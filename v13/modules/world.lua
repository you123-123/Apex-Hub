local A = _G.Apex
if not A then return end

A.World = {}
A.World.Active = false
A.World.EventsCompleted = 0
A.World.PrehistoricKills = 0
A.World.FrozenKills = 0
A.World.MirrorKills = 0
A.World.Stats = {
    EventsCompleted = 0,
    PrehistoricCompleted = 0,
    FrozenCompleted = 0,
    MirrorCompleted = 0,
    TreeDestroyed = 0,
    RevengeBossKills = 0,
    RainbowHakiProgress = 0,
    EnhancementProgress = 0,
    SkillChainProgress = 0,
    TotalDrops = 0,
    SessionStart = tick()
}

A.World.EventData = {
    PrehistoricIsland = {
        Name = "Prehistoric Island",
        SpawnChance = 0.15,
        Duration = 600,
        Level = 2000,
        Rewards = {"Dragon Scale", "Fossil Core", "Primal Essence"},
        Position = CFrame.new(200, 20, -3000),
        Enemies = {
            {Name = "T-Rex", Level = 2200, Health = 50000, Damage = 800, Position = CFrame.new(250, 20, -3050)},
            {Name = "Raptor", Level = 2000, Health = 30000, Damage = 500, Position = CFrame.new(180, 20, -2980)},
            {Name = "Pterodactyl", Level = 2100, Health = 35000, Damage = 600, Position = CFrame.new(220, 50, -3020)},
            {Name = "Brontosaurus", Level = 2300, Health = 60000, Damage = 900, Position = CFrame.new(300, 20, -3100)},
            {Name = "Mammoth", Level = 2400, Health = 70000, Damage = 1000, Position = CFrame.new(150, 20, -2900)}
        },
        Boss = {Name = "Ancient Predator", Level = 2500, Health = 200000, Damage = 2000, Position = CFrame.new(200, 30, -3000)}
    },
    FrozenDimension = {
        Name = "Frozen Dimension",
        SpawnChance = 0.12,
        Duration = 500,
        Level = 2200,
        Rewards = {"Frost Crystal", "Ice Core", "Permafrost Shard"},
        Position = CFrame.new(-4000, 20, -1500),
        Enemies = {
            {Name = "Frost Warrior", Level = 2300, Health = 45000, Damage = 700, Position = CFrame.new(-3950, 20, -1480)},
            {Name = "Ice Golem", Level = 2400, Health = 55000, Damage = 850, Position = CFrame.new(-4050, 20, -1520)},
            {Name = "Blizzard Spirit", Level = 2500, Health = 60000, Damage = 950, Position = CFrame.new(-3900, 30, -1450)},
            {Name = "Frozen Knight", Level = 2600, Health = 65000, Damage = 1000, Position = CFrame.new(-4100, 20, -1550)},
            {Name = "Cryo Beast", Level = 2700, Health = 75000, Damage = 1100, Position = CFrame.new(-3850, 20, -1400)}
        },
        Boss = {Name = "Frozen Sovereign", Level = 2800, Health = 250000, Damage = 2500, Position = CFrame.new(-4000, 30, -1500)}
    },
    MirrorDimension = {
        Name = "Mirror Dimension",
        SpawnChance = 0.10,
        Duration = 450,
        Level = 2400,
        Rewards = {"Mirror Shard", "Void Crystal", "Reality Fragment"},
        Position = CFrame.new(5000, 20, 2000),
        Enemies = {
            {Name = "Mirror Clone", Level = 2500, Health = 50000, Damage = 800, Position = CFrame.new(5050, 20, 2020)},
            {Name = "Void Walker", Level = 2600, Health = 55000, Damage = 900, Position = CFrame.new(4950, 20, 1980)},
            {Name = "Reality Bender", Level = 2700, Health = 60000, Damage = 1000, Position = CFrame.new(5100, 30, 2050)},
            {Name = "Dimensional Phantom", Level = 2800, Health = 70000, Damage = 1100, Position = CFrame.new(4900, 20, 1950)},
            {Name = "Shadow Doppelganger", Level = 2900, Health = 80000, Damage = 1200, Position = CFrame.new(5200, 20, 2100)}
        },
        Boss = {Name = "Mirror Master", Level = 3000, Health = 300000, Damage = 3000, Position = CFrame.new(5000, 30, 2000)}
    },
    TreeDestroyer = {
        Name = "Tree Destroyer",
        SpawnChance = 0.20,
        Duration = 300,
        Level = 1800,
        Rewards = {"Ancient Bark", "Living Wood", "World Tree Sap"},
        Position = CFrame.new(-1200, 100, -1000),
        TreeHealth = 500000,
        Enemies = {
            {Name = "Tree Guardian", Level = 1900, Health = 40000, Damage = 600, Position = CFrame.new(-1180, 20, -980)},
            {Name = "Forest Spirit", Level = 2000, Health = 45000, Damage = 700, Position = CFrame.new(-1220, 20, -1020)},
            {Name = "Bark Golem", Level = 2100, Health = 50000, Damage = 800, Position = CFrame.new(-1150, 20, -950)},
            {Name = "Root Crawler", Level = 2200, Health = 55000, Damage = 850, Position = CFrame.new(-1250, 20, -1050)}
        }
    },
    RevengeBoss = {
        Name = "Revenge Boss",
        SpawnChance = 0.08,
        Duration = 400,
        Level = 2600,
        Rewards = {"Revenge Essence", "Vengeance Crystal", "Dark Insignia"},
        Position = CFrame.new(3000, 20, -2000),
        Boss = {Name = "Revenant Lord", Level = 2800, Health = 350000, Damage = 3500, Position = CFrame.new(3000, 30, -2000)}
    }
}

