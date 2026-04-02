-- main.lua для LÖVE 2D Framework
-- Запуск: love .

---=== УТИЛИТЫ ===---

local function lerp(a, b, t)
    return a + (b - a) * math.min(1, math.max(0, t))
end

local function clamp(v, lo, hi)
    return math.max(lo, math.min(hi, v))
end

local function hexToRGB(hex)
    hex = hex:gsub("#", "")
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    if not r or not g or not b then
        return {1, 1, 1}
    end
    return { r / 255, g / 255, b / 255 }
end

local function lerpColor(c1, c2, t)
    return {
        lerp(c1[1], c2[1], t),
        lerp(c1[2], c2[2], t),
        lerp(c1[3], c2[3], t)
    }
end

local function pointInRect(px, py, x, y, w, h)
    return px >= x and px <= x + w and py >= y and py <= y + h
end

local function easeOutBack(t)
    local c1 = 1.70158
    local c3 = c1 + 1
    return 1 + c3 * math.pow(t - 1, 3) + c1 * math.pow(t - 1, 2)
end

local function easeOutCubic(t)
    return 1 - math.pow(1 - t, 3)
end

local function easeOutQuint(t)
    return 1 - math.pow(1 - t, 5)
end

local function smoothstep(edge0, edge1, x)
    local t = clamp((x - edge0) / (edge1 - edge0), 0, 1)
    return t * t * (3 - 2 * t)
end

local function hsvToRGB(h, s, v)
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6
    if i == 0 then return v, t, p
    elseif i == 1 then return q, v, p
    elseif i == 2 then return p, v, t
    elseif i == 3 then return p, q, v
    elseif i == 4 then return t, p, v
    else return v, p, q end
end

local function drawRoundedRect(mode, x, y, w, h, r)
    r = math.min(r or 8, w / 2, h / 2)
    if r <= 0 then
        love.graphics.rectangle(mode, x, y, w, h)
        return
    end
    love.graphics.rectangle(mode, x, y, w, h, r, r)
end

---=== СИСТЕМА ЧАСТИЦ ===---

local ParticleSystem = {}
ParticleSystem.__index = ParticleSystem

function ParticleSystem.new()
    local self = setmetatable({}, ParticleSystem)
    self.particles = {}
    return self
end

function ParticleSystem:emit(x, y, count, color, spread, lifetime)
    count = count or 14
    color = color or {0, 0.83, 1}
    spread = spread or 50
    lifetime = lifetime or 0.7

    for i = 1, count do
        local angle = math.random() * math.pi * 2
        local speed = 1.5 + math.random() * 5
        local size = 1 + math.random() * 3.5

        table.insert(self.particles, {
            x = x, y = y,
            vx = math.cos(angle) * speed * (spread / 30),
            vy = math.sin(angle) * speed * (spread / 30),
            size = size,
            originalSize = size,
            color = { color[1], color[2], color[3] },
            alpha = 1.0,
            lifetime = lifetime + math.random() * 0.3,
            age = 0,
            gravity = 0.02 + math.random() * 0.08,
            friction = 0.96 + math.random() * 0.025,
            rotation = math.random() * math.pi * 2,
            rotSpeed = (math.random() - 0.5) * 8,
            sparkle = math.random() > 0.5,
            sparklePhase = math.random() * math.pi * 2
        })
    end
end

function ParticleSystem:emitRing(x, y, count, color, radius, lifetime)
    count = count or 20
    color = color or {0, 0.83, 1}
    radius = radius or 30
    lifetime = lifetime or 0.5

    for i = 1, count do
        local angle = (i / count) * math.pi * 2
        local speed = 2 + math.random() * 2

        table.insert(self.particles, {
            x = x, y = y,
            vx = math.cos(angle) * speed,
            vy = math.sin(angle) * speed,
            size = 1.5 + math.random() * 1.5,
            originalSize = 1.5 + math.random() * 1.5,
            color = { color[1], color[2], color[3] },
            alpha = 0.9,
            lifetime = lifetime + math.random() * 0.2,
            age = 0,
            gravity = 0,
            friction = 0.95,
            rotation = 0,
            rotSpeed = 0,
            sparkle = true,
            sparklePhase = math.random() * math.pi * 2
        })
    end
end

function ParticleSystem:emitTrail(x, y, color)
    color = color or {0, 0.83, 1}
    table.insert(self.particles, {
        x = x + (math.random() - 0.5) * 6,
        y = y + (math.random() - 0.5) * 6,
        vx = (math.random() - 0.5) * 0.8,
        vy = -0.8 - math.random() * 1.5,
        size = 1 + math.random() * 2.5,
        originalSize = 1 + math.random() * 2.5,
        color = { color[1], color[2], color[3] },
        alpha = 0.7,
        lifetime = 0.3 + math.random() * 0.4,
        age = 0,
        gravity = -0.03,
        friction = 0.97,
        rotation = 0,
        rotSpeed = 0,
        sparkle = false,
        sparklePhase = 0
    })
end

function ParticleSystem:emitSpark(x, y, color, direction)
    color = color or {1, 1, 1}
    local angle = (direction or 0) + (math.random() - 0.5) * 0.8
    local speed = 3 + math.random() * 5

    table.insert(self.particles, {
        x = x, y = y,
        vx = math.cos(angle) * speed,
        vy = math.sin(angle) * speed,
        size = 0.5 + math.random() * 1.5,
        originalSize = 0.5 + math.random() * 1.5,
        color = { color[1], color[2], color[3] },
        alpha = 1.0,
        lifetime = 0.2 + math.random() * 0.3,
        age = 0,
        gravity = 0.15,
        friction = 0.92,
        rotation = 0,
        rotSpeed = 0,
        sparkle = true,
        sparklePhase = math.random() * math.pi * 2
    })
end

function ParticleSystem:update(dt)
    local i = 1
    while i <= #self.particles do
        local p = self.particles[i]
        p.age = p.age + dt

        if p.age >= p.lifetime then
            table.remove(self.particles, i)
        else
            local progress = p.age / p.lifetime
            p.vx = p.vx * p.friction
            p.vy = p.vy * p.friction
            p.vy = p.vy + p.gravity
            p.x = p.x + p.vx
            p.y = p.y + p.vy
            p.alpha = math.max(0, 1.0 - progress ^ 0.5)
            p.size = p.originalSize * (1.0 - progress ^ 1.8)
            p.rotation = p.rotation + p.rotSpeed * dt
            i = i + 1
        end
    end
end

function ParticleSystem:draw()
    for _, p in ipairs(self.particles) do
        if p.size > 0.15 and p.alpha > 0.005 then
            local sparkleMultiplier = 1
            if p.sparkle then
                sparkleMultiplier = 0.5 + 0.5 * math.sin(
                    love.timer.getTime() * 15 + p.sparklePhase)
            end

            -- внешнее свечение
            love.graphics.setColor(
                p.color[1], p.color[2], p.color[3],
                p.alpha * 0.12 * sparkleMultiplier)
            love.graphics.circle("fill", p.x, p.y, p.size * 5)

            -- среднее свечение
            love.graphics.setColor(
                p.color[1], p.color[2], p.color[3],
                p.alpha * 0.25 * sparkleMultiplier)
            love.graphics.circle("fill", p.x, p.y, p.size * 2.5)

            -- ядро
            love.graphics.setColor(
                p.color[1], p.color[2], p.color[3],
                p.alpha * sparkleMultiplier)
            love.graphics.circle("fill", p.x, p.y, p.size)

            -- яркий центр
            love.graphics.setColor(1, 1, 1, p.alpha * 0.7 * sparkleMultiplier)
            love.graphics.circle("fill", p.x, p.y, p.size * 0.35)
        end
    end
