--[[
    Apex Hub v13.0 - Cursed Dual Katana Module
    Automated CDK acquisition with Yama, Tushita, and CDK quest steps
]]

local A = _G.Apex
if not A then return end

A.CDK = {}
A.CDK.Active = false
A.CDK.Progress = {Yama = 0, Tushita = 0, CDK = 0}
A.CDK.SessionStart = tick()
A.CDK.CurrentStep = "none"
A.CDK.EliteKills = 0
A.CDK.RequiredEliteKills = 30
A.CDK.YamaQuestActive = false
A.CDK.TushitaQuestActive = false
A.CDK.CDKQuestActive = false
A.CDK.LastQuestCheck = 0
A.CDK.QuestCheckInterval = 10
A.CDK.LastEliteSpawn = 0
A.CDK.EliteSpawnCheckInterval = 30
A.CDK.YamaComplete = false
A.CDK.TushitaComplete = false
A.CDK.CDKComplete = false
A.CDK.RetryCount = 0
A.CDK.MaxRetries = 5
A.CDK.CDKLog = {}
A.CDK.StepsCompleted = 0

A.CDK.YamaRequirements = {
    {step = "Elite Kills", required = 30, description = "Kill 30 Elite Hunters"},
    {step = "Yama Altar", required = 1, description = "Click Yama Altar 30 times"},
    {step = "Yama Sword", required = 1, description = "Claim Yama Sword"},
}

A.CDK.TushitaRequirements = {
    {step = "Tushita Quest 1", required = 1, description = "Complete Isolated Cargo quest"},
    {step = "Tushita Quest 2", required = 1, description = "Complete Fire study quest"},
    {step = "Tushita Quest 3", required = 1, description = "Complete Sad boss quest"},
    {step = "Tushita Quest 4", required = 1, description = "Complete Walk the plank quest"},
    {step = "Tushita Quest 5", required = 1, description = "Complete Peace quest"},
    {step = "Tushita Sword", required = 1, description = "Claim Tushita Sword"},
}

A.CDK.CDKRequirements = {
    {step = "Yama Sword", required = 1, description = "Obtain Yama"},
    {step = "Tushita Sword", required = 1, description = "Obtain Tushita"},
    {step = "CDK Puzzle", required = 1, description = "Complete CDK puzzle"},
    {step = "CDK Trial", required = 1, description = "Complete CDK trial raid"},
    {step = "CDK Boss", required = 1, description = "Defeat CDK boss"},
    {step = "CDK Sword", required = 1, description = "Claim Cursed Dual Katana"},
}

A.CDK.EliteHunterLocations = {
    A.V3(970, 430, -6810),
    A.V3(1200, 400, -5800),
    A.V3(-5020, 300, -2870),
    A.V3(-4660, 300, -2300),
    A.V3(-2180, 30, -6200),
}

A.CDK.YamaAltarPosition = A.V3(-4780, 300, -2600)
A.CDK.TushitaStartPosition = A.V3(5320, 600, -280)
A.CDK.CDKPuzzlePosition = A.V3(-10335, 410, -3750)
A.CDK.CDKRaidPosition = A.V3(-10335, 410, -3750)
A.CDK.CDKBossPosition = A.V3(-10335, 410, -3750)

function A.CDK.MainLoop()
    while A.CDK.Active do
        if not A.Alive() then
            A.Notify("CDK", "Waiting for respawn...", 3)
            task.wait(3)
        else
            if A.CDK.CDKComplete then
                A.Notify("CDK", "CDK already obtained!", 5)
                A.CDK.Stop()
                break
            end
            if not A.CDK.YamaComplete then
                A.CDK.FarmYama()
            elseif not A.CDK.TushitaComplete then
                A.CDK.FarmTushita()
            else
                A.CDK.FarmCDK()
            end
        end
        task.wait(1)
    end
end

