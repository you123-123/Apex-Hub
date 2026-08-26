local A = _G.Apex
if not A then return end

A.SeaProgress = {}
A.SeaProgress.Active = false
A.SeaProgress.CurrentSea = 1
A.SeaProgress.ProgressPercent = 0
A.SeaProgress.CompletedTasks = {}
A.SeaProgress.Stats = {
    TasksCompleted = 0,
    BossesDefeated = 0,
    ItemsCollected = 0,
    FragmentsEarned = 0,
    RacesUnlocked = 0,
    HakiUnlocked = 0,
    SessionStart = tick()
}

A.SeaProgress.SeaData = {
    [1] = {
        Name = "First Sea",
        LevelRange = {Min = 1, Max = 700},
        NPCs = {
            {Name = "Bandit", Level = 5, Position = CFrame.new(1060, 16, 1540)},
            {Name = "Monkey", Level = 15, Position = CFrame.new(-1580, 30, 360)},
            {Name = "Gorilla", Level = 25, Position = CFrame.new(-1600, 50, 380)},
            {Name = "Pirate", Level = 35, Position = CFrame.new(-1200, 20, -800)},
            {Name = "Brute", Level = 55, Position = CFrame.new(-400, 30, -2600)},
            {Name = "Desert Bandit", Level = 65, Position = CFrame.new(1600, 12, -600)},
            {Name = "Desert Officer", Level = 75, Position = CFrame.new(1650, 12, -620)},
            {Name = "Snow Bandit", Level = 90, Position = CFrame.new(600, 40, -5200)},
            {Name = "Snowman", Level = 100, Position = CFrame.new(620, 40, -5220)},
            {Name = "Yeti", Level = 110, Position = CFrame.new(540, 40, -5280)},
            {Name = "Vice Admiral", Level = 130, Position = CFrame.new(-4800, 20, -1800)},
            {Name = "Marine Officer", Level = 150, Position = CFrame.new(-4750, 20, -1850)},
            {Name = "Chief Petty Officer", Level = 170, Position = CFrame.new(-4850, 20, -1750)},
            {Name = "Sky Bandit", Level = 190, Position = CFrame.new(-4900, 320, -2300)},
            {Name = "Dark Master", Level = 210, Position = CFrame.new(-4950, 320, -2350)},
            {Name = "Prisoner", Level = 230, Position = CFrame.new(5300, 20, 4200)},
            {Name = "Dangerous Prisoner", Level = 250, Position = CFrame.new(5350, 20, 4250)},
            {Name = "Togatha", Level = 275, Position = CFrame.new(-1350, 10, 1100)},
            {Name = "Beast Pirate", Level = 300, Position = CFrame.new(-1300, 10, 1150)},
            {Name = "Dragon Crew Archer", Level = 325, Position = CFrame.new(6300, 25, 1000)},
            {Name = "Dragon Crew Warrior", Level = 350, Position = CFrame.new(6350, 25, 1050)},
            {Name = "Female Islander", Level = 375, Position = CFrame.new(5400, 600, 1600)},
            {Name = "Island Girl", Level = 400, Position = CFrame.new(5450, 600, 1650)},
            {Name = "Saber Expert", Level = 425, Position = CFrame.new(-1950, 20, -3100)},
            {Name = "Archer", Level = 450, Position = CFrame.new(-1900, 20, -3050)},
            {Name = "Admiral", Level = 475, Position = CFrame.new(-4650, 20, -1900)},
            {Name = "Mega Monkey", Level = 500, Position = CFrame.new(-1550, 50, 350)},
            {Name = "Diamond", Level = 525, Position = CFrame.new(-1600, 80, -1000)},
            {Name = "Yeti Captain", Level = 550, Position = CFrame.new(560, 40, -5300)},
            {Name = "Warden", Level = 575, Position = CFrame.new(5100, 20, 4050)},
            {Name = "Chief Warden", Level = 600, Position = CFrame.new(5150, 20, 4100)},
            {Name = "Swan", Level = 625, Position = CFrame.new(5200, 20, 4150)},
            {Name = "Combat Master", Level = 650, Position = CFrame.new(-2000, 20, -3200)},
            {Name = "Final Boss", Level = 700, Position = CFrame.new(-4700, 20, -1950)}
        },
        Bosses = {
            {Name = "Gorilla King", Level = 25, Position = CFrame.new(-1600, 50, 380), Reward = 5000},
            {Name = "Bobby", Level = 55, Position = CFrame.new(-400, 30, -2600), Reward = 10000},
            {Name = "Yeti", Level = 110, Position = CFrame.new(540, 40, -5280), Reward = 20000},
            {Name = "Vice Admiral", Level = 130, Position = CFrame.new(-4800, 20, -1800), Reward = 30000},
            {Name = "Warden", Level = 575, Position = CFrame.new(5100, 20, 4050), Reward = 50000},
            {Name = "Swan", Level = 625, Position = CFrame.new(5200, 20, 4150), Reward = 75000},
            {Name = "Combat Master", Level = 650, Position = CFrame.new(-2000, 20, -3200), Reward = 100000}
        },
        Items = {
            {Name = "Slingshot", Type = "Gun", Price = 5000},
            {Name = "Musket", Type = "Gun", Price = 8000},
            {Name = "Flintlock", Type = "Gun", Price = 12000},
            {Name = "Refined Flintlock", Type = "Gun", Price = 25000},
            {Name = "Cutlass", Type = "Sword", Price = 1000},
            {Name = "Katana", Type = "Sword", Price = 5000},
            {Name = "Iron Mace", Type = "Sword", Price = 12000},
            {Name = "Pipe", Type = "Melee", Price = 8000},
            {Name = "Black Cape", Type = "Accessory", Price = 15000},
            {Name = "Swordsman Hat", Type = "Accessory", Price = 25000}
        },
        AccessoryLocations = {
            {Name = "Black Cape", Position = CFrame.new(-4800, 20, -1800), Price = 15000},
            {Name = "Swordsman Hat", Position = CFrame.new(-2000, 20, -3200), Price = 25000}
        },
        UnlockPositions = {
            SecondSea = CFrame.new(-1200, 20, -800)
        }
    },
    [2] = {
        Name = "Second Sea",
        LevelRange = {Min = 700, Max = 1500},
        NPCs = {
            {Name = "Raider", Level = 700, Position = CFrame.new(-2800, 30, 2300)},
            {Name = "Mercenary", Level = 750, Position = CFrame.new(-2750, 30, 2350)},
            {Name = "Swamp Pirate", Level = 800, Position = CFrame.new(-3200, 30, -700)},
            {Name = "Forest Pirate", Level = 850, Position = CFrame.new(-3250, 30, -750)},
            {Name = "Mythical Pirate", Level = 900, Position = CFrame.new(-3300, 30, -800)},
            {Name = "Jungle Pirate", Level = 950, Position = CFrame.new(-3350, 30, -850)},
            {Name = "Musketeer Pirate", Level = 1000, Position = CFrame.new(-3400, 30, -900)},
            {Name = "Urban Pirate", Level = 1050, Position = CFrame.new(-3450, 30, -950)},
            {Name = "Diabolic Pirate", Level = 1100, Position = CFrame.new(-3500, 30, -1000)},
            {Name = "Omega Troop", Level = 1150, Position = CFrame.new(-3550, 30, -1050)},
            {Name = "Grenadier", Level = 1200, Position = CFrame.new(-3600, 30, -1100)},
            {Name = "Scotch", Level = 1250, Position = CFrame.new(-3650, 30, -1150)},
            {Name = "Mixa", Level = 1300, Position = CFrame.new(-3700, 30, -1200)},
            {Name = "Cyborg", Level = 1350, Position = CFrame.new(-3750, 30, -1250)},
            {Name = "Fishman Captain", Level = 1400, Position = CFrame.new(-3800, 30, -1300)},
            {Name = "Fishman Lord", Level = 1450, Position = CFrame.new(-3850, 30, -1350)},
            {Name = "Deep Sea Emperor", Level = 1500, Position = CFrame.new(-3900, 30, -1400)}
        },
        Bosses = {
            {Name = "Diamond", Level = 750, Position = CFrame.new(-2800, 30, 2300), Reward = 100000},
            {Name = "Jeremy", Level = 850, Position = CFrame.new(-3200, 30, -700), Reward = 150000},
            {Name = "Fajita", Level = 950, Position = CFrame.new(-3300, 30, -800), Reward = 200000},
            {Name = "Don Swan", Level = 1050, Position = CFrame.new(-3400, 30, -900), Reward = 250000},
            {Name = "Smoke Admiral", Level = 1150, Position = CFrame.new(-3500, 30, -1000), Reward = 300000},
            {Name = "Cursed Captain", Level = 1250, Position = CFrame.new(-3600, 30, -1100), Reward = 350000},
            {Name = "Awakened Ice Admiral", Level = 1350, Position = CFrame.new(-3700, 30, -1200), Reward = 400000},
            {Name = "Order", Level = 1500, Position = CFrame.new(-3900, 30, -1400), Reward = 500000}
        },
        Items = {
            {Name = "Refined Musket", Type = "Gun", Price = 50000},
            {Name = "Cannon", Type = "Gun", Price = 80000},
            {Name = "Dual Katana", Type = "Sword", Price = 40000},
            {Name = "Triple Katana", Type = "Sword", Price = 60000},
            {Name = "Pipe", Type = "Melee", Price = 30000},
            {Name = "Yama", Type = "Sword", Price = 100000},
            {Name = "Saber", Type = "Sword", Price = 75000},
            {Name = "Electric Claw", Type = "Melee", Price = 150000},
            {Name = "Dark Coat", Type = "Accessory", Price = 100000},
            {Name = "Valkyrie Helm", Type = "Accessory", Price = 200000}
        },
        AccessoryLocations = {
            {Name = "Dark Coat", Position = CFrame.new(-3200, 30, -700), Price = 100000},
            {Name = "Valkyrie Helm", Position = CFrame.new(-3600, 30, -1100), Price = 200000}
        },
        UnlockPositions = {
            ThirdSea = CFrame.new(-3900, 30, -1400)
        }
    },
    [3] = {
        Name = "Third Sea",
        LevelRange = {Min = 1500, Max = 2550},
        NPCs = {
            {Name = "Pirate Millionaire", Level = 1500, Position = CFrame.new(-600, 20, 500)},
            {Name = "Pistol Billionaire", Level = 1550, Position = CFrame.new(-650, 20, 550)},
            {Name = "Dragon Crew Warrior", Level = 1600, Position = CFrame.new(6300, 25, 1000)},
            {Name = "Dragon Crew Archer", Level = 1650, Position = CFrame.new(6350, 25, 1050)},
            {Name = "Female Islander", Level = 1700, Position = CFrame.new(5400, 600, 1600)},
            {Name = "Giant Islander", Level = 1750, Position = CFrame.new(5450, 600, 1650)},
            {Name = "Marine Commodore", Level = 1800, Position = CFrame.new(-700, 20, 600)},
            {Name = "Marine Rear Admiral", Level = 1850, Position = CFrame.new(-750, 20, 650)},
            {Name = "Marine Admiral", Level = 1900, Position = CFrame.new(-800, 20, 700)},
            {Name = "Island Champion", Level = 1950, Position = CFrame.new(5500, 600, 1700)},
            {Name = "Island King", Level = 2000, Position = CFrame.new(5550, 600, 1750)},
            {Name = "Soldier", Level = 2050, Position = CFrame.new(-850, 20, 750)},
            {Name = "Elite Troop", Level = 2100, Position = CFrame.new(-900, 20, 800)},
            {Name = "Sergeant", Level = 2150, Position = CFrame.new(-950, 20, 850)},
            {Name = "Captain", Level = 2200, Position = CFrame.new(-1000, 20, 900)},
            {Name = "Chief", Level = 2250, Position = CFrame.new(-1050, 20, 950)},
            {Name = "Commander", Level = 2300, Position = CFrame.new(-1100, 20, 1000)},
            {Name = "Ward Captain", Level = 2350, Position = CFrame.new(-1150, 20, 1050)},
            {Name "Leader", Level = 2400, Position = CFrame.new(-1200, 20, 1100)},
            {Name = "Sea King", Level = 2450, Position = CFrame.new(-1250, 20, 1150)},
            {Name = "Ruler", Level = 2500, Position = CFrame.new(-1300, 20, 1200)},
            {Name = "Supreme", Level = 2550, Position = CFrame.new(-1350, 20, 1250)}
        },
        Bosses = {
            {Name = "Head Instructor", Level = 1550, Position = CFrame.new(-600, 20, 500), Reward = 600000},
            {Name = "Diablo", Level = 1650, Position = CFrame.new(6300, 25, 1000), Reward = 700000},
            {Name = "Dread", Level = 1750, Position = CFrame.new(5400, 600, 1600), Reward = 800000},
            {Name = "Rip_indra", Level = 1850, Position = CFrame.new(-700, 20, 600), Reward = 900000},
            {Name = "Venom", Level = 1950, Position = CFrame.new(5500, 600, 1700), Reward = 1000000},
            {Name = "Terrorshark", Level = 2050, Position = CFrame.new(-850, 20, 750), Reward = 1100000},
            {Name = "Leviathan", Level = 2150, Position = CFrame.new(-950, 20, 850), Reward = 1200000},
            {Name = "Cake Prince", Level = 2250, Position = CFrame.new(-1050, 20, 950), Reward = 1300000},
            {Name = "Dough King", Level = 2350, Position = CFrame.new(-1150, 20, 1050), Reward = 1500000},
            {Name = "Kitsune", Level = 2450, Position = CFrame.new(-1250, 20, 1150), Reward = 1800000},
            {Name = "Final Sea Boss", Level = 2550, Position = CFrame.new(-1350, 20, 1250), Reward = 2000000}
        },
        Items = {
            {Name = "Kabucha", Type = "Gun", Price = 300000},
            {Name = "Spikey Trident", Type = "Sword", Price = 400000},
            {Name = "Godclover", Type = "Sword", Price = 500000},
            {Name = "Twin Hooks", Type = "Sword", Price = 350000},
            {Name = "Canvander", Type = "Sword", Price = 450000},
            {Name = "Dark Dagger", Type = "Sword", Price = 600000},
            {Name = "Shark Anchor", Type = "Sword", Price = 700000},
            {Name = "Leviathan Shield", Type = "Accessory", Price = 800000},
            {Name = "Kitsune Ribbon", Type = "Accessory", Price = 1000000},
            {Name = "Dragon Crown", Type = "Accessory", Price = 1200000}
        },
        AccessoryLocations = {
            {Name = "Leviathan Shield", Position = CFrame.new(-950, 20, 850), Price = 800000},
            {Name = "Kitsune Ribbon", Position = CFrame.new(-1250, 20, 1150), Price = 1000000},
            {Name = "Dragon Crown", Position = CFrame.new(-1350, 20, 1250), Price = 1200000}
        }
    }
}

