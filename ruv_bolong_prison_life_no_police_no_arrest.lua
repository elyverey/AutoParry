local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local Teams = game:GetService("Teams")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LIBRARY_URL = "https://raw.githubusercontent.com/RillBoys/bolong.catui/refs/heads/main/b0lngUi.lua"
local libraryOk, Chloex = pcall(function()
    return loadstring(game:HttpGet(LIBRARY_URL))()
end)
if not libraryOk or not Chloex then
    error("Library file not found: b0lngUi.lua")
end

local ACCENT_COLOR = Color3.fromRGB(255, 255, 255)
local UIControls = {}
local UINotify = function(title, content, delayTime)
    -- Notifications disabled.
end

local guardsTeam = Teams:FindFirstChild("Guards")
local inmatesTeam = Teams:FindFirstChild("Inmates")
local criminalsTeam = Teams:FindFirstChild("Criminals")

local cfg = {
    enabled = true, -- toggle the whole script on/off
    teamcheck = true, -- dont shoot people on your team
    wallcheck = true, -- dont shoot through walls
    deathcheck = true, -- skip dead players
    ffcheck = true, -- skip players with forcefield
    hostilecheck = true, -- only shoot hostile inmates (guards only)
    trespasscheck = true, -- only shoot trespassing inmates (guards only)
    vehiclecheck = true, -- dont shoot people sitting in cars
    criminalsnoinnmates = true, -- criminals wont shoot inmates
    inmatesnocriminals = true, -- inmates wont shoot criminals
    shieldbreaker = true, -- target shields to break them instead of being blocked
    shieldfrontangle = 0.3, -- (DONT CHANGE) how wide the shield covers (-1 to 1, lower = wider, 0.3 = ~70 degrees)
    shieldrandomhead = true, -- randomly hit head instead of shield sometimes (more legit)
    shieldheadchance = 30, -- percent chance to hit head instead of shield (0-100)
    taserbypasshostile = false, -- taser ignores hostile check
    taserbypasstrespass = false, -- taser ignores trespass check
    taseralwayshit = true, -- taser never misses
    ifplayerstill = false, -- always hit if player isnt moving
    stillthreshold = 0.5, -- how slow they gotta be to count as still
    hitchance = 65, -- percent chance to actually hit (0-100)
    hitchanceAutoOnly = false, -- only apply hitchance to automatic weapons (shotguns always hit)
    distancebasedhitchance = false, -- use distance breakpoints to change hitchance
    distancehitchance1dist = 200, -- at/after this distance, use hitchance 1
    distancehitchance1value = 30,
    distancehitchance2dist = 350, -- at/after this distance, use hitchance 2
    distancehitchance2value = 20,
    distancehitchance3dist = 500, -- at/after this distance, use hitchance 3
    distancehitchance3value = 10,
    distancehitchance4dist = 650, -- at/after this distance, use hitchance 4
    distancehitchance4value = 5,
    distancehitchance5dist = 800, -- at/after this distance, use hitchance 5
    distancehitchance5value = 1,
    autoshoot = false, -- automatically shoot when target is found
    autoshootweapon = "Any", -- valid values: "Any", "Taser", "M9", "AK-47", "M4A1", "Remington 870", "Revolver", "Shotgun", "Sniper", "Automatic"
    autoshootdelay = 0.12, -- delay between auto shots
    autoshootstartdelay = 0.2, -- delay before first shot when target acquired (reaction time)
    aimmaxdist = 100, -- max studs a target can be from you (set to 0 for any distance)
    missspread = 5, -- how far off to shoot when missing (makes it look legit)
    shotgunnaturalspread = true, -- let shotgun bullets spread naturally instead of all hitting
    shotgungamehandled = false, -- aim at player but let game handle hitchance/spread
    prioritizeclosest = true, -- shoot whoever is closest to your cursor (false = random from fov)
    prioritizecriminals = true, -- if an inmate and criminal are both in fov, prefer the criminal
    targetstickiness = false, -- enable/disable target stickiness
    targetstickinessduration = 0.6, -- how long to keep target (seconds)
    targetstickinessrandom = false, -- use random range instead of fixed value
    targetstickinessmin = 0.3, -- min time if random is on
    targetstickinessmax = 0.7, -- max time if random is on
    fov = 150, -- how big the aim circle is
    showfov = true, -- show the fov circle on screen
    staticfov = true, -- keep the fov centered instead of following touch/mouse
    showtargetline = false, -- draw a line to your target
    togglekey = Enum.KeyCode.RightShift, -- key to toggle silent aim
    aimpart = "Head", -- what body part to aim at
    randomparts = true, -- randomly pick body parts instead
    partslist = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart"}, -- parts to pick from if random is on (can add more if wanted)
    esp = true,
    espteamcheck = true,
    espshowteam = false,
    esptargets = {guards = true, inmates = true, criminals = true},
    espmaxdist = 500, -- set to 0 for any distance
    espshowdist = true,
    esptoggle = Enum.KeyCode.RightControl,
    espcolor = Color3.fromRGB(0, 170, 255),
    espguards = Color3.fromRGB(0, 170, 255),
    espinmates = Color3.fromRGB(255, 150, 50),
    espcriminals = Color3.fromRGB(255, 60, 60),
    espteam = Color3.fromRGB(60, 255, 60),
    espuseteamcolors = true,
    c4esp = true,
    c4esptoggle = Enum.KeyCode.B,
    c4espcolor = Color3.fromRGB(80, 255, 80),
    c4espmaxdist = 200, -- set to 0 for any distance
    c4espshowdist = true,
    autograb = true, -- auto grab keycards / m9 when they sit near you
    autograbdistance = 12, -- max pickup distance (12 studs max)
    autograbdelay = 1, -- how long the item must stay nearby before grabbing
    autograbkeycard = true,
    autograbm9 = true,
    teleportdistance = 3,
    teleportpanelunits = 4, -- 4 units = 60x60 px
    hitboxenabled = false,
    fullbright = false,
    hitboxsize = 8,
    autoswitchpanel = false,
    autoswitchactive = false,
    autoswitchteam = "Inmates",
    autoswitchfirerate = 0.05,
    autoswitchdistance = 500,
    autoswitchautoreload = true,
    autoswitchwallcheck = true,
    spin = false,
    walkonwall = false,
    movementwalkspeed = 16,
    movementjumppower = 50,
    movementgravity = Workspace.Gravity,
    movementfov = 70, -- movement camera FOV slider scale (70-300)
    noclip = false,
    infinityjump = false,
}

-- Capture this game's current movement values once. Returning a slider to its
-- initial value restores the Humanoid/camera values captured for that character,
-- instead of forcing generic defaults over game-specific movement settings.
local movementOriginals = setmetatable({}, {__mode = "k"})
local movementCameraOriginals = setmetatable({}, {__mode = "k"})
local movementGravityOriginal = Workspace.Gravity
local movementWalkSpeedResetValue = 16
local movementJumpPowerResetValue = 50
local movementGravityResetValue = math.clamp(math.floor((tonumber(Workspace.Gravity) or 196.2) + 0.5), 0, 300)
local movementFovResetValue = 70
local movementWalkSpeedEdited = false
local movementGravityEdited = false
local movementFovEdited = false
local movementJumpPowerEdited = false
local movementFovOriginal = 70
local setNoclip
local setFullbright
local setSpin
local setWalkOnWall
local updateMovementSettings

local function getMovementHumanoid()
    local character = LocalPlayer.Character
    return character and character:FindFirstChildOfClass("Humanoid") or nil
end

local function captureMovementOriginals(humanoid)
    if not humanoid or movementOriginals[humanoid] then return end
    movementOriginals[humanoid] = {
        WalkSpeed = humanoid.WalkSpeed,
        JumpPower = humanoid.JumpPower,
        JumpHeight = humanoid.JumpHeight,
        UseJumpPower = humanoid.UseJumpPower,
    }
end

local function captureMovementCamera(camera)
    if not camera or movementCameraOriginals[camera] ~= nil then return end
    movementCameraOriginals[camera] = camera.FieldOfView
end

local function restoreMovementJump(humanoid)
    local original = humanoid and movementOriginals[humanoid]
    if not humanoid or not original then return end
    pcall(function()
        humanoid.UseJumpPower = original.UseJumpPower
        humanoid.JumpPower = original.JumpPower
        humanoid.JumpHeight = original.JumpHeight
    end)
end

do
    local humanoid = getMovementHumanoid()
    if humanoid then
        captureMovementOriginals(humanoid)
        movementWalkSpeedResetValue = math.clamp(math.floor((tonumber(humanoid.WalkSpeed) or 16) + 0.5), 16, 200)
        movementJumpPowerResetValue = math.clamp(math.floor((tonumber(humanoid.JumpPower) or 50) + 0.5), 50, 300)
        cfg.movementwalkspeed = movementWalkSpeedResetValue
        cfg.movementjumppower = movementJumpPowerResetValue
    end

    movementGravityOriginal = Workspace.Gravity
    cfg.movementgravity = movementGravityResetValue

    local camera = Workspace.CurrentCamera
    if camera then
        captureMovementCamera(camera)
        movementFovOriginal = camera.FieldOfView
        movementFovResetValue = math.clamp(math.floor((tonumber(camera.FieldOfView) or 70) + 0.5), 70, 120)
    end
    cfg.movementfov = movementFovResetValue
end

local function applyMovementSetting(key, value)
    local numericValue = tonumber(value)
    if not numericValue then return end

    if key == "movementwalkspeed" then
        local target = math.clamp(numericValue, 16, 200)
        movementWalkSpeedEdited = math.abs(target - movementWalkSpeedResetValue) > 0.01
        local humanoid = getMovementHumanoid()
        if humanoid then
            captureMovementOriginals(humanoid)
            if movementWalkSpeedEdited then
                pcall(function() humanoid.WalkSpeed = target end)
            else
                local original = movementOriginals[humanoid]
                if original then pcall(function() humanoid.WalkSpeed = original.WalkSpeed end) end
            end
        end
    elseif key == "movementjumppower" then
        local target = math.clamp(numericValue, 50, 300)
        movementJumpPowerEdited = math.abs(target - movementJumpPowerResetValue) > 0.01
        local humanoid = getMovementHumanoid()
        if humanoid then
            captureMovementOriginals(humanoid)
            if movementJumpPowerEdited then
                pcall(function()
                    humanoid.UseJumpPower = true
                    humanoid.JumpPower = target
                end)
            else
                restoreMovementJump(humanoid)
            end
        end
    elseif key == "movementgravity" then
        local target = math.clamp(numericValue, 0, 300)
        movementGravityEdited = math.abs(target - movementGravityResetValue) > 0.5
        pcall(function()
            Workspace.Gravity = movementGravityEdited and target or movementGravityOriginal
        end)
    elseif key == "movementfov" then
        local target = math.clamp(numericValue, 70, 120)
        movementFovEdited = math.abs(target - movementFovResetValue) > 0.01
        local camera = Workspace.CurrentCamera
        if camera then
            captureMovementCamera(camera)
            local original = movementCameraOriginals[camera] or movementFovOriginal
            pcall(function()
                camera.FieldOfView = movementFovEdited and target or original
            end)
        end
    end
end

-- BOLONG-HUB UI: all controls here update the original Prison Life config.
local function uiLabel(section, title, content)
    pcall(function()
        section:AddLabel({Title = title, Content = content or ""})
    end)
end

local function uiToggle(section, key, title, targetTable)
    local initial
    if targetTable then
        initial = targetTable[key]
    else
        initial = cfg[key]
    end
    local ok, control = pcall(function()
        return section:AddToggle({
            Title = title,
            Default = initial == true,
            Callback = function(value)
                if targetTable then
                    targetTable[key] = value == true
                else
                    cfg[key] = value == true
                end

                if not targetTable and key == "noclip" and setNoclip then
                    setNoclip(cfg.noclip)
                elseif not targetTable and key == "fullbright" and setFullbright then
                    setFullbright(cfg.fullbright)
                elseif not targetTable and key == "spin" and setSpin then
                    setSpin(cfg.spin)
                elseif not targetTable and key == "walkonwall" and setWalkOnWall then
                    setWalkOnWall(cfg.walkonwall)
                end
            end
        })
    end)
    if ok and control then
        UIControls[key] = control
    else
        uiLabel(section, title, "This control was not supported by the loaded BOLONG UI build.")
    end
end

local function uiSlider(section, key, title, minValue, maxValue, increment, note)
    local ok, control = pcall(function()
        return section:AddSlider({
            Title = title,
            Min = minValue,
            Max = maxValue,
            Default = math.clamp(tonumber(cfg[key]) or minValue, minValue, maxValue),
            Increment = increment,
            Callback = function(value)
                local numberValue = tonumber(value)
                if numberValue then
                    cfg[key] = math.clamp(numberValue, minValue, maxValue)
                    if string.sub(tostring(key), 1, 8) == "movement" then
                        applyMovementSetting(key, cfg[key])
                    end
                end
            end
        })
    end)
    if not ok or not control then
        uiLabel(section, title, note or ("Current value: " .. tostring(cfg[key])))
    elseif note then
        uiLabel(section, "Info", note)
    end
end

local function selectedOption(value, options)
    if type(value) == "number" then
        return options[value] or options[value + 1] or options[1]
    end
    return value
end

local function uiDropdown(section, key, title, options, defaultValue, callback)
    local function onChanged(value)
        value = selectedOption(value, options)
        if callback then
            callback(value)
        elseif key then
            cfg[key] = value
        end
    end

    local ok, control = pcall(function()
        return section:AddDropdown({
            Title = title,
            Options = options,
            Default = defaultValue,
            Callback = onChanged
        })
    end)
    if (not ok) or (not control) then
        ok, control = pcall(function()
            return section:AddDropdown({
                Title = title,
                Values = options,
                Default = defaultValue,
                Callback = onChanged
            })
        end)
    end
    if ok and control then
        if key then UIControls[key] = control end
    else
        uiLabel(section, title, "Current value: " .. tostring(defaultValue))
    end