end

---=== ФОНОВЫЕ ЗВЁЗДЫ С МЕРЦАНИЕМ ===---

local BackgroundStars = {}
BackgroundStars.__index = BackgroundStars

function BackgroundStars.new(count, w, h)
    local self = setmetatable({}, BackgroundStars)
    self.stars = {}
    for i = 1, count do
        table.insert(self.stars, {
            x = math.random() * w,
            y = math.random() * h,
            size = 0.3 + math.random() * 1.4,
            alpha = 0.02 + math.random() * 0.1,
            twinkleSpeed = 0.3 + math.random() * 2.5,
            twinklePhase = math.random() * math.pi * 2,
            color = {
                0.6 + math.random() * 0.4,
                0.6 + math.random() * 0.4,
                0.8 + math.random() * 0.2
            }
        })
    end
    return self
end

function BackgroundStars:draw(t, alpha)
    alpha = alpha or 1
    for _, s in ipairs(self.stars) do
        local a = s.alpha * (0.3 + 0.7 *
            math.sin(t * s.twinkleSpeed + s.twinklePhase) ^ 2) * alpha
        if a > 0.005 then
            love.graphics.setColor(s.color[1], s.color[2], s.color[3], a * 0.3)
            love.graphics.circle("fill", s.x, s.y, s.size * 3)
            love.graphics.setColor(s.color[1], s.color[2], s.color[3], a)
            love.graphics.circle("fill", s.x, s.y, s.size)
            love.graphics.setColor(1, 1, 1, a * 0.5)
            love.graphics.circle("fill", s.x, s.y, s.size * 0.4)
        end
    end
end

---=== АНИМИРОВАННАЯ НЕОНОВАЯ ОБВОДКА ===---

local GlowBorder = {}
GlowBorder.__index = GlowBorder

function GlowBorder.new(x, y, w, h, color, radius)
    local self = setmetatable({}, GlowBorder)
    self.x, self.y, self.w, self.h = x, y, w, h
    self.color = color or {0, 0.83, 1}
    self.targetColor = {self.color[1], self.color[2], self.color[3]}
    self.radius = radius or 16
    self.phase = 0
    self.secondPhase = 0.33
    self.thirdPhase = 0.66
    self.pulsePhase = 0
    self.breathe = 0
    return self
end

function GlowBorder:setColor(color)
    self.targetColor = {color[1], color[2], color[3]}
end

function GlowBorder:update(dt)
    self.phase = (self.phase + dt * 0.25) % 1.0
    self.secondPhase = (self.secondPhase + dt * 0.18) % 1.0
    self.thirdPhase = (self.thirdPhase + dt * 0.35) % 1.0
    self.pulsePhase = self.pulsePhase + dt
    self.breathe = 0.5 + 0.5 * math.sin(self.pulsePhase * 1.5)

    self.color[1] = lerp(self.color[1], self.targetColor[1], dt * 4)
    self.color[2] = lerp(self.color[2], self.targetColor[2], dt * 4)
    self.color[3] = lerp(self.color[3], self.targetColor[3], dt * 4)
end

function GlowBorder:getPointOnPerimeter(t)
    local perimeter = 2 * (self.w + self.h)
    local pos = (t % 1.0) * perimeter

    if pos < self.w then
        return self.x + pos, self.y
    elseif pos < self.w + self.h then
        return self.x + self.w, self.y + (pos - self.w)
    elseif pos < 2 * self.w + self.h then
        return self.x + self.w - (pos - self.w - self.h), self.y + self.h
    else
        return self.x, self.y + self.h - (pos - 2 * self.w - self.h)
    end
end

function GlowBorder:draw()
    local c = self.color
    local breathe = self.breathe

    -- многослойное внешнее свечение
    for i = 5, 1, -1 do
        local offset = i * 2.5
        local a = (0.02 + breathe * 0.01) / (i * 0.7)
        love.graphics.setColor(c[1], c[2], c[3], a)
        love.graphics.setLineWidth(1.5)
        drawRoundedRect("line",
            self.x - offset, self.y - offset,
            self.w + offset * 2, self.h + offset * 2,
            self.radius + offset)
    end

    -- основная рамка
    love.graphics.setColor(c[1], c[2], c[3], 0.2 + breathe * 0.08)
    love.graphics.setLineWidth(1)
    drawRoundedRect("line", self.x, self.y, self.w, self.h, self.radius)

    -- внутренняя тонкая рамка
    love.graphics.setColor(c[1], c[2], c[3], 0.06)
    drawRoundedRect("line", self.x + 2, self.y + 2,
        self.w - 4, self.h - 4, self.radius - 2)

    -- бегущие блики
    local blips = {
        {self.phase, 1.0, 4},
        {self.secondPhase, 0.5, 2.5},
        {self.thirdPhase, 0.3, 2}
    }

    for _, blip in ipairs(blips) do
        local hx, hy = self:getPointOnPerimeter(blip[1])
        local intensity = blip[2]
        local size = blip[3]

        for j = 4, 1, -1 do
            local s = size + j * 4
            love.graphics.setColor(c[1], c[2], c[3],
                intensity * 0.08 / j)
            love.graphics.circle("fill", hx, hy, s)
        end

        love.graphics.setColor(c[1], c[2], c[3], intensity * 0.9)
        love.graphics.circle("fill", hx, hy, size)
        love.graphics.setColor(1, 1, 1, intensity * 0.8)
        love.graphics.circle("fill", hx, hy, size * 0.4)
    end

    -- угловые свечения
    local corners = {
        {self.x, self.y},
        {self.x + self.w, self.y},
        {self.x + self.w, self.y + self.h},
        {self.x, self.y + self.h}
    }

    for idx, corner in ipairs(corners) do
        local p = 0.5 + 0.5 * math.sin(self.pulsePhase * 1.8 + idx * 1.2)
        love.graphics.setColor(c[1], c[2], c[3], 0.04 + p * 0.04)
        love.graphics.circle("fill", corner[1], corner[2], 15 + p * 8)
        love.graphics.setColor(c[1], c[2], c[3], 0.1 + p * 0.08)
        love.graphics.circle("fill", corner[1], corner[2], 4 + p * 2)
    end
end

---=== ПРЕМИУМ ТОГЛ ===---

local PremiumToggle = {}
PremiumToggle.__index = PremiumToggle

function PremiumToggle.new(x, y, label, color, particles)
    local self = setmetatable({}, PremiumToggle)
    self.x, self.y = x, y
    self.label = label or "Feature"
    self.color = color or {0, 0.83, 1}
    self.particles = particles
    self.enabled = false
    self.hover = false
    self.pressed = false

    self.trackW = 46
    self.trackH = 24
    self.knobRadius = 9

    self.knobPos = 0
    self.targetKnobPos = 0
    self.squashX = 1
    self.squashY = 1
    self.knobScale = 1
    self.targetKnobScale = 1
    self.colorTransition = 0
    self.targetColorTransition = 0
    self.pulsePhase = math.random() * math.pi * 2
    self.glowIntensity = 0
    self.ripples = {}
    self.labelGlow = 0

    -- каскад
    self.cascadeAlpha = 0
    self.cascadeOffsetX = -40
    self.cascadeOffsetY = 10
    self.cascading = false
    self.cascadeDelay = 0
    self.cascadeTimer = 0
    self.visible = true

    -- shake при клике
    self.shakeX = 0
    self.shakeY = 0
    self.shakeIntensity = 0

    return self
end

