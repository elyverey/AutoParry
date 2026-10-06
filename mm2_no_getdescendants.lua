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
if not localPlayer then
    repeat
        task.wait()
        localPlayer = Players.LocalPlayer
    until localPlayer
end
PlayerGui = localPlayer:WaitForChild("PlayerGui")

function refreshLocalPlayerReferences()
    local currentPlayer = Players.LocalPlayer
    if currentPlayer and currentPlayer ~= localPlayer then
        localPlayer = currentPlayer
    end

    if localPlayer then
        local currentPlayerGui = localPlayer:FindFirstChild("PlayerGui")
        if currentPlayerGui then
            PlayerGui = currentPlayerGui
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    task.defer(function()
        refreshLocalPlayerReferences()
    end)
end)

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
    local libraryUrl = "https://raw.githubusercontent.com/RillBoys/bolong.catui/main/b0lngUi.lua"
    local lastError = nil

    local function fetchLibrarySource()
        local ok, body = pcall(function()
            if type(game.HttpGetAsync) == "function" then
                return game:HttpGetAsync(libraryUrl)
            end
            return game:HttpGet(libraryUrl)
        end)
        if ok and type(body) == "string" and #body > 0 then
            return body
        end

        local requestFunc = nil
        if type(request) == "function" then
            requestFunc = request
        elseif type(http_request) == "function" then
            requestFunc = http_request
        end

        if requestFunc then
            local reqOk, response = pcall(function()
                return requestFunc({
                    Url = libraryUrl,
                    Method = "GET",
                })
            end)
            if reqOk and response and tonumber(response.StatusCode or 0) >= 200 and tonumber(response.StatusCode or 0) < 300 then
                local responseBody = response.Body or response.body
                if type(responseBody) == "string" and #responseBody > 0 then
                    return responseBody
                end
            end
        end

        return nil, body
    end

    local attempts = 1
    while attempts <= 3 and not Chloex do
        local source, fetchError = fetchLibrarySource()
        if source then
            local compiler = loadstring or load
            if type(compiler) ~= "function" then
                lastError = "No Lua loader is available in this environment"
            else
                local chunkOk, chunk = pcall(compiler, source)
                if chunkOk and type(chunk) == "function" then
                    local runOk, result = pcall(chunk)
                    if runOk and result then
                        Chloex = result
                        break
                    end
                    lastError = result
                else
                    lastError = chunk
                end
            end
        else
            lastError = fetchError
        end

        if not Chloex and attempts < 3 then
            task.wait(0.75)
        end
        attempts = attempts + 1
    end

    if not Chloex then
        error("Unable to load b0lngUi.lua after 3 attempts. " .. tostring(lastError or "unknown error"))
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
hitboxTransparencyLevel = 5
hitboxOriginals = {}
hitboxVisuals = {}

autoShootVariant = "Auto"

invisibleEnabled = false
invisibleFeatureEnabled = false
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
removeInvisibleBarrierEnabled = false
removeInvisibleBarrierOriginals = {}
removeInvisibleBarrierConnection = nil

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
    Hero = Color3.fromRGB(202, 182, 0),
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
autoFarmSpeed = 7
autoFarmCollectDelay = 1
autoFarmVariant = "Normal"
coinReachEnabled = false
coinReachRange = 4
coinReachOriginals = {}
coinReachConnection = nil
coinReachRemovingConnection = nil
coinReachPending = {}
coinReachGeneration = 0
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
fakeBombManualInputConnection = nil
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
aimbotFOV = 30
AimbotPanelScale = 8
AIMLOCK_FOV_RADIUS = 30
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

    -- Fallback role detection: once a round role has been detected, every
    -- remaining player without a known special role is an Innocent.
    if foundAnyRole then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Parent == Players then
                if GetPlayerRoleMM2(player) == "Lobby" then
                    roleCache[player.Name] = "Innocent"
                    roleCacheByUserId[tonumber(player.UserId)] = "Innocent"
                end
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

local roleVariantObjects = {}

function cleanupVisuals()
    for _, h in pairs(espHighlights) do
        if h then pcall(function() h:Destroy() end) end
    end
    espHighlights = {}

    for _, box in pairs(roleBoxes) do
        if box then pcall(function() box:Destroy() end) end
    end
    roleBoxes = {}

    for player, obj in pairs(roleVariantObjects or {}) do
        if obj then
            if obj.highlight then pcall(function() obj.highlight:Destroy() end) end
            if obj.nameBill then pcall(function() obj.nameBill:Destroy() end) end
            if obj.tracer then pcall(function() obj.tracer:Destroy() end) end
            if obj.skel then
                for _, line in ipairs(obj.skel) do
                    pcall(function() line:Destroy() end)
                end
            end
        end
        roleVariantObjects[player] = nil
    end

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


local roleEspVariant = "Box"
local roleVariantGui = nil

local function ensureRoleVariantGui()
    if roleVariantGui and roleVariantGui.Parent then
        return roleVariantGui
    end
    roleVariantGui = Instance.new("ScreenGui")
    roleVariantGui.Name = "BolongRoleVariantESP"
    roleVariantGui.ResetOnSpawn = false
    roleVariantGui.IgnoreGuiInset = true
    roleVariantGui.DisplayOrder = 997
    roleVariantGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    roleVariantGui.Parent = PlayerGui
    return roleVariantGui
end

local function makeRoleVariantLine(name)
    local gui = ensureRoleVariantGui()
    local line = Instance.new("Frame")
    line.Name = name or "RoleESPLine"
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BackgroundColor3 = RoleColors.Innocent
    line.BorderSizePixel = 0
    line.Visible = false
    line.ZIndex = 20
    line.Parent = gui
    return line
end

local function drawRoleVariantLine(line, p1, p2, color, thickness)
    if not line or not line.Parent or not p1 or not p2 then
        if line then line.Visible = false end
        return
    end
    local dx = p2.X - p1.X
    local dy = p2.Y - p1.Y
    local len = math.sqrt(dx * dx + dy * dy)
    if len < 1 then
        line.Visible = false
        return
    end
    local mid = Vector2.new((p1.X + p2.X) / 2, (p1.Y + p2.Y) / 2)
    line.Size = UDim2.fromOffset(len, thickness or 1)
    line.Position = UDim2.fromOffset(mid.X, mid.Y)
    line.Rotation = math.deg(math.atan2(dy, dx))
    line.BackgroundColor3 = color
    line.Visible = true
end

local function getRoleScreenPoint(position)
    local camera = Workspace.CurrentCamera
    if not camera or not position then
        return nil, false
    end
    local point, onScreen = camera:WorldToViewportPoint(position)
    if point.Z <= 0 then
        return nil, false
    end
    return Vector2.new(point.X, point.Y), onScreen
end