end

local function uiColor(section, key, title)
    local function setColor(color)
        if typeof(color) == "Color3" then cfg[key] = color end
    end

    local ok, control = pcall(function()
        return section:AddColorPicker({
            Title = title,
            Default = cfg[key],
            Callback = setColor
        })
    end)
    if (not ok) or (not control) then
        ok, control = pcall(function()
            return section:AddColorpicker({
                Title = title,
                Default = cfg[key],
                Callback = setColor
            })
        end)
    end
    if ok and control then
        UIControls[key] = control
        return
    end

    -- Fallback controls if the installed BOLONG build has no color picker.
    local initialColor = cfg[key]
    local components = {
        {name = "R", channel = "R", default = math.floor(initialColor.R * 255 + 0.5)},
        {name = "G", channel = "G", default = math.floor(initialColor.G * 255 + 0.5)},
        {name = "B", channel = "B", default = math.floor(initialColor.B * 255 + 0.5)}
    }
    for _, component in ipairs(components) do
        local componentKey = key .. "_" .. component.channel
        pcall(function()
            section:AddSlider({
                Title = title .. " " .. component.name,
                Min = 0,
                Max = 255,
                Default = component.default,
                Increment = 1,
                Callback = function(value)
                    local r, g, b = cfg[key].R, cfg[key].G, cfg[key].B
                    if component.channel == "R" then r = math.clamp(value, 0, 255) / 255 end
                    if component.channel == "G" then g = math.clamp(value, 0, 255) / 255 end
                    if component.channel == "B" then b = math.clamp(value, 0, 255) / 255 end
                    cfg[key] = Color3.new(r, g, b)
                end
            })
        end)
    end
end

local function uiKeybind(section, key, title)
    local current = cfg[key] or Enum.KeyCode.Unknown
    local ok, control = pcall(function()
        return section:AddKeybind({
            Title = title,
            Content = "Click the key box, then press a key",
            Default = current,
            Callback = function(keyCode)
                if typeof(keyCode) == "EnumItem" and keyCode.EnumType == Enum.KeyCode then
                    cfg[key] = keyCode
                end
            end
        })
    end)
    if ok and control then
        UIControls[key] = control
        if typeof(control.Value) == "EnumItem" and control.Value.EnumType == Enum.KeyCode
            and control.Value ~= Enum.KeyCode.Unknown then
            cfg[key] = control.Value
        end
        return
    end

    local keyNames = {
        "RightShift", "LeftShift", "RightControl", "LeftControl",
        "Insert", "Home", "End", "Delete", "F", "G", "H", "J",
        "K", "L", "Q", "E", "R", "T", "Y", "U", "I", "O",
        "P", "A", "S", "D", "W", "Z", "X", "C", "V", "B",
        "N", "M", "One", "Two", "Three", "Four", "Five"
    }
    local currentName = current.Name
    uiDropdown(section, key, title, keyNames, currentName, function(value)
        local enumValue = Enum.KeyCode[tostring(value)]
        if enumValue then cfg[key] = enumValue end
    end)
end

local function uiPartToggle(section, partName)
    local enabled = table.find(cfg.partslist, partName) ~= nil
    pcall(function()
        section:AddToggle({
            Title = "Random part: " .. partName,
            Default = enabled,
            Callback = function(value)
                local index = table.find(cfg.partslist, partName)
                if value and not index then
                    table.insert(cfg.partslist, partName)
                elseif not value and index then
                    table.remove(cfg.partslist, index)
                end
                if #cfg.partslist == 0 then
                    table.insert(cfg.partslist, "Head")
                end
            end
        })
    end)
end

local function syncUIToggle(key, value)
    local control = UIControls[key]
    if not control then return end
    for _, methodName in ipairs({"SetValue", "Set", "SetState"}) do
        local methodOk, method = pcall(function() return control[methodName] end)
        if methodOk and type(method) == "function" then
            local setOk = pcall(function() method(control, value) end)
            if setOk then return end
        end
    end
end

local teleportGui = nil
local teleportButton = nil
local teleportPanelEnabled = false
local teleportTweening = false
local teleportSetEnabled
local autoswitchPanelSetEnabled
local autoSwitchCaptureOriginalTool
local restoreAutoSwitchTool
local autoSwitchPanelGui = nil
local autoSwitchPanelButton = nil

local function updateTeleportPanelSize()
    if teleportButton then
        local units = math.clamp(tonumber(cfg.teleportpanelunits) or 4, 4, 10)
        local pixels = units * 15 -- 4 = 60px, as requested
        teleportButton.Size = UDim2.fromOffset(pixels, pixels)
    end
end

local function teleportInFront()
    if teleportTweening then return end

    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then
        UINotify("Teleport Forward", "Character is not ready.", 2)
        return
    end

    local distance = math.clamp(tonumber(cfg.teleportdistance) or 3, 2, 10)
    local startCFrame = root.CFrame
    local destination = startCFrame + startCFrame.LookVector * distance
    local tweenInfo = TweenInfo.new(0.055, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local ok, tween = pcall(function()
        return TweenService:Create(root, tweenInfo, {CFrame = destination})
    end)
    if not ok or not tween then
        UINotify("Teleport Forward", "Could not start the movement tween.", 2)
        return
    end

    teleportTweening = true
    local completedConnection
    completedConnection = tween.Completed:Connect(function()
        if completedConnection then completedConnection:Disconnect() end
        teleportTweening = false
    end)
    tween:Play()
end

local function createTeleportPanel()
    if teleportButton and teleportButton.Parent then
        return
    end

    local old
    pcall(function()
        local parent = (type(gethui) == "function" and gethui()) or CoreGui
        old = parent:FindFirstChild("BOLONG_TeleportPanel")
        if not old then old = CoreGui:FindFirstChild("BOLONG_TeleportPanel") end
    end)
    if old then pcall(function() old:Destroy() end) end

    local parent = CoreGui
    pcall(function()
        if type(gethui) == "function" then parent = gethui() end
    end)

    local screen = Instance.new("ScreenGui")
    screen.Name = "BOLONG_TeleportPanel"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = parent

    local button = Instance.new("TextButton")
    button.Name = "TeleportButton"
    button.AnchorPoint = Vector2.new(0, 0)
    button.Position = UDim2.new(1, -84, 0.5, -30)
    button.Size = UDim2.fromOffset(60, 60)
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.BackgroundTransparency = 0.77
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Active = true
    button.Text = "Teleport"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 13
    button.TextWrapped = true
    button.Font = Enum.Font.GothamBold
    button.Visible = teleportPanelEnabled
    button.Parent = screen

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Name = "Outline"
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 2
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = button

    teleportGui = screen
    teleportButton = button
    updateTeleportPanelSize()

    -- A short movement threshold prevents ordinary taps/clicks from shifting the panel.
    local pointerDown = false
    local dragInput = nil
    local dragStart = nil
    local startPosition = nil
    local didDrag = false
    local suppressNextClick = false

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            pointerDown = true
            didDrag = false
            dragStart = input.Position
            startPosition = button.Position
            dragInput = input.UserInputType == Enum.UserInputType.Touch and input or nil
        end
    end)

    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not pointerDown or not dragStart or not startPosition then return end
        if dragInput and input == dragInput then
            local delta = input.Position - dragStart
            if delta.Magnitude >= 6 then
                didDrag = true
                button.Position = UDim2.new(
                    startPosition.X.Scale, startPosition.X.Offset + delta.X,
                    startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
                )
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        local isRelease = input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        if pointerDown and isRelease then
            pointerDown = false
            dragInput = nil
            dragStart = nil
            startPosition = nil
            if didDrag then
                suppressNextClick = true
                task.delay(0.15, function()
                    suppressNextClick = false
                end)
            end
        end
    end)

    button.Activated:Connect(function()
        if suppressNextClick or didDrag then
            suppressNextClick = false
            return
        end
        teleportInFront()
    end)
end

teleportSetEnabled = function(enabled)
    teleportPanelEnabled = enabled == true
    if teleportPanelEnabled then
        createTeleportPanel()
        if teleportGui then teleportGui.Enabled = true end
        if teleportButton then teleportButton.Visible = true end
    else
        if teleportButton then teleportButton.Visible = false end
        if teleportGui then teleportGui.Enabled = false end
    end
end

local function updateAutoSwitchPanelVisual()
    if not autoSwitchPanelButton then return end
    autoSwitchPanelButton.Text = cfg.autoswitchactive and "ON" or "FIRE"
    autoSwitchPanelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end

local function createAutoSwitchPanel()
    if autoSwitchPanelButton and autoSwitchPanelButton.Parent then return end

    local parent = CoreGui
    pcall(function()
        if type(gethui) == "function" then parent = gethui() end
    end)
    pcall(function()
        local existing = parent:FindFirstChild("BOLONG_AutoShootSwitchPanel")
        if existing then existing:Destroy() end
    end)

    local screen = Instance.new("ScreenGui")
    screen.Name = "BOLONG_AutoShootSwitchPanel"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = parent

    local button = Instance.new("TextButton")
    button.Name = "SwitchShootButton"
    button.AnchorPoint = Vector2.new(0, 0)
    button.Position = UDim2.new(1, -68, 0.5, -25)
    button.Size = UDim2.fromOffset(50, 50)
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.BackgroundTransparency = 0.77
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Active = true
    button.Text = "FIRE"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 11
    button.Font = Enum.Font.GothamBold
    button.Parent = screen

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Name = "Outline"
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 2
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = button

    autoSwitchPanelGui = screen
    autoSwitchPanelButton = button
    updateAutoSwitchPanelVisual()

    local pointerDown = false
    local dragStart = nil
    local startPosition = nil
    local activeTouch = nil
    local didDrag = false
    local suppressClick = false

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            pointerDown = true
            dragStart = input.Position
            startPosition = button.Position
            activeTouch = input.UserInputType == Enum.UserInputType.Touch and input or nil
            didDrag = false
        end
    end)

    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if input.UserInputType == Enum.UserInputType.Touch then activeTouch = input end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not pointerDown or not dragStart or not startPosition then return end
        local matches = input.UserInputType == Enum.UserInputType.MouseMovement
            or (activeTouch ~= nil and input == activeTouch)
        if not matches then return end
        local delta = input.Position - dragStart
        if delta.Magnitude >= 6 then
            didDrag = true
            button.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        local release = input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
        if pointerDown and release then
            pointerDown = false
            dragStart = nil
            startPosition = nil
            activeTouch = nil
            if didDrag then
                suppressClick = true
                task.delay(0.15, function() suppressClick = false end)
            end
        end
    end)

    button.Activated:Connect(function()
        if suppressClick or didDrag then
            suppressClick = false
            return
        end
        cfg.autoswitchactive = not cfg.autoswitchactive
        if cfg.autoswitchactive then
            if autoSwitchCaptureOriginalTool then autoSwitchCaptureOriginalTool() end
        else
            if restoreAutoSwitchTool then restoreAutoSwitchTool() end
        end
        updateAutoSwitchPanelVisual()
    end)
end

autoswitchPanelSetEnabled = function(enabled)
    cfg.autoswitchpanel = enabled == true
    if cfg.autoswitchpanel then
        createAutoSwitchPanel()
        if autoSwitchPanelGui then autoSwitchPanelGui.Enabled = true end
        if autoSwitchPanelButton then autoSwitchPanelButton.Visible = true end
    else
        cfg.autoswitchactive = false
        if restoreAutoSwitchTool then restoreAutoSwitchTool() end
        if autoSwitchPanelButton then autoSwitchPanelButton.Visible = false end
        if autoSwitchPanelGui then autoSwitchPanelGui.Enabled = false end
        updateAutoSwitchPanelVisual()
    end
end

local fullbrightOriginals = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
}
local fullbrightConnection = nil

local function applyFullbright()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end

setFullbright = function(enabled)
    cfg.fullbright = enabled == true
    if cfg.fullbright then
        if fullbrightConnection then
            fullbrightConnection:Disconnect()
            fullbrightConnection = nil
        end
        applyFullbright()
        fullbrightConnection = RunService.RenderStepped:Connect(function()
            if cfg.fullbright then
                pcall(applyFullbright)
            end
        end)
    else
        if fullbrightConnection then
            fullbrightConnection:Disconnect()
            fullbrightConnection = nil
        end
        pcall(function()
            Lighting.Brightness = fullbrightOriginals.Brightness
            Lighting.ClockTime = fullbrightOriginals.ClockTime
            Lighting.FogEnd = fullbrightOriginals.FogEnd
            Lighting.GlobalShadows = fullbrightOriginals.GlobalShadows
            Lighting.Ambient = fullbrightOriginals.Ambient
            Lighting.OutdoorAmbient = fullbrightOriginals.OutdoorAmbient
        end)
    end
end