A.SeaProgress.HakiData = {
    BusoHaki = {
        Name = "Buso Haki",
        Levels = 5,
        Requirements = {
            [1] = {Level = 1, Materials = {"Leather"}, Cost = 5000},
            [2] = {Level = 100, Materials = {"Leather", "Scrap Metal"}, Cost = 15000},
            [3] = {Level = 250, Materials = {"Leather", "Scrap Metal", "Iron Ore"}, Cost = 30000},
            [4] = {Level = 500, Materials = {"Leather", "Scrap Metal", "Iron Ore", "Mithril"}, Cost = 60000},
            [5] = {Level = 1000, Materials = {"Leather", "Scrap Metal", "Iron Ore", "Mithril", "Adamantite"}, Cost = 120000}
        }
    },
    KenHaki = {
        Name = "Ken Haki",
        Levels = 5,
        Requirements = {
            [1] = {Level = 1, Cost = 5000},
            [2] = {Level = 100, Cost = 15000},
            [3] = {Level = 250, Cost = 30000},
            [4] = {Level = 500, Cost = 60000},
            [5] = {Level = 1000, Cost = 120000}
        }
    }
}

A.SeaProgress.RaceData = {
    Human = {
        V3 = { Requirements = {"1Million Bounty", "Death Step"}, Cost = 2000000 },
        V4 = { Requirements = {"8000Mastery", "Death Step", "Alucard Shard"}, Cost = 5000000 }
    },
    Shark = {
        V3 = { Requirements = {"1.5Million Bounty", "Shark Anchor"}, Cost = 2500000 },
        V4 = { Requirements = {"8000Mastery", "Shark Anchor", "Leviathan Heart"}, Cost = 6000000 }
    },
    Angel = {
        V3 = { Requirements = {"1Million Bounty", "Godhuman"}, Cost = 2000000 },
        V4 = { Requirements = {"8000Mastery", "Godhuman", "Angel Wings"}, Cost = 5000000 }
    },
    Ghoul = {
        V3 = { Requirements = {"1Million Bounty", "Dark Step"}, Cost = 2000000 },
        V4 = { Requirements = {"8000Mastery", "Dark Step", "Vampire Fang"}, Cost = 5000000 }
    },
    Cyborg = {
        V3 = { Requirements = {"1Million Bounty", "Electric Claw"}, Cost = 2000000 },
        V4 = { Requirements = {"8000Mastery", "Electric Claw", "Cyber Core"}, Cost = 5000000 }
    },
    Kraken = {
        V3 = { Requirements = {"2Million Bounty", "Dragon Talon"}, Cost = 3000000 },
        V4 = { Requirements = {"10000Mastery", "Dragon Talon", "Kraken Ink"}, Cost = 7000000 }
    },
    Dragon = {
        V3 = { Requirements = {"2Million Bounty", "Dragon Talon"}, Cost = 3000000 },
        V4 = { Requirements = {"10000Mastery", "Dragon Talon", "Dragon Scale"}, Cost = 7000000 }
    },
    Mink = {
        V3 = { Requirements = {"1Million Bounty", "Thunder"}, Cost = 2000000 },
        V4 = { Requirements = {"8000Mastery", "Thunder", "Rabbit Foot"}, Cost = 5000000 }
    }
}

