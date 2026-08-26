local A = _G.Apex
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")

local LP = A.LP
local V3 = A.V3
local CF = A.CF

A.MegaFarm = {}
local MF = A.MegaFarm

MF.Active = false
MF.Kills = 0
MF.Quests = 0
MF.Zones = 0
MF.ComboKills = 0
MF.LootItems = {}
MF.FarmStats = {
    StartTime = 0,
    TotalXP = 0,
    TotalGold = 0,
    EnemiesKilled = 0,
    QuestsCompleted = 0,
    ItemsCollected = 0,
    ZonesCleared = 0,
    BossKills = 0,
    MaterialGained = {},
    MasteryGained = {},
    AvgKillTime = 0,
    BestKillStreak = 0,
    CurrentKillStreak = 0,
    PeakXPPerMinute = 0,
    PeakKillsPerMinute = 0,
    DamageDealt = 0,
    DamageTaken = 0,
    DeathsCount = 0,
    FruitsCollected = 0,
    ChestsOpened = 0
}
MF.ZoneData = {}
MF.CurrentZone = nil
MF.FarmMode = "Ultra"
MF.LastDeathTime = 0
MF.StuckCounter = 0
MF.LastPosition = nil
MF.FarmPath = {}
MF.TargetQuest = nil
MF.QuestChainActive = false
MF.CollectMode = false
MF.ComboMultiplier = 1

MF.UltraFarm = {}

function MF.UltraFarm.UltraAutoFarm()
    if not MF.Active then return end
    if not A.Alive() then
        MF.HandleDeath()
        return
    end
    local myPos = A.GetPosition()
    local state = "Normal"
    if MF.LastPosition then
        local dist = (myPos - MF.LastPosition).Magnitude
        if dist < 1 then
            MF.StuckCounter = MF.StuckCounter + 1
            if MF.StuckCounter > 5 then
                state = "Stuck"
                MF.HandleStuck()
                return
            end
        else
            MF.StuckCounter = 0
        end
    end
    MF.LastPosition = myPos
    local health = A.Hum() and A.Hum().Health / math.max(A.Hum().MaxHealth, 1) or 1
    if health < 0.25 then
        state = "LowHealth"
        MF.HandleLowHealth()
        return
    end
    local target = A.FindTarget(200)
    if target then
        local targetChar = target.Character
        if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("Humanoid") then
            local dist = (targetChar.HumanoidRootPart.Position - myPos).Magnitude
            local isBoss = target:FindFirstChild("BossTag") or target.Name:find("Boss") or false
            if dist > 50 then
                A.TweenTo(targetChar.HumanoidRootPart.Position, 250)
            else
                local weapon = A.GetTool("Sword") or A.GetTool("Melee") or LP.Character:FindFirstChildOfClass("Tool")
                if weapon then
                    A.EquipTool(weapon)
                end
                A.SuperAttack(target)
            end
        end
    else
        local questTarget = MF.FindQuestEnemy()
        if questTarget then
            A.TweenTo(questTarget, 200)
        else
            MF.AdvanceToNextZone()
        end
    end
end

function MF.UltraFarm.AggressiveMode()
    if not MF.Active then return end
    MF.FarmMode = "Aggressive"
    MF.UltraFarm.UltraAutoFarm()
end

function MF.UltraFarm.EfficientMode()
    if not MF.Active then return end
    MF.FarmMode = "Efficient"
    local optimalTarget = MF.FarmAllEnemies.GetEnemyPriority(nil)
    if optimalTarget then
        local dist = (optimalTarget.Position - A.GetPosition()).Magnitude
        if dist > 50 then
            A.TweenTo(optimalTarget.Position, 200)
        else
            A.SuperAttack(optimalTarget.Player)
        end
    else
        MF.UltraFarm.UltraAutoFarm()
    end
end

function MF.UltraFarm.SafeMode()
    if not MF.Active then return end
    MF.FarmMode = "Safe"
    local health = A.Hum() and A.Hum().Health / math.max(A.Hum().MaxHealth, 1) or 1
    if health < 0.5 then
        MF.HandleLowHealth()
        return
    end
    local safeEnemies = MF.FarmAllEnemies.GetAllEnemies()
    local filtered = {}
    for _, e in pairs(safeEnemies) do
        if e.Threat < 40 and e.Distance < 100 then
            table.insert(filtered, e)
        end
    end
    if #filtered > 0 then
        table.sort(filtered, function(a, b) return a.Distance < b.Distance end)
        local closest = filtered[1]
        if closest.Distance > 40 then
            A.TweenTo(closest.Position, 150)
        else
            A.Attack(closest.Player, {"Z", "X", "C"}, 0.2)
        end
    end
end

MF.FarmAllEnemies = {}

