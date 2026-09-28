local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Workspace=game:GetService("Workspace")

local localPlayer=Players.LocalPlayer
local PlayerGui=localPlayer:WaitForChild("PlayerGui")

local Chloex
do
    local ok,result=pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/RillBoys/bolong.catui/main/b0lngUi.lua"))()
    end)
    if ok and result then
        Chloex=result
    else
        error("Library file not found: b0lngUi.lua")
    end
end

local VERSION="Killer Visuals Only"
local ACCENT_COLOR=Color3.fromRGB(248,248,255)
local BASE_VISUAL_COLOR=Color3.fromRGB(248,248,255)

local STATE={
    alwaysLineLength=50,
    heavenEyesEnabled=false,
    killerCharacters={},
}

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

local function sharedIsSpectatorTeam(player)
    if not player or not player.Team then
        return false
    end
    local teamName=player.Team.Name
    return typeof(teamName)=="string"
        and teamName:lower():gsub("%s+",""):find("spectator",1,true)~=nil
end

local function sharedIsKillerTeam(player)
    if not player or not player.Team or sharedIsSpectatorTeam(player) then
        return false
    end
    local teamName=player.Team.Name
    return typeof(teamName)=="string" and teamName:lower():find("killer",1,true)~=nil
end

local function sharedHasKillerMobMarker(char)
    if not char or not char.Parent then
        return false
    end

    local direct=char:FindFirstChild("Killer-mob")
        or char:FindFirstChild("KillerMob")
        or char:FindFirstChild("killer-mob")
        or char:FindFirstChild("killerMob")

    return direct~=nil
end

