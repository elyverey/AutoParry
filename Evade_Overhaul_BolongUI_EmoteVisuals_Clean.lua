local Chloex = loadstring(game:HttpGet("https://raw.githubusercontent.com/RillBoys/bolong.catui/refs/heads/main/b0lngUi.lua"))()
if not Chloex then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Bolong UI",
            Text = "UI library failed to load.",
            Duration = 5
        })
    end)
    return
end

local VERSION = "v1.0.0"
local ACCENT_COLOR = Color3.fromRGB(255, 255, 255)
if _G.EvadeOverhaulIsAlreadyRunning then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Script is already running!",
            Text = "",
            Duration = 3
        })
    end)
    return
end
_G.EvadeOverhaulIsAlreadyRunning = true

getgenv().ButtonGradients = getgenv().ButtonGradients or {
    Background = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))
    }),
    Stroke = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 180, 255))
    })
}

local Window = Chloex:Window({
    Title = "BOLONG-HUB",
    Image = "84034353458936",
    Footer = "Evade",
    Author = "Discord.gg/pWpgqVGxNK",
    Color = ACCENT_COLOR,
    Version = 1,
    Search = true,
    Folder = "BolongHub"
})
Window:InfoTab({
    Name = "Info",
    Icon = "info",
    SectionTitle = "Information",
    Banner = "79662603577585",
    BannerAspectRatio = 16/5,
    Version = VERSION,
    DiscordLink = "https://discord.gg/pWpgqVGxNK",
    DiscordName = "Community BolongHub",
    DiscordText = "Gabung untuk update & support.",
    DiscordDesc = "Made by 11rill — features: Killer & Survivor Hitbox/ESP, Auto Aim, Auto Generator, Killer Warn, Camera Veil, and many more.",
    CardsWidget = {{catwidget = "rbxassetid://117486345000318"}}
})

local MainTab = Window:AddTab({Name = "Main", Icon = "house"})
local AutoFarmTab = Window:AddTab({Name = "Auto Farm", Icon = "zap"})
local MovementTab = Window:AddTab({Name = "Movement", Icon = "footprints"})
local CombatTab = Window:AddTab({Name = "Combat", Icon = "swords"})
local VisualsTab = Window:AddTab({Name = "Visuals", Icon = "eye"})
local MiscTab = Window:AddTab({Name = "Misc", Icon = "settings"})
local ConfigManagerTab = Window:AddTab({Name = "Configs", Icon = "folder"})
local ConfigSection = ConfigManagerTab:AddSection("Configuration", true)
if ConfigSection and type(ConfigSection.AddConfig) == "function" then
    pcall(function() ConfigSection:AddConfig() end)
end

-- Compatibility adapter: preserve the original control callbacks
-- while creating the controls inside Bolong UI sections.
local BolongCompat = {Options = {}}
local Options = BolongCompat.Options
function BolongCompat:Notify(data)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = tostring(data.Title or "Notice"),
            Text = tostring(data.Content or data.Text or ""),
            Duration = tonumber(data.Duration) or 3
        })
    end)
end

local FBM = {}
function FBM:AddButton(buttonName, frame, hidden) end

local function getSectionRoute(sourceName, sectionName)
    local source = tostring(sourceName or "")
    local title = tostring(sectionName or "")
    local lower = title:lower()
    if source == "Main" then
        return MainTab
    elseif source == "Visuals" then
        return VisualsTab
    elseif source == "AutoFarm" then
        return AutoFarmTab
    elseif source == "Combat" then
        return CombatTab
    elseif source == "Misc" then
        if lower == "player modification" then
            return MainTab
        elseif lower == "lag switchs" or lower == "player adjustments" or lower == "strafe acceleration"
            or lower:find("movement", 1, true) or lower == "emote dash" or lower == "slide"
            or lower == "infinite slide" or lower == "infinity slide" or lower == "gravity"
            or lower == "gravity & bounce modify" or lower == "autojump" or lower == "auto jump"
            or lower == "crouch" then
            return MovementTab
        elseif lower == "gun adjustments" then
            return CombatTab
        end
        return MiscTab
    elseif source == "Settings" then
        return ConfigManagerTab
    elseif source == "Extension" then
        return MiscTab
    end
    return MiscTab
end

local function safeAddSection(tab, name)
    if not tab then return nil end
    local add = tab.AddSection
    if type(add) ~= "function" then return nil end
    local ok, section = pcall(add, tab, name, nil)
    if ok then return section end
    ok, section = pcall(add, tab, name)
    if ok then return section end
    return nil
end

local sectionRegistry = {}
local function registerSection(tab, name)
    if not tab then return nil end
    local key = tostring(name or ""):lower()
    sectionRegistry[tab] = sectionRegistry[tab] or {}
    if sectionRegistry[tab][key] then
        return sectionRegistry[tab][key]
    end
    local section = safeAddSection(tab, name)
    if section then
        sectionRegistry[tab][key] = section
    end
    return section
end

-- Pre-create sections so their visual order is deterministic.
registerSection(MovementTab, "Strafe Acceleration")
registerSection(MovementTab, "Gravity & Bounce Modify")
registerSection(MovementTab, "Lag Switchs")
registerSection(MovementTab, "Auto Jump")
registerSection(MovementTab, "Infinity Slide")
registerSection(MovementTab, "Emote Dash")

registerSection(AutoFarmTab, "Auto Farm")
registerSection(AutoFarmTab, "VIP Automations")
registerSection(AutoFarmTab, "Auto Vote Maps")
registerSection(AutoFarmTab, "Purchase Automations")

local function getParamCount(fn)
    if debug and type(debug.info) == "function" then
        local ok, count = pcall(debug.info, fn, "a")
        if ok and type(count) == "number" then return count end
    end
    return nil
end

local function normalizeControlConfig(kind, title, settings, dispatch)
    local config = {}
    for key, value in pairs(settings or {}) do
        config[key] = value
    end
    config.Name = title
    config.Title = title
    config.Label = title
    config.Text = title
    config.Callback = dispatch
    config.Function = dispatch
    config.Changed = dispatch
    config.OnChanged = dispatch
    if config.Values ~= nil then config.Options = config.Values end
    if config.Default ~= nil then config.Value = config.Default end
    if config.Min ~= nil then config.MinValue = config.Min end
    if config.Max ~= nil then config.MaxValue = config.Max end
    return config
end

local function invokeControlCreator(target, kind, id, title, config, dispatch)
    if not target then return nil end
    local names = {
        Toggle = {"AddToggle", "CreateToggle", "Toggle"},
        Dropdown = {"AddDropdown", "CreateDropdown", "AddSelect", "Dropdown"},
        Input = {"AddInput", "CreateInput", "AddTextInput", "AddTextBox", "AddTextbox", "Input"},
        Slider = {"AddSlider", "CreateSlider", "Slider"},
        Keybind = {"AddKeybind", "AddKeyBind", "CreateKeybind", "Keybind"},
        Button = {"AddButton", "CreateButton", "Button"},
        Paragraph = {"AddParagraph", "AddLabel", "AddText", "AddDescription", "Paragraph"}
    }
    local methodNames = names[kind] or {}
    local function attempt(fn, args)
        local ok, result = pcall(function()
            return fn(target, table.unpack(args))
        end)
        if ok then return true, result end
        return false, nil
    end
    for _, methodName in ipairs(methodNames) do
        local fn = target[methodName]
        if type(fn) == "function" then
            local count = getParamCount(fn)
            local attempts = {}
            if count == 2 then
                attempts = {{config}, {title, config}}
            elseif count == 3 then
                if kind == "Button" then
                    attempts = {{config}, {title, dispatch}, {title, config}}
                elseif kind == "Paragraph" then
                    attempts = {{config}, {title, config.Content or config.Description or ""}, {title, config}}
                else
                    attempts = {{config}, {title, config}, {id, config}}
                end
            elseif count == 4 then
                if kind == "Toggle" or kind == "Keybind" then
                    attempts = {{config}, {title, config.Default, dispatch}, {title, config.Mode, config.Default, dispatch}, {title, config}}
                elseif kind == "Dropdown" then
                    attempts = {{config}, {title, config.Values or config.Options or {}, config.Default, dispatch}, {title, config}}
                elseif kind == "Slider" then
                    attempts = {{config}, {title, config.Min, config.Max, config.Default, dispatch}, {title, config}}
                elseif kind == "Input" then
                    attempts = {{config}, {title, config.Default, dispatch}, {title, config}}
                else
                    attempts = {{config}, {title, config}}
                end
            else
                if kind == "Slider" then
                    attempts = {{config}, {title, config.Min, config.Max, config.Default, dispatch}, {title, config}}
                elseif kind == "Dropdown" then
                    attempts = {{config}, {title, config.Values or config.Options or {}, config.Default, dispatch}, {title, config}}
                elseif kind == "Keybind" then
                    attempts = {{config}, {title, config.Mode, config.Default, dispatch}, {title, config.Default, dispatch}, {title, config}}
                else
                    attempts = {{config}, {title, config}, {title, config.Default, dispatch}}
                end
            end
            for _, args in ipairs(attempts) do
                local ok, result = attempt(fn, args)
                if ok then return result, true end
            end
        end
    end
    return nil, false
end

local function makeCompatTab(sourceName, realTab, initialSection)
    local compat = {
        _sourceName = sourceName,
        _rootTab = realTab,
        _currentTab = realTab,
        _currentSection = initialSection
    }
    function compat:AddSection(title)
        local routedTab = getSectionRoute(self._sourceName, title)
        local key = tostring(title or ""):lower()
        local tabSections = sectionRegistry[routedTab]
        local realSection = tabSections and tabSections[key] or nil
        if not realSection then
            realSection = safeAddSection(routedTab, title)
            if realSection then
                sectionRegistry[routedTab] = sectionRegistry[routedTab] or {}
                sectionRegistry[routedTab][key] = realSection
            end
        end
        self._currentTab = routedTab
        self._currentSection = realSection
        return self
    end
    local function addControl(self, kind, first, second)
        local settings, id
        if type(first) == "table" then
            settings = first
            id = tostring(settings.Title or settings.Name or settings.Label or kind)
        else
            id = tostring(first or kind)
            settings = type(second) == "table" and second or {}
        end
        local title = tostring(settings.Title or settings.Name or settings.Label or id)
        if not self._currentTab then self._currentTab = self._rootTab end
        if not self._currentSection then
            self._currentSection = safeAddSection(self._currentTab, self._sourceName == "Extension" and "Extension" or "General")
        end
        local handle = {_real = nil, _callback = settings.Callback, _fireCount = 0}
        function handle:_dispatch(value)
            self._fireCount = self._fireCount + 1
            if type(self._callback) == "function" then
                pcall(self._callback, value)
            end
        end
        local dispatch = function(value) handle:_dispatch(value) end
        local config = normalizeControlConfig(kind, title, settings, dispatch)
        local target = self._currentSection or self._currentTab or self._rootTab
        local realControl, created = invokeControlCreator(target, kind, id, title, config, dispatch)
        handle._real = realControl
        if not created and target ~= self._currentTab and self._currentTab then
            handle._real = invokeControlCreator(self._currentTab, kind, id, title, config, dispatch)
        end
        function handle:OnChanged(callback)
            self._callback = callback
            return self
        end
        function handle:SetValue(value)
            local before = self._fireCount
            local real = self._real
            if real and type(real.SetValue) == "function" then
                pcall(function() real:SetValue(value) end)
            end
            if before == self._fireCount then self:_dispatch(value) end
        end
        Options[id] = handle
        return handle
    end
    compat.AddToggle = function(self, first, second) return addControl(self, "Toggle", first, second) end
    compat.AddDropdown = function(self, first, second) return addControl(self, "Dropdown", first, second) end
    compat.AddInput = function(self, first, second) return addControl(self, "Input", first, second) end
    compat.AddSlider = function(self, first, second) return addControl(self, "Slider", first, second) end
    compat.AddKeybind = function(self, first, second) return addControl(self, "Keybind", first, second) end
    compat.AddButton = function(self, first, second) return addControl(self, "Button", first, second) end
    compat.AddParagraph = function(self, first, second) return addControl(self, "Paragraph", first, second) end
    return compat
end

local Tabs = {
    Main = makeCompatTab("Main", MainTab),
    AutoFarm = makeCompatTab("AutoFarm", AutoFarmTab),
    Combat = makeCompatTab("Combat", CombatTab),
    Visuals = makeCompatTab("Visuals", VisualsTab),
    Misc = makeCompatTab("Misc", MiscTab),
    Settings = makeCompatTab("Settings", ConfigManagerTab, ConfigSection),
    Extension = makeCompatTab("Extension", MiscTab)
}

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local CAS = game:GetService("ContextActionService")
local CharacterService = require(ReplicatedStorage:WaitForChild("Services"):WaitForChild("Asset"):WaitForChild("CharacterService"))
local ServerStateRegistryService = require(ReplicatedStorage:WaitForChild("Services"):WaitForChild("Data"):WaitForChild("ServerStateRegistryService"))
local ItemRegistry = require(ReplicatedStorage:WaitForChild("Items"):WaitForChild("Registry"))
local MovementModule = require(ReplicatedStorage.Objects.Game.Character.Client.Movement)
local ClientItemService = require(ReplicatedStorage.Services.Items.ClientItemService)
local EmoteClass = require(ReplicatedStorage.Objects.Items.Emote)
local CameraService = require(ReplicatedStorage.Services.Client.CameraService)
local playerModule = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
local controlModule = require(playerModule:WaitForChild("ControlModule"))
local function GetAutoDuration()
    local dt = RunService.RenderStepped:Wait()
    local fps = 1 / dt
    local duration = 60 / math.clamp(fps, 5, 60)
    return math.clamp(duration, 1, 6)
