local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- Mobile multi-touch guard:
-- When more than one finger is active, don't let Aimlock or Auto Pickup
-- fight with the player's camera/movement touch.
local activeTouchInputs = {}
local activeTouchCount = 0


local function addTwoBubbles(parent, size)
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

local function hasMultipleTouches()
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
            activeTouchCount += 1
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and activeTouchInputs[input] then
        activeTouchInputs[input] = nil
        activeTouchCount = math.max(0, activeTouchCount - 1)
    end
end)
local SoundService = game:GetService("SoundService")

local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local Chloex
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

local ACCENT_COLOR = Color3.fromRGB(0, 180, 255)

local function PlaySoundAsset(soundId, volume)
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

local function PlayOpenSound()
    PlaySoundAsset(134699420140804, 1)
end

local AutoShootEnabled = false
local ShootKeybind = Enum.KeyCode.E
local MobilePanelEnabled = false
local PanelScale = 15
local limbEspEnabled = false

local EspEnabled = false
local EspTransparency = 0.5

local WalkSpeedEnabled = false
local WalkSpeedValue = 16
local JumpPowerEnabled = false
local JumpPowerValue = 50
local NoclipEnabled = false
local InfiniteJumpEnabled = false

local RoleColors = {
    Innocent = Color3.fromRGB(0, 190, 0),
    Hero = Color3.fromRGB(210, 190, 0),
    Sheriff = Color3.fromRGB(0, 45, 200),
    Murderer = Color3.fromRGB(205, 0, 0),
    Lobby = Color3.fromRGB(105, 105, 115)
}


local function GetPlayerRoleMM2(player)
    if not player or not player.Character then
        return "Lobby"
    end

    local char = player.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then
        return "Lobby"
    end

    local backpack = player:FindFirstChildOfClass("Backpack")
    local allTools = {}

    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(allTools, item)
            end
        end
    end

    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            table.insert(allTools, item)
        end
    end

    local hasKnife = false
    local hasGun = false
    local isHero = false

    for _, tool in ipairs(allTools) do
        local toolName = string.lower(tool.Name)

        if toolName == "knife"
            or string.find(toolName, "knife")
            or string.find(toolName, "blade")
            or string.find(toolName, "dagger")
            or string.find(toolName, "slash")
            or tool:FindFirstChild("Stab")
            or tool:FindFirstChild("KnifeServer") then
            hasKnife = true
        elseif toolName == "gun"
            or string.find(toolName, "revolver")
            or string.find(toolName, "pistol")
            or string.find(toolName, "shoot")
            or tool:FindFirstChild("GunServer") then
            if toolName == "herogun" or string.find(toolName, "hero") then
                isHero = true
            else
                hasGun = true
            end
        end
    end

    if hasKnife then return "Murderer" end
    if isHero then return "Hero" end
    if hasGun then return "Sheriff" end

    if char:FindFirstChild("HumanoidRootPart") then
        return "Innocent"
    end

    return "Lobby"
end

