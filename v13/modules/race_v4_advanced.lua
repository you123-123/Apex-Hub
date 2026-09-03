local A = _G.Apex
local module = {}
A.RaceV4Adv = module

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LP = A.LP
local running = false
local connections = {}
local moonConn = nil

-- Race data maps
local RACE_V3_REQUIREMENTS = {
    Human = {Boss = "Diablo", Quest = "Human V3 Quest", Material = {Item = "Bones", Count = 50}},
    Shark = {Boss = "Terrorsshark", Quest = "Shark V3 Quest", Material = {Item = "Shark Teeth", Count = 50}},
    Angel = {Boss = "Darkbeard", Quest = "Angel V3 Quest", Material = {Item = "Feathers", Count = 50}},
    Ghoul = {Boss = "Cursed Captain", Quest = "Ghoul V3 Quest", Material = {Item = "Ectoplasm", Count = 50}},
    Mink = {Boss = "Jeremy", Quest = "Mink V3 Quest", Material = {Item = "Electric Wings", Count = 50}},
    Cyborg = {Boss = "Fajita", Quest = "Cyborg V3 Quest", Material = {Item = "Core Brain", Count = 50}},
    Skull = {Boss = "Dough King", Quest = "Skull V3 Quest", Material = {Item = "Conjured Cocoa", Count = 50}}
}

local TEMPLE_POS = Vector3.new(1551, 1086, -1010)
local FLOWER_POSITIONS = {
    Red = {
        Vector3.new(-693, 11.5, -610),
        Vector3.new(-731, 11.5, -580),
        Vector3.new(-770, 11.5, -610),
        Vector3.new(-750, 11.5, -645),
        Vector3.new(-710, 11.5, -660)
    },
    Blue = {
        Vector3.new(555, 11.5, 795),
        Vector3.new(520, 11.5, 820),
        Vector3.new(580, 11.5, 840),
        Vector3.new(540, 11.5, 860),
        Vector3.new(570, 11.5, 810)
    },
    Yellow = {
        Vector3.new(-243, 11.5, -1232),
        Vector3.new(-270, 11.5, -1200),
        Vector3.new(-210, 11.5, -1250),
        Vector3.new(-250, 11.5, -1280),
        Vector3.new(-290, 11.5, -1260)
    }
}

-- Safe workspace-folder child lookup (nil-safe when folder or child is absent)
local function fc(parent, name)
    return parent and parent:FindFirstChild(name)
end