A.SeaProgress.DojoData = {
    Requirements = {
        Level = 2000,
        Bounty = 500000,
        Items = {"Dojo Token"}
    },
    Rewards = {
        {Name = "Dojo Belt", Type = "Accessory"},
        {Name = "Dojo Gi", Type = "Clothing"},
        {Name = "Dojo Katana", Type = "Sword"}
    }
}

local function GetSeaForLevel(level)
    if level >= 1500 then
        return 3
    elseif level >= 700 then
        return 2
    else
        return 1
    end
end

local function GetCurrentNPCs(sea)
    local seaData = A.SeaProgress.SeaData[sea]
    if not seaData then return {} end
    local npcs = {}
    for _, npc in ipairs(seaData.NPCs) do
        table.insert(npcs, npc)
    end
    return npcs
end

local function GetCurrentBosses(sea)
    local seaData = A.SeaProgress.SeaData[sea]
    if not seaData then return {} end
    local bosses = {}
    for _, boss in ipairs(seaData.Bosses) do
        table.insert(bosses, boss)
    end
    return bosses
end

local function GetSeaItems(sea)
    local seaData = A.SeaProgress.SeaData[sea]
    if not seaData then return {} end
    return seaData.Items or {}
end

local function TravelToNPC(npcPos)
    if not npcPos then return end
    A.TpTo(npcPos, 5)
    task.wait(1)
