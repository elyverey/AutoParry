local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "GrassHub - Ultimate Suite",
   LoadingTitle = "Made by Grass Hub",
   LoadingSubtitle = "Server-Sided Physics, ESP & Enhanced Stealth",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GrassHubConfig",
      FileName = "UltimateSuiteConfig_V2"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = false
   },
   KeySystem = false
})

-- Global Variables
local TelekinesisEnabled = true
local GrabbedPart = nil
local BodyPos = nil
local BodyGyro = nil
local GrabBox = nil
local OriginalProperties = {}

-- ESP Variables
local UnanchoredESPEnabled = false
local ESPRadius = 150
local ESPUpdateTick = 0
local CoreGui = game:GetService("CoreGui")
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "GrassHub_TK_ESP"
pcall(function() ESPFolder.Parent = CoreGui end)
if not ESPFolder.Parent then ESPFolder.Parent = workspace.Terrain end

-- Part Aura Variables
local PartAuraEnabled = false
local AuraRadius = 15
local AuraSpeed = 3
local AuraHeight = 2
local MaxAuraParts = 20
local AuraAngle = 0
local CachedAuraParts = {}
local AuraUpdateTick = 0

-- Player Mod Variables (Fly & Upgraded Invis)
local FlyEnabled = false
local FlySpeed = 50
local FlyConnection = nil
local BV = nil
local BG = nil

local InvisEnabled = false
local InvisOriginalTransparency = {}
local InvisConnections = {}
local StoredClothing = {}

-- Physics Settings
local HoldDistance = 15
local MinDistance = 5
local MaxDistance = 500
local ThrowForce = 500000
local SpinSpeed = 15
local IsSpinning = false
local CurrentSpinAngle = 0
local TKConnection = nil
local HighlightESP = nil
local TargetHighlightEnabled = true

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- Safe Character Filter Setup
local function UpdateTargetFilter()
    if LocalPlayer.Character then
        Mouse.TargetFilter = LocalPlayer.Character
    end
end
UpdateTargetFilter()
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    Mouse.TargetFilter = char
end)

-- Target Finding (Strictly Unanchored, Flawless Detection)
local function GetTargetUnderCursor()
    local mouseRay = Mouse.UnitRay
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local filterList = {}
    if LocalPlayer.Character then
        table.insert(filterList, LocalPlayer.Character)
    end
    raycastParams.FilterDescendantsInstances = filterList
    raycastParams.IgnoreWater = true

    local raycastResult = Workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 5000, raycastParams)

    if raycastResult and raycastResult.Instance and raycastResult.Instance:IsA("BasePart") then
        return raycastResult.Instance
    end

    if Mouse.Target and Mouse.Target:IsA("BasePart") then
        return Mouse.Target
    end

    return nil
end

local function GetTargetAssembly(target)
    if not target then return nil end
    return target.AssemblyRootPart or target
end

-- Network Ownership Awakener
local function WakePart(part)
    if part and part.Parent and not part.Anchored then
        part.AssemblyLinearVelocity = part.AssemblyLinearVelocity + Vector3.new(0, 0.001, 0)
    end
end

-- Unanchored ESP System
local function UpdateUnanchoredESP()
    ESPFolder:ClearAllChildren()
    if not UnanchoredESPEnabled then return end

    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local count = 0
    local processedAssemblies = {}

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local assembly = obj.AssemblyRootPart or obj

            if not assembly.Anchored and not obj.Anchored and assembly ~= GrabbedPart and not obj:IsDescendantOf(LocalPlayer.Character) then
                local model = obj:FindFirstAncestorWhichIsA("Model")
                if not model or not model:FindFirstChild("Humanoid") then
                    if not processedAssemblies[assembly] then
                        if (assembly.Position - root.Position).Magnitude <= ESPRadius then
                            processedAssemblies[assembly] = true

                            local box = Instance.new("SelectionBox")
                            box.Name = "TK_ESP_Box"
                            box.Adornee = assembly
                            box.LineThickness = 0.04
                            box.Color3 = Color3.fromRGB(0, 255, 125)
                            box.SurfaceTransparency = 0.85
                            box.SurfaceColor3 = Color3.fromRGB(0, 200, 100)
                            box.Parent = ESPFolder

                            count = count + 1
                            if count > 200 then break end
                        end
                    end
                end
            end
        end
    end
