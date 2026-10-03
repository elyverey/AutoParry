Players = game:GetService("Players")
RunService = game:GetService("RunService")
TweenService = game:GetService("TweenService")
Workspace = game:GetService("Workspace")
UserInputService = game:GetService("UserInputService")

activeTouchInputs = {}
activeTouchCount = 0
pickupTouchBlockUntil = 0


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
    panel.BackgroundTransparency = 1
    panel.BorderSizePixel = 0
    panel.Visible = RoundTimerState.enabled
    panel.Parent = gui
    panel.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 11)
    corner.Parent = panel

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Thickness = 1
    stroke.Transparency = 1
    stroke.Parent = panel

    local label = Instance.new("TextLabel")
    label.Name = "RoundTimer"
    label.Position = UDim2.fromOffset(5, 3)
    label.Size = UDim2.new(1, -10, 0, 21)
    label.BackgroundTransparency = 1
    label.Text = "0:00"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeColor3 = Color3.fromRGB(160, 77, 15)
    label.TextStrokeTransparency = 0.55
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.ZIndex = 5
    label.Parent = panel

    local statsLabel = Instance.new("TextLabel")
    statsLabel.Name = "ClientStats"
    statsLabel.Position = UDim2.fromOffset(5, 24)
    statsLabel.Size = UDim2.new(1, -10, 0, 12)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Text = "FPS 60    Ping 0ms"
    statsLabel.TextColor3 = Color3.new(1, 1, 1)
    statsLabel.TextStrokeColor3 = Color3.fromRGB(160, 77, 15)
    statsLabel.TextStrokeTransparency = 0.65
    statsLabel.Font = Enum.Font.GothamSemibold
    statsLabel.TextSize = 10
    statsLabel.TextXAlignment = Enum.TextXAlignment.Center
    statsLabel.TextYAlignment = Enum.TextYAlignment.Center
    statsLabel.ZIndex = 5
    statsLabel.Parent = panel

    local ball = Instance.new("ImageLabel")
    ball.Name = "PhysicsBall"
    ball.Size = UDim2.fromOffset(15, 15)
    ball.Position = UDim2.fromOffset(18, 28)
    ball.AnchorPoint = Vector2.new(0.5, 0.5)
    ball.BackgroundTransparency = 1
    ball.Image = "rbxassetid://70973825117174"
    ball.ImageTransparency = 0
    ball.ScaleType = Enum.ScaleType.Fit
    ball.ZIndex = 2
    ball.Parent = panel

    local ballCorner = Instance.new("UICorner")
    ballCorner.CornerRadius = UDim.new(1, 0)
    ballCorner.Parent = ball

    local bubbleA = Instance.new("Frame")
    bubbleA.Name = "BubbleA"
    bubbleA.Size = UDim2.fromOffset(8, 8)
    bubbleA.Position = UDim2.fromOffset(126, 29)
    bubbleA.AnchorPoint = Vector2.new(0.5, 0.5)
    bubbleA.BackgroundColor3 = Color3.new(1, 1, 1)
    bubbleA.BackgroundTransparency = 0.28
    bubbleA.BorderSizePixel = 0
    bubbleA.ZIndex = 3
    bubbleA.Parent = panel

    local bubbleACorner = Instance.new("UICorner")
    bubbleACorner.CornerRadius = UDim.new(1, 0)
    bubbleACorner.Parent = bubbleA

    local bubbleB = Instance.new("Frame")
    bubbleB.Name = "BubbleB"
    bubbleB.Size = UDim2.fromOffset(7, 7)
    bubbleB.Position = UDim2.fromOffset(137, 33)
    bubbleB.AnchorPoint = Vector2.new(0.5, 0.5)
    bubbleB.BackgroundColor3 = Color3.new(1, 1, 1)
    bubbleB.BackgroundTransparency = 0.4
    bubbleB.BorderSizePixel = 0
    bubbleB.ZIndex = 3
    bubbleB.Parent = panel

    local bubbleBCorner = Instance.new("UICorner")
    bubbleBCorner.CornerRadius = UDim.new(1, 0)
    bubbleBCorner.Parent = bubbleB

    RoundTimerState.gui = gui
    RoundTimerState.panel = panel
    RoundTimerState.label = label
    RoundTimerState.statsLabel = statsLabel
    RoundTimerState.ball = ball
    RoundTimerState.bubbleA = bubbleA
    RoundTimerState.bubbleB = bubbleB
    RoundTimerState.physicsLast = time()
    RoundTimerState.ballPhysics = {
        x = 18, y = 27, vx = 54, vy = -18, radius = 7.5,
        gravity = 185, restitution = 0.82, damping = 0.996
    }
    RoundTimerState.bubblePhysics = {
        {x = 126, y = 29, vx = -9, vy = -4, radius = 4, rise = -36},
        {x = 138, y = 33, vx = -6, vy = -2, radius = 3.5, rise = -31}
    }
    RoundTimerState.fpsLast = time()

    local timerDragging = false
    local timerDragInput = nil
    local timerDragStart = nil
    local timerStartPos = nil
    panel.Active = true

    panel.InputBegan:Connect(function(input)
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
            uiPanelTouchActive = false
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
        beginRoundTimer(roundDuration, false)
    end)
end