function MF.FarmAllEnemies.GetAllEnemies()
    local enemies = {}
    local myPos = A.GetPosition()
    local maxRange = 500
    if A.Sea() == 2 then maxRange = 700 end
    if A.Sea() == 3 then maxRange = 900 end
    for _, npc in pairs(Workspace:FindFirstChild("NPCs") and Workspace.NPCs:GetChildren() or {}) do
        if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            local dist = (npc.HumanoidRootPart.Position - myPos).Magnitude
            if dist <= maxRange then
                local priority = MF.FarmAllEnemies.GetEnemyPriority(npc)
                table.insert(enemies, {
                    NPC = npc,
                    Name = npc.Name,
                    Position = npc.HumanoidRootPart.Position,
                    Health = npc.Humanoid.Health,
                    MaxHealth = npc.Humanoid.MaxHealth,
                    HealthPercent = npc.Humanoid.Health / math.max(npc.Humanoid.MaxHealth, 1),
                    Distance = dist,
                    Priority = priority,
                    IsBoss = npc.Name:find("Boss") ~= nil or npc:FindFirstChild("BossTag") ~= nil,
                    Level = npc:FindFirstChild("Level") and npc.Level.Value or 0
                })
            end
        end
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local dist = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
            if dist <= maxRange and not (player.Team and player.Team == LP.Team) then
                table.insert(enemies, {
                    Player = player,
                    Name = player.Name,
                    Position = player.Character.HumanoidRootPart.Position,
                    Health = player.Character.Humanoid.Health,
                    MaxHealth = player.Character.Humanoid.MaxHealth,
                    HealthPercent = player.Character.Humanoid.Health / math.max(player.Character.Humanoid.MaxHealth, 1),
                    Distance = dist,
                    Priority = 50,
                    IsBoss = false,
                    Level = player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") and player.Data.Level.Value or 0
                })
            end
        end
    end
    table.sort(enemies, function(a, b) return a.Priority > b.Priority end)
    return enemies
end

function MF.FarmAllEnemies.FarmEnemyList(enemies)
    if not MF.Active then return end
    if not enemies or #enemies == 0 then return end
    for _, enemy in ipairs(enemies) do
        if not MF.Active then break end
        if not A.Alive() then
            MF.HandleDeath()
            break
        end
        local targetEntity = enemy.NPC or enemy.Player
        if targetEntity then
            local dist = enemy.Distance
            if dist > 50 then
                A.TweenTo(enemy.Position, 250)
            else
                if enemy.IsBoss then
                    A.SuperAttack(targetEntity)
                else
                    A.Attack(targetEntity, {"Z", "X", "C", "V"}, 0.15)
                end
                MF.FarmStats.EnemiesKilled = MF.FarmStats.EnemiesKilled + 1
                MF.FarmStats.CurrentKillStreak = MF.FarmStats.CurrentKillStreak + 1
                if MF.FarmStats.CurrentKillStreak > MF.FarmStats.BestKillStreak then
                    MF.FarmStats.BestKillStreak = MF.FarmStats.CurrentKillStreak
                end
                MF.ComboMultiplier = 1 + math.min(MF.FarmStats.CurrentKillStreak * 0.1, 3)
            end
        end
        wait(0.05)
    end
end

function MF.FarmAllEnemies.GetEnemyPriority(enemy)
    if not enemy then return 0 end
    local priority = 0
    local myPos = A.GetPosition()
    local myLv = A.Lv()
    local hum = enemy:FindFirstChild("Humanoid")
    if not hum then return 0 end
    local hp = hum.Health / math.max(hum.MaxHealth, 1)
    local hrp = enemy:FindFirstChild("HumanoidRootPart")
    if not hrp then return 0 end
    local dist = (hrp.Position - myPos).Magnitude
    local theirLv = enemy:FindFirstChild("Level") and enemy.Level.Value or 0
    priority = priority + math.max(0, 30 - dist / 10)
    priority = priority + (1 - hp) * 30
    if hp < 0.2 then priority = priority + 25 end
    if enemy.Name:find("Boss") then priority = priority + 40 end
    if theirLv > myLv then priority = priority + 10 end
    local questTarget = MF.TargetQuest and MF.TargetQuest.Name == enemy.Name
    if questTarget then priority = priority + 50 end
    return math.floor(priority)
end

function MF.FarmAllEnemies.FarmByPriority(enemies)
    if not MF.Active then return end
    table.sort(enemies, function(a, b) return a.Priority > b.Priority end)
    MF.FarmAllEnemies.FarmEnemyList(enemies)
end

MF.FarmAllQuests = {}