end

-- Mouse Target Highlight
local function UpdateHighlight()
    if not TargetHighlightEnabled or GrabbedPart then
        if HighlightESP then HighlightESP:Destroy(); HighlightESP = nil end
        return
    end

    local target = GetTargetUnderCursor()
    if target then
        local assembly = GetTargetAssembly(target)

        if assembly.Anchored or target.Anchored then
            if HighlightESP then HighlightESP:Destroy(); HighlightESP = nil end
            return
        end

        if not HighlightESP or HighlightESP.Adornee ~= assembly then
            if HighlightESP then HighlightESP:Destroy() end
            HighlightESP = Instance.new("Highlight")
            HighlightESP.Name = "TKHoverHighlight"
            HighlightESP.FillColor = Color3.fromRGB(0, 255, 150)
            HighlightESP.OutlineColor = Color3.fromRGB(255, 255, 255)
            HighlightESP.FillTransparency = 0.5
            HighlightESP.OutlineTransparency = 0.2
            HighlightESP.Adornee = assembly

            pcall(function() HighlightESP.Parent = CoreGui end)
            if not HighlightESP.Parent then HighlightESP.Parent = Workspace.Terrain end
        end
    else
        if HighlightESP then HighlightESP:Destroy(); HighlightESP = nil end
    end
end

-- Function to release object
local function ReleaseObject(throwType)
    if GrabbedPart then
        if BodyPos then
            if BodyPos:IsA("AlignPosition") and BodyPos.Attachment1 then
                BodyPos.Attachment1:Destroy()
            end
            BodyPos:Destroy()
            BodyPos = nil
        end
        if BodyGyro then BodyGyro:Destroy(); BodyGyro = nil end
        if GrabBox then GrabBox:Destroy(); GrabBox = nil end

        local att0 = GrabbedPart:FindFirstChild("TKAtt0")
        if att0 then att0:Destroy() end

        for part, props in pairs(OriginalProperties) do
            if part and part.Parent then
                part.Massless = props.Massless
                part.CanCollide = props.CanCollide
            end
        end
        OriginalProperties = {}

        local mouseRay = Mouse.UnitRay
        WakePart(GrabbedPart)

        if throwType == "Standard" then
            GrabbedPart.AssemblyLinearVelocity = mouseRay.Direction * 150
        elseif throwType == "Fling" then
            GrabbedPart.AssemblyLinearVelocity = mouseRay.Direction * ThrowForce
            GrabbedPart.AssemblyAngularVelocity = Vector3.new(
                math.random(-1000, 1000),
                math.random(-1000, 1000),
                math.random(-1000, 1000)
            )
        end

        GrabbedPart = nil
        IsSpinning = false
        CurrentSpinAngle = 0
        UpdateUnanchoredESP()
    end
end

