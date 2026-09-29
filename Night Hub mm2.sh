local success, errorMessage = pcall(function()
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local Workspace = game:GetService("Workspace")
    local setclipboard = setclipboard or (syn and syn.write_clipboard) or function(data) print("Clipboard não suportado: " .. data) end

    -- TELA DE LOADING MODERNA COM TEMA RED, IMAGEM DE FUNDO E 8 SEGUNDOS
    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "NightHubLoading"
    loadingGui.IgnoreGuiInset = true
    loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local successParent, _ = pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(loadingGui)
            loadingGui.Parent = CoreGui
        elseif CoreGui:FindFirstChild("RobloxGui") then
            loadingGui.Parent = CoreGui.RobloxGui
        else
            loadingGui.Parent = CoreGui
        end
    end)
    if not successParent then
        loadingGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Imagem de fundo cobrindo a tela toda
    local bgImage = Instance.new("ImageLabel", loadingGui)
    bgImage.Name = "Background"
    bgImage.Size = UDim2.fromScale(1, 1)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "rbxassetid://84152360484913"
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ImageTransparency = 1

    -- Overlay escuro para destacar o carregamento
    local darkOverlay = Instance.new("Frame", loadingGui)
    darkOverlay.Size = UDim2.fromScale(1, 1)
    darkOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    darkOverlay.BackgroundTransparency = 1

    local container = Instance.new("Frame", loadingGui)
    container.Size = UDim2.fromOffset(420, 180)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Position = UDim2.fromScale(0.5, 0.5)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    container.BackgroundTransparency = 1

    local uiCorner = Instance.new("UICorner", container)
    uiCorner.CornerRadius = UDim.new(0, 14)

    local uiStroke = Instance.new("UIStroke", container)
    uiStroke.Color = Color3.fromRGB(255, 0, 0)
    uiStroke.Transparency = 1
    uiStroke.Thickness = 2

    local titleLabel = Instance.new("TextLabel", container)
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.fromOffset(0, 25)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "NIGHT HUB - MM2"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextTransparency = 1
    titleLabel.TextSize = 22

    local percentLabel = Instance.new("TextLabel", container)
    percentLabel.Size = UDim2.new(1, 0, 0, 30)
    percentLabel.Position = UDim2.fromOffset(0, 70)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.Text = "0%"
    percentLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    percentLabel.TextTransparency = 1
    percentLabel.TextSize = 16

    -- Barra de loading moderna
    local barBg = Instance.new("Frame", container)
    barBg.Size = UDim2.new(0, 360, 0, 10)
    barBg.Position = UDim2.new(0.5, -180, 0, 125)
    barBg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    barBg.BackgroundTransparency = 1

    local barCorner = Instance.new("UICorner", barBg)
    barCorner.CornerRadius = UDim.new(1, 0)

    local barStroke = Instance.new("UIStroke", barBg)
    barStroke.Color = Color3.fromRGB(60, 20, 20)
    barStroke.Transparency = 1

    local barFill = Instance.new("Frame", barBg)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    barFill.BackgroundTransparency = 1

    local fillCorner = Instance.new("UICorner", barFill)
    fillCorner.CornerRadius = UDim.new(1, 0)

    -- Animação de Aparição do Loading (8 segundos de duração)
    TweenService:Create(bgImage, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0.2}):Play()
    TweenService:Create(darkOverlay, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.45}):Play()
    TweenService:Create(container, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15}):Play()
    TweenService:Create(uiStroke, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0.2}):Play()
    TweenService:Create(titleLabel, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(percentLabel, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(barBg, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(barStroke, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0.5}):Play()
    TweenService:Create(barFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()

    local startTime = tick()
    local duration = 8
    while tick() - startTime < duration do
        local elapsed = tick() - startTime
        local progress = math.clamp(elapsed / duration, 0, 1)
        local percentage = math.floor(progress * 100)
        percentLabel.Text = percentage .. "%"
        barFill.Size = UDim2.new(progress, 0, 1, 0)
        task.wait()
    end
    percentLabel.Text = "100%"
    barFill.Size = UDim2.new(1, 0, 1, 0)
    task.wait(0.4)

    -- Animação de Desaparecimento do Loading
    TweenService:Create(bgImage, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
    TweenService:Create(darkOverlay, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(uiStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1}):Play()
    TweenService:Create(titleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    TweenService:Create(percentLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    TweenService:Create(barBg, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(barStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1}):Play()
    TweenService:Create(barFill, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    task.wait(0.5)
    loadingGui:Destroy()

    -- CONFIGURAÇÃO DO TEMA RED
    WindUI:AddTheme({
        Name = "Red",
        Accent = Color3.fromHex("#ff0000"),
        Background = Color3.fromHex("#101010"),
        Outline = Color3.fromHex("#ff3333"),
        Text = Color3.fromHex("#FFFFFF"),
        Placeholder = Color3.fromHex("#7a7a7a"),
        Button = Color3.fromHex("#8b0000"),
        Icon = Color3.fromHex("#ff4d4d"),
    })

    local Window = Window or WindUI:CreateWindow({
        Title   = "Night Hub - MM2",
        Author  = "by Nick",
        Folder  = "nighthub",
        Icon    = "paint-bucket",
        Theme   = "Red",
        Acrylic = false,
        Transparent = true,
        Background = "",
        Size    = UDim2.fromOffset(680, 460),
        MinSize = Vector2.new(560, 350),
        MaxSize = Vector2.new(850, 560),
        ToggleKey  = Enum.KeyCode.RightShift,
        Resizable  = true,
        AutoScale  = true,
        NewElements = true,
        BackgroundImageTransparency = 0.25,
        HideSearchBar = false,
        ScrollBarEnabled = true,
        SideBarWidth = 200,
        Topbar = {
            Height      = 44,
            ButtonsType = "Default",
        },
        OpenButton = {
            Title = "Night Hub",
            Icon = "zap",
            CornerRadius = UDim.new(1, 0),
            StrokeThickness = 3,
            Enabled = true,
            Draggable = true,
            OnlyMobile = false,
            Scale = 1.2,
            Color = ColorSequence.new(
                Color3.fromHex("#ff0000"),
                Color3.fromHex("#8b0000")
            ),
        },
        User = {
            Enabled  = true,
            Anonymous = false,
            Callback = function()
                print("user panel clicked")
            end,
        },
    })

    -- TORNA A JANELA TOTALMENTE ARRASTÁVEL PELO TOPO (SUPORTE NATIVO PARA O WINDUI)
    task.spawn(function()
        task.wait(0.5)
        local guiMain = CoreGui:FindFirstChild("nighthub") or LocalPlayer.PlayerGui:FindFirstChild("nighthub")
        if not guiMain then
            for _, child in ipairs(CoreGui:GetChildren()) do
                if child:IsA("ScreenGui") and child:FindFirstChild("Frame", true) then
                    local possibleWindow = child:FindFirstChild("Frame", true)
                    if possibleWindow.Size.X.Offset >= 500 then
                        guiMain = child
                        break
                    end
                end
            end
        end

        if guiMain then
            local dragging, dragInput, dragStart, startPos
            local topbar = guiMain:FindFirstChild("Topbar", true) or guiMain:FindFirstChild("Header", true) or guiMain:FindFirstChild("Title", true)
            
            if not topbar then
                for _, desc in ipairs(guiMain:GetDescendants()) do
                    if desc:IsA("TextLabel") and desc.Text == "Night Hub - MM2" then
                        topbar = desc.Parent
                        break
                    end
                end
            end

            if topbar then
                topbar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        dragStart = input.Position
                        startPos = guiMain.AbsolutePosition -- ou a posição do container principal
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragging = false
                            end
                        end)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local delta = input.Position - dragStart
                        -- Ajusta a posição da janela principal do WindUI se houver referência direta
                    end
                end)
            end
        end
    end)

    local OWNERS = {
        ["Nao_souNICK"] = true,
        ["darkADM_ofc"] = true,
        ["shadowXvoidXHatred"] = true
    }

    local MODS = {
        ["ddddmv8"] = true,
        ["arthur2016e7"] = true,
        ["LostSoul4044"] = true,
        ["Kayojjp_O"] = true,
        ["kayojjp_0"] = true,
        ["WOLLTHAYOFC"] = true,
        ["hola_jbs"] = true
    }

    local function ApplyTagToCharacter(char, playerName)
        if not char then return end
        task.spawn(function()
            local head = char:WaitForChild("Head", 5)
            if not head then return end
            if head:FindFirstChild("NightHubTagGui") then return end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "NightHubTagGui"
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 2.8, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = head

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.fromScale(1, 1)
            textLabel.BackgroundTransparency = 1
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 18
            textLabel.TextStrokeTransparency = 0.2
            textLabel.Parent = billboard

            if OWNERS[playerName] then
                textLabel.Text = "DONO"
            elseif MODS[playerName] then
                textLabel.Text = "MOD"
            else
                textLabel.Text = "NIGHT USER"
            end

            task.spawn(function()
                local t = 0
                while billboard and billboard.Parent do
                    t = t + 0.05
                    local r = math.sin(t) * 50 + 205
                    local g = math.sin(t * 1.5) * 50 + 205
                    local b = 255
                    textLabel.TextColor3 = Color3.fromRGB(r, g, b)
                    task.wait(0.03)
                end
            end)
        end)
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if OWNERS[p.Name] or MODS[p.Name] then
            if p.Character then ApplyTagToCharacter(p.Character, p.Name) end
            p.CharacterAdded:Connect(function(c) ApplyTagToCharacter(c, p.Name) end)
        end
    end
    Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function(c)
            if OWNERS[p.Name] or MODS[p.Name] then ApplyTagToCharacter(c, p.Name) end
        end)
    end)

    local noclipEnabled = false
    local infJumpEnabled = false
    local espEnabled = false
    local espTracerEnabled = false
    local showUsernameEnabled = false
    local viewEnabled = false
    local autoFarmActive = false
    local autoPickupGunActive = false
    local aimbotActive = false
    local autoShootActive = false
    local killAuraActive = false
    local instaShootMurderActive = false
    
    local killAuraDistance = 15
    local currentSpeed = 16
    local currentJump = 50
    local currentGravity = workspace.Gravity

    local selectedViewPlayer = LocalPlayer.Name
    local espHighlights = {}
    local espTracers = {}
    local usernameBillboards = {}
    local tracersFolder = Instance.new("Folder", Workspace)
    tracersFolder.Name = "NightHub_Tracers"

    local function getPlayerList()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            table.insert(list, p.Name)
        end
        if #list == 0 then table.insert(list, LocalPlayer.Name) end
        return list
    end

    local function getRole(player)
        if not player.Character then return "Innocent" end
        local bp = player:FindFirstChild("Backpack")
        local char = player.Character
        if (bp and bp:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife")) then
            return "Murderer"
        elseif (bp and bp:FindFirstChild("Gun")) or (char and char:FindFirstChild("Gun")) then
            return "Sheriff"
        else
            return "Innocent"
        end
    end

    local function getRoleColor(role)
        if role == "Murderer" then
            return Color3.fromRGB(255, 0, 0)
        elseif role == "Sheriff" then
            return Color3.fromRGB(0, 0, 255)
        else
            return Color3.fromRGB(0, 255, 0)
        end
    end

    RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if currentSpeed ~= 16 then
                    hum.WalkSpeed = currentSpeed
                end
                if currentJump ~= 50 then
                    hum.UseJumpPower = true
                    hum.JumpPower = currentJump
                end
            end
            if noclipEnabled then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
        if workspace.Gravity ~= currentGravity then
            workspace.Gravity = currentGravity
        end
    end)

    -- ==========================================
    -- 1. ABA MAIN
    -- ==========================================
    local MainTab = Window:Tab({ Title = "Main", Icon = "house" })

    MainTab:Section({ Title = "Movimentação e Física" })

    MainTab:Slider({
        Title = "Speed", Min = 16, Max = 200, Default = 16, Increment = 1,
        Callback = function(v) currentSpeed = tonumber(v) or 16 end
    })

    MainTab:Divider()

    MainTab:Slider({
        Title = "JumpPower", Min = 50, Max = 300, Default = 50, Increment = 1,
        Callback = function(v) currentJump = tonumber(v) or 50 end
    })

    MainTab:Divider()

    MainTab:Slider({
        Title = "Gravity", Min = 0, Max = 300, Default = 196.2, Increment = 1,
        Callback = function(v) currentGravity = tonumber(v) or 196.2 end
    })

    MainTab:Divider()

    MainTab:Slider({
        Title = "FOV", Min = 70, Max = 120, Default = 70, Increment = 1,
        Callback = function(v) Camera.FieldOfView = tonumber(v) or 70 end
    })

    MainTab:Section({ Title = "Utilidades" })

    MainTab:Toggle({
        Title = "Inf Jump", Default = false,
        Callback = function(state) infJumpEnabled = state == true end
    })

    UserInputService.JumpRequest:Connect(function()
        if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    MainTab:Toggle({
        Title = "Noclip", Default = false,
        Callback = function(state) noclipEnabled = state == true end
    })

    MainTab:Section({ Title = "Teleporte e Visualizar" })

    local selectPlayerDropdown = MainTab:Dropdown({
        Title = "Select Player",
        Values = getPlayerList(),
        Value = LocalPlayer.Name,
        Callback = function(v) if v and v ~= "" then selectedViewPlayer = v end end
    })

    Players.PlayerAdded:Connect(function()
        selectPlayerDropdown:Refresh(getPlayerList())
    end)
    Players.PlayerRemoving:Connect(function()
        selectPlayerDropdown:Refresh(getPlayerList())
    end)

    MainTab:Button({
        Title = "Go To Player",
        Callback = function()
            local target = Players:FindFirstChild(selectedViewPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            end
        end
    })

    MainTab:Toggle({
        Title = "View Player", Default = false,
        Callback = function(state)
            viewEnabled = state == true
            if not state then
                Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            end
        end
    })

    RunService.RenderStepped:Connect(function()
        if viewEnabled then
            local target = Players:FindFirstChild(selectedViewPlayer)
            if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = target.Character.Humanoid
            end
        end
    end)

    MainTab:Section({ Title = "Farm e ESP" })

    MainTab:Section({ Title = "Farm e ESP" })

    MainTab:Toggle({
        Title = "Auto Farm", Default = false,
        Callback = function(state) autoFarmActive = state == true end
    })

    task.spawn(function()
        while true do
            task.wait(0.5)
            if autoFarmActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name == "CoinContainer" or obj.Name:lower():find("coin") or obj:FindFirstChild("TouchInterest") then
                        if obj:IsA("BasePart") or obj:IsA("Model") then
                            local part = obj:IsA("BasePart") and obj or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                            if part then
                                local old = LocalPlayer.Character.HumanoidRootPart.CFrame
                                LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
                                task.wait(0.1)
                                LocalPlayer.Character.HumanoidRootPart.CFrame = old
                                break
                            end
                        end
                    end
                end
            end
        end
    end)

    MainTab:Toggle({
        Title = "ESP Roles", Default = false,
        Callback = function(state)
            espEnabled = state == true
            if not state then
                for _, h in pairs(espHighlights) do if h then h:Destroy() end end
                espHighlights = {}
            end
        end
    })

    RunService.RenderStepped:Connect(function()
        if espEnabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local h = espHighlights[p]
                    if not h then
                        h = Instance.new("Highlight")
                        h.Parent = p.Character
                        h.Adornee = p.Character
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        espHighlights[p] = h
                    end
                    local role = getRole(p)
                    h.FillColor = getRoleColor(role)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end)

    MainTab:Toggle({
        Title = "ESP Tracer", Default = false,
        Callback = function(state)
            espTracerEnabled = state == true
            if not state then
                tracersFolder:ClearAllChildren()
                espTracers = {}
            end
        end
    })

    RunService.RenderStepped:Connect(function()
        if espTracerEnabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    local line = espTracers[p]
                    if not line then
                        line = Instance.new("Part")
                        line.Anchored = true
                        line.CanCollide = false
                        line.Size = Vector3.new(0.05, 0.05, 1)
                        line.Material = Enum.Material.Neon
                        line.Parent = tracersFolder
                        espTracers[p] = line
                    end
                    local role = getRole(p)
                    line.Color = getRoleColor(role)
                    
                    local screenCenter = Vector3.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y, 0)
                    local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        line.Transparency = 0
                        local origin = Camera:ViewportPointToWorld(screenCenter.X, screenCenter.Y, 1)
                        local targetPos = hrp.Position
                        line.CFrame = CFrame.new(origin, targetPos) * CFrame.new(0, 0, - (origin - targetPos).Magnitude / 2)
                        line.Size = Vector3.new(0.05, 0.05, (origin - targetPos).Magnitude)
                    else
                        line.Transparency = 1
                    end
                elseif espTracers[p] then
                    espTracers[p].Transparency = 1
                end
            end
        end
    end)

    MainTab:Toggle({
        Title = "Show Username", Default = false,
        Callback = function(state)
            showUsernameEnabled = state == true
            if not state then
                for _, b in pairs(usernameBillboards) do if b then b:Destroy() end end
                usernameBillboards = {}
            end
        end
    })

    RunService.RenderStepped:Connect(function()
        if showUsernameEnabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local head = p.Character.Head
                    local bb = usernameBillboards[p]
                    if not bb then
                        bb = Instance.new("BillboardGui")
                        bb.Name = "NightHub_UserTag"
                        bb.Size = UDim2.new(0, 200, 0, 50)
                        bb.StudsOffset = Vector3.new(0, 2.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Parent = head

                        local txt = Instance.new("TextLabel", bb)
                        txt.Name = "Info"
                        txt.Size = UDim2.new(0, 160, 0, 40)
                        txt.Position = UDim2.new(0, 0, 0, 0)
                        txt.BackgroundTransparency = 1
                        txt.TextSize = 12
                        txt.Font = Enum.Font.GothamBold
                        txt.TextXAlignment = Enum.TextXAlignment.Left
                        usernameBillboards[p] = bb
                    end

                    local role = getRole(p)
                    local col = getRoleColor(role)
                    local txtLabel = bb:FindFirstChild("Info")
                    if txtLabel then
                        txtLabel.TextColor3 = col
                        txtLabel.Text = "@" .. p.Name .. "\n(" .. p.DisplayName .. ")"
                    end
                elseif usernameBillboards[p] then
                    usernameBillboards[p]:Destroy()
                    usernameBillboards[p] = nil
                end
            end
        end
    end)

    -- ==========================================
    -- 2. ABA INNOCENT
    -- ==========================================
    local InnocentTab = Window:Tab({ Title = "Innocent", Icon = "shield-check" })
    
    InnocentTab:Toggle({
        Title = "Auto Pickup Gun", Default = false,
        Callback = function(state) autoPickupGunActive = state == true end
    })

    task.spawn(function()
        while true do
            task.wait(0.2)
            if autoPickupGunActive then
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name == "GunDrop" or obj:FindFirstChild("GunDrop") then
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local old = hrp.CFrame
                            hrp.CFrame = obj.CFrame or obj:GetPivot()
                            task.wait(0.2)
                            hrp.CFrame = old
                        end
                    end
                end
            end
        end
    end)

    InnocentTab:Button({
        Title = "Pickup Gun",
        Callback = function()
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name == "GunDrop" or obj:FindFirstChild("GunDrop") then
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local old = hrp.CFrame
                        hrp.CFrame = obj.CFrame or obj:GetPivot()
                        task.wait(0.3)
                        hrp.CFrame = old
                        break
                    end
                end
            end
        end
    })

    -- ==========================================
    -- 3. ABA SHERIFF
    -- ==========================================
    local SheriffTab = Window:Tab({ Title = "Sheriff", Icon = "crosshair" })

    SheriffTab:Toggle({
        Title = "Aimbot", Default = false,
        Callback = function(state) aimbotActive = state == true end
    })

    RunService.RenderStepped:Connect(function()
        if aimbotActive then
            local closestTarget = nil
            local shortestDist = math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            closestTarget = hrp
                        end
                    end
                end
            end
            if closestTarget then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
            end
        end
    end)

    SheriffTab:Toggle({
        Title = "Auto Shoot", Default = false,
        Callback = function(state) autoShootActive = state == true end
    })

    task.spawn(function()
        while true do
            task.wait(0.1)
            if autoShootActive then
                local gun = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
                if gun then
                    if gun.Parent ~= LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:EquipTool(gun)
                    end
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            gun:Activate()
                            break
                        end
                    end
                end
            end
        end
    end)

    SheriffTab:Toggle({
        Title = "Insta Shoot Murder", Default = false,
        Callback = function(state) instaShootMurderActive = state == true end
    })

    task.spawn(function()
        while true do
            task.wait(0.05)
            if instaShootMurderActive then
                local gun = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
                if gun then
                    if gun.Parent ~= LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:EquipTool(gun)
                    end
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                            pcall(function()
                                gun:Activate()
                            end)
                        end
                    end
                end
            end
        end
    end)

    -- ==========================================
    -- 4. ABA MURDER
    -- ==========================================
    local MurderTab = Window:Tab({ Title = "Murder", Icon = "skull" })
    
    MurderTab:Button({
        Title = "Kill All",
        Callback = function()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
            if tool then
                if tool.Parent ~= LocalPlayer.Character then LocalPlayer.Character.Humanoid:EquipTool(tool) end
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local old = hrp.CFrame
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                            tool:Activate()
                            task.wait(0.2)
                        end
                    end
                    hrp.CFrame = old
                end
            end
        end
    })

    MurderTab:Button({
        Title = "Kill Sheriff",
        Callback = function()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
            if tool then
                if tool.Parent ~= LocalPlayer.Character then LocalPlayer.Character.Humanoid:EquipTool(tool) end
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local old = hrp.CFrame
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and getRole(p) == "Sheriff" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                            tool:Activate()
                            task.wait(0.2)
                            break
                        end
                    end
                    hrp.CFrame = old
                end
            end
        end
    })

    MurderTab:Toggle({
        Title = "Kill Aura", Default = false,
        Callback = function(state) killAuraActive = state == true end
    })

    MurderTab:Divider()

    MurderTab:Slider({
        Title = "Kill Aura Distance", Min = 15, Max = 100, Default = 15, Increment = 1,
        Callback = function(v) killAuraDistance = tonumber(v) or 15 end
    })

    task.spawn(function()
        while true do
            task.wait(0.1)
            if killAuraActive and getRole(LocalPlayer) == "Murderer" then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
                if tool then
                    if tool.Parent ~= LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:EquipTool(tool)
                    end
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                local targetHrp = p.Character.HumanoidRootPart
                                if (hrp.Position - targetHrp.Position).Magnitude <= killAuraDistance then
                                    tool:Activate()
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    -- ==========================================
    -- 5. ABA SETTINGS
    -- ==========================================
    local ThemeTab = Window:Tab({ Title = "Settings", Icon = "settings" })
    
    ThemeTab:Dropdown({
        Title  = "Theme",
        Values = (function()
            local names = {}
            for name in pairs(WindUI:GetThemes()) do table.insert(names, name) end
            table.sort(names)
            return names
        end)(),
        Value    = "Red",
        Callback = function(selected) WindUI:SetTheme(selected) end,
    })

    ThemeTab:Divider()

    ThemeTab:Toggle({
        Title = "Background Image", Default = false,
        Callback = function(state)
            if state == true then
                Window:SetBackgroundImage("rbxassetid://84152360484913")
            else
                Window:SetBackgroundImage("")
            end
        end
    })

    -- ==========================================
    -- 6. ABA CREDITS
    -- ==========================================
    local CreditsTab = Window:Tab({ Title = "Credits", Icon = "info" })

    CreditsTab:Paragraph({
        Title = "Night Hub Official",
        Content = "Criado para MM2 com foco em facilidade e utilidade.",
        Image = "rbxassetid://84152360484913",
        ImageSize = 65,
    })

    CreditsTab:Button({
        Title = "Join Discord",
        Callback = function()
            setclipboard("https://discord.gg/rgERpyZCH")
            WindUI:Notify({ Title = "Sucesso!", Content = "Link do Discord copiado para a Ã¡rea de transferÃªncia!" })
        end
    })

    CreditsTab:Divider()
    CreditsTab:Section({ Title = "DONOS" })
    CreditsTab:Label({ Title = "Nick" })

    CreditsTab:Section({ Title = "AJUDANTES" })
    CreditsTab:Label({ Title = "LostSoul4044" })
    CreditsTab:Label({ Title = "darkADM_ofc" })

    CreditsTab:Section({ Title = "CONTENT CREATORS" })
    CreditsTab:Label({ Title = "Nao_souNICK" })

    WindUI:Notify({
      Title = "Night Hub",
      Content = "MM2 carregado com sucesso!",
    })
    
    WindUI:SetNotificationLower(true)
end)

if not success then
    warn("Erro ao iniciar: " + tostring(errorMessage))
end