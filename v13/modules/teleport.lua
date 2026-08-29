local A = _G.Apex
local Teleport = {}
Teleport.Active = false
Teleport.TPCount = 0
Teleport.LastTP = nil
Teleport._loop = nil
Teleport._startTick = 0
Teleport._lastPosition = nil
Teleport._tpHistory = {}
Teleport._cooldown = 0.5
Teleport._lastTPTime = 0
Teleport._safetyEnabled = true
Teleport._safePositions = {}
Teleport._teleporting = false
Teleport._pendingTP = nil
Teleport._failCount = 0
Teleport._maxFails = 10
Teleport._antiDetection = true
Teleport._jitterAmount = 2
Teleport._delayBetweenTPs = 0.3

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Apex Teleport] Error: " .. tostring(err))
    end
    return ok, err
end

local ISLAND_POSITIONS = {
    ["Starter Island"] = Vector3.new(-260, 30, 70),
    ["Middle Town"] = Vector3.new(-270, 35, 60),
    ["Marine Fortress"] = Vector3.new(-2500, 115, 740),
    ["Pirate Village"] = Vector3.new(-3030, 25, 580),
    ["Underwater City"] = Vector3.new(61160, 10, 1830),
    ["Sky Island"] = Vector3.new(-4740, 710, -2540),
    ["Colosseum"] = Vector3.new(-1780, 40, 760),
    ["Prison"] = Vector3.new(4870, 540, -270),
    ["Magma Village"] = Vector3.new(-5340, 830, -680),
    ["Forgotten Island"] = Vector3.new(-3050, 10, -1420),
    ["Usopp's Island"] = Vector3.new(4700, 8, 960),
    ["Monkey Mountain"] = Vector3.new(-2470, 660, -430),
    ["Cold Side"] = Vector3.new(-5090, 430, -2870),
    ["Hot Side"] = Vector3.new(-4970, 430, -2550),
    ["Green Bit"] = Vector3.new(-2190, 20, 5560),
    ["Graveyard"] = Vector3.new(4820, 5, 680),
    ["Ninja Island"] = Vector3.new(-2640, 9, -650),
    ["Russo Island"] = Vector3.new(5340, 10, 430),
    ["Amazon Lily"] = Vector3.new(5460, 620, -1130),
    ["Fountain of Truth"] = Vector3.new(-1120, 10, -1640),
    ["Floating Turtle"] = Vector3.new(-13340, 220, 1560),
    ["Castle on the Sea"] = Vector3.new(-5310, 310, -2260),
    ["Great Tree"] = Vector3.new(2290, 10, -6930),
    ["Hydra Island"] = Vector3.new(5280, 620, -1120),
    ["Haunted Castle"] = Vector3.new(-12550, 280, -1170),
    ["Sea of Treats"] = Vector3.new(-370, 130, -13560),
    ["Tiki Outpost"] = Vector3.new(-16610, 390, -380)
}

local NPC_POSITIONS = {
    ["Blox Fruit Dealer"] = Vector3.new(-268, 35, 58),
    ["Master of Auras"] = Vector3.new(-270, 35, 62),
    ["Sword Dealer"] = Vector3.new(-272, 35, 64),
    ["Gun Dealer"] = Vector3.new(-274, 35, 66),
    ["Ability Teacher"] = Vector3.new(-276, 35, 68),
    ["Fighting Style Teacher"] = Vector3.new(-278, 35, 70),
    ["Quest Giver"] = Vector3.new(-280, 35, 72),
    ["Race Spec"] = Vector3.new(-282, 35, 74),
    ["Elite Hunter"] = Vector3.new(-284, 35, 76),
    ["FruitDealer"] = Vector3.new(-268, 35, 58)
}

local QUEST_POSITIONS = {
    ["Bandit Quest"] = Vector3.new(-260, 30, 70),
    ["Monkey Quest"] = Vector3.new(-2470, 660, -430),
    ["Gorilla Quest"] = Vector3.new(-2470, 660, -430),
    ["Pirate Quest"] = Vector3.new(-3030, 25, 580),
    ["Soldier Quest"] = Vector3.new(-2500, 115, 740),
    ["Fishman Quest"] = Vector3.new(61160, 10, 1830),
    ["Sky Quest"] = Vector3.new(-4740, 710, -2540),
    ["Magma Quest"] = Vector3.new(-5340, 830, -680)
}