function A.CDK.GetProgress()
    local yamaProgress = 0
    if A.CDK.YamaComplete then
        yamaProgress = 100
    else
        local kills = A.CDK.GetEliteKillCount()
        yamaProgress = math.floor((kills / A.CDK.RequiredEliteKills) * 80)
    end
    local tushitaProgress = 0
    if A.CDK.TushitaComplete then
        tushitaProgress = 100
    else
        tushitaProgress = A.CDK.StepsCompleted * 15
    end
    local cdkProgress = 0
    if A.CDK.CDKComplete then
        cdkProgress = 100
    else
        if A.CDK.YamaComplete and A.CDK.TushitaComplete then
            cdkProgress = 50
        end
    end
    A.CDK.Progress = {Yama = yamaProgress, Tushita = tushitaProgress, CDK = cdkProgress}
    return A.CDK.Progress
end

function A.CDK.GetRequirements()
    local reqs = {
        Yama = A.CDK.YamaRequirements,
        Tushita = A.CDK.TushitaRequirements,
        CDK = A.CDK.CDKRequirements,
    }
    local current = A.CDK.CurrentStep
    if current == "Yama" then
        return reqs.Yama
    elseif current == "Tushita" then
        return reqs.Tushita
    elseif current == "CDK" then
        return reqs.CDK
    end
    return reqs
end

function A.CDK.FarmYama()
    if A.CDK.YamaComplete then return true end
    A.CDK.CurrentStep = "Yama"
    A.Notify("CDK", "Farming Yama Sword...", 4)
    local eliteKills = A.CDK.GetEliteKillCount()
    if eliteKills < A.CDK.RequiredEliteKills then
        A.CDK.KillEliteHunter()
    else
        A.Notify("CDK", "Elite kills complete, going to altar...", 4)
        A.CDK.AcceptYamaQuest()
    end
    return false
end

function A.CDK.FarmTushita()
    if A.CDK.TushitaComplete then return true end
    A.CDK.CurrentStep = "Tushita"
    A.Notify("CDK", "Farming Tushita Sword...", 4)
    A.CDK.AcceptTushitaQuest()
    A.CDK.FarmTushitaQuest()
    return false
end

function A.CDK.FarmCDK()
    if A.CDK.CDKComplete then return true end
    A.CDK.CurrentStep = "CDK"
    A.Notify("CDK", "Farming Cursed Dual Katana...", 4)
    local hasYama = A.CDK.YamaComplete
    local hasTushita = A.CDK.TushitaComplete
    if hasYama and hasTushita then
        A.CDK.CDKPuzzle()
        A.CDK.CDKRaid()
        A.CDK.CDKBoss()
    else
        A.Notify("CDK", "Need both Yama and Tushita first!", 3)
    end
    return false
end

function A.CDK.AcceptYamaQuest()
    A.CDK.YamaQuestActive = true
    A.TpTo(A.CDK.YamaAltarPosition, 30)
    task.wait(2)
    local clicks = 0
    while clicks < 30 and A.CDK.Active do
        pcall(function()
            A.CommF("ClickYamaAltar")
        end)
        clicks = clicks + 1
        A.Notify("CDK", "Altar click " .. clicks .. "/30", 2)
        task.wait(0.5)
    end
    if clicks >= 30 then
        A.CDK.YamaComplete = true
        A.CDK.Progress.Yama = 100
        A.CDK.StepsCompleted = A.CDK.StepsCompleted + 1
        A.Notify("CDK", "Yama Sword obtained!", 5)
        table.insert(A.CDK.CDKLog, {
            step = "Yama Complete",
            time = os.date("%Y-%m-%d %H:%M:%S"),
        })
    end
    A.CDK.YamaQuestActive = false
end

function A.CDK.AcceptTushitaQuest()
    A.CDK.TushitaQuestActive = true
    A.TpTo(A.CDK.TushitaStartPosition, 30)
    task.wait(2)
    pcall(function()
        A.CommF("AcceptTushitaQuest")
    end)
    A.Notify("CDK", "Tushita quest accepted", 3)
end

function A.CDK.FarmYamaQuest()
    A.CDK.AcceptYamaQuest()
end