function MF.FarmAllQuests.GetAllQuests()
    local quests = {}
    local sea = A.Sea()
    local myLv = A.Lv()
    local questGivers = {}
    if sea == 1 then
        if myLv < 20 then
            table.insert(questGivers, {Name = "QuestGiver", Zone = "Starter", MinLv = 1, MaxLv = 20})
        elseif myLv < 60 then
            table.insert(questGivers, {Name = "QuestGiver", Zone = "Marine", MinLv = 20, MaxLv = 60})
        elseif myLv < 120 then
            table.insert(questGivers, {Name = "QuestGiver", Zone = "Desert", MinLv = 60, MaxLv = 120})
        elseif myLv < 200 then
            table.insert(questGivers, {Name = "QuestGiver", Zone = "Snow", MinLv = 120, MaxLv = 200})
        elseif myLv < 300 then
            table.insert(questGivers, {Name = "QuestGiver", Zone = "MarineFort", MinLv = 200, MaxLv = 300})
        elseif myLv < 450 then
            table.insert(questGivers, {Name = "QuestGiver", Zone = "Sky", MinLv = 300, MaxLv = 450})
        else
            table.insert(questGivers, {Name = "QuestGiver", Zone = "Prison", MinLv = 450, MaxLv = 700})
        end
    elseif sea == 2 then
        if myLv < 800 then
            table.insert(questGivers, {Name = "QuestGiver", Zone = "Kingdom", MinLv = 700, MaxLv = 800})
        elseif myLv < 1000 then
            table.insert(questGivers, {Name = "QuestGiver", Zone = "Academy", MinLv = 800, MaxLv = 1000})
        elseif myLv < 1200 then
            table.insert(questGivers, {Name = "QuestGiver", Zone = "Usoapp", MinLv = 1000, MaxLv = 1200})
        elseif myLv < 1500 then
            table.insert(questGivers, {Name = "QuestGiver", Zone = "Colosseum", MinLv = 1200, MaxLv = 1500})
        else
            table.insert(questGivers, {Name = "QuestGiver", Zone = "GreenTorus", MinLv = 1300, MaxLv = 1500})
        end
    elseif sea == 3 then
        if myLv < 1700 then
            table.insert(questGivers, {Name = "QuestGiver", Zone = "FloatingTurtle", MinLv = 1500, MaxLv = 1700})
        elseif myLv < 2000 then
            table.insert(questGivers, {Name = "QuestGiver", Zone = "Hydra", MinLv = 1700, MaxLv = 2000})
        elseif myLv < 2300 then
            table.insert(questGivers, {Name = "QuestGiver", Zone = "GreatTree", MinLv = 2000, MaxLv = 2300})
        else
            table.insert(questGivers, {Name = "QuestGiver", Zone = "Endgame", MinLv = 2300, MaxLv = 2550})
        end
    end
    return questGivers
end

function MF.FarmAllQuests.GetOptimalQuestChain()
    local quests = MF.FarmAllQuests.GetAllQuests()
    local myLv = A.Lv()
    local bestQuest = nil
    local bestXP = 0
    for _, quest in pairs(quests) do
        if myLv >= quest.MinLv and myLv <= quest.MaxLv then
            local estimatedXP = (myLv * 10 + quest.MinLv * 5) * 1.5
            if estimatedXP > bestXP then
                bestXP = estimatedXP
                bestQuest = quest
            end
        end
    end
    if not bestQuest and #quests > 0 then
        bestQuest = quests[1]
    end
    return bestQuest
end

function MF.FarmAllQuests.AutoQuestChain()
    if not MF.Active then return end
    MF.QuestChainActive = true
    while MF.Active and MF.QuestChainActive do
        local quest = MF.FarmAllQuests.GetOptimalQuestChain()
        if quest then
            MF.TargetQuest = quest
            local questGiver = MF.FindQuestGiver(quest)
            if questGiver then
                A.TweenTo(questGiver, 200)
                wait(0.5)
                MF.AcceptQuest(quest)
            end
            MF.FarmQuestEnemies(quest)
            MF.FarmStats.QuestsCompleted = MF.FarmStats.QuestsCompleted + 1
        end
        wait(0.1)
    end
end

function MF.FarmAllQuests.CompleteAllQuests()
    if not MF.Active then return end
    local quests = MF.FarmAllQuests.GetAllQuests()
    for _, quest in pairs(quests) do
        if not MF.Active then break end
        MF.TargetQuest = quest
        MF.FarmQuestEnemies(quest)
    end
end

MF.FarmAllZones = {}

