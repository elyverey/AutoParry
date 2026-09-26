local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local VirtualInputManager=game:GetService("VirtualInputManager")
local CollectionService=game:GetService("CollectionService")

local localPlayer=Players.LocalPlayer
local PlayerGui=localPlayer:WaitForChild("PlayerGui")
local Chloex=loadstring(game:HttpGet("https://raw.githubusercontent.com/RillBoys/bolong.catui/refs/heads/main/b0lngUi.lua"))()

local VERSION="v4.2.0 Lite"
local ACCENT_COLOR=Color3.fromRGB(255,255,255)
local ABYSSWALKER_ANIM_ID=80411309607666

local KILLER_AIMING_ANIMS={
    -- Takeout Spear 1 / Idle Spear 1
    [75258958842388]="white",
    [96744338559260]="white",

    -- Takeout Spear 2 / Idle Spear 2
    [137846825408335]="white",
    [139928639611415]="white",

    -- Lunge Hold Spear 2 / Lunge Hold Spear 1 / OP variants
    [137688077908355]="yellow",
    [92098503722633]="yellow",
    [138045669415653]="yellow",
    [84093948968516]="yellow",

    -- Corrupt
    [117886494230451]="yellow"
}

local function Notify(title,content,delay)
    Chloex:MakeNotify({
        Title=title or "BOLONG-HUB",
        Description="Info",
        Content=content or "",
        Color=ACCENT_COLOR,
        Time=0.4,
        Delay=delay or 2
    })
end

local STATE={
    autoParryEnabled=false,
    autoParryRadiusEsp=false,
    autoParryRadius=10,
    faceKillerSensitivity=-1,
    aimStrictness=1.0,
    ignoredTheHidden=false,
    ignoredTheAbysswalker=false,
    ignoredTheMaskedDuck=false,
    lastParryTime=0,
    lastSkillParryTime=0,
    parryVisualPulseAt=0,
    parryVisualExpandAt=0,
    activeAttackers={},
    activeSkillAttackers={},
    maskedLungeArmed={},
    maskedSequence={},
    hiddenSequence={},
    killerCharacters={},
    killerAimingEnabled=false,
    heavenEyesEnabled=false
}

local MasterTasks={}

local function RegisterTask(name,interval,fn)
    MasterTasks[#MasterTasks+1]={
        name=name,
        interval=interval,
        timer=0,
        fn=fn
    }
end

local toggleAutoParryESP
local function sharedGetKillerName(player,char)
    if not player or not char then
        return nil
    end

    local values=char:FindFirstChild("Values")
    if values then
        local killerNameVal=values:FindFirstChild("KillerName")
        if killerNameVal and killerNameVal:IsA("StringValue") and killerNameVal.Value~="" then
            return killerNameVal.Value
        end
    end

    local attr=player:GetAttribute("SelectedKiller")
    if typeof(attr)=="string" and attr~="" then
        return attr
    end

    return nil
end

local function sharedIsKillerTeam(player)
    if not player or not player.Team then
        return false
    end
    local teamName=player.Team.Name
    return typeof(teamName)=="string" and teamName:lower():find("killer",1,true)~=nil
end

local function sharedHasKillerMobMarker(char)
    if not char or not char.Parent then
        return false
    end

    local direct=char:FindFirstChild("Killer-mob",true)
        or char:FindFirstChild("KillerMob",true)
        or char:FindFirstChild("killer-mob",true)
        or char:FindFirstChild("killerMob",true)

    if direct then
        return true
    end

    for _,obj in ipairs(char:GetDescendants()) do
        local n=string.lower(obj.Name or "")
        n=n:gsub("[%s_%-]","")
        if n=="killermob" then
            return true
        end
    end

    return false
end


local function sharedIsResolvedKiller(char)
    if not char or not char.Parent or char==localPlayer.Character then
        return false
    end
    local player=Players:GetPlayerFromCharacter(char)
    if player then
        if sharedGetKillerName(player,char)
        or sharedIsKillerTeam(player)
        or sharedHasKillerMobMarker(char) then
            return true
        end
    end
    local data=STATE.killerCharacters[char]
    return data~=nil and data.player==player
end


