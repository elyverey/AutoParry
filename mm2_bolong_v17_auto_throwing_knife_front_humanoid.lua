Players = game:GetService("Players")
RunService = game:GetService("RunService")
TweenService = game:GetService("TweenService")
Workspace = game:GetService("Workspace")
UserInputService = game:GetService("UserInputService")

-- Mobile multi-touch guard:
-- When more than one finger is active, don't let Aimlock or Auto Pickup
-- fight with the player's camera/movement touch.
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
    -- GetTouches() reflects the current live touch state, so the guard
    -- also works when a second finger begins after the first is already held.
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

-- Round timer: use server-synchronized time so FPS drops/client lag do not slow the countdown.
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
    panel.BackgroundColor3 = Color3.fromRGB(245, 151, 54)
    panel.BackgroundTransparency = 0.77
    panel.BorderSizePixel = 0
    panel.Visible = RoundTimerState.enabled
    panel.Parent = gui
    panel.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 11)
    corner.Parent = panel

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 225, 176)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.12
    stroke.Parent = panel

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 178, 76)),
        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(247, 151, 48)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(225, 119, 32)),
    })
    gradient.Parent = panel

    local highlight = Instance.new("Frame")
    highlight.Name = "Highlight"
    highlight.Position = UDim2.fromOffset(8, 4)
    highlight.Size = UDim2.new(1, -16, 0, 4)
    highlight.BackgroundColor3 = Color3.fromRGB(255, 244, 219)
    highlight.BackgroundTransparency = 0.55
    highlight.BorderSizePixel = 0
    highlight.Parent = panel

    local highlightCorner = Instance.new("UICorner")
    highlightCorner.CornerRadius = UDim.new(1, 0)
    highlightCorner.Parent = highlight

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
    statsLabel.Parent = panel

    RoundTimerState.gui = gui
    RoundTimerState.panel = panel
    RoundTimerState.label = label
    RoundTimerState.statsLabel = statsLabel
    RoundTimerState.fpsLast = time()

    -- Dragging the timer only moves the UI panel. It never changes the character.
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
limbEspEnabled = false

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

        -- A Fade payload is the authoritative role snapshot for the new round.
        roleCache = {}
        roleCacheByUserId = {}
        roleRoundActive = true
        firstGunHolderName = nil

        for playerName, playerData in pairs(roundPlayers) do
            setCachedRole(playerName, playerData)
            if type(playerData) == "table" and playerData.Role == "Sheriff" then
                firstGunHolderName = playerName
            end
        end

        -- If this script starts during an active round and RoundStart was already
        -- fired, do not guess the elapsed time. Show 00:00 until the next RoundStart.
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

        -- Do not rebuild the adornments. Only recolor the existing ones.
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

    -- Before the current round role snapshot arrives, keep ESP neutral.
    -- Never guess Innocent during lobby/waiting state.
    return "Lobby"
end