-- Grab Function
local function AttemptGrab()
    local target = GetTargetUnderCursor()
    if not target then return end

    local rootPart = GetTargetAssembly(target)

    if rootPart.Anchored or target.Anchored then
        Rayfield:Notify({
            Title = "Cannot Grab",
            Content = "Target is anchored. Only unanchored parts can be picked up.",
            Duration = 2,
        })
        return
    end

    GrabbedPart = rootPart
    GrabbedPart.AssemblyLinearVelocity = Vector3.zero
    GrabbedPart.AssemblyAngularVelocity = Vector3.zero
    WakePart(GrabbedPart)

    OriginalProperties = {}
    for _, part in ipairs(GrabbedPart:GetConnectedParts(true)) do
        OriginalProperties[part] = {
            Massless = part.Massless,
            CanCollide = part.CanCollide
        }
        part.Massless = true
        part.CanCollide = false
    end

    local att0 = Instance.new("Attachment")
    att0.Name = "TKAtt0"
    att0.Parent = GrabbedPart

    local att1 = Instance.new("Attachment")
    att1.Name = "TKAtt1"
    att1.Parent = Workspace.Terrain

    local mouseRay = Mouse.UnitRay
    local targetPos = mouseRay.Origin + (mouseRay.Direction * HoldDistance)
    local centerOffset = GrabbedPart.AssemblyCenterOfMass - GrabbedPart.Position
    att1.WorldPosition = targetPos - centerOffset

    BodyPos = Instance.new("AlignPosition")
    BodyPos.Mode = Enum.PositionAlignmentMode.TwoAttachment
    BodyPos.Attachment0 = att0
    BodyPos.Attachment1 = att1
    BodyPos.RigidityEnabled = true
    BodyPos.Parent = GrabbedPart

    BodyGyro = Instance.new("AlignOrientation")
    BodyGyro.Mode = Enum.OrientationAlignmentMode.OneAttachment
    BodyGyro.Attachment0 = att0
    BodyGyro.RigidityEnabled = true
    BodyGyro.CFrame = Camera.CFrame
    BodyGyro.Parent = GrabbedPart

    GrabBox = Instance.new("SelectionBox")
    GrabBox.Name = "TKSelectionBox"
    GrabBox.Color3 = Color3.fromRGB(0, 255, 150)
    GrabBox.LineThickness = 0.08
    GrabBox.Adornee = GrabbedPart
    GrabBox.Parent = GrabbedPart

    Rayfield:Notify({
        Title = "Made by Grass Hub",
        Content = "Grabbed: " .. rootPart.Name,
        Duration = 1.5,
    })

    UpdateUnanchoredESP()
end

-- Server-Sided Part Aura
local function UpdateAuraCache()
    if not PartAuraEnabled then return end

    local newCache = {}
    local count = 0
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local processedAssemblies = {}

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local assembly = obj.AssemblyRootPart or obj

            if not assembly.Anchored and not obj.Anchored and assembly ~= GrabbedPart and not obj:IsDescendantOf(LocalPlayer.Character) then
                local model = obj:FindFirstAncestorWhichIsA("Model")
                if assembly.Size.Magnitude < 40 and (not model or not model:FindFirstChild("Humanoid")) then
                    if not processedAssemblies[assembly] then
                        if (assembly.Position - root.Position).Magnitude < AuraRadius * 2.5 then
                            processedAssemblies[assembly] = true
                            table.insert(newCache, assembly)
                            count = count + 1
                            if count >= MaxAuraParts then break end
                        end
                    end
                end
            end
        end
    end
    CachedAuraParts = newCache
end

local function ProcessAura(deltaTime)
    if not PartAuraEnabled or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

    AuraUpdateTick = AuraUpdateTick + deltaTime
    if AuraUpdateTick > 1 then
        UpdateAuraCache()
        AuraUpdateTick = 0
    end

    local root = LocalPlayer.Character.HumanoidRootPart
    local numParts = #CachedAuraParts

    if numParts == 0 then return end

    AuraAngle = AuraAngle + (AuraSpeed * deltaTime)
    local angleStep = (math.pi * 2) / numParts

    for i, part in ipairs(CachedAuraParts) do
        if part and part.Parent and not part.Anchored and part ~= GrabbedPart then
            local currentAngle = AuraAngle + (i * angleStep)

            local targetPos = root.Position + Vector3.new(
                math.cos(currentAngle) * AuraRadius,
                math.sin(AuraAngle * 2 + i) * AuraHeight,
                math.sin(currentAngle) * AuraRadius
            )

            local distVector = (targetPos - part.Position)
            part.AssemblyLinearVelocity = distVector * 10
            part.AssemblyAngularVelocity = Vector3.new(math.random(-5,5), math.random(-5,5), math.random(-5,5))
        end
    end
