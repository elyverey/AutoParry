local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")
local Chloex = loadstring(game:HttpGet("https://raw.githubusercontent.com/RillBoys/bolong.catui/refs/heads/main/b0lngUi.lua"))()

local ACCENT_COLOR = Color3.fromRGB(0, 180, 255)
local HOLD_GUN_ANIM = "507768375"
local SHOOT_GUN_ANIM = "134826825394657"

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

local function PlayShootSound()
    PlaySoundAsset(75400675151988, 1)
end

local AutoShootEnabled = false
local ShootKeybind = Enum.KeyCode.E
local MobilePanelEnabled = false
local PanelScale = 15

local EspEnabled = false
local EspTransparency = 0.5

local WalkSpeedEnabled = false
local WalkSpeedValue = 16
local JumpPowerEnabled = false
local JumpPowerValue = 50
local NoclipEnabled = false
local InfiniteJumpEnabled = false

local RoleColors = {
    Innocent = Color3.fromRGB(0, 255, 0),
    Hero = Color3.fromRGB(255, 255, 0),
    Sheriff = Color3.fromRGB(0, 120, 255),
    Murderer = Color3.fromRGB(255, 0, 0),
    Lobby = Color3.fromRGB(150, 150, 160)
}

local StoredShootKey = nil
local ShootRemote = nil
local ShootArguments = nil
local ShootHookInstalled = false

local function Notify(title, content, delay)
    Chloex:MakeNotify({
        Title = title or "BOLONG-HUB",
        Description = "Info",
        Content = content or "",
        Color = ACCENT_COLOR,
        Time = 0.4,
        Delay = delay or 2
    })
end

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

    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track.Animation then
                local animId = tostring(track.Animation.AnimationId)
                if string.find(animId, HOLD_GUN_ANIM) or string.find(animId, SHOOT_GUN_ANIM) then
                    return "Sheriff"
                end
            end
        end
    end

    if char:FindFirstChild("HumanoidRootPart") then
        return "Innocent"
    end

    return "Lobby"
end

