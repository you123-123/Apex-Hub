local A = _G.Apex
A.BossData = {}

local BD = A.BossData

BD.BossTimers = {}
BD.LastSeen = {}

BD.All = {
    -- ==========================================
    -- SEA 1 BOSSES
    -- ==========================================
    {
        Name = "Gorilla King",
        DisplayName = "Gorilla King",
        Level = 25,
        Sea = 1,
        Island = "Jungle",
        Position = CFrame.new(-1224, 7, -485),
        SpawnCFrame = CFrame.new(-1224, 7, -485),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 5250,
        Damage = 35,
        Type = "Boss",
        Rarity = "Common",
        Drops = {
            {Name = "Saber", Chance = 0.025, Type = "Weapon"},
            {Name = "Gorilla Ape Badge", Chance = 1.0, Type = "Material"},
            {Name = "Monkey Hair", Chance = 0.5, Type = "Material"},
        },
        RequiredQuest = "King of the Jungle",
        RequiredLevel = 20,
        Weakness = {"Melee", "Sword"},
        Skills = {"Smash", "Grab", "Chest Beat", "Ground Pound"},
        AggroRange = 50,
        AttackRange = 8,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Bobby",
        DisplayName = "Bobby",
        Level = 55,
        Sea = 1,
        Island = "Pirate Village",
        Position = CFrame.new(-1145, 9, -538),
        SpawnCFrame = CFrame.new(-1145, 9, -538),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 8750,
        Damage = 55,
        Type = "Boss",
        Rarity = "Common",
        Drops = {
            {Name = "Yeti Cool Machine", Chance = 0.05, Type = "Accessory"},
            {Name = "Fluffy Tail", Chance = 0.25, Type = "Material"},
        },
        RequiredQuest = "Vocal Star",
        RequiredLevel = 50,
        Weakness = {"Fruit", "Gun"},
        Skills = {"Musical Strike", "Harmonics", "Sonic Blast"},
        AggroRange = 50,
        AttackRange = 10,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Yeti",
        DisplayName = "Yeti",
        Level = 100,
        Sea = 1,
        Island = "Frozen Village",
        Position = CFrame.new(5448, 28, -1199),
        SpawnCFrame = CFrame.new(5448, 28, -1199),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 17500,
        Damage = 100,
        Type = "Boss",
        Rarity = "Uncommon",
        Drops = {
            {Name = "Yeti Cool Machine", Chance = 0.05, Type = "Accessory"},
            {Name = "Frozen Heart", Chance = 0.25, Type = "Material"},
            {Name = "Snow Wood", Chance = 0.3, Type = "Material"},
        },
        RequiredQuest = "Yeti Hunting",
        RequiredLevel = 95,
        Weakness = {"Fire", "Fruit"},
        Skills = {"Frost Breath", "Ice Smash", "Snow Tornado", "Blizzard Slam"},
        AggroRange = 55,
        AttackRange = 10,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Vice Admiral",
        DisplayName = "Vice Admiral",
        Level = 130,
        Sea = 1,
        Island = "Marine Fortress",
        Position = CFrame.new(-4843, 207, -7336),
        SpawnCFrame = CFrame.new(-4843, 207, -7336),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 28000,
        Damage = 130,
        Type = "Boss",
        Rarity = "Uncommon",
        Drops = {
            {Name = "Quan Dai Armor", Chance = 0.05, Type = "Accessory"},
            {Name = "Marine Badge", Chance = 1.0, Type = "Material"},
            {Name = "Vice Admiral Coat", Chance = 0.15, Type = "Accessory"},
        },
        RequiredQuest = "Marine Lieutenant",
        RequiredLevel = 125,
        Weakness = {"Sword", "Melee"},
        Skills = {"Naval Cannon", "Marine Spear", "Fleet Command", "Admiral's Wrath"},
        AggroRange = 55,
        AttackRange = 12,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Warden",
        DisplayName = "Warden",
        Level = 175,
        Sea = 1,
        Island = "Prison",
        Position = CFrame.new(4875, 181, 724),
        SpawnCFrame = CFrame.new(4875, 181, 724),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 40000,
        Damage = 160,
        Type = "Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "Warden's Sword", Chance = 0.15, Type = "Weapon"},
            {Name = "Justice Medal", Chance = 0.25, Type = "Material"},
            {Name = "Prison Guard Uniform", Chance = 0.1, Type = "Accessory"},
        },
        RequiredQuest = "Breakout",
        RequiredLevel = 170,
        Weakness = {"Gun", "Fruit"},
        Skills = {"Baton Strike", "Lockdown", "Cell Breaker", "Iron Fist"},
        AggroRange = 55,
        AttackRange = 10,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Chief Warden",
        DisplayName = "Chief Warden",
        Level = 190,
        Sea = 1,
        Island = "Prison",
        Position = CFrame.new(4875, 181, 724),
        SpawnCFrame = CFrame.new(4875, 181, 724),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 50000,
        Damage = 180,
        Type = "Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "Chief Warden's Key", Chance = 0.1, Type = "Material"},
            {Name = "Warden's Sword", Chance = 0.2, Type = "Weapon"},
            {Name = "Justice Medal", Chance = 0.5, Type = "Material"},
        },
        RequiredQuest = "Prison Break",
        RequiredLevel = 185,
        Weakness = {"Sword", "Fruit"},
        Skills = {"Shock Baton", "Suppression", "Warden's Fury", "Lockdown Slam"},
        AggroRange = 55,
        AttackRange = 10,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Swan",
        DisplayName = "Don Swan",
        Level = 220,
        Sea = 1,
        Island = "Colosseum",
        Position = CFrame.new(-1726, 12, -6334),
        SpawnCFrame = CFrame.new(-1726, 12, -6334),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 65000,
        Damage = 200,
        Type = "Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "Swan Glasses", Chance = 0.05, Type = "Accessory"},
            {Name = "Flamingo Cape", Chance = 0.075, Type = "Accessory"},
            {Name = "Red Arm", Chance = 0.1, Type = "Material"},
        },
        RequiredQuest = "The Don's Challenge",
        RequiredLevel = 215,
        Weakness = {"Melee", "Gun"},
        Skills = {"Flamingo Dance", "Pink Horn", "Glass Step", "Swan's Waltz"},
        AggroRange = 60,
        AttackRange = 12,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Buggy",
        DisplayName = "Buggy the Clown",
        Level = 120,
        Sea = 1,
        Island = "Orange Town",
        Position = CFrame.new(-1572, 36, -3240),
        SpawnCFrame = CFrame.new(-1572, 36, -3240),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 20000,
        Damage = 120,
        Type = "Boss",
        Rarity = "Common",
        Drops = {
            {Name = "Buggy's Sword", Chance = 0.15, Type = "Weapon"},
            {Name = "Clown Nose", Chance = 0.05, Type = "Accessory"},
            {Name = "Jolly Roger Fragment", Chance = 0.3, Type = "Material"},
        },
        RequiredQuest = "The Pirate Clown",
        RequiredLevel = 115,
        Weakness = {"Sword", "Fruit"},
        Skills = {"Chop Chop", "Knife Toss", "Baroque Bomb", "Clown Car"},
        AggroRange = 50,
        AttackRange = 10,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Captain Elephpant",
        DisplayName = "Captain Elephant",
        Level = 250,
        Sea = 1,
        Island = "Forgotten Island",
        Position = CFrame.new(-1610, 7, 627),
        SpawnCFrame = CFrame.new(-1610, 7, 627),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 75000,
        Damage = 220,
        Type = "Boss",
        Rarity = "Uncommon",
        Drops = {
            {Name = "Elephant Tusk", Chance = 0.15, Type = "Weapon"},
            {Name = "Captain's Coat", Chance = 0.05, Type = "Accessory"},
        },
        RequiredQuest = "Island Expedition",
        RequiredLevel = 245,
        Weakness = {"Gun", "Melee"},
        Skills = {"Tusks Charge", "Stomp", "Trunk Slam", "Elephant March"},
        AggroRange = 55,
        AttackRange = 12,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Sawning Admiral",
        DisplayName = "Sawning Admiral",
        Level = 325,
        Sea = 1,
        Island = "Marine Base",
        Position = CFrame.new(-4712, 206, -7823),
        SpawnCFrame = CFrame.new(-4712, 206, -7823),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 110000,
        Damage = 280,
        Type = "Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "Marine Elite Badge", Chance = 0.2, Type = "Material"},
            {Name = "Admiral's Plate", Chance = 0.05, Type = "Accessory"},
        },
        RequiredQuest = "Elite Marine Trial",
        RequiredLevel = 320,
        Weakness = {"Sword", "Fruit"},
        Skills = {"Naval Bombardment", "Marine Rush", "Anchor Slam", "Fleet Barrage"},
        AggroRange = 55,
        AttackRange = 14,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Thunder God",
        DisplayName = "Thunder God",
        Level = 350,
        Sea = 1,
        Island = "Sky Island",
        Position = CFrame.new(-7910, 5663, -1516),
        SpawnCFrame = CFrame.new(-7910, 5663, -1516),
        SpawnTime = 20,
        RespawnTime = 20,
        Health = 140000,
        Damage = 320,
        Type = "Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "Thunder Orb", Chance = 0.05, Type = "Accessory"},
            {Name = "God's Necklace", Chance = 0.025, Type = "Accessory"},
            {Name = "Thunder Stone", Chance = 0.3, Type = "Material"},
        },
        RequiredQuest = "Ascend the Sky",
        RequiredLevel = 345,
        Weakness = {"Melee", "Gun"},
        Skills = {"Thunder Bolt", "Lightning Shower", "Divine Wrath", "Storm Cloud"},
        AggroRange = 60,
        AttackRange = 15,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Wysper",
        DisplayName = "Wysper",
        Level = 275,
        Sea = 1,
        Island = "Usoapp's Island",
        Position = CFrame.new(4687, 1008, 616),
        SpawnCFrame = CFrame.new(4687, 1008, 616),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 85000,
        Damage = 240,
        Type = "Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "Wysper's Staff", Chance = 0.1, Type = "Weapon"},
            {Name = "Sky Wings", Chance = 0.025, Type = "Accessory"},
        },
        RequiredQuest = "Sky Guardian",
        RequiredLevel = 270,
        Weakness = {"Sword", "Melee"},
        Skills = {"Wind Burst", "Sky Quake", "Tornado Scream", "Azure Wind"},
        AggroRange = 60,
        AttackRange = 12,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "God Guard",
        DisplayName = "God Guard",
        Level = 375,
        Sea = 1,
        Island = "Sky Island",
        Position = CFrame.new(-4750, 5576, -1537),
        SpawnCFrame = CFrame.new(-4750, 5576, -1537),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 160000,
        Damage = 350,
        Type = "Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "God's Guard Badge", Chance = 0.25, Type = "Material"},
            {Name = "Thunder Staff", Chance = 0.05, Type = "Weapon"},
        },
        RequiredQuest = "Guardian of the Divine",
        RequiredLevel = 370,
        Weakness = {"Gun", "Fruit"},
        Skills = {"Divine Guard", "Holy Smite", "Sky Pillar", "Guardian Descent"},
        AggroRange = 55,
        AttackRange = 10,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Shanks",
        DisplayName = "Red-Haired Shanks",
        Level = 650,
        Sea = 1,
        Island = "Shanks Arena",
        Position = CFrame.new(-1390, 45, 669),
        SpawnCFrame = CFrame.new(-1390, 45, 669),
        SpawnTime = 30,
        RespawnTime = 30,
        Health = 600000,
        Damage = 800,
        Type = "Legend",
        Rarity = "Legendary",
        Drops = {
            {Name = "Haki Shard", Chance = 0.1, Type = "Material"},
            {Name = "Gryphon", Chance = 0.02, Type = "Weapon"},
            {Name = "Red-Haired Bandana", Chance = 0.01, Type = "Accessory"},
            {Name = "Conqueror's Haki Essence", Chance = 0.005, Type = "Material"},
        },
        RequiredQuest = "Challenge the Emperor",
        RequiredLevel = 650,
        Weakness = {"Fruit", "Sword"},
        Skills = {"Divine Thrust", "Red Hawk", "Conqueror's Haki", "Gryphon Rush", "Divine Clash"},
        AggroRange = 70,
        AttackRange = 15,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Blackbeard",
        DisplayName = "Marshall D. Teach",
        Level = 750,
        Sea = 1,
        Island = "Graveyard Island",
        Position = CFrame.new(3340, 53, -6140),
        SpawnCFrame = CFrame.new(3340, 53, -6140),
        SpawnTime = 30,
        RespawnTime = 30,
        Health = 900000,
        Damage = 1000,
        Type = "Legend",
        Rarity = "Legendary",
        Drops = {
            {Name = "Dark Dark Fruit", Chance = 0.05, Type = "Fruit"},
            {Name = "Blackbeard's Coat", Chance = 0.01, Type = "Accessory"},
            {Name = "Yami Yami no Mi Essence", Chance = 0.02, Type = "Material"},
        },
        RequiredQuest = "Face the Darkness",
        RequiredLevel = 750,
        Weakness = {"Light", "Melee"},
        Skills = {"Black Hole", "Liberation", "Dark Veil", "Quake Fist", "Gravity Pull"},
        AggroRange = 70,
        AttackRange = 15,
        IsEvent = false,
        Events = {},
    },

    -- ==========================================
    -- SEA 2 BOSSES
    -- ==========================================
    {
        Name = "Diamond",
        DisplayName = "Diamond",
        Level = 750,
        Sea = 2,
        Island = "Hot and Cold",
        Position = CFrame.new(3865, 28, -2045),
        SpawnCFrame = CFrame.new(3865, 28, -2045),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 350000,
        Damage = 500,
        Type = "Boss",
        Rarity = "Uncommon",
        Drops = {
            {Name = "Diamond Gem", Chance = 0.05, Type = "Accessory"},
            {Name = "Heat Blade Fragment", Chance = 0.2, Type = "Material"},
        },
        RequiredQuest = "Hot and Cold",
        RequiredLevel = 700,
        Weakness = {"Melee", "Sword"},
        Skills = {"Diamond Crash", "Gem Burst", "Crystal Shield", "Prismatic Beam"},
        AggroRange = 60,
        AttackRange = 12,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Jeremy",
        DisplayName = "Jeremy",
        Level = 850,
        Sea = 2,
        Island = "Mountain",
        Position = CFrame.new(-608, 400, 818),
        SpawnCFrame = CFrame.new(-608, 400, 818),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 500000,
        Damage = 600,
        Type = "Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "Gryphon", Chance = 0.02, Type = "Weapon"},
            {Name = "Jeremy's Medal", Chance = 0.15, Type = "Material"},
        },
        RequiredQuest = "Mountain Bandit",
        RequiredLevel = 850,
        Weakness = {"Fruit", "Gun"},
        Skills = {"Heavenly Piercer", "Sky Dive", "Dragon Crash", "Summit Strike"},
        AggroRange = 65,
        AttackRange = 12,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Fajita",
        DisplayName = "Fajita",
        Level = 925,
        Sea = 2,
        Island = "Graveyard",
        Position = CFrame.new(5136, 555, -1608),
        SpawnCFrame = CFrame.new(5136, 555, -1608),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 600000,
        Damage = 650,
        Type = "Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "Gravity Cleave", Chance = 0.025, Type = "Weapon"},
            {Name = "Gravity Gem", Chance = 0.05, Type = "Accessory"},
            {Name = "Fajita's Cape", Chance = 0.1, Type = "Accessory"},
        },
        RequiredQuest = "Gravestone Guardian",
        RequiredLevel = 920,
        Weakness = {"Sword", "Melee"},
        Skills = {"Gravity Pull", "Meteor Rain", "Dimension Slash", "Gravity Slam"},
        AggroRange = 60,
        AttackRange = 14,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Don Swan",
        DisplayName = "Don Swan",
        Level = 1000,
        Sea = 2,
        Island = "Cursed Ship",
        Position = CFrame.new(-9500, 137, 5269),
        SpawnCFrame = CFrame.new(-9500, 137, 5269),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 700000,
        Damage = 700,
        Type = "Boss",
        Rarity = "Epic",
        Drops = {
            {Name = "Swan Glasses", Chance = 0.025, Type = "Accessory"},
            {Name = "Flamingo Cape", Chance = 0.025, Type = "Accessory"},
            {Name = "Swan's Feather", Chance = 0.15, Type = "Material"},
        },
        RequiredQuest = "The Cursed Captain",
        RequiredLevel = 995,
        Weakness = {"Gun", "Fruit"},
        Skills = {"Pink Haze", "Flamingo Barrage", "Phosphor Claw", "Swan's Lament"},
        AggroRange = 65,
        AttackRange = 12,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Smoke Admiral",
        DisplayName = "Smoke Admiral",
        Level = 1100,
        Sea = 2,
        Island = "Ice Fortress",
        Position = CFrame.new(4557, 380, -1806),
        SpawnCFrame = CFrame.new(4557, 380, -1806),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 800000,
        Damage = 750,
        Type = "Boss",
        Rarity = "Epic",
        Drops = {
            {Name = "Smoke Badge", Chance = 0.05, Type = "Material"},
            {Name = "Admiral's Coat", Chance = 0.02, Type = "Accessory"},
        },
        RequiredQuest = "Frozen Fortress Assault",
        RequiredLevel = 1095,
        Weakness = {"Melee", "Sword"},
        Skills = {"White Blow", "White Launcher", "White Punch", "White Smog", "White Hurricane"},
        AggroRange = 60,
        AttackRange = 12,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Awakened Ice Admiral",
        DisplayName = "Awakened Ice Admiral",
        Level = 1150,
        Sea = 2,
        Island = "Forgotten Island",
        Position = CFrame.new(3990, 330, -1826),
        SpawnCFrame = CFrame.new(3990, 330, -1826),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 900000,
        Damage = 800,
        Type = "Boss",
        Rarity = "Epic",
        Drops = {
            {Name = "Ice Essence", Chance = 0.02, Type = "Accessory"},
            {Name = "Frozen Crystal", Chance = 0.25, Type = "Material"},
            {Name = "Admiral's Helm", Chance = 0.03, Type = "Accessory"},
        },
        RequiredQuest = "Frozen Calamity",
        RequiredLevel = 1145,
        Weakness = {"Fire", "Fruit"},
        Skills = {"Ice Age", "Frozen Swamp", "Glacial Surge", "Absolute Zero"},
        AggroRange = 65,
        AttackRange = 14,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Ice Admiral",
        DisplayName = "Ice Admiral",
        Level = 1150,
        Sea = 2,
        Island = "Frozen Village",
        Position = CFrame.new(5482, 28, -6169),
        SpawnCFrame = CFrame.new(5482, 28, -6169),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 850000,
        Damage = 780,
        Type = "Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "Ice Essence", Chance = 0.02, Type = "Accessory"},
            {Name = "Frozen Heart", Chance = 0.3, Type = "Material"},
        },
        RequiredQuest = "Ice Cold Threat",
        RequiredLevel = 1145,
        Weakness = {"Fire", "Melee"},
        Skills = {"Ice Spears", "Frost Vortex", "Frozen Ground", "Glacier Crush"},
        AggroRange = 60,
        AttackRange = 14,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Kilo Admiral",
        DisplayName = "Kilo Admiral",
        Level = 1175,
        Sea = 2,
        Island = "Hot and Cold",
        Position = CFrame.new(4567, 398, -1829),
        SpawnCFrame = CFrame.new(4567, 398, -1829),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 950000,
        Damage = 820,
        Type = "Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "Kilo Helmet", Chance = 0.05, Type = "Accessory"},
            {Name = "Heavy Metal Shard", Chance = 0.25, Type = "Material"},
        },
        RequiredQuest = "Heavy Weight",
        RequiredLevel = 1170,
        Weakness = {"Sword", "Gun"},
        Skills = {"Kilo Crush", "Weight Slam", "Heavy Meteor", "Giant Stomp"},
        AggroRange = 60,
        AttackRange = 15,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Captain Elephant",
        DisplayName = "Captain Elephant",
        Level = 1200,
        Sea = 2,
        Island = "Forgotten Island",
        Position = CFrame.new(-1610, 7, 627),
        SpawnCFrame = CFrame.new(-1610, 7, 627),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 1000000,
        Damage = 850,
        Type = "Boss",
        Rarity = "Uncommon",
        Drops = {
            {Name = "Elephant Tusk", Chance = 0.1, Type = "Weapon"},
            {Name = "Captain's Band", Chance = 0.05, Type = "Accessory"},
        },
        RequiredQuest = "Island Expedition",
        RequiredLevel = 1195,
        Weakness = {"Melee", "Fruit"},
        Skills = {"Tusks Charge", "Trunk Whip", "Elephant Rush", "Savannah Stomp"},
        AggroRange = 55,
        AttackRange = 12,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Beautiful Pirate",
        DisplayName = "Beautiful Pirate",
        Level = 1250,
        Sea = 2,
        Island = "Emerald Kingdom",
        Position = CFrame.new(3523, 180, 2222),
        SpawnCFrame = CFrame.new(3523, 180, 2222),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 1100000,
        Damage = 900,
        Type = "Boss",
        Rarity = "Epic",
        Drops = {
            {Name = "Bisento", Chance = 0.025, Type = "Weapon"},
            {Name = "Pearl Necklace", Chance = 0.02, Type = "Accessory"},
            {Name = "Beautiful Rose", Chance = 0.1, Type = "Material"},
        },
        RequiredQuest = "Emerald Confrontation",
        RequiredLevel = 1245,
        Weakness = {"Sword", "Gun"},
        Skills = {"Quake Fist", "Tremor Pulse", "Seaquake", "Bisento Slam", "Beauty's Wrath"},
        AggroRange = 65,
        AttackRange = 14,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Tide Keeper",
        DisplayName = "Tide Keeper",
        Level = 1275,
        Sea = 2,
        Island = "Deep Sea",
        Position = CFrame.new(1630, 813, -4041),
        SpawnCFrame = CFrame.new(1630, 813, -4041),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 1200000,
        Damage = 950,
        Type = "Boss",
        Rarity = "Epic",
        Drops = {
            {Name = "Dragon Trident", Chance = 0.02, Type = "Weapon"},
            {Name = "Leviathan's Scale", Chance = 0.05, Type = "Material"},
            {Name = "Tide Crown", Chance = 0.03, Type = "Accessory"},
        },
        RequiredQuest = "Deep Ocean Guardian",
        RequiredLevel = 1270,
        Weakness = {"Fruit", "Melee"},
        Skills = {"Tidal Wave", "Kraken Grasp", "Ocean Abyss", "Sea Dragon Trident", "Depths Embrace"},
        AggroRange = 65,
        AttackRange = 15,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Order",
        DisplayName = "Order",
        Level = 1300,
        Sea = 2,
        Island = "Law's Room",
        Position = CFrame.new(7647, 358, 5633),
        SpawnCFrame = CFrame.new(7647, 358, 5633),
        SpawnTime = 20,
        RespawnTime = 20,
        Health = 1500000,
        Damage = 1000,
        Type = "Boss",
        Rarity = "Epic",
        Drops = {
            {Name = "Kikoku", Chance = 0.015, Type = "Weapon"},
            {Name = "Ope Ope no Mi Essence", Chance = 0.03, Type = "Material"},
            {Name = "Room Shard", Chance = 0.2, Type = "Material"},
        },
        RequiredQuest = "The Surgeon's Challenge",
        RequiredLevel = 1295,
        Weakness = {"Melee", "Gun"},
        Skills = {"Room", "Shambles", "Counter Shock", "Gamma Knife", "Takt", "K-Room"},
        AggroRange = 70,
        AttackRange = 16,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Darkbeard",
        DisplayName = "Darkbeard",
        Level = 1400,
        Sea = 2,
        Island = "Dark Arena",
        Position = CFrame.new(3830, 12, 6898),
        SpawnCFrame = CFrame.new(3830, 12, 6898),
        SpawnTime = 25,
        RespawnTime = 25,
        Health = 2000000,
        Damage = 1100,
        Type = "Raid Boss",
        Rarity = "Epic",
        Drops = {
            {Name = "Dark Blade V3", Chance = 0.01, Type = "Weapon"},
            {Name = "Blackbeard's Hook", Chance = 0.025, Type = "Accessory"},
            {Name = "Dark Essence", Chance = 0.15, Type = "Material"},
        },
        RequiredQuest = "Summon the Dark One",
        RequiredLevel = 1395,
        Weakness = {"Light", "Sword"},
        Skills = {"Dark Rift", "Black Void", "Dark Drain", "Negative Hollow", "Dark Abyss"},
        AggroRange = 70,
        AttackRange = 16,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Rip_Indra",
        DisplayName = "Rip_Indra",
        Level = 1500,
        Sea = 2,
        Island = "Hot and Cold",
        Position = CFrame.new(-5465, 314, -5251),
        SpawnCFrame = CFrame.new(-5465, 314, -5251),
        SpawnTime = 30,
        RespawnTime = 30,
        Health = 2500000,
        Damage = 1200,
        Type = "Raid Boss",
        Rarity = "Legendary",
        Drops = {
            {Name = "Valkyrie Helm", Chance = 0.05, Type = "Accessory"},
            {Name = "Dark Dagger", Chance = 0.01, Type = "Weapon"},
            {Name = "God's Cloth", Chance = 0.025, Type = "Accessory"},
            {Name = "Elite Hunter Badge", Chance = 0.5, Type = "Material"},
        },
        RequiredQuest = "Defeat Rip_Indra",
        RequiredLevel = 1490,
        Weakness = {"Fruit", "Melee"},
        Skills = {"Haki Slam", "Dark Rush", "Conqueror's Wrath", "Inferno Slash", "Void Strike"},
        AggroRange = 75,
        AttackRange = 18,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Awakened Pain",
        DisplayName = "Awakened Pain",
        Level = 1350,
        Sea = 2,
        Island = "Law's Room",
        Position = CFrame.new(7755, 392, 5699),
        SpawnCFrame = CFrame.new(7755, 392, 5699),
        SpawnTime = 20,
        RespawnTime = 20,
        Health = 1800000,
        Damage = 1050,
        Type = "Raid Boss",
        Rarity = "Epic",
        Drops = {
            {Name = "Pain's Cape", Chance = 0.02, Type = "Accessory"},
            {Name = "Soul Fruit Essence", Chance = 0.1, Type = "Material"},
            {Name = "Ope Shard", Chance = 0.25, Type = "Material"},
        },
        RequiredQuest = "Awakening Trial",
        RequiredLevel = 1345,
        Weakness = {"Gun", "Sword"},
        Skills = {"Pain Zone", "Torment", "Paralyze", "Soul Torture", "Agony Surge"},
        AggroRange = 70,
        AttackRange = 16,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Core Brain",
        DisplayName = "Core Brain",
        Level = 1000,
        Sea = 2,
        Island = "Cursed Ship",
        Position = CFrame.new(-9400, 150, 5300),
        SpawnCFrame = CFrame.new(-9400, 150, 5300),
        SpawnTime = 20,
        RespawnTime = 20,
        Health = 750000,
        Damage = 700,
        Type = "Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "Core Chip", Chance = 0.1, Type = "Material"},
            {Name = "Cyborg Arm", Chance = 0.02, Type = "Accessory"},
        },
        RequiredQuest = "Machine Intelligence",
        RequiredLevel = 995,
        Weakness = {"Fruit", "Melee"},
        Skills = {"Laser Beam", "EMP Pulse", "Missile Barrage", "Core Shield"},
        AggroRange = 60,
        AttackRange = 20,
        IsEvent = false,
        Events = {},
    },

    -- ==========================================
    -- SEA 3 BOSSES
    -- ==========================================
    {
        Name = "Stone",
        DisplayName = "Stone",
        Level = 1550,
        Sea = 3,
        Island = "Port Town",
        Position = CFrame.new(4922, 5, -5461),
        SpawnCFrame = CFrame.new(4922, 5, -5461),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 3000000,
        Damage = 1200,
        Type = "Boss",
        Rarity = "Uncommon",
        Drops = {
            {Name = "Stone Hammer", Chance = 0.05, Type = "Weapon"},
            {Name = "Stone Gem", Chance = 0.15, Type = "Material"},
        },
        RequiredQuest = "Port Town Trouble",
        RequiredLevel = 1545,
        Weakness = {"Melee", "Fruit"},
        Skills = {"Rock Slide", "Boulder Throw", "Earthquake", "Stone Slam"},
        AggroRange = 60,
        AttackRange = 12,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Kaido",
        DisplayName = "Kaido, The Beast",
        Level = 1750,
        Sea = 3,
        Island = "Hot and Cold",
        Position = CFrame.new(-5500, 314, -5300),
        SpawnCFrame = CFrame.new(-5500, 314, -5300),
        SpawnTime = 30,
        RespawnTime = 30,
        Health = 5000000,
        Damage = 1500,
        Type = "Raid Boss",
        Rarity = "Legendary",
        Drops = {
            {Name = "Dragon Scale Armor", Chance = 0.01, Type = "Accessory"},
            {Name = "Thunder Bagua", Chance = 0.015, Type = "Weapon"},
            {Name = "Oni Horn", Chance = 0.05, Type = "Material"},
            {Name = "Zoan Essence", Chance = 0.03, Type = "Material"},
        },
        RequiredQuest = "Challenge the Strongest Creature",
        RequiredLevel = 1745,
        Weakness = {"Dragon", "Sword"},
        Skills = {"Boro Breath", "Thunder Bagua", "Dragon Transformation", "Blast Breath", "Ragnaraku", "Conqueror's Coating"},
        AggroRange = 80,
        AttackRange = 20,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Longma",
        DisplayName = "Longma",
        Level = 1600,
        Sea = 3,
        Island = "Floating Turtle",
        Position = CFrame.new(-10395, 331, -2764),
        SpawnCFrame = CFrame.new(-10395, 331, -2764),
        SpawnTime = 20,
        RespawnTime = 20,
        Health = 3500000,
        Damage = 1300,
        Type = "Boss",
        Rarity = "Epic",
        Drops = {
            {Name = "Dragon Lance", Chance = 0.02, Type = "Weapon"},
            {Name = "Longma's Mane", Chance = 0.1, Type = "Material"},
        },
        RequiredQuest = "Dragon Slayer",
        RequiredLevel = 1595,
        Weakness = {"Melee", "Gun"},
        Skills = {"Dragon Breath", "Timber Toss", "Dragon Tornado", "Serpent Strike"},
        AggroRange = 65,
        AttackRange = 15,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Cake Prince",
        DisplayName = "Cake Prince",
        Level = 2000,
        Sea = 3,
        Island = "Cake Land",
        Position = CFrame.new(-1820, 40, -12488),
        SpawnCFrame = CFrame.new(-1820, 40, -12488),
        SpawnTime = 25,
        RespawnTime = 25,
        Health = 7000000,
        Damage = 1700,
        Type = "Event Boss",
        Rarity = "Legendary",
        Drops = {
            {Name = "Sweet Chalice", Chance = 0.02, Type = "Accessory"},
            {Name = "Dough Crystal", Chance = 0.05, Type = "Material"},
            {Name = "Cake Hat", Chance = 0.1, Type = "Accessory"},
            {Name = "Sugar Rush", Chance = 0.15, Type = "Material"},
        },
        RequiredQuest = "The Cake Prince Rising",
        RequiredLevel = 1990,
        Weakness = {"Fire", "Sword"},
        Skills = {"Dough Fist", "Pastry Slam", "Cake Roll", "Sticky Rice Trap", "Sugar Prison"},
        AggroRange = 70,
        AttackRange = 16,
        IsEvent = true,
        Events = {"Cake Prince Event"},
    },
    {
        Name = "Dough King",
        DisplayName = "Dough King",
        Level = 2250,
        Sea = 3,
        Island = "Cake Land",
        Position = CFrame.new(-1920, 40, -12588),
        SpawnCFrame = CFrame.new(-1920, 40, -12588),
        SpawnTime = 30,
        RespawnTime = 30,
        Health = 10000000,
        Damage = 2000,
        Type = "Event Boss",
        Rarity = "Mythical",
        Drops = {
            {Name = "Dough Fruit", Chance = 0.05, Type = "Fruit"},
            {Name = "Dough King's Crown", Chance = 0.01, Type = "Accessory"},
            {Name = "Dough Crystal", Chance = 0.1, Type = "Material"},
            {Name = "Tyrant's Cape", Chance = 0.02, Type = "Accessory"},
        },
        RequiredQuest = "Defeat the Dough King",
        RequiredLevel = 2240,
        Weakness = {"Light", "Melee"},
        Skills = {"Dough Slap", "Pastry Barrage", "Mochi Roll", "Dough Spiral", "Vicious Sadness", "King's Decree"},
        AggroRange = 80,
        AttackRange = 18,
        IsEvent = true,
        Events = {"Cake Prince Event", "Dough King Event"},
    },
    {
        Name = "Rip_Indra_Sea3",
        DisplayName = "Rip_Indra",
        Level = 1700,
        Sea = 3,
        Island = "Castle on the Sea",
        Position = CFrame.new(-5083, 314, -3185),
        SpawnCFrame = CFrame.new(-5083, 314, -3185),
        SpawnTime = 30,
        RespawnTime = 30,
        Health = 4500000,
        Damage = 1400,
        Type = "Raid Boss",
        Rarity = "Legendary",
        Drops = {
            {Name = "Valkyrie Helm", Chance = 0.05, Type = "Accessory"},
            {Name = "Dark Dagger", Chance = 0.01, Type = "Weapon"},
            {Name = "God's Cloth", Chance = 0.025, Type = "Accessory"},
        },
        RequiredQuest = "Indra's Wrath",
        RequiredLevel = 1690,
        Weakness = {"Fruit", "Sword"},
        Skills = {"Haki Raging God", "Dark Vortex", "Conqueror's Haki", "Heavenly Dawn", "Dimension Slash"},
        AggroRange = 75,
        AttackRange = 18,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Core Brain Sea3",
        DisplayName = "Core Brain",
        Level = 1650,
        Sea = 3,
        Island = "Haunted Castle",
        Position = CFrame.new(10341, 170, -6801),
        SpawnCFrame = CFrame.new(10341, 170, -6801),
        SpawnTime = 20,
        RespawnTime = 20,
        Health = 3200000,
        Damage = 1250,
        Type = "Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "Core Chip V2", Chance = 0.08, Type = "Material"},
            {Name = "Cyborg Core", Chance = 0.03, Type = "Accessory"},
        },
        RequiredQuest = "Haunted Machine",
        RequiredLevel = 1645,
        Weakness = {"Fruit", "Gun"},
        Skills = {"Laser Array", "EMP Burst", "Drone Swarm", "Core Overload"},
        AggroRange = 65,
        AttackRange = 22,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Fearful Ghost",
        DisplayName = "Fearful Ghost",
        Level = 1850,
        Sea = 3,
        Island = "Haunted Castle",
        Position = CFrame.new(10200, 150, -6900),
        SpawnCFrame = CFrame.new(10200, 150, -6900),
        SpawnTime = 15,
        RespawnTime = 15,
        Health = 3800000,
        Damage = 1350,
        Type = "Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "Ghost Token", Chance = 0.2, Type = "Material"},
            {Name = "Spectral Cape", Chance = 0.03, Type = "Accessory"},
            {Name = "Soul Guitar Essence", Chance = 0.01, Type = "Material"},
        },
        RequiredQuest = "Haunted Horror",
        RequiredLevel = 1845,
        Weakness = {"Light", "Fruit"},
        Skills = {"Phantom Wail", "Soul Drain", "Ghost Roar", "Terror Scream", "Haunting"},
        AggroRange = 65,
        AttackRange = 14,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Soul Reaper",
        DisplayName = "Soul Reaper",
        Level = 1900,
        Sea = 3,
        Island = "Haunted Castle",
        Position = CFrame.new(9230, 125, -8740),
        SpawnCFrame = CFrame.new(9230, 125, -8740),
        SpawnTime = 25,
        RespawnTime = 25,
        Health = 5500000,
        Damage = 1550,
        Type = "Raid Boss",
        Rarity = "Legendary",
        Drops = {
            {Name = "Soul Guitar", Chance = 0.01, Type = "Weapon"},
            {Name = "Hallow Essence", Chance = 0.03, Type = "Material"},
            {Name = "Reaper Mask", Chance = 0.02, Type = "Accessory"},
            {Name = "Soul Candy", Chance = 0.15, Type = "Material"},
        },
        RequiredQuest = "Reap What You Sow",
        RequiredLevel = 1895,
        Weakness = {"Light", "Melee"},
        Skills = {"Soul Execution", "Death's Hand", "Spectral Scythe", "Harvest", "Phantom Slash", "Soul Eater"},
        AggroRange = 75,
        AttackRange = 16,
        IsEvent = false,
        Events = {},
    },
    {
        Name = "Leviathan",
        DisplayName = "Leviathan",
        Level = 2500,
        Sea = 3,
        Island = "Tiki Outpost",
        Position = CFrame.new(-16820, 30, 4820),
        SpawnCFrame = CFrame.new(-16820, 30, 4820),
        SpawnTime = 45,
        RespawnTime = 45,
        Health = 15000000,
        Damage = 3000,
        Type = "Event Boss",
        Rarity = "Mythical",
        Drops = {
            {Name = "Leviathan Heart", Chance = 0.05, Type = "Material"},
            {Name = "Shark Anchor", Chance = 0.01, Type = "Weapon"},
            {Name = "Leviathan Shield", Chance = 0.015, Type = "Accessory"},
            {Name = "Terror Eye", Chance = 0.1, Type = "Material"},
            {Name = "Scales of the Deep", Chance = 0.2, Type = "Material"},
        },
        RequiredQuest = "Leviathan Hunt",
        RequiredLevel = 2450,
        Weakness = {"Electric", "Sword"},
        Skills = {"Tidal Crash", "Leviathan Bite", "Deep Sea Wrath", "Whirlpool", "Abyssal Roar", "Ocean Titan"},
        AggroRange = 100,
        AttackRange = 25,
        IsEvent = true,
        Events = {"Leviathan Event", "Sea Event"},
    },
    {
        Name = "Kitsune",
        DisplayName = "Kitsune",
        Level = 2300,
        Sea = 3,
        Island = "Tiki Outpost",
        Position = CFrame.new(-15230, 40, 5200),
        SpawnCFrame = CFrame.new(-15230, 40, 5200),
        SpawnTime = 30,
        RespawnTime = 30,
        Health = 8000000,
        Damage = 2200,
        Type = "Event Boss",
        Rarity = "Legendary",
        Drops = {
            {Name = "Kitsune Tail", Chance = 0.05, Type = "Material"},
            {Name = "Azure Ember", Chance = 0.03, Type = "Material"},
            {Name = "Fox Lamp", Chance = 0.01, Type = "Weapon"},
            {Name = "Kitsune Ribbon", Chance = 0.02, Type = "Accessory"},
        },
        RequiredQuest = "Hunt the Kitsune",
        RequiredLevel = 2280,
        Weakness = {"Fire", "Melee"},
        Skills = {"Fox Fire", "Tails Barrage", "Kitsune Rush", "Azure Dance", "Moonlit Howl"},
        AggroRange = 80,
        AttackRange = 18,
        IsEvent = true,
        Events = {"Full Moon Event", "Kitsune Event"},
    },
    {
        Name = "Terror Shark",
        DisplayName = "Terror Shark",
        Level = 2100,
        Sea = 3,
        Island = "Great Tree",
        Position = CFrame.new(-12250, 10, 8500),
        SpawnCFrame = CFrame.new(-12250, 10, 8500),
        SpawnTime = 25,
        RespawnTime = 25,
        Health = 6000000,
        Damage = 1800,
        Type = "Event Boss",
        Rarity = "Epic",
        Drops = {
            {Name = "Shark Tooth Necklace", Chance = 0.03, Type = "Accessory"},
            {Name = "Terror Jaw", Chance = 0.05, Type = "Material"},
            {Name = "Shark Scale", Chance = 0.2, Type = "Material"},
        },
        RequiredQuest = "Terror from the Deep",
        RequiredLevel = 2090,
        Weakness = {"Electric", "Gun"},
        Skills = {"Shark Bite", "Terror Charge", "Jaw Snap", "Deep Frenzy", "Blood in the Water"},
        AggroRange = 75,
        AttackRange = 15,
        IsEvent = true,
        Events = {"Sea Event", "Shark Event"},
    },
    {
        Name = "Shark Anchor",
        DisplayName = "Shark Anchor",
        Level = 2200,
        Sea = 3,
        Island = "Tiki Outpost",
        Position = CFrame.new(-16900, 25, 4900),
        SpawnCFrame = CFrame.new(-16900, 25, 4900),
        SpawnTime = 30,
        RespawnTime = 30,
        Health = 7000000,
        Damage = 1900,
        Type = "Event Boss",
        Rarity = "Epic",
        Drops = {
            {Name = "Shark Anchor", Chance = 0.015, Type = "Weapon"},
            {Name = "Anchor Chain", Chance = 0.1, Type = "Material"},
            {Name = "Shark Hunter Cloak", Chance = 0.03, Type = "Accessory"},
        },
        RequiredQuest = "Shark Hunting Grounds",
        RequiredLevel = 2190,
        Weakness = {"Light", "Fruit"},
        Skills = {"Anchor Toss", "Shark Rush", "Deep Anchor Slam", "Sea Chain", "Predator's Mark"},
        AggroRange = 75,
        AttackRange = 18,
        IsEvent = true,
        Events = {"Sea Event", "Shark Event"},
    },
    {
        Name = "Sea Beast",
        DisplayName = "Sea Beast",
        Level = 2000,
        Sea = 3,
        Island = "Open Sea",
        Position = CFrame.new(0, 0, 0),
        SpawnCFrame = CFrame.new(0, 10, 0),
        SpawnTime = 20,
        RespawnTime = 20,
        Health = 5000000,
        Damage = 1600,
        Type = "Event Boss",
        Rarity = "Rare",
        Drops = {
            {Name = "Beast Core", Chance = 0.05, Type = "Material"},
            {Name = "Sea Beast Scale", Chance = 0.15, Type = "Material"},
            {Name = "Beast Blood", Chance = 0.25, Type = "Material"},
        },
        RequiredQuest = "Sea Beast Sighting",
        RequiredLevel = 1990,
        Weakness = {"Light", "Electric"},
        Skills = {"Tidal Wave", "Beast Roar", "Deep Dive", "Water Cannon", "Tail Slam"},
        AggroRange = 100,
        AttackRange = 20,
        IsEvent = true,
        Events = {"Sea Event", "Sea Beast Spawn"},
    },
}