A.World.RainbowHakiData = {
    Levels = 10,
    Requirements = {
        [1] = {Enemies = 50, Color = Color3.fromRGB(255, 0, 0)},
        [2] = {Enemies = 100, Color = Color3.fromRGB(255, 127, 0)},
        [3] = {Enemies = 150, Color = Color3.fromRGB(255, 255, 0)},
        [4] = {Enemies = 200, Color = Color3.fromRGB(0, 255, 0)},
        [5] = {Enemies = 250, Color = Color3.fromRGB(0, 255, 255)},
        [6] = {Enemies = 300, Color = Color3.fromRGB(0, 0, 255)},
        [7] = {Enemies = 350, Color = Color3.fromRGB(75, 0, 130)},
        [8] = {Enemies = 400, Color = Color3.fromRGB(148, 0, 211)},
        [9] = {Enemies = 500, Color = Color3.fromRGB(255, 0, 255)},
        [10] = {Enemies = 750, Color = Color3.fromRGB(255, 255, 255)}
    }
}

A.World.EnhancementData = {
    Colors = {
        Red = {Enemies = 100, Position = CFrame.new(-4000, 20, -1500)},
        Blue = {Enemies = 100, Position = CFrame.new(200, 20, -3000)},
        Green = {Enemies = 100, Position = CFrame.new(-1200, 100, -1000)},
        Yellow = {Enemies = 100, Position = CFrame.new(5000, 20, 2000)},
        Purple = {Enemies = 150, Position = CFrame.new(3000, 20, -2000)},
        White = {Enemies = 200, Position = CFrame.new(-5000, 20, -2000)},
        Black = {Enemies = 250, Position = CFrame.new(6000, 20, 3000)}
    }
}

A.World.SkillChainData = {
    FruitSkills = {"Z", "X", "C", "V", "F"},
    SwordSkills = {"Z", "X"},
    MeleeSkills = {"Z", "X", "C", "V"},
    GunSkills = {"Z", "X"},
    RequiredHits = 100
}

local function GetTimeSinceSpawn()
    return tick() % 3600
end

local function IsEventSpawned(eventName)
    local eventData = A.World.EventData[eventName]
    if not eventData then return false end
    local eventFolder = workspace:FindFirstChild("Events") or workspace:FindFirstChild("WorldEvents")
    if eventFolder then
        local eventObj = eventFolder:FindFirstChild(eventData.Name)
        if eventObj then
            return true
        end
    end
    return false
end

local function GetEventTimer()
    local timeSinceSpawn = GetTimeSinceSpawn()
    local nextSpawn = 3600 - timeSinceSpawn
    return nextSpawn
end

local function WaitForEvent(eventName, timeout)
    local startTime = tick()
    while tick() - startTime < (timeout or 600) do
        if not A.World.Active then return false end
        if IsEventSpawned(eventName) then
            return true
        end
        task.wait(5)
    end
    return false
end

local function NavigateToPosition(position, timeout)
    if not position then return false end
    local startTime = tick()
    while tick() - startTime < (timeout or 30) do
        if not A.World.Active then return false end
        local myHRP = A.HRP()
        if myHRP then
            local dist = (myHRP.Position - position.Position).Magnitude
            if dist < 10 then
                return true
            end
        end
        A.TpTo(position.Position, 5)
        task.wait(0.5)
    end
    return false
