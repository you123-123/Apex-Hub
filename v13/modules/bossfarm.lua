--[[
    Apex Hub v13.0 - Boss Farm Module
    Comprehensive boss farming with rotation, hop, safe mode, and logging
]]

local A = _G.Apex
if not A then return end

A.BossFarm = {}
A.BossFarm.Active = false
A.BossFarm.CurrentBoss = nil
A.BossFarm.BossKills = 0
A.BossFarm.BossTimers = {}
A.BossFarm.BossDropLog = {}
A.BossFarm.RotationIndex = 0
A.BossFarm.LastHop = 0
A.BossFarm.HopCooldown = 30
A.BossFarm.FightRetries = 0
A.BossFarm.MaxRetries = 3
A.BossFarm.SafeMode = false
A.BossFarm.AutoHop = false
A.BossFarm.BossQueue = {}
A.BossFarm.KillLog = {}
A.BossFarm.TotalFights = 0
A.BossFarm.SuccessfulFights = 0
A.BossFarm.FailedFights = 0
A.BossFarm.BossSpawnData = {}
A.BossFarm.LastCheckTime = 0
A.BossFarm.CheckInterval = 2
A.BossFarm.SessionStartTime = tick()
A.BossFarm.BossLevels = {
    ["The Gorilla King"] = 20,
    ["Bobby"] = 5,
    ["The Vice Admiral"] = 60,
    ["Warden"] = 200,
    ["Chief Warden"] = 220,
    ["Swan"] = 250,
    ["Stone"] = 250,
    ["Island Empress"] = 375,
    ["Henry"] = 400,
    ["Captain Elephant"] = 425,
    ["Beautiful Pirate"] = 450,
    ["Longma"] = 350,
    ["Tikling"] = 400,
    ["Dough King"] = 300,
    ["Rip_Indra"] = 250,
    ["Darkbeard"] = 150,
    ["Order"] = 100,
    ["Mammoth"] = 500,
    ["T-Rex"] = 500,
    ["Leviathan"] = 2500,
    ["Kitsune"] = 1500,
    ["Phoenix"] = 1200,
}

A.BossFarm.BossLocations = {
    ["The Gorilla King"] = A.V3(4400, 180, -1680),
    ["Bobby"] = A.V3(4993, -250, 2850),
    ["The Vice Admiral"] = A.V3(-4845, 215, -2745),
    ["Warden"] = A.V3(2870, 280, -640),
    ["Chief Warden"] = A.V3(2870, 280, -640),
    ["Swan"] = A.V3(2640, 240, 2930),
    ["Stone"] = A.V3(2675, 20, 860),
    ["Island Empress"] = A.V3(5225, 600, -180),
    ["Henry"] = A.V3(5225, 600, -180),
    ["Captain Elephant"] = A.V3(5225, 600, -180),
    ["Beautiful Pirate"] = A.V3(5320, 600, -280),
    ["Longma"] = A.V3(-10335, 410, -3750),
    ["Tikling"] = A.V3(-3500, 50, 3400),
    ["Dough King"] = A.V3(-2180, 20, -6200),
    ["Rip_Indra"] = A.V3(-5500, 310, -2360),
    ["Darkbeard"] = A.V3(3400, 100, -4200),
    ["Order"] = A.V3(5700, 40, -300),
    ["Mammoth"] = A.V3(-13500, 700, 2350),
    ["T-Rex"] = A.V3(-13500, 700, 2350),
    ["Leviathan"] = A.V3(-4500, 30, -7500),
    ["Kitsune"] = A.V3(4800, 60, -3800),
    ["Phoenix"] = A.V3(5700, 40, -300),
}