TargetLimbNames = {
    -- R6: one block for each arm/leg.
    {Name="Head",Size=Vector3.new(1.25,1.25,1.25)},
    {Name="Torso",Size=Vector3.new(2.1,2.1,1.1)},
    {Name="Left Arm",Size=Vector3.new(1.1,2.1,1.1)},
    {Name="Right Arm",Size=Vector3.new(1.1,2.1,1.1)},
    {Name="Left Leg",Size=Vector3.new(1.1,2.1,1.1)},
    {Name="Right Leg",Size=Vector3.new(1.1,2.1,1.1)},

    -- R15: two blocks per arm/leg plus one block per foot.
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

function ClearESP(character)
    local folder = character and character:FindFirstChild("BolongLimbESPFolder")
    if folder then folder:Destroy() end
end

function Create3DLimbESP(character)
    if not character then return end
    ClearESP(character)

    local folder = Instance.new("Folder")
    folder.Name = "BolongLimbESPFolder"
    folder.Parent = character

    local footBlock = Instance.new("Part")
    footBlock.Name = "BolongFootESPBlock"
    footBlock.Size = Vector3.new(2.4, 0.35, 1.6)
    footBlock.Transparency = 1
    footBlock.CanCollide = false
    footBlock.CanTouch = false
    footBlock.CanQuery = false
    footBlock.Anchored = false
    footBlock.Massless = true
    footBlock.Parent = folder

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        footBlock.CFrame = hrp.CFrame * CFrame.new(0, -3.05, 0)
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = hrp
        weld.Part1 = footBlock
        weld.Parent = footBlock
    end

    local footBox = Instance.new("BoxHandleAdornment")
    footBox.Name = "FootBlock"
    footBox.Adornee = footBlock
    footBox.Size = footBlock.Size
    footBox.Color3 = RoleColors.Lobby
    footBox.Transparency = EspTransparency
    footBox.AlwaysOnTop = true
    footBox.ZIndex = 10
    footBox.Visible = false
    footBox.Parent = folder

    for _, limbData in ipairs(TargetLimbNames) do
        local part = character:FindFirstChild(limbData.Name)
        if part and part:IsA("BasePart") then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "3DBlock" .. limbData.Name
            box.Adornee = part
            box.Size = limbData.Size
            box.Color3 = RoleColors.Lobby
            box.Transparency = EspTransparency
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Visible = false
            box.Parent = folder
        end
    end

    -- R15 hands: one box on each side when the hand parts exist.
    for _, handName in ipairs({"LeftHand", "RightHand"}) do
        local hand = character:FindFirstChild(handName)
        if hand and hand:IsA("BasePart") then
            local handBox = Instance.new("BoxHandleAdornment")
            handBox.Name = "3DBlock" .. handName
            handBox.Adornee = hand
            handBox.Size = Vector3.new(1, 0.8, 1)
            handBox.Color3 = RoleColors.Lobby
            handBox.Transparency = EspTransparency
            handBox.AlwaysOnTop = true
            handBox.ZIndex = 10
            handBox.Visible = false
            handBox.Parent = folder
        end
    end
end

function SetupPlayerESP(player)
    if player == localPlayer then return end

    local function onCharAdded(character)
        character:WaitForChild("HumanoidRootPart", 5)
        task.wait(0.3)
        Create3DLimbESP(character)

        local refreshQueued = false
        character.ChildAdded:Connect(function()
            if refreshQueued then return end
            refreshQueued = true
            task.delay(0.25, function()
                refreshQueued = false
                if character.Parent then
                    Create3DLimbESP(character)
                end
            end)
        end)
    end

    if player.Character then onCharAdded(player.Character) end
    player.CharacterAdded:Connect(onCharAdded)
end

for _, p in ipairs(Players:GetPlayers()) do SetupPlayerESP(p) end
Players.PlayerAdded:Connect(SetupPlayerESP)

function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local character = player.Character
            local folder = character:FindFirstChild("BolongLimbESPFolder")

            if limbEspEnabled then
                if not folder then
                    Create3DLimbESP(character)
                    folder = character:FindFirstChild("BolongLimbESPFolder")
                end

                if folder then
                    local color = RoleColors[GetPlayerRoleMM2(player)] or RoleColors.Lobby
                    for _, box in ipairs(folder:GetChildren()) do
                        if box:IsA("BoxHandleAdornment") then
                            box.Color3 = color
                            box.Transparency = EspTransparency
                            box.Visible = true
                        end
                    end
                end
            elseif folder then
                for _, box in ipairs(folder:GetChildren()) do
                    if box:IsA("BoxHandleAdornment") then box.Visible = false end
                end
            end
        end
    end
end

currentSpeed = 16
currentJump = 50
currentGravity = workspace.Gravity
infJumpEnabled = false
noclipEnabled = false
speedOverrideApplied = false
jumpOverrideApplied = false
-- Movement / physics state
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

    -- Leave WalkSpeed untouched at the default so game powers such as Sprint work.
    if currentSpeed ~= 16 then
        hum.WalkSpeed = currentSpeed
        speedOverrideApplied = true
    elseif speedOverrideApplied then
        restoreWalkSpeed(hum)
        speedOverrideApplied = false
    end

    -- Only restore JumpPower if this UI previously overrode it.
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
noclipDescAddedConnection = nil
noclipDescRemovingConnection = nil
noclipCharacter = nil

function removeNoclipPart(part)
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

        if NoclipEnabled then
            obj.CanCollide = false
        end
    end
end

function clearNoclipPartCache()
    table.clear(noclipParts)
    table.clear(noclipPartSet)
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

    -- One-time recursive GetChildren traversal for a new character.
    -- After that, the part cache is maintained by events.
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
            obj.CanCollide = NoclipEnabled and false or true
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

setupNoclipCharacter(localPlayer.Character)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled or infJumpEnabled then
        local hum = getHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

localPlayer.CharacterAdded:Connect(function(character)
    setupNoclipCharacter(character)

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

    -- New character gets its own clean baseline, while selected slider
    -- values remain unchanged and are reapplied after the character loads.
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
            ApplyMovement()
            ApplyNoclip()
        end
    end)
end)

task.spawn(function()
    while task.wait(0.12) do
        if EspEnabled or limbEspEnabled then
            UpdateESP()
        end
        if currentSpeed ~= 16 or currentJump ~= 50 or currentGravity ~= 196.2 then
            ApplyMovement()
        end
        if noclipEnabled then
            ApplyNoclip()
        end
    end
end)

-- =========================================================
-- BOLONG-HUB MM2 LAYOUT
-- Auto Shoot uses the supplied Shoot.lua FireServer pattern.
-- =========================================================

Camera = workspace.CurrentCamera