function A.CDK.FarmTushitaQuest()
    local questSteps = {
        "Isolated Cargo",
        "Fire Study",
        "Sad Boss",
        "Walk the Plank",
        "Peace",
    }
    for i, step in ipairs(questSteps) do
        if not A.CDK.Active then break end
        A.Notify("CDK", "Tushita Step " .. i .. "/5: " .. step, 4)
        pcall(function()
            A.CommF("CompleteTushitaStep", i)
        end)
        task.wait(2)
        A.CDK.StepsCompleted = i
        table.insert(A.CDK.CDKLog, {
            step = "Tushita " .. step,
            time = os.date("%Y-%m-%d %H:%M:%S"),
        })
    end
    pcall(function()
        A.CommF("ClaimTushita")
    end)
    A.CDK.TushitaComplete = true
    A.CDK.Progress.Tushita = 100
    A.CDK.StepsCompleted = A.CDK.StepsCompleted + 1
    A.Notify("CDK", "Tushita Sword obtained!", 5)
    table.insert(A.CDK.CDKLog, {
        step = "Tushita Complete",
        time = os.date("%Y-%m-%d %H:%M:%S"),
    })
    A.CDK.TushitaQuestActive = false
end

function A.CDK.KillEliteHunter()
    if tick() - A.CDK.LastEliteSpawn < A.CDK.EliteSpawnCheckInterval then
        A.Notify("CDK", "Waiting for elite spawn...", 2)
        task.wait(5)
        return false
    end
    A.CDK.LastEliteSpawn = tick()
    local eliteKills = A.CDK.GetEliteKillCount()
    if eliteKills >= A.CDK.RequiredEliteKills then
        return true
    end
    local target = A.CDK.FindEliteHunter()
    if target then
        A.TpTo(target.HumanoidRootPart.Position, 25)
        task.wait(0.3)
        local hum = target:FindFirstChildOfClass("Humanoid")
        while hum and hum.Health > 0 and A.CDK.Active do
            if not A.Alive() then
                task.wait(3)
                break
            end
            A.SuperAttack(target)
            task.wait(0.1)
        end
        if not hum or hum.Health <= 0 then
            A.CDK.EliteKills = A.CDK.EliteKills + 1
            A.Notify("CDK", "Elite killed! " .. A.CDK.EliteKills .. "/" .. A.CDK.RequiredEliteKills, 3)
            return true
        end
    else
        for _, pos in ipairs(A.CDK.EliteHunterLocations) do
            if not A.CDK.Active then break end
            A.TpTo(pos, 30)
            task.wait(3)
            local found = A.CDK.FindEliteHunter()
            if found then
                return A.CDK.KillEliteHunter()
            end
        end
    end
    return false
end

function A.CDK.FindEliteHunter()
    local npcFolder = A.G:FindFirstChild("NPCs") or A.G:FindFirstChild("Enemys")
    if not npcFolder then return nil end
    local eliteNames = {"Elite Hunter", "Elite", "Diablo", "Deandre", "Urban"}
    for _, npc in ipairs(npcFolder:GetChildren()) do
        if npc:IsA("Model") then
            local hum = npc:FindFirstChildOfClass("Humanoid")
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                for _, name in ipairs(eliteNames) do
                    if npc.Name == name then
                        return npc
                    end
                end
            end
        end
    end
    return nil
end

function A.CDK.GetEliteKillCount()
    local kills = A.CDK.EliteKills
    local player = A.LP
    if player then
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local eliteStat = leaderstats:FindFirstChild("EliteKills") or leaderstats:FindFirstChild("Elite Hunter")
            if eliteStat and eliteStat:IsA("ValueBase") then
                kills = math.max(kills, eliteStat.Value)
            end
        end
    end
    return kills
end

function A.CDK.GetCDKStep()
    if A.CDK.CDKComplete then return "Complete" end
    if not A.CDK.YamaComplete then return "Yama" end
    if not A.CDK.TushitaComplete then return "Tushita" end
    return "CDK"
end

