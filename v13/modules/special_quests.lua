local A = _G.Apex
local SpecialQuest = {}
SpecialQuest.Active = false
SpecialQuest.QuestsCompleted = 0
SpecialQuest.EliteKills = 0
SpecialQuest.LegendKills = 0
SpecialQuest._loop = nil
SpecialQuest._startTick = 0
SpecialQuest._currentQuest = nil
SpecialQuest._questPhase = "idle"
SpecialQuest._questTimer = 0
SpecialQuest._questMaxTime = 300
SpecialQuest._killCount = 0
SpecialQuest._rewardLog = {}
SpecialQuest._lastQuestComplete = 0
SpecialQuest._questCooldowns = {}
SpecialQuest._maxCooldown = 300
SpecialQuest._activeBoss = nil
SpecialQuest._bossHealth = 0
SpecialQuest._bossMaxHealth = 0
SpecialQuest._eliteSpawnTimer = 0
SpecialQuest._eliteNames = {"Elite", "Diablo", "Urban", "Deandre"}
SpecialQuest._legendBossNames = {"Cake Prince", "Dough King", "Darkbeard", "Rip Indra", "Leviathan"}
SpecialQuest._doughKingSpawned = false
SpecialQuest._cakePrinceKills = 0
SpecialQuest._cakePrinceRequired = 500
SpecialQuest._lawChip = false
SpecialQuest._coreBrain = false
SpecialQuest._materialCount = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Apex SpecialQuest] Error: " .. tostring(err))
    end
    return ok, err
end

local function FindMobByName(names, range)
    range = range or 1500
    local myHRP = A.HRP()
    if not myHRP then return nil end
    local enemies = Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("Hostile") or Workspace
    for _, child in ipairs(enemies:GetDescendants()) do
        if child:IsA("Model") then
            local hum = child:FindFirstChild("Humanoid")
            local hrp = child:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                local dist = (myHRP.Position - hrp.Position).Magnitude
                if dist <= range then
                    for _, name in ipairs(names) do
                        if string.find(string.lower(child.Name), string.lower(name)) then
                            return child
                        end
                    end
                end
            end
        end
    end
    return nil
end

function SpecialQuest.GetQuestRequirements(questName)
    local requirements = {
        ["EliteHunter"] = {Level = 1925, Item = nil, Location = "Hot and Cold"},
        ["CakePrince"] = {Kills = 500, Location = "Sea of Treats"},
        ["DoughKing"] = {Fragments = 100000, Location = "Sea of Treats"},
        ["Darkbeard"] = {Key = "God's Chalice", Location = "Floating Turtle"},
        ["ColorAdmin"] = {Item = "Colored Denim", Location = "Hot and Cold"},
        ["TerrorShark"] = {Sea = 3, Location = "Third Sea"},
        ["Kitsune"] = {Item = "Azure Embers", Location = "Hydra Island"},
        ["Dragon"] = {Level = 2300, Location = "Floating Turtle"},
        ["Law"] = {Chips = 1, Location = "Hot and Cold"},
        ["CoreBrain"] = {Item = "Core Brain", Location = "Cyborg"},
        ["Phoenix"] = {Level = 2100, Location = "Hot and Cold"},
        ["Order"] = {Item = "Order's Boss", Location = "Hot and Cold"},
        ["RipIndra"] = {Chalice = 3, Location = "Castle on the Sea"},
        ["Leviathan"] = {Sea = 3, Location = "Third Sea"}
    }
    return requirements[questName] or {}
end

function SpecialQuest.IsQuestAvailable(questName)
    local reqs = SpecialQuest.GetQuestRequirements(questName)
    if not reqs then return false end
    if reqs.Level and A.Lv() < reqs.Level then return false end
    if reqs.Sea and A.Sea() < reqs.Sea then return false end
    if reqs.Kills then
        if questName == "CakePrince" and SpecialQuest._cakePrinceKills < reqs.Kills then
            return false
        end
    end
    local cooldown = SpecialQuest._questCooldowns[questName]
    if cooldown and (tick() - cooldown) < SpecialQuest._maxCooldown then
        return false
    end
    return true