local roundEndFadeRemote = gameplayRemotes and gameplayRemotes:FindFirstChild("RoundEndFade")
if roundEndFadeRemote and roundEndFadeRemote:IsA("RemoteEvent") then
    roundEndFadeRemote.OnClientEvent:Connect(function(isEnding)
        if isEnding == true then
            endRoundTimer()
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

        local physicsNow = time()
        local physicsDt = math.min(0.033, math.max(0.001, physicsNow - (RoundTimerState.physicsLast or physicsNow)))
        RoundTimerState.physicsLast = physicsNow

        local bp = RoundTimerState.ballPhysics
        local ball = RoundTimerState.ball
        local ba = RoundTimerState.bubbleA
        local bb = RoundTimerState.bubbleB
        local bubbles = RoundTimerState.bubblePhysics
        if bp and ball and ba and bb and bubbles then
            local left = bp.radius + 4
            local right = 146 - bp.radius
            local top = bp.radius + 2
            local bottom = 38 - bp.radius

            bp.vy = bp.vy + bp.gravity * physicsDt
            bp.vx = bp.vx * math.pow(bp.damping, physicsDt * 60)
            bp.vy = bp.vy * math.pow(bp.damping, physicsDt * 60)
            bp.x = bp.x + bp.vx * physicsDt
            bp.y = bp.y + bp.vy * physicsDt

            if bp.x < left then bp.x = left; bp.vx = math.abs(bp.vx) * bp.restitution end
            if bp.x > right then bp.x = right; bp.vx = -math.abs(bp.vx) * bp.restitution end
            if bp.y < top then bp.y = top; bp.vy = math.abs(bp.vy) * bp.restitution end
            if bp.y > bottom then
                bp.y = bottom
                bp.vy = -math.abs(bp.vy) * bp.restitution
                if math.abs(bp.vy) < 12 then bp.vy = -26 end
            end

            for i = 1, 2 do
                local b = bubbles[i]
                b.vy = b.vy + 62 * physicsDt
                b.vx = b.vx * math.pow(0.994, physicsDt * 60)
                b.vy = b.vy * math.pow(0.994, physicsDt * 60)
                b.x = b.x + b.vx * physicsDt
                b.y = b.y + b.vy * physicsDt

                local br = b.radius
                if b.x < br + 4 then b.x = br + 4; b.vx = math.abs(b.vx) * 0.76 end
                if b.x > 146 - br then b.x = 146 - br; b.vx = -math.abs(b.vx) * 0.76 end
                if b.y < br + 2 then b.y = br + 2; b.vy = math.abs(b.vy) * 0.76 end
                if b.y > 38 - br then
                    b.y = 38 - br
                    b.vy = -math.abs(b.vy) * 0.62
                    b.vy = b.vy + b.rise * 0.2
                end

                local dx = bp.x - b.x
                local dy = bp.y - b.y
                local distSq = dx * dx + dy * dy
                local minDist = bp.radius + br
                if distSq < minDist * minDist then
                    local dist = math.sqrt(math.max(distSq, 0.0001))
                    local nx = dx / dist
                    local ny = dy / dist
                    local overlap = minDist - dist
                    bp.x = bp.x + nx * overlap
                    bp.y = bp.y + ny * overlap
                    local relative = bp.vx * nx + bp.vy * ny
                    if relative < 0 then
                        bp.vx = bp.vx - relative * 1.45 * nx
                        bp.vy = bp.vy - relative * 1.45 * ny
                    end
                    bp.vy = bp.vy + b.rise * 0.9
                    b.vy = b.vy - 18
                end
            end

            ball.Visible = true
            ba.Visible = true
            bb.Visible = true
            ball.Position = UDim2.fromOffset(bp.x, bp.y)
            ba.Position = UDim2.fromOffset(bubbles[1].x, bubbles[1].y)
            bb.Position = UDim2.fromOffset(bubbles[2].x, bubbles[2].y)
        end

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
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end)
end

function PlayOpenSound()
    PlaySoundAsset(134699420140804, 1)
end

AutoShootEnabled = false
ShootKeybind = Enum.KeyCode.E
MobilePanelEnabled = false
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
            if type(playerData) == "table" and playerData.Role == "Sheriff" then
                firstGunHolderName = playerName
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
        stopFarmTween()
        farmSurfaceCFrame = nil
        farmLastCoinPosition = nil
        pcall(function()
            local newHum = character:FindFirstChildOfClass("Humanoid")
            if newHum then
                newHum.PlatformStand = false
                newHum.AutoRotate = true
                newHum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            end
        end)
        farmWaitingForRound = false
        farmMovingToSurface = false
        farmRoundStarted = false
        farmPoseApplied = false
        farmOriginalPlatformStand = nil
        autoFarmBusy = false
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
autoFarmSpeed = 6
autoFarmDelay = 1.2
autoFarmBusy = false
antiAFKEnabled = false
autoPickupGunActive = false
pickupPanelInteracting = false
uiPanelTouchActive = false
aimTouchBlockUntil = 0
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
AimbotPanelScale = 10
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
    return GetPlayerRoleMM2(player)
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

coinCache = {}
coinSet = {}

function isCoinPart(obj)
    if not obj or not obj:IsA("BasePart") then
        return false
    end

    local name = string.lower(obj.Name)
    return (name == "coin" or name == "coin_server" or name:find("coin") ~= nil)
        and name ~= "coincontainer"
end