function MF.FarmAllZones.GetAllZones()
    local zones = {}
    local sea = A.Sea()
    if sea == 1 then
        zones = {
            {Name = "StarterIsland", Enemies = {"Bandit", "Monkey", "Gorilla"}, MinLv = 1, MaxLv = 30, Position = V3(0, 10, 0)},
            {Name = "MarineBase", Enemies = {"Pirate", "Brute"}, MinLv = 20, MaxLv = 60, Position = V3(500, 10, 200)},
            {Name = "Desert", Enemies = {"DesertBandit", "Officer"}, MinLv = 60, MaxLv = 120, Position = V3(1000, 10, -500)},
            {Name = "Frozen", Enemies = {"Snowman", "Arctic Warrior"}, MinLv = 120, MaxLv = 200, Position = V3(-1500, 10, 800)},
            {Name = "MarineFortress", Enemies = {"Chief Warden", "Swan"}, MinLv = 200, MaxLv = 300, Position = V3(800, 10, -1200)},
            {Name = "SkyIsland", Enemies = {"Shanda", "Wind Locus"}, MinLv = 300, MaxLv = 450, Position = V3(0, 400, 0)},
            {Name = "Prison", Enemies = {"Warden", "Chief Prisoner"}, MinLv = 450, MaxLv = 625, Position = V3(-2000, 10, -500)},
            {Name = "Colosseum", Enemies = {"Toga Warrior", "Gladiator"}, MinLv = 550, MaxLv = 675, Position = V3(1200, 10, 1000)},
            {Name = "Magma", Enemies = ["Magma Ninja", "Lava Pirate"], MinLv = 650, MaxLv = 700, Position = V3(-2500, 10, 1500)}
        }
    elseif sea == 2 then
        zones = {
            {Name = "Kingdom", Enemies = {"Raider", "Mercenary"}, MinLv = 700, MaxLv = 850, Position = V3(0, 10, 0)},
            {Name = "Academy", Enemies = {"Student", "Dragon Scholar"}, MinLv = 850, MaxLv = 1000, Position = V3(600, 10, 300)},
            {Name = "Usoapp", Enemies = {"Cookie Crafter", "Cake Guard"}, MinLv = 1000, MaxLv = 1150, Position = V3(-400, 10, -300)},
            {Name = "Colosseum2", Enemies = {"Ancient One", "Swordsman"}, MinLv = 1150, MaxLv = 1300, Position = V3(900, 10, -200)},
            {Name = "GreenTorus", Enemies = {"Cupid", "Grand Soul Reaper"}, MinLv = 1300, MaxLv = 1500, Position = V3(-700, 10, 500)},
            {Name = "HauntedCastle", Enemies = {"Reborn Skeleton", "Living Zombie"}, MinLv = 1200, MaxLv = 1450, Position = V3(1100, 10, 600)}
        }
    elseif sea == 3 then
        zones = {
            {Name = "FloatingTurtle", Enemies = {"Pirate Millionaire", "Dragon Crew"}, MinLv = 1500, MaxLv = 1700, Position = V3(0, 10, 0)},
            {Name = "Hydra", Enemies = {"Hydra Enforcer", "Ancient Lava Golem"}, MinLv = 1700, MaxLv = 2000, Position = V3(500, 10, -400)},
            {Name = "GreatTree", Enemies = {"Garden Guardian", "Kitsune"}, MinLv = 2000, MaxLv = 2200, Position = V3(-600, 10, 300)},
            {Name = "TikiOutpost", Enemies = {"Stone Golem", "Island Empress"}, MinLv = 2200, MaxLv = 2400, Position = V3(800, 10, 700)},
            {Name = "EndgameZone", Enemies = {"Dark Coat Pirates", "Dough King"}, MinLv = 2400, MaxLv = 2550, Position = V3(-1000, 10, -800)}
        }
    end
    return zones
end

function MF.FarmAllZones.GetZoneEnemies(zone)
    if not zone then return {} end
    local myPos = A.GetPosition()
    local enemies = {}
    local allEnemies = MF.FarmAllEnemies.GetAllEnemies()
    for _, enemy in pairs(allEnemies) do
        if enemy.Distance < 300 then
            local matchesZone = false
            if zone.Enemies then
                for _, zoneEnemy in pairs(zone.Enemies) do
                    if enemy.Name:find(zoneEnemy) then
                        matchesZone = true
                        break
                    end
                end
            end
            if matchesZone then
                table.insert(enemies, enemy)
            end
        end
    end
    return enemies
end

function MF.FarmAllZones.FarmZone(zone)
    if not MF.Active or not zone then return end
    MF.CurrentZone = zone.Name
    A.TweenTo(zone.Position, 250)
    wait(0.5)
    local attempts = 0
    while MF.Active and attempts < 100 do
        local enemies = MF.FarmAllZones.GetZoneEnemies(zone)
        if #enemies > 0 then
            MF.FarmAllEnemies.FarmByPriority(enemies)
        else
            local allEnemies = MF.FarmAllEnemies.GetAllEnemies()
            if #allEnemies > 0 then
                MF.FarmAllEnemies.FarmEnemyList(allEnemies)
            end
        end
        attempts = attempts + 1
        wait(0.1)
    end
end

function MF.FarmAllZones.RotateZones()
    if not MF.Active then return end
    local zones = MF.FarmAllZones.GetAllZones()
    local myLv = A.Lv()
    local validZones = {}
    for _, zone in pairs(zones) do
        if myLv >= zone.MinLv - 10 and myLv <= zone.MaxLv + 10 then
            table.insert(validZones, zone)
        end
    end
    if #validZones == 0 then
        validZones = zones
    end
    while MF.Active do
        for _, zone in ipairs(validZones) do
            if not MF.Active then break end
            MF.FarmAllZones.FarmZone(zone)
        end
        wait(0.1)
    end
end