end

local function BuyItem(itemName, price)
    local success, result = pcall(function()
        return A.CommF("buyItem", itemName)
    end)
    if success and result then
        A.SeaProgress.Stats.ItemsCollected = A.SeaProgress.Stats.ItemsCollected + 1
        return true
    end
    return false
end

local function GetQuestProgress()
    local success, result = pcall(function()
        return A.CommF("getQuestProgress")
    end)
    if success and result then
        return result
    end
    return {Completed = 0, Total = 0}
end

local function HasSeaAccess(sea)
    local success, result = pcall(function()
        return A.CommF("hasSeaAccess", sea)
    end)
    if success then
        return result
    end
    return false
end

local function UnlockSeaAccess(sea)
    local success, result = pcall(function()
        return A.CommF("unlockSeaAccess", sea)
    end)
    if success then
        return result
    end
    return false
end

function A.SeaProgress.GetSeaProgress()
    local level = A.Lv()
    local currentSea = GetSeaForLevel(level)
    A.SeaProgress.CurrentSea = currentSea
    local seaData = A.SeaProgress.SeaData[currentSea]
    if not seaData then return 0 end
    local levelRange = seaData.LevelRange
    local rangeSize = levelRange.Max - levelRange.Min
    local levelProgress = level - levelRange.Min
    local percent = math.clamp((levelProgress / rangeSize) * 100, 0, 100)
    A.SeaProgress.ProgressPercent = percent
    return percent
end

function A.SeaProgress.GetSeaForLevel(level)
    return GetSeaForLevel(level)
end

function A.SeaProgress.ToSecondSea()
    if A.SeaProgress.CurrentSea >= 2 then
        A.Notify("Sea Progress", "Already in Second Sea or higher!", 3)
        return true
    end
    local level = A.Lv()
    if level < 700 then
        A.Notify("Sea Progress", "Need level 700+ for Second Sea!", 3)
        return false
    end
    A.Notify("Sea Progress", "Traveling to Second Sea...", 5)
    local reqs = A.SeaProgress.GetSecondSeaRequirements()
    if reqs then
        for _, req in ipairs(reqs) do
            if not req.Completed then
                A.Notify("Sea Progress", "Missing requirement: " .. req.Name, 3)
                return false
            end
        end
    end
    local npcPos = A.SeaProgress.SeaData[1].UnlockPositions.SecondSea
    if npcPos then
        TravelToNPC(npcPos)
        task.wait(2)
        local success, result = pcall(function()
            return A.CommF("travelToSea", 2)
        end)
        if success and result then
            A.SeaProgress.CurrentSea = 2
            A.SeaProgress.Stats.TasksCompleted = A.SeaProgress.Stats.TasksCompleted + 1
            A.Notify("Sea Progress", "Arrived at Second Sea!", 5)
            return true
        end
    end
    A.Notify("Sea Progress", "Failed to travel to Second Sea", 3)
    return false
end

