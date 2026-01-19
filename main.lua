-- [[ DEV BUTIZADA V6.0 - ALL FEATURES RESTORED ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

shared.KxConfig = {
    menuOpen = true,
    tab = "Universal",
    fov = 300, vis = 110, speed_val = 0.45,
    aim = false, silent_extreme = false,
    speed = false, spin = false, 
    skeleton = true, box = true, lines = true,
    fps_boost = false, view_char = false
}
local c = shared.KxConfig
local GlobalTarget = nil

-- [ MOTOR VISUAL COMPLETO ]
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2; fovCircle.Color = Color3.new(1, 0, 0); fovCircle.Visible = false

local ESP_STORAGE = {}
local function CreateESP(p)
    local comp = {
        Box = Drawing.new("Square"),
        Line = Drawing.new("Line"),
        Skeleton = {}
    }
    comp.Box.Thickness = 2; comp.Box.Color = Color3.new(1,0,0)
    comp.Line.Thickness = 1.5; comp.Line.Color = Color3.new(1,1,1)
    for i = 1, 6 do
        local l = Drawing.new("Line"); l.Thickness = 1.8; l.Color = Color3.new(1,1,1)
        table.insert(comp.Skeleton, l)
    end
    ESP_STORAGE[p] = comp
end
for _, p in pairs(Players:GetPlayers()) do if p ~= lp then CreateESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= lp then CreateESP(p) end end)

-- [ GUI CON TODAS LAS OPCIONES ]
local function Build()
    local gui = Instance.new("ScreenGui"); gui.Name = "DevButizadaV60"; gui.Parent = game:GetService("CoreGui")
    local main = Instance.new("Frame", gui); main.Size = UDim2.new(0, 720, 0, 520); main.Position = UDim2.new(0.5, -360, 0.5, -260); main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); main.Visible = c.menuOpen
    Instance.new("UIStroke", main).Color = Color3.new(1,0,0); Instance.new("UICorner", main)
    local container = Instance.new("ScrollingFrame", main); container.Size = UDim2.new(1, -230, 1, -80); container.Position = UDim2.new(0, 215, 0, 60); container.BackgroundTransparency = 1; container.CanvasSize = UDim2.new(0,0,4.5,0); Instance.new("UIListLayout", container).Padding = UDim.new(0, 8)
    
    local function addT(txt, var)
        local b = Instance.new("TextButton", container); b.Size = UDim2.new(0.95, 0, 0, 35); b.BackgroundColor3 = c[var] and Color3.new(1,0,0) or Color3.new(0.1,0.1,0.1); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "SourceSansBold"; b.TextSize = 14; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() c[var] = not c[var]; b.BackgroundColor3 = c[var] and Color3.new(1,0,0) or Color3.new(0.1,0.1,0.1) end)
    end

    local function addS(txt, var, step)
        local f = Instance.new("Frame", container); f.Size = UDim2.new(0.95, 0, 0, 45); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1,0,0,15); l.Text = txt..": "..c[var]; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1
        local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(1,0,0,25); btn.Position = UDim2.new(0,0,0,18); btn.Text = "AJUSTAR (+ / - CTRL)"; btn.BackgroundColor3 = Color3.new(0.2,0.2,0.2); btn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function() c[var] = UIS:IsKeyDown(Enum.KeyCode.LeftControl) and c[var]-step or c[var]+step; l.Text = txt..": "..c[var] end)
    end

    local function Load(tab)
        container:ClearAllChildren(); Instance.new("UIListLayout", container).Padding = UDim.new(0, 8); c.tab = tab
        addS("FOV AJUSTABLE", "fov", 20); addS("VISION HACK", "vis", 5)
        addT("🎯 AIMBOT INSTANT (RMB)", "aim"); addT("🔮 SILENT AGRESSIVE (LMB)", "silent_extreme")
        addT("⚡ SPEED BYPASS", "speed"); addT("🌈 SPINBOT RGB CUERPO", "spin")
        addT("💀 SKELETON ESP", "skeleton"); addT("📦 BOX ESP", "box"); addT("🔗 LINEAS", "lines")
        addT("🚀 FPS BOOST", "fps_boost"); addT("👁️ MIRAR PERSONAJE", "view_char")
    end

    local b1 = Instance.new("TextButton", main); b1.Size = UDim2.new(0, 190, 0, 50); b1.Position = UDim2.new(0, 10, 0, 60); b1.Text = "UNIVERSAL"; b1.BackgroundColor3 = Color3.new(0.2,0,0); b1.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b1)
    local b2 = Instance.new("TextButton", main); b2.Size = UDim2.new(0, 190, 0, 50); b2.Position = UDim2.new(0, 10, 0, 120); b2.Text = "KRUSH PVP"; b2.BackgroundColor3 = Color3.new(0.2,0,0); b2.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b2)
    b1.MouseButton1Click:Connect(function() Load("Universal") end); b2.MouseButton1Click:Connect(function() Load("Krush") end)
    Load("Universal")
    return main
