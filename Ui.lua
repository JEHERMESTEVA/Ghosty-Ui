local RetroDepressiveUI = {}

-- ═══════════════════════════════════════════════════════════════
-- ЦВЕТОВАЯ ПАЛИТРА: Голубо-фиолетовый + Глубокий ретро-депрессивный
-- ═══════════════════════════════════════════════════════════════
local Colors = {
    Primary = Color3.fromRGB(120, 80, 200),        -- Основной фиолетовый
    PrimaryGlow = Color3.fromRGB(140, 100, 230),    -- Свечение
    PrimaryDark = Color3.fromRGB(60, 30, 120),      -- Тёмный фиолетовый
    Accent = Color3.fromRGB(80, 140, 220),          -- Голубой акцент
    AccentDim = Color3.fromRGB(50, 90, 160),        -- Приглушённый голубой
    Background = Color3.fromRGB(12, 8, 22),         -- Почти чёрный с фиолетовым
    Surface = Color3.fromRGB(18, 12, 32),           -- Поверхность
    SurfaceLight = Color3.fromRGB(28, 20, 48),      -- Светлая поверхность
    Glass = Color3.fromRGB(80, 60, 140),            -- Матовое стекло
    Text = Color3.fromRGB(200, 190, 230),           -- Основной текст
    TextMuted = Color3.fromRGB(120, 100, 160),      -- Приглушённый текст
    TextGlow = Color3.fromRGB(170, 140, 255),       -- Светящийся текст
    Shadow = Color3.fromRGB(5, 2, 12),              -- Глубокая тень
    Scanline = Color3.fromRGB(0, 0, 0),             -- Сканлайны
    Vignette = Color3.fromRGB(0, 0, 0),             -- Виньетка
    CRT_Tint = Color3.fromRGB(100, 70, 180),        -- CRT оттенок
    OrbColor1 = Color3.fromRGB(100, 60, 200),       -- Орбик 1
    OrbColor2 = Color3.fromRGB(60, 120, 220),       -- Орбик 2
    OrbColor3 = Color3.fromRGB(140, 80, 240),       -- Орбик 3
    ChromaRed = Color3.fromRGB(255, 60, 80),        -- Хроматик красный
    ChromaGreen = Color3.fromRGB(60, 255, 120),     -- Хроматик зелёный
    ChromaBlue = Color3.fromRGB(60, 80, 255),       -- Хроматик синий
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════
-- ЗВУКОВАЯ СИСТЕМА (Ambient Sound Design)
-- ═══════════════════════════════════════════════════════════════
local SoundSystem = {}

function SoundSystem.CreateDrone()
    local drone = Instance.new("Sound")
    drone.Name = "UI_Drone"
    drone.SoundId = "rbxassetid://9112854440" -- Низкочастотный гул
    drone.Volume = 0
    drone.Looped = true
    drone.PlaybackSpeed = 0.5
    drone.Parent = game:GetService("SoundService")
    return drone
end

function SoundSystem.CreateClick()
    local click = Instance.new("Sound")
    click.Name = "UI_Click"
    click.SoundId = "rbxassetid://876939830" -- Глухой щелчок кассетного плеера
    click.Volume = 0.15
    click.PlaybackSpeed = 0.7
    click.Parent = game:GetService("SoundService")
    return click
end

function SoundSystem.CreateHover()
    local hover = Instance.new("Sound")
    hover.Name = "UI_Hover"
    hover.SoundId = "rbxassetid://6333086986" -- Тихий аналоговый щелчок
    hover.Volume = 0.08
    hover.PlaybackSpeed = 0.8
    hover.Parent = game:GetService("SoundService")
    return hover
end

function SoundSystem.CreateTypewriter()
    local tw = Instance.new("Sound")
    tw.Name = "UI_Type"
    tw.SoundId = "rbxassetid://5765856063" -- Звук печатной машинки
    tw.Volume = 0.06
    tw.PlaybackSpeed = 1.2
    tw.Parent = game:GetService("SoundService")
    return tw
end

local DroneSound = SoundSystem.CreateDrone()
local ClickSound = SoundSystem.CreateClick()
local HoverSound = SoundSystem.CreateHover()
local TypeSound = SoundSystem.CreateTypewriter()

local function PlayClick()
    ClickSound:Play()
end

local function PlayHover()
    HoverSound:Play()
end

local function PlayType()
    TypeSound:Play()
end

-- ═══════════════════════════════════════════════════════════════
-- 5-СТУПЕНЧАТЫЙ DEEP GLOW
-- ═══════════════════════════════════════════════════════════════
local function CreateDeepGlow(parent, color, zIndex)
    color = color or Colors.Primary
    zIndex = zIndex or 0
    
    local glowLevels = {
        {trans = 0.92, scale = 1.25, blur = 25},
        {trans = 0.88, scale = 1.20, blur = 20},
        {trans = 0.80, scale = 1.15, blur = 15},
        {trans = 0.70, scale = 1.10, blur = 10},
        {trans = 0.55, scale = 1.05, blur = 5},
    }
    
    local glows = {}
    for i, level in ipairs(glowLevels) do
        local glow = Instance.new("ImageLabel")
        glow.Name = "DeepGlow_L" .. i
        glow.Parent = parent
        glow.BackgroundTransparency = 1
        glow.Image = "rbxassetid://6105530152"
        glow.ImageColor3 = color
        glow.ImageTransparency = level.trans
        glow.ScaleType = Enum.ScaleType.Slice
        glow.SliceCenter = Rect.new(20, 20, 80, 80)
        glow.Size = UDim2.new(level.scale, 0, level.scale, 0)
        glow.Position = UDim2.new(0.5, 0, 0.5, 0)
        glow.AnchorPoint = Vector2.new(0.5, 0.5)
        glow.ZIndex = zIndex - i
        table.insert(glows, glow)
    end
    
    -- Анимация пульсации свечения
    spawn(function()
        while parent and parent.Parent do
            for _, g in ipairs(glows) do
                TweenService:Create(g, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    ImageTransparency = g.ImageTransparency + 0.05
                }):Play()
            end
            wait(2)
            for _, g in ipairs(glows) do
                TweenService:Create(g, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    ImageTransparency = g.ImageTransparency - 0.05
                }):Play()
            end
            wait(2)
        end
    end)
    
    return glows