-- FIX: GetDescendants throttle helper max 300 + GetChildren fallback
local _RACE_DescThrottle = {lastTick=0, cache=nil, parent=nil}
local function _RACE_SafeDescendants(parent, limit)
    if not parent then return {} end
    limit = limit or 300
    if _RACE_DescThrottle.cache and _RACE_DescThrottle.parent==parent and (tick()-_RACE_DescThrottle.lastTick)<0.5 then
        if #_RACE_DescThrottle.cache <= limit then return _RACE_DescThrottle.cache end
        local t={}; for i=1,limit do t[i]=_RACE_DescThrottle.cache[i] end; return t
    end
    local all = _RACE_SafeDescendants(parent, 300)
    local out={}; for i=1, math.min(#all, limit) do out[i]=all[i] end
    _RACE_DescThrottle.cache=out; _RACE_DescThrottle.parent=parent; _RACE_DescThrottle.lastTick=tick()
    return out
end

local function getRemote(name)
    local remotes = RS:FindFirstChild("Remotes")
    if remotes then
        local r = remotes:FindFirstChild(name)
        if r then return r end
    end
    return RS:FindFirstChild(name)
end

local function commF(name, ...)
    return A.CommF(name, ...)
end

local function safeTeleport(pos, range)
    A.TpTo(pos, range or 5)
    task.wait(0.3)
end

local function tweenOrTeleport(pos, speed, range)
    if A.TweenTo(pos, speed or 200) then
        task.wait(0.5)
    else
        safeTeleport(pos, range)
    end
end

local function killMob(mobName, maxWait)
    maxWait = maxWait or 60
    local startTime = tick()
    while running and (tick() - startTime) < maxWait do
        if not A.Alive() then
            task.wait(1)
        else
            local enemies = workspace:FindFirstChild("Enemies")
            local npcs = workspace:FindFirstChild("NPCs")
            local mob = enemies and enemies:FindFirstChild(mobName) or (npcs and npcs:FindFirstChild(mobName))
            if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                safeTeleport(mob.HumanoidRootPart.Position, 5)
                A.Attack(mob, {"Combat"}, 0.1)
            else
                return true
            end
        end
        task.wait(0.1)
    end
    return false
end

local function findNearestType(parent, className, maxDist)
    if not parent then return nil end
    maxDist = maxDist or 500
    local hrp = A.HRP()
    if not hrp then return nil end
    local best, bestDist = nil, maxDist
    -- FIX: throttle GetDescendants max 300 + cache
    for _, obj in pairs(_RACE_SafeDescendants(parent, 300)) do
        if obj:IsA(className) then
            local pos = obj:IsA("BasePart") and obj.Position or (obj:FindFirstChild("HumanoidRootPart") and obj.HumanoidRootPart.Position or nil)
            if pos then
                local d = (pos - hrp.Position).Magnitude
                if d < bestDist then
                    best = obj
                    bestDist = d
                end
            end
        end
    end
    return best, bestDist
end

local function checkHasItem(itemName)
    local result = commF("getInventory")
    if result and result then
        for _, v in pairs(result) do
            if v.Name == itemName then
                return true, v.Count or v.Quantity or 0
            end
        end
    end
    return false, 0
end

local function getRace()
    local result = commF("getRace")
    if result then
        return result
    end
    local char = A.Char()
    if char then
        return char:FindFirstChild("Race") and char.Race.Value or "Unknown"
    end
    return "Unknown"
end

local function getBeli()
    return A.LP.Data and A.LP.Data.Beli and A.LP.Data.Beli.Value or 0
end

local function getFragments()
    return A.LP.Data and A.LP.Data.Fragments and A.LP.Data.Fragments.Value or 0
end

local function buyItem(name, cost, currency)
    if currency == "Fragments" then
        if getFragments() < cost then
            A.Notify("Not Enough", "Need " .. cost .. " Fragments", 2)
            return false
        end
    elseif currency == "Beli" then
        if getBeli() < cost then
            A.Notify("Not Enough", "Need " .. cost .. " Beli", 2)
            return false
        end
    end
    commF("buyItem", name)
    task.wait(0.5)
    return true
end

local function npcClick(npcName, distance)
    distance = distance or 15
    local npcs = workspace:FindFirstChild("NPCs")
    local npc = npcs and npcs:FindFirstChild(npcName)
    if not npc then
        -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
            if v:IsA("Model") and v.Name == npcName and v:FindFirstChild("HumanoidRootPart") then
                npc = v
                break
            end
        end
    end
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        local hrp = A.HRP()
        if hrp and (npc.HumanoidRootPart.Position - hrp.Position).Magnitude <= distance then
            fireclickdetector(npc:FindFirstChildOfClass("ClickDetector"))
            return true
        else
            safeTeleport(npc.HumanoidRootPart.Position, distance - 2)
            task.wait(0.5)
            fireclickdetector(npc:FindFirstChildOfClass("ClickDetector"))
            return true
        end
    end
    return false
end

-- ============================================================
-- RACE V2 FARMING
-- ============================================================
function module.FarmRedFlower()
    A.Notify("Red Flower", "Searching for red flower...", 2)
    local collected = false
    for _, pos in pairs(FLOWER_POSITIONS.Red) do
        if not running then break end
        tweenOrTeleport(pos, 250)
        task.wait(1)
        local flower = fc(workspace:FindFirstChild("Flowers"), "RedFlower")
            or fc(workspace:FindFirstChild("Flowers"), "Red Flower")
        if flower then
            safeTeleport(flower.Position, 3)
            task.wait(0.5)
            commF("pickupFlower", "Red")
            task.wait(0.5)
            collected = true
            break
        end
    end
    if not collected then
        -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
            if not running then break end
            if (v.Name == "RedFlower" or v.Name == "Red Flower") and v:IsA("BasePart") then
                safeTeleport(v.Position, 3)
                task.wait(0.5)
                ((function() local _ht=A.HRP(); if _ht then firetouchinterest(_ht, v, 0) end end)())
                task.wait(0.3)
                ((function() local _ht=A.HRP(); if _ht then firetouchinterest(_ht, v, 1) end end)())
                collected = true
                break
            end
        end
    end
    A.Notify("Red Flower", collected and "Collected!" or "Not found", 2)
    return collected
end

function module.FarmBlueFlower()
    A.Notify("Blue Flower", "Searching for blue flower...", 2)
    local collected = false
    for _, pos in pairs(FLOWER_POSITIONS.Blue) do
        if not running then break end
        tweenOrTeleport(pos, 250)
        task.wait(1)
        local flower = fc(workspace:FindFirstChild("Flowers"), "BlueFlower")
            or fc(workspace:FindFirstChild("Flowers"), "Blue Flower")
        if flower then
            safeTeleport(flower.Position, 3)
            task.wait(0.5)
            commF("pickupFlower", "Blue")
            task.wait(0.5)
            collected = true
            break
        end
    end
    if not collected then
        -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
            if not running then break end
            if (v.Name == "BlueFlower" or v.Name == "Blue Flower") and v:IsA("BasePart") then
                safeTeleport(v.Position, 3)
                task.wait(0.5)
                ((function() local _ht=A.HRP(); if _ht then firetouchinterest(_ht, v, 0) end end)())
                task.wait(0.3)
                ((function() local _ht=A.HRP(); if _ht then firetouchinterest(_ht, v, 1) end end)())
                collected = true
                break
            end
        end
    end
    A.Notify("Blue Flower", collected and "Collected!" or "Not found", 2)
    return collected
end

function module.FarmYellowFlower()
    A.Notify("Yellow Flower", "Searching for yellow flower...", 2)
    local collected = false
    for _, pos in pairs(FLOWER_POSITIONS.Yellow) do
        if not running then break end
        tweenOrTeleport(pos, 250)
        task.wait(1)
        local flower = fc(workspace:FindFirstChild("Flowers"), "YellowFlower")
            or fc(workspace:FindFirstChild("Flowers"), "Yellow Flower")
        if flower then
            safeTeleport(flower.Position, 3)
            task.wait(0.5)
            commF("pickupFlower", "Yellow")
            task.wait(0.5)
            collected = true
            break
        end
    end
    if not collected then
        -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
            if not running then break end
            if (v.Name == "YellowFlower" or v.Name == "Yellow Flower") and v:IsA("BasePart") then
                safeTeleport(v.Position, 3)
                task.wait(0.5)
                ((function() local _ht=A.HRP(); if _ht then firetouchinterest(_ht, v, 0) end end)())
                task.wait(0.3)
                ((function() local _ht=A.HRP(); if _ht then firetouchinterest(_ht, v, 1) end end)())
                collected = true
                break
            end
        end
    end
    A.Notify("Yellow Flower", collected and "Collected!" or "Not found", 2)
    return collected
end

function module.FarmAllFlowers()
    A.Notify("Flowers", "Farming all V2 flowers...", 3)
    local red = module.FarmRedFlower()
    task.wait(0.5)
    local blue = module.FarmBlueFlower()
    task.wait(0.5)
    local yellow = module.FarmYellowFlower()
    A.Notify("Flowers", "Red: " .. tostring(red) .. " | Blue: " .. tostring(blue) .. " | Yellow: " .. tostring(yellow), 5)
    return red and blue and yellow
end

function module.AcceptV2Quest()
    A.Notify("V2 Quest", "Accepting V2 quest...", 2)
    local npc = fc(workspace:FindFirstChild("NPCs"), "Alchemist")
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        safeTeleport(npc.HumanoidRootPart.Position, 10)
        task.wait(0.5)
        commF("Alchemist", "1")
        task.wait(0.5)
        commF("Alchemist", "2")
        task.wait(0.5)
        A.Notify("V2 Quest", "Quest accepted", 2)
        return true
    end
    A.Notify("V2 Quest", "Alchemist not found", 2)
    return false
end

function module.CompleteV2Quest()
    A.Notify("V2 Quest", "Completing V2 quest...", 2)
    local hasRed = checkHasItem("Red Flower")
    local hasBlue = checkHasItem("Blue Flower")
    local hasYellow = checkHasItem("Yellow Flower")
    if not hasRed then
        module.FarmRedFlower()
    end
    if not hasBlue then
        module.FarmBlueFlower()
    end
    if not hasYellow then
        module.FarmYellowFlower()
    end
    task.wait(1)
    local npc = fc(workspace:FindFirstChild("NPCs"), "Alchemist")
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        safeTeleport(npc.HumanoidRootPart.Position, 10)
        task.wait(0.5)
        commF("Alchemist", "1")
        task.wait(0.5)
        commF("Alchemist", "3")
        task.wait(1)
        A.Notify("V2 Quest", "V2 quest completed!", 3)
        return true
    end
    return false
end

-- ============================================================
-- RACE V3 QUESTS
-- ============================================================
function module.GetV3Requirements(race)
    return RACE_V3_REQUIREMENTS[race] or RACE_V3_REQUIREMENTS["Human"]
end

function module.AcceptV3Quest(race)
    A.Notify("V3 Quest", "Accepting V3 quest for " .. race, 2)
    local req = module.GetV3Requirements(race)
    if not req then
        A.Notify("V3 Quest", "Unknown race: " .. tostring(race), 2)
        return false
    end
    commF("Alchemist", "1")
    task.wait(0.5)
    commF("Alchemist", "2")
    task.wait(0.5)
    local hasItem, count = checkHasItem(req.Material.Item)
    if hasItem and count >= req.Material.Count then
        A.Notify("V3 Quest", "Have enough " .. req.Material.Item, 2)
        return true
    end
    A.Notify("V3 Quest", "Need " .. req.Material.Count .. " " .. req.Material.Item, 3)
    return false
end

function module.CompleteV3Quest(race)
    A.Notify("V3 Quest", "Completing V3 quest for " .. race, 2)
    local req = module.GetV3Requirements(race)
    if not req then return false end
    local has, count = checkHasItem(req.Material.Item)
    if not has or count < req.Material.Count then
        A.Notify("V3 Quest", "Missing materials, farming...", 2)
        module.FarmV3Materials(race)
        task.wait(1)
    end
    module.KillV3Target(race)
    task.wait(1)
    commF("Alchemist", "3")
    task.wait(1)
    A.Notify("V3 Quest", "V3 quest complete!", 3)
    return true
end

function module.FarmV3Materials(race)
    A.Notify("V3 Farm", "Farming V3 materials for " .. race, 2)
    local req = module.GetV3Requirements(race)
    if not req then return false end
    local needed = req.Material.Count
    local attempts = 0
    while running and attempts < 200 do
        local has, count = checkHasItem(req.Material.Item)
        if has and count >= needed then
            A.Notify("V3 Farm", "Collected enough " .. req.Material.Item, 2)
            return true
        end
        local mob = fc(workspace:FindFirstChild("Enemies"), req.Boss)
        if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            safeTeleport(mob.HumanoidRootPart.Position, 5)
            A.Attack(mob, {"Combat"}, 0.1)
            task.wait(0.2)
        else
            local foundMob = findNearestType(workspace.Enemies, "Model", 500)
            if foundMob and foundMob:FindFirstChild("HumanoidRootPart") then
                safeTeleport(foundMob.HumanoidRootPart.Position, 5)
                A.Attack(foundMob, {"Combat"}, 0.1)
            end
            task.wait(0.5)
        end
        attempts = attempts + 1
    end
    return false
end

function module.KillV3Target(race)
    A.Notify("V3 Kill", "Killing V3 target for " .. race, 2)
    local req = module.GetV3Requirements(race)
    if not req then return false end
    return killMob(req.Boss, 120)
end

-- ============================================================
-- TEMPLE OF TIME
-- ============================================================
function module.DetectFullMoon()
    local lighting = game:GetService("Lighting")
    local localClock = lighting:FindFirstChild("ClockTime")
    if not localClock then
        localClock = lighting:FindFirstChild("TimeOfDay")
    end
    if localClock then
        local timeVal = tonumber(localClock.Value) or 0
        if timeVal >= 18 and timeVal <= 24 then
            return true
        end
        if timeVal >= 0 and timeVal <= 2 then
            return true
        end
    end
    return false
end

function module.WaitFullMoon()
    A.Notify("Full Moon", "Waiting for full moon...", 3)
    local maxWait = 600
    local elapsed = 0
    while running and elapsed < maxWait do
        if module.DetectFullMoon() then
            A.Notify("Full Moon", "Full moon detected!", 3)
            return true
        end
        task.wait(5)
        elapsed = elapsed + 5
    end
    A.Notify("Full Moon", "Timed out waiting", 2)
    return false
end

function module.AutoFullMoonAlert()
    A.Notify("Moon Alert", "Monitoring for full moon...", 2)
    if moonConn then
        moonConn:Disconnect()
        moonConn = nil
    end
    task.spawn(function()
        while running do
            if module.DetectFullMoon() then
                A.Notify("FULL MOON!", "Full moon is active now!", 5)
                if getfenv().game:GetService("SoundService") then
                    pcall(function()
                        local snd = Instance.new("Sound", getfenv().game:GetService("SoundService"))
                        snd.SoundId = "rbxassetid://5143855767"
                        snd.Volume = 1
                        snd:Play()
                    end)
                end
            end
            task.wait(10)
        end
    end)
    return true
end

function module.TeleportToTemple()
    A.Notify("Temple", "Teleporting to Temple of Time...", 2)
    tweenOrTeleport(TEMPLE_POS, 250)
    task.wait(1)
    return true
end

function module.PullTempleLever()
    A.Notify("Temple", "Pulling temple lever...", 2)
    module.TeleportToTemple()
    task.wait(1)
    local temple = workspace:FindFirstChild("Temple")
    local templeOfTime = workspace:FindFirstChild("TempleOfTime")
    local lever = temple and temple:FindFirstChild("Lever")
        or templeOfTime and templeOfTime:FindFirstChild("Lever")
    if not lever then
        -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
            if v.Name == "Lever" and v:IsA("BasePart") then
                lever = v
                break
            end
        end
    end
    if lever then
        safeTeleport(lever.Position, 5)
        task.wait(0.5)
        fireclickdetector(lever:FindFirstChildOfClass("ClickDetector"))
        task.wait(1)
        A.Notify("Temple", "Lever pulled!", 2)
        return true
    end
    A.Notify("Temple", "Lever not found", 2)
    return false
end

function module.EnterTempleOfTime()
    A.Notify("Temple", "Entering Temple of Time...", 2)
    if module.DetectFullMoon() then
        module.PullTempleLever()
        task.wait(3)
        local door = fc(workspace:FindFirstChild("Temple"), "Door")
            or fc(workspace:FindFirstChild("TempleOfTime"), "Gate")
        if not door then
            -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
                if (v.Name == "Door" or v.Name == "Gate") and v:IsA("BasePart") and v.Position.Magnitude > 1000 then
                    door = v
                    break
                end
            end
        end
        if door then
            safeTeleport(door.Position, 5)
            task.wait(1)
        end
        A.Notify("Temple", "Entered Temple of Time", 2)
        return true
    else
        A.Notify("Temple", "Need full moon to enter!", 2)
        return false
    end
end

-- ============================================================
-- RACE TRIALS
-- ============================================================
function module.TrialMink()
    A.Notify("Mink Trial", "Starting Mink trial (maze)...", 2)
    local hrp = A.HRP()
    if not hrp then return false end
    local startPos = hrp.Position
    local dirs = {
        Vector3.new(30, 0, 0),
        Vector3.new(-30, 0, 0),
        Vector3.new(0, 0, 30),
        Vector3.new(0, 0, -30)
    }
    local visited = {}
    local maxSteps = 200
    local steps = 0
    while running and steps < maxSteps do
        if not A.Alive() then
            task.wait(1)
        else
            hrp = A.HRP()
            if not hrp then break end
            local currentPos = hrp.Position
            local key = math.floor(currentPos.X / 10) .. "," .. math.floor(currentPos.Z / 10)
            if visited[key] then
                visited[key] = visited[key] + 1
            else
                visited[key] = 1
            end
            local exitDoor = nil
            -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
                if v.Name == "TrialExit" or v.Name == "Exit" or v.Name == "MazeEnd" then
                    if v:IsA("BasePart") then
                        exitDoor = v
                        break
                    end
                end
            end
            if exitDoor and (exitDoor.Position - currentPos).Magnitude < 50 then
                safeTeleport(exitDoor.Position, 3)
                A.Notify("Mink Trial", "Maze completed!", 3)
                return true
            end
            local bestDir = nil
            local bestScore = -999
            for _, dir in pairs(dirs) do
                local testPos = currentPos + dir
                local testKey = math.floor(testPos.X / 10) .. "," .. math.floor(testPos.Z / 10)
                local visits = visited[testKey] or 0
                local score = -visits * 10
                if exitDoor then
                    score = score - (testPos - exitDoor.Position).Magnitude * 0.1
                end
                if score > bestScore then
                    bestScore = score
                    bestDir = dir
                end
            end
            if bestDir then
                tweenOrTeleport(currentPos + bestDir, 150)
            end
            task.wait(0.3)
        end
        steps = steps + 1
    end
    A.Notify("Mink Trial", "Maze attempt finished", 2)
    return false
end

function module.TrialHuman()
    A.Notify("Human Trial", "Starting Human trial (kill boss)...", 2)
    local bossNames = {"Tide Keeper", "Frozen", "Darkbeard", "Cake Prince", "Dough King"}
    for _, bossName in pairs(bossNames) do
        if not running then break end
        local mob = fc(workspace:FindFirstChild("Enemies"), bossName)
        if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            A.Notify("Human Trial", "Fighting " .. bossName, 2)
            killMob(bossName, 120)
            task.wait(1)
            return true
        end
    end
    for _, mob in pairs((workspace.Enemies and workspace.Enemies:GetChildren()) or {}) do
        if not running then break end
        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob.Humanoid.MaxHealth > 5000 then
            A.Notify("Human Trial", "Fighting " .. mob.Name, 2)
            killMob(mob.Name, 120)
            task.wait(1)
            return true
        end
    end
    A.Notify("Human Trial", "No suitable boss found", 2)
    return false
end

function module.TrialGhoul()
    A.Notify("Ghoul Trial", "Starting Ghoul trial (waves)...", 2)
    local waveCount = 0
    local maxWaves = 5
    while running and waveCount < maxWaves do
        A.Notify("Ghoul Trial", "Wave " .. (waveCount + 1) .. "/" .. maxWaves, 2)
        local allDead = true
        for _, mob in pairs((workspace.Enemies and workspace.Enemies:GetChildren()) or {}) do
            if not running then break end
            if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                allDead = false
                if mob:FindFirstChild("HumanoidRootPart") then
                    safeTeleport(mob.HumanoidRootPart.Position, 5)
                    A.Attack(mob, {"Combat"}, 0.1)
                    task.wait(0.2)
                end
            end
        end
        if allDead then
            waveCount = waveCount + 1
            task.wait(2)
        else
            task.wait(0.5)
        end
    end
    A.Notify("Ghoul Trial", "Waves completed!", 3)
    return true
end

function module.TrialCyborg()
    A.Notify("Cyborg Trial", "Starting Cyborg trial (avoid rockets)...", 2)
    local hrp = A.HRP()
    if not hrp then return false end
    local startTime = tick()
    local duration = 60
    while running and (tick() - startTime) < duration do
        if not A.Alive() then
            task.wait(1)
        else
            hrp = A.HRP()
            if not hrp then break end
            local avoidPos = nil
            local minDist = math.huge
            -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
                if v.Name == "Rocket" or v.Name == "Projectile" or v.Name == "Missile" then
                    if v:IsA("BasePart") and v:FindFirstChild("Velocity") then
                        local dist = (v.Position - hrp.Position).Magnitude
                        if dist < 100 then
                            local dir = (hrp.Position - v.Position).Unit
                            local newPos = hrp.Position + dir * 50 + Vector3.new(0, 30, 0)
                            if dist < minDist then
                                minDist = dist
                                avoidPos = newPos
                            end
                        end
                    end
                end
            end
            if avoidPos then
                tweenOrTeleport(avoidPos, 300)
            else
                local randomOffset = Vector3.new(math.random(-20, 20), 10, math.random(-20, 20))
                tweenOrTeleport(hrp.Position + randomOffset, 200)
            end
        end
        task.wait(0.3)
    end
    A.Notify("Cyborg Trial", "Survival complete!", 3)
    return true
end

function module.TrialFishman()
    A.Notify("Fishman Trial", "Starting Fishman trial (sea beast)...", 2)
    local seaBeast = nil
    for _, mob in pairs((workspace.Enemies and workspace.Enemies:GetChildren()) or {}) do
        if mob.Name:find("Sea Beast") or mob.Name:find("Seabeast") or mob.Name:find("Terrorshark") then
            if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                seaBeast = mob
                break
            end
        end
    end
    if seaBeast and seaBeast:FindFirstChild("HumanoidRootPart") then
        A.Notify("Fishman Trial", "Found " .. seaBeast.Name, 2)
        killMob(seaBeast.Name, 180)
        task.wait(1)
        return true
    end
    local hrp = A.HRP()
    if hrp then
        local oceanPos = Vector3.new(-6500, -200, -2700)
        tweenOrTeleport(oceanPos, 250)
        task.wait(3)
        for _, mob in pairs((workspace.Enemies and workspace.Enemies:GetChildren()) or {}) do
            if mob.Name:find("Sea") or mob.Name:find("Beast") then
                if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    killMob(mob.Name, 180)
                    return true
                end
            end
        end
    end
    A.Notify("Fishman Trial", "Sea beast not found, try again", 2)
    return false
end

function module.TrialSkypiea()
    A.Notify("Skypiea Trial", "Starting Skypiea trial (platforms)...", 2)
    local hrp = A.HRP()
    if not hrp then return false end
    local platforms = {}
    -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
        if v:IsA("BasePart") and v.Name:find("Platform") then
            if v.Position.Y > 1000 or v.Position.Y > hrp.Position.Y then
                table.insert(platforms, v)
            end
        end
    end
    table.sort(platforms, function(a, b)
        return a.Position.Y < b.Position.Y
    end)
    for i, platform in pairs(platforms) do
        if not running then break end
        A.Notify("Skypiea Trial", "Platform " .. i .. "/" .. #platforms, 2)
        tweenOrTeleport(platform.Position + Vector3.new(0, 5, 0), 200)
        task.wait(1)
        if platform.Position.Y > hrp.Position.Y + 20 then
            local humanoid = A.Hum()
            if humanoid then
                humanoid.Jump = true
                task.wait(0.5)
                tweenOrTeleport(platform.Position + Vector3.new(0, 3, 0), 200)
            end
        end
        task.wait(0.5)
    end
    A.Notify("Skypiea Trial", "Platform sequence complete!", 3)
    return true
end

function module.CompleteTrial(race)
    A.Notify("Trial", "Completing trial for " .. race, 2)
    local raceLower = string.lower(race)
    if raceLower == "mink" then
        return module.TrialMink()
    elseif raceLower == "human" then
        return module.TrialHuman()
    elseif raceLower == "ghoul" then
        return module.TrialGhoul()
    elseif raceLower == "cyborg" then
        return module.TrialCyborg()
    elseif raceLower == "fishman" or raceLower == "shark" then
        return module.TrialFishman()
    elseif raceLower == "skypiea" or raceLower == "angel" then
        return module.TrialSkypiea()
    else
        A.Notify("Trial", "Unknown race: " .. race, 2)
        return false
    end
end

function module.WinTrialPvP()
    A.Notify("Trial PvP", "Fighting opponent in trial...", 2)
    local hrp = A.HRP()
    if not hrp then return false end
    local maxTime = 120
    local elapsed = 0
    while running and elapsed < maxTime do
        if not A.Alive() then
            task.wait(1)
        else
            local nearestEnemy = nil
            local nearestDist = 200
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    local dist = ((function() local _a=A.HRP(); local _b=player.Character and player.Character:FindFirstChild('HumanoidRootPart'); return _a and _b and (_b.Position - _a.Position).Magnitude or math.huge end)())
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestEnemy = player.Character
                    end
                end
            end
            if nearestEnemy and nearestEnemy:FindFirstChild("HumanoidRootPart") then
                safeTeleport(nearestEnemy.HumanoidRootPart.Position, 5)
                A.Attack(nearestEnemy, {"Combat", "Z", "X", "C", "V"}, 0.1)
            else
                local _hrpTmp = A.HRP(); local randomPos = _hrpTmp and (_hrpTmp.Position + Vector3.new(math.random(-50, 50), 0, math.random(-50, 50))) or Vector3.new(0,0,0)
                tweenOrTeleport(randomPos, 200)
            end
        end
        task.wait(0.2)
        elapsed = elapsed + 0.2
    end
    A.Notify("Trial PvP", "PvP period ended", 2)
    return true
end

function module.AutoWinTrial()
    A.Notify("Auto Trial", "Auto-winning trial...", 3)
    local race = getRace()
    A.Notify("Auto Trial", "Detected race: " .. race, 2)
    local entered = module.EnterTempleOfTime()
    if not entered then
        A.Notify("Auto Trial", "Could not enter temple", 2)
        return false
    end
    task.wait(3)
    module.CompleteTrial(race)
    task.wait(2)
    module.WinTrialPvP()
    task.wait(2)
    A.Notify("Auto Trial", "Trial auto-complete finished!", 3)
    return true
end

-- ============================================================
-- RACE V4 GEAR
-- ============================================================
function module.ClockTickingSequence()
    A.Notify("Clock", "Starting clock ticking sequence...", 2)
    local clockPart = nil
    -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
        if v.Name == "Clock" or v.Name == "ClockMechanism" or v.Name == "Gear" then
            if v:IsA("BasePart") then
                clockPart = v
                break
            end
        end
    end
    if clockPart then
        safeTeleport(clockPart.Position, 5)
        task.wait(0.5)
        for i = 1, 12 do
            if not running then break end
            fireclickdetector(clockPart:FindFirstChildOfClass("ClickDetector"))
            task.wait(0.3)
        end
        A.Notify("Clock", "Clock sequence done!", 2)
        return true
    end
    local templePos = TEMPLE_POS + Vector3.new(0, -10, 0)
    tweenOrTeleport(templePos, 200)
    task.wait(2)
    for i = 1, 12 do
        if not running then break end
        commF("Clock", i)
        task.wait(0.3)
    end
    A.Notify("Clock", "Clock sequence done!", 2)
    return true
end

function module.TalkToAncientOne()
    A.Notify("Ancient One", "Finding Ancient One...", 2)
    local npc = fc(workspace:FindFirstChild("NPCs"), "Ancient One")
    if not npc then
        -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
            if v:IsA("Model") and v.Name == "Ancient One" and v:FindFirstChild("HumanoidRootPart") then
                npc = v
                break
            end
        end
    end
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        safeTeleport(npc.HumanoidRootPart.Position, 10)
        task.wait(0.5)
        commF("AncientOne", "1")
        task.wait(0.5)
        commF("AncientOne", "2")
        task.wait(0.5)
        A.Notify("Ancient One", "Talked to Ancient One!", 2)
        return true
    end
    A.Notify("Ancient One", "Not found", 2)
    return false
end

function module.TrainV4Gear()
    A.Notify("V4 Gear", "Training V4 gear...", 2)
    local hrp = A.HRP()
    if not hrp then return false end
    local startTime = tick()
    local trainDuration = 300
    while running and (tick() - startTime) < trainDuration do
        if not A.Alive() then
            task.wait(1)
        else
            hrp = A.HRP()
            if not hrp then break end
            local mob = fc(workspace:FindFirstChild("Enemies"), "Training Dummy")
            if not mob then
                for _, v in pairs((workspace.Enemies and workspace.Enemies:GetChildren()) or {}) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        mob = v
                        break
                    end
                end
            end
            if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                safeTeleport(mob.HumanoidRootPart.Position, 5)
                A.Attack(mob, {"Combat", "Z", "X", "C", "V", "F"}, 0.1)
            else
                local randomOffset = Vector3.new(math.random(-30, 30), 0, math.random(-30, 30))
                tweenOrTeleport(hrp.Position + randomOffset, 200)
            end
        end
        task.wait(0.3)
    end
    A.Notify("V4 Gear", "Training complete!", 2)
    return true
end

function module.UpgradeV4SkillTree()
    A.Notify("Skill Tree", "Upgrading V4 skill tree...", 2)
    local result = commF("UpgradeV4Skill")
    if result then
        A.Notify("Skill Tree", "Skill tree upgraded!", 2)
        return true
    end
    module.TalkToAncientOne()
    task.wait(1)
    commF("UpgradeV4Skill")
    task.wait(1)
    A.Notify("Skill Tree", "Attempted skill tree upgrade", 2)
    return true
end

function module.AutoV4Awakening()
    A.Notify("V4 Awaken", "Auto V4 awakening enabled...", 2)
    task.spawn(function()
        while running do
            if A.Alive() then
                local char = A.Char()
                if char then
                    local v4Active = char:FindFirstChild("V4Active") or char:FindFirstChild("Awakened")
                    if not v4Active or not v4Active.Value then
                        commF("V4Awaken")
                        task.wait(0.5)
                    end
                end
            end
            task.wait(2)
        end
    end)
    return true
end

-- ============================================================
-- WEAPON UNLOCKS
-- ============================================================
function module.AutoSuperhuman()
    A.Notify("Superhuman", "Unlocking Superhuman...", 2)
    local needs = {
        {Item = "Electric Claw", Quest = "Mink", Level = 1500},
        {Item = "Sharkman Karate", Quest = "Shark", Level = 1500},
        {Item = "Death Step", Quest = "Human", Level = 1500},
        {Item = "Dragon Talon", Quest = "Angel", Level = 1500}
    }
    for _, req in pairs(needs) do
        if not running then break end
        local has = checkHasItem(req.Item)
        if not has then
            A.Notify("Superhuman", "Need " .. req.Item, 2)
        end
    end
    if A.Lv() < 1500 then
        A.Notify("Superhuman", "Need level 1500+", 2)
        return false
    end
    commF("BuySuperhuman")
    task.wait(1)
    commF("BuySuperhuman", "2")
    task.wait(1)
    A.Notify("Superhuman", "Superhuman unlock attempted!", 2)
    return true
end

function module.AutoDeathStep()
    A.Notify("Death Step", "Unlocking Death Step...", 2)
    if A.Lv() < 1500 then
        A.Notify("Death Step", "Need level 1500+", 2)
        return false
    end
    local hasKen = checkHasItem("Ken")
    local hasShadow = checkHasItem("Dark Step")
    if not hasKen then
        A.Notify("Death Step", "Farming Ken...", 2)
        killMob("Ken", 120)
        task.wait(1)
    end
    local npc = fc(workspace:FindFirstChild("NPCs"), "Death Step Teacher")
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        safeTeleport(npc.HumanoidRootPart.Position, 10)
        task.wait(0.5)
        commF("DeathStep", "2")
        task.wait(1)
    end
    commF("BuyDeathStep")
    task.wait(1)
    A.Notify("Death Step", "Death Step unlock attempted!", 2)
    return true
end

function module.AutoSharkmanKarate()
    A.Notify("Sharkman Karate", "Unlocking Sharkman Karate...", 2)
    if A.Lv() < 1500 then
        A.Notify("Sharkman Karate", "Need level 1500+", 2)
        return false
    end
    local hasShark = checkHasItem("Shark")
    if not hasShark then
        A.Notify("Sharkman Karate", "Need Shark drops...", 2)
        for _, mob in pairs((workspace.Enemies and workspace.Enemies:GetChildren()) or {}) do
            if not running then break end
            if mob.Name:find("Shark") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                killMob(mob.Name, 60)
            end
        end
    end
    local npc = fc(workspace:FindFirstChild("NPCs"), "Sharkman Karate")
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        safeTeleport(npc.HumanoidRootPart.Position, 10)
        task.wait(0.5)
        commF("BuySharkman", "2")
        task.wait(1)
    end
    commF("BuySharkmanKarate")
    task.wait(1)
    A.Notify("Sharkman Karate", "Sharkman Karate unlock attempted!", 2)
    return true
end

function module.AutoElectricClaw()
    A.Notify("Electric Claw", "Unlocking Electric Claw...", 2)
    if A.Lv() < 1500 then
        A.Notify("Electric Claw", "Need level 1500+", 2)
        return false
    end
    local npc = fc(workspace:FindFirstChild("NPCs"), "Electricity Expert")
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        safeTeleport(npc.HumanoidRootPart.Position, 10)
        task.wait(0.5)
    end
    commF("BuyElectricClaw")
    task.wait(1)
    A.Notify("Electric Claw", "Electric Claw unlock attempted!", 2)
    return true
end

function module.AutoGodhuman()
    A.Notify("Godhuman", "Unlocking Godhuman...", 2)
    if A.Lv() < 2200 then
        A.Notify("Godhuman", "Need level 2200+", 2)
        return false
    end
    local hasKarate = checkHasItem("Electric Claw")
    local hasTalon = checkHasItem("Dragon Talon")
    local hasSanguine = checkHasItem("Sanguine Art")
    if not hasKarate or not hasTalon then
        A.Notify("Godhuman", "Need prerequisite fighting styles", 2)
        return false
    end
    commF("BuyGodhuman")
    task.wait(1)
    A.Notify("Godhuman", "Godhuman unlock attempted!", 2)
    return true
end

function module.AutoDragonTalon()
    A.Notify("Dragon Talon", "Unlocking Dragon Talon...", 2)
    if A.Lv() < 1500 then
        A.Notify("Dragon Talon", "Need level 1500+", 2)
        return false
    end
    local hasBones = checkHasItem("Bones")
    if not hasBones then
        A.Notify("Dragon Talon", "Farming Bones...", 2)
        for _, mob in pairs((workspace.Enemies and workspace.Enemies:GetChildren()) or {}) do
            if not running then break end
            if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                safeTeleport(mob.HumanoidRootPart.Position, 5)
                A.Attack(mob, {"Combat"}, 0.1)
                task.wait(0.2)
            end
        end
    end
    local npc = fc(workspace:FindFirstChild("NPCs"), "Dragon Talon Sage")
    if not npc then
        -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
            if v:IsA("Model") and v.Name:find("Dragon") and v:FindFirstChild("HumanoidRootPart") then
                npc = v
                break
            end
        end
    end
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        safeTeleport(npc.HumanoidRootPart.Position, 10)
        task.wait(0.5)
        commF("DragonTalon", "1")
        task.wait(0.5)
        commF("DragonTalon", "2")
        task.wait(0.5)
    end
    commF("BuyDragonTalon")
    task.wait(1)
    A.Notify("Dragon Talon", "Dragon Talon unlock attempted!", 2)
    return true
end

function module.AutoSanguineArt()
    A.Notify("Sanguine Art", "Unlocking Sanguine Art...", 2)
    if A.Lv() < 2300 then
        A.Notify("Sanguine Art", "Need level 2300+", 2)
        return false
    end
    local hasLeviathan = checkHasItem("Leviathan Heart")
    if not hasLeviathan then
        A.Notify("Sanguine Art", "Need Leviathan Heart", 2)
        return false
    end
    local npc = fc(workspace:FindFirstChild("NPCs"), "Sanguine Art Master")
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        safeTeleport(npc.HumanoidRootPart.Position, 10)
        task.wait(0.5)
        commF("SanguineArt", "1")
        task.wait(0.5)
    end
    commF("BuySanguineArt")
    task.wait(1)
    A.Notify("Sanguine Art", "Sanguine Art unlock attempted!", 2)
    return true
end

-- ============================================================
-- WEAPON QUESTS
-- ============================================================
function module.AutoSaberQuest()
    A.Notify("Saber Quest", "Starting Saber quest...", 2)
    if A.Lv() < 200 then
        A.Notify("Saber Quest", "Need level 200+", 2)
        return false
    end
    commF("SaberQuest", "1")
    task.wait(1)
    local switches = {
        Vector3.new(-1343, 18, 758),
        Vector3.new(1616, 28, 752),
        Vector3.new(1616, 28, 873),
        Vector3.new(-1330, 23, 586),
        Vector3.new(-1330, 23, 710)
    }
    for i, pos in pairs(switches) do
        if not running then break end
        A.Notify("Saber Quest", "Switch " .. i .. "/5", 2)
        tweenOrTeleport(pos, 250)
        task.wait(1)
        -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
            if v.Name == "Switch" and v:IsA("BasePart") then
                if (v.Position - pos).Magnitude < 50 then
                    fireclickdetector(v:FindFirstChildOfClass("ClickDetector"))
                    task.wait(0.5)
                end
            end
        end
    end
    task.wait(1)
    local boss = fc(workspace:FindFirstChild("Enemies"), "Saber Expert")
    if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
        killMob("Saber Expert", 120)
    end
    commF("SaberQuest", "2")
    task.wait(1)
    A.Notify("Saber Quest", "Saber quest complete!", 3)
    return true
end

function module.AutoTushitaQuest()
    A.Notify("Tushita Quest", "Starting Tushita quest...", 2)
    if A.Lv() < 2000 then
        A.Notify("Tushita Quest", "Need level 2000+", 2)
        return false
    end
    commF("TushitaQuest", "1")
    task.wait(1)
    local locations = {
        Vector3.new(-5670, 120, -1200),
        Vector3.new(-3100, 120, -1400),
        Vector3.new(-4700, 120, -800),
        Vector3.new(-2300, 120, -1800)
    }
    for i, pos in pairs(locations) do
        if not running then break end
        A.Notify("Tushita Quest", "Location " .. i .. "/" .. #locations, 2)
        tweenOrTeleport(pos, 250)
        task.wait(2)
    end
    local boss = fc(workspace:FindFirstChild("Enemies"), "Longma")
    if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
        killMob("Longma", 180)
    end
    commF("TushitaQuest", "2")
    task.wait(1)
    A.Notify("Tushita Quest", "Tushita quest complete!", 3)
    return true
end

function module.AutoYamaQuest()
    A.Notify("Yama Quest", "Starting Yama quest...", 2)
    local killCount = 0
    local requiredKills = 30
    while running and killCount < requiredKills do
        if not A.Alive() then
            task.wait(1)
        else
            local mob = findNearestType(workspace.Enemies, "Model", 500)
            if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                safeTeleport(mob.HumanoidRootPart.Position, 5)
                A.Attack(mob, {"Combat"}, 0.1)
                task.wait(0.2)
                if mob.Humanoid.Health <= 0 then
                    killCount = killCount + 1
                end
            else
                task.wait(1)
            end
        end
    end
    A.Notify("Yama Quest", "Kills: " .. killCount .. "/" .. requiredKills, 3)
    local sword = workspace:FindFirstChild("SwordAltar") or workspace:FindFirstChild("YamaSword")
    if not sword then
        -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
            if v.Name == "Yama" and v:IsA("BasePart") then
                sword = v
                break
            end
        end
    end
    if sword then
        safeTeleport(sword.Position, 5)
        task.wait(0.5)
        fireclickdetector(sword:FindFirstChildOfClass("ClickDetector"))
    end
    A.Notify("Yama Quest", "Yama quest complete!", 3)
    return true
end

function module.AutoSoulGuitar()
    A.Notify("Soul Guitar", "Starting Soul Guitar quest...", 2)
    if A.Lv() < 2200 then
        A.Notify("Soul Guitar", "Need level 2200+", 2)
        return false
    end
    local gunParts = {
        {Name = " ectoplasm", Count = 200},
        {Name = "Ectoplasm", Count = 200}
    }
    for _, part in pairs(gunParts) do
        local has, count = checkHasItem(part.Name)
        if not has or count < part.Count then
            A.Notify("Soul Guitar", "Farming Ectoplasm...", 2)
            for i = 1, 50 do
                if not running then break end
                local mob = fc(workspace:FindFirstChild("Enemies"), "Cursed Captain")
                    or fc(workspace:FindFirstChild("Enemies"), "Ship Engineer")
                if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    killMob(mob.Name, 30)
                    task.wait(0.3)
                else
                    local found = findNearestType(workspace.Enemies, "Model", 500)
                    if found and found:FindFirstChild("HumanoidRootPart") then
                        killMob(found.Name, 30)
                    end
                    task.wait(1)
                end
            end
            break
        end
    end
    local gravestone = nil
    -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
        if v.Name == "Gravestone" or v.Name == "Soul Guitar" then
            if v:IsA("BasePart") then
                gravestone = v
                break
            end
        end
    end
    if gravestone then
        safeTeleport(gravestone.Position, 5)
        task.wait(0.5)
        fireclickdetector(gravestone:FindFirstChildOfClass("ClickDetector"))
        task.wait(0.5)
        commF("SoulGuitar", "1")
        task.wait(0.5)
        commF("SoulGuitar", "2")
        task.wait(0.5)
    end
    A.Notify("Soul Guitar", "Soul Guitar quest attempted!", 3)
    return true
end

function module.AutoTTK()
    A.Notify("TTK", "Starting True Triple Katana quest...", 2)
    local swords = {"Shisui", "Saddi", "Wando"}
    for _, swordName in pairs(swords) do
        if not running then break end
        local has = checkHasItem(swordName)
        if not has then
            A.Notify("TTK", "Need " .. swordName, 2)
            local mob = findNearestType(workspace.Enemies, "Model", 500)
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                killMob(mob.Name, 120)
            end
            task.wait(1)
        end
    end
    local hasAll = true
    for _, swordName in pairs(swords) do
        local has = checkHasItem(swordName)
        if not has then
            hasAll = false
        end
    end
    if hasAll then
        commF("BuyTrueTripleKatana")
        task.wait(1)
        A.Notify("TTK", "TTK purchased!", 3)
    else
        A.Notify("TTK", "Missing swords for TTK", 2)
    end
    return hasAll
end

-- ============================================================
-- HAKI
-- ============================================================
function module.AutoBusoHaki()
    A.Notify("Buso Haki", "Training Buso Haki...", 2)
    local startTime = tick()
    local duration = 600
    while running and (tick() - startTime) < duration do
        if not A.Alive() then
            task.wait(1)
        else
            local mob = findNearestType(workspace.Enemies, "Model", 500)
            if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                safeTeleport(mob.HumanoidRootPart.Position, 5)
                local hum = A.Hum()
                if hum then
                    hum:EquipTool(A.Char():FindFirstChildOfClass("Tool"))
                end
                task.wait(0.5)
                commF("Buso")
                task.wait(0.3)
                A.Attack(mob, {"Combat"}, 0.1)
            else
                task.wait(2)
            end
        end
        task.wait(0.5)
    end
    A.Notify("Buso Haki", "Buso training complete!", 2)
    return true
end

function module.AutoObservationV1()
    A.Notify("Observation V1", "Training Observation V1...", 2)
    local startTime = tick()
    local duration = 600
    while running and (tick() - startTime) < duration do
        if not A.Alive() then
            task.wait(1)
        else
            commF("Ken")
            task.wait(1)
            local mob = findNearestType(workspace.Enemies, "Model", 500)
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                safeTeleport(mob.HumanoidRootPart.Position, 15)
                task.wait(1)
            end
        end
        task.wait(1)
    end
    A.Notify("Observation V1", "Observation V1 training complete!", 2)
    return true
end

function module.AutoObservationV2()
    A.Notify("Observation V2", "Starting Hungry Man quest...", 2)
    local npc = fc(workspace:FindFirstChild("NPCs"), "Hungry Man")
    if not npc then
        -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
            if v:IsA("Model") and v.Name == "Hungry Man" and v:FindFirstChild("HumanoidRootPart") then
                npc = v
                break
            end
        end
    end
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        safeTeleport(npc.HumanoidRootPart.Position, 10)
        task.wait(0.5)
        commF("HungryMan", "1")
        task.wait(0.5)
    end
    local foods = {"Fish", "Dough", "Dinosaur", "Ice"}
    for _, food in pairs(foods) do
        if not running then break end
        A.Notify("Observation V2", "Looking for " .. food, 2)
        local has = checkHasItem(food)
        if not has then
            local mob = fc(workspace:FindFirstChild("Enemies"), food)
            if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                killMob(food, 60)
            else
                for _, v in pairs((workspace.Enemies and workspace.Enemies:GetChildren()) or {}) do
                    if v.Name:find(food) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        killMob(v.Name, 60)
                        break
                    end
                end
            end
        end
    end
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        safeTeleport(npc.HumanoidRootPart.Position, 10)
        task.wait(0.5)
        commF("HungryMan", "2")
        task.wait(1)
    end
    A.Notify("Observation V2", "Observation V2 attempted!", 3)
    return true
end

function module.TrainObservationEXP()
    A.Notify("Obs EXP", "Training observation EXP...", 2)
    local startTime = tick()
    local duration = 900
    while running and (tick() - startTime) < duration do
        if not A.Alive() then
            task.wait(1)
        else
            commF("Ken")
            task.wait(0.5)
            local mob = findNearestType(workspace.Enemies, "Model", 500)
            if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                safeTeleport(mob.HumanoidRootPart.Position, 20)
                task.wait(1.5)
            else
                task.wait(2)
            end
        end
        task.wait(1)
    end
    A.Notify("Obs EXP", "Observation EXP training complete!", 2)
    return true
end

function module.AutoRainbowHaki()
    A.Notify("Rainbow Haki", "Starting Rainbow Haki quest...", 2)
    local npc = fc(workspace:FindFirstChild("NPCs"), "Hungry Man")
    if not npc then
        -- FIX: throttle GetDescendants max 300 + cache
        for _, v in pairs(_RACE_SafeDescendants(workspace, 300)) do
            if v:IsA("Model") and v.Name == "Hungry Man" and v:FindFirstChild("HumanoidRootPart") then
                npc = v
                break
            end
        end
    end
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        safeTeleport(npc.HumanoidRootPart.Position, 10)
        task.wait(0.5)
        commF("Rainbow", "1")
        task.wait(0.5)
    end
    local colorIndex = 0
    local colors = {
        {"Red", 0.8, 0.1, 0.1},
        {"Orange", 0.9, 0.5, 0.1},
        {"Yellow", 1, 1, 0},
        {"Green", 0.1, 0.8, 0.1},
        {"Blue", 0.1, 0.1, 0.9},
        {"Purple", 0.5, 0.1, 0.9}
    }
    for i, colorData in pairs(colors) do
        if not running then break end
        A.Notify("Rainbow Haki", "Color " .. i .. ": " .. colorData[1], 2)
        commF("SetHakiColor", colorData[1])
        task.wait(0.5)
        for _ = 1, 10 do
            if not running then break end
            local mob = findNearestType(workspace.Enemies, "Model", 500)
            if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                safeTeleport(mob.HumanoidRootPart.Position, 5)
                commF("Buso")
                A.Attack(mob, {"Combat"}, 0.1)
            end
            task.wait(0.5)
        end
    end
    A.Notify("Rainbow Haki", "Rainbow Haki quest complete!", 3)
    return true
end

function module.BuyHakiColors()
    A.Notify("Haki Colors", "Buying all Haki colors...", 2)
    local colors = {"Red", "Blue", "Green", "Orange", "Yellow", "Purple", "Pink", "White", "Black", "Brown", "Cyan", "Lime"}
    for _, color in pairs(colors) do
        if not running then break end
        commF("BuyHakiColor", color)
        task.wait(0.3)
    end
    A.Notify("Haki Colors", "All colors purchased!", 2)
    return true
end

-- ============================================================
-- FULL AUTO MODES
-- ============================================================
function module.AutoAllWeaponUnlocks()
    A.Notify("Full Auto", "Unlocking all weapons...", 3)
    module.AutoSuperhuman()
    task.wait(1)
    module.AutoDeathStep()
    task.wait(1)
    module.AutoSharkmanKarate()
    task.wait(1)
    module.AutoElectricClaw()
    task.wait(1)
    module.AutoDragonTalon()
    task.wait(1)
    module.AutoGodhuman()
    task.wait(1)
    module.AutoSanguineArt()
    task.wait(1)
    module.AutoSaberQuest()
    task.wait(1)
    module.AutoTushitaQuest()
    task.wait(1)
    module.AutoYamaQuest()
    task.wait(1)
    module.AutoSoulGuitar()
    task.wait(1)
    module.AutoTTK()
    A.Notify("Full Auto", "All weapon unlocks attempted!", 3)
    return true
end

function module.AutoAllRaceUpgrades()
    A.Notify("Full Auto", "Upgrading all races...", 3)
    local race = getRace()
    module.FarmAllFlowers()
    task.wait(1)
    module.AcceptV2Quest()
    task.wait(1)
    module.CompleteV2Quest()
    task.wait(1)
    module.FarmV3Materials(race)
    task.wait(1)
    module.CompleteV3Quest(race)
    task.wait(1)
    if module.DetectFullMoon() or module.WaitFullMoon() then
        module.EnterTempleOfTime()
        task.wait(2)
        module.CompleteTrial(race)
        task.wait(1)
        module.WinTrialPvP()
        task.wait(1)
        module.TalkToAncientOne()
        task.wait(1)
        module.UpgradeV4SkillTree()
    end
    A.Notify("Full Auto", "All race upgrades attempted!", 3)
    return true
end

function module.AutoAllHaki()
    A.Notify("Full Auto", "Training all Haki...", 3)
    module.AutoBusoHaki()
    task.wait(1)
    module.AutoObservationV1()
    task.wait(1)
    module.AutoObservationV2()
    task.wait(1)
    module.TrainObservationEXP()
    task.wait(1)
    module.AutoRainbowHaki()
    task.wait(1)
    module.BuyHakiColors()
    A.Notify("Full Auto", "All Haki training complete!", 3)
    return true
end

-- ============================================================
-- MAIN LOOP
-- ============================================================
function module.Start(mode)
    if running then
        A.Notify("Race V4 Adv", "Already running!", 2)
        return
    end
    running = true
    A.Notify("Race V4 Adv", "Started (" .. tostring(mode or "manual") .. ")", 3)

    task.spawn(function()
        if mode == "full" then
            module.AutoAllRaceUpgrades()
            module.AutoAllWeaponUnlocks()
            module.AutoAllHaki()
        elseif mode == "race" then
            module.AutoAllRaceUpgrades()
        elseif mode == "weapons" then
            module.AutoAllWeaponUnlocks()
        elseif mode == "haki" then
            module.AutoAllHaki()
        elseif mode == "trial" then
            module.AutoWinTrial()
        elseif mode == "v4" then
            module.AutoV4Awakening()
        elseif mode == "moon" then
            module.AutoFullMoonAlert()
        elseif mode == "flower" then
            module.FarmAllFlowers()
        elseif mode == "saber" then
            module.AutoSaberQuest()
        elseif mode == "soulguitar" then
            module.AutoSoulGuitar()
        elseif mode == "ttk" then
            module.AutoTTK()
        else
            A.Notify("Race V4 Adv", "Set mode: full, race, weapons, haki, trial, v4, moon, flower, saber, soulguitar, ttk", 5)
        end
        running = false
        A.Notify("Race V4 Adv", "Finished!", 2)
    end)
end

function module.Stop()
    running = false
    for _, conn in pairs(connections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    connections = {}
    if moonConn then
        moonConn:Disconnect()
        moonConn = nil
    end
    A.Notify("Race V4 Adv", "Stopped", 2)
end

function module.IsRunning()
    return running
end

-- Distinctive Race V4 Full Automation (was partial vs Redz)
function module.StartFullRaceV4()
    if running then return end
    local races = {"Mink","Ghoul","Cyborg","Human","Skypian","Fishman"}
    for _, race in ipairs(races) do
        pcall(function()
            if A.Distinctive then A.Distinctive.ShowModuleHologram("Race V4", "Trial: "..race, "🏁") end
            module.Start(race)
            repeat task.wait(1) until not module.IsRunning() or not A.F.RaceV4
        end)
    end
end

A.Register("race_v4_advanced", module)
return module