end

function SpecialQuest.AutoEliteHunter()
    if not SpecialQuest.IsQuestAvailable("EliteHunter") then return false end
    local elite = FindMobByName(SpecialQuest._eliteNames, 2000)
    if elite then
        local hrp = elite:FindFirstChild("HumanoidRootPart")
        local hum = elite:FindFirstChild("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local myHRP = A.HRP()
            if myHRP then
                local dist = (myHRP.Position - hrp.Position).Magnitude
                if dist > 100 then
                    A.TpTo(hrp.Position, 100)
                    return true
                end
                A.SuperAttack(elite)
                return true
            end
        end
    else
        local ok, err = SafeCall(function()
            local commF = A.CommF
            if commF then
                commF("EliteHunter")
            end
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                local hunt = remotes:FindFirstChild("EliteHunter") or remotes:FindFirstChild("TrackElite")
                if hunt then
                    hunt:FireServer()
                end
            end
        end)
        return ok
    end
    return false
end

function SpecialQuest.FindEliteHunter()
    local npc = Workspace:FindFirstChild("NPCs") or Workspace:FindFirstChild("Living")
    if not npc then return nil end
    for _, child in ipairs(npc:GetDescendants()) do
        if child:IsA("Model") and string.find(string.lower(child.Name), "elite hunter") then
            local part = child:FindFirstChild("HumanoidRootPart") or child.PrimaryPart
            if part then return child end
        end
    end
    return nil
end

function SpecialQuest.KillEliteHunter()
    local elite = FindMobByName(SpecialQuest._eliteNames, 1500)
    if not elite then return false end
    local maxAttempts = 60
    local attempts = 0
    while elite and elite.Parent and SpecialQuest.Active do
        attempts = attempts + 1
        if attempts > maxAttempts then break end
        local hum = elite:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then
            SpecialQuest.EliteKills = SpecialQuest.EliteKills + 1
            SpecialQuest._killCount = SpecialQuest._killCount + 1
            SpecialQuest.QuestsCompleted = SpecialQuest.QuestsCompleted + 1
            A.Notify("Elite Hunter", "Killed! Total: " .. tostring(SpecialQuest.EliteKills), 3)
            SpecialQuest._questCooldowns["EliteHunter"] = tick()
            return true
        end
        A.SuperAttack(elite)
        task.wait(0.2)
    end
    return false
end

function SpecialQuest.AutoCakePrince()
    if not SpecialQuest.IsQuestAvailable("CakePrince") then return false end
    local cakeMobs = FindMobByName({"Cake", "Cookie", "Baked"}, 1500)
    if cakeMobs then
        A.SuperAttack(cakeMobs)
        local hum = cakeMobs:FindFirstChild("Humanoid")
        if hum and hum.Health <= 0 then
            SpecialQuest._cakePrinceKills = SpecialQuest._cakePrinceKills + 1
            if SpecialQuest._cakePrinceKills >= SpecialQuest._cakePrinceRequired then
                A.Notify("Cake Prince", "Spawning Dough King...", 3)
                SpecialQuest._doughKingSpawned = true
            end
        end
        return true
    end
    local hrp = A.HRP()
    if hrp then
        local wanderPos = hrp.Position + Vector3.new(
            math.random(-200, 200),
            0,
            math.random(-200, 200)
        )
        A.TpTo(wanderPos, 100)
    end
    return false
end

function SpecialQuest.AutoDoughKing()
    if SpecialQuest._doughKingSpawned then
        local boss = FindMobByName({"Dough King", "DoughKing"}, 2000)
        if boss then
            local maxAttempts = 120
            local attempts = 0
            while boss and boss.Parent and SpecialQuest.Active do
                attempts = attempts + 1
                if attempts > maxAttempts then break end
                local hum = boss:FindFirstChild("Humanoid")
                if not hum or hum.Health <= 0 then
                    SpecialQuest.LegendKills = SpecialQuest.LegendKills + 1
                    SpecialQuest.QuestsCompleted = SpecialQuest.QuestsCompleted + 1
                    SpecialQuest._doughKingSpawned = false
                    SpecialQuest._cakePrinceKills = 0
                    A.Notify("Dough King", "Defeated!", 5)
                    return true
                end
                A.SuperAttack(boss)
                task.wait(0.2)
            end
        else
            return SpecialQuest.AutoCakePrince()
        end
    else
        return SpecialQuest.AutoCakePrince()
    end
    return false
end

function SpecialQuest.AutoDarkbeard()
    if not SpecialQuest.IsQuestAvailable("Darkbeard") then return false end
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            commF("SummonDarkbeard")
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local summon = remotes:FindFirstChild("SummonDarkbeard") or remotes:FindFirstChild("DarkbeardSummon")
            if summon then
                summon:FireServer()
            end
        end
    end)
    local boss = FindMobByName({"Darkbeard", "Dark Beard"}, 2000)
    if boss then
        local maxAttempts = 120
        local attempts = 0
        while boss and boss.Parent and SpecialQuest.Active do
            attempts = attempts + 1
            if attempts > maxAttempts then break end
            local hum = boss:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then
                SpecialQuest.LegendKills = SpecialQuest.LegendKills + 1
                SpecialQuest.QuestsCompleted = SpecialQuest.QuestsCompleted + 1
                SpecialQuest._questCooldowns["Darkbeard"] = tick()
                A.Notify("Darkbeard", "Defeated!", 5)
                return true
            end
            A.SuperAttack(boss)
            task.wait(0.2)
        end
    end
    return ok