function PremiumToggle:setVisible(v)
    self.visible = v
    if not v then
        self.cascadeAlpha = 0
        self.cascadeOffsetX = -40
        self.cascadeOffsetY = 10
    end
end

function PremiumToggle:cascadeIn(delay)
    self.cascadeAlpha = 0
    self.cascadeOffsetX = -40
    self.cascadeOffsetY = 10
    self.cascadeDelay = delay or 0
    self.cascadeTimer = 0
    self.cascading = true
    self.visible = true
end

function PremiumToggle:checkHover(mx, my)
    if not self.visible then return false end
    local realX = self.x + self.cascadeOffsetX
    self.hover = pointInRect(mx, my,
        realX - 5, self.y - 5,
        self.trackW + 250, self.trackH + 10)
    self.targetKnobScale = self.hover and 1.2 or 1.0
    return self.hover
end

function PremiumToggle:click()
    if not self.visible then return end
    self.enabled = not self.enabled
    self.targetKnobPos = self.enabled and 1 or 0
    self.targetColorTransition = self.enabled and 1 or 0

    -- squash
    self.squashX = 0.5
    self.squashY = 1.5

    -- shake
    self.shakeIntensity = 3

    -- ripple
    local kx = self.x + 3 + self.knobRadius +
        self.knobPos * (self.trackW - self.knobRadius * 2 - 6)
    local ky = self.y + self.trackH / 2

    table.insert(self.ripples, {
        x = kx, y = ky,
        radius = 0, alpha = 0.6,
        maxRadius = 40, speed = 120
    })

    -- частицы
    if self.particles then
        if self.enabled then
            self.particles:emit(kx, ky, 22, self.color, 55, 0.8)
            self.particles:emitRing(kx, ky, 16, self.color, 20, 0.5)
        else
            self.particles:emit(kx, ky, 8,
                {0.5, 0.5, 0.6}, 25, 0.4)
        end
    end
end

function PremiumToggle:update(dt)
    if not self.visible then return end

    -- каскад
    if self.cascading then
        self.cascadeTimer = self.cascadeTimer + dt
        if self.cascadeTimer > self.cascadeDelay then
            local prog = math.min(1, (self.cascadeTimer - self.cascadeDelay) * 3)
            local easedProg = easeOutCubic(prog)
            self.cascadeAlpha = easedProg
            self.cascadeOffsetX = lerp(-40, 0, easeOutBack(prog))
            self.cascadeOffsetY = lerp(10, 0, easedProg)
            if prog >= 1 then
                self.cascadeAlpha = 1
                self.cascadeOffsetX = 0
                self.cascadeOffsetY = 0
                self.cascading = false
            end
        end
    end

    -- анимации
    local speed = 14
    self.knobPos = lerp(self.knobPos, self.targetKnobPos, dt * speed)
    self.squashX = lerp(self.squashX, 1, dt * 12)
    self.squashY = lerp(self.squashY, 1, dt * 12)
    self.knobScale = lerp(self.knobScale, self.targetKnobScale, dt * 10)
    self.colorTransition = lerp(self.colorTransition,
        self.targetColorTransition, dt * 8)
    self.pulsePhase = self.pulsePhase + dt * 3.5
    self.glowIntensity = lerp(self.glowIntensity,
        self.enabled and 1 or 0, dt * 5)
    self.labelGlow = lerp(self.labelGlow,
        self.hover and 1 or 0, dt * 8)

    -- shake
    if self.shakeIntensity > 0.1 then
        self.shakeIntensity = self.shakeIntensity * (1 - dt * 15)
        self.shakeX = (math.random() - 0.5) * self.shakeIntensity
        self.shakeY = (math.random() - 0.5) * self.shakeIntensity
    else
        self.shakeX = 0
        self.shakeY = 0
        self.shakeIntensity = 0
    end

    -- ripples
    local i = 1
    while i <= #self.ripples do
        local r = self.ripples[i]
        r.radius = r.radius + r.speed * dt
        r.alpha = r.alpha * (1 - dt * 4)
        if r.alpha < 0.01 or r.radius > r.maxRadius then
            table.remove(self.ripples, i)
        else
            i = i + 1
        end
    end

    -- trail
    if self.enabled and self.particles and math.random() < 0.12 then
        local kx = self.x + self.cascadeOffsetX + 3 + self.knobRadius +
            self.knobPos * (self.trackW - self.knobRadius * 2 - 6)
        local ky = self.y + self.cascadeOffsetY + self.trackH / 2
        self.particles:emitTrail(kx, ky, self.color)
    end
end