function MF.FarmAllZones.ZoneOptimization(zone)
    if not zone then return {} end
    local optimization = {SpawnPoints = {}, OptimalPath = {}, ClearTime = 0, Efficiency = 0}
    local enemyCount = 0
    local totalDist = 0
    local spawnPoints = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name:lower():find("spawn") then
            local dist = (obj.Position - zone.Position).Magnitude
            if dist < 200 then
                table.insert(spawnPoints, {Position = obj.Position, Distance = dist})
                enemyCount = enemyCount + 1
            end
        end
    end
    table.sort(spawnPoints, function(a, b) return a.Distance < b.Distance end)
    optimization.SpawnPoints = spawnPoints
    optimization.ClearTime = enemyCount * 0.5
    optimization.Efficiency = enemyCount > 0 and (enemyCount / math.max(optimization.ClearTime, 1)) or 0
    return optimization
end

MF.CollectEverythingItems = {}

function MF.CollectEverythingItems.CollectChests()
    if not MF.Active then return end
    local myPos = A.GetPosition()
    local chests = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("chest") or obj.Name:lower():find("treasure")) then
            local dist = (obj.Position - myPos).Magnitude
            if dist < 500 then
                table.insert(chests, {Object = obj, Position = obj.Position, Distance = dist})
            end
        end
    end
    table.sort(chests, function(a, b) return a.Distance < b.Distance end)
    for _, chest in pairs(chests) do
        if not MF.Active then break end
        A.TweenTo(chest.Position, 300)
        wait(0.3)
        MF.FarmStats.ChestsOpened = MF.FarmStats.ChestsOpened + 1
    end
end

function MF.CollectEverythingItems.CollectFruits()
    if not MF.Active then return end
    local myPos = A.GetPosition()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if not MF.Active then break end
        if obj:IsA("Tool") and (obj.Name:find("Fruit") or obj.Name:find("fruit")) then
            local pos = obj:FindFirstChild("Handle") and obj.Handle.Position or obj:GetPivot().Position
            local dist = (pos - myPos).Magnitude
            if dist < 600 then
                A.TweenTo(pos, 300)
                wait(0.5)
                MF.FarmStats.FruitsCollected = MF.FarmStats.FruitsCollected + 1
                table.insert(MF.LootItems, {Name = obj.Name, Time = tick()})
            end
        end
    end
end

function MF.CollectEverythingItems.CollectBones()
    if not MF.Active then return end
    local myPos = A.GetPosition()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if not MF.Active then break end
        if obj:IsA("BasePart") and obj.Name:lower():find("bone") then
            local dist = (obj.Position - myPos).Magnitude
            if dist < 400 then
                A.TweenTo(obj.Position, 250)
                wait(0.1)
            end
        end
    end
end

function MF.CollectEverythingItems.CollectMaterials()
    if not MF.Active then return end
    local myPos = A.GetPosition()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if not MF.Active then break end
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("material") or name:find("ore") or name:find("gem") or name:find("crystal") then
                local dist = (obj.Position - myPos).Magnitude
                if dist < 400 then
                    A.TweenTo(obj.Position, 250)
                    wait(0.2)
                    local matName = obj.Name
                    MF.FarmStats.MaterialGained[matName] = (MF.FarmStats.MaterialGained[matName] or 0) + 1
                end
            end
        end
    end
end

function MF.CollectEverythingItems.CollectDrops()
    if not MF.Active then return end
    local myPos = A.GetPosition()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if not MF.Active then break end
        if obj:IsA("BasePart") and (obj.Name:lower():find("drop") or obj.Name:lower():find("loot") or obj.Name:lower():find("item")) then
            local dist = (obj.Position - myPos).Magnitude
            if dist < 400 then
                A.TweenTo(obj.Position, 250)
                wait(0.1)
                MF.FarmStats.ItemsCollected = MF.FarmStats.ItemsCollected + 1
            end
        end
    end
end

function MF.CollectEverythingItems.CollectMastery()
    if not MF.Active then return end
    local tools = LP.Backpack:GetChildren()
    for _, tool in pairs(tools) do
        if tool:IsA("Tool") then
            local mastery = tool:FindFirstChild("Mastery")
            if mastery then
                local name = tool.Name
                MF.FarmStats.MasteryGained[name] = (MF.FarmStats.MasteryGained[name] or 0) + mastery.Value
            end
        end
    end
end

function MF.CollectEverythingItems.CollectExperience()
    if not MF.Active then return end
    local currentXP = A.G:FindFirstChild("Exp") and A.G.Exp.Value or 0
    local lastXP = MF.FarmStats.TotalXP
    local gained = currentXP - lastXP
    if gained > 0 then
        MF.FarmStats.TotalXP = currentXP
    end
end

MF.MegaCombo = {}

function MF.MegaCombo.MegaComboKill(target)
    if not MF.Active then return end
    if not target or not target.Character then return end
    local hum = target.Character:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local comboChain = {"Z", "X", "C", "V", "Z", "X"}
    for _, skill in ipairs(comboChain) do
        if not MF.Active then break end
        if hum.Health <= 0 then break end
        A.Attack(target, {skill}, 0.08)
        wait(0.1)
    end
    MF.FarmStats.CurrentKillStreak = MF.FarmStats.CurrentKillStreak + 1
    if MF.FarmStats.CurrentKillStreak > MF.FarmStats.BestKillStreak then
        MF.FarmStats.BestKillStreak = MF.FarmStats.CurrentKillStreak
    end