end

function SpecialQuest.AutoColorAdmin()
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            commF("ColorAdmin")
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local ca = remotes:FindFirstChild("ColorAdmin")
            if ca then
                ca:FireServer()
            end
        end
    end)
    return ok
end

function SpecialQuest.AutoTerrorShark()
    local mob = FindMobByName({"TerrorShark", "Terror Shark"}, 2000)
    if mob then
        local maxAttempts = 90
        local attempts = 0
        while mob and mob.Parent and SpecialQuest.Active do
            attempts = attempts + 1
            if attempts > maxAttempts then break end
            local hum = mob:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then
                SpecialQuest.QuestsCompleted = SpecialQuest.QuestsCompleted + 1
                A.Notify("Terror Shark", "Defeated!", 3)
                return true
            end
            A.SuperAttack(mob)
            task.wait(0.2)
        end
    end
    return false
end

function SpecialQuest.AutoKitsune()
    if not SpecialQuest.IsQuestAvailable("Kitsune") then return false end
    local mob = FindMobByName({"Kitsune", "Kitsune"}, 2000)
    if mob then
        local maxAttempts = 120
        local attempts = 0
        while mob and mob.Parent and SpecialQuest.Active do
            attempts = attempts + 1
            if attempts > maxAttempts then break end
            local hum = mob:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then
                SpecialQuest.LegendKills = SpecialQuest.LegendKills + 1
                SpecialQuest.QuestsCompleted = SpecialQuest.QuestsCompleted + 1
                A.Notify("Kitsune", "Defeated!", 5)
                return true
            end
            A.SuperAttack(mob)
            task.wait(0.2)
        end
    end
    return false
end

function SpecialQuest.AutoDragon()
    if not SpecialQuest.IsQuestAvailable("Dragon") then return false end
    local mob = FindMobByName({"Dragon", "Dragon"}, 2000)
    if mob then
        local maxAttempts = 120
        local attempts = 0
        while mob and mob.Parent and SpecialQuest.Active do
            attempts = attempts + 1
            if attempts > maxAttempts then break end
            local hum = mob:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then
                SpecialQuest.LegendKills = SpecialQuest.LegendKills + 1
                SpecialQuest.QuestsCompleted = SpecialQuest.QuestsCompleted + 1
                A.Notify("Dragon", "Defeated!", 5)
                return true
            end
            A.SuperAttack(mob)
            task.wait(0.2)
        end
    end
    return false
end