end

-- ═══════════════════════════════════════════════════════════════
-- ЭФФЕКТ МАТОВОГО СТЕКЛА (Frosted Glass)
-- ═══════════════════════════════════════════════════════════════
local function CreateFrostedGlass(frame)
    -- Основной стеклянный слой
    local glass = Instance.new("Frame")
    glass.Name = "FrostedGlass"
    glass.Parent = frame
    glass.BackgroundColor3 = Colors.Glass
    glass.BackgroundTransparency = 0.88
    glass.Size = UDim2.new(1, 0, 1, 0)
    glass.ZIndex = frame.ZIndex + 1
    glass.BorderSizePixel = 0
    
    local gc = Instance.new("UICorner")
    gc.CornerRadius = UDim.new(0, 12)
    gc.Parent = glass
    
    -- Градиент стекла
    local glassGrad = Instance.new("UIGradient")
    glassGrad.Parent = glass
    glassGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 90, 180)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 60, 140)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 40, 120)),
    })
    glassGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(0.3, 0.92),
        NumberSequenceKeypoint.new(0.7, 0.88),
        NumberSequenceKeypoint.new(1, 0.90),
    })
    glassGrad.Rotation = 35
    
    -- Блик сверху
    local shine = Instance.new("Frame")
    shine.Name = "GlassShine"
    shine.Parent = glass
    shine.BackgroundColor3 = Color3.fromRGB(200, 180, 255)
    shine.BackgroundTransparency = 0.94
    shine.Size = UDim2.new(1, 0, 0.4, 0)
    shine.BorderSizePixel = 0
    shine.ZIndex = glass.ZIndex + 1
    
    local shineCorner = Instance.new("UICorner")
    shineCorner.CornerRadius = UDim.new(0, 12)
    shineCorner.Parent = shine
    
    local shineGrad = Instance.new("UIGradient")
    shineGrad.Parent = shine
    shineGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(1, 1),
    })
    shineGrad.Rotation = -90
    
    -- Тонкая стеклянная рамка
    local stroke = Instance.new("UIStroke")
    stroke.Parent = frame
    stroke.Color = Colors.PrimaryGlow
    stroke.Transparency = 0.85
    stroke.Thickness = 1
    
    -- Анимация рамки
    spawn(function()
        while frame and frame.Parent do
            TweenService:Create(stroke, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.7
            }):Play()
            wait(3)
            TweenService:Create(stroke, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.9
            }):Play()
            wait(3)
        end
    end)
    
    return glass
