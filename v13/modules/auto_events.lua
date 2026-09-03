local A = _G.Apex
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LP = A.LP
local V3 = A.V3
local CF = A.CF

A.AutoEvents = {}
local AE = A.AutoEvents

AE.Active = false
AE.EventsTriggered = 0
AE.RaidCount = 0
AE.FactoryCount = 0
AE.SeaBeastCount = 0
AE.LawRaidCount = 0
AE.DoughKingCount = 0
AE.TerrorSharkCount = 0
AE.KitsuneCount = 0
AE.LeviathanCount = 0
AE.DarkbeardCount = 0
AE.CakePrinceCount = 0
AE.EliteHunterCount = 0
AE.OrderCount = 0
AE.RipIndraCount = 0
AE.MirrorDimCount = 0
AE.FrozenDimCount = 0
AE.PrehistoricCount = 0
AE.EventCooldowns = {}
AE.EventQueue = {}
AE.ProcessingQueue = false
AE.CurrentEvent = nil
AE.EventStats = {
    TotalEvents = 0,
    SuccessfulEvents = 0,
    FailedEvents = 0,
    TotalRewards = {},
    BestTimes = {},
    StartTime = 0
}

AE.EventDefinitions = {
    Raid = {Name = "Raid", Type = "Raid", Cooldown = 300, Requires = {"Fragments"}, Sea = {1,2,3}, Reward = {"Scroll", "Fragments"}},
    Factory = {Name = "Factory", Type = "Factory", Cooldown = 600, Requires = {}, Sea = {1}, Reward = {"Materials", "Beli"}},
    SeaBeast = {Name = "SeaBeast", Type = "SeaBeast", Cooldown = 300, Requires = {"Ship"}, Sea = {1,2,3}, Reward = {"Beli", "Materials"}},
    LawRaid = {Name = "LawRaid", Type = "Raid", Cooldown = 900, Requires = {"Chip"}, Sea = {2}, Reward = {"Surgery", "Fragments"}},
    DoughKing = {Name = "DoughKing", Type = "Boss", Cooldown = 1800, Requires = {"Conjured Cocoa"}, Sea = {2}, Reward = {"Dough Fragment", "Beli"}},
    TerrorShark = {Name = "TerrorShark", Type = "SeaEvent", Cooldown = 600, Requires = {}, Sea = {3}, Reward = {"Shark Tooth", "Beli"}},
    Kitsune = {Name = "Kitsune", Type = "Boss", Cooldown = 1800, Requires = {"Azure Ember"}, Sea = {3}, Reward = {"Kitsune Items", "Fragments"}},
    Leviathan = {Name = "Leviathan", Type = "SeaEvent", Cooldown = 3600, Requires = {"Frozen Dimension"}, Sea = {3}, Reward = {"Leviathan Heart", "Scroll"}},
    Darkbeard = {Name = "Darkbeard", Type = "Boss", Cooldown = 3600, Requires = {"Fist of Darkness"}, Sea = {1}, Reward = {"Dark Blade", "Beli"}},
    CakePrince = {Name = "CakePrince", Type = "Boss", Cooldown = 1200, Requires = {}, Sea = {2}, Reward = {"Sweet Cloth", "Beli"}},
    EliteHunter = {Name = "EliteHunter", Type = "Elite", Cooldown = 600, Requires = {}, Sea = {2,3}, Reward = {"Chalice", "Beli"}},
    Order = {Name = "Order", Type = "Raid", Cooldown = 1200, Requires = {"Microchip"}, Sea = {2}, Reward = {"Sword", "Fragments"}},
    RipIndra = {Name = "RipIndra", Type = "Boss", Cooldown = 7200, Requires = {"God's Chalice", "Essence"}, Sea = {3}, Reward = {"Dark Coat", "Fragments"}},
    MirrorDimension = {Name = "MirrorDimension", Type = "Dimension", Cooldown = 1800, Requires = {}, Sea = {3}, Reward = {"Mirror Items", "Fragments"}},
    FrozenDimension = {Name = "FrozenDimension", Type = "Dimension", Cooldown = 3600, Requires = {}, Sea = {3}, Reward = {"Frozen Items", "Scrolls"}},
    PrehistoricIsland = {Name = "PrehistoricIsland", Type = "Island", Cooldown = 7200, Requires = {}, Sea = {3}, Reward = {"Dragon Materials", "Beli"}}
}

