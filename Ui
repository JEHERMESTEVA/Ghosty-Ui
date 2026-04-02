local Luxt1 = {}

-- Улучшенная цветовая палитра с поддержкой матового стекла
local Colors = {
    Primary = Color3.fromRGB(153, 255, 238),
    PrimaryDark = Color3.fromRGB(101, 168, 157),
    Background = Color3.fromRGB(30, 30, 30),
    Surface = Color3.fromRGB(21, 21, 21),
    Glass = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(180, 180, 180),
    Accent = Color3.fromRGB(120, 200, 187),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- Функция для создания 5-ступенчатого Deep Glow эффекта
local function CreateDeepGlow(parent, color)
    local glowGroup = Instance.new("Folder")
    glowGroup.Name = "DeepGlow"
    glowGroup.Parent = parent
    
    local glowLevels = {
        { transparency = 0.9, size = 1.15 },
        { transparency = 0.85, size = 1.12 },
        { transparency = 0.75, size = 1.09 },
        { transparency = 0.6, size = 1.06 },
        { transparency = 0.4, size = 1.03 }
    }
    
    for i, level in ipairs(glowLevels) do
        local glow = Instance.new("ImageLabel")
        glow.Name = "Glow_" .. i
        glow.Parent = glowGroup
        glow.BackgroundTransparency = 1
        glow.Image = "rbxassetid://6105530152" -- Soft shadow asset
        glow.ImageColor3 = color or Colors.Primary
        glow.ImageTransparency = level.transparency
        glow.ScaleType = Enum.ScaleType.Slice
        glow.SliceCenter = Rect.new(20, 20, 80, 80)
        glow.Size = UDim2.new(level.size, 0, level.size, 0)
        glow.Position = UDim2.new(0.5, 0, 0.5, 0)
        glow.AnchorPoint = Vector2.new(0.5, 0.5)
        glow.ZIndex = parent.ZIndex - 1
    end
    
    return glowGroup
end

-- Функция для создания эффекта матового стекла (Frosted Glass)
local function CreateGlassEffect(frame, blurAmount)
    blurAmount = blurAmount or 15
    
    -- Создаем эффект размытия через UIStroke и прозрачность
    local glassOverlay = Instance.new("Frame")
    glassOverlay.Name = "GlassOverlay"
    glassOverlay.Parent = frame
    glassOverlay.BackgroundColor3 = Colors.Glass
    glassOverlay.BackgroundTransparency = 0.85
    glassOverlay.BorderSizePixel = 0
    glassOverlay.Size = UDim2.new(1, 0, 1, 0)
    glassOverlay.ZIndex = frame.ZIndex + 10
    
    -- Добавляем градиент для эффекта стекла
    local gradient = Instance.new("UIGradient")
    gradient.Parent = glassOverlay
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 248, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.5, 0.95),
        NumberSequenceKeypoint.new(1, 0.9)
    })
    gradient.Rotation = 45
    
    -- Добавляем блик сверху
    local shine = Instance.new("Frame")
    shine.Name = "GlassShine"
    shine.Parent = glassOverlay
    shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shine.BackgroundTransparency = 0.95
    shine.BorderSizePixel = 0
    shine.Size = UDim2.new(1, 0, 0.5, 0)
    shine.Position = UDim2.new(0, 0, 0, 0)
    
    local shineGradient = Instance.new("UIGradient")
    shineGradient.Parent = shine
    shineGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(1, 1)
    })
    shineGradient.Rotation = -90
    
    -- Добавляем тонкую рамку для эффекта стекла
    local glassStroke = Instance.new("UIStroke")
    glassStroke.Parent = frame
    glassStroke.Color = Color3.fromRGB(255, 255, 255)
    glassStroke.Transparency = 0.9
    glassStroke.Thickness = 1.5
    
    return glassOverlay
end

-- Улучшенная функция анимации с эффектом пружины (Spring)
local function SpringTween(object, properties, targetValue, speed, damping)
    speed = speed or 10
    damping = damping or 0.8
    
    local current = properties[1]
    local velocity = 0
    
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function(dt)
        local displacement = targetValue - current
        local springForce = displacement * speed * speed
        local dampingForce = velocity * 2 * speed * damping
        
        velocity = velocity + (springForce - dampingForce) * dt
        current = current + velocity * dt
        
        -- Обновляем свойство
        if object and object.Parent then
            -- Применяем значение в зависимости от типа свойства
        else
            connection:Disconnect()
        end
    end)
end

-- Улучшенная функция плавного появления
local function SmoothAppear(element, duration)
    duration = duration or 0.5
    
    element.BackgroundTransparency = 1
    
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )
    
    game:GetService("TweenService"):Create(element, tweenInfo, {
        BackgroundTransparency = element:GetAttribute("OriginalTransparency") or 0
    }):Play()
    
    -- Анимация масштаба
    element.Size = UDim2.new(0, 0, 0, 0)
    game:GetService("TweenService"):Create(element, tweenInfo, {
        Size = element:GetAttribute("OriginalSize") or element.Size
    }):Play()
end

