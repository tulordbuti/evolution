-- [[ EVOLUTION X V47 - SHIELD EDITION ]] --
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- Variables de Control (Protegidas)
local Settings = {
    Aim = false,
    Esp = false,
    Speed = 16,
    FOV = 180,
    Vision = 100,
    MenuKey = Enum.KeyCode.RightShift
}

-- [[ MOTOR DE DIBUJO (FOV) ]] --
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 2
fov_circle.Color = Color3.fromRGB(255, 0, 0)
fov_circle.Filled = false
fov_circle.Visible = false

-- [[ LÓGICA DE TARGET ]] --
local function GetClosest()
    local target = nil
    local dist = Settings.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if v.Team ~= lp.Team then
                local pos, vis = cam:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if mag < dist then
                        dist = mag
                        target = v.Character.Head
                    end
                end
            end
        end
    end
    return target
end

-- [[ INTERFAZ GIGANTE ]] --
local function BuildUI()
    local sg = Instance.new("ScreenGui", lp.PlayerGui)
    sg.Name = "EvoShield"; sg.ResetOnSpawn = false
    
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 500, 0, 450)
    main.Position = UDim2.new(0.5, -250, 0.5, -225)
    main.BackgroundColor3 = Color3.fromRGB(15, 0, 0) -- Rojo muy oscuro
    main.BorderSizePixel = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
    Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 0, 0)

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 80)
    title.Text = "EVOLUTION X"
    title.TextColor3 = Color3.new(1,0,0)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 50
    title.BackgroundTransparency = 1

    local function CreateBigBtn(text, pos, func)
        local b = Instance.new("TextButton", main)
        b.Size = UDim2.new(0, 420, 0, 70)
        b.Position = pos
        b.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
        b.Text = text
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 30
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() func(b) end)
    end

    CreateBigBtn("🚀 AIMBOT: OFF", UDim2.new(0.5, -210, 0.25, 0), function(b)
        Settings.Aim = not Settings.Aim
        b.Text = Settings.Aim and "🚀 AIMBOT: ON" or "🚀 AIMBOT: OFF"
        b.TextColor3 = Settings.Aim and Color3.new(0,1,0) or Color3.new(1,1,1)
    end)

    CreateBigBtn("⚡ VELOCIDAD: " .. Settings.Speed, UDim2.new(0.5, -210, 0.45, 0), function(b)
        if Settings.Speed == 16 then Settings.Speed = 100 else Settings.Speed = 16 end
        b.Text = "⚡ VELOCIDAD: " .. Settings.Speed
    end)

    CreateBigBtn("👁️ VISION: " .. Settings.Vision, UDim2.new(0.5, -210, 0.65, 0), function(b)
        if Settings.Vision == 100 then Settings.Vision = 120 else Settings.Vision = 100 end
        b.Text = "👁️ VISION: " .. Settings.Vision
    end)

    return main
end

local menu = BuildUI()

-- [[ BUCLE DE EJECUCIÓN ]] --
RunService.RenderStepped:Connect(function()
    fov_circle.Visible = Settings.Aim
    fov_circle.Radius = Settings.FOV
    fov_circle.Position = UIS:GetMouseLocation()
    cam.FieldOfView = Settings.Vision

    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = Settings.Speed
    end

    if Settings.Aim and not menu.Visible then
        local t = GetClosest()
        if t then
            cam.CFrame = CFrame.new(cam.CFrame.Position, t.Position)
        end
    end
end)

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Settings.MenuKey then
        menu.Visible = not menu.Visible
    end
end)
