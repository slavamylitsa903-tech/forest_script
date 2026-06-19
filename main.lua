-- ============================================================
-- SWILL FOREST SCRIPT v10 (РАБОЧИЙ С ВКЛАДКАМИ)
-- ДЛЯ "99 НОЧЕЙ В ЛЕСУ"
-- ============================================================

local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Humanoid = Char:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ===== НАСТРОЙКИ =====
local flySpeed = 60
local walkSpeed = 32
local jumpPower = 70
local collectRange = 150
local fly = false
local autoCollect = false

-- ===== УДАЛЯЕМ СТАРОЕ =====
local old = Player.PlayerGui:FindFirstChild("ForestGUI")
if old then old:Destroy() end

-- ===== СОЗДАЁМ GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "ForestGUI"
gui.Parent = Player.PlayerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 380, 0, 460)
main.Position = UDim2.new(0.5, -190, 0.5, -230)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
main.BorderSizePixel = 0
main.Parent = gui
local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 12)
mc.Parent = main

-- ===== ШАПКА =====
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(30, 40, 35)
header.BorderSizePixel = 0
header.Parent = main
local hc = Instance.new("UICorner")
hc.CornerRadius = UDim.new(0, 12)
hc.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌲 FOREST SCRIPT v10"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0.5, -15)
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.BorderSizePixel = 0
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextSize = 16
close.Font = Enum.Font.GothamBold
close.Parent = header
local cc = Instance.new("UICorner")
cc.CornerRadius = UDim.new(0, 8)
cc.Parent = close

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ===== ВКЛАДКИ =====
local tabNames = {"Игрок", "Мир", "Полёт", "Сбор", "Настр"}
local tabBtns = {}
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 36)
tabFrame.Position = UDim2.new(0, 10, 0, 50)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = main

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, -2, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.2, 0, 0, 0)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(40, 180, 120) or Color3.fromRGB(35, 35, 45)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = tabFrame
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn
    tabBtns[i] = btn
end

-- ===== КОНТЕНТ =====
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -110)
scroll.Position = UDim2.new(0, 10, 0, 92)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.Parent = main

local list = Instance.new("Frame")
list.Size = UDim2.new(1, 0, 0, 0)
list.BackgroundTransparency = 1
list.Parent = scroll
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local y = 0