function Luxt1.CreateWindow(libName, logoId)
    libName = libName or "LuxtLib"
    logoId = logoId or ""
    
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    -- Основной ScreenGui
    local LuxtLib = Instance.new("ScreenGui")
    LuxtLib.Name = "LuxtLib_" .. libName
    LuxtLib.Parent = game.CoreGui
    LuxtLib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LuxtLib.ResetOnSpawn = false
    LuxtLib.IgnoreGuiInset = true
    
    -- Контейнер теней с 5-ступенчатым Deep Glow
    local shadowContainer = Instance.new("Frame")
    shadowContainer.Name = "ShadowContainer"
    shadowContainer.Parent = LuxtLib
    shadowContainer.BackgroundTransparency = 1
    shadowContainer.Position = UDim2.new(0.5, -304, 0.5, -265)
    shadowContainer.Size = UDim2.new(0, 609, 0, 530)
    shadowContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    
    -- Создаем 5 уровней теней для Deep Glow эффекта
    CreateDeepGlow(shadowContainer, Colors.Primary)
    
    -- Главный фрейм с матовым стеклом
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = shadowContainer
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.Position = UDim2.new(0.048, 0, 0.075, 0)
    MainFrame.Size = UDim2.new(0, 553, 0, 452)
    MainFrame.BorderSizePixel = 0
    
    -- Применяем эффект матового стекла к главному фрейму
    CreateGlassEffect(MainFrame, 20)
    
    -- Улучшенные скругления
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    -- Боковая панель с градиентом
    local sideHeading = Instance.new("Frame")
    sideHeading.Name = "sideHeading"
    sideHeading.Parent = MainFrame
    sideHeading.BackgroundColor3 = Colors.Surface
    sideHeading.Size = UDim2.new(0, 155, 0, 452)
    sideHeading.ZIndex = 2
    sideHeading.BorderSizePixel = 0
    
    -- Градиент для боковой панели
    local sideGradient = Instance.new("UIGradient")
    sideGradient.Parent = sideHeading
    sideGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Colors.Surface),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
    })
    sideGradient.Rotation = 90
    
    local MainCorner2 = Instance.new("UICorner")
    MainCorner2.CornerRadius = UDim.new(0, 12)
    MainCorner2.Parent = sideHeading
    
    -- Заглушка для скругления
    local sideCover = Instance.new("Frame")
    sideCover.Name = "sideCover"
    sideCover.Parent = sideHeading
    sideCover.BackgroundColor3 = Colors.Surface
    sideCover.BorderSizePixel = 0
    sideCover.Position = UDim2.new(0.909677446, 0, 0, 0)
    sideCover.Size = UDim2.new(0, 14, 0, 452)
    
    -- Логотип с анимацией свечения
    local hubLogo = Instance.new("ImageLabel")
    hubLogo.Name = "hubLogo"
    hubLogo.Parent = sideHeading
    hubLogo.BackgroundColor3 = Colors.Primary
    hubLogo.Position = UDim2.new(0.0567928664, 0, 0.0243411884, 0)
    hubLogo.Size = UDim2.new(0, 35, 0, 35)
    hubLogo.ZIndex = 3
    hubLogo.Image = "rbxassetid://" .. logoId
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 8)
    logoCorner.Parent = hubLogo
    
    -- Добавляем свечение к логотипу
    local logoGlow = Instance.new("ImageLabel")
    logoGlow.Name = "LogoGlow"
    logoGlow.Parent = hubLogo
    logoGlow.BackgroundTransparency = 1
    logoGlow.Position = UDim2.new(-0.2, 0, -0.2, 0)
    logoGlow.Size = UDim2.new(1.4, 0, 1.4, 0)
    logoGlow.Image = "rbxassetid://6105530152"
    logoGlow.ImageColor3 = Colors.Primary
    logoGlow.ImageTransparency = 0.7
    logoGlow.ZIndex = 2
    
    -- Название библиотеки
    local hubName = Instance.new("TextLabel")
    hubName.Name = "hubName"
    hubName.Parent = sideHeading
    hubName.BackgroundTransparency = 1
    hubName.Position = UDim2.new(0.290000081, 0, 0.0299999975, 0)
    hubName.Size = UDim2.new(0, 110, 0, 18)
    hubName.ZIndex = 3
    hubName.Font = Enum.Font.GothamBold
    hubName.Text = libName
    hubName.TextColor3 = Colors.Primary
    hubName.TextSize = 16
    hubName.TextWrapped = true
    hubName.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Имя пользователя с улучшенным стилем
    local usename = Instance.new("TextLabel")
    usename.Name = "username"
    usename.Parent = sideHeading
    usename.BackgroundTransparency = 1
    usename.Position = UDim2.new(0.290000081, 0, 0.0700000152, 0)
    usename.Size = UDim2.new(0, 110, 0, 16)
    usename.ZIndex = 3
    usename.Font = Enum.Font.GothamMedium
    usename.Text = LocalPlayer.Name
    usename.TextColor3 = Colors.Accent
    usename.TextSize = 12
    usename.TextWrapped = true
    usename.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Разделитель
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Parent = sideHeading
    divider.BackgroundColor3 = Colors.Primary
    divider.BackgroundTransparency = 0.8
    divider.Position = UDim2.new(0.1, 0, 0.11, 0)
    divider.Size = UDim2.new(0.8, 0, 0, 1)
    divider.ZIndex = 3
    
    -- Фрейм для вкладок с улучшенным скроллом
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = "tabFrame"
    tabFrame.Parent = sideHeading
    tabFrame.Active = true
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.Position = UDim2.new(0.0761478543, 0, 0.14, 0)
    tabFrame.Size = UDim2.new(0, 135, 0, 320)
    tabFrame.ZIndex = 3
    tabFrame.ScrollBarThickness = 3
    tabFrame.ScrollBarImageColor3 = Colors.Primary
    tabFrame.ScrollBarImageTransparency = 0.5
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = tabFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)
    
    -- Кнопка Keybind с улучшенным дизайном
    local key1 = Instance.new("TextButton")
    key1.Name = "key1"
    key1.Parent = sideHeading
    key1.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    key1.Position = UDim2.new(0.0508064516, 0, 0.88, 0)
    key1.Size = UDim2.new(0, 80, 0, 26)
    key1.ZIndex = 3
    key1.Font = Enum.Font.GothamSemibold
    key1.Text = "LeftAlt"
    key1.TextColor3 = Colors.Primary
    key1.TextSize = 13
    
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 6)
    keyCorner.Parent = key1
    
    -- Добавляем стеклянный эффект к кнопке
    local keyGlass = CreateGlassEffect(key1, 10)
    keyGlass.BackgroundTransparency = 0.9
    
    local keybindInfo1 = Instance.new("TextLabel")
    keybindInfo1.Name = "keybindInfo"
    keybindInfo1.Parent = sideHeading
    keybindInfo1.BackgroundTransparency = 1
    keybindInfo1.Position = UDim2.new(0.585064113, 0, 0.88, 0)
    keybindInfo1.Size = UDim2.new(0, 50, 0, 26)
    keybindInfo1.ZIndex = 3
    keybindInfo1.Font = Enum.Font.GothamMedium
    keybindInfo1.Text = "Close"
    keybindInfo1.TextColor3 = Colors.TextMuted
    keybindInfo1.TextSize = 12
    keybindInfo1.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Основная область с волновым фоном
    local framesAll = Instance.new("Frame")
    framesAll.Name = "framesAll"
    framesAll.Parent = MainFrame
    framesAll.BackgroundTransparency = 1
    framesAll.BorderSizePixel = 0
    framesAll.Position = UDim2.new(0.296564192, 0, 0.0242873337, 0)
    framesAll.Size = UDim2.new(0, 381, 0, 431)
    framesAll.ZIndex = 2
    
    -- Улучшенный волновой фон
    local wave = Instance.new("ImageLabel")
    wave.Name = "wave"
    wave.Parent = MainFrame
    wave.BackgroundTransparency = 1
    wave.Position = UDim2.new(0, 0, 0, 0)
    wave.Size = UDim2.new(1, 0, 0.6, 0)
    wave.Image = "rbxassetid://6087537285"
    wave.ImageColor3 = Colors.Primary
    wave.ImageTransparency = 0.85
    wave.ScaleType = Enum.ScaleType.Slice
    wave.SliceCenter = Rect.new(0, 100, 400, 200)
    
    local waveGradient = Instance.new("UIGradient")
    waveGradient.Parent = wave
    waveGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(0.5, 0.9),
        NumberSequenceKeypoint.new(1, 1)
    })
    waveGradient.Rotation = 90
    
    local pageFolder = Instance.new("Folder")
    pageFolder.Name = "pageFolder"
    pageFolder.Parent = framesAll
    
    -- Логика Keybind с улучшенной анимацией
    local oldKey = Enum.KeyCode.LeftAlt.Name
    
    key1.MouseButton1Click:Connect(function()
        -- Анимация нажатия
        TweenService:Create(key1, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 76, 0, 24),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
        
        key1.Text = "..."
        
        local a, b = UserInputService.InputBegan:Wait()
        if a.KeyCode.Name ~= "Unknown" then
            key1.Text = a.KeyCode.Name
            oldKey = a.KeyCode.Name
            
            -- Анимация возврата
            TweenService:Create(key1, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 80, 0, 26),
                BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            }):Play()
        end
    end)
    
    UserInputService.InputBegan:Connect(function(current, ok)
        if not ok then
            if current.KeyCode.Name == oldKey then
                -- Плавное появление/исчезновение
                local targetTransparency = LuxtLib.Enabled and 1 or 0
                local targetSize = LuxtLib.Enabled and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 609, 0, 530)
                
                if LuxtLib.Enabled then
                    TweenService:Create(shadowContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
                        Size = UDim2.new(0, 0, 0, 0),
                        Position = UDim2.new(0.5, 0, 0.5, 0)
                    }):Play()
                    wait(0.4)
                    LuxtLib.Enabled = false
                else
                    LuxtLib.Enabled = true
                    shadowContainer.Size = UDim2.new(0, 0, 0, 0)
                    TweenService:Create(shadowContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, 609, 0, 530)
                    }):Play()
                end
            end
        end
    end)
    
    -- Улучшенная система перетаскивания
    local DragMousePosition
    local FramePosition
    local Draggable = false
    
    sideHeading.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Draggable = true
            DragMousePosition = Vector2.new(input.Position.X, input.Position.Y)
            FramePosition = Vector2.new(shadowContainer.Position.X.Scale, shadowContainer.Position.Y.Scale)
            
            -- Эффект при поднятии
            TweenService:Create(shadowContainer, TweenInfo.new(0.2), {
                Position = UDim2.new(FramePosition.X, -10, FramePosition.Y, -10)
            }):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if Draggable == true then
            local NewPosition = FramePosition + ((Vector2.new(input.Position.X, input.Position.Y) - DragMousePosition) / workspace.CurrentCamera.ViewportSize)
            shadowContainer.Position = UDim2.new(NewPosition.X, 0, NewPosition.Y, 0)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Draggable = false
            
            -- Возврат при отпускании
            local currentPos = Vector2.new(shadowContainer.Position.X.Scale, shadowContainer.Position.Y.Scale)
            TweenService:Create(shadowContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Position = UDim2.new(currentPos.X, 0, currentPos.Y, 0)
            }):Play()
        end
    end)
    
    -- Анимация открытия окна при создании
    shadowContainer.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(shadowContainer, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 609, 0, 530)
    }):Play()
    
    -- Обработка вкладок
    local TabHandling = {}
    
    function TabHandling:Tab(tabText, tabId)
        tabText = tabText or "Tab"
        tabId = tabId or ""
        
        local tabBtnFrame = Instance.new("Frame")
        tabBtnFrame.Name = "tabBtnFrame"
        tabBtnFrame.Parent = tabFrame
        tabBtnFrame.BackgroundTransparency = 1
        tabBtnFrame.Size = UDim2.new(0, 135, 0, 36)
        tabBtnFrame.ZIndex = 3
        
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "tabBtn"
        tabBtn.Parent = tabBtnFrame
        tabBtn.BackgroundColor3 = Colors.Surface
        tabBtn.BackgroundTransparency = 1
        tabBtn.Position = UDim2.new(0.245534033, 0, 0, 0)
        tabBtn.Size = UDim2.new(0, 101, 0, 36)
        tabBtn.ZIndex = 3
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.Text = tabText
        tabBtn.TextColor3 = Colors.TextMuted
        tabBtn.TextSize = 14
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Фон кнопки с эффектом стекла
        local tabBtnBg = Instance.new("Frame")
        tabBtnBg.Name = "Background"
        tabBtnBg.Parent = tabBtn
        tabBtnBg.BackgroundColor3 = Colors.Primary
        tabBtnBg.BackgroundTransparency = 1
        tabBtnBg.Size = UDim2.new(1, 0, 1, 0)
        tabBtnBg.ZIndex = 1
        
        local tabBtnCorner = Instance.new("UICorner")
        tabBtnCorner.CornerRadius = UDim.new(0, 8)
        tabBtnCorner.Parent = tabBtnBg
        
        local tabLogo = Instance.new("ImageLabel")
        tabLogo.Name = "tabLogo"
        tabLogo.Position = UDim2.new(-0.007, 0, 0.067, 0)
        tabLogo.Parent = tabBtnFrame
        tabLogo.BackgroundTransparency = 1
        tabLogo.BorderSizePixel = 0
        tabLogo.Size = UDim2.new(0, 28, 0, 28)
        tabLogo.ZIndex = 3
        tabLogo.Image = "rbxassetid://" .. tabId
        tabLogo.ImageColor3 = Colors.TextMuted
        
        -- Новая страница с улучшенным дизайном
        local newPage = Instance.new("ScrollingFrame")
        newPage.Name = "newPage_" .. tabText
        newPage.Parent = pageFolder
        newPage.Active = true
        newPage.BackgroundTransparency = 1
        newPage.BorderSizePixel = 0
        newPage.Size = UDim2.new(1, 0, 1, 0)
        newPage.ZIndex = 2
        newPage.ScrollBarThickness = 4
        newPage.ScrollBarImageColor3 = Colors.Primary
        newPage.ScrollBarImageTransparency = 0.6
        newPage.Visible = false
        
        local sectionList = Instance.new("UIListLayout")
        sectionList.Parent = newPage
        sectionList.SortOrder = Enum.SortOrder.LayoutOrder
        sectionList.Padding = UDim.new(0, 10)
        
        local function UpdateSize()
            local cS = sectionList.AbsoluteContentSize
            TweenService:Create(newPage, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {
                CanvasSize = UDim2.new(0, cS.X, 0, cS.Y + 20)
            }):Play()
        end
        
        UpdateSize()
        newPage.ChildAdded:Connect(UpdateSize)
        newPage.ChildRemoved:Connect(UpdateSize)
        
        -- Обработка клика по вкладке с улучшенной анимацией
        tabBtn.MouseButton1Click:Connect(function()
            UpdateSize()
            
            -- Анимация переключения вкладок
            for _, v in pairs(pageFolder:GetChildren()) do
                if v.Visible then
                    TweenService:Create(v, TweenInfo.new(0.2), {
                        Position = UDim2.new(0.02, 0, 0, 0),
                        BackgroundTransparency = 0.5
                    }):Play()
                    wait(0.1)
                    v.Visible = false
                    v.Position = UDim2.new(0, 0, 0, 0)
                end
            end
            
            newPage.Visible = true
            newPage.Position = UDim2.new(0.02, 0, 0, 0)
            TweenService:Create(newPage, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()
            
            -- Обновление цветов вкладок
            for _, v in pairs(tabFrame:GetChildren()) do
                if v:IsA("Frame") then
                    for _, child in pairs(v:GetChildren()) do
                        if child:IsA("TextButton") then
                            TweenService:Create(child, TweenInfo.new(0.2), {
                                TextColor3 = Colors.TextMuted
                            }):Play()
                            TweenService:Create(child.Background, TweenInfo.new(0.2), {
                                BackgroundTransparency = 1
                            }):Play()
                        end
                        if child:IsA("ImageLabel") and child.Name ~= "tabLogo" then
                            TweenService:Create(child, TweenInfo.new(0.2), {
                                ImageColor3 = Colors.TextMuted
                            }):Play()
                        end
                    end
                end
            end
            
            -- Активация текущей вкладки
            TweenService:Create(tabLogo, TweenInfo.new(0.2), {
                ImageColor3 = Colors.Primary
            }):Play()
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {
                TextColor3 = Colors.Primary
            }):Play()
            TweenService:Create(tabBtnBg, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                BackgroundTransparency = 0.9
            }):Play()
        end)
        
        -- Hover эффекты
        tabBtn.MouseEnter:Connect(function()
            if tabBtn.TextColor3 ~= Colors.Primary then
                TweenService:Create(tabBtn, TweenInfo.new(0.15), {
                    TextColor3 = Colors.Text
                }):Play()
                TweenService:Create(tabLogo, TweenInfo.new(0.15), {
                    ImageColor3 = Colors.Text
                }):Play()
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if tabBtn.TextColor3 ~= Colors.Primary then
                TweenService:Create(tabBtn, TweenInfo.new(0.15), {
                    TextColor3 = Colors.TextMuted
                }):Play()
                TweenService:Create(tabLogo, TweenInfo.new(0.15), {
                    ImageColor3 = Colors.TextMuted
                }):Play()
            end
        end)
        
        local sectionHandling = {}
        
        function sectionHandling:Section(sectionText)
            sectionText = sectionText or "Section"
            
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = newPage
            sectionFrame.BackgroundColor3 = Colors.Surface
            sectionFrame.Position = UDim2.new(0, 0, 0, 0)
            sectionFrame.Size = UDim2.new(1, -10, 0, 40)
            sectionFrame.ZIndex = 2
            sectionFrame.ClipsDescendants = true
            
            -- Эффект стекла для секции
            CreateGlassEffect(sectionFrame, 15)
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 10)
            sectionCorner.Parent = sectionFrame
            
            -- Добавляем Deep Glow к секции
            CreateDeepGlow(sectionFrame, Colors.Primary)
            
            local mainSectionHead = Instance.new("Frame")
            mainSectionHead.Name = "mainSectionHead"
            mainSectionHead.Parent = sectionFrame
            mainSectionHead.BackgroundTransparency = 1
            mainSectionHead.BorderSizePixel = 0
            mainSectionHead.Size = UDim2.new(1, 0, 0, 40)
            
            local sectionName = Instance.new("TextLabel")
            sectionName.Name = "sectionName"
            sectionName.Parent = mainSectionHead
            sectionName.BackgroundTransparency = 1
            sectionName.Position = UDim2.new(0.0236220472, 0, 0, 0)
            sectionName.Size = UDim2.new(0, 302, 0, 40)
            sectionName.Font = Enum.Font.GothamBold
            sectionName.Text = sectionText
            sectionName.TextColor3 = Colors.Primary
            sectionName.TextSize = 15
            sectionName.TextXAlignment = Enum.TextXAlignment.Left
            
            local sectionExpannd = Instance.new("ImageButton")
            sectionExpannd.Name = "sectionExpannd"
            sectionExpannd.Parent = mainSectionHead
            sectionExpannd.BackgroundTransparency = 1
            sectionExpannd.Position = UDim2.new(0.91863519, 0, 0.125, 0)
            sectionExpannd.Size = UDim2.new(0, 28, 0, 28)
            sectionExpannd.ZIndex = 3
            sectionExpannd.Image = "rbxassetid://3926305904"
            sectionExpannd.ImageColor3 = Colors.Primary
            sectionExpannd.ImageRectOffset = Vector2.new(564, 284)
            sectionExpannd.ImageRectSize = Vector2.new(36, 36)
            
            local sectionInnerList = Instance.new("UIListLayout")
            sectionInnerList.Parent = sectionFrame
            sectionInnerList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            sectionInnerList.SortOrder = Enum.SortOrder.LayoutOrder
            sectionInnerList.Padding = UDim.new(0, 6)
            
            local isDropped = false
            
            sectionExpannd.MouseButton1Click:Connect(function()
                if isDropped then
                    isDropped = false
                    TweenService:Create(sectionFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                        Size = UDim2.new(1, -10, 0, 40)
                    }):Play()
                    TweenService:Create(sectionExpannd, TweenInfo.new(0.2), {
                        Rotation = 0
                    }):Play()
                else
                    isDropped = true
                    local contentSize = sectionInnerList.AbsoluteContentSize.Y + 50
                    TweenService:Create(sectionFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                        Size = UDim2.new(1, -10, 0, contentSize)
                    }):Play()
                    TweenService:Create(sectionExpannd, TweenInfo.new(0.2), {
                        Rotation = 180
                    }):Play()
                end
                wait(0.3)
                UpdateSize()
            end)
            
            local ItemHandling = {}
            
            -- Улучшенная кнопка с эффектами
            function ItemHandling:Button(btnText, callback)
                btnText = btnText or "Button"
                callback = callback or function() end
                
                local ButtonFrame = Instance.new("Frame")
                ButtonFrame.Name = "ButtonFrame"
                ButtonFrame.Parent = sectionFrame
                ButtonFrame.BackgroundTransparency = 1
                ButtonFrame.Size = UDim2.new(0, 360, 0, 42)
                
                local TextButton = Instance.new("TextButton")
                TextButton.Parent = ButtonFrame
                TextButton.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                TextButton.Size = UDim2.new(0, 360, 0, 42)
                TextButton.ZIndex = 3
                TextButton.AutoButtonColor = false
                TextButton.Text = btnText
                TextButton.Font = Enum.Font.GothamSemibold
                TextButton.TextColor3 = Colors.TextMuted
                TextButton.TextSize = 14
                
                -- Эффект стекла
                CreateGlassEffect(TextButton, 8)
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = TextButton
                
                -- Deep glow для кнопки
                CreateDeepGlow(TextButton, Colors.Primary)
                
                local debounce = false
                
                TextButton.MouseButton1Click:Connect(function()
                    if not debounce then
                        debounce = true
                        
                        -- Анимация клика
                        TweenService:Create(TextButton, TweenInfo.new(0.1), {
                            Size = UDim2.new(0, 350, 0, 38),
                            Position = UDim2.new(0, 5, 0, 2)
                        }):Play()
                        
                        callback()
                        
                        wait(0.1)
                        TweenService:Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                            Size = UDim2.new(0, 360, 0, 42),
                            Position = UDim2.new(0, 0, 0, 0)
                        }):Play()
                        
                        wait(0.5)
                        debounce = false
                    end
                end)
                
                TextButton.MouseEnter:Connect(function()
                    TweenService:Create(TextButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        TextColor3 = Colors.Text
                    }):Play()
                end)
                
                TextButton.MouseLeave:Connect(function()
                    TweenService:Create(TextButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(24, 24, 24),
                        TextColor3 = Colors.TextMuted
                    }):Play()
                end)
            end
            
            -- Улучшенный Toggle
            function ItemHandling:Toggle(toggInfo, callback)
                toggInfo = toggInfo or "Toggle"
                callback = callback or function() end
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = "ToggleFrame"
                ToggleFrame.Parent = sectionFrame
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(0, 360, 0, 42)
                
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = "toggleFrame"
                toggleFrame.Parent = ToggleFrame
                toggleFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                toggleFrame.Size = UDim2.new(0, 360, 0, 42)
                toggleFrame.ZIndex = 3
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 8)
                toggleCorner.Parent = toggleFrame
                
                CreateGlassEffect(toggleFrame, 8)
                
                local checkBtn = Instance.new("ImageButton")
                checkBtn.Name = "checkBtn"
                checkBtn.Parent = toggleFrame
                checkBtn.BackgroundTransparency = 1
                checkBtn.Position = UDim2.new(0.019, 0, 0.14, 0)
                checkBtn.Size = UDim2.new(0, 30, 0, 30)
                checkBtn.ZIndex = 4
                checkBtn.Image = "rbxassetid://3926311105"
                checkBtn.ImageColor3 = Color3.fromRGB(97, 97, 97)
                checkBtn.ImageRectOffset = Vector2.new(940, 784)
                checkBtn.ImageRectSize = Vector2.new(48, 48)
                
                local toggleInfo = Instance.new("TextLabel")
                toggleInfo.Name = "toggleInfo"
                toggleInfo.Parent = toggleFrame
                toggleInfo.BackgroundTransparency = 1
                toggleInfo.Position = UDim2.new(0.11, 0, 0, 0)
                toggleInfo.Size = UDim2.new(0.8, 0, 1, 0)
                toggleInfo.ZIndex = 4
                toggleInfo.Font = Enum.Font.GothamSemibold
                toggleInfo.Text = toggInfo
                toggleInfo.TextColor3 = Color3.fromRGB(97, 97, 97)
                toggleInfo.TextSize = 14
                toggleInfo.TextXAlignment = Enum.TextXAlignment.Left
                
                local on = false
                local togDe = false
                
                checkBtn.MouseButton1Click:Connect(function()
                    if not togDe then
                        togDe = true
                        on = not on
                        callback(on)
                        
                        if on then
                            TweenService:Create(toggleInfo, TweenInfo.new(0.2), {
                                TextColor3 = Colors.Primary
                            }):Play()
                            TweenService:Create(checkBtn, TweenInfo.new(0.2), {
                                ImageColor3 = Colors.Primary
                            }):Play()
                            checkBtn.ImageRectOffset = Vector2.new(4, 836)
                            
                            -- Анимация активации
                            TweenService:Create(checkBtn, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
                                Size = UDim2.new(0, 32, 0, 32)
                            }):Play()
                            wait(0.15)
                            TweenService:Create(checkBtn, TweenInfo.new(0.15), {
                                Size = UDim2.new(0, 30, 0, 30)
                            }):Play()
                        else
                            TweenService:Create(toggleInfo, TweenInfo.new(0.2), {
                                TextColor3 = Color3.fromRGB(97, 97, 97)
                            }):Play()
                            TweenService:Create(checkBtn, TweenInfo.new(0.2), {
                                ImageColor3 = Color3.fromRGB(97, 97, 97)
                            }):Play()
                            checkBtn.ImageRectOffset = Vector2.new(940, 784)
                        end
                        
                        wait(0.5)
                        togDe = false
                    end
                end)
            end
            
            -- Улучшенный Slider
            function ItemHandling:Slider(slidInfo, minvalue, maxvalue, callback)
                slidInfo = slidInfo or "Slider"
                minvalue = minvalue or 0
                maxvalue = maxvalue or 100
                callback = callback or function() end
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = "SliderFrame"
                SliderFrame.Parent = sectionFrame
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Size = UDim2.new(0, 360, 0, 50)
                
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = "sliderFrame"
                sliderFrame.Parent = SliderFrame
                sliderFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                sliderFrame.Size = UDim2.new(0, 360, 0, 50)
                sliderFrame.ZIndex = 3
                
                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 8)
                sliderCorner.Parent = sliderFrame
                
                CreateGlassEffect(sliderFrame, 8)
                
                local sliderInfo = Instance.new("TextLabel")
                sliderInfo.Name = "sliderInfo"
                sliderInfo.Parent = sliderFrame
                sliderInfo.BackgroundTransparency = 1
                sliderInfo.Position = UDim2.new(0.45, 0, 0, 0)
                sliderInfo.Size = UDim2.new(0, 190, 0, 50)
                sliderInfo.ZIndex = 4
                sliderInfo.Font = Enum.Font.GothamSemibold
                sliderInfo.Text = slidInfo
                sliderInfo.TextColor3 = Colors.Text
                sliderInfo.TextSize = 14
                sliderInfo.TextXAlignment = Enum.TextXAlignment.Left
                
                local sliderbtn = Instance.new("TextButton")
                sliderbtn.Name = "sliderbtn"
                sliderbtn.Parent = sliderFrame
                sliderbtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                sliderbtn.Position = UDim2.new(0.025, 0, 0.5, 0)
                sliderbtn.Size = UDim2.new(0, 140, 0, 8)
                sliderbtn.ZIndex = 4
                sliderbtn.AutoButtonColor = false
                sliderbtn.Text = ""
                
                local sliderbtnCorner = Instance.new("UICorner")
                sliderbtnCorner.CornerRadius = UDim.new(0, 4)
                sliderbtnCorner.Parent = sliderbtn
                
                local dragSlider = Instance.new("Frame")
                dragSlider.Name = "dragSlider"
                dragSlider.Parent = sliderbtn
                dragSlider.BackgroundColor3 = Colors.Primary
                dragSlider.Size = UDim2.new(0, 0, 0, 8)
                dragSlider.ZIndex = 5
                
                local dragSliderCorner = Instance.new("UICorner")
                dragSliderCorner.CornerRadius = UDim.new(0, 4)
                dragSliderCorner.Parent = dragSlider
                
                local dragPrecent = Instance.new("TextLabel")
                dragPrecent.Name = "dragPrecent"
                dragPrecent.Parent = dragSlider
                dragPrecent.BackgroundColor3 = Colors.Surface
                dragPrecent.BorderSizePixel = 0
                dragPrecent.Position = UDim2.new(0.5, -22, -2.5, 0)
                dragPrecent.Size = UDim2.new(0, 44, 0, 20)
                dragPrecent.ZIndex = 6
                dragPrecent.Font = Enum.Font.GothamBold
                dragPrecent.Text = "0%"
                dragPrecent.TextColor3 = Colors.Primary
                dragPrecent.TextSize = 12
                dragPrecent.BackgroundTransparency = 0.2
                
                local precentCorner = Instance.new("UICorner")
                precentCorner.CornerRadius = UDim.new(0, 4)
                precentCorner.Parent = dragPrecent
                
                -- Deep glow для ползунка
                CreateDeepGlow(dragPrecent, Colors.Primary)
                
                local mouse = LocalPlayer:GetMouse()
                local Value = minvalue
                
                sliderbtn.MouseButton1Down:Connect(function()
                    TweenService:Create(dragPrecent, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.1,
                        TextTransparency = 0
                    }):Play()
                    
                    local moveconnection
                    moveconnection = mouse.Move:Connect(function()
                        local scale = math.clamp((mouse.X - sliderbtn.AbsolutePosition.X) / sliderbtn.AbsoluteSize.X, 0, 1)
                        Value = math.floor(minvalue + (maxvalue - minvalue) * scale)
                        
                        dragSlider.Size = UDim2.new(scale, 0, 0, 8)
                        dragPrecent.Text = tostring(Value) .. "%"
                        
                        callback(Value)
                    end)
                    
                    local releaseconnection
                    releaseconnection = UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            TweenService:Create(dragPrecent, TweenInfo.new(0.2), {
                                BackgroundTransparency = 1,
                                TextTransparency = 1
                            }):Play()
                            moveconnection:Disconnect()
                            releaseconnection:Disconnect()
                        end
                    end)
                end)
            end
            
            -- Улучшенный TextBox
            function ItemHandling:TextBox(infbix, textPlace, callback)
                infbix = infbix or "TextBox"
                textPlace = textPlace or "Enter text..."
                callback = callback or function() end
                
                local TextBoxFrame = Instance.new("Frame")
                TextBoxFrame.Name = "TextBoxFrame"
                TextBoxFrame.Parent = sectionFrame
                TextBoxFrame.BackgroundTransparency = 1
                TextBoxFrame.Size = UDim2.new(0, 360, 0, 50)
                
                local textboxFrame = Instance.new("Frame")
                textboxFrame.Name = "textboxFrame"
                textboxFrame.Parent = TextBoxFrame
                textboxFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                textboxFrame.Size = UDim2.new(0, 360, 0, 50)
                textboxFrame.ZIndex = 3
                
                local textboxCorner = Instance.new("UICorner")
                textboxCorner.CornerRadius = UDim.new(0, 8)
                textboxCorner.Parent = textboxFrame
                
                CreateGlassEffect(textboxFrame, 8)
                
                local textboxInfo = Instance.new("TextLabel")
                textboxInfo.Name = "textboxInfo"
                textboxInfo.Parent = textboxFrame
                textboxInfo.BackgroundTransparency = 1
                textboxInfo.Position = UDim2.new(0.38, 0, 0, 0)
                textboxInfo.Size = UDim2.new(0, 210, 0, 50)
                textboxInfo.ZIndex = 4
                textboxInfo.Font = Enum.Font.GothamSemibold
                textboxInfo.Text = infbix
                textboxInfo.TextColor3 = Colors.Text
                textboxInfo.TextSize = 14
                textboxInfo.TextXAlignment = Enum.TextXAlignment.Left
                
                local TextBox = Instance.new("TextBox")
                TextBox.Parent = textboxFrame
                TextBox.BackgroundColor3 = Colors.Primary
                TextBox.Position = UDim2.new(0.025, 0, 0.2, 0)
                TextBox.Size = UDim2.new(0, 120, 0, 28)
                TextBox.ZIndex = 4
                TextBox.ClearTextOnFocus = false
                TextBox.Font = Enum.Font.GothamSemibold
                TextBox.PlaceholderColor3 = Color3.fromRGB(60, 60, 60)
                TextBox.Text = ""
                TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
                TextBox.TextSize = 13
                TextBox.PlaceholderText = textPlace
                
                local textBoxCorner = Instance.new("UICorner")
                textBoxCorner.CornerRadius = UDim.new(0, 6)
                textBoxCorner.Parent = TextBox
                
                TextBox.Focused:Connect(function()
                    TweenService:Create(textboxFrame, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    }):Play()
                    TweenService:Create(TextBox, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(180, 255, 240)
                    }):Play()
                end)
                
                TextBox.FocusLost:Connect(function(EnterPressed)
                    TweenService:Create(textboxFrame, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                    }):Play()
                    TweenService:Create(TextBox, TweenInfo.new(0.2), {
                        BackgroundColor3 = Colors.Primary
                    }):Play()
                    
                    if EnterPressed then
                        callback(TextBox.Text)
                        TextBox.Text = ""
                    end
                end)
            end
            
            -- Улучшенный Label
            function ItemHandling:Label(labelInfo)
                labelInfo = labelInfo or "Label"
                
                local TextLabelFrame = Instance.new("Frame")
                TextLabelFrame.Name = "TextLabelFrame"
                TextLabelFrame.Parent = sectionFrame
                TextLabelFrame.BackgroundTransparency = 1
                TextLabelFrame.Size = UDim2.new(0, 360, 0, 40)
                
                local TextLabel = Instance.new("TextLabel")
                TextLabel.Parent = TextLabelFrame
                TextLabel.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                TextLabel.Size = UDim2.new(0, 360, 0, 40)
                TextLabel.ZIndex = 3
                TextLabel.Font = Enum.Font.GothamSemibold
                TextLabel.Text = labelInfo
                TextLabel.TextColor3 = Colors.Text
                TextLabel.TextSize = 14
                
                local labelCorner = Instance.new("UICorner")
                labelCorner.CornerRadius = UDim.new(0, 8)
                labelCorner.Parent = TextLabel
                
                CreateGlassEffect(TextLabel, 5)
            end
            
            -- Улучшенный KeyBind
            function ItemHandling:KeyBind(keyInfo, first, callback)
                keyInfo = keyInfo or "KeyBind"
                local oldKey = first.Name
                callback = callback or function() end
                
                local KeyBindFrame = Instance.new("Frame")
                KeyBindFrame.Name = "KeyBindFrame"
                KeyBindFrame.Parent = sectionFrame
                KeyBindFrame.BackgroundTransparency = 1
                KeyBindFrame.Size = UDim2.new(0, 360, 0, 50)
                
                local keybindFrame = Instance.new("Frame")
                keybindFrame.Name = "keybindFrame"
                keybindFrame.Parent = KeyBindFrame
                keybindFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                keybindFrame.Size = UDim2.new(0, 360, 0, 50)
                keybindFrame.ZIndex = 3
                
                local keybindCorner = Instance.new("UICorner")
                keybindCorner.CornerRadius = UDim.new(0, 8)
                keybindCorner.Parent = keybindFrame
                
                CreateGlassEffect(keybindFrame, 8)
                
                local key = Instance.new("TextButton")
                key.Name = "key"
                key.Parent = keybindFrame
                key.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                key.Position = UDim2.new(0.025, 0, 0.22, 0)
                key.Size = UDim2.new(0, 100, 0, 26)
                key.ZIndex = 4
                key.Font = Enum.Font.GothamBold
                key.Text = oldKey
                key.TextColor3 = Colors.Primary
                key.TextSize = 13
                
                local keyCorner = Instance.new("UICorner")
                keyCorner.CornerRadius = UDim.new(0, 6)
                keyCorner.Parent = key
                
                local keybindInfo = Instance.new("TextLabel")
                keybindInfo.Name = "keybindInfo"
                keybindInfo.Parent = keybindFrame
                keybindInfo.BackgroundTransparency = 1
                keybindInfo.Position = UDim2.new(0.35, 0, 0, 0)
                keybindInfo.Size = UDim2.new(0, 220, 0, 50)
                keybindInfo.ZIndex = 4
                keybindInfo.Font = Enum.Font.GothamSemibold
                keybindInfo.Text = keyInfo
                keybindInfo.TextColor3 = Colors.Text
                keybindInfo.TextSize = 14
                keybindInfo.TextXAlignment = Enum.TextXAlignment.Left
                
                key.MouseButton1Click:Connect(function()
                    TweenService:Create(key, TweenInfo.new(0.1), {
                        Size = UDim2.new(0, 96, 0, 24),
                        Position = UDim2.new(0.025, 2, 0.22, 1)
                    }):Play()
                    
                    key.Text = "..."
                    
                    local a, b = UserInputService.InputBegan:Wait()
                    if a.KeyCode.Name ~= "Unknown" then
                        key.Text = a.KeyCode.Name
                        oldKey = a.KeyCode.Name
                        
                        TweenService:Create(key, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                            Size = UDim2.new(0, 100, 0, 26),
                            Position = UDim2.new(0.025, 0, 0.22, 0)
                        }):Play()
                    end
                end)
                
                local keyDebounce = false
                UserInputService.InputBegan:Connect(function(current, ok)
                    if not ok then
                        if current.KeyCode.Name == oldKey then
                            if not keyDebounce then
                                keyDebounce = true
                                callback()
                                
                                TweenService:Create(key, TweenInfo.new(0.1), {
                                    BackgroundColor3 = Colors.Primary,
                                    TextColor3 = Color3.fromRGB(0, 0, 0)
                                }):Play()
                                
                                wait(0.2)
                                TweenService:Create(key, TweenInfo.new(0.2), {
                                    BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                                    TextColor3 = Colors.Primary
                                }):Play()
                                
                                wait(0.5)
                                keyDebounce = false
                            end
                        end
                    end
                end)
            end
            
            -- Улучшенный Dropdown
            function ItemHandling:DropDown(dropInfo, list, callback)
                dropInfo = dropInfo or "Select..."
                list = list or {}
                callback = callback or function() end
                
                local isDropped1 = false
                local DropYSize = 50
                
                local DropDownFrame = Instance.new("Frame")
                DropDownFrame.Name = "DropDownFrame"
                DropDownFrame.Parent = sectionFrame
                DropDownFrame.BackgroundTransparency = 1
                DropDownFrame.Size = UDim2.new(0, 360, 0, 50)
                DropDownFrame.ClipsDescendants = true
                
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Name = "dropdownFrame"
                dropdownFrame.Parent = DropDownFrame
                dropdownFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                dropdownFrame.Size = UDim2.new(1, 0, 1, 0)
                dropdownFrame.ZIndex = 3
                
                local dropdownCorner = Instance.new("UICorner")
                dropdownCorner.CornerRadius = UDim.new(0, 8)
                dropdownCorner.Parent = dropdownFrame
                
                CreateGlassEffect(dropdownFrame, 8)
                
                local dropdownFrameMain = Instance.new("Frame")
                dropdownFrameMain.Name = "dropdownFrameMain"
                dropdownFrameMain.Parent = dropdownFrame
                dropdownFrameMain.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                dropdownFrameMain.Size = UDim2.new(1, 0, 0, 50)
                dropdownFrameMain.ZIndex = 4
                
                local mainCorner = Instance.new("UICorner")
                mainCorner.CornerRadius = UDim.new(0, 8)
                mainCorner.Parent = dropdownFrameMain
                
                local expand_more = Instance.new("ImageButton")
                expand_more.Name = "expand_more"
                expand_more.Parent = dropdownFrameMain
                expand_more.BackgroundTransparency = 1
                expand_more.Position = UDim2.new(0.919, 0, 0.22, 0)
                expand_more.Size = UDim2.new(0, 28, 0, 28)
                expand_more.ZIndex = 5
                expand_more.Image = "rbxassetid://3926305904"
                expand_more.ImageColor3 = Colors.Primary
                expand_more.ImageRectOffset = Vector2.new(564, 284)
                expand_more.ImageRectSize = Vector2.new(36, 36)
                
                local dropdownItem1 = Instance.new("TextLabel")
                dropdownItem1.Name = "dropdownItem1"
                dropdownItem1.Parent = dropdownFrameMain
                dropdownItem1.BackgroundTransparency = 1
                dropdownItem1.Position = UDim2.new(0.025, 0, 0, 0)
                dropdownItem1.Size = UDim2.new(0, 300, 0, 50)
                dropdownItem1.ZIndex = 5
                dropdownItem1.Font = Enum.Font.GothamSemibold
                dropdownItem1.Text = dropInfo
                dropdownItem1.TextColor3 = Colors.Primary
                dropdownItem1.TextSize = 14
                dropdownItem1.TextXAlignment = Enum.TextXAlignment.Left
                
                local UIListLayout = Instance.new("UIListLayout")
                UIListLayout.Parent = dropdownFrame
                UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Padding = UDim.new(0, 6)
                
                expand_more.MouseButton1Click:Connect(function()
                    if isDropped1 then
                        isDropped1 = false
                        TweenService:Create(DropDownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                            Size = UDim2.new(0, 360, 0, 50)
                        }):Play()
                        TweenService:Create(expand_more, TweenInfo.new(0.2), {
                            Rotation = 0
                        }):Play()
                    else
                        isDropped1 = true
                        TweenService:Create(DropDownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                            Size = UDim2.new(0, 360, 0, DropYSize)
                        }):Play()
                        TweenService:Create(expand_more, TweenInfo.new(0.2), {
                            Rotation = 180
                        }):Play()
                    end
                end)
                
                for i, v in ipairs(list) do
                    local optionBtnFrame = Instance.new("Frame")
                    optionBtnFrame.Name = "optionBtnFrame_" .. i
                    optionBtnFrame.Parent = dropdownFrame
                    optionBtnFrame.BackgroundTransparency = 1
                    optionBtnFrame.Size = UDim2.new(0, 340, 0, 38)
                    
                    local optionBtn1 = Instance.new("TextButton")
                    optionBtn1.Name = "optionBtn"
                    optionBtn1.Parent = optionBtnFrame
                    optionBtn1.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
                    optionBtn1.Size = UDim2.new(0, 340, 0, 38)
                    optionBtn1.ZIndex = 4
                    optionBtn1.AutoButtonColor = false
                    optionBtn1.Font = Enum.Font.GothamSemibold
                    optionBtn1.Text = "  " .. v
                    optionBtn1.TextColor3 = Colors.Accent
                    optionBtn1.TextSize = 13
                    optionBtn1.TextXAlignment = Enum.TextXAlignment.Left
                    
                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, 6)
                    optionCorner.Parent = optionBtn1
                    
                    DropYSize = DropYSize + 44
                    
                    optionBtn1.MouseButton1Click:Connect(function()
                        callback(v)
                        dropdownItem1.Text = v
                        
                        TweenService:Create(DropDownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                            Size = UDim2.new(0, 360, 0, 50)
                        }):Play()
                        TweenService:Create(expand_more, TweenInfo.new(0.2), {
                            Rotation = 0
                        }):Play()
                        
                        isDropped1 = false
                    end)
                    
                    optionBtn1.MouseEnter:Connect(function()
                        TweenService:Create(optionBtn1, TweenInfo.new(0.15), {
                            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                            TextColor3 = Colors.Text
                        }):Play()
                    end)
                    
                    optionBtn1.MouseLeave:Connect(function()
                        TweenService:Create(optionBtn1, TweenInfo.new(0.15), {
                            BackgroundColor3 = Color3.fromRGB(21, 21, 21),
                            TextColor3 = Colors.Accent
                        }):Play()
                    end)
                end
            end
            
            return ItemHandling
        end
        
        return sectionHandling
    end
    
    return TabHandling
end

return Luxt1
