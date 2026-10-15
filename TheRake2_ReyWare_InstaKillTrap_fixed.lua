local Players=game:GetService("Players")
local CollectionService=game:GetService("CollectionService")
local Workspace=game:GetService("Workspace")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local HttpService=game:GetService("HttpService")
local RunService=game:GetService("RunService")
local Lighting=game:GetService("Lighting")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local ContextActionService=game:GetService("ContextActionService")
local CoreGui=game:GetService("CoreGui")
local GuiService=game:GetService("GuiService")
local TeleportService=game:GetService("TeleportService")
local Debris=game:GetService("Debris")
local SoundService=game:GetService("SoundService")
local LocalPlayer=Players.LocalPlayer

-- Play the requested sound once when the script starts.
task.spawn(function()
    local startupSound = Instance.new("Sound")
    startupSound.Name = "ScriptStartupSound"
    startupSound.SoundId = "rbxassetid://82325434805332"
    startupSound.Volume = 0.7
    startupSound.Looped = false
    startupSound.Parent = SoundService

    local ok = pcall(function()
        startupSound:Play()
    end)

    if ok then
        startupSound.Ended:Connect(function()
            startupSound:Destroy()
        end)
        Debris:AddItem(startupSound, 30)
    else
        startupSound:Destroy()
    end
end)
local Camera=Workspace.CurrentCamera
local Mouse=LocalPlayer and LocalPlayer:GetMouse() or nil
local Chloex=loadstring(game:HttpGet("https://raw.githubusercontent.com/RillBoys/bolong.catui/refs/heads/main/b0lngUi.lua"))()
local VERSION="v1.0.0"
local ACCENT_COLOR=Color3.fromRGB(255,255,255)
local Window=Chloex:Window({
Title="BOLONG-HUB",
Image="84034353458936",
Footer="The Rake Remastered",
Author="Discord.gg/pWpgqVGxNK",
Color=ACCENT_COLOR,
Version=1,
Search=true,
Folder="BolongHub"
})
Window:InfoTab({
Name="Info",
Icon="info",
SectionTitle="Information",
Banner="79662603577585",
BannerAspectRatio=16/5,
Version=VERSION,
DiscordLink="https://discord.gg/pWpgqVGxNK",
DiscordName="Community BolongHub",
DiscordText="Gabung untuk update & support.",
DiscordDesc="Made by 11rill — features: Killer & Survivor Hitbox/ESP, Auto Aim, Auto Generator, Killer Warn, Camera Veil, and many more.",
CardsWidget={{catwidget="rbxassetid://117486345000318"}}
})
local MainTab=Window:AddTab({Name="Main",Icon="house"})
local ScrapsTab=Window:AddTab({Name="Scraps",Icon="package"})
local MovementTab=Window:AddTab({Name="Movement",Icon="footprints"})
local CombatTab=Window:AddTab({Name="Combat",Icon="swords"})
local RakeTab=Window:AddTab({Name="The Rake",Icon="shield"})
local SurvivorTab=Window:AddTab({Name="Survivor",Icon="heart"})
local VisualsTab=Window:AddTab({Name="Visuals",Icon="eye"})
local MiscTab=Window:AddTab({Name="Misc",Icon="settings"})
local ConfigManagerTab=Window:AddTab({Name="Configs",Icon="folder"})
local ConfigSection=ConfigManagerTab:AddSection("Configuration")
ConfigSection:AddConfig()

local TIMER_POWER = {enabled = false}
local FLASHLIGHT_MODIFY = {}
local MainSection=MainTab:AddSection("Game Utilities")
TIMER_POWER.section = MainTab:AddSection("Timer & Power")
local MainProtectionSection=MainTab:AddSection("Player Protection")
local MainAutoGrabFlaregunSection=MainTab:AddSection("Auto Grab Flaregun")
local ScrapsFarmSection=ScrapsTab:AddSection("Auto Farm Scrap")
local ScrapsBringSection=ScrapsTab:AddSection("Collect All Scraps")
local MovementStaminaSection=MovementTab:AddSection("Infinite Stamina")
local MovementSection=MovementTab:AddSection("Player Movement")
local CombatStunSection=CombatTab:AddSection("Stun Stick Aura")
local CombatInstaSection=CombatTab:AddSection("Insta Kill (Trap)")
local RakeHideSection=RakeTab:AddSection("Anti Rake/Hide under floor")
local RakeSafeSection=RakeTab:AddSection("Safe Zone")
local SurvivorFirstAidSection=SurvivorTab:AddSection("FirstAid & Heal")
local SurvivorRepairSection=SurvivorTab:AddSection("Repair &Auto Restore")
local SurvivorPromptSection=SurvivorTab:AddSection("Prompt & Bypass")
local VisualESPSection=VisualsTab:AddSection("The Rake ESP")
local VisualPlayerESPSection=VisualsTab:AddSection("Player ESP")
local VisualObjectESPSection=VisualsTab:AddSection("Object ESP")
local VisualTrapESPSection=VisualsTab:AddSection("ESP Traps")
local VisualLocationsSection=VisualsTab:AddSection("Locations")
local VisualLightingSection=VisualsTab:AddSection("Ambient & Fullbright")
local VisualTrackingSection=VisualsTab:AddSection("Rake Tracking")
local MiscSection=MiscTab:AddSection("Utilities")
FLASHLIGHT_MODIFY.section = MiscTab:AddSection("Flashlight modify")
local MiscCameraSection=MiscTab:AddSection("Camera")
local MiscJumpscareSection=MiscTab:AddSection("No JumpScare Cutscreen")

local function notifyFeature(title, content)
    local sent = pcall(function()
        Chloex:MakeNotify({
            Title = title or "BOLONG-HUB",
            Description = "Info",
            Content = content or "",
            Color = ACCENT_COLOR,
            Time = 0.4,
            Delay = 3
        })
    end)
    if not sent then
        pcall(function() warn("[TheRake2] " .. tostring(title) .. ": " .. tostring(content)) end)
    end
end

local function addRakeToggle(section, title, callback, defaultValue)
    -- Force every ON/OFF toggle to start disabled; numeric sliders remain numeric settings.
    local initial = false
    local config = {
        Name = title,
        Title = title,
        Default = initial,
        DefaultValue = initial,
        Value = initial,
        CurrentValue = initial,
        Callback = function(value)
            if typeof(value) ~= "boolean" then value = not not value end
            local ok, err = pcall(callback, value)
            if not ok then notifyFeature(title, tostring(err)) end
        end
    }
    local ok = pcall(function() section:AddToggle(config) end)
    if not ok then
        ok = pcall(function() section:AddToggle(title, initial, config.Callback) end)
    end
    if not ok then
        pcall(function() section:AddSwitch(config) end)
    end
end

local addRakeButton

local function addRakeSlider(section, title, minValue, maxValue, defaultValue, increment, callback)
    local config = {
        Name = title,
        Title = title,
        Min = minValue,
        MinValue = minValue,
        Max = maxValue,
        MaxValue = maxValue,
        Range = {minValue, maxValue},
        Default = defaultValue,
        DefaultValue = defaultValue,
        Value = defaultValue,
        CurrentValue = defaultValue,
        Increment = increment or 1,
        Step = increment or 1,
        Callback = function(value)
            local ok, err = pcall(callback, tonumber(value) or defaultValue)
            if not ok then notifyFeature(title, tostring(err)) end
        end
    }
    local ok = pcall(function() section:AddSlider(config) end)
    if not ok then pcall(function() section:AddSlider(title, minValue, maxValue, defaultValue, config.Callback) end) end
end

local function addRakeDropdown(section, title, options, defaultValue, callback)
    local config = {
        Name = title,
        Title = title,
        Options = options,
        Values = options,
        Default = defaultValue,
        DefaultValue = defaultValue,
        Value = defaultValue,
        CurrentValue = defaultValue,
        Callback = function(value)
            local ok, err = pcall(callback, value)
            if not ok then notifyFeature(title, tostring(err)) end
        end
    }
    local ok = pcall(function() section:AddDropdown(config) end)
    if not ok then ok = pcall(function() section:AddSelect(config) end) end
    if not ok then
        for _, option in ipairs(options) do
            addRakeButton(section, title .. " - " .. option, function() callback(option) end)
        end
    end
end

addRakeButton = function(section, title, callback)
    local config = {
        Name = title,
        Title = title,
        Callback = function()
            local ok, err = pcall(callback)
            if not ok then notifyFeature(title, tostring(err)) end
        end
    }
    local ok = pcall(function() section:AddButton(config) end)
    if not ok then pcall(function() section:AddButton(title, config.Callback) end) end
end

local function getCharacter()
    return LocalPlayer and LocalPlayer.Character
end

local function getHumanoid()
    local character = getCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function getRootPart()
    local character = getCharacter()
    return character and character:FindFirstChild("HumanoidRootPart")
end

local getExecutorFunction

do
local autoFirstAidSelfEnabled = false
local autoFirstAidPlayersEnabled = false
local firstAidAutoEquipEnabled = false
local selfHealBelow = 55
local playerHealBelow = 60
local lastFirstAidTime = 0

local function findToolByName(fragment)
    fragment = tostring(fragment or ""):lower()
    local character = getCharacter()
    local backpack = LocalPlayer and LocalPlayer:FindFirstChildOfClass("Backpack")
    for _, root in pairs({character, backpack}) do
        if root then
            for _, child in ipairs(root:GetChildren()) do
                if child:IsA("Tool") and child.Name:lower():find(fragment, 1, true) then
                    return child
                end
            end
        end
    end
    return nil
end

local function firstAidReady(tool)
    if not tool or not tool.Parent then return false end
    local done = tool:FindFirstChild("Done")
    local doing = tool:FindFirstChild("Doing")
    local uses = tool:FindFirstChild("Uses")
    local doneValue, doingValue, usesValue
    pcall(function() doneValue = done and done.Value end)
    pcall(function() doingValue = doing and doing.Value end)
    pcall(function() usesValue = uses and uses.Value end)
    if doneValue == true or doingValue == true then return false end
    if tonumber(usesValue) and tonumber(usesValue) <= 0 then return false end
    return true
end

local function useFirstAid(target)
    local tool = findToolByName("firstaid") or findToolByName("first aid")
    if not firstAidReady(tool) then return false end
    local character = getCharacter()
    if not (character and tool) then return false end
    if tool.Parent ~= character and firstAidAutoEquipEnabled then
        local humanoid = getHumanoid()
        if humanoid then
            pcall(function() humanoid:EquipTool(tool) end)
            task.wait(0.12)
        end
    end
    local remote = tool:FindFirstChild("RemoteEvent")
    if remote and remote:IsA("RemoteEvent") then
        if target then
            return pcall(function() remote:FireServer("HealPlrStart", target) end)
        end
        return pcall(function() remote:FireServer("YourselfStart") end)
    end
    if not target and tool.Parent == character then
        return pcall(function() tool:Activate() end)
    end
    return false
end

local function getHealTarget()
    local root = getRootPart()
    local character = getCharacter()
    if not root or not character then return nil end
    local best, bestDistance = nil, 5
    for _, player in ipairs(Players:GetPlayers()) do
        local targetCharacter = player.Character
        if targetCharacter and targetCharacter ~= character then
            local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
            local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
            if humanoid and targetRoot and humanoid.Health > 0 and humanoid.MaxHealth > 0 and humanoid.Health < humanoid.MaxHealth then
                local percent = humanoid.Health / humanoid.MaxHealth * 100
                local distance = (root.Position - targetRoot.Position).Magnitude
                if percent <= playerHealBelow and distance < bestDistance then
                    best, bestDistance = targetCharacter, distance
                end
            end
        end
    end
    return best
end

addRakeToggle(SurvivorFirstAidSection, "Auto FirstAid Self", function(value)
    autoFirstAidSelfEnabled = value
end)
addRakeSlider(SurvivorFirstAidSection, "Self Heal Below %", 1, 100, 55, 1, function(value)
    selfHealBelow = math.clamp(math.floor(value), 1, 100)
end)
addRakeToggle(SurvivorFirstAidSection, "Auto FirstAid Players", function(value)
    autoFirstAidPlayersEnabled = value
end)
addRakeSlider(SurvivorFirstAidSection, "Player Heal Below %", 1, 100, 60, 1, function(value)
    playerHealBelow = math.clamp(math.floor(value), 1, 100)
end)
addRakeToggle(SurvivorFirstAidSection, "FirstAid Auto Equip", function(value)
    firstAidAutoEquipEnabled = value
end, false)

task.spawn(function()
    while true do
        task.wait(0.3)
        if autoFirstAidSelfEnabled or autoFirstAidPlayersEnabled then
            if time() - lastFirstAidTime >= 7.5 then
                local humanoid = getHumanoid()
                if humanoid and humanoid.Health > 0 and humanoid.MaxHealth > 0 then
                    local selfPercent = humanoid.Health / humanoid.MaxHealth * 100
                    local used = false
                    if autoFirstAidSelfEnabled and humanoid.Health < humanoid.MaxHealth and selfPercent <= selfHealBelow then
                        used = useFirstAid(nil)
                    end
                    if not used and autoFirstAidPlayersEnabled then
                        local target = getHealTarget()
                        if target then used = useFirstAid(target) end
                    end
                    if used then lastFirstAidTime = time() end
                end
            end
        end
    end
end)

local useToolboxForPower = false
local autoRestorePowerEnabled = false
local powerRepairBusy = false

local function findDeep(root, name)
    if not root then return nil end
    local direct = root:FindFirstChild(name)
    if direct then return direct end
    return root:FindFirstChild(name, true)
end