end

-- Fly Functionality
local function ToggleFly(state)
    FlyEnabled = state
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    if FlyEnabled then
        if root then
            if BV then BV:Destroy() end
            if BG then BG:Destroy() end

            BV = Instance.new("BodyVelocity")
            BV.Name = "GrassHubFlyVelocity"
            BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BV.Velocity = Vector3.zero
            BV.Parent = root

            BG = Instance.new("BodyGyro")
            BG.Name = "GrassHubFlyGyro"
            BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            BG.CFrame = root.CFrame
            BG.Parent = root

            if humanoid then
                humanoid.PlatformStand = true
            end

            if FlyConnection then FlyConnection:Disconnect() end
            FlyConnection = RunService.RenderStepped:Connect(function()
                if not FlyEnabled or not root or not BV or not BG then return end

                local camCFrame = Camera.CFrame
                local moveDir = Vector3.zero

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + camCFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - camCFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - camCFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + camCFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end

                if moveDir.Magnitude > 0 then
                    BV.Velocity = moveDir.Unit * FlySpeed
                else
                    BV.Velocity = Vector3.zero
                end

                BG.CFrame = camCFrame
            end)
        end
    else
        if FlyConnection then FlyConnection:Disconnect(); FlyConnection = nil end
        if BV then BV:Destroy(); BV = nil end
        if BG then BG:Destroy(); BG = nil end
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

-- UPGRADED ROBUST INVISIBILITY FUNCTIONALITY
local function ToggleInvis(state)
    InvisEnabled = state
    local char = LocalPlayer.Character
    if not char then return end

    if InvisEnabled then
        InvisOriginalTransparency = {}
        StoredClothing = {}

        local function hideObj(obj)
            if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                InvisOriginalTransparency[obj] = obj.Transparency
                obj.Transparency = 1
                obj.LocalTransparencyModifier = 1
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                InvisOriginalTransparency[obj] = obj.Transparency
                obj.Transparency = 1
            elseif obj:IsA("Clothing") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") then
                table.insert(StoredClothing, {obj = obj, parent = obj.Parent})
                obj.Parent = nil -- Hide clothing layers entirely
            elseif obj:IsA("Accessory") then
                local handle = obj:FindFirstChild("Handle")
                if handle then
                    InvisOriginalTransparency[handle] = handle.Transparency
                    handle.Transparency = 1
                    handle.LocalTransparencyModifier = 1
                    for _, child in ipairs(handle:GetChildren()) do
                        if child:IsA("SpecialMesh") or child:IsA("DataModelMesh") then
                            InvisOriginalTransparency[child] = child.Transparency
                            child.Transparency = 1
                        end
                    end
                end
            elseif obj:IsA("WrapLayer") or obj:IsA("WrapDeformer") then
                obj.Enabled = false -- Disable 3D Layered Clothing
            end
        end

        for _, obj in ipairs(char:GetDescendants()) do
            hideObj(obj)
        end

        -- Monitor dynamically loaded items (accessories/tools)
        table.insert(InvisConnections, char.DescendantAdded:Connect(function(obj)
            if InvisEnabled then
                task.spawn(function()
                    task.wait(0.05)
                    hideObj(obj)
                end)
            end
        end))

        Rayfield:Notify({
            Title = "Made by Grass Hub",
            Content = "Enhanced Invis active (Full mesh & layer bypass).",
            Duration = 2,
        })
    else
        for _, conn in ipairs(InvisConnections) do
            if conn then conn:Disconnect() end
        end
        InvisConnections = {}

        for obj, originalTrans in pairs(InvisOriginalTransparency) do
            if obj and obj.Parent then
                if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                    obj.Transparency = originalTrans
                    obj.LocalTransparencyModifier = 0
                elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SpecialMesh") then
                    obj.Transparency = originalTrans
                end
            end
        end

        for _, data in ipairs(StoredClothing) do
            if data.obj and data.parent then
                data.obj.Parent = data.parent
            end
        end
        StoredClothing = {}

        Rayfield:Notify({
            Title = "Made by Grass Hub",
            Content = "Invisibility disabled. Appearance restored.",
            Duration = 2,
        })
    end
