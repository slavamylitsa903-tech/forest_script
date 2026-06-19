-- =====================================================
-- SWILL "GOD OF THE FOREST" v2.0
-- ДЛЯ ИГРЫ "99 НОЧЕЙ В ЛЕСУ"
-- КРАСИВОЕ МЕНЮ С КАТЕГОРИЯМИ
-- =====================================================

local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Humanoid = Char:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- =================== НАСТРОЙКИ =======================
local Settings = {
    FlySpeed = 50,
    WalkSpeed = 32,
    JumpPower = 70,
    AutoCollectRange = 100,
}

-- =================== СОСТОЯНИЯ ========================
local state = {
    fly = false,
    menuOpen = true,
    autoCollect = false,
    espEnabled = false,
    currentCategory = "🚀 Полёт",
}

-- =================== ГЛАВНОЕ МЕНЮ =======================
local function CreateMenu()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SwillForest"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = Player.PlayerGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 400, 0, 500)
    main.Position = UDim2.new(0.5, -200, 0.5, -250)
    main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    main.BorderSizePixel = 0
    main.Parent = screenGui
    Instance.new("UICorner").Size = UDim.new(0, 12)
    Instance.new("UICorner").Parent = main

    -- ========== ШАПКА ==========
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    header.BorderSizePixel = 0
    header.Parent = main
    Instance.new("UICorner").Size = UDim.new(0, 12)
    Instance.new("UICorner").Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0.05, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🌲 GOD OF THE FOREST"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    -- Кнопка закрыть
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -38, 0.5, -16)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    Instance.new("UICorner").Size = UDim.new(0, 8)
    Instance.new("UICorner").Parent = closeBtn

    -- ========== КАТЕГОРИИ (ВЕРХНИЕ ВКЛАДКИ) ==========
    local categories = {"🚀 Полёт", "🏃 Движение", "📦 Сбор", "👁️ ESP", "⚡ Настройки"}
    local categoryButtons = {}
    local categoryFrame = Instance.new("Frame")
    categoryFrame.Size = UDim2.new(1, -20, 0, 40)
    categoryFrame.Position = UDim2.new(0, 10, 0, 55)
    categoryFrame.BackgroundTransparency = 1
    categoryFrame.Parent = main

    for i, cat in ipairs(categories) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.2, -2, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.2, 0, 0, 0)
        btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(40, 180, 120) or Color3.fromRGB(30, 30, 40)
        btn.BorderSizePixel = 0
        btn.Text = cat
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = categoryFrame
        Instance.new("UICorner").Size = UDim.new(0, 6)
        Instance.new("UICorner").Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            state.currentCategory = cat
            for _, b in ipairs(categoryButtons) do
                b.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            end
            btn.BackgroundColor3 = Color3.fromRGB(40, 180, 120)
            updateContent(cat)
        end)
        table.insert(categoryButtons, btn)
    end

    -- ========== КОНТЕНТ ==========
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

    -- ========== ФУНКЦИЯ ОБНОВЛЕНИЯ КОНТЕНТА ==========
    local function updateContent(category)
        -- Очищаем
        for _, child in ipairs(contentList:GetChildren()) do child:Destroy() end
        
        local y = 0
        local function addButton(text, color, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.Position = UDim2.new(0, 0, 0, y)
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
            y = y + 45
            return btn
        end

        local function addSlider(text, min, max, default, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 55)
            container.Position = UDim2.new(0, 0, 0, y)
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
            slider.Position = UDim2.new(0, 0, 0, 28)
            slider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            slider.BorderSizePixel = 0
            slider.Parent = container
            Instance.new("UICorner").Size = UDim.new(0, 3)
            Instance.new("UICorner").Parent = slider

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(40, 180, 120)
            fill.BorderSizePixel = 0
            fill.Parent = slider
            Instance.new("UICorner").Size = UDim.new(0, 3)
            Instance.new("UICorner").Parent = fill

            local thumb = Instance.new("TextButton")
            thumb.Size = UDim2.new(0, 16, 0, 16)
            thumb.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
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
                    local value = math.round((min + pos * (max - min)) * 10) / 10
                    label.Text = text .. ": " .. value
                    fill.Size = UDim2.new(pos, 0, 1, 0)
                    thumb.Position = UDim2.new(pos, -8, 0.5, -8)
                    callback(value)
                end
            end)
            y = y + 60
        end

        local function addLabel(text)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 30)
            lbl.Position = UDim2.new(0, 0, 0, y)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = Color3.fromRGB(150, 150, 160)
            lbl.TextSize = 13
            lbl.Font = Enum.Font.Gotham
            lbl.TextXAlignment = Enum.TextXAlignment.Center
            lbl.Parent = contentList
            y = y + 35
        end

        -- ===== КОНТЕНТ ПО КАТЕГОРИЯМ =====
        if category == "🚀 Полёт" then
            addLabel("─── УПРАВЛЕНИЕ ПОЛЁТОМ ───")
            addButton("🔄 ВКЛ/ВЫКЛ ПОЛЁТ (F)", Color3.fromRGB(40, 120, 200), function()
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
            addLabel("WASD - Движение | Space - Вверх | Ctrl - Вниз")

        elseif category == "🏃 Движение" then
            addLabel("─── НАСТРОЙКИ ДВИЖЕНИЯ ───")
            addSlider("🏃 Скорость бега", 16, 100, Settings.WalkSpeed, function(v)
                Settings.WalkSpeed = v
                Humanoid.WalkSpeed = v
            end)
            addSlider("🦘 Сила прыжка", 30, 150, Settings.JumpPower, function(v)
                Settings.JumpPower = v
                Humanoid.JumpPower = v
            end)
            addButton("🏠 ТЕЛЕПОРТ НА БАЗУ", Color3.fromRGB(40, 200, 120), function()
                local base = nil
                for _, obj in ipairs(workspace:GetChildren()) do
                    local name = obj.Name:lower()
                    if name:find("base") or name:find("house") or name:find("дом") or name:find("camp") or name:find("лагер") then
                        base = obj; break
                    end
                end
                if base then
                    local pos = base:FindFirstChild("HumanoidRootPart") and base.HumanoidRootPart.CFrame or base.CFrame
                    Root.CFrame = pos + Vector3.new(0, 3, 0)
                else
                    Root.CFrame = CFrame.new(0, 10, 0)
                end
            end)

        elseif category == "📦 Сбор" then
            addLabel("─── СБОР ПРЕДМЕТОВ ───")
            addButton("📦 ПРИНЕСТИ ВСЕ ПРЕДМЕТЫ", Color3.fromRGB(200, 160, 40), function()
                local count = 0
                for _, item in ipairs(workspace:GetChildren()) do
                    if item:IsA("Tool") or item:IsA("Item") or (item:IsA("Model") and not item:FindFirstChild("Humanoid")) then
                        item.Parent = Player.Backpack
                        count = count + 1
                        wait(0.02)
                    end
                end
                print("[SWILL] Собрано предметов: " .. count)
            end)
            addButton("🌀 АВТОСБОР ПРЕДМЕТОВ", Color3.fromRGB(40, 200, 200), function()
                state.autoCollect = not state.autoCollect
                print("[SWILL] Автосбор " .. (state.autoCollect and "включён" or "выключён"))
            end)
            addSlider("📏 Радиус автосбора", 20, 200, Settings.AutoCollectRange, function(v)
                Settings.AutoCollectRange = v
            end)

        elseif category == "👁️ ESP" then
            addLabel("─── ВИЗУАЛЬНЫЕ ЭФФЕКТЫ ───")
            addButton("👁️ ВКЛ/ВЫКЛ ESP", Color3.fromRGB(180, 40, 200), function()
                state.espEnabled = not state.espEnabled
                if state.espEnabled then
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player ~= Player and player.Character then
                            local h = Instance.new("Highlight")
                            h.Parent = player.Character
                            h.FillColor = Color3.fromRGB(255, 50, 50)
                            h.OutlineColor = Color3.fromRGB(255, 255, 255)
                            h.FillTransparency = 0.3
                        end
                    end
                else
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player ~= Player and player.Character then
                            local h = player.Character:FindFirstChild("Highlight")
                            if h then h:Destroy() end
                        end
                    end
                end
            end)

        elseif category == "⚡ Настройки" then
            addLabel("─── СКРИПТ ───")
            addButton("🔄 ПЕРЕЗАПУСТИТЬ СКРИПТ", Color3.fromRGB(200, 150, 50), function()
                print("[SWILL] Перезапуск...")
                local gui = Player.PlayerGui:FindFirstChild("SwillForest")
                if gui then gui:Destroy() end
                wait(0.5)
                CreateMenu()
            end)
            addButton("❌ ЗАКРЫТЬ МЕНЮ", Color3.fromRGB(200, 50, 50), function()
                local gui = Player.PlayerGui:FindFirstChild("SwillForest")
                if gui then gui:Destroy() end
                state.menuOpen = false
            end)
            addLabel("🌲 SWILL GOD OF THE FOREST v2.0")
            addLabel("F - Полёт | RightShift - Меню")
        end

        -- Обновляем размер Canvas
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, y + 20)
    end

    -- ========== СОБЫТИЯ ==========
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        state.menuOpen = false
    end)

    -- Инициализация
    updateContent("🚀 Полёт")
    return screenGui
end

-- =================== ПОЛЁТ ==============================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
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
        state.menuOpen = not state.menuOpen
        if state.menuOpen then
            CreateMenu()
        else
            local gui = Player.PlayerGui:FindFirstChild("SwillForest")
            if gui then gui:Destroy() end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if state.fly then
        local camera = workspace.CurrentCamera
        local forward = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        local up = camera.CFrame.UpVector
        
        local move = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + forward * Settings.FlySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - forward * Settings.FlySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - right * Settings.FlySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + right * Settings.FlySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + up * Settings.FlySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - up * Settings.FlySpeed end
        
        Root.Velocity = move
    end
    
    if state.autoCollect then
        for _, item in ipairs(workspace:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Item") then
                if (item.Position - Root.Position).Magnitude < Settings.AutoCollectRange then
                    item.Parent = Player.Backpack
                end
            end
        end
    end
end)

-- =================== СТАРТ =============================
print("🌲 GOD OF THE FOREST v2.0 ACTIVATED!")
print("⚡ F - Вкл/Выкл полёт")
print("⚡ RightShift - Открыть/закрыть меню")

wait(0.5)
CreateMenu()