local function repairPowerStation()
    if powerRepairBusy then return false, "busy" end
    local map = Workspace:FindFirstChild("Map")
    local powerStation = map and map:FindFirstChild("PowerStation")
    local station = powerStation and powerStation:FindFirstChild("StationFolder")
    local guiPart = station and station:FindFirstChild("StationGUIPart")
    local prompt = guiPart and guiPart:FindFirstChildWhichIsA("ProximityPrompt", true)
    local remote = station and station:FindFirstChild("RemoteEvent")
    local progress = station and station:FindFirstChild("Progress")
    local stationPower = ReplicatedStorage:FindFirstChild("StationPower")
    local root = getRootPart()
    local humanoid = getHumanoid()
    local character = getCharacter()
    if not (station and guiPart and prompt and remote and root and humanoid and character) then
        return false, "missing"
    end
    if stationPower and stationPower.Value == true then return true, "powered" end
    powerRepairBusy = true
    local oldCFrame = root.CFrame
    local oldAnchored = root.Anchored
    local ok, result = pcall(function()
        local useToolbox = false
        if useToolboxForPower then
            local toolbox = findToolByName("toolbox")
            if toolbox then
                pcall(function() humanoid:EquipTool(toolbox) end)
                task.wait(0.15)
                useToolbox = toolbox.Parent == character
            end
        end
        root.CFrame = guiPart.CFrame * CFrame.new(0, 0, 3)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        task.wait(0.2)
        root.Anchored = true
        remote:FireServer("StationStart", useToolbox)
        local activateTime = tonumber(prompt:GetAttribute("ActivateTime")) or 30
        local deadline = time() + math.max(activateTime + 8, 35)
        local success = false
        while root.Parent and time() < deadline do
            if stationPower and stationPower.Value == true then success = true; break end
            if progress and tonumber(progress.Value) and progress.Value >= 100 then success = true; break end
            task.wait(0.25)
        end
        if not success then pcall(function() remote:FireServer("StationCancel") end) end
        return success
    end)
    pcall(function()
        root.Anchored = oldAnchored
        root.CFrame = oldCFrame
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
    powerRepairBusy = false
    return ok and result == true, ok and (result == true and "done" or "timeout") or tostring(result)
end

local function startAutoRestorePower()
    if not autoRestorePowerEnabled or powerRepairBusy then return end
    local stationPower = ReplicatedStorage:FindFirstChild("StationPower")
    if stationPower and stationPower.Value == true then return end
    task.spawn(function() repairPowerStation() end)
end

addRakeToggle(SurvivorRepairSection, "Auto Restore Power", function(value)
    autoRestorePowerEnabled = value
    if value then startAutoRestorePower() end
end)
addRakeToggle(SurvivorRepairSection, "Use Toolbox For Restore Power", function(value)
    useToolboxForPower = value
end, true)
addRakeButton(SurvivorRepairSection, "Restore Power Now", function()
    task.spawn(function()
        local ok, reason = repairPowerStation()
        if ok and reason == "powered" then
            notifyFeature("Power Station", "Power is already online.")
        elseif ok then
            notifyFeature("Power Station", "Power restoration completed.")
        else
            notifyFeature("Power Station", "Power restoration failed: " .. tostring(reason))
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(1.25)
        if autoRestorePowerEnabled then startAutoRestorePower() end
    end
end)

local promptBypassEnabled = false
local knownPromptBypassEnabled = false
local instaOpenSupplyDropEnabled = false
local promptDistance = 25

local function applyPromptSettings(prompt, clearBusy)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    local holdRequired = false
    local map = Workspace:FindFirstChild("Map")
    local powerStation = map and map:FindFirstChild("PowerStation")
    local tower = map and map:FindFirstChild("ObservationTower")
    pcall(function()
        holdRequired = (powerStation and prompt:IsDescendantOf(powerStation)) or (tower and prompt:IsDescendantOf(tower))
    end)
    local ok = pcall(function()
        prompt.Enabled = true
        if not holdRequired then prompt.HoldDuration = 0 end
        prompt.RequiresLineOfSight = false
        prompt.MaxActivationDistance = math.clamp(promptDistance, 5, 100)
        prompt.ClickablePrompt = true
        prompt:SetAttribute("ODistance", math.clamp(promptDistance, 5, 100))
        if clearBusy then
            prompt:SetAttribute("Busy", false)
            prompt:SetAttribute("Busy2", false)
            prompt:SetAttribute("Unavailable", false)
            prompt:SetAttribute("Unavailable2", false)
        end
    end)
    return ok
end

local function applyKnownPrompts()
    local map = Workspace:FindFirstChild("Map")
    local paths = {
        {"SafeHouse", "Door", "DoorLever", "DoorGUIPart"},
        {"SafeHouse", "Door", "LightLever", "LightGUIPart"},
        {"SafeHouse", "Door", "Door", "DoorGUIPart"},
        {"SafeHouse", "Door", "PowerBox", "GUIPart"},
        {"SafeHouse", "Giver", "WalkieTalkie", "Attachment"},
        {"PowerStation", "StationFolder", "StationGUIPart"},
        {"Shack", "ShopPart"},
        {"ObservationTower", "Lights", "LightLever", "LightGUIPart"},
        {"ObservationTower", "Door", "DoorLever", "DoorGUIPart"},
        {"ObservationTower", "Door", "DoorLever2", "DoorGUIPart2"},
        {"ObservationTower", "Radar", "Lever", "RadarGUIPart"},
        {"ObservationTower", "LadderPart", "Attachment"},
        {"ObservationTower", "Door", "DoorModel", "Door", "KnockA"},
    }
    local count = 0
    local function walkPath(root, path)
        local object = root
        for _, name in ipairs(path) do
            object = object and object:FindFirstChild(name)
        end
        if object then
            if object:IsA("ProximityPrompt") then
                if applyPromptSettings(object, true) then count += 1 end
            else
                for _, item in ipairs(object:GetDescendants()) do
                    if item:IsA("ProximityPrompt") and applyPromptSettings(item, true) then count += 1 end
                end
            end
        end
    end
    if map then
        for _, path in ipairs(paths) do walkPath(map, path) end
    end
    local debris = Workspace:FindFirstChild("Debris")
    local drops = debris and (debris:FindFirstChild("SupplyCrates") or debris:FindFirstChild("SupplyCreates"))
    local traps = debris and debris:FindFirstChild("Traps")
    for _, root in pairs({drops, traps}) do
        if root then
            for _, item in ipairs(root:GetDescendants()) do
                if item:IsA("ProximityPrompt") and applyPromptSettings(item, true) then count += 1 end
            end
        end
    end
    return count
end

local function applyAllPrompts()
    local count = 0
    for _, item in ipairs(Workspace:GetDescendants()) do
        if item:IsA("ProximityPrompt") and applyPromptSettings(item, true) then count += 1 end
    end
    return count
end

local function applySupplyDropOpen()
    local debris = Workspace:FindFirstChild("Debris")
    local crates = debris and (debris:FindFirstChild("SupplyCrates") or debris:FindFirstChild("SupplyCreates"))
    if not crates then return end
    for _, box in ipairs(crates:GetChildren()) do
        if box.Name == "Box" then
            local prompt = box:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then applyPromptSettings(prompt, true) end
            local unlock = box:FindFirstChild("UnlockValue")
            if unlock and unlock:IsA("ValueBase") then pcall(function() unlock.Value = 100 end) end
        end
    end
end

addRakeToggle(SurvivorPromptSection, "Insta Open SupplyDrop", function(value)
    instaOpenSupplyDropEnabled = value
    if value then applySupplyDropOpen() end
end)
addRakeToggle(SurvivorPromptSection, "Known Object Prompt Bypass", function(value)
    knownPromptBypassEnabled = value
    if value then notifyFeature("Known Object Prompt Bypass", "Updated " .. tostring(applyKnownPrompts()) .. " known prompts.") end
end)
addRakeToggle(SurvivorPromptSection, "Prompt Bypass", function(value)
    promptBypassEnabled = value
    if value then notifyFeature("Prompt Bypass", "Updated " .. tostring(applyAllPrompts()) .. " prompts.") end
end)
addRakeButton(SurvivorPromptSection, "Unlock Prompts Once", function()
    notifyFeature("Unlock Prompts Once", "Updated " .. tostring(applyAllPrompts()) .. " prompts.")
end)
addRakeSlider(SurvivorPromptSection, "Prompt Distance", 5, 100, 25, 1, function(value)
    promptDistance = math.clamp(math.floor(value), 5, 100)
    if promptBypassEnabled then applyAllPrompts() end
    if knownPromptBypassEnabled then applyKnownPrompts() end
end)
local function callStartRemote(mode)
    local remote = ReplicatedStorage:FindFirstChild("StartRemote")
    if not remote or not remote:IsA("RemoteFunction") then
        notifyFeature("StartRemote", "StartRemote is not available.")
        return
    end
    local ok, result = pcall(function() return remote:InvokeServer(mode) end)
    notifyFeature("StartRemote " .. tostring(mode), ok and (tostring(mode) .. " returned: " .. tostring(result)) or "StartRemote call failed.")
end
addRakeButton(SurvivorPromptSection, "StartRemote Play", function() callStartRemote("Play") end)
addRakeButton(SurvivorPromptSection, "StartRemote LoadData", function() callStartRemote("LoadData") end)
addRakeButton(SurvivorPromptSection, "StartRemote JoinOld", function() callStartRemote("JoinOld") end)

task.spawn(function()
    while true do
        task.wait(1.5)
        if promptBypassEnabled then pcall(applyAllPrompts) end
        if knownPromptBypassEnabled then pcall(applyKnownPrompts) end
        if instaOpenSupplyDropEnabled then pcall(applySupplyDropOpen) end
    end
end)

local noDownedEnabled = false
local noMovementLockEnabled = false
local noJumpscareCutscreenEnabled = false
local characterControllerCache = setmetatable({}, {__mode = "k"})
local lastCharacterControllerScan = 0
local function patchCharacterControllerTables()
    -- Full getgc scans are expensive, so refresh the cache at most once every 2 seconds.
    local now = tick()
    if now - lastCharacterControllerScan >= 2 then
        lastCharacterControllerScan = now
        local getter = nil
        if type(getExecutorFunction) == "function" then
            pcall(function() getter = getExecutorFunction("getgc") end)
        end
        if type(getter) ~= "function" and type(getgc) == "function" then getter = getgc end
        if type(getter) == "function" then
            local ok, objects = pcall(getter, true)
            if ok and type(objects) == "table" then
                for _, controller in pairs(objects) do
                    if type(controller) == "table" and rawget(controller, "plr") == LocalPlayer
                        and type(rawget(controller, "vars")) == "table" and type(rawget(controller, "funcs")) == "table"
                        and rawget(controller, "CONFIG") ~= nil then
                        characterControllerCache[controller] = true
                    end
                end
            end
        end
    end

    for controller in pairs(characterControllerCache) do
        local vars = type(controller) == "table" and rawget(controller, "vars") or nil
        local valid = type(vars) == "table" and rawget(controller, "plr") == LocalPlayer
            and type(rawget(controller, "funcs")) == "table" and rawget(controller, "CONFIG") ~= nil
        if not valid then
            characterControllerCache[controller] = nil
        else
            if noDownedEnabled then
                pcall(function()
                    vars.downed = false
                    vars.lastDowned = false
                    vars.downedupbusy = false
                    controller.dead = false
                    if typeof(vars.downedV) == "Instance" and vars.downedV:IsA("BoolValue") then vars.downedV.Value = false end
                end)
            end
            if noMovementLockEnabled then
                pcall(function()
                    vars.canMove = true
                    vars.can_jump = true
                    vars.can_jump2 = true
                    vars.lastJump = 0
                    vars.handlingSRegen = false
                    vars.regeningS = false
                end)
            end
            if noJumpscareCutscreenEnabled then
                pcall(function()
                    RunService:UnbindFromRenderStep("JMPSCR")
                    controller.dead = false
                    if type(controller.sc) == "table" then controller.sc.db = true; controller.sc.fov = 0 end
                    local camera = Workspace.CurrentCamera
                    local humanoid = getHumanoid()
                    if camera and humanoid then camera.CameraType = Enum.CameraType.Custom; camera.CameraSubject = humanoid end
                end)
            end
        end
    end
end

local function applyCharacterProtection()
    local character = getCharacter()
    local humanoid = getHumanoid()
    if character and noDownedEnabled then
        local downed = character:FindFirstChild("Downed")
        if downed and downed:IsA("BoolValue") then pcall(function() downed.Value = false end) end
        local ragdollTime = character:FindFirstChild("RagdollTime")
        local switch = ragdollTime and ragdollTime:FindFirstChild("RagdollSwitch")
        if switch and switch:IsA("BoolValue") then pcall(function() switch.Value = false end) end
    end
    if humanoid and (noDownedEnabled or noMovementLockEnabled or noJumpscareCutscreenEnabled) then
        pcall(function()
            humanoid.PlatformStand = false
            humanoid.Sit = false
            humanoid.AutoRotate = true
            if noMovementLockEnabled then
                if humanoid.UseJumpPower ~= false and humanoid.JumpPower <= 1 then humanoid.JumpPower = 35 end
                if humanoid.UseJumpPower == false and humanoid.JumpHeight <= 1 then humanoid.JumpHeight = 7.2 end
            end
            if noDownedEnabled then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
        end)
        if noJumpscareCutscreenEnabled then
            pcall(function() RunService:UnbindFromRenderStep("JMPSCR") end)
            local camera = Workspace.CurrentCamera
            if camera then pcall(function() camera.CameraType = Enum.CameraType.Custom; camera.CameraSubject = humanoid end) end
        end
    end
    if noDownedEnabled or noMovementLockEnabled or noJumpscareCutscreenEnabled then
        patchCharacterControllerTables()
    end
end

-- Protection toggle occupying the former fall-damage slot.
addRakeToggle(MainProtectionSection, "No Fall Damage", function(value)
    noDownedEnabled = value == true
    applyCharacterProtection()
end, false)
addRakeToggle(MovementSection, "No Movement Lock", function(value)
    noMovementLockEnabled = value
    applyCharacterProtection()
end)
addRakeToggle(MiscJumpscareSection, "No JumpScare Cutscreen", function(value)
    noJumpscareCutscreenEnabled = value
    applyCharacterProtection()
end)
task.spawn(function()
    while true do
        task.wait(0.25)
        if noDownedEnabled or noMovementLockEnabled or noJumpscareCutscreenEnabled then
            pcall(applyCharacterProtection)
        end
    end
end)

local rakeAuraEnabled = false
local rakeAuraAutoEquip = false
local rakeAuraRange = 12
local rakeAuraDelay = 0.05
local rakeAuraElapsed = 0
local auraState = {rake = nil, root = nil, stick = nil, event = nil, hitPart = nil}

local function auraGetRake()
    local rake = auraState.rake
    if not (rake and rake.Parent) then
        rake = Workspace:FindFirstChild("Rake")
        auraState.rake = rake
        auraState.root = nil
    end
    if not rake then return nil end
    local rakeHumanoid = rake:FindFirstChild("Monster") or rake:FindFirstChildWhichIsA("Humanoid", true)
    if rakeHumanoid and rakeHumanoid.Health and rakeHumanoid.Health <= 0 then return nil end
    local root = auraState.root
    if not (root and root.Parent) then
        root = rake:FindFirstChild("HumanoidRootPart", true)
        auraState.root = root
    end
    if not root or not root:IsA("BasePart") then return nil end
    return rake, root
end

local function auraIsStick(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tool.Name:lower()
    return name == "stunstick" or (name:find("stun", 1, true) and name:find("stick", 1, true)) ~= nil
end

local function auraGetStick()
    local character = getCharacter()
    if not character then return nil end
    local stick = auraState.stick
    if not (stick and stick.Parent) then
        stick = nil
        for _, obj in ipairs(character:GetChildren()) do if auraIsStick(obj) then stick = obj; break end end
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if not stick and backpack then
            for _, obj in ipairs(backpack:GetChildren()) do if auraIsStick(obj) then stick = obj; break end end
        end
        auraState.stick, auraState.event, auraState.hitPart = stick, nil, nil
    end
    if not stick then return nil end
    if stick.Parent ~= character then
        if rakeAuraAutoEquip then
            local humanoid = getHumanoid()
            if humanoid then pcall(function() humanoid:EquipTool(stick) end) end
            auraState.stick = nil
        end
        return nil
    end
    if not (auraState.event and auraState.event.Parent) then
        auraState.event = stick:FindFirstChild("Event", true) or stick:FindFirstChildWhichIsA("RemoteEvent", true)
    end
    if not (auraState.hitPart and auraState.hitPart.Parent) then
        auraState.hitPart = stick:FindFirstChild("HitPart", true) or stick:FindFirstChildWhichIsA("BasePart", true)
    end
    return stick, auraState.event, auraState.hitPart
end

local function auraHasPower()
    local value = ReplicatedStorage:FindFirstChild("StationPower")
    return not value or value.Value == true
end

local function auraHasStamina()
    local value = ReplicatedStorage:FindFirstChild("GSTMNA")
    if not value then return true end
    local ok, current = pcall(function() return value:Invoke() end)
    return not ok or tonumber(current) == nil or tonumber(current) >= 12
end

local function auraSwing(event, hit)
    if not event or not hit then return end
    pcall(function() event:FireServer("S") end)
    if not _G.InfStamina then
        local staminaEvent = ReplicatedStorage:FindFirstChild("TKSMNA")
        if staminaEvent then pcall(function() staminaEvent:Fire(12) end) end
    end
    pcall(function() event:FireServer("H", hit) end)
end

-- The first Combat section now uses the original Rake Kill Aura implementation.
-- The display name is changed to Stun Stick Aura as requested.
addRakeToggle(CombatStunSection, "Stun Stick Aura", function(value)
    rakeAuraEnabled = value
    _G.RakeKillAura = value
    if not value then auraState.stick = nil end
end)
addRakeToggle(CombatStunSection, "Killaura Auto Equip", function(value)
    rakeAuraAutoEquip = value
end, false)
addRakeSlider(CombatStunSection, "Kill Aura Range", 6, 30, 12, 1, function(value)
    rakeAuraRange = math.clamp(value, 6, 30)
end)
addRakeSlider(CombatStunSection, "Kill Aura Delay", 0.05, 0.06, 0.05, 0.01, function(value)
    rakeAuraDelay = math.clamp(value, 0.05, 0.06)
end)

RunService.Heartbeat:Connect(function(dt)
    if not rakeAuraEnabled then rakeAuraElapsed = 0; return end
    rakeAuraElapsed += dt
    if rakeAuraElapsed < rakeAuraDelay then return end
    local root = getRootPart()
    local rake, rakeRoot = auraGetRake()
    if not (root and rake and rakeRoot) then return end
    if (root.Position - rakeRoot.Position).Magnitude > rakeAuraRange then return end
    local stick, event, hitPart = auraGetStick()
    if not (stick and event) then return end
    local targetPart = rakeRoot
    local bestDistance = (rakeRoot.Position - root.Position).Magnitude
    for _, name in ipairs({"Head", "Torso", "UpperTorso", "LowerTorso", "HumanoidRootPart"}) do
        local part = rake:FindFirstChild(name, true)
        if part and part:IsA("BasePart") then
            local distance = (part.Position - root.Position).Magnitude
            if distance < bestDistance then targetPart, bestDistance = part, distance end
        end
    end
    if bestDistance > rakeAuraRange or not auraHasPower() or not auraHasStamina() then return end
    rakeAuraElapsed = 0
    if hitPart then pcall(function() hitPart.CanTouch = true; hitPart.CanQuery = true end) end
    auraSwing(event, targetPart)
end)

local collectScrapsBusy = false
local function collectAllScraps()
    if collectScrapsBusy then notifyFeature("Collect All Scraps", "Collection is already running."); return end
    local rootPart = getRootPart()
    local humanoid = getHumanoid()
    local filter = Workspace:FindFirstChild("Filter")
    local scrapRoot = (filter and filter:FindFirstChild("ScrapSpawns")) or Workspace:FindFirstChild("ScrapSpawns", true)
    if not (rootPart and humanoid and scrapRoot) then notifyFeature("Collect All Scraps", "Scrap spawns or character are unavailable."); return end
    local scraps = {}
    for _, obj in ipairs(scrapRoot:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Scrap" and obj:FindFirstChildOfClass("TouchTransmitter") then
            scraps[#scraps + 1] = obj
        end
    end
    if #scraps == 0 then notifyFeature("Collect All Scraps", "No collectible scraps were found."); return end
    collectScrapsBusy = true
    task.spawn(function()
        local oldCFrame = rootPart.CFrame
        local collected = 0
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        local scrapFolder = backpack and backpack:FindFirstChild("ScrapFolder")
        local points = scrapFolder and scrapFolder:FindFirstChild("Points")
        for _, scrap in ipairs(scraps) do
            if not rootPart.Parent or not humanoid.Parent or humanoid.Health <= 0 then break end
            if scrap and scrap.Parent then
                local before = points and tonumber(points.Value) or nil
                pcall(function()
                    rootPart.CFrame = scrap.CFrame * CFrame.new(0, 1.5, 0)
                    rootPart.AssemblyLinearVelocity = Vector3.zero
                    rootPart.AssemblyAngularVelocity = Vector3.zero
                end)
                task.wait(0.15)
                pcall(function() rootPart.CFrame = scrap.CFrame end)
                task.wait(0.15)
                local after = points and tonumber(points.Value) or nil
                if not scrap.Parent or (before and after and after > before) then collected += 1 end
            end
        end
        pcall(function()
            if rootPart.Parent then
                rootPart.CFrame = oldCFrame
                rootPart.AssemblyLinearVelocity = Vector3.zero
                rootPart.AssemblyAngularVelocity = Vector3.zero
            end
        end)
        collectScrapsBusy = false
        notifyFeature("Collect All Scraps", "Collected " .. tostring(collected) .. " scrap(s).")
    end)
end
addRakeButton(ScrapsBringSection, "Collect All Scraps", collectAllScraps)

local instaSupplyLoop = false
local promptDescendantConnection = Workspace.DescendantAdded:Connect(function(obj)
    if obj and obj:IsA("ProximityPrompt") then
        task.defer(function()
            if promptBypassEnabled then applyPromptSettings(obj, true) end
        end)
    end
end)

local autoPowerLoop = false
end

local autoGrabFlaregunEnabled = false
_G.AutoGrabFlare = false -- Keep Auto Grab disabled until its toggle is enabled.
local autoGrabFlaregunLoopRunning = false

local function grabFlaregunPass()
    if not _G.AutoGrabFlare or not autoGrabFlaregunEnabled then return end

    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Keep the scan lightweight, and only target objects whose names include "flare".
    for _, item in pairs(Workspace:GetChildren()) do
        if not _G.AutoGrabFlare or not autoGrabFlaregunEnabled then break end
        local itemName = tostring(item.Name or ""):lower()
        if itemName:find("flare", 1, true) then
            local handle = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart")
            if item:IsA("BasePart") then
                handle = item
            end

            if handle and handle:IsA("BasePart") then
                local originalCFrame = hrp.CFrame
                local moved = pcall(function()
                    hrp.CFrame = handle.CFrame + Vector3.new(0, 3, 0)
                end)

                if moved then
                    task.wait(0.05)

                    if _G.AutoGrabFlare and autoGrabFlaregunEnabled and handle.Parent and hrp.Parent then
                        if type(firetouchinterest) == "function" then
                            pcall(function()
                                firetouchinterest(hrp, handle, 0)
                                task.wait(0.05)
                                firetouchinterest(hrp, handle, 1)
                            end)
                        end
                    end

                    task.wait(0.1)
                    pcall(function()
                        if hrp and hrp.Parent then
                            hrp.CFrame = originalCFrame
                        end
                    end)
                end
                break
            end
        end
    end
end

local function startAutoGrabFlaregunLoop()
    if autoGrabFlaregunLoopRunning then return end
    autoGrabFlaregunLoopRunning = true
    task.spawn(function()
        while _G.AutoGrabFlare and autoGrabFlaregunEnabled do
            task.wait(0.3)
            if _G.AutoGrabFlare and autoGrabFlaregunEnabled then
                pcall(grabFlaregunPass)
            end
        end
        autoGrabFlaregunLoopRunning = false
        -- Restart safely if it was enabled again as the previous loop was exiting.
        if _G.AutoGrabFlare and autoGrabFlaregunEnabled then
            startAutoGrabFlaregunLoop()
        end
    end)
end

addRakeToggle(MainAutoGrabFlaregunSection, "Enable Auto Grab Flaregun", function(value)
    autoGrabFlaregunEnabled = value == true
    _G.AutoGrabFlare = autoGrabFlaregunEnabled
    if autoGrabFlaregunEnabled then
        startAutoGrabFlaregunLoop()
    end
end, false)

local function getRakeModel()
    local rake = Workspace:FindFirstChild("Rake")
    return rake and rake:IsA("Model") and rake or nil
end

local function getRakeRoot()
    local rake = getRakeModel()
    if not rake then return nil end
    return rake:FindFirstChild("HumanoidRootPart") or rake.PrimaryPart
end

local function isAliveModel(model)
    if not model then return false end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    return humanoid ~= nil and humanoid.Health > 0
end

local function safeIsExecutorFunction(name)
    return type(_G[name]) == "function" or type(getfenv and getfenv()[name]) == "function"
end

getExecutorFunction = function(name)
    local fn = nil
    pcall(function() fn = getfenv and getfenv()[name] end)
    if type(fn) ~= "function" then pcall(function() fn = _G[name] end) end
    return fn
end

local infStaminaEnabled = false
local staminaModule = nil
local staminaHooks = setmetatable({}, {__mode = "k"})

local function findStaminaModule()
    local getter = getExecutorFunction("getloadedmodules")
    if type(getter) ~= "function" then return nil end
    local ok, modules = pcall(getter)
    if not ok or type(modules) ~= "table" then return nil end
    for _, moduleScript in ipairs(modules) do
        if moduleScript and moduleScript.Name == "M_H" then
            local requiredOk, required = pcall(require, moduleScript)
            if requiredOk and type(required) == "table" and type(required.TakeStamina) == "function" then
                return required
            end
        end
    end
    return nil
end

local function enableInfiniteStamina()
    local module = findStaminaModule()
    if not module then return false end

    local existing = staminaHooks[module]
    if existing and module.TakeStamina == existing.replacement then
        staminaModule = module
        return true
    end

    local original = module.TakeStamina
    if type(original) ~= "function" then return false end

    local replacement = function(self, amount, ...)
        if infStaminaEnabled and type(amount) == "number" and amount > 0 then
            return original(self, -amount, ...)
        end
        return original(self, amount, ...)
    end
    local wrap = getExecutorFunction("newcclosure")
    if type(wrap) == "function" then
        local wrappedOk, wrapped = pcall(wrap, replacement)
        if wrappedOk and type(wrapped) == "function" then replacement = wrapped end
    end

    local assigned = pcall(function() module.TakeStamina = replacement end)
    if not assigned then return false end
    staminaHooks[module] = {original = original, replacement = replacement}
    staminaModule = module
    return true
end

local function disableInfiniteStamina()
    for module, hookInfo in pairs(staminaHooks) do
        pcall(function()
            if module.TakeStamina == hookInfo.replacement then
                module.TakeStamina = hookInfo.original
            end
        end)
        staminaHooks[module] = nil
    end
    staminaModule = nil
end

local function retryEnableInfiniteStamina(maxAttempts, notifyOnFailure)
    task.spawn(function()
        local attempts = maxAttempts or 8
        for attempt = 1, attempts do
            if not infStaminaEnabled then return end
            if enableInfiniteStamina() then return end
            task.wait(0.75)
        end
        if infStaminaEnabled and notifyOnFailure then
            notifyFeature("Infinite Stamina", "M_H module is not ready. Try toggling Infinite Stamina off and on after respawning.")
        end
    end)
end

addRakeToggle(MovementStaminaSection, "Infinite Stamina", function(value)
    infStaminaEnabled = value == true
    _G.InfStamina = infStaminaEnabled
    if infStaminaEnabled then
        if not enableInfiniteStamina() then retryEnableInfiniteStamina(8, true) end
    else
        disableInfiniteStamina()
    end
end, false)

local walkSpeedEnabled = false
local walkSpeedValue = 16
local normalWalkSpeed = 16
local walkSpeedLoopStarted = false

local function applyWalkSpeed()
    local humanoid = getHumanoid()
    if humanoid and humanoid.Health > 0 then
        humanoid.WalkSpeed = walkSpeedEnabled and walkSpeedValue or normalWalkSpeed
    end
end

local function ensureWalkSpeedLoop()
    if walkSpeedLoopStarted then return end
    walkSpeedLoopStarted = true
    RunService.Heartbeat:Connect(function()
        if walkSpeedEnabled then applyWalkSpeed() end
    end)
end
ensureWalkSpeedLoop()

addRakeSlider(MovementSection, "WalkSpeed", 0, 30.5, 16, 0.5, function(value)
    walkSpeedValue = math.clamp(value, 0, 30.5)
    if walkSpeedEnabled then applyWalkSpeed() end
end)

addRakeToggle(MovementSection, "Toggle WalkSpeed", function(value)
    walkSpeedEnabled = value
    applyWalkSpeed()
end)

local fullBrightEnabled = false
local savedLighting = {}
local savedLightingCaptured = false
local lightingApplyBusy = false
local FULLBRIGHT_VALUES = {
    Ambient = Color3.fromRGB(255, 255, 255),
    OutdoorAmbient = Color3.fromRGB(255, 255, 255),
    Brightness = 2,
    FogEnd = 100000,
    GlobalShadows = false,
}

local fullBrightRenderConn = nil
local fullBrightEffectAddedConn = nil

local function isLightingPostEffect(item)
    return item and (item:IsA("Atmosphere") or item:IsA("PostEffect") or item:IsA("BloomEffect") or item:IsA("BlurEffect"))
end

local function removeFullbrightEffects()
    for _, item in ipairs(Lighting:GetChildren()) do
        if isLightingPostEffect(item) then
            pcall(function() item:Destroy() end)
        end
    end
end

local function applyFullbright()
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 2
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
end

local function captureRayWareLighting()
    if savedLightingCaptured then return end
    savedLightingCaptured = true
    for property in pairs(FULLBRIGHT_VALUES) do
        pcall(function() savedLighting[property] = Lighting[property] end)
    end
end

local function restoreRayWareLighting()
    if not savedLightingCaptured then return end
    for property, value in pairs(savedLighting) do
        pcall(function() Lighting[property] = value end)
    end
    table.clear(savedLighting)
    savedLightingCaptured = false
end

local function setFullbrightRuntime(enabled)
    if enabled then
        if not fullBrightRenderConn then
            removeFullbrightEffects()
            fullBrightRenderConn = RunService.RenderStepped:Connect(applyFullbright)
        end
        if not fullBrightEffectAddedConn then
            fullBrightEffectAddedConn = Lighting.ChildAdded:Connect(function(item)
                task.defer(function()
                    if fullBrightEnabled and item.Parent == Lighting and isLightingPostEffect(item) then
                        pcall(function() item:Destroy() end)
                    end
                end)
            end)
        end
        applyFullbright()
    else
        if fullBrightRenderConn then
            fullBrightRenderConn:Disconnect()
            fullBrightRenderConn = nil
        end
        if fullBrightEffectAddedConn then
            fullBrightEffectAddedConn:Disconnect()
            fullBrightEffectAddedConn = nil
        end
    end
end

local function applyLightingOverrides()
    if lightingApplyBusy then return end
    lightingApplyBusy = true
    if fullBrightEnabled then
        captureRayWareLighting()
        pcall(applyFullbright)
    else
        restoreRayWareLighting()
    end
    lightingApplyBusy = false
end

local NIGHT_VISION = {}
-- Infinite Night Vision: bounded getgc scans to avoid repeated full-heap scans causing freezes.
do
local infiniteNightVisionEnabled = false
local nightVisionTables = setmetatable({}, {__mode = "k"})
local nightVisionOriginals = setmetatable({}, {__mode = "k"})
local function patchNightVisionTable(value)
    if type(value) ~= "table" or rawget(value, "NVG_TAKE") == nil then return false end
    if not nightVisionOriginals[value] then
        nightVisionOriginals[value] = {NVG_TAKE = value.NVG_TAKE, NVG_REGEN = value.NVG_REGEN}
    end
    pcall(function()
        value.NVG_TAKE = 0
        value.NVG_REGEN = 100
    end)
    nightVisionTables[value] = true
    return true
end
local function scanNightVisionTables()
    local getter = getExecutorFunction("getgc")
    if type(getter) ~= "function" then return 0 end
    local ok, values = pcall(getter, true)
    if not ok or type(values) ~= "table" then return 0 end
    local found = 0
    for _, value in pairs(values) do
        if patchNightVisionTable(value) then found += 1 end
    end
    return found
end
local function restoreNightVisionTables()
    for value, original in pairs(nightVisionOriginals) do
        if type(value) == "table" and type(original) == "table" then
            pcall(function()
                value.NVG_TAKE = original.NVG_TAKE
                value.NVG_REGEN = original.NVG_REGEN
            end)
        end
        nightVisionTables[value] = nil
        nightVisionOriginals[value] = nil
    end
end
addRakeToggle(VisualLightingSection, "Infinite Night Vision", function(value)
    infiniteNightVisionEnabled = value == true
    _G.InfNightVision = infiniteNightVisionEnabled
    if infiniteNightVisionEnabled then
        scanNightVisionTables()
        task.spawn(function()
            -- A small number of retries helps catch the game's module loading without scanning forever.
            for attempt = 1, 3 do
                task.wait(attempt)
                if not infiniteNightVisionEnabled then return end
                scanNightVisionTables()
            end
        end)
    else
        restoreNightVisionTables()
    end
end)
task.spawn(function()
    while true do
        task.wait(1.5)
        if infiniteNightVisionEnabled then
            for value in pairs(nightVisionTables) do
                pcall(patchNightVisionTable, value)
            end
        end
    end
end)

NIGHT_VISION.disable = function()
    infiniteNightVisionEnabled = false
    _G.InfNightVision = false
    restoreNightVisionTables()
end
end

addRakeToggle(VisualLightingSection, "Fullbright", function(value)
    fullBrightEnabled = value == true
    _G.RakeFullbright = fullBrightEnabled
    if fullBrightEnabled then
        captureRayWareLighting()
        setFullbrightRuntime(true)
        applyLightingOverrides()
    else
        setFullbrightRuntime(false)
        applyLightingOverrides()
    end
end, false)

local thirdPersonEnabled = false
local shiftLockActive = false
local shiftLockInputConnection = nil
local shiftLockLoopConnection = nil
local mobileShiftLockGui = nil
local mobileShiftLockButton = nil
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local SHIFT_ICON_ON = "rbxasset://textures/ui/mouseLock_on@2x.png"
local SHIFT_ICON_OFF = "rbxasset://textures/ui/mouseLock_off@2x.png"

local function setShiftLock(value)
    shiftLockActive = value and thirdPersonEnabled or false
    if not isMobile then
        pcall(function()
            UserInputService.MouseBehavior = shiftLockActive and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
        end)
    end
    pcall(function() LocalPlayer.DevEnableMouseLock = shiftLockActive end)
    if mobileShiftLockButton then
        mobileShiftLockButton.Image = shiftLockActive and SHIFT_ICON_ON or SHIFT_ICON_OFF
    end
    if shiftLockActive then
        if not shiftLockLoopConnection then
            shiftLockLoopConnection = RunService.Heartbeat:Connect(function()
                if not (thirdPersonEnabled and shiftLockActive) then return end
                local root = getRootPart()
                local humanoid = getHumanoid()
                local camera = Workspace.CurrentCamera or Camera
                if not root or not camera then return end
                local look = camera.CFrame.LookVector
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.atan2(-look.X, -look.Z), 0)
                if humanoid then humanoid.AutoRotate = false end
            end)
        end
    else
        if shiftLockLoopConnection then
            shiftLockLoopConnection:Disconnect()
            shiftLockLoopConnection = nil
        end
        local humanoid = getHumanoid()
        if humanoid then humanoid.AutoRotate = true end
    end
end

local function activateThirdPerson()
    pcall(function()
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 400
        LocalPlayer.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.UserChoice
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end)
    if isMobile then
        if not mobileShiftLockGui then
            local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
            if playerGui then
                local old = playerGui:FindFirstChild("TheRake2MobileShiftLock")
                if old then old:Destroy() end
                local gui = Instance.new("ScreenGui")
                gui.Name = "TheRake2MobileShiftLock"
                gui.ResetOnSpawn = false
                gui.IgnoreGuiInset = true
                gui.DisplayOrder = 999
                gui.Parent = playerGui
                local button = Instance.new("ImageButton")
                button.Name = "ShiftLockButton"
                button.Size = UDim2.fromOffset(48, 48)
                button.Position = UDim2.new(1, -86, 1, -190)
                button.BackgroundTransparency = 1
                button.Image = shiftLockActive and SHIFT_ICON_ON or SHIFT_ICON_OFF
                button.Visible = thirdPersonEnabled
                button.Active = true
                button.AutoButtonColor = false
                button.Parent = gui
                button.Activated:Connect(function()
                    if thirdPersonEnabled then setShiftLock(not shiftLockActive) end
                end)
                mobileShiftLockGui = gui
                mobileShiftLockButton = button
            end
        elseif mobileShiftLockButton then
            mobileShiftLockButton.Visible = true
        end
    elseif not shiftLockInputConnection then
        shiftLockInputConnection = UserInputService.InputBegan:Connect(function(input, processed)
            if processed or not thirdPersonEnabled then return end
            if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
                setShiftLock(not shiftLockActive)
            end
        end)
    end
end

local function deactivateThirdPerson()
    setShiftLock(false)
    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = 0.5
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.DevEnableMouseLock = false
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end)
    if mobileShiftLockButton then mobileShiftLockButton.Visible = false end
    if shiftLockInputConnection then
        shiftLockInputConnection:Disconnect()
        shiftLockInputConnection = nil
    end
end

addRakeToggle(MiscCameraSection, "Third Person + Shift Lock", function(value)
    thirdPersonEnabled = value
    if value then activateThirdPerson() else deactivateThirdPerson() end
end)

local antiTrapEnabled = false
local antiTrapChildAddedConnection = nil

local antiTrapNames = {
    ["raketrapmodel"] = true,
    ["rusted bear traps"] = true,
    ["rake trap"] = true,
    ["traps"] = true,
    ["trap"] = true,
    ["beartrap"] = true,
    ["beartraps"] = true,
}

local function disableTrapTouch(obj)
    if not obj then return end

    local objNameLower = tostring(obj.Name or ""):lower()
    if not antiTrapNames[objNameLower] then return end

    if obj:IsA("BasePart") then
        obj.CanTouch = false
        return
    end

    -- Check only direct children; do not scan all descendants.
    for _, part in ipairs(obj:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanTouch = false
        end
    end
end

local function scanWorkspaceTraps()
    for _, item in ipairs(Workspace:GetChildren()) do
        disableTrapTouch(item)
    end
end

local function onAntiTrapWorkspaceChildAdded(item)
    task.spawn(function()
        task.wait(0.05)
        if not antiTrapEnabled then return end
        disableTrapTouch(item)
    end)
end

addRakeToggle(MainProtectionSection, "Anti Trap", function(value)
    antiTrapEnabled = value

    if antiTrapEnabled then
        scanWorkspaceTraps()
        if not antiTrapChildAddedConnection then
            antiTrapChildAddedConnection = Workspace.ChildAdded:Connect(onAntiTrapWorkspaceChildAdded)
        end
    else
        if antiTrapChildAddedConnection then
            antiTrapChildAddedConnection:Disconnect()
            antiTrapChildAddedConnection = nil
        end
    end
end)

-- Legacy StunStick-only aura removed; this section now controls the Rake Kill Aura above.

-- Insta Kill (Trap): integrated version of the requested RenderStepped + trap code.
-- All connections are active only while the existing toggle is enabled.
local instaKillEnabled = false
local instaKillConnections = {}
local instaKillRakeConnections = setmetatable({}, {__mode = "k"})
local instaKillSetupTraps = setmetatable({}, {__mode = "k"})
local instaKillTrapDebounce = setmetatable({}, {__mode = "k"})
local instaKillGeneration = 0
local instaKillTrapEvent = nil

local instaKillTargetNames = {
    ["rake"] = true,
    ["the rake"] = true,
    ["therake"] = true,
}

-- Find the game's unparented RemoteEvent when the executor supports getnilinstances.
local function instaKillGetNil(name, debugId)
    if type(getnilinstances) ~= "function" then return nil end
    local ok, objects = pcall(getnilinstances)
    if not ok or type(objects) ~= "table" then return nil end
    for _, object in ipairs(objects) do
        local matches = false
        pcall(function()
            matches = object.Name == name and object:GetDebugId() == debugId
        end)
        if matches then return object end
    end
    return nil
end

local function instaKillFindTargetModel(instance)
    local current = instance
    while current and current ~= Workspace do
        if current:IsA("Model") and instaKillTargetNames[string.lower(current.Name)] then
            return current
        end
        current = current.Parent
    end
    return nil
end

-- Apply the requested RenderStepped health lock to each matching Rake model.
local function instaKillProcessTarget(model)
    if not instaKillEnabled or not model or not model:IsA("Model") then return end
    if not instaKillTargetNames[string.lower(model.Name)] or instaKillRakeConnections[model] then return end

    local generation = instaKillGeneration
    task.spawn(function()
        local humanoid = model:FindFirstChild("Humanoid") or model:WaitForChild("Humanoid", 2)
        if not humanoid then humanoid = model:FindFirstChildWhichIsA("Humanoid", true) end
        if not instaKillEnabled or generation ~= instaKillGeneration or not model.Parent
            or not humanoid or not humanoid.Parent or instaKillRakeConnections[model] then
            return
        end

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not instaKillEnabled or generation ~= instaKillGeneration or not model.Parent or not humanoid.Parent then
                if connection then connection:Disconnect() end
                if instaKillRakeConnections[model] == connection then
                    instaKillRakeConnections[model] = nil
                end
                return
            end
            pcall(function() humanoid.Health = 0 end)
        end)
        instaKillRakeConnections[model] = connection
        table.insert(instaKillConnections, connection)
        print("[Insta Kill (Trap)] ตรวจพบ The Rake และล็อกเลือดด้วย RenderStepped เรียบร้อย")
    end)
end

local function instaKillIsRakePart(hit)
    if not hit or not hit.Parent then return false end
    local model = instaKillFindTargetModel(hit)
    return model ~= nil, model
end

local function instaKillIsTrap(obj)
    if not obj or not obj:IsA("BasePart") then return false end
    local name = string.lower(obj.Name)
    if name == "trap" or string.find(name, "trap", 1, true) then return true end
    local ancestor = obj.Parent
    while ancestor and ancestor ~= Workspace do
        local ancestorName = string.lower(ancestor.Name)
        if ancestorName == "trap" or string.find(ancestorName, "trap", 1, true) then return true end
        ancestor = ancestor.Parent
    end
    return false
end

local function instaKillSetupTrap(trapPart)
    if not instaKillEnabled or not instaKillIsTrap(trapPart) or instaKillSetupTraps[trapPart] then return end
    instaKillSetupTraps[trapPart] = true
    local connection = trapPart.Touched:Connect(function(hit)
        if not instaKillEnabled or instaKillTrapDebounce[trapPart] then return end
        local isRake, rakeModel = instaKillIsRakePart(hit)
        if not isRake or not rakeModel then return end
        instaKillTrapDebounce[trapPart] = true

        local humanoid = rakeModel:FindFirstChildOfClass("Humanoid") or rakeModel:FindFirstChildWhichIsA("Humanoid", true)
        if humanoid then
            local rakeConnection = instaKillRakeConnections[rakeModel]
            if rakeConnection then
                pcall(function() rakeConnection:Disconnect() end)
                instaKillRakeConnections[rakeModel] = nil
            end

            -- Optional local signal, matching the provided code. This does not guarantee a server-side trap event.
            if instaKillTrapEvent and type(firesignal) == "function" then
                pcall(function() firesignal(instaKillTrapEvent.OnClientEvent) end)
            end

            pcall(function()
                humanoid.Health = 0
                humanoid:ChangeState(Enum.HumanoidStateType.Dead)
            end)

            local generation = instaKillGeneration
            task.delay(0.4, function()
                if not instaKillEnabled or generation ~= instaKillGeneration then return end
                pcall(function() rakeModel:Destroy() end)
            end)
            print("[Insta Kill (Trap)] The Rake สัมผัสกับดักแล้ว")
        end

        local generation = instaKillGeneration
        task.delay(1, function()
            if generation == instaKillGeneration then instaKillTrapDebounce[trapPart] = nil end
        end)
    end)
    table.insert(instaKillConnections, connection)
end

local function instaKillDisconnectAll()
    for _, connection in ipairs(instaKillConnections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(instaKillConnections)
    for _, connection in pairs(instaKillRakeConnections) do
        pcall(function() connection:Disconnect() end)
    end
    instaKillRakeConnections = setmetatable({}, {__mode = "k"})
    instaKillSetupTraps = setmetatable({}, {__mode = "k"})
    instaKillTrapDebounce = setmetatable({}, {__mode = "k"})
end

local function instaKillStart()
    instaKillGeneration += 1
    instaKillEnabled = true
    instaKillDisconnectAll()
    instaKillTrapEvent = instaKillGetNil("RemoteEvent", "1_732412")

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and instaKillTargetNames[string.lower(obj.Name)] then
            instaKillProcessTarget(obj)
        end
        if instaKillIsTrap(obj) then instaKillSetupTrap(obj) end
    end

    local connection = Workspace.DescendantAdded:Connect(function(obj)
        if not instaKillEnabled then return end
        if obj:IsA("Model") and instaKillTargetNames[string.lower(obj.Name)] then
            instaKillProcessTarget(obj)
        else
            local model = instaKillFindTargetModel(obj)
            if model then instaKillProcessTarget(model) end
        end
        if instaKillIsTrap(obj) then instaKillSetupTrap(obj) end
    end)
    table.insert(instaKillConnections, connection)
end

addRakeToggle(CombatInstaSection, "Insta Kill (Trap)", function(value)
    if value == true then
        if not instaKillEnabled then instaKillStart() end
    else
        instaKillEnabled = false
        instaKillGeneration += 1
        instaKillDisconnectAll()
        instaKillTrapEvent = nil
    end
end, false)

-- Hitbox/trap repositioning loop removed as requested.

local autoFarmScrapEnabled = false
local evasionDistance = 80

local function getClosestScrap()
    local root = getRootPart()
    if not root then return nil end
    local best, bestDistance = nil, math.huge
    for _, item in ipairs(Workspace:GetDescendants()) do
        local name = tostring(item.Name):lower()
        if item:IsA("BasePart") and (name == "scrap" or name:find("scrap", 1, true)) then
            local distance = (root.Position - item.Position).Magnitude
            if distance < bestDistance then best, bestDistance = item, distance end
        end
    end
    return best
end

addRakeToggle(ScrapsFarmSection, "Auto Farm Scrap", function(value)
    autoFarmScrapEnabled = value
end)

pcall(function()
    ScrapsFarmSection:AddSlider({
        Name = "Evasion Distance",
        Title = "Evasion Distance",
        Min = 30,
        MinValue = 30,
        Max = 150,
        MaxValue = 150,
        Default = 80,
        DefaultValue = 80,
        Value = 80,
        Increment = 1,
        Step = 1,
        ValueName = "studs",
        Callback = function(value)
            evasionDistance = math.clamp(math.floor(tonumber(value) or 80), 30, 150)
        end
    })
end)

task.spawn(function()
    while true do
        task.wait(0.55)
        if autoFarmScrapEnabled then
            local root = getRootPart()
            local humanoid = getHumanoid()
            if root and humanoid and humanoid.Health > 0 then
                local rakeRoot = getRakeRoot()
                if rakeRoot then
                    local offset = root.Position - rakeRoot.Position
                    if offset.Magnitude < evasionDistance then
                        local direction = offset.Magnitude > 0.1 and offset.Unit or -root.CFrame.LookVector
                        pcall(function() root.CFrame = CFrame.new(root.Position + direction * 45) end)
                    else
                        local scrap = getClosestScrap()
                        if scrap then pcall(function() humanoid:MoveTo(scrap.Position) end) end
                    end
                else
                    local scrap = getClosestScrap()
                    if scrap then pcall(function() humanoid:MoveTo(scrap.Position) end) end
                end
            end
        end
    end
end)


local HIDE_UNDER_FLOOR = {}
do
local hideUnderFloorEnabled = false
local savedHideY = nil
local savedHideCFrame = nil
local hidePlatform = nil
local hideLockedRoot = nil
local hideRootWasAnchored = nil
local hideLockedHumanoid = nil
local hideHumanoidOriginals = nil
local hideRespawnPending = false
local UNDER_FLOOR_OFFSET = 30 -- deeper than the previous 12/20-stud offset

local function getHideFloorY(root)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {getCharacter(), hidePlatform}
    local result = Workspace:Raycast(root.Position + Vector3.new(0, 5, 0), Vector3.new(0, -500, 0), params)
    return result and result.Position.Y or root.Position.Y
end

local function ensureHidePlatform(root, targetY)
    if not (root and targetY) then return end
    if not (hidePlatform and hidePlatform.Parent) then
        hidePlatform = Instance.new("Part")
        hidePlatform.Name = "TheRake2HidePlatform"
        hidePlatform.Size = Vector3.new(48, 1, 48)
        hidePlatform.Anchored = true
        hidePlatform.CanCollide = true
        hidePlatform.CanTouch = false
        hidePlatform.CanQuery = false
        hidePlatform.CastShadow = false
        hidePlatform.Transparency = 1
        hidePlatform.Material = Enum.Material.SmoothPlastic
        hidePlatform.Parent = Workspace
    end
    local center = savedHideCFrame and savedHideCFrame.Position or root.Position
    hidePlatform.CFrame = CFrame.new(center.X, targetY - 3.5, center.Z)
end

local function rememberHideCharacter(root, humanoid)
    if hideLockedRoot ~= root then
        hideLockedRoot = root
        hideRootWasAnchored = root.Anchored
        savedHideCFrame = root.CFrame
        savedHideY = nil
        hideLockedHumanoid = nil
        hideHumanoidOriginals = nil
    end
    if humanoid and hideLockedHumanoid ~= humanoid then
        hideLockedHumanoid = humanoid
        hideHumanoidOriginals = {
            WalkSpeed = humanoid.WalkSpeed,
            JumpPower = humanoid.JumpPower,
            JumpHeight = humanoid.JumpHeight,
            AutoRotate = humanoid.AutoRotate,
            PlatformStand = humanoid.PlatformStand,
            Sit = humanoid.Sit,
        }
    end
end

local function freezeHideCharacter(root, humanoid)
    if not root then return end
    local original = savedHideCFrame or root.CFrame
    local targetY = savedHideY or (getHideFloorY(root) - UNDER_FLOOR_OFFSET)
    savedHideY = targetY
    ensureHidePlatform(root, targetY)
    local goal = CFrame.new(original.Position.X, targetY, original.Position.Z) * original.Rotation
    if (root.Position - goal.Position).Magnitude > 0.2 then
        pcall(function()
            root.CFrame = goal
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end
    if humanoid then
        pcall(function()
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            humanoid.JumpHeight = 0
            humanoid.AutoRotate = false
            humanoid.PlatformStand = false
            humanoid.Sit = false
        end)
    end
    -- Anchoring the root keeps position fixed instead of repeatedly teleporting each frame.
    pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.Anchored = true
    end)
end

local function enterHideUnderFloor()
    local root = getRootPart()
    if not root then return end
    local humanoid = getHumanoid()
    rememberHideCharacter(root, humanoid)
    freezeHideCharacter(root, humanoid)
end

local function exitHideUnderFloor()
    hideUnderFloorEnabled = false
    local root = getRootPart()
    if root and root.Parent and savedHideCFrame then
        pcall(function()
            root.CFrame = savedHideCFrame + Vector3.new(0, 2, 0)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.Anchored = hideRootWasAnchored == true
        end)
    end
    local humanoid = getHumanoid()
    if humanoid and hideHumanoidOriginals and humanoid == hideLockedHumanoid then
        local original = hideHumanoidOriginals
        pcall(function()
            humanoid.WalkSpeed = original.WalkSpeed
            humanoid.JumpPower = original.JumpPower
            humanoid.JumpHeight = original.JumpHeight
            humanoid.AutoRotate = original.AutoRotate
            humanoid.PlatformStand = original.PlatformStand
            humanoid.Sit = original.Sit
        end)
    end
    savedHideY = nil
    savedHideCFrame = nil
    hideLockedRoot = nil
    hideRootWasAnchored = nil
    hideLockedHumanoid = nil
    hideHumanoidOriginals = nil
    if hidePlatform then pcall(function() hidePlatform:Destroy() end); hidePlatform = nil end
end

addRakeToggle(RakeHideSection, "Anti Rake / Hide Under Floor", function(value)
    hideUnderFloorEnabled = value == true
    if hideUnderFloorEnabled then
        enterHideUnderFloor()
    else
        exitHideUnderFloor()
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if hideUnderFloorEnabled and not hideRespawnPending then
            pcall(function()
                local root = getRootPart()
                if root then
                    local humanoid = getHumanoid()
                    if root ~= hideLockedRoot then rememberHideCharacter(root, humanoid) end
                    -- Reassert only the locked properties; the character stays anchored in place.
                    if not (hidePlatform and hidePlatform.Parent) then ensureHidePlatform(root, savedHideY or (getHideFloorY(root) - UNDER_FLOOR_OFFSET)) end
                    local original = savedHideCFrame or root.CFrame
                    local expected = savedHideY and Vector3.new(original.Position.X, savedHideY, original.Position.Z) or root.Position
                    if not root.Anchored or (root.Position - expected).Magnitude > 0.75 then
                        freezeHideCharacter(root, humanoid)
                    end
                    if humanoid and hideHumanoidOriginals then
                        humanoid.WalkSpeed = 0
                        humanoid.JumpPower = 0
                        humanoid.JumpHeight = 0
                        humanoid.AutoRotate = false
                    end
                end
            end)
        end
    end
end)

HIDE_UNDER_FLOOR.beginRespawn = function()
    if hideUnderFloorEnabled then hideRespawnPending = true end
end
HIDE_UNDER_FLOOR.finishRespawn = function()
    if hideUnderFloorEnabled then
        savedHideY = nil
        savedHideCFrame = nil
        hideLockedRoot = nil
        hideRootWasAnchored = nil
        hideLockedHumanoid = nil
        hideHumanoidOriginals = nil
        if hidePlatform then pcall(function() hidePlatform:Destroy() end); hidePlatform = nil end
        task.delay(0.25, function()
            if hideUnderFloorEnabled then enterHideUnderFloor() end
            hideRespawnPending = false
        end)
    else
        hideRespawnPending = false
    end
end
HIDE_UNDER_FLOOR.disable = function()
    exitHideUnderFloor()
end
end

local safeZoneEnabled = false
local safeZonePart = nil
local function createSafeZone()
    if not safeZoneEnabled then return end
    local root = getRootPart()
    if not root then return end
    if safeZonePart then pcall(function() safeZonePart:Destroy() end) end
    local part = Instance.new("Part")
    part.Name = "TheRake2SafeZone"
    part.Size = Vector3.new(18, 1, 18)
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = true
    part.Transparency = 0.55
    part.Color = Color3.fromRGB(0, 255, 120)
    part.Material = Enum.Material.Neon
    part.CFrame = CFrame.new(root.Position.X, root.Position.Y - 3, root.Position.Z)
    part.Parent = Workspace
    safeZonePart = part
    part.Touched:Connect(function(hit)
        if not safeZoneEnabled then return end
        if hit and getCharacter() and hit:IsDescendantOf(getCharacter()) then
            local currentRoot = getRootPart()
            if currentRoot and safeZonePart and safeZonePart.Parent then
                currentRoot.CFrame = safeZonePart.CFrame + Vector3.new(0, 4, 0)
            end
        end
    end)
end

addRakeToggle(RakeSafeSection, "Safe Zone", function(value)
    safeZoneEnabled = value
    if value then
        createSafeZone()
    elseif safeZonePart then
        safeZonePart:Destroy()
        safeZonePart = nil
    end
end)

local ESPState = {
    Scrap = false,
    Location = false,
    Flare = false,
}
local RayESPObjects = {}
local RayLocations = {
    SHOP = true,
    CAVE = true,
    ["BASE CAMP"] = true,
    TOWER = true,
    ["SAFE HOUSE"] = true,
    ["POWER STATION"] = true,
    ["OBSERVATION TOWER"] = true,
}

local function clearRayESP()
    for _, object in ipairs(RayESPObjects) do pcall(function() object:Destroy() end) end
    table.clear(RayESPObjects)
end

local function createRayBillboard(part, labelText, color, tagName)
    if not part or not part.Parent or not part:IsA("BasePart") then return end
    tagName = tagName or "TheRake2ESP"
    if part:FindFirstChild(tagName) then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = tagName
    billboard.Adornee = part
    billboard.Size = UDim2.fromOffset(180, 36)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 2500
    billboard.Parent = part
    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = color
    label.TextStrokeTransparency = 0.3
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = billboard
    table.insert(RayESPObjects, billboard)
end

local function anyObjectESPEnabled()
    for _, value in pairs(ESPState) do if value then return true end end
    return false
end

local function updateRayESP()
    clearRayESP()
    if not anyObjectESPEnabled() then return end
    local root = getRootPart()
    for _, item in ipairs(Workspace:GetDescendants()) do
        local rawName = tostring(item.Name)
        local name = rawName:lower()
        if item:IsA("BasePart") then
            local distance = root and math.floor((root.Position - item.Position).Magnitude) or 0
            if ESPState.Scrap and (name == "scrap" or name:find("scrap", 1, true)) then
                createRayBillboard(item, "Scrap | " .. distance .. "m", Color3.fromRGB(80, 255, 100), "TheRake2ScrapESP")
            elseif ESPState.Flare and name:find("flare", 1, true) then
                createRayBillboard(item, "Flare | " .. distance .. "m", Color3.fromRGB(80, 160, 255), "TheRake2FlareESP")
            elseif ESPState.Location and RayLocations[rawName:upper()] then
                createRayBillboard(item, rawName, Color3.fromRGB(200, 200, 255), "TheRake2LocationESP")
            end
        elseif ESPState.Location and RayLocations[rawName:upper()] then
            local part = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or item:FindFirstChildWhichIsA("BasePart")
            if part then createRayBillboard(part, rawName, Color3.fromRGB(200, 200, 255), "TheRake2LocationESP") end
        end
    end
end

addRakeToggle(VisualObjectESPSection, "Scrap ESP", function(value) ESPState.Scrap = value; if not anyObjectESPEnabled() then clearRayESP() end end)
addRakeToggle(VisualObjectESPSection, "Flare ESP", function(value) ESPState.Flare = value; if not anyObjectESPEnabled() then clearRayESP() end end)
addRakeToggle(VisualLocationsSection, "Location ESP", function(value) ESPState.Location = value; if not anyObjectESPEnabled() then clearRayESP() end end)


-- ESP Traps: opt-in, event-driven; only checks Workspace children and one nested level.
do
    local trapESPEnabled = false
    local trapNames = {
        ["rusted bear traps"] = true,
        ["rake trap"] = true,
        ["traps"] = true,
        ["trap"] = true,
        ["beartrap"] = true,
        ["beartraps"] = true,
    }
    local trapESPChildAddedConn = nil
    local trapESPBillboards = {}
    local trapESPTagged = setmetatable({}, {__mode = "k"})

    local function createTrapESP(obj)
        if not trapESPEnabled or not obj or not obj.Parent then return end
        local objNameLower = tostring(obj.Name or ""):lower()
        if not trapNames[objNameLower] or trapESPTagged[obj] then return end

        local targetPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
        if not targetPart then return end
        if targetPart:FindFirstChild("TrapESP") then
            trapESPTagged[obj] = true
            return
        end

        local hasOwner = obj:FindFirstChild("Owner") ~= nil or obj:FindFirstChild("Creator") ~= nil
        local textColor = hasOwner and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(210, 180, 140)
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "TrapESP"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 120, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.Adornee = targetPart

        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "TrapLabel"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = obj.Name
        textLabel.TextColor3 = textColor
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        textLabel.TextSize = 14
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.Parent = billboard
        billboard.Parent = targetPart

        trapESPTagged[obj] = true
        table.insert(trapESPBillboards, billboard)
    end

    local function scanTrapNode(obj)
        createTrapESP(obj)
        for _, child in ipairs(obj:GetChildren()) do
            createTrapESP(child)
        end
    end

    local function setTrapESPEnabled(value)
        trapESPEnabled = value == true
        if trapESPEnabled then
            for _, item in ipairs(Workspace:GetChildren()) do
                scanTrapNode(item)
            end
            if not trapESPChildAddedConn then
                trapESPChildAddedConn = Workspace.ChildAdded:Connect(function(item)
                    task.defer(function()
                        if trapESPEnabled and item.Parent == Workspace then
                            scanTrapNode(item)
                        end
                    end)
                end)
            end
        else
            if trapESPChildAddedConn then
                trapESPChildAddedConn:Disconnect()
                trapESPChildAddedConn = nil
            end
            for _, billboard in ipairs(trapESPBillboards) do
                pcall(function() billboard:Destroy() end)
            end
            table.clear(trapESPBillboards)
            trapESPTagged = setmetatable({}, {__mode = "k"})
        end
    end

    addRakeToggle(VisualTrapESPSection, "Enable ESP Traps", setTrapESPEnabled, false)
end

task.spawn(function()
    while true do
        task.wait(1.25)
        pcall(updateRayESP)
    end
end)

addRakeButton(MiscSection, "Rejoin", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- Detailed flashlight controls ported/adapted from TheRake_v2.lua.
do
local MiscFlashlightSection = FLASHLIGHT_MODIFY.section
local flashlightModify = {
    noShadows = false,
    boost = false,
    brightness = 2,
    range = 45,
    angle = 70,
    beamWidth = 0.5,
    originals = setmetatable({}, {__mode = "k"}),
}

local function flashlightDescendants(root)
    local ok, result = pcall(function() return root and root:GetDescendants() or {} end)
    return ok and result or {}
end

local function flashlightTools()
    local result = {}
    local roots = {}
    local character = getCharacter()
    local backpack = LocalPlayer and LocalPlayer:FindFirstChildOfClass("Backpack")
    if character then roots[#roots + 1] = character end
    if backpack then roots[#roots + 1] = backpack end
    for _, root in ipairs(roots) do
        if root then
            for _, item in ipairs(root:GetChildren()) do
                if item:IsA("Tool") and item.Name:lower():find("flashlight", 1, true) then
                    result[#result + 1] = item
                end
            end
        end
    end
    return result
end

local function flashlightSave(obj)
    local rec = flashlightModify.originals[obj]
    if rec then return rec end
    rec = {}
    flashlightModify.originals[obj] = rec
    pcall(function()
        if obj:IsA("Light") then
            rec.Brightness = obj.Brightness
            rec.Range = obj.Range
            rec.Shadows = obj.Shadows
            rec.Enabled = obj.Enabled
            if obj:IsA("SpotLight") then rec.Angle = obj.Angle end
        elseif obj:IsA("Beam") then
            rec.Enabled = obj.Enabled
            rec.Width0 = obj.Width0
            rec.Width1 = obj.Width1
            rec.Brightness = obj.Brightness
            rec.LightEmission = obj.LightEmission
            rec.Transparency = obj.Transparency
        elseif obj:IsA("ParticleEmitter") then
            rec.Enabled = obj.Enabled
            rec.Rate = obj.Rate
            rec.LightEmission = obj.LightEmission
            rec.ZOffset = obj.ZOffset
        elseif obj:IsA("BasePart") then
            rec.Transparency = obj.Transparency
        end
    end)
    return rec
end

local function flashlightSet(obj, property, value)
    pcall(function() if obj[property] ~= value then obj[property] = value end end)
end

local function flashlightRestoreObject(obj, rec)
    if not (obj and obj.Parent and type(rec) == "table") then return end
    for property, value in pairs(rec) do flashlightSet(obj, property, value) end
end

local function flashlightRestoreAll()
    for obj, rec in pairs(flashlightModify.originals) do
        flashlightRestoreObject(obj, rec)
        flashlightModify.originals[obj] = nil
    end
end

local function flashlightIsOn(tool)
    local sawLight = false
    for _, obj in ipairs(flashlightDescendants(tool)) do
        if obj:IsA("Light") then
            sawLight = true
            if obj.Enabled and obj.Brightness > 0 and obj.Range > 0 then return true end
        elseif obj:IsA("Beam") then
            sawLight = true
            if obj.Enabled and (obj.Width0 > 0.02 or obj.Width1 > 0.02) then return true end
        elseif obj:IsA("ParticleEmitter") and obj.Name:lower():find("light", 1, true) then
            sawLight = true
            if obj.Enabled and obj.Rate > 0 then return true end
        end
    end
    return not sawLight
end

local function flashlightApply()
    local active = flashlightModify.noShadows or flashlightModify.boost
    if not active then
        flashlightRestoreAll()
        return
    end
    for _, tool in ipairs(flashlightTools()) do
        if flashlightIsOn(tool) then
            for _, obj in ipairs(flashlightDescendants(tool)) do
                if obj:IsA("Light") then
                    local rec = flashlightSave(obj)
                    if flashlightModify.noShadows then flashlightSet(obj, "Shadows", false)
                    elseif rec.Shadows ~= nil then flashlightSet(obj, "Shadows", rec.Shadows) end
                    if flashlightModify.boost then
                        flashlightSet(obj, "Brightness", math.clamp(tonumber(flashlightModify.brightness) or 2, 0, 10))
                        flashlightSet(obj, "Range", math.clamp(tonumber(flashlightModify.range) or 45, 8, 120))
                        if obj:IsA("SpotLight") then flashlightSet(obj, "Angle", math.clamp(tonumber(flashlightModify.angle) or 70, 15, 120)) end
                    else
                        if rec.Brightness ~= nil then flashlightSet(obj, "Brightness", rec.Brightness) end
                        if rec.Range ~= nil then flashlightSet(obj, "Range", rec.Range) end
                        if obj:IsA("SpotLight") and rec.Angle ~= nil then flashlightSet(obj, "Angle", rec.Angle) end
                    end
                elseif obj:IsA("Beam") then
                    local rec = flashlightSave(obj)
                    if flashlightModify.boost then
                        local width = math.clamp(tonumber(flashlightModify.beamWidth) or 0.5, 0, 3)
                        flashlightSet(obj, "Width0", width)
                        flashlightSet(obj, "Width1", width * 1.15)
                        flashlightSet(obj, "Brightness", math.clamp((tonumber(flashlightModify.brightness) or 2) * 0.35, 0, 4))
                        flashlightSet(obj, "LightEmission", 0.55)
                        flashlightSet(obj, "Transparency", NumberSequence.new(0.45))
                    else
                        for _, property in ipairs({"Width0", "Width1", "Brightness", "LightEmission", "Transparency"}) do
                            if rec[property] ~= nil then flashlightSet(obj, property, rec[property]) end
                        end
                    end
                elseif obj:IsA("ParticleEmitter") and obj.Name:lower():find("light", 1, true) then
                    local rec = flashlightSave(obj)
                    if flashlightModify.boost then
                        flashlightSet(obj, "Rate", math.clamp((tonumber(flashlightModify.brightness) or 2) * 4, 0, 30))
                        flashlightSet(obj, "LightEmission", 0.65)
                        flashlightSet(obj, "ZOffset", 0.1)
                    else
                        for _, property in ipairs({"Rate", "LightEmission", "ZOffset"}) do
                            if rec[property] ~= nil then flashlightSet(obj, property, rec[property]) end
                        end
                    end
                elseif obj:IsA("BasePart") and flashlightModify.noShadows and (obj.Name == "LShadow1" or obj.Name == "LShadow2") then
                    local rec = flashlightSave(obj)
                    flashlightSet(obj, "Transparency", 1)
                elseif obj:IsA("BasePart") and not flashlightModify.noShadows and (obj.Name == "LShadow1" or obj.Name == "LShadow2") then
                    local rec = flashlightModify.originals[obj]
                    if rec and rec.Transparency ~= nil then flashlightSet(obj, "Transparency", rec.Transparency) end
                end
            end
        else
            -- When the flashlight is off, leave its ordinary properties untouched.
            for obj, rec in pairs(flashlightModify.originals) do
                local ok, descendant = pcall(function() return obj:IsDescendantOf(tool) end)
                if ok and descendant then flashlightRestoreObject(obj, rec); flashlightModify.originals[obj] = nil end
            end
        end
    end
end

addRakeToggle(MiscFlashlightSection, "Flashlight No Shadows", function(value)
    flashlightModify.noShadows = value == true
    flashlightApply()
end)
addRakeToggle(MiscFlashlightSection, "Flashlight Boost", function(value)
    flashlightModify.boost = value == true
    flashlightApply()
end)
addRakeSlider(MiscFlashlightSection, "Flashlight Brightness", 0, 10, 2, 0.25, function(value)
    flashlightModify.brightness = math.clamp(tonumber(value) or 2, 0, 10)
    flashlightApply()
end)
addRakeSlider(MiscFlashlightSection, "Flashlight Range", 8, 120, 45, 1, function(value)
    flashlightModify.range = math.clamp(tonumber(value) or 45, 8, 120)
    flashlightApply()
end)
addRakeSlider(MiscFlashlightSection, "Flashlight Angle", 15, 120, 70, 1, function(value)
    flashlightModify.angle = math.clamp(tonumber(value) or 70, 15, 120)
    flashlightApply()
end)
addRakeSlider(MiscFlashlightSection, "Flashlight Beam Width", 0, 3, 0.5, 0.05, function(value)
    flashlightModify.beamWidth = math.clamp(tonumber(value) or 0.5, 0, 3)
    flashlightApply()
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if flashlightModify.noShadows or flashlightModify.boost then pcall(flashlightApply) end
    end
end)


FLASHLIGHT_MODIFY.apply = flashlightApply
FLASHLIGHT_MODIFY.isActive = function()
    return flashlightModify.noShadows or flashlightModify.boost
end
FLASHLIGHT_MODIFY.disable = function()
    flashlightModify.noShadows = false
    flashlightModify.boost = false
    flashlightRestoreAll()
end
end

do
local TimerPowerSection = TIMER_POWER.section
-- Shared drag helper: a click/tap alone never moves a panel; it must move at least 5 pixels.
local function makePanelDraggable(frame)
    local connections = {}
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPosition = nil
    local didMove = false
    table.insert(connections, frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input.UserInputType == Enum.UserInputType.Touch and input or nil
            dragStart = input.Position
            startPosition = frame.Position
            didMove = false
        end
    end))
    table.insert(connections, frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end))
    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if not dragging or not dragStart or not startPosition then return end
        local isMouseMove = input.UserInputType == Enum.UserInputType.MouseMovement
        local isActiveTouch = input.UserInputType == Enum.UserInputType.Touch and dragInput and input == dragInput
        if not (isMouseMove or isActiveTouch) then return end
        local delta = input.Position - dragStart
        if not didMove and delta.Magnitude < 5 then return end
        didMove = true
        frame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end))
    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            dragInput = nil
            dragStart = nil
            startPosition = nil
            didMove = false
        end
    end))
    return function()
        for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
        table.clear(connections)
    end
end

local timerPowerGui = nil
local timerPowerFrame = nil
local timerPowerLabels = {}
local timerPowerDragCleanup = nil
local timerPowerUpdateConn = nil

local function formatTimerPowerTime(value)
    local total = math.max(0, math.floor(tonumber(value) or 0))
    local hours = math.floor(total / 3600)
    local minutes = math.floor((total % 3600) / 60)
    local seconds = total % 60
    if hours > 0 then return string.format("%d:%02d:%02d", hours, minutes, seconds) end
    return string.format("%d:%02d", minutes, seconds)
end

local function updateTimerPowerPanel()
    if not timerPowerLabels[1] then return end
    local timerValue = ReplicatedStorage:FindFirstChild("Timer")
    local nightValue = ReplicatedStorage:FindFirstChild("Night")
    local timerText = (nightValue and nightValue.Value == true) and "Time Until Day : " or "Time Until Night : "
    timerText ..= formatTimerPowerTime(timerValue and timerValue.Value or 0)

    local powerValues = ReplicatedStorage:FindFirstChild("PowerValues")
    local powerValue = powerValues and powerValues:FindFirstChild("PowerLevel")
    local powerPct = math.max(0, (tonumber(powerValue and powerValue.Value) or 1000) / 10)
    local powerText = (powerPct % 1 == 0) and tostring(math.floor(powerPct)) or string.format("%.1f", powerPct)

    local targetText = "Rake's Target : none"
    local rake = Workspace:FindFirstChild("Rake", true)
    local targetValue = rake and rake:FindFirstChild("TargetVal", true)
    local target = targetValue and targetValue.Value
    if target and target.Parent then targetText = "Rake's Target : " .. tostring(target.Parent.Name) end

    timerPowerLabels[1].Text = targetText
    timerPowerLabels[2].Text = timerText
    timerPowerLabels[3].Text = "Power : " .. powerText .. "%"
end

local function destroyTimerPowerPanel()
    if timerPowerUpdateConn then pcall(function() timerPowerUpdateConn:Disconnect() end); timerPowerUpdateConn = nil end
    if timerPowerDragCleanup then pcall(timerPowerDragCleanup); timerPowerDragCleanup = nil end
    if timerPowerGui then pcall(function() timerPowerGui:Destroy() end) end
    timerPowerGui = nil
    timerPowerFrame = nil
    timerPowerLabels = {}
end

local function createTimerPowerPanel()
    if not TIMER_POWER.enabled or (timerPowerGui and timerPowerGui.Parent) then return end
    local playerGui = nil
    if LocalPlayer then
        local ok, result = pcall(function() return LocalPlayer:WaitForChild("PlayerGui", 10) end)
        if ok then playerGui = result end
    end
    if not playerGui then return end

    local gui = Instance.new("ScreenGui")
    gui.Name = "TheRake2TimerPowerGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 80
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Name = "Timer & Power"
    frame.Size = UDim2.new(0, 232, 0, 66)
    frame.Position = UDim2.new(0, 12, 0, 80)
    frame.BackgroundTransparency = 1 -- fully transparent
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = gui

    local labels = {}
    for i = 1, 3 do
        local label = Instance.new("TextLabel")
        label.Name = ({"RakeTarget", "DayNightTimer", "PowerLevel"})[i]
        label.Size = UDim2.new(1, 0, 0, 21)
        label.Position = UDim2.new(0, 0, 0, (i - 1) * 21)
        label.BackgroundTransparency = 1
        label.BorderSizePixel = 0
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.TextStrokeTransparency = 0.35
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Text = "Loading..."
        label.Parent = frame
        labels[i] = label
    end

    timerPowerGui = gui
    timerPowerFrame = frame
    timerPowerLabels = labels
    timerPowerDragCleanup = makePanelDraggable(frame)
    updateTimerPowerPanel()
    local elapsed = 0
    timerPowerUpdateConn = RunService.Heartbeat:Connect(function(dt)
        elapsed += dt
        if elapsed >= 0.5 then
            elapsed = 0
            pcall(updateTimerPowerPanel)
        end
    end)
end

addRakeToggle(TimerPowerSection, "Show Timer & Power Panel", function(value)
    TIMER_POWER.enabled = value == true
    if TIMER_POWER.enabled then createTimerPowerPanel() else destroyTimerPowerPanel() end
end, false)
-- Timer & Power panel is intentionally not created until its toggle is enabled.

TIMER_POWER.create = createTimerPowerPanel
TIMER_POWER.destroy = destroyTimerPowerPanel
TIMER_POWER.makeDraggable = makePanelDraggable
end

LocalPlayer.CharacterAdded:Connect(function(character)
    HIDE_UNDER_FLOOR.beginRespawn()
    task.wait(1)
    if infStaminaEnabled then retryEnableInfiniteStamina(10, true) end
    if walkSpeedEnabled then applyWalkSpeed() end
    if fullBrightEnabled then applyLightingOverrides() end
    if thirdPersonEnabled then activateThirdPerson() end
    HIDE_UNDER_FLOOR.finishRespawn()
    if FLASHLIGHT_MODIFY.isActive() then task.delay(0.25, FLASHLIGHT_MODIFY.apply) end
    if TIMER_POWER.enabled then task.delay(0.25, TIMER_POWER.create) end
    if safeZoneEnabled then createSafeZone() end
end)


local LOCATION_CONTROL_NAMES={
    ["Power Station"]=true,
    ["Safe House"]=true,
    ["Shop"]=true,
    ["Tower"]=true,
    ["Base Camp"]=true,
}

local function getBolongSectionForControl(parent,title)
    local name=tostring(title or "")
    local parentName=""
    pcall(function() parentName=tostring(parent.Name or "") end)
    if name=="Enable Speed" or parentName=="PlayerLeftCol" then return nil end
    if name=="Fall Damage" or name=="Remove Trap Hitbox" or name=="Improved Lighting" or name=="Object Finder (Beta)" or name=="Trap Detector" then return nil end
    if name=="Show Locations" or name=="Text Background" or LOCATION_CONTROL_NAMES[name] then return nil end
    if name=="Rake Kill Aura" or parentName=="PlayerRightCol" or name=="Other NPC's" then return nil end
    if name=="The Rake" then
        return VisualESPSection
    elseif name=="Players" then
        return VisualPlayerESPSection
    end
    if name=="Rake Meter" then
        return VisualTrackingSection
    end
    if name=="No Downed / Ragdoll" or name=="No Movement Lock" or name=="No Jumpscare Camera" or name=="Insta Open SupplyDrop" or name=="Known Object Prompt Bypass" or name=="Prompt Bypass" then
        return nil
    end
    if parentName=="GameLeftCol" or name=="SH Bypass" or name=="TD Bypass" or name=="Power Level Stat" or name=="Day/Night Timer" then
        return MainSection
    end
    return MiscSection
end

local function addBolongToggle(parent,title,initial,callback)
    local section=getBolongSectionForControl(parent,title)
    if not section then return end
    local config={Name=title,Title=title,Default=initial,DefaultValue=initial,Value=initial,CurrentValue=initial,Callback=function(value)
        if type(value)~="boolean" then value=not not value end
        pcall(callback,value)
    end}
    local ok=pcall(function() section:AddToggle(config) end)
    if not ok then
        ok=pcall(function() section:AddToggle(title,initial,config.Callback) end)
    end
    if not ok then
        pcall(function() section:AddSwitch(config) end)
    end
end

local function addBolongButton(parent,title,callback)
    local section=getBolongSectionForControl(parent,title)
    if not section then return end
    local config={Name=title,Callback=function() pcall(callback) end}
    local ok=pcall(function() section:AddButton(config) end)
    if not ok then pcall(function() section:AddButton(title,config.Callback) end) end
end


-- Script active flag
local SCRIPT_ACTIVE = true
pcall(function() ContextActionService:UnbindAction("RakeKillToggleAction") end)
local workspaceChildAddedConn = nil
local workspaceDescendantAddedConn = nil
local workspaceDescendantRemovingConn = nil
local playersPlayerAddedConn = nil
local insertToggleConn = nil
local localPlayerCharAddedConn = nil
local localPlayerRespawnConn = nil

local Light = Lighting
local IMPROVED_LIGHTS = {}
local IMPROVED_LIGHTING_ENABLED = false
local _prevOutdoorAmbient = nil
local _prevAmbient = nil
local _prevBrightness = nil
local _prevGlobalShadows = nil

function dofullbright()
	Light.Ambient = Color3.new(1, 1, 1)
	Light.ColorShift_Bottom = Color3.new(1, 1, 1)
	Light.ColorShift_Top = Color3.new(1, 1, 1)
end

local _dofullbright_conn = nil
local function enableImprovedLighting()
	if IMPROVED_LIGHTING_ENABLED then return end
	IMPROVED_LIGHTING_ENABLED = true
	pcall(function()
		_prevAmbient = Light.Ambient
		_prevOutdoorAmbient = Light.OutdoorAmbient
		_prevBrightness = Light.Brightness
		_prevGlobalShadows = Light.GlobalShadows
	end)
	dofullbright()
	if not _dofullbright_conn then
		_dofullbright_conn = Light.LightingChanged:Connect(dofullbright)
	end
end

local function disableImprovedLighting()
	if not IMPROVED_LIGHTING_ENABLED then return end
	IMPROVED_LIGHTING_ENABLED = false
	if _dofullbright_conn then
		_dofullbright_conn:Disconnect()
		_dofullbright_conn = nil
	end
	pcall(function()
		if _prevAmbient then Light.Ambient = _prevAmbient end
		if _prevOutdoorAmbient then Light.OutdoorAmbient = _prevOutdoorAmbient end
		if _prevBrightness then Light.Brightness = _prevBrightness end
		if _prevGlobalShadows ~= nil then Light.GlobalShadows = _prevGlobalShadows end
		_prevAmbient = nil
		_prevOutdoorAmbient = nil
		_prevBrightness = nil
		_prevGlobalShadows = nil
	end)
end

local RAKE_METER = {
	enabled = false,
	conn = nil,
	hudGui = nil,
	label = nil,
	cachedRake = nil,
	lastRakeCheck = 0,
	dragCleanup = nil,
}

local function findRakeModel()
	-- Prefer an exact match
	local direct = Workspace:FindFirstChild("Rake")
	if direct and direct:IsA("Model") then
		return direct
	end

	-- Fallback: prefer models explicitly tagged by ESP as 'rake'
	for _, m in ipairs(Workspace:GetDescendants()) do
		if m and m:IsA("Model") then
			local tag = m:FindFirstChild("ESP_Category")
			if tag and tag:IsA("StringValue") and tag.Value == "rake" then
				return m
			end
		end
	end

	return nil
end

-- Cached getter to avoid expensive workspace scans every frame
local function getCachedRake(throttle)
	throttle = throttle or 0.25
	local now = tick()
	-- return cached if still valid
	if RAKE_METER.cachedRake and RAKE_METER.cachedRake.Parent then
		return RAKE_METER.cachedRake
	end
	-- throttle repeated searches
	if now - (RAKE_METER.lastRakeCheck or 0) < throttle then
		return nil
	end
	RAKE_METER.lastRakeCheck = now
	local r = findRakeModel()
	RAKE_METER.cachedRake = r
	return r
end

local function formatFriendly(dist)
	if dist < 8 then
		return "Very Close"
	elseif dist < 25 then
		return "Close"
	elseif dist < 80 then
		return "Nearby"
	else
		return "Far"
	end
end

-- Lightweight Rake proximity panel; the old Rake ESP Beam feature is removed.
local function createRakeProximityGui()
	local playerGui = LocalPlayer:WaitForChild("PlayerGui")
	-- destroy any existing instance to avoid duplicates
	local existing = playerGui:FindFirstChild("RakeProximityGui")
	if existing then existing:Destroy() end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "RakeProximityGui"
	screenGui.Parent = playerGui
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local frame = Instance.new("Frame")
	frame.Name = "ProximityFrame"
	frame.Parent = screenGui
	frame.Size = UDim2.new(0, 198, 0, 48)
	frame.Position = UDim2.new(1, -208, 0, 10)
	frame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
	frame.BackgroundTransparency = 0.2
	frame.BorderSizePixel = 0
	frame.Active = true
	local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0,6) corner.Parent = frame

	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Parent = frame
	statusLabel.Size = UDim2.new(1, 0, 1, 0)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = "Initializing..."
	statusLabel.TextColor3 = Color3.new(1,1,1)
	statusLabel.TextScaled = true
	statusLabel.Font = Enum.Font.SourceSansBold

	-- Draggable on desktop/mobile; a click or tap without an actual drag does not move it.
	if RAKE_METER.dragCleanup then pcall(RAKE_METER.dragCleanup) end
	RAKE_METER.dragCleanup = TIMER_POWER.makeDraggable(frame)

	RAKE_METER.hudGui = screenGui
	RAKE_METER.label = statusLabel
end

local function destroyRakeProximityGui()
	if RAKE_METER.dragCleanup then pcall(RAKE_METER.dragCleanup); RAKE_METER.dragCleanup = nil end
	pcall(function()
		if RAKE_METER.hudGui then RAKE_METER.hudGui:Destroy() end
	end)
	RAKE_METER.hudGui = nil
	RAKE_METER.label = nil
end

local function enableRakeMeter(screen)
	if RAKE_METER.conn then return end
	RAKE_METER.enabled = true
	createRakeProximityGui()

	RAKE_METER.conn = RunService.Heartbeat:Connect(function()
		pcall(function()
			local char = LocalPlayer and LocalPlayer.Character
			local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
			if not hrp then
				if RAKE_METER.label then RAKE_METER.label.Text = "Rake: no character" RAKE_METER.label.TextColor3 = Color3.fromRGB(128,128,128) end
				return
			end

			-- throttle workspace searches more aggressively when we don't have a cached rake
			local throttle = RAKE_METER.cachedRake and 0.25 or 2.0
			local rake = getCachedRake(throttle)
			if not rake then
				if RAKE_METER.label then
					RAKE_METER.label.Text = "Rake is not active"
					RAKE_METER.label.TextColor3 = Color3.fromRGB(160,160,160)
				end
				return
			end

			local rakeRoot = rake:FindFirstChild("HumanoidRootPart") or rake.PrimaryPart or rake:FindFirstChildWhichIsA("BasePart")
			if not rakeRoot then return end
			local dist = (rakeRoot.Position - hrp.Position).Magnitude

			-- status and color mapping (kept similar to original formatting)
			local status, color
			if dist <= 50 then
				status = "VERY CLOSE"
				color = Color3.new(1,0,0)
			elseif dist <= 150 then
				status = "CLOSE"
				color = Color3.new(1,0.5,0)
			elseif dist <= 300 then
				status = "FAR"
				color = Color3.new(1,1,0)
			else
				status = "SAFE"
				color = Color3.new(0,1,0)
			end

			if RAKE_METER.label then
				RAKE_METER.label.Text = string.format("%s — %.1fm", status, dist)
				RAKE_METER.label.TextColor3 = color
			end
		end)
	end)
end

local function disableRakeMeter()
	RAKE_METER.enabled = false
	if RAKE_METER.conn then
		RAKE_METER.conn:Disconnect()
		RAKE_METER.conn = nil
	end
	destroyRakeProximityGui()
end

-- Player handling
-- ESP settings
local ESP_SETTINGS = {
	showRake = false,
	showPlayers = false,
	rakeVariant = "Chams",
}

local ESP_HEALTH_CONNECTIONS = setmetatable({}, {__mode = "k"})

local function removeModelESP(model)
    if not model then return end
    local connections = ESP_HEALTH_CONNECTIONS[model]
    if connections then
        for _, connection in ipairs(connections) do
            pcall(function() connection:Disconnect() end)
        end
        ESP_HEALTH_CONNECTIONS[model] = nil
    end
    for _, name in ipairs({"ESP_Highlight", "ESP_Name", "ESP_Category", "ESP_Variant", "ESP_Square", "ESP_Health"}) do
        local item = model:FindFirstChild(name)
        if item then pcall(function() item:Destroy() end) end
    end
end

local function createESP(model)
    if not model or not model:IsA("Model") then return end
    local root = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not root then return end
    local player = Players:GetPlayerFromCharacter(model)
    if player == LocalPlayer then
        removeModelESP(model)
        return
    end
    local isRake = tostring(model.Name or ""):lower():find("rake", 1, true) ~= nil
    if not player and not isRake then
        removeModelESP(model)
        return
    end
    if player and not ESP_SETTINGS.showPlayers then return end
    if isRake and not ESP_SETTINGS.showRake then return end

    local category = player and "player" or "rake"
    local variant = isRake and (ESP_SETTINGS.rakeVariant or "Chams") or "Chams"
    local existingCategory = model:FindFirstChild("ESP_Category")
    local existingVariant = model:FindFirstChild("ESP_Variant")
    local hasVisual = model:FindFirstChild("ESP_Highlight") or model:FindFirstChild("ESP_Square")
    if hasVisual and existingCategory and existingCategory.Value == category and existingVariant and existingVariant.Value == variant then
        return
    end
    removeModelESP(model)

    if isRake and variant == "Square" then
        local square = Instance.new("BillboardGui")
        square.Name = "ESP_Square"
        square.Adornee = root
        local extents = model:GetExtentsSize()
        local boxWidth = math.clamp(extents.X, 2.2, 10)
        local boxHeight = math.clamp(extents.Y, 4, 16)
        square.Size = UDim2.new(boxWidth, 0, boxHeight, 0)
        square.StudsOffset = Vector3.new(0, math.max(extents.Y * 0.05, 0.15), 0)
        square.AlwaysOnTop = true
        square.MaxDistance = 2500
        square.Parent = model
        local frame = Instance.new("Frame")
        frame.Name = "SquareFrame"
        frame.Size = UDim2.fromScale(1, 1)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        frame.Parent = square
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(255, 55, 55)
        stroke.Transparency = 0
        stroke.Parent = frame
    else
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = model
        highlight.Parent = model
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        if player then
            highlight.FillColor = Color3.fromRGB(0, 255, 80)
            highlight.OutlineColor = Color3.fromRGB(0, 255, 80)
            highlight.FillTransparency = 0.66
            highlight.OutlineTransparency = 0
        elseif variant == "Outline" then
            highlight.FillColor = Color3.fromRGB(255, 60, 60)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.66
            highlight.OutlineTransparency = 0
        else
            highlight.FillColor = Color3.fromRGB(170, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.3
            highlight.OutlineTransparency = 0.8
        end
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Name"
    billboard.Parent = model
    billboard.Adornee = root
    billboard.Size = UDim2.fromScale(4, 1)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    local text = Instance.new("TextLabel")
    text.Parent = billboard
    text.Size = UDim2.fromScale(1, 1)
    text.BackgroundTransparency = 1
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.TextStrokeTransparency = 0
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.Text = player and player.Name or model.Name

    -- Actual humanoid health, displayed as small red text on the model's right side.
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local extents = model:GetExtentsSize()
        local healthGui = Instance.new("BillboardGui")
        healthGui.Name = "ESP_Health"
        healthGui.Adornee = root
        healthGui.Size = UDim2.fromOffset(72, 19)
        healthGui.StudsOffset = Vector3.new(math.max(extents.X * 0.5, 1.2) + 0.45, math.max(extents.Y * 0.22, 0.5), 0)
        healthGui.AlwaysOnTop = true
        healthGui.MaxDistance = 2500
        healthGui.Parent = model

        local healthText = Instance.new("TextLabel")
        healthText.Name = "HealthText"
        healthText.Size = UDim2.fromScale(1, 1)
        healthText.BackgroundTransparency = 1
        healthText.BorderSizePixel = 0
        healthText.Font = Enum.Font.GothamBold
        healthText.TextSize = 12
        healthText.TextScaled = false
        healthText.TextColor3 = Color3.fromRGB(255, 45, 45)
        healthText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        healthText.TextStrokeTransparency = 0.25
        healthText.TextXAlignment = Enum.TextXAlignment.Left
        healthText.TextYAlignment = Enum.TextYAlignment.Center
        healthText.Parent = healthGui

        local function updateHealthText()
            if not healthText.Parent or not humanoid.Parent then return end
            local health = math.max(0, math.ceil(humanoid.Health))
            local maximum = math.max(0, math.ceil(humanoid.MaxHealth))
            healthText.Text = string.format("%d/%d HP", health, maximum)
        end
        updateHealthText()
        ESP_HEALTH_CONNECTIONS[model] = {
            humanoid.HealthChanged:Connect(updateHealthText),
            humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(updateHealthText),
        }
    end

    local catTag = Instance.new("StringValue")
    catTag.Name = "ESP_Category"
    catTag.Value = category
    catTag.Parent = model
    local variantTag = Instance.new("StringValue")
    variantTag.Name = "ESP_Variant"
    variantTag.Value = variant
    variantTag.Parent = model
end

local function refreshAllHighlights()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local player = Players:GetPlayerFromCharacter(obj)
            local isRake = tostring(obj.Name or ""):lower():find("rake", 1, true) ~= nil
            local tag = obj:FindFirstChild("ESP_Category")
            local variantTag = obj:FindFirstChild("ESP_Variant")
            local hasESP = tag ~= nil
            local shouldHave = (player ~= nil and player ~= LocalPlayer and ESP_SETTINGS.showPlayers)
                or (isRake and ESP_SETTINGS.showRake)
            local desiredVariant = isRake and (ESP_SETTINGS.rakeVariant or "Chams") or "Chams"
            if shouldHave and (not hasESP or not variantTag or variantTag.Value ~= desiredVariant) then
                pcall(createESP, obj)
            elseif not shouldHave and hasESP then
                removeModelESP(obj)
            elseif player == LocalPlayer then
                removeModelESP(obj)
            elseif not player and not isRake and hasESP then
                removeModelESP(obj)
            end
        end
    end
end

addRakeDropdown(VisualESPSection, "The Rake ESP Variant", {"Chams", "Outline", "Square"}, "Chams", function(value)
    if value ~= "Chams" and value ~= "Outline" and value ~= "Square" then value = "Chams" end
    ESP_SETTINGS.rakeVariant = value
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and tostring(model.Name):lower():find("rake", 1, true) then
            removeModelESP(model)
        end
    end
    refreshAllHighlights()
end)

-- Building highlight settings (persisted)
local BUILDING_SETTINGS = {
	["Tower"] = false,
	["Base Camp"] = false,
	["Safe House"] = false,
	["Shop"] = false,
	["Power Station"] = false,
}

-- Location marker system
local LOCATIONS = {
	{ name = "Power Station", pos = Vector3.new(-295.83, 20.00, -201.65) },
	{ name = "Safe House",    pos = Vector3.new(-363.56, 16.48, 74.48) },
	{ name = "Shop",          pos = Vector3.new(-24.29, 16.24, -254.70) },
	{ name = "Tower",         pos = Vector3.new(64.43, 13.49, -55.44) },
	{ name = "Base Camp",     pos = Vector3.new(-43.67, 17.61, 202.36) },
}

local LOCATION_MARKERS = {}
local locationUpdateConn = nil
local LOCATION_SETTINGS = {}
for _, l in ipairs(LOCATIONS) do
	LOCATION_SETTINGS[l.name] = false
end

-- Whether to draw a background behind location text labels (persisted)
local LOCATION_TEXT_BG = false

local function createLocationMarkerUI(screen, loc)
	if not screen or not loc then return end
	local container = Instance.new("Frame")
	container.Name = ("Loc_%s"):format(loc.name:gsub("%s+",""))
	container.Size = UDim2.new(0, 200, 0, 48)
	container.BackgroundTransparency = 1
	container.ClipsDescendants = false
	container.Parent = screen

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = (LOCATION_TEXT_BG and 0) or 1
	label.BackgroundColor3 = Color3.fromRGB(18,18,20)
	label.TextColor3 = Color3.fromRGB(230,230,235)
	label.Font = Enum.Font.GothamSemibold
	label.Text = loc.name
	label.TextSize = 13
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.Parent = container

	if LOCATION_TEXT_BG then
		local lblCorner = Instance.new("UICorner")
		lblCorner.CornerRadius = UDim.new(0,6)
		lblCorner.Parent = label

		local lblStroke = Instance.new("UIStroke")
		lblStroke.Color = Color3.fromRGB(40,40,44)
		lblStroke.Transparency = 0.6
		lblStroke.Thickness = 1
		lblStroke.Parent = label
	end

	local shape = Instance.new("Frame")
	shape.Name = "Dot"
	shape.Size = UDim2.new(0, 10, 0, 10)
	shape.Position = UDim2.new(0.5, -5, 0, 26)
	shape.AnchorPoint = Vector2.new(0.5, 0)
	shape.BackgroundColor3 = Color3.fromRGB(120, 220, 170)
	shape.BackgroundTransparency = 0
	local sCorner = Instance.new("UICorner")
	sCorner.CornerRadius = UDim.new(1, 0)
	sCorner.Parent = shape
	local sStroke = Instance.new("UIStroke")
	sStroke.Color = Color3.fromRGB(30,30,30)
	sStroke.Transparency = 0.7
	sStroke.Thickness = 1
	sStroke.Parent = shape
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(150,255,200)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(90,200,140)),
	})
	g.Rotation = 0
	g.Parent = shape
	shape.Parent = container

	return { container = container, label = label, shape = shape }