end

local function FarmEventEnemies(enemies, duration)
    if not enemies then return 0 end
    local kills = 0
    local startTime = tick()
    while tick() - startTime < (duration or 300) do
        if not A.World.Active then break end
        local target = A.FindTarget(200)
        if target then
            A.SuperAttack(target)
            local hum = target:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then
                kills = kills + 1
            end
        else
            for _, enemy in ipairs(enemies) do
                if not A.World.Active then break end
                local enemyObj = workspace:FindFirstChild(enemy.Name, true)
                if enemyObj then
                    local hrp = enemyObj:FindFirstChild("HumanoidRootPart") or enemyObj:FindFirstChild("Handle")
                    if hrp then
                        A.TpTo(hrp.Position, 5)
                        task.wait(1)
                        local t = A.FindTarget(50)
                        if t then
                            A.SuperAttack(t)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
    return kills
end

local function CollectRewards(eventName)
    pcall(function()
        A.CommF("collectEventRewards", eventName)
    end)
    A.World.Stats.TotalDrops = A.World.Stats.TotalDrops + 1
end

function A.World.FindPrehistoricIsland()
    return IsEventSpawned("PrehistoricIsland")
end

function A.World.FarmPrehistoric()
    if not A.World.Active then return false end
    local eventData = A.World.EventData.PrehistoricIsland
    if not eventData then return false end
    A.Notify("World Events", "Farm Prehistoric Island started!", 5)
    NavigateToPosition(eventData.Position, 30)
    task.wait(2)
    local kills = FarmEventEnemies(eventData.Enemies, eventData.Duration - 30)
    A.World.PrehistoricKills = A.World.PrehistoricKills + kills
    A.World.Stats.PrehistoricCompleted = A.World.Stats.PrehistoricCompleted + 1
    CollectRewards("PrehistoricIsland")
    A.World.EventsCompleted = A.World.EventsCompleted + 1
    A.Notify("World Events", "Prehistoric Island completed! Kills: " .. kills, 5)
    return true
end

function A.World.AutoPrehistoricIsland()
    if not A.World.Active then return end
    if A.World.FindPrehistoricIsland() then
        A.World.FarmPrehistoric()
    end
end

function A.World.FindFrozenDimension()
    return IsEventSpawned("FrozenDimension")
end

function A.World.FarmFrozen()
    if not A.World.Active then return false end
    local eventData = A.World.EventData.FrozenDimension
    if not eventData then return false end
    A.Notify("World Events", "Farm Frozen Dimension started!", 5)
    NavigateToPosition(eventData.Position, 30)
    task.wait(2)
    local kills = FarmEventEnemies(eventData.Enemies, eventData.Duration - 30)
    A.World.FrozenKills = A.World.FrozenKills + kills
    A.World.Stats.FrozenCompleted = A.World.Stats.FrozenCompleted + 1
    CollectRewards("FrozenDimension")
    A.World.EventsCompleted = A.World.EventsCompleted + 1
    A.Notify("World Events", "Frozen Dimension completed! Kills: " .. kills, 5)
    return true
end

function A.World.AutoFrozenDimension()
    if not A.World.Active then return end
    if A.World.FindFrozenDimension() then
        A.World.FarmFrozen()
    end
end

function A.World.FindMirrorDimension()
    return IsEventSpawned("MirrorDimension")
end

function A.World.FarmMirror()
    if not A.World.Active then return false end
    local eventData = A.World.EventData.MirrorDimension
    if not eventData then return false end
    A.Notify("World Events", "Farm Mirror Dimension started!", 5)
    NavigateToPosition(eventData.Position, 30)
    task.wait(2)
    local kills = FarmEventEnemies(eventData.Enemies, eventData.Duration - 30)
    A.World.MirrorKills = A.World.MirrorKills + kills
    A.World.Stats.MirrorCompleted = A.World.Stats.MirrorCompleted + 1
    CollectRewards("MirrorDimension")
    A.World.EventsCompleted = A.World.EventsCompleted + 1
    A.Notify("World Events", "Mirror Dimension completed! Kills: " .. kills, 5)
    return true
end

function A.World.AutoMirrorDimension()
    if not A.World.Active then return end
    if A.World.FindMirrorDimension() then
        A.World.FarmMirror()
    end
end

function A.World.FindTree()
    return IsEventSpawned("TreeDestroyer")
end

