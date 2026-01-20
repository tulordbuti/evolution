-- [[ KX SEN CHEATS DEV BUTIZADA V18 - FULL RESTORED ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
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

-- [ OVERLAY MAKANKY ]
local function CreateOverlay()
    local sg = Instance.new("ScreenGui", game:GetService("CoreGui")); sg.Name = "KxOverlay"
    local bg = Instance.new("Frame", sg); bg.Size = UDim2.new(0, 180, 0, 90); bg.Position = UDim2.new(0, 10, 0.4, 0); bg.BackgroundColor3 = Color3.new(0,0,0); bg.BackgroundTransparency = 0.4
    Instance.new("UIStroke", bg).Color = Color3.new(1,0,0); Instance.new("UICorner", bg)
    local info = Instance.new("TextLabel", bg); info.Size = UDim2.new(1, -10, 1, -10); info.Position = UDim2.new(0, 5, 0, 5); info.BackgroundTransparency = 1; info.TextColor3 = Color3.new(1,1,1); info.TextSize = 13; info.Font = "Code"; info.TextXAlignment = "Left"; info.TextYAlignment = "Top"
    return info
end
local OverlayText = CreateOverlay()

-- [ MOTOR VISUAL COMPLETO ]
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2; fovCircle.Color = Color3.new(1, 0, 0); fovCircle.Visible = false

local ESP_STORAGE = {}
local function CreateESP(p)
    local comp = { Box = Drawing.new("Square"), Line = Drawing.new("Line"), Skeleton = {} }
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

-- [ GUI ORIGINAL - TODAS LAS OPCIONES ]
local function Build()
    local gui = Instance.new("ScreenGui"); gui.Name = "KX_SEN_DEV"; gui.Parent = game:GetService("CoreGui")
    local main = Instance.new("Frame", gui); main.Size = UDim2.new(0, 720, 0, 520); main.Position = UDim2.new(0.5, -360, 0.5, -260); main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); main.Visible = c.menuOpen
    Instance.new("UIStroke", main).Color = Color3.new(1,0,0); Instance.new("UICorner", main)
    
    local title = Instance.new("TextLabel", main); title.Size = UDim2.new(1, 0, 0, 50); title.Text = "KX SEN CHEATS - DEV BUTIZADA"; title.TextColor3 = Color3.new(1,0,0); title.Font = "SourceSansBold"; title.TextSize = 25; title.BackgroundTransparency = 1

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
        addT("🎯 AIM MOUSE LOCK (RMB)", "aim"); addT("🔮 SILENT AGRESSIVE (LMB)", "silent_extreme")
        addT("⚡ SPEED BYPASS", "speed"); addT("🌈 SPINBOT RGB CUERPO", "spin")
        addT("💀 SKELETON ESP", "skeleton"); addT("📦 BOX ESP", "box"); addT("🔗 LINEAS (KRUSH FIX)", "lines")
        addT("🚀 FPS BOOST", "fps_boost"); addT("👁️ MIRAR PERSONAJE", "view_char")
    end

    local b1 = Instance.new("TextButton", main); b1.Size = UDim2.new(0, 190, 0, 50); b1.Position = UDim2.new(0, 10, 0, 60); b1.Text = "UNIVERSAL"; b1.BackgroundColor3 = Color3.new(0.2,0,0); b1.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b1)
    local b2 = Instance.new("TextButton", main); b2.Size = UDim2.new(0, 190, 0, 50); b2.Position = UDim2.new(0, 10, 0, 120); b2.Text = "KRUSH PVP"; b2.BackgroundColor3 = Color3.new(0.2,0,0); b2.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b2)
    b1.MouseButton1Click:Connect(function() Load("Universal") end); b2.MouseButton1Click:Connect(function() Load("Krush") end)
    Load("Universal"); return main
end
local MainMenu = Build()