local function BuildUI()
    local Window = Chloex:Window({
        Title = "BOLONG-HUB",
        Image = "84034353458936",
        Footer = "Prison Life",
        Author = "Discord.gg/pWpgqVGxNK",
        Color = ACCENT_COLOR,
        Version = 1,
        Search = true,
        Folder = "BolongHub"
    })

    -- Requested tab order: Info, Main, Movement, Combat, Visuals, Fun, Configs.
    local InfoTab = Window:AddTab({Name = "Info", Icon = "info"})
    local MainTab = Window:AddTab({Name = "Main", Icon = "house"})
    local MovementTab = Window:AddTab({Name = "Movement", Icon = "move"})
    local ExclusiveTab = Window:AddTab({Name = "Combat", Icon = "crosshair"})
    local VisualsTab = Window:AddTab({Name = "Visuals", Icon = "eye"})
    local FunTab = Window:AddTab({Name = "Fun", Icon = "zap"})
    local ConfigManagerTab = Window:AddTab({Name = "Configs", Icon = "settings"})

    local InfoSection = InfoTab:AddSection("BOLONG-HUB | Prison Life", nil)
    uiLabel(InfoSection, "Info", "Prison Life script controls and configuration.")

    -- Main: teleport and Auto Grab.
    local MainSection = MainTab:AddSection("Teleport Forward", nil)
    local toggleOk, toggleControl = pcall(function()
        return MainSection:AddToggle({
            Title = "Teleport Forward",
            Default = false,
            Callback = function(value)
                teleportSetEnabled(value == true)
            end
        })
    end)
    if toggleOk and toggleControl then
        UIControls.teleportPanelEnabled = toggleControl
    else
        uiLabel(MainSection, "Teleport Forward", "This toggle was not supported by the loaded BOLONG UI build.")
    end
    uiSlider(MainSection, "teleportdistance", "Teleport distance (studs)", 2, 10, 1)

    local panelSizeOk = pcall(function()
        MainSection:AddSlider({
            Title = "Teleport panel size (4 = 60x60)",
            Min = 4,
            Max = 10,
            Default = 4,
            Increment = 1,
            Callback = function(value)
                cfg.teleportpanelunits = math.clamp(tonumber(value) or 4, 4, 10)
                updateTeleportPanelSize()
            end
        })
    end)
    if not panelSizeOk then
        uiLabel(MainSection, "Teleport panel size", "Default: 60x60 px. Adjustable from 4 to 10 units when slider support is available.")
    end
    uiLabel(MainSection, "Teleport panel", "Tap Teleport to move forward. Drag the square to reposition it.")

    local HitboxSection = MainTab:AddSection("Hitbox Expander", nil)
    uiToggle(HitboxSection, "hitboxenabled", "Hitbox Expander")
    uiSlider(HitboxSection, "hitboxsize", "Hitbox size", 1, 30, 1)

    local FullbrightSection = MainTab:AddSection("Fullbright", nil)
    uiToggle(FullbrightSection, "fullbright", "Fullbright")

    local GrabSection = MainTab:AddSection("Auto Grab", nil)
    uiToggle(GrabSection, "autograb", "Auto Grab keycards / M9")
    uiToggle(GrabSection, "autograbkeycard", "Grab keycards")
    uiToggle(GrabSection, "autograbm9", "Grab M9")
    uiSlider(GrabSection, "autograbdistance", "Pickup distance (max 12 studs)", 0, 12, 0.5)
    uiSlider(GrabSection, "autograbdelay", "Required item delay", 0, 5, 0.1)

    -- Movement controls use the MM2-style ranges, with real baselines captured from this game.
    local MovementSection = MovementTab:AddSection("Movement & Physics", nil)
    uiSlider(MovementSection, "movementwalkspeed", "Speed", 16, 200, 1)
    uiSlider(MovementSection, "movementjumppower", "JumpPower", 50, 300, 1)
    uiSlider(MovementSection, "movementgravity", "Gravity", 0, 300, 1)
    uiSlider(MovementSection, "movementfov", "FOV", 70, 120, 1)
    uiLabel(MovementSection, "Restore behavior", "Returning a slider to its initial value restores the original Humanoid, Gravity, or camera value captured by this script.")

    local UtilitiesSection = MovementTab:AddSection("Utilities", nil)
    uiToggle(UtilitiesSection, "infinityjump", "Inf Jump")
    uiToggle(UtilitiesSection, "noclip", "Noclip")
    uiLabel(UtilitiesSection, "Utilities", "Noclip disables collision on your character parts while enabled and restores each part's original CanCollide value when disabled. Inf Jump supports keyboard and touch jump input.")

    -- Exclusive order: Silent Aim, Auto Shoot, Accuracy & Shot Behavior, Target Filters.
    local AimSection = ExclusiveTab:AddSection("Silent Aim", nil)
    uiToggle(AimSection, "enabled", "Enable Silent Aim")
    uiSlider(AimSection, "fov", "FOV radius", 1, 600, 1)
    uiToggle(AimSection, "showfov", "Show FOV circle")
    uiToggle(AimSection, "staticfov", "Keep FOV centered")
    uiToggle(AimSection, "showtargetline", "Show target line")
    uiToggle(AimSection, "randomparts", "Random body parts")
    uiDropdown(AimSection, "aimpart", "Aim part", {
        "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart"
    }, cfg.aimpart)
    uiPartToggle(AimSection, "Head")
    uiPartToggle(AimSection, "Torso")
    uiPartToggle(AimSection, "Left Arm")
    uiPartToggle(AimSection, "Right Arm")
    uiPartToggle(AimSection, "Left Leg")
    uiPartToggle(AimSection, "Right Leg")
    uiPartToggle(AimSection, "HumanoidRootPart")
    uiSlider(AimSection, "aimmaxdist", "Aim max distance (0 = unlimited)", 0, 1000, 10)
    uiKeybind(AimSection, "togglekey", "Silent Aim hotkey")
    uiToggle(AimSection, "prioritizeclosest", "Prioritize closest to cursor")
    uiToggle(AimSection, "prioritizecriminals", "Prioritize criminals")
    uiToggle(AimSection, "targetstickiness", "Keep target briefly")
    uiToggle(AimSection, "targetstickinessrandom", "Random target-stick duration")
    uiSlider(AimSection, "targetstickinessduration", "Target-stick duration", 0.05, 3, 0.05)
    uiSlider(AimSection, "targetstickinessmin", "Random duration minimum", 0.05, 3, 0.05)
    uiSlider(AimSection, "targetstickinessmax", "Random duration maximum", 0.05, 3, 0.05)

    local AutoShootSection = ExclusiveTab:AddSection("Auto Shoot", nil)
    uiToggle(AutoShootSection, "autoshoot", "Auto Shoot")
    uiDropdown(AutoShootSection, "autoshootweapon", "Weapon filter", {
        "Any", "Taser", "M9", "AK-47", "M4A1", "Remington 870", "Revolver", "Shotgun", "Sniper", "Automatic"
    }, cfg.autoshootweapon)
    uiSlider(AutoShootSection, "autoshootdelay", "Delay between shots", 0.03, 2, 0.01)
    uiSlider(AutoShootSection, "autoshootstartdelay", "Target acquire delay", 0, 2, 0.01)

    local SwitchShootSection = ExclusiveTab:AddSection("Auto Shoot Switch Guns", nil)
    local switchPanelToggleOk, switchPanelToggle = pcall(function()
        return SwitchShootSection:AddToggle({
            Title = "Auto Shoot Switch Guns",
            Default = cfg.autoswitchpanel,
            Callback = function(value)
                autoswitchPanelSetEnabled(value == true)
            end
        })
    end)
    if switchPanelToggleOk and switchPanelToggle then
        UIControls.autoswitchpanel = switchPanelToggle
    else
        uiLabel(SwitchShootSection, "Auto Shoot Switch Guns", "This toggle was not supported by the loaded BOLONG UI build.")
    end
    uiDropdown(SwitchShootSection, "autoswitchteam", "Target team", {"Inmates", "Police", "Criminal"}, cfg.autoswitchteam)
    uiSlider(SwitchShootSection, "autoswitchfirerate", "Fire interval (seconds)", 0.02, 1, 0.01)
    uiSlider(SwitchShootSection, "autoswitchdistance", "Target range (studs)", 25, 1200, 25)
    uiToggle(SwitchShootSection, "autoswitchautoreload", "Auto reload empty guns")
    uiLabel(SwitchShootSection, "Panel", "Enable the toggle to show the 50x50 panel, then tap FIRE to start or stop switching guns and shooting. Only Taser/Tazer is skipped; M9 is allowed.")
    uiToggle(SwitchShootSection, "autoswitchwallcheck", "Wall check (Switch Guns)")

    local AccuracySection = ExclusiveTab:AddSection("Accuracy & Shot Behavior", nil)
    uiSlider(AccuracySection, "hitchance", "Hit chance (%)", 0, 100, 1)
    uiToggle(AccuracySection, "hitchanceAutoOnly", "Apply hit chance to automatic weapons only")
    uiToggle(AccuracySection, "distancebasedhitchance", "Distance-based hit chance")
    uiSlider(AccuracySection, "distancehitchance1dist", "Distance breakpoint 1", 25, 1000, 5)
    uiSlider(AccuracySection, "distancehitchance1value", "Hit chance at breakpoint 1 (%)", 0, 100, 1)
    uiSlider(AccuracySection, "distancehitchance2dist", "Distance breakpoint 2", 25, 1000, 5)
    uiSlider(AccuracySection, "distancehitchance2value", "Hit chance at breakpoint 2 (%)", 0, 100, 1)
    uiSlider(AccuracySection, "distancehitchance3dist", "Distance breakpoint 3", 25, 1000, 5)
    uiSlider(AccuracySection, "distancehitchance3value", "Hit chance at breakpoint 3 (%)", 0, 100, 1)
    uiSlider(AccuracySection, "distancehitchance4dist", "Distance breakpoint 4", 25, 1000, 5)
    uiSlider(AccuracySection, "distancehitchance4value", "Hit chance at breakpoint 4 (%)", 0, 100, 1)
    uiSlider(AccuracySection, "distancehitchance5dist", "Distance breakpoint 5", 25, 1200, 5)
    uiSlider(AccuracySection, "distancehitchance5value", "Hit chance at breakpoint 5 (%)", 0, 100, 1)
    uiSlider(AccuracySection, "missspread", "Miss spread", 0, 25, 0.5)
    uiToggle(AccuracySection, "shotgunnaturalspread", "Natural shotgun spread")
    uiToggle(AccuracySection, "shotgungamehandled", "Let game handle shotgun spread")
    uiToggle(AccuracySection, "taseralwayshit", "Taser always hits")
    uiToggle(AccuracySection, "ifplayerstill", "Always hit stationary targets")
    uiSlider(AccuracySection, "stillthreshold", "Stationary movement threshold", 0, 5, 0.1)
    uiToggle(AccuracySection, "shieldbreaker", "Shield breaker targeting")
    uiSlider(AccuracySection, "shieldfrontangle", "Shield front angle", -1, 1, 0.05)
    uiToggle(AccuracySection, "shieldrandomhead", "Randomly aim at head around shield")
    uiSlider(AccuracySection, "shieldheadchance", "Head chance around shield (%)", 0, 100, 1)

    local FiltersSection = ExclusiveTab:AddSection("Target Filters", nil)
    uiToggle(FiltersSection, "teamcheck", "Skip same team")
    uiToggle(FiltersSection, "wallcheck", "Wall check")
    uiToggle(FiltersSection, "deathcheck", "Skip dead players")
    uiToggle(FiltersSection, "ffcheck", "Skip ForceField players")
    uiToggle(FiltersSection, "hostilecheck", "Hostile check (Guards)")
    uiToggle(FiltersSection, "trespasscheck", "Trespass check (Guards)")
    uiToggle(FiltersSection, "vehiclecheck", "Skip players in vehicles")
    uiToggle(FiltersSection, "criminalsnoinnmates", "Criminals skip Inmates")
    uiToggle(FiltersSection, "inmatesnocriminals", "Inmates skip Criminals")
    uiToggle(FiltersSection, "taserbypasshostile", "Taser bypasses hostile check")
    uiToggle(FiltersSection, "taserbypasstrespass", "Taser bypasses trespass check")

    -- All ESP options stay on Visuals.
    local ESPSection = VisualsTab:AddSection("ESP", nil)
    uiToggle(ESPSection, "esp", "Player ESP")
    uiToggle(ESPSection, "espteamcheck", "Team filter")
    uiToggle(ESPSection, "espshowteam", "Show teammates")
    uiToggle(ESPSection, "espshowdist", "Show player distance")
    uiToggle(ESPSection, "espuseteamcolors", "Use team colors")
    uiToggle(ESPSection, "guards", "Show Guards", cfg.esptargets)
    uiToggle(ESPSection, "inmates", "Show Inmates", cfg.esptargets)
    uiToggle(ESPSection, "criminals", "Show Criminals", cfg.esptargets)
    uiSlider(ESPSection, "espmaxdist", "Player ESP max distance (0 = unlimited)", 0, 2000, 25)
    uiKeybind(ESPSection, "esptoggle", "ESP hotkey")
    uiColor(ESPSection, "espcolor", "Default ESP color")
    uiColor(ESPSection, "espguards", "Guards color")
    uiColor(ESPSection, "espinmates", "Inmates color")
    uiColor(ESPSection, "espcriminals", "Criminals color")
    uiColor(ESPSection, "espteam", "Teammate color")

    local C4Section = VisualsTab:AddSection("C4 ESP", nil)
    uiToggle(C4Section, "c4esp", "C4 ESP")
    uiToggle(C4Section, "c4espshowdist", "Show C4 distance")
    uiSlider(C4Section, "c4espmaxdist", "C4 ESP max distance (0 = unlimited)", 0, 1000, 10)
    uiKeybind(C4Section, "c4esptoggle", "C4 ESP hotkey")
    uiColor(C4Section, "c4espcolor", "C4 ESP color")

    local SpinSection = FunTab:AddSection("Spin", nil)
    uiToggle(SpinSection, "spin", "Spin")
    uiLabel(SpinSection, "Spin", "Rotates the character at a moderate speed while leaving movement controls available.")

    local WallWalkSection = FunTab:AddSection("Walk on Wall", nil)
    uiToggle(WallWalkSection, "walkonwall", "Walk on Wall")
    uiLabel(WallWalkSection, "Walk on Wall", "Move into a wall to attach to it. The camera remains attached to the character. Turn the toggle off to restore normal movement.")

    -- Requested config manager API; keep the rest of the UI alive if a library build lacks AddConfig.
    local ConfigSection
    local configSectionOk = pcall(function()
        ConfigSection = ConfigManagerTab:AddSection("Configuration", true)
        ConfigSection:AddConfig()
    end)
    if not configSectionOk and ConfigSection then
        uiLabel(ConfigSection, "Configuration", "This BOLONG UI build does not expose AddConfig().")
    elseif not configSectionOk then
        pcall(function()
            local fallback = ConfigManagerTab:AddSection("Configuration", true)
            uiLabel(fallback, "Configuration", "This BOLONG UI build does not expose AddConfig().")
        end)
    end