local function getRoleSkeletonPairs(character)
    local function findPart(...)
        local names = {...}
        for _, name in ipairs(names) do
            local part = character:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                return part
            end
        end
        return nil
    end

    local head = findPart("Head")
    local torso = findPart("UpperTorso", "Torso", "LowerTorso")
    local leftArm = findPart("LeftUpperArm", "Left Arm", "LeftLowerArm", "LeftHand")
    local rightArm = findPart("RightUpperArm", "Right Arm", "RightLowerArm", "RightHand")
    local leftLeg = findPart("LeftUpperLeg", "Left Leg", "LeftLowerLeg", "LeftFoot")
    local rightLeg = findPart("RightUpperLeg", "Right Leg", "RightLowerLeg", "RightFoot")

    local pairsList = {}
    if head and torso then pairsList[#pairsList + 1] = {head, torso} end
    if torso and leftArm then pairsList[#pairsList + 1] = {torso, leftArm} end
    if torso and rightArm then pairsList[#pairsList + 1] = {torso, rightArm} end
    if torso and leftLeg then pairsList[#pairsList + 1] = {torso, leftLeg} end
    if torso and rightLeg then pairsList[#pairsList + 1] = {torso, rightLeg} end
    return pairsList
end

local function clearRoleVariant(player)
    local obj = roleVariantObjects[player]
    if not obj then
        return
    end

    if obj.highlight then
        pcall(function() obj.highlight:Destroy() end)
    end
    if obj.nameBill then
        pcall(function() obj.nameBill:Destroy() end)
    end
    if obj.tracer then
        pcall(function() obj.tracer:Destroy() end)
    end
    if obj.skel then
        for _, line in ipairs(obj.skel) do
            pcall(function() line:Destroy() end)
        end
    end
    roleVariantObjects[player] = nil
end

function clearRoleBoxes(player)
    local list = roleBoxes[player]
    if list then
        for _, box in ipairs(list) do
            pcall(function() box:Destroy() end)
        end
        roleBoxes[player] = nil
    end
    clearRoleVariant(player)
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

local function buildRoleVariant(player, character, roleColor)
    clearRoleVariant(player)
    if roleEspVariant == "Box" or not character then
        return
    end

    local obj = { character = character }

    if roleEspVariant == "Highlight" or roleEspVariant == "Chams" or roleEspVariant == "Outline" then
        local hl = Instance.new("Highlight")
        hl.Name = "BolongRole" .. roleEspVariant
        hl.Adornee = character
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillColor = roleColor
        hl.OutlineColor = roleColor

        if roleEspVariant == "Chams" then
            hl.FillTransparency = 0.64
            hl.OutlineTransparency = 1
        elseif roleEspVariant == "Outline" then
            hl.FillTransparency = 1
            hl.OutlineTransparency = 0.64
        else
            hl.FillTransparency = 0.64
            hl.OutlineTransparency = 0.64
        end

        hl.Enabled = false
        hl.Parent = character
        obj.highlight = hl
    elseif roleEspVariant == "Names" then
        local bill = Instance.new("BillboardGui")
        bill.Name = "BolongRoleName"
        bill.Adornee = character:FindFirstChild("Head")
            or character:FindFirstChild("HumanoidRootPart")
            or character:FindFirstChild("UpperTorso")
            or character
        bill.Size = UDim2.fromOffset(180, 22)
        bill.StudsOffset = Vector3.new(0, 2.8, 0)
        bill.AlwaysOnTop = true
        bill.LightInfluence = 0
        bill.Enabled = false
        bill.Parent = character

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.fromScale(1, 1)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextStrokeTransparency = 0.4
        label.Text = player.Name
        label.TextColor3 = roleColor
        label.Parent = bill

        obj.nameBill = bill
        obj.nameLabel = label
    elseif roleEspVariant == "Tracer" then
        obj.tracer = makeRoleVariantLine("BolongRoleTracer")
    elseif roleEspVariant == "Skeleton" then
        obj.skel = {}
        for i = 1, 5 do
            obj.skel[i] = makeRoleVariantLine("BolongRoleSkeleton")
        end
    end

    roleVariantObjects[player] = obj
end

function buildRoleBoxes(player)
    clearRoleBoxes(player)

    local character = player.Character
    if not character then return end

    local role = GetPlayerRoleMM2(player)
    local roleColor = getRoleColor(role)
    bindRoleCharacterWatcher(player, character)

    if roleEspVariant ~= "Box" then
        buildRoleVariant(player, character, roleColor)
        return
    end

    local boxes = {}
    for _, part in ipairs(getRoleParts(character)) do
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "BolongRolePartBox"
        box.Adornee = part
        box.Size = part.Size
        box.Color3 = roleColor
        box.Transparency = 0.64
        box.AlwaysOnTop = true
        box.ZIndex = 1
        box.Visible = roleRoundActive and (role ~= "Lobby")
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
                    if box and box.Parent then
                        box.Visible = false
                    end
                end
            end
        end
        for _, obj in pairs(roleVariantObjects) do
            if obj.highlight then obj.highlight.Enabled = false end
            if obj.nameBill then obj.nameBill.Enabled = false end
            if obj.tracer then obj.tracer.Visible = false end
            if obj.skel then
                for _, line in ipairs(obj.skel) do line.Visible = false end
            end
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            local role = GetPlayerRoleMM2(player)
            local hasActiveRole = roleRoundActive and (
                role == "Murderer"
                or role == "Sheriff"
                or role == "Hero"
                or role == "Innocent"
            )
            local color = getRoleColor(role)

            if roleEspVariant == "Box" then
                clearRoleVariant(player)
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

                if boxes then
                    for _, box in ipairs(boxes) do
                        if box and box.Parent then
                            if box.Color3 ~= color then
                                box.Color3 = color
                            end
                            box.Visible = character ~= nil and hasActiveRole
                        end
                    end
                end
            else
                local boxes = roleBoxes[player]
                if boxes then
                    for _, box in ipairs(boxes) do
                        pcall(function() box:Destroy() end)
                    end
                    roleBoxes[player] = nil
                end

                local obj = roleVariantObjects[player]
                if (not obj) or obj.character ~= character or (
                    obj.highlight and not obj.highlight.Parent
                ) then
                    if character then
                        buildRoleVariant(player, character, color)
                        obj = roleVariantObjects[player]
                    end
                end

                local visible = character ~= nil and hasActiveRole
                if obj then
                    if obj.highlight then
                        obj.highlight.FillColor = color
                        obj.highlight.OutlineColor = color
                        obj.highlight.Enabled = visible
                    end
                    if obj.nameBill and obj.nameLabel then
                        obj.nameLabel.Text = player.Name
                        obj.nameLabel.TextColor3 = color
                        obj.nameBill.Enabled = visible
                    end

                    local root = getRoot(player)
                    local rootScreen, rootOnScreen = getRoleScreenPoint(root and root.Position)
                    if obj.tracer then
                        if visible and rootScreen and rootOnScreen then
                            local vp = Camera.ViewportSize
                            drawRoleVariantLine(
                                obj.tracer,
                                Vector2.new(vp.X / 2, vp.Y),
                                rootScreen,
                                color,
                                1
                            )
                        else
                            obj.tracer.Visible = false
                        end
                    end

                    if obj.skel then
                        if visible then
                            local pairsList = getRoleSkeletonPairs(character)
                            for i, line in ipairs(obj.skel) do
                                local pair = pairsList[i]
                                if pair then
                                    local p1, on1 = getRoleScreenPoint(pair[1].Position)
                                    local p2, on2 = getRoleScreenPoint(pair[2].Position)
                                    if p1 and p2 and on1 and on2 then
                                        drawRoleVariantLine(line, p1, p2, color, 1)
                                    else
                                        line.Visible = false
                                    end
                                else
                                    line.Visible = false
                                end
                            end
                        else
                            for _, line in ipairs(obj.skel) do
                                line.Visible = false
                            end
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
    for player in pairs(roleVariantObjects) do
        if not player.Parent then
            clearRoleVariant(player)
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

local function applyCoinReachObject(obj)
    if not coinReachEnabled or not obj or not obj.Parent then
        return
    end
    if obj.Name ~= "Coin_Server" or not obj:IsA("BasePart") then
        return
    end

    if not coinReachOriginals[obj] then
        coinReachOriginals[obj] = obj.Size
    end

    local originalSize = coinReachOriginals[obj]
    if originalSize then
        pcall(function()
            obj.Size = originalSize * coinReachRange
        end)
    end
end

local function queueCoinReachObject(obj, generation)
    if not coinReachEnabled or not obj or obj.Name ~= "Coin_Server" or not obj:IsA("BasePart") then
        return
    end

    applyCoinReachObject(obj)

    if coinReachPending[obj] then
        return
    end

    coinReachPending[obj] = true
    task.defer(function()
        coinReachPending[obj] = nil
        if not coinReachEnabled or generation ~= coinReachGeneration or not obj.Parent then
            return
        end

        applyCoinReachObject(obj)
        task.delay(0.01, function()
            if coinReachEnabled and generation == coinReachGeneration and obj.Parent then
                applyCoinReachObject(obj)
            end
        end)
        task.delay(0.05, function()
            if coinReachEnabled and generation == coinReachGeneration and obj.Parent then
                applyCoinReachObject(obj)
            end
        end)
    end)
end

local function ApplyCoinReach(state)
    coinReachEnabled = state == true
    coinReachGeneration = coinReachGeneration + 1
    local generation = coinReachGeneration
    coinReachPending = {}

    if coinReachConnection then
        coinReachConnection:Disconnect()
        coinReachConnection = nil
    end
    if coinReachRemovingConnection then
        coinReachRemovingConnection:Disconnect()
        coinReachRemovingConnection = nil
    end

    if coinReachEnabled then
        coinReachOriginals = {}

        coinReachConnection = Workspace.DescendantAdded:Connect(function(obj)
            if coinReachEnabled and generation == coinReachGeneration then
                queueCoinReachObject(obj, generation)
            end
        end)

        coinReachRemovingConnection = Workspace.DescendantRemoving:Connect(function(obj)
            coinReachOriginals[obj] = nil
            coinReachPending[obj] = nil
        end)

        for _, obj in ipairs(scanCoinReachObjects()) do
            queueCoinReachObject(obj, generation)
        end
    else
        for obj, originalSize in pairs(coinReachOriginals) do
            if obj and obj.Parent and originalSize then
                pcall(function()
                    obj.Size = originalSize
                end)
            end
        end
        coinReachOriginals = {}
        coinReachPending = {}
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
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if not char or not humanoid or humanoid.Health <= 0 or not hrp then
            return nil
        end

        local coinContainer = map:FindFirstChild("CoinContainer")
        if not coinContainer then
            return nil
        end

        for _, coin in ipairs(coinContainer:GetChildren()) do
            local visual = coin:FindFirstChild("CoinVisual")
            if visual and not visual:GetAttribute("Collected") and coin:IsA("BasePart") then
                local d = (hrp.Position - coin.Position).Magnitude
                if d < dist then
                    closest = coin
                    dist = d
                end
            end
        end

        return closest
    end

    local function waitForCharacter()
        while autoFarmCoinsRunning do
            local char = localPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if char and humanoid and hrp and humanoid.Health > 0 then
                return char, humanoid, hrp
            end

            task.wait(0.25)
        end
        return nil
    end

    local function tp(target)
        local char, humanoid, hrp = waitForCharacter()
        if not char or not humanoid or not hrp or not target or not target.Parent then
            return false
        end

        humanoid:ChangeState(Enum.HumanoidStateType.Physics)

        local destinationCFrame
        if autoFarmVariant == "Lay" then
            -- Move slightly below the coin and face upward (upside-down).
            destinationCFrame =
                CFrame.new(target.Position + Vector3.new(0, -3, 0))
                * CFrame.Angles(math.rad(180), 0, 0)
        else
            destinationCFrame = target.CFrame
        end

        local distance = (hrp.Position - destinationCFrame.Position).Magnitude
        local speed = math.clamp(tonumber(autoFarmSpeed) or 7, 7, 20)
        local duration = math.max(0.03, distance / speed)

        local tween = TweenService:Create(
            hrp,
            TweenInfo.new(duration, Enum.EasingStyle.Linear),
            {CFrame = destinationCFrame}
        )
        tween:Play()

        while tween.PlaybackState == Enum.PlaybackState.Playing and autoFarmCoinsRunning do
            if humanoid.Health <= 0 or not hrp.Parent or not target.Parent then
                tween:Cancel()
                return false
            end
            task.wait()
        end

        if autoFarmVariant == "Lay" and autoFarmCoinsRunning and hrp.Parent and target.Parent then
            pcall(function()
                hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, -3, 0))
                    * CFrame.Angles(math.rad(180), 0, 0)
            end)
        end

        return autoFarmCoinsRunning and target.Parent ~= nil
    end

    while autoFarmCoinsRunning do
        local char = localPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")

        if not char or not humanoid or humanoid.Health <= 0 then
            waitForCharacter()
        else
            local target = getNearest()

            if target then
                local reached = tp(target)

                if reached then
                    local visual = target:FindFirstChild("CoinVisual")

                    while autoFarmCoinsRunning and target.Parent and visual and not visual:GetAttribute("Collected") do
                        local currentChar = localPlayer.Character
                        local currentHumanoid = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

                        if not currentChar or not currentHumanoid or currentHumanoid.Health <= 0 then
                            break
                        end

                        if getNearest() ~= target then
                            break
                        end

                        if autoFarmVariant == "Lay" then
                            local currentRoot = currentChar:FindFirstChild("HumanoidRootPart")
                            if currentRoot and target.Parent then
                                pcall(function()
                                    currentRoot.CFrame = CFrame.new(target.Position + Vector3.new(0, -3, 0))
                                        * CFrame.Angles(math.rad(180), 0, 0)
                                end)
                            end
                        end

                        task.wait(0.05)
                    end

                    if autoFarmCoinsRunning then
                        task.wait(math.clamp(tonumber(autoFarmCollectDelay) or 1, 0.6, 2))
                    end
                end
            else
                task.wait(0.15)
            end
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
                autoFarmCoinsRunning = true
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
    local radius = AIMLOCK_FOV_RADIUS
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

pcall(function()
    RunService:UnbindFromRenderStep("BolongAimlockLock")
end)

RunService:BindToRenderStep("BolongAimlockLock", Enum.RenderPriority.Camera.Value + 1, function()
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

    local cameraPosition = Camera.CFrame.Position
    Camera.CFrame = CFrame.lookAt(cameraPosition, aimPart.Position)
end)


AUTO_SHOOT_SHOT_COOLDOWN = 0.008

AUTO_SHOOT_PREDICTION = 0.02

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
            local torso = character and character:FindFirstChild("LowerTorso")
            local roleIsMurderer = getRole(player) == "Murderer"
            local hasKnife = character and character:FindFirstChild("Knife") ~= nil

            if (roleIsMurderer or hasKnife) and torso and humanoid and humanoid.Health > 0 then
                local distance = (torso.Position - localRoot.Position).Magnitude
                local score = distance

                if score < bestScore then
                    bestScore = score
                    bestPlayer = player
                    bestPart = torso
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

function getAutoShootTargetPoint(character, origin)
    if not character then
        return nil
    end

    local torso = character:FindFirstChild("LowerTorso")
    if not torso or not torso:IsA("BasePart") then
        return nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local moveDirection = humanoid and humanoid.MoveDirection or Vector3.zero
    local flatMove = Vector3.new(moveDirection.X, 0, moveDirection.Z)

    if flatMove.Magnitude > 0.001 then
        return torso.Position + flatMove.Unit * AUTO_SHOOT_PREDICTION
    end

    return torso.Position
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
    local character = targetPart.Parent
    local targetPosition = getAutoShootTargetPoint(character, origin)
    if not targetPosition then
        return false
    end

    if (targetPosition - origin).Magnitude < 0.01 then
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
        autoShootShotCooldownUntil = os.clock() + AUTO_SHOOT_SHOT_COOLDOWN
        PlaySoundAsset(104895925840852, 1)
        playGunFiredVisual(handle, origin, targetPosition, targetPart)
    end

    return ok
end

function autoShootFlick(gun, targetPart)
    if not gun or not targetPart or not targetPart.Parent then
        return false
    end

    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then
        return false
    end

    local originPart = gun:FindFirstChild("Handle")
    local origin = originPart and originPart:IsA("BasePart") and originPart.Position or root.Position
    local targetPosition = getAutoShootTargetPoint(targetPart.Parent, origin)
    if not targetPosition then
        return false
    end

    -- เก็บทิศเดิมไว้ แต่ปล่อยให้ตัวละครเดิน/เปลี่ยนตำแหน่งได้ตามปกติ
    local originalLook = root.CFrame.LookVector
    local originalYaw = math.atan2(-originalLook.X, -originalLook.Z)
    local flatTarget = Vector3.new(targetPosition.X, root.Position.Y, targetPosition.Z)
    local flatDirection = flatTarget - root.Position
    if flatDirection.Magnitude <= 0.01 then
        return fireShotAtTarget(gun, targetPart)
    end

    local targetYaw = math.atan2(-flatDirection.X, -flatDirection.Z)
    local originalAutoRotate = humanoid.AutoRotate
    local fired = false

    local function rotateOver(duration, fromYaw, toYaw)
        local startTime = os.clock()
        local delta = math.atan2(math.sin(toYaw - fromYaw), math.cos(toYaw - fromYaw))

        while root.Parent do
            local alpha = math.clamp((os.clock() - startTime) / duration, 0, 1)
            local eased = 1 - (1 - alpha) * (1 - alpha)
            local yaw = fromYaw + delta * eased
            local pos = root.Position
            root.CFrame = CFrame.new(pos) * CFrame.Angles(0, yaw, 0)

            if alpha >= 1 then
                break
            end
            task.wait()
        end
    end

    pcall(function()
        humanoid.AutoRotate = false
    end)

    -- ยิงก่อนหัน เพื่อให้จุดเล็งถูกคำนวณจากเป้าหมายเดิมโดยทันที
    if root.Parent and targetPart.Parent then
        fired = fireShotAtTarget(gun, targetPart)
    end

    -- หลังยิงแล้วค่อยหันทั้งตัวไปหา Murderer ใน 0.1 วินาที
    if root.Parent then
        rotateOver(0.1, originalYaw, targetYaw)
    end

    -- หันทั้งตัวกลับทิศเดิมใน 0.1 วินาที โดยไม่ล็อกตำแหน่งตัวละคร
    if root.Parent then
        local currentLook = root.CFrame.LookVector
        local currentYaw = math.atan2(-currentLook.X, -currentLook.Z)
        rotateOver(0.1, currentYaw, originalYaw)
    end

    pcall(function()
        if humanoid.Parent then
            humanoid.AutoRotate = originalAutoRotate
        end
    end)

    return fired
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

    local currentCharacter = localPlayer.Character
    local equippedGun = currentCharacter and currentCharacter:FindFirstChild("Gun")
    if not equippedGun then
        equipTool(gun)
        equippedGun = getToolByName(localPlayer, "Gun") or gun
    end

    if autoShootVariant == "Flick" then
        if autoShootFlick(equippedGun, targetPart) then
            return
        end
        if equippedGun ~= gun then
            autoShootFlick(gun, targetPart)
        end
        return
    end

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
                PlaySoundAsset(88129339693239, 1)
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
InvisiblePanel.Size = UDim2.fromOffset(65, 65)
InvisiblePanel.Visible = false
InvisiblePanel.Active = true
InvisiblePanel.Selectable = true
InvisiblePanel.Parent = InvisibleGui

InvisiblePanelCorner = Instance.new("UICorner")
InvisiblePanelCorner.CornerRadius = UDim.new(0, 10)
InvisiblePanelCorner.Parent = InvisiblePanel

InvisiblePanelStroke = Instance.new("UIStroke")
InvisiblePanelStroke.Color = Color3.fromRGB(0,195,255)
InvisiblePanelStroke.Thickness = 2
InvisiblePanelStroke.Transparency = .2
InvisiblePanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
InvisiblePanelStroke.Parent = InvisiblePanel

local SetInvisible

InvisibleLabel = Instance.new("TextLabel")
InvisibleLabel.Size = UDim2.new(1,0,1,0)
InvisibleLabel.BackgroundTransparency = 1
InvisibleLabel.Text = "INVISIBLE"
InvisibleLabel.TextColor3 = Color3.fromRGB(255,255,255)
InvisibleLabel.TextSize = 11
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
            SetInvisible(not invisibleEnabled)
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
AimbotIcon.Size = UDim2.fromOffset(50, 50)
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
AimbotCircleGui.DisplayOrder = 10001
AimbotCircleGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
AimbotCircleGui.Enabled = true
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

AimbotFOVSpinner = Instance.new("ImageLabel")
AimbotFOVSpinner.Name = "AimlockFOVSpinner"
AimbotFOVSpinner.AnchorPoint = Vector2.new(0.5, 0.5)
AimbotFOVSpinner.Position = UDim2.fromScale(0.5, 0.5)
AimbotFOVSpinner.Size = UDim2.fromOffset(30, 30)
AimbotFOVSpinner.BackgroundTransparency = 1
AimbotFOVSpinner.Image = "rbxassetid://78275912674145"
AimbotFOVSpinner.Position = UDim2.fromScale(0.5, 0.5)
AimbotFOVSpinner.ImageTransparency = 0
AimbotFOVSpinner.Visible = false
AimbotFOVSpinner.Active = false
AimbotFOVSpinner.ZIndex = 100
AimbotFOVSpinner.Parent = AimbotCircleGui

aimlockSpinnerConnection = RunService.RenderStepped:Connect(function(deltaTime)
    if AimbotFOVSpinner and AimbotFOVSpinner.Visible then
        AimbotFOVSpinner.Rotation = (AimbotFOVSpinner.Rotation + (deltaTime * 180)) % 360
    end
end)


function UpdateAimbotVisuals()
    -- The aimlock FOV is fixed at 30 and intentionally has no visible circle.
    AimbotCircle.Visible = false
    CircleStroke.Transparency = 1

    if AimbotFOVSpinner then
        local shouldShowSpinner = (aimbotActive == true and aimlockEngaged == true)
        AimbotFOVSpinner.Visible = shouldShowSpinner
        if not shouldShowSpinner then
            AimbotFOVSpinner.Rotation = 0
        end
    end

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
            PlaySoundAsset(111044884172919, 1)
            aimlockEngaged = not aimlockEngaged
            aimbotFOVVisible = aimlockEngaged
            if not aimlockEngaged then
                clearAimlockTarget()
            end
            UpdateAimbotVisuals()

            -- Make the center spinner appear/disappear immediately with the panel.
            if AimbotFOVSpinner then
                AimbotFOVSpinner.Visible = (aimbotActive == true and aimlockEngaged == true)
            end
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
    local iconSize = math.clamp(AimbotPanelScale * 6, 34, 52)
    AimbotIcon.Size = UDim2.fromOffset(iconSize, iconSize)
end

UpdateAimbotPanelScale(AimbotPanelScale)
aimbotFOV = 30
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
local touchFlingRestoreCFrame = nil
local touchFlingRestoreCharacter = nil

local function restoreTouchFlingPosition()
    local character = touchFlingRestoreCharacter
    local restoreCF = touchFlingRestoreCFrame
    if not character or not restoreCF then
        return
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hrp and hrp.Parent then
        pcall(function()
            hrp.CFrame = restoreCF
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
        if character.PrimaryPart then
            pcall(function() character:SetPrimaryPartCFrame(restoreCF) end)
        end
        if hum then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end

    touchFlingRestoreCFrame = nil
    touchFlingRestoreCharacter = nil
end

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
    local nextState = enabled == true

    if nextState and not touchFlingEnabled then
        local character = localPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            touchFlingRestoreCFrame = hrp.CFrame
            touchFlingRestoreCharacter = character
        end
    end

    touchFlingEnabled = nextState

    if touchFlingEnabled then
        if not touchFlingThread or coroutine.status(touchFlingThread) == "dead" then
            touchFlingThread = coroutine.create(touchFlingLoop)
            coroutine.resume(touchFlingThread)
        end
    else
        touchFlingThread = nil
        restoreTouchFlingPosition()
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
antiFlingRestoreCFrame = nil
antiFlingRestoreCharacter = nil

local function restoreAntiFlingPosition()
    local character = antiFlingRestoreCharacter
    local restoreCF = antiFlingRestoreCFrame
    if not character or not restoreCF then
        return
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hrp and hrp.Parent then
        pcall(function()
            hrp.CFrame = restoreCF
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
        if character.PrimaryPart then
            pcall(function() character:SetPrimaryPartCFrame(restoreCF) end)
        end
        if hum then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end

    antiFlingRestoreCFrame = nil
    antiFlingRestoreCharacter = nil
end

function SetAntiFling(enabled)
    local nextState = enabled == true

    if nextState and not antiFlingEnabled then
        local character = localPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            antiFlingRestoreCFrame = hrp.CFrame
            antiFlingRestoreCharacter = character
        end
    end

    antiFlingEnabled = nextState

    if antiFlingConnection then
        antiFlingConnection:Disconnect()
        antiFlingConnection = nil
    end

    if not antiFlingEnabled then
        restoreAntiFlingPosition()
        return
    end

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

    PlaySoundAsset(402143943, 1)

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
    local mouseLockActive = false
    local okLock = pcall(function()
        mouseLockActive = isFakeBombMouseLockOn()
    end)
    if okLock and mouseLockActive then
        local rootLook = originPart.CFrame.LookVector
        if rootLook.Magnitude > 0.001 then
            forward = rootLook
        end
        -- also allow camera direction if it gives better results
        if camera then
            local camLook = camera.CFrame.LookVector
            if camLook.Magnitude > 0.001 and camLook:Dot(forward) < 0.5 then
                forward = camLook
            end
        end
    end

    local dotThreshold = AUTO_THROW_FOV_DOT
    if mouseLockActive then
        dotThreshold = 0.2
    end

    local bestTarget = nil
    local bestScore = -math.huge
    local bestDist = math.huge

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
                    if distance > 0.05 and distance < 60 then
                        local direction = offset.Unit
                        local dot = forward:Dot(direction)
                        if dot >= dotThreshold then
                            local score = (dot * 1000) - distance
                            if score > bestScore then
                                bestScore = score
                                bestTarget = targetPart
                            end
                        elseif mouseLockActive and distance < bestDist then
                            bestDist = distance
                            bestTarget = targetPart
                        end
                    end
                end
            end
        end
    end

    if not bestTarget and mouseLockActive then
        local bestDist2 = math.huge
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
                        local dist = (targetPart.Position - origin).Magnitude
                        if dist > 0.05 and dist < 60 and dist < bestDist2 then
                            bestDist2 = dist
                            bestTarget = targetPart
                        end
                    end
                end
            end
        end
    end

    return bestTarget
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
        -- try immediate throw if mouselock and target in view/near
        do
            local mlock = false
            pcall(function() mlock = isFakeBombMouseLockOn() end)
            if mlock then
                task.defer(function()
                    local t = getAutoThrowSilentTarget()
                    if t then
                        fireKnifeThrowAtTarget(t)
                    end
                end)
            end
        end
        return
    end

    if id ~= AUTO_THROW_READY_ID then
        return
    end

    local mlock = false
    pcall(function() mlock = isFakeBombMouseLockOn() end)
    local timeout = 2
    if mlock then timeout = 4 end
    if os.clock() - autoThrowLastWindupAt > timeout and not mlock then
        return
    end
    if mlock and os.clock() - autoThrowLastWindupAt > 5 then
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

    if fakeBombVariant == "Auto" and fakeBombAutoJumpEnabled then
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

function onFakeBombManualScreenTap(input)
    if fakeBombVariant ~= "Manual" then
        return
    end

    if not fakeBombJumpEnabled or fakeBombScreenTouchSuppress then
        return
    end

    if input and input.UserInputType ~= Enum.UserInputType.Touch
        and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return
    end

    local char = localPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local bomb = char and char:FindFirstChild("FakeBomb")

    if not humanoid or not bomb or not bomb:IsA("Tool") then
        return
    end

    -- Manual mode: the player jumps by themselves, then taps/clicks.
    -- The bomb is placed directly under the player's feet; no automatic jump is issued.
    local state = humanoid:GetState()
    if state ~= Enum.HumanoidStateType.Jumping
        and state ~= Enum.HumanoidStateType.Freefall
        and state ~= Enum.HumanoidStateType.FallingDown then
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

    -- Manual mode is deliberately input-driven.
    -- Do not fire merely because Humanoid entered Jumping; the player must tap the screen.
end

function setupFakeBombManualInput()
    if fakeBombManualInputConnection then
        pcall(function()
            fakeBombManualInputConnection:Disconnect()
        end)
        fakeBombManualInputConnection = nil
    end

    fakeBombManualInputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end
        if input.UserInputType ~= Enum.UserInputType.Touch
            and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end
        onFakeBombManualScreenTap(input)
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
setupFakeBombManualInput()
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
    if FakeBombJumpPanel then
        FakeBombJumpPanel.Visible = false
    end
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

local function getHitboxTorso(character)
    if not character then
        return nil
    end
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if torso and torso:IsA("BasePart") then
        return torso
    end
    return nil
end

local function restoreHitboxPlayer(player)
    local data = hitboxOriginals[player]
    if not data then
        return
    end

    local torso = data.part
    if torso and torso.Parent then
        pcall(function()
            torso.Size = data.size
            torso.Transparency = data.transparency
            torso.CanCollide = data.canCollide
            torso.CanTouch = data.canTouch
            torso.CanQuery = data.canQuery
        end)
    end

    local visual = hitboxVisuals[player]
    if visual then
        pcall(function() visual:Destroy() end)
        hitboxVisuals[player] = nil
    end

    hitboxOriginals[player] = nil
end

local function isHitboxRole(role)
    return role == "Innocent"
        or role == "Sheriff"
        or role == "Hero"
        or role == "Murderer"
end

local function getHitboxTransparency()
    return math.clamp((tonumber(hitboxTransparencyLevel) or 5) / 10, 0.5, 1)
end

local function applyHitboxPlayer(player)
    if not hitboxExpandEnabled or not player or player == localPlayer then
        return
    end

    local role = GetPlayerRoleMM2(player)
    if not isHitboxRole(role) then
        restoreHitboxPlayer(player)
        return
    end

    local character = player.Character
    local torso = getHitboxTorso(character)
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not torso or not humanoid or humanoid.Health <= 0 then
        restoreHitboxPlayer(player)
        return
    end

    local data = hitboxOriginals[player]
    if not data or data.part ~= torso then
        if data then
            restoreHitboxPlayer(player)
        end

        data = {
            part = torso,
            size = torso.Size,
            transparency = torso.Transparency,
            canCollide = torso.CanCollide,
            canTouch = torso.CanTouch,
            canQuery = torso.CanQuery
        }
        hitboxOriginals[player] = data
    end

    pcall(function()
        -- Keep the enlarged hitbox square/cubic without turning it into a physical wall.
        torso.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
        torso.CanCollide = false
        torso.CanTouch = data.canTouch
        torso.CanQuery = true

        local visual = hitboxVisuals[player]
        if not visual or visual.Parent ~= torso then
            if visual then
                pcall(function() visual:Destroy() end)
            end
            visual = Instance.new("BoxHandleAdornment")
            visual.Name = "BolongHitboxBox"
            visual.Adornee = torso
            visual.AlwaysOnTop = true
            visual.ZIndex = 10
            visual.Parent = torso
            hitboxVisuals[player] = visual
        end
        visual.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
        visual.Transparency = getHitboxTransparency()
        visual.Color3 = Color3.fromRGB(0, 180, 255)
    end)
end

local function SetHitboxExpand(state)
    hitboxExpandEnabled = state == true

    if not hitboxExpandEnabled then
        for player in pairs(hitboxOriginals) do
            restoreHitboxPlayer(player)
        end
        for player, visual in pairs(hitboxVisuals) do
            if visual then
                pcall(function() visual:Destroy() end)
            end
            hitboxVisuals[player] = nil
        end
        hitboxOriginals = {}
    end
end

local function SetHitboxSize(value)
    hitboxSize = math.clamp(tonumber(value) or 4, 1, 20)

    if hitboxExpandEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            applyHitboxPlayer(player)
        end
    end
end

local function SetHitboxTransparency(value)
    hitboxTransparencyLevel = math.clamp(tonumber(value) or 5, 5, 10)

    if not hitboxExpandEnabled then
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        applyHitboxPlayer(player)
    end
end

RunService.Heartbeat:Connect(function()
    if not hitboxExpandEnabled then
        return
    end

    local activePlayers = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            activePlayers[player] = true
            applyHitboxPlayer(player)
        end
    end

    for player in pairs(hitboxOriginals) do
        if not activePlayers[player] then
            restoreHitboxPlayer(player)
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
        if obj:IsA("BasePart") then
            invisibleTransparencyOriginals[obj] = obj.Transparency
            obj.Transparency = 1
        end
    end)
end

local function isInvisibleBarrierPart(part)
    if not part or not part:IsA("BasePart") then
        return false
    end

    if part.Transparency < 0.99 or not part.CanCollide then
        return false
    end

    -- Do not touch player characters or tool parts; this feature targets map collision.
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and part:IsDescendantOf(player.Character) then
            return false
        end
    end

    local toolAncestor = part:FindFirstAncestorOfClass("Tool")
    if toolAncestor then
        return false
    end

    return true
end

local function removeInvisibleBarrierPart(part)
    if not isInvisibleBarrierPart(part) then
        return
    end

    if removeInvisibleBarrierOriginals[part] == nil then
        removeInvisibleBarrierOriginals[part] = part.CanCollide
    end

    pcall(function()
        part.CanCollide = false
    end)
end

local function restoreInvisibleBarriers()
    for part, originalCanCollide in pairs(removeInvisibleBarrierOriginals) do
        if part and part.Parent then
            pcall(function()
                part.CanCollide = originalCanCollide
            end)
        end
    end
    removeInvisibleBarrierOriginals = {}
end

local function scanInvisibleBarriers()
    walkDescendants(Workspace, function(obj)
        if obj:IsA("BasePart") then
            removeInvisibleBarrierPart(obj)
        end
    end)
end

function SetRemoveInvisibleBarriers(state)
    removeInvisibleBarrierEnabled = state == true

    if removeInvisibleBarrierConnection then
        removeInvisibleBarrierConnection:Disconnect()
        removeInvisibleBarrierConnection = nil
    end

    if not removeInvisibleBarrierEnabled then
        restoreInvisibleBarriers()
        return
    end

    scanInvisibleBarriers()

    removeInvisibleBarrierConnection = Workspace.DescendantAdded:Connect(function(obj)
        if removeInvisibleBarrierEnabled and obj:IsA("BasePart") then
            task.defer(function()
                if removeInvisibleBarrierEnabled and obj.Parent then
                    removeInvisibleBarrierPart(obj)
                end
            end)
        end
    end)
end

SetInvisible = function(state)
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
        return
    end

    if character then
        makeCharacterInvisible(character)
    end

    if InvisiblePanel then
        InvisiblePanel.Visible = invisibleFeatureEnabled
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
            local invisCF = oldCF * CFrame.new(0, -5000, 0)

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


local CoinOpt = {
    spinningHidden = false,
    coinsHidden = false,
    hiddenSpinning = {},
    hiddenCoins = {},
    pollThread = nil,
    petsHidden = false,
    hiddenPets = {},
}

local function findAllCoinVisuals()
    local results = {}
    walkDescendants(Workspace, function(desc)
        if desc.Name == "CoinVisual" then
            results[#results + 1] = desc
        end
    end)
    return results
end

local function findAllCoinServers()
    local results = {}
    walkDescendants(Workspace, function(desc)
        if desc.Name == "Coin_Server" then
            results[#results + 1] = desc
        end
    end)
    return results
end

local function hideObj(obj, store)
    if not obj or not obj.Parent then
        return false
    end
    table.insert(store, { obj = obj, parent = obj.Parent })
    obj.Parent = nil
    return true
end

local function hideSpinning()
    CoinOpt.hiddenSpinning = {}
    for _, obj in ipairs(findAllCoinVisuals()) do
        hideObj(obj, CoinOpt.hiddenSpinning)
    end
end

local function showSpinning()
    for _, entry in ipairs(CoinOpt.hiddenSpinning) do
        if entry.obj and entry.parent then
            pcall(function() entry.obj.Parent = entry.parent end)
        end
    end
    CoinOpt.hiddenSpinning = {}
end

local function hideCoins()
    CoinOpt.hiddenCoins = {}
    for _, obj in ipairs(findAllCoinServers()) do
        hideObj(obj, CoinOpt.hiddenCoins)
    end
end

local function showCoins()
    for _, entry in ipairs(CoinOpt.hiddenCoins) do
        if entry.obj and entry.parent then
            pcall(function() entry.obj.Parent = entry.parent end)
        end
    end
    CoinOpt.hiddenCoins = {}
end

local function findAllPets()
    local results = {}
    for _, char in ipairs(Workspace:GetChildren()) do
        local pet = char:FindFirstChild("Pet")
        if pet then
            results[#results + 1] = pet
        end
    end
    return results
end

local function hidePets()
    CoinOpt.hiddenPets = {}
    for _, obj in ipairs(findAllPets()) do
        hideObj(obj, CoinOpt.hiddenPets)
    end
end

local function showPets()
    for _, entry in ipairs(CoinOpt.hiddenPets) do
        if entry.obj and entry.parent then
            pcall(function() entry.obj.Parent = entry.parent end)
        end
    end
    CoinOpt.hiddenPets = {}
end

local function startCoinPolling()
    if CoinOpt.pollThread then
        return
    end

    CoinOpt.pollThread = task.spawn(function()
        while CoinOpt.spinningHidden or CoinOpt.coinsHidden or CoinOpt.petsHidden do
            if CoinOpt.spinningHidden then
                for _, obj in ipairs(findAllCoinVisuals()) do
                    hideObj(obj, CoinOpt.hiddenSpinning)
                end
            end

            if CoinOpt.coinsHidden then
                for _, obj in ipairs(findAllCoinServers()) do
                    hideObj(obj, CoinOpt.hiddenCoins)
                end
            end

            if CoinOpt.petsHidden then
                for _, obj in ipairs(findAllPets()) do
                    hideObj(obj, CoinOpt.hiddenPets)
                end
            end

            task.wait(0.3)
        end

        CoinOpt.pollThread = nil
    end)
end

local render3dCce = Instance.new("ColorCorrectionEffect")
render3dCce.Name = "Bolong3DOff"
render3dCce.Brightness = -1
render3dCce.Contrast = -1
render3dCce.Saturation = -1
render3dCce.Enabled = false
render3dCce.Parent = Lighting

local SELECTED_FLING_TIMEOUT = 2.5
local selectedFlingRestoreCFrame = nil
local selectedFlingRestoreCharacter = nil

local function restoreSelectedFlingPosition()
    local character = selectedFlingRestoreCharacter
    local restoreCF = selectedFlingRestoreCFrame
    if not character or not restoreCF then
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    local hum = character:FindFirstChildOfClass("Humanoid")
    if root and root.Parent then
        pcall(function()
            root.CFrame = restoreCF
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
        if character.PrimaryPart then
            pcall(function() character:SetPrimaryPartCFrame(restoreCF) end)
        end
        if hum then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end

    selectedFlingRestoreCFrame = nil
    selectedFlingRestoreCharacter = nil
end

local function StopSelectedFling()
    selectedFlingEnabled = false
    selectedFlingInProgress = false
    restoreSelectedFlingPosition()
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
    selectedFlingRestoreCFrame = oldPos
    selectedFlingRestoreCharacter = myChar

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

    if myRoot.Parent then
        local restoreCF = oldPos
        pcall(function()
            myRoot.CFrame = restoreCF
            myRoot.AssemblyLinearVelocity = Vector3.zero
            myRoot.AssemblyAngularVelocity = Vector3.zero
        end)
        if myChar.PrimaryPart then
            pcall(function() myChar:SetPrimaryPartCFrame(restoreCF) end)
        end
        myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end

    selectedFlingRestoreCFrame = nil
    selectedFlingRestoreCharacter = nil
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
    end
    if InvisiblePanel then
        InvisiblePanel.Visible = invisibleFeatureEnabled
    end

    if selectedFlingEnabled then
        StopSelectedFling()
    end
end)


--//================== MURDERER: KNIFE SILENCE AIM ==================//
local KnifeSilence = {
    enabled = false,
    circleAim = false,
    circleSize = 150,
    drawCircle = true,
    circleColor = Color3.fromRGB(255, 255, 255),
    throwBtnEnabled = false,
    throwBtn = nil,
    throwBtnGui = nil,
    knifeOffset = 1.0,
    knifeSpeed = 80,
    knifeHeight = 1.5,
    pingPredict = true,
    jumpPredict = true,
}

local KnifeSilenceHook = {
    ws = nil,
    origGetTarget = nil,
    origMouseTarget = nil,
    hooked = false,
    throwing = false,
    dynamicLoop = nil,
    lastPredicted = nil,
}

local knifeSilenceCircleGui = Instance.new("ScreenGui")
knifeSilenceCircleGui.Name = "BolongKnifeSilenceCircle"
knifeSilenceCircleGui.ResetOnSpawn = false
knifeSilenceCircleGui.IgnoreGuiInset = true
knifeSilenceCircleGui.DisplayOrder = 996
knifeSilenceCircleGui.Parent = PlayerGui

local knifeSilenceCircle = Instance.new("Frame")
knifeSilenceCircle.Name = "Circle"
knifeSilenceCircle.AnchorPoint = Vector2.new(0.5, 0.5)
knifeSilenceCircle.Position = UDim2.fromScale(0.5, 0.5)
knifeSilenceCircle.BackgroundTransparency = 1
knifeSilenceCircle.BorderSizePixel = 0
knifeSilenceCircle.Visible = false
knifeSilenceCircle.ZIndex = 30
knifeSilenceCircle.Parent = knifeSilenceCircleGui
Instance.new("UICorner", knifeSilenceCircle).CornerRadius = UDim.new(1, 0)

local knifeSilenceCircleStroke = Instance.new("UIStroke")
knifeSilenceCircleStroke.Thickness = 2
knifeSilenceCircleStroke.Transparency = 0
knifeSilenceCircleStroke.Color = KnifeSilence.circleColor
knifeSilenceCircleStroke.Parent = knifeSilenceCircle

local function isKnifeSilenceShiftLock()
    return UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
end

local function findKnifeSilenceTool()
    local char = localPlayer.Character
    local backpack = localPlayer:FindFirstChild("Backpack")

    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("knife") then
                return tool, true
            end
        end
    end

    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("knife") then
                return tool, false
            end
        end
    end

    return nil, false
end

local function getKnifeSilenceTarget()
    local myChar = localPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then
        return nil
    end

    local closest, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local dist = (root.Position - myRoot.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = char
                end
            end
        end
    end
    return closest
end

local function getKnifeSilenceScreenPoint(position)
    local camera = Workspace.CurrentCamera
    if not camera then
        return nil
    end
    local p, onScreen = camera:WorldToViewportPoint(position)
    if p.Z <= 0 then
        return nil
    end
    return Vector2.new(p.X, p.Y), onScreen
end

local function isKnifeSilenceTargetInCircle(targetChar)
    local root = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    if not root then
        return false
    end
    local screenPos, onScreen = getKnifeSilenceScreenPoint(root.Position)
    if not screenPos or not onScreen then
        return false
    end
    local vp = Workspace.CurrentCamera.ViewportSize
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    return (screenPos - center).Magnitude <= (KnifeSilence.circleSize / 2)
end

local function predictKnifeSilenceTarget(targetChar)
    local hrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    local aimPart = targetChar and (
        targetChar:FindFirstChild("UpperTorso")
        or targetChar:FindFirstChild("HumanoidRootPart")
        or targetChar:FindFirstChild("Head")
        or targetChar:FindFirstChild("Torso")
    )
    if not hrp or not aimPart then
        return nil
    end

    local myChar = localPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then
        return nil
    end

    local velocity = hrp.AssemblyLinearVelocity
    local ping = localPlayer:GetNetworkPing() or 0

    local aimPos = Vector3.new(
        aimPart.Position.X,
        aimPart.Position.Y + KnifeSilence.knifeHeight,
        aimPart.Position.Z
    )

    local myXZ = Vector3.new(myRoot.Position.X, 0, myRoot.Position.Z)
    local aimXZ = Vector3.new(aimPos.X, 0, aimPos.Z)
    local dist = (aimXZ - myXZ).Magnitude
    if dist < 1 then
        dist = 1
    end

    local travelTime = dist / math.max(1, KnifeSilence.knifeSpeed)
    if KnifeSilence.pingPredict then
        travelTime = travelTime + math.max(0, ping)
    end

    local velXZ = Vector3.new(velocity.X, 0, velocity.Z)
    local toTarget = aimXZ - myXZ
    local throwDir = toTarget.Magnitude > 0.1 and toTarget.Unit or Vector3.new(0, 0, -1)

    local parallelMag = velXZ:Dot(throwDir)
    local parallel = throwDir * parallelMag
    local perpendicular = velXZ - parallel
    local offsetVec = Vector3.zero

    if KnifeSilence.knifeOffset ~= 0 and perpendicular.Magnitude > 0.1 then
        offsetVec = perpendicular.Unit * KnifeSilence.knifeOffset
    end

    local predictedY = aimPos.Y
    if KnifeSilence.jumpPredict then
        local clampedLead = math.min(travelTime, 0.6)
        predictedY = aimPos.Y + velocity.Y * clampedLead * 0.25
    end

    local perpendicularLead = perpendicular * travelTime * 0.6

    return Vector3.new(
        aimPos.X + perpendicularLead.X + offsetVec.X,
        predictedY,
        aimPos.Z + perpendicularLead.Z + offsetVec.Z
    )
end

local function getKnifeSilenceAimCFrame()
    if not KnifeSilence.enabled then
        return nil
    end

    local target = getKnifeSilenceTarget()
    if target then
        if KnifeSilence.circleAim then
            if isKnifeSilenceTargetInCircle(target) then
                local pos = predictKnifeSilenceTarget(target)
                if pos then
                    return CFrame.new(pos)
                end
            end
        else
            local pos = predictKnifeSilenceTarget(target)
            if pos then
                return CFrame.new(pos)
            end
        end
    end

    if KnifeSilence.circleAim and isKnifeSilenceShiftLock() then
        local camera = Workspace.CurrentCamera
        if not camera then
            return nil
        end
        local rayDir = camera.CFrame.LookVector * 1000
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {localPlayer.Character}
        local hit = Workspace:Raycast(camera.CFrame.Position, rayDir, params)
        if hit then
            return CFrame.new(hit.Position)
        end
        return CFrame.new(camera.CFrame.Position + rayDir)
    end

    return nil
end

local function hookKnifeSilenceWeaponService()
    if KnifeSilenceHook.hooked then
        return
    end

    if not KnifeSilenceHook.ws then
        local ok, ws = pcall(function()
            return require(
                game:GetService("ReplicatedStorage")
                    :WaitForChild("ClientServices")
                    :WaitForChild("WeaponService")
            )
        end)
        if not ok or not ws then
            return
        end

        KnifeSilenceHook.ws = ws
        KnifeSilenceHook.origGetTarget = ws.GetTargetPosition
        KnifeSilenceHook.origMouseTarget = ws.GetMouseTargetCFrame
    end

    local ws = KnifeSilenceHook.ws
    if not ws then
        return
    end

    ws.GetTargetPosition = function(self, x, y)
        local aim = getKnifeSilenceAimCFrame()
        if aim then
            return aim
        end
        return KnifeSilenceHook.origGetTarget(self, x, y)
    end

    ws.GetMouseTargetCFrame = function(self)
        local aim = getKnifeSilenceAimCFrame()
        if aim then
            return aim
        end
        return KnifeSilenceHook.origMouseTarget(self)
    end

    KnifeSilenceHook.hooked = true
end

local function unhookKnifeSilenceWeaponService()
    if not KnifeSilenceHook.hooked or not KnifeSilenceHook.ws then
        return
    end

    KnifeSilenceHook.ws.GetTargetPosition = KnifeSilenceHook.origGetTarget
    KnifeSilenceHook.ws.GetMouseTargetCFrame = KnifeSilenceHook.origMouseTarget
    KnifeSilenceHook.hooked = false
end

local function makeKnifeSilenceThrowButton()
    if KnifeSilence.throwBtn and KnifeSilence.throwBtn.Parent then
        return
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "BolongKnifeSilenceThrow"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 995
    gui.Parent = PlayerGui

    local button = Instance.new("TextButton")
    button.Name = "ThrowBtn"
    button.AnchorPoint = Vector2.new(0.5, 0.5)
    button.Position = UDim2.fromScale(0.5, 0.68)
    button.Size = UDim2.fromOffset(72, 72)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    button.BackgroundTransparency = 0.2
    button.Text = "THROW"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    button.Visible = true
    button.Parent = gui
    Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke")
    stroke.Color = KnifeSilence.circleColor
    stroke.Thickness = 2
    stroke.Transparency = 0.1
    stroke.Parent = button

    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    local moved = false

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragInput = input
            dragStart = input.Position
            startPos = button.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            if delta.Magnitude > 6 then
                moved = true
            end
            button.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if dragging and input == dragInput then
            dragging = false
            dragInput = nil
        end
    end)

    button.Activated:Connect(function()
        if not moved then
            KnifeSilenceHook.throwing = false
            local char = localPlayer.Character
            local knife, equipped = findKnifeSilenceTool()
            local backpack = localPlayer:FindFirstChild("Backpack")
            if not knife or not char then
                return
            end

            if KnifeSilenceHook.throwing then
                return
            end

            KnifeSilenceHook.throwing = true
            KnifeSilenceHook.lastPredicted = nil

            KnifeSilenceHook.dynamicLoop = task.spawn(function()
                while KnifeSilenceHook.throwing do
                    local target = getKnifeSilenceTarget()
                    if target then
                        local inside = (not KnifeSilence.circleAim) or isKnifeSilenceTargetInCircle(target)
                        if inside then
                            local predicted = predictKnifeSilenceTarget(target)
                            if predicted then
                                KnifeSilenceHook.lastPredicted = predicted
                            end
                        else
                            KnifeSilenceHook.lastPredicted = nil
                        end
                    end
                    task.wait(0.05)
                end
            end)

            pcall(function()
                if not equipped and knife.Parent ~= char and backpack then
                    knife.Parent = char
                end

                local throwSpeed = knife:GetAttribute("ThrowSpeed") or 1
                task.wait(throwSpeed)

                local predicted = KnifeSilenceHook.lastPredicted

                if not predicted and KnifeSilence.circleAim and isKnifeSilenceShiftLock() then
                    local camera = Workspace.CurrentCamera
                    local rayOrigin = camera.CFrame.Position
                    local rayDir = camera.CFrame.LookVector * 1000
                    local params = RaycastParams.new()
                    params.FilterType = Enum.RaycastFilterType.Exclude
                    params.FilterDescendantsInstances = {localPlayer.Character}
                    local hit = Workspace:Raycast(rayOrigin, rayDir, params)
                    predicted = hit and hit.Position or (rayOrigin + rayDir)
                end

                if not predicted then
                    return
                end

                local events = knife:FindFirstChild("Events")
                local remote = events and events:FindFirstChild("KnifeThrown")
                local handle = knife:FindFirstChild("Handle")
                if remote and remote:IsA("RemoteEvent") and handle then
                    remote:FireServer(handle.CFrame, CFrame.new(predicted))
                end
            end)

            KnifeSilenceHook.throwing = false
        end
    end)

    KnifeSilence.throwBtnGui = gui
    KnifeSilence.throwBtn = button
end

local function removeKnifeSilenceThrowButton()
    if KnifeSilence.throwBtnGui then
        pcall(function() KnifeSilence.throwBtnGui:Destroy() end)
    end
    KnifeSilence.throwBtnGui = nil
    KnifeSilence.throwBtn = nil
end

RunService.RenderStepped:Connect(function()
    knifeSilenceCircle.Size = UDim2.fromOffset(KnifeSilence.circleSize, KnifeSilence.circleSize)
    knifeSilenceCircleStroke.Color = KnifeSilence.circleColor
    knifeSilenceCircle.Visible =
        KnifeSilence.enabled
        and KnifeSilence.circleAim
        and KnifeSilence.drawCircle
end)

function BuildUI()
    refreshLocalPlayerReferences()
    if not PlayerGui then
        PlayerGui = localPlayer:WaitForChild("PlayerGui")
    end

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
    HitboxSec:AddSlider({
        Title = "Transparency",
        Min = 5,
        Max = 10,
        Default = 5,
        Increment = 1,
        Callback = function(v)
            SetHitboxTransparency(v)
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
        Max = 7,
        Default = 4,
        Increment = 1,
        Callback = function(v)
            coinReachRange = math.clamp(tonumber(v) or 4, 4, 7)
            if coinReachEnabled then
                for obj, originalSize in pairs(coinReachOriginals) do
                    if obj and obj.Parent and originalSize then
                        pcall(function()
                            obj.Size = originalSize * coinReachRange
                        end)
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
    AutoFarmSec:AddDropdown({
        Title = "Variants",
        Values = {"Normal", "Lay"},
        Options = {"Normal", "Lay"},
        Default = "Normal",
        Callback = function(v)
            if type(v) == "table" then
                v = v[1]
            end
            autoFarmVariant = (v == "Lay") and "Lay" or "Normal"
        end
    })

    AutoFarmSec:AddSlider({
        Title = "Farm Speed",
        Min = 7,
        Max = 20,
        Default = 7,
        Increment = 1,
        Callback = function(v)
            autoFarmSpeed = math.clamp(tonumber(v) or 7, 7, 20)
        end
    })
    AutoFarmSec:AddSlider({
        Title = "Coin Collect Delay",
        Min = 0.6,
        Max = 2,
        Default = 1,
        Increment = 0.1,
        Callback = function(v)
            autoFarmCollectDelay = math.clamp(tonumber(v) or 1, 0.6, 2)
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
    AutoShootSec:AddDropdown({
        Title = "Variant",
        Values = {"Auto", "Flick"},
        Options = {"Auto", "Flick"},
        Default = "Auto",
        Callback = function(v)
            if type(v) == "table" then
                v = v[1]
            end
            if v ~= "Flick" then
                v = "Auto"
            end
            autoShootVariant = v
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
                FakeBombJumpPanel.Visible = fakeBombVariant == "Auto"
                fakeBombAutoJumpEnabled = (fakeBombVariant == "Auto")
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
            fakeBombAutoJumpEnabled = (fakeBombVariant == "Auto")

            if FakeBombJumpPanel then
                -- Auto keeps the floating panel. Manual hides it because the player taps the screen after jumping.
                FakeBombJumpPanel.Visible = fakeBombJumpEnabled and fakeBombVariant == "Auto"
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

    local KnifeSilenceSec = MurdererTab:AddSection("Knife silence aim", nil)
    KnifeSilenceSec:AddToggle({
        Title = "Knife silence aim",
        Default = false,
        Callback = function(v)
            KnifeSilence.enabled = v == true
            if KnifeSilence.enabled then
                hookKnifeSilenceWeaponService()
            else
                unhookKnifeSilenceWeaponService()
            end
        end
    })
    KnifeSilenceSec:AddToggle({
        Title = "Circle Aim",
        Default = false,
        Callback = function(v)
            KnifeSilence.circleAim = v == true
        end
    })
    KnifeSilenceSec:AddSlider({
        Title = "Circle Size",
        Min = 30, Max = 500, Default = 150, Increment = 5,
        Callback = function(v)
            KnifeSilence.circleSize = math.clamp(tonumber(v) or 150, 30, 500)
        end
    })
    KnifeSilenceSec:AddToggle({
        Title = "Draw Circle",
        Default = true,
        Callback = function(v)
            KnifeSilence.drawCircle = v == true
        end
    })
    KnifeSilenceSec:AddDropdown({
        Title = "Circle Color",
        Values = {"White", "Red", "Green", "Blue", "Yellow", "Cyan", "Purple", "Orange", "Pink", "Black"},
        Options = {"White", "Red", "Green", "Blue", "Yellow", "Cyan", "Purple", "Orange", "Pink", "Black"},
        Default = "White",
        Callback = function(v)
            if type(v) == "table" then
                v = v[1]
            end
            local colors = {
                White = Color3.fromRGB(255, 255, 255),
                Red = Color3.fromRGB(255, 70, 70),
                Green = Color3.fromRGB(80, 255, 120),
                Blue = Color3.fromRGB(80, 150, 255),
                Yellow = Color3.fromRGB(255, 220, 60),
                Cyan = Color3.fromRGB(80, 255, 255),
                Purple = Color3.fromRGB(190, 100, 255),
                Orange = Color3.fromRGB(255, 140, 60),
                Pink = Color3.fromRGB(255, 110, 190),
                Black = Color3.fromRGB(20, 20, 20),
            }
            KnifeSilence.circleColor = colors[v] or colors.White
        end
    })
    KnifeSilenceSec:AddToggle({
        Title = "Throw Btn",
        Default = false,
        Callback = function(v)
            KnifeSilence.throwBtnEnabled = v == true
            if KnifeSilence.throwBtnEnabled then
                makeKnifeSilenceThrowButton()
            else
                removeKnifeSilenceThrowButton()
            end
        end
    })
    KnifeSilenceSec:AddSlider({
        Title = "Knife Offset",
        Min = -5, Max = 5, Default = 1, Increment = 0.1,
        Callback = function(v)
            KnifeSilence.knifeOffset = math.clamp(tonumber(v) or 1, -5, 5)
        end
    })
    KnifeSilenceSec:AddSlider({
        Title = "Knife Speed",
        Min = 10, Max = 200, Default = 80, Increment = 1,
        Callback = function(v)
            KnifeSilence.knifeSpeed = math.clamp(tonumber(v) or 80, 10, 200)
        end
    })
    KnifeSilenceSec:AddSlider({
        Title = "Knife Height",
        Min = -2, Max = 4, Default = 1.5, Increment = 0.1,
        Callback = function(v)
            KnifeSilence.knifeHeight = math.clamp(tonumber(v) or 1.5, -2, 4)
        end
    })
    KnifeSilenceSec:AddToggle({
        Title = "Knife Ping Predict",
        Default = true,
        Callback = function(v)
            KnifeSilence.pingPredict = v == true
        end
    })
    KnifeSilenceSec:AddToggle({
        Title = "Knife Jump Predict",
        Default = true,
        Callback = function(v)
            KnifeSilence.jumpPredict = v == true
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
                for player in pairs(roleVariantObjects) do
                    clearRoleVariant(player)
                end
            else
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character then
                        buildRoleBoxes(player)
                    end
                end
            end
        end
    })
    RolesEspSec:AddDropdown({
        Title = "Variants",
        Values = {"Box", "Highlight", "Names", "Tracer", "Outline", "Chams", "Skeleton"},
        Options = {"Box", "Highlight", "Names", "Tracer", "Outline", "Chams", "Skeleton"},
        Default = "Box",
        Callback = function(v)
            if type(v) == "table" then
                v = v[1]
            end
            if v ~= "Highlight" and v ~= "Names" and v ~= "Tracer"
                and v ~= "Outline" and v ~= "Chams" and v ~= "Skeleton" then
                v = "Box"
            end

            roleEspVariant = v

            for player in pairs(roleBoxes) do
                clearRoleBoxes(player)
            end
            for player in pairs(roleVariantObjects) do
                clearRoleVariant(player)
            end

            if EspEnabled then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character then
                        buildRoleBoxes(player)
                    end
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


    local MiscInvisibleBarrierSec = MiscTab:AddSection("Remove invisible barrier", nil)
    MiscInvisibleBarrierSec:AddToggle({
        Title = "Remove invisible barrier",
        Default = false,
        Callback = function(v)
            SetRemoveInvisibleBarriers(v == true)
        end
    })


    local MiscInvisibleSec = MiscTab:AddSection("Invisible", nil)
    MiscInvisibleSec:AddToggle({
        Title = "Invisible",
        Default = false,
        Callback = function(v)
            invisibleFeatureEnabled = v == true
            if InvisiblePanel then
                InvisiblePanel.Visible = invisibleFeatureEnabled
            end
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
        Title = "Stop Spinning",
        Default = false,
        Callback = function(v)
            CoinOpt.spinningHidden = v == true
            if CoinOpt.spinningHidden then
                hideSpinning()
                startCoinPolling()
            else
                showSpinning()
            end
        end
    })
    MiscOptimizerSec:AddToggle({
        Title = "Delete Coins",
        Default = false,
        Callback = function(v)
            CoinOpt.coinsHidden = v == true
            if CoinOpt.coinsHidden then
                hideCoins()
                startCoinPolling()
            else
                showCoins()
            end
        end
    })

    local Misc3DRenderSec = MiscTab:AddSection("Remove 3D Rendering", nil)
    Misc3DRenderSec:AddToggle({
        Title = "Remove 3D Rendering",
        Default = false,
        Callback = function(v)
            render3dCce.Enabled = v == true
        end
    })
    Misc3DRenderSec:AddToggle({
        Title = "Delete Pets",
        Default = false,
        Callback = function(v)
            CoinOpt.petsHidden = v == true
            if CoinOpt.petsHidden then
                hidePets()
                startCoinPolling()
            else
                showPets()
            end
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
            SetRemoveInvisibleBarriers(false)

        end
    })

end

BuildUI()
print("BOLONG-HUB MM2 - DISCORD.GG/PWPGQVGXNK LOADED!")