end

local function updateLocationMarkers(screen)
	if not screen then return end
	local cam = workspace.CurrentCamera
	if not cam then return end
	local maxDist = 2000
	for _, loc in ipairs(LOCATIONS) do
		local entry = LOCATION_MARKERS[loc.name]
		if LOCATION_SETTINGS[loc.name] == false then
			if entry and entry.container then
				entry.container.Visible = false
			end
		else
			if not entry then
				entry = createLocationMarkerUI(screen, loc)
				LOCATION_MARKERS[loc.name] = entry
			end
			if entry then
				local worldPos = loc.pos
				local viewportPoint = cam:WorldToViewportPoint(worldPos)
				local onScreen = viewportPoint.Z > 0
				local screenX, screenY = viewportPoint.X, viewportPoint.Y
				local dist = (cam.CFrame.Position - worldPos).Magnitude
				local visible = onScreen and dist < maxDist
				entry.container.Visible = visible
				if visible then
					entry.container.Position = UDim2.fromOffset(math.floor(screenX - (entry.container.Size.X.Offset/2)), math.floor(screenY - 24))
					local scale = math.clamp(1.5 - (dist / 200), 0.6, 2.2)
					entry.label.TextSize = math.clamp(14 * scale, 10, 36)
					local dotSize = math.clamp(math.floor(12 * (1.2 - (dist / 800))), 6, 20)
					entry.shape.Size = UDim2.new(0, dotSize, 0, dotSize)
					entry.shape.Position = UDim2.new(0.5, -dotSize/2, 0, 30)
				end
			end
		end
	end