function registerCoin(obj)
    if isCoinPart(obj) and not coinSet[obj] then
        coinSet[obj] = true
        coinCache[#coinCache + 1] = obj
    end
end

function unregisterCoin(obj)
    if not coinSet[obj] then
        return
    end

    coinSet[obj] = nil

    for i = #coinCache, 1, -1 do
        if coinCache[i] == obj then
            table.remove(coinCache, i)
            break
        end
    end
end

function collectInitialCoins(parent)
    for _, obj in ipairs(parent:GetChildren()) do
        registerCoin(obj)
        collectInitialCoins(obj)
    end
end

task.spawn(function()
    collectInitialCoins(Workspace)
end)

function getNearestCoin()
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return nil
    end

    local nearest = nil
    local nearestDistance = math.huge

    for i = #coinCache, 1, -1 do
        local obj = coinCache[i]

        if not obj or not obj.Parent or not isCoinPart(obj) or obj.Transparency >= 1 then
            unregisterCoin(obj)
        else
            local distance = (obj.Position - hrp.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearest = obj
            end
        end
    end

    return nearest
end

function teleportToPart(part)
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and part then
        hrp.CFrame = part.CFrame
        return true
    end
    return false
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
    registerCoin(obj)

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
    unregisterCoin(obj)

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

farmTween = nil
farmSurfaceCFrame = nil
farmLastCoinPosition = nil
farmCollisionOriginals = {}
farmWaitingForRound = false
farmMovingToSurface = false
farmRoundStarted = false
farmPoseApplied = false
farmOriginalPlatformStand = nil
farmOriginalClimbingEnabled = true

function setFarmNoclip(enabled)
    local char = localPlayer.Character
    if not char then return end

    if enabled then
        if noclipCharacter ~= char then
            setupNoclipCharacter(char)
        end

        farmCollisionOriginals = {}

        for i = #noclipParts, 1, -1 do
            local obj = noclipParts[i]

            if obj and obj.Parent and obj:IsA("BasePart") then
                farmCollisionOriginals[obj] = obj.CanCollide
                obj.CanCollide = false
            else
                removeNoclipPart(obj)
            end
        end
    else
        for obj, original in pairs(farmCollisionOriginals) do
            if obj and obj.Parent then
                obj.CanCollide = original
            end
        end
        farmCollisionOriginals = {}
    end
end

function stopFarmTween()
    if farmTween then
        pcall(function() farmTween:Cancel() end)
        farmTween = nil
    end
end

function getFarmHumanoid()
    local char = localPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

function makeUprightCFrame(position, lookVector)
    local flatLook = Vector3.new(lookVector.X, 0, lookVector.Z)
    if flatLook.Magnitude < 0.01 then
        flatLook = Vector3.new(0, 0, -1)
    else
        flatLook = flatLook.Unit
    end
    return CFrame.lookAt(position, position + flatLook)
end

function tweenFarmTo(cframe, watchedCoin)
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not autoFarmActive then return false end

    stopFarmTween()
    setFarmNoclip(true)

    local hum = getFarmHumanoid()
    if hum then hum.AutoRotate = false end

    local distance = (hrp.Position - cframe.Position).Magnitude
    local duration = math.clamp(distance / math.max(autoFarmSpeed * 2.5, 0.1), 0.18, 12)
    farmTween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = cframe})

    local coinLost = false
    local watchConnection
    if watchedCoin then
        watchConnection = RunService.Heartbeat:Connect(function()
            if not watchedCoin.Parent or watchedCoin.Transparency >= 1 then
                coinLost = true
                if farmTween then
                    pcall(function() farmTween:Cancel() end)
                end
            end
        end)
    end

    farmTween:Play()
    local playbackState = farmTween.Completed:Wait()

    if watchConnection then watchConnection:Disconnect() end
    farmTween = nil

    if coinLost or not autoFarmActive or not hrp.Parent then return false end
    return playbackState == Enum.PlaybackState.Completed
end

function getFarmCoinTargetCFrame(coin)
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local look = hrp and hrp.CFrame.LookVector or Vector3.new(0, 0, -1)
    local position = coin.Position

    if farmRoundStarted then
        local rayOrigin = coin.Position + Vector3.new(0, 2, 0)
        local rayDirection = Vector3.new(0, -12, 0)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {char}
        params.IgnoreWater = true

        local result = Workspace:Raycast(rayOrigin, rayDirection, params)
        local floorY = result and result.Position.Y or (coin.Position.Y - 2.5)
        position = Vector3.new(coin.Position.X, floorY - 1.5, coin.Position.Z)

        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude < 0.01 then
            flatLook = Vector3.new(0, 0, -1)
        else
            flatLook = flatLook.Unit
        end

        return CFrame.lookAt(position, position + flatLook) * CFrame.Angles(math.rad(90), 0, 0)
    end

    position = coin.Position - Vector3.new(0, 2.9, 0)
    return makeUprightCFrame(position, look)
end

function getFarmSurfaceCFrame()
    if farmSurfaceCFrame then
        local pos = farmSurfaceCFrame.Position

        if farmLastCoinPosition then
            pos = Vector3.new(
                farmLastCoinPosition.X,
                farmSurfaceCFrame.Position.Y,
                farmLastCoinPosition.Z
            )
        end

        return makeUprightCFrame(pos, farmSurfaceCFrame.LookVector)
    end

    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        farmSurfaceCFrame = makeUprightCFrame(hrp.Position, hrp.CFrame.LookVector)
        return farmSurfaceCFrame
    end