A.BossFarm.BossRewards = {
    ["The Gorilla King"] = {"Blast Gem", "Spikey Trident"},
    ["Bobby"] = {"Saber"},
    ["The Vice Admiral"] = {"Colosseum Sword"},
    ["Warden"] = {"Warden's Sword", "Warden's Key"},
    ["Chief Warden"] = {"Warrior Helmet"},
    ["Swan"] = {"Dark Fragment"},
    ["Stone"] = {"Rock Diamond"},
    ["Island Empress"] = {"Leviathan Crown"},
    ["Henry"] = {"Leviathan Crown"},
    ["Captain Elephant"] = {"Elephant TOKEN"},
    ["Beautiful Pirate"] = {"Dual记者采访", "Beautiful Pirate Glasses"},
    ["Longma"] = {"Longma Sword"},
    ["Tikling"] = {"Foolish Samurai"},
    ["Dough King"] = {"Dough"},
    ["Rip_Indra"] = {"Dark Fragment", "Valkyrie Helm"},
    ["Darkbeard"] = {"Dark Fragment"},
    ["Order"] = {"Order"},
    ["Mammoth"] = {"Mammoth Fruit"},
    ["T-Rex"] = {"T-Rex Fruit"},
    ["Leviathan"] = {"Leviathan Shield", "Leviathan Heart"},
    ["Kitsune"] = {"Kitsune Gem"},
    ["Phoenix"] = {"Phoenix Fruit"},
}

A.BossFarm.BossDropLog = {}

function A.BossFarm.MainLoop()
    while A.BossFarm.Active do
        if not A.Alive() then
            A.Notify("Boss Farm", "Waiting for respawn...", 3)
            task.wait(3)
        else
            local boss = A.BossFarm.GetClosestBoss()
            if boss then
                A.BossFarm.CurrentBoss = boss
                A.BossFarm.KillBoss(boss)
                A.BossFarm.CheckBossSpawn()
            else
                A.BossFarm.CheckBossSpawn()
                if A.BossFarm.AutoHop and A.BossFarm.GetAliveBosses() == 0 then
                    A.BossFarm.BossHop()
                end
                task.wait(A.BossFarm.CheckInterval)
            end
        end
        task.wait(1)
    end
end

function A.BossFarm.FindBoss(bossName)
    if not A.G then return nil end
    local npcFolder = A.G:FindFirstChild("NPCs") or A.G:FindFirstChild("Enemys") or A.G:FindFirstChild("Enemies")
    if not npcFolder then
        for _, child in ipairs(A.G:GetChildren()) do
            if child:IsA("Folder") or child:IsA("Model") then
                local found = child:FindFirstChild(bossName)
                if found and found:FindFirstChild("HumanoidRootPart") then
                    return found
                end
            end
        end
        return nil
    end
    local npc = npcFolder:FindFirstChild(bossName)
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        return npc
    end
    for _, child in ipairs(npcFolder:GetChildren()) do
        if child:IsA("Model") and child.Name == bossName then
            if child:FindFirstChild("HumanoidRootPart") then
                return child
            end
        end
    end
    return nil
end

function A.BossFarm.GetClosestBoss()
    local alive = A.BossFarm.GetAliveBosses()
    local closest = nil
    local closestDist = math.huge
    local char = A.Char()
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    local hrp = char.HumanoidRootPart.Position
    for _, boss in ipairs(alive) do
        local bhrp = boss:FindFirstChild("HumanoidRootPart")
        if bhrp then
            local dist = (bhrp.Position - hrp).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = boss
            end
        end
    end
    return closest
end

function A.BossFarm.GetAliveBosses()
    local alive = {}
    for bossName, _ in pairs(A.BossFarm.BossLocations) do
        local boss = A.BossFarm.FindBoss(bossName)
        if boss then
            local hum = boss:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                table.insert(alive, boss)
            end
        end
    end
    return alive
end

function A.BossFarm.IsBossSpawned(bossName)
    local boss = A.BossFarm.FindBoss(bossName)
    if boss then
        local hum = boss:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            return true
        end
    end
    return false
end

