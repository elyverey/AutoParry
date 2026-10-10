local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer

local Chloex = loadstring(game:HttpGet("https://raw.githubusercontent.com/RillBoys/bolong.catui/refs/heads/main/b0lngUi.lua"))()

local VERSION = "v4.2.0 Lite"
local ACCENT_COLOR = Color3.fromRGB(255, 255, 255)

local STRAFE_ENABLED = false
local STRAFE_SPEED = 186
local MIN_STRAFE_SPEED = 186
local MAX_STRAFE_SPEED = 500
local AIR_ACCELERATION = 8

local Character
local Humanoid
local RootPart

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

local function BindCharacter(character)
    Character = character
    Humanoid = character:WaitForChild("Humanoid", 10)
    RootPart = character:WaitForChild("HumanoidRootPart", 10)
end

if LP.Character then
    task.spawn(BindCharacter, LP.Character)
end

LP.CharacterAdded:Connect(BindCharacter)

local function Flat(vector)
    return Vector3.new(vector.X, 0, vector.Z)
end

local function IsAirborne(humanoid)
    if not humanoid or humanoid.Health <= 0 then
        return false
    end

    local state = humanoid:GetState()
    return humanoid.FloorMaterial == Enum.Material.Air
        and state ~= Enum.HumanoidStateType.Climbing
        and state ~= Enum.HumanoidStateType.Swimming
        and state ~= Enum.HumanoidStateType.Seated
        and state ~= Enum.HumanoidStateType.Dead
end

local function ApplyAirStrafe(deltaTime)
    if not STRAFE_ENABLED then
        return
    end

    if not Character or not Character.Parent
        or not Humanoid or not Humanoid.Parent
        or not RootPart or not RootPart.Parent then
        return
    end

    if not IsAirborne(Humanoid) then
        return
    end

    local moveDirection = Flat(Humanoid.MoveDirection)
    if moveDirection.Magnitude < 0.05 then
        return
    end
    moveDirection = moveDirection.Unit

    local velocity = RootPart.AssemblyLinearVelocity
    local horizontalVelocity = Flat(velocity)
    local targetSpeed = math.clamp(STRAFE_SPEED, MIN_STRAFE_SPEED, MAX_STRAFE_SPEED)
    local currentSpeed = horizontalVelocity.Magnitude

    if currentSpeed > targetSpeed then
        horizontalVelocity = horizontalVelocity.Unit * targetSpeed
    else
        -- Air acceleration: input direction adds horizontal speed while airborne.
        local speedAlongInput = horizontalVelocity:Dot(moveDirection)
        local addSpeed = targetSpeed - speedAlongInput

        if addSpeed > 0 then
            local acceleration = math.min(
                addSpeed,
                AIR_ACCELERATION * targetSpeed * math.max(deltaTime, 0)
            )
            horizontalVelocity += moveDirection * acceleration
        end

        -- Keep the configured value as the maximum horizontal air speed.
        local newSpeed = horizontalVelocity.Magnitude
        if newSpeed > targetSpeed then
            horizontalVelocity = horizontalVelocity.Unit * targetSpeed
        end
    end

    RootPart.AssemblyLinearVelocity = Vector3.new(
        horizontalVelocity.X,
        velocity.Y,
        horizontalVelocity.Z
    )
end

local function BuildUI()
    local Window = Chloex:Window({
        Title = "BOLONG-HUB",
        Image = "84034353458936",
        Footer = "Violence District",
        Author = "Discord.gg/pWpgqVGxNK",
        Color = ACCENT_COLOR,
        Version = 1,
        Search = true,
        Folder = "BolongHub"
    })

    local ExclusiveTab = Window:AddTab({
        Name = "Exclusive",
        Icon = "sparkles"
    })

    local StrafeSection = ExclusiveTab:AddSection("Strafe", nil)

    StrafeSection:AddToggle({
        Title = "Air Strafe",
        Default = false,
        Callback = function(value)
            STRAFE_ENABLED = value == true
            Notify(
                "Strafe",
                STRAFE_ENABLED and "Air Strafe enabled" or "Air Strafe disabled",
                1.5
            )
        end
    })

    StrafeSection:AddSlider({
        Title = "Strafe Speed",
        Min = MIN_STRAFE_SPEED,
        Max = MAX_STRAFE_SPEED,
        Default = STRAFE_SPEED,
        Increment = 1,
        Callback = function(value)
            STRAFE_SPEED = math.clamp(
                tonumber(value) or MIN_STRAFE_SPEED,
                MIN_STRAFE_SPEED,
                MAX_STRAFE_SPEED
            )
        end
    })

    StrafeSection:AddLabel({
        Title = "Air Strafe Info",
        Content = "Adjusts horizontal air movement from 186 to 500. Changes apply immediately while airborne."
    })
end

BuildUI()

RunService.Heartbeat:Connect(function(deltaTime)
    ApplyAirStrafe(deltaTime)
end)

print("BOLONG-HUB Evade loaded")