local TargetLimbNames = {
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

local function ClearESP(character)
    local folder = character and character:FindFirstChild("BolongLimbESPFolder")
    if folder then folder:Destroy() end
end

local function Create3DLimbESP(character)
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

local function SetupPlayerESP(player)
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

local function UpdateESP()
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
                    local color = RoleColors[GetPlayerRoleMM2(player)] or RoleColors.Innocent
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

local currentSpeed = 16
local currentJump = 50
local currentGravity = workspace.Gravity
local infJumpEnabled = false
local noclipEnabled = false
-- Movement / physics state
local movementOriginals = setmetatable({}, {__mode = "k"})
local gravityOriginal = workspace.Gravity
local fovOriginal = 70
local cameraFovCaptured = false

local function getHumanoid()
    local char = localPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function captureMovementOriginals(hum)
    if not hum or movementOriginals[hum] then return end
    movementOriginals[hum] = {
        WalkSpeed = hum.WalkSpeed,
        JumpPower = hum.JumpPower,
        UseJumpPower = hum.UseJumpPower,
        AutoRotate = hum.AutoRotate
    }
end

local function restoreWalkSpeed(hum)
    local original = hum and movementOriginals[hum]
    if hum and original then
        hum.WalkSpeed = original.WalkSpeed
    end
end

local function restoreJumpPower(hum)
    local original = hum and movementOriginals[hum]
    if hum and original then
        hum.UseJumpPower = original.UseJumpPower
        hum.JumpPower = original.JumpPower
    end
end

local function ApplyMovement()
    local hum = getHumanoid()
    if not hum then return end

    captureMovementOriginals(hum)

    -- Slider default = 16 means "off"; any other value is active.
    if currentSpeed ~= 16 then
        hum.WalkSpeed = currentSpeed
    else
        restoreWalkSpeed(hum)
    end

    -- Slider default = 50 means "off"; any other value is active.
    if currentJump ~= 50 then
        hum.UseJumpPower = true
        hum.JumpPower = currentJump
    else
        restoreJumpPower(hum)
    end
end

local function SetNoclip(state)
    NoclipEnabled = state == true
    noclipEnabled = NoclipEnabled

    if not NoclipEnabled and localPlayer.Character then
        for _, obj in ipairs(localPlayer.Character:GetDescendants()) do
            if obj:IsA("BasePart") then
                -- Restore normal collision rather than leaving it permanently off.
                obj.CanCollide = true
            end
        end
    end
end

local function ApplyNoclip()
    if not NoclipEnabled or not localPlayer.Character then return end
    for _, obj in ipairs(localPlayer.Character:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CanCollide = false
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
    if autoFarmActive then
        stopFarmTween()
        farmSurfaceCFrame = nil
        farmLastCoinPosition = nil
        farmWaitingForRound = false
        farmMovingToSurface = false
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

local Camera = workspace.CurrentCamera

local viewEnabled = false
local selectedViewPlayer = localPlayer.Name

local autoFarmActive = false
local autoFarmSpeed = 6
local autoFarmDelay = 1.2
local autoFarmBusy = false
local antiAFKEnabled = false
local discordWebhook = ""
local autoPickupGunActive = false
local VirtualUser = game:GetService("VirtualUser")

localPlayer.Idled:Connect(function()
    if not antiAFKEnabled then return end

    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end)

local aimbotActive = false
local aimbotFOV = 10
local AimbotPanelScale = 20
local aimbotFOVVisible = false
local autoShootActive = false
local killAuraActive = false
local killAuraDistance = 15
local AutoShootEnabled = false
local ShootKeybind = Enum.KeyCode.E
local MobilePanelEnabled = false
local PanelScale = 15
local limbEspEnabled = false
local droppedGunEspEnabled = false
local showDroppedGunEspNameEnabled = false
local autoThrowKnifeActive = false
local silentKnifeConnections = {}
local silentKnifeCharacterConnection = nil
local silentKnifeBackpackConnection = nil
local silentKnifeBoundEvent = nil

local showUsernameEnabled = false
local espHighlights = {}
local usernameBillboards = {}

local function getPlayerList()
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

local function getRole(player)
    return GetPlayerRoleMM2(player)
end

local function getRoleColor(role)
    return RoleColors[role] or RoleColors.Innocent
end

local function getToolByName(player, name)
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

local function getKnife()
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

local function getKnifeThrownRemote()
    local knife = getKnife()
    if not knife then return nil end

    local events = knife:FindFirstChild("Events")
    local remote = events and events:FindFirstChild("KnifeThrown")
    if remote and remote:IsA("RemoteEvent") then
        return remote
    end

    return nil
end

local function getKnifeTargetFromAimPoint()
    local camera = Workspace.CurrentCamera
    if not camera then return nil end

    local viewport = camera.ViewportSize
    local aimPoint

    -- PC: use the actual mouse/cursor position.
    -- Mobile/touch: use the center of the screen as the aim point.
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        aimPoint = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
    else
        local mouse = localPlayer:GetMouse()
        aimPoint = Vector2.new(mouse.X, mouse.Y)
    end

    local bestRoot = nil
    local bestPixelDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")

            if humanoid and humanoid.Health > 0 and root then
                local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)
                if onScreen and screenPos.Z > 0 then
                    local pixelDistance = (Vector2.new(screenPos.X, screenPos.Y) - aimPoint).Magnitude
                    if pixelDistance < bestPixelDistance then
                        bestPixelDistance = pixelDistance
                        bestRoot = root
                    end
                end
            end
        end
    end

    return bestRoot
end

local function fireKnifeThrowAtTarget(targetRoot)
    if not targetRoot or not targetRoot.Parent then return false end

    local character = localPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local remote = getKnifeThrownRemote()
    if not root or not remote then return false end

    local origin = root.Position
    local targetPosition = targetRoot.Position
    local direction = targetPosition - origin
    if direction.Magnitude < 0.01 then return false end

    local throwCFrame = CFrame.lookAt(origin, targetPosition)
    local targetCFrame = CFrame.new(targetPosition)

    return pcall(function()
        remote:FireServer(throwCFrame, targetCFrame)
    end)
end

local function getNilThrowEvent()
    local ok, result = pcall(function()
        for _, object in getnilinstances() do
            if object.Name == "Event" and object:GetDebugId() == "0_353889" then
                return object
            end
        end
    end)
    return ok and result or nil
end

local function disconnectSilentKnifeConnections()
    for _, connection in ipairs(silentKnifeConnections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(silentKnifeConnections)
    silentKnifeBoundEvent = nil
end

local function connectNilThrowEvent()
    local event = getNilThrowEvent()
    if not event or not event:IsA("BindableEvent") then return false end

    if silentKnifeBoundEvent == event then
        return true
    end

    local connection = event.Event:Connect(function()
        if not autoThrowKnifeActive then return end
        if getRole(localPlayer) ~= "Murderer" then return end

        local targetRoot = getKnifeTargetFromAimPoint()
        if targetRoot then
            fireKnifeThrowAtTarget(targetRoot)
        end
    end)

    table.insert(silentKnifeConnections, connection)
    silentKnifeBoundEvent = event
    return true
end

local function bindSilentKnife()
    if not autoThrowKnifeActive then return end
    if getRole(localPlayer) ~= "Murderer" then return end
    connectNilThrowEvent()
end

local function setSilentKnifeEnabled(enabled)
    autoThrowKnifeActive = enabled == true
    disconnectSilentKnifeConnections()

    if autoThrowKnifeActive then
        bindSilentKnife()
    end
end

if silentKnifeCharacterConnection then
    silentKnifeCharacterConnection:Disconnect()
end
silentKnifeCharacterConnection = localPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    bindSilentKnife()
end)

if silentKnifeBackpackConnection then
    silentKnifeBackpackConnection:Disconnect()
end
local backpack = localPlayer:FindFirstChildOfClass("Backpack")
if backpack then
    silentKnifeBackpackConnection = backpack.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and autoThrowKnifeActive then
            task.wait()
            bindSilentKnife()
        end
    end)
