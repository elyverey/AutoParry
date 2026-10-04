Players = game:GetService("Players")
RunService = game:GetService("RunService")
TweenService = game:GetService("TweenService")
Workspace = game:GetService("Workspace")
Lighting = game:GetService("Lighting")
UserInputService = game:GetService("UserInputService")
GuiService = game:GetService("GuiService")

activeTouchInputs = {}
activeTouchCount = 0


function addTwoBubbles(parent, size)
    local bubbles = {}
    for i = 1, 2 do
        local b = Instance.new("Frame")
        b.Name = "Bubble" .. i
        b.Size = UDim2.fromOffset(size, size)
        b.BackgroundTransparency = 0.15
        b.BorderSizePixel = 0
        b.ZIndex = parent.ZIndex + 1
        b.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = b

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Transparency = 0.35
        stroke.Parent = b

        table.insert(bubbles, b)
    end

    local function animate(b, startX, delayTime)
        task.spawn(function()
            task.wait(delayTime)
            while b.Parent do
                b.Position = UDim2.new(0, startX, 1, 2)
                b.BackgroundTransparency = 0.15
                local tween = TweenService:Create(
                    b,
                    TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                    {
                        Position = UDim2.new(0, startX + 3, 0, -10),
                        BackgroundTransparency = 1,
                    }
                )
                tween:Play()
                tween.Completed:Wait()
                task.wait(0.15)
            end
        end)
    end

    animate(bubbles[1], math.floor(parent.AbsoluteSize.X * 0.32), 0)
    animate(bubbles[2], math.floor(parent.AbsoluteSize.X * 0.58), 0.65)
end

function hasMultipleTouches()
    local ok, touches = pcall(function()
        return UserInputService:GetTouches()
    end)
    if ok and touches then
        return #touches >= 2
    end
    return activeTouchCount >= 2
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        if not activeTouchInputs[input] then
            activeTouchInputs[input] = true
            activeTouchCount = activeTouchCount + 1
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and activeTouchInputs[input] then
        activeTouchInputs[input] = nil
        activeTouchCount = math.max(0, activeTouchCount - 1)
    end
end)
SoundService = game:GetService("SoundService")

localPlayer = Players.LocalPlayer
PlayerGui = localPlayer:WaitForChild("PlayerGui")

RoundRoleEndAt = 0

RoundTimerState = {
    enabled = false,
    duration = 0,
    endAt = 0,
    gui = nil,
    panel = nil,
    label = nil,
    statsLabel = nil,
    fps = 0,
    fpsFrames = 0,
    fpsLast = 0,
    phase = "WAITING",
    startedAt = 0,
}

local function getServerNow()
    local ok, value = pcall(function()
        return Workspace:GetServerTimeNow()
    end)
    if ok and type(value) == "number" then
        return value
    end
    return time()
end

local function getCurrentPing()
    local ok, value = pcall(function()
        local stats = game:GetService("Stats")
        local network = stats:FindFirstChild("Network")
        local serverStats = network and network:FindFirstChild("ServerStatsItem")
        local dataPing = serverStats and serverStats:FindFirstChild("Data Ping")
        if dataPing then
            return math.floor(dataPing:GetValue() + 0.5)
        end
        return 0
    end)
    if ok and type(value) == "number" then
        return math.max(0, value)
    end
    return 0
end

local function setRoundTimerGuiVisible(visible)
    if RoundTimerState.gui then
        RoundTimerState.gui.Enabled = visible == true
    end
end

local function ensureRoundTimerGui()
    if RoundTimerState.gui and RoundTimerState.gui.Parent then
        return
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "BolongRoundTimer"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.Enabled = true
    gui.Parent = PlayerGui

    local panel = Instance.new("Frame")
    panel.Name = "RoundTimerPanel"
    panel.AnchorPoint = Vector2.new(0.5, 0)
    panel.Position = UDim2.new(0.5, 0, 0, 12)
    panel.Size = UDim2.fromOffset(150, 40)
    panel.BackgroundColor3 = Color3.fromRGB(40, 190, 255)
    panel.BackgroundTransparency = 0.77
    panel.BorderSizePixel = 0
    panel.Visible = RoundTimerState.enabled
    panel.Parent = gui
    panel.ClipsDescendants = true

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 205, 255)),
        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(40, 190, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 155, 235)),
    })
    gradient.Parent = panel

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 11)
    corner.Parent = panel

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 195, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.12
    stroke.Parent = panel

    local label = Instance.new("TextLabel")
    label.Name = "RoundTimer"
    label.Position = UDim2.fromOffset(5, 3)
    label.Size = UDim2.new(1, -10, 0, 21)
    label.BackgroundTransparency = 1
    label.Text = "0:00"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeColor3 = Color3.fromRGB(0, 100, 180)
    label.TextStrokeTransparency = 0.55
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Active = false
    label.Selectable = false
    label.ZIndex = 5
    label.Active = false
    label.Selectable = false
    label.Parent = panel

    local statsLabel = Instance.new("TextLabel")
    statsLabel.Name = "ClientStats"
    statsLabel.Position = UDim2.fromOffset(5, 24)
    statsLabel.Size = UDim2.new(1, -10, 0, 12)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Text = "FPS 60    Ping 0ms"
    statsLabel.TextColor3 = Color3.new(1, 1, 1)
    statsLabel.TextStrokeColor3 = Color3.fromRGB(0, 100, 180)
    statsLabel.TextStrokeTransparency = 0.65
    statsLabel.Font = Enum.Font.GothamSemibold
    statsLabel.TextSize = 10
    statsLabel.TextXAlignment = Enum.TextXAlignment.Center
    statsLabel.TextYAlignment = Enum.TextYAlignment.Center
    statsLabel.ZIndex = 5
    statsLabel.Active = false
    statsLabel.Selectable = false
    statsLabel.Parent = panel

    local bubbleContainer = Instance.new("Frame")
    bubbleContainer.Name = "Bubbles"
    bubbleContainer.Size = UDim2.fromScale(1, 1)
    bubbleContainer.BackgroundTransparency = 1
    bubbleContainer.ClipsDescendants = true
    bubbleContainer.ZIndex = 2
    bubbleContainer.Parent = panel

    local bubbleData = {
        {x = 0.18, y = 0.72, size = 5, delay = 0.00, duration = 1.8},
        {x = 0.38, y = 0.84, size = 4, delay = 0.45, duration = 1.6},
        {x = 0.67, y = 0.68, size = 6, delay = 0.90, duration = 1.9},
        {x = 0.84, y = 0.82, size = 4, delay = 1.25, duration = 1.7},
    }

    for i, data in ipairs(bubbleData) do
        local bubble = Instance.new("Frame")
        bubble.Name = "Bubble" .. i
        bubble.Size = UDim2.fromOffset(data.size, data.size)
        bubble.Position = UDim2.fromScale(data.x, data.y)
        bubble.AnchorPoint = Vector2.new(0.5, 0.5)
        bubble.BackgroundColor3 = Color3.fromRGB(235, 250, 255)
        bubble.BackgroundTransparency = 0.25
        bubble.BorderSizePixel = 0
        bubble.ZIndex = 2
        bubble.Parent = bubbleContainer

        local bubbleCorner = Instance.new("UICorner")
        bubbleCorner.CornerRadius = UDim.new(1, 0)
        bubbleCorner.Parent = bubble

        task.spawn(function()
            task.wait(data.delay)
            while bubble.Parent do
                bubble.Position = UDim2.fromScale(data.x, 0.92)
                bubble.Size = UDim2.fromOffset(data.size, data.size)
                bubble.BackgroundTransparency = 0.15
                local tween = TweenService:Create(
                    bubble,
                    TweenInfo.new(data.duration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                    {
                        Position = UDim2.fromScale(data.x + 0.025, 0.08),
                        Size = UDim2.fromOffset(data.size + 2, data.size + 2),
                        BackgroundTransparency = 0.78
                    }
                )
                tween:Play()
                tween.Completed:Wait()
                task.wait(0.12)
            end
        end)
    end

    RoundTimerState.gui = gui
    RoundTimerState.panel = panel
    RoundTimerState.label = label
    RoundTimerState.statsLabel = statsLabel
    RoundTimerState.ball = nil
    RoundTimerState.bubbleContainer = bubbleContainer
    RoundTimerState.fpsLast = time()

    local timerDragging = false
    local timerDragInput = nil
    local timerDragStart = nil
    local timerStartPos = nil
    panel.Active = true

    panel.InputBegan:Connect(function(input)
        if timerDragging then
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            timerDragging = true
            timerDragInput = input
            timerDragStart = input.Position
            timerStartPos = panel.Position
            uiPanelTouchActive = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if timerDragging and input == timerDragInput then
            local delta = input.Position - timerDragStart
            panel.Position = UDim2.new(
                timerStartPos.X.Scale,
                timerStartPos.X.Offset + delta.X,
                timerStartPos.Y.Scale,
                timerStartPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if timerDragging and input == timerDragInput then
            timerDragging = false
            timerDragInput = nil
            uiPanelTouchActive = activeTouchCount > 0
        end
    end)
end

local function formatRoundTime(seconds)
    seconds = math.max(0, math.ceil(seconds))
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%d:%02d", minutes, secs)
end

local function beginRoundTimer(duration, isRecovery)
    duration = tonumber(duration) or 180
    if duration < 0 then duration = 0 end
    RoundTimerState.phase = "RUNNING"
    RoundTimerState.duration = duration
    RoundTimerState.startedAt = getServerNow()
    RoundTimerState.endAt = RoundTimerState.startedAt + duration
    RoundRoleEndAt = RoundTimerState.endAt
    ensureRoundTimerGui()
    if RoundTimerState.enabled then
        RoundTimerState.panel.Visible = true
        RoundTimerState.label.Text = formatRoundTime(duration)
    end
end

local function endRoundTimer()
    RoundTimerState.phase = "ENDED"
    RoundTimerState.endAt = 0
    RoundTimerState.startedAt = 0
    RoundRoleEndAt = 0
    ensureRoundTimerGui()
    if RoundTimerState.panel then
        RoundTimerState.panel.Visible = RoundTimerState.enabled
    end
    if RoundTimerState.label then
        RoundTimerState.label.Text = "0:00"
    end
end

local roundReplicatedStorage = game:GetService("ReplicatedStorage")
local gameplayFolder = roundReplicatedStorage:FindFirstChild("Remotes")
local gameplayRemotes = gameplayFolder and gameplayFolder:FindFirstChild("Gameplay")
local roundStartRemote = gameplayRemotes and gameplayRemotes:FindFirstChild("RoundStart")
if roundStartRemote and roundStartRemote:IsA("RemoteEvent") then
    roundStartRemote.OnClientEvent:Connect(function(roundDuration)
        if not roleRoundActive then
            resetRoundRoles()
        end
        roleRoundSerial = roleRoundSerial + 1
        autoShootShotCooldownUntil = 0
        beginRoundTimer(roundDuration, false)
    end)
end

local roundEndFadeRemote = gameplayRemotes and gameplayRemotes:FindFirstChild("RoundEndFade")
if roundEndFadeRemote and roundEndFadeRemote:IsA("RemoteEvent") then
    roundEndFadeRemote.OnClientEvent:Connect(function(isEnding)
        if isEnding == true then
            endRoundTimer()
            autoShootShotCooldownUntil = 0
            resetRoundRoles()
        end
    end)
end

RunService.Heartbeat:Connect(function(deltaTime)
    local serverNow = getServerNow()
    if roleRoundActive and RoundRoleEndAt > 0 and serverNow >= RoundRoleEndAt then
        resetRoundRoles()
        RoundRoleEndAt = 0
    end

    if RoundTimerState.enabled then
        ensureRoundTimerGui()

        if RoundTimerState.phase == "RUNNING" and RoundTimerState.endAt > 0 then
            RoundTimerState.panel.Visible = true
            local remaining = math.max(0, RoundTimerState.endAt - serverNow)
            RoundTimerState.label.Text = formatRoundTime(remaining)
            if remaining <= 0 then
                endRoundTimer()
            end
        elseif RoundTimerState.phase == "MIDGAME" then
            RoundTimerState.panel.Visible = true
            RoundTimerState.label.Text = "0:00"
        elseif RoundTimerState.phase == "ENDED" then
            RoundTimerState.panel.Visible = true
            RoundTimerState.label.Text = "0:00"
        else
            RoundTimerState.panel.Visible = true
            RoundTimerState.label.Text = "0:00"
        end
    end

    RoundTimerState.fpsFrames = RoundTimerState.fpsFrames + 1
    local now = time()
    local elapsed = now - RoundTimerState.fpsLast
    if elapsed >= 0.25 then
        RoundTimerState.fps = math.floor((RoundTimerState.fpsFrames / elapsed) + 0.5)
        RoundTimerState.fpsFrames = 0
        RoundTimerState.fpsLast = now
        if RoundTimerState.enabled and RoundTimerState.statsLabel then
            local ping = getCurrentPing()
            RoundTimerState.statsLabel.Text = string.format("FPS %d    Ping %dms", RoundTimerState.fps, ping)
        end
    end
end)

Chloex = nil
do
    local ok, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/RillBoys/bolong.catui/main/b0lngUi.lua"))()
    end)
    if ok and result then
        Chloex = result
    else
        error("Library file not found: b0lngUi.lua")
    end
end

ACCENT_COLOR = Color3.fromRGB(0, 180, 255)

function PlaySoundAsset(soundId, volume)
    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. tostring(soundId)
        sound.Volume = volume or 1
        sound.Parent = SoundService
        SoundService:PlayLocalSound(sound)
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end)
end

function PlayOpenSound()
    PlaySoundAsset(134699420140804, 1)
end

AutoShootEnabled = false
autoShootShotCooldownUntil = 0
ShootKeybind = Enum.KeyCode.E
MobilePanelEnabled = false

hitboxExpandEnabled = false
hitboxSize = 4
hitboxVisible = false
hitboxOriginals = {}

invisibleEnabled = false
invisibleTransparencyOriginals = {}
invisibleRenderConnection = nil
InvisiblePanel = nil
InvisibleLabel = nil
InvisiblePanelStroke = nil
invisibleDragging = false
invisibleDragInput = nil
invisibleDragStart = nil
invisibleStartPos = nil
invisibleDragMoved = false
invisibleTouchStartTime = 0

lowDetailsEnabled = false
lowDetailsOriginal = nil

disableFootstepEnabled = false
footstepConnection = nil
footstepBackups = {}

selectedFlingPlayerName = nil
selectedFlingEnabled = false
selectedFlingThread = nil
selectedFlingInProgress = false
PanelScale = 15
EspEnabled = false
EspTransparency = 0.5

WalkSpeedEnabled = false
WalkSpeedValue = 16
JumpPowerEnabled = false
JumpPowerValue = 50
NoclipEnabled = false
InfiniteJumpEnabled = false

RoleColors = {
    Innocent = Color3.fromRGB(0, 190, 0),
    Hero = Color3.fromRGB(210, 190, 0),
    Sheriff = Color3.fromRGB(0, 45, 200),
    Murderer = Color3.fromRGB(205, 0, 0),
    Lobby = Color3.fromRGB(105, 105, 115)
}


roleCache = {}
roleCacheByUserId = {}
roleRoundActive = false
firstGunHolderName = nil
roleRoundSerial = 0

function clearAllRoleBoxes()
    for player in pairs(roleBoxes or {}) do
        clearRoleBoxes(player)
    end
end

local function setCachedRole(playerName, playerData)
    if type(playerName) ~= "string" or type(playerData) ~= "table" then
        return
    end

    local role = playerData.Role
    if role ~= "Murderer" and role ~= "Sheriff" and role ~= "Hero" and role ~= "Innocent" then
        return
    end

    roleCache[playerName] = role

    local userId = tonumber(playerData.UserId)
    if userId then
        roleCacheByUserId[userId] = role
    end
end

local fadeRemote = gameplayRemotes and gameplayRemotes:FindFirstChild("Fade")
if not fadeRemote and gameplayRemotes then
    fadeRemote = gameplayRemotes:WaitForChild("Fade", 10)
end

if fadeRemote and fadeRemote:IsA("RemoteEvent") then
    fadeRemote.OnClientEvent:Connect(function(roundPlayers)
        if type(roundPlayers) ~= "table" then
            return
        end

        roleCache = {}
        roleCacheByUserId = {}
        roleRoundActive = true
        firstGunHolderName = nil
        roleRoundSerial = roleRoundSerial + 1
        RoundRoleEndAt = 0

        for playerName, playerData in pairs(roundPlayers) do
            setCachedRole(playerName, playerData)

            if type(playerData) == "table" then
                local fadeUserId = tonumber(playerData.UserId)
                local actualPlayer = Players:FindFirstChild(playerName)

                if fadeUserId then
                    roleCacheByUserId[fadeUserId] = playerData.Role
                elseif actualPlayer then
                    roleCacheByUserId[actualPlayer.UserId] = playerData.Role
                end

                if playerData.Role == "Sheriff" then
                    firstGunHolderName = playerName
                end
            end
        end

        if RoundTimerState.phase ~= "RUNNING" then
            local hasCharacter = false
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                    hasCharacter = true
                    break
                end
            end
            if hasCharacter then
                RoundTimerState.phase = "MIDGAME"
                RoundTimerState.duration = 0
                RoundTimerState.startedAt = 0
                RoundTimerState.endAt = 0
                RoundRoleEndAt = 0
                ensureRoundTimerGui()
                RoundTimerState.label.Text = "0:00"
                if RoundTimerState.enabled then
                    RoundTimerState.panel.Visible = true
                end
            end
        end

        for player, boxes in pairs(roleBoxes or {}) do
            if player and player.Parent and boxes then
                local role = GetPlayerRoleMM2(player)
                local activeRole = role == "Murderer"
                    or role == "Sheriff"
                    or role == "Hero"
                    or role == "Innocent"
                local color = RoleColors[role] or RoleColors.Lobby
                for _, box in ipairs(boxes) do
                    if box and box.Parent then
                        box.Color3 = color
                        box.Visible = EspEnabled and roleRoundActive and activeRole
                    end
                end
            end
        end
    end)