local BOSS_POSITIONS = {
    ["The Gorilla King"] = Vector3.new(-2470, 660, -430),
    ["Bobby"] = Vector3.new(-3030, 25, 580),
    ["Yeti"] = Vector3.new(-5090, 430, -2870),
    ["Vice Admiral"] = Vector3.new(-2500, 115, 740),
    ["Warden"] = Vector3.new(4870, 540, -270),
    ["Chief Warden"] = Vector3.new(4870, 540, -270),
    ["Swan"] = Vector3.new(4870, 540, -270),
    ["Magma Admiral"] = Vector3.new(-5340, 830, -680),
    ["Fishman Lord"] = Vector3.new(61160, 10, 1830),
    ["Wysper"] = Vector3.new(-4740, 710, -2540),
    ["Thunder God"] = Vector3.new(-2470, 660, -430),
    ["Cyborg"] = Vector3.new(4700, 8, 960),
    ["Diamond"] = Vector3.new(-1780, 40, 760),
    ["Jeremy"] = Vector3.new(-3030, 25, 580),
    ["Fajita"] = Vector3.new(4870, 540, -270),
    ["Don Swan"] = Vector3.new(-3030, 25, 580),
    ["Cake Prince"] = Vector3.new(-250, 100, -12300),
    ["Dough King"] = Vector3.new(-250, 100, -12300),
    ["Darkbeard"] = Vector3.new(3750, 50, -2870),
    ["Kitsune"] = Vector3.new(5280, 620, -1120)
}

local function AddJitter(pos)
    if not Teleport._antiDetection then return pos end
    local jitter = Teleport._jitterAmount
    return Vector3.new(
        pos.X + math.random(-jitter * 100, jitter * 100) / 100,
        pos.Y + math.random(-jitter * 50, jitter * 50) / 100,
        pos.Z + math.random(-jitter * 100, jitter * 100) / 100
    )
end

function Teleport.GetIslandList()
    local islands = {}
    for name, pos in pairs(ISLAND_POSITIONS) do
        table.insert(islands, {Name = name, Position = pos})
    end
    table.sort(islands, function(a, b) return a.Name < b.Name end)
    return islands
end

function Teleport.GetNPCList()
    local npcs = {}
    for name, pos in pairs(NPC_POSITIONS) do
        table.insert(npcs, {Name = name, Position = pos})
    end
    return npcs
end

function Teleport.GetClosestIsland()
    local myHRP = A.HRP()
    if not myHRP then return nil end
    local closest = nil
    local closestDist = math.huge
    for name, pos in pairs(ISLAND_POSITIONS) do
        local dist = (myHRP.Position - pos).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = {Name = name, Position = pos, Distance = dist}
        end
    end
    return closest
end

