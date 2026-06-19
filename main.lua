-- =====================================================
-- SWILL FOREST SCRIPT v7.0 (ПРЯМОЙ ЗАПУСК)
-- ДЛЯ "99 НОЧЕЙ В ЛЕСУ"
-- =====================================================

local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Humanoid = Char:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- НАСТРОЙКИ
local flySpeed = 60
local walkSpeed = 32
local jumpPower = 70
local collectRange = 150
local fly = false
local autoCollect = false

-- УДАЛЯЕМ СТАРОЕ МЕНЮ ЕСЛИ ЕСТЬ
local oldGui = Player.PlayerGui:FindFirstChild("ForestGUI")
if oldGui then oldGui:Destroy() end

-- =================== МЕНЮ ==============================
local function CreateMenu()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ForestGUI"
    gui.Parent = Player.PlayerGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 350, 0, 480)
    main.Position = UDim2.new(0.5, -175, 0.5, -240)
    main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    main.BorderSizePixel = 0
    main.Parent = gui
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = main

    -- ШАПКА
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundColor3 = Color3.fromRGB(25, 35, 30)
    header.BorderSizePixel = 0
    header.Parent = main
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0.05, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🌲 FOREST SCRIPT v7"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    -- КНОПКА ЗАКРЫТЬ
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -35, 0.5, -15)
    close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    close.BorderSizePixel = 0
    close.Text = "✕"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.TextSize = 16
    close.Font = Enum.Font.GothamBold
    close.Parent = header
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = close

    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- СКРОЛЛ
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -60)
    scroll.Position = UDim2.new(0, 10, 0, 55)
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
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
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
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 3)
        sliderCorner.Parent = slider

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(40, 180, 120)
        fill.BorderSizePixel = 0
        fill.Parent = slider
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 3)
        fillCorner.Parent = fill

        local thumb = Instance.new("TextButton")
        thumb.Size = UDim2.new(0, 16, 0, 16)
        thumb.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
        thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        thumb.BorderSizePixel = 0
        thumb.Text = ""
        thumb.Parent = container
        local thumbCorner = Instance.new("UICorner")
        thumbCorner.CornerRadius = UDim.new(0, 8)
        thumbCorner.Parent = thumb

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
    addBtn("🚀 ВКЛ/ВЫКЛ ПОЛЁТ (F)", Color3.fromRGB(40, 120, 200), function()
        fly = not fly
        if fly then
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
            local name = obj.Name:lower()
            if name:find("base") or name:find("camp") or name:find("fire") or name:find("костёр") or name:find("house") then
                base = obj
                break
            end
        end
        if not base then base = Root end
        local pos = base:IsA("BasePart") and base.Position or base:FindFirstChild("HumanoidRootPart").Position
        for _, item in ipairs(workspace:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Item") or (item:IsA("Model") and not item:FindFirstChild("Humanoid")) then
                if item:FindFirstChild("Handle") then
                    item.Handle.Position = pos + Vector3.new(math.random(-3, 3), 2, math.random(-3, 3))
                elseif item:IsA("BasePart") then
                    item.Position = pos + Vector3.new(math.random(-3, 3), 2, math.random(-3, 3))
                end
                count = count + 1
                wait(0.01)
            end
        end
        print("[SWILL] Собрано предметов: " .. count)
    end)

    addBtn("🏠 ТЕЛЕПОРТ НА БАЗУ", Color3.fromRGB(40, 200, 120), function()
        local base = nil
        for _, obj in ipairs(workspace:GetChildren()) do
            local name = obj.Name:lower()
            if name:find("base") or name:find("camp") or name:find("house") or name:find("костёр") or name:find("fire") then
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
        autoCollect = not autoCollect
        print("[SWILL] Автосбор " .. (autoCollect and "ВКЛЮЧЁН" or "ВЫКЛЮЧЁН"))
    end)

    addBtn("👁️ ESP (ИГРОКИ)", Color3.fromRGB(180, 40, 200), function()
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= Player and player.Character then
                local h = player.Character:FindFirstChild("Highlight")
                if h then
                    h:Destroy()
                else
                    local nh = Instance.new("Highlight")
                    nh.Parent = player.Character
                    nh.FillColor = Color3.fromRGB(255, 50, 50)
                    nh.OutlineColor = Color3.fromRGB(255, 255, 255)
                    nh.FillTransparency = 0.3
                end
            end
        end
    end)

    addBtn("💀 БЕССМЕРТИЕ", Color3.fromRGB(200, 50, 50), function()
        Humanoid.Health = Humanoid.MaxHealth
        Humanoid.BreakJointsOnDeath = false
        print("[SWILL] Бессмертие активировано")
    end)

    addBtn("🔫 ДУБЛЬ ИНВЕНТАРЯ", Color3.fromRGB(200, 100, 50), function()
        local count = 0
        for _, item in ipairs(Player.Backpack:GetChildren()) do
            if item:IsA("Tool") then
                item:Clone().Parent = Player.Backpack
                count = count + 1
                wait(0.05)
            end
        end
        print("[SWILL] Создано копий: " .. count)
    end)

    addBtn("🔄 ОБНОВИТЬ МЕНЮ", Color3.fromRGB(100, 100, 150), function()
        gui:Destroy()
        wait(0.2)
        CreateMenu()
        print("[SWILL] Меню перезапущено")
    end)

    -- ===== СЛАЙДЕРЫ =====
    addSlider("🚀 Скорость полёта", 10, 200, flySpeed, function(v)
        flySpeed = v
    end)

    addSlider("🏃 Скорость бега", 16, 100, walkSpeed, function(v)
        walkSpeed = v
        Humanoid.WalkSpeed = v
    end)

    addSlider("🦘 Сила прыжка", 30, 150, jumpPower, function(v)
        jumpPower = v
        Humanoid.JumpPower = v
    end)

    addSlider("📏 Радиус автосбора", 20, 300, collectRange, function(v)
        collectRange = v
    end)

    return gui
end

-- ===== УПРАВЛЕНИЕ =====
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
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
        local g = Player.PlayerGui:FindFirstChild("ForestGUI")
        if g then
            g:Destroy()
        else
            CreateMenu()
        end
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
                    item.Handle.Position = pos + Vector3.new(math.random(-2, 2), 2, math.random(-2, 2))
                elseif item:IsA("BasePart") then
                    item.Position = pos + Vector3.new(math.random(-2, 2), 2, math.random(-2, 2))
                end
                count = count + 1
                wait(0.01)
            end
        end
        print("[SWILL] Собрано: " .. count)
    end
end)

-- ===== ПОЛЁТ (ПЛАВНЫЙ) =====
RunService.Heartbeat:Connect(function()
    if fly then
        local cam = workspace.CurrentCamera
        local fwd = cam.CFrame.LookVector
        local rgt = cam.CFrame.RightVector
        local up = cam.CFrame.UpVector
        local move = Vector3.new(0, 0, 0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + fwd * flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - fwd * flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - rgt * flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + rgt * flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + up * flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - up * flySpeed end
        Root.Velocity = Root.Velocity:Lerp(move, 0.3)
    end
    if autoCollect then
        for _, item in ipairs(workspace:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Item") then
                if (item.Position - Root.Position).Magnitude < collectRange then
                    item.Parent = Player.Backpack
                end
            end
        end
    end
end)

-- ===== ЗАПУСК =====
print("🌲 FOREST SCRIPT v7.0 LOADED!")
print("F - Fly | RightShift - Menu | RightCtrl - Принести всё")
CreateMenu()