viewEnabled = false
selectedViewPlayer = localPlayer.Name

autoFarmActive = false
autoFarmSpeed = 6
autoFarmDelay = 1.2
autoFarmBusy = false
antiAFKEnabled = false
discordWebhook = ""
autoPickupGunActive = false
pickupPanelInteracting = false
uiPanelTouchActive = false
VirtualUser = game:GetService("VirtualUser")

fakeBombJumpEnabled = false
fakeBombMouseLockActive = false
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
AimbotPanelScale = 20
aimbotFOVVisible = false
autoShootActive = false
killAuraActive = false
killAuraDistance = 15
AutoShootEnabled = false
ShootKeybind = Enum.KeyCode.E
MobilePanelEnabled = false
PanelScale = 15
limbEspEnabled = false
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
    -- Fade is authoritative. If it already arrived, never overwrite its snapshot.
    if roleRoundActive then
        return
    end
    -- This fallback is only for scripts started after Fade already fired.
    -- It runs once, never every frame, and does not use deep hierarchy scans.
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

    -- Recovery is allowed to activate Role ESP only when an actual role was found.
    roleRoundActive = foundAnyRole

    -- If the script was injected after RoundStart, the original event cannot be replayed.
    -- Do not guess the remaining time. Show 00:00 until the next RoundStart event.
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

-- If the script was started during an active round, Fade may already have fired.
-- Wait briefly for character/backpack objects, then perform exactly one recovery pass.
task.delay(0.35, recoverCurrentRoundRolesOnce)

function refreshGunHolderRole(player)
    if not player or player == localPlayer or not player.Parent then return end
    local gun = getToolByName(player, "Gun")
    if not gun then return end

    if not firstGunHolderName then
        firstGunHolderName = player.Name
    end

    local role = (firstGunHolderName == player.Name) and "Sheriff" or "Hero"
    roleCache[player.Name] = role
    roleCacheByUserId[tonumber(player.UserId)] = role
    roleRoundActive = true
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

-- One-time recursive GetChildren traversal replaces the old full hierarchy scan.
-- DescendantAdded/Removing keeps the cache current after initialization.
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