end

-- ═══════════════════════════════════════════════════════════════
-- ПАРТИКЛЫ — БОЛЬШИЕ ОРБИКИ
-- ═══════════════════════════════════════════════════════════════
local function CreateOrbs(parent, count)
    count = count or 6
    local orbColors = {Colors.OrbColor1, Colors.OrbColor2, Colors.OrbColor3}
    local orbs = {}
    
    for i = 1, count do
        local orb = Instance.new("Frame")
        orb.Name = "Orb_" .. i
        orb.Parent = parent
        orb.BackgroundColor3 = orbColors[(i % #orbColors) + 1]
        orb.BackgroundTransparency = 0.65
        local orbSize = math.random(40, 90)
        orb.Size = UDim2.new(0, orbSize, 0, orbSize)
        orb.Position = UDim2.new(math.random(5, 85) / 100, 0, math.random(5, 85) / 100, 0)
        orb.ZIndex = parent.ZIndex + 2
        orb.BorderSizePixel = 0
        
        local orbCorner = Instance.new("UICorner")
        orbCorner.CornerRadius = UDim.new(1, 0)
        orbCorner.Parent = orb
        
        -- Градиент орбика
        local orbGrad = Instance.new("UIGradient")
        orbGrad.Parent = orb
        orbGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(0.5, 0.6),
            NumberSequenceKeypoint.new(1, 0.9),
        })
        orbGrad.Rotation = math.random(0, 360)
        
        table.insert(orbs, orb)
        
        -- Плавное движение орбика
        spawn(function()
            while orb and orb.Parent do
                local targetX = math.random(2, 88) / 100
                local targetY = math.random(2, 88) / 100
                local duration = math.random(60, 120) / 10 -- 6-12 секунд
                
                TweenService:Create(orb, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Position = UDim2.new(targetX, 0, targetY, 0),
                    BackgroundTransparency = math.random(55, 80) / 100
                }):Play()
                
                -- Вращение градиента
                TweenService:Create(orbGrad, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                    Rotation = orbGrad.Rotation + math.random(60, 180)
                }):Play()
                
                wait(duration)
            end
        end)
    end
    
    return orbs
end

-- ═══════════════════════════════════════════════════════════════
-- PHOSPHOR TRAIL (Фосфорный след для орбиков)
-- ═══════════════════════════════════════════════════════════════
local function CreatePhosphorTrail(orb, parent)
    spawn(function()
        while orb and orb.Parent do
            local trail = Instance.new("Frame")
            trail.Name = "PhosphorTrail"
            trail.Parent = parent
            trail.BackgroundColor3 = orb.BackgroundColor3
            trail.BackgroundTransparency = 0.85
            trail.Size = orb.Size
            trail.Position = orb.Position
            trail.ZIndex = orb.ZIndex - 1
            trail.BorderSizePixel = 0
            
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = trail
            
            -- Затухание следа
            TweenService:Create(trail, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, orb.Size.X.Offset * 0.5, 0, orb.Size.Y.Offset * 0.5)
            }):Play()
            
            game:GetService("Debris"):AddItem(trail, 2.1)
            wait(0.3)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- CRT SCANLINES (Сканирующие линии старого монитора)
