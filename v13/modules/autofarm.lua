local A = _G.Apex

A.Farm = {}
A.Farm.Active = false
A.Farm.Paused = false
A.Farm.CurrentQuest = nil
A.Farm.CurrentMob = nil
A.Farm.KillCount = 0
A.Farm.XpGained = 0
A.Farm.StartTime = 0
A.Farm.LastQuest = nil
A.Farm.QuestRetries = 0
A.Farm.TotalQuestsCompleted = 0
A.Farm.ZoneIndex = 0
A.Farm.LastZone = ""
A.Farm.StuckCount = 0
A.Farm.LastPosition = nil
A.Farm.LastPositionTime = 0
A.Farm.MobBlacklist = {}
A.Farm.LoopConnection = nil
A.Farm.WeaponCache = nil
A.Farm.LastWeaponCheck = 0
A.Farm.LastStatCheck = 0
A.Farm.LastHakiCheck = 0
A.Farm.LastChestCheck = 0
A.Farm.LastAutoSellCheck = 0
A.Farm.LastHealthCheck = 0
A.Farm.PathfindAttempts = 0
A.Farm.CurrentPath = nil
A.Farm.ZoneMobs = {}
A.Farm.FarmingStats = {
    kills = 0,
    quests = 0,
    xp = 0,
    deaths = 0,
    rejoins = 0,
    stuck = 0,
    errors = 0,
    bossKills = 0,
    chestsCollected = 0,
    timeSpent = 0,
    questFailures = 0,
    zoneChanges = 0,
    weaponsSwapped = 0,
    hakiActivations = 0,
    foodUsed = 0,
    retreats = 0
}

local QuestCache = {}
local MobCache = {}
local NPCCache = {}
local LastQuestAccept = 0
local LastQuestComplete = 0
local QuestAcceptDelay = 1.5
local QuestCompleteDelay = 1.0
local MobSpawnTimeout = 8
local AttackCooldown = 0.35
local StuckThreshold = 5
local StuckCheckInterval = 2
local HealthRetreatPercent = 25
local HealthFoodPercent = 60
local MaxPathfindAttempts = 10
local ChestSearchRadius = 80
local AutoSellInterval = 30
local StatCheckInterval = 15
local HakiCheckInterval = 10

local function safeCall(fn, ...)
    local ok, result = pcall(fn, ...)
    if ok then return result end
    return nil
end

local function getTime()
    return tick()
end

local function getQuestDB()
    return A.Quests or {}
end

local function getBossDB()
    return A.BossData or {}
end

local function getMobFolder()
    local g = A.G
    if not g then return nil end
    local folder = g:FindFirstChild("Workspace") or g.Workspace
    if not folder then return nil end
    return folder:FindFirstChild("Enemies") or folder:FindFirstChild("Mobs") or folder:FindFirstChild("Monsters")
end

local function getNPCFolder()
    local g = A.G
    if not g then return nil end
    local folder = g:FindFirstChild("Workspace") or g.Workspace
    if not folder then return nil end
    return folder:FindFirstChild("NPCs") or folder:FindFirstChild("QuestGivers")
end

local function distanceBetween(pos1, pos2)
    if not pos1 or not pos2 then return math.huge end
    local v1 = A.V3(pos1.X, pos1.Y, pos1.Z)
    local v2 = A.V3(pos2.X, pos2.Y, pos2.Z)
    return (v1 - v2).Magnitude
end

local function posFromPart(part)
    if not part then return nil end
    local p = part.Position
    return A.V3(p.X, p.Y, p.Z)
end

local function cframeFromPart(part)
    if not part then return nil end
    return part.CFrame
end

local function getHRPPos()
    local hrp = A.HRP()
    if hrp then return posFromPart(hrp) end
    return nil
end

local function getCharacter()
    return A.Char()
end

local function isAlive()
    return A.Alive()
end

local function waitForCondition(checkFn, timeout, interval)
    timeout = timeout or 10
    interval = interval or 0.25
    local start = getTime()
    while getTime() - start < timeout do
        if not A.Farm.Active then return false end
        local result = checkFn()
        if result then return result end
        task.wait(interval)
    end
    return false
end

local function getLevel()
    return A.Lv() or 1
end

local function getSea()
    return A.Sea() or 1
end

