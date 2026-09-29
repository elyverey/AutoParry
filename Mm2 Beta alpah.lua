-- ============================================
-- MODERN GUI + ESP & AUTO SHOOT MURDER (MM2) - FULL VERSION
-- ============================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============ ESP STATE ============
local ESPEnabled = {
    Murderer = true,
    Sheriff = true,
    Gun = true
}
local ESPObjects = {}
local autoShootEnabled = false

-- ============ DETECTION FUNCTIONS ============
local function isMurderer(player)
    local char = player.Character
    if not char then return false end
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local n = item.Name:lower()
            if n:find("knife") or n:find("murder") or n:find("blade") then return true end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local n = item.Name:lower()
                if n:find("knife") or n:find("murder") or n:find("blade") then return true end
            end
        end
    end
    return false
end

local function isSheriff(player)
    local char = player.Character
    if not char then return false end
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local n = item.Name:lower()
            if n:find("gun") or n:find("sheriff") then return true end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local n = item.Name:lower()
                if n:find("gun") or n:find("sheriff") then return true end
            end
        end
    end
    return false
end

local function isDroppedGun(obj)
    if not obj:IsA("BasePart") then return false end
    if not (obj.Name:lower():find("gun") or obj.Name:lower():find("sheriff")) then return false end
    local parent = obj.Parent
    while parent do
        if parent:IsA("Model") and Players:GetPlayerFromCharacter(parent) then return false end
        if parent:IsA("Tool") then return false end
        parent = parent.Parent
    end
    return true
end

-- ============ ESP SYSTEM ============
local function createESP(player)
    if player == LocalPlayer then return end
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.4
    highlight.Enabled = false
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 120, 0, 30)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Enabled = false
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = billboard
    ESPObjects[player] = {Highlight = highlight, Billboard = billboard, Label = label}
    
    RunService.Heartbeat:Connect(function()
        pcall(function()
            local char = player.Character
            if not char or not char:FindFirstChild("Head") then
                highlight.Enabled = false
                billboard.Enabled = false
                return
            end
            highlight.Enabled = false
            billboard.Enabled = false
            if isMurderer(player) and ESPEnabled.Murderer then
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                highlight.Parent = char
                highlight.Enabled = true
                billboard.Parent = char.Head
                label.Text = "🔪 MURDERER"
                label.TextColor3 = Color3.fromRGB(255, 50, 50)
                billboard.Enabled = true
            elseif isSheriff(player) and ESPEnabled.Sheriff then
                highlight.FillColor = Color3.fromRGB(0, 100, 255)
                highlight.OutlineColor = Color3.fromRGB(0, 100, 255)
                highlight.Parent = char
                highlight.Enabled = true
                billboard.Parent = char.Head
                label.Text = "🔫 SHERIFF"
                label.TextColor3 = Color3.fromRGB(50, 150, 255)
                billboard.Enabled = true
            end
        end)
    end)
    
    player.CharacterAdded:Connect(function() task.wait(0.5) end)
end

local function createGunESP()
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:FindFirstChild("ESP_Gun") then v.ESP_Gun:Destroy() end
                end
                if ESPEnabled.Gun then
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if isDroppedGun(v) and not v:FindFirstChild("ESP_Gun") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "ESP_Gun"
                            hl.FillColor = Color3.fromRGB(0, 150, 255)
                            hl.OutlineColor = Color3.fromRGB(0, 200, 255)
                            hl.FillTransparency = 0.5
                            hl.Parent = v
                        end
                    end
                end
            end)
        end
    end)
end

-- ============ AUTO SHOOT SYSTEM ============
local function getGunTool()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") and (item.Name:lower():find("gun") or item.Name:lower():find("sheriff")) then return item end
    end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") and (item.Name:lower():find("gun") or item.Name:lower():find("sheriff")) then return item end
        end
    end
    return nil
end