end

function enterFarmRoundPose(firstCoin)
    if farmPoseApplied then return end
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hrp or not hum then return end

    farmRoundStarted = true
    setFarmNoclip(true)
    farmOriginalPlatformStand = hum.PlatformStand
    pcall(function()
        farmOriginalClimbingEnabled = hum:GetStateEnabled(Enum.HumanoidStateType.Climbing)
        hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    end)
    hum.AutoRotate = false
    hum.PlatformStand = true
    farmPoseApplied = true

    local targetPosition = (firstCoin and firstCoin.Parent)
        and (firstCoin.Position - Vector3.new(0, 4.5, 0))
        or (hrp.Position - Vector3.new(0, 8, 0))

    local look = hrp.CFrame.LookVector
    local flatLook = Vector3.new(look.X, 0, look.Z)
    if flatLook.Magnitude < 0.01 then flatLook = Vector3.new(0, 0, -1) else flatLook = flatLook.Unit end
    hrp.CFrame = CFrame.lookAt(targetPosition, targetPosition + flatLook) * CFrame.Angles(math.rad(90), 0, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

function exitFarmRoundPose()
    if not farmPoseApplied then
        farmRoundStarted = false
        return
    end
    local hum = getFarmHumanoid()
    if hum then
        hum.PlatformStand = farmOriginalPlatformStand == true
        hum.AutoRotate = true
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, farmOriginalClimbingEnabled)
        end)
    end
    farmOriginalPlatformStand = nil
    farmPoseApplied = false
    farmRoundStarted = false
end

function startAutoFarm()
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    stopFarmTween()

    farmSurfaceCFrame = makeUprightCFrame(hrp.Position, hrp.CFrame.LookVector)
    farmLastCoinPosition = nil
    farmWaitingForRound = false
    farmMovingToSurface = false
    farmRoundStarted = false
    farmPoseApplied = false

    local hum = getFarmHumanoid()
    if hum then
        hum.AutoRotate = false
    end
end

function stopAutoFarm()
    stopFarmTween()
    exitFarmRoundPose()
    setFarmNoclip(false)

    local hum = getFarmHumanoid()
    if hum then
        local original = movementOriginals[hum]
        if original then
            hum.AutoRotate = original.AutoRotate
        else
            hum.AutoRotate = true
        end
    end

    autoFarmBusy = false
    farmWaitingForRound = false
    farmMovingToSurface = false
end

function farmToCoin(coin)
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not coin or not coin.Parent or not autoFarmActive then return false end

    if not farmRoundStarted then enterFarmRoundPose(coin) else setFarmNoclip(true) end

    autoFarmBusy = true
    farmWaitingForRound = false
    farmMovingToSurface = false
    farmLastCoinPosition = coin.Position

    local reached = tweenFarmTo(getFarmCoinTargetCFrame(coin), coin)
    if not reached or not autoFarmActive then
        autoFarmBusy = false
        return false
    end

    local hum = getFarmHumanoid()
    if hum then
        hum.AutoRotate = false
        hum.PlatformStand = true
    end

    task.wait(0.18)
    if not coin.Parent or coin.Transparency >= 1 then
        autoFarmBusy = false
        return false
    end

    local deadline = os.clock() + 0.8
    while autoFarmActive and coin.Parent and coin.Transparency < 1 and os.clock() < deadline do
        task.wait(0.05)
    end

    if not autoFarmActive then
        autoFarmBusy = false
        return false
    end

    if not coin.Parent or coin.Transparency >= 1 then
        autoFarmBusy = false
        return false
    end

    task.wait(math.clamp(autoFarmDelay, 0.8, 3))
    autoFarmBusy = false
    return true
end

task.spawn(function()
    while task.wait(0.12) do
        if autoFarmActive and not autoFarmBusy then
            local coin = getNearestCoin()

            if coin then
                farmToCoin(coin)
            else
                if farmRoundStarted and not farmWaitingForRound then
                    farmWaitingForRound = true
                    local surface = getFarmSurfaceCFrame()
                    if surface then
                        autoFarmBusy = true
                        farmMovingToSurface = true
                        exitFarmRoundPose()
                        local oldNoclip = noclipEnabled
                        tweenFarmTo(surface)
                        setFarmNoclip(false)
                        farmMovingToSurface = false
                        autoFarmBusy = false
                        if oldNoclip then SetNoclip(true) end
                    else
                        exitFarmRoundPose()
                    end
                else
                    setFarmNoclip(false)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.40) do
        local char = localPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local isMoving = humanoid and humanoid.MoveDirection.Magnitude > 0.05
        local uiBlocked = pickupPanelInteracting or uiPanelTouchActive
        local touchBlocked = activeTouchCount > 0 or os.clock() < pickupTouchBlockUntil

        if autoPickupGunActive and not uiBlocked and not touchBlocked and not isMoving then
            local part = getGunDrop()
            if part then
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local old = hrp.CFrame
                    hrp.CFrame = part.CFrame
                    task.wait(0.2)
                    if hrp.Parent then
                        hrp.CFrame = old
                    end
                end
            end
        end
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
        if p ~= localPlayer and getRole(p) == "Murderer" and p.Character then
            local character = p.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")

            if humanoid and humanoid.Health > 0 and root then
                local worldDistance = localRoot and (root.Position - localRoot.Position).Magnitude or math.huge
                if worldDistance <= 120 then
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(root.Position)
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
    end

    if closestTarget then
        aimlockLockedPlayer = closestTarget
        local character = closestTarget.Character
        aimlockLockedHead = character and character:FindFirstChild("HumanoidRootPart") or nil
        aimlockLockedHumanoid = character and character:FindFirstChildOfClass("Humanoid") or nil
    end