function A.CDK.CDKPuzzle()
    A.Notify("CDK", "Starting CDK Puzzle...", 4)
    A.TpTo(A.CDK.CDKPuzzlePosition, 30)
    task.wait(2)
    pcall(function()
        A.CommF("StartCDKPuzzle")
    end)
    local puzzleParts = {"Part1", "Part2", "Part3", "Part4"}
    for _, part in ipairs(puzzleParts) do
        if not A.CDK.Active then break end
        pcall(function()
            A.CommF("CDKPuzzleStep", part)
        end)
        A.Notify("CDK", "Puzzle step: " .. part, 2)
        task.wait(2)
    end
    table.insert(A.CDK.CDKLog, {
        step = "CDK Puzzle Complete",
        time = os.date("%Y-%m-%d %H:%M:%S"),
    })
    A.Notify("CDK", "CDK Puzzle completed!", 4)
end

function A.CDK.CDKRaid()
    A.Notify("CDK", "Starting CDK Raid...", 4)
    A.TpTo(A.CDK.CDKRaidPosition, 30)
    task.wait(2)
    pcall(function()
        A.CommF("StartCDKRaid")
    end)
    local raidTime = 0
    local maxRaidTime = 300
    while raidTime < maxRaidTime and A.CDK.Active do
        if not A.Alive() then
            task.wait(3)
        else
            local enemies = A.CDK.GetCDKRaidEnemies()
            if #enemies == 0 then
                A.Notify("CDK", "Raid room cleared!", 3)
                task.wait(2)
                raidTime = raidTime + 2
            else
                for _, enemy in ipairs(enemies) do
                    if not A.CDK.Active then break end
                    if enemy:FindFirstChild("HumanoidRootPart") then
                        A.TpTo(enemy.HumanoidRootPart.Position, 25)
                        task.wait(0.2)
                        A.SuperAttack(enemy)
                        task.wait(0.1)
                    end
                end
            end
        end
        task.wait(1)
        raidTime = raidTime + 1
    end
    table.insert(A.CDK.CDKLog, {
        step = "CDK Raid Complete",
        time = os.date("%Y-%m-%d %H:%M:%S"),
    })
    A.Notify("CDK", "CDK Raid completed!", 4)
end

function A.CDK.GetCDKRaidEnemies()
    local enemies = {}
    local npcFolder = A.G:FindFirstChild("NPCs") or A.G:FindFirstChild("Enemys")
    if npcFolder then
        for _, npc in ipairs(npcFolder:GetChildren()) do
            if npc:IsA("Model") then
                local hum = npc:FindFirstChildOfClass("Humanoid")
                local hrp = npc:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local dist = (hrp.Position - A.HRP().Position).Magnitude
                    if dist < 200 then
                        table.insert(enemies, npc)
                    end
                end
            end
        end
    end
    return enemies
end

function A.CDK.CDKBoss()
    A.Notify("CDK", "Starting CDK Boss fight...", 4)
    A.TpTo(A.CDK.CDKBossPosition, 30)
    task.wait(2)
    local boss = nil
    local npcFolder = A.G:FindFirstChild("NPCs") or A.G:FindFirstChild("Enemys")
    if npcFolder then
        for _, npc in ipairs(npcFolder:GetChildren()) do
            if npc:IsA("Model") then
                local hum = npc:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local level = npc:FindFirstChild("Level") and npc.Level.Value or 0
                    if level >= 2000 then
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
        local fightStart = tick()
        while hum and hum.Health > 0 and A.CDK.Active do
            if tick() - fightStart > 180 then
                A.Notify("CDK", "Boss fight timeout", 3)
                break
            end
            if not A.Alive() then
                task.wait(3)
                if not A.Alive() then break end
            end
            A.SuperAttack(boss)
            task.wait(0.1)
        end
        if not hum or hum.Health <= 0 then
            A.CDK.CDKComplete = true
            A.CDK.Progress.CDK = 100
            A.Notify("CDK", "CURSED DUAL KATANA OBTAINED!", 8)
            table.insert(A.CDK.CDKLog, {
                step = "CDK Complete",
                time = os.date("%Y-%m-%d %H:%M:%S"),
            })
        end
    else
        A.Notify("CDK", "CDK Boss not found", 3)
    end