local TargetLimbNames = {
    {Name="Head",Size=Vector3.new(1.25,1.25,1.25)},
    {Name="Torso",Size=Vector3.new(2.1,2.1,1.1)},
    {Name="UpperTorso",Size=Vector3.new(2.1,1.1,1.1)},
    {Name="LowerTorso",Size=Vector3.new(2,1,1)},
    {Name="Left Arm",Size=Vector3.new(1.1,2.1,1.1)},
    {Name="Right Arm",Size=Vector3.new(1.1,2.1,1.1)},
    {Name="LeftUpperArm",Size=Vector3.new(1.1,1.1,1.1)},
    {Name="LeftLowerArm",Size=Vector3.new(1,1.1,1)},
    {Name="LeftHand",Size=Vector3.new(1,.8,1)},
    {Name="RightUpperArm",Size=Vector3.new(1.1,1.1,1.1)},
    {Name="RightLowerArm",Size=Vector3.new(1,1.1,1)},
    {Name="RightHand",Size=Vector3.new(1,.8,1)},
    {Name="Left Leg",Size=Vector3.new(1.1,2.1,1.1)},
    {Name="Right Leg",Size=Vector3.new(1.1,2.1,1.1)},
    {Name="LeftUpperLeg",Size=Vector3.new(1.1,1.1,1.1)},
    {Name="LeftLowerLeg",Size=Vector3.new(1,1.1,1)},
    {Name="LeftFoot",Size=Vector3.new(1,.8,1)},
    {Name="RightUpperLeg",Size=Vector3.new(1.1,1.1,1.1)},
    {Name="RightLowerLeg",Size=Vector3.new(1,1.1,1)},
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
end

local function SetupPlayerESP(player)
    if player == localPlayer then return end

    local function onCharAdded(character)
        character:WaitForChild("HumanoidRootPart", 5)
        task.wait(0.3)
        Create3DLimbESP(character)
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

            if EspEnabled then
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

RunService.RenderStepped:Connect(function()
    UpdateESP()
    ApplyMovement()
    ApplyNoclip()
end)

-- =========================================================
-- NIGHT HUB STYLE MM2 LAYOUT ON BOLONGUI / CHLOEX
-- Old Auto Shoot hook/mobile panel implementation removed.
-- =========================================================

local Camera = workspace.CurrentCamera

local viewEnabled = false
local selectedViewPlayer = localPlayer.Name

local autoFarmActive = false
local autoPickupGunActive = false
local aimbotActive = false
local autoShootActive = false
local instaShootMurderActive = false
local killAuraActive = false
local killAuraDistance = 15
local AutoShootEnabled = false
local ShootKeybind = Enum.KeyCode.E
local MobilePanelEnabled = false
local PanelScale = 15
local droppedGunEspEnabled = false
local droppedGunBillboard = nil
local droppedGunHighlight = nil

local espTracerEnabled = false
local showUsernameEnabled = false
local espHighlights = {}
local espTracers = {}
local usernameBillboards = {}
local tracersFolder = Instance.new("Folder")
tracersFolder.Name = "Bolong_NightHub_Tracers"
tracersFolder.Parent = Workspace

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

local function getGunForNightHub()
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

local function getCoinPart()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local n = string.lower(obj.Name)
        if n == "coin" or n == "coincontainer" or n:find("coin") then
            if obj:IsA("BasePart") then
                return obj
            elseif obj:IsA("Model") then
                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if part then return part end
            end
        end
    end
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

    for _, line in pairs(espTracers) do
        if line then pcall(function() line:Destroy() end) end
    end
    espTracers = {}
    tracersFolder:ClearAllChildren()

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

-- Role ESP
RunService.RenderStepped:Connect(function()
    if not EspEnabled then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            local h = espHighlights[p]
            if not h then
                h = Instance.new("Highlight")
                h.Name = "BolongRoleHighlight"
                h.Adornee = p.Character
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Parent = p.Character
                espHighlights[p] = h
            end

            local role = getRole(p)
            h.FillColor = getRoleColor(role)
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.Enabled = true
        end
    end
end)

-- Tracers
RunService.RenderStepped:Connect(function()
    if not espTracerEnabled then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local line = espTracers[p]

            if not line then
                line = Instance.new("Part")
                line.Name = "Tracer"
                line.Anchored = true
                line.CanCollide = false
                line.CanQuery = false
                line.CanTouch = false
                line.Material = Enum.Material.Neon
                line.Size = Vector3.new(0.05, 0.05, 1)
                line.Parent = tracersFolder
                espTracers[p] = line
            end

            line.Color = getRoleColor(getRole(p))

            local screenCenter = Vector3.new(
                Camera.ViewportSize.X / 2,
                Camera.ViewportSize.Y,
                0
            )

            local _, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local origin = Camera:ViewportPointToWorld(
                    screenCenter.X,
                    screenCenter.Y,
                    1
                )
                local targetPos = hrp.Position
                local distance = (origin - targetPos).Magnitude

                line.Transparency = 0
                line.CFrame = CFrame.new(origin, targetPos)
                    * CFrame.new(0, 0, -distance / 2)
                line.Size = Vector3.new(0.05, 0.05, distance)
            else
                line.Transparency = 1
            end
        end
    end
end)

-- Dropped Gun ESP
local function clearDroppedGunESP()
    if droppedGunBillboard then
        droppedGunBillboard:Destroy()
        droppedGunBillboard = nil
    end
    if droppedGunHighlight then
        droppedGunHighlight:Destroy()
        droppedGunHighlight = nil
    end
end

local function updateDroppedGunESP()
    if not droppedGunEspEnabled then
        clearDroppedGunESP()
        return
    end

    local gunDrop = getGunDrop()
    if not gunDrop then
        clearDroppedGunESP()
        return
    end

    if not droppedGunHighlight or droppedGunHighlight.Adornee ~= gunDrop then
        clearDroppedGunESP()

        droppedGunHighlight = Instance.new("Highlight")
        droppedGunHighlight.Name = "BolongDroppedGunHighlight"
        droppedGunHighlight.Adornee = gunDrop
        droppedGunHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        droppedGunHighlight.FillColor = Color3.fromRGB(0, 170, 255)
        droppedGunHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        droppedGunHighlight.FillTransparency = 0.35
        droppedGunHighlight.Parent = gunDrop

        droppedGunBillboard = Instance.new("BillboardGui")
        droppedGunBillboard.Name = "BolongDroppedGunESP"
        droppedGunBillboard.Size = UDim2.new(0, 140, 0, 35)
        droppedGunBillboard.StudsOffset = Vector3.new(0, 2.5, 0)
        droppedGunBillboard.AlwaysOnTop = true
        droppedGunBillboard.Adornee = gunDrop
        droppedGunBillboard.Parent = gunDrop

        local label = Instance.new("TextLabel")
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundTransparency = 1
        label.Text = "DROPPED GUN"
        label.TextColor3 = Color3.fromRGB(80, 200, 255)
        label.TextStrokeTransparency = 0.15
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Parent = droppedGunBillboard
    end
end

RunService.RenderStepped:Connect(updateDroppedGunESP)

-- Username
RunService.RenderStepped:Connect(function()
    if not showUsernameEnabled then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local bb = usernameBillboards[p]

            if not bb then
                bb = Instance.new("BillboardGui")
                bb.Name = "Bolong_NightHub_UserTag"
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
end)

-- Auto Farm
task.spawn(function()
    while task.wait(0.5) do
        if autoFarmActive then
            local part = getCoinPart()
            if part then
                local char = localPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local old = hrp.CFrame
                    hrp.CFrame = part.CFrame
                    task.wait(0.1)
                    if hrp.Parent then
                        hrp.CFrame = old
                    end
                end
            end
        end
    end
end)

-- Auto Pickup Gun
task.spawn(function()
    while task.wait(0.25) do
        if autoPickupGunActive then
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

-- Sheriff Aimbot
RunService.RenderStepped:Connect(function()
    if not aimbotActive then return end

    local closestTarget
    local shortestDist = math.huge

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and getRole(p) == "Murderer" and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (
                        Vector2.new(screenPoint.X, screenPoint.Y)
                        - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    ).Magnitude

                    if dist < shortestDist then
                        shortestDist = dist
                        closestTarget = hrp
                    end
                end
            end
        end
    end

    if closestTarget then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
    end
end)

-- Night Hub style Auto Shoot / Insta Shoot implementation.
-- This intentionally uses Tool:Activate rather than the removed old
-- remote-hook implementation from mm2.lua.
task.spawn(function()
    while task.wait(0.1) do
        if autoShootActive then
            local gun = getGunForNightHub()
            if gun then
                equipTool(gun)
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= localPlayer and getRole(p) == "Murderer" and p.Character then
                        pcall(function()
                            gun:Activate()
                        end)
                        break
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.05) do
        if instaShootMurderActive then
            local gun = getGunForNightHub()
            if gun then
                equipTool(gun)
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= localPlayer and getRole(p) == "Murderer" and p.Character then
                        pcall(function()
                            gun:Activate()
                        end)
                    end
                end
            end
        end
    end
end)

-- =========================================================
-- ORIGINAL BOLONG MM2 AUTO-SHOOT PANEL
-- Reused from the original mm2.lua, wired to the rebuilt Auto Shoot.
-- =========================================================

local function autoShoot()
    local gun = getGunForNightHub()
    if not gun then
        Notify("Auto Shoot", "ไม่พบปืนในตัวคุณ!", 1.5)
        return
    end

    local murderer
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and getRole(p) == "Murderer" and p.Character then
            murderer = p
            break
        end
    end

    if not murderer then
        Notify("Auto Shoot", "ไม่พบตัว Murderer ในเกม!", 1.5)
        return
    end

    local targetPart = murderer.Character:FindFirstChild("UpperTorso")
        or murderer.Character:FindFirstChild("Torso")
        or murderer.Character:FindFirstChild("HumanoidRootPart")

    if not targetPart then return end

    PlayShootSound()

    equipTool(gun)
    pcall(function()
        gun:Activate()
    end)

    Notify("Auto Shoot", "พยายามยิงใส่ " .. murderer.Name .. " แล้ว", 1.5)
end

local MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "BolongFrutigerPanel"
MobileGui.ResetOnSpawn = false
pcall(function()
    MobileGui.Parent = localPlayer:WaitForChild("PlayerGui")
end)

local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.BackgroundColor3 = Color3.fromRGB(15,25,40)
MainPanel.BackgroundTransparency = .7
MainPanel.Position = UDim2.new(.5,-100,.5,-25)
MainPanel.Size = UDim2.new(0,200,0,50)
MainPanel.Visible = false
MainPanel.Active = true
MainPanel.Parent = MobileGui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0,12)
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
ShootLabel.Font = Enum.Font.FredokaOne
ShootLabel.Parent = MainPanel

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
            if AutoShootEnabled then
                autoShoot()
            else
                Notify("Auto Shoot", "เปิด Auto Shoot ก่อน", 1.2)
            end
        end
    end
