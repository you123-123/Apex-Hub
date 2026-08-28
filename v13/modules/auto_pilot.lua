local A = _G.Apex
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local LP = A.LP
local V3 = A.V3
local CF = A.CF

A.AutoPilot = {}
local AP = A.AutoPilot

AP.Active = false
AP.Phase = 1
AP.StartTime = 0
AP.Stats = {
    TotalXP = 0,
    QuestsCompleted = 0,
    EnemiesKilled = 0,
    Deaths = 0,
    BossKills = 0,
    RaidsCompleted = 0,
    SeaEvents = 0,
    ItemsCollected = 0,
    FruitsFound = 0,
    MaterialsGained = 0,
    CurrentLevel = 0,
    StartTime = 0,
    LastLevel = 0,
    XPPerMinute = 0,
    LevelsPerHour = 0,
    TimeInPhase = 0,
    PhaseStartTime = 0,
    TotalPlayTime = 0
}
AP.ProgressHistory = {}
AP.Milestones = {
    Level100 = false, Level250 = false, Level500 = false, Level700 = false,
    Level1000 = false, Level1300 = false, Level1500 = false, Level1800 = false,
    Level2200 = false, Level2550 = false,
    FirstSword = false, FirstFruit = false, FirstHaki = false,
    Sea2Unlocked = false, Sea3Unlocked = false,
    FirstRaid = false, FirstBoss = false,
    MaxLevel = false
}
AP.LastQuestAccept = 0
AP.QuestCooldown = 3
AP.StuckCounter = 0
AP.LastPosition = nil
AP.LastStuckCheck = 0
AP.DeathRecoveryActive = false
AP.PhaseTransitionPending = false
AP.CurrentQuestTarget = nil
AP.FarmingActive = false
AP.InventoryFull = false
AP.HakiLevel = 0
AP.RaceProgress = {}
AP.AwakeningProgress = {}
AP.TradingCooldown = 0
AP.BountyTarget = 0

AP.Phases = {
    Phase1 = {
        Name = "Beginner",
        MinLevel = 1,
        MaxLevel = 250,
        Sea = 1,
        Zones = {"StarterIsland", "MarineBase"},
        Quests = {"BanditQuest", "MonkeyQuest", "PirateQuest"},
        Bosses = {},
        Items = {"Cutlass", "Katana"},
        Fruits = {},
        Description = "Starter Island farming - learn basics"
    },
    Phase2 = {
        Name = "Intermediate",
        MinLevel = 250,
        MaxLevel = 500,
        Sea = 1,
        Zones = {"Desert", "Frozen"},
        Quests = {"DesertQuest", "SnowQuest"},
        Bosses = {"Diamond", "Yeti"},
        Items = {"Iron Mace", "Trident"},
        Fruits = {},
        Description = "Mid-sea progression - unlock new areas"
    },
    Phase3 = {
        Name = "Advanced",
        MinLevel = 500,
        MaxLevel = 700,
        Sea = 1,
        Zones = {"MarineFortress", "SkyIsland", "Prison", "Colosseum"},
        Quests = {"WardenQuest", "SkyQuest", "PrisonQuest"},
        Bosses = {"Warden", "Chief Warden", "Swan", "Saber Expert"},
        Items = {"Saber", "Pole", "Pole (2nd Form)"},
        Fruits = {},
        Description = "Late first sea - prepare for second sea"
    },
    Phase4 = {
        Name = "Sea2Early",
        MinLevel = 700,
        MaxLevel = 1000,
        Sea = 2,
        Zones = {"Kingdom", "Academy"},
        Quests = {"KingdomQuest", "AcademyQuest"},
        Bosses = {"Diamond", "Jeremy", "Greybeard"},
        Items = {"Gravity Blade", "Dragon Claw"},
        Fruits = {},
        Description = "Second sea beginning - new challenges"
    },
    Phase5 = {
        Name = "Sea2Mid",
        MinLevel = 1000,
        MaxLevel = 1300,
        Sea = 2,
        Zones = {"Usoapp", "Colosseum2", "GreenTorus"},
        Quests = {"CookieQuest", "ArenaQuest"},
        Bosses = {"Toga Warrior", "Thunder God", "Order"},
        Items = {"Yoru", "Shisui", "Saddi"},
        Fruits = {},
        Description = "Second sea mid-game - power spike"
    },
    Phase6 = {
        Name = "Sea2Late",
        MinLevel = 1300,
        MaxLevel = 1500,
        Sea = 2,
        Zones = {"GreenTorus", "HauntedCastle"},
        Quests = {"SoulReaperQuest", "VampireQuest"},
        Bosses = {"Soul Reaper", "Awakened Ice Admiral", "Cake Prince"},
        Items = {"Dark Step", "Electric", "Water Kung Fu"},
        Fruits = {},
        Description = "Late second sea - prepare for third sea"
    },
    Phase7 = {
        Name = "Sea3Early",
        MinLevel = 1500,
        MaxLevel = 1800,
        Sea = 3,
        Zones = {"FloatingTurtle", "Hydra"},
        Quests = {"TurtleQuest", "HydraQuest"},
        Bosses = {"Captain Elephant", "Beautiful Pirate"},
        Items = {"Canvanda", "Fox Lamp", "Spikey Trident"},
        Fruits = {},
        Description = "Third sea start - endgame begins"
    },
    Phase8 = {
        Name = "Sea3Mid",
        MinLevel = 1800,
        MaxLevel = 2200,
        Sea = 3,
        Zones = {"Hydra", "GreatTree"},
        Quests = {"KitsuneQuest", "GardenQuest"},
        Bosses = {"Kitsune", "Leviathan", "Rip Indra"},
        Items = {"CDK", "Dark Blade"},
        Fruits = {},
        Description = "Third sea mid - seeking ultimate power"
    },
    Phase9 = {
        Name = "Sea3Late",
        MinLevel = 2200,
        MaxLevel = 2550,
        Sea = 3,
        Zones = {"GreatTree", "TikiOutpost", "EndgameZone"},
        Quests = {"EndgameQuest"},
        Bosses = {"Dough King", "Terror Shark", "Leviathan", "Rip Indra"},
        Items = {"Godhuman", "Sanguine Art", "CDK", "Shadow Blade"},
        Fruits = {"Dragon", "Leopard", "Kitsune"},
        Description = "Endgame - absolute peak power"
    }
}