end
local Duration = GetAutoDuration()
local openshit = Instance.new("ScreenGui")
openshit.Name = "openshit"
openshit.Parent = LocalPlayer.PlayerGui
openshit.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
openshit.ResetOnSpawn = false
local mainopen = Instance.new("TextButton")
mainopen.Name = "mainopen"
mainopen.Parent = openshit
mainopen.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainopen.BackgroundTransparency = 1
mainopen.Position = UDim2.new(0.101969875, 0, 0.110441767, 0)
mainopen.Size = UDim2.new(0, 64, 0, 42)
mainopen.Text = ""
mainopen.Visible = true
local mainopens = Instance.new("UICorner")
mainopens.Parent = mainopen
local SizeBackMulti = 0.1
local AssetsIcon = ""
local AssetsBackground = ""
local backgroundImage = Instance.new("ImageLabel")
backgroundImage.Name = "RotatingBackground"
backgroundImage.Parent = mainopen
backgroundImage.Size = UDim2.new(1.8 + SizeBackMulti, 0, 1.8 + SizeBackMulti, 0)
backgroundImage.Position = UDim2.new(0.5, 0, 0.5, 0)
backgroundImage.AnchorPoint = Vector2.new(0.5, 0.5)
backgroundImage.BackgroundTransparency = 1
backgroundImage.Image = AssetsBackground
backgroundImage.SizeConstraint = Enum.SizeConstraint.RelativeXX
backgroundImage.ZIndex = 0
local WIDTH = 0.85
local HEIGHT = 1
local frontImage = Instance.new("ImageLabel")
frontImage.Name = "StaticIcon"
frontImage.Parent = mainopen
frontImage.Size = UDim2.new(WIDTH, 0, HEIGHT, 0)
frontImage.Position = UDim2.new(0.5, 0, 0.5, 0)
frontImage.AnchorPoint = Vector2.new(0.5, 0.5)
frontImage.BackgroundTransparency = 1
frontImage.Image = AssetsIcon
frontImage.ZIndex = 1
frontImage.ScaleType = Enum.ScaleType.Stretch
local frontCorner = Instance.new("UICorner")
frontCorner.CornerRadius = UDim.new(1, 0)
frontCorner.Parent = frontImage
local rotation = 0
local speed = 90
local lastTime = tick()
task.spawn(function()
    while backgroundImage and backgroundImage.Parent do
        local now = tick()
        local delta = now - lastTime
        lastTime = now
        rotation = (rotation + speed * delta) % 360
        backgroundImage.Rotation = rotation
        task.wait()
    end
end)
local function MakeDraggable(topbarobject, object, locked)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition
    local Holding = false
    local HoldTime = 1.0
    local MoveCancelThreshold = 6
    local HoldToken = 0
    object:SetAttribute("Locked", locked or false)
    local function Update(input)
        if object:GetAttribute("Locked") then return end
        local delta = input.Position - DragStart
        object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + delta.Y
        )
    end
    local function ToggleLock()
        local newState = not object:GetAttribute("Locked")
        object:SetAttribute("Locked", newState)
        BolongCompat:Notify({
            Title = newState and "Button Locked" or "Button Unlocked",
            Content = newState and "This button is now locked in place." or "This button can now be moved.",
            Duration = 2
        })
    end
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        Dragging = not object:GetAttribute("Locked")
        Holding = true
        DragStart = input.Position
        StartPosition = object.Position
        HoldToken += 1
        local token = HoldToken
        task.delay(HoldTime, function()
            if Holding and token == HoldToken then
                ToggleLock()
            end
        end)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
                Holding = false
            end
        end)
    end)
    topbarobject.InputChanged:Connect(function(input)
        if not DragStart then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            if (input.Position - DragStart).Magnitude > MoveCancelThreshold then
                Holding = false
            end
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end
MakeDraggable(mainopen, mainopen, false)
local function playSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end
mainopen.MouseButton1Click:Connect(function()
    local sounds = { "7127123605", "137566474343039", "438666542", "257001341", "257000833", "7127123554", "131607746976396", "97325669841459", "109312518223078" }
    playSound(sounds[math.random(#sounds)])
    pcall(function() if type(Window.Minimize) == "function" then Window:Minimize() end end)
    local function smoothSpeed(target, duration)
        local start = speed
        local steps = 30
        for i = 1, steps do
            speed = start + (target - start) * (i / steps)
            task.wait(duration / steps)
        end
        speed = target
    end
    smoothSpeed(360, 0.4)
    task.wait(0.5)
    smoothSpeed(180, 0.4)
    task.wait(0.3)
    smoothSpeed(90, 0.4)
end)
local Stats = game:GetService("Stats")
local fpsCounter = Instance.new("ScreenGui")
fpsCounter.Name = "FPSCounter"
fpsCounter.Parent = game.CoreGui
fpsCounter.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
fpsCounter.ResetOnSpawn = false
local frame = Instance.new("Frame")
frame.Parent = fpsCounter
frame.Size = UDim2.new(0, 172, 0, 68)
frame.Position = UDim2.new(0, 300, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.7
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
gradient.Parent = frame
task.spawn(function()
    while frame.Parent and task.wait(0.03) do
        gradient.Rotation = (gradient.Rotation + 1) % 360
    end
end)
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(80, 180, 255)
uiStroke.Parent = frame
task.spawn(function()
    local a = Color3.fromRGB(80, 180, 255)
    local b = Color3.fromRGB(255, 255, 255)
    local t, d = 0, 1
    while frame.Parent and task.wait(0.03) do
        t += 0.02 * d
        if t >= 1 then t, d = 1, -1 elseif t <= 0 then t, d = 0, 1 end
        uiStroke.Color = a:Lerp(b, t)
    end
end)
local label = Instance.new("TextLabel")
label.Parent = frame
label.Size = UDim2.new(1, -8, 1, -8)
label.Position = UDim2.new(0, 4, 0, 4)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBlack
label.TextSize = 13
label.TextWrapped = true
label.TextXAlignment = Enum.TextXAlignment.Center
label.TextYAlignment = Enum.TextYAlignment.Center
label.Text = "FPS: 0 | Ping: 0 ms\nClient Timer: 0h 0m 0s"
MakeDraggable(frame, frame, false)
local function GetPing()
    local n = Stats:FindFirstChild("Network")
    if not n then return 0 end
    local s = n:FindFirstChild("ServerStatsItem")
    if not s then return 0 end
    local p = s:FindFirstChild("Data Ping")
    if not p then return 0 end
    return math.floor(p:GetValue())
end
local startTime = tick()
local lastUpdateTime = startTime
local frameCount = 0
local previousText = ""
RunService.RenderStepped:Connect(function()
    frameCount += 1
    local now = tick()
    local dt = now - lastUpdateTime
    if dt >= 1 then
        local fps = math.round(frameCount / dt)
        local elapsed = now - startTime
        local h = math.floor(elapsed / 3600)
        local m = math.floor((elapsed % 3600) / 60)
        local s = math.floor(elapsed % 60)
        local ping = GetPing()
        local text = string.format(
            "FPS: %d | Ping: %d ms\nClient Timer: %dh %dm %ds",
            fps, ping, h, m, s
        )
        if text ~= previousText then
            label.Text = text
            previousText = text
        end
        lastUpdateTime = now
        frameCount = 0
    end
end)
local DFunctions = {}
local DConfiguration = {
    ESP = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
    },
    Tracers = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
    },
    Highlight = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
        OutlineOnly = false,
    },
    Boxes = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
    },
    Removals = {
        CameraShake = false,
        InvisibleWalls = false,
        ReducingRewards = false,
    },
    Main = {
        AntiAFK = true,
        AutoRespawn = false,
        RespawnType = "Spawnpoint",
        AutoWhistle = false,
        ShowTimer = false,
        Fly = false,
        FlySpeed = 1,
        isFlyFloating = false,
        FlyoriginalUpdate = false,
        Noclip = false,
    },
    Battlepass = {
        BypassTimer = false,
    },
    AutoFarm = {
        FarmingStates = {
            IsReviving = false,
            IsCompletingObjective = false,
            IsCollectingTickets = false,
            IsCatchingNPC = false,
        },
        AFKFarm = false,
        FarmTickets = false,
        CompleteObjective = false,
        FarmTokens = false,
        VIPAutomations = {
            AutoVote = false,
            MapSection = 1,
            GamemodeSection = 1,
            AutoMap = false,
            MapInput = "DesertBus",
            AutoSpecialRound = false,
            SpecialRoundInput = "Plushie Hell",
            AutoTimer = false,
            TimerInput = "",
            TimerRoundState = 1,
            AutoProMode = false,
            LastMapSet = 0,
            LastSRSet = 0,
            LastTimerSet = 0,
            LastVotingFire = 0,
        },
        PurchaseAutomations = {
            Enabled = false,
            Selected = "Cola",
            Amount = 1,
            Connection = nil,
            LastBuy = 0,
        },
    },
    Combat = {
        AntiNextbot = false,
        AntiNextbotRange = 15,
        AntiNextbotType = "Spawn",
    },
    Misc = {
        PlayerAdjustment = {
            Default = {
                Friction = 5,
                Speed = 1500,
                JumpHeight = 3,
                JumpCap = 1,
                AirStrafeAcceleration = 182,
                AirAcceleration = 1,
                JumpSpeedMultiplier = 1.45,
                AutoJumpEnabled = false
            },
            Update = {
                Speed = 1500,
                JumpHeight = 3,
                JumpCap = 1,
                JumpAcceleration = 1.5,
                AirStrafe = 182,
                GroundAcceleration = 5,
                AutoJumpEnabled = false,
            },
            Saved = {
                Speed = 1500,
                JumpHeight = 3,
                JumpCap = 1,
                JumpAcceleration = 1.5,
                AirStrafe = 182,
                GroundAcceleration = 5,
            },
            Tick = {
                Speed = 0,
                JumpHeight = 0,
                JumpCap = 0,
                JumpAcceleration = 0,
                AirStrafe = 0,
                GroundAcceleration = 0,
                AutoJumpEnabled = 0,
            },
            Debounce = {
                Speed = false,
                JumpHeight = false,
                JumpCap = false,
                JumpAcceleration = false,
                AirStrafe = false,
                GroundAcceleration = false,
                AutoJumpEnabled = false,
            },
        },
        Humanoids = {
            WalkspeedCF = false,
            OriginalJumpHeight = false,
            CF = 5,
            JP = 20,
        },
        Utilities = {
            GetCurrentSpeed = 0,
            BounceModification = {
                Enabled = false,
                DefaultBounce = 80,
                EmoteBounce = 120,
                SuperBounce = false,
                SuperBounceStrength = -50,
            },
            EdgeTrimpModification = {
                Enabled = false,
                HeightMultiplier = 1.5,
                DownThreshold = 4.5
            },
            LagSwitch = {
                MSDelay = 200,
                Mode = "Normal",
            },
        },
        CameraAdjustment = {
            StretchX = 1,
            StretchY = 1,
        },
        GunAdjustment = {
            v = nil,
        },
        GameAutomation = {
            Revive = {
                Enabled = false,
                FloatingButton = false,
                Keybind = false,
                WhileEmote = false,
                Delay = 0.1,
            },
            Carry = {
                Enabled = false,
                FloatingButton = false,
                Keybind = false,
                WhileEmote = false,
                lastAttempt = 0,
                Cooldown = 0.5,
                Connection = nil,
            },
            Macro = {
                SelectedEmote = "BoldMarch",
                FloatingButton = false,
                Keybind = false,
            },
        },
        MovementModification = {
            AggressiveEmoteDash = {
                Enabled = false,
                Type = "Blatant",
                Speed = 3000,
                Acceleration = -2,
            },
            SlideModification = {
                FloatingButton = false,
                Enabled = false,
                Acceleration = -3,
            },
            Gravity = {
                FloatingButton = false,
                Keybind = false,
                Value = 10,
            },
            AutoJump = {
                Enabled = false,
                Keybind = false,
                HoldKeybind = false,
                FloatingButton = false,
                JumpButton = false,
                HipHeight1 = 0,
                HipHeight2 = 0,
                lastTick = 0.01,
                lastFriction = nil,
                Settings = {
                    AutoAcceleration = {
                        Enabled = false,
                        MaxAccelerate = 3,
                        MinAccelerate = -1,
                        MinSpeed = 70
                    },
                    SpiderHop = false,
                    Backwards = false,
                    Type = "Acceleration",
                    JumpType = "Simulation",
                    Acceleration = -0.1,
                },
            },
            Crouch = {
                FloatingButton = false,
                Keybind = false,
                Type = "Rapid",
                isHolding = false,
                debounce = 0.1,
                lastTick = 0.1,
                lastReleaseTick = 0.1,
            },
        },
    },
    Settings = {
        GuiScale = {
            Respawn = 0,
            SuperBounce = 0,
            AutoCarry = 0,
            AutoEmoteDash = 0,
            Gravity = 0,
            InfiniteSlide = 0,
            AutoJump = 0,
            AutoCrouch = 0,
            LagSwitch = 0,
        },
    },
    SelfRevive = {
        Method = "Spawnpoint",
        Enabled = false,
        HasRevived = false,
        LastSavedPosition = nil,
        IsProcessing = false,
        LastRespawnTime = 0,
        Connections = {
            Heartbeat = nil,
            Character = nil,
        }
    },
    TokenFarm = {
        Enabled = false,
        ReviveTarget = nil,
        FireCount = 0,
        LastReviveFire = 0,
        TokenDelay = 2,
        TokenOffset = Vector3.new(0, -8, 0),
        Connection = nil,
    },
    TimerDisplay = {
        Enabled = false,
        SpecialRoundEnabled = false,
        TimerGui = nil,
        SpecialGui = nil,
        TimerConn = nil,
        SpecialConn = nil,
    },
}
function CreateBillboardESP(Name, Part, Color, TextSize)
    if not Part or Part:FindFirstChild(Name) then return nil end
    local BillboardGui = Instance.new("BillboardGui")
    local TextLabel = Instance.new("TextLabel")
    local TextStroke = Instance.new("UIStroke")
    BillboardGui.Parent = Part
    BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BillboardGui.Name = Name
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.new(0, 200, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
    BillboardGui.MaxDistance = 1000
    TextLabel.Parent = BillboardGui
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.TextSize = TextSize or 14
    TextLabel.TextColor3 = Color or Color3.fromRGB(255, 255, 255)
    TextStroke.Parent = TextLabel
    TextStroke.Thickness = 1
    TextStroke.Color = Color3.new(0, 0, 0)
    return BillboardGui
end
function UpdateBillboardESP(Name, Part, NameText, Color, TextSize, CamPos)
    if not Part then return false end
    local esp = Part:FindFirstChild(Name)
    if esp and esp:FindFirstChildOfClass("TextLabel") then
        local label = esp:FindFirstChildOfClass("TextLabel")
        if Color then label.TextColor3 = Color end
        if TextSize then label.TextSize = TextSize end
        if CamPos then
            local distance = math.floor((CamPos - Part.Position).Magnitude)
            label.Text = string.format("%s - [ %d M ]", NameText or Part.Name, distance)
        else
            label.Text = NameText or Part.Name
        end
        return true
    end
    return false
end
function DestroyBillboardESP(Name, Part)
    if not Part then return false end
    local esp = Part:FindFirstChild(Name)
    if esp then esp:Destroy() return true end
    return false
end
function CreateTracerESP(tracerTable, part, thickness, color)
    local tracer = Drawing.new("Line")
    tracer.Thickness = thickness or 2
    tracer.Color = color or Color3.fromRGB(255, 255, 255)
    tracer.Transparency = 1
    tracer.Visible = false
    tracerTable[part] = tracer
    return tracer
end
function UpdateTracerESP(tracerTable, part, color)
    local tracer = tracerTable[part]
    if not tracer then return end
    if typeof(part) ~= "Instance" or not part.Parent or not part:IsDescendantOf(workspace) then
        tracer.Visible = false
        pcall(function()
            if tracer.Remove then tracer:Remove()
            elseif tracer.Destroy then tracer:Destroy() end
        end)
        tracerTable[part] = nil
        return
    end
    local ok, screenPos, onScreen = pcall(function()
        return workspace.CurrentCamera:WorldToViewportPoint(part.Position)
    end)
    if not ok or not onScreen then
        tracer.Visible = false
        return
    end
    if color then tracer.Color = color end
    tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
    tracer.To = Vector2.new(screenPos.X, screenPos.Y)
    tracer.Visible = true
end
function DestroyTracerESP(tracerTable, part)
    local tracer = tracerTable[part]
    if tracer then
        pcall(function()
            if tracer.Remove then tracer:Remove()
            elseif tracer.Destroy then tracer:Destroy() end
        end)
        tracerTable[part] = nil
    end
end
function CleanupTracers(tracerTable)
    for part, tracer in pairs(tracerTable) do
        if typeof(part) ~= "Instance" or not part.Parent or not part:IsDescendantOf(workspace) then
            pcall(function()
                if tracer.Remove then tracer:Remove()
                elseif tracer.Destroy then tracer:Destroy() end
            end)
            tracerTable[part] = nil
        end
    end
end
function CreateHighlightESP(Name, Part, HighlightColor, OutlineColor, OutlineOnly)
    if not Part or Part:FindFirstChild(Name) then return false end
    local Highlight = Instance.new("Highlight")
    Highlight.Name = Name
    Highlight.FillColor = HighlightColor or Color3.fromRGB(255, 255, 255)
    Highlight.OutlineColor = OutlineColor or Color3.fromRGB(0, 0, 0)
    Highlight.FillTransparency = OutlineOnly and 1 or 0.5
    Highlight.OutlineTransparency = 0
    Highlight.Parent = Part
    return true
end
function UpdateHighlightESP(Name, Part, HighlightColor, OutlineColor, OutlineOnly)
    local Highlight = Part and Part:FindFirstChild(Name)
    if not Highlight or not Highlight:IsA("Highlight") then return false end
    if HighlightColor then Highlight.FillColor = HighlightColor end
    if OutlineColor then Highlight.OutlineColor = OutlineColor end
    if OutlineOnly ~= nil then Highlight.FillTransparency = OutlineOnly and 1 or 0.5 end
    return true
end
function DestroyHighlightESP(Name, Part)
    local Highlight = Part and Part:FindFirstChild(Name)
    if Highlight and Highlight:IsA("Highlight") then
        Highlight:Destroy()
        return true
    end
    return false
end
function DFunctions.CreateButton(ButtonName, Name, Size1, Size2, ScriptLogic, CircleMode)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = ButtonName
    screenGui.Parent = LocalPlayer.PlayerGui
    screenGui.ResetOnSpawn = false
    local frame = Instance.new("Frame")
    frame.Name = ButtonName
    frame.Size = UDim2.new(Size1, 0, Size2, 0)
    frame.Position = UDim2.new(0.5 - Size1 / 2, 0, 0.5 - Size2 / 2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = 0.7
    frame.Parent = screenGui
    local gradient = Instance.new("UIGradient")
    gradient.Color = getgenv().ButtonGradients.Background
    gradient.Parent = frame
    task.spawn(function()
        while frame.Parent and task.wait(0.03) do
            gradient.Rotation = (gradient.Rotation + 1) % 360
            gradient.Color = getgenv().ButtonGradients.Background
        end
    end)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Parent = frame
    local gradientstroke = Instance.new("UIGradient")
    gradientstroke.Color = getgenv().ButtonGradients.Stroke
    gradientstroke.Rotation = 0
    gradientstroke.Parent = stroke
    task.spawn(function()
        while frame.Parent do
            gradientstroke.Rotation = (gradientstroke.Rotation + 0.5) % 360
            gradientstroke.Color = getgenv().ButtonGradients.Stroke
            task.wait()
        end
    end)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = Name
    button.Font = Enum.Font.SourceSansBold
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 24
    button.TextScaled = false
    button.Parent = frame
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 28, 0, 28)
    toggle.Position = UDim2.new(1, 6, 0.5, -14)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggle.Text = "○"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Visible = false
    toggle.Parent = frame
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = toggle
    local originalSize = UDim2.new(Size1, 0, Size2, 0)
    local holding = false
    local holdStart = 0
    local hideAt = 0
    frame:SetAttribute("IsCircle", false)
    local isCircle = CircleMode ~= nil and CircleMode or frame:GetAttribute("IsCircle")
    local function applyShape(circle)
        frame:SetAttribute("IsCircle", circle)
        local s = math.min(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
        if circle then
            frame.Size = UDim2.new(0, s, 0, s)
            button.TextWrapped = true
            button.TextScaled = true
            button.TextSize = math.floor(s * 0.45)
            corner.CornerRadius = UDim.new(1, 0)
            toggle.Text = "▢"
        else
            frame.Size = originalSize
            button.TextWrapped = false
            button.TextScaled = false
            button.TextSize = 24
            corner.CornerRadius = UDim.new(0, 15)
            toggle.Text = "○"
        end
    end
    applyShape(isCircle)
    task.spawn(function()
        while frame.Parent and task.wait(0.25) do
            if toggle.Visible and tick() - hideAt >= 10 then
                toggle.Visible = false
            end
        end
    end)
    button.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            holding = true
            holdStart = tick()
        end
    end)
    button.InputEnded:Connect(function(i)
        if holding and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
            holding = false
            if tick() - holdStart >= 0.6 then
                toggle.Visible = true
                hideAt = tick()
            end
        end
    end)
    toggle.MouseButton1Click:Connect(function()
        hideAt = tick()
        local current = frame:GetAttribute("IsCircle")
        applyShape(not current)
    end)
    button.Activated:Connect(function()
        if ScriptLogic then
            ScriptLogic(button)
        end
    end)
    FBM:AddButton(ButtonName, frame, false)
    MakeDraggable(button, frame, false)
    return button
end
function DFunctions.UpdateButton(Name, Size1, Size2)
    local gui = LocalPlayer.PlayerGui:FindFirstChild(Name)
    if gui then
        local frame = gui:FindFirstChild(Name)
        if frame then
            frame.Size = UDim2.new(Size1, 0, Size2, 0)
            local isCircle = frame:GetAttribute("IsCircle")
            if isCircle then
                local s = math.min(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
                frame.Size = UDim2.new(0, s, 0, s)
            end
        end
    end
end
function DFunctions.DestroyButton(Name)
    local gui = LocalPlayer.PlayerGui:FindFirstChild(Name)
    if gui then
        gui:Destroy()
    end
end
local changePlayerMode = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("SetPlayerMode")
function DFunctions.SelfReviveRespawn()
    local SelfRevive = DConfiguration.SelfRevive
    local now = tick()
    if now - SelfRevive.LastRespawnTime < 0.5 then return end
    SelfRevive.LastRespawnTime = now
    if SelfRevive.IsProcessing then return end
    local char = LocalPlayer.Character
    if not char then return end
    local isDowned = false
    if CharacterService then
        local ok, charData = pcall(function() return CharacterService:GetCharacterFromPlayer(LocalPlayer) end)
        if ok and charData and charData.DataRegistry and charData.DataRegistry:Get("Downed") then
            isDowned = true
        end
    end
    if not isDowned then return end
    SelfRevive.IsProcessing = true
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if SelfRevive.Method == "Spawnpoint" then
        if not SelfRevive.HasRevived then
            SelfRevive.HasRevived = true
            pcall(function()
                if changePlayerMode then changePlayerMode:FireServer(true) end
            end)
            SelfRevive.IsProcessing = false
            task.delay(10, function()
                SelfRevive.HasRevived = false
            end)
        else
            SelfRevive.IsProcessing = false
        end
    elseif SelfRevive.Method == "Fake Revive" then
        local savedPos = nil
        if hrp then savedPos = hrp.CFrame.Position end
        task.spawn(function()
            pcall(function()
                if changePlayerMode then changePlayerMode:FireServer(true) end
            end)
            local newCharacter
            repeat
                newCharacter = LocalPlayer.Character
                task.wait()
            until newCharacter and newCharacter:FindFirstChild("HumanoidRootPart") and newCharacter ~= char
            if newCharacter then
                local newHRP = newCharacter:FindFirstChild("HumanoidRootPart")
                if savedPos and newHRP then
                    task.wait(0.1)
                    newHRP.CFrame = CFrame.new(savedPos)
                end
            end
            SelfRevive.IsProcessing = false
        end)
    else
        SelfRevive.IsProcessing = false
    end
end
function DFunctions.StartSelfRevive()
    local SelfRevive = DConfiguration.SelfRevive
    if SelfRevive.Connections.Heartbeat then return end
    SelfRevive.Enabled = true
    SelfRevive.Connections.Heartbeat = RunService.Heartbeat:Connect(function()
        if not SelfRevive.Enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        if not CharacterService then return end
        local ok, charData = pcall(function() return CharacterService:GetCharacterFromPlayer(LocalPlayer) end)
        if ok and charData and charData.DataRegistry and charData.DataRegistry:Get("Downed") then
            DFunctions.SelfReviveRespawn()
        end
    end)
    SelfRevive.Connections.Character = LocalPlayer.CharacterAdded:Connect(function()
        SelfRevive.HasRevived = false
        SelfRevive.IsProcessing = false
        SelfRevive.LastSavedPosition = nil
    end)
end
function DFunctions.StopSelfRevive()
    local SelfRevive = DConfiguration.SelfRevive
    SelfRevive.Enabled = false
    SelfRevive.HasRevived = false
    SelfRevive.IsProcessing = false
    SelfRevive.LastSavedPosition = nil
    for name, conn in pairs(SelfRevive.Connections) do
        if conn then
            conn:Disconnect()
            SelfRevive.Connections[name] = nil
        end
    end
end
function DFunctions.AutoRespawn()
    DFunctions.SelfReviveRespawn()
end
function DFunctions.IsTokenFarmLocalPlayerModel(model)
    if not model then return true end
    if model == LocalPlayer.Character then return true end
    if model.Name == LocalPlayer.Name then return true end
    if model.Name == tostring(LocalPlayer.UserId) then return true end
    local attrName = model:GetAttribute("Name")
    if attrName == LocalPlayer.Name or attrName == LocalPlayer.DisplayName then return true end
    local attrTag = model:GetAttribute("Tag")
    if attrTag == LocalPlayer.Name or attrTag == LocalPlayer.DisplayName then return true end
    local userId = model:GetAttribute("UserId") or model:GetAttribute("PlayerUserId")
    if typeof(userId) == "number" and userId == LocalPlayer.UserId then return true end
    return false
end
function DFunctions.IsValidTokenFarmTarget(model)
    if not model or not model.Parent or not model:IsA("Model") then return false end
    if model.Parent.Name ~= "Players" then return false end
    if DFunctions.IsTokenFarmLocalPlayerModel(model) then return false end
    if not model:FindFirstChild("HumanoidRootPart") then return false end
    if model:GetAttribute("Tag") == nil then return false end
    return true
end
function DFunctions.PickRandomTokenFarmTarget()
    local playersFolder = workspace:FindFirstChild("Players")
    if not playersFolder then return nil end
    local valid = {}
    for _, model in ipairs(playersFolder:GetChildren()) do
        if DFunctions.IsValidTokenFarmTarget(model) then
            table.insert(valid, model)
        end
    end
    if #valid == 0 then return nil end
    return valid[math.random(1, #valid)]
end
function DFunctions.StartGodMode()
    local TF = DConfiguration.TokenFarm
    if TF.Connection then return end
    TF.Enabled = true
    TF.Connection = RunService.Heartbeat:Connect(function()
        if not TF.Enabled then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if not DFunctions.IsValidTokenFarmTarget(TF.ReviveTarget) then
            TF.ReviveTarget = DFunctions.PickRandomTokenFarmTarget()
        end
        local target = TF.ReviveTarget
        if not target then return end
        local targetHrp = target:FindFirstChild("HumanoidRootPart")
        if not targetHrp then return end
        hrp.CFrame = targetHrp.CFrame + TF.TokenOffset
        local tag = target:GetAttribute("Tag")
        if not tag then return end
        local now = tick()
        if now - TF.LastReviveFire >= (TF.TokenDelay or 2) then
            TF.LastReviveFire = now
            pcall(function()
                ReplicatedStorage.Events.Interact:FireServer("Revive", tag)
                ReplicatedStorage.Events.Interact:FireServer("Revive", tag, true)
            end)
        end
    end)
end
function DFunctions.StopGodMode()
    local TF = DConfiguration.TokenFarm
    TF.Enabled = false
    if TF.Connection then
        TF.Connection:Disconnect()
        TF.Connection = nil
    end
    TF.ReviveTarget = nil
    TF.FireCount = 0
    TF.LastReviveFire = 0
end
function DFunctions.DisableTouch() end
function DFunctions.CreateTimer()
    local TD = DConfiguration.TimerDisplay
    if LocalPlayer.PlayerGui:FindFirstChild("TimerGui") then return end
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = LocalPlayer.PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.Name = "TimerGui"
    local timerLabel = Instance.new("TextLabel")
    timerLabel.Parent = screenGui
    timerLabel.Size = UDim2.new(0, 200, 0, 50)
    timerLabel.Position = UDim2.new(0.5, -100, 0.1, 0)
    timerLabel.BackgroundTransparency = 1
    timerLabel.TextScaled = true
    timerLabel.Font = Enum.Font.SourceSans
    timerLabel.TextColor3 = Color3.new(1, 1, 1)
    timerLabel.Text = "0:00"
    timerLabel.Name = "TimerLabel"
    TD.TimerGui = screenGui
    TD.Enabled = true
    if TD.TimerConn then TD.TimerConn:Disconnect() end
    TD.TimerConn = RunService.Heartbeat:Connect(function()
        if not TD.Enabled then return end
        local seconds = nil
        if ServerStateRegistryService and ServerStateRegistryService.Registry then
            seconds = ServerStateRegistryService.Registry.Time
        end
        if type(seconds) == "number" and seconds >= 0 and seconds ~= -1 then
            local m = math.floor(seconds / 60)
            local s = math.floor(seconds % 60)
            timerLabel.Text = string.format("%d:%02d", m, s)
        else
            timerLabel.Text = "--:--"
        end
    end)
end
function DFunctions.RemoveTimer()
    local TD = DConfiguration.TimerDisplay
    TD.Enabled = false
    if TD.TimerConn then
        TD.TimerConn:Disconnect()
        TD.TimerConn = nil
    end
    if LocalPlayer.PlayerGui:FindFirstChild("TimerGui") then
        LocalPlayer.PlayerGui.TimerGui:Destroy()
    end
    TD.TimerGui = nil
end
function DFunctions.CreateSpecialRoundDisplay()
    local TD = DConfiguration.TimerDisplay
    if LocalPlayer.PlayerGui:FindFirstChild("SpecialRoundGui") then return end
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = LocalPlayer.PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.Name = "SpecialRoundGui"
    local specialLabel = Instance.new("TextLabel")
    specialLabel.Parent = screenGui
    specialLabel.Size = UDim2.new(0, 300, 0, 40)
    specialLabel.Position = UDim2.new(0.5, -150, 0.16, 0)
    specialLabel.BackgroundTransparency = 1
    specialLabel.TextScaled = true
    specialLabel.Font = Enum.Font.SourceSans
    specialLabel.TextColor3 = Color3.new(1, 1, 1)
    specialLabel.Text = ""
    specialLabel.Name = "SpecialRoundLabel"
    TD.SpecialGui = screenGui
    TD.SpecialRoundEnabled = true
    if TD.SpecialConn then TD.SpecialConn:Disconnect() end
    TD.SpecialConn = RunService.Heartbeat:Connect(function()
        if not TD.SpecialRoundEnabled then return end
        local special = nil
        if ServerStateRegistryService and ServerStateRegistryService.Registry then
            special = ServerStateRegistryService.Registry.SpecialRound
        end
        if special and special ~= false and special ~= "" then
            local title = tostring(special)
            pcall(function()
                local folder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("SpecialRounds")
                if folder then
                    local mod = folder:FindFirstChild(tostring(special))
                    if mod then
                        local ok, data = pcall(require, mod)
                        if ok and data and data.Title then title = data.Title end
                    end
                end
            end)
            specialLabel.Text = title
        else
            specialLabel.Text = ""
        end
    end)
end
function DFunctions.RemoveSpecialRoundDisplay()
    local TD = DConfiguration.TimerDisplay
    TD.SpecialRoundEnabled = false
    if TD.SpecialConn then
        TD.SpecialConn:Disconnect()
        TD.SpecialConn = nil
    end
    if LocalPlayer.PlayerGui:FindFirstChild("SpecialRoundGui") then
        LocalPlayer.PlayerGui.SpecialRoundGui:Destroy()
    end
    TD.SpecialGui = nil
end
function DFunctions.RemoveReduceRewards() end
function DFunctions.DisableInvisParts(state)
    local map = workspace:FindFirstChild("Map")
    if not map then return end
    local invis = map:FindFirstChild("InvisParts") or map:FindFirstChild("MapLogic")
    if not invis then return end
    for _, v in pairs(invis:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = state
        end
    end
end
function DFunctions.DisableCameraShake() end
function DFunctions.GetDownedPlayer()
    local folder = workspace:FindFirstChild("Players")
    if not folder then return nil end
    for _, v in pairs(folder:GetChildren()) do
        if v:GetAttribute("Downed") and v:FindFirstChild("HumanoidRootPart") then
            return v
        end
    end
    return nil
end
function DFunctions.GetEventNPC() return nil end
function DFunctions.TPEventNPC() end
function DFunctions.GetObjective()
    local objectives = {}
    local map = workspace:FindFirstChild("Map")
    if not map then
        local gameFolder = workspace:FindFirstChild("Game")
        map = gameFolder and gameFolder:FindFirstChild("Map")
    end
    if not map then return objectives end
    local parts = map:FindFirstChild("Parts") or map:FindFirstChild("MapLogic")
    if not parts then return objectives end
    local objectivesFolder = parts:FindFirstChild("Objectives")
    if not objectivesFolder then return objectives end
    for _, obj in pairs(objectivesFolder:GetChildren()) do
        if obj:GetAttribute("Completed") == true then continue end
        local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        if primaryPart or obj:IsA("BasePart") then
            table.insert(objectives, {
                Name = obj.Name,
                Part = primaryPart or obj,
                Position = (primaryPart or obj).Position,
                Tag = obj:GetAttribute("Tag"),
                Instance = obj
            })
        end
    end
    return objectives
end
local FarmPart
function DFunctions.AFKFarming()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not FarmPart then
        FarmPart = Instance.new("Part")
        FarmPart.Size = Vector3.new(10, 1, 10)
        FarmPart.Anchored = true
        FarmPart.CanCollide = true
        FarmPart.Name = "AFKFarmPad"
        FarmPart.CFrame = CFrame.new(1131, 1015, 2222)
        FarmPart.Parent = workspace
    end
    hrp.CFrame = FarmPart.CFrame + Vector3.new(0, 3, 0)
end
function DFunctions.RevivePlayer()
    local downed = DFunctions.GetDownedPlayer()
    if downed and downed:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(downed.HumanoidRootPart.Position + Vector3.new(0, 2, 0))
        end
    else
        DFunctions.AFKFarming()
    end
end
function DFunctions.TokenFarming()
    DFunctions.StartGodMode()
end
function DFunctions.PointFarming()
    local objectives = DFunctions.GetObjective()
    if type(objectives) ~= "table" or #objectives == 0 then return end
    for _, objective in ipairs(objectives) do
        local inst = objective.Instance
        if inst and inst:FindFirstChild("WhenActivated") then
            local tagValue = objective.Tag or inst:GetAttribute("Tag")
            if tagValue then
                pcall(function()
                    ReplicatedStorage.Events.Interact:FireServer("Dynamic", tagValue)
                end)
                task.wait(0.2)
            end
        end
    end
end
function DFunctions.TicketsFarming()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local ticketsFolder = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
    if not ticketsFolder then
        DFunctions.AFKFarming()
        return
    end
    for _, v in ipairs(ticketsFolder:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "HumanoidRootPart" then
            hrp.CFrame = CFrame.new(v.Position)
            return
        end
    end
    DFunctions.AFKFarming()
end
function DFunctions.AutoVote() end
function DFunctions.NormalizeVIPString(str)
    return tostring(str or ""):gsub("%s+", ""):lower()
end
function DFunctions.AdminCommand(commandString)
    local cmd = ReplicatedStorage:FindFirstChild("Events")
        and ReplicatedStorage.Events:FindFirstChild("Admin")
        and ReplicatedStorage.Events.Admin:FindFirstChild("Command")
    if not cmd then return end
    pcall(function()
        cmd:FireServer(commandString)
    end)
end
function DFunctions.SetVIPCommands()
    local VIP = DConfiguration.AutoFarm.VIPAutomations
    local svc = ServerStateRegistryService
    if not svc then return end
    local function getState(key)
        if svc.Registry then
            return svc.Registry[key]
        end
        return nil
    end
    local function normalize(str)
        return tostring(str or ""):gsub("%s+", ""):lower()
    end
    local function getMapDisplayName(moduleName)
        local mapsFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("Maps")
        if not mapsFolder then return nil end
        local mod = mapsFolder:FindFirstChild(moduleName)
        if mod and mod:IsA("ModuleScript") then
            local ok, data = pcall(require, mod)
            if ok and data and data.Name then
                return data.Name
            end
        end
        return nil
    end
    local function getMapModuleName(displayName)
        local mapsFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("Maps")
        if not mapsFolder then return nil end
        for _, mod in ipairs(mapsFolder:GetChildren()) do
            if mod:IsA("ModuleScript") then
                local ok, data = pcall(require, mod)
                if ok and data and data.Name then
                    if normalize(data.Name) == normalize(displayName) then
                        return mod.Name
                    end
                end
            end
        end
        return nil
    end
    local function getSpecialRoundDisplayName(moduleName)
        local srFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("SpecialRounds")
        if not srFolder then return nil end
        local mod = srFolder:FindFirstChild(moduleName)
        if mod and mod:IsA("ModuleScript") then
            local ok, data = pcall(require, mod)
            if ok and data and data.Name then
                return data.Name
            end
        end
        return nil
    end
    local function getSpecialRoundModuleName(displayName)
        local srFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("SpecialRounds")
        if not srFolder then return nil end
        for _, mod in ipairs(srFolder:GetChildren()) do
            if mod:IsA("ModuleScript") then
                local ok, data = pcall(require, mod)
                if ok and data and data.Name then
                    if normalize(data.Name) == normalize(displayName) then
                        return mod.Name
                    end
                end
            end
        end
        return nil
    end
    if VIP.AutoMap and VIP.MapInput and VIP.MapInput ~= "" then
        if tick() - (VIP.LastMapSet or 0) >= 1 then
            local current = getState("Map")
            local desired = VIP.MapInput
            local match = false
            local nc = normalize(current)
            local nd = normalize(desired)
            if nc == nd then
                match = true
            else
                local display = getMapDisplayName(desired)
                if display and normalize(display) == nc then
                    match = true
                end
                local moduleName = getMapModuleName(desired)
                if moduleName and normalize(moduleName) == nc then
                    match = true
                end
            end
            if not match then
                local isLoading = getState("MapLoading")
                if type(isLoading) == "string" then
                    else
                    DFunctions.AdminCommand("!Map " .. desired)
                    VIP.LastMapSet = tick()
                end
            end
        end
    end
    if VIP.AutoSpecialRound and VIP.SpecialRoundInput and VIP.SpecialRoundInput ~= "" then
        if tick() - (VIP.LastSRSet or 0) >= 1 then
            local current = getState("SpecialRound")
            local desired = VIP.SpecialRoundInput
            local match = false
            local nc = normalize(current)
            local nd = normalize(desired)
            if nc == nd then
                match = true
            else
                local display = getSpecialRoundDisplayName(desired)
                if display and normalize(display) == nc then
                    match = true
                end
                local moduleName = getSpecialRoundModuleName(desired)
                if moduleName and normalize(moduleName) == nc then
                    match = true
                end
            end
            if not match then
                DFunctions.AdminCommand("!SpecialRound " .. desired)
                VIP.LastSRSet = tick()
                end
        end
    end
    if VIP.AutoTimer and VIP.TimerInput and VIP.TimerInput ~= "" then
        if tick() - (VIP.LastTimerSet or 0) >= 3 then
            local roundStatus = getState("RoundStatus")
            local roundState = VIP.TimerRoundState or 1
            local shouldFire = false
            if roundState == 1 and roundStatus == 2 then
                shouldFire = true
            elseif roundState == 2 and roundStatus ~= 2 then
                shouldFire = true
            elseif roundState == 3 then
                shouldFire = true
            end
            if shouldFire then
                local currentTime = getState("Time")
                local desiredNum = tonumber(VIP.TimerInput)
                if desiredNum and (currentTime == nil or currentTime ~= desiredNum) then
                    DFunctions.AdminCommand("!Time " .. tostring(desiredNum))
                    VIP.LastTimerSet = tick()
                end
            end
        end
    end
end
function DFunctions.GetItemRegistry()
    if ItemRegistry then return ItemRegistry end
    return ItemRegistry
end
function DFunctions.GetEmotesName()
    local names = {}
    local reg = DFunctions.GetItemRegistry()
    if not reg then return names end
    local byCat = reg.GetByCategory and reg.GetByCategory("Emotes")
    if byCat then
        for id, entry in pairs(byCat) do
            if entry and entry.Module then
                table.insert(names, entry.Module.Name)
            end
        end
    end
    if #names == 0 then
        local all = reg.GetAll and reg.GetAll()
        if all then
            for id, entry in pairs(all) do
                if entry and entry.Categories then
                    for _, cat in ipairs(entry.Categories) do
                        if tostring(cat):lower():find("emote") then
                            table.insert(names, entry.Module.Name)
                            break
                        end
                    end
                end
            end
        end
    end
    table.sort(names)
    return names
end
function DFunctions.GetMultipleShopItems()
    local names = {}
    local reg = DFunctions.GetItemRegistry()
    if not reg or not reg.GetAll then return names end
    local allIds = reg.GetAll()
    for id, _ in pairs(allIds) do
        local config = reg.GetConfig(id)
        if config and config.PurchaseInfo then
            local purchase = config.PurchaseInfo
            if purchase.AppearsIn == "Shop" and purchase.OwnershipType == "Multiple" then
                local name = config.AppearanceInfo and config.AppearanceInfo.Name or config.Name or "Unknown"
                table.insert(names, name)
            end
        end
    end
    table.sort(names)
    return names
end
function DFunctions.BuyItem()
    local selected = DConfiguration.AutoFarm.PurchaseAutomations.Selected
    if not selected or selected == "" then return end
    local reg = DFunctions.GetItemRegistry()
    if not reg or not reg.GetAll then return end
    local allIds = reg.GetAll()
    local itemId = nil
    for id, _ in pairs(allIds) do
        local config = reg.GetConfig(id)
        if config and config.PurchaseInfo then
            local purchase = config.PurchaseInfo
            if purchase.AppearsIn == "Shop" and purchase.OwnershipType == "Multiple" then
                local name = config.AppearanceInfo and config.AppearanceInfo.Name or config.Name or "Unknown"
                if name == selected then
                    itemId = id
                    break
                end
            end
        end
    end
    if not itemId then return end
    local amount = DConfiguration.AutoFarm.PurchaseAutomations.Amount or 1
    local purchaseEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
        and ReplicatedStorage.Shared:FindFirstChild("UserData")
        and ReplicatedStorage.Shared.UserData:FindFirstChild("Events")
        and ReplicatedStorage.Shared.UserData.Events:FindFirstChild("Requests")
        and ReplicatedStorage.Shared.UserData.Events.Requests:FindFirstChild("Purchase")
    if not purchaseEvent then return end
    pcall(function()
        purchaseEvent:FireServer(itemId, amount)
    end)
end
function DFunctions.GetMultipleShopItems()
    local names = {}
    local reg = DFunctions.GetItemRegistry()
    if not reg or not reg.GetAll then return names end
    local allIds = reg.GetAll()
    for id, _ in pairs(allIds) do
        local config = reg.GetConfig(id)
        if config and config.PurchaseInfo then
            local purchase = config.PurchaseInfo
            if purchase.AppearsIn == "Shop" and purchase.OwnershipType == "Multiple" then
                local name = config.AppearanceInfo and config.AppearanceInfo.Name or config.Name or "Unknown"
                table.insert(names, name)
            end
        end
    end
    table.sort(names)
    return names
end
function DFunctions.BuyItem()
    local selected = DConfiguration.AutoFarm.PurchaseAutomations.Selected
    if not selected or selected == "" then return end
    local reg = DFunctions.GetItemRegistry()
    if not reg or not reg.GetAll then return end
    local allIds = reg.GetAll()
    local itemId = nil
    for id, _ in pairs(allIds) do
        local config = reg.GetConfig(id)
        if config and config.PurchaseInfo then
            local purchase = config.PurchaseInfo
            if purchase.AppearsIn == "Shop" and purchase.OwnershipType == "Multiple" then
                local name = config.AppearanceInfo and config.AppearanceInfo.Name or config.Name or "Unknown"
                if name == selected then
                    itemId = id
                    break
                end
            end
        end
    end
    if not itemId then return end
    local amount = DConfiguration.AutoFarm.PurchaseAutomations.Amount or 1
    local purchaseEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
        and ReplicatedStorage.Shared:FindFirstChild("UserData")
        and ReplicatedStorage.Shared.UserData:FindFirstChild("Events")
        and ReplicatedStorage.Shared.UserData.Events:FindFirstChild("Requests")
        and ReplicatedStorage.Shared.UserData.Events.Requests:FindFirstChild("Purchase")
    if not purchaseEvent then return end
    pcall(function()
        purchaseEvent:FireServer(itemId, amount)
    end)
end
function DFunctions.GetItemByName(name)
    local reg = DFunctions.GetItemRegistry()
    if not reg or not name or name == "" then return nil end
    if reg.TryGetByName then
        return reg.TryGetByName(name)
    end
    return nil
end
function DFunctions.GetItemConfig(nameOrId)
    local reg = DFunctions.GetItemRegistry()
    if not reg then return nil end
    local id = tonumber(nameOrId)
    if not id and reg.TryGetByName then
        local entry = reg.TryGetByName(tostring(nameOrId))
        if entry then id = entry.Id end
    end
    if id and reg.GetConfig then
        return reg.GetConfig(id)
    end
    return nil
end
function DFunctions.GetSafeCFrame(typ, root, tdist, nextbotPos)
    if typ == "Spawn" then
        local map = workspace:FindFirstChild("Map")
        local spawns = map and (map:FindFirstChild("ItemSpawns") or map:FindFirstChild("Spawns") or map:FindFirstChild("MapLogic"))
        if spawns then
            local parts = {}
            for _, p in pairs(spawns:GetDescendants()) do
                if p:IsA("BasePart") then table.insert(parts, p) end
            end
            if #parts > 0 then
                local r = parts[math.random(1, #parts)]
                return CFrame.new(r.Position + Vector3.new(0, 3, 0))
            end
        end
    elseif typ == "Players" then
        local players = Players:GetPlayers()
        local candidates = {}
        for _, plr in pairs(players) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(candidates, plr)
            end
        end
        if #candidates > 0 then
            local r = candidates[math.random(1, #candidates)]
            return r.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    elseif typ == "Distance" and root and nextbotPos then
        local dir = (root.Position - nextbotPos)
        if dir.Magnitude > 0.1 then
            return CFrame.new(root.Position + dir.Unit * (tdist or 100))
        end
    end
    return root and (root.CFrame + Vector3.new(0, 50, 0)) or CFrame.new(0, 100, 0)
end
function DFunctions.AntiNextbot()
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local range = DConfiguration.Combat.AntiNextbotRange or 50
    local tpType = DConfiguration.Combat.AntiNextbotType or "Spawn"
    local function checkFolder(folder)
        if not folder then return false end
        for _, v in pairs(folder:GetChildren()) do
            if v:IsA("Model") and v:GetAttribute("Team") == "Nextbot" and v:FindFirstChild("HumanoidRootPart") then
                if (myHRP.Position - v.HumanoidRootPart.Position).Magnitude < range then
                    local target = DFunctions.GetSafeCFrame(tpType, myHRP, 100, v.HumanoidRootPart.Position)
                    if target then myHRP.CFrame = target end
                    return true
                end
            end
        end
        return false
    end
    if checkFolder(workspace:FindFirstChild("Players")) then return end
    local gameFolder = workspace:FindFirstChild("Game")
    if gameFolder then checkFolder(gameFolder:FindFirstChild("Players")) end
end
function DFunctions.GetAdjustments() end
function DFunctions.setTSpeed(value)
    DFunctions.MovementValueSet("Speed", tonumber(value) or 1500)
end
function DFunctions.setTJump(value)
    DFunctions.MovementValueSet("JumpHeight", tonumber(value) or 3)
end
function DFunctions.setTJumpCap(value)
    DFunctions.MovementValueSet("JumpCap", tonumber(value) or 1)
end
function DFunctions.setTJumpAcceleration(value)
    DFunctions.MovementValueSet("JumpSpeedMultiplier", tonumber(value) or 1.45)
end
function DFunctions.setTAirStrafe(value)
    DFunctions.MovementValueSet("AirStrafeAcceleration", tonumber(value) or 182)
end
function DFunctions.setTAirAccel(value)
    DFunctions.MovementValueSet("AirAcceleration", tonumber(value) or 1)
end
function DFunctions.setTSprintCap(value)
    DFunctions.MovementValueSet("SprintCap", tonumber(value) or 2)
end
function DFunctions.setTSprintAccel(value)
    DFunctions.MovementValueSet("SprintAcceleration", tonumber(value) or 1)
end
function DFunctions.setTFriction(value)
    DFunctions.MovementValueSet("Friction", tonumber(value) or 5)
end
function DFunctions.setTFriction() end
function DFunctions.setAutoJumpEnabled() end
function DFunctions.setStrafeAcceleration() end
function DFunctions.SetPreviousAdjustment() end
function DFunctions.GetSpeedometer()
    local shared = LocalPlayer.PlayerGui:FindFirstChild("Shared")
    if not shared then return nil end
    local hud = shared:FindFirstChild("HUD")
    if not hud then return nil end
    local overlay = hud:FindFirstChild("Overlay")
    if not overlay then return nil end
    local default = overlay:FindFirstChild("Default")
    if not default then return nil end
    local charInfo = default:FindFirstChild("CharacterInfo")
    if not charInfo then return nil end
    local item = charInfo:FindFirstChild("Item")
    if not item then return nil end
    local speedometer = item:FindFirstChild("Speedometer")
    if not speedometer then return nil end
    return speedometer:FindFirstChild("Players")
end
function DFunctions.BounceFunction()
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChild("Humanoid")
    if not humanoid then return end
    if not DConfiguration.Misc.Utilities.BounceModification.Enabled then
        humanoid.WalkSpeed = 0
        return
    end
    local state = char:GetAttribute("State")
    if state == "Default" or state == "Downed" then
        humanoid.WalkSpeed = 0
    elseif state == "Emoting" or state == "EmotingAir" or state == "EmotingSlide" or state == "EmotingSlideAir" then
        humanoid.WalkSpeed = DConfiguration.Misc.Utilities.BounceModification.EmoteBounce
    else
        humanoid.WalkSpeed = DConfiguration.Misc.Utilities.BounceModification.DefaultBounce
    end
end
function DFunctions.SuperBounce()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end
    local prevHip = char:FindFirstChild("R15Visual") and 0.75 or -1.25
    hrp.CanCollide = false
    humanoid.HipHeight = -100
    task.wait(2)
    hrp.CanCollide = true
    humanoid.HipHeight = prevHip
end
function DFunctions.StartLag(ms)
    local LagTime = (ms or 200) * 0.002
    local Character = LocalPlayer.Character
    if not Character then return end
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local StoredVelocity = hrp.AssemblyLinearVelocity
    if StoredVelocity.Magnitude < 1 then return end
    local start = tick()
    while tick() - start < LagTime do end
    local Mode = DConfiguration.Misc.Utilities.LagSwitch.Mode
    if Mode == "FastFlag" or LagTime < 0.2 then
        if setfflag then
            setfflag("MaxMissedWorldStepsRemembered", "9999")
        end
        return
    end
end
local EdgeParams = RaycastParams.new()
EdgeParams.FilterType = Enum.RaycastFilterType.Blacklist
function DFunctions.ModifyEdgeTrimp()
    local Character = LocalPlayer.Character
    if not Character then return end
    local Root = Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end
    local Velocity = Root.AssemblyLinearVelocity
    local HorizontalVel = Vector3.new(Velocity.X, 0, Velocity.Z)
    local Speed = HorizontalVel.Magnitude
    if Speed < 22 then return end
    if Velocity.Y >= 0 then return end
    local MoveDir = HorizontalVel.Unit
    EdgeParams.FilterDescendantsInstances = {Character}
    local PredictTime = math.clamp(Speed / 110, 0.14, 0.24)
    local FutureMovePos = Root.Position + HorizontalVel * PredictTime + MoveDir * 2.5
    local dropThreshold = DConfiguration.Misc.Utilities.EdgeTrimpModification.DownThreshold
    local heightMult = DConfiguration.Misc.Utilities.EdgeTrimpModification.HeightMultiplier
    local downHit = workspace:Raycast(FutureMovePos + Vector3.new(0, 2, 0), Vector3.new(0, -6, 0), EdgeParams)
    if downHit then
        local drop = Root.Position.Y - downHit.Position.Y
        if drop >= dropThreshold then
            Root.AssemblyLinearVelocity = HorizontalVel * 1.05 + Vector3.new(0, math.clamp(Speed * 0.7, 22, 85) * heightMult, 0)
        end
    end
end
local CharacterTag = nil
local function GetCharacterTag(character)
    if not character then return nil end
    return character:GetAttribute("Tag")
end
if LocalPlayer.Character then CharacterTag = GetCharacterTag(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(function(c) CharacterTag = GetCharacterTag(c) end)
local function getCurrentSpeed(character)
    if not character then return 0 end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return 0 end
    local velocity = hrp.AssemblyLinearVelocity
    return (velocity.X * velocity.X + velocity.Z * velocity.Z) ^ 0.5
end
function DFunctions.MovementValueSet(MovementType, value)
    if not CharacterTag then CharacterTag = GetCharacterTag(LocalPlayer.Character) end
    if not CharacterTag then return end
    pcall(function()
        firesignal(ReplicatedStorage.Events.CharacterTask.OnClientEvent, CharacterTag, "ModifyMovement", { MovementType, value })
    end)
end
local MovementValueSet = DFunctions.MovementValueSet
local originalRegistry = MovementModule.RegistryTermUpdated
local originalMovementUpdate = MovementModule.Update

if originalRegistry then
    MovementModule.RegistryTermUpdated = function(self, term)
        if term == "Emote" then
            local AED = DConfiguration.Misc.MovementModification.AggressiveEmoteDash
            local id = self.DataRegistry:Get("Emote")
            if id and id ~= 0 then
                local item = ClientItemService:GetItemFromID(id)
                local mult = 1
                if item then
                    local ok, mod = pcall(require, item)
                    if ok and mod and mod.EmoteInfo then mult = mod.EmoteInfo.SpeedMult or 1 end
                end
                if AED.Enabled and AED.Type == "Blatant" then
                    self.MoveStats:SpeedChange("Emote", mult * ((AED.Speed or 1000) / 1000))
                else
                    self.MoveStats:SpeedChange("Emote", mult)
                end
            else
                self.MoveStats:SpeedChange("Emote", nil)
            end
            return
        end
        return originalRegistry(self, term)
    end
end

if originalMovementUpdate then
    MovementModule.Update = function(self, ...)
        originalMovementUpdate(self, ...)
        
        local character = self.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end
        
        local MM = DConfiguration.Misc.MovementModification
        local AutoJump = MM.AutoJump
        local S = AutoJump.Settings
        local Slide = MM.SlideModification
        local state = self.State or (self.DataRegistry and self.DataRegistry:Get("State"))
        local isInfSlide = (state == "Slide" or state == "EmotingSlide" or state == "CarrySlide")
        local velocity = root.AssemblyLinearVelocity

        local holdJump = AutoJump.HoldKeybind and humanoid.Jump == true
        local autoJumpActive = AutoJump.Enabled or holdJump
        
        -- ระบบ Raycast Auto-Jump (ตามต้นฉบับ 100%)
        if autoJumpActive and S.JumpType == "Simulation" then
            pcall(function()
                local ray = Ray.new(root.Position, Vector3.new(0, -4, 0))
                local hitPart = workspace:FindPartOnRay(ray, character)
                if hitPart then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        elseif autoJumpActive then
            pcall(function() self:AttemptJump() end)
        end

        -- Infinite Slide friction (matches Evade_Overhaul_Deobfuscated)
        local desiredFriction = nil
        if isInfSlide and Slide.Enabled then
            desiredFriction = Slide.Acceleration or -8
        end

        local accelOn = S.Type ~= "No Acceleration"
        local isNegativeOnly = (S.Type == "Negative Only")
        
        if desiredFriction == nil and accelOn and autoJumpActive then
            desiredFriction = S.Acceleration or -0.2
        end

        if desiredFriction ~= AutoJump.lastFriction then
            if desiredFriction ~= nil then
                MovementValueSet("Friction", desiredFriction)
            else
                MovementValueSet("Friction", DConfiguration.Misc.PlayerAdjustment.Default.Friction)
            end
            AutoJump.lastFriction = desiredFriction
        end

        -- ระบบเร่งความเร็วตอนขึ้นเนิน (ไม่ล็อคทิศทาง)
        if autoJumpActive and S.JumpType == "Simulation" and accelOn then
            local horizontal = Vector3.new(velocity.X, 0, velocity.Z)
            local speed = horizontal.Magnitude
            
            if speed > 0.05 then
                local configuredAcceleration = tonumber(S.Acceleration) or -0.1
                local canApplyAccel = true
                if isNegativeOnly and configuredAcceleration >= 0 then
                    canApplyAccel = false
                end
                
                if canApplyAccel then
                    local magnitudeVal = math.abs(configuredAcceleration)
                    local gain = math.clamp(magnitudeVal * 0.002, 0, 0.005)
                    local moveDir = humanoid.MoveDirection
                    local targetVel = horizontal
                    
                    if moveDir.Magnitude > 0 then
                        targetVel = (moveDir * speed) + (moveDir * (speed * gain))
                    else
                        targetVel = horizontal * (1 + gain)
                    end
                    
                    root.AssemblyLinearVelocity = Vector3.new(
                        targetVel.X,
                        velocity.Y,
                        targetVel.Z
                    )
                end
            end
        end
    end
end

local function updateAutoJumpEnabled()
    local AutoJump = DConfiguration.Misc.MovementModification.AutoJump
    local shouldEnable = (AutoJump.Enabled or AutoJump.HoldKeybind) and AutoJump.Settings.Type ~= "No Acceleration"
    MovementValueSet("BhopEnabled", shouldEnable)
end
function DFunctions.GetStatus(player)
    if not player then return "DEAD" end
    local character = player.Character
    if not character then return "DEAD" end
    local cs = CharacterService
    if not cs then
        pcall(function()
            cs = CharacterService
        end)
    end
    if cs then
        local ok, charData = pcall(function() return cs:GetCharacterFromPlayer(player) end)
        if ok and charData and charData.DataRegistry then
            if charData.DataRegistry:Get("Downed") then
                return "DOWNED"
            end
        end
    end
    local folder = workspace:FindFirstChild("Players")
    local folderPlr = folder and folder:FindFirstChild(player.Name)
    if folderPlr then
        local downed = folderPlr:GetAttribute("Downed")
        if downed == true or downed == 1 or downed == "true" then
            return "DOWNED"
        end
    end
    if character:GetAttribute("Downed") == true then
        return "DOWNED"
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then return "ALIVE" end
    return "DEAD"
end
function DFunctions.isPlayerDowned(player)
    return DFunctions.GetStatus(player) == "DOWNED"
end
function DFunctions.isPlayerRagdolled(player)
    if not player or not player.Character then return false end
    local char = player.Character
    if char:FindFirstChild("RagdollConstraints") then return true end
    if CharacterService then
        local ok, charData = pcall(function() return CharacterService:GetCharacterFromPlayer(player) end)
        if ok and charData and charData.DataRegistry and charData.DataRegistry:Get("Ragdolling") then return true end
    end
    if char.PrimaryPart and char.PrimaryPart.Anchored then return true end
    return false
end
function DFunctions.getNearestDownedPlayer()
    local nearest, nearestDist = nil, 20
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and DFunctions.isPlayerDowned(plr) and not DFunctions.isPlayerRagdolled(plr) then
            local otherHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if otherHRP then
                local dist = (hrp.Position - otherHRP.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = plr
                end
            end
        end
    end
    return nearest
end
function DFunctions.CarryPlayer()
    local target = DFunctions.getNearestDownedPlayer()
    if not target or not target.Character then return end
    local tag = target.Character:GetAttribute("Tag")
    if tag then
        pcall(function()
            ReplicatedStorage.Events.Interact:FireServer("Carry", tag)
        end)
    end
end
function DFunctions.StartAutoCarry()
    local Carry = DConfiguration.Misc.GameAutomation.Carry
    if Carry.Connection then Carry.Connection:Disconnect() end
    Carry.Enabled = true
    Carry.Connection = RunService.Heartbeat:Connect(function()
        if not Carry.Enabled then return end
        local now = tick()
        if now - (Carry.lastAttempt or 0) < (Carry.Cooldown or 0.5) then return end
        DFunctions.CarryPlayer()
        Carry.lastAttempt = now
    end)
end
function DFunctions.StopAutoCarry()
    local Carry = DConfiguration.Misc.GameAutomation.Carry
    Carry.Enabled = false
    if Carry.Connection then
        Carry.Connection:Disconnect()
        Carry.Connection = nil
    end
end
function DFunctions.AggressiveEmoteDashFunction()
    if MovementModule then
        pcall(function()
            local id = MovementModule.DataRegistry:Get("Emote")
            if id and id ~= 0 then
                MovementModule.RegistryTermUpdated(MovementModule, "Emote")
            end
        end)
    end
end
function DFunctions.SetToMovableEmote() end
function DFunctions.InfiniteSlideFunction()
end
function DFunctions.ToggleAutoJump(state)
    DConfiguration.Misc.MovementModification.AutoJump.Enabled = state and true or false
    updateAutoJumpEnabled()
end
function DFunctions.ToggleAutoJumpHold(state)
    DConfiguration.Misc.MovementModification.AutoJump.HoldKeybind = state and true or false
    updateAutoJumpEnabled()
end
function DFunctions.SetAccelerationMethod(method)
    local AutoJump = DConfiguration.Misc.MovementModification.AutoJump
    AutoJump.Settings.Type = method
    updateAutoJumpEnabled()
    if not (AutoJump.Enabled or AutoJump.HoldKeybind) then
        MovementValueSet("Friction", DConfiguration.Misc.PlayerAdjustment.Default.Friction)
        AutoJump.lastFriction = nil
    end
end
function DFunctions.AutoJumpFunction()
    updateAutoJumpEnabled()
end
function DFunctions.ResetAutoJump()
    local AutoJump = DConfiguration.Misc.MovementModification.AutoJump
    AutoJump.Enabled = false
    AutoJump.HoldKeybind = false
    updateAutoJumpEnabled()
    MovementValueSet("Friction", DConfiguration.Misc.PlayerAdjustment.Default.Friction)
    AutoJump.lastFriction = nil
end
function DFunctions.CrouchFunction()
    local Config = DConfiguration.Misc.MovementModification.Crouch
    local now = tick()
    Config.isHolding = Config.isHolding or false
    Config.lastTick = Config.lastTick or 0
    Config.debounce = Config.debounce or 0.1
    local SendKeybindEvent = ReplicatedStorage:FindFirstChild("Services")
        and ReplicatedStorage.Services:FindFirstChild("Client")
        and ReplicatedStorage.Services.Client:FindFirstChild("KeybindService")
        and ReplicatedStorage.Services.Client.KeybindService:FindFirstChild("SendKeybindEvent")
    if not SendKeybindEvent then return end
    if not Config.isHolding and (now - Config.lastTick) >= Config.debounce then
        SendKeybindEvent:Fire({ Down = true, Key = "Crouching" })
        Config.isHolding = true
        Config.lastTick = now
    elseif Config.isHolding and (now - Config.lastTick) >= Config.debounce then
        SendKeybindEvent:Fire({ Down = false, Key = "Crouching" })
        Config.isHolding = false
        Config.lastTick = now
    end
end
function DFunctions.Normalize(input) return (input or ""):lower():gsub("%s+", "") end
function DFunctions.FindRealName(folder, userInput)
    if not userInput or userInput == "" then return nil end
    local reg = DFunctions.GetItemRegistry()
    if reg and reg.TryGetByName then
        local entry = reg.TryGetByName(userInput)
        if entry and entry.Module then return entry.Module.Name end
    end
    if not folder then return nil end
    local normalized = DFunctions.Normalize(userInput)
    for _, item in ipairs(folder:GetChildren()) do
        if DFunctions.Normalize(item.Name) == normalized then return item.Name end
    end
    for _, item in ipairs(folder:GetDescendants()) do
        if item:IsA("ModuleScript") and DFunctions.Normalize(item.Name) == normalized then
            return item.Name
        end
    end
    return nil
end
function DFunctions.GetItemModule(name)
    local reg = DFunctions.GetItemRegistry()
    if reg and reg.TryGetByName then
        local entry = reg.TryGetByName(name)
        if entry then return entry.Module, entry.Id end
    end
    return nil, nil
end
local CosmeticsFolder = Instance.new("Folder")
CosmeticsFolder.Name = "D-Folder-Cosmetics"
pcall(function() CosmeticsFolder.Parent = ReplicatedStorage:FindFirstChild("Items") or ReplicatedStorage end)
function DFunctions.scanDescendantsAsync(root, matchFolderName, targetName, callback)
    local stack = {}
    for _, child in ipairs(root:GetChildren()) do
        table.insert(stack, child)
    end
    local found = nil
    local function findInFolder(folder, name)
        for _, child in ipairs(folder:GetChildren()) do
            if child.Name == name then return child end
            local result = findInFolder(child, name)
            if result then return result end
        end
        return nil
    end
    local iterations = 0
    while #stack > 0 do
        local node = table.remove(stack)
        if node:IsA("Folder") or node:IsA("Model") then
            if matchFolderName and node.Name == matchFolderName then
                local innerResult = findInFolder(node, targetName)
                if innerResult then
                    found = innerResult
                    break
                end
            elseif not matchFolderName and node.Name == targetName then
                found = node
                break
            else
                for _, child in ipairs(node:GetChildren()) do
                    table.insert(stack, child)
                end
            end
        end
        iterations = iterations + 1
        if iterations % 100 == 0 then task.wait() end
    end
    if callback then callback(found) end
    return found
end
function DFunctions.SetEmote(emoteID)
    if not emoteID then return end
    local character = LocalPlayer.Character
    if not character then return end
    local tagValue = character:GetAttribute("Tag")
    if not tagValue then return end
    local tagBuf = buffer.create(2)
    buffer.writeu16(tagBuf, 0, tagValue)
    firesignal(ReplicatedStorage.Events.UpdateCharacterDataRegistry.OnClientEvent, {
        buffer.fromstring("\24\1"),
        emoteID,
        tagBuf
    })
end
function DFunctions.GetAllEmotes()
    local allEmotes = {}
    local itemsFolder = ReplicatedStorage:FindFirstChild("Items")
    if not itemsFolder then return allEmotes end
    local function findEmotesFolders(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Folder") then
                if child.Name == "Emotes" then
                    for _, emote in ipairs(child:GetChildren()) do
                        if emote:IsA("ModuleScript") then
                            table.insert(allEmotes, { Name = emote.Name, ID = emote:GetAttribute("ID") })
                        end
                    end
                else
                    findEmotesFolders(child)
                end
            end
        end
    end
    findEmotesFolders(itemsFolder)
    local reg = DFunctions.GetItemRegistry()
    if reg and reg.GetByCategory then
        local byCat = reg.GetByCategory("Emotes")
        if byCat then
            for id, entry in pairs(byCat) do
                if entry and entry.Module then
                    local exists = false
                    for _, e in ipairs(allEmotes) do
                        if e.Name == entry.Module.Name then exists = true break end
                    end
                    if not exists then
                        table.insert(allEmotes, { Name = entry.Module.Name, ID = entry.Id or entry.Module:GetAttribute("ID") })
                    end
                end
            end
        end
    end
    return allEmotes
end
function DFunctions.FindEmoteInfo(emoteInput)
    if not emoteInput or emoteInput == "" then return nil end
    local id = tonumber(emoteInput)
    local reg = DFunctions.GetItemRegistry()
    if id then
        if reg and reg.GetConfig and reg.GetConfig(id) then
            return { Name = tostring(id), ID = id }
        end
        for _, e in ipairs(DFunctions.GetAllEmotes()) do
            if e.ID == id then return { Name = e.Name, ID = id } end
        end
        return { Name = tostring(id), ID = id }
    end
    for _, emote in ipairs(DFunctions.GetAllEmotes()) do
        if emote.Name:lower() == tostring(emoteInput):lower() then
            return { Name = emote.Name, ID = emote.ID }
        end
    end
    if reg and reg.TryGetByName then
        local entry = reg.TryGetByName(emoteInput)
        if entry then return { Name = entry.Module.Name, ID = entry.Id } end
    end
    return nil
end
function DFunctions.AutoEmoteDash()
    local char = LocalPlayer.Character
    if not char then return end
    local emoteName = DConfiguration.Misc.GameAutomation.Macro.SelectedEmote
    local info = DFunctions.FindEmoteInfo(emoteName)
    local emoteId = info and info.ID
    if not emoteId then
        local mod = select(1, DFunctions.GetItemModule(emoteName or ""))
        if mod then emoteId = mod:GetAttribute("ID") end
    end
    if emoteId then
        pcall(function()
            ReplicatedStorage.Events.CharacterTask:FireServer("Emote", emoteId)
        end)
        DFunctions.SetEmote(emoteId)
    end
    DFunctions.CrouchFunction()
end
function DFunctions.Noclip(enabled)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not enabled
        end
    end
end
local EmoteNames = DFunctions.GetEmotesName()
if #EmoteNames == 0 then EmoteNames = {"BoldMarch", "DefaultEmote"} end
local ShopItemNames = DFunctions.GetMultipleShopItems()
if #ShopItemNames == 0 then ShopItemNames = {"Cola"} end
Tabs.Main:AddSection("Billboard ESP")
-- Generation tokens prevent duplicate ESP workers when toggles are switched rapidly.
local espLoopTokens = {}
local function nextEspLoopToken(key)
    espLoopTokens[key] = (espLoopTokens[key] or 0) + 1
    return espLoopTokens[key]
end
local function clearBillboardESP(espName)
    local folder = workspace:FindFirstChild("Players")
    if folder then
        for _, v in pairs(folder:GetDescendants()) do
            if v.Name == espName then v:Destroy() end
        end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            for _, d in pairs(plr.Character:GetDescendants()) do
                if d.Name == espName then d:Destroy() end
            end
        end
    end
    local tickets = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
    if tickets then
        for _, d in pairs(tickets:GetDescendants()) do
            if d.Name == espName then d:Destroy() end
        end
    end
end
-- Share downed-state results between Billboard, Tracer, and Highlight ESP.
-- This avoids repeatedly querying CharacterService for the same player in one short interval.
local downedTargetCache = setmetatable({}, { __mode = "k" })
local DOWNED_CACHE_TTL = 0.15
local function isDownedTarget(plr)
    if not plr then return false end
    local now = os.clock()
    local character = plr.Character
    local cached = downedTargetCache[plr]
    if cached and cached.character == character and (now - cached.time) < DOWNED_CACHE_TTL then
        return cached.value
    end

    local result = false
    if DFunctions.isPlayerDowned and DFunctions.isPlayerDowned(plr) then
        result = true
    else
        local folder = workspace:FindFirstChild("Players")
        local folderPlr = folder and folder:FindFirstChild(plr.Name)
        if folderPlr and folderPlr:GetAttribute("Downed") == true then
            result = true
        elseif character then
            if character:GetAttribute("Downed") == true then
                result = true
            else
                local hum = character:FindFirstChildOfClass("Humanoid")
                result = hum ~= nil and hum.Health <= 0
            end
        end
    end

    downedTargetCache[plr] = { character = character, time = now, value = result }
    return result
end
local Toggle = Tabs.Main:AddToggle("BillboardNextbots", {Title = "Billboard Nextbots", Default = false })
Toggle:OnChanged(function(value)
    local loopToken = nextEspLoopToken("BillboardNextbots")
    DConfiguration.ESP.Nextbots = value
    if not value then
        clearBillboardESP("NextbotESP")
        return
    end
    task.spawn(function()
        while DConfiguration.ESP.Nextbots and espLoopTokens["BillboardNextbots"] == loopToken do
            local folder = workspace:FindFirstChild("Players")
            if folder then
                for _, v in pairs(folder:GetChildren()) do
                    if v:GetAttribute("Team") == "Nextbot" and v:FindFirstChild("HumanoidRootPart") then
                        local hrp = v.HumanoidRootPart
                        if not hrp:FindFirstChild("NextbotESP") then
                            CreateBillboardESP("NextbotESP", hrp, Color3.fromRGB(255, 0, 0), 18)
                        end
                        UpdateBillboardESP("NextbotESP", hrp, v.Name, Color3.fromRGB(255, 0, 0), 18, Camera.CFrame.Position)
                    end
                end
            end
            task.wait(0.25)
        end
        clearBillboardESP("NextbotESP")
    end)
end)
local Toggle = Tabs.Main:AddToggle("BillboardPlayers", {Title = "Billboard Players", Default = false })
Toggle:OnChanged(function(value)
    local loopToken = nextEspLoopToken("BillboardPlayers")
    DConfiguration.ESP.Players = value
    if not value then
        clearBillboardESP("PlayerESP")
        return
    end
    task.spawn(function()
        while DConfiguration.ESP.Players and espLoopTokens["BillboardPlayers"] == loopToken do
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = plr.Character.HumanoidRootPart
                    if not hrp:FindFirstChild("PlayerESP") then
                        CreateBillboardESP("PlayerESP", hrp, Color3.fromRGB(255, 255, 255), 14)
                    end
                    local color = isDownedTarget(plr) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
                    UpdateBillboardESP("PlayerESP", hrp, plr.Name, color, 14, Camera.CFrame.Position)
                end
            end
            task.wait(0.25)
        end
        clearBillboardESP("PlayerESP")
    end)
end)
local Toggle = Tabs.Main:AddToggle("BillboardTicket", {Title = "Billboard Tickets", Default = false })
Toggle:OnChanged(function(State)
    local loopToken = nextEspLoopToken("BillboardTicket")
    DConfiguration.ESP.Tickets = State
    if not State then
        clearBillboardESP("TicketESP")
        return
    end
    task.spawn(function()
        while DConfiguration.ESP.Tickets and espLoopTokens["BillboardTicket"] == loopToken do
            local tickets = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
            if tickets then
                for _, v in pairs(tickets:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name == "HumanoidRootPart" then
                        if not v:FindFirstChild("TicketESP") then
                            CreateBillboardESP("TicketESP", v, Color3.fromRGB(255, 213, 128), 18)
                        end
                        UpdateBillboardESP("TicketESP", v, v.Parent and v.Parent.Name or "Ticket", Color3.fromRGB(255, 213, 128), 18, Camera.CFrame.Position)
                    end
                end
            end
            task.wait(0.5)
        end
        clearBillboardESP("TicketESP")
    end)
end)
Tabs.Main:AddSection("Tracer ESP")
local TracerLines = {}
local TracerLinesBots = {}
local TracerLinesTickets = {}
local Toggle = Tabs.Main:AddToggle("TracersPlayers", {Title = "Tracer Players", Default = false})
Toggle:OnChanged(function(State)
    local loopToken = nextEspLoopToken("TracersPlayers")
    DConfiguration.Tracers.Players = State
    if not State then
        for part, _ in pairs(TracerLines) do DestroyTracerESP(TracerLines, part) end
        TracerLines = {}
        return
    end
    task.spawn(function()
        while DConfiguration.Tracers.Players and espLoopTokens["TracersPlayers"] == loopToken do
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = plr.Character.HumanoidRootPart
                    if not TracerLines[hrp] then
                        CreateTracerESP(TracerLines, hrp, 2, Color3.fromRGB(255, 255, 255))
                    end
                    local color = isDownedTarget(plr) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
                    UpdateTracerESP(TracerLines, hrp, color)
                end
            end
            CleanupTracers(TracerLines)
            task.wait(0.06)
        end
    end)
end)
local Toggle = Tabs.Main:AddToggle("TracersBots", {Title = "Tracer Bots", Default = false})
Toggle:OnChanged(function(State)
    local loopToken = nextEspLoopToken("TracersBots")
    DConfiguration.Tracers.Nextbots = State
    if not State then
        for part, _ in pairs(TracerLinesBots) do DestroyTracerESP(TracerLinesBots, part) end
        TracerLinesBots = {}
        return
    end
    task.spawn(function()
        while DConfiguration.Tracers.Nextbots and espLoopTokens["TracersBots"] == loopToken do
            local folder = workspace:FindFirstChild("Players")
            if folder then
                for _, v in pairs(folder:GetChildren()) do
                    if v:GetAttribute("Team") == "Nextbot" and v:FindFirstChild("HumanoidRootPart") then
                        local hrp = v.HumanoidRootPart
                        if not TracerLinesBots[hrp] then
                            CreateTracerESP(TracerLinesBots, hrp, 5, Color3.fromRGB(255, 0, 0))
                        end
                        UpdateTracerESP(TracerLinesBots, hrp, Color3.fromRGB(255, 0, 0))
                    end
                end
            end
            CleanupTracers(TracerLinesBots)
            task.wait(0.06)
        end
    end)
end)
local Toggle = Tabs.Main:AddToggle("TracerTickets", {Title = "Tracer Tickets", Default = false})
Toggle:OnChanged(function(State)
    local loopToken = nextEspLoopToken("TracerTickets")
    DConfiguration.Tracers.Tickets = State
    if not State then
        for part, _ in pairs(TracerLinesTickets) do DestroyTracerESP(TracerLinesTickets, part) end
        TracerLinesTickets = {}
        return
    end
    task.spawn(function()
        while DConfiguration.Tracers.Tickets and espLoopTokens["TracerTickets"] == loopToken do
            local tickets = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
            if tickets then
                for _, v in pairs(tickets:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name == "HumanoidRootPart" then
                        if not TracerLinesTickets[v] then
                            CreateTracerESP(TracerLinesTickets, v, 2, Color3.fromRGB(255, 213, 128))
                        end
                        UpdateTracerESP(TracerLinesTickets, v, Color3.fromRGB(255, 213, 128))
                    end
                end
            end
            CleanupTracers(TracerLinesTickets)
            task.wait(0.06)
        end
    end)
end)
Tabs.Main:AddSection("Highlight ESP")
local function clearHighlights(name)
    local rigs = workspace:FindFirstChild("Rigs")
    if rigs then
        for _, rig in pairs(rigs:GetChildren()) do
            DestroyHighlightESP(name, rig)
        end
    end
    local folder = workspace:FindFirstChild("Players")
    if folder then
        for _, v in pairs(folder:GetChildren()) do
            DestroyHighlightESP(name, v)
        end
    end
    local tickets = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
    if tickets then
        for _, v in pairs(tickets:GetChildren()) do
            DestroyHighlightESP(name, v)
            local hrp = v:FindFirstChild("HumanoidRootPart")
            if hrp then DestroyHighlightESP(name, hrp) end
        end
    end
end
local Toggle = Tabs.Main:AddToggle("HighlightNextbot", {Title = "Highlight Nextbots", Default = false })
Toggle:OnChanged(function(value)
    local loopToken = nextEspLoopToken("HighlightNextbot")
    DConfiguration.Highlight.Nextbots = value
    if not value then
        clearHighlights("NextbotHighlight")
        return
    end
    task.spawn(function()
        while DConfiguration.Highlight.Nextbots and espLoopTokens["HighlightNextbot"] == loopToken do
            local rigs = workspace:FindFirstChild("Rigs")
            local playersFolder = workspace:FindFirstChild("Players")
            if rigs then
                for _, rig in pairs(rigs:GetChildren()) do
                    local team = playersFolder and playersFolder:FindFirstChild(rig.Name) and playersFolder[rig.Name]:GetAttribute("Team")
                    if team == "Nextbot" then
                        if not rig:FindFirstChild("NextbotHighlight") then
                            CreateHighlightESP("NextbotHighlight", rig, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), false)
                        end
                        UpdateHighlightESP("NextbotHighlight", rig, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), false)
                    end
                end
            end
            task.wait(0.25)
        end
        clearHighlights("NextbotHighlight")
    end)
end)
local Toggle = Tabs.Main:AddToggle("HighlightPlayers", {Title = "Highlight Players", Default = false })
Toggle:OnChanged(function(value)
    local loopToken = nextEspLoopToken("HighlightPlayers")
    DConfiguration.Highlight.Players = value
    if not value then
        clearHighlights("PlayerHighlight_D")
        return
    end
    task.spawn(function()
        while DConfiguration.Highlight.Players and espLoopTokens["HighlightPlayers"] == loopToken do
            local rigs = workspace:FindFirstChild("Rigs")
            local playersFolder = workspace:FindFirstChild("Players")
            if rigs then
                for _, rig in pairs(rigs:GetChildren()) do
                    if rig.Name ~= LocalPlayer.Name then
                        local folderPlr = playersFolder and playersFolder:FindFirstChild(rig.Name)
                        local team = folderPlr and folderPlr:GetAttribute("Team")
                        if team ~= "Nextbot" then
                            if not rig:FindFirstChild("PlayerHighlight_D") then
                                CreateHighlightESP("PlayerHighlight_D", rig, Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0), false)
                            end
                            local plr = Players:FindFirstChild(rig.Name)
                            local color = (plr and isDownedTarget(plr)) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
                            UpdateHighlightESP("PlayerHighlight_D", rig, color, Color3.fromRGB(0, 0, 0), false)
                        end
                    end
                end
            end
            task.wait(0.25)
        end
        clearHighlights("PlayerHighlight_D")
    end)
end)
local Toggle = Tabs.Main:AddToggle("HighlightTicket", {Title = "Highlight Tickets", Default = false })
Toggle:OnChanged(function(State)
    local loopToken = nextEspLoopToken("HighlightTicket")
    DConfiguration.Highlight.Tickets = State
    if not State then
        clearHighlights("TicketHighlight")
        return
    end
    task.spawn(function()
        while DConfiguration.Highlight.Tickets and espLoopTokens["HighlightTicket"] == loopToken do
            local tickets = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
            if tickets then
                for _, v in pairs(tickets:GetChildren()) do
                    local target = v:IsA("Model") and v or v
                    if not target:FindFirstChild("TicketHighlight") then
                        CreateHighlightESP("TicketHighlight", target, Color3.fromRGB(255, 213, 128), Color3.fromRGB(255, 213, 128), false)
                    end
                    UpdateHighlightESP("TicketHighlight", target, Color3.fromRGB(255, 213, 128), Color3.fromRGB(255, 213, 128), false)
                end
            end
            task.wait(0.25)
        end
        clearHighlights("TicketHighlight")
    end)
end)
Tabs.Main:AddSection("Game Modification")
local Toggle = Tabs.Main:AddToggle("AutoRespawn", {Title = "Auto Respawn", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Main.AutoRespawn = value
    DConfiguration.SelfRevive.Enabled = value
    if value then
        DFunctions.StartSelfRevive()
    else
        DFunctions.StopSelfRevive()
    end
end)
local Toggle = Tabs.Main:AddToggle("SelfReviveButton", {Title = "Self Revive (Button)", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("SelfReviveGui", "Self Revive: OFF", 0.15, 0.1, function(btn)
            local SR = DConfiguration.SelfRevive
            if SR.Enabled and SR.Connections and SR.Connections.Heartbeat then
                DFunctions.StopSelfRevive()
                DConfiguration.Main.AutoRespawn = false
                btn.Text = "Self Revive: OFF"
            else
                DFunctions.StartSelfRevive()
                DConfiguration.Main.AutoRespawn = true
                btn.Text = "Self Revive: ON"
            end
        end)
    else
        DFunctions.DestroyButton("SelfReviveGui")
    end
end)
local Toggle = Tabs.Main:AddToggle("RespawnButton", {Title = "Respawn (Button)", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("RespawnButton", "Respawn", 0.15 + DConfiguration.Settings.GuiScale.Respawn, 0.1 + DConfiguration.Settings.GuiScale.Respawn, function(btn)
            btn.Text = "Respawning..."
            local event = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("SetPlayerMode")
            if event then event:FireServer(true) end
            wait(0.1)
            btn.Text = "Respawned!"
            wait(0.2)
            btn.Text = "Respawn"
        end)
    else
        DFunctions.DestroyButton("RespawnButton")
    end
end)
Tabs.Main:AddInput("RespawnButtonSize", {
    Title = "Respawn Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.Respawn),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.Respawn = num * 0.01
        else
            DConfiguration.Settings.GuiScale.Respawn = 0
        end
        DFunctions.UpdateButton("RespawnButton", 0.15 + DConfiguration.Settings.GuiScale.Respawn, 0.1 + DConfiguration.Settings.GuiScale.Respawn)
    end
})
Tabs.Main:AddButton({
    Title = "Force Respawn",
    Description = "",
    Callback = function()
        local event = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("SetPlayerMode")
        if event then event:FireServer(true) end
    end
})
local Dropdown = Tabs.Main:AddDropdown("RespawnType", {
    Title = "Respawn Type",
    Values = {"Spawnpoint", "Fake Revive"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(value)
    DConfiguration.Main.RespawnType = value
    DConfiguration.SelfRevive.Method = value
end)
Tabs.Main:AddParagraph({Title = " ", Content = ""})
local Toggle = Tabs.Main:AddToggle("AutoWhistle", {Title = "Auto Whistle", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Main.AutoWhistle = value
    task.spawn(function()
        while DConfiguration.Main.AutoWhistle do
            local SendKeybindEvent = ReplicatedStorage:FindFirstChild("Services")
                and ReplicatedStorage.Services:FindFirstChild("Client")
                and ReplicatedStorage.Services.Client:FindFirstChild("KeybindService")
                and ReplicatedStorage.Services.Client.KeybindService:FindFirstChild("SendKeybindEvent")
            if SendKeybindEvent then
                SendKeybindEvent:Fire({ Down = true, Key = "Whistle" })
                task.wait(0.05)
                SendKeybindEvent:Fire({ Down = false, Key = "Whistle" })
            end
            task.wait(1)
        end
    end)
end)
Tabs.Main:AddSection("Alternative Settings")
local Toggle = Tabs.Main:AddToggle("AntiAfk", {Title = "Anti-AFK", Default = false })
Toggle:OnChanged(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:ClickButton2(Vector2.new())
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)
pcall(function() Options.AntiAfk:SetValue(true) end)
local Toggle = Tabs.Main:AddToggle("ShowTimer", {Title = "Show Timer", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Main.ShowTimer = State
    DConfiguration.TimerDisplay.Enabled = State
    if State then
        DFunctions.CreateTimer()
    else
        DFunctions.RemoveTimer()
    end
end)
local Toggle = Tabs.Main:AddToggle("ShowSpecialRound", {Title = "Show Special Round", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.TimerDisplay.SpecialRoundEnabled = State
    if State then
        DFunctions.CreateSpecialRoundDisplay()
    else
        DFunctions.RemoveSpecialRoundDisplay()
    end
end)
local Toggle = Tabs.Main:AddToggle("DisableCameraShake", {Title = "Disable Camera Shake", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Removals.CameraShake = value
end)
Tabs.Main:AddButton({
    Title = "Open Leaderboard",
    Description = "",
    Callback = function()
        local SendKeybindEvent = ReplicatedStorage:FindFirstChild("Services")
            and ReplicatedStorage.Services:FindFirstChild("Client")
            and ReplicatedStorage.Services.Client:FindFirstChild("KeybindService")
            and ReplicatedStorage.Services.Client.KeybindService:FindFirstChild("SendKeybindEvent")
        if SendKeybindEvent then
            SendKeybindEvent:Fire({ Down = true, Key = "Leaderboard" })
        end
    end
})
Tabs.Main:AddSection("Player Modification")
local Toggle = Tabs.Main:AddToggle("PlayerJumpPower", {Title = "Jump Power Toggle", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.Humanoids.OriginalJumpHeight = State
    while DConfiguration.Misc.Humanoids.OriginalJumpHeight and task.wait(0.1) do
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = DConfiguration.Misc.Humanoids.JP
        end
    end
end)
Tabs.Main:AddInput("PlayerJumpPower", {
    Title = "Player Jump Power",
    Default = "20",
    Placeholder = "Jump Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Humanoids.JP = tonumber(Value) or 20
    end
})
local Toggle = Tabs.Main:AddToggle("PlayerWalkspeed", {Title = "Walkspeed Toggle", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.Humanoids.WalkspeedCF = State
    while DConfiguration.Misc.Humanoids.WalkspeedCF and task.wait() do
        local chr = LocalPlayer.Character
        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
        if chr and hum and hum.MoveDirection.Magnitude > 0 then
            chr:TranslateBy(hum.MoveDirection * DConfiguration.Misc.Humanoids.CF * 0.1)
        end
    end
end)
Tabs.Main:AddInput("PlayerWalkCf", {
    Title = "Player Walkspeed",
    Default = "5",
    Placeholder = "Walk Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Humanoids.CF = tonumber(Value) or 5
    end
})
local Toggle = Tabs.Main:AddToggle("Noclip", {Title = "Noclip", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Main.Noclip = value
    if value then
        task.spawn(function()
            while DConfiguration.Main.Noclip do
                DFunctions.Noclip(true)
                RunService.Stepped:Wait()
            end
            DFunctions.Noclip(false)
        end)
    else
        DFunctions.Noclip(false)
    end
end)
    MovementModule = require(ReplicatedStorage:WaitForChild("Objects"):WaitForChild("Game"):WaitForChild("Character"):WaitForChild("Client"):WaitForChild("Movement"))
    DConfiguration.Main.FlyoriginalUpdate = MovementModule.Update
    local playerModule = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
    controlModule = require(playerModule:WaitForChild("ControlModule"))
local function getFlyDirection()
    if not controlModule then return Vector3.new() end
    local camCF = workspace.CurrentCamera.CFrame
    local moveVector = controlModule:GetMoveVector()
    if moveVector.Magnitude < 0.01 then
        return Vector3.new(0, 0, 0)
    end
    local forward = camCF.LookVector
    local right = camCF.RightVector
    return (forward * -moveVector.Z + right * moveVector.X).Unit * 150 * DConfiguration.Main.FlySpeed
end
local function flyUpdate(self, dt)
    if DConfiguration.Main.FlyoriginalUpdate then DConfiguration.Main.FlyoriginalUpdate(self, dt) end
    local hrp = self.Character and self.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local flyDir = getFlyDirection()
    if flyDir.Magnitude > 0.1 then
        DConfiguration.Main.isFlyFloating = nil
    elseif not DConfiguration.Main.isFlyFloating then
        DConfiguration.Main.isFlyFloating = hrp.Position.Y
    end
    local newVel = flyDir
    if self.DataRegistry and self.DataRegistry.Set then
        self.DataRegistry:Set("Velocity", newVel * 90)
    end
    hrp.AssemblyLinearVelocity = newVel
    if DConfiguration.Main.isFlyFloating and flyDir.Magnitude <= 0.1 then
        local pos = hrp.Position
        hrp.CFrame = CFrame.new(pos.X, DConfiguration.Main.isFlyFloating, pos.Z) * (hrp.CFrame - hrp.CFrame.Position)
    end
end
local function StartFly()
    if DConfiguration.Main.Fly or not MovementModule then return end
    DConfiguration.Main.Fly = true
    DConfiguration.Main.isFlyFloating = nil
    MovementModule.Update = flyUpdate
end
local function StopFly()
    if not DConfiguration.Main.Fly then return end
    DConfiguration.Main.Fly = false
    DConfiguration.Main.isFlyFloating = nil
    if MovementModule and DConfiguration.Main.FlyoriginalUpdate then
        MovementModule.Update = DConfiguration.Main.FlyoriginalUpdate
    end
end
local Toggle = Tabs.Main:AddToggle("ShowFlyButton", { Title = "Fly Button", Default = false })
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("FlyButton", "Fly: OFF", 0.15, 0.1, function(btn)
            local newState = not DConfiguration.Main.Fly
            if newState then
                StartFly()
                btn.Text = "Fly: ON"
            else
                StopFly()
                btn.Text = "Fly: OFF"
            end
        end)
    else
        StopFly()
        DFunctions.DestroyButton("FlyButton")
    end
end)
local FlySpeedInput = Tabs.Main:AddInput("FlySpeedInput", {
    Title = "Fly Speed",
    Default = "1",
    Placeholder = "Enter fly speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local speed = tonumber(Value)
        if speed and speed > 0 then
            DConfiguration.Main.FlySpeed = speed
        end
    end
})
wait(Duration)
Tabs.AutoFarm:AddSection("Auto Farm")
local Toggle = Tabs.AutoFarm:AddToggle("AutoFarmMoney", {
    Title = "Auto Farm Token",
    Description = "Teleports under a random workspace.Players child and fires Revive. Stays on that target until it is gone. Ban risk on public servers.",
    Default = false
})
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.FarmTokens = State
    DConfiguration.TokenFarm.Enabled = State
    if State then
        DFunctions.StartGodMode()
    else
        DFunctions.StopGodMode()
    end
end)
Tabs.AutoFarm:AddInput("TokenFarmOffset", {
    Title = "Token Farm Offset",
    Default = "0 -8 0",
    Placeholder = "X Y Z",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local x, y, z = tostring(Value):match("^%s*([%-%d%.]+)%s+([%-%d%.]+)%s+([%-%d%.]+)%s*$")
        if x and y and z then
            DConfiguration.TokenFarm.TokenOffset = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
        end
    end
})
Tabs.AutoFarm:AddSlider("TokenFarmDelay", {
    Title = "Token Farm Delay",
    Description = "Revive fire delay in seconds",
    Default = 2,
    Min = 1,
    Max = 4,
    Rounding = 0,
    Callback = function(Value)
        DConfiguration.TokenFarm.TokenDelay = Value
    end
})
local ticketFarmRunId = 0
local Toggle = Tabs.AutoFarm:AddToggle("AutoFarmTickets", {Title = "Auto Farm Tickets", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.FarmTickets = State
    ticketFarmRunId += 1
    local runId = ticketFarmRunId
    if State then
        task.spawn(function()
            while DConfiguration.AutoFarm.FarmTickets and runId == ticketFarmRunId do
                task.wait(1)
                if not DConfiguration.AutoFarm.FarmTickets or runId ~= ticketFarmRunId then break end
                DFunctions.TicketsFarming()
            end
        end)
    end
end)
local objectiveFarmRunId = 0
local Toggle = Tabs.AutoFarm:AddToggle("AutoCompleteObjectives", {Title = "Auto Complete Objective", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.CompleteObjective = State
    objectiveFarmRunId += 1
    local runId = objectiveFarmRunId
    if State then
        task.spawn(function()
            while DConfiguration.AutoFarm.CompleteObjective and runId == objectiveFarmRunId do
                task.wait(3)
                if not DConfiguration.AutoFarm.CompleteObjective or runId ~= objectiveFarmRunId then break end
                DFunctions.PointFarming()
            end
        end)
    end
end)
local afkFarmRunId = 0
local Toggle = Tabs.AutoFarm:AddToggle("AFKFarm", {Title = "AFK Farm", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.AFKFarm = State
    afkFarmRunId += 1
    local runId = afkFarmRunId
    if State then
        task.spawn(function()
            while DConfiguration.AutoFarm.AFKFarm and runId == afkFarmRunId do
                task.wait(1)
                if not DConfiguration.AutoFarm.AFKFarm or runId ~= afkFarmRunId then break end
                DFunctions.AFKFarming()
            end
        end)
    end
end)
Tabs.AutoFarm:AddSection("Auto Vote Maps")
local Toggle = Tabs.AutoFarm:AddToggle("RemoveReducingRewards", {Title = "Remove Reducing Rewards", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Removals.ReducingRewards = value
end)
local invisibleWallsRunId = 0
local Toggle = Tabs.AutoFarm:AddToggle("RemoveInvisibleWalls", {Title = "Remove Invisible Walls", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Removals.InvisibleWalls = value
    invisibleWallsRunId += 1
    local runId = invisibleWallsRunId
    if value then
        task.spawn(function()
            while DConfiguration.Removals.InvisibleWalls and runId == invisibleWallsRunId do
                task.wait(1)
                if not DConfiguration.Removals.InvisibleWalls or runId ~= invisibleWallsRunId then break end
                DFunctions.DisableInvisParts(false)
            end
        end)
    else
        DFunctions.DisableInvisParts(true)
    end
end)
Tabs.AutoFarm:AddSection("Purchase Automations")
local Toggle = Tabs.AutoFarm:AddToggle("AutoBuy", {Title = "Auto Purchase Selected Item", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.PurchaseAutomations.Enabled = State
    if State then
        DConfiguration.AutoFarm.PurchaseAutomations.LastBuy = tick()
        DConfiguration.AutoFarm.PurchaseAutomations.Connection = RunService.Heartbeat:Connect(function()
            if not DConfiguration.AutoFarm.PurchaseAutomations.Enabled then return end
            if tick() - (DConfiguration.AutoFarm.PurchaseAutomations.LastBuy or 0) >= 4 then
                DFunctions.BuyItem()
                DConfiguration.AutoFarm.PurchaseAutomations.LastBuy = tick()
            end
        end)
    else
        if DConfiguration.AutoFarm.PurchaseAutomations.Connection then
            DConfiguration.AutoFarm.PurchaseAutomations.Connection:Disconnect()
            DConfiguration.AutoFarm.PurchaseAutomations.Connection = nil
        end
    end
end)
local Dropdown = Tabs.AutoFarm:AddDropdown("SelectedItem", {
    Title = "Select Item",
    Values = ShopItemNames,
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.AutoFarm.PurchaseAutomations.Selected = Value
end)
Tabs.AutoFarm:AddInput("PurchaseAmount", {
    Title = "Purchase Amount",
    Default = "1",
    Placeholder = "1",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        DConfiguration.AutoFarm.PurchaseAutomations.Amount = tonumber(Value) or 1
    end,
})
Tabs.AutoFarm:AddSection("VIP Automations")
local AutoVote = {
    Enabled = false,
    Map = 1,
    Mode = 1,
    Connections = { Map = nil, Mode = nil }
}
local function getVotePopup()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil end
    local shared = playerGui:FindFirstChild("Shared")
    if shared then
        local popups = shared:FindFirstChild("Popups")
        if popups then
            local voteActive = popups:FindFirstChild("VoteActive")
            if voteActive and voteActive.Visible then return voteActive end
            local vote = popups:FindFirstChild("Vote")
            if vote and vote.Visible then return vote end
        end
    end
    return nil
end
local function fireVoteServer(mapNumber)
    if not getVotePopup() then return end
    local voteEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("Vote")
    if voteEvent and voteEvent:IsA("RemoteEvent") then
        voteEvent:FireServer(mapNumber)
    end
end
local function fireVoteMode(modeNumber)
    if not getVotePopup() then return end
    local voteEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("Vote")
    if voteEvent and voteEvent:IsA("RemoteEvent") then
        voteEvent:FireServer(modeNumber, true)
    end
end
local function StartAutoVoteMap()
    if AutoVote.Connections.Map then AutoVote.Connections.Map:Disconnect() end
    AutoVote.Connections.Map = RunService.Heartbeat:Connect(function()
        fireVoteServer(AutoVote.Map)
    end)
end
local function StopAutoVoteMap()
    if AutoVote.Connections.Map then
        AutoVote.Connections.Map:Disconnect()
        AutoVote.Connections.Map = nil
    end
end
local function StartAutoVoteMode()
    if AutoVote.Connections.Mode then AutoVote.Connections.Mode:Disconnect() end
    AutoVote.Connections.Mode = RunService.Heartbeat:Connect(function()
        fireVoteMode(AutoVote.Mode)
    end)
end
local function StopAutoVoteMode()
    if AutoVote.Connections.Mode then
        AutoVote.Connections.Mode:Disconnect()
        AutoVote.Connections.Mode = nil
    end
end
local Toggle = Tabs.AutoFarm:AddToggle("AutoVoteMap", {Title = "Auto Vote Map", Default = false })
Toggle:OnChanged(function(State)
    if State then StartAutoVoteMap() else StopAutoVoteMap() end
end)
local Dropdown = Tabs.AutoFarm:AddDropdown("MapSection", {
    Title = "Map Section",
    Values = {"Map 1", "Map 2", "Map 3", "Map 4"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    local num = tonumber(tostring(Value):match("%d+")) or 1
    AutoVote.Map = num
    DConfiguration.AutoFarm.VIPAutomations.MapSection = num
end)
local Toggle = Tabs.AutoFarm:AddToggle("AutoVoteMode", {Title = "Auto Vote Mode", Default = false })
Toggle:OnChanged(function(State)
    if State then StartAutoVoteMode() else StopAutoVoteMode() end
end)
local Dropdown = Tabs.AutoFarm:AddDropdown("GamemodeSection", {
    Title = "Gamemode Section",
    Values = {"Mode 1", "Mode 2", "Mode 3", "Mode 4"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    local num = tonumber(tostring(Value):match("%d+")) or 1
    AutoVote.Mode = num
    DConfiguration.AutoFarm.VIPAutomations.GamemodeSection = num
end)
Tabs.AutoFarm:AddParagraph({Title = " ", Content = ""})
Tabs.AutoFarm:AddInput("MapInput", {
    Title = "Map Input",
    Default = "DesertBus",
    Placeholder = "DesertBus",
    Numeric = false,
    Finished = false,
    Description = "NO SPACE NEEDED",
    Callback = function(Value)
        DConfiguration.AutoFarm.VIPAutomations.MapInput = Value
    end
})
local Toggle = Tabs.AutoFarm:AddToggle("AutoSetMap", {Title = "Auto Set Map", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.VIPAutomations.AutoMap = State
    if State then
        DConfiguration.AutoFarm.VIPAutomations.LastMapSet = DConfiguration.AutoFarm.VIPAutomations.LastMapSet or tick()
    end
end)
Tabs.AutoFarm:AddInput("SpecialRoundInput", {
    Title = "Special Round Input",
    Default = "Plushie Hell",
    Placeholder = "Plushie Hell",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.AutoFarm.VIPAutomations.SpecialRoundInput = Value
    end
})
local Toggle = Tabs.AutoFarm:AddToggle("AutoSetSpecialRound", {Title = "Auto Set Special Round", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.VIPAutomations.AutoSpecialRound = State
    if State then
        DConfiguration.AutoFarm.VIPAutomations.LastSRSet = DConfiguration.AutoFarm.VIPAutomations.LastSRSet or tick()
    end
end)
Tabs.AutoFarm:AddInput("TimerInput", {
    Title = "Timer Input",
    Default = "180",
    Placeholder = "180",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.AutoFarm.VIPAutomations.TimerInput = Value
    end
})
local Dropdown = Tabs.AutoFarm:AddDropdown("TimerRoundState", {
    Title = "Auto Timer Round State",
    Values = {"Round Started", "Intermission", "All"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    local num = tonumber(tostring(Value):match("%d+")) or 1
    if Value == "Round Started" then num = 1
    elseif Value == "Intermission" then num = 2
    elseif Value == "All" then num = 3 end
    DConfiguration.AutoFarm.VIPAutomations.TimerRoundState = num
end)
local Toggle = Tabs.AutoFarm:AddToggle("AutoSetTimer", {Title = "Auto Set Timer", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.VIPAutomations.AutoTimer = State
    if State then
        DConfiguration.AutoFarm.VIPAutomations.LastTimerSet = DConfiguration.AutoFarm.VIPAutomations.LastTimerSet or tick()
    end
end)
pcall(function()
    if DConfiguration.AutoFarm.VIPAutomations.MapConn then
        DConfiguration.AutoFarm.VIPAutomations.MapConn:Disconnect()
        DConfiguration.AutoFarm.VIPAutomations.MapConn = nil
    end
end)
pcall(function()
    if DConfiguration.AutoFarm.VIPAutomations.SRConn then
        DConfiguration.AutoFarm.VIPAutomations.SRConn:Disconnect()
        DConfiguration.AutoFarm.VIPAutomations.SRConn = nil
    end
end)
pcall(function()
    if DConfiguration.AutoFarm.VIPAutomations.TimerConn then
        DConfiguration.AutoFarm.VIPAutomations.TimerConn:Disconnect()
        DConfiguration.AutoFarm.VIPAutomations.TimerConn = nil
    end
end)
if DConfiguration.AutoFarm.VIPAutomations.VIPConn then
    pcall(function() DConfiguration.AutoFarm.VIPAutomations.VIPConn:Disconnect() end)
    DConfiguration.AutoFarm.VIPAutomations.VIPConn = nil
end
DConfiguration.AutoFarm.VIPAutomations.VIPConn = RunService.Heartbeat:Connect(function()
    local VIP = DConfiguration.AutoFarm.VIPAutomations
    local svc = ServerStateRegistryService
    if not svc then return end
    local function getState(key)
        if svc.Registry then
            return svc.Registry[key]
        end
        return nil
    end
    local function normalize(str)
        return tostring(str or ""):gsub("%s+", ""):lower()
    end
    local function getMapDisplayName(moduleName)
        local mapsFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("Maps")
        if not mapsFolder then return nil end
        local mod = mapsFolder:FindFirstChild(moduleName)
        if mod and mod:IsA("ModuleScript") then
            local ok, data = pcall(require, mod)
            if ok and data and data.Name then
                return data.Name
            end
        end
        return nil
    end
    local function getMapModuleName(displayName)
        local mapsFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("Maps")
        if not mapsFolder then return nil end
        for _, mod in ipairs(mapsFolder:GetChildren()) do
            if mod:IsA("ModuleScript") then
                local ok, data = pcall(require, mod)
                if ok and data and data.Name then
                    if normalize(data.Name) == normalize(displayName) then
                        return mod.Name
                    end
                end
            end
        end
        return nil
    end
    local function getSpecialRoundDisplayName(moduleName)
        local srFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("SpecialRounds")
        if not srFolder then return nil end
        local mod = srFolder:FindFirstChild(moduleName)
        if mod and mod:IsA("ModuleScript") then
            local ok, data = pcall(require, mod)
            if ok and data and data.Name then
                return data.Name
            end
        end
        return nil
    end
    local function getSpecialRoundModuleName(displayName)
        local srFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("SpecialRounds")
        if not srFolder then return nil end
        for _, mod in ipairs(srFolder:GetChildren()) do
            if mod:IsA("ModuleScript") then
                local ok, data = pcall(require, mod)
                if ok and data and data.Name then
                    if normalize(data.Name) == normalize(displayName) then
                        return mod.Name
                    end
                end
            end
        end
        return nil
    end
    if VIP.AutoMap and VIP.MapInput and VIP.MapInput ~= "" then
        if tick() - (VIP.LastMapSet or 0) >= 1 then
            local current = getState("Map")
            local desired = VIP.MapInput
            local match = false
            local nc = normalize(current)
            local nd = normalize(desired)
            if nc == nd then
                match = true
            else
                local display = getMapDisplayName(desired)
                if display and normalize(display) == nc then
                    match = true
                end
                local moduleName = getMapModuleName(desired)
                if moduleName and normalize(moduleName) == nc then
                    match = true
                end
            end
            if not match then
                local isLoading = getState("MapLoading")
                if type(isLoading) == "string" then
                    else
                    DFunctions.AdminCommand("!Map " .. desired)
                    VIP.LastMapSet = tick()
                end
            end
        end
    end
    if VIP.AutoSpecialRound and VIP.SpecialRoundInput and VIP.SpecialRoundInput ~= "" then
        if tick() - (VIP.LastSRSet or 0) >= 1 then
            local current = getState("SpecialRound")
            local desired = VIP.SpecialRoundInput
            local match = false
            local nc = normalize(current)
            local nd = normalize(desired)
            if nc == nd then
                match = true
            else
                local display = getSpecialRoundDisplayName(desired)
                if display and normalize(display) == nc then
                    match = true
                end
                local moduleName = getSpecialRoundModuleName(desired)
                if moduleName and normalize(moduleName) == nc then
                    match = true
                end
            end
            if not match then
                DFunctions.AdminCommand("!SpecialRound " .. desired)
                VIP.LastSRSet = tick()
                end
        end
    end
    local isVoting = getState("Voting")
    if isVoting == true and VIP.MapInput and VIP.MapInput ~= "" then
        if tick() - (VIP.LastVotingFire or 0) >= 3 then
            DFunctions.AdminCommand("!Time 1")
            DFunctions.AdminCommand("!Map " .. VIP.MapInput)
            VIP.LastVotingFire = tick()
            end
    end
    if VIP.AutoTimer and VIP.TimerInput and VIP.TimerInput ~= "" then
        if tick() - (VIP.LastTimerSet or 0) >= 3 then
            local roundStatus = getState("RoundStatus")
            local roundState = VIP.TimerRoundState or 1
            local shouldFire = false
            if roundState == 1 and roundStatus == 2 then
                shouldFire = true
            elseif roundState == 2 and roundStatus ~= 2 then
                shouldFire = true
            elseif roundState == 3 then
                shouldFire = true
            end
            if shouldFire then
                local current = getState("Time")
                local desiredNum = tonumber(VIP.TimerInput)
                if desiredNum and (current == nil or current ~= desiredNum) then
                    DFunctions.AdminCommand("!Time " .. tostring(desiredNum))
                    VIP.LastTimerSet = tick()
                end
            end
        end
    end
end)
wait(Duration)
Tabs.Combat:AddSection("Nextbot Modification")
local Toggle = Tabs.Combat:AddToggle("AntiNextbotToggle", {Title = "Anti Nextbot Toggle", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Combat.AntiNextbot = value
    while DConfiguration.Combat.AntiNextbot and task.wait(0.1) do
        DFunctions.AntiNextbot()
    end
end)
local Dropdown = Tabs.Combat:AddDropdown("AntiBotTeleport", {
    Title = "Anti Nextbot Teleport Type",
    Values = {"Spawn", "Players"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Combat.AntiNextbotType = Value
end)
Tabs.Combat:AddInput("NextbotDistance", {
    Title = "Anti Nextbot Distance",
    Default = 15,
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Combat.AntiNextbotRange = tonumber(Value) or 15
    end
})
wait(Duration)
Tabs.Misc:AddSection("Strafe Acceleration")
Tabs.Misc:AddInput("PlayerSpeed", {
    Title = "Player Speed",
    Description = "Change how fast your character moves.",
    Default = "1500",
    Placeholder = "Speed Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local n = tonumber(Value) or 1500
        DConfiguration.Misc.PlayerAdjustment.Update.Speed = n
        DConfiguration.Misc.PlayerAdjustment.Saved.Speed = n
        DFunctions.setTSpeed(n)
    end
})
Tabs.Misc:AddInput("PlayerJump", {
    Title = "Player Jump",
    Description = "Change how high your character jumps.",
    Default = "3",
    Placeholder = "Jump Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local n = tonumber(Value) or 3
        DConfiguration.Misc.PlayerAdjustment.Update.JumpHeight = n
        DConfiguration.Misc.PlayerAdjustment.Saved.JumpHeight = n
        DFunctions.setTJump(n)
    end
})
Tabs.Misc:AddInput("PlayerJumpAcce", {
    Title = "Player Jump Acceleration",
    Description = "Your speed increases when you jump.",
    Default = "1.45",
    Placeholder = "Jump Acceleration Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local n = tonumber(Value) or 1.45
        DConfiguration.Misc.PlayerAdjustment.Update.JumpAcceleration = n
        DConfiguration.Misc.PlayerAdjustment.Saved.JumpAcceleration = n
        DFunctions.setTJumpAcceleration(n)
    end
})
Tabs.Misc:AddInput("PlayerJumpCap", {
    Title = "Player Jump Cap",
    Description = "Allows air jumping.",
    Default = "1",
    Placeholder = "Jump Cap Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local n = tonumber(Value) or 1
        DConfiguration.Misc.PlayerAdjustment.Update.JumpCap = n
        DConfiguration.Misc.PlayerAdjustment.Saved.JumpCap = n
        DFunctions.setTJumpCap(n)
    end
})
Tabs.Misc:AddInput("PlayerStrafeAcceleration", {
    Title = "Player Strafe Acceleration",
    Description = "Change how fast you move sideways in the air.",
    Default = "182",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local n = tonumber(Value) or 182
        DConfiguration.Misc.PlayerAdjustment.Update.AirStrafe = n
        DConfiguration.Misc.PlayerAdjustment.Saved.AirStrafe = n
        DFunctions.setTAirStrafe(n)
    end
})
Tabs.Misc:AddSection("Lag Switchs")
local Toggle = Tabs.Misc:AddToggle("LagSwitch", {Title = "Lag Switch (Button)", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("LagSwitchButton", "Start Lag", 0.15 + DConfiguration.Settings.GuiScale.LagSwitch, 0.1 + DConfiguration.Settings.GuiScale.LagSwitch, function(btn)
            task.spawn(function()
                DFunctions.StartLag(DConfiguration.Misc.Utilities.LagSwitch.MSDelay)
            end)
            btn.Text = "..."
            wait(0.1)
            btn.Text = "Start Lag"
        end)
    else
        DFunctions.DestroyButton("LagSwitchButton")
    end
end)
local Keybind = Tabs.Misc:AddKeybind("LagSwitchKey", {
    Title = "Lag Switch Keybind",
    Mode = "Toggle",
    Default = "H",
    Callback = function()
        task.spawn(function()
            DFunctions.StartLag(DConfiguration.Misc.Utilities.LagSwitch.MSDelay)
        end)
    end,
})
Tabs.Misc:AddInput("LagSwitchButtonSize", {
    Title = "Lag Switch Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.LagSwitch),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.LagSwitch = num * 0.01
        else
            DConfiguration.Settings.GuiScale.LagSwitch = 0
        end
        DFunctions.UpdateButton("LagSwitchButton", 0.15 + DConfiguration.Settings.GuiScale.LagSwitch, 0.1 + DConfiguration.Settings.GuiScale.LagSwitch)
    end
})
Tabs.Misc:AddInput("DelayMS", {
    Title = "Delay MS",
    Default = "200",
    Placeholder = "Value",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.LagSwitch.MSDelay = tonumber(Value) or 200
    end
})
local Dropdown = Tabs.Misc:AddDropdown("LagMode", {
    Title = "Lag Mode",
    Values = {"Normal", "Demon", "FastFlag"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.Utilities.LagSwitch.Mode = Value
end)
Tabs.Misc:AddParagraph({Title = " ", Content = ""})
Tabs.Misc:AddSection("Gravity & Bounce Modify")
local Toggle = Tabs.Misc:AddToggle("AdjustBounce", {Title = "Modify Bounce", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.Utilities.BounceModification.Enabled = State
    while DConfiguration.Misc.Utilities.BounceModification.Enabled and task.wait(0.1) do
        DFunctions.BounceFunction()
    end
end)
local Toggle = Tabs.Misc:AddToggle("SuperBounce", {Title = "Super Bounce", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("SuperBounceButton", "Super Bounce", 0.1 + DConfiguration.Settings.GuiScale.SuperBounce, 0.1 + DConfiguration.Settings.GuiScale.SuperBounce, function(btn)
            DFunctions.SuperBounce()
            btn.Text = "..."
            wait(0.1)
            btn.Text = "Super Bounce"
        end)
    else
        DFunctions.DestroyButton("SuperBounceButton")
    end
end)
Tabs.Misc:AddInput("PlayerBounce", {
    Title = "Player Bounce",
    Default = "80",
    Placeholder = "Bounce Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.BounceModification.DefaultBounce = tonumber(Value) or 80
    end
})
Tabs.Misc:AddInput("EmoteBounce", {
    Title = "Emote Bounce",
    Default = "120",
    Placeholder = "Bounce Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.BounceModification.EmoteBounce = tonumber(Value) or 120
    end
})
Tabs.Misc:AddParagraph({Title = " ", Content = ""})
Tabs.Misc:AddSection("Edge Trimp Modification")
local Toggle = Tabs.Misc:AddToggle("AdjustEdgeTrimp", {Title = "Modify Edge Trimp", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.Utilities.EdgeTrimpModification.Enabled = State
    while DConfiguration.Misc.Utilities.EdgeTrimpModification.Enabled and task.wait(0.1) do
        DFunctions.ModifyEdgeTrimp()
    end
end)
Tabs.Misc:AddInput("EdgeTrimpHeight", {
    Title = "Height Multiplier",
    Default = "1.5",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.EdgeTrimpModification.HeightMultiplier = tonumber(Value) or 1.5
    end
})
Tabs.Misc:AddInput("DownThreshold", {
    Title = "Falling Threshold",
    Default = "4.5",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.EdgeTrimpModification.DownThreshold = tonumber(Value) or 4.5
    end
})
Tabs.Misc:AddSection("Camera Adjustments")
Tabs.Misc:AddInput("CamX", {
    Title = "Stretch Horizontal",
    Default = "1",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.CameraAdjustment.StretchX = tonumber(Value) or 1
    end
})
Tabs.Misc:AddInput("CamY", {
    Title = "Stretch Vertical",
    Default = "1",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.CameraAdjustment.StretchY = tonumber(Value) or 1
    end
})
Tabs.Misc:AddInput("PlayerFOV", {
    Title = "Player FOV",
    Default = "1",
    Placeholder = "Number (multiplier)",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local mult = tonumber(Value) or 1
        if CameraService and CameraService.AdjustFOV then
            CameraService:AdjustFOV("EvadeCustomFOV", mult)
        end
    end
})
Tabs.Misc:AddButton({
    Title = "Set Camera Stretch",
    Description = "(Warning: Stretch settings can make billboards look weird or disappear from far away.)",
    Callback = function()
        LocalPlayer:SetAttribute("StretchX", DConfiguration.Misc.CameraAdjustment.StretchX)
        LocalPlayer:SetAttribute("StretchY", DConfiguration.Misc.CameraAdjustment.StretchY)
    end
})
Tabs.Misc:AddButton({
    Title = "Enable Front Camera",
    Description = "",
    Callback = function()
    end
})
Tabs.Misc:AddSection("Client Stats Panel")
local StatsPanelToggle = Tabs.Misc:AddToggle("ClientStatsPanel", {
    Title = "FPS / Ping / Client Timer Panel",
    Default = true
})
StatsPanelToggle:OnChanged(function(State)
    if fpsCounter and fpsCounter.Parent then
        fpsCounter.Enabled = State
    end
end)
Tabs.Misc:AddSection("Gun Adjustments")
Tabs.Misc:AddButton({
    Title = "Set to Infinite Ammo",
    Description = " ",
    Callback = function()
        local Tools = ReplicatedStorage:FindFirstChild("Tools")
        if not Tools then return end
        for _, tool in ipairs(Tools:GetChildren()) do
            if tool:IsA("ModuleScript") then
                local success, module = pcall(require, tool)
                if success and module and module.Tasks then
                    for _, task in ipairs(module.Tasks) do
                        if task.ResourceInfo and task.ResourceInfo.Type == "Clip" then
                            task.ResourceInfo.Reserve = 9999999999
                            task.ResourceInfo.Cap = 9999999999
                        end
                    end
                end
            end
        end
    end
})
Tabs.Misc:AddButton({
    Title = "Set to Infinite Range",
    Description = " ",
    Callback = function()
        local function setInfiniteRange(data)
            if type(data) ~= "table" then return end
            for key, value in pairs(data) do
                if (key == "Range" or key == "LungeRange" or key == "HearingRange") and type(value) == "number" then
                    data[key] = math.huge
                elseif key == "DamageDistanceInterval" and type(value) == "table" and #value >= 2 then
                    value[2] = math.huge
                elseif type(value) == "table" then
                    setInfiniteRange(value)
                end
            end
        end
        local Tools = ReplicatedStorage:FindFirstChild("Tools")
        if not Tools then return end
        for _, tool in pairs(Tools:GetChildren()) do
            if tool:IsA("ModuleScript") then
                local success, toolData = pcall(require, tool)
                if success and type(toolData) == "table" and toolData.Tasks then
                    for _, task in ipairs(toolData.Tasks) do
                        for _, func in ipairs(task.Functions or {}) do
                            for _, activation in ipairs(func.Activations or {}) do
                                for _, method in ipairs(activation.Methods or {}) do
                                    if method.Info then setInfiniteRange(method.Info) end
                                end
                            end
                        end
                        for _, autoFunc in ipairs(task.AutomaticFunctions or {}) do
                            for _, method in ipairs(autoFunc.Methods or {}) do
                                if method.Info then setInfiniteRange(method.Info) end
                            end
                        end
                    end
                end
            end
        end
    end
})
Tabs.Misc:AddButton({
    Title = "No Cooldown",
    Description = " ",
    Callback = function()
        local function setFastShoot(data)
            if type(data) ~= "table" then return end
            for key, value in pairs(data) do
                if key == "Cooldown" and type(value) == "number" then
                    data[key] = 1/65536
                elseif type(value) == "table" then
                    setFastShoot(value)
                end
            end
        end
        local Tools = ReplicatedStorage:FindFirstChild("Tools")
        if not Tools then return end
        for _, tool in pairs(Tools:GetChildren()) do
            if tool:IsA("ModuleScript") then
                local success, toolData = pcall(require, tool)
                if success and type(toolData) == "table" and toolData.Tasks then
                    for _, task in ipairs(toolData.Tasks) do
                        for _, func in ipairs(task.Functions or {}) do
                            for _, activation in ipairs(func.Activations or {}) do
                                for _, method in ipairs(activation.Methods or {}) do
                                    if method.Info then setFastShoot(method.Info) end
                                end
                            end
                        end
                        for _, autoFunc in ipairs(task.AutomaticFunctions or {}) do
                            for _, method in ipairs(autoFunc.Methods or {}) do
                                if method.Info then setFastShoot(method.Info) end
                            end
                        end
                    end
                end
            end
        end
    end
})
Tabs.Misc:AddSection("Game Automations")
local Toggle = Tabs.Misc:AddToggle("AutoCarry", {Title = "Auto Carry (Button)", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("AutoCarryGui", "Auto Carry: OFF", 0.15 + DConfiguration.Settings.GuiScale.AutoCarry, 0.1 + DConfiguration.Settings.GuiScale.AutoCarry, function(btn)
            DConfiguration.Misc.GameAutomation.Carry.FloatingButton = not DConfiguration.Misc.GameAutomation.Carry.FloatingButton
            btn.Text = DConfiguration.Misc.GameAutomation.Carry.FloatingButton and "Auto Carry: ON" or "Auto Carry: OFF"
            if DConfiguration.Misc.GameAutomation.Carry.FloatingButton then
                DFunctions.StartAutoCarry()
            else
                DFunctions.StopAutoCarry()
            end
        end)
    else
        DFunctions.StopAutoCarry()
        DFunctions.DestroyButton("AutoCarryGui")
    end
end)
local Toggle = Tabs.Misc:AddToggle("EmoteCarry", {Title = "Carry While Emote", Default = false})
Toggle:OnChanged(function(State)
    DConfiguration.Misc.GameAutomation.Carry.WhileEmote = State
end)
local Keybind = Tabs.Misc:AddKeybind("KeybindCarry", {
    Title = "Keybind to Carry",
    Mode = "Toggle",
    Default = "Q",
    Callback = function(Bool)
        DConfiguration.Misc.GameAutomation.Carry.Keybind = Bool
    end,
})
Tabs.Misc:AddInput("CarryButtonSize", {
    Title = "Auto Carry Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.AutoCarry),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.AutoCarry = num * 0.01
        else
            DConfiguration.Settings.GuiScale.AutoCarry = 0
        end
        DFunctions.UpdateButton("AutoCarryGui", 0.15 + DConfiguration.Settings.GuiScale.AutoCarry, 0.1 + DConfiguration.Settings.GuiScale.AutoCarry)
    end
})
Tabs.Misc:AddParagraph({Title = " ", Content = ""})
wait(Duration)
local Toggle = Tabs.Misc:AddToggle("AutoEmote", {Title = "Auto Emote Dash Button", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("EmoteDashButton", "Start Emote", 0.15 + DConfiguration.Settings.GuiScale.AutoEmoteDash, 0.1 + DConfiguration.Settings.GuiScale.AutoEmoteDash, function(btn)
            btn.Text = "Emoting..."
            DFunctions.AutoEmoteDash()
            task.wait(0.15)
            btn.Text = "Start Emote"
        end)
    else
        DFunctions.DestroyButton("EmoteDashButton")
    end
end)
Tabs.Misc:AddInput("EmoteButtonSize", {
    Title = "Auto Emote Dash Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.AutoEmoteDash),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.AutoEmoteDash = num * 0.01
        else
            DConfiguration.Settings.GuiScale.AutoEmoteDash = 0
        end
        DFunctions.UpdateButton("EmoteDashButton", 0.15 + DConfiguration.Settings.GuiScale.AutoEmoteDash, 0.1 + DConfiguration.Settings.GuiScale.AutoEmoteDash)
    end
})
local Keybind = Tabs.Misc:AddKeybind("KeyEmoteDash", {
    Title = "Keybind to Emote Dash",
    Mode = "Toggle",
    Default = "RightControl",
    Callback = function(Bool)
        DConfiguration.Misc.GameAutomation.Macro.Keybind = Bool
        if Bool then
            DFunctions.AutoEmoteDash()
        end
    end,
})
local Dropdown = Tabs.Misc:AddDropdown("EmoteID", {
    Title = "Select Emote ID",
    Values = EmoteNames,
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.GameAutomation.Macro.SelectedEmote = Value
end)
Tabs.Misc:AddSection("Emote Dash")
local Toggle = Tabs.Misc:AddToggle("AggressiveEmoteDash", {Title = "Aggressive Emote Dash", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.AggressiveEmoteDash.Enabled = State
    DFunctions.AggressiveEmoteDashFunction()
end)
local Dropdown = Tabs.Misc:AddDropdown("AggressiveEmoteType", {
    Title = "Aggressive Emote Type",
    Values = {"Legit", "Blatant"},
    Multi = false,
    Default = 2,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.MovementModification.AggressiveEmoteDash.Type = Value
    DFunctions.AggressiveEmoteDashFunction()
end)
Tabs.Misc:AddInput("EmoteSpeed", {
    Title = "Aggressive Emote Speed",
    Default = "2000",
    Placeholder = "Emote Speed Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.AggressiveEmoteDash.Speed = tonumber(Value) or 2000
        DFunctions.AggressiveEmoteDashFunction()
    end
})
Tabs.Misc:AddInput("CrouchSpeedAgg", {
    Title = "Aggressive Emote Acceleration (Negative Only)",
    Default = "-2",
    Placeholder = "Acceleration Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.AggressiveEmoteDash.Acceleration = tonumber(Value) or -2
        DFunctions.AggressiveEmoteDashFunction()
    end
})
Tabs.Misc:AddSection("Infinity Slide")
local Toggle = Tabs.Misc:AddToggle("InfiniteSlide", {Title = "Infinity Slide", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.SlideModification.Enabled = State
    DFunctions.InfiniteSlideFunction()
end)
local Toggle = Tabs.Misc:AddToggle("InfiniteSlideButton", {Title = "Infinity Slide (Button)", Default = false })
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("InfiniteSlideButton", "Infinity Slide: OFF", 0.15 + DConfiguration.Settings.GuiScale.InfiniteSlide, 0.1 + DConfiguration.Settings.GuiScale.InfiniteSlide, function(btn)
            DConfiguration.Misc.MovementModification.SlideModification.FloatingButton = not DConfiguration.Misc.MovementModification.SlideModification.FloatingButton
            btn.Text = DConfiguration.Misc.MovementModification.SlideModification.FloatingButton and "Infinity Slide: ON" or "Infinity Slide: OFF"
            DConfiguration.Misc.MovementModification.SlideModification.Enabled = DConfiguration.Misc.MovementModification.SlideModification.FloatingButton
        end)
    else
        DFunctions.DestroyButton("InfiniteSlideButton")
    end
end)
Tabs.Misc:AddInput("InfiniteSlideButtonSize", {
    Title = "Infinity Slide Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.InfiniteSlide),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.InfiniteSlide = num * 0.01
        else
            DConfiguration.Settings.GuiScale.InfiniteSlide = 0
        end
        DFunctions.UpdateButton("InfiniteSlideButton", 0.15 + DConfiguration.Settings.GuiScale.InfiniteSlide, 0.1 + DConfiguration.Settings.GuiScale.InfiniteSlide)
    end
})
Tabs.Misc:AddInput("SlideSpeed", {
    Title = "Infinity Slide Speed (Negative Only)",
    Default = "-3",
    Placeholder = "Crouch Speed Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.SlideModification.Acceleration = tonumber(Value) or -3
        DFunctions.InfiniteSlideFunction()
    end
})
Tabs.Misc:AddSection("Gravity & Bounce Modify")
local NormalGravity = game.Workspace.Gravity
local Toggle = Tabs.Misc:AddToggle("GravityToggle", {Title = "Gravity Button", Default = false })
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("GravityGui", "Gravity: OFF", 0.15 + DConfiguration.Settings.GuiScale.Gravity, 0.1 + DConfiguration.Settings.GuiScale.Gravity, function(btn)
            DConfiguration.Misc.MovementModification.Gravity.FloatingButton = not DConfiguration.Misc.MovementModification.Gravity.FloatingButton
            btn.Text = DConfiguration.Misc.MovementModification.Gravity.FloatingButton and "Gravity: ON" or "Gravity: OFF"
            if DConfiguration.Misc.MovementModification.Gravity.FloatingButton then
                task.spawn(function()
                    while DConfiguration.Misc.MovementModification.Gravity.FloatingButton do
                        workspace.Gravity = DConfiguration.Misc.MovementModification.Gravity.Value
                        task.wait(0.1)
                    end
                    workspace.Gravity = NormalGravity
                end)
            else
                workspace.Gravity = NormalGravity
            end
        end)
    else
        DConfiguration.Misc.MovementModification.Gravity.FloatingButton = false
        workspace.Gravity = NormalGravity
        DFunctions.DestroyButton("GravityGui")
    end
end)
Tabs.Misc:AddInput("GravityButtonSize", {
    Title = "Gravity Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.Gravity),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.Gravity = num * 0.01
        else
            DConfiguration.Settings.GuiScale.Gravity = 0
        end
        DFunctions.UpdateButton("GravityGui", 0.15 + DConfiguration.Settings.GuiScale.Gravity, 0.1 + DConfiguration.Settings.GuiScale.Gravity)
    end
})
local Keybind = Tabs.Misc:AddKeybind("GravitKey", {
    Title = "Gravity Keybind",
    Mode = "Toggle",
    Default = "J",
    Callback = function(Bool)
        DConfiguration.Misc.MovementModification.Gravity.Keybind = Bool
        if Bool then
            workspace.Gravity = DConfiguration.Misc.MovementModification.Gravity.Value
        else
            workspace.Gravity = NormalGravity
        end
    end,
})
Tabs.Misc:AddInput("GravityAdjust", {
    Title = "Gravity Adjustment",
    Default = "10",
    Placeholder = " Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.Gravity.Value = tonumber(Value) or 10
    end
})
Tabs.Misc:AddSection("Auto Jump")
local Toggle = Tabs.Misc:AddToggle("AutoJumpToggle", {Title = "AutoJump", Default = false })
Toggle:OnChanged(function(State)
    DFunctions.ToggleAutoJump(State)
end)
local Toggle = Tabs.Misc:AddToggle("AutoJumpHoldJump", {Title = "AutoJump Hold Jump", Default = false })
Toggle:OnChanged(function(State)
    DFunctions.ToggleAutoJumpHold(State)
end)
local Toggle = Tabs.Misc:AddToggle("ShowAutoJumpButton", {Title = "Show AutoJump Button", Default = false })
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("AutoJumpGui", "AutoJump: OFF", 0.15 + DConfiguration.Settings.GuiScale.AutoJump, 0.1 + DConfiguration.Settings.GuiScale.AutoJump, function(btn)
            local on = not DConfiguration.Misc.MovementModification.AutoJump.Enabled
            DFunctions.ToggleAutoJump(on)
            btn.Text = on and "AutoJump: ON" or "AutoJump: OFF"
        end)
    else
        DFunctions.DestroyButton("AutoJumpGui")
    end
end)
local Keybind = Tabs.Misc:AddKeybind("KeybindAutoJump", {
    Title = "Keybind to AutoJump",
    Mode = "Toggle",
    Default = "B",
    Callback = function(Bool)
        DFunctions.ToggleAutoJump(Bool)
    end,
})
Tabs.Misc:AddInput("AutoJumpButtonSize", {
    Title = "AutoJump Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.AutoJump),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.AutoJump = num * 0.01
        else
            DConfiguration.Settings.GuiScale.AutoJump = 0
        end
        DFunctions.UpdateButton("AutoJumpGui", 0.15 + DConfiguration.Settings.GuiScale.AutoJump, 0.1 + DConfiguration.Settings.GuiScale.AutoJump)
    end
})
local Dropdown = Tabs.Misc:AddDropdown("AutoJumpVersion", {
    Title = "AutoJump Mode",
    Values = {"Acceleration", "No Acceleration"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DFunctions.SetAccelerationMethod(Value)
end)
local Dropdown = Tabs.Misc:AddDropdown("JumpType", {
    Title = "AutoJump Mode",
    Values = {"Simulation", "Realistic"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.MovementModification.AutoJump.Settings.JumpType = Value
    DFunctions.AutoJumpFunction()
end)
local Toggle = Tabs.Misc:AddToggle("BackwardAutoJump", {Title = "AutoJump Backwards", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.AutoJump.Settings.Backwards = State
end)
local Toggle = Tabs.Misc:AddToggle("SpiderHop", {Title = "Spider Hop (Beta)", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.AutoJump.Settings.SpiderHop = State
    DFunctions.AutoJumpFunction()
end)
Tabs.Misc:AddInput("AutoJumpAcceleration", {
    Title = "AutoJump Acceleration (Negative Only)",
    Default = "-0.1",
    Placeholder = "-1",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.AutoJump.Settings.Acceleration = tonumber(Value) or -0.1
        DFunctions.AutoJumpFunction()
    end
})
local Toggle = Tabs.Misc:AddToggle("AutoJumpAutoAccelerate", {Title = "Auto Acceleration (Legit)", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.AutoJump.Settings.AutoAcceleration.Enabled = State
    DFunctions.AutoJumpFunction()
end)
Tabs.Misc:AddInput("AutoAccelerationMaxAccel", {
    Title = "Max Acceleration",
    Default = "3",
    Placeholder = "3",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.AutoJump.Settings.AutoAcceleration.MaxAccelerate = tonumber(Value) or 3
        DFunctions.AutoJumpFunction()
    end
})
Tabs.Misc:AddInput("AutoAccelerationMinAccel", {
    Title = "Min Acceleration",
    Default = "-1",
    Placeholder = "-1",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.AutoJump.Settings.AutoAcceleration.MinAccelerate = tonumber(Value) or -1
        DFunctions.AutoJumpFunction()
    end
})
Tabs.Misc:AddInput("AutoAccelerationMaxSpeed", {
    Title = "Max Speed",
    Default = "70",
    Placeholder = "70",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.AutoJump.Settings.AutoAcceleration.MinSpeed = tonumber(Value) or 70
    end
})
Tabs.Misc:AddSection("Auto Jump")
local Toggle = Tabs.Misc:AddToggle("AutoCrouch", {Title = "Auto Crouch (Button)", Default = false })
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("AutoCrouchGui", "Auto Crouch: OFF", 0.15 + DConfiguration.Settings.GuiScale.AutoCrouch, 0.1 + DConfiguration.Settings.GuiScale.AutoCrouch, function(btn)
            DConfiguration.Misc.MovementModification.Crouch.FloatingButton = not DConfiguration.Misc.MovementModification.Crouch.FloatingButton
            btn.Text = DConfiguration.Misc.MovementModification.Crouch.FloatingButton and "Auto Crouch: ON" or "Auto Crouch: OFF"
            if DConfiguration.Misc.MovementModification.Crouch.FloatingButton then
                task.spawn(function()
                    while DConfiguration.Misc.MovementModification.Crouch.FloatingButton do
                        DFunctions.CrouchFunction()
                        task.wait(0.05)
                    end
                end)
            end
        end)
    else
        DConfiguration.Misc.MovementModification.Crouch.FloatingButton = false
        DFunctions.DestroyButton("AutoCrouchGui")
    end
end)
local Keybind = Tabs.Misc:AddKeybind("KeybindCrouch", {
    Title = "Keybind to Auto Crouch (Hold)",
    Mode = "Hold",
    Default = "RightControl",
    Callback = function(Bool)
        DConfiguration.Misc.MovementModification.Crouch.Keybind = Bool
        if Bool then
            task.spawn(function()
                while DConfiguration.Misc.MovementModification.Crouch.Keybind do
                    DFunctions.CrouchFunction()
                    task.wait(0.05)
                end
            end)
        end
    end,
})
Tabs.Misc:AddInput("CrouchButtonSize", {
    Title = "Auto Crouch Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.AutoCrouch),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.AutoCrouch = num * 0.01
        else
            DConfiguration.Settings.GuiScale.AutoCrouch = 0
        end
        DFunctions.UpdateButton("AutoCrouchGui", 0.15 + DConfiguration.Settings.GuiScale.AutoCrouch, 0.1 + DConfiguration.Settings.GuiScale.AutoCrouch)
    end
})
local Dropdown = Tabs.Misc:AddDropdown("CrouchType", {
    Title = "Select Crouch Type",
    Values = {"Rapid", "Ground", "Air", "Normal"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.MovementModification.Crouch.Type = Value
end)
Tabs.Misc:AddInput("CrouchDebounce", {
    Title = "Crouch Speed",
    Default = "0.1",
    Placeholder = "0.1",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.Crouch.debounce = tonumber(Value) or 0.1
    end
})
--==================================================
-- YINYANG EMOTE VISUALS CHANGER (ported to Bolong UI)
--==================================================
Tabs.Visuals:AddSection("Emote Visuals Changer")

local EMOTE_VISUAL_NAMES = {
    "MaracaTime", "Bhop", "GamingTime", "StealthyBox", "TouchGrass", "HeliosChariot",
    "DogParty", "FreshFlop", "CatParty", "TurtleHobble", "DuckyMarch", "Sleepybara",
    "HoveringCrystal", "FlyingFish", "OiiaOiia", "Caffeinated", "Frolic", "Bumblebee",
    "MarchShowcase", "Tank", "Rocket", "QueensAppearance", "RegalWalk", "WingedRoyalSit",
    "BananaDance", "HitTheJackpot", "CuddleBearSit", "CrabRave", "NeptunesThrone", "MountedSeahorse",
    "DynastyDrumming", "FireworkBlast", "ClassicJeep", "RainingTacos", "SkateboardStroll", "TurkeyJockey",
    "WinterOf85", "RockinStride", "Broom", "WindupDance", "SnowmobileCruise", "CampfireDoze",
    "FlyingSleigh", "GhoulishGalleon", "DeadBoneStride", "CyberBroom", "Xylobone", "GhastlyGrimoire",
    "AngelicWings", "HarpRecital", "BobointheBox", "IceFishing", "RudolphMount", "SledDrifting",
    "SnowmanConstruction", "SantaMech", "WinterRide", "WindUpPose", "AvariceLounge", "SerenePerch",
    "BeachChairLounge", "LemonadeStand", "RowBoat", "PoolTime", "SummerDays", "CasualSurfing",
    "ManyFans", "CuerdasDelAlma", "GraveRider", "ScorchedEarth", "SpiritedAway", "HeadlessHorseman",
    "CozyChair", "FrostDrake", "SkiSpree", "WinterMelody", "RockingHorse", "SnowAngel",
    "AprilShower", "GoldRitual", "DreamyCloud", "ValentineComputer", "CoccoonRebirth", "LadybugFlight",
    "LotusSwing", "MegaflyJet", "SnailMail", "HoneyPool", "SummerLowrider", "AstralMantaRay",
    "FrutigerFloatie", "LeapingDolphin", "AquaticDaydreamer", "SubmarineRide", "EncapsulatedBubble",
    "APose", "BoogieDown", "BringItAround", "Catjam", "CompanyMan", "Fazbore",
    "FlashingLights", "Kickback", "LineDance", "LunarParty", "Mashle", "Moonwalk",
    "Nizmoo", "ParkerPride", "PawsClaws", "Popipopi", "Robot", "RushinAround",
    "SeeTinh", "SeriousMarch", "Smile", "SpookyTime", "StarPower", "TPose",
    "Banger", "GalacticBound", "Outlaw", "Writhing", "Popular", "SightlessDance",
    "Addendum", "Aerobics", "Beg", "BoldMarch", "Breakdown", "BumperKart",
    "California", "Caramelldansen", "Carlton", "Catdown", "Clap", "ClubDance",
    "Conga", "Crabby", "CrouchDance", "Distraction", "Epicaricacy", "Facepalm",
    "Flexing", "Freestyle", "Gmod", "GoofyStride", "Gyrating", "Heaventaker",
    "Hired", "Infectious", "LittleJiggy", "Nostalgia", "PBJT", "PonPon",
    "Rambunctious", "RussianDance", "Sit", "Sleep", "Smug", "Stride",
    "SwagWalk", "TexasStyle", "ZenSerenity", "FrightFunk", "PumpItUp", "Reanimated",
    "Thriller", "WerewolfHowl", "ChristmasBoogie", "Marching", "Nutcracker", "HeadlessBaller",
    "ZombieStride", "IrishJig", "ToyTrainRide", "MariachiBand", "AuspiciousWell", "ClamClamor",
    "ClassicDance", "ClassicStride", "FastFoodDelight", "PotionMash", "AstroSlide", "ShellHermit",
    "Boneless", "CatDance", "Gangnam", "Griddy", "LDance", "Macarena",
    "RockefellerStreet", "ShubaDance", "SolarBike", "SolarConqueror", "SolarSlayer", "Twist",
    "Wess", "M3GANDance", "RobotM3GAN",
}

local EMOTE_VISUAL_SOUNDS = {

        ["Addendum"] = 1837749140,
        ["Aerobics"] = 1837749805,
        ["AngelicWings"] = 1844513698,
        ["AprilShower"] = 105686006501847,
        ["AquaticDaydreamer"] = 138099443718294,
        ["AstralMantaRay"] = 1839261895,
        ["AstroSlide"] = 115993151545357,
        ["AuspiciousWell"] = 1840385645,
        ["AvariceLounge"] = 1838878344,
        ["BananaDance"] = 112635285085297,
        ["Banger"] = 98514814631830,
        ["BeachChairLounge"] = 1837052418,
        ["Beg"] = 14364312565,
        ["Bhop"] = 126206938379415,
        ["BobointheBox"] = 1836575943,
        ["BoldMarch"] = 11010019801,
        ["Boneless"] = 1836756328,
        ["BoogieDown"] = 7023785633,
        ["Breakdown"] = 1836128152,
        ["BringItAround"] = 1839850337,
        ["Broom"] = 9042323118,
        ["BumperKart"] = 532147820,
        ["Caffeinated"] = 127278096000378,
        ["California"] = 10810371773,
        ["CampfireDoze"] = 987328482,
        ["Caramelldansen"] = 1837749140,
        ["Carlton"] = 7214835508,
        ["CasualSurfing"] = { 134467231588252, 103716933516581, 1837299834, 1837299907, 1839966537 },
        ["CatDance"] = 73110745626575,
        ["Catdown"] = 1835543937,
        ["Catjam"] = 9048056790,
        ["CatParty"] = 131781481996626,
        ["ChristmasBoogie"] = 1841446876,
        ["ClamClamor"] = 123516194124949,
        ["Clap"] = 9114762437,
        ["ClassicDance"] = 1847444965,
        ["ClassicJeep"] = 4690541424,
        ["ClassicStride"] = 174960816,
        ["ClubDance"] = 9043520892,
        ["CoccoonRebirth"] = 1846899100,
        ["CompanyMan"] = 1843460188,
        ["Conga"] = 1840682740,
        ["CozyChair"] = 1847194445,
        ["Crabby"] = 1835885741,
        ["CrabRave"] = 107342460864353,
        ["CuddleBearSit"] = 103795552668647,
        ["CuerdasDelAlma"] = 1838904664,
        ["CyberBroom"] = 1837252757,
        ["DeadBoneStride"] = 1841036900,
        ["Distraction"] = 5589805449,
        ["DogParty"] = 1843403987,
        ["DreamyCloud"] = 136646292451106,
        ["DuckyMarch"] = 1836660569,
        ["DynastyDrumming"] = { 9040111018, 1845963328, 9046676631, 1839459618 },
        ["EncapsulatedBubble"] = 123150573629544,
        ["Epicaricacy"] = { 9094536756, 3604152746, 2859239852, 6357412245, 3604140002, 9094387306, 9094389373, 6083193447 },
        ["Facepalm"] = 173818824,
        ["FastFoodDelight"] = 96073718689833,
        ["Fazbore"] = 9072301639,
        ["FlashingLights"] = 9043228726,
        ["Flexing"] = 9040328140,
        ["FlyingFish"] = 129978379605810,
        ["FlyingSleigh"] = 9038471642,
        ["Freestyle"] = 1847582197,
        ["FreshFlop"] = 129995441623039,
        ["FrightFunk"] = 1836786439,
        ["Frolic"] = 99291075044992,
        ["FrostDrake"] = { 1847755467, 1847755266 },
        ["FrutigerFloatie"] = 135283078333452,
        ["GalacticBound"] = 120306291221994,
        ["GamingTime"] = 1842892836,
        ["Gangnam"] = 1840043516,
        ["GhastlyGrimoire"] = 1843397281,
        ["GhoulishGalleon"] = 9114228918,
        ["Gmod"] = 1847228473,
        ["GoldRitual"] = 1836476042,
        ["GoofyStride"] = 1839311958,
        ["GraveRider"] = 1846558629,
        ["Griddy"] = 1841590283,
        ["Gyrating"] = 9042930938,
        ["HarpRecital"] = 1836393811,
        ["HeadlessBaller"] = 9042109851,
        ["HeadlessHorseman"] = 132143414909199,
        ["Heaventaker"] = 1839075218,
        ["HeliosChariot"] = 1842437907,
        ["Hired"] = 1837851744,
        ["HitTheJackpot"] = 115869696246143,
        ["HoneyPool"] = 112707360250366,
        ["HoveringCrystal"] = 1837486779,
        ["IceFishing"] = 1847389463,
        ["Infectious"] = 9040145864,
        ["IrishJig"] = 9039477709,
        ["Kickback"] = { 1844694201, 1843272362, 1845741464 },
        ["LadybugFlight"] = 9045962979,
        ["LDance"] = 1846469019,
        ["LeapingDolphin"] = 119628288257106,
        ["LemonadeStand"] = 96055841088274,
        ["LineDance"] = 1848212835,
        ["LittleJiggy"] = 9044433139,
        ["LotusSwing"] = 104525574451549,
        ["LunarParty"] = 1836048649,
        ["M3GANDance"] = 80330439169850,
        ["Macarena"] = 17181642702,
        ["ManyFans"] = 1838890637,
        ["MaracaTime"] = 1840435892,
        ["Marching"] = 1846746381,
        ["MarchShowcase"] = 1846160143,
        ["MariachiBand"] = 134959415719456,
        ["Mashle"] = 1847180351,
        ["MegaflyJet"] = 72710061789341,
        ["Moonwalk"] = 1840177685,
        ["MountedSeahorse"] = 114609192456425,
        ["NeptunesThrone"] = 1848195207,
        ["Nizmoo"] = 15089778847,
        ["Nostalgia"] = 10641626669,
        ["Nutcracker"] = 1846627694,
        ["OiiaOiia"] = 77446822492985,
        ["Outlaw"] = 137299960951971,
        ["ParkerPride"] = 1837664271,
        ["PawsClaws"] = 1842288556,
        ["PBJT"] = 1839118973,
        ["PonPon"] = 1835761714,
        ["PoolTime"] = 1839198233,
        ["Popipopi"] = 9039445224,
        ["Popular"] = 138219559979274,
        ["PotionMash"] = 35930009,
        ["PumpItUp"] = 1839926069,
        ["QueensAppearance"] = 120762187006495,
        ["RainingTacos"] = 142376088,
        ["Rambunctious"] = 1847853099,
        ["Reanimated"] = 1847068926,
        ["RegalWalk"] = 140255571286893,
        ["Robot"] = 1839529551,
        ["RobotM3GAN"] = 1847853099,
        ["Rocket"] = 4454997815,
        ["RockingHorse"] = 1847193822,
        ["RockinStride"] = { 1837843587, 75005539309691, 1846890705, 9045500818, 118793808010485 },
        ["RowBoat"] = 1844645532,
        ["RudolphMount"] = 9046751883,
        ["RushinAround"] = 1845031840,
        ["RussianDance"] = 1840183276,
        ["SantaMech"] = 1837321766,
        ["ScorchedEarth"] = 9048229950,
        ["SeeTinh"] = 115566443106041,
        ["SerenePerch"] = 1839805968,
        ["SeriousMarch"] = 1842186884,
        ["ShellHermit"] = 1839267262,
        ["ShubaDance"] = 77446822492985,
        ["SightlessDance"] = 134374904055454,
        ["Sit"] = 360202811,
        ["SkateboardStroll"] = 22917014,
        ["SkiSpree"] = 1837344499,
        ["SledDrifting"] = 1842713774,
        ["Sleep"] = 8227660256,
        ["Sleepybara"] = 70552340832713,
        ["Smile"] = 79974903670937,
        ["Smug"] = 1835704870,
        ["SnailMail"] = 9045713778,
        ["SnowAngel"] = 88335403434652,
        ["SnowmanConstruction"] = 1845170721,
        ["SnowmobileCruise"] = 2154685557,
        ["SolarBike"] = 97100369595333,
        ["SolarConqueror"] = 1840488369,
        ["SolarSlayer"] = 1839849378,
        ["SpiritedAway"] = 1836918703,
        ["SpookyTime"] = 1841601203,
        ["StarPower"] = 1837696629,
        ["StealthyBox"] = 113603259167759,
        ["Stride"] = 1844684317,
        ["SubmarineRide"] = 136827064604146,
        ["SummerDays"] = 9047869288,
        ["SummerLowrider"] = 125631342429119,
        ["SwagWalk"] = 9042679995,
        ["Tank"] = 4976628801,
        ["TexasStyle"] = 5054944078,
        ["Thriller"] = 11300625654,
        ["TouchGrass"] = 140533669480753,
        ["ToyTrainRide"] = 74121765957356,
        ["TurkeyJockey"] = 1839413554,
        ["TurtleHobble"] = 1844782107,
        ["ValentineComputer"] = 132469746985185,
        ["WerewolfHowl"] = 357647862,
        ["Wess"] = 88655232862426,
        ["WindupDance"] = 1838103156,
        ["WindUpPose"] = 1838103193,
        ["WingedRoyalSit"] = 115975784564662,
        ["WinterMelody"] = { 9044918945, 81307576830692, 9045083983, 88718172625349 },
        ["WinterOf85"] = 120984254901586,
        ["WinterRide"] = 1837309597,
        ["Writhing"] = 1840686367,
        ["Xylobone"] = 1843700415,
        ["ZenSerenity"] = 1847476575,
        ["ZombieStride"] = 1131937949,
    }

local emoteVisualOriginalSounds = {}
local emoteVisualTargetName = ""
local emoteVisualSourceName = EMOTE_VISUAL_NAMES[1] or "MaracaTime"
local emoteVisualStatusControl

local function emoteVisualTrim(value)
    return tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function emoteVisualKey(value)
    return string.lower((tostring(value or ""):gsub("%s+", "")))
end

local function setEmoteVisualStatus(message, success)
    local color = success and Color3.fromRGB(80, 220, 125) or Color3.fromRGB(255, 75, 75)
    local handle = emoteVisualStatusControl
    if not handle then return end
    local real = handle._real

    local function updateObject(obj, depth, keyName)
        if obj == nil or depth > 4 then return end
        local key = tostring(keyName or ""):lower()
        if typeof(obj) == "Instance" then
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if not obj.Name:lower():find("title", 1, true) then
                    obj.Text = message
                    obj.TextColor3 = color
                end
            else
                for _, descendant in ipairs(obj:GetDescendants()) do
                    if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                        if not descendant.Name:lower():find("title", 1, true) then
                            descendant.Text = message
                            descendant.TextColor3 = color
                        end
                    end
                end
            end
            return
        end
        if type(obj) ~= "table" then return end
        for _, methodName in ipairs({"SetText", "SetContent", "SetDesc", "SetDescription", "SetValue"}) do
            if type(obj[methodName]) == "function" then
                pcall(function() obj[methodName](obj, message) end)
            end
        end
        for childKey, child in pairs(obj) do
            local childKeyLower = tostring(childKey):lower()
            if (childKeyLower:find("content", 1, true) or childKeyLower:find("description", 1, true)
                or childKeyLower == "desc" or childKeyLower == "label" or childKeyLower == "text")
                and typeof(child) == "Instance"
                and (child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox")) then
                child.Text = message
                child.TextColor3 = color
            elseif type(child) == "table" or typeof(child) == "Instance" then
                updateObject(child, depth + 1, childKey)
            end
        end
        pcall(function() obj.Content = message end)
        pcall(function() obj.Description = message end)
        pcall(function() obj.Text = message end)
        pcall(function() obj.TextColor3 = color end)
        pcall(function() obj.Color = color end)
    end

    pcall(function() updateObject(real, 0, "status") end)
    handle._statusText = message
    handle._statusColor = color
end

local function findEmoteVisualModule(name)
    local rep = game:GetService("ReplicatedStorage")
    local cleanName = emoteVisualTrim(name)
    if cleanName == "" then return nil end

    -- Match YinYang: prefer Items.Registry entries categorized as Emotes.
    local items = rep:FindFirstChild("Items") or rep:WaitForChild("Items", 5)
    local registryModule = items and (items:FindFirstChild("Registry") or items:WaitForChild("Registry", 5))
    if registryModule and registryModule:IsA("ModuleScript") then
        local ok, registry = pcall(require, registryModule)
        if ok and type(registry) == "table" and type(registry.GetAll) == "function" then
            local okAll, entries = pcall(registry.GetAll)
            if okAll and type(entries) == "table" then
                local exact, loose
                for _, entry in pairs(entries) do
                    local module = type(entry) == "table" and entry.Module or nil
                    local categories = type(entry) == "table" and entry.Categories or nil
                    if module and module:IsA("ModuleScript") and type(categories) == "table" and table.find(categories, "Emotes") then
                        if module.Name == cleanName then exact = exact or module end
                        if emoteVisualKey(module.Name) == emoteVisualKey(cleanName) then loose = loose or module end
                    end
                end
                if exact or loose then return exact or loose end
            end
        end
    end

    local found = rep:FindFirstChild(cleanName, true)
    if found then return found end
    local compactName = cleanName:gsub("%s+", "")
    if compactName ~= cleanName then
        return rep:FindFirstChild(compactName, true)
    end
    return nil
end

local function getEmoteVisualSound(moduleInst)
    if not moduleInst or not moduleInst:IsA("ModuleScript") then return nil end
    if emoteVisualOriginalSounds[moduleInst] ~= nil then
        return emoteVisualOriginalSounds[moduleInst]
    end
    local ok, data = pcall(require, moduleInst)
    if ok and type(data) == "table" and type(data.EmoteInfo) == "table" and data.EmoteInfo.Sound ~= nil then
        return data.EmoteInfo.Sound
    end
    return EMOTE_VISUAL_SOUNDS[moduleInst.Name]
end

local function setEmoteVisualSound(moduleInst, rawSound)
    if not moduleInst or not moduleInst:IsA("ModuleScript") or rawSound == nil then return false end
    local ok, data = pcall(require, moduleInst)
    if not ok or type(data) ~= "table" or type(data.EmoteInfo) ~= "table" then return false end
    if emoteVisualOriginalSounds[moduleInst] == nil then
        emoteVisualOriginalSounds[moduleInst] = data.EmoteInfo.Sound
    end
    data.EmoteInfo.Sound = rawSound
    return true
end

local function applyEmoteVisualChange()
    local targetName = emoteVisualTrim(emoteVisualTargetName)
    local sourceName = emoteVisualTrim(emoteVisualSourceName)
    if targetName == "" or sourceName == "" then
        setEmoteVisualStatus("Failed: enter Current Emote and select an emote.", false)
        return
    end

    local targetModule = findEmoteVisualModule(targetName)
    local sourceModule = findEmoteVisualModule(sourceName)
    if not targetModule then
        setEmoteVisualStatus("Failed: Current Emote not found — " .. targetName, false)
        return
    end
    if not sourceModule then
        setEmoteVisualStatus("Failed: selected emote not found — " .. sourceName, false)
        return
    end
    if targetModule == sourceModule then
        setEmoteVisualStatus("Failed: choose two different emotes.", false)
        return
    end

    local clones = {}
    for _, item in ipairs(sourceModule:GetChildren()) do
        local ok, clone = pcall(function() return item:Clone() end)
        if not ok or not clone then
            for _, pending in ipairs(clones) do pcall(function() pending:Destroy() end) end
            setEmoteVisualStatus("Failed: could not prepare the selected emote.", false)
            return
        end
        clones[#clones + 1] = clone
    end

    local okApply, applyError = pcall(function()
        for _, item in ipairs(targetModule:GetChildren()) do item:Destroy() end
        for _, clone in ipairs(clones) do clone.Parent = targetModule end
        if targetModule:IsA("ModuleScript") and sourceModule:IsA("ModuleScript") then
            local rawSound = getEmoteVisualSound(sourceModule)
            if rawSound ~= nil then setEmoteVisualSound(targetModule, rawSound) end
        end
    end)
    if not okApply then
        for _, clone in ipairs(clones) do
            if clone and clone.Parent == nil then pcall(function() clone:Destroy() end) end
        end
        setEmoteVisualStatus("Failed: " .. tostring(applyError), false)
        return
    end

    setEmoteVisualStatus("Applied: " .. targetName .. " ← " .. sourceName, true)
end

Tabs.Visuals:AddInput("YYCurrentEmote", {
    Title = "Current Emote",
    Default = "",
    Placeholder = "Enter the current emote name (e.g. Popular)",
    Finished = true,
    Callback = function(value)
        emoteVisualTargetName = tostring(value or "")
    end
})

local emoteVisualDropdown = Tabs.Visuals:AddDropdown("YYSelectEmote", {
    Title = "Select Emote",
    Values = EMOTE_VISUAL_NAMES,
    Multi = false,
    Default = 1
})
emoteVisualDropdown:OnChanged(function(value)
    if type(value) == "number" then
        emoteVisualSourceName = EMOTE_VISUAL_NAMES[value] or EMOTE_VISUAL_NAMES[1]
    else
        emoteVisualSourceName = tostring(value or EMOTE_VISUAL_NAMES[1])
    end
end)

Tabs.Visuals:AddButton({
    Title = "Apply",
    Description = "Apply the selected emote as the visual for Current Emote.",
    Callback = applyEmoteVisualChange
})

emoteVisualStatusControl = Tabs.Visuals:AddParagraph({
    Title = "Status",
    Content = "Ready — enter Current Emote and select a visual emote.",
    Color = Color3.fromRGB(170, 170, 170),
    TextColor3 = Color3.fromRGB(170, 170, 170)
})

Tabs.Settings:AddParagraph({
    Title = "Configuration",
    Content = " "
})
pcall(function() if type(Window.SelectTab) == "function" then Window:SelectTab(1) end end)
local ExtensionLoaded = false
Tabs.Extension:AddButton({
    Title = "Load Extension",
    Description = "Not all the scripts here are ours. Some are recommendations from this tab.",
    Callback = function()
        BolongCompat:Notify({
            Title = "WARNING",
            Content = "Extension loading is currently unavailable.",
            Duration = 3
        })
    end
})
local tadaSound = Instance.new("Sound")
tadaSound.SoundId = "rbxassetid://131653558869295"
tadaSound.Parent = game:GetService("SoundService")
tadaSound.Volume = 6
tadaSound:Play()
tadaSound.Ended:Connect(function() tadaSound:Destroy() end)