end)

local function UpdatePanelScale(value)
    PanelScale = math.clamp(tonumber(value) or 15, 7, 30)
    MainPanel.Size = UDim2.new(0, PanelScale * 12, 0, PanelScale * 3.2)
    ShootLabel.TextSize = PanelScale
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if AutoShootEnabled and input.KeyCode == ShootKeybind then
        autoShoot()
    end
end)

-- Murder functions
local function killTarget(targetPlayer)
    local knife = getKnife()
    if not knife then return false end

    equipTool(knife)

    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local targetChar = targetPlayer and targetPlayer.Character
    local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

    if not hrp or not targetHrp then return false end

    local old = hrp.CFrame
    hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 1)

    pcall(function()
        knife:Activate()
    end)

    task.wait(0.15)

    if hrp.Parent then
        hrp.CFrame = old
    end

    return true
end

local function killAll()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            killTarget(p)
            task.wait(0.15)
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
        if killAuraActive and getRole(localPlayer) == "Murderer" then
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
-- UI
-- =========================================================

local function BuildUI()
    local W = Chloex:Window({
        Title = "BOLONG-HUB",
        Image = "84034353458936",
        Footer = "Murder Mystery 2 Exclusive",
        Author = "Night Hub Style",
        Color = ACCENT_COLOR,
        Version = 2,
        Search = true,
        Folder = "BolongHubMM2"
    })

    PlayOpenSound()

    -- Same order as Night Hub:
    -- Main -> Innocent -> Sheriff -> Murder -> Settings -> Credits
    local MainTab = W:AddTab({Name = "Main", Icon = "house"})
    local InnocentTab = W:AddTab({Name = "Innocent", Icon = "shield-check"})
    local SheriffTab = W:AddTab({Name = "Sheriff", Icon = "crosshair"})
    local MurderTab = W:AddTab({Name = "Murder", Icon = "skull"})
    local SettingsTab = W:AddTab({Name = "Settings", Icon = "settings"})
    local CreditsTab = W:AddTab({Name = "Credits", Icon = "info"})
    local MiscTab = W:AddTab({Name = "Misc", Icon = "settings"})

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
        Callback = function(v)
            infJumpEnabled = v == true
        end
    })

    UtilitySec:AddToggle({
        Title = "Noclip",
        Default = false,
        Callback = function(v)
            noclipEnabled = v == true
            NoclipEnabled = noclipEnabled
            if not noclipEnabled then
                SetNoclip(false)
            end
        end
    })

    local TeleportSec = MainTab:AddSection("Teleport & View", nil)

    local playerDropdown = TeleportSec:AddDropdown({
        Title = "Select Player",
        Values = getPlayerList(),
        Default = localPlayer.Name,
        Callback = function(v)
            if v and v ~= "" then
                selectedViewPlayer = v
            end
        end
    })

    Players.PlayerAdded:Connect(function()
        pcall(function() playerDropdown:Refresh(getPlayerList()) end)
    end)

    Players.PlayerRemoving:Connect(function()
        pcall(function() playerDropdown:Refresh(getPlayerList()) end)
    end)

    TeleportSec:AddButton({
        Title = "Go To Player",
        Callback = function()
            local target = Players:FindFirstChild(selectedViewPlayer)
            local targetHrp = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

            if targetHrp and hrp then
                hrp.CFrame = targetHrp.CFrame
            end
        end
    })

    TeleportSec:AddToggle({
        Title = "View Player",
        Default = false,
        Callback = function(v)
            viewEnabled = v == true
            if not viewEnabled then
                local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    Camera.CameraSubject = hum
                end
            end
        end
    })

    local VisualSec = MainTab:AddSection("Visuals", nil)

    VisualSec:AddToggle({
        Title = "ESP Roles",
        Default = false,
        Callback = function(v)
            EspEnabled = v == true
            if not EspEnabled then
                for _, h in pairs(espHighlights) do
                    if h then h:Destroy() end
                end
                espHighlights = {}
            end
        end
    })

    VisualSec:AddToggle({
        Title = "ESP Tracer",
        Default = false,
        Callback = function(v)
            espTracerEnabled = v == true
            if not espTracerEnabled then
                for _, line in pairs(espTracers) do
                    if line then line:Destroy() end
                end
                espTracers = {}
                tracersFolder:ClearAllChildren()
            end
        end
    })

    VisualSec:AddToggle({
        Title = "Show Username",
        Default = false,
        Callback = function(v)
            showUsernameEnabled = v == true
            if not showUsernameEnabled then
                for _, bb in pairs(usernameBillboards) do
                    if bb then bb:Destroy() end
                end
                usernameBillboards = {}
            end
        end
    })

    VisualSec:AddToggle({
        Title = "3D Limb ESP",
        Default = false,
        Callback = function(v)
            EspEnabled = v == true
            if not EspEnabled then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Character then
                        local folder = p.Character:FindFirstChild("BolongLimbESPFolder")
                        if folder then
                            for _, box in ipairs(folder:GetChildren()) do
                                if box:IsA("BoxHandleAdornment") then
                                    box.Visible = false
                                end
                            end
                        end
                    end
                end
            end
        end
    })

    VisualSec:AddToggle({
        Title = "ESP Dropped Gun",
        Default = false,
        Callback = function(v)
            droppedGunEspEnabled = v == true
            if not droppedGunEspEnabled then
                clearDroppedGunESP()
            end
        end
    })

    local FarmSec = MainTab:AddSection("Farm", nil)

    FarmSec:AddToggle({
        Title = "Auto Farm",
        Default = false,
        Callback = function(v)
            autoFarmActive = v == true
        end
    })

    -- INNOCENT
    local InnocentSec = InnocentTab:AddSection("Innocent", nil)

    InnocentSec:AddToggle({
        Title = "Auto Pickup Gun",
        Default = false,
        Callback = function(v)
            autoPickupGunActive = v == true
        end
    })

    InnocentSec:AddButton({
        Title = "Pickup Gun",
        Callback = function()
            local part = getGunDrop()
            if part then
                local char = localPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local old = hrp.CFrame
                    hrp.CFrame = part.CFrame
                    task.wait(0.3)
                    if hrp.Parent then
                        hrp.CFrame = old
                    end
                end
            else
                Notify("Night Hub", "GunDrop not found.", 1.5)
            end
        end
    })

    -- SHERIFF
    local SheriffSec = SheriffTab:AddSection("Sheriff", nil)

    SheriffSec:AddToggle({
        Title = "Aimbot",
        Default = false,
        Callback = function(v)
            aimbotActive = v == true
        end
    })

    SheriffSec:AddToggle({
        Title = "Auto Shoot",
        Default = false,
        Callback = function(v)
            autoShootActive = v == true
        end
    })

    SheriffSec:AddToggle({
        Title = "Insta Shoot Murder",
        Default = false,
        Callback = function(v)
            instaShootMurderActive = v == true
        end
    })

    SheriffSec:AddToggle({
        Title = "Auto Shoot (Keybind Enable)",
        Default = false,
        Callback = function(v)
            AutoShootEnabled = v == true
            autoShootActive = AutoShootEnabled
            Notify("Auto Shoot", AutoShootEnabled and "Auto Shoot Enabled" or "Disabled", 1)
        end
    })

    SheriffSec:AddKeybind({
        Title = "Auto Shoot Keybind",
        Default = Enum.KeyCode.E,
        Callback = function(key)
            ShootKeybind = key
        end
    })

    SheriffSec:AddToggle({
        Title = "Mobile Auto Shoot Panel",
        Default = false,
        Callback = function(v)
            MobilePanelEnabled = v == true
            MainPanel.Visible = MobilePanelEnabled
        end
    })

    SheriffSec:AddSlider({
        Title = "Mobile Panel Scale",
        Min = 7,
        Max = 30,
        Default = 15,
        Increment = 1,
        Callback = function(v)
            UpdatePanelScale(v)
        end
    })

    -- MURDER
    local MurderSec = MurderTab:AddSection("Murder", nil)

    MurderSec:AddButton({
        Title = "Kill All",
        Callback = function()
            killAll()
        end
    })

    MurderSec:AddButton({
        Title = "Kill Sheriff",
        Callback = function()
            killSheriff()
        end
    })

    MurderSec:AddToggle({
        Title = "Kill Aura",
        Default = false,
        Callback = function(v)
            killAuraActive = v == true
        end
    })

    MurderSec:AddSlider({
        Title = "Kill Aura Distance",
        Min = 15, Max = 100, Default = 15, Increment = 1,
        Callback = function(v)
            killAuraDistance = tonumber(v) or 15
        end
    })

    MurderTab:AddSection("Murderer")

    MurderSec:AddButton({
        Title = "Kill All (Murderer)",
        Callback = function()
            if getRole(localPlayer) ~= "Murderer" then
                Notify("Murderer", "คุณไม่ใช่ Murderer", 1.5)
                return
            end
            killAll()
        end
    })

    MurderSec:AddButton({
        Title = "Kill Sheriff (Murderer)",
        Callback = function()
            if getRole(localPlayer) ~= "Murderer" then
                Notify("Murderer", "คุณไม่ใช่ Murderer", 1.5)
                return
            end
            killSheriff()
        end
    })

    -- SETTINGS
    local SettingsSec = SettingsTab:AddSection("Settings", nil)

    SettingsSec:AddSlider({
        Title = "UI Transparency",
        Min = 0, Max = 1, Default = 0, Increment = 0.05,
        Callback = function(v)
            -- BolongUI owns the actual window styling; keep this setting
            -- intentionally harmless if the current UI build does not expose it.
        end
    })

    SettingsSec:AddButton({
        Title = "Reset Camera",
        Callback = function()
            local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                Camera.CameraSubject = hum
            end
            Camera.FieldOfView = 70
        end
    })

    SettingsSec:AddButton({
        Title = "Cleanup Visuals",
        Callback = function()
            cleanupVisuals()
            EspEnabled = false
            espTracerEnabled = false
            showUsernameEnabled = false
            Notify("Night Hub", "Visuals cleaned.", 1.2)
        end
    })

    -- CREDITS
    local CreditsSec = CreditsTab:AddSection("Night Hub Style", nil)

    CreditsSec:AddLabel({
        Title = "BOLONG-HUB MM2",
        Content = "BolongUI interface with Night Hub tab layout."
    })

    CreditsSec:AddLabel({
        Title = "Tabs",
        Content = "Main / Innocent / Sheriff / Murder / Settings / Credits"
    })

    CreditsSec:AddLabel({
        Title = "UI",
        Content = "Chloe / b0lngUi"
    })

    -- MISC (restored from the original mm2.lua)
    local MiscSec = MiscTab:AddSection("Misc Info", nil)
    MiscSec:AddLabel({
        Title = "BOLONG-HUB Exclusive",
        Content = "MM2 True Silent Aim Loaded!"
    })

    MiscSec:AddLabel({
        Title = "Night Hub Layout",
        Content = "Main / Innocent / Sheriff / Murder / Settings / Credits / Misc"
    })

    Notify("BOLONG-HUB", "Night Hub style loaded successfully.", 2)
end

BuildUI()
print("BOLONG-HUB MM2 - NIGHT HUB STYLE LOADED!")