end

RunService.Heartbeat:Connect(function()
    if not aimbotActive or not aimlockEngaged then
        return
    end

    if uiPanelTouchActive or hasMultipleTouches() or os.clock() < aimTouchBlockUntil then
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

    aimlockLockedHead = root
    aimlockLockedHumanoid = humanoid

    local cameraPosition = Camera.CFrame.Position
    Camera.CFrame = CFrame.lookAt(cameraPosition, root.Position)
end)


function getMurdererTargetPart()
    if not roleRoundActive then
        return nil, nil
    end

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

                if distance <= 250 then
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
AUTO_SHOOT_MIN_LEAD = 0.004
AUTO_SHOOT_MAX_LEAD = 0.18
autoShootMotion = {}
autoShootMotionAccumulator = 0
AUTO_SHOOT_MAX_ACCELERATION = 520
AUTO_SHOOT_PING_LEAD = 0.085
AUTO_SHOOT_DIRECTION_BLEND = 1
AUTO_SHOOT_MAX_DISTANCE = 350
AUTO_SHOOT_UPDATE_RATE = 0.025
AUTO_SHOOT_TARGET_SWITCH_MARGIN = 2.5

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
                    autoShootMotion[player] = {
                        position = root.Position,
                        time = now,
                        velocity = root.AssemblyLinearVelocity,
                        acceleration = Vector3.zero,
                        speed = root.AssemblyLinearVelocity.Magnitude,
                    }
                else
                    local dt = now - state.time
                    if dt > 0.005 and dt < 0.20 then
                        local measuredVelocity = (root.Position - state.position) / dt
                        local assemblyVelocity = root.AssemblyLinearVelocity
                        local blendedVelocity = measuredVelocity:Lerp(assemblyVelocity, 0.48)
                        local measuredAcceleration = (blendedVelocity - state.velocity) / dt
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
    local currentPosition = bodyCFrame.Position
    local rootPosition = root.Position
    local centerOffset = currentPosition - rootPosition
    if centerOffset.Magnitude > 4 then
        currentPosition = rootPosition
    end

    local velocity = root.AssemblyLinearVelocity
    local acceleration = Vector3.zero
    local player = Players:GetPlayerFromCharacter(character)
    local motion = player and autoShootMotion[player]

    if motion then
        velocity = motion.velocity:Lerp(velocity, 0.22)
        acceleration = motion.acceleration
    end

    local halfHeight = math.max((bodySize and bodySize.Y or 2) * 0.5, 0.18)
    local verticalCenterOffset = math.clamp(currentPosition.Y - rootPosition.Y, -halfHeight, halfHeight)
    currentPosition = Vector3.new(currentPosition.X, rootPosition.Y + verticalCenterOffset, currentPosition.Z)

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

    for _ = 1, 14 do
        local future = currentPosition
            + velocity * leadTime
            + acceleration * (0.5 * leadTime * leadTime)
        local nextDistance = (future - origin).Magnitude
        local nextLead = math.clamp(
            nextDistance / speed + ping * AUTO_SHOOT_PING_LEAD,
            AUTO_SHOOT_MIN_LEAD,
            AUTO_SHOOT_MAX_LEAD
        )
        if math.abs(nextLead - leadTime) < 0.00035 then
            leadTime = nextLead
            break
        end
        leadTime = leadTime * 0.35 + nextLead * 0.65
    end

    local predicted = currentPosition
        + velocity * leadTime
        + acceleration * (0.5 * leadTime * leadTime)

    local horizontal = Vector3.new(
        predicted.X - currentPosition.X,
        0,
        predicted.Z - currentPosition.Z
    )
    local verticalDelta = math.clamp(
        predicted.Y - currentPosition.Y,
        -0.85,
        0.65
    )

    predicted = currentPosition
        + horizontal
        + Vector3.new(0, verticalDelta, 0)

    return currentPosition:Lerp(predicted, AUTO_SHOOT_DIRECTION_BLEND)
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
                if distance <= AUTO_SHOOT_MAX_DISTANCE then
                    local score = distance
                    if part == upper then
                        score = score - 3
                    elseif part == root then
                        score = score - 1.5
                    elseif part == head then
                        score = score + 2
                    end
                    if score < bestScore then
                        bestScore = score
                        bestPoint = predicted
                    end
                end
            end
        end
    end

    return bestPoint
end

function getMurdererTargetPart()
    if not roleRoundActive then
        return nil, nil
    end

    local localChar = localPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then
        return nil, nil
    end

    local bestPlayer = nil
    local bestPart = nil
    local bestScore = math.huge
    local cameraPosition = Camera.CFrame.Position
    local cameraLook = Camera.CFrame.LookVector

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and getRole(player) == "Murderer" then
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")

            if root and humanoid and humanoid.Health > 0 then
                local distance = (root.Position - localRoot.Position).Magnitude
                if distance <= AUTO_SHOOT_MAX_DISTANCE then
                    local offset = root.Position - cameraPosition
                    local anglePenalty = 0
                    if offset.Magnitude > 0.01 then
                        local facingDot = math.clamp(cameraLook:Dot(offset.Unit), -1, 1)
                        anglePenalty = (1 - facingDot) * 8
                    end

                    local motion = autoShootMotion[player]
                    local speedPenalty = 0
                    if motion then
                        speedPenalty = math.min(motion.speed or 0, 24) * 0.035
                    end

                    local score = distance + anglePenalty + speedPenalty

                    if score < bestScore then
                        bestScore = score
                        bestPlayer = player
                        bestPart = root
                    end
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

