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

local function beginRoundTimer(duration)
    -- This function is called only by the live RoundStart listener.
    -- If the event omits a usable duration, use the usual 180-second round length.
    duration = tonumber(duration)
    if not duration or duration <= 0 then
        duration = 180
    end

    RoundTimerState.phase = "RUNNING"
    RoundTimerState.duration = duration
    RoundTimerState.startedAt = getServerNow()
    RoundTimerState.endAt = RoundTimerState.startedAt + duration
    RoundRoleEndAt = RoundTimerState.endAt
    refreshLocalPlayerReferences()
    ensureRoundTimerGui()
    if RoundTimerState.gui then
        RoundTimerState.gui.Enabled = true
    end
    if RoundTimerState.enabled then
        RoundTimerState.gui.Enabled = true
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
    -- Keep the timer panel on-screen at 0:00 after RoundEndFade, matching the
    -- working .trashed version. Only the Show rounds timer toggle hides it.
    if RoundTimerState.panel then
        RoundTimerState.panel.Visible = RoundTimerState.enabled
    end
    if RoundTimerState.label then
        RoundTimerState.label.Text = "0:00"
    end
end

-- Forward-declare the Auto Farm cleanup function so round callbacks share the
-- same local function instead of resolving a missing global during an event.
local destroyAutoFarmGodPlatform
local stopAutoFarmRoundSession

-- Remote hookup runs in its own task so missing/late remotes cannot block the UI
-- from loading. Ignore startup-time signals until BuildUI has completed; the timer
-- must wait for the next live RoundStart event after the script is ready.
local roundTimerHooksReady = false

task.spawn(function()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local remotesFolder = replicatedStorage:WaitForChild("Remotes")
    local gameplayRemotes = remotesFolder:WaitForChild("Gameplay")

    local roundStartRemote = gameplayRemotes:WaitForChild("RoundStart")
    if roundStartRemote:IsA("RemoteEvent") then
        roundStartRemote.OnClientEvent:Connect(function(roundDuration, _roundPlayerData)
            if not roundTimerHooksReady then
                return
            end

            RoundTimerState.enabled = true
            beginRoundTimer(roundDuration)
            autoFarmRoundActive = true
            autoFarmWaitingForRoundStart = false

            -- RoundStart must not clear Roles/Fade state. Keep role visuals until
            -- RoundEndFade(true) performs the actual cleanup.
            roleVisualsAllowed = true
            autoShootShotCooldownUntil = 0
            autoFarmRoundToken = (tonumber(autoFarmRoundToken) or 0) + 1
            autoFarmCoinsCollected = 0
            autoFarmFullActionDone = false
            autoFarmMapCache = nil
            if type(destroyAutoFarmGodPlatform) == "function" then
                destroyAutoFarmGodPlatform()
            end
            if autoFarmActive and type(startAutoFarm) == "function" then
                task.defer(function()
                    if autoFarmActive and type(startAutoFarm) == "function" then
                        startAutoFarm()
                    end
                end)
            end
        end)
    end

    local roundEndFadeRemote = gameplayRemotes:WaitForChild("RoundEndFade")
    if roundEndFadeRemote:IsA("RemoteEvent") then
        roundEndFadeRemote.OnClientEvent:Connect(function(isEnding)
            if not roundTimerHooksReady or isEnding ~= true then
                return
            end

            roleVisualSource = "FADE"
            roleVisualsAllowed = false
            endRoundTimer()
            autoFarmRoundActive = false
            autoFarmWaitingForRoundStart = true
            autoShootShotCooldownUntil = 0
            autoFarmRoundToken = (tonumber(autoFarmRoundToken) or 0) + 1
            autoFarmCoinsRunning = false
            autoFarmCoinsCollected = 0
            autoFarmFullActionDone = false
            autoFarmMapCache = nil
            if autoFarmCurrentTween then
                pcall(function()
                    autoFarmCurrentTween:Cancel()
                end)
                autoFarmCurrentTween = nil
            end
            if type(destroyAutoFarmGodPlatform) == "function" then
                destroyAutoFarmGodPlatform()
            end
            if type(stopAutoFarmRoundSession) == "function" then
                stopAutoFarmRoundSession()
            end

            -- RoundEndFade(true): clear all role information and visuals.
            roleRebuildQueued = {}
            resetRoundRoles()
            clearAllRoleBoxes()
        end)
    end
end)