function A.SeaProgress.ToThirdSea()
    if A.SeaProgress.CurrentSea >= 3 then
        A.Notify("Sea Progress", "Already in Third Sea!", 3)
        return true
    end
    local level = A.Lv()
    if level < 1500 then
        A.Notify("Sea Progress", "Need level 1500+ for Third Sea!", 3)
        return false
    end
    A.Notify("Sea Progress", "Traveling to Third Sea...", 5)
    local reqs = A.SeaProgress.GetThirdSeaRequirements()
    if reqs then
        for _, req in ipairs(reqs) do
            if not req.Completed then
                A.Notify("Sea Progress", "Missing requirement: " .. req.Name, 3)
                return false
            end
        end
    end
    local npcPos = A.SeaProgress.SeaData[2].UnlockPositions.ThirdSea
    if npcPos then
        TravelToNPC(npcPos)
        task.wait(2)
        local success, result = pcall(function()
            return A.CommF("travelToSea", 3)
        end)
        if success and result then
            A.SeaProgress.CurrentSea = 3
            A.SeaProgress.Stats.TasksCompleted = A.SeaProgress.Stats.TasksCompleted + 1
            A.Notify("Sea Progress", "Arrived at Third Sea!", 5)
            return true
        end
    end
    A.Notify("Sea Progress", "Failed to travel to Third Sea", 3)
    return false
end

function A.SeaProgress.TravelToSea(sea)
    if sea == 2 then
        return A.SeaProgress.ToSecondSea()
    elseif sea == 3 then
        return A.SeaProgress.ToThirdSea()
    end
    return false
end

function A.SeaProgress.GetRequirements(sea)
    if sea == 2 then
        return A.SeaProgress.GetSecondSeaRequirements()
    elseif sea == 3 then
        return A.SeaProgress.GetThirdSeaRequirements()
    end
    return {}
end

function A.SeaProgress.MeetRequirements(sea)
    local reqs = A.SeaProgress.GetRequirements(sea)
    for _, req in ipairs(reqs) do
        if not req.Completed then
            return false
        end
    end
    return true
end

function A.SeaProgress.GetSecondSeaRequirements()
    local level = A.Lv()
    local requirements = {
        {Name = "Reach Level 700", Completed = level >= 700},
        {Name = "Defeat Swan Boss", Completed = false},
        {Name = "Have 100,000 Beli", Completed = false}
    }
    local success, hasSwan = pcall(function()
        return A.CommF("hasDefeatedBoss", "Swan")
    end)
    if success and hasSwan then
        requirements[2].Completed = true
    end
    local success2, beli = pcall(function()
        return A.CommF("getBeli")
    end)
    if success2 and beli and beli >= 100000 then
        requirements[3].Completed = true
    end
    return requirements
end

function A.SeaProgress.CompleteSecondSeaTasks()
    local reqs = A.SeaProgress.GetSecondSeaRequirements()
    for _, req in ipairs(reqs) do
        if not req.Completed then
            if req.Name == "Defeat Swan Boss" then
                A.Notify("Sea Progress", "Farming Swan Boss...", 3)
                local swan = A.SeaProgress.SeaData[1].Bosses[6]
                if swan then
                    A.TpTo(swan.Position, 5)
                    task.wait(2)
                    local target = A.FindTarget(100)
                    if target then
                        A.SuperAttack(target)
                        task.wait(5)
                    end
                end
            elseif req.Name == "Have 100,000 Beli" then
                A.Notify("Sea Progress", "Need more Beli! Farm money first.", 3)
                return false
            end
        end
    end
    return A.SeaProgress.ToSecondSea()
end

function A.SeaProgress.GetThirdSeaRequirements()
    local level = A.Lv()
    local requirements = {
        {Name = "Reach Level 1500", Completed = level >= 1500},
        {Name = "Defeat Order Boss", Completed = false},
        {Name = "Have 500,000 Beli", Completed = false}
    }
    local success, hasOrder = pcall(function()
        return A.CommF("hasDefeatedBoss", "Order")
    end)
    if success and hasOrder then
        requirements[2].Completed = true
    end
    local success2, beli = pcall(function()
        return A.CommF("getBeli")
    end)
    if success2 and beli and beli >= 500000 then
        requirements[3].Completed = true
    end
    return requirements
end

function A.SeaProgress.CompleteThirdSeaTasks()
    local reqs = A.SeaProgress.GetThirdSeaRequirements()
    for _, req in ipairs(reqs) do
        if not req.Completed then
            if req.Name == "Defeat Order Boss" then
                A.Notify("Sea Progress", "Farming Order Boss...", 3)
                local order = A.SeaProgress.SeaData[2].Bosses[8]
                if order then
                    A.TpTo(order.Position, 5)
                    task.wait(2)
                    local target = A.FindTarget(100)
                    if target then
                        A.SuperAttack(target)
                        task.wait(5)
                    end
                end
            elseif req.Name == "Have 500,000 Beli" then
                A.Notify("Sea Progress", "Need more Beli! Farm money first.", 3)
                return false
            end
        end
    end
    return A.SeaProgress.ToThirdSea()
end

function A.SeaProgress.GetSeaTasks(sea)
    local tasks = {}
    local npcs = GetCurrentNPCs(sea)
    for _, npc in ipairs(npcs) do
        table.insert(tasks, {
            Name = "Farm " .. npc.Name,
            Level = npc.Level,
            Position = npc.Position,
            Completed = A.Lv() > npc.Level
        })
    end
    local bosses = GetCurrentBosses(sea)
    for _, boss in ipairs(bosses) do
        table.insert(tasks, {
            Name = "Defeat " .. boss.Name,
            Level = boss.Level,
            Position = boss.Position,
            Completed = false
        })
    end
    return tasks
end

function A.SeaProgress.GetCompletedTasks(sea)
    local tasks = A.SeaProgress.GetSeaTasks(sea)
    local completed = {}
    for _, task in ipairs(tasks) do
        if task.Completed then
            table.insert(completed, task)
        end
    end
    return completed
end

function A.SeaProgress.CompleteSeaTasks(sea)
    local tasks = A.SeaProgress.GetSeaTasks(sea)
    for _, task in ipairs(tasks) do
        if not A.SeaProgress.Active then break end
        if not task.Completed then
            A.TpTo(task.Position, 5)
            task.wait(1)
            local target = A.FindTarget(100)
            if target then
                A.SuperAttack(target)
                A.SeaProgress.Stats.TasksCompleted = A.SeaProgress.Stats.TasksCompleted + 1
                task.wait(1)
            end
        end
    end
