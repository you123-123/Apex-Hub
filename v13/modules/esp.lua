local A = _G.Apex
local ESP = {}
ESP.Active = false
ESP.Drawings = {}
ESP.ESPCount = 0
ESP._loop = nil
ESP._startTick = 0
ESP._enabledTypes = {
    Players = true,
    Chests = false,
    Fruits = true,
    Mobs = false,
    Bosses = true,
    Quests = false,
    SeaEvents = false
}
ESP._settings = {
    Range = 2000,
    ShowHealth = true,
    ShowDistance = true,
    ShowName = true,
    ShowWeapon = true,
    ShowLevel = true,
    ShowBounty = false,
    ShowTracer = false,
    ShowBox = true,
    ShowSkeleton = false,
    ShowHealthBar = true,
    BoxStyle = "Corner",
    TracerOrigin = "Bottom",
    TextSize = 14,
    TextFont = 2,
    MaxESPDistance = 3000,
    UpdateRate = 0.1,
    ESPColor = Color3.fromRGB(255, 255, 255),
    EnemyColor = Color3.fromRGB(255, 0, 0),
    FriendlyColor = Color3.fromRGB(0, 255, 0),
    ChestColor = Color3.fromRGB(255, 255, 0),
    FruitColor = Color3.fromRGB(255, 0, 255),
    MobColor = Color3.fromRGB(255, 128, 0),
    BossColor = Color3.fromRGB(255, 0, 128),
    QuestColor = Color3.fromRGB(128, 255, 128),
    SeaEventColor = Color3.fromRGB(0, 128, 255)
}
ESP._playerCache = {}
ESP._objectCache = {}
ESP._lastUpdate = 0
ESP._totalDrawings = 0
ESP._maxDrawings = 200

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Apex ESP] Error: " .. tostring(err))
    end
    return ok, err
end

local function CreateDrawing(className, properties)
    if not Drawing or not Drawing.new then return nil end
    local ok, drawing = pcall(Drawing.new, className)
    if not ok or not drawing then return nil end
    if properties then
        for prop, val in pairs(properties) do
            pcall(function()
                drawing[prop] = val
            end)
        end
    end
    return drawing
end

function ESP.DrawBox(corners, color, thickness, visible)
    local box = CreateDrawing("Quad", {
        PointA = corners[1],
        PointB = corners[2],
        PointC = corners[3],
        PointD = corners[4],
        Color = color or ESP._settings.ESPColor,
        Thickness = thickness or 1,
        Visible = visible or false,
        Filled = false,
        Transparency = 1
    })
    return box
end

function ESP.DrawText(position, text, color, size, font, visible)
    local txt = CreateDrawing("Text", {
        Position = position,
        Text = text,
        Color = color or ESP._settings.ESPColor,
        Size = size or ESP._settings.TextSize,
        Font = font or ESP._settings.TextFont,
        Visible = visible or false,
        Center = true,
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0)
    })
    return txt
end

function ESP.DrawLine(from, to, color, thickness, visible)
    local line = CreateDrawing("Line", {
        From = from,
        To = to,
        Color = color or ESP._settings.ESPColor,
        Thickness = thickness or 1,
        Visible = visible or false,
        Transparency = 1
    })
    return line
end

function ESP.DrawTracer(from, to, color, thickness, visible)
    local tracer = CreateDrawing("Line", {
        From = from,
        To = to,
        Color = color or ESP._settings.ESPColor,
        Thickness = thickness or 1,
        Visible = visible or false,
        Transparency = 0.7
    })
    return tracer
end

function ESP.DrawHealthBar(position, health, maxHealth, height, visible)
    local barWidth = 4
    local healthPct = math.clamp(health / math.max(maxHealth, 1), 0, 1)
    local bgColor = CreateDrawing("Square", {
        Position = position - Vector2.new(barWidth / 2 + 1, 0),
        Size = Vector2.new(barWidth + 2, height),
        Color = Color3.fromRGB(0, 0, 0),
        Filled = true,
        Visible = visible or false,
        Transparency = 0.5
    })
    local healthColor = Color3.fromRGB(
        255 * (1 - healthPct),
        255 * healthPct,
        0
    )
    local healthBar = CreateDrawing("Square", {
        Position = position - Vector2.new(barWidth / 2, height * (1 - healthPct)),
        Size = Vector2.new(barWidth, height * healthPct),
        Color = healthColor,
        Filled = true,
        Visible = visible or false,
        Transparency = 0.8
    })
    return bgColor, healthBar
