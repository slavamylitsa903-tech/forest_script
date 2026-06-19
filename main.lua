-- =====================================================
-- SWILL FOREST SCRIPT v6.0 (РАБОЧИЙ)
-- ДЛЯ "99 НОЧЕЙ В ЛЕСУ"
-- =====================================================

local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Humanoid = Char:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- =================== НАСТРОЙКИ =======================
local Settings = {
    FlySpeed = 60,
    WalkSpeed = 32,
    JumpPower = 70,
    CollectRange = 150,
}

-- =================== СОСТОЯНИЯ ========================
local state = {
    fly = false,
    menuOpen = true,
    autoCollect = false,
    espEnabled = false,
}

-- =================== МЕНЮ ==============================
local function CreateMenu()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ForestGUI"
    gui.ResetOnSpawn = false
    gui.Parent = Player.PlayerGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 340, 0, 420)
    main.Position = UDim2.new(0.5, -170, 0.5, -210)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    main.BorderSizePixel = 0
    main.Parent = gui
    Instance.new("UICorner").Size = UDim.new(0, 12)
    Instance.new("UICorner").Parent = main

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    header.BorderSizePixel = 0
    header.Parent = main
    Instance.new("UICorner").Size = UDim.new(0, 12)
    Instance.new("UICorner").Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.8, 0, 1, 0)
    title.Position = UDim2.new(0.05, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🌲 FOREST SCRIPT v6"
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
    Instance.new("UICorner").Size = UDim.new(0, 8)
    Instance.new("UICorner").Parent = close

    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -55)
    scroll.Position = UDim2.new(0, 10, 0, 45)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.Parent = main

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.BackgroundTransparency = 1
    list.Parent = scroll
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

    local y = 0

    local function addBtn(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.Position = UDim2.new(0, 0, 0, y)
        btn.BackgroundColor3 = color
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = list
        Instance.new("UICorner").Size = UDim.new(0, 8)
        Instance.new("UICorner").Parent = btn
        btn.MouseButton1Click:Connect(callback)
        y = y + 43
        scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20)
        return btn
    end

    local function addSlider(text, min, max, default, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 55)
        container.Position = UDim2.new(0, 0, 0, y)
        container.BackgroundTransparency = 1
        container.Parent = list

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
        thumb.MouseButton1Down:Connect(function()
            dragging = true
        end)
        Mouse.Button1Up:Connect(function()
            dragging = false
        end)

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

        y = y + 60
        scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20)
    end

    -- ===== КНОПКИ =====
    addBtn("🚀 ПОЛЁТ (F)", Color3.fromRGB(40, 120, 200), function()
        state.fly = not state.fly
        if state.fly then
            Humanoid.PlatformStand = true
            Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        else
            Humanoid.PlatformStand = false
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)

    addBtn("📦 ПРИНЕСТИ ВСЁ К БАЗЕ", Color3.fromRGB(200, 160, 40), function()
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
                    item.Handle.Position = pos + Vector3.new(math.random(-2, 2), 2, math.random(-2, 2))
                elseif item:IsA("BasePart") then
                    item.Position = pos + Vector3.new(math.random(-2, 2), 2, math.random(-2, 2))
                end
                count = count + 1
                wait(0.01)
            end
        end
        print("[SWILL] Собрано: " .. count)
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

    addBtn("🌀 АВТОСБОР", Color3.fromRGB(40, 200, 200), function()
        state.autoCollect = not state.autoCollect
        print("[SWILL] Автосбор " .. (state.autoCollect and "ON" or "OFF"))
    end)

    addBtn("👁️ ESP", Color3.fromRGB(180, 40, 200), function()
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

    addBtn("💀 БЕССМЕРТИЕ", Color3.fromRGB(200, 50, 50), function()
        Humanoid.Health = Humanoid.MaxHealth
        Humanoid.BreakJointsOnDeath = false
        print("[SWILL] Бессмертие включено")
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

    -- ===== СЛАЙДЕРЫ =====
    addSlider("🚀 Скорость полёта", 10, 200, Settings.FlySpeed, function(v)
        Settings.FlySpeed = v
    end)

    addSlider("🏃 Скорость бега", 16, 100, Settings.WalkSpeed, function(v)
        Settings.WalkSpeed = v
        Humanoid.WalkSpeed = v
    end)

    addSlider("🦘 Сила прыжка", 30, 150, Settings.JumpPower, function(v)
        Settings.JumpPower = v
        Humanoid.JumpPower = v
    end)

    addSlider("📏 Радиус автосбора", 20, 300, Settings.CollectRange, function(v)
        Settings.CollectRange = v
    end)

    return gui
end

-- ===== УПРАВЛЕНИЕ =====
UIS.InputBegan:Connect(function(input)
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
        local g = Player.PlayerGui:FindFirstChild("ForestGUI")
        if g then
            g:Destroy()
        else
            CreateMenu()
        end
    end
end)

-- ===== ПОЛЁТ (ПЛАВНЫЙ) =====
RunService.Heartbeat:Connect(function()
    if state.fly then
        local cam = workspace.CurrentCamera
        local fwd = cam.CFrame.LookVector
        local rgt = cam.CFrame.RightVector
        local up = cam.CFrame.UpVector
        local move = Vector3.new(0, 0, 0)
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

-- ===== ЗАПУСК =====
print("🌲 FOREST SCRIPT v6.0 LOADED!")
print("F - Fly | RightShift - Menu")
CreateMenu()