function PremiumToggle:draw()
    if not self.visible or self.cascadeAlpha < 0.005 then return end

    love.graphics.push()
    love.graphics.translate(
        self.cascadeOffsetX + self.shakeX,
        self.cascadeOffsetY + self.shakeY)

    local alpha = self.cascadeAlpha
    local tx, ty = self.x, self.y
    local tw, th = self.trackW, self.trackH
    local offColor = {0.14, 0.14, 0.22}
    local trackColor = lerpColor(offColor, self.color, self.colorTransition)

    -- hover подсветка фона
    if self.labelGlow > 0.01 then
        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            0.02 * self.labelGlow * alpha)
        drawRoundedRect("fill", tx - 10, ty - 6, tw + 260, th + 12, 8)
    end

    -- свечение трека
    if self.glowIntensity > 0.01 then
        local pulse = 0.7 + 0.3 * math.sin(self.pulsePhase * 0.8)
        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            self.glowIntensity * 0.12 * pulse * alpha)
        drawRoundedRect("fill", tx - 8, ty - 8, tw + 16, th + 16, th / 2 + 8)

        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            self.glowIntensity * 0.06 * pulse * alpha)
        drawRoundedRect("fill", tx - 16, ty - 16, tw + 32, th + 32, th / 2 + 16)
    end

    -- трек тень
    love.graphics.setColor(0, 0, 0, 0.3 * alpha)
    drawRoundedRect("fill", tx + 1, ty + 2, tw, th, th / 2)

    -- трек фон
    love.graphics.setColor(0.1, 0.1, 0.16, alpha)
    drawRoundedRect("fill", tx, ty, tw, th, th / 2)

    -- трек заливка
    love.graphics.setColor(trackColor[1], trackColor[2], trackColor[3],
        (0.25 + self.colorTransition * 0.75) * alpha)
    drawRoundedRect("fill", tx, ty, tw, th, th / 2)

    -- внутренний блик трека (верх)
    love.graphics.setColor(1, 1, 1, 0.04 * alpha)
    drawRoundedRect("fill", tx + 1, ty + 1, tw - 2, th / 2 - 1, th / 4)

    -- обводка трека
    love.graphics.setColor(trackColor[1], trackColor[2], trackColor[3],
        (0.2 + self.colorTransition * 0.3) * alpha)
    love.graphics.setLineWidth(1)
    drawRoundedRect("line", tx, ty, tw, th, th / 2)

    -- ripples
    for _, r in ipairs(self.ripples) do
        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            r.alpha * alpha)
        love.graphics.setLineWidth(2)
        love.graphics.circle("line", r.x, r.y, r.radius)
        love.graphics.setLineWidth(1)
    end

    -- ручка позиция
    local offset = self.knobPos * (tw - self.knobRadius * 2 - 6)
    local kx = tx + 3 + self.knobRadius + offset
    local ky = ty + th / 2
    local kr = self.knobRadius * self.knobScale

    -- тень ручки
    love.graphics.setColor(0, 0, 0, 0.5 * alpha)
    love.graphics.ellipse("fill", kx + 1, ky + 2,
        kr * self.squashX * 1.05, kr * self.squashY * 1.05)

    -- свечение ручки
    if self.hover or self.glowIntensity > 0.1 then
        local pulse = 0.5 + 0.5 * math.sin(self.pulsePhase)
        local intensity = math.max(
            self.hover and 1 or 0,
            self.glowIntensity * 0.5)
        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            (0.06 + pulse * 0.05) * intensity * alpha)
        love.graphics.circle("fill", kx, ky, kr * 3)
    end

    -- ручка основная
    local knobColor = lerpColor({0.72, 0.72, 0.84}, {1, 1, 1}, self.colorTransition)
    love.graphics.setColor(knobColor[1], knobColor[2], knobColor[3], alpha)
    love.graphics.ellipse("fill", kx, ky,
        kr * self.squashX, kr * self.squashY)

    -- градиентный блик на ручке
    love.graphics.setColor(1, 1, 1, 0.35 * alpha)
    love.graphics.ellipse("fill",
        kx - kr * 0.15 * self.squashX,
        ky - kr * 0.25 * self.squashY,
        kr * 0.45 * self.squashX,
        kr * 0.3 * self.squashY)

    -- второй блик (нижний)
    love.graphics.setColor(1, 1, 1, 0.1 * alpha)
    love.graphics.ellipse("fill",
        kx + kr * 0.1 * self.squashX,
        ky + kr * 0.2 * self.squashY,
        kr * 0.3 * self.squashX,
        kr * 0.15 * self.squashY)

    -- обводка ручки
    love.graphics.setColor(1, 1, 1, 0.2 * alpha)
    love.graphics.setLineWidth(1)
    love.graphics.ellipse("line", kx, ky,
        kr * self.squashX, kr * self.squashY)

    -- внутренняя точка (индикатор)
    if self.colorTransition > 0.01 then
        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            self.colorTransition * alpha)
        love.graphics.circle("fill", kx, ky, kr * 0.32 * self.colorTransition)

        -- свечение точки
        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            self.colorTransition * 0.3 * alpha)
        love.graphics.circle("fill", kx, ky, kr * 0.5 * self.colorTransition)
    end

    -- лейбл
    local labelAlpha = lerp(0.55, 1, self.labelGlow) *
        lerp(0.55, 1, self.colorTransition)
    love.graphics.setColor(1, 1, 1, labelAlpha * alpha)
    love.graphics.setFont(UI_FONTS.normal)
    love.graphics.print(self.label, tx + tw + 14, ty + th / 2 - 7)

    -- свечение лейбла
    if self.labelGlow > 0.01 then
        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            0.15 * self.labelGlow * alpha)
        love.graphics.print(self.label, tx + tw + 14, ty + th / 2 - 7)
    end

    -- статус
    local statusFont = UI_FONTS.small
    love.graphics.setFont(statusFont)
    local labelWidth = UI_FONTS.normal:getWidth(self.label)

    if self.enabled then
        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            self.colorTransition * alpha)
        love.graphics.print("ON", tx + tw + 20 + labelWidth, ty + th / 2 - 5)
    else
        love.graphics.setColor(0.3, 0.3, 0.42,
            (1 - self.colorTransition) * alpha)
        love.graphics.print("OFF", tx + tw + 20 + labelWidth, ty + th / 2 - 5)
    end

    love.graphics.pop()
end

---=== ПРЕМИУМ СЛАЙДЕР ===---

local PremiumSlider = {}
PremiumSlider.__index = PremiumSlider

function PremiumSlider.new(x, y, width, label, minVal, maxVal, value, color, particles)
    local self = setmetatable({}, PremiumSlider)
    self.x, self.y = x, y
    self.width = width or 320
    self.label = label or "Value"
    self.minVal = minVal or 0
    self.maxVal = maxVal or 100
    self.value = value or 50
    self.displayValue = value or 50
    self.color = color or {0, 0.83, 1}
    self.particles = particles

    self.hover = false
    self.dragging = false
    self.knobScale = 1
    self.targetKnobScale = 1
    self.glowPhase = math.random() * math.pi * 2
    self.knobRadius = 8
    self.trackHeight = 5
    self.trackY = y + 26

    -- каскад
    self.cascadeAlpha = 0
    self.cascadeOffsetX = -40
    self.cascadeOffsetY = 10
    self.cascading = false
    self.cascadeDelay = 0
    self.cascadeTimer = 0
    self.visible = true

    -- tooltip
    self.tooltipAlpha = 0
    self.tooltipScale = 0
    self.prevValue = value

    -- fill animation
    self.displayProgress = (value - minVal) / (maxVal - minVal)

    return self
end

function PremiumSlider:setVisible(v)
    self.visible = v
    if not v then
        self.cascadeAlpha = 0
        self.cascadeOffsetX = -40
        self.cascadeOffsetY = 10
    end
end

function PremiumSlider:cascadeIn(delay)
    self.cascadeAlpha = 0
    self.cascadeOffsetX = -40
    self.cascadeOffsetY = 10
    self.cascadeDelay = delay or 0
    self.cascadeTimer = 0
    self.cascading = true
    self.visible = true
end

function PremiumSlider:checkHover(mx, my)
    if not self.visible then return false end
    self.hover = pointInRect(mx, my,
        self.x - 12, self.trackY - 14,
        self.width + 24, self.trackHeight + 28)
    if not self.dragging then
        self.targetKnobScale = self.hover and 1.4 or 1.0
    end
    return self.hover
end

function PremiumSlider:press(mx, my)
    if self.hover and self.visible then
        self.dragging = true
        self.targetKnobScale = 1.6
        self:_updateValue(mx)
    end
end

function PremiumSlider:release()
    self.dragging = false
    self.targetKnobScale = self.hover and 1.4 or 1.0
end

function PremiumSlider:drag(mx)
    if self.dragging then
        self:_updateValue(mx)
    end
end

function PremiumSlider:_updateValue(mx)
    local progress = clamp((mx - self.x) / self.width, 0, 1)
    self.prevValue = self.value
    self.value = self.minVal + progress * (self.maxVal - self.minVal)

    -- sparks при быстром движении
    if self.particles and math.abs(self.value - self.prevValue) > 2 then
        local kx = self.x + progress * self.width
        local ky = self.trackY + self.trackHeight / 2
        if math.random() < 0.4 then
            self.particles:emitSpark(kx, ky, self.color,
                self.value > self.prevValue and 0 or math.pi)
        end
    end
end

function PremiumSlider:update(dt)
    if not self.visible then return end

    -- каскад
    if self.cascading then
        self.cascadeTimer = self.cascadeTimer + dt
        if self.cascadeTimer > self.cascadeDelay then
            local prog = math.min(1, (self.cascadeTimer - self.cascadeDelay) * 3)
            local easedProg = easeOutCubic(prog)
            self.cascadeAlpha = easedProg
            self.cascadeOffsetX = lerp(-40, 0, easeOutBack(prog))
            self.cascadeOffsetY = lerp(10, 0, easedProg)
            if prog >= 1 then
                self.cascadeAlpha = 1
                self.cascadeOffsetX = 0
                self.cascadeOffsetY = 0
                self.cascading = false
            end
        end
    end

    self.knobScale = lerp(self.knobScale, self.targetKnobScale, dt * 10)
    self.glowPhase = self.glowPhase + dt * 2.5
    self.displayValue = lerp(self.displayValue, self.value, dt * 15)
    self.displayProgress = lerp(self.displayProgress,
        (self.value - self.minVal) / (self.maxVal - self.minVal), dt * 12)

    -- tooltip
    local showTooltip = self.hover or self.dragging
    self.tooltipAlpha = lerp(self.tooltipAlpha, showTooltip and 1 or 0, dt * 10)
    self.tooltipScale = lerp(self.tooltipScale, showTooltip and 1 or 0.7, dt * 12)