function AE.AddToQueue(eventType, priority)
    if not eventType then return end
    priority = priority or 5
    local eventDef = AE.EventDefinitions[eventType]
    if not eventDef then return end
    table.insert(AE.EventQueue, {
        Type = eventType,
        Definition = eventDef,
        Priority = priority,
        AddedTime = tick(),
        Attempts = 0,
        Status = "Queued"
    })
    table.sort(AE.EventQueue, function(a, b) return a.Priority > b.Priority end)
    A.Notify("Event Queue", eventType .. " added to queue (Priority: " .. priority .. ")", 2)
end

function AE.ProcessQueue()
    if AE.ProcessingQueue then return end
    AE.ProcessingQueue = true
    while AE.Active and #AE.EventQueue > 0 do
        local event = AE.EventQueue[1]
        if event then
            AE.CurrentEvent = event.Type
            local available = AE.IsEventAvailable(event.Type)
            local onCooldown = AE.GetEventCooldown(event.Type)
            if available and onCooldown <= 0 then
                event.Status = "Processing"
                event.Attempts = event.Attempts + 1
                local success = AE.TriggerEventByType(event.Type)
                if success then
                    AE.EventStats.SuccessfulEvents = AE.EventStats.SuccessfulEvents + 1
                    table.remove(AE.EventQueue, 1)
                else
                    event.Status = "Failed"
                    AE.EventStats.FailedEvents = AE.EventStats.FailedEvents + 1
                    if event.Attempts >= 3 then
                        table.remove(AE.EventQueue, 1)
                    end
                end
            elseif onCooldown > 0 then
                event.Status = "Cooldown"
                task.wait(math.min(onCooldown, 10))
            else
                event.Status = "Unavailable"
                table.remove(AE.EventQueue, 1)
            end
        end
        AE.CurrentEvent = nil
        task.wait(1)
    end
    AE.ProcessingQueue = false
end

function AE.ClearQueue()
    AE.EventQueue = {}
    AE.CurrentEvent = nil
    AE.ProcessingQueue = false
end

function AE.IsEventAvailable(eventType)
    local eventDef = AE.EventDefinitions[eventType]
    if not eventDef then return false end
    local sea = A.Sea()
    local seaAllowed = false
    for _, s in pairs(eventDef.Sea) do
        if s == sea then
            seaAllowed = true
            break
        end
    end
    if not seaAllowed then return false end
    local cooldown = AE.GetEventCooldown(eventType)
    if cooldown > 0 then return false end
    return true
end

function AE.GetEventCooldown(eventType)
    local lastTime = AE.EventCooldowns[eventType]
    if not lastTime then return 0 end
    local eventDef = AE.EventDefinitions[eventType]
    if not eventDef then return 0 end
    local elapsed = tick() - lastTime
    local remaining = eventDef.Cooldown - elapsed
    return math.max(remaining, 0)
end

function AE.WaitForEvent(eventType, timeout)
    timeout = timeout or 120
    local startTime = tick()
    while tick() - startTime < timeout do
        if AE.IsEventAvailable(eventType) then
            return true
        end
        task.wait(1)
    end
    return false
end

function AE.GetEventRequirements(eventType)
    local eventDef = AE.EventDefinitions[eventType]
    if not eventDef then return {} end
    local requirements = {}
    for _, req in pairs(eventDef.Requires) do
        local hasIt = false
        local backpack = LP.Backpack:GetChildren()
        for _, item in pairs(backpack) do
            if item.Name:find(req) then
                hasIt = true
                break
            end
        end
        local char = LP.Character
        if char then
            for _, item in pairs(char:GetChildren()) do
                if item.Name:find(req) then
                    hasIt = true
                    break
                end
            end
        end
        table.insert(requirements, {Name = req, Has = hasIt})
    end
    return requirements
end