local function dividePoints(total, splits)
    local result = {}
    local base = math.floor(total / #splits)
    local remainder = total - (base * #splits)
    for i, split in ipairs(splits) do
        local extra = 0
        if i <= remainder then extra = 1 end
        result[split] = base + extra
    end
    return result
end

A.Farm.GetMobHealth = function(mob)
    if not mob then return 0, 0 end
    local hum = mob:FindFirstChildOfClass("Humanoid")
    if not hum then return 0, 0 end
    return hum.Health, hum.MaxHealth
end

A.Farm.GetMobDistance = function(mob)
    local mobPart = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso") or mob:FindFirstChild("UpperTorso")
    if not mobPart then return math.huge end
    local hrp = A.HRP()
    if not hrp then return math.huge end
    return distanceBetween(posFromPart(hrp), posFromPart(mobPart))
end

A.Farm.IsMobAlive = function(mob)
    if not mob then return false end
    local hum = mob:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.Health <= 0 then return false end
    if not mob.Parent then return false end
    return true
end

A.Farm.GetMobSpawnPoint = function(mob)
    if not mob then return nil end
    local spawnTag = mob:FindFirstChild("SpawnPoint") or mob:FindFirstChild("SpawnLocation")
    if spawnTag and spawnTag:IsA("Vector3Value") then return spawnTag.Value end
    if spawnTag and spawnTag:IsA("CFrameValue") then return spawnTag.Value.Position end
    local primaryPart = mob.PrimaryPart or mob:FindFirstChild("HumanoidRootPart")
    if primaryPart then return posFromPart(primaryPart) end
    return posFromPart(mob)
end

A.Farm.GetAliveMobs = function()
    local folder = getMobFolder()
    if not folder then return {} end
    local alive = {}
    for _, mob in ipairs(folder:GetChildren()) do
        if A.Farm.IsMobAlive(mob) then
            table.insert(alive, mob)
        end
    end
    return alive
end

A.Farm.CountAliveMobs = function()
    return #A.Farm.GetAliveMobs()
end

A.Farm.GetClosestMob = function(mobs)
    mobs = mobs or A.Farm.GetAliveMobs()
    local closest = nil
    local closestDist = math.huge
    local hrp = A.HRP()
    if not hrp then return nil end
    local hrpPos = posFromPart(hrp)
    for _, mob in ipairs(mobs) do
        local mobPart = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
        if mobPart then
            local dist = distanceBetween(hrpPos, posFromPart(mobPart))
            if dist < closestDist then
                closestDist = dist
                closest = mob
            end
        end
    end
    return closest, closestDist
end

A.Farm.IsMobBlacklisted = function(mob)
    if not mob then return false end
    return A.Farm.MobBlacklist[mob.Name] == true
end

A.Farm.BlacklistMob = function(mob)
    if mob then
        A.Farm.MobBlacklist[mob.Name] = true
    end
end

A.Farm.ClearMobBlacklist = function()
    A.Farm.MobBlacklist = {}
end

A.Farm.WaitForMob = function(spawnPos, timeout)
    timeout = timeout or MobSpawnTimeout
    local start = getTime()
    while getTime() - start < timeout do
        if not A.Farm.Active then return false end
        if not isAlive() then return false end
        local mobs = A.Farm.GetAliveMobs()
        for _, mob in ipairs(mobs) do
            local mobPart = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
            if mobPart then
                local dist = distanceBetween(spawnPos, posFromPart(mobPart))
                if dist < 60 then
                    return mob
                end
            end
        end
        task.wait(0.5)
    end
    return false
end

A.Farm.MobSpawned = function(pos, range)
    range = range or 80
    local mobs = A.Farm.GetAliveMobs()
    for _, mob in ipairs(mobs) do
        local mobPart = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
        if mobPart then
            local dist = distanceBetween(pos, posFromPart(mobPart))
            if dist <= range then
                return mob
            end
        end
    end
    return false
end

A.Farm.FindQuestMob = function(questData)
    if not questData then return nil end
    local targetName = questData.mobName or questData.MobName or questData.target
    if not targetName then return nil end
    local folder = getMobFolder()
    if not folder then return nil end
    local candidates = {}
    for _, mob in ipairs(folder:GetChildren()) do
        if A.Farm.IsMobAlive(mob) and not A.Farm.IsMobBlacklisted(mob) then
            if mob.Name == targetName or string.find(mob.Name, targetName) then
                table.insert(candidates, mob)
            end
        end
    end
    if #candidates == 0 then return nil end
    return A.Farm.GetClosestMob(candidates)
end

A.Farm.GetQuestProgress = function()
    local quest = A.Farm.CurrentQuest
    if not quest then return 0, 0 end
    local needed = quest.killCount or quest.KillCount or quest.required or 10
    local current = quest.currentKills or quest.Kills or 0
    return current, needed
end

A.Farm.GetQuestTarget = function()
    local quest = A.Farm.CurrentQuest
    if not quest then return nil end
    return A.Farm.FindQuestMob(quest)
end

A.Farm.GetClosestQuestMob = function()
    return A.Farm.GetQuestTarget()
end

A.Farm.HasQuest = function()
    return A.Farm.CurrentQuest ~= nil
end

A.Farm.GetQuest = function()
    return A.Farm.CurrentQuest
end

A.Farm.IsQuestComplete = function()
    if not A.Farm.HasQuest() then return false end
    local current, needed = A.Farm.GetQuestProgress()
    return current >= needed
end

A.Farm.GetQuestDataForLevel = function(level)
    level = level or getLevel()
    local db = getQuestDB()
    local bestQuest = nil
    local bestLevelDiff = math.huge
    for _, questData in pairs(db) do
        local qLevel = questData.level or questData.Level or questData.minLevel or 1
        local maxLevel = questData.maxLevel or questData.Level or qLevel + 20
        if level >= qLevel and level <= maxLevel then
            local diff = math.abs(level - qLevel)
            if diff < bestLevelDiff then
                bestLevelDiff = diff
                bestQuest = questData
            end
        end
    end
    return bestQuest
end

A.Farm.OptimizeQuestSelection = function()
    local level = getLevel()
    local questData = A.Farm.GetQuestDataForLevel(level)
    if not questData then
        A.Notify("Auto Farm", "No quest found for level " .. level, 3)
        return nil
    end
    local sea = getSea()
    if questData.sea and questData.sea ~= sea then
        A.Notify("Auto Farm", "Quest requires sea " .. questData.sea, 3)
        return nil
    end
    if A.Farm.LastQuest and questData.name == A.Farm.LastQuest.name then
        if A.Farm.QuestRetries > 3 then
            local allQuests = getQuestDB()
            for _, alt in pairs(allQuests) do
                local altLevel = alt.level or alt.Level or 1
                local altMax = alt.maxLevel or alt.Level or altLevel + 20
                if level >= altLevel and level <= altMax and alt.name ~= questData.name then
                    A.Farm.QuestRetries = 0
                    return alt
                end
            end
        end
    end
    return questData
end

A.Farm.AcceptQuest = function(questData)
    if not questData then return false end
    local npcName = questData.npcName or questData.NPC or questData.questGiver
    if not npcName then return false end
    local now = getTime()
    if now - LastQuestAccept < QuestAcceptDelay then
        task.wait(QuestAcceptDelay - (now - LastQuestAccept))
    end
    local npcFolder = getNPCFolder()
    if not npcFolder then
        local workspace = A.G.Workspace
        npcFolder = workspace:FindFirstChild("NPCs") or workspace:FindFirstChild("QuestGivers")
    end
    local npc = nil
    if npcFolder then
        for _, child in ipairs(npcFolder:GetChildren()) do
            if child.Name == npcName or string.find(child.Name, npcName) then
                npc = child
                break
            end
        end
    end
    if not npc then
        local workspace = A.G.Workspace
        for _, child in ipairs(workspace:GetChildren()) do
            if child.Name == npcName or string.find(child.Name, npcName) then
                npc = child
                break
            end
        end
    end
    if not npc then
        A.Farm.QuestRetries = A.Farm.QuestRetries + 1
        A.Notify("Auto Farm", "Quest NPC not found: " .. tostring(npcName), 3)
        return false
    end
    local npcPos = posFromPart(npc)
    if not npcPos then
        A.Notify("Auto Farm", "Cannot get NPC position", 3)
        return false
    end
    local distToNPC = distanceBetween(getHRPPos(), npcPos)
    if distToNPC > 15 then
        A.TpTo(npcPos, 8)
        task.wait(0.5)
    end
    local hrp = A.HRP()
    if hrp then
        local npcCFrame = cframeFromPart(npc)
        if npcCFrame then
            hrp.CFrame = npcCFrame * A.CF(0, 0, -4)
            task.wait(0.3)
        end
    end
    local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        pcall(function()
            fireproximityprompt(prompt, 0)
        end)
        task.wait(0.5)
    end
    local questId = questData.id or questData.Id or questData.name or questData.Name
    local commResult = A.CommF("AcceptQuest", questId)
    if commResult == false then
        A.CommF("SetQuest", questId)
    end
    task.wait(QuestAcceptDelay)
    A.Farm.CurrentQuest = {
        name = questData.name or questData.Name or "Unknown",
        mobName = questData.mobName or questData.MobName or questData.target,
        killCount = questData.killCount or questData.KillCount or questData.required or 10,
        currentKills = 0,
        level = questData.level or questData.Level or getLevel(),
        xpReward = questData.xpReward or questData.XP or 0,
        npcName = npcName,
        startTime = getTime()
    }
    A.Farm.QuestRetries = 0
    LastQuestAccept = getTime()
    A.Notify("Auto Farm", "Accepted quest: " .. A.Farm.CurrentQuest.name, 2)
    return true
end

A.Farm.CompleteQuest = function()
    if not A.Farm.HasQuest() then return false end
    if not A.Farm.IsQuestComplete() then return false end
    local now = getTime()
    if now - LastQuestComplete < QuestCompleteDelay then
        task.wait(QuestCompleteDelay - (now - LastQuestComplete))
    end
    local quest = A.Farm.CurrentQuest
    local npcName = quest.npcName
    if npcName then
        local npcFolder = getNPCFolder()
        if not npcFolder then
            npcFolder = A.G.Workspace:FindFirstChild("NPCs") or A.G.Workspace:FindFirstChild("QuestGivers")
        end
        if npcFolder then
            for _, npc in ipairs(npcFolder:GetChildren()) do
                if npc.Name == npcName or string.find(npc.Name, npcName) then
                    local npcPos = posFromPart(npc)
                    if npcPos then
                        local dist = distanceBetween(getHRPPos(), npcPos)
                        if dist > 15 then
                            A.TpTo(npcPos, 8)
                            task.wait(0.5)
                        end
                        local hrp = A.HRP()
                        if hrp then
                            local npcCF = cframeFromPart(npc)
                            if npcCF then
                                hrp.CFrame = npcCF * A.CF(0, 0, -4)
                                task.wait(0.3)
                            end
                        end
                        local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            pcall(function()
                                fireproximityprompt(prompt, 0)
                            end)
                            task.wait(0.5)
                        end
                        break
                    end
                end
            end
        end
    end
    local questId = quest.name
    A.CommF("CompleteQuest", questId)
    A.CommF("TurnInQuest", questId)
    task.wait(QuestCompleteDelay)
    local xpGained = quest.xpReward or 0
    A.Farm.XpGained = A.Farm.XpGained + xpGained
    A.Farm.TotalQuestsCompleted = A.Farm.TotalQuestsCompleted + 1
    A.Farm.FarmingStats.quests = A.Farm.FarmingStats.quests + 1
    A.Farm.FarmingStats.xp = A.Farm.FarmingStats.xp + xpGained
    A.Farm.LastQuest = quest
    A.Farm.LastZone = quest.name
    A.Farm.CurrentQuest = nil
    A.Farm.CurrentMob = nil
    A.Farm.KillCount = 0
    LastQuestComplete = getTime()
    A.Notify("Auto Farm", "Quest complete! +" .. xpGained .. " XP", 2)
    return true
end

A.Farm.AbandonQuest = function()
    if not A.Farm.HasQuest() then return false end
    local quest = A.Farm.CurrentQuest
    A.CommF("AbandonQuest", quest.name)
    A.Farm.CurrentQuest = nil
    A.Farm.CurrentMob = nil
    A.Farm.KillCount = 0
    A.Farm.FarmingStats.questFailures = A.Farm.FarmingStats.questFailures + 1
    A.Notify("Auto Farm", "Abandoned quest: " .. quest.name, 2)
    return true
end

A.Farm.ChainQuests = function()
    if A.Farm.IsQuestComplete() then
        A.Farm.CompleteQuest()
        task.wait(0.5)
    end
    if not A.Farm.HasQuest() then
        local questData = A.Farm.OptimizeQuestSelection()
        if questData then
            return A.Farm.AcceptQuest(questData)
        end
    end
    return A.Farm.HasQuest()
end

A.Farm.GetNextQuest = function()
    local level = getLevel()
    local allQuests = getQuestDB()
    local candidates = {}
    for _, q in pairs(allQuests) do
        local qLevel = q.level or q.Level or 1
        local qMax = q.maxLevel or q.Level or qLevel + 20
        if level >= qLevel and level <= qMax then
            table.insert(candidates, q)
        end
    end
    table.sort(candidates, function(a, b)
        local aLvl = a.level or a.Level or 1
        local bLvl = b.level or b.Level or 1
        return aLvl > bLvl
    end)
    for _, q in ipairs(candidates) do
        if A.Farm.LastQuest and q.name == A.Farm.LastQuest.name then
            -- skip already completed
        else
            return q
        end
    end
    if #candidates > 0 then return candidates[1] end
    return nil
end

A.Farm.QuestChain = function()
    if A.Farm.IsQuestComplete() then
        A.Farm.CompleteQuest()
        task.wait(0.3)
    end
    if not A.Farm.HasQuest() then
        local nextQ = A.Farm.GetNextQuest()
        if nextQ then
            return A.Farm.AcceptQuest(nextQ)
        end
        local fallback = A.Farm.OptimizeQuestSelection()
        if fallback then
            return A.Farm.AcceptQuest(fallback)
        end
    end
    return A.Farm.HasQuest()
end

A.Farm.OptimalRoute = function()
    local level = getLevel()
    local route = {}
    local allQuests = getQuestDB()
    for _, q in pairs(allQuests) do
        local qLevel = q.level or q.Level or 1
        if qLevel >= level - 10 and qLevel <= level + 5 then
            table.insert(route, q)
        end
    end
    table.sort(route, function(a, b)
        return (a.level or 1) < (b.level or 1)
    end)
    return route
end

A.Farm.NavigateTo = function(pos)
    if not pos then return false end
    if not isAlive() then return false end
    local hrpPos = getHRPPos()
    if not hrpPos then return false end
    local dist = distanceBetween(hrpPos, pos)
    if dist < 8 then return true end
    if dist < 30 then
        A.TpTo(pos, 5)
        task.wait(0.3)
        local newDist = distanceBetween(getHRPPos(), pos)
        if newDist < 15 then return true end
    end
    local tweenSpeed = A.C and A.C.TweenSpeed or 200
    A.TweenTo(pos, tweenSpeed)
    local timeout = getTime() + 15
    while getTime() - timeout < 0 do
        task.wait(0.1)
    end
    timeout = getTime() + 15
    while getTime() - timeout < 15 do
        if not A.Farm.Active then return false end
        if not isAlive() then return false end
        local currentDist = distanceBetween(getHRPPos(), pos)
        if currentDist < 10 then return true end
        task.wait(0.2)
    end
    A.TpTo(pos, 5)
    task.wait(0.3)
    return distanceBetween(getHRPPos(), pos) < 20
end

A.Farm.FollowPath = function(waypoints)
    if not waypoints or #waypoints == 0 then return false end
    for i, wp in ipairs(waypoints) do
        if not A.Farm.Active then return false end
        if not isAlive() then return false end
        local wpPos = wp.Position or wp
        A.Farm.NavigateTo(wpPos)
        task.wait(0.2)
    end
    return true
end

A.Farm.CircleFarm = function(center, radius)
    center = center or getHRPPos()
    radius = radius or 30
    if not center then return false end
    local angle = (A.Farm.ZoneIndex or 0) * 0.5
    local targetX = center.X + math.cos(angle) * radius
    local targetZ = center.Z + math.sin(angle) * radius
    local targetPos = A.V3(targetX, center.Y, targetZ)
    A.Farm.ZoneIndex = (A.Farm.ZoneIndex or 0) + 1
    A.Farm.NavigateTo(targetPos)
    return true
end

A.Farm.LinearFarm = function(startPos, endPos)
    if not startPos or not endPos then return false end
    local progress = (A.Farm.ZoneIndex or 0) * 0.1
    if progress > 1 then
        A.Farm.ZoneIndex = 0
        progress = 0
    end
    local targetPos = startPos:Lerp(endPos, progress)
    A.Farm.ZoneIndex = (A.Farm.ZoneIndex or 0) + 1
    A.Farm.NavigateTo(targetPos)
    return true
end

A.Farm.ZoneFarm = function(zone)
    if not zone then return false end
    local center = zone.Position or zone.Center
    local radius = zone.Radius or 40
    if center then
        A.Farm.CircleFarm(center, radius)
        return true
    end
    return false
end

A.Farm.RandomFarm = function()
    local hrpPos = getHRPPos()
    if not hrpPos then return false end
    local angle = math.random() * math.pi * 2
    local dist = math.random(15, 50)
    local targetX = hrpPos.X + math.cos(angle) * dist
    local targetZ = hrpPos.Z + math.sin(angle) * dist
    local targetPos = A.V3(targetX, hrpPos.Y, targetZ)
    A.Farm.NavigateTo(targetPos)
    return true
end

A.Farm.AvoidDanger = function(pos)
    if not pos then return pos end
    local g = A.G
    local dangerZones = {}
    local ws = g:FindFirstChild("Workspace") or g.Workspace
    for _, child in ipairs(ws:GetChildren()) do
        if child.Name and string.find(child.Name, "Danger") then
            table.insert(dangerZones, child)
        end
        if child.Name and string.find(child.Name, "Kill") then
            table.insert(dangerZones, child)
        end
    end
    for _, zone in ipairs(dangerZones) do
        local zonePart = zone:IsA("BasePart") and zone or zone:FindFirstChildOfClass("BasePart")
        if zonePart then
            local dist = distanceBetween(pos, posFromPart(zonePart))
            if dist < 30 then
                local hrpPos = getHRPPos() or pos
                local awayDir = (pos - posFromPart(zonePart)).Unit
                return pos + awayDir * 20
            end
        end
    end
    return pos
end

A.Farm.GetSafePosition = function(targetPos)
    if not targetPos then return nil end
    local safePos = A.Farm.AvoidDanger(targetPos)
    if safePos ~= targetPos then return safePos end
    local g = A.G
    local ws = g:FindFirstChild("Workspace") or g.Workspace
    local terrain = ws:FindFirstChildOfClass("Terrain")
    if terrain then
        return targetPos
    end
    return targetPos
end

A.Farm.EquipBestWeapon = function()
    local now = getTime()
    if A.Farm.WeaponCache and (now - A.Farm.LastWeaponCheck) < 10 then
        return A.Farm.WeaponCache
    end
    local bestWeapon = nil
    local bestDamage = 0
    local backpack = A.LP:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local damage = 0
                local stats = item:FindFirstChild("Stats") or item:FindFirstChild("Attribute")
                if stats then
                    local dmg = stats:FindFirstChild("Damage") or stats:FindFirstChild("Value")
                    if dmg and dmg:IsA("NumberValue") then
                        damage = dmg.Value
                    end
                end
                local toolDamage = item:GetAttribute("Damage") or item:GetAttribute("Power") or 0
                damage = math.max(damage, toolDamage)
                if damage > bestDamage then
                    bestDamage = damage
                    bestWeapon = item
                end
            end
        end
    end
    local char = getCharacter()
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then
                bestWeapon = item
                break
            end
        end
    end
    if bestWeapon and backpack then
        if not char:FindFirstChild(bestWeapon.Name) then
            bestWeapon.Parent = char
            task.wait(0.1)
        end
        A.Farm.WeaponCache = bestWeapon
        A.Farm.LastWeaponCheck = now
        A.Farm.FarmingStats.weaponsSwapped = A.Farm.FarmingStats.weaponsSwapped + 1
    end
    return bestWeapon
end

A.Farm.AttackMob = function(mob)
    if not mob then return false end
    if not A.Farm.IsMobAlive(mob) then return false end
    if not isAlive() then return false end
    A.Farm.EquipBestWeapon()
    local mobPart = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
    if not mobPart then return false end
    local mobPos = posFromPart(mobPart)
    local hrp = A.HRP()
    if not hrp then return false end
    local dist = distanceBetween(posFromPart(hrp), mobPos)
    if dist > 12 then
        A.TpTo(mobPos, 5)
        task.wait(0.15)
    end
    local behindOffset = mobPart.CFrame.LookVector * -3
    local attackPos = mobPos + behindOffset
    hrp.CFrame = A.CF(attackPos, mobPos)
    task.wait(0.1)
    local target = mob
    A.Attack(target, {"1", "2", "3", "4", "Q", "E", "R", "F"}, AttackCooldown)
    task.wait(0.1)
    if A.Farm.IsMobAlive(mob) then
        A.SuperAttack(target)
        task.wait(0.1)
    end
    if not A.Farm.IsMobAlive(mob) then
        A.Farm.KillCount = A.Farm.KillCount + 1
        A.Farm.FarmingStats.kills = A.Farm.FarmingStats.kills + 1
        local quest = A.Farm.CurrentQuest
        if quest then
            quest.currentKills = (quest.currentKills or 0) + 1
        end
        return true
    end
    return false
end

A.Farm.SmartCombat = function(mob)
    if not mob then return false end
    if not A.Farm.IsMobAlive(mob) then return false end
    local current, needed = A.Farm.GetQuestProgress()
    local mobHealth, mobMaxHealth = A.Farm.GetMobHealth(mob)
    local playerHealth, playerMaxHealth = 0, 100
    local hum = A.Hum()
    if hum then
        playerHealth = hum.Health
        playerMaxHealth = hum.MaxHealth
    end
    if playerHealth / playerMaxHealth < 0.3 then
        A.Farm.Retreat()
        return false
    end
    A.Farm.EquipBestWeapon()
    local mobPart = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
    if not mobPart then return false end
    local mobPos = posFromPart(mobPart)
    local hrp = A.HRP()
    if not hrp then return false end
    local dist = distanceBetween(posFromPart(hrp), mobPos)
    if dist > 200 then
        A.TpTo(mobPos, 5)
        task.wait(0.3)
        return A.Farm.SmartCombat(mob)
    end
    if dist > 10 then
        local speed = A.C and A.C.TweenSpeed or 200
        A.TweenTo(mobPos, speed)
        local waitStart = getTime()
        while getTime() - waitStart < 5 do
            if not A.Farm.Active or not isAlive() then return false end
            if not A.Farm.IsMobAlive(mob) then return true end
            local d = distanceBetween(getHRPPos(), mobPos)
            if d < 10 then break end
            task.wait(0.15)
        end
    end
    if dist <= 10 then
        local attackPos = mobPos + mobPart.CFrame.LookVector * -2.5
        hrp.CFrame = A.CF(attackPos, mobPos)
        task.wait(0.08)
    end
    local comboKeys = {"1", "2", "3", "4", "Q", "E", "R", "F", "Z", "X", "C", "V"}
    for _, key in ipairs(comboKeys) do
        if not A.Farm.Active or not isAlive() then return false end
        if not A.Farm.IsMobAlive(mob) then break end
        A.Attack(mob, {key}, 0.15)
        task.wait(0.08)
    end
    if A.Farm.IsMobAlive(mob) then
        A.SuperAttack(mob)
        task.wait(0.15)
    end
    if not A.Farm.IsMobAlive(mob) then
        A.Farm.KillCount = A.Farm.KillCount + 1
        A.Farm.FarmingStats.kills = A.Farm.FarmingStats.kills + 1
        local quest = A.Farm.CurrentQuest
        if quest then
            quest.currentKills = (quest.currentKills or 0) + 1
        end
        return true
    end
    return false
end

A.Farm.FastKill = function(mob)
    if not mob or not A.Farm.IsMobAlive(mob) then return false end
    if not isAlive() then return false end
    A.Farm.EquipBestWeapon()
    local mobPart = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
    if not mobPart then return false end
    local mobPos = posFromPart(mobPart)
    local hrp = A.HRP()
    if not hrp then return false end
    hrp.CFrame = A.CF(mobPos + mobPart.CFrame.LookVector * -3, mobPos)
    task.wait(0.05)
    for i = 1, 6 do
        if not A.Farm.IsMobAlive(mob) then break end
        A.Attack(mob, {"1", "2", "3", "4"}, 0.1)
        task.wait(0.05)
    end
    if not A.Farm.IsMobAlive(mob) then
        A.Farm.KillCount = A.Farm.KillCount + 1
        A.Farm.FarmingStats.kills = A.Farm.FarmingStats.kills + 1
        local quest = A.Farm.CurrentQuest
        if quest then
            quest.currentKills = (quest.currentKills or 0) + 1
        end
        return true
    end
    return false
end

A.Farm.SafeKill = function(mob)
    if not mob or not A.Farm.IsMobAlive(mob) then return false end
    if not isAlive() then return false end
    local hum = A.Hum()
    if hum and hum.Health / hum.MaxHealth < 0.5 then
        A.Farm.Retreat()
        return false
    end
    return A.Farm.SmartCombat(mob)
end

A.Farm.ComboKill = function(mob)
    if not mob or not A.Farm.IsMobAlive(mob) then return false end
    if not isAlive() then return false end
    A.Farm.EquipBestWeapon()
    local mobPart = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
    if not mobPart then return false end
    local mobPos = posFromPart(mobPart)
    local hrp = A.HRP()
    if not hrp then return false end
    hrp.CFrame = A.CF(mobPos + mobPart.CFrame.LookVector * -3, mobPos)
    task.wait(0.08)
    local fullCombo = {"1", "2", "3", "4", "Q", "E", "R", "F", "Z", "X", "C", "V", "G", "H"}
    for _, key in ipairs(fullCombo) do
        if not A.Farm.Active or not isAlive() then return false end
        if not A.Farm.IsMobAlive(mob) then break end
        A.Attack(mob, {key}, 0.12)
        task.wait(0.06)
    end
    if A.Farm.IsMobAlive(mob) then
        A.SuperAttack(mob)
        task.wait(0.1)
        for _, key in ipairs(fullCombo) do
            if not A.Farm.IsMobAlive(mob) then break end
            A.Attack(mob, {key}, 0.1)
            task.wait(0.05)
        end
    end
    if not A.Farm.IsMobAlive(mob) then
        A.Farm.KillCount = A.Farm.KillCount + 1
        A.Farm.FarmingStats.kills = A.Farm.FarmingStats.kills + 1
        local quest = A.Farm.CurrentQuest
        if quest then
            quest.currentKills = (quest.currentKills or 0) + 1
        end
        return true
    end
    return false
end

A.Farm.OneHitKill = function(mob)
    if not mob or not A.Farm.IsMobAlive(mob) then return false end
    if not isAlive() then return false end
    A.Farm.EquipBestWeapon()
    local mobPart = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
    if not mobPart then return false end
    local mobPos = posFromPart(mobPart)
    local hrp = A.HRP()
    if not hrp then return false end
    hrp.CFrame = A.CF(mobPos, mobPos)
    task.wait(0.05)
    A.SuperAttack(mob)
    task.wait(0.1)
    A.Attack(mob, {"1"}, 0.2)
    task.wait(0.1)
    if not A.Farm.IsMobAlive(mob) then
        A.Farm.KillCount = A.Farm.KillCount + 1
        A.Farm.FarmingStats.kills = A.Farm.FarmingStats.kills + 1
        local quest = A.Farm.CurrentQuest
        if quest then
            quest.currentKills = (quest.currentKills or 0) + 1
        end
        return true
    end
    return A.Farm.AttackMob(mob)
end

A.Farm.CheckHealth = function()
    if not isAlive() then return false end
    local hum = A.Hum()
    if not hum then return false end
    local healthPercent = hum.Health / hum.MaxHealth
    if healthPercent < HealthFoodPercent / 100 then
        A.Farm.UseFood()
    end
    if healthPercent < HealthRetreatPercent / 100 then
        return false
    end
    return true
end

A.Farm.UseFood = function()
    local char = getCharacter()
    if not char then return false end
    local backpack = A.LP:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local name = string.lower(item.Name)
                if string.find(name, "food") or string.find(name, "meal") or string.find(name, "fruit") or string.find(name, "meat") or string.find(name, "bread") or string.find(name, "soup") then
                    item.Parent = char
                    task.wait(0.1)
                    local hum = A.Hum()
                    if hum then
                        local humHealth = hum.Health
                        item.Parent = backpack
                        task.wait(0.1)
                        if hum.Health > humHealth then
                            A.Farm.FarmingStats.foodUsed = A.Farm.FarmingStats.foodUsed + 1
                            return true
                        end
                    end
                    item.Parent = backpack
                end
            end
        end
    end
    local charItems = {}
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            table.insert(charItems, item)
        end
    end
    for _, item in ipairs(charItems) do
        local name = string.lower(item.Name)
        if string.find(name, "food") or string.find(name, "meal") then
            A.Attack(nil, {"Z"}, 0.5)
            task.wait(0.3)
            A.Farm.FarmingStats.foodUsed = A.Farm.FarmingStats.foodUsed + 1
            return true
        end
    end
    return false
end

A.Farm.Retreat = function()
    A.Farm.FarmingStats.retreats = A.Farm.FarmingStats.retreats + 1
    local hrpPos = getHRPPos()
    if not hrpPos then return false end
    local retreatPos = A.V3(hrpPos.X, hrpPos.Y + 50, hrpPos.Z)
    A.TpTo(retreatPos, 5)
    task.wait(1)
    A.Farm.UseFood()
    local waitStart = getTime()
    while getTime() - waitStart < 5 do
        if not A.Farm.Active then return false end
        local hum = A.Hum()
        if hum and hum.Health / hum.MaxHealth > 0.7 then
            return true
        end
        task.wait(0.5)
    end
    return true
end

A.Farm.Heal = function()
    if not isAlive() then return false end
    local hum = A.Hum()
    if not hum then return false end
    if hum.Health >= hum.MaxHealth then return true end
    A.Farm.UseFood()
    task.wait(1)
    if A.Farm.IsLowHealth() then
        A.Farm.Retreat()
    end
    return not A.Farm.IsLowHealth()
end

A.Farm.IsLowHealth = function()
    local hum = A.Hum()
    if not hum then return true end
    return (hum.Health / hum.MaxHealth) < (HealthRetreatPercent / 100)
end

A.Farm.CheckStuck = function()
    if not isAlive() then
        A.Farm.StuckCount = A.Farm.StuckCount + 1
        return A.Farm.StuckCount >= StuckThreshold
    end
    local hrpPos = getHRPPos()
    if not hrpPos then return false end
    local now = getTime()
    if A.Farm.LastPosition and (now - A.Farm.LastPositionTime) > StuckCheckInterval then
        local dist = distanceBetween(A.Farm.LastPosition, hrpPos)
        if dist < 2 then
            A.Farm.StuckCount = A.Farm.StuckCount + 1
        else
            A.Farm.StuckCount = 0
        end
        A.Farm.LastPosition = hrpPos
        A.Farm.LastPositionTime = now
    elseif not A.Farm.LastPosition then
        A.Farm.LastPosition = hrpPos
        A.Farm.LastPositionTime = now
    end
    return A.Farm.StuckCount >= StuckThreshold
end

A.Farm.Unstuck = function()
    A.Farm.StuckCount = 0
    A.Farm.FarmingStats.stuck = A.Farm.FarmingStats.stuck + 1
    local hrpPos = getHRPPos()
    if hrpPos then
        local unstuckPositions = {
            A.V3(hrpPos.X + math.random(-20, 20), hrpPos.Y + 10, hrpPos.Z + math.random(-20, 20)),
            A.V3(hrpPos.X, hrpPos.Y + 30, hrpPos.Z),
            A.V3(hrpPos.X + math.random(-50, 50), hrpPos.Y, hrpPos.Z + math.random(-50, 50))
        }
        for _, pos in ipairs(unstuckPositions) do
            A.TpTo(pos, 5)
            task.wait(0.3)
            if isAlive() then
                local newHRP = getHRPPos()
                if newHRP and distanceBetween(newHRP, pos) < 20 then
                    A.Farm.LastPosition = nil
                    return true
                end
            end
        end
    end
    return false
end

A.Farm.ChangePosition = function()
    local hrpPos = getHRPPos()
    if not hrpPos then return false end
    local angles = {0, math.pi / 4, math.pi / 2, 3 * math.pi / 4, math.pi, 5 * math.pi / 4, 3 * math.pi / 2, 7 * math.pi / 4}
    local distances = {20, 40, 60}
    for _, dist in ipairs(distances) do
        for _, angle in ipairs(angles) do
            local testPos = A.V3(
                hrpPos.X + math.cos(angle) * dist,
                hrpPos.Y,
                hrpPos.Z + math.sin(angle) * dist
            )
            A.TpTo(testPos, 5)
            task.wait(0.3)
            if isAlive() then
                local newHRP = getHRPPos()
                if newHRP and distanceBetween(newHRP, testPos) < 15 then
                    A.Farm.LastPosition = nil
                    A.Farm.StuckCount = 0
                    return true
                end
            end
        end
    end
    return false
end

A.Farm.ResetFarm = function()
    A.Farm.Stop()
    task.wait(1)
    A.Farm.StuckCount = 0
    A.Farm.LastPosition = nil
    A.Farm.CurrentMob = nil
    A.Farm.MobBlacklist = {}
    A.Farm.WeaponCache = nil
    A.Farm.LastWeaponCheck = 0
    A.Farm.PathfindAttempts = 0
    A.Farm.ZoneIndex = 0
    A.Farm.CurrentQuest = nil
    A.Farm.KillCount = 0
    task.wait(1)
    A.Farm.Start()
end

A.Farm.AutoStats = function()
    local now = getTime()
    if (now - A.Farm.LastStatCheck) < StatCheckInterval then return end
    A.Farm.LastStatCheck = now
    local level = getLevel()
    local points = A.CommF("StatPoints")
    if not points or points == 0 then return end
    local buildType = A.C and A.C.Build or "melee"
    local splits
    if buildType == "melee" then
        splits = {Melee = 40, Defense = 40, Blox Fruit = 20}
    elseif buildType == "sword" then
        splits = {Sword = 40, Defense = 40, Gun = 20}
    elseif buildType == "fruit" then
        splits = {"Blox Fruit" = 40, Defense = 40, Melee = 20}
    elseif buildType == "gun" then
        splits = {Gun = 40, Defense = 40, Sword = 20}
    else
        splits = {Melee = 40, Defense = 40, "Blox Fruit" = 20}
    end
    for statName, percent in pairs(splits) do
        local pointsToAllocate = math.floor(points * percent / 100)
        if pointsToAllocate > 0 then
            for i = 1, pointsToAllocate do
                A.CommF("AddStat", statName)
                task.wait(0.05)
            end
        end
    end
end

A.Farm.LearnSkills = function()
    local level = getLevel()
    local sea = getSea()
    local g = A.G
    local replicatedStorage = g:FindFirstChild("ReplicatedStorage")
    if not replicatedStorage then return end
    local dataFolder = replicatedStorage:FindFirstChild("Data")
    if not dataFolder then return end
    local skillsFolder = dataFolder:FindFirstChild("Skills") or dataFolder:FindFirstChild("Abilities")
    if not skillsFolder then return end
    for _, skill in ipairs(skillsFolder:GetChildren()) do
        local reqLevel = skill:GetAttribute("Level") or skill:GetAttribute("RequiredLevel") or 0
        if level >= reqLevel then
            A.CommF("LearnSkill", skill.Name)
        end
    end
end

A.Farm.GetZones = function()
    local level = getLevel()
    local sea = getSea()
    local zones = {}
    local zoneData = {
        {name = "Starter Island", minLevel = 1, maxLevel = 20, sea = 1, pos = A.V3(0, 10, 0)},
        {name = "Jungle", minLevel = 15, maxLevel = 40, sea = 1, pos = A.V3(-1200, 10, -800)},
        {name = "Pirate Village", minLevel = 30, maxLevel = 60, sea = 1, pos = A.V3(-1100, 10, -1000)},
        {name = "Desert", minLevel = 50, maxLevel = 90, sea = 1, pos = A.V3(1100, 10, 1500)},
        {name = "Frozen Village", minLevel = 80, maxLevel = 130, sea = 1, pos = A.V3(1000, 10, -500)},
        {name = "Marine Fortress", minLevel = 120, maxLevel = 175, sea = 1, pos = A.V3(-2500, 10, -450)},
        {name = "Sky Island", minLevel = 175, maxLevel = 250, sea = 1, pos = A.V3(-500, 600, -2000)},
        {name = "Prison", minLevel = 250, maxLevel = 325, sea = 1, pos = A.V3(5000, 10, 3000)},
        {name = "Colosseum", minLevel = 300, maxLevel = 400, sea = 1, pos = A.V3(-1700, 10, 800)},
        {name = "Magma Village", minLevel = 375, maxLevel = 475, sea = 1, pos = A.V3(-5000, 10, -2000)},
        {name = "Underwater City", minLevel = 425, maxLevel = 525, sea = 1, pos = A.V3(600, 10, -8000)},
        {name = "Fountain of Truth", minLevel = 500, maxLevel = 600, sea = 1, pos = A.V3(-4000, 10, -3000)},
        {name = "Hot and Cold", minLevel = 575, maxLevel = 675, sea = 2, pos = A.V3(-700, 10, -5000)},
        {name = "Cursed Ship", minLevel = 650, maxLevel = 750, sea = 2, pos = A.V3(-1000, 10, -6000)},
        {name = "Usoapp's Island", minLevel = 700, maxLevel = 800, sea = 2, pos = A.V3(2000, 10, -2000)},
        {name = "Green Bit", minLevel = 775, maxLevel = 875, sea = 2, pos = A.V3(3000, 10, -1500)},
        {name = "Graveyard", minLevel = 850, maxLevel = 950, sea = 2, pos = A.V3(-2000, 10, -8000)},
        {name = "Dark Arena", minLevel = 925, maxLevel = 1025, sea = 2, pos = A.V3(4000, 10, -6000)},
        {name = "Floating Turtle", minLevel = 1000, maxLevel = 1150, sea = 3, pos = A.V3(-1200, 100, -7500)},
        {name = "Castle on the Sea", minLevel = 1100, maxLevel = 1250, sea = 3, pos = A.V3(-5000, 100, -3000)},
        {name = "Port Town", minLevel = 1200, maxLevel = 1350, sea = 3, pos = A.V3(-3000, 10, -5000)},
        {name = "Hydra Island", minLevel = 1300, maxLevel = 1450, sea = 3, pos = A.V3(5500, 100, -2000)},
        {name = "Great Tree", minLevel = 1400, maxLevel = 1550, sea = 3, pos = A.V3(2000, 100, -7000)},
        {name = "Tiki Outpost", minLevel = 1500, maxLevel = 1700, sea = 3, pos = A.V3(-4000, 10, -12000)}
    }
    for _, zone in ipairs(zoneData) do
        if level >= zone.minLevel and level <= zone.maxLevel and zone.sea == sea then
            table.insert(zones, zone)
        end
    end
    return zones
end

A.Farm.GetBestZone = function(level)
    level = level or getLevel()
    local zones = A.Farm.GetZones()
    local bestZone = nil
    local bestScore = -math.huge
    for _, zone in ipairs(zones) do
        local levelCenter = (zone.minLevel + zone.maxLevel) / 2
        local score = -math.abs(level - levelCenter)
        if zone.name == A.Farm.LastZone then
            score = score - 5
        end
        if score > bestScore then
            bestScore = score
            bestZone = zone
        end
    end
    return bestZone
end

A.Farm.SwitchZone = function()
    local newZone = A.Farm.GetBestZone()
    if not newZone then
        A.Notify("Auto Farm", "No suitable zone found", 3)
        return false
    end
    A.Farm.FarmingStats.zoneChanges = A.Farm.FarmingStats.zoneChanges + 1
    A.Farm.LastZone = newZone.name
    A.Notify("Auto Farm", "Switching to zone: " .. newZone.name, 3)
    A.TpTo(newZone.pos, 5)
    task.wait(1)
    return true
end

A.Farm.ZoneOptimized = function()
    if not A.Farm.HasQuest() then
        A.Farm.SwitchZone()
        task.wait(0.5)
        A.Farm.ChainQuests()
    end
end

A.Farm.UpdateStats = function()
    if A.Farm.StartTime == 0 then return end
    local elapsed = getTime() - A.Farm.StartTime
    A.Farm.FarmingStats.timeSpent = elapsed
end

A.Farm.GetStats = function()
    A.Farm.UpdateStats()
    local stats = A.Farm.FarmingStats
    local elapsed = stats.timeSpent
    local minutes = math.floor(elapsed / 60)
    local seconds = math.floor(elapsed % 60)
    return {
        kills = stats.kills,
        quests = stats.quests,
        xp = stats.xp,
        deaths = stats.deaths,
        rejoins = stats.rejoins,
        stuck = stats.stuck,
        errors = stats.errors,
        bossKills = stats.bossKills,
        chestsCollected = stats.chestsCollected,
        timeSpent = string.format("%dm %ds", minutes, seconds),
        timeSeconds = elapsed,
        questFailures = stats.questFailures,
        zoneChanges = stats.zoneChanges,
        weaponsSwapped = stats.weaponsSwapped,
        hakiActivations = stats.hakiActivations,
        foodUsed = stats.foodUsed,
        retreats = stats.retreats,
        totalQuestsCompleted = A.Farm.TotalQuestsCompleted,
        killCount = A.Farm.KillCount,
        xpGained = A.Farm.XpGained
    }
end

A.Farm.PrintStats = function()
    local stats = A.Farm.GetStats()
    local lines = {
        "===== AUTO FARM STATS =====",
        "Kills: " .. tostring(stats.kills),
        "Quests Completed: " .. tostring(stats.quests),
        "XP Gained: " .. tostring(stats.xp),
        "Boss Kills: " .. tostring(stats.bossKills),
        "Deaths: " .. tostring(stats.deaths),
        "Rejoins: " .. tostring(stats.rejoins),
        "Stuck Events: " .. tostring(stats.stuck),
        "Errors: " .. tostring(stats.errors),
        "Chests Collected: " .. tostring(stats.chestsCollected),
        "Time Spent: " .. stats.timeSpent,
        "Quest Failures: " .. tostring(stats.questFailures),
        "Zone Changes: " .. tostring(stats.zoneChanges),
        "Food Used: " .. tostring(stats.foodUsed),
        "Retreats: " .. tostring(stats.retreats),
        "Kill Rate: " .. string.format("%.1f", A.Farm.GetKillRate()) .. "/min",
        "XP Rate: " .. string.format("%.0f", A.Farm.GetXPRate()) .. "/min",
        "Efficiency: " .. string.format("%.1f%%", A.Farm.GetEfficiency()),
        "==========================="
    }
    for _, line in ipairs(lines) do
        print("[Apex Hub] " .. line)
    end
    A.Notify("Auto Farm Stats", "Kills: " .. stats.kills .. " | Quests: " .. stats.quests .. " | XP: " .. stats.xp, 5)
end

A.Farm.GetEfficiency = function()
    local stats = A.Farm.FarmingStats
    local elapsed = stats.timeSpent
    if elapsed <= 0 then return 0 end
    local minutes = elapsed / 60
    if minutes <= 0 then return 0 end
    local killScore = stats.kills * 10
    local questScore = stats.quests * 50
    local xpScore = stats.xp * 0.1
    local penalty = (stats.deaths * 20) + (stats.stuck * 10) + (stats.errors * 15) + (stats.questFailures * 25)
    local totalScore = killScore + questScore + xpScore - penalty
    local maxPossible = minutes * 100
    if maxPossible <= 0 then return 0 end
    local efficiency = (totalScore / maxPossible) * 100
    return math.clamp(efficiency, 0, 100)
end

A.Farm.GetXPRate = function()
    local elapsed = A.Farm.FarmingStats.timeSpent
    if elapsed <= 0 then return 0 end
    local minutes = elapsed / 60
    if minutes <= 0 then return 0 end
    return A.Farm.XpGained / minutes
end

A.Farm.GetKillRate = function()
    local elapsed = A.Farm.FarmingStats.timeSpent
    if elapsed <= 0 then return 0 end
    local minutes = elapsed / 60
    if minutes <= 0 then return 0 end
    return A.Farm.FarmingStats.kills / minutes
end

A.Farm.GetETA = function(targetLevel)
    targetLevel = targetLevel or (getLevel() + 1)
    local currentLevel = getLevel()
    local levelsNeeded = targetLevel - currentLevel
    if levelsNeeded <= 0 then return "Already at target level" end
    local xpRate = A.Farm.GetXPRate()
    if xpRate <= 0 then return "Calculating..." end
    local xpPerLevel = 500 + (currentLevel * 50)
    local totalXPNeeded = levelsNeeded * xpPerLevel
    local secondsNeeded = (totalXPNeeded / xpRate) * 60
    local hours = math.floor(secondsNeeded / 3600)
    local minutes = math.floor((secondsNeeded % 3600) / 60)
    return string.format("%dh %dm to level %d", hours, minutes, targetLevel)
end

A.Farm.AutoHaki = function()
    local now = getTime()
    if (now - A.Farm.LastHakiCheck) < HakiCheckInterval then return end
    A.Farm.LastHakiCheck = now
    local char = getCharacter()
    if not char then return end
    local bodyColors = char:FindFirstChildOfClass("BodyColors")
    if bodyColors then
        local rightArm = bodyColors:FindFirstChild("RightArmColor")
        if rightArm and rightArm:IsA("BrickColor") then
            if rightArm.BrickColor == BrickColor.new("Really black") then
                return
            end
        end
    end
    A.CommF("ToggleHaki")
    A.Farm.FarmingStats.hakiActivations = A.Farm.FarmingStats.hakiActivations + 1
end

A.Farm.AutoBuso = function()
    local now = getTime()
    if (now - A.Farm.LastHakiCheck) < HakiCheckInterval then return end
    local char = getCharacter()
    if not char then return end
    local hasBuso = char:FindFirstChild("BusoHaki") or char:FindFirstChild("Buso")
    if hasBuso then return end
    A.CommF("BusoHaki")
    A.Farm.FarmingStats.hakiActivations = A.Farm.FarmingStats.hakiActivations + 1
end

A.Farm.AutoKen = function()
    local now = getTime()
    if (now - A.Farm.LastHakiCheck) < HakiCheckInterval then return end
    local char = getCharacter()
    if not char then return end
    local hasKen = char:FindFirstChild("KenHaki") or char:FindFirstChild("Ken")
    if hasKen then return end
    A.CommF("KenHaki")
    A.Farm.FarmingStats.hakiActivations = A.Farm.FarmingStats.hakiActivations + 1
end

A.Farm.ChestFarm = function()
    local now = getTime()
    if (now - A.Farm.LastChestCheck) < 5 then return end
    A.Farm.LastChestCheck = now
    local hrpPos = getHRPPos()
    if not hrpPos then return end
    local g = A.G
    local ws = g:FindFirstChild("Workspace") or g.Workspace
    local chestFolder = ws:FindFirstChild("Chests") or ws:FindFirstChild("Loot") or ws:FindFirstChild("Items")
    if not chestFolder then return end
    for _, chest in ipairs(chestFolder:GetChildren()) do
        if not A.Farm.Active then return end
        local chestPart = chest:IsA("BasePart") and chest or chest:FindFirstChildOfClass("BasePart")
        if not chestPart then
            local prompt = chest:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                chestPart = prompt.Parent
            end
        end
        if chestPart then
            local chestPos = posFromPart(chestPart)
            if chestPos then
                local dist = distanceBetween(hrpPos, chestPos)
                if dist < ChestSearchRadius then
                    A.TpTo(chestPos, 5)
                    task.wait(0.3)
                    local prompt = chest:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        pcall(function()
                            fireproximityprompt(prompt, 0)
                        end)
                    end
                    A.Farm.FarmingStats.chestsCollected = A.Farm.FarmingStats.chestsCollected + 1
                    task.wait(0.2)
                end
            end
        end
    end
end

A.Farm.AutoSell = function()
    local now = getTime()
    if (now - A.Farm.LastAutoSellCheck) < AutoSellInterval then return end
    A.Farm.LastAutoSellCheck = now
    local backpack = A.LP:FindFirstChild("Backpack")
    if not backpack then return end
    local itemCount = #backpack:GetChildren()
    if itemCount > 30 then
        local npcFolder = getNPCFolder()
        if npcFolder then
            for _, npc in ipairs(npcFolder:GetChildren()) do
                if string.find(npc.Name, "Shop") or string.find(npc.Name, "Sell") or string.find(npc.Name, "Merchant") then
                    local npcPos = posFromPart(npc)
                    if npcPos then
                        A.TpTo(npcPos, 8)
                        task.wait(0.5)
                        local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            pcall(function()
                                fireproximityprompt(prompt, 0)
                            end)
                        end
                        A.CommF("SellAll")
                        task.wait(0.5)
                        break
                    end
                end
            end
        end
    end
end

A.Farm.AutoBuyFood = function()
    local hum = A.Hum()
    if not hum then return end
    if hum.Health / hum.MaxHealth > 0.5 then return end
    local backpack = A.LP:FindFirstChild("Backpack")
    local hasFood = false
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            local name = string.lower(item.Name)
            if string.find(name, "food") or string.find(name, "meal") then
                hasFood = true
                break
            end
        end
    end
    if hasFood then return end
    local npcFolder = getNPCFolder()
    if npcFolder then
        for _, npc in ipairs(npcFolder:GetChildren()) do
            if string.find(npc.Name, "Food") or string.find(npc.Name, "Chef") or string.find(npc.Name, "Merchant") then
                local npcPos = posFromPart(npc)
                if npcPos then
                    A.TpTo(npcPos, 8)
                    task.wait(0.5)
                    local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        pcall(function()
                            fireproximityprompt(prompt, 0)
                        end)
                    end
                    A.CommF("BuyFood")
                    A.CommF("BuyItem", "Food")
                    task.wait(0.5)
                    break
                end
            end
        end
    end
end

A.Farm.AFK = function()
    A.Farm.Active = true
    A.Farm.StartTime = getTime()
    A.Notify("Auto Farm", "AFK Mode Active - Farming Continuously", 3)
    while A.Farm.Active do
        if not isAlive() then
            task.wait(2)
            A.CommF("Respawn")
            task.wait(3)
        end
        A.Farm.CheckHealth()
        A.Farm.AutoHaki()
        A.Farm.ChestFarm()
        A.Farm.AutoSell()
        local questMob = A.Farm.GetQuestTarget()
        if questMob then
            A.Farm.AttackMob(questMob)
        else
            A.Farm.RandomFarm()
        end
        task.wait(0.3)
    end
end

A.Farm.MainLoop = function()
    if not A.Farm.Active then return end
    A.Farm.StartTime = A.Farm.StartTime or getTime()
    if not isAlive() then
        A.Farm.FarmingStats.deaths = A.Farm.FarmingStats.deaths + 1
        A.Notify("Auto Farm", "Character died, respawning...", 3)
        task.wait(2)
        A.CommF("Respawn")
        task.wait(3)
        return
    end
    A.Farm.CheckHealth()
    if A.Farm.IsLowHealth() then
        A.Farm.Retreat()
        return
    end
    if A.Farm.CheckStuck() then
        A.Notify("Auto Farm", "Stuck detected, recovering...", 3)
        if not A.Farm.Unstuck() then
            if not A.Farm.ChangePosition() then
                A.Farm.ResetFarm()
                return
            end
        end
        return
    end
    A.Farm.AutoStats()
    A.Farm.LearnSkills()
    A.Farm.AutoHaki()
    A.Farm.EquipBestWeapon()
    A.Farm.ChestFarm()
    A.Farm.AutoSell()
    A.Farm.AutoBuyFood()
    if A.Farm.HasQuest() then
        if A.Farm.IsQuestComplete() then
            A.Farm.CompleteQuest()
            task.wait(0.3)
            A.Farm.ChainQuests()
            return
        end
        local questMob = A.Farm.GetQuestTarget()
        if questMob then
            A.Farm.CurrentMob = questMob
            local killResult = A.Farm.AttackMob(questMob)
            if killResult then
                task.wait(0.1)
                if A.Farm.IsQuestComplete() then
                    A.Farm.CompleteQuest()
                    task.wait(0.3)
                    A.Farm.ChainQuests()
                end
            else
                if not A.Farm.IsMobAlive(questMob) then
                    A.Farm.BlacklistMob(questMob)
                end
                local hrpPos = getHRPPos()
                if hrpPos then
                    A.Farm.CircleFarm(hrpPos, 30)
                end
            end
        else
            local hrpPos = getHRPPos()
            if hrpPos then
                A.Farm.RandomFarm()
            end
            task.wait(0.5)
            local retryMob = A.Farm.GetQuestTarget()
            if not retryMob then
                local quest = A.Farm.CurrentQuest
                if quest then
                    local elapsed = getTime() - (quest.startTime or getTime())
                    if elapsed > 60 then
                        A.Farm.AbandonQuest()
                        task.wait(0.3)
                    end
                end
            end
        end
    else
        local questData = A.Farm.OptimizeQuestSelection()
        if questData then
            A.Farm.AcceptQuest(questData)
        else
            A.Farm.ZoneOptimized()
            task.wait(1)
        end
    end
    A.Farm.UpdateStats()
end

A.Farm.Start = function()
    if A.Farm.Active then return end
    A.Farm.Active = true
    A.Farm.Paused = false
    A.Farm.StartTime = getTime()
    A.Farm.KillCount = 0
    A.Farm.XpGained = 0
    A.Farm.StuckCount = 0
    A.Farm.LastPosition = nil
    A.Farm.CurrentMob = nil
    A.Farm.MobBlacklist = {}
    A.Farm.WeaponCache = nil
    A.Farm.QuestRetries = 0
    A.Notify("Auto Farm", "Auto Farm Started", 3)
    A.Farm.LoopConnection = game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
            if not A.Farm.Active then
                if A.Farm.LoopConnection then
                    A.Farm.LoopConnection:Disconnect()
                    A.Farm.LoopConnection = nil
                end
                return
            end
            if A.Farm.Paused then return end
            A.Farm.MainLoop()
        end)
    end)
