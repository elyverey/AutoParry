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
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

if _G.EvadeOverhaulAutoFarmRunning then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Auto Farm is already running",
            Text = "",
            Duration = 3
        })
    end)
    return
end
_G.EvadeOverhaulAutoFarmRunning = true

local Window = Chloex:Window({
    Title = "BOLONG-HUB",
    Image = "84034353458936",
    Footer = "Evade Overhaul",
    Author = "Discord.gg/pWpgqVGxNK",
    Color = Color3.fromRGB(255, 255, 255),
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
    DiscordText = "Update & support.",
    DiscordDesc = "Evade Overhaul — Auto Farm only."
})

local AutoFarmTab = Window:AddTab({Name = "Auto Farm", Icon = "zap"})
local ConfigManagerTab = Window:AddTab({Name = "Configs", Icon = "folder"})
local ConfigSection = ConfigManagerTab:AddSection("Configuration", true)
if ConfigSection and type(ConfigSection.AddConfig) == "function" then
    pcall(function() ConfigSection:AddConfig() end)
end

local AutoFarmSection = AutoFarmTab:AddSection("Auto Farm")
local TokenFarm = {
    Enabled = false,
    Target = nil,
    LastFire = 0,
    Delay = 2,
    Offset = Vector3.new(0, -8, 0),
    Connection = nil
}
local TicketFarmEnabled = false
local ObjectiveFarmEnabled = false
local AFKFarmEnabled = false
local FarmPart
local TicketRunId = 0
local ObjectiveRunId = 0
local AFKRunId = 0

local function isValidTokenTarget(model)
    if not model or not model.Parent or not model:IsA("Model") then return false end
    if model.Parent.Name ~= "Players" then return false end
    if model == LocalPlayer.Character or model.Name == LocalPlayer.Name or model.Name == tostring(LocalPlayer.UserId) then
        return false
    end
    local nameAttribute = model:GetAttribute("Name")
    local tagAttribute = model:GetAttribute("Tag")
    local userId = model:GetAttribute("UserId") or model:GetAttribute("PlayerUserId")
    if nameAttribute == LocalPlayer.Name or nameAttribute == LocalPlayer.DisplayName then return false end
    if tagAttribute == LocalPlayer.Name or tagAttribute == LocalPlayer.DisplayName then return false end
    if typeof(userId) == "number" and userId == LocalPlayer.UserId then return false end
    return model:FindFirstChild("HumanoidRootPart") ~= nil and tagAttribute ~= nil
end

