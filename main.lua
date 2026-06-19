-- =====================================================
-- SWILL "GOD OF THE FOREST" v1.0
-- ДЛЯ ИГРЫ "99 НОЧЕЙ В ЛЕСУ"
-- =====================================================

local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Humanoid = Char:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
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
    menuOpen = false,
    autoCollect = false,
    espEnabled = false,
}

-- =================== GUI ===============================
local function CreateMenu()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SwillForest"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = Player.PlayerGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 340, 0, 460)
    main.Position = UDim2.new(0.5, -170, 0.5, -230)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    main.BorderSizePixel = 0
    main.Parent = screenGui
    Instance.new("UICorner").Parent = main

    -- ЗАГОЛОВОК
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    header.BorderSizePixel = 0
    header.Parent = main
    Instance.new("UICorner").Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "🌲 GOD OF THE FOREST"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -38, 0.5, -15)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    Instance.new("UICorner").Parent = closeBtn

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -65)
    scroll.Position = UDim2.new(0, 10, 0, 55)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 5
    scroll.Parent = main

    local function createButton(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.BackgroundColor3 = color
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = scroll
        Instance.new("UICorner").Parent = btn
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local function createSlider(text, min, max, default, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 55)
        container.BackgroundTransparency = 1
        container.Parent = scroll

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. default
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(1, 0, 0, 6)
        slider.Position = UDim2.new(0, 0, 0, 28)
        slider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        slider.BorderSizePixel = 0
        slider.Parent = container
        Instance.new("UICorner").Parent = slider

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(40, 180, 120)
        fill.BorderSizePixel = 0
        fill.Parent = slider
        Instance.new("UICorner").Parent = fill

        local thumb = Instance.new("TextButton")
        thumb.Size = UDim2.new(0, 18, 0, 18)
        thumb.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
        thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        thumb.BorderSizePixel = 0
        thumb.Text = ""
        thumb.Parent = container
        Instance.new("UICorner").Parent = thumb

        local dragging = false
        thumb.MouseButton1Down:Connect(function() dragging = true end)
        Mouse.Button1Up:Connect(function() dragging = false end)

        Mouse.Move:Connect(function()
            if dragging then
                local pos = math.clamp((Mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                local value = min + pos * (max - min)
                value = math.round(value * 10) / 10
                label.Text = text .. ": " .. value
                fill.Size = UDim2.new(pos, 0, 1, 0)
                thumb.Position = UDim2.new(pos, -9, 0.5, -9)
                callback(value)
            end
        end)
    end

    -- ========== КНОПКИ ==========
    createButton("🚀 ВКЛ/ВЫКЛ ПОЛЁТ (F)", Color3.fromRGB(40, 120, 200), function()
        state.fly = not state.fly
        if state.fly then
            Humanoid.PlatformStand = true
            Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        else
            Humanoid.PlatformStand = false
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)

    createButton("📦 ПРИНЕСТИ ВСЕ ПРЕДМЕТЫ", Color3.fromRGB(200, 160, 40), function()
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

    createButton("🏠 ТЕЛЕПОРТ НА БАЗУ", Color3.fromRGB(40, 200, 120), function()
        local base = nil
        for _, obj in ipairs(workspace:GetChildren()) do
            local name = obj.Name:lower()
            if name:find("base") or name:find("house") or name:find("дом") or name:find("camp") or name:find("лагер") then
                base = obj
                break
            end
        end
        if base and base:FindFirstChild("HumanoidRootPart") then
            Root.CFrame = base.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        elseif base then
            Root.CFrame = base.CFrame + Vector3.new(0, 3, 0)
        else
            Root.CFrame = CFrame.new(0, 10, 0)
        end
    end)

    createButton("👁️ ESP (ВСЕ ИГРОКИ)", Color3.fromRGB(180, 40, 200), function()
        state.espEnabled = not state.espEnabled
        if state.espEnabled then
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= Player and player.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.3
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

    createButton("🌀 АВТОСБОР ПРЕДМЕТОВ", Color3.fromRGB(40, 200, 200), function()
        state.autoCollect = not state.autoCollect
        if state.autoCollect then
            print("[SWILL] Автосбор включён")
        else
            print("[SWILL] Автосбор выключён")
        end
    end)

    -- ========== СЛАЙДЕРЫ ==========
    createSlider("🚀 Скорость полёта", 10, 200, Settings.FlySpeed, function(value)
        Settings.FlySpeed = value
    end)

    createSlider("🏃 Скорость бега", 16, 100, Settings.WalkSpeed, function(value)
        Settings.WalkSpeed = value
        Humanoid.WalkSpeed = value
    end)

    createSlider("🦘 Сила прыжка", 30, 150, Settings.JumpPower, function(value)
        Settings.JumpPower = value
        Humanoid.JumpPower = value
    end)

    -- ========== ЗАКРЫТИЕ ==========
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        state.menuOpen = false
    end)

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
print("🌲 GOD OF THE FOREST ACTIVATED!")
print("⚡ F - Вкл/Выкл полёт")
print("⚡ RightShift - Открыть меню")
print("⚡ Все настройки в меню!")

-- Открываем меню автоматически
wait(0.5)
CreateMenu()