end

function resetRoundRoles()
    roleCache = {}
    roleCacheByUserId = {}
    roleRoundActive = false
    firstGunHolderName = nil
    for player, boxes in pairs(roleBoxes or {}) do
        if boxes then
            for _, box in ipairs(boxes) do
                if box and box.Parent then
                    box.Visible = false
                end
            end
        end
    end
end

function GetPlayerRoleMM2(player)
    if not player then
        return "Lobby"
    end

    local role = roleCache[player.Name]
    if role then
        return role
    end

    local userId = tonumber(player.UserId)
    if userId then
        role = roleCacheByUserId[userId]
        if role then
            return role
        end
    end

    return "Lobby"
end

TargetLimbNames = {
    {Name="Head",Size=Vector3.new(1.25,1.25,1.25)},
    {Name="Torso",Size=Vector3.new(2.1,2.1,1.1)},
    {Name="Left Arm",Size=Vector3.new(1.1,2.1,1.1)},
    {Name="Right Arm",Size=Vector3.new(1.1,2.1,1.1)},
    {Name="Left Leg",Size=Vector3.new(1.1,2.1,1.1)},
    {Name="Right Leg",Size=Vector3.new(1.1,2.1,1.1)},

    {Name="UpperTorso",Size=Vector3.new(2.1,1.1,1.1)},
    {Name="LowerTorso",Size=Vector3.new(2,1,1)},
    {Name="LeftUpperArm",Size=Vector3.new(1.1,1.1,1.1)},
    {Name="LeftLowerArm",Size=Vector3.new(1,1.1,1)},
    {Name="RightUpperArm",Size=Vector3.new(1.1,1.1,1.1)},
    {Name="RightLowerArm",Size=Vector3.new(1,1.1,1)},
    {Name="LeftUpperLeg",Size=Vector3.new(1.1,1.1,1.1)},
    {Name="LeftLowerLeg",Size=Vector3.new(1,1.1,1)},
    {Name="RightUpperLeg",Size=Vector3.new(1.1,1.1,1.1)},
    {Name="RightLowerLeg",Size=Vector3.new(1,1.1,1)},
    {Name="LeftFoot",Size=Vector3.new(1,.8,1)},
    {Name="RightFoot",Size=Vector3.new(1,.8,1)}
}

currentSpeed = 16
currentJump = 50
currentGravity = workspace.Gravity
infJumpEnabled = false
noclipEnabled = false
speedOverrideApplied = false
jumpOverrideApplied = false
movementOriginals = setmetatable({}, {__mode = "k"})
gravityOriginal = workspace.Gravity
fovOriginal = 70
cameraFovCaptured = false

function getHumanoid()
    local char = localPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

function captureMovementOriginals(hum)
    if not hum or movementOriginals[hum] then return end
    movementOriginals[hum] = {
        WalkSpeed = hum.WalkSpeed,
        JumpPower = hum.JumpPower,
        UseJumpPower = hum.UseJumpPower,
        AutoRotate = hum.AutoRotate
    }
end

function restoreWalkSpeed(hum)
    local original = hum and movementOriginals[hum]
    if hum and original then
        hum.WalkSpeed = original.WalkSpeed
    end
end

function restoreJumpPower(hum)
    local original = hum and movementOriginals[hum]
    if hum and original then
        hum.UseJumpPower = original.UseJumpPower
        hum.JumpPower = original.JumpPower
    end
end

function ApplyMovement()
    local hum = getHumanoid()
    if not hum then return end

    captureMovementOriginals(hum)

    if currentSpeed ~= 16 then
        hum.WalkSpeed = currentSpeed
        speedOverrideApplied = true
    elseif speedOverrideApplied then
        restoreWalkSpeed(hum)
        speedOverrideApplied = false
    end

    if currentJump ~= 50 then
        hum.UseJumpPower = true
        hum.JumpPower = currentJump
        jumpOverrideApplied = true
    elseif jumpOverrideApplied then
        restoreJumpPower(hum)
        jumpOverrideApplied = false
    end
end

noclipParts = {}
noclipPartSet = {}
noclipOriginalCanCollide = {}
noclipDescAddedConnection = nil
noclipDescRemovingConnection = nil
noclipCharacter = nil

function removeNoclipPart(part)
    noclipOriginalCanCollide[part] = nil
    if not noclipPartSet[part] then
        return
    end

    noclipPartSet[part] = nil
    for i = #noclipParts, 1, -1 do
        if noclipParts[i] == part then
            table.remove(noclipParts, i)
            break
        end
    end
end

function trackNoclipPart(obj)
    if obj and obj:IsA("BasePart") and not noclipPartSet[obj] then
        noclipPartSet[obj] = true
        noclipParts[#noclipParts + 1] = obj
        noclipOriginalCanCollide[obj] = obj.CanCollide

        if NoclipEnabled then
            obj.CanCollide = false
        end
    end
end

function clearNoclipPartCache()
    table.clear(noclipParts)
    table.clear(noclipPartSet)
    table.clear(noclipOriginalCanCollide)
end

function setupNoclipCharacter(character)
    if noclipDescAddedConnection then
        pcall(function()
            noclipDescAddedConnection:Disconnect()
        end)
        noclipDescAddedConnection = nil
    end

    if noclipDescRemovingConnection then
        pcall(function()
            noclipDescRemovingConnection:Disconnect()
        end)
        noclipDescRemovingConnection = nil
    end

    clearNoclipPartCache()
    noclipCharacter = character

    if not character then
        return
    end

    local function collectParts(parent)
        for _, obj in ipairs(parent:GetChildren()) do
            trackNoclipPart(obj)
            collectParts(obj)
        end
    end

    collectParts(character)

    noclipDescAddedConnection = character.DescendantAdded:Connect(function(obj)
        trackNoclipPart(obj)
    end)

    noclipDescRemovingConnection = character.DescendantRemoving:Connect(function(obj)
        removeNoclipPart(obj)
    end)
end

function SetNoclip(state)
    NoclipEnabled = state == true
    noclipEnabled = NoclipEnabled

    if noclipCharacter ~= localPlayer.Character then
        setupNoclipCharacter(localPlayer.Character)
    end

    for i = #noclipParts, 1, -1 do
        local obj = noclipParts[i]

        if obj and obj.Parent and obj:IsA("BasePart") then
            if NoclipEnabled then
                obj.CanCollide = false
            else
                local original = noclipOriginalCanCollide[obj]
                if original ~= nil then
                    obj.CanCollide = original
                end
            end
        else
            removeNoclipPart(obj)
        end
    end
end

function ApplyNoclip()
    if not NoclipEnabled then
        return
    end

    if noclipCharacter ~= localPlayer.Character then
        setupNoclipCharacter(localPlayer.Character)
    end

    for i = #noclipParts, 1, -1 do
        local part = noclipParts[i]

        if part and part.Parent and part:IsA("BasePart") then
            part.CanCollide = false
        else
            removeNoclipPart(part)
        end
    end
end

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled or infJumpEnabled then
        local hum = getHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

localPlayer.CharacterAdded:Connect(function(character)
    if NoclipEnabled then
        setupNoclipCharacter(character)
    end

    if autoFarmActive then
        autoFarmCoinsRunning = false
        autoFarmActive = false
        if autoFarmCoinsThread then
            task.cancel(autoFarmCoinsThread)
            autoFarmCoinsThread = nil
        end
    end

    task.spawn(function()
        local hum = character:WaitForChild("Humanoid", 5)
        if hum then
            movementOriginals[hum] = {
                WalkSpeed = hum.WalkSpeed,
                JumpPower = hum.JumpPower,
                UseJumpPower = hum.UseJumpPower,
                AutoRotate = hum.AutoRotate
            }

            task.wait(0.15)
            if currentSpeed ~= 16 or currentJump ~= 50 then
                ApplyMovement()
            end
            if NoclipEnabled then
                ApplyNoclip()
            end
        end
    end)
end)

task.spawn(function()
    while task.wait(0.12) do
        if currentSpeed ~= 16 or currentJump ~= 50 or currentGravity ~= 196.2 then
            ApplyMovement()
        end
        if noclipEnabled then
            ApplyNoclip()
        end
    end
end)


Camera = workspace.CurrentCamera

viewEnabled = false
selectedViewPlayer = localPlayer.Name

autoFarmActive = false
autoFarmCoinsRunning = false
autoFarmCoinsThread = nil
coinReachEnabled = false
coinReachRange = 6
coinReachOriginals = {}
coinReachConnection = nil
antiAFKEnabled = false
autoPickupGunActive = false
pickupPanelInteracting = false
uiPanelTouchActive = false
VirtualUser = game:GetService("VirtualUser")

fakeBombJumpEnabled = false
fakeBombAutoJumpEnabled = true
fakeBombVariant = "Auto"
fakeBombMouseLockActive = false
fakeBombCooldownTime = 21
fakeBombCooldownUntil = 0
fakeBombJumpReady = true
fakeBombScreenTouchJumpConnection = nil
fakeBombScreenTouchSuppress = false
FakeBombJumpPanel = nil
FakeBombJumpLabel = nil
fakeBombPanelDragging = false
fakeBombPanelDragInput = nil
fakeBombPanelDragStart = nil
fakeBombPanelStartPos = nil
fakeBombPanelDragMoved = false
fakeBombPanelTouchStart = 0
fakeBombToolConnections = {}
fakeBombCharacterConnection = nil
fakeBombBackpackConnection = nil
fakeBombMouseLockConnection = nil
fakeBombLastPointer = nil

localPlayer.Idled:Connect(function()
    if not antiAFKEnabled then return end

    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end)

aimbotActive = false
aimlockEngaged = false
aimbotFOV = 10
AimbotPanelScale = 8
aimbotFOVVisible = false
autoShootActive = false
killAuraActive = false
killAuraDistance = 15
AutoShootEnabled = false
ShootKeybind = Enum.KeyCode.E
MobilePanelEnabled = false
PanelScale = 15
droppedGunEspEnabled = false
showDroppedGunEspNameEnabled = false

espHighlights = {}

function getPlayerList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(list, p.Name)
    end
    if #list == 0 then
        table.insert(list, localPlayer.Name)
    end
    table.sort(list)
    return list
end

function getRole(player)
    if not player then
        return "Lobby"
    end

    local role = roleCacheByUserId and roleCacheByUserId[player.UserId]
    if role then
        return role
    end

    role = roleCache and roleCache[player.Name]
    if role then
        return role
    end

    return "Lobby"
end

function getRoleColor(role)
    return RoleColors[role] or RoleColors.Lobby
end

function getToolByName(player, name)
    if not player then return nil end

    local char = player.Character
    if char then
        local tool = char:FindFirstChild(name)
        if tool and tool:IsA("Tool") then
            return tool
        end
    end

    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        local tool = backpack:FindFirstChild(name)
        if tool and tool:IsA("Tool") then
            return tool
        end
    end

    return nil
end

local function recoverCurrentRoundRolesOnce()
    if roleRoundActive then
        return
    end
    local foundMurderer = false
    local foundSheriff = false
    local foundAnyRole = false

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local knife = getToolByName(player, "Knife")
            if knife then
                roleCache[player.Name] = "Murderer"
                roleCacheByUserId[tonumber(player.UserId)] = "Murderer"
                foundMurderer = true
                foundAnyRole = true
            end
        end
    end

    local knownSheriff = false
    for _, role in pairs(roleCache) do
        if role == "Sheriff" then
            knownSheriff = true
            break
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local gun = getToolByName(player, "Gun")
            if gun then
                local role
                if not firstGunHolderName then
                    firstGunHolderName = player.Name
                    role = "Sheriff"
                elseif firstGunHolderName == player.Name then
                    role = "Sheriff"
                else
                    role = "Hero"
                end
                roleCache[player.Name] = role
                roleCacheByUserId[tonumber(player.UserId)] = role
                if role == "Sheriff" then
                    knownSheriff = true
                    foundSheriff = true
                end
                foundAnyRole = true
            end
        end
    end

    roleRoundActive = foundAnyRole

    if foundAnyRole and RoundTimerState.phase ~= "RUNNING" then
        RoundTimerState.phase = "MIDGAME"
        RoundTimerState.duration = 0
        RoundTimerState.startedAt = 0
        RoundTimerState.endAt = 0
        RoundRoleEndAt = 0
        ensureRoundTimerGui()
        RoundTimerState.label.Text = "0:00"
        if RoundTimerState.enabled then
            RoundTimerState.panel.Visible = true
        end
    end

    for player, boxes in pairs(roleBoxes or {}) do
        if player and player.Parent and boxes then
            local color = RoleColors[GetPlayerRoleMM2(player)] or RoleColors.Lobby
            for _, box in ipairs(boxes) do
                if box and box.Parent then
                    box.Color3 = color
                    box.Visible = EspEnabled
                end
            end
        end
    end
end

function getKnife()
    return getToolByName(localPlayer, "Knife")
        or (function()
            local char = localPlayer.Character
            local backpack = localPlayer:FindFirstChildOfClass("Backpack")
            local containers = {char, backpack}
            for _, container in ipairs(containers) do
                if container then
                    for _, obj in ipairs(container:GetChildren()) do
                        if obj:IsA("Tool") then
                            local n = string.lower(obj.Name)
                            if n:find("knife") or n:find("blade") or n:find("dagger") then
                                return obj
                            end
                        end
                    end
                end
            end
        end)()
end

function getGunForBolong()
    local gun = getToolByName(localPlayer, "Gun")
    if gun then return gun end

    local char = localPlayer.Character
    local backpack = localPlayer:FindFirstChildOfClass("Backpack")

    for _, container in ipairs({char, backpack}) do
        if container then
            for _, obj in ipairs(container:GetChildren()) do
                if obj:IsA("Tool") then
                    local n = string.lower(obj.Name)
                    if n == "gun" or n:find("revolver") or n:find("pistol") or n:find("gun") then
                        return obj
                    end
                end
            end
        end
    end
end

task.delay(0.35, recoverCurrentRoundRolesOnce)

function refreshGunHolderRole(player)
    if not player or player == localPlayer or not player.Parent then return end
    if not roleRoundActive then return end

    local gun = getToolByName(player, "Gun")
    if not gun then return end

    local cachedRole = GetPlayerRoleMM2(player)
    if cachedRole == "Sheriff" then
        firstGunHolderName = player.Name
        return
    end

    if firstGunHolderName and firstGunHolderName == player.Name then
        roleCache[player.Name] = "Sheriff"
        roleCacheByUserId[tonumber(player.UserId)] = "Sheriff"
        return
    end

    if firstGunHolderName then
        roleCache[player.Name] = "Hero"
        roleCacheByUserId[tonumber(player.UserId)] = "Hero"
        return
    end

    for _, role in pairs(roleCache) do
        if role == "Sheriff" then
            return
        end
    end

    firstGunHolderName = player.Name
    roleCache[player.Name] = "Sheriff"
    roleCacheByUserId[tonumber(player.UserId)] = "Sheriff"
end

function bindGunRoleWatcher(player, character)
    if not player or player == localPlayer or not character then return end
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and string.lower(child.Name) == "gun" then
            task.defer(function() refreshGunHolderRole(player) end)
        end
    end)
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        backpack.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and string.lower(child.Name) == "gun" then
                task.defer(function() refreshGunHolderRole(player) end)
            end
        end)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        if player.Character then bindGunRoleWatcher(player, player.Character) end
        player.CharacterAdded:Connect(function(character)
            task.defer(function() bindGunRoleWatcher(player, character); refreshGunHolderRole(player) end)
        end)
    end
end
Players.PlayerAdded:Connect(function(player)
    if player == localPlayer then return end
    player.CharacterAdded:Connect(function(character)
        task.defer(function() bindGunRoleWatcher(player, character); refreshGunHolderRole(player) end)
    end)
end)


function equipTool(tool)
    local char = localPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if tool and hum and tool.Parent ~= char then
        pcall(function()
            hum:EquipTool(tool)
        end)
    end
end

cachedGunDrop = nil

function getGunDrop()
    if cachedGunDrop and cachedGunDrop.Parent then
        return cachedGunDrop
    end

    local obj = Workspace:FindFirstChild("GunDrop", true)

    if obj and obj:IsA("BasePart") then
        cachedGunDrop = obj
        return obj
    elseif obj and obj:IsA("Model") then
        local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        if part then
            cachedGunDrop = part
            return part
        end
    end

    cachedGunDrop = nil
    return nil
end

function cleanupVisuals()
    for _, h in pairs(espHighlights) do
        if h then pcall(function() h:Destroy() end) end
    end
    espHighlights = {}

    for _, box in pairs(roleBoxes) do
        if box then pcall(function() box:Destroy() end) end
    end
    roleBoxes = {}

    for _, bb in pairs(usernameBillboards) do
        if bb then pcall(function() bb:Destroy() end) end
    end
    end

RunService.Heartbeat:Connect(function()
    if noclipEnabled then
        ApplyNoclip()
    end

    if currentGravity ~= 196.2 then
        if workspace.Gravity ~= currentGravity then
            workspace.Gravity = currentGravity
        end
    elseif workspace.Gravity ~= gravityOriginal then
        workspace.Gravity = gravityOriginal
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if viewEnabled then
        local target = Players:FindFirstChild(selectedViewPlayer)
        if target and target.Character then
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                Camera.CameraSubject = hum
            end
        end
    end
end)