local function pickTokenTarget()
    local folder = workspace:FindFirstChild("Players")
    if not folder then return nil end
    local candidates = {}
    for _, model in ipairs(folder:GetChildren()) do
        if isValidTokenTarget(model) then
            table.insert(candidates, model)
        end
    end
    if #candidates == 0 then return nil end
    return candidates[math.random(1, #candidates)]
end

local function stopTokenFarm()
    TokenFarm.Enabled = false
    if TokenFarm.Connection then
        TokenFarm.Connection:Disconnect()
        TokenFarm.Connection = nil
    end
    TokenFarm.Target = nil
    TokenFarm.LastFire = 0
end

local function startTokenFarm()
    if TokenFarm.Connection then return end
    TokenFarm.Enabled = true
    TokenFarm.Connection = RunService.Heartbeat:Connect(function()
        if not TokenFarm.Enabled then return end
        local nowClock = os.clock()
        if TokenFarm._lastUpdate and nowClock - TokenFarm._lastUpdate < 0.05 then return end
        TokenFarm._lastUpdate = nowClock
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if not isValidTokenTarget(TokenFarm.Target) then
            TokenFarm.Target = pickTokenTarget()
        end
        local target = TokenFarm.Target
        local targetRoot = target and target:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end
        root.CFrame = targetRoot.CFrame + TokenFarm.Offset
        local tag = target:GetAttribute("Tag")
        if not tag then return end
        if tick() - TokenFarm.LastFire >= (TokenFarm.Delay or 2) then
            TokenFarm.LastFire = tick()
            pcall(function()
                local events = ReplicatedStorage:FindFirstChild("Events")
                local interact = events and events:FindFirstChild("Interact")
                if interact then
                    interact:FireServer("Revive", tag)
                    interact:FireServer("Revive", tag, true)
                end
            end)
        end
    end)
end

local function afkFarm()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if not FarmPart or not FarmPart.Parent then
        FarmPart = Instance.new("Part")
        FarmPart.Name = "AFKFarmPad"
        FarmPart.Size = Vector3.new(10, 1, 10)
        FarmPart.Anchored = true
        FarmPart.CanCollide = true
        FarmPart.CFrame = CFrame.new(1131, 1015, 2222)
        FarmPart.Parent = workspace
    end
    root.CFrame = FarmPart.CFrame + Vector3.new(0, 3, 0)
end

local function farmTickets()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local effects = workspace:FindFirstChild("Effects")
    local tickets = effects and effects:FindFirstChild("Tickets")
    if tickets then
        for _, part in ipairs(tickets:GetDescendants()) do
            if part:IsA("BasePart") and part.Name == "HumanoidRootPart" then
                root.CFrame = CFrame.new(part.Position)
                return
            end
        end
    end
    afkFarm()
end

local function farmObjectives()
    local map = workspace:FindFirstChild("Map")
    if not map then
        local gameFolder = workspace:FindFirstChild("Game")
        map = gameFolder and gameFolder:FindFirstChild("Map")
    end
    if not map then return end
    local parts = map:FindFirstChild("Parts") or map:FindFirstChild("MapLogic")
    local objectivesFolder = parts and parts:FindFirstChild("Objectives")
    if not objectivesFolder then return end
    local events = ReplicatedStorage:FindFirstChild("Events")
    local interact = events and events:FindFirstChild("Interact")
    if not interact then return end
    for _, objective in ipairs(objectivesFolder:GetChildren()) do
        if objective:GetAttribute("Completed") ~= true and objective:FindFirstChild("WhenActivated") then
            local tag = objective:GetAttribute("Tag")
            if tag then
                pcall(function() interact:FireServer("Dynamic", tag) end)
                task.wait(0.2)
            end
        end
    end
end

AutoFarmSection:AddToggle("AutoFarmMoney", {
    Title = "Auto Farm Token",
    Description = "Automatically follows a valid target and attempts token farming.",
    Default = false,
    Callback = function(state)
        if state then startTokenFarm() else stopTokenFarm() end
    end
})

AutoFarmSection:AddInput("TokenFarmOffset", {
    Title = "Token Farm Offset",
    Default = "0 -8 0",
    Placeholder = "X Y Z",
    Numeric = false,
    Finished = false,
    Callback = function(value)
        local x, y, z = tostring(value):match("^%s*([%-%d%.]+)%s+([%-%d%.]+)%s+([%-%d%.]+)%s*$")
        if x and y and z then
            TokenFarm.Offset = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
        end
    end
})

AutoFarmSection:AddSlider("TokenFarmDelay", {
    Title = "Token Farm Delay",
    Description = "Delay between interaction attempts, in seconds.",
    Default = 2,
    Min = 1,
    Max = 4,
    Rounding = 0,
    Callback = function(value)
        TokenFarm.Delay = value
    end
})

AutoFarmSection:AddToggle("AutoFarmTickets", {
    Title = "Auto Farm Tickets",
    Default = false,
    Callback = function(state)
        TicketFarmEnabled = state
        TicketRunId += 1
        local runId = TicketRunId
        if state then
            task.spawn(function()
                while TicketFarmEnabled and runId == TicketRunId do
                    task.wait(1)
                    if TicketFarmEnabled and runId == TicketRunId then farmTickets() end
                end
            end)
        end
    end
})

AutoFarmSection:AddToggle("AutoCompleteObjectives", {
    Title = "Auto Complete Objective",
    Default = false,
    Callback = function(state)
        ObjectiveFarmEnabled = state
        ObjectiveRunId += 1
        local runId = ObjectiveRunId
        if state then
            task.spawn(function()
                while ObjectiveFarmEnabled and runId == ObjectiveRunId do
                    task.wait(3)
                    if ObjectiveFarmEnabled and runId == ObjectiveRunId then farmObjectives() end
                end
            end)
        end
    end
})

AutoFarmSection:AddToggle("AFKFarm", {
    Title = "AFK Farm",
    Default = false,
    Callback = function(state)
        AFKFarmEnabled = state
        AFKRunId += 1
        local runId = AFKRunId
        if state then
            task.spawn(function()
                while AFKFarmEnabled and runId == AFKRunId do
                    task.wait(1)
                    if AFKFarmEnabled and runId == AFKRunId then afkFarm() end
                end
            end)
        end
    end
})

-- Cleanup active connections when the script is explicitly stopped.
_G.EvadeOverhaulAutoFarmStop = function()
    stopTokenFarm()
    TicketFarmEnabled = false
    ObjectiveFarmEnabled = false
    AFKFarmEnabled = false
    TicketRunId += 1
    ObjectiveRunId += 1
    AFKRunId += 1
    if FarmPart then
        FarmPart:Destroy()
        FarmPart = nil
    end
    _G.EvadeOverhaulAutoFarmRunning = nil
end