end

function PremiumSlider:draw()
    if not self.visible or self.cascadeAlpha < 0.005 then return end

    love.graphics.push()
    love.graphics.translate(self.cascadeOffsetX, self.cascadeOffsetY)

    local alpha = self.cascadeAlpha
    local progress = self.displayProgress
    local fillW = progress * self.width

    -- лейбл
    love.graphics.setColor(0.63, 0.63, 0.74, alpha)
    love.graphics.setFont(UI_FONTS.normal)
    love.graphics.print(self.label, self.x, self.y)

    -- значение
    love.graphics.setColor(self.color[1], self.color[2], self.color[3], alpha)
    love.graphics.setFont(UI_FONTS.bold)
    local valText = string.format("%.0f", self.displayValue)
    love.graphics.printf(valText, self.x, self.y, self.width, "right")

    -- трек тень
    love.graphics.setColor(0, 0, 0, 0.3 * alpha)
    drawRoundedRect("fill", self.x + 1, self.trackY + 1,
        self.width, self.trackHeight, 3)

    -- трек фон
    love.graphics.setColor(0.1, 0.1, 0.16, alpha)
    drawRoundedRect("fill", self.x, self.trackY,
        self.width, self.trackHeight, 3)

    -- трек свечение под заливкой
    if fillW > 2 then
        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            0.06 * alpha)
        drawRoundedRect("fill", self.x, self.trackY - 4,
            fillW, self.trackHeight + 8, 5)
    end

    -- трек заливка с градиентом
    if fillW > 2 then
        -- основная заливка
        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            0.85 * alpha)
        drawRoundedRect("fill", self.x, self.trackY,
            fillW, self.trackHeight, 3)

        -- верхний блик
        love.graphics.setColor(1, 1, 1, 0.12 * alpha)
        drawRoundedRect("fill", self.x, self.trackY,
            fillW, self.trackHeight / 2, 2)

        -- пульсирующий блик на конце
        local pulse = 0.5 + 0.5 * math.sin(self.glowPhase * 2)
        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            0.3 * pulse * alpha)
        love.graphics.circle("fill",
            self.x + fillW, self.trackY + self.trackHeight / 2, 8)
    end

    -- засечки на треке
    for i = 0, 4 do
        local tickX = self.x + (i / 4) * self.width
        love.graphics.setColor(1, 1, 1, 0.04 * alpha)
        love.graphics.rectangle("fill", tickX, self.trackY + self.trackHeight + 3,
            1, 3)
    end

    -- ручка
    local kx = self.x + fillW
    local ky = self.trackY + self.trackHeight / 2
    local kr = self.knobRadius * self.knobScale

    -- свечение ручки
    if self.hover or self.dragging then
        local pulse = 0.5 + 0.5 * math.sin(self.glowPhase)
        local intensity = self.dragging and 1.2 or 0.8

        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            (0.05 + pulse * 0.04) * intensity * alpha)
        love.graphics.circle("fill", kx, ky, kr * 3.5)

        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            (0.08 + pulse * 0.06) * intensity * alpha)
        love.graphics.circle("fill", kx, ky, kr * 2)
    end

    -- тень ручки
    love.graphics.setColor(0, 0, 0, 0.45 * alpha)
    love.graphics.circle("fill", kx + 1, ky + 2, kr)

    -- ручка
    love.graphics.setColor(0.9, 0.9, 0.96, alpha)
    love.graphics.circle("fill", kx, ky, kr)

    -- блик
    love.graphics.setColor(1, 1, 1, 0.4 * alpha)
    love.graphics.ellipse("fill", kx - kr * 0.15, ky - kr * 0.2,
        kr * 0.45, kr * 0.3)

    -- обводка
    love.graphics.setColor(1, 1, 1, 0.15 * alpha)
    love.graphics.setLineWidth(1)
    love.graphics.circle("line", kx, ky, kr)

    -- внутренняя точка
    love.graphics.setColor(self.color[1], self.color[2], self.color[3], alpha)
    love.graphics.circle("fill", kx, ky, kr * 0.28)

    -- tooltip
    if self.tooltipAlpha > 0.01 then
        love.graphics.push()
        love.graphics.translate(kx, ky - kr - 18)
        love.graphics.scale(self.tooltipScale, self.tooltipScale)

        local ttText = string.format("%.0f", self.displayValue)
        local ttFont = UI_FONTS.small
        local ttW = ttFont:getWidth(ttText) + 12
        local ttH = 18

        -- tooltip фон
        love.graphics.setColor(0.08, 0.08, 0.14, 0.9 * self.tooltipAlpha * alpha)
        drawRoundedRect("fill", -ttW / 2, -ttH / 2, ttW, ttH, 4)

        -- tooltip обводка
        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
            0.3 * self.tooltipAlpha * alpha)
        drawRoundedRect("line", -ttW / 2, -ttH / 2, ttW, ttH, 4)

        -- tooltip текст
        love.graphics.setColor(1, 1, 1, self.tooltipAlpha * alpha)
        love.graphics.setFont(ttFont)
        love.graphics.printf(ttText, -ttW / 2, -ttH / 2 + 3, ttW, "center")

        -- стрелка
        love.graphics.setColor(0.08, 0.08, 0.14, 0.9 * self.tooltipAlpha * alpha)
        love.graphics.polygon("fill", -4, ttH / 2, 4, ttH / 2, 0, ttH / 2 + 4)

        love.graphics.pop()
    end

    love.graphics.pop()
end

---=== ДЕКОРАТИВНЫЕ ЛИНИИ (сканирование) ===---

local ScanLines = {}
ScanLines.__index = ScanLines

function ScanLines.new(x, y, w, h)
    local self = setmetatable({}, ScanLines)
    self.x, self.y, self.w, self.h = x, y, w, h
    self.scanY = 0
    self.speed = 40
    return self
end

function ScanLines:update(dt)
    self.scanY = (self.scanY + self.speed * dt) % self.h
end

function ScanLines:draw(alpha)
    alpha = alpha or 1

    -- тонкие горизонтальные линии
    love.graphics.setColor(1, 1, 1, 0.008 * alpha)
    for y = self.y, self.y + self.h, 3 do
        love.graphics.line(self.x, y, self.x + self.w, y)
    end

    -- бегущая линия сканирования
    local sy = self.y + self.scanY
    for i = 1, 5 do
        local a = 0.015 * (6 - i) / 5
        love.graphics.setColor(1, 1, 1, a * alpha)
        love.graphics.line(self.x, sy - i * 2, self.x + self.w, sy - i * 2)
        love.graphics.line(self.x, sy + i * 2, self.x + self.w, sy + i * 2)
    end
    love.graphics.setColor(1, 1, 1, 0.03 * alpha)
    love.graphics.line(self.x, sy, self.x + self.w, sy)
end

---=== ДЕКОРАТИВНЫЙ HEX-ПАТТЕРН ===---

local HexPattern = {}
HexPattern.__index = HexPattern

