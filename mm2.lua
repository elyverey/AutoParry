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

local function getMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and GetPlayerRoleMM2(p) == "Murderer" then
                return p
            end
        end
    end
end

local function getGun()
    local char = localPlayer.Character
    if not char then return nil end

    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") and (item:FindFirstChild("Shoot") or item:FindFirstChild("GunServer") or string.find(string.lower(item.Name),"gun")) then
            return item
        end
    end

    local backpack = localPlayer:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and (item:FindFirstChild("Shoot") or item:FindFirstChild("GunServer") or string.find(string.lower(item.Name),"gun")) then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:EquipTool(item)
                    task.wait(.05)
                    return item
                end
            end
        end
    end
end

local function IsGunRemote(remote)
    if not remote then return false end
    if not remote:IsA("RemoteEvent") and not remote:IsA("RemoteFunction") then return false end
    if remote.Name == "Shoot" then return true end

    local parent = remote.Parent
    return parent and (parent.Name == "GunLocal" or parent.Name == "CreateBeam" or parent.Name == "Gun")
end

local function InstallShootHook()
    if ShootHookInstalled then return end
    if typeof(hookmetamethod) ~= "function" or typeof(getnamecallmethod) ~= "function" or typeof(newcclosure) ~= "function" then return end

    ShootHookInstalled = true
    local rawNamecall

    rawNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local args = {...}
        local result = rawNamecall(self, ...)

        local callerOK = true
        if typeof(checkcaller) == "function" then callerOK = not checkcaller() end

        if callerOK then
            local method = getnamecallmethod()
            if (method == "InvokeServer" or method == "FireServer") and IsGunRemote(self) then
                ShootRemote = self
                ShootArguments = args

                for _, arg in ipairs(args) do
                    if type(arg) == "string" then
                        StoredShootKey = arg
                        break
                    end
                end
            end
        end

        return result
    end))
end

InstallShootHook()

local function FindGunShootRemote(gun)
    if not gun then return nil end

    local shoot = gun:FindFirstChild("Shoot")
    if shoot and (shoot:IsA("RemoteEvent") or shoot:IsA("RemoteFunction")) then
        return shoot
    end

    for _, obj in ipairs(gun:GetDescendants()) do
        if IsGunRemote(obj) then return obj end
    end

    if IsGunRemote(ShootRemote) then return ShootRemote end
end

local function BuildDynamicArguments(remote, targetPos, originPos)
    if type(ShootArguments) == "table" and #ShootArguments > 0 then
        local args = {}

        for i, value in ipairs(ShootArguments) do
            if typeof(value) == "Vector3" then
                args[i] = targetPos
            elseif typeof(value) == "CFrame" then
                args[i] = CFrame.new(originPos, targetPos)
            elseif type(value) == "string" and StoredShootKey then
                args[i] = StoredShootKey
            else
                args[i] = value
            end
        end

        return args
    end

    if remote:IsA("RemoteFunction") then
        if StoredShootKey then return {1, targetPos, StoredShootKey} end
        return {1, targetPos}
    end

    if remote:IsA("RemoteEvent") then
        return {true}
    end

    return {}
end

local function InvokeShootRemote(remote, targetPos, originPos)
    if not remote then return false end
    local args = BuildDynamicArguments(remote, targetPos, originPos)

    if remote:IsA("RemoteFunction") then
        return pcall(function() remote:InvokeServer(table.unpack(args)) end)
    elseif remote:IsA("RemoteEvent") then
        return pcall(function() remote:FireServer(table.unpack(args)) end)
    end

    return false
end

local function autoShoot()
    local gun = getGun()
    local murderer = getMurderer()

    if not gun then
        Notify("Auto Shoot","ไม่พบปืนในตัวคุณ!",1.5)
        return
    end

    if not murderer or not murderer.Character then
        Notify("Auto Shoot","ไม่พบตัว Murderer ในเกม!",1.5)
        return
    end

    local targetPart = murderer.Character:FindFirstChild("UpperTorso")
        or murderer.Character:FindFirstChild("Torso")
        or murderer.Character:FindFirstChild("HumanoidRootPart")

    if not targetPart then return end

    PlayShootSound()

    local handle = gun:FindFirstChild("Handle")
    local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    local originPos = handle and handle.Position or (root and root.Position)
    if not originPos then return end

    local targetPos = targetPart.Position
    local remote = FindGunShootRemote(gun)

    if remote and InvokeShootRemote(remote,targetPos,originPos) then
        Notify("Auto Shoot","ยิงใส่ "..murderer.Name.." เรียบร้อย!",1.5)
        return
    end

    pcall(function() gun:Activate() end)
    Notify("Auto Shoot","พยายามยิงใส่ "..murderer.Name.." แล้ว",1.5)
end

local MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "BolongFrutigerPanel"
MobileGui.ResetOnSpawn = false
pcall(function() MobileGui.Parent = PlayerGui end)

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

local dragging, dragInputObject, dragStart, startPos, touchStartTime, dragMoved = false,nil,nil,nil,0,false

MainPanel.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not dragging then
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
            MainPanel.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if dragging and input == dragInputObject then
        dragging = false
        dragInputObject = nil
        PanelStroke.Thickness = 2
        if not dragMoved and os.clock()-touchStartTime < .4 then autoShoot() end
    end
end)