RunService.Heartbeat:Connect(function(deltaTime)
    if not roleVisualsAllowed and next(roleBoxes or {}) ~= nil then
        clearAllRoleBoxes()
    end

    local serverNow = getServerNow()
    if RoundRoleEndAt > 0 and serverNow >= RoundRoleEndAt then
        -- Round timer expiry is not a role cleanup event. Roles/Fade stay visible
        -- until the actual RoundEndFade(true) remote arrives.
        RoundRoleEndAt = 0
    end

    if RoundTimerState.enabled then
        ensureRoundTimerGui()
        -- Re-enable only while the timer feature is enabled. RoundEndFade must
        -- not leave the ScreenGui disabled and hide the panel in later frames.
        if RoundTimerState.gui then
            RoundTimerState.gui.Enabled = true
        end

        if RoundTimerState.phase == "RUNNING" and RoundTimerState.endAt > 0 then
            RoundTimerState.panel.Visible = true
            local remaining = math.max(0, RoundTimerState.endAt - serverNow)
            RoundTimerState.label.Text = formatRoundTime(remaining)
            -- Reaching 0:00 does not end/reset the round timer by itself.
            -- Keep it at 0:00 until RoundEndFade(true) arrives from the game.
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
hitboxSize = 8
hitboxOriginals = setmetatable({}, {__mode = "k"})

autoShootVariant = "Auto"
autoShootFlickBusy = false

invisibleEnabled = false
invisibleFeatureEnabled = false
invisibleTransparencyOriginals = {}
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
spamFlingEnabled = false
autoFarmResetWhenFull = false
autoFarmFlingMurdererWhenFull = false
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
roleVisualsAllowed = true
-- Bootstrap with fallback only once. Fade takes permanent ownership as soon as
-- an authoritative Fade payload arrives; it remains the active source thereafter.
roleVisualSource = "FALLBACK"
firstGunHolderName = nil
roleRoundSerial = 0

local roleDeadPlayers = {}
local roleDeathConnections = {}
local sheriffDead = false
local sheriffDeathPlayerName = nil

-- One-time bootstrap fallback. It is never reset by RoundStart and is permanently
-- retired once Fade takes over (or RoundEndFade(true) occurs).
local initialKnifeFallbackActive = false
local initialKnifeFallbackPlayer = nil
local initialKnifeFallbackDone = false
local initialGunFallbackActive = false
local initialGunFallbackPlayer = nil

local function runInitialKnifeFallbackOnce()
    if initialKnifeFallbackDone or not roleVisualsAllowed or roleVisualSource ~= "FALLBACK" or roleRoundActive then
        return
    end

    local fallbackMurderer = nil
    local fallbackSheriff = nil

    -- Fallback owns the initial round snapshot: everyone starts as Innocent (green),
    -- then any player holding Knife/Gun is promoted to the detected role.
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            roleCache[player.Name] = "Innocent"
            roleCacheByUserId[player.UserId] = "Innocent"
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            local backpack = player:FindFirstChildOfClass("Backpack")

            local hasKnife = (character and character:FindFirstChild("Knife")) ~= nil
                or (backpack and backpack:FindFirstChild("Knife")) ~= nil
            local hasGun = (character and character:FindFirstChild("Gun")) ~= nil
                or (backpack and backpack:FindFirstChild("Gun")) ~= nil

            if hasKnife and not fallbackMurderer then
                fallbackMurderer = player
            end
            if hasGun and not fallbackSheriff then
                fallbackSheriff = player
            end
        end
    end

    if fallbackMurderer then
        roleCache[fallbackMurderer.Name] = "Murderer"
        roleCacheByUserId[fallbackMurderer.UserId] = "Murderer"
        initialKnifeFallbackActive = true
        initialKnifeFallbackPlayer = fallbackMurderer
    end

    if fallbackSheriff then
        roleCache[fallbackSheriff.Name] = "Sheriff"
        roleCacheByUserId[fallbackSheriff.UserId] = "Sheriff"
        firstGunHolderName = fallbackSheriff.Name
        initialGunFallbackActive = true
        initialGunFallbackPlayer = fallbackSheriff
    end

    if fallbackMurderer or fallbackSheriff then
        initialKnifeFallbackDone = true
        roleRoundActive = true
        roleRoundSerial = roleRoundSerial + 1

        if EspEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    buildRoleBoxes(player)
                end
            end
        end
    end
end

task.defer(function()
    -- Run immediately on script startup, then give replicated tools a short window
    -- to appear without ever creating a second fallback round.
    runInitialKnifeFallbackOnce()
    for _ = 1, 20 do
        if initialKnifeFallbackDone or roleVisualSource ~= "FALLBACK" then
            break
        end
        task.wait(0.15)
        runInitialKnifeFallbackOnce()
    end
end)

local function updateRoleBoxDisplay(player)
    if not player then return end
    local boxes = roleBoxes and roleBoxes[player]
    if not boxes then return end

    local role = GetPlayerRoleMM2(player)
    local activeRole = roleRoundActive and not roleDeadPlayers[player] and (
        role == "Murderer"
        or role == "Sheriff"
        or role == "Hero"
        or role == "Innocent"
    )
    local color = getRoleColor(role)

    for _, box in ipairs(boxes) do
        if box and box.Parent then
            if box.Color3 ~= color then box.Color3 = color end
            local shouldShow = EspEnabled and activeRole
            if box.Visible ~= shouldShow then box.Visible = shouldShow end
        end
    end
end

local function bindRoleDeathWatcher(player, character)
    if not player or player == localPlayer or not character then return end

    local old = roleDeathConnections[player]
    if old then pcall(function() old:Disconnect() end) end
    roleDeathConnections[player] = nil

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then humanoid = character:WaitForChild("Humanoid", 5) end
    if not humanoid then return end

    roleDeadPlayers[player] = humanoid.Health <= 0
    roleDeathConnections[player] = humanoid.Died:Connect(function()
        roleDeadPlayers[player] = true
        if firstGunHolderName == player.Name then
            sheriffDead = true
            sheriffDeathPlayerName = player.Name
        end
        updateRoleBoxDisplay(player)
    end)
end

function clearAllRoleBoxes()
    for player in pairs(roleBoxes or {}) do
        clearRoleBoxes(player)
    end

    -- Also remove any orphaned role boxes that are still parented to body parts.
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            for _, partName in ipairs(ROLE_PART_NAMES or {}) do
                local part = player.Character:FindFirstChild(partName)
                if part then
                    local box = part:FindFirstChild("BolongRolePartBox")
                    while box do
                        pcall(function() box:Destroy() end)
                        box = part:FindFirstChild("BolongRolePartBox")
                    end
                end
            end
        end
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

task.spawn(function()
    -- Keep Fade hookup independent from the Round Timer task's local variables.
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local remotesFolder = replicatedStorage:WaitForChild("Remotes")
    local gameplayRemotes = remotesFolder:WaitForChild("Gameplay")
    local fadeRemote = gameplayRemotes:WaitForChild("Fade")

    if fadeRemote and fadeRemote:IsA("RemoteEvent") then
        fadeRemote.OnClientEvent:Connect(function(roundPlayers)
            if type(roundPlayers) ~= "table" then
                return
            end

            -- Fade is authoritative. The first Fade payload permanently retires the
            -- bootstrap fallback so the two role sources can never overlap.
            roleVisualSource = "FADE"
            roleVisualsAllowed = true
            clearAllRoleBoxes()
            roleCache = {}
            roleCacheByUserId = {}
            roleDeadPlayers = {}
            roleRoundActive = true
            initialKnifeFallbackActive = false
            initialKnifeFallbackPlayer = nil
            initialGunFallbackActive = false
            initialGunFallbackPlayer = nil
            sheriffDead = false
            sheriffDeathPlayerName = nil
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

            if EspEnabled then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character then
                        buildRoleBoxes(player)
                    end
                end
            else
                for player in pairs(roleBoxes or {}) do
                    updateRoleBoxDisplay(player)
                end
            end
        end)
    end
end)

function resetRoundRoles()
    roleCache = {}
    roleCacheByUserId = {}
    roleDeadPlayers = {}
    roleRoundActive = false
    initialKnifeFallbackActive = false
    initialKnifeFallbackPlayer = nil
    initialGunFallbackActive = false
    initialGunFallbackPlayer = nil
    sheriffDead = false
    sheriffDeathPlayerName = nil
    firstGunHolderName = nil
    clearAllRoleBoxes()
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

local function bindAutoFarmDeathWatcher(character)
    if not character then return end
    task.spawn(function()
        local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
        if not humanoid then return end
        humanoid.Died:Connect(function()
            if autoFarmActive and autoFarmRoundActive then
                autoFarmRoundActive = false
                autoFarmWaitingForRoundStart = true
                if type(stopAutoFarmRoundSession) == "function" then
                    stopAutoFarmRoundSession()
                else
                    autoFarmCoinsRunning = false
                end
            end
        end)
    end)
end

if localPlayer.Character then
    bindAutoFarmDeathWatcher(localPlayer.Character)
end

localPlayer.CharacterAdded:Connect(function(character)
    bindAutoFarmDeathWatcher(character)
    if NoclipEnabled then
        setupNoclipCharacter(character)
    end

    -- A respawn alone is not a new round. Resume farming only after a live RoundStart.
    if autoFarmActive and autoFarmRoundActive then
        if autoFarmCoinsThread then
            task.cancel(autoFarmCoinsThread)
            autoFarmCoinsThread = nil
        end
        task.defer(function()
            if autoFarmActive and autoFarmRoundActive and localPlayer.Character == character then
                startAutoFarm()
            end
        end)
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
autoFarmSpeed = 12
autoFarmCollectDelay = 1
coinReachEnabled = false
coinReachUserEnabled = false
autoFarmOwnsCoinReach = false
autoFarmRoundActive = false
autoFarmWaitingForRoundStart = true
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

function refreshGunHolderRole(player)
    if not player or player == localPlayer or not player.Parent then return end
    if not roleRoundActive then return end

    local gun = getToolByName(player, "Gun")
    if not gun then return end

    local cachedRole = GetPlayerRoleMM2(player)

    if cachedRole == "Sheriff" then
        firstGunHolderName = player.Name
        initialGunFallbackActive = false
        initialGunFallbackPlayer = nil
        updateRoleBoxDisplay(player)
        return
    end

    if firstGunHolderName and firstGunHolderName == player.Name then
        roleCache[player.Name] = "Sheriff"
        roleCacheByUserId[player.UserId] = "Sheriff"
        initialGunFallbackActive = false
        initialGunFallbackPlayer = nil
        updateRoleBoxDisplay(player)
        return
    end

    if firstGunHolderName and sheriffDead then
        roleCache[player.Name] = "Hero"
        roleCacheByUserId[player.UserId] = "Hero"
        initialGunFallbackActive = false
        initialGunFallbackPlayer = nil
        updateRoleBoxDisplay(player)
        return
    end

    for _, role in pairs(roleCache) do
        if role == "Sheriff" then return end
    end

    firstGunHolderName = player.Name
    roleCache[player.Name] = "Sheriff"
    roleCacheByUserId[player.UserId] = "Sheriff"
    initialGunFallbackActive = false
    initialGunFallbackPlayer = nil
    updateRoleBoxDisplay(player)
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
    if not EspEnabled or not roleVisualsAllowed or not player or not character or player.Character ~= character then
        return
    end
    if roleRebuildQueued[player] then
        return
    end
    roleRebuildQueued[player] = true
    task.delay(0.08, function()
        roleRebuildQueued[player] = nil
        if EspEnabled and roleVisualsAllowed and player.Parent and player.Character == character then
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

    if not roleVisualsAllowed then
        return
    end

    if not roleRoundActive and not initialKnifeFallbackActive and not initialGunFallbackActive then
        return
    end

    local character = player.Character
    if not character then return end

    local boxes = {}
    local roleColor = getRoleColor(GetPlayerRoleMM2(player))
    bindRoleCharacterWatcher(player, character)
    bindRoleDeathWatcher(player, character)

    for _, part in ipairs(getRoleParts(character)) do
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "BolongRolePartBox"
        box.Adornee = part
        box.Size = part.Size
        box.Color3 = roleColor
        box.Transparency = 0.64
        box.AlwaysOnTop = true
        box.ZIndex = 1
        box.Visible = (roleRoundActive or initialKnifeFallbackActive or initialGunFallbackActive)
            and not roleDeadPlayers[player]
            and (GetPlayerRoleMM2(player) ~= "Lobby")
        box.Parent = part
        table.insert(boxes, box)
    end

    roleBoxes[player] = boxes
end

task.spawn(function()
    while task.wait(0.25) do
        if EspEnabled then
            if roleVisualSource == "FALLBACK" and not initialKnifeFallbackDone then
                runInitialKnifeFallbackOnce()
            end
            for player in pairs(roleBoxes) do
                updateRoleBoxDisplay(player)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    clearRoleBoxes(player)
    roleDeadPlayers[player] = nil
    local deathConnection = roleDeathConnections[player]
    if deathConnection then
        pcall(function() deathConnection:Disconnect() end)
        roleDeathConnections[player] = nil
    end
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
            if EspEnabled and roleVisualsAllowed then
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
            if EspEnabled and roleVisualsAllowed and player.Parent and player.Character == character then
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
        local effectiveRange = autoFarmOwnsCoinReach and 5 or coinReachRange
        pcall(function()
            obj.Size = originalSize * effectiveRange
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
    state = state == true

    -- Reapplying the current state must not re-capture already-scaled coin sizes
    -- as the originals (which would compound the reach multiplier).
    if state == coinReachEnabled then
        if state then
            local effectiveRange = autoFarmOwnsCoinReach and 5 or coinReachRange
            for obj, originalSize in pairs(coinReachOriginals) do
                if obj and obj.Parent and originalSize then
                    pcall(function()
                        obj.Size = originalSize * effectiveRange
                    end)
                end
            end
        end
        return
    end

    coinReachEnabled = state
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

function setAutoFarmCoinReach(state)
    autoFarmOwnsCoinReach = state == true
    ApplyCoinReach(coinReachUserEnabled or autoFarmOwnsCoinReach)
end

autoFarmSpeed = 12
autoFarmCollectDelay = 1
autoFarmMode = "Normal"

autoFarmCoinsCollected = 0
autoFarmFullActionDone = false
autoFarmRoundToken = 0
autoFarmCurrentTween = nil
autoFarmNoclipEnabled = false
autoFarmNoclipConnection = nil
autoFarmNoclipEnforceConnection = nil
autoFarmNoclipOriginals = {}
autoFarmGodPlatform = nil
autoFarmHoldCFrame = nil
autoFarmNoCoinsStanding = false
AUTO_FARM_STAND_ROOT_HEIGHT = 2.5

murdererKillAllEnabled = false
autoShootMurdererEnabled = false

local function setAutoFarmCharacterNoclip(state)
    state = state == true

    if state and autoFarmNoclipEnabled then
        return
    end

    if autoFarmNoclipConnection then
        pcall(function()
            autoFarmNoclipConnection:Disconnect()
        end)
        autoFarmNoclipConnection = nil
    end
    if autoFarmNoclipEnforceConnection then
        pcall(function()
            autoFarmNoclipEnforceConnection:Disconnect()
        end)
        autoFarmNoclipEnforceConnection = nil
    end

    if not state then
        for part, original in pairs(autoFarmNoclipOriginals) do
            if part and part.Parent then
                pcall(function()
                    part.CanCollide = original
                end)
            end
        end
        autoFarmNoclipOriginals = {}
        autoFarmNoclipEnabled = false
        return
    end

    autoFarmNoclipEnabled = true
    autoFarmNoclipOriginals = {}

    local character = localPlayer.Character
    if not character then
        autoFarmNoclipEnabled = false
        return
    end

    local function applyPart(obj)
        if obj and obj:IsA("BasePart") then
            if autoFarmNoclipOriginals[obj] == nil then
                autoFarmNoclipOriginals[obj] = obj.CanCollide
            end
            pcall(function()
                obj.CanCollide = false
            end)
        end
    end

    local function scan(parent)
        for _, child in ipairs(parent:GetChildren()) do
            applyPart(child)
            scan(child)
        end
    end
    scan(character)

    autoFarmNoclipConnection = character.DescendantAdded:Connect(function(obj)
        if autoFarmNoclipEnabled then
            applyPart(obj)
        end
    end)

    -- Re-apply noclip periodically in case the game resets CanCollide (for example, on stairs).
    autoFarmNoclipEnforceConnection = RunService.Heartbeat:Connect(function()
        if not autoFarmNoclipEnabled then
            return
        end
        local activeCharacter = localPlayer and localPlayer.Character
        if not activeCharacter then
            return
        end
        for _, obj in ipairs(activeCharacter:GetDescendants()) do
            applyPart(obj)
        end
    end)
end

destroyAutoFarmGodPlatform = function()
    if autoFarmGodPlatform then
        pcall(function()
            autoFarmGodPlatform:Destroy()
        end)
        autoFarmGodPlatform = nil
    end
end

local function restoreAutoFarmCharacterState()
    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local hrp = character and character:FindFirstChild("HumanoidRootPart")

    if humanoid then
        pcall(function()
            humanoid.AutoRotate = true
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
    end

    if hrp then
        pcall(function()
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end

local function holdAutoFarmCharacter(holdCFrame)
    if not autoFarmCoinsRunning or not holdCFrame then
        return
    end

    local character = localPlayer and localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp or humanoid.Health <= 0 then
        return
    end

    pcall(function()
        humanoid.AutoRotate = false
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        hrp.CFrame = holdCFrame
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)
    autoFarmHoldCFrame = holdCFrame
end

local function getAutoFarmMap()
    if autoFarmMapCache and autoFarmMapCache.Parent
        and (autoFarmMapCache:FindFirstChild("CoinAreas") or autoFarmMapCache:FindFirstChild("CoinContainer")) then
        return autoFarmMapCache
    end
    autoFarmMapCache = nil
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:FindFirstChild("CoinAreas") or obj:FindFirstChild("CoinContainer") then
            autoFarmMapCache = obj
            return obj
        end
    end
    return nil
end

local function getAutoFarmNearestCoin()
    local map = getAutoFarmMap()
    if not map or not autoFarmCoinsRunning then return nil end
    local coinContainer = map:FindFirstChild("CoinContainer")
    if not coinContainer then return nil end
    local character = localPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return nil end
    local closest, closestDistance = nil, math.huge
    for _, coin in ipairs(coinContainer:GetChildren()) do
        if coin.Name == "Coin_Server" and coin:IsA("BasePart") and not coin:GetAttribute("Collected") then
            local distance = (root.Position - coin.Position).Magnitude
            if distance < closestDistance then
                closest, closestDistance = coin, distance
            end
        end
    end
    return closest
end

local function waitAutoFarmCharacter()
    while autoFarmCoinsRunning do
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if character and humanoid and hrp and humanoid.Health > 0 then
            return character, humanoid, hrp
        end
        task.wait(0.12)
    end
    return nil
end

local onyxFarmPhysics = {gyro = nil, velocity = nil, character = nil, oldAutoRotate = true, oldPlatformStand = false}
local function setOnyxAutoFarmPhysics(enabled)
    local character = localPlayer and localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local torso = character and (character:FindFirstChild("UpperTorso") or root)
    if enabled then
        if not character or not humanoid or not root or not torso then return false end
        if onyxFarmPhysics.character ~= character then
            if onyxFarmPhysics.gyro then pcall(function() onyxFarmPhysics.gyro:Destroy() end) end
            if onyxFarmPhysics.velocity then pcall(function() onyxFarmPhysics.velocity:Destroy() end) end
            onyxFarmPhysics.gyro, onyxFarmPhysics.velocity = nil, nil
            onyxFarmPhysics.character = character
            onyxFarmPhysics.oldAutoRotate = humanoid.AutoRotate
            onyxFarmPhysics.oldPlatformStand = humanoid.PlatformStand
        end
        if not onyxFarmPhysics.gyro or not onyxFarmPhysics.gyro.Parent then
            local gyro = Instance.new("BodyGyro")
            gyro.Name = "ODH Auto Farm BodyGyro"
            gyro.P = 90000
            gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            gyro.CFrame = CFrame.new(root.Position) * CFrame.Angles(math.rad(90), 0, math.rad(90))
            gyro.Parent = torso
            onyxFarmPhysics.gyro = gyro
        end
        if not onyxFarmPhysics.velocity or not onyxFarmPhysics.velocity.Parent then
            local velocity = Instance.new("BodyVelocity")
            velocity.Name = "ODH Auto Farm BodyVelocity"
            velocity.Velocity = Vector3.zero
            velocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            velocity.Parent = torso
            onyxFarmPhysics.velocity = velocity
        end
        humanoid.AutoRotate = false
        humanoid.PlatformStand = true
        return true
    end
    if onyxFarmPhysics.gyro then pcall(function() onyxFarmPhysics.gyro:Destroy() end) end
    if onyxFarmPhysics.velocity then pcall(function() onyxFarmPhysics.velocity:Destroy() end) end
    onyxFarmPhysics.gyro, onyxFarmPhysics.velocity = nil, nil
    local oldCharacter = onyxFarmPhysics.character
    if character and (not oldCharacter or character == oldCharacter) and humanoid then
        humanoid.PlatformStand = onyxFarmPhysics.oldPlatformStand == true
        humanoid.AutoRotate = onyxFarmPhysics.oldAutoRotate ~= false
        if not humanoid.PlatformStand then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
    end
    onyxFarmPhysics.character = nil
    return true
end

local function moveAutoFarmToCoin(target)
    local character, humanoid, hrp = waitAutoFarmCharacter()
    if not character or not humanoid or not hrp or not target or not target.Parent then
        return false
    end

    autoFarmNoCoinsStanding = false
    setAutoFarmCharacterNoclip(true)
    setOnyxAutoFarmPhysics(true)
    -- Match Onyx's farm pose: face-up, with the root held 3.5 studs below the coin.
    local destination = CFrame.new(target.Position.X, target.Position.Y - 3.5, target.Position.Z)
        * CFrame.Angles(math.rad(90), 0, math.rad(90))
    autoFarmHoldCFrame = nil

    local distance = (hrp.Position - destination.Position).Magnitude
    local speed = math.clamp(tonumber(autoFarmSpeed) or 12, 7, 30)
    local duration = math.max(0.02, distance / speed)

    if autoFarmCurrentTween then
        pcall(function()
            autoFarmCurrentTween:Cancel()
        end)
        autoFarmCurrentTween = nil
    end

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {CFrame = destination}
    )
    autoFarmCurrentTween = tween
    tween:Play()

    while tween.PlaybackState == Enum.PlaybackState.Playing and autoFarmCoinsRunning do
        if humanoid.Health <= 0 or not hrp.Parent or not target.Parent then
            tween:Cancel()
            autoFarmCurrentTween = nil
            return false
        end
        task.wait()
    end

    if autoFarmCurrentTween == tween then
        autoFarmCurrentTween = nil
    end

    if autoFarmCoinsRunning and hrp.Parent and target.Parent then
        holdAutoFarmCharacter(destination)
    end

    return autoFarmCoinsRunning, destination
end

local function releaseAutoFarmAtStandingPosition(lastHoldCFrame)
    local character = localPlayer and localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local hrp = character and character:FindFirstChild("HumanoidRootPart")

    if lastHoldCFrame and hrp and hrp.Parent and humanoid and humanoid.Health > 0 then
        local standPosition = lastHoldCFrame.Position + Vector3.new(0, 3.5 + AUTO_FARM_STAND_ROOT_HEIGHT, 0)
        local standCFrame = CFrame.new(standPosition)

        if autoFarmCurrentTween then
            pcall(function() autoFarmCurrentTween:Cancel() end)
            autoFarmCurrentTween = nil
        end

        -- Keep noclip only during the short lift so the avatar reaches the floor
        -- cleanly; restore collisions and release control immediately afterward.
        setAutoFarmCharacterNoclip(true)
        local tween = TweenService:Create(
            hrp,
            TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {CFrame = standCFrame}
        )
        autoFarmCurrentTween = tween
        tween:Play()
        while tween.PlaybackState == Enum.PlaybackState.Playing and hrp.Parent do
            task.wait()
        end
        if autoFarmCurrentTween == tween then
            autoFarmCurrentTween = nil
        end
    end

    autoFarmHoldCFrame = nil
    autoFarmNoCoinsStanding = true
    setOnyxAutoFarmPhysics(false)
    setAutoFarmCharacterNoclip(false)
    restoreAutoFarmCharacterState()
end

local function getAutoFarmBagLimit()
    return localPlayer and localPlayer:GetAttribute("Elite") and 50 or 40
end

local function autoFarmReached40()
    local bagLimit = getAutoFarmBagLimit()
    if autoFarmFullActionDone or autoFarmCoinsCollected < bagLimit then
        return false
    end

    autoFarmFullActionDone = true
    autoFarmCoinsRunning = false

    local lastHold = autoFarmHoldCFrame
    if autoFarmCurrentTween then
        pcall(function()
            autoFarmCurrentTween:Cancel()
        end)
        autoFarmCurrentTween = nil
    end

    releaseAutoFarmAtStandingPosition(lastHold)

    if autoFarmResetWhenFull then
        task.delay(1.5, function()
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then pcall(function() humanoid.Health = 0 end) end
        end)
    end

    local knife = getKnife()
    local gun = getGunForBolong()

    if autoFarmFlingMurdererWhenFull and _G.BolongStartFlingRole then
        task.defer(_G.BolongStartFlingRole, "Murderer")
    end

    if murdererKillAllEnabled and knife then
        equipTool(knife)
        task.defer(function()
            killAll()
        end)
        return true
    end

    if autoShootMurdererEnabled and gun then
        equipTool(gun)
        task.spawn(function()
            local token = autoFarmRoundToken
            while autoFarmActive
                and autoShootMurdererEnabled
                and token == autoFarmRoundToken
                and RoundTimerState.phase ~= "ENDED" do

                local murderer, targetPart = getMurdererTargetPart()
                if not murderer or not targetPart then
                    break
                end

                local targetCharacter = murderer.Character
                local humanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
                if not humanoid or humanoid.Health <= 0 then
                    break
                end

                local currentGun = getGunForBolong()
                if not currentGun then
                    break
                end

                local equippedGun = localPlayer.Character and localPlayer.Character:FindFirstChild("Gun")
                if not equippedGun then
                    equipTool(currentGun)
                    task.wait(0.01)
                    equippedGun = localPlayer.Character and localPlayer.Character:FindFirstChild("Gun")
                end

                if not equippedGun then
                    break
                end

                -- fireShotAtTarget re-reads UpperTorso.Position immediately before FireServer.
                fireShotAtTarget(equippedGun, targetPart)
                task.wait(0.015)
            end
        end)
        return true
    end

    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if humanoid then
        pcall(function()
            humanoid.AutoRotate = true
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
    end
    if hrp then
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    return true
end

function AutoFarmCoinsFunc()
    autoFarmRoundToken = autoFarmRoundToken + 1
    autoFarmCoinsCollected = 0
    autoFarmFullActionDone = false
    autoFarmMapCache = nil
    autoFarmCountedCoins = setmetatable({}, {__mode = "k"})

    setAutoFarmCharacterNoclip(true)

    while autoFarmCoinsRunning and not autoFarmFullActionDone do
        local target = getAutoFarmNearestCoin()

        if target then
            local moved, holdCFrame = moveAutoFarmToCoin(target)
            if moved then
                while autoFarmCoinsRunning and target.Parent and not target:GetAttribute("Collected") do
                    holdAutoFarmCharacter(holdCFrame)
                    task.wait(0.05)
                end

                local collected = false
                if not target.Parent or target:GetAttribute("Collected") == true then
                    collected = true
                end

                if collected and not autoFarmCountedCoins[target] then
                    autoFarmCountedCoins[target] = true
                    autoFarmCoinsCollected = autoFarmCoinsCollected + 1
                    local bagLimit = getAutoFarmBagLimit()
                    pcall(sendOnyxWebhook, ("Auto Farm collected %d/%d coins."):format(autoFarmCoinsCollected, bagLimit))
                    if autoFarmCoinsCollected >= bagLimit then
                        pcall(sendOnyxWebhook, "Coin bag is full. Running the selected full-bag action.")
                        autoFarmReached40()
                        break
                    end
                end

                -- Skip the collect delay when no coin remains so the Onyx farm pose is released promptly.
                if autoFarmCoinsRunning and getAutoFarmNearestCoin() then
                    local delayUntil = os.clock() + math.clamp(tonumber(autoFarmCollectDelay) or 1, 0.4, 2)
                    while autoFarmCoinsRunning and os.clock() < delayUntil do
                        holdAutoFarmCharacter(holdCFrame)
                        task.wait(0.05)
                    end
                end
            end
        else
            if not autoFarmNoCoinsStanding then
                -- Return upright once; do not repeatedly write CFrame/Physics while waiting for new coins.
                releaseAutoFarmAtStandingPosition(autoFarmHoldCFrame)
            end
            task.wait(0.12)
        end
    end
end

function startAutoFarm()
    autoFarmActive = true
    if autoFarmCoinsThread then
        task.cancel(autoFarmCoinsThread)
        autoFarmCoinsThread = nil
    end

    -- If the round has not started (or the player died this round), keep the
    -- feature toggled on but do not move until the next live RoundStart event.
    if not autoFarmRoundActive then
        autoFarmCoinsRunning = false
        autoFarmHoldCFrame = nil
        autoFarmNoCoinsStanding = false
        setOnyxAutoFarmPhysics(false)
        setAutoFarmCharacterNoclip(false)
        restoreAutoFarmCharacterState()
        if type(setAutoFarmCoinReach) == "function" then
            setAutoFarmCoinReach(false)
        end
        return
    end

    autoFarmCoinsRunning = true
    autoFarmFullActionDone = false
    autoFarmNoCoinsStanding = false
    if type(setAutoFarmCoinReach) == "function" then
        setAutoFarmCoinReach(true)
    end

    restoreAutoFarmCharacterState()

    autoFarmCoinsThread = task.spawn(function()
        AutoFarmCoinsFunc()
        autoFarmCoinsThread = nil
    end)
end

function stopAutoFarm()
    autoFarmActive = false
    autoFarmCoinsRunning = false
    autoFarmHoldCFrame = nil
    autoFarmNoCoinsStanding = false

    if autoFarmCurrentTween then
        pcall(function()
            autoFarmCurrentTween:Cancel()
        end)
        autoFarmCurrentTween = nil
    end

    setOnyxAutoFarmPhysics(false)
    setAutoFarmCharacterNoclip(false)
    restoreAutoFarmCharacterState()
    if type(setAutoFarmCoinReach) == "function" then
        setAutoFarmCoinReach(false)
    end

    if autoFarmCoinsThread then
        task.cancel(autoFarmCoinsThread)
        autoFarmCoinsThread = nil
    end

    destroyAutoFarmGodPlatform()
end

stopAutoFarmRoundSession = function()
    autoFarmCoinsRunning = false
    autoFarmRoundToken = (tonumber(autoFarmRoundToken) or 0) + 1
    local lastHold = autoFarmHoldCFrame

    if autoFarmCurrentTween then
        pcall(function() autoFarmCurrentTween:Cancel() end)
        autoFarmCurrentTween = nil
    end

    local character = localPlayer and localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if lastHold and humanoid and humanoid.Health > 0 then
        releaseAutoFarmAtStandingPosition(lastHold)
    else
        autoFarmHoldCFrame = nil
        autoFarmNoCoinsStanding = false
        setOnyxAutoFarmPhysics(false)
        setAutoFarmCharacterNoclip(false)
        restoreAutoFarmCharacterState()
    end

    if type(setAutoFarmCoinReach) == "function" then
        setAutoFarmCoinReach(false)
    end
    if type(destroyAutoFarmGodPlatform) == "function" then
        destroyAutoFarmGodPlatform()
    end
end

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
triggerBotEnabled = false
local triggerBotLastShot = 0
local TRIGGERBOT_DELAY = 0.18
local TRIGGERBOT_FOV = 60
task.spawn(function()
    while task.wait(0.03) do
        if triggerBotEnabled and getRole(localPlayer) == "Sheriff" and os.clock() - triggerBotLastShot >= TRIGGERBOT_DELAY then
            local character = localPlayer and localPlayer.Character
            local gun = character and character:FindFirstChild("Gun")
            local camera = Workspace.CurrentCamera
            if gun and camera then
                local mouse = UserInputService:GetMouseLocation()
                local ray = camera:ViewportPointToRay(mouse.X, mouse.Y)
                local params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Exclude
                params.FilterDescendantsInstances = {character}
                local hit = Workspace:Raycast(ray.Origin, ray.Direction * 500, params)
                local model = hit and hit.Instance and hit.Instance:FindFirstAncestorOfClass("Model")
                local target = model and Players:GetPlayerFromCharacter(model)
                if target and target ~= localPlayer and getRole(target) == "Murderer" and isPlayerAlive(target) then
                    local root = character:FindFirstChild("HumanoidRootPart")
                    local targetRoot = model:FindFirstChild("HumanoidRootPart")
                    local screenPoint, visible
                    if targetRoot then
                        screenPoint, visible = camera:WorldToViewportPoint(targetRoot.Position)
                    end
                    local center = camera.ViewportSize / 2
                    if root and targetRoot and visible and screenPoint.Z > 0
                        and (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude <= TRIGGERBOT_FOV then
                        if fireShotAtTarget(gun, model:FindFirstChild("UpperTorso") or targetRoot) then
                            triggerBotLastShot = os.clock()
                        end
                    end
                end
            end
        end
    end
end)

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
            local torso = character and character:FindFirstChild("UpperTorso")
            local roleIsMurderer = getRole(player) == "Murderer"
            local hasKnife = character and character:FindFirstChild("Knife") ~= nil

            if (roleIsMurderer or hasKnife) and torso and torso:IsA("BasePart") and humanoid and humanoid.Health > 0 then
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

-- Auto Shoot prediction modes. Dropdown changes take effect immediately.
local AUTO_SHOOT_PREDICTION_PROFILES = {
    Legacy = {
        PREDICTION_DISTANCE = 0.01,
        MAX_PREDICTION_OFFSET = 0.03,
        PREDICTION_WEIGHT = 0.03,
        MAX_PING_PREDICTION = 0.06,
        ANTI_JITTER_LOOKBACK = 0.08,
        ELEVATION_Y_OFFSET = -0.1,
        MAX_JITTER_PREDICTION = 0.10,
        JUMP_SPAM_THRESHOLD = 3,
        MAX_PREDICTION_DISTANCE = 0.5,
        HIGH_GROUND_HEIGHT = 4,
        RELATIVE_WEIGHT = 0.25,
        VerticalMode = "Legacy",
    },
    Astral = {
        PREDICTION_DISTANCE = 0.025,
        MAX_PREDICTION_OFFSET = 0.04,
        PREDICTION_WEIGHT = 0.035,
        MAX_PING_PREDICTION = 0.06,
        ANTI_JITTER_LOOKBACK = 0.08,
        ELEVATION_Y_OFFSET = -0.05,
        MAX_JITTER_PREDICTION = 0.12,
        JUMP_SPAM_THRESHOLD = 3,
        MAX_PREDICTION_DISTANCE = 0.9,
        HIGH_GROUND_HEIGHT = 4,
        RELATIVE_WEIGHT = 0.32,
        VerticalMode = "Astral",
    },
}
local autoShootMode = "Legacy"
local autoShootJitterState = setmetatable({}, {__mode = "k"})

function getAutoShootTargetPoint(character)
    if not character then return nil end

    local config = AUTO_SHOOT_PREDICTION_PROFILES[autoShootMode] or AUTO_SHOOT_PREDICTION_PROFILES.Legacy
    local torso = character:FindFirstChild("UpperTorso")
               or character:FindFirstChild("Torso")
               or character:FindFirstChild("HumanoidRootPart")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not torso or not hrp or not humanoid or humanoid.Health <= 0 then
        return nil
    end

    local myChar = game.Players.LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return torso.Position end

    local myPos = myHrp.Position
    local targetPos = torso.Position
    local targetVel = hrp.AssemblyLinearVelocity or hrp.Velocity
    local myVel = myHrp.AssemblyLinearVelocity or myHrp.Velocity
    local relativeVel = targetVel - myVel

    local toMeVector = myPos - targetPos
    local dot = 0
    if toMeVector.Magnitude > 1e-5 and relativeVel.Magnitude > 1e-5 then
        dot = relativeVel.Unit:Dot(toMeVector.Unit)
    end

    local heightDelta = myPos.Y - targetPos.Y
    local isHighGround = heightDelta > config.HIGH_GROUND_HEIGHT

    local currentPing = 0
    if type(getCurrentPing) == "function" then
        currentPing = tonumber(getCurrentPing()) or 0
    end
    local ping = math.min(currentPing / 1000, config.MAX_PING_PREDICTION)
    local delay = ping + config.PREDICTION_DISTANCE

    local weightXZ = config.RELATIVE_WEIGHT * (0.20 / 0.25)
    if isHighGround and dot > 0.3 then
        weightXZ = config.RELATIVE_WEIGHT * (0.05 / 0.25)
    end

    local relativeXZ = Vector3.new(relativeVel.X, 0, relativeVel.Z)
    local hOffset = relativeXZ * delay * weightXZ * config.PREDICTION_WEIGHT

    local now = os.clock()
    local previousMotion = autoShootJitterState[hrp]
    local jittering = false
    if previousMotion and (now - previousMotion.time) <= config.ANTI_JITTER_LOOKBACK then
        local previousVelocity = previousMotion.velocity
        if relativeXZ.Magnitude >= 3 and previousVelocity.Magnitude >= 3 then
            jittering = previousVelocity.Unit:Dot(relativeXZ.Unit) < 0.25
        end
    end
    autoShootJitterState[hrp] = { velocity = relativeXZ, time = now }

    local distanceX = math.clamp(hOffset.X, -config.MAX_PREDICTION_DISTANCE, config.MAX_PREDICTION_DISTANCE)
    local distanceZ = math.clamp(hOffset.Z, -config.MAX_PREDICTION_DISTANCE, config.MAX_PREDICTION_DISTANCE)
    local jitterX = math.clamp(distanceX, -config.MAX_JITTER_PREDICTION, config.MAX_JITTER_PREDICTION)
    local jitterZ = math.clamp(distanceZ, -config.MAX_JITTER_PREDICTION, config.MAX_JITTER_PREDICTION)
    local clampedX = math.clamp(jitterX, -config.MAX_PREDICTION_OFFSET, config.MAX_PREDICTION_OFFSET)
    local clampedZ = math.clamp(jitterZ, -config.MAX_PREDICTION_OFFSET, config.MAX_PREDICTION_OFFSET)

    if jittering then
        clampedX = 0
        clampedZ = 0
    end

    local clampedY = 0
    local state = humanoid:GetState()
    local relYVel = relativeVel.Y
    if config.VerticalMode == "Astral" then
        if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
            clampedY = math.clamp((relYVel - (myVel.Y * 0.35)) * delay * 0.22, -0.4, 0.4)
        elseif math.abs(relYVel) > config.JUMP_SPAM_THRESHOLD then
            clampedY = math.clamp(relYVel * delay * 0.15, -0.3, 0.3)
        end
    else
        if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
            clampedY = math.clamp(relYVel * delay * 0.15, -0.3, 0.3)
        elseif math.abs(relYVel) > config.JUMP_SPAM_THRESHOLD then
            clampedY = math.clamp(relYVel * delay * 0.1, -0.3, 0.3)
        end
    end

    if isHighGround then
        if dot > 0.3 then
            clampedY = clampedY + (heightDelta * 0.02)
        else
            clampedY = clampedY - (heightDelta * 0.01)
        end
        clampedY = clampedY - config.ELEVATION_Y_OFFSET
    end

    return targetPos + Vector3.new(clampedX, clampedY, clampedZ)
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

    local character = targetPart.Parent
    -- Re-read the target part at the exact shot attempt so jukes are followed
    -- by the latest replicated UpperTorso position, with no prediction.
    local latestTargetPart = character:FindFirstChild("UpperTorso")
    if not latestTargetPart or not latestTargetPart:IsA("BasePart") then
        return false
    end

    local origin = handle.Position
    local targetPosition = getAutoShootTargetPoint(character)
    if not targetPosition then
        targetPosition = latestTargetPart.Position
    end

    if (targetPosition - origin).Magnitude < 0.01 then
        return false
    end

    -- Legacy follows Onyx Silent Aim's GunRaycastAttachment firing signature.
    -- Astral keeps the existing direct origin/target CFrame method.
    local originCFrame
    if autoShootMode == "Legacy" then
        local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        local attachment = root and root:FindFirstChild("GunRaycastAttachment")
        originCFrame = attachment and attachment.WorldCFrame or CFrame.new(root and root.Position or origin)
    else
        originCFrame = CFrame.lookAt(origin, targetPosition)
    end
    local targetCFrame = CFrame.new(targetPosition)

    local ok = pcall(function()
        shootEvent:FireServer(originCFrame, targetCFrame)
    end)

    if ok then
        autoShootShotCooldownUntil = os.clock() + AUTO_SHOOT_SHOT_COOLDOWN
        PlaySoundAsset(104895925840852, 1)
        playGunFiredVisual(handle, origin, targetPosition, latestTargetPart)
    end

    return ok
end

function autoShootFlick(gun, targetPart)
    if not gun or not targetPart or not targetPart.Parent then
        return false
    end

    if autoShootFlickBusy then
        return false
    end
    autoShootFlickBusy = true

    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then
        autoShootFlickBusy = false
        return false
    end

    local originPart = gun:FindFirstChild("Handle")
    local origin = originPart and originPart:IsA("BasePart") and originPart.Position or root.Position
    local targetPosition = getAutoShootTargetPoint(targetPart.Parent)
    if not targetPosition then
        autoShootFlickBusy = false
        return false
    end

    local originalLook = root.CFrame.LookVector
    local originalYaw = math.atan2(-originalLook.X, -originalLook.Z)
    local flatTarget = Vector3.new(targetPosition.X, root.Position.Y, targetPosition.Z)
    local flatDirection = flatTarget - root.Position
    if flatDirection.Magnitude <= 0.01 then
        autoShootFlickBusy = false
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

    local ok = pcall(function()
        humanoid.AutoRotate = false

        if root.Parent and targetPart.Parent then
            fired = fireShotAtTarget(gun, targetPart)
        end

        if root.Parent then
            rotateOver(0.1, originalYaw, targetYaw)
        end

        if root.Parent then
            local currentLook = root.CFrame.LookVector
            local currentYaw = math.atan2(-currentLook.X, -currentLook.Z)
            rotateOver(0.1, currentYaw, originalYaw)
        end
    end)

    -- Always restore the player's current position with the original facing direction,
    -- even when a rapid repeated flick or an unexpected error interrupts the rotation.
    if root.Parent then
        local currentPos = root.Position
        root.CFrame = CFrame.new(currentPos) * CFrame.Angles(0, originalYaw, 0)
    end

    pcall(function()
        if humanoid.Parent then
            humanoid.AutoRotate = originalAutoRotate
        end
    end)

    autoShootFlickBusy = false
    return ok and fired
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
        task.wait(0.01)
        currentCharacter = localPlayer.Character
        equippedGun = currentCharacter and currentCharacter:FindFirstChild("Gun")
    end

    if not equippedGun then
        return
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

function UpdateAimbotVisuals()
    -- The aimlock FOV is fixed at 30 and intentionally has no visible circle.
    AimbotCircle.Visible = false
    CircleStroke.Transparency = 1

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
    local character = localPlayer and localPlayer.Character
    local targetCharacter = targetPlayer and targetPlayer.Character
    local targetRoot = targetCharacter and (targetCharacter:FindFirstChild("HumanoidRootPart") or targetCharacter:FindFirstChild("Torso"))
    local humanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
    if not knife or not character or not targetRoot or not humanoid or humanoid.Health <= 0 then return false end
    local events = knife:FindFirstChild("Events")
    local knifeStabbed = events and events:FindFirstChild("KnifeStabbed")
    local handleTouched = events and events:FindFirstChild("HandleTouched")
    if not handleTouched or not handleTouched:IsA("RemoteEvent") then return false end
    equipTool(knife)
    if knifeStabbed and knifeStabbed:IsA("RemoteEvent") then
        pcall(function() knifeStabbed:FireServer() end)
    end
    return pcall(function() handleTouched:FireServer(targetRoot) end)
end

function killAll()
    local character = localPlayer and localPlayer.Character
    local knife = character and character:FindFirstChild("Knife") or getKnife()
    if not knife then return false end
    equipTool(knife)
    task.wait(0.05)
    character = localPlayer.Character
    knife = character and character:FindFirstChild("Knife") or knife
    local events = knife:FindFirstChild("Events")
    local knifeStabbed = events and events:FindFirstChild("KnifeStabbed")
    local handleTouched = events and events:FindFirstChild("HandleTouched")
    if not handleTouched or not handleTouched:IsA("RemoteEvent") then return false end
    if knifeStabbed and knifeStabbed:IsA("RemoteEvent") then
        pcall(function() knifeStabbed:FireServer() end)
    end
    local fired = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local ok = pcall(function() handleTouched:FireServer(targetRoot) end)
                if ok then fired = fired + 1 end
                task.wait(0.05)
            end
        end
    end
    return fired > 0
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

local function restoreTouchFlingPosition()
    local character = touchFlingRestoreCharacter
    local restoreCF = touchFlingRestoreCFrame
    if not character or not restoreCF then
        touchFlingRestoreCFrame = nil
        touchFlingRestoreCharacter = nil
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    local hum = character:FindFirstChildOfClass("Humanoid")
    if root and root.Parent then
        pcall(function()
            root.CFrame = restoreCF
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
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

function SetTouchFling(enabled)
    local nextState = enabled == true

    if nextState then
        if not touchFlingRestoreCFrame then
            local character = localPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root then
                touchFlingRestoreCFrame = root.CFrame
                touchFlingRestoreCharacter = character
            end
        end

        touchFlingEnabled = true
        if not touchFlingThread or coroutine.status(touchFlingThread) == "dead" then
            touchFlingThread = coroutine.create(touchFlingLoop)
            coroutine.resume(touchFlingThread)
        end
    else
        touchFlingEnabled = false
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

    PlaySoundAsset(402143943, 1)

    local part = getGunDrop()
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not part or not hrp then
        return
    end

    local originalCFrame = hrp.CFrame

    pcall(function()
        hrp.CFrame = part.CFrame
    end)

    -- Trigger the touch immediately when the executor exposes firetouchinterest.
    if type(firetouchinterest) == "function" then
        pcall(function()
            firetouchinterest(hrp, part, 0)
            firetouchinterest(hrp, part, 1)
        end)
    end

    task.wait(0.001)

    if hrp.Parent then
        pcall(function()
            hrp.CFrame = originalCFrame
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
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

--// Hitbox Expander (BolongUI controls)
-- Expand other players' HumanoidRootPart and restore original values when disabled.
local function restoreHitboxPart(part)
    local original = hitboxOriginals[part]
    if not original then
        return
    end

    pcall(function()
        if part and part.Parent then
            part.Size = original.Size
            part.CanCollide = original.CanCollide
            part.Transparency = original.Transparency
        end
    end)

    hitboxOriginals[part] = nil
end

local function restoreAllHitboxes()
    for part in pairs(hitboxOriginals) do
        restoreHitboxPart(part)
    end
end

local function updateHitboxes()
    if not hitboxExpandEnabled then
        restoreAllHitboxes()
        return
    end

    local activeParts = {}
    local size = math.clamp(tonumber(hitboxSize) or 8, 1, 30)

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= localPlayer then
            local character = targetPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")

            if root
                and root:IsA("BasePart")
                and humanoid
                and humanoid.Health > 0 then

                if not hitboxOriginals[root] then
                    hitboxOriginals[root] = {
                        Size = root.Size,
                        CanCollide = root.CanCollide,
                        Transparency = root.Transparency
                    }
                end

                activeParts[root] = true

                pcall(function()
                    root.Size = Vector3.new(size, size, size)
                    root.CanCollide = false
                    root.Transparency = 0.6
                end)
            end
        end
    end

    for part in pairs(hitboxOriginals) do
        if not activeParts[part] then
            restoreHitboxPart(part)
        end
    end
end

local function SetHitboxExpand(state)
    hitboxExpandEnabled = state == true
    if not hitboxExpandEnabled then
        restoreAllHitboxes()
    end
end

local function SetHitboxSize(value)
    hitboxSize = math.clamp(tonumber(value) or 8, 1, 30)
end

local HitboxConnection
HitboxConnection = RunService.Heartbeat:Connect(function()
    local success, err = pcall(updateHitboxes)
    if not success then
        warn("[Hitbox Expander] " .. tostring(err))
    end
end)

local invisibleSeat = nil
local invisibleToggleGeneration = 0
local invisibleStagingPosition = Vector3.new(-25.95, 84, 3537.55)

local function restoreInvisibleCharacter(character)
    for part, originalTransparency in pairs(invisibleTransparencyOriginals) do
        local shouldRestore = part and part.Parent
            and (character == nil or part:IsDescendantOf(character))
        if shouldRestore then
            pcall(function()
                part.Transparency = originalTransparency
            end)
            invisibleTransparencyOriginals[part] = nil
        elseif not part or not part.Parent then
            invisibleTransparencyOriginals[part] = nil
        end
    end
end

local function makeCharacterInvisible(character)
    if not character then
        return
    end

    -- Preserve original transparency so turning invisibility off does not
    -- accidentally make normally transparent accessories/parts fully visible.
    restoreInvisibleCharacter(nil)
    invisibleTransparencyOriginals = {}
    walkDescendants(character, function(obj)
        if obj:IsA("BasePart") or obj:IsA("Decal") then
            invisibleTransparencyOriginals[obj] = obj.Transparency
            obj.Transparency = 0.5
        end
    end)
end

local function destroyInvisibleSeat()
    local seat = invisibleSeat
    invisibleSeat = nil
    if seat and seat.Parent then
        pcall(function()
            seat:Destroy()
        end)
    end
end

local function notifyInvisibleState(_enabled)
    -- Intentionally disabled: Invisible should not show a toast or play an alert sound.
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

SetInvisible = function(state, silent)
    local shouldEnable = state == true

    if shouldEnable and invisibleEnabled and invisibleSeat and invisibleSeat.Parent then
        return
    end

    invisibleToggleGeneration = invisibleToggleGeneration + 1
    local generation = invisibleToggleGeneration

    if not shouldEnable then
        local wasEnabled = invisibleEnabled
        invisibleEnabled = false
        destroyInvisibleSeat()
        restoreInvisibleCharacter(nil)
        if wasEnabled and not silent then
            notifyInvisibleState(false)
        end
        return
    end

    invisibleEnabled = true
    destroyInvisibleSeat()
    restoreInvisibleCharacter(nil)

    local character = localPlayer and localPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not root or not humanoid then
        invisibleEnabled = false
        return
    end

    local savedCFrame = root.CFrame

    local moved = pcall(function()
        character:MoveTo(invisibleStagingPosition)
    end)
    if not moved then
        invisibleEnabled = false
        return
    end

    task.wait(0.15)
    if generation ~= invisibleToggleGeneration or not invisibleEnabled
        or not character.Parent or localPlayer.Character ~= character then
        if root.Parent then
            pcall(function()
                root.CFrame = savedCFrame
            end)
        end
        return
    end

    local seat = Instance.new("Seat")
    seat.Name = "invischair"
    seat.Anchored = false
    seat.CanCollide = false
    seat.Transparency = 1
    seat.Position = invisibleStagingPosition
    seat.Parent = Workspace
    invisibleSeat = seat

    local torso = character:FindFirstChild("Torso")
        or character:FindFirstChild("UpperTorso")
        or root
    if not torso or not torso:IsA("BasePart") then
        destroyInvisibleSeat()
        invisibleEnabled = false
        pcall(function()
            root.CFrame = savedCFrame
        end)
        return
    end

    local weld = Instance.new("Weld")
    weld.Part0 = seat
    weld.Part1 = torso
    weld.Parent = seat

    task.wait()
    if generation ~= invisibleToggleGeneration or not invisibleEnabled
        or not seat.Parent or not character.Parent or localPlayer.Character ~= character then
        destroyInvisibleSeat()
        if root.Parent then
            pcall(function()
                root.CFrame = savedCFrame
            end)
        end
        return
    end

    pcall(function()
        seat.CFrame = savedCFrame
    end)
    makeCharacterInvisible(character)

    if InvisiblePanel then
        InvisiblePanel.Visible = invisibleFeatureEnabled
    end
    if not silent then
        notifyInvisibleState(true)
    end
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
    coinsHidden = false,
    hiddenCoins = {},
    pollThread = nil,
    petsHidden = false,
    hiddenPets = {},
}

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
        while CoinOpt.coinsHidden or CoinOpt.petsHidden do
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
        selectedFlingRestoreCFrame = nil
        selectedFlingRestoreCharacter = nil
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
    if selectedFlingThread then
        task.cancel(selectedFlingThread)
        selectedFlingThread = nil
    end
    restoreSelectedFlingPosition()
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
    selectedFlingInProgress = false
end

local function StartSelectedFling()
    local player = selectedFlingPlayerName and Players:FindFirstChild(selectedFlingPlayerName)
    if not player or player == localPlayer then
        selectedFlingEnabled = false
        return
    end

    StopSelectedFling()

    local myChar = localPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myChar or not myRoot then
        selectedFlingEnabled = false
        return
    end

    -- Save the exact position from before Select Fling starts.
    -- Keep it until Select Fling is cancelled so repeated fling cycles
    -- cannot overwrite the restore position.
    selectedFlingRestoreCFrame = myRoot.CFrame
    selectedFlingRestoreCharacter = myChar

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

local function FlingPlayerForDuration(playerName, duration)
    if not playerName then return end
    selectedFlingPlayerName = playerName
    StartSelectedFling()
    task.delay(duration or 2, function()
        if selectedFlingEnabled and selectedFlingPlayerName == playerName then
            StopSelectedFling()
        end
    end)
end

_G.BolongStartFlingRole = function(role)
    local target = FindPlayerByRole(role)
    if target then
        FlingPlayerForDuration(target.Name, 2)
    end
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
    local shouldReapplyInvisible = invisibleEnabled
    if shouldReapplyInvisible then
        -- Clean up the previous character's seat/transparency state, then run
        -- the same invisibility sequence for the newly spawned character.
        SetInvisible(false, true)
        task.delay(0.2, function()
            if shouldReapplyInvisible and character.Parent and localPlayer.Character == character then
                SetInvisible(true, true)
            end
        end)
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

-- PC keyboard shortcuts. Do not reject gameProcessed input: some UI/keybind layers
-- mark the key as processed even though the feature toggle is enabled.
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then
        return
    end

    if input.KeyCode == Enum.KeyCode.E then
        if AutoShootEnabled and MainPanel then
            PlaySoundAsset(88129339693239, 1)
            autoShoot()
        end
        return
    end

    if input.KeyCode == Enum.KeyCode.F then
        if aimbotActive then
            PlaySoundAsset(111044884172919, 1)
            aimlockEngaged = not aimlockEngaged
            aimbotFOVVisible = aimlockEngaged
            if not aimlockEngaged then
                clearAimlockTarget()
            end
            UpdateAimbotVisuals()
        end
        return
    end

    if input.KeyCode == Enum.KeyCode.Q then
        if fakeBombJumpEnabled and fakeBombVariant == "Auto" then
            fireFakeBombThrow()
        end
    end
end)


-- Onyx Auto Grab Gun port (adapted to the existing Chloex UI and PickupPanel).
local onyxGunPickupEnabled = false
local onyxGunPickupThread = nil

local function onyxFindGunDrop()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" and obj.Parent then
            return obj
        end
    end
    return nil
end

local function onyxGrabGunOnce()
    local drop = onyxFindGunDrop()
    local character = localPlayer and localPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not drop or not root then return false end

    local touchPart
    if drop:IsA("BasePart") and drop:FindFirstChild("TouchInterest") then
        touchPart = drop
    else
        for _, descendant in ipairs(drop:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant:FindFirstChild("TouchInterest") then
                touchPart = descendant
                break
            end
        end
    end
    touchPart = touchPart or (drop:IsA("BasePart") and drop)
    if not touchPart then return false end

    for _ = 1, 5 do
        pcall(function()
            if firetouchinterest then
                firetouchinterest(root, touchPart, 0)
                firetouchinterest(root, touchPart, 1)
            end
        end)
        task.wait(0.05)
        local backpack = localPlayer:FindFirstChildOfClass("Backpack")
        if (character and character:FindFirstChild("Gun")) or (backpack and backpack:FindFirstChild("Gun")) then
            return true
        end
    end
    return false
end

local function setOnyxAutoGrabGun(enabled)
    onyxGunPickupEnabled = enabled == true
    if onyxGunPickupThread then
        pcall(task.cancel, onyxGunPickupThread)
        onyxGunPickupThread = nil
    end
    if onyxGunPickupEnabled then
        onyxGunPickupThread = task.spawn(function()
            while onyxGunPickupEnabled do
                local character = localPlayer and localPlayer.Character
                local backpack = localPlayer and localPlayer:FindFirstChildOfClass("Backpack")
                if not (character and character:FindFirstChild("Gun") or backpack and backpack:FindFirstChild("Gun")) then
                    onyxGrabGunOnce()
                end
                task.wait(0.12)
            end
        end)
    end
end

-- Minimal distance label renderer for the Player Distance section.
local playerDistanceEnabled = false
local playerDistanceConnection
local playerDistanceLabels = {}
local function clearPlayerDistanceLabels()
    for player, gui in pairs(playerDistanceLabels) do
        pcall(function() gui:Destroy() end)
        playerDistanceLabels[player] = nil
    end
end
Players.PlayerRemoving:Connect(function(player)
    local gui = playerDistanceLabels[player]
    if gui then pcall(function() gui:Destroy() end); playerDistanceLabels[player] = nil end
end)
local function setPlayerDistance(enabled)
    playerDistanceEnabled = enabled == true
    if playerDistanceConnection then
        playerDistanceConnection:Disconnect()
        playerDistanceConnection = nil
    end
    if not playerDistanceEnabled then
        clearPlayerDistanceLabels()
        return
    end
    playerDistanceConnection = RunService.RenderStepped:Connect(function()
        local myRoot = localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then
            clearPlayerDistanceLabels()
            return
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local gui = playerDistanceLabels[player]
                    if not gui or not gui.Parent then
                        gui = Instance.new("BillboardGui")
                        gui.Name = "BolongPlayerDistance"
                        gui.Size = UDim2.fromOffset(100, 22)
                        gui.StudsOffset = Vector3.new(0, -3.2, 0)
                        gui.AlwaysOnTop = true
                        local label = Instance.new("TextLabel")
                        label.BackgroundTransparency = 1
                        label.Size = UDim2.fromScale(1, 1)
                        label.Font = Enum.Font.GothamBold
                        label.TextSize = 12
                        label.TextStrokeTransparency = 0.25
                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        label.Parent = gui
                        gui.Parent = root
                        playerDistanceLabels[player] = gui
                    end
                    local label = gui:FindFirstChildOfClass("TextLabel")
                    if label then
                        label.Text = string.format("%d studs", math.floor((myRoot.Position - root.Position).Magnitude + 0.5))
                    end
                elseif playerDistanceLabels[player] then
                    playerDistanceLabels[player]:Destroy()
                    playerDistanceLabels[player] = nil
                end
            elseif playerDistanceLabels[player] then
                playerDistanceLabels[player]:Destroy()
                playerDistanceLabels[player] = nil
            end
        end
    end)
end


-- Additional Onyx-compatible feature adapters (kept independent from WindUI internals).
local onyxTrapEspEnabled = false
local onyxTrapHighlights = {}
local onyxTrapColor = Color3.fromHex("#A855F7")
local function clearOnyxTrapEsp()
    for trap, highlight in pairs(onyxTrapHighlights) do
        pcall(function() highlight:Destroy() end)
        onyxTrapHighlights[trap] = nil
    end
end
local function refreshOnyxTrapEsp()
    if not onyxTrapEspEnabled then clearOnyxTrapEsp(); return end
    local found = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "Trap" and (obj:IsA("BasePart") or obj:IsA("Model")) then
            found[obj] = true
            local h = onyxTrapHighlights[obj]
            if not h or not h.Parent then
                h = Instance.new("Highlight")
                h.Name = "BolongTrapESP"
                h.Adornee = obj
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.FillTransparency = 0.72
                h.OutlineTransparency = 0.05
                h.Parent = PlayerGui
                onyxTrapHighlights[obj] = h
            end
            h.FillColor = onyxTrapColor
            h.OutlineColor = onyxTrapColor
        end
    end
    for trap, h in pairs(onyxTrapHighlights) do
        if not found[trap] or not trap.Parent then
            pcall(function() h:Destroy() end)
            onyxTrapHighlights[trap] = nil
        end
    end
end
Workspace.DescendantAdded:Connect(function(obj)
    if onyxTrapEspEnabled and obj.Name == "Trap" then task.defer(refreshOnyxTrapEsp) end
end)
Workspace.DescendantRemoving:Connect(function(obj)
    local h = onyxTrapHighlights[obj]
    if h then pcall(function() h:Destroy() end); onyxTrapHighlights[obj] = nil end
end)

local onyxAutoHopDeadServer = false
local onyxAutoHopElapsed = 0
task.spawn(function()
    local TeleportService = game:GetService("TeleportService")
    while true do
        task.wait(3)
        if not onyxAutoHopDeadServer then
            onyxAutoHopElapsed = 0
        elseif #Players:GetPlayers() < 2 then
            onyxAutoHopElapsed = onyxAutoHopElapsed + 3
            if onyxAutoHopElapsed >= 15 then
                onyxAutoHopElapsed = 0
                pcall(function() TeleportService:Teleport(game.PlaceId, localPlayer) end)
            end
        else
            onyxAutoHopElapsed = 0
        end
    end
end)

local onyxAutoClaimShells = false
local function claimSummerRewardPopup()
    local gui = localPlayer and localPlayer:FindFirstChild("PlayerGui")
    if not gui then return false end
    for _, button in ipairs(gui:GetDescendants()) do
        if (button:IsA("TextButton") or button:IsA("ImageButton")) and button.Name == "Claim" and button.Visible then
            local ancestor = button.Parent
            local matched = false
            for _ = 1, 5 do
                if not ancestor then break end
                local names = (ancestor.Name .. " " .. (ancestor.Parent and ancestor.Parent.Name or "")):lower()
                if names:find("reward", 1, true) or names:find("shell", 1, true) or names:find("summer", 1, true) then
                    matched = true
                    break
                end
                ancestor = ancestor.Parent
            end
            if matched then
                local clicked = false
                pcall(function()
                    local vim = game:GetService("VirtualInputManager")
                    local pos, size = button.AbsolutePosition, button.AbsoluteSize
                    local x, y = pos.X + size.X / 2, pos.Y + size.Y / 2 + 36
                    vim:SendMouseButtonEvent(x, y, 0, true, game, 1)
                    task.wait(0.04)
                    vim:SendMouseButtonEvent(x, y, 0, false, game, 1)
                    clicked = true
                end)
                if not clicked then
                    pcall(function() if firesignal then firesignal(button.Activated) else button:Activate() end end)
                end
                return true
            end
        end
    end
    return false
end

task.spawn(function()
    while true do
        if onyxAutoClaimShells then pcall(claimSummerRewardPopup) end
        task.wait(0.5)
    end
end)

local onyxBoxNames = {"Summer2026Box", "MysteryBox1", "MysteryBox2", "KnifeBox1", "KnifeBox2", "KnifeBox3", "KnifeBox4", "KnifeBox5", "GunBox1", "GunBox2", "GunBox3", "MLG Box"}
local onyxBoxEnabled = false
local onyxSelectedBox = "Summer2026Box"
task.spawn(function()
    while true do
        if onyxBoxEnabled then
            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
            local shop = remotes and remotes:FindFirstChild("Shop")
            local openCrate = shop and shop:FindFirstChild("OpenCrate")
            if openCrate and openCrate:IsA("RemoteFunction") then
                local currency = onyxSelectedBox == "Summer2026Box" and "SummerKey2026" or "Coins"
                local canAfford = false
                local okData, profile = pcall(function()
                    return require(game:GetService("ReplicatedStorage").Modules.ProfileData)
                end)
                local okShop, shopData = pcall(function()
                    return require(game:GetService("ReplicatedStorage").Database.Sync.NewShop)
                end)
                if okData and type(profile) == "table" and okShop and type(shopData) == "table" then
                    local owned = profile.Materials and profile.Materials.Owned
                    local boxInfo = shopData[onyxSelectedBox]
                    local priceTable = type(boxInfo) == "table" and boxInfo.Price
                    local price = type(priceTable) == "table" and tonumber(priceTable[currency])
                    local funds = type(owned) == "table" and tonumber(owned[currency])
                    if price and funds then canAfford = funds >= price end
                end
                if canAfford then
                    pcall(function() openCrate:InvokeServer(onyxSelectedBox, "MysteryBox", currency) end)
                    task.wait(1)
                else
                    task.wait(5)
                end
            else
                onyxBoxEnabled = false
                task.wait(1)
            end
        else
            task.wait(0.25)
        end
    end
end)

local onyxKnifeReach = 1.5
local onyxKnifeMultiplier = 1
local onyxKnifeReachEnabled = false
local onyxKnifeReachShow = false
local onyxKnifeReachSphere
local onyxKnifeReachVisualConnection
local onyxKnifeReachMouseConnection
local function updateOnyxKnifeReachSphere()
    if not onyxKnifeReachShow then
        if onyxKnifeReachSphere then onyxKnifeReachSphere:Destroy(); onyxKnifeReachSphere = nil end
        if onyxKnifeReachVisualConnection then onyxKnifeReachVisualConnection:Disconnect(); onyxKnifeReachVisualConnection = nil end
        return
    end
    if not onyxKnifeReachSphere then
        local part = Instance.new("Part")
        part.Name = "BolongKnifeReachVisual"
        part.Shape = Enum.PartType.Ball
        part.Anchored = true
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.Material = Enum.Material.Neon
        part.Color = Color3.fromRGB(255, 90, 90)
        part.Transparency = 0.88
        part.Parent = Workspace.CurrentCamera
        onyxKnifeReachSphere = part
    end
    if onyxKnifeReachVisualConnection then onyxKnifeReachVisualConnection:Disconnect() end
    onyxKnifeReachVisualConnection = RunService.RenderStepped:Connect(function()
        local char = localPlayer.Character
        local handle = char and char:FindFirstChild("Knife") and char.Knife:FindFirstChild("Handle")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local pos = handle and handle.Position or root and root.Position
        if pos and onyxKnifeReachSphere then
            onyxKnifeReachSphere.Size = Vector3.one * onyxKnifeReach * 2
            onyxKnifeReachSphere.CFrame = CFrame.new(pos)
        end
    end)
end
local function startOnyxKnifeReach()
    if onyxKnifeReachEnabled then return end
    onyxKnifeReachEnabled = true
    local mouse = localPlayer:GetMouse()
    onyxKnifeReachMouseConnection = mouse.Button1Down:Connect(function()
        if not onyxKnifeReachEnabled or getRole(localPlayer) ~= "Murderer" then return end
        local char = localPlayer.Character
        local knife = char and char:FindFirstChild("Knife")
        local events = knife and knife:FindFirstChild("Events")
        local handleTouched = events and events:FindFirstChild("HandleTouched")
        local knifeStabbed = events and events:FindFirstChild("KnifeStabbed")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not handleTouched or not root then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if targetRoot and hum and hum.Health > 0 and (targetRoot.Position - root.Position).Magnitude <= onyxKnifeReach then
                    if knifeStabbed and knifeStabbed:IsA("RemoteEvent") then
                        pcall(function() knifeStabbed:FireServer() end)
                    end
                    pcall(function() handleTouched:FireServer(targetRoot) end)
                end
            end
        end
    end)
end
local function stopOnyxKnifeReach()
    onyxKnifeReachEnabled = false
    if onyxKnifeReachMouseConnection then onyxKnifeReachMouseConnection:Disconnect(); onyxKnifeReachMouseConnection = nil end
end

local onyxCrosshairGui
local onyxCrosshairImage
local onyxCrosshairConnection
local onyxCrosshairEnabled = false
local onyxCrosshairStyle = "Default"
local onyxCrosshairSize = 50
local onyxCrosshairSpin = false
local onyxCrosshairOnlyWithGun = false
local onyxCrosshairOriginalMouseIcon = UserInputService.MouseIconEnabled
local ONYX_CROSSHAIRS = {
    Default = "", Paw = "rbxassetid://11767069582", Gengar = "rbxassetid://11759293285",
    Bunny = "rbxassetid://1912438810", ["Hello Kitty"] = "rbxassetid://11351620343",
    ["Kitty v2"] = "rbxassetid://11802094220", Heart = "rbxthumb://type=Asset&w=420&h=420&id=11722368344",
    Pentagram = "rbxassetid://51838212", Star = "rbxassetid://11716559277", ["Star v2"] = "rbxassetid://11716557686",
    Osu = "rbxassetid://8390115370", ["Power Star"] = "rbxassetid://1718840561", Troll = "rbxassetid://12438907427",
    Cross = "rbxthumb://type=Asset&w=420&h=420&id=14034486267", ["Pink Star"] = "rbxthumb://type=Asset&w=420&h=420&id=11719595129",
    Kuromi = "rbxthumb://type=Asset&w=420&h=420&id=11893991373", ["Red Heart"] = "rbxthumb://type=Asset&w=420&h=420&id=11754042886",
    ["Green Heart"] = "rbxthumb://type=Asset&w=420&h=420&id=11754039821", ["Blue Heart"] = "rbxthumb://type=Asset&w=420&h=420&id=11754037423",
    ["Yellow Heart"] = "rbxthumb://type=Asset&w=420&h=420&id=11754042019", ["Heart Cross"] = "rbxassetid://11739569678",
    ["Clean Kitty"] = "rbxassetid://11718192673", ["Pixel Cat"] = "rbxassetid://10878214990",
    ["Evil Kitty"] = "rbxassetid://11734940424", ["Vamp Face"] = "rbxassetid://11734893655",
    ["Glowing Circle"] = "rbxassetid://10891594349", Bear = "rbxassetid://11722088774",
    ["Shoot this guy"] = "rbxassetid://8680062686", Barbie = "rbxassetid://11754489642",
    Death = "rbxassetid://12472046162", Donut = "rbxassetid://11717104785", Cat = "rbxassetid://11722553511",
    ["Blue Donut"] = "rbxassetid://11717093063",
}
local function updateOnyxCrosshair()
    if not onyxCrosshairImage then return end
    onyxCrosshairImage.Image = ONYX_CROSSHAIRS[onyxCrosshairStyle] or ""
    onyxCrosshairImage.Size = UDim2.fromOffset(onyxCrosshairSize, onyxCrosshairSize)
    if onyxCrosshairStyle == "Default" then onyxCrosshairImage.Visible = false end
end
local function setOnyxCrosshair(enabled)
    onyxCrosshairEnabled = enabled == true
    if onyxCrosshairConnection then onyxCrosshairConnection:Disconnect(); onyxCrosshairConnection = nil end
    if onyxCrosshairGui then onyxCrosshairGui:Destroy(); onyxCrosshairGui = nil; onyxCrosshairImage = nil end
    UserInputService.MouseIconEnabled = onyxCrosshairOriginalMouseIcon
    if not onyxCrosshairEnabled or onyxCrosshairStyle == "Default" then return end
    local gui = Instance.new("ScreenGui")
    gui.Name = "BolongOnyxCrosshair"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10000
    gui.Parent = PlayerGui
    local image = Instance.new("ImageLabel")
    image.Name = "Crosshair"
    image.BackgroundTransparency = 1
    image.AnchorPoint = Vector2.new(0.5, 0.5)
    image.Size = UDim2.fromOffset(onyxCrosshairSize, onyxCrosshairSize)
    image.Image = ONYX_CROSSHAIRS[onyxCrosshairStyle] or ""
    image.ScaleType = Enum.ScaleType.Stretch
    image.Parent = gui
    onyxCrosshairGui, onyxCrosshairImage = gui, image
    onyxCrosshairOriginalMouseIcon = UserInputService.MouseIconEnabled
    onyxCrosshairConnection = RunService.RenderStepped:Connect(function(dt)
        if not image.Parent then return end
        local hasGun = localPlayer.Character and localPlayer.Character:FindFirstChild("Gun")
        local visible = not onyxCrosshairOnlyWithGun or hasGun ~= nil
        image.Visible = visible
        if visible then
            UserInputService.MouseIconEnabled = false
            local pos = UserInputService:GetMouseLocation()
            image.Position = UDim2.fromOffset(pos.X, pos.Y)
        else
            UserInputService.MouseIconEnabled = onyxCrosshairOriginalMouseIcon
        end
        if onyxCrosshairSpin then image.Rotation = (image.Rotation + dt * 55) % 360 else image.Rotation = 0 end
    end)
end


--==================================================
-- Onyx-compatible local visual skin inventory adapter
-- This mirrors Onyx's client-side ProfileData approach; it does NOT grant
-- permanent/server-side ownership or change other players' inventories.
--==================================================
local onyxSkinState = {
    loaded = false,
    profile = nil,
    weapons = nil,
    equipService = nil,
    inventoryChanged = nil,
    baselineOwned = {},
    baselineEquipped = {},
    selectedKnife = nil,
    showChroma = true,
}

local function loadOnyxSkinData()
    if onyxSkinState.loaded and onyxSkinState.profile and onyxSkinState.weapons then
        return true
    end
    local rs = game:GetService("ReplicatedStorage")
    local okProfile, profile = pcall(function()
        return require(rs:WaitForChild("Modules"):WaitForChild("ProfileData"))
    end)
    local okWeapons, weapons = pcall(function()
        return require(rs:WaitForChild("Database"):WaitForChild("Sync")).Weapons
    end)
    if not okProfile or type(profile) ~= "table" or not okWeapons or type(weapons) ~= "table" then
        return false, "ProfileData/Weapons database unavailable"
    end
    onyxSkinState.profile = profile
    onyxSkinState.weapons = weapons
    local okEquip, equipService = pcall(function()
        local client = rs:FindFirstChild("Client") or rs:FindFirstChild("ClientServices")
        return client and require(client:FindFirstChild("EquipService", true))
    end)
    if okEquip then onyxSkinState.equipService = equipService end
    local okChanged, changed = pcall(function()
        local client = rs:FindFirstChild("Client") or rs:FindFirstChild("ClientServices")
        local data = client and client:FindFirstChild("InventoryDataChanged", true)
        return data
    end)
    if okChanged then onyxSkinState.inventoryChanged = changed end
    local owned = profile.Weapons and profile.Weapons.Owned
    local equipped = profile.Weapons and profile.Weapons.Equipped
    if type(owned) ~= "table" or type(equipped) ~= "table" then
        return false, "Weapon inventory data unavailable"
    end
    for key, value in pairs(owned) do onyxSkinState.baselineOwned[key] = value end
    for key, value in pairs(equipped) do onyxSkinState.baselineEquipped[key] = value end
    onyxSkinState.loaded = true
    return true
end

local function getOnyxSkinNames(itemType, includeChroma)
    local ok = loadOnyxSkinData()
    if not ok then return {} end
    local names = {}
    for key, data in pairs(onyxSkinState.weapons) do
        if type(data) == "table" and data.ItemType == itemType then
            local rarity = tostring(data.Rarity or "")
            local isChroma = rarity:lower():find("chroma", 1, true) ~= nil or tostring(key):lower():find("chroma", 1, true) ~= nil
            if includeChroma or not isChroma then
                names[#names + 1] = key
            end
        end
    end
    table.sort(names)
    return names
end

local function fireOnyxInventoryChanged(key, amount)
    local event = onyxSkinState.inventoryChanged
    if event and event:IsA("BindableEvent") then
        pcall(function() event:Fire("Weapons", key, amount) end)
    end
end

local function onyxUnlockLocalSkins(itemType)
    local ok, err = loadOnyxSkinData()
    if not ok then
        Chloex:Notify({Title = "Skins", Content = tostring(err), Duration = 4})
        return
    end
    local owned = onyxSkinState.profile.Weapons.Owned
    local count = 0
    for key, data in pairs(onyxSkinState.weapons) do
        if type(data) == "table" and data.ItemType == itemType then
            if owned[key] == nil or tonumber(owned[key]) == 0 then
                owned[key] = 1
                fireOnyxInventoryChanged(key, 1)
                count = count + 1
            end
        end
    end
    Chloex:Notify({Title = "Local Visual Skins", Content = ("Added %d %s skins to the local inventory view only."):format(count, itemType:lower()), Duration = 4})
end

local startOnyxVisualSkinChanger

local function onyxUnlockAllLocalSkins()
    -- Keep this change isolated to Unlock All:
    -- use the exact same spawn call as clicking each tile in the Onyx skin GUI.
    local visual = _G.__MM2Viz
    if type(visual) ~= "table" or type(visual.spawn) ~= "function" then
        local startOk, startResult = startOnyxVisualSkinChanger()
        if not startOk or type(startResult) ~= "table" or type(startResult.spawn) ~= "function" then
            Chloex:Notify({
                Title = "Visual Skin Changer",
                Content = "Couldn't start the Onyx model renderer: " .. tostring(startResult),
                Duration = 5
            })
            return
        end
        visual = startResult
    end

    local counts = {Gun = 0, Knife = 0}
    local failed = 0

    -- Exactly mirror the GUI tile callback: spawn(item.key, 1).
    -- Do not use a separate inventory refresh path here.
    for index, item in ipairs(visual.list or {}) do
        local key = item.key
        local itemType = item.type
        if key and (itemType == "Gun" or itemType == "Knife") then
            local ok = pcall(function()
                visual.spawn(key, 1)
            end)

            if ok then
                counts[itemType] = counts[itemType] + 1
            else
                failed = failed + 1
            end
        end

        if index % 25 == 0 then
            task.wait()
        end
    end

    -- Rebuild only the currently held overlays after the inventory events.
    task.wait(0.15)
    if type(visual.refreshEquipped) == "function" then
        pcall(function()
            visual.refreshEquipped()
        end)
    end

    Chloex:Notify({
        Title = "Unlock All Skin",
        Content = ("Added %d gun skins and %d knife skins using the same GUI spawn method.%s"):format(
            counts.Gun, counts.Knife,
            failed > 0 and (" " .. failed .. " items failed.") or ""
        ),
        Duration = 6
    })
end

local function onyxApplySelectedKnife()
    local ok, err = loadOnyxSkinData()
    if not ok then
        Chloex:Notify({Title = "Skins", Content = tostring(err), Duration = 4})
        return
    end
    local key = onyxSkinState.selectedKnife
    local data = key and onyxSkinState.weapons[key]
    if not data or data.ItemType ~= "Knife" then
        Chloex:Notify({Title = "Skins", Content = "Select a valid knife first.", Duration = 3})
        return
    end
    onyxSkinState.profile.Weapons.Owned[key] = math.max(1, tonumber(onyxSkinState.profile.Weapons.Owned[key]) or 0)
    onyxSkinState.profile.Weapons.Equipped.Knife = key
    fireOnyxInventoryChanged(key, onyxSkinState.profile.Weapons.Owned[key])
    if onyxSkinState.equipService and onyxSkinState.equipService.EquippedChanged then
        pcall(function() onyxSkinState.equipService.EquippedChanged:Fire("Knife", key) end)
    end
    Chloex:Notify({Title = "Skins", Content = data.ItemName or key .. " selected locally. Visual only.", Duration = 3})
end

local function onyxDespawnLocalVisualSkins()
    -- Stop the same visual-skin renderer used by Onyx when it is present.
    if type(_G.__MM2Viz) == "table" and type(_G.__MM2Viz.destroy) == "function" then
        pcall(_G.__MM2Viz.destroy)
        _G.__MM2Viz = nil
    end
    local ok, err = loadOnyxSkinData()
    if not ok then
        Chloex:Notify({Title = "Skins", Content = tostring(err), Duration = 4})
        return
    end
    local owned = onyxSkinState.profile.Weapons.Owned
    local changed = 0
    for key, data in pairs(onyxSkinState.weapons) do
        if type(data) == "table" and (data.ItemType == "Knife" or data.ItemType == "Gun") then
            local original = onyxSkinState.baselineOwned[key]
            if owned[key] ~= original then
                owned[key] = original
                fireOnyxInventoryChanged(key, original or 0)
                changed = changed + 1
            end
        end
    end
    for itemType, key in pairs(onyxSkinState.baselineEquipped) do
        if onyxSkinState.profile.Weapons.Equipped[itemType] ~= key then
            onyxSkinState.profile.Weapons.Equipped[itemType] = key
            if onyxSkinState.equipService and onyxSkinState.equipService.EquippedChanged then
                pcall(function() onyxSkinState.equipService.EquippedChanged:Fire(itemType, key) end)
            end
        end
    end
    Chloex:Notify({Title = "Skins", Content = ("Restored %d local visual inventory entries."):format(changed), Duration = 3})
end


onyxWebhookUrl = ""
onyxWebhookEnabled = false
function sendOnyxWebhook(message)
    if not onyxWebhookEnabled or onyxWebhookUrl == "" then return end
    local okBody, body = pcall(function()
        return game:GetService("HttpService"):JSONEncode({content = tostring(message)})
    end)
    if not okBody then return end
    local requestFn = (syn and syn.request) or http_request or request
    if type(requestFn) ~= "function" then return end
    pcall(function()
        requestFn({Url = onyxWebhookUrl, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body})
    end)
end


local function buildOnyxVisualSkinEngine()
	local Players_ = game:GetService("Players")
	local ReplicatedStorage_ = game:GetService("ReplicatedStorage")
	game:GetService("InsertService")
	local localPlayer2 = Players_.LocalPlayer

	pcall(function()
		if setthreadidentity then
			setthreadidentity(2)
		end
	end)

	if _G.__MM2Viz and _G.__MM2Viz.destroy then
		pcall(_G.__MM2Viz.destroy)
	end

	local mM2Viz = { conns = {} }
	_G.__MM2Viz = mM2Viz
	local EquipService = require(ReplicatedStorage_:WaitForChild("ClientServices"):WaitForChild("EquipService"))
	local Sync = require(ReplicatedStorage_:WaitForChild("Database"):WaitForChild("Sync"))
	local ProfileData = require(ReplicatedStorage_:WaitForChild("Modules"):WaitForChild("ProfileData"))
	local weapons = Sync.Weapons
	local inventoryDataChanged = ReplicatedStorage_:WaitForChild("Remotes"):WaitForChild("Inventory"):WaitForChild("InventoryDataChanged")

	local function fn59(arg)
		local ok, result = pcall(function()
			return game:HttpGet(arg, true)
		end)

		if ok and type(result) == "string" and #result > 0 then
			return result
		end
		local request_ = syn and syn.request or request or http_request or http and http.request
		if not request_ then
			return nil, tostring(result)
		end
		local ok2, result2 = pcall(request_, { Url = arg, Method = "GET" })
		if ok2 and type(result2) == "table" and type(result2.Body) == "string" and #result2.Body > 0 then
			return result2.Body
		end
		return nil, tostring(ok2 and result2 and result2.StatusCode or result2)
	end

	local lua = nil

	if isfile and readfile and isfile("OnyxV2/weapon.lua") then
		local ok, result = pcall(readfile, "OnyxV2/weapon.lua")

		if ok and type(result) == "string" and #result > 100000 then
			lua = result
		end
	end

	local flag16 = lua ~= nil
	local v11 = nil

	if not lua then
		lua, v11 = fn59("https://raw.githubusercontent.com/kroxn/visual/refs/heads/main/weapon.lua")
	end

	if not lua then
		error("[MM2Viz] could not fetch mesh data from " .. "https://raw.githubusercontent.com/kroxn/visual/refs/heads/main/weapon.lua" .. " -- " .. tostring(v11), 0)
	end

	local chunk, v12 = loadstring(lua .. "\nreturn MESHES_FULL")

	if not chunk and flag16 then
		lua = fn59("https://raw.githubusercontent.com/kroxn/visual/refs/heads/main/weapon.lua")
		chunk = lua and loadstring(lua .. "\nreturn MESHES_FULL")
		flag16 = false
		v12 = nil
	end

	if not chunk then
		error("[MM2Viz] mesh data failed to compile -- " .. tostring(v12), 0)
	end

	if not flag16 and writefile then
		pcall(function()
			if makefolder and isfolder and not isfolder("OnyxV2") then
				makefolder("OnyxV2")
			end

			writefile("OnyxV2/weapon.lua", lua)
		end)
	end

	local v13 = chunk()

	if type(v13) ~= "table" or next(v13) == nil then
		error("[MM2Viz] fetched file produced no MESHES_FULL table (is the URL the data file?)", 0)
	end

	local tbl13 = {}

	for k, v14 in pairs(v13) do
		tbl13[k] = v14
	end

	local sweetChroma = tbl13.SweetChroma

	if sweetChroma and sweetChroma.Model and not tbl13.Sweet then
		local fn60 = nil

		fn60 = function(arg)
			local tbl14 = { Class = arg.Class, Id = arg.Id, Name = arg.Name, Props = arg.Props, Tags = arg.Tags }

			if arg.Children then
				tbl14.Children = {}

				for _, child in ipairs(arg.Children) do
					if not (child.Class == "Decal" and child.Name == "Chroma") then
						tbl14.Children[#tbl14.Children + 1] = fn60(child)
					end
				end
			end

			return tbl14
		end

		local tbl14 = {}
		local v14 = pairs
		local meta = sweetChroma.Meta or {}

		for k, v15 in v14(meta) do
			tbl14[k] = v15
		end

		tbl14.Chroma = nil
		tbl13.Sweet = { Complete = false, Meta = tbl14, Model = fn60(sweetChroma.Model) }
	end

	local tbl14 = { Godly = true, Ancient = true }

	local function fn60(arg)
		local str = tostring(arg or "")
		return str == "" or str:match("^%?+$") ~= nil
	end

	local tbl15 = {}
	local n4 = 0

	for k, v14 in pairs(tbl13) do
		local v15 = weapons[k]

		if type(v15) == "table" and (v15.ItemType == "Knife" or v15.ItemType == "Gun") and tbl14[v15.Rarity] and not fn60(v15.ItemName) then
			tbl15[k] = v14
		else
			n4 += 1
		end
	end

	local v14 = tbl15
	local n5 = 0
	local n6 = 0

	for _, v15 in pairs(v14) do
		n5 += 1

		if v15.Model then
			n6 += 1
		end
	end

	local RunService_ = game:GetService("RunService")
	local CollectionService_ = game:GetService("CollectionService")

	local function fn61(arg)
		if type(arg) == "string" then
			return (arg:gsub("^%s+", ""):gsub("%s+$", ""))
		end
		return arg
	end

	local function fn62(arg, arg2, arg3)
		for k, v15 in pairs(arg2) do
			if not (arg3 and arg3[k]) then
				if k == "MeshId" or k == "TextureId" or k == "TextureID" or k == "Texture" then
					v15 = fn61(v15)
				end

				pcall(function()
					arg[k] = v15
				end)
			end
		end
	end

	local function createPart(arg)
		local v15 = fn61(arg.MeshId or "")
		local size = arg.Size or Vector3.one
		local v16 = nil

		pcall(function()
			v16 = game:GetService("InsertService"):CreateMeshPartAsync(v15, Enum.CollisionFidelity.Box, Enum.RenderFidelity.Precise)
		end)

		if v16 then
			pcall(function()
				v16.Size = size
			end)

			return v16
		end

		local part = Instance.new("Part")
		part.Size = size
		local specialMesh = Instance.new("SpecialMesh")
		specialMesh.MeshType = Enum.MeshType.FileMesh

		pcall(function()
			specialMesh.MeshId = v15
		end)

		pcall(function()
			specialMesh.TextureId = fn61(arg.TextureID or "")
		end)

		specialMesh.Parent = part
		return part
	end

	local tbl16 = {}
	local color2 = Color3.fromRGB(255, 0, 0)
	local color3 = Color3.fromRGB(255, 255, 0)
	local color4 = Color3.fromRGB(0, 255, 0)
	local color5 = Color3.fromRGB(0, 255, 255)
	local color6 = Color3.fromRGB(0, 0, 255)
	local color7 = Color3.fromRGB
	tbl16[1] = color2
	tbl16[2] = color3
	tbl16[3] = color4
	tbl16[4] = color5
	tbl16[5] = color6

	do
		local values = table.pack(color7(255, 0, 255))
		table.move(values, 1, values.n, 6, tbl16)
	end

	local function fn63(arg)
		local n7 = #tbl16
		local n8 = arg % n7
		local n9 = math.floor(n8)
		return tbl16[n9 + 1]:Lerp(tbl16[(n9 + 1) % n7 + 1], n8 - n9)
	end

	local function fn64(arg, arg2)
		if arg2.Meta and arg2.Meta.Chroma == true then
			return true
		end
		return arg:sub(-6) == "Chroma"
	end

	local n7 = 1.8
	local texture = "rbxassetid://18363392181"

	local function fn65(arg)
		local tbl17 = {}
		local tbl18 = {}
		local tbl19 = {}
		local tbl20 = {}
		local flag17 = false

		for _, descendant in ipairs(arg:GetDescendants()) do
			local attribute = descendant:GetAttribute("MM2Chroma")

			if attribute then
				if attribute == "part" then
					tbl17[#tbl17 + 1] = descendant
					flag17 = true
				elseif attribute == "decal" and descendant:IsA("Decal") then
					pcall(function()
						descendant.Texture = texture
					end)

					tbl18[#tbl18 + 1] = descendant
					flag17 = true
				else
					flag17 = true

					if attribute == "fire" then
						tbl19[#tbl19 + 1] = descendant
					end
				end
			end
		end

		if not flag17 then
			for _, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("BasePart") and (descendant.Material == Enum.Material.Neon or descendant.Name:lower():find("light")) then
					tbl17[#tbl17 + 1] = descendant
				elseif descendant:IsA("Decal") and descendant.Name:lower():find("chroma") then
					tbl18[#tbl18 + 1] = descendant
				elseif descendant:IsA("Fire") then
					tbl19[#tbl19 + 1] = descendant
				end
			end

			if #tbl18 == 0 then
				tbl19[#tbl19 + 1] = arg
			end
		end

		local tbl21 = {}

		for _, v15 in ipairs(tbl19) do
			if v15:IsA("BasePart") then
				tbl21[v15] = true
			end
		end

		for _, v15 in ipairs(tbl17) do
			tbl21[v15] = nil
		end

		for _, descendant in ipairs(arg:GetDescendants()) do
			if descendant:IsA("SpecialMesh") and descendant.TextureId ~= "" and tbl21[descendant.Parent] then
				tbl20[#tbl20 + 1] = descendant
			end
		end

		if arg:IsA("Part") and tbl21[arg] then
			local specialMesh = arg:FindFirstChildWhichIsA("SpecialMesh")

			if specialMesh and specialMesh.TextureId ~= "" then
				tbl20[#tbl20 + 1] = specialMesh
			end
		end

		if #tbl17 == 0 and #tbl18 == 0 and #tbl19 == 0 and #tbl20 == 0 then
			return nil
		end

		return RunService_.Heartbeat:Connect(function()
			local now = os.clock()
			local v15 = fn63(now)

			for _, v16 in ipairs(tbl18) do
				v16.Color3 = v15
			end

			for _, v16 in ipairs(tbl20) do
				v16.VertexColor = Vector3.new(v15.R, v15.G, v15.B)
			end

			for _, v16 in ipairs(tbl19) do
				if v16:IsA("Fire") then
					v16.Color = v15
				elseif v16:IsA("BasePart") then
					v16.Color = v15
				end
			end

			local n8 = math.floor(now * n7)

			for i, v16 in ipairs(tbl17) do
				v16.Color = tbl16[(n8 + i - 1) % #tbl16 + 1]
			end
		end)
	end

	local tbl17 = {
		WeldConstraint = true,
		Weld = true,
		Motor6D = true,
		RigidConstraint = true,
		Bone = true,
		Snap = true,
		ManualWeld = true,
		Rotate = true,
		RotateP = true,
		RotateV = true,
	}

	local function fn66(arg, arg2)
		if not (arg and arg2.Tags) then
			return
		end

		for _, tag in ipairs(arg2.Tags) do
			local str = tag == "ChromaPart" and "part" or tag == "ChromaDecal" and "decal"
			local str2

			if str then
				str2 = str
			else
				str2 = tag == "ChromaFire" and "fire"
			end

			str2 = str2 or nil

			if str2 then
				pcall(function()
					arg:SetAttribute("MM2Chroma", str2)
				end)
			end
		end
	end

	local function fn67(arg)
		local class = arg.Class
		if tbl17[class] then
			return nil
		end
		local v15

		if class == "MeshPart" then
			v15 = createPart(arg.Props)
			fn62(v15, arg.Props, { MeshId = true, Size = true, RelCF = true, CanCollide = true })
		else
			local ok, result = pcall(Instance.new, class)
			if not ok or not result then
				return nil
			end
			v15 = result
			fn62(v15, arg.Props, { RelCF = true })
		end

		if arg.Name then
			pcall(function()
				v15.Name = arg.Name
			end)
		end

		fn66(v15, arg)
		return v15
	end

	local fn68 = nil

	fn68 = function(arg, parent, parent2, arg2, arg3, arg4)
		local v15 = ipairs
		local children = arg.Children or {}

		for _, child in v15(children) do
			local v16 = fn67(child)

			if v16 then
				arg2[child.Id] = v16

				if v16:IsA("BasePart") then
					v16.Anchored = false
					v16.CanCollide = false
					v16.CanQuery = false
					v16.CanTouch = false
					v16.Massless = true
					arg3[#arg3 + 1] = { inst = v16, relcf = child.Props.RelCF }
					v16.Parent = parent2
					fn68(child, v16, parent2, arg2, arg3, arg4)
				elseif v16:IsA("Attachment") then
					if child.Props.RelCF then
						pcall(function()
							v16.CFrame = child.Props.RelCF
						end)
					end

					v16.Parent = parent2
					fn68(child, v16, parent2, arg2, arg3, arg4)
				elseif v16:IsA("Beam") or v16:IsA("Trail") then
					v16.Parent = parent
					arg4[#arg4 + 1] = { inst = v16, a0 = child.Att0, a1 = child.Att1 }
					fn68(child, v16, parent2, arg2, arg3, arg4)
				else
					v16.Parent = parent
					fn68(child, v16, parent2, arg2, arg3, arg4)
				end
			else
				fn68(child, parent, parent2, arg2, arg3, arg4)
			end
		end
	end

	local function fn69(arg)
		local model = arg.Model
		if not model then
			return nil
		end
		local part

		if model.Class == "MeshPart" then
			part = createPart(model.Props)
			fn62(part, model.Props, { MeshId = true, Size = true, RelCF = true, CanCollide = true })
		else
			part = Instance.new("Part")
			fn62(part, model.Props, { RelCF = true, CanCollide = true })
		end

		if model.Name then
			pcall(function()
				part.Name = model.Name
			end)
		end

		fn66(part, model)
		part.Anchored = false
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.Massless = true
		local tbl18 = { [model.Id] = part }
		local tbl19 = {}
		local tbl20 = {}
		fn68(model, part, part, tbl18, tbl19, tbl20)

		for _, v15 in ipairs(tbl20) do
			if v15.a0 and tbl18[v15.a0] then
				pcall(function()
					v15.inst.Attachment0 = tbl18[v15.a0]
				end)
			end

			if v15.a1 and tbl18[v15.a1] then
				pcall(function()
					v15.inst.Attachment1 = tbl18[v15.a1]
				end)
			end
		end

		return { root = part, parts = tbl19 }
	end

	local function fn70(arg, cFrame)
		local root = arg.root

		pcall(function()
			root.CFrame = cFrame
		end)

		for _, part in ipairs(arg.parts) do
			if part.relcf then
				pcall(function()
					part.inst.CFrame = cFrame * part.relcf
				end)
			end

			local weldConstraint = Instance.new("WeldConstraint")
			weldConstraint.Part0 = part.inst
			weldConstraint.Part1 = root
			weldConstraint.Parent = part.inst
		end

		return root
	end

	local tbl18 = {
		ParticleEmitter = true,
		Fire = true,
		Smoke = true,
		Sparkles = true,
		PointLight = true,
		SpotLight = true,
		SurfaceLight = true,
	}

	local function fn71(arg)
		local v15 = nil
		local tbl19 = {}
		local tbl20 = {}
		local tbl21 = {}
		local v16 = ipairs
		local display = arg.Display or {}

		for _, v17 in v16(display) do
			if v17.Path == "(root)" then
				v15 = v17
			elseif v17.Class == "SpecialMesh" then
				tbl19[#tbl19 + 1] = v17
			elseif v17.Class == "Decal" or v17.Class == "Texture" then
				tbl20[#tbl20 + 1] = v17
			elseif tbl18[v17.Class] then
				tbl21[#tbl21 + 1] = v17
			end
		end

		if not v15 then
			return nil
		end
		local part

		if v15.Class == "MeshPart" then
			part = createPart(v15.Props)
			fn62(part, v15.Props, { MeshId = true, Size = true, CanCollide = true })
		else
			part = Instance.new("Part")
			part.Size = v15.Props.Size or Vector3.one
			fn62(part, v15.Props, { Size = true, CanCollide = true })

			for _, v17 in ipairs(tbl19) do
				local specialMesh = Instance.new("SpecialMesh")
				specialMesh.MeshType = Enum.MeshType.FileMesh
				fn62(specialMesh, v17.Props)
				specialMesh.Parent = part
			end
		end

		part.Anchored = false
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.Massless = true

		if v15.Name then
			pcall(function()
				part.Name = v15.Name
			end)
		end

		for _, v17 in ipairs(tbl20) do
			local decal = Instance.new("Decal")
			fn62(decal, v17.Props)

			if v17.Name then
				pcall(function()
					decal.Name = v17.Name
				end)
			end

			decal.Parent = part
		end

		for _, v17 in ipairs(tbl21) do
			local ok, result = pcall(Instance.new, v17.Class)

			if ok and result then
				fn62(result, v17.Props)

				if v17.Name then
					pcall(function()
						result.Name = v17.Name
					end)
				end

				result.Parent = part
			end
		end

		return { root = part, parts = {} }
	end

	local function fn72(arg)
		if arg.Model then
			return fn69(arg)
		end

		if arg.Display then
			return fn71(arg)
		end
		return nil
	end

	local function fn73(arg)
		if arg.Model then
			local model = arg.Model
			if model.Class == "MeshPart" then
				return fn61(model.Props.MeshId or "")
			end
			local v15 = ipairs
			local children = model.Children or {}

			for _, child in v15(children) do
				if child.Class == "SpecialMesh" then
					return fn61(child.Props.MeshId or "")
				end
			end

			return ""
		end

		local v15 = ipairs
		local display = arg.Display or {}

		for _, v16 in v15(display) do
			if v16.Path == "(root)" and v16.Class == "MeshPart" then
				return fn61(v16.Props.MeshId or "")
			end

			if v16.Class == "SpecialMesh" then
				return fn61(v16.Props.MeshId or "")
			end
		end

		return ""
	end

	local function fn74(arg)
		if not arg then
			return ""
		end

		if arg:IsA("MeshPart") then
			return fn61(arg.MeshId or "")
		end
		local specialMesh = arg:FindFirstChildWhichIsA("SpecialMesh", true)

		if specialMesh then
			specialMesh = fn61(specialMesh.MeshId or "")
		end

		return specialMesh or ""
	end

	local cframe = CFrame.identity
	local fn75 = nil

	fn75 = function(arg)
		local v15 = ipairs
		local children = arg.Children or {}

		for _, child in v15(children) do
			if child.Class == "Attachment" and child.Name == "CustomAttachment" and child.Props and child.Props.RelCF then
				return child.Props.RelCF
			end
			local v16 = fn75(child)
			if v16 then
				return v16
			end
		end

		return nil
	end

	local function fn76(arg)
		if arg.Model then
			return arg.Model.Props and arg.Model.Props.Size
		end
		local v15 = ipairs
		local display = arg.Display or {}

		for _, v16 in v15(display) do
			if v16.Path == "(root)" then
				return v16.Props and v16.Props.Size
			end
		end

		return nil
	end

	local function fn77(arg)
		if not arg then
			return nil
		end
		local tbl19 = { { arg.X, "X" }, { arg.Y, "Y" }, { arg.Z, "Z" } }

		table.sort(tbl19, function(arg2, arg3)
			return arg2[1] > arg3[1]
		end)

		return tbl19[1][2] .. tbl19[2][2] .. tbl19[3][2]
	end

	local tbl19 = {
		Gun_ZYX = CFrame.new(0.12991, -3e-05, 0.075, 1, 0, 0, 0, 0.70713, 0.70708, 0, -0.70708, 0.70713),
		Gun_ZXY = CFrame.new(0.12991, 0, 0.07501, 2e-05, -0.5, -0.86603, 1, -4e-05, 5e-05, -6e-05, -0.86603, 0.5),
		Gun_XYZ = CFrame.new(-0.22989, 0.09821, 0.1, 1e-05, 0.98481, -0.17362, -1e-05, 0.17362, 0.98481, 1, -1e-05, 1e-05),
		Knife_YXZ = CFrame.new(0, 0, 0, -0.0446, -0.00031, -0.99901, 0.03549, 0.99937, -0.00189, 0.99837, -0.03553, -0.04456),
		Knife_ZYX = CFrame.new(0.00151, -0.12701, -0.15448, -0.99867, 0.03727, 0.03568, -0.04098, -0.15276, -0.98741, -0.03135, -0.98756, 0.15409),
		Knife_ZXY = CFrame.new(0.00151, -0.12701, -0.15448, -0.99867, 0.03727, 0.03568, -0.04098, -0.15276, -0.98741, -0.03135, -0.98756, 0.15409),
	}

	local mM2VizLearned = _G.__MM2VizLearned or {}
	_G.__MM2VizLearned = mM2VizLearned
	local mM2VizOverride = _G.__MM2VizOverride or {}
	_G.__MM2VizOverride = mM2VizOverride
	local mM2VizOverrideGrip = _G.__MM2VizOverrideGrip or {}
	_G.__MM2VizOverrideGrip = mM2VizOverrideGrip

	local function fn78(arg)
		if not arg then
			return nil
		end
		return arg:FindFirstChild("CustomAttachment") or arg:FindFirstChildWhichIsA("Attachment")
	end

	local function fn79(arg)
		local v15 = fn74(arg)
		local v16 = fn78(arg)

		if v15 ~= "" and v16 then
			mM2VizLearned[v15] = v16.CFrame
		end
	end

	local function fn80(arg, arg2, arg3)
		if mM2VizOverride[arg] then
			return mM2VizOverride[arg]
		end

		if arg2.Model then
			return fn75(arg2.Model) or cframe
		end
		local v15 = fn73(arg2)
		if v15 ~= "" and mM2VizLearned[v15] then
			return mM2VizLearned[v15]
		end
		local v16 = fn77(fn76(arg2))
		return v16 and tbl19[(arg2.Meta and arg2.Meta.ItemType or arg3) .. "_" .. v16] or cframe
	end

	local function fn81(arg, arg2)
		local v15 = fn78(arg)
		return arg.CFrame * (v15 and v15.CFrame or cframe) * arg2:Inverse()
	end

	local function fn82(arg, arg2)
		if arg2:IsA("BasePart") or arg2:IsA("Decal") then
			arg[#arg + 1] = { inst = arg2, prop = "Transparency", val = arg2.Transparency }

			pcall(function()
				arg2.Transparency = 1
			end)
		elseif arg2:IsA("ParticleEmitter") or arg2:IsA("Trail") or arg2:IsA("Beam") or arg2:IsA("Fire") or arg2:IsA("Smoke") or arg2:IsA("Sparkles") then
			arg[#arg + 1] = { inst = arg2, prop = "Enabled", val = arg2.Enabled }

			pcall(function()
				arg2.Enabled = false
			end)
		end
	end

	local function fn83(arg)
		for _, v15 in ipairs(arg) do
			pcall(function()
				v15.inst[v15.prop] = v15.val
			end)
		end
	end

	local function fn84(arg)
		local tbl20 = {}

		for _, v15 in ipairs(arg) do
			local inst = v15.inst
			local prop = v15.prop

			tbl20[#tbl20 + 1] = inst:GetPropertyChangedSignal(prop):Connect(function()
				if prop == "Enabled" then
					if inst.Enabled then
						inst.Enabled = false
					end
				elseif inst.Transparency ~= 1 then
					inst.Transparency = 1
				end
			end)
		end

		return tbl20
	end

	local function fn85(arg)
		local v15 = ipairs
		local tbl20 = arg or {}

		for _, v16 in v15(tbl20) do
			pcall(function()
				v16:Disconnect()
			end)
		end
	end

	local function fn86()
		return localPlayer2.Character
	end

	local function fn87(arg)
		local v15 = fn86()
		if not v15 then
			return nil
		end
		local v16 = v15:FindFirstChild("DisplayRef" .. arg)
		return v16 and v16.Value or nil
	end

	local function fn88(arg, arg2)
		local n8 = os.clock() + (arg2 or 1)

		while os.clock() < n8 do
			local v15 = fn87(arg)
			if v15 then
				return v15
			end
			task.wait(0.05)
		end

		return fn87(arg)
	end

	local tbl20 = {}
	local tbl21 = {}
	local tbl22 = {}
	local fn89 = nil

	local function fn90(arg, arg2)
		local weaponDisplays = workspace:FindFirstChild("WeaponDisplays")
		if not weaponDisplays then
			return
		end

		for _, child in ipairs(weaponDisplays:GetChildren()) do
			if child ~= arg2 and child:GetAttribute("MM2VizSlot") == arg then
				pcall(function()
					child:Destroy()
				end)
			end
		end
	end

	local function fn91(arg)
		fn90(arg)
		local v15 = tbl20[arg]
		if not v15 then
			return
		end

		if v15.chroma then
			pcall(function()
				v15.chroma:Disconnect()
			end)
		end

		if v15.overlay then
			pcall(function()
				v15.overlay:Destroy()
			end)
		end

		fn83(v15.hidden)
		tbl20[arg] = nil
	end

	local function fn92(arg, arg2)
		if tbl20[arg] and tbl21[arg] == arg2 and arg2 ~= nil then
			return
		end
		tbl22[arg] = (tbl22[arg] or 0) + 1
		local v15 = tbl22[arg]
		fn91(arg)
		local v16 = arg2 and v14[arg2]
		if not v16 then
			tbl21[arg] = arg2
			return
		end
		tbl21[arg] = arg2
		local v17 = fn87(arg) or fn88(arg, 1.5)
		if tbl22[arg] ~= v15 then
			return
		end

		if not v17 then
			if fn89 then
				fn89("No " .. arg .. " shown — equip a normal " .. arg .. " first.", Color3.fromRGB(240, 200, 120))
			end

			return
		end

		fn79(v17)
		if fn74(v17) == fn73(v16) and fn74(v17) ~= "" then
			return
		end
		local v18 = fn80(arg2, v16, arg)
		local tbl23 = {}
		fn82(tbl23, v17)

		for _, descendant in ipairs(v17:GetDescendants()) do
			fn82(tbl23, descendant)
		end

		local v19 = fn72(v16)

		if not v19 or not v19.root or tbl22[arg] ~= v15 or not v17.Parent then
			fn83(tbl23)

			if v19 and v19.root then
				v19.root:Destroy()
			end

			return
		end

		fn70(v19, fn81(v17, v18))
		local root = v19.root
		root:SetAttribute("MM2VizOverlay", true)
		root:SetAttribute("MM2VizSlot", arg)
		root.Parent = v17.Parent or v17
		local weldConstraint = Instance.new("WeldConstraint")
		weldConstraint.Part0 = root
		weldConstraint.Part1 = v17
		weldConstraint.Parent = root
		local v20 = fn64(arg2, v16) and fn65(root) or nil
		fn90(arg, root)
		tbl20[arg] = { overlay = root, hidden = tbl23, chroma = v20 }

		if fn89 then
			fn89("Showing: " .. arg2 .. " (" .. arg .. ")", Color3.fromRGB(150, 230, 170))
		end
	end

	local tbl23 = { X = Vector3.new(1, 0, 0), Y = Vector3.new(0, 1, 0), Z = Vector3.new(0, 0, 1) }

	local function fn93(arg)
		local tbl24 = { { arg.X, "X" }, { arg.Y, "Y" }, { arg.Z, "Z" } }

		table.sort(tbl24, function(arg2, arg3)
			return arg2[1] > arg3[1]
		end)

		return tbl24[1][2], tbl24[2][2], tbl24[3][2]
	end

	local tbl24 = {
		Gun = { Vector3.new(0, 0, 1), Vector3.new(0, 1, 0), Vector3.new(-1, 0, 0) },
		Knife = { Vector3.new(0, 1, 0), Vector3.new(0, 0, 1), Vector3.new(1, 0, 0) },
	}

	local tbl25 = {
		Harvester = CFrame.Angles(0, 0, -1.5707963267948966),
		Icepiercer = CFrame.Angles(0, 0, -1.5707963267948966),
	}

	local tbl26 = { Sweet = true, SweetChroma = true }
	local tbl27 = { Harvester = 0.5, Icepiercer = 0.5 }

	local function fn94(arg, arg2, arg3, arg4)
		if arg2 and tbl26[arg2] then
			return cframe
		end
		local v15 = fn76(arg3)
		local v16 = tbl24[arg4]
		if not (v15 and v16) then
			return cframe
		end
		local v17, v18, v19 = fn93(v15)
		local tbl28 = { [v17] = v16[1], [v18] = v16[2], [v19] = v16[3] }

		if tbl23[v17]:Cross(tbl23[v18]):Dot(tbl23[v19]) < 0 then
			tbl28[v19] = -tbl28[v19]
		end

		local x = tbl28.X
		local y = tbl28.Y
		local z = tbl28.Z
		local n8 = arg.Grip.Rotation * CFrame.fromMatrix(Vector3.new(), x, y, z)
		local v20 = arg2 and tbl25[arg2]

		if v20 then
			n8 *= v20
		end

		arg2 = arg2 and tbl27[arg2]

		if arg2 then
			n8 *= CFrame.new(tbl23[v17] * arg2)
		end

		return n8
	end

	local function fn95(arg, arg2)
		local v15 = fn76(arg2)
		if not v15 then
			return cframe
		end
		local v16, v17, v18 = fn93(v15)
		local v19, v20, v21 = fn93(arg)
		local tbl28 = { [v16] = tbl23[v19], [v17] = tbl23[v20], [v18] = tbl23[v21] }

		if tbl23[v16]:Cross(tbl23[v17]):Dot(tbl23[v18]) ~= tbl23[v19]:Cross(tbl23[v20]):Dot(tbl23[v21]) then
			tbl28[v18] = -tbl28[v18]
		end

		local x = tbl28.X
		local y = tbl28.Y
		local z = tbl28.Z
		return CFrame.fromMatrix(Vector3.new(), x, y, z)
	end

	local function fn96(arg)
		if not arg then
			return nil
		end
		return arg:match("^(.-)Chroma$") or arg:match("^Chroma(.+)$")
	end

	local function fn97(arg, arg2)
		local v15 = fn96(arg)
		local meta = v15 and v14[v15] and v14[v15].Meta or arg2.Meta
		if not meta then
			return nil
		end

		if meta.ItemID then
			return ("rbxthumb://type=Asset&w=150&h=150&id=%d"):format(meta.ItemID)
		end
		return meta.Image
	end

	local obj = setmetatable({}, { __mode = "k" })

	local function fn98(arg)
		local v15 = obj[arg]
		if v15 and v15.Parent then
			return v15
		end
		local playerGui = localPlayer2:FindFirstChild("PlayerGui")
		playerGui = playerGui and playerGui:FindFirstChild("BackpackUI")
		playerGui = playerGui and playerGui:FindFirstChild("BackpackFrame")
		if not playerGui then
			return nil
		end

		for _, child in ipairs(playerGui:GetChildren()) do
			local container = child:IsA("GuiObject") and child:FindFirstChild("Container")
			local nameLabel = container and container:FindFirstChild("NameLabel")

			if nameLabel and container:FindFirstChild("ToolIcon") then
				local name = child.Name
				local text = nameLabel.Text
				child.Name = name .. " "
				task.wait()
				local text2 = nameLabel.Text
				child.Name = name
				task.wait()
				nameLabel.Text = text
				if text2 == arg.Name then
					obj[arg] = container
					return container
				end
			end
		end

		return nil
	end

	local function fn99(arg, image)
		task.spawn(function()
			local v15 = fn98(arg)
			if not v15 then
				return
			end
			local toolIcon = v15:FindFirstChild("ToolIcon")

			if toolIcon then
				toolIcon.Image = image
			end

			local nameLabel = v15:FindFirstChild("NameLabel")

			if nameLabel then
				nameLabel.Text = image == "" and arg.Name or ""
			end
		end)
	end

	local function fn100(arg, textureId)
		if not textureId or textureId == "" then
			return nil
		end
		local textureId2 = arg.TextureId
		arg.TextureId = textureId
		fn99(arg, textureId)
		return textureId2
	end

	local function fn101(arg, textureId)
		if not textureId then
			return
		end

		pcall(function()
			arg.TextureId = textureId
		end)

		fn99(arg, textureId)
	end

	local tbl28 = {
		Harvester = "rbxassetid://7808472682",
		Icepiercer = "rbxassetid://7808472682",
		Raygun = "rbxassetid://92066070356304",
		RaygunChroma = "rbxassetid://92066070356304",
		Snowcannon = "rbxassetid://136161856273464",
		SnowcannonChroma = "rbxassetid://136161856273464",
		Gingerscope = "rbxassetid://74240492893421",
	}

	local mM2VizSounds = _G.__MM2VizSounds or {}
	_G.__MM2VizSounds = mM2VizSounds

	local function fn102()
		for _, player in ipairs(Players_:GetPlayers()) do
			for _, v15 in ipairs({ player.Character, player:FindFirstChild("Backpack") }) do
				local v16 = ipairs
				v15 = v15 and v15:GetChildren() or {}

				for _, v17 in v16(v15) do
					local attribute = v17:IsA("Tool") and v17:GetAttribute("ItemID")
					local handle = attribute and v17:FindFirstChild("Handle")
					handle = handle and handle:FindFirstChild("AltSound")

					if handle and handle:IsA("Sound") and handle.SoundId ~= "" and mM2VizSounds[attribute] ~= handle.SoundId then
						mM2VizSounds[attribute] = handle.SoundId
						print(("learned shot sound -- SHOT_SOUND[%q] = %q"):format(attribute, handle.SoundId))
					end
				end
			end
		end
	end

	local function fn103(arg, arg2)
		local v15 = tbl28[arg2] or mM2VizSounds[arg2]
		local handle = v15 and arg:FindFirstChild("Handle")
		handle = handle and handle:FindFirstChild("Gunshot")
		if not (handle and handle:IsA("Sound")) then
			return nil
		end
		local soundId = handle.SoundId
		handle.SoundId = v15
		return { sound = handle, old = soundId }
	end

	local function fn104(arg)
		if arg and arg.sound then
			pcall(function()
				arg.sound.SoundId = arg.old
			end)
		end
	end

	local tbl29 = {}

	local function fn105(arg)
		if arg:IsDescendantOf(localPlayer2) then
			return true
		end
		local v15 = fn86()
		return v15 ~= nil and arg:IsDescendantOf(v15)
	end

	local function fn106(arg, arg2)
		if tbl29[arg] then
			return
		end
		local handle = arg:FindFirstChild("Handle") or arg:WaitForChild("Handle", 5)
		if not handle then
			return
		end
		local v15 = ProfileData.Weapons.Equipped[arg2]
		local v16 = v15 and v14[v15]
		if not v16 then
			return
		end
		fn79(handle)
		local v17 = fn72(v16)
		if not v17 or not v17.root then
			return
		end
		local tbl30 = {}
		fn82(tbl30, handle)

		for _, descendant in ipairs(handle:GetDescendants()) do
			fn82(tbl30, descendant)
		end

		fn70(v17, handle.CFrame * (mM2VizOverrideGrip[v15] or fn94(arg, v15, v16, arg2)))
		local root = v17.root
		root.Parent = handle
		local weldConstraint = Instance.new("WeldConstraint")
		weldConstraint.Part0 = root
		weldConstraint.Part1 = handle
		weldConstraint.Parent = root
		local v18 = fn64(v15, v16) and fn65(root) or nil
		root:SetAttribute("MM2VizOverlay", true)

		tbl29[arg] = {
			overlay = root,
			hidden = tbl30,
			chroma = v18,
			icon = fn100(arg, fn97(v15, v16)),
			skin = v15,
			guards = fn84(tbl30),
			shot = fn103(arg, v15),
		}
	end

	local function fn107(arg)
		local tbl30 = {}
		local v15 = ipairs
		local v16 = CollectionService_
		local getTagged = v16.GetTagged
		local str = arg == "Gun" and "Weapon_Gun" or "Weapon_Knife"

		for _, v17 in v15(getTagged(v16, str)) do
			if fn105(v17) then
				tbl30[#tbl30 + 1] = v17
			end
		end

		return tbl30
	end

	local function fn108(arg)
		local v15 = tbl29[arg]
		if not v15 then
			return
		end

		if v15.chroma then
			pcall(function()
				v15.chroma:Disconnect()
			end)
		end

		if v15.overlay then
			pcall(function()
				v15.overlay:Destroy()
			end)
		end

		pcall(fn101, arg, v15.icon)
		fn104(v15.shot)
		fn85(v15.guards)
		fn83(v15.hidden)
		tbl29[arg] = nil
	end

	local mM2VizBaseline = _G.__MM2VizBaseline

	if not mM2VizBaseline then
		mM2VizBaseline = {}

		for k, v15 in pairs(ProfileData.Weapons.Owned) do
			mM2VizBaseline[k] = v15
		end

		_G.__MM2VizBaseline = mM2VizBaseline
	end

	local mM2VizBaselineEq = _G.__MM2VizBaselineEq

	if not mM2VizBaselineEq then
		mM2VizBaselineEq = { Knife = ProfileData.Weapons.Equipped.Knife, Gun = ProfileData.Weapons.Equipped.Gun }
		_G.__MM2VizBaselineEq = mM2VizBaselineEq
	end

	local function spawn(arg, arg2)
		local n8 = arg2 or 1
		local owned = ProfileData.Weapons.Owned
		owned[arg] = (owned[arg] or 0) + n8

		pcall(function()
			inventoryDataChanged:Fire("Weapons", arg, owned[arg])
		end)
	end

	local function despawnAll()
		local owned = ProfileData.Weapons.Owned
		local n8 = 0

		for k in pairs(v14) do
			local v15 = mM2VizBaseline[k]

			if owned[k] ~= v15 then
				owned[k] = v15

				pcall(function()
					inventoryDataChanged:Fire("Weapons", k, owned[k] or 0)
				end)

				n8 += 1
			end
		end

		for _, v15 in ipairs({ "Knife", "Gun" }) do
			local v16 = ProfileData.Weapons.Equipped[v15]

			if v16 and owned[v16] == nil then
				local str = mM2VizBaselineEq[v15]

				if not (str and owned[str]) then
					str = nil

					for k in pairs(owned) do
						local v17 = weapons[k]
						if type(v17) == "table" and v17.ItemType == v15 then
							str = k
							break
						end
					end
				end

				if not str then
					str = v15 == "Knife" and "DefaultKnife" or "DefaultGun"
				end

				ProfileData.Weapons.Equipped[v15] = str

				pcall(function()
					EquipService.EquippedChanged:Fire(v15, str)
				end)
			end
		end

		return n8
	end

	local list = {}

	for k in pairs(v14) do
		local v15 = weapons[k]

		list[#list + 1] = {
			key = k,
			name = type(v15) == "table" and v15.ItemName or k,
			type = type(v15) == "table" and v15.ItemType or "",
			rarity = type(v15) == "table" and v15.Rarity or "",
			chroma = fn64(k, v14[k]),
		}
	end

	table.sort(list, function(arg, arg2)
		if arg.type ~= arg2.type then
			return arg.type < arg2.type
		end

		if arg.rarity ~= arg2.rarity then
			return arg.rarity < arg2.rarity
		end
		return arg.name:lower() < arg2.name:lower()
	end)

	local v15 = nil
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MM2Spawner"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 999999

	pcall(function()
		screenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
	end)

	if not screenGui.Parent then
		screenGui.Parent = localPlayer2:WaitForChild("PlayerGui")
	end

	mM2Viz.gui = screenGui
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(290, 420)
	frame.Position = UDim2.new(0, 20, 0.5, -210)
	frame.BackgroundColor3 = Color3.fromRGB(20, 20, 27)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = true
	frame.Parent = screenGui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
	local uiStroke = Instance.new("UIStroke", frame)
	uiStroke.Color = Color3.fromRGB(120, 90, 230)
	uiStroke.Thickness = 1.5
	local textButton = Instance.new("TextButton")
	textButton.Size = UDim2.new(0.5, -14, 0, 26)
	textButton.Position = UDim2.fromOffset(12, 10)
	textButton.BackgroundColor3 = Color3.fromRGB(60, 95, 70)
	textButton.BorderSizePixel = 0
	textButton.Font = Enum.Font.GothamBold
	textButton.TextSize = 12
	textButton.TextColor3 = Color3.fromRGB(200, 255, 215)
	textButton.Text = "Spawn all"
	textButton.Parent = frame
	Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 6)
	local textButton2 = Instance.new("TextButton")
	textButton2.Size = UDim2.new(0.5, -14, 0, 26)
	textButton2.Position = UDim2.new(0.5, 2, 0, 10)
	textButton2.BackgroundColor3 = Color3.fromRGB(95, 60, 70)
	textButton2.BorderSizePixel = 0
	textButton2.Font = Enum.Font.GothamBold
	textButton2.TextSize = 12
	textButton2.TextColor3 = Color3.fromRGB(255, 205, 215)
	textButton2.Text = "Despawn all"
	textButton2.Parent = frame
	Instance.new("UICorner", textButton2).CornerRadius = UDim.new(0, 6)
	local scrollingFrame = Instance.new("ScrollingFrame")
	scrollingFrame.Size = UDim2.new(1, -20, 1, -56)
	scrollingFrame.Position = UDim2.fromOffset(10, 46)
	scrollingFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 19)
	scrollingFrame.BackgroundTransparency = 0.3
	scrollingFrame.BorderSizePixel = 0
	scrollingFrame.ScrollBarThickness = 6
	scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 90, 230)
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollingFrame.Parent = frame
	Instance.new("UICorner", scrollingFrame).CornerRadius = UDim.new(0, 6)
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Padding = UDim.new(0, 2)
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = scrollingFrame
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingTop = UDim.new(0, 3)
	uiPadding.PaddingBottom = UDim.new(0, 3)
	uiPadding.PaddingLeft = UDim.new(0, 3)
	uiPadding.PaddingRight = UDim.new(0, 3)
	uiPadding.Parent = scrollingFrame

	local function fn109()
	end

	local tbl30 = { Godly = Color3.fromRGB(255, 110, 190), Ancient = Color3.fromRGB(165, 95, 245) }
	local flag17 = false
	local tbl31 = {}

	local function fn110()
		if flag17 then
			return
		end
		flag17 = true

		task.spawn(function()
			for i, v16 in ipairs(list) do
				local textButton3 = Instance.new("TextButton")
				textButton3.Size = UDim2.new(1, -6, 0, 24)
				textButton3.BackgroundColor3 = v16.type == "Knife" and Color3.fromRGB(48, 44, 70) or Color3.fromRGB(44, 56, 72)
				textButton3.BackgroundTransparency = 0.25
				textButton3.Font = Enum.Font.Gotham
				textButton3.TextSize = 12
				textButton3.TextColor3 = Color3.fromRGB(235, 235, 245)
				textButton3.TextXAlignment = Enum.TextXAlignment.Left
				textButton3.TextTruncate = Enum.TextTruncate.AtEnd
				textButton3.Text = "  " .. v16.name .. (v16.chroma and "  [Chroma]" or "") .. "   -  " .. v16.rarity .. " " .. v16.type
				textButton3.LayoutOrder = i
				textButton3.Parent = scrollingFrame
				Instance.new("UICorner", textButton3).CornerRadius = UDim.new(0, 4)
				local uiStroke2 = Instance.new("UIStroke", textButton3)
				uiStroke2.Color = tbl30[v16.rarity] or Color3.fromRGB(90, 90, 110)
				uiStroke2.Thickness = 1.4
				uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				local key = v16.key

				textButton3.MouseButton1Click:Connect(function()
					spawn(key, 1)
					fn109(key)
					local backgroundColor3 = textButton3.BackgroundColor3
					textButton3.BackgroundColor3 = Color3.fromRGB(0, 150, 100)

					task.delay(0.18, function()
						if textButton3.Parent then
							textButton3.BackgroundColor3 = backgroundColor3
						end
					end)
				end)

				tbl31[#tbl31 + 1] = { btn = textButton3, hay = (v16.key .. " " .. v16.name):lower() }

				if i % 60 == 0 then
					task.wait()
				end
			end
		end)
	end

	fn110()

	textButton.MouseButton1Click:Connect(function()
		if textButton.Text ~= "Spawn all" then
			return
		end
		textButton.Text = "..."

		task.spawn(function()
			for i, v16 in ipairs(list) do
				spawn(v16.key, 1)

				if i % 25 == 0 then
					task.wait()
				end
			end

			textButton.Text = "Spawn all"
		end)
	end)

	textButton2.MouseButton1Click:Connect(function()
		if textButton2.Text ~= "Despawn all" then
			return
		end
		textButton2.Text = "..."

		task.spawn(function()
			despawnAll()
			textButton2.Text = "Despawn all"
		end)
	end)

	fn89 = function(text, textColor3)
		if v15 then
			v15.Text = text
			v15.TextColor3 = textColor3 or Color3.fromRGB(190, 190, 205)
		end
	end

	local tbl32 = { Knife = nil, Gun = nil }

	pcall(function()
		tbl32.Knife = ProfileData.Weapons.Equipped.Knife
		tbl32.Gun = ProfileData.Weapons.Equipped.Gun
	end)

	task.spawn(function()
		for _, v16 in ipairs({ "Knife", "Gun" }) do
			local v17 = ProfileData.Weapons.Equipped[v16]

			if v17 then
				task.spawn(function()
					fn92(v16, v17)
				end)
			end
		end

		while _G.__MM2Viz == mM2Viz do
			for _, v16 in ipairs({ "Knife", "Gun" }) do
				local v17 = nil

				pcall(function()
					v17 = ProfileData.Weapons.Equipped[v16]
				end)

				if v17 ~= tbl32[v16] then
					tbl32[v16] = v17
					local v18 = v17

					task.spawn(function()
						fn92(v16, v18)
					end)

					for _, v19 in ipairs(fn107(v16)) do
						task.spawn(function()
							fn108(v19)
							fn106(v19, v16)
						end)
					end
				end
			end

			task.wait(0.1)
		end
	end)

	local connection6 = EquipService.EquippedChanged.Event:Connect(function(arg, arg2)
		if arg == "Knife" or arg == "Gun" then
			tbl32[arg] = arg2

			task.spawn(function()
				fn92(arg, arg2)
                for _, tool in ipairs(fn107(arg)) do
                    fn108(tool)
                    fn106(tool, arg)
                end
			end)
		end
	end)

	table.insert(mM2Viz.conns, connection6)

	local function fn111(arg)
		local connection7 = arg.ChildAdded:Connect(function(child)
			local name = child.Name

			if name == "DisplayRefKnife" or name == "DisplayRefGun" then
				local str = name == "DisplayRefKnife" and "Knife" or "Gun"

				task.delay(0.2, function()
					local v16 = tbl20[str] and tbl21[str]

					if v16 then
						tbl20[str] = nil
						fn92(str, v16)
					end
				end)
			end
		end)

		table.insert(mM2Viz.conns, connection7)
	end

	if fn86() then
		local v16 = fn86()
		fn111(v16)
	end

	local connection7 = localPlayer2.CharacterAdded:Connect(function(character)
		for _, v16 in ipairs({ "Knife", "Gun" }) do
			local v17 = tbl20[v16]

			if v17 and v17.overlay then
				pcall(function()
					v17.overlay:Destroy()
				end)
			end
		end

		tbl20 = {}
		fn111(character)

		task.delay(1, function()
			for _, v16 in ipairs({ "Knife", "Gun" }) do
				if tbl21[v16] then
					fn92(v16, tbl21[v16])
				end
			end
		end)
	end)

	table.insert(mM2Viz.conns, connection7)

	for _, v16 in ipairs({ "Weapon_Knife", "Weapon_Gun" }) do
		local str = v16 == "Weapon_Gun" and "Gun" or "Knife"

		for _, v17 in ipairs(CollectionService_:GetTagged(v16)) do
			if fn105(v17) then
				task.spawn(function()
					fn106(v17, str)
				end)
			end
		end

		table.insert(mM2Viz.conns, CollectionService_:GetInstanceAddedSignal(v16):Connect(function(arg)
			if fn105(arg) then
				task.spawn(function()
					fn106(arg, str)
				end)
			end
		end))

		table.insert(mM2Viz.conns, CollectionService_:GetInstanceRemovedSignal(v16):Connect(function(arg)
			fn108(arg)
		end))
	end

	local function fn112(arg)
		local knifeVisual = arg:WaitForChild("KnifeVisual", 5)
		if not knifeVisual then
			return
		end
		local v16 = nil

		for _, descendant in ipairs(knifeVisual:GetDescendants()) do
			if descendant:GetAttribute("MM2VizOverlay") then
				v16 = descendant
				break
			else
				v16 = nil
			end
		end

		if not v16 then
			return
		end
		local tbl33 = {}
		fn82(tbl33, knifeVisual)

		for _, descendant in ipairs(knifeVisual:GetDescendants()) do
			if descendant ~= v16 and not descendant:IsDescendantOf(v16) then
				fn82(tbl33, descendant)
			end
		end
	end

	table.insert(mM2Viz.conns, CollectionService_:GetInstanceAddedSignal("ThrowingKnife"):Connect(function(arg)
		task.spawn(fn112, arg)
	end))

	local tbl33 = {}

	local function fn113()
		local v16 = fn86()

		for _, v17 in ipairs(CollectionService_:GetTagged("Weapon_Knife")) do
			if v17:IsDescendantOf(localPlayer2) or v16 and v17:IsDescendantOf(v16) then
				return true
			end
		end

		return false
	end

	local function fn114(arg)
		local v16 = tbl33[arg]
		if not v16 then
			return
		end
		tbl33[arg] = nil

		if v16.chroma then
			pcall(function()
				v16.chroma:Disconnect()
			end)
		end

		fn85(v16.guards)

		if v16.overlay then
			pcall(function()
				v16.overlay:Destroy()
			end)
		end
	end

	local function fn115(parent)
		if tbl33[parent] or not fn113() then
			return
		end
		local knife = ProfileData.Weapons.Equipped.Knife
		local v16 = knife and v14[knife]
		if not v16 then
			return
		end
		tbl33[parent] = {}
		local v17 = fn72(v16)

		if not v17 or not v17.root or not parent.Parent then
			if v17 and v17.root then
				v17.root:Destroy()
			end

			tbl33[parent] = nil
			return
		end

		local tbl34 = {}
		fn82(tbl34, parent)

		for _, descendant in ipairs(parent:GetDescendants()) do
			fn82(tbl34, descendant)
		end

		fn70(v17, parent.CFrame * fn95(parent.Size, v16))
		local root = v17.root
		root.Parent = parent
		local weldConstraint = Instance.new("WeldConstraint")
		weldConstraint.Part0 = root
		weldConstraint.Part1 = parent
		weldConstraint.Parent = root
		tbl33[parent] = { overlay = root, chroma = fn64(knife, v16) and fn65(root) or nil, guards = fn84(tbl34) }

		parent.Destroying:Once(function()
			fn114(parent)
		end)
	end

	local function fn116(child)
		if child:IsA("BasePart") and child.Name == "StuckKnife" then
			task.spawn(fn115, child)
		end
	end

	for _, child in ipairs(workspace:GetChildren()) do
		fn116(child)
	end

	table.insert(mM2Viz.conns, workspace.ChildAdded:Connect(fn116))

	task.spawn(function()
		while _G.__MM2Viz == mM2Viz do
			pcall(fn102)
			task.wait(2)
		end
	end)

	mM2Viz.tune = function(arg, arg2, arg3, arg4)
		local v16 = tbl21[arg]
		local v17 = v16 and v14[v16]
		if not v17 then
			warn("nothing applied on " .. tostring(arg))
			return
		end
		local n8 = (mM2VizOverride[v16] or fn80(v16, v17, arg)) * CFrame.Angles(arg2 or 0, arg3 or 0, arg4 or 0)
		mM2VizOverride[v16] = n8
		local tbl34 = { n8:GetComponents() }

		for i, v18 in ipairs(tbl34) do
			tbl34[i] = string.format("%.5f", v18)
		end

		print(("OVERRIDE[%q] = CFrame.new(%s)"):format(v16, table.concat(tbl34, ", ")))

		task.spawn(function()
			tbl21[arg] = nil
			fn92(arg, v16)
		end)
	end

	mM2Viz.tuneGrip = function(arg, arg2, arg3, arg4)
		local v16 = nil

		for k in pairs(tbl29) do
			if (CollectionService_:HasTag(k, "Weapon_Gun") and "Gun" or "Knife") == arg then
				v16 = k
			end
		end

		local v17 = v16 and tbl29[v16]
		local v18 = v17 and v14[v17.skin]
		if not v18 then
			warn("not holding a " .. tostring(arg))
			return
		end
		local n8 = (mM2VizOverrideGrip[v17.skin] or fn94(v16, v17.skin, v18, arg)) * CFrame.Angles(arg2 or 0, arg3 or 0, arg4 or 0)
		mM2VizOverrideGrip[v17.skin] = n8
		local tbl34 = { n8:GetComponents() }

		for i, v19 in ipairs(tbl34) do
			tbl34[i] = string.format("%.5f", v19)
		end

		print(("OVERRIDE_GRIP[%q] = CFrame.new(%s)"):format(v17.skin, table.concat(tbl34, ", ")))

		task.spawn(function()
			fn108(v16)
			fn106(v16, arg)
		end)
	end

	mM2Viz.nudge = function(arg, arg2)
		local v16 = nil

		for k in pairs(tbl29) do
			if (CollectionService_:HasTag(k, "Weapon_Gun") and "Gun" or "Knife") == arg then
				v16 = k
			end
		end

		local v17 = v16 and tbl29[v16]
		if not v17 then
			warn("not holding a " .. tostring(arg))
			return
		end
		tbl27[v17.skin] = (tbl27[v17.skin] or 0) + (arg2 or 0)
		print(("GRIP_NUDGE[%q] = %.2f"):format(v17.skin, tbl27[v17.skin]))

		task.spawn(function()
			fn108(v16)
			fn106(v16, arg)
		end)
	end

	mM2Viz.spawn = spawn
	mM2Viz.despawnAll = despawnAll
	mM2Viz.list = list

    -- Refresh inventory UI without increasing the owned count.
    mM2Viz.refreshInventoryItem = function(key, amount)
        local owned = ProfileData.Weapons.Owned
        if owned[key] == nil or tonumber(owned[key]) == 0 then
            owned[key] = math.max(1, tonumber(amount) or 1)
        end
        inventoryDataChanged:Fire("Weapons", key, tonumber(amount) or owned[key] or 1)
    end

    -- Force the local held models to rebuild using the currently equipped skin.
    mM2Viz.refreshEquipped = function(itemType)
        local types = itemType and { itemType } or { "Knife", "Gun" }
        for _, kind in ipairs(types) do
            local equippedKey = ProfileData.Weapons.Equipped[kind]
            if equippedKey then
                pcall(fn92, kind, equippedKey)
            end
            for _, tool in ipairs(fn107(kind)) do
                pcall(fn108, tool)
                pcall(fn106, tool, kind)
            end
        end
    end

	mM2Viz.icon = function(arg)
		local v16 = v14[arg]
		return v16 and fn97(arg, v16) or nil
	end

	mM2Viz.destroy = function()
		for _, conn in ipairs(mM2Viz.conns) do
			pcall(function()
				conn:Disconnect()
			end)
		end

		for k in pairs(tbl20) do
			pcall(fn91, k)
		end

		for k in pairs(tbl29) do
			pcall(fn108, k)
		end

		for k in pairs(tbl33) do
			pcall(fn114, k)
		end

		if mM2Viz.gui then
			pcall(function()
				mM2Viz.gui:Destroy()
			end)
		end
	end

	fn89(("Ready — %d weapons (%d full). Spawn + equip; works in-round too."):format(n5, n6))
	return _G.__MM2Viz
end

--==================================================
-- ONYX VISUAL SKIN CHANGER (ported engine)
-- Uses Onyx's actual mesh overlay, weapon display sync, Chroma,
-- search list, spawn/despawn inventory flow and cleanup.
--==================================================

-- Onyx-style searchable visual-skin tile grid (no dropdown).
local function buildOnyxVisualSkinGrid(visual)
    if type(visual) ~= "table" or not visual.gui or not visual.gui.Parent then
        return false, "Visual skin window is unavailable"
    end
    local gui = visual.gui
    local old = gui:FindFirstChild("OnyxVisualSkinGrid")
    if old then old:Destroy() end

    local panel = Instance.new("Frame")
    panel.Name = "OnyxVisualSkinGrid"
    panel.Size = UDim2.fromOffset(360, 420)
    panel.Position = UDim2.new(0, 320, 0.5, -210)
    panel.BackgroundColor3 = Color3.fromRGB(20, 20, 27)
    panel.BorderSizePixel = 0
    panel.Active = true
    panel.Draggable = true
    panel.Parent = gui
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
    local outline = Instance.new("UIStroke", panel)
    outline.Color = Color3.fromRGB(120, 90, 230)
    outline.Thickness = 1.5

    local header = Instance.new("TextLabel")
    header.BackgroundTransparency = 1
    header.Position = UDim2.fromOffset(10, 7)
    header.Size = UDim2.new(1, -20, 0, 22)
    header.Font = Enum.Font.GothamBold
    header.TextSize = 13
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextColor3 = Color3.fromRGB(238, 238, 246)
    header.Text = "ONYX VISUAL SKINS"
    header.Parent = panel

    local search = Instance.new("TextBox")
    search.Name = "Search"
    search.Position = UDim2.fromOffset(10, 34)
    search.Size = UDim2.new(1, -20, 0, 28)
    search.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
    search.BackgroundTransparency = 0.15
    search.BorderSizePixel = 0
    search.ClearTextOnFocus = false
    search.Font = Enum.Font.Gotham
    search.TextSize = 12
    search.TextXAlignment = Enum.TextXAlignment.Left
    search.TextColor3 = Color3.fromRGB(230, 230, 240)
    search.PlaceholderText = "Search skins..."
    search.PlaceholderColor3 = Color3.fromRGB(120, 120, 135)
    search.Text = ""
    search.Parent = panel
    Instance.new("UICorner", search).CornerRadius = UDim.new(0, 7)

    local scrolling = Instance.new("ScrollingFrame")
    scrolling.Name = "SkinTiles"
    scrolling.Position = UDim2.fromOffset(10, 70)
    scrolling.Size = UDim2.new(1, -20, 1, -80)
    scrolling.BackgroundColor3 = Color3.fromRGB(14, 14, 19)
    scrolling.BackgroundTransparency = 0.25
    scrolling.BorderSizePixel = 0
    scrolling.ScrollBarThickness = 5
    scrolling.ScrollBarImageColor3 = Color3.fromRGB(120, 90, 230)
    scrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrolling.Parent = panel
    Instance.new("UICorner", scrolling).CornerRadius = UDim.new(0, 7)

    local layout = Instance.new("UIGridLayout")
    layout.CellSize = UDim2.fromOffset(98, 104)
    layout.CellPadding = UDim2.fromOffset(6, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = scrolling
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 6)
    padding.PaddingBottom = UDim.new(0, 6)
    padding.Parent = scrolling

    local syncWeapons = {}
    pcall(function()
        syncWeapons = require(game:GetService("ReplicatedStorage"):WaitForChild("Database"):WaitForChild("Sync")).Weapons
    end)
    local tileRecords = {}
    local rarityColors = {
        Godly = Color3.fromRGB(255, 110, 190),
        Ancient = Color3.fromRGB(165, 95, 245),
    }

    local function imageFor(key)
        local data = syncWeapons and syncWeapons[key]
        if type(data) == "table" then
            local image = type(data.Image) == "string" and data.Image or nil
            if image and (image:find("rbxassetid") or image:find("rbxthumb")) then
                return image
            end
            if image then
                local id = image:match("[Aa]sset[Ii][Dd]=(%d+)") or image:match("[?&]id=(%d+)")
                if id then return "rbxthumb://type=Asset&w=150&h=150&id=" .. id end
            end
            if tonumber(data.ItemID) then
                return ("rbxthumb://type=Asset&w=150&h=150&id=%s"):format(tostring(data.ItemID))
            end
        end
        local ok, image = pcall(visual.icon, key)
        return ok and image or ""
    end

    for index, item in ipairs(visual.list or {}) do
        local tile = Instance.new("TextButton")
        tile.Name = tostring(item.key)
        tile.LayoutOrder = index
        tile.Text = ""
        tile.AutoButtonColor = false
        tile.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
        tile.BackgroundTransparency = 0.2
        tile.BorderSizePixel = 0
        tile.Parent = scrolling
        Instance.new("UICorner", tile).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", tile)
        stroke.Thickness = 1.4
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = rarityColors[item.rarity] or Color3.fromRGB(90, 90, 110)
        stroke.Transparency = 0.4

        local icon = Instance.new("ImageLabel")
        icon.BackgroundTransparency = 1
        icon.AnchorPoint = Vector2.new(0.5, 0)
        icon.Position = UDim2.new(0.5, 0, 0, 4)
        icon.Size = UDim2.fromOffset(62, 62)
        icon.Image = imageFor(item.key)
        icon.ScaleType = Enum.ScaleType.Fit
        icon.Parent = tile

        local name = Instance.new("TextLabel")
        name.BackgroundTransparency = 1
        name.AnchorPoint = Vector2.new(0.5, 1)
        name.Position = UDim2.new(0.5, 0, 1, -3)
        name.Size = UDim2.new(1, -6, 0, 27)
        name.Font = Enum.Font.GothamBold
        name.TextSize = 10
        name.TextWrapped = true
        name.TextTruncate = Enum.TextTruncate.AtEnd
        name.TextColor3 = Color3.fromRGB(210, 210, 220)
        name.Text = tostring(item.name)
        name.Parent = tile

        if item.chroma then
            local tag = Instance.new("TextLabel")
            tag.Name = "ChromaTag"
            tag.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            tag.BackgroundTransparency = 0.2
            tag.Position = UDim2.fromOffset(3, 3)
            tag.Size = UDim2.fromOffset(38, 13)
            tag.Font = Enum.Font.GothamBold
            tag.TextSize = 8
            tag.TextColor3 = Color3.new(1, 1, 1)
            tag.Text = "CHROMA"
            tag.ZIndex = 3
            tag.Parent = tile
            Instance.new("UICorner", tag).CornerRadius = UDim.new(0, 4)
        end

        tile.Activated:Connect(function()
            local ok, err = pcall(visual.spawn, item.key, 1)
            if ok then
                tile.BackgroundColor3 = Color3.fromRGB(0, 120, 85)
                task.delay(0.2, function()
                    if tile.Parent then tile.BackgroundColor3 = Color3.fromRGB(10, 10, 13) end
                end)
            else
                warn("[Onyx Visual Skins] spawn failed:", err)
            end
        end)
        tileRecords[#tileRecords + 1] = {tile = tile, search = (tostring(item.key) .. " " .. tostring(item.name)):lower()}
    end

    search:GetPropertyChangedSignal("Text"):Connect(function()
        local query = search.Text:lower()
        for _, record in ipairs(tileRecords) do
            record.tile.Visible = query == "" or record.search:find(query, 1, true) ~= nil
        end
    end)

    task.spawn(function()
        local images = {}
        for _, record in ipairs(tileRecords) do
            local image = record.tile:FindFirstChildWhichIsA("ImageLabel")
            if image then images[#images + 1] = image end
        end
        pcall(function() game:GetService("ContentProvider"):PreloadAsync(images) end)
    end)

    return true
end

startOnyxVisualSkinChanger = function()
    local previousIdentity = nil
    pcall(function()
        if type(getthreadidentity) == "function" then
            previousIdentity = getthreadidentity()
        end
    end)

    local ok, result = pcall(buildOnyxVisualSkinEngine)
    if ok and type(result) == "table" then
        local gridOk, gridErr = pcall(buildOnyxVisualSkinGrid, result)
        if not gridOk then warn("[Onyx Visual Skins] grid setup failed:", gridErr) end
    end

    pcall(function()
        if previousIdentity ~= nil and type(setthreadidentity) == "function" then
            setthreadidentity(previousIdentity)
        end
    end)

    return ok, result
end

local function onyxVisualSkinDespawnAll()
    local visual = _G.__MM2Viz
    if type(visual) == "table" and type(visual.despawnAll) == "function" then
        local ok, result = pcall(visual.despawnAll)
        return ok, result
    end
    return false, "Visual Skin Changer is not running"
end

local function onyxVisualSkinClose()
    local visual = _G.__MM2Viz
    if type(visual) == "table" and type(visual.destroy) == "function" then
        pcall(visual.destroy)
    end
    _G.__MM2Viz = nil
end

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

    local VERSION = "v1.0.0"
    W:InfoTab({
        Name = "Info", Icon = "info", SectionTitle = "Information", Banner = "79662603577585",
        BannerAspectRatio = 16/5, Version = VERSION, DiscordLink = "https://discord.gg/pWpgqVGxNK",
        DiscordName = "Community BolongHub", DiscordText = 'Gabung untuk update & support.',
        DiscordDesc = 'Made by 11rill — features: Killer & Survivor Hitbox/ESP, Auto Aim, Auto Generator, Killer Warn, Camera Veil, and many more.',
        CardsWidget = { { catwidget = "rbxassetid://117486345000318" } },
    })

    local MainTab = W:AddTab({Name = "Main", Icon = "house"})
    local AutoFarmTab = W:AddTab({Name = "Auto Farm", Icon = "bot"})
    local CombatTab = W:AddTab({Name = "Combat", Icon = "crosshair"})
    local MurdererTab = W:AddTab({Name = "Murderer", Icon = "skull"})
    local VisualsTab = W:AddTab({Name = "Visuals", Icon = "eye"})
    local MiscTab = W:AddTab({Name = "Misc", Icon = "settings"})
    local SkinsTab = W:AddTab({Name = "Skins", Icon = "palette"})
    local ConfigManagerTab = W:AddTab({Name = "Configuration", Icon = "settings"})

    local TabSoundNames = {
        ["Info"] = true,
        ["Main"] = true,
        ["Auto Farm"] = true,
        ["Combat"] = true,
        ["Murderer"] = true,
        ["Visuals"] = true,
        ["Misc"] = true,
        ["Skins"] = true,
        ["Configuration"] = true
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
        Title = "Hitbox Expander",
        Default = false,
        Callback = function(v)
            SetHitboxExpand(v == true)
        end
    })
    HitboxSec:AddSlider({
        Title = "Hitbox Size",
        Min = 1, Max = 30, Default = 8, Increment = 1,
        Callback = function(v)
            SetHitboxSize(v)
        end
    })

    local WallHopSec = MainTab:AddSection("WallHop", nil)
    local wallHopEnabled = false
    local wallHopBusy = false
    local wallHopLastAt = 0
    local WALLHOP_RAY_DISTANCE = 4
    local WALLHOP_PUSH_SPEED = 14
    local WALLHOP_COOLDOWN = 0.2

    local function getWallHopHit(character, root)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {character}
        for _, direction in ipairs({root.CFrame.LookVector, root.CFrame.RightVector, -root.CFrame.RightVector}) do
            local hit = Workspace:Raycast(root.Position, direction * WALLHOP_RAY_DISTANCE, params)
            if hit and hit.Instance and hit.Instance.CanCollide then
                return hit
            end
        end
        return nil
    end

    local function performWallHop()
        if not wallHopEnabled or wallHopBusy or os.clock() - wallHopLastAt < WALLHOP_COOLDOWN then return end
        local character = localPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end
        local hit = getWallHopHit(character, root)
        if not hit then return end
        local away = Vector3.new(-hit.Normal.X, 0, -hit.Normal.Z)
        if away.Magnitude < 0.05 then return end
        local push = away.Unit
        wallHopBusy = true
        task.spawn(function()
            local function pushJump()
                if not root.Parent or not humanoid.Parent then return end
                root.AssemblyLinearVelocity = Vector3.new(push.X * WALLHOP_PUSH_SPEED, root.AssemblyLinearVelocity.Y, push.Z * WALLHOP_PUSH_SPEED)
                humanoid.Jump = true
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            pushJump()
            task.wait(0.12)
            if root.Parent then
                local old = root.CFrame
                root.CFrame = CFrame.lookAt(root.Position, root.Position + push) * CFrame.Angles(0, math.rad(60), 0)
                task.wait(0.08)
                if root.Parent then root.CFrame = CFrame.lookAt(root.Position, root.Position + push) end
            end
            task.wait(0.03)
            pushJump()
            wallHopBusy = false
            wallHopLastAt = os.clock()
        end)
    end

    WallHopSec:AddToggle({Title = "WallHop", Default = false, Callback = function(v)
        wallHopEnabled = v == true
    end})
    UserInputService.JumpRequest:Connect(performWallHop)

    local GodModeSec = MainTab:AddSection("God Mode [BETA]", nil)
    GodModeSec:AddButton({
        Title = "God Mode [BETA]",
        Callback = function()
            local role = getRole(localPlayer)
            if role == "Murderer" then
                Chloex:Notify({Title = "God Mode", Content = "Onyx method only supports Innocent/Sheriff.", Duration = 4})
                return
            end
            local map
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:FindFirstChild("CoinAreas") or obj:FindFirstChild("CoinContainer") then map = obj; break end
            end
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not map or not humanoid then
                Chloex:Notify({Title = "God Mode", Content = "Start a round first, then try again.", Duration = 4})
                return
            end
            local spawns = map:FindFirstChild("Spawns")
            local spawnPart
            if spawns then
                for _, part in ipairs(spawns:GetChildren()) do
                    if part:IsA("BasePart") then
                        spawnPart = spawnPart or part
                        if part.Name == "Spawn" or part.Name == "PlayerSpawn" or part.Name == "SpawnLocation" then
                            spawnPart = part
                            break
                        end
                    end
                end
            end
            if not spawnPart then
                Chloex:Notify({Title = "God Mode", Content = "Map spawn point was not found; no reset was performed.", Duration = 4})
                return
            end
            local spawnCFrame = spawnPart.CFrame
            task.spawn(function()
                pcall(function() humanoid.Health = 0 end)
                local newCharacter = localPlayer.CharacterAdded:Wait()
                local root = newCharacter:WaitForChild("HumanoidRootPart", 10)
                local newHumanoid = newCharacter:FindFirstChildOfClass("Humanoid")
                if root then
                    if newHumanoid then
                        newHumanoid.PlatformStand = false
                        newHumanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    root.CFrame = CFrame.new(spawnCFrame.X, spawnCFrame.Y + spawnPart.Size.Y / 2 + 4, spawnCFrame.Z)
                    Chloex:Notify({Title = "God Mode [BETA]", Content = "Onyx respawn-to-spawn method completed. Invulnerability depends on the current server implementation.", Duration = 5})
                else
                    Chloex:Notify({Title = "God Mode", Content = "Respawn timed out.", Duration = 4})
                end
            end)
        end
    })

    local MainInvisibleBarrierSec = MainTab:AddSection("Remove invisible barrier", nil)
    MainInvisibleBarrierSec:AddToggle({
        Title = "Remove invisible barrier",
        Default = false,
        Callback = function(v)
            SetRemoveInvisibleBarriers(v == true)
        end
    })


    local AntiStealerSec = SkinsTab:AddSection("Anti Stealer", nil)
    local onyxAntiStealer = false
    AntiStealerSec:AddToggle({
        Title = "Anti Stealer",
        Default = false,
        Callback = function(v)
            onyxAntiStealer = v == true
        end
    })


    local SkinChangerSec = SkinsTab:AddSection("Visual Skin Changer", nil)
    SkinChangerSec:AddButton({Title = "Skin Changer", Callback = function()
        local current = _G.__MM2Viz
        if type(current) == "table" and current.gui and current.gui.Parent then
            Chloex:Notify({Title = "Visual Skin Changer", Content = "Already open. Choose a skin from the search grid.", Duration = 3})
            return
        end
        task.spawn(function()
            local ok, result = startOnyxVisualSkinChanger()
            if ok and type(result) == "table" then
                Chloex:Notify({Title = "Visual Skin Changer", Content = "Loaded " .. tostring(#(result.list or {})) .. " Onyx visual skins.", Duration = 5})
            else
                Chloex:Notify({Title = "Visual Skin Changer", Content = "Couldn't load: " .. tostring(result), Duration = 6})
            end
        end)
    end})
    SkinChangerSec:AddButton({Title = "Unlock All Skin", Callback = function()
        onyxUnlockAllLocalSkins()
    end})
    SkinChangerSec:AddButton({Title = "Despawn All Skin", Callback = function()
        local ok, result = onyxVisualSkinDespawnAll()
        if ok then
            Chloex:Notify({Title = "Visual Skin Changer", Content = "All spawned visual skins were despawned.", Duration = 3})
        else
            Chloex:Notify({Title = "Visual Skin Changer", Content = tostring(result), Duration = 3})
        end
    end})
    SkinChangerSec:AddButton({Title = "Close Skin Changer", Callback = function()
        onyxVisualSkinClose()
        Chloex:Notify({Title = "Visual Skin Changer", Content = "Visual renderer closed and overlays cleaned up.", Duration = 3})
    end})

    local AutoFarmSec = AutoFarmTab:AddSection("AUTO FARM COINS", nil)
    AutoFarmSec:AddToggle({
        Title = "AutoFarm",
        Default = false,
        Callback = function(v)
            if v == true then
                startAutoFarm()
            else
                stopAutoFarm()
            end
        end
    })
    AutoFarmSec:AddSlider({
        Title = "Farm Speed",
        Min = 7,
        Max = 30,
        Default = 12,
        Increment = 1,
        Callback = function(v)
            autoFarmSpeed = math.clamp(tonumber(v) or 12, 7, 30)
        end
    })
    AutoFarmSec:AddSlider({
        Title = "Between Delay",
        Min = 0.4,
        Max = 2,
        Default = 1,
        Increment = 0.1,
        Callback = function(v)
            autoFarmCollectDelay = math.clamp(tonumber(v) or 1, 0.4, 2)
        end
    })
    AutoFarmSec:AddToggle({
        Title = "Auto Reset When Bag Full",
        Default = false,
        Callback = function(v) autoFarmResetWhenFull = v == true end
    })
    AutoFarmSec:AddToggle({
        Title = "Fling Murderer When Bag Full",
        Default = false,
        Callback = function(v) autoFarmFlingMurdererWhenFull = v == true end
    })
    AutoFarmSec:AddToggle({
        Title = "Kill All When Bag Full",
        Default = false,
        Callback = function(v) murdererKillAllEnabled = v == true end
    })
    AutoFarmSec:AddToggle({
        Title = "Anti AFK",
        Default = false,
        Callback = function(v)
            antiAFKEnabled = v == true
        end
    })
    AutoFarmSec:AddToggle({
        Title = "Auto Hop Server When Server Dies",
        Default = true,
        Callback = function(v) onyxAutoHopDeadServer = v == true end
    })


    local webhookGui
    local function openWebhookEditor()
        if webhookGui and webhookGui.Parent then webhookGui:Destroy() end
        local gui = Instance.new("ScreenGui")
        gui.Name = "BolongWebhookEditor"
        gui.ResetOnSpawn = false
        gui.Parent = PlayerGui
        local frame = Instance.new("Frame")
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.Position = UDim2.fromScale(0.5, 0.5)
        frame.Size = UDim2.fromOffset(320, 150)
        frame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
        frame.BorderSizePixel = 0
        frame.Parent = gui
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
        local box = Instance.new("TextBox")
        box.Position = UDim2.fromOffset(12, 14)
        box.Size = UDim2.new(1, -24, 0, 38)
        box.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
        box.TextColor3 = Color3.new(1, 1, 1)
        box.PlaceholderText = "Discord Webhook URL"
        box.Text = onyxWebhookUrl
        box.ClearTextOnFocus = false
        box.Parent = frame
        local save = Instance.new("TextButton")
        save.Position = UDim2.fromOffset(12, 64)
        save.Size = UDim2.new(0.5, -18, 0, 34)
        save.Text = "Save URL"
        save.Parent = frame
        local close = Instance.new("TextButton")
        close.Position = UDim2.new(0.5, 6, 0, 64)
        close.Size = UDim2.new(0.5, -18, 0, 34)
        close.Text = "Close"
        close.Parent = frame
        save.MouseButton1Click:Connect(function()
            onyxWebhookUrl = box.Text:gsub("%s+", "")
            gui:Destroy()
            webhookGui = nil
            Chloex:Notify({Title = "Webhook", Content = onyxWebhookUrl ~= "" and "URL saved locally." or "Webhook URL cleared.", Duration = 3})
        end)
        close.MouseButton1Click:Connect(function() gui:Destroy(); webhookGui = nil end)
        webhookGui = gui
    end

    local SummerEventSec = AutoFarmTab:AddSection("Summer Event", nil)
    SummerEventSec:AddToggle({Title = "Auto Claim Shells", Default = false, Callback = function(v)
        onyxAutoClaimShells = v == true
    end})

    local AutoBoxesSec = AutoFarmTab:AddSection("Auto Open Boxes", nil)
    AutoBoxesSec:AddDropdown({Title = "Box", Values = onyxBoxNames, Options = onyxBoxNames, Default = onyxSelectedBox, Callback = function(v)
        if type(v) == "table" then v = v[1] end
        if table.find(onyxBoxNames, v) then onyxSelectedBox = v end
    end})
    AutoBoxesSec:AddToggle({Title = "Auto Open Boxes", Default = false, Callback = function(v)
        onyxBoxEnabled = v == true
    end})


    local WebhookSec = AutoFarmTab:AddSection("Discord WebHook", nil)
    WebhookSec:AddButton({Title = "Set WebHook URL", Callback = function() openWebhookEditor() end})
    WebhookSec:AddToggle({Title = "Enable WebHook", Default = false, Callback = function(v)
        onyxWebhookEnabled = v == true
        if onyxWebhookEnabled then sendOnyxWebhook("Bolong-Hub MM2 webhook connected.") end
    end})

    local CoinReachSec = AutoFarmTab:AddSection("COINS REACH", nil)
    CoinReachSec:AddToggle({
        Title = "Coin Reach",
        Default = false,
        Callback = function(v)
            coinReachUserEnabled = v == true
            ApplyCoinReach(coinReachUserEnabled or autoFarmOwnsCoinReach)
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
                            obj.Size = originalSize * (autoFarmOwnsCoinReach and 5 or coinReachRange)
                        end)
                    end
                end
            end
        end
    })

    local AutoFarm3DRenderSec = AutoFarmTab:AddSection("Remove 3D Rendering", nil)
    AutoFarm3DRenderSec:AddToggle({
        Title = "Remove 3D Rendering",
        Default = false,
        Callback = function(v)
            render3dCce.Enabled = v == true
        end
    })

    local AutoShootSec = CombatTab:AddSection("Auto Shoot", nil)
    AutoShootSec:AddToggle({
        Title = "Auto Shoot",
        Content = "Pc Press E",
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
        Values = {"Legacy", "Astral"},
        Options = {"Legacy", "Astral"},
        Default = "Legacy",
        Callback = function(v)
            if type(v) == "table" then v = v[1] end
            autoShootMode = (v == "Astral") and "Astral" or "Legacy"
            autoShootJitterState = setmetatable({}, {__mode = "k"})
        end
    })
    AutoShootSec:AddDropdown({
        Title = "Mode",
        Values = {"Normal", "Flick"},
        Options = {"Normal", "Flick"},
        Default = "Normal",
        Callback = function(v)
            if type(v) == "table" then v = v[1] end
            autoShootVariant = (v == "Flick") and "Flick" or "Auto"
        end
    })
    AutoShootSec:AddToggle({
        Title = "TriggerBot",
        Default = false,
        Callback = function(v)
            triggerBotEnabled = v == true
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
        Content = "Pc Press F",
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
            setOnyxAutoGrabGun(v == true)
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
        Content = "Pc Press Q",
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
    MurdererKillSec:AddButton({
        Title = "Kill Sheriff",
        Callback = function() killSheriff() end
    })
    local murderTargetOptions = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            murderTargetOptions[#murderTargetOptions + 1] = player.Name
        end
    end
    local selectedMurderTarget = murderTargetOptions[1]
    local MurderTargetDropdown = MurdererKillSec:AddDropdown({
        Title = "Target",
        Values = murderTargetOptions,
        Options = murderTargetOptions,
        Default = selectedMurderTarget,
        Callback = function(v)
            if type(v) == "table" then v = v[1] end
            selectedMurderTarget = v
        end
    })
    MurdererKillSec:AddButton({
        Title = "Kill Target",
        Callback = function()
            local target = selectedMurderTarget and Players:FindFirstChild(selectedMurderTarget)
            if target then killTarget(target) end
        end
    })
    MurdererKillSec:AddButton({Title = "Refresh Target List", Callback = function()
        local fresh = {}
        for _, player in ipairs(Players:GetPlayers()) do if player ~= localPlayer then fresh[#fresh + 1] = player.Name end end
        table.sort(fresh)
        if selectedMurderTarget and not table.find(fresh, selectedMurderTarget) then selectedMurderTarget = fresh[1] end
        pcall(function()
            if MurderTargetDropdown and MurderTargetDropdown.SetValues then MurderTargetDropdown:SetValues(fresh)
            elseif MurderTargetDropdown and MurderTargetDropdown.SetOptions then MurderTargetDropdown:SetOptions(fresh) end
        end)
        Chloex:Notify({Title = "Target", Content = ("Found %d players."):format(#fresh), Duration = 3})
    end})
    local KnifeHitboxSec = MurdererTab:AddSection("Murderer Knife Hitbox", nil)
    KnifeHitboxSec:AddSlider({
        Title = "Change Knife Hitbox (OP!)",
        Min = 1, Max = 200, Default = 1, Increment = 1,
        Callback = function(v)
            onyxKnifeMultiplier = math.clamp(math.floor(tonumber(v) or 1), 1, 200)
            onyxKnifeReach = 1.5 * (1 + (onyxKnifeMultiplier - 1) * 0.1)
            if onyxKnifeReachShow then updateOnyxKnifeReachSphere() end
        end
    })
    KnifeHitboxSec:AddToggle({
        Title = "Enable Knife Hitbox",
        Default = false,
        Callback = function(v)
            if v then startOnyxKnifeReach() else stopOnyxKnifeReach() end
        end
    })
    KnifeHitboxSec:AddToggle({
        Title = "Show Hitbox",
        Default = false,
        Callback = function(v)
            onyxKnifeReachShow = v == true
            updateOnyxKnifeReachSphere()
        end
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
        Min = 30, Max = 300, Default = 150, Increment = 5,
        Callback = function(v)
            KnifeSilence.circleSize = math.clamp(tonumber(v) or 150, 30, 300)
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
            else
                if roleVisualSource == "FALLBACK" then
                    runInitialKnifeFallbackOnce()
                end
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character then
                        buildRoleBoxes(player)
                    end
                end
            end
        end
    })

    local RoleColorSec = VisualsTab:AddSection("Roles ESP Colors", nil)
    local roleColorChoices = {"Default", "Red", "Blue", "Green", "Yellow", "Purple", "White", "Cyan"}
    local roleColorValues = {
        Default = nil, Red = Color3.fromRGB(255, 40, 40), Blue = Color3.fromRGB(0, 153, 255),
        Green = Color3.fromRGB(0, 255, 8), Yellow = Color3.fromRGB(255, 220, 40),
        Purple = Color3.fromRGB(168, 85, 247), White = Color3.new(1,1,1), Cyan = Color3.fromRGB(0,255,255)
    }
    local function setRoleColor(role, choice)
        if type(choice) == "table" then choice = choice[1] end
        RoleColors[role] = roleColorValues[choice] or (role == "Murderer" and Color3.fromRGB(205,0,0) or role == "Sheriff" and Color3.fromRGB(0,45,200) or Color3.fromRGB(0,190,0))
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then updateRoleBoxDisplay(player) end
        end
    end
    RoleColorSec:AddDropdown({Title = "Murderer Color", Values = roleColorChoices, Options = roleColorChoices, Default = "Default", Callback = function(v) setRoleColor("Murderer", v) end})
    RoleColorSec:AddDropdown({Title = "Sheriff Color", Values = roleColorChoices, Options = roleColorChoices, Default = "Default", Callback = function(v) setRoleColor("Sheriff", v) end})
    RoleColorSec:AddDropdown({Title = "Innocent Color", Values = roleColorChoices, Options = roleColorChoices, Default = "Default", Callback = function(v) setRoleColor("Innocent", v) end})

    local roleRgb = {
        Murderer = {205, 0, 0},
        Sheriff = {0, 45, 200},
        Innocent = {0, 190, 0},
    }
    local function applyRoleRgb(role)
        RoleColors[role] = Color3.fromRGB(roleRgb[role][1], roleRgb[role][2], roleRgb[role][3])
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then updateRoleBoxDisplay(player) end
        end
    end
    for _, roleName in ipairs({"Murderer", "Sheriff", "Innocent"}) do
        local selectedRole = roleName
        for channelIndex, channelName in ipairs({"R", "G", "B"}) do
            local idx = channelIndex
            RoleColorSec:AddSlider({
                Title = selectedRole .. " " .. channelName,
                Min = 0, Max = 255, Default = roleRgb[selectedRole][idx], Increment = 1,
                Callback = function(v)
                    roleRgb[selectedRole][idx] = math.clamp(math.floor(tonumber(v) or roleRgb[selectedRole][idx]), 0, 255)
                    applyRoleRgb(selectedRole)
                end
            })
        end
    end

    local TrapEspSec = VisualsTab:AddSection("Trap Esp", nil)
    TrapEspSec:AddToggle({Title = "Trap Esp", Default = false, Callback = function(v)
        onyxTrapEspEnabled = v == true
        refreshOnyxTrapEsp()
    end})
    TrapEspSec:AddDropdown({Title = "Trap ESP Color", Values = roleColorChoices, Options = roleColorChoices, Default = "Purple", Callback = function(v)
        if type(v) == "table" then v = v[1] end
        onyxTrapColor = roleColorValues[v] or Color3.fromHex("#A855F7")
        refreshOnyxTrapEsp()
    end})

    local trapRgb = {168, 85, 247}
    for channelIndex, channelName in ipairs({"R", "G", "B"}) do
        local idx = channelIndex
        TrapEspSec:AddSlider({Title = "Trap " .. channelName, Min = 0, Max = 255, Default = trapRgb[idx], Increment = 1, Callback = function(v)
            trapRgb[idx] = math.clamp(math.floor(tonumber(v) or trapRgb[idx]), 0, 255)
            onyxTrapColor = Color3.fromRGB(trapRgb[1], trapRgb[2], trapRgb[3])
            refreshOnyxTrapEsp()
        end})
    end

    local PlayerDistanceSec = VisualsTab:AddSection("Player Distance", nil)
    PlayerDistanceSec:AddToggle({
        Title = "Player Distance",
        Default = false,
        Callback = function(v)
            setPlayerDistance(v == true)
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
                -- Showing the UI must never start a round or change timer phase.
                -- WAITING/ENDED stays at 0:00 until the next RoundStart event.
                RoundTimerState.panel.Visible = true
                if RoundTimerState.phase == "RUNNING" then
                    RoundTimerState.label.Text = formatRoundTime(math.max(0, RoundTimerState.endAt - getServerNow()))
                else
                    RoundTimerState.label.Text = "0:00"
                end
                RoundTimerState.statsLabel.Text = string.format("FPS %d    Ping %dms", RoundTimerState.fps, getCurrentPing())
            else
                setRoundTimerGuiVisible(false)
            end
        end
    })

    local MiscFlingSec = MiscTab:AddSection("Anti Fling / Fling", nil)
    MiscFlingSec:AddButton({Title = "Fling All", Callback = function()
        task.spawn(function()
            for _, target in ipairs(Players:GetPlayers()) do
                if target ~= localPlayer then
                    FlingPlayerForDuration(target.Name, 2)
                    task.wait(2.1)
                end
            end
        end)
    end})
    MiscFlingSec:AddButton({Title = "Fling Murderer", Callback = function()
        local target = FindPlayerByRole("Murderer")
        if target then FlingPlayerForDuration(target.Name, 2) end
    end})
    MiscFlingSec:AddButton({Title = "Fling Sheriff", Callback = function()
        local target = FindPlayerByRole("Sheriff")
        if target then FlingPlayerForDuration(target.Name, 2) end
    end})
    local flingNames = getFlingPlayerNames()
    if #flingNames > 0 then selectedFlingPlayerName = flingNames[1] end
    SelectedFlingDropdown = MiscFlingSec:AddDropdown({
        Title = "Target Players", Values = flingNames, Options = flingNames,
        Default = selectedFlingPlayerName,
        Callback = function(v)
            if type(v) == "table" then v = v[1] end
            selectedFlingPlayerName = v
            if selectedFlingEnabled then StartSelectedFling() end
        end
    })
    MiscFlingSec:AddButton({Title = "Fling Player", Callback = function() FlingPlayerForDuration(selectedFlingPlayerName, 2) end})
    MiscFlingSec:AddButton({Title = "Teleport To Murderer", Callback = function()
        local target = FindPlayerByRole("Murderer")
        local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if root and targetRoot then root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3) end
    end})
    MiscFlingSec:AddButton({Title = "Teleport To Sheriff", Callback = function()
        local target = FindPlayerByRole("Sheriff")
        local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if root and targetRoot then root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3) end
    end})
    MiscFlingSec:AddToggle({Title = "Spam Fling", Default = false, Callback = function(v)
        spamFlingEnabled = v == true
        if spamFlingEnabled then
            task.spawn(function()
                while spamFlingEnabled do
                    StartSelectedFling()
                    task.wait(0.25)
                end
                StopSelectedFling()
            end)
        else
            StopSelectedFling()
        end
    end})
    MiscFlingSec:AddToggle({Title = "Anti Fling", Default = false, Callback = function(v) SetAntiFling(v == true) end})

    local CrosshairSec = MiscTab:AddSection("Change Crosshair", nil)
    local crosshairStyles = {}
    for name in pairs(ONYX_CROSSHAIRS) do crosshairStyles[#crosshairStyles + 1] = name end
    table.sort(crosshairStyles, function(a, b)
        if a == "Default" then return true end
        if b == "Default" then return false end
        return a < b
    end)
    CrosshairSec:AddToggle({Title = "Enable Crosshair", Default = false, Callback = function(v) setOnyxCrosshair(v == true) end})
    CrosshairSec:AddDropdown({Title = "Crosshair Style", Values = crosshairStyles, Options = crosshairStyles, Default = "Default", Callback = function(v)
        if type(v) == "table" then v = v[1] end
        onyxCrosshairStyle = ONYX_CROSSHAIRS[v] ~= nil and v or "Default"
        setOnyxCrosshair(onyxCrosshairEnabled)
    end})
    CrosshairSec:AddSlider({Title = "Crosshair Size", Min = 12, Max = 80, Default = 50, Increment = 1, Callback = function(v)
        onyxCrosshairSize = math.clamp(tonumber(v) or 50, 12, 80)
        updateOnyxCrosshair()
    end})
    CrosshairSec:AddToggle({Title = "Spin Cursor", Default = false, Callback = function(v) onyxCrosshairSpin = v == true end})
    CrosshairSec:AddToggle({Title = "Only With Gun", Default = false, Callback = function(v) onyxCrosshairOnlyWithGun = v == true end})

    local MiscInvisibleSec = MiscTab:AddSection("Invisible", nil)
    MiscInvisibleSec:AddToggle({
        Title = "Invisible",
        Default = false,
        Callback = function(v)
            invisibleFeatureEnabled = v == true
            if not invisibleFeatureEnabled and invisibleEnabled then
                SetInvisible(false)
            end
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

    local MiscDeletePetsSec = MiscTab:AddSection("Delete Pets", nil)
    MiscDeletePetsSec:AddToggle({
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

    local ConfigSection = ConfigManagerTab:AddSection("Configuration", true)
    ConfigSection:AddConfig()

end

BuildUI()
roundTimerHooksReady = true
print("BOLONG-HUB MM2 - DISCORD.GG/PWPGQVGXNK LOADED!")

