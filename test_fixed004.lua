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
    faceKillerSensitivity=0.1,
    parryVisualPulseAt=0,
    parryVisualExpandAt=0,
    parryVisualCollapseTime=1.0,
    parryVisualExpandTime=1.0,
    ignoredTheHidden=false,
    ignoredTheAbysswalker=false,
    ignoredTheMaskedDuck=false,
    lastParryTime=0,
    lastSkillParryTime=0,
    activeAttackers={},
    activeSkillAttackers={},
    maskedLungeArmed={},
    maskedSequence={},
    hiddenSequence={},
    killerCharacters={}
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

do
    local SKILL_ANIM_ID=98163597193511
    local HIDDEN_WALK_ANIM_ID=88848807662765
    local HIDDEN_WIPE_MACHETE_ID=73681849513551
    local ABYSSWALKER_ANIM="rbxassetid://"..ABYSSWALKER_ANIM_ID
    local INSTANT_ANIM_ID="rbxassetid://"..SKILL_ANIM_ID

    local HIDDEN_ARM_TIME=0.300
    local HIDDEN_WALK_RANGE=18
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

    local CLOSE_RANGE=4.5
    local HARD_CLOSE_RANGE=2.75
    local MIN_CLOSING_SPEED=2
    local EMERGENCY_TIME=0.18
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

    local function sendParryInput()
        local char=localPlayer.Character

        if not char then
            return
        end

        local mobGui=PlayerGui:FindFirstChild("Survivor-mob")
        local controls=mobGui and mobGui:FindFirstChild("Controls")
        local btn=controls and controls:FindFirstChild("Gui-mob")

        if btn and btn:IsA("ImageButton") then
            firesignal(btn.MouseButton1Down)

            task.defer(function()
                if btn and btn.Parent then
                    firesignal(btn.MouseButton1Up)
                end
            end)
        else
            local ok,fakeInput=pcall(function()
                local obj=Instance.new("InputObject")
                obj.UserInputType=Enum.UserInputType.MouseButton2
                obj.UserInputState=Enum.UserInputState.Begin
                return obj
            end)

            if ok and fakeInput then
                for _,conn in getconnections(UserInputService.InputBegan) do
                    conn:Fire(fakeInput,false)
                end
            else
                VirtualInputManager:SendMouseButtonEvent(0,0,1,true,game,0)
            end
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

    local function parryInputAvailable(now)
        if now-STATE.lastParryTime<0.01 then
            return false
        end

        if now-STATE.lastSkillParryTime<0.01 then
            return false
        end

        return true
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
                pallet=false
            }
        end

        local flat=Vector3.new(direction.X,0,direction.Z)
        local flatUnit=flat.Magnitude>0.05 and flat.Unit or Vector3.zero
        local right=flatUnit:Cross(Vector3.new(0,1,0))

        local rayData={
            {origin,target},
            {origin+Vector3.new(0,1.1,0),target+Vector3.new(0,1.1,0)},
            {origin+Vector3.new(0,-0.75,0),target+Vector3.new(0,-0.75,0)},
            {origin+right*EDGE_TOLERANCE,target+right*EDGE_TOLERANCE},
            {origin-right*EDGE_TOLERANCE,target-right*EDGE_TOLERANCE},
            {origin+right*(EDGE_TOLERANCE*0.55)+Vector3.new(0,0.75,0),target+right*(EDGE_TOLERANCE*0.55)+Vector3.new(0,0.75,0)},
            {origin-right*(EDGE_TOLERANCE*0.55)+Vector3.new(0,0.75,0),target-right*(EDGE_TOLERANCE*0.55)+Vector3.new(0,0.75,0)}
        }

        local localHead=localChar and localChar:FindFirstChild("Head")
        local killerHead=extraIgnore and extraIgnore:FindFirstChild("Head")

        if localHead and killerHead then
            table.insert(rayData,{
                localHead.Position,
                killerHead.Position
            })
        end

        local clearCount=0
        local blockedCount=0
        local vaultHit=false
        local palletHit=false

        for _,pair in ipairs(rayData) do
            local result=Workspace:Raycast(pair[1],pair[2]-pair[1],params)

            if not result then
                clearCount=clearCount+1
            else
                blockedCount=blockedCount+1

                local hit=result.Instance

                if hit then
                    local n=hit.Name:lower()

                    if n:find("vault") or n:find("window") or n:find("ledge") then
                        vaultHit=true
                    end

                    if n:find("pallet") or n:find("plank") then
                        palletHit=true
                    end
                end
            end
        end

        return {
            clear=clearCount>=4,
            blocked=blockedCount>=4,
            vault=vaultHit,
            pallet=palletHit,
            clearCount=clearCount,
            blockedCount=blockedCount
        }
    end

    local function doParry(force,killerChar,distance,allowPredictedRange)
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

            local obstacle=getObstacleState(
                localRoot.Position,
                killerRoot.Position,
                killerChar
            )

            if obstacle.blocked then
                local vaultAllowed=allowVault
                    and obstacle.vault
                    and distance<=allowedRange+VAULT_EXTRA_RANGE

                local palletAllowed=allowVault
                    and obstacle.pallet
                    and distance<=allowedRange

                if not vaultAllowed
                and not palletAllowed
                and not allowPredictedRange then
                    return false
                end
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
        local strictness=math.clamp(STATE.faceKillerSensitivity,-1,1)

        if strictness<=-1 then
            return -1
        end

        local t=(strictness+1)/2

        return 0.05+(t*0.12)
    end

    local function isFacingLocalPlayer(killerChar)
        if STATE.faceKillerSensitivity<=-1 then
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

        local baseAngle=math.deg(math.acos(math.clamp(math.max(0,threshold),-1,1)))
        local faceThreshold=math.cos(math.rad(math.min(90,baseAngle)))

        if dot>=faceThreshold then
            return true
        end

        local velocity=killerRoot.AssemblyLinearVelocity
        local flatVelocity=Vector3.new(velocity.X,0,velocity.Z)

        if flatVelocity.Magnitude>6 then
            local velocityDot=flatVelocity.Unit:Dot(flatDirection.Unit)

            if velocityDot>=math.max(threshold-0.08,0.35) then
                return true
            end
        end

        return false
    end

    local function canNormalAttackParry(killerChar,distance,closingSpeed,predictedDistance)
        if distance>STATE.autoParryRadius then
            return false
        end

        if STATE.faceKillerSensitivity<=-1 then
            return true
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

        if closingSpeed and predictedDistance then
            if closingSpeed>=3.5 and predictedDistance<=STATE.autoParryRadius then
                return true
            end
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

    local function hiddenIsComingFromFront(char)
        local localChar=localPlayer.Character
        local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")
        local head=char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))

        if not localRoot or not head then
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

        if tick()>seq.expires then
            return false
        end

        if not hiddenIsComingFromFront(char) then
            return false
        end

        local distance=getSkillDistance(char)

        if distance<=HIDDEN_WALK_RANGE then
            return true
        end

        local predictedDistance=getPredictedDistance(char,0.42)

        return predictedDistance<=HIDDEN_WALK_RANGE
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

    local function registerSkillAttack(char,kName,track)
        if typeof(kName)~="string" or kName:lower()~="the hidden" then
            return
        end

        if isIgnoredSkillKiller(kName) then
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
            armTime=0,
            armed=false,
            walkTrack=nil,
            walkSeen=false,
            walkTracks={},
            consumed=false,
            parried=false,
            expires=now+HIDDEN_SEQUENCE_TIME
        }

        STATE.hiddenSequence[char]=seq

        local currentWalkTracks=getHiddenWalkTracks(char)

        for walkTrack in pairs(currentWalkTracks) do
            registerHiddenWalk(char,walkTrack)

            if not STATE.hiddenSequence[char] then
                break
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

        for killerChar,seq in pairs(STATE.hiddenSequence) do
            if not killerChar or not killerChar.Parent or not seq then
                clearHiddenSequence(killerChar)
            elseif seq.consumed then
                clearHiddenSequence(killerChar)
            elseif tick()>seq.expires then
                clearHiddenSequence(killerChar)
            else
                if seq.skillTrack and seq.skillTrack.IsPlaying then
                    local position=seq.skillTrack.TimePosition or 0

                    seq.armTime=position

                    if position>=HIDDEN_ARM_TIME then
                        seq.armed=true
                    end

                    seq.skillLongEnough=true

                    local currentWalkTracks=getHiddenWalkTracks(killerChar)

                    for walkTrack in pairs(currentWalkTracks) do
                        registerHiddenWalk(killerChar,walkTrack)

                        if not STATE.hiddenSequence[killerChar] then
                            break
                        end
                    end
                elseif seq.armed and not seq.skillFinished then
                    seq.skillFinished=true
                    seq.finishedAt=tick()
                    seq.expires=tick()+HIDDEN_SEQUENCE_TIME

                    local currentWalkTracks=getHiddenWalkTracks(killerChar)

                    for walkTrack in pairs(currentWalkTracks) do
                        registerHiddenWalk(killerChar,walkTrack)

                        if not STATE.hiddenSequence[killerChar] then
                            break
                        end
                    end
                elseif not seq.armed and seq.skillTrack and not seq.skillTrack.IsPlaying then
                    clearHiddenSequence(killerChar)
                end

                local current=STATE.hiddenSequence[killerChar]

                if current and current.armed and current.skillFinished then
                    local currentWalkTracks=getHiddenWalkTracks(killerChar)

                    for walkTrack in pairs(currentWalkTracks) do
                        registerHiddenWalk(killerChar,walkTrack)

                        if not STATE.hiddenSequence[killerChar] then
                            break
                        end
                    end

                    current=STATE.hiddenSequence[killerChar]

                    if current and current.walkSeen then
                        hiddenTryWalkParry(killerChar,current)
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
                if currentName:lower()=="the hidden" then
                    registerSkillAttack(char,currentName,track)
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

                task.delay(0.15,function()
                    if STATE.activeAttackers[char]
                    and STATE.activeAttackers[char].track==track then
                        STATE.activeAttackers[char]=nil
                    end
                end)
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

                    local position=data.track.TimePosition or 0
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

    RunService.Heartbeat:Connect(function()
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
    end)

    RunService.Heartbeat:Connect(function()
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

                    local emergency=false

                    if distance<=HARD_CLOSE_RANGE then
                        emergency=true
                    elseif distance<=CLOSE_RANGE and closingSpeed>=MIN_CLOSING_SPEED then
                        local timeToImpact=distance/closingSpeed

                        if timeToImpact<=EMERGENCY_TIME
                        or predictedDistance<=STATE.autoParryRadius then
                            emergency=true
                        end
                    elseif distance<=STATE.autoParryRadius
                    and closingSpeed>=2
                    and predictedDistance<=STATE.autoParryRadius then
                        emergency=true
                    end

                    if emergency then
                        if canNormalAttackParry(
                            killerChar,
                            distance,
                            closingSpeed,
                            predictedDistance
                        ) then

                            if doParry(true,killerChar,distance) then
                                data.consumed=true
                            end
                        end
                    elseif animationReady and attackWindowOpen then
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

                local humanoid=localPlayer.Character:FindFirstChildOfClass("Humanoid")
                local root=(humanoid and humanoid.RootPart)
                    or localPlayer.Character:FindFirstChild("HumanoidRootPart")

                if not root then
                    return
                end

                local radius=STATE.autoParryRadius
                local now=tick()
                local pulseAt=STATE.parryVisualPulseAt or 0
                local expandAt=STATE.parryVisualExpandAt or 0

                if pulseAt>0 then
                    local elapsed=now-pulseAt

                    if elapsed<STATE.parryVisualCollapseTime then
                        local t=math.clamp(
                            elapsed/STATE.parryVisualCollapseTime,
                            0,
                            1
                        )
                        radius=STATE.autoParryRadius*(1-t)
                    elseif not parryInputAvailable(now) then
                        radius=0
                    else
                        if expandAt<=0 then
                            STATE.parryVisualExpandAt=now
                            expandAt=now
                        end

                        local expandElapsed=now-expandAt
                        local t=math.clamp(
                            expandElapsed/STATE.parryVisualExpandTime,
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
        Default=0.1,
        Increment=0.1,
        Callback=function(v)
            STATE.faceKillerSensitivity=v
        end
    })

end

BuildUI()
print("BOLONGHUB LITE LOADED!")