end

-- Re-apply on respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(0.6)
    if FlyEnabled then
        ToggleFly(false)
        ToggleFly(true)
    end
    if InvisEnabled then
        ToggleInvis(false)
        ToggleInvis(true)
    end
end)

-- Keybinds and Mouse Listeners
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if TelekinesisEnabled then
            if not GrabbedPart then
                AttemptGrab()
            else
                ReleaseObject("Standard")
            end
        end
    elseif input.KeyCode == Enum.KeyCode.F then
        if TelekinesisEnabled and GrabbedPart then
            ReleaseObject("Fling")
        end
    elseif input.KeyCode == Enum.KeyCode.R then
        if TelekinesisEnabled and GrabbedPart then
            IsSpinning = not IsSpinning
            Rayfield:Notify({
                Title = "Spin Toggled",
                Content = IsSpinning and "Auto-spinning enabled." or "Spin disabled.",
                Duration = 1.5,
            })
        end
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        if TelekinesisEnabled and GrabbedPart then
            HoldDistance = math.clamp(HoldDistance + (input.Position.Z * 5), MinDistance, MaxDistance)
        end
    end
end)

-- Main Render Loop
local function EnableRenderLoop()
    if TKConnection then TKConnection:Disconnect() end
    TKConnection = RunService.RenderStepped:Connect(function(deltaTime)
        UpdateHighlight()
        ProcessAura(deltaTime)

        ESPUpdateTick = ESPUpdateTick + deltaTime
        if ESPUpdateTick > 0.5 then
            UpdateUnanchoredESP()
            ESPUpdateTick = 0
        end

        if TelekinesisEnabled and GrabbedPart then
            if not GrabbedPart:IsDescendantOf(Workspace) or GrabbedPart.Anchored then
                ReleaseObject("None")
                return
            end

            WakePart(GrabbedPart)

            local mouseRay = Mouse.UnitRay
            local targetPos = mouseRay.Origin + (mouseRay.Direction * HoldDistance)
            local centerOffset = GrabbedPart.AssemblyCenterOfMass - GrabbedPart.Position
            local finalPos = targetPos - centerOffset

            if BodyPos and BodyPos:IsA("AlignPosition") then
                BodyPos.Attachment1.WorldPosition = finalPos
            end

            if IsSpinning then
                CurrentSpinAngle = CurrentSpinAngle + math.rad(SpinSpeed)
                if BodyGyro then
                    BodyGyro.CFrame = Camera.CFrame * CFrame.Angles(0, CurrentSpinAngle, 0)
                end
            elseif BodyGyro then
                BodyGyro.CFrame = Camera.CFrame
            end
        end
    end)
end
EnableRenderLoop()

-- UI SETUP
local TKTab = Window:CreateTab("Telekinesis")
local ESPTab = Window:CreateTab("ESP Display")
local AuraTab = Window:CreateTab("Server Aura")
local PlayerTab = Window:CreateTab("Player Mods")

TKTab:CreateSection("Made by Grass Hub - Server Sided TK")

TKTab:CreateToggle({
   Name = "Enable Telekinesis",
   CurrentValue = true,
   Flag = "TKToggleFlag",
   Callback = function(Value)
       TelekinesisEnabled = Value
       if not TelekinesisEnabled then
           ReleaseObject("None")
       end
   end,
})

TKTab:CreateParagraph({
    Title = "Controls Summary",
    Content = "Left Click: Pick up / Drop strictly unanchored object\nF Key: Fling object with immense force\nR Key: Toggle object spin\nMouse Scroll: Push/Pull object closer or further"
})

TKTab:CreateSlider({
   Name = "Spin Speed",
   Range = {1, 100},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 15,
   Flag = "TKSpinSpeedFlag",
   Callback = function(Value)
       SpinSpeed = Value
   end,
})

