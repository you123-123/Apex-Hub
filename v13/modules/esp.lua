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
-- FIX: Distinctive 3D ESP - 8-point cube + off-screen + fruit % (was 2D red square only)
-- Logical distinctive 3D ESP (was 2D red square)
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
    Box3D = true,
    ShowSkeleton = false,
    ShowHealthBar = true,
    ShowOffScreenArrow = true,
    FruitShowRarity = true,
    BoxStyle = "3D",
    TracerOrigin = "Bottom",
    TextSize = 14,
    TextFont = 2,
    MaxESPDistance = 5000,
    UpdateRate = 0.05,
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

-- NEW: 3D Bounding Box - 8 corners cube (12 edges) like Blender
function ESP.GetBoundingBoxCorners(model)
    local ok, cf, size = pcall(function() return model:GetBoundingBox() end)
    if not ok or not cf then return nil end
    local sx, sy, sz = size.X/2, size.Y/2, size.Z/2
    local corners = {
        cf * Vector3.new( sx,  sy,  sz),
        cf * Vector3.new(-sx,  sy,  sz),
        cf * Vector3.new(-sx, -sy,  sz),
        cf * Vector3.new( sx, -sy,  sz),
        cf * Vector3.new( sx,  sy, -sz),
        cf * Vector3.new(-sx,  sy, -sz),
        cf * Vector3.new(-sx, -sy, -sz),
        cf * Vector3.new( sx, -sy, -sz),
    }
    return corners
end

function ESP.Draw3DBox(corners3D, color, thickness, visible, drawings)
    if not corners3D or #corners3D < 8 then return end
    local screenPoints = {}
    local anyOnScreen = false
    for i, pos in ipairs(corners3D) do
        local sp, onScreen = Camera:WorldToViewportPoint(pos)
        screenPoints[i] = {pos=Vector2.new(sp.X, sp.Y), onScreen=onScreen, depth=sp.Z}
        if onScreen then anyOnScreen = true end
    end
    if not anyOnScreen then return nil end -- will handle off-screen arrow separately
    local edges = {
        {1,2},{2,3},{3,4},{4,1}, -- front
        {5,6},{6,7},{7,8},{8,5}, -- back
        {1,5},{2,6},{3,7},{4,8}, -- connections
    }
    local lines = {}
    for _, e in ipairs(edges) do
        local a = screenPoints[e[1]]
        local b = screenPoints[e[2]]
        if a and b and a.depth > 0 and b.depth > 0 then
            local line = ESP.DrawLine(a.pos, b.pos, color, thickness or 1.2, visible)
            table.insert(drawings or {}, line)
            table.insert(lines, line)
        end
    end
    return lines
end

function ESP.DrawOffScreenArrow(targetPos, color, visible)
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
    if onScreen then return nil end
    local dir = (Vector2.new(screenPos.X, screenPos.Y) - center)
    if dir.Magnitude < 1 then return nil end
    dir = dir.Unit
    -- Place arrow on screen edge with padding 40
    local radius = math.min(Camera.ViewportSize.X, Camera.ViewportSize.Y)/2 - 40
    local arrowPos = center + dir * radius
    local arrow = CreateDrawing("Triangle", {
        PointA = arrowPos + dir * 12,
        PointB = arrowPos - dir * 8 + Vector2.new(-dir.Y, dir.X) * 6,
        PointC = arrowPos - dir * 8 + Vector2.new(dir.Y, -dir.X) * 6,
        Color = color or Color3.fromRGB(255,255,255),
        Filled = true,
        Visible = visible or false,
        Transparency = 0.9,
    })
    return arrow
end

-- Fruit rarity data (from data/fruits.lua)
ESP._fruitRarity = {
    ["Dragon"]={chance=0.5, color=Color3.fromRGB(255,50,50)}, ["Leopard"]={chance=0.7, color=Color3.fromRGB(255,180,0)},
    ["Kitsune"]={chance=0.8, color=Color3.fromRGB(255,100,200)}, ["Mammoth"]={chance=1.0, color=Color3.fromRGB(120,90,40)},
    ["Spirit"]={chance=1.2, color=Color3.fromRGB(180,220,255)}, ["Control"]={chance=1.5, color=Color3.fromRGB(100,200,255)},
    ["Venom"]={chance=2.0, color=Color3.fromRGB(120,0,200)}, ["Shadow"]={chance=2.2, color=Color3.fromRGB(40,40,80)},
    ["Dough"]={chance=2.5, color=Color3.fromRGB(240,220,180)}, ["T-Rex"]={chance=2.8, color=Color3.fromRGB(80,180,60)},
}
function ESP.GetFruitInfo(name)
    for k,v in pairs(ESP._fruitRarity) do if name:find(k) then return v end end
    return {chance=5.0, color=ESP._settings.FruitColor}
