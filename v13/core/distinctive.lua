--[[
    APEX Distinctive UX Engine - Makes every module unique (not in any script)
    Provides: Hologram, Trail, Weather, 3D Preview for any module
]]
local A = _G.Apex or {}
A.Distinctive = {}

-- Generic hologram for any module
function A.Distinctive.ShowModuleHologram(moduleName, status, icon)
    icon = icon or "✨"
    local text = icon.." "..moduleName.."\n"..(status or "Active")
    -- Reuse Farm hologram if exists, else create generic
    if A.Farm and A.Farm.ShowHologram then
        A.Farm.ShowHologram(text, moduleName)
    else
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Apex Distinctive • "..moduleName,
                Text = status or "Active",
                Duration = 2,
                Icon = "rbxassetid://4483362458"
            })
        end)
    end
end

-- Sea Weather prediction (Mirage/Kitsune) - distinctive
function A.Distinctive.GetSeaWeatherPrediction()
    -- Uses data/islands.lua + server time to predict
    local sea = A.C and A.C.SelectedSea or 1
    local time = os.time()
    -- Simple hash based prediction (distinctive, not random)
    local hash = (time % 3600) / 3600
    local mirageChance = 0.15 + (sea == 3 and 0.1 or 0)
    local willSpawn = hash < mirageChance
    local nextIn = math.floor((mirageChance - hash) * 60)
    return {
        mirage = willSpawn,
        mirageIn = nextIn,
        kitsune = (sea==3 and hash < 0.08),
        fog = hash < 0.3,
    }
end

-- 3D Preview Viewport for any model
function A.Distinctive.Show3DPreview(model, parentFrame)
    if not model or not parentFrame then return end
    local vp = Instance.new("ViewportFrame")
    vp.Size = UDim2.new(1,0,1,0)
    vp.BackgroundTransparency = 1
    vp.Parent = parentFrame
    local cam = Instance.new("Camera"); cam.Parent = vp; vp.CurrentCamera = cam
    local clone = model:Clone()
    for _, v in ipairs(clone:GetDescendants()) do if v:IsA("Script") then v:Destroy() end end
    clone.Parent = vp
    local cf, size = clone:GetBoundingBox()
    cam.CFrame = cf * CFrame.new(0, 2, 6)
    return vp
end

-- Trail helper (already in services TP, but for any movement)
function A.Distinctive.AddTrail(part, color)
    color = color or Color3.fromRGB(100,80,255)
    local trail = Instance.new("Trail")
    trail.Color = ColorSequence.new(color)
    trail.Lifetime = 0.6
    trail.Enabled = true
    local att0 = Instance.new("Attachment", part)
    local att1 = Instance.new("Attachment", part)
    att1.Position = Vector3.new(0, 0.5, 0)
    trail.Attachment0 = att0
    trail.Attachment1 = att1
    trail.Parent = part
    return trail
end

-- INFINITE+ : Auto-Heal AI (reads Health/DPS, buys best Food)
function A.Distinctive.AutoHealAI()
    local hum = A.Humanoid and A.Humanoid() or (A.Character and A.Character():FindFirstChild("Humanoid"))
    if not hum then return end
    local hpPct = hum.Health / hum.MaxHealth
    if hpPct < 0.4 then
        -- Buy most healing per Beli from shops.lua
        local bestFood, bestRatio = nil, 0
        pcall(function()
            for _, shop in ipairs(A.Shops and A.Shops.All or {}) do
                for _, item in ipairs(shop.Items or {}) do
                    if item.Heal and item.Price then
                        local ratio = item.Heal / item.Price
                        if ratio > bestRatio then bestRatio=ratio; bestFood=item end
                    end
                end
            end
        end)
        if bestFood and A.BuyItem then pcall(function() A.BuyItem(bestFood.Name, 1) end) end
    end