local function getNearestMurder()
    local nearest = nil
    local shortest = math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            if isMurderer(player) then
                local dist = (myPos - char.HumanoidRootPart.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    nearest = player
                end
            end
        end
    end
    return nearest
end

local function oneShotKill()
    if not autoShootEnabled then return end
    local gun = getGunTool()
    if not gun then return end
    local murder = getNearestMurder()
    if not murder or not murder.Character then return end
    local targetPos = murder.Character.Head and murder.Character.Head.Position or murder.Character.HumanoidRootPart.Position
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    task.wait(0.05)
    if gun.Parent ~= LocalPlayer.Character then
        gun.Parent = LocalPlayer.Character
        task.wait(0.1)
    end
    for _, remote in pairs(gun:GetChildren()) do
        if remote:IsA("RemoteEvent") then
            pcall(function() remote:FireServer() end)
            return
        end
    end
    pcall(function() gun:Activate() end)
end

-- ============ GUI SETUP ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ============ HELPERS ============
local function makeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function makeStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(80, 120, 255)
    s.Thickness = thickness or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function makeDrag(frame, handle)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============ MAIN FRAME ============
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 295)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -147)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
makeCorner(MainFrame, 12)
makeStroke(MainFrame, Color3.fromRGB(70, 110, 255), 1.5)

-- Shadow glow
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 14, 1, 14)
Shadow.Position = UDim2.new(0, -7, 0, -7)
Shadow.BackgroundColor3 = Color3.fromRGB(50, 80, 255)
Shadow.BackgroundTransparency = 0.82
Shadow.BorderSizePixel = 0
Shadow.ZIndex = MainFrame.ZIndex - 1
Shadow.Parent = MainFrame
makeCorner(Shadow, 18)

-- ============ TITLE BAR ============
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 40)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2
TitleBar.Parent = MainFrame
makeCorner(TitleBar, 12)

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 12)
TitleFix.Position = UDim2.new(0, 0, 1, -12)
TitleFix.BackgroundColor3 = Color3.fromRGB(22, 22, 40)
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 2
TitleFix.Parent = TitleBar

local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(0.65, 0, 0, 2)
AccentLine.Position = UDim2.new(0.175, 0, 1, -2)
AccentLine.BackgroundColor3 = Color3.fromRGB(80, 130, 255)
AccentLine.BorderSizePixel = 0
AccentLine.ZIndex = 3
AccentLine.Parent = TitleBar
makeCorner(AccentLine, 2)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = " ⚡ ModPanel"
TitleLabel.Size = UDim2.new(1, -46, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(160, 190, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 3
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "—"
CloseBtn.Size = UDim2.new(0, 28, 0, 22)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -11)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 85)
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 4
CloseBtn.Parent = TitleBar
makeCorner(CloseBtn, 6)

makeDrag(MainFrame, TitleBar)

-- ============ CONTENT ============
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -52)
Content.Position = UDim2.new(0, 10, 0, 48)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 7)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Parent = Content

local function makeSection(text, parent)
    local lbl = Instance.new("TextLabel")
    lbl.Text = text
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(90, 130, 255)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
end