function SpecialQuest.AutoLaw()
    if not SpecialQuest.IsQuestAvailable("Law") then return false end
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            commF("StartLawRaid")
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local law = remotes:FindFirstChild("StartLawRaid") or remotes:FindFirstChild("LawRaid")
            if law then
                law:FireServer()
            end
        end
    end)
    local boss = FindMobByName({"Law", "Order"}, 2000)
    if boss then
        local maxAttempts = 120
        local attempts = 0
        while boss and boss.Parent and SpecialQuest.Active do
            attempts = attempts + 1
            if attempts > maxAttempts then break end
            local hum = boss:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then
                SpecialQuest.LegendKills = SpecialQuest.LegendKills + 1
                SpecialQuest.QuestsCompleted = SpecialQuest.QuestsCompleted + 1
                A.Notify("Law", "Defeated!", 5)
                return true
            end
            A.SuperAttack(boss)
            task.wait(0.2)
        end
    end
    return ok
end

function SpecialQuest.AutoCoreBrain()
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            commF("CoreBrain")
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local core = remotes:FindFirstChild("CoreBrain")
            if core then
                core:FireServer()
            end
        end
    end)
    return ok
end

function SpecialQuest.AutoPhoenix()
    if not SpecialQuest.IsQuestAvailable("Phoenix") then return false end
    local mob = FindMobByName({"Phoenix", "Phoenix"}, 2000)
    if mob then
        local maxAttempts = 120
        local attempts = 0
        while mob and mob.Parent and SpecialQuest.Active do
            attempts = attempts + 1
            if attempts > maxAttempts then break end
            local hum = mob:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then
                SpecialQuest.QuestsCompleted = SpecialQuest.QuestsCompleted + 1
                A.Notify("Phoenix", "Defeated!", 5)
                return true
            end
            A.SuperAttack(mob)
            task.wait(0.2)
        end
    end
    return false
end

function SpecialQuest.AutoOrder()
    return SpecialQuest.AutoLaw()
end

function SpecialQuest.AutoRipIndra()
    if not SpecialQuest.IsQuestAvailable("RipIndra") then return false end
    local boss = FindMobByName({"Rip Indra", "RipIndra"}, 2000)
    if boss then
        local maxAttempts = 150
        local attempts = 0
        while boss and boss.Parent and SpecialQuest.Active do
            attempts = attempts + 1
            if attempts > maxAttempts then break end
            local hum = boss:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then
                SpecialQuest.LegendKills = SpecialQuest.LegendKills + 1
                SpecialQuest.QuestsCompleted = SpecialQuest.QuestsCompleted + 1
                SpecialQuest._questCooldowns["RipIndra"] = tick()
                A.Notify("Rip Indra", "Defeated!", 5)
                return true
            end
            A.SuperAttack(boss)
            task.wait(0.2)
        end
    else
        local ok, err = SafeCall(function()
            local commF = A.CommF
            if commF then
                commF("SummonRipIndra")
            end
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                local summon = remotes:FindFirstChild("SummonRipIndra")
                if summon then
                    summon:FireServer()
                end
            end
        end)
    end
    return false
end

function SpecialQuest.AutoLeviathan()
    if not SpecialQuest.IsQuestAvailable("Leviathan") then return false end
    local mob = FindMobByName({"Leviathan"}, 5000)
    if mob then
        local heart = mob:FindFirstChild("Heart") or mob:FindFirstChild("LeviathanHeart")
        local target = heart or mob
        local maxAttempts = 180
        local attempts = 0
        while mob and mob.Parent and SpecialQuest.Active do
            attempts = attempts + 1
            if attempts > maxAttempts then break end
            local mainHum = mob:FindFirstChild("Humanoid")
            if mainHum and mainHum.Health <= 0 then
                SpecialQuest.LegendKills = SpecialQuest.LegendKills + 1
                SpecialQuest.QuestsCompleted = SpecialQuest.QuestsCompleted + 1
                SpecialQuest._questCooldowns["Leviathan"] = tick()
                A.Notify("Leviathan", "Defeated!", 5)
                return true
            end
            A.SuperAttack(target)
            task.wait(0.2)
        end
    end
    return false
end