do
    local SKILL_ANIM_ID=98163597193511
    local HIDDEN_WALK_ANIM_ID=88848807662765
    local HIDDEN_WIPE_MACHETE_ID=73681849513551
    local HIDDEN_HIT_BACK_ID=121845674088602
    local HIDDEN_HIT_FRONT_ID=139830743437188
    local ABYSSWALKER_ANIM="rbxassetid://"..ABYSSWALKER_ANIM_ID
    local INSTANT_ANIM_ID="rbxassetid://"..SKILL_ANIM_ID

    local HIDDEN_ARM_TIME=0.000
    local HIDDEN_WALK_RANGE=28
    local HIDDEN_WALK_PREDICT_TIME=1.50
    local HIDDEN_SEQUENCE_TIME=3.0
    local ABYSSWALKER_RANGE=12.5

    local MASKED_MIN_LUNGE_TIME=1.680
    local MASKED_SEQUENCE_TIME=3.0
    local MASKED_LUNGEHOLD_ID=117070354890871
    local MASKED_WALK_ID=111229698330816
    local MASKED_ATTACK_ID=106871536134254
    local MASKED_ATTACKDONE_ID=109402730355822

    local MASKED_EXTRA_ANIMS={
        [MASKED_LUNGEHOLD_ID]={type="masked_lungehold",length=2.00,speed=1.00},
        [MASKED_WALK_ID]={type="maskedwalk",length=0.87,speed=1.00},
        [MASKED_ATTACK_ID]={type="maskedattack",length=3.00,speed=1.00},
        [MASKED_ATTACKDONE_ID]={type="maskedattackdone",length=2.95,speed=1.00}
    }

    local VAULT_EXTRA_RANGE=2.25
    local EDGE_TOLERANCE=1.0
    local ATTACK_TRIGGER_GRACE=0.18

    local ATTACK_PROFILES={
        [113255068724446]={type="lungehold",length=1.00,speed=1.00,triggerProgress=0.018,triggerTime=0.018},
        [74968262036854]={type="attack",length=1.70,speed=1.00,triggerProgress=0.018,triggerTime=0.030},
        [135002183282873]={type="lungehold",length=1.50,speed=1.00,triggerProgress=0.015,triggerTime=0.022},
        [121216847022485]={type="attack",length=1.75,speed=1.00,triggerProgress=0.015,triggerTime=0.025},
        [117042998468241]={type="lungehold",length=1.00,speed=1.00,triggerProgress=0.018,triggerTime=0.018},
        [133963973694098]={type="attack",length=1.72,speed=1.00,triggerProgress=0.016,triggerTime=0.025},
        [110355011987939]={type="lungehold",length=1.00,speed=1.00,triggerProgress=0.012,triggerTime=0.012},
        [139369275981139]={type="attack",length=1.72,speed=1.00,triggerProgress=0.014,triggerTime=0.022},
        [118907603246885]={type="lungehold",length=0.83,speed=1.00,triggerProgress=0.010,triggerTime=0.010},
        [78432063483146]={type="attack",length=1.72,speed=1.00,triggerProgress=0.018,triggerTime=0.025},
        [122812055447896]={type="lungehold",length=0.75,speed=1.00,triggerProgress=0.010,triggerTime=0.008},
        [78935059863801]={type="attack",length=1.63,speed=1.00,triggerProgress=0.016,triggerTime=0.022},
        [129784271201071]={type="lungehold",length=1.00,speed=1.00,triggerProgress=0.015,triggerTime=0.015},
        [132817836308238]={type="attack",length=1.72,speed=1.00,triggerProgress=0.017,triggerTime=0.025},
        [105374834496520]={type="lungehold",length=1.00,speed=1.00,triggerProgress=0.010,triggerTime=0.010},
        [111920872708571]={type="attack",length=1.72,speed=1.00,triggerProgress=0.014,triggerTime=0.022},
        [115244153053858]={type="lungehold",length=1.00,speed=1.00,triggerProgress=0.010,triggerTime=0.010},
        [130593238885843]={type="attack",length=1.70,speed=1.00,triggerProgress=0.012,triggerTime=0.020},
        [138720291317243]={type="attack",length=1.72,speed=1.00,triggerProgress=0.12,triggerTime=0.12},
        [HIDDEN_WIPE_MACHETE_ID]={type="attack",length=2.48,speed=1.00,triggerProgress=0.018,triggerTime=0.025,faceRequired=true}
    }

    local function getAnimNumericId(animId)
        if typeof(animId)~="string" then
            return nil
        end

        return tonumber(animId:match("%d+"))
    end

    local function getKillerName(player,char)
        if not player or not char then
            return nil
        end

        local values=char:FindFirstChild("Values")

        if values then
            local killerNameVal=values:FindFirstChild("KillerName")

            if killerNameVal and killerNameVal:IsA("StringValue") and killerNameVal.Value~="" then
                return killerNameVal.Value
            end
        end

        local attr=player:GetAttribute("SelectedKiller")

        if typeof(attr)=="string" and attr~="" then
            return attr
        end

        return nil
    end

    local function isKillerTeam(player)
        if not player then
            return false
        end

        local team=player.Team

        if not team then
            return false
        end

        local teamName=team.Name

        if typeof(teamName)~="string" then
            return false
        end

        return teamName:lower():find("killer")~=nil
    end

    local function hasKillerMobMarker(char)
        if not char or not char.Parent then
            return false
        end

        local direct=char:FindFirstChild("Killer-mob",true)
            or char:FindFirstChild("KillerMob",true)
            or char:FindFirstChild("killer-mob",true)
            or char:FindFirstChild("killerMob",true)

        if direct then
            return true
        end

        for _,obj in ipairs(char:GetDescendants()) do
            local n=string.lower(obj.Name or "")
            n=n:gsub("[%s_%-]","")
            if n=="killermob" then
                return true
            end
        end

        return false
    end

    local cachedParryButton=nil

    local function getParryButton()
        if cachedParryButton and cachedParryButton.Parent and cachedParryButton:IsA("ImageButton") then
            return cachedParryButton
        end

        local mobGui=PlayerGui:FindFirstChild("Survivor-mob")
        local controls=mobGui and mobGui:FindFirstChild("Controls")
        local btn=controls and controls:FindFirstChild("Gui-mob")

        if btn and btn:IsA("ImageButton") then
            cachedParryButton=btn
            return btn
        end

        cachedParryButton=nil
        return nil
    end

    local function sendParryInput()
        local char=localPlayer.Character
        if not char then
            return
        end

        local btn=getParryButton()

        if btn then
            firesignal(btn.MouseButton1Down)
            firesignal(btn.MouseButton1Up)
        else
            -- Avoid getconnections()/InputBegan fan-out here because that can cause
            -- a one-frame hitch exactly when the first parry is sent.
            pcall(function()
                VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.F,false,game)
                VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.F,false,game)
            end)
        end

        local root=char:FindFirstChild("HumanoidRootPart")
        if root then
            pcall(function()
                if CollectionService:HasTag(root,"doing action") then
                    CollectionService:RemoveTag(root,"doing action")
                end
            end)
        end
    end

    local PARRY_COOLDOWN=60.0

    local function parryInputAvailable(now)
        -- One shared 60-second lockout for every parry source.
        -- The visual ring and the actual input use the exact same cooldown.
        local lastParry=math.max(
            STATE.lastParryTime or 0,
            STATE.lastSkillParryTime or 0
        )

        if lastParry>0 and now-lastParry<PARRY_COOLDOWN then
            return false
        end

        return true
    end

    local function getPalletModelFromPart(part)
        if not part then
            return nil
        end

        local current=part
        for _=1,6 do
            if not current then
                break
            end

            local name=string.lower(current.Name or "")
            if name:find("pallet",1,true) or name:find("plank",1,true) then
                if current:IsA("Model") then
                    return current
                end

                local parent=current.Parent
                if parent and parent:IsA("Model") then
                    return parent
                end
            end

            current=current.Parent
        end

        return nil
    end

    local function isStandingPallet(model)
        if not model or not model.Parent then
            return false
        end

        local ok,_,size=pcall(function()
            local cf,bounds=model:GetBoundingBox()
            return cf,bounds
        end)

        if not ok or not size then
            return false
        end

        -- A dropped pallet is substantially flatter on Y.
        -- A standing pallet has a tall vertical bounding box.
        local horizontal=math.max(size.X,size.Z,0.01)
        return size.Y>=horizontal*0.50
    end

    local function getPalletContext(hitPart)
        local model=getPalletModelFromPart(hitPart)
        if not model then
            return nil
        end

        return {
            model=model,
            standing=isStandingPallet(model),
            dropped=not isStandingPallet(model)
        }
    end

    local function getObstacleState(origin,target,extraIgnore)
        local localChar=localPlayer.Character
        local params=RaycastParams.new()
        params.FilterType=Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances={localChar,extraIgnore}
        params.IgnoreWater=true

        local direction=target-origin

        if direction.Magnitude<=0.05 then
            return {
                clear=true,
                blocked=false,
                vault=false,
                pallet=false,
                standingPallet=false,
                droppedPallet=false,
                clearCount=1,
                blockedCount=0,
                directBlocked=false
            }
        end

        local flat=Vector3.new(direction.X,0,direction.Z)
        local flatUnit=flat.Magnitude>0.05 and flat.Unit or Vector3.zero
        local right=flatUnit:Cross(Vector3.new(0,1,0))

        -- Only sample the actual body corridor.  The old +/- 1 stud edge rays
        -- could "see around" a wall/window/pallet and incorrectly authorize a
        -- parry when the killer was actually on the opposite side.
        local sideOffset=0.38
        local verticalOffset=0.55
        local rayData={
            {origin,target,true},
            {origin+right*sideOffset,target+right*sideOffset,false},
            {origin-right*sideOffset,target-right*sideOffset,false},
            {origin+Vector3.new(0,verticalOffset,0),target+Vector3.new(0,verticalOffset,0),false},
            {origin-Vector3.new(0,verticalOffset,0),target-Vector3.new(0,verticalOffset,0),false},
        }

        local localHead=localChar and localChar:FindFirstChild("Head")
        local killerHead=extraIgnore and extraIgnore:FindFirstChild("Head")
        if localHead and killerHead then
            table.insert(rayData,{localHead.Position,killerHead.Position,false})
        end

        local clearCount=0
        local blockedCount=0
        local vaultHit=false
        local palletHit=false
        local standingPalletHit=false
        local droppedPalletHit=false
        local palletBlockedCount=0
        local directBlocked=false

        for _,pair in ipairs(rayData) do
            local result=Workspace:Raycast(pair[1],pair[2]-pair[1],params)

            if not result then
                clearCount=clearCount+1
            else
                blockedCount=blockedCount+1
                if pair[3] then
                    directBlocked=true
                end

                local hit=result.Instance
                if hit then
                    local n=string.lower(hit.Name or "")

                    if n:find("vault",1,true)
                    or n:find("window",1,true)
                    or n:find("ledge",1,true) then
                        vaultHit=true
                    end

                    if n:find("pallet",1,true)
                    or n:find("plank",1,true) then
                        palletHit=true
                        palletBlockedCount=palletBlockedCount+1

                        local pallet=getPalletContext(hit)
                        if pallet then
                            if pallet.standing then
                                standingPalletHit=true
                            else
                                droppedPalletHit=true
                            end
                        end
                    end
                end
            end
        end

        local sampleCount=#rayData
        -- Require a real majority of the body corridor to be clear.  A single
        -- edge ray cannot bypass a solid wall anymore.
        local clear=clearCount>=math.max(4,math.ceil(sampleCount*0.66))
        local blocked=blockedCount>=math.ceil(sampleCount*0.50)

        return {
            clear=clear,
            blocked=blocked,
            vault=vaultHit,
            pallet=palletHit,
            standingPallet=standingPalletHit,
            droppedPallet=droppedPalletHit,
            palletBlockedCount=palletBlockedCount,
            clearCount=clearCount,
            blockedCount=blockedCount,
            directBlocked=directBlocked
        }
    end

    local function doParry(force,killerChar,distance,allowPredictedRange,allowEdgePulse)
        if not STATE.autoParryEnabled then
            return false
        end

        local now=tick()

        if not parryInputAvailable(now) then
            return false
        end

        if killerChar and distance then
            local allowedRange=STATE.autoParryRadius
            local allowVault=false
            local data=STATE.activeAttackers[killerChar]

            if data and data.profile and data.profile.type=="lungehold" then
                allowVault=true
            end

            if distance>allowedRange and not allowPredictedRange then
                return false
            end

            local localChar=localPlayer.Character
            local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")
            local killerRoot=killerChar:FindFirstChild("HumanoidRootPart")

            if not localRoot or not killerRoot then
                return false
            end

            -- Pallet-specific side handling:
            -- * standing pallet: allow the parry when the attack is reaching the
            --   player through/around the standing pallet;
            -- * dropped pallet: if it is actually separating both characters
            --   (most sampled rays are blocked), do not parry from the far side.
            --
            -- The multi-ray test deliberately keeps edge rays, so an attack that
            -- clips an object's corner can still be detected instead of being
            -- rejected just because the center ray is blocked.
            local obstacle=getObstacleState(
                localRoot.Position,
                killerRoot.Position,
                killerChar
            )

            -- A killer on the opposite side of a solid wall/window/pallet must
            -- not be able to trigger parry merely because an edge ray is clear.
            -- The obstacle test is intentionally shared by every normal parry
            -- path, including predicted-range/lunge paths.
            local edgePulseAllowed=false
            if allowEdgePulse and not obstacle.directBlocked then
                -- Edge/corner pulse may accept a partially obstructed corridor,
                -- but never a fully blocked/direct wall hit.
                edgePulseAllowed=(
                    obstacle.clearCount>=2
                    and obstacle.blockedCount>=1
                    and obstacle.blockedCount<math.ceil(6*0.75)
                )
            end

            if obstacle.directBlocked then
                return false
            end

            if (obstacle.blocked or not obstacle.clear) and not edgePulseAllowed then
                return false
            end
        end

        STATE.lastParryTime=now
        STATE.lastSkillParryTime=now
        STATE.parryVisualPulseAt=now
        STATE.parryVisualExpandAt=0
        sendParryInput()

        return true
    end

    local function doSkillParry()
        if not STATE.autoParryEnabled then
            return false
        end

        local now=tick()

        if not parryInputAvailable(now) then
            return false
        end

        STATE.lastSkillParryTime=now
        STATE.lastParryTime=now
        STATE.parryVisualPulseAt=now
        STATE.parryVisualExpandAt=0
        sendParryInput()

        return true
    end

    local function isIgnoredSkillKiller(killerName)
        if typeof(killerName)~="string" then
            return false
        end

        local name=killerName:lower()

        if name=="the hidden" then
            return STATE.ignoredTheHidden
        elseif name=="the abysswalker" then
            return STATE.ignoredTheAbysswalker
        elseif name=="the masked (duck)" or name=="the masked" then
            return STATE.ignoredTheMaskedDuck
        end

        return false
    end

    local function getSkillDistance(char)
        local localChar=localPlayer.Character
        local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")
        local killerRoot=char and char:FindFirstChild("HumanoidRootPart")

        if not localRoot or not killerRoot then
            return math.huge
        end

        local a=localRoot.Position
        local b=killerRoot.Position

        return (Vector3.new(a.X,0,a.Z)-Vector3.new(b.X,0,b.Z)).Magnitude
    end

    local function getPredictedDistance(char,maxTime)
        local localChar=localPlayer.Character
        local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")
        local killerRoot=char and char:FindFirstChild("HumanoidRootPart")

        if not localRoot or not killerRoot then
            return math.huge
        end

        local localPosition=localRoot.Position
        local killerPosition=killerRoot.Position

        local localVelocity=localRoot.AssemblyLinearVelocity
        local killerVelocity=killerRoot.AssemblyLinearVelocity

        local localFlatVelocity=Vector3.new(localVelocity.X,0,localVelocity.Z)
        local killerFlatVelocity=Vector3.new(killerVelocity.X,0,killerVelocity.Z)

        local ping=math.clamp(localPlayer:GetNetworkPing(),0,0.3)
        local baseTime=ping+0.04
        local bestDistance=math.huge

        local samples={
            math.clamp(baseTime,0,maxTime),
            math.clamp(baseTime+0.05,0,maxTime),
            math.clamp(baseTime+0.10,0,maxTime),
            math.clamp(baseTime+0.16,0,maxTime),
            math.clamp(baseTime+0.22,0,maxTime),
            math.clamp(baseTime+0.30,0,maxTime),
            math.clamp(baseTime+0.38,0,maxTime)
        }

        for _,predictionTime in ipairs(samples) do
            local predictedLocal=localPosition+localFlatVelocity*predictionTime
            local predictedKiller=killerPosition+killerFlatVelocity*predictionTime

            local predictedDistance=(
                Vector3.new(predictedLocal.X,0,predictedLocal.Z)-
                Vector3.new(predictedKiller.X,0,predictedKiller.Z)
            ).Magnitude

            if predictedDistance<bestDistance then
                bestDistance=predictedDistance
            end
        end

        return bestDistance
    end

    local function getMaskedDirectionalPrediction(char)
        local localChar=localPlayer.Character
        local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")
        local killerRoot=char and char:FindFirstChild("HumanoidRootPart")

        if not localRoot or not killerRoot then
            return math.huge
        end

        local localPosition=localRoot.Position
        local killerPosition=killerRoot.Position

        local localVelocity=localRoot.AssemblyLinearVelocity
        local killerVelocity=killerRoot.AssemblyLinearVelocity

        local localFlat=Vector3.new(localVelocity.X,0,localVelocity.Z)
        local killerFlat=Vector3.new(killerVelocity.X,0,killerVelocity.Z)

        local killerLook=killerRoot.CFrame.LookVector
        local killerLookFlat=Vector3.new(killerLook.X,0,killerLook.Z)

        if killerLookFlat.Magnitude>0.05 then
            killerLookFlat=killerLookFlat.Unit
        else
            killerLookFlat=Vector3.zero
        end

        local killerSpeed=killerFlat.Magnitude

        if killerSpeed>0.05 and killerLookFlat.Magnitude>0 then
            local forwardSpeed=killerFlat:Dot(killerLookFlat)

            if forwardSpeed>0 then
                killerFlat=killerFlat+killerLookFlat*math.min(forwardSpeed*0.45,6)
            end
        end

        local relative=killerPosition-localPosition
        local relativeFlat=Vector3.new(relative.X,0,relative.Z)
        local distance=relativeFlat.Magnitude

        if distance<=0.05 then
            return 0
        end

        local direction=relativeFlat.Unit
        local relativeVelocity=killerFlat-localFlat
        local closingSpeed=math.max(0,relativeVelocity:Dot(direction))

        local ping=math.clamp(localPlayer:GetNetworkPing(),0,0.3)
        local base=ping+0.025
        local best=distance

        local samples={
            base,
            base+0.02,
            base+0.04,
            base+0.07,
            base+0.10,
            base+0.14,
            base+0.19,
            base+0.25,
            base+0.32,
            base+0.40,
            base+0.50,
            base+0.60
        }

        for _,t in ipairs(samples) do
            local pLocal=localPosition+localFlat*t
            local pKiller=killerPosition+killerFlat*t

            local d=(Vector3.new(pLocal.X,0,pLocal.Z)-Vector3.new(pKiller.X,0,pKiller.Z)).Magnitude

            if d<best then
                best=d
            end
        end

        if closingSpeed>0 then
            local impactTime=math.max(distance-STATE.autoParryRadius,0)/closingSpeed

            if impactTime<=0.55 then
                best=math.min(best,STATE.autoParryRadius-0.05)
            end
        end

        return best
    end

    local function getFaceKillerThreshold()
        -- Face Killer Sensitivity ranges from -1 to 1.
        -- -1 = most forgiving, 1 = most strict.
        local sensitivity=math.clamp(STATE.faceKillerSensitivity,-1,1)

        -- Keep the threshold usable even at 1.0 so normal parry is never
        -- disabled just because the slider is at its maximum.
        return 0.10+((sensitivity+1)/2)*0.55
    end

    local function isFacingLocalPlayer(killerChar)
        local localChar=localPlayer.Character
        local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")
        local killerRoot=killerChar and killerChar:FindFirstChild("HumanoidRootPart")

        if not localRoot or not killerRoot then
            return false
        end

        local direction=localRoot.Position-killerRoot.Position
        local flatDirection=Vector3.new(direction.X,0,direction.Z)

        if flatDirection.Magnitude<=0.05 then
            return true
        end

        local look=killerRoot.CFrame.LookVector
        local flatLook=Vector3.new(look.X,0,look.Z)

        if flatLook.Magnitude<=0.05 then
            return true
        end

        local dot=flatLook.Unit:Dot(flatDirection.Unit)
        local threshold=getFaceKillerThreshold()

        -- -1 = forgiving, 1 = strict, but never impossible.
        local sensitivity=math.clamp(STATE.faceKillerSensitivity,-1,1)
        local strictPercent=(sensitivity+1)/2
        local allowedAngle=80-(strictPercent*42)
        local aimThreshold=math.cos(math.rad(allowedAngle))

        if dot>=math.max(threshold,aimThreshold) then
            return true
        end

        -- Moving directly toward the player is still treated as a valid
        -- attack approach, including when sensitivity is set to 1.0.
        local velocity=killerRoot.AssemblyLinearVelocity
        local flatVelocity=Vector3.new(velocity.X,0,velocity.Z)

        if flatVelocity.Magnitude>6 then
            local velocityDot=flatVelocity.Unit:Dot(flatDirection.Unit)
            local velocityThreshold=0.20+(strictPercent*0.35)

            if velocityDot>=velocityThreshold then
                return true
            end
        end

        return false
    end

    local function canNormalAttackParry(killerChar,distance,closingSpeed,predictedDistance)
        if distance>STATE.autoParryRadius then
            return false
        end

        -- At maximum sensitivity, an actual closing attack inside the
        -- predicted parry radius must still be allowed to parry.
        if closingSpeed and predictedDistance then
            if closingSpeed>=3.5 and predictedDistance<=STATE.autoParryRadius then
                return true
            end
        end

        if isFacingLocalPlayer(killerChar) then
            return true
        end

        local localChar=localPlayer.Character
        local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")
        local killerRoot=killerChar and killerChar:FindFirstChild("HumanoidRootPart")

        if not localRoot or not killerRoot then
            return false
        end

        local direction=localRoot.Position-killerRoot.Position
        local flatDirection=Vector3.new(direction.X,0,direction.Z)

        if flatDirection.Magnitude<=2.0 then
            return true
        end

        return false
    end

    local function getHiddenWalkTracks(char)
        local tracks={}
        local humanoid=char and char:FindFirstChildOfClass("Humanoid")
        local animator=humanoid and humanoid:FindFirstChildOfClass("Animator")

        if not animator then
            return tracks
        end

        for _,track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track and track.IsPlaying and track.Animation then
                local id=getAnimNumericId(track.Animation.AnimationId)

                if id==HIDDEN_WALK_ANIM_ID then
                    tracks[track]=true
                end
            end
        end

        return tracks
    end

    local function clearHiddenSequence(char)
        STATE.hiddenSequence[char]=nil
    end

    local function getHiddenPredictedDistance(char,maxTime)
        local localChar=localPlayer.Character
        local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")
        local killerRoot=char and char:FindFirstChild("HumanoidRootPart")

        if not localRoot or not killerRoot then
            return math.huge
        end

        local localPosition=localRoot.Position
        local killerPosition=killerRoot.Position

        local localVelocity=localRoot.AssemblyLinearVelocity
        local killerVelocity=killerRoot.AssemblyLinearVelocity

        local localFlatVelocity=Vector3.new(localVelocity.X,0,localVelocity.Z)
        local killerFlatVelocity=Vector3.new(killerVelocity.X,0,killerVelocity.Z)

        local ping=math.clamp(localPlayer:GetNetworkPing(),0,0.3)
        local baseTime=ping+0.025
        local samples={
            0,
            math.clamp(baseTime,0,maxTime),
            math.clamp(baseTime+0.08,0,maxTime),
            math.clamp(baseTime+0.16,0,maxTime),
            math.clamp(baseTime+0.28,0,maxTime),
            math.clamp(baseTime+0.40,0,maxTime),
            math.clamp(baseTime+0.55,0,maxTime),
            math.clamp(baseTime+0.75,0,maxTime),
            math.clamp(baseTime+1.00,0,maxTime),
            math.clamp(baseTime+1.25,0,maxTime),
            math.clamp(baseTime+1.50,0,maxTime)
        }

        local bestDistance=math.huge

        for _,predictionTime in ipairs(samples) do
            local predictedLocal=localPosition+localFlatVelocity*predictionTime
            local predictedKiller=killerPosition+killerFlatVelocity*predictionTime

            local predictedDistance=(
                Vector3.new(predictedLocal.X,0,predictedLocal.Z)-
                Vector3.new(predictedKiller.X,0,predictedKiller.Z)
            ).Magnitude

            if predictedDistance<bestDistance then
                bestDistance=predictedDistance
            end
        end

        return bestDistance
    end

    local function hiddenIsWalkComingFromFront(char)
        if not char or not char.Parent then
            return false
        end

        local head=char:FindFirstChild("Head")
        local localChar=localPlayer.Character
        local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")

        if not head or not localRoot then
            return false
        end

        local direction=localRoot.Position-head.Position
        local flatDirection=Vector3.new(direction.X,0,direction.Z)

        if flatDirection.Magnitude<=0.05 then
            return true
        end

        local look=head.CFrame.LookVector
        local flatLook=Vector3.new(look.X,0,look.Z)

        if flatLook.Magnitude<=0.05 then
            return true
        end

        return flatLook.Unit:Dot(flatDirection.Unit)>=0
    end

    local function hiddenCanParry(char,seq)
        if not char or not char.Parent or not seq then
            return false
        end

        if STATE.ignoredTheHidden or seq.consumed then
            return false
        end

        if not seq.skillTrack or not seq.skillTrack.IsPlaying then
            return false
        end

        if tick()>seq.expires then
            return false
        end

        local distance=getSkillDistance(char)
        local predictedDistance=getHiddenPredictedDistance(
            char,
            HIDDEN_WALK_PREDICT_TIME
        )

        if distance>HIDDEN_WALK_RANGE
        and predictedDistance>HIDDEN_WALK_RANGE then
            return false
        end

        if hiddenIsWalkComingFromFront(char) then
            return true
        end

        local head=char:FindFirstChild("Head")
        local localChar=localPlayer.Character
        local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")
        local killerRoot=char:FindFirstChild("HumanoidRootPart")

        if not head or not localRoot or not killerRoot then
            return false
        end

        local targetDirection=Vector3.new(
            localRoot.Position.X-killerRoot.Position.X,
            0,
            localRoot.Position.Z-killerRoot.Position.Z
        )

        local velocity=killerRoot.AssemblyLinearVelocity
        local flatVelocity=Vector3.new(velocity.X,0,velocity.Z)

        if targetDirection.Magnitude>0.05
        and flatVelocity.Magnitude>=4 then
            local velocityDot=flatVelocity.Unit:Dot(targetDirection.Unit)

            if velocityDot>=0.15 then
                return true
            end
        end

        return false
    end

    local function hiddenTryWalkParry(char,seq)
        if not seq or seq.consumed then
            return false
        end

        if not hiddenCanParry(char,seq) then
            return false
        end

        if doSkillParry() then
            seq.consumed=true
            seq.parried=true
            clearHiddenSequence(char)
            return true
        end

        return false
    end

    local function registerHiddenWalk(char,track)
        if STATE.ignoredTheHidden then
            return
        end

        local seq=STATE.hiddenSequence[char]

        if not seq or seq.consumed then
            return
        end

        if not seq.skillTrack or not seq.skillTrack.IsPlaying then
            return
        end

        if tick()>seq.expires then
            clearHiddenSequence(char)
            return
        end

        seq.walkTracks=seq.walkTracks or {}

        if seq.walkTracks[track] then
            return
        end

        seq.walkTracks[track]=true
        seq.walkTrack=track
        seq.walkSeen=true

        hiddenTryWalkParry(char,seq)
    end

    local function registerHiddenHit(char,track)
        if STATE.ignoredTheHidden or not char or not char.Parent then
            return false
        end

        local seq=STATE.hiddenSequence[char]

        if not seq or seq.consumed then
            return false
        end

        if not seq.skillTrack or not seq.skillTrack.IsPlaying then
            return false
        end

        seq.hitTracks=seq.hitTracks or {}

        if seq.hitTracks[track] then
            return false
        end

        seq.hitTracks[track]=true
        seq.hitTrack=track

        return hiddenTryWalkParry(char,seq)
    end

    local function getHiddenHitTracks(char)
        local tracks={}
        local humanoid=char and char:FindFirstChildOfClass("Humanoid")
        local animator=humanoid and humanoid:FindFirstChildOfClass("Animator")

        if not animator then
            return tracks
        end

        for _,track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track and track.IsPlaying and track.Animation then
                local id=getAnimNumericId(track.Animation.AnimationId)

                if id==HIDDEN_HIT_BACK_ID
                or id==HIDDEN_HIT_FRONT_ID then
                    tracks[track]=true
                end
            end
        end

        return tracks
    end

    local function getHiddenSkillTracks(char)
        local tracks={}
        local humanoid=char and char:FindFirstChildOfClass("Humanoid")
        local animator=humanoid and humanoid:FindFirstChildOfClass("Animator")

        if not animator then
            return tracks
        end

        for _,track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track and track.IsPlaying and track.Animation then
                local id=getAnimNumericId(track.Animation.AnimationId)

                if id==SKILL_ANIM_ID then
                    tracks[track]=true
                end
            end
        end

        return tracks
    end

    local function hiddenTrySkillParry(char,seq)
        if not seq or seq.consumed then
            return false
        end

        if not hiddenCanParry(char,seq) then
            return false
        end

        if doSkillParry() then
            seq.consumed=true
            seq.parried=true
            clearHiddenSequence(char)
            return true
        end

        return false
    end

    local function registerSkillAttack(char,kName,track)
        if not sharedIsResolvedKiller(char) then
            return
        end

        local resolvedName=kName
        local known=STATE.killerCharacters[char]
        if (typeof(resolvedName)~="string" or resolvedName==""
            or resolvedName:lower()=="unknown killer")
            and known and typeof(known.name)=="string"
            and known.name~="" then
            resolvedName=known.name
        end

        if isIgnoredSkillKiller(resolvedName) then
            return
        end

        local now=tick()
        local oldSeq=STATE.hiddenSequence[char]

        if oldSeq and oldSeq.skillTrack==track then
            return
        end

        local seq={
            name=kName,
            skillTrack=track,
            skillStarted=now,
            skillFinished=false,
            skillLongEnough=false,
            finishedAt=nil,
            lastSkillPosition=track.TimePosition or 0,
            armTime=0,
            armed=false,
            walkTrack=nil,
            walkSeen=false,
            walkTracks={},
            hitTrack=nil,
            hitTracks={},
            consumed=false,
            parried=false,
            expires=now+HIDDEN_SEQUENCE_TIME
        }

        STATE.hiddenSequence[char]=seq

        -- The Hidden: animation 981 triggers Parry immediately.
        -- Do not wait for distance, direction, arm time, walk animation, or hit animation.
        if doSkillParry() then
            seq.consumed=true
            seq.parried=true
            clearHiddenSequence(char)
            return
        end

        if not STATE.hiddenSequence[char] then
            return
        end

        local currentWalkTracks=getHiddenWalkTracks(char)

        for walkTrack in pairs(currentWalkTracks) do
            registerHiddenWalk(char,walkTrack)

            if not STATE.hiddenSequence[char] then
                return
            end
        end

        local currentHitTracks=getHiddenHitTracks(char)

        for hitTrack in pairs(currentHitTracks) do
            registerHiddenHit(char,hitTrack)

            if not STATE.hiddenSequence[char] then
                return
            end
        end

        local conn

        conn=track.Stopped:Connect(function()
            if conn then
                conn:Disconnect()
                conn=nil
            end

            task.defer(function()
                local current=STATE.hiddenSequence[char]

                if not current or current~=seq or current.consumed then
                    return
                end

                local finalPosition=track.TimePosition or 0
                current.armTime=math.max(current.armTime,finalPosition)

                if not current.armed and current.armTime>=HIDDEN_ARM_TIME then
                    current.armed=true
                end

                if not current.armed then
                    clearHiddenSequence(char)
                    return
                end

                current.skillFinished=true
                current.finishedAt=tick()
                current.expires=tick()+HIDDEN_SEQUENCE_TIME

                local currentWalkTracks=getHiddenWalkTracks(char)

                for walkTrack in pairs(currentWalkTracks) do
                    registerHiddenWalk(char,walkTrack)

                    if not STATE.hiddenSequence[char] then
                        break
                    end
                end
            end)
        end)
    end

    local function hiddenHeartbeatMonitor()
        if not STATE.autoParryEnabled then
            return
        end

        -- Recover the exact The Hidden skill trigger if AnimationPlayed was
        -- missed during a frame spike. The exact animation ID is required and
        -- the character must be confirmed by the shared Killer resolver.
        for char,data in pairs(STATE.killerCharacters) do
            if char and char.Parent and sharedIsResolvedKiller(char) then
                local humanoid=char:FindFirstChildOfClass("Humanoid")
                local animator=humanoid and humanoid:FindFirstChildOfClass("Animator")
                if animator then
                    for _,track in ipairs(animator:GetPlayingAnimationTracks()) do
                        if track and track.IsPlaying and track.Animation then
                            local id=getAnimNumericId(track.Animation.AnimationId)
                            if id==SKILL_ANIM_ID then
                                registerSkillAttack(char,(data and data.name) or "The Hidden",track)
                            end
                        end
                    end
                end
            end
        end

        for killerChar,seq in pairs(STATE.hiddenSequence) do
            if not killerChar or not killerChar.Parent or not seq then
                clearHiddenSequence(killerChar)
            elseif seq.consumed then
                clearHiddenSequence(killerChar)
            elseif tick()>seq.expires then
                clearHiddenSequence(killerChar)
            elseif not seq.skillTrack or not seq.skillTrack.IsPlaying then
                clearHiddenSequence(killerChar)
            else
                local currentPosition=seq.skillTrack.TimePosition or 0

                if seq.lastSkillPosition
                and currentPosition+0.10<seq.lastSkillPosition then
                    seq.walkTracks={}
                    seq.walkTrack=nil
                    seq.walkSeen=false
                    seq.hitTracks={}
                    seq.hitTrack=nil
                    seq.consumed=false
                    seq.parried=false
                    seq.armed=false
                    seq.armTime=0
                    seq.skillFinished=false
                    seq.finishedAt=nil
                    seq.skillStarted=tick()
                    seq.expires=tick()+HIDDEN_SEQUENCE_TIME

                    hiddenTrySkillParry(killerChar,seq)
                end

                if STATE.hiddenSequence[killerChar] then
                    seq.lastSkillPosition=currentPosition
                end

                local currentWalkTracks=getHiddenWalkTracks(killerChar)

                for walkTrack in pairs(currentWalkTracks) do
                    registerHiddenWalk(killerChar,walkTrack)

                    if not STATE.hiddenSequence[killerChar] then
                        break
                    end
                end

                if STATE.hiddenSequence[killerChar] then
                    local currentHitTracks=getHiddenHitTracks(killerChar)

                    for hitTrack in pairs(currentHitTracks) do
                        registerHiddenHit(killerChar,hitTrack)

                        if not STATE.hiddenSequence[killerChar] then
                            break
                        end
                    end
                end
            end
        end

        for killerChar,killerData in pairs(STATE.killerCharacters) do
            if killerChar and killerChar.Parent
            and typeof(killerData.name)=="string"
            and killerData.name:lower()=="the hidden" then

                local skillTracks=getHiddenSkillTracks(killerChar)

                for skillTrack in pairs(skillTracks) do
                    local current=STATE.hiddenSequence[killerChar]

                    if not current
                    or current.skillTrack~=skillTrack then
                        registerSkillAttack(
                            killerChar,
                            killerData.name,
                            skillTrack
                        )
                    end

                    if STATE.hiddenSequence[killerChar] then
                        local seqNow=STATE.hiddenSequence[killerChar]
                        seqNow.lastSkillPosition=skillTrack.TimePosition or 0

                        hiddenTrySkillParry(killerChar,seqNow)

                        if not STATE.hiddenSequence[killerChar] then
                            break
                        end

                        local walkTracks=getHiddenWalkTracks(killerChar)

                        for walkTrack in pairs(walkTracks) do
                            registerHiddenWalk(killerChar,walkTrack)

                            if not STATE.hiddenSequence[killerChar] then
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    local function registerAbysswalkerAttack(char,kName,track)
        if STATE.ignoredTheAbysswalker then
            return
        end

        local data={
            name=kName or "The Abysswalker",
            track=track,
            type="abysswalker",
            started=tick(),
            consumed=false,
            skillId=ABYSSWALKER_ANIM_ID
        }

        STATE.activeSkillAttackers[char]=data

        local conn

        conn=track.Stopped:Connect(function()
            if conn then
                conn:Disconnect()
                conn=nil
            end

            task.defer(function()
                if STATE.activeSkillAttackers[char]
                and STATE.activeSkillAttackers[char].track==track then
                    STATE.activeSkillAttackers[char]=nil
                end
            end)
        end)

        local distance=getSkillDistance(char)

        if distance<=ABYSSWALKER_RANGE then
            if doSkillParry() then
                data.consumed=true
            end
        end
    end

    local function getMaskedWalkTracks(char)
        local tracks={}
        local humanoid=char and char:FindFirstChildOfClass("Humanoid")
        local animator=humanoid and humanoid:FindFirstChildOfClass("Animator")

        if not animator then
            return tracks
        end

        for _,track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track and track.IsPlaying and track.Animation then
                local id=getAnimNumericId(track.Animation.AnimationId)

                if id==MASKED_WALK_ID then
                    tracks[track]=true
                end
            end
        end

        return tracks
    end

    local function clearMaskedSequence(char)
        STATE.maskedSequence[char]=nil
        STATE.maskedLungeArmed[char]=nil
    end

    local function getMaskedPredictedDistance(char)
        return getMaskedDirectionalPrediction(char)
    end

    local function maskedCanParryNow(char,seq)
        if not char or not char.Parent or not seq then
            return false
        end

        if STATE.ignoredTheMaskedDuck
        or seq.consumed
        or not seq.lungeReachedMinTime
        or not seq.lungeFinished
        or not seq.walkSeen then
            return false
        end

        local distance=getSkillDistance(char)

        if distance<=STATE.autoParryRadius then
            return true
        end

        local predictedDistance=getMaskedPredictedDistance(char)

        if predictedDistance<=STATE.autoParryRadius then
            return true
        end

        local localChar=localPlayer.Character
        local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")
        local killerRoot=char and char:FindFirstChild("HumanoidRootPart")

        if localRoot and killerRoot then
            local relative=killerRoot.Position-localRoot.Position
            local relativeFlat=Vector3.new(relative.X,0,relative.Z)

            if relativeFlat.Magnitude>0.05 then
                local localVelocity=localRoot.AssemblyLinearVelocity
                local killerVelocity=killerRoot.AssemblyLinearVelocity

                local relativeVelocity=Vector3.new(
                    killerVelocity.X-localVelocity.X,
                    0,
                    killerVelocity.Z-localVelocity.Z
                )

                local closingSpeed=math.max(0,relativeVelocity:Dot(relativeFlat.Unit))

                if closingSpeed>=3 then
                    local timeToRadius=math.max(distance-STATE.autoParryRadius,0)/closingSpeed

                    if timeToRadius<=0.25 then
                        return true
                    end
                end
            end
        end

        return false
    end

    local function maskedTryLungeParry(char,seq)
        if not char or not char.Parent or not seq then
            return false
        end

        if STATE.ignoredTheMaskedDuck
        or seq.consumed
        or not seq.lungeReachedMinTime then
            return false
        end

        local distance=getSkillDistance(char)
        local predictedDistance=getMaskedPredictedDistance(char)

        if distance<=STATE.autoParryRadius then
            if doParry(true,char,distance) then
                seq.consumed=true
                seq.parried=true
                clearMaskedSequence(char)
                return true
            end

            return false
        end

        if predictedDistance<=STATE.autoParryRadius then
            if doParry(true,char,distance,true) then
                seq.consumed=true
                seq.parried=true
                clearMaskedSequence(char)
                return true
            end
        end

        return false
    end

    local function maskedTryWalkParry(char,seq)
        if not seq
        or seq.consumed
        or not seq.lungeReachedMinTime
        or not seq.lungeFinished
        or not seq.walkSeen then
            return false
        end

        if not maskedCanParryNow(char,seq) then
            return false
        end

        local distance=getSkillDistance(char)

        if distance<=STATE.autoParryRadius then
            if doParry(true,char,distance) then
                seq.consumed=true
                seq.parried=true
                clearMaskedSequence(char)
                return true
            end
        else
            local predictedDistance=getMaskedPredictedDistance(char)

            if predictedDistance<=STATE.autoParryRadius then
                if doParry(true,char,distance,true) then
                    seq.consumed=true
                    seq.parried=true
                    clearMaskedSequence(char)
                    return true
                end
            end
        end

        return false
    end

    local function maskedWalkIsNew(seq,track)
        if not seq or not track or seq.consumed then
            return false
        end

        if seq.acceptedWalkTracks and seq.acceptedWalkTracks[track] then
            return false
        end

        if seq.lungeTrack==track then
            return false
        end

        return true
    end

    local function registerMaskedWalkPreparation(char,seq,track)
        if not seq or seq.consumed or not track then
            return false
        end

        if not maskedWalkIsNew(seq,track) then
            return false
        end

        if tick()>seq.expires then
            return false
        end

        if not seq.lungeReachedMinTime or not seq.lungeFinished then
            seq.pendingWalkTrack=track
            return false
        end

        seq.acceptedWalkTracks=seq.acceptedWalkTracks or {}
        seq.acceptedWalkTracks[track]=true
        seq.walkTrack=track
        seq.walkStarted=tick()
        seq.walkSeen=true
        seq.prepared=true

        maskedTryWalkParry(char,seq)

        return true
    end

    local function registerMaskedFastAttack(char,kName,track,profile,animId)
        if STATE.ignoredTheMaskedDuck then
            return
        end

        local numericId=typeof(animId)=="number"
            and animId
            or getAnimNumericId(track.Animation and track.Animation.AnimationId)

        if not numericId then
            return
        end

        if numericId==MASKED_LUNGEHOLD_ID then
            local now=tick()
            local actualLength=track.Length

            if not actualLength or actualLength<=0 then
                actualLength=MASKED_EXTRA_ANIMS[MASKED_LUNGEHOLD_ID].length
            end

            local seq={
                armed=false,
                armedAt=nil,
                expires=now+MASKED_SEQUENCE_TIME,
                lungeTrack=track,
                lungeReachedMinTime=false,
                lungeFinished=false,
                lungePosition=0,
                lungeLength=actualLength,
                lungeStoppedAt=nil,
                walkTrack=nil,
                pendingWalkTrack=nil,
                walkStarted=nil,
                walkSeen=false,
                prepared=false,
                consumed=false,
                parried=false,
                acceptedWalkTracks={}
            }

            STATE.maskedSequence[char]=seq
            STATE.maskedLungeArmed[char]=seq

            local conn

            conn=track.Stopped:Connect(function()
                if conn then
                    conn:Disconnect()
                    conn=nil
                end

                task.defer(function()
                    if STATE.maskedSequence[char]~=seq then
                        return
                    end

                    seq.lungeFinished=true
                    seq.lungeStoppedAt=tick()

                    local currentWalkTracks=getMaskedWalkTracks(char)

                    for walkTrack in pairs(currentWalkTracks) do
                        registerMaskedWalkPreparation(char,seq,walkTrack)

                        if STATE.maskedSequence[char]~=seq then
                            return
                        end
                    end

                    if seq.pendingWalkTrack and seq.pendingWalkTrack.IsPlaying then
                        registerMaskedWalkPreparation(char,seq,seq.pendingWalkTrack)
                    end

                    if not seq.lungeReachedMinTime then
                        clearMaskedSequence(char)
                    end
                end)
            end)

            return
        end

        if numericId==MASKED_WALK_ID then
            local seq=STATE.maskedSequence[char]

            if seq then
                if seq.lungeTrack and seq.lungeTrack.IsPlaying then
                    seq.pendingWalkTrack=track
                else
                    seq.lungeFinished=true
                    registerMaskedWalkPreparation(char,seq,track)
                end
            end

            return
        end

        if numericId==MASKED_ATTACK_ID or numericId==MASKED_ATTACKDONE_ID then
            return
        end
    end

    local function maskedHeartbeatMonitor()
        if not STATE.autoParryEnabled then
            return
        end

        for killerChar,seq in pairs(STATE.maskedSequence) do
            if not killerChar or not killerChar.Parent or not seq then
                clearMaskedSequence(killerChar)
            elseif seq.consumed then
                clearMaskedSequence(killerChar)
            elseif tick()>seq.expires then
                clearMaskedSequence(killerChar)
            else
                local lungeTrack=seq.lungeTrack

                if lungeTrack then
                    if lungeTrack.IsPlaying then
                        local position=lungeTrack.TimePosition or 0
                        seq.lungePosition=position

                        if position>=MASKED_MIN_LUNGE_TIME then
                            seq.lungeReachedMinTime=true

                            if not seq.armed then
                                seq.armed=true
                                seq.armedAt=tick()
                                STATE.maskedLungeArmed[killerChar]=seq
                            end

                            if maskedTryLungeParry(killerChar,seq) then
                                continue
                            end
                        end
                    elseif seq.lungeReachedMinTime then
                        seq.lungeFinished=true

                        local distance=getSkillDistance(killerChar)
                        local predictedDistance=getMaskedPredictedDistance(killerChar)

                        if distance<=STATE.autoParryRadius
                        or predictedDistance<=STATE.autoParryRadius then
                            if maskedTryLungeParry(killerChar,seq) then
                                continue
                            end
                        end
                    end
                end

                if seq.lungeFinished and seq.lungeReachedMinTime then
                    if seq.pendingWalkTrack and seq.pendingWalkTrack.IsPlaying then
                        registerMaskedWalkPreparation(killerChar,seq,seq.pendingWalkTrack)

                        if not STATE.maskedSequence[killerChar] then
                            continue
                        end
                    end

                    local currentWalkTracks=getMaskedWalkTracks(killerChar)

                    for walkTrack in pairs(currentWalkTracks) do
                        registerMaskedWalkPreparation(killerChar,seq,walkTrack)

                        if not STATE.maskedSequence[killerChar] then
                            break
                        end
                    end

                    local current=STATE.maskedSequence[killerChar]

                    if current and current.walkSeen then
                        maskedTryWalkParry(killerChar,current)
                    end
                end
            end
        end
    end

    local boundCharacters={}

    local function cleanupCharacter(char)
        boundCharacters[char]=nil
        STATE.killerCharacters[char]=nil
        STATE.activeAttackers[char]=nil
        STATE.activeSkillAttackers[char]=nil
        STATE.maskedLungeArmed[char]=nil
        STATE.maskedSequence[char]=nil
        STATE.hiddenSequence[char]=nil
    end

    local function OnParryCharacterAdded(player,char)
        if not player or not char or player==localPlayer then
            return
        end

        if boundCharacters[char] then
            return
        end

        boundCharacters[char]=true

        local kName=getKillerName(player,char) or "Unknown Killer"

        local function resolveKiller()
            if not char.Parent then
                return false
            end

            local detectedName=getKillerName(player,char)
            local teamKiller=isKillerTeam(player)
            local known=STATE.killerCharacters[char]

            if detectedName then
                kName=detectedName

                if not known then
                    STATE.killerCharacters[char]={
                        player=player,
                        name=kName
                    }
                else
                    known.player=player
                    known.name=kName
                end

                return true
            end

            if teamKiller then
                if not known then
                    STATE.killerCharacters[char]={
                        player=player,
                        name=kName
                    }
                else
                    known.player=player

                    if known.name==nil
                    or known.name==""
                    or known.name=="Unknown Killer" then
                        known.name=kName
                    end
                end

                return true
            end

            if known and known.player==player then
                kName=known.name or kName
                return true
            end

            return false
        end

        resolveKiller()

        char.AncestryChanged:Connect(function(_,parent)
            if not parent then
                cleanupCharacter(char)
            end
        end)

        task.spawn(function()
            for _=1,12 do
                if not char.Parent then
                    return
                end

                resolveKiller()
                task.wait(0.5)
            end
        end)

        local humanoid=char:WaitForChild("Humanoid",3)

        if not humanoid then
            return
        end

        local animator=humanoid:WaitForChild("Animator",3)

        if not animator then
            return
        end

        animator.AnimationPlayed:Connect(function(track)
            if not STATE.autoParryEnabled then
                return
            end

            if not track or not track.Animation then
                return
            end

            local numericId=getAnimNumericId(track.Animation.AnimationId)

            if not numericId then
                return
            end

            local detectedName=getKillerName(player,char)

            if detectedName then
                kName=detectedName

                local known=STATE.killerCharacters[char]

                if known then
                    known.name=detectedName
                else
                    STATE.killerCharacters[char]={
                        player=player,
                        name=detectedName
                    }
                end
            else
                local known=STATE.killerCharacters[char]

                if known and known.name then
                    kName=known.name
                end
            end

            local currentName=kName or "Unknown Killer"

            if numericId==MASKED_LUNGEHOLD_ID
            or numericId==MASKED_WALK_ID
            or numericId==MASKED_ATTACK_ID
            or numericId==MASKED_ATTACKDONE_ID then

                local profile=MASKED_EXTRA_ANIMS[numericId] or {
                    type="maskedfast",
                    length=1,
                    speed=1
                }

                registerMaskedFastAttack(
                    char,
                    currentName,
                    track,
                    profile,
                    numericId
                )

                if not STATE.killerCharacters[char] then
                    STATE.killerCharacters[char]={
                        player=player,
                        name=currentName
                    }
                end

                return
            end

            if numericId==SKILL_ANIM_ID then
                if sharedIsResolvedKiller(char) then
                    registerSkillAttack(char,currentName,track)
                end
                return
            end

            if numericId==HIDDEN_HIT_BACK_ID
            or numericId==HIDDEN_HIT_FRONT_ID then
                if currentName:lower()=="the hidden" then
                    registerHiddenHit(char,track)
                end

                return
            end

            if numericId==HIDDEN_WALK_ANIM_ID then
                if currentName:lower()=="the hidden" then
                    registerHiddenWalk(char,track)
                end

                return
            end

            if numericId==ABYSSWALKER_ANIM_ID then
                registerAbysswalkerAttack(char,currentName,track)

                if not STATE.killerCharacters[char] then
                    STATE.killerCharacters[char]={
                        player=player,
                        name=currentName
                    }
                end

                return
            end

            local profile=ATTACK_PROFILES[numericId]

            if not profile then
                return
            end

            local known=STATE.killerCharacters[char]

            if not known then
                STATE.killerCharacters[char]={
                    player=player,
                    name=currentName
                }
            elseif currentName~="Unknown Killer" then
                known.name=currentName
            end

            local data={
                name=currentName,
                track=track,
                type=profile.type,
                id=numericId,
                profile=profile,
                started=tick(),
                consumed=false,
                lastTimePosition=-1
            }

            STATE.activeAttackers[char]=data

            local conn

            conn=track.Stopped:Connect(function()
                if conn then
                    conn:Disconnect()
                    conn=nil
                end

                if STATE.activeAttackers[char]
                and STATE.activeAttackers[char].track==track then
                    STATE.activeAttackers[char]=nil
                end
            end)
        end)
    end

    local function OnParryPlayerAdded(player)
        if player==localPlayer then
            return
        end

        if player.Character then
            task.spawn(function()
                OnParryCharacterAdded(player,player.Character)
            end)
        end

        player.CharacterAdded:Connect(function(char)
            task.spawn(function()
                OnParryCharacterAdded(player,char)
            end)
        end)
    end

    for _,player in ipairs(Players:GetPlayers()) do
        OnParryPlayerAdded(player)
    end

    Players.PlayerAdded:Connect(OnParryPlayerAdded)

    RegisterTask("CloseRangeMonitor",0,function()
        if not STATE.autoParryEnabled then
            return
        end

        local localChar=localPlayer.Character
        local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")

        if not localRoot then
            return
        end

        for killerChar,data in pairs(STATE.activeAttackers) do
            if killerChar
            and killerChar.Parent
            and data
            and not data.consumed
            and data.track
            and data.track.IsPlaying
            and data.profile then

                local position=data.track.TimePosition or 0
                local triggerTime=(data.profile.triggerTime or 0)/(data.profile.speed or 1)

                if data.profile.type=="attack"
                and position>triggerTime+ATTACK_TRIGGER_GRACE then
                    STATE.activeAttackers[killerChar]=nil
                    continue
                end

                local killerRoot=killerChar:FindFirstChild("HumanoidRootPart")

                if killerRoot then
                    if data.profile.faceRequired and not isFacingLocalPlayer(killerChar) then
                        continue
                    end

                    local offset=localRoot.Position-killerRoot.Position
                    local flatOffset=Vector3.new(offset.X,0,offset.Z)
                    local distance=flatOffset.Magnitude

                    local killerVelocity=killerRoot.AssemblyLinearVelocity
                    local localVelocity=localRoot.AssemblyLinearVelocity

                    local killerFlatVelocity=Vector3.new(killerVelocity.X,0,killerVelocity.Z)
                    local localFlatVelocity=Vector3.new(localVelocity.X,0,localVelocity.Z)

                    local relativeVelocity=killerFlatVelocity-localFlatVelocity
                    local closingSpeed=0

                    if distance>0.05 then
                        closingSpeed=relativeVelocity:Dot(flatOffset.Unit)
                    end

                    local timeToImpact=closingSpeed>0 and distance/closingSpeed or math.huge

                    local predictedDistance=getPredictedDistance(killerChar,0.40)

                    local length=data.track.Length

                    if not length or length<=0 then
                        length=data.profile.length
                    end

                    local speed=data.profile.speed or 1
                    local progress=length>0 and (position*speed)/length or 0
                    local triggerTime=(data.profile.triggerTime or 0)/speed
                    local triggerProgress=data.profile.triggerProgress or 0

                    local animationReady=position>=triggerTime
                        or progress>=triggerProgress

                    local attackWindowOpen=true

                    if data.profile.type=="attack" then
                        attackWindowOpen=position<=triggerTime+ATTACK_TRIGGER_GRACE
                    end

                    local lungeReady=closingSpeed>=5 and timeToImpact<=0.30
                    local critical=closingSpeed>=3.5 and timeToImpact<=0.15

                    if (animationReady and attackWindowOpen)
                    or lungeReady
                    or critical then

                        if canNormalAttackParry(
                            killerChar,
                            distance,
                            closingSpeed,
                            predictedDistance
                        ) then

                            local trigger=false

                            if distance<=STATE.autoParryRadius then
                                trigger=true
                            elseif closingSpeed>=2.5
                            and math.max(distance-3.5,0)/closingSpeed<=0.24 then
                                trigger=true
                            elseif closingSpeed>=5
                            and math.max(distance-3.5,0)/closingSpeed<=0.32 then
                                trigger=true
                            elseif predictedDistance<=STATE.autoParryRadius
                            and closingSpeed>=2 then
                                trigger=true
                            elseif animationReady
                            and attackWindowOpen
                            and predictedDistance<=STATE.autoParryRadius+1.75 then
                                trigger=true
                            end

                            if trigger then
                                if doParry(true,killerChar,distance) then
                                    data.consumed=true
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    local function normalAttackHeartbeatMonitor()
        if not STATE.autoParryEnabled then
            return
        end

        local localChar=localPlayer.Character
        local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")

        if not localRoot then
            return
        end

        local localPos=localRoot.Position

        for killerChar,data in pairs(STATE.activeSkillAttackers) do
            if not killerChar or not killerChar.Parent or not data or not data.track then
                STATE.activeSkillAttackers[killerChar]=nil
            elseif not data.track.IsPlaying then
                STATE.activeSkillAttackers[killerChar]=nil
            elseif not data.consumed and data.skillId==ABYSSWALKER_ANIM_ID then
                if not STATE.ignoredTheAbysswalker then
                    local killerRoot=killerChar:FindFirstChild("HumanoidRootPart")

                    if killerRoot then
                        local killerPos=killerRoot.Position

                        local flatOffset=Vector3.new(
                            localPos.X-killerPos.X,
                            0,
                            localPos.Z-killerPos.Z
                        )

                        if flatOffset.Magnitude<=ABYSSWALKER_RANGE then
                            if doSkillParry() then
                                data.consumed=true
                            end
                        end
                    end
                end
            end
        end
    end

    RunService.Heartbeat:Connect(function()
        if STATE.autoParryEnabled then
            normalAttackHeartbeatMonitor()
        end
    end)

    local function normalAttackersMonitor()
        if not STATE.autoParryEnabled then
            return
        end

        local localChar=localPlayer.Character
        local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")

        if not localRoot then
            return
        end

        for killerChar,data in pairs(STATE.activeAttackers) do
            if killerChar
            and killerChar.Parent
            and killerChar~=localChar
            and data
            and not data.consumed
            and data.track
            and data.track.IsPlaying
            and data.profile then

                local position=data.track.TimePosition or 0
                local triggerTime=(data.profile.triggerTime or 0)/(data.profile.speed or 1)

                if data.profile.type=="attack"
                and position>triggerTime+ATTACK_TRIGGER_GRACE then
                    STATE.activeAttackers[killerChar]=nil
                    continue
                end

                local killerRoot=killerChar:FindFirstChild("HumanoidRootPart")

                if killerRoot then
                    local killerVelocity=killerRoot.AssemblyLinearVelocity
                    local killerFlatVelocity=Vector3.new(killerVelocity.X,0,killerVelocity.Z)

                    local localVelocity=localRoot.AssemblyLinearVelocity
                    local localFlatVelocity=Vector3.new(localVelocity.X,0,localVelocity.Z)

                    local offset=localRoot.Position-killerRoot.Position
                    local flatOffset=Vector3.new(offset.X,0,offset.Z)
                    local distance=flatOffset.Magnitude

                    local relativeVelocity=killerFlatVelocity-localFlatVelocity

                    local closingSpeed=0

                    if flatOffset.Magnitude>0 then
                        closingSpeed=relativeVelocity:Dot(flatOffset.Unit)
                    end

                    local ping=math.clamp(localPlayer:GetNetworkPing(),0,0.3)
                    local predictionTime=ping+0.035

                    local predictedKiller=killerRoot.Position+
                        killerFlatVelocity*predictionTime

                    local predictedLocal=localRoot.Position+
                        localFlatVelocity*predictionTime

                    local predictedDistance=(
                        Vector3.new(predictedLocal.X,0,predictedLocal.Z)-
                        Vector3.new(predictedKiller.X,0,predictedKiller.Z)
                    ).Magnitude

                    local position=data.track.TimePosition or 0
                    local realLength=data.track.Length
                    local length=(realLength and realLength>0)
                        and realLength
                        or data.profile.length

                    local speed=data.profile.speed or 1
                    local progress=length>0 and (position*speed)/length or 0
                    local triggerTime=(data.profile.triggerTime or 0)/speed
                    local triggerProgress=data.profile.triggerProgress or 0

                    local animationReady=position>=triggerTime
                        or progress>=triggerProgress

                    local attackWindowOpen=true

                    if data.profile.type=="attack" then
                        attackWindowOpen=position<=triggerTime+ATTACK_TRIGGER_GRACE
                    end

                    if animationReady and attackWindowOpen then
                        if canNormalAttackParry(
                            killerChar,
                            distance,
                            closingSpeed,
                            predictedDistance
                        ) then

                            local trigger=false

                            if distance<=STATE.autoParryRadius then
                                trigger=true
                            elseif closingSpeed>=2
                            and predictedDistance<=STATE.autoParryRadius then
                                trigger=true
                            elseif closingSpeed>=3
                            and predictedDistance<=STATE.autoParryRadius+1.5 then
                                trigger=true
                            elseif distance<=STATE.autoParryRadius
                            and predictedDistance<=STATE.autoParryRadius+1.75 then
                                trigger=true
                            end

                            if trigger then
                                if doParry(true,killerChar,distance) then
                                    data.consumed=true
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Edge/corner pulse: supplemental only. Normal Heartbeat attack detection
    -- remains the primary Auto Parry path. This pulse is used only when an
    -- active attack is close to a partial obstacle/standing pallet/corner,
    -- where the hit can arrive around the edge between Heartbeat samples.
    local function edgeCornerParryPulse()
        if not STATE.autoParryEnabled then
            return
        end

        local localChar=localPlayer.Character
        local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")
        if not localRoot then
            return
        end

        for killerChar,data in pairs(STATE.activeAttackers) do
            if killerChar
            and killerChar.Parent
            and killerChar~=localChar
            and data
            and not data.consumed
            and data.track
            and data.track.IsPlaying
            and data.profile then

                local profile=data.profile
                local profileType=profile.type

                if profileType=="attack"
                or profileType=="lungehold"
                or profileType=="corrupt"
                or profileType=="spearlunge" then

                    local killerRoot=killerChar:FindFirstChild("HumanoidRootPart")
                    if killerRoot then
                        local offset=localRoot.Position-killerRoot.Position
                        local flat=Vector3.new(offset.X,0,offset.Z)
                        local distance=flat.Magnitude

                        if distance<=STATE.autoParryRadius+2.5 then
                            local killerVelocity=killerRoot.AssemblyLinearVelocity
                            local localVelocity=localRoot.AssemblyLinearVelocity
                            local kFlat=Vector3.new(killerVelocity.X,0,killerVelocity.Z)
                            local lFlat=Vector3.new(localVelocity.X,0,localVelocity.Z)

                            local closingSpeed=0
                            if flat.Magnitude>0.05 then
                                closingSpeed=(kFlat-lFlat):Dot(flat.Unit)
                            end

                            local ping=math.clamp(localPlayer:GetNetworkPing(),0,0.3)
                            local predictionTime=ping+0.035
                            local predictedKiller=killerRoot.Position+kFlat*predictionTime
                            local predictedLocal=localRoot.Position+lFlat*predictionTime

                            local predictedDistance=(
                                Vector3.new(predictedLocal.X,0,predictedLocal.Z)-
                                Vector3.new(predictedKiller.X,0,predictedKiller.Z)
                            ).Magnitude

                            local obstacle=getObstacleState(
                                localRoot.Position,
                                killerRoot.Position,
                                killerChar
                            )

                            local partialEdge=(
                                not obstacle.directBlocked
                                and obstacle.clearCount>=2
                                and obstacle.blockedCount>=1
                                and (
                                    obstacle.vault
                                    or obstacle.standingPallet
                                    or obstacle.blockedCount>=1
                                )
                            )

                            if partialEdge then
                                local imminent=(
                                    distance<=STATE.autoParryRadius
                                    or predictedDistance<=STATE.autoParryRadius+1.5
                                    or closingSpeed>=2.0
                                )

                                if imminent then
                                    if doParry(
                                        true,
                                        killerChar,
                                        distance,
                                        predictedDistance<=STATE.autoParryRadius+1.5,
                                        true
                                    ) then
                                        data.consumed=true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Fast attack pulse: run immediately before simulation as an additional
    -- detector. This reduces the chance of missing a short animation window
    -- between Heartbeat samples without changing the parry cooldown.
    if RunService.PreSimulation then
        RunService.PreSimulation:Connect(function()
            if STATE.autoParryEnabled then
                edgeCornerParryPulse()
            end
        end)
    end

    RunService.RenderStepped:Connect(function()
        if STATE.autoParryEnabled then
            -- Extra render-frame pulse: normal attacks are checked here as well,
            -- not only on Heartbeat.
            normalAttackersMonitor()
            hiddenHeartbeatMonitor()
            maskedHeartbeatMonitor()
        end
    end)

    RunService.Heartbeat:Connect(function()
        if STATE.autoParryEnabled then
            normalAttackersMonitor()
        end
    end)

    RunService.Heartbeat:Connect(function()
        if STATE.autoParryEnabled then
            hiddenHeartbeatMonitor()
        end
    end)

    RunService.Heartbeat:Connect(function()
        if STATE.autoParryEnabled then
            maskedHeartbeatMonitor()
        end
    end)

    if RunService.PreSimulation then
        RunService.PreSimulation:Connect(function()
            if STATE.autoParryEnabled then
                normalAttackHeartbeatMonitor()
                normalAttackersMonitor()
                hiddenHeartbeatMonitor()
                maskedHeartbeatMonitor()
            end
        end)
    end

    local espRing={}
    local espLoop=nil
    local espCache={}
    local SEGMENTS=32
    local lastRadius=-1

    local function buildRing()
        for _,p in ipairs(espRing) do
            if p and p.Parent then
                p:Destroy()
            end
        end

        espRing={}
        espCache={}

        local step=(2*math.pi)/SEGMENTS

        for i=1,SEGMENTS do
            local angle=step*(i-1)
            local nextAngle=step*i

            espCache[i]={
                cx=math.cos(angle),
                cz=math.sin(angle),
                nx=math.cos(nextAngle),
                nz=math.sin(nextAngle)
            }

            local seg=Instance.new("Part")

            seg.Shape=Enum.PartType.Block
            seg.Anchored=true
            seg.CanCollide=false
            seg.CanQuery=false
            seg.CastShadow=false
            seg.Material=Enum.Material.Neon
            seg.Color=Color3.fromRGB(255,255,255)
            seg.Transparency=0.15
            seg.Size=Vector3.new(0.08,0.08,0.1)
            seg.Name="BolongESP_Seg"
            seg.Parent=Workspace

            espRing[i]=seg
        end
    end

    local function updateSegmentSizes(radius)
        local arcLen=(2*math.pi*radius)/SEGMENTS

        for _,seg in ipairs(espRing) do
            if seg and seg.Parent then
                seg.Size=Vector3.new(0.08,0.08,arcLen+0.02)
            end
        end
    end

    local function destroyRing()
        for _,p in ipairs(espRing) do
            if p and p.Parent then
                p:Destroy()
            end
        end

        espRing={}
        espCache={}
        lastRadius=-1
    end

    function toggleAutoParryESP(state)
        if state then
            buildRing()

            espLoop=RunService.RenderStepped:Connect(function()
                if not localPlayer.Character then
                    return
                end

                local root=localPlayer.Character:FindFirstChild("HumanoidRootPart")

                if not root then
                    return
                end

                local radius=STATE.autoParryRadius
                local now=tick()
                local pulseAt=STATE.parryVisualPulseAt or 0

                if pulseAt>0 then
                    local elapsed=now-pulseAt

                    if elapsed<1.0 then
                        local t=math.clamp(elapsed,0,1)
                        radius=STATE.autoParryRadius*(1-t)
                    elseif elapsed<PARRY_COOLDOWN-1.0 then
                        radius=0
                    else
                        local t=math.clamp(
                            elapsed-(PARRY_COOLDOWN-1.0),
                            0,
                            1
                        )
                        radius=STATE.autoParryRadius*t

                        if t>=1 then
                            STATE.parryVisualPulseAt=0
                            STATE.parryVisualExpandAt=0
                            radius=STATE.autoParryRadius
                        end
                    end
                end

                if radius~=lastRadius then
                    updateSegmentSizes(radius)
                    lastRadius=radius
                end

                local center=root.Position-Vector3.new(0,root.Size.Y/2+0.6,0)

                for i,seg in ipairs(espRing) do
                    if seg and seg.Parent then
                        local c=espCache[i]
                        local pos=center+Vector3.new(c.cx*radius,0,c.cz*radius)
                        local nxt=center+Vector3.new(c.nx*radius,0,c.nz*radius)

                        seg.CFrame=CFrame.lookAt(pos,nxt)*CFrame.new(0,0,-seg.Size.Z/2)
                    end
                end
            end)
        else
            if espLoop then
                espLoop:Disconnect()
                espLoop=nil
            end

            destroyRing()
        end
    end
end

RunService.Heartbeat:Connect(function(dt)
    for i=1,#MasterTasks do
        local t=MasterTasks[i]

        t.timer=t.timer+dt

        if t.timer>=t.interval then
            t.timer=0
            t.fn(dt)
        end
    end
end)


local KillerAimingFeature=(function()
    local activeTracks={}
    local trackConnections={}
    local aimingLines={}
    local alwaysLines={}
    local heavenParts={}
    local killerWatchConnections={}
    local lineAlways=false

    -- Direct Killer Detector:
    -- Keeps exactly one selected killer character instead of treating every
    -- character with a generic marker as a killer.
    local DIRECT_KILLER={
        selectedPlayer=nil,
        selectedCharacter=nil,
        selectedName=nil,
        candidates={},
        lastScan=0
    }

    local function directKillerEvidence(player,char)
        if not player or not char or not char.Parent then
            return nil,0,{}
        end

        local evidence={}
        local score=0
        local name=nil

        local function addEvidence(text,points)
            evidence[#evidence+1]=text
            score=score+points
        end

        local function considerName(value,source)
            if typeof(value)=="string" and value~="" then
                if not name then
                    name=value
                end
                evidence[#evidence+1]=source.."="..value
            end
        end

        -- Highest-confidence explicit killer identity.
        local values=char:FindFirstChild("Values")
        local killerNameVal=values and values:FindFirstChild("KillerName")
        if killerNameVal
        and killerNameVal:IsA("StringValue")
        and killerNameVal.Value~="" then
            name=killerNameVal.Value
            addEvidence(
                "Values.KillerName="..tostring(killerNameVal.Value),
                120
            )
        end

        local selected=player:GetAttribute("SelectedKiller")
        if typeof(selected)=="string" and selected~="" then
            considerName(selected,"SelectedKiller")
            score=math.max(score,110)
        end

        -- Some games store the role/name under a differently named
        -- attribute. Only accept explicit role/killer-like attribute names.
        for attrName,attrValue in pairs(player:GetAttributes()) do
            local n=string.lower(tostring(attrName))
            if (n:find("killer",1,true)
                or n:find("role",1,true)
                or n:find("character",1,true))
                and typeof(attrValue)=="string"
                and attrValue~="" then
                considerName(attrValue,"PlayerAttribute."..tostring(attrName))
                score=math.max(score,100)
            end
        end

        -- Direct character markers found in the supplied scan.
        local killerost=char:FindFirstChild("Killerost",true)
        local lookkiller=char:FindFirstChild("Lookscriptkiller",true)
        local spearmanager=char:FindFirstChild("spearmanager",true)
        local weapon=char:FindFirstChild("Weapon",true)
        local spear1=char:FindFirstChild("Spear1",true)
        local spear2=char:FindFirstChild("Spear2",true)

        if killerost then
            addEvidence("Character.Killerost",55)
        end

        if lookkiller then
            addEvidence("Character.Lookscriptkiller",45)
        end

        if spearmanager then
            addEvidence("Character.spearmanager",25)
        end

        if weapon then
            addEvidence("Character.Weapon",20)
        end

        if spear1 or spear2 then
            addEvidence(
                "Character.Spear1/Spear2",
                30
            )
        end

        -- Killer-side attributes observed in the scan.
        local killerAttributes={
            "Spears",
            "TerrorRadius",
            "SuspenseRadius",
            "BloodLust",
            "ChaseTargetUserId",
            "Chasemusic",
            "spearmode",
            "foundationstaff",
            "special"
        }

        for _,attrName in ipairs(killerAttributes) do
            local value=char:GetAttribute(attrName)

            if value~=nil then
                addEvidence(
                    "Attribute."..attrName.."="..tostring(value),
                    6
                )
            end
        end

        -- Strong survivor-side negatives. These prevent generic character
        -- evidence from selecting a survivor when the killer is present.
        local survivorMarkers=0

        if char:FindFirstChild("Highlight-forsurvivor",true) then
            survivorMarkers=survivorMarkers+1
            evidence[#evidence+1]="SurvivorMarker=Highlight-forsurvivor"
        end

        if char:FindFirstChild("Parrying Dagger",true) then
            survivorMarkers=survivorMarkers+1
            evidence[#evidence+1]="SurvivorMarker=Parrying Dagger"
        end

        if char:FindFirstChild("Lookscript",true)
            and not lookkiller then
            survivorMarkers=survivorMarkers+1
            evidence[#evidence+1]="SurvivorMarker=Lookscript"
        end

        if char:GetAttribute("Flowstate")~=nil
            or char:GetAttribute("repairboost")~=nil
            or char:GetAttribute("skillcheckfrequency")~=nil then
            survivorMarkers=survivorMarkers+1
            evidence[#evidence+1]="SurvivorAttributes"
        end

        if survivorMarkers>0 then
            score=score-(survivorMarkers*35)
        end

        -- A local player can also be the killer. Do not exclude them.
        -- Require concrete killer evidence before selecting a character.
        if killerost or lookkiller or spear1 or spear2
            or spearmanager or weapon then
            score=math.max(score,40)
        end

        if score<=0 then
            return nil,0,evidence
        end

        -- If the game does not expose KillerName/SelectedKiller,
        -- selectedName is the player name as a stable fallback.
        return name or player.Name,score,evidence
    end

    local function scanDirectKiller()
        local candidates={}
        local best=nil

        for _,player in ipairs(Players:GetPlayers()) do
            -- Visual target must be another player; never select the local player.
            if player ~= LocalPlayer
                and player.Character
                and player.Character.Parent then
                local name,score,evidence=directKillerEvidence(player,player.Character)
                if score>0 then
                    local item={
                        player=player,
                        character=player.Character,
                        name=name or player.Name,
                        score=score,
                        evidence=evidence
                    }
                    candidates[#candidates+1]=item

                    if not best
                    or score>best.score
                    or (score==best.score and #evidence>#best.evidence) then
                        best=item
                    end
                end
            end
        end

        DIRECT_KILLER.candidates=candidates
        DIRECT_KILLER.lastScan=tick()

        if best then
            DIRECT_KILLER.selectedPlayer=best.player
            DIRECT_KILLER.selectedCharacter=best.character
            DIRECT_KILLER.selectedName=best.name
        else
            DIRECT_KILLER.selectedPlayer=nil
            DIRECT_KILLER.selectedCharacter=nil
            DIRECT_KILLER.selectedName=nil
        end

        return best,candidates
    end

    local function isDirectSelectedKiller(char)
        return char
            and DIRECT_KILLER.selectedCharacter==char
            and char.Parent
    end

    local MAX_LENGTH=115
    local LINE_THICKNESS=0.08
    local HEAVEN_DISTANCE=17.2
    local HEAVEN_HEIGHT=0.33
    local HEAVEN_WIDTH=8.75
    local WHITE=Color3.fromRGB(255,255,255)
    local YELLOW=Color3.fromRGB(255,220,0)

    local function numericId(track)
        if not track or not track.Animation then
            return nil
        end
        local id=track.Animation.AnimationId
        if typeof(id)~="string" then
            return nil
        end
        return tonumber(id:match("%d+"))
    end

    local function scanKillerRegistry()
        local best,candidates=scanDirectKiller()

        -- Registry contains only the one selected killer.
        STATE.killerCharacters={}
        if best then
            STATE.killerCharacters[best.character]={
                player=best.player,
                name=best.name,
                score=best.score,
                evidence=best.evidence
            }
        end

        return best,candidates
    end

    -- Single source of truth for every Killer visual.
    -- The player name is never hardcoded; this is whatever the detector
    -- currently selected as the active Killer.
    local function getCurrentKiller()
        local char=DIRECT_KILLER.selectedCharacter
        if char and char.Parent then
            return char
        end
        return nil
    end

    local function isKillerCharacter(char)
        return char ~= nil and char == getCurrentKiller()
    end

    local function setBeamColor(beam,color)
        beam.Color=ColorSequence.new(color)
    end

    local function destroyLineData(data)
        if not data then
            return
        end
        if data.beam and data.beam.Parent then
            data.beam:Destroy()
        end
        if data.endpointAttachment and data.endpointAttachment.Parent then
            data.endpointAttachment:Destroy()
        end
        if data.endpointPart and data.endpointPart.Parent then
            data.endpointPart:Destroy()
        end
    end

    local function clearLine(store,char)
        local data=store[char]
        if data then
            destroyLineData(data)
            store[char]=nil
        end
    end

    local function createLine(store,char,color,prefix)
        if not char or not char.Parent then
            return nil
        end
        local head=char:FindFirstChild("Head")
        if not head then
            return nil
        end

        clearLine(store,char)

        local endpointPart=Instance.new("Part")
        endpointPart.Name=prefix.."Endpoint"
        endpointPart.Anchored=true
        endpointPart.CanCollide=false
        endpointPart.CanTouch=false
        endpointPart.CanQuery=false
        endpointPart.CastShadow=false
        endpointPart.Transparency=1
        endpointPart.Size=Vector3.new(.1,.1,.1)
        endpointPart.CFrame=CFrame.new(head.Position)
        endpointPart.Parent=Workspace

        local startAttachment=Instance.new("Attachment")
        startAttachment.Name=prefix.."Start"
        startAttachment.Position=Vector3.zero
        startAttachment.Parent=head

        local endpointAttachment=Instance.new("Attachment")
        endpointAttachment.Name=prefix.."End"
        endpointAttachment.Position=Vector3.zero
        endpointAttachment.Parent=endpointPart

        local beam=Instance.new("Beam")
        beam.Name=prefix
        beam.Attachment0=startAttachment
        beam.Attachment1=endpointAttachment
        beam.FaceCamera=true
        beam.LightEmission=1
        beam.LightInfluence=0
        beam.Segments=1
        beam.Width0=LINE_THICKNESS
        beam.Width1=LINE_THICKNESS
        beam.Transparency=NumberSequence.new(0)
        setBeamColor(beam,color or WHITE)
        beam.Parent=endpointPart

        local data={
            beam=beam,
            endpointPart=endpointPart,
            endpointAttachment=endpointAttachment,
            startAttachment=startAttachment,
            color=color or WHITE
        }
        store[char]=data
        return data
    end

    local function updateLine(data,char)
        if not data or not char or not char.Parent then
            return
        end
        local head=char:FindFirstChild("Head")
        local root=char:FindFirstChild("HumanoidRootPart")
        if not head or not root then
            return
        end

        local direction=root.CFrame.LookVector
        if direction.Magnitude<=0.001 then
            return
        end
        direction=direction.Unit

        local origin=head.Position
        data.endpointPart.CFrame=CFrame.new(origin+direction*MAX_LENGTH)
        data.startAttachment.Position=Vector3.zero
        data.endpointAttachment.Position=Vector3.zero
    end

    local function clearAimingLine(char)
        clearLine(aimingLines,char)
    end

    local function createAimingLine(char,color)
        return createLine(aimingLines,char,color,"LineOfSightAnimation")
    end

    local function updateAimingLine(char)
        updateLine(aimingLines[char],char)
    end

    local function clearAlwaysLine(char)
        clearLine(alwaysLines,char)
    end

    local function createAlwaysLine(char)
        return createLine(alwaysLines,char,WHITE,"LineOfSightAlways")
    end

    local function updateAlwaysLine(char)
        local data=alwaysLines[char]
        if not data then
            return
        end

        -- Always Line is permanently white.  Animation Line of Sight is the
        -- separate layer that changes to yellow for lungehold/corrupt.
        if data.color~=WHITE then
            data.color=WHITE
            setBeamColor(data.beam,WHITE)
        end

        updateLine(data,char)
    end

    local function clearHeavenParts(char)
        local list=heavenParts[char]
        if list then
            for _,part in ipairs(list) do
                if part and part.Parent then
                    part:Destroy()
                end
            end
        end
        heavenParts[char]=nil
    end

    local function makeHeavenPart(name)
        local part=Instance.new("Part")
        part.Name=name
        part.Anchored=true
        part.CanCollide=false
        part.CanTouch=false
        part.CanQuery=false
        part.CastShadow=false
        part.Material=Enum.Material.Neon
        part.Color=WHITE
        part.Transparency=0.05
        part.Size=Vector3.new(.0825,.0825,.1)
        part.Parent=Workspace
        return part
    end

    local function pointPart(part,a,b)
        local delta=b-a
        local length=delta.Magnitude
        if length<=.001 then
            part.Transparency=1
            return
        end
        part.Transparency=.05
        part.Size=Vector3.new(.0825,.0825,length)
        part.CFrame=CFrame.lookAt((a+b)*.5,b)
    end

    local function heavenGroundPoint(char,point)
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not root then
            return point
        end
        return Vector3.new(point.X,root.Position.Y-3.0,point.Z)
    end

    local function ensureHeavenParts(char)
        local list=heavenParts[char]
        if list then
            return list
        end
        list={
            makeHeavenPart("HeavenEyesLine"),
            makeHeavenPart("HeavenEyesLine"),
            makeHeavenPart("HeavenEyesLine")
        }
        heavenParts[char]=list
        return list
    end

    local function updateHeavenEyes(char)
        if not STATE.heavenEyesEnabled or not char or not char.Parent then
            clearHeavenParts(char)
            return
        end
        local root=char:FindFirstChild("HumanoidRootPart")
        if not root then
            return
        end

        local forward=Vector3.new(root.CFrame.LookVector.X,0,root.CFrame.LookVector.Z)
        if forward.Magnitude<=.01 then
            return
        end
        forward=forward.Unit
        local right=Vector3.new(-forward.Z,0,forward.X)

        local center=root.Position
        local apexBase=center+forward*1.0
        local leftBase=center+forward*HEAVEN_DISTANCE-right*HEAVEN_WIDTH
        local rightBase=center+forward*HEAVEN_DISTANCE+right*HEAVEN_WIDTH

        local apex=heavenGroundPoint(char,apexBase)
        local leftEnd=heavenGroundPoint(char,leftBase)
        local rightEnd=heavenGroundPoint(char,rightBase)

        local parts=ensureHeavenParts(char)
        pointPart(parts[1],apex,leftEnd)
        pointPart(parts[2],leftEnd,rightEnd)
        pointPart(parts[3],rightEnd,apex)

        for _,part in ipairs(parts) do
            part.Color=WHITE
        end
    end

    local function hasActiveRecognizedAnimation(char)
        local tracks=activeTracks[char]
        if not tracks then
            return false
        end
        for track in pairs(tracks) do
            if track and track.Parent and track.IsPlaying then
                return true
            end
        end
        return false
    end

    local function hasActiveYellowAnimation(char)
        local tracks=activeTracks[char]
        if not tracks then
            return false
        end

        for track,data in pairs(tracks) do
            if track
            and track.Parent
            and track.IsPlaying
            and data
            and data.yellow then
                return true
            end
        end

        return false
    end

    local function getAlwaysLineColor(char)
        if hasActiveYellowAnimation(char) then
            return YELLOW
        end
        return WHITE
    end

    local function removeTrack(char,track)
        local tracks=activeTracks[char]
        if not tracks then
            return
        end
        tracks[track]=nil
        local conn=trackConnections[track]
        if conn then
            conn:Disconnect()
            trackConnections[track]=nil
        end
        if next(tracks)==nil then
            activeTracks[char]=nil
        end
        if not lineAlways and not hasActiveRecognizedAnimation(char) then
            clearAimingLine(char)
        end

        if lineAlways and alwaysLines[char] then
            updateAlwaysLine(char)
        end
    end

    local function registerTrack(char,track)
        if not STATE.killerAimingEnabled then
            return
        end

        local id=numericId(track)
        local colorMode=id and KILLER_AIMING_ANIMS[id]
        if not colorMode then
            return
        end

        if not isKillerCharacter(char) then
            return
        end

        activeTracks[char]=activeTracks[char] or {}

        local data=activeTracks[char][track]
        local color=(colorMode=="yellow" and YELLOW or WHITE)

        if not data then
            data={
                startedAt=tick(),
                yellow=(colorMode=="yellow")
            }
            activeTracks[char][track]=data
        else
            data.startedAt=tick()
            data.yellow=(colorMode=="yellow")
        end

        local line=aimingLines[char]
        if not line then
            line=createAimingLine(char,color)
        else
            line.color=color
            setBeamColor(line.beam,color)
        end

        updateAimingLine(char)

        if not trackConnections[track] then
            trackConnections[track]=track.Stopped:Connect(function()
                removeTrack(char,track)
            end)
        end
    end

    local function scanCurrentTracks(char)
        local humanoid=char and char:FindFirstChildOfClass("Humanoid")
        local animator=humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            return
        end
        for _,track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track.IsPlaying then
                registerTrack(char,track)
            end
        end
    end

    local function bindCharacter(char)
        if not char or not char.Parent then
            return
        end
        if killerWatchConnections[char] then
            return
        end

        local humanoid=char:FindFirstChildOfClass("Humanoid")
        local animator=humanoid and humanoid:FindFirstChildOfClass("Animator")

        if not animator then
            task.spawn(function()
                local h=char:WaitForChild("Humanoid",3)
                local a=h and h:WaitForChild("Animator",3)
                if a and char.Parent and not killerWatchConnections[char] then
                    bindCharacter(char)
                end
            end)
            return
        end

        local conn=animator.AnimationPlayed:Connect(function(track)
            if STATE.killerAimingEnabled then
                registerTrack(char,track)
            end
        end)

        killerWatchConnections[char]=conn
        scanCurrentTracks(char)

        char.AncestryChanged:Connect(function(_,parent)
            if parent then
                return
            end

            local c=killerWatchConnections[char]
            if c then
                c:Disconnect()
            end
            killerWatchConnections[char]=nil

            local tracks=activeTracks[char]
            if tracks then
                for track in pairs(tracks) do
                    local tc=trackConnections[track]
                    if tc then
                        tc:Disconnect()
                        trackConnections[track]=nil
                    end
                end
            end

            activeTracks[char]=nil
            clearAimingLine(char)
            clearAlwaysLine(char)
            clearHeavenParts(char)
        end)
    end

    local function bindAll()
        for _,player in ipairs(Players:GetPlayers()) do
            if player.Character then
                bindCharacter(player.Character)
            end

            if not player:GetAttribute("KillerAimingBound") then
                player.CharacterAdded:Connect(function(char)
                    task.defer(function()
                        bindCharacter(char)
                    end)
                end)
                player:SetAttribute("KillerAimingBound",true)
            end
        end
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(char)
            task.defer(function()
                bindCharacter(char)
            end)
        end)
    end)

    local function setEnabled(v)
        STATE.killerAimingEnabled=v
        scanKillerRegistry()

        if not v then
            for char in pairs(aimingLines) do
                clearAimingLine(char)
            end
            for char,tracks in pairs(activeTracks) do
                for track in pairs(tracks) do
                    local conn=trackConnections[track]
                    if conn then
                        conn:Disconnect()
                        trackConnections[track]=nil
                    end
                end
            end
            activeTracks={}
            if not lineAlways then
                for char in pairs(alwaysLines) do
                    clearAlwaysLine(char)
                end
            end
            return
        end

        bindAll()

        if lineAlways then
            for _,player in ipairs(Players:GetPlayers()) do
                if player.Character and isKillerCharacter(player.Character) then
                    local char=player.Character
                    if not alwaysLines[char] then
                        createAlwaysLine(char)
                    end
                    updateAlwaysLine(char)
                end
            end
        end
    end

    local function setLineAlways(v)
        lineAlways=v
        scanKillerRegistry()
        if lineAlways then
            bindAll()
        end

        local killer=getCurrentKiller()

        if killer and lineAlways then
            if not alwaysLines[killer] then
                createAlwaysLine(killer)
            end
            updateAlwaysLine(killer)
        end

        for char in pairs(alwaysLines) do
            if char ~= killer or not lineAlways then
                clearAlwaysLine(char)
            end
        end
    end

    local function setHeavenEyes(v)
        STATE.heavenEyesEnabled=v
        scanKillerRegistry()
        if not v then
            for char in pairs(heavenParts) do
                clearHeavenParts(char)
            end
            return
        end

        bindAll()

        local killer=getCurrentKiller()
        if killer then
            updateHeavenEyes(killer)
        end
    end

    RunService.RenderStepped:Connect(function()
        scanKillerRegistry()

        if STATE.killerAimingEnabled then
            for _,player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    bindCharacter(player.Character)
                end
            end

            for char in pairs(aimingLines) do
                if not char or not char.Parent then
                    clearAimingLine(char)
                elseif not isKillerCharacter(char) then
                    clearAimingLine(char)
                elseif hasActiveRecognizedAnimation(char) then
                    updateAimingLine(char)
                else
                    clearAimingLine(char)
                end
            end
        end

        if lineAlways then
            local killer=getCurrentKiller()
            if killer then
                if not alwaysLines[killer] then
                    createAlwaysLine(killer)
                end
                updateAlwaysLine(killer)
            end
        end

        local currentKiller=getCurrentKiller()
        for char in pairs(alwaysLines) do
            if not char or not char.Parent or char ~= currentKiller or not lineAlways then
                clearAlwaysLine(char)
            end
        end

        if STATE.heavenEyesEnabled then
            for char in pairs(heavenParts) do
                if not char or not char.Parent or not isKillerCharacter(char) then
                    clearHeavenParts(char)
                end
            end
            local killer=getCurrentKiller()
            if killer then
                updateHeavenEyes(killer)
            end
        end
    end)

    return {
        setEnabled=setEnabled,
        setHeavenEyes=setHeavenEyes,
        setLineAlways=setLineAlways
    }
end)()


local function BuildUI()
    local Window=Chloex:Window({
        Title="BOLONG-HUB",
        Image="84034353458936",
        Footer="Violence District",
        Author="Discord.gg/pWpgqVGxNK",
        Color=ACCENT_COLOR,
        Version=1,
        Search=true,
        Folder="BolongHub"
    })

    local ExclusiveTab=Window:AddTab({
        Name="Exclusive",
        Icon="sparkles"
    })

    local APSection=ExclusiveTab:AddSection("Auto Parry",nil)
    local APH1=APSection:AddHStack()

    local AimSection=ExclusiveTab:AddSection("Killer Visuals",nil)

AimSection:AddToggle({
        Title="Line of Sight",
        Default=false,
        Callback=function(v)
            KillerAimingFeature.setEnabled(v)
        end
    })

    AimSection:AddToggle({
        Title="Line Always",
        Default=false,
        Callback=function(v)
            KillerAimingFeature.setLineAlways(v)
        end
    })

    AimSection:AddToggle({
        Title="Heaven eyes",
        Default=false,
        Callback=function(v)
            KillerAimingFeature.setHeavenEyes(v)
        end
    })

    APH1:AddToggle({
        Title="Auto Parry",
        Default=false,
        Callback=function(v)
            STATE.autoParryEnabled=v

            if not v then
                STATE.activeAttackers={}
                STATE.activeSkillAttackers={}
                STATE.maskedLungeArmed={}
                STATE.maskedSequence={}
                STATE.hiddenSequence={}
            end
        end
    })

    APH1:AddToggle({
        Title="Radius ESP",
        Default=false,
        Callback=function(v)
            STATE.autoParryRadiusEsp=v

            if toggleAutoParryESP then
                toggleAutoParryESP(v)
            end
        end
    })

    APSection:AddToggle({
        Title="The Hidden",
        Default=false,
        Callback=function(v)
            STATE.ignoredTheHidden=v

            if v then
                STATE.hiddenSequence={}
            end
        end
    })

    APSection:AddToggle({
        Title="The Abysswalker",
        Default=false,
        Callback=function(v)
            STATE.ignoredTheAbysswalker=v

            if v then
                for char,data in pairs(STATE.activeSkillAttackers) do
                    if data and data.skillId==ABYSSWALKER_ANIM_ID then
                        STATE.activeSkillAttackers[char]=nil
                    end
                end
            end
        end
    })

    APSection:AddToggle({
        Title="The Masked (Duck)",
        Default=false,
        Callback=function(v)
            STATE.ignoredTheMaskedDuck=v

            if v then
                for char,data in pairs(STATE.activeAttackers) do
                    if data.name and (
                        data.name:lower()=="the masked (duck)"
                        or data.name:lower()=="the masked"
                    ) then
                        STATE.activeAttackers[char]=nil
                    end
                end

                for char,data in pairs(STATE.activeSkillAttackers) do
                    if data.name and (
                        data.name:lower()=="the masked (duck)"
                        or data.name:lower()=="the masked"
                    ) then
                        STATE.activeSkillAttackers[char]=nil
                    end
                end

                STATE.maskedLungeArmed={}
                STATE.maskedSequence={}
            end
        end
    })

    APSection:AddSlider({
        Title="Parry Radius (Stud)",
        Min=4,
        Max=40,
        Default=10,
        Increment=1,
        Callback=function(v)
            STATE.autoParryRadius=v
        end
    })

    APSection:AddSlider({
        Title="Face Killer Sensitivity",
        Min=-1,
        Max=1,
        Default=-1,
        Increment=0.1,
        Callback=function(v)
            STATE.faceKillerSensitivity=math.clamp(v,-1,1)
        end
    })

    APSection:AddSlider({
        Title="Aim Strictness",
        Min=0.1,
        Max=3,
        Default=1.0,
        Increment=0.1,
        Callback=function(v)
            STATE.aimStrictness=v
        end
    })
end

BuildUI()
print("BOLONGHUB LITE LOADED!")