end

function A.SeaProgress.AutoSeaProgression()
    if not A.SeaProgress.Active then return end
    local currentSea = A.SeaProgress.CurrentSea
    local nextSea = currentSea + 1
    if nextSea > 3 then
        A.Notify("Sea Progress", "Already in the highest sea!", 3)
        return
    end
    local level = A.Lv()
    local seaData = A.SeaProgress.SeaData[nextSea]
    if not seaData then return end
    if level >= seaData.LevelRange.Min then
        A.SeaProgress.TravelToSea(nextSea)
    else
        A.Notify("Sea Progress", "Need level " .. seaData.LevelRange.Min .. " for " .. seaData.Name, 3)
        local currentSeaData = A.SeaProgress.SeaData[currentSea]
        if currentSeaData then
            local targetNPC = nil
            for _, npc in ipairs(currentSeaData.NPCs) do
                if npc.Level <= level and npc.Level >= level - 100 then
                    targetNPC = npc
                end
            end
            if targetNPC then
                A.TpTo(targetNPC.Position, 5)
                local target = A.FindTarget(100)
                if target then
                    A.SuperAttack(target)
                end
            end
        end
    end
end

function A.SeaProgress.ProgressToNextSea()
    A.SeaProgress.AutoSeaProgression()
end

function A.SeaProgress.GetSeaNPCs(sea)
    return GetCurrentNPCs(sea)
end

function A.SeaProgress.FindSeaNPC(name, sea)
    local npcs = GetCurrentNPCs(sea or A.SeaProgress.CurrentSea)
    for _, npc in ipairs(npcs) do
        if npc.Name == name then
            return npc
        end
    end
    return nil
end

function A.SeaProgress.GetSeaBosses(sea)
    return GetCurrentBosses(sea)
end

function A.SeaProgress.FarmSeaBosses(sea)
    if not A.SeaProgress.Active then return end
    local bosses = GetCurrentBosses(sea)
    for _, boss in ipairs(bosses) do
        if not A.SeaProgress.Active then break end
        A.Notify("Sea Progress", "Farming " .. boss.Name .. "...", 3)
        A.TpTo(boss.Position, 5)
        task.wait(2)
        local startTime = tick()
        while tick() - startTime < 120 do
            if not A.SeaProgress.Active then break end
            local target = A.FindTarget(200)
            if target then
                A.SuperAttack(target)
                local hum = target:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health <= 0 then
                    A.SeaProgress.Stats.BossesDefeated = A.SeaProgress.Stats.BossesDefeated + 1
                    A.SeaProgress.Stats.FragmentsEarned = A.SeaProgress.Stats.FragmentsEarned + boss.Reward
                    A.Notify("Sea Progress", boss.Name .. " defeated! +" .. boss.Reward .. " fragments", 3)
                    break
                end
            else
                break
            end
            task.wait(0.5)
        end
        task.wait(5)
    end
end

function A.SeaProgress.GetSeaItems(sea)
    return GetSeaItems(sea)
end

function A.SeaProgress.FarmSeaItems(sea)
    if not A.SeaProgress.Active then return end
    local items = GetSeaItems(sea)
    for _, item in ipairs(items) do
        if not A.SeaProgress.Active then break end
        local success, hasItem = pcall(function()
            return A.CommF("hasItem", item.Name)
        end)
        if success and not hasItem then
            A.Notify("Sea Progress", "Buying " .. item.Name .. "...", 3)
            local bought = BuyItem(item.Name, item.Price)
            if bought then
                A.SeaProgress.Stats.ItemsCollected = A.SeaProgress.Stats.ItemsCollected + 1
                A.Notify("Sea Progress", "Bought " .. item.Name .. "!", 3)
            end
        end
    end
end

function A.SeaProgress.BuySeaAccessories(sea)
    if not A.SeaProgress.Active then return end
    local seaData = A.SeaProgress.SeaData[sea]
    if not seaData or not seaData.AccessoryLocations then return end
    for _, acc in ipairs(seaData.AccessoryLocations) do
        if not A.SeaProgress.Active then break end
        local success, hasItem = pcall(function()
            return A.CommF("hasItem", acc.Name)
        end)
        if success and not hasItem then
            A.TpTo(acc.Position, 5)
            task.wait(1)
            local bought = BuyItem(acc.Name, acc.Price)
            if bought then
                A.SeaProgress.Stats.ItemsCollected = A.SeaProgress.Stats.ItemsCollected + 1
            end
        end
    end
end

function A.SeaProgress.BuySeaWeapons(sea)
    A.SeaProgress.FarmSeaItems(sea)
end

function A.SeaProgress.AutoHaki()
    if not A.SeaProgress.Active then return end
    local hakiData = A.SeaProgress.HakiData.BusoHaki
    local success, level = pcall(function()
        return A.CommF("getHakiLevel", "Buso")
    end)
    if not success then return end
    if level and level < hakiData.Levels then
        local nextLevel = level + 1
        local requirements = hakiData.Requirements[nextLevel]
        if requirements then
            if A.Lv() >= requirements.Level then
                local success2, result = pcall(function()
                    return A.CommF("upgradeHaki", "Buso")
                end)
                if success2 and result then
                    A.SeaProgress.Stats.HakiUnlocked = A.SeaProgress.Stats.HakiUnlocked + 1
                    A.Notify("Haki", "Buso Haki upgraded to level " .. nextLevel, 3)
                end
            end
        end
    end
end