end

local function enableLocationMarkers(screen)
	if locationUpdateConn then return end
	for _, loc in ipairs(LOCATIONS) do
		local entry = LOCATION_MARKERS[loc.name]
		if not entry then
			entry = {}
			LOCATION_MARKERS[loc.name] = entry
		end
		if not entry.worldPart then
			local part = Instance.new("Part")
			part.Name = ("LocPart_%s"):format(loc.name:gsub("%s+",""))
			part.Size = Vector3.new(0.4,0.4,0.4)
			part.Position = loc.pos
			part.Anchored = true
			part.CanCollide = false
			part.Transparency = 0.45
			part.Material = Enum.Material.SmoothPlastic
			part.Color = Color3.fromRGB(110,200,160)
			part.Parent = Workspace

			local bp = Instance.new("BillboardGui")
			bp.Size = UDim2.new(0, 140, 0, 26)
			bp.Adornee = part
			bp.AlwaysOnTop = true
			bp.StudsOffset = Vector3.new(0, 1.2, 0)
			bp.Parent = part

			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, 0, 1, 0)
			lbl.BackgroundTransparency = (LOCATION_TEXT_BG and 0) or 1
			lbl.BackgroundColor3 = Color3.fromRGB(20,20,22)
			lbl.TextColor3 = Color3.fromRGB(235,235,240)
			lbl.Font = Enum.Font.GothamSemibold
			lbl.TextSize = 12
			lbl.Text = loc.name
			lbl.TextWrapped = true
			lbl.TextXAlignment = Enum.TextXAlignment.Center
			lbl.Parent = bp

			if LOCATION_TEXT_BG then
				local bCorner = Instance.new("UICorner")
				bCorner.CornerRadius = UDim.new(0,6)
				bCorner.Parent = lbl

				local bStroke = Instance.new("UIStroke")
				bStroke.Color = Color3.fromRGB(40,40,44)
				bStroke.Transparency = 0.7
				bStroke.Thickness = 1
				bStroke.Parent = lbl
			end

			entry.worldPart = part
		end
	end

	locationUpdateConn = RunService.RenderStepped:Connect(function()
		pcall(function() updateLocationMarkers(screen) end)
		for _, loc in ipairs(LOCATIONS) do
			local e = LOCATION_MARKERS[loc.name]
			if e and e.worldPart then
				local enabled = (LOCATION_SETTINGS[loc.name] ~= false)
				e.worldPart.Position = loc.pos
				e.worldPart.Transparency = enabled and 0 or 1
				-- ensure attached BillboardGui
				pcall(function()
					local bp = e.worldPart:FindFirstChildOfClass("BillboardGui")
					if bp then
						pcall(function() bp.Enabled = enabled end)
						local lbl = bp:FindFirstChildWhichIsA("TextLabel")
						if lbl then
							lbl.Visible = enabled
						end
					end
				end)
			end
		end
	end)
end

local function disableLocationMarkers()
	if locationUpdateConn then
		locationUpdateConn:Disconnect()
		locationUpdateConn = nil
	end
	for _, entry in pairs(LOCATION_MARKERS) do
		pcall(function()
			if entry.container then entry.container:Destroy() end
			if entry.worldPart then entry.worldPart:Destroy() end
		end)
	end
	LOCATION_MARKERS = {}
end

local function onPlayer(player)
	if player == LocalPlayer then return end
	player.CharacterAdded:Connect(function(char)
		task.wait(0.2)
		if char then removeModelESP(char) end
		createESP(char)
	end)
	if player.Character then
		local char = player.Character
		removeModelESP(char)
		createESP(player.Character)
	end
end

for _, player in pairs(Players:GetPlayers()) do
	if SCRIPT_ACTIVE then onPlayer(player) end
end
playersPlayerAddedConn = Players.PlayerAdded:Connect(function(p)
	if not SCRIPT_ACTIVE then return end
	onPlayer(p)
end)


-- Global NPC highlighting
local function isPlayerCharacter(model)
	return Players:GetPlayerFromCharacter(model) ~= nil
end

local function onModelAdded(model)
	if not model or not model:IsA("Model") then return end
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if humanoid then
		task.spawn(function()
			task.wait(0.2)
			if not isPlayerCharacter(model) then
				createESP(model)
			else
				local player = Players:GetPlayerFromCharacter(model)
				if player and player ~= LocalPlayer then
					removeModelESP(model)
					createESP(model)
				end
			end
		end)
	end
end
workspaceChildAddedConn = Workspace.ChildAdded:Connect(function(m)
	if not SCRIPT_ACTIVE then return end
	onModelAdded(m)
end)
for _, child in pairs(Workspace:GetChildren()) do
	if SCRIPT_ACTIVE then onModelAdded(child) end
end

workspaceDescendantAddedConn = Workspace.DescendantAdded:Connect(function(desc)
	if not SCRIPT_ACTIVE then return end
	if not desc then return end
	if desc:IsA("Humanoid") and desc.Parent and desc.Parent:IsA("Model") then
		task.defer(function()
			if not isPlayerCharacter(desc.Parent) then
				pcall(function() createESP(desc.Parent) end)
			else
				local player = Players:GetPlayerFromCharacter(desc.Parent)
				if player and player ~= LocalPlayer then
					pcall(function()
						removeModelESP(desc.Parent)
						createESP(desc.Parent)
					end)
				end
			end
		end)
	elseif desc:IsA("Model") then
		task.defer(function() pcall(function() onModelAdded(desc) end) end)
	end
end)

workspaceDescendantRemovingConn = Workspace.DescendantRemoving:Connect(function(desc)
	if not SCRIPT_ACTIVE then return end
	if not desc then return end
	local model = nil
	if desc:IsA("Model") then
		model = desc
	elseif desc:IsA("Humanoid") and desc.Parent and desc.Parent:IsA("Model") then
		model = desc.Parent
	end
	if model then
		removeModelESP(model)
	end
end)