end

local MainMenu = Build()

-- [ LOOP DE POTENCIA ]
RunService.RenderStepped:Connect(function()
    local cent = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    cam.FieldOfView = c.vis
    fovCircle.Visible = (c.aim or c.silent_extreme); fovCircle.Position = cent; fovCircle.Radius = c.fov

    -- Target Finder
    local target, dist = nil, c.fov
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local pos, vis = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if vis then
                local m = (Vector2.new(pos.X, pos.Y) - cent).Magnitude
                if m < dist then dist = m; target = p.Character.HumanoidRootPart end
            end
        end
    end
    GlobalTarget = target

    -- Mirar Personaje
    if c.view_char then cam.CameraSubject = lp.Character:FindFirstChildOfClass("Humanoid") end

    -- Aimbot / Silent
    if GlobalTarget then
        local p = GlobalTarget.Position + (GlobalTarget.Velocity * 0.14)
        if (c.aim and UIS:IsMouseButtonPressed(2)) or (c.silent_extreme and UIS:IsMouseButtonPressed(1)) then
            cam.CFrame = CFrame.new(cam.CFrame.Position, p)
        end
    end

    -- ESP COMPLETO (BOX, LINES, SKELETON)
    for player, draw in pairs(ESP_STORAGE) do
        local char = player.Character
        local isT = (GlobalTarget and char == GlobalTarget.Parent)
        local show = (c.tab == "Universal") or (c.tab == "Krush" and isT)

        if show and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid").Health > 0 then
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
                if c.skeleton and char:FindFirstChild("Head") then
                    local joints = {char.Head, char:FindFirstChild("Left Arm"), char:FindFirstChild("Right Arm"), char:FindFirstChild("Left Leg"), char:FindFirstChild("Right Leg")}
                    for i, j in pairs(joints) do
                        if j and draw.Skeleton[i] then
                            local jP = cam:WorldToViewportPoint(j.Position)
                            draw.Skeleton[i].Visible = true; draw.Skeleton[i].From = Vector2.new(sP.X, sP.Y); draw.Skeleton[i].To = Vector2.new(jP.X, jP.Y)
                        end
                    end
                else for _, s in pairs(draw.Skeleton) do s.Visible = false end end
            else draw.Box.Visible = false; draw.Line.Visible = false; for _, s in pairs(draw.Skeleton) do s.Visible = false end end
        else draw.Box.Visible = false; draw.Line.Visible = false; for _, s in pairs(draw.Skeleton) do s.Visible = false end end
    end

    -- Spinbot RGB & FPS Boost
    if c.spin and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(35), 0)
        for _, v in pairs(lp.Character:GetChildren()) do if v:IsA("BasePart") then v.Color = Color3.fromHSV(tick()%5/5, 1, 1) end end
    end
    if c.fps_boost then settings().Rendering.QualityLevel = 1 end
    if c.speed and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character:TranslateBy(lp.Character.Humanoid.MoveDirection * c.speed_val)
    end
end)

UIS.InputBegan:Connect(function(k) if k.KeyCode == Enum.KeyCode.RightShift then MainMenu.Visible = not MainMenu.Visible end end)