function HexPattern.new(x, y, w, h)
    local self = setmetatable({}, HexPattern)
    self.x, self.y, self.w, self.h = x, y, w, h
    self.hexes = {}

    local size = 20
    local rows = math.ceil(h / (size * 1.5)) + 1
    local cols = math.ceil(w / (size * 1.73)) + 1

    for row = 0, rows do
        for col = 0, cols do
            local hx = x + col * size * 1.73 + (row % 2) * size * 0.866
            local hy = y + row * size * 1.5
            if hx < x + w + size and hy < y + h + size then
                table.insert(self.hexes, {
                    x = hx, y = hy, size = size,
                    alpha = 0.005 + math.random() * 0.015,
                    phase = math.random() * math.pi * 2,
                    speed = 0.3 + math.random() * 1.5
                })
            end
        end
    end
    return self
end

function HexPattern:draw(t, alpha)
    alpha = alpha or 1
    for _, h in ipairs(self.hexes) do
        local a = h.alpha * (0.3 + 0.7 *
            math.sin(t * h.speed + h.phase) ^ 2) * alpha
        if a > 0.002 then
            love.graphics.setColor(0.5, 0.6, 1, a)
            self:_drawHex(h.x, h.y, h.size * 0.8)
        end
    end
end

function HexPattern:_drawHex(x, y, size)
    local vertices = {}
    for i = 0, 5 do
        local angle = math.rad(60 * i - 30)
        table.insert(vertices, x + size * math.cos(angle))
        table.insert(vertices, y + size * math.sin(angle))
    end
    if #vertices >= 6 then
        love.graphics.setLineWidth(0.5)
        love.graphics.polygon("line", vertices)
    end
end

---=== ГЛАВНЫЙ UI ===---

local UI = {}
UI.__index = UI

function UI.new()
    local self = setmetatable({}, UI)

    self.W, self.H = 660, 560
    self.particles = ParticleSystem.new()
    self.stars = BackgroundStars.new(80, self.W, self.H)
    self.scanLines = ScanLines.new(10, 10, self.W - 20, self.H - 20)
    self.hexPattern = HexPattern.new(10, 120, self.W - 20, self.H - 130)

    -- анимация открытия
    self.openProgress = 0
    self.openDuration = 0.5
    self.opened = false

    -- табы
    self.tabs = {
        { name = "AIMBOT",  color = hexToRGB("#00D4FF"), icon = "◎" },
        { name = "VISUALS", color = hexToRGB("#FF6B9D"), icon = "◈" },
        { name = "MISC",    color = hexToRGB("#FFD93D"), icon = "◆" },
        { name = "CONFIG",  color = hexToRGB("#8B5CF6"), icon = "◉" },
    }
    self.activeTab = 1
    self.underlineX = 0
    self.targetUnderlineX = 0
    self.underlineW = 90
    self.tabHovers = {}
    for i = 1, #self.tabs do
        self.tabHovers[i] = 0
    end

    -- параллакс
    self.parallaxX = 0
    self.parallaxY = 0

    -- обводка
    self.border = GlowBorder.new(10, 10, self.W - 20, self.H - 20,
        self.tabs[1].color, 18)

    -- контент
    self.tabContent = {}
    self:_createContent()

    -- статус
    self.statusPhase = 0

    -- глобальное время
    self.time = 0

    -- ambient glow
    self.ambientPhase = 0

    -- mouse trail
    self.mouseTrail = {}
    self.lastMX, self.lastMY = 0, 0

    return self
end

function UI:_createContent()
    local startY = 135
    local x = 55

    -- Tab 1: AIMBOT
    self.tabContent[1] = {
        toggles = {
            PremiumToggle.new(x, startY,       "Enable Aimbot",  self.tabs[1].color, self.particles),
            PremiumToggle.new(x, startY + 40,   "Silent Aim",     self.tabs[1].color, self.particles),
            PremiumToggle.new(x, startY + 80,   "Auto Fire",      self.tabs[1].color, self.particles),
            PremiumToggle.new(x, startY + 120,  "Prediction",     self.tabs[1].color, self.particles),
            PremiumToggle.new(x, startY + 160,  "Visible Check",  self.tabs[1].color, self.particles),
        },
        sliders = {
            PremiumSlider.new(x, startY + 210, 340, "FOV Radius",     5, 180, 90,  self.tabs[1].color, self.particles),
            PremiumSlider.new(x, startY + 268, 340, "Smoothness",     1, 100, 35,  self.tabs[1].color, self.particles),
            PremiumSlider.new(x, startY + 326, 340, "Reaction Time",  0, 500, 120, self.tabs[1].color, self.particles),
        }
    }

    -- Tab 2: VISUALS
    self.tabContent[2] = {
        toggles = {
            PremiumToggle.new(x, startY,       "ESP Box",       self.tabs[2].color, self.particles),
            PremiumToggle.new(x, startY + 40,   "Skeleton",      self.tabs[2].color, self.particles),
            PremiumToggle.new(x, startY + 80,   "Health Bar",    self.tabs[2].color, self.particles),
            PremiumToggle.new(x, startY + 120,  "Glow Outline",  self.tabs[2].color, self.particles),
            PremiumToggle.new(x, startY + 160,  "Tracers",       self.tabs[2].color, self.particles),
        },
        sliders = {
            PremiumSlider.new(x, startY + 210, 340, "Render Distance",  50, 500, 300, self.tabs[2].color, self.particles),
            PremiumSlider.new(x, startY + 268, 340, "Glow Intensity",    0, 100, 70,  self.tabs[2].color, self.particles),
        }
    }

    -- Tab 3: MISC
    self.tabContent[3] = {
        toggles = {
            PremiumToggle.new(x, startY,       "Bunny Hop",    self.tabs[3].color, self.particles),
            PremiumToggle.new(x, startY + 40,   "Auto Strafe",  self.tabs[3].color, self.particles),
            PremiumToggle.new(x, startY + 80,   "Radar Hack",   self.tabs[3].color, self.particles),
            PremiumToggle.new(x, startY + 120,  "No Recoil",    self.tabs[3].color, self.particles),
        },
        sliders = {
            PremiumSlider.new(x, startY + 175, 340, "Speed Multiplier", 1, 5, 1, self.tabs[3].color, self.particles),
        }
    }

    -- Tab 4: CONFIG
    self.tabContent[4] = {
        toggles = {
            PremiumToggle.new(x, startY,       "Auto-Save",     self.tabs[4].color, self.particles),
            PremiumToggle.new(x, startY + 40,   "Stream Proof",  self.tabs[4].color, self.particles),
            PremiumToggle.new(x, startY + 80,   "Panic Key",     self.tabs[4].color, self.particles),
            PremiumToggle.new(x, startY + 120,  "Watermark",     self.tabs[4].color, self.particles),
        },
        sliders = {}
    }

    -- скрыть неактивные, каскад для первого
    for i = 1, #self.tabContent do
        if i == 1 then
            self:_cascadeTab(i, 0.3) -- задержка для открытия окна
        else
            self:_setTabVisible(i, false)
        end
    end
end

function UI:_setTabVisible(tabIdx, visible)
    local content = self.tabContent[tabIdx]
    if not content then return end
    for _, t in ipairs(content.toggles) do t:setVisible(visible) end
    for _, s in ipairs(content.sliders) do s:setVisible(visible) end
end

function UI:_cascadeTab(tabIdx, baseDelay)
    local content = self.tabContent[tabIdx]
    if not content then return end
    baseDelay = baseDelay or 0
    local idx = 0
    for _, t in ipairs(content.toggles) do
        t:setVisible(true)
        t:cascadeIn(baseDelay + idx * 0.06)
        idx = idx + 1
    end
    for _, s in ipairs(content.sliders) do
        s:setVisible(true)
        s:cascadeIn(baseDelay + idx * 0.06)
        idx = idx + 1
    end
end