function A.World.DestroyTree()
    if not A.World.Active then return false end
    local eventData = A.World.EventData.TreeDestroyer
    if not eventData then return false end
    A.Notify("World Events", "Destroying World Tree!", 5)
    NavigateToPosition(eventData.Position, 30)
    task.wait(2)
    local treeHealth = eventData.TreeHealth
    local startTime = tick()
    while tick() - startTime < eventData.Duration do
        if not A.World.Active then break end
        if treeHealth <= 0 then break end
        local target = A.FindTarget(100)
        if target then
            A.SuperAttack(target)
            local hum = target:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then
                treeHealth = treeHealth - 1000
            end
        else
            for _, enemy in ipairs(eventData.Enemies) do
                if not A.World.Active then break end
                local enemyObj = workspace:FindFirstChild(enemy.Name, true)
                if enemyObj then
                    local hrp = enemyObj:FindFirstChild("HumanoidRootPart") or enemyObj:FindFirstChild("Handle")
                    if hrp then
                        A.TpTo(hrp.Position, 5)
                        task.wait(1)
                    end
                end
            end
        end
        task.wait(0.5)
    end
    A.World.Stats.TreeDestroyed = A.World.Stats.TreeDestroyed + 1
    CollectRewards("TreeDestroyer")
    A.World.EventsCompleted = A.World.EventsCompleted + 1
    A.Notify("World Events", "World Tree destroyed!", 5)
    return true
end

function A.World.AutoTreeDestroyer()
    if not A.World.Active then return end
    if A.World.FindTree() then
        A.World.DestroyTree()
    end
end

function A.World.FindRevengeBoss()
    return IsEventSpawned("RevengeBoss")
end

function A.World.FarmRevenge()
    if not A.World.Active then return false end
    local eventData = A.World.EventData.RevengeBoss
    if not eventData then return false end
    A.Notify("World Events", "Farming Revenge Boss!", 5)
    NavigateToPosition(eventData.Position, 30)
    task.wait(2)
    local boss = eventData.Boss
    local startTime = tick()
    while tick() - startTime < eventData.Duration do
        if not A.World.Active then break end
        local bossObj = workspace:FindFirstChild(boss.Name, true)
        if bossObj then
            local hrp = bossObj:FindFirstChild("HumanoidRootPart") or bossObj:FindFirstChild("Handle")
            if hrp then
                A.TpTo(hrp.Position, 5)
                task.wait(1)
                local target = A.FindTarget(100)
                if target then
                    A.SuperAttack(target)
                    local hum = target:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health <= 0 then
                        A.World.Stats.RevengeBossKills = A.World.Stats.RevengeBossKills + 1
                        break
                    end
                end
            end
        else
            break
        end
        task.wait(0.5)
    end
    CollectRewards("RevengeBoss")
    A.World.EventsCompleted = A.World.EventsCompleted + 1
    A.Notify("World Events", "Revenge Boss defeated!", 5)
    return true
end

function A.World.AutoRevengeBoss()
    if not A.World.Active then return end
    if A.World.FindRevengeBoss() then
        A.World.FarmRevenge()
    end
end

function A.World.GetRainbowProgress()
    local success, level = pcall(function()
        return A.CommF("getRainbowHakiLevel")
    end)
    if success and level then
        return level
    end
    return 0
end

function A.World.FarmRainbowHaki()
    if not A.World.Active then return end
    local currentLevel = A.World.GetRainbowProgress()
    if currentLevel >= A.World.RainbowHakiData.Levels then
        A.Notify("Rainbow Haki", "Rainbow Haki already maxed!", 3)
        return
    end
    local requirement = A.World.RainbowHakiData.Requirements[currentLevel + 1]
    if not requirement then return end
    A.Notify("Rainbow Haki", "Farming Rainbow Haki Level " .. (currentLevel + 1) .. " (" .. requirement.Enemies .. " enemies)", 5)
    local kills = 0
    local startTime = tick()
    while tick() - startTime < 300 do
        if not A.World.Active then break end
        if kills >= requirement.Enemies then break end
        local target = A.FindTarget(200)
        if target then
            A.SuperAttack(target)
            local hum = target:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then
                kills = kills + 1
            end
        end
        task.wait(0.5)
    end
    A.World.Stats.RainbowHakiProgress = kills
    A.Notify("Rainbow Haki", "Farmed " .. kills .. "/" .. requirement.Enemies .. " enemies", 3)
end

function A.World.AutoRainbowHaki()
    if not A.World.Active then return end
    A.World.FarmRainbowHaki()