function SpecialQuest.CompleteSpecialQuest(questName)
    local questMap = {
        EliteHunter = SpecialQuest.AutoEliteHunter,
        CakePrince = SpecialQuest.AutoCakePrince,
        DoughKing = SpecialQuest.AutoDoughKing,
        Darkbeard = SpecialQuest.AutoDarkbeard,
        ColorAdmin = SpecialQuest.AutoColorAdmin,
        TerrorShark = SpecialQuest.AutoTerrorShark,
        Kitsune = SpecialQuest.AutoKitsune,
        Dragon = SpecialQuest.AutoDragon,
        Law = SpecialQuest.AutoLaw,
        CoreBrain = SpecialQuest.AutoCoreBrain,
        Phoenix = SpecialQuest.AutoPhoenix,
        Order = SpecialQuest.AutoOrder,
        RipIndra = SpecialQuest.AutoRipIndra,
        Leviathan = SpecialQuest.AutoLeviathan
    }
    local func = questMap[questName]
    if func then
        return func()
    end
    return false
end

function SpecialQuest.GetQuestRewards()
    local rewards = {}
    local lp = A.LP
    if not lp then return rewards end
    local backpack = lp:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(rewards, {
                    Name = item.Name,
                    Type = "Tool"
                })
            end
        end
    end
    return rewards
end

function SpecialQuest.FarmSpecialQuests()
    local questOrder = {
        "EliteHunter", "CakePrince", "DoughKing", "Darkbeard",
        "RipIndra", "Leviathan", "Kitsune", "Law", "Dragon",
        "TerrorShark", "Phoenix", "ColorAdmin", "CoreBrain"
    }
    for _, questName in ipairs(questOrder) do
        if SpecialQuest.Active and SpecialQuest.IsQuestAvailable(questName) then
            SpecialQuest._currentQuest = questName
            SpecialQuest._questPhase = "active"
            SpecialQuest._questTimer = tick()
            A.Notify("Quest", "Attempting: " .. questName, 3)
            local result = SpecialQuest.CompleteSpecialQuest(questName)
            if result then
                SpecialQuest._questCooldowns[questName] = tick()
                SpecialQuest._lastQuestComplete = tick()
                SpecialQuest._currentQuest = nil
                SpecialQuest._questPhase = "idle"
                table.insert(SpecialQuest._rewardLog, {
                    Quest = questName,
                    Time = tick(),
                    Rewards = SpecialQuest.GetQuestRewards()
                })
            end
        end
    end
end

function SpecialQuest.MainLoop()
    while SpecialQuest.Active do
        if not A.Alive() then
            task.wait(2)
            break
        end
        if SpecialQuest._currentQuest then
            local elapsed = tick() - SpecialQuest._questTimer
            if elapsed > SpecialQuest._questMaxTime then
                A.Notify("Quest", "Timed out on " .. tostring(SpecialQuest._currentQuest), 3)
                SpecialQuest._currentQuest = nil
                SpecialQuest._questPhase = "idle"
            end
        end
        SafeCall(function()
            SpecialQuest.FarmSpecialQuests()
        end)
        task.wait(1)
    end
end

function SpecialQuest.Start()
    if SpecialQuest.Active then return end
    SpecialQuest.Active = true
    SpecialQuest._startTick = tick()
    SpecialQuest._cakePrinceKills = 0
    SpecialQuest._doughKingSpawned = false
    SpecialQuest._questCooldowns = {}
    A.Notify("Special Quests", "Started farming special quests", 3)
    SpecialQuest._loop = task.spawn(function()
        SpecialQuest.MainLoop()
        SpecialQuest.Active = false
    end)
end

function SpecialQuest.Stop()
    SpecialQuest.Active = false
    SpecialQuest._currentQuest = nil
    SpecialQuest._questPhase = "idle"
    if SpecialQuest._loop then
        task.cancel(SpecialQuest._loop)
        SpecialQuest._loop = nil
    end
    A.Notify("Special Quests", "Stopped", 2)
end

A.SpecialQuest = SpecialQuest
A.Register("special_quests", A.SpecialQuest)
