-- [[ EVOLUTION X V48 - RECONSTRUCCIÓN TOTAL ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()

-- Configuración Real (Secciones Separadas)
_G.EvoConfig = {
    Menu = true,
    Tab = "Hyper",
    -- Hyper Vars
    H_Aim = false,
    H_Esp = false,
    H_Speed = 16,
    H_Vision = 100,
    H_FOV = 180,
    -- Kush Vars
    K_Aim = false,
    K_Esp = false
}
local c = _G.EvoConfig

-- [[ MOTOR DE DIBUJO (ESP Y FOV) ]] --
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 2; fov_circle.Color = Color3.new(1,0,0); fov_circle.Visible = false

local esp_data = {}

local function create_esp(obj)
    if esp_data[obj] then return end
    esp_data[obj] = {
        box = Drawing.new("Square"),
        line = Drawing.new("Line")
    }
end

-- [[ LÓGICA DE TARGET ]] --
local function getClosest()
    local target = nil
    local dist = c.H_FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Team ~= lp.Team and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
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
    return target
end

-- [[ INTERFAZ GIGANTE CON SECCIONES ]] --
local function BuildUI()
    if lp.PlayerGui:FindFirstChild("EvoX") then lp.PlayerGui.EvoX:Destroy() end
    local sg = Instance.new("ScreenGui", lp.PlayerGui); sg.Name = "EvoX"; sg.ResetOnSpawn = false
    
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 550, 0, 480); main.Position = UDim2.new(0.5, -275, 0.5, -240); main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); main.Visible = c.Menu
    Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 0, 0); Instance.new("UICorner", main)

    local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 140, 1, 0); side.BackgroundColor3 = Color3.fromRGB(20, 5, 5); Instance.new("UICorner", side)
    
    local container = Instance.new("Frame", main); container.Size = UDim2.new(1, -150, 1, -20); container.Position = UDim2.new(0, 145, 0, 10); container.BackgroundTransparency = 1
    local list = Instance.new("UIListLayout", container); list.Padding = UDim.new(0, 12)

    local function addBtn(txt, parent, callback)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, -10, 0, 60); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "SourceSansBold"; b.TextSize = 24; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() callback(b) end)
        return b
    end

    -- Pestañas
    local btnHyper = addBtn("HYPER", side, function() end)
    btnHyper.Position = UDim2.new(0, 5, 0, 10); btnHyper.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    
    local btnKush = addBtn("KUSH", side, function() end)
    btnKush.Position = UDim2.new(0, 5, 0, 80)

    -- Contenido Hyper
    local function loadHyper()
        container:ClearAllChildren(); Instance.new("UIListLayout", container).Padding = UDim.new(0, 12)
        
        addBtn("🚀 AIMBOT: "..(c.H_Aim and "ON" or "OFF"), container, function(b)
            c.H_Aim = not c.H_Aim; b.Text = "🚀 AIMBOT: "..(c.H_Aim and "ON" or "OFF"); b.TextColor3 = c.H_Aim and Color3.new(0,1,0) or Color3.new(1,1,1)
        end)
        
        addBtn("📦 ESP: "..(c.H_Esp and "ON" or "OFF"), container, function(b)
            c.H_Esp = not c.H_Esp; b.Text = "📦 ESP: "..(c.H_Esp and "ON" or "OFF"); b.TextColor3 = c.H_Esp and Color3.new(0,1,0) or Color3.new(1,1,1)
        end)

        addBtn("⚡ SPEED: "..c.H_Speed, container, function(b)
            if c.H_Speed == 16 then c.H_Speed = 100 elseif c.H_Speed == 100 then c.H_Speed = 200 else c.H_Speed = 16 end
            b.Text = "⚡ SPEED: "..c.H_Speed
        end)
        
        addBtn("👁️ VISION: "..c.H_Vision, container, function(b)
            c.H_Vision = (c.H_Vision == 100 and 130 or 100); b.Text = "👁️ VISION: "..c.H_Vision
        end)
    end

    btnHyper.MouseButton1Click:Connect(loadHyper)
    btnKush.MouseButton1Click:Connect(function()
        container:ClearAllChildren(); Instance.new("UIListLayout", container).Padding = UDim.new(0, 12)
        addBtn("🎯 KUSH LOCK", container, function(b) c.K_Aim = not c.K_Aim; b.TextColor3 = c.K_Aim and Color3.new(0,1,0) or Color3.new(1,1,1) end)
        addBtn("🔗 KUSH ESP", container, function(b) c.K_Esp = not c.K_Esp; b.TextColor3 = c.K_Esp and Color3.new(0,1,0) or Color3.new(1,1,1) end)
    end)

    loadHyper(); return main
end

local menuFrame = BuildUI()

-- [[ BUCLE DE RENDERIZADO ]] --
RunService.RenderStepped:Connect(function()
    fov_circle.Visible = (c.H_Aim or c.K_Aim); fov_circle.Radius = c.H_FOV; fov_circle.Position = UIS:GetMouseLocation()
    cam.FieldOfView = c.H_Vision
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = c.H_speed end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character; create_esp(char)
            local data = esp_data[char]
            local pos, vis = cam:WorldToViewportPoint(char.HumanoidRootPart.Position)
            
            if (c.H_Esp or c.K_Esp) and vis and char.Humanoid.Health > 0 and p.Team ~= lp.Team then
                local headV = cam:WorldToViewportPoint(char.Head.Position + Vector3.new(0, 1.5, 0))
                local footV = cam:WorldToViewportPoint(char.HumanoidRootPart.Position - Vector3.new(0, 3.5, 0))
                local h = math.abs(headV.Y - footV.Y); local w = h / 1.5
                
                data.box.Visible = true; data.box.Size = Vector2.new(w, h); data.box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2); data.box.Color = Color3.new(1,0,0)
                data.line.Visible = true; data.line.From = Vector2.new(cam.ViewportSize.X/2, 0); data.line.To = Vector2.new(pos.X, pos.Y - h/2); data.line.Color = Color3.new(1,0,0)
            else
                data.box.Visible = false; data.line.Visible = false
            end
        end
    end

    if (c.H_Aim or c.K_Aim) and not menuFrame.Visible then
        local t = getClosest()
        if t then cam.CFrame = CFrame.new(cam.CFrame.Position, t.Position) end
    end
end)

UIS.InputBegan:Connect(function(k) if k.KeyCode == Enum.KeyCode.RightShift then menuFrame.Visible = not menuFrame.Visible end end)
