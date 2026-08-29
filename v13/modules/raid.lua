--[[
    Apex Hub v13.0 - Raid Module
    Comprehensive raid system with auto-start, rotation, and AFK mode
]]

local A = _G.Apex
if not A then return end

A.Raid = {}
A.Raid.Active = false
A.Raid.CurrentRaid = nil
A.Raid.RaidsCompleted = 0
A.Raid.FragmentEarned = 0
A.Raid.SessionStart = tick()
A.Raid.LastRaidEnd = 0
A.Raid.RaidCooldown = 300
A.Raid.AutoStart = true
A.Raid.AFKMode = false
A.Raid.SpeedMode = false
A.Raid.SafeMode = false
A.Raid.RotationIndex = 0
A.Raid.LastRoomClear = 0
A.Raid.RoomCheckInterval = 2
A.Raid.CurrentRoom = 0
A.Raid.MaxRooms = 4
A.Raid.RaidEnemies = {}
A.Raid.RaidLog = {}
A.Raid.TotalKills = 0
A.Raid.RaidStartTime = 0
A.Raid.BossKilled = false

A.Raid.RaidTypes = {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Magma", "Human", "Cyborg", "Buddha", "Angel", "Leopard", "Mammoth", "T-Rex", "Dough", "Kitsune"}

A.Raid.RaidCosts = {
    ["Flame"] = 1000,
    ["Ice"] = 1000,
    ["Quake"] = 1000,
    ["Light"] = 1000,
    ["Dark"] = 1000,
    ["String"] = 1000,
    ["Magma"] = 1000,
    ["Human"] = 1000,
    ["Cyborg"] = 1000,
    ["Buddha"] = 1500,
    ["Angel"] = 1500,
    ["Leopard"] = 2000,
    ["Mammoth"] = 2000,
    ["T-Rex"] = 2000,
    ["Dough"] = 2000,
    ["Kitsune"] = 2500,
}

A.Raid.RaidRewards = {
    ["Flame"] = {"Flame Fruit", "Flame Essence"},
    ["Ice"] = {"Ice Fruit", "Ice Essence"},
    ["Quake"] = {"Quake Fruit", "Quake Essence"},
    ["Light"] = {"Light Fruit", "Light Essence"},
    ["Dark"] = {"Dark Fruit", "Dark Essence"},
    ["String"] = {"String Fruit", "String Essence"},
    ["Magma"] = {"Magma Fruit", "Magma Essence"},
    ["Human"] = {"Human Fruit", "Human Essence"},
    ["Cyborg"] = {"Cyborg Fruit", "Cyborg Essence"},
    ["Buddha"] = {"Buddha Fruit", "Buddha Essence"},
    ["Angel"] = {"Angel Fruit", "Angel Essence"},
    ["Leopard"] = {"Leopard Fruit", "Leopard Essence"},
    ["Mammoth"] = {"Mammoth Fruit", "Mammoth Essence"},
    ["T-Rex"] = {"T-Rex Fruit", "T-Rex Essence"},
    ["Dough"] = {"Dough Fruit", "Dough Essence"},
    ["Kitsune"] = {"Kitsune Fruit", "Kitsune Essence"},
}

A.Raid.RaidLocations = {
    ["Flame"] = A.V3(2800, 60, -1400),
    ["Ice"] = A.V3(2800, 60, -1400),
    ["Quake"] = A.V3(2800, 60, -1400),
    ["Light"] = A.V3(2800, 60, -1400),
    ["Dark"] = A.V3(2800, 60, -1400),
    ["String"] = A.V3(2800, 60, -1400),
    ["Magma"] = A.V3(2800, 60, -1400),
    ["Human"] = A.V3(2800, 60, -1400),
    ["Cyborg"] = A.V3(2800, 60, -1400),
    ["Buddha"] = A.V3(2800, 60, -1400),
    ["Angel"] = A.V3(2800, 60, -1400),
    ["Leopard"] = A.V3(2800, 60, -1400),
    ["Mammoth"] = A.V3(2800, 60, -1400),
    ["T-Rex"] = A.V3(2800, 60, -1400),
    ["Dough"] = A.V3(2800, 60, -1400),
    ["Kitsune"] = A.V3(2800, 60, -1400),
}

function A.Raid.MainLoop()
    while A.Raid.Active do
        if not A.Alive() then
            A.Notify("Raid", "Waiting for respawn...", 3)
            task.wait(3)
        else
            if A.Raid.CurrentRaid then
                A.Raid.CompleteRaid()
            else
                if A.Raid.AutoStart then
                    local canStart = A.Raid.CanStartRaid()
                    if canStart then
                        local raidType = A.Raid.GetOptimalRaid(A.Lv())
                        if raidType then
                            A.Raid.StartRaid(raidType)
                        end
                    else
                        A.Raid.WaitRaidCooldown()
                    end
                end
            end
        end
        task.wait(1)
    end
end

function A.Raid.StartRaid(type)
    if not type then
        A.Notify("Raid", "No raid type specified", 2)
        return false
    end
    if A.Raid.CurrentRaid then
        A.Notify("Raid", "Already in a raid!", 2)
        return false
    end
    A.Notify("Raid", "Starting " .. type .. " raid...", 4)
    local npc = A.Raid.FindRaidNPC()
    if not npc then
        A.Notify("Raid", "Raid NPC not found, navigating...", 3)
        A.TpTo(A.V3(2800, 60, -1400), 30)
        task.wait(2)
        npc = A.Raid.FindRaidNPC()
        if not npc then
            A.Notify("Raid", "Could not find raid NPC", 3)
            return false
        end
    end
    A.TpTo(npc.HumanoidRootPart.Position, 20)
    task.wait(1)
    local boughtChip = A.Raid.BuyChip(type)
    if not boughtChip then
        A.Notify("Raid", "Failed to buy raid chip for " .. type, 3)
        return false
    end
    A.Raid.CurrentRaid = type
    A.Raid.RaidStartTime = tick()
    A.Raid.CurrentRoom = 0
    A.Raid.BossKilled = false
    A.Raid.RaidEnemies = {}
    A.Notify("Raid", type .. " raid started!", 5)
    return true
end

function A.Raid.FindRaidNPC()
    local npcNames = {"Law", "Blox Fruit Dealer", "Raid Boss", "Scientist"}
    local npcFolder = A.G:FindFirstChild("NPCs") or A.G:FindFirstChild("Enemys")
    if npcFolder then
        for _, npcName in ipairs(npcNames) do
            local npc = npcFolder:FindFirstChild(npcName)
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                return npc
            end
        end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
            for _, npcName in ipairs(npcNames) do
                if obj.Name == npcName then
                    return obj
                end
            end
        end
    end
    return nil
end

function A.Raid.BuyChip(type)
    if not type then return false end
    local cost = A.Raid.RaidCosts[type] or 1000
    local fragments = A.Raid.GetFragmentsNeeded()
    if fragments < cost then
        A.Notify("Raid", "Not enough fragments. Need " .. cost .. ", have " .. fragments, 3)
        return false
    end
    local success = pcall(function()
        A.CommF("BuyChip", type)
    end)
    if success then
        A.Notify("Raid", "Bought " .. type .. " chip", 3)
    end
    return success
end

function A.Raid.StartNextRaid()
    if A.Raid.CurrentRaid then return false end
    if tick() - A.Raid.LastRaidEnd < A.Raid.RaidCooldown then
        return false
    end
    local raidType = A.Raid.GetOptimalRaid(A.Lv())
    if raidType then
        return A.Raid.StartRaid(raidType)
    end
    return false
end

function A.Raid.CompleteRaid()
    if not A.Raid.CurrentRaid then return false end
    local raidType = A.Raid.CurrentRaid
    if A.Raid.SafeMode then
        A.Raid.SafeRaid()
    elseif A.Raid.SpeedMode then
        A.Raid.SpeedRaid()
    else
        A.Raid.NavigateRaid()
    end
    if A.Raid.BossKilled then
        A.Raid.CollectRaidRewards()
        A.Raid.RaidsCompleted = A.Raid.RaidsCompleted + 1
        local raidTime = tick() - A.Raid.RaidStartTime
        local reward = A.Raid.GetRaidReward(raidType)
        table.insert(A.Raid.RaidLog, {
            type = raidType,
            time = os.date("%Y-%m-%d %H:%M:%S"),
            duration = math.floor(raidTime),
            reward = reward,
        })
        A.Notify("Raid", raidType .. " raid completed in " .. math.floor(raidTime) .. "s!", 5)
        A.Raid.CurrentRaid = nil
        A.Raid.LastRaidEnd = tick()
        return true
    end
    return false
end

function A.Raid.KillRaidBoss()
    local boss = nil
    local npcFolder = A.G:FindFirstChild("NPCs") or A.G:FindFirstChild("Enemys")
    if npcFolder then
        for _, npc in ipairs(npcFolder:GetChildren()) do
            if npc:IsA("Model") then
                local hum = npc:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local level = npc:FindFirstChild("Level") and npc.Level.Value or 0
                    if level >= 1000 then
                        boss = npc
                        break
                    end
                end
            end
        end
    end
    if boss then
        A.TpTo(boss.HumanoidRootPart.Position, 25)
        task.wait(0.3)
        local hum = boss:FindFirstChildOfClass("Humanoid")
        while hum and hum.Health > 0 and A.Raid.Active do
            if not A.Alive() then
                task.wait(3)
                if not A.Alive() then break end
            end
            A.SuperAttack(boss)
            task.wait(0.1)
        end
        if not hum or hum.Health <= 0 then
            A.Raid.BossKilled = true
            A.Raid.TotalKills = A.Raid.TotalKills + 1
            A.Notify("Raid", "Raid boss defeated!", 4)
            return true
        end
    end
    return false
end

function A.Raid.GetRaidType()
    return A.Raid.CurrentRaid or "None"
end

function A.Raid.GetRaidEnemies()
    local enemies = {}
    local npcFolder = A.G:FindFirstChild("NPCs") or A.G:FindFirstChild("Enemys")
    if npcFolder then
        for _, npc in ipairs(npcFolder:GetChildren()) do
            if npc:IsA("Model") then
                local hum = npc:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    table.insert(enemies, {
                        name = npc.Name,
                        model = npc,
                        health = hum.Health,
                        maxHealth = hum.MaxHealth,
                    })
                end
            end
        end
    end
    return enemies
end

function A.Raid.NavigateRaid()
    local enemies = A.Raid.GetRaidEnemies()
    if #enemies == 0 then
        A.Raid.CurrentRoom = A.Raid.CurrentRoom + 1
        A.Notify("Raid", "Room " .. A.Raid.CurrentRoom .. " cleared!", 3)
        if A.Raid.CurrentRoom >= A.Raid.MaxRooms then
            A.Raid.KillRaidBoss()
        end
        task.wait(1)
        return
    end
    for _, enemy in ipairs(enemies) do
        if not A.Raid.Active then break end
        if enemy.model and enemy.model:FindFirstChild("HumanoidRootPart") then
            local dist = (enemy.model.HumanoidRootPart.Position - A.HRP().Position).Magnitude
            if dist > 50 then
                A.TpTo(enemy.model.HumanoidRootPart.Position, 30)
            else
                A.SuperAttack(enemy.model)
                A.Raid.TotalKills = A.Raid.TotalKills + 1
            end
            task.wait(0.2)
        end
    end
end

function A.Raid.CollectRaidRewards()
    pcall(function()
        A.CommF("CollectRaidReward")
    end)
    A.Raid.FragmentEarned = A.Raid.FragmentEarned + 1000
    A.Notify("Raid", "Raid rewards collected!", 4)
end

function A.Raid.FarmAllRaids()
    while A.Raid.Active do
        local raidType = A.Raid.GetOptimalRaid(A.Lv())
        if raidType then
            if A.Raid.CanStartRaid() then
                A.Raid.StartRaid(raidType)
                while A.Raid.CurrentRaid and A.Raid.Active do
                    task.wait(1)
                end
            else
                A.Raid.WaitRaidCooldown()
            end
        end
        task.wait(2)
    end
end

function A.Raid.GetRaidTimer()
    local elapsed = tick() - A.Raid.LastRaidEnd
    local remaining = A.Raid.RaidCooldown - elapsed
    if remaining <= 0 then return 0 end
    return remaining
end

function A.Raid.WaitRaidCooldown()
    A.Notify("Raid", "Waiting for raid cooldown...", 2)
    while A.Raid.Active do
        local timer = A.Raid.GetRaidTimer()
        if timer <= 0 then
            return true
        end
        task.wait(2)
    end
    return false
end

function A.Raid.GetRaidReward(type)
    if not type then return nil end
    local rewards = A.Raid.RaidRewards[type]
    if rewards then
        return rewards[1]
    end
    return nil
end

function A.Raid.GetFragmentsNeeded()
    local player = A.LP
    if not player then return 0 end
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local frag = leaderstats:FindFirstChild("Fragments") or leaderstats:FindFirstChild("Fragment")
        if frag and frag:IsA("ValueBase") then
            return frag.Value
        end
    end
    return 0
end

function A.Raid.CanStartRaid()
    if A.Raid.CurrentRaid then return false end
    if tick() - A.Raid.LastRaidEnd < A.Raid.RaidCooldown then return false end
    if not A.Alive() then return false end
    local fragments = A.Raid.GetFragmentsNeeded()
    local raidType = A.Raid.GetOptimalRaid(A.Lv())
    if not raidType then return false end
    local cost = A.Raid.RaidCosts[raidType] or 1000
    return fragments >= cost
end

function A.Raid.GetOptimalRaid(level)
    level = level or A.Lv() or 1
    local raidLevels = {
        {name = "Flame", minLevel = 800},
        {name = "Ice", minLevel = 850},
        {name = "Quake", minLevel = 900},
        {name = "Light", minLevel = 950},
        {name = "Dark", minLevel = 1000},
        {name = "String", minLevel = 1050},
        {name = "Magma", minLevel = 1100},
        {name = "Human", minLevel = 1150},
        {name = "Cyborg", minLevel = 1200},
        {name = "Buddha", minLevel = 1300},
        {name = "Angel", minLevel = 1400},
        {name = "Leopard", minLevel = 1500},
        {name = "Mammoth", minLevel = 1600},
        {name = "T-Rex", minLevel = 1700},
        {name = "Dough", minLevel = 1800},
        {name = "Kitsune", minLevel = 2000},
    }
    local best = nil
    local bestFit = -1
    for _, raid in ipairs(raidLevels) do
        if level >= raid.minLevel then
            local fit = level - raid.minLevel
            if fit >= 0 and (bestFit < 0 or fit < bestFit) then
                bestFit = fit
                best = raid.name
            end
        end
    end
    if not best then
        best = raidLevels[1].name
    end
    return best
end

function A.Raid.SafeRaid()
    local enemies = A.Raid.GetRaidEnemies()
    for _, enemy in ipairs(enemies) do
        if not A.Raid.Active then break end
        local myHum = A.Hum()
        if myHum and myHum.Health < myHum.MaxHealth * 0.4 then
            A.Notify("Raid", "Low HP in safe mode, retreating", 2)
            task.wait(5)
            if A.Hum() and A.Hum().Health < A.Hum().MaxHealth * 0.3 then
                return
            end
        end
        if enemy.model and enemy.model:FindFirstChild("HumanoidRootPart") then
            A.TpTo(enemy.model.HumanoidRootPart.Position, 30)
            task.wait(0.3)
            A.Attack(enemy.model, {"Z", "X", "C"}, 0.3)
            task.wait(0.2)
        end
    end
end

function A.Raid.SpeedRaid()
    local enemies = A.Raid.GetRaidEnemies()
    for _, enemy in ipairs(enemies) do
        if not A.Raid.Active then break end
        if enemy.model and enemy.model:FindFirstChild("HumanoidRootPart") then
            A.CF.CFrame = CFrame.new(enemy.model.HumanoidRootPart.Position + A.V3(0, 10, 0))
            task.wait(0.1)
            A.SuperAttack(enemy.model)
            task.wait(0.1)
        end
    end
end

function A.Raid.AFKRaid()
    A.Raid.AFKMode = true
    A.Raid.SafeMode = false
    A.Raid.SpeedMode = false
    A.Raid.AutoStart = true
    while A.Raid.Active and A.Raid.AFKMode do
        if A.Raid.CurrentRaid then
            A.Raid.CompleteRaid()
        else
            if A.Raid.CanStartRaid() then
                local raidType = A.Raid.GetOptimalRaid(A.Lv())
                if raidType then
                    A.Raid.StartRaid(raidType)
                end
            else
                A.Raid.WaitRaidCooldown()
            end
        end
        task.sleep(2)
    end
end

function A.Raid.GetRaidStats()
    local uptime = tick() - A.Raid.SessionStart
    local hours = math.floor(uptime / 3600)
    local mins = math.floor((uptime % 3600) / 60)
    local secs = math.floor(uptime % 60)
    return {
        active = A.Raid.Active,
        currentRaid = A.Raid.CurrentRaid or "None",
        raidsCompleted = A.Raid.RaidsCompleted,
        fragmentsEarned = A.Raid.FragmentEarned,
        totalKills = A.Raid.TotalKills,
        uptime = string.format("%dh %dm %ds", hours, mins, secs),
        raidsPerHour = uptime > 0 and math.floor(A.Raid.RaidsCompleted / (uptime / 3600)) or 0,
        afkMode = A.Raid.AFKMode,
        speedMode = A.Raid.SpeedMode,
        safeMode = A.Raid.SafeMode,
        raidLog = A.Raid.RaidLog,
    }
end

function A.Raid.GetRaidHistory()
    return A.Raid.RaidLog
end

function A.Raid.GetAwakeningMaterials(type)
    if not type then return {} end
    local materials = {}
    local rewards = A.Raid.RaidRewards[type]
    if rewards then
        for _, reward in ipairs(rewards) do
            table.insert(materials, {name = reward, type = "Raid Reward"})
        end
    end
    return materials
end

function A.Raid.Start()
    if A.Raid.Active then
        A.Notify("Raid", "Already running!", 2)
        return
    end
    A.Raid.Active = true
    A.Raid.SessionStart = tick()
    A.Raid.RaidsCompleted = 0
    A.Raid.FragmentEarned = 0
    A.Raid.TotalKills = 0
    A.Notify("Raid", "Raid system started!", 3)
    task.spawn(A.Raid.MainLoop)
end

function A.Raid.Stop()
    A.Raid.Active = false
    A.Raid.CurrentRaid = nil
    A.Raid.AFKMode = false
    A.Notify("Raid", "Raid system stopped. Completed: " .. A.Raid.RaidsCompleted, 3)
end

A.Register("raid", A.Raid)