function UI:switchTab(idx)
    if idx == self.activeTab or idx < 1 or idx > #self.tabs then return end

    -- частицы при переключении
    local tabX = 35 + (idx - 1) * 120 + 45
    self.particles:emit(tabX, 100, 10, self.tabs[idx].color, 30, 0.5)

    self:_setTabVisible(self.activeTab, false)
    self.activeTab = idx
    self:_cascadeTab(idx)
    self.border:setColor(self.tabs[idx].color)
    self.targetUnderlineX = 35 + (idx - 1) * 120
end

function UI:update(dt)
    self.time = self.time + dt

    -- открытие
    if not self.opened then
        self.openProgress = math.min(1, self.openProgress + dt / self.openDuration)
        if self.openProgress >= 1 then
            self.opened = true
        end
    end

    self.statusPhase = self.statusPhase + dt
    self.ambientPhase = self.ambientPhase + dt

    -- параллакс
    local mx, my = love.mouse.getPosition()
    local cx, cy = self.W / 2, self.H / 2
    local tx = (mx - cx) / cx * 4
    local ty = (my - cy) / cy * 4
    self.parallaxX = lerp(self.parallaxX, tx, dt * 4)
    self.parallaxY = lerp(self.parallaxY, ty, dt * 4)

    -- mouse trail
    local dx = mx - self.lastMX
    local dy = my - self.lastMY
    local speed = math.sqrt(dx * dx + dy * dy)
    if speed > 3 then
        table.insert(self.mouseTrail, {
            x = mx, y = my,
            alpha = 0.15,
            size = math.min(speed * 0.08, 3),
            age = 0
        })
    end
    self.lastMX, self.lastMY = mx, my

    -- обновить trail
    local i = 1
    while i <= #self.mouseTrail do
        local t = self.mouseTrail[i]
        t.age = t.age + dt
        t.alpha = t.alpha * (1 - dt * 5)
        if t.alpha < 0.005 then
            table.remove(self.mouseTrail, i)
        else
            i = i + 1
        end
    end
    -- лимит
    while #self.mouseTrail > 50 do
        table.remove(self.mouseTrail, 1)
    end

    -- подчёркивание табов
    self.underlineX = lerp(self.underlineX, self.targetUnderlineX, dt * 14)

    -- tab hovers
    for j = 1, #self.tabs do
        local tabX = 35 + (j - 1) * 120
        local isHover = pointInRect(mx, my, tabX, 73, 90, 30)
        self.tabHovers[j] = lerp(self.tabHovers[j], isHover and 1 or 0, dt * 10)
    end

    -- обводка
    self.border:update(dt)

    -- сканлинии
    self.scanLines:update(dt)

    -- частицы
    self.particles:update(dt)

    -- контент
    local content = self.tabContent[self.activeTab]
    if content then
        for _, t in ipairs(content.toggles) do
            t:checkHover(mx, my)
            t:update(dt)
        end
        for _, s in ipairs(content.sliders) do
            s:checkHover(mx, my)
            s:update(dt)
        end
    end
end

function UI:draw()
    local t = self.time

    -- анимация открытия
    local openT = easeOutBack(clamp(self.openProgress, 0, 1))
    local openAlpha = clamp(self.openProgress * 2.5, 0, 1)
    local openScale = lerp(0.82, 1, openT)

    love.graphics.push()
    love.graphics.translate(self.W / 2, self.H / 2)
    love.graphics.scale(openScale, openScale)
    love.graphics.translate(-self.W / 2, -self.H / 2)

    -- параллакс
    love.graphics.translate(self.parallaxX, self.parallaxY)

    -- фон
    self:_drawBackground(t, openAlpha)

    -- hex pattern
    self.hexPattern:draw(t, openAlpha * 0.5)

    -- scan lines
    self.scanLines:draw(openAlpha)

    -- обводка
    self.border:draw()

    -- ambient glow в углах
    self:_drawAmbientGlow(t, openAlpha)

    -- заголовок
    self:_drawHeader(t, openAlpha)

    -- табы
    self:_drawTabs(t, openAlpha)

    -- разделитель
    self:_drawSeparator(116, openAlpha)

    -- контент
    local content = self.tabContent[self.activeTab]
    if content then
        for _, toggle in ipairs(content.toggles) do
            toggle:draw()
        end
        for _, slider in ipairs(content.sliders) do
            slider:draw()
        end
    end

    -- mouse trail
    self:_drawMouseTrail(openAlpha)

    -- частицы
    self.particles:draw()

    -- watermark
    self:_drawWatermark(openAlpha)

    love.graphics.pop()
end

function UI:_drawBackground(t, alpha)
    -- градиент
    for y = 0, self.H do
        local p = y / self.H
        local r = lerp(0.035, 0.06, p)
        local g = lerp(0.035, 0.045, p)
        local b = lerp(0.06, 0.09, p)
        love.graphics.setColor(r, g, b, alpha)
        love.graphics.line(0, y, self.W, y)
    end

    -- основной блок
    love.graphics.setColor(0.045, 0.045, 0.07, 0.92 * alpha)
    drawRoundedRect("fill", 10, 10, self.W - 20, self.H - 20, 18)

    -- звёзды
    self.stars:draw(t, alpha)
end

function UI:_drawAmbientGlow(t, alpha)
    local c = self.tabs[self.activeTab].color
    local pulse = 0.3 + 0.7 * math.sin(t * 0.8) ^ 2

    -- верхний левый
    love.graphics.setColor(c[1], c[2], c[3], 0.02 * pulse * alpha)
    love.graphics.circle("fill", 40, 40, 80)

    -- нижний правый
    love.graphics.setColor(c[1], c[2], c[3], 0.015 * pulse * alpha)
    love.graphics.circle("fill", self.W - 40, self.H - 40, 100)

    -- центральный верхний
    love.graphics.setColor(c[1], c[2], c[3], 0.01 * pulse * alpha)
    love.graphics.circle("fill", self.W / 2, 30, 120)
end

function UI:_drawHeader(t, alpha)
    local c = self.tabs[self.activeTab].color

    -- тень заголовка (3 слоя)
    love.graphics.setFont(UI_FONTS.title)
    love.graphics.setColor(0, 0, 0, 0.4 * alpha)
    love.graphics.printf("NEXUS", 2, 24, self.W, "center")
    love.graphics.setColor(0, 0, 0, 0.2 * alpha)
    love.graphics.printf("NEXUS", 3, 25, self.W, "center")

    -- основной текст
    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.printf("NEXUS", 0, 22, self.W, "center")

    -- неоновое наложение
    local neonPulse = 0.3 + 0.7 * (0.5 + 0.5 * math.sin(t * 2))
    love.graphics.setColor(c[1], c[2], c[3], 0.25 * neonPulse * alpha)
    love.graphics.printf("NEXUS", 0, 22, self.W, "center")

    -- свечение под текстом
    love.graphics.setColor(c[1], c[2], c[3], 0.04 * neonPulse * alpha)
    love.graphics.circle("fill", self.W / 2, 35, 60)

    -- подзаголовок
    love.graphics.setColor(0.32, 0.32, 0.44, alpha)
    love.graphics.setFont(UI_FONTS.tiny)
    love.graphics.printf("P R E M I U M  ·  E D I T I O N  ·  v2.0", 0, 48, self.W, "center")

    -- rainbow подзаголовок (тонкий)
    local hue = (t * 0.1) % 1
    local rr, rg, rb = hsvToRGB(hue, 0.5, 1)
    love.graphics.setColor(rr, rg, rb, 0.08 * alpha)
    love.graphics.printf("P R E M I U M  ·  E D I T I O N  ·  v2.0", 0, 48, self.W, "center")

    -- разделитель верхний
    self:_drawSeparator(66, alpha)

    -- статус
    local pulse = 0.5 + 0.5 * math.sin(self.statusPhase * 2.5)
    local dotSize = 3.5 + pulse * 1.8

    -- свечение статуса (многослойное)
    for i = 4, 1, -1 do
        love.graphics.setColor(0, 1, 0.53, (0.03 + pulse * 0.02) / i * alpha)
        love.graphics.circle("fill", self.W - 48, 28, dotSize * i * 1.5)
    end

    love.graphics.setColor(0, 1, 0.53, (0.8 + pulse * 0.2) * alpha)
    love.graphics.circle("fill", self.W - 48, 28, dotSize)

    love.graphics.setColor(1, 1, 1, 0.7 * alpha)
    love.graphics.circle("fill", self.W - 48, 28, dotSize * 0.35)

    love.graphics.setColor(0, 1, 0.53, 0.7 * alpha)
    love.graphics.setFont(UI_FONTS.tiny)
    love.graphics.printf("ACTIVE", 0, 23, self.W - 58, "right")

    -- ping
    love.graphics.setColor(0, 1, 0.53, 0.4 * alpha)
    love.graphics.printf("12ms", 0, 33, self.W - 58, "right")