function AP.AcceptAndFarm()
    if not AP.Active then return end
    if not A.Alive() then return end
    local now = tick()
    if now - AP.LastQuestAccept < AP.QuestCooldown then return end
    local questData = AP.GetPhaseRequirements(AP.Phase)
    if questData and questData.Quests then
        for _, questName in pairs(questData.Quests) do
            local success = pcall(function()
                A.CommF("QuestAccept", questName)
            end)
            if success then
                AP.LastQuestAccept = now
                AP.Stats.QuestsCompleted = AP.Stats.QuestsCompleted + 1
                break
            end
        end
    end
    local target = A.FindTarget(250)
    if target then
        local targetChar = target.Character
        if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("Humanoid") and targetChar.Humanoid.Health > 0 then
            local dist = (targetChar.HumanoidRootPart.Position - A.GetPosition()).Magnitude
            if dist > 50 then
                A.TweenTo(targetChar.HumanoidRootPart.Position, 250)
            else
                A.SuperAttack(target)
                AP.Stats.EnemiesKilled = AP.Stats.EnemiesKilled + 1
            end
        end
    else
        AP.HandlePhase(AP.Phase)
    end
end

function AP.AutoStats()
    if not AP.Active then return end
    pcall(function()
        local statPoints = A.G:FindFirstChild("StatPoints") and A.G.StatPoints.Value or 0
        if statPoints > 0 then
            local phase = AP.Phases["Phase" .. AP.Phase]
            local mainStat = "Melee"
            if phase and phase.Sea >= 2 then
                mainStat = "Sword"
            end
            A.CommF("AddPoint", mainStat, statPoints)
            A.CommF("AddPoint", "Health", math.floor(statPoints * 0.2))
        end
    end)
end

function AP.AutoEquip()
    if not AP.Active then return end
    if not A.Alive() then return end
    local bestTool = nil
    local bestPower = 0
    local backpack = LP.Backpack:GetChildren()
    for _, tool in pairs(backpack) do
        if tool:IsA("Tool") then
            local power = 0
            local levelReq = tool:FindFirstChild("LevelReq") and tool.LevelReq.Value or 0
            if A.Lv() >= levelReq then
                power = levelReq
                local damage = tool:FindFirstChild("Damage") and tool.Damage.Value or 0
                power = power + damage * 0.1
            end
            if power > bestPower then
                bestPower = power
                bestTool = tool
            end
        end
    end
    if bestTool then
        local char = A.Char()
        if char then
            local currentTool = char:FindFirstChildOfClass("Tool")
            if not currentTool or currentTool ~= bestTool then
                if currentTool then
                    currentTool.Parent = LP.Backpack
                end
                bestTool.Parent = char
            end
        end
    end
end

function AP.AutoHaki()
    if not AP.Active then return end
    pcall(function()
        local myChar = A.Char()
        if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local hakiEnabled = myHRP:FindFirstChild("BusoHaki") or myHRP:FindFirstChild("Haki")
        if not hakiEnabled then
            A.CommF("Buso")
        end
    end)
end