end

function A.World.GetEnhancementProgress()
    local success, level = pcall(function()
        return A.CommF("getEnhancementLevel")
    end)
    if success and level then
        return level
    end
    return 0
end

function A.World.FarmEnhancement()
    if not A.World.Active then return end
    local colors = {"Red", "Blue", "Green", "Yellow", "Purple", "White", "Black"}
    for _, color in ipairs(colors) do
        if not A.World.Active then break end
        local colorData = A.World.EnhancementData[color]
        if colorData then
            local success, unlocked = pcall(function()
                return A.CommF("hasEnhancement", color)
            end)
            if success and not unlocked then
                A.Notify("Enhancement", "Farming " .. color .. " Enhancement...", 5)
                NavigateToPosition(colorData.Position, 30)
                task.wait(2)
                local kills = 0
                local startTime = tick()
                while tick() - startTime < 300 do
                    if not A.World.Active then break end
                    if kills >= colorData.Enemies then break end
                    local target = A.FindTarget(200)
                    if target then
                        A.SuperAttack(target)
                        local hum = target:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health <= 0 then
                            kills = kills + 1
                        end
                    end
                    task.wait(0.5)
                end
                A.World.Stats.EnhancementProgress = A.World.Stats.EnhancementProgress + 1
                A.Notify("Enhancement", color .. " Enhancement farmed! " .. kills .. "/" .. colorData.Enemies, 3)
            end
        end
    end
end

function A.World.AutoEnhancementColor()
    if not A.World.Active then return end
    A.World.FarmEnhancement()
end

function A.World.GetSkillChainProgress()
    local success, progress = pcall(function()
        return A.CommF("getSkillChainProgress")
    end)
    if success and progress then
        return progress
    end
    return 0
end

function A.World.FarmSkillChain()
    if not A.World.Active then return end
    A.Notify("Skill Chain", "Farming Skill Chains...", 5)
    local skills = A.World.SkillChainData.FruitSkills
    for _, skill in ipairs(skills) do
        if not A.World.Active then break end
        local hits = 0
        local startTime = tick()
        while tick() - startTime < 120 do
            if not A.World.Active then break end
            if hits >= A.World.SkillChainData.RequiredHits then break end
            local target = A.FindTarget(100)
            if target then
                A.Attack(target, {skill}, 0.1)
                hits = hits + 1
            end
            task.wait(0.2)
        end
    end
    A.World.Stats.SkillChainProgress = A.World.Stats.SkillChainProgress + 1
    A.Notify("Skill Chain", "Skill Chain farming complete!", 3)
end

function A.World.AutoFruitSkillChain()
    if not A.World.Active then return end
    A.World.FarmSkillChain()
end

function A.World.GetSwordChainProgress()
    local success, progress = pcall(function()
        return A.CommF("getSwordChainProgress")
    end)
    if success and progress then
        return progress
    end
    return 0
end

function A.World.FarmSwordChain()
    if not A.World.Active then return end
    A.Notify("Sword Chain", "Farming Sword Chains...", 5)
    local skills = A.World.SkillChainData.SwordSkills
    for _, skill in ipairs(skills) do
        if not A.World.Active then break end
        local hits = 0
        local startTime = tick()
        while tick() - startTime < 120 do
            if not A.World.Active then break end
            if hits >= A.World.SkillChainData.RequiredHits then break end
            local target = A.FindTarget(100)
            if target then
                A.Attack(target, {skill}, 0.1)
                hits = hits + 1
            end
            task.wait(0.2)
        end
    end
    A.World.Stats.SkillChainProgress = A.World.Stats.SkillChainProgress + 1
    A.Notify("Sword Chain", "Sword Chain farming complete!", 3)
end

function A.World.AutoSwordSkillChain()
    if not A.World.Active then return end
    A.World.FarmSwordChain()
end

function A.World.FindWorldEvent()
    for eventName, eventData in pairs(A.World.EventData) do
        if IsEventSpawned(eventName) then
            return eventName, eventData
        end
    end
    return nil, nil
end

function A.World.GetEventStatus()
    local statuses = {}
    for eventName, eventData in pairs(A.World.EventData) do
        statuses[eventName] = {
            Name = eventData.Name,
            Active = IsEventSpawned(eventName),
            Level = eventData.Level,
            Duration = eventData.Duration
        }
    end
    return statuses
end

function A.World.WaitForEvent(eventName, timeout)
    return WaitForEvent(eventName, timeout)
end