end

BuildUI()


local wallParams = RaycastParams.new()
wallParams.FilterType = Enum.RaycastFilterType.Exclude
wallParams.IgnoreWater = true
wallParams.RespectCanCollide = false
wallParams.CollisionGroup = "ClientBullet"

local projectileParams = RaycastParams.new()
projectileParams.FilterType = Enum.RaycastFilterType.Exclude
projectileParams.IgnoreWater = true
projectileParams.RespectCanCollide = false
projectileParams.CollisionGroup = "ClientBullet"

local currentGun = nil
local rng = Random.new()
local lastShotTime = 0
local lastShotResult = false
local shotCooldown = 1 / 30
local currentTarget = nil
local targetSwitchTime = 0
local currentStickiness = 0
local randomPartCache = {}
local lastTouchAimPos = nil
local storedAimMaxDistanceBeforeDistanceHitchance = tonumber(cfg.aimmaxdist) or 0
local distanceHitchanceForcesAimMaxDistance = false
local activeTouch = nil
local lastAutoShoot = 0
local cachedBulletsLabel = nil
local targetAcquiredTime = 0
local lastAutoTarget = nil
local playerSettings = ReplicatedStorage:FindFirstChild("PlayerSettings")
local mobileCursorOffset = 0
local isInsideDynThumbFrame = nil
local giverPressedRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("GiverPressed")
local trackedGrabbables = {}
local firstSeenGrabbables = {}
local lastAutoGrab = 0

do
    local sharedModules = ReplicatedStorage:FindFirstChild("SharedModules")
    local dynThumbModule = sharedModules and sharedModules:FindFirstChild("isInsideDynThumbFrame")
    if dynThumbModule then
        local ok, result = pcall(require, dynThumbModule)
        if ok and typeof(result) == "function" then
            isInsideDynThumbFrame = result
        end
    end
end

local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(0, 0, 0)
fovCircle.Radius = cfg.fov
fovCircle.Transparency = 0.8
fovCircle.Filled = false
fovCircle.NumSides = 64
fovCircle.Thickness = 1
fovCircle.Visible = cfg.showfov and cfg.enabled

local targetLine = Drawing.new("Line")
targetLine.Color = Color3.fromRGB(0, 255, 0)
targetLine.Thickness = 1
targetLine.Transparency = 0.5
targetLine.Visible = false

local visuals = {container = nil}
local espCache = {}

local function resetAimState()
    lastShotTime = 0
    lastShotResult = false
    currentTarget = nil
    targetSwitchTime = 0
    currentStickiness = 0
    lastAutoShoot = 0
    lastAutoTarget = nil
    targetAcquiredTime = 0
    cachedBulletsLabel = nil
end

local function getHud()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local home = playerGui and playerGui:FindFirstChild("Home")
    return home and home:FindFirstChild("hud") or nil
end

local function getMobileGunFrame()
    local hud = getHud()
    return hud and hud:FindFirstChild("MobileGunFrame") or nil
end

local function getMobileCursor()
    local mobileGunFrame = getMobileGunFrame()
    return mobileGunFrame and mobileGunFrame:FindFirstChild("MobileCursor") or nil
end

local function updateMobileCursorOffset()
    if not playerSettings then
        mobileCursorOffset = 0
        return
    end
    local offset = playerSettings:GetAttribute("MobileCursorOffset")
    if typeof(offset) == "number" then
        mobileCursorOffset = offset * 15
    else
        mobileCursorOffset = 0
    end
end

if playerSettings then
    updateMobileCursorOffset()
    playerSettings:GetAttributeChangedSignal("MobileCursorOffset"):Connect(updateMobileCursorOffset)
end

local function isIgnoredTouchPosition(position)
    if isInsideDynThumbFrame and isInsideDynThumbFrame(position.X, position.Y) then
        return true
    end
    local mobileGunFrame = getMobileGunFrame()
    local ignoreTouchArea = mobileGunFrame and mobileGunFrame:FindFirstChild("IgnoreTouchArea")
    if not ignoreTouchArea then
        return false
    end
    local x = position.X
    local y = position.Y
    local left = ignoreTouchArea.AbsolutePosition.X
    local right = left + ignoreTouchArea.AbsoluteSize.X
    local top = ignoreTouchArea.AbsolutePosition.Y
    local bottom = top + ignoreTouchArea.AbsoluteSize.Y
    return left <= x and x <= right and top <= y and y <= bottom
end

local function getAimScreenPosition(camera)
    camera = camera or workspace.CurrentCamera
    if not camera then
        return UserInputService:GetMouseLocation()
    end
    
    local lastInput = UserInputService:GetLastInputType()
    if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        local viewportSize = camera.ViewportSize
        return Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    end
    
    if lastInput == Enum.UserInputType.Touch then
        local mobileCursor = getMobileCursor()
        if mobileCursor and mobileCursor.Visible then
            local pos = mobileCursor.AbsolutePosition
            local size = mobileCursor.AbsoluteSize
            return Vector2.new(pos.X + size.X / 2, pos.Y + size.Y / 2)
        end

        local viewportSize = camera.ViewportSize
        return Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    end
    
    return UserInputService:GetMouseLocation()
end

local function getScreenCenter(camera)
    camera = camera or workspace.CurrentCamera
    if not camera then
        return Vector2.zero
    end
    local viewportSize = camera.ViewportSize
    return Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
end

local function getFovScreenPosition(camera)
    if cfg.staticfov then
        return getScreenCenter(camera)
    end
    return getAimScreenPosition(camera)
end

local function isSniper(gun)
    return gun and gun:GetAttribute("Behavior") == "Sniper"
end

local function isTaserGun(gun)
    return gun and (gun:GetAttribute("Behavior") == "Taser" or gun:GetAttribute("Projectile") == "Taser")
end

local function isShotgun(gun)
    return gun and (gun:GetAttribute("IsShotgun") or gun:GetAttribute("Behavior") == "Shotgun")
end

local function isAutomaticWeapon(gun)
    return gun and gun:GetAttribute("AutoFire") == true
end

local function normalizeWeaponSelector(value)
    return tostring(value or ""):lower():gsub("%s+", "")
end

local function gunMatchesAutoShootWeapon(gun)
    if not gun then
        return false
    end
    
    local selector = normalizeWeaponSelector(cfg.autoshootweapon)
    if selector == "" or selector == "any" or selector == "all" then
        return true
    end
    
    local gunName = normalizeWeaponSelector(gun.Name)
    local behavior = normalizeWeaponSelector(gun:GetAttribute("Behavior"))
    local projectile = normalizeWeaponSelector(gun:GetAttribute("Projectile"))
    
    if selector == "taser" then
        return isTaserGun(gun) or gunName:find("taser", 1, true) ~= nil
    elseif selector == "shotgun" then
        return isShotgun(gun)
    elseif selector == "sniper" then
        return isSniper(gun)
    elseif selector == "auto" or selector == "automatic" then
        return isAutomaticWeapon(gun)
    end
    
    return selector == gunName or selector == behavior or selector == projectile
end

local function getLocalAimOriginPart()
    local character = LocalPlayer.Character
    if not character then
        return nil
    end
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
end

local function isWithinAimDistance(targetPos)
    local maxDistance = tonumber(cfg.aimmaxdist) or 0
    if maxDistance <= 0 or not targetPos then
        return true
    end
    
    local originPart = getLocalAimOriginPart()
    if not originPart then
        return true
    end
    
    return (targetPos - originPart.Position).Magnitude <= maxDistance
end

local function syncDistanceHitchanceAimMaxDistance()
    local currentAimMaxDistance = tonumber(cfg.aimmaxdist) or 0
    if cfg.distancebasedhitchance then
        if currentAimMaxDistance > 0 then
            storedAimMaxDistanceBeforeDistanceHitchance = currentAimMaxDistance
        elseif storedAimMaxDistanceBeforeDistanceHitchance <= 0 then
            storedAimMaxDistanceBeforeDistanceHitchance = 100
        end
        cfg.aimmaxdist = 0
        distanceHitchanceForcesAimMaxDistance = true
    elseif distanceHitchanceForcesAimMaxDistance then
        cfg.aimmaxdist = tonumber(storedAimMaxDistanceBeforeDistanceHitchance) or 0
        distanceHitchanceForcesAimMaxDistance = false
    else
        storedAimMaxDistanceBeforeDistanceHitchance = currentAimMaxDistance
    end
end

local function shouldBypassHitchance(gun)
    return gun ~= nil and cfg.hitchanceAutoOnly and not isAutomaticWeapon(gun)
end

local function getLocalHumanoid()
    local character = LocalPlayer.Character
    return character and character:FindFirstChildOfClass("Humanoid") or nil
end

local function isSniperStable(gun)
    if not isSniper(gun) then
        return true
    end
    if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
        return false
    end
    local humanoid = getLocalHumanoid()
    return not humanoid or humanoid:GetState() ~= Enum.HumanoidStateType.Freefall
end

local function getFireOriginPosition()
    local myChar = LocalPlayer.Character
    local myHead = myChar and myChar:FindFirstChild("Head")
    if not myHead then return nil end
    
    local muzzle = currentGun and currentGun:FindFirstChild("Muzzle")
    return muzzle and muzzle.Position or myHead.Position
end

local function isInCurrentGunRange(targetPos, originPos)
    if not currentGun or not targetPos then return true end
    
    local range = currentGun:GetAttribute("Range")
    if typeof(range) ~= "number" or range <= 0 then return true end
    
    originPos = originPos or getFireOriginPosition()
    if not originPos then return true end
    
    return (targetPos - originPos).Magnitude <= range + 5
end

local function isSupportedGrabbable(obj)
    if not obj or not obj:IsA("Model") then
        return false
    end
    
    local name = obj.Name:lower()
    return name:find("keycard", 1, true) ~= nil or name == "m9"
end

local function shouldAutoGrabItem(obj)
    if not cfg.autograb or not obj or not obj:IsA("Model") then
        return false
    end
    
    local name = obj.Name:lower()
    if name:find("keycard", 1, true) ~= nil then
        return cfg.autograbkeycard
    end
    if name == "m9" then
        return cfg.autograbm9
    end
    
    return false
end

local function isOwnedGrabbable(obj)
    local ancestor = obj and obj.Parent
    while ancestor and ancestor ~= workspace do
        if ancestor:FindFirstChildOfClass("Humanoid") then
            return true
        end
        if ancestor.Name == "Backpack" then
            return true
        end
        ancestor = ancestor.Parent
    end
    return false
end

local function getGrabbablePart(model)
    if not model then
        return nil
    end
    return model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
end

local function distSq(a, b)
    local delta = a - b
    return delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z
end

local function trackGrabbable(obj)
    if isSupportedGrabbable(obj) then
        trackedGrabbables[obj] = true
    end
end

local function untrackGrabbable(obj)
    trackedGrabbables[obj] = nil
    firstSeenGrabbables[obj] = nil
end

local function updateAutoGrab(now)
    if not cfg.autograb or not giverPressedRemote then
        return
    end
    if now - lastAutoGrab < 0.05 then
        return
    end
    
    local root = getLocalAimOriginPart()
    if not root then
        return
    end
    
    local grabDistance = math.clamp(tonumber(cfg.autograbdistance) or 0, 0, 12)
    if grabDistance <= 0 then
        return
    end
    
    local requiredDelay = math.max(tonumber(cfg.autograbdelay) or 0, 0)
    local grabDistanceSq = grabDistance * grabDistance
    
    for item in pairs(trackedGrabbables) do
        if not item or not item.Parent then
            untrackGrabbable(item)
        elseif not shouldAutoGrabItem(item) then
            firstSeenGrabbables[item] = nil
        elseif isOwnedGrabbable(item) then
            firstSeenGrabbables[item] = nil
        else
            local part = getGrabbablePart(item)
            if part and distSq(root.Position, part.Position) <= grabDistanceSq then
                if not firstSeenGrabbables[item] then
                    firstSeenGrabbables[item] = now
                elseif now - firstSeenGrabbables[item] >= requiredDelay then
                    lastAutoGrab = now
                    firstSeenGrabbables[item] = nil
                    pcall(giverPressedRemote.FireServer, giverPressedRemote, item)
                    return
                end
            else
                firstSeenGrabbables[item] = nil
            end
        end
    end
end

local function shouldUseInstantAcquireDelay(gun)
    if not gun then
        return false
    end
    local lastInput = UserInputService:GetLastInputType()
    return lastInput == Enum.UserInputType.Touch or lastInput == Enum.UserInputType.Gamepad1 or isShotgun(gun)
end

