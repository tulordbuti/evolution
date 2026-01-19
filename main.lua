-- [[ DEV BUTIZADA V5.7 - LÓGICA DE BLOQUEO DE TARGET ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

shared.KxConfig = {
    menuOpen = true,
    tab = "Universal",
    fov = 250, vis = 110, speed_val = 0.45,
    aim = false, speed = false, spin = false, 
    skeleton = true, box = true, lines = true,
    silent_extreme = false, fps_boost = false
}
local c = shared.KxConfig
local CurrentTarget = nil

-- [ MOTOR VISUAL ]
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5; fovCircle.Color = Color3.new(1, 0, 0); fovCircle.Visible = false

local ESP_STORAGE = {}
local function CreateESP(p)
    local comp = {Box = Drawing.new("Square"), Line = Drawing.new("Line")}
    comp.Box.Thickness = 2; comp.Box.Color = Color3.new(1,0,0)
    comp.Line.Thickness = 1.5; comp.Line.Color = Color3.new(1,1,1)
    ESP_STORAGE[p] = comp
end
for _, p in pairs(Players:GetPlayers()) do if p ~= lp then CreateESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= lp then CreateESP(p) end end)

-- [ GUI CON SECCIONES ]
local function Build()
    local gui = Instance.new("ScreenGui"); gui.Name = "DevButizadaV57"; gui.Parent = game:GetService("CoreGui")
    local main = Instance.new("Frame", gui); main.Size = UDim2.new(0, 720, 0, 520); main.Position = UDim2.new(0.5, -360, 0.5, -250); main.BackgroundColor3 = Color3.fromRGB(8, 8, 8); main.Visible = c.menuOpen
    Instance.new("UIStroke", main).Color = Color3.new(1,0,0); Instance.new("UICorner", main)
    local container = Instance.new("ScrollingFrame", main); container.Size = UDim2.new(1, -230, 1, -80); container.Position = UDim2.new(0, 215, 0, 60); container.BackgroundTransparency = 1; container.CanvasSize = UDim2.new(0,0,4,0); Instance.new("UIListLayout", container).Padding = UDim.new(0, 8)
    
    local function addT(txt, var)
        local b = Instance.new("TextButton", container); b.Size = UDim2.new(0.95, 0, 0, 38); b.BackgroundColor3 = c[var] and Color3.new(1,0,0) or Color3.new(0.1,0.1,0.1); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "SourceSansBold"; b.TextSize = 14; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() c[var] = not c[var]; b.BackgroundColor3 = c[var] and Color3.new(1,0,0) or Color3.new(0.1,0.1,0.1) end)
    end

    local function addS(txt, var, step)
        local f = Instance.new("Frame", container); f.Size = UDim2.new(0.95, 0, 0, 45); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1,0,0,15); l.Text = txt..": "..c[var]; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1
        local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(1,0,0,25); btn.Position = UDim2.new(0,0,0,18); btn.Text = "AJUSTAR (+/-)"; btn.BackgroundColor3 = Color3.new(0.2,0.2,0.2); btn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function() c[var] = UIS:IsKeyDown(Enum.KeyCode.LeftControl) and c[var]-step or c[var]+step; l.Text = txt..": "..c[var] end)
    end

    local function Load(tab)
        container:ClearAllChildren(); Instance.new("UIListLayout", container).Padding = UDim.new(0, 8); c.tab = tab
        addS("FOV", "fov", 20); addS("VISION HACK", "vis", 5)
        addT("🎯 AIMBOT INSTANT", "aim"); addT("🔮 SILENT AGRESIVO", "silent_extreme")
        addT("⚡ SPEED BYPASS", "speed"); addT("🌈 SPINBOT RGB", "spin")
        addT("📦 BOX ESP", "box"); addT("🔗 LINEAS", "lines")
    end

    local b1 = Instance.new("TextButton", main); b1.Size = UDim2.new(0, 190, 0, 50); b1.Position = UDim2.new(0, 10, 0, 60); b1.Text = "UNIVERSAL"; b1.BackgroundColor3 = Color3.new(0.2,0,0); b1.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b1)
    local b2 = Instance.new("TextButton", main); b2.Size = UDim2.new(0, 190, 0, 50); b2.Position = UDim2.new(0, 10, 0, 120); b2.Text = "KRUSH PVP"; b2.BackgroundColor3 = Color3.new(0.2,0,0); b2.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b2)
    b1.MouseButton1Click:Connect(function() Load("Universal") end); b2.MouseButton1Click:Connect(function() Load("Krush") end)
    Load("Universal")
    return main
end

MainMenu = Build()

-- [ MOTOR LOGICO ]
RunService.RenderStepped:Connect(function()
    local cent = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    cam.FieldOfView = c.vis
    fovCircle.Position = cent; fovCircle.Radius = c.fov; fovCircle.Visible = (c.aim or c.silent_extreme)

    -- Buscador de Objetivo Unificado
    local targetChar, minDist = nil, c.fov
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local pos, vis = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - cent).Magnitude
                if mag < minDist then minDist = mag; targetChar = p.Character end
            end
        end
    end
    CurrentTarget = targetChar

    -- LOOP DE ESP CON BLOQUEO DE KRUSH
    for player, draw in pairs(ESP_STORAGE) do
        local char = player.Character
        -- LÓGICA CLAVE: Si es Krush, SOLO dibuja si el char es el CurrentTarget. Si es Universal, dibuja a todos.
        local isTarget = (CurrentTarget and char == CurrentTarget)
        local shouldShow = (c.tab == "Universal") or (c.tab == "Krush" and isTarget)

        if shouldShow and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid").Health > 0 then
            local root = char.HumanoidRootPart
            local sP, vis = cam:WorldToViewportPoint(root.Position)
            if vis then
                if c.box then
                    local h = (cam.ViewportSize.Y / sP.Z) * 2.5; local w = h * 0.6
                    draw.Box.Visible = true; draw.Box.Size = Vector2.new(w, h); draw.Box.Position = Vector2.new(sP.X - w/2, sP.Y - h/2)
                else draw.Box.Visible = false end
                if c.lines then
                    draw.Line.Visible = true; draw.Line.From = Vector2.new(cent.X, cam.ViewportSize.Y); draw.Line.To = Vector2.new(sP.X, sP.Y)
                else draw.Line.Visible = false end
            else draw.Box.Visible = false; draw.Line.Visible = false end
        else draw.Box.Visible = false; draw.Line.Visible = false end
    end

    -- COMBATE AGRESIVO (SIN ERROR DE APUNTADO)
    if CurrentTarget then
        local root = CurrentTarget.HumanoidRootPart
        local pred = root.Position + (root.Velocity * 0.15)
        
        -- Si presiona Click Derecho (Aim) o Click Izquierdo (Silent)
        if (c.aim and UIS:IsMouseButtonPressed(2)) or (c.silent_extreme and UIS:IsMouseButtonPressed(1)) then
            cam.CFrame = CFrame.new(cam.CFrame.Position, pred)
        end
    end

    -- SPINBOT RGB & SPEED
    if c.spin and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(35), 0)
        for _, v in pairs(lp.Character:GetChildren()) do if v:IsA("BasePart") then v.Color = Color3.fromHSV(tick()%5/5, 1, 1) end end
    end
    if c.speed and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character:TranslateBy(lp.Character.Humanoid.Move