end

function ESP.DrawSkeleton(joints, color, thickness, visible)
    local skeletonLines = {}
    local bonePairs = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
    }
    for _, pair in ipairs(bonePairs) do
        local jointA = joints[pair[1]]
        local jointB = joints[pair[2]]
        if jointA and jointB then
            local screenA, onScreenA = Camera:WorldToViewportPoint(jointA)
            local screenB, onScreenB = Camera:WorldToViewportPoint(jointB)
            if onScreenA and onScreenB then
                local line = ESP.DrawLine(
                    Vector2.new(screenA.X, screenA.Y),
                    Vector2.new(screenB.X, screenB.Y),
                    color or ESP._settings.ESPColor,
                    thickness or 1,
                    visible
                )
                table.insert(skeletonLines, line)
            end
        end
    end
    return skeletonLines
end

function ESP.GetESPColor(player)
    if player == Players.LocalPlayer then
        return ESP._settings.FriendlyColor
    end
    return ESP._settings.EnemyColor
end

function ESP.SetESPColor(espType, color)
    if ESP._settings[espType .. "Color"] then
        ESP._settings[espType .. "Color"] = color
    end
end

function ESP.SetRange(range)
    ESP._settings.Range = range
    ESP._settings.MaxESPDistance = range
end

function ESP.ToggleType(espType, enabled)
    if ESP._enabledTypes[espType] ~= nil then
        ESP._enabledTypes[espType] = enabled
    end
end

function ESP.AddPlayer(player)
    if not player or player == Players.LocalPlayer then return end
    if ESP._playerCache[player] then return end
    ESP._playerCache[player] = {
        Player = player,
        Drawings = {},
        LastUpdate = 0
    }
    ESP.ESPCount = ESP.ESPCount + 1
end

function ESP.RemovePlayer(player)
    if ESP._playerCache[player] then
        local data = ESP._playerCache[player]
        for _, drawing in ipairs(data.Drawings) do
            pcall(function()
                if drawing and drawing.Remove then
                    drawing:Remove()
                end
            end)
        end
        ESP._playerCache[player] = nil
        ESP.ESPCount = ESP.ESPCount - 1
    end
end