-- ═══════════════════════════════════════════════════════════════
local function CreateScanlines(parent)
    local scanlineContainer = Instance.new("Frame")
    scanlineContainer.Name = "CRT_Scanlines"
    scanlineContainer.Parent = parent
    scanlineContainer.BackgroundTransparency = 1
    scanlineContainer.Size = UDim2.new(1, 0, 2, 0) -- Двойная высота для прокрутки
    scanlineContainer.Position = UDim2.new(0, 0, 0, 0)
    scanlineContainer.ZIndex = 100
    scanlineContainer.ClipsDescendants = false
    
    -- Создаём горизонтальные полоски
    for y = 0, 300 do
        if y % 3 == 0 then
            local line = Instance.new("Frame")
            line.Name = "Scanline"
            line.Parent = scanlineContainer
            line.BackgroundColor3 = Colors.Scanline
            line.BackgroundTransparency = 0.92
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0, y * 3)
            line.ZIndex = 100
            line.BorderSizePixel = 0
        end
    end
    
    -- Клиппинг контейнер
    local clipFrame = Instance.new("Frame")
    clipFrame.Name = "ScanlineClip"
    clipFrame.Parent = parent
    clipFrame.BackgroundTransparency = 1
    clipFrame.Size = UDim2.new(1, 0, 1, 0)
    clipFrame.ClipsDescendants = true
    clipFrame.ZIndex = 100
    scanlineContainer.Parent = clipFrame
    
    -- Анимация прокрутки сканлайнов
    spawn(function()
        while scanlineContainer and scanlineContainer.Parent do
            scanlineContainer.Position = UDim2.new(0, 0, 0, 0)
            TweenService:Create(scanlineContainer, TweenInfo.new(4, Enum.EasingStyle.Linear), {
                Position = UDim2.new(0, 0, -0.5, 0)
            }):Play()
            wait(4)
        end
    end)
    
    return clipFrame
end

-- ═══════════════════════════════════════════════════════════════
-- CHROMATIC ABERRATION (Хроматическая аберрация / Глитч)
-- ═══════════════════════════════════════════════════════════════
local function CreateChromaticAberration(parent)
    -- Красный сдвиг
    local redLayer = Instance.new("Frame")
    redLayer.Name = "ChromaRed"
    redLayer.Parent = parent
    redLayer.BackgroundColor3 = Colors.ChromaRed
    redLayer.BackgroundTransparency = 0.97
    redLayer.Size = UDim2.new(1, 0, 1, 0)
    redLayer.Position = UDim2.new(0, 2, 0, 0)
    redLayer.ZIndex = 99
    redLayer.BorderSizePixel = 0
    
    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 12)
    rc.Parent = redLayer
    
    -- Синий сдвиг
    local blueLayer = Instance.new("Frame")
    blueLayer.Name = "ChromaBlue"
    blueLayer.Parent = parent
    blueLayer.BackgroundColor3 = Colors.ChromaBlue
    blueLayer.BackgroundTransparency = 0.97
    blueLayer.Size = UDim2.new(1, 0, 1, 0)
    blueLayer.Position = UDim2.new(0, -2, 0, 0)
    blueLayer.ZIndex = 99
    blueLayer.BorderSizePixel = 0
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 12)
    bc.Parent = blueLayer
    
    -- Периодический глитч
    spawn(function()
        while parent and parent.Parent do
            wait(math.random(30, 80) / 10) -- Случайный интервал
            
            -- Глитч-вспышка
            local offset = math.random(2, 5)
            TweenService:Create(redLayer, TweenInfo.new(0.05), {
                Position = UDim2.new(0, offset, 0, math.random(-1, 1)),
                BackgroundTransparency = 0.93
            }):Play()
            TweenService:Create(blueLayer, TweenInfo.new(0.05), {
                Position = UDim2.new(0, -offset, 0, math.random(-1, 1)),
                BackgroundTransparency = 0.93
            }):Play()
            
            wait(0.08)
            
            -- Возврат
            TweenService:Create(redLayer, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 1, 0, 0),
                BackgroundTransparency = 0.97
            }):Play()
            TweenService:Create(blueLayer, TweenInfo.new(0.2), {
                Position = UDim2.new(0, -1, 0, 0),
                BackgroundTransparency = 0.97
            }):Play()
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- VIGNETTE (Виньетка)
-- ═══════════════════════════════════════════════════════════════
local function CreateVignette(parent)
    local vignette = Instance.new("ImageLabel")
    vignette.Name = "Vignette"
    vignette.Parent = parent
    vignette.BackgroundTransparency = 1
    vignette.Size = UDim2.new(1, 0, 1, 0)
    vignette.Image = "rbxassetid://6105530152"
    vignette.ImageColor3 = Color3.fromRGB(0, 0, 0)
    vignette.ImageTransparency = 0.3
    vignette.ScaleType = Enum.ScaleType.Stretch
    vignette.ZIndex = 98
    
    -- Инвертируем — тёмные края, светлый центр
    local vigGrad = Instance.new("UIGradient")
    vigGrad.Parent = vignette
    vigGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(0.4, 0.8),
        NumberSequenceKeypoint.new(0.6, 0.8),
        NumberSequenceKeypoint.new(1, 0.2),
    })
    
    return vignette