BD.Sea1 = {}
BD.Sea2 = {}
BD.Sea3 = {}
BD.Event = {}
BD.Raid = {}
BD.SeaBeast = {}

for _, boss in ipairs(BD.All) do
    if boss.Sea == 1 then
        BD.Sea1[#BD.Sea1 + 1] = boss
    elseif boss.Sea == 2 then
        BD.Sea2[#BD.Sea2 + 1] = boss
    elseif boss.Sea == 3 then
        BD.Sea3[#BD.Sea3 + 1] = boss
    end
    if boss.IsEvent then
        BD.Event[#BD.Event + 1] = boss
    end
    if boss.Type == "Raid Boss" then
        BD.Raid[#BD.Raid + 1] = boss
    end
    if boss.Name == "Sea Beast" or boss.Name == "Terror Shark" or boss.Name == "Leviathan" or boss.Name == "Shark Anchor" then
        BD.SeaBeast[#BD.SeaBeast + 1] = boss
    end
end

local bossLookup = {}
for _, boss in ipairs(BD.All) do
    bossLookup[string.lower(boss.Name)] = boss
end

function BD.GetBoss(name)
    if not name then return nil end
    local key = string.lower(name)
    return bossLookup[key] or nil
end

function BD.GetBossLevel(name)
    local boss = BD.GetBoss(name)
    if boss then
        return boss.Level
    end
    return 0
end

function BD.GetBossPosition(name)
    local boss = BD.GetBoss(name)
    if boss then
        return boss.Position
    end
    return CFrame.new(0, 0, 0)
end

function BD.GetBossDrops(name)
    local boss = BD.GetBoss(name)
    if boss then
        return boss.Drops
    end
    return {}
end

function BD.GetBossTime()
    local now = tick()
    local soonest = math.huge
    local soonestName = ""
    for _, boss in ipairs(BD.All) do
        local lastSeen = BD.LastSeen[boss.Name] or 0
        local elapsed = now - lastSeen
        local spawnInterval = boss.RespawnTime * 60
        local remaining = spawnInterval - elapsed
        if remaining < 0 then
            remaining = 0
        end
        if remaining < soonest then
            soonest = remaining
            soonestName = boss.Name
        end
    end
    return soonest, soonestName
end

function BD.GetBossTimer(name)
    local boss = BD.GetBoss(name)
    if not boss then
        return 0
    end
    local now = tick()
    local lastSeen = BD.LastSeen[name] or 0
    local elapsed = now - lastSeen
    local spawnInterval = boss.RespawnTime * 60
    local remaining = spawnInterval - elapsed
    if remaining < 0 then
        remaining = 0
    end
    return remaining
end

function BD.IsBossAlive(name)
    if BD.BossTimers[name] then
        return BD.BossTimers[name].Alive == true
    end
    return false
end

function BD.GetAliveBosses()
    local alive = {}
    for name, data in pairs(BD.BossTimers) do
        if data.Alive then
            alive[#alive + 1] = name
        end
    end
    return alive
end

function BD.GetClosestBoss(pos)
    local closest = nil
    local closestDist = math.huge
    for _, boss in ipairs(BD.All) do
        if BD.IsBossAlive(boss.Name) then
            local dist = (boss.Position.Position - pos.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = boss
            end
        end
    end
    return closest, closestDist
end

function BD.GetBossForLevel(level, sea)
    local bestBoss = nil
    local bestDiff = math.huge
    for _, boss in ipairs(BD.All) do
        if not sea or boss.Sea == sea then
            local diff = math.abs(boss.Level - level)
            if diff < bestDiff then
                bestDiff = diff
                bestBoss = boss
            end
        end
    end
    return bestBoss
end

function BD.GetBossDropChance(bossName, itemName)
    local boss = BD.GetBoss(bossName)
    if not boss then
        return 0
    end
    for _, drop in ipairs(boss.Drops) do
        if string.lower(drop.Name) == string.lower(itemName) then
            return drop.Chance
        end
    end
    return 0
end

function BD.GetBossRarity(name)
    local boss = BD.GetBoss(name)
    if boss then
        return boss.Rarity
    end
    return "Unknown"
end

function BD.GetBossHealth(name)
    local boss = BD.GetBoss(name)
    if boss then
        return boss.Health
    end
    return 0
end

function BD.GetBossReward(name)
    local boss = BD.GetBoss(name)
    if not boss then
        return 0
    end
    local reward = boss.Health * 0.1
    for _, drop in ipairs(boss.Drops) do
        if drop.Type == "Fruit" then
            reward = reward + (1000000 * drop.Chance)
        elseif drop.Type == "Weapon" then
            reward = reward + (250000 * drop.Chance)
        elseif drop.Type == "Accessory" then
            reward = reward + (500000 * drop.Chance)
        elseif drop.Type == "Material" then
            reward = reward + (50000 * drop.Chance)
        end
    end
    return math.floor(reward)
end

function BD.GetBossDifficulty(name)
    local boss = BD.GetBoss(name)
    if not boss then
        return 0
    end
    local diff = 1
    local healthScore = boss.Health / 1000000
    local damageScore = boss.Damage / 200
    local levelScore = boss.Level / 300
    diff = diff + healthScore * 1.5 + damageScore * 1.2 + levelScore * 0.8
    if boss.Type == "Raid Boss" then
        diff = diff + 2
    elseif boss.Type == "Event Boss" then
        diff = diff + 1.5
    elseif boss.Type == "Legend" then
        diff = diff + 3
    elseif boss.Type == "Mythical" then
        diff = diff + 4
    end
    local rarityBonus = {
        Common = 0,
        Uncommon = 0.5,
        Rare = 1,
        Epic = 1.5,
        Legendary = 2.5,
        Mythical = 3.5,
    }
    diff = diff + (rarityBonus[boss.Rarity] or 0)
    diff = math.clamp(diff, 1, 10)
    return math.floor(diff * 10 + 0.5) / 10
end

function BD.CalcSpawnTime(name)
    local boss = BD.GetBoss(name)
    if not boss then
        return 0
    end
    local now = tick()
    local lastSeen = BD.LastSeen[name] or 0
    local elapsed = now - lastSeen
    local spawnInterval = boss.RespawnTime * 60
    local remaining = spawnInterval - elapsed
    if remaining < 0 then
        remaining = 0
    end
    return remaining
end

function BD.GetBossSkillNames(name)
    local boss = BD.GetBoss(name)
    if boss then
        return boss.Skills
    end
    return {}
end

function BD.IsBossEvent(name)
    local boss = BD.GetBoss(name)
    if boss then
        return boss.IsEvent
    end
    return false
end

function BD.StartTimer(name)
    BD.BossTimers[name] = BD.BossTimers[name] or {}
    BD.BossTimers[name].Alive = true
    BD.BossTimers[name].StartTime = tick()
    BD.LastSeen[name] = tick()
end

function BD.UpdateTimer(name)
    if BD.BossTimers[name] then
        BD.BossTimers[name].LastUpdate = tick()
        BD.LastSeen[name] = tick()
    end
end

function BD.GetRarestDrop(bossName)
    local boss = BD.GetBoss(bossName)
    if not boss or #boss.Drops == 0 then
        return nil, 0
    end
    local rarest = boss.Drops[1]
    local rarestChance = boss.Drops[1].Chance
    for _, drop in ipairs(boss.Drops) do
        if drop.Chance < rarestChance then
            rarestChance = drop.Chance
            rarest = drop
        end
    end
    return rarest, rarestChance
end

function BD.GetBossTable(sea)
    if sea == 1 then
        return BD.Sea1
    elseif sea == 2 then
        return BD.Sea2
    elseif sea == 3 then
        return BD.Sea3
    end
    return BD.All
end

function BD.GetTotalBosses()
    return #BD.All
end

function BD.GetBossesByRarity(rarity)
    local result = {}
    for _, boss in ipairs(BD.All) do
        if boss.Rarity == rarity then
            result[#result + 1] = boss
        end
    end
    return result
end

function BD.GetBossesByType(btype)
    local result = {}
    for _, boss in ipairs(BD.All) do
        if boss.Type == btype then
            result[#result + 1] = boss
        end
    end
    return result
end

return BD