end

function MF.MegaCombo.FullCombo(target)
    if not MF.Active then return end
    if not target or not target.Character then return end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = A.HRP()
    if hrp and myHRP then
        local dist = (hrp.Position - myHRP.Position).Magnitude
        if dist > 15 then
            A.TpTo(hrp.Position + V3(0, 0, 5), 5)
            wait(0.1)
        end
    end
    local skills = {"Z", "X", "C", "V"}
    for _, skill in ipairs(skills) do
        if not MF.Active then break end
        local hum = target.Character:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then break end
        A.Attack(target, {skill}, 0.05)
        wait(0.12)
        if hrp then
            local angle = math.rad(tick() * 90 % 360)
            local circlePos = hrp.Position + V3(math.cos(angle) * 5, 0, math.sin(angle) * 5)
            A.TpTo(circlePos, 3)
        end
    end
end

function MF.MegaCombo.MaxDPS(target)
    if not MF.Active then return 0 end
    if not target or not target.Character then return 0 end
    local startTime = tick()
    local startHealth = target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health or 0
    MF.MegaCombo.MegaComboKill(target)
    local endHealth = target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health or 0
    local elapsed = math.max(tick() - startTime, 0.01)
    local damage = startHealth - endHealth
    local dps = damage / elapsed
    return dps
end

function MF.MegaCombo.OneShotKill(target)
    if not MF.Active then return false end
    if not target or not target.Character then return false end
    local hum = target.Character:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return true end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = A.HRP()
    if hrp and myHRP then
        A.TpTo(hrp.Position, 1)
    end
    wait(0.05)
    local allSkills = {"V", "C", "X", "Z"}
    for _, skill in ipairs(allSkills) do
        if not MF.Active then break end
        if hum.Health <= 0 then break end
        A.Attack(target, {skill}, 0.01)
    end
    wait(0.15)
    local allSkills2 = {"Z", "X", "C", "V"}
    for _, skill in ipairs(allSkills2) do
        if not MF.Active then break end
        if hum.Health <= 0 then break end
        A.Attack(target, {skill}, 0.01)
    end
    return hum.Health <= 0
end

function MF.FindQuestEnemy()
    local myPos = A.GetPosition()
    local questData = A.CommF("QuestAccept", MF.TargetQuest)
    if questData then
        local enemyPos = questData:FindFirstChild("EnemyPosition")
        if enemyPos then
            return enemyPos.Value
        end
    end
    local enemies = MF.FarmAllEnemies.GetAllEnemies()
    if #enemies > 0 then
        return enemies[1].Position
    end
    return nil
end

function MF.FindQuestGiver(quest)
    if not quest then return nil end
    local myPos = A.GetPosition()
    local sea = A.Sea()
    local zones = MF.FarmAllZones.GetAllZones()
    for _, zone in pairs(zones) do
        if zone.Name:find(quest.Zone or "") then
            return zone.Position
        end
    end
    return zones[1] and zones[1].Position or myPos
end

function MF.AcceptQuest(quest)
    if not quest then return end
    A.CommF("QuestAccept", quest.Name)
    wait(0.3)
end

function MF.FarmQuestEnemies(quest)
    if not quest then return end
    local attempts = 0
    while MF.Active and attempts < 200 do
        local questActive = A.G:FindFirstChild("Quest") and A.G.Quest.Value > 0
        if not questActive then break end
        local target = A.FindTarget(200)
        if target then
            local targetChar = target.Character
            if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                local dist = (targetChar.HumanoidRootPart.Position - A.GetPosition()).Magnitude
                if dist > 40 then
                    A.TweenTo(targetChar.HumanoidRootPart.Position, 250)
                else
                    MF.MegaCombo.MegaComboKill(target)
                    MF.FarmStats.EnemiesKilled = MF.FarmStats.EnemiesKilled + 1
                end
            end
        else
            local pos = MF.FindQuestEnemy()
            if pos then
                A.TweenTo(pos, 200)
            end
        end
        attempts = attempts + 1
        wait(0.08)
    end
end

function MF.AdvanceToNextZone()
    local zones = MF.FarmAllZones.GetAllZones()
    local myLv = A.Lv()
    local bestZone = nil
    local bestScore = -1
    for _, zone in pairs(zones) do
        local score = 0
        if myLv >= zone.MinLv and myLv <= zone.MaxLv then
            score = 100 - math.abs(myLv - (zone.MinLv + zone.MaxLv) / 2)
        elseif myLv < zone.MinLv then
            score = -10
        else
            score = 50
        end
        if score > bestScore then
            bestScore = score
            bestZone = zone
        end
    end
    if bestZone then
        A.TweenTo(bestZone.Position, 250)
    end
end