end

function A.CDK.IsComplete()
    return A.CDK.CDKComplete
end

function A.CDK.GetCDKRewards()
    return {
        name = "Cursed Dual Katana",
        type = "Sword",
        rarity = "Legendary",
        damage = "High",
        abilities = {"Cursed Slashes", "Heavenly Piercer", "Dual Cursed Storm"},
        requirements = {
            "Yama Sword",
            "Tushita Sword",
            "CDK Puzzle",
            "CDK Trial",
            "CDK Boss",
        },
    }
end

function A.CDK.GetEstimatedTime()
    local progress = A.CDK.GetProgress()
    local totalProgress = (progress.Yama + progress.Tushita + progress.CDK) / 3
    if totalProgress >= 100 then return 0 end
    local elapsed = tick() - A.CDK.SessionStart
    if totalProgress <= 0 then
        return 7200
    end
    local rate = totalProgress / elapsed
    local remaining = (100 - totalProgress) / rate
    return remaining
end

function A.CDK.AutoCDK()
    A.Notify("CDK", "Starting full CDK automation...", 5)
    while A.CDK.Active do
        if A.CDK.CDKComplete then
            A.Notify("CDK", "CDK obtained! Stopping.", 5)
            A.CDK.Stop()
            break
        end
        if not A.Alive() then
            A.Notify("CDK", "Waiting for respawn...", 3)
            task.wait(3)
        else
            local step = A.CDK.GetCDKStep()
            if step == "Yama" then
                A.CDK.FarmYama()
            elseif step == "Tushita" then
                A.CDK.FarmTushita()
            elseif step == "CDK" then
                A.CDK.FarmCDK()
            end
            task.sleep(1)
        end
    end
end

function A.CDK.GetCDKStats()
    local uptime = tick() - A.CDK.SessionStart
    local hours = math.floor(uptime / 3600)
    local mins = math.floor((uptime % 3600) / 60)
    local secs = math.floor(uptime % 60)
    local estTime = A.CDK.GetEstimatedTime()
    local estHours = math.floor(estTime / 3600)
    local estMins = math.floor((estTime % 3600) / 60)
    return {
        active = A.CDK.Active,
        currentStep = A.CDK.GetCDKStep(),
        progress = A.CDK.GetProgress(),
        yamaComplete = A.CDK.YamaComplete,
        tushitaComplete = A.CDK.TushitaComplete,
        cdkComplete = A.CDK.CDKComplete,
        eliteKills = A.CDK.GetEliteKillCount(),
        requiredEliteKills = A.CDK.RequiredEliteKills,
        stepsCompleted = A.CDK.StepsCompleted,
        uptime = string.format("%dh %dm %ds", hours, mins, secs),
        estimatedTime = string.format("%dh %dm", estHours, estMins),
        log = A.CDK.CDKLog,
    }
end

function A.CDK.Start()
    if A.CDK.Active then
        A.Notify("CDK", "Already running!", 2)
        return
    end
    A.CDK.Active = true
    A.CDK.SessionStart = tick()
    A.CDK.EliteKills = 0
    A.CDK.StepsCompleted = 0
    A.Notify("CDK", "CDK acquisition started!", 4)
    task.spawn(A.CDK.AutoCDK)
end

function A.CDK.Stop()
    A.CDK.Active = false
    A.CDK.YamaQuestActive = false
    A.CDK.TushitaQuestActive = false
    A.CDK.CDKQuestActive = false
    local progress = A.CDK.GetProgress()
    A.Notify("CDK", string.format("Stopped. Yama: %d%% Tushita: %d%% CDK: %d%%",
        progress.Yama, progress.Tushita, progress.CDK), 4)
end

function A.CDK.ShowProgress()
    A.CDK.GetProgress()
end

A.Register("cdk", A.CDK)