local function UpdatePanelScale(value)
    PanelScale = math.clamp(value,7,30)
    MainPanel.Size = UDim2.new(0,PanelScale*12,0,PanelScale*3.2)
    ShootLabel.TextSize = PanelScale
end

UserInputService.InputBegan:Connect(function(input,gameProcessed)
    if gameProcessed then return end
    if AutoShootEnabled and input.KeyCode == ShootKeybind then autoShoot() end
end)

local function ApplyMovement()
    local char = localPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if WalkSpeedEnabled then hum.WalkSpeed = WalkSpeedValue end
    if JumpPowerEnabled then
        hum.UseJumpPower = true
        hum.JumpPower = JumpPowerValue
    end
end

local function SetNoclip(state)
    NoclipEnabled = state
    if not state and localPlayer.Character then
        for _, obj in ipairs(localPlayer.Character:GetDescendants()) do
            if obj:IsA("BasePart") then obj.CanCollide = true end
        end
    end
end

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

localPlayer.CharacterAdded:Connect(function()
    task.wait(.5)
    ApplyMovement()
end)

RunService.RenderStepped:Connect(function()
    UpdateESP()
    ApplyMovement()

    if NoclipEnabled and localPlayer.Character then
        for _, obj in ipairs(localPlayer.Character:GetDescendants()) do
            if obj:IsA("BasePart") then obj.CanCollide = false end
        end
    end
end)

local function BuildUI()
    local W = Chloex:Window({
        Title="BOLONG-HUB",
        Image="84034353458936",
        Footer="Murder Mystery 2 Exclusive",
        Author="Discord.gg/pWpgqVGxNK",
        Color=ACCENT_COLOR,
        Version=1,
        Search=true,
        Folder="BolongHubMM2"
    })

    PlayOpenSound()

    local MovementTab = W:AddTab({Name="Movement",Icon="footprints"})
    local ExclusiveTab = W:AddTab({Name="Exclusive",Icon="sparkles"})
    local MiscTab = W:AddTab({Name="Misc",Icon="settings"})

    local MovementSec = MovementTab:AddSection("Movement",nil)

    MovementSec:AddToggle({
        Title="Enable WalkSpeed",
        Default=false,
        Callback=function(v) WalkSpeedEnabled=v ApplyMovement() end
    })

    MovementSec:AddSlider({
        Title="WalkSpeed",
        Min=16,Max=200,Default=16,Increment=1,
        Callback=function(v) WalkSpeedValue=v ApplyMovement() end
    })

    MovementSec:AddToggle({
        Title="Enable JumpPower",
        Default=false,
        Callback=function(v) JumpPowerEnabled=v ApplyMovement() end
    })

    MovementSec:AddSlider({
        Title="Jump Power",
        Min=50,Max=300,Default=50,Increment=1,
        Callback=function(v) JumpPowerValue=v ApplyMovement() end
    })

    MovementSec:AddToggle({
        Title="Enable Noclip",
        Default=false,
        Callback=function(v) SetNoclip(v) end
    })

    MovementSec:AddToggle({
        Title="Infinite Jump",
        Default=false,
        Callback=function(v) InfiniteJumpEnabled=v end
    })

    MovementSec:AddButton({
        Title="Reset Character",
        Callback=function()
            local hum=localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health=0 end
        end
    })

    local AutoShootSec = ExclusiveTab:AddSection("Auto Shoot Settings",nil)

    AutoShootSec:AddToggle({
        Title="Auto Shoot (Keybind Enable)",
        Default=false,
        Callback=function(v)
            AutoShootEnabled=v
            Notify("Auto Shoot",v and "Auto Shoot Enabled" or "Disabled",1)
        end
    })

    AutoShootSec:AddKeybind({
        Title="Auto Shoot Keybind",
        Default=Enum.KeyCode.E,
        Callback=function(Key) ShootKeybind=Key end
    })

    AutoShootSec:AddToggle({
        Title="Mobile Auto Shoot Panel",
        Default=false,
        Callback=function(v)
            MobilePanelEnabled=v
            MainPanel.Visible=v
        end
    })

    AutoShootSec:AddSlider({
        Title="Mobile Panel Scale",
        Min=7,Max=30,Default=15,Increment=1,
        Callback=function(v) UpdatePanelScale(v) end
    })

    local EspSec = ExclusiveTab:AddSection("MM2 3D Limb Box ESP Settings",nil)

    EspSec:AddToggle({
        Title="Enable 3D Limb Box ESP",
        Default=false,
        Callback=function(v)
            EspEnabled=v
            Notify("3D Limb Box ESP",v and "ESP Enabled" or "ESP Disabled",1)
        end
    })

    EspSec:AddSlider({
        Title="Box Transparency",
        Min=0,Max=1,Default=.5,Increment=.05,
        Callback=function(v) EspTransparency=v end
    })

    for role, color in pairs({
        Innocent=RoleColors.Innocent,
        Hero=RoleColors.Hero,
        Sheriff=RoleColors.Sheriff,
        Murderer=RoleColors.Murderer
    }) do
        EspSec:AddColorpicker({
            Title=role,
            Default=color,
            Callback=function(v) RoleColors[role]=v end
        })
    end

    local MiscSec = MiscTab:AddSection("Misc Info",nil)
    MiscSec:AddLabel({
        Title="BOLONG-HUB Exclusive",
        Content="MM2 True Silent Aim Loaded!"
    })
end

BuildUI()
print("BOLONG-HUB MM2 LOADED!")