local KillerAimingFeature=(function()
    local activeTracks={}
    local trackConnections={}
    local alwaysLines={}
    local alwaysYellowLines={}
    local heavenParts={}
    local killerWatchConnections={}
    local lineAlways=false
    local lastRegistryScan=0

    local MAX_LENGTH=100
    local LINE_THICKNESS=0.09
    local HEAVEN_DISTANCE=18.0
    local HEAVEN_HEIGHT=0.33
    local HEAVEN_WIDTH=7.85
    local WHITE=Color3.fromRGB(248,248,255)
    local YELLOW=Color3.fromRGB(199,21,133)
    local MEDIUM_VIOLET_RED=Color3.fromRGB(199,21,133)

    local function numericId(track)
        if not track then
            return nil
        end

        local raw=nil
        pcall(function()
            if track.Animation then
                raw=track.Animation.AnimationId
            end
        end)

        if raw==nil then
            pcall(function()
                raw=track.AnimationId
            end)
        end

        local text=tostring(raw or "")
        local id=text:match("%d+")
        return id and tonumber(id) or nil
    end

    local function scanKillerRegistry()
        for _,player in ipairs(Players:GetPlayers()) do
            if player~=localPlayer
            and not sharedIsSpectatorTeam(player)
            and player.Character
            and player.Character.Parent then
                local char=player.Character
                local detectedName=sharedGetKillerName(player,char)
                local teamKiller=sharedIsKillerTeam(player)
                local killerMob=sharedHasKillerMobMarker(char)
                local known=STATE.killerCharacters[char]

                if detectedName or teamKiller or killerMob then
                    STATE.killerCharacters[char]={
                        player=player,
                        name=detectedName or (known and known.name) or "Killer"
                    }
                elseif known and known.player==player and known.name
                and known.name~="Unknown Killer" then
                    STATE.killerCharacters[char]=known
                end
            end
        end

        for char,data in pairs(STATE.killerCharacters) do
            local player=data and data.player
            if not char or not char.Parent
            or not player or player.Character~=char then
                STATE.killerCharacters[char]=nil
            end
        end
    end

    local function isKillerCharacter(char)
        if not char or not char.Parent or char==localPlayer.Character then
            return false
        end

        local player=Players:GetPlayerFromCharacter(char)
        local data=STATE.killerCharacters[char]

        if player and sharedIsSpectatorTeam(player) then
            STATE.killerCharacters[char]=nil
            return false
        end

        if player then
            local detectedName=sharedGetKillerName(player,char)
            local teamKiller=sharedIsKillerTeam(player)
            local killerMob=sharedHasKillerMobMarker(char)

            if detectedName or teamKiller or killerMob then
                local name=detectedName
                    or (data and data.name)
                    or "Killer"

                STATE.killerCharacters[char]={
                    player=player,
                    name=name
                }
                return true
            end

            if data and data.player==player
            and data.name
            and data.name~="Unknown Killer" then
                return true
            end
        end

        return data~=nil
            and data.name~=nil
            and data.name~="Unknown Killer"
    end

    local function setBeamColor(beam,color)
        if not beam or not beam.Parent then
            return false
        end
        beam.Color=ColorSequence.new(color)
        return true
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
        if data.startAttachment and data.startAttachment.Parent then
            data.startAttachment:Destroy()
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
        beam.Width0=0.12
        beam.Width1=0.12
        beam.Transparency=NumberSequence.new(0.45)
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

    local function updateLine(data,char,forcedLength)
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
        local length=math.clamp(tonumber(forcedLength) or tonumber(STATE.alwaysLineLength) or 50,10,100)
        data.endpointPart.CFrame=CFrame.new(origin+direction*length)
        data.length=length
        data.startAttachment.Position=Vector3.zero
        data.endpointAttachment.Position=Vector3.zero
    end

    local function clearAlwaysLine(char)
        clearLine(alwaysLines,char)
        clearLine(alwaysYellowLines,char)
    end

    local function createAlwaysLine(char)
        local data=createLine(alwaysLines,char,WHITE,"LineOfSightAlways")
        if data then
            data.color=WHITE
        end
        return data
    end

    local function createAlwaysYellowLine(char)
        local data=alwaysYellowLines[char]
        if data then return data end
        data=createLine(alwaysYellowLines,char,YELLOW,"LineOfSightAlwaysYellow")
        if data and data.beam then
            data.beam.Width0=0.12
            data.beam.Width1=0.12
            data.beam.Enabled=true
        end
        return data
    end

    local function hasActiveYellowAnimation(char)
        local liveColor=getLiveAnimationColor(char)
        if liveColor==MEDIUM_VIOLET_RED then
            return true
        end

        local tracks=activeTracks[char]
        if not tracks then
            return false
        end

        local yellowActive=false
        for track,data in pairs(tracks) do
            if not track or not track.IsPlaying then
                tracks[track]=nil
                local conn=trackConnections[track]
                if conn then
                    conn:Disconnect()
                    trackConnections[track]=nil
                end
            elseif data and data.special then
                yellowActive=true
            end
        end

        if next(tracks)==nil then
            activeTracks[char]=nil
        end

        return yellowActive
    end

    local SHARED_WHITE_ANIMS = {
        [75258958842388]=true,
        [96744338559260]=true,
        [137846825408335]=true,
        [139928639611415]=true
    }

    local SHARED_SPECIAL_ANIMS = {
        [92098503722633]=true,
        [84093948968516]=true,
        [138045669415653]=true,
        [137688077908355]=true,
        [117886494230451]=true,
        [98163597193511]=true
    }

    local function getSharedLineVisualColor(char)
        local humanoid=char and char:FindFirstChildOfClass("Humanoid")
        local animator=humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            return WHITE
        end

        local hasWhite=false

        for _,track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track and track.IsPlaying then
                local id=numericId(track)

                if id and SHARED_SPECIAL_ANIMS[id] then
                    return MEDIUM_VIOLET_RED
                end

                if id and SHARED_WHITE_ANIMS[id] then
                    hasWhite=true
                end
            end
        end

        if hasWhite then
            return BASE_VISUAL_COLOR
        end

        return WHITE
    end

    local function getAlwaysLineSpecialColor(char)
        local color=getSharedLineVisualColor(char)
        if color==MEDIUM_VIOLET_RED then
            return color
        end
        return nil
    end

    local function updateAlwaysLine(char)
        if not char or not char.Parent then
            return
        end

        -- Recreate the line if its visual objects disappeared.
        local data=alwaysLines[char]
        if not data
        or not data.beam
        or not data.beam.Parent
        or not data.endpointPart
        or not data.endpointPart.Parent
        or not data.startAttachment
        or not data.startAttachment.Parent
        or not data.endpointAttachment
        or not data.endpointAttachment.Parent then
            data=createAlwaysLine(char)
        end

        if not data then
            return
        end

        updateLine(data,char)

        local color=getSharedLineVisualColor(char)
        data.color=color

        if data.beam and data.beam.Parent then
            setBeamColor(data.beam,color)
            data.beam.Width0=0.12
            data.beam.Width1=0.12
            data.beam.Transparency=NumberSequence.new(0.45)
            data.beam.Enabled=true
        end

        clearLine(alwaysYellowLines,char)
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
        part.CFrame=CFrame.lookAt((a+b)*0.5,b)
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
        if list and #list==9 then
            return list
        end

        if list then
            for _,part in ipairs(list) do
                if part then
                    part:Destroy()
                end
            end
        end

        list={}
        for i=1,9 do
            list[i]=makeHeavenPart("HeavenEyesLine")
        end
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

        local flatForward=Vector3.new(root.CFrame.LookVector.X,0,root.CFrame.LookVector.Z)
        if flatForward.Magnitude<=0.01 then
            return
        end
        flatForward=flatForward.Unit

        local right=Vector3.new(-flatForward.Z,0,flatForward.X)
        local groundY=root.Position.Y-3.0

        local halfWidth=7.85
        local depth=11.5
        local arcBulge=3.0

        local apex=Vector3.new(
            root.Position.X + flatForward.X*0.8,
            groundY,
            root.Position.Z + flatForward.Z*0.8
        )

        local leftEnd=Vector3.new(
            root.Position.X + flatForward.X*depth - right.X*halfWidth,
            groundY,
            root.Position.Z + flatForward.Z*depth - right.Z*halfWidth
        )

        local rightEnd=Vector3.new(
            root.Position.X + flatForward.X*depth + right.X*halfWidth,
            groundY,
            root.Position.Z + flatForward.Z*depth + right.Z*halfWidth
        )

        local parts=ensureHeavenParts(char)

        pointPart(parts[1],apex,leftEnd)
        pointPart(parts[2],apex,rightEnd)

        local arcPoints={}
        for i=0,7 do
            local t=i/7
            local lateral=(-halfWidth)+(2*halfWidth*t)
            local bulge=math.sin(math.pi*t)*arcBulge
            local p=root.Position
                + flatForward*(depth+bulge)
                + right*lateral
            arcPoints[i+1]=Vector3.new(p.X,groundY,p.Z)
        end

        for i=1,7 do
            pointPart(parts[i+2],arcPoints[i],arcPoints[i+1])
        end

        for _,part in ipairs(parts) do
            part.Color=WHITE
            part.Material=Enum.Material.Neon
            part.Transparency=0.02
        end
    end

    local function setEnabled(v)
        scanKillerRegistry()
        if not v then
            return
        end
        bindAll()
        if lineAlways then
            for _,player in ipairs(Players:GetPlayers()) do
                if player~=localPlayer and player.Character and isKillerCharacter(player.Character) then
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

        for _,player in ipairs(Players:GetPlayers()) do
            if player~=localPlayer and player.Character then
                local char=player.Character
                if isKillerCharacter(char) then
                    if lineAlways then
                        if not alwaysLines[char] then
                            createAlwaysLine(char)
                        end
                        updateAlwaysLine(char)
                    else
                        clearAlwaysLine(char)
                    end
                else
                    clearAlwaysLine(char)
                end
            end
        end
    end

    local function setAlwaysLineLength(v)
        local length=math.clamp(tonumber(v) or 50,10,100)
        STATE.alwaysLineLength=length
        for char,data in pairs(alwaysLines) do
            if data then data.length=length end
            if char and char.Parent then
                updateAlwaysLine(char)
            end
        end
        for char,data in pairs(alwaysYellowLines) do
            if data then data.length=length end
            if char and char.Parent then
                updateLine(data,char)
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

        for _,player in ipairs(Players:GetPlayers()) do
            if player~=localPlayer and player.Character and isKillerCharacter(player.Character) then
                updateHeavenEyes(player.Character)
            end
        end
    end

    RunService.RenderStepped:Connect(function()
        local now=tick()
        if now-lastRegistryScan>=0.1 then
            scanKillerRegistry()
            lastRegistryScan=now
        end

        pcall(function()
            if lineAlways then
                for _,player in ipairs(Players:GetPlayers()) do
                    if player~=localPlayer and player.Character then
                        local char=player.Character
                        if isKillerCharacter(char) then
                            if not alwaysLines[char]
                            or not alwaysLines[char].beam
                            or not alwaysLines[char].beam.Parent then
                                createAlwaysLine(char)
                            end
                            updateAlwaysLine(char)

                        else
                            clearAlwaysLine(char)
                        end
                    end
                end
            end

            for char in pairs(alwaysLines) do
                if not char or not char.Parent or not isKillerCharacter(char) or not lineAlways then
                    clearAlwaysLine(char)
                end
            end
        end)

        pcall(function()
            if STATE.heavenEyesEnabled then
                for char in pairs(heavenParts) do
                    local confirmed=(char and char.Parent and (
                        isKillerCharacter(char) or STATE.killerCharacters[char]~=nil
                    ))
                    if not confirmed then
                        clearHeavenParts(char)
                    end
                end

                for _,player in ipairs(Players:GetPlayers()) do
                    if player~=localPlayer and player.Character then
                        local char=player.Character
                        if isKillerCharacter(char) or STATE.killerCharacters[char]~=nil then
                            updateHeavenEyes(char)
                        end
                    end
                end
            end
        end)
    end)

    return {
        setEnabled=setEnabled,
        setHeavenEyes=setHeavenEyes,
        setLineAlways=setLineAlways,
        setAlwaysLineLength=setAlwaysLineLength,
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

    local AimSection=ExclusiveTab:AddSection("Killer Visuals",nil)

    AimSection:AddToggle({
        Title="Line Always",
        Default=false,
        Callback=function(v)
            KillerAimingFeature.setLineAlways(v)
        end
    })

    AimSection:AddToggle({
        Title="Sensory Range",
        Default=false,
        Callback=function(v)
            KillerAimingFeature.setHeavenEyes(v)
        end
    })

    local LineLengthSection=AimSection:AddHStack()

    LineLengthSection:AddSlider({
        Title="Always Length",
        Min=10,
        Max=100,
        Default=50,
        Increment=1,
        Callback=function(v)
            KillerAimingFeature.setAlwaysLineLength(v)
        end
    })
end

BuildUI()
print("BOLONGHUB KILLER VISUALS ONLY LOADED!")