-- [ LOOP DE POTENCIA TOTAL ]
RunService.RenderStepped:Connect(function()
    local cent = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    cam.FieldOfView = c.vis
    fovCircle.Visible = (c.aim or c.silent_extreme); fovCircle.Position = cent; fovCircle.Radius = c.fov

    local targetHead, target2D = nil, nil
    local dist = c.fov
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Team ~= lp.Team and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
            local mag = (p.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
            if (c.tab == "Universal") or (c.tab == "Krush" and mag < 35) then
                local pos, _ = cam:WorldToViewportPoint(p.Character.Head.Position)
                local m = (Vector2.new(pos.X, pos.Y) - cent).Magnitude
                if m < dist then dist = m; targetHead = p.Character.Head; target2D = pos end
            end
        end
    end

    -- OVERLAY UPDATE
    OverlayText.Text = string.format("KX SEN CHEATS\nFPS: %s\nTarget: %s\nDist: %s studs\nModo: %s", math.floor(1/RunService.RenderStepped:Wait()), (targetHead and targetHead.Parent.Name or "None"), (targetHead and math.floor((targetHead.Position - lp.Character.Head.Position).Magnitude) or 0), c.tab)

    -- COMBATE (MOUSE PARA AIM, LERP PARA SILENT)
    if c.aim and target2D and UIS:IsMouseButtonPressed(2) then
        local mPos = UIS:GetMouseLocation()
        mousemoverel((target2D.X - mPos.X) * 0.3, (target2D.Y - mPos.Y) * 0.3)
    end
    if c.silent_extreme and targetHead and UIS:IsMouseButtonPressed(1) then
        local pred = targetHead.Position + (targetHead.Parent.HumanoidRootPart.Velocity * 0.16)
        cam.CFrame = cam.CFrame:Lerp(CFrame.lookAt(cam.CFrame.Position, pred), 0.35)
    end

    -- MIRAR PERSONAJE
    if c.view_char then cam.CameraSubject = lp.Character:FindFirstChildOfClass("Humanoid") end

    -- ESP COMPLETO (VE A ESCONDIDOS)
    for player, draw in pairs(ESP_STORAGE) do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local mag = root and (root.Position - lp.Character.HumanoidRootPart.Position).Magnitude or 1000
        local show = player.Team ~= lp.Team and char and char.Humanoid.Health > 0
        if c.tab == "Krush" and mag > 35 then show = false end

        if show and root then
            local sP, _ = cam:WorldToViewportPoint(root.Position)
            if sP.Z > 0 then
                if c.box then draw.Box.Visible = true; draw.Box.Size = Vector2.new(2500/sP.Z, 2500/sP.Z * 1.2); draw.Box.Position = Vector2.new(sP.X - draw.Box.Size.X/2, sP.Y - draw.Box.Size.Y/2) else draw.Box.Visible = false end
                if c.lines then draw.Line.Visible = true; draw.Line.From = Vector2.new(cent.X, cam.ViewportSize.Y); draw.Line.To = Vector2.new(sP.X, sP.Y) else draw.Line.Visible = false end
                if c.skeleton and char:FindFirstChild("Head") then
                    local joints = {char.Head, char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm"), char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm"), char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg"), char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg")}
                    for i, j in pairs(joints) do if j and draw.Skeleton[i] then local jP = cam:WorldToViewportPoint(j.Position) draw.Skeleton[i].Visible = true; draw.Skeleton[i].From = Vector2.new(sP.X, sP.Y); draw.Skeleton[i].To = Vector2.new(jP.X, jP.Y) end end
                else for _, s in pairs(draw.Skeleton) do s.Visible = false end end
            else draw.Box.Visible = false; draw.Line.Visible = false; for _, s in pairs(draw.Skeleton) do s.Visible = false end end
        else draw.Box.Visible = false; draw.Line.Visible = false; for _, s in pairs(draw.Skeleton) do s.Visible = false end end
    end

    -- EXTRAS RESTAURADOS
    if c.spin and lp.Character then lp.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(35), 0) end
    if c.fps_boost then settings().Rendering.QualityLevel = 1 end
    if c.speed and lp.Character then lp.Character:TranslateBy(lp.Character.Humanoid.MoveDirection * c.speed_val) end
end)

UIS.InputBegan:Connect(function(k) if k.KeyCode == Enum.KeyCode.RightShift then MainMenu.Visible = not MainMenu.Visible end end)
