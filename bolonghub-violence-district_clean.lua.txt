--[[ By LeekG Community - https://discord.gg/ndxRJ3vR68]]

local var30 = (function()
    local _ok, _b = pcall(function()
        return buffer.create(8)
    end)
    if _ok and _b then
        return true
    else
        return false
    end
end)()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local var46 = math.rad(30)
local var47 = math.rad(45)
local var48 = math.rad(42)
local var49 = math.rad(28)
local var50 = math.rad(18)
local var51 = math.rad(72)
local num = -0.95
local num2 = 0.95
local gravity = Workspace.Gravity
local num3 = 2
local num4 = 1.5
local num5 = 0.15
local num6 = 3
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RillBoys/bolong.catui/refs/heads/main/b0lngUi.lua"))()
local str = "v4.4.7.1"
local color3 = Color3.fromRGB(255, 255, 255)
local function fn2(arg2, content, delay)
    library:MakeNotify({
        Title = arg2 or "BOLONG-HUB",
        Description = "Info",
        Content = content or "",
        Color = color3,
        Time = 0.4,
        Delay = delay or 2,
    })
end
local tbl = {
    flag1 = false,
    flag64 = true,
    flag65 = true,
    color31 = Color3.fromRGB(255, 60, 60),
    flag66 = false,
    flag67 = true,
    flag68 = true,
    color37 = Color3.fromRGB(60, 200, 255),
    maxDistance = 500,
    num1 = 500,
    num113 = 500,
    fillTransparency = 0.6,
    flag69 = false,
    flag70 = true,
    num114 = 500,
    color38 = Color3.fromRGB(200, 60, 255),
    flag71 = false,
    cameraZoomValue = 1000,
    flag72 = false,
    num115 = 5,
    flag73 = false,
    num116 = 1.7777777777777777,
    flag74 = false,
    warnDist1 = 60,
    warnDist2 = 40,
    warnDist3 = 20,
    num117 = 70,
    flag75 = false,
    flag76 = true,
    str1 = "Instant",
    flag77 = false,
    flag78 = false,
    flag79 = false,
    str11 = "Zombie",
    num118 = 700,
    num119 = 1,
    str12 = "Always Lock",
    str13 = "Torso",
    flag80 = false,
    flag81 = false,
    color39 = Color3.fromRGB(200, 100, 0),
    flag82 = false,
    color310 = Color3.fromRGB(255, 223, 0),
    flag83 = false,
    color311 = Color3.fromRGB(53, 189, 166),
    flag84 = false,
    color312 = Color3.fromRGB(252, 116, 116),
    flag85 = false,
    color313 = Color3.fromRGB(255, 255, 255),
    flag86 = false,
    flag87 = false,
    cameraVeilMaxDistance = 175,
    cameraVeilSmoothness = 1,
    cameraVeilSpearSpeed = 220,
    cameraVeilGravityMult = 0.5,
    cameraVeilTargetType = "Survivor",
    flag88 = false,
    flag89 = false,
    num120 = 150,
    str14 = "Killer",
    flag90 = true,
    flag91 = true,
    num121 = 150,
    flag92 = true,
    flag93 = true,
    spearPingLead = 1,
    spearSnaplineMaxDistance = 400,
    flag94 = true,
    flag95 = false,
    num122 = 18,
    flag96 = false,
    flag97 = false,
    flag98 = false,
    flag99 = false,
    str15 = "Classic",
    num123 = 0.55,
    num124 = 6,
    flag100 = false,
    flag101 = false,
    flag102 = false,
    num125 = 15,
    flag103 = false,
    flag104 = false,
    flag105 = false,
    flag106 = false,
    flag107 = false,
}
local tbl2 = {
    espObjects = {},
    outlineObjects = {},
    playerRoles = {},
    playerTeamConns = {},
    playerCharConns = {},
    list1 = {Generators = {}, Pallets = {}, Hooks = {}, Gates = {}},
    list2 = {},
    list3 = {},
    list4 = {},
    list5 = {},
    num126 = 1,
    field1 = nil,
    connection1 = nil,
    flag108 = false,
    list6 = {},
    flag109 = false,
    SpeedBoost = false,
    num127 = 0.3,
    flag110 = true,
    flag111 = false,
    safeModeSpeed = true,
    flag112 = true,
    flag113 = false,
    flag114 = false,
    num128 = 1.3,
    flag115 = true,
    str16 = "Both",
    num129 = 0,
    scpEspObjects = {},
    flag116 = false,
    flag117 = false,
    num130 = 10,
    num131 = 0,
    list7 = {},
    num132 = 1.5,
    num133 = 0,
    list8 = {},
    killerCharacters = {},
    num134 = 1,
    flag118 = false,
    flag119 = false,
    list9 = {},
    list10 = {},
    flag120 = false,
    num135 = 50,
    flag121 = false,
    flag122 = false,
    health1 = nil,
    flag123 = false,
    num136 = 0,
    num137 = 0,
    flag124 = false,
    cameraMaxZoomDistance1 = nil,
    fieldOfView1 = nil,
    cursorBackupIcon = nil,
    cursorBackupBehavior = nil,
    connection9 = nil,
    connection10 = nil,
    mouseIconEnabled1 = nil,
    mouseBehavior1 = nil,
    field2 = nil,
    flag125 = false,
    list11 = {},
    pnameNameConns = {},
    pnameSlotConns = {},
    connection11 = nil,
    connection12 = nil,
    field3 = nil,
    field4 = nil,
    field5 = nil,
    flag126 = false,
    avatarUiSlotConns = {},
    connection13 = nil,
    connection14 = nil,
    flag127 = false,
    field6 = nil,
    flag128 = false,
    flag129 = false,
    flag130 = false,
    unit1 = nil,
    field7 = nil,
    field8 = nil,
    field9 = nil,
    field10 = nil,
    field11 = nil,
    num138 = 0,
    num139 = -99,
    flag131 = false,
    num140 = -99,
    field12 = nil,
    num141 = -99,
    field13 = nil,
    field14 = nil,
    field15 = nil,
    field16 = nil,
    list12 = {},
    connection15 = nil,
    connection16 = nil,
    connection17 = nil,
    connection18 = nil,
    list13 = {},
    CV_RenderStepName = "BOLONGHUB_CameraVeil",
    skipEndScreenConns = {},
    flag132 = false,
    flag133 = false,
    flag134 = false,
    field17 = nil,
    vector31 = nil,
    vector358 = Vector3.new(0, 0, 0),
    vector359 = Vector3.new(0, 0, 0),
    list14 = {},
    field18 = nil,
    field19 = nil,
    list15 = nil,
    flag135 = true,
    flag136 = false,
    field20 = nil,
    field21 = nil,
    frame1 = nil,
    flag137 = false,
    flag138 = false,
    field22 = nil,
    vector360 = Vector3.new(0, 0, 0),
    field23 = nil,
    flag139 = false,
    flag140 = false,
    flag141 = false,
    now1 = nil,
    num142 = 142.5,
    num143 = 0.5,
    num144 = 1,
    SPEAR_SNAPLINE = {enabled = false, flag142 = false, field24 = nil, str17 = "", huge1 = math.huge, lockPulse = 0},
    frame17 = nil,
    field25 = nil,
    textLabel1 = nil,
    textLabel10 = nil,
    frame18 = nil,
    frame19 = nil,
    screenGui1 = nil,
    frame20 = nil,
    frame21 = nil,
    textLabel11 = nil,
    flag143 = false,
    autoCrouchActiveSlashers = {},
    autoCrouchAnimConns = {},
    _hookedMobButtons = {},
    _hookedSlasherButtons = {},
    num145 = 0,
    num146 = 0,
    flag144 = false,
    flag145 = false,
    movConns = {antiFall = nil, noSlow = nil},
    field26 = nil,
    connection19 = nil,
    field27 = nil,
    connection20 = nil,
    field28 = nil,
    num147 = 0,
    field29 = nil,
    ghostGateOriginals = {},
    flag146 = false,
    field30 = nil,
    field31 = nil,
    flag147 = false,
    str18 = "Unknown",
    field32 = nil,
    connection21 = nil,
    flag148 = false,
    list16 = nil,
    num148 = 0,
    flag149 = false,
    num149 = 0,
    flag150 = false,
    flag151 = false,
    field33 = nil,
    num150 = 0,
    num151 = 1,
    num152 = 0,
    fastVaultPoints = {},
    fastVaultLastScan = 0,
    num153 = 0,
    num154 = 0,
    flag152 = true,
    list17 = {},
    hookCounterAttrConns = {},
    connection22 = nil,
    connection23 = nil,
    connection24 = nil,
    flag153 = false,
    num155 = 250,
    stunTimerBoards = {},
    stunTimerForced = {},
    stunTimerAnim = {},
    stunTimerConns = {},
    flag154 = false,
    stunTimerLens = {},
    flag155 = false,
    flag156 = false,
    num156 = 0.35,
    flag157 = false,
    list18 = nil,
    flag158 = false,
    connection25 = nil,
    num157 = 0,
    num158 = 0,
    num159 = 0,
    flag159 = false,
    num160 = 1,
    num161 = 0,
    connection26 = nil,
    flag160 = false,
    flag161 = false,
    flag162 = false,
    list19 = {},
    connection27 = nil,
    connection28 = nil,
    list20 = {},
    connection29 = nil,
    flag163 = false,
    flag164 = false,
    field34 = nil,
    specConns = {},
    specDetected = {},
    specStreamTimes = {},
    flag165 = false,
    potatoProcessed = {},
    potatoPallets = {},
    list21 = {},
    field35 = nil,
    num162 = 1,
    list22 = {},
    num163 = 1,
    num164 = 0,
    list23 = {},
    list24 = {},
    list25 = {},
    list26 = {},
    qualityLevel1 = nil,
    globalShadows1 = nil,
    fogEnd1 = nil,
    list27 = {},
    flag166 = false,
}
local tbl3 = {
    ["Adrenaline Shot"] = "rbxassetid://135388781922226",
    Bandage = "rbxassetid://97791520639443",
    Flashlight = "rbxassetid://103299939715311",
    Gate = "rbxassetid://131249244284700",
    ["Holy Water"] = "rbxassetid://86130208614143",
    ["Motion Tracker"] = "rbxassetid://92303584765773",
    ["Parrying Dagger"] = "rbxassetid://76822757630703",
    ["Riot Shield"] = "rbxassetid://95718705901699",
    ["Shadow Clone"] = (function()
        if var30 and buffer then
            local _bf = buffer.create(28)
            local _by = {
                114,
                98,
                120,
                97,
                115,
                115,
                101,
                116,
                105,
                100,
                58,
                47,
                47,
                49,
                51,
                52,
                48,
                56,
                56,
                56,
                52,
                48,
                53,
                49,
                56,
                56,
                56,
                57,
            }
            for _i = 1, #_by do
                buffer.writeu8(_bf, _i - 1, _by[_i])
            end
            local _s = {}
            for _i = 1, #_by do
                _s[_i] = string.char(buffer.readu8(_bf, _i - 1))
            end
            return table.concat(_s)
        else
            local _by = {
                114,
                98,
                120,
                97,
                115,
                115,
                101,
                116,
                105,
                100,
                58,
                47,
                47,
                49,
                51,
                52,
                48,
                56,
                56,
                56,
                52,
                48,
                53,
                49,
                56,
                56,
                56,
                57,
            }
            local _s = {}
            for _i = 1, #_by do
                _s[_i] = string.char(_by[_i])
            end
            return table.concat(_s)
        end
    end)(),
    ["Twist of Fate"] = "rbxassetid://98397448432071",
    ["WaxBound Candle"] = "rbxassetid://110413686590821",
}
local function fn3(arg3)
    if not arg3 or type(arg3) ~= "string" then
        return nil
    end
    arg3 = arg3:match("^%s*(.-)%s*$")
    local var52 = tbl3[arg3]
    if var52 then
        return var52
    end
    for name, id in pairs(tbl3) do
        if name:lower() == arg3:lower() then
            return id
        end
    end
    return nil
end
local num7 = 17
local tbl4 = {"BOLONGHUB"}
local folder = Instance.new("Folder")
folder.Name = "__BolongESP__"
folder.Parent = workspace
local function fn4()
    if folder and folder.Parent then
        return folder
    end
    folder = Instance.new("Folder")
    folder.Name = "__BolongESP__"
    folder.Parent = workspace
    return folder
end
local tbl5 = {}
local function fn5(name, interval, fn)
    tbl5[#tbl5 + 1] = {name = name, interval = interval, timer = 0, fn = fn}
end
local flag = false
local var53
local tbl6 = {
    [25] = true,
    [17] = true,
    [30] = true,
    [67.8] = true,
    [2] = true,
    [4] = true,
    [0.25] = true,
    [70] = true,
    [0.65] = true,
}
local tbl7 = {[1] = true, [10] = true}
local var54, _activeKillerT = nil, 0
local function fn6()
    local now = tick()
    if now - _activeKillerT < 2 and var54 ~= nil then
        return var54
    end
    local var55 = nil
    pcall(function()
        local var56 = localPlayer:GetAttribute("SelectedKiller")
        local name = tostring(var56 or ""):lower()
        if name:find("hidden") then
            var55 = "hidden"
        elseif name:find("mayers") or name:find("stalker") or name:find("michael") then
            var55 = "mayers"
        end
        if not var55 then
            local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
            local var57 = ReplicatedStorage2:FindFirstChild("Remotes") and ReplicatedStorage2.Remotes:FindFirstChild("Killers")
            if var57 then
                if var57:FindFirstChild("Stalker") then
                    var55 = "mayers"
                elseif var57:FindFirstChild("Hidden") then
                    var55 = "hidden"
                end
            end
        end
    end)
    var54, _activeKillerT = var55, now
    return var55
end
local function fn7()
    if var53 then
        return
    end
    if not hookfunction then
        fn2("No Cooldown", "Executor tidak support hookfunction", 2)
        return
    end
    local var59, err = pcall(function()
        local var58 = newcclosure or function(arg4)
            return arg4
        end
        var53 = hookfunction(task.delay, var58(function(delayTime, callback)
            if not var53 then
                return task.delay and task.delay(0, callback) or task.spawn(callback)
            end
            if not flag then
                return var53(delayTime, callback)
            end
            if tbl6[delayTime] then
                return var53(0, callback)
            end
            if tbl7[delayTime] and fn6() == "mayers" then
                return var53(0, callback)
            end
            return var53(delayTime, callback)
        end))
    end)
    if not var59 then
        fn2("No Cooldown", "Gagal hook task.delay: " .. tostring(err), 2)
        var53 = nil
    end
end
local function fn8()
    if var53 then
        if restorefunction then
            pcall(restorefunction, task.delay)
        end
        var53 = nil
    end
end
local function fn9(player)
    return tbl2.playerRoles[player] or "survivor"
end
local function fn10(player)
    local var62, var63 = pcall(function()
        return player.Team and player.Team.Name:lower() or ""
    end)
    tbl2.playerRoles[player] = var62 and var63:find("killer") and "killer" or "survivor"
end
local var64, GetNearestSurvivorForMayers, StartMayersMobileHook, StopMayersMobileHook
do
    function GetNearestSurvivorForMayers(maxDist)
        maxDist = maxDist or 5
        local char = localPlayer.Character
        local var65 = char and char:FindFirstChild("HumanoidRootPart")
        if not var65 then
            return nil, math.huge
        end
        local var66, var67 = nil, maxDist + 0.01
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= localPlayer and v.Character then
                local humanoidRootPart = v.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = v.Character:FindFirstChildOfClass("Humanoid")
                if humanoidRootPart and humanoid and humanoid.Health > 0 then
                    local magnitude = (humanoidRootPart.Position - var65.Position).Magnitude
                    if magnitude < var67 then
                        var66, var67 = v.Character, magnitude
                    end
                end
            end
        end
        return var66, var67
    end
    function var64()
        if not (tbl2.flag160 or flag) then
            return
        end
        if fn6() ~= "mayers" then
            return
        end
        if tbl2.flag162 then
            return
        end
        local char = localPlayer.Character
        if not char then
            return
        end
        local humanoidRootPart2 = char:FindFirstChild("HumanoidRootPart")
        local humanoid2 = char:FindFirstChildOfClass("Humanoid")
        if not (humanoidRootPart2 and humanoid2 and humanoid2.Health > 0) then
            return
        end
        tbl2.flag162 = true
        task.delay(0.35, function()
            tbl2.flag162 = false
        end)
        local var68 = nil
        pcall(function()
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://77477445889320"
            local var69 = humanoid2:FindFirstChildOfClass("Animator") or humanoid2
            var68 = var69:LoadAnimation(animation)
            var68.Priority = Enum.AnimationPriority.Action
            var68:Play()
        end)
        local ReplicatedStorage3 = game:GetService("ReplicatedStorage")
        pcall(function()
            ReplicatedStorage3.Remotes.SoundPlayer:FireServer("132736711620405", humanoidRootPart2, 0.3, 70)
        end)
        pcall(function()
            ReplicatedStorage3.Remotes.Attacks.BasicAttack:FireServer(true)
        end)
        pcall(function()
            local var70 = ReplicatedStorage3:FindFirstChild("Remotes") and ReplicatedStorage3.Remotes:FindFirstChild("Killers") and ReplicatedStorage3.Remotes.Killers:FindFirstChild("Stalker") and ReplicatedStorage3.Remotes.Killers.Stalker:FindFirstChild("ConsumeReady")
            if var70 then
                var70:FireServer()
            end
        end)
        task.spawn(function()
            local now2 = tick()
            local flag2 = false
            while tick() - now2 < 2 and not flag2 do
                RunService.Heartbeat:Wait()
                local target, dist = GetNearestSurvivorForMayers(5)
                if target and dist <= 5 then
                    pcall(function()
                        local grab = ReplicatedStorage3.Remotes.Killers.Stalker:FindFirstChild("grab")
                        if grab then
                            grab:FireServer(target)
                        end
                    end)
                    if var68 then
                        pcall(function()
                            var68:Stop(0.1)
                        end)
                    end
                    flag2 = true
                    break
                end
            end
            if var68 then
                pcall(function()
                    var68:Stop(0.1)
                end)
            end
        end)
    end
    fn5("MayersStalkWhileMoving", 0.2, function()
        if not tbl2.flag161 then
            return
        end
        pcall(function()
            local ReplicatedStorage4 = game:GetService("ReplicatedStorage")
            local var71 = ReplicatedStorage4:FindFirstChild("Remotes") and ReplicatedStorage4.Remotes:FindFirstChild("Killers") and ReplicatedStorage4.Remotes.Killers:FindFirstChild("Stalker")
            local var72 = var71 and var71:FindFirstChild("StartStalking")
            if not var72 then
                return
            end
            for _, v2 in ipairs(Players:GetPlayers()) do
                if v2 ~= localPlayer and v2.Character then
                    local humanoid3 = v2.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid3 and humanoid3.Health > 0 then
                        pcall(function()
                            var72:FireServer(v2)
                        end)
                    end
                end
            end
        end)
    end)
    tbl2.connection29 = UserInputService.InputBegan:Connect(function(input, arg5)
        if arg5 then
            return
        end
        if input.KeyCode ~= Enum.KeyCode.Q then
            return
        end
        if not (tbl2.flag160 or flag) then
            return
        end
        pcall(var64)
    end)
    local function fn11(arg6)
        if not (arg6 and arg6:IsA("GuiButton")) then
            return false
        end
        if arg6.Name ~= "move2" then
            return false
        end
        local parent = arg6.Parent
        if not (parent and parent.Name == "Controls") then
            return false
        end
        local parent2 = parent.Parent
        if not (parent2 and parent2.Name == "Slasher-mob") then
            return false
        end
        return true
    end
    local function fn12(arg7)
        if not tbl2.flag160 then
            return
        end
        if fn6() ~= "mayers" then
            return
        end
        if not fn11(arg7) then
            return
        end
        if tbl2.list20[arg7] then
            return
        end
        tbl2.list20[arg7] = true
        pcall(function()
            arg7.Active = true
        end)
        local function onActivated()
            if not tbl2.flag160 then
                return
            end
            pcall(var64)
        end
        local connection = arg7.Activated:Connect(onActivated)
        table.insert(tbl2.list19, connection)
    end
    local function fn13()
        if not tbl2.flag160 then
            return
        end
        if fn6() ~= "mayers" then
            return
        end
        local var74 = localPlayer:FindFirstChildOfClass("PlayerGui") or playerGui
        if not var74 then
            return
        end
        pcall(function()
            local slasherMob = var74:FindFirstChild("Slasher-mob")
            if slasherMob then
                local controls = slasherMob:FindFirstChild("Controls")
                if controls then
                    local move2 = controls:FindFirstChild("move2")
                    if move2 then
                        fn12(move2)
                    end
                    for _, v3 in ipairs(controls:GetDescendants()) do
                        if v3.Name == "move2" then
                            fn12(v3)
                        end
                    end
                end
            end
        end)
        if tbl2.connection28 then
            pcall(function()
                tbl2.connection28:Disconnect()
            end)
        end
        tbl2.connection28 = var74.ChildAdded:Connect(function(arg8)
            if arg8.Name == "Slasher-mob" then
                task.wait(0.5)
                fn13()
                if tbl2.connection27 then
                    pcall(function()
                        tbl2.connection27:Disconnect()
                    end)
                end
                tbl2.connection27 = arg8.DescendantAdded:Connect(function(arg9)
                    if arg9.Name == "move2" then
                        fn12(arg9)
                    end
                end)
                table.insert(tbl2.list19, tbl2.connection27)
            end
        end)
        table.insert(tbl2.list19, tbl2.connection28)
        pcall(function()
            local slasherMob2 = var74:FindFirstChild("Slasher-mob")
            if slasherMob2 and not tbl2.connection27 then
                tbl2.connection27 = slasherMob2.DescendantAdded:Connect(function(arg10)
                    if arg10.Name == "move2" then
                        fn12(arg10)
                    end
                end)
                table.insert(tbl2.list19, tbl2.connection27)
            end
        end)
    end
    function StartMayersMobileHook()
        fn13()
    end
    function StopMayersMobileHook()
        for _, v4 in ipairs(tbl2.list19) do
            pcall(function()
                v4:Disconnect()
            end)
        end
        tbl2.list19 = {}
        tbl2.list20 = {}
        if tbl2.connection28 then
            pcall(function()
                tbl2.connection28:Disconnect()
            end)
            tbl2.connection28 = nil
        end
        if tbl2.connection27 then
            pcall(function()
                tbl2.connection27:Disconnect()
            end)
            tbl2.connection27 = nil
        end
    end
end
local function fn14()
    if tbl2.connection19 then
        tbl2.connection19:Disconnect()
        tbl2.connection19 = nil
    end
    if tbl2.field26 ~= nil then
        local char = localPlayer.Character
        if char then
            pcall(function()
                char:SetAttribute("lungeboost", tbl2.field26)
            end)
        end
        tbl2.field26 = nil
    end
    if tbl2.field27 then
        for i = 1, #tbl2.field27 do
            local var77 = tbl2.field27[i]
            if var77 then
                pcall(function()
                    var77:Enable()
                end)
            end
        end
        tbl2.field27 = nil
    end
end
local function fn15()
    if fn9(localPlayer) ~= "killer" then
        return
    end
    if tbl2.connection19 then
        return
    end
    local char = localPlayer.Character
    if char then
        pcall(function()
            tbl2.field26 = char:GetAttribute("lungeboost")
            char:SetAttribute("lungeboost", 999999)
        end)
    end
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local var78 = remotes and remotes:FindFirstChild("Attacks")
        local var79 = var78 and var78:FindFirstChild("LungeDetect")
        if var79 and var79:IsA("RemoteEvent") then
            local var80 = getconnections(var79.OnClientEvent)
            local tbl8 = {}
            for i2 = 1, #var80 do
                local var81 = var80[i2]
                pcall(function()
                    var81:Disable()
                    tbl8[#tbl8 + 1] = var81
                end)
            end
            tbl2.field27 = tbl8
        end
    end)
    tbl2.connection19 = localPlayer.CharacterAdded:Connect(function(newChar)
        if not tbl.flag100 then
            return
        end
        pcall(function()
            tbl2.field26 = newChar:GetAttribute("lungeboost")
            newChar:SetAttribute("lungeboost", 999999)
        end)
    end)
end
local var82
do
    local tbl9 = {}
    local function fn16(gui)
        if gui.Name == "Blind" then
            tbl9[gui] = true
            if gui:IsA("ScreenGui") then
                gui.Enabled = false
            elseif gui:IsA("GuiObject") then
                gui.Visible = false
                gui.BackgroundTransparency = 1
            end
        end
    end
    local flag3 = false
    local function fn17()
        if flag3 then
            return
        end
        local var87 = pcall(function()
            assert(typeof(hookmetamethod) == "function", "hookmetamethod missing")
            assert(typeof(getnamecallmethod) == "function", "getnamecallmethod missing")
            assert(typeof(checkcaller) == "function", "checkcaller missing")
            local remotes2 = ReplicatedStorage:FindFirstChild("Remotes")
            local var83 = remotes2 and remotes2:FindFirstChild("Items")
            local var84 = var83 and var83:FindFirstChild("Flashlight")
            local var85 = var84 and var84:FindFirstChild("GotBlinded")
            if not (var85 and var85:IsA("RemoteEvent")) then
                return
            end
            local var86
            var86 = hookmetamethod(game, "__namecall", function(self, ...)
                if not checkcaller() and tbl.flag96 and rawequal(self, var85) and getnamecallmethod() == "FireServer" and fn9(localPlayer) == "killer" then
                    return
                end
                return var86(self, ...)
            end)
            flag3 = true
        end)
        return var87
    end
    getgenv().SetupAntiBlindHook = fn17
    playerGui.DescendantAdded:Connect(function(arg11)
        if tbl.flag96 then
            fn16(arg11)
        end
    end)
    fn5("AntiBlindForce", 1, function()
        if not tbl.flag96 then
            return
        end
        fn17()
        for gui, _ in pairs(tbl9) do
            if not gui.Parent then
                tbl9[gui] = nil
            else
                fn16(gui)
            end
        end
    end)
    local var88
    function var82(arg12)
        if arg12 then
            if not var88 then
                var88 = localPlayer.Idled:Connect(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        else
            if var88 then
                var88:Disconnect()
                var88 = nil
            end
        end
    end
end
local var89, Spear_PingSec
do
    local var90 = nil
    function Spear_PingSec()
        if var90 == nil then
            pcall(function()
                var90 = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            end)
        end
        local num8 = 0
        if var90 ~= nil then
            pcall(function()
                num8 = var90:GetValue()
            end)
        end
        num8 = tonumber(num8) or 0
        return math.clamp(num8 / 1000, 0, 1)
    end
    function var89(arg13, char, posNow)
        local now3 = tick()
        if arg13.char ~= char then
            arg13.char = char
            arg13.hist = {}
            arg13.vector361 = Vector3.new(0, 0, 0)
            arg13.turn = 0
        end
        if arg13.turn == nil then
            arg13.turn = 0
        end
        local hist = arg13.hist
        table.insert(hist, {pos = posNow, t = now3})
        while #hist > 1 and hist[1].t < now3 - 0.4 do
            table.remove(hist, 1)
        end
        if #hist >= 2 then
            local var92 = hist[#hist - 1]
            local var93 = hist[#hist]
            local var94 = var93.t - var92.t
            if var94 > 0.001 then
                local var95 = (var93.pos - var92.pos) / var94
                local vector3 = Vector3.new(var95.X, 0, var95.Z)
                local var96 = char and char:FindFirstChild("HumanoidRootPart")
                if var96 and var96:IsA("BasePart") then
                    local var97, av = pcall(function()
                        return var96.AssemblyLinearVelocity
                    end)
                    if var97 and typeof(av) == "Vector3" then
                        local vector32 = Vector3.new(av.X, 0, av.Z)
                        if vector32.Magnitude > 0.5 and vector32.Magnitude < 100 then
                            vector3 = vector3:Lerp(vector32, 0.5)
                        end
                    end
                end
                if vector3.Magnitude > 24 then
                    vector3 = vector3.Unit * 24
                end
                local num9 = 0
                if arg13.vector361.Magnitude > 2 and vector3.Magnitude > 2 then
                    local var98 = arg13.vector361:Dot(vector3) / (arg13.vector361.Magnitude * vector3.Magnitude)
                    if tbl.flag93 and var98 < 0 then
                        vector3 = vector3 * 0.7
                    end
                    num9 = math.clamp(1 - var98, 0, 1)
                end
                arg13.turn = arg13.turn * 0.7 + num9 * 0.3
                arg13.vector361 = arg13.vector361:Lerp(vector3, 0.45)
            end
        end
        local vector33 = Vector3.new(arg13.vector361.X, 0, arg13.vector361.Z)
        if vector33.Magnitude > 24 then
            vector33 = vector33.Unit * 24
        end
        arg13.vector361 = vector33
        local stab = 1 - math.clamp(arg13.turn, 0, 1)
        return vector33, stab
    end
end
local var99, StopCameraVeil, CV_ScanAttackButtons, CV_ClearLock
do
    local tbl10 = {hist = {}, char = nil, vector361 = Vector3.new(0, 0, 0)}
    local function fn18()
        local var100, var101 = pcall(function()
            if gethui then
                return gethui()
            end
            return game:GetService("CoreGui")
        end)
        return var100 and var101 or playerGui
    end
    local function fn19(char)
        if not char then
            return nil
        end
        local head = char:FindFirstChild("Head")
        if head then
            return head.Position
        end
        local humanoidRootPart3 = char:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart3 then
            return humanoidRootPart3.Position
        end
        local upperTorso = char:FindFirstChild("UpperTorso")
        if upperTorso then
            return upperTorso.Position
        end
        local t = char:FindFirstChild("Torso")
        if t then
            return t.Position
        end
        return char.PrimaryPart and char.PrimaryPart.Position or nil
    end
    local function fn20(rootPart)
        if not rootPart then
            return Vector3.new(0, 0, 0)
        end
        local vel = rootPart.AssemblyLinearVelocity
        local vector34 = Vector3.new(vel.X, 0, vel.Z)
        if vector34.Magnitude > 65 then
            vector34 = vector34.Unit * 65
        end
        return vector34
    end
    local function fn21()
        local char = localPlayer.Character
        local var102 = char and char:FindFirstChild("HumanoidRootPart")
        if not var102 then
            return nil
        end
        local currentCamera = Workspace.CurrentCamera
        local var103 = currentCamera and currentCamera.CFrame.LookVector or var102.CFrame.LookVector
        return var102.Position + var103 * 3 + Vector3.new(0, 1.5, 0)
    end
    local function fn22(arg14)
        local speed = tonumber(tbl2.field10) or tonumber(tbl.cameraVeilSpearSpeed) or 220
        return math.clamp(speed, 35, 800)
    end
    local function fn23(arg15, arg16, speed, arg17)
        local var104 = math.cos(arg16)
        if var104 <= 0.015 then
            return nil, nil
        end
        local travelTime = arg15 / (speed * var104)
        if travelTime ~= travelTime or travelTime <= 0 then
            return nil, nil
        end
        local num10 = 0.016666666666666666
        local var105 = 0.5 * arg17 * num10 * travelTime
        local var106 = speed * math.sin(arg16) * travelTime - 0.5 * arg17 * travelTime * travelTime - var105
        return var106, travelTime
    end
    local function fn24(arg18, arg19, arg20, speed, arg21)
        local var107, travelTime = fn23(arg18, arg20, speed, arg21)
        if not var107 or not travelTime then
            return nil
        end
        if travelTime < 0.025 or travelTime > 4 then
            return nil
        end
        local var108 = math.abs(var107 - arg19)
        local var109 = math.max(arg20 - var48, 0) * 0.35
        local var110 = math.max(travelTime - 1.3, 0) * 0.25
        return var108 + var109 + var110, var108, travelTime
    end
    local function fn25(arg22, arg23, speed, arg24)
        local var111 = arg23 - arg22
        local vector35 = Vector3.new(var111.X, 0, var111.Z)
        local magnitude2 = vector35.Magnitude
        local Y = var111.Y
        if var111.Magnitude <= 0.001 then
            return nil
        end
        if magnitude2 <= 0.35 or arg24 <= 0.001 then
            return var111.Unit, math.clamp(var111.Magnitude / speed, 0.025, 4)
        end
        local unit = vector35.Unit
        local var112 = math.atan2(Y, magnitude2)
        local var113 = math.max(-var49, var112 - var50)
        local var114 = var51
        local var115, bestScore, bestError, bestTime = nil, math.huge, math.huge, nil
        local var116 = magnitude2 > 80
        local var117 = var116 and 40 or 24
        local var118 = var116 and 0.08 or num5
        for i3 = 0, var117 do
            local var119 = var113 + (var114 - var113) * (i3 / var117)
            local var120, var121, travelTime = fn24(magnitude2, Y, var119, speed, arg24)
            if var120 and var120 < bestScore then
                bestScore, bestError, var115, bestTime = var120, var121, var119, travelTime
                if bestError < var118 then
                    break
                end
            end
        end
        if var115 then
            local var122 = (var114 - var113) / var117 * 2.5
            local var123 = bestError < var118 and 1 or (var116 and 5 or 3)
            for _ = 1, var123 do
                local var124, localBestScore, localBestError, localBestTime = var115, bestScore, bestError, bestTime
                for j = -3, 3 do
                    local var125 = math.clamp(var115 + var122 * (j / 3), var113, var114)
                    local var126, var127, travelTime = fn24(magnitude2, Y, var125, speed, arg24)
                    if var126 and var126 < localBestScore then
                        localBestScore, localBestError, var124, localBestTime = var126, var127, var125, travelTime
                    end
                end
                var115, bestScore, bestError, bestTime = var124, localBestScore, localBestError, localBestTime
                if bestError < var118 then
                    break
                end
                var122 = var122 * 0.38
            end
        end
        if not var115 then
            local var128 = math.clamp(magnitude2 / speed, 0.025, 4)
            local var129 = math.min(0.5 * arg24 * var128 * var128, 15)
            local var130 = arg23 + Vector3.new(0, var129, 0)
            local var131 = var130 - arg22
            if var131.Magnitude <= 0.001 then
                return nil
            end
            return var131.Unit, var128
        end
        local var132 = unit * math.cos(var115) + Vector3.new(0, math.sin(var115), 0)
        if var132.Magnitude <= 0.001 then
            return nil
        end
        return var132.Unit, bestTime
    end
    local function fn26(arg25)
        local var133 = fn21()
        if not var133 or not arg25 then
            return nil
        end
        local speed = fn22((arg25 - var133).Magnitude)
        local var134 = math.max(tonumber(tbl2.field11) or tonumber(tbl.cameraVeilGravityMult) or 1, 0)
        local var135 = gravity * var134
        return fn25(var133, arg25, speed, var135)
    end
    local function fn27(arg26, arg27)
        if not arg26 then
            return nil
        end
        local var136 = fn21()
        if var136 then
            local var137 = arg26 - var136
            local magnitude3 = var137.Magnitude
            if magnitude3 < 6 then
                if magnitude3 < 0.001 then
                    return nil
                end
                local var138 = tonumber(tbl2.field10) or tonumber(tbl.cameraVeilSpearSpeed) or 220
                return var137.Unit, arg26, math.clamp(magnitude3 / math.max(var138, 1), 0.01, 1)
            end
        end
        local var139 = tbl2.num138
        local var140 = var139 - tbl2.num141
        local var141 = tbl2.field13 and (arg26 - tbl2.field13).Magnitude < num4
        if var140 < num3 and var141 and tbl2.field14 then
            return tbl2.field14, tbl2.field15, tbl2.field16
        end
        local predictedPos = arg26
        local var142, travelTime = fn26(predictedPos)
        if var142 and travelTime and arg27 and arg27.Magnitude > 1.25 then
            local var143 = 0.68 + 0.32 * math.clamp(travelTime / 0.6, 0, 1)
            local var144 = var136 and arg26 and (arg26 - var136).Magnitude or 0
            local var145 = math.max(var144 * 0.4, 4)
            local var146 = Spear_PingSec() * (tonumber(tbl.spearPingLead) or 1)
            local var147 = math.clamp(travelTime * var143, 0, 1.1)
            local lead = arg27 * ((var147 + var146) * undefinedGlobal1)
            if lead.Magnitude > 32 then
                lead = lead.Unit * 32
            end
            if lead.Magnitude > var145 then
                lead = lead.Unit * var145
            end
            local var148 = arg26 + lead
            local var149, newTime = fn26(var148)
            if var149 and newTime then
                var142, travelTime, predictedPos = var149, newTime, var148
            end
            if var149 and newTime and newTime > 0.35 then
                local var150 = math.clamp(newTime * var143, 0, 1.1)
                local var151 = arg27 * ((var150 + var146) * undefinedGlobal1)
                if var151.Magnitude > 32 then
                    var151 = var151.Unit * 32
                end
                if var151.Magnitude > var145 then
                    var151 = var151.Unit * var145
                end
                local var152 = arg26 + var151
                local var153, newTime2 = fn26(var152)
                if var153 and newTime2 then
                    var142, travelTime, predictedPos = var153, newTime2, var152
                end
            end
        end
        tbl2.num141 = var139
        tbl2.field13 = arg26
        tbl2.field14 = var142
        tbl2.field15 = predictedPos
        tbl2.field16 = travelTime
        return var142, predictedPos, travelTime
    end
    local var154
    local function fn28()
        local currentCamera2 = Workspace.CurrentCamera
        if not currentCamera2 then
            return nil
        end
        local position, camDir = currentCamera2.CFrame.Position, currentCamera2.CFrame.LookVector
        local var155, var156 = nil, var46
        local character2 = localPlayer.Character
        local var157 = character2 and character2:FindFirstChild("HumanoidRootPart")
        if not var157 then
            return nil
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local var158 = fn9(player)
                if var158 == "survivor" then
                    local char = player.Character
                    local var159 = char and char:FindFirstChildOfClass("Humanoid")
                    if char and var159 and var159.Health > 0 then
                        local var160 = fn19(char)
                        if var160 then
                            local dist = (var160 - var157.Position).Magnitude
                            if dist <= tbl.cameraVeilMaxDistance then
                                local var161 = var160 - position
                                if var161.Magnitude > 0.001 then
                                    local var162 = math.acos(math.clamp(camDir:Dot(var161.Unit), -1, 1))
                                    if var162 < var156 then
                                        var156 = var162
                                        var155 = player
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return var155
    end
    local function fn29()
        if tbl2.field7 and tbl2.field7.Parent and tbl2.field8 and tbl2.field8.Parent and tbl2.field9 and tbl2.field9.Parent then
            return
        end
        local gui = Instance.new("ScreenGui")
        gui.Name = "CameraVeil_SnapLine"
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.Parent = fn18()
        local frame = Instance.new("Frame")
        frame.Name = "Line"
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.BorderSizePixel = 0
        frame.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
        frame.BackgroundTransparency = 0.08
        frame.Visible = false
        frame.Parent = gui
        local dot = Instance.new("Frame")
        dot.Name = "Dot"
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.BorderSizePixel = 0
        dot.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
        dot.BackgroundTransparency = 0
        dot.Size = UDim2.fromOffset(7, 7)
        dot.Visible = false
        dot.Parent = gui
        local uICorner = Instance.new("UICorner")
        uICorner.CornerRadius = UDim.new(1, 0)
        uICorner.Parent = dot
        tbl2.field7 = gui
        tbl2.field8 = frame
        tbl2.field9 = dot
    end
    local function fn30(arg28)
        if not tbl.flag87 or not tbl2.flag127 then
            if tbl2.field8 then
                tbl2.field8.Visible = false
            end
            if tbl2.field9 then
                tbl2.field9.Visible = false
            end
            return
        end
        if not var154() then
            if tbl2.field8 then
                tbl2.field8.Visible = false
            end
            if tbl2.field9 then
                tbl2.field9.Visible = false
            end
            return
        end
        local var163 = tbl2.num138
        if arg28 and var163 - tbl2.num139 < 2 then
            return
        end
        tbl2.num139 = var163
        local var172 = pcall(function()
            fn29()
            local var164 = tbl2.field8
            local dot = tbl2.field9
            local currentCamera3 = Workspace.CurrentCamera
            if not var164 or not currentCamera3 then
                if var164 then
                    var164.Visible = false
                end
                if dot then
                    dot.Visible = false
                end
                return
            end
            local var165 = arg28
            local var166 = tbl2.field6 ~= nil and tbl2.flag128
            if not var166 then
                local var167 = fn28()
                if var167 then
                    local char = var167.Character
                    if char then
                        var165 = fn19(char)
                    end
                else
                    var165 = nil
                end
            end
            if not var165 then
                var164.Visible = false
                if dot then
                    dot.Visible = false
                end
                return
            end
            local var168, onScreen = currentCamera3:WorldToViewportPoint(var165)
            if not onScreen or var168.Z <= 0 then
                var164.Visible = false
                if dot then
                    dot.Visible = false
                end
                return
            end
            local viewportSize = currentCamera3.ViewportSize
            local vector2 = Vector2.new(viewportSize.X * 0.5, viewportSize.Y * 0.5)
            local vector22 = Vector2.new(var168.X, var168.Y)
            local var169 = vector22 - vector2
            local length = var169.Magnitude
            if length < 2 then
                var164.Visible = false
                if dot then
                    dot.Visible = false
                end
                return
            end
            local var170 = var166 and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 220, 0)
            local var171 = var166 and 0.08 or 0.35
            var164.BackgroundColor3 = var170
            var164.BackgroundTransparency = var171
            var164.Size = UDim2.fromOffset(length, var166 and 2 or 1)
            var164.Position = UDim2.fromOffset((vector2.X + vector22.X) * 0.5, (vector2.Y + vector22.Y) * 0.5)
            var164.Rotation = math.deg(math.atan2(var169.Y, var169.X))
            var164.Visible = true
            if dot then
                dot.BackgroundColor3 = var170
                dot.Position = UDim2.fromOffset(vector22.X, vector22.Y)
                dot.Visible = true
            end
        end)
        if not var172 then
            if tbl2.field8 then
                tbl2.field8.Visible = false
            end
            if tbl2.field9 then
                tbl2.field9.Visible = false
            end
        end
    end
    function CV_ClearLock()
        tbl2.field6 = nil
        tbl2.flag128 = false
        tbl2.unit1 = nil
        tbl2.field12 = nil
        fn30(nil)
    end
    var154 = function()
        local var173 = tbl2.num138
        if var173 == tbl2.num140 then
            return tbl2.flag131
        end
        tbl2.num140 = var173
        local char = localPlayer.Character
        local flag4 = false
        if char then
            local var174, var175 = pcall(char.GetAttribute, char, "spearmode")
            flag4 = var174 and var175 == true
        end
        tbl2.flag131 = flag4
        return flag4
    end
    local function fn31()
        if not var154() then
            return false
        end
        return tbl2.flag129 or tbl2.flag130
    end
    local function fn32()
        tbl2.num138 = tbl2.num138 + 1
        if not tbl2.flag127 then
            return
        end
        local var176 = fn31()
        if not var176 then
            if tbl2.flag128 then
                CV_ClearLock()
            else
                fn30(nil)
            end
            return
        end
        if not tbl2.flag128 then
            tbl2.unit1 = nil
            tbl2.field6 = fn28()
            tbl2.flag128 = true
            tbl2.field12 = tbl2.num138
        end
        if tbl2.field12 and tbl2.num138 - tbl2.field12 < num6 then
            local var178 = fn28()
            if var178 then
                tbl2.field6 = var178
            end
        end
        local target = tbl2.field6
        if not target then
            tbl2.flag128 = false
            return
        end
        local char = target.Character
        local var179 = char and char:FindFirstChildOfClass("Humanoid")
        local var180 = fn9(target)
        if not char or not var179 or var179.Health <= 0 or var180 ~= "survivor" then
            tbl2.flag128 = false
            tbl2.field6 = nil
            return
        end
        local var181 = fn19(char)
        if not var181 then
            tbl2.flag128 = false
            tbl2.field6 = nil
            return
        end
        local currentCamera4 = Workspace.CurrentCamera
        local character3 = localPlayer.Character
        local var182 = character3 and character3:FindFirstChild("HumanoidRootPart")
        if not currentCamera4 or not var182 then
            return
        end
        if (var181 - var182.Position).Magnitude > tbl.cameraVeilMaxDistance then
            tbl2.flag128 = false
            tbl2.field6 = nil
            return
        end
        local var183, stabNow = nil, 1
        if tbl.flag92 then
            var183, stabNow = var89(tbl10, char, var181)
        else
            tbl10.char, tbl10.hist, tbl10.vector361 = nil, {}, Vector3.new(0, 0, 0)
            tbl10.turn = 0
            var183 = fn20(char:FindFirstChild("HumanoidRootPart"))
        end
        local num11 = 1
        if tbl.flag93 then
            num11 = 0.55 + 0.45 * math.clamp(stabNow or 1, 0, 1)
        end
        local var184 = fn27(var181, var183)
        local var185 = var184 and var184.Magnitude > 0.001 and var184.Y < num2 and var184.Y > num
        if var185 then
            if tbl2.unit1 then
                local var186 = math.acos(math.clamp(tbl2.unit1:Dot(var184.Unit), -1, 1))
                if var186 < var47 then
                    tbl2.unit1 = var184.Unit
                end
            else
                tbl2.unit1 = var184.Unit
            end
            var184 = tbl2.unit1
        elseif tbl2.unit1 then
            var184 = tbl2.unit1
        else
            var184 = currentCamera4.CFrame.LookVector
        end
        local position2 = currentCamera4.CFrame.Position
        local var187 = math.clamp(tbl.cameraVeilSmoothness or 1, 0.05, 1)
        local var188 = currentCamera4.CFrame.LookVector:Lerp(var184, var187)
        if var188.Magnitude > 0.001 then
            currentCamera4.CFrame = CFrame.new(position2, position2 + var188.Unit)
            fn30(var181)
        end
    end
    local function fn33(arg29, name)
        local var189 = arg29 and arg29.Parent
        while var189 do
            if var189.Name == name then
                return true
            end
            var189 = var189.Parent
        end
        return false
    end
    local function fn34(arg30)
        if not (arg30 and arg30:IsA("GuiButton")) then
            return false
        end
        if arg30.Name ~= "attack" then
            return false
        end
        if not fn33(arg30, "Slasher-mob") then
            return false
        end
        if not fn33(arg30, "Control") and not fn33(arg30, "Controls") then
            return false
        end
        return true
    end
    local function onDescendantAdded(arg31)
        if not fn34(arg31) then
            return
        end
        if tbl2.list13[arg31] then
            return
        end
        tbl2.list13[arg31] = true
        local function fn35()
            if not tbl2.flag127 or not var154() then
                return
            end
            tbl2.flag130 = true
        end
        local function fn36()
            tbl2.flag130 = false
        end
        local connection2 = arg31.InputBegan:Connect(function(input)
            local t = input.UserInputType
            if t ~= Enum.UserInputType.Touch and t ~= Enum.UserInputType.MouseButton1 then
                return
            end
            fn35()
            local var190
            var190 = UserInputService.InputEnded:Connect(function(ended)
                if ended == input then
                    fn36()
                    if var190 then
                        var190:Disconnect()
                    end
                end
            end)
        end)
        table.insert(tbl2.list12, connection2)
        local connection3 = arg31.InputEnded:Connect(function(input)
            local t = input.UserInputType
            if t ~= Enum.UserInputType.Touch and t ~= Enum.UserInputType.MouseButton1 then
                return
            end
            fn36()
        end)
        table.insert(tbl2.list12, connection3)
    end
    function CV_ScanAttackButtons()
        local var191 = localPlayer:FindFirstChildOfClass("PlayerGui") or playerGui
        if not var191 then
            return
        end
        pcall(function()
            local slasherMob3 = var191:FindFirstChild("Slasher-mob", true)
            if slasherMob3 then
                local var192 = slasherMob3:FindFirstChild("Control") or slasherMob3:FindFirstChild("Controls")
                if var192 then
                    local function fn37(arg32)
                        for _, v5 in ipairs(arg32:GetChildren()) do
                            onDescendantAdded(v5)
                            fn37(v5)
                        end
                    end
                    fn37(var192)
                end
            end
        end)
        if tbl2.connection17 then
            tbl2.connection17:Disconnect()
        end
        tbl2.connection17 = var191.DescendantAdded:Connect(onDescendantAdded)
        table.insert(tbl2.list12, tbl2.connection17)
    end
    local function fn38()
        if tbl2.connection18 then
            return
        end
        local var193, remote = pcall(function()
            local ReplicatedStorage5 = game:GetService("ReplicatedStorage")
            local remotes3 = ReplicatedStorage5:FindFirstChild("Remotes")
            local mechanics = remotes3 and remotes3:FindFirstChild("Mechanics")
            return mechanics and mechanics:FindFirstChild("visualize")
        end)
        if var193 and remote and remote:IsA("RemoteEvent") then
            tbl2.connection18 = remote.OnClientEvent:Connect(function(ownerChar, spearDir, spearSpeed, gravityMult)
                if ownerChar ~= localPlayer.Character then
                    return
                end
                if type(spearSpeed) == "number" and spearSpeed >= 15 and spearSpeed <= 800 then
                    tbl2.field10 = spearSpeed
                end
                if type(gravityMult) == "number" and gravityMult > 0.2 and gravityMult <= 5 then
                    tbl2.field11 = gravityMult
                end
            end)
            table.insert(tbl2.list12, tbl2.connection18)
        end
    end
    function var99()
        if tbl2.flag127 then
            return
        end
        tbl2.flag127 = true
        tbl2.flag129 = false
        tbl2.flag130 = false
        CV_ClearLock()
        fn38()
        CV_ScanAttackButtons()
        tbl2.connection15 = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 and var154() then
                tbl2.flag129 = true
            end
        end)
        table.insert(tbl2.list12, tbl2.connection15)
        tbl2.connection16 = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                tbl2.flag129 = false
            end
        end)
        table.insert(tbl2.list12, tbl2.connection16)
        pcall(function()
            RunService:UnbindFromRenderStep(tbl2.CV_RenderStepName)
        end)
        pcall(function()
            RunService:BindToRenderStep(tbl2.CV_RenderStepName, Enum.RenderPriority.Camera.Value + 2, fn32)
        end)
    end
    function StopCameraVeil()
        tbl2.field10 = nil
        tbl2.field11 = nil
        tbl2.flag127 = false
        tbl2.flag129 = false
        tbl2.flag130 = false
        CV_ClearLock()
        tbl2.num138 = 0
        tbl2.num139 = -99
        tbl2.num140 = -99
        tbl2.flag131 = false
        tbl2.num141 = -99
        tbl2.field13 = nil
        tbl2.field14 = nil
        tbl2.field15 = nil
        tbl2.field16 = nil
        pcall(function()
            RunService:UnbindFromRenderStep(tbl2.CV_RenderStepName)
        end)
        for _, v6 in ipairs(tbl2.list12) do
            pcall(function()
                v6:Disconnect()
            end)
        end
        tbl2.list12 = {}
        tbl2.list13 = {}
        tbl2.connection15 = nil
        tbl2.connection16 = nil
        tbl2.connection17 = nil
        tbl2.connection18 = nil
    end
end
local var195
local var196
local var197
local var198, ForceRefreshAllESP, GetCamPosition, AttachESPToChar, RemovePlayerESP, AttachOutlineToChar, ValidateAndReattachESP, CreateBillboardTag
do
    function CreateBillboardTag(arg33, color, size, arg34)
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.AlwaysOnTop = true
        billboardGui.Size = size or UDim2.new(0, 40, 0, 40)
        billboardGui.StudsOffset = Vector3.new(0, 3.5, 0)
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "Label"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = arg33
        textLabel.TextColor3 = color
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel.TextSize = arg34 or 22
        textLabel.Font = Enum.Font.GothamBold
        textLabel.RichText = true
        textLabel.Parent = billboardGui
        return billboardGui
    end
    local function fn39(isKiller)
        return isKiller and tbl.num1 or tbl.num113
    end
    function var198()
        for player, v7 in pairs(tbl2.espObjects) do
            if v7 and v7.billboard and v7.billboard.Parent then
                local var199 = fn9(player)
                local isKiller = var199 == "killer"
                v7.nameLabel.Visible = isKiller and tbl.flag1 or not isKiller and tbl.flag66
                v7.nameLabel.Text = tbl2.flag125 and (tbl2.list11[player] or player.Name) or player.Name
                v7.billboard.MaxDistance = fn39(isKiller)
                if v7.itemBillboard then
                    v7.itemBillboard.MaxDistance = fn39(isKiller)
                end
            end
        end
        for player, v8 in pairs(tbl2.outlineObjects) do
            if v8 and v8.Parent then
                local var200 = fn9(player)
                local isKiller = var200 == "killer"
                local color = isKiller and tbl.color31 or tbl.color37
                local var201 = isKiller and tbl.flag64 or not isKiller and tbl.flag67
                local var202 = isKiller and tbl.flag65 or not isKiller and tbl.flag68
                v8.FillColor = color
                v8.OutlineColor = color
                v8.Enabled = var201
                v8.FillTransparency = var202 and 1 or tbl.fillTransparency
            end
        end
        var197()
    end
    local function fn40(player)
        if player == localPlayer or not player or not player.Parent then
            return
        end
        local var203 = tbl2.espObjects[player]
        if var203 then
            if var203.billboard and var203.billboard.Parent then
                var203.billboard:Destroy()
            end
            if var203.itemBillboard and var203.itemBillboard.Parent then
                var203.itemBillboard:Destroy()
            end
        end
        local var204 = tbl2.outlineObjects[player]
        if var204 and var204.Parent then
            var204:Destroy()
        end
        tbl2.espObjects[player] = nil
        tbl2.outlineObjects[player] = nil
        var195(player)
        var196(player)
    end
    function ForceRefreshAllESP()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                fn40(player)
            end
        end
    end
    function GetCamPosition()
        local currentCamera5 = workspace.CurrentCamera
        if currentCamera5 then
            return currentCamera5.CFrame.Position
        end
        return nil
    end
    var197 = function()
        local var205 = GetCamPosition()
        if not var205 then
            return
        end
        for player, v9 in pairs(tbl2.espObjects) do
            if player and player.Parent then
                local char = player.Character
                local var206 = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head"))
                if var206 then
                    local dist = (var206.Position - var205).Magnitude
                    local isKiller = fn9(player) == "killer"
                    local var207 = fn39(isKiller)
                    local var208 = dist <= var207
                    local var209 = tbl2.outlineObjects[player]
                    if var209 then
                        local var210 = isKiller and tbl.flag64 or not isKiller and tbl.flag67
                        local var211 = var210 and var208
                        if var209.Enabled ~= var211 then
                            var209.Enabled = var211
                        end
                    end
                    if v9 then
                        if v9.billboard then
                            local var212 = isKiller and tbl.flag1 or not isKiller and tbl.flag66
                            local var213 = var208 and var212
                            if v9.billboard.Enabled ~= var213 then
                                v9.billboard.Enabled = var213
                            end
                            v9.billboard.MaxDistance = var207
                        end
                        if v9.itemBillboard and tbl.flag97 then
                            if v9.itemBillboard.Enabled ~= var208 then
                                v9.itemBillboard.Enabled = var208
                            end
                        end
                    end
                end
            end
        end
    end
    function AttachESPToChar(player, char)
        local var214 = tbl2.espObjects[player]
        if not var214 then
            return
        end
        if not char or not char.Parent or player.Character ~= char then
            return
        end
        local var215 = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head")
        if not var215 then
            task.spawn(function()
                local var216, waitedRoot = pcall(function()
                    return char:WaitForChild("HumanoidRootPart", 3)
                end)
                if var216 and waitedRoot and waitedRoot.Parent and char.Parent and player.Character == char then
                    if var214.billboard then
                        var214.billboard.Adornee = waitedRoot
                        var214.billboard.Enabled = true
                    end
                    if var214.itemBillboard then
                        var214.itemBillboard.Adornee = waitedRoot
                        var214.itemBillboard.Enabled = true
                    end
                end
            end)
            return
        end
        if var214.billboard then
            var214.billboard.Adornee = var215
            var214.billboard.Enabled = true
        end
        if var214.itemBillboard then
            var214.itemBillboard.Adornee = var215
            var214.itemBillboard.Enabled = true
        end
        local var217 = fn9(player)
        local isKiller = var217 == "killer"
        var214.nameLabel.Visible = isKiller and tbl.flag1 or not isKiller and tbl.flag66
        var214.nameLabel.Text = tbl2.flag125 and (tbl2.list11[player] or player.Name) or player.Name
    end
    function RemovePlayerESP(player)
        if tbl2.espObjects[player] then
            if tbl2.espObjects[player].billboard then
                tbl2.espObjects[player].billboard.Destroy(tbl2.espObjects[player].billboard)
            end
            if tbl2.espObjects[player].itemBillboard then
                tbl2.espObjects[player].itemBillboard.Destroy(tbl2.espObjects[player].itemBillboard)
            end
            tbl2.espObjects[player] = nil
        end
        if tbl2.outlineObjects[player] then
            tbl2.outlineObjects[player].Destroy(tbl2.outlineObjects[player])
            tbl2.outlineObjects[player] = nil
        end
        tbl2.playerRoles[player] = nil
        if tbl2.playerTeamConns[player] then
            tbl2.playerTeamConns[player].Disconnect(tbl2.playerTeamConns[player])
            tbl2.playerTeamConns[player] = nil
        end
    end
    function AttachOutlineToChar(player, char)
        local var219 = tbl2.outlineObjects[player]
        if not var219 then
            return
        end
        if not char or not char.Parent or player.Character ~= char then
            return
        end
        local var220 = fn9(player)
        local isKiller = var220 == "killer"
        local color = isKiller and tbl.color31 or tbl.color37
        local var221 = isKiller and tbl.flag64 or not isKiller and tbl.flag67
        local var222 = isKiller and tbl.flag65 or not isKiller and tbl.flag68
        var219.Adornee = char
        var219.FillColor = color
        var219.OutlineColor = color
        var219.FillTransparency = var222 and 1 or tbl.fillTransparency
        var219.OutlineTransparency = 0
        var219.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        var219.Enabled = var221
    end
    function ValidateAndReattachESP(player)
        if player == localPlayer then
            return
        end
        if not player or not player.Parent then
            return
        end
        local var223 = tbl2.espObjects[player]
        local var224 = tbl2.outlineObjects[player]
        if not var223 and not var224 then
            return
        end
        if var223 and var223.billboard and not var223.billboard.Parent or var224 and not var224.Parent then
            fn40(player)
            return
        end
        local char = player.Character
        if not char or not char.Parent then
            if var223 and var223.billboard then
                var223.billboard.Adornee = nil
            end
            if var223 and var223.itemBillboard then
                var223.itemBillboard.Adornee = nil
            end
            if var224 then
                var224.Adornee = nil
                var224.Enabled = false
            end
            return
        end
        local var225 = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head")
        if not var225 then
            return
        end
        local var226 = GetCamPosition()
        local flag5 = true
        if var226 then
            local dist = (var225.Position - var226).Magnitude
            local var227 = fn9(player) == "killer"
            flag5 = dist <= fn39(var227)
        end
        local var228 = fn9(player) == "killer"
        local var229 = var228 and tbl.flag1 or not var228 and tbl.flag66
        local var230 = var228 and tbl.flag64 or not var228 and tbl.flag67
        if var223 and var223.billboard then
            if var223.billboard.Adornee ~= var225 then
                var223.billboard.Adornee = var225
            end
            local var231 = flag5 and var229
            if var223.billboard.Enabled ~= var231 then
                var223.billboard.Enabled = var231
            end
        end
        if var223 and var223.itemBillboard then
            if var223.itemBillboard.Adornee ~= var225 then
                var223.itemBillboard.Adornee = var225
            end
            if var223.itemBillboard.Enabled ~= flag5 then
                var223.itemBillboard.Enabled = flag5
            end
        end
        if var224 then
            if var224.Adornee ~= char then
                AttachOutlineToChar(player, char)
            else
                local var232 = flag5 and var230
                if var224.Enabled ~= var232 then
                    var224.Enabled = var232
                end
            end
        end
    end
    var195 = function(player)
        if player == localPlayer then
            return
        end
        fn10(player)
        local var233 = fn9(player)
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_BB_" .. player.Name
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 150, 0, 18)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.MaxDistance = fn39(var233 == "killer")
        billboard.Parent = fn4()
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Text = tbl2.flag125 and (tbl2.list11[player] or player.Name) or player.Name
        nameLabel.Visible = var233 == "killer" and tbl.flag1 or var233 ~= "killer" and tbl.flag66
        nameLabel.Parent = billboard
        local itemBillboard = Instance.new("BillboardGui")
        itemBillboard.Name = "ESP_Item_" .. player.Name
        itemBillboard.AlwaysOnTop = true
        itemBillboard.Size = UDim2.new(1.5, 0, 1.5, 0)
        itemBillboard.StudsOffset = Vector3.new(0, -5, 0)
        itemBillboard.MaxDistance = fn39(var233 == "killer")
        itemBillboard.Parent = fn4()
        local itemImage = Instance.new("ImageLabel")
        itemImage.Name = "ItemImage"
        itemImage.Size = UDim2.new(1, 0, 1, 0)
        itemImage.BackgroundTransparency = 1
        itemImage.Visible = false
        itemImage.Parent = itemBillboard
        tbl2.espObjects[player] = {billboard = billboard, nameLabel = nameLabel, itemBillboard = itemBillboard, itemImage = itemImage}
        if player.Character then
            AttachESPToChar(player, player.Character)
        end
        if not tbl2.playerTeamConns[player] then
            tbl2.playerTeamConns[player] = player:GetPropertyChangedSignal("Team"):Connect(function()
                fn10(player)
                var198()
                task.delay(0.5, function()
                    ValidateAndReattachESP(player)
                end)
                task.delay(2, function()
                    ValidateAndReattachESP(player)
                end)
            end)
        end
    end
    var196 = function(player)
        if player == localPlayer then
            return
        end
        local highlight = Instance.new("Highlight")
        highlight.Parent = fn4()
        tbl2.outlineObjects[player] = highlight
        if player.Character then
            AttachOutlineToChar(player, player.Character)
        end
    end
end
local var234, ApplyAntiLoopWindow, DisableAntiLoopWindow, DropAllPallets, ApplyGhostGateToObj
do
    local function fn41(obj, name)
        if typeof(obj) ~= "Instance" then
            return nil
        end
        local var235 = obj:GetAttribute(name)
        if var235 ~= nil then
            return var235
        end
        local var236 = obj:FindFirstChild(name)
        if var236 and var236:IsA("ValueBase") then
            return var236.Value
        end
        return nil
    end
    local function fn42(object, color)
        if not object or not object.Parent then
            return
        end
        local __BolongHL__ = object:FindFirstChild("__BolongHL__")
        if not __BolongHL__ then
            __BolongHL__ = Instance.new("Highlight")
            __BolongHL__.Name = "__BolongHL__"
            __BolongHL__.Adornee = object
            __BolongHL__.FillTransparency = 1
            __BolongHL__.OutlineTransparency = 0
            __BolongHL__.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            __BolongHL__.FillColor = color
            __BolongHL__.OutlineColor = color
            __BolongHL__.Parent = object
            return
        end
        if __BolongHL__.FillColor ~= color then
            __BolongHL__.FillColor = color
            __BolongHL__.OutlineColor = color
        end
        if not __BolongHL__.Enabled then
            __BolongHL__.Enabled = true
        end
    end
    local function fn43(object)
        if not object then
            return
        end
        local __BolongHL__2 = object:FindFirstChild("__BolongHL__")
        if __BolongHL__2 then
            __BolongHL__2:Destroy()
        end
    end
    local function fn44(generator)
        if not generator or not generator.Parent then
            return true
        end
        if tbl2.list4[generator] then
            return true
        end
        local var237 = generator:GetAttribute("RepairProgress") or generator:GetAttribute("Progress") or 0
        local var238 = var237 >= 100 or generator:GetAttribute("Completed") == true or generator:GetAttribute("IsCompleted") == true or generator:GetAttribute("Done") == true
        local billboard = generator:FindFirstChild("__BolongGenProgress__")
        if var238 then
            if billboard then
                billboard:Destroy()
            end
            fn43(generator)
            generator:SetAttribute("__BolongGenLastPct__", nil)
            generator:SetAttribute("__BolongGenLastInfo__", nil)
            tbl2.list4[generator] = true
            tbl2.list5[generator] = nil
            return var238
        end
        if tbl.flag80 then
            fn42(generator, tbl.color39)
        else
            fn43(generator)
        end
        if tbl.flag81 then
            local var239 = generator:GetAttribute("PlayersRepairingCount") or 0
            local var240 = generator:GetAttribute("kickcount") or 0
            local var241 = math.floor(var237 + 0.5)
            local var242 = generator:GetAttribute("__BolongGenLastPct__")
            local var243 = generator:GetAttribute("__BolongGenLastInfo__")
            local var244 = tbl2.list5[generator] or 1
            local var245 = string.format("%d_%d_%d_%s_%d", var241, var239, var240, tostring(tbl.flag78), var244)
            if var242 == var241 and var243 == var245 and billboard then
                return false
            end
            generator:SetAttribute("__BolongGenLastPct__", var241)
            generator:SetAttribute("__BolongGenLastInfo__", var245)
            local var246 = math.clamp(var237, 0, 100)
            local var247 = var246 < 50 and tbl.color39:Lerp(Color3.fromRGB(255, 200, 0), var246 / 50) or Color3.fromRGB(255, 200, 0):Lerp(Color3.fromRGB(100, 255, 80), (var246 - 50) / 50)
            local var248 = var247:ToHex()
            local var249 = string.format("GEN%d", var244)
            local var250 = string.format("%d%%", var241)
            local var251 = generator:FindFirstChild("GeneratorBody", true) or generator:FindFirstChild("defaultMaterial", true) or generator:IsA("Model") and generator.PrimaryPart or generator:FindFirstChildWhichIsA("BasePart", true)
            if not var251 then
                return false
            end
            local str2 = "F4D03F"
            local var252 = string.format("<font size=\"9\" color=\"#%s\">%s</font> <font color=\"#555555\">│</font> <font color=\"#%s\">%s</font>", str2, var249, var248, var250)
            if tbl.flag78 then
                var252 = var252 .. string.format(" <font color=\"#555555\">│</font> <font color=\"#76D7C4\">P:%d</font> <font color=\"#555555\">│</font> <font color=\"#FF6B6B\">K:%d</font>", var239, var240)
            end
            if not billboard then
                billboard = Instance.new("BillboardGui")
                billboard.Name = "__BolongGenProgress__"
                billboard.Adornee = var251
                billboard.AlwaysOnTop = true
                billboard.LightInfluence = 0
                billboard.ResetOnSpawn = false
                billboard.MaxDistance = 260
                billboard.Size = UDim2.new(0, 100, 0, 14)
                local var253 = var251.Size.Y / 2 + 3.5
                billboard.StudsOffset = Vector3.new(0, var253, 0)
                billboard.Parent = generator
                local textLabel2 = Instance.new("TextLabel")
                textLabel2.Name = "Label"
                textLabel2.BackgroundTransparency = 1
                textLabel2.Size = UDim2.new(1, 0, 1, 0)
                textLabel2.Position = UDim2.new(0, 0, 0, 0)
                textLabel2.Font = Enum.Font.GothamBlack
                textLabel2.TextSize = 11
                textLabel2.RichText = true
                textLabel2.Text = var252
                textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel2.TextXAlignment = Enum.TextXAlignment.Center
                textLabel2.Parent = billboard
                local uIStroke = Instance.new("UIStroke")
                uIStroke.Thickness = 0.8
                uIStroke.Transparency = 0.4
                uIStroke.Color = Color3.new(0, 0, 0)
                uIStroke.Parent = textLabel2
            else
                if billboard.Adornee ~= var251 then
                    billboard.Adornee = var251
                end
                local var254 = var251.Size.Y / 2 + 3.5
                billboard.StudsOffset = Vector3.new(0, var254, 0)
                local label2 = billboard:FindFirstChild("Label")
                if label2 then
                    label2.Text = var252
                end
            end
        else
            if billboard then
                billboard:Destroy()
                generator:SetAttribute("__BolongGenLastPct__", nil)
                generator:SetAttribute("__BolongGenLastInfo__", nil)
            end
        end
        return false
    end
    local function fn45(generator)
        local function fn46()
            if not tbl.flag80 and not tbl.flag81 then
                return
            end
            fn44(generator)
        end
        pcall(function()
            generator:GetAttributeChangedSignal("RepairProgress"):Connect(fn46)
            generator:GetAttributeChangedSignal("Progress"):Connect(fn46)
            generator:GetAttributeChangedSignal("Completed"):Connect(fn46)
            generator:GetAttributeChangedSignal("IsCompleted"):Connect(fn46)
            generator:GetAttributeChangedSignal("PlayersRepairingCount"):Connect(fn46)
            generator:GetAttributeChangedSignal("kickcount"):Connect(fn46)
        end)
    end
    local function fn47(pallet, arg35)
        local function onChanged()
            local var255 = fn41(pallet, "Dropped") or fn41(pallet, "IsDropped")
            local var256 = fn41(pallet, "Broken") or fn41(pallet, "IsBroken") or fn41(pallet, "Destroyed")
            if var255 or var256 or arg35.isFake then
                fn43(pallet)
                for i4, v10 in ipairs(tbl2.list1.Pallets) do
                    if v10 == pallet then
                        table.remove(tbl2.list1.Pallets, i4)
                        break
                    end
                end
                tbl2.list2[pallet] = nil
            end
        end
        for _, v11 in ipairs({"Dropped", "IsDropped", "Broken", "IsBroken", "Destroyed"}) do
            pallet:GetAttributeChangedSignal(v11):Connect(onChanged)
        end
        pallet.ChildAdded:Connect(function(arg36)
            if arg36:IsA("ValueBase") and (arg36.Name == "Dropped" or arg36.Name == "IsDropped" or arg36.Name == "Broken" or arg36.Name == "IsBroken" or arg36.Name == "Destroyed") then
                arg36.Changed:Connect(onChanged)
            end
        end)
    end
    function ApplyGhostGateToObj(arg37, enabled)
        if not arg37 or not arg37.Parent then
            return
        end
        local var257 = arg37:IsA("BasePart") and {arg37} or {}
        if not arg37:IsA("BasePart") then
            local function fn48(arg38)
                for _, v12 in ipairs(arg38:GetChildren()) do
                    if v12:IsA("BasePart") then
                        table.insert(var257, v12)
                    end
                    fn48(v12)
                end
            end
            fn48(arg37)
        end
        for _, part in ipairs(var257) do
            if part:IsA("BasePart") then
                if enabled then
                    if not tbl2.ghostGateOriginals[part] then
                        tbl2.ghostGateOriginals[part] = {CanCollide = part.CanCollide, Transparency = part.Transparency}
                    end
                    part.CanCollide = false
                    part.Transparency = 0.6
                else
                    if tbl2.ghostGateOriginals[part] then
                        part.CanCollide = tbl2.ghostGateOriginals[part].CanCollide
                        part.Transparency = tbl2.ghostGateOriginals[part].Transparency
                    end
                end
            end
        end
    end
    local function onDescendantAdded2(arg39)
        local n = arg39.Name
        if n == "Generator" then
            table.insert(tbl2.list1.Generators, arg39)
            if not tbl2.list5[arg39] then
                if next(tbl2.list5) == nil then
                    tbl2.num126 = 1
                end
                tbl2.list5[arg39] = tbl2.num126
                tbl2.num126 = tbl2.num126 + 1
            end
            if tbl.flag80 then
                fn44(arg39)
                fn45(arg39)
            end
        elseif n == "Hook" then
            table.insert(tbl2.list1.Hooks, arg39)
            local tbl11 = {}
            local m = arg39:FindFirstChild("Model")
            if m then
                local function fn49(arg40)
                    for _, v13 in ipairs(arg40:GetChildren()) do
                        if v13:IsA("MeshPart") then
                            table.insert(tbl11, v13)
                        end
                        fn49(v13)
                    end
                end
                fn49(m)
            end
            tbl2.list3[arg39] = tbl11
            if tbl.flag84 then
                if #tbl11 > 0 then
                    for _, v14 in ipairs(tbl11) do
                        fn42(v14, tbl.color312)
                    end
                else
                    fn42(arg39, tbl.color312)
                end
            end
        elseif n == "Gate" then
            table.insert(tbl2.list1.Gates, arg39)
            if tbl.flag85 then
                fn42(arg39, tbl.color313)
            end
            if tbl2.flag145 then
                ApplyGhostGateToObj(arg39, true)
            end
        elseif n == "Pallet" or n == "Palletwrong" then
            table.insert(tbl2.list1.Pallets, arg39)
            local var258 = n:lower()
            local part = arg39:IsA("Model") and arg39.PrimaryPart or arg39:FindFirstChildWhichIsA("BasePart", true) or arg39:IsA("BasePart") and arg39
            local fake = var258:find("fake") or var258:find("broken") or var258:find("destroyed")
            local tbl12 = {part = part, isFake = fake and true or false}
            tbl2.list2[arg39] = tbl12
            if tbl.flag83 and not tbl12.isFake then
                fn42(arg39, tbl.color311)
            end
            fn47(arg39, tbl12)
        end
    end
    local function onDescendantRemoving(arg41)
        local n = arg41.Name
        if n == "Generator" then
            for i5, v15 in ipairs(tbl2.list1.Generators) do
                if v15 == arg41 then
                    table.remove(tbl2.list1.Generators, i5)
                    break
                end
            end
            tbl2.list5[arg41] = nil
            tbl2.list4[arg41] = nil
            fn43(arg41)
            local __BolongGenProgress__ = arg41:FindFirstChild("__BolongGenProgress__")
            if __BolongGenProgress__ then
                __BolongGenProgress__:Destroy()
            end
            if next(tbl2.list5) == nil then
                tbl2.num126 = 1
            end
        elseif n == "Hook" then
            for i6, v16 in ipairs(tbl2.list1.Hooks) do
                if v16 == arg41 then
                    table.remove(tbl2.list1.Hooks, i6)
                    break
                end
            end
            local var259 = tbl2.list3[arg41]
            if var259 then
                for _, v17 in ipairs(var259) do
                    fn43(v17)
                end
            else
                fn43(arg41)
            end
            tbl2.list3[arg41] = nil
        elseif n == "Gate" then
            for i7, v18 in ipairs(tbl2.list1.Gates) do
                if v18 == arg41 then
                    table.remove(tbl2.list1.Gates, i7)
                    break
                end
            end
            fn43(arg41)
        elseif n == "Pallet" or n == "Palletwrong" then
            for i8, v19 in ipairs(tbl2.list1.Pallets) do
                if v19 == arg41 then
                    table.remove(tbl2.list1.Pallets, i8)
                    break
                end
            end
            fn43(arg41)
            tbl2.list2[arg41] = nil
        end
    end
    local function fn50(arg42)
        if not arg42 then
            return
        end
        tbl2.list1 = {Generators = {}, Pallets = {}, Hooks = {}, Gates = {}}
        tbl2.list2 = {}
        tbl2.list3 = {}
        tbl2.list4 = {}
        tbl2.list5 = {}
        tbl2.num126 = 1
        for _, obj in ipairs(arg42:GetDescendants()) do
            onDescendantAdded2(obj)
        end
    end
    local function fn51(arg43)
        if not arg43 then
            return
        end
        fn50(arg43)
        arg43.DescendantAdded:Connect(onDescendantAdded2)
        arg43.DescendantRemoving:Connect(onDescendantRemoving)
        tbl2.flag108 = true
    end
    tbl2.list6 = {}
    tbl2._windowParts = {}
    tbl2._windowPartMap = {}
    local function fn52(part)
        if not part or not part.Parent or tbl2.list6[part] then
            return
        end
        local color = tbl.color310
        local boxHandleAdornment = Instance.new("BoxHandleAdornment")
        boxHandleAdornment.Name = "WindowESP_Box"
        boxHandleAdornment.Adornee = part
        boxHandleAdornment.Color3 = color
        boxHandleAdornment.Transparency = 0.3
        boxHandleAdornment.Size = part.Size
        boxHandleAdornment.AlwaysOnTop = true
        boxHandleAdornment.ZIndex = 10
        boxHandleAdornment.Parent = fn4()
        tbl2.list6[part] = boxHandleAdornment
    end
    local function fn53(part)
        local var260 = tbl2.list6[part]
        if var260 then
            pcall(function()
                var260:Destroy()
            end)
            tbl2.list6[part] = nil
        end
    end
    local function fn54(arg44)
        if typeof(arg44) ~= "Instance" then
            return nil
        end
        local n = string.lower(arg44.Name)
        if n == "window" and arg44:IsA("Model") then
            local bottom = arg44:FindFirstChild("Bottom", true)
            if bottom and bottom:IsA("BasePart") then
                return bottom
            end
            return arg44.PrimaryPart
        end
        if n == "bottom" and arg44:IsA("BasePart") then
            if arg44.Parent and string.lower(arg44.Parent.Name) == "window" then
                return arg44
            end
        end
        return nil
    end
    local function fn55(arg45)
        local var261 = fn54(arg45)
        if var261 then
            if not tbl2._windowPartMap[var261] then
                tbl2._windowPartMap[var261] = true
                table.insert(tbl2._windowParts, var261)
            end
            if tbl.flag82 and not tbl2.list6[var261] then
                fn52(var261)
            end
        end
    end
    Workspace.DescendantAdded:Connect(function(arg46)
        fn55(arg46)
    end)
    Workspace.DescendantRemoving:Connect(function(arg47)
        local var262 = fn54(arg47) or arg47
        if tbl2._windowPartMap[var262] then
            tbl2._windowPartMap[var262] = nil
            for i9, e in ipairs(tbl2._windowParts) do
                if e == var262 then
                    table.remove(tbl2._windowParts, i9)
                    break
                end
            end
        end
        if tbl2.list6[var262] then
            fn53(var262)
        end
    end)
    local function fn56()
        for part, _ in pairs(tbl2.list6) do
            if not part or not part.Parent then
                fn53(part)
            end
        end
        if tbl.flag82 then
            for _, target in ipairs(tbl2._windowParts) do
                if target and target.Parent and not tbl2.list6[target] then
                    fn52(target)
                end
            end
        end
    end
    task.spawn(function()
        task.wait(3)
        for _, obj in ipairs(Workspace:GetDescendants()) do
            local target = fn54(obj)
            if target and not tbl2._windowPartMap[target] then
                tbl2._windowPartMap[target] = true
                table.insert(tbl2._windowParts, target)
            end
        end
        fn56()
    end)
    function var234()
        if not tbl2.flag108 then
            return
        end
        local var265 = tbl.flag80 or tbl.flag81
        if var265 then
            local tbl13 = {}
            for _, obj in ipairs(tbl2.list1.Generators) do
                if obj and obj.Parent then
                    local var266 = fn44(obj)
                    if not var266 then
                        table.insert(tbl13, obj)
                    end
                end
            end
            tbl2.list1.Generators = tbl13
        else
            for _, obj in ipairs(tbl2.list1.Generators) do
                if obj and obj.Parent then
                    fn43(obj)
                    local __BolongGenProgress__2 = obj:FindFirstChild("__BolongGenProgress__")
                    if __BolongGenProgress__2 then
                        __BolongGenProgress__2:Destroy()
                    end
                    obj:SetAttribute("__BolongGenLastPct__", nil)
                end
            end
        end
        if tbl.flag83 then
            for _, pallet in ipairs(tbl2.list1.Pallets) do
                if pallet and pallet.Parent then
                    local var267 = tbl2.list2[pallet]
                    if var267 and not var267.isFake then
                        fn42(pallet, tbl.color311)
                    end
                end
            end
        else
            for _, pallet in ipairs(tbl2.list1.Pallets) do
                if pallet then
                    fn43(pallet)
                end
            end
        end
        if tbl.flag84 then
            for _, v20 in ipairs(tbl2.list1.Hooks) do
                if v20 and v20.Parent then
                    local var268 = tbl2.list3[v20]
                    if var268 then
                        for _, v21 in ipairs(var268) do
                            fn42(v21, tbl.color312)
                        end
                    else
                        fn42(v20, tbl.color312)
                    end
                end
            end
        else
            for _, v22 in ipairs(tbl2.list1.Hooks) do
                if v22 and v22.Parent then
                    local var269 = tbl2.list3[v22]
                    if var269 then
                        for _, v23 in ipairs(var269) do
                            fn43(v23)
                        end
                    else
                        fn43(v22)
                    end
                end
            end
        end
        if tbl.flag85 then
            for _, v24 in ipairs(tbl2.list1.Gates) do
                if v24 and v24.Parent then
                    fn42(v24, tbl.color313)
                end
            end
        else
            for _, v25 in ipairs(tbl2.list1.Gates) do
                if v25 and v25.Parent then
                    fn43(v25)
                end
            end
        end
        if tbl.flag82 then
            fn56()
            for part, v26 in pairs(tbl2.list6) do
                if part and part.Parent and v26 and v26.Parent then
                    pcall(function()
                        local color = tbl.color310
                        v26.Color3 = color
                        v26.Size = part.Size
                    end)
                else
                    fn53(part)
                end
            end
        else
            for part, _ in pairs(tbl2.list6) do
                fn53(part)
            end
        end
    end
    tbl2._antiLoopWindowCache = {}
    tbl2._antiLoopWindowMap = {}
    Workspace.DescendantAdded:Connect(function(arg48)
        if typeof(arg48) ~= "Instance" then
            return
        end
        if not (arg48:IsA("BasePart") or arg48:IsA("Model")) then
            return
        end
        local n = arg48.Name
        if n ~= "Window" and n ~= "VaultPoint" and not string.find(n, "Window") then
            return
        end
        if tbl2._antiLoopWindowMap[arg48] then
            return
        end
        tbl2._antiLoopWindowMap[arg48] = true
        table.insert(tbl2._antiLoopWindowCache, arg48)
    end)
    Workspace.DescendantRemoving:Connect(function(arg49)
        if not tbl2._antiLoopWindowMap[arg49] then
            return
        end
        tbl2._antiLoopWindowMap[arg49] = nil
        for i10, e in ipairs(tbl2._antiLoopWindowCache) do
            if e == arg49 then
                table.remove(tbl2._antiLoopWindowCache, i10)
                break
            end
        end
    end)
    task.spawn(function()
        local map = workspace:FindFirstChild("Map")
        if map then
            for _, v27 in ipairs(map:GetDescendants()) do
                if typeof(v27) == "Instance" and (v27:IsA("BasePart") or v27:IsA("Model")) then
                    local n = v27.Name
                    if n == "Window" or n == "VaultPoint" or string.find(n, "Window") then
                        if not tbl2._antiLoopWindowMap[v27] then
                            tbl2._antiLoopWindowMap[v27] = true
                            table.insert(tbl2._antiLoopWindowCache, v27)
                        end
                    end
                end
            end
        end
    end)
    local function fn57()
        local tbl14 = {}
        for _, v28 in ipairs(tbl2._antiLoopWindowCache) do
            if v28 and v28.Parent then
                table.insert(tbl14, v28)
            end
        end
        for _, v29 in ipairs(CollectionService:GetTagged("VaultPoint")) do
            local flag6 = false
            for _, v30 in ipairs(tbl14) do
                if v30 == v29 then
                    flag6 = true
                    break
                end
            end
            if not flag6 then
                table.insert(tbl14, v29)
            end
        end
        return tbl14
    end
    function ApplyAntiLoopWindow()
        if not tbl2.flag146 then
            return
        end
        local remotes4 = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes4 then
            return
        end
        local window2 = remotes4:FindFirstChild("Window")
        if not window2 then
            return
        end
        local vaultEvent = window2:FindFirstChild("VaultEvent")
        if not vaultEvent then
            return
        end
        task.spawn(function()
            task.wait(1)
            local var271 = fn57()
            for _, v31 in ipairs(var271) do
                task.spawn(function()
                    pcall(function()
                        vaultEvent:FireServer(v31, true)
                    end)
                end)
                task.wait(0.05)
            end
        end)
    end
    function DisableAntiLoopWindow()
        local remotes5 = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes5 then
            return
        end
        local window3 = remotes5:FindFirstChild("Window")
        if not window3 then
            return
        end
        local vaultCompleteEvent = window3:FindFirstChild("VaultCompleteEvent")
        local vaultCompleteEventpart1 = window3:FindFirstChild("VaultCompleteEventpart1")
        task.spawn(function()
            local var272 = fn57()
            for _, v32 in ipairs(var272) do
                task.spawn(function()
                    pcall(function()
                        if vaultCompleteEvent then
                            vaultCompleteEvent:FireServer(v32, false)
                        end
                        if vaultCompleteEventpart1 then
                            vaultCompleteEventpart1:FireServer()
                        end
                    end)
                end)
                task.wait(0.05)
            end
        end)
    end
    do
        local map2 = workspace:FindFirstChild("Map")
        if map2 then
            fn51(map2)
            ApplyAntiLoopWindow()
        end
        workspace.ChildAdded:Connect(function(arg50)
            if arg50.Name == "Map" then
                task.wait(2)
                fn51(arg50)
                ApplyAntiLoopWindow()
            end
        end)
        workspace.ChildRemoved:Connect(function(arg51)
            if arg51.Name == "Map" then
                tbl2.list1 = {Generators = {}, Pallets = {}, Hooks = {}, Gates = {}}
                tbl2.list2 = {}
                tbl2.list3 = {}
                tbl2.list4 = {}
                tbl2.flag108 = false
                tbl2.list5 = {}
                tbl2.num126 = 1
            end
        end)
    end
    fn5("GenESPUpdater", 0.2, function()
        if not tbl.flag80 and not tbl.flag81 then
            return
        end
        for _, obj in ipairs(tbl2.list1.Generators) do
            if obj and obj.Parent and not tbl2.list4[obj] then
                fn44(obj)
            end
        end
    end)
    function DropAllPallets()
        if not getnilinstances then
            fn2("Error", "Executor tidak support getnilinstances()", 2)
            return
        end
        task.spawn(function()
            local remotes6 = ReplicatedStorage:FindFirstChild("Remotes")
            if not remotes6 then
                return
            end
            local pallet2 = remotes6:FindFirstChild("Pallet")
            pallet2 = pallet2 and pallet2:FindFirstChild("PalletDropEvent")
            if not pallet2 then
                return
            end
            local tbl15 = {}
            local tbl16 = {}
            local var273, nilInstances = pcall(getnilinstances)
            if var273 and type(nilInstances) == "table" then
                for _, obj in ipairs(nilInstances) do
                    if typeof(obj) == "Instance" then
                        local name = obj.Name
                        if name == "PalletPointSlide" or name == "palletDropPoint" or name == "PalletDropPoint" or name == "PalletPoint" then
                            if not tbl16[obj] then
                                table.insert(tbl15, obj)
                                tbl16[obj] = true
                            end
                        end
                    end
                end
            end
            if tbl2.list16 then
                for _, obj in ipairs(tbl2.list16) do
                    if obj and obj.Parent and not tbl16[obj] then
                        table.insert(tbl15, obj)
                        tbl16[obj] = true
                    end
                end
            end
            if #tbl15 == 0 then
                return
            end
            for _, v33 in ipairs(tbl15) do
                pcall(function()
                    pallet2:FireServer(v33)
                end)
            end
        end)
    end
    local function onDescendantAdded3(obj)
        if typeof(obj) ~= "Instance" then
            return
        end
        local name = obj.Name
        if name ~= "PalletPointSlide" and name ~= "palletDropPoint" and name ~= "PalletDropPoint" and name ~= "PalletPoint" then
            return
        end
        if not tbl2.list16 then
            tbl2.list16 = {}
        end
        if tbl2._palletPointMap[obj] then
            return
        end
        tbl2._palletPointMap[obj] = true
        table.insert(tbl2.list16, obj)
    end
    tbl2._palletPointMap = {}
    Workspace.DescendantAdded:Connect(onDescendantAdded3)
    Workspace.DescendantRemoving:Connect(function(obj)
        if not tbl2._palletPointMap[obj] then
            return
        end
        tbl2._palletPointMap[obj] = nil
        if tbl2.list16 then
            for i11, e in ipairs(tbl2.list16) do
                if e == obj then
                    table.remove(tbl2.list16, i11)
                    break
                end
            end
        end
    end)
    if getnilinstances then
        local var274, nilInstances = pcall(getnilinstances)
        if var274 and type(nilInstances) == "table" then
            for _, obj in ipairs(nilInstances) do
                onDescendantAdded3(obj)
            end
        end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        onDescendantAdded3(obj)
    end
    fn5("AutoDropNearbyPallets", 0.2, function()
        if not tbl2.flag148 then
            return
        end
        if tbl2.flag149 then
            return
        end
        local char = localPlayer.Character
        if not char then
            return
        end
        local humanoidRootPart4 = char:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart4 then
            return
        end
        local remotes7 = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes7 then
            return
        end
        local pallet3 = remotes7:FindFirstChild("Pallet")
        pallet3 = pallet3 and pallet3:FindFirstChild("PalletDropEvent")
        if not pallet3 then
            return
        end
        local position3 = humanoidRootPart4.Position
        if not tbl2.list16 then
            tbl2.list16 = {}
            tbl2._palletPointMap = {}
            if getnilinstances then
                local var275, nilInstances = pcall(getnilinstances)
                if var275 and type(nilInstances) == "table" then
                    for _, obj in ipairs(nilInstances) do
                        onDescendantAdded3(obj)
                    end
                end
            end
            for _, obj in ipairs(workspace:GetDescendants()) do
                onDescendantAdded3(obj)
            end
        end
        if tick() - (tbl2.num148 or 0) > 5 then
            tbl2.num148 = tick()
            if getnilinstances then
                local var276, nilInstances = pcall(getnilinstances)
                if var276 and type(nilInstances) == "table" then
                    for _, obj in ipairs(nilInstances) do
                        onDescendantAdded3(obj)
                    end
                end
            end
        end
        local var277 = nil
        local huge = math.huge
        for i12 = #tbl2.list16, 1, -1 do
            local obj = tbl2.list16[i12]
            if not obj or not obj.Parent then
                tbl2._palletPointMap[obj] = nil
                table.remove(tbl2.list16, i12)
            else
                local pos = nil
                pcall(function()
                    if obj:IsA("BasePart") then
                        pos = obj.Position
                    elseif obj:IsA("Model") then
                        pos = obj:GetPivot().Position
                    elseif obj:IsA("Attachment") then
                        pos = obj.WorldPosition
                    end
                end)
                if not pos then
                    local part = obj:FindFirstChildWhichIsA("BasePart", true)
                    if part then
                        pos = part.Position
                    end
                end
                if pos then
                    local dist = (pos - position3).Magnitude
                    if dist < huge then
                        huge = dist
                        var277 = obj
                    end
                end
            end
        end
        if var277 and huge <= 4 then
            pcall(function()
                pallet3:FireServer(var277)
            end)
            for i13, obj in ipairs(tbl2.list16) do
                if obj == var277 then
                    tbl2._palletPointMap[obj] = nil
                    table.remove(tbl2.list16, i13)
                    break
                end
            end
            tbl2.flag149 = true
            task.delay(2, function()
                tbl2.flag149 = false
            end)
        end
    end)
end
local var278, IsPlayerDoingAction
do
    local function fn58()
        task.spawn(function()
            local var279, mechanics = pcall(function()
                return game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 10):WaitForChild("Mechanics", 10)
            end)
            if not var279 or not mechanics then
                return
            end
            local slow = mechanics:FindFirstChild("Slow")
            if slow and slow:IsA("BindableEvent") then
                slow.Event:Connect(function(_, dur, extra)
                    local var280 = (tonumber(dur) or 0) + (tonumber(extra) or 0)
                    if var280 > 0 then
                        tbl2.num129 = tick() + var280 + 0.1
                    end
                end)
            end
            local slowserver = mechanics:FindFirstChild("Slowserver")
            if slowserver and slowserver:IsA("RemoteEvent") then
                slowserver.OnClientEvent:Connect(function(_, dur)
                    local var281 = tonumber(dur) or 0
                    if var281 > 0 then
                        tbl2.num129 = tick() + var281 + 0.1
                    end
                end)
            end
        end)
    end
    function var278()
        return tick() < tbl2.num129
    end
    function IsPlayerDoingAction()
        local char = localPlayer.Character
        if not char then
            return false
        end
        local humanoidRootPart5 = char:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart5 and CollectionService:HasTag(humanoidRootPart5, "doing action") then
            return true
        end
        return false
    end
    fn58()
end
do
    local function fn59(player)
        if not player then
            return 0
        end
        local var282, val = pcall(function()
            return player:GetAttribute("HookCount")
        end)
        if var282 and typeof(val) == "number" then
            return val
        end
        local hookCount = player:FindFirstChild("HookCount")
        if hookCount and hookCount:IsA("ValueBase") then
            return tonumber(hookCount.Value) or 0
        end
        local char = player.Character
        if char then
            local var283, cval = pcall(function()
                return char:GetAttribute("HookCount")
            end)
            if var283 and typeof(cval) == "number" then
                return cval
            end
            local hookCount2 = char:FindFirstChild("HookCount")
            if hookCount2 and hookCount2:IsA("ValueBase") then
                return tonumber(hookCount2.Value) or 0
            end
        end
        return 0
    end
    local function fn60(enabled)
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return
        end
        for _, gui in ipairs(playerGui2:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name:match("%-mob$") then
                local frame2 = gui:FindFirstChild("Frame")
                if frame2 then
                    for i14 = 1, 5 do
                        local var284 = frame2:FindFirstChild("Survivor" .. i14)
                        local var285 = var284 and var284:FindFirstChild("ImageLabel")
                        local var286 = var284 and var284:FindFirstChild("TextLabel")
                        if var285 and var286 then
                            local str3 = "Bolong_CustomHookCounter"
                            local var287 = var285:FindFirstChild(str3)
                            local counter = var285:FindFirstChild("Counter")
                            local function fn61(cacheKey)
                                if counter then
                                    pcall(function()
                                        counter.Visible = false
                                    end)
                                end
                                if var287 then
                                    var287.Visible = false
                                end
                                if cacheKey then
                                    tbl2.list17[cacheKey] = nil
                                end
                            end
                            if not enabled then
                                fn61(nil)
                                continue
                            end
                            local var288 = var286.Text and var286.Text:match("^%s*(.-)%s*$") or ""
                            local var289 = var288:lower()
                            local var290 = var288 == "" or var289 == "waiting" or var289:find("waiting") or var289 == "empty" or var288:match("^Survivor%d+$")
                            local flag7 = true
                            pcall(function()
                                if var284.Visible == false then
                                    flag7 = false
                                end
                                if var285.Image == "" or var285.Image == "rbxasset://textures/ui/GuiImagePlaceholder.png" then
                                end
                            end)
                            if not flag7 then
                                fn61(nil)
                                continue
                            end
                            local player = nil
                            if not var290 then
                                for _, v34 in ipairs(Players:GetPlayers()) do
                                    if v34.Name == var288 or v34.DisplayName == var288 then
                                        player = v34
                                        break
                                    end
                                end
                            end
                            if not player then
                                fn61(nil)
                                continue
                            end
                            local var291 = fn59(player)
                            tbl2.list17[player.Name] = var291
                            if var291 <= 0 then
                                if counter then
                                    pcall(function()
                                        counter.Visible = false
                                    end)
                                end
                                if not var287 then
                                    var287 = Instance.new("TextLabel")
                                    var287.Name = str3
                                    var287.Size = UDim2.new(1, 0, 0.35, 0)
                                    var287.Position = UDim2.new(0, 0, 0.65, 0)
                                    var287.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                                    var287.BackgroundTransparency = 0.5
                                    var287.TextColor3 = Color3.fromRGB(255, 255, 255)
                                    var287.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                    var287.TextStrokeTransparency = 0
                                    var287.TextScaled = true
                                    var287.Font = Enum.Font.SourceSansBold
                                    var287.BorderSizePixel = 0
                                    var287.Parent = var285
                                end
                                var287.Visible = true
                                var287.Text = "Hooks: 0"
                                var287.TextColor3 = Color3.fromRGB(255, 255, 255)
                                continue
                            end
                            if counter then
                                pcall(function()
                                    counter.Visible = true
                                end)
                            end
                            if not var287 then
                                var287 = Instance.new("TextLabel")
                                var287.Name = str3
                                var287.Size = UDim2.new(1, 0, 0.35, 0)
                                var287.Position = UDim2.new(0, 0, 0.65, 0)
                                var287.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                                var287.BackgroundTransparency = 0.5
                                var287.TextColor3 = Color3.fromRGB(255, 255, 255)
                                var287.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                var287.TextStrokeTransparency = 0
                                var287.TextScaled = true
                                var287.Font = Enum.Font.SourceSansBold
                                var287.BorderSizePixel = 0
                                var287.Parent = var285
                            end
                            var287.Visible = true
                            if var291 >= 3 then
                                var287.Text = "DEAD"
                                var287.TextColor3 = Color3.fromRGB(255, 75, 75)
                            elseif var291 == 2 then
                                var287.Text = "Hooks: 2"
                                var287.TextColor3 = Color3.fromRGB(255, 140, 0)
                            else
                                var287.Text = "Hooks: 1"
                                var287.TextColor3 = Color3.fromRGB(210, 130, 255)
                            end
                        end
                    end
                end
            end
        end
    end
    local function fn62(player)
        if not player or tbl2.hookCounterAttrConns[player] then
            return
        end
        pcall(function()
            local connection4 = player:GetAttributeChangedSignal("HookCount"):Connect(function()
                tbl2.flag152 = true
            end)
            tbl2.hookCounterAttrConns[player] = connection4
        end)
        pcall(function()
            local hookCount3 = player:FindFirstChild("HookCount")
            if hookCount3 and hookCount3:IsA("ValueBase") then
                local connection5 = hookCount3.Changed:Connect(function()
                    tbl2.flag152 = true
                end)
                tbl2.hookCounterAttrConns[player.Name .. "_val"] = connection5
            end
        end)
        if player.Character then
            pcall(function()
                local connection6 = player.Character:GetAttributeChangedSignal("HookCount"):Connect(function()
                    tbl2.flag152 = true
                end)
                tbl2.hookCounterAttrConns[player.Name .. "_char"] = connection6
            end)
        end
        pcall(function()
            player.CharacterAdded:Connect(function(char)
                if not tbl.flag105 then
                    return
                end
                task.wait(0.5)
                pcall(function()
                    local connection7 = char:GetAttributeChangedSignal("HookCount"):Connect(function()
                        tbl2.flag152 = true
                    end)
                    tbl2.hookCounterAttrConns[player.Name .. "_char"] = connection7
                end)
                tbl2.flag152 = true
            end)
        end)
    end
    local function fn63()
        for k, v35 in pairs(tbl2.hookCounterAttrConns) do
            pcall(function()
                v35:Disconnect()
            end)
            tbl2.hookCounterAttrConns[k] = nil
        end
        if tbl2.connection22 then
            pcall(function()
                tbl2.connection22:Disconnect()
            end)
            tbl2.connection22 = nil
        end
        if tbl2.connection23 then
            pcall(function()
                tbl2.connection23:Disconnect()
            end)
            tbl2.connection23 = nil
        end
        if tbl2.connection24 then
            pcall(function()
                tbl2.connection24:Disconnect()
            end)
            tbl2.connection24 = nil
        end
    end
    local function fn64()
        if tbl2.connection22 then
            return
        end
        tbl2.flag152 = true
        for _, v36 in ipairs(Players:GetPlayers()) do
            fn62(v36)
        end
        tbl2.connection23 = Players.PlayerAdded:Connect(function(arg52)
            task.wait(0.5)
            fn62(arg52)
            tbl2.flag152 = true
        end)
        tbl2.connection24 = Players.PlayerRemoving:Connect(function(arg53)
            tbl2.list17[arg53.Name] = nil
            local var293 = tbl2.hookCounterAttrConns[arg53]
            if var293 then
                pcall(function()
                    var293:Disconnect()
                end)
                tbl2.hookCounterAttrConns[arg53] = nil
            end
            local var294 = tbl2.hookCounterAttrConns[arg53.Name .. "_val"]
            if var294 then
                pcall(function()
                    var294:Disconnect()
                end)
                tbl2.hookCounterAttrConns[arg53.Name .. "_val"] = nil
            end
            local var295 = tbl2.hookCounterAttrConns[arg53.Name .. "_char"]
            if var295 then
                pcall(function()
                    var295:Disconnect()
                end)
                tbl2.hookCounterAttrConns[arg53.Name .. "_char"] = nil
            end
            tbl2.flag152 = true
        end)
        local playerGui3 = localPlayer:FindFirstChild("PlayerGui")
        if playerGui3 then
            tbl2.connection22 = playerGui3.ChildAdded:Connect(function(arg54)
                if arg54:IsA("ScreenGui") and arg54.Name:match("%-mob$") then
                    tbl2.flag152 = true
                end
                if arg54.Name == "Frame" and arg54.Parent and arg54.Parent.Name:match("%-mob$") then
                    tbl2.flag152 = true
                end
            end)
            local connection8 = playerGui3.DescendantAdded:Connect(function(arg55)
                if arg55.Name == "Survivor1" or arg55.Name == "ImageLabel" then
                    local screenGui = arg55:FindFirstAncestorOfClass("ScreenGui")
                    if screenGui and screenGui.Name:match("%-mob$") then
                        tbl2.flag152 = true
                    end
                end
            end)
            tbl2.hookCounterAttrConns._guiDesc = connection8
        end
        fn60(true)
    end
    local function fn65()
        fn63()
        tbl2.list17 = {}
        tbl2.flag152 = true
        fn60(false)
        local playerGui4 = localPlayer:FindFirstChild("PlayerGui")
        if playerGui4 then
            for _, gui in ipairs(playerGui4:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Name:match("%-mob$") then
                    local frame3 = gui:FindFirstChild("Frame")
                    if frame3 then
                        for i15 = 1, 5 do
                            local var296 = frame3:FindFirstChild("Survivor" .. i15)
                            local var297 = var296 and var296:FindFirstChild("ImageLabel")
                            local var298 = var297 and var297:FindFirstChild("Bolong_CustomHookCounter")
                            if var298 then
                                pcall(function()
                                    var298:Destroy()
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
    fn5("HookCounter", 0.5, function()
        if not tbl.flag105 then
            return
        end
        if not tbl2.flag152 then
            local flag8 = false
            for _, v37 in ipairs(Players:GetPlayers()) do
                local cur = fn59(v37)
                if tbl2.list17[v37.Name] ~= cur then
                    flag8 = true
                    break
                end
            end
            if not flag8 then
                return
            end
            tbl2.flag152 = true
        end
        tbl2.flag152 = false
        fn60(true)
    end)
    _G.Bolong_SetShowHookCounter = function(enabled)
        tbl.flag105 = enabled and true or false
        if tbl.flag105 then
            fn64()
        else
            fn65()
        end
    end
    getgenv().Bolong_SetShowHookCounter = _G.Bolong_SetShowHookCounter
    tbl2._HookCounter_Enable = fn64
    tbl2._HookCounter_Disable = fn65
    tbl2._HookCounter_Update = fn60
end
local var300, _ApplySpeed, _StartAntiFallSlow, _StopAntiFallSlow, _StartNoSlowdown, _StopNoSlowdown, SetupMovementForChar
do
    function var300()
        if tbl2.SpeedBoost then
            return num7 * (1 + math.clamp(tonumber(tbl2.num127) or 0.3, 0, 2))
        end
        return num7
    end
    function _ApplySpeed(arg56, arg57)
        if not arg56 or not arg56.Parent then
            return
        end
        if math.abs(arg56.WalkSpeed - arg57) > 0.05 then
            pcall(function()
                arg56.WalkSpeed = arg57
            end)
        end
    end
    local function fn66()
        task.spawn(function()
            local var301, remote = pcall(function()
                return game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 10):WaitForChild("Mechanics", 10):WaitForChild("Fall", 10)
            end)
            if not var301 or not remote then
                return
            end
            local var302
            var302 = hookmetamethod(game, "__namecall", function(self, ...)
                local var303 = getnamecallmethod()
                if tbl2.flag111 and var303 == "FireServer" and rawequal(self, remote) then
                    return
                end
                return var302(self, ...)
            end)
        end)
    end
    function _StartAntiFallSlow(arg58)
        if tbl2.movConns.antiFall then
            tbl2.movConns.antiFall:Disconnect()
        end
        fn66()
        if not arg58 then
            return
        end
        pcall(function()
            arg58:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        end)
        tbl2.movConns.antiFall = arg58.StateChanged:Connect(function(_, arg59)
            if not tbl2.flag111 then
                return
            end
            if arg59 == Enum.HumanoidStateType.Landed or arg59 == Enum.HumanoidStateType.GettingUp or arg59 == Enum.HumanoidStateType.FallingDown then
                pcall(function()
                    arg58:ChangeState(Enum.HumanoidStateType.Running)
                end)
                _ApplySpeed(arg58, var300())
            end
        end)
    end
    function _StopAntiFallSlow(arg60)
        if tbl2.movConns.antiFall then
            tbl2.movConns.antiFall:Disconnect()
            tbl2.movConns.antiFall = nil
        end
        if arg60 and arg60.Parent then
            pcall(function()
                arg60:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            end)
        end
    end
    function _StartNoSlowdown(arg61)
        if tbl2.movConns.noSlow then
            tbl2.movConns.noSlow:Disconnect()
            tbl2.movConns.noSlow = nil
        end
        if not arg61 then
            return
        end
        if fn9(localPlayer) == "killer" then
            return
        end
        tbl2.movConns.noSlow = arg61:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if not tbl2.flag109 then
                return
            end
            if fn9(localPlayer) == "killer" then
                return
            end
            local char = localPlayer.Character
            if tbl2.safeModeSpeed and char and (char:GetAttribute("IsHooked") or char:GetAttribute("IsCarried") or arg61.Health <= 50) then
                return
            end
            if tbl2.flag112 and (var278() or IsPlayerDoingAction()) then
                return
            end
            local var305 = var300()
            if arg61.WalkSpeed < var305 - 0.05 then
                pcall(function()
                    arg61.WalkSpeed = var305
                end)
            end
        end)
    end
    function _StopNoSlowdown()
        if tbl2.movConns.noSlow then
            tbl2.movConns.noSlow:Disconnect()
            tbl2.movConns.noSlow = nil
        end
    end
    function SetupMovementForChar(char)
        if not char then
            return
        end
        local humanoid4 = char:WaitForChild("Humanoid", 5)
        if not humanoid4 then
            return
        end
        if tbl2.flag111 then
            _StartAntiFallSlow(humanoid4)
        end
        if tbl2.flag109 and fn9(localPlayer) ~= "killer" then
            _StartNoSlowdown(humanoid4)
        end
        if tbl2.SpeedBoost then
            local var306 = var300()
            task.wait(0.15)
            if not (tbl2.safeModeSpeed and (var278() or IsPlayerDoingAction())) then
                _ApplySpeed(humanoid4, var306)
            end
        end
    end
    localPlayer:GetPropertyChangedSignal("Team"):Connect(function()
        fn10(localPlayer)
        if fn9(localPlayer) == "killer" and tbl2.movConns.noSlow then
            tbl2.movConns.noSlow:Disconnect()
            tbl2.movConns.noSlow = nil
        end
        if fn9(localPlayer) ~= "killer" then
            fn14()
        end
    end)
end
local var307
do
    function var307()
        if tbl2.field33 then
            if tbl2.field33.Parent then
                return
            end
            tbl2.field33 = nil
        end
        local playerGui5 = localPlayer:WaitForChild("PlayerGui")
        local screenGui2 = Instance.new("ScreenGui")
        screenGui2.Name = "BolongHubMoonwalk"
        screenGui2.ResetOnSpawn = false
        screenGui2.Enabled = false
        screenGui2.Parent = playerGui5
        local frame4 = Instance.new("Frame")
        frame4.Name = "MoonwalkBtns"
        frame4.AnchorPoint = Vector2.new(1, 1)
        frame4.Position = UDim2.new(1, -18, 1, -170)
        frame4.Size = UDim2.fromOffset(46, 96)
        frame4.BackgroundTransparency = 1
        frame4.Parent = screenGui2
        local function fn67(rotation, arg62)
            local imageButton = Instance.new("ImageButton")
            imageButton.BackgroundTransparency = 1
            imageButton.BorderSizePixel = 0
            imageButton.AutoButtonColor = false
            imageButton.AnchorPoint = Vector2.new(0.5, 0)
            imageButton.Position = UDim2.new(0.5, 0, 0, arg62)
            imageButton.Size = UDim2.fromOffset(42, 42)
            imageButton.Image = "rbxassetid://125598796341580"
            imageButton.ScaleType = Enum.ScaleType.Slice
            imageButton.ImageColor3 = Color3.fromRGB(170, 170, 170)
            imageButton.ImageTransparency = 0.25
            imageButton.Rotation = rotation
            imageButton.Parent = frame4
            return imageButton
        end
        local var310 = fn67(-90, 0)
        local var311 = fn67(90, 50)
        local function fn68(arg63, arg64)
            arg63.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    tbl2.num149 = arg64
                    arg63.ImageColor3 = Color3.fromRGB(255, 255, 255)
                    arg63.ImageTransparency = 0
                end
            end)
            arg63.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    tbl2.num149 = 0
                    arg63.ImageColor3 = Color3.fromRGB(170, 170, 170)
                    arg63.ImageTransparency = 0.25
                end
            end)
        end
        fn68(var310, 1)
        fn68(var311, -1)
        tbl2.field33 = screenGui2
    end
    fn5("MoonwalkGuiGuard", 0.5, function()
        if not tbl.flag99 then
            return
        end
        if not tbl2.field33 or not tbl2.field33.Parent then
            var307()
            if tbl2.field33 then
                tbl2.field33.Enabled = true
            end
        elseif not tbl2.field33.Enabled then
            tbl2.field33.Enabled = true
        end
    end)
    local function fn69(arg65)
        if arg65:FindFirstChild("BolongMoonwalkAlign") then
            return arg65:FindFirstChild("BolongMoonwalkAlign")
        end
        local attachment = Instance.new("Attachment")
        attachment.Name = "BolongMoonwalkAtt"
        attachment.Parent = arg65
        local alignOrientation = Instance.new("AlignOrientation")
        alignOrientation.Name = "BolongMoonwalkAlign"
        alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
        alignOrientation.Attachment0 = attachment
        alignOrientation.MaxTorque = 6000000
        alignOrientation.Responsiveness = 65
        alignOrientation.Parent = arg65
        return alignOrientation
    end
    local function fn70(arg66)
        local bolongMoonwalkAlign = arg66:FindFirstChild("BolongMoonwalkAlign")
        local bolongMoonwalkAtt = arg66:FindFirstChild("BolongMoonwalkAtt")
        if bolongMoonwalkAlign then
            bolongMoonwalkAlign:Destroy()
        end
        if bolongMoonwalkAtt then
            bolongMoonwalkAtt:Destroy()
        end
    end
    fn5("MoonwalkLock", 0, function(arg67)
        if not tbl.flag99 then
            return
        end
        local char = localPlayer.Character
        local var312 = char and char:FindFirstChildOfClass("Humanoid")
        local var313 = char and char:FindFirstChild("HumanoidRootPart")
        local currentCamera6 = Workspace.CurrentCamera
        if not var312 or not var313 or not currentCamera6 then
            return
        end
        local num12 = 0
        if tbl2.flag150 then
            num12 = 1
        end
        if tbl2.flag151 then
            num12 = -1
        end
        if tbl2.num149 ~= 0 then
            num12 = tbl2.num149
        end
        if num12 == 0 then
            if not var312.AutoRotate then
                var312.AutoRotate = true
            end
            fn70(var313)
            tbl2.num150 = 0
            return
        end
        var312.AutoRotate = false
        local var314 = fn69(var313)
        local lookVector = currentCamera6.CFrame.LookVector
        local vector36 = Vector3.new(lookVector.X, 0, lookVector.Z)
        if vector36.Magnitude > 0.001 then
            vector36 = vector36.Unit
            local var315 = num12 == 1 and vector36 or -vector36
            if (tbl.str15 or "Classic") == "Classic" then
                var314.Responsiveness = 15
                tbl2.num150 = 0
                local cFrame = CFrame.lookAt(Vector3.new(0, 0, 0), var315)
                var314.CFrame = cFrame
            else
                var314.Responsiveness = 65
                local var316 = math.atan2(var315.X, var315.Z)
                local num13 = 0
                if var312.MoveDirection.Magnitude > 0.01 then
                    local var317 = tbl.num124 or 6
                    local var318 = tbl.num123 or 0.55
                    local num14 = 0.06
                    local interval = 1.2 / var317
                    if tick() - tbl2.num152 >= interval then
                        tbl2.num152 = tick()
                        tbl2.num151 = -tbl2.num151
                    end
                    local var319 = tbl2.num151 * var318
                    local var320 = math.clamp(arg67 * 14, 0, 1)
                    tbl2.num150 = tbl2.num150 + (var319 - tbl2.num150) * var320
                    local var321 = (math.random() - 0.5) * num14
                    num13 = tbl2.num150 + var321
                else
                    tbl2.num150 = 0
                    num13 = 0
                end
                local var322 = var316 + num13
                local cFrame2 = CFrame.Angles(0, var322, 0)
                var314.CFrame = cFrame2
            end
        end
    end)
end
local function fn71()
    tbl2.flag122 = true
    tbl2.health1 = nil
    local char = localPlayer.Character
    local var323 = char and char:FindFirstChildOfClass("Humanoid")
    if var323 then
        pcall(function()
            var323:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end)
        pcall(function()
            var323:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end)
        pcall(function()
            var323:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        end)
    end
end
local function fn72()
    tbl2.flag122 = false
    tbl2.health1 = nil
    local char = localPlayer.Character
    local var324 = char and char:FindFirstChildOfClass("Humanoid")
    if var324 then
        pcall(function()
            var324:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end)
        pcall(function()
            var324:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end)
        pcall(function()
            var324:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        end)
    end
end
fn5("GodMode", 0.2, function()
    if not tbl2.flag122 then
        return
    end
    local char = localPlayer.Character
    if not char then
        return
    end
    local humanoid5 = char:FindFirstChildOfClass("Humanoid")
    if not humanoid5 then
        return
    end
    local maxHealth = humanoid5.MaxHealth
    local health = humanoid5.Health
    if tbl2.health1 ~= nil and health < tbl2.health1 and health > 0 then
        pcall(function()
            humanoid5.Health = maxHealth
        end)
    end
    tbl2.health1 = humanoid5.Health
    pcall(function()
        local var325 = humanoid5:GetState()
        if var325 == Enum.HumanoidStateType.Dead then
            humanoid5.Health = maxHealth
            humanoid5:ChangeState(Enum.HumanoidStateType.Running)
            tbl2.health1 = maxHealth
        elseif var325 == Enum.HumanoidStateType.Ragdoll or var325 == Enum.HumanoidStateType.FallingDown then
            humanoid5:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end)
local var326
do
    local tbl17 = {active = false, target = nil, generator = nil}
    local kingScourgeStart = ReplicatedStorage.Remotes.KillerPerks.kingscourge:WaitForChild("KingScourgeStart")
    local kingScourgeEnd = ReplicatedStorage.Remotes.KillerPerks.kingscourge:WaitForChild("KingScourgeEnd")
    kingScourgeStart.OnClientEvent:Connect(function(arg68, arg69, hitCount)
        tbl17.active = true
        tbl17.target = arg69
        tbl17.generator = arg68
    end)
    kingScourgeEnd.OnClientEvent:Connect(function()
        tbl17.active = false
        tbl17.target = nil
        tbl17.generator = nil
    end)
    local function fn73()
        for _, name in ipairs({"SkillCheckPromptGui", "SkillCheckPromptGui-con"}) do
            local gui = playerGui:FindFirstChild(name, true)
            if gui then
                local check = gui:FindFirstChild("Check", true)
                if check and check.Visible then
                    return check:FindFirstChild("Line", true), check:FindFirstChild("Goal", true)
                end
            end
        end
    end
    local var327 = nil
    local function fn74()
        if var327 and var327.Parent then
            return var327
        end
        local survivorMob = playerGui:FindFirstChild("Survivor-mob", true)
        if not survivorMob then
            return nil
        end
        local controls2 = survivorMob:FindFirstChild("Controls", true)
        if not controls2 then
            return nil
        end
        local action = controls2:FindFirstChild("action")
        if action and action:IsA("GuiButton") then
            var327 = action
            return action
        end
        action = controls2:FindFirstChild("Gui-mob")
        if action and action:IsA("GuiButton") then
            var327 = action
            return action
        end
        return nil
    end
    function var326()
        local var328 = fn74()
        if var328 and type(firesignal) == "function" then
            firesignal(var328.MouseButton1Down)
            task.delay(0.05, function()
                if var328 and var328.Parent then
                    firesignal(var328.MouseButton1Up)
                    firesignal(var328.MouseButton1Click)
                end
            end)
            return
        end
        local check2 = playerGui:FindFirstChild("check", true)
        if check2 and check2:IsA("GuiObject") and check2.Visible then
            local absolutePosition = check2.AbsolutePosition
            local absoluteSize = check2.AbsoluteSize
            local var329 = GuiService:GetGuiInset()
            local var330 = absolutePosition.X + absoluteSize.X / 2 + var329.X
            local var331 = absolutePosition.Y + absoluteSize.Y / 2 + var329.Y
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(var330, var331, 0, true, game, 1)
                task.wait(0.01)
                VirtualInputManager:SendMouseButtonEvent(var330, var331, 0, false, game, 1)
            end)
        else
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait()
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end
    end
    fn5("Generator", 0, function()
        if not tbl.flag76 then
            return
        end
        local var332, goal = fn73()
        if not (var332 and goal) then
            tbl2.flag123 = false
            tbl2.lastGoalRot = nil
            tbl2.prevLr = nil
            return
        end
        local rotation2 = goal.Rotation
        local rotation3 = var332.Rotation
        local now4 = tick()
        local var333 = tbl17.active and 0.05 or 0.1
        if now4 - tbl2.num136 < var333 then
            tbl2.prevLr = rotation3
            return
        end
        if tbl.str1 == "Instant" then
            if not tbl2.flag123 or rotation2 ~= tbl2.lastGoalRot then
                var332.Rotation = rotation2 + 109
                tbl2.lastGoalRot = rotation2
                tbl2.flag123 = true
                tbl2.num136 = now4
                tbl2.num137 = now4
                var326()
            end
        else
            local var334 = (rotation3 - rotation2) % 360
            local num15 = -1
            if tbl2.prevLr and tbl2.lastGoalRot == rotation2 then
                num15 = (tbl2.prevLr - rotation2) % 360
            end
            tbl2.lastGoalRot = rotation2
            local var335, zoneEnd
            if tbl.str1 == "Perfect" then
                var335 = 102
                zoneEnd = 116
            elseif tbl.str1 == "Normal" then
                var335 = 116
                zoneEnd = 159
            elseif tbl.str1 == "Random" then
                if not tbl2.flag124 then
                    var335 = 102
                    zoneEnd = 116
                else
                    var335 = 116
                    zoneEnd = 159
                end
            else
                return
            end
            local var336 = var334 >= var335 and var334 <= zoneEnd
            local var337 = num15 >= 0 and num15 < var335 and var334 > zoneEnd
            if var336 or var337 then
                if var337 then
                    var332.Rotation = rotation2 + (var335 + zoneEnd) / 2
                end
                tbl2.num136 = now4
                tbl2.num137 = now4
                var326()
                if tbl.str1 == "Random" then
                    tbl2.flag124 = not tbl2.flag124
                end
            end
        end
        tbl2.prevLr = rotation3
    end)
    fn5("GenBtnRefresh", 2, function()
        if not tbl.flag76 then
            return
        end
        if not var327 or not var327.Parent then
            fn74()
        end
    end)
end
function IsGeneratorPoint(obj)
    if not obj then
        return false
    end
    local var338 = obj:GetAttribute("OriginalName")
    if var338 and string.find(tostring(var338):lower(), "generatorpoint") then
        return true
    end
    if string.find(obj.Name, "^GeneratorPoint%d+$") then
        return true
    end
    return false
end
function CollectGeneratorPoints(arg70)
    local tbl18 = {}
    if not arg70 then
        return tbl18
    end
    local tbl19 = {}
    local function fn75(obj)
        if tbl19[obj] then
            return
        end
        if IsGeneratorPoint(obj) then
            tbl19[obj] = true
            table.insert(tbl18, obj)
        end
    end
    local function fn76(arg71)
        for _, v38 in ipairs(arg71:GetChildren()) do
            fn75(v38)
            fn76(v38)
        end
    end
    fn76(arg70)
    table.sort(tbl18, function(arg72, arg73)
        local var339 = arg72:GetAttribute("OriginalName") or arg72.Name
        local var340 = arg73:GetAttribute("OriginalName") or arg73.Name
        return tostring(var339) < tostring(var340)
    end)
    return tbl18
end
function FindGenForPoint(arg74)
    if not arg74 then
        return nil
    end
    local var341 = arg74
    for _ = 1, 6 do
        local parent3 = var341.Parent
        if not parent3 then
            break
        end
        if parent3:IsA("Model") or parent3:IsA("Folder") then
            local name = parent3.Name:lower()
            if string.find(name, "generator") or string.find(name, "gens") then
                return parent3
            end
            for _, v39 in ipairs(parent3:GetChildren()) do
                if IsGeneratorPoint(v39) then
                    return parent3
                end
            end
        end
        var341 = parent3
    end
    for _, v40 in ipairs(tbl2.list1.Generators) do
        if v40 and v40.Parent and arg74:IsDescendantOf(v40) then
            return v40
        end
    end
    return nil
end
function GetAllGenerators()
    local tbl20 = {}
    local tbl21 = {}
    local function fn77(arg75)
        if arg75 and arg75.Parent and not tbl21[arg75] then
            tbl21[arg75] = true
            table.insert(tbl20, arg75)
        end
    end
    for _, v41 in ipairs(tbl2.list1.Generators) do
        fn77(v41)
    end
    local map3 = workspace:FindFirstChild("Map")
    if map3 then
        for _, v42 in ipairs({"Generators", "Generator", "Gens"}) do
            local var342 = map3:FindFirstChild(v42)
            if var342 then
                for _, v43 in ipairs(var342:GetChildren()) do
                    fn77(v43)
                end
            end
        end
    end
    return tbl20
end
function GetPointPosition(arg76)
    if arg76:IsA("BasePart") then
        return arg76.Position
    end
    local part = arg76:FindFirstChildWhichIsA("BasePart")
    if part then
        return part.Position
    end
    return nil
end
function PerformGenBoost()
    task.spawn(function()
        local var352, err = pcall(function()
            local char = localPlayer.Character
            if not char then
                fn2("GenBoost", "Character not found!", 2)
                return
            end
            local humanoidRootPart6 = char:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart6 then
                fn2("GenBoost", "Character HumanoidRootPart not found!", 2)
                return
            end
            local checkInterractable = char:FindFirstChild("CheckInterractable")
            local var343 = checkInterractable and checkInterractable:GetAttribute("isRepairing") or false
            if not var343 then
                fn2("GenBoost", "Repair a generator first!", 2)
                return
            end
            local var344 = GetAllGenerators()
            local var345 = nil
            local huge2 = math.huge
            for _, v44 in ipairs(var344) do
                for _, v45 in ipairs(CollectGeneratorPoints(v44)) do
                    local pos = GetPointPosition(v45)
                    local dist = pos and (pos - humanoidRootPart6.Position).Magnitude or math.huge
                    if dist < huge2 then
                        huge2 = dist
                        var345 = v45
                    end
                end
            end
            local var346 = var345 and FindGenForPoint(var345)
            if not var346 then
                local var347 = nil
                local huge3 = math.huge
                for _, v46 in ipairs(var344) do
                    for _, v47 in ipairs(CollectGeneratorPoints(v46)) do
                        local pos = GetPointPosition(v47)
                        local dist = pos and (pos - humanoidRootPart6.Position).Magnitude or math.huge
                        if dist < huge3 then
                            huge3 = dist
                            var347 = v47
                        end
                    end
                end
                if var347 then
                    var345 = var347
                    var346 = FindGenForPoint(var347)
                end
            end
            if not var346 then
                fn2("GenBoost", "Could not find current generator!", 2)
                return
            end
            local var348 = CollectGeneratorPoints(var346)
            if #var348 == 0 then
                fn2("GenBoost", "No generator points resolved!", 2)
                return
            end
            local var349 = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Generator") and ReplicatedStorage.Remotes.Generator:FindFirstChild("RepairEvent")
            if not var349 then
                var349 = ReplicatedStorage:FindFirstChild("RepairEvent", true)
            end
            if not var349 then
                fn2("GenBoost", "RepairEvent remote not found!", 2)
                return
            end
            local var350 = var345
            local flag9 = false
            for _, v48 in ipairs(var348) do
                if v48 == var350 then
                    flag9 = true
                    break
                end
            end
            if not var350 or not flag9 then
                var350 = var348[1]
            end
            for _, v49 in ipairs(var348) do
                if v49 ~= var350 then
                    var349:FireServer(v49, true)
                    task.wait(0.4)
                    var349:FireServer(var350, true)
                    task.wait(0.15)
                    var349:FireServer(var350, false)
                    task.wait(0.15)
                end
            end
            for _, v50 in ipairs(var348) do
                if v50 ~= var350 then
                    var349:FireServer(v50, true)
                    task.wait(0.3)
                end
            end
            var349:FireServer(var350, false)
            task.wait(0.2)
            local var351 = GetPointPosition(var350)
            if var351 and humanoidRootPart6 then
                pcall(function()
                    humanoidRootPart6.Anchored = false
                end)
                pcall(function()
                    humanoidRootPart6.CFrame = CFrame.new(var351 + Vector3.new(0, 1.5, 0))
                end)
            end
            task.wait(0.3)
            pcall(var326)
            fn2("GenBoost", "Successfully applied generator Boost!", 2)
        end)
        if not var352 then
            fn2("GenBoost", "Critical Error: " .. tostring(err), 2)
        end
    end)
end
function DestroyGenBoostButton()
    if tbl2.connection1 then
        pcall(function()
            tbl2.connection1:Disconnect()
        end)
        tbl2.connection1 = nil
    end
    if tbl2.field1 then
        pcall(function()
            tbl2.field1:Destroy()
        end)
        tbl2.field1 = nil
    end
end
function BuildGenBoostGui(arg77)
    if not arg77 or tbl2.field1 then
        return
    end
    local gui = Instance.new("ScreenGui")
    gui.Name = "BolongHubGenBoost"
    gui.ResetOnSpawn = false
    gui.Parent = localPlayer:WaitForChild("PlayerGui")
    local imageButton2 = Instance.new("ImageButton")
    imageButton2.Name = "GenBoostBtn"
    imageButton2.BackgroundTransparency = 1
    imageButton2.BorderSizePixel = 0
    imageButton2.AutoButtonColor = false
    imageButton2.Size = UDim2.fromOffset(76, 76)
    imageButton2.Image = "rbxassetid://129980991442403"
    imageButton2.ImageTransparency = 0.5
    imageButton2.Draggable = false
    imageButton2.AnchorPoint = Vector2.new(1, 0.5)
    imageButton2.Position = UDim2.new(arg77.Position.X.Scale, arg77.Position.X.Offset + 100, arg77.Position.Y.Scale, arg77.Position.Y.Offset)
    imageButton2.Parent = gui
    imageButton2.MouseButton1Click:Connect(PerformGenBoost)
    imageButton2.MouseButton1Click:Connect(function()
        imageButton2.ImageColor3 = Color3.fromRGB(255, 128, 0)
        task.delay(0.3, function()
            imageButton2.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end)
    end)
    tbl2.field1 = gui
end
function CreateGenBoostButton()
    if tbl2.field1 then
        return
    end
    local playerGui6 = localPlayer:FindFirstChild("PlayerGui")
    if playerGui6 then
        local survivorMob2 = playerGui6:FindFirstChild("Survivor-mob")
        if survivorMob2 then
            local controls3 = survivorMob2:FindFirstChild("Controls")
            local var354 = controls3 and controls3:FindFirstChild("crouch")
            if var354 and var354:IsA("GuiButton") then
                BuildGenBoostGui(var354)
                return
            end
        end
    end
    if tbl2.connection1 then
        return
    end
    playerGui6 = playerGui6 or localPlayer:WaitForChild("PlayerGui")
    tbl2.connection1 = playerGui6.ChildAdded:Connect(function(arg78)
        if arg78 and arg78.Name == "Survivor-mob" then
            if tbl2.connection1 then
                tbl2.connection1:Disconnect()
                tbl2.connection1 = nil
            end
            task.spawn(function()
                local controls4 = arg78:WaitForChild("Controls", 5)
                local var355 = controls4 and controls4:WaitForChild("crouch", 5)
                if var355 and var355:IsA("GuiButton") and tbl.flag77 then
                    BuildGenBoostGui(var355)
                end
            end)
        end
    end)
end
fn5("KillerWarn", 0.1, function()
    if not tbl.flag74 then
        local character4 = localPlayer.Character
        local var356 = character4 and character4:FindFirstChild("HumanoidRootPart")
        if var356 then
            local killerWarn = var356:FindFirstChild("KillerWarn")
            if killerWarn then
                killerWarn:Destroy()
            end
        end
        return
    end
    local character5 = localPlayer.Character
    local var357 = character5 and character5:FindFirstChild("HumanoidRootPart")
    if not var357 then
        return
    end
    local huge4 = math.huge
    for player, _ in pairs(tbl2.espObjects) do
        if player and player.Parent then
            local var358 = fn9(player)
            if var358 == "killer" then
                local char = player.Character
                local var359 = char and char:FindFirstChild("HumanoidRootPart")
                if var359 then
                    local dist = (var359.Position - var357.Position).Magnitude
                    if dist < huge4 then
                        huge4 = dist
                    end
                end
            end
        end
    end
    local killerWarn2 = var357:FindFirstChild("KillerWarn")
    if huge4 <= tbl.warnDist1 then
        local var360, col
        if huge4 <= tbl.warnDist3 then
            var360 = "!!!"
            col = Color3.fromRGB(255, 0, 0)
        elseif huge4 <= tbl.warnDist2 then
            var360 = "!!"
            col = Color3.fromRGB(255, 80, 0)
        else
            var360 = "!"
            col = Color3.fromRGB(255, 160, 0)
        end
        if not killerWarn2 then
            killerWarn2 = CreateBillboardTag(var360, col, UDim2.new(0, 40, 0, 40), 22)
            killerWarn2.Name = "KillerWarn"
            killerWarn2.Parent = var357
        else
            killerWarn2.Label.Text = var360
            killerWarn2.Label.TextColor3 = col
        end
    elseif killerWarn2 then
        killerWarn2:Destroy()
    end
end)
local var361, StopStunTimer
do
    local tbl22 = {StunAnimation = true, WallHitStun = true, WallHitStun2 = true, WipeMachete = true, Parried = true}
    local tbl23 = {
        stunnedvm = "rbxassetid://108650759135855",
        parriedvm = "rbxassetid://87457855797515",
        wallhitvm = "rbxassetid://109632692854327",
        wipevm = "rbxassetid://71906161598748",
    }
    local color32 = Color3.fromRGB(255, 220, 60)
    tbl2.stunTimerPulse = 0
    local function fn78()
        if tbl2.stunTimerLens.stunnedvm then
            return true
        end
        local var362 = nil
        pcall(function()
            local char = localPlayer.Character
            local var363 = char and char:FindFirstChildOfClass("Humanoid")
            if var363 then
                var362 = var363:FindFirstChildOfClass("Animator")
            end
        end)
        if not var362 then
            return false
        end
        for k2, v51 in pairs(tbl23) do
            if not tbl2.stunTimerLens[k2] then
                pcall(function()
                    local animation2 = Instance.new("Animation")
                    animation2.AnimationId = v51
                    local var364 = var362:LoadAnimation(animation2)
                    if var364 and var364.Length and var364.Length > 0 then
                        tbl2.stunTimerLens[k2] = var364.Length
                    end
                    pcall(function()
                        animation2:Destroy()
                    end)
                end)
            end
        end
        return tbl2.stunTimerLens.stunnedvm ~= nil
    end
    local function fn79()
        task.spawn(function()
            for _ = 1, 5 do
                if not tbl2.flag153 then
                    return
                end
                local flag10 = false
                pcall(function()
                    flag10 = fn78()
                end)
                if flag10 then
                    return
                end
                task.wait(2)
            end
        end)
    end
    local function fn80(dur)
        if not dur or dur <= 0 then
            return
        end
        local var365 = tick() + dur
        for _, v52 in ipairs(Players:GetPlayers()) do
            if v52 ~= localPlayer and v52.Parent and fn9(v52) == "killer" then
                local cur = tbl2.stunTimerForced[v52]
                if not cur or cur < var365 then
                    tbl2.stunTimerForced[v52] = var365
                end
            end
        end
    end
    local function fn81(player)
        local var366 = tbl2.stunTimerBoards[player]
        if var366 then
            pcall(function()
                var366:Destroy()
            end)
        end
        tbl2.stunTimerBoards[player] = nil
        tbl2.stunTimerForced[player] = nil
        tbl2.stunTimerAnim[player] = nil
    end
    local function fn82()
        local tbl24 = {}
        for player, _ in pairs(tbl2.stunTimerBoards) do
            tbl24[#tbl24 + 1] = player
        end
        for i16 = 1, #tbl24 do
            fn81(tbl24[i16])
        end
        for player, _ in pairs(tbl2.stunTimerForced) do
            tbl2.stunTimerForced[player] = nil
        end
        tbl2.stunTimerPulse = 0
    end
    local function fn83(player, char)
        local var367 = tbl2.stunTimerAnim[player]
        if var367 and var367.Parent then
            return var367
        end
        var367 = nil
        pcall(function()
            local humanoid6 = char:FindFirstChildOfClass("Humanoid")
            if humanoid6 then
                var367 = humanoid6:FindFirstChildOfClass("Animator")
            end
        end)
        tbl2.stunTimerAnim[player] = var367
        return var367
    end
    local function fn84(player, char)
        local var368 = fn83(player, char)
        if not var368 then
            return 0
        end
        local var369, var370 = pcall(function()
            return var368:GetPlayingAnimationTracks()
        end)
        if not var369 or type(var370) ~= "table" then
            return 0
        end
        local num16 = 0
        for i17 = 1, #var370 do
            local var371 = var370[i17]
            local nm = nil
            local num17 = 1
            local flag11, num18, pos = false, 0, 0
            pcall(function()
                nm = var371.Name
                local animation3 = var371.Animation
                if animation3 then
                    if not tbl22[nm] and animation3.Name and tbl22[animation3.Name] then
                        nm = animation3.Name
                    end
                    if not tbl22[nm] and animation3.AnimationId then
                        local id = tostring(animation3.AnimationId)
                        for _, v53 in pairs(tbl23) do
                            if id == v53 or id:find(v53:match("%d+"), 1, true) then
                                nm = "__vmid__"
                                break
                            end
                        end
                    end
                end
                flag11 = var371.IsPlaying
                num18 = var371.Length or 0
                pos = var371.TimePosition or 0
                num17 = var371.Speed or 1
            end)
            if nm and (tbl22[nm] or nm == "__vmid__") and flag11 then
                if num17 == 0 then
                    num17 = 1
                end
                local var372 = (num18 - pos) / math.abs(num17)
                if var372 > num16 then
                    num16 = var372
                end
            end
        end
        return num16
    end
    local function fn85(player, arg79)
        local var373 = tbl2.stunTimerBoards[player]
        if var373 and var373.Parent and var373.Adornee and var373.Adornee.Parent then
            if var373.Adornee ~= arg79 then
                pcall(function()
                    var373.Adornee = arg79
                end)
            end
            return var373
        end
        if var373 then
            pcall(function()
                var373:Destroy()
            end)
        end
        var373 = CreateBillboardTag("Stun 0.0s", color32, UDim2.new(0, 110, 0, 30), 18)
        var373.Name = "StunTimer"
        pcall(function()
            var373.MaxDistance = tbl2.num155
        end)
        pcall(function()
            var373.Adornee = arg79
            var373.Parent = arg79
            var373:SetAttribute("__t", "")
        end)
        tbl2.stunTimerBoards[player] = var373
        return var373
    end
    local function fn86()
        if tbl2.flag154 then
            return
        end
        tbl2.flag154 = true
        pcall(function()
            local remotes8 = ReplicatedStorage:FindFirstChild("Remotes")
            if not remotes8 then
                return
            end
            local pallet = remotes8:FindFirstChild("Pallet")
            local var375 = pallet and pallet:FindFirstChild("Jason")
            local var376 = var375 and var375:FindFirstChild("Stun")
            if var376 and var376:IsA("RemoteEvent") then
                table.insert(tbl2.stunTimerConns, var376.OnClientEvent:Connect(function()
                    if tbl2.flag153 then
                        tbl2.stunTimerPulse = tick()
                        if not tbl2.stunTimerLens.stunnedvm then
                            fn79()
                        end
                        fn80(tbl2.stunTimerLens.stunnedvm or 2.5)
                    end
                end))
            end
            local var377 = var375 and var375:FindFirstChild("Stunover")
            if var377 and var377:IsA("RemoteEvent") then
                table.insert(tbl2.stunTimerConns, var377.OnClientEvent:Connect(function()
                    if tbl2.flag153 then
                        for player, _ in pairs(tbl2.stunTimerForced) do
                            tbl2.stunTimerForced[player] = nil
                        end
                        fn82()
                    end
                end))
            end
            local attacks = remotes8:FindFirstChild("Attacks")
            local var378 = attacks and attacks:FindFirstChild("AfterAttack")
            if var378 and var378:IsA("RemoteEvent") then
                table.insert(tbl2.stunTimerConns, var378.OnClientEvent:Connect(function(atkType)
                    if not tbl2.flag153 then
                        return
                    end
                    if atkType == "Parried" then
                        for _, v54 in ipairs(Players:GetPlayers()) do
                            if v54 ~= localPlayer and v54.Parent and fn9(v54) == "killer" then
                                tbl2.stunTimerForced[v54] = tick() + 4
                            end
                        end
                    elseif atkType == "WallHitStun" or atkType == "WallHitStun2" then
                        tbl2.stunTimerPulse = tick()
                        if not tbl2.stunTimerLens.wallhitvm then
                            fn79()
                        end
                        fn80(tbl2.stunTimerLens.wallhitvm or 2.5)
                    elseif atkType == "WipeMachete" then
                        tbl2.stunTimerPulse = tick()
                        if not tbl2.stunTimerLens.wipevm then
                            fn79()
                        end
                        fn80(tbl2.stunTimerLens.wipevm or 2.5)
                    end
                end))
            end
            local killers = remotes8:FindFirstChild("Killers")
            local var379 = killers and killers:FindFirstChild("Hidden")
            local var380 = var379 and var379:FindFirstChild("endlag")
            if var380 and var380:IsA("BindableEvent") then
                table.insert(tbl2.stunTimerConns, var380.Event:Connect(function()
                    if tbl2.flag153 then
                        tbl2.stunTimerPulse = tick()
                        if not tbl2.stunTimerLens.wipevm then
                            fn79()
                        end
                        fn80(tbl2.stunTimerLens.wipevm or 2.5)
                    end
                end))
            end
            local game2 = remotes8:FindFirstChild("Game")
            local var381 = game2 and game2:FindFirstChild("PlayerActionEvent")
            if var381 and var381:IsA("RemoteEvent") then
                table.insert(tbl2.stunTimerConns, var381.OnClientEvent:Connect(function(message)
                    if tbl2.flag153 and message == "Stunned the Killer" then
                        tbl2.stunTimerPulse = tick()
                        if not tbl2.stunTimerLens.stunnedvm then
                            fn79()
                        end
                        fn80(tbl2.stunTimerLens.stunnedvm or 2.5)
                    end
                end))
            end
        end)
    end
    function var361()
        tbl2.flag153 = true
        fn86()
        fn79()
    end
    function StopStunTimer()
        tbl2.flag153 = false
        fn82()
    end
    fn5("StunTimer", 0.1, function()
        if not tbl2.flag153 then
            if next(tbl2.stunTimerBoards) ~= nil then
                fn82()
            end
            return
        end
        local character6 = localPlayer.Character
        local var382 = character6 and character6:FindFirstChild("HumanoidRootPart")
        local var383 = nil
        if var382 then
            var383 = var382.Position
        else
            local currentCamera7 = workspace.CurrentCamera
            if currentCamera7 then
                var383 = currentCamera7.CFrame.Position
            end
        end
        if not var383 then
            return
        end
        local now5 = tick()
        local var384 = tbl2.num155
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Parent and fn9(player) == "killer" then
                local char = player.Character
                local var385 = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
                if char and char.Parent and var385 and var385.Parent then
                    local dist = (var385.Position - var383).Magnitude
                    if dist <= var384 then
                        local num19 = 0
                        local var386 = tbl2.stunTimerForced[player]
                        if var386 and var386 > now5 then
                            num19 = var386 - now5
                        end
                        local var387 = fn84(player, char)
                        if var387 > num19 then
                            num19 = var387
                        end
                        if num19 > 0.05 then
                            local var388 = fn85(player, var385)
                            if var388 then
                                if not var388.Enabled then
                                    var388.Enabled = true
                                end
                                local var389 = string.format("Stun %.1fs", num19)
                                local var390 = var388:GetAttribute("__t")
                                if var390 ~= var389 then
                                    var388:SetAttribute("__t", var389)
                                    local label3 = var388:FindFirstChild("Label")
                                    if label3 then
                                        label3.Text = var389
                                    end
                                end
                            end
                        else
                            if now5 - (tbl2.stunTimerPulse or 0) > 0.35 then
                                fn81(player)
                            end
                        end
                    else
                        local var391 = tbl2.stunTimerBoards[player]
                        if var391 and var391.Enabled then
                            var391.Enabled = false
                        end
                    end
                else
                    fn81(player)
                end
            end
        end
        local var392 = nil
        for player, _ in pairs(tbl2.stunTimerBoards) do
            if not player.Parent then
                var392 = var392 or {}
                var392[#var392 + 1] = player
            end
        end
        if var392 then
            for i18 = 1, #var392 do
                fn81(var392[i18])
            end
        end
    end)
end
fn5("ESPValidator", 1, function()
    if not folder or not folder.Parent then
        ForceRefreshAllESP()
        return
    end
    for player, _ in pairs(tbl2.espObjects) do
        ValidateAndReattachESP(player)
    end
    for player, _ in pairs(tbl2.outlineObjects) do
        if not tbl2.espObjects[player] then
            ValidateAndReattachESP(player)
        end
    end
end)
fn5("EspDistCull", 0.25, function()
    if tbl2.espObjects then
        var197()
    end
end)
fn5("ItemESP", 0.2, function()
    if not tbl.flag97 then
        for _, v55 in pairs(tbl2.espObjects) do
            if v55 and v55.itemImage and v55.itemImage.Visible then
                v55.itemImage.Visible = false
            end
        end
        return
    end
    local character7 = localPlayer.Character
    local var393 = character7 and character7:FindFirstChild("HumanoidRootPart")
    for player, v56 in pairs(tbl2.espObjects) do
        if v56 and v56.billboard and v56.billboard.Parent and v56.itemBillboard then
            if fn9(player) == "killer" then
                if v56.itemImage.Visible then
                    v56.itemImage.Visible = false
                end
                continue
            end
            local char = player.Character
            local var394 = nil
            if char then
                local var395 = char:GetAttribute("EquippedItem") or char:GetAttribute("Equippedltem")
                if type(var395) == "string" then
                    var394 = var395
                elseif typeof(var395) == "Instance" then
                    var394 = var395.Name
                end
            end
            if not var394 then
                local var396 = player:GetAttribute("EquippedItem") or player:GetAttribute("Equippedltem")
                if type(var396) == "string" then
                    var394 = var396
                elseif typeof(var396) == "Instance" then
                    var394 = var396.Name
                end
            end
            local var397 = fn3(var394)
            if var397 then
                if v56.itemImage.Image ~= var397 then
                    v56.itemImage.Image = var397
                end
                if var393 and char then
                    local humanoidRootPart7 = char:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart7 then
                        local dist = (var393.Position - humanoidRootPart7.Position).Magnitude
                        local size = 1.5 + dist / 200 * 2
                        size = math.clamp(size, 1.5, 3.5)
                        v56.itemBillboard.Size = UDim2.new(size, 0, size, 0)
                    end
                end
                v56.itemImage.Visible = true
            else
                if v56.itemImage.Visible then
                    v56.itemImage.Visible = false
                end
            end
        elseif v56 and v56.itemImage then
            if v56.itemImage.Visible then
                v56.itemImage.Visible = false
            end
        end
    end
end)
local var398, GetScpModelRoot, RefreshZombieCache, RefreshScpEsp
local var399, zombieCacheTime
do
    local function fn87(name)
        if type(name) ~= "string" or name == "" then
            return false
        end
        local var400 = name:lower()
        if var400:find("zombie") then
            return true
        end
        if var400 == "scp" then
            return true
        end
        for i19 = 1, 9 do
            if var400 == "scp" .. i19 or var400:find("^scp%-" .. i19) then
                return true
            end
        end
        return false
    end
    function var398(model)
        local var401 = tbl2.scpEspObjects[model]
        if var401 then
            if var401.highlight and var401.highlight.Parent then
                var401.highlight:Destroy()
            end
            if var401.billboard and var401.billboard.Parent then
                var401.billboard:Destroy()
            end
            tbl2.scpEspObjects[model] = nil
        end
    end
    local function fn88(model)
        local highlight2 = Instance.new("Highlight")
        highlight2.Name = "__BolongScpHl__"
        highlight2.Adornee = model
        highlight2.FillColor = tbl.color38
        highlight2.OutlineColor = tbl.color38
        highlight2.FillTransparency = 1
        highlight2.OutlineTransparency = 0
        highlight2.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight2.Enabled = true
        highlight2.Parent = fn4()
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "__BolongScpBb__"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 140, 0, 18)
        billboard.StudsOffset = Vector3.new(0, 4, 0)
        billboard.MaxDistance = tbl.num114
        billboard.Parent = fn4()
        local textLabel3 = Instance.new("TextLabel")
        textLabel3.Size = UDim2.new(1, 0, 1, 0)
        textLabel3.BackgroundTransparency = 1
        textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel3.TextStrokeTransparency = 0
        textLabel3.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel3.TextSize = 12
        textLabel3.Font = Enum.Font.GothamBold
        textLabel3.Text = tbl.flag70 and "zombie" or ""
        textLabel3.Parent = billboard
        tbl2.scpEspObjects[model] = {highlight = highlight2, billboard = billboard, label = textLabel3}
    end
    function GetScpModelRoot(model)
        local primaryPart = model.PrimaryPart
        if not primaryPart then
            local humanoidRootPart8 = model:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart8 and humanoidRootPart8:IsA("BasePart") then
                primaryPart = humanoidRootPart8
            end
        end
        if not primaryPart then
            for _, v57 in ipairs(model:GetChildren()) do
                if v57:IsA("BasePart") then
                    primaryPart = v57
                    break
                end
            end
        end
        return primaryPart
    end
    var399 = {}
    zombieCacheTime = 0
    local function fn89()
        if tbl2._zombieCacheReady then
            return
        end
        tbl2._zombieCacheReady = true
        local tbl25 = {}
        local function onDescendantAdded4(model)
            if not model:IsA("Model") then
                return
            end
            if localPlayer.Character and model == localPlayer.Character then
                return
            end
            for _, v58 in ipairs(Players:GetPlayers()) do
                if v58.Character and model == v58.Character then
                    return
                end
            end
            if not fn87(model.Name) then
                return
            end
            if tbl25[model] then
                return
            end
            tbl25[model] = true
            table.insert(var399, model)
            if tbl.flag69 and not tbl2.scpEspObjects[model] then
                fn88(model)
            end
        end
        local function onDescendantRemoving2(model)
            if not tbl25[model] then
                return
            end
            tbl25[model] = nil
            for i20, v59 in ipairs(var399) do
                if v59 == model then
                    table.remove(var399, i20)
                    break
                end
            end
            var398(model)
        end
        Workspace.DescendantAdded:Connect(onDescendantAdded4)
        Workspace.DescendantRemoving:Connect(onDescendantRemoving2)
        local tbl26 = {}
        for _, v60 in ipairs(Players:GetPlayers()) do
            if v60.Character then
                tbl26[v60.Character] = true
            end
        end
        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and not tbl26[model] and fn87(model.Name) then
                tbl25[model] = true
                table.insert(var399, model)
            end
        end
        zombieCacheTime = tick()
    end
    function RefreshZombieCache()
        fn89()
        zombieCacheTime = tick()
    end
    fn89()
    function RefreshScpEsp()
        if not tbl2.scpEspObjects then
            return
        end
        local var402 = GetCamPosition()
        local tbl27 = {}
        for model, v61 in pairs(tbl2.scpEspObjects) do
            if not model or not model.Parent then
                tbl27[#tbl27 + 1] = model
            else
                local flag12 = true
                if var402 then
                    local var403 = GetScpModelRoot(model)
                    if var403 then
                        flag12 = (var403.Position - var402).Magnitude <= tbl.num114
                    end
                end
                if v61.highlight and v61.highlight.Parent then
                    if v61.highlight.FillColor ~= tbl.color38 then
                        v61.highlight.FillColor = tbl.color38
                        v61.highlight.OutlineColor = tbl.color38
                    end
                    if v61.highlight.Enabled ~= flag12 then
                        v61.highlight.Enabled = flag12
                    end
                end
                if v61.billboard then
                    v61.billboard.MaxDistance = tbl.num114
                    if v61.billboard.Enabled ~= flag12 then
                        v61.billboard.Enabled = flag12
                    end
                    if v61.label then
                        local var404 = tbl.flag70 and "zombie" or ""
                        if v61.label.Text ~= var404 then
                            v61.label.Text = var404
                        end
                    end
                end
            end
        end
        for i21 = 1, #tbl27 do
            var398(tbl27[i21])
        end
    end
    fn5("ScpESP", 0.5, function()
        if not tbl.flag69 then
            for model, _ in pairs(tbl2.scpEspObjects) do
                var398(model)
            end
            return
        end
        local tbl28 = {}
        for model, _ in pairs(tbl2.scpEspObjects) do
            if not model or not model.Parent then
                tbl28[#tbl28 + 1] = model
            end
        end
        for i22 = 1, #tbl28 do
            var398(tbl28[i22])
        end
        for i23 = 1, #var399 do
            local model = var399[i23]
            if model and model.Parent and not tbl2.scpEspObjects[model] then
                fn88(model)
            end
        end
        RefreshScpEsp()
    end)
end
local var406
do
    local function fn90()
        if not tbl2.SpeedBoost then
            return
        end
        local char = localPlayer.Character
        if not char then
            return
        end
        local humanoid7 = char:FindFirstChildOfClass("Humanoid")
        if not humanoid7 then
            return
        end
        if tbl2.safeModeSpeed and (char:GetAttribute("IsHooked") or char:GetAttribute("IsCarried") or humanoid7.Health <= 50) then
            return
        end
        if tbl2.safeModeSpeed and (var278() or IsPlayerDoingAction()) then
            return
        end
        if tbl2.flag113 and char:GetAttribute("Crouching") then
            return
        end
        local var407 = var300()
        if var407 <= 0 then
            return
        end
        local var408 = math.clamp(tonumber(tbl2.num127) or 0.3, 0, 2)
        local var409 = num7 * var408
        tbl2._jitterFlip = not tbl2._jitterFlip
        local target = tbl2._jitterFlip and var407 + var409 or var407
        if math.abs(humanoid7.WalkSpeed - target) > 0.1 then
            pcall(function()
                humanoid7.WalkSpeed = target
            end)
        end
    end
    fn5("SpeedBoost", 0, function()
        fn90()
    end)
    function var406(arg80)
        tbl2.SpeedBoost = arg80 and true or false
        local char = localPlayer.Character
        local var410 = char and char:FindFirstChildOfClass("Humanoid")
        if not arg80 then
            if var410 then
                _ApplySpeed(var410, num7)
            end
            return
        end
        if var410 then
            fn90()
        end
    end
    tbl2.SB_Retarget = function()
        fn90()
    end
    tbl2.SB_RefreshAll = function()
        fn90()
    end
end
local var411
do
    local tbl29 = {}
    local tbl30 = {}
    local tbl31 = {}
    local flag13 = false
    local function fn91(model, value)
        if not model or not model.Parent then
            return
        end
        local speedboost = model:FindFirstChild("speedboost")
        if speedboost and speedboost:IsA("ValueBase") then
            speedboost.Value = value
            return
        end
        model:SetAttribute("speedboost", value)
    end
    local function fn92()
        local team = localPlayer.Team
        local var412 = team and team.Name
        local var413 = tbl2.str16 or "Both"
        if var413 == "Both" then
            return var412 == "Survivors" or var412 == "Killer"
        end
        return var412 == var413
    end
    local function fn93(model)
        if not model or not model.Parent then
            return
        end
        local var414 = tbl29[model] or 1
        local var415
        if tbl2.flag114 and fn92() then
            local var416 = math.clamp(tonumber(tbl2.num128) or 1.3, 1, 3)
            if tbl2.flag115 then
                var415 = var414 + (var416 - 1)
            else
                var415 = var416
            end
        else
            if tbl2.flag115 then
                var415 = var414
            else
                var415 = 1
            end
        end
        tbl30[model] = var415
        fn91(model, var415)
    end
    local function fn94(model)
        if tbl31[model] then
            return
        end
        local var417 = model:GetAttribute("speedboost") or 1
        tbl29[model] = var417
        tbl30[model] = var417
        tbl31[model] = model.AttributeChanged:Connect(function(attrName)
            if attrName ~= "speedboost" then
                return
            end
            local var418 = model:GetAttribute("speedboost") or 1
            local var419 = tbl30[model]
            if var419 and math.abs(var418 - var419) < 0.001 then
                return
            end
            tbl29[model] = var418
            pcall(function()
                fn93(model)
            end)
        end)
    end
    local function fn95()
        if tbl2.flag114 and not fn92() then
            if not flag13 then
                flag13 = true
                fn2("Speed Boost V2", "Hanya work di dalam match, tidak work di lobby", 2)
            end
        else
            flag13 = false
        end
        local name2 = localPlayer.Name
        if not name2 then
            return
        end
        local tbl32 = {}
        if localPlayer.Character then
            table.insert(tbl32, localPlayer.Character)
        end
        local var420 = Workspace:FindFirstChild(name2)
        if var420 and var420:IsA("Model") and not table.find(tbl32, var420) then
            table.insert(tbl32, var420)
        end
        local tbl33 = {"climb_obsessing", "climb_collisoning", "climb_collisioning", "climb_colliding"}
        for _, v62 in ipairs(tbl33) do
            local var421 = Workspace:FindFirstChild(v62)
            local model = var421 and var421:FindFirstChild(name2)
            if model and model:IsA("Model") and not table.find(tbl32, model) then
                table.insert(tbl32, model)
            end
        end
        for model, v63 in pairs(tbl31) do
            if not model or not model.Parent then
                pcall(function()
                    v63:Disconnect()
                end)
                tbl31[model] = nil
                tbl29[model] = nil
                tbl30[model] = nil
            end
        end
        for _, model in ipairs(tbl32) do
            fn94(model)
            fn93(model)
        end
    end
    fn5("SpeedBoostV2", 0.35, function()
        if tbl2.flag114 or next(tbl31) ~= nil then
            fn95()
        end
    end)
    function var411(arg81)
        arg81 = arg81 and true or false
        if arg81 and tbl2.SpeedBoost and var406 then
            var406(false)
            if tbl2.SB_SyncToggle then
                pcall(tbl2.SB_SyncToggle, false)
            end
        end
        tbl2.flag114 = arg81
        if not arg81 then
            for model, v64 in pairs(tbl29) do
                if model and model.Parent then
                    tbl30[model] = v64
                    fn91(model, v64)
                end
            end
        end
        fn95()
    end
    tbl2.SB2_Refresh = function()
        fn95()
    end
end
do
    local function fn96(arg82, pos)
        if not arg82 or not arg82.Parent then
            return false
        end
        local absolutePosition2 = arg82.AbsolutePosition
        local as = arg82.AbsoluteSize
        local cx = absolutePosition2.X + as.X / 2
        local var422 = absolutePosition2.Y + as.Y / 2
        local var423 = math.min(as.X, as.Y) / 2 * 0.8
        local dx = pos.X - cx
        local dy = pos.Y - var422
        return dx * dx + dy * dy <= var423 * var423
    end
    local function fn97(arg83)
        if not arg83:IsA("ImageButton") then
            return
        end
        if arg83.Name ~= "Gui-mob" then
            return
        end
        if tbl2._hookedMobButtons[arg83] then
            return
        end
        tbl2._hookedMobButtons[arg83] = true
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            if not fn96(arg83, input.Position) then
                return
            end
            tbl2.flag121 = true
            local var424
            var424 = UserInputService.InputEnded:Connect(function(ended)
                if ended == input then
                    tbl2.flag121 = false
                    var424:Disconnect()
                end
            end)
        end)
    end
    local tbl34 = {["Slasher-mob"] = true, ["Masked-mob"] = true, ["Hidden-mob"] = true, ["Killer-mob"] = true}
    local function fn98(arg84)
        if not (arg84 and arg84:IsA("GuiButton")) then
            return false
        end
        if arg84.Name ~= "attack" then
            return false
        end
        local flag14, hasControl = false, false
        local parent4 = arg84.Parent
        while parent4 do
            if tbl34[parent4.Name] then
                flag14 = true
            end
            if parent4.Name == "Controls" or parent4.Name == "Control" then
                hasControl = true
            end
            parent4 = parent4.Parent
        end
        return flag14 and hasControl
    end
    local function fn99(arg85)
        if tbl2._hookedSlasherButtons[arg85] then
            return
        end
        tbl2._hookedSlasherButtons[arg85] = true
        arg85.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                tbl2.flag121 = true
            end
        end)
        arg85.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                tbl2.flag121 = false
            end
        end)
    end
    local function fn100(arg86)
        local function fn101(arg87)
            if not arg87 then
                return
            end
            local guiMob = arg87:FindFirstChild("Gui-mob", true)
            if guiMob and guiMob:IsA("ImageButton") then
                fn97(guiMob)
            end
            local var426 = arg87:FindFirstChild("Control") or arg87:FindFirstChild("Controls")
            if var426 then
                local function fn102(arg88)
                    for _, v65 in ipairs(arg88:GetChildren()) do
                        if fn98(v65) then
                            fn99(v65)
                        end
                        fn102(v65)
                    end
                end
                fn102(var426)
            end
        end
        for k3, _ in pairs(tbl34) do
            fn101(arg86:FindFirstChild(k3))
        end
        arg86.DescendantAdded:Connect(function(arg89)
            if arg89:IsA("ImageButton") and arg89.Name == "Gui-mob" then
                fn97(arg89)
            end
            if fn98(arg89) then
                fn99(arg89)
            end
        end)
    end
    task.spawn(function()
        local playerGui7 = localPlayer:WaitForChild("PlayerGui")
        fn100(playerGui7)
    end)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        local isKiller = fn9(localPlayer) == "killer"
        if isKiller then
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                tbl2.flag121 = true
            end
        else
            if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton2 then
                tbl2.flag121 = true
            end
        end
        if not gameProcessed and input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonL2 then
            tbl2.flag121 = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
            tbl2.flag121 = false
        end
        if input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonL2 then
            tbl2.flag121 = false
        end
    end)
    fn5("HoldLock", 0.2, function()
        if not tbl.flag79 then
            return
        end
        if tbl2.flag121 then
            return
        end
        local char = localPlayer.Character
        if char and char:GetAttribute("Aiming") == true then
            tbl2.flag121 = true
        end
    end)
end
local var427, StopCameralock
do
    local function fn103(char)
        if not char then
            return nil
        end
        if tbl.str13 == "Head" then
            local head2 = char:FindFirstChild("Head")
            if head2 then
                return head2.Position
            end
        end
        local upperTorso2 = char:FindFirstChild("UpperTorso")
        if upperTorso2 then
            return upperTorso2.Position
        end
        local torso = char:FindFirstChild("Torso")
        if torso then
            return torso.Position
        end
        local humanoidRootPart9 = char:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart9 then
            return humanoidRootPart9.Position + (tbl.str13 == "Head" and Vector3.new(0, 2.5, 0) or Vector3.new(0, 1.2, 0))
        end
        return nil
    end
    local function fn104(player, char, arg90)
        if not char or not arg90 or arg90.Health <= 0 then
            return false
        end
        if arg90.Health < 50 then
            return false
        end
        if char:GetAttribute("IsHooked") then
            return false
        end
        if char:GetAttribute("IsCarried") then
            return false
        end
        if player:GetAttribute("IsHooked") then
            return false
        end
        if player:GetAttribute("IsCarried") then
            return false
        end
        local var430 = arg90:GetState()
        if var430 == Enum.HumanoidStateType.PlatformStanding then
            return false
        end
        if var430 == Enum.HumanoidStateType.Physics and arg90.PlatformStand then
            return false
        end
        local humanoidRootPart10 = char:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart10 and humanoidRootPart10.Anchored then
            return false
        end
        return true
    end
    local function fn105(currentTarget)
        local character8 = localPlayer.Character
        local var431 = character8 and character8:FindFirstChild("HumanoidRootPart")
        if not var431 then
            return nil
        end
        local position4 = var431.Position
        local num20 = 0.1
        local var432 = nil
        local var433 = tbl.num118
        if tbl.str11 == "Zombie" then
            if currentTarget and typeof(currentTarget) == "Instance" and not currentTarget:IsA("Player") then
                local var434 = GetScpModelRoot(currentTarget)
                if var434 and var434:IsA("BasePart") and currentTarget.Parent then
                    local dist = (var434.Position - position4).Magnitude
                    if dist <= tbl.num118 then
                        var432 = currentTarget
                        var433 = dist - num20
                    end
                end
            end
            if tick() - zombieCacheTime > 0.5 then
                RefreshZombieCache()
            end
            for i24 = 1, #var399 do
                local model = var399[i24]
                if model and model.Parent then
                    local var435 = GetScpModelRoot(model)
                    if var435 and var435:IsA("BasePart") then
                        local dist = (var435.Position - position4).Magnitude
                        if dist < var433 then
                            var433 = dist
                            var432 = model
                        end
                    end
                end
            end
            return var432
        end
        if currentTarget and currentTarget.Character then
            local character9 = currentTarget.Character
            local humanoid8 = character9:FindFirstChildOfClass("Humanoid")
            local var436 = fn103(character9)
            local flag15 = true
            if tbl.str11 == "Killer" and fn9(currentTarget) ~= "killer" then
                flag15 = false
            elseif tbl.str11 == "Survivor" and fn9(currentTarget) ~= "survivor" then
                flag15 = false
            end
            if flag15 and fn104(currentTarget, character9, humanoid8) and var436 then
                local magnitude4 = (var436 - position4).Magnitude
                if magnitude4 <= tbl.num118 then
                    var432 = currentTarget
                    var433 = magnitude4 - num20
                end
            end
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player == localPlayer then
                continue
            end
            local char = player.Character
            if not char then
                continue
            end
            local humanoid9 = char:FindFirstChildOfClass("Humanoid")
            if not fn104(player, char, humanoid9) then
                continue
            end
            local var437 = fn103(char)
            if not var437 then
                continue
            end
            local var438 = fn9(player)
            if tbl.str11 == "Killer" and var438 ~= "killer" then
                continue
            end
            if tbl.str11 == "Survivor" and var438 ~= "survivor" then
                continue
            end
            local dist = (var437 - position4).Magnitude
            if dist < var433 then
                var433 = dist
                var432 = player
            end
        end
        return var432
    end
    function var427()
        if tbl2.connection20 then
            tbl2.connection20:Disconnect()
        end
        tbl2.field28 = nil
        tbl2.num147 = 0
        tbl2.field29 = nil
        tbl2.connection20 = RunService.RenderStepped:Connect(function(arg91)
            if not tbl.flag79 then
                return
            end
            if tbl.str12 == "Hold to Lock" and not tbl2.flag121 then
                tbl2.field28 = nil
                tbl2.field29 = nil
                return
            end
            local character10 = localPlayer.Character
            if not character10 then
                return
            end
            local humanoidRootPart11 = character10:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart11 then
                return
            end
            tbl2.num147 = tbl2.num147 + arg91
            if tbl2.num147 >= 0.15 then
                tbl2.num147 = 0
                tbl2.field28 = fn105(tbl2.field28)
            end
            local target = tbl2.field28
            if not target then
                tbl2.field29 = nil
                return
            end
            local var439
            if typeof(target) == "Instance" and not target:IsA("Player") then
                local var440 = GetScpModelRoot(target)
                if not var440 or not var440:IsA("BasePart") or not target.Parent then
                    tbl2.field28 = nil
                    tbl2.field29 = nil
                    return
                end
                var439 = var440.Position
            else
                local character11 = target.Character
                if not character11 then
                    tbl2.field28 = nil
                    tbl2.field29 = nil
                    return
                end
                local humanoid10 = character11:FindFirstChildOfClass("Humanoid")
                if not fn104(target, character11, humanoid10) then
                    tbl2.field28 = nil
                    tbl2.field29 = nil
                    return
                end
                var439 = fn103(character11)
            end
            if not var439 then
                tbl2.field28 = nil
                tbl2.field29 = nil
                return
            end
            local currentCamera8 = workspace.CurrentCamera
            if not currentCamera8 then
                return
            end
            local cFrame3 = currentCamera8.CFrame
            local position5 = cFrame3.Position
            local lookVector2 = cFrame3.LookVector
            local var441 = tbl.num119
            local var442 = var439 - position5
            local magnitude5 = var442.Magnitude
            local magnitude6 = (var439 - humanoidRootPart11.Position).Magnitude
            local num21 = 4
            local var443
            if magnitude5 >= num21 and magnitude6 >= 1.5 then
                var443 = var442.Unit
                tbl2.field29 = var443
            elseif tbl2.field29 then
                var443 = tbl2.field29
            else
                var443 = lookVector2
            end
            local var444 = lookVector2:Lerp(var443, var441)
            if var444.Magnitude < 0.001 then
                return
            end
            currentCamera8.CFrame = CFrame.new(position5, position5 + var444)
            local humanoid11 = character10:FindFirstChildOfClass("Humanoid")
            if humanoid11 and not humanoid11.AutoRotate then
                local lookVector3 = currentCamera8.CFrame.LookVector
                local position6 = humanoidRootPart11.Position
                local vector37 = Vector3.new(lookVector3.X, 0, lookVector3.Z)
                if vector37.Magnitude > 0.001 then
                    local var445 = math.atan2(humanoidRootPart11.CFrame.LookVector.X, humanoidRootPart11.CFrame.LookVector.Z)
                    local var446 = math.atan2(vector37.X, vector37.Z)
                    local var447 = var446 - var445
                    var447 = (var447 + math.pi) % (2 * math.pi) - math.pi
                    local var448 = var445 + var447 * 0.15
                    local var449 = math.sin(var448)
                    local var450 = math.cos(var448)
                    local var451 = position6 + Vector3.new(var449, 0, var450) * 900
                    humanoidRootPart11.CFrame = CFrame.new(position6, Vector3.new(var451.X, position6.Y, var451.Z))
                end
            end
        end)
    end
    function StopCameralock()
        if tbl2.connection20 then
            tbl2.connection20:Disconnect()
            tbl2.connection20 = nil
        end
        tbl2.field28 = nil
        tbl2.field29 = nil
    end
end
local function fn106(value)
    if tbl2.cameraMaxZoomDistance1 == nil then
        tbl2.cameraMaxZoomDistance1 = localPlayer.CameraMaxZoomDistance
    end
    localPlayer.CameraMaxZoomDistance = value
end
local function fn107()
    if tbl2.cameraMaxZoomDistance1 ~= nil then
        localPlayer.CameraMaxZoomDistance = tbl2.cameraMaxZoomDistance1
    end
    tbl2.cameraMaxZoomDistance1 = nil
end
local function fn108(char)
    if not char then
        return nil
    end
    local var452, var453 = pcall(function()
        return char:FindFirstChild("SmoothCamera")
    end)
    if var452 and var453 then
        return var453
    end
    return nil
end
local function fn109(value)
    local var454 = fn108(localPlayer.Character)
    if not var454 then
        return false
    end
    if tbl2.origCamStiffness == nil then
        local cur = 8
        pcall(function()
            cur = var454:GetAttribute("CameraStiffness") or 8
        end)
        tbl2.origCamStiffness = cur
    end
    pcall(function()
        var454:SetAttribute("CameraStiffness", value)
    end)
    return true
end
local function fn110()
    if tbl2.origCamStiffness ~= nil then
        local var455 = fn108(localPlayer.Character)
        if var455 then
            pcall(function()
                var455:SetAttribute("CameraStiffness", tbl2.origCamStiffness)
            end)
        end
    end
    tbl2.origCamStiffness = nil
end
do
    localPlayer.CharacterAdded:Connect(function(char)
        task.spawn(function()
            task.wait(1)
            if tbl.flag72 and localPlayer.Character == char then
                fn109(tbl.num115)
            end
        end)
    end)
    fn5("CamStiffness", 0.5, function()
        if not tbl.flag72 then
            return
        end
        local var456 = fn108(localPlayer.Character)
        if not var456 then
            return
        end
        local var457, cur = pcall(function()
            return var456:GetAttribute("CameraStiffness")
        end)
        if var457 and cur ~= tbl.num115 then
            pcall(function()
                var456:SetAttribute("CameraStiffness", tbl.num115)
            end)
        end
    end)
end
local function fn111(value)
    local currentCamera9 = workspace.CurrentCamera
    if not currentCamera9 then
        return
    end
    if tbl2.fieldOfView1 == nil then
        tbl2.fieldOfView1 = currentCamera9.FieldOfView
    end
    currentCamera9.FieldOfView = value
end
local function fn112()
    local currentCamera10 = workspace.CurrentCamera
    if currentCamera10 and tbl2.fieldOfView1 then
        currentCamera10.FieldOfView = tbl2.fieldOfView1
    end
    tbl2.fieldOfView1 = nil
end
do
    localPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
        if tbl.flag71 and localPlayer.CameraMaxZoomDistance ~= tbl.cameraZoomValue then
            localPlayer.CameraMaxZoomDistance = tbl.cameraZoomValue
        end
    end)
    local function fn113()
        local currentCamera11 = workspace.CurrentCamera
        if not currentCamera11 then
            return
        end
        currentCamera11:GetPropertyChangedSignal("FieldOfView"):Connect(function()
            if tbl.flag75 and currentCamera11.FieldOfView ~= tbl.num117 then
                currentCamera11.FieldOfView = tbl.num117
            end
        end)
    end
    fn113()
end
local tbl35 = {m = 1, n = 1}
local function fn114()
    pcall(function()
        RunService:UnbindFromRenderStep("BOLONG_Aspect")
    end)
    tbl35.m, tbl35.n = 1, 1
end
local function fn115()
    fn114()
    tbl35.m, tbl35.n = 1, 1
    pcall(function()
        RunService:UnbindFromRenderStep("BOLONG_Aspect")
        RunService:BindToRenderStep("BOLONG_Aspect", Enum.RenderPriority.Camera.Value + 2, function(arg92)
            if not tbl.flag73 then
                return
            end
            local currentCamera12 = workspace.CurrentCamera
            if not currentCamera12 then
                return
            end
            local viewportSize2 = currentCamera12.ViewportSize
            if viewportSize2.Y < 1 then
                return
            end
            local var458 = viewportSize2.X / viewportSize2.Y
            local var459 = tonumber(tbl.num116) or 1.7777777777777777
            local m, n = 1, 1
            if math.abs(var459 - var458) > 0.03 then
                if var459 < var458 then
                    m = 1
                    n = math.clamp(var459 / var458, 0.1, 1)
                else
                    m = math.clamp(var458 / var459, 0.1, 1)
                    n = 1
                end
            end
            local var460 = math.clamp(arg92 or 0.0167, 0.0005, 0.1)
            local var461 = math.clamp(1 - math.exp(-12 * var460), 0.001, 1)
            tbl35.m = tbl35.m + (m - tbl35.m) * var461
            tbl35.n = tbl35.n + (n - tbl35.n) * var461
            if math.abs(tbl35.m - 1) < 0.002 and math.abs(tbl35.n - 1) < 0.002 then
                tbl35.m, tbl35.n = 1, 1
                return
            end
            local cFrame4 = currentCamera12.CFrame
            local position7 = cFrame4.Position
            if position7.X ~= position7.X or position7.Y ~= position7.Y or position7.Z ~= position7.Z then
                return
            end
            if cFrame4.RightVector.Magnitude < 0.01 or cFrame4.UpVector.Magnitude < 0.01 then
                return
            end
            local cFrame5 = CFrame.fromMatrix(position7, cFrame4.RightVector.Unit, cFrame4.UpVector.Unit)
            currentCamera12.CFrame = cFrame5 * CFrame.new(0, 0, 0, tbl35.m, 0, 0, 0, tbl35.n, 0, 0, 0, 1)
        end)
    end)
end
local function fn116()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return
    end
    tbl2.mouseIconEnabled1 = UserInputService.MouseIconEnabled
    tbl2.mouseBehavior1 = UserInputService.MouseBehavior
    UserInputService.MouseIconEnabled = true
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    if tbl2.connection9 then
        tbl2.connection9:Disconnect()
    end
    if tbl2.connection10 then
        tbl2.connection10:Disconnect()
    end
    tbl2.connection9 = UserInputService:GetPropertyChangedSignal("MouseIconEnabled"):Connect(function()
        if tbl.flag98 and not UserInputService.MouseIconEnabled then
            UserInputService.MouseIconEnabled = true
        end
    end)
    tbl2.connection10 = UserInputService:GetPropertyChangedSignal("MouseBehavior"):Connect(function()
        if tbl.flag98 and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end)
end
local function fn117()
    if tbl2.connection9 then
        tbl2.connection9:Disconnect()
        tbl2.connection9 = nil
    end
    if tbl2.connection10 then
        tbl2.connection10:Disconnect()
        tbl2.connection10 = nil
    end
    if tbl2.mouseIconEnabled1 ~= nil then
        UserInputService.MouseIconEnabled = tbl2.mouseIconEnabled1
        tbl2.mouseIconEnabled1 = nil
    end
    if tbl2.mouseBehavior1 ~= nil then
        UserInputService.MouseBehavior = tbl2.mouseBehavior1
        tbl2.mouseBehavior1 = nil
    end
end
local var462, StopPerfMonitor, StartPrediction, StopPrediction
do
    local function fn118()
        local screenGui3 = Instance.new("ScreenGui")
        screenGui3.Name = "BolongPerfMon"
        screenGui3.ResetOnSpawn = false
        screenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui3.IgnoreGuiInset = false
        screenGui3.DisplayOrder = 50
        pcall(function()
            screenGui3.Parent = gethui and gethui() or game:GetService("CoreGui")
        end)
        if not screenGui3.Parent then
            screenGui3.Parent = playerGui
        end
        local frame5 = Instance.new("Frame")
        frame5.Name = "PerfFrame"
        frame5.Size = UDim2.fromOffset(160, 28)
        frame5.AnchorPoint = Vector2.new(1, 0)
        frame5.Position = UDim2.new(1, -10, 0, 10)
        frame5.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
        frame5.BorderSizePixel = 0
        frame5.Active = true
        frame5.Parent = screenGui3
        local uICorner2 = Instance.new("UICorner")
        uICorner2.CornerRadius = UDim.new(0, 8)
        uICorner2.Parent = frame5
        local uIStroke2 = Instance.new("UIStroke")
        uIStroke2.Color = Color3.fromRGB(60, 60, 75)
        uIStroke2.Thickness = 1
        uIStroke2.Parent = frame5
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Name = "InfoLabel"
        infoLabel.Size = UDim2.new(1, 0, 1, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Text = "FPS — | PING —"
        infoLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
        infoLabel.TextSize = 12
        infoLabel.Font = Enum.Font.GothamBold
        infoLabel.TextXAlignment = Enum.TextXAlignment.Center
        infoLabel.TextYAlignment = Enum.TextYAlignment.Center
        infoLabel.RichText = true
        infoLabel.Parent = frame5
        local var463, var464, var465
        frame5.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                var463 = true
                var464 = input.Position
                var465 = frame5.Position
            end
        end)
        frame5.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                var463 = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if var463 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local var466 = input.Position - var464
                frame5.Position = UDim2.new(1, var465.X.Offset + var466.X, 0, var465.Y.Offset + var466.Y)
            end
        end)
        return screenGui3, infoLabel
    end
    fn5("PerfMonitor", 0.5, function()
        if not tbl2.flag144 then
            return
        end
        local var467 = math.floor(tbl2.num146 / math.max(tbl2.num145, 0.001))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local var468 = var467 >= 50 and "rgb(80,220,100)" or var467 >= 30 and "rgb(255,200,60)" or "rgb(255,70,70)"
        local var469 = ping <= 80 and "rgb(80,220,100)" or ping <= 150 and "rgb(255,200,60)" or "rgb(255,70,70)"
        if not tbl2.field2 or not tbl2.field2.Parent then
            if tbl2.field2 then
                pcall(function()
                    tbl2.field2:Destroy()
                end)
            end
            local var470 = fn118()
            tbl2.field2 = var470
        end
        if tbl2.field2 and tbl2.field2.Parent then
            local label = tbl2.field2:FindFirstChild("PerfFrame"):FindFirstChild("InfoLabel")
            if label then
                label.Text = string.format("<font color=\"%s\">FPS %d</font> <font color=\"rgb(60,60,75)\">|</font> <font color=\"%s\">PING %d</font>", var468, var467, var469, ping)
            end
        end
        tbl2.num145 = 0
        tbl2.num146 = 0
    end)
    fn5("PerfCounter", 0, function(arg93)
        if tbl2.flag144 then
            tbl2.num146 = tbl2.num146 + 1
            tbl2.num145 = tbl2.num145 + arg93
        end
    end)
    function var462()
        if tbl2.field2 then
            tbl2.field2:Destroy()
        end
        local var471, infoLabel = fn118()
        tbl2.field2 = var471
        tbl2.flag144 = true
        tbl2.num145 = 0
        tbl2.num146 = 0
    end
    function StopPerfMonitor()
        tbl2.flag144 = false
        if tbl2.field2 then
            tbl2.field2:Destroy()
            tbl2.field2 = nil
        end
    end
    local function fn119(obj, name)
        if not obj then
            return nil
        end
        local var472 = obj:GetAttribute(name)
        if var472 ~= nil then
            return var472
        end
        local var473 = obj:FindFirstChild(name)
        if var473 then
            local var474, val = pcall(function()
                return var473.Value
            end)
            if var474 then
                return val
            end
        end
        return nil
    end
    local function fn120()
        local screenGui4 = Instance.new("ScreenGui")
        screenGui4.Name = "BolongPrediction"
        screenGui4.ResetOnSpawn = false
        screenGui4.IgnoreGuiInset = true
        screenGui4.DisplayOrder = 51
        screenGui4.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        local var475 = nil
        pcall(function()
            var475 = gethui()
        end)
        if not var475 then
            pcall(function()
                var475 = game:GetService("CoreGui")
            end)
        end
        if not var475 then
            var475 = playerGui
        end
        screenGui4.Parent = var475
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Name = "InfoLabel"
        infoLabel.AnchorPoint = Vector2.new(0.5, 0)
        if tbl2.field32 then
            infoLabel.Position = tbl2.field32
        else
            infoLabel.Position = UDim2.new(0.5, 0, 0, 50)
        end
        infoLabel.BackgroundTransparency = 1
        infoLabel.AutomaticSize = Enum.AutomaticSize.XY
        infoLabel.Text = "Map: — | Killer: —"
        infoLabel.TextColor3 = Color3.fromRGB(252, 235, 229)
        infoLabel.TextSize = 14
        infoLabel.Font = Enum.Font.GothamBold
        infoLabel.TextXAlignment = Enum.TextXAlignment.Center
        infoLabel.TextYAlignment = Enum.TextYAlignment.Center
        infoLabel.RichText = true
        infoLabel.Active = true
        infoLabel.Parent = screenGui4
        local uIStroke3 = Instance.new("UIStroke")
        uIStroke3.Name = "Outline"
        uIStroke3.Color = Color3.new(0, 0, 0)
        uIStroke3.Thickness = 1
        uIStroke3.Transparency = 0.2
        uIStroke3.Parent = infoLabel
        local flag16 = false
        local vector23 = Vector2.new()
        local uDim2 = UDim2.new()
        infoLabel.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                flag16 = true
                vector23 = input.Position
                uDim2 = infoLabel.Position
            end
        end)
        infoLabel.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                flag16 = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if flag16 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local var476 = input.Position - vector23
                local uDim22 = UDim2.new(uDim2.X.Scale, uDim2.X.Offset + var476.X, uDim2.Y.Scale, uDim2.Y.Offset + var476.Y)
                infoLabel.Position = uDim22
                tbl2.field32 = uDim22
            end
        end)
        return screenGui4, infoLabel
    end
    local function fn121()
        if tbl2.connection21 then
            return
        end
        task.spawn(function()
            local var477, remote = pcall(function()
                return ReplicatedStorage:WaitForChild("Remotes", 10):WaitForChild("Messages", 10):WaitForChild("Mapinfo", 10)
            end)
            if var477 and remote and remote:IsA("RemoteEvent") then
                tbl2.connection21 = remote.OnClientEvent:Connect(function(mapName, mapId)
                    if type(mapName) == "string" and mapName ~= "" then
                        tbl2.str18 = mapName
                    end
                end)
            end
        end)
    end
    fn5("PredictionMonitor", 1, function()
        if not tbl2.flag147 then
            return
        end
        if not tbl2.field30 or not tbl2.field30.Parent then
            if tbl2.field30 then
                tbl2.field30:Destroy()
            end
            local var478, infoLabel = fn120()
            tbl2.field30 = var478
            tbl2.field31 = infoLabel
        end
        local infoLabel = tbl2.field30:FindFirstChild("InfoLabel")
        if not infoLabel then
            return
        end
        local players = Players:GetPlayers()
        table.sort(players, function(arg94, arg95)
            local var479 = fn119(arg94, "AllowKiller")
            local var480 = fn119(arg95, "AllowKiller")
            local var481 = var479 == false
            local var482 = var480 == false
            if var481 ~= var482 then
                return not var481
            end
            if not var481 and not var482 then
                return (fn119(arg94, "KillerChance") or 0) > (fn119(arg95, "KillerChance") or 0)
            end
            return (fn119(arg94, "KillerChance") or 0) < (fn119(arg95, "KillerChance") or 0)
        end)
        local var483 = players[1]
        local str4 = "<font color=\"rgb(100,110,130)\">—</font>"
        if var483 then
            local name = var483.Name
            local var484 = fn119(var483, "SelectedKiller")
            local var485 = fn119(var483, "AllowKiller")
            if var483 == localPlayer then
                name = "YOU"
            end
            local var486
            if var485 == false then
                var486 = "rgb(255,0,30)"
            else
                var486 = "rgb(252,235,229)"
            end
            if var484 and type(var484) == "string" and var484 ~= "" then
                str4 = string.format("<font color=\"%s\">%s</font> <font color=\"rgb(255,0,30)\">(%s)</font>", var486, name, var484)
            else
                str4 = string.format("<font color=\"%s\">%s</font>", var486, name)
            end
        end
        local var487 = tbl2.str18 or "—"
        infoLabel.Text = string.format("<font color=\"rgb(255,210,60)\">Map:</font> <font color=\"rgb(252,235,229)\">%s</font>  <font color=\"rgb(80,80,85)\">|</font>  <font color=\"rgb(255,210,60)\">Killer:</font> %s", var487, str4)
    end)
    function StartPrediction()
        if tbl2.field30 then
            tbl2.field30:Destroy()
        end
        tbl2.str18 = nil
        fn121()
        local var488, infoLabel = fn120()
        tbl2.field30 = var488
        tbl2.field31 = infoLabel
        tbl2.flag147 = true
    end
    function StopPrediction()
        tbl2.flag147 = false
        if tbl2.connection21 then
            pcall(function()
                tbl2.connection21:Disconnect()
            end)
            tbl2.connection21 = nil
        end
        if tbl2.field30 then
            tbl2.field30:Destroy()
            tbl2.field30 = nil
        end
    end
end
local var489, StopSpectatorCount
do
    local num22 = 0.001
    local num23 = 2
    local tbl36 = {
        "Head",
        "Torso",
        "UpperTorso",
        "LowerTorso",
        "Left Arm",
        "Right Arm",
        "Left Leg",
        "Right Leg",
        "LeftUpperArm",
        "LeftLowerArm",
        "LeftHand",
        "RightUpperArm",
        "RightLowerArm",
        "RightHand",
        "LeftUpperLeg",
        "RightUpperLeg",
        "LeftFoot",
        "RightFoot",
    }
    local specConns = tbl2.specConns
    local specDetected = tbl2.specDetected
    local specStreamTimes = tbl2.specStreamTimes
    local function fn122()
        local var490, var491 = pcall(function()
            return localPlayer.Team
        end)
        if not var490 or not var491 then
            return false
        end
        local var492, name = pcall(function()
            return var491.Name
        end)
        if not var492 or type(name) ~= "string" then
            return false
        end
        return (name:lower():gsub("%s+", ""):find("spectator", 1, true)) ~= nil
    end
    local function fn123(player)
        if not player or not localPlayer then
            return false
        end
        if player == localPlayer then
            return true
        end
        return player.UserId == localPlayer.UserId
    end
    local function fn124(char)
        if not char or not localPlayer then
            return false
        end
        if char == localPlayer.Character then
            return true
        end
        if Players:GetPlayerFromCharacter(char) == localPlayer then
            return true
        end
        return char:FindFirstChild("Bolong_Invis") ~= nil
    end
    local function fn125(arg96)
        local var493 = specConns[arg96]
        if var493 then
            pcall(function()
                var493:Disconnect()
            end)
            specConns[arg96] = nil
        end
    end
    local function fn126(arg97)
        for key in next, specConns do
            if key:sub(1, #arg97) == arg97 then
                local var494 = specConns[key]
                pcall(function()
                    var494:Disconnect()
                end)
                specConns[key] = nil
            end
        end
    end
    local function fn127(char)
        for _, name in ipairs(tbl36) do
            local part = char:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                local t = part.Transparency
                local localTransparencyModifier = part.LocalTransparencyModifier
                if t > num22 or localTransparencyModifier > num22 then
                    return part, t, localTransparencyModifier
                end
            end
        end
    end
    local function fn128()
        local count = 0
        for key2, value2 in next, specDetected do
            if value2.Player and value2.Player.Parent == Players and not fn123(value2.Player) and not fn124(value2.Character) then
                count = count + 1
            else
                specDetected[key2] = nil
            end
        end
        return count
    end
    local function fn129()
        if not tbl2.field34 or not tbl2.field34.Parent then
            return
        end
        local count = tbl2.flag164 and 0 or fn128()
        local label = tbl2.field34:FindFirstChild("SpecFrame") and tbl2.field34.SpecFrame:FindFirstChild("InfoLabel")
        if label then
            local var495 = count > 0 and "rgb(80,220,100)" or "rgb(150,150,165)"
            label.Text = string.format("<font color=\"%s\">SPECTATORS %d</font>", var495, count)
        end
    end
    local function fn130(player)
        if not tbl2.flag163 or not player or fn123(player) then
            return
        end
        local userId = player.UserId
        local char = player.Character
        if fn122() then
            if specDetected[userId] then
                specDetected[userId] = nil
                fn129()
            end
            return
        end
        if not char or fn124(char) then
            if specDetected[userId] then
                specDetected[userId] = nil
                fn129()
            end
            return
        end
        local part, t, var496 = fn127(char)
        if part then
            if not specDetected[userId] then
                specDetected[userId] = {Player = player, Character = char, Part = part, T = t, field36 = var496}
                fn129()
            else
                local var497 = specDetected[userId]
                var497.Character, var497.Part, var497.T, var497.field36 = char, part, t, var496
            end
        elseif specDetected[userId] then
            specDetected[userId] = nil
            fn129()
        end
    end
    local function fn131(player, part, name)
        local var498 = "char_" .. player.UserId .. "_" .. name
        specConns[var498 .. "_T"] = part:GetPropertyChangedSignal("Transparency"):Connect(function()
            fn130(player)
        end)
        specConns[var498 .. "_LT"] = part:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
            fn130(player)
        end)
    end
    local function fn132(player, char)
        if fn123(player) or fn124(char) then
            return
        end
        local var499 = "char_" .. player.UserId .. "_"
        fn126(var499)
        for _, name in ipairs(tbl36) do
            local part = char:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                fn131(player, part, name)
            end
        end
        specConns[var499 .. "added"] = char.ChildAdded:Connect(function(obj)
            if not obj:IsA("BasePart") then
                return
            end
            for _, name in ipairs(tbl36) do
                if obj.Name == name then
                    fn131(player, obj, name)
                    task.defer(function()
                        fn130(player)
                    end)
                    break
                end
            end
        end)
        task.defer(function()
            fn130(player)
        end)
    end
    local function fn133(player)
        if fn123(player) then
            return
        end
        local userId2 = player.UserId
        fn125("player_" .. userId2)
        specConns["player_" .. userId2] = player.CharacterAdded:Connect(function(char)
            specDetected[userId2] = nil
            fn129()
            task.wait(0.15)
            if tbl2.flag163 then
                fn132(player, char)
            end
        end)
        if player.Character then
            fn132(player, player.Character)
        end
    end
    local function onPlayerRemoving(player)
        if not player then
            return
        end
        local userId3 = player.UserId
        fn125("player_" .. userId3)
        fn126("char_" .. userId3 .. "_")
        specDetected[userId3] = nil
        specStreamTimes[userId3] = nil
        fn129()
    end
    local function fn134(player)
        if not tbl2.flag163 or not player or fn123(player) then
            return
        end
        if tbl2.flag164 or fn122() then
            return
        end
        local char = player.Character
        local var500 = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
        if not var500 or not var500:IsA("BasePart") then
            return
        end
        local userId4 = player.UserId
        local var501 = os.clock()
        if specStreamTimes[userId4] and var501 - specStreamTimes[userId4] < num23 then
            return
        end
        specStreamTimes[userId4] = var501
        task.spawn(function()
            pcall(function()
                localPlayer:RequestStreamAroundAsync(var500.Position, num23)
            end)
        end)
    end
    local num24 = 0
    local function fn135()
        local var502 = fn122()
        if var502 ~= tbl2.flag164 then
            tbl2.flag164 = var502
            if var502 then
                table.clear(specDetected)
                table.clear(specStreamTimes)
            end
        end
        fn129()
    end
    fn5("SpectatorCount", 0.25, function(arg98)
        if not tbl2.flag163 then
            return
        end
        local var503 = fn122()
        if var503 ~= tbl2.flag164 then
            tbl2.flag164 = var503
            if var503 then
                table.clear(specDetected)
                table.clear(specStreamTimes)
                num24 = 0
                fn129()
                return
            end
            num24 = 0
        end
        if var503 then
            fn129()
            return
        end
        local players2 = Players:GetPlayers()
        for _, v66 in ipairs(players2) do
            if not fn123(v66) then
                fn130(v66)
            end
        end
        if not tbl2.field34 or not tbl2.field34.Parent then
            if tbl2.field34 then
                pcall(function()
                    tbl2.field34:Destroy()
                end)
            end
            tbl2.field34 = undefinedGlobal2()
        end
        num24 = num24 + arg98
        if num24 >= num23 then
            num24 = 0
            for _, v67 in ipairs(players2) do
                if not fn123(v67) then
                    fn134(v67)
                end
            end
        end
        fn129()
    end)
    local function fn136()
        local screenGui5 = Instance.new("ScreenGui")
        screenGui5.Name = "BolongSpecCount"
        screenGui5.ResetOnSpawn = false
        screenGui5.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui5.IgnoreGuiInset = false
        screenGui5.DisplayOrder = 49
        pcall(function()
            screenGui5.Parent = gethui and gethui() or game:GetService("CoreGui")
        end)
        if not screenGui5.Parent then
            screenGui5.Parent = playerGui
        end
        local frame6 = Instance.new("Frame")
        frame6.Name = "SpecFrame"
        frame6.Size = UDim2.fromOffset(170, 28)
        frame6.AnchorPoint = Vector2.new(0, 1)
        frame6.Position = UDim2.new(0, 10, 1, -10)
        frame6.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
        frame6.BorderSizePixel = 0
        frame6.Active = true
        frame6.Parent = screenGui5
        local uICorner3 = Instance.new("UICorner")
        uICorner3.CornerRadius = UDim.new(0, 8)
        uICorner3.Parent = frame6
        local uIStroke4 = Instance.new("UIStroke")
        uIStroke4.Color = Color3.fromRGB(60, 60, 75)
        uIStroke4.Thickness = 1
        uIStroke4.Parent = frame6
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Name = "InfoLabel"
        infoLabel.Size = UDim2.new(1, 0, 1, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Text = "SPECTATORS 0"
        infoLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
        infoLabel.TextSize = 12
        infoLabel.Font = Enum.Font.GothamBold
        infoLabel.TextXAlignment = Enum.TextXAlignment.Center
        infoLabel.TextYAlignment = Enum.TextYAlignment.Center
        infoLabel.RichText = true
        infoLabel.Parent = frame6
        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Name = "EyeIcon"
        imageLabel.Size = UDim2.fromOffset(16, 16)
        imageLabel.BackgroundTransparency = 1
        imageLabel.Image = "rbxassetid://104977598392154"
        imageLabel.ImageColor3 = Color3.fromRGB(200, 200, 210)
        imageLabel.Position = UDim2.new(0, 6, 0.5, -8)
        imageLabel.ScaleType = Enum.ScaleType.Fit
        imageLabel.Parent = frame6
        local var504, var505, var506
        frame6.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                var504 = true
                var505 = input.Position
                var506 = frame6.Position
            end
        end)
        frame6.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                var504 = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if var504 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local var507 = input.Position - var505
                frame6.Position = UDim2.new(var506.X.Scale, var506.X.Offset + var507.X, var506.Y.Scale, var506.Y.Offset + var507.Y)
            end
        end)
        return screenGui5
    end
    function var489()
        if tbl2.flag163 then
            return
        end
        tbl2.flag163 = true
        tbl2.flag164 = fn122()
        num24 = 0
        table.clear(specDetected)
        table.clear(specStreamTimes)
        if tbl2.field34 then
            tbl2.field34:Destroy()
        end
        tbl2.field34 = fn136()
        for _, v68 in ipairs(Players:GetPlayers()) do
            if not fn123(v68) then
                fn133(v68)
            end
        end
        specConns.onJoin = Players.PlayerAdded:Connect(function(arg99)
            if tbl2.flag163 then
                fn133(arg99)
            end
        end)
        specConns.onLeave = Players.PlayerRemoving:Connect(onPlayerRemoving)
        specConns.selfTeam = localPlayer:GetPropertyChangedSignal("Team"):Connect(function()
            if not tbl2.flag163 then
                return
            end
            fn135()
        end)
        fn129()
    end
    function StopSpectatorCount()
        tbl2.flag163 = false
        tbl2.flag164 = false
        for key3 in next, specConns do
            local var508 = specConns[key3]
            pcall(function()
                var508:Disconnect()
            end)
            specConns[key3] = nil
        end
        table.clear(specDetected)
        table.clear(specStreamTimes)
        if tbl2.field34 then
            tbl2.field34:Destroy()
            tbl2.field34 = nil
        end
    end
end
CROSSHAIR_STYLES = {"Dot", "Circle", "Circle + Dot", "Plus", "Cross (X)", "T-Shape", "Square"}
local var509
do
    local num25 = 80
    local var510 = num25 / 2
    local tbl37 = {}
    local function fn137(centerX, centerY, width, length, rotation, color, arg100, name)
        local frame7 = Instance.new("Frame")
        frame7.Name = name or "CH_Part"
        frame7.BackgroundColor3 = color
        frame7.BackgroundTransparency = arg100
        frame7.BorderSizePixel = 0
        frame7.Size = UDim2.fromOffset(math.max(1, math.round(width)), math.max(1, math.round(length)))
        frame7.AnchorPoint = Vector2.new(0.5, 0.5)
        frame7.Position = UDim2.fromOffset(math.round(centerX), math.round(centerY))
        if rotation ~= 0 then
            frame7.Rotation = rotation
        end
        return frame7
    end
    local function fn138(size)
        return 0.3 + math.clamp(size, 1, 100) / 100 * 2.2
    end
    tbl37.Plus = function(size, color, arg101)
        local tbl38 = {}
        local var511 = fn138(size)
        local var512 = math.max(2, math.round(2 * var511))
        local var513 = math.max(8, math.round(25 * var511))
        local var514 = var510
        table.insert(tbl38, fn137(var514, var514, var512, var513, 0, color, arg101))
        table.insert(tbl38, fn137(var514, var514, var513, var512, 0, color, arg101))
        return tbl38, {}, {}
    end
    tbl37["Cross (X)"] = function(size, color, arg102)
        local tbl39 = {}
        local var515 = fn138(size)
        local var516 = math.max(2, math.round(2 * var515))
        local var517 = math.max(8, math.round(25 * var515))
        local var518 = var510
        table.insert(tbl39, fn137(var518, var518, var516, var517, 45, color, arg102))
        table.insert(tbl39, fn137(var518, var518, var516, var517, -45, color, arg102))
        return tbl39, {}, {}
    end
    tbl37.Dot = function(size, color, arg103)
        local tbl40 = {}
        local var519 = fn138(size)
        local var520 = math.max(3, math.round(8 * var519))
        local var521 = var510
        local dot = fn137(var521, var521, var520, var520, 0, color, arg103, "CH_Dot")
        local uICorner4 = Instance.new("UICorner")
        uICorner4.CornerRadius = UDim.new(1, 0)
        uICorner4.Parent = dot
        table.insert(tbl40, dot)
        return tbl40, {}, {}
    end
    tbl37.Circle = function(size, color, arg104)
        local tbl41, strokes = {}, {}
        local var522 = fn138(size)
        local var523 = math.max(4, math.round(12 * var522))
        local var524 = math.max(2, math.round(2 * var522))
        local var525 = var510
        local frame8 = Instance.new("Frame")
        frame8.Name = "CH_Ring"
        frame8.BackgroundTransparency = 1
        frame8.Size = UDim2.fromOffset(var523 * 2, var523 * 2)
        frame8.AnchorPoint = Vector2.new(0.5, 0.5)
        frame8.Position = UDim2.fromOffset(var525, var525)
        local uICorner5 = Instance.new("UICorner")
        uICorner5.CornerRadius = UDim.new(1, 0)
        uICorner5.Parent = frame8
        local uIStroke5 = Instance.new("UIStroke")
        uIStroke5.Name = "CH_Stroke"
        uIStroke5.Color = color
        uIStroke5.Thickness = var524
        uIStroke5.Transparency = arg104
        uIStroke5.Parent = frame8
        table.insert(tbl41, frame8)
        table.insert(strokes, uIStroke5)
        return tbl41, strokes, {}
    end
    tbl37["Circle + Dot"] = function(size, color, arg105)
        local tbl42, strokes, dots = {}, {}, {}
        local var526 = fn138(size)
        local var527 = math.max(4, math.round(12 * var526))
        local var528 = math.max(2, math.round(2 * var526))
        local var529 = math.max(2, math.round(4 * var526))
        local var530 = var510
        local frame9 = Instance.new("Frame")
        frame9.Name = "CH_Ring"
        frame9.BackgroundTransparency = 1
        frame9.Size = UDim2.fromOffset(var527 * 2, var527 * 2)
        frame9.AnchorPoint = Vector2.new(0.5, 0.5)
        frame9.Position = UDim2.fromOffset(var530, var530)
        local uICorner6 = Instance.new("UICorner")
        uICorner6.CornerRadius = UDim.new(1, 0)
        uICorner6.Parent = frame9
        local uIStroke6 = Instance.new("UIStroke")
        uIStroke6.Name = "CH_Stroke"
        uIStroke6.Color = color
        uIStroke6.Thickness = var528
        uIStroke6.Transparency = arg105
        uIStroke6.Parent = frame9
        table.insert(tbl42, frame9)
        table.insert(strokes, uIStroke6)
        local dot = fn137(var530, var530, var529, var529, 0, color, arg105, "CH_Dot")
        local uICorner7 = Instance.new("UICorner")
        uICorner7.CornerRadius = UDim.new(1, 0)
        uICorner7.Parent = dot
        table.insert(tbl42, dot)
        table.insert(dots, dot)
        return tbl42, strokes, dots
    end
    tbl37["T-Shape"] = function(size, color, arg106)
        local tbl43 = {}
        local var532 = fn138(size)
        local var533 = math.max(2, math.round(2 * var532))
        local var534 = math.max(8, math.round(25 * var532))
        local var535 = var510
        local var536 = math.round(var534 * 0.25)
        table.insert(tbl43, fn137(var535, var535 - var536, var534, var533, 0, color, arg106))
        table.insert(tbl43, fn137(var535, var535 - var536 + var534 / 2, var533, var534, 0, color, arg106))
        return tbl43, {}, {}
    end
    tbl37.Square = function(size, color, arg107)
        local tbl44 = {}
        local var537 = fn138(size)
        local var538 = math.max(2, math.round(2 * var537))
        local var539 = math.max(8, math.round(22 * var537))
        local var540 = math.max(3, math.round(var539 * 0.4))
        local var541 = var510
        local var542 = var539 / 2
        table.insert(tbl44, fn137(var541 - var542 + var540 / 2, var541 - var542, var540, var538, 0, color, arg107))
        table.insert(tbl44, fn137(var541 - var542, var541 - var542 + var540 / 2, var538, var540, 0, color, arg107))
        table.insert(tbl44, fn137(var541 + var542 - var540 / 2, var541 - var542, var540, var538, 0, color, arg107))
        table.insert(tbl44, fn137(var541 + var542, var541 - var542 + var540 / 2, var538, var540, 0, color, arg107))
        table.insert(tbl44, fn137(var541 - var542 + var540 / 2, var541 + var542, var540, var538, 0, color, arg107))
        table.insert(tbl44, fn137(var541 - var542, var541 + var542 - var540 / 2, var538, var540, 0, color, arg107))
        table.insert(tbl44, fn137(var541 + var542 - var540 / 2, var541 + var542, var540, var538, 0, color, arg107))
        table.insert(tbl44, fn137(var541 + var542, var541 + var542 - var540 / 2, var538, var540, 0, color, arg107))
        return tbl44, {}, {}
    end
    local tbl45 = {}
    tbl45.__index = tbl45
    function tbl45.new()
        local self = setmetatable({}, tbl45)
        self.config = {
            enabled = false,
            style = "Plus",
            size = 1,
            opacity = 1,
            offsetX = 0,
            offsetY = 0,
            color = Color3.fromRGB(255, 255, 255),
            smooth = true,
            smoothSpeed = 0.25,
        }
        self.gui = nil
        self.container = nil
        self.parent = nil
        self.parts = {frames = {}, strokes = {}, dots = {}}
        self.connections = {}
        self.renderConn = nil
        self.currentOffset = Vector2.new(0, 0)
        self.targetOffset = Vector2.new(0, 0)
        self._frameCount = 0
        return self
    end
    local function fn139()
        local var543
        pcall(function()
            if gethui then
                var543 = gethui()
            end
        end)
        if var543 and var543.Parent then
            return var543
        end
        pcall(function()
            var543 = game:GetService("CoreGui")
        end)
        if var543 and var543.Parent then
            return var543
        end
        return playerGui
    end
    function tbl45:_createGui()
        if self.gui and self.gui.Parent then
            return
        end
        local screenGui6 = Instance.new("ScreenGui")
        screenGui6.Name = "BolongCrosshair"
        screenGui6.ResetOnSpawn = false
        screenGui6.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui6.IgnoreGuiInset = true
        screenGui6.DisplayOrder = 999999
        local var545 = fn139()
        screenGui6.Parent = var545
        self.parent = var545
        local frame10 = Instance.new("Frame")
        frame10.Name = "Container"
        frame10.Size = UDim2.fromOffset(num25, num25)
        frame10.AnchorPoint = Vector2.new(0.5, 0.5)
        frame10.BackgroundTransparency = 1
        frame10.BorderSizePixel = 0
        frame10.Parent = screenGui6
        self.gui = screenGui6
        self.container = frame10
        self:_rebuild()
        self.targetOffset = Vector2.new(self.config.offsetX, self.config.offsetY)
        self.currentOffset = self.targetOffset
        self:_updatePosition()
    end
    function tbl45:_rebuild()
        if not self.container then
            return
        end
        for _, v69 in ipairs(self.parts.frames) do
            pcall(function()
                v69:Destroy()
            end)
        end
        self.parts = {frames = {}, strokes = {}, dots = {}}
        local var546 = tbl37[self.config.style]
        if not var546 then
            return
        end
        local var547 = 1 - self.config.opacity
        local frames, strokes, dots = var546(self.config.size, self.config.color, var547)
        for _, v70 in ipairs(frames) do
            v70.Parent = self.container
            table.insert(self.parts.frames, v70)
        end
        for _, v71 in ipairs(strokes) do
            table.insert(self.parts.strokes, v71)
        end
        self.parts.dots = dots or {}
    end
    function tbl45:_updateColors()
        local color = self.config.color
        local var548 = 1 - self.config.opacity
        local tbl46 = {}
        for _, v72 in ipairs(self.parts.dots) do
            tbl46[v72] = true
        end
        for _, v73 in ipairs(self.parts.frames) do
            if v73 and v73.Parent then
                v73.BackgroundColor3 = tbl46[v73] and Color3.fromRGB(255, 255, 255) or color
                if not v73:FindFirstChildWhichIsA("UIStroke") then
                    v73.BackgroundTransparency = var548
                end
            end
        end
        for _, v74 in ipairs(self.parts.strokes) do
            if v74 and v74.Parent then
                v74.Color = color
                v74.Transparency = var548
            end
        end
    end
    function tbl45:_updatePosition()
        if not self.container then
            return
        end
        local currentCamera13 = workspace.CurrentCamera
        if not currentCamera13 then
            return
        end
        local viewportSize3 = currentCamera13.ViewportSize
        self.container.Position = UDim2.fromOffset(viewportSize3.X * 0.5 + self.currentOffset.X, viewportSize3.Y * 0.5 + self.currentOffset.Y)
    end
    function tbl45:_hookCamera()
        if self.connections.camViewport then
            self.connections.camViewport:Disconnect()
            self.connections.camViewport = nil
        end
        local currentCamera14 = workspace.CurrentCamera
        if currentCamera14 then
            self.connections.camViewport = currentCamera14:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                self:_updatePosition()
            end)
        end
    end
    function tbl45:_setupConnections()
        self:_hookCamera()
        if not self.connections.camChange then
            self.connections.camChange = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
                self:_hookCamera()
                self:_updatePosition()
            end)
        end
        if not self.connections.childRemoved then
            self.connections.childRemoved = self.parent.ChildRemoved:Connect(function(arg108)
                if arg108 == self.gui and self.config.enabled then
                    self.gui = nil
                    self.container = nil
                    self.parts = {frames = {}, strokes = {}, dots = {}}
                    task.wait(0.05)
                    if self.config.enabled then
                        self:_createGui()
                    end
                end
            end)
        end
        if not self.connections.touchChanged then
            self.connections.touchChanged = UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(function()
                self:_updatePosition()
            end)
        end
    end
    function tbl45:_startRender()
        if self.renderConn then
            return
        end
        self.renderConn = RunService.RenderStepped:Connect(function(arg109)
            if not self.config.enabled then
                return
            end
            if not self.gui or not self.gui.Parent then
                self:_createGui()
                return
            end
            if not self.gui.Enabled then
                self.gui.Enabled = true
            end
            self._frameCount = self._frameCount + 1
            if self._frameCount % 30 == 0 then
                local flag17 = false
                for _, v75 in ipairs(self.parts.frames) do
                    if v75 and v75.Parent then
                        flag17 = true
                        break
                    end
                end
                if not flag17 and #self.parts.frames > 0 then
                    self:_rebuild()
                end
            end
            if self.config.smooth then
                local var549 = self.targetOffset - self.currentOffset
                if var549.Magnitude > 0.01 then
                    local var550 = 1 - math.pow(1 - self.config.smoothSpeed, arg109 * 60)
                    self.currentOffset = self.currentOffset:Lerp(self.targetOffset, var550)
                    self:_updatePosition()
                end
            end
        end)
    end
    function tbl45:_stopRender()
        if self.renderConn then
            self.renderConn:Disconnect()
            self.renderConn = nil
        end
    end
    function tbl45:SetEnabled(enabled)
        self.config.enabled = enabled
        if enabled then
            if not self.gui or not self.gui.Parent then
                self:_createGui()
                self:_setupConnections()
            end
            self.gui.Enabled = true
            self.targetOffset = Vector2.new(self.config.offsetX, self.config.offsetY)
            self.currentOffset = self.targetOffset
            self:_updatePosition()
            self:_startRender()
        else
            self:_stopRender()
            if self.gui then
                self.gui.Enabled = false
            end
        end
    end
    function tbl45:SetStyle(style)
        self.config.style = style
        if self.config.enabled and self.gui then
            self:_rebuild()
        end
    end
    function tbl45:SetSize(size)
        self.config.size = size
        if self.config.enabled and self.gui then
            self:_rebuild()
        end
    end
    function tbl45:SetOpacity(opacity)
        self.config.opacity = opacity
        if self.config.enabled and self.gui then
            self:_updateColors()
        end
    end
    function tbl45:SetColor(color)
        self.config.color = color
        if self.config.enabled and self.gui then
            self:_updateColors()
        end
    end
    function tbl45:SetOffsetX(arg110)
        self.config.offsetX = arg110
        self.targetOffset = Vector2.new(arg110, self.config.offsetY)
        if not self.config.smooth and self.config.enabled then
            self.currentOffset = self.targetOffset
            self:_updatePosition()
        end
    end
    function tbl45:SetOffsetY(arg111)
        self.config.offsetY = arg111
        self.targetOffset = Vector2.new(self.config.offsetX, arg111)
        if not self.config.smooth and self.config.enabled then
            self.currentOffset = self.targetOffset
            self:_updatePosition()
        end
    end
    function tbl45:Destroy()
        self.config.enabled = false
        self:_stopRender()
        for _, v76 in pairs(self.connections) do
            pcall(function()
                v76:Disconnect()
            end)
        end
        self.connections = {}
        if self.gui then
            pcall(function()
                self.gui:Destroy()
            end)
        end
        self.gui = nil
        self.container = nil
        self.parts = {frames = {}, strokes = {}, dots = {}}
    end
    var509 = tbl45.new()
end
local var551, StopProtectName, _ApplyCopiedAvatarToUI, _HookAllAvatarSlots, _EnsureAvatarUiWatchers
do
    local function fn140(player)
        if not tbl2.list11[player] then
            tbl2.list11[player] = tbl4[1]
        end
        return tbl2.list11[player]
    end
    local function fn141(char, arg112)
        if not char then
            return
        end
        local head3 = char:FindFirstChild("Head")
        if not head3 then
            return
        end
        for _, gui in ipairs(head3:GetChildren()) do
            if gui:IsA("BillboardGui") then
                local textLabel4 = gui:FindFirstChildWhichIsA("TextLabel", true)
                if textLabel4 then
                    textLabel4.Text = arg112
                end
            end
        end
        local humanoid12 = char:FindFirstChildOfClass("Humanoid")
        if humanoid12 then
            pcall(function()
                humanoid12.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            end)
        end
    end
    local function fn142(char, arg113)
        if not char then
            return
        end
        local head4 = char:FindFirstChild("Head")
        if head4 then
            for _, gui in ipairs(head4:GetChildren()) do
                if gui:IsA("BillboardGui") then
                    local textLabel5 = gui:FindFirstChildWhichIsA("TextLabel", true)
                    if textLabel5 then
                        textLabel5.Text = arg113
                    end
                end
            end
        end
        local humanoid13 = char:FindFirstChildOfClass("Humanoid")
        if humanoid13 then
            pcall(function()
                humanoid13.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Limit
            end)
        end
    end
    local function fn143(arg114)
        local survivorMob3 = playerGui:FindFirstChild("Survivor-mob")
        if not survivorMob3 then
            return nil
        end
        local frame11 = survivorMob3:FindFirstChild("Frame")
        if not frame11 then
            return nil
        end
        for i25 = 1, 5 do
            local var553 = frame11:FindFirstChild("Survivor" .. i25)
            if var553 and var553:GetAttribute("UserId") == arg114 then
                return var553:FindFirstChild("TextLabel")
            end
        end
        return nil
    end
    local function fn144(player)
        local var554 = player == localPlayer
        local var555 = fn140(player)
        if not var554 then
            if tbl2.espObjects[player] then
                tbl2.espObjects[player].nameLabel.Text = var555
            end
            if player.Character then
                fn141(player.Character, var555)
            end
        end
        local var556 = fn143(player.UserId)
        if var556 then
            var556.Text = var555
        end
        if not var554 and not tbl2.pnameNameConns[player] then
            tbl2.pnameNameConns[player] = player.CharacterAdded:Connect(function(char)
                if not tbl2.flag125 then
                    return
                end
                local fn = fn140(player)
                task.wait(0.5)
                fn141(char, fn)
                if tbl2.espObjects[player] then
                    tbl2.espObjects[player].nameLabel.Text = fn
                end
                local var557 = fn143(player.UserId)
                if var557 then
                    var557.Text = fn
                end
            end)
        end
    end
    local function fn145(player)
        local var558 = player == localPlayer
        local name3 = player.Name
        if not var558 then
            if tbl2.espObjects[player] then
                tbl2.espObjects[player].nameLabel.Text = name3
            end
            if player.Character then
                fn142(player.Character, name3)
            end
            if tbl2.pnameNameConns[player] then
                tbl2.pnameNameConns[player].Disconnect(tbl2.pnameNameConns[player])
                tbl2.pnameNameConns[player] = nil
            end
        end
        local var559 = fn143(player.UserId)
        if var559 then
            var559.Text = name3
        end
    end
    local function fn146(arg115, arg116)
        local name4 = arg115.Name
        if tbl2.pnameSlotConns[name4] then
            tbl2.pnameSlotConns[name4].Disconnect(tbl2.pnameSlotConns[name4])
            tbl2.pnameSlotConns[name4] = nil
        end
        local var561 = arg115:GetAttribute("UserId")
        if not var561 then
            return
        end
        local var562
        for _, v77 in ipairs(Players:GetPlayers()) do
            if v77.UserId == var561 then
                var562 = v77
                break
            end
        end
        if not var562 then
            return
        end
        local fn = fn140(var562)
        tbl2.pnameSlotConns[name4] = arg116:GetPropertyChangedSignal("Text"):Connect(function()
            if not tbl2.flag125 then
                return
            end
            local var563 = arg115:GetAttribute("UserId")
            if not var563 then
                return
            end
            local var564
            for _, v78 in ipairs(Players:GetPlayers()) do
                if v78.UserId == var563 then
                    var564 = v78
                    break
                end
            end
            if not var564 then
                return
            end
            local var565 = fn140(var564)
            if arg116.Text ~= var565 then
                arg116.Text = var565
            end
        end)
    end
    local function fn147()
        for k4, v79 in pairs(tbl2.pnameSlotConns) do
            v79:Disconnect()
            tbl2.pnameSlotConns[k4] = nil
        end
        local survivorMob4 = playerGui:FindFirstChild("Survivor-mob")
        if not survivorMob4 then
            return
        end
        local frame12 = survivorMob4:FindFirstChild("Frame")
        if not frame12 then
            return
        end
        for i26 = 1, 5 do
            local var566 = frame12:FindFirstChild("Survivor" .. i26)
            if var566 then
                local textLabel6 = var566:FindFirstChild("TextLabel")
                if textLabel6 then
                    fn146(var566, textLabel6)
                end
            end
        end
    end
    local function fn148(arg117)
        if type(arg117) ~= "string" or arg117 == "" then
            return nil
        end
        local tbl47 = {}
        for _, v80 in ipairs(Players:GetPlayers()) do
            for _, nm in ipairs({v80.Name, v80.DisplayName}) do
                if type(nm) == "string" and #nm >= 3 then
                    tbl47[#tbl47 + 1] = {nm = nm, fake = fn140(v80)}
                end
            end
        end
        table.sort(tbl47, function(arg118, arg119)
            return #arg118.nm > #arg119.nm
        end)
        for _, v81 in ipairs(tbl47) do
            if string.find(arg117, v81.nm, 1, true) then
                local var567 = v81.nm:gsub("(%W)", "%%%1")
                return (arg117:gsub(var567, v81.fake, 1))
            end
        end
        return nil
    end
    local function fn149(obj)
        local parent5 = obj.Parent
        for _ = 1, 6 do
            if not parent5 then
                break
            end
            if parent5.Name == "Survivor-mob" then
                return true
            end
            parent5 = parent5.Parent
        end
        return false
    end
    local function fn150(obj)
        if not tbl2.flag125 then
            return
        end
        local var568, isText = pcall(function()
            return obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")
        end)
        if not var568 or not isText then
            return
        end
        if fn149(obj) then
            return
        end
        local var569, cur = pcall(function()
            return obj.Text
        end)
        if not var569 or type(cur) ~= "string" then
            return
        end
        local var570 = fn148(cur)
        if not var570 or var570 == cur then
            return
        end
        tbl2.pnameGenConns = tbl2.pnameGenConns or {}
        tbl2.pnameGenOrig = tbl2.pnameGenOrig or {}
        tbl2.pnameGenCount = tbl2.pnameGenCount or 0
        if tbl2.pnameGenOrig[obj] == nil and tbl2.pnameGenCount < 200 then
            tbl2.pnameGenOrig[obj] = cur
            tbl2.pnameGenCount = tbl2.pnameGenCount + 1
        end
        pcall(function()
            obj.Text = var570
        end)
        if not tbl2.pnameGenConns[obj] then
            tbl2.pnameGenConns[obj] = obj:GetPropertyChangedSignal("Text"):Connect(function()
                if not tbl2.flag125 then
                    return
                end
                local var571 = tbl2.pnameGenOrig[obj]
                if not var571 then
                    return
                end
                local var572 = fn148(var571)
                if var572 then
                    local var573, curNow = pcall(function()
                        return obj.Text
                    end)
                    if var573 and curNow ~= var572 then
                        pcall(function()
                            obj.Text = var572
                        end)
                    end
                end
            end)
        end
    end
    function var551()
        tbl2.flag125 = true
        for _, player in ipairs(Players:GetPlayers()) do
            fn144(player)
        end
        fn147()
        pcall(function()
            local playerGui8 = localPlayer:FindFirstChildOfClass("PlayerGui")
            if playerGui8 then
                for _, v82 in ipairs(playerGui8:GetDescendants()) do
                    fn150(v82)
                end
            end
        end)
        if not tbl2.connection11 then
            tbl2.connection11 = playerGui.ChildAdded:Connect(function(arg120)
                if arg120.Name == "Survivor-mob" then
                    task.wait(0.2)
                    if tbl2.flag125 then
                        fn147()
                        for _, player in ipairs(Players:GetPlayers()) do
                            fn144(player)
                        end
                    end
                end
            end)
        end
        if not tbl2.connection12 then
            tbl2.connection12 = Players.PlayerAdded:Connect(function(player)
                if tbl2.flag125 then
                    task.wait(1)
                    fn144(player)
                    fn147()
                end
            end)
        end
        if not tbl2.pnameGenConn then
            tbl2.pnameGenConn = playerGui.DescendantAdded:Connect(function(obj)
                task.defer(function()
                    if tbl2.flag125 then
                        fn150(obj)
                    end
                end)
            end)
        end
    end
    function StopProtectName()
        tbl2.flag125 = false
        for k5, v83 in pairs(tbl2.pnameSlotConns) do
            v83:Disconnect()
            tbl2.pnameSlotConns[k5] = nil
        end
        if tbl2.connection11 then
            tbl2.connection11:Disconnect()
            tbl2.connection11 = nil
        end
        if tbl2.pnameGenConn then
            pcall(function()
                tbl2.pnameGenConn:Disconnect()
            end)
            tbl2.pnameGenConn = nil
        end
        for _, v84 in pairs(tbl2.pnameGenConns or {}) do
            pcall(function()
                v84:Disconnect()
            end)
        end
        tbl2.pnameGenConns = {}
        for k6, v85 in pairs(tbl2.pnameGenOrig or {}) do
            pcall(function()
                if k6 and k6.Parent then
                    k6.Text = v85
                end
            end)
        end
        tbl2.pnameGenOrig = {}
        tbl2.pnameGenCount = 0
        for _, player in ipairs(Players:GetPlayers()) do
            fn145(player)
        end
        tbl2.list11 = {}
        if tbl2.connection12 then
            tbl2.connection12:Disconnect()
            tbl2.connection12 = nil
        end
    end
    local function fn151(arg121)
        if tbl2.field5 == arg121 and tbl2.field4 then
            return tbl2.field4
        end
        local var576 = nil
        for _ = 1, 3 do
            local var577, var578, ready = pcall(function()
                return Players:GetUserThumbnailAsync(arg121, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            end)
            if var577 and var578 and var578 ~= "" then
                var576 = var578
                if ready then
                    break
                end
            end
            task.wait(1)
        end
        if var576 then
            tbl2.field4 = var576
            tbl2.field5 = arg121
        end
        return var576
    end
    local function fn152()
        local survivorMob5 = playerGui:FindFirstChild("Survivor-mob")
        if not survivorMob5 then
            return nil, nil
        end
        local frame13 = survivorMob5:FindFirstChild("Frame")
        if not frame13 then
            return nil, nil
        end
        for i27 = 1, 5 do
            local var579 = frame13:FindFirstChild("Survivor" .. i27)
            if var579 and var579:GetAttribute("UserId") == localPlayer.UserId then
                local imageLabel2 = var579:FindFirstChild("ImageLabel")
                if imageLabel2 then
                    return var579, imageLabel2
                end
            end
        end
        return nil, nil
    end
    function _ApplyCopiedAvatarToUI()
        if not tbl2.flag126 or not tbl2.field3 then
            return
        end
        local _, var580 = fn152()
        if not var580 then
            return
        end
        local var581 = fn151(tbl2.field3)
        if var581 and var580.Parent and var580.Image ~= var581 then
            pcall(function()
                var580.Image = var581
            end)
        end
    end
    local function fn153(arg122, arg123)
        local name5 = arg122.Name
        local var582 = tbl2.avatarUiSlotConns[name5]
        if var582 then
            if type(var582) == "table" then
                for _, v86 in ipairs(var582) do
                    pcall(function()
                        v86:Disconnect()
                    end)
                end
            else
                pcall(function()
                    var582:Disconnect()
                end)
            end
            tbl2.avatarUiSlotConns[name5] = nil
        end
        local tbl48 = {}
        tbl48[#tbl48 + 1] = arg123:GetPropertyChangedSignal("Image"):Connect(function()
            if not tbl2.flag126 or not tbl2.field3 then
                return
            end
            if arg122:GetAttribute("UserId") ~= localPlayer.UserId then
                return
            end
            local var583 = tbl2.field4
            if var583 and arg123.Parent and arg123.Image ~= var583 then
                pcall(function()
                    arg123.Image = var583
                end)
            end
        end)
        tbl48[#tbl48 + 1] = arg122:GetAttributeChangedSignal("UserId"):Connect(function()
            if not tbl2.flag126 or not tbl2.field3 then
                return
            end
            task.wait(0.3)
            if arg122:GetAttribute("UserId") == localPlayer.UserId then
                _ApplyCopiedAvatarToUI()
            end
        end)
        tbl2.avatarUiSlotConns[name5] = tbl48
    end
    function _HookAllAvatarSlots()
        for k7, v87 in pairs(tbl2.avatarUiSlotConns) do
            if type(v87) == "table" then
                for _, v88 in ipairs(v87) do
                    pcall(function()
                        v88:Disconnect()
                    end)
                end
            else
                pcall(function()
                    v87:Disconnect()
                end)
            end
            tbl2.avatarUiSlotConns[k7] = nil
        end
        local survivorMob6 = playerGui:FindFirstChild("Survivor-mob")
        if not survivorMob6 then
            return
        end
        local frame14 = survivorMob6:FindFirstChild("Frame")
        if not frame14 then
            return
        end
        for i28 = 1, 5 do
            local var584 = frame14:FindFirstChild("Survivor" .. i28)
            if var584 then
                local imageLabel3 = var584:FindFirstChild("ImageLabel")
                if imageLabel3 then
                    fn153(var584, imageLabel3)
                end
            end
        end
    end
    function _EnsureAvatarUiWatchers()
        if not tbl2.connection13 then
            tbl2.connection13 = playerGui.ChildAdded:Connect(function(arg124)
                if arg124.Name == "Survivor-mob" then
                    task.wait(0.2)
                    if tbl2.flag126 and tbl2.field3 then
                        _HookAllAvatarSlots()
                        _ApplyCopiedAvatarToUI()
                    end
                end
            end)
        end
        if not tbl2.connection14 then
            tbl2.connection14 = localPlayer.CharacterAdded:Connect(function()
                if not tbl2.field3 then
                    return
                end
                task.wait(1)
                if tbl2.field3 then
                    tbl2.flag126 = true
                    undefinedGlobal3(tostring(tbl2.field3))
                end
            end)
        end
    end
end
local function fn154(darknessMode)
    darknessMode = darknessMode or false
    local currentCamera15 = Workspace.CurrentCamera
    local skipEndScreenConns = tbl2.skipEndScreenConns
    local flag18 = false
    local flag19 = false
    local flag20 = false
    pcall(function()
        local remotes9 = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes9 then
            return
        end
        local function fn155(remote)
            if remote and remote:IsA("RemoteEvent") then
                for _, v89 in ipairs(getconnections(remote.OnClientEvent)) do
                    v89:Disable()
                    v89:Disconnect()
                end
            end
        end
        local game3 = remotes9:FindFirstChild("Game")
        if game3 then
            for _, name in ipairs({"cutscene", "cutsceneEnd", "cutsceneEnd2", "endscreencutscene", "cutsceneEndwithownchar", "shake"}) do
                fn155(game3:FindFirstChild(name))
            end
        end
        local killers = remotes9:FindFirstChild("Killers")
        if killers then
            fn155(killers:FindFirstChild("Startmori"))
        end
        if darknessMode then
            fn155(remotes9:FindFirstChild("Darkness2"))
        end
    end)
    local function fn156()
        if not currentCamera15 then
            return
        end
        if currentCamera15.CameraType == Enum.CameraType.Scriptable then
            flag18 = true
            currentCamera15.CameraType = Enum.CameraType.Custom
            flag18 = false
        end
    end
    if currentCamera15 then
        fn156()
        table.insert(skipEndScreenConns, currentCamera15:GetPropertyChangedSignal("CameraType"):Connect(function()
            if not flag18 then
                fn156()
            end
        end))
        table.insert(skipEndScreenConns, currentCamera15:GetPropertyChangedSignal("FieldOfView"):Connect(function()
            if flag19 or tbl.flag75 then
                return
            end
            if currentCamera15.FieldOfView ~= 70 then
                flag19 = true
                currentCamera15.FieldOfView = 70
                flag19 = false
            end
        end))
    end
    table.insert(skipEndScreenConns, Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        currentCamera15 = Workspace.CurrentCamera
        if currentCamera15 then
            fn156()
        end
    end))
    table.insert(skipEndScreenConns, localPlayer:GetAttributeChangedSignal("isspectating"):Connect(function()
        if flag20 then
            return
        end
        if localPlayer:GetAttribute("isspectating") then
            flag20 = true
            localPlayer:SetAttribute("isspectating", false)
            flag20 = false
        end
    end))
    table.insert(skipEndScreenConns, localPlayer:GetAttributeChangedSignal("killerend"):Connect(function()
        if flag20 then
            return
        end
        if localPlayer:GetAttribute("killerend") then
            flag20 = true
            localPlayer:SetAttribute("killerend", false)
            flag20 = false
        end
    end))
    local function fn157()
        local map4 = Workspace:FindFirstChild("Map")
        if map4 then
            local endscreen = map4:FindFirstChild("endscreen")
            if endscreen then
                pcall(function()
                    endscreen.Parent = nil
                end)
            end
        end
        local backgroundSounds = Workspace:FindFirstChild("BackgroundSounds")
        if backgroundSounds then
            pcall(function()
                backgroundSounds:Destroy()
            end)
        end
    end
    fn157()
    table.insert(skipEndScreenConns, Workspace.DescendantAdded:Connect(function(arg125)
        if arg125.Name == "endscreen" and arg125.Parent and arg125.Parent.Name == "Map" then
            task.wait(0.01)
            pcall(function()
                arg125.Parent = nil
            end)
        elseif arg125.Name == "BackgroundSounds" then
            pcall(function()
                arg125:Destroy()
            end)
        end
    end))
    local function fn158(gui)
        if not gui or not gui.Parent then
            return
        end
        pcall(function()
            if darknessMode and gui.Name == "Darkness" and gui:IsA("ScreenGui") then
                gui.Enabled = false
            end
            local function fn159(arg126)
                if arg126:IsA("VideoFrame") then
                    arg126:Destroy()
                elseif arg126:IsA("Frame") and (arg126.Name == "Frame2" or arg126.Name == "blackout") then
                    arg126.BackgroundTransparency = 1
                    if darknessMode then
                        arg126.Visible = false
                        arg126:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
                            if arg126.BackgroundTransparency < 1 then
                                arg126.BackgroundTransparency = 1
                            end
                        end)
                        arg126:GetPropertyChangedSignal("Visible"):Connect(function()
                            if arg126.Visible then
                                arg126.Visible = false
                            end
                        end)
                    end
                elseif arg126:IsA("ParticleEmitter") or arg126:IsA("Beam") or arg126:IsA("Trail") then
                    arg126.Enabled = false
                end
                for _, v90 in ipairs(arg126:GetChildren()) do
                    fn159(v90)
                end
            end
            fn159(gui)
        end)
    end
    for _, v91 in ipairs(playerGui:GetChildren()) do
        local n = v91.Name
        if n == "Darkness" or n == "EndScreen" or n == "Cutscene" or n == "Results" then
            fn158(v91)
        end
    end
    table.insert(skipEndScreenConns, playerGui.ChildAdded:Connect(function(arg127)
        local n = arg127.Name
        if n == "Darkness" or n == "EndScreen" or n == "Cutscene" or n == "Results" then
            task.wait(0.05)
            fn158(arg127)
        end
    end))
end
local function fn160()
    for _, v92 in ipairs(tbl2.skipEndScreenConns) do
        pcall(function()
            v92:Disconnect()
        end)
    end
    table.clear(tbl2.skipEndScreenConns)
end
local var587
local var588
do
    (function()
        local num26 = 80411309607666
        local color33 = Color3.fromRGB(248, 248, 255)
        local function fn161(player, char)
            if not player or not char then
                return nil
            end
            local values = char:FindFirstChild("Values")
            if values then
                local killerName = values:FindFirstChild("KillerName")
                if killerName and killerName:IsA("StringValue") and killerName.Value ~= "" then
                    return killerName.Value
                end
            end
            local var589 = player:GetAttribute("SelectedKiller")
            if typeof(var589) == "string" and var589 ~= "" then
                return var589
            end
            return nil
        end
        local function fn162(player)
            if not player or not player.Team then
                return false
            end
            local name6 = player.Team.Name
            return typeof(name6) == "string" and name6:lower():gsub("%s+", ""):find("spectator", 1, true) ~= nil
        end
        local var590 = setmetatable({}, {__mode = "k"})
        local var591 = setmetatable({}, {__mode = "k"})
        local function fn163(value)
            return tostring(value or ""):lower():gsub("[%s%-%_]", "")
        end
        local function fn164(value)
            local name = fn163(value)
            return name == "survimob" or name == "survivormob"
        end
        local function fn165(char)
            if not char then
                return false
            end
            if fn164(char.Name) then
                return true
            end
            local var592 = var590[char]
            if var592 then
                return var592.value
            end
            local num27 = 0
            for _, v93 in ipairs(char:GetChildren()) do
                if fn164(v93.Name) then
                    num27 = num27 + 1
                end
            end
            local tbl49 = {count = num27, value = num27 > 0}
            var590[char] = tbl49
            if not var591[char] then
                var591[char] = true
                char.ChildAdded:Connect(function(arg128)
                    if fn164(arg128.Name) then
                        local var593 = var590[char]
                        if var593 then
                            var593.count = var593.count + 1
                            var593.value = var593.count > 0
                        end
                    end
                end)
                char.ChildRemoved:Connect(function(arg129)
                    if fn164(arg129.Name) then
                        local var594 = var590[char]
                        if var594 then
                            var594.count = math.max(0, var594.count - 1)
                            var594.value = var594.count > 0
                        end
                    end
                end)
            end
            return tbl49.value
        end
        local function fn166(player, char)
            if player and player.Team then
                local var595 = fn163(player.Team.Name)
                if var595:find("spectator", 1, true) ~= nil or var595:find("survivor", 1, true) ~= nil then
                    return true
                end
            end
            if player and fn162(player) then
                return true
            end
            if fn165(char) then
                return true
            end
            return false
        end
        local function fn167(player)
            if not player or not player.Team or fn166(player, player.Character) then
                return false
            end
            local name7 = player.Team.Name
            return typeof(name7) == "string" and name7:lower():find("killer", 1, true) ~= nil
        end
        local function fn168(char)
            if not char or not char.Parent or fn165(char) then
                return false
            end
            local var596 = char:FindFirstChild("Killer-mob") or char:FindFirstChild("KillerMob") or char:FindFirstChild("killer-mob") or char:FindFirstChild("killerMob")
            if var596 then
                return true
            end
            return false
        end
        do
            local num28 = 12.5
            local num29 = 1.68
            local num30 = 3
            local num31 = 117070354890871
            local num32 = 111229698330816
            local num33 = 106871536134254
            local num34 = 109402730355822
            local tbl50 = {
                [num31] = {type = "masked_lungehold", length = 2, speed = 1},
                [num32] = {type = "maskedwalk", length = 0.87, speed = 1},
                [num33] = {type = "maskedattack", length = 3, speed = 1},
                [num34] = {type = "maskedattackdone", length = 2.95, speed = 1},
            }
            local num35 = 0.28
            local num36 = 0.45
            local num37 = 0.055
            local num38 = 0.055
            local tbl51 = {
                attack = {triggerLead = 0, reactionWindow = 0.34, predictionLead = 0.075, predictionExtra = 1.1},
                lungehold = {triggerLead = -0.006, reactionWindow = 0.42, predictionLead = 0.095, predictionExtra = 1.35},
            }
            local function fn169(profile)
                local var600 = profile and profile.type or "attack"
                return tbl51[var600] or tbl51.attack
            end
            local tbl52 = {
                [113255068724446] = {
                    type = "lungehold",
                    length = 1,
                    speed = 1,
                    triggerProgress = 0.018,
                    triggerTime = 0.018,
                    reactionWindow = 0.35,
                },
                [74968262036854] = {
                    type = "attack",
                    length = 1.7,
                    speed = 1,
                    triggerProgress = 0.018,
                    triggerTime = 0.03,
                    reactionWindow = 0.35,
                },
                [135002183282873] = {
                    type = "lungehold",
                    length = 1.5,
                    speed = 1,
                    triggerProgress = 0.015,
                    triggerTime = 0.022,
                    reactionWindow = 0.35,
                },
                [121216847022485] = {
                    type = "attack",
                    length = 1.75,
                    speed = 1,
                    triggerProgress = 0.015,
                    triggerTime = 0.025,
                    reactionWindow = 0.35,
                },
                [117042998468241] = {
                    type = "lungehold",
                    length = 1,
                    speed = 1,
                    triggerProgress = 0.008,
                    triggerTime = 0.008,
                    reactionWindow = 0.5,
                },
                [133963973694098] = {
                    type = "attack",
                    length = 1.72,
                    speed = 1,
                    triggerProgress = 0.006,
                    triggerTime = 0.01,
                    reactionWindow = 0.44,
                },
                [110355011987939] = {
                    type = "lungehold",
                    length = 1,
                    speed = 1,
                    triggerProgress = 0.012,
                    triggerTime = 0.012,
                    reactionWindow = 0.35,
                },
                [139369275981139] = {
                    type = "attack",
                    length = 1.72,
                    speed = 1,
                    triggerProgress = 0.014,
                    triggerTime = 0.022,
                    reactionWindow = 0.35,
                },
                [118907603246885] = {
                    type = "lungehold",
                    length = 0.83,
                    speed = 1,
                    triggerProgress = 0.01,
                    triggerTime = 0.01,
                    reactionWindow = 0.35,
                },
                [78432063483146] = {
                    type = "attack",
                    length = 1.72,
                    speed = 1,
                    triggerProgress = 0.018,
                    triggerTime = 0.025,
                    reactionWindow = 0.35,
                },
                [122812055447896] = {
                    type = "lungehold",
                    length = 0.75,
                    speed = 1,
                    triggerProgress = 0.01,
                    triggerTime = 0.008,
                    reactionWindow = 0.35,
                },
                [78935059863801] = {
                    type = "attack",
                    length = 1.63,
                    speed = 1,
                    triggerProgress = 0.016,
                    triggerTime = 0.022,
                    reactionWindow = 0.35,
                },
                [129784271201071] = {
                    type = "lungehold",
                    length = 1,
                    speed = 1,
                    triggerProgress = 0.015,
                    triggerTime = 0.015,
                    reactionWindow = 0.35,
                },
                [132817836308238] = {
                    type = "attack",
                    length = 1.72,
                    speed = 1,
                    triggerProgress = 0.017,
                    triggerTime = 0.025,
                    reactionWindow = 0.35,
                },
                [105374834496520] = {
                    type = "lungehold",
                    length = 1,
                    speed = 1,
                    triggerProgress = 0.01,
                    triggerTime = 0.01,
                    reactionWindow = 0.35,
                },
                [111920872708571] = {
                    type = "attack",
                    length = 1.72,
                    speed = 1,
                    triggerProgress = 0.014,
                    triggerTime = 0.022,
                    reactionWindow = 0.35,
                },
                [115244153053858] = {
                    type = "lungehold",
                    length = 1,
                    speed = 1,
                    triggerProgress = 0.01,
                    triggerTime = 0.01,
                    reactionWindow = 0.35,
                },
                [130593238885843] = {
                    type = "attack",
                    length = 1.7,
                    speed = 1,
                    triggerProgress = 0.012,
                    triggerTime = 0.02,
                    reactionWindow = 0.35,
                },
                [138720291317243] = {
                    type = "attack",
                    length = 1.72,
                    speed = 1,
                    triggerProgress = 0.12,
                    triggerTime = 0.12,
                    reactionWindow = 0.35,
                },
            }
            local function fn170(animId)
                if typeof(animId) ~= "string" then
                    return nil
                end
                return tonumber(animId:match("%d+"))
            end
            local function fn171(player, char)
                if not player or not char then
                    return nil
                end
                local values2 = char:FindFirstChild("Values")
                if values2 then
                    local killerName2 = values2:FindFirstChild("KillerName")
                    if killerName2 and killerName2:IsA("StringValue") and killerName2.Value ~= "" then
                        return killerName2.Value
                    end
                end
                local var601 = player:GetAttribute("SelectedKiller")
                if typeof(var601) == "string" and var601 ~= "" then
                    return var601
                end
                return nil
            end
            local function fn172(player)
                if not player then
                    return false
                end
                local team2 = player.Team
                if not team2 then
                    return false
                end
                local name8 = team2.Name
                if typeof(name8) ~= "string" then
                    return false
                end
                return name8:lower():find("killer") ~= nil
            end
            local function fn173(char)
                if not char or not char.Parent then
                    return false
                end
                local var602 = char:FindFirstChild("Killer-mob") or char:FindFirstChild("KillerMob") or char:FindFirstChild("killer-mob") or char:FindFirstChild("killerMob")
                if var602 then
                    return true
                end
                return false
            end
            local var603 = nil
            local function fn174()
                if var603 and var603.Parent and var603:IsA("ImageButton") then
                    return var603
                end
                local survivorMob7 = playerGui:FindFirstChild("Survivor-mob")
                local var604 = survivorMob7 and survivorMob7:FindFirstChild("Controls")
                local var605 = var604 and var604:FindFirstChild("Gui-mob")
                if var605 and var605:IsA("ImageButton") then
                    var603 = var605
                    return var605
                end
                var603 = nil
                return nil
            end
            local function fn175()
                local char = localPlayer.Character
                if not char then
                    return
                end
                local var606 = fn174()
                local flag21 = false
                if var606 and type(firesignal) == "function" then
                    flag21 = pcall(function()
                        firesignal(var606.MouseButton1Down)
                        task.delay(0.05, function()
                            if var606 and var606.Parent then
                                firesignal(var606.MouseButton1Up)
                            end
                        end)
                    end)
                end
                if not flag21 and type(getconnections) == "function" then
                    local var607, obj = pcall(function()
                        local o = Instance.new("InputObject")
                        o.UserInputType = Enum.UserInputType.MouseButton2
                        o.UserInputState = Enum.UserInputState.Begin
                        return o
                    end)
                    if var607 and obj then
                        pcall(function()
                            for _, v94 in ipairs(getconnections(UserInputService.InputBegan)) do
                                v94:Fire(obj, false)
                            end
                        end)
                        flag21 = true
                    end
                end
                if not flag21 then
                    pcall(function()
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
                        task.delay(0.01, function()
                            pcall(function()
                                VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
                            end)
                        end)
                    end)
                end
                local humanoidRootPart12 = char:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart12 then
                    task.defer(function()
                        pcall(function()
                            if CollectionService:HasTag(humanoidRootPart12, "doing action") then
                                CollectionService:RemoveTag(humanoidRootPart12, "doing action")
                            end
                        end)
                    end)
                end
            end
            local num39 = 0.35
            local num40 = 0.22
            local function fn176(arg130, arg131)
                local var608 = math.max(tbl2.num131 or 0, tbl2.num133 or 0)
                local var609 = arg131 or num39
                if var608 > 0 and arg130 - var608 < var609 then
                    return false
                end
                return true
            end
            local function fn177(part)
                if not part then
                    return nil
                end
                local var610 = part
                for _ = 1, 6 do
                    if not var610 then
                        break
                    end
                    local name = string.lower(var610.Name or "")
                    if name:find("pallet", 1, true) or name:find("plank", 1, true) then
                        if var610:IsA("Model") then
                            return var610
                        end
                        local parent6 = var610.Parent
                        if parent6 and parent6:IsA("Model") then
                            return parent6
                        end
                    end
                    var610 = var610.Parent
                end
                return nil
            end
            local function fn178(model)
                if not model or not model.Parent then
                    return false
                end
                local var612, _, size = pcall(function()
                    local var611, bounds = model:GetBoundingBox()
                    return var611, bounds
                end)
                if not var612 or not size then
                    return false
                end
                local var613 = math.max(size.X, size.Z, 0.01)
                return size.Y >= var613 * 0.5
            end
            local function fn179(hitPart)
                local model = fn177(hitPart)
                if not model then
                    return nil
                end
                return {model = model, standing = fn178(model), dropped = not fn178(model)}
            end
            local function fn180(arg132, target, extraIgnore)
                local character12 = localPlayer.Character
                local raycastParams2 = RaycastParams.new()
                raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
                raycastParams2.FilterDescendantsInstances = {character12, extraIgnore}
                raycastParams2.IgnoreWater = true
                local var614 = target - arg132
                if var614.Magnitude <= 0.05 then
                    return {
                        clear = true,
                        blocked = false,
                        vault = false,
                        pallet = false,
                        standingPallet = false,
                        droppedPallet = false,
                        clearCount = 1,
                        blockedCount = 0,
                        directBlocked = false,
                    }
                end
                local vector38 = Vector3.new(var614.X, 0, var614.Z)
                local var615 = vector38.Magnitude > 0.05 and vector38.Unit or Vector3.zero
                local var616 = var615:Cross(Vector3.new(0, 1, 0))
                local num41 = 0.9
                local num42 = 0.75
                local tbl53 = {
                    {arg132, target, true},
                    {arg132 + var616 * num41, target + var616 * num41, false},
                    {arg132 - var616 * num41, target - var616 * num41, false},
                    {arg132 + Vector3.new(0, num42, 0), target + Vector3.new(0, num42, 0), false},
                    {arg132 - Vector3.new(0, num42, 0), target - Vector3.new(0, num42, 0), false},
                }
                local var617 = character12 and character12:FindFirstChild("Head")
                local var618 = extraIgnore and extraIgnore:FindFirstChild("Head")
                if var617 and var618 then
                    table.insert(tbl53, {var617.Position, var618.Position, false})
                end
                local clearCount = 0
                local blockedCount = 0
                local flag22 = false
                local flag23 = false
                local flag24 = false
                local flag25 = false
                local palletBlockedCount = 0
                local directBlocked = false
                for _, v95 in ipairs(tbl53) do
                    local var619 = Workspace:Raycast(v95[1], v95[2] - v95[1], raycastParams2)
                    if not var619 then
                        clearCount = clearCount + 1
                    else
                        blockedCount = blockedCount + 1
                        if v95[3] then
                            directBlocked = true
                        end
                        local instance = var619.Instance
                        if instance then
                            local n = string.lower(instance.Name or "")
                            if n:find("vault", 1, true) or n:find("window", 1, true) or n:find("ledge", 1, true) then
                                flag22 = true
                            end
                            if n:find("pallet", 1, true) or n:find("plank", 1, true) then
                                flag23 = true
                                palletBlockedCount = palletBlockedCount + 1
                                local pallet = fn179(instance)
                                if pallet then
                                    if pallet.standing then
                                        flag24 = true
                                    else
                                        flag25 = true
                                    end
                                end
                            end
                        end
                    end
                end
                local var620 = #tbl53
                local clear = clearCount >= math.max(4, math.ceil(var620 * 0.66))
                local blocked = blockedCount >= math.ceil(var620 * 0.5)
                return {
                    clear = clear,
                    blocked = blocked,
                    vault = flag22,
                    pallet = flag23,
                    standingPallet = flag24,
                    droppedPallet = flag25,
                    palletBlockedCount = palletBlockedCount,
                    clearCount = clearCount,
                    blockedCount = blockedCount,
                    directBlocked = directBlocked,
                }
            end
            local function fn181(force, character13, arg133, allowPredictedRange, allowEdgePulse)
                if not tbl2.flag116 then
                    return false
                end
                local now6 = tick()
                local var621 = character13 and tbl2.list7[character13]
                local var622 = var621 and var621.profile ~= nil
                local var623 = var622 and num40 or num39
                if not fn176(now6, var623) then
                    return false
                end
                if character13 and arg133 then
                    local var624 = tbl2.num130
                    local flag26 = false
                    local var625 = var621
                    if var625 and var625.profile and var625.profile.type == "lungehold" then
                        flag26 = true
                    end
                    if arg133 > var624 and not allowPredictedRange then
                        return false
                    end
                    local character14 = localPlayer.Character
                    local var626 = character14 and character14:FindFirstChild("HumanoidRootPart")
                    local humanoidRootPart13 = character13:FindFirstChild("HumanoidRootPart")
                    if not var626 or not humanoidRootPart13 then
                        return false
                    end
                    local var627 = fn180(var626.Position, humanoidRootPart13.Position, character13)
                    local flag27 = false
                    if allowEdgePulse then
                        flag27 = var627.clearCount >= 3 and var627.blockedCount >= 1 and var627.blockedCount <= math.ceil(4.5)
                    end
                    if var627.directBlocked and not flag27 then
                        return false
                    end
                    if (var627.blocked or not var627.clear) and not flag27 then
                        return false
                    end
                end
                tbl2.num131 = now6
                tbl2.num133 = now6
                fn175()
                return true
            end
            local function fn182()
                if not tbl2.flag116 then
                    return false
                end
                local now7 = tick()
                if not fn176(now7) then
                    return false
                end
                tbl2.num133 = now7
                tbl2.num131 = now7
                fn175()
                return true
            end
            local function fn183(char)
                local character15 = localPlayer.Character
                local var628 = character15 and character15:FindFirstChild("HumanoidRootPart")
                local var629 = char and char:FindFirstChild("HumanoidRootPart")
                if not var628 or not var629 then
                    return math.huge
                end
                local position8 = var628.Position
                local position9 = var629.Position
                return (Vector3.new(position8.X, 0, position8.Z) - Vector3.new(position9.X, 0, position9.Z)).Magnitude
            end
            local function fn184(char, maxTime)
                local character16 = localPlayer.Character
                local var630 = character16 and character16:FindFirstChild("HumanoidRootPart")
                local var631 = char and char:FindFirstChild("HumanoidRootPart")
                if not var630 or not var631 then
                    return math.huge
                end
                local position10 = var630.Position
                local position11 = var631.Position
                local assemblyLinearVelocity = var630.AssemblyLinearVelocity
                local assemblyLinearVelocity2 = var631.AssemblyLinearVelocity
                local vector39 = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
                local vector310 = Vector3.new(assemblyLinearVelocity2.X, 0, assemblyLinearVelocity2.Z)
                local ping = math.clamp(localPlayer:GetNetworkPing(), 0, 0.3)
                local var632 = ping + 0.04
                local huge5 = math.huge
                local tbl54 = {
                    math.clamp(var632, 0, maxTime),
                    math.clamp(var632 + 0.05, 0, maxTime),
                    math.clamp(var632 + 0.1, 0, maxTime),
                    math.clamp(var632 + 0.16, 0, maxTime),
                    math.clamp(var632 + 0.22, 0, maxTime),
                    math.clamp(var632 + 0.3, 0, maxTime),
                    math.clamp(var632 + 0.38, 0, maxTime),
                }
                for _, v96 in ipairs(tbl54) do
                    local var633 = position10 + vector39 * v96
                    local var634 = position11 + vector310 * v96
                    local magnitude7 = (Vector3.new(var633.X, 0, var633.Z) - Vector3.new(var634.X, 0, var634.Z)).Magnitude
                    if magnitude7 < huge5 then
                        huge5 = magnitude7
                    end
                end
                return huge5
            end
            local function fn185(char)
                local character17 = localPlayer.Character
                local var635 = character17 and character17:FindFirstChild("HumanoidRootPart")
                local var636 = char and char:FindFirstChild("HumanoidRootPart")
                if not var635 or not var636 then
                    return math.huge
                end
                local position12 = var635.Position
                local position13 = var636.Position
                local assemblyLinearVelocity3 = var635.AssemblyLinearVelocity
                local assemblyLinearVelocity4 = var636.AssemblyLinearVelocity
                local vector311 = Vector3.new(assemblyLinearVelocity3.X, 0, assemblyLinearVelocity3.Z)
                local vector312 = Vector3.new(assemblyLinearVelocity4.X, 0, assemblyLinearVelocity4.Z)
                local lookVector4 = var636.CFrame.LookVector
                local vector313 = Vector3.new(lookVector4.X, 0, lookVector4.Z)
                if vector313.Magnitude > 0.05 then
                    vector313 = vector313.Unit
                else
                    vector313 = Vector3.zero
                end
                local magnitude8 = vector312.Magnitude
                if magnitude8 > 0.05 and vector313.Magnitude > 0 then
                    local var637 = vector312:Dot(vector313)
                    if var637 > 0 then
                        vector312 = vector312 + vector313 * math.min(var637 * 0.45, 6)
                    end
                end
                local var638 = position13 - position12
                local vector314 = Vector3.new(var638.X, 0, var638.Z)
                local magnitude9 = vector314.Magnitude
                if magnitude9 <= 0.05 then
                    return 0
                end
                local unit2 = vector314.Unit
                local var639 = vector312 - vector311
                local var640 = math.max(0, var639:Dot(unit2))
                local ping = math.clamp(localPlayer:GetNetworkPing(), 0, 0.3)
                local var641 = ping + 0.025
                local var642 = magnitude9
                local tbl55 = {
                    var641,
                    var641 + 0.02,
                    var641 + 0.04,
                    var641 + 0.07,
                    var641 + 0.1,
                    var641 + 0.14,
                    var641 + 0.19,
                    var641 + 0.25,
                    var641 + 0.32,
                    var641 + 0.4,
                    var641 + 0.5,
                    var641 + 0.6,
                }
                for _, t in ipairs(tbl55) do
                    local var643 = position12 + vector311 * t
                    local var644 = position13 + vector312 * t
                    local magnitude10 = (Vector3.new(var643.X, 0, var643.Z) - Vector3.new(var644.X, 0, var644.Z)).Magnitude
                    if magnitude10 < var642 then
                        var642 = magnitude10
                    end
                end
                if var640 > 0 then
                    local var645 = math.max(magnitude9 - tbl2.num130, 0) / var640
                    if var645 <= 0.55 then
                        var642 = math.min(var642, tbl2.num130 - 0.05)
                    end
                end
                return var642
            end
            local num43 = 0.24
            local num44 = -0.2
            local num45 = 2
            local num46 = 1.35
            local num47 = 0.18
            local tbl56 = {list28 = nil, killers = {}}
            local tbl57 = {list28 = nil, killers = {}}
            local num48 = 42
            local num49 = 0.1
            local num50 = 0.16
            local num51 = 0.16
            local num52 = 1.35
            local tbl58 = {look = nil, num165 = 0, num166 = 0}
            local function fn186(arg134, arg135)
                if not arg134 then
                    return false
                end
                local look = arg134.CFrame.LookVector
                local vector315 = Vector3.new(look.X, 0, look.Z)
                if vector315.Magnitude <= 0.001 then
                    return arg135 <= tbl58.num166
                end
                vector315 = vector315.Unit
                if not tbl58.look then
                    tbl58.look = vector315
                    tbl58.num165 = arg135
                    return false
                end
                if arg135 - tbl58.num165 >= num49 then
                    local var647 = arg135 - tbl58.num165
                    local dot = math.clamp(tbl58.look:Dot(vector315), -1, 1)
                    local var648 = math.deg(math.acos(dot))
                    if var647 <= num50 and var648 >= num48 then
                        tbl58.num166 = arg135 + num51
                    end
                    tbl58.look = vector315
                    tbl58.num165 = arg135
                end
                return arg135 <= tbl58.num166
            end
            local function fn187(arg136)
                if not arg136 then
                    return Vector3.zero
                end
                local assemblyLinearVelocity5 = arg136.AssemblyLinearVelocity
                return Vector3.new(assemblyLinearVelocity5.X, 0, assemblyLinearVelocity5.Z)
            end
            local function fn188(arg137, arg138, arg139)
                local now8 = tick()
                local var649 = fn187(arg138)
                local killerVel = fn187(arg139)
                local var650 = tbl56.list28
                local var651 = tbl56.killers[arg137]
                tbl56.list28 = {velocity = var649, time = now8}
                tbl56.killers[arg137] = {velocity = killerVel, time = now8}
                return var650, var651, now8, var649, killerVel
            end
            local function fn189(character18, arg140, arg141)
                local character19 = localPlayer.Character
                local var652 = character19 and character19:FindFirstChild("HumanoidRootPart")
                local var653 = character18 and character18:FindFirstChild("HumanoidRootPart")
                if not var652 or not var653 then
                    return false
                end
                local var654, var655, var656, var657, killerVel = fn188(character18, var652, var653)
                local flag28 = false
                local flag29 = false
                if var654 and var656 - var654.time <= num43 and var654.velocity.Magnitude >= num45 and var657.Magnitude >= num45 then
                    local dot = var654.velocity.Unit:Dot(var657.Unit)
                    flag28 = dot <= num44
                end
                if var655 and var656 - var655.time <= num43 and var655.velocity.Magnitude >= num45 and killerVel.Magnitude >= num45 then
                    local dot = var655.velocity.Unit:Dot(killerVel.Unit)
                    flag29 = dot <= num44
                end
                local var658 = character19 and character19:FindFirstChildOfClass("Humanoid")
                local var659 = var658 and var658:GetState()
                local var660 = var659 == Enum.HumanoidStateType.Landed or var659 == Enum.HumanoidStateType.Running or var659 == Enum.HumanoidStateType.RunningNoPhysics
                local flag30 = false
                if var658 then
                    local Y2 = var652.AssemblyLinearVelocity.Y
                    flag30 = math.abs(Y2) >= 7 or var659 == Enum.HumanoidStateType.Freefall or var659 == Enum.HumanoidStateType.Jumping
                end
                if not (flag28 or flag29 or flag30) then
                    return false
                end
                if arg140 > tbl2.num130 + num46 then
                    return false
                end
                local var661 = var652.Position - var653.Position
                local vector316 = Vector3.new(var661.X, 0, var661.Z)
                if vector316.Magnitude <= 0.05 then
                    return true
                end
                local unit3 = vector316.Unit
                local var662 = var657
                if flag28 and var654 then
                    var662 = var654.velocity * 0.55 + var657 * 0.45
                end
                local var663 = killerVel
                if flag29 and var655 then
                    var663 = var655.velocity * 0.55 + killerVel * 0.45
                end
                local var664 = var663 - var662
                local var665 = var664:Dot(unit3)
                local var666 = var652.Position + var662 * num47
                local var667 = var653.Position + var663 * num47
                local magnitude11 = (Vector3.new(var666.X, 0, var666.Z) - Vector3.new(var667.X, 0, var667.Z)).Magnitude
                if magnitude11 <= tbl2.num130 + 0.55 then
                    return true
                end
                if var665 >= 0.75 and (arg141 <= tbl2.num130 + num46 or arg140 <= tbl2.num130 + 0.55) then
                    return true
                end
                if var660 and flag30 and arg140 <= tbl2.num130 + 0.65 then
                    return true
                end
                return false
            end
            local function fn190()
                local var668 = math.clamp(tbl2.num134, -1, 1)
                return 0.1 + (var668 + 1) / 2 * 0.55
            end
            local flag31 = true
            local num53 = 0.14
            local num54 = 0.65
            local num55 = 1.25
            local num56 = 0.12
            local function fn191(character20)
                if not flag31 then
                    return false
                end
                local character21 = localPlayer.Character
                local var669 = character21 and character21:FindFirstChild("HumanoidRootPart")
                local var670 = character20 and character20:FindFirstChild("HumanoidRootPart")
                if not var669 or not var670 then
                    return false
                end
                local var671 = var669.Position - var670.Position
                local vector317 = Vector3.new(var671.X, 0, var671.Z)
                local magnitude12 = vector317.Magnitude
                if magnitude12 <= 0.05 then
                    return true
                end
                local unit4 = vector317.Unit
                local assemblyLinearVelocity6 = var670.AssemblyLinearVelocity
                local assemblyLinearVelocity7 = var669.AssemblyLinearVelocity
                local vector318 = Vector3.new(assemblyLinearVelocity6.X, 0, assemblyLinearVelocity6.Z)
                local vector319 = Vector3.new(assemblyLinearVelocity7.X, 0, assemblyLinearVelocity7.Z)
                local var672 = vector318 - vector319
                local var673 = var672:Dot(unit4)
                local var674 = var670.Position + vector318 * num53
                local var675 = var669.Position + vector319 * num53
                local var676 = var675 - var674
                local magnitude13 = Vector3.new(var676.X, 0, var676.Z).Magnitude
                if var673 >= num54 and magnitude13 < magnitude12 then
                    return true
                end
                if vector318.Magnitude >= num55 then
                    local var677 = vector318.Unit:Dot(unit4)
                    if var677 >= num56 and magnitude13 < magnitude12 then
                        return true
                    end
                end
                local magnitude14 = (vector318 - vector319).Magnitude
                if vector318.Magnitude >= num55 and magnitude14 >= 0.65 and magnitude13 < magnitude12 then
                    return true
                end
                return false
            end
            local function fn192(character22)
                local character23 = localPlayer.Character
                local var678 = character23 and character23:FindFirstChild("HumanoidRootPart")
                local var679 = character22 and character22:FindFirstChild("HumanoidRootPart")
                if not var678 or not var679 then
                    return false
                end
                local var680 = var678.Position - var679.Position
                local vector320 = Vector3.new(var680.X, 0, var680.Z)
                if vector320.Magnitude <= 0.05 then
                    return true
                end
                local look = var679.CFrame.LookVector
                local vector321 = Vector3.new(look.X, 0, look.Z)
                if vector321.Magnitude <= 0.05 then
                    return true
                end
                local dot = vector321.Unit:Dot(vector320.Unit)
                local var681 = fn190()
                local var682 = math.clamp(tbl2.num134, -1, 1)
                local var683 = (var682 + 1) / 2
                local var684 = 80 - var683 * 42
                local var685 = math.cos(math.rad(var684))
                if dot >= math.max(var681, var685) then
                    return true
                end
                local velocity = var679.AssemblyLinearVelocity
                local vector322 = Vector3.new(velocity.X, 0, velocity.Z)
                if vector322.Magnitude > 6 then
                    local var686 = vector322.Unit:Dot(vector320.Unit)
                    local var687 = 0.2 + var683 * 0.35
                    if var686 >= var687 then
                        return true
                    end
                end
                return false
            end
            local num57 = 0.75
            local num58 = 4.25
            local num59 = 0.24
            local num60 = 0.9
            local num61 = 0.045
            local function fn193(character24, arg142, arg143, arg144)
                if not character24 or not arg142 then
                    return false
                end
                local character25 = localPlayer.Character
                local var688 = character25 and character25:FindFirstChild("HumanoidRootPart")
                local humanoidRootPart14 = character24:FindFirstChild("HumanoidRootPart")
                if not var688 or not humanoidRootPart14 then
                    return false
                end
                local assemblyLinearVelocity8 = humanoidRootPart14.AssemblyLinearVelocity
                local assemblyLinearVelocity9 = var688.AssemblyLinearVelocity
                local vector323 = Vector3.new(assemblyLinearVelocity8.X, 0, assemblyLinearVelocity8.Z)
                local vector324 = Vector3.new(assemblyLinearVelocity9.X, 0, assemblyLinearVelocity9.Z)
                local vector325 = Vector3.new(var688.Position.X - humanoidRootPart14.Position.X, 0, var688.Position.Z - humanoidRootPart14.Position.Z)
                local magnitude15 = vector325.Magnitude
                if magnitude15 <= 0.05 then
                    return true
                end
                local unit5 = vector325.Unit
                local var689 = vector324 - vector323
                local var690 = math.max(0, var689:Dot(-unit5))
                local ping = math.clamp(localPlayer:GetNetworkPing(), 0, 0.45)
                local var691 = math.clamp(ping * 0.5, 0.025, num59)
                local lead = var691 + num61
                local var692 = math.max(0, vector323:Dot(unit5))
                local var693 = var692 * lead
                local var694 = math.max(0, vector324:Dot(-unit5))
                local var695 = var694 * lead
                local var696 = num57 + math.min(var693 + var695, num58 - num57)
                var696 = var696 + math.min(var690 * lead * num60, 1.35)
                var696 = math.clamp(var696, num57, num58)
                local var697 = arg142 - var696
                local var698 = (arg143 or math.huge) - var696 * 0.65
                local var699 = var690 >= 2 or arg144 and arg144 >= 2 or var692 >= 2
                if not var699 then
                    return false
                end
                return var697 <= tbl2.num130 or var698 <= tbl2.num130
            end
            local function fn194(character26, arg145, arg146, arg147)
                if arg145 > tbl2.num130 then
                    if fn191(character26) then
                        return true
                    end
                    if fn189(character26, arg145, arg147) then
                        return true
                    end
                    if fn193(character26, arg145, arg147, arg146) then
                        return true
                    end
                    return false
                end
                if fn189(character26, arg145, arg147) then
                    return true
                end
                if fn193(character26, arg145, arg147, arg146) then
                    return true
                end
                if fn191(character26) then
                    return true
                end
                if arg146 and arg147 then
                    if arg146 >= 3.5 and arg147 <= tbl2.num130 then
                        return true
                    end
                end
                local character27 = localPlayer.Character
                local var700 = character26 and character26:FindFirstChild("HumanoidRootPart")
                local var701 = character27 and character27:FindFirstChild("HumanoidRootPart")
                if var701 and var700 then
                    local var702 = var701.Position - var700.Position
                    local vector326 = Vector3.new(var702.X, 0, var702.Z)
                    if vector326.Magnitude > 0.05 then
                        local velocity = var700.AssemblyLinearVelocity
                        local vector327 = Vector3.new(velocity.X, 0, velocity.Z)
                        if vector327.Magnitude >= 2 then
                            local var703 = vector327.Unit:Dot(vector326.Unit)
                            if var703 >= 0.25 then
                                return true
                            end
                        end
                    end
                end
                if fn192(character26) then
                    return true
                end
                local character28 = localPlayer.Character
                local var704 = character28 and character28:FindFirstChild("HumanoidRootPart")
                local var705 = character26 and character26:FindFirstChild("HumanoidRootPart")
                if not var704 or not var705 then
                    return false
                end
                local var706 = var704.Position - var705.Position
                local vector328 = Vector3.new(var706.X, 0, var706.Z)
                if vector328.Magnitude <= 2 then
                    return true
                end
                return false
            end
            local function fn195(char, arg148, track)
                if tbl2.flag118 then
                    return
                end
                local tbl59 = {
                    name = arg148 or "The Abysswalker",
                    track = track,
                    type = "abysswalker",
                    started = tick(),
                    flag167 = false,
                    skillId = num26,
                }
                tbl2.list8[char] = tbl59
                local var707
                var707 = track.Stopped:Connect(function()
                    if var707 then
                        var707:Disconnect()
                        var707 = nil
                    end
                    task.defer(function()
                        if tbl2.list8[char] and tbl2.list8[char].track == track then
                            tbl2.list8[char] = nil
                        end
                    end)
                end)
                local var708 = fn183(char)
                if var708 <= num28 then
                    if fn182() then
                        tbl59.flag167 = true
                    end
                end
            end
            local function fn196(char)
                local tbl60 = {}
                local var709 = char and char:FindFirstChildOfClass("Humanoid")
                local var710 = var709 and var709:FindFirstChildOfClass("Animator")
                if not var710 then
                    return tbl60
                end
                for _, track in ipairs(var710:GetPlayingAnimationTracks()) do
                    if track and track.IsPlaying and track.Animation then
                        local id = fn170(track.Animation.AnimationId)
                        if id == num32 then
                            tbl60[track] = true
                        end
                    end
                end
                return tbl60
            end
            local function fn197(char)
                tbl2.list10[char] = nil
                tbl2.list9[char] = nil
            end
            local function fn198(char)
                return fn185(char)
            end
            local function fn199(char, arg149)
                if not char or not char.Parent or not arg149 then
                    return false
                end
                if tbl2.flag119 or arg149.flag167 or not arg149.flag168 or not arg149.flag169 or not arg149.flag170 then
                    return false
                end
                local var711 = fn183(char)
                if var711 <= tbl2.num130 then
                    return true
                end
                local var712 = fn198(char)
                if var712 <= tbl2.num130 then
                    return true
                end
                local character29 = localPlayer.Character
                local var713 = character29 and character29:FindFirstChild("HumanoidRootPart")
                local var714 = char and char:FindFirstChild("HumanoidRootPart")
                if var713 and var714 then
                    local var715 = var714.Position - var713.Position
                    local vector329 = Vector3.new(var715.X, 0, var715.Z)
                    if vector329.Magnitude > 0.05 then
                        local assemblyLinearVelocity10 = var713.AssemblyLinearVelocity
                        local assemblyLinearVelocity11 = var714.AssemblyLinearVelocity
                        local vector330 = Vector3.new(assemblyLinearVelocity11.X - assemblyLinearVelocity10.X, 0, assemblyLinearVelocity11.Z - assemblyLinearVelocity10.Z)
                        local var716 = math.max(0, vector330:Dot(vector329.Unit))
                        if var716 >= 3 then
                            local var717 = math.max(var711 - tbl2.num130, 0) / var716
                            if var717 <= 0.25 then
                                return true
                            end
                        end
                    end
                end
                return false
            end
            local function fn200(char, arg150)
                if not char or not char.Parent or not arg150 then
                    return false
                end
                if tbl2.flag119 or arg150.flag167 or not arg150.flag168 then
                    return false
                end
                local var718 = fn183(char)
                local var719 = fn198(char)
                if var718 <= tbl2.num130 then
                    if fn181(true, char, var718) then
                        arg150.flag167 = true
                        arg150.flag171 = true
                        fn197(char)
                        return true
                    end
                    return false
                end
                if var719 <= tbl2.num130 then
                    if fn181(true, char, var718, true) then
                        arg150.flag167 = true
                        arg150.flag171 = true
                        fn197(char)
                        return true
                    end
                end
                return false
            end
            local function fn201(char, arg151)
                if not arg151 or arg151.flag167 or not arg151.flag168 or not arg151.flag169 or not arg151.flag170 then
                    return false
                end
                if not fn199(char, arg151) then
                    return false
                end
                local var720 = fn183(char)
                if var720 <= tbl2.num130 then
                    if fn181(true, char, var720) then
                        arg151.flag167 = true
                        arg151.flag171 = true
                        fn197(char)
                        return true
                    end
                else
                    local var721 = fn198(char)
                    if var721 <= tbl2.num130 then
                        if fn181(true, char, var720, true) then
                            arg151.flag167 = true
                            arg151.flag171 = true
                            fn197(char)
                            return true
                        end
                    end
                end
                return false
            end
            local function fn202(arg152, track)
                if not arg152 or not track or arg152.flag167 then
                    return false
                end
                if arg152.list29 and arg152.list29[track] then
                    return false
                end
                if arg152.lungeTrack == track then
                    return false
                end
                return true
            end
            local function fn203(char, arg153, track)
                if not arg153 or arg153.flag167 or not track then
                    return false
                end
                if not fn202(arg153, track) then
                    return false
                end
                if tick() > arg153.expires then
                    return false
                end
                if not arg153.flag168 or not arg153.flag169 then
                    arg153.field37 = track
                    return false
                end
                arg153.list29 = arg153.list29 or {}
                arg153.list29[track] = true
                arg153.walkTrack = track
                arg153.now21 = tick()
                arg153.flag170 = true
                arg153.flag172 = true
                fn201(char, arg153)
                return true
            end
            local function fn204(char, arg154, track, profile, animId)
                if tbl2.flag119 then
                    return
                end
                local var722 = typeof(animId) == "number" and animId or fn170(track.Animation and track.Animation.AnimationId)
                if not var722 then
                    return
                end
                if var722 == num31 then
                    local now9 = tick()
                    local length2 = track.Length
                    if not length2 or length2 <= 0 then
                        length2 = tbl50[num31].length
                    end
                    local tbl61 = {
                        flag173 = false,
                        now22 = nil,
                        expires = now9 + num30,
                        lungeTrack = track,
                        flag168 = false,
                        flag169 = false,
                        num167 = 0,
                        lungeLength = length2,
                        now23 = nil,
                        walkTrack = nil,
                        field37 = nil,
                        now21 = nil,
                        flag170 = false,
                        flag172 = false,
                        flag167 = false,
                        flag171 = false,
                        list29 = {},
                    }
                    tbl2.list10[char] = tbl61
                    tbl2.list9[char] = tbl61
                    local var723
                    var723 = track.Stopped:Connect(function()
                        if var723 then
                            var723:Disconnect()
                            var723 = nil
                        end
                        task.defer(function()
                            if tbl2.list10[char] ~= tbl61 then
                                return
                            end
                            tbl61.flag169 = true
                            tbl61.now23 = tick()
                            local var724 = fn196(char)
                            for walkTrack in pairs(var724) do
                                fn203(char, tbl61, walkTrack)
                                if tbl2.list10[char] ~= tbl61 then
                                    return
                                end
                            end
                            if tbl61.field37 and tbl61.field37.IsPlaying then
                                fn203(char, tbl61, tbl61.field37)
                            end
                            if not tbl61.flag168 then
                                fn197(char)
                            end
                        end)
                    end)
                    return
                end
                if var722 == num32 then
                    local var725 = tbl2.list10[char]
                    if var725 then
                        if var725.lungeTrack and var725.lungeTrack.IsPlaying then
                            var725.field37 = track
                        else
                            var725.flag169 = true
                            fn203(char, var725, track)
                        end
                    end
                    return
                end
                if var722 == num33 or var722 == num34 then
                    return
                end
            end
            local function fn205()
                if not tbl2.flag116 then
                    return
                end
                for k8, v97 in pairs(tbl2.list10) do
                    if not k8 or not k8.Parent or not v97 then
                        fn197(k8)
                    elseif v97.flag167 then
                        fn197(k8)
                    elseif tick() > v97.expires then
                        fn197(k8)
                    else
                        local lungeTrack = v97.lungeTrack
                        if lungeTrack then
                            if lungeTrack.IsPlaying then
                                local var726 = lungeTrack.TimePosition or 0
                                v97.num167 = var726
                                if var726 >= num29 then
                                    v97.flag168 = true
                                    if not v97.flag173 then
                                        v97.flag173 = true
                                        v97.now22 = tick()
                                        tbl2.list9[k8] = v97
                                    end
                                    if fn200(k8, v97) then
                                        continue
                                    end
                                end
                            elseif v97.flag168 then
                                v97.flag169 = true
                                local var727 = fn183(k8)
                                local var728 = fn198(k8)
                                if var727 <= tbl2.num130 or var728 <= tbl2.num130 then
                                    if fn200(k8, v97) then
                                        continue
                                    end
                                end
                            end
                        end
                        if v97.flag169 and v97.flag168 then
                            if v97.field37 and v97.field37.IsPlaying then
                                fn203(k8, v97, v97.field37)
                                if not tbl2.list10[k8] then
                                    continue
                                end
                            end
                            local var729 = fn196(k8)
                            for walkTrack in pairs(var729) do
                                fn203(k8, v97, walkTrack)
                                if not tbl2.list10[k8] then
                                    break
                                end
                            end
                            local var730 = tbl2.list10[k8]
                            if var730 and var730.flag170 then
                                fn201(k8, var730)
                            end
                        end
                    end
                end
            end
            local tbl62 = {}
            local function fn206(char)
                tbl62[char] = nil
                tbl2.killerCharacters[char] = nil
                tbl2.list7[char] = nil
                tbl2.list8[char] = nil
                tbl2.list9[char] = nil
                tbl2.list10[char] = nil
            end
            local function fn207(player, char)
                if not player or not char or player == localPlayer then
                    return
                end
                if tbl62[char] then
                    return
                end
                tbl62[char] = true
                local var731 = fn171(player, char) or "Unknown Killer"
                local function fn208()
                    if not char.Parent then
                        return false
                    end
                    local var732 = fn171(player, char)
                    local var733 = fn172(player)
                    local var734 = tbl2.killerCharacters[char]
                    if var732 then
                        var731 = var732
                        if not var734 then
                            tbl2.killerCharacters[char] = {player = player, name = var731}
                        else
                            var734.player = player
                            var734.name = var731
                        end
                        return true
                    end
                    if var733 then
                        if not var734 then
                            tbl2.killerCharacters[char] = {player = player, name = var731}
                        else
                            var734.player = player
                            if var734.name == nil or var734.name == "" or var734.name == "Unknown Killer" then
                                var734.name = var731
                            end
                        end
                        return true
                    end
                    if var734 and var734.player == player then
                        var731 = var734.name or var731
                        return true
                    end
                    return false
                end
                fn208()
                char.AncestryChanged:Connect(function(_, arg155)
                    if not arg155 then
                        fn206(char)
                    end
                end)
                task.spawn(function()
                    for _ = 1, 12 do
                        if not char.Parent then
                            return
                        end
                        fn208()
                        task.wait(0.5)
                    end
                end)
                local humanoid14 = char:WaitForChild("Humanoid", 3)
                if not humanoid14 then
                    return
                end
                local animator = humanoid14:WaitForChild("Animator", 3)
                if not animator then
                    return
                end
                animator.AnimationPlayed:Connect(function(track)
                    if not tbl2.flag116 then
                        return
                    end
                    if not track or not track.Animation then
                        return
                    end
                    local var735 = fn170(track.Animation.AnimationId)
                    if not var735 then
                        return
                    end
                    local var736 = fn171(player, char)
                    if var736 then
                        var731 = var736
                        local var737 = tbl2.killerCharacters[char]
                        if var737 then
                            var737.name = var736
                        else
                            tbl2.killerCharacters[char] = {player = player, name = var736}
                        end
                    else
                        local var738 = tbl2.killerCharacters[char]
                        if var738 and var738.name then
                            var731 = var738.name
                        end
                    end
                    local var739 = var731 or "Unknown Killer"
                    if var735 == num31 or var735 == num32 or var735 == num33 or var735 == num34 then
                        local profile = tbl50[var735] or {type = "maskedfast", length = 1, speed = 1}
                        fn204(char, var739, track, profile, var735)
                        if not tbl2.killerCharacters[char] then
                            tbl2.killerCharacters[char] = {player = player, name = var739}
                        end
                        return
                    end
                    if var735 == num26 then
                        fn195(char, var739, track)
                        if not tbl2.killerCharacters[char] then
                            tbl2.killerCharacters[char] = {player = player, name = var739}
                        end
                        return
                    end
                    local profile = tbl52[var735]
                    if not profile then
                        return
                    end
                    local var740 = tbl2.killerCharacters[char]
                    if not var740 then
                        tbl2.killerCharacters[char] = {player = player, name = var739}
                    elseif var739 ~= "Unknown Killer" then
                        var740.name = var739
                    end
                    local tbl63 = {
                        name = var739,
                        track = track,
                        type = profile.type,
                        id = var735,
                        profile = profile,
                        started = tick(),
                        flag167 = false,
                        lastTimePosition = -1,
                    }
                    tbl2.list7[char] = tbl63
                    local var741
                    var741 = track.Stopped:Connect(function()
                        if var741 then
                            var741:Disconnect()
                            var741 = nil
                        end
                        if tbl2.list7[char] and tbl2.list7[char].track == track then
                            tbl2.list7[char] = nil
                        end
                    end)
                end)
            end
            local function onPlayerAdded(player)
                if player == localPlayer then
                    return
                end
                if player.Character then
                    task.spawn(function()
                        fn207(player, player.Character)
                    end)
                end
                player.CharacterAdded:Connect(function(char)
                    task.spawn(function()
                        fn207(player, char)
                    end)
                end)
            end
            for _, player in ipairs(Players:GetPlayers()) do
                onPlayerAdded(player)
            end
            Players.PlayerAdded:Connect(onPlayerAdded)
            fn5("CloseRangeMonitor", 0, function()
                if not tbl2.flag116 then
                    return
                end
                local character30 = localPlayer.Character
                local var742 = character30 and character30:FindFirstChild("HumanoidRootPart")
                if not var742 then
                    return
                end
                local now10 = tick()
                local var743 = fn186(var742, now10)
                for k9, v98 in pairs(tbl2.list7) do
                    if k9 and k9.Parent and v98 and not v98.flag167 and v98.track and v98.track.IsPlaying and v98.profile then
                        local var744 = v98.track.TimePosition or 0
                        local triggerTime = (v98.profile.triggerTime or 0) / (v98.profile.speed or 1)
                        if v98.profile.type == "attack" then
                            local reactionWindow = v98.profile.reactionWindow or undefinedGlobal4.reactionWindow or num35
                            if var744 > triggerTime + reactionWindow then
                                tbl2.list7[k9] = nil
                                continue
                            end
                        end
                        local humanoidRootPart15 = k9:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart15 then
                            if v98.profile.faceRequired and not fn192(k9) then
                                continue
                            end
                            local var745 = var742.Position - humanoidRootPart15.Position
                            local vector331 = Vector3.new(var745.X, 0, var745.Z)
                            local magnitude16 = vector331.Magnitude
                            local assemblyLinearVelocity12 = humanoidRootPart15.AssemblyLinearVelocity
                            local assemblyLinearVelocity13 = var742.AssemblyLinearVelocity
                            local vector332 = Vector3.new(assemblyLinearVelocity12.X, 0, assemblyLinearVelocity12.Z)
                            local vector333 = Vector3.new(assemblyLinearVelocity13.X, 0, assemblyLinearVelocity13.Z)
                            local var746 = vector332 - vector333
                            local num62 = 0
                            if magnitude16 > 0.05 then
                                num62 = var746:Dot(vector331.Unit)
                            end
                            local var747 = num62 > 0 and magnitude16 / num62 or math.huge
                            local var748 = fn184(k9, 0.4)
                            local length = v98.track.Length
                            if not length or length <= 0 then
                                length = v98.profile.length
                            end
                            local speed = v98.profile.speed or 1
                            local var749 = length > 0 and var744 * speed / length or 0
                            local triggerTime = (v98.profile.triggerTime or 0) / speed
                            local triggerProgress = v98.profile.triggerProgress or 0
                            local var750 = var744 >= math.max(0, triggerTime - num37) or var749 >= math.max(0, triggerProgress - num37)
                            local flag32 = true
                            if v98.profile.type == "attack" then
                                local reactionWindow = v98.profile.reactionWindow or undefinedGlobal4.reactionWindow or num35
                                flag32 = var744 <= triggerTime + reactionWindow + num38
                            end
                            local var751 = num62 >= 5 and var747 <= 0.3
                            local var752 = num62 >= 3.5 and var747 <= 0.15
                            if var750 and flag32 or var751 or var752 then
                                local var753 = var743 and v98.profile.type == "attack" and var750 and flag32 and magnitude16 <= tbl2.num130 + num52
                                if var753 or fn194(k9, magnitude16, num62, var748) then
                                    local var754 = var753
                                    if magnitude16 <= tbl2.num130 then
                                        var754 = true
                                    elseif num62 >= 2.5 and math.max(magnitude16 - 3.5, 0) / num62 <= 0.24 then
                                        var754 = true
                                    elseif num62 >= 5 and math.max(magnitude16 - 3.5, 0) / num62 <= 0.32 then
                                        var754 = true
                                    elseif var748 <= tbl2.num130 and num62 >= 2 then
                                        var754 = true
                                    elseif var750 and flag32 and var748 <= tbl2.num130 + 1.75 then
                                        var754 = true
                                    end
                                    if var754 then
                                        local var755 = var748 <= tbl2.num130 + undefinedGlobal4.predictionExtra or var753
                                        if fn181(true, k9, magnitude16, var755, false) then
                                            v98.flag167 = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            local function fn209()
                if not tbl2.flag116 then
                    return
                end
                local character31 = localPlayer.Character
                local var756 = character31 and character31:FindFirstChild("HumanoidRootPart")
                if not var756 then
                    return
                end
                local position14 = var756.Position
                for k10, v99 in pairs(tbl2.list8) do
                    if not k10 or not k10.Parent or not v99 or not v99.track then
                        tbl2.list8[k10] = nil
                    elseif not v99.track.IsPlaying then
                        tbl2.list8[k10] = nil
                    elseif not v99.flag167 and v99.skillId == num26 then
                        if not tbl2.flag118 then
                            local humanoidRootPart16 = k10:FindFirstChild("HumanoidRootPart")
                            if humanoidRootPart16 then
                                local position15 = humanoidRootPart16.Position
                                local vector334 = Vector3.new(position14.X - position15.X, 0, position14.Z - position15.Z)
                                if vector334.Magnitude <= num28 then
                                    if fn182() then
                                        v99.flag167 = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
            RunService.Heartbeat:Connect(function()
                if tbl2.flag116 then
                    fn209()
                end
            end)
            local function fn210()
                if not tbl2.flag116 then
                    return
                end
                local character32 = localPlayer.Character
                local var757 = character32 and character32:FindFirstChild("HumanoidRootPart")
                if not var757 then
                    return
                end
                for k11, v100 in pairs(tbl2.list7) do
                    if k11 and k11.Parent and k11 ~= character32 and v100 and not v100.flag167 and v100.track and v100.track.IsPlaying and v100.profile then
                        local var758 = v100.track.TimePosition or 0
                        local triggerTime = (v100.profile.triggerTime or 0) / (v100.profile.speed or 1)
                        if v100.profile.type == "attack" then
                            local reactionWindow = v100.profile.reactionWindow or undefinedGlobal4.reactionWindow or num35
                            if var758 > triggerTime + reactionWindow then
                                tbl2.list7[k11] = nil
                                continue
                            end
                        end
                        local humanoidRootPart17 = k11:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart17 then
                            local assemblyLinearVelocity14 = humanoidRootPart17.AssemblyLinearVelocity
                            local vector335 = Vector3.new(assemblyLinearVelocity14.X, 0, assemblyLinearVelocity14.Z)
                            local assemblyLinearVelocity15 = var757.AssemblyLinearVelocity
                            local vector336 = Vector3.new(assemblyLinearVelocity15.X, 0, assemblyLinearVelocity15.Z)
                            local var759 = var757.Position - humanoidRootPart17.Position
                            local vector337 = Vector3.new(var759.X, 0, var759.Z)
                            local magnitude17 = vector337.Magnitude
                            local var760 = vector335 - vector336
                            local num63 = 0
                            if vector337.Magnitude > 0 then
                                num63 = var760:Dot(vector337.Unit)
                            end
                            local ping = math.clamp(localPlayer:GetNetworkPing(), 0, num36)
                            local var761 = math.clamp(ping + undefinedGlobal4.predictionLead, undefinedGlobal4.predictionLead, num36 + undefinedGlobal4.predictionLead)
                            local var762 = humanoidRootPart17.Position + vector335 * var761
                            local var763 = var757.Position + vector336 * var761
                            local magnitude18 = (Vector3.new(var763.X, 0, var763.Z) - Vector3.new(var762.X, 0, var762.Z)).Magnitude
                            local var764 = v100.track.TimePosition or 0
                            local length3 = v100.track.Length
                            local length = length3 and length3 > 0 and length3 or v100.profile.length
                            local speed = v100.profile.speed or 1
                            local var765 = length > 0 and var764 * speed / length or 0
                            local triggerTime = (v100.profile.triggerTime or 0) / speed
                            local triggerProgress = v100.profile.triggerProgress or 0
                            local var766 = var764 >= math.max(0, triggerTime - num37) or var765 >= math.max(0, triggerProgress - num37)
                            local flag33 = true
                            if v100.profile.type == "attack" then
                                local reactionWindow = v100.profile.reactionWindow or undefinedGlobal4.reactionWindow or num35
                                flag33 = var764 <= triggerTime + reactionWindow + num38
                            end
                            local var767 = v100.profile.type ~= "idle" and v100.profile.type ~= "unknown" and var764 >= 0 and var764 <= math.min(length, 0.82) and magnitude17 <= math.min(tbl2.num130, 7.5) and num63 >= 4 and magnitude18 <= tbl2.num130 + undefinedGlobal4.predictionExtra
                            if var766 and flag33 or var767 then
                                if fn194(k11, magnitude17, num63, magnitude18) then
                                    local flag34 = false
                                    if magnitude17 <= tbl2.num130 then
                                        flag34 = true
                                    elseif num63 >= 2 and magnitude18 <= tbl2.num130 then
                                        flag34 = true
                                    elseif num63 >= 3 and magnitude18 <= tbl2.num130 + 1.5 then
                                        flag34 = true
                                    elseif magnitude17 <= tbl2.num130 and magnitude18 <= tbl2.num130 + 1.75 then
                                        flag34 = true
                                    end
                                    if flag34 then
                                        if fn181(true, k11, magnitude17, magnitude18 <= tbl2.num130 + undefinedGlobal4.predictionExtra, false) then
                                            v100.flag167 = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            local num64 = 0.45
            local num65 = 0.055
            local num66 = 0.055
            local num67 = 0.42
            local num68 = 0.9
            local num69 = 1.35
            local num70 = 0.3
            local num71 = 1.2
            local function fn211(character33)
                local character34 = localPlayer.Character
                local var768 = character34 and character34:FindFirstChild("HumanoidRootPart")
                local var769 = character33 and character33:FindFirstChild("HumanoidRootPart")
                if not var768 or not var769 then
                    return false, math.huge, 0
                end
                local position16 = var768.Position
                local position17 = var769.Position
                local var770 = position16 - position17
                local vector338 = Vector3.new(var770.X, 0, var770.Z)
                local magnitude19 = vector338.Magnitude
                if magnitude19 <= 0.05 then
                    return true, magnitude19, 0
                end
                local var771 = fn187(var768)
                local var772 = fn187(var769)
                local var773 = tbl57.list28
                local var774 = tbl57.killers[character33]
                local var775 = var771
                local var776 = var772
                if var773 and tick() - var773.time <= num43 then
                    var775 = var773.velocity * 0.35 + var771 * 0.65
                end
                if var774 and tick() - var774.time <= num43 then
                    var776 = var774.velocity * 0.35 + var772 * 0.65
                end
                local ping = math.clamp(localPlayer:GetNetworkPing(), 0, num64)
                local lead = math.clamp(ping + num65, num66, num64 + num65)
                local var777 = math.clamp(num67 + ping * 0.2, 0.28, 0.52)
                local var778 = var775 - var776
                local var779 = var778:Dot(var778)
                local num72 = 0
                if var779 > 0.25 then
                    num72 = math.clamp(-vector338:Dot(var778) / var779, 0, var777)
                end
                local var780 = vector338 + var778 * num72
                local magnitude20 = var780.Magnitude
                local var781 = position16 + var775 * lead
                local var782 = position17 + var776 * lead
                local vector339 = Vector3.new(var781.X - var782.X, 0, var781.Z - var782.Z)
                local magnitude21 = vector339.Magnitude
                local unit6 = vector338.Unit
                local look = var769.CFrame.LookVector
                local vector340 = Vector3.new(look.X, 0, look.Z)
                if vector340.Magnitude <= 0.05 then
                    vector340 = unit6
                else
                    vector340 = vector340.Unit
                end
                if var776.Magnitude >= 5 then
                    local unit7 = var776.Unit
                    local var783 = vector340 * 0.62 + unit7 * 0.38
                    if var783.Magnitude > 0.05 then
                        vector340 = var783.Unit
                    end
                end
                local var784 = vector340:Dot(unit6)
                local raycastParams3 = RaycastParams.new()
                raycastParams3.FilterType = Enum.RaycastFilterType.Exclude
                raycastParams3.FilterDescendantsInstances = {character34, character33}
                raycastParams3.IgnoreWater = true
                local num73 = 0
                local huge6 = math.huge
                local var785 = var784
                local tbl64 = {
                    lead,
                    math.clamp(lead + 0.035, 0, var777),
                    math.clamp(lead + 0.075, 0, var777),
                    math.clamp(lead + 0.12, 0, var777),
                    math.clamp(lead + 0.18, 0, var777),
                }
                for _, t in ipairs(tbl64) do
                    local var786 = position17 + var776 * t
                    local var787 = position16 + var775 * t
                    local vector341 = Vector3.new(var786.X, 0, var786.Z)
                    local vector342 = Vector3.new(var787.X, 0, var787.Z)
                    local var788 = vector342 - vector341
                    local magnitude22 = var788.Magnitude
                    if magnitude22 < huge6 then
                        huge6 = magnitude22
                    end
                    if magnitude22 > 0.05 then
                        local unit8 = var788.Unit
                        local var789 = vector340:Dot(unit8)
                        if var789 > var785 then
                            var785 = var789
                        end
                        local var790 = Workspace:Raycast(var786, var787 - var786, raycastParams3)
                        if not var790 then
                            num73 = num73 + 1
                        end
                    end
                end
                local var791 = Workspace:Raycast(position17, position16 - position17, raycastParams3)
                local var792 = var791 == nil
                local var793 = unit6 - vector340 * unit6:Dot(vector340)
                local magnitude23 = var793.Magnitude
                local var794 = magnitude20 <= tbl2.num130 + num68 or magnitude21 <= tbl2.num130 + num69 or huge6 <= tbl2.num130 + num68
                local var795 = var785 >= num70 and magnitude23 <= tbl2.num130 + num71
                local var796 = (var778:Dot(unit6))
                local var797 = var796 >= 1 or magnitude20 <= tbl2.num130 + 0.55 or magnitude21 <= tbl2.num130
                local var798 = var792 or num73 >= 2
                local var799 = var794 and var795 and var797 and var798
                return var799, magnitude21, var796
            end
            local function fn212()
                if not tbl2.flag116 then
                    return
                end
                local character35 = localPlayer.Character
                local var800 = character35 and character35:FindFirstChild("HumanoidRootPart")
                if not var800 then
                    return
                end
                for k12, v101 in pairs(tbl2.list7) do
                    if k12 and k12.Parent and k12 ~= character35 and v101 and not v101.flag167 and v101.track and v101.track.IsPlaying and v101.profile then
                        local profile = v101.profile
                        local type2 = profile.type
                        local var801 = v101.track.TimePosition or 0
                        local length4 = v101.track.Length
                        local length = length4 and length4 > 0 and length4 or (profile.length or 1)
                        local speed = profile.speed or 1
                        local triggerTime = (profile.triggerTime or 0) / speed
                        local var802 = fn169(profile)
                        local reactionWindow = profile.reactionWindow or var802.reactionWindow or num35
                        local var803 = var801 >= math.max(0, triggerTime - 0.045) and (type2 ~= "attack" or var801 <= triggerTime + reactionWindow)
                        if var803 and (type2 == "attack" or type2 == "lungehold" or type2 == "corrupt" or type2 == "spearlunge") then
                            local humanoidRootPart18 = k12:FindFirstChild("HumanoidRootPart")
                            if humanoidRootPart18 then
                                local var804 = var800.Position - humanoidRootPart18.Position
                                local vector343 = Vector3.new(var804.X, 0, var804.Z)
                                local magnitude24 = vector343.Magnitude
                                local var805, cornerPredictedDistance, cornerClosingSpeed = fn211(k12)
                                if magnitude24 <= tbl2.num130 + 3.5 or var805 then
                                    local assemblyLinearVelocity16 = humanoidRootPart18.AssemblyLinearVelocity
                                    local assemblyLinearVelocity17 = var800.AssemblyLinearVelocity
                                    local vector344 = Vector3.new(assemblyLinearVelocity16.X, 0, assemblyLinearVelocity16.Z)
                                    local vector345 = Vector3.new(assemblyLinearVelocity17.X, 0, assemblyLinearVelocity17.Z)
                                    local num74 = 0
                                    if vector343.Magnitude > 0.05 then
                                        num74 = (vector344 - vector345):Dot(vector343.Unit)
                                    end
                                    local ping = math.clamp(localPlayer:GetNetworkPing(), 0, num64)
                                    local var806 = var802.predictionLead or num65
                                    local var807 = math.clamp(ping + var806, var806, num64 + var806)
                                    local var808 = humanoidRootPart18.Position + vector344 * var807
                                    local var809 = var800.Position + vector345 * var807
                                    local magnitude25 = (Vector3.new(var809.X, 0, var809.Z) - Vector3.new(var808.X, 0, var808.Z)).Magnitude
                                    local var810 = fn180(var800.Position, humanoidRootPart18.Position, k12)
                                    local var811 = var810.clearCount >= 2 and var810.blockedCount >= 1 and (var810.vault or var810.standingPallet or var810.blockedCount >= 1)
                                    if var811 or var805 then
                                        local var812 = magnitude24 <= tbl2.num130 or magnitude25 <= tbl2.num130 + 1.5 or num74 >= 2 or cornerClosingSpeed >= 1.5 or cornerPredictedDistance <= tbl2.num130 + 1.5
                                        if var812 then
                                            local var813 = magnitude25 <= tbl2.num130 + 1.5 or cornerPredictedDistance <= tbl2.num130 + 1.5
                                            if fn181(true, k12, magnitude24, var813, true) then
                                                v101.flag167 = true
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            local function fn213()
                if not tbl2.flag116 then
                    return
                end
                local character36 = localPlayer.Character
                local var814 = character36 and character36:FindFirstChild("HumanoidRootPart")
                if not var814 then
                    return
                end
                local now11 = tick()
                local var815 = fn187(var814)
                tbl57.list28 = tbl56.list28
                for k13, _ in pairs(tbl2.list7) do
                    if k13 and k13.Parent then
                        tbl57.killers[k13] = tbl56.killers[k13]
                    end
                end
                tbl56.list28 = {velocity = var815, time = now11}
                for k14, _ in pairs(tbl2.list7) do
                    if k14 and k14.Parent then
                        local humanoidRootPart19 = k14:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart19 then
                            tbl56.killers[k14] = {velocity = fn187(humanoidRootPart19), time = now11}
                        end
                    end
                end
            end
            if RunService.PreSimulation then
                RunService.PreSimulation:Connect(function()
                    if tbl2.flag116 then
                        fn213()
                        fn212()
                    end
                end)
            end
            RunService.RenderStepped:Connect(function()
                if tbl2.flag116 then
                    fn210()
                    fn205()
                end
            end)
            RunService.Heartbeat:Connect(function()
                if tbl2.flag116 then
                    fn210()
                end
            end)
            RunService.Heartbeat:Connect(function()
                if tbl2.flag116 then
                end
            end)
            RunService.Heartbeat:Connect(function()
                if tbl2.flag116 then
                    fn205()
                end
            end)
            if RunService.PreSimulation then
                RunService.PreSimulation:Connect(function()
                    if tbl2.flag116 then
                        fn209()
                        fn210()
                        fn205()
                    end
                end)
            end
            local tbl65 = {}
            local var816 = nil
            local tbl66 = {}
            local num75 = 32
            local num76 = -1
            local function fn214()
                for _, v102 in ipairs(tbl65) do
                    if v102 and v102.Parent then
                        v102:Destroy()
                    end
                end
                tbl65 = {}
                tbl66 = {}
                local var817 = 2 * math.pi / num75
                for i29 = 1, num75 do
                    local var818 = var817 * (i29 - 1)
                    local var819 = var817 * i29
                    tbl66[i29] = {cx = math.cos(var818), cz = math.sin(var818), nx = math.cos(var819), nz = math.sin(var819)}
                    local part2 = Instance.new("Part")
                    part2.Shape = Enum.PartType.Block
                    part2.Anchored = true
                    part2.CanCollide = false
                    part2.CanQuery = false
                    part2.CastShadow = false
                    part2.Material = Enum.Material.Neon
                    part2.Color = Color3.fromRGB(248, 248, 255)
                    part2.Transparency = 0.15
                    part2.Size = Vector3.new(0.08, 0.08, 0.1)
                    part2.Name = "BolongESP_Seg"
                    part2.Parent = Workspace
                    tbl65[i29] = part2
                end
            end
            local function fn215(arg156)
                local var820 = 2 * math.pi * arg156 / num75
                for _, v103 in ipairs(tbl65) do
                    if v103 and v103.Parent then
                        v103.Size = Vector3.new(0.08, 0.08, var820 + 0.02)
                    end
                end
            end
            local function fn216()
                for _, v104 in ipairs(tbl65) do
                    if v104 and v104.Parent then
                        v104:Destroy()
                    end
                end
                tbl65 = {}
                tbl66 = {}
                num76 = -1
            end
            function var587(arg157)
                if arg157 then
                    fn214()
                    var816 = RunService.RenderStepped:Connect(function()
                        if not localPlayer.Character then
                            return
                        end
                        local humanoidRootPart20 = localPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if not humanoidRootPart20 then
                            return
                        end
                        local var821 = math.max(0, tbl2.num130)
                        if var821 ~= num76 then
                            fn215(var821)
                            num76 = var821
                        end
                        local var822 = humanoidRootPart20.Position - Vector3.new(0, humanoidRootPart20.Size.Y / 2 + 0.6, 0)
                        for i30, v105 in ipairs(tbl65) do
                            if v105 and v105.Parent then
                                local var823 = tbl66[i30]
                                local pos = var822 + Vector3.new(var823.cx * var821, 0, var823.cz * var821)
                                local var824 = var822 + Vector3.new(var823.nx * var821, 0, var823.nz * var821)
                                v105.CFrame = CFrame.lookAt(pos, var824) * CFrame.new(0, 0, -v105.Size.Z / 2)
                                v105.Transparency = 0.15
                                v105.Size = Vector3.new(0.08, 0.08, v105.Size.Z)
                            end
                        end
                    end)
                else
                    if var816 then
                        var816:Disconnect()
                        var816 = nil
                    end
                    fn216()
                end
            end
        end
        var588 = (function()
            local tbl67 = {}
            local tbl68 = {}
            local tbl69 = {}
            local tbl70 = {}
            local tbl71 = {}
            local flag35 = false
            local num77 = 0
            local color34 = Color3.fromRGB(248, 248, 255)
            local color35 = Color3.fromRGB(199, 21, 133)
            local color36 = Color3.fromRGB(199, 21, 133)
            local function fn217(track)
                if not track then
                    return nil
                end
                local raw = nil
                pcall(function()
                    if track.Animation then
                        raw = track.Animation.AnimationId
                    end
                end)
                if raw == nil then
                    pcall(function()
                        raw = track.AnimationId
                    end)
                end
                local var831 = tostring(raw or "")
                local id = var831:match("%d+")
                return id and tonumber(id) or nil
            end
            local function fn218()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character and player.Character.Parent and not fn166(player, player.Character) then
                        local char = player.Character
                        local var832 = fn161(player, char)
                        local var833 = fn167(player)
                        local var834 = fn168(char)
                        local var835 = tbl2.killerCharacters[char]
                        if var832 or var833 or var834 then
                            tbl2.killerCharacters[char] = {player = player, name = var832 or var835 and var835.name or "Killer"}
                        elseif var835 and var835.player == player and var835.name and var835.name ~= "Unknown Killer" then
                            tbl2.killerCharacters[char] = var835
                        end
                    end
                end
                for char, v106 in pairs(tbl2.killerCharacters) do
                    local player = v106 and v106.player
                    if not char or not char.Parent or not player or player.Character ~= char or fn166(player, char) then
                        tbl2.killerCharacters[char] = nil
                    end
                end
            end
            local function fn219(char)
                if not char or not char.Parent or char == localPlayer.Character then
                    return false
                end
                local player = Players:GetPlayerFromCharacter(char)
                if fn166(player, char) then
                    return false
                end
                if player then
                    if not player.Team or not fn167(player) then
                        return false
                    end
                    local var836 = tbl2.killerCharacters[char]
                    local var837 = fn161(player, char)
                    tbl2.killerCharacters[char] = {player = player, name = var837 or var836 and var836.name or "Killer"}
                    return true
                end
                return fn168(char)
            end
            local function fn220(beam, color)
                if not beam or not beam.Parent then
                    return false
                end
                beam.Color = ColorSequence.new(color)
                return true
            end
            local function fn221(arg158)
                if not arg158 then
                    return
                end
                if arg158.beam and arg158.beam.Parent then
                    arg158.beam:Destroy()
                end
                if arg158.endpointAttachment and arg158.endpointAttachment.Parent then
                    arg158.endpointAttachment:Destroy()
                end
                if arg158.endpointPart and arg158.endpointPart.Parent then
                    arg158.endpointPart:Destroy()
                end
                if arg158.startAttachment and arg158.startAttachment.Parent then
                    arg158.startAttachment:Destroy()
                end
            end
            local function fn222(store, char)
                local var838 = store[char]
                if var838 then
                    fn221(var838)
                    store[char] = nil
                end
            end
            local function fn223(store, char, color, arg159)
                if not char or not char.Parent then
                    return nil
                end
                local head5 = char:FindFirstChild("Head")
                if not head5 then
                    return nil
                end
                fn222(store, char)
                local endpointPart = Instance.new("Part")
                endpointPart.Name = arg159 .. "Endpoint"
                endpointPart.Anchored = true
                endpointPart.CanCollide = false
                endpointPart.CanTouch = false
                endpointPart.CanQuery = false
                endpointPart.CastShadow = false
                endpointPart.Shape = Enum.PartType.Ball
                endpointPart.Material = Enum.Material.Neon
                endpointPart.Color = color or color34
                endpointPart.Transparency = 0.04
                endpointPart.Size = Vector3.new(0.26, 0.26, 0.26)
                endpointPart.CFrame = CFrame.new(head5.Position)
                endpointPart.Parent = Workspace
                local startAttachment = Instance.new("Attachment")
                startAttachment.Name = arg159 .. "Start"
                startAttachment.Position = Vector3.zero
                startAttachment.Parent = head5
                local endpointAttachment = Instance.new("Attachment")
                endpointAttachment.Name = arg159 .. "End"
                endpointAttachment.Position = Vector3.zero
                endpointAttachment.Parent = endpointPart
                local beam = Instance.new("Beam")
                beam.Name = arg159
                beam.Attachment0 = startAttachment
                beam.Attachment1 = endpointAttachment
                beam.FaceCamera = true
                beam.LightEmission = 1
                beam.LightInfluence = 0
                beam.Segments = 1
                beam.Width0 = 0.12
                beam.Width1 = 0.12
                beam.Transparency = NumberSequence.new(0.45)
                fn220(beam, color or color34)
                beam.Parent = endpointPart
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                raycastParams.IgnoreWater = true
                local character37 = localPlayer.Character
                local tbl72 = {char}
                if character37 and character37 ~= char then
                    table.insert(tbl72, character37)
                end
                raycastParams.FilterDescendantsInstances = tbl72
                local tbl73 = {
                    beam = beam,
                    endpointPart = endpointPart,
                    endpointAttachment = endpointAttachment,
                    startAttachment = startAttachment,
                    raycastParams = raycastParams,
                    field38 = character37,
                    num168 = 0,
                    field39 = nil,
                    color = color or color34,
                }
                store[char] = tbl73
                return tbl73
            end
            local function fn224(arg160, char, forcedLength, arg161)
                if not arg160 or not char or not char.Parent or not arg160.endpointPart or not arg160.endpointPart.Parent then
                    return
                end
                local head6 = char:FindFirstChild("Head")
                local humanoidRootPart21 = char:FindFirstChild("HumanoidRootPart")
                if not head6 or not humanoidRootPart21 then
                    return
                end
                local lookVector5 = humanoidRootPart21.CFrame.LookVector
                if lookVector5.Magnitude <= 0.001 then
                    return
                end
                lookVector5 = lookVector5.Unit
                local position18 = head6.Position
                local length = math.clamp(tonumber(forcedLength) or tonumber(tbl2.num135) or 50, 10, 100)
                local var839 = tonumber(arg160.targetLength) or length
                local now12 = tick()
                local character38 = localPlayer.Character
                if arg160.field38 ~= character38 then
                    arg160.field38 = character38
                    local tbl74 = {char}
                    if character38 and character38 ~= char then
                        table.insert(tbl74, character38)
                    end
                    arg160.raycastParams.FilterDescendantsInstances = tbl74
                    arg160.num168 = 0
                end
                local num78 = 0.055
                local var840 = arg160.num168 == 0 or now12 - arg160.num168 >= num78 or not arg160.field39 or math.abs(arg160.field39 - length) >= 0.05
                local var841 = nil
                if var840 then
                    var841 = Workspace:Raycast(position18, lookVector5 * length, arg160.raycastParams)
                    if var841 then
                        local var842 = arg160.endpointPart.Size.X * 0.5
                        var839 = math.clamp(var841.Distance - var842, 0.12, length)
                    else
                        var839 = length
                    end
                    arg160.num168 = now12
                    arg160.field39 = length
                    arg160.targetLength = var839
                end
                local var843 = tonumber(arg160.currentLength) or length
                if typeof(arg161) == "number" and arg161 > 0 then
                    local var844 = 1 - math.exp(-18 * math.clamp(arg161, 0, 0.1))
                    var843 = var843 + (var839 - var843) * var844
                    if math.abs(var839 - var843) < 0.015 then
                        var843 = var839
                    end
                else
                    var843 = var839
                end
                arg160.currentLength = var843
                arg160.targetLength = var839
                arg160.obstructed = var841 ~= nil
                arg160.endpointPart.CFrame = CFrame.new(position18 + lookVector5 * var843)
                arg160.length = var843
                arg160.startAttachment.Position = Vector3.zero
                arg160.endpointAttachment.Position = Vector3.zero
            end
            local function fn225(char)
                fn222(tbl69, char)
                fn222(tbl70, char)
            end
            local function fn226(char)
                local var845 = fn223(tbl69, char, color34, "LineOfSightAlways")
                if var845 then
                    var845.color = color34
                end
                return var845
            end
            local function fn227(char)
                local var846 = tbl70[char]
                if var846 then
                    return var846
                end
                var846 = fn223(tbl70, char, color35, "LineOfSightAlwaysYellow")
                if var846 and var846.beam then
                    var846.beam.Width0 = 0.12
                    var846.beam.Width1 = 0.12
                    var846.beam.Enabled = true
                end
                return var846
            end
            local tbl75 = {
                [92098503722633] = true,
                [84093948968516] = true,
                [138045669415653] = true,
                [137688077908355] = true,
                [117886494230451] = true,
            }
            local function fn228(char)
                local var847 = char and char:FindFirstChildOfClass("Humanoid")
                local var848 = var847 and var847:FindFirstChildOfClass("Animator")
                if not var848 then
                    return color34
                end
                for _, track in ipairs(var848:GetPlayingAnimationTracks()) do
                    if track and track.IsPlaying then
                        local id = fn217(track)
                        if id and tbl75[id] then
                            return color36
                        end
                    end
                end
                return color34
            end
            local function fn229()
            end
            local function fn230(char)
                local var849 = fn228(char)
                if var849 == color36 then
                    return true
                end
                local var850 = tbl67[char]
                if not var850 then
                    return false
                end
                local flag36 = false
                for track, v107 in pairs(var850) do
                    if not track or not track.IsPlaying then
                        var850[track] = nil
                        local var851 = tbl68[track]
                        if var851 then
                            var851:Disconnect()
                            tbl68[track] = nil
                        end
                    elseif v107 and v107.special then
                        flag36 = true
                    end
                end
                if next(var850) == nil then
                    tbl67[char] = nil
                end
                return flag36
            end
            local tbl76 = {
                [75258958842388] = true,
                [96744338559260] = true,
                [137846825408335] = true,
                [139928639611415] = true,
            }
            local tbl77 = {
                [92098503722633] = true,
                [84093948968516] = true,
                [138045669415653] = true,
                [137688077908355] = true,
                [117886494230451] = true,
            }
            local function fn231(char)
                local var852 = char and char:FindFirstChildOfClass("Humanoid")
                local var853 = var852 and var852:FindFirstChildOfClass("Animator")
                if not var853 then
                    return color34
                end
                local flag37 = false
                for _, track in ipairs(var853:GetPlayingAnimationTracks()) do
                    if track and track.IsPlaying then
                        local id = fn217(track)
                        if id and tbl77[id] then
                            return color36
                        end
                        if id and tbl76[id] then
                            flag37 = true
                        end
                    end
                end
                if flag37 then
                    return color33
                end
                return color34
            end
            local function fn232(char)
                local color = fn231(char)
                if color == color36 then
                    return color
                end
                return nil
            end
            local function fn233(char, arg162)
                if not char or not char.Parent then
                    return
                end
                local var854 = tbl69[char]
                if not var854 or not var854.beam or not var854.beam.Parent or not var854.endpointPart or not var854.endpointPart.Parent or not var854.startAttachment or not var854.startAttachment.Parent or not var854.endpointAttachment or not var854.endpointAttachment.Parent then
                    var854 = fn226(char)
                end
                if not var854 then
                    return
                end
                fn224(var854, char, nil, arg162)
                local color = fn231(char)
                var854.color = color
                if var854.beam and var854.beam.Parent then
                    fn220(var854.beam, color)
                    var854.beam.Width0 = 0.12
                    var854.beam.Width1 = 0.12
                    var854.beam.Transparency = NumberSequence.new(0.45)
                    var854.beam.Enabled = true
                end
                if var854.endpointPart and var854.endpointPart.Parent then
                    var854.endpointPart.Color = color
                    var854.endpointPart.Material = Enum.Material.Neon
                    var854.endpointPart.Transparency = 0.04
                end
                fn222(tbl70, char)
            end
            local function fn234(char)
                local var855 = tbl71[char]
                if var855 then
                    for _, part in ipairs(var855) do
                        if part and part.Parent then
                            part:Destroy()
                        end
                    end
                end
                tbl71[char] = nil
            end
            local function fn235(name)
                local part = Instance.new("Part")
                part.Name = name
                part.Anchored = true
                part.CanCollide = false
                part.CanTouch = false
                part.CanQuery = false
                part.CastShadow = false
                part.Material = Enum.Material.Neon
                part.Color = color34
                part.Transparency = 0.05
                part.Size = Vector3.new(0.0825, 0.0825, 0.1)
                part.Parent = Workspace
                return part
            end
            local function fn236(part, arg163, arg164)
                local var856 = arg164 - arg163
                local length = var856.Magnitude
                if length <= 0.001 then
                    part.Transparency = 1
                    return
                end
                part.Transparency = 0.05
                part.Size = Vector3.new(0.0825, 0.0825, length)
                part.CFrame = CFrame.lookAt((arg163 + arg164) * 0.5, arg164)
            end
            local function fn237(char, arg165)
                local var857 = char and char:FindFirstChild("HumanoidRootPart")
                if not var857 then
                    return arg165
                end
                return Vector3.new(arg165.X, var857.Position.Y - 3, arg165.Z)
            end
            local function fn238(char)
                local var858 = tbl71[char]
                if var858 and #var858 == 9 then
                    return var858
                end
                if var858 then
                    for _, part in ipairs(var858) do
                        if part then
                            part:Destroy()
                        end
                    end
                end
                var858 = {}
                for i31 = 1, 9 do
                    var858[i31] = fn235("HeavenEyesLine")
                end
                tbl71[char] = var858
                return var858
            end
            local function fn239(char)
                if not tbl2.flag120 or not char or not char.Parent then
                    fn234(char)
                    return
                end
                local humanoidRootPart22 = char:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart22 then
                    return
                end
                local vector346 = Vector3.new(humanoidRootPart22.CFrame.LookVector.X, 0, humanoidRootPart22.CFrame.LookVector.Z)
                if vector346.Magnitude <= 0.01 then
                    return
                end
                vector346 = vector346.Unit
                local vector347 = Vector3.new(-vector346.Z, 0, vector346.X)
                local var859 = humanoidRootPart22.Position.Y - 3
                local num79 = 7.85
                local num80 = 11.5
                local num81 = 3
                local vector348 = Vector3.new(humanoidRootPart22.Position.X + vector346.X * 0.8, var859, humanoidRootPart22.Position.Z + vector346.Z * 0.8)
                local vector349 = Vector3.new(humanoidRootPart22.Position.X + vector346.X * num80 - vector347.X * num79, var859, humanoidRootPart22.Position.Z + vector346.Z * num80 - vector347.Z * num79)
                local vector350 = Vector3.new(humanoidRootPart22.Position.X + vector346.X * num80 + vector347.X * num79, var859, humanoidRootPart22.Position.Z + vector346.Z * num80 + vector347.Z * num79)
                local var860 = fn238(char)
                fn236(var860[1], vector348, vector349)
                fn236(var860[2], vector348, vector350)
                local tbl78 = {}
                for i32 = 0, 7 do
                    local t = i32 / 7
                    local var861 = -num79 + 2 * num79 * t
                    local var862 = math.sin(math.pi * t) * num81
                    local var863 = humanoidRootPart22.Position + vector346 * (num80 + var862) + vector347 * var861
                    tbl78[i32 + 1] = Vector3.new(var863.X, var859, var863.Z)
                end
                for i33 = 1, 7 do
                    fn236(var860[i33 + 2], tbl78[i33], tbl78[i33 + 1])
                end
                for _, part in ipairs(var860) do
                    part.Color = color34
                    part.Material = Enum.Material.Neon
                    part.Transparency = 0.02
                end
            end
            local function setEnabled(arg166)
                fn218()
                if not arg166 then
                    return
                end
                fn229()
                if flag35 then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= localPlayer and player.Character and fn219(player.Character) then
                            local char = player.Character
                            if not tbl69[char] then
                                fn226(char)
                            end
                            fn233(char)
                        end
                    end
                end
            end
            local function setLineAlways(arg167)
                flag35 = arg167
                fn218()
                if flag35 then
                    fn229()
                end
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character then
                        local char = player.Character
                        if fn219(char) then
                            if flag35 then
                                if not tbl69[char] then
                                    fn226(char)
                                end
                                fn233(char)
                            else
                                fn225(char)
                            end
                        else
                            fn225(char)
                        end
                    end
                end
            end
            local function setAlwaysLineLength(arg168)
                local length = math.clamp(tonumber(arg168) or 50, 10, 100)
                tbl2.num135 = length
                for char, v108 in pairs(tbl69) do
                    if v108 then
                        v108.length = length
                    end
                    if char and char.Parent then
                        fn233(char)
                    end
                end
                for char, v109 in pairs(tbl70) do
                    if v109 then
                        v109.length = length
                    end
                    if char and char.Parent then
                        fn224(v109, char)
                    end
                end
            end
            local function setHeavenEyes(arg169)
                tbl2.flag120 = arg169
                fn218()
                if not arg169 then
                    for char in pairs(tbl71) do
                        fn234(char)
                    end
                    return
                end
                fn229()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character and fn219(player.Character) then
                        fn239(player.Character)
                    end
                end
            end
            RunService.RenderStepped:Connect(function(arg170)
                local now13 = tick()
                if now13 - num77 >= 0.3 then
                    fn218()
                    num77 = now13
                end
                pcall(function()
                    if flag35 then
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= localPlayer and player.Character then
                                local char = player.Character
                                if fn219(char) then
                                    if not tbl69[char] or not tbl69[char].beam or not tbl69[char].beam.Parent then
                                        fn226(char)
                                    end
                                    fn233(char, arg170)
                                else
                                    fn225(char)
                                end
                            end
                        end
                    end
                    for char in pairs(tbl69) do
                        if not char or not char.Parent or not tbl2.killerCharacters[char] or not flag35 then
                            fn225(char)
                        end
                    end
                end)
                pcall(function()
                    if tbl2.flag120 then
                        for char in pairs(tbl71) do
                            local var864 = char and char.Parent and fn219(char)
                            if not var864 then
                                fn234(char)
                            end
                        end
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= localPlayer and player.Character then
                                local char = player.Character
                                if fn219(char) then
                                    fn239(char)
                                else
                                    fn234(char)
                                end
                            end
                        end
                    end
                end)
            end)
            return {
                setEnabled = setEnabled,
                setHeavenEyes = setHeavenEyes,
                setLineAlways = setLineAlways,
                setAlwaysLineLength = setAlwaysLineLength,
            }
        end)()
    end)()
end
local function fn240()
    for _, v110 in ipairs(tbl2.list1.Gates) do
        ApplyGhostGateToObj(v110, tbl2.flag145)
    end
end
local function fn241()
    local char = localPlayer.Character
    local var865 = char and char:FindFirstChild("HumanoidRootPart")
    if not var865 then
        fn2("Teleport", "Karakter tidak ditemukan!", 2)
        return
    end
    local fininshline = workspace:FindFirstChild("Fininshline", true)
    if not fininshline then
        fn2("Teleport", "Fininshline tidak ditemukan di map!", 2)
        return
    end
    local position19 = fininshline.Position
    local raycastParams4 = RaycastParams.new()
    raycastParams4.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams4.FilterDescendantsInstances = {char, fininshline.Parent}
    local var867 = nil
    local var868 = position19 + Vector3.new(0, 10, 0)
    local var869 = workspace:Raycast(var868, Vector3.new(0, -30, 0), raycastParams4)
    if var869 then
        local var870 = workspace:Raycast(var869.Position + Vector3.new(0, 5, 0), Vector3.new(0, 5, 0), raycastParams4)
        if not var870 then
            var867 = var869.Position + Vector3.new(0, 3, 0)
        end
    end
    if var867 then
        pcall(function()
            var865.CFrame = CFrame.new(var867)
        end)
    else
        pcall(function()
            var865.CFrame = fininshline.CFrame
        end)
    end
end
local var871
do
    local str5 = "80411309607666"
    local function fn242(animId)
        if not animId then
            return ""
        end
        return tostring(animId):match("%d+") or ""
    end
    local function fn243()
        local playerGui9 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui9 then
            return nil
        end
        local survivorMob8 = playerGui9:FindFirstChild("Survivor-mob")
        if not survivorMob8 then
            return nil
        end
        local controls5 = survivorMob8:FindFirstChild("Controls")
        if not controls5 then
            return nil
        end
        local crouch = controls5:FindFirstChild("crouch")
        if crouch and crouch:IsA("GuiButton") then
            return crouch
        end
        return nil
    end
    function var871(arg171)
        if tbl2.flag143 ~= arg171 then
            tbl2.flag143 = arg171
            local char = localPlayer.Character
            if char then
                char:SetAttribute("Crouchingserver", arg171)
                char:SetAttribute("Crouching", arg171)
            end
            pcall(function()
                ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", arg171)
                ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouching", arg171)
            end)
            local var874 = not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled
            if var874 then
                VirtualInputManager:SendKeyEvent(arg171, Enum.KeyCode.C, false, game)
                VirtualInputManager:SendKeyEvent(arg171, Enum.KeyCode.LeftControl, false, game)
            else
                local var875 = fn243()
                if var875 and type(firesignal) == "function" then
                    if arg171 then
                        firesignal(var875.MouseButton1Down)
                        if var875.MouseButton1Click then
                            firesignal(var875.MouseButton1Click)
                        end
                    else
                        firesignal(var875.MouseButton1Up)
                        if var875.MouseButton1Click then
                            firesignal(var875.MouseButton1Click)
                        end
                    end
                end
            end
        end
    end
    local function fn244(char)
        if not char then
            return
        end
        local humanoid15 = char:FindFirstChildOfClass("Humanoid")
        if not humanoid15 then
            return
        end
        if tbl2.autoCrouchAnimConns[humanoid15] then
            return
        end
        tbl2.autoCrouchAnimConns[humanoid15] = humanoid15.AnimationPlayed:Connect(function(track)
            if not tbl.flag95 then
                return
            end
            local animation4 = track.Animation
            if animation4 then
                local var877 = fn242(animation4.AnimationId)
                if var877 == str5 then
                    tbl2.autoCrouchActiveSlashers[char] = true
                    track.Stopped:Connect(function()
                        task.wait(0.2)
                        tbl2.autoCrouchActiveSlashers[char] = nil
                    end)
                end
            end
        end)
        humanoid15.Died:Connect(function()
            tbl2.autoCrouchActiveSlashers[char] = nil
            if tbl2.autoCrouchAnimConns[humanoid15] then
                tbl2.autoCrouchAnimConns[humanoid15].Disconnect(tbl2.autoCrouchAnimConns[humanoid15])
                tbl2.autoCrouchAnimConns[humanoid15] = nil
            end
        end)
    end
    fn5("AutoCrouch", 0, function()
        if not tbl.flag95 then
            return
        end
        local character39 = localPlayer.Character
        if not character39 then
            return
        end
        local humanoidRootPart23 = character39:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart23 then
            return
        end
        local flag38 = false
        for k15, _ in pairs(tbl2.autoCrouchActiveSlashers) do
            if k15 and k15.Parent then
                local humanoidRootPart24 = k15:FindFirstChild("HumanoidRootPart")
                local humanoid16 = k15:FindFirstChildOfClass("Humanoid")
                if humanoidRootPart24 and humanoid16 and humanoid16.Health > 0 then
                    local dist = (humanoidRootPart24.Position - humanoidRootPart23.Position).Magnitude
                    if dist <= tbl.num122 then
                        flag38 = true
                        break
                    end
                end
            else
                tbl2.autoCrouchActiveSlashers[k15] = nil
            end
        end
        var871(flag38)
    end)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            fn244(player.Character)
        end
        if player ~= localPlayer then
            player.CharacterAdded:Connect(function(newChar)
                task.wait(1)
                fn244(newChar)
            end)
        end
    end
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(newChar)
            task.wait(1)
            if tbl.flag95 then
                fn244(newChar)
            end
        end)
    end)
end
local function fn245(input)
    if not input or input:gsub("%s+", "") == "" then
        return
    end
    input = input:gsub("%s+", "")
    task.spawn(function()
        local var878 = tonumber(input)
        if not var878 then
            local var879 = pcall(function()
                var878 = Players:GetUserIdFromNameAsync(input)
            end)
            if not var879 or not var878 then
                return
            end
        end
        local char = localPlayer.Character
        local var880 = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not var880 then
            return
        end
        local var881 = Players:GetHumanoidDescriptionFromUserId(var878)
        if not var881 then
            return
        end
        local var882 = Players:CreateHumanoidModelFromDescription(var881, var880.RigType)
        if not var882 then
            return
        end
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("BodyColors") or obj:IsA("CharacterMesh") then
                obj:Destroy()
            end
        end
        for _, v111 in ipairs(char:GetChildren()) do
            if v111:IsA("BasePart") then
                for _, v112 in ipairs(v111:GetChildren()) do
                    if v112:IsA("SpecialMesh") or v112:IsA("Decal") or v112:IsA("Texture") or v112:IsA("SurfaceAppearance") then
                        v112:Destroy()
                    end
                end
            end
        end
        local bodyColors = var882:FindFirstChildOfClass("BodyColors")
        if bodyColors then
            bodyColors:Clone().Parent = char
            local tbl79 = {
                Head = bodyColors.HeadColor3,
                Torso = bodyColors.TorsoColor3,
                ["Left Arm"] = bodyColors.LeftArmColor3,
                ["Right Arm"] = bodyColors.RightArmColor3,
                ["Left Leg"] = bodyColors.LeftLegColor3,
                ["Right Leg"] = bodyColors.RightLegColor3,
                UpperTorso = bodyColors.TorsoColor3,
                LowerTorso = bodyColors.TorsoColor3,
                LeftHand = bodyColors.LeftArmColor3,
                RightHand = bodyColors.RightArmColor3,
                LeftLowerArm = bodyColors.LeftArmColor3,
                RightLowerArm = bodyColors.RightArmColor3,
                LeftUpperArm = bodyColors.LeftArmColor3,
                RightUpperArm = bodyColors.RightArmColor3,
                LeftFoot = bodyColors.LeftLegColor3,
                RightFoot = bodyColors.RightLegColor3,
                LeftLowerLeg = bodyColors.LeftLegColor3,
                RightLowerLeg = bodyColors.RightLegColor3,
                LeftUpperLeg = bodyColors.LeftLegColor3,
                RightUpperLeg = bodyColors.RightLegColor3,
            }
            for k16, color in pairs(tbl79) do
                local part = char:FindFirstChild(k16)
                if part then
                    pcall(function()
                        part.Color = color
                    end)
                end
            end
        end
        for _, obj in ipairs(var882:GetChildren()) do
            if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("CharacterMesh") then
                obj:Clone().Parent = char
            end
        end
        for _, v113 in ipairs(var882:GetChildren()) do
            if v113:IsA("BasePart") then
                local var883 = char:FindFirstChild(v113.Name)
                if var883 and var883:IsA("BasePart") then
                    if v113:IsA("MeshPart") and var883:IsA("MeshPart") then
                        pcall(function()
                            var883.MeshId = v113.MeshId
                            var883.TextureID = v113.TextureID
                            var883.Color = v113.Color
                            var883.Transparency = v113.Transparency
                        end)
                    end
                    for _, v114 in ipairs(v113:GetChildren()) do
                        if v114:IsA("SpecialMesh") or v114:IsA("Decal") or v114:IsA("Texture") or v114:IsA("SurfaceAppearance") then
                            v114:Clone().Parent = var883
                        end
                    end
                end
            end
        end
        local function fn246(acc)
            local var884 = acc:Clone()
            var884.Parent = char
            local handle = var884:FindFirstChild("Handle")
            if not handle then
                return
            end
            handle.Anchored = false
            handle.CanCollide = false
            pcall(function()
                handle.Massless = true
            end)
            for _, v115 in ipairs(handle:GetChildren()) do
                if v115:IsA("Weld") or v115:IsA("WeldConstraint") or v115:IsA("Motor6D") then
                    v115:Destroy()
                end
            end
            pcall(function()
                var880:AddAccessory(var884)
            end)
            local flag39 = false
            for _, v116 in ipairs(handle:GetChildren()) do
                if (v116:IsA("Weld") or v116:IsA("WeldConstraint")) and v116.Part1 and v116.Part1:IsDescendantOf(char) then
                    flag39 = true
                    break
                end
            end
            if not flag39 then
                local attachment2 = handle:FindFirstChildOfClass("Attachment")
                local var885 = nil
                local var886 = nil
                if attachment2 then
                    local var887 = char:FindFirstChild(attachment2.Name, true)
                    if var887 and var887:IsA("Attachment") then
                        var885 = var887.Parent
                        var886 = var887
                    end
                end
                if not var885 then
                    var885 = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                end
                if var885 then
                    if var886 and attachment2 then
                        handle.CFrame = var885.CFrame * var886.CFrame * attachment2.CFrame:Inverse()
                    else
                        handle.CFrame = var885.CFrame
                    end
                    local weldConstraint = Instance.new("WeldConstraint")
                    weldConstraint.Name = "BolongWeld"
                    weldConstraint.Part0 = handle
                    weldConstraint.Part1 = var885
                    weldConstraint.Parent = handle
                end
            end
        end
        for _, obj in ipairs(var882:GetChildren()) do
            if obj:IsA("Accessory") then
                pcall(function()
                    fn246(obj)
                end)
            end
        end
        var882:Destroy()
        if var878 then
            if tbl2.field3 ~= var878 then
                tbl2.field3 = var878
                tbl2.field4 = nil
                tbl2.field5 = nil
            end
            tbl2.flag126 = true
            _EnsureAvatarUiWatchers()
            _HookAllAvatarSlots()
            _ApplyCopiedAvatarToUI()
        end
    end)
end
local var888, restoreLighting, removeVisualEffects, restoreVisualEffects
do
    local tbl80 = {
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        ColorShift_Top = Lighting.ColorShift_Top,
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        GlobalShadows = Lighting.GlobalShadows,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
        FogColor = Lighting.FogColor,
        ExposureCompensation = Lighting.ExposureCompensation,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    }
    local tbl81 = {}
    function var888()
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
        Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        Lighting.ColorShift_Top = Color3.new(0, 0, 0)
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
        Lighting.FogStart = 9000000000
        Lighting.FogEnd = 9000000000
        Lighting.ExposureCompensation = 0
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
    end
    function restoreLighting()
        for k17, v117 in pairs(tbl80) do
            pcall(function()
                Lighting[k17] = v117
            end)
        end
    end
    function removeVisualEffects()
        tbl81 = {}
        for _, v118 in ipairs(Lighting:GetChildren()) do
            if v118:IsA("PostEffect") or v118:IsA("Clouds") or v118:IsA("Atmosphere") or v118:IsA("Sky") then
                tbl81[v118] = {Enabled = v118.Enabled, Parent = v118.Parent}
                pcall(function()
                    if v118:IsA("Sky") then
                        v118.Parent = nil
                    else
                        v118.Enabled = false
                    end
                end)
            end
        end
    end
    function restoreVisualEffects()
        for k18, v119 in pairs(tbl81) do
            if k18 then
                pcall(function()
                    if k18:IsA("Sky") then
                        k18.Parent = v119.Parent
                    else
                        k18.Enabled = v119.Enabled
                    end
                end)
            end
        end
        tbl81 = {}
    end
    fn5("LightingEnforcer", 0.5, function()
        if tbl2.flag132 then
            var888()
        end
        if tbl2.flag133 then
            for _, v120 in ipairs(Lighting:GetChildren()) do
                if v120:IsA("PostEffect") or v120:IsA("Clouds") or v120:IsA("Atmosphere") or v120:IsA("Sky") then
                    pcall(function()
                        if v120:IsA("Sky") then
                            if v120.Parent then
                                v120.Parent = nil
                            end
                        else
                            if v120.Enabled then
                                v120.Enabled = false
                            end
                        end
                    end)
                end
            end
        end
    end)
    Lighting.ChildAdded:Connect(function(arg172)
        if tbl2.flag133 then
            if arg172:IsA("PostEffect") or arg172:IsA("Clouds") or arg172:IsA("Atmosphere") or arg172:IsA("Sky") then
                task.spawn(function()
                    pcall(function()
                        if arg172:IsA("Sky") then
                            arg172.Parent = nil
                        else
                            arg172.Enabled = false
                        end
                    end)
                end)
            end
        end
    end)
end
do
    local function fn247()
        local screenGui7 = Instance.new("ScreenGui")
        screenGui7.Name = "BolongFOV"
        screenGui7.ResetOnSpawn = false
        screenGui7.DisplayOrder = 999999
        pcall(function()
            screenGui7.Parent = gethui and gethui() or game:GetService("CoreGui")
        end)
        if not screenGui7.Parent then
            screenGui7.Parent = playerGui
        end
        tbl2.frame1 = Instance.new("Frame")
        tbl2.frame1.Size = UDim2.new(0, tbl.num120 * 2, 0, tbl.num120 * 2)
        tbl2.frame1.Position = UDim2.new(0.5, 0, 0.5, 0)
        tbl2.frame1.AnchorPoint = Vector2.new(0.5, 0.5)
        tbl2.frame1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tbl2.frame1.BackgroundTransparency = 1
        tbl2.frame1.Visible = false
        tbl2.frame1.Parent = screenGui7
        local uICorner8 = Instance.new("UICorner")
        uICorner8.CornerRadius = UDim.new(1, 0)
        uICorner8.Parent = tbl2.frame1
        local uIStroke7 = Instance.new("UIStroke")
        uIStroke7.Color = color3
        uIStroke7.Thickness = 2
        uIStroke7.Transparency = 0.2
        uIStroke7.Parent = tbl2.frame1
    end
    fn247()
    local function fn248(char)
        if not char then
            return nil
        end
        local upperTorso3 = char:FindFirstChild("UpperTorso")
        if upperTorso3 and upperTorso3:IsA("BasePart") then
            return upperTorso3.Position
        end
        local torso2 = char:FindFirstChild("Torso")
        if torso2 and torso2:IsA("BasePart") then
            return torso2.Position
        end
        local humanoidRootPart25 = char:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart25 then
            return humanoidRootPart25.Position
        end
        return nil
    end
    local function fn249()
        local char = localPlayer.Character
        if not char then
            return nil
        end
        local var889, gun = pcall(function()
            return char:FindFirstChild("Twist of Fate"):FindFirstChild("Right Arm"):FindFirstChild("gun"):FindFirstChild("gun")
        end)
        if var889 and gun and gun:IsA("BasePart") then
            return gun.Position
        end
        local var890 = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
        if var890 then
            return var890.Position
        end
        return nil
    end
    local fire = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Items"):WaitForChild("Twist of Fate"):WaitForChild("Fire")
    local var891
    pcall(function()
        var891 = hookmetamethod(game, "__namecall", function(self, ...)
            local var892 = getnamecallmethod()
            if var892 == "FireServer" and rawequal(self, fire) then
                local var893 = table.pack(...)
                if tbl2.flag134 and typeof(tbl2.vector31) == "Vector3" then
                    if var893.n >= 3 and typeof(var893[3]) == "Vector3" then
                        var893[3] = tbl2.vector31
                        if tbl2.flag135 then
                            tbl2.flag136 = true
                        end
                        local var894 = tbl2.list15
                        if var894 then
                            print(string.format("[ToF] fire dist=%.0f tof=%.2f lead=%.1f vel=%.1f pred=%d damp=%d zig=%d dot=%.2f ping=%.0fms", var894.dist or 0, var894.tof or 0, var894.lead or 0, var894.vel or 0, var894.pred or 0, var894.damp or 0, var894.zig or 0, var894.dot or 0, (var894.ping or 0) * 1000))
                        end
                    elseif var893.n >= 2 and typeof(var893[2]) == "Vector3" then
                        var893[2] = tbl2.vector31
                        if tbl2.flag135 then
                            tbl2.flag136 = true
                        end
                        local var895 = tbl2.list15
                        if var895 then
                            print(string.format("[ToF] fire dist=%.0f tof=%.2f lead=%.1f vel=%.1f pred=%d damp=%d zig=%d dot=%.2f ping=%.0fms", var895.dist or 0, var895.tof or 0, var895.lead or 0, var895.vel or 0, var895.pred or 0, var895.damp or 0, var895.zig or 0, var895.dot or 0, (var895.ping or 0) * 1000))
                        end
                    end
                end
                return var891(self, table.unpack(var893, 1, var893.n))
            end
            return var891(self, ...)
        end)
    end)
    do
        local fire2 = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Items"):WaitForChild("Twist of Fate"):WaitForChild("Fire")
        local num82 = 0
        local function fn250()
            local char = localPlayer.Character
            if not char then
                return false
            end
            if localPlayer:GetAttribute("IsDead") then
                return true
            end
            if char:GetAttribute("IsCarried") then
                return true
            end
            if char:GetAttribute("IsHooked") then
                return true
            end
            local humanoid17 = char:FindFirstChildOfClass("Humanoid")
            if humanoid17 and humanoid17.Health < humanoid17.MaxHealth * 0.5 then
                return true
            end
            local humanoidRootPart26 = char:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart26 and humanoidRootPart26:HasTag("doing action") then
                return true
            end
            if char:GetAttribute("Knocked") == true then
                return true
            end
            return false
        end
        local function fn251()
            local char = localPlayer.Character
            if char then
                local var896, gun = pcall(function()
                    return char:FindFirstChild("Twist of Fate"):FindFirstChild("Right Arm"):FindFirstChild("gun")
                end)
                if var896 and gun then
                    return gun
                end
                local twistOfFate = char:FindFirstChild("Twist of Fate")
                if twistOfFate then
                    local rightArm = twistOfFate:FindFirstChild("Right Arm")
                    if rightArm and rightArm:FindFirstChild("gun") then
                        return rightArm.gun
                    end
                    return twistOfFate
                end
            end
            return nil
        end
        local function fn252()
            if not tbl.flag107 then
                return
            end
            if not fn250() then
                return
            end
            local now14 = tick()
            if now14 - num82 < 1 then
                return
            end
            local item = fn251()
            local currentCamera16 = Workspace.CurrentCamera
            if not item or not currentCamera16 then
                return
            end
            num82 = now14
            pcall(function()
                local lookVector6 = currentCamera16.CFrame.LookVector
                if tbl2.flag134 and typeof(tbl2.vector31) == "Vector3" then
                    lookVector6 = tbl2.vector31
                end
                fire2:FireServer(item, lookVector6)
            end)
        end
        UserInputService.InputBegan:Connect(function(input, arg173)
            if input.UserInputType == Enum.UserInputType.Touch then
                if tbl.flag107 and fn250() then
                    local pos = input.Position
                    for _, obj in ipairs(playerGui:GetDescendants()) do
                        if obj:IsA("ImageButton") and obj.Name == "Gui-mob" and obj.Visible then
                            local absolutePosition3, as = obj.AbsolutePosition, obj.AbsoluteSize
                            if pos.X >= absolutePosition3.X and pos.X <= absolutePosition3.X + as.X and pos.Y >= absolutePosition3.Y and pos.Y <= absolutePosition3.Y + as.Y then
                                fn252()
                                break
                            end
                        end
                    end
                end
                return
            end
            if arg173 then
                return
            end
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                fn252()
            elseif input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonR2 then
                fn252()
            end
        end)
    end
    fn5("UpdateSilentAimTarget", 0.02, function()
        if tbl2.frame1 then
            tbl2.frame1.Visible = tbl2.flag137
            local var897 = tbl.num120 * 2
            if tbl2.frame1.Size.X.Offset ~= var897 then
                tbl2.frame1.Size = UDim2.new(0, var897, 0, var897)
            end
        end
        if not tbl2.flag134 then
            tbl2.field17 = nil
            tbl2.vector31 = nil
            tbl2.field19 = nil
            tbl2.field18 = nil
            tbl2.list14 = {}
            tbl2.list15 = nil
            return
        end
        local character40 = localPlayer.Character
        if not character40 then
            return
        end
        local humanoidRootPart27 = character40:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart27 then
            return
        end
        local currentCamera17 = workspace.CurrentCamera
        if not currentCamera17 then
            return
        end
        local var898 = nil
        local huge7 = math.huge
        local var899 = nil
        local var900 = tbl.str14 or "Killer"
        if var900 == "Zombie" then
            if tick() - zombieCacheTime > 0.5 then
                RefreshZombieCache()
            end
            for i34 = 1, #var399 do
                local model = var399[i34]
                if model and model.Parent then
                    local var901 = GetScpModelRoot(model)
                    if var901 then
                        local pos = var901.Position
                        local dist = (pos - humanoidRootPart27.Position).Magnitude
                        if dist < huge7 then
                            huge7 = dist
                            var898 = pos
                            var899 = model
                        end
                    end
                end
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    if var900 == "Killer" and fn9(player) ~= "killer" then
                        continue
                    end
                    if var900 == "Survivor" and fn9(player) ~= "survivor" then
                        continue
                    end
                    local character41 = player.Character
                    if character41 then
                        local humanoid18 = character41:FindFirstChildOfClass("Humanoid")
                        local var902 = fn248(character41)
                        if humanoid18 and humanoid18.Health > 0 and typeof(var902) == "Vector3" then
                            local dist = (var902 - humanoidRootPart27.Position).Magnitude
                            if dist < huge7 then
                                huge7 = dist
                                var898 = var902
                                var899 = character41
                            end
                        end
                    end
                end
            end
        end
        local now15 = tick()
        local var903 = tbl2.vector359
        if typeof(var903) ~= "Vector3" then
            var903 = Vector3.new(0, 0, 0)
        end
        local num83 = 0
        local flag40 = false
        if typeof(var898) == "Vector3" then
            if tbl2.field18 ~= var899 then
                tbl2.field18 = var899
                tbl2.list14 = {}
                var903 = Vector3.new(0, 0, 0)
            end
            local hist = tbl2.list14
            table.insert(hist, {pos = var898, t = now15})
            while #hist > 1 and hist[1].t < now15 - 0.4 do
                table.remove(hist, 1)
            end
            if #hist >= 2 then
                local var904 = hist[#hist - 1]
                local var905 = hist[#hist]
                local var906 = var905.t - var904.t
                if var906 > 0.001 then
                    local var907 = (var905.pos - var904.pos) / var906
                    local vector351 = Vector3.new(var907.X, 0, var907.Z)
                    local var908 = var899 and var899:FindFirstChild("HumanoidRootPart")
                    if var908 and var908:IsA("BasePart") then
                        local var909, av = pcall(function()
                            return var908.AssemblyLinearVelocity
                        end)
                        if var909 and typeof(av) == "Vector3" then
                            local vector352 = Vector3.new(av.X, 0, av.Z)
                            if vector352.Magnitude > 0.5 and vector352.Magnitude < 100 then
                                vector351 = vector351:Lerp(vector352, 0.5)
                            end
                        end
                    end
                    if vector351.Magnitude > 65 then
                        vector351 = vector351.Unit * 65
                    end
                    if tbl.flag91 and var903.Magnitude > 2 and vector351.Magnitude > 2 then
                        num83 = var903:Dot(vector351) / (var903.Magnitude * vector351.Magnitude)
                        if num83 < 0 then
                            vector351 = vector351 * 0.7
                            flag40 = true
                        end
                    end
                    var903 = var903:Lerp(vector351, 0.45)
                end
            end
            local vector353 = Vector3.new(var903.X, 0, var903.Z)
            if vector353.Magnitude > 65 then
                vector353 = vector353.Unit * 65
            end
            var903 = vector353
        else
            tbl2.field18 = nil
            tbl2.list14 = {}
            var903 = Vector3.new(0, 0, 0)
        end
        tbl2.vector358 = var903
        tbl2.vector359 = var903
        if typeof(var898) == "Vector3" then
            local var910 = var898
            if typeof(var910) == "Vector3" then
                local flag41 = true
                local var911, onScreen = currentCamera17:WorldToViewportPoint(var910)
                if onScreen then
                    local vector24 = Vector2.new(currentCamera17.ViewportSize.X / 2, currentCamera17.ViewportSize.Y / 2)
                    local magnitude26 = (Vector2.new(var911.X, var911.Y) - vector24).Magnitude
                    if magnitude26 > tbl.num120 then
                        flag41 = false
                    end
                else
                    flag41 = false
                end
                if flag41 then
                    local var912 = fn249()
                    local flag42 = false
                    pcall(function()
                        local character42 = localPlayer.Character
                        if character42 then
                            if localPlayer:GetAttribute("IsDead") then
                                flag42 = true
                            end
                            if character42:GetAttribute("IsCarried") then
                                flag42 = true
                            end
                            if character42:GetAttribute("IsHooked") then
                                flag42 = true
                            end
                            if character42:GetAttribute("Knocked") == true then
                                flag42 = true
                            end
                            local humanoid19 = character42:FindFirstChildOfClass("Humanoid")
                            if humanoid19 and humanoid19.Health < humanoid19.MaxHealth * 0.5 then
                                flag42 = true
                            end
                        end
                    end)
                    if flag42 then
                        local humanoidRootPart28 = character40:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart28 then
                            var912 = humanoidRootPart28.Position
                        else
                            var912 = currentCamera17.CFrame.Position
                        end
                    end
                    if typeof(var912) ~= "Vector3" then
                        var912 = currentCamera17.CFrame.Position
                    end
                    local var913 = var910 - Vector3.new(0, 1.2, 0)
                    local var914 = var913 - var912
                    local magnitude27 = var914.Magnitude
                    if magnitude27 > 0.1 then
                        local var915 = var913
                        local var916 = magnitude27 / 200 + 0.1
                        local num84 = 0
                        local num85 = 0
                        if typeof(tbl2.vector359) == "Vector3" then
                            num85 = Vector3.new(tbl2.vector359.X, 0, tbl2.vector359.Z).Magnitude
                        end
                        if tbl.flag90 then
                            local var917 = tbl2.vector359
                            local num86 = 0.1
                            local tof = magnitude27 / 200 + num86
                            var915 = var913 + var917 * tof
                            local var918 = var915 - var912
                            if var918.Magnitude > 0.1 then
                                tof = var918.Magnitude / 200 + num86
                                var915 = var913 + var917 * tof
                            end
                            var916 = tof
                            num84 = (var915 - var913).Magnitude
                            tbl2.field19 = var915
                        else
                            tbl2.field19 = nil
                        end
                        local var919 = var915 - var912
                        local magnitude28 = var919.Magnitude
                        if magnitude28 > 0.1 then
                            tbl2.field17 = var910
                            tbl2.vector31 = Vector3.new(var919.X / magnitude28, var919.Y / magnitude28, var919.Z / magnitude28)
                            tbl2.field20 = var912
                            tbl2.field21 = var915
                            local num87 = 0
                            pcall(function()
                                if typeof(Spear_PingSec) == "function" then
                                    num87 = Spear_PingSec() or 0
                                end
                            end)
                            tbl2.list15 = {
                                dist = magnitude27,
                                tof = var916,
                                lead = num84,
                                vel = num85,
                                pred = tbl.flag90 and 1 or 0,
                                damp = tbl.flag91 and 1 or 0,
                                zig = flag40 and 1 or 0,
                                dot = num83 or 0,
                                ping = num87,
                                t = tick(),
                            }
                        else
                            tbl2.field17 = nil
                            tbl2.vector31 = nil
                            tbl2.list15 = nil
                        end
                    else
                        tbl2.field17 = nil
                        tbl2.vector31 = nil
                        tbl2.list15 = nil
                    end
                else
                    tbl2.field17 = nil
                    tbl2.vector31 = nil
                    tbl2.list15 = nil
                end
            else
                tbl2.field17 = nil
                tbl2.vector31 = nil
                tbl2.list15 = nil
            end
        else
            tbl2.field17 = nil
            tbl2.vector31 = nil
            tbl2.list15 = nil
        end
    end)
    local var920 = nil
    fn5("DrawLaserESP", 0, function()
        if tbl2.flag136 then
            tbl2.flag136 = false
            local var921 = tbl2.field20
            local var922 = tbl2.field21
            if typeof(var921) == "Vector3" and typeof(var922) == "Vector3" then
                local magnitude29 = (var921 - var922).Magnitude
                if magnitude29 >= 0.1 then
                    local part3 = Instance.new("Part")
                    part3.Name = "SilentLaser"
                    part3.Anchored = true
                    part3.CanCollide = false
                    part3.Material = Enum.Material.Neon
                    part3.Color = Color3.fromRGB(255, 0, 0)
                    part3.Transparency = 0.3
                    part3.Size = Vector3.new(0.15, 0.15, magnitude29)
                    part3.CFrame = CFrame.new(var921, var922) * CFrame.new(0, 0, -magnitude29 / 2)
                    part3.Parent = workspace
                    task.delay(0.4, function()
                        if part3 then
                            part3:Destroy()
                        end
                    end)
                end
            end
        end
        local char = localPlayer.Character
        local var923 = tbl2.flag135 and tbl2.flag134 and char ~= nil and char:GetAttribute("Aiming") == true
        local var924 = var923 and tbl2.field20 or nil
        local var925 = var923 and tbl2.field21 or nil
        local var926 = typeof(var924) == "Vector3" and typeof(var925) == "Vector3" and (var924 - var925).Magnitude or 0
        if var926 < 0.1 then
            if var920 then
                var920:Destroy()
                var920 = nil
            end
            return
        end
        if not var920 or not var920.Parent then
            var920 = Instance.new("Part")
            var920.Name = "SilentLaserAim"
            var920.Anchored = true
            var920.CanCollide = false
            var920.Material = Enum.Material.Neon
            var920.Color = Color3.fromRGB(255, 0, 0)
            var920.Transparency = 0.3
            var920.Parent = workspace
        end
        var920.Size = Vector3.new(0.15, 0.15, var926)
        var920.CFrame = CFrame.new(var924, var925) * CFrame.new(0, 0, -var926 / 2)
    end)
end
do
    local num88 = 30
    local function fn253(char)
        if not char then
            return false
        end
        if char:FindFirstChild("Flashlight") then
            return true
        end
        for _, v121 in ipairs(char:GetDescendants()) do
            if v121.Name == "Flashlight" and (v121:IsA("Model") or v121:IsA("Tool") or v121:IsA("Accessory")) then
                return true
            end
        end
        return false
    end
    local function fn254(character)
        if not character then
            return false
        end
        local humanoid20 = character:FindFirstChildOfClass("Humanoid")
        if not humanoid20 or humanoid20.Health <= 50 then
            return false
        end
        local var927 = character:GetAttribute("IsHooked") or character:GetAttribute("isHooked")
        if var927 == true then
            return false
        end
        return true
    end
    local function fn255(char)
        if not char then
            return nil
        end
        local head7 = char:FindFirstChild("Head")
        if head7 and head7:IsA("BasePart") then
            return head7
        end
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    end
    local function fn256()
        local character43 = localPlayer.Character
        local var928 = character43 and character43:FindFirstChild("HumanoidRootPart")
        if not var928 then
            return nil
        end
        local var929, huge8 = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and fn254(player.Character) then
                if fn9(player) == "killer" then
                    local part = fn255(player.Character)
                    if part and part:IsA("BasePart") then
                        local dist = (var928.Position - part.Position).Magnitude
                        if dist <= num88 and dist < huge8 then
                            huge8 = dist
                            var929 = part
                        end
                    end
                end
            end
        end
        return var929
    end
    local var930 = nil
    pcall(function()
        local remotes10 = ReplicatedStorage:FindFirstChild("Remotes")
        local items = remotes10 and remotes10:FindFirstChild("Items")
        local var931 = items and items:FindFirstChild("Flashlight")
        local var932 = var931 and var931:FindFirstChild("Activate")
        if var932 and var932:IsA("RemoteEvent") then
            var930 = var932
        end
    end)
    local var933
    pcall(function()
        var933 = hookmetamethod(game, "__namecall", function(self, ...)
            local var934 = getnamecallmethod()
            if var934 == "FireServer" and var930 and rawequal(self, var930) then
                local var935 = table.pack(...)
                pcall(function()
                    tbl2.flag156 = var935[2] == true
                end)
            end
            return var933(self, ...)
        end)
    end)
    fn5("FlashAimLock", 0.02, function()
        if not tbl2.flag155 then
            return
        end
        local var936 = fn253(localPlayer.Character)
        local var937 = fn9(localPlayer) ~= "killer"
        if not (var936 and var937 and tbl2.flag156) then
            return
        end
        local currentCamera18 = workspace.CurrentCamera
        if not currentCamera18 then
            return
        end
        local var938 = fn256()
        if not var938 then
            return
        end
        local position20 = var938.Position
        local smooth = math.clamp(tonumber(tbl2.num156) or 0.35, 0.05, 1)
        pcall(function()
            currentCamera18.CFrame = currentCamera18.CFrame:Lerp(CFrame.new(currentCamera18.CFrame.Position, position20), smooth)
        end)
        pcall(function()
            local char = localPlayer.Character
            local var939 = char and char:FindFirstChild("HumanoidRootPart")
            if var939 then
                var939.CFrame = CFrame.new(var939.Position, Vector3.new(position20.X, var939.Position.Y, position20.Z))
            end
        end)
    end)
end
local var940
do
    local vector354 = Vector3.new(0, -6000, 0)
    local num89 = 0.5
    local num90 = 5
    local tbl82 = {}
    local function fn257()
        local var941, var942 = pcall(function()
            local ReplicatedStorage6 = game:GetService("ReplicatedStorage")
            local remotes11 = ReplicatedStorage6:FindFirstChild("Remotes")
            if not remotes11 then
                return nil
            end
            local game4 = remotes11:FindFirstChild("Game")
            if not game4 then
                return nil
            end
            local e = game4:FindFirstChild("UpdateCharacterLook")
            if e and e:IsA("RemoteEvent") then
                return e
            end
            return nil
        end)
        if var941 then
            return var942
        end
        return nil
    end
    local function fn258(...)
        local tbl83 = {}
        local n = select("#", ...)
        for i35 = 1, n do
            local var944 = select(i35, ...)
            if typeof(var944) == "CFrame" then
                var944 = var944 + vector354
            end
            tbl83[i35] = var944
        end
        return table.unpack(tbl83, 1, n)
    end
    local function fn259()
        if not tbl2.flag157 then
            return false
        end
        local var945 = tbl2.list18
        if type(var945) ~= "table" or #var945 ~= 5 then
            return false
        end
        local var946 = fn257()
        if not var946 then
            return false
        end
        local var947 = table.pack(pcall(fn258, table.unpack(var945)))
        if not var947[1] then
            return false
        end
        local fireServer = var946.FireServer
        if typeof(fireServer) ~= "function" then
            return false
        end
        local var948 = pcall(fireServer, var946, table.unpack(var947, 2, var947.n))
        if var948 then
            tbl2.num158 = 0
            tbl2.num159 = tbl2.num159 + 1
        else
            tbl2.num158 = tbl2.num158 + 1
        end
        return var948
    end
    local function fn260()
        if tbl2.flag157 then
            return false
        end
        local var949 = tbl2.list18
        if type(var949) ~= "table" or #var949 ~= 5 then
            return false
        end
        local var950 = fn257()
        if not var950 then
            return false
        end
        local fireServer2 = var950.FireServer
        if typeof(fireServer2) ~= "function" then
            return false
        end
        return pcall(fireServer2, var950, table.unpack(var949))
    end
    local function fn261(character)
        if character == nil then
            return
        end
        for _, v122 in ipairs(character:GetChildren()) do
            if v122.Name == "Bolong_Invis" and v122:IsA("Highlight") then
                pcall(function()
                    v122:Destroy()
                end)
            end
        end
    end
    local function fn262(character)
        if tbl2.invisTagConn then
            pcall(function()
                tbl2.invisTagConn:Disconnect()
            end)
            tbl2.invisTagConn = nil
        end
        if character == nil then
            return
        end
        local var951 = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
        if var951 then
            local bolong_InvisTag = var951:FindFirstChild("Bolong_InvisTag")
            if bolong_InvisTag then
                pcall(function()
                    bolong_InvisTag:Destroy()
                end)
            end
        end
    end
    local function fn263(character, arg174)
        if character == nil then
            return
        end
        fn262(character)
        if not arg174 then
            return
        end
        local var952 = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
        if not var952 then
            return
        end
        local var960, var961 = pcall(function()
            local str6 = "[ Invisible ]"
            local num91 = 12
            local gothamBold = Enum.Font.GothamBold
            local num92 = 110
            pcall(function()
                local TextService = game:GetService("TextService")
                num92 = TextService:GetTextSize(str6, num91, gothamBold, Vector2.new(1000, 26)).X
            end)
            local num93, gap, glowR, margin = 14, 4, 1.5, 5
            local num94 = 14
            local var953 = math.ceil(margin * 2 + num93 + gap + num92)
            local var954 = num93 + margin * 2
            local gui = Instance.new("BillboardGui")
            gui.Name = "Bolong_InvisTag"
            gui.AlwaysOnTop = true
            gui.Size = UDim2.new(0, var953, 0, var954)
            gui.StudsOffset = Vector3.new(0, 1.5, 0)
            gui.Adornee = var952
            local var955, iconY = margin, margin
            local var956 = margin + num93 + gap
            local var957 = margin + math.floor((num93 - num94) / 2)
            local function fn264(arg175, arg176)
                return math.floor(arg175 * arg176 + 0.5)
            end
            local imageLabel4 = Instance.new("ImageLabel")
            imageLabel4.Name = "Icon"
            imageLabel4.Position = UDim2.fromOffset(var955, iconY)
            imageLabel4.Size = UDim2.new(0, num93, 0, num93)
            imageLabel4.BackgroundTransparency = 1
            imageLabel4.Image = "rbxassetid://84034353458936"
            imageLabel4.ZIndex = 2
            imageLabel4.Parent = gui
            local tbl84 = {}
            local tbl85 = {{2, 0.6}, {4, 0.85}}
            for i36, v123 in ipairs(tbl85) do
                local pad, transp = v123[1], v123[2]
                local imageLabel5 = Instance.new("ImageLabel")
                imageLabel5.Name = "Halo" .. i36
                imageLabel5.Position = UDim2.fromOffset(var955 - pad, iconY - pad)
                imageLabel5.Size = UDim2.new(0, num93 + pad * 2, 0, num93 + pad * 2)
                imageLabel5.BackgroundTransparency = 1
                imageLabel5.Image = "rbxassetid://84034353458936"
                imageLabel5.ImageColor3 = Color3.new(0, 0, 0)
                imageLabel5.ImageTransparency = transp
                imageLabel5.ZIndex = 1
                imageLabel5.Parent = gui
                tbl84[#tbl84 + 1] = {o = imageLabel5, pad = pad}
            end
            local tbl86 = {}
            local tbl87 = {
                {glowR, 0},
                {-glowR, 0},
                {0, glowR},
                {0, -glowR},
                {glowR * 0.7, glowR * 0.7},
                {glowR * 0.7, -glowR * 0.7},
                {-glowR * 0.7, glowR * 0.7},
                {-glowR * 0.7, -glowR * 0.7},
            }
            for i37, v124 in ipairs(tbl87) do
                local textLabel7 = Instance.new("TextLabel")
                textLabel7.Name = "Glow" .. i37
                textLabel7.Position = UDim2.fromOffset(var956 + v124[1], var957 + v124[2])
                textLabel7.Size = UDim2.new(0, num92, 0, num94)
                textLabel7.BackgroundTransparency = 1
                textLabel7.Text = str6
                textLabel7.TextColor3 = Color3.new(0, 0, 0)
                textLabel7.TextTransparency = 0.8
                textLabel7.TextSize = num91
                textLabel7.Font = gothamBold
                textLabel7.ZIndex = 1
                textLabel7.Parent = gui
                tbl86[#tbl86 + 1] = {o = textLabel7, dx = v124[1], dy = v124[2]}
            end
            local textLabel8 = Instance.new("TextLabel")
            textLabel8.Name = "Label"
            textLabel8.Position = UDim2.fromOffset(var956, var957)
            textLabel8.Size = UDim2.new(0, num92, 0, num94)
            textLabel8.BackgroundTransparency = 1
            textLabel8.Text = str6
            textLabel8.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel8.TextTransparency = 0
            textLabel8.TextSize = num91
            textLabel8.Font = gothamBold
            textLabel8.ZIndex = 2
            textLabel8.Parent = gui
            gui.Parent = var952
            local num95, minK, maxK = 25, 0.45, 1.35
            if tbl2.invisTagConn then
                pcall(function()
                    tbl2.invisTagConn:Disconnect()
                end)
                tbl2.invisTagConn = nil
            end
            tbl2.invisTagConn = game:GetService("RunService").RenderStepped:Connect(function()
                if not gui.Parent then
                    return
                end
                local currentCamera19 = workspace.CurrentCamera
                if not currentCamera19 then
                    return
                end
                local var958 = var952.Parent and var952.Position or nil
                if not var958 then
                    return
                end
                local dist = (currentCamera19.CFrame.Position - var958).Magnitude
                if dist < 1 then
                    dist = 1
                end
                local var959 = num95 / dist
                if var959 < minK then
                    var959 = minK
                elseif var959 > maxK then
                    var959 = maxK
                end
                gui.Size = UDim2.fromOffset(fn264(var953, var959), fn264(var954, var959))
                imageLabel4.Position = UDim2.fromOffset(fn264(var955, var959), fn264(iconY, var959))
                imageLabel4.Size = UDim2.fromOffset(fn264(num93, var959), fn264(num93, var959))
                for _, v125 in ipairs(tbl84) do
                    v125.o.Position = UDim2.fromOffset(fn264(var955 - v125.pad, var959), fn264(iconY - v125.pad, var959))
                    v125.o.Size = UDim2.fromOffset(fn264(num93 + v125.pad * 2, var959), fn264(num93 + v125.pad * 2, var959))
                end
                for _, v126 in ipairs(tbl86) do
                    v126.o.Position = UDim2.fromOffset(fn264(var956 + v126.dx, var959), fn264(var957 + v126.dy, var959))
                    v126.o.Size = UDim2.fromOffset(fn264(num92, var959), fn264(num94, var959))
                    v126.o.TextSize = fn264(num91, var959)
                end
                textLabel8.Position = UDim2.fromOffset(fn264(var956, var959), fn264(var957, var959))
                textLabel8.Size = UDim2.fromOffset(fn264(num92, var959), fn264(num94, var959))
                textLabel8.TextSize = fn264(num91, var959)
            end)
            return gui
        end)
        if not var960 or not var961 then
            fn262(character)
        end
    end
    local function fn265(character, arg177)
        if character == nil then
            return
        end
        fn261(character)
        if not arg177 then
            fn262(character)
            for _, part in ipairs(tbl82) do
                if part and part.Parent then
                    pcall(function()
                        part.Transparency = 0
                    end)
                end
            end
            tbl82 = {}
            return
        end
        tbl82 = {}
        for _, v127 in ipairs(character:GetDescendants()) do
            if v127:IsA("BasePart") and v127.Transparency == 0 then
                tbl82[#tbl82 + 1] = v127
            end
        end
        for _, part in ipairs(tbl82) do
            pcall(function()
                part.Transparency = num89
            end)
        end
        local var962, var963 = pcall(function()
            return Instance.new("Highlight")
        end)
        if var962 and var963 then
            var963.Name = "Bolong_Invis"
            var963.Adornee = character
            var963.FillColor = Color3.fromRGB(184, 106, 4)
            var963.OutlineColor = Color3.fromRGB(255, 255, 255)
            var963.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            var963.FillTransparency = 1
            var963.OutlineTransparency = 0
            var963.Parent = character
        end
        fn263(character, true)
    end
    local function fn266()
        if tbl2.flag158 then
            return
        end
        local var972 = pcall(function()
            assert(typeof(hookmetamethod) == "function", "hookmetamethod missing")
            assert(typeof(getnamecallmethod) == "function", "getnamecallmethod missing")
            assert(typeof(checkcaller) == "function", "checkcaller missing")
            local var964
            var964 = hookmetamethod(game, "__namecall", function(self, ...)
                if checkcaller() then
                    return var964(self, ...)
                end
                if getnamecallmethod() ~= "FireServer" then
                    return var964(self, ...)
                end
                local var965, nm = pcall(function()
                    return self.Name
                end)
                if not var965 or typeof(nm) ~= "string" then
                    return var964(self, ...)
                end
                if string.lower(nm) ~= "updatecharacterlook" then
                    return var964(self, ...)
                end
                if not tbl2.flag157 then
                    if select("#", ...) == 5 then
                        local var966, var967, var968, var969, e = ...
                        if typeof(var966) == "CFrame" and typeof(var967) == "CFrame" and typeof(var968) == "CFrame" and typeof(var969) == "CFrame" and typeof(e) == "CFrame" then
                            tbl2.list18 = {var966, var967, var968, var969, e}
                        end
                    end
                    return var964(self, ...)
                end
                local character44 = localPlayer.Character
                local var970 = character44 and character44:FindFirstChild("HumanoidRootPart")
                if var970 == nil then
                    return var964(self, ...)
                end
                if select("#", ...) ~= 5 then
                    tbl2.num157 = tbl2.num157 + 1
                    return nil
                end
                local var971 = table.pack(pcall(fn258, ...))
                if not var971[1] then
                    return var964(self, ...)
                end
                if tbl2.num158 >= num90 then
                    return var964(self, table.unpack(var971, 2, var971.n))
                end
                local fireServer3 = self.FireServer
                local flag43 = false
                if typeof(fireServer3) == "function" then
                    flag43 = pcall(fireServer3, self, table.unpack(var971, 2, var971.n))
                end
                if flag43 then
                    tbl2.num158 = 0
                    tbl2.num159 = tbl2.num159 + 1
                else
                    tbl2.num158 = tbl2.num158 + 1
                end
                return nil
            end)
        end)
        if var972 then
            tbl2.flag158 = true
        end
    end
    function var940(arg178)
        tbl2.flag157 = arg178 and true or false
        local char = localPlayer.Character
        if char then
            fn265(char, tbl2.flag157)
        end
        if tbl2.flag157 then
            fn259()
        else
            fn260()
        end
    end
    if not tbl2.connection25 then
        tbl2.connection25 = localPlayer.CharacterAdded:Connect(function(char)
            tbl2.list18 = nil
            if tbl2.flag157 then
                task.spawn(function()
                    task.wait(1)
                    if tbl2.flag157 then
                        fn265(char, true)
                    end
                end)
            end
        end)
    end
    pcall(function()
        local char = localPlayer.Character
        if char then
            fn261(char)
            fn262(char)
        end
    end)
    tbl2.flag157 = false
    fn266()
end
local var973, StopHiddenM2Hook
do
    local num96 = 50
    local num97 = 1.5
    local function fn267(character)
        if not character then
            return false
        end
        local humanoid21 = character:FindFirstChildOfClass("Humanoid")
        if not humanoid21 or humanoid21.Health <= 0 then
            return false
        end
        if character:GetAttribute("Knocked") then
            return false
        end
        if character:GetAttribute("IsHooked") then
            return false
        end
        if character:GetAttribute("IsCarried") then
            return false
        end
        return true
    end
    local function fn268()
        local character45 = localPlayer.Character
        local var974 = character45 and character45:FindFirstChild("HumanoidRootPart")
        if not var974 then
            return nil
        end
        local var975, huge9 = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and fn267(player.Character) then
                if fn9(player) ~= "killer" then
                    local part = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Head")
                    if part and part:IsA("BasePart") then
                        local dist = (var974.Position - part.Position).Magnitude
                        if dist <= num96 and dist < huge9 then
                            huge9 = dist
                            var975 = part
                        end
                    end
                end
            end
        end
        return var975
    end
    local function onEvent()
        if not tbl2.flag159 then
            return
        end
        local var976, isKiller = pcall(function()
            return fn9(localPlayer) == "killer"
        end)
        if not var976 or not isKiller then
            return
        end
        tbl2.num161 = tick() + num97
    end
    function var973()
        if tbl2.connection26 then
            return
        end
        pcall(function()
            local remotes12 = ReplicatedStorage:FindFirstChild("Remotes")
            local killers = remotes12 and remotes12:FindFirstChild("Killers")
            local var977 = killers and killers:FindFirstChild("Hidden")
            local var978 = var977 and var977:FindFirstChild("preparem2")
            if var978 and var978:IsA("BindableEvent") then
                tbl2.connection26 = var978.Event:Connect(onEvent)
            elseif var978 and var978:IsA("RemoteEvent") then
                tbl2.connection26 = var978.OnClientEvent:Connect(onEvent)
            else
                fn2("AIMLOCK M2", "preparem2 tidak ditemukan", 2)
            end
        end)
    end
    function StopHiddenM2Hook()
        if tbl2.connection26 then
            pcall(function()
                tbl2.connection26:Disconnect()
            end)
            tbl2.connection26 = nil
        end
        tbl2.num161 = 0
    end
    fn5("HiddenM2Aimlock", 0.02, function()
        if not tbl2.flag159 then
            return
        end
        if tick() > tbl2.num161 then
            return
        end
        local var979, isKiller = pcall(function()
            return fn9(localPlayer) == "killer"
        end)
        if not var979 or not isKiller then
            return
        end
        local currentCamera20 = workspace.CurrentCamera
        if not currentCamera20 then
            return
        end
        local var980 = fn268()
        if not var980 then
            return
        end
        local position21 = var980.Position
        local smooth = math.clamp(tonumber(tbl2.num160) or 1, 0.05, 1)
        pcall(function()
            currentCamera20.CFrame = currentCamera20.CFrame:Lerp(CFrame.new(currentCamera20.CFrame.Position, position21), smooth)
        end)
        pcall(function()
            local char = localPlayer.Character
            local var981 = char and char:FindFirstChild("HumanoidRootPart")
            if var981 then
                var981.CFrame = CFrame.new(var981.Position, Vector3.new(position21.X, var981.Position.Y, position21.Z))
            end
        end)
    end)
end
do
    local tbl88 = {hist = {}, char = nil, vector361 = Vector3.new(0, 0, 0)}
    local function fn269(char)
        if not char then
            return nil
        end
        local upperTorso4 = char:FindFirstChild("UpperTorso")
        if upperTorso4 and upperTorso4:IsA("BasePart") then
            return upperTorso4.Position
        end
        local torso3 = char:FindFirstChild("Torso")
        if torso3 and torso3:IsA("BasePart") then
            return torso3.Position
        end
        local humanoidRootPart29 = char:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart29 then
            return humanoidRootPart29.Position + Vector3.new(0, 0.5, 0)
        end
        return nil
    end
    local function fn270(arg179, targetPosition, fovRadius)
        local var982, onScreen = arg179:WorldToViewportPoint(targetPosition)
        if not onScreen then
            return false
        end
        local vector25 = Vector2.new(arg179.ViewportSize.X / 2, arg179.ViewportSize.Y / 2)
        local vector26 = Vector2.new(var982.X, var982.Y)
        local magnitude30 = (vector26 - vector25).Magnitude
        return magnitude30 <= fovRadius
    end
    local function fn271()
        local screenGui8 = Instance.new("ScreenGui")
        screenGui8.Name = "BolongSpearFOV"
        screenGui8.ResetOnSpawn = false
        screenGui8.DisplayOrder = 999999
        pcall(function()
            screenGui8.Parent = gethui and gethui() or game:GetService("CoreGui")
        end)
        if not screenGui8.Parent then
            screenGui8.Parent = playerGui
        end
        tbl2.frame17 = Instance.new("Frame")
        tbl2.frame17.Size = UDim2.new(0, tbl.num121 * 2, 0, tbl.num121 * 2)
        tbl2.frame17.Position = UDim2.new(0.5, 0, 0.5, 0)
        tbl2.frame17.AnchorPoint = Vector2.new(0.5, 0.5)
        tbl2.frame17.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tbl2.frame17.BackgroundTransparency = 1
        tbl2.frame17.Visible = false
        tbl2.frame17.Parent = screenGui8
        local uICorner9 = Instance.new("UICorner")
        uICorner9.CornerRadius = UDim.new(1, 0)
        uICorner9.Parent = tbl2.frame17
        local uIStroke8 = Instance.new("UIStroke")
        uIStroke8.Color = color3
        uIStroke8.Thickness = 2
        uIStroke8.Transparency = 0.2
        uIStroke8.Parent = tbl2.frame17
    end
    fn271()
    local function fn272()
        local screenGui9 = Instance.new("ScreenGui")
        screenGui9.Name = "SpearIndicatorUI"
        screenGui9.ResetOnSpawn = false
        screenGui9.Enabled = false
        screenGui9.DisplayOrder = 999998
        screenGui9.IgnoreGuiInset = true
        pcall(function()
            screenGui9.Parent = gethui and gethui() or game:GetService("CoreGui")
        end)
        if not screenGui9.Parent then
            screenGui9.Parent = playerGui
        end
        tbl2.frame19 = Instance.new("Frame")
        tbl2.frame19.Name = "MainFrame"
        tbl2.frame19.Size = UDim2.new(0, 180, 0, 42)
        tbl2.frame19.Position = UDim2.new(0.5, 0, 0.82, 0)
        tbl2.frame19.AnchorPoint = Vector2.new(0.5, 0.5)
        tbl2.frame19.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        tbl2.frame19.BackgroundTransparency = 0.1
        tbl2.frame19.BorderSizePixel = 0
        tbl2.frame19.Parent = screenGui9
        local uICorner10 = Instance.new("UICorner")
        uICorner10.CornerRadius = UDim.new(0, 8)
        uICorner10.Parent = tbl2.frame19
        local uIStroke9 = Instance.new("UIStroke")
        uIStroke9.Color = Color3.fromRGB(45, 45, 55)
        uIStroke9.Thickness = 1
        uIStroke9.Transparency = 0.2
        uIStroke9.Parent = tbl2.frame19
        local uIGradient = Instance.new("UIGradient")
        uIGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 40)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20)),
        })
        uIGradient.Rotation = 90
        uIGradient.Parent = tbl2.frame19
        tbl2.frame18 = Instance.new("Frame")
        tbl2.frame18.Name = "AccentBar"
        tbl2.frame18.Size = UDim2.new(0, 3, 1, -12)
        tbl2.frame18.Position = UDim2.new(0, 6, 0, 6)
        tbl2.frame18.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        tbl2.frame18.BorderSizePixel = 0
        tbl2.frame18.Parent = tbl2.frame19
        local uICorner11 = Instance.new("UICorner")
        uICorner11.CornerRadius = UDim.new(1, 0)
        uICorner11.Parent = tbl2.frame18
        tbl2.textLabel1 = Instance.new("TextLabel")
        tbl2.textLabel1.Name = "StatusText"
        tbl2.textLabel1.Size = UDim2.new(1, -18, 0, 18)
        tbl2.textLabel1.Position = UDim2.new(0, 14, 0, 5)
        tbl2.textLabel1.BackgroundTransparency = 1
        tbl2.textLabel1.Text = "NO TARGET"
        tbl2.textLabel1.TextColor3 = Color3.fromRGB(255, 255, 255)
        tbl2.textLabel1.TextSize = 13
        tbl2.textLabel1.Font = Enum.Font.GothamBold
        tbl2.textLabel1.TextXAlignment = Enum.TextXAlignment.Left
        tbl2.textLabel1.TextTruncate = Enum.TextTruncate.AtEnd
        tbl2.textLabel1.Parent = tbl2.frame19
        tbl2.textLabel10 = Instance.new("TextLabel")
        tbl2.textLabel10.Name = "InfoText"
        tbl2.textLabel10.Size = UDim2.new(1, -18, 0, 14)
        tbl2.textLabel10.Position = UDim2.new(0, 14, 0, 23)
        tbl2.textLabel10.BackgroundTransparency = 1
        tbl2.textLabel10.Text = "Aim to Survivor"
        tbl2.textLabel10.TextColor3 = Color3.fromRGB(160, 160, 170)
        tbl2.textLabel10.TextSize = 10
        tbl2.textLabel10.Font = Enum.Font.Gotham
        tbl2.textLabel10.TextXAlignment = Enum.TextXAlignment.Left
        tbl2.textLabel10.TextTruncate = Enum.TextTruncate.AtEnd
        tbl2.textLabel10.Parent = tbl2.frame19
        tbl2.field25 = screenGui9
    end
    fn272()
    local function fn273()
        tbl2.screenGui1 = Instance.new("ScreenGui")
        tbl2.screenGui1.Name = "SpearVeil_SnapLine"
        tbl2.screenGui1.IgnoreGuiInset = true
        tbl2.screenGui1.ResetOnSpawn = false
        tbl2.screenGui1.DisplayOrder = 999999
        pcall(function()
            tbl2.screenGui1.Parent = gethui and gethui() or game:GetService("CoreGui")
        end)
        if not tbl2.screenGui1.Parent then
            tbl2.screenGui1.Parent = playerGui
        end
        tbl2.frame20 = Instance.new("Frame")
        tbl2.frame20.Name = "Line"
        tbl2.frame20.AnchorPoint = Vector2.new(0.5, 0.5)
        tbl2.frame20.BorderSizePixel = 0
        tbl2.frame20.BackgroundColor3 = Color3.fromRGB(255, 220, 0)
        tbl2.frame20.BackgroundTransparency = 0.35
        tbl2.frame20.Visible = false
        tbl2.frame20.Parent = tbl2.screenGui1
        tbl2.frame21 = Instance.new("Frame")
        tbl2.frame21.Name = "Dot"
        tbl2.frame21.AnchorPoint = Vector2.new(0.5, 0.5)
        tbl2.frame21.BorderSizePixel = 0
        tbl2.frame21.BackgroundColor3 = Color3.fromRGB(255, 220, 0)
        tbl2.frame21.BackgroundTransparency = 0
        tbl2.frame21.Size = UDim2.fromOffset(4, 4)
        tbl2.frame21.Visible = false
        tbl2.frame21.Parent = tbl2.screenGui1
        local uICorner12 = Instance.new("UICorner")
        uICorner12.CornerRadius = UDim.new(1, 0)
        uICorner12.Parent = tbl2.frame21
        tbl2.textLabel11 = Instance.new("TextLabel")
        tbl2.textLabel11.Name = "InfoText"
        tbl2.textLabel11.AnchorPoint = Vector2.new(0.5, 1)
        tbl2.textLabel11.Size = UDim2.new(0, 200, 0, 16)
        tbl2.textLabel11.BackgroundTransparency = 1
        tbl2.textLabel11.Text = ""
        tbl2.textLabel11.TextColor3 = Color3.fromRGB(255, 255, 255)
        tbl2.textLabel11.TextSize = 12
        tbl2.textLabel11.Font = Enum.Font.GothamBold
        tbl2.textLabel11.TextStrokeTransparency = 0
        tbl2.textLabel11.TextStrokeColor3 = Color3.new(0, 0, 0)
        tbl2.textLabel11.TextXAlignment = Enum.TextXAlignment.Center
        tbl2.textLabel11.TextTruncate = Enum.TextTruncate.AtEnd
        tbl2.textLabel11.Visible = false
        tbl2.textLabel11.Parent = tbl2.screenGui1
    end
    fn273()
    local function fn274(arg180, arg181, speed, arg182)
        local var984 = math.cos(arg181)
        if var984 <= 0.015 then
            return nil, nil
        end
        local travelTime = arg180 / (speed * var984)
        if travelTime ~= travelTime or travelTime <= 0 then
            return nil, nil
        end
        local num98 = 0.016666666666666666
        local var985 = 0.5 * arg182 * num98 * travelTime
        local var986 = speed * math.sin(arg181) * travelTime - 0.5 * arg182 * travelTime * travelTime - var985
        return var986, travelTime
    end
    local function fn275(arg183, arg184, arg185, speed, arg186)
        local var987, travelTime = fn274(arg183, arg185, speed, arg186)
        if not var987 or not travelTime then
            return nil
        end
        if travelTime < 0.025 or travelTime > 5 then
            return nil
        end
        local var988 = math.abs(var987 - arg184)
        local var989 = math.max(arg185 - var48, 0) * 0.35
        local var990 = math.max(travelTime - 1.3, 0) * 0.25
        return var988 + var989 + var990, var988, travelTime
    end
    local function fn276(arg187, arg188, speed, arg189)
        if speed <= 0 then
            speed = 142.5
        end
        if arg189 <= 0 then
            arg189 = 196.2
        end
        local var991 = arg188 - arg187
        local vector355 = Vector3.new(var991.X, 0, var991.Z)
        local magnitude31 = vector355.Magnitude
        local Y3 = var991.Y
        if var991.Magnitude <= 0.001 then
            return nil
        end
        if magnitude31 <= 0.35 or arg189 <= 0.001 then
            return var991.Unit, math.clamp(var991.Magnitude / speed, 0.025, 5)
        end
        local unit9 = vector355.Unit
        local var992 = math.atan2(Y3, magnitude31)
        local var993 = math.max(-var49, var992 - var50)
        local var994 = var51
        local var995, bestScore, bestError, bestTime = nil, math.huge, math.huge, nil
        local var996 = magnitude31 > 80
        local var997 = var996 and 44 or 30
        local var998 = var996 and 0.08 or num5
        for i38 = 0, var997 do
            local var999 = var993 + (var994 - var993) * (i38 / var997)
            local var1000, var1001, travelTime = fn275(magnitude31, Y3, var999, speed, arg189)
            if var1000 and var1000 < bestScore then
                bestScore, bestError, var995, bestTime = var1000, var1001, var999, travelTime
                if bestError < var998 then
                    break
                end
            end
        end
        if var995 then
            local var1002 = (var994 - var993) / var997 * 2.5
            local var1003 = bestError < var998 and 1 or (var996 and 6 or 4)
            for _ = 1, var1003 do
                local var1004, localBestScore, localBestError, localBestTime = var995, bestScore, bestError, bestTime
                for j2 = -3, 3 do
                    local var1005 = math.clamp(var995 + var1002 * (j2 / 3), var993, var994)
                    local var1006, var1007, travelTime = fn275(magnitude31, Y3, var1005, speed, arg189)
                    if var1006 and var1006 < localBestScore then
                        localBestScore, localBestError, var1004, localBestTime = var1006, var1007, var1005, travelTime
                    end
                end
                var995, bestScore, bestError, bestTime = var1004, localBestScore, localBestError, localBestTime
                if bestError < var998 then
                    break
                end
                var1002 = var1002 * 0.38
            end
        end
        if not var995 then
            local var1008 = math.clamp(magnitude31 / speed, 0.025, 5)
            local var1009 = math.min(0.5 * arg189 * var1008 * var1008, 15)
            local var1010 = arg188 + Vector3.new(0, var1009, 0)
            local var1011 = var1010 - arg187
            if var1011.Magnitude <= 0.001 then
                return nil
            end
            return var1011.Unit, var1008
        end
        local var1012 = unit9 * math.cos(var995) + Vector3.new(0, math.sin(var995), 0)
        if var1012.Magnitude <= 0.001 then
            return nil
        end
        return var1012.Unit, bestTime
    end
    local function fn277(arg190, arg191, speed, arg192)
        if speed <= 0 or arg192 <= 0 then
            return false
        end
        local var1013, var1014, var1015, var1016 = arg190, arg191, speed, arg192
        local var1017 = var1016 * var1013 * var1013 / (2 * var1015 * var1015)
        if var1017 <= 0 then
            return false
        end
        local var1018, var1019, var1020 = var1017, -var1013, var1014 + var1017
        return var1019 * var1019 - 4 * var1018 * var1020 >= 0
    end
    local function fn278(arg193, arg194, arg195)
        for t = 0.1, 3, 0.05 do
            local num99 = 23
            if t < 1 then
                num99 = math.max(23, t * 150)
            elseif t < 2 then
                num99 = 142.5
            else
                num99 = 165
            end
            if fn277(arg193, arg194, num99, arg195) then
                return t
            end
        end
        return nil
    end
    do
        local spearthrow = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Veil"):WaitForChild("Spearthrow")
        local visualize = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("visualize")
        visualize.OnClientEvent:Connect(function(ownerChar, spearDir, spearSpeed, gravityMult)
            if ownerChar == localPlayer.Character then
                if type(spearSpeed) == "number" and spearSpeed >= 15 and spearSpeed <= 800 then
                    tbl2.num142 = spearSpeed
                end
                if type(gravityMult) == "number" and gravityMult > 0.2 and gravityMult <= 5 then
                    tbl2.num143 = gravityMult
                end
                local spearLastShot = tbl2.spearLastShot
                if spearLastShot and tick() - (spearLastShot.t or 0) < 5 and (spearLastShot.speed or 0) > 1 and type(spearSpeed) == "number" and spearSpeed >= 15 and spearSpeed <= 800 then
                    local var1021 = spearSpeed / spearLastShot.speed
                    if var1021 > 0.2 and var1021 < 5 then
                        local var1022 = tonumber(tbl2.num144) or 1
                        tbl2.num144 = math.clamp(var1022 + (var1021 - 1) * 0.3, 0.5, 2)
                    end
                end
            end
        end)
        local var1023
        var1023 = hookmetamethod(game, "__namecall", function(...)
            local var1024 = getnamecallmethod()
            if var1024 == "FireServer" then
                local var1025 = table.pack(...)
                local self = var1025[1]
                if typeof(self) == "Instance" and rawequal(self, spearthrow) then
                    if tbl2.flag138 and typeof(tbl2.field23) == "Vector3" then
                        if var1025.n >= 4 and typeof(var1025[2]) == "Vector3" and typeof(var1025[4]) == "Vector3" then
                            var1025[2] = tbl2.field23
                            local spearLastShot2 = tbl2.spearLastShot
                            if spearLastShot2 then
                                print(string.format((function()
                                    if var30 and buffer then
                                        local _bf = buffer.create(99)
                                        local _by = {
                                            91,
                                            83,
                                            112,
                                            101,
                                            97,
                                            114,
                                            93,
                                            32,
                                            102,
                                            105,
                                            114,
                                            101,
                                            32,
                                            100,
                                            105,
                                            115,
                                            116,
                                            61,
                                            37,
                                            46,
                                            48,
                                            102,
                                            32,
                                            115,
                                            112,
                                            100,
                                            61,
                                            37,
                                            46,
                                            48,
                                            102,
                                            40,
                                            114,
                                            97,
                                            119,
                                            37,
                                            46,
                                            48,
                                            102,
                                            44,
                                            99,
                                            97,
                                            108,
                                            37,
                                            46,
                                            50,
                                            102,
                                            41,
                                            32,
                                            116,
                                            111,
                                            102,
                                            61,
                                            37,
                                            46,
                                            50,
                                            102,
                                            32,
                                            108,
                                            101,
                                            97,
                                            100,
                                            61,
                                            37,
                                            46,
                                            49,
                                            102,
                                            32,
                                            112,
                                            105,
                                            110,
                                            103,
                                            61,
                                            37,
                                            46,
                                            48,
                                            102,
                                            109,
                                            115,
                                            32,
                                            103,
                                            114,
                                            97,
                                            118,
                                            61,
                                            37,
                                            46,
                                            50,
                                            102,
                                            32,
                                            115,
                                            116,
                                            97,
                                            98,
                                            61,
                                            37,
                                            46,
                                            50,
                                            102,
                                        }
                                        for _i = 1, #_by do
                                            buffer.writeu8(_bf, _i - 1, _by[_i])
                                        end
                                        local _s = {}
                                        for _i = 1, #_by do
                                            _s[_i] = string.char(buffer.readu8(_bf, _i - 1))
                                        end
                                        return table.concat(_s)
                                    else
                                        local _by = {
                                            91,
                                            83,
                                            112,
                                            101,
                                            97,
                                            114,
                                            93,
                                            32,
                                            102,
                                            105,
                                            114,
                                            101,
                                            32,
                                            100,
                                            105,
                                            115,
                                            116,
                                            61,
                                            37,
                                            46,
                                            48,
                                            102,
                                            32,
                                            115,
                                            112,
                                            100,
                                            61,
                                            37,
                                            46,
                                            48,
                                            102,
                                            40,
                                            114,
                                            97,
                                            119,
                                            37,
                                            46,
                                            48,
                                            102,
                                            44,
                                            99,
                                            97,
                                            108,
                                            37,
                                            46,
                                            50,
                                            102,
                                            41,
                                            32,
                                            116,
                                            111,
                                            102,
                                            61,
                                            37,
                                            46,
                                            50,
                                            102,
                                            32,
                                            108,
                                            101,
                                            97,
                                            100,
                                            61,
                                            37,
                                            46,
                                            49,
                                            102,
                                            32,
                                            112,
                                            105,
                                            110,
                                            103,
                                            61,
                                            37,
                                            46,
                                            48,
                                            102,
                                            109,
                                            115,
                                            32,
                                            103,
                                            114,
                                            97,
                                            118,
                                            61,
                                            37,
                                            46,
                                            50,
                                            102,
                                            32,
                                            115,
                                            116,
                                            97,
                                            98,
                                            61,
                                            37,
                                            46,
                                            50,
                                            102,
                                        }
                                        local _s = {}
                                        for _i = 1, #_by do
                                            _s[_i] = string.char(_by[_i])
                                        end
                                        return table.concat(_s)
                                    end
                                end)(), spearLastShot2.dist or 0, spearLastShot2.speed or 0, spearLastShot2.raw or 0, tonumber(tbl2.num144) or 1, spearLastShot2.tof or 0, spearLastShot2.lead or 0, (spearLastShot2.ping or 0) * 1000, spearLastShot2.grav or 1, spearLastShot2.stab == nil and -1 or spearLastShot2.stab))
                            end
                            return var1023(table.unpack(var1025, 1, var1025.n))
                        end
                    end
                end
            end
            return var1023(...)
        end)
        local var1026
        var1026 = hookmetamethod(game, "__index", function(t, arg196)
            if arg196 == "FireServer" and typeof(t) == "Instance" and rawequal(t, spearthrow) then
                return newcclosure(function(...)
                    local var1027 = table.pack(...)
                    if tbl2.flag138 and typeof(tbl2.field23) == "Vector3" then
                        if var1027.n >= 4 and typeof(var1027[2]) == "Vector3" and typeof(var1027[4]) == "Vector3" then
                            var1027[2] = tbl2.field23
                            local spearLastShot3 = tbl2.spearLastShot
                            if spearLastShot3 then
                                print(string.format("[Spear] fire dist=%.0f spd=%.0f(raw%.0f,cal%.2f) tof=%.2f lead=%.1f ping=%.0fms grav=%.2f stab=%.2f", spearLastShot3.dist or 0, spearLastShot3.speed or 0, spearLastShot3.raw or 0, tonumber(tbl2.num144) or 1, spearLastShot3.tof or 0, spearLastShot3.lead or 0, (spearLastShot3.ping or 0) * 1000, spearLastShot3.grav or 1, spearLastShot3.stab == nil and -1 or spearLastShot3.stab))
                            end
                        end
                    end
                    return var1026(t, arg196)(table.unpack(var1027, 1, var1027.n))
                end)
            end
            return var1026(t, arg196)
        end)
    end
    do
        local tbl89 = {}
        local function fn279(arg197, name)
            local var1028 = arg197 and arg197.Parent
            while var1028 do
                if var1028.Name == name then
                    return true
                end
                var1028 = var1028.Parent
            end
            return false
        end
        local function fn280(arg198)
            if not (arg198 and arg198:IsA("GuiButton")) then
                return false
            end
            if arg198.Name ~= "attack" and arg198.Name ~= "Gui-mob" then
                return false
            end
            if not fn279(arg198, "Slasher-mob") and not fn279(arg198, "Survivor-mob") then
                return false
            end
            if not fn279(arg198, "Control") and not fn279(arg198, "Controls") then
                return false
            end
            return true
        end
        local function fn281(arg199)
            if not fn280(arg199) then
                return
            end
            if tbl89[arg199] then
                return
            end
            tbl89[arg199] = true
            arg199.InputBegan:Connect(function(input)
                local t = input.UserInputType
                if t ~= Enum.UserInputType.Touch and t ~= Enum.UserInputType.MouseButton1 then
                    return
                end
                local char = localPlayer.Character
                if char and char:GetAttribute("spearmode") then
                    tbl2.flag141 = true
                    tbl2.now1 = tick()
                end
            end)
            arg199.InputEnded:Connect(function(input)
                local t = input.UserInputType
                if t ~= Enum.UserInputType.Touch and t ~= Enum.UserInputType.MouseButton1 then
                    return
                end
                tbl2.flag141 = false
                tbl2.now1 = nil
            end)
        end
        local function fn282()
            local var1029 = localPlayer:FindFirstChildOfClass("PlayerGui") or playerGui
            if not var1029 then
                return
            end
            pcall(function()
                local function fn283(screenName)
                    local var1030 = var1029:FindFirstChild(screenName, true)
                    if not var1030 then
                        return
                    end
                    local var1031 = var1030:FindFirstChild("Control") or var1030:FindFirstChild("Controls")
                    if var1031 then
                        local function fn284(arg200)
                            for _, v128 in ipairs(arg200:GetChildren()) do
                                fn281(v128)
                                fn284(v128)
                            end
                        end
                        fn284(var1031)
                    end
                    local guiMob2 = var1030:FindFirstChild("Gui-mob", true)
                    if guiMob2 and guiMob2:IsA("GuiButton") then
                        fn281(guiMob2)
                    end
                end
                fn283("Slasher-mob")
                fn283("Survivor-mob")
            end)
            var1029.DescendantAdded:Connect(function(arg201)
                fn281(arg201)
            end)
        end
        UserInputService.InputBegan:Connect(function(input, arg202)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local char = localPlayer.Character
                if char and char:GetAttribute("spearmode") then
                    tbl2.flag141 = true
                    tbl2.now1 = tick()
                end
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                tbl2.flag141 = false
                tbl2.now1 = nil
            end
        end)
        fn282()
    end
    fn5("Spear_UpdateSnapLine", 0, function(arg203)
        local SPEAR_SNAPLINE = tbl2.SPEAR_SNAPLINE
        if not SPEAR_SNAPLINE.enabled then
            if tbl2.frame20 then
                tbl2.frame20.Visible = false
            end
            if tbl2.frame21 then
                tbl2.frame21.Visible = false
            end
            if tbl2.textLabel11 then
                tbl2.textLabel11.Visible = false
            end
            SPEAR_SNAPLINE.flag142 = false
            SPEAR_SNAPLINE.field24 = nil
            SPEAR_SNAPLINE.str17 = ""
            return
        end
        local currentCamera21 = Workspace.CurrentCamera
        if not currentCamera21 then
            if tbl2.frame20 then
                tbl2.frame20.Visible = false
            end
            if tbl2.frame21 then
                tbl2.frame21.Visible = false
            end
            if tbl2.textLabel11 then
                tbl2.textLabel11.Visible = false
            end
            return
        end
        local character46 = localPlayer.Character
        local var1032 = character46 and character46:GetAttribute("spearmode")
        if not var1032 then
            if tbl2.frame20 then
                tbl2.frame20.Visible = false
            end
            if tbl2.frame21 then
                tbl2.frame21.Visible = false
            end
            if tbl2.textLabel11 then
                tbl2.textLabel11.Visible = false
            end
            return
        end
        local viewportSize4 = currentCamera21.ViewportSize
        local vector27 = Vector2.new(viewportSize4.X / 2, viewportSize4.Y / 2)
        local var1033 = character46 and character46:FindFirstChild("HumanoidRootPart")
        local function fn285()
            local var1034 = nil
            local huge10 = math.huge
            local bestDist3D = math.huge
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and fn9(player) == "survivor" then
                    local character47 = player.Character
                    if character47 then
                        local humanoid22 = character47:FindFirstChildOfClass("Humanoid")
                        local var1035 = fn269(character47)
                        if var1035 and humanoid22 and humanoid22.Health > 0 and humanoid22.Health > 50 and not character47:GetAttribute("IsHooked") then
                            local var1036 = var1033 and (var1035 - var1033.Position).Magnitude or 0
                            if var1036 <= tbl.spearSnaplineMaxDistance then
                                local var1037, onScreen = currentCamera21:WorldToViewportPoint(var1035)
                                if onScreen then
                                    local magnitude32 = (Vector2.new(var1037.X, var1037.Y) - vector27).Magnitude
                                    if magnitude32 <= tbl.num121 then
                                        if magnitude32 < huge10 then
                                            huge10 = magnitude32
                                            bestDist3D = var1036
                                            var1034 = player
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return var1034, huge10, bestDist3D
        end
        if tbl2.flag141 and not SPEAR_SNAPLINE.flag142 then
            local var1038, _, bestDist3D = fn285()
            if var1038 then
                SPEAR_SNAPLINE.flag142 = true
                SPEAR_SNAPLINE.field24 = var1038
                SPEAR_SNAPLINE.str17 = var1038.Name
                SPEAR_SNAPLINE.huge1 = bestDist3D
            end
        end
        if not tbl2.flag141 then
            SPEAR_SNAPLINE.flag142 = false
            SPEAR_SNAPLINE.field24 = nil
            SPEAR_SNAPLINE.str17 = ""
        end
        local flag44 = false
        local var1039 = nil
        local num100 = 0
        local var1040 = nil
        if SPEAR_SNAPLINE.flag142 and SPEAR_SNAPLINE.field24 then
            local character48 = SPEAR_SNAPLINE.field24.Character
            if character48 then
                local humanoid23 = character48:FindFirstChildOfClass("Humanoid")
                local var1041 = fn269(character48)
                if var1041 and humanoid23 and humanoid23.Health > 50 and not character48:GetAttribute("IsHooked") then
                    local var1042, onScreen = currentCamera21:WorldToViewportPoint(var1041)
                    if onScreen then
                        local magnitude33 = (Vector2.new(var1042.X, var1042.Y) - vector27).Magnitude
                        if magnitude33 <= tbl.num121 * 1.15 then
                            var1039 = Vector2.new(var1042.X, var1042.Y)
                            num100 = var1033 and (var1041 - var1033.Position).Magnitude or 0
                            var1040 = var1041
                            flag44 = true
                            SPEAR_SNAPLINE.huge1 = num100
                        end
                    end
                end
            end
            if not flag44 then
                SPEAR_SNAPLINE.flag142 = false
                SPEAR_SNAPLINE.field24 = nil
                SPEAR_SNAPLINE.str17 = ""
            end
        end
        local var1043 = nil
        local num101 = 0
        local var1044 = nil
        local var1045 = nil
        if not SPEAR_SNAPLINE.flag142 then
            local var1046, _, bestDist3D = fn285()
            if var1046 then
                local var1047 = fn269(var1046.Character)
                local var1048, _ = currentCamera21:WorldToViewportPoint(var1047)
                var1043 = Vector2.new(var1048.X, var1048.Y)
                num101 = bestDist3D
                var1044 = var1047
                var1045 = var1046
                SPEAR_SNAPLINE.huge1 = bestDist3D
            end
        end
        local flag45 = false
        if tbl2.flag141 and tbl2.now1 and var1033 then
            local var1049 = var1040 or var1045 and fn269(var1045.Character)
            if var1049 then
                local position22 = currentCamera21.CFrame.Position
                local var1050 = var1049 - position22
                local vector356 = Vector3.new(var1050.X, 0, var1050.Z)
                local magnitude34 = vector356.Magnitude
                local Y4 = var1050.Y
                local var1051 = Workspace.Gravity * (tbl2.num143 or 1)
                local var1052 = fn278(magnitude34, Y4, var1051)
                if var1052 then
                    local var1053 = tick() - tbl2.now1
                    if var1053 >= var1052 then
                        flag45 = true
                    end
                end
            end
        end
        local var1054 = nil
        local str7 = ""
        local num102 = 0
        if SPEAR_SNAPLINE.flag142 and flag44 then
            var1054 = var1039
            str7 = SPEAR_SNAPLINE.str17
            num102 = num100
        elseif var1043 then
            var1054 = var1043
            str7 = var1045 and var1045.Name or ""
            num102 = num101
        end
        local var1061 = pcall(function()
            if not tbl2.frame20 or not tbl2.frame21 or not tbl2.textLabel11 or not currentCamera21 then
                if tbl2.frame20 then
                    tbl2.frame20.Visible = false
                end
                if tbl2.frame21 then
                    tbl2.frame21.Visible = false
                end
                if tbl2.textLabel11 then
                    tbl2.textLabel11.Visible = false
                end
                return
            end
            if not var1054 then
                tbl2.frame20.Visible = false
                tbl2.frame21.Visible = false
                tbl2.textLabel11.Visible = false
                SPEAR_SNAPLINE.huge1 = math.huge
                return
            end
            local var1055 = vector27
            local var1056 = var1054
            local var1057 = var1056 - var1055
            local length = var1057.Magnitude
            if length < 2 then
                tbl2.frame20.Visible = false
                tbl2.frame21.Visible = false
                tbl2.textLabel11.Visible = false
                return
            end
            local var1058 = flag45
            local var1059 = var1058 and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 220, 0)
            local var1060 = var1058 and 0.08 or 0.35
            tbl2.frame20.BackgroundColor3 = var1059
            tbl2.frame20.BackgroundTransparency = var1060
            tbl2.frame20.Size = UDim2.fromOffset(length, var1058 and 2 or 1)
            tbl2.frame20.Position = UDim2.fromOffset((var1055.X + var1056.X) * 0.5, (var1055.Y + var1056.Y) * 0.5)
            tbl2.frame20.Rotation = math.deg(math.atan2(var1057.Y, var1057.X))
            tbl2.frame20.Visible = true
            tbl2.frame21.BackgroundColor3 = var1059
            tbl2.frame21.Position = UDim2.fromOffset(var1056.X, var1056.Y)
            tbl2.frame21.Visible = true
            if tbl.flag94 and str7 ~= "" then
                tbl2.textLabel11.Text = string.format("%s [%dm]", str7, math.floor(num102))
                tbl2.textLabel11.TextColor3 = var1059
                tbl2.textLabel11.Position = UDim2.fromOffset(var1056.X, var1056.Y - 14)
                tbl2.textLabel11.Visible = true
            else
                tbl2.textLabel11.Visible = false
            end
        end)
        if not var1061 then
            if tbl2.frame20 then
                tbl2.frame20.Visible = false
            end
            if tbl2.frame21 then
                tbl2.frame21.Visible = false
            end
            if tbl2.textLabel11 then
                tbl2.textLabel11.Visible = false
            end
        end
    end)
    fn5("Spear_UpdateSpearSystem", 0, function()
        if tbl2.frame17 then
            tbl2.frame17.Visible = tbl2.flag140
            local var1062 = tbl.num121 * 2
            if tbl2.frame17.Size.X.Offset ~= var1062 then
                tbl2.frame17.Size = UDim2.new(0, var1062, 0, var1062)
            end
        end
        if not tbl2.flag138 then
            tbl2.field22 = nil
            tbl2.field23 = nil
        end
        local character49 = localPlayer.Character
        local var1063 = character49 and character49:GetAttribute("spearmode")
        if not tbl2.flag139 or not var1063 then
            if tbl2.field25 then
                tbl2.field25.Enabled = false
            end
            if not tbl2.flag138 or not var1063 then
                return
            end
        end
        local var1064 = character49 and character49:FindFirstChild("HumanoidRootPart")
        if not var1064 then
            return
        end
        local currentCamera22 = workspace.CurrentCamera
        if not currentCamera22 then
            return
        end
        if tbl2.flag139 and var1063 and tbl2.field25 then
            tbl2.field25.Enabled = true
        end
        local var1065 = nil
        local huge11 = math.huge
        local bestDist3D = math.huge
        local flag46 = false
        local vector28 = Vector2.new(currentCamera22.ViewportSize.X / 2, currentCamera22.ViewportSize.Y / 2)
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and fn9(player) == "survivor" then
                local character50 = player.Character
                if character50 then
                    local humanoid24 = character50:FindFirstChildOfClass("Humanoid")
                    local var1066 = fn269(character50)
                    local humanoidRootPart30 = character50:FindFirstChild("HumanoidRootPart")
                    if humanoid24 and humanoid24.Health > 50 and typeof(var1066) == "Vector3" and humanoidRootPart30 and not character50:GetAttribute("IsHooked") then
                        local magnitude35 = (var1066 - var1064.Position).Magnitude
                        local var1067, onScreen = currentCamera22:WorldToViewportPoint(var1066)
                        if onScreen then
                            local magnitude36 = (Vector2.new(var1067.X, var1067.Y) - vector28).Magnitude
                            if magnitude36 <= tbl.num121 then
                                if magnitude36 < huge11 then
                                    huge11 = magnitude36
                                    bestDist3D = magnitude35
                                    var1065 = player
                                    flag46 = true
                                end
                            elseif not flag46 and magnitude35 < bestDist3D then
                                bestDist3D = magnitude35
                                var1065 = player
                            end
                        elseif not flag46 and magnitude35 < bestDist3D then
                            bestDist3D = magnitude35
                            var1065 = player
                        end
                    end
                end
            end
        end
        if var1065 and var1065.Character then
            local var1068 = fn269(var1065.Character)
            if var1068 then
                flag46 = fn270(currentCamera22, var1068, tbl.num121)
            end
        end
        if tbl2.flag139 and var1063 then
            if not var1065 or not var1065.Character then
                tbl2.textLabel1.Text = "NO TARGET"
                tbl2.textLabel1.TextColor3 = Color3.fromRGB(200, 200, 200)
                tbl2.frame18.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                tbl2.textLabel10.Text = "Aim to Survivor"
                return
            end
            local var1069 = fn269(var1065.Character)
            local position23 = currentCamera22.CFrame.Position
            local var1070 = var1069 - position23
            local vector357 = Vector3.new(var1070.X, 0, var1070.Z)
            local magnitude37 = vector357.Magnitude
            local Y5 = var1070.Y
            local magnitude38 = var1070.Magnitude
            local var1071 = Workspace.Gravity * (tbl2.num143 or 1)
            local var1072 = fn278(magnitude37, Y5, var1071)
            local name9 = var1065.Name
            local var1073 = string.format("%.0f", magnitude38)
            if not var1072 then
                tbl2.textLabel1.Text = "OUT OF RANGE"
                tbl2.textLabel1.TextColor3 = Color3.fromRGB(255, 80, 80)
                tbl2.frame18.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                tbl2.textLabel10.Text = string.format("%s | %s studs", name9, var1073)
            elseif not flag46 then
                tbl2.textLabel1.Text = "AIM AT TARGET"
                tbl2.textLabel1.TextColor3 = Color3.fromRGB(255, 150, 150)
                tbl2.frame18.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
                local var1074, onScreen = currentCamera22:WorldToViewportPoint(var1069)
                local vector29 = Vector2.new(currentCamera22.ViewportSize.X / 2, currentCamera22.ViewportSize.Y / 2)
                local magnitude39 = (Vector2.new(var1074.X, var1074.Y) - vector29).Magnitude
                local var1075 = string.format("%.0f", magnitude39 - tbl.num121)
                if not onScreen then
                    tbl2.textLabel10.Text = "Target di belakang kamera"
                else
                    tbl2.textLabel10.Text = string.format("Masuk FOV: %s px lagi", var1075)
                end
            elseif not tbl2.flag141 then
                tbl2.textLabel1.Text = "READY"
                tbl2.textLabel1.TextColor3 = Color3.fromRGB(255, 255, 255)
                tbl2.frame18.BackgroundColor3 = Color3.fromRGB(150, 150, 200)
                tbl2.textLabel10.Text = string.format("%s | %s studs | Hold: %ss", name9, var1073, string.format("%.2f", var1072))
            else
                local var1076 = tick() - tbl2.now1
                local var1077 = string.format("%.2f", var1076)
                local var1078 = string.format("%.2f", var1072)
                local var1079 = fn270(currentCamera22, var1069, tbl.num121)
                if not var1079 then
                    tbl2.textLabel1.Text = "AIM AT TARGET"
                    tbl2.textLabel1.TextColor3 = Color3.fromRGB(255, 150, 150)
                    tbl2.frame18.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
                    tbl2.textLabel10.Text = "Target keluar FOV!"
                elseif var1076 >= var1072 then
                    local stabNow = tbl2.spearLastStab
                    if stabNow ~= nil and stabNow < 0.35 then
                        tbl2.textLabel1.Text = "UNSTABLE!"
                        tbl2.textLabel1.TextColor3 = Color3.fromRGB(255, 150, 50)
                        tbl2.frame18.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
                        tbl2.textLabel10.Text = (function()
                            if var30 and buffer then
                                local _bf = buffer.create(32)
                                local _by = {
                                    84,
                                    97,
                                    114,
                                    103,
                                    101,
                                    116,
                                    32,
                                    98,
                                    101,
                                    114,
                                    109,
                                    97,
                                    110,
                                    117,
                                    118,
                                    101,
                                    114,
                                    44,
                                    32,
                                    116,
                                    97,
                                    104,
                                    97,
                                    110,
                                    32,
                                    100,
                                    117,
                                    108,
                                    117,
                                    46,
                                    46,
                                    46,
                                }
                                for _i = 1, #_by do
                                    buffer.writeu8(_bf, _i - 1, _by[_i])
                                end
                                local _s = {}
                                for _i = 1, #_by do
                                    _s[_i] = string.char(buffer.readu8(_bf, _i - 1))
                                end
                                return table.concat(_s)
                            else
                                local _by = {
                                    84,
                                    97,
                                    114,
                                    103,
                                    101,
                                    116,
                                    32,
                                    98,
                                    101,
                                    114,
                                    109,
                                    97,
                                    110,
                                    117,
                                    118,
                                    101,
                                    114,
                                    44,
                                    32,
                                    116,
                                    97,
                                    104,
                                    97,
                                    110,
                                    32,
                                    100,
                                    117,
                                    108,
                                    117,
                                    46,
                                    46,
                                    46,
                                }
                                local _s = {}
                                for _i = 1, #_by do
                                    _s[_i] = string.char(_by[_i])
                                end
                                return table.concat(_s)
                            end
                        end)()
                    else
                        tbl2.textLabel1.Text = "RELEASE!"
                        tbl2.textLabel1.TextColor3 = Color3.fromRGB(80, 255, 120)
                        tbl2.frame18.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
                        tbl2.textLabel10.Text = string.format("Hold: %ss | Ideal: %ss", var1077, var1078)
                    end
                else
                    tbl2.textLabel1.Text = "HOLD..."
                    tbl2.textLabel1.TextColor3 = Color3.fromRGB(255, 220, 100)
                    tbl2.frame18.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
                    tbl2.textLabel10.Text = string.format("Hold: %ss | Ideal: %ss", var1077, var1078)
                end
            end
        end
        if tbl2.flag138 and var1063 and var1065 and var1065.Character then
            local var1080 = fn269(var1065.Character)
            local humanoidRootPart31 = var1065.Character:FindFirstChild("HumanoidRootPart")
            if typeof(var1080) == "Vector3" and humanoidRootPart31 then
                local var1081 = fn270(currentCamera22, var1080, tbl.num121)
                if var1081 then
                    local position24 = currentCamera22.CFrame.Position
                    local var1082 = var1080 - position24
                    local magnitude40 = var1082.Magnitude
                    if magnitude40 > 0.1 then
                        local num103 = 142.5
                        if tbl2.flag141 and tbl2.now1 then
                            local var1083 = tick() - tbl2.now1
                            if var1083 >= 2 then
                                num103 = 165
                            elseif var1083 >= 1 then
                                num103 = 142.5
                            else
                                num103 = math.max(23, var1083 * 150)
                            end
                        end
                        local var1084 = num103
                        num103 = var1084 * (tonumber(tbl2.num144) or 1)
                        local var1085 = Workspace.Gravity * (tbl2.num143 or 1)
                        local var1086, stabNow = nil, 1
                        if tbl.flag92 then
                            var1086, stabNow = var89(tbl88, var1065.Character, var1080)
                        else
                            tbl88.char, tbl88.hist, tbl88.vector361 = nil, {}, Vector3.new(0, 0, 0)
                            tbl88.turn = 0
                            local vel = humanoidRootPart31.AssemblyLinearVelocity
                            var1086 = Vector3.new(vel.X, 0, vel.Z)
                            if var1086.Magnitude > 65 then
                                var1086 = var1086.Unit * 65
                            end
                        end
                        tbl2.vector360 = var1086
                        tbl2.spearLastStab = math.clamp(stabNow or 1, 0, 1)
                        local num104 = 1
                        if tbl.flag93 then
                            num104 = 0.55 + 0.45 * tbl2.spearLastStab
                        end
                        local var1087, travelTime = fn276(position24, var1080, num103, var1085)
                        if var1087 and travelTime then
                            local var1088 = Spear_PingSec() * (tonumber(tbl.spearPingLead) or 1)
                            local lead = tbl2.vector360 * ((travelTime + var1088) * num104)
                            local var1089 = math.max(magnitude40 * 0.4, 4)
                            if lead.Magnitude > var1089 then
                                lead = lead.Unit * var1089
                            end
                            local predictedPos = var1080 + lead
                            local var1090, finalTime = fn276(position24, predictedPos, num103, var1085)
                            if var1090 and finalTime and finalTime > 0.35 then
                                local var1091 = tbl2.vector360 * ((finalTime + var1088) * num104)
                                if var1091.Magnitude > var1089 then
                                    var1091 = var1091.Unit * var1089
                                end
                                local var1092 = var1080 + var1091
                                local var1093 = fn276(position24, var1092, num103, var1085)
                                if var1093 then
                                    var1090, predictedPos = var1093, var1092
                                end
                            end
                            if var1090 then
                                tbl2.field22 = predictedPos
                                tbl2.field23 = var1090
                                tbl2.spearLastShot = {
                                    dist = magnitude40,
                                    speed = num103,
                                    raw = var1084,
                                    tof = travelTime,
                                    lead = lead.Magnitude,
                                    ping = var1088,
                                    t = tick(),
                                    grav = tbl2.num143 or 1,
                                    stab = tbl2.spearLastStab,
                                }
                            else
                                tbl2.field22 = nil
                                tbl2.field23 = nil
                                tbl2.spearLastShot = nil
                            end
                        else
                            tbl2.field22 = nil
                            tbl2.field23 = nil
                        end
                    else
                        tbl2.field22 = nil
                        tbl2.field23 = nil
                    end
                else
                    tbl2.field22 = nil
                    tbl2.field23 = nil
                end
            else
                tbl2.field22 = nil
                tbl2.field23 = nil
            end
        else
            tbl2.field22 = nil
            tbl2.field23 = nil
        end
    end)
end
local var1094, StopJerk
do
    local var1095 = nil
    local var1096 = nil
    local var1097 = nil
    local track = nil
    local flag47 = false
    local function onUnequipped()
        flag47 = false
        if track then
            pcall(function()
                track:Stop()
            end)
            track = nil
        end
    end
    function StopJerk()
        onUnequipped()
        if var1096 then
            pcall(function()
                task.cancel(var1096)
            end)
            var1096 = nil
        end
        if var1095 then
            pcall(function()
                var1095:Destroy()
            end)
            var1095 = nil
        end
    end
    function var1094()
        StopJerk()
        local char = localPlayer.Character
        if not char then
            return
        end
        local humanoid25 = char:FindFirstChildOfClass("Humanoid")
        local backpack = localPlayer:FindFirstChildOfClass("Backpack")
        if not humanoid25 or not backpack then
            return
        end
        var1095 = Instance.new("Tool")
        var1095.Name = "Jerk Off"
        var1095.ToolTip = "in the stripped club. straight up \"jorking it\" . and by \"it\" , haha, well. let's justr say. My peanits."
        var1095.RequiresHandle = false
        var1095.Parent = backpack
        var1095.Equipped:Connect(function()
            flag47 = true
        end)
        var1095.Unequipped:Connect(onUnequipped)
        humanoid25.Died:Connect(onUnequipped)
        var1096 = task.spawn(function()
            while task.wait() do
                if not flag47 then
                    continue
                end
                local character51 = localPlayer.Character
                local var1098 = character51 and character51:FindFirstChildOfClass("Humanoid")
                if not var1098 then
                    continue
                end
                local var1099 = var1098.RigType == Enum.HumanoidRigType.R15
                if not track then
                    var1097 = Instance.new("Animation")
                    var1097.AnimationId = not var1099 and "rbxassetid://72042024" or "rbxassetid://698251653"
                    pcall(function()
                        track = var1098:LoadAnimation(var1097)
                    end)
                end
                if track then
                    pcall(function()
                        track:Play()
                        track:AdjustSpeed(var1099 and 0.7 or 0.65)
                        track.TimePosition = 0.6
                    end)
                    task.wait(0.1)
                    while track and track.TimePosition < (not var1099 and 0.65 or 0.7) do
                        task.wait(0.1)
                    end
                    if track then
                        pcall(function()
                            track:Stop()
                        end)
                        track = nil
                    end
                end
            end
        end)
    end
end
local var1100, StopNoclip
do
    local var1102 = nil
    local tbl90 = {}
    local var1103 = getgenv and getgenv() or _G
    var1103.BolongNoclipGen = (tonumber(var1103.BolongNoclipGen) or 0) + 1
    local bolongNoclipGen = var1103.BolongNoclipGen
    local function fn286(char, collideOn)
        if not char then
            return
        end
        if not tbl90[char] then
            tbl90[char] = {}
        end
        local var1104 = tbl90[char]
        if collideOn then
            for part, _ in pairs(var1104) do
                if part and part.Parent then
                    pcall(function()
                        part.CanCollide = true
                    end)
                end
            end
            tbl90[char] = {}
        else
            for _, v129 in ipairs(char:GetDescendants()) do
                if v129:IsA("BasePart") and var1104[v129] == nil then
                    local var1105, cur = pcall(function()
                        return v129.CanCollide
                    end)
                    if var1105 and cur then
                        var1104[v129] = true
                        pcall(function()
                            v129.CanCollide = false
                        end)
                    end
                end
            end
        end
    end
    local function fn287()
        local tbl91 = {}
        for char, _ in pairs(tbl90) do
            if not char or not char.Parent then
                tbl91[#tbl91 + 1] = char
            end
        end
        for _, char in ipairs(tbl91) do
            tbl90[char] = nil
        end
    end
    function var1100()
        StopNoclip()
        tbl2.flag166 = true
        var1102 = RunService.Stepped:Connect(function()
            if bolongNoclipGen ~= var1103.BolongNoclipGen then
                pcall(function()
                    var1102:Disconnect()
                end)
                var1102 = nil
                return
            end
            if not tbl2.flag166 then
                return
            end
            local char = localPlayer.Character
            if char then
                fn286(char, false)
            end
        end)
    end
    function StopNoclip()
        tbl2.flag166 = false
        if var1102 then
            pcall(function()
                var1102:Disconnect()
            end)
            var1102 = nil
        end
        fn287()
        local char = localPlayer.Character
        if char then
            fn286(char, true)
        end
    end
    localPlayer.CharacterAdded:Connect(function()
        fn287()
    end)
    fn287()
    pcall(function()
        local char = localPlayer.Character
        if char then
            fn286(char, true)
        end
    end)
end
local var1106, StopFlyGui
do
    local str8 = "https://raw.githubusercontent.com/b00l08g87b/trbg/refs/heads/main/FlyGuiV3.lua"
    local function fn288()
        local char = localPlayer.Character
        if not char then
            return
        end
        local humanoidRootPart32 = char:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart32 then
            pcall(function()
                humanoidRootPart32.AssemblyLinearVelocity = Vector3.zero
            end)
        end
        local humanoid26 = char:FindFirstChildOfClass("Humanoid")
        if humanoid26 then
            pcall(function()
                humanoid26.PlatformStand = false
            end)
            for _, v130 in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
                if v130 ~= Enum.HumanoidStateType.None then
                    pcall(function()
                        humanoid26:SetStateEnabled(v130, true)
                    end)
                end
            end
        end
        for _, v131 in ipairs(char:GetDescendants()) do
            if v131:IsA("BodyGyro") or v131:IsA("BodyVelocity") or v131:IsA("BodyPosition") or v131:IsA("BodyForce") then
                pcall(function()
                    v131:Destroy()
                end)
            end
        end
        local animate = char:FindFirstChild("Animate")
        if animate then
            pcall(function()
                animate.Disabled = false
            end)
        end
    end
    function var1106()
        pcall(function()
            local main = playerGui:FindFirstChild("main")
            if main then
                main:Destroy()
            end
        end)
        local var1107, err = pcall(function()
            loadstring(game:HttpGet(str8))()
        end)
        if not var1107 then
            fn2("Fly GUI", "Gagal memuat: " .. tostring(err), 2)
        end
    end
    function StopFlyGui()
        pcall(function()
            local var1108 = getgenv and getgenv() or _G
            var1108.nowe = false
            var1108.tpwalking = false
        end)
        pcall(function()
            local gui = playerGui:FindFirstChild("main")
            if gui then
                gui:Destroy()
            end
        end)
        fn288()
    end
    pcall(function()
        local var1109 = getgenv and getgenv() or _G
        var1109.nowe = false
        var1109.tpwalking = false
    end)
end
do
    local function fn289(player, char)
        if player == localPlayer then
            return
        end
        if not char or not char.Parent or player.Character ~= char then
            return
        end
        AttachESPToChar(player, char)
        AttachOutlineToChar(player, char)
        if tbl2.flag116 or AP_State and AP_State.Enabled then
            if AP_HookKiller then
                AP_HookKiller(player, char)
            end
        end
    end
    local function onPlayerAdded2(player)
        if player == localPlayer then
            return
        end
        fn10(player)
        var195(player)
        var196(player)
        player:GetPropertyChangedSignal("Team"):Connect(function()
            fn10(player)
            task.wait(0.2)
            if tbl2.flag116 or AP_State and AP_State.Enabled then
                if AP_HookKiller then
                    AP_HookKiller(player)
                end
            end
        end)
        if player.Character then
            task.spawn(function()
                fn289(player, player.Character)
            end)
        end
        player.CharacterAdded:Connect(function(char)
            task.spawn(function()
                fn289(player, char)
            end)
        end)
    end
    local function onPlayerRemoving2(player)
    end
    Players.PlayerAdded:Connect(onPlayerAdded2)
    Players.PlayerRemoving:Connect(onPlayerRemoving2)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            onPlayerAdded2(player)
        end
    end
    local function fn290(char)
        tbl2.flag121 = false
        tbl2.health1 = nil
        tbl2.flag129 = false
        tbl2.flag130 = false
        CV_ClearLock()
        if tbl2.flag127 then
            task.defer(CV_ScanAttackButtons)
        end
        task.spawn(SetupMovementForChar, char)
        if tbl2.flag122 then
            task.wait(0.3)
            fn72()
            fn71()
        end
        if tbl.flag75 then
            task.wait(0.1)
            tbl2.fieldOfView1 = nil
            fn111(tbl.num117)
        end
        if tbl.flag71 then
            task.wait(0.1)
            tbl2.cameraMaxZoomDistance1 = nil
            fn106(tbl.cameraZoomValue)
        end
        if tbl.flag77 then
            task.delay(1, function()
                pcall(DestroyGenBoostButton)
                pcall(CreateGenBoostButton)
            end)
        end
        if fn9(localPlayer) ~= "killer" and FP_ReArm then
            task.delay(1, function()
                if fn9(localPlayer) ~= "killer" then
                    pcall(FP_ReArm)
                end
            end)
        end
    end
    if localPlayer.Character then
        task.spawn(fn290, localPlayer.Character)
    end
    localPlayer.CharacterAdded:Connect(function(char)
        task.spawn(fn290, char)
    end)
end
do
    local var1110 = nil
    local var1111 = nil
    local function fn291()
        local window = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Window")
        if not window then
            return
        end
        var1110 = window:FindFirstChild("fastvault")
        var1111 = window:FindFirstChild("VaultCompleteEventpart1")
    end
    pcall(fn291)
    local function fn292()
        if not tbl.flag102 then
            return
        end
        local now16 = tick()
        if now16 < tbl2.num153 then
            return
        end
        tbl2.num154 = now16 + 0.5
        tbl2.num153 = now16 + (tbl.num125 or 15)
    end
    local function fn293()
        local flag48 = false
        local function fn294(arg204)
            return arg204:IsA("BasePart") and (arg204.Name == "VaultTrigger" or arg204.Name == "VaultPoint")
        end
        local function onDescendantAdded5(arg205)
            if not fn294(arg205) then
                return
            end
            for _, v132 in ipairs(tbl2.fastVaultPoints) do
                if v132 == arg205 then
                    return
                end
            end
            table.insert(tbl2.fastVaultPoints, arg205)
        end
        local function onDescendantRemoving3(arg206)
            for i39, v133 in ipairs(tbl2.fastVaultPoints) do
                if v133 == arg206 then
                    table.remove(tbl2.fastVaultPoints, i39)
                    break
                end
            end
        end
        if flag48 then
            return
        end
        flag48 = true
        for _, v134 in ipairs(CollectionService:GetTagged("VaultPoint")) do
            onDescendantAdded5(v134)
        end
        Workspace.DescendantAdded:Connect(onDescendantAdded5)
        Workspace.DescendantRemoving:Connect(onDescendantRemoving3)
    end
    fn293()
    local function fn295(pos, arg207)
        local var1112, var1113 = nil, arg207
        for _, v135 in ipairs(tbl2.fastVaultPoints) do
            if v135 and v135.Parent then
                local magnitude41 = (v135.Position - pos).Magnitude
                if magnitude41 < var1113 then
                    var1113 = magnitude41
                    var1112 = v135
                end
            end
        end
        return var1112
    end
    fn5("FastVault", 0.05, function()
        if not tbl.flag101 then
            return
        end
        if fn9(localPlayer) == "killer" then
            return
        end
        local char = localPlayer.Character
        local var1114 = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not var1114 then
            return
        end
        if fn295(var1114.Position, 6) then
            pcall(function()
                char:SetAttribute("Sprinting", true)
                char:SetAttribute("IsRunning", true)
            end)
        end
    end)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not tbl.flag101 then
            return
        end
        if fn9(localPlayer) == "killer" then
            return
        end
        if gameProcessed then
            return
        end
        local keyCode = input.KeyCode
        if keyCode ~= Enum.KeyCode.Space and keyCode ~= Enum.KeyCode.E then
            return
        end
        local char = localPlayer.Character
        local var1115 = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not var1115 then
            return
        end
        local var1116 = fn295(var1115.Position, 9)
        if not var1116 then
            return
        end
        local var1117 = var1116.Position - var1115.Position
        var1117 = Vector3.new(var1117.X, 0, var1117.Z)
        if var1117.Magnitude > 0.05 then
            var1117 = var1117.Unit
        else
            var1117 = Vector3.new(var1115.CFrame.LookVector.X, 0, var1115.CFrame.LookVector.Z).Unit
        end
        local vel = var1115.AssemblyLinearVelocity
        local speed = Vector3.new(vel.X, 0, vel.Z).Magnitude
        if speed < 13 then
            pcall(function()
                char:SetAttribute("Sprinting", true)
                char:SetAttribute("IsRunning", true)
            end)
            var1115.CFrame = CFrame.new(var1115.Position, var1115.Position + var1117)
            var1115.AssemblyLinearVelocity = var1117 * 22
        end
    end)
    local var1119, SurvivorActions = pcall(function()
        local modules = ReplicatedStorage:FindFirstChild("Modules", true)
        local var1118 = modules and modules:FindFirstChild("SurvivorActions", true)
        return var1118 and require(var1118)
    end)
    if var1119 and SurvivorActions and SurvivorActions.startVault then
        local startVault = SurvivorActions.startVault
        SurvivorActions.startVault = newcclosure(function(controller, vaultPoint)
            fn292()
            pcall(FP_MarkVault)
            if not tbl.flag101 then
                return startVault(controller, vaultPoint)
            end
            pcall(function()
                local char = controller and controller.character
                if char then
                    char:SetAttribute("Sprinting", true)
                    char:SetAttribute("IsRunning", true)
                    local humanoidRootPart33 = char:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart33 then
                        local var1120 = vaultPoint and (vaultPoint.Position or vaultPoint:IsA("Model") and vaultPoint.PrimaryPart and vaultPoint.PrimaryPart.Position)
                        if var1120 then
                            local var1121 = var1120 - humanoidRootPart33.Position
                            var1121 = Vector3.new(var1121.X, 0, var1121.Z)
                            if var1121.Magnitude > 0.05 then
                                humanoidRootPart33.AssemblyLinearVelocity = var1121.Unit * 22
                            end
                        end
                    end
                end
            end)
            local tbl92 = {startVault(controller, vaultPoint)}
            if var1110 then
                pcall(function()
                    var1110:FireServer(localPlayer)
                end)
            end
            if var1111 then
                pcall(function()
                    var1111:FireServer()
                end)
            end
            return unpack(tbl92)
        end)
    end
    pcall(function()
        local modules2 = ReplicatedStorage:FindFirstChild("Modules", true)
        local var1122 = modules2 and modules2:FindFirstChild("SurvivorAnimationsController", true)
        local var1123 = var1122 and require(var1122)
        if var1123 and var1123._isFacingStraightEnough then
            local _isFacingStraightEnough = var1123._isFacingStraightEnough
            var1123._isFacingStraightEnough = newcclosure(function(...)
                if not tbl.flag101 then
                    return _isFacingStraightEnough(...)
                end
                return true
            end)
        end
    end)
    local function fn296()
        local tbl93 = {
            gui = nil,
            panel = nil,
            rows = nil,
            taskName = "KillerPerksInfo",
            field40 = nil,
            dragConn = {},
            perkSet = {},
            flag174 = false,
            field41 = nil,
            flag175 = false,
        }
        local tbl94 = {
            "Predator",
            "Eternal Torment",
            "Play With Your Food",
            "Terror Spread",
            "Sloppy Mess",
            "Resentment Clinger",
            "Echo Location",
            "Enhanced Senses",
            "Next in Line",
            "Corrupted Path",
            "Abyssal Covenant",
            "Shadow Trace",
            "Piercing Reverie",
            "Blood Between Worlds",
            "Echo Of The Void",
            "Excitement",
            "Brutal Strength",
            "Offscreen Scare",
            "Hard Swing",
            "Combo Streak",
            "Crackdown",
            "Sustenance",
            "Foundation Staff",
            "Desire For The Living",
            "Deep Wound",
            "All Seeing Eye",
            "Touch Of Death",
            "Murderous Acrobatics",
            "Eyes Of Hell",
            "Stage Fright",
            "Trade Off",
            "Containment",
            "King's Scourge",
        }
        local function fn297(name)
            if not name then
                return ""
            end
            return tostring(name):lower():gsub("[^%a%d]", ""):gsub("excitment", "excitement")
        end
        local tbl95 = {exposuretherapy = true}
        local function fn298(name)
            if not name or name == "" then
                return
            end
            local var1124 = fn297(name)
            if var1124 == "" then
                return
            end
            if tbl95[var1124] then
                return
            end
            tbl93.perkSet[var1124] = name
        end
        local function fn299()
            if tbl93.flag174 then
                return
            end
            tbl93.flag174 = true
            for _, v136 in ipairs(tbl94) do
                fn298(v136)
            end
            pcall(function()
                local tbl96 = {
                    ReplicatedStorage:FindFirstChild("Killers"),
                    ReplicatedStorage:FindFirstChild("ShopKillers"),
                    ReplicatedStorage:FindFirstChild("Perks"),
                    ReplicatedStorage:FindFirstChild("KillerPerks"),
                }
                for _, v137 in ipairs(tbl96) do
                    if v137 then
                        for _, v138 in ipairs(v137:GetChildren()) do
                            if v137.Name == "Perks" or v137.Name == "KillerPerks" then
                                fn298(v138.Name)
                            else
                                local perks = v138:FindFirstChild("Perks")
                                if perks then
                                    for _, v139 in ipairs(perks:GetChildren()) do
                                        fn298(v139.Name)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        local function fn300()
            for _, v140 in ipairs(Players:GetPlayers()) do
                if fn9(v140) == "killer" then
                    return v140
                end
            end
            for _, v141 in ipairs(Players:GetPlayers()) do
                local var1125, var1126 = pcall(function()
                    return v141.Team and v141.Team.Name or ""
                end)
                if var1125 and tostring(var1126):lower():find("killer") then
                    return v141
                end
            end
            return nil
        end
        local function fn301(arg208, arg209)
            if arg208 == "" then
                return
            end
            for k19, v142 in pairs(tbl93.perkSet) do
                if arg208 == k19 or arg208:find(k19, 1, true) or k19:find(arg208, 1, true) then
                    if not arg209[v142] then
                        arg209[v142] = true
                    end
                    return
                end
            end
        end
        local function fn302(killer)
            local tbl97 = {}
            local function fn303(name)
                fn301(fn297(name), tbl97)
            end
            local char = killer.Character
            pcall(function()
                for _, v143 in pairs(killer:GetAttributes()) do
                    fn303(tostring(v143))
                end
                for name in pairs(killer:GetAttributes()) do
                    fn303(name)
                end
            end)
            pcall(function()
                local var1127 = killer:FindFirstChild("EquippedPerks") or killer:FindFirstChild("Perks")
                if var1127 then
                    for _, v144 in ipairs(var1127:GetChildren()) do
                        fn303(v144.Name)
                        if v144:IsA("ValueBase") and type(v144.Value) == "string" then
                            fn303(v144.Value)
                        end
                    end
                end
            end)
            if char then
                pcall(function()
                    for _, v145 in pairs(char:GetAttributes()) do
                        fn303(tostring(v145))
                    end
                    for name in pairs(char:GetAttributes()) do
                        fn303(name)
                    end
                end)
                pcall(function()
                    for _, v146 in ipairs(char:GetChildren()) do
                        fn303(v146.Name)
                    end
                end)
            end
            return tbl97
        end
        local function fn304()
            local var1128, var1129 = pcall(function()
                if gethui then
                    return gethui()
                end
                return nil
            end)
            if var1128 and var1129 then
                return var1129
            end
            local var1130, core = pcall(function()
                return game:GetService("CoreGui")
            end)
            if var1130 and core then
                return core
            end
            return playerGui
        end
        local function fn305()
            local screenGui10 = Instance.new("ScreenGui")
            screenGui10.Name = "BolongKillerPerksInfo"
            screenGui10.ResetOnSpawn = false
            screenGui10.IgnoreGuiInset = true
            screenGui10.DisplayOrder = 48
            screenGui10.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            screenGui10.Parent = fn304()
            local panel = Instance.new("Frame")
            panel.Name = "Panel"
            panel.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
            panel.BackgroundTransparency = 0.06
            panel.BorderSizePixel = 0
            panel.Size = UDim2.fromOffset(220, 0)
            panel.AutomaticSize = Enum.AutomaticSize.Y
            panel.Position = tbl2.kpiPos or UDim2.new(1, -12, 0, 12)
            panel.AnchorPoint = Vector2.new(1, 0)
            panel.Active = true
            panel.Parent = screenGui10
            local uICorner13 = Instance.new("UICorner")
            uICorner13.CornerRadius = UDim.new(0, 8)
            uICorner13.Parent = panel
            local uIStroke10 = Instance.new("UIStroke")
            uIStroke10.Color = Color3.fromRGB(60, 60, 75)
            uIStroke10.Thickness = 1
            uIStroke10.Parent = panel
            local uIPadding = Instance.new("UIPadding")
            uIPadding.PaddingLeft = UDim.new(0, 8)
            uIPadding.PaddingRight = UDim.new(0, 8)
            uIPadding.PaddingTop = UDim.new(0, 6)
            uIPadding.PaddingBottom = UDim.new(0, 6)
            uIPadding.Parent = panel
            local uIListLayout = Instance.new("UIListLayout")
            uIListLayout.Padding = UDim.new(0, 3)
            uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            uIListLayout.Parent = panel
            local frame15 = Instance.new("Frame")
            frame15.Name = "Header"
            frame15.LayoutOrder = 1
            frame15.BackgroundTransparency = 1
            frame15.BorderSizePixel = 0
            frame15.Size = UDim2.new(1, 0, 0, 16)
            frame15.Parent = panel
            local textLabel9 = Instance.new("TextLabel")
            textLabel9.Name = "Title"
            textLabel9.BackgroundTransparency = 1
            textLabel9.BorderSizePixel = 0
            textLabel9.Size = UDim2.new(1, -20, 0, 16)
            textLabel9.Text = "KILLER"
            textLabel9.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel9.TextSize = 11
            textLabel9.Font = Enum.Font.GothamBold
            textLabel9.TextXAlignment = Enum.TextXAlignment.Left
            textLabel9.TextYAlignment = Enum.TextYAlignment.Center
            textLabel9.RichText = true
            textLabel9.Parent = frame15
            local textButton = Instance.new("TextButton")
            textButton.Name = "Minimize"
            textButton.BackgroundTransparency = 1
            textButton.BorderSizePixel = 0
            textButton.Size = UDim2.new(0, 16, 0, 16)
            textButton.Position = UDim2.new(1, -16, 0, 0)
            textButton.Text = "-"
            textButton.TextColor3 = Color3.fromRGB(160, 162, 170)
            textButton.TextSize = 13
            textButton.Font = Enum.Font.GothamBold
            textButton.Parent = frame15
            textButton.MouseButton1Click:Connect(function()
                tbl93.minimized = not tbl93.minimized
                if tbl93.rows then
                    tbl93.rows.Visible = not tbl93.minimized
                end
                local divider = panel:FindFirstChild("Divider")
                if divider then
                    divider.Visible = not tbl93.minimized
                end
            end)
            local frame16 = Instance.new("Frame")
            frame16.Name = "Divider"
            frame16.LayoutOrder = 1.5
            frame16.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
            frame16.BackgroundTransparency = 0.4
            frame16.BorderSizePixel = 0
            frame16.Size = UDim2.new(1, 0, 0, 1)
            frame16.Parent = panel
            local rows = Instance.new("Frame")
            rows.Name = "Rows"
            rows.LayoutOrder = 3
            rows.BackgroundTransparency = 1
            rows.BorderSizePixel = 0
            rows.Size = UDim2.new(1, 0, 0, 0)
            rows.AutomaticSize = Enum.AutomaticSize.Y
            rows.Parent = panel
            local uIListLayout2 = Instance.new("UIListLayout")
            uIListLayout2.Padding = UDim.new(0, 2)
            uIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
            uIListLayout2.Parent = rows
            local var1134, var1135, var1136
            frame15.Active = true
            frame15.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    var1134 = true
                    var1135 = input.Position
                    var1136 = panel.Position
                end
            end)
            frame15.InputChanged:Connect(function(input)
                if var1134 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local var1137 = input.Position - var1135
                    panel.Position = UDim2.new(1, var1136.X.Offset + var1137.X, 0, var1136.Y.Offset + var1137.Y)
                end
            end)
            frame15.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    var1134 = false
                    tbl2.kpiPos = panel.Position
                end
            end)
            tbl93.gui = screenGui10
            tbl93.panel = panel
            tbl93.rows = rows
        end
        local function fn306()
            if not tbl93.gui or not tbl93.gui.Parent then
                return
            end
            local killer = fn300()
            local var1138, var1139
            if not killer then
                var1138 = "none"
                var1139 = "<font color=\"rgb(160,162,170)\">Tidak ada Killer.</font>"
            else
                local var1140 = fn302(killer)
                local tbl98 = {}
                for name in pairs(var1140) do
                    table.insert(tbl98, name)
                end
                table.sort(tbl98)
                var1138 = killer.Name .. "|" .. table.concat(tbl98, ",")
                local tbl99 = {}
                for _, name in ipairs(tbl98) do
                    table.insert(tbl99, "<font color=\"rgb(200,200,210)\">- " .. name .. "</font>")
                end
                if #tbl99 == 0 then
                    var1139 = "<font color=\"rgb(160,162,170)\">Tidak ada perk terdeteksi.</font>"
                else
                    var1139 = table.concat(tbl99, "\n")
                end
                var1138 = var1138 .. "#" .. tostring(killer.Character and killer.Character.Name or "")
            end
            if var1138 == tbl93.field40 then
                return
            end
            tbl93.field40 = var1138
            local var1141 = tbl93.panel and tbl93.panel:FindFirstChild("Header") and tbl93.panel:FindFirstChild("Header"):FindFirstChild("Title")
            if var1141 then
                var1141.Text = killer and (function()
                    if var30 and buffer then
                        local _bf = buffer.create(78)
                        local _by = {
                            75,
                            73,
                            76,
                            76,
                            69,
                            82,
                            32,
                            60,
                            102,
                            111,
                            110,
                            116,
                            32,
                            99,
                            111,
                            108,
                            111,
                            114,
                            61,
                            34,
                            114,
                            103,
                            98,
                            40,
                            50,
                            53,
                            53,
                            44,
                            56,
                            48,
                            44,
                            56,
                            48,
                            41,
                            34,
                            62,
                            226,
                            128,
                            162,
                            60,
                            47,
                            102,
                            111,
                            110,
                            116,
                            62,
                            32,
                            60,
                            102,
                            111,
                            110,
                            116,
                            32,
                            99,
                            111,
                            108,
                            111,
                            114,
                            61,
                            34,
                            114,
                            103,
                            98,
                            40,
                            50,
                            53,
                            50,
                            44,
                            50,
                            51,
                            53,
                            44,
                            50,
                            50,
                            57,
                            41,
                            34,
                            62,
                        }
                        for _i = 1, #_by do
                            buffer.writeu8(_bf, _i - 1, _by[_i])
                        end
                        local _s = {}
                        for _i = 1, #_by do
                            _s[_i] = string.char(buffer.readu8(_bf, _i - 1))
                        end
                        return table.concat(_s)
                    else
                        local _by = {
                            75,
                            73,
                            76,
                            76,
                            69,
                            82,
                            32,
                            60,
                            102,
                            111,
                            110,
                            116,
                            32,
                            99,
                            111,
                            108,
                            111,
                            114,
                            61,
                            34,
                            114,
                            103,
                            98,
                            40,
                            50,
                            53,
                            53,
                            44,
                            56,
                            48,
                            44,
                            56,
                            48,
                            41,
                            34,
                            62,
                            226,
                            128,
                            162,
                            60,
                            47,
                            102,
                            111,
                            110,
                            116,
                            62,
                            32,
                            60,
                            102,
                            111,
                            110,
                            116,
                            32,
                            99,
                            111,
                            108,
                            111,
                            114,
                            61,
                            34,
                            114,
                            103,
                            98,
                            40,
                            50,
                            53,
                            50,
                            44,
                            50,
                            51,
                            53,
                            44,
                            50,
                            50,
                            57,
                            41,
                            34,
                            62,
                        }
                        local _s = {}
                        for _i = 1, #_by do
                            _s[_i] = string.char(_by[_i])
                        end
                        return table.concat(_s)
                    end
                end)() .. killer.Name .. "</font>" or "KILLER"
            end
            if tbl93.rows then
                tbl93.rows.Visible = not tbl93.minimized
                for _, v147 in ipairs(tbl93.rows:GetChildren()) do
                    if v147:IsA("TextLabel") then
                        v147:Destroy()
                    end
                end
                local num105 = 1
                for key4 in string.gmatch(var1139, "[^\n]+") do
                    local label = Instance.new("TextLabel")
                    label.BackgroundTransparency = 1
                    label.BorderSizePixel = 0
                    label.AutomaticSize = Enum.AutomaticSize.XY
                    label.LayoutOrder = num105
                    num105 = num105 + 1
                    label.Text = key4
                    label.TextColor3 = Color3.fromRGB(200, 200, 210)
                    label.TextSize = 12
                    label.Font = Enum.Font.Gotham
                    label.RichText = true
                    label.TextXAlignment = Enum.TextXAlignment.Left
                    label.Parent = tbl93.rows
                end
            end
        end
        function StartKillerPerksInfo()
            if not tbl.flag104 then
                return
            end
            fn299()
            if tbl93.gui and tbl93.gui.Parent then
                tbl93.gui.Enabled = true
            else
                fn305()
            end
            fn306()
            if not tbl93.flag175 then
                fn5(tbl93.taskName, 2, function()
                    if not tbl.flag104 then
                        return
                    end
                    fn306()
                end)
                tbl93.flag175 = true
            end
        end
        function StopKillerPerksInfo()
            if tbl93.gui then
                pcall(function()
                    tbl93.gui:Destroy()
                end)
                tbl93.gui = nil
                tbl93.panel = nil
                tbl93.rows = nil
            end
            tbl93.field40 = nil
        end
        function SetKPI_ToggleRef(toggle)
            tbl93.field41 = toggle
        end
    end
    fn296()
    fn5("Flowstate", 0.1, function()
        if not tbl.flag102 then
            return
        end
        if fn9(localPlayer) == "killer" then
            return
        end
        local char = localPlayer.Character
        local now17 = tick()
        local active = not (now17 < tbl2.num153) or now17 < tbl2.num154
        local tbl100 = {localPlayer, char}
        local tbl101 = {"climb_obsessing", "climb_collisoning", "climb_collisioning", "climb_colliding"}
        local flag49 = false
        for _, name in ipairs(tbl101) do
            local var1142 = Workspace:FindFirstChild(name)
            if var1142 then
                local var1143 = var1142:FindFirstChild(localPlayer.Name)
                if var1143 and var1143:IsA("Model") then
                    flag49 = true
                    table.insert(tbl100, var1143)
                end
            end
        end
        if flag49 then
            fn292()
        end
        for _, target in ipairs(tbl100) do
            if target then
                local cur = target:GetAttribute("Flowstate")
                if cur ~= active then
                    pcall(function()
                        target:SetAttribute("Flowstate", active)
                    end)
                end
            end
        end
    end)
    fn5("FlowstateUI", 0.2, function()
        local playerGui10 = localPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui10 then
            return
        end
        local gui = playerGui10:FindFirstChild("FlowstateUIGui")
        local var1144 = tbl.flag102 and not tbl.flag103
        if not var1144 then
            if gui then
                pcall(function()
                    gui:Destroy()
                end)
            end
            return
        end
        if not gui then
            gui = Instance.new("ScreenGui")
            gui.Name = "FlowstateUIGui"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.Parent = playerGui10
            local label = Instance.new("TextLabel")
            label.Name = "FlowstateCooldownLabel"
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Center
            label.TextYAlignment = Enum.TextYAlignment.Center
            label.TextScaled = false
            label.TextSize = 16
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            label.Size = UDim2.new(0, 220, 0, 22)
            label.Position = UDim2.new(0.5, 0, 0, 55)
            label.AnchorPoint = Vector2.new(0.5, 0)
            label.Font = Enum.Font.GothamBold
            label.Parent = gui
        end
        local label = gui:FindFirstChild("FlowstateCooldownLabel")
        if label then
            local now18 = tick()
            if now18 < tbl2.num153 then
                label.Text = "FLOWSTATE: " .. tostring(math.ceil(tbl2.num153 - now18)) .. "s"
                label.TextColor3 = Color3.fromRGB(255, 60, 60)
            else
                label.Text = "FLOWSTATE: READY"
                label.TextColor3 = Color3.fromRGB(0, 255, 120)
            end
        end
    end)
end
do
    tbl2.fpBuffs = tbl2.fpBuffs or {}
    tbl2.fpConns = tbl2.fpConns or {}
    tbl2.fpOn = tbl2.fpOn or {}
    if tbl2.fpCooldown == nil then
        tbl2.fpCooldown = 10
    end
    if tbl2.fpLastEnd == nil then
        tbl2.fpLastEnd = 0
    end
    if tbl2.fpMinFallTime == nil then
        tbl2.fpMinFallTime = 0.25
    end
    if tbl2.fpMinFallDrop == nil then
        tbl2.fpMinFallDrop = 3
    end
    if tbl2.fpVaultWindow == nil then
        tbl2.fpVaultWindow = 1
    end
    local function fn307()
        return localPlayer.Character
    end
    local function fn308()
        local num106 = 0
        local now19 = tick()
        for _, v148 in pairs(tbl2.fpBuffs or {}) do
            if now19 < v148.endTime then
                num106 = num106 + v148.amt
            end
        end
        return num106
    end
    local function fn309()
        if fn9(localPlayer) == "killer" then
            return
        end
        local char = fn307()
        local var1145 = fn308()
        if char then
            pcall(function()
                char:SetAttribute("speedboost", var1145 > 0 and 1 + var1145 / 14 or 1)
            end)
        end
    end
    function FP_TryBuff(name, amt, dur)
        if fn9(localPlayer) == "killer" then
            return
        end
        if tbl2.fpBuffs[name] then
            return
        end
        if tick() - tbl2.fpLastEnd < (tbl2.fpCooldown or 10) and next(tbl2.fpBuffs) == nil then
            return
        end
        tbl2.fpBuffs[name] = {amt = amt, endTime = tick() + dur}
        if name == "PerfectLanding" then
            tbl2.fpPLAnnounced = false
        end
        fn309()
        fn2("Fake Perks", "[" .. name .. "] Aktif! +" .. math.floor(amt / 14 * 100) .. "% Speed (" .. dur .. "s)", 3)
    end
    local function fn310(name)
        local var1148 = tbl2.fpConns[name]
        if var1148 then
            for _, v149 in ipairs(var1148) do
                pcall(function()
                    v149:Disconnect()
                end)
            end
            tbl2.fpConns[name] = nil
        end
    end
    local function fn311(name, arg210)
        if arg210 == nil then
            return
        end
        if not tbl2.fpConns[name] then
            tbl2.fpConns[name] = {}
        end
        table.insert(tbl2.fpConns[name], arg210)
    end
    local function fn312(name, fn)
        fn311(name, localPlayer.CharacterAdded:Connect(fn))
        local cur = fn307()
        if cur then
            pcall(fn, cur)
        end
    end
    function FP_MarkVault()
        tbl2.fpVaultUntil = tick() + (tbl2.fpVaultWindow or 1)
    end
    function FP_IsVaultNow()
        if (tbl2.fpVaultUntil or 0) > tick() then
            return true
        end
        local char = localPlayer.Character
        if not char then
            return true
        end
        local checkInterrable = char:FindFirstChild("CheckInterrable")
        if checkInterrable and checkInterrable:GetAttribute("isVaulting") then
            return true
        end
        if IsPlayerDoingAction() then
            return true
        end
        if char:GetAttribute("IsHooked") or char:GetAttribute("IsCarried") then
            return true
        end
        return false
    end
    if not tbl2.fpVaultHooked then
        tbl2.fpVaultHooked = true
        pcall(function()
            local remotes13 = ReplicatedStorage:FindFirstChild("Remotes")
            local var1151 = remotes13 and remotes13:FindFirstChild("Window")
            local var1152 = var1151 and var1151:FindFirstChild("VaultEvent")
            if var1152 and var1152.OnClientEvent then
                tbl2.fpVaultConn = var1152.OnClientEvent:Connect(function()
                    tbl2.fpVaultUntil = tick() + (tbl2.fpVaultWindow or 1)
                end)
            end
        end)
    end
    function FP_SetPerk(name, arg211)
        if name == "Flowstate" then
            tbl2.fpOn.Flowstate = nil
            return
        end
        tbl2.fpOn[name] = arg211 and true or false
        if not arg211 then
            fn310(name)
            tbl2.fpBuffs[name] = nil
            if name == "PerfectLanding" then
                tbl2.fpPLAnnounced = false
            end
            fn309()
            return
        end
        if name == "QuickRecovery" then
            local function onEvent2(_, sprintFlag)
                if not tbl2.fpOn.QuickRecovery then
                    return
                end
                if sprintFlag ~= true then
                    return
                end
                FP_TryBuff("QuickRecovery", 5.6, 3)
            end
            pcall(function()
                local remotes14 = ReplicatedStorage:FindFirstChild("Remotes")
                local var1153 = remotes14 and remotes14:FindFirstChild("Window")
                local var1154 = var1153 and var1153:FindFirstChild("Vaultbindable")
                if var1154 and var1154:IsA("BindableEvent") then
                    fn311(name, var1154.Event:Connect(onEvent2))
                end
            end)
        elseif name == "PerfectLanding" then
            fn312(name, function(ch)
                local humanoid27 = ch:FindFirstChildOfClass("Humanoid")
                if not humanoid27 then
                    return
                end
                local humanoidRootPart34 = ch:FindFirstChild("HumanoidRootPart")
                tbl2.fpWasFalling = false
                tbl2.fpFallStart = 0
                tbl2.fpFallY = 0
                fn311(name, humanoid27.StateChanged:Connect(function(_, new)
                    if not tbl2.fpOn.PerfectLanding then
                        return
                    end
                    if new == Enum.HumanoidStateType.Freefall then
                        tbl2.fpWasFalling = true
                        tbl2.fpFallStart = tick()
                        tbl2.fpFallY = humanoidRootPart34 and humanoidRootPart34.Position.Y or 0
                    elseif tbl2.fpWasFalling and (new == Enum.HumanoidStateType.Landed or new == Enum.HumanoidStateType.Running) then
                        tbl2.fpWasFalling = false
                        if FP_IsVaultNow() then
                            return
                        end
                        if tick() - (tbl2.fpFallStart or 0) < (tbl2.fpMinFallTime or 0.25) then
                            return
                        end
                        if humanoidRootPart34 then
                            local var1155 = (tbl2.fpFallY or humanoidRootPart34.Position.Y) - humanoidRootPart34.Position.Y
                            if var1155 < (tbl2.fpMinFallDrop or 3) then
                                return
                            end
                        end
                        FP_TryBuff("PerfectLanding", 5.6, 3)
                    elseif tbl2.fpWasFalling and (new == Enum.HumanoidStateType.Swimming or new == Enum.HumanoidStateType.Climbing or new == Enum.HumanoidStateType.Physics or new == Enum.HumanoidStateType.Seated) then
                        tbl2.fpWasFalling = false
                    end
                end))
            end)
        elseif name == "AdrenalineRush" then
            fn312(name, function(ch)
                local humanoid28 = ch:FindFirstChildOfClass("Humanoid")
                if not humanoid28 then
                    return
                end
                local health2 = humanoid28.Health
                fn311(name, humanoid28.HealthChanged:Connect(function(newHP)
                    if tbl2.fpOn.AdrenalineRush and newHP < health2 and newHP <= 50 and newHP > 0 then
                        FP_TryBuff("AdrenalineRush", 4, 5)
                    end
                    health2 = newHP
                end))
            end)
        end
    end
    function FP_ReArm()
        for name, v150 in pairs(tbl2.fpOn or {}) do
            if v150 then
                pcall(FP_SetPerk, name, false)
                pcall(FP_SetPerk, name, true)
            end
        end
    end
    fn5("FakePerks", 0.1, function()
        if next(tbl2.fpBuffs) == nil then
            return
        end
        local now20 = tick()
        local flag50 = false
        for k20, v151 in pairs(tbl2.fpBuffs) do
            if now20 >= v151.endTime then
                tbl2.fpBuffs[k20] = nil
                flag50 = true
            end
        end
        if flag50 and next(tbl2.fpBuffs) == nil then
            tbl2.fpLastEnd = now20
        end
        local perfectLanding = tbl2.fpBuffs.PerfectLanding
        if perfectLanding and now20 < perfectLanding.endTime then
            local char = localPlayer.Character
            if char then
                pcall(function()
                    if char:GetAttribute("MovementLocked") then
                        char:SetAttribute("MovementLocked", false)
                        if not tbl2.fpPLAnnounced then
                            tbl2.fpPLAnnounced = true
                            print("[FP] MovementLocked ditahan OFF (PerfectLanding)")
                        end
                    end
                end)
            end
        end
        fn309()
    end)
end
local var1156, HEAL_BoostBandage, HEAL_SetNoAnim, HEAL_Abort, HEAL_SetSessionEndHook
do
    local num107 = 95
    local num108 = 100
    local num109 = 8
    local str9, PHASE_HEAL, PHASE_BANDAGE = "idle", "heal", "bandage"
    local var1157 = str9
    local var1158 = nil
    local flag51 = false
    local flag52 = false
    local var1159 = nil
    local num110 = 0
    local tbl102 = {}
    local var1160 = nil
    local flag53 = false
    local flag54 = false
    local var1161
    local flag55 = false
    local flag56 = false
    local tbl103 = {}
    local function fn313()
        if var1160 then
            pcall(function()
                var1160:Disconnect()
            end)
            var1160 = nil
        end
        for i40 = 1, #tbl102 do
            pcall(function()
                tbl102[i40].Disconnect(tbl102[i40])
            end)
        end
        table.remove(tbl102, 1, #tbl102)
    end
    local function fn314(arg212)
        local char = var1158 or localPlayer.Character
        local var1162 = char and char:FindFirstChild("HumanoidRootPart")
        if not var1162 then
            return false
        end
        local remotes15 = ReplicatedStorage:FindFirstChild("Remotes")
        local var1163 = remotes15 and remotes15:FindFirstChild("Healing")
        local var1164 = var1163 and var1163:FindFirstChild("HealEvent")
        if not var1164 then
            return false
        end
        return (pcall(function()
            var1164:FireServer(var1162, arg212)
        end))
    end
    local function fn315()
        var1157 = str9
        var1158 = nil
        flag51 = false
        flag52 = false
        var1159 = nil
        num110 = 0
        flag54 = false
    end
    local var1165 = nil
    local function fn316()
        fn313()
        flag53 = false
        fn315()
        flag56 = false
        if var1165 then
            pcall(var1165)
        end
    end
    local function fn317()
        pcall(function()
            local remotes16 = ReplicatedStorage:FindFirstChild("Remotes")
            local var1166 = remotes16 and remotes16:FindFirstChild("Healing")
            if not var1166 then
                return
            end
            for _, name in ipairs({"HealAnim", "HealAnimRec"}) do
                local var1167 = var1166:FindFirstChild(name)
                if var1167 then
                    for _, v152 in ipairs(getconnections(var1167.OnClientEvent)) do
                        local fn = v152.Function
                        if fn and not tbl103[fn] and hookfunction then
                            tbl103[fn] = true
                            local var1168
                            var1168 = hookfunction(fn, function(arg213)
                                if flag56 and arg213 then
                                    return
                                end
                                return var1168(arg213)
                            end)
                        end
                    end
                end
            end
        end)
    end
    function HEAL_SetNoAnim(arg214)
        flag55 = arg214 and true or false
        if flag55 then
            if not hookfunction then
                fn2("No-Anim Heal", "Executor tidak support hookfunction.", 3)
                flag55 = false
                return
            end
            fn317()
        else
            flag56 = false
        end
    end
    local function fn318()
        local char = var1158 or localPlayer.Character
        local var1169 = nil
        if char then
            var1169 = char:GetAttribute("HealProgress")
        end
        if type(var1169) ~= "number" then
            var1169 = localPlayer:GetAttribute("HealProgress")
        end
        if type(var1169) ~= "number" then
            return nil
        end
        return var1169
    end
    local function fn319()
        local char = var1158 or localPlayer.Character
        if not char then
            return nil
        end
        local var1170 = char:GetAttribute("EquippedItem") or char:GetAttribute("Equippedltem")
        if var1170 == nil then
            var1170 = localPlayer:GetAttribute("EquippedItem") or localPlayer:GetAttribute("Equippedltem")
        end
        if type(var1170) == "string" then
            return var1170
        end
        if typeof(var1170) == "Instance" then
            return var1170.Name
        end
        return nil
    end
    local function fn320()
        local name = fn319()
        if type(name) ~= "string" then
            return false
        end
        return name:lower() == "bandage"
    end
    local function fn321()
        local char = var1158 or localPlayer.Character
        if not char then
            return "Character not found"
        end
        if char:GetAttribute("IsDead") then
            return "Kamu sudah mati"
        end
        if char:GetAttribute("IsHooked") then
            return "Kamu sedang hooked"
        end
        if char:GetAttribute("IsCarried") then
            return "Kamu sedang di-carry"
        end
        if CollectionService:HasTag(char, "Silenced") then
            return "Kamu sedang Silenced"
        end
        if CollectionService:HasTag(char, "Antiheal") then
            return "Kamu sedang Antiheal"
        end
        local checkInterractable2 = char:FindFirstChild("CheckInterractable")
        if checkInterractable2 then
            for _, v153 in ipairs({
                "isVaulting",
                "isSliding",
                "isDroppingPallet",
                "isRepairing",
                "isHealing",
                "isUnhooking",
                "isExiting",
            }) do
                if checkInterractable2:GetAttribute(v153) then
                    return "SedangBusy: " .. v153
                end
            end
        end
        return nil
    end
    local function fn322()
        local char = var1158 or localPlayer.Character
        if not char then
            return nil, nil
        end
        local tool = char:FindFirstChild("Bandage")
        if tool and tool:IsA("Tool") then
            local var1171 = tool:GetAttribute("charge")
            if type(var1171) == "number" and var1171 <= 0 then
                return nil, "Bandage kehabisan charge"
            end
            return tool, nil
        end
        local var1172 = tool and tool:FindFirstChild("Right Arm")
        local var1173 = var1172 and var1172:FindFirstChild("Bandage")
        if var1173 then
            return var1173, nil
        end
        return nil, "Bandage tidak ter-equip"
    end
    local function fn323(arg215, arg216)
        local remotes17 = ReplicatedStorage:FindFirstChild("Remotes")
        local items = remotes17 and remotes17:FindFirstChild("Items")
        local var1174 = items and items:FindFirstChild("Bandage")
        local var1175 = var1174 and var1174:FindFirstChild("Fire")
        if not var1175 then
            return false
        end
        return (pcall(function()
            var1175:FireServer(arg215, arg216)
        end))
    end
    local function fn324(arg217)
        local char = localPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            return false
        end
        if fn9(localPlayer) == "killer" then
            fn2(arg217, "Fitur ini hanya untuk Survivor.", 2)
            return false
        end
        fn313()
        fn315()
        var1158 = char
        num110 = tick()
        var1157 = PHASE_HEAL
        var1160 = char:GetAttributeChangedSignal("HealProgress"):Connect(function()
            var1161()
        end)
        table.insert(tbl102, var1160)
        if not fn314(true) then
            fn316()
            return false
        end
        flag51 = true
        return true
    end
    local function fn325(arg218)
        local var1176 = fn321()
        if var1176 then
            fn2(arg218, "Boost bandage gagal: " .. var1176, 3)
            return false
        end
        if not fn320() then
            fn2(arg218, "Equip Item Bandage dulu sebelum pakai Boost Progress.", 3)
            return false
        end
        local var1177, err = fn322()
        if not var1177 then
            fn2(arg218, "Boost bandage gagal: " .. tostring(err), 3)
            return false
        end
        if not fn323(true, var1177) then
            return false
        end
        var1159 = var1177
        flag52 = true
        var1157 = PHASE_BANDAGE
        num110 = tick()
        return true
    end
    function var1161()
        if var1157 == str9 then
            return
        end
        local char = var1158
        if not char or char ~= localPlayer.Character or not char.Parent then
            if flag51 then
                fn314(false)
            end
            if flag52 then
                fn323(false, var1159)
            end
            fn316()
            return
        end
        local var1178 = fn318()
        local var1179 = tick() - num110
        if var1178 and var1178 > 0 then
            flag54 = true
        end
        if var1157 == PHASE_HEAL then
            if var1178 and var1178 >= num107 then
                if flag51 then
                    fn314(false)
                end
                flag51 = false
                var1157 = str9
                if flag53 then
                    fn325("Boost Bandage")
                else
                    fn316()
                end
            elseif var1179 > num109 and not flag54 then
                if flag51 then
                    fn314(false)
                end
                fn316()
            end
            return
        end
        if var1157 == PHASE_BANDAGE then
            if var1178 and var1178 >= num108 or var1179 > num109 then
                if flag52 then
                    fn323(false, var1159)
                end
                fn316()
            end
        end
    end
    function var1156()
        flag53 = false
        flag56 = flag55
        if flag56 then
            fn317()
        end
        if not fn324("Self Heal") then
            flag53 = false
            fn316()
        end
    end
    function HEAL_BoostBandage()
        flag53 = true
        flag56 = flag55
        if flag56 then
            fn317()
        end
        if not fn324("Boost Bandage") then
            flag53 = false
            fn316()
        end
    end
    function HEAL_Abort()
        if flag51 then
            fn314(false)
        end
        if flag52 then
            fn323(false, var1159)
        end
        fn316()
    end
    function HEAL_SetSessionEndHook(fn)
        var1165 = fn
    end
    fn5("SelfHealWatch", 0.1, function()
        if var1157 ~= str9 then
            var1161()
        end
    end)
    localPlayer.CharacterAdded:Connect(function()
        if var1157 ~= str9 then
            if flag51 then
                fn314(false)
            end
            if flag52 then
                fn323(false, var1159)
            end
            fn316()
        end
    end)
end
local var1180, StopPotato
do
    local num111 = 800
    local num112 = 0.008
    local tbl104 = {
        generator = true,
        generators = true,
        character = true,
        avatar = true,
        survivor = true,
        killer = true,
        window = true,
        vault = true,
        wood = true,
        wooden = true,
        plank = true,
        planks = true,
        log = true,
        logs = true,
        trunk = true,
        tree = true,
        equipment = true,
        item = true,
        items = true,
        tool = true,
        tools = true,
        hitbox = true,
        interaction = true,
        interact = true,
        prompt = true,
        attack = true,
        weapon = true,
        weapons = true,
        spear = true,
        spears = true,
    }
    local tbl105 = {
        Humanoid = true,
        Animator = true,
        Animation = true,
        AnimationController = true,
        Tool = true,
        ProximityPrompt = true,
        ClickDetector = true,
        Weld = true,
        WeldConstraint = true,
        Motor6D = true,
        ManualWeld = true,
    }
    local tbl106 = {ParticleEmitter = true, Smoke = true, Fire = true, Beam = true, Sparkles = true}
    local tbl107 = {
        leaf = true,
        leaves = true,
        leaflet = true,
        leaflets = true,
        leafmesh = true,
        leaf_mesh = true,
        leafpart = true,
        leaf_part = true,
        leaftexture = true,
        leaf_texture = true,
        leafcard = true,
        leaf_card = true,
        leafplane = true,
        leaf_plane = true,
        leafcluster = true,
        leaf_cluster = true,
        leafgroup = true,
        leaf_group = true,
        foliageleaf = true,
        foliage_leaf = true,
        treetop = true,
        tree_top = true,
        treeleaves = true,
        tree_leaves = true,
        leavesmesh = true,
        leaves_mesh = true,
    }
    local tbl108 = {grass = true, grassblade = true, grass_blade = true}
    local tbl109, LeafKeywords, GrassKeywords = {}, {}, {}
    for k21 in pairs(tbl104) do
        tbl109[#tbl109 + 1] = k21
    end
    for k22 in pairs(tbl107) do
        LeafKeywords[#LeafKeywords + 1] = k22
    end
    for k23 in pairs(tbl108) do
        GrassKeywords[#GrassKeywords + 1] = k23
    end
    local function fn326(arg219)
        return string.lower(tostring(arg219))
    end
    local function fn327(name, arg220)
        name = fn326(name)
        for i41 = 1, #arg220 do
            if string.find(name, arg220[i41], 1, true) then
                return true
            end
        end
        return false
    end
    local tbl110 = {
        "endscreen",
        "endscreencutscene",
        "cutsceneend",
        "cutsceneend2",
        "cutsceneendwithownchar",
        "endgame",
        "end_screen",
    }
    local function fn328(obj)
        if not obj then
            return false
        end
        local var1182 = obj
        for _ = 1, 4 do
            if not var1182 then
                break
            end
            if fn327(var1182.Name, tbl110) then
                return true
            end
            var1182 = var1182.Parent
        end
        return false
    end
    local tbl111 = {"fog", "mist", "haze", "smoke", "steam", "vapor"}
    local function fn329(obj)
        if not obj then
            return false
        end
        if not (obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Beam")) then
            return false
        end
        local var1183 = obj
        for _ = 1, 12 do
            if not var1183 then
                break
            end
            local name = fn326(var1183.Name)
            if string.find(name, "exit", 1, true) or string.find(name, "escape", 1, true) or string.find(name, "door", 1, true) then
                if fn327(name, tbl111) then
                    return true
                end
            end
            if fn327(name, tbl111) then
                local parent7 = var1183.Parent
                for _ = 1, 8 do
                    if not parent7 then
                        break
                    end
                    local var1184 = fn326(parent7.Name)
                    if string.find(var1184, "exit", 1, true) or string.find(var1184, "escape", 1, true) or string.find(var1184, "door", 1, true) then
                        return true
                    end
                    parent7 = parent7.Parent
                end
            end
            var1183 = var1183.Parent
        end
        return false
    end
    local function fn330(arg221)
        if arg221 then
            tbl2.list25[arg221] = true
        end
    end
    local function fn331(arg222)
        if arg222 then
            tbl2.list25[arg222] = nil
            tbl2.list26[arg222] = nil
        end
    end
    local function fn332(player2)
        return player2 and player2.Team and player2.Team.Name == "killer"
    end
    local function fn333(player3)
        if not player3 then
            return
        end
        local character52 = player3.Character
        if character52 then
            if fn332(player3) then
                tbl2.list26[character52] = true
            else
                tbl2.list26[character52] = nil
            end
        end
    end
    local function onPlayerAdded3(player4)
        if not player4 then
            return
        end
        if player4.Character then
            fn330(player4.Character)
            fn333(player4)
        end
        table.insert(tbl2.list24, player4.CharacterAdded:Connect(function(arg223)
            fn330(arg223)
            task.defer(function()
                fn333(player4)
            end)
        end))
        table.insert(tbl2.list24, player4.CharacterRemoving:Connect(function(arg224)
            fn331(arg224)
        end))
        table.insert(tbl2.list24, player4:GetPropertyChangedSignal("Team"):Connect(function()
            fn333(player4)
        end))
    end
    local function fn334(obj)
        local var1185 = obj
        for _ = 1, 20 do
            if not var1185 then
                return false
            end
            if tbl2.list25[var1185] then
                return true
            end
            var1185 = var1185.Parent
        end
        return false
    end
    local function fn335(obj)
        if not obj or not tbl106[obj.ClassName] then
            return false
        end
        local var1186 = obj
        for _ = 1, 20 do
            if not var1186 then
                return false
            end
            if tbl2.list26[var1186] then
                return true
            end
            var1186 = var1186.Parent
        end
        return false
    end
    local function fn336(obj)
        local var1187 = obj
        for _ = 1, 20 do
            if not var1187 then
                return false
            end
            if string.find(fn326(var1187.Name), "pallet", 1, true) then
                return true
            end
            var1187 = var1187.Parent
        end
        return false
    end
    local function fn337(obj)
        if not obj then
            return nil
        end
        local var1188 = obj
        for _ = 1, 20 do
            if not var1188 then
                return nil
            end
            if string.find(fn326(var1188.Name), "pallet", 1, true) then
                return var1188
            end
            var1188 = var1188.Parent
        end
        return nil
    end
    local function fn338(obj)
        if not obj then
            return false
        end
        if fn327(obj.Name, LeafKeywords) then
            return true
        end
        local parent8 = obj.Parent
        for _ = 1, 4 do
            if not parent8 then
                break
            end
            if fn327(parent8.Name, LeafKeywords) then
                return true
            end
            parent8 = parent8.Parent
        end
        return false
    end
    local function fn339(obj)
        if not obj then
            return true
        end
        if tbl105[obj.ClassName] then
            return true
        end
        if fn334(obj) then
            return true
        end
        if fn336(obj) then
            return false
        end
        local var1189 = obj
        for _ = 1, 7 do
            if not var1189 then
                break
            end
            if fn327(var1189.Name, tbl109) then
                return true
            end
            var1189 = var1189.Parent
        end
        return false
    end
    local function fn340()
        local currentCamera23 = workspace.CurrentCamera
        return currentCamera23 and currentCamera23.CameraType == Enum.CameraType.Scriptable
    end
    local function fn341(obj)
        if not obj or not obj.Parent then
            return
        end
        if obj:IsA("MeshPart") then
            pcall(function()
                obj.Material = Enum.Material.SmoothPlastic
                obj.CastShadow = false
                obj.TextureID = ""
            end)
        elseif obj:IsA("BasePart") then
            pcall(function()
                obj.Material = Enum.Material.SmoothPlastic
                obj.CastShadow = false
            end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function()
                obj.Transparency = 1
            end)
        elseif obj:IsA("SurfaceAppearance") then
            pcall(function()
                obj:Destroy()
            end)
        elseif obj:IsA("SpecialMesh") then
            pcall(function()
                obj.TextureId = ""
            end)
        end
    end
    local function fn342(obj)
        if not obj or not obj.Parent then
            return
        end
        if tbl105[obj.ClassName] then
            return
        end
        if obj:IsA("BasePart") then
            pcall(function()
                obj.Transparency = 1
                obj.CanCollide = false
                obj.CanTouch = false
                obj.CanQuery = false
            end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function()
                obj.Transparency = 1
            end)
        elseif obj:IsA("SpecialMesh") then
            pcall(function()
                obj.TextureId = ""
            end)
        elseif obj:IsA("SurfaceAppearance") then
            pcall(function()
                obj:Destroy()
            end)
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            pcall(function()
                obj.Enabled = false
            end)
        end
    end
    local flag57 = false
    local function fn343(obj)
        if not obj or not obj.Parent then
            return
        end
        if tbl2.potatoProcessed[obj] then
            return
        end
        if fn328(obj) then
            tbl2.potatoProcessed[obj] = true
            return
        end
        if fn329(obj) then
            pcall(function()
                obj.Enabled = false
            end)
            tbl2.potatoProcessed[obj] = true
            return
        end
        if fn340() then
            return
        end
        if fn336(obj) then
            local var1190 = fn337(obj)
            if var1190 then
                tbl2.potatoPallets[var1190] = true
                fn341(obj)
                tbl2.potatoProcessed[obj] = true
                return
            end
        end
        if fn335(obj) then
            pcall(function()
                obj.Enabled = false
            end)
            tbl2.potatoProcessed[obj] = true
            return
        end
        if fn334(obj) then
            tbl2.potatoProcessed[obj] = true
            return
        end
        if tbl105[obj.ClassName] then
            tbl2.potatoProcessed[obj] = true
            return
        end
        if fn338(obj) then
            fn342(obj)
            tbl2.potatoProcessed[obj] = true
            return
        end
        if fn339(obj) then
            tbl2.potatoProcessed[obj] = true
            return
        end
        if fn327(obj.Name, GrassKeywords) then
            tbl2.potatoProcessed[obj] = true
            return
        end
        if obj:IsA("BasePart") then
            pcall(function()
                obj.Material = Enum.Material.SmoothPlastic
                obj.CastShadow = false
            end)
            tbl2.potatoProcessed[obj] = true
            return
        end
        if obj:IsA("Decal") or obj:IsA("Texture") then
            local parent9 = obj.Parent
            if not parent9 or not fn327(parent9.Name, tbl109) then
                pcall(function()
                    obj.Transparency = 1
                end)
            end
            tbl2.potatoProcessed[obj] = true
            return
        end
        if obj:IsA("SurfaceAppearance") then
            local parent10 = obj.Parent
            if parent10 and fn338(parent10) then
                pcall(function()
                    obj:Destroy()
                end)
            end
            tbl2.potatoProcessed[obj] = true
            return
        end
        if obj:IsA("SpecialMesh") then
            local parent11 = obj.Parent
            if parent11 and fn338(parent11) then
                pcall(function()
                    obj.TextureId = ""
                end)
            end
            tbl2.potatoProcessed[obj] = true
            return
        end
        tbl2.potatoProcessed[obj] = true
    end
    local function fn344(arg225)
        if not arg225 then
            return false
        end
        if arg225 == localPlayer.Character then
            return false
        end
        if tbl2.list25[arg225] then
            return false
        end
        if arg225:IsA("Camera") or arg225:IsA("Terrain") then
            return false
        end
        return arg225:IsA("Model") or arg225:IsA("Folder") or arg225:IsA("BasePart") and arg225.Parent == workspace
    end
    local function fn345(obj)
        if not tbl2.flag165 or not obj or not obj.Parent then
            return
        end
        if flag57 then
            tbl2.potatoProcessed[obj] = true
            return
        end
        if tbl2.potatoProcessed[obj] or tbl2.list23[obj] then
            return
        end
        if fn328(obj) then
            tbl2.potatoProcessed[obj] = true
            return
        end
        if fn329(obj) then
            pcall(function()
                obj.Enabled = false
            end)
            tbl2.potatoProcessed[obj] = true
            return
        end
        if tbl105[obj.ClassName] then
            return
        end
        if fn334(obj) and not fn335(obj) then
            return
        end
        tbl2.num164 = tbl2.num164 + 1
        tbl2.list22[tbl2.num164] = obj
        tbl2.list23[obj] = true
    end
    local function fn346()
        if tbl2.num163 > tbl2.num164 then
            tbl2.list22 = {}
            tbl2.num163 = 1
            tbl2.num164 = 0
            tbl2.list23 = {}
        end
    end
    local function fn347()
        tbl2.list22 = {}
        tbl2.num163, tbl2.num164, tbl2.list23 = 1, 0, {}
        tbl2.list21 = {}
        tbl2.field35 = nil
        tbl2.num162 = 1
    end
    local function fn348()
        if flag57 then
            return
        end
        flag57 = true
        fn347()
    end
    local function fn349(obj)
        return obj ~= nil and obj.Name == "endscreen" and obj.Parent ~= nil and obj.Parent.Name == "Map"
    end
    local function fn350(arg226, count)
        if count >= num111 then
            return false
        end
        if os.clock() - arg226 >= num112 then
            return false
        end
        if fn340() then
            return false
        end
        return true
    end
    function var1180()
        if tbl2.flag165 then
            return
        end
        tbl2.flag165 = true
        flag57 = false
        pcall(function()
            local map5 = workspace:FindFirstChild("Map")
            if map5 and map5:FindFirstChild("endscreen") then
                fn348()
            end
        end)
        pcall(function()
            tbl2.qualityLevel1 = settings().Rendering.QualityLevel
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        pcall(function()
            local Lighting2 = game:GetService("Lighting")
            tbl2.globalShadows1 = Lighting2.GlobalShadows
            tbl2.fogEnd1 = Lighting2.FogEnd
            Lighting2.GlobalShadows = false
            Lighting2.FogEnd = 1000000
        end)
        tbl2.list27 = {}
        pcall(function()
            for _, obj in ipairs(game:GetService("Lighting"):GetChildren()) do
                if obj:IsA("PostEffect") and obj.Enabled then
                    obj.Enabled = false
                    tbl2.list27[#tbl2.list27 + 1] = obj
                end
            end
        end)
        for _, v154 in ipairs(Players:GetPlayers()) do
            onPlayerAdded3(v154)
        end
        table.insert(tbl2.list24, Players.PlayerAdded:Connect(onPlayerAdded3))
        table.insert(tbl2.list24, Players.PlayerRemoving:Connect(function(player5)
            if player5.Character then
                fn331(player5.Character)
            end
        end))
        table.insert(tbl2.list24, workspace.ChildAdded:Connect(function(arg227)
            if not tbl2.flag165 then
                return
            end
            if flag57 then
                return
            end
            if fn328(arg227) then
                return
            end
            if fn344(arg227) then
                tbl2.list21[#tbl2.list21 + 1] = arg227
            end
        end))
        table.insert(tbl2.list24, workspace.DescendantAdded:Connect(function(obj)
            if not tbl2.flag165 or not obj or not obj.Parent then
                return
            end
            if fn349(obj) then
                fn348()
                return
            end
            if flag57 then
                tbl2.potatoProcessed[obj] = true
                return
            end
            if tbl2.potatoProcessed[obj] or tbl2.list23[obj] then
                return
            end
            if fn328(obj) then
                tbl2.potatoProcessed[obj] = true
                return
            end
            if fn329(obj) then
                pcall(function()
                    obj.Enabled = false
                end)
                tbl2.potatoProcessed[obj] = true
                return
            end
            if fn334(obj) and not fn335(obj) then
                return
            end
            if tbl105[obj.ClassName] then
                return
            end
            fn345(obj)
        end))
        pcall(function()
            for _, v155 in ipairs(workspace:GetChildren()) do
                if fn344(v155) then
                    tbl2.list21[#tbl2.list21 + 1] = v155
                end
            end
        end)
    end
    function StopPotato()
        tbl2.flag165 = false
        flag57 = false
        for _, v156 in ipairs(tbl2.list24) do
            pcall(function()
                v156:Disconnect()
            end)
        end
        tbl2.list24 = {}
        tbl2.list21 = {}
        tbl2.field35 = nil
        tbl2.num162 = 1
        tbl2.list22 = {}
        tbl2.num163, tbl2.num164, tbl2.list23 = 1, 0, {}
        tbl2.list25 = {}
        tbl2.list26 = {}
        pcall(function()
            if tbl2.qualityLevel1 then
                settings().Rendering.QualityLevel = tbl2.qualityLevel1
            end
        end)
        pcall(function()
            local Lighting3 = game:GetService("Lighting")
            if tbl2.globalShadows1 ~= nil then
                Lighting3.GlobalShadows = tbl2.globalShadows1
            end
            if tbl2.fogEnd1 ~= nil then
                Lighting3.FogEnd = tbl2.fogEnd1
            end
            for _, obj in ipairs(tbl2.list27) do
                if obj and obj.Parent then
                    obj.Enabled = true
                end
            end
        end)
        tbl2.list27 = {}
    end
    fn5("PotatoStream", 0, function()
        if not tbl2.flag165 then
            return
        end
        if flag57 then
            return
        end
        if fn340() then
            return
        end
        local var1191 = os.clock()
        local count = 0
        while tbl2.num163 <= tbl2.num164 and fn350(var1191, count) do
            local obj = tbl2.list22[tbl2.num163]
            tbl2.list22[tbl2.num163] = nil
            tbl2.num163 = tbl2.num163 + 1
            if obj then
                tbl2.list23[obj] = nil
            end
            if obj and obj.Parent then
                fn343(obj)
            end
            count = count + 1
        end
        fn346()
        if tbl2.field35 == nil and #tbl2.list21 > 0 and fn350(var1191, count) then
            local var1192 = table.remove(tbl2.list21, 1)
            if var1192 and var1192.Parent and fn344(var1192) then
                local var1193, objs = pcall(function()
                    return var1192:GetDescendants()
                end)
                if var1193 and objs then
                    tbl2.field35 = objs
                    tbl2.num162 = 1
                end
            end
        end
        while tbl2.field35 ~= nil and fn350(var1191, count) do
            local var1194 = tbl2.field35
            local var1195 = tbl2.num162
            local obj = var1194[var1195]
            tbl2.num162 = var1195 + 1
            if var1195 > #var1194 then
                tbl2.field35 = nil
                tbl2.num162 = 1
            elseif obj and obj.Parent then
                fn343(obj)
            end
            count = count + 1
        end
    end)
end
RunService.Heartbeat:Connect(function(arg228)
    for i42 = 1, #tbl5 do
        local t = tbl5[i42]
        t.timer = t.timer + arg228
        if t.timer >= t.interval then
            t.timer = 0
            t.fn(arg228)
        end
    end
end)
local var1196
local var1197
do
    local flag58 = false
    local flag59 = false
    local var1198
    local var1199
    local selfUnHookEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("SelfUnHookEvent")
    local repairEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("RepairEvent")
    local function fn351(pos)
        local var1200 = nil
        local huge12 = math.huge
        for _, item in ipairs(Workspace:GetDescendants()) do
            if item.Name == "Hook" and (item:IsA("Model") or item:IsA("BasePart")) and item.Parent then
                local var1201, var1202 = pcall(function()
                    if item:IsA("Model") then
                        return item:GetPivot()
                    end
                    return item.CFrame
                end)
                if var1201 and var1202 then
                    local dist = (var1202.Position - pos).Magnitude
                    if dist < huge12 then
                        huge12 = dist
                        var1200 = var1202
                    end
                end
            end
        end
        return var1200
    end
    local function fn352(arg229, char)
        if var1198 then
            var1198:Disconnect()
            var1198 = nil
        end
        flag59 = false
        arg229.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        arg229.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        if not var1199 then
            char:PivotTo(arg229.CFrame * CFrame.new(0, 15, 0))
        else
            char:PivotTo(var1199 * CFrame.new(0, 3, 0))
        end
        task.wait(0.1)
        arg229.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
    local function fn353()
        if localPlayer.Character then
            local killer = nil
            for _, v157 in ipairs(Players:GetPlayers()) do
                local isKiller = v157.Team
                if isKiller then
                    isKiller = v157.Team.Name == "Killer"
                end
                if isKiller then
                    killer = v157
                    break
                end
            end
            if killer then
                if var1198 then
                    var1198:Disconnect()
                    var1198 = nil
                end
                var1198 = RunService.Heartbeat:Connect(function()
                    local char = localPlayer.Character
                    local var1203 = char
                    if var1203 then
                        var1203 = char:FindFirstChild("HumanoidRootPart")
                    end
                    local var1204 = not flag59
                    if not var1204 then
                        var1204 = not char
                    end
                    if not var1204 then
                        var1204 = not var1203
                    end
                    if not var1204 then
                        if char:GetAttribute("IsHooked") then
                            local character53 = killer.Character
                            local var1205 = character53
                            if var1205 then
                                var1205 = character53:FindFirstChild("HumanoidRootPart")
                            end
                            if var1205 then
                                local var1206 = char:GetAttribute("anticampCharge")
                                if not var1206 then
                                    var1206 = 0
                                end
                                if not (var1206 >= 100) then
                                    var1203.CFrame = var1205.CFrame * CFrame.new(0, -15, 10)
                                    return
                                else
                                    fn352(var1203, char)
                                    task.wait(0.9)
                                    selfUnHookEvent:FireServer()
                                    return
                                end
                            else
                                flag59 = false
                                return
                            end
                        else
                            fn352(var1203, char)
                            return
                        end
                    else
                        if var1198 then
                            var1198:Disconnect()
                            var1198 = nil
                        end
                        return
                    end
                end)
                return
            else
                return
            end
        else
            return
        end
    end
    var1197 = function()
        flag58 = true
        var1196()
    end
    var1196 = function()
        if flag58 then
            local char = localPlayer.Character
            if char then
                if char:GetAttribute("IsHooked") then
                    flag59 = not flag59
                    if not flag59 then
                        if var1198 then
                            var1198:Disconnect()
                            var1198 = nil
                        end
                        return
                    else
                        local humanoidRootPart35 = char:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart35 then
                            var1199 = fn351(humanoidRootPart35.Position)
                            task.wait(1)
                            local var1207 = not flag59
                            if not var1207 then
                                var1207 = not char:GetAttribute("IsHooked")
                            end
                            if not var1207 then
                                local var1208 = nil
                                for _, v158 in ipairs(Workspace:GetDescendants()) do
                                    local m = v158.Name:match("^GeneratorPoint")
                                    if m then
                                        m = v158:IsA("BasePart")
                                    end
                                    if m then
                                        var1208 = v158
                                        break
                                    end
                                end
                                if var1208 then
                                    humanoidRootPart35.CFrame = var1208.CFrame + Vector3.new(0, 3, 0)
                                    task.wait(0.1)
                                    repairEvent:FireServer(var1208, true)
                                    task.wait(0.25)
                                    repairEvent:FireServer(var1208, false)
                                    task.wait(0.1)
                                    fn353()
                                end
                                return
                            else
                                return
                            end
                        else
                            return
                        end
                    end
                else
                    return
                end
            else
                return
            end
        else
            return
        end
    end
end
local function fn354()
    local var1209 = library:Window({
        Title = "BOLONG-HUB",
        Image = "84034353458936",
        Footer = "Violence District",
        Author = "Discord.gg/pWpgqVGxNK",
        Color = color3,
        Version = 1,
        Search = true,
        Folder = "BolongHub",
    })
    var1209:InfoTab({
        Name = "Info",
        Icon = "info",
        SectionTitle = "Information",
        Banner = "79662603577585",
        BannerAspectRatio = 3.2,
        Version = str,
        DiscordLink = "https://discord.gg/pWpgqVGxNK",
        DiscordName = "Community BolongHub",
        DiscordText = "Gabung untuk update & support.",
        DiscordDesc = "Made by 11rill — features: Killer & Survivor Hitbox/ESP, Auto Aim, Auto Generator, Killer Warn, Camera Veil, and many more.",
        CardsWidget = {{catwidget = "rbxassetid://117486345000318"}},
    })
    local var1210 = var1209:AddTab({Name = "Exclusive", Icon = "sparkles"})
    local var1211 = var1209:AddTab({Name = "Killer", Icon = "swords"})
    local var1212 = var1209:AddTab({Name = "Survivor", Icon = "user"})
    local var1213 = var1209:AddTab({Name = "Visual", Icon = "eye"})
    local var1214 = var1209:AddTab({Name = "Misc", Icon = "settings"})
    local var1215 = var1209:AddTab({Name = "Config", Icon = "save"})
    do
        local var1216 = var1210:AddSection("Invisible Op", nil)
        var1216:AddTogglePanel({
            Title = "Enable Invisible",
            PanelTitle = "INVISIBLE",
            Subtitle = "Invisible",
            ButtonTitle = "Open Invisible Panel",
            Default = false,
            OffsetY = 0,
            Callback = function(arg230)
                var940(arg230)
            end,
        })
        local var1217 = var1210:AddSection("Auto Parry", nil)
        local var1218 = var1217:AddHStack()
        var1218:AddToggle({
            Title = "Auto Parry",
            Default = false,
            Callback = function(arg231)
                tbl2.flag116 = arg231
                if not arg231 then
                    tbl2.list7 = {}
                    tbl2.list8 = {}
                    tbl2.list9 = {}
                    tbl2.list10 = {}
                end
            end,
        })
        var1218:AddToggle({
            Title = "Radius ESP",
            Default = false,
            Callback = function(arg232)
                tbl2.flag117 = arg232
                if var587 then
                    var587(arg232)
                end
            end,
        })
        var1217:AddToggle({
            Title = "Ignore Skill Abysswalker",
            Content = "Abaikan Skill Dari Killer Abysswalker",
            Default = false,
            Callback = function(arg233)
                tbl2.flag118 = arg233
                if arg233 then
                    for char, v159 in pairs(tbl2.list8) do
                        if v159 and v159.skillId == 80411309607666 then
                            tbl2.list8[char] = nil
                        end
                    end
                end
            end,
        })
        var1217:AddToggle({
            Title = "Ignore Skill Masked (Duck)",
            Content = "Abaikan Skill Dari Killer Masked (Bebek)",
            Default = false,
            Callback = function(arg234)
                tbl2.flag119 = arg234
                if arg234 then
                    for char, v160 in pairs(tbl2.list7) do
                        if v160.name and (v160.name:lower() == "the masked (duck)" or v160.name:lower() == "the masked") then
                            tbl2.list7[char] = nil
                        end
                    end
                    for char, v161 in pairs(tbl2.list8) do
                        if v161.name and (v161.name:lower() == "the masked (duck)" or v161.name:lower() == "the masked") then
                            tbl2.list8[char] = nil
                        end
                    end
                    tbl2.list9 = {}
                    tbl2.list10 = {}
                end
            end,
        })
        var1217:AddSlider({
            Title = "Parry Radius (Stud)",
            Min = 4,
            Max = 40,
            Default = 10,
            Increment = 1,
            Callback = function(arg235)
                tbl2.num130 = arg235
            end,
        })
        var1217:AddSlider({
            Title = "Face Killer Sensitivity",
            Min = -1,
            Max = 1,
            Default = 1,
            Increment = 0.1,
            Callback = function(arg236)
                tbl2.num134 = math.clamp(arg236, -1, 1)
            end,
        })
        var1217:AddSlider({
            Title = "Aim Strictness",
            Min = 0.1,
            Max = 3,
            Default = 1.5,
            Increment = 0.1,
            Callback = function(arg237)
                tbl2.num132 = arg237
            end,
        })
        local var1219 = var1210:AddSection("Killer Fovv", nil)
        var1219:AddToggle({
            Title = "Line Always",
            Default = false,
            Callback = function(arg238)
                if var588 then
                    var588.setLineAlways(arg238)
                end
            end,
        })
        var1219:AddToggle({
            Title = "Sensory Range",
            Default = false,
            Callback = function(arg239)
                if var588 then
                    var588.setHeavenEyes(arg239)
                end
            end,
        })
        local var1220 = var1219:AddHStack()
        var1220:AddSlider({
            Title = "Always Length",
            Min = 10,
            Max = 100,
            Default = 50,
            Increment = 1,
            Callback = function(arg240)
                if var588 then
                    var588.setAlwaysLineLength(arg240)
                end
            end,
        })
        local var1221 = var1210:AddSection("Unhook Yourself", nil)
        var1221:AddParagraph({Title = "Unhook Yourself", Content = "Bypass Hook."})
        local flag60 = false
        local var1222 = library:TogglePanel({
            Title = "UNHOOK",
            Subtitle = "Unhook",
            Default = false,
            OffsetY = 95,
            Callback = function(arg241)
                if not arg241 then
                    var1196()
                    return
                end
                if flag60 then
                    return
                end
                local char = localPlayer.Character
                if not (char and char:GetAttribute("IsHooked")) then
                    undefinedGlobal5:Set(false)
                    fn2("Unhook", "Kamu sedang tidak hooked", 2)
                    return
                end
                flag60 = true
                task.spawn(function()
                    var1197()
                    task.wait(1.5)
                    flag60 = false
                end)
            end,
        })
        var1221:AddButton({
            Title = "Open Unhook Panel",
            Callback = function()
                var1222:Toggle()
            end,
        })
        var1221:AddKeybind({
            Title = "Unhook Keybind",
            Default = Enum.KeyCode.Unknown,
            Callback = function()
                var1196()
            end,
        })
        local var1223 = var1210:AddSection("Silent Spear (Veil)", nil)
        var1223:AddParagraph({
            Title = "Aim Guide",
            Content = "[ID] Saat Indikator/Snapline berubah hijau atau menampilkan \"RELEASE\", itu adalah waktu paling akurat untuk melepaskan SPEAR (90% kena target jika target diam).\n\n[EN] When the Indicator/Snapline turns green or shows \"RELEASE\", it is the most accurate time to release the SPEAR (90% hit chance if the target is stationary).",
        })
        var1223:AddToggle({
            Title = "Silent Spear",
            Default = false,
            Callback = function(arg242)
                tbl2.flag138 = arg242
                if not arg242 then
                    tbl2.num142 = 142.5
                    tbl2.num143 = 0.5
                    tbl2.spearLastShot = nil
                end
            end,
        })
        local var1224 = var1223:AddHStack()
        local var1225 = var1223:AddHStack()
        var1224:AddToggle({
            Title = "FOV Circle",
            Default = false,
            Callback = function(arg243)
                tbl2.flag140 = arg243
            end,
        })
        var1224:AddToggle({
            Title = "Aim Indicator",
            Default = false,
            Callback = function(arg244)
                tbl2.flag139 = arg244
            end,
        })
        var1225:AddToggle({
            Title = "SnapLine",
            Default = false,
            Callback = function(arg245)
                tbl2.SPEAR_SNAPLINE.enabled = arg245
            end,
        })
        var1225:AddToggle({
            Title = "Show Name/Studs",
            Default = true,
            Callback = function(arg246)
                tbl.flag94 = arg246
            end,
        })
        var1223:AddSlider({
            Title = "Spear FOV Radius",
            Min = 30,
            Max = 500,
            Default = 150,
            Step = 5,
            Callback = function(arg247)
                tbl.num121 = arg247
            end,
        })
        var1223:AddToggle({
            Title = "Spear Auto Prediction",
            Default = true,
            Callback = function(arg248)
                tbl.flag92 = arg248
            end,
        })
        var1223:AddToggle({
            Title = "Spear Anti-Strafing",
            Content = "Redam lead saat survivor tiba-tiba balik arah",
            Default = true,
            Callback = function(arg249)
                tbl.flag93 = arg249
            end,
        })
        local var1226 = var1210:AddSection("Silent Aim (Twist of Fate)", nil)
        var1226:AddToggle({
            Title = "Silent Aim",
            Default = false,
            Callback = function(arg250)
                tbl2.flag134 = arg250
            end,
        })
        local var1227 = var1226:AddTargetSelector({
            Title = "Silent Aim",
            DropdownTitle = "Target Type",
            Options = {"KILLER", "SURVIVOR", "ZOMBIE"},
            Values = {"Killer", "Survivor", "Zombie"},
            Default = tbl.str14 or "Killer",
            Callback = function(arg251)
                tbl.str14 = arg251
            end,
        })
        local var1228 = var1226:AddHStack()
        var1228:AddToggle({
            Title = "FOV Circle",
            Default = false,
            Callback = function(arg252)
                tbl2.flag137 = arg252
            end,
        })
        var1228:AddToggle({
            Title = "Laser ESP",
            Default = false,
            Callback = function(arg253)
                tbl2.flag135 = arg253
            end,
        })
        var1226:AddToggle({
            Title = "Auto Prediction (ToF)",
            Default = true,
            Callback = function(arg254)
                tbl.flag90 = arg254
            end,
        })
        var1226:AddToggle({
            Title = "Adaptive Damping (Zigzag)",
            Default = true,
            Callback = function(arg255)
                tbl.flag91 = arg255
            end,
        })
        var1226:AddSlider({
            Title = "Aim FOV Radius",
            Min = 30,
            Max = 500,
            Default = 150,
            Step = 5,
            Callback = function(arg256)
                tbl.num120 = arg256
            end,
        })
        local var1229 = var1210:AddSection("Shoot While Downed/Carried", nil)
        var1229:AddToggle({
            Title = "Enable Shoot While Downed/Carried",
            Default = false,
            Content = "Tetap bisa tembak Twist of Fate meski down/IsCarried/IsHooked",
            Callback = function(arg257)
                tbl.flag107 = arg257
            end,
        })
        local var1230 = var1210:AddSection("Crosshair", nil)
        var1230:AddToggle({
            Title = "Enable Crosshair",
            Default = false,
            Callback = function(arg258)
                var509:SetEnabled(arg258)
            end,
        })
        var1230:AddDropdown({
            Title = "Style / Model",
            Options = CROSSHAIR_STYLES,
            Default = "Dot",
            Callback = function(arg259)
                var509:SetStyle(arg259)
            end,
        })
        var1230:AddSlider({
            Title = "Size",
            Min = 1,
            Max = 100,
            Default = 20,
            Increment = 1,
            Callback = function(arg260)
                var509:SetSize(arg260)
            end,
        })
        var1230:AddSlider({
            Title = "Opacity",
            Min = 0,
            Max = 100,
            Default = 100,
            Increment = 1,
            Callback = function(arg261)
                var509:SetOpacity(arg261 / 100)
            end,
        })
        var1230:AddInput({
            Title = "Position X (px)",
            Default = "0",
            Placeholder = (function()
                if var30 and buffer then
                    local _bf = buffer.create(37)
                    local _by = {
                        79,
                        102,
                        102,
                        115,
                        101,
                        116,
                        32,
                        102,
                        114,
                        111,
                        109,
                        32,
                        99,
                        101,
                        110,
                        116,
                        101,
                        114,
                        32,
                        40,
                        112,
                        111,
                        115,
                        105,
                        116,
                        105,
                        118,
                        101,
                        32,
                        61,
                        32,
                        114,
                        105,
                        103,
                        104,
                        116,
                        41,
                    }
                    for _i = 1, #_by do
                        buffer.writeu8(_bf, _i - 1, _by[_i])
                    end
                    local _s = {}
                    for _i = 1, #_by do
                        _s[_i] = string.char(buffer.readu8(_bf, _i - 1))
                    end
                    return table.concat(_s)
                else
                    local _by = {
                        79,
                        102,
                        102,
                        115,
                        101,
                        116,
                        32,
                        102,
                        114,
                        111,
                        109,
                        32,
                        99,
                        101,
                        110,
                        116,
                        101,
                        114,
                        32,
                        40,
                        112,
                        111,
                        115,
                        105,
                        116,
                        105,
                        118,
                        101,
                        32,
                        61,
                        32,
                        114,
                        105,
                        103,
                        104,
                        116,
                        41,
                    }
                    local _s = {}
                    for _i = 1, #_by do
                        _s[_i] = string.char(_by[_i])
                    end
                    return table.concat(_s)
                end
            end)(),
            Callback = function(arg262)
                local var1231 = tonumber(arg262)
                if var1231 then
                    var509:SetOffsetX(math.clamp(var1231, -1000, 1000))
                end
            end,
        })
        var1230:AddInput({
            Title = "Position Y (px)",
            Default = "0",
            Placeholder = "Offset from center (positive = down)",
            Callback = function(arg263)
                local var1232 = tonumber(arg263)
                if var1232 then
                    var509:SetOffsetY(math.clamp(var1232, -1000, 1000))
                end
            end,
        })
        var1230:AddColorPicker({
            Title = "Crosshair Color",
            Default = Color3.fromRGB(255, 255, 255),
            Callback = function(color)
                var509:SetColor(color)
            end,
        })
        local var1233 = var1210:AddSection("God Mode", nil)
        var1233:AddParagraph({
            Title = "God Mode",
            Content = "Instant Heal + Anti Knock/Down.\nSangat Cocok Jika Digunakan Untuk Main Pistol-pistolan.",
        })
        var1233:AddToggle({
            Title = "Enable God Mode",
            Default = false,
            Callback = function(arg264)
                if arg264 then
                    fn71()
                else
                    fn72()
                end
            end,
        })
        local var1235 = var1210:AddSection("Self Heal & Bandage Boost", nil)
        var1235:AddToggle({
            Title = "No-Anim Self Heal",
            Default = false,
            Callback = function(arg265)
                HEAL_SetNoAnim(arg265)
            end,
        })
        local var1236, BandageBoostToggle
        local flag61 = false
        var1236 = var1235:AddToggle({
            Title = "Self Heal",
            Default = false,
            Callback = function(arg266)
                if flag61 then
                    return
                end
                if arg266 then
                    if BandageBoostToggle then
                        BandageBoostToggle:Set(false)
                    end
                    var1156()
                else
                    HEAL_Abort()
                end
            end,
        })
        BandageBoostToggle = var1235:AddToggle({
            Title = "Bandage Boost",
            Default = false,
            Callback = function(arg267)
                if flag61 then
                    return
                end
                if arg267 then
                    if var1236 then
                        var1236:Set(false)
                    end
                    HEAL_BoostBandage()
                else
                    HEAL_Abort()
                end
            end,
        })
        local var1237, BandageBoostPanel
        var1237 = library:TogglePanel({
            Title = "SELF HEAL",
            Subtitle = "Self Heal",
            Default = false,
            OffsetY = 190,
            Callback = function(arg268)
                if arg268 then
                    if BandageBoostPanel then
                        BandageBoostPanel:Set(false)
                    end
                    var1156()
                else
                    HEAL_Abort()
                end
            end,
        })
        BandageBoostPanel = library:TogglePanel({
            Title = "BANDAGE BOOST",
            Subtitle = "Boost Bandage",
            Default = false,
            OffsetY = 285,
            Callback = function(arg269)
                if arg269 then
                    if var1237 then
                        var1237:Set(false)
                    end
                    HEAL_BoostBandage()
                else
                    HEAL_Abort()
                end
            end,
        })
        HEAL_SetSessionEndHook(function()
            flag61 = true
            if var1237 then
                var1237:Set(false)
            end
            if BandageBoostPanel then
                BandageBoostPanel:Set(false)
            end
            if var1236 then
                var1236:Set(false)
            end
            if BandageBoostToggle then
                BandageBoostToggle:Set(false)
            end
            flag61 = false
        end)
        var1235:AddButton({
            Title = "Open Self Heal Panel",
            Callback = function()
                var1237:Toggle()
            end,
        })
        var1235:AddButton({
            Title = "Open Bandage Panel",
            Callback = function()
                BandageBoostPanel:Toggle()
            end,
        })
        var1235:AddKeybind({
            Title = "Self Heal Keybind",
            Default = Enum.KeyCode.Unknown,
            Callback = function()
                var1156()
            end,
        })
        var1235:AddKeybind({
            Title = "Bandage Boost Keybind",
            Default = Enum.KeyCode.Unknown,
            Callback = function()
                HEAL_BoostBandage()
            end,
        })
        local var1238 = var1210:AddSection("Aimlock Flashlight", nil)
        var1238:AddToggle({
            Title = "Enable Aimlock Flashlight",
            Content = "Auto senter ke kepala Killer terdekat (max 30 studs)",
            Default = false,
            Callback = function(arg270)
                tbl2.flag155 = arg270
                if not arg270 then
                    tbl2.flag156 = false
                end
            end,
        })
        var1238:AddSlider({
            Title = "Smoothness",
            Min = 0.05,
            Max = 1,
            Default = 0.35,
            Step = 0.01,
            Callback = function(arg271)
                tbl2.num156 = tonumber(arg271) or 0.35
            end,
        })
        local var1239 = var1210:AddSection("Aim Lock (Legit)", nil)
        var1239:AddToggle({
            Title = "Enable Aim Lock",
            Default = false,
            Callback = function(arg272)
                tbl.flag79 = arg272
                if arg272 then
                    var427()
                else
                    StopCameralock()
                end
            end,
        })
        var1239:AddTargetSelector({
            Title = "Aim Lock",
            DropdownTitle = "Lock Target",
            Options = {"ZOMBIE", "SURVIVOR", "KILLER"},
            Values = {"Zombie", "Survivor", "Killer"},
            Default = tbl.str11 or "Zombie",
            Callback = function(arg273)
                tbl.str11 = arg273
            end,
        })
        var1239:AddDropdown({
            Title = "Aim Part",
            Options = {"Torso", "Head"},
            Default = "Torso",
            Callback = function(arg274)
                tbl.str13 = arg274
            end,
        })
        var1239:AddDropdown({
            Title = "Lock Mode",
            Content = "Recommended Use: Hold to Lock (PC: Right Click / Mobile: Slasher Attack Button)",
            Options = {"Always Lock", "Hold to Lock"},
            Default = "Always Lock",
            Callback = function(arg275)
                tbl.str12 = arg275
            end,
        })
        var1239:AddSlider({
            Title = "Max Distance",
            Content = "Maximum distance to lock target (studs)",
            Min = 20,
            Max = 700,
            Default = tbl.num118,
            Increment = 5,
            Callback = function(arg276)
                tbl.num118 = arg276
            end,
        })
        var1239:AddSlider({
            Title = "Camera Smoothness",
            Min = 0.01,
            Max = 1,
            Default = tbl.num119,
            Increment = 0.01,
            Callback = function(arg277)
                tbl.num119 = arg277
            end,
        })
        local var1240 = var1210:AddSection("Camera Veil (Legit)", nil)
        var1240:AddToggle({
            Title = "Camera Veil",
            Default = false,
            Callback = function(arg278)
                tbl.flag86 = arg278
                local var1241 = pcall(function()
                    if arg278 then
                        var99()
                    else
                        StopCameraVeil()
                    end
                end)
                if not var1241 then
                    tbl.flag86 = false
                    fn2("Camera Veil", "Gagal mengaktifkan Camera Veil", 2)
                end
            end,
        })
        var1240:AddToggle({
            Title = "SnapLine ESP",
            Default = false,
            Callback = function(arg279)
                tbl.flag87 = arg279
                if not arg279 then
                    if tbl2.field8 then
                        tbl2.field8.Visible = false
                    end
                    if tbl2.field9 then
                        tbl2.field9.Visible = false
                    end
                end
            end,
        })
    end
    do
        local var1242 = var1211:AddSection("Killer No Cooldown", nil)
        var1242:AddToggle({
            Title = "Enable No Cooldown Bypass",
            Content = "Hidden, Abysswalker, Masked, More",
            Default = false,
            Callback = function(arg280)
                flag = arg280
                if arg280 then
                    fn7()
                else
                    fn8()
                end
            end,
        })
        local var1243 = var1242:AddHStack()
        var1243:AddButton({
            Title = "Fire Corrupt (Abyss)",
            Callback = function()
                pcall(function()
                    local corrupt = game:GetService("ReplicatedStorage").Remotes.Killers.Abysswalker.corrupt
                    corrupt:FireServer()
                end)
            end,
        })
        var1243:AddButton({
            Title = "Fire Slash (Abyss)",
            Callback = function()
                pcall(function()
                    local basicAttack = game:GetService("ReplicatedStorage").Remotes.Attacks.BasicAttack
                    basicAttack:FireServer(true)
                end)
            end,
        })
        local var1244 = var1211:AddSection("Mayers (Stalker) No Cooldown", nil)
        var1244:AddToggle({
            Title = "Enable Mayers No Cooldown",
            Content = "PC: Q | Mobile: Button Jambak",
            Default = false,
            Callback = function(arg281)
                tbl2.flag160 = arg281
                if arg281 and not flag then
                    fn7()
                end
                if arg281 then
                    StartMayersMobileHook()
                else
                    StopMayersMobileHook()
                end
            end,
        })
        var1244:AddToggle({
            Title = "Stalk While Moving (Auto)",
            Content = (function()
                if var30 and buffer then
                    local _bf = buffer.create(34)
                    local _by = {
                        65,
                        117,
                        116,
                        111,
                        32,
                        83,
                        116,
                        97,
                        108,
                        107,
                        105,
                        110,
                        103,
                        32,
                        107,
                        101,
                        32,
                        115,
                        117,
                        114,
                        118,
                        105,
                        118,
                        111,
                        114,
                        32,
                        116,
                        101,
                        114,
                        100,
                        101,
                        107,
                        97,
                        116,
                    }
                    for _i = 1, #_by do
                        buffer.writeu8(_bf, _i - 1, _by[_i])
                    end
                    local _s = {}
                    for _i = 1, #_by do
                        _s[_i] = string.char(buffer.readu8(_bf, _i - 1))
                    end
                    return table.concat(_s)
                else
                    local _by = {
                        65,
                        117,
                        116,
                        111,
                        32,
                        83,
                        116,
                        97,
                        108,
                        107,
                        105,
                        110,
                        103,
                        32,
                        107,
                        101,
                        32,
                        115,
                        117,
                        114,
                        118,
                        105,
                        118,
                        111,
                        114,
                        32,
                        116,
                        101,
                        114,
                        100,
                        101,
                        107,
                        97,
                        116,
                    }
                    local _s = {}
                    for _i = 1, #_by do
                        _s[_i] = string.char(_by[_i])
                    end
                    return table.concat(_s)
                end
            end)(),
            Default = false,
            Callback = function(arg282)
                tbl2.flag161 = arg282
            end,
        })
        local var1245 = var1244:AddHStack()
        var1245:AddButton({
            Title = "Dash (Q) NoCD",
            Callback = function()
                var64()
            end,
        })
        var1245:AddButton({
            Title = "Grab Nearest",
            Callback = function()
                pcall(function()
                    local target = GetNearestSurvivorForMayers(8)
                    if target then
                        local grab2 = game:GetService("ReplicatedStorage").Remotes.Killers.Stalker:FindFirstChild("grab")
                        if grab2 then
                            grab2:FireServer(target)
                            fn2("Mayers", "Grab fired: " .. target.Name, 1.2)
                        end
                    else
                        fn2("Mayers", "No target within 8 studs", 1.2)
                    end
                end)
            end,
        })
        local var1246 = var1211:AddSection("Infinite Lunge", nil)
        var1246:AddToggle({
            Title = "Enable Infinite Lunge",
            Content = "Lunge saat menahan attack tidak pernah berakhir",
            Default = tbl.flag100,
            Callback = function(arg283)
                tbl.flag100 = arg283
                if arg283 then
                    fn15()
                else
                    fn14()
                end
            end,
        })
        local var1247 = var1242:AddHStack()
        var1247:AddButton({
            Title = "Fire Leap (Hidden)",
            Callback = function()
                pcall(function()
                    local leap = game:GetService("ReplicatedStorage").Remotes.Killers.Hidden.Leap
                    leap:FireServer(true)
                end)
            end,
        })
        var1247:AddButton({
            Title = "Fire M2 (Hidden)",
            Callback = function()
                pcall(function()
                    local M2 = game:GetService("ReplicatedStorage").Remotes.Killers.Hidden.M2
                    M2:FireServer({}, false)
                end)
            end,
        })
        local var1248 = var1211:AddSection("Aimlock M2 Skill Hidden", nil)
        var1248:AddToggle({
            Title = "Enable AIMLOCK M2",
            Content = "Auto lock survivor terdekat (max 50 studs)",
            Default = false,
            Callback = function(arg284)
                tbl2.flag159 = arg284
                if arg284 then
                    var973()
                else
                    StopHiddenM2Hook()
                end
            end,
        })
        var1248:AddSlider({
            Title = "Smoothness",
            Min = 0.05,
            Max = 1,
            Default = 1,
            Step = 0.01,
            Callback = function(arg285)
                tbl2.num160 = tonumber(arg285) or 1
            end,
        })
        local var1249 = var1211:AddSection("Masked Skill Spammer", nil)
        local str10 = "Cobra"
        var1249:AddDropdown({
            Title = "Select Mask Power",
            Options = {"Alex", "Brandon", "Cobra", "Rabbit", "Richter", "Tony"},
            Default = "Cobra",
            Callback = function(arg286)
                str10 = arg286
            end,
        })
        local var1250 = var1249:AddHStack()
        var1250:AddButton({
            Title = "Activate Power",
            Callback = function()
                pcall(function()
                    local activatepower = game:GetService("ReplicatedStorage").Remotes.Killers.Masked.Activatepower
                    activatepower:FireServer(str10)
                end)
                fn2("Masked", "Power Activated: " .. str10, 1.5)
            end,
        })
        var1250:AddButton({
            Title = "Deactivate Power",
            Callback = function()
                pcall(function()
                    local deactivatepower = game:GetService("ReplicatedStorage").Remotes.Killers.Masked.Deactivatepower
                    deactivatepower:FireServer()
                end)
                fn2("Masked", "Power Deactivated", 1.5)
            end,
        })
        local var1251 = var1211:AddSection("Anti Blind", nil)
        var1251:AddToggle({
            Title = "Anti Flashlight Blind",
            Content = "Mencegah kamu terkena efek buta (Blinded) dari senter Survivor",
            Default = false,
            Callback = function(arg287)
                tbl.flag96 = arg287
                if arg287 and type(getgenv().SetupAntiBlindHook) == "function" then
                    pcall(getgenv().SetupAntiBlindHook)
                end
            end,
        })
        local var1252 = var1211:AddSection("Anti Looping", nil)
        var1252:AddToggle({
            Title = "Anti Loop Window",
            Content = "Membuat semua window di map tidak bisa digunakan untuk looping",
            Default = false,
            Callback = function(arg288)
                tbl2.flag146 = arg288
                if arg288 then
                    ApplyAntiLoopWindow()
                else
                    DisableAntiLoopWindow()
                end
            end,
        })
        var1252:AddButton({
            Title = "Auto Drop All Pallets",
            Callback = function()
                DropAllPallets()
            end,
        })
        local var1253 = var1211:AddSection("Killer Perks Info", nil)
        local var1254 = var1253:AddToggle({
            Title = "Enable Killer Perks Info",
            Default = tbl.flag104,
            Callback = function(arg289)
                tbl.flag104 = arg289
                if arg289 then
                    StartKillerPerksInfo()
                else
                    StopKillerPerksInfo()
                end
            end,
        })
        SetKPI_ToggleRef(var1254)
        local var1255 = var1211:AddSection("Hook Counter", nil)
        var1255:AddToggle({
            Title = "Show Hook Counter",
            Default = tbl.flag105,
            Callback = function(arg290)
                tbl.flag105 = arg290
                if arg290 then
                    if tbl2._HookCounter_Enable then
                        pcall(tbl2._HookCounter_Enable)
                    end
                else
                    if tbl2._HookCounter_Disable then
                        pcall(tbl2._HookCounter_Disable)
                    end
                end
            end,
        })
    end
    do
        local var1256 = var1212:AddSection("Auto Generator", nil)
        var1256:AddToggle({
            Title = "Auto Generator",
            Default = tbl.flag76,
            Callback = function(arg291)
                tbl.flag76 = arg291
            end,
        })
        var1256:AddParagraph({
            Title = "Mode",
            Content = "Normal = safe zone | Perfect = zona Perfect | Instant = 😈 | Random = Succes/Neutral",
        })
        var1256:AddTargetSelector({
            Title = "Auto Generator",
            DropdownTitle = "Mode",
            ButtonTitle = "Open Mode Panel",
            Options = {"INSTANT", "PERFECT", "NORMAL", "RANDOM"},
            Values = {"Instant", "Perfect", "Normal", "Random"},
            Default = tbl.str1,
            Callback = function(arg292)
                if arg292 then
                    tbl.str1 = arg292
                end
            end,
        })
        local var1257 = var1212:AddSection("Generator Boost", nil)
        var1257:AddToggle({
            Title = "Show GenBoost Button",
            Default = false,
            Callback = function(arg293)
                tbl.flag77 = arg293
                if arg293 then
                    CreateGenBoostButton()
                else
                    DestroyGenBoostButton()
                end
            end,
        })
        var1257:AddKeybind({
            Title = "GenBoost Keybind",
            Default = Enum.KeyCode.Unknown,
            Callback = function()
                PerformGenBoost()
            end,
        })
        local var1258 = var1212:AddSection("Anti Fall Slow", nil)
        var1258:AddToggle({
            Title = "Anti Fall Slow",
            Content = "Mencegah karakter melambat saat mendarat / jatuh dari ketinggian berapa pun",
            Default = false,
            Callback = function(arg294)
                tbl2.flag111 = arg294
                local char = localPlayer.Character
                local var1259 = char and char:FindFirstChildOfClass("Humanoid")
                if arg294 then
                    _StartAntiFallSlow(var1259)
                else
                    _StopAntiFallSlow(var1259)
                end
            end,
        })
        local var1260 = var1212:AddSection("Speed Boost V1", nil)
        local var1261, sb2ToggleHandle
        var1261 = var1260:AddToggle({
            Title = "Speed Boost",
            Default = false,
            Callback = function(arg295)
                if arg295 and tbl2.flag114 and sb2ToggleHandle then
                    sb2ToggleHandle:Set(false)
                end
                var406(arg295)
            end,
        })
        var1260:AddSlider({
            Title = "Boost Multiplier",
            Min = 0,
            Max = 2,
            Default = 0.3,
            Increment = 0.01,
            Callback = function(arg296)
                tbl2.num127 = arg296
                if tbl2.SB_Retarget then
                    pcall(tbl2.SB_Retarget)
                end
            end,
        })
        var1260:AddToggle({
            Title = "Count Speed Perks",
            Content = "Perk & slow bawaan game ikut dihitung",
            Default = true,
            Callback = function(arg297)
                tbl2.flag110 = arg297
                if tbl2.SB_RefreshAll then
                    pcall(tbl2.SB_RefreshAll)
                end
            end,
        })
        var1260:AddToggle({
            Title = "Pause when Crouching",
            Content = "SpeedBoost berhenti saat crouch, otomatis lanjut setelah tidak crouch",
            Default = false,
            Callback = function(arg298)
                tbl2.flag113 = arg298
            end,
        })
        tbl2.SB_SyncToggle = function(arg299)
            if var1261 then
                var1261:Set(arg299)
            end
        end
        local var1262 = var1212:AddSection("Speed Boost V2", nil)
        sb2ToggleHandle = var1262:AddToggle({
            Title = "Speed Boost V2",
            Default = false,
            Callback = function(arg300)
                if arg300 and tbl2.SpeedBoost and var1261 then
                    var1261:Set(false)
                end
                var411(arg300)
            end,
        })
        var1262:AddDropdown({
            Title = "Team Filter",
            Options = {"Both", "Survivors", "Killer"},
            Default = "Both",
            Callback = function(arg301)
                tbl2.str16 = arg301
                if tbl2.SB2_Refresh then
                    pcall(tbl2.SB2_Refresh)
                end
            end,
        })
        var1262:AddSlider({
            Title = "Boost Multiplier x",
            Min = 1,
            Max = 3,
            Default = 1.3,
            Increment = 0.01,
            Callback = function(arg302)
                tbl2.num128 = arg302
                if tbl2.SB2_Refresh then
                    pcall(tbl2.SB2_Refresh)
                end
            end,
        })
        var1262:AddToggle({
            Title = "Count Speed Perks",
            Content = "Boost ditumpuk di atas perk speed bawaan game",
            Default = true,
            Callback = function(arg303)
                tbl2.flag115 = arg303
                if tbl2.SB2_Refresh then
                    pcall(tbl2.SB2_Refresh)
                end
            end,
        })
        tbl2.SB2_SyncToggle = function(arg304)
            if sb2ToggleHandle then
                sb2ToggleHandle:Set(arg304)
            end
        end
        local var1263 = var1212:AddSection("No Slowdown", nil)
        var1263:AddToggle({
            Title = "No Slowdown",
            Default = false,
            Callback = function(arg305)
                tbl2.flag109 = arg305
                local char = localPlayer.Character
                local var1264 = char and char:FindFirstChildOfClass("Humanoid")
                if arg305 then
                    _StartNoSlowdown(var1264)
                else
                    _StopNoSlowdown()
                end
            end,
        })
        var1263:AddToggle({
            Title = "Safe Mode (No Slowdown)",
            Content = "No Slowdown tidak menimpa efek slow dari (parry / item).",
            Default = true,
            Callback = function(arg306)
                tbl2.flag112 = arg306
            end,
        })
        local var1266 = var1212:AddSection("Auto Crouch (Abyss)", nil)
        var1266:AddToggle({
            Title = "Auto Crouch",
            Default = false,
            Callback = function(arg307)
                tbl.flag95 = arg307
                if not arg307 then
                    var871(false)
                end
            end,
        })
        var1266:AddSlider({
            Title = "Crouch Radius (Stud)",
            Min = 4,
            Max = 40,
            Default = 18,
            Increment = 1,
            Callback = function(arg308)
                tbl.num122 = arg308
            end,
        })
        local var1267 = var1212:AddSection("Auto Drop Nearby Pallet", nil)
        var1267:AddToggle({
            Title = "Auto Drop Nearby Pallet",
            Default = false,
            Callback = function(arg309)
                tbl2.flag148 = arg309
                if arg309 then
                    tbl2.list16 = nil
                end
            end,
        })
        local var1268 = var1212:AddSection("Moonwalk", nil)
        var1268:AddToggle({
            Title = "Enable Moonwalk (Mobile GUI)",
            Default = false,
            Callback = function(arg310)
                tbl.flag99 = arg310
                if arg310 then
                    var307()
                    if tbl2.field33 then
                        tbl2.field33.Enabled = true
                    end
                else
                    if tbl2.field33 then
                        tbl2.field33.Enabled = false
                    end
                    tbl2.num149 = 0
                    tbl2.flag150 = false
                    tbl2.flag151 = false
                end
            end,
        })
        var1268:AddDropdown({
            Title = "Moonwalk Mode",
            Content = "Classic = lock murni versi lama. Sway = versi goyang kiri-kanan.",
            Options = {"Classic", "Sway"},
            Default = "Classic",
            Callback = function(arg311)
                tbl.str15 = arg311
            end,
        })
        var1268:AddSlider({
            Title = "Sway Width",
            Content = "Lebar goyangan kiri-kanan (khusus mode Sway)",
            Min = 0.1,
            Max = 1.5,
            Default = 0.55,
            Increment = 0.05,
            Callback = function(arg312)
                tbl.num123 = arg312
            end,
        })
        var1268:AddSlider({
            Title = "Sway Speed",
            Content = "Kecepatan flip goyangan (khusus mode Sway)",
            Min = 1,
            Max = 12,
            Default = 6,
            Increment = 0.5,
            Callback = function(arg313)
                tbl.num124 = arg313
            end,
        })
        var1268:AddKeybind({
            Title = "PC Lock Forward Key",
            Default = Enum.KeyCode.Unknown,
            Callback = function()
                if tbl.flag99 then
                    tbl2.flag150 = not tbl2.flag150
                    if tbl2.flag150 then
                        tbl2.flag151 = false
                    end
                end
            end,
        })
        var1268:AddKeybind({
            Title = "PC Lock Backward Key",
            Default = Enum.KeyCode.Unknown,
            Callback = function()
                if tbl.flag99 then
                    tbl2.flag151 = not tbl2.flag151
                    if tbl2.flag151 then
                        tbl2.flag150 = false
                    end
                end
            end,
        })
        local var1269 = var1212:AddSection("Fast Vault Op", nil)
        var1269:AddToggle({
            Title = "Always Fast Vault",
            Default = false,
            Callback = function(arg314)
                tbl.flag101 = arg314
            end,
        })
        local var1270 = var1212:AddSection("Flowstate (Force Perk)", nil)
        var1270:AddToggle({
            Title = "Force Flowstate Perk",
            Default = false,
            Callback = function(arg315)
                tbl.flag102 = arg315
                if not arg315 then
                    pcall(function()
                        localPlayer:SetAttribute("Flowstate", nil)
                    end)
                    local char = localPlayer.Character
                    if char then
                        pcall(function()
                            char:SetAttribute("Flowstate", nil)
                        end)
                    end
                end
            end,
        })
        var1270:AddSlider({
            Title = "Flowstate Cooldown (s)",
            Min = 0,
            Max = 60,
            Default = 15,
            Increment = 1,
            Callback = function(arg316)
                tbl.num125 = arg316
            end,
        })
        var1270:AddToggle({
            Title = "Hide Flowstate UI",
            Default = false,
            Callback = function(arg317)
                tbl.flag103 = arg317
            end,
        })
        local var1271 = var1212:AddSection("Fake Perks", nil)
        var1271:AddSlider({
            Title = "Perk Cooldown",
            Content = (function()
                if var30 and buffer then
                    local _bf = buffer.create(33)
                    local _by = {
                        67,
                        111,
                        111,
                        108,
                        100,
                        111,
                        119,
                        110,
                        32,
                        115,
                        101,
                        109,
                        117,
                        97,
                        32,
                        70,
                        97,
                        107,
                        101,
                        32,
                        80,
                        101,
                        114,
                        107,
                        115,
                        32,
                        40,
                        100,
                        101,
                        116,
                        105,
                        107,
                        41,
                    }
                    for _i = 1, #_by do
                        buffer.writeu8(_bf, _i - 1, _by[_i])
                    end
                    local _s = {}
                    for _i = 1, #_by do
                        _s[_i] = string.char(buffer.readu8(_bf, _i - 1))
                    end
                    return table.concat(_s)
                else
                    local _by = {
                        67,
                        111,
                        111,
                        108,
                        100,
                        111,
                        119,
                        110,
                        32,
                        115,
                        101,
                        109,
                        117,
                        97,
                        32,
                        70,
                        97,
                        107,
                        101,
                        32,
                        80,
                        101,
                        114,
                        107,
                        115,
                        32,
                        40,
                        100,
                        101,
                        116,
                        105,
                        107,
                        41,
                    }
                    local _s = {}
                    for _i = 1, #_by do
                        _s[_i] = string.char(_by[_i])
                    end
                    return table.concat(_s)
                end
            end)(),
            Min = 0,
            Max = 60,
            Default = 10,
            Increment = 1,
            Callback = function(arg318)
                tbl2.fpCooldown = arg318
            end,
        })
        var1271:AddToggle({
            Title = "Quick Recovery",
            Content = "Mendapat +40% speed 3 detik setelah Fast/Medium Vault di Window",
            Default = false,
            Callback = function(arg319)
                FP_SetPerk("QuickRecovery", arg319)
            end,
        })
        var1271:AddToggle({
            Title = "Perfect Landing",
            Content = "+40% speed 3 detik setelah jatuh dari ketinggian",
            Default = false,
            Callback = function(arg320)
                FP_SetPerk("PerfectLanding", arg320)
            end,
        })
        var1271:AddToggle({
            Title = "Adrenaline Rush",
            Content = "+4 speed 5 detik saat HP drop ke 50",
            Default = false,
            Callback = function(arg321)
                FP_SetPerk("AdrenalineRush", arg321)
            end,
        })
        local var1272 = var1212:AddSection("Escape Gate", nil)
        var1272:AddButton({
            Title = "Auto Escape (Teleport)",
            Callback = function()
                fn241()
            end,
        })
        var1272:AddToggle({
            Title = "Ghost Gate (Legit Mode)",
            Default = false,
            Callback = function(arg322)
                tbl2.flag145 = arg322
                fn240()
            end,
        })
        local var1273 = var1212:AddSection("Lock FOV", nil)
        var1273:AddToggle({
            Title = "Lock FOV",
            Default = tbl.flag75,
            Callback = function(arg323)
                tbl.flag75 = arg323
                if arg323 then
                    fn111(tbl.num117)
                else
                    fn112()
                end
            end,
        })
        var1273:AddSlider({
            Title = "FOV Value",
            Min = 30,
            Max = 120,
            Default = tbl.num117,
            Increment = 1,
            Callback = function(arg324)
                tbl.num117 = arg324
                if tbl.flag75 then
                    fn111(arg324)
                end
            end,
        })
    end
    do
        local var1276 = var1213:AddSection("Killer ESP", nil)
        local var1277 = var1276:AddHStack()
        var1277:AddToggle({
            Title = "Show Name",
            Default = tbl.flag1,
            Callback = function(arg325)
                tbl.flag1 = arg325
                var198()
            end,
        })
        var1277:AddToggle({
            Title = "Show Outline",
            Default = tbl.flag64,
            Callback = function(arg326)
                tbl.flag64 = arg326
                var198()
            end,
        })
        var1276:AddColorPicker({
            Title = "Killer Color",
            Default = tbl.color31,
            Callback = function(color)
                tbl.color31 = color
                var198()
            end,
        })
        local var1278 = var1213:AddSection("Survivor ESP", nil)
        local var1279 = var1278:AddHStack()
        var1279:AddToggle({
            Title = "Show Name",
            Default = tbl.flag66,
            Callback = function(arg327)
                tbl.flag66 = arg327
                var198()
            end,
        })
        var1279:AddToggle({
            Title = "Show Outline",
            Default = tbl.flag67,
            Callback = function(arg328)
                tbl.flag67 = arg328
                var198()
            end,
        })
        var1278:AddColorPicker({
            Title = "Survivor Color",
            Default = tbl.color37,
            Callback = function(color)
                tbl.color37 = color
                var198()
            end,
        })
        local var1280 = var1213:AddSection("Zombie / SCP ESP", nil)
        var1280:AddToggle({
            Title = "Enable SCP ESP",
            Default = tbl.flag69,
            Callback = function(arg329)
                tbl.flag69 = arg329
                if not arg329 then
                    for model, _ in pairs(tbl2.scpEspObjects) do
                        var398(model)
                    end
                end
            end,
        })
        local var1281 = var1280:AddHStack()
        var1281:AddToggle({
            Title = "Show Name",
            Default = tbl.flag70,
            Callback = function(arg330)
                tbl.flag70 = arg330
                RefreshScpEsp()
            end,
        })
        var1280:AddColorPicker({
            Title = "SCP Color",
            Default = tbl.color38,
            Callback = function(color)
                tbl.color38 = color
                for _, v162 in pairs(tbl2.scpEspObjects) do
                    if v162.highlight then
                        v162.highlight.FillColor = color
                        v162.highlight.OutlineColor = color
                    end
                end
            end,
        })
        var1280:AddSlider({
            Title = "SCP ESP Distance",
            Min = 25,
            Max = 600,
            Default = tbl.num114,
            Live = true,
            Callback = function(arg331)
                tbl.num114 = arg331
                RefreshScpEsp()
            end,
        })
        local var1282 = var1213:AddSection("Player ESP Settings", nil)
        var1282:AddToggle({
            Title = "Outline Only",
            Content = "Tampilkan outline saja tanpa fill (berlaku untuk Killer & Survivor)",
            Default = tbl.flag65,
            Callback = function(arg332)
                tbl.flag65 = arg332
                tbl.flag68 = arg332
                var198()
            end,
        })
        var1282:AddButton({
            Title = "Refresh All ESP",
            Callback = function()
                ForceRefreshAllESP()
            end,
        })
        var1282:AddSlider({
            Title = "Killer ESP Distance",
            Min = 25,
            Max = 600,
            Default = tbl.num1,
            Live = true,
            Callback = function(arg333)
                tbl.num1 = arg333
                var198()
            end,
        })
        var1282:AddSlider({
            Title = "Survivor ESP Distance",
            Min = 25,
            Max = 600,
            Default = tbl.num113,
            Live = true,
            Callback = function(arg334)
                tbl.num113 = arg334
                var198()
            end,
        })
        local var1283 = var1213:AddSection("Show Item Survivor", nil)
        var1283:AddToggle({
            Title = "Show Equipped Item",
            Default = false,
            Callback = function(arg335)
                tbl.flag97 = arg335
            end,
        })
        local var1284 = var1213:AddSection("Object ESP", nil)
        local var1285 = var1284:AddHStack()
        var1285:AddToggle({
            Title = "ESP Generator",
            Default = tbl.flag80,
            Callback = function(arg336)
                tbl.flag80 = arg336
                var234()
            end,
        })
        var1285:AddToggle({
            Title = "Progress Gen",
            Default = tbl.flag81,
            Callback = function(arg337)
                tbl.flag81 = arg337
                for _, obj in ipairs(tbl2.list1.Generators) do
                    if obj and obj.Parent then
                        obj:SetAttribute("__BolongGenLastPct__", nil)
                        if not arg337 then
                            local __BolongGenProgress__3 = obj:FindFirstChild("__BolongGenProgress__")
                            if __BolongGenProgress__3 then
                                __BolongGenProgress__3:Destroy()
                            end
                        end
                    end
                end
                var234()
            end,
        })
        var1284:AddToggle({
            Title = "Show Generator Info",
            Default = tbl.flag78,
            Content = "Player & Break",
            Callback = function(arg338)
                tbl.flag78 = arg338
                for _, obj in ipairs(tbl2.list1.Generators) do
                    if obj and obj.Parent then
                        obj:SetAttribute("__BolongGenLastPct__", nil)
                    end
                end
            end,
        })
        local var1286 = var1284:AddHStack()
        var1286:AddToggle({
            Title = "ESP Window",
            Default = tbl.flag82,
            Callback = function(arg339)
                tbl.flag82 = arg339
                var234()
            end,
        })
        var1286:AddToggle({
            Title = "ESP Pallet",
            Default = tbl.flag83,
            Callback = function(arg340)
                tbl.flag83 = arg340
                var234()
            end,
        })
        local var1287 = var1284:AddHStack()
        var1287:AddToggle({
            Title = "ESP Hook",
            Default = tbl.flag84,
            Callback = function(arg341)
                tbl.flag84 = arg341
                var234()
            end,
        })
        var1287:AddToggle({
            Title = "ESP Gate",
            Default = tbl.flag85,
            Callback = function(arg342)
                tbl.flag85 = arg342
                var234()
            end,
        })
        local var1288 = var1284:AddHStack()
        var1288:AddColorPicker({
            Title = "Generator Color",
            Default = tbl.color39,
            Callback = function(color)
                tbl.color39 = color
                if tbl.flag80 then
                    for _, obj in ipairs(tbl2.list1.Generators) do
                        if obj and obj.Parent then
                            local __BolongHL__3 = obj:FindFirstChild("__BolongHL__")
                            if __BolongHL__3 then
                                __BolongHL__3.FillColor = color
                                __BolongHL__3.OutlineColor = color
                            end
                        end
                    end
                end
            end,
        })
        var1288:AddColorPicker({
            Title = "Window Color",
            Default = tbl.color310,
            Callback = function(color)
                tbl.color310 = color
                for part, v163 in pairs(tbl2.list6) do
                    if v163 and v163.Parent then
                        pcall(function()
                            v163.Color3 = color
                        end)
                    end
                end
            end,
        })
        local var1289 = var1284:AddHStack()
        var1289:AddColorPicker({
            Title = "Pallet Color",
            Default = tbl.color311,
            Callback = function(color)
                tbl.color311 = color
                for _, pallet in ipairs(tbl2.list1.Pallets) do
                    if pallet then
                        local __BolongHL__4 = pallet:FindFirstChild("__BolongHL__")
                        if __BolongHL__4 then
                            __BolongHL__4.FillColor = color
                            __BolongHL__4.OutlineColor = color
                        end
                    end
                end
            end,
        })
        var1289:AddColorPicker({
            Title = "Hook Color",
            Default = tbl.color312,
            Callback = function(color)
                tbl.color312 = color
                for _, v164 in ipairs(tbl2.list1.Hooks) do
                    if v164 and v164.Parent then
                        local var1290 = tbl2.list3[v164]
                        if var1290 then
                            for _, v165 in ipairs(var1290) do
                                local __BolongHL__5 = v165:FindFirstChild("__BolongHL__")
                                if __BolongHL__5 then
                                    __BolongHL__5.FillColor = color
                                    __BolongHL__5.OutlineColor = color
                                end
                            end
                        end
                    end
                end
            end,
        })
        local var1291 = var1284:AddHStack()
        var1291:AddColorPicker({
            Title = "Gate Color",
            Default = tbl.color313,
            Callback = function(color)
                tbl.color313 = color
                for _, v166 in ipairs(tbl2.list1.Gates) do
                    if v166 and v166.Parent then
                        local __BolongHL__6 = v166:FindFirstChild("__BolongHL__")
                        if __BolongHL__6 then
                            __BolongHL__6.FillColor = color
                            __BolongHL__6.OutlineColor = color
                        end
                    end
                end
            end,
        })
        local var1292 = var1213:AddSection("Prediction Map&Killer", nil)
        var1292:AddToggle({
            Title = "Show Prediction Monitor",
            Default = false,
            Callback = function(arg343)
                if arg343 then
                    StartPrediction()
                else
                    StopPrediction()
                end
            end,
        })
        local var1293 = var1213:AddSection("World Settings", nil)
        var1293:AddToggle({
            Title = "Fullbright",
            Default = false,
            Callback = function(arg344)
                tbl2.flag132 = arg344
                if arg344 then
                    var888()
                else
                    restoreLighting()
                end
            end,
        })
        var1293:AddToggle({
            Title = "Remove Visual Effects",
            Content = "BoostFps",
            Default = false,
            Callback = function(arg345)
                tbl2.flag133 = arg345
                if arg345 then
                    removeVisualEffects()
                else
                    restoreVisualEffects()
                end
            end,
        })
    end
    do
        local var1296 = var1214:AddSection("Potato Graphics By Ruv", nil)
        var1296:AddParagraph({Title = "Potato Graphics", Content = "by ruvlegacys."})
        var1296:AddButton({
            Title = "Apply Potato Graphics",
            Callback = function()
                if tbl2.flag165 then
                    fn2("Potato Graphics", "Sudah aktif", 1.5)
                    return
                end
                tbl.flag106 = true
                var1180()
                fn2("Potato Graphics", "Potato mode diterapkan", 2)
            end,
        })
        local var1297 = var1214:AddSection("Anti AFK", nil)
        var1297:AddToggle({
            Title = "Enable Anti AFK",
            Default = false,
            Callback = function(arg346)
                var82(arg346)
            end,
        })
        local var1298 = var1214:AddSection("Killer Warn", nil)
        var1298:AddToggle({
            Title = "Enable Killer Warn",
            Content = "The ! sign above your head when the killer is around you",
            Default = tbl.flag74,
            Callback = function(arg347)
                tbl.flag74 = arg347
            end,
        })
        local var1299 = var1214:AddSection("Stun Timer", nil)
        var1299:AddToggle({
            Title = "Enable Stun Timer",
            Content = "Show Stun x.xs countdown above stunned Killer head",
            Default = false,
            Callback = function(arg348)
                if arg348 then
                    var361()
                else
                    StopStunTimer()
                end
            end,
        })
        var1299:AddSlider({
            Title = "Max Distance",
            Min = 50,
            Max = 500,
            Default = 250,
            Increment = 10,
            Callback = function(arg349)
                tbl2.num155 = arg349
                for _, v167 in pairs(tbl2.stunTimerBoards) do
                    pcall(function()
                        v167.MaxDistance = arg349
                    end)
                end
            end,
        })
        local var1300 = var1214:AddSection("Performance Monitor", nil)
        var1300:AddToggle({
            Title = "Show Performance Window",
            Default = false,
            Callback = function(arg350)
                if arg350 then
                    var462()
                else
                    StopPerfMonitor()
                end
            end,
        })
        local var1301 = var1214:AddSection("Spectator Count", nil)
        var1301:AddToggle({
            Title = "Show Spectator Counter",
            Default = false,
            Callback = function(arg351)
                if arg351 then
                    var489()
                else
                    StopSpectatorCount()
                end
            end,
        })
        local var1302 = var1214:AddSection("Camera Zoom", nil)
        var1302:AddToggle({
            Title = "Max Camera Zoom",
            Default = tbl.flag71,
            Callback = function(arg352)
                tbl.flag71 = arg352
                if arg352 then
                    fn106(tbl.cameraZoomValue)
                else
                    fn107()
                end
            end,
        })
        local var1303 = var1214:AddSection("Camera Stiffness", nil)
        var1303:AddToggle({
            Title = "Smooth Camera",
            Default = tbl.flag72,
            Content = "DBD Trend Camera (Hanya Work Didalam Match.",
            Callback = function(arg353)
                tbl.flag72 = arg353
                if arg353 then
                    if not fn109(tbl.num115) then
                    end
                else
                    fn110()
                end
            end,
        })
        var1303:AddSlider({
            Title = "Stiffness",
            Content = "Lebih kecil = lebih smooth",
            Min = 1,
            Max = 10,
            Default = 5,
            Increment = 0.1,
            Callback = function(arg354)
                tbl.num115 = arg354
            end,
        })
        local var1304 = var1214:AddSection("Aspect Ratio", nil)
        var1304:AddToggle({
            Title = "Stretched Res",
            Default = tbl.flag73,
            Callback = function(arg355)
                tbl.flag73 = arg355
                if arg355 then
                    fn115()
                else
                    fn114()
                end
            end,
        })
        local var1305
        var1304:AddDropdown({
            Title = "Preset",
            Options = {"Normal 16:9", "4:3 Stretched", "16:10", "21:9 Ultrawide"},
            Default = "Normal 16:9",
            Callback = function(arg356)
                local tbl112 = {
                    ["Normal 16:9"] = 1.7777777777777777,
                    ["4:3 Stretched"] = 1.3333333333333333,
                    ["16:10"] = 1.6,
                    ["21:9 Ultrawide"] = 2.3333333333333335,
                }
                local var1306 = tbl112[arg356] or 1.7777777777777777
                tbl.num116 = var1306
                if var1305 then
                    pcall(function()
                        var1305:Set(var1306)
                    end)
                end
            end,
        })
        var1305 = var1304:AddSlider({
            Title = "Custom Ratio",
            Min = 0.8,
            Max = 2.5,
            Default = 1.7777777777777777,
            Increment = 0.01,
            Callback = function(arg357)
                tbl.num116 = arg357
            end,
        })
        local var1307 = var1214:AddSection("Force Cursor (PC Only)", nil)
        local var1308 = var1307:AddToggle({
            Title = "Force Mouse Cursor",
            Content = (function()
                if var30 and buffer then
                    local _bf = buffer.create(55)
                    local _by = {
                        70,
                        111,
                        114,
                        99,
                        101,
                        115,
                        32,
                        116,
                        104,
                        101,
                        32,
                        109,
                        111,
                        117,
                        115,
                        101,
                        32,
                        99,
                        117,
                        114,
                        115,
                        111,
                        114,
                        32,
                        116,
                        111,
                        32,
                        97,
                        108,
                        119,
                        97,
                        121,
                        115,
                        32,
                        97,
                        112,
                        112,
                        101,
                        97,
                        114,
                        32,
                        111,
                        110,
                        32,
                        116,
                        104,
                        101,
                        32,
                        115,
                        99,
                        114,
                        101,
                        101,
                        110,
                        46,
                    }
                    for _i = 1, #_by do
                        buffer.writeu8(_bf, _i - 1, _by[_i])
                    end
                    local _s = {}
                    for _i = 1, #_by do
                        _s[_i] = string.char(buffer.readu8(_bf, _i - 1))
                    end
                    return table.concat(_s)
                else
                    local _by = {
                        70,
                        111,
                        114,
                        99,
                        101,
                        115,
                        32,
                        116,
                        104,
                        101,
                        32,
                        109,
                        111,
                        117,
                        115,
                        101,
                        32,
                        99,
                        117,
                        114,
                        115,
                        111,
                        114,
                        32,
                        116,
                        111,
                        32,
                        97,
                        108,
                        119,
                        97,
                        121,
                        115,
                        32,
                        97,
                        112,
                        112,
                        101,
                        97,
                        114,
                        32,
                        111,
                        110,
                        32,
                        116,
                        104,
                        101,
                        32,
                        115,
                        99,
                        114,
                        101,
                        101,
                        110,
                        46,
                    }
                    local _s = {}
                    for _i = 1, #_by do
                        _s[_i] = string.char(_by[_i])
                    end
                    return table.concat(_s)
                end
            end)(),
            Default = false,
            Callback = function(arg358)
                tbl.flag98 = arg358
                if arg358 then
                    fn116()
                    fn2("Force Cursor", "Mouse cursor forced to appear!", 2)
                else
                    fn117()
                end
            end,
        })
        var1307:AddKeybind({
            Title = "Toggle Keybind",
            Default = Enum.KeyCode.Y,
            Callback = function()
                local var1309 = not tbl.flag98
                var1308:Set(var1309)
            end,
        })
        local var1310 = var1214:AddSection("Protect Name", nil)
        var1310:AddToggle({
            Title = "Enable Protect Name",
            Default = false,
            Callback = function(arg359)
                if arg359 then
                    var551()
                else
                    StopProtectName()
                end
            end,
        })
        local var1311 = var1214:AddSection("Skip Cutscene", nil)
        local flag62 = false
        local var1312, skipEndDarknessToggle
        var1312 = var1311:AddToggle({
            Title = "Skip End Screen",
            Default = false,
            Callback = function(arg360)
                if flag62 then
                    return
                end
                tbl.flag88 = arg360
                if arg360 then
                    flag62 = true
                    tbl.flag89 = false
                    if skipEndDarknessToggle then
                        skipEndDarknessToggle:Set(false)
                    end
                    flag62 = false
                    fn160()
                    fn154(false)
                else
                    fn160()
                end
            end,
        })
        skipEndDarknessToggle = var1311:AddToggle({
            Title = "Skip Loading & End Screen",
            Default = false,
            Callback = function(arg361)
                if flag62 then
                    return
                end
                tbl.flag89 = arg361
                if arg361 then
                    flag62 = true
                    tbl.flag88 = false
                    if var1312 then
                        var1312:Set(false)
                    end
                    flag62 = false
                    fn160()
                    fn154(true)
                else
                    fn160()
                end
            end,
        })
        local var1313 = var1214:AddSection("Avatar Copy (Visual)", nil)
        var1313:AddPresetManager({
            Title = "Profile Avatar By Username / ID",
            Placeholder = "Jandel / 1234...",
            Default = "",
            Presets = {
                Boy1 = "kiicaine",
                Boy2 = "444jamesss",
                Boy3 = "KiLouo14",
                Girl1 = "9kinb",
                Girl2 = "winterilous",
                Girl3 = "ellea_893",
            },
            Callback = function(arg362)
                currentAvatarInput = arg362
            end,
        })
        var1313:AddButton({
            Title = "Copy Avatar",
            Callback = function()
                if currentAvatarInput and currentAvatarInput ~= "" then
                    fn245(currentAvatarInput)
                else
                    fn2("BolongHub", (function()
                        if var30 and buffer then
                            local _bf = buffer.create(37)
                            local _by = {
                                77,
                                97,
                                115,
                                117,
                                107,
                                107,
                                97,
                                110,
                                32,
                                85,
                                115,
                                101,
                                114,
                                110,
                                97,
                                109,
                                101,
                                47,
                                73,
                                68,
                                32,
                                116,
                                101,
                                114,
                                108,
                                101,
                                98,
                                105,
                                104,
                                32,
                                100,
                                97,
                                104,
                                117,
                                108,
                                117,
                                33,
                            }
                            for _i = 1, #_by do
                                buffer.writeu8(_bf, _i - 1, _by[_i])
                            end
                            local _s = {}
                            for _i = 1, #_by do
                                _s[_i] = string.char(buffer.readu8(_bf, _i - 1))
                            end
                            return table.concat(_s)
                        else
                            local _by = {
                                77,
                                97,
                                115,
                                117,
                                107,
                                107,
                                97,
                                110,
                                32,
                                85,
                                115,
                                101,
                                114,
                                110,
                                97,
                                109,
                                101,
                                47,
                                73,
                                68,
                                32,
                                116,
                                101,
                                114,
                                108,
                                101,
                                98,
                                105,
                                104,
                                32,
                                100,
                                97,
                                104,
                                117,
                                108,
                                117,
                                33,
                            }
                            local _s = {}
                            for _i = 1, #_by do
                                _s[_i] = string.char(_by[_i])
                            end
                            return table.concat(_s)
                        end
                    end)(), 2)
                end
            end,
        })
        local var1314 = var1214:AddSection("Jerk Off (Fun)", nil)
        var1314:AddToggle({
            Title = "Enable Jerk Off",
            Default = false,
            Callback = function(arg363)
                if arg363 then
                    var1094()
                else
                    StopJerk()
                end
            end,
        })
        local var1315 = var1214:AddSection("Noclip & Fly", nil)
        var1315:AddToggle({
            Title = "Enable Noclip",
            Default = false,
            Callback = function(arg364)
                if arg364 then
                    var1100()
                else
                    StopNoclip()
                end
            end,
        })
        var1315:AddToggle({
            Title = "Fly GUI (V3)",
            Default = false,
            Callback = function(arg365)
                if arg365 then
                    var1106()
                else
                    StopFlyGui()
                end
            end,
        })
        local var1316 = var1214:AddSection("Hop Server / Respawn", nil)
        var1316:AddParagraph({
            Title = "Info",
            Content = "Hop: pindah ke server random.\nRejoin: masuk ulang ke server ini.\nRespawn: mati dan hidup kembali.",
        })
        var1316:AddButton({
            Title = "Hop Server",
            Callback = function()
                local var1317 = pcall(function()
                    game:GetService("TeleportService"):Teleport(game.PlaceId, localPlayer)
                end)
                fn2("Server", var1317 and "Teleporting ke server lain..." or "Gagal hop server", 2)
            end,
        })
        var1316:AddButton({
            Title = "Rejoin Server",
            Callback = function()
                local var1318 = pcall(function()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
                end)
                fn2("Server", var1318 and "Rejoin server..." or "Gagal rejoin server", 2)
            end,
        })
        var1316:AddButton({
            Title = "Respawn",
            Callback = function()
                local flag63 = false
                pcall(function()
                    local tbl113 = {
                        Respawn = true,
                        RequestRespawn = true,
                        Spawn = true,
                        SpawnCharacter = true,
                        RespawnCharacter = true,
                    }
                    local function fn355(obj)
                        if flag63 then
                            return
                        end
                        if tbl113[obj.Name] and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
                            pcall(function()
                                if obj:IsA("RemoteEvent") then
                                    obj:FireServer()
                                else
                                    obj:InvokeServer()
                                end
                            end)
                            flag63 = true
                        end
                    end
                    for _, v168 in ipairs({game:GetService("ReplicatedStorage"), workspace}) do
                        if flag63 then
                            break
                        end
                        for _, obj in ipairs(v168:GetChildren()) do
                            fn355(obj)
                            if flag63 then
                                break
                            end
                        end
                    end
                end)
                pcall(function()
                    local char = localPlayer.Character
                    local var1319 = char and char:FindFirstChildOfClass("Humanoid")
                    if var1319 then
                        var1319.Health = 0
                    end
                end)
                task.spawn(function()
                    local var1320 = os.clock()
                    while os.clock() - var1320 < 6 do
                        local char = localPlayer.Character
                        local var1321 = char and char:FindFirstChildOfClass("Humanoid")
                        if var1321 and var1321.Health > 0 then
                            fn2("Server", "Respawn berhasil", 2)
                            return
                        end
                        task.wait(0.5)
                    end
                    fn2("Server", "Karakter mati - game menolak respawn paksa, tunggu round berikutnya", 3)
                end)
            end,
        })
    end
    do
        local var1322 = var1215:AddSection("Configuration", true)
        var1322:AddConfig()
    end
end
fn354()
print("BOLONGHUB LOADED!")