roleBoxes = {}
roleCharacterConnections = {}
roleRebuildQueued = {}

ROLE_PART_NAMES = {
    "Head",
    "UpperTorso", "LowerTorso", "Torso", "Waist",
    "LeftUpperArm", "LeftLowerArm", "LeftHand", "Left Arm",
    "RightUpperArm", "RightLowerArm", "RightHand", "Right Arm",
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg",
    "RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg",
}

local function isRoleBodyPartName(name)
    for _, partName in ipairs(ROLE_PART_NAMES) do
        if partName == name then
            return true
        end
    end
    return false
end

local function queueRoleBoxRebuild(player, character)
    if not EspEnabled or not player or not character or player.Character ~= character then
        return
    end
    if roleRebuildQueued[player] then
        return
    end
    roleRebuildQueued[player] = true
    task.delay(0.08, function()
        roleRebuildQueued[player] = nil
        if EspEnabled and player.Parent and player.Character == character then
            buildRoleBoxes(player)
        end
    end)
end

local function bindRoleCharacterWatcher(player, character)
    if not player or not character then return end

    local old = roleCharacterConnections[player]
    if old then
        for _, connection in ipairs(old) do
            pcall(function() connection:Disconnect() end)
        end
    end

    local connections = {}
    roleCharacterConnections[player] = connections

    table.insert(connections, character.ChildAdded:Connect(function(child)
        if child:IsA("BasePart") and isRoleBodyPartName(child.Name) then
            queueRoleBoxRebuild(player, character)
        end
    end))

    table.insert(connections, character.ChildRemoved:Connect(function(child)
        if child:IsA("BasePart") and isRoleBodyPartName(child.Name) then
            queueRoleBoxRebuild(player, character)
        end
    end))
end

function clearRoleBoxes(player)
    local list = roleBoxes[player]
    if list then
        for _, box in ipairs(list) do
            pcall(function() box:Destroy() end)
        end
        roleBoxes[player] = nil
    end
end

function getRoleParts(character)
    local result, seen = {}, {}
    for _, name in ipairs(ROLE_PART_NAMES) do
        local part = character:FindFirstChild(name)
        if part and part:IsA("BasePart") and not seen[part] then
            seen[part] = true
            table.insert(result, part)
        end
    end
    return result
end

function buildRoleBoxes(player)
    clearRoleBoxes(player)

    local character = player.Character
    if not character then return end

    local boxes = {}
    local roleColor = getRoleColor(GetPlayerRoleMM2(player))
    bindRoleCharacterWatcher(player, character)

    for _, part in ipairs(getRoleParts(character)) do
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "BolongRolePartBox"
        box.Adornee = part
        box.Size = part.Size
        box.Color3 = roleColor
        box.Transparency = 0.64
        box.AlwaysOnTop = true
        box.ZIndex = 1
        box.Visible = roleRoundActive and (GetPlayerRoleMM2(player) ~= "Lobby")
        box.Parent = part
        table.insert(boxes, box)
    end

    roleBoxes[player] = boxes
end

RunService.Heartbeat:Connect(function()
    if not EspEnabled then
        for _, boxes in pairs(roleBoxes) do
            if boxes then
                for _, box in ipairs(boxes) do
                    if box and box.Parent and box.Visible then
                        box.Visible = false
                    end
                end
            end
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            local boxes = roleBoxes[player]

            local boxesLost = boxes == nil or #boxes == 0
            if not boxesLost and character then
                for _, box in ipairs(boxes) do
                    if not box or not box.Parent then
                        boxesLost = true
                        break
                    end
                end
            end

            if character and boxesLost then
                buildRoleBoxes(player)
                boxes = roleBoxes[player]
            end

            local role = GetPlayerRoleMM2(player)
            local hasActiveRole = roleRoundActive and (
                role == "Murderer"
                or role == "Sheriff"
                or role == "Hero"
                or role == "Innocent"
            )
            local color = getRoleColor(role)

            if boxes then
                for _, box in ipairs(boxes) do
                    if box and box.Parent then
                        if box.Color3 ~= color then
                            box.Color3 = color
                        end
                        local shouldShow = character ~= nil and hasActiveRole
                        if box.Visible ~= shouldShow then
                            box.Visible = shouldShow
                        end
                    end
                end
            end
        end
    end

    for player in pairs(roleBoxes) do
        if not player.Parent then
            clearRoleBoxes(player)
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    clearRoleBoxes(player)
    local connections = roleCharacterConnections[player]
    if connections then
        for _, connection in ipairs(connections) do
            pcall(function() connection:Disconnect() end)
        end
        roleCharacterConnections[player] = nil
    end
    roleRebuildQueued[player] = nil
end)

