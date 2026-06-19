-- ============================================================
-- SWILL FOREST SCRIPT v9.0 (С ВКЛАДКАМИ)
-- ДЛЯ "99 НОЧЕЙ В ЛЕСУ"
-- ============================================================

local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Humanoid = Char:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- =================== НАСТРОЙКИ ===========================
local Settings = {
    FlySpeed = 60,
    WalkSpeed = 32,
    JumpPower = 70,
    CollectRange = 150,
}

local state = {
    fly = false,
    autoCollect = false,
    espEnabled = false,
    menuOpen = true,
}

-- =================== УДАЛЯЕМ СТАРОЕ МЕНЮ ==================
local oldGui = Player.PlayerGui:FindFirstChild("ForestGUI")
if oldGui then oldGui:Destroy() end

-- =================== ГЛАВНОЕ МЕНЮ =========================
local function CreateMenu()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ForestGUI"
    gui.ResetOnSpawn = false
    gui.Parent = Player.PlayerGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 400, 0, 500)
    main.Position = UDim2.new(0.5, -200, 0.5, -250)
    main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    main.BorderSizePixel = 0
    main.Parent = gui
    Instance.new("UICorner").Size = UDim.new(0, 14)
    Instance.new("UICorner").Parent = main

    -- ===== ШАПКА =====
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Color3.fromRGB(25, 35, 30)
    header.BorderSizePixel = 0
    header.Parent = main
    Instance.new("UICorner").Size = UDim.new(0, 14)
    Instance.new("UICorner").Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0.05, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🌲 FOREST SCRIPT v9"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 32, 0, 32)
    close.Position = UDim2.new(1, -38, 0.5, -16)
    close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    close.BorderSizePixel = 0
    close.Text = "✕"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.TextSize = 16
    close.Font = Enum.Font.GothamBold
    close.Parent = header
    Instance.new("UICorner").Size = UDim.new(0, 8)
    Instance.new("UICorner").Parent = close

    close.MouseButton1Click:Connect(function()
        gui:Destroy()
        state.menuOpen = false
    end)

    -- ===== ВКЛАДКИ =====
    local tabs = {"👤 Игрок", "🌍 Мир", "🚀 Полёт", "📦 Сбор", "⚙️ Настройки"}
    local tabButtons = {}
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, -20, 0, 40)
    tabFrame.Position = UDim2.new(0, 10, 0, 55)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = main

    for i, tab in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.2, -2, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.2, 0, 0, 0)
        btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(40, 180, 120) or Color3.fromRGB(30, 30, 40)
        btn.BorderSizePixel = 0
        btn.Text = tab
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = tabFrame
        Instance.new("UICorner").Size = UDim.new(0, 6)
        Instance.new("UICorner").Parent = btn
        tabButtons[i] = btn
    end

    -- ===== КОНТЕНТ =====
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -20, 1, -115)
    contentFrame.Position = UDim2.new(0, 10, 0, 100)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 5
    contentFrame.Parent = main

    local contentList = Instance.new("Frame")
    contentList.Size = UDim2.new(1, 0, 0, 0)
    contentList.BackgroundTransparency = 1
    contentList.Parent = contentFrame
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    local function clearContent()
        for _, child in ipairs(contentList:GetChildren()) do
            child:Destroy()
        end
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    end

    local function addBtn(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.Position = UDim2.new(0, 0, 0, contentFrame.CanvasSize.Y.Offset)
        btn.BackgroundColor3 = color
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = contentList
        Instance.new("UICorner").Size = UDim.new(0, 8)
        Instance.new("UICorner").Parent = btn
        btn.MouseButton1Click:Connect(callback)
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentFrame.CanvasSize.Y.Offset + 43)
        return btn
    end

    local function addSlider(text, min, max, default, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 55)
        container.Position = UDim2.new(0, 0, 0, contentFrame.CanvasSize.Y.Offset)
        container.BackgroundTransparency = 1
        container.Parent = contentList

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. default
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(1, 0, 0, 6)
        slider.Position = UDim2.new(0, 0, 0, 26)
        slider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        slider.BorderSizePixel = 0
        slider.Parent = container
        Instance.new("UICorner").Size = UDim.new(0, 3)
        Instance.new("UICorner").Parent = slider

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(40, 180, 120)
        fill.BorderSizePixel = 0
        fill.Parent = slider
        Instance.new("UICorner").Size = UDim.new(0, 3)
        Instance.new("UICorner").Parent = fill

        local thumb = Instance.new("TextButton")
        thumb.Size = UDim2.new(0, 16, 0, 16)
        thumb.Position = UDim2.new((default-min)/(max-min), -8, 0.5, -8)
        thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        thumb.BorderSizePixel = 0
        thumb.Text = ""
        thumb.Parent = container
        Instance.new("UICorner").Size = UDim.new(0, 8)
        Instance.new("UICorner").Parent = thumb

        local dragging = false
        thumb.MouseButton1Down:Connect(function() dragging = true end)
        Mouse.Button1Up:Connect(function() dragging = false end)

        Mouse.Move:Connect(function()
            if dragging then
                local pos = math.clamp((Mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                local val = math.round((min + pos * (max - min)) * 10) / 10
                label.Text = text .. ": " .. val
                fill.Size = UDim2.new(pos, 0, 1, 0)
                thumb.Position = UDim2.new(pos, -8, 0.5, -8)
                callback(val)
            end
        end)

        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentFrame.CanvasSize.Y.Offset + 60)
    end

    local function addLabel(text)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 30)
        lbl.Position = UDim2.new(0, 0, 0, contentFrame.CanvasSize.Y.Offset)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(150, 150, 160)
        lbl.TextSize = 13
        lbl.Font = Enum.Font.Gotham
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.Parent = contentList
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentFrame.CanvasSize.Y.Offset + 35)
    end

    -- ===== КОНТЕНТ ВКЛАДОК =====
    local function showTab(tabIndex)
        clearContent()
        if tabIndex == 1 then -- Игрок
            addLabel("─── ИГРОК ───")
            addBtn("💀 БЕССМЕРТИЕ", Color3.fromRGB(200, 50, 50), function()
                Humanoid.Health = Humanoid.MaxHealth
                Humanoid.BreakJointsOnDeath = false
                print("[SWILL] Бессмертие включено")
            end)
            addBtn("💚 ВОССТАНОВИТЬ ЗДОРОВЬЕ", Color3.fromRGB(40, 200, 80), function()
                Humanoid.Health = Humanoid.MaxHealth
                print("[SWILL] Здоровье восстановлено")
            end)
            addBtn("🔫 ДУБЛЬ ИНВЕНТАРЯ", Color3.fromRGB(200, 100, 50), function()
                for _, item in ipairs(Player.Backpack:GetChildren()) do
                    if item:IsA("Tool") then
                        item:Clone().Parent = Player.Backpack
                        wait(0.05)
                    end
                end
                print("[SWILL] Инвентарь удвоен")
            end)
            addBtn("👁️ ESP (ИГРОКИ)", Color3.fromRGB(180, 40, 200), function()
                state.espEnabled = not state.espEnabled
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player ~= Player and player.Character then
                        local h = player.Character:FindFirstChild("Highlight")
                        if h then h:Destroy() else
                            local nh = Instance.new("Highlight")
                            nh.Parent = player.Character
                            nh.FillColor = Color3.fromRGB(255, 50, 50)
                            nh.OutlineColor = Color3.fromRGB(255, 255, 255)
                        end
                    end
                end
            end)
            addBtn("🔄 РЕСПАВН", Color3.fromRGB(200, 150, 50), function()
                Player.Character:BreakJoints()
                wait(1)
                print("[SWILL] Респавн")
            end)

        elseif tabIndex == 2 then -- Мир
            addLabel("─── МИР ───")
            addBtn("📦 ТЕЛЕПОРТ ПРЕДМЕТОВ К БАЗЕ", Color3.fromRGB(200, 160, 40), function()
                local count = 0
                local base = nil
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj.Name:lower():find("base") or obj.Name:lower():find("camp") or obj.Name:lower():find("fire") or obj.Name:lower():find("костёр") then
                        base = obj
                        break
                    end
                end
                if not base then base = Root end
                local pos = base:IsA("BasePart") and base.Position or base:FindFirstChild("HumanoidRootPart").Position
                for _, item in ipairs(workspace:GetChildren()) do
                    if item:IsA("Tool") or item:IsA("Item") or (item:IsA("Model") and not item:FindFirstChild("Humanoid")) then
                        if item:FindFirstChild("Handle") then
                            item.Handle.Position = pos + Vector3.new(math.random(-2,2), 2, math.random(-2,2))
                            count = count + 1
                        elseif item:IsA("BasePart") then
                            item.Position = pos + Vector3.new(math.random(-2,2), 2, math.random(-2,2))
                            count = count + 1
                        end
                        wait(0.01)
                    end
                end
                print("[SWILL] Телепортировано: " .. count)
            end)
            addBtn("🏠 ТЕЛЕПОРТ НА БАЗУ", Color3.fromRGB(40, 200, 120), function()
                local base = nil
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj.Name:lower():find("base") or obj.Name:lower():find("camp") or obj.Name:lower():find("house") or obj.Name:lower():find("костёр") then
                        base = obj
                        break
                    end
                end
                if base then
                    local pos = base:FindFirstChild("HumanoidRootPart") and base.HumanoidRootPart.CFrame or base.CFrame
                    Root.CFrame = pos + Vector3.new(0,3,0)
                else
                    Root.CFrame = CFrame.new(0,10,0)
                end
            end)
            addBtn("🌞 ДЕНЬ/НОЧЬ", Color3.fromRGB(200, 180, 40), function()
                local lighting = game:GetService("Lighting")
                if lighting.ClockTime < 12 then
                    lighting.ClockTime = 22
                else
                    lighting.ClockTime = 8
                end
            end)
            addBtn("⏩ УСКОРИТЬ ВРЕМЯ", Color3.fromRGB(100, 100, 200), function()
                game:GetService("Lighting").ClockTime = game:GetService("Lighting").ClockTime + 2
            end)

        elseif tabIndex == 3 then -- Полёт
            addLabel("─── ПОЛЁТ ───")
            addBtn("🚀 ПОЛЁТ (G)", Color3.fromRGB(40, 120, 200), function()
                state.fly = not state.fly
                if state.fly then
                    Humanoid.PlatformStand = true
                    Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
                else
                    Humanoid.PlatformStand = false
                    Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end)
            addSlider("🚀 Скорость полёта", 10, 200, Settings.FlySpeed, function(v)
                Settings.FlySpeed = v
            end)
            addBtn("⬆️ ВВЕРХ", Color3.fromRGB(40, 120, 200), function()
                Root.Position = Root.Position + Vector3.new(0, 20, 0)
            end)
            addBtn("⬇️ ВНИЗ", Color3.fromRGB(200, 120, 40), function()
                Root.Position = Root.Position - Vector3.new(0, 20, 0)
            end)

        elseif tabIndex == 4 then -- Сбор
            addLabel("─── СБОР ───")
            addBtn("🌀 АВТОСБОР (ТП к вам)", Color3.fromRGB(40, 200, 200), function()
                state.autoCollect = not state.autoCollect
                print("[SWILL] Автосбор " .. (state.autoCollect and "ON" or "OFF"))
            end)
            addSlider("📏 Радиус автосбора", 20, 300, Settings.CollectRange, function(v)
                Settings.CollectRange = v
            end)
            addBtn("📦 Собрать всё сейчас", Color3.fromRGB(200, 160, 40), function()
                local count = 0
                for _, item in ipairs(workspace:GetChildren()) do
                    if item:IsA("Tool") or item:IsA("Item") then
                        if (item.Position - Root.Position).Magnitude < 100 then
                            item.Parent = Player.Backpack
                            count = count + 1
                            wait(0.01)
                        end
                    end
                end
                print("[SWILL] Собрано: " .. count)
            end)

        elseif tabIndex == 5 then -- Настройки
            addLabel("─── НАСТРОЙКИ ───")
            addBtn("🔄 ПЕРЕЗАПУСТИТЬ МЕНЮ", Color3.fromRGB(100, 100, 150), function()
                gui:Destroy()
                wait(0.2)
                CreateMenu()
            end)
            addBtn("❌ ЗАКРЫТЬ МЕНЮ", Color3.fromRGB(200, 50, 50), function()
                gui:Destroy()
                state.menuOpen = false
            end)
            addBtn("📋 ИНФО", Color3.fromRGB(50, 150, 200), function()
                print("🌲 FOREST SCRIPT v9.0")
                print("G - Fly | RightShift - Menu")
                print("RightCtrl - Teleport items to base")
            end)
            addSlider("🏃 Скорость бега", 16, 100, Settings.WalkSpeed, function(v)
                Settings.WalkSpeed = v
                Humanoid.WalkSpeed = v
            end)
            addSlider("🦘 Сила прыжка", 30, 150, Settings.JumpPower, function(v)
                Settings.JumpPower = v
                Humanoid.JumpPower = v
            end)
        end
    end

    -- ===== СОБЫТИЯ ВКЛАДОК =====
    for i, btn in ipairs(tabButtons) do
        btn.MouseButton1Click:Connect(function()
            for _, b in ipairs(tabButtons) do
                b.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            end
            btn.BackgroundColor3 = Color3.fromRGB(40, 180, 120)
            showTab(i)
        end)
    end

    showTab(1)
    return gui