end

-- The throw event can appear in nil after the script starts.
-- Keep looking for that exact event while the feature is enabled.
task.spawn(function()
    while task.wait(0.1) do
        if autoThrowKnifeActive then
            connectNilThrowEvent()
        end
    end
end)

local function getGunForBolong()
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

local function equipTool(tool)
    local char = localPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if tool and hum and tool.Parent ~= char then
        pcall(function()
            hum:EquipTool(tool)
        end)
    end
end

local function getGunDrop()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" then
            if obj:IsA("BasePart") then
                return obj
            elseif obj:IsA("Model") then
                return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            end
        end
    end
end

local function getNearestCoin()
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local nearest = nil
    local nearestDistance = math.huge
    local seen = {}

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = string.lower(obj.Name)
            local isCoin = (name == "coin" or name == "coin_server" or name:find("coin") ~= nil)
                and name ~= "coincontainer"

            if isCoin and not seen[obj]
                and obj.Transparency < 1
                and obj.Parent
            then
                seen[obj] = true

                local distance = (obj.Position - hrp.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearest = obj
                end
            end
        end
    end

    return nearest
end

local function teleportToPart(part)
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and part then
        hrp.CFrame = part.CFrame
        return true
    end
    return false
end

local function cleanupVisuals()
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
    usernameBillboards = {}
end

-- Movement / physics
RunService.Stepped:Connect(function()
    local char = localPlayer.Character
    if char and noclipEnabled then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
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
local roleBoxes = {}

local ROLE_PART_NAMES = {
    "Head",
    "UpperTorso", "Torso",
    "LeftUpperArm", "Left Arm",
    "RightUpperArm", "Right Arm",
    "LeftUpperLeg", "Left Leg",
    "RightUpperLeg", "Right Leg",
}

local function clearRoleBoxes(player)
    local list = roleBoxes[player]
    if list then
        for _, box in ipairs(list) do
            pcall(function() box:Destroy() end)
        end
        roleBoxes[player] = nil
    end
end

local function getRoleParts(character)
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

local function buildRoleBoxes(player)
    clearRoleBoxes(player)

    local character = player.Character
    if not character then return end

    local boxes = {}
    local roleColor = getRoleColor(getRole(player))

    for _, part in ipairs(getRoleParts(character)) do
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "BolongRolePartBox"
        box.Adornee = part
        box.Size = part.Size
        box.Color3 = roleColor
        box.Transparency = 0.65
        box.AlwaysOnTop = true
        box.ZIndex = 1
        box.Parent = part
        table.insert(boxes, box)
    end

    roleBoxes[player] = boxes
end

RunService.Heartbeat:Connect(function()
    if not EspEnabled then
        for player in pairs(roleBoxes) do
            clearRoleBoxes(player)
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local parts = getRoleParts(player.Character)
            local boxes = roleBoxes[player]

            if not boxes or #boxes ~= #parts then
                buildRoleBoxes(player)
            else
                local color = getRoleColor(getRole(player))
                for _, box in ipairs(boxes) do
                    if box.Adornee and box.Adornee.Parent then
                        box.Size = box.Adornee.Size
                        box.Color3 = color
                        box.Transparency = 0.55
                        box.Visible = true
                    end
                end
            end
        elseif player ~= localPlayer then
            clearRoleBoxes(player)
        end
    end

    for player in pairs(roleBoxes) do
        if not Players:FindFirstChild(player.Name) then
            clearRoleBoxes(player)
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
local droppedGunBlock = nil
local droppedGunNameBillboard = nil
local cachedGunDrop = nil

local function clearDroppedGunESPName()
    if droppedGunNameBillboard then
        pcall(function() droppedGunNameBillboard:Destroy() end)
    end
    droppedGunNameBillboard = nil
end

local function clearDroppedGunESP()
    clearDroppedGunESPName()

    if droppedGunBlock then
        pcall(function() droppedGunBlock:Destroy() end)
    end
    droppedGunBlock = nil
end

local function setGunDrop(obj)
    if obj and obj.Name == "GunDrop" and obj:IsA("BasePart") then
        cachedGunDrop = obj
    end
end

for _, obj in ipairs(Workspace:GetDescendants()) do
    if obj.Name == "GunDrop" and obj:IsA("BasePart") then
        cachedGunDrop = obj
        break
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

local function updateDroppedGunESP()
    if not cachedGunDrop or not cachedGunDrop.Parent then
        clearDroppedGunESP()
        return
    end

    -- 3D Box is controlled separately by ESP Dropped Gun.
    if droppedGunEspEnabled then
        if not droppedGunBlock or droppedGunBlock.Adornee ~= cachedGunDrop then
            if droppedGunBlock then
                pcall(function() droppedGunBlock:Destroy() end)
            end

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
        if droppedGunBlock then
            pcall(function() droppedGunBlock:Destroy() end)
        end
        droppedGunBlock = nil
    end

    -- Dropped Gun name works independently from the 3D Box.
    if showDroppedGunEspNameEnabled then
        if not droppedGunNameBillboard or droppedGunNameBillboard.Adornee ~= cachedGunDrop then
            clearDroppedGunESPName()

            local bb = Instance.new("BillboardGui")
            bb.Name = "BolongDroppedGunName"
            bb.Adornee = cachedGunDrop
            bb.Size = UDim2.fromOffset(140, 28)
            bb.StudsOffset = Vector3.new(
                0,
                math.max(1.5, cachedGunDrop.Size.Y * 0.5 + 1.2),
                0
            )
            bb.AlwaysOnTop = true
            bb.Parent = cachedGunDrop

            local txt = Instance.new("TextLabel")
            txt.Name = "DroppedGun"
            txt.Size = UDim2.fromScale(1, 1)
            txt.BackgroundTransparency = 1
            txt.Text = "Dropped Gun"
            txt.TextColor3 = Color3.fromRGB(255, 255, 255)
            txt.TextSize = 13
            txt.Font = Enum.Font.GothamBold
            txt.TextStrokeTransparency = 0.2
            txt.TextXAlignment = Enum.TextXAlignment.Center
            txt.TextYAlignment = Enum.TextYAlignment.Center
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

-- Username
task.spawn(function()
    while task.wait(0.20) do
        if not showUsernameEnabled then
            continue
        end

        for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local bb = usernameBillboards[p]

            if not bb then
                bb = Instance.new("BillboardGui")
                bb.Name = "Bolong_UserTag"
                bb.Size = UDim2.new(0, 200, 0, 50)
                bb.StudsOffset = Vector3.new(0, 2.5, 0)
                bb.AlwaysOnTop = true
                bb.Parent = head

                local txt = Instance.new("TextLabel")
                txt.Name = "Info"
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.TextSize = 12
                txt.Font = Enum.Font.GothamBold
                txt.TextStrokeTransparency = 0.2
                txt.Parent = bb

                usernameBillboards[p] = bb
            end

            local txt = bb:FindFirstChild("Info")
            if txt then
                local role = getRole(p)
                txt.TextColor3 = getRoleColor(role)
                txt.Text = "@" .. p.Name .. "\n(" .. p.DisplayName .. ")"
            end
        end
        end
    end
end)

-- Auto Farm
-- Smooth upright movement to the nearest coin. The character never lies down
-- and never teleports: TweenService moves the HumanoidRootPart through walls
-- while collisions are temporarily disabled.
local farmTween = nil
local farmSurfaceCFrame = nil
local farmLastCoinPosition = nil
local farmCollisionOriginals = {}
local farmWaitingForRound = false
local farmMovingToSurface = false

local function setFarmNoclip(enabled)
    local char = localPlayer.Character
    if not char then return end

    if enabled then
        farmCollisionOriginals = {}
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                farmCollisionOriginals[obj] = obj.CanCollide
                obj.CanCollide = false
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

local function stopFarmTween()
    if farmTween then
        pcall(function() farmTween:Cancel() end)
        farmTween = nil
    end
end

local function getFarmHumanoid()
    local char = localPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function makeUprightCFrame(position, lookVector)
    local flatLook = Vector3.new(lookVector.X, 0, lookVector.Z)
    if flatLook.Magnitude < 0.01 then
        flatLook = Vector3.new(0, 0, -1)
    else
        flatLook = flatLook.Unit
    end
    return CFrame.lookAt(position, position + flatLook)
end

local function tweenFarmTo(cframe)
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not autoFarmActive then return false end

    stopFarmTween()
    setFarmNoclip(true)

    local hum = getFarmHumanoid()
    if hum then
        hum.AutoRotate = false
    end

    local distance = (hrp.Position - cframe.Position).Magnitude
    -- Between 3-20 directly controls movement speed. Higher = faster.
    local duration = math.clamp(distance / math.max(autoFarmSpeed * 2.5, 0.1), 0.18, 12)

    farmTween = TweenService:Create(
        hrp,
        TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
        {CFrame = cframe}
    )

    farmTween:Play()
    local playbackState = farmTween.Completed:Wait()
    farmTween = nil

    if not autoFarmActive or not hrp.Parent then
        return false
    end

    return playbackState == Enum.PlaybackState.Completed
end

local function getFarmCoinTargetCFrame(coin)
    -- R15/R6 HumanoidRootPart is several studs below the top of the head.
    -- Keeping the root ~3.2 studs below the coin leaves the head underneath
    -- the coin instead of sticking through the floor/map.
    local yOffset = 2.9
    local position = coin.Position - Vector3.new(0, yOffset, 0)

    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local look = hrp and hrp.CFrame.LookVector or Vector3.new(0, 0, -1)

    return makeUprightCFrame(position, look)
end

local function getFarmSurfaceCFrame()
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

local function startAutoFarm()
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    stopFarmTween()

    -- Save the actual surface position once, before going underneath coins.
    farmSurfaceCFrame = makeUprightCFrame(hrp.Position, hrp.CFrame.LookVector)
    farmLastCoinPosition = nil
    farmWaitingForRound = false
    farmMovingToSurface = false

    local hum = getFarmHumanoid()
    if hum then
        hum.AutoRotate = false
    end
end

local function stopAutoFarm()
    stopFarmTween()
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

local function farmToCoin(coin)
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not coin or not coin.Parent or not autoFarmActive then
        return false
    end

    autoFarmBusy = true
    farmWaitingForRound = false
    farmMovingToSurface = false
    farmLastCoinPosition = coin.Position

    local targetCFrame = getFarmCoinTargetCFrame(coin)
    local reached = tweenFarmTo(targetCFrame)

    if not reached or not autoFarmActive then
        autoFarmBusy = false
        return false
    end

    -- Stay upright underneath the coin so its touch/collection can register.
    local hum = getFarmHumanoid()
    if hum then
        hum.AutoRotate = false
    end

    task.wait(0.18)

    -- Give the game time to remove/register the coin before the configured delay.
    local deadline = os.clock() + 0.8
    while autoFarmActive and coin.Parent and os.clock() < deadline do
        task.wait(0.05)
    end

    if not autoFarmActive then
        autoFarmBusy = false
        return false
    end

    -- Delay is applied after the pickup attempt, exactly as configured.
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
                -- No coins left: slowly return to the surface area and wait.
                if not farmWaitingForRound then
                    farmWaitingForRound = true
                    local surface = getFarmSurfaceCFrame()
                    if surface then
                        autoFarmBusy = true
                        farmMovingToSurface = true
                        tweenFarmTo(surface)
                        -- Stand normally on the surface while waiting for the next round.
                        setFarmNoclip(false)
                        farmMovingToSurface = false
                        autoFarmBusy = false
                    end
                end
            end
        end
    end
end)

-- Auto Pickup Gun
task.spawn(function()
    while task.wait(0.40) do
        if autoPickupGunActive and not hasMultipleTouches() then
            local part = getGunDrop()
            if part then
                local char = localPlayer.Character
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

-- Sheriff Aimbot with visible Frutiger Aero-style FOV circle.
local aimbotScanAccumulator = 0
RunService.RenderStepped:Connect(function(deltaTime)
    if not aimbotActive or not aimbotFOVVisible then return end
    -- Never fight the mobile camera/movement when two fingers are active.
    if hasMultipleTouches() then return end

    aimbotScanAccumulator += deltaTime
    if aimbotScanAccumulator < 0.05 then return end
    aimbotScanAccumulator = 0

    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local radius = aimbotFOV * 12
    local closestTarget
    local shortestDist = radius

    local localCharacter = localPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and getRole(p) == "Murderer" and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local worldDistance = localRoot and (hrp.Position - localRoot.Position).Magnitude or math.huge
                if worldDistance <= 120 then
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude
                        if dist <= shortestDist then
                            shortestDist = dist
                            closestTarget = hrp
                        end
                    end
                end
            end
        end
    end

    if closestTarget then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
    end
end)

-- =========================================================
-- BOLONG AUTO-SHOOT TARGETING
-- Auto Shoot uses the supplied Shoot.lua FireServer argument pattern.
-- =========================================================

local function getMurdererTargetPart()
    local bestPlayer, bestPart
    local bestScore = math.huge
    local localChar = localPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and getRole(p) == "Murderer" and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            if hum and hum.Health > 0 and root then
                local distance = localRoot and (root.Position - localRoot.Position).Magnitude or 0
                if distance <= 250 then
                    -- Prefer head for a tighter hitbox, then choose the closest murderer.
                    local part = head or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or root
                    local score = distance + (part == head and -2 or 0)
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

-- Auto Shoot now follows the supplied Shoot.lua pattern:
-- Gun.Shoot:FireServer(origin-facing-target CFrame, target CFrame)
-- It does not use Tool:Activate(), camera steering, or the removed animation IDs.
local function fireShotAtTarget(gun, targetPart)
    if not gun or not targetPart or not targetPart.Parent then
        return false
    end

    local shootEvent = gun:FindFirstChild("Shoot")
    if not shootEvent then
        return false
    end

    if not (shootEvent:IsA("RemoteEvent") or shootEvent:IsA("UnreliableRemoteEvent")) then
        return false
    end

    local handle = gun:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then
        return false
    end

    local origin = handle.Position
    local velocity = targetPart.AssemblyLinearVelocity
    local distance = (targetPart.Position - origin).Magnitude

    -- Keep the original distance-based prediction, with a small capped lead.
    local leadTime = math.clamp(distance / 700, 0.02, 0.12)

    -- Add only a small amount of prediction while the target is airborne.
    local humanoid = targetPart.Parent and targetPart.Parent:FindFirstChildOfClass("Humanoid")
    local state = humanoid and humanoid:GetState()
    local airborne = state == Enum.HumanoidStateType.Jumping
        or state == Enum.HumanoidStateType.Freefall

    if airborne then
        leadTime = math.clamp(leadTime + 0.025, 0.02, 0.145)
    end

    local targetPosition = targetPart.Position + velocity * leadTime

    -- Small vertical compensation only while airborne; the original trajectory
    -- remains unchanged for normal ground movement.
    if airborne then
        targetPosition = targetPosition + Vector3.new(
            0,
            0.5 * workspace.Gravity * leadTime * leadTime * 0.12,
            0
        )
    end

    if (targetPosition - origin).Magnitude < 0.01 then
        return false
    end

    local originCFrame = CFrame.lookAt(origin, targetPosition)
    local targetCFrame = CFrame.lookAt(targetPosition, targetPosition + targetPart.CFrame.LookVector)

    return pcall(function()
        shootEvent:FireServer(originCFrame, targetCFrame)
    end)
end

-- Auto Shoot has no background loop; it fires only from the on-screen panel click.

-- =========================================================
-- BOLONG MM2 AUTO-SHOOT PANEL
-- =========================================================

local function autoShoot()
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

    if fireShotAtTarget(gun, targetPart) then

    else
        -- removed: no-gun notification
    end
end

local MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "BolongFrutigerPanel"
MobileGui.ResetOnSpawn = false
pcall(function()
    MobileGui.Parent = localPlayer:WaitForChild("PlayerGui")
end)

local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.BackgroundColor3 = Color3.fromRGB(40,190,255)
MainPanel.BackgroundTransparency = .77
MainPanel.Position = UDim2.new(.5,-100,.5,-25)
MainPanel.Size = UDim2.fromOffset(405, 161)
MainPanel.Visible = false
MainPanel.Active = true
MainPanel.Parent = MobileGui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 24)
PanelCorner.Parent = MainPanel

local PanelStroke = Instance.new("UIStroke")
PanelStroke.Color = Color3.fromRGB(0,195,255)
PanelStroke.Thickness = 2
PanelStroke.Transparency = .2
PanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
PanelStroke.Parent = MainPanel

local ShootLabel = Instance.new("TextLabel")
ShootLabel.Size = UDim2.new(1,0,1,0)
ShootLabel.BackgroundTransparency = 1
ShootLabel.Text = "AUTO SHOOT"
ShootLabel.TextColor3 = Color3.fromRGB(255,255,255)
ShootLabel.TextSize = PanelScale
ShootLabel.ZIndex = 3
ShootLabel.Font = Enum.Font.FredokaOne
ShootLabel.Parent = MainPanel

-- Four small "air bubbles" that gently rise inside the Auto Shoot panel.
local BubbleContainer = Instance.new("Frame")
BubbleContainer.Name = "Bubbles"
BubbleContainer.Size = UDim2.fromScale(1, 1)
BubbleContainer.BackgroundTransparency = 1
BubbleContainer.ClipsDescendants = true
BubbleContainer.Parent = MainPanel

local BubbleData = {
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

local dragging, dragInputObject, dragStart, startPos, touchStartTime, dragMoved =
    false,nil,nil,nil,0,false

MainPanel.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch)
        and not dragging then

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

local function UpdatePanelScale(value)
    -- Scale 10 is the reference size from the user's drawing:
    -- approximately 405 x 161 px.
    PanelScale = math.clamp(tonumber(value) or 10, 5, 20)

    local scaleRatio = PanelScale / 10
    local width = math.clamp(math.floor(405 * scaleRatio + 0.5), 203, 810)
    local height = math.clamp(math.floor(161 * scaleRatio + 0.5), 81, 322)

    MainPanel.Size = UDim2.fromOffset(width, height)

    -- Keep the label comfortably inside the larger panel.
    ShootLabel.TextSize = math.clamp(math.floor(18 * scaleRatio + 0.5), 10, 36)
end

-- Auto Shoot intentionally fires only from the on-screen panel click.

-- =========================================================
-- FRUTIGER AERO AIMBOT PANEL
-- Small circular panel, 75% transparent, centered "AIMBOT" text.
-- =========================================================
local AimbotGui = Instance.new("ScreenGui")
AimbotGui.Name = "BolongAimbotPanel"
AimbotGui.ResetOnSpawn = false
AimbotGui.Parent = PlayerGui

local AimbotPanel = Instance.new("Frame")
AimbotPanel.Name = "AimbotPanel"
AimbotPanel.AnchorPoint = Vector2.new(0.5, 0.5)
AimbotPanel.BackgroundColor3 = Color3.fromRGB(205, 245, 255)
AimbotPanel.BackgroundTransparency = 0.75
AimbotPanel.Position = UDim2.fromScale(0.5, 0.5)
AimbotPanel.Size = UDim2.fromOffset(70, 70)
AimbotPanel.Visible = false
AimbotPanel.Active = true
AimbotPanel.Parent = AimbotGui

local AimbotCorner = Instance.new("UICorner")
AimbotCorner.CornerRadius = UDim.new(1, 0)
AimbotCorner.Parent = AimbotPanel

local AimbotStroke = Instance.new("UIStroke")
AimbotStroke.Color = Color3.fromRGB(0, 170, 255)
AimbotStroke.Thickness = 2
AimbotStroke.Transparency = 0.15
AimbotStroke.Parent = AimbotPanel

local AimbotLabel = Instance.new("TextLabel")
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

local AimbotCircleGui = Instance.new("ScreenGui")
AimbotCircleGui.Name = "BolongAimbotFOV"
AimbotCircleGui.ResetOnSpawn = false
AimbotCircleGui.IgnoreGuiInset = true
AimbotCircleGui.Parent = PlayerGui

local AimbotCircle = Instance.new("Frame")
AimbotCircle.Name = "FOVCircle"
AimbotCircle.AnchorPoint = Vector2.new(0.5, 0.5)
AimbotCircle.Position = UDim2.fromScale(0.5, 0.5)
AimbotCircle.BackgroundTransparency = 1
AimbotCircle.Visible = false
AimbotCircle.Parent = AimbotCircleGui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = AimbotCircle

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Color3.fromRGB(0, 170, 255)
CircleStroke.Thickness = 2
CircleStroke.Transparency = 0.15
CircleStroke.Parent = AimbotCircle

local function UpdateAimbotVisuals()
    -- FOV remains 2..20 in the UI. Keep the visual compact.
    local diameter = math.clamp(aimbotFOV * 12, 24, 240)
    AimbotCircle.Size = UDim2.fromOffset(diameter, diameter)
    AimbotCircle.Visible = aimbotActive and aimbotFOVVisible

    -- The aim panel and FOV circle only exist visually while Aimbot is enabled.
    AimbotPanel.Visible = aimbotActive
end

local aimDragging, aimDragInput, aimDragStart, aimStartPos = false, nil, nil, nil
local aimPressStart = nil
local aimWasDragged = false

AimbotPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
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
        AimbotStroke.Thickness = 2

        -- Tap/click the panel = toggle only the FOV circle.
        -- Dragging the panel does not toggle it.
        if not aimWasDragged and aimPressStart then
            aimbotFOVVisible = not aimbotFOVVisible
            UpdateAimbotVisuals()
        end

        aimPressStart = nil
        aimWasDragged = false
    end
end)

local function UpdateAimbotPanelScale(value)
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
UpdateAimbotVisuals()


-- Murder functions
local function isPlayerAlive(player)
    local char = player and player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function killTarget(targetPlayer)
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

local function killAll()
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or getRole(localPlayer) ~= "Murderer" then return end

    local targets = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and isPlayerAlive(p) and p.Character then
            local targetHrp = p.Character:FindFirstChild("HumanoidRootPart")
            if targetHrp and (hrp.Position - targetHrp.Position).Magnitude <= 300 then
                table.insert(targets, p)
            end
        end
    end

    -- No teleporting and no repeated kill-until-dead loop.
    -- One swing is issued per target while remaining at the same position.
    for _, p in ipairs(targets) do
        if isPlayerAlive(p) then
            killTarget(p)
            task.wait(0.03)
        end
    end
end

local function killSheriff()
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

local function SkidFling(TargetPlayer)
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

local function FindPlayerByRole(role)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and GetPlayerRoleMM2(p) == role then
            return p
        end
    end
    return nil
end

local function PlayMiscEmote(emoteName)
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
local antiFlingEnabled = false
local antiFlingConnection

local function SetAntiFling(enabled)
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
local PickupGui = Instance.new("ScreenGui")
PickupGui.Name = "BolongPickupPanel"
PickupGui.ResetOnSpawn = false
PickupGui.IgnoreGuiInset = true
PickupGui.Parent = PlayerGui

local PickupPanel = Instance.new("Frame")
PickupPanel.Name = "PickupPanel"
PickupPanel.AnchorPoint = Vector2.new(0.5, 0.5)
PickupPanel.Position = UDim2.fromScale(0.5, 0.68)
PickupPanel.Size = UDim2.fromOffset(72, 72)
PickupPanel.BackgroundColor3 = Color3.fromRGB(40, 190, 255)
PickupPanel.BackgroundTransparency = 0.77
PickupPanel.Visible = false
PickupPanel.Active = true
PickupPanel.Parent = PickupGui

local PickupCorner = Instance.new("UICorner")
PickupCorner.CornerRadius = UDim.new(1, 0)
PickupCorner.Parent = PickupPanel

local PickupStroke = Instance.new("UIStroke")
PickupStroke.Color = Color3.fromRGB(0, 170, 255)
PickupStroke.Thickness = 2
PickupStroke.Transparency = 0.08
PickupStroke.Parent = PickupPanel

local PickupLabel = Instance.new("TextLabel")
PickupLabel.Size = UDim2.fromScale(0.88, 0.88)
PickupLabel.Position = UDim2.fromScale(0.06, 0.06)
PickupLabel.BackgroundTransparency = 1
PickupLabel.Text = "PICK UP GUN"
PickupLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PickupLabel.TextSize = 11
PickupLabel.Font = Enum.Font.GothamBold
PickupLabel.TextWrapped = true
PickupLabel.Parent = PickupPanel

local pickupDragging, pickupDragInput, pickupDragStart, pickupStartPos = false, nil, nil, nil
PickupPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        pickupDragInput = nil
    end
end)