local function simulateProjectileImpact(startPos, aimPos, gun)
    if not gun or not startPos or not aimPos then
        return nil, aimPos
    end
    local behavior = gun:GetAttribute("Behavior")
    local spread = gun:GetAttribute("SpreadRadius") or 0
    local range = gun:GetAttribute("Range") or 1500
    local randomScale = rng:NextNumber()
    if behavior == "Sniper" or behavior == "Shotgun" then
        randomScale = math.sqrt(randomScale)
    end
    local baseCFrame = CFrame.new(startPos, aimPos)
    local rollAngle = math.rad(360 - 720 * rng:NextNumber())
    local direction = (baseCFrame * CFrame.Angles(0, 0, rollAngle) * CFrame.Angles(0, randomScale * spread, 0)).LookVector * range
    projectileParams.FilterDescendantsInstances = {LocalPlayer.Character}
    local result = workspace:Raycast(startPos, direction, projectileParams)
    if result then
        return result.Instance, result.Position
    end
    return nil, startPos + direction
end

local function makeVisuals()
    local container
    local guiParent = (gethui and gethui()) or CoreGui
    local existing = guiParent:FindFirstChild("SilentAimESP") or CoreGui:FindFirstChild("SilentAimESP")
    if existing then
        existing:Destroy()
    end
    if gethui then
        local screen = Instance.new("ScreenGui")
        screen.Name = "SilentAimESP"
        screen.ResetOnSpawn = false
        screen.Parent = gethui()
        container = screen
    elseif syn and syn.protect_gui then
        local screen = Instance.new("ScreenGui")
        screen.Name = "SilentAimESP"
        screen.ResetOnSpawn = false
        syn.protect_gui(screen)
        screen.Parent = CoreGui
        container = screen
    else
        local screen = Instance.new("ScreenGui")
        screen.Name = "SilentAimESP"
        screen.ResetOnSpawn = false
        screen.Parent = CoreGui
        container = screen
    end
    visuals.container = container
end

local function makeEsp(player)
    if espCache[player] then return espCache[player] end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = "ESP_" .. player.Name
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 20, 0, 20)
    esp.StudsOffset = Vector3.new(0, 3, 0)
    esp.LightInfluence = 0
    
    local diamond = Instance.new("Frame")
    diamond.Name = "Diamond"
    diamond.BackgroundColor3 = cfg.espcolor
    diamond.BorderSizePixel = 0
    diamond.Size = UDim2.new(0, 10, 0, 10)
    diamond.Position = UDim2.new(0.5, -5, 0.5, -5)
    diamond.Rotation = 45
    diamond.Parent = esp
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(0, 0, 0)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    stroke.Parent = diamond
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistanceLabel"
    distLabel.BackgroundTransparency = 1
    distLabel.Size = UDim2.new(0, 60, 0, 16)
    distLabel.Position = UDim2.new(0.5, -30, 1, 2)
    distLabel.Font = Enum.Font.GothamBold
    distLabel.TextSize = 11
    distLabel.TextColor3 = Color3.new(1, 1, 1)
    distLabel.TextStrokeTransparency = 0.5
    distLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distLabel.Text = ""
    distLabel.Parent = esp
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(0, 100, 0, 14)
    nameLabel.Position = UDim2.new(0.5, -50, 0, -16)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 10
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Text = player.Name
    nameLabel.Parent = esp
    
    espCache[player] = esp
    return esp
end

local function removeEsp(player)
    local e = espCache[player]
    if e then e:Destroy() espCache[player] = nil end
    if player and player.Character then
        randomPartCache[player.Character] = nil
    end
    if currentTarget == player then
        currentTarget = nil
    end
    if lastAutoTarget == player then
        lastAutoTarget = nil
    end
end

local function shouldShowEsp(player)
    if not player or player == LocalPlayer or not player.Character then return false end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local myChar = LocalPlayer.Character
    if not myChar then return false end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return false end
    
    local distance = (hrp.Position - myHrp.Position).Magnitude
    local espMaxDistance = tonumber(cfg.espmaxdist) or 0
    if espMaxDistance > 0 and distance > espMaxDistance then return false end
    
    local myTeam = LocalPlayer.Team
    local theirTeam = player.Team
    
    if theirTeam == myTeam then
        if not cfg.espshowteam then return false end
        return true
    end
    
    if cfg.espteamcheck then
        local imCrimOrInmate = (myTeam == criminalsTeam or myTeam == inmatesTeam)
        local theyCrimOrInmate = (theirTeam == criminalsTeam or theirTeam == inmatesTeam)
        if imCrimOrInmate and theyCrimOrInmate then return false end
    end
    
    if theirTeam == guardsTeam then return cfg.esptargets.guards
    elseif theirTeam == inmatesTeam then return cfg.esptargets.inmates
    elseif theirTeam == criminalsTeam then return cfg.esptargets.criminals end
    
    return false
end

local function updateEsp()
    if not cfg.esp or not visuals.container then
        for _, e in pairs(espCache) do e.Parent = nil end
        return
    end
    
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    for _, player in ipairs(Players:GetPlayers()) do
        local show = shouldShowEsp(player)
        
        if show then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            
            if hrp and head then
                local esp = makeEsp(player)
                esp.Adornee = head
                esp.Parent = visuals.container
                
                local d = esp:FindFirstChild("Diamond")
                if d and cfg.espuseteamcolors then
                    local t = player.Team
                    if t == LocalPlayer.Team then d.BackgroundColor3 = cfg.espteam
                    elseif t == guardsTeam then d.BackgroundColor3 = cfg.espguards
                    elseif t == inmatesTeam then d.BackgroundColor3 = cfg.espinmates
                    elseif t == criminalsTeam then d.BackgroundColor3 = cfg.espcriminals
                    else d.BackgroundColor3 = cfg.espcolor end
                end
                
                if cfg.espshowdist and myHrp then
                    local label = esp:FindFirstChild("DistanceLabel")
                    if label then
                        label.Text = math.floor((hrp.Position - myHrp.Position).Magnitude) .. "m"
                        label.Visible = true
                    end
                else
                    local label = esp:FindFirstChild("DistanceLabel")
                    if label then
                        label.Visible = false
                    end
                end
            end
        else
            local e = espCache[player]
            if e then e.Parent = nil end
        end
    end
end

local c4espCache = {}

local function makeC4Esp(c4Part)
    if c4espCache[c4Part] then return c4espCache[c4Part] end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = "C4ESP_" .. tostring(c4Part)
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 24, 0, 24)
    esp.StudsOffset = Vector3.new(0, 1, 0)
    esp.LightInfluence = 0
    
    local icon = Instance.new("Frame")
    icon.Name = "Icon"
    icon.BackgroundColor3 = cfg.c4espcolor
    icon.BorderSizePixel = 0
    icon.Size = UDim2.new(0, 14, 0, 14)
    icon.Position = UDim2.new(0.5, -7, 0.5, -7)
    icon.Rotation = 45
    icon.Parent = esp
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(0, 0, 0)
    stroke.Thickness = 2
    stroke.Transparency = 0.2
    stroke.Parent = icon
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 60, 0, 14)
    label.Position = UDim2.new(0.5, -30, 1, 2)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Text = "C4"
    label.Parent = esp
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.BackgroundTransparency = 1
    distLabel.Size = UDim2.new(0, 60, 0, 12)
    distLabel.Position = UDim2.new(0.5, -30, 1, 16)
    distLabel.Font = Enum.Font.GothamBold
    distLabel.TextSize = 10
    distLabel.TextColor3 = cfg.c4espcolor
    distLabel.TextStrokeTransparency = 0.5
    distLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distLabel.Text = ""
    distLabel.Parent = esp
    
    c4espCache[c4Part] = esp
    return esp
end

local trackedC4s = {}

local function isC4Part(part)
    if not part or not part:IsA("BasePart") then return false end
    local name = part.Name:lower()
    local parentName = part.Parent and part.Parent.Name:lower() or ""
    return name == "explosive" or name == "c4" or name == "clientc4" or 
        parentName:find("c4") or name:find("c4")
end

local function onDescendantAdded(desc)
    if isC4Part(desc) then
        trackedC4s[desc] = true
    end
end

local function onDescendantRemoving(desc)
    trackedC4s[desc] = nil
    if c4espCache[desc] then
        c4espCache[desc]:Destroy()
        c4espCache[desc] = nil
    end
end

for _, desc in ipairs(workspace:GetDescendants()) do
    if isC4Part(desc) then trackedC4s[desc] = true end
    trackGrabbable(desc)
end
workspace.DescendantAdded:Connect(onDescendantAdded)
workspace.DescendantRemoving:Connect(onDescendantRemoving)
workspace.DescendantAdded:Connect(trackGrabbable)
workspace.DescendantRemoving:Connect(untrackGrabbable)

local function updateC4Esp()
    if not cfg.c4esp or not visuals.container then
        for _, e in pairs(c4espCache) do e.Parent = nil end
        return
    end
    
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    for part in pairs(trackedC4s) do
        if part and part:IsDescendantOf(workspace) then
            local dist = 0
            if myHrp then
                dist = (part.Position - myHrp.Position).Magnitude
            end
            
            local c4MaxDistance = tonumber(cfg.c4espmaxdist) or 0
            if c4MaxDistance <= 0 or dist <= c4MaxDistance then
                local esp = makeC4Esp(part)
                esp.Adornee = part
                esp.Parent = visuals.container
                
                if cfg.c4espshowdist and myHrp then
                    local distLabel = esp:FindFirstChild("DistLabel")
                    if distLabel then
                        distLabel.Text = math.floor(dist) .. "m"
                    end
                else
                    local distLabel = esp:FindFirstChild("DistLabel")
                    if distLabel then
                        distLabel.Text = ""
                    end
                end
            else
                local e = c4espCache[part]
                if e then e.Parent = nil end
            end
        else
            trackedC4s[part] = nil
            if c4espCache[part] then
                c4espCache[part]:Destroy()
                c4espCache[part] = nil
            end
        end
    end
end

makeVisuals()


local partMap = {
    ["Torso"] = {"Torso"},
    ["LeftArm"] = {"Left Arm"},
    ["RightArm"] = {"Right Arm"},
    ["LeftLeg"] = {"Left Leg"},
    ["RightLeg"] = {"Right Leg"}
}

local function normalizePartName(name)
    return tostring(name or ""):gsub("%s+", "")
end

local function getPart(char, name)
    if not char then return nil end
    local p = char:FindFirstChild(name)
    if p then return p end
    
    local maps = partMap[normalizePartName(name)]
    if maps then
        for _, n in ipairs(maps) do
            local part = char:FindFirstChild(n)
            if part then return part end
        end
    end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
end

local function getTaserTargetPart(char)
    if not char then return nil end
    return char:FindFirstChild("Torso")
        or char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("Head")
end

