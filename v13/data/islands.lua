local A = _G.Apex
A.Islands = {}

A.Islands.All = {
    -- ═══════════════════════════════════════════════════════
    -- SEA 1 — EAST BLUE & PARADISE
    -- ═══════════════════════════════════════════════════════
    {
        Name = "Starter Island",
        Level = 1,
        Sea = 1,
        Position = CFrame.new(-4500, 200, -2000),
        QuestGiver = "Bandit Quest Giver",
        QuestPos = CFrame.new(-4450, 210, -1980),
        SpawnPoints = {
            CFrame.new(-4520, 205, -2010),
            CFrame.new(-4480, 205, -1960),
            CFrame.new(-4540, 205, -2040),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Bandit Quest Giver", "Sword Dealer", "Close Account Manager"},
        Region = "East Blue",
        AccessMethod = "Walk",
    },
    {
        Name = "Marine Fortress",
        Level = 20,
        Sea = 1,
        Position = CFrame.new(-4300, 210, -1500),
        QuestGiver = "Marine Quest Giver",
        QuestPos = CFrame.new(-4280, 220, -1480),
        SpawnPoints = {
            CFrame.new(-4320, 215, -1520),
            CFrame.new(-4280, 215, -1480),
            CFrame.new(-4260, 215, -1540),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Marine Quest Giver", "Gun Dealer", "Fighting Style Teacher"},
        Region = "East Blue",
        AccessMethod = "Walk",
    },
    {
        Name = "Shanks' Town",
        Level = 40,
        Sea = 1,
        Position = CFrame.new(-3800, 200, -1200),
        QuestGiver = "Shanks Town Quest Giver",
        QuestPos = CFrame.new(-3780, 210, -1180),
        SpawnPoints = {
            CFrame.new(-3820, 205, -1220),
            CFrame.new(-3780, 205, -1180),
            CFrame.new(-3760, 205, -1240),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Shanks Town Quest Giver", "Sword Dealer", "Coliseum Dealer"},
        Region = "East Blue",
        AccessMethod = "Walk",
    },
    {
        Name = "Monkey Mountain",
        Level = 60,
        Sea = 1,
        Position = CFrame.new(-3500, 300, -900),
        QuestGiver = "Monkey Quest Giver",
        QuestPos = CFrame.new(-3480, 310, -880),
        SpawnPoints = {
            CFrame.new(-3520, 305, -920),
            CFrame.new(-3480, 305, -880),
            CFrame.new(-3460, 305, -940),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Monkey Quest Giver", "Sword Dealer", "Animal Tamer"},
        Region = "East Blue",
        AccessMethod = "Walk",
    },
    {
        Name = "Magma Village",
        Level = 80,
        Sea = 1,
        Position = CFrame.new(-3200, 250, -600),
        QuestGiver = "Magma Village Quest Giver",
        QuestPos = CFrame.new(-3180, 260, -580),
        SpawnPoints = {
            CFrame.new(-3220, 255, -620),
            CFrame.new(-3180, 255, -580),
            CFrame.new(-3160, 255, -640),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = true,
        NPCs = {"Magma Village Quest Giver", "Blacksmith", "Magma Expert"},
        Region = "East Blue",
        AccessMethod = "Walk",
    },
    {
        Name = "Frozen Village",
        Level = 100,
        Sea = 1,
        Position = CFrame.new(-2900, 350, -300),
        QuestGiver = "Frozen Village Quest Giver",
        QuestPos = CFrame.new(-2880, 360, -280),
        SpawnPoints = {
            CFrame.new(-2920, 355, -320),
            CFrame.new(-2880, 355, -280),
            CFrame.new(-2860, 355, -340),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Frozen Village Quest Giver", "Ice Expert", "Snow Merchant"},
        Region = "East Blue",
        AccessMethod = "Walk",
    },
    {
        Name = "Pirate Village",
        Level = 120,
        Sea = 1,
        Position = CFrame.new(-2600, 200, 0),
        QuestGiver = "Pirate Village Quest Giver",
        QuestPos = CFrame.new(-2580, 210, 20),
        SpawnPoints = {
            CFrame.new(-2620, 205, -20),
            CFrame.new(-2580, 205, 20),
            CFrame.new(-2560, 205, -40),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Pirate Village Quest Giver", "Pirate Dealer", "Blacksmith"},
        Region = "East Blue",
        AccessMethod = "Walk",
    },
    {
        Name = "Prison",
        Level = 150,
        Sea = 1,
        Position = CFrame.new(-2300, 180, 300),
        QuestGiver = "Prison Quest Giver",
        QuestPos = CFrame.new(-2280, 190, 320),
        SpawnPoints = {
            CFrame.new(-2320, 185, 280),
            CFrame.new(-2280, 185, 320),
            CFrame.new(-2260, 185, 260),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Prison Quest Giver", "Warden", "Prison Guard"},
        Region = "East Blue",
        AccessMethod = "Walk",
    },
    {
        Name = "Baratie",
        Level = 175,
        Sea = 1,
        Position = CFrame.new(-2000, 150, 600),
        QuestGiver = "Baratie Quest Giver",
        QuestPos = CFrame.new(-1980, 160, 620),
        SpawnPoints = {
            CFrame.new(-2020, 155, 580),
            CFrame.new(-1980, 155, 620),
            CFrame.new(-1960, 155, 560),
        },
        Type = "Boss",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = true,
        NPCs = {"Baratie Quest Giver", "Sword Dealer", "Fighting Style Teacher", "Chef"},
        Region = "East Blue",
        AccessMethod = "Boat",
    },
    {
        Name = "Colosseum",
        Level = 200,
        Sea = 1,
        Position = CFrame.new(-1700, 120, 900),
        QuestGiver = "Colosseum Quest Giver",
        QuestPos = CFrame.new(-1680, 130, 920),
        SpawnPoints = {
            CFrame.new(-1720, 125, 880),
            CFrame.new(-1680, 125, 920),
            CFrame.new(-1660, 125, 860),
        },
        Type = "Boss",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Colosseum Quest Giver", "Tournament Master", "Medal Vendor"},
        Region = "East Blue",
        AccessMethod = "Boat",
    },
    {
        Name = "Mysterious Dungeon",
        Level = 225,
        Sea = 1,
        Position = CFrame.new(-1400, 100, 1200),
        QuestGiver = "Dungeon Quest Giver",
        QuestPos = CFrame.new(-1380, 110, 1220),
        SpawnPoints = {
            CFrame.new(-1420, 105, 1180),
            CFrame.new(-1380, 105, 1220),
            CFrame.new(-1360, 105, 1160),
        },
        Type = "Event",
        HasShop = false,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Dungeon Quest Giver", "Dungeon Master"},
        Region = "East Blue",
        AccessMethod = "Boat",
    },
    {
        Name = "Dead Mountain",
        Level = 250,
        Sea = 1,
        Position = CFrame.new(-1100, 400, 1500),
        QuestGiver = "Dead Mountain Quest Giver",
        QuestPos = CFrame.new(-1080, 410, 1520),
        SpawnPoints = {
            CFrame.new(-1120, 405, 1480),
            CFrame.new(-1080, 405, 1520),
            CFrame.new(-1060, 405, 1460),
        },
        Type = "Boss",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Dead Mountain Quest Giver", "Undead Dealer"},
        Region = "East Blue",
        AccessMethod = "Boat",
    },
    {
        Name = "Sky Islands",
        Level = 300,
        Sea = 1,
        Position = CFrame.new(-800, 800, 1800),
        QuestGiver = "Sky Island Quest Giver",
        QuestPos = CFrame.new(-780, 810, 1820),
        SpawnPoints = {
            CFrame.new(-820, 805, 1780),
            CFrame.new(-780, 805, 1820),
            CFrame.new(-760, 805, 1760),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = true,
        NPCs = {"Sky Island Quest Giver", "Cloud Merchant", "Rumble Expert"},
        Region = "Sky Island",
        AccessMethod = "Teleport",
    },
    {
        Name = "Upper Sky",
        Level = 375,
        Sea = 1,
        Position = CFrame.new(-600, 1100, 2100),
        QuestGiver = "Upper Sky Quest Giver",
        QuestPos = CFrame.new(-580, 1110, 2120),
        SpawnPoints = {
            CFrame.new(-620, 1105, 2080),
            CFrame.new(-580, 1105, 2120),
            CFrame.new(-560, 1105, 2060),
        },
        Type = "Boss",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Upper Sky Quest Giver", "Angel Warrior", "Raid Boss"},
        Region = "Sky Island",
        AccessMethod = "Teleport",
    },
    {
        Name = "Fountain City",
        Level = 425,
        Sea = 1,
        Position = CFrame.new(-300, 1400, 2400),
        QuestGiver = "Fountain City Quest Giver",
        QuestPos = CFrame.new(-280, 1410, 2420),
        SpawnPoints = {
            CFrame.new(-320, 1405, 2380),
            CFrame.new(-280, 1405, 2420),
            CFrame.new(-260, 1405, 2360),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = true,
        NPCs = {"Fountain City Quest Giver", "Wyper", "Enel"},
        Region = "Sky Island",
        AccessMethod = "Teleport",
    },
    {
        Name = "Forgotten Island",
        Level = 475,
        Sea = 1,
        Position = CFrame.new(0, 80, 2700),
        QuestGiver = "Forgotten Island Quest Giver",
        QuestPos = CFrame.new(20, 90, 2720),
        SpawnPoints = {
            CFrame.new(-20, 85, 2680),
            CFrame.new(20, 85, 2720),
            CFrame.new(40, 85, 2660),
        },
        Type = "Boss",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Forgotten Island Quest Giver", "Sea King", "Whirlpool Master"},
        Region = "New World",
        AccessMethod = "Boat",
    },
    {
        Name = "Underwater City",
        Level = 350,
        Sea = 1,
        Position = CFrame.new(-1000, -300, 2000),
        QuestGiver = "Underwater Quest Giver",
        QuestPos = CFrame.new(-980, -290, 2020),
        SpawnPoints = {
            CFrame.new(-1020, -295, 1980),
            CFrame.new(-980, -295, 2020),
            CFrame.new(-960, -295, 1960),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Underwater Quest Giver", "Fishman Expert", "Deep Sea Merchant"},
        Region = "Underwater",
        AccessMethod = "Boat",
    },
    -- ═══════════════════════════════════════════════════════
    -- SEA 2 — NEW WORLD / PARADISE
    -- ═══════════════════════════════════════════════════════
    {
        Name = "Cafe",
        Level = 700,
        Sea = 2,
        Position = CFrame.new(-2700, 300, -1000),
        QuestGiver = "Cafe Manager",
        QuestPos = CFrame.new(-2680, 310, -980),
        SpawnPoints = {
            CFrame.new(-2720, 305, -1020),
            CFrame.new(-2680, 305, -980),
            CFrame.new(-2660, 305, -1040),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = true,
        HasTraining = true,
        NPCs = {"Cafe Manager", "Blox Fruit Dealer", "Fighting Style Teacher", "Blacksmith"},
        Region = "Cafertown",
        AccessMethod = "Teleport",
    },
    {
        Name = "Kingdom of Rose",
        Level = 750,
        Sea = 2,
        Position = CFrame.new(-2400, 280, -800),
        QuestGiver = "Kingdom of Rose Quest Giver",
        QuestPos = CFrame.new(-2380, 290, -780),
        SpawnPoints = {
            CFrame.new(-2420, 285, -820),
            CFrame.new(-2380, 285, -780),
            CFrame.new(-2360, 285, -840),
        },
        Type = "Boss",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Kingdom Quest Giver", "Diamond", "Orange Captain"},
        Region = "Green Bit",
        AccessMethod = "Walk",
    },
    {
        Name = "Green Bit",
        Level = 775,
        Sea = 2,
        Position = CFrame.new(-2100, 260, -600),
        QuestGiver = "Green Bit Quest Giver",
        QuestPos = CFrame.new(-2080, 270, -580),
        SpawnPoints = {
            CFrame.new(-2120, 265, -620),
            CFrame.new(-2080, 265, -580),
            CFrame.new(-2060, 265, -640),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Green Bit Quest Giver", "Marine Lieutenant"},
        Region = "Green Bit",
        AccessMethod = "Walk",
    },
    {
        Name = "Dressrosa",
        Level = 800,
        Sea = 2,
        Position = CFrame.new(-1800, 240, -400),
        QuestGiver = "Dressrosa Quest Giver",
        QuestPos = CFrame.new(-1780, 250, -380),
        SpawnPoints = {
            CFrame.new(-1820, 245, -420),
            CFrame.new(-1780, 245, -380),
            CFrame.new(-1760, 245, -440),
        },
        Type = "Boss",
        HasShop = true,
        HasFruitDealer = true,
        HasTraining = true,
        NPCs = {"Dressrosa Quest Giver", "Donquixote", "Colosseum Fighter", "Blox Fruit Dealer"},
        Region = "Dressrosa",
        AccessMethod = "Boat",
    },
    {
        Name = "Hot and Cold",
        Level = 850,
        Sea = 2,
        Position = CFrame.new(-1500, 220, -200),
        QuestGiver = "Hot Cold Quest Giver",
        QuestPos = CFrame.new(-1480, 230, -180),
        SpawnPoints = {
            CFrame.new(-1520, 225, -220),
            CFrame.new(-1480, 225, -180),
            CFrame.new(-1460, 225, -240),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Hot Cold Quest Giver", "Magma Admiral", "Fire Expert"},
        Region = "Hot Cold",
        AccessMethod = "Boat",
    },
    {
        Name = "Graveyard",
        Level = 900,
        Sea = 2,
        Position = CFrame.new(-1200, 200, 0),
        QuestGiver = "Graveyard Quest Giver",
        QuestPos = CFrame.new(-1180, 210, 20),
        SpawnPoints = {
            CFrame.new(-1220, 205, -20),
            CFrame.new(-1180, 205, 20),
            CFrame.new(-1160, 205, -40),
        },
        Type = "Boss",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Graveyard Quest Giver", "T-Rex", "Zombie Expert"},
        Region = "Graveyard",
        AccessMethod = "Boat",
    },
    {
        Name = "Shipwreck",
        Level = 925,
        Sea = 2,
        Position = CFrame.new(-900, 100, 200),
        QuestGiver = "Shipwreck Quest Giver",
        QuestPos = CFrame.new(-880, 110, 220),
        SpawnPoints = {
            CFrame.new(-920, 105, 180),
            CFrame.new(-880, 105, 220),
            CFrame.new(-860, 105, 160),
        },
        Type = "Event",
        HasShop = false,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Shipwreck Quest Giver", "Lost Captain"},
        Region = "Shipwreck",
        AccessMethod = "Boat",
    },
    {
        Name = "Green Zone",
        Level = 950,
        Sea = 2,
        Position = CFrame.new(-600, 180, 400),
        QuestGiver = "Green Zone Quest Giver",
        QuestPos = CFrame.new(-580, 190, 420),
        SpawnPoints = {
            CFrame.new(-620, 185, 380),
            CFrame.new(-580, 185, 420),
            CFrame.new(-560, 185, 360),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Green Zone Quest Giver", "Valkyrie", "Plant Expert"},
        Region = "Green Zone",
        AccessMethod = "Boat",
    },
    {
        Name = "Colosseum Sea 2",
        Level = 1000,
        Sea = 2,
        Position = CFrame.new(-300, 160, 600),
        QuestGiver = "Arena Master",
        QuestPos = CFrame.new(-280, 170, 620),
        SpawnPoints = {
            CFrame.new(-320, 165, 580),
            CFrame.new(-280, 165, 620),
            CFrame.new(-260, 165, 560),
        },
        Type = "Boss",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = true,
        NPCs = {"Arena Master", "Boss Swan", "Arena Champion"},
        Region = "Colosseum",
        AccessMethod = "Boat",
    },
    {
        Name = "Cursed Ship",
        Level = 1050,
        Sea = 2,
        Position = CFrame.new(0, 50, 800),
        QuestGiver = "Cursed Ship Quest Giver",
        QuestPos = CFrame.new(20, 60, 820),
        SpawnPoints = {
            CFrame.new(-20, 55, 780),
            CFrame.new(20, 55, 820),
            CFrame.new(40, 55, 760),
        },
        Type = "Event",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Cursed Ship Quest Giver", "Ghost Captain", "Cursed Merchant"},
        Region = "Cursed Ship",
        AccessMethod = "Boat",
    },
    {
        Name = "Usoapp's Island",
        Level = 1100,
        Sea = 2,
        Position = CFrame.new(300, 140, 1000),
        QuestGiver = "Usoapp Quest Giver",
        QuestPos = CFrame.new(320, 150, 1020),
        SpawnPoints = {
            CFrame.new(280, 145, 980),
            CFrame.new(320, 145, 1020),
            CFrame.new(340, 145, 960),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Usoapp Quest Giver", "Sniper"},
        Region = "Usoapp",
        AccessMethod = "Boat",
    },
    {
        Name = "Land on the Sky",
        Level = 1150,
        Sea = 2,
        Position = CFrame.new(600, 500, 1200),
        QuestGiver = "Sky Quest Giver",
        QuestPos = CFrame.new(620, 510, 1220),
        SpawnPoints = {
            CFrame.new(580, 505, 1180),
            CFrame.new(620, 505, 1220),
            CFrame.new(640, 505, 1160),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Sky Quest Giver", "Wyper"},
        Region = "Sky",
        AccessMethod = "Teleport",
    },
    {
        Name = "Frozen Village Sea 2",
        Level = 1200,
        Sea = 2,
        Position = CFrame.new(900, 300, 1400),
        QuestGiver = "Frozen Quest Giver 2",
        QuestPos = CFrame.new(920, 310, 1420),
        SpawnPoints = {
            CFrame.new(880, 305, 1380),
            CFrame.new(920, 305, 1420),
            CFrame.new(940, 305, 1360),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Frozen Quest Giver 2", "Ice Admiral"},
        Region = "Frozen",
        AccessMethod = "Boat",
    },
    -- ═══════════════════════════════════════════════════════
    -- SEA 3 — NEW WORLD / FINAL SEA
    -- ═══════════════════════════════════════════════════════
    {
        Name = "Port Town",
        Level = 1500,
        Sea = 3,
        Position = CFrame.new(-200, 100, -3000),
        QuestGiver = "Port Town Quest Giver",
        QuestPos = CFrame.new(-180, 110, -2980),
        SpawnPoints = {
            CFrame.new(-220, 105, -3020),
            CFrame.new(-180, 105, -2980),
            CFrame.new(-160, 105, -3040),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = true,
        HasTraining = true,
        NPCs = {"Port Town Quest Giver", "Blox Fruit Dealer", "Fighting Style Teacher", "Blacksmith"},
        Region = "Port Town",
        AccessMethod = "Teleport",
    },
    {
        Name = "Hydra Island",
        Level = 1575,
        Sea = 3,
        Position = CFrame.new(100, 120, -2800),
        QuestGiver = "Hydra Quest Giver",
        QuestPos = CFrame.new(120, 130, -2780),
        SpawnPoints = {
            CFrame.new(80, 125, -2820),
            CFrame.new(120, 125, -2780),
            CFrame.new(140, 125, -2840),
        },
        Type = "Boss",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Hydra Quest Giver", "Hydra Boss", "Serpent Slayer"},
        Region = "Hydra",
        AccessMethod = "Boat",
    },
    {
        Name = "Tiki Outpost",
        Level = 1600,
        Sea = 3,
        Position = CFrame.new(-500, 90, -3200),
        QuestGiver = "Tiki Quest Giver",
        QuestPos = CFrame.new(-480, 100, -3180),
        SpawnPoints = {
            CFrame.new(-520, 95, -3220),
            CFrame.new(-480, 95, -3180),
            CFrame.new(-460, 95, -3240),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = true,
        NPCs = {"Tiki Quest Giver", "Tiki Guard", "Tribe Elder"},
        Region = "Tiki",
        AccessMethod = "Boat",
    },
    {
        Name = "Floating Turtle",
        Level = 1700,
        Sea = 3,
        Position = CFrame.new(-200, 300, -2600),
        QuestGiver = "Turtle Quest Giver",
        QuestPos = CFrame.new(-180, 310, -2580),
        SpawnPoints = {
            CFrame.new(-220, 305, -2620),
            CFrame.new(-180, 305, -2580),
            CFrame.new(-160, 305, -2640),
        },
        Type = "Boss",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = true,
        NPCs = {"Turtle Quest Giver", "Kitsune", "Martial Arts Master", "Shark Anchor"},
        Region = "Turtle",
        AccessMethod = "Boat",
    },
    {
        Name = "Castle on the Sea",
        Level = 1800,
        Sea = 3,
        Position = CFrame.new(200, 350, -2400),
        QuestGiver = "Castle Quest Giver",
        QuestPos = CFrame.new(220, 360, -2380),
        SpawnPoints = {
            CFrame.new(180, 355, -2420),
            CFrame.new(220, 355, -2380),
            CFrame.new(240, 355, -2440),
        },
        Type = "Boss",
        HasShop = true,
        HasFruitDealer = true,
        HasTraining = true,
        NPCs = {"Castle Quest Giver", "Ice Queen", "Blox Fruit Dealer", "Race Reroll"},
        Region = "Castle",
        AccessMethod = "Boat",
    },
    {
        Name = "Great Tree",
        Level = 1875,
        Sea = 3,
        Position = CFrame.new(500, 500, -2200),
        QuestGiver = "Great Tree Quest Giver",
        QuestPos = CFrame.new(520, 510, -2180),
        SpawnPoints = {
            CFrame.new(480, 505, -2220),
            CFrame.new(520, 505, -2180),
            CFrame.new(540, 505, -2240),
        },
        Type = "Event",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = true,
        NPCs = {"Great Tree Quest Giver", "Leviathan", "Sea Beast Hunter"},
        Region = "Great Tree",
        AccessMethod = "Boat",
    },
    {
        Name = "Marble Island",
        Level = 1900,
        Sea = 3,
        Position = CFrame.new(800, 100, -2000),
        QuestGiver = "Marble Quest Giver",
        QuestPos = CFrame.new(820, 110, -1980),
        SpawnPoints = {
            CFrame.new(780, 105, -2020),
            CFrame.new(820, 105, -1980),
            CFrame.new(840, 105, -2040),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Marble Quest Giver", "Marble Guardian"},
        Region = "Marble",
        AccessMethod = "Boat",
    },
    {
        Name = "Haunted Castle",
        Level = 1950,
        Sea = 3,
        Position = CFrame.new(-800, 200, -1800),
        QuestGiver = "Haunted Quest Giver",
        QuestPos = CFrame.new(-780, 210, -1780),
        SpawnPoints = {
            CFrame.new(-820, 205, -1820),
            CFrame.new(-780, 205, -1780),
            CFrame.new(-760, 205, -1840),
        },
        Type = "Boss",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Haunted Quest Giver", "Ghost King", "Drip Mama"},
        Region = "Haunted",
        AccessMethod = "Boat",
    },
    {
        Name = "Sea of Treats",
        Level = 2000,
        Sea = 3,
        Position = CFrame.new(-1000, 150, -1500),
        QuestGiver = "Treats Quest Giver",
        QuestPos = CFrame.new(-980, 160, -1480),
        SpawnPoints = {
            CFrame.new(-1020, 155, -1520),
            CFrame.new(-980, 155, -1480),
            CFrame.new(-960, 155, -1540),
        },
        Type = "Event",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = true,
        NPCs = {"Treats Quest Giver", "Cake Prince", "Candy Queen"},
        Region = "Treats",
        AccessMethod = "Boat",
    },
    {
        Name = "Kitsune Island",
        Level = 2100,
        Sea = 3,
        Position = CFrame.new(600, 80, -1200),
        QuestGiver = "Kitsune Quest Giver",
        QuestPos = CFrame.new(620, 90, -1180),
        SpawnPoints = {
            CFrame.new(580, 85, -1220),
            CFrame.new(620, 85, -1180),
            CFrame.new(640, 85, -1240),
        },
        Type = "Event",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = true,
        NPCs = {"Kitsune Quest Giver", "Kitsune Boss", "Moon Merchant"},
        Region = "Kitsune",
        AccessMethod = "Boat",
    },
    {
        Name = "Tiki Outpost 2",
        Level = 2200,
        Sea = 3,
        Position = CFrame.new(-300, 70, -3500),
        QuestGiver = "Tiki 2 Quest Giver",
        QuestPos = CFrame.new(-280, 80, -3480),
        SpawnPoints = {
            CFrame.new(-320, 75, -3520),
            CFrame.new(-280, 75, -3480),
            CFrame.new(-260, 75, -3540),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = true,
        HasTraining = true,
        NPCs = {"Tiki 2 Quest Giver", "Blox Fruit Dealer", "Shark Hunter"},
        Region = "Tiki",
        AccessMethod = "Boat",
    },
    {
        Name = "Temple of Time",
        Level = 2300,
        Sea = 3,
        Position = CFrame.new(0, 700, -3800),
        QuestGiver = "Temple Guardian",
        QuestPos = CFrame.new(20, 710, -3780),
        SpawnPoints = {
            CFrame.new(-20, 705, -3820),
            CFrame.new(20, 705, -3780),
            CFrame.new(40, 705, -3840),
        },
        Type = "Event",
        HasShop = true,
        HasFruitDealer = false,
        HasTraining = true,
        NPCs = {"Temple Guardian", "Raid Boss", "Ancient Warrior"},
        Region = "Temple",
        AccessMethod = "Teleport",
    },
    {
        Name = "Port Town Sea 3",
        Level = 2400,
        Sea = 3,
        Position = CFrame.new(400, 60, -4000),
        QuestGiver = "Port Town 3 Quest Giver",
        QuestPos = CFrame.new(420, 70, -3980),
        SpawnPoints = {
            CFrame.new(380, 65, -4020),
            CFrame.new(420, 65, -3980),
            CFrame.new(440, 65, -4040),
        },
        Type = "Normal",
        HasShop = true,
        HasFruitDealer = true,
        HasTraining = true,
        NPCs = {"Port Town 3 Quest Giver", "Blox Fruit Dealer", "Elite Hunter"},
        Region = "Port Town",
        AccessMethod = "Boat",
    },
    -- ═══════════════════════════════════════════════════════
    -- RAID & SPECIAL LOCATIONS
    -- ═══════════════════════════════════════════════════════
    {
        Name = "Law Raid Island",
        Level = 1000,
        Sea = 2,
        Position = CFrame.new(-500, -500, 500),
        QuestGiver = "Law Raid Controller",
        QuestPos = CFrame.new(-480, -490, 520),
        SpawnPoints = {
            CFrame.new(-520, -495, 480),
            CFrame.new(-480, -495, 520),
        },
        Type = "Raid",
        HasShop = false,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Law Raid Controller"},
        Region = "Raid",
        AccessMethod = "Teleport",
    },
    {
        Name = "Rumble Raid Island",
        Level = 1200,
        Sea = 2,
        Position = CFrame.new(-700, -600, 700),
        QuestGiver = "Rumble Raid Controller",
        QuestPos = CFrame.new(-680, -590, 720),
        SpawnPoints = {
            CFrame.new(-720, -595, 680),
            CFrame.new(-680, -595, 720),
        },
        Type = "Raid",
        HasShop = false,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Rumble Raid Controller"},
        Region = "Raid",
        AccessMethod = "Teleport",
    },
    {
        Name = "Magma Raid Island",
        Level = 1400,
        Sea = 2,
        Position = CFrame.new(-900, -700, 900),
        QuestGiver = "Magma Raid Controller",
        QuestPos = CFrame.new(-880, -690, 920),
        SpawnPoints = {
            CFrame.new(-920, -695, 880),
            CFrame.new(-880, -695, 920),
        },
        Type = "Raid",
        HasShop = false,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Magma Raid Controller"},
        Region = "Raid",
        AccessMethod = "Teleport",
    },
    {
        Name = "Flame Raid Island",
        Level = 1600,
        Sea = 3,
        Position = CFrame.new(-1100, -800, 1100),
        QuestGiver = "Flame Raid Controller",
        QuestPos = CFrame.new(-1080, -790, 1120),
        SpawnPoints = {
            CFrame.new(-1120, -795, 1080),
            CFrame.new(-1080, -795, 1120),
        },
        Type = "Raid",
        HasShop = false,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Flame Raid Controller"},
        Region = "Raid",
        AccessMethod = "Teleport",
    },
    {
        Name = "Ice Raid Island",
        Level = 1800,
        Sea = 3,
        Position = CFrame.new(-1300, -900, 1300),
        QuestGiver = "Ice Raid Controller",
        QuestPos = CFrame.new(-1280, -890, 1320),
        SpawnPoints = {
            CFrame.new(-1320, -895, 1280),
            CFrame.new(-1280, -895, 1320),
        },
        Type = "Raid",
        HasShop = false,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Ice Raid Controller"},
        Region = "Raid",
        AccessMethod = "Teleport",
    },
    {
        Name = "Quake Raid Island",
        Level = 2000,
        Sea = 3,
        Position = CFrame.new(-1500, -1000, 1500),
        QuestGiver = "Quake Raid Controller",
        QuestPos = CFrame.new(-1480, -990, 1520),
        SpawnPoints = {
            CFrame.new(-1520, -995, 1480),
            CFrame.new(-1480, -995, 1520),
        },
        Type = "Raid",
        HasShop = false,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Quake Raid Controller"},
        Region = "Raid",
        AccessMethod = "Teleport",
    },
    {
        Name = "Order Raid Island",
        Level = 2200,
        Sea = 3,
        Position = CFrame.new(-1700, -1100, 1700),
        QuestGiver = "Order Raid Controller",
        QuestPos = CFrame.new(-1680, -1090, 1720),
        SpawnPoints = {
            CFrame.new(-1720, -1095, 1680),
            CFrame.new(-1680, -1095, 1720),
        },
        Type = "Raid",
        HasShop = false,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Order Raid Controller"},
        Region = "Raid",
        AccessMethod = "Teleport",
    },
    {
        Name = "Dough Raid Island",
        Level = 2500,
        Sea = 3,
        Position = CFrame.new(-1900, -1200, 1900),
        QuestGiver = "Dough Raid Controller",
        QuestPos = CFrame.new(-1880, -1190, 1920),
        SpawnPoints = {
            CFrame.new(-1920, -1195, 1880),
            CFrame.new(-1880, -1195, 1920),
        },
        Type = "Raid",
        HasShop = false,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Dough Raid Controller"},
        Region = "Raid",
        AccessMethod = "Teleport",
    },
    {
        Name = "Dark Raid Island",
        Level = 2700,
        Sea = 3,
        Position = CFrame.new(-2100, -1300, 2100),
        QuestGiver = "Dark Raid Controller",
        QuestPos = CFrame.new(-2080, -1290, 2120),
        SpawnPoints = {
            CFrame.new(-2120, -1295, 2080),
            CFrame.new(-2080, -1295, 2120),
        },
        Type = "Raid",
        HasShop = false,
        HasFruitDealer = false,
        HasTraining = false,
        NPCs = {"Dark Raid Controller"},
        Region = "Raid",
        AccessMethod = "Teleport",
    },
}

A.Islands.Sea1TravelPath = {
    "Starter Island",
    "Marine Fortress",
    "Shanks' Town",
    "Monkey Mountain",
    "Magma Village",
    "Frozen Village",
    "Pirate Village",
    "Prison",
    "Underwater City",
    "Baratie",
    "Colosseum",
    "Mysterious Dungeon",
    "Dead Mountain",
    "Sky Islands",
    "Upper Sky",
    "Fountain City",
    "Forgotten Island",
}

A.Islands.Sea2TravelPath = {
    "Cafe",
    "Kingdom of Rose",
    "Green Bit",
    "Dressrosa",
    "Hot and Cold",
    "Graveyard",
    "Shipwreck",
    "Green Zone",
    "Colosseum Sea 2",
    "Cursed Ship",
    "Usoapp's Island",
    "Land on the Sky",
    "Frozen Village Sea 2",
}

A.Islands.Sea3TravelPath = {
    "Port Town",
    "Hydra Island",
    "Tiki Outpost",
    "Floating Turtle",
    "Castle on the Sea",
    "Great Tree",
    "Marble Island",
    "Haunted Castle",
    "Sea of Treats",
    "Kitsune Island",
    "Tiki Outpost 2",
    "Temple of Time",
    "Port Town Sea 3",
}

A.Islands.Sea1RaidPath = {
    "Law Raid Island",
    "Rumble Raid Island",
    "Magma Raid Island",
}

A.Islands.Sea2RaidPath = {
    "Flame Raid Island",
    "Ice Raid Island",
    "Quake Raid Island",
}

A.Islands.Sea3RaidPath = {
    "Order Raid Island",
    "Dough Raid Island",
    "Dark Raid Island",
}

A.Islandsfunctions = {}

function A.Islandsfunctions.GetIsland(name)
    for _, island in ipairs(A.Islands.All) do
        if island.Name == name then
            return island
        end
    end
    return nil
end

function A.Islandsfunctions.GetIslandByLevel(level)
    local closest = nil
    local closestDist = math.huge
    for _, island in ipairs(A.Islands.All) do
        local dist = math.abs(island.Level - level)
        if dist < closestDist then
            closestDist = dist
            closest = island
        end
    end
    return closest
end

function A.Islandsfunctions.GetIslandBySea(sea)
    local result = {}
    for _, island in ipairs(A.Islands.All) do
        if island.Sea == sea then
            table.insert(result, island)
        end
    end
    return result
end

function A.Islandsfunctions.GetClosestIsland(pos)
    local closest = nil
    local closestDist = math.huge
    for _, island in ipairs(A.Islands.All) do
        local dist = (pos - island.Position.Position).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = island
        end
    end
    return closest, closestDist
end

function A.Islandsfunctions.GetIslandNPCs(name)
    local island = A.Islandsfunctions.GetIsland(name)
    if island then
        return island.NPCs or {}
    end
    return {}
end

function A.Islandsfunctions.GetIslandShops(name)
    local shops = {}
    local island = A.Islandsfunctions.GetIsland(name)
    if not island then return shops end
    for _, shop in ipairs(A.Shops.All) do
        if shop.Island == name then
            table.insert(shops, shop)
        end
    end
    return shops
end

function A.Islandsfunctions.GetIslandBosses(name)
    local bosses = {}
    local bossData = A.BossData and A.BossData.All
    for _, mob in ipairs(bossData or {}) do
        if mob.Island == name then
            table.insert(bosses, mob)
        end
    end
    return bosses
end

function A.Islandsfunctions.GetNearestIsland(pos, sea)
    local closest = nil
    local closestDist = math.huge
    for _, island in ipairs(A.Islands.All) do
        if island.Sea == sea then
            local dist = (pos - island.Position.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = island
            end
        end
    end
    return closest, closestDist
end

function A.Islandsfunctions.GetTravelPath(from, to)
    local path = A.Islands.Sea1TravelPath
    local fromIdx = nil
    local toIdx = nil
    for i, name in ipairs(path) do
        if name == from then fromIdx = i end
        if name == to then toIdx = i end
    end
    if fromIdx and toIdx then
        local result = {}
        local step = fromIdx < toIdx and 1 or -1
        local idx = fromIdx
        while idx ~= toIdx do
            table.insert(result, path[idx])
            idx = idx + step
        end
        table.insert(result, path[toIdx])
        return result
    end
    return {from, to}
end

function A.Islandsfunctions.GetSeaIslands(sea)
    return A.Islandsfunctions.GetIslandBySea(sea)
end

function A.Islandsfunctions.IsInIsland(pos, name)
    local island = A.Islandsfunctions.GetIsland(name)
    if not island then return false end
    local dist = (pos - island.Position.Position).Magnitude
    return dist < 500
end

function A.Islandsfunctions.GetSpawnPoint(name)
    local island = A.Islandsfunctions.GetIsland(name)
    if island and island.SpawnPoints and #island.SpawnPoints > 0 then
        return island.SpawnPoints[math.random(1, #island.SpawnPoints)]
    end
    return nil
end

function A.Islandsfunctions.GetIslandQuests(name)
    local quests = {}
    local island = A.Islandsfunctions.GetIsland(name)
    if not island then return quests end
    for _, quest in ipairs(A.Quests.All or {}) do
        if quest.Island == name then
            table.insert(quests, quest)
        end
    end
    return quests
end

function A.Islandsfunctions.GetIslandLevel(name)
    local island = A.Islandsfunctions.GetIsland(name)
    if island then
        return island.Level
    end
    return 0
end

function A.Islandsfunctions.TravelBetween(island1, island2)
    local i1 = A.Islandsfunctions.GetIsland(island1)
    local i2 = A.Islandsfunctions.GetIsland(island2)
    if not i1 or not i2 then return false end
    return i1.Sea == i2.Sea
end

function A.Islandsfunctions.GetFruitSpawns(name)
    local spawns = {}
    for _, fruit in ipairs(A.Fruits.Spawns or {}) do
        if fruit.Island == name then
            table.insert(spawns, fruit)
        end
    end
    return spawns
end

function A.Islandsfunctions.GetChestSpawns(name)
    local spawns = {}
    local chestData = A.Chests and A.Chests.Spawns
    for _, chest in ipairs(chestData or {}) do
        if chest.Island == name then
            table.insert(spawns, chest)
        end
    end
    return spawns
end

return A.Islands