end

-- ═══════════════════════════════════════════════════════════════
-- GRAIN / NOISE (Зернистость / Шум)
-- ═══════════════════════════════════════════════════════════════
local function CreateGrain(parent)
    local grainFrame = Instance.new("Frame")
    grainFrame.Name = "Grain"
    grainFrame.Parent = parent
    grainFrame.BackgroundTransparency = 1
    grainFrame.Size = UDim2.new(1, 0, 1, 0)
    grainFrame.ZIndex = 97
    grainFrame.ClipsDescendants = true
    grainFrame.BorderSizePixel = 0
    
    local gc = Instance.new("UICorner")
    gc.CornerRadius = UDim.new(0, 12)
    gc.Parent = grainFrame
    
    -- Шум через множество мелких полупрозрачных точек
    -- (Оптимизировано — используем ImageLabel с шумовой текстурой)
    local noiseImg = Instance.new("ImageLabel")
    noiseImg.Name = "NoiseTexture"
    noiseImg.Parent = grainFrame
    noiseImg.BackgroundTransparency = 1
    noiseImg.Size = UDim2.new(2, 0, 2, 0) -- Больше размера для движения
    noiseImg.Position = UDim2.new(0, 0, 0, 0)
    noiseImg.Image = "rbxassetid://3578681074" -- Шумовая текстура
    noiseImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
    noiseImg.ImageTransparency = 0.93
    noiseImg.ScaleType = Enum.ScaleType.Tile
    noiseImg.TileSize = UDim2.new(0, 128, 0, 128)
    noiseImg.ZIndex = 97
    
    -- Анимация дрожания шума
    spawn(function()
        while noiseImg and noiseImg.Parent do
            noiseImg.Position = UDim2.new(
                0, math.random(-50, 0),
                0, math.random(-50, 0)
            )
            noiseImg.ImageTransparency = 0.91 + math.random() * 0.05
            wait(0.06) -- ~16fps для шума
        end
    end)
    
    return grainFrame
end

-- ═══════════════════════════════════════════════════════════════
-- CRT ЭФФЕКТ (Искривление + фосфорное свечение)
-- ═══════════════════════════════════════════════════════════════
local function CreateCRTEffect(parent)
    -- Фосфорный оттенок
    local phosphor = Instance.new("Frame")
    phosphor.Name = "CRT_Phosphor"
    phosphor.Parent = parent
    phosphor.BackgroundColor3 = Colors.CRT_Tint
    phosphor.BackgroundTransparency = 0.96
    phosphor.Size = UDim2.new(1, 0, 1, 0)
    phosphor.ZIndex = 96
    phosphor.BorderSizePixel = 0
    
    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(0, 12)
    pc.Parent = phosphor
    
    -- Мерцание CRT
    spawn(function()
        while phosphor and phosphor.Parent do
            TweenService:Create(phosphor, TweenInfo.new(0.03), {
                BackgroundTransparency = 0.94 + math.random() * 0.04
            }):Play()
            wait(0.05 + math.random() * 0.1)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- TYPEWRITER EFFE