end

-- Logical 3D Fruit Radar + Inventory Value Tracker
ESP.RadarActive = false
ESP._radarArrow = nil
ESP._radarText = nil
ESP._radarValueText = nil
function ESP.StartFruitRadar()
    if ESP.RadarActive then return end
    ESP.RadarActive = true
    -- Inventory value (distinctive: scans Inventory remote)
    local function GetInventoryValue()
        local total = 0
        local count = 0
        pcall(function()
            local inv = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")
            -- Fallback: count fruits in objectCache
            for k, data in pairs(ESP._objectCache) do
                if data.Type=="Fruit" then
                    local info = ESP.GetFruitInfo(data.Object.Name)
                    -- Value estimate: 1/chance * 100k + rarity bonus
                    local val = math.floor((1/(info.chance))*300000 + 50000)
                    total = total + val
                    count = count + 1
                end
            end
        end)
        return total, count
    end
    task.spawn(function()
        while ESP.RadarActive do
            local nearest, nearestDist, nearestInfo
            local myHRP = A.HRP()
            if myHRP then
                for k, data in pairs(ESP._objectCache) do
                    if data.Type=="Fruit" and data.Object and data.Object.Parent then
                        local pos = data.Object.PrimaryPart and data.Object.PrimaryPart.Position or data.Position
                        if pos then
                            local d = (myHRP.Position - pos).Magnitude
                            if not nearestDist or d < nearestDist then
                                nearest = data
                                nearestDist = d
                                nearestInfo = ESP.GetFruitInfo(data.Object.Name)
                            end
                        end
                    end
                end
            end
            -- Update radar arrow
            if nearest and nearestDist then
                if not ESP._radarArrow then
                    ESP._radarArrow = ESP.DrawOffScreenArrow(nearest.Object.PrimaryPart and nearest.Object.PrimaryPart.Position or nearest.Position, nearestInfo.color, true)
                    ESP._radarText = ESP.DrawText(Vector2.new(Camera.ViewportSize.X/2, 50), "", nearestInfo.color, 16, 2, true)
                    ESP._radarValueText = ESP.DrawText(Vector2.new(Camera.ViewportSize.X/2, 70), "", Color3.fromRGB(255,215,0), 12, 2, true)
                end
                if ESP._radarArrow then
                    -- Pulse for legendary <1% (distinctive)
                    local pulse = (nearestInfo.chance < 1.0) and (math.sin(tick()*5)*0.3+0.7) or 1
                    pcall(function() ESP._radarArrow.Transparency = pulse end)
                    -- Update arrow position
                    pcall(function() ESP._radarArrow:Remove() end)
                    ESP._radarArrow = ESP.DrawOffScreenArrow(nearest.Object.PrimaryPart and nearest.Object.PrimaryPart.Position or nearest.Position, nearestInfo.color, true)
                end
                if ESP._radarText then
                    ESP._radarText.Text = nearest.Object.Name.." ["..nearestInfo.chance.."%] - "..math.floor(nearestDist).."m"
                    ESP._radarText.Color = nearestInfo.color
                end
                if ESP._radarValueText then
                    local total, count = GetInventoryValue()
                    ESP._radarValueText.Text = "Radar: "..(nearest and nearest.Object.Name or "None").." | Inventory: "..count.." fruits ~"..A.UI.FormatNumber(total).." Beli"
                end
            else
                if ESP._radarText then ESP._radarText.Text = "Fruit Radar: Scanning..." end
            end
            task.wait(0.1)
        end
    end)
