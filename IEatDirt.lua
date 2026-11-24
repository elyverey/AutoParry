local u, L, O = game:GetService'Players', game:GetService'ReplicatedStorage', game:GetService'RunService'
local Players = u
local UserInputService = game:GetService'UserInputService'
local _ = u.LocalPlayer

do
    local function d(aa)
        local ab = type(aa) == 'table' and rawget(aa, 'gethui')

        if type(ab) ~= 'function' or rawget(aa, 'bloxstrikehui') then
            return
        end

        local ac, ad = pcall(ab)

        if not (ac and (typeof(ad) == 'Instance' and ad:IsA'LayerCollector')) then
            return
        end

        rawset(aa, 'bloxstrikehui', true)
        rawset(aa, 'gethui', function()
            local ae = ab()

            if typeof(ae) == 'Instance' and ae:IsA'LayerCollector' then
                return ae.Parent or game:GetService'CoreGui'
            end

            return ae
        end)
    end

    pcall(d, getfenv and getfenv(1))
    pcall(d, getgenv and getgenv())
end

local aa = {
    unloaded = false,
    conns = {},
    cleanups = {},
}

do
    local ab = getgenv and getgenv() or _G

    if type(ab.bloxstrike) == 'table' and type(ab.bloxstrike.unload) == 'function' then
        pcall(ab.bloxstrike.unload)
    end
    if type(ab.__bloxstrikebloxUnload) == 'function' then
        pcall(ab.__bloxstrikebloxUnload)
    end

    function aa.connect(ac, ad)
        local ae, af = ac:Connect(ad), aa.conns

        af[#af + 1] = ae

        if #af % 200 == 0 then
            local ag = {}

            for ah, ai in ipairs(af)do
                if ai.Connected then
                    ag[#ag + 1] = ai
                end
            end

            aa.conns = ag
        end
        if aa.unloaded then
            ae:Disconnect()
        end

        return ae
    end
    function aa.onUnload(ac)
        aa.cleanups[#aa.cleanups + 1] = ac
    end
    function aa.unload()
        if aa.unloaded then
            return
        end

        aa.unloaded = true

        for ac, ad in ipairs(aa.conns)do
            pcall(function()
                ad:Disconnect()
            end)
        end

        aa.conns = {}

        for ac = #aa.cleanups, 1, -1 do
            pcall(aa.cleanups[ac])
        end

        aa.cleanups = {}

        if type(ab.bloxstrike) == 'table' and ab.bloxstrike.unload == aa.unload then
            ab.bloxstrike = nil
        end
    end

    ab.__bloxstrikebloxUnload = nil
    ab.bloxstrike = {
        unload = aa.unload,
    }
end

local ab = true

do
    local ac, ad = 'bloxstrikebloxHubHandle', {}

    pcall(function()
        ad[#ad + 1] = game:GetService'CoreGui'
    end)
    pcall(function()
        if gethui then
            ad[#ad + 1] = gethui()
        end
    end)

    for ae, af in ipairs(ad)do
        local ag = af:FindFirstChild(ac)

        if ag and ag:IsA'BindableFunction' then
            pcall(function()
                ag:Invoke()
            end)
            pcall(function()
                ag:Destroy()
            end)
        end
    end

    if setthreadidentity then
        pcall(setthreadidentity, 8)
    end

    local ae = Instance.new'BindableFunction'

    ae.Name = ac
    ae.OnInvoke = function()
        aa.unload()
    end
    ae.Parent = ad[1]

    aa.onUnload(function()
        pcall(function()
            ae:Destroy()
        end)
    end)
end
do
    local ac = {
        WindUI = true,
        ['WindUI/Notifications'] = true,
        ['WindUI/Dropdowns'] = true,
        ['WindUI/Tooltips'] = true,
        bloxstrikeNametags = true,
        bloxstrikebloxOverlay = true,
        bloxstrikebloxKeybinds = true,
        bloxstrikebloxBindPopup = true,
        bloxstrikebloxNametags = true,
        bloxstrikebloxSpectators = true,
    }

    local function E(ad)
        if not ad then
            return
        end

        for ae, af in ipairs(ad:GetChildren())do
            if ac[af.Name] then
                pcall(function()
                    af:Destroy()
                end)
            end
        end
    end

    pcall(function()
        E(gethui and gethui())
    end)
    pcall(function()
        E(game:GetService'CoreGui')
    end)
    pcall(function()
        E(_:FindFirstChildOfClass'PlayerGui')
    end)
end


local Chloex = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/RillBoys/bolong.catui/refs/heads/main/b0lngUi.lua"
))()

local ACCENT_COLOR = Color3.fromRGB(255, 255, 255)

task.wait()

if setthreadidentity then
    pcall(setthreadidentity, 8)
end


local VERSION = "v1.0.0"
local ACCENT_COLOR = Color3.fromRGB(255, 255, 255)

local Window = Chloex:Window({
    Title = "BOLONG HUB",
    Author = "Discord.gg/pWpgqVGxNK",
    Image = "84034353458936",
    Footer = "Bloxstrike",
    Color = ACCENT_COLOR,
    Version = 1,
    Search = true,
    Folder = "Bloxstrike"
})


Window:InfoTab({
    Name = "Info",
    Icon = "info",
    SectionTitle = "Information",
    Banner = "79662603577585",
    BannerAspectRatio = 16/5,
    Version = VERSION,
    DiscordLink = "https://discord.gg/pWpgqVGxNK",
    DiscordName = "Bloxstrike Community",
    DiscordText = "Join for updates & support.",
    DiscordDesc = "Bloxstrike — updates, support, and community information.",
    CardsWidget = {{catwidget = "rbxassetid://117486345000318"}}
})

-- Six main tabs, matching the supplied Chloex/Bolong framework.
local MovementTab = Window:AddTab({Name = "Movement", Icon = "footprints"})
local CombatTab = Window:AddTab({Name = "Combat", Icon = "swords"})
local BulletTab = Window:AddTab({Name = "Bullet", Icon = "crosshair"})
local VisualsTab = Window:AddTab({Name = "Visuals", Icon = "eye"})
local ConfigManagerTab = Window:AddTab({Name = "Configs", Icon = "folder"})

local ConfigSection = ConfigManagerTab:AddSection("Configuration", true)
ConfigSection:AddConfig()

local function resolveTab(title)
    local name = string.lower(tostring(title or ""))
    if name:find("movement", 1, true) then
        return MovementTab
    elseif name:find("visual", 1, true) or name == "world" then
        return VisualsTab
    elseif name:find("legit", 1, true) or name:find("rage", 1, true)
        or name:find("gun", 1, true) or name:find("combat", 1, true) then
        return CombatTab
    end
    return CombatTab
end

local function keyCodeFrom(value)
    if typeof(value) == "EnumItem" then return value end
    if type(value) == "string" and Enum.KeyCode[value] then
        return Enum.KeyCode[value]
    end
    return Enum.KeyCode.Unknown
end

local VirtualTab = {}
VirtualTab.__index = VirtualTab

function VirtualTab.new(realTab, title)
    return setmetatable({
        _realTab = realTab,
        _title = tostring(title or "General"),
        _items = nil,
    }, VirtualTab)
end

function VirtualTab:Section(cfg)
    cfg = cfg or {}
    self._title = tostring(cfg.Title or self._title or "General")
    self._items = nil
    return self
end

function VirtualTab:_getItems(title)
    if not self._items then
        self._items = self._realTab:AddSection(title or self._title or "General")
    end
    return self._items
end

function VirtualTab:Tab(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "General"
    -- Nested WindUI tabs (notably the skin categories) become sections
    -- inside their assigned Chloex parent tab, avoiding extra physical tabs.
    return VirtualTab.new(self._realTab, title)
end

function VirtualTab:Toggle(cfg)
    cfg = cfg or {}
    return self:_getItems(cfg.Title):AddToggle({
        Title = cfg.Title,
        Content = cfg.Content or "",
        Default = cfg.Value == true,
        Flag = cfg.Flag,
        Save = cfg.Save,
        Keybind = keyCodeFrom(cfg.Keybind),
        Callback = cfg.Callback,
    })
end

function VirtualTab:Slider(cfg)
    cfg = cfg or {}
    local range = type(cfg.Value) == "table" and cfg.Value or {}
    return self:_getItems(cfg.Title):AddSlider({
        Title = cfg.Title,
        Content = cfg.Content or "",
        Min = range.Min or cfg.Min or 0,
        Max = range.Max or cfg.Max or 100,
        Default = range.Default or cfg.Default or 0,
        Step = cfg.Step or cfg.Increment or 1,
        Flag = cfg.Flag,
        Save = cfg.Save,
        Callback = cfg.Callback,
    })
end

function VirtualTab:Dropdown(cfg)
    cfg = cfg or {}
    local value = cfg.Value
    local multi = cfg.Multi == true or (type(value) == "table")
    return self:_getItems(cfg.Title):AddDropdown({
        Title = cfg.Title,
        Content = cfg.Content or "",
        Options = cfg.Values or cfg.Options or {},
        Default = value,
        Multi = multi,
        Flag = cfg.Flag,
        Save = cfg.Save,
        Callback = cfg.Callback,
    })
end

function VirtualTab:Colorpicker(cfg)
    cfg = cfg or {}
    return self:_getItems(cfg.Title):AddColorPicker({
        Title = cfg.Title,
        Content = cfg.Content or "",
        Default = cfg.Default or Color3.new(1, 1, 1),
        Flag = cfg.Flag,
        Save = cfg.Save,
        Callback = cfg.Callback,
    })
end

function VirtualTab:Button(cfg)
    cfg = cfg or {}
    return self:_getItems(cfg.Title):AddButton({
        Title = cfg.Title,
        Content = cfg.Content or "",
        Callback = cfg.Callback,
    })
end

function VirtualTab:Input(cfg)
    cfg = cfg or {}
    return self:_getItems(cfg.Title):AddInput({
        Title = cfg.Title,
        Content = cfg.Content or "",
        Default = cfg.Value or cfg.Default or "",
        Placeholder = cfg.Placeholder or "Input Here",
        Flag = cfg.Flag,
        Save = cfg.Save,
        Callback = cfg.Callback,
    })
end

function VirtualTab:Keybind(cfg)
    cfg = cfg or {}
    return self:_getItems(cfg.Title):AddKeybind({
        Title = cfg.Title,
        Content = cfg.Content or "",
        Default = keyCodeFrom(cfg.Value),
        Flag = cfg.Flag,
        Save = cfg.Save,
        Callback = function(key)
            if not cfg.Callback then return end
            if typeof(key) == "EnumItem" then
                cfg.Callback(key.Name)
            else
                cfg.Callback(tostring(key))
            end
        end,
    })
end

local LegacyWindow = {}
LegacyWindow.__index = LegacyWindow

function LegacyWindow:Tab(cfg)
    cfg = cfg or {}
    local title = cfg.Title or cfg.Name or "Main"
    return VirtualTab.new(resolveTab(title), title)
end

function LegacyWindow:Section(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Misc"
    local tab = VirtualTab.new(resolveTab(title), title)
    tab:Section(cfg)
    return tab
end

function LegacyWindow:OnDestroy(callback)
    if type(callback) == "function" then
        aa.onUnload(callback)
    end
end

function LegacyWindow:SetPanelBackground() end
function LegacyWindow:IsResizable() end
function LegacyWindow:SetToggleKey(key)
    pcall(function()
        Window.WindowKeybind = key
        if Window.SetToggleKey then Window:SetToggleKey(key) end
    end)
end

function LegacyWindow:Dialog(cfg)
    cfg = cfg or {}
    local buttons = cfg.Buttons or {}
    local first = buttons[1]
    Chloex:MakeNotify({
        Title = cfg.Title or "bloxstrike",
        Description = cfg.Content or "",
        Content = first and first.Title or " ",
        Delay = 6,
    })
end

local ad = setmetatable({
    Closed = false,
    Destroyed = false,
    UIElements = {},
}, LegacyWindow)

local bulletTab = VirtualTab.new(BulletTab, "Bullet")

-- Small compatibility surface for legacy notifications and the keybind HUD.
local ac = {}

function ac:Notify(cfg)
    cfg = cfg or {}
    Chloex:MakeNotify({
        Title = cfg.Title or "bloxstrike",
        Description = cfg.Content or cfg.Description or "",
        Content = "",
        Delay = cfg.Duration or 3,
    })
end

function ac:Panel(cfg)
    cfg = cfg or {}
    local parent = (gethui and gethui()) or game:GetService("CoreGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = cfg.Name or "bloxstrikebloxLegacyPanel"
    gui.ResetOnSpawn = false
    gui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Name = "Frame"
    frame.Size = cfg.Size or UDim2.fromOffset(160, 80)
    frame.Position = cfg.Position or UDim2.fromOffset(16, 100)
    frame.AnchorPoint = cfg.AnchorPoint or Vector2.zero
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    frame.BackgroundTransparency = 0.08
    frame.BorderSizePixel = 0
    frame.Visible = cfg.Visible == true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(8, 4)
    title.Size = UDim2.new(1, -16, 0, 20)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextColor3 = cfg.TitleColor or Color3.new(1, 1, 1)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = cfg.Title or ""
    title.Parent = frame

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Position = UDim2.fromOffset(6, 26)
    content.Size = UDim2.new(1, -12, 1, -32)
    content.Parent = frame

    local panel = {Frame = frame, Content = content, Title = title}
    function panel:SetVisible(value) frame.Visible = value == true end
    function panel:Destroy() gui:Destroy() end
    return panel
end

-- Legacy helper widgets use this ScreenGui as their parent instead of WindUI internals.
local compatGui = Instance.new("ScreenGui")
compatGui.Name = "bloxstrikebloxChloexCompat"
compatGui.ResetOnSpawn = false
compatGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
local compatMain = Instance.new("Frame")
compatMain.Name = "Main"
compatMain.Size = UDim2.fromScale(1, 1)
compatMain.BackgroundTransparency = 1
compatMain.Parent = compatGui
local compatMainBar = Instance.new("Frame")
compatMainBar.Name = "MainBar"
compatMainBar.Size = UDim2.fromScale(1, 0)
compatMainBar.BackgroundTransparency = 1
compatMainBar.Parent = compatMain
ad.UIElements = {Main = compatMain, MainBar = compatMainBar}
aa.onUnload(function()
    pcall(function() compatGui:Destroy() end)
end)

local ae = nil
local af, ag, ah, ai, aj = nil, "bloxstrikeblox", nil, nil, nil
local ak


(function()
    local al, am, an, ao, ap, aq, ar, as, at, au, av, aw = game:GetService'UserInputService', game:GetService'TweenService', game:GetService'TextService', game:GetService'HttpService', Color3.fromRGB(255, 255, 255), {}, {}, {}, {}, nil, nil, {}

    local function a(ax)
        if ax.UserInputType == Enum.UserInputType.Keyboard then
            if ax.KeyCode == Enum.KeyCode.Unknown then
                return nil
            end

            return ax.KeyCode.Name
        elseif ax.UserInputType == Enum.UserInputType.MouseButton1 then
            return 'MouseLeft'
        elseif ax.UserInputType == Enum.UserInputType.MouseButton2 then
            return 'MouseRight'
        elseif ax.UserInputType == Enum.UserInputType.MouseButton3 then
            return 'MouseMiddle'
        end

        return nil
    end

    local ax = ac:Panel{
        Name = 'bloxstrikebloxKeybinds',
        Title = 'keybinds',
        TitleColor = ap,
        OutlineThickness = 5,
        Size = UDim2.fromOffset(160, 80),
        Position = UDim2.new(0, 16, 0.5, -80),
        AnchorPoint = Vector2.new(0, 0),
        Visible = false,
    }

    do
        local ay = 'bloxstrike/bloxstrike/keybinds_position.json'

        pcall(function()
            if not (isfile and isfile(ay)) then
                return
            end

            local az = ao:JSONDecode(readfile(ay))

            if type(az) ~= 'table' or not (tonumber(az.xs) and (tonumber(az.xo) and (tonumber(az.ys) and tonumber(az.yo)))) then
                return
            end

            local aA = workspace.CurrentCamera.ViewportSize
            local aB, aC = math.clamp(az.xs * aA.X + az.xo, 0, math.max(0, aA.X - 60)), math.clamp(az.ys * aA.Y + az.yo, 0, math.max(0, aA.Y - 40))

            ax.Frame.Position = UDim2.fromOffset(aB, aC)
        end)

        local az = 0

        aa.connect(ax.Frame:GetPropertyChangedSignal'Position', function()
            az = az + 1

            local aA = az

            task.delay(0.4, function()
                if aA ~= az or not writefile then
                    return
                end

                local aB = ax.Frame.Position

                pcall(function()
                    if isfolder and (makefolder and not isfolder'bloxstrike/bloxstrike') then
                        if not isfolder'bloxstrike' then
                            makefolder'bloxstrike'
                        end

                        makefolder'bloxstrike/bloxstrike'
                    end

                    writefile(ay, ao:JSONEncode{
                        xs = aB.X.Scale,
                        xo = aB.X.Offset,
                        ys = aB.Y.Scale,
                        yo = aB.Y.Offset,
                    })
                end)
            end)
        end)
    end

    aa.onUnload(function()
        if au then
            pcall(function()
                au:Destroy()
            end)
        end

        pcall(function()
            ax:Destroy()
        end)
    end)

    local ay = Instance.new'UIListLayout'

    ay.Padding = UDim.new(0, 4)
    ay.SortOrder = Enum.SortOrder.LayoutOrder
    ay.Parent = ax.Content

    local az = Instance.new'UIPadding'

    az.PaddingTop = UDim.new(0, 6)
    az.Parent = ax.Content

    local function e(aA, aB, aC)
        return (an:GetTextSize(aA, aB, aC, Vector2.new(1000, 100))).X
    end

    local aA = {}

    local function o(aB)
        if aA[aB] then
            return aA[aB]
        end

        local aC = Instance.new'Frame'

        aC.Size = UDim2.new(1, 0, 0, 18)
        aC.BackgroundTransparency = 1
        aC.LayoutOrder = aB
        aC.Parent = ax.Content

        local aD = Instance.new'TextLabel'

        aD.Size = UDim2.new(1, -56, 1, 0)
        aD.BackgroundTransparency = 1
        aD.Font = Enum.Font.GothamBold
        aD.TextSize = 14
        aD.TextColor3 = ap
        aD.TextXAlignment = Enum.TextXAlignment.Left
        aD.Parent = aC

        local aE = Instance.new'TextLabel'

        aE.Size = UDim2.new(0, 56, 1, 0)
        aE.Position = UDim2.new(1, -56, 0, 0)
        aE.BackgroundTransparency = 1
        aE.Font = Enum.Font.GothamBold
        aE.TextSize = 14
        aE.TextColor3 = ap
        aE.TextXAlignment = Enum.TextXAlignment.Right
        aE.Parent = aC
        aA[aB] = {
            row = aC,
            label = aD,
            key = aE,
        }

        return aA[aB]
    end
    local function n()
        local aB = {}

        for aC, aD in ipairs(as)do
            local aE, aF = aq[aD], ar[aD]

            if aE and aF then
                local aG

                if aE.mode == 'Always' then
                    aG = true
                elseif aE.mode == 'Hold' then
                    aG = at[aD] == true
                else
                    aG = aF.isActive and aF.isActive() or false
                end
                if aG then
                    aB[#aB + 1] = {
                        name = (tostring(aF.title or aD)):lower(),
                        key = (aE.mode == 'Always' and 'on' or tostring(aE.key)):lower(),
                    }
                end
            end
        end

        return aB
    end
    local function G()
        return ax.Frame:FindFirstChildOfClass'UIStroke'
    end

    local aB, aC, aD = false, 0, {}

    local function Y()
        for aE, aF in ipairs(aD)do
            pcall(function()
                aF:Cancel()
            end)
        end

        aD = {}
    end
    local function H(aE, aF, aG, aH, aI)
        if not aE then
            return nil
        end

        local aJ = am:Create(aE, TweenInfo.new(aF, aH or Enum.EasingStyle.Quint, aI or Enum.EasingDirection.Out), aG)

        aD[#aD + 1] = aJ

        aJ:Play()

        return aJ
    end
    local function i()
        ax.Frame.BackgroundTransparency = 0.1

        local aE = G()

        if aE then
            aE.Transparency = 0
        end
        if ax.Title then
            ax.Title.TextTransparency = 0
        end
    end
    local function B()
        local aE = ab ~= false and n() or {}

        if #aE == 0 then
            if aB then
                aB = false
                aC = aC + 1

                local aF = aC

                Y()

                for aG = 1, #aA, 1 do
                    aA[aG].row.Visible = false
                end

                if ax.Title then
                    H(ax.Title, 0.12, {TextTransparency = 1})
                end

                H(ax.Frame, 0.22, {BackgroundTransparency = 1})

                local aG = G()

                if aG then
                    H(aG, 0.22, {Transparency = 1})
                end

                local aH = H(ax.Frame, 0.28, {
                    Size = UDim2.fromOffset(0, 0),
                }, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)

                if aH then
                    aH.Completed:Once(function()
                        if aF == aC then
                            ax:SetVisible(false)
                        end
                    end)
                else
                    ax:SetVisible(false)
                end
            end

            return
        end

        for aF = 1, #aA, 1 do
            aA[aF].row.Visible = false
        end

        local aF = e('Keybinds', 16, Enum.Font.GothamBold)

        for aG, aH in ipairs(aE)do
            local aI = o(aG)

            aI.row.Visible = true
            aI.label.Text = aH.name
            aI.label.TextColor3 = ap
            aI.key.Text = '[' .. (aH.key .. ']')
            aI.key.TextColor3 = ap
            aF = math.max(aF, (e(aH.name, 14, Enum.Font.GothamBold) + 20) + e('[' .. (aH.key .. ']'), 14, Enum.Font.GothamBold))
        end

        local aG, aH = math.clamp(aF + 28, 130, 340), (34 + #aE * 22) + 8

        aC = aC + 1

        Y()

        if not aB then
            aB = true

            ax:SetVisible(true)
            i()

            ax.Frame.Size = UDim2.fromOffset(aG, 0)
        else
            i()
        end

        H(ax.Frame, 0.2, {
            Size = UDim2.fromOffset(aG, aH),
        })
    end
    local function s(aE)
        pcall(function()
            local aF = af or ae

            if not aF then
                return
            end

            aF:Set('bloxstrikeBinds', ao:JSONEncode(aq))

            if aE ~= false then
                aF:Save()
            end
        end)
    end
    local function g(aE, aF, aG)
        aq[aE] = {
            key = aF,
            mode = aG,
        }

        local aH = ar[aE]

        if aH and (aG == 'Always' and aH.kind == 'toggle') then
            aH.setState(true)
        end

        s()
        B()
    end
    local function f(aE)
        aq[aE] = nil
        at[aE] = nil

        s()
        B()
    end

    local aE, aF, aG = nil, false, nil

    local function U()
        if aG and aG.Parent then
            return aG
        end
        if setthreadidentity then
            pcall(setthreadidentity, 8)
        end

        aG = Instance.new'ScreenGui'
        aG.Name = 'bloxstrikebloxBindPopup'
        aG.IgnoreGuiInset = true
        aG.ResetOnSpawn = false
        aG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        aG.DisplayOrder = 2147483025
        aG.Parent = gethui and gethui() or game:GetService'CoreGui'

        return aG
    end

    aa.onUnload(function()
        if aG then
            pcall(function()
                aG:Destroy()
            end)
        end
    end)

    local aH = game:GetService'GuiService'

    local function m()
        return al:GetMouseLocation() - aH:GetGuiInset()
    end
    local function j(aI, aJ)
        if not (aI and (aI.Parent and aI.Visible)) then
            return false
        end

        local aK, aL = aI.AbsolutePosition, aI.AbsoluteSize

        return aJ.X >= aK.X and (aJ.X <= aK.X + aL.X and (aJ.Y >= aK.Y and aJ.Y <= aK.Y + aL.Y))
    end

    local aI = ac.Creator
    local aJ = aI and aI.Font or 'rbxassetid://12187365364'

    local function F(aK, aL)
        local aM, aN = pcall(function()
            return aI.GetThemeProperty(aK, ac.Theme)
        end)

        if aM then
            if typeof(aN) == 'Color3' then
                return aN
            end
            if type(aN) == 'table' and typeof(aN.Color) == 'ColorSequence' then
                return aN.Color.Keypoints[1].Value, aN
            end
        end

        return aL
    end
    local function t(aK)
        local aL, aM = pcall(function()
            return aI.Icon'chevron-down'
        end)

        if not (aL and (type(aM) == 'table' and aM[1])) then
            return nil
        end

        local aN = Instance.new'ImageLabel'

        aN.BackgroundTransparency = 1
        aN.Image = aM[1]
        aN.ImageRectSize = aM[2].ImageRectSize
        aN.ImageRectOffset = aM[2].ImageRectPosition
        aN.Size = UDim2.fromOffset(14, 14)
        aN.AnchorPoint = Vector2.new(1, 0.5)
        aN.Position = UDim2.new(1, -7, 0.5, 0)
        aN.Parent = aK

        return aN
    end

    local aK, aL, aM, aN, aO = 158, 36, 5, 26, 64
    local aP, aQ = (aK - aO) - aM * 3, {
        'Hold',
        'Toggle',
    }

    local function zT(aR)
        if au then
            pcall(function()
                au:Destroy()
            end)

            au = nil
        end
        if aE then
            aE:Disconnect()

            aE = nil
        end

        aF = false

        local aS = ar[aR]
        local aU = aS and aS.frame

        if typeof(aU) ~= 'Instance' then
            return
        end

        local aV, aW, aX, aY = F('Text', ap), F('Placeholder', Color3.fromRGB(160, 160, 170)), F('Primary', Color3.fromRGB(129, 140, 248)), F('ElementBackground', Color3.fromRGB(30, 30, 38))
        local aZ, a_, a0 = F('ElementBackgroundHover', aY:Lerp(ap, 0.06)), F('Background', Color3.fromRGB(16, 16, 20))

        local function c(a1, a2)
            local a3 = Instance.new'UICorner'

            a3.CornerRadius = UDim.new(0, a2)
            a3.Parent = a1
        end
        local function Q(a1, a2, a3, a4)
            local a5 = Instance.new'UIStroke'

            a5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            a5.Color, a5.Transparency, a5.Thickness = a2, a3, a4 or 1
            a5.Parent = a1

            return a5
        end
        local function b(a1)
            a1.BackgroundColor3 = a_
            a1.BackgroundTransparency = 0.02

            if a0 then
                local a2 = Instance.new'UIGradient'

                a2.Color = a0.Color
                a2.Rotation = tonumber(a0.Rotation) or 90
                a2.Parent = a1
            end
        end
        local function T(a1, a2, a3)
            local a4 = Instance.new'TextLabel'

            a4.BackgroundTransparency = 1
            a4.FontFace = Font.new(aJ, a3 or Enum.FontWeight.SemiBold)
            a4.TextSize = 14
            a4.TextColor3 = aV
            a4.Text = a2
            a4.TextTruncate = Enum.TextTruncate.AtEnd
            a4.Parent = a1

            return a4
        end
        local function w(a1, a2, a3)
            local a4 = Instance.new'TextButton'

            a4.AutoButtonColor = false
            a4.Text = ''
            a4.BorderSizePixel = 0
            a4.BackgroundColor3 = aY
            a4.Position = UDim2.fromOffset(a2, aM)
            a4.Size = UDim2.fromOffset(a3, aN)
            a4.Parent = a1

            c(a4, 8)
            aa.connect(a4.MouseEnter, function()
                a4.BackgroundColor3 = aZ
            end)
            aa.connect(a4.MouseLeave, function()
                a4.BackgroundColor3 = aY
            end)

            return a4
        end

        local a1 = Instance.new'Frame'

        a1.Name = 'Popup'
        a1.Size = UDim2.fromOffset(aK, aL)
        a1.BorderSizePixel = 0
        a1.Active = true

        b(a1)
        c(a1, 11)
        Q(a1, aX, 0.55, 1.2)

        local a2 = (aq[aR] and aq[aR].mode == 'Hold') and 'Hold' or 'Toggle'

        local function Z()
            local a3 = aq[aR]

            if not a3 then
                return 'none'
            end
            if a3.mode == 'Always' then
                return 'always'
            end

            return (tostring(a3.key)):lower()
        end

        local a3 = w(a1, aM, aO)
        local a4, a5 = Q(a3, aX, 1, 1.4), T(a3, Z())

        a5.Size = UDim2.fromScale(1, 1)

        local function J()
            a5.Text = Z()
            a5.TextColor3 = aq[aR] and aV or aW
        end

        J()

        local a6 = w(a1, aM * 2 + aO, aP)
        local a7 = T(a6, a2:lower())

        a7.TextXAlignment = Enum.TextXAlignment.Left
        a7.Position = UDim2.fromOffset(9, 0)
        a7.Size = UDim2.new(1, -30, 1, 0)

        local a8 = t(a6)

        if a8 then
            a8.ImageColor3 = aV
        end

        local a9, ba = 24, Instance.new'Frame'

        ba.Position = UDim2.fromOffset(aM * 2 + aO, aL + 4)
        ba.Size = UDim2.fromOffset(aP, (#aQ * a9 + (#aQ - 1) * 2) + 8)
        ba.BorderSizePixel = 0
        ba.Visible = false
        ba.Active = true
        ba.Parent = a1

        b(ba)
        c(ba, 10)
        Q(ba, aX, 0.55, 1.2)

        local bb = {}

        local function s()
            for bc, bd in pairs(bb)do
                local be = bc == a2

                bd.btn.BackgroundColor3 = be and aX or aZ
                bd.btn.BackgroundTransparency = be and 0.8 or bd.hot and 0.4 or 1
                bd.lbl.TextTransparency = be and 0 or 0.4
            end
        end

        for bc, bd in ipairs(aQ)do
            local be = Instance.new'TextButton'

            be.AutoButtonColor = false
            be.Text = ''
            be.BorderSizePixel = 0
            be.Position = UDim2.fromOffset(4, 4 + (bc - 1) * (a9 + 2))
            be.Size = UDim2.new(1, -8, 0, a9)
            be.Parent = ba

            c(be, 7)

            local bf = T(be, bd:lower(), Enum.FontWeight.Medium)

            bf.TextXAlignment = Enum.TextXAlignment.Left
            bf.Position = UDim2.fromOffset(8, 0)
            bf.Size = UDim2.new(1, -8, 1, 0)

            local bg = {
                btn = be,
                lbl = bf,
                hot = false,
            }

            bb[bd] = bg

            aa.connect(be.MouseEnter, function()
                bg.hot = true

                s()
            end)
            aa.connect(be.MouseLeave, function()
                bg.hot = false

                s()
            end)
            aa.connect(be.MouseButton1Click, function()
                a2 = bd
                a7.Text = bd:lower()
                ba.Visible = false

                if a8 then
                    a8.Rotation = 0
                end

                s()

                local bh = aq[aR]

                if bh and (bh.mode ~= bd and bh.key ~= 'ON') then
                    g(aR, bh.key, bd)
                end
            end)
        end

        s()
        aa.connect(a6.MouseButton1Click, function()
            ba.Visible = not ba.Visible

            if a8 then
                a8.Rotation = ba.Visible and 180 or 0
            end
        end)

        local bc, bd

        local function k()
            aF = false

            if aE then
                aE:Disconnect()

                aE = nil
            end

            a4.Transparency = 1
        end
        local function zT()
            k()

            if bc then
                bc:Disconnect()

                bc = nil
            end
            if bd then
                bd:Disconnect()

                bd = nil
            end
            if au == a1 then
                au = nil
            end

            pcall(function()
                a1:Destroy()
            end)
        end

        aa.connect(a3.MouseButton1Click, function()
            if aF then
                k()
                J()

                return
            end

            ba.Visible = false

            if a8 then
                a8.Rotation = 0
            end

            aF = true
            a5.Text = '...'
            a5.TextColor3 = aV
            a4.Transparency = 0.1

            if aE then
                aE:Disconnect()
            end

            aE = aa.connect(al.InputBegan, function(be)
                local bf = be.UserInputType

                if bf == Enum.UserInputType.Keyboard then
                    if be.KeyCode == Enum.KeyCode.Escape or be.KeyCode == Enum.KeyCode.Backspace then
                        f(aR)
                    else
                        local bg = a(be)

                        if not bg then
                            return
                        end

                        g(aR, bg, a2)
                    end
                elseif bf == Enum.UserInputType.MouseButton2 or bf == Enum.UserInputType.MouseButton3 then
                    g(aR, a(be), a2)
                else
                    return
                end

                k()
                J()
            end)
        end)

        local be = U()

        a1.Parent = be
        au = a1

        local function RT()
            if not (aU.Parent and a1.Parent) then
                zT()

                return
            end

            local bf, bg, bh, bi = be.AbsolutePosition, be.AbsoluteSize, aU.AbsolutePosition, aU.AbsoluteSize
            local bj = (bh.X + bi.X) + 8

            if bj + aK > (bf.X + bg.X) - 4 then
                bj = (bh.X - aK) - 8
            end

            local bk = bh.Y + (bi.Y - aL) / 2

            a1.Position = UDim2.fromOffset(bj - bf.X, bk - bf.Y)
        end

        RT()

        bc = aa.connect(O.RenderStepped, RT)
        bd = aa.connect(al.InputBegan, function(bf)
            if au ~= a1 then
                zT()

                return
            end

            local bg = bf.UserInputType

            if bg ~= Enum.UserInputType.MouseButton1 and bg ~= Enum.UserInputType.MouseButton2 then
                return
            end
            if aF and bg == Enum.UserInputType.MouseButton2 then
                return
            end

            local bh = m()

            if not j(a1, bh) and not j(ba, bh) then
                zT()
            end
        end)
    end

    aa.connect(al.InputBegan, function(aR)
        if aR.UserInputType == Enum.UserInputType.MouseButton3 and (av and not aF) then
            zT(av)
        end
    end)
    aa.connect(al.InputBegan, function(aR, aS)
        if aF or al:GetFocusedTextBox() then
            return
        end
        if aS and aR.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end

        local aU = a(aR)

        if not aU then
            return
        end

        for aV, aW in pairs(aq)do
            if aW.key == aU and aW.mode ~= 'Always' then
                local aX = ar[aV]

                if aX then
                    if aW.mode == 'Toggle' then
                        if aX.kind == 'toggle' then
                            aX.setState(not aX.isActive())
                        else
                            aX.fire()
                        end

                        B()
                    elseif aW.mode == 'Hold' then
                        at[aV] = true

                        if aX.kind == 'toggle' then
                            aX.setState(true)
                        else
                            aX.fire()
                        end

                        B()
                    end
                end
            end
        end
    end)
    aa.connect(al.InputEnded, function(aR)
        local aS = a(aR)

        if not aS then
            return
        end

        for aU, aV in pairs(aq)do
            if aV.key == aS and (aV.mode == 'Hold' and at[aU]) then
                at[aU] = false

                local aW = ar[aU]

                if aW and aW.kind == 'toggle' then
                    aW.setState(false)
                end

                B()
            end
        end
    end)

    local aR = 0

    aa.connect(O.RenderStepped, function()
        if au and (ad.Closed or ad.Destroyed) then
            if aE then
                aE:Disconnect()

                aE = nil
            end

            pcall(function()
                au:Destroy()
            end)

            au = nil
        end

        for aS, aU in pairs(aq)do
            local aV = ar[aS]

            if aV then
                if aU.mode == 'Always' then
                    if aV.kind == 'toggle' then
                        if aV.isActive and not aV.isActive() then
                            aV.setState(true)
                        end
                    elseif aV.fire then
                        aV.fire()
                    end
                elseif aU.mode == 'Hold' and (at[aS] and (aV.kind == 'button' and aV.fire)) then
                    aV.fire()
                end
            end
        end

        if os.clock() - aR >= 0.3 then
            aR = os.clock()

            B()
        end
    end)

    ak = {}

    function ak.register(aS, aU, aV)
        if type(aU) == 'table' then
            if aV.auto then
                aU.__zbAuto = aS
            elseif aU.__zbAuto and aU.__zbAuto ~= aS then
                local aW = aU.__zbAuto

                aw[aW] = aS
                ar[aW] = nil

                for aX = #as, 1, -1 do
                    if as[aX] == aW then
                        table.remove(as, aX)
                    end
                end
            end
        end

        ar[aS] = {
            frame = aU and aU.ElementFrame,
            kind = aV.kind,
            setState = aV.setState,
            isActive = aV.isActive,
            fire = aV.fire,
            title = aV.title or aS,
        }
        as[#as + 1] = aS

        if aU and aU.ElementFrame then
            local aW = aU.ElementFrame

            aa.connect(aW.MouseEnter, function()
                av = aw[aS] or aS
            end)
            aa.connect(aW.MouseLeave, function()
                if av == aS or av == aw[aS] then
                    av = nil
                end
            end)
        end
    end
    function ak.loadBinds()
        local aS = {}

        pcall(function()
            local aU = af or ae

            if aU then
                local aV = aU:Get'bloxstrikeBinds'

                if aV and aV ~= '' then
                    local aW = ao:JSONDecode(aV)

                    if type(aW) == 'table' then
                        aS = aW
                    end
                end
            end
        end)

        aq = aS

        table.clear(at)

        for aU, aV in pairs(aq)do
            if aV.mode == 'Always' then
                local aW = ar[aU]

                if aW and (aW.kind == 'toggle' and aW.setState) then
                    aW.setState(true)
                end
            end
        end

        B()
    end
    function ak.refresh()
        B()
    end
    function ak.saveBinds(aS)
        s(aS)
    end
end)()

do
    local al, am, an, ao, ap, aq, ar, as = game:GetService'UserInputService', game:GetService'TextService', game:GetService'HttpService', {
        'Toggle',
        'Slider',
        'Dropdown',
        'Colorpicker',
        'Input',
        'Button',
        'Keybind',
        'Section',
        'Paragraph',
        'Divider',
        'Space',
        'Code',
        'Image',
    }, {
        Toggle = true,
        Slider = true,
        Dropdown = true,
        Colorpicker = true,
        Input = true,
        Button = true,
        Keybind = true,
    }, {
        Toggle = 1,
        Button = 1,
        Slider = 1.5,
        Dropdown = 1.2,
        Colorpicker = 1,
        Input = 1.2,
        Keybind = 1,
        Section = 1,
        Paragraph = 2,
    }, 440, ad.UIElements and ad.UIElements.Main
    local at, au = as and as:FindFirstAncestorOfClass'ScreenGui', Instance.new'Frame'

    au.Name = 'bloxstrikebloxTip'
    au.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
    au.BackgroundTransparency = 0.04
    au.BorderSizePixel = 0
    au.Visible = false
    au.ZIndex = 100000
    au.Parent = at;
    (Instance.new('UICorner', au)).CornerRadius = UDim.new(0, 6)

    local av = Instance.new('UIStroke', au)

    av.Color = Color3.new(1, 1, 1)
    av.Transparency = 0.8

    local aw = Instance.new'TextLabel'

    aw.BackgroundTransparency = 1
    aw.Position = UDim2.fromOffset(8, 6)
    aw.Font = Enum.Font.GothamMedium
    aw.TextSize = 13
    aw.TextColor3 = Color3.fromRGB(230, 230, 235)
    aw.TextWrapped = true
    aw.TextXAlignment = Enum.TextXAlignment.Left
    aw.TextYAlignment = Enum.TextYAlignment.Top
    aw.ZIndex = 100001
    aw.Parent = au

    aa.onUnload(function()
        au:Destroy()
    end)

    local ax

    local function Q(ay, az)
        ax = ay

        local aA = am:GetTextSize(az, 13, Enum.Font.GothamMedium, Vector2.new(260, 1000))

        aw.Text = az
        aw.Size = UDim2.fromOffset(aA.X + 2, aA.Y + 2)
        au.Size = UDim2.fromOffset(aA.X + 18, aA.Y + 14)
        au.Visible = true
    end
    local function b(ay)
        if ax == ay then
            ax = nil
            au.Visible = false
        end
    end

    aa.connect(O.RenderStepped, function()
        if not au.Visible then
            return
        end
        if not (ax and ax:IsDescendantOf(game)) or ad.Closed then
            ax, au.Visible = nil, false

            return
        end

        local ay, az, aA, aB = al:GetMouseLocation(), at and at.AbsolutePosition or Vector2.new(0, 0), (at and at.IgnoreGuiInset) and Vector2.new(0, 0) or (game:GetService'GuiService'):GetGuiInset(), workspace.CurrentCamera.ViewportSize
        local aC, aD = math.min(ay.X + 14, (aB.X - au.AbsoluteSize.X) - 4), math.min(ay.Y + 16, (aB.Y - au.AbsoluteSize.Y) - 4)

        au.Position = UDim2.fromOffset((aC - az.X) - aA.X, (aD - az.Y) - aA.Y)
    end)

    local function a(ay, az)
        local aA = ay:FindFirstChild('TitleFrame', true)
        local aB = aA and aA:FindFirstChild'TitleFrame'
        local aC = aB and aB:FindFirstChildOfClass'TextLabel'

        if not aC then
            return false
        end

        local aD = Instance.new'UIPadding'

        aD.PaddingLeft = UDim.new(0, 22)
        aD.Parent = aC

        local aE = Instance.new'TextLabel'

        aE.Name = 'Info'
        aE.Size = UDim2.fromOffset(15, 15)
        aE.Position = UDim2.fromOffset(-22, 1)
        aE.BackgroundTransparency = 1
        aE.Font = Enum.Font.GothamBold
        aE.TextSize = 11
        aE.Text = 'i'
        aE.TextColor3 = aC.TextColor3
        aE.TextTransparency = 0.25
        aE.Active = true
        aE.ZIndex = aC.ZIndex + 1
        aE.Parent = aC;
        (Instance.new('UICorner', aE)).CornerRadius = UDim.new(1, 0)

        local aF = Instance.new('UIStroke', aE)

        aF.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        aF.Thickness = 1.2
        aF.Color = aC.TextColor3
        aF.Transparency = 0.45

        aa.connect(aC:GetPropertyChangedSignal'TextColor3', function()
            aE.TextColor3, aF.Color = aC.TextColor3, aC.TextColor3
        end)
        aa.connect(aE.MouseEnter, function()
            aE.TextTransparency, aF.Transparency = 0, 0.1

            Q(aE, az)
        end)
        aa.connect(aE.MouseLeave, function()
            aE.TextTransparency, aF.Transparency = 0.25, 0.45

            b(aE)
        end)

        return true
    end

    local ay = {}

    function ak.shapeTab(az, aA)
        if type(az) ~= 'table' or ay[az] then
            return az
        end

        local aB = {
            col = 1,
            weight = {0, 0},
        }

        ay[az] = aB

        local function M()
            if aB.cols then
                return aB.cols
            end

            local aC = az.UIElements and az.UIElements.ContainerFrame

            if not aC then
                return nil
            end

            local aD = aC:FindFirstChildOfClass'UIListLayout'

            if not aD then
                return nil
            end

            local aE, aF = aD.Padding, Instance.new'Frame'

            aF.Name = 'ZbColumns'
            aF.BackgroundTransparency = 1
            aF.Size = UDim2.new(1, 0, 0, 0)
            aF.AutomaticSize = Enum.AutomaticSize.Y
            aF.LayoutOrder = -1
            aF.Parent = aC

            local aG = Instance.new'UIListLayout'

            aG.FillDirection = Enum.FillDirection.Horizontal
            aG.SortOrder = Enum.SortOrder.LayoutOrder
            aG.Padding = UDim.new(0, 10)
            aG.Parent = aF

            local aH = {}

            for aI = 1, 2, 1 do
                local aJ = Instance.new'Frame'

                aJ.Name = 'Column' .. aI
                aJ.BackgroundTransparency = 1
                aJ.AutomaticSize = Enum.AutomaticSize.Y
                aJ.LayoutOrder = aI
                aJ.Parent = aF

                local aK = Instance.new'UIListLayout'

                aK.SortOrder = Enum.SortOrder.LayoutOrder
                aK.Padding = aE
                aK.Parent = aJ
                aH[aI] = aJ
            end

            local aI

            local function P()
                local aJ = aC.AbsoluteSize.X < ar

                if aJ == aI then
                    return
                end

                aI = aJ
                aG.FillDirection = aJ and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal

                for aK = 1, 2, 1 do
                    aH[aK].Size = aJ and UDim2.new(1, 0, 0, 0) or UDim2.new(0.5, 
-5, 0, 0)
                end
            end

            P()
            aa.connect(aC:GetPropertyChangedSignal'AbsoluteSize', P)

            aB.cols = aH

            return aH
        end

        for aC, aD in ipairs(ao)do
            local aE = az[aD]

            if type(aE) == 'function' then
                az[aD] = function(aF, aG, ...)
                    local aH, aI = type(aG) == 'table', nil

                    if aH and (ap[aD] and (type(aG.Desc) == 'string' and aG.Desc ~= '')) then
                        aI = aG.Desc
                        aG.Desc = nil
                    end

                    local aJ, aK = false, aH and aG.Callback or nil

                    if aH and aD == 'Toggle' then
                        aJ = aG.Value == true
                        aG.Callback = function(aL, ...)
                            aJ = aL == true

                            if aK then
                                return aK(aL, ...)
                            end
                        end
                    end

                    local aL = aE(aF, aG, ...)
                    local aM = type(aL) == 'table' and aL.ElementFrame

                    aa.breathe()

                    if typeof(aM) ~= 'Instance' then
                        return aL
                    end

                    local aN = M()

                    if aN then
                        if aD == 'Section' then
                            aB.col = aB.weight[2] < aB.weight[1] and 2 or 1
                        end

                        aB.weight[aB.col] = aB.weight[aB.col] + (aq[aD] or 1)
                        aM.Parent = aN[aB.col]
                    end
                    if aI and not a(aM, aI) then
                        pcall(function()
                            aL:SetDesc(aI)
                        end)
                    end
                    if aD == 'Colorpicker' and (aH and (type(aK) == 'function' and type(aL.Update) == 'function')) then
                        local aO = aL.Update

                        aL.Update = function(aP, aQ, aR, ...)
                            local aS = aO(aP, aQ, aR, ...)

                            if typeof(aQ) == 'Color3' then
                                pcall(aK, aQ, aR)
                            end

                            return aS
                        end
                    end
                    if aH and (type(aG.Title) == 'string' and (aD == 'Toggle' or aD == 'Button')) then
                        local aO = 'auto:' .. (type(aG.Flag) == 'string' and aG.Flag or tostring(aA) .. ('/' .. aG.Title))

                        if aD == 'Toggle' then
                            ak.register(aO, aL, {
                                auto = true,
                                kind = 'toggle',
                                title = aG.Title,
                                isActive = function()
                                    return aJ
                                end,
                                setState = function(aP)
                                    pcall(function()
                                        aL:Set(aP)
                                    end)

                                    if aJ ~= aP then
                                        aG.Callback(aP)
                                    end
                                end,
                            })
                        elseif type(aK) == 'function' then
                            ak.register(aO, aL, {
                                auto = true,
                                kind = 'button',
                                title = aG.Title,
                                fire = function()
                                    aK()
                                end,
                            })
                        end
                    end

                    return aL
                end
            end
        end

        return az
    end

    aa.building = true
    aa.lastBreath = os.clock()

    function aa.breathe()
        if not aa.building or os.clock() - aa.lastBreath < 0.005 or not coroutine.isyieldable() then
            return
        end

        task.wait()

        if setthreadidentity then
            pcall(setthreadidentity, 8)
        end

        aa.lastBreath = os.clock()
    end

    -- Keep Roblox's native mouse camera on desktop and touch camera on mobile.

    -- Chloex compatibility: legacy tabs are routed by LegacyWindow:Tab.

    local aA

    if as then
        for aB, aC in ipairs(as:GetDescendants())do
            if aC:IsA'ImageLabel' and aC.Image == 'rbxassetid://120997033468887' then
                aA = aC.Parent

                break
            end
        end
    end
    if aA then
        pcall(function()
            ad:IsResizable(false)
        end)

        local aB, aC, aD = 420, 260, nil

        aa.connect(aA.InputBegan, function(aE)
            if aE.UserInputType ~= Enum.UserInputType.MouseButton1 or aD then
                return
            end

            aD = {
                mouse = al:GetMouseLocation(),
                w = as.Size.X.Offset,
                h = as.Size.Y.Offset,
                pos = as.Position,
                frozen = {},
            }

            local aF = ad.UIElements.MainBar

            if aF then
                for aG, aH in ipairs(aF:GetChildren())do
                    if aH:IsA'Frame' and not aH.Visible then
                        aD.frozen[aH] = aH.Size
                        aH.Size = UDim2.fromOffset(aH.AbsoluteSize.X, aH.AbsoluteSize.Y)
                    end
                end
            end
        end)
        aa.connect(O.RenderStepped, function()
            if not aD then
                return
            end

            local aE = al:GetMouseLocation()

            if aE == aD.last then
                return
            end

            aD.last = aE

            local aF = workspace.CurrentCamera.ViewportSize
            local aG, aH = math.clamp(aD.w + (aE.X - aD.mouse.X), aB, math.max(aB, aF.X)), math.clamp(aD.h + (aE.Y - aD.mouse.Y), aC, math.max(aC, aF.Y))

            as.Size = UDim2.fromOffset(aG, aH)
            as.Position = aD.pos + UDim2.fromOffset((aG - aD.w) / 2, (aH - aD.h) / 2)
            ad.Size = as.Size
        end)
        aa.connect(al.InputEnded, function(aE)
            if aE.UserInputType ~= Enum.UserInputType.MouseButton1 or not aD then
                return
            end

            for aF, aG in pairs(aD.frozen)do
                pcall(function()
                    aF.Size = aG
                end)
            end

            aD = nil

            pcall(function()
                if isfolder and (makefolder and not isfolder'bloxstrike/bloxstrike') then
                    if not isfolder'bloxstrike' then
                        makefolder'bloxstrike'
                    end

                    makefolder'bloxstrike/bloxstrike'
                end

                writefile('bloxstrike/bloxstrike/window.json', an:JSONEncode{
                    w = as.Size.X.Offset,
                    h = as.Size.Y.Offset,
                })
            end)
        end)
    end
end

local al, am = hookfunction, {}

local function Q(an, ao)
    if isfunctionhooked and (restorefunction and isfunctionhooked(an)) then
        pcall(restorefunction, an)
    end

    am[#am + 1] = an

    return al(an, ao)
end

aa.onUnload(function()
    if not restorefunction then
        return
    end

    for an, ao in ipairs(am)do
        pcall(restorefunction, ao)
    end
end)

do
    local an = require(L.Components.Weapon.Classes.Bullet)

    if isfunctionhooked and (restorefunction and isfunctionhooked(an._performRaycast)) then
        pcall(restorefunction, an._performRaycast)
    end
end

local an, ao, ap, aq, ar, as, at, au, av, aw, ax = game:GetService'UserInputService', game:GetService'ContextActionService', game:GetService'TweenService', game:GetService'SoundService', game:GetService'HttpService', game:GetService'Debris', workspace.CurrentCamera, require(L.Controllers.CharacterController), require(L.Controllers.CameraController), require(L.Controllers.InventoryController), require(L.Classes.Character)

local function p()
    local ay, az = pcall(debug.getupvalue, aw.getInventorySlot, 1)

    if ay and type(az) == 'table' then
        return rawget(az, 'CurrentEquipped')
    end

    return nil
end

local ay, az, aA, aB, aC, aD = require(L.MovementV2.Simulation.Config), require(L.Database.Components.Libraries.Skins), require(L.Classes.WeaponComponent.Classes.Viewmodel), L.Database.Custom.Weapons, {
    bhop = false,
    strafe = false,
    alignDeg = 6,
    strafeMode = 'Rage',
    fastTurn = true,
    landBrake = false,
    longJump = false,
    boostJump = false,
    duckTicks = 12,
    noSpeedPenalty = false,
    speed = false,
    speedLimit = 25,
    silentAim = false,
    fov = 120,
    showFov = true,
    fovColor = Color3.fromRGB(255, 255, 255),
    aimPart = 'Head',
    wallCheck = true,
    teamCheck = true,
    minDmg = 20,
    minDmgOverride = false,
    minDmgOverrideValue = 5,
    noSpread = false,
    noRecoil = false,
    rage = false,
    rageAutoFire = true,
    rageAutowall = true,
    rageHitbox = 'Head',
    rageMaxDist = math.huge,
    rapidFire = false,
    rapidMult = 2,
    rapidUnlimited = false,
    wallbang = false,
    penMod = false,
    penValue = 10,
    originOn = false,
    originX = 0,
    originY = 0,
    originZ = 0,
    originMarker = true,
    backtrack = false,
    backtrackMs = 200,
    forwardTrack = false,
    forwardMs = 100,
    wallLimit = false,
    maxWalls = 1,
    bulletTp = false,
    bulletTpDist = 2,
    tapKill = false,
    maxTaps = 3,
    revolverAlt = true,
    doubleTap = false,
    rageRemote = true,
    killAll = false,
    killAllDelay = 0.1,
    loopKill = false,
    loopTarget = nil,
    knifeKillAll = false,
    knifeReach = 3,
    killAllWaitRound = true,
    killAllLeadMs = 100,
    rageTargetMode = 'Distance',
    preferBodyLethal = true,
    forceBody = false,
    predictMs = 0,
    rageMulti = false,
    rageSticky = false,
    rageScanHz = 30,
    missAdapt = false,
    missesToBody = 2,
    ignoreFriends = false,
    rageIndicator = false,
    aaBase = 'View',
    aaManual = nil,
    aa = false,
    aaYaw = 'Backwards',
    aaSpin = 30,
    aaJitter = 60,
    aaJitterDelay = 1,
    aaPitch = 'Down',
    aaOffShot = true,
    autoReload = false,
    instaReload = false,
    reloadSpeed = 3,
    reloadAt = 1,
    remoteReload = false,
    esp = false,
    espEnemyColor = Color3.fromRGB(255, 60, 60),
    espTeam = false,
    espTeamColor = Color3.fromRGB(60, 160, 255),
    espFill = 0.6,
    espNames = true,
    espDistance = true,
    espChams = true,
    espChamsOccluded = false,
    espBox = false,
    espBoxStyle = 'Corner',
    espBoxFill = false,
    espHealth = false,
    espHealthText = true,
    espArmor = false,
    espWeapon = false,
    espSkeleton = false,
    espHeadDot = false,
    espSnap = false,
    espSnapFrom = 'Bottom',
    espArrows = false,
    espArrowRadius = 220,
    espArrowSize = 14,
    espVisCheck = false,
    espVisColor = Color3.fromRGB(90, 255, 120),
    espMaxDist = 3000,
    espTextSize = 12,
    espFlags = false,
    espDormant = false,
    espDormantTime = 4,
    espFade = 0,
    espChamsMode = 'Glow',
    espColorMode = 'Enemy / Teammate',
    espTColor = Color3.fromRGB(255, 170, 60),
    espCTColor = Color3.fromRGB(80, 150, 255),
    scopeStyle = 'Line',
    scopeColor = Color3.fromRGB(255, 255, 255),
    scopeLen = 60,
    scopeGap = 12,
    scopeThick = 1,
    xhair = false,
    xhairColor = Color3.fromRGB(0, 255, 140),
    xhairLen = 6,
    xhairGap = 4,
    xhairThick = 2,
    xhairOutline = true,
    xhairT = false,
    hitMarker = false,
    hitMarkerColor = Color3.fromRGB(255, 255, 255),
    hitMarkerKill = Color3.fromRGB(255, 70, 90),
    hitMarkerTime = 0.45,
    hitMarkerWhere = 'Crosshair',
    hitMarkerAnim = 'Fade',
    hitMarkerSize = 10,
    hitMarkerShape = 'X',
    hitMarkerThick = 2,
    hitMarkerGap = 4,
    hitMarkerOutline = true,
    hitMarkerKillScale = 1.4,
    hitMarkerRise = 0,
    hitMarkerDamage = false,
    dmgNumbers = false,
    dmgColor = Color3.fromRGB(255, 220, 90),
    killFx = false,
    killFxColor = Color3.fromRGB(255, 70, 120),
    dot = false,
    dotColor = Color3.fromRGB(255, 255, 255),
    dotSize = 4,
    tracer = false,
    tracerWidth = 0.06,
    tracerLife = 1,
    impact = false,
    hitSound = false,
    hitSoundId = '3744371342',
    hitVol = 0.6,
    hitLogs = true,
    killSound = false,
    killSoundId = '3744371342',
    killVol = 1,
    skins = false,
    float = 0.001,
    statTrak = true,
    statTrakCount = 1337,
    knife = nil,
    knifeSkin = nil,
    glove = nil,
    gloveSkin = nil,
}, Color3.fromRGB(255, 80, 200)

aC.tracerStyle, aC.tracerFrom, aC.tracerRainbow, aC.tracerOnlyHits = 'Line', 'Gun', false, false
aC.impactSize, aC.impactGlow = 0.35, false

local aE = Color3.fromRGB(255, 255, 255)

local function f() end

local aF, aG, aH = nil, nil, {
    active = false,
    eye = nil,
    sentYaw = nil,
    sentPitch = nil,
}

local function U()
    return aH.active and aH.eye or at.CFrame
end
local function D(aI)
    return (aI + math.pi) % (2 * math.pi) - math.pi
end
local function m()
    return _:GetAttribute'IsPlayerChatting' or an:GetFocusedTextBox() ~= nil
end
local function j()
    local aI = workspace:GetAttribute'ServerGamemode'

    if aI == 'Casual' or aI == 'Deathmatch' then
        return ay.CasualDeathmatch or ay.Default
    elseif aI == 'Surf' then
        return ay.Surf or ay.Default
    end

    return ay.Competitive or ay.Default
end

do
    local aI, aJ = pcall(require, L.Components.Common.Participants)

    if not aI or type(aJ) ~= 'table' or type(aJ.GetAll) ~= 'function' then
        aJ = nil
    end

    local aK = getthreadidentity or syn and syn.get_thread_identity

    local function z(aL, ...)
        local aM, aN, aO = aK and aK(), pcall(aL, ...)

        if aM and setthreadidentity then
            pcall(setthreadidentity, aM)
        end

        return aN, aO
    end

    local aL = {}

    local function R(aM)
        local aN = aL[aM]

        if aN then
            return aN
        end

        aN = setmetatable({
            IsBot = true,
            UserId = 0,
        }, {
            __index = function(aO, aP)
                if aP == 'Character' then
                    local aQ, aR = z(aJ.Character, aM)

                    return aQ and aR or nil
                elseif aP == 'Name' or aP == 'DisplayName' then
                    local aQ, aR = z(aJ.Name, aM)

                    return (aQ and type(aR) == 'string') and aR or aM.Name
                elseif aP == 'Parent' then
                    return aM.Parent
                end

                return nil
            end,
        })

        function aN.GetAttribute(aO, aP)
            local aQ = aM:GetAttribute(aP)

            if aQ == nil then
                local aR, aS = z(aJ.Character, aM)

                if aR and aS then
                    aQ = aS:GetAttribute(aP)
                end
            end

            return aQ
        end

        aL[aM] = aN

        return aN
    end

    local aM, aN = (-1)

    function aa.entities()
        local aO = os.clock()

        if aN and aO - aM < 0.2 then
            return aN
        end

        aM = aO

        local aP, aQ, aR = nil, false

        if aJ then
            aQ, aR = z(aJ.GetAll)
        end
        if aQ and type(aR) == 'table' then
            aP = {}

            for aS, aU in pairs(aR)do
                if typeof(aU) == 'Instance' then
                    aP[#aP + 1] = aU:IsA'Player' and aU or R(aU)
                end
            end
        else
            aP = aa.entities()
        end

        for aS in pairs(aL)do
            if aS.Parent == nil then
                aL[aS] = nil
            end
        end

        if workspace:FindFirstChild'HordeShells' then
            aP = table.clone(aP)

            for aS, aU in ipairs(aa.liveShells())do
                aP[#aP + 1] = aa.zombie(aU)
            end
        end

        aN = aP

        return aP
    end

    local aO

    pcall(function()
        aO = require(L.Controllers.HordeController)
    end)

    function aa.liveShells()
        local aP = {}

        if aO and type(aO.GetLiveShells) == 'function' then
            local aQ, aR = z(aO.GetLiveShells)

            if aQ and type(aR) == 'table' then
                for aS, aU in pairs(aR)do
                    if typeof(aU) == 'Instance' and (aU.Parent and aU:FindFirstChild'Head') then
                        aP[#aP + 1] = aU
                    end
                end

                return aP
            end
        end

        local aQ = workspace:FindFirstChild'HordeShells'

        for aR, aS in ipairs(aQ and aQ:GetChildren() or {})do
            if aS:IsA'Model' and (aS:GetAttribute'HordeId' ~= nil and (not aS:GetAttribute'Ragdolled' and aS:FindFirstChild'Head')) then
                aP[#aP + 1] = aS
            end
        end

        return aP
    end

    local aP = setmetatable({}, {
        __mode = 'k',
    })

    function aa.zombie(aQ)
        local aR = aP[aQ]

        if aR then
            return aR
        end

        aR = {
            IsZombie = true,
            IsBot = true,
            UserId = 0,
            Name = 'zombie',
            DisplayName = 'zombie',
            Character = aQ,
            Parent = aQ.Parent,
        }

        function aR.GetAttribute(aS, aU)
            return aQ:GetAttribute(aU)
        end

        aP[aQ] = aR

        return aR
    end
    function aa.ownerOf(aQ)
        if not aQ then
            return nil
        end

        for aR, aS in ipairs(aa.entities())do
            if aS.Character == aQ then
                return aS
            end
        end

        return nil
    end
    function aa.byName(aQ)
        for aR, aS in ipairs(aa.entities())do
            if aS.Name == aQ then
                return aS
            end
        end

        return nil
    end
end

local function k(aI)
    if type(aI) == 'table' and aI.IsZombie then
        return false
    end
    if workspace:FindFirstChild'HordeShells' then
        return true
    end
    if workspace:GetAttribute'Gamemode' == 'Deathmatch' then
        return false
    end

    local aJ = _:GetAttribute'Team'

    return aJ ~= nil and aI:GetAttribute'Team' == aJ
end
local function h(aI)
    if aI == _ then
        return false
    end
    if type(aI) == 'table' and aI.IsZombie then
        return true
    end
    if workspace:FindFirstChild'HordeShells' then
        return false
    end
    if not aC.teamCheck then
        return true
    end
    if workspace:GetAttribute'Gamemode' == 'Deathmatch' then
        return true
    end

    local aJ = aI:GetAttribute'Team'

    return (aJ == 'Terrorists' or aJ == 'Counter-Terrorists') and aJ ~= _:GetAttribute'Team'
end
local function F(aI, aJ)
    local aK = aI.Character

    if not aK or aK:GetAttribute'Dead' or aK:GetAttribute'Ragdolled' then
        return nil
    end

    local aL = aK:GetAttribute'Health'

    if type(aL) == 'number' and aL <= 0 then
        return nil
    end
    if not aK:IsDescendantOf(workspace) then
        return nil
    end
    if not aK:FindFirstChild(aJ or 'Head') then
        return nil
    end

    return aK
end
local function t(aI)
    if aI == nil then
        return false
    end
    if aI:GetAttribute'Invincible' == true then
        return true
    end

    local aJ = aa.ownerOf(aI)

    return aJ ~= nil and aJ:GetAttribute'Invincible' == true
end

local aI, aJ = {}, setmetatable({}, {
    __mode = 'k',
})

local function dT(aK)
    if aK == _ or aJ[aK] ~= nil then
        return
    end

    aJ[aK] = false

    task.spawn(function()
        local aL, aM = pcall(_.IsFriendsWith, _, aK.UserId)

        aJ[aK] = aL and aM == true
    end)
end

for aK, aL in ipairs(u:GetPlayers())do
    dT(aL)
end

aa.connect(u.PlayerAdded, dT)

local function ET(aK)
    if not h(aK) or aI[aK.Name] then
        return false
    end
    if aC.ignoreFriends and aJ[aK] then
        return false
    end

    return true
end

local aK = setmetatable({}, {
    __mode = 'k',
})

local function MT(aL)
    for aM, aN in ipairs(aa.entities())do
        local aO = aN.Character

        if aO and aL:IsDescendantOf(aO) then
            return aN
        end
    end

    return nil
end
local function AT(aL)
    aL = tostring(aL or '')

    if aL:find'^rbxassetid://' then
        return aL
    end

    local aM = aL:match'%d+'

    return aM and 'rbxassetid://' .. aM or nil
end
local function zT(aL, aM)
    local aN = AT(aL)

    if not aN then
        return
    end

    local aO = Instance.new'Sound'

    aO.SoundId = aN
    aO.Volume = aM or 1
    aO.Parent = aq

    aO:Play()
    as:AddItem(aO, 6)
end

local aL = Instance.new'ScreenGui'

aL.Name = 'bloxstrikebloxOverlay'
aL.IgnoreGuiInset = true
aL.ResetOnSpawn = false
aL.DisplayOrder = 999
aL.Parent = gethui and gethui() or _:WaitForChild'PlayerGui'

aa.onUnload(function()
    aL:Destroy()
end)

local aM = Instance.new'Frame'

aM.AnchorPoint = Vector2.new(0.5, 0.5)
aM.Position = UDim2.fromScale(0.5, 0.5)
aM.BackgroundTransparency = 1
aM.Visible = false
aM.Parent = aL;
(Instance.new('UICorner', aM)).CornerRadius = UDim.new(1, 0)

local aN = Instance.new('UIStroke', aM)

aN.Transparency = 0.35
aN.Thickness = 1

local aO = Instance.new'Frame'

aO.AnchorPoint = Vector2.new(0.5, 0.5)
aO.Position = UDim2.fromScale(0.5, 0.5)
aO.BorderSizePixel = 0
aO.Visible = false
aO.Parent = aL;
(Instance.new('UICorner', aO)).CornerRadius = UDim.new(1, 0)

local aP = Instance.new('UIStroke', aO)

aP.Color = Color3.new(0, 0, 0)
aP.Thickness = 1

aa.connect(O.RenderStepped, function()
    aM.Visible = aC.silentAim and aC.showFov
    aM.Size = UDim2.fromOffset(aC.fov * 2, aC.fov * 2)
    aN.Color = aC.fovColor

    local aQ = p()

    aO.Visible = aC.dot and not (aQ and aQ.IsAiming)
    aO.Size = UDim2.fromOffset(aC.dotSize, aC.dotSize)
    aO.BackgroundColor3 = aC.dotColor
end)

local aQ, aR = 'bloxstrikebloxBhop', false

local function vT(aS)
    aC.bhop = aS

    if aS then
        ao:BindActionAtPriority(aQ, function(aU, aV)
            if aV == Enum.UserInputState.Begin then
                aR = true
            elseif aV == Enum.UserInputState.End or aV == Enum.UserInputState.Cancel then
                aR = false
            end

            return Enum.ContextActionResult.Sink
        end, false, Enum.ContextActionPriority.High.Value + 1000, Enum.KeyCode.Space)
    else
        pcall(function()
            ao:UnbindAction(aQ)
        end)

        aR = false
    end
end

aa.onUnload(function()
    pcall(function()
        ao:UnbindAction(aQ)
    end)
end)

do
    -- movement (shitaro.lol) loaded in an isolated chunk: any failure here cannot break the hub
    local shCode = [===[
local aa, L, LP = ...

local function shHookField(tbl, key, wrap)
    local orig = rawget(tbl, key)

    if type(orig) ~= 'function' then
        return nil
    end

    local new = wrap(orig)

    if type(new) ~= 'function' then
        return orig
    end

    local function setField(v)
        local okRO, ro = false, false

        if isreadonly then
            okRO, ro = pcall(isreadonly, tbl)
        end
        if okRO and ro and setreadonly then
            pcall(setreadonly, tbl, false)
        end

        local ok = pcall(function()
            tbl[key] = v
        end)

        if okRO and ro and setreadonly then
            pcall(setreadonly, tbl, true)
        end

        return ok
    end

    if not setField(new) then
        return orig
    end

    aa.onUnload(function()
        if rawget(tbl, key) == new then
            setField(orig)
        end
    end)

    return orig
end

local shOk, shMv = pcall(function()
    return require(L.MovementV2.Client.Runtime)
end)

return (function(shLP, shStorage, shMvRuntime)
    local R = {lp = shLP, storage = shStorage}
    local _ = {
        field = shHookField,
        teardown = function(fn)
            aa.onUnload(fn)

            return fn
        end,
    }
    local N = {mv_runtime = shMvRuntime}
    local h = {apply = function() end}
    local F = {cmd_samples = 0, expires = 0, yaw = 0, pitch = 0, clear = function() end}

    local t,f,l=R.lp,R.storage,math.clamp;
    local g=math.floor;
    local u=math.sqrt;
    local s=math.abs;
    local C=math.cos;
    local z,q=math.sin,3.141592653589793;
    local r=bit32.bor;
    local x=bit32.band;
    local G,a,m,c,n,O,j=bit32.bnot,{bhop=false,strafe=false,edge_jump=false,jump_bug=false,edge_bug=false,slow_walk=false,pixel_surf=false};
    local E,P,T,Y,v,Z,L=false;
    do 
    local o=f:FindFirstChild("MovementV2");
    if o then 
    	local X,Q,S,A,J,y=pcall(function()
    		return require(o.Simulation),require(o.Simulation.State),require(o.Simulation.RuntimeSettings),require(o.Serial),require(o.Buttons);
    	end);
    	if X and type(Q)=="table"then 
    		if type(Q.step)=="function"then 
    			if type(S)=="table"then 
    				if type(A)=="table"then 
    					if type(J)=="table"then 
    						if type(y)=="table"then 
    							local o=true;
    							m,c,n,O,j,E=Q,S,A,J,y,o;
    						else 
    						end;
    					else 
    					end;
    				else 
    				end;
    			else 
    			end;
    		else 
    		end;
    	else 
    	end;
    else 
    end;
    P,T,Y,v,Z,L=m,c,n,O,j,E;end;
    			local m=Z and Z.Jump or 1;
    local c=Z and Z.Duck or 2;
    local n,O,j=Z and Z.Walk or 4,{char=nil,runtime=nil,bug_pending=false,hz=nil,config=nil,strafe_yaw=nil,strafe_side=1,capture=false,world=nil,world_tick=nil,world_owner=nil},{mode=nil,normal=nil,duck=false,wide=false,ticks=0,check=0,away=0,rest=0,jump=false,air=false};
    local E=math.round;
    local o=math.max;
    local X=math.log;
    local Q,S,A,J=math.exp,6.283185307179586,{1,0.5,0},{};
    for y=0,7,1 do 
    	f=y*q/4;
    	J[y+1]=Vector3.new(C(f),0,z(f));
    end;
    local y={};
    y[1]=Vector2.zero;
    for e=0,15,1 do 
    	R=e*q/8;
    	y[#y+1]=Vector2.new(C(R),z(R));
    end;
    local e,M={},{};
    f=N.mv_runtime;
    if type(f)=="table"then 
    	if type(rawget(f,"advance"))=="function"then 
    		_.field(f,"advance",function(I)
    			return function(i,...)
    				O.runtime=i;
    				return I(i,...);
    			end;
    		end);
    	end;
    end;
    if type(f)=="table"then 
    	if type(rawget(f,"_composeWorld"))=="function"then 
    		R=_.field(f,"_composeWorld",function(I)
    			return function(i,k,...)
    				local B,d=I(i,k,...);
    				if B~=nil then 
    					O.world=B;
    					O.world_tick=k;
    					O.world_owner=i;
    				end;
    				return B,d;
    			end;
    		end);
    		O.capture=rawget(f,"_composeWorld")~=R;
    		_.teardown(function()
    			O.capture=false;
    			O.world=nil;
    			O.world_tick=nil;
    			O.world_owner=nil;
    		end);
    	end;
    end;
    local function I(i,k,B)
    	if Z then 
    		if type(Z.with)=="function"then 
    			return Z.with(i,k,B);
    		end;
    	end;
    	if B then 
    		return r(i,k);
    	end;
    	return x(i,G(k));
    end;
    local function Z(i)
    	local k=O.runtime;
    	if type(k)~="table"then 
    		return nil;
    	end;
    	if rawget(k,"_started")~=true then 
    		return nil;
    	end;
    	if type(i)=="table"then 
    		local B=rawget(k,"_mapping");
    		if type(B)~="table"then 
    			return nil;
    		elseif B.Generation~=i.Generation then 
    			return nil;
    		end;
    	end;
    	return k;
    end;
    local function i(k)
    	local B=type(k)=="table"and tonumber(k.SimulationHz)or nil;
    	if not(B)then 
    		return nil;
    	end;
    	if O.hz==B then 
    		if O.config then 
    			return O.config;
    		end;
    	end;
    	local k,d=pcall(Y.getMovementConfig,B);
    	if k then 
    		if type(d)~="table"then 
    			return nil;
    		end;
    	else 
    		return nil;
    	end;
    	O.hz=B;
    	O.config=d;
    	return d;
    end;
    local function Y(k,B)
    	if L then 
    		if type(k)~="table"then 
    			return nil;
    		elseif type(B)~="table"then 
    			return nil;
    		elseif type(k.Support)~="table"then 
    			return nil;
    		end;
    	else 
    		return nil;
    	end;
    	local L=tonumber(k.ServerTick);
    	if not(L)then 
    		return nil;
    	end;
    	local d=Z(k.Mapping);
    	if not(d)then 
    		return nil;
    	end;
    	local Z=rawget(d,"_commandStream");
    	if type(Z)~="table"then 
    		return nil;
    	end;
    	local b=O.world_owner==d and O.world_tick==L and O.world or nil;
    	if b then 
    	else 
    		if O.capture then 
    		else 
    			local p=rawget(d,"_timeline");
    			if type(p)~="table"then 
    				return nil;
    			end;
    			local D,V=pcall(p.resolve,p,L);
    			if D then 
    				if type(V)~="table"then 
    					return nil;
    				end;
    			else 
    				return nil;
    			end;
    			p,D=pcall(d._composeWorld,d,L,V.Revision,nil,B);
    			b=p and D or nil;
    		end;
    	end;
    	if type(b)~="table"then 
    		return nil;
    	elseif type(b.Composed)~="table"then 
    		return nil;
    	elseif type(b.Composed.Query)~="table"then 
    		return nil;
    	end;
    	L=i(k.Mapping);
    	if not L then 
    		return nil;
    	end;
    	local i,p=pcall(Z.lastSampledCommandNumber,Z);
    	if not(i)then 
    		return nil;
    	end;
    	Z,i=pcall(v.addUInt32,p or 4294967295,1);
    	if not Z then 
    		return nil;
    	end;
    	return{runtime=d,state=B,support=k.Support,world=b,config=L,step=l(tonumber(k.StepSeconds)or 0.015625,0.001,0.05),number=i};
    end;
    local function v(Z)
    	local L,i=pcall(T.clone,Z.state);
    	if L then 
    		if type(i)~="table"then 
    			return nil;
    		end;
    	else 
    		return nil;
    	end;
    	local L,k=pcall(T.cloneSupport,Z.support);
    	if L then 
    		if type(k)~="table"then 
    			return nil;
    		end;
    	else 
    		return nil;
    	end;
    	return i,k;
    end;
    local function T(Z)
    	local L=E(Z%S/S*65536)%65536/65536*S;
    	if L>=q then 
    		return L-S;
    	end;
    	return L;
    end;
    local function q(Z,L,S,i,k,B,d,b)
    	local p,D=pcall(Z.runtime._resolveSupportMotion,Z.runtime,Z.world,L,S);
    	if not(p)then 
    		return nil;
    	end;
    	local p,V,W,H=pcall(P.step,L,S,{CommandNumber=i,Move=Vector2.new(E(l(k.X,-1,1)*127)/127,E(l(k.Y,-1,1)*127)/127),LookYaw=T(B),VerticalLook=E(l(d,-1,1)*127)/127,Buttons=b},Z.step,Z.world.Composed.Query,D,Z.config,nil);
    	if p then 
    		if type(V)~="table"then 
    			return nil;
    		elseif type(W)~="table"then 
    			return nil;
    		elseif type(H)~="table"then 
    			return nil;
    		end;
    	else 
    		return nil;
    	end;
    	return V,W,H;
    end;
    local function E(P,T,Z,L,S)
    	local i,k=v(P);
    	if not(i)then 
    		return nil;
    	end;
    	return q(P,i,k,P.number,T,Z,L,S);
    end;
    local function q(P,T,v,Z)
    	if Z.Landed then 
    		return false;
    	elseif Z.StartSolid then 
    		return false;
    	elseif T.OnGround==true then 
    		return false;
    	elseif v.OnGround==true then 
    		return false;
    	end;
    	local L,S=T.Velocity,v.Velocity;
    	if typeof(L)~="Vector3"then 
    		return false;
    	elseif typeof(S)~="Vector3"then 
    		return false;
    	elseif L.Y>=-4 then 
    		return false;
    	end;
    	Z=s(tonumber(P.config.Gravity)or 60);
    	local i=math.max(1.25,Z*P.step*1.35);
    	if s(S.Y)>i then 
    		return false;
    	elseif S.Y<=L.Y+4 then 
    		return false;
    	end;
    	return v.Position.Y<=T.Position.Y+0.05;
    end;
    local function P(T,v,Z,L,S)
    	local i=I(I(S,m,false),c,false);
    	local k,B,B=E(T,v,Z,L,i);
    	if not(k)then 
    		return nil;
    	end;
    	if q(T,T.state,k,B)then 
    		return v,false;
    	end;
    	if not(B.Landed)then 
    		return nil;
    	end;
    	k=#y+1;
    	for d=0,#y,1 do 
    		S=d+1;
    		e[S]=d;
    		M[S]=((d==0 and v or y[d])-v).Magnitude;
    	end;
    	for d=2,k,1 do 
    		local b,p,D=e[d],M[d],d-1;
    		while D>=1 and M[D]>p do 
    			e[D+1]=e[D];
    			M[D+1]=M[D];
    			D-=1;
    		end;
    		e[D+1]=b;
    		M[D+1]=p;
    	end;
    	local d,b,p;
    	for D=0,1,1 do 
    		B=D==1;
    		local V,W=B and 0.25 or 0,I(i,c,B);
    		for i=1,k,1 do 
    			S=e[i];
    			if D~=0 or S~=0 then 
    				local e=M[i]+V;
    				if d then 
    					if e>=d then 
    						break;
    					end;
    				end;
    				local M=S==0 and v or y[S];
    				local v,S,S=E(T,M,Z,L,W);
    				if v then 
    					if q(T,T.state,v,S)then 
    						d,b,p=e,M,B;
    						break;
    					end;
    				end;
    			end;
    		end;
    	end;
    	return b,p;
    end;
    local function q(T,v)
    	local Z,L=z(v),C(v);
    	local S,y=L*T.X+Z*T.Y,-Z*T.X+L*T.Y;
    	v=S*S+y*y;
    	if v>1 then 
    		T=1/u(v);
    		S,y=S*T,y*T;
    	else 
    	end;
    	return Vector3.new(S,0,y);
    end;
    local function u(T,v)
    	local Z,L=z(v),C(v);
    	return Vector2.new(L*T.X-Z*T.Z,Z*T.X+L*T.Z);
    end;
    local function T(v,Z,L,S)
    	local y=Vector3.new(L.X,0,L.Z);
    	local e,M=y.Magnitude,O.strafe_yaw;
    	O.strafe_yaw=Z;
    	if e<=0.05 then 
    		if v.Magnitude>0.001 then 
    			return v.Magnitude>1 and v.Unit or v;
    		end;
    		L=O.strafe_side or 1;
    		O.strafe_side=L;
    		return Vector2.new(L,0);
    	end;
    	L=y/e;
    	e=Vector3.new(L.Z,0,-L.X);
    	y=q(v,Z):Dot(e);
    	v=nil;
    	if s(y)>0.01 then 
    		v=y>0 and 1 or-1;
    	else 
    		if M~=nil then 
    			L=math.atan2(z(Z-M),C(Z-M));
    			v=if s(L)>1.0E-4 then L>0 and 1 or-1 else v;
    		else 
    		end;
    	end;
    	if v then 
    	else 
    		y=tonumber(S);
    		v=if y then g(y)%2==0 and 1 or-1 else-(O.strafe_side or 1);
    	end;
    	O.strafe_side=v;
    	return u(e*v,Z);
    end;
    local function g(v)
    	if typeof(v)~="Vector3"then 
    		return nil;
    	elseif s(v.Y)>=0.7 then 
    		return nil;
    	end;
    	local Z=Vector3.new(v.X,0,v.Z);
    	if Z.Magnitude<0.3 then 
    		return nil;
    	end;
    	return Z.Unit;
    end;
    local function v(Z)
    	return Z.Stance=="Ducking"and"Ducking"or"Standing";
    end;
    local function Z(L,S)
    	local y=S=="Ducking"and L.PlayerSizeDucking or L.PlayerSizeStanding;
    	return typeof(y)=="Vector3"and y.X*0.5 or 1.2;
    end;
    local function L(S,y)
    	local e=y=="Ducking"and S.PlayerSizeDucking or S.PlayerSizeStanding;
    	return typeof(e)=="Vector3"and e.Y*0.5 or 2.7;
    end;
    local function S(y,e)
    	return e.Position.Y-L(y,v(e));
    end;
    local function y(e)
    	local M,i=e.PlayerSizeStanding,e.PlayerSizeDucking;
    	if typeof(M)~="Vector3"then 
    		return 0.27;
    	elseif typeof(i)~="Vector3"then 
    		return 0.27;
    	end;
    	return(M.Y-i.Y)*(tonumber(e.DuckJumpOriginShiftFraction)or 0.2);
    end;
    local function e(M)
    	local i=tonumber(M.DuckAmount);
    	if i then 
    		if i>=0.999 then 
    			return true;
    		end;
    	end;
    	i=tonumber(M.DuckCooldownSeconds);
    	if i then 
    		if i>0 then 
    			local i=tonumber(M.DuckAmount);
    			if i then 
    				if i<=0.75 then 
    					return false;
    				end;
    			else 
    				return false;
    			end;
    		end;
    	end;
    	return(tonumber(M.DuckSpeed)or 8)>=3.5;
    end;
    local function M(i,k,B,d)
    	local b,p=pcall(i.Sweep,i,k,B,d,nil,1,1);
    	if b then 
    		if type(p)=="table"then 
    			return p;
    		end;
    	end;
    	return nil;
    end;
    local function i(k,B,d,b)
    	local p,D=pcall(k.FindGround,k,B,d,b,1);
    	if p then 
    		if type(D)=="table"then 
    			return D;
    		end;
    	end;
    	return nil;
    end;
    local function k(B,d,b)
    	local p,D=pcall(B.IsClear,B,d,b,1);
    	return p and D==true;
    end;
    local function B(d,b)
    	if b<=0 then 
    		return 0;
    	end;
    	local p=o(tonumber(d.Friction)or 5.2,0.1);
    	local D=(tonumber(d.GroundAccelerate)or 5.5)*o(tonumber(d.DefaultBaseMoveSpeed)or 18.75,1)/p;
    	d=X(1+b/D)/p;
    	return(b+D)/p*(1-Q(-p*d))-D*d;
    end;
    local function X(Q,d,b,p,D)
    	local V=d-Vector3.new(0,0.5,0);
    	d=V+b*(p*2+0.35);
    	if not(k(Q,d,D))then 
    		return b;
    	end;
    	p=M(Q,d,V,D);
    	if p then 
    		if not(p.StartSolid)then 
    			V=tonumber(p.Fraction);
    			if V then 
    				if V<1 then 
    					Q=g(p.Normal);
    					if Q then 
    						if Q:Dot(b)>0.5 then 
    							return Q;
    						end;
    					end;
    				end;
    			end;
    		end;
    	end;
    	return b;
    end;
    local function Q(d)
    	return(tonumber(d.MaxStepHeight)or 1.35)+0.15;
    end;
    local function d(b,p,D,V)
    	return k(b,p,D)and i(b,p,D,V)==nil;
    end;
    local function b(p,D,V)
    	return i(p,D,V,1.5)~=nil;
    end;
    local function p(D)
    	j.mode=nil;
    	j.normal=nil;
    	j.duck=false;
    	j.wide=false;
    	j.ticks=0;
    	j.check=0;
    	j.away=0;
    	if D then 
    		j.rest=10;
    	end;
    end;
    local function D(V,W)
    	local H,w,UQ,KQ=V.world.Composed.Query,V.config,v(W),W.Position;
    	local RQ,_Q,NQ=Z(w,UQ),Q(w),j.mode=="catch"and j.normal or nil;
    	p(false);
    	NQ=NQ and(if d(H,KQ+NQ*(RQ*2+0.6),UQ,_Q)then NQ else nil);
    	if NQ then 
    	else 
    		W,V=RQ*2+0.35,Vector3.zero;
    		for hQ=1,#J,1 do 
    			w=J[hQ];
    			V=if d(H,KQ+w*W,UQ,_Q)then V+w else V;
    		end;
    		NQ=if V.Magnitude>0.3 then X(H,KQ,V.Unit,RQ,UQ)else NQ;
    	end;
    	if not(NQ)then 
    		return;
    	end;
    	j.mode="ride";
    	j.normal=NQ;
    	j.wide=not d(H,KQ-NQ*(RQ*2+0.35),UQ,_Q);
    end;
    local function X(V,W,H,w,UQ,KQ,RQ)
    	local _Q,NQ,hQ=V.world.Composed.Query,V.config,j.normal;
    	local FQ,tQ=Vector3.new(-hQ.Z,0,hQ.X),q(H,w);
    	H=tQ:Dot(hQ);
    	if H>0.7 then 
    		j.away=j.away+1;
    		if j.away>=30 then 
    			p(true);
    			return nil;
    		end;
    	else 
    		j.away=0;
    	end;
    	local fQ=v(W);
    	j.check=j.check+1;
    	if j.check>=8 then 
    		j.check=0;
    		if not(d(_Q,W.Position+hQ*(Z(NQ,fQ)*2+0.6),fQ,Q(NQ)))then 
    			p(false);
    			return nil;
    		end;
    	end;
    	local Q,d,lQ,gQ,uQ=I(I(KQ,m,false),c,false),tQ:Dot(FQ),RQ:Dot(hQ),RQ:Dot(FQ),false;
    	KQ=B(NQ,s(gQ))+0.45;
    	if s(gQ)>0.5 and not b(_Q,W.Position+FQ*(gQ>0 and KQ or-KQ),fQ)then 
    		d,uQ=gQ>0 and-1 or 1,true;
    	else 
    		if s(d)>0.05 and(d*gQ<=0 or s(gQ)<=0.5)then 
    			if b(_Q,W.Position+FQ*(d>0 and KQ or-KQ),fQ)then 
    			else 
    				RQ,tQ=true,0;
    				d,uQ=tQ,RQ;
    			end;
    		else 
    		end;
    	end;
    	fQ=if j.wide then o(lQ,0)*0.9+o(-H,0)else lQ*0.9;
    	for KQ=1,3,1 do 
    		gQ=if KQ==1 then FQ*d-hQ*l(fQ,-1,1)else if KQ==2 then FQ*(d*0.5)-hQ*(lQ>=0 and 1 or-1)else Vector3.zero;
    		gQ=if gQ.Magnitude>1 then gQ.Unit else gQ;
    		W=gQ.Magnitude>0.01 and u(gQ,w)or Vector2.zero;
    		if KQ==1 then 
    			if not(uQ)then 
    				if lQ<=0 then 
    					if gQ:Dot(hQ)<=0 then 
    						return W;
    					end;
    				end;
    			end;
    		end;
    		RQ=E(V,W,w,UQ,Q);
    		if RQ then 
    			if RQ.OnGround==true then 
    				H=RQ.Velocity;
    				tQ=H.X*hQ.X+H.Z*hQ.Z;
    				if tQ<=0.35 then 
    					return W;
    				elseif b(_Q,RQ.Position+hQ*B(NQ,tQ),v(RQ))then 
    					return W;
    				end;
    			end;
    		end;
    	end;
    	p(true);
    	return nil;
    end;
    local function l(Q,B,d,b)
    	local V=Vector3.new(d.X,0,d.Z);
    	local W,H,w,UQ=V.Magnitude>1 and V.Unit or nil,Q.world.Composed.Query,v(B),B.Position;
    	V=if W then b+W*0.6 else b;
    	if V.Magnitude<0.15 then 
    		return nil;
    	end;
    	d=g(B.WallNormal);
    	B,b=d and-V.Unit:Dot(d)or nil,d;
    	for KQ=1,#J,1 do 
    		d=J[KQ];
    		if V:Dot(d)>0.15 then 
    			Q=M(H,UQ,UQ+d*2.6,w);
    			if Q then 
    				if Q.AllSolid then 
    				else 
    					KQ=tonumber(Q.Fraction);
    					if KQ then 
    						if KQ<1 then 
    							W=g(Q.Normal);
    							if W then 
    								local g=-V.Unit:Dot(W);
    								if g>0.25 then 
    									if B then 
    										if g>B then 
    											B,b=g,W;
    										else 
    										end;
    									else 
    										B,b=g,W;
    									end;
    								else 
    								end;
    							else 
    							end;
    						else 
    						end;
    					else 
    					end;
    				end;
    			else 
    			end;
    		else 
    		end;
    	end;
    	return b;
    end;
    local function g(Q,J,M,B)
    	local d,b,V,W=Q.world.Composed.Query,Q.config,J.Position,v(J);
    	local v,H=S(b,J),s(tonumber(b.Gravity)or 60);
    	local S,w,UQ,KQ,RQ=B.Y>0 and B.Y*B.Y/(2*H)or 0,o(0,tonumber(b.AutoJumpLedgeAssistHeight)or 0),L(b,W),(tonumber(J.DuckAmount)or 0)>=0.999,0;
    	if KQ then 
    	else 
    		RQ=y(b);
    		RQ=if W~="Ducking"then RQ+(b.PlayerSizeStanding.Y-b.PlayerSizeDucking.Y)*0.5 else RQ;
    	end;
    	Q=i(d,V,W,14);
    	H,B=Q and Q.Position.Y-UQ or v-14,v+S;
    	Q,v=B+w;
    	for L=1,3,1 do 
    		S=V-M*(L==1 and 0.1 or L==2 and 0.4 or Z(b,W)+0.2);
    		for Z=1,#A,1 do 
    			w=Q+RQ*A[Z]+0.2;
    			L=Vector3.new(S.X,w+UQ,S.Z);
    			if k(d,L,W)then 
    				Z=i(d,L,W,w-H+14);
    				if Z then 
    					v=Z.Position.Y-UQ;
    					break;
    				end;
    			end;
    		end;
    		if v then 
    			break;
    		end;
    	end;
    	if v then 
    		if v<=H+0.6 then 
    			return nil;
    		end;
    	else 
    		return nil;
    	end;
    	if v<=B-0.2 then 
    		return KQ;
    	end;
    	if RQ>0 then 
    		if v<=Q+RQ then 
    			if e(J)then 
    				return true;
    			end;
    		end;
    	end;
    	if v<=Q then 
    		return KQ;
    	end;
    	return nil;
    end;
    local function v(Z,L,o,Q,S,A)
    	local J,y=q(o,Q),j.mode=="catch"and j.normal or nil;
    	if y then 
    		j.ticks=j.ticks+1;
    		if j.ticks>40 then 
    			p(false);
    			y=nil;
    		else 
    			if J:Dot(y)>0.7 then 
    				p(false);
    				y=nil;
    			else 
    			end;
    		end;
    	else 
    	end;
    	o=y;
    	if not o then 
    		y=l(Z,L,S,J);
    		if not(y)then 
    			return nil;
    		end;
    		local l=g(Z,L,y,S);
    		if l==nil then 
    			return nil;
    		end;
    		j.mode="catch";
    		j.normal=y;
    		j.duck=l;
    		j.ticks=0;
    		j.check=0;
    		return u(-y,Q),l or A;
    	end;
    	j.check=j.check+1;
    	if j.check>=3 then 
    		j.check=0;
    		J=g(Z,L,o,S);
    		if J==nil then 
    			p(false);
    			return nil;
    		end;
    		if J then 
    			j.duck=true;
    		end;
    	end;
    	return u(-o,Q),j.duck or A;
    end;
    local function l(g,u,q,Z,L,o,Q,S,A,J,y)
    	if S then 
    		if y then 
    			p(true);
    			return nil;
    		end;
    		if A or j.mode=="catch"then 
    			if j.rest>0 then 
    				p(false);
    				return nil;
    			elseif J then 
    				p(false);
    				return nil;
    			end;
    			D(g,u);
    		end;
    		if j.mode~="ride"then 
    			return nil;
    		end;
    		local S=X(g,u,q,Z,L,o,Q);
    		if S then 
    			return S,false;
    		end;
    		return nil;
    	end;
    	if j.mode=="ride"then 
    		p(false);
    	end;
    	if j.rest>0 then 
    		return nil;
    	end;
    	return v(g,u,q,Z,Q,x(o,c)~=0);
    end;
    local function g(u)
    	O.char=u;
    	O.bug_pending=false;
    	O.hz=nil;
    	O.config=nil;
    	O.strafe_yaw=nil;
    	O.strafe_side=1;
    	j.mode=nil;
    	j.normal=nil;
    	j.duck=false;
    	j.wide=false;
    	j.ticks=0;
    	j.check=0;
    	j.away=0;
    	j.rest=0;
    	j.jump=false;
    	j.air=false;
    end;
    local function u(q,v,Z)
    	local L=v and v.State or q and q.MovementState;
    	if type(L)~="table"then 
    		return nil;
    	end;
    	local o=q and q.Character;
    	if O.char~=o then 
    		g(o);
    	end;
    	local X,Q,S,A,J,y,e,M,i=tonumber(Z.Buttons)or 0,typeof(Z.Move)=="Vector2"and Z.Move or Vector2.zero,tonumber(Z.LookYaw)or tonumber(L.LookYaw)or 0,tonumber(Z.VerticalLook)or tonumber(L.VerticalLook)or 0,typeof(L.Velocity)=="Vector3"and L.Velocity or q and q.GlobalVelocity or Vector3.zero,L.OnGround==true,L.MovementMode==nil or L.MovementMode=="Walking";
    	o=false;
    	if not(a.jump_bug)then 
    		O.bug_pending=false;
    	end;
    	if e and a.strafe then 
    		if y then 
    			O.strafe_yaw=nil;
    		end;
    	else 
    		O.strafe_yaw=nil;
    	end;
    	local k=x(X,m)~=0;
    	local B,d=k and not j.jump,j.air and y;
    	j.jump=k;
    	local b=not y;
    	j.air=b;
    	local D=a.pixel_surf and e;
    	if D then 
    		if j.rest>0 then 
    			j.rest=j.rest-1;
    		end;
    	elseif j.mode~=nil then 
    		p(false);
    	end;
    	local j=if e and a.bhop then if q then if q.JumpInputDown then y else nil else nil else nil;
    	if O.bug_pending then 
    		O.bug_pending=false;
    		if a.jump_bug then 
    			if e then 
    				if y then 
    					local p,V,W=true,false,true;
    					j,M,o=p,V,W;
    				else 
    				end;
    			else 
    			end;
    		else 
    		end;
    	else 
    	end;
    	q=e and(D or a.edge_jump and y or(if y then b else a.jump_bug or a.edge_bug))and Y(v,L)or nil;
    	if q and not o then 
    		if D then 
    			local Y,p=l(q,L,Q,S,A,X,J,y,d,k,B);
    			if Y then 
    				local l,V,W=false,p==true,true;
    				j,M,i,o=l,V,Y,W;
    			else 
    			end;
    		else 
    		end;
    	else 
    	end;
    	if q and not o then 
    		if a.edge_jump then 
    			if y then 
    				B,k,L=E(q,Q,S,A,I(X,m,false));
    				j=if B and L.LeftGround then if L.Jumped then j else if B.OnGround~=true then true else j else j;
    			else 
    			end;
    		else 
    		end;
    	else 
    	end;
    	if q and not o and a.edge_bug and b then 
    		if J.Y<-4 then 
    			d=if j~=nil then(I(X,m,j))else X;
    			d=if M~=nil then(I(d,c,M))else d;
    			L,D=P(q,Q,S,A,d);
    			if typeof(L)=="Vector2"then 
    				local l,P,Y=false,D==true,true;
    				j,M,i,o=l,P,L,Y;
    			else 
    			end;
    		else 
    		end;
    	else 
    	end;
    	if q and not o and a.jump_bug and b then 
    		if J.Y<-4 then 
    			L=I(I(X,m,false),c,true);
    			d,D,B=E(q,Q,S,A,L);
    			if d then 
    				if B.Landed then 
    					O.bug_pending=true;
    					local l,q,O=false,true,true;
    					j,M,o=l,q,O;
    				else 
    				end;
    			else 
    			end;
    		else 
    		end;
    	else 
    	end;
    	i=if(if o then not o else e)and a.strafe then if y then i else T(Q,S,J,v and v.ServerTick)else i;
    	if typeof(i)=="Vector2"then 
    		Z.Move=i;
    	end;
    	X=if j~=nil then(I(X,m,j))else X;
    	X=if M~=nil then(I(X,c,M))else X;
    	Z.Buttons=if a.slow_walk and e then if y then I(X,n,true)else X else X;
    	return M;
    end;
    local function l(q,m,c)
    	if typeof(q.Move)~="Vector2"then 
    		return;
    	end;
    	local n=m-c;
    	if s(n)<=1.0E-6 then 
    		return;
    	end;
    	local s,m,c=C(n),z(n),q.Move;
    	q.Move=Vector2.new(c.X*s-c.Y*m,c.X*m+c.Y*s);
    end;

    return {
        cfg = a,
        sample = function(char, arg, cmd)
            local duck = u(char, arg, cmd)

            if duck ~= nil then
                local b = tonumber(cmd.Buttons) or 0

                if duck then
                    cmd.Buttons = r(b, 2)
                else
                    cmd.Buttons = x(b, G(2))
                end
            end
        end,
        reset = function()
            g(nil)
        end,
    }
end)(LP, L, shOk and shMv or nil)
]===]

    pcall(function()
        local shFn = loadstring and loadstring(shCode, '=shitaro_movement')

        if shFn then
            local ok, res = pcall(shFn, aa, L, _)

            if ok and type(res) == 'table' then
                aa.shitaro = res
            end
        end
    end)
    aa.onUnload(function()
        local sh = aa.shitaro

        aa.shitaro = nil

        if sh then
            pcall(sh.reset)
        end
    end)
end


do
    local aS, aU, aV, aW, aX, aY, aZ, a_, a0, a1 = 64, 2, 1, false, 0, false, false, 0, 0, nil

    local function v(a2, a3, a4)
        local a5, a6 = aC.speed, a1 and D(a3.LookYaw - a1) or 0

        a1 = a3.LookYaw

        if not (aC.strafe or a5) or a2.OnGround or m() then
            return
        end
        if not a5 and not an:IsKeyDown(Enum.KeyCode.Space) then
            return
        end
        if not a5 and aC.strafeMode == 'Legit' then
            if math.abs(a6) < 0.002 then
                return
            end

            a3.Move = Vector2.new(a6 > 0 and -1 or 1, 0)

            return
        end

        local a7, a8 = (an:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (an:IsKeyDown(Enum.KeyCode.A) and 1 or 0), (an:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (an:IsKeyDown(Enum.KeyCode.W) and 1 or 0)

        if a7 == 0 and a8 == 0 then
            if not a5 then
                return
            end

            a8 = -1
        end
        if type(a4) ~= 'table' then
            a4 = nil
        end

        local a9 = (a4 and typeof(a4.Velocity) == 'Vector3') and a4.Velocity or a2.GlobalVelocity
        local ba = (Vector2.new(a9.X, a9.Z)).Magnitude

        if ba < aU then
            return
        end
        if a5 and ba >= aC.speedLimit then
            a3.Move = Vector2.zero

            return
        end

        local bb, bc = D(a3.LookYaw + math.atan2(-a7, -a8)), math.atan2(-a9.X, -a9.Z)
        local bd, be = D(bb - bc), nil
        local bf = math.abs(bd) > math.rad(aC.alignDeg)

        if bf then
            be = bd > 0 and 1 or -1
        else
            aV = -aV
            be = aV
        end

        local bg = j()
        local bh = bg.MaxSpeed

        if a4 and type(a4.BaseMoveSpeed) == 'number' then
            bh = math.clamp(a4.BaseMoveSpeed, 0, bg.MaxBaseMoveSpeed or a4.BaseMoveSpeed)
        end

        local bi = 1

        if a4 and type(a4.Stamina) == 'number' then
            local bj = math.max(bg.StaminaMax or 100, 1)

            bi = math.clamp((a4.Stamina + (bg.StaminaRecoveryRate or 0) / aS) / bj, 0, 1)
        end

        local bj = 1

        if a4 and (type(a4.DuckAmount) == 'number' and type(bg.CrouchModifier) == 'number') then
            bj = 1 + (bg.CrouchModifier - 1) * math.clamp(a4.DuckAmount, 0, 1)
        end

        local bk, bl, bm = ((bh * bj) * bi) * bi, nil, nil

        if (bg.BunnyHopAirAccelerate or 0) > 0 and (bg.BunnyHopAirSpeedCap or 0) > 0 then
            bm = math.min(bk, bg.BunnyHopAirSpeedCap)
            bl = (bg.BunnyHopAirAccelerate * bm) / aS
        else
            bm = math.min(bk, bg.AirSpeedCap)
            bl = (bg.AirAccelerate * bk) / aS
        end

        local bn = math.min(bl, bm)
        local bo = math.acos(math.clamp((bm - bn) / ba, -1, 1))

        if bf and aC.fastTurn then
            local bp = math.min(bl, 2 * bm)
            local bq = math.acos(math.clamp((-bp / 2) / ba, -1, 1))
            local br = math.atan2(bp * math.sin(bq), ba + bp * math.cos(bq))

            if br <= math.abs(bd) then
                bo = bq
            end
        end

        local bp = be > 0 and bc + bo or bc - bo
        local bq = Vector3.new(-math.sin(bp), 0, -math.cos(bp))
        local br = (CFrame.Angles(0, a3.LookYaw, 0)):VectorToObjectSpace(bq)

        a3.Move = Vector2.new(math.clamp(br.X, -1, 1), math.clamp(br.Z, -1, 1))
    end
    local function K(a2)
        if not aC.aa then
            return
        end
        if aC.aaOffShot then
            local a3 = p()

            if a3 and a3.IsShooting then
                return
            end
        end

        local a3 = a2.LookYaw
        local a4 = a3

        if aC.aaBase == 'At Targets' then
            local a5, a6 = (U()).Position, nil

            for a7, a8 in ipairs(aa.entities())do
                if h(a8) then
                    local a9 = F(a8, 'HumanoidRootPart')

                    if a9 then
                        local ba = a9.HumanoidRootPart.Position - a5

                        if not a6 or ba.Magnitude < a6 then
                            a6 = ba.Magnitude
                            a4 = math.atan2(-ba.X, -ba.Z)
                        end
                    end
                end
            end
        end

        local a5 = a4

        if aC.aaManual == 'Left' then
            a5 = a4 + math.pi / 2
        elseif aC.aaManual == 'Right' then
            a5 = a4 - math.pi / 2
        elseif aC.aaManual == 'Back' then
            a5 = a4 + math.pi
        elseif aC.aaYaw == 'Backwards' then
            a5 = a4 + math.pi
        elseif aC.aaYaw == 'Sideways' then
            a5 = a4 + math.pi / 2
        elseif aC.aaYaw == 'Spin' then
            aX = D(aX + math.rad(aC.aaSpin))
            a5 = aX
        elseif aC.aaYaw == 'Jitter' then
            a_ = a_ + 1

            if a_ >= math.max(aC.aaJitterDelay, 1) then
                a_ = 0
                aY = not aY
            end

            a5 = (a4 + math.pi) + (aY and 1 or -1) * math.rad(aC.aaJitter)
        end

        a5 = D(a5)

        local a6 = a2.Move

        if typeof(a6) == 'Vector2' and a6.Magnitude > 0 then
            local a7 = (CFrame.Angles(0, a3, 0)):VectorToWorldSpace(Vector3.new(a6.X, 0, a6.Y))
            local a8 = (CFrame.Angles(0, a5, 0)):VectorToObjectSpace(a7)

            a2.Move = Vector2.new(math.clamp(a8.X, -1, 1), math.clamp(a8.Z, -1, 1))
        end

        a2.LookYaw = a5

        if aC.aaPitch == 'Down' then
            a2.VerticalLook = -1
        elseif aC.aaPitch == 'Up' then
            a2.VerticalLook = 1
        elseif aC.aaPitch == 'Jitter' then
            a0 = a0 + 1

            if a0 >= math.max(aC.aaJitterDelay, 1) then
                a0 = 0
                aZ = not aZ
            end

            a2.VerticalLook = aZ and 1 or -1
        end
    end

    local a2, a3, a4, a5, a6, a7 = require(L.MovementV2.Buttons), nil, false, false, 0, RaycastParams.new()

    a7.FilterType = Enum.RaycastFilterType.Exclude
    a3 = function(a8)
        local a9, ba = a8.HumanoidRootPart, a8.GlobalVelocity

        if not a9 or typeof(ba) ~= 'Vector3' then
            return false
        end

        local bb = Vector3.new(ba.X, 0, ba.Z)

        if bb.Magnitude < 4 then
            return false
        end

        a7.FilterDescendantsInstances = {
            _.Character,
            at,
            workspace:FindFirstChild'Debris',
        }

        local bc = (a9.Position + bb * (2 / aS)) + bb.Unit * 0.6

        return workspace:Raycast(bc, Vector3.new(0, -4.5, 0), a7) == nil
    end

    local a8, a9 = 0, 0

    local function o(ba, bb)
        if not aC.landBrake or type(bb) ~= 'table' then
            return
        end

        local bc = j()
        local bd = bc.BunnyHopPenaltyThreshold or 0

        if bd <= 0 then
            return
        end

        local be, bf = bb.Velocity, bb.Position

        if typeof(be) ~= 'Vector3' or typeof(bf) ~= 'Vector3' or be.Y > 0 then
            return
        end

        local bg, bh = math.sqrt(be.X * be.X + be.Z * be.Z), bd - 0.15

        if bg <= bh then
            return
        end

        local bi = 1 / aS

        a7.FilterDescendantsInstances = {
            _.Character,
            at,
            workspace:FindFirstChild'Debris',
        }

        local bj = bf + Vector3.new(be.X, 0, be.Z) * (4 * bi)
        local bk = workspace:Raycast(bj + Vector3.new(0, 3, 0), Vector3.new(0, -90, 0), a7)

        if not bk then
            return
        end

        local bl, bm, bn = (bf.Y - bk.Position.Y) - a8, be.Y, 0

        while bn < 48 do
            bm = bm - bc.Gravity * bi
            bl = bl + bm * bi

            if bl <= 0 then
                break
            end

            bn = bn + 1
        end

        local bo = bc.MaxSpeed

        if type(bb.BaseMoveSpeed) == 'number' then
            bo = math.clamp(bb.BaseMoveSpeed, 0, bc.MaxBaseMoveSpeed or bb.BaseMoveSpeed)
        end

        local bp = 1

        if type(bb.Stamina) == 'number' then
            bp = math.clamp((bb.Stamina + (bc.StaminaRecoveryRate or 0) * bi) / math.max(bc.StaminaMax or 100, 1), 0, 1)
        end

        local bq = (((bc.AirAccelerate * bo) * bp) * bp) * bi

        if bq <= 0.01 then
            return
        end

        local br = bg - bh

        if bn > math.ceil(br / bq) + 1 then
            return
        end

        local bs, bt = math.clamp(((bh * bh - bg * bg) - bq * bq) / ((2 * bg) * bq), 
-1, 1), math.atan2(-be.X, -be.Z)
        local bu = bt + math.acos(bs)
        local bv = Vector3.new(-math.sin(bu), 0, -math.cos(bu))
        local bw = (CFrame.Angles(0, ba.LookYaw, 0)):VectorToObjectSpace(bv)

        ba.Move = Vector2.new(math.clamp(bw.X, -1, 1), math.clamp(bw.Z, -1, 1))
    end

    local ba

    ba = Q(ax.SampleInput, function(bb, ...)
        local bc = not aa.unloaded and (not m() and (aC.bhop and aR or aC.speed))

        if not aa.unloaded and (aC.longJump and (bb.OnGround and (not m() and a3(bb)))) then
            bb.JumpPulsePending = true
            a4 = true
        end

        local bd, be = ..., ba(bb, ...)

        if aa.unloaded or be == nil then
            return be
        end
        if bc then
            local bf = bb.OnGround == true and not aW

            be.Buttons = a2.with(be.Buttons, a2.Jump, bf)
            aW = bf
        else
            aW = false
        end

        local bf = bb.OnGround == true

        if a5 and (not bf and (aC.boostJump or a4)) then
            a6 = aC.duckTicks
        end
        if bf then
            a4 = false
        end

        a5 = bf

        if a6 > 0 and not bf then
            a6 = a6 - 1
            be.Buttons = a2.with(be.Buttons, a2.Duck, true)
        elseif bf then
            a6 = 0
        end

        local bg = type(bd) == 'table' and bd.State or nil

        v(bb, be, bg)

        if bc and type(bg) == 'table' then
            if bf then
                if os.clock() - a9 > 1 and typeof(bg.Position) == 'Vector3' then
                    a9 = os.clock()
                    a7.FilterDescendantsInstances = {
                        _.Character,
                        at,
                        workspace:FindFirstChild'Debris',
                    }

                    local bh = workspace:Raycast(bg.Position + Vector3.new(0, 3, 0), Vector3.new(0, 
-12, 0), a7)

                    if bh then
                        a8 = bg.Position.Y - bh.Position.Y
                    end
                end
            else
                pcall(o, be, bg)
            end
        end
        if aC.speed and (bb.OnGround and (not m() and (typeof(be.Move) == 'Vector2' and be.Move.Magnitude == 0))) then
            be.Move = Vector2.new(0, -1)
        end

        do
            local sh = aa.shitaro

            if sh and not aa.unloaded then
                pcall(sh.sample, bb, bd, be)
            end
        end

        K(be)

        aH.sentYaw, aH.sentPitch = be.LookYaw, be.VerticalLook

        return be
    end)
end

function aa.hookSpeedPenalty()
    if aa.unloaded or aa.speedPenaltyHooked then
        return
    end

    aa.speedPenaltyHooked = true

    local aS

    for aU, aV in ipairs(getgc(true))do
        if type(aV) == 'table' then
            local aW, aX = pcall(rawget, aV, '_accumulatorSeconds')

            if aW and (type(aX) == 'number' and type(rawget(aV, '_options')) == 'table') then
                aS = aV

                break
            end
        end
    end

    local aU = aS and aS._options

    if aU then
        aU.__zbScoped = rawget(aU, '__zbScoped') or aU.ResolveScopedState
        aU.__zbBaseSpeed = rawget(aU, '__zbBaseSpeed') or aU.ResolveBaseMoveSpeed

        local aV, aW, aX = aU.__zbScoped, aU.__zbBaseSpeed, ay.Default and ay.Default.MaxBaseMoveSpeed or 19.5

        if aV then
            aU.ResolveScopedState = function(...)
                if not aa.unloaded and aC.noSpeedPenalty then
                    return false
                end

                return aV(...)
            end
        end
        if aW then
            aU.ResolveBaseMoveSpeed = function(...)
                local aY, aZ = aW(...)

                if not aa.unloaded and (aC.noSpeedPenalty and (type(aY) == 'number' and aY > 0)) then
                    aY = math.max(aY, aX)
                end

                return aY, aZ
            end
        end

        aa.onUnload(function()
            if aV then
                aU.ResolveScopedState = aV
            end
            if aW then
                aU.ResolveBaseMoveSpeed = aW
            end
        end)
    else
        aa.speedPenaltyHooked = false
    end
end

do
    local aS

    aS = Q(av.setWeaponRecoil, function(aU, aV)
        if aa.unloaded or not aC.noRecoil then
            return aS(aU, aV)
        end

        return aS({
            Value = Vector3.zero,
            Damper = aU.Damper,
            Speed = aU.Speed,
        }, aV)
    end)

    local aU

    aU = Q(av.weaponKick, function(aV, aW)
        if aa.unloaded or not aC.noRecoil then
            return aU(aV, aW)
        end

        return aU({
            Value = aV.Value * 0,
            Damper = aV.Damper,
            Speed = aV.Speed,
        }, {
            Value = aW.Value * 0,
            Damper = aW.Damper,
            Speed = aW.Speed,
        })
    end)
end
do
    local aS = 2147483000
    local aU, aV = {
        WindUI = aS,
        ['WindUI/Dropdowns'] = aS + 10,
        ['WindUI/Tooltips'] = aS + 20,
        ['WindUI/Notifications'] = aS + 30,
    }, {}

    local function M()
        local aW = {
            game:GetService'CoreGui',
        }

        if gethui then
            aW[2] = gethui()
        end

        for aX, aY in ipairs(aW)do
            for aZ, a_ in ipairs(aY:GetChildren())do
                local a0 = aU[a_.Name]

                if a0 and (a_:IsA'ScreenGui' and a_.DisplayOrder ~= a0) then
                    if aV[a_] == nil then
                        aV[a_] = a_.DisplayOrder
                    end

                    a_.DisplayOrder = a0
                end
            end
        end
    end

    task.spawn(function()
        while not aa.unloaded do
            if setthreadidentity then
                pcall(setthreadidentity, 8)
            end

            pcall(M)
            task.wait(1)
        end
    end)
    aa.onUnload(function()
        for aW, aX in pairs(aV)do
            pcall(function()
                aW.DisplayOrder = aX
            end)
        end
    end)
end

local aS = Instance.new'Folder'

aS.Name = 'bloxstrikebloxFX'
aS.Parent = at

aa.onUnload(function()
    aS:Destroy()
end)

local aU = RaycastParams.new()

aU.FilterType = Enum.RaycastFilterType.Exclude

local function cT(aV, aW)
    if not aC.wallCheck then
        return true
    end

    local aX = (U()).Position

    aU.FilterDescendantsInstances = {
        _.Character,
        at,
    }

    local aY = workspace:Raycast(aX, aV.Position - aX, aU)

    return aY == nil or aY.Instance:IsDescendantOf(aW)
end

local aV, aW = {
    'Head',
    'UpperTorso',
    'LowerTorso',
    'LeftUpperArm',
    'LeftLowerArm',
    'LeftHand',
    'RightUpperArm',
    'RightLowerArm',
    'RightHand',
    'LeftUpperLeg',
    'LeftLowerLeg',
    'LeftFoot',
    'RightUpperLeg',
    'RightLowerLeg',
    'RightFoot',
}, {
    Head = 'Head',
    UpperTorso = 'Torso',
    LowerTorso = 'Torso',
    HumanoidRootPart = 'Torso',
    Torso = 'Torso',
    LeftUpperArm = 'Arms',
    LeftLowerArm = 'Arms',
    LeftHand = 'Arms',
    RightUpperArm = 'Arms',
    RightLowerArm = 'Arms',
    RightHand = 'Arms',
    LeftUpperLeg = 'Legs',
    LeftLowerLeg = 'Legs',
    LeftFoot = 'Legs',
    RightUpperLeg = 'Legs',
    RightLowerLeg = 'Legs',
    RightFoot = 'Legs',
}

local function bT(aX, aY)
    local aZ, a_ = at:WorldToViewportPoint(aX)

    if not a_ then
        return nil
    end

    return (Vector2.new(aZ.X, aZ.Y) - aY).Magnitude
end
local function aT()
    local aX, aY = at.ViewportSize / 2, aC.aimPart
    local aZ, a_, a0, a1 = aY == 'Closest to Crosshair' or aY == 'Random', (aC.fov)

    for a2, a3 in ipairs(aa.entities())do
        if h(a3) then
            local a4 = F(a3, 'HumanoidRootPart')

            if a4 then
                for a5, a6 in ipairs(aZ and aV or {aY})do
                    local a7 = a4:FindFirstChild(a6)

                    if a7 then
                        local a8 = bT(a7.Position, aX)

                        if a8 and (a8 < a_ and cT(a7, a4)) then
                            a0, a_, a1 = a7, a8, a4
                        end
                    end
                end
            end
        end
    end

    if aY == 'Random' and a1 then
        local a2 = {}

        for a3, a4 in ipairs(aV)do
            local a5 = a1:FindFirstChild(a4)

            if a5 and cT(a5, a1) then
                a2[#a2 + 1] = a5
            end
        end

        if #a2 > 0 then
            return a2[math.random(#a2)]
        end
    end

    return a0
end
local function TT(aX, aY, aZ)
    local a_ = Instance.new'Part'

    a_.Anchored, a_.CanCollide, a_.CanQuery, a_.CanTouch, a_.CastShadow = true, false, false, false, false
    a_.Material = Enum.Material.Neon
    a_.Color = aZ
    a_.Size = aX
    a_.CFrame = aY
    a_.Parent = aS;

    (ap:Create(a_, TweenInfo.new(aC.tracerLife, Enum.EasingStyle.Quad), {Transparency = 1})):Play()
    as:AddItem(a_, aC.tracerLife + 0.1)

    return a_
end

local aX, aY = {}, 0

function drawTracer(aZ, a_, a0)
    local a1 = aZ

    if aC.tracerFrom == 'Gun' then
        local a2 = p()
        local a3 = a2 and (a2.Viewmodel and a2.Viewmodel.Model)
        local a4 = a3 and a3:FindFirstChild('Muzzle', true)

        if a4 and a4:IsA'BasePart' then
            a1 = a4.Position
        elseif a4 and a4:IsA'Attachment' then
            a1 = a4.WorldPosition
        else
            a1 = (U() * CFrame.new(0.35, -0.35, -1.2)).Position
        end
    end

    local a2 = aD

    if aC.tracerRainbow then
        aY = (aY + 0.07) % 1
        a2 = Color3.fromHSV(aY, 0.85, 1)
    end

    local a3, a4, a5 = aC.tracerLife, aC.tracerWidth, (a_ - a1).Magnitude

    if aC.tracer and a5 > 0.5 then
        if aC.tracerStyle == 'Beam' then
            local a6 = Instance.new'Part'

            a6.Anchored, a6.CanCollide, a6.CanQuery, a6.CanTouch = true, false, false, false
            a6.Transparency, a6.Size, a6.CFrame = 1, Vector3.new(0.1, 0.1, 0.1), CFrame.new(a1)
            a6.Parent = aS

            local a7, a8 = Instance.new('Attachment', a6), Instance.new('Attachment', a6)

            a8.WorldPosition = a_

            local a9 = Instance.new'Beam'

            a9.Attachment0, a9.Attachment1 = a7, a8
            a9.Width0, a9.Width1 = a4 * 2.5, a4 * 0.6
            a9.FaceCamera = true
            a9.LightEmission, a9.LightInfluence = 1, 0
            a9.Color = ColorSequence.new(a2)
            a9.Parent = a6

            task.spawn(function()
                local ba = os.clock()

                while a6.Parent and os.clock() - ba < a3 do
                    local bb = (os.clock() - ba) / a3

                    a9.Transparency = NumberSequence.new(bb * 0.9, math.min(1, 0.3 + bb))

                    task.wait(0.03)
                end

                a6:Destroy()
            end)
        elseif aC.tracerStyle == 'Lightning' then
            local a6, a7 = math.clamp(math.floor(a5 / 4), 4, 14), (a_ - a1).Unit
            local a8 = a7:Cross(Vector3.new(0, 1, 0))

            if a8.Magnitude < 0.001 then
                a8 = Vector3.new(1, 0, 0)
            end

            a8 = a8.Unit

            local a9, ba = (a8:Cross(a7)).Unit, a1

            for bb = 1, a6, 1 do
                local bc = a1 + (a_ - a1) * (bb / a6)

                if bb < a6 then
                    bc = (bc + (a8 * (math.random() - 0.5)) * 0.9) + (a9 * (math.random() - 0.5)) * 0.9
                end

                local bd = (bc - ba).Magnitude

                if bd > 0.05 then
                    TT(Vector3.new(a4, a4, bd), CFrame.lookAt((ba + bc) / 2, bc), a2)
                end

                ba = bc
            end
        else
            TT(Vector3.new(a4, a4, a5), CFrame.lookAt((a1 + a_) / 2, a_), a2)
        end
    end
    if aC.impact and a0 then
        local a6 = aC.impactSize
        local a7 = TT(Vector3.new(a6, a6, a6), CFrame.new(a_), aE)

        if aC.impactGlow then
            local a8 = Instance.new'PointLight'

            a8.Color, a8.Range, a8.Brightness = aE, 6, 2
            a8.Parent = a7
        end
    end
end

local aZ = {
    factor = {},
    samples = {},
    meta = {},
}

do
    local a_ = 'bloxstrike/bloxstrike/damage_calibration.json'

    pcall(function()
        if isfile and isfile(a_) then
            local a0 = ar:JSONDecode(readfile(a_))

            if type(a0) == 'table' then
                aZ.factor, aZ.samples = a0.factor or {}, a0.samples or {}
            end
        end
    end)

    local function E()
        pcall(function()
            if isfolder and (makefolder and not isfolder'bloxstrike/bloxstrike') then
                if not isfolder'bloxstrike' then
                    makefolder'bloxstrike'
                end

                makefolder'bloxstrike/bloxstrike'
            end

            writefile(a_, ar:JSONEncode{
                factor = aZ.factor,
                samples = aZ.samples,
            })
        end)
    end

    local a0, a1 = false, false

    local function z()
        a0 = true

        if a1 then
            return
        end

        a1 = true

        task.delay(10, function()
            a1 = false

            if a0 and not aa.unloaded then
                a0 = false

                E()
            end
        end)
    end

    aa.onUnload(function()
        if a0 then
            a0 = false

            E()
        end
    end)

    function aZ.key(a2, a3, a4)
        return tostring(a2) .. ('|' .. (tostring(a3) .. ('|' .. ((a4 or 0) > 0 and 'wall' or 'open'))))
    end
    function aZ.get(a2)
        return math.clamp(aZ.factor[a2] or 1, 0.6, 1.4)
    end
    function aZ.expect(a2, a3, a4)
        aZ.meta[a2] = {
            key = a3,
            raw = a4,
            at = os.clock(),
        }
    end
    function aZ.observe(a2, a3, a4)
        local a5 = aZ.meta[a2]

        aZ.meta[a2] = nil

        if not a5 or os.clock() - a5.at > 1.5 or not a5.raw or a5.raw <= 0 then
            return
        end
        if a4 and a5.raw >= a4 then
            return
        end

        local a6, a7 = math.clamp(a3 / a5.raw, 0.05, 2), (aZ.samples[a5.key] or 0) + 1
        local a8, a9 = aZ.factor[a5.key] or a6, a7 <= 3 and 1 / a7 or 0.3

        aZ.factor[a5.key] = a8 + (a6 - a8) * a9
        aZ.samples[a5.key] = a7

        z()
    end
    function aZ.reset()
        aZ.factor, aZ.samples, aZ.meta = {}, {}, {}

        z()
    end
end

local a_ = {}

do
    local a0, a1, a2, a3, a4, a5, a6, a7 = 0.8, 4, 1, 8, {
        hit = Color3.fromRGB(88, 170, 255),
        kill = Color3.fromRGB(255, 86, 110),
        miss = Color3.fromRGB(150, 150, 160),
    }, {
        Head = 'head',
        UpperTorso = 'body',
        LowerTorso = 'body',
        HumanoidRootPart = 'body',
        LeftUpperArm = 'arm',
        LeftLowerArm = 'arm',
        LeftHand = 'arm',
        RightUpperArm = 'arm',
        RightLowerArm = 'arm',
        RightHand = 'arm',
        LeftUpperLeg = 'leg',
        LeftLowerLeg = 'leg',
        LeftFoot = 'leg',
        RightUpperLeg = 'leg',
        RightLowerLeg = 'leg',
        RightFoot = 'leg',
    }, {}, Instance.new'Frame'

    a7.Name = 'bloxstrikebloxHitLog'
    a7.AnchorPoint = Vector2.new(0.5, 0)
    a7.Position = UDim2.new(0.5, 0, 0.5, 70)
    a7.Size = UDim2.fromOffset(0, 0)
    a7.AutomaticSize = Enum.AutomaticSize.XY
    a7.BackgroundTransparency = 1
    a7.Parent = aL

    local a8 = Instance.new('UIListLayout', a7)

    a8.Padding = UDim.new(0, 0)
    a8.HorizontalAlignment = Enum.HorizontalAlignment.Center
    a8.SortOrder = Enum.SortOrder.LayoutOrder

    local a9, ba, bb = 0, {}, {
        hit = Color3.fromRGB(255, 255, 255),
        head = Color3.fromRGB(255, 60, 60),
        kill = Color3.fromRGB(255, 60, 60),
        miss = Color3.fromRGB(255, 95, 95),
    }

    local function N(bc, bd)
        if not aC.hitLogs then
            return
        end
        if setthreadidentity then
            pcall(setthreadidentity, 8)
        end

        a9 = a9 + 1

        local be = Instance.new'TextLabel'

        be.LayoutOrder = -a9
        be.Size = UDim2.fromOffset(0, 16)
        be.AutomaticSize = Enum.AutomaticSize.X
        be.BackgroundTransparency = 1
        be.Font = Enum.Font.GothamBold
        be.TextSize = 13
        be.TextColor3 = bb[bc] or bb.hit
        be.TextStrokeColor3 = Color3.new(0, 0, 0)
        be.TextStrokeTransparency = 0.4
        be.Text = bd
        be.Parent = a7

        table.insert(ba, be)

        while#ba > a3 do
            local bf = table.remove(ba, 1)

            bf:Destroy()
        end

        task.delay(a1, function()
            if not be.Parent then
                return
            end

            (ap:Create(be, TweenInfo.new(a2, Enum.EasingStyle.Linear), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })):Play()
            task.delay(a2, function()
                local bf = table.find(ba, be)

                if bf then
                    table.remove(ba, bf)
                end

                be:Destroy()
            end)
        end)
    end

    local bc = {}

    pcall(function()
        local bd = require(L.Controllers.HordeController)

        aa.connect(bd.HitConfirmed, function(be, bf)
            local bg = table.remove(bc, 1)

            if not bg then
                return
            end

            local bh = be and 'head' or a5[bg.part] or 'body'

            if bh == 'head' and not be then
                bh = 'body'
            end
            if a_.onConfirm then
                pcall(a_.onConfirm, bf and 'kill' or 'hit', bg.plr, 0, bg.plr.Character, bg.pos)
            end
            if bf then
                N('kill', ('killed zombie - %s'):format(bh))
            else
                N(bh == 'head' and 'head' or 'hit', ('hit zombie in the %s'):format(bh))
            end
        end)
    end)

    function a_.shot(bd, be, bf)
        if not bd then
            return
        end
        if type(bd) == 'table' and bd.IsZombie then
            bc[#bc + 1] = {
                at = os.clock(),
                part = be or '?',
                pos = bf,
                plr = bd,
            }

            return
        end
        if a6[bd] then
            return
        end

        local bg = bd.Character

        a6[bd] = {
            at = os.clock(),
            part = be or '?',
            hp = bg and tonumber(bg:GetAttribute'Health') or 100,
            pos = bf,
        }
    end

    aa.connect(O.Heartbeat, function()
        local bd = os.clock()

        while bc[1] and bd - bc[1].at > a0 do
            local be = table.remove(bc, 1)

            N('miss', ('missed zombie in the %s due to server'):format(a5[be.part] or 'body'))
        end

        if next(a6) == nil then
            return
        end
        if setthreadidentity then
            pcall(setthreadidentity, 8)
        end

        for be, bf in pairs(a6)do
            local bg = be.Parent and be.Character
            local bh, bi = bg and tonumber(bg:GetAttribute'Health'), a5[bf.part] or 'body'

            if not bg then
                a6[be] = nil
            elseif bg:GetAttribute'Dead' == true or bh and bh <= 0 then
                aK[be] = nil

                if a_.onConfirm then
                    pcall(a_.onConfirm, 'kill', be, bf.hp, bg, bf.pos)
                end

                N('kill', ('killed %s - %s, %d dmg'):format(be.DisplayName, bi, math.floor(bf.hp + 0.5)))

                a6[be] = nil
            elseif bh and bh < bf.hp then
                aZ.observe(be, bf.hp - bh, bf.hp)

                aK[be] = nil

                if a_.onConfirm then
                    pcall(a_.onConfirm, 'hit', be, bf.hp - bh, bg, bf.pos)
                end

                N(bi == 'head' and 'head' or 'hit', ('hit %s in the %s for %d (%d left)'):format(be.DisplayName, bi, math.floor((bf.hp - bh) + 0.5), math.floor(bh + 0.5)))

                a6[be] = nil
            elseif bd - bf.at > a0 then
                aK[be] = (aK[be] or 0) + 1

                N('miss', ('missed %s in the %s due to server'):format(be.DisplayName, bi))

                a6[be] = nil
            end
        end
    end)
end

local a0, a1 = require(L.Components.Common.GetRayIgnore), {at = 0}

local function GT()
    local a2, a3 = os.clock(), _.Character

    if a1.list and (a1.char == a3 and a2 - a1.at < 0.1) then
        return a1.list
    end

    a1.at, a1.char = a2, a3

    local a4, a5 = pcall(a0)
    local a6 = {}

    a1.list = a6

    if a4 and type(a5) == 'table' then
        for a7, a8 in ipairs(a5)do
            a6[#a6 + 1] = a8
        end
    end

    a6[#a6 + 1] = _.Character
    a6[#a6 + 1] = at

    return a6
end
local function JT(a2, a3, a4, a5)
    local a6 = a4[#a4]
    local a7, a8 = a6 and a6.Position or a2 + a3 * a5, false

    for a9, ba in ipairs(a4)do
        local bb = ba.Instance and MT(ba.Instance)

        if bb and (bb ~= _ and not k(bb)) then
            a8 = true

            break
        end
    end

    if (aC.tracer or aC.impact) and (a8 or not aC.tracerOnlyHits) then
        pcall(drawTracer, a2, a7, a6 ~= nil)
    end

    for a9, ba in ipairs(a4)do
        local bb = ba.Instance and MT(ba.Instance)

        if bb and (bb ~= _ and not k(bb)) then
            aX[bb] = os.clock()

            a_.shot(bb, ba.Instance.Name, ba.Position)

            if aC.hitSound then
                zT(aC.hitSoundId, aC.hitVol)
            end

            break
        end
    end
end

aa.connect(O.Heartbeat, function()
    for a2, a3 in pairs(aX)do
        local a4 = a2.Parent and a2.Character

        if os.clock() - a3 > 1.5 then
            aX[a2] = nil
        elseif not a4 or a4:GetAttribute'Dead' then
            aX[a2] = nil

            if aC.killSound then
                zT(aC.killSoundId, aC.killVol)
            end
        end
    end
end)

local a2 = require(L.Database.Security.Remotes)

local function ST(a3, a4)
    return {
        Instance = a3.Instance,
        Position = a3.Position,
        Normal = a3.Normal,
        Material = a3.Material.Name,
        Exit = a4 == true,
    }
end
local function YT(a3, a4)
    return {
        Instance = a3,
        Position = a3.Position,
        Normal = -a4,
        Material = a3.Material.Name,
        Exit = false,
    }
end

local a3, a4 = {
    [Enum.Material.Plastic] = 10,
    [Enum.Material.SmoothPlastic] = 10,
    [Enum.Material.Wood] = 10,
    [Enum.Material.WoodPlanks] = 10,
    [Enum.Material.Cardboard] = 10,
    [Enum.Material.Glass] = 25,
    [Enum.Material.Fabric] = 25,
}, {
    ['Sandy Brick'] = 0,
    IndoorWall = 0,
}

local function BT(a5)
    if a5 ~= 0 then
        return a5
    end
    if workspace:GetAttribute'Map' == 'Reactor' then
        return -1
    end

    return a5
end
local function sT(a5)
    local a6 = a5.Parent

    if a6 and a6:HasTag'BreakableDoor' then
        return Enum.Material.Metal
    end

    return a5.Material
end
local function gT(a5)
    return a5:FindFirstAncestorWhichIsA'Accessory' ~= nil or a5:HasTag'CharacterAccessory' or a5.Name == 'CollisionCapsule' or a5.Name == 'HumanoidRootPart'
end

local a5 = RaycastParams.new()

a5.FilterType = Enum.RaycastFilterType.Exclude
a5.CollisionGroup = 'Bullet'

local a6 = RaycastParams.new()

a6.FilterType = Enum.RaycastFilterType.Include
a6.CollisionGroup = 'Bullet'

local a7 = {
    server = false,
    notified = false,
}

pcall(function()
    a7.router = require(L.Database.Security.Router)
end)

function a7.viewTick()
    if not a7.router then
        return nil
    end

    local a8, a9 = pcall(a7.router.broadcastRouter, 'GetRemoteViewTick')

    return a8 and (type(a9) == 'number' and a9) or nil
end
function a7.setServerHits(a8)
    a7.server = a8
end

pcall(function()
    local a8 = require(L.Shared.Raycast)

    if type(a8) == 'table' and type(rawget(a8, 'castThroughDistance')) == 'function' then
        a7.setServerHits(true)
    end
end)
task.spawn(function()
    for a8 = 1, 40, 1 do
        if aa.unloaded or a7.server then
            return
        end
        if a7.viewTick() then
            a7.setServerHits(true)

            return
        end

        task.wait(3)
    end
end)

local function uT(a8)
    if a7.server then
        return a8 and a8.Penetration or 0
    end
    if aC.wallLimit then
        return math.huge
    end
    if aC.penMod then
        return aC.penValue
    end

    return a8 and a8.Penetration or 0
end
local function UT(a8, a9, ba, bb, bc, bd)
    a5.FilterDescendantsInstances = GT()

    if bd then
        local be = workspace:FindFirstChild'Characters'

        if be then
            a5:AddToFilter(be)
        end
    end

    local be, bf, bg, bh, bi = {}, {}, {}, a8, 0

    for bj = 1, 64, 1 do
        local bk = ba - (bh - a8).Magnitude

        if bk <= 0 then
            break
        end

        local bl = workspace:Raycast(bh, a9 * bk, a5)

        if not bl then
            break
        end

        a5:AddToFilter(bl.Instance)

        if not gT(bl.Instance) then
            be[#be + 1] = ST(bl)

            if bc and bl.Instance:IsDescendantOf(bc) then
                return be, true, bi
            end
            if bb == math.huge then
                bi = bi + 1
                bh = bl.Position + a9 * 0.01
            else
                a6.FilterDescendantsInstances = {
                    bl.Instance,
                }

                local bm = bl.Position + a9 * 1000
                local bn = workspace:Raycast(bm, bl.Position - bm, a6)

                if not bn then
                    return be, false, bi, true
                end

                local bo, bp, bq = (bl.Position - bn.Position).Magnitude, bl.Instance.MaterialVariant, nil

                if bp ~= '' and a4[bp] ~= nil then
                    bg[bp] = (bg[bp] or 0) + bo
                    bq = BT(a4[bp]) + bb

                    if bg[bp] > bq then
                        return be, false, bi, true
                    end
                else
                    local br = sT(bl.Instance)

                    bf[br] = (bf[br] or 0) + bo
                    bq = BT(a3[br] or 0) + bb

                    if bf[br] > bq then
                        return be, false, bi, true
                    end
                end

                be[#be + 1] = ST(bn, true)
                bi = bi + 1
                bh = bn.Position + a9 * 0.001
            end
        end
    end

    return be, false, bi
end
local function DT(a8, a9, ba, bb, bc, bd)
    local be = bc and bc.Parent
    local bf, bg = UT(a8, a9, ba, bb, be)

    if bd and (not a7.server and (bc and not bg)) then
        bf[#bf + 1] = YT(bc, a9)
    end

    return bf
end
local function mT(a8, a9, ba, bb)
    local bc = a9 - a8
    local bd = bc.Magnitude

    if bd < 0.05 or bd > ba then
        return false, 0
    end

    local be, bf, bg, bh = UT(a8, bc.Unit, bd, bb, nil, true)

    if bh then
        return false, bg
    end

    return true, bg, be
end
local function jT(a8, a9, ba, bb, bc, bd)
    local be, bf, bg = mT(a8, a9, bb, bc)

    if not be then
        if not bd or a7.server then
            return nil
        end

        bg = {}
    end

    local bh = (a9 - a8).Unit

    bg[#bg + 1] = {
        Instance = ba,
        Position = a9,
        Normal = -bh,
        Material = ba.Material.Name,
        Exit = false,
    }

    return bg
end
local function kT(a8, a9)
    local ba = a8

    for bb, bc in ipairs(a9)do
        bc.Distance = (bc.Position - ba).Magnitude
        ba = bc.Position
    end

    return a9
end

local a8 = 0

local function FT(a9)
    local ba = a9 and a9.Properties

    if not (aC.revolverAlt and (ba and ba.ShootingOptions == 'Revolver')) then
        return nil
    end

    local bb = ba.FireModes

    return type(bb) == 'table' and (type(bb.Secondary) == 'table' and bb.Secondary) or nil
end
local function tT(a9)
    local ba = FT(a9)

    if ba and type(ba.FireRate) == 'number' then
        return ba.FireRate
    end

    return a9.Properties and a9.Properties.FireRate or 0.1
end
local function OT(a9)
    local ba = os.clock()

    if ba - a8 < 0.016666666666667 then
        return
    end

    a8 = ba

    local bb, bc = a9.Viewmodel and a9.Viewmodel.Animation, FT(a9)

    task.spawn(function()
        if setthreadidentity then
            pcall(setthreadidentity, 2)
        end
        if bb then
            local bd = false

            if bc and type(bc.Animation) == 'string' then
                bd = pcall(function()
                    bb:play(bc.Animation)
                end)
            end
            if not bd then
                pcall(function()
                    bb:play(bb:pickVariant'Shoot' or 'Shoot')
                end)
            end
        end
        if bc and type(bc.CharacterAnimation) == 'string' then
            pcall(function()
                (require(L.Components.Common.ReplicateCharacterAction))(bc.CharacterAnimation)
            end)
        end
    end)
end
local function LT()
    local a9 = U()

    if not aC.originOn then
        return a9.Position
    end

    local ba, bb = a9:ToEulerAnglesYXZ()

    return a9.Position + (CFrame.Angles(0, bb, 0)):VectorToWorldSpace(Vector3.new(aC.originX, aC.originY, aC.originZ))
end

local a9 = {
    params = RaycastParams.new(),
    last = setmetatable({}, {
        __mode = 'k',
    }),
}

a9.params.FilterType = Enum.RaycastFilterType.Exclude
a9.params.CollisionGroup = 'Bullet'

local function EU(ba)
    if not aC.bulletTp or not ba or not ba.Parent then
        return nil
    end

    local bb = ba.Position
    local bc = (U()).Position - bb
    local bd = Vector3.new(bc.X, 0, bc.Z)

    bd = bd.Magnitude > 0.01 and bd.Unit or Vector3.new(0, 0, 1)

    local be, bf, bg = bd:Cross(Vector3.new(0, 1, 0)), Vector3.new(0, 1, 0), aC.bulletTpDist
    local bh = {
        bd,
        (bd + bf).Unit,
        bf,
        be,
        -be,
        (bd + be).Unit,
        (bd - be).Unit,
        -bd,
    }

    if a9.stamp ~= a1.at or not a1.list then
        a9.params.FilterDescendantsInstances = GT()
        a9.stamp = a1.at
    end

    local bi, bj = ba.Parent, a9.last[ba] or 1

    for bk = 0, #bh - 1, 1 do
        local bl = ((bj - 1) + bk) % #bh + 1
        local bm = bh[bl]
        local bn = bb + bm * bg
        local bo = workspace:Raycast(bn, bm * -(bg + 2), a9.params)

        if bo and bo.Instance:IsDescendantOf(bi) then
            a9.last[ba] = bl

            return bn
        end
    end

    return nil
end

do
    local ba = Instance.new'Part'

    ba.Shape = Enum.PartType.Ball
    ba.Size = Vector3.new(0.35, 0.35, 0.35)
    ba.Anchored, ba.CanCollide, ba.CanQuery, ba.CanTouch, ba.CastShadow = true, false, false, false, false
    ba.Material = Enum.Material.Neon
    ba.Color = Color3.fromRGB(190, 120, 255)
    ba.Transparency = 1
    ba.Parent = aS

    aa.connect(O.RenderStepped, function()
        local bb = aC.originOn and (aC.originMarker and (aC.rage or aC.killAll or aC.loopKill))

        ba.Transparency = bb and 0.3 or 1

        if bb then
            ba.CFrame = CFrame.new(LT())
        end
    end)
end

local ba, bb, bc = setmetatable({}, {
    __mode = 'k',
}), setmetatable({}, {
    __mode = 'k',
}), 0.6

do
    local bd = setmetatable({}, {
        __mode = 'k',
    })

    aa.connect(O.Heartbeat, function(be)
        if be <= 0 then
            return
        end

        for bf, bg in ipairs(aa.entities())do
            local bh = bg ~= _ and bg.Character
            local bi = bh and bh:FindFirstChild'HumanoidRootPart'

            if bi then
                local bj, bk = bi.Position, bd[bg]

                if bk then
                    local bl = (bj - bk) / be

                    if bl.Magnitude > 80 then
                        bl = Vector3.zero
                    end

                    ba[bg] = (ba[bg] or bl):Lerp(bl, 0.35)
                end

                bd[bg] = bj

                if aC.backtrack then
                    local bl = bb[bg]

                    if not bl then
                        bl = {}
                        bb[bg] = bl
                    end

                    local bm = {
                        t = os.clock(),
                        pos = {},
                    }

                    for bn, bo in ipairs(aV)do
                        local bp = bh:FindFirstChild(bo)

                        if bp then
                            bm.pos[bo] = bp.Position
                        end
                    end

                    bm.pos.HumanoidRootPart = bj
                    bl[#bl + 1] = bm

                    while bl[1] and bm.t - bl[1].t > bc do
                        table.remove(bl, 1)
                    end
                elseif bb[bg] then
                    bb[bg] = nil
                end
            else
                bd[bg], ba[bg] = nil, nil
            end
        end
    end)
end

local function zU(bd)
    local be = aC.predictMs or 0

    if be <= 0 or not bd.Parent then
        return bd.Position
    end

    local bf = aa.ownerOf(bd.Parent)
    local bg = bf and ba[bf]

    if not bg then
        return bd.Position
    end

    return bd.Position + Vector3.new(bg.X, bg.Y * 0.5, bg.Z) * (be / 1000)
end
local function xU(bd, be, bf, bg)
    local bh = bd.Properties

    if not (bh and (bd.Identifier and be)) then
        return false
    end

    local bi = a7.server

    if bi then
        bg = nil
    end

    local bj, bk, bl, bm = {}, not bg and EU(be) or LT(), bh.Range or 500, uT(bh)
    local bn, bo = ((bg or zU(be)) - bk).Unit, {}

    for bp = 1, math.max(bh.BulletsPerShot or 1, 1), 1 do
        local bq

        if bg then
            bq = jT(bk, bg, be, bl, bm, bf)

            if not bq then
                return false
            end
        else
            bq = DT(bk, bn, bl, bm, be, bf)
        end
        if bi then
            local br = bq[#bq]

            if not (br and (br.Instance and br.Instance:IsDescendantOf(be.Parent))) then
                return false
            end

            bo[#bo + 1] = {
                Direction = bn,
                Origin = bk,
            }
        else
            bo[#bo + 1] = {
                Direction = bn,
                Origin = bk,
                Hits = kT(bk, bq),
            }
        end

        bj[#bj + 1] = bq
    end

    bd.ShotSeq = (bd.ShotSeq or 0) + 1

    local bp = {
        IsSniperScoped = bd.IsSniperScoped,
        ShootingHand = bd.ShootingHand,
        Identifier = bd.Identifier,
        Seq = bd.ShotSeq,
        Bullets = bo,
        ViewTick = bi and a7.viewTick() or nil,
        __bloxstrikeblox = bj,
    }
    local bq = pcall(a2.Inventory.ShootWeapon.Send, bp)

    if bq then
        bd.Rounds = math.max((bd.Rounds or 1) - 1, 0)
        bd.RechargeStartTime = workspace:GetServerTimeNow()

        OT(bd)
    end

    return bq
end

local bd = require(L.Database.Components.GameState)

local function lU()
    if not aC.killAllWaitRound then
        return true
    end

    local be, bf = pcall(bd.GetStateAtTime, workspace:GetServerTimeNow() + (aC.killAllLeadMs or 0) / 1000)

    return be and bf == 'Round In Progress'
end
local function rU(be, bf, bg)
    local bh = be.Properties
    local bi, bj = bh and bh.Range or 3, (U()).Position
    local bk = bg.Position - bj
    local bl = bk.Magnitude > 0 and bk.Unit or (U()).LookVector
    local bm = pcall(a2.Melee.MeleeAttack.Send, {
        Direction = bl * bi,
        Material = bg.Material.Name,
        Distance = math.min(bk.Magnitude, bi),
        Instance = bg,
        Position = bg.Position,
        Normal = -bl,
        MeleeAttack = 'BackStab',
        Identifier = be.Identifier,
    })

    if bm then
        a_.shot(bf, bg.Name)
    end

    return bm
end

do
    local be = setmetatable({}, {
        __mode = 'k',
    })

    aa.connect(O.Heartbeat, function()
        if not aC.knifeKillAll or m() or not lU() then
            return
        end

        local bf = p()
        local bg = bf and bf.Properties

        if not (bg and (bf.Identifier and (not bf.Bullet and bg.Class == 'Melee'))) then
            return
        end

        local bh, bi = (U()).Position, os.clock()

        for bj, bk in ipairs(aa.entities())do
            if ET(bk) then
                local bl = F(bk, 'UpperTorso')

                if bl and (not t(bl) and bi - (be[bk] or 0) >= aC.killAllDelay) then
                    local bm = bl.UpperTorso

                    if (bm.Position - bh).Magnitude <= aC.knifeReach then
                        if rU(bf, bk, bm) then
                            be[bk] = bi
                        end
                    end
                end
            end
        end
    end)
end

local function yU(be)
    local bf = be.Properties

    if not (bf and (bf.Rounds and be.Identifier)) then
        return false
    end

    local bg, bh, bi = workspace:GetAttribute'Gamemode' == 'Deathmatch', be.Capacity or 0, bf.Rounds - (be.Rounds or 0)
    local bj = bg and bi or math.min(bi, bh)

    if bj <= 0 then
        return false
    end

    local bk = pcall(a2.Inventory.ReloadWeapon.Send, {
        Identifier = be.Identifier,
        Capacity = bh,
        Rounds = be.Rounds,
    })

    if bk then
        be.Rounds = (be.Rounds or 0) + bj

        if not bg then
            be.Capacity = bh - bj
        end
    end

    return bk
end

local be = setmetatable({}, {
    __mode = 'k',
})

local function qU(bf)
    local bg = bf and bf.WeaponEquippedTick

    if type(bg) ~= 'number' then
        return true
    end

    local bh = be[bf]

    if not bh then
        bh = 0.5

        pcall(function()
            local bi = bf.Viewmodel.Animation:getAnimation'Equip'

            if bi and (type(bi.Length) == 'number' and bi.Length > 0) then
                bh = bi.Length
                be[bf] = bh
            end
        end)
    end

    return tick() - bg > bh * 0.925 + 0.03
end
local function vU(bf, bg)
    if bf then
        if mouse1release then
            mouse1release()
        end
        if mouse1press then
            mouse1press()
        end
    elseif FT(bg) and mouse2click then
        mouse2click()
    elseif mouse1click then
        mouse1click()
    end
end

local bf, bg, bh

do
    local bi = {
        Head = {
            'Head',
        },
        Body = {
            'UpperTorso',
            'LowerTorso',
            'HumanoidRootPart',
        },
        Multipoint = {
            'Head',
            'UpperTorso',
            'LowerTorso',
            'HumanoidRootPart',
        },
        ['Full Body'] = aV,
    }

    local function E(bj, bk, bl, bm, bn)
        local bo = (bk.Position - bj).Unit
        local bp, bq, br = UT(bj, bo, bn, bm, bl)

        if bq then
            if br > 0 and (not aC.rageAutowall and (a7.server or not aC.wallbang and not aC.wallLimit)) then
                return false, 0
            end

            return true, br
        end
        if aC.wallbang and not a7.server then
            local bs, bt, bu = UT(bj, bo, bn, math.huge, bl)

            return true, bu
        end

        return false, 0
    end

    local bj = 0.075

    local function z(bk)
        local bl = bk:GetAttribute'Armor'

        if type(bl) ~= 'string' then
            return 0, false
        end

        local bm, bn = pcall(ar.JSONDecode, ar, bl)

        if not bm or type(bn) ~= 'table' then
            return 0, false
        end

        return tonumber(bn.Health) or 0, type(bn.Type) == 'string' and bn.Type:find'Helmet' ~= nil
    end
    local function x(bk, bl, bm, bn, bo)
        local bp, bq = aW[bl], bk.DamagePerPart

        if not bp or type(bq) ~= 'table' or not bq[bp] then
            return 0
        end

        local br = bq[bp]

        br = br * (bk.RangeModifier or 1) ^ ((bm / bj) / 500)

        if bn > 0 then
            br = br * (bk.WallbangMultiplier or 0.5) ^ bn
        end

        local bs, bt = z(bo)

        if bs > 0 and (bp ~= 'Legs' and (bp ~= 'Head' or bt)) then
            br = br * (bk.ArmorPenetration or 1)
        end

        return br * (bk.BulletsPerShot or 1)
    end
    local function R(bk, bl, bm, bn)
        local bo = aZ.key(bk, aW[bl], bm)

        if a7.server then
            return bn, bo
        end

        return bn * aZ.get(bo), bo
    end
    local function l()
        return aC.minDmgOverride and aC.minDmgOverrideValue or aC.minDmg
    end

    local bk, bl, bm = nil, 0.004, 1

    local function q(bn)
        local bo, bp, bq = os.clock(), LT(), bn.Properties
        local br, bs, bt = uT(bq), bq.Range or 500, bi[aC.rageHitbox] or bi.Head

        if aC.forceBody then
            bt = bi.Body
        end

        local bu, bv, bw = l(), {}, at.ViewportSize / 2

        for bx, by in ipairs(aa.entities())do
            if ET(by) then
                local bz = F(by, 'HumanoidRootPart')

                if bz and not t(bz) then
                    local bA = (bz.HumanoidRootPart.Position - bp).Magnitude

                    if bA < aC.rageMaxDist then
                        local bB = {
                            player = by,
                            char = bz,
                            dist = bA,
                            hp = tonumber(bz:GetAttribute'Health') or 100,
                        }

                        if aC.rageTargetMode == 'Crosshair' then
                            bB.score = bT(bz.HumanoidRootPart.Position, bw) or math.huge
                        elseif aC.rageTargetMode == 'Lowest HP' then
                            bB.score = bB.hp + bA / 10000
                        else
                            bB.score = bA
                        end
                        if aC.rageSticky and by == bk then
                            bB.score = -math.huge
                        end

                        bv[#bv + 1] = bB
                    end
                end
            end
        end

        table.sort(bv, function(bx, by)
            return bx.score < by.score
        end)

        aC.rageCands = #bv

        local bx, by = {}, #bv
        local bz = bm <= by and bm or 1

        bm = 1

        for bA = 0, by - 1, 1 do
            local bB = ((bz - 1) + bA) % by + 1
            local bC = bv[bB]

            if bA > 0 and os.clock() - bo > bl then
                bm = bB

                break
            end

            local bD, bE = bC.hp, bt

            if aC.missAdapt and (aK[bC.player] or 0) >= aC.missesToBody then
                bE = bi.Body
            end

            local bF, bG = {dmg = 0}, {dmg = 0}

            for bH, bI in ipairs(bE)do
                local bJ = bC.char:FindFirstChild(bI)

                if bJ then
                    local bK = EU(bJ)
                    local bL, bM = bK ~= nil, 0

                    if not bK then
                        bK = bp
                        bL, bM = E(bp, bJ, bC.char, br, bs)

                        if bL and (aC.wallLimit and bM > aC.maxWalls) then
                            bL = false
                        end
                    end
                    if bL then
                        local bN, bO = bK ~= bp and 'TP' or nil, x(bq, bI, (bJ.Position - bK).Magnitude, (aC.wallLimit and not a7.server) and 0 or bM, bC.player)
                        local bP, bQ = R(bn.Name, bI, bM, bO)

                        if bP > bF.dmg then
                            bF = {
                                part = bJ,
                                dmg = bP,
                                raw = bO,
                                key = bQ,
                                walls = bM,
                                track = bN,
                            }
                        end
                        if aW[bI] == 'Torso' and bP > bG.dmg then
                            bG = {
                                part = bJ,
                                dmg = bP,
                                raw = bO,
                                key = bQ,
                                walls = bM,
                                track = bN,
                            }
                        end
                        if bG.dmg >= bD or bF.dmg >= bD and not aC.preferBodyLethal then
                            break
                        end
                    end
                end
            end

            if aC.preferBodyLethal and (bG.part and bG.dmg >= bD) then
                bF = bG
            end

            local bH = bD <= bu and 0 or bu

            if not a7.server and (not (bF.part and (bF.dmg >= bH or bF.dmg >= bD)) and (aC.backtrack or aC.forwardTrack)) then
                local function d(bI, bJ, bK, bL)
                    local bM, bN = mT(bp, bK, bs, br)

                    if not bM or bN > 0 and (not aC.rageAutowall and (not aC.wallbang and not aC.wallLimit)) then
                        return
                    end
                    if aC.wallLimit and bN > aC.maxWalls then
                        return
                    end

                    local bO = x(bq, bI, (bK - bp).Magnitude, aC.wallLimit and 0 or bN, bC.player)
                    local bP, bQ = R(bn.Name, bI, bN, bO)

                    if bP > bF.dmg then
                        bF = {
                            part = bJ,
                            dmg = bP,
                            raw = bO,
                            key = bQ,
                            walls = bN,
                            pos = bK,
                            track = bL,
                        }
                    end
                end

                if aC.backtrack then
                    local bI, bJ = bb[bC.player], os.clock()

                    if bI then
                        for bK = #bI - 1, 1, -2 do
                            local bL = bI[bK]
                            local bM = bJ - bL.t

                            if bM > aC.backtrackMs / 1000 then
                                break
                            end
                            if os.clock() - bo > bl then
                                break
                            end

                            for bN, bO in ipairs(bE)do
                                local bP, bQ = bC.char:FindFirstChild(bO), bL.pos[bO]

                                if bP and bQ then
                                    d(bO, bP, bQ, ('BT %dms'):format(bM * 1000))
                                end
                            end

                            if bF.pos and (bF.dmg >= bH or bF.dmg >= bD) then
                                break
                            end
                        end
                    end
                end
                if aC.forwardTrack and not (bF.pos and (bF.dmg >= bH or bF.dmg >= bD)) then
                    local bI = ba[bC.player]

                    if bI and bI.Magnitude > 1 then
                        for bJ, bK in ipairs{0.5, 1}do
                            if os.clock() - bo > bl then
                                break
                            end

                            local bL = (aC.forwardMs * bK) / 1000

                            for bM, bN in ipairs(bE)do
                                local bO = bC.char:FindFirstChild(bN)

                                if bO then
                                    d(bN, bO, bO.Position + bI * bL, ('FT %dms'):format(bL * 1000))
                                end
                            end

                            if bF.pos and (bF.dmg >= bH or bF.dmg >= bD) then
                                break
                            end
                        end
                    end
                end
            end
            if bF.part and (bF.dmg >= bH or bF.dmg >= bD) then
                bF.player, bF.char, bF.hp = bC.player, bC.char, bD
                bx[#bx + 1] = bF

                if not aC.rageMulti then
                    break
                end
            end
        end

        bk = bx[1] and bx[1].player or nil

        return bx
    end

    local bn, bo = {}, 0

    local function N(bp)
        local bq = os.clock()

        if bq - bo >= 1 / math.max(aC.rageScanHz, 1) then
            bo = bq
            bn = q(bp)
        else
            for br = #bn, 1, -1 do
                local bs = bn[br]

                if not bs.part.Parent or bs.char:GetAttribute'Dead' or t(bs.char) then
                    table.remove(bn, br)
                end
            end
        end

        return bn
    end

    local bp = Instance.new'Highlight'

    bp.FillTransparency = 1
    bp.OutlineColor = Color3.fromRGB(190, 120, 255)
    bp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    bp.Enabled = false
    bp.Parent = aL

    local bq = Instance.new'BillboardGui'

    bq.Size = UDim2.fromOffset(240, 18)
    bq.StudsOffset = Vector3.new(0, 4.2, 0)
    bq.AlwaysOnTop = true
    bq.Enabled = false
    bq.Parent = aL

    local br = Instance.new'TextLabel'

    br.Size = UDim2.fromScale(1, 1)
    br.BackgroundTransparency = 1
    br.Font = Enum.Font.GothamBold
    br.TextSize = 12
    br.TextColor3 = Color3.fromRGB(205, 160, 255)
    br.TextStrokeTransparency = 0.4
    br.Parent = bq

    aa.onUnload(function()
        bp:Destroy()
        bq:Destroy()
    end)

    local function b(bs)
        if setthreadidentity then
            pcall(setthreadidentity, 8)
        end

        local bt = aC.rageIndicator and bs ~= nil

        bp.Enabled = bt
        bq.Enabled = bt

        if not bt then
            return
        end

        bp.Adornee = bs.char
        bq.Adornee = bs.part

        local bu, bv = aK[bs.player] or 0, bs.dmg > 0 and math.ceil(bs.hp / bs.dmg) or 0

        br.Text = ('%s | %d hp | ~%d dmg | %d tap%s%s'):format(bs.player.Name, math.floor(bs.hp + 0.5), math.floor(bs.dmg + 0.5), bv, bs.walls > 0 and ' | ' .. (bs.walls .. (' wall' .. (bs.walls > 1 and 's' or ''))) or '', bu > 0 and ' | ' .. (bu .. ' miss') or '') .. (bs.track and ' | ' .. bs.track or '')
    end

    local bs, bt = 0, setmetatable({}, {
        __mode = 'k',
    })

    local function w(bu)
        if aC.rapidFire and aC.rapidUnlimited then
            return 0
        end

        local bv = tT(bu)

        if aC.rapidFire then
            bv = bv / math.max(aC.rapidMult, 1)
        end

        return bv
    end
    local function e()
        if aC.loopKill and aC.loopTarget then
            local bu = aa.byName(aC.loopTarget)
            local bv = bu and F(bu, 'Head')

            if bv and not t(bv) then
                return bv.Head
            end

            return nil
        end

        return nil
    end

    aa.connect(O.Heartbeat, function()
        bf, bg, bh = nil, nil, nil

        if m() then
            return
        end

        local bu = aC.loopKill and aC.loopTarget ~= nil or aC.killAll

        if not aC.rage and not bu then
            aC.rageStatus = nil

            return
        end

        local bv = p()

        if not bv or not bv.Bullet or not bv.Properties then
            aC.rageStatus = 'NO GUN'

            return
        end
        if aC.killAll and (not bv.IsReloading and (lU() and qU(bv))) then
            local bw = os.clock()

            for bx, by in ipairs(aa.entities())do
                if ET(by) then
                    local bz = F(by, 'Head')

                    if bz and (not t(bz) and bw - (bt[by] or 0) >= aC.killAllDelay) then
                        if (bv.Rounds or 0) <= 0 then
                            yU(bv)
                        end
                        if (bv.Rounds or 0) <= 0 then
                            break
                        end
                        if xU(bv, bz.Head, true) then
                            bt[by] = bw
                        end
                    end
                end
            end
        end

        local bw = e()
        local bx = (not bw and aC.rage) and N(bv) or {}

        b(not bw and bx[1] or nil)

        bg = bw or bx[1] and bx[1].part or nil
        bh = not bw and (bx[1] and bx[1].pos) or nil
        bf = bh or bg and bg.Position

        if not bg then
            aC.rageStatus = (aC.rageCands or 0) > 0 and 'NO LINE' or 'NO TARGET'

            return
        end
        if not (bw or aC.rageAutoFire) then
            aC.rageStatus = 'AUTO OFF'

            return
        end
        if (bv.Rounds or 0) <= 0 or bv.IsReloading then
            aC.rageStatus = bv.IsReloading and 'RELOAD' or 'NO AMMO'

            return
        end
        if not qU(bv) then
            aC.rageStatus = 'EQUIP'

            return
        end
        if aC.rageRemote or bw then
            local by, bz = os.clock(), w(bv)

            if by - bs < bz then
                aC.rageStatus = ('WAIT %.1f'):format(bz - (by - bs))

                return
            end

            aC.rageStatus = 'FIRE'
            bs = by

            local bA = {}

            if bw then
                bA[1] = {part = bw}
            elseif aC.rageMulti then
                bA = bx
            else
                bA[1] = bx[1]
            end

            local bB = {}

            for bC, bD in ipairs(bA)do
                local bE = 1

                if aC.tapKill and (bD.hp and (bD.dmg and bD.dmg > 0)) then
                    bE = math.clamp(math.ceil(bD.hp / bD.dmg), 1, aC.maxTaps)
                end
                if aC.doubleTap and bE < 2 then
                    bE = 2
                end
                if bE > 1 then
                    bD.key = nil
                end

                for bF = 1, bE, 1 do
                    bB[#bB + 1] = bD
                end
            end

            local bC, bD = bz == 0 and (bv.Rounds or 1) or #bB, 0

            while bD < bC do
                local bE = bB[bD % #bB + 1]

                if (bv.Rounds or 0) <= aC.reloadAt and (aC.autoReload and aC.remoteReload) then
                    yU(bv)
                end
                if (bv.Rounds or 0) <= 0 then
                    break
                end
                if bE.player and bE.key then
                    aZ.expect(bE.player, bE.key, bE.raw)
                end

                xU(bv, bE.part, bw ~= nil or aC.wallbang, bE.pos)

                bD = bD + 1
            end

            if aC.doubleTap and (bD >= 2 and bz > 0) then
                bs = by + bz
            end
        elseif not aC.rapidFire and (not bv.IsShooting and not bv.IsFireHeld) then
            vU(false, bv)
        end
    end)
end
do
    local bi = 0

    aa.connect(O.Heartbeat, function()
        if not aC.rapidFire or m() then
            return
        end

        local bj = p()

        if not bj or not bj.Bullet or not bj.Properties then
            return
        end

        local bk, bl = bj.IsFireHeld == true, aC.rage and (aC.rageAutoFire and (bf ~= nil and not aC.rageRemote))

        if not (bk or bl) or (bj.Rounds or 0) <= 0 or bj.IsReloading then
            return
        end

        local bm = aC.rapidUnlimited and 0 or tT(bj) / math.max(aC.rapidMult, 1)

        if os.clock() - bi < bm then
            return
        end
        if bj.ShootDelayThread then
            pcall(task.cancel, bj.ShootDelayThread)
        end

        bj.ShootDelayThread = nil
        bj.IsShooting = false
        bj.NextShotDue = 0
        bi = os.clock()

        vU(bk, bj)
    end)
end
do
    local bi, bj = require(L.Classes.WeaponComponent.Classes.Viewmodel.Classes.Animation), nil

    bj = Q(bi.play, function(bk, bl, ...)
        local bm = bj(bk, bl, ...)

        if not aa.unloaded and (aC.instaReload and (bm and (type(bl) == 'string' and bl:find'^Reload'))) then
            pcall(function()
                bm:AdjustSpeed(aC.reloadSpeed)
            end)
        end

        return bm
    end)

    aa.connect(O.Heartbeat, function()
        if not aC.autoReload then
            return
        end

        local bk = p()
        local bl = bk and (bk.Capacity or 0) > 0 or workspace:GetAttribute'Gamemode' == 'Deathmatch'

        if bk and (bk.Bullet and (bk.Properties and ((bk.Rounds or 0) <= aC.reloadAt and (bl and ((bk.Rounds or 0) < (bk.Properties.Rounds or 0) and (not bk.IsReloading and not bk.IsShooting)))))) then
            if aC.remoteReload then
                yU(bk)
            else
                task.spawn(pcall, bk.reload, bk)
            end
        end
    end)
end
do
    local bi, bj = require(L.Components.Weapon.Classes.Bullet), nil

    bj = Q(bi.getTrueSpread, function(bk, ...)
        if not aa.unloaded and (aC.noSpread or bg ~= nil) then
            return 0
        end

        return bj(bk, ...)
    end)
end
do
    local bi = a2.Inventory and a2.Inventory.ShootWeapon

    if bi and type(bi.Send) == 'function' then
        local bj

        bj = Q(bi.Send, function(bk, ...)
            if aa.unloaded or type(bk) ~= 'table' or type(bk.Bullets) ~= 'table' then
                return bj(bk, ...)
            end
            if bk.__bloxstrikeblox then
                local bl = bk.__bloxstrikeblox

                bk.__bloxstrikeblox = nil

                pcall(function()
                    local bm = p()
                    local bn = bm and (bm.Properties and bm.Properties.Range) or 500

                    for bo, bp in ipairs(bk.Bullets)do
                        JT(bp.Origin, bp.Direction, bp.Hits or type(bl) == 'table' and bl[bo] or {}, bn)
                    end
                end)

                return bj(bk, ...)
            end

            do
                local bl = bk.Bullets[1]

                if type(bl) == 'table' then
                    local bm = bl.Hits == nil

                    if bm ~= a7.server then
                        a7.setServerHits(bm)
                    end
                end
            end

            pcall(function()
                local bl = p()
                local bm = bl and bl.Properties or {}
                local bn, bo, bp = bm.Range or 500, uT(bm), bg

                if not bp and aC.silentAim then
                    bp = aT()
                end

                local bq, br = U(), bp ~= nil or aH.active

                for bs, bt in ipairs(bk.Bullets)do
                    local bu

                    if br then
                        local bv = not a7.server and (bp ~= nil and (bp == bg and bh)) or nil
                        local bw, bx, by = (bp ~= nil and bp == bg) and (not bv and EU(bp) or LT()) or bq.Position, nil, nil

                        if bv then
                            bx = (bv - bw).Unit
                            by = jT(bw, bv, bp, bn, bo, aC.wallbang) or {}
                        else
                            bx = bp and (zU(bp) - bw).Unit or bq.LookVector
                            by = DT(bw, bx, bn, bo, bp, aC.wallbang and bp ~= nil)
                        end

                        bt.Origin, bt.Direction = bw, bx

                        if a7.server then
                            bu = by
                        else
                            bt.Hits = kT(bw, by)
                        end
                    elseif a7.server then
                        if typeof(bt.Origin) == 'Vector3' and (typeof(bt.Direction) == 'Vector3' and bt.Direction.Magnitude > 0) then
                            bu = DT(bt.Origin, bt.Direction.Unit, bn, bo, nil, false)
                        end
                    elseif aC.penMod and (typeof(bt.Origin) == 'Vector3' and (typeof(bt.Direction) == 'Vector3' and bt.Direction.Magnitude > 0)) then
                        bt.Hits = kT(bt.Origin, DT(bt.Origin, bt.Direction.Unit, bn, bo, nil, false))
                    end
                    if bt.Origin and bt.Direction then
                        JT(bt.Origin, bt.Direction, bu or bt.Hits or {}, bn)
                    end
                end
            end)

            return bj(bk, ...)
        end)
    end
end
do
    local bi = Instance.new'Folder'

    bi.Name = 'bloxstrikebloxESP'
    bi.Parent = aL

    local bj = Instance.new'Frame'

    bj.Name = 'ESP2D'
    bj.Size = UDim2.fromScale(1, 1)
    bj.BackgroundTransparency = 1
    bj.Parent = aL

    local bk, bl, bm, bn, bo, bp = {}, Color3.new(0, 0, 0), Color3.fromRGB(90, 255, 110), Color3.fromRGB(255, 60, 60), Color3.fromRGB(90, 170, 255), {
        {
            'Head',
            'UpperTorso',
        },
        {
            'UpperTorso',
            'LowerTorso',
        },
        {
            'UpperTorso',
            'LeftUpperArm',
        },
        {
            'LeftUpperArm',
            'LeftLowerArm',
        },
        {
            'LeftLowerArm',
            'LeftHand',
        },
        {
            'UpperTorso',
            'RightUpperArm',
        },
        {
            'RightUpperArm',
            'RightLowerArm',
        },
        {
            'RightLowerArm',
            'RightHand',
        },
        {
            'LowerTorso',
            'LeftUpperLeg',
        },
        {
            'LeftUpperLeg',
            'LeftLowerLeg',
        },
        {
            'LeftLowerLeg',
            'LeftFoot',
        },
        {
            'LowerTorso',
            'RightUpperLeg',
        },
        {
            'RightUpperLeg',
            'RightLowerLeg',
        },
        {
            'RightLowerLeg',
            'RightFoot',
        },
    }

    local function q(bq, br, bs)
        local bt = Instance.new'Frame'

        bt.BorderSizePixel = 0
        bt.BackgroundColor3 = bs or bl
        bt.Visible = false
        bt.ZIndex = br
        bt.Parent = bq

        return bt
    end
    local function v(bq, br)
        local bs = q(bq, br)

        bs.AnchorPoint = Vector2.new(0.5, 0.5)

        return bs
    end
    local function K(bq)
        local br = Instance.new'TextLabel'

        br.BackgroundTransparency = 1
        br.Font = Enum.Font.GothamBold
        br.TextStrokeTransparency = 0.35
        br.TextStrokeColor3 = bl
        br.AnchorPoint = Vector2.new(0.5, 0)
        br.Visible = false
        br.ZIndex = 4
        br.Parent = bq

        return br
    end
    local function N(bq, br, bs, bt, bu)
        bq.Position = UDim2.fromOffset(br, bs)
        bq.Size = UDim2.fromOffset(bt, bu)
        bq.Visible = true
    end
    local function c(bq, br, bs, bt, bu, bv, bw)
        local bx, by = bt - br, bu - bs

        bq.Position = UDim2.fromOffset((br + bt) / 2, (bs + bu) / 2)
        bq.Size = UDim2.fromOffset(math.sqrt(bx * bx + by * by), bv)
        bq.Rotation = math.deg(math.atan2(by, bx))
        bq.BackgroundColor3 = bw
        bq.Visible = true
    end
    local function C(bq)
        local br = bk[bq]

        if br then
            br.highlight:Destroy()
            br.root:Destroy()
            br.outer:Destroy()

            bk[bq] = nil
        end
    end
    local function Q()
        for bq in pairs(bk)do
            C(bq)
        end
    end
    local function b(bq, br)
        C(bq)

        local bs = Instance.new'Highlight'

        bs.OutlineTransparency = 0
        bs.Adornee = br
        bs.Parent = bi

        local bt = Instance.new'Frame'

        bt.Size = UDim2.fromScale(1, 1)
        bt.BackgroundTransparency = 1
        bt.Visible = false
        bt.Parent = bj

        local bu = Instance.new'Frame'

        bu.Size = UDim2.fromScale(1, 1)
        bu.BackgroundTransparency = 1
        bu.Parent = bj

        local bv = {
            highlight = bs,
            root = bt,
            outer = bu,
            char = br,
            vis = false,
            visAt = 0,
        }

        bv.fill = q(bt, 1)
        bv.fill.BackgroundTransparency = 0.82
        bv.boxOut, bv.box = {}, {}

        for bw = 1, 8, 1 do
            bv.boxOut[bw] = q(bt, 2)
            bv.box[bw] = q(bt, 3)
        end

        bv.hpBack, bv.hpBar = q(bt, 2), q(bt, 3)
        bv.arBack, bv.arBar = q(bt, 2), q(bt, 3, bo)
        bv.hpText = K(bt)
        bv.hpText.AnchorPoint = Vector2.new(1, 0.5)
        bv.name, bv.weapon, bv.dist = K(bt), K(bt), K(bt)
        bv.flags = K(bt)
        bv.flags.AnchorPoint = Vector2.new(0, 0)
        bv.flags.RichText = true
        bv.flags.TextXAlignment = Enum.TextXAlignment.Left
        bv.flags.TextYAlignment = Enum.TextYAlignment.Top
        bv.bones = {}

        for bw = 1, #bp, 1 do
            bv.bones[bw] = v(bt, 2)
        end

        bv.headDot = q(bt, 3)
        bv.headDot.AnchorPoint = Vector2.new(0.5, 0.5)
        bv.headDot.BackgroundTransparency = 1
        (Instance.new('UICorner', bv.headDot)).CornerRadius = UDim.new(1, 0)
        bv.headStroke = Instance.new('UIStroke', bv.headDot)
        bv.headStroke.Thickness = 1
        bv.snapOut, bv.snap = v(bu, 1), v(bu, 2)
        bv.arrow = {
            v(bu, 3),
            v(bu, 3),
        }

        local bw = {}

        local function N(bx, by, bz)
            bw[#bw + 1] = {bx, by, bz}
        end

        N(bv.fill, 'BackgroundTransparency', 0.82)

        for bx = 1, 8, 1 do
            N(bv.boxOut[bx], 'BackgroundTransparency', 0)
            N(bv.box[bx], 'BackgroundTransparency', 0)
        end

        for bx, by in ipairs{
            bv.hpBack,
            bv.hpBar,
            bv.arBack,
            bv.arBar,
            bv.snap,
            bv.arrow[1],
            bv.arrow[2],
        }do
            N(by, 'BackgroundTransparency', 0)
        end

        N(bv.snapOut, 'BackgroundTransparency', 0.5)

        for bx, by in ipairs{
            bv.hpText,
            bv.name,
            bv.weapon,
            bv.dist,
            bv.flags,
        }do
            N(by, 'TextTransparency', 0)
            N(by, 'TextStrokeTransparency', 0.35)
        end
        for bx, by in ipairs(bv.bones)do
            N(by, 'BackgroundTransparency', 0)
        end

        N(bv.headStroke, 'Transparency', 0)

        bv.fade, bv.alpha, bv.fadeApplied = bw, 0, -1
        bk[bq] = bv

        return bv
    end
    local function a(bq)
        local br = 1 - bq.alpha

        if br == bq.fadeApplied then
            return
        end

        bq.fadeApplied = br

        for bs, bt in ipairs(bq.fade)do
            bt[1][bt[2] ] = bt[3] + (1 - bt[3]) * br
        end
    end

    aa.connect(u.PlayerRemoving, C)
    aa.onUnload(Q)

    local function T(bq, br)
        local bs = bq:GetAttribute'CurrentEquipped'

        if bs ~= br.eqRaw then
            br.eqRaw = bs

            local bt, bu = pcall(ar.JSONDecode, ar, type(bs) == 'string' and bs or '')

            br.eqName = (bt and (type(bu) == 'table' and type(bu.Name) == 'string')) and bu.Name or nil
        end

        return br.eqName
    end
    local function w(bq, br)
        local bs = bq:GetAttribute'Armor'

        if bs ~= br.arRaw then
            br.arRaw = bs

            local bt, bu = pcall(ar.JSONDecode, ar, type(bs) == 'string' and bs or '')

            br.arValue = bt and (type(bu) == 'table' and tonumber(bu.Health)) or 0
            br.arHelmet = bt and (type(bu) == 'table' and (type(bu.Type) == 'string' and bu.Type:find'Helmet' ~= nil))
        end

        return br.arValue or 0
    end
    local function e(bq, br, bs, bt, bu, bv)
        local bw = aC.espBoxStyle == 'Full' and 0.5 or 0.25
        local bx, by = math.ceil(bt * bw), math.ceil(bu * bw)
        local bz = {
            {
                br,
                bs,
                bx,
                1,
            },
            {
                br,
                bs,
                1,
                by,
            },
            {
                (br + bt) - bx,
                bs,
                bx,
                1,
            },
            {
                (br + bt) - 1,
                bs,
                1,
                by,
            },
            {
                br,
                (bs + bu) - 1,
                bx,
                1,
            },
            {
                br,
                (bs + bu) - by,
                1,
                by,
            },
            {
                (br + bt) - bx,
                (bs + bu) - 1,
                bx,
                1,
            },
            {
                (br + bt) - 1,
                (bs + bu) - by,
                1,
                by,
            },
        }

        for bA = 1, 8, 1 do
            local bB = bz[bA]

            N(bq.boxOut[bA], bB[1] - 1, bB[2] - 1, bB[3] + 2, bB[4] + 2)
            N(bq.box[bA], bB[1], bB[2], bB[3], bB[4])

            bq.box[bA].BackgroundColor3 = bv
        end
    end
    local function o(bq, br, bs, bt, bu, bv, bw)
        local bx = br.Head
        local by = br:FindFirstChild'HumanoidRootPart' or bx
        local bz, bA = bx.Position, by.Position
        local bB = (bz - bu).Magnitude

        if aC.espVisCheck and (not bt and not bs.dormant) then
            if bw - bs.visAt > 0.12 then
                bs.visAt = bw
                aU.FilterDescendantsInstances = {
                    _.Character,
                    at,
                }

                local bC = workspace:Raycast(bu, bz - bu, aU)

                bs.vis = bC == nil or bC.Instance:IsDescendantOf(br)
            end
        else
            bs.vis = false
        end

        local bC

        if aC.espColorMode == 'Team Side' then
            local bD = bq:GetAttribute'Team'

            bC = bD == 'Terrorists' and aC.espTColor or bD == 'Counter-Terrorists' and aC.espCTColor or bt and aC.espTeamColor or aC.espEnemyColor
        elseif aC.espColorMode == 'Player Color' then
            local bD = bq:GetAttribute'CompetitivePlayerColor'

            bC = typeof(bD) == 'Color3' and bD or bt and aC.espTeamColor or aC.espEnemyColor
        else
            bC = bt and aC.espTeamColor or aC.espEnemyColor
        end
        if bs.vis then
            bC = aC.espVisColor
        end
        if bs.dormant then
            bC = Color3.fromRGB(150, 150, 160)
        end

        local bD, bE, bF, bG = bs.highlight, aC.espFill, bC, aC.espChamsMode

        if bG == 'Outline' then
            bE = 1
        elseif bG == 'Solid' then
            bE = 0
        elseif bG == 'Pulse' then
            bE = 0.5 + 0.38 * math.sin(bw * 4.5)
        elseif bG == 'Rainbow' then
            bF = Color3.fromHSV((bw * 0.25) % 1, 0.85, 1)
        elseif bG == 'Health' then
            local bH = math.clamp(tonumber(br:GetAttribute'Health') or 100, 0, 100)

            bF = bn:Lerp(bm, bH / 100)
        end

        local bH = 1 - bs.alpha

        bD.Enabled = aC.espChams and not bs.dormant
        bD.DepthMode = aC.espChamsOccluded and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
        bD.FillColor, bD.OutlineColor = bF, bF
        bD.FillTransparency = bE + (1 - bE) * bH
        bD.OutlineTransparency = bH

        local bI, bJ, bK = bA.Y - 3, br:FindFirstChild'LeftFoot', br:FindFirstChild'RightFoot'

        if bJ and bK then
            bI = math.min(bJ.Position.Y, bK.Position.Y) - bJ.Size.Y / 2
        end

        local bL, bM = at:WorldToViewportPoint(Vector3.new(bA.X, (bz.Y + bx.Size.Y / 2) + 0.25, bA.Z)), at:WorldToViewportPoint(Vector3.new(bA.X, bI, bA.Z))
        local bN = bM.Y - bL.Y
        local bO, bP = bN * 0.52, (bL.X + bM.X) / 2
        local bQ = bL.Z > 0 and (bM.Z > 0 and (bN > 2 and (bP + bO / 2 > 0 and (bP - bO / 2 < bv.X and (bM.Y > 0 and bL.Y < bv.Y)))))

        bs.outer.Visible = true

        local bR = aC.espArrows and not bQ

        bs.arrow[1].Visible, bs.arrow[2].Visible = bR, bR

        if bR then
            local bS = at.CFrame:PointToObjectSpace(bA)
            local bU, bV = bS.X, -bS.Y
            local bW = math.sqrt(bU * bU + bV * bV)

            if bW < 0.001 then
                bU, bV, bW = 0, 1, 1
            end

            local bX = math.atan2(bV / bW, bU / bW)
            local bY, bZ = bv.X / 2 + math.cos(bX) * aC.espArrowRadius, bv.Y / 2 + math.sin(bX) * aC.espArrowRadius

            for b_ = 1, 2, 1 do
                local b0 = (bX + math.pi) + (b_ == 1 and 0.5 or -0.5)

                c(bs.arrow[b_], bY, bZ, bY + math.cos(b0) * aC.espArrowSize, bZ + math.sin(b0) * aC.espArrowSize, 2, bC)
            end
        end

        local bS = aC.espSnap and bQ

        bs.snap.Visible, bs.snapOut.Visible = bS, bS

        if bS then
            local bU = aC.espSnapFrom == 'Top' and 0 or aC.espSnapFrom == 'Center' and bv.Y / 2 or bv.Y

            c(bs.snapOut, bv.X / 2, bU, bP, bM.Y, 3, bl)

            bs.snapOut.BackgroundTransparency = 0.5

            c(bs.snap, bv.X / 2, bU, bP, bM.Y, 1, bC)
        end

        bs.root.Visible = bQ

        if not bQ then
            return
        end

        local bU, bV = math.floor(bP - bO / 2), math.floor(bL.Y)

        bO, bN = math.floor(bO), math.floor(bN)

        if aC.espBox then
            e(bs, bU, bV, bO, bN, bC)
        else
            for bW = 1, 8, 1 do
                bs.boxOut[bW].Visible, bs.box[bW].Visible = false, false
            end
        end

        bs.fill.Visible = aC.espBoxFill

        if aC.espBoxFill then
            N(bs.fill, bU, bV, bO, bN)

            bs.fill.BackgroundColor3 = bC
        end

        local bW = math.clamp(tonumber(br:GetAttribute'Health') or 100, 0, 100)

        bs.hpBack.Visible, bs.hpBar.Visible = aC.espHealth, aC.espHealth
        bs.hpText.Visible = aC.espHealth and (aC.espHealthText and bW < 100)

        if aC.espHealth then
            local bX = math.max(math.floor((bN * bW) / 100), 1)

            N(bs.hpBack, bU - 6, bV - 1, 4, bN + 2)
            N(bs.hpBar, bU - 5, (bV + bN) - bX, 2, bX)

            bs.hpBar.BackgroundColor3 = bn:Lerp(bm, bW / 100)

            if bs.hpText.Visible then
                bs.hpText.Position = UDim2.fromOffset(bU - 8, (bV + bN) - bX)
                bs.hpText.Size = UDim2.fromOffset(30, 10)
                bs.hpText.TextXAlignment = Enum.TextXAlignment.Right
                bs.hpText.TextSize = math.max(aC.espTextSize - 2, 9)
                bs.hpText.TextColor3 = Color3.new(1, 1, 1)
                bs.hpText.Text = tostring(math.floor(bW + 0.5))
            end
        end

        local bX, bY = (bV + bN) + 2, aC.espArmor and w(bq, bs) or 0
        local bZ = aC.espArmor and bY > 0

        bs.arBack.Visible, bs.arBar.Visible = bZ, bZ

        if bZ then
            N(bs.arBack, bU - 1, bX, bO + 2, 4)
            N(bs.arBar, bU, bX + 1, math.max(math.floor((bO * math.clamp(bY, 0, 100)) / 100), 1), 2)

            bX = bX + 5
        end

        local b_ = aC.espTextSize

        bs.name.Visible = aC.espNames

        if aC.espNames then
            bs.name.Position = UDim2.fromOffset(bP, (bV - b_) - 4)
            bs.name.Size = UDim2.fromOffset(200, b_ + 2)
            bs.name.TextSize, bs.name.TextColor3 = b_, bs.dormant and bC or Color3.new(1, 1, 1)
            bs.name.Text = bs.dormant and ('%s  %.0fs ago'):format(bq.DisplayName, bw - (bs.dormantAt or bw)) or bq.DisplayName
        end

        local b0 = aC.espWeapon and T(bq, bs)

        bs.weapon.Visible = b0 ~= nil and b0 ~= false

        if bs.weapon.Visible then
            bs.weapon.Position = UDim2.fromOffset(bP, bX)
            bs.weapon.Size = UDim2.fromOffset(200, b_ + 2)
            bs.weapon.TextSize, bs.weapon.TextColor3, bs.weapon.Text = b_, bC, b0
            bX = (bX + b_) + 1
        end

        bs.dist.Visible = aC.espDistance

        if aC.espDistance then
            bs.dist.Position = UDim2.fromOffset(bP, bX)
            bs.dist.Size = UDim2.fromOffset(200, b_ + 2)
            bs.dist.TextSize, bs.dist.TextColor3 = math.max(b_ - 1, 9), Color3.fromRGB(210, 210, 215)
            bs.dist.Text = math.floor(bB * 0.28) .. 'm'
        end

        bs.flags.Visible = aC.espFlags

        if aC.espFlags then
            local b1, b2 = {}, w(bq, bs)

            if b2 > 0 then
                b1[#b1 + 1] = '<font color="#6FB4FF">' .. ((bs.arHelmet and 'HK' or 'K') .. '</font>')
            end

            local b3 = tonumber(bq:GetAttribute'Money')

            if b3 then
                b1[#b1 + 1] = '<font color="#7CE38B">$' .. (math.floor(b3) .. '</font>')
            end
            if (tonumber(bq:GetAttribute'ScopeIncrement') or 0) > 0 then
                b1[#b1 + 1] = '<font color="#5CE1E6">ZOOM</font>'
            end
            if bq:GetAttribute'HasDefuseKit' == true then
                b1[#b1 + 1] = '<font color="#C9A6FF">KIT</font>'
            end
            if bq:GetAttribute'IsCrouching' == true then
                b1[#b1 + 1] = '<font color="#D0D0D8">DUCK</font>'
            end
            if t(br) then
                b1[#b1 + 1] = '<font color="#FFD35C">IMMUNE</font>'
            end
            if type(bq) == 'table' and bq.IsBot then
                b1[#b1 + 1] = '<font color="#9A9AA5">BOT</font>'
            end

            local b4 = math.max(b_ - 2, 9)

            bs.flags.Position = UDim2.fromOffset((bU + bO) + 4, bV - 1)
            bs.flags.Size = UDim2.fromOffset(90, #b1 * (b4 + 1) + 2)
            bs.flags.TextSize = b4
            bs.flags.TextColor3 = Color3.new(1, 1, 1)
            bs.flags.Text = table.concat(b1, ' ')
        end

        bs.headDot.Visible = aC.espHeadDot

        if aC.espHeadDot then
            local b1, b2 = at:WorldToViewportPoint(bz), math.max(math.floor(bN * 0.13), 4)

            bs.headDot.Position = UDim2.fromOffset(b1.X, b1.Y)
            bs.headDot.Size = UDim2.fromOffset(b2, b2)
            bs.headStroke.Color = bC
        end

        for b1, b2 in ipairs(bp)do
            local b3, b4, b5 = bs.bones[b1], aC.espSkeleton and br:FindFirstChild(b2[1]), aC.espSkeleton and br:FindFirstChild(b2[2])

            if b4 and b5 then
                local b6, b7 = at:WorldToViewportPoint(b4.Position), at:WorldToViewportPoint(b5.Position)

                if b6.Z > 0 and b7.Z > 0 then
                    c(b3, b6.X, b6.Y, b7.X, b7.Y, 1, bC)
                else
                    b3.Visible = false
                end
            else
                b3.Visible = false
            end
        end
    end

    aa.connect(O.RenderStepped, function(bq)
        if not aC.esp then
            if next(bk) then
                Q()
            end

            return
        end

        local br, bs, bt = (U()).Position, at.ViewportSize, os.clock()

        for bu, bv in ipairs(aa.entities())do
            local bw = bv ~= _ and k(bv)
            local bx = bv ~= _ and (not bw or aC.espTeam)
            local by, bz = bx and F(bv), false

            if not by and (bx and (not bw and aC.espDormant)) then
                local bA, bB = bv.Character, bk[bv]

                if bA and (bB and (bB.char == bA and (not bA:IsDescendantOf(workspace) and (not bA:GetAttribute'Dead' and (bv:GetAttribute'Dead' == false and bA:FindFirstChild'Head'))))) then
                    bB.dormantAt = bB.dormantAt or bt

                    if bt - bB.dormantAt <= aC.espDormantTime then
                        by, bz = bA, true
                    end
                end
            end

            local bA, bB = bk[bv], 1

            if by then
                if not bA or bA.char ~= by then
                    bA = b(bv, by)
                end
                if not bz then
                    bA.dormantAt = nil
                end

                bA.dormant = bz
            elseif bA and (bx and (bA.char and (bA.char:FindFirstChild'Head' and (bA.char:IsDescendantOf(workspace) or (bA.alpha or 0) > 0)))) then
                bA.goneAt = bA.goneAt or bt

                if bt - bA.goneAt > 3 then
                    C(bv)

                    bA = nil
                else
                    by, bB = bA.char, 0
                    bA.dormant = false
                end
            else
                C(bv)

                bA = nil
            end
            if bA and by then
                if bB == 1 then
                    bA.goneAt = nil
                end
                if aC.espFade <= 0 then
                    bA.alpha = bB
                elseif bA.alpha < bB then
                    bA.alpha = math.min(bA.alpha + bq / aC.espFade, bB)
                else
                    bA.alpha = math.max(bA.alpha - bq / aC.espFade, bB)
                end
                if bB == 0 and bA.alpha <= 0 then
                    bA.root.Visible, bA.outer.Visible, bA.highlight.Enabled = false, false, false
                else
                    local bC = pcall(o, bv, by, bA, bw, br, bs, bt)

                    if not bC then
                        bA.root.Visible, bA.outer.Visible = false, false
                    end

                    a(bA)
                end
            end
        end

        local bu = aa.entities()

        for bv in pairs(bk)do
            if not table.find(bu, bv) then
                C(bv)
            end
        end
    end)
end

local bi = ad:Tab{
    Title = 'Legit',
    Icon = 'target',
}

bi:Section{
    Title = 'silent aim',
}

do
    local bj = bi:Toggle{
        Title = 'silent aim',
        Value = false,
        Flag = 'silentAim',
        Callback = function(bj)
            aC.silentAim = bj
        end,
    }

    ak.register('Silent Aim', bj, {
        kind = 'toggle',
        title = 'Silent Aim',
        isActive = function()
            return aC.silentAim
        end,
        setState = function(bk)
            aC.silentAim = bk

            pcall(function()
                bj:Set(bk)
            end)
        end,
    })
end

bi:Slider{
    Title = 'fov radius',
    Value = {
        Min = 10,
        Max = 600,
        Default = 120,
    },
    Flag = 'fovRadius',
    Callback = function(bj)
        aC.fov = bj
    end,
}
bi:Toggle{
    Title = 'show fov circle',
    Value = true,
    Flag = 'showFov',
    Callback = function(bj)
        aC.showFov = bj
    end,
}
bi:Colorpicker{
    Title = 'fov color',
    Default = aC.fovColor,
    Flag = 'fovColor',
    Callback = function(bj)
        aC.fovColor = bj
    end,
}
bi:Dropdown{
    Title = 'aim part',
    Values = {
        'Head',
        'HumanoidRootPart',
        'Closest to Crosshair',
        'Random',
    },
    Value = 'Head',
    Flag = 'aimPart',
    Callback = function(bj)
        aC.aimPart = type(bj) == 'table' and bj[1] or bj
    end,
}
bi:Toggle{
    Title = 'wall check',
    Value = true,
    Flag = 'wallCheck',
    Callback = function(bj)
        aC.wallCheck = bj
    end,
}
bi:Toggle{
    Title = 'team check',
    Value = true,
    Flag = 'teamCheck',
    Callback = function(bj)
        aC.teamCheck = bj
    end,
}
bi:Section{
    Title = 'gun mods',
}

do
    local bj = bi:Toggle{
        Title = 'no spread',
        Value = false,
        Flag = 'noSpread',
        Callback = function(bj)
            aC.noSpread = bj
        end,
    }

    ak.register('No Spread', bj, {
        kind = 'toggle',
        title = 'No Spread',
        isActive = function()
            return aC.noSpread
        end,
        setState = function(bk)
            aC.noSpread = bk

            pcall(function()
                bj:Set(bk)
            end)
        end,
    })
end
do
    local bj = bi:Toggle{
        Title = 'no recoil',
        Value = false,
        Flag = 'noRecoil',
        Callback = function(bj)
            aC.noRecoil = bj

            if bj then
                task.spawn(pcall, av.resetWeaponRecoil)
            end
        end,
    }

    ak.register('No Recoil', bj, {
        kind = 'toggle',
        title = 'No Recoil',
        isActive = function()
            return aC.noRecoil
        end,
        setState = function(bk)
            aC.noRecoil = bk

            if bk then
                task.spawn(pcall, av.resetWeaponRecoil)
            end

            pcall(function()
                bj:Set(bk)
            end)
        end,
    })
end

-- Gun mods tab (no spread / no recoil from legit + firerate from meow)
do
    local gunTab = ad:Tab{
        Title = 'Gun mods',
        Icon = 'crosshair',
    }

    gunTab:Section{
        Title = 'weapon',
    }

    gunTab:Section{
        Title = 'firerate',
    }

    gunTab:Toggle{
        Title = 'enable firerate changer',
        Value = false,
        Flag = 'firerate',
        Callback = function(v)
            aC.firerate = v == true
        end,
    }

    gunTab:Slider{
        Title = 'firerate',
        Value = {
            Min = 0,
            Max = 1,
            Default = 0.01,
        },
        Step = 0.001,
        Flag = 'firerateValue',
        Callback = function(v)
            aC.firerateValue = tonumber(v) or 0.01
        end,
    }
end

-- meow-style FireRate changer (getgc tables with FireRate)
do
    local original = {}
    local firerateobjs = {}

    task.spawn(function()
        task.wait(1)
        pcall(function()
            if type(getgc) ~= 'function' then
                return
            end
            for _, obj in next, getgc(true) do
                if type(obj) == 'table' and rawget(obj, 'FireRate') ~= nil then
                    pcall(function()
                        local fr = rawget(obj, 'FireRate')
                        if type(fr) == 'number' then
                            original[#original + 1] = { FireRate = fr }
                            firerateobjs[#firerateobjs + 1] = obj
                        end
                    end)
                end
            end
        end)
    end)

    local function restoreFireRates()
        for i, obj in next, firerateobjs do
            local orig = original[i]
            if orig and type(orig.FireRate) == 'number' then
                pcall(function()
                    if setreadonly then
                        setreadonly(obj, false)
                    end
                    rawset(obj, 'FireRate', orig.FireRate)
                    if setreadonly then
                        setreadonly(obj, true)
                    end
                end)
            end
        end
    end

    aa.onUnload(restoreFireRates)

    task.spawn(function()
        while task.wait(0.05) do
            if aa.unloaded then
                restoreFireRates()
                break
            end
            pcall(function()
                if aC.firerate then
                    local val = math.max(tonumber(aC.firerateValue) or 0.01, 0.01)
                    for _, obj in next, firerateobjs do
                        pcall(function()
                            if setreadonly then
                                setreadonly(obj, false)
                            end
                            rawset(obj, 'FireRate', val)
                            if setreadonly then
                                setreadonly(obj, true)
                            end
                        end)
                    end
                else
                    for i, obj in next, firerateobjs do
                        local orig = original[i]
                        if orig and type(orig.FireRate) == 'number' then
                            pcall(function()
                                if setreadonly then
                                    setreadonly(obj, false)
                                end
                                rawset(obj, 'FireRate', orig.FireRate)
                                if setreadonly then
                                    setreadonly(obj, true)
                                end
                            end)
                        end
                    end
                end
            end)
        end
    end)
end


-- Duplicate Rage Bot V1 controls removed; Rage Bot V2 is the single control set.

do
local bj = ad:Tab{
    Title = 'Rage bot v2 (zaml mode)',
    Icon = 'flame',
}

bj:Section{
    Title = 'ragebot v2',
}

do
    local bk = bj:Toggle{
        Title = 'ragebot',
        Value = false,
        Flag = 'zamlv2_rage',
        Callback = function(bk)
            aC.rage = bk
        end,
    }

    ak.register('Ragebot', bk, {
        kind = 'toggle',
        title = 'Ragebot',
        isActive = function()
            return aC.rage
        end,
        setState = function(bl)
            aC.rage = bl

            pcall(function()
                bk:Set(bl)
            end)
        end,
    })
end

bj:Toggle{
    Title = 'auto fire',
    Value = true,
    Flag = 'zamlv2_rageAutoFire',
    Callback = function(bk)
        aC.rageAutoFire = bk
    end,
}
bj:Toggle{
    Title = 'wall penetration check',
    Value = true,
    Flag = 'zamlv2_rageAutowall',
    Callback = function(bk)
        aC.rageAutowall = bk
    end,
}
bj:Dropdown{
    Title = 'hitbox',
    Values = {
        'Head',
        'Body',
        'Multipoint',
        'Full Body',
    },
    Value = 'Head',
    Flag = 'zamlv2_rageHitbox',
    Callback = function(bk)
        aC.rageHitbox = type(bk) == 'table' and bk[1] or bk
    end,
}
bj:Dropdown{
    Title = 'target selection',
    Values = {
        'Distance',
        'Crosshair',
        'Lowest HP',
    },
    Value = 'Distance',
    Flag = 'zamlv2_rageTargetMode',
    Callback = function(bk)
        aC.rageTargetMode = type(bk) == 'table' and bk[1] or bk
    end,
}
bj:Toggle{
    Title = 'prefer body when lethal',
    Value = true,
    Flag = 'zamlv2_preferBodyLethal',
    Callback = function(bk)
        aC.preferBodyLethal = bk
    end,
}
bj:Toggle{
    Title = 'multi-target',
    Value = false,
    Flag = 'zamlv2_rageMulti',
    Callback = function(bk)
        aC.rageMulti = bk
    end,
}
bj:Slider{
    Title = 'scan rate (hz)',
    Value = {
        Min = 5,
        Max = 60,
        Default = 30,
    },
    Flag = 'zamlv2_rageScanHz',
    Callback = function(bk)
        aC.rageScanHz = bk
    end,
}
bj:Slider{
    Title = 'min damage',
    Value = {
        Min = 1,
        Max = 100,
        Default = 20,
    },
    Flag = 'zamlv2_minDmg',
    Callback = function(bk)
        aC.minDmg = bk
    end,
}

do
    local bk = bj:Toggle{
        Title = 'min damage override',
        Value = false,
        Flag = 'zamlv2_minDmgOverride',
        Callback = function(bk)
            aC.minDmgOverride = bk
        end,
    }

    ak.register('Min Dmg Override', bk, {
        kind = 'toggle',
        title = 'Min Dmg Override',
        isActive = function()
            return aC.minDmgOverride
        end,
        setState = function(bl)
            aC.minDmgOverride = bl

            pcall(function()
                bk:Set(bl)
            end)
        end,
    })
end

bj:Slider{
    Title = 'override damage',
    Value = {
        Min = 1,
        Max = 100,
        Default = 5,
    },
    Flag = 'zamlv2_minDmgOverrideValue',
    Callback = function(bk)
        aC.minDmgOverrideValue = bk
    end,
}
bj:Section{
    Title = 'anti-aim',
}

do
    local bk = bj:Toggle{
        Title = 'anti-aim',
        Value = false,
        Flag = 'zamlv2_aa',
        Callback = function(bk)
            aC.aa = bk
        end,
    }

    ak.register('Anti-Aim', bk, {
        kind = 'toggle',
        title = 'Anti-Aim',
        isActive = function()
            return aC.aa
        end,
        setState = function(bl)
            aC.aa = bl

            pcall(function()
                bk:Set(bl)
            end)
        end,
    })
end

bj:Dropdown{
    Title = 'yaw base',
    Values = {
        'View',
        'At Targets',
    },
    Value = 'View',
    Flag = 'zamlv2_aaBase',
    Callback = function(bk)
        aC.aaBase = type(bk) == 'table' and bk[1] or bk
    end,
}

do
    local bk = {}

    for bl, bm in ipairs{
        'Left',
        'Right',
        'Back',
    }do
        local bn

        local function A(bo)
            if bo then
                aC.aaManual = bm

                for bp, bq in pairs(bk)do
                    if bp ~= bm then
                        pcall(function()
                            bq:Set(false)
                        end)
                    end
                end
            elseif aC.aaManual == bm then
                aC.aaManual = nil
            end
        end

        bn = bj:Toggle{
            Title = 'manual ' .. bm:lower(),
            Value = false,
            Callback = A,
        }
        bk[bm] = bn

        ak.register('AA ' .. bm, bn, {
            kind = 'toggle',
            title = 'AA ' .. bm,
            isActive = function()
                return aC.aaManual == bm
            end,
            setState = function(bo)
                A(bo)
                pcall(function()
                    bn:Set(bo)
                end)
            end,
        })
    end
end

bj:Dropdown{
    Title = 'yaw',
    Values = {
        'Backwards',
        'Sideways',
        'Spin',
        'Jitter',
    },
    Value = 'Backwards',
    Flag = 'zamlv2_aaYaw',
    Callback = function(bk)
        aC.aaYaw = type(bk) == 'table' and bk[1] or bk
    end,
}
bj:Slider{
    Title = 'spin speed',
    Value = {
        Min = 5,
        Max = 90,
        Default = 30,
    },
    Flag = 'zamlv2_aaSpin',
    Callback = function(bk)
        aC.aaSpin = bk
    end,
}
bj:Slider{
    Title = 'jitter range',
    Value = {
        Min = 5,
        Max = 90,
        Default = 60,
    },
    Flag = 'zamlv2_aaJitter',
    Callback = function(bk)
        aC.aaJitter = bk
    end,
}
bj:Slider{
    Title = 'jitter delay (ticks)',
    Value = {
        Min = 1,
        Max = 64,
        Default = 1,
    },
    Flag = 'zamlv2_aaJitterDelay',
    Callback = function(bk)
        aC.aaJitterDelay = bk
    end,
}
bj:Dropdown{
    Title = 'pitch',
    Values = {
        'None',
        'Down',
        'Up',
        'Jitter',
    },
    Value = 'Down',
    Flag = 'zamlv2_aaPitch',
    Callback = function(bk)
        aC.aaPitch = type(bk) == 'table' and bk[1] or bk
    end,
}
bj:Toggle{
    Title = 'disable while shooting',
    Value = true,
    Flag = 'zamlv2_aaOffShot',
    Callback = function(bk)
        aC.aaOffShot = bk
    end,
}
bj:Section{
    Title = 'weapon',
}
bj:Toggle{
    Title = 'auto reload',
    Value = false,
    Flag = 'zamlv2_autoReload',
    Callback = function(bk)
        aC.autoReload = bk
    end,
}
bj:Slider{
    Title = 'reload at',
    Value = {
        Min = 0,
        Max = 10,
        Default = 1,
    },
    Flag = 'zamlv2_reloadAt',
    Callback = function(bk)
        aC.reloadAt = bk
    end,
}
bj:Toggle{
    Title = 'remote reload',
    Value = false,
    Flag = 'zamlv2_remoteReload',
    Callback = function(bk)
        aC.remoteReload = bk
    end,
}
bj:Toggle{
    Title = 'insta reload',
    Value = false,
    Flag = 'zamlv2_instaReload',
    Callback = function(bk)
        aC.instaReload = bk
    end,
}
bj:Slider{
    Title = 'reload speed',
    Value = {
        Min = 1,
        Max = 20,
        Default = 3,
    },
    Flag = 'zamlv2_reloadSpeed',
    Callback = function(bk)
        aC.reloadSpeed = bk
    end,
}

end

local bk = ad:Tab{
    Title = 'visual',
    Icon = 'sparkles',
}

bk:Section{
    Title = 'esp',
}

do
    local bl = bk:Toggle{
        Title = 'esp',
        Value = false,
        Flag = 'esp',
        Callback = function(bl)
            aC.esp = bl
        end,
    }

    ak.register('ESP', bl, {
        kind = 'toggle',
        title = 'ESP',
        isActive = function()
            return aC.esp
        end,
        setState = function(bm)
            aC.esp = bm

            pcall(function()
                bl:Set(bm)
            end)
        end,
    })
end

bk:Colorpicker{
    Title = 'enemy color',
    Default = aC.espEnemyColor,
    Flag = 'espEnemyColor',
    Callback = function(bl)
        aC.espEnemyColor = bl
    end,
}
bk:Dropdown{
    Title = 'color mode',
    Values = {
        'Enemy / Teammate',
        'Team Side',
        'Player Color',
    },
    Value = 'Enemy / Teammate',
    Flag = 'espColorMode',
    Callback = function(bl)
        aC.espColorMode = type(bl) == 'table' and bl[1] or bl
    end,
}
bk:Colorpicker{
    Title = 'terrorist color',
    Default = aC.espTColor,
    Flag = 'espTColor',
    Callback = function(bl)
        aC.espTColor = bl
    end,
}
bk:Colorpicker{
    Title = 'counter-terrorist color',
    Default = aC.espCTColor,
    Flag = 'espCTColor',
    Callback = function(bl)
        aC.espCTColor = bl
    end,
}
bk:Toggle{
    Title = 'visible check color',
    Value = false,
    Flag = 'espVisCheck',
    Callback = function(bl)
        aC.espVisCheck = bl
    end,
}
bk:Colorpicker{
    Title = 'visible color',
    Default = aC.espVisColor,
    Flag = 'espVisColor',
    Callback = function(bl)
        aC.espVisColor = bl
    end,
}
bk:Toggle{
    Title = 'show teammates',
    Value = false,
    Flag = 'espTeam',
    Callback = function(bl)
        aC.espTeam = bl
    end,
}
bk:Colorpicker{
    Title = 'teammate color',
    Default = aC.espTeamColor,
    Flag = 'espTeamColor',
    Callback = function(bl)
        aC.espTeamColor = bl
    end,
}
bk:Toggle{
    Title = 'dormant esp',
    Value = false,
    Flag = 'espDormant',
    Callback = function(bl)
        aC.espDormant = bl
    end,
}
bk:Slider{
    Title = 'dormant time (s)',
    Value = {
        Min = 1,
        Max = 15,
        Default = 4,
    },
    Flag = 'espDormantTime',
    Callback = function(bl)
        aC.espDormantTime = bl
    end,
}
bk:Section{
    Title = 'esp - chams',
}
bk:Toggle{
    Title = 'chams',
    Value = true,
    Flag = 'espChams',
    Callback = function(bl)
        aC.espChams = bl
    end,
}
bk:Dropdown{
    Title = 'chams mode',
    Values = {
        'Glow',
        'Outline',
        'Solid',
        'Pulse',
        'Rainbow',
        'Health',
    },
    Value = 'Glow',
    Flag = 'espChamsMode',
    Callback = function(bl)
        aC.espChamsMode = type(bl) == 'table' and bl[1] or bl
    end,
}
bk:Toggle{
    Title = 'visible only',
    Value = false,
    Flag = 'espChamsOccluded',
    Callback = function(bl)
        aC.espChamsOccluded = bl
    end,
}
bk:Slider{
    Title = 'fill transparency',
    Value = {
        Min = 0,
        Max = 100,
        Default = 60,
    },
    Flag = 'espFill',
    Callback = function(bl)
        aC.espFill = bl / 100
    end,
}
bk:Section{
    Title = 'esp - info',
}
bk:Toggle{
    Title = 'names',
    Value = true,
    Flag = 'espNames',
    Callback = function(bl)
        aC.espNames = bl
    end,
}
bk:Toggle{
    Title = 'weapon',
    Value = false,
    Flag = 'espWeapon',
    Callback = function(bl)
        aC.espWeapon = bl
    end,
}
bk:Toggle{
    Title = 'flags',
    Value = false,
    Flag = 'espFlags',
    Callback = function(bl)
        aC.espFlags = bl
    end,
}
bk:Toggle{
    Title = 'distance',
    Value = true,
    Flag = 'espDistance',
    Callback = function(bl)
        aC.espDistance = bl
    end,
}
bk:Slider{
    Title = 'text size',
    Value = {
        Min = 9,
        Max = 18,
        Default = 12,
    },
    Flag = 'espTextSize',
    Callback = function(bl)
        aC.espTextSize = bl
    end,
}
bk:Section{
    Title = 'esp - lines',
}
bk:Toggle{
    Title = 'head dot',
    Value = false,
    Flag = 'espHeadDot',
    Callback = function(bl)
        aC.espHeadDot = bl
    end,
}
bk:Toggle{
    Title = 'snaplines',
    Value = false,
    Flag = 'espSnap',
    Callback = function(bl)
        aC.espSnap = bl
    end,
}
bk:Dropdown{
    Title = 'snapline origin',
    Values = {
        'Bottom',
        'Center',
        'Top',
    },
    Value = 'Bottom',
    Flag = 'espSnapFrom',
    Callback = function(bl)
        aC.espSnapFrom = type(bl) == 'table' and bl[1] or bl
    end,
}
bk:Toggle{
    Title = 'off-screen arrows',
    Value = false,
    Flag = 'espArrows',
    Callback = function(bl)
        aC.espArrows = bl
    end,
}
bk:Slider{
    Title = 'arrow radius',
    Value = {
        Min = 60,
        Max = 500,
        Default = 220,
    },
    Step = 10,
    Flag = 'espArrowRadius',
    Callback = function(bl)
        aC.espArrowRadius = bl
    end,
}
bk:Slider{
    Title = 'arrow size',
    Value = {
        Min = 8,
        Max = 30,
        Default = 14,
    },
    Flag = 'espArrowSize',
    Callback = function(bl)
        aC.espArrowSize = bl
    end,
}
bk:Section{
    Title = 'esp - sound',
}

do
    local bl, bm, bn, bo, bp, bq, br, bs, bt = false, Color3.fromRGB(255, 190, 60), 3, true, {}, {
        'Bomb',
        'Plant',
        'Defus',
        'Killed',
        'Music',
        'Hostage',
        'Round',
        'Win',
    }, 7, 16, RaycastParams.new()

    bt.FilterType = Enum.RaycastFilterType.Exclude

    local function q()
        local bu = {}

        for bv, bw in ipairs(aa.entities())do
            if h(bw) and bw:GetAttribute'Dead' == false then
                local bx = bw.Character

                if not (bx and bx:IsDescendantOf(workspace)) then
                    local by = bw:GetAttribute'CurrentEquipped'
                    local bz, bA = pcall(ar.JSONDecode, ar, type(by) == 'string' and by or '')

                    bu[#bu + 1] = {
                        name = bw.Name,
                        weapon = bz and (type(bA) == 'table' and bA.Name) or nil,
                    }
                end
            end
        end

        return bu
    end
    local function v(bu, bv)
        local bw = q()

        if #bw == 1 then
            return bw[1].name
        end
        if bu then
            local bx

            for by, bz in ipairs(bw)do
                if bz.weapon == bv then
                    if bx then
                        return nil
                    end

                    bx = bz.name
                end
            end

            return bx
        end

        return nil
    end
    local function K(bu)
        pcall(function()
            bu.part:Destroy()
        end)
    end
    local function N()
        local bu = Instance.new'Part'

        bu.Anchored, bu.CanCollide, bu.CanQuery, bu.CanTouch, bu.CastShadow = true, false, false, false, false
        bu.Transparency = 1
        bu.Size = Vector3.new(0.2, 0.2, 0.2)
        bu.Parent = aS

        local bv = Instance.new'BillboardGui'

        bv.Size = UDim2.fromOffset(170, 62)
        bv.AlwaysOnTop = true
        bv.Adornee = bu
        bv.Parent = bu

        local bw = Instance.new'Frame'

        bw.AnchorPoint = Vector2.new(0.5, 0)
        bw.Position = UDim2.new(0.5, 0, 0, 0)
        bw.Size = UDim2.fromOffset(14, 14)
        bw.BorderSizePixel = 0
        bw.Parent = bv;
        (Instance.new('UICorner', bw)).CornerRadius = UDim.new(1, 0)

        local bx = Instance.new('UIStroke', bw)

        bx.Thickness = 2

        local by = Instance.new'TextLabel'

        by.Position = UDim2.fromOffset(0, 22)
        by.Size = UDim2.new(1, 0, 0, 40)
        by.BackgroundTransparency = 1
        by.Font = Enum.Font.GothamBold
        by.TextSize = 12
        by.TextStrokeTransparency = 0.4
        by.TextYAlignment = Enum.TextYAlignment.Top
        by.Parent = bv

        local bz = Instance.new'BoxHandleAdornment'

        bz.Size = Vector3.new(3, 5.5, 3)
        bz.AlwaysOnTop = true
        bz.ZIndex = 5
        bz.Adornee = bu
        bz.Parent = bu

        return {
            part = bu,
            ring = bw,
            stroke = bx,
            text = by,
            box = bz,
        }
    end
    local function c(bu)
        if not bl or aa.unloaded or type(bu) ~= 'table' then
            return
        end

        local bv = bu.Position

        if typeof(bv) ~= 'Vector3' then
            return
        end

        local bw = tostring(bu.Name or '')

        for bx, by in ipairs(bq)do
            if bw:find(by, 1, true) then
                return
            end
        end

        local bx = _.Character
        local by = bx and bx:FindFirstChild'HumanoidRootPart'

        if by and (by.Position - bv).Magnitude < 16 then
            return
        end

        local bz = workspace:FindFirstChild'Characters'

        if bz then
            for bA, bB in ipairs(bz:GetChildren())do
                local bC = bB:IsA'Model' and bB:FindFirstChild'HumanoidRootPart'

                if bC and (bC.Position - bv).Magnitude < br then
                    return
                end
            end
        end

        local bA, bB, bC, bD = bw == 'Shoot', type(bu.Class) == 'string' and bu.Class or nil, nil, nil

        for bE, bF in ipairs(bp)do
            local bG = (bF.pos - bv).Magnitude

            if bG < bs and (not bD or bG < bD) then
                bC, bD = bF, bG
            end
        end

        if not bC then
            bC = N()
            bp[#bp + 1] = bC
        end

        local bE = os.clock()

        if bC.pos and (bC.last and (bA == bC.wasShot and (bE - bC.last > 0.05 and bE - bC.last < 1.5))) then
            local bF = (bv - bC.pos) / (bE - bC.last)

            bF = Vector3.new(bF.X, 0, bF.Z)
            bC.vel = bF.Magnitude < 32 and bF or nil
        else
            bC.vel = nil
        end

        bC.wasShot = bA
        bC.pos, bC.last = bv, bE
        bC.kind = bA and (bB or 'shot') or 'steps'
        bt.FilterDescendantsInstances = {
            _.Character,
            at,
            workspace:FindFirstChild'Debris',
        }

        local bF = (U()).Position

        bC.inView = workspace:Raycast(bF, (bv + Vector3.new(0, 2.5, 0)) - bF, bt) == nil
        bC.who = v(bA, bB) or bC.who
        bC.part.CFrame = CFrame.new(bv + Vector3.new(0, 1.5, 0))
    end

    local bu

    pcall(function()
        bu = a2.Sound.ReplicateSound.Connect(function(bv)
            pcall(c, bv)
        end)
    end)
    aa.onUnload(function()
        if type(bu) == 'function' then
            pcall(bu)
        end

        for bv, bw in ipairs(bp)do
            K(bw)
        end

        bp = {}
    end)
    aa.connect(O.RenderStepped, function()
        if #bp == 0 then
            return
        end

        local bv, bw = os.clock(), (U()).Position

        for bx = #bp, 1, -1 do
            local by = bp[bx]
            local bz = bv - by.last

            if not bl or bz > bn then
                K(by)
                table.remove(bp, bx)
            else
                local bA = bz / bn

                by.ring.BackgroundColor3, by.stroke.Color, by.text.TextColor3 = bm, bm, bm
                by.ring.BackgroundTransparency = 0.5 + bA * 0.5
                by.stroke.Transparency = bA
                by.text.TextTransparency = bA
                by.text.TextStrokeTransparency = 0.4 + bA * 0.6

                local bB = by.vel and by.pos + by.vel * math.min(bz, 0.6) or by.pos

                by.part.CFrame = CFrame.new(bB + Vector3.new(0, 1.5, 0))
                by.box.Visible = bo
                by.box.Color3 = bm
                by.box.Transparency = 0.7 + bA * 0.3
                by.box.CFrame = CFrame.new(0, by.wasShot and -3.25 or 1.25, 0)
                by.text.Text = (by.who and by.who .. ' ' or '') .. (by.kind .. ('  ' .. (math.floor((by.pos - bw).Magnitude * 0.28) .. ('m' .. (by.inView and 'IN VIEW' or '')))))
                by.ring.Size = by.inView and UDim2.fromOffset(20, 20) or UDim2.fromOffset(14, 14)
            end
        end
    end)
    bk:Toggle{
        Title = 'sound esp',
        Value = false,
        Flag = 'soundEsp',
        Callback = function(bv)
            bl = bv
        end,
    }
    bk:Colorpicker{
        Title = 'sound marker color',
        Default = bm,
        Flag = 'soundEspColor',
        Callback = function(bv)
            bm = bv
        end,
    }
    bk:Toggle{
        Title = 'sound ghost box',
        Value = true,
        Flag = 'soundEspBox',
        Callback = function(bv)
            bo = bv
        end,
    }
    bk:Slider{
        Title = 'sound marker time (s)',
        Value = {
            Min = 1,
            Max = 10,
            Default = 3,
        },
        Step = 0.5,
        Flag = 'soundEspLife',
        Callback = function(bv)
            bn = bv
        end,
    }
end
do
    local bl, bm, bn, bo, bp = 'rbxassetid://16658221428', false, false, {}, nil

    local function r()
        if bp and bp.Parent then
            return bp
        end

        bp = Instance.new'Folder'
        bp.Name = 'bloxstrikebloxNametags'

        local bq = {
            function()
                return gethui()
            end,
            function()
                return game:GetService'CoreGui'
            end,
            function()
                return _:FindFirstChildOfClass'PlayerGui'
            end,
        }

        for br, bs in ipairs(bq)do
            if pcall(function()
                bp.Parent = bs()
            end) and bp.Parent then
                break
            end
        end

        return bp
    end
    local function y()
        local bq = Instance.new'BillboardGui'

        bq.Name = 'Tag'
        bq.AlwaysOnTop = true
        bq.LightInfluence = 0
        bq.MaxDistance = math.huge
        bq.ResetOnSpawn = false
        bq.Size = UDim2.fromOffset(300, 22)
        bq.StudsOffset = Vector3.new(0, 2.6, 0)

        local br = Instance.new'Frame'

        br.AnchorPoint = Vector2.new(0.5, 0.5)
        br.Position = UDim2.fromScale(0.5, 0.5)
        br.Size = UDim2.fromScale(0, 1)
        br.AutomaticSize = Enum.AutomaticSize.X
        br.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        br.BackgroundTransparency = 0.55
        br.BorderSizePixel = 0
        br.Parent = bq

        local bs = Instance.new'UIPadding'

        bs.PaddingLeft = UDim.new(0, 6)
        bs.PaddingRight = UDim.new(0, 6)
        bs.Parent = br

        local bt = Instance.new'UIListLayout'

        bt.FillDirection = Enum.FillDirection.Horizontal
        bt.VerticalAlignment = Enum.VerticalAlignment.Center
        bt.SortOrder = Enum.SortOrder.LayoutOrder
        bt.Padding = UDim.new(0, 5)
        bt.Parent = br

        local bu = Instance.new'Frame'

        bu.LayoutOrder = 1
        bu.Size = UDim2.fromOffset(8, 8)
        bu.BorderSizePixel = 0

        local bv = Instance.new'UICorner'

        bv.CornerRadius = UDim.new(1, 0)
        bv.Parent = bu
        bu.Parent = br

        local bw = Instance.new'TextLabel'

        bw.LayoutOrder = 2
        bw.Size = UDim2.fromScale(0, 1)
        bw.AutomaticSize = Enum.AutomaticSize.X
        bw.BackgroundTransparency = 1
        bw.FontFace = Font.new(bl, Enum.FontWeight.Bold)
        bw.TextSize = 14
        bw.TextColor3 = Color3.fromRGB(222, 222, 222)
        bw.RichText = true
        bw.Parent = br

        return {
            gui = bq,
            dot = bu,
            label = bw,
        }
    end
    local function P(bq)
        local br = bo[bq]

        if br then
            pcall(function()
                br.gui:Destroy()
            end)

            bo[bq] = nil
        end
    end
    local function q()
        for bq in pairs(bo)do
            P(bq)
        end

        if bp then
            pcall(function()
                bp:Destroy()
            end)

            bp = nil
        end
    end

    aa.onUnload(q)
    aa.connect(u.PlayerRemoving, P)
    aa.connect(O.RenderStepped, function()
        if not bm then
            return
        end

        local bq, br = (U()).Position, r()

        for bs, bt in ipairs(aa.entities())do
            local bu = bt ~= _ and k(bt)
            local bv = bt ~= _ and ((not bu or aC.espTeam) and bt.Character)

            if bv and (bv:GetAttribute'Dead' and not bn) then
                bv = nil
            end
            if bv and not bv:IsDescendantOf(workspace) then
                bv = nil
            end

            local bw = bv and (bv:FindFirstChild'Head' or bv:FindFirstChild'HumanoidRootPart')

            if bw then
                local bx = bo[bt]

                if not bx or not bx.gui.Parent then
                    P(bt)

                    bx = y()
                    bo[bt] = bx
                end

                bx.dot.BackgroundColor3 = bu and aC.espTeamColor or aC.espEnemyColor

                if bx.gui.Adornee ~= bw then
                    bx.gui.Adornee = bw
                end
                if bx.gui.Parent ~= br then
                    bx.gui.Parent = br
                end

                local by = math.floor((bw.Position - bq).Magnitude * 0.28 + 0.5)
                local bz = bt.Name .. (' <font color="#E04B4B">[' .. (by .. 'm]</font>'))

                if bx.text ~= bz then
                    bx.text = bz
                    bx.label.Text = bz
                end
            else
                P(bt)
            end
        end

        local bs = aa.entities()

        for bt in pairs(bo)do
            if not table.find(bs, bt) then
                P(bt)
            end
        end
    end)
    ak.register('Nametags', tagToggle, {
        kind = 'toggle',
        title = 'Nametags',
        isActive = function()
            return bm
        end,
        setState = function(bq)
            bm = bq

            if not bq then
                q()
            end

            pcall(function()
                tagToggle:Set(bq)
            end)
        end,
    })
end

bk:Section{
    Title = 'third person',
}

do
    local bl, bm, bn, bo, bp, bq, br, bs, bt, bu, bv, bw = 'bloxstrikebloxThirdPerson', false, 8, 0.5, 0, true, false, 'Camera', setmetatable({}, {
        __mode = 'k',
    }), setmetatable({}, {
        __mode = 'k',
    }), false, RaycastParams.new()

    bw.FilterType = Enum.RaycastFilterType.Exclude

    local bx

    local function Q(by, bz)
        for bA, bB in ipairs(by:GetDescendants())do
            if bB:IsA'BasePart' and (bB.Name ~= 'HumanoidRootPart' and bB.Name ~= 'CameraPart') then
                bB.LocalTransparencyModifier = bz
            end
        end
    end
    local function b()
        for by, bz in pairs(bt)do
            if by.Parent then
                by.C0 = bz
            end
        end

        table.clear(bt)
    end
    local function a()
        for by in pairs(bu)do
            if by.Parent then
                by.LocalTransparencyModifier = 0
            end
        end

        table.clear(bu)
    end

    local by, bz, bA, bB = require(L.Controllers.Observers.Players.Components.CreateWeaponModel), false

    local function G(bC)
        task.spawn(function()
            if setthreadidentity then
                pcall(setthreadidentity, 2)
            end

            pcall(bC)
        end)
    end
    local function J()
        if not bz then
            return
        end

        bz, bA, bB = false, nil, nil

        local bC = au.getCurrentCharacter()

        G(function()
            by.ClearPlayerCache(_)

            if bC then
                bC.CharacterAnimator:setWeapon(nil, nil, true)
            end
        end)
    end
    local function S()
        local bC, bD = _:GetAttribute'CurrentEquipped', au.getCurrentCharacter()

        if bz and (bC == bA and bD == bB) then
            return
        end

        bA, bB, bz = bC, bD, true

        local bE, bF = pcall(ar.JSONDecode, ar, type(bC) == 'string' and bC or '')

        G(function()
            if bE and (type(bF) == 'table' and type(bF.Name) == 'string') then
                by(_, bF, {})

                if bD then
                    bD.CharacterAnimator:setWeapon(bF.Name, bF.Identifier, true)
                end
            else
                by.ClearPlayerCache(_)

                if bD then
                    bD.CharacterAnimator:setWeapon(nil, nil, true)
                end
            end
        end)
    end

    local bC

    local function H()
        if not bv then
            return
        end

        bv = false
        aH.active, aH.eye = false, nil

        b()
        a()
        J()

        if _.Character then
            bC(_.Character)
        end

        local bD = _.Character

        if bD then
            Q(bD, 1)
        end
    end
    local function i(bD)
        return math.atan2(-bD.X, -bD.Z)
    end

    local bD, bE, bF = require(L.Components.Common.CharacterPose), setmetatable({}, {
        __mode = 'k',
    }), setmetatable({}, {
        __mode = 'k',
    })

    local function W(bG)
        local bH = bE[bG]

        if not bH then
            local bI, bJ = pcall(bD.getJoints, bG)

            if bI and type(bJ) == 'table' then
                bH = bJ
                bE[bG] = bH
            end
        end

        return bH
    end

    bC = function(bG)
        if not bF[bG] then
            return
        end

        bF[bG] = nil

        local bH = W(bG)

        if bH then
            pcall(bD.applyVerticalLook, bH, 0, 0.003)
        end
    end

    local function X(bG, bH)
        local bI = aC.aa and aH.sentYaw ~= nil

        if not br and not bI then
            bC(bG)

            return
        end

        local bJ = bG:FindFirstChild'HumanoidRootPart'

        if not bJ then
            return
        end

        local bK, bL = i(bH.LookVector), bH.LookVector.Y

        if bI or bs == 'Sent Angles' and aH.sentYaw then
            bK, bL = aH.sentYaw, aH.sentPitch or bL
        end

        pcall(function()
            bJ.CFrame = bD.composeRootCFrame(bJ.Position, bK)
        end)

        local bM = W(bG)

        if bM then
            pcall(bD.applyVerticalLook, bM, math.clamp(bL, -1, 1), 0.003)

            bF[bG] = true
        end
    end
    local function U()
        local bG = _.Character

        if not bm or not bG or bG:GetAttribute'Dead' then
            H()

            return
        end

        local bH = at.CFrame

        aH.eye, aH.active = bH, true
        bv = true

        local bI, bJ = bH.Position, bH:VectorToWorldSpace(Vector3.new(bp, bo, bn))
        local bK = bJ.Magnitude

        if bK > 0.01 then
            if bq then
                bw.FilterDescendantsInstances = {bG, at}

                local bL = workspace:Raycast(bI, bJ, bw)

                if bL then
                    bK = math.max((bL.Position - bI).Magnitude - 0.3, 0.2)
                end
            end

            at.CFrame = bH.Rotation + (bI + bJ.Unit * bK)
            bx = at.CFrame
        end

        Q(bG, 0)

        local bL = p()
        local bM = bL and (bL.Viewmodel and bL.Viewmodel.Model)

        if bM then
            for bN, bO in ipairs(bM:GetDescendants())do
                if bO:IsA'BasePart' then
                    bO.LocalTransparencyModifier = 1
                    bu[bO] = true
                end
            end
        end

        X(bG, bH)
        S()
    end

    O:BindToRenderStep(bl, Enum.RenderPriority.Last.Value, U)
    aa.connect(O.Heartbeat, function()
        if bx and (aH.active and (aH.eye and at.CFrame == bx)) then
            at.CFrame = aH.eye
        end

        bx = nil
    end)
    aa.onUnload(function()
        pcall(function()
            O:UnbindFromRenderStep(bl)
        end)
        H()
    end)

    local bG = bk:Toggle{
        Title = 'third person',
        Value = false,
        Flag = 'thirdPerson',
        Callback = function(bG)
            bm = bG
        end,
    }

    ak.register('Third Person', bG, {
        kind = 'toggle',
        title = 'Third Person',
        isActive = function()
            return bm
        end,
        setState = function(bH)
            bm = bH

            pcall(function()
                bG:Set(bH)
            end)
        end,
    })
    bk:Slider{
        Title = 'distance',
        Value = {
            Min = 2,
            Max = 25,
            Default = 8,
        },
        Step = 0.5,
        Flag = 'tpDistance',
        Callback = function(bH)
            bn = bH
        end,
    }
    bk:Slider{
        Title = 'height',
        Value = {
            Min = -2,
            Max = 5,
            Default = 0.5,
        },
        Step = 0.25,
        Flag = 'tpHeight',
        Callback = function(bH)
            bo = bH
        end,
    }
    bk:Slider{
        Title = 'shoulder offset',
        Value = {
            Min = -4,
            Max = 4,
            Default = 0,
        },
        Step = 0.25,
        Flag = 'tpShoulder',
        Callback = function(bH)
            bp = bH
        end,
    }
    bk:Toggle{
        Title = 'camera collision',
        Value = true,
        Flag = 'tpCollide',
        Callback = function(bH)
            bq = bH
        end,
    }
    bk:Toggle{
        Title = 'body rotation',
        Value = false,
        Flag = 'tpHeadRot',
        Callback = function(bH)
            br = bH
        end,
    }
    bk:Dropdown{
        Title = 'body follows',
        Values = {
            'Camera',
            'Sent Angles',
        },
        Value = 'Camera',
        Flag = 'tpHeadFollow',
        Callback = function(bH)
            bs = type(bH) == 'table' and bH[1] or bH
        end,
    }
end
do
    local bl, bm, bn, bo = game:GetService'CollectionService', require(L.Shared.GrenadeSimulator), require(L.Database.Security.Remotes), L.Components.Common.VFXLibary
    local bp, bq, br, bs, bt, bu, bv, bw, bx, by, bz, bA = require(bo.FlashEffect), require(bo.CreateVoxelSmoke), workspace:FindFirstChild'Debris', 0.016666666666667, 300, 20, 0.7, {
        ['HE Grenade'] = {
            color = Color3.fromRGB(255, 60, 60),
            radius = 26,
            linger = 0.6,
        },
        Flashbang = {
            color = Color3.fromRGB(255, 255, 190),
            radius = 20,
            linger = 0.6,
        },
        ['Smoke Grenade'] = {
            color = Color3.fromRGB(170, 170, 170),
            radius = 11,
            linger = 18,
        },
        Molotov = {
            color = Color3.fromRGB(255, 140, 40),
            radius = 11,
            linger = 7,
        },
        ['Incendiary Grenade'] = {
            color = Color3.fromRGB(255, 140, 40),
            radius = 11,
            linger = 7,
        },
        ['Decoy Grenade'] = {
            color = Color3.fromRGB(80, 200, 120),
            radius = 4,
            linger = 15,
        },
    }, {
        Molotov = true,
        ['Incendiary Grenade'] = true,
    }, {}, {
        Radius = 0.25,
        Restitution = 0.4,
        MaxBounces = 20,
        FuseTime = 0,
    }, {
        ['HE Grenade'] = 1.6,
        Flashbang = 1.6,
        Molotov = 2,
        ['Incendiary Grenade'] = 2,
    }

    pcall(function()
        bn.Projectile.Spawn.Listen(function(bB)
            if type(bB) == 'table' and (type(bB.Weapon) == 'string' and type(bB.Physics) == 'table') then
                by[bB.Weapon] = bB.Physics
            end
        end)
    end)

    local bB, bC, bD, bE = false, false, false, Instance.new'Folder'

    bE.Name = 'bloxstrikebloxGrenades'
    bE.Parent = at

    aa.onUnload(function()
        bE:Destroy()
    end)

    local function S(bF)
        local bG = Instance.new'Part'

        bG.Anchored, bG.CanCollide, bG.CanQuery, bG.CanTouch, bG.CastShadow = true, false, false, false, false
        bG.Material = Enum.Material.Neon
        bG.Shape = bF or Enum.PartType.Block
        bG.Transparency = bv
        bG.Parent = bE

        return bG
    end

    local bF, bG, bH = {}, 0, S(Enum.PartType.Ball)

    bH.Transparency = 1

    local function s()
        for bI = 1, #bF, 1 do
            bF[bI].Transparency = 1
        end

        bH.Transparency = 1
    end
    local function g(bI, bJ, bK, bL)
        local bM = bF[bI]

        if not bM then
            bM = S()
            bF[bI] = bM
        end

        local bN = (bK - bJ).Magnitude

        bM.Size = Vector3.new(0.08, 0.08, math.max(bN, 0.01))
        bM.CFrame = CFrame.lookAt(bJ, bK) * CFrame.new(0, 0, -bN / 2)
        bM.Color = bL
        bM.Transparency = 0.2
    end
    local function f()
        local bI = au.getCurrentCharacter()
        local bJ = bI and bI.GlobalVelocity

        return typeof(bJ) == 'Vector3' and bJ or Vector3.zero
    end
    local function W(bI, bJ)
        local bK = by[bI] or bz
        local bL = (bK.FuseTime and bK.FuseTime > 0) and bK.FuseTime or bA[bI]
        local bM, bN = {
            rangeScale = 1,
            isNearThrow = bJ == 'Near',
            radius = bK.Radius or bz.Radius,
            restitution = bK.Restitution or bz.Restitution,
            maxBounces = bK.MaxBounces or bz.MaxBounces,
            fuseTime = bL,
            minimumFuseTime = bx[bI] and 0.1 or nil,
            explodeOnFloorImpact = bx[bI] or nil,
        }, RaycastParams.new()

        bN.FilterType = Enum.RaycastFilterType.Exclude
        bN.FilterDescendantsInstances = {
            _.Character,
            at,
            br,
        }
        bN.RespectCanCollide = false
        bN.IgnoreWater = true

        if bK.CollisionGroup then
            bN.CollisionGroup = bK.CollisionGroup
        end

        local bO = U()
        local bP, bQ = bm.calculateThrowParameters(bO.Position, bO.LookVector, bJ, 1)
        local bR = bm.createInitialState(bP, bQ, bJ, f(), 1, tick())
        local bS = {
            bR.position,
        }

        for bU = 1, bt, 1 do
            local bV = bm.simulate(bR, bM, bN, bs)

            bR = bV.state
            bS[#bS + 1] = bR.position

            local bW = bR.isAtRest

            for bX, bY in ipairs(bV.events or {})do
                if bY.type == 'rest' or bY.type == 'fuse' or bY.type == 'floor_impact' then
                    bW = true
                end
            end

            if bW then
                break
            end
        end

        return bS
    end
    local function X()
        local bI = p()
        local bJ = bI and bI.Name

        if bJ and bw[bJ] then
            return bJ
        end

        return nil
    end

    local bI = 0

    aa.connect(O.RenderStepped, function()
        if not bB then
            if bG > 0 then
                s()

                bG = 0
            end

            return
        end

        local bJ = X()

        if not bJ then
            if bG > 0 then
                s()

                bG = 0
            end

            return
        end
        if os.clock() - bI < 1 / bu then
            return
        end

        bI = os.clock()

        local bK = an:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) and 'Near' or 'Far'
        local bL, bM = pcall(W, bJ, bK)

        if not bL or #bM < 2 then
            return
        end

        local bN, bO = bw[bJ], 0

        for bP = 1, #bM - 1, 2 do
            bO = bO + 1

            g(bO, bM[bP], bM[math.min(bP + 2, #bM)], bN.color)
        end
        for bP = bO + 1, #bF, 1 do
            bF[bP].Transparency = 1
        end

        bG = bO

        local bP = bN.radius

        bH.Size = Vector3.new(bP * 2, bP * 2, bP * 2)
        bH.CFrame = CFrame.new(bM[#bM])
        bH.Color = bN.color
        bH.Transparency = bv
    end)

    local bJ = {}

    aa.connect(O.Heartbeat, function()
        local bK = os.clock()

        if bC then
            for bL, bM in ipairs(bl:GetTagged'Grenade')do
                local bN = bM:GetAttribute'GrenadeName'
                local bO = bN and bw[bN]

                if bO and bM.PrimaryPart then
                    local bP = bJ[bM]

                    if not bP then
                        bP = {
                            name = bN,
                            part = S(Enum.PartType.Ball),
                        }
                        bP.part.Color = bO.color
                        bP.part.Size = Vector3.new(bO.radius * 2, bO.radius * 2, bO.radius * 2)
                        bJ[bM] = bP
                    end
                    if not bP.landedAt then
                        bP.pos = bM.PrimaryPart.Position

                        if bM:GetAttribute'SimulationFinished' then
                            bP.landedAt = bK
                        end
                    end
                end
            end
        end

        for bL, bM in pairs(bJ)do
            local bN = bw[bM.name]
            local bO, bP = bM.landedAt and bK - bM.landedAt > bN.linger, not bL.Parent and not bM.landedAt

            if not bC or bO or bP then
                bM.part:Destroy()

                bJ[bL] = nil
            else
                bM.part.CFrame = CFrame.new(bM.pos)
                bM.part.Transparency = bv
            end
        end
    end)

    do
        local bK

        bK = Q(bp.Flash, function(...)
            if not aa.unloaded and aC.antiFlash then
                return false
            end

            return bK(...)
        end)
        aC.cancelFlash = function()
            pcall(function()
                if bp.IsFlashed() then
                    bp.CancelFlash()
                end
            end)
        end

        local bL

        bL = Q(bq.Create, function(...)
            if not aa.unloaded and bD then
                return nil
            end

            return bL(...)
        end)
    end

    if setthreadidentity then
        pcall(setthreadidentity, 8)
    end

    ak.register('Grenade Trajectory', previewToggle, {
        kind = 'toggle',
        title = 'Grenade Trajectory',
        isActive = function()
            return bB
        end,
        setState = function(bK)
            bB = bK

            pcall(function()
                previewToggle:Set(bK)
            end)
        end,
    })

    local bK = {
        {
            'HE Radius',
            'HE Grenade',
            26,
        },
        {
            'Flash Radius',
            'Flashbang',
            20,
        },
        {
            'Smoke Radius',
            'Smoke Grenade',
            11,
        },
        {
            'Fire Radius',
            'Molotov',
            11,
        },
    }

    for bL, bM in ipairs(bK)do
        bk:Slider{
            Title = bM[1],
            Value = {
                Min = 2,
                Max = 40,
                Default = bM[3],
            },
            Flag = 'grenadeRadius_' .. bM[2],
            Callback = function(bN)
                bw[bM[2] ].radius = bN

                if bM[2] == 'Molotov' then
                    bw['Incendiary Grenade'].radius = bN
                end

                for bO, bP in pairs(bJ)do
                    local bQ = bw[bP.name].radius

                    bP.part.Size = Vector3.new(bQ * 2, bQ * 2, bQ * 2)
                end
            end,
        }
    end
end

bk:Section{
    Title = 'camera',
}

do
    local bl, bm, bn, bo = 'bloxstrikebloxCameraMods', false, 90
    local bp, bq, br = false, 70
    local bs, bt, bu, bv, bw, bx = false, 0, 0, 0, false, nil

    local function a()
        if bx and bx.Parent then
            return bx
        end

        local by = _:FindFirstChildOfClass'PlayerGui'

        bx = by and by:FindFirstChild('SniperScope', true)

        return bx
    end
    local function T()
        local by = a()

        if by and by.Visible then
            return true
        end

        local bz = p()

        return bz ~= nil and (bz.IsAiming == true or bz.IsSniperScoped == true or (bz.CurrentScopeIncrement or 0) > 0)
    end

    do
        local by, bz = require(L.Classes.WeaponComponent.Classes.Viewmodel), nil

        bz = Q(by.render, function(bA, ...)
            local bB = bz(bA, ...)

            if bA.Player == _ then
                aC.vmModel = bA.Model
            end
            if not aa.unloaded and (bs and (not aH.active and (bA.Player == _ and bA.Model))) then
                pcall(function()
                    bA.Model:PivotTo(bA.Model:GetPivot() * CFrame.new(bt, bu, bv))

                    if bA.LargeWeaponModel and bA.SmallWeaponModel then
                        bA.LargeWeaponModel:PivotTo(bA.SmallWeaponModel:GetPivot())
                    end
                end)
            end

            return bB
        end)
    end

    local by = {}

    for bz = 1, 4, 1 do
        local bA = Instance.new'Frame'

        bA.BorderSizePixel = 0
        bA.Visible = false
        bA.Parent = aL

        local bB = Instance.new'UIGradient'

        bB.Rotation = bz <= 2 and 0 or 90
        bB.Parent = bA
        by[bz] = bA
    end

    local bz, bA, bB = NumberSequence.new(0), NumberSequence.new(1, 0), NumberSequence.new(0, 1)

    local function n()
        local bC = aC.scopeStyle == 'Gradient'
        local bD, bE, bF, bG = bC and aC.scopeGap or 0, bC and aC.scopeLen / 100 or 1, bC and aC.scopeThick or 1, bC and aC.scopeColor or Color3.new(0, 0, 0)

        for bH, bI in ipairs(by)do
            local bJ = bI:FindFirstChildOfClass'UIGradient'

            bI.BackgroundColor3 = bG

            if bH == 1 then
                bI.AnchorPoint = Vector2.new(1, 0.5)
                bI.Position = UDim2.new(0.5, -bD, 0.5, 0)
                bI.Size = UDim2.new(0.5 * bE, 0, 0, bF)
                bJ.Transparency = bC and bA or bz
            elseif bH == 2 then
                bI.AnchorPoint = Vector2.new(0, 0.5)
                bI.Position = UDim2.new(0.5, bD, 0.5, 0)
                bI.Size = UDim2.new(0.5 * bE, 0, 0, bF)
                bJ.Transparency = bC and bB or bz
            elseif bH == 3 then
                bI.AnchorPoint = Vector2.new(0.5, 1)
                bI.Position = UDim2.new(0.5, 0, 0.5, -bD)
                bI.Size = UDim2.new(0, bF, 0.5 * bE, 0)
                bJ.Transparency = bC and bA or bz
            else
                bI.AnchorPoint = Vector2.new(0.5, 0)
                bI.Position = UDim2.new(0.5, 0, 0.5, bD)
                bI.Size = UDim2.new(0, bF, 0.5 * bE, 0)
                bJ.Transparency = bC and bB or bz
            end
        end
    end

    n()

    local bC = {}

    local function J(bD)
        for bE, bF in ipairs(bD:GetDescendants())do
            local bG = bF:IsA'Frame' and (bF.Name == 'Left' or bF.Name == 'Right' or bF.Name == 'Top' or bF.Name == 'Bottom')

            if bG or bF:IsA'ImageLabel' then
                if bC[bF] == nil then
                    bC[bF] = {
                        'Visible',
                        bF.Visible,
                    }
                end

                bF.Visible = false
            end
        end
    end
    local function S()
        for bD, bE in pairs(bC)do
            if bD.Parent then
                pcall(function()
                    bD[bE[1] ] = bE[2]
                end)
            end
        end

        table.clear(bC)
    end

    O:BindToRenderStep(bl, Enum.RenderPriority.Last.Value + 1, function()
        local bD, bE = T(), at.FieldOfView
        local bF = bE < bn - 0.5 and (bo ~= nil and bE < bo - 0.5)

        if not bD and not bF then
            if bm then
                at.FieldOfView = bn
            else
                bq = bE
            end

            br = an.MouseDeltaSensitivity
        elseif bp then
            at.FieldOfView = bm and bn or bq

            if br then
                an.MouseDeltaSensitivity = br
            end
        end

        local bG = a()
        local bH = bw and (bG ~= nil and bG.Visible)

        if bH then
            J(bG)
        elseif next(bC) then
            S()
        end

        for bI, bJ in ipairs(by)do
            bJ.Visible = bH
        end
    end)
    aa.onUnload(function()
        pcall(function()
            O:UnbindFromRenderStep(bl)
        end)
        S()

        if bo then
            at.FieldOfView = bo
        end
    end)

    local bD = bk:Toggle{
        Title = 'fov changer',
        Value = false,
        Flag = 'fovChanger',
        Callback = function(bD)
            if bD and not bm then
                bo = at.FieldOfView
            end

            bm = bD

            if not bD and (bo and not T()) then
                at.FieldOfView = bo
            end
        end,
    }

    ak.register('FOV Changer', bD, {
        kind = 'toggle',
        title = 'FOV Changer',
        isActive = function()
            return bm
        end,
        setState = function(bE)
            if bE and not bm then
                bo = at.FieldOfView
            end

            bm = bE

            if not bE and (bo and not T()) then
                at.FieldOfView = bo
            end

            pcall(function()
                bD:Set(bE)
            end)
        end,
    })
    bk:Slider{
        Title = 'fov',
        Value = {
            Min = 50,
            Max = 120,
            Default = 90,
        },
        Flag = 'fovSlider',
        Callback = function(bE)
            bn = bE
        end,
    }
    bk:Toggle{
        Title = 'no scope zoom',
        Value = false,
        Flag = 'noScopeZoom',
        Callback = function(bE)
            bp = bE
        end,
    }
    bk:Toggle{
        Title = 'no scope borders',
        Value = false,
        Flag = 'noScopeBorders',
        Callback = function(bE)
            bw = bE
        end,
    }
    bk:Dropdown{
        Title = 'scope lines',
        Values = {
            'Line',
            'Gradient',
        },
        Value = 'Line',
        Flag = 'scopeStyle',
        Callback = function(bE)
            aC.scopeStyle = type(bE) == 'table' and bE[1] or bE

            n()
        end,
    }
    bk:Colorpicker{
        Title = 'scope line color',
        Default = aC.scopeColor,
        Flag = 'scopeColor',
        Callback = function(bE)
            aC.scopeColor = bE

            n()
        end,
    }
    bk:Slider{
        Title = 'scope line length',
        Value = {
            Min = 10,
            Max = 100,
            Default = 60,
        },
        Step = 5,
        Flag = 'scopeLen',
        Callback = function(bE)
            aC.scopeLen = bE

            n()
        end,
    }
    bk:Slider{
        Title = 'scope line gap',
        Value = {
            Min = 0,
            Max = 80,
            Default = 12,
        },
        Flag = 'scopeGap',
        Callback = function(bE)
            aC.scopeGap = bE

            n()
        end,
    }
    bk:Slider{
        Title = 'scope line thickness',
        Value = {
            Min = 1,
            Max = 5,
            Default = 1,
        },
        Flag = 'scopeThick',
        Callback = function(bE)
            aC.scopeThick = bE

            n()
        end,
    }

    do
        local bE = false

        pcall(function()
            local bF = require(L.Controllers.CameraController)

            for bG, bH in ipairs{
                'weaponKick',
                'BombExploded',
                'OnLanded',
            }do
                local bI = bF[bH]

                if type(bI) == 'function' then
                    bF[bH] = function(...)
                        if bE and not aa.unloaded then
                            return
                        end

                        return bI(...)
                    end

                    aa.onUnload(function()
                        bF[bH] = bI
                    end)
                end
            end
        end)
        bk:Toggle{
            Title = 'remove screen shake',
            Value = false,
            Flag = 'noShake',
            Callback = function(bF)
                bE = bF
            end,
        }
    end

    bk:Toggle{
        Title = 'anti flash',
        Value = false,
        Flag = 'antiFlash',
        Callback = function(bE)
            aC.antiFlash = bE

            if bE and aC.cancelFlash then
                aC.cancelFlash()
            end
        end,
    }
    bk:Toggle{
        Title = 'viewmodel changer',
        Value = false,
        Flag = 'vmChanger',
        Callback = function(bE)
            bs = bE
        end,
    }

    for bE, bF in ipairs{
        {
            'x',
            'vmX',
        },
        {
            'y',
            'vmY',
        },
        {
            'z',
            'vmZ',
        },
    }do
        bk:Slider{
            Title = 'viewmodel ' .. bF[1],
            Value = {
                Min = -3,
                Max = 3,
                Default = 0,
            },
            Step = 0.05,
            Flag = bF[2] .. 'Slider',
            Callback = function(bG)
                if bF[1] == 'x' then
                    bt = bG
                elseif bF[1] == 'y' then
                    bu = bG
                else
                    bv = bG
                end
            end,
        }
    end
end

bk:Section{
    Title = 'hit effects',
}
bk:Toggle{
    Title = 'hit marker',
    Value = false,
    Flag = 'hitMarker',
    Callback = function(bl)
        aC.hitMarker = bl
    end,
}
bk:Colorpicker{
    Title = 'hit marker color',
    Default = aC.hitMarkerColor,
    Flag = 'hitMarkerColor',
    Callback = function(bl)
        aC.hitMarkerColor = bl
    end,
}
bk:Colorpicker{
    Title = 'kill marker color',
    Default = aC.hitMarkerKill,
    Flag = 'hitMarkerKill',
    Callback = function(bl)
        aC.hitMarkerKill = bl
    end,
}
bk:Dropdown{
    Title = 'hit marker position',
    Values = {
        'Crosshair',
        'Where It Landed',
        'Both',
    },
    Value = 'Crosshair',
    Flag = 'hitMarkerWhere',
    Callback = function(bl)
        aC.hitMarkerWhere = type(bl) == 'table' and bl[1] or bl
    end,
}
bk:Dropdown{
    Title = 'hit marker animation',
    Values = {
        'Fade',
        'Expand',
        'Shrink',
        'Spin',
    },
    Value = 'Fade',
    Flag = 'hitMarkerAnim',
    Callback = function(bl)
        aC.hitMarkerAnim = type(bl) == 'table' and bl[1] or bl
    end,
}
bk:Slider{
    Title = 'hit marker time (s)',
    Value = {
        Min = 0.1,
        Max = 3,
        Default = 0.45,
    },
    Step = 0.05,
    Flag = 'hitMarkerTime',
    Callback = function(bl)
        aC.hitMarkerTime = bl
    end,
}
bk:Dropdown{
    Title = 'hit marker shape',
    Values = {
        'X',
        'Plus',
        'Square',
        'Circle',
    },
    Value = 'X',
    Flag = 'hitMarkerShape',
    Callback = function(bl)
        aC.hitMarkerShape = type(bl) == 'table' and bl[1] or bl
    end,
}
bk:Slider{
    Title = 'hit marker size',
    Value = {
        Min = 2,
        Max = 40,
        Default = 10,
    },
    Flag = 'hitMarkerSize',
    Callback = function(bl)
        aC.hitMarkerSize = bl
    end,
}
bk:Slider{
    Title = 'hit marker thickness',
    Value = {
        Min = 1,
        Max = 8,
        Default = 2,
    },
    Flag = 'hitMarkerThick',
    Callback = function(bl)
        aC.hitMarkerThick = bl
    end,
}
bk:Slider{
    Title = 'hit marker gap',
    Value = {
        Min = 0,
        Max = 40,
        Default = 4,
    },
    Flag = 'hitMarkerGap',
    Callback = function(bl)
        aC.hitMarkerGap = bl
    end,
}
bk:Toggle{
    Title = 'hit marker outline',
    Value = true,
    Flag = 'hitMarkerOutline',
    Callback = function(bl)
        aC.hitMarkerOutline = bl
    end,
}
bk:Slider{
    Title = 'kill marker scale',
    Value = {
        Min = 1,
        Max = 3,
        Default = 1.4,
    },
    Step = 0.1,
    Flag = 'hitMarkerKillScale',
    Callback = function(bl)
        aC.hitMarkerKillScale = bl
    end,
}
bk:Toggle{
    Title = 'hit marker damage',
    Value = false,
    Flag = 'hitMarkerDamage',
    Callback = function(bl)
        aC.hitMarkerDamage = bl
    end,
}
bk:Slider{
    Title = 'world marker rise',
    Value = {
        Min = 0,
        Max = 6,
        Default = 0,
    },
    Step = 0.5,
    Flag = 'hitMarkerRise',
    Callback = function(bl)
        aC.hitMarkerRise = bl
    end,
}
bk:Button{
    Title = 'test hit marker',
    Callback = function()
        if a_.testMarker then
            a_.testMarker()
        end
    end,
}
bulletTab:Section{
    Title = 'bullet tracer',
}
bulletTab:Toggle{
    Title = 'bullet tracer',
    Value = false,
    Flag = 'tracerEnabled',
    Callback = function(bl)
        aC.tracer = bl
    end,
}

aF = bulletTab:Colorpicker{
    Title = 'tracer color',
    Default = aD,
    Flag = 'tracerColor',
    Callback = function(bl)
        aD = bl
    end,
}

bulletTab:Slider{
    Title = 'tracer width',
    Value = {
        Min = 1,
        Max = 30,
        Default = 6,
    },
    Flag = 'tracerWidth',
    Callback = function(bl)
        aC.tracerWidth = bl / 100
    end,
}
bulletTab:Slider{
    Title = 'tracer lifetime (s)',
    Value = {
        Min = 0.1,
        Max = 10,
        Default = 1,
    },
    Step = 0.1,
    Flag = 'tracerLife',
    Callback = function(bl)
        aC.tracerLife = bl
    end,
}
bulletTab:Dropdown{
    Title = 'tracer style',
    Values = {
        'Line',
        'Beam',
        'Lightning',
    },
    Value = 'Line',
    Flag = 'tracerStyle',
    Callback = function(bl)
        aC.tracerStyle = type(bl) == 'table' and bl[1] or bl
    end,
}
bulletTab:Dropdown{
    Title = 'tracer start',
    Values = {
        'Gun',
        'Eye',
    },
    Value = 'Gun',
    Flag = 'tracerFrom',
    Callback = function(bl)
        aC.tracerFrom = type(bl) == 'table' and bl[1] or bl
    end,
}
bulletTab:Toggle{
    Title = 'rainbow tracers',
    Value = false,
    Flag = 'tracerRainbow',
    Callback = function(bl)
        aC.tracerRainbow = bl
    end,
}
bulletTab:Toggle{
    Title = 'only on hits',
    Value = false,
    Flag = 'tracerOnlyHits',
    Callback = function(bl)
        aC.tracerOnlyHits = bl
    end,
}
bulletTab:Toggle{
    Title = 'impact marker',
    Value = false,
    Flag = 'impactEnabled',
    Callback = function(bl)
        aC.impact = bl
    end,
}
bulletTab:Slider{
    Title = 'impact size',
    Value = {
        Min = 0.1,
        Max = 1.5,
        Default = 0.35,
    },
    Step = 0.05,
    Flag = 'impactSize',
    Callback = function(bl)
        aC.impactSize = bl
    end,
}
bulletTab:Toggle{
    Title = 'impact glow',
    Value = false,
    Flag = 'impactGlow',
    Callback = function(bl)
        aC.impactGlow = bl
    end,
}

aG = bulletTab:Colorpicker{
    Title = 'impact color',
    Default = aE,
    Flag = 'impactColor',
    Callback = function(bl)
        aE = bl
    end,
}

bulletTab:Section{
    Title = 'hit sound',
}
bulletTab:Toggle{
    Title = 'hit sound',
    Value = false,
    Flag = 'hitSound',
    Callback = function(bl)
        aC.hitSound = bl
    end,
}
bulletTab:Input{
    Title = 'hit sound id',
    Value = aC.hitSoundId,
    Placeholder = '3744371342',
    Flag = 'hitSoundId',
    Callback = function(bl)
        aC.hitSoundId = bl
    end,
}
bulletTab:Slider{
    Title = 'hit volume',
    Value = {
        Min = 0,
        Max = 100,
        Default = 60,
    },
    Flag = 'hitVol',
    Callback = function(bl)
        aC.hitVol = bl / 100
    end,
}
bulletTab:Button{
    Title = 'test hit sound',
    Callback = function()
        zT(aC.hitSoundId, aC.hitVol)
    end,
}
bulletTab:Section{
    Title = 'kill sound',
}
bulletTab:Toggle{
    Title = 'kill sound',
    Value = false,
    Flag = 'killSound',
    Callback = function(bl)
        aC.killSound = bl
    end,
}
bulletTab:Input{
    Title = 'kill sound id',
    Value = aC.killSoundId,
    Placeholder = '3744371342',
    Flag = 'killSoundId',
    Callback = function(bl)
        aC.killSoundId = bl
    end,
}
bulletTab:Slider{
    Title = 'kill volume',
    Value = {
        Min = 0,
        Max = 100,
        Default = 100,
    },
    Flag = 'killVol',
    Callback = function(bl)
        aC.killVol = bl / 100
    end,
}
bulletTab:Button{
    Title = 'test kill sound',
    Callback = function()
        zT(aC.killSoundId, aC.killVol)
    end,
}

local bl = ad:Tab{
    Title = 'movement',
    Icon = 'move',
}

bl:Section{
    Title = 'bunny hop',
}

do
    local bm = bl:Toggle{
        Title = 'auto bhop',
        Value = false,
        Flag = 'bhop',
        Callback = function(bm)
            vT(bm)
        end,
    }

    ak.register('Auto Bhop', bm, {
        kind = 'toggle',
        title = 'Auto Bhop',
        isActive = function()
            return aC.bhop
        end,
        setState = function(bn)
            vT(bn)
            pcall(function()
                bm:Set(bn)
            end)
        end,
    })
end

bl:Section{
    Title = 'auto strafe',
}

do
    local bm = bl:Toggle{
        Title = 'silent auto strafe',
        Value = false,
        Flag = 'strafe',
        Callback = function(bm)
            aC.strafe = bm
        end,
    }

    ak.register('Auto Strafe', bm, {
        kind = 'toggle',
        title = 'Auto Strafe',
        isActive = function()
            return aC.strafe
        end,
        setState = function(bn)
            aC.strafe = bn

            pcall(function()
                bm:Set(bn)
            end)
        end,
    })
end

bl:Dropdown{
    Title = 'strafe mode',
    Values = {
        'Rage',
        'Legit',
    },
    Value = 'Rage',
    Flag = 'strafeMode',
    Callback = function(bm)
        aC.strafeMode = type(bm) == 'table' and bm[1] or bm
    end,
}
bl:Toggle{
    Title = 'fast turn',
    Value = true,
    Flag = 'strafeFastTurn',
    Callback = function(bm)
        aC.fastTurn = bm
    end,
}
bl:Slider{
    Title = 'align threshold',
    Value = {
        Min = 1,
        Max = 30,
        Default = 6,
    },
    Flag = 'strafeAlign',
    Callback = function(bm)
        aC.alignDeg = bm
    end,
}

local bm, bn, bo, bp, bq, br, bs, bt, bu, bv = game:GetService'Lighting', {
    Galaxy = {
        Bk = 'rbxassetid://159454299',
        Dn = 'rbxassetid://159454296',
        Ft = 'rbxassetid://159454293',
        Lf = 'rbxassetid://159454286',
        Rt = 'rbxassetid://159454300',
        Up = 'rbxassetid://159454288',
    },
    ['Pink Sky'] = {
        Lf = 'rbxassetid://271042310',
        Bk = 'rbxassetid://271042516',
        Dn = 'rbxassetid://271077243',
        Ft = 'rbxassetid://271042556',
        Rt = 'rbxassetid://271042467',
        Up = 'rbxassetid://271077958',
    },
    Sunset = {
        Bk = 'rbxassetid://458016711',
        Dn = 'rbxassetid://458016826',
        Ft = 'rbxassetid://458016532',
        Lf = 'rbxassetid://458016655',
        Rt = 'rbxassetid://458016782',
        Up = 'rbxassetid://458016792',
    },
    Night = {
        Bk = 'rbxassetid://48020371',
        Dn = 'rbxassetid://48020144',
        Ft = 'rbxassetid://48020234',
        Lf = 'rbxassetid://48020211',
        Rt = 'rbxassetid://48020254',
        Up = 'rbxassetid://48020383',
    },
    Custom = {},
    Evening = {
        Lf = 'rbxassetid://7950573918',
        Bk = 'rbxassetid://7950569153',
        Dn = 'rbxassetid://7950570785',
        Ft = 'rbxassetid://7950572449',
        Rt = 'rbxassetid://7950575055',
        Up = 'rbxassetid://7950627627',
    },
}, false, Color3.fromRGB(75, 58, 222), Color3.fromRGB(109, 58, 206), false, 12, 0, false, 'Galaxy'
local bw, bx, by, bz = bm.Ambient, bm.OutdoorAmbient, bm.ClockTime, Instance.new'ColorCorrectionEffect'

bz.Name = 'bloxstrikebloxSaturation'
bz.Enabled = false
bz.Parent = bm

aa.onUnload((function(bA)
    return function()
        if bo then
            bm.Ambient = bw
            bm.OutdoorAmbient = bx
        end
        if br then
            pcall(function()
                bm.ClockTime = by
            end)
        end

        pcall(function()
            bm.GlobalShadows = bA
        end)
        pcall(function()
            bz:Destroy()
        end)

        local bB = bm:FindFirstChild'bloxstrikebloxSky'

        if bB then
            bB:Destroy()
        end
    end
end)(bm.GlobalShadows))

local function BU()
    local bA = bm:FindFirstChild'bloxstrikebloxSky'

    if bu then
        local bB = bn[bv]

        if not (bB and bB.Bk) then
            return
        end

        local bC = bA or Instance.new'Sky'

        bC.Name = 'bloxstrikebloxSky'
        bC.SkyboxBk, bC.SkyboxDn, bC.SkyboxFt = bB.Bk, bB.Dn, bB.Ft
        bC.SkyboxLf, bC.SkyboxRt, bC.SkyboxUp = bB.Lf, bB.Rt, bB.Up
        bC.Parent = bm
    elseif bA then
        bA:Destroy()
    end
end

aa.connect(O.Heartbeat, function()
    if bo then
        bm.Ambient = bp
        bm.OutdoorAmbient = bq
    end
    if br then
        bm.ClockTime = bs
    end
end)

pcall(function()
    local shTab = ad:Tab{
        Title = 'movement (shitaro.lol)',
        Icon = 'move',
    }

    shTab:Section{
        Title = 'movement',
    }

    for _, shItem in ipairs{
        {'edge jump', 'edge_jump', 'shz_edgejump'},
        {'jump bug', 'jump_bug', 'shz_jumpbug'},
        {'edge bug', 'edge_bug', 'shz_edgebug'},
        {'slow walk', 'slow_walk', 'shz_slowwalk'},
        {'pixel surf', 'pixel_surf', 'shz_pixelsurf'},
    }do
        shTab:Toggle{
            Title = shItem[1],
            Value = false,
            Flag = shItem[3],
            Callback = function(v)
                local sh = aa.shitaro

                if sh then
                    sh.cfg[shItem[2]] = v
                end
            end,
        }
    end
end)


-- visuals (shitaro.lol) — safe UI, wired to existing aC
pcall(function()
    if not ad or type(ad.Tab) ~= 'function' then
        return
    end

    local shVis = ad:Tab{
        Title = 'visuals (shitaro.lol)',
        Icon = 'sparkles',
    }

    if not shVis then
        return
    end

    local function safeSet(key, val)
        if type(aC) == 'table' then
            aC[key] = val
        end
    end

    shVis:Section{
        Title = 'world',
    }

    shVis:Toggle{
        Title = 'damage numbers',
        Value = false,
        Flag = 'shvis_dmgNumbers',
        Callback = function(v)
            safeSet('dmgNumbers', v == true)
        end,
    }
    shVis:Toggle{
        Title = 'kill fx',
        Value = false,
        Flag = 'shvis_killFx',
        Callback = function(v)
            safeSet('killFx', v == true)
        end,
    }

    shVis:Section{
        Title = 'local',
    }

    shVis:Toggle{
        Title = 'crosshair',
        Value = false,
        Flag = 'shvis_xhair',
        Callback = function(v)
            safeSet('xhair', v == true)
        end,
    }
    shVis:Colorpicker{
        Title = 'crosshair color',
        Default = Color3.fromRGB(0, 255, 140),
        Flag = 'shvis_xhairCol',
        Callback = function(v)
            if typeof(v) == 'Color3' then
                safeSet('xhairColor', v)
            end
        end,
    }
    shVis:Slider{
        Title = 'crosshair length',
        Value = {
            Min = 1,
            Max = 30,
            Default = 6,
        },
        Flag = 'shvis_xhairLen',
        Callback = function(v)
            safeSet('xhairLen', tonumber(v) or 6)
        end,
    }
    shVis:Slider{
        Title = 'crosshair gap',
        Value = {
            Min = 0,
            Max = 20,
            Default = 4,
        },
        Flag = 'shvis_xhairGap',
        Callback = function(v)
            safeSet('xhairGap', tonumber(v) or 4)
        end,
    }
    shVis:Toggle{
        Title = 'dot',
        Value = false,
        Flag = 'shvis_dot',
        Callback = function(v)
            safeSet('dot', v == true)
        end,
    }
    shVis:Colorpicker{
        Title = 'dot color',
        Default = Color3.fromRGB(255, 255, 255),
        Flag = 'shvis_dotCol',
        Callback = function(v)
            if typeof(v) == 'Color3' then
                safeSet('dotColor', v)
            end
        end,
    }
    shVis:Slider{
        Title = 'dot size',
        Value = {
            Min = 1,
            Max = 12,
            Default = 4,
        },
        Flag = 'shvis_dotSize',
        Callback = function(v)
            safeSet('dotSize', tonumber(v) or 4)
        end,
    }
end)


local bA = ad:Tab{
    Title = 'world',
    Icon = 'globe',
}

bA:Section{
    Title = 'lighting',
}
bA:Toggle{
    Title = 'ambience',
    Value = false,
    Flag = 'wrl_ambient',
    Callback = function(bB)
        bo = bB

        if not bB then
            bm.Ambient = bw
            bm.OutdoorAmbient = bx
        end
    end,
}

local bB, bC = bA:Colorpicker{
    Title = 'ambient color',
    Default = bp,
    Flag = 'wrl_ambientColor',
    Callback = function(bB)
        bp = bB
    end,
}, bA:Colorpicker{
    Title = 'outdoor color',
    Default = bq,
    Flag = 'wrl_outdoorColor',
    Callback = function(bB)
        bq = bB
    end,
}

bA:Toggle{
    Title = 'shadow map',
    Value = bm.GlobalShadows,
    Flag = 'wrl_shadows',
    Callback = function(bD)
        pcall(function()
            bm.GlobalShadows = bD
        end)
    end,
}
bA:Toggle{
    Title = 'force time',
    Value = false,
    Flag = 'wrl_forcetime',
    Callback = function(bD)
        br = bD

        if not bD then
            pcall(function()
                bm.ClockTime = by
            end)
        end
    end,
}
bA:Slider{
    Title = 'time',
    Value = {
        Min = 0,
        Max = 24,
        Default = 12,
    },
    Step = 1,
    Flag = 'wrl_time',
    Callback = function(bD)
        bs = bD
    end,
}
bA:Section{
    Title = 'effects',
}
bA:Toggle{
    Title = 'saturation',
    Value = false,
    Flag = 'wrl_saturation',
    Callback = function(bD)
        bz.Enabled = bD
    end,
}
bA:Slider{
    Title = 'saturation value',
    Value = {
        Min = -1,
        Max = 5,
        Default = 0,
    },
    Step = 0.05,
    Flag = 'wrl_satvalue',
    Callback = function(bD)
        bt = bD
        bz.Saturation = bD
    end,
}

do
    local bD, bE, bF, bG = {
        fullbright = false,
        bright = false,
        brightness = 2,
        exposure = 0,
        fog = 'Default',
        fogColor = Color3.fromRGB(190, 200, 220),
        fogStart = 0,
        fogEnd = 400,
        noPost = false,
        night = false,
        nightStrength = 0.6,
        asus = false,
        asusValue = 0.5,
        tint = false,
        tintColor = Color3.fromRGB(110, 90, 255),
        tintStrength = 0.5,
        weather = 'Off',
        weatherAmount = 1,
    }, {
        Brightness = bm.Brightness,
        Exposure = bm.ExposureCompensation,
        FogColor = bm.FogColor,
        FogStart = bm.FogStart,
        FogEnd = bm.FogEnd,
    }, Color3.new(1, 1, 1), Instance.new'ColorCorrectionEffect'

    bG.Name = 'bloxstrikebloxGrade'
    bG.Enabled = false
    bG.Parent = bm

    local bH = Instance.new'ColorCorrectionEffect'

    bH.Name = 'bloxstrikebloxNight'
    bH.Enabled = false
    bH.Parent = bm

    local bI = Instance.new'BloomEffect'

    bI.Name = 'bloxstrikebloxBloom'
    bI.Enabled = false
    bI.Parent = bm

    local bJ = {}

    local function y(bK)
        bD.fog = bK

        if bK == 'Default' then
            for bL, bM in ipairs(bJ)do
                pcall(function()
                    bM.Parent = bm
                end)
            end

            bJ = {}
            bm.FogColor, bm.FogStart, bm.FogEnd = bE.FogColor, bE.FogStart, bE.FogEnd
        else
            for bL, bM in ipairs(bm:GetChildren())do
                if bM:IsA'Atmosphere' then
                    bJ[#bJ + 1] = bM
                    bM.Parent = nil
                end
            end
        end
    end

    local bK = {}

    local function q()
        for bL, bM in ipairs{bm, at}do
            for bN, bO in ipairs(bM:GetChildren())do
                if bO:IsA'PostEffect' and bO.Name:sub(1, 8) ~= 'bloxstrikeblox' then
                    if bK[bO] == nil then
                        bK[bO] = bO.Enabled
                    end
                    if bO.Enabled then
                        bO.Enabled = false
                    end
                end
            end
        end
    end
    local function v()
        for bL, bM in pairs(bK)do
            pcall(function()
                bL.Enabled = bM
            end)
        end

        bK = {}
    end

    local bL, bM, bN = {}, 0, false

    local function C()
        return bD.asus or bD.tint
    end
    local function Q()
        bM = bM + 1

        local bO = bM

        task.spawn(function()
            local bP = {[at] = true}

            for bQ, bR in ipairs{
                'Characters',
                'Debris',
            }do
                local bS = workspace:FindFirstChild(bR)

                if bS then
                    bP[bS] = true
                end
            end

            local bQ = 0

            local function z(bR)
                if not bR:IsA'BasePart' or bR:IsA'Terrain' then
                    return
                end

                local bS = bL[bR]

                if not bS then
                    if not C() then
                        return
                    end

                    bS = {
                        bR.Transparency,
                        bR.Color,
                    }
                    bL[bR] = bS
                end

                bR.Transparency = (bD.asus and bS[1] < 1) and math.max(bS[1], bD.asusValue) or bS[1]
                bR.Color = bD.tint and bS[2]:Lerp(bD.tintColor, bD.tintStrength) or bS[2]
            end

            for bR, bS in ipairs(workspace:GetChildren())do
                if not bP[bS] and not u:GetPlayerFromCharacter(bS) then
                    pcall(z, bS)

                    for bU, bV in ipairs(bS:GetDescendants())do
                        if bO ~= bM then
                            return
                        end

                        pcall(z, bV)

                        bQ = bQ + 1

                        if bQ % 2500 == 0 then
                            task.wait()
                        end
                    end
                end
            end

            if not C() then
                bL = {}
            end
        end)
    end
    local function b()
        if bN then
            return
        end

        bN = true

        task.delay(0.3, function()
            bN = false

            if not aa.unloaded then
                Q()
            end
        end)
    end

    local bO = Instance.new'Part'

    bO.Name = 'bloxstrikebloxWeather'
    bO.Anchored, bO.CanCollide, bO.CanQuery, bO.CanTouch, bO.CastShadow = true, false, false, false, false
    bO.Transparency = 1
    bO.Size = Vector3.new(140, 1, 140)
    bO.Parent = aS

    local bP = Instance.new'ParticleEmitter'

    bP.EmissionDirection = Enum.NormalId.Bottom
    bP.Enabled = false
    bP.Parent = bO

    local function w()
        local bQ, bR = bD.weather, bD.weatherAmount

        bP.Enabled = bQ ~= 'Off'

        if bQ == 'Snow' then
            bP.Rate = 350 * bR
            bP.Lifetime = NumberRange.new(7, 9)
            bP.Speed = NumberRange.new(8, 12)
            bP.SpreadAngle = Vector2.new(12, 12)
            bP.Acceleration = Vector3.new(1.5, 0, 0.5)
            bP.Size = NumberSequence.new(0.22)
            bP.Transparency = NumberSequence.new(0.15)
            bP.Color = ColorSequence.new(bF)
            bP.LightEmission = 0.6
            bP.RotSpeed = NumberRange.new(-60, 60)

            pcall(function()
                bP.Orientation = Enum.ParticleOrientation.FacingCamera
            end)
            pcall(function()
                bP.Squash = NumberSequence.new(0)
            end)
        elseif bQ == 'Rain' then
            bP.Rate = 1400 * bR
            bP.Lifetime = NumberRange.new(0.8, 1)
            bP.Speed = NumberRange.new(85, 95)
            bP.SpreadAngle = Vector2.new(2, 2)
            bP.Acceleration = Vector3.new(0, 0, 0)
            bP.Size = NumberSequence.new(0.14)
            bP.Transparency = NumberSequence.new(0.45)
            bP.Color = ColorSequence.new(Color3.fromRGB(170, 195, 255))
            bP.LightEmission = 0.3
            bP.RotSpeed = NumberRange.new(0)

            pcall(function()
                bP.Orientation = Enum.ParticleOrientation.VelocityParallel
            end)
            pcall(function()
                bP.Squash = NumberSequence.new(6)
            end)
        end
    end

    local bQ, bR = 0, workspace:GetAttribute'Map'

    aa.connect(O.RenderStepped, function()
        if bD.fullbright then
            bm.Ambient, bm.OutdoorAmbient = bF, bF
            bm.Brightness = 2
        elseif bD.bright then
            bm.Brightness = bD.brightness
        end
        if bD.bright then
            bm.ExposureCompensation = bD.exposure
        end
        if bD.fog == 'None' then
            bm.FogStart, bm.FogEnd = 1000000, 1000000
        elseif bD.fog == 'Custom' then
            bm.FogColor, bm.FogStart, bm.FogEnd = bD.fogColor, bD.fogStart, math.max(bD.fogEnd, bD.fogStart + 1)
        end
        if bD.weather ~= 'Off' then
            bO.CFrame = CFrame.new(at.CFrame.Position + Vector3.new(0, bD.weather == 'Rain' and 45 or 35, 0))
        end

        local bS = os.clock()

        if bS - bQ > 0.5 then
            bQ = bS

            if bD.noPost then
                q()
            end
            if bD.fog ~= 'Default' and bm:FindFirstChildOfClass'Atmosphere' then
                y(bD.fog)
            end

            local bU = workspace:GetAttribute'Map'

            if bU ~= bR then
                bR = bU
                bL = {}

                if C() then
                    task.delay(3, function()
                        if not aa.unloaded then
                            Q()
                        end
                    end)
                end
            end
        end
    end)

    local function o()
        if not bD.fullbright and not bD.bright then
            bm.Brightness = bE.Brightness
        end
        if not bD.fullbright and not bo then
            bm.Ambient, bm.OutdoorAmbient = bw, bx
        end
        if not bD.bright then
            bm.ExposureCompensation = bE.Exposure
        end
    end

    aa.onUnload(function()
        bD.fullbright, bD.bright, bD.noPost, bD.asus, bD.tint = false, false, false, false, false

        pcall(o)
        pcall(y, 'Default')
        pcall(v)

        bM = bM + 1

        for bS, bU in pairs(bL)do
            pcall(function()
                bS.Transparency, bS.Color = bU[1], bU[2]
            end)
        end

        bG:Destroy()
        bH:Destroy()
        bI:Destroy()
    end)

    local function n()
        local bS = bD.nightStrength

        bH.Enabled = bD.night
        bH.Brightness = -0.28 * bS
        bH.Contrast = 0.2 * bS
        bH.Saturation = -0.15 * bS
        bH.TintColor = bF:Lerp(Color3.fromRGB(140, 155, 255), bS)
    end

    bA:Section{
        Title = 'brightness',
    }
    bA:Toggle{
        Title = 'fullbright',
        Value = false,
        Flag = 'wrl_fullbright',
        Callback = function(bS)
            bD.fullbright = bS

            if not bS then
                o()
            end
        end,
    }
    bA:Toggle{
        Title = 'custom brightness',
        Value = false,
        Flag = 'wrl_bright',
        Callback = function(bS)
            bD.bright = bS

            if not bS then
                o()
            end
        end,
    }
    bA:Slider{
        Title = 'sun brightness',
        Value = {
            Min = 0,
            Max = 10,
            Default = 2,
        },
        Step = 0.1,
        Flag = 'wrl_brightness',
        Callback = function(bS)
            bD.brightness = bS
        end,
    }
    bA:Slider{
        Title = 'exposure',
        Value = {
            Min = -3,
            Max = 3,
            Default = 0,
        },
        Step = 0.05,
        Flag = 'wrl_exposure',
        Callback = function(bS)
            bD.exposure = bS
        end,
    }
    bA:Toggle{
        Title = 'night mode',
        Value = false,
        Flag = 'wrl_night',
        Callback = function(bS)
            bD.night = bS

            n()
        end,
    }
    bA:Slider{
        Title = 'night strength',
        Value = {
            Min = 0.1,
            Max = 1,
            Default = 0.6,
        },
        Step = 0.05,
        Flag = 'wrl_nightStrength',
        Callback = function(bS)
            bD.nightStrength = bS

            n()
        end,
    }
    bA:Section{
        Title = 'post processing',
    }
    bA:Toggle{
        Title = 'remove game effects',
        Value = false,
        Flag = 'wrl_noPost',
        Callback = function(bS)
            bD.noPost = bS

            if bS then
                q()
            else
                v()
            end
        end,
    }
    bA:Toggle{
        Title = 'color grading',
        Value = false,
        Flag = 'wrl_grade',
        Callback = function(bS)
            bG.Enabled = bS
        end,
    }
    bA:Slider{
        Title = 'contrast',
        Value = {
            Min = -1,
            Max = 2,
            Default = 0,
        },
        Step = 0.05,
        Flag = 'wrl_contrast',
        Callback = function(bS)
            bG.Contrast = bS
        end,
    }
    bA:Slider{
        Title = 'grade brightness',
        Value = {
            Min = -1,
            Max = 1,
            Default = 0,
        },
        Step = 0.05,
        Flag = 'wrl_gradeBright',
        Callback = function(bS)
            bG.Brightness = bS
        end,
    }
    bA:Colorpicker{
        Title = 'screen tint',
        Default = bF,
        Flag = 'wrl_gradeTint',
        Callback = function(bS)
            bG.TintColor = bS
        end,
    }
    bA:Toggle{
        Title = 'bloom',
        Value = false,
        Flag = 'wrl_bloom',
        Callback = function(bS)
            bI.Enabled = bS
        end,
    }
    bA:Slider{
        Title = 'bloom intensity',
        Value = {
            Min = 0,
            Max = 5,
            Default = 1,
        },
        Step = 0.05,
        Flag = 'wrl_bloomIntensity',
        Callback = function(bS)
            bI.Intensity = bS
        end,
    }
    bA:Slider{
        Title = 'bloom size',
        Value = {
            Min = 0,
            Max = 56,
            Default = 24,
        },
        Flag = 'wrl_bloomSize',
        Callback = function(bS)
            bI.Size = bS
        end,
    }
    bA:Slider{
        Title = 'bloom threshold',
        Value = {
            Min = 0,
            Max = 4,
            Default = 2,
        },
        Step = 0.05,
        Flag = 'wrl_bloomThreshold',
        Callback = function(bS)
            bI.Threshold = bS
        end,
    }
    bA:Section{
        Title = 'map',
    }
    bA:Toggle{
        Title = 'see-through walls',
        Value = false,
        Flag = 'wrl_asus',
        Callback = function(bS)
            bD.asus = bS

            Q()
        end,
    }
    bA:Slider{
        Title = 'wall transparency',
        Value = {
            Min = 10,
            Max = 95,
            Default = 50,
        },
        Step = 5,
        Flag = 'wrl_asusValue',
        Callback = function(bS)
            bD.asusValue = bS / 100

            if bD.asus then
                b()
            end
        end,
    }
    bA:Toggle{
        Title = 'map tint',
        Value = false,
        Flag = 'wrl_tint',
        Callback = function(bS)
            bD.tint = bS

            Q()
        end,
    }
    bA:Colorpicker{
        Title = 'tint color',
        Default = bD.tintColor,
        Flag = 'wrl_tintColor',
        Callback = function(bS)
            bD.tintColor = bS

            if bD.tint then
                b()
            end
        end,
    }
    bA:Slider{
        Title = 'tint strength',
        Value = {
            Min = 5,
            Max = 100,
            Default = 50,
        },
        Step = 5,
        Flag = 'wrl_tintStrength',
        Callback = function(bS)
            bD.tintStrength = bS / 100

            if bD.tint then
                b()
            end
        end,
    }
    bA:Section{
        Title = 'weather',
    }
    bA:Dropdown{
        Title = 'weather',
        Values = {
            'Off',
            'Snow',
            'Rain',
        },
        Value = 'Off',
        Flag = 'wrl_weather',
        Callback = function(bS)
            bD.weather = type(bS) == 'table' and bS[1] or bS

            w()
        end,
    }
    bA:Slider{
        Title = 'weather amount',
        Value = {
            Min = 0.2,
            Max = 3,
            Default = 1,
        },
        Step = 0.1,
        Flag = 'wrl_weatherAmount',
        Callback = function(bS)
            bD.weatherAmount = bS

            w()
        end,
    }
end
do
    local bD, bE, bF = {
        drops = false,
        dropColor = Color3.fromRGB(235, 235, 240),
        dropDist = 150,
        bomb = false,
        shotChams = false,
        shotColor = Color3.fromRGB(120, 190, 255),
        shotLife = 2,
        sun = false,
        sunLatitude = 40,
        lightColor = Color3.fromRGB(255, 170, 110),
        noCelestial = false,
        noStars = false,
        noClouds = false,
    }, Color3.fromRGB(255, 86, 110), Instance.new'Folder'

    bF.Name = 'WorldItems'
    bF.Parent = aS

    local bG, bH, bI = {}, nil, nil

    local function l(bJ)
        local bK = bJ:IsA'Model' and bJ.PrimaryPart or bJ:IsA'BasePart' and bJ or bJ:FindFirstChildWhichIsA('BasePart', true)

        if not bK then
            return nil
        end

        local bL = Instance.new'BillboardGui'

        bL.Size = UDim2.fromOffset(160, 30)
        bL.AlwaysOnTop = true
        bL.StudsOffset = Vector3.new(0, 1, 0)
        bL.Adornee = bK
        bL.Parent = bF

        local bM = Instance.new'TextLabel'

        bM.Size = UDim2.fromScale(1, 1)
        bM.BackgroundTransparency = 1
        bM.Font = Enum.Font.GothamBold
        bM.TextSize = 12
        bM.TextStrokeTransparency = 0.4
        bM.Parent = bL

        local bN = {
            gui = bL,
            label = bM,
            part = bK,
        }

        bG[bJ] = bN

        return bN
    end
    local function r(bJ)
        local bK = bG[bJ]

        if bK then
            bK.gui:Destroy()

            bG[bJ] = nil
        end
    end

    local bJ = Instance.new'Frame'

    bJ.AnchorPoint = Vector2.new(0.5, 0)
    bJ.Position = UDim2.new(0.5, 0, 0, 150)
    bJ.Size = UDim2.fromOffset(240, 26)
    bJ.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
    bJ.BackgroundTransparency = 0.1
    bJ.BorderSizePixel = 0
    bJ.Visible = false
    bJ.Parent = aL;
    (Instance.new('UICorner', bJ)).CornerRadius = UDim.new(0, 4)

    local bK = Instance.new'Frame'

    bK.Position = UDim2.new(0, 0, 1, -2)
    bK.Size = UDim2.new(1, 0, 0, 2)
    bK.BorderSizePixel = 0
    bK.Parent = bJ

    local bL = Instance.new'TextLabel'

    bL.Size = UDim2.new(1, 0, 1, -2)
    bL.BackgroundTransparency = 1
    bL.Font = Enum.Font.GothamBold
    bL.TextSize = 13
    bL.TextColor3 = Color3.fromRGB(235, 235, 240)
    bL.Parent = bJ

    local bM = 0

    aa.connect(O.RenderStepped, function()
        local bN = os.clock()

        if not (bD.drops or bD.bomb) then
            if next(bG) then
                for bO in pairs(bG)do
                    r(bO)
                end
            end

            bJ.Visible = false
            bH = nil

            return
        end
        if bN - bM > 0.25 then
            bM = bN

            local bO, bP = workspace:FindFirstChild'Debris', {}

            bH = nil

            if bO then
                for bQ, bR in ipairs(bO:GetChildren())do
                    if bR:IsA'Model' then
                        local bS = bR:GetAttribute'BombPlanted'

                        if type(bS) == 'string' then
                            if bD.bomb then
                                bH = bR

                                local bU, bV = pcall(ar.JSONDecode, ar, bS)

                                bI = bU and (type(bV) == 'table' and bV) or {}
                                bP[bR] = true
                            end
                        elseif bD.drops and type(bR:GetAttribute'Weapon') == 'string' then
                            bP[bR] = true
                        end
                    end
                end
            end
            if bD.bomb and not bH then
                for bQ, bR in ipairs((game:GetService'CollectionService'):GetTagged'Bomb')do
                    local bS = bR:GetAttribute'BombPlanted'

                    if type(bS) == 'string' and bR:IsDescendantOf(workspace) then
                        bH = bR

                        local bU, bV = pcall(ar.JSONDecode, ar, bS)

                        bI = bU and (type(bV) == 'table' and bV) or {}
                        bP[bR] = true

                        break
                    end
                end
            end

            for bQ in pairs(bG)do
                if not bP[bQ] or not bQ.Parent then
                    r(bQ)
                end
            end
            for bQ in pairs(bP)do
                if not bG[bQ] then
                    l(bQ)
                end
            end
        end

        local bO = (U()).Position

        for bP, bQ in pairs(bG)do
            if bP ~= bH and bQ.part.Parent then
                local bR, bS = (bQ.part.Position - bO).Magnitude, bP:GetAttribute'Weapon'
                local bU = bS == 'C4'

                bQ.gui.Enabled = bU or bR <= bD.dropDist
                bQ.label.TextColor3 = bU and bE or bD.dropColor
                bQ.label.Text = tostring(bS) .. ('  ' .. (math.floor(bR * 0.28) .. 'm'))
            end
        end

        local bP = false

        if bH and (bH.Parent and bG[bH]) then
            local bQ, bR, bS = bG[bH], math.max(tonumber(bI.TimeUntilExplode) or 40, 0.1), tonumber(bI.Time) or workspace:GetServerTimeNow()
            local bU, bV, bW = math.max((bS + bR) - workspace:GetServerTimeNow(), 0), bH:GetAttribute'Defused' == true, bH:GetAttribute'Exploded' == true or bH:GetAttribute'Exploding' == true
            local bX = bV and 'DEFUSED' or bW and 'EXPLODED' or ('%.1fs'):format(bU)

            bQ.gui.Enabled = true
            bQ.label.TextColor3 = bE
            bQ.label.Text = 'C4  ' .. (bX .. ('  ' .. (math.floor((bQ.part.Position - bO).Magnitude * 0.28) .. 'm')))
            bP = true

            local bY, bZ = bV and 1 or math.clamp(bU / bR, 0, 1), type(bI.Site) == 'string' and ' ' .. bI.Site or ''

            bL.Text = 'BOMB' .. (bZ .. ('  ' .. bX))
            bK.Size = UDim2.new(bY, 0, 0, 2)
            bK.BackgroundColor3 = bV and Color3.fromRGB(110, 230, 140) or (Color3.fromRGB(255, 70, 90)):Lerp(Color3.fromRGB(110, 230, 140), bY)
        end

        bJ.Visible = bP
    end)

    local bN, bO = {
        'Head',
        'UpperTorso',
        'LowerTorso',
        'LeftUpperArm',
        'LeftLowerArm',
        'LeftHand',
        'RightUpperArm',
        'RightLowerArm',
        'RightHand',
        'LeftUpperLeg',
        'LeftLowerLeg',
        'LeftFoot',
        'RightUpperLeg',
        'RightLowerLeg',
        'RightFoot',
    }, a_.onConfirm

    function a_.onConfirm(bP, bQ, bR, bS, bU)
        if bO then
            pcall(bO, bP, bQ, bR, bS, bU)
        end
        if not bD.shotChams or not bS then
            return
        end

        local bV = Instance.new'Model'

        bV.Name = 'ShotCham'

        local bW = 0

        for bX, bY in ipairs(bN)do
            local bZ = bS:FindFirstChild(bY)

            if bZ and bZ:IsA'BasePart' then
                local b_ = Instance.new'Part'

                b_.Anchored, b_.CanCollide, b_.CanQuery, b_.CanTouch, b_.CastShadow = true, false, false, false, false
                b_.Material = Enum.Material.Neon
                b_.Color = bD.shotColor
                b_.Transparency = 0.75
                b_.Size = bZ.Size
                b_.CFrame = bZ.CFrame
                b_.Parent = bV
                bW = bW + 1
            end
        end

        if bW == 0 then
            bV:Destroy()

            return
        end

        local bX = Instance.new'Highlight'

        bX.FillColor, bX.OutlineColor = bD.shotColor, bD.shotColor
        bX.FillTransparency = 0.6
        bX.OutlineTransparency = 0
        bX.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        bX.Parent = bV
        bV.Parent = bF

        local bY = TweenInfo.new(bD.shotLife, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

        (ap:Create(bX, bY, {
            FillTransparency = 1,
            OutlineTransparency = 1,
        })):Play()

        for bZ, b_ in ipairs(bV:GetChildren())do
            if b_:IsA'BasePart' then
                (ap:Create(b_, bY, {Transparency = 1})):Play()
            end
        end

        as:AddItem(bV, bD.shotLife + 0.1)
    end

    local bP = game:GetService'Lighting'
    local bQ, bR, bS, bU = {
        latitude = bP.GeographicLatitude,
        top = bP.ColorShift_Top,
    }, {}, nil, {}

    local function w()
        for bV, bW in ipairs(bP:GetChildren())do
            if bW:IsA'Sky' then
                if not bR[bW] then
                    bR[bW] = {
                        bW.CelestialBodiesShown,
                        bW.StarCount,
                        bW.SunAngularSize,
                        bW.MoonAngularSize,
                    }
                end

                local bX = bR[bW]

                bW.CelestialBodiesShown = not bD.noCelestial and bX[1]
                bW.SunAngularSize = bD.noCelestial and 0 or bX[3]
                bW.MoonAngularSize = bD.noCelestial and 0 or bX[4]
                bW.StarCount = bD.noStars and 0 or bX[2]
            elseif bW:IsA'SunRaysEffect' then
                if bU[bW] == nil then
                    bU[bW] = bW.Enabled
                end

                bW.Enabled = not bD.noCelestial and bU[bW]
            end
        end
        for bV, bW in ipairs(at:GetChildren())do
            if bW:IsA'SunRaysEffect' then
                if bU[bW] == nil then
                    bU[bW] = bW.Enabled
                end

                bW.Enabled = not bD.noCelestial and bU[bW]
            end
        end

        local bV = workspace.Terrain:FindFirstChildOfClass'Clouds'

        if bV then
            if bS == nil then
                bS = bV.Enabled
            end

            bV.Enabled = not bD.noClouds and bS
        end
    end

    local bV = 0

    aa.connect(O.Heartbeat, function()
        if bD.sun then
            bP.GeographicLatitude = bD.sunLatitude
            bP.ColorShift_Top = bD.lightColor
        end
        if (bD.noCelestial or bD.noStars or bD.noClouds) and os.clock() - bV > 0.5 then
            bV = os.clock()

            pcall(w)
        end
    end)
    aa.connect(bP.ChildAdded, function(bW)
        if (bD.noCelestial or bD.noStars) and (bW:IsA'Sky' or bW:IsA'SunRaysEffect') then
            task.defer(function()
                pcall(w)
            end)
        end
    end)

    local function n()
        bP.GeographicLatitude = bQ.latitude
        bP.ColorShift_Top = bQ.top
    end

    aa.onUnload(function()
        pcall(n)

        bD.noCelestial, bD.noStars, bD.noClouds = false, false, false

        pcall(w)
        pcall(function()
            bJ:Destroy()
        end)
        pcall(function()
            bF:Destroy()
        end)

        a_.onConfirm = bO
    end)
    bA:Section{
        Title = 'items',
    }
    bA:Toggle{
        Title = 'dropped weapons',
        Value = false,
        Flag = 'wrl_drops',
        Callback = function(bW)
            bD.drops = bW
        end,
    }
    bA:Colorpicker{
        Title = 'dropped weapon color',
        Default = bD.dropColor,
        Flag = 'wrl_dropColor',
        Callback = function(bW)
            bD.dropColor = bW
        end,
    }
    bA:Slider{
        Title = 'dropped weapon distance',
        Value = {
            Min = 20,
            Max = 600,
            Default = 150,
        },
        Step = 10,
        Flag = 'wrl_dropDist',
        Callback = function(bW)
            bD.dropDist = bW
        end,
    }
    bA:Toggle{
        Title = 'bomb timer',
        Value = false,
        Flag = 'wrl_bomb',
        Callback = function(bW)
            bD.bomb = bW
        end,
    }
end

local bD, bE, bF = {}, 'bloxstrike/bloxstrike/skins.json', {}

local function UU()
    pcall(function()
        if isfolder and (makefolder and not isfolder'bloxstrike/bloxstrike') then
            if not isfolder'bloxstrike' then
                makefolder'bloxstrike'
            end

            makefolder'bloxstrike/bloxstrike'
        end

        writefile(bE, ar:JSONEncode{
            skins = bD,
            knife = aC.knife,
            knifeSkin = aC.knifeSkin,
        })
    end)
end

pcall(function()
    if isfile and isfile(bE) then
        local bG = ar:JSONDecode(readfile(bE))

        if type(bG) == 'table' then
            bD = type(bG.skins) == 'table' and bG.skins or {}
            aC.knife, aC.knifeSkin = bG.knife, bG.knifeSkin
        end
    end
end)

local bG, bH = {
    'Rifle',
    'Pistol',
    'SMG',
    'Heavy',
    'Knife',
}, {
    Rifle = {},
    Pistol = {},
    SMG = {},
    Heavy = {},
    Knife = {},
}

do
    local bI = {}

    for bJ, bK in ipairs(aB:GetChildren())do
        if not bI[bK.Name] then
            bI[bK.Name] = true

            local bL, bM = pcall(require, bK)

            if bL and type(bM) == 'table' then
                local bN

                if bM.Class == 'Melee' then
                    bN = 'Knife'
                    bF[bK.Name] = true
                elseif bM.Class == 'Weapon' and bH[bM.Type] ~= nil then
                    bN = bM.Type
                end
                if bN then
                    local bO, bP = pcall(az.GetAllSkinsForWeapon, bK.Name)

                    if bO and type(bP) == 'table' then
                        for bQ, bR in pairs(bP)do
                            if type(bR) == 'table' and (bR.skin and (bR.skin ~= 'Stock' and bR.isEnabled ~= false)) then
                                local bS = bR.wearImages and (bR.wearImages[1] and bR.wearImages[1].assetId)

                                table.insert(bH[bN], {
                                    weapon = bK.Name,
                                    skin = bR.skin,
                                    rarity = bR.rarity,
                                    image = bS or '',
                                })
                            end
                        end
                    end
                end
            end
        end
    end
    for bJ, bK in pairs(bH)do
        table.sort(bK, function(bL, bM)
            if bL.weapon ~= bM.weapon then
                return bL.weapon < bM.weapon
            end

            return bL.skin < bM.skin
        end)
    end
end
do
    local bI

    bI = Q(aA.new, function(bJ, bK, bL, bM)
        if aa.unloaded or not aC.skins then
            return bI(bJ, bK, bL, bM)
        end
        if aC.knife and (aC.knifeSkin and bF[bK]) then
            if bK ~= aC.knife then
                bJ.ViewmodelCameraWeapon = nil
            end

            return bI(bJ, aC.knife, aC.knifeSkin, bM)
        end

        return bI(bJ, bK, bD[bK] or bL, bM)
    end)

    pcall(function()
        local bJ = require(L.Database.Components.Common.AttachGlovesToViewmodel)

        if type(bJ) ~= 'function' or type(az.GetGloves) ~= 'function' then
            return
        end

        local bK

        bK = Q(bJ, function(bL, bM, ...)
            if not aa.unloaded and (aC.skins and (aC.glove and aC.gloveSkin)) then
                local bN, bO = pcall(az.GetGloves, aC.glove, aC.gloveSkin, aC.float)

                if bN and typeof(bO) == 'Instance' then
                    local bP = bO:GetChildren()

                    if #bP > 0 then
                        return bK(bP, bM, ...)
                    end
                end
            end

            return bK(bL, bM, ...)
        end)
    end)

    local bJ

    bJ = Q(az.GetCameraModel, function(bK, bL, bM, bN, ...)
        if aa.unloaded or not aC.skins then
            return bJ(bK, bL, bM, bN, ...)
        end

        local bO = aC.statTrak and aC.statTrakCount or nil
        local bP, bQ = pcall(bJ, bK, bL, aC.float, bO, ...)

        if bP and bQ then
            return bQ
        end

        return bJ(bK, bL, bM, bN, ...)
    end)

    pcall(function()
        local bK

        bK = Q(aA.claim, function(...)
            if not aa.unloaded and aC.skins then
                return nil
            end

            return bK(...)
        end)
    end)
end

local bI

do
    local bJ = false

    local function E()
        bJ = false

        if aa.unloaded then
            return
        end

        local bK = _.Character

        if not bK then
            return
        end

        local bL, bM = pcall(filtergc, 'table', {
            Keys = {
                'Viewmodel',
                'Skin',
                'Slot',
            },
        }, false)

        if not bL or type(bM) ~= 'table' then
            return
        end
        if setthreadidentity then
            pcall(setthreadidentity, 2)
        end

        for bN, bO in ipairs(bM)do
            local bP = rawget(bO, 'Viewmodel')

            if bO.Player == _ and (not bO.Character and (not bO.IsDestroyed and (type(bP) == 'table' and (not bP.IsDestroyed and type(bP.construct) == 'function')))) then
                local bQ, bR = bO.Name, bO.Skin

                if aC.skins then
                    if aC.knife and (aC.knifeSkin and bF[bO.Name]) then
                        bQ, bR = aC.knife, aC.knifeSkin
                    else
                        bR = bD[bO.Name] or bO.Skin
                    end
                end

                bP.Weapon, bP.CameraModelWeapon, bP.Skin = bQ, bQ, bR

                pcall(bP.construct, bP, bK, bO)

                if bP.IsEquipped then
                    pcall(bP.equip, bP, true)
                end
            end
        end

        if setthreadidentity then
            pcall(setthreadidentity, 8)
        end
    end

    bI = function()
        if bJ then
            return
        end

        bJ = true

        task.defer(E)
    end
end

-- Skin Changer UI removed as requested.