-- GUI START
local function createESPGui()
	if not LocalPlayer then
		warn("RakeRemastered: LocalPlayer nil — GUI requires a LocalScript (StarterPlayerScripts).")
		return
	end

	local playerGui = LocalPlayer:WaitForChild("PlayerGui")
	local screen = Instance.new("ScreenGui")
	screen.Name = "RakeRemasteredUI"
	screen.ResetOnSpawn = false
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screen.IgnoreGuiInset = true
	screen.Parent = playerGui

	SCREEN_GUI = screen

	local SETTINGS_FILE = "rake_settings.json"

	local loadedSettings = nil

	local OBJECT_FINDER = { enabled = false }
	local TRAP_DETECTOR = { enabled = false, isBeta = true }
	local shouldEnableTrapDetector = false

	local function saveSettings(settings)
		local data = settings or {
			esp = ESP_SETTINGS,
			fov = workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70,
			pov = LocalPlayer:GetAttribute("Rake_POV") or "Default",
			playerSpeed = LocalPlayer:GetAttribute("Rake_PlayerSpeed") or 16,
			playerSpeedEnabled = LocalPlayer:GetAttribute("Rake_PlayerSpeedEnabled") or false,
			rakeKillKey = LocalPlayer:GetAttribute("Rake_RakeKillKey") or "R",
			rakeKillAuraEnabled = LocalPlayer:GetAttribute("Rake_RakeKillAuraEnabled") or false,
			buildingSettings = BUILDING_SETTINGS,
			locationSettings = LOCATION_SETTINGS,
				locationTextBackground = LOCATION_TEXT_BG,
			rakeMeterEnabled = RAKE_METER.enabled or false,
			objectFinderEnabled = (OBJECT_FINDER and OBJECT_FINDER.enabled) or false,
			trapDetectorEnabled = (TRAP_DETECTOR and TRAP_DETECTOR.enabled) or false,
			improvedLighting = IMPROVED_LIGHTING_ENABLED or false,

			-- improvedLightingIntensity removed
		}
		local encoded = HttpService:JSONEncode(data)
		local ok, err = pcall(function()
			if writefile then
				writefile(SETTINGS_FILE, encoded)
			end
		end)
		pcall(function()
			LocalPlayer:SetAttribute("RakeSettings", encoded)
		end)
	end

	local function loadSettings()
		local loaded = nil
		local ok = false
		pcall(function()
			if isfile and isfile(SETTINGS_FILE) then
				local txt = readfile(SETTINGS_FILE)
				loaded = HttpService:JSONDecode(txt)
				ok = true
			end
		end)
		if not ok then
			pcall(function()
				local attr = LocalPlayer:GetAttribute("RakeSettings")
				if attr then
					loaded = HttpService:JSONDecode(attr)
				end
			end)
		end
		return loaded
	end

	local DEFAULT_WALK_SPEED = 16
	local playerSpeed = LocalPlayer:GetAttribute("Rake_PlayerSpeed") or DEFAULT_WALK_SPEED
	local playerSpeedEnabled = false
	pcall(function() LocalPlayer:SetAttribute("Rake_PlayerSpeedEnabled", false) end)

	-- Rake kill-aura defaults (top-level so other code can read updated value)
	local rakeKillKey = LocalPlayer:GetAttribute("Rake_RakeKillKey") or "R"
	local rakeKillAuraEnabled = false
	pcall(function() LocalPlayer:SetAttribute("Rake_RakeKillAuraEnabled", false) end)


	local speedEnforceHumConn = nil
	local speedEnforceHeartbeat = nil
	local speedEnforceRenderConn = nil
	local function stopSpeedEnforce()
		if speedEnforceHumConn then
			speedEnforceHumConn:Disconnect()
			speedEnforceHumConn = nil
		end
		if speedEnforceHeartbeat then
			speedEnforceHeartbeat:Disconnect()
			speedEnforceHeartbeat = nil
		end
		if speedEnforceRenderConn then
			speedEnforceRenderConn:Disconnect()
			speedEnforceRenderConn = nil
		end
	end

	local function enforceHumanoid(hum)
		stopSpeedEnforce()
		if not hum then return end
		pcall(function() hum.WalkSpeed = playerSpeed end)
		speedEnforceHumConn = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			if not hum or not hum.Parent then
				stopSpeedEnforce()
				return
			end
			if hum.WalkSpeed ~= playerSpeed then
				pcall(function() hum.WalkSpeed = playerSpeed end)
			end
		end)
		speedEnforceHeartbeat = RunService.Heartbeat:Connect(function(dt)
			if not hum or not hum.Parent then
				stopSpeedEnforce()
				return
			end
			-- ensure WalkSpeed
			if hum.WalkSpeed ~= playerSpeed then
				pcall(function() hum.WalkSpeed = playerSpeed end)
			end
			-- try to maintain movement velocity to avoid server rectification
			local hrp = hum.Parent:FindFirstChild("HumanoidRootPart")
			if hrp then
				local moveDir = hum.MoveDirection or Vector3.new(0,0,0)
				if moveDir.Magnitude > 0.001 then
					local desiredVel = moveDir.Unit * playerSpeed
					-- set assembly velocity to desired (preserve vertical velocity)
					pcall(function()
						local av = hrp.AssemblyLinearVelocity
						hrp.AssemblyLinearVelocity = Vector3.new(desiredVel.X, av.Y, desiredVel.Z)
					end)
					-- simple prediction and correction for large rollback
					local predicted = hrp.Position + desiredVel * math.clamp(dt, 0, 0.1)
					local rollbackDist = (hrp.Position - predicted).Magnitude
					if rollbackDist > 2 then
						pcall(function()
							hrp.CFrame = CFrame.new(predicted, predicted + hrp.CFrame.LookVector)
						end)
					end
				else
					-- stationary: reduce horizontal velocity
					pcall(function()
						local av = hrp.AssemblyLinearVelocity
						if av then
							hrp.AssemblyLinearVelocity = Vector3.new(0, av.Y, 0)
						end
					end)
				end
			end
		end)

		-- stronger enforcement on RenderStepped to try to avoid quick server rectification
		speedEnforceRenderConn = RunService.RenderStepped:Connect(function(dt)
			if not hum or not hum.Parent then
				stopSpeedEnforce()
				return
			end
			local hrp = hum.Parent:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			local moveDir = hum.MoveDirection or Vector3.new(0,0,0)
			if moveDir.Magnitude > 0.001 then
				local desiredVel = moveDir.Unit * playerSpeed
				pcall(function()
					local av = hrp.AssemblyLinearVelocity
					hrp.AssemblyLinearVelocity = Vector3.new(desiredVel.X, av and av.Y or 0, desiredVel.Z)
				end)
				-- immediate small-step teleport toward predicted position to fight rectification
				local step = math.clamp(dt, 0, 0.06)
				local predicted = hrp.Position + desiredVel * step
				pcall(function()
					hrp.CFrame = CFrame.new(predicted, predicted + hrp.CFrame.LookVector)
				end)
			else
				pcall(function()
					local av = hrp.AssemblyLinearVelocity
					if av then hrp.AssemblyLinearVelocity = Vector3.new(0, av.Y, 0) end
				end)
			end
		end)
	end


	local cameraLoopConn, mouseConn = nil, nil
	local rakeKillConn = nil
	local shiftConnB, shiftConnE = nil, nil
	local shiftLockActive = false
	local prevAutoRotate = nil
	local function stopCameraLoop()
		if cameraLoopConn then
			cameraLoopConn:Disconnect()
			cameraLoopConn = nil
		end
		if mouseConn then
			mouseConn:Disconnect()
			mouseConn = nil
		end
		if shiftConnB then
			shiftConnB:Disconnect()
			shiftConnB = nil
		end
		if shiftConnE then
			shiftConnE:Disconnect()
			shiftConnE = nil
		end
		shiftLockActive = false
		prevAutoRotate = nil
		pcall(function() UserInputService.MouseBehavior = Enum.MouseBehavior.Default end)
	end

	local lastHumanoid = nil
	local lastHumanoidOffset = nil
	local function restoreHumanoidOffset()
		if lastHumanoid and lastHumanoid.Parent and lastHumanoid:IsA("Humanoid") then
			pcall(function()
				local target = lastHumanoidOffset or Vector3.new(0,0,0)
				local ok, tween = pcall(function()
					return TweenService:Create(lastHumanoid, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CameraOffset = target})
				end)
				if ok and tween then pcall(function() tween:Play() end) end
			end)
		end
		lastHumanoid = nil
		lastHumanoidOffset = nil
	end

	local function applyPOV(opt)
		if not opt then return end
		pcall(function() LocalPlayer:SetAttribute("Rake_POV", opt) end)
		stopCameraLoop()

		local cam = workspace.CurrentCamera
		if not cam then return end

		local char = LocalPlayer.Character
		local humanoid = char and char:FindFirstChildOfClass("Humanoid")

		if opt == "Third" then
			pcall(function() LocalPlayer.CameraMode = Enum.CameraMode.Classic end)
			cam.CameraType = Enum.CameraType.Scriptable
			restoreHumanoidOffset()

			local yaw = 0
			local pitch = 0
			local sensitivity = 0.12
			local distance = 6
			local height = 2.5

			mouseConn = UserInputService.InputChanged:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseMovement then
					yaw = yaw - inp.Delta.X * sensitivity
					pitch = math.clamp(pitch - inp.Delta.Y * sensitivity, -60, 60)
				end
			end)

			shiftConnB = UserInputService.InputBegan:Connect(function(input, gproc)
				if gproc then return end
				if input.KeyCode == Enum.KeyCode.LeftShift then
					shiftLockActive = true
					local ch = LocalPlayer.Character
					local hum = ch and ch:FindFirstChildOfClass("Humanoid")
					if hum then
						prevAutoRotate = hum.AutoRotate
						pcall(function() hum.AutoRotate = false end)
					end
					pcall(function() UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter end)
				end
			end)
			shiftConnE = UserInputService.InputEnded:Connect(function(input, gproc)
				if gproc then return end
				if input.KeyCode == Enum.KeyCode.LeftShift then
					shiftLockActive = false
					local ch = LocalPlayer.Character
					local hum = ch and ch:FindFirstChildOfClass("Humanoid")
					if hum and prevAutoRotate ~= nil then
						pcall(function() hum.AutoRotate = prevAutoRotate end)
					end
					prevAutoRotate = nil
					pcall(function() UserInputService.MouseBehavior = Enum.MouseBehavior.Default end)
				end
			end)

			cameraLoopConn = RunService.RenderStepped:Connect(function()
				local ch = LocalPlayer.Character
				if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
				local hrp = ch.HumanoidRootPart
				local target = hrp.Position + Vector3.new(0, height, 0)

				local baseDir = -hrp.CFrame.LookVector
				local baseOffset = baseDir * distance
				local rotated = (CFrame.Angles(0, math.rad(yaw), 0) * baseOffset)
				local camPos = target + rotated + Vector3.new(0, pitch * 0.03, 0)
				cam.CFrame = CFrame.new(camPos, target + Vector3.new(0, pitch * 0.03, 0))

				local look = (cam.CFrame.LookVector)
				local lookH = Vector3.new(look.X, 0, look.Z)
				if lookH.Magnitude > 0.001 then
					local desired = CFrame.new(hrp.Position, hrp.Position + lookH)
					if shiftLockActive then
						hrp.CFrame = desired
					else
						hrp.CFrame = hrp.CFrame:Lerp(desired, 0.15)
					end
				end
			end)

		else
			pcall(function() LocalPlayer.CameraMode = Enum.CameraMode.Classic end)
			cam.CameraType = Enum.CameraType.Custom
			if humanoid then
				cam.CameraSubject = humanoid
			end
			restoreHumanoidOffset()
		end
	end

	-- Load saved settings
	do
		local s = loadSettings()
		loadedSettings = s
		if s then
			if s.esp then
				ESP_SETTINGS.showRake = false
				ESP_SETTINGS.showPlayers = false
			end
			if s.fov and workspace.CurrentCamera then
				pcall(function() workspace.CurrentCamera.FieldOfView = s.fov end)
			end
			pcall(function() LocalPlayer:SetAttribute("Rake_POV", "Default") end)
			if s.playerSpeed then
				playerSpeed = s.playerSpeed
				pcall(function() LocalPlayer:SetAttribute("Rake_PlayerSpeed", s.playerSpeed) end)
			end
			if s.rakeKillKey then
				rakeKillKey = s.rakeKillKey
				pcall(function() LocalPlayer:SetAttribute("Rake_RakeKillKey", s.rakeKillKey) end)
			end
			if s.rakeKillAuraEnabled ~= nil then
				rakeKillAuraEnabled = false
				pcall(function() LocalPlayer:SetAttribute("Rake_RakeKillAuraEnabled", false) end)
			end
			if s.rakeKillKey then
				pcall(function() LocalPlayer:SetAttribute("Rake_RakeKillKey", s.rakeKillKey) end)
			end
			if s.rakeKillAuraEnabled ~= nil then
				pcall(function() LocalPlayer:SetAttribute("Rake_RakeKillAuraEnabled", false) end)
			end
			-- Always start all persisted feature toggles disabled, even if an older
			-- settings file or LocalPlayer attribute saved them as enabled.
			for k in pairs(BUILDING_SETTINGS) do BUILDING_SETTINGS[k] = false end
			for k in pairs(LOCATION_SETTINGS) do LOCATION_SETTINGS[k] = false end
			LOCATION_TEXT_BG = false
			RAKE_METER.enabled = false
			IMPROVED_LIGHTING_ENABLED = false
			shouldEnableTrapDetector = false
			-- Feature activation states are intentionally not restored from config.
		end
	end

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 900, 0, 600)
	mainFrame.Position = UDim2.new(0.5, -450, 0.06, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 205)
	mainFrame.BackgroundTransparency = 0.06
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screen

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 10)
	mainCorner.Parent = mainFrame

	local mainGrad = Instance.new("UIGradient")
	mainGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(245,245,245)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(210,210,215)),
	}
	mainGrad.Rotation = 45
	mainGrad.Parent = mainFrame

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = Color3.fromRGB(160,160,165)
	mainStroke.Transparency = 0.25
	mainStroke.Thickness = 2
	mainStroke.Parent = mainFrame

	-- Make the panel draggable
	mainFrame.Active = true
	local dragging = false
	local dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	mainFrame.InputBegan:Connect(function(input)
		if not isDragable then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	mainFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)

	-- Top bar
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 36)
	topBar.BackgroundTransparency = 0.12
	topBar.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
	topBar.Parent = mainFrame

	local homeBtn = Instance.new("TextButton")
	homeBtn.Name = "HomeButton"
	homeBtn.Size = UDim2.new(0, 100, 1, 0)
	homeBtn.Position = UDim2.new(0, 8, 0, 0)
	homeBtn.BackgroundTransparency = 0
	homeBtn.BackgroundColor3 = Color3.fromRGB(38,38,45)
	homeBtn.AutoButtonColor = false
	homeBtn.Text = "Home"
	homeBtn.TextColor3 = Color3.fromRGB(230,230,235)
	homeBtn.Font = Enum.Font.GothamBold
	homeBtn.TextSize = 18
	homeBtn.TextStrokeTransparency = 1
	homeBtn.Parent = topBar

	local visualsBtn = Instance.new("TextButton")
	visualsBtn.Name = "VisualsButton"
	visualsBtn.Size = UDim2.new(0, 100, 1, 0)
	visualsBtn.Position = UDim2.new(0, 116, 0, 0)
	visualsBtn.BackgroundTransparency = 0
	visualsBtn.BackgroundColor3 = Color3.fromRGB(38,38,45)
	visualsBtn.AutoButtonColor = false
	visualsBtn.Text = "Visuals"
	visualsBtn.TextColor3 = Color3.fromRGB(230,230,235)
	visualsBtn.Font = Enum.Font.GothamBold
	visualsBtn.TextSize = 18
	visualsBtn.TextStrokeTransparency = 1
	visualsBtn.Parent = topBar

	local playerBtn = Instance.new("TextButton")
	playerBtn.Name = "PlayerButton"
	playerBtn.Size = UDim2.new(0, 100, 1, 0)
	playerBtn.Position = UDim2.new(0, 224, 0, 0)
	playerBtn.BackgroundTransparency = 0
	playerBtn.BackgroundColor3 = Color3.fromRGB(38,38,45)
	playerBtn.AutoButtonColor = false
	playerBtn.Text = "Player"
	playerBtn.TextColor3 = Color3.fromRGB(230,230,235)
	playerBtn.Font = Enum.Font.GothamBold
	playerBtn.TextSize = 18
	playerBtn.TextStrokeTransparency = 1
	playerBtn.Parent = topBar

	-- Game tab 
	local gameBtn = Instance.new("TextButton")
	gameBtn.Name = "GameButton"
	gameBtn.Size = UDim2.new(0, 100, 1, 0)
	gameBtn.Position = UDim2.new(0, 332, 0, 0)
	gameBtn.BackgroundTransparency = 0
	gameBtn.BackgroundColor3 = Color3.fromRGB(38,38,45)
	gameBtn.AutoButtonColor = false
	gameBtn.Text = "Game"
	gameBtn.TextColor3 = Color3.fromRGB(230,230,235)
	gameBtn.Font = Enum.Font.GothamBold
	gameBtn.TextSize = 18
	gameBtn.TextStrokeTransparency = 1
	gameBtn.Parent = topBar

	local hbCorner = Instance.new("UICorner")
	hbCorner.Parent = homeBtn
	local vbCorner = Instance.new("UICorner")
	vbCorner.Parent = visualsBtn
	local pbCorner = Instance.new("UICorner")
	pbCorner.Parent = playerBtn

	local function addTabStroke(b)
		local s = Instance.new("UIStroke")
		s.Parent = b
		s.Color = Color3.fromRGB(64,64,70)
		s.Transparency = 0.6
		s.Thickness = 1
	end
	addTabStroke(homeBtn)
	addTabStroke(visualsBtn)
	addTabStroke(playerBtn)
	addTabStroke(gameBtn)

	local _okTween = false
	pcall(function() _okTween = (TweenService ~= nil) end)
	local _tabTweens = {}
	local function addTabHover(btn)
		local baseSize = btn.TextSize or 18
		local baseTrans = btn.BackgroundTransparency or 0
		btn.MouseEnter:Connect(function()
			pcall(function()
				if _okTween and TweenService then
					if _tabTweens[btn] then _tabTweens[btn]:Cancel() end
					_tabTweens[btn] = TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = math.max(0, baseTrans - 0.06), TextSize = baseSize + 1})
					_tabTweens[btn]:Play()
				else
					btn.BackgroundTransparency = math.max(0, baseTrans - 0.06)
					btn.TextSize = baseSize + 1
				end
			end)
		end)
		btn.MouseLeave:Connect(function()
			pcall(function()
				if _okTween and TweenService then
					if _tabTweens[btn] then _tabTweens[btn]:Cancel() end
					_tabTweens[btn] = TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = baseTrans, TextSize = baseSize})
					_tabTweens[btn]:Play()
				else
					btn.BackgroundTransparency = baseTrans
					btn.TextSize = baseSize
				end
			end)
		end)
	end

	addTabHover(homeBtn)
	addTabHover(visualsBtn)
	addTabHover(playerBtn)
	addTabHover(gameBtn)

	-- Tab indicator (underlines active tab)
	local tabIndicator = Instance.new("Frame")
	tabIndicator.Name = "TabIndicator"
	tabIndicator.Size = UDim2.new(0, 96, 0, 3)
	tabIndicator.Position = UDim2.new(0, homeBtn.Position.X.Offset, 1, -3)
	tabIndicator.AnchorPoint = Vector2.new(0,0)
	tabIndicator.BackgroundColor3 = Color3.fromRGB(150,8,8)
	tabIndicator.Parent = topBar

	local tabIndicatorCorner = Instance.new("UICorner")
	tabIndicatorCorner.CornerRadius = UDim.new(0, 4)
	tabIndicatorCorner.Parent = tabIndicator

	-- Close button (top right pos)
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Size = UDim2.new(0, 36, 0, 28)
	closeBtn.Position = UDim2.new(1, -44, 0, 4)
	closeBtn.AnchorPoint = Vector2.new(0, 0)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 18
	closeBtn.Text = "X"
	closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
	closeBtn.TextStrokeTransparency = 1
	closeBtn.Parent = topBar

	closeBtn.MouseEnter:Connect(function()
		pcall(function() closeBtn.TextColor3 = Color3.fromRGB(255,80,80) end)
	end)
	closeBtn.MouseLeave:Connect(function()
		pcall(function() closeBtn.TextColor3 = Color3.fromRGB(255,255,255) end)
	end)

	-- Unload
	local function unloadScript()
		pcall(function()
			SCRIPT_ACTIVE = false
			-- stop local enforced systems
			pcall(stopSpeedEnforce)
			pcall(stopCameraLoop)
			-- disable feature modules first
			pcall(function() if OBJECT_FINDER and OBJECT_FINDER.enabled then disableObjectFinder() end end)
			pcall(function() if TRAP_DETECTOR and TRAP_DETECTOR.enabled then disableTrapDetector() end end)
			-- disable meters/markers created by the script
			pcall(disableRakeMeter)
			pcall(disableLocationMarkers)
			pcall(destroyRakeProximityGui)
			TIMER_POWER.enabled = false
			pcall(NIGHT_VISION.disable)
			pcall(FLASHLIGHT_MODIFY.disable)
			pcall(HIDE_UNDER_FLOOR.disable)
			pcall(TIMER_POWER.destroy)
			-- unbind any ContextActionService
			local CAS = ContextActionService
			pcall(function() CAS:UnbindAction("RakeKillToggleAction") end)
			-- disconnect stored global connections
			pcall(function()
				if playersPlayerAddedConn then playersPlayerAddedConn:Disconnect() playersPlayerAddedConn = nil end
				if workspaceChildAddedConn then workspaceChildAddedConn:Disconnect() workspaceChildAddedConn = nil end
				if workspaceDescendantAddedConn then workspaceDescendantAddedConn:Disconnect() workspaceDescendantAddedConn = nil end
				if workspaceDescendantRemovingConn then workspaceDescendantRemovingConn:Disconnect() workspaceDescendantRemovingConn = nil end
			end)
			-- stop power watcher if present
			pcall(function()
				if _G and _G._POWER_WATCHER and _G._POWER_WATCHER.stop then
					pcall(_G._POWER_WATCHER.stop)
					_G._POWER_WATCHER = nil
				end
			end)
			-- stop FOV enforce if present
			pcall(function() if stopFovEnforce then pcall(stopFovEnforce) end end)
			-- stop day/night watcher if present
			pcall(function()
				if _G and _G._DAY_TIMER and _G._DAY_TIMER.stop then
					pcall(_G._DAY_TIMER.stop)
					_G._DAY_TIMER = nil
				end
			end)
			-- stop trapless watcher if present
			pcall(function()
				if _G and _G._TRAPLESS and _G._TRAPLESS.stop then
					pcall(_G._TRAPLESS.stop)
					_G._TRAPLESS = nil
				end
			end)

			pcall(function() if rakeKillConn then rakeKillConn:Disconnect() rakeKillConn = nil end end)
			pcall(function()
				if OBJECT_FINDER and OBJECT_FINDER.connections then
					for _,c in pairs(OBJECT_FINDER.connections) do pcall(function() if c and c.Disconnect then c:Disconnect() end end) end
				end
				if TRAP_DETECTOR and TRAP_DETECTOR.connections then
					for _,c in pairs(TRAP_DETECTOR.connections) do pcall(function() if c and c.Disconnect then c:Disconnect() end end) end
				end
			end)
			-- remove highlights, name tags, and category tags
			pcall(function()
				for _,inst in pairs(Workspace:GetDescendants()) do
					-- remove ESP highlights/name tags/categories by name
					if inst and (inst.Name == "ESP_Highlight" or inst.Name == "ESP_Name" or inst.Name == "ESP_Category") then
						pcall(function() inst:Destroy() end)
					end
					-- destroy other highlights created by features (heuristic)
					if inst and inst:IsA("Highlight") then
						local ok, ft, dm = pcall(function() return inst.FillTransparency, inst.DepthMode end)
						if ok and (ft == 0.8 or ft == 0.7 or dm == Enum.HighlightDepthMode.AlwaysOnTop) then
							pcall(function() inst:Destroy() end)
						end
					end
					-- destroy cluster/world parts created by object finder
					if inst and inst.Name == "ObjectClusterPart" then
						pcall(function() inst:Destroy() end)
					end
					-- remove location world parts
					if inst and inst:IsA("BasePart") and tostring(inst.Name):sub(1,8) == "LocPart_" then
						inst:Destroy()
					end
				end
			end)
			-- destroy any remaining ScreenGuis created by this script
			pcall(function()
				local pg = LocalPlayer:FindFirstChild("PlayerGui")
				if pg then
					for _,g in pairs(pg:GetChildren()) do
						if g:IsA("ScreenGui") then
							local n = tostring(g.Name)
							if n:match("Rake") or n:match("CloseConfirmOverlay") then
								g:Destroy()
							end
						end
					end
				end
			end)
			-- also destroy the main SCREEN_GUI 
			pcall(function()
				if SCREEN_GUI then
					if SCREEN_GUI.Parent then
						SCREEN_GUI:Destroy()
					end
					SCREEN_GUI = nil
				end
				-- remove any similarly named guis in CoreGui just in case
				local cg = CoreGui
				for _,g in pairs(cg:GetChildren()) do
					if g:IsA("ScreenGui") then
						local n = tostring(g.Name)
						if n:match("Rake") or n:match("CloseConfirmOverlay") then
							pcall(function() g:Destroy() end)
						end
					end
				end
			end)
			-- ensure any NameTag/ClusterTag/TrapNameTag billboards under PlayerGui/CoreGui are removed
			pcall(function()
				local function removeBillboards(parent)
					for _,c in pairs(parent:GetDescendants()) do
						if c and c:IsA("BillboardGui") and (c.Name == "NameTag" or c.Name == "ClusterTag" or c.Name == "TrapNameTag") then
							pcall(function() c:Destroy() end)
						end
					end
				end
				local pg = LocalPlayer:FindFirstChild("PlayerGui")
				if pg then removeBillboards(pg) end
				local cg = CoreGui
				if cg then removeBillboards(cg) end
			end)

			-- ensure player-specific ESP artifacts are removed
			pcall(function()
				for _,pl in pairs(Players:GetPlayers()) do
					local ch = pl.Character
					if ch then
						-- remove named children
						removeModelESP(ch)
						-- remove Highlight instances adorning this character
						for _,h in pairs(ch:GetDescendants()) do
							if h and h:IsA("Highlight") then pcall(function() h:Destroy() end) end
						end
					end
				end
				-- also remove Highlights in workspace that adorn player models
				for _,inst in pairs(Workspace:GetDescendants()) do
					if inst and inst:IsA("Highlight") then
						local ok, ad = pcall(function() return inst.Adornee end)
						if ok and ad and ad:IsA("Model") then
							local player = Players:GetPlayerFromCharacter(ad)
							if player then pcall(function() inst:Destroy() end) end
						end
					end
				end
			end)
			-- disconnect remaining anonymous connections
			pcall(function()
				if insertToggleConn then insertToggleConn:Disconnect() insertToggleConn = nil end
				if localPlayerCharAddedConn then localPlayerCharAddedConn:Disconnect() localPlayerCharAddedConn = nil end
				if localPlayerRespawnConn then localPlayerRespawnConn:Disconnect() localPlayerRespawnConn = nil end
			end)
			-- disable improved lighting listener
			pcall(function() disableImprovedLighting() end)
			-- attempt to clear attributes
			pcall(function()
				LocalPlayer:SetAttribute("RakeSettings", nil)
			end)
		end)
	end

	-- Confirmation modal creator
	local function showCloseConfirmation()
		local overlay = Instance.new("Frame")
		overlay.Name = "CloseConfirmOverlay"
		overlay.Size = UDim2.fromScale(1, 1)
		overlay.Position = UDim2.new(0, 0)
		overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
		overlay.BackgroundTransparency = 0.5
		overlay.ZIndex = 999
		overlay.Parent = SCREEN_GUI

		local box = Instance.new("Frame")
		box.Size = UDim2.new(0, 420, 0, 140)
		box.Position = UDim2.new(0.5, -210, 0.5, -70)
		box.BackgroundColor3 = Color3.fromRGB(28,28,32)
		box.ZIndex = 1000
		box.Parent = overlay

		local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0,8) corner.Parent = box

		local msg = Instance.new("TextLabel")
		msg.Size = UDim2.new(1, -24, 0, 60)
		msg.Position = UDim2.new(0, 12, 0, 12)
		msg.BackgroundTransparency = 1
		msg.Font = Enum.Font.GothamBold
		msg.TextSize = 18
		msg.TextColor3 = Color3.fromRGB(235,235,235)
		msg.Text = "Do you actually wanna close the script?"
		msg.TextWrapped = true
		msg.Parent = box

		local yesBtn = Instance.new("TextButton")
		yesBtn.Size = UDim2.new(0, 160, 0, 36)
		yesBtn.Position = UDim2.new(0.5, -170, 1, -52)
		yesBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
		yesBtn.Text = "Yes"
		yesBtn.Font = Enum.Font.GothamBold
		yesBtn.TextSize = 16
		yesBtn.TextColor3 = Color3.fromRGB(255,255,255)
		yesBtn.ZIndex = 1001
		yesBtn.Parent = box

		local noBtn = Instance.new("TextButton")
		noBtn.Size = UDim2.new(0, 160, 0, 36)
		noBtn.Position = UDim2.new(0.5, 10, 1, -52)
		noBtn.BackgroundColor3 = Color3.fromRGB(80,80,88)
		noBtn.Text = "No"
		noBtn.Font = Enum.Font.GothamBold
		noBtn.TextSize = 16
		noBtn.TextColor3 = Color3.fromRGB(255,255,255)
		noBtn.ZIndex = 1001
		noBtn.Parent = box

		yesBtn.MouseButton1Click:Connect(function()
			pcall(unloadScript)
			overlay:Destroy()
		end)

		noBtn.MouseButton1Click:Connect(function()
			overlay:Destroy()
		end)
	end

	closeBtn.MouseButton1Click:Connect(function()
		pcall(showCloseConfirmation)
	end)

	-- bring tabs above indicator
	homeBtn.ZIndex = 2
	visualsBtn.ZIndex = 2
	playerBtn.ZIndex = 2
	gameBtn.ZIndex = 2
	tabIndicator.ZIndex = 1

	-- Content
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, 0, 1, -36)
	content.Position = UDim2.new(0, 0, 0, 36)
	content.BackgroundTransparency = 1
	content.Parent = mainFrame
	-- Prevent off-screen child frames from showing before they slide in
	content.ClipsDescendants = true
	mainFrame.ClipsDescendants = true

	-- Home
	local homeSection = Instance.new("Frame")
	homeSection.Name = "HomeSection"
	homeSection.Size = UDim2.new(1, 0, 1, 0)
	homeSection.Position = UDim2.new(0, 0, 0, 0)
	homeSection.Parent = content

	local homeCard = Instance.new("Frame")
	homeCard.Name = "HomeCard"
	homeCard.Size = UDim2.new(1, -24, 0, 260)
	homeCard.Position = UDim2.new(0, 12, 0, 8)
	homeCard.BackgroundColor3 = Color3.fromRGB(30,30,36)
	homeCard.BackgroundTransparency = 0
	homeCard.Parent = homeSection

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 10)
	cardCorner.Parent = homeCard

	local cardStroke = Instance.new("UIStroke")
	cardStroke.Color = Color3.fromRGB(50,50,60)
	cardStroke.Transparency = 0.5
	cardStroke.Thickness = 1
	cardStroke.Parent = homeCard

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -24, 0, 30)
	title.Position = UDim2.new(0, 12, 0, 8)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.Text = "Welcome"
	title.TextColor3 = Color3.fromRGB(245,245,245)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = homeCard

	local body = Instance.new("TextLabel")
	body.Size = UDim2.new(1, -24, 0, 120)
	body.Position = UDim2.new(0, 12, 0, 44)
	body.BackgroundTransparency = 1
	body.Font = Enum.Font.Gotham
	body.TextSize = 14
	body.TextWrapped = true
	body.Text = "Hii there! First of all, I hope you'll have a nice time using my script and that you'll not face any issues while using it (Close and open this window with Insert button). Before you start, please read the tips and notes below to learn how to use this script and some notes on some issues.\n\nNotes: the FOV might not work in this game now, but I'll sure try to fix it later. The third pov might be a bit buggy now, but it works, so be careful about how you use it!\n\nHope you have a nice time!!"
	body.TextColor3 = Color3.fromRGB(220,220,225)
	body.TextXAlignment = Enum.TextXAlignment.Left
	body.Parent = homeCard

	-- Tips list (rendered inside a vertical layout for consistent spacing)
	local tips = {
		"Tip 1. If Player speed is enabled, keep it down to 12-14 so the system doesn't think your movement is bugged and teleports you back.",
		"Tip 2. Use the location markers to find important locations across the map.",
		"Tip 3. Use the highlights (ESP) to find out where Rake and other players are.",
		"Tip 4. Use the object finder to locate important items in the game world.",
		"Tip 5. This game doesn't have an actual proper anti-cheat lol.",
		"Tip 6. SH Bypass and TD Bypass is \"Safe House Door Bypass\" and \"Tower Door Bypass\" nice to know right?",
		"Tip 7. Join my Discord server for updates on this script, and other useful apps. Press the button below to get invited."
	}


	-- container for tips so layout is consistent and easier to style
	local tipsContainer = Instance.new("Frame")
	tipsContainer.Name = "TipsContainer"
	tipsContainer.Size = UDim2.new(1, -56, 0, #tips * 22)
	tipsContainer.Position = UDim2.new(0, 28, 0, 168)
	tipsContainer.BackgroundTransparency = 1
	tipsContainer.Parent = homeCard

	local tipsLayout = Instance.new("UIListLayout")
	tipsLayout.Parent = tipsContainer
	tipsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tipsLayout.Padding = UDim.new(0, 6)

	for i, t in ipairs(tips) do
		local tl = Instance.new("TextLabel")
		tl.Size = UDim2.new(1, 0, 0, 20)
		tl.BackgroundTransparency = 1
		tl.Font = Enum.Font.Gotham
		tl.TextSize = 13
		tl.Text = "• " .. t
		tl.TextColor3 = Color3.fromRGB(200,200,205)
		tl.TextXAlignment = Enum.TextXAlignment.Left
		tl.LayoutOrder = i
		tl.Parent = tipsContainer
	end

	-- reposition homeCard to fit tips + button
	local tipsCount = #tips
	local cardHeight = 44 + 120 + tipsCount * 22 + 72
	homeCard.Size = UDim2.new(1, -24, 0, cardHeight)

	-- Discord invite button (round, bluish)
	local discordBtn = Instance.new("TextButton")
	discordBtn.Name = "DiscordInvite"
	discordBtn.Size = UDim2.new(0, 200, 0, 36)
	discordBtn.Position = UDim2.new(0, 18, 0, 168 + tipsCount * 22 + 16)
	discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	discordBtn.TextColor3 = Color3.fromRGB(255,255,255)
	discordBtn.Font = Enum.Font.GothamBold
	discordBtn.TextSize = 16
	discordBtn.Text = "Join Discord"
	discordBtn.AutoButtonColor = false
	discordBtn.Active = true
	discordBtn.ZIndex = 5
	discordBtn.Parent = homeCard

	local dCorner = Instance.new("UICorner")
	dCorner.CornerRadius = UDim.new(0, 18)
	dCorner.Parent = discordBtn

	local dStroke = Instance.new("UIStroke")
	dStroke.Color = Color3.fromRGB(70,80,220)
	dStroke.Transparency = 0.2
	dStroke.Parent = discordBtn

	local dGrad = Instance.new("UIGradient")
	dGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(96,110,248)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(72,86,238)),
	})
	dGrad.Rotation = 90
	dGrad.Parent = discordBtn

	-- hover animation
	local okT, _ = pcall(function() return TweenService end)
	local hoverTween = nil
	discordBtn.MouseEnter:Connect(function()
		pcall(function()
			if okT and TweenService then
				if hoverTween then hoverTween:Cancel() end
				hoverTween = TweenService:Create(discordBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(104,119,252)})
				hoverTween:Play()
			else
				discordBtn.BackgroundColor3 = Color3.fromRGB(104,119,252)
			end
		end)
	end)
	discordBtn.MouseLeave:Connect(function()
		pcall(function()
			if okT and TweenService then
				if hoverTween then hoverTween:Cancel() end
				hoverTween = TweenService:Create(discordBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(88,101,242)})
				hoverTween:Play()
			else
				discordBtn.BackgroundColor3 = Color3.fromRGB(88,101,242)
			end
		end)
	end)

	-- confirmation label
	local conf = Instance.new("TextLabel")
	conf.Size = UDim2.new(0, 260, 0, 28)
	conf.Position = UDim2.new(0, 230, 0, discordBtn.Position.Y.Offset - 4)
	conf.BackgroundTransparency = 1
	conf.Font = Enum.Font.Gotham
	conf.TextSize = 14
	conf.TextColor3 = Color3.fromRGB(200,200,200)
	conf.Text = ""
	conf.TextXAlignment = Enum.TextXAlignment.Left
	conf.Visible = false
	conf.Parent = homeCard

	discordBtn.MouseButton1Click:Connect(function()
		local url = "https://discord.gg/8At8X7YuKC"
		local browserService = GuiService
		local ok2 = browserService ~= nil
		local opened = false
		if ok2 and browserService and browserService.OpenBrowserWindow then
			local ok3 = pcall(function() browserService:OpenBrowserWindow(url) end)
			opened = ok3
		end
		if opened then
			conf.Text = "Invite opened in your browser"
			conf.Visible = true
			task.delay(2, function() pcall(function() conf.Visible = false end) end)
			return
		end
		-- fallback: show link panel with copy / retry open
		local panel = homeCard:FindFirstChild("InvitePanel")
		if panel then panel:Destroy() end
		panel = Instance.new("Frame")
		panel.Name = "InvitePanel"
		panel.Size = UDim2.new(0, 380, 0, 56)
		-- position the panel directly below the Discord button inside the card
		local btnY = discordBtn.Position.Y.Offset
		local btnH = discordBtn.Size.Y.Offset
		panel.Position = UDim2.new(0, 18, 0, btnY + btnH + 8)
		panel.BackgroundColor3 = Color3.fromRGB(24,24,28)
		panel.ZIndex = (homeCard.ZIndex or 1) + 5
		panel.Parent = homeCard

		local pCorner = Instance.new("UICorner") pCorner.CornerRadius = UDim.new(0,6) pCorner.Parent = panel
		local pStroke = Instance.new("UIStroke") pStroke.Color = Color3.fromRGB(40,40,48) pStroke.Transparency = 0.6 pStroke.Parent = panel

		local tb = Instance.new("TextBox")
		tb.Size = UDim2.new(1, -220, 1, -12)
		tb.Position = UDim2.new(0, 8, 0, 6)
		tb.Text = url
		tb.ClearTextOnFocus = false
		tb.TextEditable = false
		tb.Font = Enum.Font.Gotham
		tb.TextSize = 14
		tb.TextColor3 = Color3.fromRGB(220,220,220)
		tb.BackgroundTransparency = 1
		tb.Parent = panel

		local copyBtn = Instance.new("TextButton")
		copyBtn.Size = UDim2.new(0, 80, 0, 36)
		copyBtn.Position = UDim2.new(1, -198, 0, 10)
		copyBtn.Text = "Copy"
		copyBtn.Font = Enum.Font.GothamBold
		copyBtn.TextSize = 14
		copyBtn.BackgroundColor3 = Color3.fromRGB(80,80,88)
		copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
		copyBtn.Parent = panel
		local cbCorner = Instance.new("UICorner") cbCorner.CornerRadius = UDim.new(0,6) cbCorner.Parent = copyBtn

		local openBtn = Instance.new("TextButton")
		openBtn.Size = UDim2.new(0, 100, 0, 36)
		openBtn.Position = UDim2.new(1, -104, 0, 10)
		openBtn.Text = "Open"
		openBtn.Font = Enum.Font.GothamBold
		openBtn.TextSize = 14
		openBtn.BackgroundColor3 = Color3.fromRGB(60,60,68)
		openBtn.TextColor3 = Color3.fromRGB(255,255,255)
		openBtn.Parent = panel
		local obCorner = Instance.new("UICorner") obCorner.CornerRadius = UDim.new(0,6) obCorner.Parent = openBtn

		local function tryCopy()
			local okc, err = pcall(function() setclipboard(url) end)
			conf.Text = okc and "Link copied to clipboard" or "Could not copy link"
			conf.Visible = true
			task.delay(2, function() pcall(function() conf.Visible = false end) end)
		end

		copyBtn.MouseButton1Click:Connect(tryCopy)
		openBtn.MouseButton1Click:Connect(function()
			local browserService = GuiService
			local ok3 = browserService ~= nil
			if ok3 and browserService and browserService.OpenBrowserWindow then
				local ok4 = pcall(function() browserService:OpenBrowserWindow(url) end)
				if ok4 then
					conf.Text = "Invite opened in your browser"
					conf.Visible = true
					task.delay(2, function() pcall(function() conf.Visible = false end) end)
					panel:Destroy()
					return
				end
			end
			tryCopy()
		end)

		-- allow clicking outside to close (clicking the button again toggles)
		discordBtn.MouseButton1Click:Wait()
	end)

	-- Visuals (split layout)
	local visualsSection = Instance.new("Frame")
	visualsSection.Name = "VisualsSection"
	visualsSection.Size = UDim2.new(1, 0, 1, 0)
	visualsSection.Visible = true
	visualsSection.Position = UDim2.new(1, 0, 0, 0)
	visualsSection.BackgroundTransparency = 1
	visualsSection.Parent = content

	-- Player section
	local playerSection = Instance.new("Frame")
	playerSection.Name = "PlayerSection"
	playerSection.Size = UDim2.new(1, 0, 1, 0)
	playerSection.Visible = true
	playerSection.Position = UDim2.new(2, 0, 0, 0)
	playerSection.BackgroundTransparency = 1
	playerSection.Parent = content

	-- Game section
	local gameSection = Instance.new("Frame")
	gameSection.Name = "GameSection"
	gameSection.Size = UDim2.new(1, 0, 1, 0)
	gameSection.Visible = true
	gameSection.Position = UDim2.new(3, 0, 0, 0)
	gameSection.BackgroundTransparency = 1
	gameSection.Parent = content

	-- Player split columns (left/right) for controls
	local playerLeftCol = Instance.new("Frame")
	playerLeftCol.Name = "PlayerLeftCol"
	playerLeftCol.Size = UDim2.new(0.55, -8, 1, -8)
	playerLeftCol.Position = UDim2.new(0, 8, 0, 8)
	playerLeftCol.BackgroundTransparency = 1
	playerLeftCol.Parent = playerSection

	local playerDivider = Instance.new("Frame")
	playerDivider.Name = "PlayerDivider"
	playerDivider.Size = UDim2.new(0, 2, 1, -16)
	playerDivider.Position = UDim2.new(0.55, 0, 0, 8)
	playerDivider.BackgroundColor3 = Color3.fromRGB(170,170,170)
	playerDivider.BackgroundTransparency = 0.25
	playerDivider.Parent = playerSection

	local playerRightCol = Instance.new("Frame")
	playerRightCol.Name = "PlayerRightCol"
	playerRightCol.Size = UDim2.new(0.43, -8, 1, -8)
	playerRightCol.Position = UDim2.new(0.57, 0, 0, 8)
	playerRightCol.BackgroundTransparency = 1
	playerRightCol.Parent = playerSection



	-- Player Related header in left column
	local playerHeader = Instance.new("TextLabel")
	playerHeader.Size = UDim2.new(1, 0, 0, 24)
	playerHeader.Position = UDim2.new(0, 8, 0, 0)
	playerHeader.BackgroundTransparency = 1
	playerHeader.Font = Enum.Font.GothamBold
	playerHeader.TextSize = 18
	playerHeader.Text = "Player Related"
	playerHeader.TextColor3 = Color3.fromRGB(230,230,235)
	playerHeader.TextStrokeTransparency = 1
	playerHeader.TextXAlignment = Enum.TextXAlignment.Left
	playerHeader.Parent = playerLeftCol

	local speedLabel = Instance.new("TextLabel")
	speedLabel.Size = UDim2.new(0.7, 0, 0, 24)
	speedLabel.Position = UDim2.new(0, 8, 0, 32)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Font = Enum.Font.GothamBold
	speedLabel.TextSize = 16
	speedLabel.Text = "Player Speed"
	speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
	speedLabel.TextXAlignment = Enum.TextXAlignment.Left
	speedLabel.Parent = playerLeftCol

	local speedSlider = Instance.new("Frame")
	speedSlider.Size = UDim2.new(1, -16, 0, 24)
	speedSlider.Position = UDim2.new(0, 8, 0, 64)
	speedSlider.BackgroundTransparency = 1
	speedSlider.Parent = playerLeftCol

	local speedBarBg = Instance.new("Frame")
	speedBarBg.Size = UDim2.new(1, 0, 1, 0)
	speedBarBg.BackgroundColor3 = Color3.fromRGB(120,120,120)
	speedBarBg.BackgroundTransparency = 0.4
	speedBarBg.Parent = speedSlider

	local speedFill = Instance.new("Frame")
	speedFill.Size = UDim2.new(0.16, 0, 1, 0)
	speedFill.BackgroundColor3 = Color3.fromRGB(200,200,200)
	speedFill.Parent = speedBarBg

	local speedValueLabel = Instance.new("TextLabel")
	speedValueLabel.Size = UDim2.new(0, 48, 1, 0)
	speedValueLabel.Position = UDim2.new(1, -56, 0, 0)
	speedValueLabel.BackgroundTransparency = 1
	speedValueLabel.Font = Enum.Font.GothamBold
	speedValueLabel.TextSize = 14
	speedValueLabel.TextColor3 = Color3.fromRGB(255,255,255)
	speedValueLabel.Text = tostring(playerSpeed)
	speedValueLabel.Parent = speedSlider

	local _fracSpeed = math.clamp((playerSpeed - 8) / (100 - 8), 0, 1)
	speedFill.Size = UDim2.new(_fracSpeed, 0, 1, 0)


	local leftCol = Instance.new("Frame")
	leftCol.Name = "LeftCol"
	leftCol.Size = UDim2.new(0.55, -8, 1, -8)
	leftCol.Position = UDim2.new(0, 8, 0, 8)
	leftCol.BackgroundTransparency = 1
	leftCol.Parent = visualsSection

	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.Size = UDim2.new(0, 2, 1, -16)
	divider.Position = UDim2.new(0.55, 0, 0, 8)
	divider.BackgroundColor3 = Color3.fromRGB(170,170,170)
	divider.BackgroundTransparency = 0.25
	divider.Parent = visualsSection

	local rightCol = Instance.new("Frame")
	rightCol.Name = "RightCol"
	rightCol.Size = UDim2.new(0.43, -8, 1, -8)
	rightCol.Position = UDim2.new(0.57, 0, 0, 8)
	rightCol.BackgroundTransparency = 1
	rightCol.Parent = visualsSection

	-- Toggle helper
	local function makeToggle(parent, title, initial, onChange)
		-- Force custom ON/OFF switches to start OFF as well.
		initial = false
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, -16, 0, 40)
		frame.Position = UDim2.new(0, 8, 0, 0)
		frame.BackgroundTransparency = 1
		frame.Parent = parent

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.66, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = title
		label.Font = Enum.Font.GothamBold
		label.TextSize = 16
		label.TextColor3 = Color3.fromRGB(245, 245, 245)
		label.TextXAlignment = Enum.TextXAlignment.Left
			-- ensure label sits behind interactive parts
			label.ZIndex = 2
		label.Parent = frame

		local btnBg = Instance.new("Frame")
		btnBg.Size = UDim2.new(0.28, 0, 0.7, 0)
		btnBg.Position = UDim2.new(0.72, 0, 0.15, 0)
		btnBg.BackgroundColor3 = initial and Color3.fromRGB(140,160,180) or Color3.fromRGB(60,60,66)
		btnBg.BackgroundTransparency = 0.12
		local btnCorner = Instance.new("UICorner") btnCorner.Parent = btnBg
			-- ensure toggle background and button draw above labels
			btnBg.ZIndex = 3
			btnBg.Parent = frame

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -8, 1, -6)
		btn.Position = UDim2.new(0, 4, 0, 3)
		btn.BackgroundTransparency = 1
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 14
		btn.TextStrokeTransparency = 0
		btn.AutoButtonColor = false
			-- put the actionable text on top
			btn.ZIndex = 4
			btn.Parent = btnBg

		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 1
		stroke.Parent = btnBg

		local okT, _ = pcall(function() return TweenService end)
		local hoverTween
		btnBg.MouseEnter:Connect(function()
			pcall(function()
				if okT and TweenService then
					if hoverTween then hoverTween:Cancel() end
					hoverTween = TweenService:Create(btnBg, TweenInfo.new(0.12), {BackgroundTransparency = 0.05})
					hoverTween:Play()
				else
					btnBg.BackgroundTransparency = 0.05
				end
			end)
		end)
		btnBg.MouseLeave:Connect(function()
			pcall(function()
				if okT and TweenService then
					if hoverTween then hoverTween:Cancel() end
					hoverTween = TweenService:Create(btnBg, TweenInfo.new(0.12), {BackgroundTransparency = 0.12})
					hoverTween:Play()
				else
					btnBg.BackgroundTransparency = 0.12
				end
			end)
		end)

		local function applyToggleVisual(state)
			btn.Text = state and "ON" or "OFF"
			if state then
				btn.TextColor3 = Color3.fromRGB(255,255,255)
				-- remove stroke entirely for this toggle text so white reads cleanly
				btn.TextStrokeTransparency = 1
				stroke.Color = Color3.fromRGB(100,120,140)
				btnBg.BackgroundColor3 = Color3.fromRGB(140,160,180)
			else
				btn.TextColor3 = Color3.fromRGB(220,220,220)
				-- keep stroke removed for consistency; rely on color contrast
				btn.TextStrokeTransparency = 1
				stroke.Color = Color3.fromRGB(60,60,66)
				btnBg.BackgroundColor3 = Color3.fromRGB(60,60,66)
			end
		end

		applyToggleVisual(initial)

		btn.MouseButton1Click:Connect(function()
			initial = not initial
			applyToggleVisual(initial)
			pcall(onChange, initial)
		end)

        addBolongToggle(parent,title,initial,onChange)
		return frame
	end

	-- Small button helper (returns frame, button, and label)
	local function makeSmallButton(parent, title, onClick)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, -16, 0, 32)
		frame.Position = UDim2.new(0, 8, 0, 0)
		frame.BackgroundTransparency = 1
		frame.Parent = parent

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.66, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = title
		label.Font = Enum.Font.GothamBold
		label.TextSize = 14
		label.TextColor3 = Color3.fromRGB(245,245,245)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = frame

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.28, 0, 0, 24)
		btn.Position = UDim2.new(0.72, 0, 0, 4)
		btn.BackgroundColor3 = Color3.fromRGB(70,70,76)
		btn.AutoButtonColor = false
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 14
		btn.TextColor3 = Color3.fromRGB(230,230,235)
		btn.Text = "Change"
		local btnCorner = Instance.new("UICorner") btnCorner.Parent = btn
		btn.Parent = frame

        local section=getBolongSectionForControl(parent,title)
        if section then
            local buttonConfig={Name="Set Rake Kill Key",Title="Set Rake Kill Key",Callback=function() pcall(onClick,btn) end}
            local ok=pcall(function() section:AddButton(buttonConfig) end)
            if not ok then pcall(function() section:AddButton(buttonConfig.Name,buttonConfig.Callback) end) end
        end

		btn.MouseButton1Click:Connect(function()
			pcall(onClick, btn)
		end)

		return frame, btn, label
	end

	-- Notification helper: top-middle notification, dark grey background, white text, auto-destroy after 3s
	local function makeNotification(text)
		local parentGui = SCREEN_GUI or (LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")) or CoreGui
		if not parentGui then return end
		local name = "RakeNotificationGui"
		pcall(function()
			local existing = parentGui:FindFirstChild(name)
			if existing then existing:Destroy() end
		end)
		local sg = Instance.new("ScreenGui")
		sg.Name = name
		sg.ResetOnSpawn = false
		sg.DisplayOrder = 2000
		sg.Parent = parentGui
		local notif = Instance.new("Frame")
		notif.Name = "Notification"
		notif.Size = UDim2.new(0, 420, 0, 40)
		notif.Position = UDim2.new(0.5, -210, 0, 8)
		notif.AnchorPoint = Vector2.new(0,0)
		notif.BackgroundColor3 = Color3.fromRGB(24,24,28)
		notif.BackgroundTransparency = 0
		notif.ZIndex = 2000
		notif.Parent = sg
		local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0,8) corner.Parent = notif
		local msg = Instance.new("TextLabel")
		msg.Size = UDim2.new(1, -16, 1, 0)
		msg.Position = UDim2.new(0, 8, 0, 0)
		msg.BackgroundTransparency = 1
		msg.Font = Enum.Font.GothamBold
		msg.TextSize = 14
		msg.TextColor3 = Color3.fromRGB(255,255,255)
		msg.ZIndex = 2001
		msg.Text = text or ""
		msg.TextXAlignment = Enum.TextXAlignment.Left
		msg.TextYAlignment = Enum.TextYAlignment.Center
		msg.Parent = notif
		task.delay(3, function() pcall(function() if sg and sg.Parent then sg:Destroy() end end) end)
	end

	-- Button helper: similar layout to makeToggle but a single action button
	-- optional fourth argument `stay` when true prevents the control from being destroyed after click
	local function makeButton(parent, title, onClick, stay)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, -16, 0, 32)
		frame.Position = UDim2.new(0, 8, 0, 0)
		frame.BackgroundTransparency = 1
		frame.Parent = parent

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.66, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = title
		label.Font = Enum.Font.GothamBold
		label.TextSize = 14
		label.TextColor3 = Color3.fromRGB(245,245,245)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = frame

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.28, 0, 0, 24)
		btn.Position = UDim2.new(0.72, 0, 0, 4)
		btn.BackgroundColor3 = Color3.fromRGB(60,60,66) -- same color as toggle-off
		btn.AutoButtonColor = false
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 14
		btn.TextColor3 = Color3.fromRGB(230,230,235)
		btn.Text = "Go"
		local btnCorner = Instance.new("UICorner") btnCorner.Parent = btn
		btn.Parent = frame

		btn.MouseButton1Click:Connect(function()
			-- run provided callback
			pcall(onClick)
			-- destroy only if not told to stay
			if not stay then pcall(function() if frame and frame.Destroy then frame:Destroy() end end) end
		end)

        addBolongButton(parent,title,onClick)
		return frame, btn, label
	end

