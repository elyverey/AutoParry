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

local VERSION = "Farm"
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
    Footer = "Evade Overhaul",
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
    DiscordText = "Evade Overhaul - Auto Farm",
    DiscordDesc = "Auto Farm controls and settings.",
    CardsWidget = {{catwidget = "rbxassetid://117486345000318"}}
})

local AutoFarmTab = Window:AddTab({Name = "Auto Farm", Icon = "zap"})
local ConfigManagerTab = Window:AddTab({Name = "Configs", Icon = "folder"})
local ConfigSection = ConfigManagerTab:AddSection("Configuration", true)
if ConfigSection and type(ConfigSection.AddConfig) == "function" then
    pcall(function() ConfigSection:AddConfig() end)
end

-- All retained sections are explicitly routed to the single Auto Farm tab.
local function getSectionRoute(sourceName, sectionTitle)
    return AutoFarmTab
end

-- Compatibility adapter used only by the Auto Farm controls.
local Options = {}
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

-- Pre-create only sections used by Auto Farm.
registerSection(AutoFarmTab, "Auto Farm")
registerSection(AutoFarmTab, "Remove Functions [In Test]")
registerSection(AutoFarmTab, "Purchase Automations")
registerSection(AutoFarmTab, "VIP Automations")

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
    AutoFarm = makeCompatTab("AutoFarm", AutoFarmTab)
}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local ServerStateRegistryService
local ItemRegistry
pcall(function()
    ServerStateRegistryService = require(ReplicatedStorage:WaitForChild("Services"):WaitForChild("Data"):WaitForChild("ServerStateRegistryService"))
end)
pcall(function()
    ItemRegistry = require(ReplicatedStorage:WaitForChild("Items"):WaitForChild("Registry"))
end)

local DFunctions = {}
local DConfiguration = {
    Removals = {InvisibleWalls = false, ReducingRewards = false},
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
            TimerInput = "180",
            TimerRoundState = 1,
            LastMapSet = 0,
            LastSRSet = 0,
            LastTimerSet = 0,
            LastVotingFire = 0,
            MapConn = nil,
            SRConn = nil,
            TimerConn = nil,
            VIPConn = nil,
        },
        PurchaseAutomations = {
            Enabled = false,
            Selected = "Cola",
            Amount = 1,
            Connection = nil,
            LastBuy = 0,
        },
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
}

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
    local lastTokenFarmUpdate = 0
    TF.Connection = RunService.Heartbeat:Connect(function()
        if not TF.Enabled then return end
        local currentClock = os.clock()
        if currentClock - lastTokenFarmUpdate < 0.05 then return end
        lastTokenFarmUpdate = currentClock
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

function DFunctions.AdminCommand(commandString)
    local cmd = ReplicatedStorage:FindFirstChild("Events")
        and ReplicatedStorage.Events:FindFirstChild("Admin")
        and ReplicatedStorage.Events.Admin:FindFirstChild("Command")
    if not cmd then return end
    pcall(function()
        cmd:FireServer(commandString)
    end)
end

function DFunctions.GetItemRegistry()
    if ItemRegistry then return ItemRegistry end
    return ItemRegistry
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

local ShopItemNames = DFunctions.GetMultipleShopItems()

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
Tabs.AutoFarm:AddSection("Remove Functions [In Test]")
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
    local lastVoteAttempt = 0
    AutoVote.Connections.Map = RunService.Heartbeat:Connect(function()
        local now = os.clock()
        if now - lastVoteAttempt < 0.35 then return end
        lastVoteAttempt = now
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
    local lastVoteAttempt = 0
    AutoVote.Connections.Mode = RunService.Heartbeat:Connect(function()
        local now = os.clock()
        if now - lastVoteAttempt < 0.35 then return end
        lastVoteAttempt = now
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
local vipAutomationLastCheck = 0
DConfiguration.AutoFarm.VIPAutomations.VIPConn = RunService.Heartbeat:Connect(function()
    local now = os.clock()
    if now - vipAutomationLastCheck < 0.25 then return end
    vipAutomationLastCheck = now
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