-- Movement / physics
RunService.Stepped:Connect(function()
    local char = localPlayer.Character
    if char and noclipEnabled then
        ApplyNoclip()
    end

    -- Gravity uses 196.2 as the UI "off/reset" value.
    -- When reset, restore the gravity captured before the hub changed it.
    if currentGravity ~= 196.2 then
        workspace.Gravity = currentGravity
    else
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

-- View player
RunService.RenderStepped:Connect(function()
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

-- Role ESP: 3D transparent boxes on the six body areas.
-- No Highlight / Chams / Outline.
roleBoxes = {}

ROLE_PART_NAMES = {
    "Head",
    "UpperTorso", "Torso",
    "LeftUpperArm", "LeftLowerArm", "LeftHand", "Left Arm",
    "RightUpperArm", "RightLowerArm", "RightHand", "Right Arm",
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg",
    "RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg",
}

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

    for _, part in ipairs(getRoleParts(character)) do
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "BolongRolePartBox"
        box.Adornee = part
        box.Size = part.Size
        box.Color3 = roleColor
        box.Transparency = 0.65
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Visible = roleRoundActive and (GetPlayerRoleMM2(player) ~= "Lobby")
        box.Parent = part
        table.insert(boxes, box)
    end

    roleBoxes[player] = boxes
end

task.spawn(function()
    while task.wait(0.5) do
        if not EspEnabled then
            for player, boxes in pairs(roleBoxes) do
                if boxes then
                    for _, box in ipairs(boxes) do
                        if box and box.Parent then
                            box.Visible = false
                        end
                    end
                end
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local parts = getRoleParts(player.Character)
                    local boxes = roleBoxes[player]

                    if not boxes or #boxes ~= #parts then
                        buildRoleBoxes(player)
                        boxes = roleBoxes[player]
                    end

                    local role = GetPlayerRoleMM2(player)
                    local hasActiveRole = roleRoundActive and (role == "Murderer" or role == "Sheriff" or role == "Hero" or role == "Innocent")
                    local color = getRoleColor(role)
                    if boxes then
                        for _, box in ipairs(boxes) do
                            if box and box.Parent then
                                box.Color3 = color
                                box.Visible = hasActiveRole
                            end
                        end
                    end
                elseif player ~= localPlayer then
                    local boxes = roleBoxes[player]
                    if boxes then
                        for _, box in ipairs(boxes) do
                            if box and box.Parent then box.Visible = false end
                        end
                    end
                end
            end

            for player, boxes in pairs(roleBoxes) do
                if not Players:FindFirstChild(player.Name) then
                    clearRoleBoxes(player)
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    clearRoleBoxes(player)
end)

Players.PlayerAdded:Connect(function(player)
    if player == localPlayer then return end

    local function rebuildForCharacter(character)
        clearRoleBoxes(player)
        character:WaitForChild("HumanoidRootPart", 5)
        task.wait(0.25)
        if EspEnabled and player.Parent and player.Character == character then
            buildRoleBoxes(player)
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
            task.wait(0.25)
            if EspEnabled and player.Parent and player.Character == character then
                buildRoleBoxes(player)
            end
        end)
    end
end

-- Dropped Gun ESP
-- Cached/event-driven detection. Only one dropped-gun ESP box is created.
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

-- Auto Farm
-- Smooth upright movement to the nearest coin. The character never lies down
-- and never teleports: TweenService moves the HumanoidRootPart through walls
-- while collisions are temporarily disabled.
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

    -- During an active round, keep the character only 1.5 studs below the
    -- actual floor under the coin. Do not use the coin height itself as the
    -- vertical reference; that was what could send the character far below
    -- the map on maps with elevated coins.
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

    -- Save the actual surface position once, before going underneath coins.
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

    -- No configured Delay when somebody else already took this coin.
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
                -- Every new batch/round starts by slowly moving to the nearest
                -- coin from the surface; the target remains below the coin.
                farmToCoin(coin)
            else
                -- Before the first coin appears, do not move the player at all.
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

-- Auto Pickup Gun
task.spawn(function()
    while task.wait(0.40) do
        -- Never let Auto Pickup move the character while the player is
        -- interacting with a UI panel, using multi-touch, or actively moving.
        -- The short cooldown also covers the small gap between TouchEnded and
        -- the next pickup tick on mobile.
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

-- Sheriff Aimlock. Once a target is acquired, keep that exact player locked
-- until they die/leave. The lock point is always the Head.
aimlockLockedPlayer = nil
aimlockLockedHead = nil
aimlockLockedHumanoid = nil
aimlockAcquireAccumulator = 0
AIMLOCK_SMOOTHNESS = 0.34

function clearAimlockTarget()
    aimlockLockedPlayer = nil
    aimlockLockedHead = nil
    aimlockLockedHumanoid = nil
end

function acquireAimlockTarget()
    if not aimbotActive or not aimlockEngaged then
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
            local centerPart = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or root

            if humanoid and humanoid.Health > 0 and root and centerPart and centerPart:IsA("BasePart") then
                local worldDistance = localRoot and (root.Position - localRoot.Position).Magnitude or math.huge
                if worldDistance <= 120 then
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(centerPart.Position)
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
        aimlockLockedHead = character and (character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")) or nil
        aimlockLockedHumanoid = character and character:FindFirstChildOfClass("Humanoid") or nil
    end
end

RunService.RenderStepped:Connect(function(deltaTime)
    if not aimbotActive or not aimlockEngaged then
        return
    end

    local player = aimlockLockedPlayer
    local character = player and player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local centerPart = character and (character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart"))

    if not player or player.Parent ~= Players or not humanoid or humanoid.Health <= 0 or not centerPart then
        clearAimlockTarget()
        acquireAimlockTarget()
        player = aimlockLockedPlayer
        character = player and player.Character
        humanoid = character and character:FindFirstChildOfClass("Humanoid")
        centerPart = character and (character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart"))
    end

    if not centerPart then
        return
    end

    aimlockLockedHead = centerPart
    aimlockLockedHumanoid = humanoid
    local cameraPosition = Camera.CFrame.Position
    local targetCFrame = CFrame.lookAt(cameraPosition, centerPart.Position)
    local alpha = 1 - math.pow(1 - 0.82, math.clamp(deltaTime * 60, 0, 2))
    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, alpha)
end)

-- =========================================================
-- BOLONG AUTO-SHOOT TARGETING
-- Auto Shoot uses the supplied Shoot.lua FireServer argument pattern.
-- =========================================================

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
                    -- Use the actual body center for the shot point. This is
                    -- more stable than selecting a head/limb and works well on
                    -- very small scaled avatars.
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

-- Auto Shoot keeps the original Shoot:FireServer(originCFrame, targetCFrame)
-- call. Only the point prediction is improved.
AUTO_SHOOT_PROJECTILE_SPEED = 700
AUTO_SHOOT_MIN_LEAD = 0.006
AUTO_SHOOT_MAX_LEAD = 0.115
autoShootMotion = {}
AUTO_SHOOT_MAX_ACCELERATION = 300
AUTO_SHOOT_PING_LEAD = 0.035
AUTO_SHOOT_DIRECTION_BLEND = 0.88

function updateAutoShootMotion()
    if not AutoShootEnabled then
        return
    end

    local now = os.clock()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and getRole(player) == "Murderer" then
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")

            if root then
                local state = autoShootMotion[player]
                if not state then
                    autoShootMotion[player] = {
                        position = root.Position,
                        time = now,
                        velocity = root.AssemblyLinearVelocity,
                        acceleration = Vector3.zero,
                    }
                else
                    local dt = now - state.time
                    if dt > 0.008 and dt < 0.25 then
                        local measuredVelocity = (root.Position - state.position) / dt
                        local blendedVelocity = measuredVelocity:Lerp(root.AssemblyLinearVelocity, 0.35)
                        local measuredAcceleration = (blendedVelocity - state.velocity) / dt
                        if measuredAcceleration.Magnitude > AUTO_SHOOT_MAX_ACCELERATION then
                            measuredAcceleration = measuredAcceleration.Unit * AUTO_SHOOT_MAX_ACCELERATION
                        end
                        state.acceleration = state.acceleration:Lerp(measuredAcceleration, 0.45)
                        state.velocity = state.velocity:Lerp(blendedVelocity, 0.72)
                        state.position = root.Position
                        state.time = now
                    end
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(updateAutoShootMotion)

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

    -- Always solve against the actual body bounding-box center. This avoids
    -- head/limb offsets and is noticeably more reliable on tiny R6/R15 rigs.
    local bodyCFrame, bodySize = character:GetBoundingBox()
    local currentPosition = bodyCFrame.Position
    local rootPosition = root.Position

    -- If an unusual rig has a bounding box center far from the root, keep the
    -- aim point close to the root while preserving the model's actual height.
    local centerOffset = currentPosition - rootPosition
    if centerOffset.Magnitude > 4 then
        currentPosition = rootPosition
    end

    local velocity = root.AssemblyLinearVelocity
    local acceleration = Vector3.zero
    local player = Players:GetPlayerFromCharacter(character)
    local motion = player and autoShootMotion[player]

    if motion then
        if motion.velocity then
            velocity = motion.velocity:Lerp(velocity, 0.18)
        end
        if motion.acceleration then
            acceleration = motion.acceleration
        end
    end

    -- Tiny avatars need the center of their actual volume, not a fixed body
    -- offset. Keep the aim point inside the model even when scaled very small.
    local halfHeight = math.max((bodySize and bodySize.Y or 2) * 0.5, 0.18)
    local verticalCenterOffset = math.clamp(currentPosition.Y - rootPosition.Y, -halfHeight, halfHeight)
    currentPosition = Vector3.new(currentPosition.X, rootPosition.Y + verticalCenterOffset, currentPosition.Z)

    local distance = (currentPosition - origin).Magnitude
    local ping = 0
    pcall(function()
        ping = math.clamp(localPlayer:GetNetworkPing(), 0, 0.25)
    end)

    -- Start with the exact projectile travel time, then add only a small
    -- latency correction. The correction is deliberately capped so high ping
    -- cannot make the shot fly past a nearby target.
    local leadTime = math.clamp(
        distance / AUTO_SHOOT_PROJECTILE_SPEED + ping * AUTO_SHOOT_PING_LEAD,
        AUTO_SHOOT_MIN_LEAD,
        AUTO_SHOOT_MAX_LEAD
    )

    local predictedPosition = currentPosition
    for _ = 1, 10 do
        predictedPosition = currentPosition
            + velocity * leadTime
            + acceleration * (0.5 * leadTime * leadTime)

        local nextDistance = (predictedPosition - origin).Magnitude
        leadTime = math.clamp(
            nextDistance / AUTO_SHOOT_PROJECTILE_SPEED + ping * AUTO_SHOOT_PING_LEAD,
            AUTO_SHOOT_MIN_LEAD,
            AUTO_SHOOT_MAX_LEAD
        )
    end

    -- Preserve a very small amount of vertical lead. Horizontal prediction is
    -- allowed to be stronger because it is less sensitive to jump/fall noise.
    local verticalDelta = math.clamp(
        predictedPosition.Y - currentPosition.Y,
        -0.32,
        0.18
    )

    local horizontal = Vector3.new(
        predictedPosition.X - currentPosition.X,
        0,
        predictedPosition.Z - currentPosition.Z
    )

    -- Blend the predicted point toward the exact current center. This makes
    -- the first click feel immediate while retaining enough lead for movement.
    local predicted = currentPosition
        + horizontal
        + Vector3.new(0, verticalDelta, 0)

    return currentPosition:Lerp(predicted, AUTO_SHOOT_DIRECTION_BLEND)
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

    if not targetPosition or (targetPosition - origin).Magnitude < 0.01 then
        return false
    end

    -- Keep the same shooting method and FireServer argument structure.
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
    end

    return ok
end

-- Auto Shoot has no background loop; it fires only from the on-screen panel click.

-- =========================================================
-- BOLONG MM2 AUTO-SHOOT PANEL
-- =========================================================

function autoShoot()
    local gun = getGunForBolong()
    if not gun then
        -- removed: no-gun notification
        return
    end

    local murderer, targetPart = getMurdererTargetPart()
    if not murderer or not targetPart then

        return
    end

    equipTool(gun)
    task.wait(0.04)

    local equippedGun = getToolByName(localPlayer, "Gun") or gun
    if fireShotAtTarget(equippedGun, targetPart) then

    else
        -- removed: no-gun notification
    end
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

-- Four small "air bubbles" that gently rise inside the Auto Shoot panel.
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
    -- Scale 10 is the compact reference size: 197 x 49 px.
    PanelScale = math.clamp(tonumber(value) or 10, 5, 20)

    local scaleRatio = PanelScale / 10
    local width = math.clamp(math.floor(197 * scaleRatio + 0.5), 99, 394)
    local height = math.clamp(math.floor(49 * scaleRatio + 0.5), 25, 98)

    MainPanel.Size = UDim2.fromOffset(width, height)
    ShootLabel.TextSize = math.clamp(math.floor(12 * scaleRatio + 0.5), 8, 24)
end

UpdatePanelScale(10)

-- Auto Shoot intentionally fires only from the on-screen panel click.

-- =========================================================
-- FRUTIGER AERO AIMBOT PANEL
-- Small circular panel, 75% transparent, centered "AIMBOT" text.
-- =========================================================
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
AimbotPanel.Size = UDim2.fromOffset(70, 70)
AimbotPanel.Visible = false
AimbotPanel.Active = true
AimbotPanel.Parent = AimbotGui

AimbotCorner = Instance.new("UICorner")
AimbotCorner.CornerRadius = UDim.new(1, 0)
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
AimbotLabel.TextSize = 14
AimbotLabel.TextScaled = false
AimbotLabel.TextWrapped = true
AimbotLabel.Font = Enum.Font.GothamBold
AimbotLabel.TextXAlignment = Enum.TextXAlignment.Center
AimbotLabel.TextYAlignment = Enum.TextYAlignment.Center
AimbotLabel.Parent = AimbotPanel

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
        uiPanelTouchActive = true
        pickupTouchBlockUntil = os.clock() + 0.75
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
        AimbotStroke.Thickness = 2

        -- Only a real tap on the Aimlock panel engages/disengages the FOV and lock.
        -- Toggling the Aimlock setting itself never shows the FOV or acquires a target.
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
    AimbotPanelScale = math.clamp(tonumber(value) or 20, 10, 30)

    -- Keep the panel circular while scaling.
    local diameter = math.clamp(AimbotPanelScale * 3.2, 40, 96)
    AimbotPanel.Size = UDim2.fromOffset(diameter, diameter)

    -- Keep text inside the circle.
    AimbotLabel.Size = UDim2.fromScale(0.9, 0.9)
    AimbotLabel.TextSize = math.clamp(AimbotPanelScale * 0.55, 8, 17)
end

UpdateAimbotPanelScale(AimbotPanelScale)
aimbotFOVVisible = false
aimlockEngaged = false
UpdateAimbotVisuals()


-- Murder functions
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

    -- Stay at the current position. Face the target and swing once only.
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
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local gameplay = remotes and remotes:FindFirstChild("Gameplay")
    local killEvent = gameplay and gameplay:FindFirstChild("KillEvent")
    if not killEvent then return false end

    local ok = pcall(function()
        firesignal(killEvent.OnClientEvent,
            "player",
            Color3.new(0.098039217293262482, 0.88235294818878174, 0.098039217293262482),
            nil,
            "Melee Kill!"
        )
    end)
    return ok
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


-- =========================================================
-- PORTED MISC HELPERS (from Vision Hub / Mm2 (2))
-- =========================================================

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

-- =========================================================

-- Anti Fling
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

-- UI
-- =========================================================

-- Auto Pick up gun floating panel: circular, blue, 77% transparent, draggable.
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


-- Auto Throwing Knife: exact nil-instance Event trigger + silent FOV target lock.
-- No full hierarchy scan is used here.
autoThrowKnifeEnabled = false
autoThrowEventConnection = nil
autoThrowBoundEvent = nil
autoThrowTarget = nil
autoThrowLockUntil = 0
autoThrowCycle = 0
AUTO_THROW_SILENT_FOV = 30
AUTO_THROW_LOCK_TIME = 0.3
AUTO_THROW_UNLOCK_DELAY = 0.7

function GetNil(Name, DebugId)
    if type(getnilinstances) ~= "function" then
        return nil
    end

    local ok, objects = pcall(getnilinstances)
    if not ok or type(objects) ~= "table" then
        return nil
    end

    for _, Object in ipairs(objects) do
        if Object and Object.Name == Name then
            local idOK, objectDebugId = pcall(function()
                return Object:GetDebugId()
            end)

            if idOK and objectDebugId == DebugId then
                return Object
            end
        end
    end
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

    -- Pick the living player closest to the direction the player is facing.
    -- Only Innocent / Sheriff / Hero are valid knife targets.
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

                        -- 0.75 is roughly a 41-degree cone in front of the player.
                        if dot >= 0.75 then
                            -- Prefer targets that are more directly in front,
                            -- then prefer the nearer target when angles are similar.
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

function fireKnifeThrowAtLockedTarget(targetPart)
    if not targetPart or not targetPart.Parent then
        return false
    end

    local character = localPlayer.Character
    local knife = character and character:FindFirstChild("Knife")
    local events = knife and knife:FindFirstChild("Events")
    local knifeThrown = events and events:FindFirstChild("KnifeThrown")
    local originPart = character and (
        character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
    )

    if not knifeThrown or not originPart then
        return false
    end

    local origin = originPart.Position
    local target = targetPart.Position
    local direction = target - origin

    if direction.Magnitude <= 0.001 then
        return false
    end

    -- Same two-CFrame FireServer structure as the supplied throw code.
    local throwCFrame = CFrame.lookAt(origin, target)
    local targetCFrame = CFrame.new(target)

    local ok = pcall(function()
        knifeThrown:FireServer(
            throwCFrame,
            targetCFrame
        )
    end)

    return ok
end

function disconnectAutoThrowEvent()
    if autoThrowEventConnection then
        pcall(function()
            autoThrowEventConnection:Disconnect()
        end)
        autoThrowEventConnection = nil
    end

    autoThrowBoundEvent = nil
    autoThrowTarget = nil
    autoThrowLockUntil = 0
    autoThrowCycle = autoThrowCycle + 1
end

function enableAutoThrowKnife()
    disconnectAutoThrowEvent()

    -- Exact GetNil lookup from the supplied code. No world descendant scan.
    local Event = GetNil("Event", "0_353889")
    if not Event then
        return
    end

    autoThrowBoundEvent = Event
    autoThrowCycle = autoThrowCycle + 1
    local cycle = autoThrowCycle

    local ok, connection = pcall(function()
        return Event.Event:Connect(function()
            if not autoThrowKnifeEnabled or cycle ~= autoThrowCycle then
                return
            end

            -- Lock a valid Innocent / Sheriff / Hero in the invisible 30px FOV.
            local target = getAutoThrowSilentTarget()
            if not target then
                return
            end

            autoThrowTarget = target
            autoThrowLockUntil = os.clock() + AUTO_THROW_LOCK_TIME

            -- FireServer immediately using the locked target.
            fireKnifeThrowAtLockedTarget(autoThrowTarget)

            -- Keep the lock state for 0.7s after FireServer, then start fresh.
            task.delay(AUTO_THROW_UNLOCK_DELAY, function()
                if cycle ~= autoThrowCycle or not autoThrowKnifeEnabled then
                    return
                end

                autoThrowTarget = nil
                autoThrowLockUntil = 0
            end)
        end)
    end)

    if ok and connection then
        autoThrowEventConnection = connection
    else
        autoThrowBoundEvent = nil
    end
end

function disableAutoThrowKnife()
    autoThrowKnifeEnabled = false
    disconnectAutoThrowEvent()
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
    -- PC Shift Lock normally exposes MouseBehavior.LockCenter.
    if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        return true
    end

    -- Mobile/custom MouseLock can be tracked through its toggle signal.
    return fakeBombMouseLockActive == true
end

function getFakeBombFreeAimCFrame()
    local camera = Workspace.CurrentCamera
    if not camera then
        return nil
    end

    -- PC uses the normal mouse hit point. Touch devices use the most recent
    -- touch position so the throw follows where the player aimed on-screen.
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

    -- Keep the camera/Shift Lock pitch exactly, including looking upward/downward.
    return CFrame.lookAt(target, target + direction)
end

function getFakeBombThrowCFrame()
    if isFakeBombMouseLockOn() then
        return getFakeBombMouseLockCFrame()
    end

    -- With MouseLock/Shift Lock off, use the normal pointer/mouse aim direction.
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
    if not fakeBombJumpEnabled then
        return
    end

    local tool = getFakeBombTool()
    local remote = tool and tool:FindFirstChild("Remote")
    if not remote or not remote:IsA("RemoteEvent") then
        return
    end

    local throwCFrame = getFakeBombThrowCFrame()
    if not throwCFrame then
        return
    end

    triggerFakeBombRemotes()

    pcall(function()
        remote:FireServer(throwCFrame, 50)
    end)
end

function connectFakeBombTool(tool)
    if not tool or not tool:IsA("Tool") or tool.Name ~= "FakeBomb" then
        return
    end

    disconnectFakeBombTool(tool)

    fakeBombToolConnections[tool] = tool.Activated:Connect(function()
        if fakeBombJumpEnabled then
            fireFakeBombThrow()
        end
    end)
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
    disconnectAllFakeBombTools()
end

setupFakeBombMouseLock()

if localPlayer.Character then
    localPlayer.Character.ChildAdded:Connect(function(child)
        if child.Name == "FakeBomb" then
            connectFakeBombTool(child)
        end
    end)
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

    -- Requested order: Info first, then the functional tabs.
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

    -- MAIN
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

    local FakeBombSec = MainTab:AddSection("Fake bomb jump", true)
    FakeBombSec:AddToggle({
        Title = "Fake bomb jump",
        Default = false,
        Callback = function(v)
            if v == true then
                enableFakeBombJump()
            else
                disableFakeBombJump()
            end
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

    -- AUTO FARM: only the requested controls.
    local AutoFarmSec = AutoFarmTab:AddSection("Features", true)
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

    AutoFarmSec:AddInput({
        Title = "Webhook",
        Content = "",
        Placeholder = "Discord Webhook",
        Default = "",
        Save = false,
        Callback = function(v)
            discordWebhook = tostring(v or "")
        end
    })


    -- COMBAT: all related controls stay inside the same Auto Shoot section.
    -- Nothing is created as a separate floating GUI; scroll the main tab to
    -- see Aimlock and Auto Pick Up Gun below Auto Shoot.
    local AutoShootSec = CombatTab:AddSection("Features", true)

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
AutoShootSec:AddToggle({
        Title = "Aimlock",
        Default = false,
        Callback = function(v)
            aimbotActive = v == true
            -- The setting only enables the feature. FOV/lock appear after panel tap.
            if not aimbotActive then
                aimlockEngaged = false
                aimbotFOVVisible = false
                clearAimlockTarget()
            end
            UpdateAimbotVisuals()
            AimbotPanel.Visible = v == true
        end
    })

    AutoShootSec:AddSlider({
        Title = "Aimlock FOV",
        Min = 2, Max = 20, Default = 10, Increment = 1,
        Callback = function(v)
            aimbotFOV = math.clamp(tonumber(v) or 10, 2, 20)
            UpdateAimbotVisuals()
        end
    })

    AutoShootSec:AddSlider({
        Title = "Aimlock Panel Size",
        Min = 10, Max = 30, Default = 10, Increment = 1,
        Callback = function(v)
            UpdateAimbotPanelScale(v)
        end
    })
AutoShootSec:AddToggle({
        Title = "Auto Pick Up Gun",
        Default = false,
        Callback = function(v)
            autoPickupGunActive = v == true
            PickupPanel.Visible = v == true
        end
    })

    AutoShootSec:AddSlider({
        Title = "Auto Pick Up Gun Panel Size",
        Min = 5, Max = 20, Default = 10, Increment = 1,
        Callback = function(v)
            UpdatePickupPanelScale(v)
        end
    })

    -- MURDERER: no visible section title, only the requested controls.
    local MurdererSec = MurdererTab:AddSection("Features", true)
    MurdererSec:AddButton({
        Title = "Kill All",
        Callback = function() killAll() end
    })
    MurdererSec:AddButton({
        Title = "Kill Sheriff",
        Callback = function() killSheriff() end
    })
    MurdererSec:AddToggle({
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
-- VISUALS: only the requested three controls.
    local VisualSec = VisualsTab:AddSection("Features", true)
    VisualSec:AddToggle({
        Title = "ESP Roles",
        Default = false,
        Callback = function(v)
            EspEnabled = v == true
            limbEspEnabled = EspEnabled
            if not EspEnabled then
                for _, box in pairs(roleBoxes) do if box then box:Destroy() end end
                roleBoxes = {}
            end
        end
    })
    VisualSec:AddToggle({
        Title = "ESP Dropped Gun",
        Default = false,
        Callback = function(v)
            droppedGunEspEnabled = v == true
            updateDroppedGunESP()
        end
    })
    VisualSec:AddToggle({
        Title = "Show Dropped gun esp name",
        Default = false,
        Callback = function(v)
            showDroppedGunEspNameEnabled = v == true
            if not showDroppedGunEspNameEnabled then
                clearDroppedGunESPName()
            end
        end
    })
    VisualSec:AddToggle({
        Title = "Show rounds timer",
        Default = false,
        Callback = function(v)
            RoundTimerState.enabled = v == true
            if RoundTimerState.enabled then
                ensureRoundTimerGui()
                RoundTimerState.gui.Enabled = true
                -- If the toggle is enabled after RoundStart already fired,
                -- deliberately show 0:00 instead of guessing the elapsed time.
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

    -- MISC
    local MiscFlingSec = MiscTab:AddSection("Anti Fling / Fling", nil)
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
                        limbEspEnabled = false
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