function A.SeaProgress.AutoKenHaki()
    if not A.SeaProgress.Active then return end
    local hakiData = A.SeaProgress.HakiData.KenHaki
    local success, level = pcall(function()
        return A.CommF("getHakiLevel", "Ken")
    end)
    if not success then return end
    if level and level < hakiData.Levels then
        local nextLevel = level + 1
        local requirements = hakiData.Requirements[nextLevel]
        if requirements then
            if A.Lv() >= requirements.Level then
                local success2, result = pcall(function()
                    return A.CommF("upgradeHaki", "Ken")
                end)
                if success2 and result then
                    A.SeaProgress.Stats.HakiUnlocked = A.SeaProgress.Stats.HakiUnlocked + 1
                    A.Notify("Haki", "Ken Haki upgraded to level " .. nextLevel, 3)
                end
            end
        end
    end
end

function A.SeaProgress.AutoBusoHaki()
    A.SeaProgress.AutoHaki()
end

function A.SeaProgress.GetRaceRequirements(race)
    local raceData = A.SeaProgress.RaceData[race]
    if not raceData then return nil end
    local success, currentRace = pcall(function()
        return A.CommF("getRace")
    end)
    local success2, raceLevel = pcall(function()
        return A.CommF("getRaceLevel", race)
    end)
    return {
        Race = race,
        CurrentRace = success and currentRace or "Unknown",
        IsCurrentRace = success and currentRace == race,
        V3Requirements = raceData.V3.Requirements,
        V3Cost = raceData.V3.Cost,
        V4Requirements = raceData.V4.Requirements,
        V4Cost = raceData.V4.Cost,
        V3Unlocked = success2 and raceLevel and raceLevel >= 3,
        V4Unlocked = success2 and raceLevel and raceLevel >= 4
    }
end

function A.SeaProgress.CompleteRaceTrials(race)
    if not A.SeaProgress.Active then return false end
    A.Notify("Race", "Starting " .. race .. " trials...", 5)
    local success, result = pcall(function()
        return A.CommF("startRaceTrial", race)
    end)
    if success and result then
        local startTime = tick()
        while tick() - startTime < 300 do
            if not A.SeaProgress.Active then return false end
            local success2, complete = pcall(function()
                return A.CommF("isRaceTrialComplete", race)
            end)
            if success2 and complete then
                A.Notify("Race", race .. " trial completed!", 5)
                return true
            end
            local target = A.FindTarget(300)
            if target then
                A.SuperAttack(target)
            end
            task.wait(0.5)
        end
    end
    A.Notify("Race", "Race trial failed or timed out", 3)
    return false
end

function A.SeaProgress.GetV3Requirements(race)
    local raceData = A.SeaProgress.RaceData[race]
    if not raceData then return nil end
    return {
        Requirements = raceData.V3.Requirements,
        Cost = raceData.V3.Cost
    }
end

function A.SeaProgress.GetV4Requirements(race)
    local raceData = A.SeaProgress.RaceData[race]
    if not raceData then return nil end
    return {
        Requirements = raceData.V4.Requirements,
        Cost = raceData.V4.Cost
    }
end

function A.SeaProgress.AutoRaceV3()
    if not A.SeaProgress.Active then return end
    local success, currentRace = pcall(function()
        return A.CommF("getRace")
    end)
    if not success or not currentRace then return end
    local raceData = A.SeaProgress.RaceData[currentRace]
    if not raceData then return end
    local success2, raceLevel = pcall(function()
        return A.CommF("getRaceLevel", currentRace)
    end)
    if success2 and raceLevel and raceLevel >= 3 then
        return
    end
    local requirements = raceData.V3.Requirements
    A.Notify("Race", "Auto " .. currentRace .. " V3 started", 5)
    A.SeaProgress.CompleteRaceTrials(currentRace)
end

function A.SeaProgress.AutoRaceV4()
    if not A.SeaProgress.Active then return end
    local success, currentRace = pcall(function()
        return A.CommF("getRace")
    end)
    if not success or not currentRace then return end
    local raceData = A.SeaProgress.RaceData[currentRace]
    if not raceData then return end
    local success2, raceLevel = pcall(function()
        return A.CommF("getRaceLevel", currentRace)
    end)
    if success2 and raceLevel and raceLevel >= 4 then
        return
    end
    A.Notify("Race", "Auto " .. currentRace .. " V4 started", 5)
    A.SeaProgress.CompleteRaceTrials(currentRace)
end

function A.SeaProgress.AutoCyborg()
    if not A.SeaProgress.Active then return end
    A.Notify("Cyborg", "Auto Cyborg race started", 5)
    local success, result = pcall(function()
        return A.CommF("unlockRace", "Cyborg")
    end)
    if success and result then
        A.SeaProgress.Stats.RacesUnlocked = A.SeaProgress.Stats.RacesUnlocked + 1
        A.Notify("Cyborg", "Cyborg race unlocked!", 5)
    end
end

function A.SeaProgress.AutoGhoul()
    if not A.SeaProgress.Active then return end
    A.Notify("Ghoul", "Auto Ghoul race started", 5)
    local success, result = pcall(function()
        return A.CommF("unlockRace", "Ghoul")
    end)
    if success and result then
        A.SeaProgress.Stats.RacesUnlocked = A.SeaProgress.Stats.RacesUnlocked + 1
        A.Notify("Ghoul", "Ghoul race unlocked!", 5)
    end
end

function A.SeaProgress.AutoDraco()
    if not A.SeaProgress.Active then return end
    A.Notify("Draco", "Auto Draco race started", 5)
    local success, result = pcall(function()
        return A.CommF("unlockRace", "Dragon")
    end)
    if success and result then
        A.SeaProgress.Stats.RacesUnlocked = A.SeaProgress.Stats.RacesUnlocked + 1
        A.Notify("Draco", "Draco race unlocked!", 5)
    end
end

function A.SeaProgress.AutoDracoRace()
    A.Notify("DracoRace", "Draco Race automation coming soon", 3)
end