function A.BossFarm.NavigateToBoss(boss)
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local hrp = A.HRP()
    if not hrp then return false end
    local pos = boss.HumanoidRootPart.Position
    local dist = (pos - hrp.Position).Magnitude
    if dist > 300 then
        hrp.CFrame = A.CF(pos + A.V3(0, 50, 0))
        task.wait(0.5)
    elseif dist > 50 then
        A.TweenTo(pos, 300)
        task.wait(0.3)
    else
        A.TpTo(pos, 30)
    end
    return true
end

function A.BossFarm.FightBoss(boss)
    if not boss or not boss:FindFirstChild("HumanoidRootPart") then return false end
    local hum = boss:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    A.BossFarm.NavigateToBoss(boss)
    local fightStart = tick()
    local timeout = 120
    while A.BossFarm.Active and hum.Health > 0 do
        if not A.Alive() then
            return false
        end
        if tick() - fightStart > timeout then
            A.Notify("Boss Farm", "Fight timeout for " .. boss.Name, 3)
            return false
        end
        local bhrp = boss:FindFirstChild("HumanoidRootPart")
        if bhrp then
            local myHRP = A.HRP()
            if myHRP then
                local dist = (bhrp.Position - myHRP.Position).Magnitude
                if dist > 30 then
                    A.BossFarm.NavigateToBoss(boss)
                end
            end
            if A.BossFarm.SafeMode then
                local myHum = A.Hum()
                if myHum and myHum.Health < myHum.MaxHealth * 0.3 then
                    A.Notify("Boss Farm", "Low HP, retreating...", 2)
                    task.wait(3)
                    return false
                end
                A.Attack(boss, {"Z", "X", "C", "V"}, 0.2)
            else
                A.SuperAttack(boss)
            end
        end
        task.wait(0.1)
    end
    return true
end

function A.BossFarm.KillBoss(boss)
    if not boss then return end
    A.BossFarm.TotalFights = A.BossFarm.TotalFights + 1
    A.Notify("Boss Farm", "Fighting: " .. boss.Name, 3)
    local success = A.BossFarm.FightBoss(boss)
    if success then
        A.BossFarm.BossKills = A.BossFarm.BossKills + 1
        A.BossFarm.SuccessfulFights = A.BossFarm.SuccessfulFights + 1
        A.BossFarm.BossTimers[boss.Name] = tick()
        A.BossFarm.LogBossKill(boss, {})
        A.Notify("Boss Farm", "Defeated: " .. boss.Name .. " (Total: " .. A.BossFarm.BossKills .. ")", 4)
    else
        A.BossFarm.FailedFights = A.BossFarm.FailedFights + 1
        A.BossFarm.FightRetries = A.BossFarm.FightRetries + 1
        if A.BossFarm.FightRetries < A.BossFarm.MaxRetries then
            A.Notify("Boss Farm", "Retrying " .. boss.Name .. " (" .. A.BossFarm.FightRetries .. "/" .. A.BossFarm.MaxRetries .. ")", 3)
            task.wait(2)
            A.BossFarm.KillBoss(boss)
        else
            A.Notify("Boss Farm", "Failed to kill " .. boss.Name .. " after retries", 4)
            A.BossFarm.FightRetries = 0
        end
    end
end

function A.BossFarm.CheckBossSpawn()
    A.BossFarm.LastCheckTime = tick()
    for bossName, _ in pairs(A.BossFarm.BossLocations) do
        if not A.BossFarm.BossSpawnData[bossName] then
            A.BossFarm.BossSpawnData[bossName] = {spawned = false, lastSeen = 0, lastKilled = 0}
        end
        local isSpawned = A.BossFarm.IsBossSpawned(bossName)
        local prev = A.BossFarm.BossSpawnData[bossName].spawned
        if isSpawned and not prev then
            A.BossFarm.BossSpawnData[bossName].lastSeen = tick()
            A.Notify("Boss Spawn", bossName .. " has appeared!", 5)
        end
        A.BossFarm.BossSpawnData[bossName].spawned = isSpawned
    end