local function getTargetPart(char)
    if not char then return nil end

    if isTaserGun(currentGun) then
        return getTaserTargetPart(char)
    end

    if cfg.shieldbreaker then
        local shield = char:FindFirstChild("RiotShieldPart")
        if shield and shield:IsA("BasePart") then
            local hp = shield:GetAttribute("Health")
            if hp and hp > 0 then
                local myChar = LocalPlayer.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local theirHrp = char:FindFirstChild("HumanoidRootPart")
                
                if myHrp and theirHrp then
                    local toMe = (myHrp.Position - theirHrp.Position).Unit
                    local theirLook = theirHrp.CFrame.LookVector
                    local dot = toMe:Dot(theirLook)
                    
                    if dot > cfg.shieldfrontangle then
                        if cfg.shieldrandomhead and rng:NextInteger(1, 100) <= cfg.shieldheadchance then
                            return getPart(char, "Head")
                        end
                        return shield
                    end
                end
            end
        end
    end
    
    local partName
    if cfg.randomparts then
        local cached = randomPartCache[char]
        if cached and cached.part and cached.part.Parent == char and cached.expiresAt > os.clock() then
            return cached.part
        end
        
        local list = cfg.partslist
        partName = (list and #list > 0) and list[rng:NextInteger(1, #list)] or "Head"
    else
        partName = cfg.aimpart
    end
    
    local part = getPart(char, partName)
    if cfg.randomparts and part then
        randomPartCache[char] = {
            part = part,
            partName = partName,
            expiresAt = os.clock() + 0.15
        }
    end
    return part
end

local function isDead(player)
    if not player or not player.Character then return true end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    return not humanoid or humanoid.Health <= 0
end

local function isStanding(player)
    if not player or not player.Character then return false end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local vel = hrp.AssemblyLinearVelocity
    return Vector2.new(vel.X, vel.Z).Magnitude <= cfg.stillthreshold
end

local function hasForceField(player)
    if not player or not player.Character then return false end
    return player.Character:FindFirstChildOfClass("ForceField") ~= nil
end

local function isInVehicle(player)
    if not player or not player.Character then return false end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    return humanoid.SeatPart ~= nil
end

local function wallBetween(startPos, endPos, targetChar)
    local myChar = LocalPlayer.Character
    if not myChar then return true end
    
    local filter = {myChar}
    if targetChar then table.insert(filter, targetChar) end
    wallParams.FilterDescendantsInstances = filter
    
    local direction = endPos - startPos
    local distance = direction.Magnitude
    if distance <= 0.001 then return false end
    local unit = direction.Unit
    
    local currentStart = startPos
    local remaining = distance
    
    for _ = 1, 10 do
        local result = workspace:Raycast(currentStart, unit * remaining, wallParams)
        if not result then return false end
        
        local hit = result.Instance
        if hit.Transparency < 0.8 and hit.CanCollide then return true end
        
        local hitDist = (result.Position - currentStart).Magnitude
        remaining = remaining - hitDist - 0.01
        if remaining <= 0 then return false end
        
        currentStart = result.Position + unit * 0.01
    end
    return false
end

-- Forward declaration shared by target selection and validation.
local fullCheck

local function quickCheck(player, ignoreDistanceLimits)
    if not player or player == LocalPlayer or not player.Character then return false end
    local targetPart = getTargetPart(player.Character)
    if not targetPart then return false end
    -- Silent Aim may bypass distance limits, but getClosest still enforces the FOV circle.
    if not ignoreDistanceLimits and not isWithinAimDistance(targetPart.Position) then return false end
    if not ignoreDistanceLimits and not isInCurrentGunRange(targetPart.Position) then return false end
    if cfg.deathcheck and isDead(player) then return false end
    if cfg.ffcheck and hasForceField(player) then return false end
    if cfg.vehiclecheck and isInVehicle(player) then return false end
    if cfg.teamcheck and player.Team == LocalPlayer.Team then return false end
    if cfg.criminalsnoinnmates then
        if LocalPlayer.Team == criminalsTeam and player.Team == inmatesTeam then return false end
    end
    if cfg.inmatesnocriminals then
        if LocalPlayer.Team == inmatesTeam and player.Team == criminalsTeam then return false end
    end
    
    if cfg.hostilecheck or cfg.trespasscheck then
        local isTaser = isTaserGun(currentGun)
        local bypassHostile = cfg.taserbypasshostile and isTaser
        local bypassTrespass = cfg.taserbypasstrespass and isTaser
        local targetChar = player.Character
        
        if LocalPlayer.Team == guardsTeam and player.Team == inmatesTeam then
            local hostile = targetChar:GetAttribute("Hostile")
            local trespass = targetChar:GetAttribute("Trespassing")
            
            if cfg.hostilecheck and cfg.trespasscheck then
                if not bypassHostile and not bypassTrespass then
                    if not hostile and not trespass then return false end
                end
            elseif cfg.hostilecheck and not bypassHostile then
                if not hostile then return false end
            elseif cfg.trespasscheck and not bypassTrespass then
                if not trespass then return false end
            end
        end
    end
    return true
end


-- Full target validation used by Silent Aim and Auto Shoot.
-- The original file called fullCheck() but never defined it, so target selection
-- could error even when an enemy was clearly inside the FOV circle.
fullCheck = function(player, ignoreDistanceLimits)
    if not quickCheck(player, ignoreDistanceLimits) then
        return false
    end

    if not cfg.wallcheck then
        return true
    end

    local character = player and player.Character
    local targetPart = character and getTargetPart(character)
    if not targetPart then
        return false
    end

    local origin = getFireOriginPosition()
    if not origin then
        local originPart = getLocalAimOriginPart()
        origin = originPart and originPart.Position or nil
    end

    if origin and wallBetween(origin, targetPart.Position, character) then
        return false
    end

    return true
end

local function rollHit(chanceOverride)
    lastShotTime = os.clock()
    local chance = math.clamp(tonumber(chanceOverride) or tonumber(cfg.hitchance) or 0, 0, 100)
    if chance >= 100 then
        lastShotResult = true
    elseif chance <= 0 then
        lastShotResult = false
    else
        lastShotResult = rng:NextInteger(1, 100) <= chance
    end
    return lastShotResult
end

local function getDistanceBasedHitChance(targetPart, originPos)
    local baseChance = math.clamp(tonumber(cfg.hitchance) or 0, 0, 100)
    if not cfg.distancebasedhitchance then
        return baseChance
    end
    if not targetPart then
        return baseChance
    end
    local origin = originPos or getFireOriginPosition()
    if not origin then
        local originPart = getLocalAimOriginPart()
        origin = originPart and originPart.Position or nil
    end
    if not origin then
        return baseChance
    end
    local distance = (targetPart.Position - origin).Magnitude
    local selectedChance = baseChance
    local points = {
        {distance = math.max(tonumber(cfg.distancehitchance1dist) or 0, 0), chance = math.clamp(tonumber(cfg.distancehitchance1value) or baseChance, 0, 100)},
        {distance = math.max(tonumber(cfg.distancehitchance2dist) or 0, 0), chance = math.clamp(tonumber(cfg.distancehitchance2value) or baseChance, 0, 100)},
        {distance = math.max(tonumber(cfg.distancehitchance3dist) or 0, 0), chance = math.clamp(tonumber(cfg.distancehitchance3value) or baseChance, 0, 100)},
        {distance = math.max(tonumber(cfg.distancehitchance4dist) or 0, 0), chance = math.clamp(tonumber(cfg.distancehitchance4value) or baseChance, 0, 100)},
        {distance = math.max(tonumber(cfg.distancehitchance5dist) or 0, 0), chance = math.clamp(tonumber(cfg.distancehitchance5value) or baseChance, 0, 100)}
    }
    table.sort(points, function(a, b)
        return a.distance < b.distance
    end)
    for _, point in ipairs(points) do
        if point.distance > 0 and distance >= point.distance then
            selectedChance = point.chance
        end
    end
    return selectedChance
end

local function getMissPos(startPos, targetPartOrPos)
    local targetPart = typeof(targetPartOrPos) == "Instance" and targetPartOrPos:IsA("BasePart") and targetPartOrPos or nil
    local targetPos = targetPart and targetPart.Position or targetPartOrPos
    if not targetPos then return startPos end
    
    local toTarget = targetPos - startPos
    if toTarget.Magnitude <= 0.001 then
        return targetPos + Vector3.new(cfg.missspread + 6, 0, 0)
    end
    
    local direction = toTarget.Unit
    local reference = math.abs(direction.Y) > 0.98 and Vector3.new(1, 0, 0) or Vector3.new(0, 1, 0)
    local right = direction:Cross(reference)
    if right.Magnitude <= 0.001 then
        right = Vector3.new(0, 0, 1)
    else
        right = right.Unit
    end
    
    local up = right:Cross(direction)
    if up.Magnitude <= 0.001 then
        up = Vector3.new(0, 1, 0)
    else
        up = up.Unit
    end
    
    local partRadius = targetPart and math.max(targetPart.Size.X, targetPart.Size.Y, targetPart.Size.Z) * 0.75 or 2
    local missRadius = math.max(cfg.missspread, partRadius + 3)
    local angle = rng:NextNumber(0, math.pi * 2)
    local offset = right * math.cos(angle) * missRadius + up * math.sin(angle) * missRadius
    return targetPos + offset
end

local function getFovTargetPriority(player)
    if not cfg.prioritizecriminals then
        return 0
    end
    if player.Team == criminalsTeam then
        return 0
    end
    if player.Team == inmatesTeam then
        return 1
    end
    return 0
end

local function getClosest(fovRadius, ignoreDistanceLimits)
    fovRadius = fovRadius or cfg.fov
    local camera = workspace.CurrentCamera
    if not camera then return nil, nil end
    
    local aimPos = getFovScreenPosition(camera)
    
    local now = os.clock()
    
    if cfg.targetstickiness and currentTarget and (now - targetSwitchTime) < currentStickiness then
        if fullCheck(currentTarget, ignoreDistanceLimits) then
            local part = getTargetPart(currentTarget.Character)
            if part then
                local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen and screenPos.Z > 0 then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - aimPos).Magnitude
                    if dist < fovRadius then
                        return currentTarget, part.Position
                    end
                end
            end
        end
    end
    
    local candidates = {}
    
    for _, player in ipairs(Players:GetPlayers()) do
        if quickCheck(player, ignoreDistanceLimits) then
            local part = getTargetPart(player.Character)
            if part then
                local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen and screenPos.Z > 0 then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - aimPos).Magnitude
                    if dist < fovRadius then
                        candidates[#candidates + 1] = {
                            player = player,
                            dist = dist,
                            part = part,
                            priority = getFovTargetPriority(player)
                        }
                    end
                end
            end
        end
    end
    
    if cfg.prioritizeclosest then
        table.sort(candidates, function(a, b)
            if a.priority ~= b.priority then
                return a.priority < b.priority
            end
            return a.dist < b.dist
        end)
    else
        local bestPriority = math.huge
        for _, candidate in ipairs(candidates) do
            if candidate.priority < bestPriority then
                bestPriority = candidate.priority
            end
        end
        if bestPriority < math.huge then
            local prioritizedCandidates = {}
            for _, candidate in ipairs(candidates) do
                if candidate.priority == bestPriority then
                    prioritizedCandidates[#prioritizedCandidates + 1] = candidate
                end
            end
            candidates = prioritizedCandidates
        end
        for i = #candidates, 2, -1 do
            local j = rng:NextInteger(1, i)
            candidates[i], candidates[j] = candidates[j], candidates[i]
        end
    end
    
    for _, candidate in ipairs(candidates) do
        if fullCheck(candidate.player, ignoreDistanceLimits) then
            local part = getTargetPart(candidate.player.Character)
            if not part then
                continue
            end
            if candidate.player ~= currentTarget then
                currentTarget = candidate.player
                targetSwitchTime = now
                if cfg.targetstickinessrandom then
                    currentStickiness = rng:NextNumber(cfg.targetstickinessmin, cfg.targetstickinessmax)
                else
                    currentStickiness = cfg.targetstickinessduration
                end
            end
            return candidate.player, part.Position
        end
    end
    
    currentTarget = nil
    return nil, nil
end
local ShootEvent = ReplicatedStorage:WaitForChild("GunRemotes"):WaitForChild("ShootEvent")
local ReloadRemote = ReplicatedStorage:WaitForChild("GunRemotes"):WaitForChild("FuncReload")
local Debris = game:GetService("Debris")
local lastReloadRequest = 0

local function createBulletTrail(startPos, endPos, isTaser)
    local distance = (endPos - startPos).Magnitude
    local trail = Instance.new("Part")
    trail.Name = "BulletTrail"
    trail.Anchored = true
    trail.CanCollide = false
    trail.CanQuery = false
    trail.CanTouch = false
    trail.Material = Enum.Material.Neon
    trail.Size = Vector3.new(0.1, 0.1, distance)
    trail.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -distance / 2)
    trail.Transparency = 0.5
    
    if isTaser then
        trail.BrickColor = BrickColor.new("Cyan")
        trail.Size = Vector3.new(0.2, 0.2, distance)
        local light = Instance.new("SurfaceLight")
        light.Color = Color3.fromRGB(0, 234, 255)
        light.Range = 7
        light.Brightness = 5
        light.Face = Enum.NormalId.Bottom
        light.Parent = trail
    else
        trail.BrickColor = BrickColor.Yellow()
    end
    
    trail.Parent = workspace
    Debris:AddItem(trail, isTaser and 0.8 or 0.1)
end

local function getBulletsLabel()
    if cachedBulletsLabel and cachedBulletsLabel.Parent then
        return cachedBulletsLabel
    end
    
    cachedBulletsLabel = nil
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local home = playerGui and playerGui:FindFirstChild("Home")
    local hud = home and home:FindFirstChild("hud")
    local bottomRight = hud and hud:FindFirstChild("BottomRightFrame")
    local gunFrame = bottomRight and bottomRight:FindFirstChild("GunFrame")
    cachedBulletsLabel = gunFrame and gunFrame:FindFirstChild("BulletsLabel") or nil
    return cachedBulletsLabel
end

local function requestReload(gun)
    local now = os.clock()
    if now - lastReloadRequest < 0.5 then
        return
    end
    if not gun or (tonumber(gun:GetAttribute("Local_ReloadSession")) or 0) ~= 0 then
        return
    end
    local storedAmmo = gun:GetAttribute("StoredAmmo")
    if typeof(storedAmmo) == "number" and storedAmmo <= 0 then
        return
    end
    lastReloadRequest = now
    task.spawn(function()
        pcall(function()
            ReloadRemote:InvokeServer()
        end)
    end)
end