function A.World.GetEventTimer()
    return GetEventTimer()
end

function A.World.IsEventActive(eventName)
    return IsEventSpawned(eventName)
end

function A.World.GetActiveEvents()
    local active = {}
    for eventName, eventData in pairs(A.World.EventData) do
        if IsEventSpawned(eventName) then
            table.insert(active, {
                Name = eventName,
                Data = eventData
            })
        end
    end
    return active
end

function A.World.NavigateToEvent(event)
    if not event then return false end
    local eventData = A.World.EventData[event]
    if not eventData then return false end
    return NavigateToPosition(eventData.Position, 60)
end

function A.World.FightEvent(event)
    if not event then return false end
    if event == "PrehistoricIsland" then
        return A.World.FarmPrehistoric()
    elseif event == "FrozenDimension" then
        return A.World.FarmFrozen()
    elseif event == "MirrorDimension" then
        return A.World.FarmMirror()
    elseif event == "TreeDestroyer" then
        return A.World.DestroyTree()
    elseif event == "RevengeBoss" then
        return A.World.FarmRevenge()
    end
    return false
end

function A.World.CollectEventRewards(event)
    CollectRewards(event)
end

function A.World.GetEventDrops(event)
    local eventData = A.World.EventData[event]
    if not eventData then return {} end
    return eventData.Rewards or {}
end

function A.World.GetWorldStats()
    local stats = A.World.Stats
    local uptime = tick() - stats.SessionStart
    return {
        EventsCompleted = stats.EventsCompleted,
        PrehistoricCompleted = stats.PrehistoricCompleted,
        FrozenCompleted = stats.FrozenCompleted,
        MirrorCompleted = stats.MirrorCompleted,
        TreeDestroyed = stats.TreeDestroyed,
        RevengeBossKills = stats.RevengeBossKills,
        RainbowHakiProgress = stats.RainbowHakiProgress,
        EnhancementProgress = stats.EnhancementProgress,
        SkillChainProgress = stats.SkillChainProgress,
        TotalDrops = stats.TotalDrops,
        SessionUptime = uptime,
        EventsPerHour = uptime > 0 and (stats.EventsCompleted / (uptime / 3600)) or 0
    }
end

function A.World.GetEventHistory()
    return {
        PrehistoricKills = A.World.PrehistoricKills,
        FrozenKills = A.World.FrozenKills,
        MirrorKills = A.World.MirrorKills,
        TotalEventsCompleted = A.World.EventsCompleted
    }
end

function A.World.AutoAllEvents()
    if not A.World.Active then return end
    A.World.AutoPrehistoricIsland()
    task.wait(2)
    A.World.AutoFrozenDimension()
    task.wait(2)
    A.World.AutoMirrorDimension()
    task.wait(2)
    A.World.AutoTreeDestroyer()
    task.wait(2)
    A.World.AutoRevengeBoss()
    task.wait(2)
    A.World.AutoRainbowHaki()
    task.wait(2)
    A.World.AutoEnhancementColor()
    task.wait(2)
    A.World.AutoFruitSkillChain()
    task.wait(2)
    A.World.AutoSwordSkillChain()
end

function A.World.FarmAllWorldEvents()
    A.World.AutoAllEvents()
end

function A.World.MainLoop()
    while A.World.Active do
        pcall(function()
            local eventName, eventData = A.World.FindWorldEvent()
            if eventName and eventData then
                A.Notify("World Events", eventData.Name .. " detected!", 5)
                A.World.FightEvent(eventName)
            else
                local nextEvent = A.World.GetEventTimer()
                if nextEvent < 60 then
                    A.Notify("World Events", "Event spawning in " .. math.floor(nextEvent) .. "s", 3)
                end
            end
        end)
        task.wait(10)
    end
end

function A.World.Start()
    if A.World.Active then return end
    A.World.Active = true
    A.World.Stats = {
        EventsCompleted = 0,
        PrehistoricCompleted = 0,
        FrozenCompleted = 0,
        MirrorCompleted = 0,
        TreeDestroyed = 0,
        RevengeBossKills = 0,
        RainbowHakiProgress = 0,
        EnhancementProgress = 0,
        SkillChainProgress = 0,
        TotalDrops = 0,
        SessionStart = tick()
    }
    A.Notify("World Events", "World event system started!", 5)
    task.spawn(function()
        A.World.MainLoop()
    end)
end

function A.World.Stop()
    A.World.Active = false
    A.Notify("World Events", "World event system stopped!", 3)
end

A.Register("world", A.World)