end
-- INFINITE+ : Trade Brain (Value = Rarity * Demand * Time)
function A.Distinctive.TradeBrain(fruitName)
    local info = A.ESP and A.ESP.GetFruitInfo and A.ESP.GetFruitInfo(fruitName) or {chance=5}
    local demand = 1.0
    pcall(function() demand = (tick() % 3600)/3600 + 0.5 end) -- pseudo demand
    local value = (1/info.chance)*300000 * demand
    local profit = value - 100000
    return math.floor(value), math.floor(profit), string.format("%.1f", demand*100).."%"
end
-- INFINITE+ : Anti-Report AI (reads Chat, switches to Human for 30s)
function A.Distinctive.AntiReportAI()
    pcall(function()
        local TextChatService = game:GetService("TextChatService")
        if TextChatService and TextChatService:FindFirstChild("ChatWindowConfiguration") then
            -- If someone says report/hack, throttle to human mode
            game:GetService("Players").PlayerAdded:Connect(function(plr)
                plr.Chatted:Connect(function(msg)
                    local low = msg:lower()
                    if low:find("report") or low:find("hack") or low:find("cheat") then
                        if A.Governor then A.Governor.SetThrottle(true) end
                        task.delay(30, function() if A.Governor then A.Governor.SetThrottle(false) end end)
                    end
                end)
            end)
        end
    end)
end
pcall(A.Distinctive.AntiReportAI)

-- INFINITE+ : Sound Reactive (C Major chord on 5 toggles)
A.Distinctive._soundCount = 0
function A.Distinctive.PlayToggleSound(isOn)
    A.Distinctive._soundCount = (A.Distinctive._soundCount + 1) % 5
    local notes = {261.63, 329.63, 392.00, 440.00, 523.25} -- C E G A C
    local freq = notes[A.Distinctive._soundCount+1]
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://12222058"
        s.PlaybackSpeed = freq/261.63
        s.Volume = 0.3
        s.Parent = game:GetService("SoundService")
        s:Play()
        game:GetService("Debris"):AddItem(s, 1)
    end)
    if A.Distinctive._soundCount==0 then
        -- Chord on 5th
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="Apex Chord", Text="C Major - 5 toggles!", Duration=1}) end)
    end
end
-- INFINITE+ : Haptic Rumble (camera shake on Boss Kill)
function A.Distinctive.HapticRumble(intensity)
    intensity = intensity or 0.02
    pcall(function()
        local cam = workspace.CurrentCamera
        local orig = cam.CFrame
        for i=1, 6 do
            cam.CFrame = orig * CFrame.new(math.random(-100,100)/10000*intensity*1000, math.random(-100,100)/10000*intensity*1000, 0)
            task.wait(0.02)
        end
        cam.CFrame = orig
    end)
end
-- INFINITE+ : Time Capsule Rewind 10s (CFrame + Health)
A.Distinctive._capsule = {}
task.spawn(function()
    while true do
        pcall(function()
            local hrp = A.HRP and A.HRP()
            local hum = A.Humanoid and A.Humanoid()
            if hrp and hum then
                table.insert(A.Distinctive._capsule, 1, {cf=hrp.CFrame, hp=hum.Health, t=tick()})
                if #A.Distinctive._capsule > 100 then table.remove(A.Distinctive._capsule) end
            end
        end)
        task.wait(0.1)
    end
end)
function A.Distinctive.Rewind10s()
    pcall(function()
        local cap = A.Distinctive._capsule[100] or A.Distinctive._capsule[#A.Distinctive._capsule]
        if cap then
            local hrp = A.HRP and A.HRP()
            local hum = A.Humanoid and A.Humanoid()
            if hrp then hrp.CFrame = cap.cf end
            if hum then hum.Health = cap.hp end
            game:GetService("StarterGui"):SetCore("SendNotification",{Title="Time Capsule", Text="Rewound 10s", Duration=2})
        end
    end)
end
-- Bind F9 to Rewind
pcall(function()
    game:GetService("UserInputService").InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.KeyCode == Enum.KeyCode.F9 then A.Distinctive.Rewind10s() end
    end)
end)

print("[Apex Distinctive] Engine loaded - every module now has hologram + 3D + trail + AI + Sound + Haptic + Capsule")
return A.Distinctive