-- ESP TAB --
ESPTab:CreateSection("Locate Grabbable Objects")

ESPTab:CreateToggle({
   Name = "Strict Unanchored ESP",
   CurrentValue = false,
   Flag = "UnanchoredESPFlag",
   Callback = function(Value)
       UnanchoredESPEnabled = Value
       if not Value then
           ESPFolder:ClearAllChildren()
       else
           UpdateUnanchoredESP()
       end
   end,
})

ESPTab:CreateSlider({
   Name = "ESP Search Radius",
   Range = {50, 1000},
   Increment = 10,
   Suffix = " Studs",
   CurrentValue = 150,
   Flag = "ESPRadiusFlag",
   Callback = function(Value)
       ESPRadius = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Target Hover Highlight",
   CurrentValue = true,
   Flag = "HighlightFlag",
   Callback = function(Value)
       TargetHighlightEnabled = Value
       if not Value and HighlightESP then
           HighlightESP:Destroy()
           HighlightESP = nil
       end
   end,
})

-- AURA TAB --
AuraTab:CreateSection("Server-Sided Part Orbit")
AuraTab:CreateParagraph({
    Title = "Network Ownership Notice",
    Content = "Both TK and Aura force the Roblox engine to grant you 'Network Ownership' of purely unanchored items. Everything is perfectly replicated to the server and fully visible to all other players."
})

AuraTab:CreateToggle({
   Name = "Enable Network Part Aura",
   CurrentValue = false,
   Flag = "AuraToggleFlag",
   Callback = function(Value)
       PartAuraEnabled = Value
       if Value then
           UpdateAuraCache()
       else
           CachedAuraParts = {}
       end
   end,
})

AuraTab:CreateSlider({
   Name = "Aura Radius",
   Range = {5, 50},
   Increment = 1,
   Suffix = " Studs",
   CurrentValue = 15,
   Flag = "AuraRadiusFlag",
   Callback = function(Value)
       AuraRadius = Value
   end,
})

AuraTab:CreateSlider({
   Name = "Aura Speed",
   Range = {1, 15},
   Increment = 0.5,
   Suffix = " Multiplier",
   CurrentValue = 3,
   Flag = "AuraSpeedFlag",
   Callback = function(Value)
       AuraSpeed = Value
   end,
})

AuraTab:CreateSlider({
   Name = "Max Parts in Aura",
   Range = {1, 50},
   Increment = 1,
   Suffix = " Parts",
   CurrentValue = 20,
   Flag = "AuraPartsFlag",
   Callback = function(Value)
       MaxAuraParts = Value
       UpdateAuraCache()
   end,
})

-- PLAYER TAB --
PlayerTab:CreateSection("Made by Grass Hub - Flight & Stealth")

PlayerTab:CreateToggle({
   Name = "Enable Flight (Works seamlessly with TK)",
   CurrentValue = false,
   Flag = "FlightToggleFlag",
   Callback = function(Value)
       ToggleFly(Value)
   end,
})

PlayerTab:CreateSlider({
   Name = "Flight Speed",
   Range = {10, 200},
   Increment = 5,
   Suffix = " Studs/s",
   CurrentValue = 50,
   Flag = "FlightSpeedFlag",
   Callback = function(Value)
       FlySpeed = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "Upgraded Invisibility (Mesh & Layer Bypass)",
   CurrentValue = false,
   Flag = "InvisToggleFlag",
   Callback = function(Value)
       ToggleInvis(Value)
   end,
})

PlayerTab:CreateParagraph({
    Title = "Player Controls Info",
    Content = "Flight Controls: WASD to move, Space to go up, Left Shift to go down. The upgraded invisibility now completely strips 3D layered clothing, accessories, and mesh textures so you stay entirely hidden."
})

Rayfield:Notify({
   Title = "Made by Grass Hub",
   Content = "Ultimate Suite loaded with Upgraded Invisibility.",
   Duration = 5,
})