end

function A.BossFarm.GetBossTimer(bossName)
    local lastKilled = A.BossFarm.BossTimers[bossName]
    if not lastKilled then
        return 0
    end
    local elapsed = tick() - lastKilled
    local respawnTimes = {
        ["The Gorilla King"] = 300,
        ["Bobby"] = 300,
        ["The Vice Admiral"] = 300,
        ["Warden"] = 600,
        ["Chief Warden"] = 600,
        ["Swan"] = 900,
        ["Stone"] = 600,
        ["Island Empress"] = 600,
        ["Henry"] = 600,
        ["Captain Elephant"] = 600,
        ["Beautiful Pirate"] = 3600,
        ["Longma"] = 300,
        ["Tikling"] = 300,
        ["Dough King"] = 1800,
        ["Rip_Indra"] = 1800,
        ["Darkbeard"] = 1800,
        ["Order"] = 600,
        ["Mammoth"] = 3600,
        ["T-Rex"] = 3600,
        ["Leviathan"] = 7200,
        ["Kitsune"] = 3600,
        ["Phoenix"] = 3600,
    }
    local respawnTime = respawnTimes[bossName] or 600
    local remaining = respawnTime - elapsed
    if remaining <= 0 then
        return 0
    end
    return remaining
end

function A.BossFarm.WaitBoss(bossName, timeout)
    timeout = timeout or 300
    local start = tick()
    A.Notify("Boss Farm", "Waiting for " .. bossName .. "...", 3)
    while tick() - start < timeout do
        if not A.BossFarm.Active then return false end
        if A.BossFarm.IsBossSpawned(bossName) then
            return true
        end
        local timer = A.BossFarm.GetBossTimer(bossName)
        if timer > 0 and timer % 30 < 2 then
            A.Notify("Boss Farm", bossName .. " in " .. math.floor(timer) .. "s", 2)
        end
        task.wait(2)
    end
    return false
end

function A.BossFarm.BossRotation()
    A.BossFarm.RotationIndex = A.BossFarm.RotationIndex + 1
    local sorted = {}
    for name, _ in pairs(A.BossFarm.BossLocations) do
        table.insert(sorted, name)
    end
    table.sort(sorted, function(a, b)
        return (A.BossFarm.BossLevels[a] or 0) < (A.BossFarm.BossLevels[b] or 0)
    end)
    if #sorted == 0 then return nil end
    if A.BossFarm.RotationIndex > #sorted then
        A.BossFarm.RotationIndex = 1
    end
    return sorted[A.BossFarm.RotationIndex]
end

function A.BossFarm.LogBossKill(boss, drops)
    local logEntry = {
        boss = boss.Name,
        time = os.time(),
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        drops = drops or {},
    }
    table.insert(A.BossFarm.KillLog, logEntry)
    if not A.BossFarm.BossDropLog[boss.Name] then
        A.BossFarm.BossDropLog[boss.Name] = {kills = 0, drops = {}}
    end
    A.BossFarm.BossDropLog[boss.Name].kills = A.BossFarm.BossDropLog[boss.Name].kills + 1
    for _, drop in ipairs(drops) do
        if not A.BossFarm.BossDropLog[boss.Name].drops[drop] then
            A.BossFarm.BossDropLog[boss.Name].drops[drop] = 0
        end
        A.BossFarm.BossDropLog[boss.Name].drops[drop] = A.BossFarm.BossDropLog[boss.Name].drops[drop] + 1
    end
end