function Teleport.GetIslandByLevel(level)
    local levelIslands = {
        {MinLevel = 1, MaxLevel = 20, Island = "Starter Island"},
        {MinLevel = 20, MaxLevel = 60, Island = "Middle Town"},
        {MinLevel = 60, MaxLevel = 120, Island = "Marine Fortress"},
        {MinLevel = 120, MaxLevel = 200, Island = "Pirate Village"},
        {MinLevel = 200, MaxLevel = 350, Island = "Underwater City"},
        {MinLevel = 350, MaxLevel = 525, Island = "Sky Island"},
        {MinLevel = 525, MaxLevel = 725, Island = "Colosseum"},
        {MinLevel = 725, MaxLevel = 900, Island = "Prison"},
        {MinLevel = 900, MaxLevel = 1050, Island = "Magma Village"},
        {MinLevel = 1050, MaxLevel = 1300, Island = "Forgotten Island"},
        {MinLevel = 1300, MaxLevel = 1575, Island = "Usopp's Island"},
        {MinLevel = 1575, MaxLevel = 1875, Island = "Monkey Mountain"},
        {MinLevel = 1875, MaxLevel = 2175, Island = "Cold Side"},
        {MinLevel = 2175, MaxLevel = 2500, Island = "Hot Side"},
        {MinLevel = 2500, MaxLevel = 3000, Island = "Green Bit"},
        {MinLevel = 3000, MaxLevel = 3750, Island = "Graveyard"},
        {MinLevel = 3750, MaxLevel = 4500, Island = "Ninja Island"},
        {MinLevel = 4500, MaxLevel = 5500, Island = "Russo Island"},
        {MinLevel = 5500, MaxLevel = 6750, Island = "Amazon Lily"},
        {MinLevel = 6750, MaxLevel = 8000, Island = "Fountain of Truth"},
        {MinLevel = 8000, MaxLevel = 10000, Island = "Floating Turtle"},
        {MinLevel = 10000, MaxLevel = 12500, Island = "Castle on the Sea"},
        {MinLevel = 12500, MaxLevel = 15000, Island = "Great Tree"},
        {MinLevel = 15000, MaxLevel = 17500, Island = "Hydra Island"},
        {MinLevel = 17500, MaxLevel = 20000, Island = "Haunted Castle"},
        {MinLevel = 20000, MaxLevel = 25000, Island = "Sea of Treats"},
        {MinLevel = 25000, MaxLevel = 99999, Island = "Tiki Outpost"}
    }
    for _, data in ipairs(levelIslands) do
        if level >= data.MinLevel and level <= data.MaxLevel then
            return {Name = data.Island, Position = ISLAND_POSITIONS[data.Island]}
        end
    end
    return nil
end

function Teleport.ToIsland(name)
    local pos = ISLAND_POSITIONS[name]
    if not pos then
        A.Notify("Teleport", "Island not found: " .. tostring(name), 3)
        return false
    end
    return Teleport.TpTo(pos)
end

function Teleport.ToNPC(name)
    if not name or name == "" then
        A.Notify("Teleport", "No target name specified", 2)
        return false
    end
    local pos = NPC_POSITIONS[name]
    if not pos then
        local npcs = Workspace:FindFirstChild("NPCs") or Workspace:FindFirstChild("Living")
        if npcs then
            for _, npc in ipairs(npcs:GetDescendants()) do
                if npc:IsA("Model") and string.find(string.lower(npc.Name), string.lower(name)) then
                    local part = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
                    if part then
                        pos = part.Position
                        break
                    end
                end
            end
        end
    end
    if not pos then
        A.Notify("Teleport", "NPC not found: " .. tostring(name), 3)
        return false
    end
    return Teleport.TpTo(pos)
end

function Teleport.ToQuest(name)
    local key = name
    if type(name) == "table" then
        key = name.Name or name.QuestName or name.ID
    end
    local pos = QUEST_POSITIONS[key]
    if not pos then
        A.Notify("Teleport", "Quest not found: " .. tostring(name), 3)
        return false
    end
    return Teleport.TpTo(pos)
end

function Teleport.ToBoss(name)
    if not name or name == "" then
        A.Notify("Teleport", "No target name specified", 2)
        return false
    end
    local pos = BOSS_POSITIONS[name]
    if not pos then
        local enemies = Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("Hostile")
        if enemies then
            for _, mob in ipairs(enemies:GetDescendants()) do
                if mob:IsA("Model") and string.find(string.lower(mob.Name), string.lower(name)) then
                    local part = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
                    if part then
                        pos = part.Position
                        break
                    end
                end
            end
        end
    end
    if not pos then
        A.Notify("Teleport", "Boss not found: " .. tostring(name), 3)
        return false
    end
    return Teleport.TpTo(pos)
end