function ESP.UpdatePlayer(player)
    if not ESP._enabledTypes.Players then return end
    if not player or not player.Character then return end
    if not ESP._playerCache[player] then
        ESP.AddPlayer(player)
    end
    local data = ESP._playerCache[player]
    if not data then return end
    local char = player.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then
        for _, d in ipairs(data.Drawings) do
            pcall(function() if d and d.Remove then d.Visible = false end end)
        end
        return
    end
    local myHRP = A.HRP()
    if not myHRP then return end
    local dist = (myHRP.Position - hrp.Position).Magnitude
    if dist > ESP._settings.MaxESPDistance then
        for _, d in ipairs(data.Drawings) do
            pcall(function() if d and d.Remove then d.Visible = false end end)
        end
        return
    end
    local rootPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    if not onScreen then
        for _, d in ipairs(data.Drawings) do
            pcall(function() if d and d.Remove then d.Visible = false end end)
        end
        return
    end
    local color = ESP.GetESPColor(player)
    for _, d in ipairs(data.Drawings) do
        pcall(function()
            if d and d.Remove then d:Remove() end
        end)
    end
    data.Drawings = {}
    if ESP._settings.ShowBox then
        local pos, size
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local topPos, topOnScreen = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3, 0))
            local botPos, botOnScreen = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, -3, 0))
            if topOnScreen and botOnScreen then
                local height = math.abs(topPos.Y - botPos.Y)
                local width = height * 0.6
                local topLeft = Vector2.new(rootPos.X - width / 2, rootPos.Y - height / 2)
                local topRight = Vector2.new(rootPos.X + width / 2, rootPos.Y - height / 2)
                local botRight = Vector2.new(rootPos.X + width / 2, rootPos.Y + height / 2)
                local botLeft = Vector2.new(rootPos.X - width / 2, rootPos.Y + height / 2)
                local box = ESP.DrawBox({topLeft, topRight, botRight, botLeft}, color, 1, true)
                table.insert(data.Drawings, box)
            end
        end)
    end
    local textY = rootPos.Y - 20
    if ESP._settings.ShowName then
        local nameText = ESP.DrawText(
            Vector2.new(rootPos.X, textY),
            player.DisplayName or player.Name,
            color,
            ESP._settings.TextSize,
            ESP._settings.TextFont,
            true
        )
        table.insert(data.Drawings, nameText)
        textY = textY - ESP._settings.TextSize - 2
    end
    if ESP._settings.ShowLevel then
        local level = 0
        local levelVal = player:FindFirstChild("Level")
        if levelVal and levelVal:IsA("ValueBase") then
            level = tonumber(levelVal.Value) or 0
        end
        if level > 0 then
            local levelText = ESP.DrawText(
                Vector2.new(rootPos.X, textY),
                "Lv. " .. tostring(level),
                color,
                ESP._settings.TextSize - 2,
                ESP._settings.TextFont,
                true
            )
            table.insert(data.Drawings, levelText)
            textY = textY - ESP._settings.TextSize
        end
    end
    if ESP._settings.ShowBounty then
        local bounty = 0
        local ls = player:FindFirstChild("leaderstats")
        if ls then
            local bv = ls:FindFirstChild("Bounty/Honor") or ls:FindFirstChild("Bounty")
            if bv and bv:IsA("ValueBase") then
                bounty = tonumber(bv.Value) or 0
            end
        end
        if bounty > 0 then
            local bountyText = ESP.DrawText(
                Vector2.new(rootPos.X, textY),
                "$" .. tostring(bounty),
                Color3.fromRGB(255, 255, 0),
                ESP._settings.TextSize - 2,
                ESP._settings.TextFont,
                true
            )
            table.insert(data.Drawings, bountyText)
            textY = textY - ESP._settings.TextSize
        end
    end
    if ESP._settings.ShowDistance then
        local distText = ESP.DrawText(
            Vector2.new(rootPos.X, rootPos.Y + 20),
            tostring(math.floor(dist)) .. "m",
            Color3.fromRGB(200, 200, 200),
            ESP._settings.TextSize - 2,
            ESP._settings.TextFont,
            true
        )
        table.insert(data.Drawings, distText)
    end
    if ESP._settings.ShowWeapon then
        local weapon = nil
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                weapon = tool.Name
                break
            end
        end
        if weapon then
            local weaponText = ESP.DrawText(
                Vector2.new(rootPos.X, rootPos.Y + 35),
                weapon,
                Color3.fromRGB(200, 200, 200),
                ESP._settings.TextSize - 2,
                ESP._settings.TextFont,
                true
            )
            table.insert(data.Drawings, weaponText)
        end
    end
    if ESP._settings.ShowHealthBar then
        local barHeight = 40
        local barX = rootPos.X - 30
        local barY = rootPos.Y - barHeight / 2
        local bgBar, hpBar = ESP.DrawHealthBar(
            Vector2.new(barX, barY),
            hum.Health,
            hum.MaxHealth,
            barHeight,
            true
        )
        table.insert(data.Drawings, bgBar)
        table.insert(data.Drawings, hpBar)
    end
    if ESP._settings.ShowTracer then
        local tracerOrigin = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        if ESP._settings.TracerOrigin == "Top" then
            tracerOrigin = Vector2.new(Camera.ViewportSize.X / 2, 0)
        elseif ESP._settings.TracerOrigin == "Center" then
            tracerOrigin = Camera.ViewportSize / 2
        end
        local tracer = ESP.DrawTracer(
            tracerOrigin,
            Vector2.new(rootPos.X, rootPos.Y),
            color,
            1,
            true
        )
        table.insert(data.Drawings, tracer)
    end
end

function ESP.AddChest(chest)
    if not chest or not chest:IsA("Model") then return end
    local pos = chest.PrimaryPart and chest.PrimaryPart.Position or chest:FindFirstChildWhichIsA("BasePart") and chest:FindFirstChildWhichIsA("BasePart").Position
    if not pos then return end
    ESP._objectCache["chest_" .. chest:GetFullName()] = {
        Object = chest,
        Position = pos,
        Type = "Chest",
        Drawings = {}
    }