end
function ESP.StopFruitRadar()
    ESP.RadarActive = false
    pcall(function() if ESP._radarArrow then ESP._radarArrow:Remove() end end)
    pcall(function() if ESP._radarText then ESP._radarText:Remove() end end)
    pcall(function() if ESP._radarValueText then ESP._radarValueText:Remove() end end)
    ESP._radarArrow, ESP._radarText, ESP._radarValueText = nil, nil, nil
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
        -- Distinctive: off-screen arrow instead of hide (was just hide)
        for _, d in ipairs(data.Drawings) do pcall(function() if d then d:Remove() end end) end
        data.Drawings = {}
        if ESP._settings.ShowOffScreenArrow then
            local arrow = ESP.DrawOffScreenArrow(hrp.Position, ESP.GetESPColor(player), true)
            if arrow then table.insert(data.Drawings, arrow) end
            -- Keep arrow visible, don't return to allow name/distance update below? For off-screen, just arrow
            return
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
    -- Distinctive 3D Box (was 2D red square)
    if ESP._settings.ShowBox then
        if ESP._settings.Box3D then
            local corners = ESP.GetBoundingBoxCorners(char)
            if corners then
                local lines = ESP.Draw3DBox(corners, color, 1.4, true, data.Drawings)
                if lines then for _, l in ipairs(lines) do table.insert(data.Drawings, l) end end
            end
            -- Fallback to 2D if 3D failed
            if #data.Drawings == 0 then
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
                end
            end
        else
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
            end
        end
    end
    -- Skeleton 3D lines (was disabled)
    if ESP._settings.ShowSkeleton then
        local joints = {}
        for _, partName in ipairs({"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}) do
            local part = char:FindFirstChild(partName)
            if part then joints[partName] = part.Position end
        end
        local skel = ESP.DrawSkeleton(joints, color, 1, true)
        for _, l in ipairs(skel) do table.insert(data.Drawings, l) end
    end
    -- Off-screen arrow (was just hide)
    if ESP._settings.ShowOffScreenArrow and not onScreen then
        local arrow = ESP.DrawOffScreenArrow(hrp.Position, color, true)
        if arrow then table.insert(data.Drawings, arrow) end
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
        -- Distinctive off-screen arrow for objects (was just hide)
        for _, d in ipairs(data.Drawings) do pcall(function() if d then d:Remove() end end) end
        data.Drawings = {}
        if ESP._settings.ShowOffScreenArrow then
            local arrow = ESP.DrawOffScreenArrow(pos, color, true)
            if arrow then table.insert(data.Drawings, arrow) end
            local arrowText = ESP.DrawText(Vector2.new(Camera.ViewportSize.X/2, 20), data.Object.Name.." ["..math.floor(dist).."m]", color, 12, 2, true)
            table.insert(data.Drawings, arrowText)
        end
        return
    end
    for _, d in ipairs(data.Drawings) do
        pcall(function() if d and d.Remove then d:Remove() end end)
    end
    data.Drawings = {}
    -- 3D Box for objects (was just text)
    if ESP._settings.ShowBox and data.Object:IsA("Model") then
        local corners = ESP.GetBoundingBoxCorners(data.Object)
        if corners then
            local lines = ESP.Draw3DBox(corners, color, 1.2, true, data.Drawings)
            if lines then for _, l in ipairs(lines) do table.insert(data.Drawings, l) end end
        end
    end
    -- Distinctive fruit info: name + rarity % + color (was just name)
    local displayName = data.Object.Name
    local displayColor = color
    if data.Type == "Fruit" and ESP._settings.FruitShowRarity then
        local info = ESP.GetFruitInfo(data.Object.Name)
        displayName = data.Object.Name.." ["..info.chance.."%]"
        displayColor = info.color
    end
    local nameText = ESP.DrawText(
        Vector2.new(screenPos.X, screenPos.Y - 20),
        displayName,
        displayColor,
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
    -- Health bar for mobs/bosses
    if (data.Type=="Mob" or data.Type=="Boss") and data.Object:FindFirstChild("Humanoid") then
        local hum = data.Object:FindFirstChild("Humanoid")
        if hum then
            local bg, bar = ESP.DrawHealthBar(Vector2.new(screenPos.X - 30, screenPos.Y - 20), hum.Health, hum.MaxHealth, 30, true)
            table.insert(data.Drawings, bg); table.insert(data.Drawings, bar)
        end
    end
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

A.ESP = ESP

function A.ESP:SetPlayers(v) self:ToggleType("Players", v) end
function A.ESP:SetChest(v) self:ToggleType("Chests", v) end
function A.ESP:SetFruit(v) self:ToggleType("Fruits", v) end
function A.ESP:SetMob(v) self:ToggleType("Mobs", v) end
function A.ESP:SetQuest(v) self:ToggleType("Quests", v) end
function A.ESP:SetSea(v) self:ToggleType("SeaEvents", v) end
function A.ESP:SetBoss(v) self:ToggleType("Bosses", v) end

A.Register("esp", A.ESP)