PickupPanel.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    -- Let the drag handler own movement; a short tap attempts an immediate pickup.
    local started = os.clock()
    local startPos = input.Position
    task.delay(0.18, function()
        if not pickupDragging and not hasMultipleTouches() and os.clock() - started >= 0.18 then
            local part = getGunDrop()
            local char = localPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if part and hrp then
                local old = hrp.CFrame
                hrp.CFrame = part.CFrame
                task.wait(0.15)
                if hrp.Parent then hrp.CFrame = old end
            end
        end
    end)
end)

function UpdatePickupPanelScale(value)
    local scale = math.clamp(tonumber(value) or 10, 5, 20)
    local diameter = math.clamp(scale * 5.5, 40, 110)
    PickupPanel.Size = UDim2.fromOffset(diameter, diameter)
    PickupLabel.TextSize = math.clamp(scale * 0.8, 7, 16)
end
UpdatePickupPanelScale(10)


local function BuildUI()
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
        Min = 5, Max = >20, Default = >10, Increment = 1,
        Callback = function(v)
            UpdatePanelScale(v)
        end
    })
AutoShootSec:AddToggle({
        Title = "Aimlock",
        Default = false,
        Callback = function(v)
            aimbotActive = v == true
            aimbotFOVVisible = v == true
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
    MurdererSec:AddToggle({
        Title = "Auto Throwing Knife",
        Default = false,
        Callback = function(v)
            setSilentKnifeEnabled(v == true)
        end
    })
    MurdererSec:AddButton({
        Title = "Kill All",
        Callback = function() killAll() end
    })
    MurdererSec:AddButton({
        Title = "Kill Sheriff",
        Callback = function() killSheriff() end
    })
-- VISUALS: only the requested three controls.
    local VisualSec = VisualsTab:AddSection("Features", true)
    VisualSec:AddToggle({
        Title = "ESP Roles",
        Default = false,
        Callback = function(v)
            EspEnabled = v == true
            if not EspEnabled then
                for _, box in pairs(roleBoxes) do if box then box:Destroy() end end
                roleBoxes = {}
            end
        end
    })
    VisualSec:AddToggle({
        Title = "Show Username",
        Default = false,
        Callback = function(v)
            showUsernameEnabled = v == true
            if not showUsernameEnabled then
                for _, bb in pairs(usernameBillboards) do if bb then bb:Destroy() end end
                usernameBillboards = {}
            end
        end
    })
    VisualSec:AddToggle({
        Title = "ESP Dropped Gun",
        Default = false,
        Callback = function(v)
            droppedGunEspEnabled = v == true
            if not droppedGunEspEnabled then clearDroppedGunESP() end
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
            showUsernameEnabled = false
            limbEspEnabled = false
            droppedGunEspEnabled = false
            showDroppedGunEspNameEnabled = false
            clearDroppedGunESP()

        end
    })

end

BuildUI()
print("BOLONG-HUB MM2 - DISCORD.GG/PWPGQVGXNK LOADED!")