spawn(function()
	while not makeToggle do task.wait() end

	-- watcher state
	local cachedPowerValue, cachedPowerValuesFolder
	local power_current_conn, power_search_conn, power_folder_conn, power_descendant_conn
	local power_gui, power_frame, power_label
	local power_stat_label

	local function findPowerValue()
		if cachedPowerValue and cachedPowerValue.Parent then return cachedPowerValue end
		local pvFolder = ReplicatedStorage:FindFirstChild("PowerValues") or ReplicatedStorage:FindFirstChild("powervalues")
		if not pvFolder then return nil end
		cachedPowerValuesFolder = pvFolder
		local pl = pvFolder:FindFirstChild("PowerLevel") or pvFolder:FindFirstChild("powerlevel")
		if not pl then return nil end
		if pl:IsA("NumberValue") or pl:IsA("IntValue") or pl:IsA("StringValue") or pl:IsA("IntConstrainedValue") then
			cachedPowerValue = pl
			return pl
		end
		local val = pl:FindFirstChild("Value") or pl:FindFirstChild("value")
		if val and (val:IsA("NumberValue") or val:IsA("IntValue") or val:IsA("StringValue")) then
			cachedPowerValue = val
			return val
		end
		return nil
	end

	local function createPowerGui()
		local playerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
		if not playerGui then return end
		local existing = playerGui:FindFirstChild("PowerLevelGui")
		if existing then existing:Destroy() end
		local sg = Instance.new("ScreenGui")
		sg.Name = "PowerLevelGui"
		sg.ResetOnSpawn = false
		sg.DisplayOrder = 50
		sg.Parent = playerGui

		local frame = Instance.new("Frame")
		frame.Name = "PowerLevelFrame"
		frame.Size = UDim2.new(0, 220, 0, 36)
		frame.Position = UDim2.new(1, -240, 0.85, 0)
		frame.AnchorPoint = Vector2.new(0,0)
		frame.BackgroundColor3 = Color3.fromRGB(24,24,28)
		frame.BackgroundTransparency = 0.06
		frame.ZIndex = 1
		frame.Parent = sg
		local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0,8) corner.Parent = frame

		local label = Instance.new("TextLabel")
		label.Name = "PowerLevelLabel"
		label.Size = UDim2.new(1, -16, 1, 0)
		label.Position = UDim2.new(0, 8, 0, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamBold
		label.TextSize = 16
		label.TextColor3 = Color3.fromRGB(255,255,255)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Center
		label.Text = "power: unknown"
		label.ZIndex = 2
		label.Parent = frame

		power_gui, power_frame, power_label = sg, frame, label
	end

	local function updatePowerLabel(value)
		if not power_label then return end
		local text
		if value == nil then
			text = "power: unknown"
		else
			if tonumber(value) == 0 then
				text = "power is out"
			else
				text = "power: " .. tostring(value)
			end
		end
		pcall(function() power_label.Text = text end)
		-- also update inline stat label in main GUI if present
		pcall(function()
			if power_stat_label and power_stat_label.Parent then
				if value == nil then
					power_stat_label.Text = "?"
				else
					power_stat_label.Text = tostring(value)
				end
			end
		end)
	end

	local function hookPower(valueObj)
		if not valueObj then return end
		if power_current_conn then pcall(function() power_current_conn:Disconnect() end) power_current_conn = nil end
		local ok, v = pcall(function() return valueObj.Value end)
		if ok then updatePowerLabel(v) end
		pcall(function()
			if valueObj.GetPropertyChangedSignal then
				power_current_conn = valueObj:GetPropertyChangedSignal("Value"):Connect(function()
					local ok2, nv = pcall(function() return valueObj.Value end)
					if ok2 then updatePowerLabel(nv) end
				end)
			else
				power_current_conn = valueObj.Changed:Connect(function(nv)
					updatePowerLabel(nv)
				end)
			end
		end)
	end

	local function startPowerWatcher()
		if not power_gui then createPowerGui() end
		local val = findPowerValue()
		if val then hookPower(val) end
		if not cachedPowerValue then
			power_search_conn = RunService.Heartbeat:Connect(function()
				local v = findPowerValue()
				if v then
					if power_search_conn then power_search_conn:Disconnect(); power_search_conn = nil end
					hookPower(v)
				end
			end)
		end
		if not cachedPowerValuesFolder then
			power_folder_conn = ReplicatedStorage.ChildAdded:Connect(function(child)
				if not child then return end
				if child.Name:lower() == "powervalues" then
					cachedPowerValuesFolder = child
					local pl = cachedPowerValuesFolder:FindFirstChild("PowerLevel") or cachedPowerValuesFolder:FindFirstChild("powerlevel")
					if pl then
						local v = pl:FindFirstChild("Value") or pl:FindFirstChild("value")
						if v then hookPower(v) end
					end
					power_descendant_conn = cachedPowerValuesFolder.DescendantAdded:Connect(function(inst)
						if not inst then return end
						if inst.Name:lower() == "powerlevel" then
							local v = inst:FindFirstChild("Value") or inst:FindFirstChild("value")
							if v then hookPower(v) end
						elseif inst.Name:lower() == "value" and inst.Parent and inst.Parent.Name:lower() == "powerlevel" then
							hookPower(inst)
						end
					end)
				end
			end)
		else
			power_descendant_conn = cachedPowerValuesFolder.DescendantAdded:Connect(function(inst)
				if not inst then return end
				if inst.Name:lower() == "powerlevel" then
					local v = inst:FindFirstChild("Value") or inst:FindFirstChild("value")
					if v then hookPower(v) end
				elseif inst.Name:lower() == "value" and inst.Parent and inst.Parent.Name:lower() == "powerlevel" then
					hookPower(inst)
				end
			end)
		end
		ReplicatedStorage.DescendantRemoving:Connect(function(inst)
			if cachedPowerValue and (inst == cachedPowerValue or inst == cachedPowerValue.Parent) then
				updatePowerLabel(nil)
				if power_current_conn then pcall(function() power_current_conn:Disconnect() end) end
				cachedPowerValue = nil
			end
		end)
	end

	local function stopPowerWatcher()
		if power_search_conn then pcall(function() power_search_conn:Disconnect() end) power_search_conn = nil end
		if power_folder_conn then pcall(function() power_folder_conn:Disconnect() end) power_folder_conn = nil end
		if power_descendant_conn then pcall(function() power_descendant_conn:Disconnect() end) power_descendant_conn = nil end
		if power_current_conn then pcall(function() power_current_conn:Disconnect() end) power_current_conn = nil end
		if power_gui then pcall(function() power_gui:Destroy() end) power_gui, power_frame, power_label = nil, nil, nil end
		cachedPowerValue = nil
	end

	-- expose start/stop for power watcher to GUI code (toggle created elsewhere)
	_G._POWER_WATCHER = _G._POWER_WATCHER or {}
	_G._POWER_WATCHER.start = startPowerWatcher
	_G._POWER_WATCHER.stop = stopPowerWatcher
end)

-- Day/Night watcher implementation (imported from Beta Features/DayNightWatcher.lua)
spawn(function()
	while not makeToggle do task.wait() end

	local cachedTimer
	local cachedTurningToDay
	local cachedNight

	local timerConn, turningConn, nightConn, heartbeatConn

	local function findValue(name)
		if not ReplicatedStorage then return nil end
		local inst = ReplicatedStorage:FindFirstChild(name)
		return inst
	end

	local function findAll()
		if not cachedTimer or not cachedTimer.Parent then
			cachedTimer = findValue("Timer") or findValue("timer")
		end
		if not cachedTurningToDay or not cachedTurningToDay.Parent then
			cachedTurningToDay = findValue("TurningToDay") or findValue("turningtoday")
		end
		if not cachedNight or not cachedNight.Parent then
			cachedNight = findValue("Night") or findValue("night")
		end
		return cachedTimer, cachedTurningToDay, cachedNight
	end

	local day_gui, day_frame, day_state_label, day_time_label

	local function createDayGui()
		if not LocalPlayer then return end
		local playerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
		if not playerGui then return end
		local existing = playerGui:FindFirstChild("DayNightWatcherGui")
		if existing then existing:Destroy() end
		local sg = Instance.new("ScreenGui")
		sg.Name = "DayNightWatcherGui"
		sg.ResetOnSpawn = false
		sg.DisplayOrder = 50
		sg.Parent = playerGui

		local frame = Instance.new("Frame")
		frame.Name = "DayNightFrame"
		frame.Size = UDim2.new(0, 260, 0, 56)
		frame.Position = UDim2.new(1, -280, 0.78, 0)
		frame.AnchorPoint = Vector2.new(0,0)
		frame.BackgroundColor3 = Color3.fromRGB(24,24,28)
		frame.BackgroundTransparency = 0.06
		frame.ZIndex = 1
		frame.Parent = sg
		local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0,8) corner.Parent = frame

		local stateLabel = Instance.new("TextLabel")
		stateLabel.Name = "StateLabel"
		stateLabel.Size = UDim2.new(1, -16, 0, 22)
		stateLabel.Position = UDim2.new(0, 8, 0, 6)
		stateLabel.BackgroundTransparency = 1
		stateLabel.Font = Enum.Font.GothamBold
		stateLabel.TextSize = 14
		stateLabel.TextColor3 = Color3.fromRGB(245,245,245)
		stateLabel.TextXAlignment = Enum.TextXAlignment.Left
		stateLabel.TextYAlignment = Enum.TextYAlignment.Center
		stateLabel.Text = "State: unknown"
		stateLabel.ZIndex = 2
		stateLabel.Parent = frame

		local timeLabel = Instance.new("TextLabel")
		timeLabel.Name = "TimeLabel"
		timeLabel.Size = UDim2.new(1, -16, 0, 22)
		timeLabel.Position = UDim2.new(0, 8, 0, 30)
		timeLabel.BackgroundTransparency = 1
		timeLabel.Font = Enum.Font.Gotham
		timeLabel.TextSize = 14
		timeLabel.TextColor3 = Color3.fromRGB(220,220,225)
		timeLabel.TextXAlignment = Enum.TextXAlignment.Left
		timeLabel.TextYAlignment = Enum.TextYAlignment.Center
		timeLabel.Text = "Time until: --"
		timeLabel.ZIndex = 2
		timeLabel.Parent = frame

		day_gui, day_frame, day_state_label, day_time_label = sg, frame, stateLabel, timeLabel
	end

	local function formatTime(t)
		if not t or t <= 0 then return "0s" end
		local s = math.floor(t)
		local m = math.floor(s / 60)
		local rem = s % 60
		if m > 0 then
			return string.format("%dm %ds", m, rem)
		else
			return string.format("%ds", rem)
		end
	end

	local function updateDisplay()
		local timer = cachedTimer
		local turning = cachedTurningToDay
		local night = cachedNight

		local timerVal = nil
		if timer then pcall(function() timerVal = timer.Value end) end

		local isNight = nil
		if night then pcall(function() isNight = night.Value end) end
		local isTurning = nil
		if turning then pcall(function() isTurning = turning.Value end) end

		local stateText = "State: unknown"
		if isNight == true then stateText = "State: Night"
		elseif isNight == false then stateText = "State: Day" end
		if isTurning ~= nil then
			stateText = stateText .. (isTurning and " (Turning to Day)" or "")
		end
		pcall(function() if day_state_label then day_state_label.Text = stateText end end)

		if timerVal ~= nil then
			local t = tonumber(timerVal)
			if t then
				local target = (isNight == true) and "day" or "night"
				local labelText = "Time until " .. target .. ": " .. formatTime(t)
				pcall(function() if day_time_label then day_time_label.Text = labelText end end)
				return
			end
		end
		pcall(function() if day_time_label then day_time_label.Text = "Time until: unknown" end end)
	end

	local function hookEvents()
		if timerConn then pcall(function() timerConn:Disconnect() end) timerConn = nil end
		if turningConn then pcall(function() turningConn:Disconnect() end) turningConn = nil end
		if nightConn then pcall(function() nightConn:Disconnect() end) nightConn = nil end

		if cachedTimer and cachedTimer.GetPropertyChangedSignal then
			timerConn = cachedTimer:GetPropertyChangedSignal("Value"):Connect(function() updateDisplay() end)
		elseif cachedTimer and cachedTimer.Changed then
			timerConn = cachedTimer.Changed:Connect(function() updateDisplay() end)
		end

		if cachedTurningToDay and cachedTurningToDay.GetPropertyChangedSignal then
			turningConn = cachedTurningToDay:GetPropertyChangedSignal("Value"):Connect(function() updateDisplay() end)
		elseif cachedTurningToDay and cachedTurningToDay.Changed then
			turningConn = cachedTurningToDay.Changed:Connect(function() updateDisplay() end)
		end

		if cachedNight and cachedNight.GetPropertyChangedSignal then
			nightConn = cachedNight:GetPropertyChangedSignal("Value"):Connect(function() updateDisplay() end)
		elseif cachedNight and cachedNight.Changed then
			nightConn = cachedNight.Changed:Connect(function() updateDisplay() end)
		end
	end

	local function startDayWatcher()
		if not day_gui then createDayGui() end
		findAll()
		if cachedTimer or cachedTurningToDay or cachedNight then
			updateDisplay()
			hookEvents()
		end

		if heartbeatConn then heartbeatConn:Disconnect() heartbeatConn = nil end
		heartbeatConn = RunService.Heartbeat:Connect(function()
			findAll()
			if (cachedTimer or cachedTurningToDay or cachedNight) then
				updateDisplay()
				hookEvents()
				if heartbeatConn then heartbeatConn:Disconnect() heartbeatConn = nil end
			end
		end)
	end

	local function stopDayWatcher()
		if timerConn then pcall(function() timerConn:Disconnect() end) timerConn = nil end
		if turningConn then pcall(function() turningConn:Disconnect() end) turningConn = nil end
		if nightConn then pcall(function() nightConn:Disconnect() end) nightConn = nil end
		if heartbeatConn then pcall(function() heartbeatConn:Disconnect() end) heartbeatConn = nil end
		if day_gui then pcall(function() day_gui:Destroy() end) day_gui, day_frame, day_state_label, day_time_label = nil, nil, nil, nil end
		cachedTimer, cachedTurningToDay, cachedNight = nil, nil, nil
	end

	_G._DAY_TIMER = _G._DAY_TIMER or {}
	_G._DAY_TIMER.start = startDayWatcher
	_G._DAY_TIMER.stop = stopDayWatcher
end)

