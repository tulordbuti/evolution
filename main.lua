-- [[ KXSEN V240 - RAPID FIRE & INFINITE AMMO ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()
 
shared.KxConfig = {
    menuOpen = true,
    tab = "Kush",
    -- KUSH
    k_aim = false, k_silent = false, k_ia = true, k_spin = false,
    k_vis = 90, k_speed = 16, k_fov = 150, k_box_dist = 60, k_lines = true,
    -- HYPER
    h_aim = false, h_shake = true, h_head = true, h_lock = true, h_rapid = false, h_inf = false,
    h_vis = 90, h_speed = 16, h_fov = 200
}
local c = shared.KxConfig
local CombatTarget = nil
 
local function isEnemy(p)
    if not p or p == lp then return false end
    if p.Team and lp.Team and p.Team == lp.Team then return false end
    if not p.Character or not p.Character:FindFirstChild("Humanoid") or p.Character.Humanoid.Health <= 0 then return false end
    return true
end
 
-- [ VISUALES ]
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2; fovCircle.Color = Color3.new(1,0,0); fovCircle.Visible = false
local duelLine = Drawing.new("Line")
duelLine.Thickness = 3; duelLine.Color = Color3.new(0,1,0); duelLine.Visible = false
 
-- [ GUI PRINCIPAL ]
local function Build()
    local gui = Instance.new("ScreenGui")
    gui.Name = "KxV240"; gui.ResetOnSpawn = false
    gui.Parent = (game:GetService("CoreGui") or lp.PlayerGui)
 
    -- OVERLAY MEJORADO
    local ov = Instance.new("Frame", gui); ov.Size = UDim2.new(0, 320, 0, 180); ov.Position = UDim2.new(1, -340, 1, -200); ov.BackgroundColor3 = Color3.new(0,0,0); ov.BackgroundTransparency = 0.5
    Instance.new("UIStroke", ov).Color = Color3.new(1,0,0); Instance.new("UICorner", ov)
    local ot = Instance.new("TextLabel", ov); ot.Size = UDim2.new(1,-20,1,-20); ot.Position = UDim2.new(0,10,0,10); ot.TextColor3 = Color3.new(1,1,1); ot.Font = "Code"; ot.TextSize = 22; ot.TextXAlignment = "Left"; ot.BackgroundTransparency = 1; ot.RichText = true
 
    local main = Instance.new("Frame", gui); main.Size = UDim2.new(0, 750, 0, 600); main.Position = UDim2.new(0.5, -375, 0.5, -300); main.BackgroundColor3 = Color3.fromRGB(12, 12, 15); main.Visible = c.menuOpen
    Instance.new("UIStroke", main).Color = Color3.new(1,0,0); Instance.new("UICorner", main); main.Active = true; main.Draggable = true
 
    local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 200, 1, -20); side.Position = UDim2.new(0, 10, 0, 10); side.BackgroundTransparency = 1
    local container = Instance.new("ScrollingFrame", main); container.Size = UDim2.new(1, -230, 1, -20); container.Position = UDim2.new(0, 220, 0, 10); container.BackgroundTransparency = 1; container.ScrollBarThickness = 5; container.CanvasSize = UDim2.new(0,0,3.5,0)
    Instance.new("UIListLayout", container).Padding = UDim.new(0, 12)
 
    local function addT(txt, var)
        local b = Instance.new("TextButton", container); b.Size = UDim2.new(0.95, 0, 0, 55); b.BackgroundColor3 = c[var] and Color3.new(0.8,0,0) or Color3.new(0.1,0.1,0.1); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "SourceSansBold"; b.TextSize = 22; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() c[var] = not c[var]; b.BackgroundColor3 = c[var] and Color3.new(0.8,0,0) or Color3.new(0.1,0.1,0.1) end)
    end
 
    local function LoadKush()
        container:ClearAllChildren(); Instance.new("UIListLayout", container).Padding = UDim.new(0, 12); c.tab = "Kush"
        addT("🎯 IA AIMBOT KUSH", "k_aim"); addT("🔮 SILENT AIM", "k_silent"); addT("🔄 SPIN BOT", "k_spin"); addT("🔗 LINEA DE BOX", "k_lines")
    end
 
    local function LoadHyper()
        container:ClearAllChildren(); Instance.new("UIListLayout", container).Padding = UDim.new(0, 12); c.tab = "Hyper"
        addT("🎯 AGRESSIVE AIMBOT", "h_aim"); addT("💀 BUG CAM (SHAKE)", "h_shake"); addT("💀 SOLO CABEZA", "h_head"); addT("🔥 DISPARO RÁPIDO", "h_rapid"); addT("♾️ BALAS INFINITAS", "h_inf"); addT("🔒 LOCK TARGET", "h_lock")
    end
 
    local bK = Instance.new("TextButton", side); bK.Size = UDim2.new(1,0,0,60); bK.Text = "KUSH MODE"; bK.BackgroundColor3 = Color3.new(0.8,0,0); bK.TextColor3 = Color3.new(1,1,1); bK.Font = "SourceSansBold"; bK.TextSize = 24; Instance.new("UICorner", bK)
    local bH = Instance.new("TextButton", side); bH.Size = UDim2.new(1,0,0,60); bH.Position = UDim2.new(0,0,0,70); bH.Text = "HYPER MODE"; bH.BackgroundColor3 = Color3.new(0.2,0.2,0.2); bH.TextColor3 = Color3.new(1,1,1); bH.Font = "SourceSansBold"; bH.TextSize = 24; Instance.new("UICorner", bH)
 
    bK.MouseButton1Click:Connect(LoadKush); bH.MouseButton1Click:Connect(LoadHyper); LoadKush()
 
    RunService.RenderStepped:Connect(function()
        local tName = CombatTarget and CombatTarget.Parent.Name or "NONE"
        local color = CombatTarget and "#00FF00" or "#FFFFFF" -- Verde si hay target
        ot.Text = string.format("KXSEN V240\nMODE: %s\nFPS: %d\nTARGET: <font color='%s'>%s</font>", c.tab:upper(), math.floor(1/RunService.RenderStepped:Wait()), color, tName:sub(1,12))
    end)
    return main