end

A.Farm.Stop = function()
    A.Farm.Active = false
    A.Farm.Paused = false
    if A.Farm.LoopConnection then
        A.Farm.LoopConnection:Disconnect()
        A.Farm.LoopConnection = nil
    end
    A.Farm.CurrentMob = nil
    A.Farm.PrintStats()
    A.Notify("Auto Farm", "Auto Farm Stopped", 3)
end

A.Farm.Pause = function()
    if not A.Farm.Active then return end
    A.Farm.Paused = true
    A.Notify("Auto Farm", "Auto Farm Paused", 2)
end

A.Farm.Resume = function()
    if not A.Farm.Active then return end
    A.Farm.Paused = false
    A.Notify("Auto Farm", "Auto Farm Resumed", 2)
end

A.Farm.Restart = function()
    A.Farm.Stop()
    task.wait(1)
    A.Farm.StuckCount = 0
    A.Farm.LastPosition = nil
    A.Farm.CurrentMob = nil
    A.Farm.CurrentQuest = nil
    A.Farm.KillCount = 0
    A.Farm.XpGained = 0
    A.Farm.MobBlacklist = {}
    A.Farm.WeaponCache = nil
    A.Farm.ZoneIndex = 0
    A.Farm.QuestRetries = 0
    A.Farm.FarmingStats = {
        kills = 0,
        quests = 0,
        xp = 0,
        deaths = 0,
        rejoins = 0,
        stuck = 0,
        errors = 0,
        bossKills = 0,
        chestsCollected = 0,
        timeSpent = 0,
        questFailures = 0,
        zoneChanges = 0,
        weaponsSwapped = 0,
        hakiActivations = 0,
        foodUsed = 0,
        retreats = 0
    }
    task.wait(1)
    A.Farm.Start()
end

function A.Farm.AutoSoru(v)
    A.F.AutoSoru = v
end

function A.Farm.AutoGeppo(v)
    A.F.AutoGeppo = v
end

function A.Farm.AutoQuest(v)
    A.F.AutoQuest = v
end

function A.Farm.TrainHaki()
end

A.Register("autofarm", A.Farm)