function playGunShotSound(gun)
    if not gun then return end
    local candidates = {}
    for _, obj in ipairs(gun:GetChildren()) do
        if obj:IsA("Sound") then
            table.insert(candidates, obj)
        end
    end
    local handle = gun:FindFirstChild("Handle")
    if handle then
        for _, obj in ipairs(handle:GetChildren()) do
            if obj:IsA("Sound") then
                table.insert(candidates, obj)
            end
        end
    end
    for _, sound in ipairs(candidates) do
        local n = string.lower(sound.Name)
        if n:find("shoot") or n:find("fire") or n:find("shot") or n:find("gun") then
            pcall(function()
                sound:Play()
            end)
            return
        end
    end
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
        playGunShotSound(gun)
        playGunFiredVisual(handle, origin, targetPosition, targetPart)
    end

    return ok
end

function autoShoot()
    if not AutoShootEnabled or uiPanelTouchActive or hasMultipleTouches() then
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
    fireShotAtTarget(equippedGun, targetPart)
end


MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "BolongFrutigerPanel"
MobileGui.ResetOnSpawn = false
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
        uiPanelTouchActive = false
        PanelStroke.Thickness = 2

        if not dragMoved and os.clock() - touchStartTime < .4 then
            PlaySoundAsset(77120543307812, 1)
            if AutoShootEnabled then
                autoShoot()
            else

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
AimbotPanel.Size = UDim2.fromOffset(100, 100)
AimbotPanel.Visible = false
AimbotPanel.Active = true
AimbotPanel.Parent = AimbotGui

AimbotCorner = Instance.new("UICorner")
AimbotCorner.CornerRadius = UDim.new(0, 14)
AimbotCorner.Parent = AimbotPanel

AimbotStroke = Instance.new("UIStroke")
AimbotStroke.Color = Color3.fromRGB(0, 170, 255)
AimbotStroke.Thickness = 2
AimbotStroke.Transparency = 0.15
AimbotStroke.Parent = AimbotPanel

AimbotLabel = Instance.new("TextLabel")
AimbotLabel.AnchorPoint = Vector2.new(0.5, 0.5)
AimbotLabel.Position = UDim2.fromScale(0.5, 0.5)
AimbotLabel.Size = UDim2.fromScale(0.9, 0.9)
AimbotLabel.BackgroundTransparency = 1
AimbotLabel.Text = "AIMLOCK"
AimbotLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotLabel.TextSize = 20
AimbotLabel.TextScaled = false
AimbotLabel.TextWrapped = true
AimbotLabel.Font = Enum.Font.GothamBold
AimbotLabel.TextXAlignment = Enum.TextXAlignment.Center
AimbotLabel.TextYAlignment = Enum.TextYAlignment.Center
AimbotLabel.Parent = AimbotPanel

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
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        if input.UserInputType == Enum.UserInputType.Touch and hasMultipleTouches() then
            return
        end
        uiPanelTouchActive = true
        pickupTouchBlockUntil = os.clock() + 0.75
        aimTouchBlockUntil = os.clock() + 0.75
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
    if aimDragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
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
        uiPanelTouchActive = false
        pickupTouchBlockUntil = os.clock() + 0.75
        aimTouchBlockUntil = os.clock() + 0.75
        AimbotStroke.Thickness = 2

        if not aimWasDragged and aimPressStart and not hasMultipleTouches() then
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
    AimbotPanelScale = math.clamp(tonumber(value) or 10, 7, 20)

    local diameter = AimbotPanelScale * 10
    AimbotPanel.Size = UDim2.fromOffset(diameter, diameter)

    AimbotLabel.Size = UDim2.fromScale(0.9, 0.9)
    AimbotLabel.TextSize = math.clamp(AimbotPanelScale * 1.45, 14, 30)
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