function AP.AutoSkills()
    if not AP.Active then return end
    pcall(function()
        local skillPoints = A.G:FindFirstChild("SkillPoints") and A.G.SkillPoints.Value or 0
        if skillPoints > 0 then
            local fightingStyle = A.G:FindFirstChild("FightingStyle") and A.G.FightingStyle.Value or ""
            local sword = A.G:FindFirstChild("Sword") and A.G.Sword.Value or ""
            local gun = A.G:FindFirstChild("Gun") and A.G.Gun.Value or ""
            if fightingStyle ~= "" then
                A.CommF("BuyMuscle", fightingStyle)
            end
            if sword ~= "" then
                A.CommF("BuySword", sword)
            end
        end
    end)
end

function AP.TravelToSea(sea)
    if not AP.Active then return end
    local currentSea = A.Sea()
    if currentSea == sea then return end
    if currentSea == 1 and sea == 2 then
        local dockingPos = V3(-200, 10, -2500)
        A.TweenTo(dockingPos, 200)
        wait(1)
        A.CommF("TravelDressroza")
        wait(5)
    elseif currentSea == 2 and sea == 3 then
        local fountainPos = V3(0, 10, -2000)
        A.TweenTo(fountainPos, 200)
        wait(1)
        A.CommF("TravelZou")
        wait(5)
    elseif currentSea == 2 and sea == 1 then
        local dockPos = V3(600, 10, -300)
        A.TweenTo(dockPos, 200)
        wait(1)
        A.CommF("TravelBack")
        wait(5)
    elseif currentSea == 3 and sea == 2 then
        local returnPos = V3(0, 10, 0)
        A.TweenTo(returnPos, 200)
        wait(1)
        A.CommF("TravelMarines")
        wait(5)
    end
end