local function makeToggle(labelText, parent)
    local toggled = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 38)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = parent
    makeCorner(btn, 8)
    local stroke = makeStroke(btn, Color3.fromRGB(50, 65, 160), 1.2)

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 10, 0, 10)
    Dot.Position = UDim2.new(0, 12, 0.5, -5)
    Dot.BackgroundColor3 = Color3.fromRGB(60, 70, 120)
    Dot.BorderSizePixel = 0
    Dot.Parent = btn
    makeCorner(Dot, 5)

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = labelText
    Lbl.Size = UDim2.new(1, -30, 1, 0)
    Lbl.Position = UDim2.new(0, 30, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.TextColor3 = Color3.fromRGB(170, 175, 210)
    Lbl.TextSize = 13
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = btn

    local PillBG = Instance.new("Frame")
    PillBG.Size = UDim2.new(0, 34, 0, 18)
    PillBG.Position = UDim2.new(1, -44, 0.5, -9)
    PillBG.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
    PillBG.BorderSizePixel = 0
    PillBG.Parent = btn
    makeCorner(PillBG, 9)

    local PillCircle = Instance.new("Frame")
    PillCircle.Size = UDim2.new(0, 13, 0, 13)
    PillCircle.Position = UDim2.new(0, 3, 0.5, -6.5)
    PillCircle.BackgroundColor3 = Color3.fromRGB(90, 90, 130)
    PillCircle.BorderSizePixel = 0
    PillCircle.Parent = PillBG
    makeCorner(PillCircle, 7)

    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad)

    local function setToggle(state)
        toggled = state
        if toggled then
            TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(25, 35, 70)}):Play()
            TweenService:Create(stroke, tweenInfo, {Color = Color3.fromRGB(90, 140, 255)}):Play()
            TweenService:Create(Dot, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 160, 255)}):Play()
            TweenService:Create(Lbl, tweenInfo, {TextColor3 = Color3.fromRGB(140, 180, 255)}):Play()
            TweenService:Create(PillBG, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 100, 230)}):Play()
            TweenService:Create(PillCircle, tweenInfo, {
                BackgroundColor3 = Color3.fromRGB(220, 235, 255),
                Position = UDim2.new(0, 18, 0.5, -6.5)
            }):Play()
        else
            TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(22, 22, 38)}):Play()
            TweenService:Create(stroke, tweenInfo, {Color = Color3.fromRGB(50, 65, 160)}):Play()
            TweenService:Create(Dot, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 70, 120)}):Play()
            TweenService:Create(Lbl, tweenInfo, {TextColor3 = Color3.fromRGB(170, 175, 210)}):Play()
            TweenService:Create(PillBG, tweenInfo, {BackgroundColor3 = Color3.fromRGB(40, 40, 65)}):Play()
            TweenService:Create(PillCircle, tweenInfo, {
                BackgroundColor3 = Color3.fromRGB(90, 90, 130),
                Position = UDim2.new(0, 3, 0.5, -6.5)
            }):Play()
        end
    end

    btn.MouseButton1Click:Connect(function()
        setToggle(not toggled)
    end)

    return btn, function() return toggled end, setToggle
end

-- ============ ISI PANEL ============
makeSection("  ESP", Content)
local murderToggle, getMurderState, setMurderState = makeToggle("Murder", Content)
local sheriffToggle, getSheriffState, setSheriffState = makeToggle("Sheriff", Content)
local gunToggle, getGunState, setGunState = makeToggle("Gun Drop", Content)

murderToggle.MouseButton1Click:Connect(function()
    ESPEnabled.Murderer = getMurderState()
end)
sheriffToggle.MouseButton1Click:Connect(function()
    ESPEnabled.Sheriff = getSheriffState()
end)
gunToggle.MouseButton1Click:Connect(function()
    ESPEnabled.Gun = getGunState()
end)

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.BackgroundColor3 = Color3.fromRGB(45, 55, 110)
Divider.BorderSizePixel = 0
Divider.Parent = Content

makeSection("  Settings", Content)

local shotPanelOpen = false
local AutoShotBtn, getAutoShot, setAutoShot = makeToggle("Auto Shot", Content)

-- ============ SHOT SUB-PANEL ============
local ShotPanel = Instance.new("Frame")
ShotPanel.Size = UDim2.new(0, 185, 0, 65)
ShotPanel.Position = UDim2.new(0.5, 10, 0.5, -32)
ShotPanel.BackgroundColor3 = Color3.fromRGB(10, 12, 25)
ShotPanel.BackgroundTransparency = 0.25
ShotPanel.BorderSizePixel = 0
ShotPanel.Visible = false
ShotPanel.Parent = ScreenGui
makeCorner(ShotPanel, 10)
makeStroke(ShotPanel, Color3.fromRGB(50, 150, 255), 2)
makeDrag(ShotPanel, ShotPanel)