end

function UI:_drawSeparator(y, alpha)
    local c = self.tabs[self.activeTab].color

    -- основная линия
    love.graphics.setColor(0.1, 0.1, 0.16, alpha)
    love.graphics.setLineWidth(1)
    love.graphics.line(30, y, self.W - 30, y)

    -- цветной акцент в центре
    local centerW = 120
    love.graphics.setColor(c[1], c[2], c[3], 0.15 * alpha)
    love.graphics.line(self.W / 2 - centerW / 2, y, self.W / 2 + centerW / 2, y)

    -- точка в центре
    love.graphics.setColor(c[1], c[2], c[3], 0.3 * alpha)
    love.graphics.circle("fill", self.W / 2, y, 1.5)
end

function UI:_drawTabs(t, alpha)
    local tabY = 78
    local tabStartX = 35
    local tabSpacing = 120
    local tabW = 90

    for i, tab in ipairs(self.tabs) do
        local tx = tabStartX + (i - 1) * tabSpacing
        local hoverAmt = self.tabHovers[i] or 0
        local isActive = (i == self.activeTab)

        -- hover фон
        if hoverAmt > 0.01 then
            love.graphics.setColor(tab.color[1], tab.color[2], tab.color[3],
                0.03 * hoverAmt * alpha)
            drawRoundedRect("fill", tx - 4, tabY - 4, tabW + 8, 26, 6)
        end

        -- текст
        if isActive then
            love.graphics.setColor(1, 1, 1, alpha)
        else
            local a = lerp(0.35, 0.75, hoverAmt)
            love.graphics.setColor(a, a, a + 0.05, alpha)
        end

        love.graphics.setFont(UI_FONTS.tab)
        local icon = tab.icon or ""
        local text = icon .. " " .. tab.name
        local textW = UI_FONTS.tab:getWidth(text)
        love.graphics.print(text, tx + (tabW - textW) / 2, tabY + 1)

        -- свечение активного текста
        if isActive then
            love.graphics.setColor(tab.color[1], tab.color[2], tab.color[3],
                0.2 * alpha)
            love.graphics.print(text, tx + (tabW - textW) / 2, tabY + 1)
        end
    end

    -- подчёркивание
    local underColor = self.tabs[self.activeTab].color

    -- широкое свечение
    love.graphics.setColor(underColor[1], underColor[2], underColor[3],
        0.08 * alpha)
    drawRoundedRect("fill", self.underlineX - 4, tabY + 24, tabW + 8, 8, 4)

    -- основная линия
    love.graphics.setColor(underColor[1], underColor[2], underColor[3],
        0.9 * alpha)
    drawRoundedRect("fill", self.underlineX, tabY + 26, tabW, 2.5, 1.5)

    -- яркий центр
    love.graphics.setColor(1, 1, 1, 0.35 * alpha)
    drawRoundedRect("fill", self.underlineX + tabW * 0.15, tabY + 26,
        tabW * 0.7, 1, 1)

    -- точки на концах
    love.graphics.setColor(underColor[1], underColor[2], underColor[3], 0.6 * alpha)
    love.graphics.circle("fill", self.underlineX + 2, tabY + 27, 1.5)
    love.graphics.circle("fill", self.underlineX + tabW - 2, tabY + 27, 1.5)
end

function UI:_drawMouseTrail(alpha)
    local c = self.tabs[self.activeTab].color
    for _, t in ipairs(self.mouseTrail) do
        love.graphics.setColor(c[1], c[2], c[3], t.alpha * alpha)
        love.graphics.circle("fill", t.x, t.y, t.size)
    end
end

function UI:_drawWatermark(alpha)
    love.graphics.setColor(0.25, 0.25, 0.35, 0.4 * alpha)
    love.graphics.setFont(UI_FONTS.tiny)
    love.graphics.print("FPS: " .. love.timer.getFPS() ..
        "  |  Particles: " .. #self.particles.particles ..
        "  |  NEXUS PRO v2.0", 25, self.H - 25)

    -- время
    local timeStr = os.date("%H:%M:%S")
    love.graphics.printf(timeStr, 0, self.H - 25, self.W - 25, "right")
end

function UI:mousepressed(x, y, button)
    if button ~= 1 then return end

    -- табы
    local tabY = 78
    local tabStartX = 35
    local tabSpacing = 120
    local tabW = 90

    for i = 1, #self.tabs do
        local tx = tabStartX + (i - 1) * tabSpacing
        if pointInRect(x, y, tx, tabY - 5, tabW, 30) then
            self:switchTab(i)
            return
        end
    end

    -- контент
    local content = self.tabContent[self.activeTab]
    if content then
        for _, toggle in ipairs(content.toggles) do
            if toggle.hover and toggle.visible then
                toggle:click()
            end
        end
        for _, slider in ipairs(content.sliders) do
            slider:press(x, y)
        end
    end
end

function UI:mousereleased(x, y, button)
    if button ~= 1 then return end
    local content = self.tabContent[self.activeTab]
    if content then
        for _, slider in ipairs(content.sliders) do
            slider:release()
        end
    end
end

function UI:mousemoved(x, y, dx, dy)
    local content = self.tabContent[self.activeTab]
    if content then
        for _, slider in ipairs(content.sliders) do
            slider:drag(x)
        end
    end
end

---=== LÖVE CALLBACKS ===---

local ui

love = love or {}

function love.load()
    love.window.setTitle("NEXUS PRO v2.0")
    love.window.setMode(660, 560, {
        resizable = false,
        vsync = 1,
        msaa = 4
    })

    -- шрифты (безопасное создание)
    UI_FONTS = {
        title  = love.graphics.newFont(24),
        tab    = love.graphics.newFont(11),
        normal = love.graphics.newFont(12),
        bold   = love.graphics.newFont(12),
        small  = love.graphics.newFont(9),
        tiny   = love.graphics.newFont(8),
    }

    love.graphics.setBackgroundColor(0.025, 0.025, 0.04)
    love.graphics.setLineStyle("smooth")

    ui = UI.new()
    ui.underlineX = 35
    ui.targetUnderlineX = 35
end

function love.update(dt)
    dt = math.min(dt, 0.05)
    ui:update(dt)
end

function love.draw()
    ui:draw()
end

function love.mousepressed(x, y, button)
    ui:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    ui:mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    ui:mousemoved(x, y, dx, dy)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