function AP.HandlePhase(phase)
    if not AP.Active then return end
    local phaseData = AP.Phases["Phase" .. phase]
    if not phaseData then return end
    local currentSea = A.Sea()
    if currentSea ~= phaseData.Sea then
        AP.TravelToSea(phaseData.Sea)
        return
    end
    local myLv = A.Lv()
    if myLv < phaseData.MinLevel then
        AP.ProgressToNextPhase()
        return
    end
    if myLv > phaseData.MaxLevel then
        AP.ProgressToNextPhase()
        return
    end
    local zones = phaseData.Zones
    if zones and #zones > 0 then
        local zoneIndex = ((tick() / 60) % #zones) + 1
        local currentZone = zones[math.floor(zoneIndex)]
        if currentZone then
            local zonePos = AP.GetZonePosition(currentZone)
            if zonePos then
                A.TweenTo(zonePos, 200)
            end
        end
    end
    AP.AcceptAndFarm()
end

function AP.GetPhaseRequirements(phase)
    return AP.Phases["Phase" .. phase] or nil
end

function AP.CompletePhaseTasks(phase)
    if not AP.Active then return end
    local phaseData = AP.Phases["Phase" .. phase]
    if not phaseData then return end
    if phaseData.Bosses and #phaseData.Bosses > 0 then
        for _, bossName in pairs(phaseData.Bosses) do
            if not AP.Active then break end
            local boss = AP.FindBoss(bossName)
            if boss then
                AP.FightBoss(boss)
            end
        end
    end
    for _, quest in pairs(phaseData.Quests or {}) do
        if not AP.Active then break end
        pcall(function()
            A.CommF("QuestAccept", quest)
        end)
        wait(0.5)
        local attempts = 0
        while AP.Active and attempts < 100 do
            local target = A.FindTarget(200)
            if target then
                A.SuperAttack(target)
            else
                break
            end
            attempts = attempts + 1
            wait(0.1)
        end
    end
end

function AP.ProgressToNextPhase()
    AP.PhaseTransitionPending = true
    local nextPhase = AP.Phase + 1
    if nextPhase > 9 then
        A.Notify("Auto Pilot", "Maximum level reached! All phases complete!", 5)
        AP.Stop()
        return
    end
    local nextPhaseData = AP.Phases["Phase" .. nextPhase]
    if not nextPhaseData then return end
    A.Notify("Auto Pilot", "Advancing to Phase " .. nextPhase .. ": " .. nextPhaseData.Name, 3)
    AP.Phase = nextPhase
    AP.Stats.PhaseStartTime = tick()
    if nextPhaseData.Sea ~= A.Sea() then
        AP.TravelToSea(nextPhaseData.Sea)
    end
    AP.PhaseTransitionPending = false
end

function AP.GetProgress()
    local totalLevels = 2550
    local currentLv = A.Lv()
    local percentage = (currentLv / totalLevels) * 100
    local phaseProgress = 0
    local phaseData = AP.Phases["Phase" .. AP.Phase]
    if phaseData then
        local phaseRange = phaseData.MaxLevel - phaseData.MinLevel
        local phaseCurrent = currentLv - phaseData.MinLevel
        phaseProgress = math.clamp(phaseCurrent / math.max(phaseRange, 1) * 100, 0, 100)
    end
    return {
        Overall = percentage,
        Phase = phaseProgress,
        PhaseNumber = AP.Phase,
        PhaseName = phaseData and phaseData.Name or "Unknown",
        Level = currentLv,
        MaxLevel = 2550,
        ETA = AP.GetETA()
    }
end

function AP.UpdateProgress()
    local currentLv = A.Lv()
    local elapsed = tick() - AP.StartTime
    AP.Stats.CurrentLevel = currentLv
    AP.Stats.TotalPlayTime = elapsed
    if elapsed > 0 then
        AP.Stats.LevelsPerHour = (currentLv - AP.Stats.LastLevel) / (elapsed / 3600)
    end
    local phaseData = AP.Phases["Phase" .. AP.Phase]
    if phaseData and currentLv >= phaseData.MaxLevel then
        AP.ProgressToNextPhase()
    end
    table.insert(AP.ProgressHistory, {
        Time = tick(),
        Level = currentLv,
        Phase = AP.Phase,
        XP = A.G:FindFirstChild("Exp") and A.G.Exp.Value or 0
    })
    if #AP.ProgressHistory > 200 then
        table.remove(AP.ProgressHistory, 1)
    end
    AP.CheckMilestones()
end

function AP.GetETA()
    local currentLv = A.Lv()
    local remaining = 2550 - currentLv
    if remaining <= 0 then return "Complete" end
    local elapsed = tick() - AP.StartTime
    if elapsed < 60 then return "Calculating..." end
    local levelsPerSecond = (currentLv - AP.Stats.LastLevel) / math.max(elapsed, 1)
    if levelsPerSecond <= 0 then return "Unknown" end
    local secondsLeft = remaining / levelsPerSecond
    local hours = math.floor(secondsLeft / 3600)
    local minutes = math.floor((secondsLeft % 3600) / 60)
    if hours > 0 then
        return string.format("%dh %dm", hours, minutes)
    else
        return string.format("%dm", minutes)
    end
end

function AP.UpdateProgressHistory()
    local currentLv = A.Lv()
    local currentXP = A.G:FindFirstChild("Exp") and A.G.Exp.Value or 0
    local elapsed = tick() - AP.StartTime
    if elapsed > 0 then
        AP.Stats.XPPerMinute = currentXP / (elapsed / 60)
    end
    if #AP.ProgressHistory > 0 then
        local lastEntry = AP.ProgressHistory[#AP.ProgressHistory]
        if tick() - lastEntry.Time > 60 then
            table.insert(AP.ProgressHistory, {
                Time = tick(),
                Level = currentLv,
                XP = currentXP,
                Phase = AP.Phase
            })
        end
    end
end

function AP.CheckMilestones()
    local lv = A.Lv()
    local milestones = {
        {Key = "Level100", Level = 100, Name = "Level 100"},
        {Key = "Level250", Level = 250, Name = "Level 250"},
        {Key = "Level500", Level = 500, Name = "Level 500"},
        {Key = "Level700", Level = 700, Name = "Level 700 - Sea 2"},
        {Key = "Level1000", Level = 1000, Name = "Level 1000"},
        {Key = "Level1300", Level = 1300, Name = "Level 1300"},
        {Key = "Level1500", Level = 1500, Name = "Level 1500 - Sea 3"},
        {Key = "Level1800", Level = 1800, Name = "Level 1800"},
        {Key = "Level2200", Level = 2200, Name = "Level 2200"},
        {Key = "Level2550", Level = 2550, Name = "MAX LEVEL"}
    }
    for _, m in pairs(milestones) do
        if lv >= m.Level and not AP.Milestones[m.Key] then
            AP.Milestones[m.Key] = true
            A.Notify("MILESTONE", m.Name .. " reached!", 5)
        end
    end
    if AP.Milestones.Level2550 then
        AP.Milestones.MaxLevel = true
    end
end

function AP.HandleDeath()
    if not AP.Active then return end
    if AP.DeathRecoveryActive then return end
    AP.DeathRecoveryActive = true
    AP.Stats.Deaths = AP.Stats.Deaths + 1
    A.Notify("Auto Pilot", "Death detected - recovering...", 2)
    wait(3)
    local spawnAttempts = 0
    while AP.Active and not A.Alive() and spawnAttempts < 10 do
        wait(1)
        spawnAttempts = spawnAttempts + 1
    end
    if A.Alive() then
        wait(1)
        AP.AutoEquip()
        AP.AutoHaki()
    end
    AP.DeathRecoveryActive = false
end

function AP.HandleStuck()
    if not AP.Active then return end
    AP.StuckCounter = AP.StuckCounter + 1
    if AP.StuckCounter < 5 then return end
    AP.StuckCounter = 0
    A.Notify("Auto Pilot", "Stuck detected - attempting recovery", 2)
    local randomOffset = V3(math.random(-100, 100), 0, math.random(-100, 100))
    local newPos = A.GetPosition() + randomOffset
    A.TpTo(newPos, 200)
    wait(1)
    if not A.Alive() then
        AP.HandleDeath()
    end
    local phaseData = AP.Phases["Phase" .. AP.Phase]
    if phaseData and phaseData.Zones and #phaseData.Zones > 0 then
        local zone = phaseData.Zones[1]
        local zonePos = AP.GetZonePosition(zone)
        if zonePos then
            A.TweenTo(zonePos, 250)
        end
    end
end

function AP.HandleLowHealth()
    if not AP.Active then return end
    local health = A.Hum() and A.Hum().Health / math.max(A.Hum().MaxHealth, 1) or 1
    if health < 0.15 then
        local myHRP = A.HRP()
        if myHRP then
            local fleeDir = V3(math.random(-1, 1), 0, math.random(-1, 1)).Unit
            local fleePos = myHRP.Position + fleeDir * 60
            A.TpTo(fleePos, 200)
        end
        wait(2)
    end
end

function AP.HandleInventory()
    if not AP.Active then return end
    pcall(function()
        local inventory = LP.Backpack:GetChildren()
        if #inventory > 50 then
            AP.InventoryFull = true
            for _, item in pairs(inventory) do
                if item:IsA("Tool") then
                    local levelReq = item:FindFirstChild("LevelReq") and item.LevelReq.Value or 0
                    if A.Lv() > levelReq + 100 then
                        item:Destroy()
                    end
                end
            end
        else
            AP.InventoryFull = false
        end
    end)
end

function AP.HandleTrading()
    if not AP.Active then return end
    local now = tick()
    if now - AP.TradingCooldown < 60 then return end
    AP.TradingCooldown = now
    pcall(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP then
                local dist = (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or V3(9999,0,9999)) - A.GetPosition()
                if dist.Magnitude < 15 then
                    A.CommF("TradeRequest", player.Name)
                end
            end
        end
    end)
end

function AP.HandleBounty()
    if not AP.Active then return end
    pcall(function()
        local myBounty = A.G:FindFirstChild("Bounty") and A.G.Bounty.Value or 0
        AP.BountyTarget = myBounty
    end)
end

function AP.HandleMastery()
    if not AP.Active then return end
    pcall(function()
        local tools = LP.Backpack:GetChildren()
        for _, tool in pairs(tools) do
            if tool:IsA("Tool") then
                local mastery = tool:FindFirstChild("Mastery")
                if mastery and mastery.Value < 600 then
                    local char = A.Char()
                    if char then
                        tool.Parent = char
                        wait(0.1)
                    end
                end
            end
        end
    end)
end

function AP.HandleSeaEvents()
    if not AP.Active then return end
    if _G.Apex.AutoEvents and _G.Apex.AutoEvents.Active then return end
    pcall(function()
        if _G.Apex.AutoEvents then
            _G.Apex.AutoEvents.AutoAllEvents()
        end
    end)
end

function AP.HandleBossFights()
    if not AP.Active then return end
    local phaseData = AP.Phases["Phase" .. AP.Phase]
    if not phaseData or not phaseData.Bosses then return end
    for _, bossName in pairs(phaseData.Bosses) do
        if not AP.Active then break end
        local boss = AP.FindBoss(bossName)
        if boss then
            AP.FightBoss(boss)
        end
    end
end

function AP.HandleRaids()
    if not AP.Active then return end
    pcall(function()
        if _G.Apex.AutoEvents then
            _G.Apex.AutoEvents.AddToQueue("Raid", 6)
        end
    end)
end

function AP.HandleCDK()
    if not AP.Active then return end
    local myLv = A.Lv()
    if myLv < 2200 then return end
    pcall(function()
        A.CommF("CDKQuest")
    end)
end

function AP.HandleRace()
    if not AP.Active then return end
    pcall(function()
        local race = A.G:FindFirstChild("Race") and A.G.Race.Value or ""
        if race ~= "" then
            AP.RaceProgress[race] = AP.RaceProgress[race] or {Step = 1, Complete = false}
            local progress = AP.RaceProgress[race]
            if not progress.Complete then
                A.CommF("RaceAwakening", race, progress.Step)
            end
        end
    end)
end

function AP.HandleAwakening()
    if not AP.Active then return end
    pcall(function()
        local fruit = A.G:FindFirstChild("DevilFruit") and A.G.DevilFruit.Value or ""
        if fruit ~= "" then
            AP.AwakeningProgress[fruit] = AP.AwakeningProgress[fruit] or {Level = 0, MaxLevel = 4}
            local progress = AP.AwakeningProgress[fruit]
            if progress.Level < progress.MaxLevel then
                local raidType = fruit:gsub(" ", ""):lower()
                if _G.Apex.AutoEvents then
                    _G.Apex.AutoEvents.AddToQueue("Raid", 7)
                end
            end
        end
    end)
end

function AP.SmartNavigation(pos)
    if not pos then return end
    if not A.Alive() then return end
    local myHRP = A.HRP()
    if not myHRP then return end
    local dist = (pos - myHRP.Position).Magnitude
    if dist < 10 then return end
    local currentSea = A.Sea()
    local targetSea = 1
    if pos.Magnitude > 5000 then targetSea = 3
    elseif pos.Magnitude > 2000 then targetSea = 2
    end
    if currentSea ~= targetSea then
        AP.TravelToSea(targetSea)
        return
    end
    if dist > 500 then
        A.TweenTo(pos, 250)
    elseif dist > 100 then
        A.TweenTo(pos, 200)
    else
        A.TpTo(pos, 10)
    end
end

function AP.FindBoss(bossName)
    if not bossName then return nil end
    for _, npc in pairs(Workspace:GetDescendants()) do
        if npc:IsA("Model") and npc.Name:find(bossName) then
            if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 and npc:FindFirstChild("HumanoidRootPart") then
                return npc
            end
        end
    end
    return nil
end

function AP.FightBoss(boss)
    if not AP.Active or not boss then return end
    if not boss:FindFirstChild("HumanoidRootPart") or not boss:FindFirstChild("Humanoid") then return end
    local startTime = tick()
    local timeout = 300
    while AP.Active and (tick() - startTime < timeout) do
        if not A.Alive() then
            AP.HandleDeath()
            return
        end
        local hum = boss:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then
            AP.Stats.BossKills = AP.Stats.BossKills + 1
            return
        end
        local dist = (boss.HumanoidRootPart.Position - A.GetPosition()).Magnitude
        if dist > 50 then
            A.TweenTo(boss.HumanoidRootPart.Position, 250)
        else
            A.SuperAttack(nil)
        end
        wait(0.1)
    end
end

function AP.GetZonePosition(zoneName)
    local positions = {
        StarterIsland = V3(0, 10, 0),
        MarineBase = V3(500, 10, 200),
        Desert = V3(1000, 10, -500),
        Frozen = V3(-1500, 10, 800),
        MarineFortress = V3(800, 10, -1200),
        SkyIsland = V3(0, 400, 0),
        Prison = V3(-2000, 10, -500),
        Colosseum = V3(1200, 10, 1000),
        Kingdom = V3(0, 10, 0),
        Academy = V3(600, 10, 300),
        Usoapp = V3(-400, 10, -300),
        Colosseum2 = V3(900, 10, -200),
        GreenTorus = V3(-700, 10, 500),
        HauntedCastle = V3(1100, 10, 600),
        FloatingTurtle = V3(0, 10, 0),
        Hydra = V3(500, 10, -400),
        GreatTree = V3(-600, 10, 300),
        TikiOutpost = V3(800, 10, 700),
        EndgameZone = V3(-1000, 10, -800)
    }
    return positions[zoneName]
end

function AP.Phase1Farm()
    local target = A.FindTarget(200)
    if target then
        local tChar = target.Character
        if tChar and tChar:FindFirstChild("HumanoidRootPart") then
            local dist = (tChar.HumanoidRootPart.Position - A.GetPosition()).Magnitude
            if dist > 40 then
                A.TweenTo(tChar.HumanoidRootPart.Position, 200)
            else
                A.SuperAttack(target)
            end
        end
    else
        A.TweenTo(V3(0, 10, 0), 150)
    end
end

function AP.Phase2Farm()
    local target = A.FindTarget(200)
    if target then
        local tChar = target.Character
        if tChar and tChar:FindFirstChild("HumanoidRootPart") then
            local dist = (tChar.HumanoidRootPart.Position - A.GetPosition()).Magnitude
            if dist > 40 then
                A.TweenTo(tChar.HumanoidRootPart.Position, 200)
            else
                A.SuperAttack(target)
            end
        end
    else
        A.TweenTo(V3(1000, 10, -500), 200)
    end
end

function AP.Phase3Farm()
    local target = A.FindTarget(200)
    if target then
        local tChar = target.Character
        if tChar and tChar:FindFirstChild("HumanoidRootPart") then
            local dist = (tChar.HumanoidRootPart.Position - A.GetPosition()).Magnitude
            if dist > 40 then
                A.TweenTo(tChar.HumanoidRootPart.Position, 200)
            else
                A.SuperAttack(target)
            end
        end
    else
        A.TweenTo(V3(-2000, 10, -500), 200)
    end
end

function AP.Phase4Farm()
    local target = A.FindTarget(250)
    if target then
        local tChar = target.Character
        if tChar and tChar:FindFirstChild("HumanoidRootPart") then
            local dist = (tChar.HumanoidRootPart.Position - A.GetPosition()).Magnitude
            if dist > 50 then
                A.TweenTo(tChar.HumanoidRootPart.Position, 220)
            else
                A.SuperAttack(target)
            end
        end
    else
        A.TweenTo(V3(0, 10, 0), 200)
    end
end

function AP.Phase5Farm()
    local target = A.FindTarget(250)
    if target then
        local tChar = target.Character
        if tChar and tChar:FindFirstChild("HumanoidRootPart") then
            local dist = (tChar.HumanoidRootPart.Position - A.GetPosition()).Magnitude
            if dist > 50 then
                A.TweenTo(tChar.HumanoidRootPart.Position, 220)
            else
                A.SuperAttack(target)
            end
        end
    else
        A.TweenTo(V3(900, 10, -200), 200)
    end
end

function AP.Phase6Farm()
    local target = A.FindTarget(250)
    if target then
        local tChar = target.Character
        if tChar and tChar:FindFirstChild("HumanoidRootPart") then
            local dist = (tChar.HumanoidRootPart.Position - A.GetPosition()).Magnitude
            if dist > 50 then
                A.TweenTo(tChar.HumanoidRootPart.Position, 220)
            else
                A.SuperAttack(target)
            end
        end
    else
        A.TweenTo(V3(-700, 10, 500), 200)
    end
end

function AP.Phase7Farm()
    local target = A.FindTarget(300)
    if target then
        local tChar = target.Character
        if tChar and tChar:FindFirstChild("HumanoidRootPart") then
            local dist = (tChar.HumanoidRootPart.Position - A.GetPosition()).Magnitude
            if dist > 60 then
                A.TweenTo(tChar.HumanoidRootPart.Position, 250)
            else
                A.SuperAttack(target)
            end
        end
    else
        A.TweenTo(V3(0, 10, 0), 250)
    end
end

function AP.Phase8Farm()
    local target = A.FindTarget(300)
    if target then
        local tChar = target.Character
        if tChar and tChar:FindFirstChild("HumanoidRootPart") then
            local dist = (tChar.HumanoidRootPart.Position - A.GetPosition()).Magnitude
            if dist > 60 then
                A.TweenTo(tChar.HumanoidRootPart.Position, 250)
            else
                A.SuperAttack(target)
            end
        end
    else
        A.TweenTo(V3(500, 10, -400), 250)
    end
end

function AP.Phase9Farm()
    local target = A.FindTarget(300)
    if target then
        local tChar = target.Character
        if tChar and tChar:FindFirstChild("HumanoidRootPart") then
            local dist = (tChar.HumanoidRootPart.Position - A.GetPosition()).Magnitude
            if dist > 60 then
                A.TweenTo(tChar.HumanoidRootPart.Position, 250)
            else
                A.SuperAttack(target)
            end
        end
    else
        A.TweenTo(V3(-1000, 10, -800), 250)
    end
end

function AP.GetAutoPilotStats()
    local elapsed = tick() - AP.StartTime
    local minutes = math.max(elapsed / 60, 0.01)
    local hours = math.max(elapsed / 3600, 0.01)
    local currentLv = A.Lv()
    return {
        Active = AP.Active,
        Phase = AP.Phase,
        PhaseName = AP.Phases["Phase" .. AP.Phase] and AP.Phases["Phase" .. AP.Phase].Name or "Unknown",
        Level = currentLv,
        MaxLevel = 2550,
        OverallProgress = string.format("%.1f%%", (currentLv / 2550) * 100),
        Duration = string.format("%.1f hrs", hours),
        LevelsPerHour = string.format("%.1f", AP.Stats.LevelsPerHour),
        TotalKills = AP.Stats.EnemiesKilled,
        KillsPerHour = string.format("%.0f", AP.Stats.EnemiesKilled / math.max(hours, 0.01)),
        QuestsCompleted = AP.Stats.QuestsCompleted,
        BossKills = AP.Stats.BossKills,
        Deaths = AP.Stats.Deaths,
        RaidsCompleted = AP.Stats.RaidsCompleted,
        SeaEvents = AP.Stats.SeaEvents,
        ItemsCollected = AP.Stats.ItemsCollected,
        FruitsFound = AP.Stats.FruitsFound,
        MaterialsGained = AP.Stats.MaterialsGained,
        ETA = AP.GetETA(),
        Milestones = AP.GetMilestoneCount()
    }
end

function AP.GetMilestoneCount()
    local count = 0
    local total = 0
    for _, v in pairs(AP.Milestones) do
        total = total + 1
        if v then count = count + 1 end
    end
    return count .. "/" .. total
end

function AP.PrintProgress()
    local stats = AP.GetAutoPilotStats()
    local report = "=== AUTO PILOT STATS ===\n"
    report = report .. "Active: " .. tostring(stats.Active) .. "\n"
    report = report .. "Phase: " .. stats.Phase .. " - " .. stats.PhaseName .. "\n"
    report = report .. "Level: " .. stats.Level .. "/2550 (" .. stats.OverallProgress .. ")\n"
    report = report .. "Duration: " .. stats.Duration .. "\n"
    report = report .. "Levels/hr: " .. stats.LevelsPerHour .. "\n"
    report = report .. "Kills: " .. stats.TotalKills .. " (" .. stats.KillsPerHour .. "/hr)\n"
    report = report .. "Quests: " .. stats.QuestsCompleted .. "\n"
    report = report .. "Bosses: " .. stats.BossKills .. "\n"
    report = report .. "Deaths: " .. stats.Deaths .. "\n"
    report = report .. "Raids: " .. stats.RaidsCompleted .. "\n"
    report = report .. "Items: " .. stats.ItemsCollected .. "\n"
    report = report .. "Milestones: " .. stats.Milestones .. "\n"
    report = report .. "ETA: " .. stats.ETA .. "\n"
    A.Notify("Auto Pilot", report, 5)
end

function AP.ExportProgress()
    local stats = AP.GetAutoPilotStats()
    local export = HttpService:JSONEncode(stats)
    A.Notify("Auto Pilot", "Progress exported to console", 2)
    return export
end

function AP.AutoPilotLoop()
    while AP.Active do
        pcall(function()
            if not A.Alive() then
                AP.HandleDeath()
                return
            end
            local now = tick()
            local myPos = A.GetPosition()
            if AP.LastPosition then
                local dist = (myPos - AP.LastPosition).Magnitude
                if dist < 1 and now - AP.LastStuckCheck > 5 then
                    AP.StuckCounter = AP.StuckCounter + 1
                    AP.LastStuckCheck = now
                elseif dist > 1 then
                    AP.StuckCounter = 0
                end
            end
            AP.LastPosition = myPos
            if AP.StuckCounter >= 5 then
                AP.HandleStuck()
                return
            end
            local health = A.Hum() and A.Hum().Health / math.max(A.Hum().MaxHealth, 1) or 1
            if health < 0.25 then
                AP.HandleLowHealth()
                return
            end
            AP.UpdateProgress()
            AP.UpdateProgressHistory()
            AP.HandlePhase(AP.Phase)
            AP.AutoStats()
            AP.AutoEquip()
            AP.AutoHaki()
            AP.AutoSkills()
            AP.HandleInventory()
            AP.HandleBounty()
            AP.HandleMastery()
            if now % 30 < 0.5 then
                AP.HandleSeaEvents()
                AP.HandleRaids()
                AP.HandleCDK()
                AP.HandleRace()
                AP.HandleAwakening()
            end
        end)
        wait(0.1)
    end
end

function AP.MainLoop()
    AP.AutoPilotLoop()
end

function AP.Start()
    if AP.Active then return end
    AP.Active = true
    AP.StartTime = tick()
    AP.Stats.StartTime = tick()
    AP.Stats.LastLevel = A.Lv()
    AP.Stats.CurrentLevel = A.Lv()
    AP.Stats.PhaseStartTime = tick()
    local currentLv = A.Lv()
    if currentLv < 250 then AP.Phase = 1
    elseif currentLv < 500 then AP.Phase = 2
    elseif currentLv < 700 then AP.Phase = 3
    elseif currentLv < 1000 then AP.Phase = 4
    elseif currentLv < 1300 then AP.Phase = 5
    elseif currentLv < 1500 then AP.Phase = 6
    elseif currentLv < 1800 then AP.Phase = 7
    elseif currentLv < 2200 then AP.Phase = 8
    else AP.Phase = 9
    end
    local phaseData = AP.Phases["Phase" .. AP.Phase]
    A.Notify("Auto Pilot", "Phase " .. AP.Phase .. ": " .. (phaseData and phaseData.Name or "Unknown") .. " (Lv " .. currentLv .. ")", 3)
    spawn(function()
        AP.MainLoop()
    end)
end

function AP.Stop()
    AP.Active = false
    AP.PhaseTransitionPending = false
    AP.DeathRecoveryActive = false
    AP.FarmingActive = false
    A.Notify("Auto Pilot", "Auto Pilot System Deactivated", 2)
end

A.Register("auto_pilot", AP)
return AP