local SPTitle = Instance.new("TextLabel")
SPTitle.Text = "Auto Shot"
SPTitle.Size = UDim2.new(1, -12, 0, 22)
SPTitle.Position = UDim2.new(0, 10, 0, 6)
SPTitle.BackgroundTransparency = 1
SPTitle.TextColor3 = Color3.fromRGB(80, 170, 255)
SPTitle.TextSize = 11
SPTitle.Font = Enum.Font.GothamBold
SPTitle.TextXAlignment = Enum.TextXAlignment.Left
SPTitle.Parent = ShotPanel

local SPShootBtn = Instance.new("TextButton")
SPShootBtn.Text = "🎯  Shot Murder"
SPShootBtn.Size = UDim2.new(1, -16, 0, 24)
SPShootBtn.Position = UDim2.new(0, 10, 0, 32)
SPShootBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
SPShootBtn.BackgroundTransparency = 0.4
SPShootBtn.BorderSizePixel = 0
SPShootBtn.TextColor3 = Color3.fromRGB(200, 215, 255)
SPShootBtn.Font = Enum.Font.Gotham
SPShootBtn.TextSize = 12
SPShootBtn.TextXAlignment = Enum.TextXAlignment.Left
SPShootBtn.AutoButtonColor = false
SPShootBtn.Parent = ShotPanel
makeCorner(SPShootBtn, 6)

SPShootBtn.MouseButton1Click:Connect(function()
    oneShotKill()
end)

AutoShotBtn.MouseButton1Click:Connect(function()
    task.wait(0.05)
    autoShootEnabled = getAutoShot()
    shotPanelOpen = autoShootEnabled
    ShotPanel.Visible = shotPanelOpen
end)

-- ============ MINIMIZE BUTTON ============
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 42, 0, 42)
MinBtn.Position = UDim2.new(1, -58, 0.5, -21)  -- kanan tengah
MinBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 38)
MinBtn.TextColor3 = Color3.fromRGB(120, 160, 255)
MinBtn.Text = "☰"
MinBtn.TextSize = 20
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.ZIndex = 10
MinBtn.Parent = ScreenGui
makeCorner(MinBtn, 12)
makeStroke(MinBtn, Color3.fromRGB(70, 110, 255), 1.8)

makeDrag(MinBtn, MinBtn)

-- ============ OPEN/CLOSE LOGIC ============
local panelOpen = true

local function setPanel(open)
    panelOpen = open
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    if open then
        MainFrame.Visible = true
        MainFrame.ClipsDescendants = true
        TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 230, 0, 295)
        }):Play()
        MinBtn.Text = "✕"
        for _, v in pairs(MinBtn:GetChildren()) do
            if v:IsA("UIStroke") then
                                v.Color = Color3.fromRGB(200, 80, 80)
            end
        end
    else
        TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 230, 0, 0)
        }):Play()
        task.delay(0.21, function()
            if not panelOpen then
                MainFrame.Visible = false
                ShotPanel.Visible = false
                shotPanelOpen = false
                setAutoShot(false)
                autoShootEnabled = false
            end
        end)
        MinBtn.Text = "☰"
        for _, v in pairs(MinBtn:GetChildren()) do
            if v:IsA("UIStroke") then
                v.Color = Color3.fromRGB(70, 110, 255)
            end
        end
    end
end

CloseBtn.MouseButton1Click:Connect(function()
    setPanel(false)
end)

MinBtn.MouseButton1Click:Connect(function()
    setPanel(not panelOpen)
end)

-- ============ INIT ESP & AUTO SHOOT ============
for _, player in pairs(Players:GetPlayers()) do
    pcall(createESP, player)
end
Players.PlayerAdded:Connect(function(player) pcall(createESP, player) end)
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        pcall(function() ESPObjects[player].Highlight:Destroy() end)
        pcall(function() ESPObjects[player].Billboard:Destroy() end)
        ESPObjects[player] = nil
    end
end)

createGunESP()

print("✅ Modern GUI + ESP + Auto Shoot loaded successfully!")
print("🎯 Activate 'Auto Shot' to reveal the 'Shot Murder' button.")