-- Trapless implementation: removes HitBox under traps in workspace.Debris.Traps
spawn(function()

	local workspaceRef = workspace

	local trapsRoot = nil
	local heartbeatConn = nil
	local descendantConn = nil

	local function findTrapsRoot()
		local debris = workspaceRef:FindFirstChild("Debris")
		if debris then return debris:FindFirstChild("Traps") end
		return nil
	end

	local function cleanTrapModel(trapModel)
		if not trapModel then return end
		pcall(function()
			local hb = trapModel:FindFirstChild("HitBox", true)
			if hb and hb.Parent then pcall(function() hb:Destroy() end) end
		end)
	end

	local function scanAll()
		trapsRoot = findTrapsRoot()
		if not trapsRoot then return end
		for _, trap in ipairs(trapsRoot:GetChildren()) do
			if trap and trap.Name == "RakeTrapModel" then
				cleanTrapModel(trap)
			else
				local rake = trap:FindFirstChild("RakeTrapModel", true)
				if rake then cleanTrapModel(rake) end
			end
		end
	end

	local function onDescendantAdded(inst)
		if not inst then return end
		if tostring(inst.Name):lower() == "hitbox" then
			local cur = inst
			local found = false
			while cur and cur.Parent do
				if cur.Name == "RakeTrapModel" then found = true break end
				cur = cur.Parent
			end
			if found then pcall(function() inst:Destroy() end) end
		end
	end

	local function startTrapless()
		if heartbeatConn then return end
		scanAll()
		heartbeatConn = RunService.Heartbeat:Connect(function()
			scanAll()
		end)
		trapsRoot = findTrapsRoot()
		if trapsRoot then
			descendantConn = trapsRoot.DescendantAdded:Connect(onDescendantAdded)
		end
	end

	local function stopTrapless()
		if heartbeatConn then pcall(function() heartbeatConn:Disconnect() end) heartbeatConn = nil end
		if descendantConn then pcall(function() descendantConn:Disconnect() end) descendantConn = nil end
		trapsRoot = nil
	end

	_G._TRAPLESS = _G._TRAPLESS or {}
	_G._TRAPLESS.start = startTrapless
	_G._TRAPLESS.stop = stopTrapless
end)



	-- Ensure Game left column and divider exist, then add Power Level Stat toggle
	pcall(function()
		local initial = false
		pcall(function() LocalPlayer:SetAttribute("Rake_PowerLevelEnabled", false) end)
		local parentCol = gameSection:FindFirstChild("GameLeftCol")
		if not parentCol then
			parentCol = Instance.new("Frame")
			parentCol.Name = "GameLeftCol"
			parentCol.Size = UDim2.new(0.55, -8, 1, -8)
			parentCol.Position = UDim2.new(0, 8, 0, 8)
			parentCol.BackgroundTransparency = 1
			parentCol.Parent = gameSection
		end
		if not gameSection:FindFirstChild("GameDivider") then
			local div = Instance.new("Frame")
			div.Name = "GameDivider"
			div.Size = UDim2.new(0, 2, 1, -16)
			div.Position = UDim2.new(0.55, 0, 0, 8)
			div.BackgroundColor3 = Color3.fromRGB(170,170,170)
			div.BackgroundTransparency = 0.25
			div.Parent = gameSection
		end

		local f = makeToggle(parentCol, "Power Level Stat", initial, function(v)
			pcall(function() LocalPlayer:SetAttribute("Rake_PowerLevelEnabled", v) end)
			if loadedSettings then loadedSettings.PowerLevelEnabled = v; pcall(saveSettings, loadedSettings) end
			if v then
				pcall(function() if _G and _G._POWER_WATCHER and _G._POWER_WATCHER.start then pcall(_G._POWER_WATCHER.start) end end)
			else
				pcall(function() if _G and _G._POWER_WATCHER and _G._POWER_WATCHER.stop then pcall(_G._POWER_WATCHER.stop) end end)
			end
		end)
		if f and f:IsA("Instance") then
			f.Position = UDim2.new(0,8,0,8)
			-- inline stat label for power watcher to update
			local statLabel = Instance.new("TextLabel")
			statLabel.Size = UDim2.new(0.12, 0, 1, 0)
			statLabel.Position = UDim2.new(0.66, 4, 0, 0)
			statLabel.BackgroundTransparency = 1
			statLabel.Font = Enum.Font.GothamBold
			statLabel.TextSize = 14
			statLabel.TextColor3 = Color3.fromRGB(200,200,200)
			statLabel.Text = "?"
			statLabel.TextXAlignment = Enum.TextXAlignment.Right
			statLabel.Parent = f
			power_stat_label = statLabel
		end

		-- ensure watcher starts if initial is true; wait for watcher API if necessary
		if initial then
			spawn(function()
				local tries = 0
				while tries < 100 and (not _G or not _G._POWER_WATCHER or not _G._POWER_WATCHER.start) do
					task.wait(0.05)
					tries = tries + 1
				end
				pcall(function()
					if _G and _G._POWER_WATCHER and _G._POWER_WATCHER.start then _G._POWER_WATCHER.start() end
				end)
			end)
		end

		-- Add Day/Night Timer toggle below Power Level Stat in left column
		pcall(function()
				local initialDN = false
			pcall(function() LocalPlayer:SetAttribute("Rake_DayNightTimerEnabled", false) end)
			local dn = makeToggle(parentCol, "Day/Night Timer", initialDN, function(v)
				pcall(function() LocalPlayer:SetAttribute("Rake_DayNightTimerEnabled", v) end)
				if loadedSettings then loadedSettings.DayNightTimerEnabled = v; pcall(saveSettings, loadedSettings) end
				if v then
					pcall(function() if _G and _G._DAY_TIMER and _G._DAY_TIMER.start then _G._DAY_TIMER.start() end end)
				else
					pcall(function() if _G and _G._DAY_TIMER and _G._DAY_TIMER.stop then _G._DAY_TIMER.stop() end end)
				end
			end)
			if dn and dn:IsA("Instance") then dn.Position = UDim2.new(0,8,0,56) end
			if initialDN then spawn(function()
				local tries = 0
				while tries < 100 and (not _G or not _G._DAY_TIMER or not _G._DAY_TIMER.start) do task.wait(0.05); tries = tries + 1 end
				pcall(function() if _G and _G._DAY_TIMER and _G._DAY_TIMER.start then _G._DAY_TIMER.start() end end)
			end) end
		end)

		-- Add Safe House Bypass button (persists, applies settings each press)
		pcall(function()
			local parentCol = gameSection:FindFirstChild("GameLeftCol")
			if not parentCol then
				parentCol = Instance.new("Frame")
				parentCol.Name = "GameLeftCol"
				parentCol.Size = UDim2.new(0.55, -8, 1, -8)
				parentCol.Position = UDim2.new(0, 8, 0, 8)
				parentCol.BackgroundTransparency = 1
				parentCol.Parent = gameSection
			end

            
		end)

		-- Add Fall Damage button (one-shot delete of FD_Event in ReplicatedStorage)
		pcall(function()
			local btnFrame, btn, lbl = makeButton(parentCol, "Fall Damage", function()
				local rs = ReplicatedStorage
				local parentGui = nil
				pcall(function() parentGui = CoreGui end)
				if not parentGui or not parentGui.Parent then parentGui = LocalPlayer:FindFirstChild("PlayerGui") end
				local function notify(text)
					pcall(function()
						if not parentGui then return end
						local existingGui = parentGui:FindFirstChild("FallDamageNotifGui")
						if existingGui then existingGui:Destroy() end
						local sg = Instance.new("ScreenGui")
						sg.Name = "FallDamageNotifGui"
						sg.ResetOnSpawn = false
						sg.DisplayOrder = 2000
						sg.Parent = parentGui
						local notif = Instance.new("Frame")
						notif.Name = "FallDamageNotif"
						notif.Size = UDim2.new(0, 320, 0, 40)
						notif.Position = UDim2.new(1, -340, 1, -84)
						notif.AnchorPoint = Vector2.new(0,0)
						notif.BackgroundColor3 = Color3.fromRGB(24,24,28)
						notif.BackgroundTransparency = 0.06
						notif.ZIndex = 2000
						notif.Parent = sg
						local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0,8) corner.Parent = notif
						local msg = Instance.new("TextLabel")
						msg.Size = UDim2.new(1, -16, 1, 0)
						msg.Position = UDim2.new(0, 8, 0, 0)
						msg.BackgroundTransparency = 1
						msg.Font = Enum.Font.GothamBold
						msg.TextSize = 14
						msg.TextColor3 = Color3.fromRGB(255,255,255)
						msg.ZIndex = 2001
						msg.Text = text
						msg.TextXAlignment = Enum.TextXAlignment.Left
						msg.TextYAlignment = Enum.TextYAlignment.Center
						msg.Parent = notif
						task.delay(3, function() pcall(function() if sg and sg.Parent then sg:Destroy() end end) end)
					end)
				end
				local success = false
				local ev = rs:FindFirstChild("FD_Event")
				if ev and ev.Parent then
					pcall(function() ev:Destroy() end)
					success = true
				end
				if success then notify("Fall damage was removed") else notify("Failed to delete fall damage.") end
			end)
			if btnFrame and btnFrame:IsA("Instance") then btnFrame.Position = UDim2.new(0,8,0,104) end
		end)
		end)

			pcall(function()
				local parentCol = gameSection:FindFirstChild("GameLeftCol")
				if not parentCol then
					parentCol = Instance.new("Frame")
					parentCol.Name = "GameLeftCol"
					parentCol.Size = UDim2.new(0.55, -8, 1, -8)
					parentCol.Position = UDim2.new(0, 8, 0, 8)
					parentCol.BackgroundTransparency = 1
					parentCol.Parent = gameSection
				end

				local initialT = false
				pcall(function() LocalPlayer:SetAttribute("Rake_TraplessEnabled", false) end)

				local tgl = makeToggle(parentCol, "Remove Trap Hitbox", initialT, function(v)
					pcall(function() LocalPlayer:SetAttribute("Rake_TraplessEnabled", v) end)
					if loadedSettings then loadedSettings.TraplessEnabled = v; pcall(saveSettings, loadedSettings) end
					if v then pcall(function() if _G and _G._TRAPLESS and _G._TRAPLESS.start then _G._TRAPLESS.start() end end)
					else pcall(function() if _G and _G._TRAPLESS and _G._TRAPLESS.stop then _G._TRAPLESS.stop() end end)
					end
				end)

				if tgl and tgl:IsA("Instance") then
					-- prefer LayoutOrder where available, but also set a safe Position
					pcall(function() tgl.LayoutOrder = 50 end)
					tgl.Position = UDim2.new(0,8,0,140)
				end

				if initialT then spawn(function()
					local tries = 0
					while tries < 100 and (not _G or not _G._TRAPLESS or not _G._TRAPLESS.start) do task.wait(0.05); tries = tries + 1 end
					pcall(function() if _G and _G._TRAPLESS and _G._TRAPLESS.start then _G._TRAPLESS.start() end end)
				end) end
			end)

			-- Add Safe House Bypass button (persistent) after Trapless toggle
			pcall(function()
				local parentCol = gameSection:FindFirstChild("GameLeftCol")
				if not parentCol then
					parentCol = Instance.new("Frame")
					parentCol.Name = "GameLeftCol"
					parentCol.Size = UDim2.new(0.55, -8, 1, -8)
					parentCol.Position = UDim2.new(0, 8, 0, 8)
					parentCol.BackgroundTransparency = 1
					parentCol.Parent = gameSection
				end

				local function applySHBypass()
					-- show immediate feedback so clicks are visible
					pcall(function() makeNotification("Applying SH bypass...") end)
					local prompt = nil
					pcall(function()
						local m = Workspace and Workspace:FindFirstChild("Map") or nil
						if m then
							local sh = m:FindFirstChild("SafeHouse")
							if sh then
								local door = sh:FindFirstChild("Door")
								if door then
									local lever = door:FindFirstChild("DoorLever")
									if lever then
										local guipart = lever:FindFirstChild("DoorGUIPart")
										if guipart then
											prompt = guipart:FindFirstChild("ProximityPrompt")
										end
									end
								end
							end
						end
					end)

					if prompt and prompt:IsA("ProximityPrompt") then
						-- read properties safely
						local okReq, curReq = pcall(function() return prompt.RequiresLineOfSight end)
						local okMax, curMax = pcall(function() return prompt.MaxActivationDistance end)
						local okInd, curInd = pcall(function() return prompt.MaxIndicatorDistance end)

						local already = (okReq and curReq == false) and (okMax and curMax == 20) and (okInd and curInd == 20)
						if not already then
							pcall(function()
								pcall(function() prompt.RequiresLineOfSight = false end)
								pcall(function() prompt.MaxActivationDistance = 20 end)
								pcall(function() prompt.MaxIndicatorDistance = 20 end)
							end)
							pcall(function() makeNotification("Done! You can freely open the safe house door now.") end)
						else
							pcall(function() makeNotification("Safe house already bypassed.") end)
						end
					else
						pcall(function() makeNotification("Safe house prompt not found.") end)
					end
				end

				local frame, btn, lbl = makeButton(parentCol, "SH Bypass", function()
					applySHBypass()
				end, true)
				if frame and frame:IsA("Instance") then frame.Position = UDim2.new(0,8,0,180) end
			end)

			-- Add TD Bypass button (Observation Tower) — same behavior as SH Bypass
			pcall(function()
				local parentCol = gameSection:FindFirstChild("GameLeftCol")
				if not parentCol then return end

				local function applyTDBypass()
					pcall(function() makeNotification("Applying TD bypass...") end)
					local prompt = nil
					pcall(function()
						local m = Workspace and Workspace:FindFirstChild("Map") or nil
						if m then
							local ot = m:FindFirstChild("ObservationTower")
							if ot then
								local door = ot:FindFirstChild("Door")
								if door then
									local lever = door:FindFirstChild("DoorLever2")
									if lever then
										local guipart = lever:FindFirstChild("DoorGUIPart2")
											if guipart then
												prompt = guipart:FindFirstChild("ProximityPrompt")
											end
										end
									end
								end
							end
						end)

					if prompt and prompt:IsA("ProximityPrompt") then
						local okReq, curReq = pcall(function() return prompt.RequiresLineOfSight end)
						local okMax, curMax = pcall(function() return prompt.MaxActivationDistance end)
						local okInd, curInd = pcall(function() return prompt.MaxIndicatorDistance end)
						local already = (okReq and curReq == false) and (okMax and curMax == 20) and (okInd and curInd == 20)
						if not already then
							pcall(function()
								pcall(function() prompt.RequiresLineOfSight = false end)
								pcall(function() prompt.MaxActivationDistance = 20 end)
								pcall(function() prompt.MaxIndicatorDistance = 20 end)
							end)
							pcall(function() makeNotification("Done! You can freely open the tower door now.") end)
						else
							pcall(function() makeNotification("Observation Tower already bypassed.") end)
						end
					else
						pcall(function() makeNotification("Observation Tower prompt not found.") end)
					end
				end

				local f, b = makeButton(parentCol, "TD Bypass", function()
					applyTDBypass()
				end, true)
				if f and f:IsA("Instance") then f.Position = UDim2.new(0,8,0,220) end
			end)

	if playerSection then
		local speedEnableToggle = makeToggle(playerLeftCol, "Enable Speed", playerSpeedEnabled, function(v)
			playerSpeedEnabled = v
			pcall(function() LocalPlayer:SetAttribute("Rake_PlayerSpeedEnabled", v) end)
			if v then
				local ch = LocalPlayer.Character
				local hum = ch and ch:FindFirstChildOfClass("Humanoid")
				if hum then
					pcall(function() hum.WalkSpeed = playerSpeed end)
					enforceHumanoid(hum)
				end
			else
				-- stop enforcing and restore default walk speed
				stopSpeedEnforce()
				local ch = LocalPlayer.Character
				local hum = ch and ch:FindFirstChildOfClass("Humanoid")
				if hum then
					pcall(function() hum.WalkSpeed = DEFAULT_WALK_SPEED end)
				end
			end
			saveSettings()
		end)
		-- ensure the toggle sits below the speed slider/header
		if speedEnableToggle and speedEnableToggle:IsA("Instance") then
			speedEnableToggle.Position = UDim2.new(0, 8, 0, 96)
			speedEnableToggle.Size = UDim2.new(1, -16, 0, 40)
		end
	end

	-- Right column: Camera settings (FOV slider + POV radio)
	local fovLabel = Instance.new("TextLabel")
	fovLabel.Size = UDim2.new(1, 0, 0, 24)
	fovLabel.Position = UDim2.new(0, 8, 0, 8)
	fovLabel.BackgroundTransparency = 1
	fovLabel.Font = Enum.Font.GothamBold
	fovLabel.TextSize = 14
	fovLabel.Text = "FOV"
	fovLabel.TextColor3 = Color3.fromRGB(255,255,255)
	fovLabel.Parent = rightCol

	local fovSlider = Instance.new("Frame")
	fovSlider.Size = UDim2.new(1, -16, 0, 24)
	fovSlider.Position = UDim2.new(0, 8, 0, 36)
	fovSlider.BackgroundTransparency = 1
	fovSlider.Parent = rightCol

	local fovBarBg = Instance.new("Frame")
	fovBarBg.Size = UDim2.new(1, 0, 1, 0)
	fovBarBg.BackgroundColor3 = Color3.fromRGB(120,120,120)
	fovBarBg.BackgroundTransparency = 0.4
	fovBarBg.Parent = fovSlider

	local fovFill = Instance.new("Frame")
	fovFill.Size = UDim2.new(0.5, 0, 1, 0)
	fovFill.BackgroundColor3 = Color3.fromRGB(200,200,200)
	fovFill.Parent = fovBarBg

	local fovValueLabel = Instance.new("TextLabel")
	fovValueLabel.Size = UDim2.new(0, 48, 1, 0)
	fovValueLabel.Position = UDim2.new(1, -56, 0, 0)
	fovValueLabel.BackgroundTransparency = 1
	fovValueLabel.Font = Enum.Font.GothamBold
	fovValueLabel.TextSize = 14
	fovValueLabel.TextColor3 = Color3.fromRGB(255,255,255)
	fovValueLabel.Text = tostring(math.floor(workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70))
	fovValueLabel.Parent = fovSlider
	local currentFov = workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70
	local _fracInit = math.clamp((currentFov - 30) / 70, 0, 1)
	fovFill.Size = UDim2.new(_fracInit, 0, 1, 0)

	local fovEnforceConn = nil
	local function stopFovEnforce()
		if fovEnforceConn then
			fovEnforceConn:Disconnect()
			fovEnforceConn = nil
		end
	end
	local function startFovEnforce()
		stopFovEnforce()
		fovEnforceConn = RunService.Heartbeat:Connect(function()
			local cam = workspace.CurrentCamera
			if cam and currentFov then
				if cam.FieldOfView ~= currentFov then
					pcall(function() cam.FieldOfView = currentFov end)
				end
			end
		end)
	end

	if loadedSettings and loadedSettings.fov then
		currentFov = loadedSettings.fov
		fovValueLabel.Text = tostring(math.floor(currentFov))
		local frac = math.clamp((currentFov - 30) / 70, 0, 1)
		fovFill.Size = UDim2.new(frac, 0, 1, 0)
		startFovEnforce()
	end

    pcall(function()
        MiscCameraSection:AddSlider({
            Name="Field of View",
            Title="Field of View",
            Min=30,
            MinValue=30,
            Max=100,
            MaxValue=100,
            Default=currentFov,
            DefaultValue=currentFov,
            Value=currentFov,
            Increment=1,
            Step=1,
            ValueName="FOV",
            Callback=function(value)
                currentFov=math.clamp(math.floor(tonumber(value) or currentFov),30,100)
                local cam=workspace.CurrentCamera
                if cam then pcall(function() cam.FieldOfView=currentFov end) end
                pcall(startFovEnforce)
                pcall(saveSettings)
            end
        })
    end)


	-- POV radio options
	local povLabel = Instance.new("TextLabel")
	povLabel.Size = UDim2.new(1, 0, 0, 24)
	povLabel.Position = UDim2.new(0, 8, 0, 72)
	povLabel.BackgroundTransparency = 1
	povLabel.Font = Enum.Font.GothamBold
	povLabel.TextSize = 14
	povLabel.Text = "POV"
	povLabel.TextColor3 = Color3.fromRGB(255,255,255)
	povLabel.Parent = rightCol

	local povOptions = { "Default", "Third" }
	-- Dropdown for POV selection
	local povDropdown = Instance.new("TextButton")
	povDropdown.Size = UDim2.new(1, -16, 0, 32)
	povDropdown.Position = UDim2.new(0, 8, 0, 72)
	povDropdown.BackgroundColor3 = Color3.fromRGB(60,60,60)
	povDropdown.Font = Enum.Font.Gotham
	povDropdown.TextColor3 = Color3.fromRGB(255,255,255)
	povDropdown.Text = LocalPlayer:GetAttribute("Rake_POV") or "Default"
	povDropdown.Active = true
	povDropdown.ZIndex = 60
	povDropdown.Parent = rightCol

	local dropdownList = Instance.new("Frame")
	dropdownList.Size = UDim2.new(1, -16, 0, #povOptions * 30)
	dropdownList.Position = UDim2.new(0, 8, 0, 72 + 36)
	dropdownList.BackgroundColor3 = Color3.fromRGB(45,45,45)
	dropdownList.BackgroundTransparency = 0
	dropdownList.Visible = false
	dropdownList.Active = true
	dropdownList.ZIndex = 59
	dropdownList.Parent = rightCol

	local povOptionButtons = {}
	for i, opt in ipairs(povOptions) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, 0, 0, 28)
		b.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
		b.BackgroundTransparency = 0
		b.BackgroundColor3 = Color3.fromRGB(45,45,45)
		b.Font = Enum.Font.Gotham
		b.TextColor3 = Color3.fromRGB(200,200,200)
		b.Text = opt
		b.ZIndex = 61
		b.Parent = dropdownList
		table.insert(povOptionButtons, b)

		b.MouseButton1Click:Connect(function()
			applyPOV(opt)
			saveSettings()
			povDropdown.Text = opt
			for _, btn in ipairs(povOptionButtons) do
				btn.TextColor3 = Color3.fromRGB(200,200,200)
			end
			b.TextColor3 = Color3.fromRGB(255,255,255)
			dropdownList.Visible = false
		end)
	end

	-- Initialize visual state: highlight the currently selected POV
	local initPOV = povDropdown.Text or "Default"
	for _, btn in ipairs(povOptionButtons) do
		if btn.Text == initPOV then
			btn.TextColor3 = Color3.fromRGB(255,255,255)
		else
			btn.TextColor3 = Color3.fromRGB(200,200,200)
		end
	end

	povDropdown.MouseButton1Click:Connect(function()
		local newVis = not dropdownList.Visible
		dropdownList.Visible = newVis
		-- disable dragging while dropdown open to ensure clicks register
		isDragable = not newVis
	end)

	-- ensure this specific keybind button sits next to its label
	if keyBtn and keyBtn:IsA("TextButton") then
		keyBtn.Position = UDim2.new(0.66, 0, 0, 4)
		keyBtn.Size = UDim2.new(0.34, 0, 0, 24)
	end

	-- Player section speed dragging input
	local draggingSpeed = false
	speedBarBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSpeed = true
			isDragable = false
		end
	end)
	speedBarBg.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSpeed = false
			isDragable = true
			saveSettings()
		end
	end)
	speedBarBg.InputChanged:Connect(function(input)
		if draggingSpeed and input.UserInputType == Enum.UserInputType.MouseMovement then
			local absX = input.Position.X - speedBarBg.AbsolutePosition.X
			local frac = math.clamp(absX / speedBarBg.AbsoluteSize.X, 0, 1)
			speedFill.Size = UDim2.new(frac, 0, 1, 0)
			local spd = 8 + math.floor(frac * (100 - 8))
			playerSpeed = spd
			speedValueLabel.Text = tostring(spd)
			local ch = LocalPlayer.Character
			local hum = ch and ch:FindFirstChildOfClass("Humanoid")
			if hum then
				if playerSpeedEnabled then
					pcall(function() hum.WalkSpeed = spd end)
					enforceHumanoid(hum)
				end
			end
			pcall(function() LocalPlayer:SetAttribute("Rake_PlayerSpeed", spd) end)
			pcall(function() saveSettings() end)
		end
	end)

	-- ensure speed applies on character spawn
	localPlayerCharAddedConn = LocalPlayer.CharacterAdded:Connect(function(char)
		task.wait(0.15)
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			if playerSpeedEnabled then
				pcall(function() hum.WalkSpeed = playerSpeed end)
				enforceHumanoid(hum)
			else
				pcall(function() hum.WalkSpeed = DEFAULT_WALK_SPEED end)
				stopSpeedEnforce()
			end
		else
			stopSpeedEnforce()
		end
	end)

	-- apply immediately if character already present
	do
		local ch = LocalPlayer.Character
		local hum = ch and ch:FindFirstChildOfClass("Humanoid")
		if hum then
			if playerSpeedEnabled then
				pcall(function() hum.WalkSpeed = playerSpeed end)
				enforceHumanoid(hum)
			else
				pcall(function() hum.WalkSpeed = DEFAULT_WALK_SPEED end)
			end
		end
	end

	-- FOV dragging input
	local draggingFOV = false
	fovBarBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingFOV = true
			isDragable = false
		end
	end)
	fovBarBg.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingFOV = false
			isDragable = true
			-- persist and start enforcement
			pcall(function() saveSettings() end)
			startFovEnforce()
		end
	end)
	fovBarBg.InputChanged:Connect(function(input)
		if draggingFOV and input.UserInputType == Enum.UserInputType.MouseMovement then
			local absX = input.Position.X - fovBarBg.AbsolutePosition.X
			local frac = math.clamp(absX / fovBarBg.AbsoluteSize.X, 0, 1)
			fovFill.Size = UDim2.new(frac, 0, 1, 0)
			local fov = 30 + math.floor(frac * 70)
			currentFov = fov
			if workspace.CurrentCamera then pcall(function() workspace.CurrentCamera.FieldOfView = fov end) end
			fovValueLabel.Text = tostring(fov)
		end
	end)

	-- left column toggles
	local yOffset = 0
	local rakeToggle = makeToggle(leftCol, "The Rake", ESP_SETTINGS.showRake, function(v)
		ESP_SETTINGS.showRake = v
		refreshAllHighlights()
		saveSettings()
	end)
	rakeToggle.Position = UDim2.new(0, 8, 0, yOffset)
	yOffset = yOffset + 44

	local playerToggle = makeToggle(leftCol, "Players", ESP_SETTINGS.showPlayers, function(v)
		ESP_SETTINGS.showPlayers = v
		refreshAllHighlights()
		saveSettings()
	end)
	playerToggle.Position = UDim2.new(0, 8, 0, yOffset)
	yOffset = yOffset + 44


	-- horizontal separator (visual split like the lighting section)
	local sep = Instance.new("Frame")
	sep.Size = UDim2.new(1, -16, 0, 2)
	sep.Position = UDim2.new(0, 8, 0, yOffset)
	sep.BackgroundColor3 = Color3.fromRGB(80,80,80)
	sep.BackgroundTransparency = 0.35
	sep.Parent = leftCol

	yOffset = yOffset + 12

	-- section header (minimal safe restyle)
	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, -16, 0, 24)
	header.Position = UDim2.new(0, 8, 0, yOffset)
	header.BackgroundTransparency = 1
	header.Font = Enum.Font.GothamBold
	header.TextSize = 18
	header.Text = "Location Related"
	header.TextColor3 = Color3.fromRGB(245,245,245)
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.ZIndex = 900
	header.Parent = leftCol

	yOffset = yOffset + 24

	local showLocations = false
	local locToggle = makeToggle(leftCol, "Show Locations", showLocations, function(v)
		showLocations = v
		if v then
			pcall(function() enableLocationMarkers(screen) end)
		else
			pcall(function() disableLocationMarkers() end)
		end
		-- no persistence necessary but still save settings blob
		saveSettings()
	end)
	locToggle.Position = UDim2.new(0, 8, 0, yOffset)
	yOffset = yOffset + 44

	-- Text Background toggle: when off, markers omit the label background
	local textBgToggle = makeToggle(leftCol, "Text Background", LOCATION_TEXT_BG, function(v)
		LOCATION_TEXT_BG = v
		-- update existing screen markers
		for _, e in pairs(LOCATION_MARKERS) do
			pcall(function()
				if e and e.label then
					if v then
						e.label.BackgroundTransparency = 0
						if not e.label:FindFirstChildWhichIsA("UICorner") then
							local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0,6) c.Parent = e.label
						end
						if not e.label:FindFirstChildWhichIsA("UIStroke") then
							local s = Instance.new("UIStroke") s.Color = Color3.fromRGB(40,40,44) s.Transparency = 0.6 s.Thickness = 1 s.Parent = e.label
						end
					else
						e.label.BackgroundTransparency = 1
						local c = e.label:FindFirstChildWhichIsA("UICorner") if c then c:Destroy() end
						local s = e.label:FindFirstChildWhichIsA("UIStroke") if s then s:Destroy() end
					end
				end
				-- world billboard labels
				if e and e.worldPart then
					local bp = e.worldPart:FindFirstChildOfClass("BillboardGui")
					if bp then
						local wl = bp:FindFirstChildWhichIsA("TextLabel")
						if wl then
							if v then
								wl.BackgroundTransparency = 0
								if not wl:FindFirstChildWhichIsA("UICorner") then local c2 = Instance.new("UICorner") c2.CornerRadius = UDim.new(0,6) c2.Parent = wl end
								if not wl:FindFirstChildWhichIsA("UIStroke") then local s2 = Instance.new("UIStroke") s2.Color = Color3.fromRGB(40,40,44) s2.Transparency = 0.7 s2.Thickness = 1 s2.Parent = wl end
							else
								wl.BackgroundTransparency = 1
								local c2 = wl:FindFirstChildWhichIsA("UICorner") if c2 then c2:Destroy() end
								local s2 = wl:FindFirstChildWhichIsA("UIStroke") if s2 then s2:Destroy() end
							end
						end
					end
				end
			end)
		end
		pcall(function() saveSettings() end)
	end)
	textBgToggle.Position = UDim2.new(0, 8, 0, yOffset)
	yOffset = yOffset + 44



	-- Dropdown to choose which locations to show (placed after Improved Lighting)
	local chooseBtn = Instance.new("TextButton")
	chooseBtn.Size = UDim2.new(1, -16, 0, 28)
	chooseBtn.Position = UDim2.new(0, 8, 0, yOffset)
	chooseBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	chooseBtn.Font = Enum.Font.Gotham
	chooseBtn.TextColor3 = Color3.fromRGB(255,255,255)
	chooseBtn.Text = "Choose Locations"
	chooseBtn.ZIndex = 200
	chooseBtn.Active = true
	chooseBtn.Parent = leftCol

	local chooseList = Instance.new("Frame")
	chooseList.Size = UDim2.new(1, -16, 0, #LOCATIONS * 44)
	chooseList.Position = UDim2.new(0, 8, 0, yOffset + 30)
	chooseList.BackgroundColor3 = Color3.fromRGB(45,45,45)
	chooseList.BackgroundTransparency = 0
	chooseList.Visible = false
	chooseList.Active = true
	chooseList.ZIndex = 205
	chooseList.Parent = leftCol

	yOffset = yOffset + 12

	-- if settings requested rake meter enabled, start it now
	if RAKE_METER.enabled then
		pcall(function() enableRakeMeter(screen) end)
	end

	IMPROVED_LIGHTING_ENABLED = false



	local locToggles = {}
	for i, loc in ipairs(LOCATIONS) do
		local initial = false
		local t = makeToggle(chooseList, loc.name, initial, function(v)
			LOCATION_SETTINGS[loc.name] = v
			-- immediately update markers visibility (UI containers)
			pcall(function() updateLocationMarkers(screen) end)
			-- also update any existing world-part marker transparency immediately
			pcall(function()
				local entry = LOCATION_MARKERS[loc.name]
				if entry and entry.worldPart then
					local enabled = v
					entry.worldPart.Transparency = enabled and 0 or 1
					local bp = entry.worldPart:FindFirstChildOfClass("BillboardGui")
					if bp then
						pcall(function() bp.Enabled = enabled end)
						local lbl = bp:FindFirstChildWhichIsA("TextLabel")
						if lbl then lbl.Visible = enabled end
					end
				end
			end)
			saveSettings()
		end)
		t.Position = UDim2.new(0, 8, 0, (i - 1) * 44)
		table.insert(locToggles, t)
		-- ensure the toggle and its children render above nearby UI (like lightning labels)
		pcall(function()
			t.ZIndex = 206
			for _, d in ipairs(t:GetDescendants()) do
				if pcall(function() return d.ZIndex end) then
					d.ZIndex = 206
				end
			end
		end)
	end

	chooseBtn.MouseButton1Click:Connect(function()
		local newVis = not chooseList.Visible
		chooseList.Visible = newVis
		isDragable = not newVis
	end)

	-- Splitting horizontal line and label for lighting-related controls (placed below chooseList)
	local baseY = yOffset + 22

	local lightningDivider = Instance.new("Frame")
	lightningDivider.Name = "LightningDivider"
	lightningDivider.Size = UDim2.new(1, -16, 0, 2)
	lightningDivider.Position = UDim2.new(0, 8, 0, baseY)
	lightningDivider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	lightningDivider.BackgroundTransparency = 0.35
	lightningDivider.ZIndex = 201
	lightningDivider.Parent = leftCol

	-- Section label for lighting controls
	local lightningLabel = Instance.new("TextLabel")
	lightningLabel.Name = "LightningLabel"
	lightningLabel.Size = UDim2.new(1, -16, 0, 22)
	lightningLabel.Position = UDim2.new(0, 8, 0, baseY + 12)
	lightningLabel.BackgroundTransparency = 1
	lightningLabel.Font = Enum.Font.GothamBold
	lightningLabel.TextSize = 16
	lightningLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	lightningLabel.Text = "Lighting Related"
	lightningLabel.TextXAlignment = Enum.TextXAlignment.Left
	lightningLabel.ZIndex = 202
	lightningLabel.Parent = leftCol

	-- Improved Lighting toggle (placed just under the label)
	local improvedToggle = makeToggle(leftCol, "Improved Lighting", IMPROVED_LIGHTING_ENABLED, function(v)
		IMPROVED_LIGHTING_ENABLED = v
		if v then
			pcall(function() enableImprovedLighting() end)
		else
			pcall(function() disableImprovedLighting() end)
		end
		saveSettings()
	end)
	improvedToggle.Position = UDim2.new(0, 8, 0, baseY + 36)
	yOffset = baseY + 36 + 44



	-- start markers if enabled
	if showLocations then
		pcall(function() enableLocationMarkers(screen) end)
	end

	-- Rake controls group (moved out of left column so it's grouped with other visuals)
	local rakeGroup = Instance.new("Frame")
	rakeGroup.Name = "RakeGroup"
	rakeGroup.Size = UDim2.new(1, -16, 0, 96)
	rakeGroup.Position = UDim2.new(0, 8, 0, 140)
	rakeGroup.BackgroundTransparency = 1
	rakeGroup.Parent = rightCol

	local rakeMeterToggle = makeToggle(rakeGroup, "Rake Meter", RAKE_METER.enabled, function(v)
		RAKE_METER.enabled = v
		if v then
			pcall(function() enableRakeMeter(screen) end)
		else
			pcall(function() disableRakeMeter() end)
		end
		saveSettings()
	end)
	rakeMeterToggle.Position = UDim2.new(0, 8, 0, 8)


	-- Generic beta 
	local function showBetaNoticeOnce(msg)
		if not SCREEN_GUI then return end
		local existing = SCREEN_GUI:FindFirstChild("BetaNotice")
		if existing then existing:Destroy() end
		local note = Instance.new("TextLabel")
		note.Name = "BetaNotice"
		note.Size = UDim2.new(0, 420, 0, 28)
		note.Position = UDim2.new(0.5, -210, 0, 6)
		note.BackgroundColor3 = Color3.fromRGB(200, 120, 40)
		note.BackgroundTransparency = 0.06
		note.Font = Enum.Font.GothamBold
		note.TextSize = 14
		note.TextColor3 = Color3.fromRGB(255,255,255)
		note.Text = msg or "This feature is currently in beta, and may be instable."
		note.TextXAlignment = Enum.TextXAlignment.Center
		note.ZIndex = 1200
		local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0,6) corner.Parent = note
		note.Parent = SCREEN_GUI
		task.delay(4, function()
			pcall(function() if note then note:Destroy() end end)
		end)
	end

	-- Object Finder (integrated from Beta Features/ObjectFinder.lua)
	OBJECT_FINDER = {
		enabled = false,
		isBeta = true,
		tracked = {},
		clusters = {},
		connections = {},
		clusterAcc = 0,
	}

	-- Determine if Object Finder should start enabled (restore from settings)
	local shouldEnableObjectFinder = false

	local TARGET_NAMES = {"scrap","flaregun","supply drop","drop"}
	-- whitelist of accepted no-space tokens that count as supply objects
	local SUPPLY_TOKENS = {
		supplydrop = true,
	}
	local NAME_TAG_COLOR = Color3.new(1,1,0)
	local COLOR_SUPPLY = Color3.fromRGB(80,255,120)
	local COLOR_SCRAP = Color3.fromRGB(140,85,40)
	local COLOR_FLARE = Color3.fromRGB(255,105,180)
	local COLOR_CUE = Color3.fromRGB(255,255,255)
	local CLUSTER_CONFIG = { ["scrap"] = { label = "Supply Drop", radius = 8, minCount = 3 } }

	local function titleCase(s)
		local out = {}
		for word in s:gmatch("%S+") do
			out[#out+1] = word:sub(1,1):upper() .. word:sub(2)
		end
		return table.concat(out, " ")
	end

	local function findBestMatch(name)
		if not name then return nil end
		local lower = name:lower()
		local best = nil
		for _, t in ipairs(TARGET_NAMES) do
			local tl = t:lower()
			if string.find(lower, tl, 1, true) then
				if (not best) or (#tl > #best) then best = tl end
			end
		end
		return best
	end

	local function createNameTag(object, adorneePart, textColor)
		if not SCREEN_GUI then return end
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "NameTag"
		billboard.Adornee = adorneePart or object
		billboard.Parent = SCREEN_GUI
		billboard.Size = UDim2.new(0, 100, 0, 40)
		billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
		billboard.AlwaysOnTop = true
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1,0,1,0)
		label.BackgroundTransparency = 1
		label.Text = object.Name or "Unknown"
		label.TextColor3 = textColor or NAME_TAG_COLOR
		label.TextScaled = true
		label.Font = Enum.Font.SourceSansBold
		label.TextStrokeTransparency = 0
		label.TextStrokeColor3 = Color3.new(0,0,0)
		label.Parent = billboard
		return billboard
	end

	local function clearClusters()
		for id, c in pairs(OBJECT_FINDER.clusters) do
			-- if cluster used a dedicated gui/part, destroy them
			if c.gui and c.gui.Parent then c.gui:Destroy() end
			if c.part and c.part.Parent then c.part:Destroy() end
			-- if cluster was using a representative member's nameTag, restore it
			if c.representative and OBJECT_FINDER.tracked[c.representative] then
				local td = OBJECT_FINDER.tracked[c.representative]
				pcall(function()
					if td.nameTag and td.nameTag.Parent then
						local lbl = td.nameTag:FindFirstChildWhichIsA("TextLabel")
						if lbl then
							if c.originalText then lbl.Text = c.originalText end
							if c.originalColor then lbl.TextColor3 = c.originalColor end
						end
						td.nameTag.Enabled = true
					end
				end)
			end
			-- re-enable member nameTags that were disabled
			if c.members then
				for memberKey, _ in pairs(c.members) do
					if OBJECT_FINDER.tracked[memberKey] and OBJECT_FINDER.tracked[memberKey].nameTag then
						pcall(function() OBJECT_FINDER.tracked[memberKey].nameTag.Enabled = true end)
					end
				end
			end
			OBJECT_FINDER.clusters[id] = nil
		end
	end

	local function createClusterGuiAt(pos, text)
		local part = Instance.new("Part")
		part.Name = "ObjectClusterPart"
		part.Anchored = true
		part.CanCollide = false
		part.Transparency = 1
		part.Size = Vector3.new(1,1,1)
		part.Position = pos
		part.Parent = Workspace
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "ClusterTag"
		billboard.Adornee = part
		billboard.Parent = SCREEN_GUI
		billboard.Size = UDim2.new(0,160,0,40)
		billboard.StudsOffsetWorldSpace = Vector3.new(0,3,0)
		billboard.AlwaysOnTop = true
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1,1,1,1)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextScaled = true
		label.Font = Enum.Font.SourceSansBold
		label.TextColor3 = NAME_TAG_COLOR
		label.TextStrokeTransparency = 0
		label.TextStrokeColor3 = Color3.new(0,0,0)
		label.Parent = billboard
		return { part = part, gui = billboard }
	end

	local function enforceFlareUniqueness()
		local flareItems = {}
		local char = LocalPlayer and LocalPlayer.Character
		local hrpPos = nil
		if char then
			local hrp = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
			if hrp then hrpPos = hrp.Position end
		end
		for key, data in pairs(OBJECT_FINDER.tracked) do
			if data and data.match and data.match == "flare" then
				local posPart = nil
				if key:IsA("Model") then posPart = key.PrimaryPart or key:FindFirstChildWhichIsA("BasePart")
				elseif key:IsA("BasePart") then posPart = key end
				local dist = (posPart and hrpPos) and (posPart.Position - hrpPos).Magnitude or math.huge
				table.insert(flareItems, { key = key, dist = dist, data = data })
			end
		end
		if #flareItems <= 1 then
			if #flareItems == 1 then
				local only = flareItems[1]
				if only.data.highlight then only.data.highlight.Enabled = true end
				if only.data.nameTag then only.data.nameTag.Enabled = true end
			end
			return
		end
		table.sort(flareItems, function(a,b) return a.dist < b.dist end)
		local keep = flareItems[1].key
		for i=1,#flareItems do
			local item = flareItems[i]
			if item.key == keep then
				if item.data.highlight then item.data.highlight.Enabled = true end
				if item.data.nameTag then item.data.nameTag.Enabled = true end
			else
				if item.data.highlight then item.data.highlight.Enabled = false end
				if item.data.nameTag then item.data.nameTag.Enabled = false end
			end
		end
	end

	local function processInstance(inst)
		if not inst or not inst.Parent then return end
		local modelRoot = nil
		if inst:IsA("BasePart") and inst.Parent and inst.Parent:IsA("Model") then
			modelRoot = inst.Parent
		elseif inst:IsA("Model") then
			modelRoot = inst
		end
		local nameToCheck = (modelRoot and (modelRoot.Name) or inst.Name) or ""
		-- normalize forms: raw lower, a spaced-normalized form and a nospace form
		local rawLower = nameToCheck:lower()
		local normSpaces = rawLower:gsub("[_%-]", " "):gsub("[^%w%s]", ""):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
		local normNoSpace = rawLower:gsub("[_%s%-%p]", "")
		-- filter out known irrelevant names
		if normNoSpace == "scrapspawn" or normNoSpace == "scrapspawns" or normNoSpace == "supplylerppos" or normNoSpace == "supplycratemain" or normNoSpace == "supplycrate" then return end
		local category = nil
		-- Prefer explicit supply / scrap matches (strict: require exact words or known tokens)
		local words = {}
		for w in normSpaces:gmatch("%S+") do table.insert(words, w) end
		local function hasWord(w)
			for i=1,#words do if words[i] == w then return true end end
			return false
		end
		local isSupply = false
		if string.find(normSpaces, "supply drop", 1, true) then
			isSupply = true
		elseif hasWord("supply") and hasWord("drop") then
			isSupply = true
		else
			-- accept a small set of known no-space tokens exactly
			local zn = normNoSpace
			if SUPPLY_TOKENS[zn] then
				isSupply = true
			end
		end
		if isSupply then
			category = "supply"
		
		elseif string.find(normSpaces, "scrap", 1, true) or string.find(normNoSpace, "scrap", 1, true) then
			category = "scrap"
		-- Detect flare clue/cue variants first (more specific)
		elseif string.find(normSpaces, "flare gun clue", 1, true) or string.find(normSpaces, "flare gun cue", 1, true) or string.find(normSpaces, "flare clue", 1, true) or string.find(normSpaces, "flare cue", 1, true) or string.find(normNoSpace, "flareguncue", 1, true) or string.find(normNoSpace, "flareguncue", 1, true) or string.find(normNoSpace, "flareclue", 1, true) then
			category = "flare_cue"

		elseif string.find(normSpaces, "flare gun", 1, true) or string.find(normNoSpace, "flaregun", 1, true) or string.find(normSpaces, "flare", 1, true) then
			if string.find(normSpaces, "clue", 1, true) or string.find(normNoSpace, "clue", 1, true) then
				category = "flare_cue"
			else
				category = "flare"
			end
		else
			category = findBestMatch(nameToCheck)
		end
		local match = category
		if not match then return end
		local key = modelRoot or inst
		if OBJECT_FINDER.tracked[key] then return end
		-- Limit flare matches to at most two tracked items
		if match == "flare" then
			local flareCount = 0
			for k,v in pairs(OBJECT_FINDER.tracked) do
				if v and v.match == "flare" then flareCount = flareCount + 1 end
			end
			if flareCount >= 2 then
				return
			end
		end
		local adornPart = nil
		if key:IsA("Model") then adornPart = key.PrimaryPart or key:FindFirstChild("HumanoidRootPart") or key:FindFirstChildWhichIsA("BasePart") else adornPart = key end
		local highlight = Instance.new("Highlight")
		highlight.Adornee = key
		highlight.FillTransparency = 0.8
		highlight.Parent = key
		local nameTagColor = NAME_TAG_COLOR
		if match == "supply" then
			highlight.FillColor = COLOR_SUPPLY
			highlight.OutlineColor = COLOR_SUPPLY
			nameTagColor = COLOR_SUPPLY
		elseif match == "scrap" then
			highlight.FillColor = COLOR_SCRAP
			highlight.OutlineColor = COLOR_SCRAP
			nameTagColor = COLOR_SCRAP
		elseif match == "flare" then
			highlight.FillColor = COLOR_FLARE
			highlight.OutlineColor = COLOR_FLARE
			nameTagColor = COLOR_FLARE
		elseif match == "flare_cue" then
			highlight.FillColor = COLOR_CUE
			highlight.OutlineColor = COLOR_CUE
			nameTagColor = COLOR_CUE
		else
			highlight.FillColor = Color3.new(1,0.5,0)
			highlight.OutlineColor = Color3.new(1,0.5,0)
			nameTagColor = NAME_TAG_COLOR
		end
		local nameTag = createNameTag(key, adornPart, nameTagColor)
		if nameTag and nameTag:FindFirstChildWhichIsA("TextLabel") then
			local lbl = nameTag:FindFirstChildWhichIsA("TextLabel")
			if lbl then
				if match == "flare" then
					local kn = (key.Name or ""):lower()
					if string.find(kn, "flare gun cue", 1, true) or string.find(kn, "flare_gun_cue", 1, true) then
						lbl.Text = "Flare Gun Cue"
					else
						lbl.Text = "Flare Gun"
					end
				else
					lbl.Text = (key.Name or "")
				end
			end
		end
		OBJECT_FINDER.tracked[key] = { highlight = highlight, nameTag = nameTag, match = match }
		if match == "flare" then pcall(function() enforceFlareUniqueness() end) end
	end

	local function initialScanObjectFinder()
		local all = Workspace:GetDescendants()
		local batch = 60
		for i = 1, #all, batch do
			for j = i, math.min(i+batch-1, #all) do
				processInstance(all[j])
			end
			RunService.Heartbeat:Wait()
		end
	end

	local function updateClustersObjectFinder(dt)
		OBJECT_FINDER.clusterAcc = OBJECT_FINDER.clusterAcc + (dt or 0)
		if OBJECT_FINDER.clusterAcc < 0.6 then return end
		OBJECT_FINDER.clusterAcc = 0
		clearClusters()
		local byMatch = {}
		for key, data in pairs(OBJECT_FINDER.tracked) do
			if key and key.Parent and data and data.match then
				local posPart = nil
				if key:IsA("Model") then posPart = key.PrimaryPart or key:FindFirstChild("HumanoidRootPart") or key:FindFirstChildWhichIsA("BasePart")
				elseif key:IsA("BasePart") then posPart = key end
				if posPart and posPart.Position then
					byMatch[data.match] = byMatch[data.match] or {}
					table.insert(byMatch[data.match], { key = key, pos = posPart.Position })
				end
			end
		end
		for matchToken, items in pairs(byMatch) do
			local cfg = CLUSTER_CONFIG[matchToken]
			if cfg then
				local used = {}
				for i = 1, #items do
					if not used[i] then
						local group = { items[i] }
						used[i] = true
						for j = i+1, #items do
							if not used[j] and (items[i].pos - items[j].pos).Magnitude <= cfg.radius then
								table.insert(group, items[j])
								used[j] = true
							end
						end
						if #group >= cfg.minCount then
							local sum = Vector3.new(0,0,0)
							for _, it in ipairs(group) do sum = sum + it.pos end
							local center = sum / #group
							-- Use one of the group's existing tracked nameTags as the cluster label.
							local rep = group[1].key
							local id = tostring(center.X) .. ":" .. tostring(center.Z)
							OBJECT_FINDER.clusters[id] = { representative = rep, members = {}, originalText = nil, label = cfg.label }
							for _, it in ipairs(group) do
								OBJECT_FINDER.clusters[id].members[it.key] = true
								-- disable other members' nameTags; keep one representative
								if OBJECT_FINDER.tracked[it.key] and OBJECT_FINDER.tracked[it.key].nameTag then
									if it.key == rep then
										-- store original text and color, then set to cluster label and supply color
										pcall(function()
											local lbl = OBJECT_FINDER.tracked[rep].nameTag:FindFirstChildWhichIsA("TextLabel")
											if lbl then
												OBJECT_FINDER.clusters[id].originalText = lbl.Text
												OBJECT_FINDER.clusters[id].originalColor = lbl.TextColor3
												lbl.Text = cfg.label
												-- if this cluster label is a Supply Drop, use supply color
												if cfg.label and string.find(cfg.label:lower(), "supply") then
													lbl.TextColor3 = COLOR_SUPPLY
												end
											end
										end)
									else
										pcall(function() OBJECT_FINDER.tracked[it.key].nameTag.Enabled = false end)
									end
								end
							end
						end
					end
				end
			end
		end
	end

	local function enableObjectFinder()
		if OBJECT_FINDER.enabled then return end
		OBJECT_FINDER.enabled = true
		OBJECT_FINDER.tracked = {}
		OBJECT_FINDER.clusters = {}
		-- scan and hook events
		task.spawn(initialScanObjectFinder)
		OBJECT_FINDER.connections.add = Workspace.DescendantAdded:Connect(function(inst)
			task.defer(function() processInstance(inst) end)
		end)
		OBJECT_FINDER.connections.remove = Workspace.DescendantRemoving:Connect(function(inst)
			for key, data in pairs(OBJECT_FINDER.tracked) do
				if not key or not key.Parent then
					if data.highlight and data.highlight.Parent then data.highlight:Destroy() end
					if data.nameTag and data.nameTag.Parent then data.nameTag:Destroy() end
					OBJECT_FINDER.tracked[key] = nil
				end
			end
		end)
		-- update cluster guis fading/scaling
		local cam = workspace.CurrentCamera
		local camPos = cam and cam.CFrame and cam.CFrame.Position
		if camPos then
			for id, c in pairs(OBJECT_FINDER.clusters) do
				pcall(function()
					if c and c.part and c.part.Position and c.gui and c.gui.Parent then
						local dist = (c.part.Position - camPos).Magnitude
						local fadeStart, fadeEnd = 60, 200
						local alpha = math.clamp((dist - fadeStart) / (fadeEnd - fadeStart), 0, 1)
						local lbl = c.gui:FindFirstChildWhichIsA("TextLabel")
						if lbl then
							lbl.TextTransparency = alpha
							lbl.TextStrokeTransparency = math.clamp(alpha * 0.9, 0, 1)
						end
						local baseW, baseH = 160, 40
						local w = math.floor(math.clamp(baseW * (1 - alpha * 0.8), 60, baseW))
						local h = math.floor(math.clamp(baseH * (1 - alpha * 0.8), 14, baseH))
						pcall(function() c.gui.Size = UDim2.new(0, w, 0, h) end)
					end
				end)
			end
		end
		OBJECT_FINDER.connections.heartbeat = RunService.Heartbeat:Connect(function()
			local cam = workspace.CurrentCamera
			local camPos = cam and cam.CFrame and cam.CFrame.Position
			for key, data in pairs(OBJECT_FINDER.tracked) do
				if not key or not key.Parent then
					if data.highlight and data.highlight.Parent then data.highlight:Destroy() end
					if data.nameTag and data.nameTag.Parent then data.nameTag:Destroy() end
					OBJECT_FINDER.tracked[key] = nil
				else
					pcall(function()
						if data.nameTag and data.nameTag.Parent and camPos then
							local posPart = nil
							if key:IsA("Model") then
								posPart = key.PrimaryPart or key:FindFirstChildWhichIsA("BasePart")
							elseif key:IsA("BasePart") then
								posPart = key
							end
							if posPart and posPart.Position then
								local dist = (posPart.Position - camPos).Magnitude
								local fadeStart, fadeEnd = 60, 200
								local alpha = math.clamp((dist - fadeStart) / (fadeEnd - fadeStart), 0, 1)
								local lbl = data.nameTag:FindFirstChildWhichIsA("TextLabel")
								if lbl then
									lbl.TextTransparency = alpha
									lbl.TextStrokeTransparency = math.clamp(alpha * 0.9, 0, 1)
								end
								local bb = data.nameTag
								local baseW, baseH = 100, 40
								local w = math.floor(math.clamp(baseW * (1 - alpha * 0.8), 40, baseW))
								local h = math.floor(math.clamp(baseH * (1 - alpha * 0.8), 14, baseH))
								pcall(function() bb.Size = UDim2.new(0, w, 0, h) end)
							end
						end
					end)
				end
			end
		end)
		OBJECT_FINDER.connections.cluster = RunService.Heartbeat:Connect(function(dt) updateClustersObjectFinder(dt) end)
	end

	local function disableObjectFinder()
		if not OBJECT_FINDER.enabled then return end
		OBJECT_FINDER.enabled = false
		-- disconnect connections
		for k,c in pairs(OBJECT_FINDER.connections) do
			pcall(function() if c and c.Disconnect then c:Disconnect() end end)
			OBJECT_FINDER.connections[k] = nil
		end
		-- destroy tracked highlights and guis
		for _, data in pairs(OBJECT_FINDER.tracked) do
			pcall(function() if data.highlight then data.highlight:Destroy() end end)
			pcall(function() if data.nameTag then data.nameTag:Destroy() end end)
		end
		OBJECT_FINDER.tracked = {}
		-- clear clusters
		clearClusters()
	end

	-- Add toggle to right column
	local objFinderToggle = makeToggle(rakeGroup, "Object Finder (Beta)", shouldEnableObjectFinder, function(v)
		if v then
			enableObjectFinder()
			if OBJECT_FINDER.isBeta then
				showBetaNoticeOnce()
			end
		else
			disableObjectFinder()
		end
		saveSettings()
	end)
	objFinderToggle.Position = UDim2.new(0, 8, 0, 92)

	local function modelHasPhysicalPart(root)
		if not root then return false end
		if root:IsA("BasePart") then
			local sz = root.Size and root.Size.Magnitude or 0
			if sz > 0.05 and (root.Transparency < 0.95 or root.CanCollide) then return true end
			return false
		end
		if root:IsA("Model") then
			for _, d in ipairs(root:GetDescendants()) do
				if d:IsA("BasePart") then
					local sz = d.Size and d.Size.Magnitude or 0
					if sz > 0.05 and (d.Transparency < 0.95 or d.CanCollide) then
						return true
					end
				end
			end
		end
		return false
	end

	local function getTrapModelRoot(inst)
		if not inst or not inst.Parent then return nil end
		if inst:IsA("BasePart") and inst.Parent and inst.Parent:IsA("Model") then
			return inst.Parent
		elseif inst:IsA("Model") then
			local part = inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart")
			if part then return inst end
			return nil
		elseif inst.Parent and inst.Parent:IsA("Model") then
			local m = inst.Parent
			local p = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
			if p then return m end
		end
		return nil
	end

	local function createTrapTag(root, adornPart, labelText, accentColor)
		if not SCREEN_GUI then return nil end
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "TrapNameTag"
		billboard.Adornee = adornPart or root
		billboard.Size = UDim2.new(0, 140, 0, 26)
		billboard.StudsOffsetWorldSpace = Vector3.new(0, 2.4, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = SCREEN_GUI

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = labelText or "Trap"
		label.TextColor3 = Color3.fromRGB(240,240,240)
		label.TextScaled = false
		label.TextSize = 14
		label.Font = Enum.Font.GothamBold
		label.TextStrokeTransparency = 0.8
		label.Parent = billboard

		local accent = Instance.new("Frame")
		accent.Size = UDim2.new(0, 6, 1, -8)
		accent.Position = UDim2.new(0, 6, 0, 4)
		accent.BackgroundColor3 = accentColor or Color3.fromRGB(255,80,80)
		accent.BorderSizePixel = 0
		accent.Parent = billboard

		return billboard
	end

	local function enableTrapDetector()
		if TRAP_DETECTOR and TRAP_DETECTOR.conn then return end
		TRAP_DETECTOR.enabled = true
		TRAP_DETECTOR.tracked = {}

		local function process(inst)
			local root = getTrapModelRoot(inst)
			if not root then return end
			local name = (root.Name or ""):lower()
			if not string.find(name, "trap", 1, true) then return end
			if TRAP_DETECTOR.tracked[root] then return end
			if not modelHasPhysicalPart(root) then return end
			local isRusty = string.find(name, "rusty", 1, true) ~= nil
			local color = isRusty and Color3.fromRGB(160,90,20) or Color3.fromRGB(255,80,80)
			local adorn = root.PrimaryPart or root:FindFirstChildWhichIsA("BasePart") or root
			local ok, h = pcall(function()
				local hl = Instance.new("Highlight")
				hl.Adornee = root
				hl.FillTransparency = 0.7
				hl.FillColor = color
				hl.OutlineTransparency = 0
				hl.OutlineColor = Color3.fromRGB(255,255,255)
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Parent = root
				return hl
			end)
			local tag = nil
			pcall(function() tag = createTrapTag(root, adorn, isRusty and "Rusty Trap" or "Trap", color) end)
			TRAP_DETECTOR.tracked[root] = { highlight = ok and h or nil, nameTag = tag }
		end

		-- initial scan
		for _, d in ipairs(Workspace:GetDescendants()) do
			pcall(function() process(d) end)
		end

		TRAP_DETECTOR.connections = {}
		TRAP_DETECTOR.connections.add = Workspace.DescendantAdded:Connect(function(inst) pcall(function() process(inst) end) end)
		TRAP_DETECTOR.connections.remove = Workspace.DescendantRemoving:Connect(function(inst)
			for k,_ in pairs(TRAP_DETECTOR.tracked) do
				if not k or not k.Parent then
					local td = TRAP_DETECTOR.tracked[k]
					if td then
						pcall(function() if td.highlight then td.highlight:Destroy() end end)
						pcall(function() if td.nameTag then td.nameTag:Destroy() end end)
					end
					TRAP_DETECTOR.tracked[k] = nil
				end
			end
		end)
		TRAP_DETECTOR.conn = RunService.Heartbeat:Connect(function()
			for obj, td in pairs(TRAP_DETECTOR.tracked) do
				if not obj or not obj.Parent then
					pcall(function() if td.highlight then td.highlight:Destroy() end end)
					pcall(function() if td.nameTag then td.nameTag:Destroy() end end)
					TRAP_DETECTOR.tracked[obj] = nil
				end
			end
		end)
	end

	local function disableTrapDetector()
		TRAP_DETECTOR.enabled = false
		if TRAP_DETECTOR.conn then TRAP_DETECTOR.conn:Disconnect() TRAP_DETECTOR.conn = nil end
		for k, c in pairs(TRAP_DETECTOR.connections or {}) do pcall(function() if c and c.Disconnect then c:Disconnect() end end) end
		for k, td in pairs(TRAP_DETECTOR.tracked or {}) do
			pcall(function() if td.highlight then td.highlight:Destroy() end end)
			pcall(function() if td.nameTag then td.nameTag:Destroy() end end)
			TRAP_DETECTOR.tracked[k] = nil
		end
		TRAP_DETECTOR.connections = {}
	end

	local trapToggle = makeToggle(rakeGroup, "Trap Detector", shouldEnableTrapDetector, function(v)
		TRAP_DETECTOR.enabled = v
		if v then
			pcall(function() enableTrapDetector() end)
			if TRAP_DETECTOR.isBeta then showBetaNoticeOnce() end
		else
			pcall(function() disableTrapDetector() end)
		end
		saveSettings()
	end)
	trapToggle.Position = UDim2.new(0, 8, 0, 132)

	if shouldEnableObjectFinder then
		pcall(function() enableObjectFinder() end)
	end

	if shouldEnableTrapDetector then
		pcall(function() enableTrapDetector() end)
	end


	local homeDefaultPos = homeBtn.Position
	local visualsDefaultPos = visualsBtn.Position
	local playerDefaultPos = playerBtn.Position
	local gameDefaultPos = gameBtn.Position
	local homeActivePos = UDim2.new(homeDefaultPos.X.Scale, homeDefaultPos.X.Offset, homeDefaultPos.Y.Scale, homeDefaultPos.Y.Offset - 6)
	local visualsActivePos = UDim2.new(visualsDefaultPos.X.Scale, visualsDefaultPos.X.Offset, visualsDefaultPos.Y.Scale, visualsDefaultPos.Y.Offset - 6)
	local playerActivePos = UDim2.new(playerDefaultPos.X.Scale, playerDefaultPos.X.Offset, playerDefaultPos.Y.Scale, playerDefaultPos.Y.Offset - 6)
	local gameActivePos = UDim2.new(gameDefaultPos.X.Scale, gameDefaultPos.X.Offset, gameDefaultPos.Y.Scale, gameDefaultPos.Y.Offset - 6)
	local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local function setActiveSection(name)
		-- ensure sections are visible for tweening
		homeSection.Visible = true
		visualsSection.Visible = true
		playerSection.Visible = true
		gameSection.Visible = true

		-- helper to compute target positions so active section slides to X=0
		local order = { Home = homeSection, Visuals = visualsSection, Player = playerSection, Game = gameSection }
		local activeIndex = (name == "Home" and 1) or (name == "Visuals" and 2) or (name == "Player" and 3) or 4
		local function posForIndex(idx)
			return UDim2.new(idx - activeIndex, 0, 0, 0)
		end
		if name == "Home" then
			TweenService:Create(homeBtn, tweenInfo, {Position = homeActivePos, TextColor3 = Color3.fromRGB(150,8,8)}):Play()
			TweenService:Create(visualsBtn, tweenInfo, {Position = visualsDefaultPos, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			TweenService:Create(playerBtn, tweenInfo, {Position = playerDefaultPos, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			TweenService:Create(gameBtn, tweenInfo, {Position = gameDefaultPos, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			-- animate backgrounds
			TweenService:Create(homeBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60,60,70)}):Play()
			TweenService:Create(visualsBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(38,38,45)}):Play()
			TweenService:Create(playerBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(38,38,45)}):Play()
			-- move tab indicator
			if tabIndicator then
				local tgt = UDim2.new(0, homeDefaultPos.X.Offset, 1, -3)
				TweenService:Create(tabIndicator, tweenInfo, {Position = tgt}):Play()
			end
			-- slide sections: home -> center
			TweenService:Create(homeSection, tweenInfo, {Position = posForIndex(1)}):Play()
			TweenService:Create(visualsSection, tweenInfo, {Position = posForIndex(2)}):Play()
			TweenService:Create(playerSection, tweenInfo, {Position = posForIndex(3)}):Play()
			TweenService:Create(gameSection, tweenInfo, {Position = posForIndex(4)}):Play()
		elseif name == "Visuals" then
			TweenService:Create(visualsBtn, tweenInfo, {Position = visualsActivePos, TextColor3 = Color3.fromRGB(150,8,8)}):Play()
			TweenService:Create(homeBtn, tweenInfo, {Position = homeDefaultPos, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			TweenService:Create(playerBtn, tweenInfo, {Position = playerDefaultPos, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			TweenService:Create(gameBtn, tweenInfo, {Position = gameDefaultPos, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			-- animate backgrounds
			TweenService:Create(visualsBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60,60,70)}):Play()
			TweenService:Create(homeBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(38,38,45)}):Play()
			TweenService:Create(playerBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(38,38,45)}):Play()
			-- move tab indicator
			if tabIndicator then
				local tgt = UDim2.new(0, visualsDefaultPos.X.Offset, 1, -3)
				TweenService:Create(tabIndicator, tweenInfo, {Position = tgt}):Play()
			end
			-- slide sections: visuals -> center
			TweenService:Create(homeSection, tweenInfo, {Position = posForIndex(1)}):Play()
			TweenService:Create(visualsSection, tweenInfo, {Position = posForIndex(2)}):Play()
			TweenService:Create(playerSection, tweenInfo, {Position = posForIndex(3)}):Play()
			TweenService:Create(gameSection, tweenInfo, {Position = posForIndex(4)}):Play()
		elseif name == "Player" then
			TweenService:Create(playerBtn, tweenInfo, {Position = playerActivePos, TextColor3 = Color3.fromRGB(150,8,8)}):Play()
			TweenService:Create(homeBtn, tweenInfo, {Position = homeDefaultPos, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			TweenService:Create(visualsBtn, tweenInfo, {Position = visualsDefaultPos, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			TweenService:Create(gameBtn, tweenInfo, {Position = gameDefaultPos, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			-- animate backgrounds
			TweenService:Create(playerBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60,60,70)}):Play()
			TweenService:Create(homeBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(38,38,45)}):Play()
			TweenService:Create(visualsBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(38,38,45)}):Play()
			TweenService:Create(gameBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(38,38,45)}):Play()
			-- move tab indicator
			if tabIndicator then
				local tgt = UDim2.new(0, playerDefaultPos.X.Offset, 1, -3)
				TweenService:Create(tabIndicator, tweenInfo, {Position = tgt}):Play()
			end
			-- slide sections: player -> center
			TweenService:Create(homeSection, tweenInfo, {Position = posForIndex(1)}):Play()
			TweenService:Create(visualsSection, tweenInfo, {Position = posForIndex(2)}):Play()
			TweenService:Create(playerSection, tweenInfo, {Position = posForIndex(3)}):Play()
			TweenService:Create(gameSection, tweenInfo, {Position = posForIndex(4)}):Play()
		elseif name == "Game" then
			TweenService:Create(gameBtn, tweenInfo, {Position = gameActivePos, TextColor3 = Color3.fromRGB(150,8,8)}):Play()
			TweenService:Create(homeBtn, tweenInfo, {Position = homeDefaultPos, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			TweenService:Create(visualsBtn, tweenInfo, {Position = visualsDefaultPos, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			TweenService:Create(playerBtn, tweenInfo, {Position = playerDefaultPos, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			-- animate backgrounds
			TweenService:Create(gameBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60,60,70)}):Play()
			TweenService:Create(homeBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(38,38,45)}):Play()
			TweenService:Create(visualsBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(38,38,45)}):Play()
			TweenService:Create(playerBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(38,38,45)}):Play()
			-- move tab indicator
			if tabIndicator then
				local tgt = UDim2.new(0, gameDefaultPos.X.Offset, 1, -3)
				TweenService:Create(tabIndicator, tweenInfo, {Position = tgt}):Play()
			end
			-- slide sections: game -> center
			TweenService:Create(homeSection, tweenInfo, {Position = posForIndex(1)}):Play()
			TweenService:Create(visualsSection, tweenInfo, {Position = posForIndex(2)}):Play()
			TweenService:Create(playerSection, tweenInfo, {Position = posForIndex(3)}):Play()
			TweenService:Create(gameSection, tweenInfo, {Position = posForIndex(4)}):Play()
		end
	end

	homeBtn.MouseButton1Click:Connect(function()
		setActiveSection("Home")
	end)
	visualsBtn.MouseButton1Click:Connect(function()
		setActiveSection("Visuals")
	end)
	playerBtn.MouseButton1Click:Connect(function()
		setActiveSection("Player")
	end)
	gameBtn.MouseButton1Click:Connect(function()
		setActiveSection("Game")
	end)

	setActiveSection("Home")
	-- subtle pop-in animation for the main panel
	pcall(function()
		local orig = mainFrame.Position
		mainFrame.Position = UDim2.new(orig.X.Scale, orig.X.Offset, orig.Y.Scale, orig.Y.Offset - 28)
		if TweenService then
			local popTween = TweenService:Create(mainFrame, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = orig})
			popTween:Play()
		end
	end)
    mainFrame.Visible = false
end

-- Create GUI 
createESPGui()
if SCREEN_GUI then
	local ok = false
	pcall(function()
		SCREEN_GUI.DisplayOrder = 1000
		SCREEN_GUI.Parent = CoreGui
		ok = true
	end)
	if not ok then
		SCREEN_GUI.Parent = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") or SCREEN_GUI.Parent
		SCREEN_GUI.DisplayOrder = 1000
	end
	SCREEN_GUI.Enabled = true
end

-- Reapply improved/fullbright lighting after player respawn
pcall(function()
	if LocalPlayer then
		localPlayerRespawnConn = LocalPlayer.CharacterAdded:Connect(function()
			if IMPROVED_LIGHTING_ENABLED then
				pcall(function()
					dofullbright()
					if not _dofullbright_conn then
						_dofullbright_conn = Light.LightingChanged:Connect(dofullbright)
					end
				end)
			end
		end)
	end
end)

local function setMouseVisible(visible)
	if visible then
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true
	else
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseIconEnabled = false
	end
end

local mouseVisible = true
setMouseVisible(true)

insertToggleConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Insert and SCREEN_GUI then
        SCREEN_GUI.Enabled = not SCREEN_GUI.Enabled
	end
end)

-- GUI END