function AE.TriggerEventByType(eventType)
    if eventType == "Raid" then return AE.TriggerRaid("Normal") end
    if eventType == "Factory" then return AE.TriggerFactory() end
    if eventType == "SeaBeast" then return AE.TriggerSeaBeast() end
    if eventType == "LawRaid" then return AE.TriggerLawRaid() end
    if eventType == "DoughKing" then return AE.TriggerDoughKing() end
    if eventType == "TerrorShark" then return AE.TriggerTerrorShark() end
    if eventType == "Kitsune" then return AE.TriggerKitsune() end
    if eventType == "Leviathan" then return AE.TriggerLeviathan() end
    if eventType == "Darkbeard" then return AE.TriggerDarkbeard() end
    if eventType == "CakePrince" then return AE.TriggerCakePrince() end
    if eventType == "EliteHunter" then return AE.TriggerEliteHunter() end
    if eventType == "Order" then return AE.TriggerOrder() end
    if eventType == "RipIndra" then return AE.TriggerRipIndra() end
    if eventType == "MirrorDimension" then return AE.TriggerMirrorDimension() end
    if eventType == "FrozenDimension" then return AE.TriggerFrozenDimension() end
    if eventType == "PrehistoricIsland" then return AE.TriggerPrehistoricIsland() end
    return false
end

function AE.TriggerRaid(raidType)
    if not AE.Active then return false end
    raidType = raidType or "Normal"
    local chipPos = V3(0, 0, 0)
    local sea = A.Sea()
    if sea == 1 then chipPos = V3(100, 10, -100)
    elseif sea == 2 then chipPos = V3(600, 10, -300)
    elseif sea == 3 then chipPos = V3(-800, 10, 400)
    end
    A.TweenTo(chipPos, 200)
    task.wait(1)
    A.CommF("RaidsNpc", "Start")
    task.wait(2)
    return AE.CompleteRaid()
end