function MF.HandleDeath()
    MF.FarmStats.DeathsCount = MF.FarmStats.DeathsCount + 1
    MF.LastDeathTime = tick()
    MF.ComboMultiplier = 1
    MF.FarmStats.CurrentKillStreak = 0
    wait(2)
    local spawnPoints = Workspace:FindFirstChild("SpawnPoints") and Workspace.SpawnPoints:GetChildren() or {}
    if #spawnPoints > 0 then
        local closest = spawnPoints[1]
        local closestDist = math.huge
        for _, sp in pairs(spawnPoints) do
            if sp:IsA("BasePart") then
                local dist = (sp.Position - A.GetPosition()).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = sp
                end
            end
        end
        A.TpTo(closest.Position, 5)
    end
    wait(1)
end

function MF.HandleStuck()
    MF.StuckCounter = 0
    local randomOffset = V3(math.random(-50, 50), 0, math.random(-50, 50))
    local newPos = A.GetPosition() + randomOffset
    A.TpTo(newPos, 100)
    wait(1)
    local zones = MF.FarmAllZones.GetAllZones()
    if #zones > 0 then
        local randomZone = zones[math.random(1, #zones)]
        A.TpTo(randomZone.Position, 300)
    end
end

function MF.HandleLowHealth()
    local health = A.Hum() and A.Hum().Health / math.max(A.Hum().MaxHealth, 1) or 1
    if health < 0.1 then
        local myHRP = A.HRP()
        if myHRP then
            local fleeDir = V3(math.random(-1, 1), 0, math.random(-1, 1)).Unit
            local fleePos = myHRP.Position + fleeDir * 50
            A.TpTo(fleePos, 200)
        end
        wait(1)
    elseif health < 0.25 then
        MF.UltraFarm.SafeMode()
    end
end

function MF.LootAll()
    if not MF.Active then return end
    MF.CollectEverythingItems.CollectChests()
    MF.CollectEverythingItems.CollectFruits()
    MF.CollectEverythingItems.CollectBones()
    MF.CollectEverythingItems.CollectMaterials()
    MF.CollectEverythingItems.CollectDrops()
end

function MF.CollectAll()
    MF.LootAll()
    MF.CollectEverythingItems.CollectMastery()
    MF.CollectEverythingItems.CollectExperience()
end

function MF.FarmEverything()
    if not MF.Active then return end
    MF.FarmStats.StartTime = tick()
    while MF.Active do
        pcall(function()
            MF.CollectEverythingItems.CollectExperience()
            local target = A.FindTarget(200)
            if target then
                MF.MegaCombo.MegaComboKill(target)
            else
                local quest = MF.FarmAllQuests.GetOptimalQuestChain()
                if quest then
                    MF.TargetQuest = quest
                    local pos = MF.FindQuestGiver(quest)
                    if pos then
                        A.TweenTo(pos, 200)
                        MF.AcceptQuest(quest)
                    end
                else
                    MF.AdvanceToNextZone()
                end
            end
            if tick() - MF.FarmStats.StartTime > 0 then
                local elapsed = tick() - MF.FarmStats.StartTime
                MF.FarmStats.AvgKillTime = elapsed / math.max(MF.FarmStats.EnemiesKilled, 1)
            end
        end)
        wait(0.05)
    end
end

function MF.GetMegaStats()
    local elapsed = tick() - MF.FarmStats.StartTime
    local minutes = math.max(elapsed / 60, 0.01)
    return {
        Active = MF.Active,
        Mode = MF.FarmMode,
        CurrentZone = MF.CurrentZone or "None",
        Duration = string.format("%.1f min", minutes),
        TotalKills = MF.FarmStats.EnemiesKilled,
        KillsPerMinute = string.format("%.1f", MF.FarmStats.EnemiesKilled / minutes),
        TotalXP = MF.FarmStats.TotalXP,
        XPPerMinute = string.format("%.0f", MF.FarmStats.TotalXP / minutes),
        QuestsCompleted = MF.FarmStats.QuestsCompleted,
        ItemsCollected = MF.FarmStats.ItemsCollected,
        ChestsOpened = MF.FarmStats.ChestsOpened,
        FruitsCollected = MF.FarmStats.FruitsCollected,
        BossKills = MF.FarmStats.BossKills,
        Deaths = MF.FarmStats.DeathsCount,
        BestKillStreak = MF.FarmStats.BestKillStreak,
        ComboMultiplier = string.format("%.1fx", MF.ComboMultiplier),
        MaterialGained = MF.FarmStats.MaterialGained,
        MasteryGained = MF.FarmStats.MasteryGained
    }
end

function MF.GetEfficiency()
    local elapsed = tick() - MF.FarmStats.StartTime
    if elapsed < 1 then return 0 end
    local minutes = elapsed / 60
    local killEfficiency = MF.FarmStats.EnemiesKilled / math.max(minutes, 0.1)
    local deathPenalty = MF.FarmStats.DeathsCount * 5
    local efficiency = math.max(0, killEfficiency - deathPenalty)
    return math.floor(efficiency)
end

function MF.GetKillsPerMinute()
    local elapsed = tick() - MF.FarmStats.StartTime
    if elapsed < 1 then return 0 end
    return MF.FarmStats.EnemiesKilled / (elapsed / 60)
end

function MF.GetXPRate()
    local elapsed = tick() - MF.FarmStats.StartTime
    if elapsed < 1 then return 0 end
    return MF.FarmStats.TotalXP / (elapsed / 60)
end

function MF.GetETA(targetLevel)
    if not targetLevel then return "Unknown" end
    local currentLv = A.Lv()
    if currentLv >= targetLevel then return "Complete" end
    local xpNeeded = 0
    for lv = currentLv, targetLevel - 1 do
        xpNeeded = xpNeeded + lv * 100 + 500
    end
    local xpRate = MF.GetXPRate()
    if xpRate <= 0 then return "Unknown" end
    local minutesLeft = xpNeeded / xpRate
    if minutesLeft < 60 then
        return string.format("%.0f min", minutesLeft)
    else
        return string.format("%.1f hrs", minutesLeft / 60)
    end
end

function MF.FarmOptimized()
    if not MF.Active then return end
    MF.FarmStats.StartTime = tick()
    while MF.Active do
        pcall(function()
            MF.CollectEverythingItems.CollectExperience()
            local health = A.Hum() and A.Hum().Health / math.max(A.Hum().MaxHealth, 1) or 1
            if health < 0.25 then
                MF.HandleLowHealth()
                return
            end
            local quest = MF.FarmAllQuests.GetOptimalQuestChain()
            if quest then
                MF.TargetQuest = quest
                local questActive = A.G:FindFirstChild("Quest") and A.G.Quest.Value > 0
                if not questActive then
                    local pos = MF.FindQuestGiver(quest)
                    if pos then
                        A.TweenTo(pos, 200)
                        wait(0.3)
                        MF.AcceptQuest(quest)
                    end
                end
                MF.FarmQuestEnemies(quest)
            else
                local target = A.FindTarget(200)
                if target then
                    MF.MegaCombo.MegaComboKill(target)
                else
                    MF.AdvanceToNextZone()
                end
            end
        end)
        wait(0.05)
    end
end

function MF.PrintStats()
    local stats = MF.GetMegaStats()
    local report = "=== MEGA FARM STATS ===\n"
    report = report .. "Active: " .. tostring(stats.Active) .. "\n"
    report = report .. "Mode: " .. stats.Mode .. "\n"
    report = report .. "Zone: " .. stats.CurrentZone .. "\n"
    report = report .. "Duration: " .. stats.Duration .. "\n"
    report = report .. "Kills: " .. stats.TotalKills .. " (" .. stats.KillsPerMinute .. "/min)\n"
    report = report .. "XP: " .. stats.TotalXP .. " (" .. stats.XPPerMinute .. "/min)\n"
    report = report .. "Quests: " .. stats.QuestsCompleted .. "\n"
    report = report .. "Items: " .. stats.ItemsCollected .. "\n"
    report = report .. "Chests: " .. stats.ChestsOpened .. "\n"
    report = report .. "Fruits: " .. stats.FruitsCollected .. "\n"
    report = report .. "Deaths: " .. stats.Deaths .. "\n"
    report = report .. "Streak: " .. stats.BestKillStreak .. "\n"
    report = report .. "Combo: " .. stats.ComboMultiplier .. "\n"
    A.Notify("Mega Farm Stats", report, 5)
end

function MF.MegaFarmLoop()
    while MF.Active do
        pcall(function()
            MF.FarmEverything()
        end)
        wait(0.1)
    end
end

function MF.MainLoop()
    MF.MegaFarmLoop()
end

function MF.Start()
    if MF.Active then return end
    MF.Active = true
    MF.FarmStats.StartTime = tick()
    MF.FarmStats.EnemiesKilled = 0
    MF.FarmStats.QuestsCompleted = 0
    MF.FarmStats.ItemsCollected = 0
    MF.FarmStats.ChestsOpened = 0
    MF.FarmStats.FruitsCollected = 0
    MF.FarmStats.DeathsCount = 0
    MF.FarmStats.BestKillStreak = 0
    MF.FarmStats.CurrentKillStreak = 0
    MF.FarmStats.TotalXP = 0
    MF.ComboMultiplier = 1
    MF.StuckCounter = 0
    A.Notify("Mega Farm", "Mega Farm System Activated", 2)
    spawn(function()
        MF.MainLoop()
    end)
end

function MF.Stop()
    MF.Active = false
    MF.QuestChainActive = false
    A.Notify("Mega Farm", "Mega Farm System Deactivated", 2)
end

MF.SetFarmAllEnemies = function(self, v) MF._FarmAllEnemies = v end
MF.SetFarmAllQuests = function(self, v) MF._FarmAllQuests = v end
MF.SetFarmAllZones = function(self, v) MF._FarmAllZones = v end
MF.SetAutoCollectAll = function(self, v) MF._AutoCollectAll = v end
MF.SetMegaCombo = function(self, v) MF._MegaCombo = v end
MF.LootAllDrops = function(self) MF.LootAll(self) end
function MF.CollectEverything() MF.CollectAll() end

A.Register("mega_farm", MF)
return MF