function A.BossFarm.GetBossStats()
    local uptime = tick() - A.BossFarm.SessionStartTime
    local hours = math.floor(uptime / 3600)
    local mins = math.floor((uptime % 3600) / 60)
    local secs = math.floor(uptime % 60)
    return {
        active = A.BossFarm.Active,
        totalKills = A.BossFarm.BossKills,
        totalFights = A.BossFarm.TotalFights,
        successfulFights = A.BossFarm.SuccessfulFights,
        failedFights = A.BossFarm.FailedFights,
        killRate = A.BossFarm.TotalFights > 0
            and math.floor(A.BossFarm.SuccessfulFights / A.BossFarm.TotalFights * 100) or 0,
        uptime = string.format("%dh %dm %ds", hours, mins, secs),
        killsPerHour = uptime > 0 and math.floor(A.BossFarm.BossKills / (uptime / 3600)) or 0,
        currentBoss = A.BossFarm.CurrentBoss and A.BossFarm.CurrentBoss.Name or "None",
        dropLog = A.BossFarm.BossDropLog,
        safeMode = A.BossFarm.SafeMode,
        autoHop = A.BossFarm.AutoHop,
    }
end

function A.BossFarm.GetOptimalBoss(level)
    level = level or A.Lv()
    local candidates = {}
    for name, bossLevel in pairs(A.BossFarm.BossLevels) do
        local diff = math.abs(bossLevel - level)
        table.insert(candidates, {name = name, level = bossLevel, diff = diff})
    end
    table.sort(candidates, function(a, b) return a.diff < b.diff end)
    if #candidates > 0 then
        return candidates[1].name
    end
    return nil
end

function A.BossFarm.FarmAllBosses()
    while A.BossFarm.Active do
        local bossName = A.BossFarm.BossRotation()
        if not bossName then
            task.wait(5)
        else
            local available = A.BossFarm.WaitBoss(bossName, 60)
            if available then
                local boss = A.BossFarm.FindBoss(bossName)
                if boss then
                    A.BossFarm.KillBoss(boss)
                end
            else
                A.Notify("Boss Farm", bossName .. " not found, trying next...", 2)
            end
        end
        task.wait(1)
    end
end

function A.BossFarm.BossHop()
    if tick() - A.BossFarm.LastHop < A.BossFarm.HopCooldown then
        A.Notify("Boss Farm", "Hop cooldown active...", 2)
        return false
    end
    A.BossFarm.LastHop = tick()
    A.Notify("Boss Farm", "Server hopping for bosses...", 4)
    local success, err = pcall(function()
        local servers = game:GetService("HttpService"):JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullServers=true")
        )
        if servers and servers.data then
            local serverId = nil
            for _, server in ipairs(servers.data) do
                if server.id ~= game.JobId then
                    serverId = server.id
                    break
                end
            end
            if serverId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, serverId, A.LP)
                return true
            end
        end
    end)
    return success
end

function A.BossFarm.SafeFight(boss)
    if not boss then return false end
    local prevSafe = A.BossFarm.SafeMode
    A.BossFarm.SafeMode = true
    local result = A.BossFarm.FightBoss(boss)
    A.BossFarm.SafeMode = prevSafe
    return result
end

function A.BossFarm.RetryBoss(boss)
    if not boss then return false end
    A.BossFarm.FightRetries = 0
    while A.BossFarm.FightRetries < A.BossFarm.MaxRetries do
        if not A.BossFarm.Active then return false end
        A.BossFarm.FightRetries = A.BossFarm.FightRetries + 1
        A.Notify("Boss Farm", "Retry attempt " .. A.BossFarm.FightRetries .. "/" .. A.BossFarm.MaxRetries, 2)
        task.wait(2)
        if not A.Alive() then
            task.wait(5)
        end
        local success = A.BossFarm.FightBoss(boss)
        if success then
            return true
        end
    end
    A.Notify("Boss Farm", "All retries exhausted for " .. boss.Name, 4)
    return false
end

function A.BossFarm.GetBossHealth(boss)
    if not boss then return 0, 0, 0 end
    local hum = boss:FindFirstChildOfClass("Humanoid")
    if not hum then return 0, 0, 0 end
    local hp = hum.Health
    local maxHp = hum.MaxHealth
    local pct = maxHp > 0 and (hp / maxHp * 100) or 0
    return hp, maxHp, pct