Players.PlayerAdded:Connect(function(player)
    if player == localPlayer then return end

    local function rebuildForCharacter(character)
        clearRoleBoxes(player)
        character:WaitForChild("HumanoidRootPart", 5)
        task.wait(0.25)
        if player.Parent and player.Character == character then
            bindRoleCharacterWatcher(player, character)
            if EspEnabled then
                buildRoleBoxes(player)
            end
        end
    end

    if player.Character then
        task.spawn(rebuildForCharacter, player.Character)
    end

    player.CharacterAdded:Connect(function(character)
        task.spawn(rebuildForCharacter, character)
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        player.CharacterAdded:Connect(function(character)
            clearRoleBoxes(player)
            bindRoleCharacterWatcher(player, character)
            task.wait(0.25)
            if EspEnabled and player.Parent and player.Character == character then
                buildRoleBoxes(player)
            end
        end)
    end
end

droppedGunBlock = nil
droppedGunNameBillboard = nil

function clearDroppedGunESPName()
    if droppedGunNameBillboard then
        pcall(function() droppedGunNameBillboard:Destroy() end)
    end
    droppedGunNameBillboard = nil
end

function clearDroppedGunESP()
    if droppedGunBlock then
        pcall(function() droppedGunBlock:Destroy() end)
    end
    droppedGunBlock = nil
end

function setGunDrop(obj)
    if obj and obj.Name == "GunDrop" and obj:IsA("BasePart") then
        cachedGunDrop = obj
    end
end

initialGunDrop = Workspace:FindFirstChild("GunDrop", true)
if initialGunDrop then
    if initialGunDrop:IsA("BasePart") then
        setGunDrop(initialGunDrop)
    elseif initialGunDrop:IsA("Model") then
        local part = initialGunDrop.PrimaryPart or initialGunDrop:FindFirstChildWhichIsA("BasePart")
        if part then
            setGunDrop(part)
        end
    end
end

Workspace.DescendantAdded:Connect(function(obj)
    if obj.Name == "GunDrop" then
        if obj:IsA("BasePart") then
            setGunDrop(obj)
        elseif obj:IsA("Model") then
            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if part then setGunDrop(part) end
        end
    end
end)

Workspace.DescendantRemoving:Connect(function(obj)
    if obj == cachedGunDrop then
        cachedGunDrop = nil
        clearDroppedGunESP()
    end
end)

function updateDroppedGunESP()
    if not cachedGunDrop or not cachedGunDrop.Parent then
        clearDroppedGunESP()
        clearDroppedGunESPName()
        return
    end

    if droppedGunEspEnabled then
        if not droppedGunBlock or droppedGunBlock.Adornee ~= cachedGunDrop then
            clearDroppedGunESP()
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "BolongDroppedGun3D"
            box.Adornee = cachedGunDrop
            box.Size = cachedGunDrop.Size + Vector3.new(1.2, 1.2, 1.2)
            box.Color3 = Color3.fromRGB(0, 45, 15)
            box.Transparency = 0.63
            box.AlwaysOnTop = true
            box.ZIndex = 1
            box.Parent = cachedGunDrop
            droppedGunBlock = box
        end
    else
        clearDroppedGunESP()
    end

    if showDroppedGunEspNameEnabled then
        if not droppedGunNameBillboard or droppedGunNameBillboard.Adornee ~= cachedGunDrop then
            clearDroppedGunESPName()
            local bb = Instance.new("BillboardGui")
            bb.Name = "BolongDroppedGunName"
            bb.Adornee = cachedGunDrop
            bb.Size = UDim2.fromOffset(140, 28)
            bb.StudsOffset = Vector3.new(0, math.max(1.5, cachedGunDrop.Size.Y * 0.5 + 1.2), 0)
            bb.AlwaysOnTop = true
            bb.Parent = cachedGunDrop

            local txt = Instance.new("TextLabel")
            txt.Name = "DroppedGun"
            txt.Size = UDim2.fromScale(1, 1)
            txt.BackgroundTransparency = 1
            txt.Text = "Dropped Gun"
            txt.TextColor3 = Color3.fromRGB(255, 255, 255)
            txt.TextSize = 16
            txt.Font = Enum.Font.GothamBold
            txt.TextStrokeTransparency = 0.2
            txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            txt.Parent = bb
            droppedGunNameBillboard = bb
        end
    else
        clearDroppedGunESPName()
    end
end
task.spawn(function()
    while task.wait(0.12) do
        updateDroppedGunESP()
    end
end)

local function scanCoinReachObjects()
    local objects = {}
    local function visit(parent)
        for _, obj in ipairs(parent:GetChildren()) do
            if obj.Name == "Coin_Server" and obj:IsA("BasePart") then
                table.insert(objects, obj)
            end
            visit(obj)
        end
    end
    visit(Workspace)
    return objects
end

local function ApplyCoinReach(state)
    coinReachEnabled = state == true

    if coinReachConnection then
        coinReachConnection:Disconnect()
        coinReachConnection = nil
    end

    if coinReachEnabled then
        coinReachOriginals = {}
        for _, obj in ipairs(scanCoinReachObjects()) do
            if not coinReachOriginals[obj] then
                coinReachOriginals[obj] = obj.Size
            end
            obj.Size = coinReachOriginals[obj] * coinReachRange
        end

        coinReachConnection = Workspace.DescendantAdded:Connect(function(obj)
            if coinReachEnabled and obj.Name == "Coin_Server" and obj:IsA("BasePart") then
                if not coinReachOriginals[obj] then
                    coinReachOriginals[obj] = obj.Size
                end
                obj.Size = coinReachOriginals[obj] * coinReachRange
            end
        end)
    else
        for obj, originalSize in pairs(coinReachOriginals) do
            if obj and obj.Parent then
                obj.Size = originalSize
            end
        end
        coinReachOriginals = {}
    end
end

function AutoFarmCoinsFunc()
    local function GetMap()
        while autoFarmCoinsRunning do
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:GetAttribute("MapID") and obj:FindFirstChild("CoinContainer") then
                    return obj
                end
            end
            task.wait(0.1)
        end
        return nil
    end

    local function getNearest()
        local map = GetMap()
        if not map or not autoFarmCoinsRunning then
            return nil
        end

        local closest, dist = nil, math.huge
        local char = localPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if not char or not humanoid or humanoid.Health <= 0 then
            return nil
        end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            return nil
        end

        local coinContainer = map:FindFirstChild("CoinContainer")
        if not coinContainer then
            return nil
        end

        for _, coin in ipairs(coinContainer:GetChildren()) do
            local visual = coin:FindFirstChild("CoinVisual")
            if visual and not visual:GetAttribute("Collected") then
                local d = (hrp.Position - coin.Position).Magnitude
                if d < dist then
                    closest = coin
                    dist = d
                end
            end
        end
        return closest
    end

    local function tp(hp)
        local char = localPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if not char or not humanoid or not autoFarmCoinsRunning then
            return false
        end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            return false
        end

        if humanoid.Health <= 0 then
            autoFarmCoinsRunning = false
            autoFarmActive = false
            return false
        end

        humanoid:ChangeState(11)
        local d = (hrp.Position - hp.Position).Magnitude
        local t = TweenService:Create(hrp, TweenInfo.new(d / 25, Enum.EasingStyle.Linear), {CFrame = hp.CFrame})
        t:Play()
        t.Completed:Wait()
        return autoFarmCoinsRunning
    end

    while autoFarmCoinsRunning and task.wait(0.1) do
        local char = localPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if not char or not humanoid or humanoid.Health <= 0 then
            autoFarmCoinsRunning = false
            autoFarmActive = false
            break
        end

        local target = getNearest()
        if target then
            local reached = tp(target)
            if not reached then
                break
            end

            local visual = target:FindFirstChild("CoinVisual")
            while autoFarmCoinsRunning and visual and not visual:GetAttribute("Collected") and visual.Parent do
                local currentChar = localPlayer.Character
                local currentHumanoid = currentChar and currentChar:FindFirstChild("Humanoid")
                if not currentChar or not currentHumanoid or currentHumanoid.Health <= 0 then
                    autoFarmCoinsRunning = false
                    autoFarmActive = false
                    break
                end

                local nearest = getNearest()
                if nearest and nearest ~= target then
                    break
                end
                task.wait(0.1)
            end
        else
            task.wait(0.5)
        end
    end
end

function startAutoFarm()
    if autoFarmCoinsThread then
        task.cancel(autoFarmCoinsThread)
        autoFarmCoinsThread = nil
    end

    autoFarmActive = true
    autoFarmCoinsRunning = true
    autoFarmCoinsThread = task.spawn(function()
        AutoFarmCoinsFunc()
        autoFarmCoinsThread = nil
    end)
end

function stopAutoFarm()
    autoFarmActive = false
    autoFarmCoinsRunning = false
    if autoFarmCoinsThread then
        task.cancel(autoFarmCoinsThread)
        autoFarmCoinsThread = nil
    end
end

task.spawn(function()
    while true do
        if autoFarmActive and autoFarmCoinsRunning then
            local char = localPlayer.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            if not char or not humanoid or humanoid.Health <= 0 then
                stopAutoFarm()
            end
        end
        task.wait(1)
    end
end)

aimlockLockedPlayer = nil
aimlockLockedHead = nil
aimlockLockedHumanoid = nil
aimlockAcquireAccumulator = 0
AIMLOCK_SMOOTHNESS = 1

function clearAimlockTarget()
    aimlockLockedPlayer = nil
    aimlockLockedHead = nil
    aimlockLockedHumanoid = nil
end

function acquireAimlockTarget()
    if not aimbotActive or not aimlockEngaged or aimlockLockedPlayer then
        return
    end

    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local radius = aimbotFOV * 12
    local closestTarget = nil
    local shortestDist = radius
    local localCharacter = localPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            local character = p.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")
            local roleIsMurderer = getRole(p) == "Murderer"

            if roleIsMurderer and humanoid and humanoid.Health > 0 and root then
                local aimPart = character:FindFirstChild("Head") or root
                local screenPoint, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                if onScreen and screenPoint.Z > 0 then
                    local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude
                    if dist <= shortestDist then
                        shortestDist = dist
                        closestTarget = p
                    end
                end
            end
        end
    end

    if closestTarget then
        aimlockLockedPlayer = closestTarget
        local character = closestTarget.Character
        aimlockLockedHead = character and (character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")) or nil
        aimlockLockedHumanoid = character and character:FindFirstChildOfClass("Humanoid") or nil
    end
end

RunService.Heartbeat:Connect(function()
    if not aimbotActive or not aimlockEngaged then
        return
    end

    local player = aimlockLockedPlayer

    if not player or player.Parent ~= Players then
        clearAimlockTarget()
        acquireAimlockTarget()
        player = aimlockLockedPlayer
    end

    local character = player and player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not humanoid or humanoid.Health <= 0 or not root then
        clearAimlockTarget()
        acquireAimlockTarget()
        player = aimlockLockedPlayer
        character = player and player.Character
        humanoid = character and character:FindFirstChildOfClass("Humanoid")
        root = character and character:FindFirstChild("HumanoidRootPart")
    end

    if not root then
        return
    end

    local aimPart = character:FindFirstChild("Head") or root
    aimlockLockedHead = aimPart
    aimlockLockedHumanoid = humanoid

    local velocity = root.AssemblyLinearVelocity
    local predictionTime = 0.02
    local predictedPosition = aimPart.Position + velocity * predictionTime

    local cameraPosition = Camera.CFrame.Position
    Camera.CFrame = CFrame.lookAt(cameraPosition, predictedPosition)
end)


function getMurdererTargetPart()
    local bestPlayer, bestPart
    local bestScore = math.huge
    local localChar = localPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and getRole(p) == "Murderer" and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")

            if hum and hum.Health > 0 and root then
                local distance = localRoot and (root.Position - localRoot.Position).Magnitude or 0

                if distance <= AUTO_SHOOT_MAX_DISTANCE then
                    local bodyCFrame = char:GetBoundingBox()
                    local bodyCenter = bodyCFrame.Position
                    local part = root
                    local score = distance + (bodyCenter - root.Position).Magnitude * 0.02

                    if score < bestScore then
                        bestScore = score
                        bestPlayer = p
                        bestPart = part
                    end
                end
            end
        end
    end

    return bestPlayer, bestPart
end

AUTO_SHOOT_PROJECTILE_SPEED = 700
AUTO_SHOOT_MIN_LEAD = 0.002
AUTO_SHOOT_MAX_LEAD = 0.045
autoShootMotion = {}
autoShootMotionAccumulator = 0
AUTO_SHOOT_MAX_ACCELERATION = 260
AUTO_SHOOT_PING_LEAD = 0.012
AUTO_SHOOT_DIRECTION_BLEND = 1
AUTO_SHOOT_MAX_DISTANCE = math.huge
AUTO_SHOOT_UPDATE_RATE = 0.025
AUTO_SHOOT_TARGET_SWITCH_MARGIN = 2.5
AUTO_SHOOT_ZIGZAG_LEAD = 0.010
AUTO_SHOOT_JUMP_VERTICAL_LEAD = 0.060
AUTO_SHOOT_JUMP_HORIZONTAL_BOOST = 0.006

function updateAutoShootMotion(deltaTime)
    if not AutoShootEnabled then
        return
    end

    autoShootMotionAccumulator = autoShootMotionAccumulator + (tonumber(deltaTime) or 0)
    if autoShootMotionAccumulator < AUTO_SHOOT_UPDATE_RATE then
        return
    end
    autoShootMotionAccumulator = 0

    local now = os.clock()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and getRole(player) == "Murderer" then
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if root and humanoid and humanoid.Health > 0 then
                local state = autoShootMotion[player]
                if not state then
                    local initialVelocity = root.AssemblyLinearVelocity
                    local initialHorizontal = Vector3.new(initialVelocity.X, 0, initialVelocity.Z)
                    autoShootMotion[player] = {
                        position = root.Position,
                        time = now,
                        velocity = initialVelocity,
                        acceleration = Vector3.zero,
                        speed = initialVelocity.Magnitude,
                        lastHorizontal = initialHorizontal,
                        zigzag = false,
                        zigzagStrength = 0,
                        jump = humanoid:GetState() == Enum.HumanoidStateType.Jumping or humanoid:GetState() == Enum.HumanoidStateType.Freefall,
                        jumpStartedAt = now,
                    }
                else
                    local dt = now - state.time
                    if dt > 0.005 and dt < 0.20 then
                        local measuredVelocity = (root.Position - state.position) / dt
                        local assemblyVelocity = root.AssemblyLinearVelocity
                        local blendedVelocity = measuredVelocity:Lerp(assemblyVelocity, 0.48)
                        local measuredAcceleration = (blendedVelocity - state.velocity) / dt
                        local horizontalVelocity = Vector3.new(blendedVelocity.X, 0, blendedVelocity.Z)
                        local previousHorizontal = state.lastHorizontal or Vector3.zero
                        local zigzag = false
                        local zigzagStrength = 0
                        if horizontalVelocity.Magnitude > 4 and previousHorizontal.Magnitude > 4 then
                            local directionDot = horizontalVelocity.Unit:Dot(previousHorizontal.Unit)
                            if directionDot < -0.25 then
                                zigzag = true
                                zigzagStrength = math.clamp((-directionDot) * math.min(horizontalVelocity.Magnitude, 60) / 60, 0, 1)
                            end
                        end
                        local stateNow = humanoid:GetState()
                        local jumping = stateNow == Enum.HumanoidStateType.Jumping or stateNow == Enum.HumanoidStateType.Freefall
                        if jumping and not state.jump then
                            state.jumpStartedAt = now
                        end
                        state.jump = jumping
                        state.zigzag = zigzag
                        state.zigzagStrength = zigzagStrength
                        state.lastHorizontal = horizontalVelocity
                        if measuredAcceleration.Magnitude > AUTO_SHOOT_MAX_ACCELERATION then
                            measuredAcceleration = measuredAcceleration.Unit * AUTO_SHOOT_MAX_ACCELERATION
                        end
                        state.acceleration = state.acceleration:Lerp(measuredAcceleration, 0.58)
                        state.velocity = state.velocity:Lerp(blendedVelocity, 0.82)
                        state.position = root.Position
                        state.time = now
                        state.speed = state.velocity.Magnitude
                    end
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(updateAutoShootMotion)

function getAutoShootLineOfSight(origin, character, targetPosition)
    if not origin or not character or not targetPosition then
        return false
    end

    local direction = targetPosition - origin
    local distance = direction.Magnitude
    if distance <= 0.01 then
        return true
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {localPlayer.Character, character}
    params.IgnoreWater = true

    local result = Workspace:Raycast(origin, direction, params)
    return result == nil
end

function getAutoShootPredictedPosition(targetPart, origin)
    local character = targetPart and targetPart.Parent
    if not character then
        return nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root or (humanoid and humanoid.Health <= 0) then
        return targetPart.Position
    end

    local bodyCFrame, bodySize = character:GetBoundingBox()
    local rootPosition = root.Position
    local bodyCenter = bodyCFrame.Position
    local centerOffset = bodyCenter - rootPosition
    if centerOffset.Magnitude > 4 then
        bodyCenter = rootPosition
    end

    local velocity = root.AssemblyLinearVelocity
    local acceleration = Vector3.zero
    local player = Players:GetPlayerFromCharacter(character)
    local motion = player and autoShootMotion[player]
    if motion then
        velocity = motion.velocity:Lerp(velocity, 0.18)
        acceleration = motion.acceleration
    end

    local state = humanoid and humanoid:GetState() or Enum.HumanoidStateType.Running
    local isJumping = state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall
    local isZigZag = motion and motion.zigzag == true
    local zigzagStrength = motion and motion.zigzagStrength or 0

    local halfHeight = math.max((bodySize and bodySize.Y or 2) * 0.5, 0.18)
    local verticalCenterOffset = math.clamp(bodyCenter.Y - rootPosition.Y, -halfHeight, halfHeight)
    local currentPosition = Vector3.new(bodyCenter.X, rootPosition.Y + verticalCenterOffset, bodyCenter.Z)

    local distance = (currentPosition - origin).Magnitude
    local ping = 0
    pcall(function()
        ping = math.clamp(localPlayer:GetNetworkPing(), 0, 0.35)
    end)

    local speed = AUTO_SHOOT_PROJECTILE_SPEED
    local leadTime = math.clamp(
        distance / speed + ping * AUTO_SHOOT_PING_LEAD,
        AUTO_SHOOT_MIN_LEAD,
        AUTO_SHOOT_MAX_LEAD
    )

    if isZigZag then
        leadTime = math.min(AUTO_SHOOT_MAX_LEAD, leadTime + AUTO_SHOOT_ZIGZAG_LEAD * zigzagStrength)
    end
    if isJumping then
        leadTime = math.min(AUTO_SHOOT_MAX_LEAD, leadTime + AUTO_SHOOT_JUMP_HORIZONTAL_BOOST)
    end

    for _ = 1, 5 do
        local future = currentPosition
            + velocity * leadTime
            + acceleration * (0.5 * leadTime * leadTime)
        local nextDistance = (future - origin).Magnitude
        local nextLead = math.clamp(
            nextDistance / speed + ping * AUTO_SHOOT_PING_LEAD,
            AUTO_SHOOT_MIN_LEAD,
            AUTO_SHOOT_MAX_LEAD
        )
        if isZigZag then
            nextLead = math.min(AUTO_SHOOT_MAX_LEAD, nextLead + AUTO_SHOOT_ZIGZAG_LEAD * zigzagStrength)
        end
        if isJumping then
            nextLead = math.min(AUTO_SHOOT_MAX_LEAD, nextLead + AUTO_SHOOT_JUMP_HORIZONTAL_BOOST)
        end
        if math.abs(nextLead - leadTime) < 0.00025 then
            leadTime = nextLead
            break
        end
        leadTime = leadTime * 0.30 + nextLead * 0.70
    end

    local horizontalVelocity = Vector3.new(velocity.X, 0, velocity.Z)
    local horizontalAcceleration = Vector3.new(acceleration.X, 0, acceleration.Z)
    local horizontalPrediction = horizontalVelocity * leadTime + horizontalAcceleration * (0.5 * leadTime * leadTime)

    if isZigZag then
        local directionFlip = Vector3.zero
        if horizontalVelocity.Magnitude > 1 then
            directionFlip = horizontalVelocity.Unit * (2.5 * zigzagStrength)
        end
        horizontalPrediction = horizontalPrediction + directionFlip * leadTime
    end

    local maxHorizontal = math.max(10, distance * 0.20)
    if horizontalPrediction.Magnitude > maxHorizontal then
        horizontalPrediction = horizontalPrediction.Unit * maxHorizontal
    end

    local verticalLead = leadTime
    if isJumping then
        verticalLead = math.max(verticalLead, AUTO_SHOOT_JUMP_VERTICAL_LEAD)
    end
    local verticalPrediction = velocity.Y * verticalLead + acceleration.Y * (0.5 * verticalLead * verticalLead)
    verticalPrediction = math.clamp(verticalPrediction, -5, 5)

    local predicted = currentPosition + horizontalPrediction + Vector3.new(0, verticalPrediction, 0)

    if isJumping then
        local jumpBlend = math.clamp((motion and (os.clock() - (motion.jumpStartedAt or os.clock())) or 0) * 3, 0, 1)
        predicted = currentPosition:Lerp(predicted, 0.92 + jumpBlend * 0.08)
    elseif isZigZag then
        predicted = currentPosition:Lerp(predicted, 0.97)
    else
        predicted = currentPosition:Lerp(predicted, 0.96)
    end

    return predicted
end

function getAutoShootTargetPoint(character, origin)
    if not character then
        return nil
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    local upper = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    local head = character:FindFirstChild("Head")
    local parts = {upper, root, head}
    local bestPoint = nil
    local bestScore = math.huge

    for _, part in ipairs(parts) do
        if part and part:IsA("BasePart") then
            local predicted = getAutoShootPredictedPosition(part, origin)
            if predicted then
                local distance = (predicted - origin).Magnitude
                local score = distance
                if part == upper then
                    score = score - 8
                elseif part == root then
                    score = score - 5
                elseif part == head then
                    score = score + 8
                end
                if score < bestScore then
                    bestScore = score
                    bestPoint = predicted
                end
            end
        end
    end

    return bestPoint
end

function getMurdererTargetPart()
    local localChar = localPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then
        return nil, nil
    end

    local bestPlayer = nil
    local bestPart = nil
    local bestScore = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local roleIsMurderer = getRole(player) == "Murderer"
            local hasKnife = character and character:FindFirstChild("Knife") ~= nil

            if (roleIsMurderer or hasKnife) and root and humanoid and humanoid.Health > 0 then
                local distance = (root.Position - localRoot.Position).Magnitude
                local motion = autoShootMotion[player]
                local speedPenalty = 0
                if motion then
                    speedPenalty = math.min(motion.speed or 0, 80) * 0.01
                end
                local score = distance + speedPenalty

                if score < bestScore then
                    bestScore = score
                    bestPlayer = player
                    bestPart = root
                end
            end
        end
    end

    return bestPlayer, bestPart
end

function getGunShootRemote(gun)
    if not gun then return nil end

    local direct = gun:FindFirstChild("Shoot")
    if direct and (direct:IsA("RemoteEvent") or direct:IsA("UnreliableRemoteEvent")) then
        return direct
    end

    local handle = gun:FindFirstChild("Handle")
    if handle then
        local nested = handle:FindFirstChild("Shoot")
        if nested and (nested:IsA("RemoteEvent") or nested:IsA("UnreliableRemoteEvent")) then
            return nested
        end
    end

    return nil
end

gunFiredVisualEvent = nil
gunFiredVisualLastAt = 0

pcall(function()
    local clientServices = ReplicatedStorage:FindFirstChild("ClientServices")
    local weaponService = clientServices and clientServices:FindFirstChild("WeaponService")
    local event = weaponService and weaponService:FindFirstChild("GunFired")
    if event and event:IsA("RemoteEvent") then
        gunFiredVisualEvent = event
        event.OnClientEvent:Connect(function()
            gunFiredVisualLastAt = os.clock()
        end)
    end
end)

function playGunFiredVisual(handle, origin, targetPosition, hitPart)
    if not handle or not origin or not targetPosition or not gunFiredVisualEvent then
        return
    end

    task.delay(0.045, function()
        if not gunFiredVisualEvent or not gunFiredVisualEvent.Parent then
            return
        end
        if os.clock() - gunFiredVisualLastAt < 0.10 then
            return
        end
        if not handle.Parent then
            return
        end
        pcall(function()
            firesignal(
                gunFiredVisualEvent.OnClientEvent,
                handle,
                origin,
                targetPosition,
                hitPart
            )
        end)
    end)
end

function fireShotAtTarget(gun, targetPart)
    if not gun or not targetPart or not targetPart.Parent then
        return false
    end

    local shootEvent = getGunShootRemote(gun)
    if not shootEvent then
        return false
    end

    local handle = gun:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then
        return false
    end

    local origin = handle.Position
    local targetPosition = getAutoShootPredictedPosition(targetPart, origin)
    local character = targetPart.Parent
    local betterPoint = getAutoShootTargetPoint(character, origin)
    if betterPoint then
        targetPosition = betterPoint
    else
        return false
    end

    if not targetPosition or (targetPosition - origin).Magnitude < 0.01 then
        return false
    end

    local originCFrame = CFrame.lookAt(origin, targetPosition)
    local targetCFrame = CFrame.lookAt(
        targetPosition,
        targetPosition + targetPart.CFrame.LookVector
    )

    local ok = pcall(function()
        shootEvent:FireServer(originCFrame, targetCFrame)
    end)

    if ok then
        autoShootShotCooldownUntil = os.clock() + 0.12
        PlaySoundAsset(104895925840852, 1)
        playGunFiredVisual(handle, origin, targetPosition, targetPart)
    end

    return ok
end

function autoShoot()
    if not AutoShootEnabled or os.clock() < autoShootShotCooldownUntil then
        return
    end

    local gun = getGunForBolong()
    if not gun then
        return
    end

    local murderer, targetPart = getMurdererTargetPart()
    if not murderer or not targetPart then
        return
    end

    equipTool(gun)
    task.wait(0.025)

    local equippedGun = getToolByName(localPlayer, "Gun") or gun
    if fireShotAtTarget(equippedGun, targetPart) then
        return
    end

    if equippedGun ~= gun then
        fireShotAtTarget(gun, targetPart)
    end
end


MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "BolongFrutigerPanel"
MobileGui.ResetOnSpawn = false
MobileGui.IgnoreGuiInset = true
MobileGui.DisplayOrder = 10000
pcall(function()
    MobileGui.Parent = localPlayer:WaitForChild("PlayerGui")
end)

MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.BackgroundColor3 = Color3.fromRGB(40,190,255)
MainPanel.BackgroundTransparency = .77
MainPanel.Position = UDim2.new(.5,-98.5,.5,-24.5)
MainPanel.Size = UDim2.fromOffset(197, 49)
MainPanel.Visible = false
MainPanel.Active = true
MainPanel.Selectable = true
MainPanel.Parent = MobileGui

PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 24)
PanelCorner.Parent = MainPanel

PanelStroke = Instance.new("UIStroke")
PanelStroke.Color = Color3.fromRGB(0,195,255)
PanelStroke.Thickness = 2
PanelStroke.Transparency = .2
PanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
PanelStroke.Parent = MainPanel

ShootLabel = Instance.new("TextLabel")
ShootLabel.Size = UDim2.new(1,0,1,0)
ShootLabel.BackgroundTransparency = 1
ShootLabel.Text = "AUTO SHOOT"
ShootLabel.TextColor3 = Color3.fromRGB(255,255,255)
ShootLabel.TextSize = PanelScale
ShootLabel.ZIndex = 3
ShootLabel.Active = false
ShootLabel.Selectable = false
ShootLabel.Font = Enum.Font.FredokaOne
ShootLabel.Parent = MainPanel

BubbleContainer = Instance.new("Frame")
BubbleContainer.Name = "Bubbles"
BubbleContainer.Size = UDim2.fromScale(1, 1)
BubbleContainer.BackgroundTransparency = 1
BubbleContainer.ClipsDescendants = true
BubbleContainer.Parent = MainPanel

BubbleData = {
    {x = 0.18, y = 0.72, size = 5, delay = 0.00, duration = 1.8},
    {x = 0.38, y = 0.84, size = 4, delay = 0.45, duration = 1.6},
    {x = 0.67, y = 0.68, size = 6, delay = 0.90, duration = 1.9},
    {x = 0.84, y = 0.82, size = 4, delay = 1.25, duration = 1.7},
}

for i, data in ipairs(BubbleData) do
    local bubble = Instance.new("Frame")
    bubble.Name = "Bubble" .. i
    bubble.Size = UDim2.fromOffset(data.size, data.size)
    bubble.Position = UDim2.fromScale(data.x, data.y)
    bubble.AnchorPoint = Vector2.new(0.5, 0.5)
    bubble.BackgroundColor3 = Color3.fromRGB(235, 250, 255)
    bubble.BackgroundTransparency = 0.25
    bubble.BorderSizePixel = 0
    bubble.ZIndex = 2
    bubble.Parent = BubbleContainer

    local bubbleCorner = Instance.new("UICorner")
    bubbleCorner.CornerRadius = UDim.new(1, 0)
    bubbleCorner.Parent = bubble

    task.spawn(function()
        task.wait(data.delay)
        while bubble.Parent do
            bubble.Position = UDim2.fromScale(data.x, 0.90)
            bubble.BackgroundTransparency = 0.15
            local tween = TweenService:Create(
                bubble,
                TweenInfo.new(data.duration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                {
                    Position = UDim2.fromScale(data.x + 0.025, 0.12),
                    BackgroundTransparency = 0.75
                }
            )
            tween:Play()
            tween.Completed:Wait()
            task.wait(0.15)
        end
    end)
end

dragging, dragInputObject, dragStart, startPos, touchStartTime, dragMoved =
    false,nil,nil,nil,0,false

MainPanel.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch)
        and not dragging then

        uiPanelTouchActive = true
        dragging = true
        dragInputObject = input
        dragMoved = false
        touchStartTime = os.clock()
        dragStart = input.Position
        startPos = MainPanel.Position
        PanelStroke.Thickness = 3
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInputObject then
        local delta = input.Position - dragStart
        if delta.Magnitude > 5 then
            dragMoved = true
            MainPanel.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if dragging and input == dragInputObject then
        dragging = false
        dragInputObject = nil
        uiPanelTouchActive = activeTouchCount > 0
        PanelStroke.Thickness = 2

        if not dragMoved and os.clock() - touchStartTime < .7 then
            if AutoShootEnabled then
                PlaySoundAsset(104895925840852, 1)
                autoShoot()
            end
        end
    end
end)

function UpdatePanelScale(value)
    PanelScale = math.clamp(tonumber(value) or 10, 5, 20)

    local scaleRatio = PanelScale / 10
    local width = math.clamp(math.floor(197 * scaleRatio + 0.5), 99, 394)
    local height = math.clamp(math.floor(49 * scaleRatio + 0.5), 25, 98)

    MainPanel.Size = UDim2.fromOffset(width, height)
    ShootLabel.TextSize = math.clamp(math.floor(15 * scaleRatio + 0.5), 10, 30)
end

UpdatePanelScale(10)

InvisibleGui = Instance.new("ScreenGui")
InvisibleGui.Name = "BolongInvisiblePanel"
InvisibleGui.ResetOnSpawn = false
InvisibleGui.IgnoreGuiInset = true
InvisibleGui.DisplayOrder = 10000
pcall(function()
    InvisibleGui.Parent = localPlayer:WaitForChild("PlayerGui")
end)

InvisiblePanel = Instance.new("Frame")
InvisiblePanel.Name = "InvisiblePanel"
InvisiblePanel.BackgroundColor3 = Color3.fromRGB(40,190,255)
InvisiblePanel.BackgroundTransparency = .77
InvisiblePanel.Position = UDim2.new(.5,-98.5,.5,35)
InvisiblePanel.Size = UDim2.fromOffset(197, 49)
InvisiblePanel.Visible = false
InvisiblePanel.Active = true
InvisiblePanel.Selectable = true
InvisiblePanel.Parent = InvisibleGui

InvisiblePanelCorner = Instance.new("UICorner")
InvisiblePanelCorner.CornerRadius = UDim.new(0, 24)
InvisiblePanelCorner.Parent = InvisiblePanel

InvisiblePanelStroke = Instance.new("UIStroke")
InvisiblePanelStroke.Color = Color3.fromRGB(0,195,255)
InvisiblePanelStroke.Thickness = 2
InvisiblePanelStroke.Transparency = .2
InvisiblePanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
InvisiblePanelStroke.Parent = InvisiblePanel

InvisibleLabel = Instance.new("TextLabel")
InvisibleLabel.Size = UDim2.new(1,0,1,0)
InvisibleLabel.BackgroundTransparency = 1
InvisibleLabel.Text = "INVISIBLE"
InvisibleLabel.TextColor3 = Color3.fromRGB(255,255,255)
InvisibleLabel.TextSize = 15
InvisibleLabel.ZIndex = 3
InvisibleLabel.Active = false
InvisibleLabel.Selectable = false
InvisibleLabel.Font = Enum.Font.FredokaOne
InvisibleLabel.Parent = InvisiblePanel

InvisibleBubbleContainer = Instance.new("Frame")
InvisibleBubbleContainer.Name = "Bubbles"
InvisibleBubbleContainer.Size = UDim2.fromScale(1,1)
InvisibleBubbleContainer.BackgroundTransparency = 1
InvisibleBubbleContainer.ClipsDescendants = true
InvisibleBubbleContainer.Parent = InvisiblePanel

InvisibleBubbleData = {
    {x = 0.18, y = 0.72, size = 5, delay = 0.00, duration = 1.8},
    {x = 0.38, y = 0.84, size = 4, delay = 0.45, duration = 1.6},
    {x = 0.67, y = 0.68, size = 6, delay = 0.90, duration = 1.9},
    {x = 0.84, y = 0.82, size = 4, delay = 1.25, duration = 1.7},
}

for i, data in ipairs(InvisibleBubbleData) do
    local bubble = Instance.new("Frame")
    bubble.Name = "Bubble" .. i
    bubble.Size = UDim2.fromOffset(data.size, data.size)
    bubble.Position = UDim2.fromScale(data.x, data.y)
    bubble.AnchorPoint = Vector2.new(0.5,0.5)
    bubble.BackgroundColor3 = Color3.fromRGB(235,250,255)
    bubble.BackgroundTransparency = 0.25
    bubble.BorderSizePixel = 0
    bubble.ZIndex = 2
    bubble.Parent = InvisibleBubbleContainer

    local bubbleCorner = Instance.new("UICorner")
    bubbleCorner.CornerRadius = UDim.new(1,0)
    bubbleCorner.Parent = bubble

    task.spawn(function()
        task.wait(data.delay)
        while bubble.Parent do
            bubble.Position = UDim2.fromScale(data.x,0.90)
            bubble.BackgroundTransparency = 0.15
            local tween = TweenService:Create(
                bubble,
                TweenInfo.new(data.duration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                {Position = UDim2.fromScale(data.x + 0.025,0.12), BackgroundTransparency = 0.75}
            )
            tween:Play()
            tween.Completed:Wait()
            task.wait(0.15)
        end
    end)
end

InvisiblePanel.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch)
        and not invisibleDragging then
        invisibleDragging = true
        invisibleDragInput = input
        invisibleDragMoved = false
        invisibleTouchStartTime = os.clock()
        invisibleDragStart = input.Position
        invisibleStartPos = InvisiblePanel.Position
        InvisiblePanelStroke.Thickness = 3
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if invisibleDragging and input == invisibleDragInput then
        local delta = input.Position - invisibleDragStart
        if delta.Magnitude > 5 then
            invisibleDragMoved = true
            InvisiblePanel.Position = UDim2.new(
                invisibleStartPos.X.Scale,
                invisibleStartPos.X.Offset + delta.X,
                invisibleStartPos.Y.Scale,
                invisibleStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if invisibleDragging and input == invisibleDragInput then
        invisibleDragging = false
        invisibleDragInput = nil
        InvisiblePanelStroke.Thickness = 2

        if not invisibleDragMoved and os.clock() - invisibleTouchStartTime < .7 then
            SetInvisible(false)
        end
    end
end)


AimbotGui = Instance.new("ScreenGui")
AimbotGui.Name = "BolongAimbotPanel"
AimbotGui.ResetOnSpawn = false
AimbotGui.Parent = PlayerGui

AimbotPanel = Instance.new("Frame")
AimbotPanel.Name = "AimbotPanel"
AimbotPanel.AnchorPoint = Vector2.new(0.5, 0.5)
AimbotPanel.BackgroundColor3 = Color3.fromRGB(205, 245, 255)
AimbotPanel.BackgroundTransparency = 0.75
AimbotPanel.Position = UDim2.fromScale(0.5, 0.5)
AimbotPanel.Size = UDim2.fromOffset(80, 80)
AimbotPanel.Visible = false
AimbotPanel.Active = true
AimbotPanel.Selectable = true
AimbotPanel.Parent = AimbotGui

AimbotCorner = Instance.new("UICorner")
AimbotCorner.CornerRadius = UDim.new(0, 10)
AimbotCorner.Parent = AimbotPanel

AimbotStroke = Instance.new("UIStroke")
AimbotStroke.Color = Color3.fromRGB(0, 170, 255)
AimbotStroke.Thickness = 2
AimbotStroke.Transparency = 0.15
AimbotStroke.Parent = AimbotPanel

AimbotIcon = Instance.new("ImageLabel")
AimbotIcon.Name = "AimlockIcon"
AimbotIcon.AnchorPoint = Vector2.new(0.5, 0.5)
AimbotIcon.Position = UDim2.fromScale(0.5, 0.38)
AimbotIcon.Size = UDim2.fromOffset(34, 34)
AimbotIcon.BackgroundTransparency = 1
AimbotIcon.Image = "rbxassetid://78275912674145"
AimbotIcon.ImageTransparency = 0
AimbotIcon.ScaleType = Enum.ScaleType.Fit
AimbotIcon.ZIndex = 4
AimbotIcon.Active = false
AimbotIcon.Parent = AimbotPanel

AimbotLabel = Instance.new("TextLabel")
AimbotLabel.AnchorPoint = Vector2.new(0.5, 0.5)
AimbotLabel.Position = UDim2.fromScale(0.5, 0.78)
AimbotLabel.Size = UDim2.fromScale(0.9, 0.25)
AimbotLabel.BackgroundTransparency = 1
AimbotLabel.Text = "AIMLOCK"
AimbotLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotLabel.TextSize = 12
AimbotLabel.TextScaled = false
AimbotLabel.TextWrapped = false
AimbotLabel.Font = Enum.Font.GothamBold
AimbotLabel.TextXAlignment = Enum.TextXAlignment.Center
AimbotLabel.TextYAlignment = Enum.TextYAlignment.Center
AimbotLabel.Active = false
AimbotLabel.Selectable = false
AimbotLabel.ZIndex = 4
AimbotLabel.Parent = AimbotPanel

task.spawn(function()
    while AimbotIcon and AimbotIcon.Parent do
        AimbotIcon.Rotation = AimbotIcon.Rotation + 2.5
        task.wait(0.02)
    end
end)

AimbotBubbleContainer = Instance.new("Frame")
AimbotBubbleContainer.Name = "Bubbles"
AimbotBubbleContainer.Size = UDim2.fromScale(1, 1)
AimbotBubbleContainer.BackgroundTransparency = 1
AimbotBubbleContainer.ClipsDescendants = true
AimbotBubbleContainer.ZIndex = 2
AimbotBubbleContainer.Parent = AimbotPanel

AimbotBubbleData = {
    {x = 0.25, size = 5, delay = 0.0, duration = 1.55},
    {x = 0.50, size = 4, delay = 0.52, duration = 1.75},
    {x = 0.74, size = 6, delay = 0.95, duration = 1.65},
}

for i, data in ipairs(AimbotBubbleData) do
    local bubble = Instance.new("Frame")
    bubble.Name = "Bubble" .. i
    bubble.Size = UDim2.fromOffset(data.size, data.size)
    bubble.Position = UDim2.fromScale(data.x, 0.92)
    bubble.AnchorPoint = Vector2.new(0.5, 0.5)
    bubble.BackgroundColor3 = Color3.fromRGB(235, 250, 255)
    bubble.BackgroundTransparency = 0.18
    bubble.BorderSizePixel = 0
    bubble.ZIndex = 2
    bubble.Parent = AimbotBubbleContainer

    local bubbleCorner = Instance.new("UICorner")
    bubbleCorner.CornerRadius = UDim.new(1, 0)
    bubbleCorner.Parent = bubble

    task.spawn(function()
        task.wait(data.delay)
        while bubble.Parent do
            bubble.Position = UDim2.fromScale(data.x, 0.92)
            bubble.BackgroundTransparency = 0.18
            local tween = TweenService:Create(
                bubble,
                TweenInfo.new(data.duration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                {
                    Position = UDim2.fromScale(data.x + 0.02, 0.12),
                    BackgroundTransparency = 0.78
                }
            )
            tween:Play()
            tween.Completed:Wait()
            task.wait(0.12)
        end
    end)
end

AimbotCircleGui = Instance.new("ScreenGui")
AimbotCircleGui.Name = "BolongAimbotFOV"
AimbotCircleGui.ResetOnSpawn = false
AimbotCircleGui.IgnoreGuiInset = true
AimbotCircleGui.Parent = PlayerGui

AimbotCircle = Instance.new("Frame")
AimbotCircle.Name = "FOVWater"
AimbotCircle.AnchorPoint = Vector2.new(0.5, 0.5)
AimbotCircle.Position = UDim2.fromScale(0.5, 0.5)
AimbotCircle.BackgroundTransparency = 1
AimbotCircle.Visible = false
AimbotCircle.Parent = AimbotCircleGui

CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = AimbotCircle

CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Color3.fromRGB(70, 190, 255)
CircleStroke.Thickness = 3
CircleStroke.Transparency = 0.08
CircleStroke.Parent = AimbotCircle


function UpdateAimbotVisuals()
    local diameter = math.clamp(aimbotFOV * 12, 24, 240)
    AimbotCircle.Size = UDim2.fromOffset(diameter, diameter)
    local visible = aimbotActive and aimbotFOVVisible and aimlockEngaged
    AimbotCircle.Visible = visible

    AimbotPanel.Visible = aimbotActive
end

aimDragging, aimDragInput, aimDragStart, aimStartPos = false, nil, nil, nil
aimPressStart = nil
aimWasDragged = false

AimbotPanel.InputBegan:Connect(function(input)
    if aimDragging then
        return
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        uiPanelTouchActive = true
        aimDragging = true
        aimDragInput = input
        aimDragStart = input.Position
        aimPressStart = input.Position
        aimWasDragged = false
        aimStartPos = AimbotPanel.Position
        AimbotStroke.Thickness = 3
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if aimDragging and input == aimDragInput then
        local delta = input.Position - aimDragStart
        if delta.Magnitude > 6 then
            aimWasDragged = true
        end

        AimbotPanel.Position = UDim2.new(
            aimStartPos.X.Scale,
            aimStartPos.X.Offset + delta.X,
            aimStartPos.Y.Scale,
            aimStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if aimDragging and input == aimDragInput then
        aimDragging = false
        aimDragInput = nil
        uiPanelTouchActive = activeTouchCount > 0
        AimbotStroke.Thickness = 2

        if not aimWasDragged and aimPressStart then
            PlaySoundAsset(136328893130485, 1)
            aimlockEngaged = not aimlockEngaged
            aimbotFOVVisible = aimlockEngaged
            if not aimlockEngaged then
                clearAimlockTarget()
            end
            UpdateAimbotVisuals()
        end

        aimPressStart = nil
        aimWasDragged = false
    end
end)

function UpdateAimbotPanelScale(value)
    AimbotPanelScale = math.clamp(tonumber(value) or 8, 6, 16)

    local diameter = AimbotPanelScale * 10
    AimbotPanel.Size = UDim2.fromOffset(diameter, diameter)

    AimbotLabel.Size = UDim2.fromScale(0.9, 0.9)
    AimbotLabel.TextSize = math.clamp(AimbotPanelScale * 1.25, 10, 18)
    local iconSize = math.clamp(AimbotPanelScale * 4.25, 26, 38)
    AimbotIcon.Size = UDim2.fromOffset(iconSize, iconSize)
end

UpdateAimbotPanelScale(AimbotPanelScale)
aimbotFOVVisible = false
aimlockEngaged = false
UpdateAimbotVisuals()


function isPlayerAlive(player)
    local char = player and player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

function killTarget(targetPlayer)
    local knife = getKnife()
    if not knife then return false end

    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local targetChar = targetPlayer and targetPlayer.Character
    local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

    if not hrp or not targetHrp or not isPlayerAlive(targetPlayer) then
        return false
    end

    if (hrp.Position - targetHrp.Position).Magnitude > 300 then
        return false
    end

    equipTool(knife)

    local lookAt = Vector3.new(targetHrp.Position.X, hrp.Position.Y, targetHrp.Position.Z)
    if (lookAt - hrp.Position).Magnitude > 0.01 then
        hrp.CFrame = CFrame.lookAt(hrp.Position, lookAt)
    end

    pcall(function()
        knife:Activate()
    end)

    return true
end

function killAll()
    local plr = localPlayer
    if not plr then return false end

    local char = plr.Character
    if not char then return false end

    local knife = char:FindFirstChild("Knife")
    if not knife then return false end

    local events = knife:FindFirstChild("Events")
    if not events then return false end

    local HandleTouched = events:FindFirstChild("HandleTouched")
    if not HandleTouched or not HandleTouched:IsA("RemoteEvent") then
        return false
    end

    local fired = false
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= plr and v.Character then
            local primary = v.Character:FindFirstChild("HumanoidRootPart")
            if primary then
                local ok = pcall(function()
                    HandleTouched:FireServer(primary)
                end)
                if ok then
                    fired = true
                end
                task.wait(0.05)
            end
        end
    end

    return fired
end

function killSheriff()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and getRole(p) == "Sheriff" and p.Character then
            killTarget(p)
            break
        end
    end
end

task.spawn(function()
    while task.wait(0.1) do
        if killAuraActive and getRole(localPlayer) == "Murderer" and not autoFarmActive then
            local knife = getKnife()
            local char = localPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if knife and hrp then
                equipTool(knife)

                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= localPlayer and p.Character then
                        local targetHrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if targetHrp and (hrp.Position - targetHrp.Position).Magnitude <= killAuraDistance then
                            pcall(function()
                                knife:Activate()
                            end)
                        end
                    end
                end
            end
        end
    end
end)



local touchFlingEnabled = false
local touchFlingThread = nil

local function touchFlingLoop()
    local lp = localPlayer
    local hiddenfling = function()
        local c, hrp, vel, movel = nil, nil, nil, 0.1

        while touchFlingEnabled do
            RunService.Heartbeat:Wait()
            c = lp.Character
            hrp = c and c:FindFirstChild("HumanoidRootPart")

            if hrp then
                vel = hrp.Velocity
                pcall(function()
                    hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                end)
                RunService.RenderStepped:Wait()
                if not touchFlingEnabled or not hrp.Parent then
                    break
                end
                pcall(function()
                    hrp.Velocity = vel
                end)
                RunService.Stepped:Wait()
                if not touchFlingEnabled or not hrp.Parent then
                    break
                end
                pcall(function()
                    hrp.Velocity = vel + Vector3.new(0, movel, 0)
                end)
                movel = -movel
            end
        end
    end

    hiddenfling()
end

function SetTouchFling(enabled)
    touchFlingEnabled = enabled == true

    if touchFlingEnabled then
        if not touchFlingThread or coroutine.status(touchFlingThread) == "dead" then
            touchFlingThread = coroutine.create(touchFlingLoop)
            coroutine.resume(touchFlingThread)
        end
    else
        touchFlingThread = nil
        local character = localPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function()
                hrp.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end
end

localPlayer.CharacterAdded:Connect(function(character)
    if touchFlingEnabled then
        task.defer(function()
            character:WaitForChild("HumanoidRootPart", 5)
        end)
    end
end)

function FindPlayerByRole(role)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and GetPlayerRoleMM2(p) == role then
            return p
        end
    end
    return nil
end

function PlayMiscEmote(emoteName)
    if not emoteName or emoteName == "" then return end

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local playEmote = remotes and remotes:FindFirstChild("PlayEmote")

    if not playEmote then
        playEmote = ReplicatedStorage:FindFirstChild("PlayEmote", true)
    end

    if playEmote then
        pcall(function()
            if playEmote:IsA("RemoteEvent") then
                playEmote:FireServer(emoteName)
            elseif playEmote:IsA("BindableEvent") then
                playEmote:Fire(emoteName)
            end
        end)
    end
end


antiFlingEnabled = false
antiFlingConnection = nil

function SetAntiFling(enabled)
    antiFlingEnabled = enabled == true

    if antiFlingConnection then
        antiFlingConnection:Disconnect()
        antiFlingConnection = nil
    end

    if not antiFlingEnabled then return end

    antiFlingConnection = RunService.Heartbeat:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.AssemblyLinearVelocity.Magnitude > 250 then
                    pcall(function()
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end)
                end
            end
        end
    end)
end


PickupGui = Instance.new("ScreenGui")
PickupGui.Name = "BolongPickupPanel"
PickupGui.ResetOnSpawn = false
PickupGui.IgnoreGuiInset = true
PickupGui.Parent = PlayerGui

PickupPanel = Instance.new("Frame")
PickupPanel.Name = "PickupPanel"
PickupPanel.AnchorPoint = Vector2.new(0.5, 0.5)
PickupPanel.Position = UDim2.fromScale(0.5, 0.68)
PickupPanel.Size = UDim2.fromOffset(72, 72)
PickupPanel.BackgroundColor3 = Color3.fromRGB(40, 190, 255)
PickupPanel.BackgroundTransparency = 0.77
PickupPanel.Visible = false
PickupPanel.Active = true
PickupPanel.Parent = PickupGui

PickupCorner = Instance.new("UICorner")
PickupCorner.CornerRadius = UDim.new(1, 0)
PickupCorner.Parent = PickupPanel

PickupStroke = Instance.new("UIStroke")
PickupStroke.Color = Color3.fromRGB(0, 170, 255)
PickupStroke.Thickness = 2
PickupStroke.Transparency = 0.08
PickupStroke.Parent = PickupPanel

PickupLabel = Instance.new("TextLabel")
PickupLabel.Size = UDim2.fromScale(0.88, 0.88)
PickupLabel.Position = UDim2.fromScale(0.06, 0.06)
PickupLabel.BackgroundTransparency = 1
PickupLabel.Text = "PICK UP GUN"
PickupLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PickupLabel.TextSize = 11
PickupLabel.Font = Enum.Font.GothamBold
PickupLabel.TextWrapped = true
PickupLabel.Active = false
PickupLabel.Selectable = false
PickupLabel.Parent = PickupPanel

pickupDragging, pickupDragInput, pickupDragStart, pickupStartPos = false, nil, nil, nil
pickupDragMoved = false
pickupPressStart = 0

local function pickupGunNow()
    if not autoPickupGunActive then
        return
    end

    PlaySoundAsset(9112751536, 1)

    local part = getGunDrop()
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not part or not hrp then
        return
    end

    pcall(function()
        hrp.CFrame = part.CFrame
    end)
end

PickupPanel.InputBegan:Connect(function(input)
    if pickupDragging then
        return
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        pickupPanelInteracting = true
        uiPanelTouchActive = true
        pickupDragging = true
        pickupDragMoved = false
        pickupPressStart = os.clock()
        pickupDragInput = input
        pickupDragStart = input.Position
        pickupStartPos = PickupPanel.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if pickupDragging and input == pickupDragInput then
        local delta = input.Position - pickupDragStart
        if delta.Magnitude > 6 then
            pickupDragMoved = true
        end
        PickupPanel.Position = UDim2.new(
            pickupStartPos.X.Scale, pickupStartPos.X.Offset + delta.X,
            pickupStartPos.Y.Scale, pickupStartPos.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if pickupDragging and input == pickupDragInput then
        pickupDragging = false
        pickupDragInput = nil
        pickupPanelInteracting = false
        uiPanelTouchActive = activeTouchCount > 0

        if not pickupDragMoved and os.clock() - pickupPressStart < 0.45 then
            pickupGunNow()
        end
    end
end)
function UpdatePickupPanelScale(value)
    local scale = math.clamp(tonumber(value) or 10, 5, 20)
    local diameter = math.clamp(scale * 5.5, 40, 110)
    PickupPanel.Size = UDim2.fromOffset(diameter, diameter)
    PickupLabel.TextSize = math.clamp(scale * 0.8, 7, 16)
end
UpdatePickupPanelScale(8)


autoThrowKnifeEnabled = false
autoThrowCycle = 0
autoThrowAnimationConnection = nil
autoThrowCharacterConnection = nil
autoThrowLastWindupAt = 0
AUTO_THROW_FOV_DOT = 0.75
AUTO_THROW_WINDUP_ID = "1957618848"
AUTO_THROW_READY_ID = "15478370930"
AUTO_THROW_SWING_ID = "112035104498952"

function getKnifeThrownEvent()
    local character = localPlayer.Character
    if not character then
        return nil, nil
    end

    local knife = character:FindFirstChild("Knife")
    local events = knife and knife:FindFirstChild("Events")
    local event = events and events:FindFirstChild("KnifeThrown")
    if event and event:IsA("RemoteEvent") then
        return event, knife
    end

    return nil, knife
end

function getAutoThrowSilentTarget()
    local camera = Workspace.CurrentCamera
    local character = localPlayer.Character
    if not camera or not character then
        return nil
    end

    local originPart = character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
    if not originPart then
        return nil
    end

    local origin = originPart.Position
    local forward = camera.CFrame.LookVector
    local bestTarget = nil
    local bestScore = -math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local role = GetPlayerRoleMM2(player)

            if role == "Innocent" or role == "Sheriff" or role == "Hero" then
                local targetCharacter = player.Character
                local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
                local targetPart = targetCharacter:FindFirstChild("HumanoidRootPart")
                    or targetCharacter:FindFirstChild("UpperTorso")
                    or targetCharacter:FindFirstChild("Torso")

                if humanoid and humanoid.Health > 0 and targetPart and targetPart:IsA("BasePart") then
                    local offset = targetPart.Position - origin
                    local distance = offset.Magnitude

                    if distance > 0.05 then
                        local direction = offset.Unit
                        local dot = forward:Dot(direction)

                        if dot >= AUTO_THROW_FOV_DOT then
                            local score = (dot * 1000) - distance
                            if score > bestScore then
                                bestScore = score
                                bestTarget = targetPart
                            end
                        end
                    end
                end
            end
        end
    end

    return bestTarget
end

function playKnifeSwingAnimation()
    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return
    end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end

    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. AUTO_THROW_SWING_ID

    local ok, track = pcall(function()
        return animator:LoadAnimation(animation)
    end)

    if ok and track then
        track.Priority = Enum.AnimationPriority.Action
        track:Play(0.03, 1, 1)
        task.delay(1, function()
            pcall(function()
                track:Stop(0.08)
                track:Destroy()
            end)
            pcall(function()
                animation:Destroy()
            end)
        end)
    else
        animation:Destroy()
    end
end

function fireKnifeThrowAtTarget(targetPart)
    if not targetPart or not targetPart.Parent then
        return false
    end

    local event, knife = getKnifeThrownEvent()
    if not event or not knife then
        return false
    end

    local handle = knife:FindFirstChild("Handle")
    local character = localPlayer.Character
    local originPart = handle
        or (character and character:FindFirstChild("HumanoidRootPart"))
        or (character and character:FindFirstChild("UpperTorso"))
        or (character and character:FindFirstChild("Torso"))

    if not originPart or not originPart:IsA("BasePart") then
        return false
    end

    local targetPosition = targetPart.Position
    local throwCFrame = CFrame.lookAt(originPart.Position, targetPosition)
    local targetCFrame = CFrame.new(targetPosition)

    local ok = pcall(function()
        event:FireServer(throwCFrame, targetCFrame)
    end)

    if ok then
        playKnifeSwingAnimation()
    end

    return ok
end

function getAnimationId(track)
    if not track then
        return ""
    end
    local animation = track.Animation
    if not animation then
        return ""
    end
    local id = tostring(animation.AnimationId or "")
    return id:match("(%d+)$") or id
end

function handleKnifeAnimation(track)
    if not autoThrowKnifeEnabled or not track then
        return
    end

    local character = localPlayer.Character
    if not character or not character:FindFirstChild("Knife") then
        return
    end

    local id = getAnimationId(track)

    if id == AUTO_THROW_WINDUP_ID then
        autoThrowLastWindupAt = os.clock()
        return
    end

    if id ~= AUTO_THROW_READY_ID then
        return
    end

    if os.clock() - autoThrowLastWindupAt > 2 then
        return
    end

    autoThrowLastWindupAt = 0

    local target = getAutoThrowSilentTarget()
    if target then
        fireKnifeThrowAtTarget(target)
    end
end

function disconnectAutoThrowAnimationConnections()
    if autoThrowAnimationConnection then
        pcall(function()
            autoThrowAnimationConnection:Disconnect()
        end)
        autoThrowAnimationConnection = nil
    end

    if autoThrowCharacterConnection then
        pcall(function()
            autoThrowCharacterConnection:Disconnect()
        end)
        autoThrowCharacterConnection = nil
    end
end

function watchKnifeAnimations(character)
    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        humanoid = character:WaitForChild("Humanoid", 5)
    end
    if not humanoid then
        return
    end

    if autoThrowAnimationConnection then
        pcall(function()
            autoThrowAnimationConnection:Disconnect()
        end)
    end

    autoThrowAnimationConnection = humanoid.AnimationPlayed:Connect(function(track)
        handleKnifeAnimation(track)
    end)
end

function disableAutoThrowKnife()
    autoThrowKnifeEnabled = false
    autoThrowCycle = autoThrowCycle + 1
    autoThrowLastWindupAt = 0
    disconnectAutoThrowAnimationConnections()
end

function enableAutoThrowKnife()
    disableAutoThrowKnife()
    autoThrowKnifeEnabled = true
    autoThrowCycle = autoThrowCycle + 1

    watchKnifeAnimations(localPlayer.Character)

    autoThrowCharacterConnection = localPlayer.CharacterAdded:Connect(function(character)
        if autoThrowKnifeEnabled then
            task.defer(function()
                watchKnifeAnimations(character)
            end)
        end
    end)
end

function disconnectFakeBombTool(tool)
    local connection = fakeBombToolConnections[tool]
    if connection then
        pcall(function()
            connection:Disconnect()
        end)
        fakeBombToolConnections[tool] = nil
    end
end

function disconnectAllFakeBombTools()
    for tool, connection in pairs(fakeBombToolConnections) do
        if connection then
            pcall(function()
                connection:Disconnect()
            end)
        end
        fakeBombToolConnections[tool] = nil
    end
end

function getFakeBombTool()
    local character = localPlayer.Character
    local backpack = localPlayer:FindFirstChildOfClass("Backpack")

    local tool = character and character:FindFirstChild("FakeBomb")
    if tool and tool:IsA("Tool") then
        return tool
    end

    tool = backpack and backpack:FindFirstChild("FakeBomb")
    if tool and tool:IsA("Tool") then
        return tool
    end

    return nil
end

function isFakeBombMouseLockOn()
    if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        return true
    end

    return fakeBombMouseLockActive == true
end

function getFakeBombFreeAimCFrame()
    local camera = Workspace.CurrentCamera
    if not camera then
        return nil
    end

    if not UserInputService.TouchEnabled or UserInputService.MouseEnabled then
        local mouse = localPlayer:GetMouse()
        local hit = nil
        local ok = pcall(function()
            hit = mouse.Hit
        end)

        if ok and typeof(hit) == "CFrame" then
            return hit
        end
    end

    local pointer = fakeBombLastPointer
    if not pointer then
        pointer = UserInputService:GetMouseLocation()
    end

    local ray = camera:ViewportPointToRay(pointer.X, pointer.Y)
    local origin = camera.CFrame.Position
    return CFrame.lookAt(origin + ray.Direction * 50, origin + ray.Direction * 51)
end

function getFakeBombMouseLockCFrame()
    local camera = Workspace.CurrentCamera
    if not camera then
        return nil
    end

    local character = localPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local origin = root and root.Position or camera.CFrame.Position
    local direction = camera.CFrame.LookVector

    if direction.Magnitude <= 0.001 then
        return nil
    end

    direction = direction.Unit
    local target = origin + direction * 50

    return CFrame.lookAt(target, target + direction)
end

function getFakeBombThrowCFrame()
    if isFakeBombMouseLockOn() then
        return getFakeBombMouseLockCFrame()
    end

    return getFakeBombFreeAimCFrame()
end

function triggerFakeBombRemotes()
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    local extras = remotes and remotes:FindFirstChild("Extras")
    local replicateToy = extras and extras:FindFirstChild("ReplicateToy")

    if replicateToy and replicateToy:IsA("RemoteFunction") then
        pcall(function()
            replicateToy:InvokeServer("FakeBomb")
        end)
    end

    local misc = remotes and remotes:FindFirstChild("Misc")
    local playEmote = misc and misc:FindFirstChild("PlayEmote")
    if playEmote then
        pcall(function()
            if playEmote:IsA("RemoteEvent") then
                playEmote:Fire("FakeBomb")
            elseif playEmote:IsA("BindableEvent") then
                playEmote:Fire("FakeBomb")
            end
        end)
    end
end

function fireFakeBombThrow()
    if not fakeBombJumpEnabled or not fakeBombJumpReady then
        return false
    end

    local char = localPlayer.Character
    if not char then
        return false
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    if not hrp or not humanoid then
        return false
    end

    local bomb = char:FindFirstChild("FakeBomb")
    if not bomb then
        return false
    end

    local remote = bomb:FindFirstChild("Remote")
    if not remote or not remote:IsA("RemoteEvent") then
        return false
    end

    fakeBombJumpReady = false
    fakeBombCooldownUntil = os.clock() + fakeBombCooldownTime

    local bombPos = hrp.Position - Vector3.new(0, 3.15, 0)
    pcall(function()
        remote:FireServer(CFrame.new(bombPos), 50)
    end)

    if fakeBombAutoJumpEnabled then
        task.wait(0.06)
        if humanoid.Parent then
            fakeBombScreenTouchSuppress = true
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            humanoid.Jump = true
            task.delay(0.25, function()
                fakeBombScreenTouchSuppress = false
            end)
        end
    end

    task.spawn(function()
        while fakeBombJumpEnabled and os.clock() < fakeBombCooldownUntil do
            local remaining = math.max(0, fakeBombCooldownUntil - os.clock())
            if FakeBombJumpLabel and FakeBombJumpLabel.Parent then
                FakeBombJumpLabel.Text = tostring(math.ceil(remaining))
            end
            task.wait(1)
        end

        if fakeBombJumpEnabled then
            fakeBombJumpReady = true
            if FakeBombJumpLabel and FakeBombJumpLabel.Parent then
                FakeBombJumpLabel.Text = "Ready"
            end
        end
    end)

    return true
end

function onFakeBombScreenTouchJump()
    if fakeBombVariant ~= "Manual" then
        return
    end

    if not fakeBombJumpEnabled or fakeBombScreenTouchSuppress then
        return
    end

    local char = localPlayer.Character
    local bomb = char and char:FindFirstChild("FakeBomb")
    if not bomb or not bomb:IsA("Tool") then
        return
    end

    fireFakeBombThrow()
end

function setupFakeBombScreenTouchHumanoid(character)
    if fakeBombScreenTouchJumpConnection then
        pcall(function()
            fakeBombScreenTouchJumpConnection:Disconnect()
        end)
        fakeBombScreenTouchJumpConnection = nil
    end

    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        humanoid = character and character:WaitForChild("Humanoid", 5)
    end
    if not humanoid then
        return
    end

    fakeBombScreenTouchJumpConnection = humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Jumping then
            onFakeBombScreenTouchJump()
        end
    end)
end

function updateFakeBombJumpPanelScale(value)
    local v = math.clamp(tonumber(value) or 10, 6, 20)
    local size = math.floor(60 + ((v - 6) / 14) * 95 + 0.5)
    size = math.clamp(size, 60, 155)

    if FakeBombJumpPanel then
        FakeBombJumpPanel.Size = UDim2.fromOffset(size, size)
    end

    if FakeBombJumpLabel then
        FakeBombJumpLabel.TextSize = math.clamp(math.floor(size * 0.23), 16, 34)
    end
end

function ensureFakeBombJumpPanel()
    if FakeBombJumpPanel and FakeBombJumpPanel.Parent then
        return
    end

    local gui = PlayerGui:FindFirstChild("BolongFakeBombJump")
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = "BolongFakeBombJump"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 10001
        gui.Parent = PlayerGui
    end

    local panel = Instance.new("Frame")
    panel.Name = "FakeBombJumpPanel"
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.fromScale(0.5, 0.72)
    panel.Size = UDim2.fromOffset(100, 100)
    panel.BackgroundColor3 = Color3.fromRGB(72, 200, 255)
    panel.BackgroundTransparency = 0.77
    panel.BorderSizePixel = 0
    panel.Active = true
    panel.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = panel

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(120, 225, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.15
    stroke.Parent = panel

    local label = Instance.new("TextLabel")
    label.Name = "Status"
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = "Ready"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 23
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Active = false
    label.Selectable = false
    label.ZIndex = 3
    label.Parent = panel

    FakeBombJumpPanel = panel
    FakeBombJumpLabel = label

    panel.InputBegan:Connect(function(input)
        if fakeBombPanelDragging then
            return
        end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        uiPanelTouchActive = true
        fakeBombPanelDragging = true
        fakeBombPanelDragInput = input
        fakeBombPanelDragStart = input.Position
        fakeBombPanelStartPos = panel.Position
        fakeBombPanelDragMoved = false
        fakeBombPanelTouchStart = os.clock()
        stroke.Thickness = 3
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not fakeBombPanelDragging or input ~= fakeBombPanelDragInput then
            return
        end

        local delta = input.Position - fakeBombPanelDragStart
        if delta.Magnitude > 6 then
            fakeBombPanelDragMoved = true
        end

        panel.Position = UDim2.new(
            fakeBombPanelStartPos.X.Scale,
            fakeBombPanelStartPos.X.Offset + delta.X,
            fakeBombPanelStartPos.Y.Scale,
            fakeBombPanelStartPos.Y.Offset + delta.Y
        )
    end)

    UserInputService.InputEnded:Connect(function(input)
        if not fakeBombPanelDragging or input ~= fakeBombPanelDragInput then
            return
        end

        fakeBombPanelDragging = false
        fakeBombPanelDragInput = nil
        uiPanelTouchActive = activeTouchCount > 0
        stroke.Thickness = 2

        if not fakeBombPanelDragMoved and os.clock() - fakeBombPanelTouchStart < 0.4 then
            if fakeBombVariant == "Auto" then
                fireFakeBombThrow()
            end
        end
    end)

    updateFakeBombJumpPanelScale(10)
end

function connectFakeBombTool(tool)
    if not tool or not tool:IsA("Tool") or tool.Name ~= "FakeBomb" then
        return
    end

    disconnectFakeBombTool(tool)
    fakeBombToolConnections[tool] = true
end
function scanFakeBombToolsOnce()
    local character = localPlayer.Character
    local backpack = localPlayer:FindFirstChildOfClass("Backpack")

    if character then
        local tool = character:FindFirstChild("FakeBomb")
        if tool then
            connectFakeBombTool(tool)
        end
    end

    if backpack then
        local tool = backpack:FindFirstChild("FakeBomb")
        if tool then
            connectFakeBombTool(tool)
        end
    end
end

function setupFakeBombMouseLock()
    local playerScripts = localPlayer:FindFirstChild("PlayerScripts")
    if not playerScripts then
        playerScripts = localPlayer:WaitForChild("PlayerScripts", 10)
    end

    local mouseLock = playerScripts and playerScripts:FindFirstChild("MouseLock")
    if not mouseLock and playerScripts then
        mouseLock = playerScripts:WaitForChild("MouseLock", 10)
    end

    local toggleSignal = mouseLock and mouseLock:FindFirstChild("MouseLockToggled")
    if not toggleSignal and mouseLock then
        toggleSignal = mouseLock:WaitForChild("MouseLockToggled", 10)
    end

    if toggleSignal and toggleSignal:IsA("BindableEvent") then
        pcall(function()
            fakeBombMouseLockConnection = toggleSignal.Event:Connect(function(enabled)
                fakeBombMouseLockActive = enabled == true
            end)
        end)
    end
end

function enableFakeBombJump()
    fakeBombJumpEnabled = true
    scanFakeBombToolsOnce()
end

function disableFakeBombJump()
    fakeBombJumpEnabled = false
    fakeBombAutoJumpEnabled = true
    disconnectAllFakeBombTools()
end

setupFakeBombMouseLock()

if localPlayer.Character then
    localPlayer.Character.ChildAdded:Connect(function(child)
        if child.Name == "FakeBomb" then
            connectFakeBombTool(child)
        end
    end)
    task.defer(setupFakeBombScreenTouchHumanoid, localPlayer.Character)
end

localPlayer.CharacterAdded:Connect(function(character)
    if fakeBombCharacterConnection then
        pcall(function()
            fakeBombCharacterConnection:Disconnect()
        end)
        fakeBombCharacterConnection = nil
    end

    fakeBombCharacterConnection = character.ChildAdded:Connect(function(child)
        if child.Name == "FakeBomb" then
            connectFakeBombTool(child)
        end
    end)

    task.defer(setupFakeBombScreenTouchHumanoid, character)
    task.defer(scanFakeBombToolsOnce)
end)

local function getFakeBombBackpack()
    return localPlayer:FindFirstChildOfClass("Backpack")
end

fakeBombBackpack = getFakeBombBackpack()
if fakeBombBackpack then
    fakeBombBackpackConnection = fakeBombBackpack.ChildAdded:Connect(function(child)
        if child.Name == "FakeBomb" then
            connectFakeBombTool(child)
        end
    end)
end

localPlayer.ChildAdded:Connect(function(child)
    if child:IsA("Backpack") then
        if fakeBombBackpackConnection then
            pcall(function()
                fakeBombBackpackConnection:Disconnect()
            end)
        end
        fakeBombBackpackConnection = child.ChildAdded:Connect(function(item)
            if item.Name == "FakeBomb" then
                connectFakeBombTool(item)
            end
        end)
        task.defer(scanFakeBombToolsOnce)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        fakeBombLastPointer = input.Position
    end
end)


local function walkDescendants(root, callback)
    for _, child in ipairs(root:GetChildren()) do
        callback(child)
        walkDescendants(child, callback)
    end
end

local function collectNamedDescendants(root, targetName)
    local result = {}
    walkDescendants(root, function(obj)
        if obj.Name == targetName then
            table.insert(result, obj)
        end
    end)
    return result
end

local function SetHitboxExpand(state)
    hitboxExpandEnabled = state == true

    if not hitboxExpandEnabled then
        for root, original in pairs(hitboxOriginals) do
            if root and root.Parent then
                pcall(function()
                    root.Size = original.Size
                    root.Transparency = original.Transparency
                    root.CanCollide = original.CanCollide
                end)
            end
        end
        hitboxOriginals = {}
    end
end

local function SetHitboxSize(value)
    hitboxSize = math.clamp(tonumber(value) or 4, 1, 20)
end

local function SetHitboxVisible(state)
    hitboxVisible = state == true
end

RunService.Heartbeat:Connect(function()
    if not hitboxExpandEnabled then
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if not hitboxOriginals[root] then
                    hitboxOriginals[root] = {
                        Size = root.Size,
                        Transparency = root.Transparency,
                        CanCollide = root.CanCollide
                    }
                end
                root.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                root.Transparency = hitboxVisible and 0.5 or 1
                root.CanCollide = false
            end
        end
    end
end)

local function restoreInvisibleCharacter(character)
    for part, original in pairs(invisibleTransparencyOriginals) do
        if part and part.Parent and part:IsDescendantOf(character) then
            pcall(function()
                part.Transparency = original
            end)
        end
    end
    invisibleTransparencyOriginals = {}
end

local function makeCharacterInvisible(character)
    if not character then
        return
    end

    invisibleTransparencyOriginals = {}
    walkDescendants(character, function(obj)
        if obj:IsA("BasePart") and obj.Transparency == 0 then
            invisibleTransparencyOriginals[obj] = obj.Transparency
            obj.Transparency = 0.5
        end
    end)
end

local function SetInvisible(state)
    invisibleEnabled = state == true

    if invisibleRenderConnection then
        invisibleRenderConnection:Disconnect()
        invisibleRenderConnection = nil
    end

    local character = localPlayer.Character
    if not invisibleEnabled then
        if character then
            restoreInvisibleCharacter(character)
        end
        if InvisiblePanel then
            InvisiblePanel.Visible = false
        end
        return
    end

    if character then
        makeCharacterInvisible(character)
    end

    if InvisiblePanel then
        InvisiblePanel.Visible = true
    end

    invisibleRenderConnection = RunService.Heartbeat:Connect(function()
        if not invisibleEnabled then
            return
        end

        local char = localPlayer.Character
        if not char then
            return
        end

        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if root and humanoid then
            local oldCF = root.CFrame
            local oldCameraOffset = humanoid.CameraOffset
            local invisCF = oldCF * CFrame.new(0, -200000, 0)

            pcall(function()
                root.CFrame = invisCF
                humanoid.CameraOffset = invisCF:ToObjectSpace(CFrame.new(oldCF.Position)).Position
            end)

            RunService.RenderStepped:Wait()

            if root.Parent then
                pcall(function()
                    root.CFrame = oldCF
                    humanoid.CameraOffset = oldCameraOffset
                end)
            end
        end
    end)
end

local function SetLowDetailsMode(state)
    lowDetailsEnabled = state == true

    if lowDetailsEnabled then
        if not lowDetailsOriginal then
            lowDetailsOriginal = {
                GlobalShadows = Lighting.GlobalShadows,
                ShadowSoftness = Lighting.ShadowSoftness,
                ShadowColor = Lighting.ShadowColor
            }
        end

        Lighting.GlobalShadows = false
        Lighting.ShadowSoftness = 0
        Lighting.ShadowColor = Color3.new(0, 0, 0)
    else
        if lowDetailsOriginal then
            Lighting.GlobalShadows = lowDetailsOriginal.GlobalShadows
            Lighting.ShadowSoftness = lowDetailsOriginal.ShadowSoftness
            Lighting.ShadowColor = lowDetailsOriginal.ShadowColor
            lowDetailsOriginal = nil
        end
    end
end

local function SetDisableFootstep(state)
    disableFootstepEnabled = state == true

    if footstepConnection then
        footstepConnection:Disconnect()
        footstepConnection = nil
    end

    if disableFootstepEnabled then
        footstepBackups = {}
        local existing = collectNamedDescendants(Workspace, "Footsteps")

        for _, obj in ipairs(existing) do
            local clone = nil
            pcall(function()
                if obj.Archivable then
                    clone = obj:Clone()
                end
            end)

            if clone then
                table.insert(footstepBackups, {
                    parent = obj.Parent,
                    clone = clone
                })
            end

            pcall(function()
                obj:Destroy()
            end)
        end

        footstepConnection = Workspace.DescendantAdded:Connect(function(obj)
            if disableFootstepEnabled and obj.Name == "Footsteps" then
                task.defer(function()
                    if not disableFootstepEnabled or not obj or not obj.Parent then
                        return
                    end

                    local hasParentBackup = false
                    for _, backup in ipairs(footstepBackups) do
                        if backup.parent == obj.Parent then
                            hasParentBackup = true
                            break
                        end
                    end

                    if not hasParentBackup then
                        local clone = nil
                        pcall(function()
                            if obj.Archivable then
                                clone = obj:Clone()
                            end
                        end)
                        if clone then
                            table.insert(footstepBackups, {
                                parent = obj.Parent,
                                clone = clone
                            })
                        end
                    end

                    pcall(function()
                        obj:Destroy()
                    end)
                end)
            end
        end)
    else
        local current = collectNamedDescendants(Workspace, "Footsteps")
        if #current == 0 then
            for _, backup in ipairs(footstepBackups) do
                if backup.parent and backup.parent.Parent and backup.clone then
                    pcall(function()
                        backup.clone.Parent = backup.parent
                    end)
                end
            end
        end
        footstepBackups = {}
    end
end

local optimizerCoinOriginals = {}
local optimizerCoinsEnabled = false
local optimizerCoinsConnection = nil

local function scanOptimizerCoins()
    local coins = {}
    walkDescendants(Workspace, function(obj)
        if obj.Name == "Coin_Server" and obj:IsA("BasePart") then
            table.insert(coins, obj)
        end
    end)
    return coins
end

local function optimizeCoin(obj)
    if not obj or not obj.Parent or not obj:IsA("BasePart") then
        return
    end

    if not optimizerCoinOriginals[obj] then
        optimizerCoinOriginals[obj] = {
            Material = obj.Material,
            Color = obj.Color,
            Emitters = {}
        }

        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("ParticleEmitter") then
                optimizerCoinOriginals[obj].Emitters[child] = child.Enabled
            end
        end
    end

    obj.Material = Enum.Material.Plastic
    obj.Color = Color3.fromRGB(255, 255, 0)

    for emitter, wasEnabled in pairs(optimizerCoinOriginals[obj].Emitters) do
        if emitter and emitter.Parent then
            emitter.Enabled = false
        end
    end
end

function ApplyOptimizerCoins(state)
    optimizerCoinsEnabled = state == true

    if optimizerCoinsConnection then
        optimizerCoinsConnection:Disconnect()
        optimizerCoinsConnection = nil
    end

    if optimizerCoinsEnabled then
        for _, obj in ipairs(scanOptimizerCoins()) do
            optimizeCoin(obj)
        end

        optimizerCoinsConnection = Workspace.DescendantAdded:Connect(function(obj)
            if optimizerCoinsEnabled and obj.Name == "Coin_Server" and obj:IsA("BasePart") then
                task.defer(function()
                    if optimizerCoinsEnabled and obj and obj.Parent then
                        optimizeCoin(obj)
                    end
                end)
            end
        end)
    else
        for obj, original in pairs(optimizerCoinOriginals) do
            if obj and obj.Parent then
                obj.Material = original.Material
                obj.Color = original.Color
                for emitter, wasEnabled in pairs(original.Emitters) do
                    if emitter and emitter.Parent then
                        emitter.Enabled = wasEnabled
                    end
                end
            end
        end
        optimizerCoinOriginals = {}
    end
end

local SELECTED_FLING_TIMEOUT = 2.5

local function StopSelectedFling()
    selectedFlingEnabled = false
    selectedFlingInProgress = false
    if selectedFlingThread then
        task.cancel(selectedFlingThread)
        selectedFlingThread = nil
    end
end

local function FlingSelectedPlayer(targetPlayer)
    selectedFlingInProgress = true

    local myChar = localPlayer.Character
    if not myChar then
        selectedFlingInProgress = false
        return
    end

    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local targetChar = targetPlayer and targetPlayer.Character
    if not (myHum and myRoot and targetChar) then
        selectedFlingInProgress = false
        return
    end

    local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
    local targetRoot = targetHum and targetHum.RootPart
    local targetHead = targetChar:FindFirstChild("Head")
    local accessory = targetChar:FindFirstChildOfClass("Accessory")
    local handle = accessory and accessory:FindFirstChild("Handle")
    local oldPos = myRoot.CFrame
    local originalCameraSubject = Camera.CameraSubject

    if targetHead or handle or targetHum then
        pcall(function()
            Camera.CameraSubject = targetHead or handle or targetHum
        end)
    end

    local function forcePosition(basePart, offset, angle)
        if not selectedFlingEnabled then
            return false
        end
        local targetCF = CFrame.new(basePart.Position) * offset * angle
        myRoot.CFrame = targetCF
        if myChar.PrimaryPart then
            myChar:SetPrimaryPartCFrame(targetCF)
        end
        myRoot.Velocity = Vector3.new(9e7, 9e8, 9e7)
        myRoot.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        return true
    end

    local function flingBasePart(basePart)
        local start = tick()
        local ang = 0
        while selectedFlingEnabled and basePart and basePart.Parent and targetHum and targetHum.Health > 0 and tick() - start <= SELECTED_FLING_TIMEOUT do
            ang = ang + 100
            for _, off in ipairs({
                CFrame.new(0, 1.5, 0),
                CFrame.new(0, -1.5, 0),
                CFrame.new(2.25, 1.5, -2.25),
                CFrame.new(-2.25, -1.5, 2.25)
            }) do
                if not forcePosition(basePart, off + targetHum.MoveDirection, CFrame.Angles(math.rad(ang), 0, 0)) then
                    return
                end
                task.wait()
            end
        end
    end

    local bv = Instance.new("BodyVelocity")
    bv.Name = "SelectedFlingVelocity"
    bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = myRoot
    myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    local targetPart = targetRoot or targetHead or handle
    if targetPart then
        flingBasePart(targetPart)
    end

    if bv.Parent then
        bv:Destroy()
    end
    myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

    pcall(function()
        Camera.CameraSubject = originalCameraSubject or myHum
    end)

    if selectedFlingEnabled and myRoot.Parent then
        local restoreCF = oldPos * CFrame.new(0, 0.5, 0)
        myRoot.CFrame = restoreCF
        if myChar.PrimaryPart then
            myChar:SetPrimaryPartCFrame(restoreCF)
        end
        myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
        for _, part in ipairs(myChar:GetChildren()) do
            if part:IsA("BasePart") then
                part.Velocity = Vector3.zero
                part.RotVelocity = Vector3.zero
            end
        end
    end

    selectedFlingInProgress = false
end

local function StartSelectedFling()
    local player = selectedFlingPlayerName and Players:FindFirstChild(selectedFlingPlayerName)
    if not player or player == localPlayer then
        selectedFlingEnabled = false
        return
    end

    StopSelectedFling()
    selectedFlingEnabled = true
    selectedFlingThread = task.spawn(function()
        while selectedFlingEnabled do
            local currentPlayer = selectedFlingPlayerName and Players:FindFirstChild(selectedFlingPlayerName)
            if not currentPlayer or currentPlayer == localPlayer then
                selectedFlingEnabled = false
                break
            end

            FlingSelectedPlayer(currentPlayer)
            if not selectedFlingEnabled then
                break
            end
            task.wait(0.12)
        end
        selectedFlingThread = nil
    end)
end

local function getFlingPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(names, player.Name)
        end
    end
    table.sort(names)
    return names
end

local SelectedFlingDropdown = nil

local function RefreshSelectedFlingDropdown()
    if not SelectedFlingDropdown then
        return
    end

    local options = getFlingPlayerNames()
    pcall(function()
        if SelectedFlingDropdown.SetValues then
            SelectedFlingDropdown:SetValues(options)
        elseif SelectedFlingDropdown.SetOptions then
            SelectedFlingDropdown:SetOptions(options)
        end
    end)
end

Players.PlayerAdded:Connect(function()
    task.defer(RefreshSelectedFlingDropdown)
end)

Players.PlayerRemoving:Connect(function(player)
    if player and selectedFlingPlayerName == player.Name then
        StopSelectedFling()
    end
    task.defer(RefreshSelectedFlingDropdown)
end)

localPlayer.CharacterAdded:Connect(function(character)
    if invisibleEnabled then
        if invisibleRenderConnection then
            invisibleRenderConnection:Disconnect()
            invisibleRenderConnection = nil
        end
        task.wait(0.2)
        if invisibleEnabled and character.Parent then
            makeCharacterInvisible(character)
            SetInvisible(true)
        end
    else
        if InvisiblePanel then
            InvisiblePanel.Visible = false
        end
    end

    if selectedFlingEnabled then
        StopSelectedFling()
    end
end)

function BuildUI()
    local W = Chloex:Window({
        Title = "BOLONG-HUB",
        Image = "84034353458936",
        Footer = "Murder Mystery 2",
        Author = "discord.gg/pWpgqVGxNK",
        Color = ACCENT_COLOR,
        Version = 2,
        Search = true,
        Folder = "BolongHubMM2"
    })

    PlayOpenSound()

    local InfoTab = W:AddTab({Name = "Info", Icon = "info"})
    local MainTab = W:AddTab({Name = "Main", Icon = "house"})
    local AutoFarmTab = W:AddTab({Name = "Auto Farm", Icon = "bot"})
    local CombatTab = W:AddTab({Name = "Combat", Icon = "crosshair"})
    local MurdererTab = W:AddTab({Name = "Murderer", Icon = "skull"})
    local VisualsTab = W:AddTab({Name = "Visuals", Icon = "eye"})
    local MiscTab = W:AddTab({Name = "Misc", Icon = "settings"})
    local SettingsTab = W:AddTab({Name = "Settings", Icon = "settings"})

    local TabSoundNames = {
        ["Info"] = true,
        ["Main"] = true,
        ["Auto Farm"] = true,
        ["Combat"] = true,
        ["Murderer"] = true,
        ["Visuals"] = true,
        ["Misc"] = true,
        ["Settings"] = true
    }

    local function getTabText(guiObject)
        local current = guiObject
        local depth = 0
        while current and depth < 8 do
            if current:IsA("TextButton") or current:IsA("TextLabel") then
                local textValue = tostring(current.Text or "")
                if TabSoundNames[textValue] then
                    return textValue
                end
            end
            current = current.Parent
            depth = depth + 1
        end
        return nil
    end

    local function playTabSoundAt(position)
        local ok, objects = pcall(function()
            return GuiService:GetGuiObjectsAtPosition(position.X, position.Y)
        end)
        if not ok or type(objects) ~= "table" then
            return
        end
        local index = 1
        while index <= #objects do
            local tabText = getTabText(objects[index])
            if tabText then
                PlaySoundAsset(124199202280292, 1)
                return
            end
            index = index + 1
        end
    end

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            playTabSoundAt(input.Position)
        end
    end)

    local InfoSec = InfoTab:AddSection("Info", nil)
    InfoSec:AddParagraph({
        Title = "Yo rill add your discord profile or something you want here",
        Content = "discord.gg/pWpgqVGxNK"
    })

    local MovementSec = MainTab:AddSection("Movement & Physics", nil)
    MovementSec:AddSlider({
        Title = "Speed",
        Min = 16, Max = 200, Default = 16, Increment = 1,
        Callback = function(v)
            currentSpeed = tonumber(v) or 16
            ApplyMovement()
        end
    })
    MovementSec:AddSlider({
        Title = "JumpPower",
        Min = 50, Max = 300, Default = 50, Increment = 1,
        Callback = function(v)
            currentJump = tonumber(v) or 50
            ApplyMovement()
        end
    })
    MovementSec:AddSlider({
        Title = "Gravity",
        Min = 0, Max = 300, Default = 196.2, Increment = 1,
        Callback = function(v)
            currentGravity = tonumber(v) or 196.2
        end
    })
    MovementSec:AddSlider({
        Title = "FOV",
        Min = 70, Max = 120, Default = 70, Increment = 1,
        Callback = function(v)
            Camera.FieldOfView = tonumber(v) or 70
        end
    })

    local UtilitySec = MainTab:AddSection("Utilities", nil)
    UtilitySec:AddToggle({
        Title = "Inf Jump",
        Default = false,
        Callback = function(v) infJumpEnabled = v == true end
    })
    UtilitySec:AddToggle({
        Title = "Noclip",
        Default = false,
        Callback = function(v)
            noclipEnabled = v == true
            NoclipEnabled = noclipEnabled
            if not noclipEnabled then SetNoclip(false) end
        end
    })

    local HitboxSec = MainTab:AddSection("Hitbox Expander", nil)
    HitboxSec:AddToggle({
        Title = "Enable Hitbox Expander",
        Default = false,
        Callback = function(v)
            SetHitboxExpand(v == true)
        end
    })
    HitboxSec:AddSlider({
        Title = "Size",
        Min = 1, Max = 20, Default = 4, Increment = 1,
        Callback = function(v)
            SetHitboxSize(v)
        end
    })
    HitboxSec:AddToggle({
        Title = "Visible Hitbox",
        Default = false,
        Callback = function(v)
            SetHitboxVisible(v == true)
        end
    })

    local CoinReachSec = AutoFarmTab:AddSection("COINS REACH", nil)
    CoinReachSec:AddToggle({
        Title = "Coin Reach",
        Default = false,
        Callback = function(v)
            ApplyCoinReach(v == true)
        end
    })
    CoinReachSec:AddSlider({
        Title = "Reach Range",
        Min = 4,
        Max = 23,
        Default = 6,
        Increment = 1,
        Callback = function(v)
            coinReachRange = math.clamp(tonumber(v) or 6, 4, 23)
            if coinReachEnabled then
                for obj, originalSize in pairs(coinReachOriginals) do
                    if obj and obj.Parent then
                        obj.Size = originalSize * coinReachRange
                    end
                end
            end
        end
    })

    local AutoFarmSec = AutoFarmTab:AddSection("AUTO FARM COINS", nil)
    AutoFarmSec:AddToggle({
        Title = "Auto Farm Coins",
        Default = false,
        Callback = function(v)
            if v == true then
                startAutoFarm()
            else
                stopAutoFarm()
            end
        end
    })
    AutoFarmSec:AddButton({
        Title = "FORCE STOP FARM (if dead)",
        Callback = function()
            stopAutoFarm()
        end
    })
    AutoFarmSec:AddToggle({
        Title = "Anti AFK",
        Default = false,
        Callback = function(v)
            antiAFKEnabled = v == true
        end
    })


    local AutoShootSec = CombatTab:AddSection("Auto Shoot", nil)
    AutoShootSec:AddToggle({
        Title = "Auto Shoot",
        Default = false,
        Callback = function(v)
            autoShootActive = v == true
            AutoShootEnabled = autoShootActive
            MobilePanelEnabled = autoShootActive
            MainPanel.Visible = autoShootActive
        end
    })
    AutoShootSec:AddSlider({
        Title = "Panel Size",
        Min = 5, Max = 16, Default = 10, Increment = 1,
        Callback = function(v)
            UpdatePanelScale(v)
        end
    })

    local AimlockSec = CombatTab:AddSection("Aimlock", nil)
    AimlockSec:AddToggle({
        Title = "Aimlock",
        Default = false,
        Callback = function(v)
            aimbotActive = v == true
            if not aimbotActive then
                aimlockEngaged = false
                aimbotFOVVisible = false
                clearAimlockTarget()
            end
            UpdateAimbotVisuals()
            AimbotPanel.Visible = v == true
        end
    })
    AimlockSec:AddSlider({
        Title = "Aimlock FOV",
        Min = 2, Max = 20, Default = 10, Increment = 1,
        Callback = function(v)
            aimbotFOV = math.clamp(tonumber(v) or 10, 2, 20)
            UpdateAimbotVisuals()
        end
    })
    AimlockSec:AddSlider({
        Title = "Size",
        Min = 6, Max = 16, Default = 8, Increment = 1,
        Callback = function(v)
            UpdateAimbotPanelScale(v)
        end
    })

    local AutoPickupSec = CombatTab:AddSection("Auto Pick Up Gun", nil)
    AutoPickupSec:AddToggle({
        Title = "Auto Pick Up Gun",
        Default = false,
        Callback = function(v)
            autoPickupGunActive = v == true
            PickupPanel.Visible = v == true
        end
    })
    AutoPickupSec:AddSlider({
        Title = "Size",
        Min = 5, Max = 20, Default = 10, Increment = 1,
        Callback = function(v)
            UpdatePickupPanelScale(v)
        end
    })

    local FakeBombSec = CombatTab:AddSection("Fake Bomb Jump", nil)
    FakeBombSec:AddToggle({
        Title = "Fake Bomb Jump",
        Default = false,
        Callback = function(v)
            fakeBombJumpEnabled = v == true
            if fakeBombJumpEnabled then
                ensureFakeBombJumpPanel()
                FakeBombJumpPanel.Visible = true
                scanFakeBombToolsOnce()
            else
                if FakeBombJumpPanel then
                    FakeBombJumpPanel.Visible = false
                end
                fakeBombCooldownUntil = 0
                fakeBombJumpReady = true
                fakeBombScreenTouchSuppress = false
                if FakeBombJumpLabel then
                    FakeBombJumpLabel.Text = "Ready"
                end
            end
        end
    })
    FakeBombSec:AddDropdown({
        Title = "Variant",
        Values = {"Auto", "Manual"},
        Options = {"Auto", "Manual"},
        Default = "Auto",
        Callback = function(v)
            if type(v) == "table" then
                v = v[1]
            end
            if v ~= "Manual" then
                v = "Auto"
            end
            fakeBombVariant = v
            if FakeBombJumpPanel then
                FakeBombJumpPanel.Visible = fakeBombJumpEnabled
            end
        end
    })
    FakeBombSec:AddSlider({
        Title = "Fake Bomb Jump Panel Size",
        Min = 6, Max = 20, Default = 10, Increment = 1,
        Callback = function(v)
            updateFakeBombJumpPanelScale(v)
        end
    })

    local MurdererKillSec = MurdererTab:AddSection("Murderer Kill section", nil)
    MurdererKillSec:AddButton({
        Title = "Kill All",
        Callback = function() killAll() end
    })
    MurdererKillSec:AddButton({
        Title = "Kill Sheriff",
        Callback = function() killSheriff() end
    })
    MurdererKillSec:AddButton({
        Title = "Kill Hero",
        Callback = function() end
    })
    MurdererKillSec:AddButton({
        Title = "Kill Innocent",
        Callback = function() end
    })

    local ThrowingKnifeSec = MurdererTab:AddSection("Auto Throwing Knife", nil)
    ThrowingKnifeSec:AddToggle({
        Title = "Auto Throwing Knife",
        Default = false,
        Callback = function(v)
            if v == true then
                autoThrowKnifeEnabled = true
                enableAutoThrowKnife()
            else
                disableAutoThrowKnife()
            end
        end
    })

    local FootstepSec = MurdererTab:AddSection("Disable Footstep", nil)
    FootstepSec:AddToggle({
        Title = "Disable Footstep",
        Default = false,
        Callback = function(v)
            SetDisableFootstep(v == true)
        end
    })

    local RolesEspSec = VisualsTab:AddSection("Roles ESP", nil)
    RolesEspSec:AddToggle({
        Title = "ESP Roles",
        Default = false,
        Callback = function(v)
            EspEnabled = v == true
            if not EspEnabled then
                for player in pairs(roleBoxes) do
                    clearRoleBoxes(player)
                end
            end
        end
    })

    local DroppedGunCharmSec = VisualsTab:AddSection("Gun Dropped Charm", nil)
    DroppedGunCharmSec:AddToggle({
        Title = "ESP Dropped Gun",
        Default = false,
        Callback = function(v)
            droppedGunEspEnabled = v == true
            updateDroppedGunESP()
        end
    })

    local DroppedGunNameSec = VisualsTab:AddSection("Gun Dropped Name", nil)
    DroppedGunNameSec:AddToggle({
        Title = "Show Dropped gun esp name",
        Default = false,
        Callback = function(v)
            showDroppedGunEspNameEnabled = v == true
            if not showDroppedGunEspNameEnabled then
                clearDroppedGunESPName()
            end
        end
    })

    local RoundTimerSec = VisualsTab:AddSection("Show rounds timer", nil)
    RoundTimerSec:AddToggle({
        Title = "Show rounds timer",
        Default = false,
        Callback = function(v)
            RoundTimerState.enabled = v == true
            if RoundTimerState.enabled then
                ensureRoundTimerGui()
                RoundTimerState.gui.Enabled = true
                if RoundTimerState.phase ~= "RUNNING" then
                    RoundTimerState.phase = "MIDGAME"
                    RoundTimerState.duration = 0
                    RoundTimerState.startedAt = 0
                    RoundTimerState.endAt = 0
                    RoundTimerState.label.Text = "0:00"
                end
                RoundTimerState.panel.Visible = true
                if RoundTimerState.phase == "RUNNING" then
                    RoundTimerState.label.Text = formatRoundTime(math.max(0, RoundTimerState.endAt - getServerNow()))
                elseif RoundTimerState.phase == "MIDGAME" then
                    RoundTimerState.label.Text = "0:00"
                end
                RoundTimerState.statsLabel.Text = string.format("FPS %d    Ping %dms", RoundTimerState.fps, getCurrentPing())
            else
                setRoundTimerGuiVisible(false)
            end
        end
    })

    local MiscInvisibleSec = MiscTab:AddSection("Invisible", nil)
    MiscInvisibleSec:AddToggle({
        Title = "Invisible",
        Default = false,
        Callback = function(v)
            SetInvisible(v == true)
        end
    })

    local MiscLowDetailsSec = MiscTab:AddSection("Low Details mode", nil)
    MiscLowDetailsSec:AddToggle({
        Title = "Low Details mode",
        Default = false,
        Callback = function(v)
            SetLowDetailsMode(v == true)
        end
    })

    local MiscOptimizerSec = MiscTab:AddSection("Optimizer Coins", nil)
    MiscOptimizerSec:AddToggle({
        Title = "Optimizer Coins",
        Default = false,
        Callback = function(v)
            ApplyOptimizerCoins(v == true)
        end
    })

    local MiscFlingSec = MiscTab:AddSection("Anti Fling / Fling", nil)
    MiscFlingSec:AddToggle({
        Title = "Anti Fling",
        Default = false,
        Callback = function(v) SetAntiFling(v == true) end
    })
    MiscFlingSec:AddToggle({
        Title = "Touch Fling",
        Default = false,
        Callback = function(v) SetTouchFling(v == true) end
    })

    local flingOptions = getFlingPlayerNames()
    if #flingOptions > 0 then
        selectedFlingPlayerName = flingOptions[1]
    end

    SelectedFlingDropdown = MiscFlingSec:AddDropdown({
        Title = "Select Player",
        Values = flingOptions,
        Options = flingOptions,
        Default = selectedFlingPlayerName,
        Callback = function(v)
            if type(v) == "table" then
                v = v[1]
            end
            selectedFlingPlayerName = v
            if selectedFlingEnabled then
                StartSelectedFling()
            end
        end
    })

    MiscFlingSec:AddToggle({
        Title = "Fling Selected Player",
        Default = false,
        Callback = function(v)
            if v == true then
                StartSelectedFling()
            else
                StopSelectedFling()
            end
        end
    })

    MiscFlingSec:AddButton({
        Title = "Refresh Player List",
        Callback = function()
            RefreshSelectedFlingDropdown()
        end
    })

    local MiscEmoteSec = MiscTab:AddSection("Emotes", nil)
    for _, emoteName in ipairs({"sit", "zombie", "ninja", "zen", "floss", "dab"}) do
        MiscEmoteSec:AddButton({
            Title = "Emote: " .. emoteName:gsub("^%l", string.upper),
            Callback = function() PlayMiscEmote(emoteName) end
        })
    end

    local SettingsSec = SettingsTab:AddSection("Settings", nil)
    SettingsSec:AddButton({
        Title = "Reset Camera",
        Callback = function()
            local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then Camera.CameraSubject = hum end
            Camera.FieldOfView = 70
        end
    })
    SettingsSec:AddButton({
        Title = "Cleanup Visuals",
        Callback = function()
            cleanupVisuals()
            EspEnabled = false
            droppedGunEspEnabled = false
            showDroppedGunEspNameEnabled = false
            clearDroppedGunESP()
            resetRoundRoles()
            RoundRoleEndAt = 0
            RoundTimerState.phase = "WAITING"
            RoundTimerState.endAt = 0
            RoundTimerState.enabled = false
            setRoundTimerGuiVisible(false)

        end
    })

end

BuildUI()
print("BOLONG-HUB MM2 - DISCORD.GG/PWPGQVGXNK LOADED!")