function Teleport.ToChest()
    local myHRP = A.HRP()
    if not myHRP then return false end
    local chests = Workspace:FindFirstChild("Chests") or Workspace:FindFirstChild("Items")
    if not chests then
        for _, child in ipairs(Workspace:GetChildren()) do
            if string.find(string.lower(child.Name), "chest") then
                chests = child
                break
            end
        end
    end
    if not chests then return false end
    local closest = nil
    local closestDist = math.huge
    for _, chest in ipairs(chests:GetChildren()) do
        if chest:IsA("Model") then
            local part = chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")
            if part then
                local dist = (myHRP.Position - part.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = part.Position
                end
            end
        end
    end
    if closest then
        return Teleport.TpTo(closest)
    end
    return false
end

function Teleport.ToFruit()
    local myHRP = A.HRP()
    if not myHRP then return false end
    local fruits = Workspace:FindFirstChild("Fruits") or Workspace:FindFirstChild("Blox Fruits")
    if not fruits then
        for _, child in ipairs(Workspace:GetChildren()) do
            if string.find(string.lower(child.Name), "fruit") then
                fruits = child
                break
            end
        end
    end
    if not fruits then return false end
    for _, fruit in ipairs(fruits:GetChildren()) do
        if fruit:IsA("BasePart") or fruit:IsA("Model") then
            local part = fruit:IsA("BasePart") and fruit or fruit.PrimaryPart
            if part then
                return Teleport.TpTo(part.Position)
            end
        end
    end
    return false
end

function Teleport.ToSeaBeast()
    local enemies = Workspace:FindFirstChild("Enemies") or Workspace
    for _, child in ipairs(enemies:GetDescendants()) do
        if child:IsA("Model") and string.find(string.lower(child.Name), "beast") then
            local part = child:FindFirstChild("HumanoidRootPart") or child.PrimaryPart
            if part then
                return Teleport.TpTo(part.Position)
            end
        end
    end
    return false
end

function Teleport.ToDungeon()
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            commF("EnterDungeon")
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local enter = remotes:FindFirstChild("EnterDungeon")
            if enter then
                enter:FireServer()
            end
        end
    end)
    return ok
end

function Teleport.ToRaid()
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            commF("StartRaid")
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local raid = remotes:FindFirstChild("StartRaid") or remotes:FindFirstChild("Raids")
            if raid then
                raid:FireServer()
            end
        end
    end)
    return ok
end

function Teleport.ToSafeZone()
    return Teleport.TpTo(Vector3.new(-260, 30, 70))
end

function Teleport.ToSpawn()
    local lp = A.LP
    if not lp then return false end
    local spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn")
    if spawn then
        local pos = spawn:IsA("BasePart") and spawn.Position or (spawn.PrimaryPart and spawn.PrimaryPart.Position)
        if pos then
            return Teleport.TpTo(pos)
        end
    end
    return Teleport.ToSafeZone()
end

function Teleport.ToPortal()
    local myHRP = A.HRP()
    if not myHRP then return false end
    for _, child in ipairs(Workspace:GetDescendants()) do
        if child:IsA("BasePart") and string.find(string.lower(child.Name), "portal") then
            local dist = (myHRP.Position - child.Position).Magnitude
            if dist < 5000 then
                return Teleport.TpTo(child.Position)
            end
        end
    end
    return false
end

function Teleport.ToDimension()
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            commF("EnterDimension")
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local dim = remotes:FindFirstChild("EnterDimension")
            if dim then
                dim:FireServer()
            end
        end
    end)
    return ok
end

function Teleport.SafeTP(pos)
    if not pos then return false end
    if Teleport._safetyEnabled then
        local myHRP = A.HRP()
        if myHRP then
            local dist = (myHRP.Position - pos).Magnitude
            if dist > 5000 then
                A.Notify("Teleport", "Distance too large, using safe teleport", 3)
                return Teleport.PathTP(pos)
            end
        end
    end
    return Teleport.TpTo(pos)
end

function Teleport.PathTP(pos)
    if not pos then return false end
    local myHRP = A.HRP()
    if not myHRP then return false end
    local startPos = myHRP.Position
    local dist = (startPos - pos).Magnitude
    local segments = math.ceil(dist / 500)
    for i = 1, segments do
        local alpha = i / segments
        local intermediatePos = startPos:Lerp(pos, alpha)
        A.TpTo(intermediatePos + Vector3.new(0, 30, 0), 100)
        task.wait(0.2)
    end
    A.TpTo(pos, 100)
    return true