end

function A.BossFarm.IsBossDefeated(boss)
    if not boss then return true end
    local hum = boss:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return true end
    return false
end

function A.BossFarm.GetRareDrops(bossName)
    local drops = A.BossFarm.BossRewards[bossName] or {}
    local rare = {}
    local legendaryDrops = {"Dough", "Mammoth Fruit", "T-Rex Fruit", "Phoenix Fruit"}
    for _, drop in ipairs(drops) do
        for _, legendary in ipairs(legendaryDrops) do
            if drop == legendary then
                table.insert(rare, {name = drop, rarity = "Legendary"})
            end
        end
    end
    local log = A.BossFarm.BossDropLog[bossName]
    if log then
        for dropName, count in pairs(log.drops) do
            table.insert(rare, {name = dropName, count = count})
        end
    end
    return rare
end

function A.BossFarm.GetBossPriority(boss)
    if not boss then return 0 end
    local level = A.BossFarm.BossLevels[boss.Name] or 0
    local playerLevel = A.Lv() or 1
    local levelScore = 0
    if level >= playerLevel - 50 and level <= playerLevel + 50 then
        levelScore = 100
    elseif level < playerLevel then
        levelScore = math.max(0, 100 - (playerLevel - level) * 2)
    else
        levelScore = math.max(0, 100 - (level - playerLevel))
    end
    local killCount = A.BossFarm.BossDropLog[boss.Name] and A.BossFarm.BossDropLog[boss.Name].kills or 0
    local rarityBonus = 0
    local drops = A.BossFarm.BossRewards[boss.Name] or {}
    local legendaryDrops = {"Dough", "Mammoth Fruit", "T-Rex Fruit", "Phoenix Fruit"}
    for _, drop in ipairs(drops) do
        for _, legendary in ipairs(legendaryDrops) do
            if drop == legendary then
                rarityBonus = rarityBonus + 50
            end
        end
    end
    local priority = levelScore + rarityBonus - killCount
    return priority
end

function A.BossFarm.Start(bossName)
    if A.BossFarm.Active then
        A.Notify("Boss Farm", "Already running!", 2)
        return
    end
    -- Distinctive: Boss 3D Hologram + Trail (not in any script)
    pcall(function() if A.Distinctive then A.Distinctive.ShowModuleHologram("BossFarm", "Hunting: "..(bossName or "Auto"), "👑") end end)
    A.BossFarm.Active = true
    A.BossFarm.SessionStartTime = tick()
    A.BossFarm.BossKills = 0
    A.BossFarm.TotalFights = 0
    A.BossFarm.SuccessfulFights = 0
    A.BossFarm.FailedFights = 0
    A.Notify("Boss Farm", "Started!", 3)
    if bossName then
        A.BossFarm.BossQueue = {bossName}
    else
        A.BossFarm.BossQueue = {}
    end
    if #A.BossFarm.BossQueue > 0 then
        task.spawn(function()
            while A.BossFarm.Active do
                for _, bName in ipairs(A.BossFarm.BossQueue) do
                    if not A.BossFarm.Active then break end
                    local boss = A.BossFarm.FindBoss(bName)
                    if boss then
                        A.BossFarm.KillBoss(boss)
                    else
                        A.BossFarm.WaitBoss(bName, 60)
                    end
                    task.wait(1)
                end
                task.wait(1)
            end
        end)
    else
        task.spawn(A.BossFarm.FarmAllBosses)
    end
end

function A.BossFarm.Stop()
    A.BossFarm.Active = false
    A.BossFarm.CurrentBoss = nil
    A.Notify("Boss Farm", "Stopped. Kills: " .. A.BossFarm.BossKills, 3)
end

function A.BossFarm.ShowTimers()
end

A.Register("bossfarm", A.BossFarm)