local function autoShoot()
    local gun = currentGun
    if not cfg.autoshoot or not cfg.enabled or not gun then return end
    if gun.Parent ~= LocalPlayer.Character then return end
    if not gunMatchesAutoShootWeapon(gun) then
        lastAutoTarget = nil
        return
    end
    
    local now = os.clock()
    local reloadSession = gun:GetAttribute("Local_ReloadSession") or 0
    if reloadSession ~= 0 or gun:GetAttribute("Local_IsShooting") then return end
    if not isSniperStable(gun) then return end
    
    local fireRate = math.max(gun:GetAttribute("FireRate") or 0, cfg.autoshootdelay)
    if now - lastAutoShoot < fireRate then return end
    
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHead = myChar:FindFirstChild("Head")
    if not myHead then return end
    
    local muzzle = gun:FindFirstChild("Muzzle")
    local startPos = muzzle and muzzle.Position or myHead.Position
    
    local target, targetPos = getClosest(cfg.fov)
    if not target or not fullCheck(target) then 
        lastAutoTarget = nil
        return 
    end
    
    if target ~= lastAutoTarget then
        targetAcquiredTime = now
        lastAutoTarget = target
    end
    
    local acquireDelay = shouldUseInstantAcquireDelay(gun) and 0 or cfg.autoshootstartdelay
    local requiredDelay = math.max(acquireDelay, gun:GetAttribute("ChargeTime") or 0)
    if now - targetAcquiredTime < requiredDelay then return end
    
    local targetPart = getTargetPart(target.Character)
    if not targetPart then return end
    
    local weaponRange = gun:GetAttribute("Range")
    if weaponRange and (targetPart.Position - startPos).Magnitude > weaponRange + 5 then
        return
    end
    
    local ammo = gun:GetAttribute("Local_CurrentAmmo") or gun:GetAttribute("CurrentAmmo") or 0
    if ammo <= 0 then
        requestReload(gun)
        return
    end
    
    lastAutoShoot = now
    
    local isTaser = isTaserGun(gun)
    local sniper = isSniper(gun)
    local shotgun = isShotgun(gun)
    local shouldHit = false
    
    if cfg.taseralwayshit and isTaser then
        shouldHit = true
    elseif cfg.ifplayerstill and isStanding(target) then
        shouldHit = true
    elseif shouldBypassHitchance(gun) then
        shouldHit = true
    else
        shouldHit = rollHit(getDistanceBasedHitChance(targetPart, startPos))
    end
    
    local projectileCount = gun:GetAttribute("ProjectileCount") or 1
    local shots = {}
    
    for i = 1, projectileCount do
        local aimPoint
        if shouldHit then
            aimPoint = targetPart.Position
        else
            if cfg.missspread > 0 then
                aimPoint = getMissPos(startPos, targetPart)
            else
                return
            end
        end
        
                local hitPart = shouldHit and targetPart or nil
        local finalPos = aimPoint

        if shouldHit then
            if isTaser then
                local simulatedHit, simulatedPos = simulateProjectileImpact(startPos, aimPoint, gun)
                finalPos = simulatedPos
                hitPart = simulatedHit or targetPart
            elseif shotgun and cfg.shotgunnaturalspread then
                local simulatedHit, simulatedPos = simulateProjectileImpact(startPos, aimPoint, gun)
                finalPos = simulatedPos
                hitPart = simulatedHit or targetPart
            end
        end

        shots[i] = {myHead.Position, finalPos, hitPart}
        createBulletTrail(startPos, finalPos, isTaser)
    end
    
    ShootEvent:FireServer(shots)
    if gun ~= currentGun or gun.Parent ~= LocalPlayer.Character then return end
    
    local newAmmo = ammo - 1
    gun:SetAttribute("Local_CurrentAmmo", newAmmo)
    
    local bulletsLabel = getBulletsLabel()
    if bulletsLabel then
        if sniper then
            bulletsLabel.Text = newAmmo .. " | " .. (gun:GetAttribute("StoredAmmo") or 0)
        else
            bulletsLabel.Text = newAmmo .. "/" .. (gun:GetAttribute("MaxAmmo") or 30)
        end
    end
    
    local handle = gun:FindFirstChild("Handle")
    if handle then
        local shootSound = handle:FindFirstChild("ShootSound")
        if shootSound then
            local sound = shootSound:Clone()
            sound.Parent = handle
            sound:Play()
            Debris:AddItem(sound, 2)
        end
    end
end

local function getGun()
    local char = LocalPlayer.Character
    if not char then return nil end
    local children = char:GetChildren()
    for index = #children, 1, -1 do
        local tool = children[index]
        if tool:IsA("Tool") and tool:GetAttribute("ToolType") == "Gun" then
            return tool
        end
    end
    return nil
end

local hitboxOriginals = setmetatable({}, {__mode = "k"})

local function restoreHitboxPart(part)
    local original = hitboxOriginals[part]
    if not original then return end
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
    if not cfg.hitboxenabled then
        restoreAllHitboxes()
        return
    end

    local activeParts = {}
    local localTeam = LocalPlayer.Team
    local size = math.clamp(tonumber(cfg.hitboxsize) or 8, 1, 30)
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= LocalPlayer and targetPlayer.Team ~= localTeam then
            local character = targetPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root and root:IsA("BasePart") and humanoid and humanoid.Health > 0 then
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

RunService.Heartbeat:Connect(function()
    pcall(updateHitboxes)
end)

-- Remember the equipped tool so disabling the panel can restore the player's previous weapon.
local autoSwitchOriginalTool = nil
local function getEquippedToolNow()
    local character = LocalPlayer.Character
    if not character then return nil end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then return child end
    end
    return nil
end

autoSwitchCaptureOriginalTool = function()
    autoSwitchOriginalTool = getEquippedToolNow()
end

restoreAutoSwitchTool = function()
    local saved = autoSwitchOriginalTool
    autoSwitchOriginalTool = nil
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not humanoid then return end
    if saved and (saved.Parent == backpack or saved.Parent == character) then
        pcall(function() humanoid:EquipTool(saved) end)
    else
        pcall(function() humanoid:UnequipTools() end)
    end
end

local function isSkippedSwitchGun(tool)
    if not tool then return true end
    local name = string.lower(tool.Name):gsub("%s+", "")
    local behavior = string.lower(tostring(tool:GetAttribute("Behavior") or ""))
    local projectile = string.lower(tostring(tool:GetAttribute("Projectile") or ""))
    if isTaserGun(tool) or name:find("taser", 1, true) or name:find("tazer", 1, true)
        or behavior == "taser" or behavior == "tazer"
        or projectile == "taser" or projectile == "tazer" then
        return true
    end
    return false
end

local function getSwitchGuns()
    local found = {}
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local character = LocalPlayer.Character
    local function addFrom(container)
        if not container then return end
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("ToolType") == "Gun" and not isSkippedSwitchGun(tool) then
                table.insert(found, tool)
            end
        end
    end
    addFrom(backpack)
    addFrom(character)
    table.sort(found, function(a, b) return a.Name < b.Name end)
    return found
end

local function matchesSwitchTargetTeam(player)
    if not player or player == LocalPlayer or not player.Team then return false end
    local teamName = string.lower(player.Team.Name)
    local selected = string.lower(tostring(cfg.autoswitchteam or "Inmates"))
    if selected == "police" then
        return teamName == "police" or teamName == "guards"
    elseif selected == "criminal" or selected == "criminals" then
        return teamName == "criminal" or teamName == "criminals"
    end
    return teamName == "inmate" or teamName == "inmates"
end

local function getNearestSwitchTarget()
    local myCharacter = LocalPlayer.Character
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, nil end
    local nearest, nearestPart, nearestDistance = nil, nil, math.huge
    local maxDistance = math.clamp(tonumber(cfg.autoswitchdistance) or 500, 25, 1200)
    for _, player in ipairs(Players:GetPlayers()) do
        if matchesSwitchTargetTeam(player) then
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local part = character and (character:FindFirstChild("Head") or character:FindFirstChild("Torso") or root)
            if humanoid and humanoid.Health > 0 and root and part and not (cfg.ffcheck and character:FindFirstChildOfClass("ForceField")) then
                local distance = (myRoot.Position - root.Position).Magnitude
                if distance <= maxDistance and distance < nearestDistance then
                    nearest, nearestPart, nearestDistance = player, part, distance
                end
            end
        end
    end
    return nearest, nearestPart
end