function A.SeaProgress.AutoDojo()
    if not A.SeaProgress.Active then return end
    local dojoReqs = A.SeaProgress.GetDojoRequirements()
    if dojoReqs then
        for _, req in ipairs(dojoReqs) do
            if not req.Completed then
                A.Notify("Dojo", "Missing: " .. req.Name, 3)
                return
            end
        end
    end
    A.Notify("Dojo", "Starting Dojo challenge...", 5)
    local success, result = pcall(function()
        return A.CommF("startDojo")
    end)
    if success and result then
        local startTime = tick()
        while tick() - startTime < 180 do
            if not A.SeaProgress.Active then return end
            local target = A.FindTarget(200)
            if target then
                A.SuperAttack(target)
            end
            task.wait(0.5)
        end
    end
end

function A.SeaProgress.GetDojoRequirements()
    local level = A.Lv()
    local requirements = {
        {Name = "Reach Level 2000", Completed = level >= 2000},
        {Name = "Have 500,000 Bounty", Completed = false},
        {Name = "Have Dojo Token", Completed = false}
    }
    local success, bounty = pcall(function()
        return A.CommF("getBounty")
    end)
    if success and bounty and bounty >= 500000 then
        requirements[2].Completed = true
    end
    local success2, hasToken = pcall(function()
        return A.CommF("hasItem", "Dojo Token")
    end)
    if success2 and hasToken then
        requirements[3].Completed = true
    end
    return requirements
end

function A.SeaProgress.FarmSeaFragments(sea)
    if not A.SeaProgress.Active then return end
    local bosses = GetCurrentBosses(sea)
    for _, boss in ipairs(bosses) do
        if not A.SeaProgress.Active then break end
        A.TpTo(boss.Position, 5)
        task.wait(2)
        local target = A.FindTarget(200)
        if target then
            A.SuperAttack(target)
            A.SeaProgress.Stats.FragmentsEarned = A.SeaProgress.Stats.FragmentsEarned + boss.Reward
        end
        task.wait(1)
    end
end

function A.SeaProgress.GetFragmentsNeeded()
    local level = A.Lv()
    local currentSea = GetSeaForLevel(level)
    local fragmentsNeeded = 0
    for sea = currentSea, 3 do
        local seaData = A.SeaProgress.SeaData[sea]
        if seaData then
            for _, item in ipairs(seaData.Items) do
                local success, hasItem = pcall(function()
                    return A.CommF("hasItem", item.Name)
                end)
                if success and not hasItem then
                    fragmentsNeeded = fragmentsNeeded + item.Price
                end
            end
        end
    end
    return fragmentsNeeded
end

function A.SeaProgress.GetSeaStats()
    local stats = A.SeaProgress.Stats
    local uptime = tick() - stats.SessionStart
    return {
        CurrentSea = A.SeaProgress.CurrentSea,
        Progress = A.SeaProgress.ProgressPercent,
        TasksCompleted = stats.TasksCompleted,
        BossesDefeated = stats.BossesDefeated,
        ItemsCollected = stats.ItemsCollected,
        FragmentsEarned = stats.FragmentsEarned,
        RacesUnlocked = stats.RacesUnlocked,
        HakiUnlocked = stats.HakiUnlocked,
        SessionUptime = uptime,
        TasksPerMinute = uptime > 0 and (stats.TasksCompleted / (uptime / 60)) or 0
    }
end

function A.SeaProgress.GetCompletionPercentage()
    local totalTasks = 0
    local completedTasks = 0
    for sea = 1, 3 do
        local tasks = A.SeaProgress.GetSeaTasks(sea)
        for _, task in ipairs(tasks) do
            totalTasks = totalTasks + 1
            if task.Completed then
                completedTasks = completedTasks + 1
            end
        end
    end
    return totalTasks > 0 and (completedTasks / totalTasks) * 100 or 0
end

function A.SeaProgress.AutoAll()
    if not A.SeaProgress.Active then return end
    A.SeaProgress.AutoHaki()
    task.wait(1)
    A.SeaProgress.AutoKenHaki()
    task.wait(1)
    A.SeaProgress.AutoRaceV3()
    task.wait(1)
    A.SeaProgress.AutoDojo()
    task.wait(1)
    A.SeaProgress.AutoSeaProgression()
end

function A.SeaProgress.FullSeaProgression()
    A.SeaProgress.AutoAll()
end

function A.SeaProgress.MainLoop()
    while A.SeaProgress.Active do
        pcall(function()
            A.SeaProgress.GetSeaProgress()
            A.SeaProgress.AutoSeaProgression()
            local currentSea = A.SeaProgress.CurrentSea
            A.SeaProgress.FarmSeaBosses(currentSea)
            task.wait(5)
            A.SeaProgress.FarmSeaItems(currentSea)
            task.wait(5)
            A.SeaProgress.BuySeaAccessories(currentSea)
            task.wait(5)
            A.SeaProgress.AutoHaki()
            task.wait(5)
            A.SeaProgress.AutoKenHaki()
        end)
        task.wait(10)
    end
end

function A.SeaProgress.Start()
    if A.SeaProgress.Active then return end
    A.SeaProgress.Active = true
    A.SeaProgress.CurrentSea = GetSeaForLevel(A.Lv())
    A.SeaProgress.Stats = {
        TasksCompleted = 0,
        BossesDefeated = 0,
        ItemsCollected = 0,
        FragmentsEarned = 0,
        RacesUnlocked = 0,
        HakiUnlocked = 0,
        SessionStart = tick()
    }
    A.Notify("Sea Progression", "Sea progression started! Current Sea: " .. A.SeaProgress.CurrentSea, 5)
    task.spawn(function()
        A.SeaProgress.MainLoop()
    end)
end

function A.SeaProgress.Stop()
    A.SeaProgress.Active = false
    A.Notify("Sea Progression", "Sea progression stopped!", 3)
end

A.Register("sea_progression", A.SeaProgress)