end

function ESP.RemoveChest(chest)
    local key = "chest_" .. chest:GetFullName()
    if ESP._objectCache[key] then
        for _, d in ipairs(ESP._objectCache[key].Drawings) do
            pcall(function() if d and d.Remove then d:Remove() end end)
        end
        ESP._objectCache[key] = nil
    end
end

function ESP.AddFruit(fruit)
    if not fruit then return end
    local pos = fruit:IsA("BasePart") and fruit.Position or (fruit.PrimaryPart and fruit.PrimaryPart.Position)
    if not pos then return end
    ESP._objectCache["fruit_" .. fruit:GetFullName()] = {
        Object = fruit,
        Position = pos,
        Type = "Fruit",
        Drawings = {}
    }
end

function ESP.RemoveFruit(fruit)
    local key = "fruit_" .. fruit:GetFullName()
    if ESP._objectCache[key] then
        for _, d in ipairs(ESP._objectCache[key].Drawings) do
            pcall(function() if d and d.Remove then d:Remove() end end)
        end
        ESP._objectCache[key] = nil
    end
end

function ESP.AddMob(mob)
    if not mob or not mob:IsA("Model") then return end
    local hrp = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
    if not hrp then return end
    ESP._objectCache["mob_" .. mob:GetFullName()] = {
        Object = mob,
        Position = hrp.Position,
        Type = "Mob",
        Drawings = {}
    }
end

function ESP.RemoveMob(mob)
    local key = "mob_" .. mob:GetFullName()
    if ESP._objectCache[key] then
        for _, d in ipairs(ESP._objectCache[key].Drawings) do
            pcall(function() if d and d.Remove then d:Remove() end end)
        end
        ESP._objectCache[key] = nil
    end
end

function ESP.AddBoss(boss)
    if not boss or not boss:IsA("Model") then return end
    local hrp = boss:FindFirstChild("HumanoidRootPart") or boss.PrimaryPart
    if not hrp then return end
    ESP._objectCache["boss_" .. boss:GetFullName()] = {
        Object = boss,
        Position = hrp.Position,
        Type = "Boss",
        Drawings = {}
    }
end

function ESP.RemoveBoss(boss)
    local key = "boss_" .. boss:GetFullName()
    if ESP._objectCache[key] then
        for _, d in ipairs(ESP._objectCache[key].Drawings) do
            pcall(function() if d and d.Remove then d:Remove() end end)
        end
        ESP._objectCache[key] = nil
    end
end

function ESP.UpdateObjectESP(key, data, color)
    if not data or not data.Object or not data.Object.Parent then
        if data and data.Drawings then
            for _, d in ipairs(data.Drawings) do
                pcall(function() if d and d.Remove then d:Remove() end end)
            end
        end
        ESP._objectCache[key] = nil
        return
    end
    local pos = data.Object.PrimaryPart and data.Object.PrimaryPart.Position
    if not pos then
        local part = data.Object:FindFirstChildWhichIsA("BasePart")
        if part then pos = part.Position end
    end
    if not pos then return end
    local myHRP = A.HRP()
    if not myHRP then return end
    local dist = (myHRP.Position - pos).Magnitude
    if dist > ESP._settings.MaxESPDistance then
        for _, d in ipairs(data.Drawings) do
            pcall(function() if d and d.Remove then d.Visible = false end end)
        end
        return
    end
    local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
    if not onScreen then
        for _, d in ipairs(data.Drawings) do
            pcall(function() if d and d.Remove then d.Visible = false end end)
        end
        return
    end
    for _, d in ipairs(data.Drawings) do
        pcall(function() if d and d.Remove then d:Remove() end end)
    end
    data.Drawings = {}
    local nameText = ESP.DrawText(
        Vector2.new(screenPos.X, screenPos.Y - 20),
        data.Object.Name,
        color,
        ESP._settings.TextSize,
        ESP._settings.TextFont,
        true
    )
    table.insert(data.Drawings, nameText)
    local distText = ESP.DrawText(
        Vector2.new(screenPos.X, screenPos.Y),
        tostring(math.floor(dist)) .. "m",
        Color3.fromRGB(200, 200, 200),
        ESP._settings.TextSize - 2,
        ESP._settings.TextFont,
        true
    )
    table.insert(data.Drawings, distText)