local autoSwitchToolIndex = 0
local lastSwitchFire = 0
task.spawn(function()
    while true do
        if not cfg.autoswitchpanel or not cfg.autoswitchactive then
            task.wait(0.05)
            continue
        end

        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local head = character and character:FindFirstChild("Head")
        local guns = getSwitchGuns()
        local target, targetPart = getNearestSwitchTarget()
        if not humanoid or humanoid.Health <= 0 or not head or #guns == 0 or not target or not targetPart then
            task.wait(0.05)
            continue
        end

        autoSwitchToolIndex = (autoSwitchToolIndex % #guns) + 1
        local gun = guns[autoSwitchToolIndex]
        if gun and gun.Parent ~= character then
            pcall(function() humanoid:EquipTool(gun) end)
            task.wait(0.025)
        end

        local currentCharacter = LocalPlayer.Character
        local currentHead = currentCharacter and currentCharacter:FindFirstChild("Head")
        local muzzle = gun and gun:FindFirstChild("Muzzle")
        local startPosition = muzzle and muzzle.Position or (currentHead and currentHead.Position)
        if cfg.autoswitchwallcheck and startPosition and target.Character
            and wallBetween(startPosition, targetPart.Position, target.Character) then
            task.wait(math.clamp(tonumber(cfg.autoswitchfirerate) or 0.05, 0.02, 1))
            continue
        end
        local ammo = gun and (gun:GetAttribute("Local_CurrentAmmo") or gun:GetAttribute("CurrentAmmo"))
        local reloadSession = gun and (tonumber(gun:GetAttribute("Local_ReloadSession")) or 0) or 0
        local fireInterval = math.clamp(tonumber(cfg.autoswitchfirerate) or 0.05, 0.02, 1)

        if gun and gun.Parent == currentCharacter and reloadSession == 0 and (tonumber(ammo) or 0) <= 0 then
            if cfg.autoswitchautoreload then
                requestReload(gun)
            end
            task.wait(0.05)
            continue
        end

        local now = os.clock()
        if gun and gun.Parent == currentCharacter and startPosition and (tonumber(ammo) or 0) > 0
            and reloadSession == 0 and now - lastSwitchFire >= fireInterval then
            lastSwitchFire = now
            local ok = pcall(function()
                ShootEvent:FireServer({{currentHead.Position, targetPart.Position, targetPart}})
            end)
            if ok then
                pcall(function()
                    if gun:GetAttribute("Local_CurrentAmmo") ~= nil then
                        gun:SetAttribute("Local_CurrentAmmo", math.max(0, (tonumber(gun:GetAttribute("Local_CurrentAmmo")) or 1) - 1))
                    end
                end)
                pcall(function() createBulletTrail(startPosition, targetPart.Position, false) end)
            end
        end
        task.wait(fireInterval)
    end
end)

local function notify(title, text, duration)
    UINotify(title, text, duration or 3)
end

local lastGun = nil

syncDistanceHitchanceAimMaxDistance()

RunService.Heartbeat:Connect(function()
    local now = os.clock()
    updateMovementSettings()
    syncDistanceHitchanceAimMaxDistance()
    currentGun = getGun()
    if currentGun ~= lastGun then
        resetAimState()
        lastGun = currentGun
    end
    updateAutoGrab(now)
    autoShoot()
end)

RunService.PreRender:Connect(function()
    local camera = workspace.CurrentCamera
    local fovPos = getFovScreenPosition(camera)
    
    fovCircle.Position = fovPos
    fovCircle.Radius = cfg.fov
    fovCircle.Visible = cfg.showfov and cfg.enabled
    
    if cfg.showtargetline and cfg.enabled then
        local target, targetPos = getClosest()
        if target and targetPos and camera then
            local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
            if onScreen then
                targetLine.From = fovPos
                targetLine.To = Vector2.new(screenPos.X, screenPos.Y)
                targetLine.Visible = true
            else
                targetLine.Visible = false
            end
        else
            targetLine.Visible = false
        end
    else
        targetLine.Visible = false
    end
    
    updateEsp()
    updateC4Esp()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == cfg.togglekey then
        cfg.enabled = not cfg.enabled
        syncUIToggle("enabled", cfg.enabled)
        notify("Silent Aim", "Enabled: " .. tostring(cfg.enabled), 3)
    elseif input.KeyCode == cfg.esptoggle then
        cfg.esp = not cfg.esp
        syncUIToggle("esp", cfg.esp)
        notify("ESP", "Enabled: " .. tostring(cfg.esp), 3)
    elseif input.KeyCode == cfg.c4esptoggle then
        cfg.c4esp = not cfg.c4esp
        syncUIToggle("c4esp", cfg.c4esp)
        notify("C4 ESP", "Enabled: " .. tostring(cfg.c4esp), 3)
    end
end)

Players.PlayerRemoving:Connect(removeEsp)

local function bindPlayer(player)
    player.CharacterRemoving:Connect(function(char)
        randomPartCache[char] = nil
        if currentTarget and currentTarget == player then
            currentTarget = nil
        end
        if lastAutoTarget and lastAutoTarget == player then
            lastAutoTarget = nil
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    bindPlayer(player)
end
Players.PlayerAdded:Connect(bindPlayer)

local function clearEsp()
    for player, e in pairs(espCache) do
        if e then e:Destroy() end
        espCache[player] = nil
    end
    randomPartCache = {}
    currentTarget = nil
end

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    resetAimState()
    clearEsp()
end)

-- Movement/Noclip runtime. Noclip is applied before physics and also to newly-added
-- character parts. Original CanCollide values are restored exactly when it is disabled.
local noclipSaved = setmetatable({}, {__mode = "k"})
local noclipCharacter = nil
local noclipDescAddedConnection = nil

local function disconnectNoclipCharacterConnection()
    if noclipDescAddedConnection then
        pcall(function() noclipDescAddedConnection:Disconnect() end)
        noclipDescAddedConnection = nil
    end
end

local function restoreNoclipParts()
    disconnectNoclipCharacterConnection()
    for part, originalCanCollide in pairs(noclipSaved) do
        pcall(function()
            if part and part.Parent then
                part.CanCollide = originalCanCollide
            end
        end)
    end
    noclipSaved = setmetatable({}, {__mode = "k"})
    noclipCharacter = nil
end

local function forceNoclipPart(instance)
    if not instance or not instance:IsA("BasePart") then return end
    if noclipSaved[instance] == nil then
        noclipSaved[instance] = instance.CanCollide
    end
    pcall(function() instance.CanCollide = false end)
end

local function applyNoclipToCharacter()
    local character = LocalPlayer.Character
    if character ~= noclipCharacter then
        restoreNoclipParts()
        noclipCharacter = character
        if character then
            noclipDescAddedConnection = character.DescendantAdded:Connect(function(instance)
                if cfg.noclip then
                    forceNoclipPart(instance)
                end
            end)
        end
    end
    if not character then return end

    for _, instance in ipairs(character:GetDescendants()) do
        if instance:IsA("BasePart") then
            forceNoclipPart(instance)
        end
    end
end

setNoclip = function(enabled)
    cfg.noclip = enabled == true
    if cfg.noclip then
        applyNoclipToCharacter()
    else
        restoreNoclipParts()
    end
end

updateMovementSettings = function()
    local humanoid = getMovementHumanoid()
    if humanoid then
        captureMovementOriginals(humanoid)
        if movementWalkSpeedEdited then
            local targetSpeed = math.clamp(tonumber(cfg.movementwalkspeed) or movementWalkSpeedResetValue, 16, 200)
            if math.abs(humanoid.WalkSpeed - targetSpeed) > 0.01 then
                pcall(function() humanoid.WalkSpeed = targetSpeed end)
            end
        end
        if movementJumpPowerEdited then
            local targetJumpPower = math.clamp(tonumber(cfg.movementjumppower) or movementJumpPowerResetValue, 50, 300)
            pcall(function()
                humanoid.UseJumpPower = true
                if math.abs(humanoid.JumpPower - targetJumpPower) > 0.01 then
                    humanoid.JumpPower = targetJumpPower
                end
            end)
        end
    end

    if movementGravityEdited then
        local targetGravity = math.clamp(tonumber(cfg.movementgravity) or movementGravityResetValue, 0, 300)
        if math.abs(Workspace.Gravity - targetGravity) > 0.01 then
            pcall(function() Workspace.Gravity = targetGravity end)
        end
    end

    local camera = Workspace.CurrentCamera
    if camera then
        captureMovementCamera(camera)
        if movementFovEdited then
            local targetFov = math.clamp(tonumber(cfg.movementfov) or movementFovResetValue, 70, 120)
            if math.abs(camera.FieldOfView - targetFov) > 0.01 then
                pcall(function() camera.FieldOfView = targetFov end)
            end
        end
    end
end

-- The regular JumpRequest event works with both keyboard and mobile jump controls.
UserInputService.JumpRequest:Connect(function()
    if not cfg.infinityjump then return end
    local humanoid = getMovementHumanoid()
    if humanoid and humanoid.Health > 0 then
        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    task.spawn(function()
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            captureMovementOriginals(humanoid)
            task.wait(0.1)
            updateMovementSettings()
            if cfg.noclip then applyNoclipToCharacter() end
        end
    end)
end)

RunService.Stepped:Connect(function()
    if not cfg.noclip then return end
    local character = LocalPlayer.Character
    if not character then return end
    if character ~= noclipCharacter then
        applyNoclipToCharacter()
        return
    end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            forceNoclipPart(part)
        end
    end
end)

-- Fun features: moderate spin and wall traversal with explicit cleanup.
local spinAttachment = nil
local spinConstraint = nil
local spinRoot = nil
local wallWalkRayParams = RaycastParams.new()
wallWalkRayParams.FilterType = Enum.RaycastFilterType.Exclude
wallWalkRayParams.IgnoreWater = true
wallWalkRayParams.RespectCanCollide = true

local wallWalkState = {
    active = false,
    character = nil,
    humanoid = nil,
    root = nil,
    attachment = nil,
    align = nil,
    velocity = nil,
    normal = nil,
}

local funAutoRotateHumanoid = nil
local funAutoRotateOriginal = nil

local function updateFunAutoRotate()
    local humanoid = getMovementHumanoid()
    if not humanoid then return end
    local forceOff = cfg.spin or wallWalkState.active
    if forceOff then
        if funAutoRotateHumanoid ~= humanoid then
            funAutoRotateHumanoid = humanoid
            funAutoRotateOriginal = humanoid.AutoRotate
        end
        pcall(function() humanoid.AutoRotate = false end)
    elseif funAutoRotateHumanoid == humanoid then
        local original = funAutoRotateOriginal
        pcall(function()
            if original ~= nil then humanoid.AutoRotate = original end
        end)
        funAutoRotateHumanoid = nil
        funAutoRotateOriginal = nil
    end
end

local function destroySpinRuntime()
    if spinConstraint then
        pcall(function() spinConstraint:Destroy() end)
    end
    if spinAttachment then
        pcall(function() spinAttachment:Destroy() end)
    end
    spinConstraint = nil
    spinAttachment = nil
    spinRoot = nil
end

local function ensureSpinRuntime(root)
    if not root or not root.Parent then
        destroySpinRuntime()
        return
    end
    if spinRoot == root and spinConstraint and spinConstraint.Parent then
        return
    end
    destroySpinRuntime()

    local attachment = Instance.new("Attachment")
    attachment.Name = "BOLONG_SpinAttachment"
    attachment.Parent = root

    local angularVelocity = Instance.new("AngularVelocity")
    angularVelocity.Name = "BOLONG_SpinAngularVelocity"
    angularVelocity.Attachment0 = attachment
    angularVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    angularVelocity.AngularVelocity = Vector3.new(0, 3.4, 0)
    pcall(function() angularVelocity.MaxTorque = 4500 end)
    pcall(function() angularVelocity.ReactionTorqueEnabled = false end)
    angularVelocity.Parent = root

    spinAttachment = attachment
    spinConstraint = angularVelocity
    spinRoot = root
end

local function destroyWallWalkConstraints()
    if wallWalkState.velocity then pcall(function() wallWalkState.velocity:Destroy() end) end
    if wallWalkState.align then pcall(function() wallWalkState.align:Destroy() end) end
    if wallWalkState.attachment then pcall(function() wallWalkState.attachment:Destroy() end) end
    wallWalkState.velocity = nil
    wallWalkState.align = nil
    wallWalkState.attachment = nil
end

local function stopWallWalk(restoreUpright)
    if not wallWalkState.active then
        destroyWallWalkConstraints()
        return
    end

    local root = wallWalkState.root
    local humanoid = wallWalkState.humanoid
    local normal = wallWalkState.normal
    destroyWallWalkConstraints()
    wallWalkState.active = false
    wallWalkState.character = nil
    wallWalkState.humanoid = nil
    wallWalkState.root = nil
    wallWalkState.normal = nil

    if restoreUpright and root and root.Parent then
        pcall(function()
            local look = normal and Vector3.new(-normal.X, 0, -normal.Z) or Vector3.zero
            if look.Magnitude < 0.05 then
                local currentLook = root.CFrame.LookVector
                look = Vector3.new(currentLook.X, 0, currentLook.Z)
            end
            if look.Magnitude < 0.05 then look = Vector3.new(0, 0, -1) end
            root.CFrame = CFrame.lookAt(root.Position, root.Position + look.Unit, Vector3.yAxis)
            local velocity = root.AssemblyLinearVelocity
            root.AssemblyLinearVelocity = Vector3.new(velocity.X, 0, velocity.Z)
        end)
    end

    updateFunAutoRotate()
    if humanoid and humanoid.Parent and humanoid.Health > 0 then
        pcall(function()
            if humanoid.FloorMaterial == Enum.Material.Air then
                humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            else
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end
end

local function startWallWalk(character, humanoid, root, hit)
    if wallWalkState.active or not character or not humanoid or not root or not hit then return end

    local attachment = Instance.new("Attachment")
    attachment.Name = "BOLONG_WallWalkAttachment"
    attachment.Parent = root

    local align = Instance.new("AlignOrientation")
    align.Name = "BOLONG_WallWalkAlign"
    align.Mode = Enum.OrientationAlignmentMode.OneAttachment
    align.Attachment0 = attachment
    align.Responsiveness = 25
    align.RigidityEnabled = false
    pcall(function() align.MaxTorque = 80000 end)
    pcall(function() align.MaxAngularVelocity = 30 end)
    align.Parent = root

    local velocity = Instance.new("LinearVelocity")
    velocity.Name = "BOLONG_WallWalkVelocity"
    velocity.Attachment0 = attachment
    velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    velocity.VectorVelocity = Vector3.zero
    pcall(function() velocity.ForceLimitsEnabled = true end)
    pcall(function() velocity.ForceLimitMode = Enum.ForceLimitMode.Magnitude end)
    pcall(function() velocity.MaxForce = math.max(100000, root.AssemblyMass * Workspace.Gravity * 20) end)
    velocity.Parent = root

    wallWalkState.active = true
    wallWalkState.character = character
    wallWalkState.humanoid = humanoid
    wallWalkState.root = root
    wallWalkState.attachment = attachment
    wallWalkState.align = align
    wallWalkState.velocity = velocity
    wallWalkState.normal = hit.Normal
    updateFunAutoRotate()
    pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Freefall) end)
end

setSpin = function(enabled)
    cfg.spin = enabled == true
    if not cfg.spin then
        destroySpinRuntime()
    end
    updateFunAutoRotate()
end

setWalkOnWall = function(enabled)
    cfg.walkonwall = enabled == true
    if not cfg.walkonwall then
        stopWallWalk(true)
    end
end

RunService.Heartbeat:Connect(function()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if cfg.spin and not wallWalkState.active and humanoid and humanoid.Health > 0 and root then
        ensureSpinRuntime(root)
    else
        destroySpinRuntime()
    end

    updateFunAutoRotate()
    if not cfg.walkonwall then
        if wallWalkState.active then stopWallWalk(true) end
        return
    end
    if not character or not humanoid or humanoid.Health <= 0 or not root then
        if wallWalkState.active then stopWallWalk(false) end
        return
    end
    if wallWalkState.active and (wallWalkState.root ~= root or wallWalkState.character ~= character) then
        stopWallWalk(false)
        return
    end

    local moveDirection = humanoid.MoveDirection
    if not wallWalkState.active then
        local flatMove = Vector3.new(moveDirection.X, 0, moveDirection.Z)
        if flatMove.Magnitude < 0.12 then return end
        wallWalkRayParams.FilterDescendantsInstances = {character}
        local hit = Workspace:Raycast(root.Position, flatMove.Unit * 3.5, wallWalkRayParams)
        if hit and math.abs(hit.Normal.Y) < 0.35
            and moveDirection.Unit:Dot(-hit.Normal) > 0.25 then
            startWallWalk(character, humanoid, root, hit)
        end
        return
    end

    local normal = wallWalkState.normal
    if not normal then
        stopWallWalk(true)
        return
    end

    wallWalkRayParams.FilterDescendantsInstances = {character}
    local probeOrigin = root.Position + normal * 1.5
    local wallHit = Workspace:Raycast(probeOrigin, -normal * 4.0, wallWalkRayParams)
    if not wallHit or math.abs(wallHit.Normal.Y) >= 0.4 then
        stopWallWalk(true)
        return
    end
    normal = wallHit.Normal
    wallWalkState.normal = normal

    local awayAmount = moveDirection:Dot(normal)
    if moveDirection.Magnitude > 0.1 and awayAmount > 0.82 then
        stopWallWalk(true)
        return
    end

    local tangent = Vector3.yAxis:Cross(normal)
    if tangent.Magnitude < 0.05 then
        stopWallWalk(true)
        return
    end
    tangent = tangent.Unit

    local verticalInput = math.clamp(moveDirection:Dot(-normal), -1, 1)
    local sideInput = math.clamp(moveDirection:Dot(tangent), -1, 1)
    local speed = math.clamp(tonumber(humanoid.WalkSpeed) or 16, 8, 32)
    local desiredVelocity = Vector3.yAxis * (verticalInput * speed)
        + tangent * (sideInput * speed) - normal * 1.5

    if wallWalkState.velocity and wallWalkState.velocity.Parent then
        wallWalkState.velocity.VectorVelocity = desiredVelocity
    end
    if wallWalkState.align and wallWalkState.align.Parent then
        wallWalkState.align.CFrame = CFrame.lookAt(root.Position, root.Position + Vector3.yAxis, normal)
    end
end)

local function noUpvals(fn)
    return function(...) return fn(...) end
end

local origCastRay
local hooked = false

local function setupHook()
    local castRayFunc = filtergc("function", {Name = "castRay"}, true)
    if not castRayFunc then return false end
    
    origCastRay = hookfunction(castRayFunc, noUpvals(function(startPos, targetPos, ...)
        if not cfg.enabled then return origCastRay(startPos, targetPos, ...) end
        
        -- Ignore world-distance and weapon-range caps for Silent Aim only.
        -- getClosest still requires the target to be inside cfg.fov on screen.
        local closest = getClosest(cfg.fov, true)
        
        if closest and closest.Character then
            local gun = currentGun
            if not gun then
                return origCastRay(startPos, targetPos, ...)
            end
            local isTaser = isTaserGun(gun)
            local shotgun = isShotgun(gun)
            local sniperStable = isSniperStable(gun)
            local shouldHit = false
            local bypassHitchance = shouldBypassHitchance(gun)
            local targetPart = getTargetPart(closest.Character)
            
            if not targetPart then
                return origCastRay(startPos, targetPos, ...)
            end
            
            if cfg.shotgungamehandled and shotgun then
                return origCastRay(startPos, targetPart.Position, ...)
            end
            
            if cfg.taseralwayshit and isTaser then
                shouldHit = true
            elseif cfg.ifplayerstill and isStanding(closest) then
                shouldHit = true
            elseif bypassHitchance then
                shouldHit = true
            else
                shouldHit = rollHit(getDistanceBasedHitChance(targetPart, startPos))
            end
            
            if shouldHit then
                if isSniper(gun) and not sniperStable then
                    return origCastRay(startPos, targetPart.Position, ...)
                end
                if isTaser then
                    return origCastRay(startPos, targetPart.Position, ...)
                end
                if cfg.shotgunnaturalspread and shotgun then
                    return origCastRay(startPos, targetPart.Position, ...)
                end
                return targetPart, targetPart.Position
            else
                if cfg.missspread > 0 then
                    local missPos = getMissPos(startPos, targetPart)
                    return origCastRay(startPos, missPos, ...)
                end
                return origCastRay(startPos, targetPos, ...)
            end
        end
        
        return origCastRay(startPos, targetPos, ...)
    end))
    return true
end

if not setupHook() then
    task.spawn(function()
        while not hooked do
            task.wait(0.5)
            if setupHook() then
                hooked = true
            end
        end
    end)
else
    hooked = true
end

