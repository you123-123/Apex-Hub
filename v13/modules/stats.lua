--[[
    Apex Hub v13.0 - Auto Stats Module
    Automatic stat point distribution for optimal builds
]]

local A = _G.Apex
if not A then return end

A.Stats = {}
A.Stats.Active = false
A.Stats.Build = "Melee"
A.Stats.LastDistribution = {}
A.Stats.LastCheck = 0
A.Stats.CheckInterval = 3
A.Stats.SessionStart = tick()
A.Stats.TotalPointsSpent = 0
A.Stats.LastPoints = 0
A.Stats.DistributionLog = {}
A.Stats.AutoDistribute = true
A.Stats.PointThreshold = 5
A.Stats.BuildWeights = {
    Melee = {Melee = 100, Defense = 100, Sword = 0, Gun = 0, ["Blox Fruit"] = 0},
    Sword = {Melee = 0, Defense = 100, Sword = 100, Gun = 0, ["Blox Fruit"] = 0},
    Fruit = {Melee = 0, Defense = 100, Sword = 0, Gun = 0, ["Blox Fruit"] = 100},
    Gun = {Melee = 0, Defense = 100, Sword = 0, Gun = 100, ["Blox Fruit"] = 0},
}

A.Stats.ValidStats = {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"}

function A.Stats.MainLoop()
    while A.Stats.Active do
        if not A.Alive() then
            task.wait(3)
        else
            local points = A.Stats.GetPoints()
            if points and points >= A.Stats.PointThreshold then
                A.Stats.Distribute(points)
            end
        end
        task.wait(A.Stats.CheckInterval)
    end
end

function A.Stats.GetPoints()
    local player = A.LP
    if not player then return 0 end
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local pointsStat = leaderstats:FindFirstChild("Stat Points") or leaderstats:FindFirstChild("Points")
        if pointsStat and pointsStat:IsA("ValueBase") then
            return pointsStat.Value
        end
    end
    local statsFolder = player:FindFirstChild("DataFolder") or player:FindFirstChild("Stats")
    if statsFolder then
        local pointsStat = statsFolder:FindFirstChild("Points") or statsFolder:FindFirstChild("StatPoints")
        if pointsStat then
            return pointsStat.Value
        end
    end
    return 0
end

function A.Stats.GetStats()
    local player = A.LP
    if not player then return {} end
    local stats = {}
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        for _, statName in ipairs(A.Stats.ValidStats) do
            local stat = leaderstats:FindFirstChild(statName)
            if stat and stat:IsA("ValueBase") then
                stats[statName] = stat.Value
            else
                stats[statName] = 0
            end
        end
    end
    return stats
end

function A.Stats.Distribute(points)
    if not points or points <= 0 then return false end
    local build = A.Stats.Build
    local weights = A.Stats.BuildWeights[build]
    if not weights then
        A.Notify("Stats", "Invalid build: " .. tostring(build), 3)
        return false
    end
    local totalWeight = 0
    for _, w in pairs(weights) do
        totalWeight = totalWeight + w
    end
    if totalWeight <= 0 then return false end
    local distributed = 0
    local allocations = {}
    for statName, weight in pairs(weights) do
        if weight > 0 then
            local share = math.floor(points * weight / totalWeight)
            allocations[statName] = share
            distributed = distributed + share
        else
            allocations[statName] = 0
        end
    end
    local remainder = points - distributed
    for statName, weight in pairs(weights) do
        if remainder <= 0 then break end
        if weight > 0 then
            allocations[statName] = allocations[statName] + 1
            remainder = remainder - 1
        end
    end
    local success = false
    for statName, amount in pairs(allocations) do
        if amount > 0 then
            local result = pcall(function()
                A.CommF("AddPoint", statName, amount)
            end)
            if result then
                success = true
                A.Stats.TotalPointsSpent = A.Stats.TotalPointsSpent + amount
                table.insert(A.Stats.DistributionLog, {
                    stat = statName,
                    amount = amount,
                    time = os.date("%Y-%m-%d %H:%M:%S"),
                    build = build,
                })
            end
        end
    end
    A.Stats.LastDistribution = allocations
    if success then
        A.Notify("Stats", "Distributed " .. points .. " points (" .. build .. " build)", 3)
    end
    return success
end

function A.Stats.SetBuild(build)
    if not A.Stats.BuildWeights[build] then
        A.Notify("Stats", "Invalid build: " .. tostring(build), 3)
        return false
    end
    A.Stats.Build = build
    A.Notify("Stats", "Build set to: " .. build, 3)
    return true
end

function A.Stats.MeleeBuild(points)
    if not points or points <= 0 then return false end
    local half = math.floor(points / 2)
    local remainder = points - half
    local success = false
    local result1 = pcall(function()
        A.CommF("AddPoint", "Melee", half)
    end)
    if result1 then
        success = true
        A.Stats.TotalPointsSpent = A.Stats.TotalPointsSpent + half
    end
    local result2 = pcall(function()
        A.CommF("AddPoint", "Defense", half + remainder)
    end)
    if result2 then
        success = true
        A.Stats.TotalPointsSpent = A.Stats.TotalPointsSpent + half + remainder
    end
    A.Stats.LastDistribution = {Melee = half, Defense = half + remainder}
    if success then
        A.Stats.Build = "Melee"
        A.Notify("Stats", "Melee build: " .. points .. " points distributed", 3)
    end
    return success
end

function A.Stats.SwordBuild(points)
    if not points or points <= 0 then return false end
    local half = math.floor(points / 2)
    local remainder = points - half
    local success = false
    local result1 = pcall(function()
        A.CommF("AddPoint", "Sword", half)
    end)
    if result1 then
        success = true
        A.Stats.TotalPointsSpent = A.Stats.TotalPointsSpent + half
    end
    local result2 = pcall(function()
        A.CommF("AddPoint", "Defense", half + remainder)
    end)
    if result2 then
        success = true
        A.Stats.TotalPointsSpent = A.Stats.TotalPointsSpent + half + remainder
    end
    A.Stats.LastDistribution = {Sword = half, Defense = half + remainder}
    if success then
        A.Stats.Build = "Sword"
        A.Notify("Stats", "Sword build: " .. points .. " points distributed", 3)
    end
    return success
end

function A.Stats.FruitBuild(points)
    if not points or points <= 0 then return false end
    local half = math.floor(points / 2)
    local remainder = points - half
    local success = false
    local result1 = pcall(function()
        A.CommF("AddPoint", "Blox Fruit", half)
    end)
    if result1 then
        success = true
        A.Stats.TotalPointsSpent = A.Stats.TotalPointsSpent + half
    end
    local result2 = pcall(function()
        A.CommF("AddPoint", "Defense", half + remainder)
    end)
    if result2 then
        success = true
        A.Stats.TotalPointsSpent = A.Stats.TotalPointsSpent + half + remainder
    end
    A.Stats.LastDistribution = {["Blox Fruit"] = half, Defense = half + remainder}
    if success then
        A.Stats.Build = "Fruit"
        A.Notify("Stats", "Fruit build: " .. points .. " points distributed", 3)
    end
    return success
end

function A.Stats.GunBuild(points)
    if not points or points <= 0 then return false end
    local half = math.floor(points / 2)
    local remainder = points - half
    local success = false
    local result1 = pcall(function()
        A.CommF("AddPoint", "Gun", half)
    end)
    if result1 then
        success = true
        A.Stats.TotalPointsSpent = A.Stats.TotalPointsSpent + half
    end
    local result2 = pcall(function()
        A.CommF("AddPoint", "Defense", half + remainder)
    end)
    if result2 then
        success = true
        A.Stats.TotalPointsSpent = A.Stats.TotalPointsSpent + half + remainder
    end
    A.Stats.LastDistribution = {Gun = half, Defense = half + remainder}
    if success then
        A.Stats.Build = "Gun"
        A.Notify("Stats", "Gun build: " .. points .. " points distributed", 3)
    end
    return success
end

function A.Stats.CustomBuild(points, statTable)
    if not points or points <= 0 then return false end
    if not statTable or type(statTable) ~= "table" then
        A.Notify("Stats", "Invalid stat table", 3)
        return false
    end
    local totalWeight = 0
    for _, w in pairs(statTable) do
        totalWeight = totalWeight + w
    end
    if totalWeight <= 0 then return false end
    local distributed = 0
    local allocations = {}
    for statName, weight in pairs(statTable) do
        if weight > 0 then
            local share = math.floor(points * weight / totalWeight)
            allocations[statName] = share
            distributed = distributed + share
        else
            allocations[statName] = 0
        end
    end
    local remainder = points - distributed
    for statName, weight in pairs(statTable) do
        if remainder <= 0 then break end
        if weight > 0 then
            allocations[statName] = allocations[statName] + 1
            remainder = remainder - 1
        end
    end
    local success = false
    for statName, amount in pairs(allocations) do
        if amount > 0 then
            local result = pcall(function()
                A.CommF("AddPoint", statName, amount)
            end)
            if result then
                success = true
                A.Stats.TotalPointsSpent = A.Stats.TotalPointsSpent + amount
                table.insert(A.Stats.DistributionLog, {
                    stat = statName,
                    amount = amount,
                    time = os.date("%Y-%m-%d %H:%M:%S"),
                    build = "Custom",
                })
            end
        end
    end
    A.Stats.LastDistribution = allocations
    if success then
        A.Notify("Stats", "Custom build: " .. points .. " points distributed", 3)
    end
    return success
end

function A.Stats.ResetStats()
    local canReset = A.Stats.CanReset()
    if not canReset then
        A.Notify("Stats", "Cannot reset stats (need gems or not available)", 3)
        return false
    end
    local success = pcall(function()
        A.CommF("StatRefund")
    end)
    if success then
        A.Stats.TotalPointsSpent = 0
        A.Stats.LastDistribution = {}
        A.Notify("Stats", "Stats reset successfully!", 4)
    else
        A.Notify("Stats", "Failed to reset stats", 3)
    end
    return success
end

function A.Stats.OptimalDistribution(level)
    level = level or A.Lv() or 1
    local builds = {
        Melee = {
            levelRange = {1, 2550},
            Melee = 0.4,
            Defense = 0.5,
            Sword = 0.05,
            Gun = 0.0,
            ["Blox Fruit"] = 0.05,
        },
        Sword = {
            levelRange = {1, 2550},
            Melee = 0.0,
            Defense = 0.5,
            Sword = 0.45,
            Gun = 0.0,
            ["Blox Fruit"] = 0.05,
        },
        Fruit = {
            levelRange = {1, 2550},
            Melee = 0.0,
            Defense = 0.5,
            Sword = 0.0,
            Gun = 0.0,
            ["Blox Fruit"] = 0.5,
        },
        Gun = {
            levelRange = {1, 2550},
            Melee = 0.0,
            Defense = 0.5,
            Sword = 0.0,
            Gun = 0.45,
            ["Blox Fruit"] = 0.05,
        },
    }
    local bestBuild = "Melee"
    local bestScore = 0
    for buildName, buildData in pairs(builds) do
        if level >= buildData.levelRange[1] and level <= buildData.levelRange[2] then
            local score = buildData["Blox Fruit"] + buildData.Sword + buildData.Gun + buildData.Melee
            if score > bestScore then
                bestScore = score
                bestBuild = buildName
            end
        end
    end
    return bestBuild
end

function A.Stats.GetBuildInfo()
    local build = A.Stats.Build
    local weights = A.Stats.BuildWeights[build]
    if not weights then return nil end
    local currentStats = A.Stats.GetStats()
    return {
        build = build,
        weights = weights,
        currentStats = currentStats,
        lastDistribution = A.Stats.LastDistribution,
        totalPointsSpent = A.Stats.TotalPointsSpent,
    }
end

function A.Stats.CompareBuilds(b1, b2)
    local w1 = A.Stats.BuildWeights[b1]
    local w2 = A.Stats.BuildWeights[b2]
    if not w1 or not w2 then return nil end
    local comparison = {}
    for _, stat in ipairs(A.Stats.ValidStats) do
        comparison[stat] = {
            [b1] = w1[stat] or 0,
            [b2] = w2[stat] or 0,
            diff = (w1[stat] or 0) - (w2[stat] or 0),
        }
    end
    return comparison
end

function A.Stats.CanReset()
    local player = A.LP
    if not player then return false end
    local stats = player:FindFirstChild("DataFolder") or player:FindFirstChild("Stats")
    if stats then
        local gems = stats:FindFirstChild("Gems") or stats:FindFirstChild("Fragment")
        if gems and gems:IsA("ValueBase") and gems.Value >= 2500 then
            return true
        end
    end
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local gems = leaderstats:FindFirstChild("Gems") or leaderstats:FindFirstChild("Fragment")
        if gems and gems:IsA("ValueBase") and gems.Value >= 2500 then
            return true
        end
    end
    return false
end

function A.Stats.GetStatByName(name)
    if not name then return 0 end
    local stats = A.Stats.GetStats()
    for statName, value in pairs(stats) do
        if statName == name then
            return value
        end
    end
    return 0
end

function A.Stats.GetMaxStat()
    local stats = A.Stats.GetStats()
    local maxStat = nil
    local maxValue = -1
    for statName, value in pairs(stats) do
        if value > maxValue then
            maxValue = value
            maxStat = statName
        end
    end
    return maxStat, maxValue
end

function A.Stats.GetTotalPoints()
    local stats = A.Stats.GetStats()
    local total = 0
    for _, value in pairs(stats) do
        total = total + value
    end
    return total
end

function A.Stats.Start()
    if A.Stats.Active then
        A.Notify("Stats", "Already running!", 2)
        return
    end
    A.Stats.Active = true
    A.Stats.SessionStart = tick()
    A.Stats.TotalPointsSpent = 0
    A.Notify("Stats", "Auto stats started (" .. A.Stats.Build .. " build)", 3)
    task.spawn(A.Stats.MainLoop)
end

function A.Stats.Stop()
    A.Stats.Active = false
    A.Notify("Stats", "Auto stats stopped. Spent " .. A.Stats.TotalPointsSpent .. " points this session.", 3)
end

A.Register("stats", A.Stats)