end

function ESP.UpdateAll()
    Camera = Workspace.CurrentCamera
    if not Camera then return end
    if ESP._enabledTypes.Players then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                ESP.UpdatePlayer(player)
            end
        end
    end
    if ESP._enabledTypes.Chests then
        for key, data in pairs(ESP._objectCache) do
            if data.Type == "Chest" then
                ESP.UpdateObjectESP(key, data, ESP._settings.ChestColor)
            end
        end
    end
    if ESP._enabledTypes.Fruits then
        for key, data in pairs(ESP._objectCache) do
            if data.Type == "Fruit" then
                ESP.UpdateObjectESP(key, data, ESP._settings.FruitColor)
            end
        end
    end
    if ESP._enabledTypes.Mobs then
        for key, data in pairs(ESP._objectCache) do
            if data.Type == "Mob" then
                ESP.UpdateObjectESP(key, data, ESP._settings.MobColor)
            end
        end
    end
    if ESP._enabledTypes.Bosses then
        for key, data in pairs(ESP._objectCache) do
            if data.Type == "Boss" then
                ESP.UpdateObjectESP(key, data, ESP._settings.BossColor)
            end
        end
    end
end

function ESP.ClearAll()
    for _, data in pairs(ESP._playerCache) do
        for _, d in ipairs(data.Drawings) do
            pcall(function() if d and d.Remove then d:Remove() end end)
        end
    end
    ESP._playerCache = {}
    for key, data in pairs(ESP._objectCache) do
        for _, d in ipairs(data.Drawings) do
            pcall(function() if d and d.Remove then d:Remove() end end)
        end
    end
    ESP._objectCache = {}
    ESP.ESPCount = 0
    ESP._totalDrawings = 0
end

function ESP.GetESPStats()
    local objectCount = 0
    for _ in pairs(ESP._objectCache) do
        objectCount = objectCount + 1
    end
    return {
        Active = ESP.Active,
        PlayerESP = ESP.ESPCount,
        ObjectESP = objectCount,
        TotalDrawings = ESP._totalDrawings,
        EnabledTypes = ESP._enabledTypes,
        Settings = ESP._settings
    }
end

function ESP.MainLoop()
    while ESP.Active do
        if tick() - ESP._lastUpdate < ESP._settings.UpdateRate then
            task.wait(0.01)
            break
        end
        ESP._lastUpdate = tick()
        SafeCall(function()
            ESP.UpdateAll()
        end)
        task.wait(ESP._settings.UpdateRate)
    end
end

function ESP.Start()
    if ESP.Active then return end
    ESP.Active = true
    ESP._startTick = tick()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            ESP.AddPlayer(player)
        end
    end
    Players.PlayerAdded:Connect(function(player)
        ESP.AddPlayer(player)
    end)
    Players.PlayerRemoving:Connect(function(player)
        ESP.RemovePlayer(player)
    end)
    A.Notify("ESP", "Started ESP system", 3)
    ESP._loop = task.spawn(function()
        ESP.MainLoop()
        ESP.Active = false
    end)
end

function ESP.Stop()
    ESP.Active = false
    ESP.ClearAll()
    if ESP._loop then
        task.cancel(ESP._loop)
        ESP._loop = nil
    end
    A.Notify("ESP", "Stopped", 2)
end

function A.ESP:SetPlayers(v) self:ToggleType("Players", v) end
function A.ESP:SetChest(v) self:ToggleType("Chests", v) end
function A.ESP:SetFruit(v) self:ToggleType("Fruits", v) end
function A.ESP:SetMob(v) self:ToggleType("Mobs", v) end
function A.ESP:SetQuest(v) self:ToggleType("Quests", v) end
function A.ESP:SetSea(v) self:ToggleType("SeaEvents", v) end
function A.ESP:SetBoss(v) self:ToggleType("Bosses", v) end

A.ESP = ESP
A.Register("esp", A.ESP)