function AE.CompleteRaid()
    if not AE.Active then return false end
    local raidActive = Workspace:FindFirstChild("RaidStarted") and Workspace.RaidStarted.Value or false
    local startTime = tick()
    local timeout = 300
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then
            task.wait(3)
        end
        local target = A.FindTarget(150)
        if target then
            A.SuperAttack(target)
        else
            local raidStructures = Workspace:FindFirstChild("Raid") and Workspace.Raid:GetChildren() or {}
            for _, structure in pairs(raidStructures) do
                if structure:IsA("Model") and structure:FindFirstChild("HumanoidRootPart") then
                    A.TpTo(structure.HumanoidRootPart.Position, 10)
                    task.wait(0.2)
                    break
                end
            end
        end
        local raidCleared = true
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:find("Raid") and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                raidCleared = false
                break
            end
        end
        if raidCleared then
            AE.RaidCount = AE.RaidCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["Raid"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.TriggerFactory()
    if not AE.Active then return false end
    local factoryPos = V3(100, 10, -200)
    A.TweenTo(factoryPos, 200)
    task.wait(1)
    A.CommF("Factory", "Start")
    task.wait(2)
    return AE.CompleteFactory()
end

function AE.CompleteFactory()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 120
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local core = Workspace:FindFirstChild("FactoryCore")
        if core and core:FindFirstChild("Humanoid") and core.Humanoid.Health > 0 then
            A.TpTo(core.Position or core:GetPivot().Position, 10)
            A.SuperAttack(nil)
        end
        local target = A.FindTarget(150)
        if target then
            A.SuperAttack(target)
        end
        if core and (not core:FindFirstChild("Humanoid") or core.Humanoid.Health <= 0) then
            AE.FactoryCount = AE.FactoryCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["Factory"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.TriggerSeaBeast()
    if not AE.Active then return false end
    local oceanPos = V3(0, 0, 0)
    local sea = A.Sea()
    if sea == 1 then oceanPos = V3(0, 0, 5000)
    elseif sea == 2 then oceanPos = V3(0, 0, -5000)
    elseif sea == 3 then oceanPos = V3(0, 0, 6000)
    end
    A.TweenTo(oceanPos, 300)
    task.wait(2)
    return AE.KillSeaBeast()
end

function AE.KillSeaBeast()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 180
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local seaBeast = nil
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and (npc.Name:find("SeaBeast") or npc.Name:find("Sea Beast") or npc.Name:find("Shark")) then
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    seaBeast = npc
                    break
                end
            end
        end
        if seaBeast and seaBeast:FindFirstChild("HumanoidRootPart") then
            A.TpTo(seaBeast.HumanoidRootPart.Position, 10)
            A.SuperAttack(nil)
        else
            AE.SeaBeastCount = AE.SeaBeastCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["SeaBeast"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.TriggerLawRaid()
    if not AE.Active then return false end
    local lawPos = V3(600, 10, -500)
    A.TweenTo(lawPos, 200)
    task.wait(1)
    A.CommF("LawRaid", "Start")
    task.wait(2)
    return AE.CompleteLawRaid()
end

function AE.CompleteLawRaid()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 300
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local law = nil
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and (npc.Name:find("Law") or npc.Name:find("Doctor")) then
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    law = npc
                    break
                end
            end
        end
        if law and law:FindFirstChild("HumanoidRootPart") then
            A.TpTo(law.HumanoidRootPart.Position, 10)
            A.SuperAttack(nil)
        else
            AE.LawRaidCount = AE.LawRaidCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["LawRaid"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.TriggerDoughKing()
    if not AE.Active then return false end
    local dkPos = V3(500, 10, -200)
    A.TweenTo(dkPos, 200)
    task.wait(1)
    A.CommF("DoughKing", "Start")
    task.wait(2)
    return AE.KillDoughKing()
end

function AE.KillDoughKing()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 300
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local dk = nil
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and (npc.Name:find("Dough King") or npc.Name:find("DoughKing")) then
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    dk = npc
                    break
                end
            end
        end
        if dk and dk:FindFirstChild("HumanoidRootPart") then
            A.TpTo(dk.HumanoidRootPart.Position, 10)
            A.SuperAttack(nil)
        else
            AE.DoughKingCount = AE.DoughKingCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["DoughKing"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.TriggerTerrorShark()
    if not AE.Active then return false end
    local tsPos = V3(0, 0, -4000)
    A.TweenTo(tsPos, 300)
    task.wait(2)
    return AE.KillTerrorShark()
end

function AE.KillTerrorShark()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 180
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local shark = nil
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and (npc.Name:find("Terror Shark") or npc.Name:find("TerrorShark")) then
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    shark = npc
                    break
                end
            end
        end
        if shark and shark:FindFirstChild("HumanoidRootPart") then
            A.TpTo(shark.HumanoidRootPart.Position, 10)
            A.SuperAttack(nil)
        else
            AE.TerrorSharkCount = AE.TerrorSharkCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["TerrorShark"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.TriggerKitsune()
    if not AE.Active then return false end
    local kitsunePos = V3(800, 10, 600)
    A.TweenTo(kitsunePos, 200)
    task.wait(1)
    A.CommF("Kitsune", "Start")
    task.wait(2)
    return AE.KillKitsune()
end

function AE.KillKitsune()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 300
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local kitsune = nil
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and npc.Name:find("Kitsune") then
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    kitsune = npc
                    break
                end
            end
        end
        if kitsune and kitsune:FindFirstChild("HumanoidRootPart") then
            A.TpTo(kitsune.HumanoidRootPart.Position, 10)
            A.SuperAttack(nil)
        else
            AE.KitsuneCount = AE.KitsuneCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["Kitsune"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.TriggerLeviathan()
    if not AE.Active then return false end
    local levPos = V3(0, 0, -8000)
    A.TweenTo(levPos, 300)
    task.wait(3)
    return AE.KillLeviathan()
end

function AE.KillLeviathan()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 600
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local levi = nil
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and (npc.Name:find("Leviathan") or npc.Name:find("Levi")) then
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    levi = npc
                    break
                end
            end
        end
        if levi and levi:FindFirstChild("HumanoidRootPart") then
            A.TpTo(levi.HumanoidRootPart.Position, 10)
            A.SuperAttack(nil)
        else
            AE.LeviathanCount = AE.LeviathanCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["Leviathan"] = tick()
            return true
        end
        task.wait(0.5)
    end
    return false
end

function AE.TriggerDarkbeard()
    if not AE.Active then return false end
    local dbPos = V3(-2500, 10, 1500)
    A.TweenTo(dbPos, 200)
    task.wait(1)
    A.CommF("Darkbeard", "Start")
    task.wait(2)
    return AE.KillDarkbeard()
end

function AE.KillDarkbeard()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 300
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local db = nil
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and (npc.Name:find("Darkbeard") or npc.Name:find("Dark Beard")) then
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    db = npc
                    break
                end
            end
        end
        if db and db:FindFirstChild("HumanoidRootPart") then
            A.TpTo(db.HumanoidRootPart.Position, 10)
            A.SuperAttack(nil)
        else
            AE.DarkbeardCount = AE.DarkbeardCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["Darkbeard"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.TriggerCakePrince()
    if not AE.Active then return false end
    local cpPos = V3(-400, 10, 500)
    A.TweenTo(cpPos, 200)
    task.wait(1)
    A.CommF("CakePrince", "Start")
    task.wait(2)
    return AE.KillCakePrince()
end

function AE.KillCakePrince()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 300
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local cp = nil
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and (npc.Name:find("Cake Prince") or npc.Name:find("CakePrince")) then
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    cp = npc
                    break
                end
            end
        end
        if cp and cp:FindFirstChild("HumanoidRootPart") then
            A.TpTo(cp.HumanoidRootPart.Position, 10)
            A.SuperAttack(nil)
        else
            AE.CakePrinceCount = AE.CakePrinceCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["CakePrince"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.TriggerEliteHunter()
    if not AE.Active then return false end
    local ehPos = V3(600, 10, 300)
    A.TweenTo(ehPos, 200)
    task.wait(1)
    A.CommF("EliteHunter", "Start")
    task.wait(2)
    return AE.KillEliteHunter()
end

function AE.KillEliteHunter()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 300
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local elite = nil
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and (npc.Name:find("Elite") or npc.Name:find("Diablo") or npc.Name:find("Urban") or npc.Name:find("Deandre")) then
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    elite = npc
                    break
                end
            end
        end
        if elite and elite:FindFirstChild("HumanoidRootPart") then
            A.TpTo(elite.HumanoidRootPart.Position, 10)
            A.SuperAttack(nil)
        else
            AE.EliteHunterCount = AE.EliteHunterCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["EliteHunter"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.TriggerOrder()
    if not AE.Active then return false end
    local ordPos = V3(400, 10, -200)
    A.TweenTo(ordPos, 200)
    task.wait(1)
    A.CommF("Order", "Start")
    task.wait(2)
    return AE.KillOrder()
end

function AE.KillOrder()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 300
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local order = nil
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and (npc.Name:find("Order") or npc.Name:find("Awakened Ice")) then
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    order = npc
                    break
                end
            end
        end
        if order and order:FindFirstChild("HumanoidRootPart") then
            A.TpTo(order.HumanoidRootPart.Position, 10)
            A.SuperAttack(nil)
        else
            AE.OrderCount = AE.OrderCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["Order"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.TriggerRipIndra()
    if not AE.Active then return false end
    local riPos = V3(-1000, 10, -800)
    A.TweenTo(riPos, 200)
    task.wait(1)
    A.CommF("RipIndra", "Start")
    task.wait(2)
    return AE.KillRipIndra()
end

function AE.KillRipIndra()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 600
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local rip = nil
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and (npc.Name:find("Rip Indra") or npc.Name:find("RipIndra")) then
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    rip = npc
                    break
                end
            end
        end
        if rip and rip:FindFirstChild("HumanoidRootPart") then
            A.TpTo(rip.HumanoidRootPart.Position, 10)
            A.SuperAttack(nil)
        else
            AE.RipIndraCount = AE.RipIndraCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["RipIndra"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.TriggerMirrorDimension()
    if not AE.Active then return false end
    local mdPos = V3(500, 10, 200)
    A.TweenTo(mdPos, 200)
    task.wait(1)
    A.CommF("MirrorDimension", "Start")
    task.wait(2)
    return AE.CompleteMirrorDimension()
end

function AE.CompleteMirrorDimension()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 300
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local target = A.FindTarget(200)
        if target then
            A.SuperAttack(target)
        end
        local mirrorDone = true
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and npc.Name:find("Mirror") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                mirrorDone = false
                break
            end
        end
        if mirrorDone then
            AE.MirrorDimCount = AE.MirrorDimCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["MirrorDimension"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.TriggerFrozenDimension()
    if not AE.Active then return false end
    local fdPos = V3(0, 0, -7000)
    A.TweenTo(fdPos, 300)
    task.wait(3)
    return AE.CompleteFrozenDimension()
end

function AE.CompleteFrozenDimension()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 600
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local target = A.FindTarget(200)
        if target then
            A.SuperAttack(target)
        end
        local frozenDone = true
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and npc.Name:find("Frozen") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                frozenDone = false
                break
            end
        end
        if frozenDone then
            AE.FrozenDimCount = AE.FrozenDimCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["FrozenDimension"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.TriggerPrehistoricIsland()
    if not AE.Active then return false end
    local piPos = V3(-500, 10, 500)
    A.TweenTo(piPos, 200)
    task.wait(1)
    A.CommF("PrehistoricIsland", "Start")
    task.wait(2)
    return AE.CompletePrehistoricIsland()
end

function AE.CompletePrehistoricIsland()
    if not AE.Active then return false end
    local startTime = tick()
    local timeout = 600
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local target = A.FindTarget(200)
        if target then
            A.SuperAttack(target)
        end
        local preDone = true
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and npc.Name:find("Prehistoric") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                preDone = false
                break
            end
        end
        if preDone then
            AE.PrehistoricCount = AE.PrehistoricCount + 1
            AE.EventStats.TotalEvents = AE.EventStats.TotalEvents + 1
            AE.EventCooldowns["PrehistoricIsland"] = tick()
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.NavigateToEvent(eventType)
    local eventPositions = {
        Raid = V3(0, 10, 0),
        Factory = V3(100, 10, -200),
        SeaBeast = V3(0, 0, 5000),
        LawRaid = V3(600, 10, -500),
        DoughKing = V3(500, 10, -200),
        TerrorShark = V3(0, 0, -4000),
        Kitsune = V3(800, 10, 600),
        Leviathan = V3(0, 0, -8000),
        Darkbeard = V3(-2500, 10, 1500),
        CakePrince = V3(-400, 10, 500),
        EliteHunter = V3(600, 10, 300),
        Order = V3(400, 10, -200),
        RipIndra = V3(-1000, 10, -800),
        MirrorDimension = V3(500, 10, 200),
        FrozenDimension = V3(0, 0, -7000),
        PrehistoricIsland = V3(-500, 10, 500)
    }
    local pos = eventPositions[eventType]
    if pos then
        A.TweenTo(pos, 250)
        return true
    end
    return false
end

function AE.FightEvent(eventType)
    if not AE.Active then return false end
    AE.NavigateToEvent(eventType)
    task.wait(1)
    local startTime = tick()
    local timeout = 300
    while AE.Active and (tick() - startTime < timeout) do
        if not A.Alive() then task.wait(3) end
        local target = A.FindTarget(200)
        if target then
            A.SuperAttack(target)
        else
            AE.CollectEventRewards(eventType)
            return true
        end
        task.wait(0.3)
    end
    return false
end

function AE.CollectEventRewards(eventType)
    task.wait(1)
    local eventDef = AE.EventDefinitions[eventType]
    if eventDef and eventDef.Reward then
        for _, reward in pairs(eventDef.Reward) do
            AE.EventStats.TotalRewards[reward] = (AE.EventStats.TotalRewards[reward] or 0) + 1
        end
    end
end

function AE.GetEventDrops(eventType)
    local eventDef = AE.EventDefinitions[eventType]
    if not eventDef then return {} end
    return eventDef.Reward or {}
end

function AE.AutoAllEvents()
    if not AE.Active then return end
    local allEvents = {
        "Raid", "Factory", "SeaBeast", "LawRaid", "DoughKing",
        "TerrorShark", "Kitsune", "Darkbeard", "CakePrince",
        "EliteHunter", "Order", "MirrorDimension"
    }
    for _, eventType in ipairs(allEvents) do
        if not AE.Active then break end
        if AE.IsEventAvailable(eventType) then
            AE.AddToQueue(eventType, 8)
        end
    end
end

function AE.FarmAllEvents()
    if not AE.Active then return end
    AE.AutoAllEvents()
    AE.ProcessQueue()
end

function AE.EventHop(eventType)
    if not AE.Active then return false end
    local eventDef = AE.EventDefinitions[eventType]
    if not eventDef then return false end
    local currentServer = game.JobId
    local maxHops = 5
    for i = 1, maxHops do
        if not AE.Active then break end
        local available = AE.WaitForEvent(eventType, 5)
        if available then
            return true
        end
        pcall(function()
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            if servers and servers.data then
                for _, server in pairs(servers.data) do
                    if server.id ~= currentServer and server.playing < server.maxPlayers then
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, LP)
                        task.wait(3)
                        break
                    end
                end
            end
        end)
        task.wait(5)
    end
    return false
end

function AE.SafeEvent(eventType)
    if not AE.Active then return false end
    local health = A.Hum() and A.Hum().Health / math.max(A.Hum().MaxHealth, 1) or 1
    if health < 0.3 then
        A.Notify("Event", "Health too low for event, recovering...", 2)
        return false
    end
    local requirements = AE.GetEventRequirements(eventType)
    for _, req in pairs(requirements) do
        if not req.Has then
            A.Notify("Event", "Missing requirement: " .. req.Name, 2)
            return false
        end
    end
    return AE.TriggerEventByType(eventType)
end

function AE.GetEventStats()
    local elapsed = tick() - AE.EventStats.StartTime
    local minutes = math.max(elapsed / 60, 0.01)
    return {
        Active = AE.Active,
        Duration = string.format("%.1f min", minutes),
        TotalEvents = AE.EventStats.TotalEvents,
        Successful = AE.EventStats.SuccessfulEvents,
        Failed = AE.EventStats.FailedEvents,
        EventsPerMinute = string.format("%.2f", AE.EventStats.TotalEvents / minutes),
        QueueSize = #AE.EventQueue,
        CurrentEvent = AE.CurrentEvent or "None",
        Raids = AE.RaidCount,
        Factories = AE.FactoryCount,
        SeaBeasts = AE.SeaBeastCount,
        LawRaids = AE.LawRaidCount,
        DoughKings = AE.DoughKingCount,
        TerrorSharks = AE.TerrorSharkCount,
        Kitsunes = AE.KitsuneCount,
        Leviathans = AE.LeviathanCount,
        Darkbeards = AE.DarkbeardCount,
        CakePrinces = AE.CakePrinceCount,
        EliteHunters = AE.EliteHunterCount,
        Orders = AE.OrderCount,
        RipIndras = AE.RipIndraCount,
        MirrorDims = AE.MirrorDimCount,
        FrozenDims = AE.FrozenDimCount,
        Prehistoric = AE.PrehistoricCount,
        Rewards = AE.EventStats.TotalRewards
    }
end

function AE.PrintEventStats()
    local stats = AE.GetEventStats()
    local report = "=== AUTO EVENTS STATS ===\n"
    report = report .. "Active: " .. tostring(stats.Active) .. "\n"
    report = report .. "Duration: " .. stats.Duration .. "\n"
    report = report .. "Events: " .. stats.TotalEvents .. " (" .. stats.EventsPerMinute .. "/min)\n"
    report = report .. "Success: " .. stats.Successful .. " / Failed: " .. stats.Failed .. "\n"
    report = report .. "Queue: " .. stats.QueueSize .. "\n"
    report = report .. "Current: " .. stats.CurrentEvent .. "\n"
    report = report .. "Raid:" .. stats.Raids .. " Factory:" .. stats.Factories .. " SeaBeast:" .. stats.SeaBeasts .. "\n"
    report = report .. "Law:" .. stats.LawRaids .. " DoughKing:" .. stats.DoughKings .. " TerrorShark:" .. stats.TerrorSharks .. "\n"
    report = report .. "Kitsune:" .. stats.Kitsunes .. " Leviathan:" .. stats.Leviathans .. " Darkbeard:" .. stats.Darkbeards .. "\n"
    report = report .. "CakePrince:" .. stats.CakePrinces .. " Elite:" .. stats.EliteHunters .. " Order:" .. stats.Orders .. "\n"
    report = report .. "RipIndra:" .. stats.RipIndras .. " Mirror:" .. stats.MirrorDims .. " Frozen:" .. stats.FrozenDims .. "\n"
    A.Notify("Event Stats", report, 5)
end

function AE.MainLoop()
    while AE.Active do
        pcall(function()
            AE.AutoAllEvents()
            AE.ProcessQueue()
        end)
        task.wait(5)
    end
end

function AE.Start()
    if AE.Active then return end
    AE.Active = true
    AE.EventStats.StartTime = tick()
    A.Notify("Auto Events", "Auto Event System Activated", 2)
    task.spawn(function()
        AE.MainLoop()
    end)
end

function AE.Stop()
    AE.Active = false
    AE.ClearQueue()
    A.Notify("Auto Events", "Auto Event System Deactivated", 2)
end

function AE.TriggerRaids()
    AE.TriggerRaid()
end

A.Register("auto_events", AE)
return AE