local function addBtn(text, color, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = list
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn
    btn.MouseButton1Click:Connect(cb)
    y = y + 41
    scroll.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

local function addSlider(text, min, max, def, cb)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.Position = UDim2.new(0, 0, 0, y)
    container.BackgroundTransparency = 1
    container.Parent = list

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. def
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 6)
    slider.Position = UDim2.new(0, 0, 0, 24)
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    slider.BorderSizePixel = 0
    slider.Parent = container
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 3)
    sc.Parent = slider

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(40, 180, 120)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 3)
    fc.Parent = fill

    local thumb = Instance.new("TextButton")
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.Position = UDim2.new((def-min)/(max-min), -8, 0.5, -8)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    thumb.Text = ""
    thumb.Parent = container
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 8)
    tc.Parent = thumb

    local drag = false
    thumb.MouseButton1Down:Connect(function() drag = true end)
    Mouse.Button1Up:Connect(function() drag = false end)
    Mouse.Move:Connect(function()
        if drag then
            local pos = math.clamp((Mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local val = math.round((min + pos * (max - min)) * 10) / 10
            label.Text = text .. ": " .. val
            fill.Size = UDim2.new(pos, 0, 1, 0)
            thumb.Position = UDim2.new(pos, -8, 0.5, -8)
            cb(val)
        end
    end)

    y = y + 55
    scroll.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

local function addLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 28)
    lbl.Position = UDim2.new(0, 0, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(150, 150, 160)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.Parent = list
    y = y + 32
    scroll.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

local function clear()
    for _, c in ipairs(list:GetChildren()) do
        c:Destroy()
    end
    y = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
end

-- ===== КОНТЕНТ ВКЛАДОК =====
local function showTab(idx)
    clear()
    if idx == 1 then
        addLabel("─── ИГРОК ───")
        addBtn("💀 БЕССМЕРТИЕ", Color3.fromRGB(200, 50, 50), function()
            Humanoid.Health = Humanoid.MaxHealth
            Humanoid.BreakJointsOnDeath = false
        end)
        addBtn("💚 ВОССТАНОВИТЬ ЗДОРОВЬЕ", Color3.fromRGB(40, 200, 80), function()
            Humanoid.Health = Humanoid.MaxHealth
        end)
        addBtn("🔫 ДУБЛЬ ИНВЕНТАРЯ", Color3.fromRGB(200, 100, 50), function()
            for _, it in ipairs(Player.Backpack:GetChildren()) do
                if it:IsA("Tool") then
                    it:Clone().Parent = Player.Backpack
                    wait(0.05)
                end
            end
        end)
        addBtn("👁️ ESP", Color3.fromRGB(180, 40, 200), function()
            for _, pl in ipairs(game.Players:GetPlayers()) do
                if pl ~= Player and pl.Character then
                    local h = pl.Character:FindFirstChild("Highlight")
                    if h then h:Destroy() else
                        local nh = Instance.new("Highlight")
                        nh.Parent = pl.Character
                        nh.FillColor = Color3.fromRGB(255, 50, 50)
                    end
                end
            end
        end)
    elseif idx == 2 then
        addLabel("─── МИР ───")
        addBtn("📦 ТП ПРЕДМЕТОВ К БАЗЕ", Color3.fromRGB(200, 160, 40), function()
            local count = 0
            local base = nil
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj.Name:lower():find("base") or obj.Name:lower():find("camp") or obj.Name:lower():find("fire") then
                    base = obj
                    break
                end
            end
            if not base then base = Root end
            local pos = base:IsA("BasePart") and base.Position or base:FindFirstChild("HumanoidRootPart").Position
            for _, it in ipairs(workspace:GetChildren()) do
                if it:IsA("Tool") or it:IsA("Item") or (it:IsA("Model") and not it:FindFirstChild("Humanoid")) then
                    if it:FindFirstChild("Handle") then
                        it.Handle.Position = pos + Vector3.new(math.random(-2,2), 2, math.random(-2,2))
                        count = count + 1
                    elseif it:IsA("BasePart") then
                        it.Position = pos + Vector3.new(math.random(-2,2), 2, math.random(-2,2))
                        count = count + 1
                    end
                    wait(0.01)
                end
            end
        end)
        addBtn("🏠 ТП НА БАЗУ", Color3.fromRGB(40, 200, 120), function()
            local base = nil
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj.Name:lower():find("base") or obj.Name:lower():find("camp") or obj.Name:lower():find("house") or obj.Name:lower():find("костёр") then
                    base = obj
                    break
                end
            end
            if base then
                local pos = base:FindFirstChild("HumanoidRootPart") and base.HumanoidRootPart.CFrame or base.CFrame
                Root.CFrame = pos + Vector3.new(0, 3, 0)
            else
                Root.CFrame = CFrame.new(0, 10, 0)
            end
        end)
        addBtn("🌞 ДЕНЬ/НОЧЬ", Color3.fromRGB(200, 180, 40), function()
            local l = game:GetService("Lighting")
            l.ClockTime = (l.ClockTime < 12) and 22 or 8
        end)
    elseif idx == 3 then
        addLabel("─── ПОЛЁТ ───")
        addBtn("🚀 ПОЛЁТ (G)", Color3.fromRGB(40, 120, 200), function()
            fly = not fly
            if fly then
                Humanoid.PlatformStand = true
                Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
            else
                Humanoid.PlatformStand = false
                Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
        addSlider("🚀 Скорость", 10, 200, flySpeed, function(v)
            flySpeed = v
        end)
        addBtn("⬆️ ВВЕРХ", Color3.fromRGB(40, 120, 200), function()
            Root.Position = Root.Position + Vector3.new(0, 20, 0)
        end)
        addBtn("⬇️ ВНИЗ", Color3.fromRGB(200, 120, 40), function()
            Root.Position = Root.Position - Vector3.new(0, 20, 0)
        end)
    elseif idx == 4 then
        addLabel("─── СБОР ───")
        addBtn("🌀 АВТОСБОР", Color3.fromRGB(40, 200, 200), function()
            autoCollect = not autoCollect
        end)
        addSlider("📏 Радиус", 20, 300, collectRange, function(v)
            collectRange = v
        end)
        addBtn("📦 СОБРАТЬ ВСЁ", Color3.fromRGB(200, 160, 40), function()
            local c = 0
            for _, it in ipairs(workspace:GetChildren()) do
                if it:IsA("Tool") or it:IsA("Item") then
                    if (it.Position - Root.Position).Magnitude < 100 then
                        it.Parent = Player.Backpack
                        c = c + 1
                        wait(0.01)
                    end
                end
            end
        end)
    elseif idx == 5 then
        addLabel("─── НАСТРОЙКИ ───")
        addBtn("🔄 ПЕРЕЗАПУСТИТЬ", Color3.fromRGB(100, 100, 150), function()
            gui:Destroy()
            wait(0.2)
            CreateMenu()
        end)
        addBtn("❌ ЗАКРЫТЬ", Color3.fromRGB(200, 50, 50), function()
            gui:Destroy()
        end)
        addSlider("🏃 Скорость бега", 16, 100, walkSpeed, function(v)
            walkSpeed = v
            Humanoid.WalkSpeed = v
        end)
        addSlider("🦘 Сила прыжка", 30, 150, jumpPower, function(v)
            jumpPower = v
            Humanoid.JumpPower = v
        end)
    end
end

-- ===== СОБЫТИЯ ВКЛАДОК =====
for i, btn in ipairs(tabBtns) do
    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabBtns) do
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        end
        btn.BackgroundColor3 = Color3.fromRGB(40, 180, 120)
        showTab(i)
    end)
end

showTab(1)

-- ===== УПРАВЛЕНИЕ =====
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.G then
        fly = not fly
        if fly then
            Humanoid.PlatformStand = true
            Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        else
            Humanoid.PlatformStand = false
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if gui.Parent then
            gui:Destroy()
        else
            CreateMenu()
        end
    end
    if input.KeyCode == Enum.KeyCode.RightControl then
        local count = 0
        local base = nil
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name:lower():find("base") or obj.Name:lower():find("camp") or obj.Name:lower():find("fire") then
                base = obj
                break
            end
        end
        if not base then base = Root end
        local pos = base:IsA("BasePart") and base.Position or base:FindFirstChild("HumanoidRootPart").Position
        for _, it in ipairs(workspace:GetChildren()) do
            if it:IsA("Tool") or it:IsA("Item") or (it:IsA("Model") and not it:FindFirstChild("Humanoid")) then
                if it:FindFirstChild("Handle") then
                    it.Handle.Position = pos + Vector3.new(math.random(-2,2), 2, math.random(-2,2))
                    count = count + 1
                elseif it:IsA("BasePart") then
                    it.Position = pos + Vector3.new(math.random(-2,2), 2, math.random(-2,2))
                    count = count + 1
                end
                wait(0.01)
            end
        end
    end
end)

-- ===== ПОЛЁТ =====
RunService.Heartbeat:Connect(function()
    if fly then
        local cam = workspace.CurrentCamera
        local fwd = cam.CFrame.LookVector
        local rgt = cam.CFrame.RightVector
        local up = cam.CFrame.UpVector
        local move = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + fwd * flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - fwd * flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - rgt * flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + rgt * flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + up * flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - up * flySpeed end
        Root.Velocity = Root.Velocity:Lerp(move, 0.3)
    end
    if autoCollect then
        for _, it in ipairs(workspace:GetChildren()) do
            if it:IsA("Tool") or it:IsA("Item") then
                if (it.Position - Root.Position).Magnitude < collectRange then
                    it.Parent = Player.Backpack
                end
            end
        end
    end
end)

print("🌲 FOREST SCRIPT v10 LOADED!")
print("G - Fly | RightShift - Menu | RightCtrl - Teleport items")