function SkidFling(TargetPlayer)
    if not TargetPlayer or not TargetPlayer.Character then return end

    local Character = localPlayer and localPlayer.Character
    local Humanoid = Character and (Character:FindFirstChildOfClass("Humanoid") or Character:FindFirstChild("Humanoid"))
    local RootPart = Character and (Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart)

    local TCharacter = TargetPlayer and TargetPlayer.Character
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle

    if TCharacter and TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid then
        TRootPart = TCharacter:FindFirstChild("HumanoidRootPart") or TCharacter.PrimaryPart or THumanoid.RootPart
    end
    if TCharacter and TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter and TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessory and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        
        local CurrentCam = workspace.CurrentCamera
        if THead then
            CurrentCam.CameraSubject = THead
        elseif not THead and Handle then
            CurrentCam.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            CurrentCam.CameraSubject = THumanoid
        end
        if not (TCharacter and TCharacter:FindFirstChildWhichIsA("BasePart")) then
            return
        end
        
        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            pcall(function()
                if Character and Character.PrimaryPart then
                    Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                end
            end)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        
        local SFBasePart = function(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart and TRootPart.Velocity.Magnitude / 1.25 or 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -(TRootPart and TRootPart.Velocity.Magnitude / 1.25 or 0)), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart and TRootPart.Velocity.Magnitude / 1.25 or 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or TargetPlayer.Character ~= TCharacter or (THumanoid and THumanoid.Sit) or (Humanoid and Humanoid.Health <= 0) or tick() > Time + TimeToWait
        end
        
        if not getgenv().FPDH then
             getgenv().FPDH = workspace.FallenPartsDestroyHeight
        end

        workspace.FallenPartsDestroyHeight = 0/0
        
        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        end
        
        if BV and BV.Parent then BV:Destroy() end
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid
        
        repeat
            if getgenv().OldPos then
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                pcall(function()
                    if Character and Character.PrimaryPart then
                        Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                    end
                end)
            end
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            for _, x in ipairs(Character:GetChildren()) do
                if x:IsA("BasePart") then
                    x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                end
            end
            task.wait()
        until not getgenv().OldPos or (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
        
        if getgenv().FPDH then
            workspace.FallenPartsDestroyHeight = getgenv().FPDH
        end
    end
end

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
PickupLabel.Parent = PickupPanel

pickupDragging, pickupDragInput, pickupDragStart, pickupStartPos = false, nil, nil, nil
PickupPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        pickupPanelInteracting = true
        uiPanelTouchActive = true
        pickupTouchBlockUntil = os.clock() + 0.75
        pickupDragging = true
        pickupDragInput = input
        pickupDragStart = input.Position
        pickupStartPos = PickupPanel.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if pickupDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - pickupDragStart
        PickupPanel.Position = UDim2.new(
            pickupStartPos.X.Scale, pickupStartPos.X.Offset + delta.X,
            pickupStartPos.Y.Scale, pickupStartPos.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if pickupDragging and input == pickupDragInput then
        pickupDragging = false
        pickupPanelInteracting = false
        uiPanelTouchActive = false
        pickupTouchBlockUntil = os.clock() + 0.75
        pickupDragInput = nil
    end
end)

function UpdatePickupPanelScale(value)
    local scale = math.clamp(tonumber(value) or 10, 5, 20)
    local diameter = math.clamp(scale * 5.5, 40, 110)
    PickupPanel.Size = UDim2.fromOffset(diameter, diameter)
    PickupLabel.TextSize = math.clamp(scale * 0.8, 7, 16)
end
UpdatePickupPanelScale(10)


autoThrowKnifeEnabled = false
autoThrowCycle = 0
AUTO_THROW_FOV_DOT = 0.75
AUTO_THROW_INTERVAL = 0.7

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
    local velocity = targetPart.AssemblyLinearVelocity
    local horizontalVelocity = Vector3.new(velocity.X, 0, velocity.Z)
    local distance = (targetPosition - originPart.Position).Magnitude
    local leadTime = math.clamp(distance / 900, 0.025, 0.12)
    local predictedPosition = targetPosition + horizontalVelocity * leadTime

    local throwCFrame = CFrame.lookAt(originPart.Position, predictedPosition)
    local targetCFrame = CFrame.new(predictedPosition)

    local ok = pcall(function()
        event:FireServer(
            throwCFrame,
            targetCFrame
        )
    end)

    return ok
end

function disableAutoThrowKnife()
    autoThrowKnifeEnabled = false
    autoThrowCycle = autoThrowCycle + 1
end

function enableAutoThrowKnife()
    disableAutoThrowKnife()
    autoThrowKnifeEnabled = true
    autoThrowCycle = autoThrowCycle + 1
    local cycle = autoThrowCycle

    task.spawn(function()
        while autoThrowKnifeEnabled and cycle == autoThrowCycle do
            local target = getAutoThrowSilentTarget()
            if target then
                fireKnifeThrowAtTarget(target)
                task.wait(AUTO_THROW_INTERVAL)
            else
                task.wait(0.08)
            end
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
        FakeBombJumpLabel.TextSize = math.clamp(math.floor(size * 0.16), 12, 24)
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
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.ZIndex = 3
    label.Parent = panel

    FakeBombJumpPanel = panel
    FakeBombJumpLabel = label

    panel.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        uiPanelTouchActive = true
        pickupTouchBlockUntil = os.clock() + 0.75
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
        uiPanelTouchActive = false
        pickupTouchBlockUntil = os.clock() + 0.75
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

local CollapsibleSections = {}

function RegisterCollapsibleSection(section)
    if section then
        table.insert(CollapsibleSections, section)
    end
    return section
end

function CloseSectionAtStartup(section)
    if not section then
        return false
    end

    local directMethods = {
        {"SetOpen", false},
        {"SetExpanded", false},
        {"SetCollapsed", true},
        {"Collapse", nil},
        {"Close", nil}
    }

    for _, info in ipairs(directMethods) do
        local name = info[1]
        local value = info[2]
        local okGet, method = pcall(function()
            return section[name]
        end)
        if okGet and type(method) == "function" then
            local okCall = pcall(function()
                if value == nil then
                    method(section)
                else
                    method(section, value)
                end
            end)
            if okCall then
                return true
            end
        end
    end

    local okToggleGet, toggleMethod = pcall(function()
        return section.Toggle
    end)
    if okToggleGet and type(toggleMethod) == "function" then
        local okToggle = pcall(function()
            toggleMethod(section)
        end)
        if okToggle then
            return true
        end
    end

    return false
end

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

    local InfoSec = InfoTab:AddSection("Info", nil)
    InfoSec:AddParagraph({
        Title = "Yo rill add your discord profile or something you want here",
        Content = "discord.gg/pWpgqVGxNK"
    })

    local MovementSec = RegisterCollapsibleSection(MainTab:AddSection("Movement & Physics", true))
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

    local UtilitySec = RegisterCollapsibleSection(MainTab:AddSection("Utilities", true))
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

    local AutoFarmSec = AutoFarmTab:AddSection("Features", nil)
    AutoFarmSec:AddToggle({
        Title = "Auto Farm",
        Default = false,
        Callback = function(v)
            autoFarmActive = v == true
            if autoFarmActive then
                startAutoFarm()
            else
                stopAutoFarm()
            end
        end
    })
    AutoFarmSec:AddSlider({
        Title = "Between",
        Min = 3, Max = 20, Default = 6, Increment = 1,
        Callback = function(v)
            autoFarmSpeed = math.clamp(tonumber(v) or 6, 3, 20)
        end
    })
    AutoFarmSec:AddSlider({
        Title = "Delay",
        Min = 0.8, Max = 3, Default = 1.2, Increment = 0.1,
        Callback = function(v)
            autoFarmDelay = math.clamp(tonumber(v) or 1.2, 0.8, 3)
        end
    })
    AutoFarmSec:AddToggle({
        Title = "Anti AFK",
        Default = false,
        Callback = function(v)
            antiAFKEnabled = v == true
        end
    })


    local AutoShootSec = RegisterCollapsibleSection(CombatTab:AddSection("Auto Shoot", true))
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
        Min = 5, Max = 20, Default = 10, Increment = 1,
        Callback = function(v)
            UpdatePanelScale(v)
        end
    })

    local AimlockSec = RegisterCollapsibleSection(CombatTab:AddSection("Aimlock", true))
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
        Title = "Aimlock Panel Size",
        Min = 7, Max = 20, Default = 10, Increment = 1,
        Callback = function(v)
            UpdateAimbotPanelScale(v)
        end
    })

    local AutoPickupSec = RegisterCollapsibleSection(CombatTab:AddSection("Auto Pick Up Gun", true))
    AutoPickupSec:AddToggle({
        Title = "Auto Pick Up Gun",
        Default = false,
        Callback = function(v)
            autoPickupGunActive = v == true
            PickupPanel.Visible = v == true
        end
    })
    AutoPickupSec:AddSlider({
        Title = "Auto Pick Up Gun Panel Size",
        Min = 5, Max = 20, Default = 10, Increment = 1,
        Callback = function(v)
            UpdatePickupPanelScale(v)
        end
    })

    local FakeBombSec = RegisterCollapsibleSection(CombatTab:AddSection("Fake Bomb Jump", true))
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

    local MurdererKillSec = RegisterCollapsibleSection(MurdererTab:AddSection("Murderer Kill section", true))
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

    local ThrowingKnifeSec = RegisterCollapsibleSection(MurdererTab:AddSection("Auto Throwing Knife", true))
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

    local RolesEspSec = RegisterCollapsibleSection(VisualsTab:AddSection("Roles ESP", true))
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

    local DroppedGunCharmSec = RegisterCollapsibleSection(VisualsTab:AddSection("Gun Dropped Charm", true))
    DroppedGunCharmSec:AddToggle({
        Title = "ESP Dropped Gun",
        Default = false,
        Callback = function(v)
            droppedGunEspEnabled = v == true
            updateDroppedGunESP()
        end
    })

    local DroppedGunNameSec = RegisterCollapsibleSection(VisualsTab:AddSection("Gun Dropped Name", true))
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

    local RoundTimerSec = RegisterCollapsibleSection(VisualsTab:AddSection("Show rounds timer", true))
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

    local MiscFlingSec = RegisterCollapsibleSection(MiscTab:AddSection("Anti Fling / Fling", true))
    MiscFlingSec:AddToggle({
        Title = "Anti Fling",
        Default = false,
        Callback = function(v) SetAntiFling(v == true) end
    })
    MiscFlingSec:AddButton({
        Title = "Fling Random Player",
        Callback = function()
            local players = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then table.insert(players, player) end
            end
            if #players > 0 then SkidFling(players[math.random(1, #players)]) end
        end
    })
    MiscFlingSec:AddButton({
        Title = "Fling All Players",
        Callback = function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    task.spawn(function() SkidFling(player) end)
                end
            end
        end
    })

    local MiscEmoteSec = RegisterCollapsibleSection(MiscTab:AddSection("Emotes", true))
    for _, emoteName in ipairs({"sit", "zombie", "ninja", "zen", "floss", "dab"}) do
        MiscEmoteSec:AddButton({
            Title = "Emote: " .. emoteName:gsub("^%l", string.upper),
            Callback = function() PlayMiscEmote(emoteName) end
        })
    end

    local SettingsSec = RegisterCollapsibleSection(SettingsTab:AddSection("Settings", true))
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

    task.defer(function()
        for _, section in ipairs(CollapsibleSections) do
            CloseSectionAtStartup(section)
        end
    end)
end

BuildUI()
print("BOLONG-HUB MM2 - DISCORD.GG/PWPGQVGXNK LOADED!")