end

-- =================== УПРАВЛЕНИЕ =========================
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.G then
        state.fly = not state.fly
        if state.fly then
            Humanoid.PlatformStand = true
            Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        else
            Humanoid.PlatformStand = false
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
    if input.KeyCode == Enum.KeyCode.RightShift then
        local g = Player.PlayerGui:FindFirstChild("ForestGUI")
        if g then g:Destroy() else CreateMenu() end
    end
    if input.KeyCode == Enum.KeyCode.RightControl then
        local count = 0
        local base = nil
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name:lower():find("base") or obj.Name:lower():find("camp") or obj.Name:lower():find("fire") or obj.Name:lower():find("костёр") then
                base = obj
                break
            end
        end
        if not base then base = Root end
        local pos = base:IsA("BasePart") and base.Position or base:FindFirstChild("HumanoidRootPart").Position
        for _, item in ipairs(workspace:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Item") or (item:IsA("Model") and not item:FindFirstChild("Humanoid")) then
                if item:FindFirstChild("Handle") then
                    item.Handle.Position = pos + Vector3.new(math.random(-2,2), 2, math.random(-2,2))
                    count = count + 1
                elseif item:IsA("BasePart") then
                    item.Position = pos + Vector3.new(math.random(-2,2), 2, math.random(-2,2))
                    count = count + 1
                end
                wait(0.01)
            end
        end
        print("[SWILL] Телепортировано: " .. count)
    end
end)

-- =================== ПОЛЁТ ==============================
RunService.Heartbeat:Connect(function()
    if state.fly then
        local cam = workspace.CurrentCamera
        local fwd = cam.CFrame.LookVector
        local rgt = cam.CFrame.RightVector
        local up = cam.CFrame.UpVector
        local move = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + fwd * Settings.FlySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - fwd * Settings.FlySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - rgt * Settings.FlySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + rgt * Settings.FlySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + up * Settings.FlySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - up * Settings.FlySpeed end
        Root.Velocity = Root.Velocity:Lerp(move, 0.3)
    end
    if state.autoCollect then
        for _, item in ipairs(workspace:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Item") then
                if (item.Position - Root.Position).Magnitude < Settings.CollectRange then
                    item.Parent = Player.Backpack
                end
            end
        end
    end
end)

-- =================== ЗАПУСК =============================
print("🌲 FOREST SCRIPT v9.0 LOADED!")
print("G - Fly | RightShift - Menu | RightCtrl - Teleport items")
CreateMenu()