end

function Teleport.TweenTP(pos, speed)
    if not pos then return false end
    local myHRP = A.HRP()
    if not myHRP then return false end
    A.TweenTo(pos, speed or 200)
    return true
end

function Teleport.HopTP(islandName)
    A.Notify("Teleport", "Server hopping to " .. tostring(islandName), 3)
    local HttpService = game:GetService("HttpService")
    local ok, res = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)
    if ok and res and res.data then
        local servers = {}
        for _, srv in ipairs(res.data) do
            if srv.id ~= game.JobId then
                table.insert(servers, srv)
            end
        end
        if #servers > 0 then
            local chosen = servers[math.random(1, #servers)]
            if chosen and chosen.id then
                pcall(function()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, chosen.id, A.LP)
                end)
                return true
            end
        end
    end
    return false
end

function Teleport.SmartTP(target)
    if not target then return false end
    if type(target) == "string" then
        if ISLAND_POSITIONS[target] then
            return Teleport.ToIsland(target)
        elseif NPC_POSITIONS[target] then
            return Teleport.ToNPC(target)
        elseif BOSS_POSITIONS[target] then
            return Teleport.ToBoss(target)
        elseif QUEST_POSITIONS[target] then
            return Teleport.ToQuest(target)
        end
    elseif type(target) == "Vector3" or (type(target) == "table" and target.X) then
        return Teleport.SafeTP(target)
    end
    return false
end

function Teleport.TpTo(pos)
    if not pos then return false end
    if tick() - Teleport._lastTPTime < Teleport._delayBetweenTPs then
        return false
    end
    local safePos = AddJitter(pos)
    local ok, err = SafeCall(function()
        A.TpTo(safePos, 50)
        Teleport.TPCount = Teleport.TPCount + 1
        Teleport.LastTP = safePos
        Teleport._lastTPTime = tick()
        table.insert(Teleport._tpHistory, {
            Position = safePos,
            Time = tick(),
            Success = true
        })
    end)
    if not ok then
        Teleport._failCount = Teleport._failCount + 1
        table.insert(Teleport._tpHistory, {
            Position = safePos,
            Time = tick(),
            Success = false
        })
    end
    return ok
end

function Teleport.GetTPStats()
    local sessionTime = tick() - Teleport._startTick
    local minutes = math.floor(sessionTime / 60)
    local seconds = math.floor(sessionTime % 60)
    local nearest = Teleport.GetClosestIsland()
    return {
        TotalTPs = Teleport.TPCount,
        FailCount = Teleport._failCount,
        LastTP = Teleport.LastTP,
        NearestIsland = nearest and nearest.Name or "Unknown",
        NearestDistance = nearest and math.floor(nearest.Distance) or 0,
        SessionTime = string.format("%dm %ds", minutes, seconds),
        Rate = sessionTime > 0 and string.format("%.1f/min", Teleport.TPCount / (sessionTime / 60)) or "0/min",
        HistorySize = #Teleport._tpHistory,
        AntiDetection = Teleport._antiDetection
    }
end

function Teleport.MainLoop()
    while Teleport.Active do
        if not A.Alive() then
            task.wait(2)
            break
        end
        task.wait(1)
    end
end

function Teleport.Start()
    if Teleport.Active then return end
    Teleport.Active = true
    Teleport._startTick = tick()
    Teleport._lastTPTime = 0
    Teleport._failCount = 0
    A.Notify("Teleport", "Teleport system started", 3)
    Teleport._loop = task.spawn(function()
        Teleport.MainLoop()
        Teleport.Active = false
    end)
end

function Teleport.Stop()
    Teleport.Active = false
    Teleport._teleporting = false
    if Teleport._loop then
        task.cancel(Teleport._loop)
        Teleport._loop = nil
    end
    A.Notify("Teleport", "Stopped", 2)
end

A.Teleport = Teleport
A.Register("teleport", A.Teleport)