end
 
local MainMenu = Build()
 
-- [ MOTOR DE ARMAS (RAPID/INF) ]
RunService.Heartbeat:Connect(function()
    if lp.Character then
        local tool = lp.Character:FindFirstChildOfClass("Tool")
        if tool then
            if c.h_rapid and tool:FindFirstChild("Configuration") then -- Ejemplo común
                for _, v in pairs(tool.Configuration:GetChildren()) do
                    if v.Name:find("Cooldown") or v.Name:find("Rate") then v.Value = 0.01 end
                end
            end
            if c.h_inf and tool:FindFirstChild("Ammo") then
                tool.Ammo.Value = 999
            end
        end
    end
end)
 
-- [ MOTOR PRINCIPAL ]
RunService.RenderStepped:Connect(function()
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    fovCircle.Position = center; fovCircle.Radius = (c.tab == "Kush") and c.k_fov or c.h_fov
    fovCircle.Visible = (c.k_aim or c.h_aim or c.k_silent)
 
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = (c.tab == "Kush") and c.k_speed or c.h_speed
        if c.k_spin then lp.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(45), 0) end
    end
    cam.FieldOfView = (c.tab == "Kush") and c.k_vis or c.h_vis
 
    -- BOX DETECTION
    if CombatTarget then
        local d3 = (lp.Character.HumanoidRootPart.Position - CombatTarget.Position).Magnitude
        if not isEnemy(Players:GetPlayerFromCharacter(CombatTarget.Parent)) or d3 > (c.k_box_dist + 40) then CombatTarget = nil end
    end
 
    if not CombatTarget then
        local bestD = fovCircle.Radius
        for _, p in pairs(Players:GetPlayers()) do
            if isEnemy(p) then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local d3 = (lp.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if d3 <= c.k_box_dist then -- SOLO EN TU BOX
                        local sPos, vis = cam:WorldToViewportPoint(hrp.Position)
                        if vis then
                            local d2 = (Vector2.new(sPos.X, sPos.Y) - center).Magnitude
                            if d2 < bestD then bestD = d2; CombatTarget = hrp end
                        end
                    end
                end
            end
        end
    end
 
    -- EJECUCIÓN
    if CombatTarget and not MainMenu.Visible then
        local goal = (c.tab == "Hyper" and c.h_head) and CombatTarget.Parent:FindFirstChild("Head") or CombatTarget
        local aimPos = goal.Position
 
        if c.k_ia then aimPos = aimPos + (CombatTarget.Velocity * 0.15) end
 
        if c.k_lines then
            local pPos = cam:WorldToViewportPoint(goal.Position)
            duelLine.Visible = true; duelLine.From = Vector2.new(center.X, cam.ViewportSize.Y); duelLine.To = Vector2.new(pPos.X, pPos.Y)
        else duelLine.Visible = false end
 
        if c.k_aim or c.h_aim or c.k_silent then
            if c.tab == "Hyper" and c.h_shake then
                aimPos = aimPos + Vector3.new(math.random(-8,8)/100, math.random(-8,8)/100, math.random(-8,8)/100)
            end
            cam.CFrame = CFrame.new(cam.CFrame.Position, aimPos)
        end
    else duelLine.Visible = false end
end)
 
UIS.InputBegan:Connect(function(k) if k.KeyCode == Enum.KeyCode.RightShift then c.menuOpen = not c.menuOpen; MainMenu.Visible = c.menuOpen end end)
