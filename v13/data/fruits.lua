local A = _G.Apex
A.FruitDB = {}

-- ============================================================
-- A.FruitDB.All - Complete fruit database
-- ============================================================
A.FruitDB.All = {
    -- ==================== COMMON ====================
    {
        Name = "Bomb",
        DisplayName = "Bomb Fruit",
        Type = "Natural",
        Rarity = "Common",
        Value = 80000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Bomb Shot", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Exploding Grenade", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Selfdestruct", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Full Body Explode", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
            CFrame.new(1013, -100, -200),
        },
        MetaValue = 5000,
        Demand = "Low",
        BestFor = "Grinding",
        Tier = "D",
        Rating = {Damage = 3, Speed = 4, Range = 5, AoE = 6, Versatility = 3, Difficulty = 2},
    },
    {
        Name = "Spike",
        DisplayName = "Spike Fruit",
        Type = "Natural",
        Rarity = "Common",
        Value = 80000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Spike Shot", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Spike Barrage", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Rain Spikes", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Spike Underground", Key = "V", Mastery = 100, Type = "Blast"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
            CFrame.new(1013, -100, -200),
        },
        MetaValue = 5000,
        Demand = "Low",
        BestFor = "Grinding",
        Tier = "D",
        Rating = {Damage = 4, Speed = 3, Range = 5, AoE = 5, Versatility = 3, Difficulty = 2},
    },
    {
        Name = "Chop",
        DisplayName = "Chop Fruit",
        Type = "Natural",
        Rarity = "Common",
        Value = 80000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Chop", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "Slap", Key = "X", Mastery = 0, Type = "Dash"},
            {Name = "Spin Cut", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Fly Away", Key = "V", Mastery = 100, Type = "Dash"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
            CFrame.new(1013, -100, -200),
        },
        MetaValue = 5000,
        Demand = "Low",
        BestFor = "Grinding",
        Tier = "D",
        Rating = {Damage = 3, Speed = 5, Range = 3, AoE = 4, Versatility = 3, Difficulty = 1},
    },
    {
        Name = "Spring",
        DisplayName = "Spring Fruit",
        Type = "Natural",
        Rarity = "Common",
        Value = 80000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Spring Snipe", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Spring Death Knock", Key = "X", Mastery = 0, Type = "Blast"},
            {Name = "Spring Hopper", Key = "C", Mastery = 0, Type = "Dash"},
            {Name = "Spring Launcher", Key = "V", Mastery = 100, Type = "Projectile"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 5000,
        Demand = "Low",
        BestFor = "PvP",
        Tier = "D",
        Rating = {Damage = 4, Speed = 5, Range = 7, AoE = 3, Versatility = 4, Difficulty = 4},
    },
    {
        Name = "Smoke",
        DisplayName = "Smoke Fruit",
        Type = "Natural",
        Rarity = "Common",
        Value = 100000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "White Blow", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "White Smoke", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "White Lavender", Key = "C", Mastery = 0, Type = "Projectile"},
            {Name = "White Tornado", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 10000,
        Demand = "Low",
        BestFor = "Grinding",
        Tier = "C",
        Rating = {Damage = 4, Speed = 5, Range = 5, AoE = 6, Versatility = 4, Difficulty = 2},
    },
    {
        Name = "Spin",
        DisplayName = "Spin Fruit",
        Type = "Natural",
        Rarity = "Common",
        Value = 80000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Spin Throw", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Powerful Slam", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Vertical Spin", Key = "C", Mastery = 0, Type = "Dash"},
            {Name = "Spin Generator", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 5000,
        Demand = "Low",
        BestFor = "Grinding",
        Tier = "D",
        Rating = {Damage = 3, Speed = 5, Range = 4, AoE = 4, Versatility = 3, Difficulty = 2},
    },
    {
        Name = "Diamond",
        DisplayName = "Diamond Fruit",
        Type = "Natural",
        Rarity = "Common",
        Value = 90000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Diamond Shoot", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Diamond Charge", Key = "X", Mastery = 0, Type = "Dash"},
            {Name = "Diamond Drill", Key = "C", Mastery = 0, Type = "Blast"},
            {Name = "Diamond Wall", Key = "V", Mastery = 100, Type = "Buff"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 5000,
        Demand = "Low",
        BestFor = "Grinding",
        Tier = "D",
        Rating = {Damage = 4, Speed = 3, Range = 4, AoE = 3, Versatility = 3, Difficulty = 2},
    },
    {
        Name = "Eagle",
        DisplayName = "Eagle Fruit",
        Type = "Natural",
        Rarity = "Common",
        Value = 80000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Wind Cutter", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "Talon Grab", Key = "X", Mastery = 0, Type = "Dash"},
            {Name = "Wind Burst", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Ride the Wind", Key = "V", Mastery = 100, Type = "Dash"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 5000,
        Demand = "Low",
        BestFor = "Grinding",
        Tier = "D",
        Rating = {Damage = 3, Speed = 6, Range = 4, AoE = 3, Versatility = 4, Difficulty = 2},
    },
    {
        Name = "Ice",
        DisplayName = "Ice Fruit",
        Type = "Natural",
        Rarity = "Common",
        Value = 100000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Ice Lance", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Subzero", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Frozen", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Ice Birds", Key = "V", Mastery = 100, Type = "Projectile"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 25000,
        Demand = "Low",
        BestFor = "PvP",
        Tier = "C",
        Rating = {Damage = 5, Speed = 4, Range = 6, AoE = 6, Versatility = 5, Difficulty = 2},
    },

    -- ==================== UNCOMMON ====================
    {
        Name = "Barrier",
        DisplayName = "Barrier Fruit",
        Type = "Natural",
        Rarity = "Uncommon",
        Value = 120000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Barrier Pulse", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "Barrier Tower", Key = "X", Mastery = 0, Type = "Buff"},
            {Name = "Slap Louge", Key = "C", Mastery = 0, Type = "Dash"},
            {Name = "Universe Slap", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 15000,
        Demand = "Low",
        BestFor = "PvP",
        Tier = "C",
        Rating = {Damage = 5, Speed = 3, Range = 4, AoE = 5, Versatility = 4, Difficulty = 3},
    },
    {
        Name = "Ghost",
        DisplayName = "Ghost Fruit",
        Type = "Natural",
        Rarity = "Uncommon",
        Value = 100000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Soul Execution", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Ethereal Vengeance", Key = "X", Mastery = 0, Type = "Blast"},
            {Name = "Soul Chain", Key = "C", Mastery = 0, Type = "Dash"},
            {Name = "Soul Drain", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 15000,
        Demand = "Low",
        BestFor = "PvP",
        Tier = "C",
        Rating = {Damage = 5, Speed = 4, Range = 5, AoE = 5, Versatility = 5, Difficulty = 3},
    },
    {
        Name = "Power",
        DisplayName = "Power Fruit",
        Type = "Natural",
        Rarity = "Uncommon",
        Value = 120000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Power Hook", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "Power Smash", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Power Kick", Key = "C", Mastery = 0, Type = "Dash"},
            {Name = "Power Uppercut", Key = "V", Mastery = 100, Type = "Blast"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 10000,
        Demand = "Low",
        BestFor = "Grinding",
        Tier = "C",
        Rating = {Damage = 5, Speed = 4, Range = 3, AoE = 4, Versatility = 3, Difficulty = 2},
    },
    {
        Name = "Rubber",
        DisplayName = "Rubber Fruit",
        Type = "Paramecia",
        Rarity = "Uncommon",
        Value = 250000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Gum Gum Pistol", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Gum Gum Gatling", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Gum Gum Bazooka", Key = "C", Mastery = 0, Type = "Blast"},
            {Name = "Gum Gum Gattling Gun", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Gum Gum Balloon", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
            CFrame.new(1013, -100, -200),
        },
        MetaValue = 50000,
        Demand = "Medium",
        BestFor = "PvP",
        Tier = "C",
        Rating = {Damage = 6, Speed = 5, Range = 6, AoE = 5, Versatility = 5, Difficulty = 3},
    },
    {
        Name = "Flame",
        DisplayName = "Flame Fruit",
        Type = "Natural",
        Rarity = "Uncommon",
        Value = 120000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Fire Bullets", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Fire Column", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Fire Shower", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Heatwave", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 15000,
        Demand = "Low",
        BestFor = "Grinding",
        Tier = "C",
        Rating = {Damage = 5, Speed = 5, Range = 5, AoE = 6, Versatility = 4, Difficulty = 2},
    },
    {
        Name = "Falcon",
        DisplayName = "Falcon Fruit",
        Type = "Natural",
        Rarity = "Uncommon",
        Value = 100000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Plume", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Wind Scythe", Key = "X", Mastery = 0, Type = "Blast"},
            {Name = "Divine Death", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Peacock Outrage", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Soul Flight", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 10000,
        Demand = "Low",
        BestFor = "Grinding",
        Tier = "C",
        Rating = {Damage = 4, Speed = 6, Range = 5, AoE = 4, Versatility = 5, Difficulty = 3},
    },
    {
        Name = "Qilin",
        DisplayName = "Qilin Fruit",
        Type = "Natural",
        Rarity = "Uncommon",
        Value = 150000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Lightning Strike", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Storm Charge", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Thunder Clap", Key = "C", Mastery = 0, Type = "Blast"},
            {Name = "Divine Storm", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 20000,
        Demand = "Low",
        BestFor = "PvP",
        Tier = "C",
        Rating = {Damage = 5, Speed = 5, Range = 5, AoE = 5, Versatility = 4, Difficulty = 3},
    },

    -- ==================== RARE ====================
    {
        Name = "Magma",
        DisplayName = "Magma Fruit",
        Type = "Natural",
        Rarity = "Rare",
        Value = 300000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Magma Fist", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "Magma Hound", Key = "X", Mastery = 0, Type = "Projectile"},
            {Name = "Magma Shower", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Great Magma", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = true,
        AwakeningSkills = {
            {Name = "Great Magma Hound", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Magma Rain", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Eruption", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Meteor", Key = "V", Mastery = 0, Type = "AoE"},
        },
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 250000,
        Demand = "High",
        BestFor = "Grinding",
        Tier = "A",
        Rating = {Damage = 8, Speed = 4, Range = 6, AoE = 9, Versatility = 7, Difficulty = 3},
    },
    {
        Name = "Dark",
        DisplayName = "Dark Fruit",
        Type = "Natural",
        Rarity = "Rare",
        Value = 350000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Black Hole", Key = "Z", Mastery = 0, Type = "AoE"},
            {Name = "Severe Gun", Key = "X", Mastery = 0, Type = "Projectile"},
            {Name = "Darkness", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Liberation", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Step of Darkness", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = true,
        AwakeningSkills = {
            {Name = "Black Void", Key = "Z", Mastery = 0, Type = "AoE"},
            {Name = "Severe Gun", Key = "X", Mastery = 0, Type = "Projectile"},
            {Name = "World of Darkness", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Endless Darkness", Key = "V", Mastery = 0, Type = "AoE"},
        },
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 300000,
        Demand = "High",
        BestFor = "PvP",
        Tier = "S",
        Rating = {Damage = 7, Speed = 5, Range = 6, AoE = 8, Versatility = 9, Difficulty = 4},
    },
    {
        Name = "Light",
        DisplayName = "Light Fruit",
        Type = "Natural",
        Rarity = "Rare",
        Value = 350000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Light Beam", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Light Reflection", Key = "X", Mastery = 0, Type = "Blast"},
            {Name = "Light Speed", Key = "C", Mastery = 0, Type = "Dash"},
            {Name = "Light Execution", Key = "V", Mastery = 100, Type = "Blast"},
            {Name = "Light Speed Step", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = true,
        AwakeningSkills = {
            {Name = "Jeweled Light", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Judgement of Emperor", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Light Speed Kick", Key = "C", Mastery = 0, Type = "Blast"},
            {Name = "Sacred Judgement", Key = "V", Mastery = 0, Type = "AoE"},
        },
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 350000,
        Demand = "High",
        BestFor = "PvP",
        Tier = "S",
        Rating = {Damage = 7, Speed = 9, Range = 7, AoE = 7, Versatility = 9, Difficulty = 3},
    },
    {
        Name = "Love",
        DisplayName = "Love Fruit",
        Type = "Natural",
        Rarity = "Rare",
        Value = 250000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Peptide Shot", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Femming", Key = "X", Mastery = 0, Type = "Buff"},
            {Name = "Heart Destroyer", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Love Hurricane", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 25000,
        Demand = "Low",
        BestFor = "PvP",
        Tier = "B",
        Rating = {Damage = 5, Speed = 4, Range = 5, AoE = 6, Versatility = 6, Difficulty = 4},
    },
    {
        Name = "Sound",
        DisplayName = "Sound Fruit",
        Type = "Natural",
        Rarity = "Rare",
        Value = 250000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Rhythm Toss", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Rhythm Punch", Key = "X", Mastery = 0, Type = "Blast"},
            {Name = "Rhythm Boom", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Rhythm Song", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 25000,
        Demand = "Low",
        BestFor = "PvP",
        Tier = "B",
        Rating = {Damage = 6, Speed = 5, Range = 6, AoE = 6, Versatility = 5, Difficulty = 3},
    },
    {
        Name = "Spider",
        DisplayName = "Spider Fruit",
        Type = "Natural",
        Rarity = "Rare",
        Value = 250000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Web Shot", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Web Wrap", Key = "X", Mastery = 0, Type = "Blast"},
            {Name = "Spider Mesh", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Stick v2", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 50000,
        Demand = "Medium",
        BestFor = "PvP",
        Tier = "B",
        Rating = {Damage = 6, Speed = 5, Range = 6, AoE = 5, Versatility = 6, Difficulty = 4},
    },
    {
        Name = "Quake",
        DisplayName = "Quake Fruit",
        Type = "Natural",
        Rarity = "Rare",
        Value = 400000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Tremor Punch", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "Levitate", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Tremor Punch Roar", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Island Shaker", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = true,
        AwakeningSkills = {
            {Name = "Tremor Punch Roar", Key = "Z", Mastery = 0, Type = "AoE"},
            {Name = "Island Tower", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Tremor Burst", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Tsunami", Key = "V", Mastery = 0, Type = "AoE"},
        },
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 400000,
        Demand = "High",
        BestFor = "PvP",
        Tier = "S",
        Rating = {Damage = 8, Speed = 3, Range = 8, AoE = 9, Versatility = 7, Difficulty = 4},
    },

    -- ==================== LEGENDARY ====================
    {
        Name = "Buddha",
        DisplayName = "Buddha Fruit",
        Type = "Special",
        Rarity = "Legendary",
        Value = 1200000,
        RobuxPrice = 1650,
        Physical = true,
        Skills = {
            {Name = "Buddha Beam", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Buddha Palm", Key = "X", Mastery = 0, Type = "Blast"},
            {Name = "Trip", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Fruit Awaken", Key = "V", Mastery = 100, Type = "Buff"},
            {Name = "Step of Buddha", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = true,
        AwakeningSkills = {
            {Name = "Vajra Punch", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "Buddha Stomp", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Buddha Elbow", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Execution", Key = "V", Mastery = 0, Type = "AoE"},
        },
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
            CFrame.new(1013, -100, -200),
        },
        MetaValue = 2500000,
        Demand = "Very High",
        BestFor = "Grinding",
        Tier = "S",
        Rating = {Damage = 9, Speed = 2, Range = 3, AoE = 9, Versatility = 8, Difficulty = 1},
    },
    {
        Name = "Phoenix",
        DisplayName = "Phoenix Fruit",
        Type = "Mythical Zoan",
        Rarity = "Legendary",
        Value = 1800000,
        RobuxPrice = 1800,
        Physical = true,
        Skills = {
            {Name = "Blue Flames", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Rebirth", Key = "X", Mastery = 0, Type = "Buff"},
            {Name = "Phoenix Regeneration", Key = "C", Mastery = 0, Type = "Buff"},
            {Name = "Fire Pillars", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Flight", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = true,
        AwakeningSkills = {
            {Name = "Blazing Blue Flames", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Rebirth Flame", Key = "X", Mastery = 0, Type = "Buff"},
            {Name = "Super Regeneration", Key = "C", Mastery = 0, Type = "Buff"},
            {Name = "Inferno", Key = "V", Mastery = 0, Type = "AoE"},
        },
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 3000000,
        Demand = "Very High",
        BestFor = "PvP",
        Tier = "S",
        Rating = {Damage = 7, Speed = 7, Range = 6, AoE = 7, Versatility = 9, Difficulty = 5},
    },
    {
        Name = "Portal",
        DisplayName = "Portal Fruit",
        Type = "Natural",
        Rarity = "Legendary",
        Value = 1800000,
        RobuxPrice = 2000,
        Physical = true,
        Skills = {
            {Name = "Portal Thrust", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "Spatial Tearing", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Portal Pull", Key = "C", Mastery = 0, Type = "Blast"},
            {Name = "World Warp", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Dimension Shift", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 3500000,
        Demand = "Very High",
        BestFor = "PvP",
        Tier = "S",
        Rating = {Damage = 6, Speed = 8, Range = 8, AoE = 6, Versatility = 10, Difficulty = 5},
    },
    {
        Name = "Pain",
        DisplayName = "Pain Fruit",
        Type = "Natural",
        Rarity = "Legendary",
        Value = 900000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Damned Pitch", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Delivering Pain", Key = "X", Mastery = 0, Type = "Blast"},
            {Name = "Soul Pain", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Torment", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = true,
        AwakeningSkills = {
            {Name = "Damned Pitch", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Delivering Pain", Key = "X", Mastery = 0, Type = "Blast"},
            {Name = "Soul Pain", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Anguish", Key = "V", Mastery = 0, Type = "AoE"},
        },
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 1500000,
        Demand = "High",
        BestFor = "PvP",
        Tier = "A",
        Rating = {Damage = 7, Speed = 5, Range = 6, AoE = 7, Versatility = 7, Difficulty = 5},
    },
    {
        Name = "Blizzard",
        DisplayName = "Blizzard Fruit",
        Type = "Natural",
        Rarity = "Legendary",
        Value = 900000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Winter Severity", Key = "Z", Mastery = 0, Type = "AoE"},
            {Name = "Frozen", Key = "X", Mastery = 0, Type = "Projectile"},
            {Name = "Blizzard Dance", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Winter Justice", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = true,
        AwakeningSkills = {
            {Name = "Winter Severity", Key = "Z", Mastery = 0, Type = "AoE"},
            {Name = "Frozen", Key = "X", Mastery = 0, Type = "Projectile"},
            {Name = "Blizzard Dance", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Avalanche", Key = "V", Mastery = 0, Type = "AoE"},
        },
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 1200000,
        Demand = "High",
        BestFor = "Grinding",
        Tier = "A",
        Rating = {Damage = 7, Speed = 4, Range = 7, AoE = 9, Versatility = 7, Difficulty = 3},
    },
    {
        Name = "Gravity",
        DisplayName = "Gravity Fruit",
        Type = "Natural",
        Rarity = "Legendary",
        Value = 900000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Meteor Fallback", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Meteor", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Seismic", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Gravity Destroyer", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = true,
        AwakeningSkills = {
            {Name = "Meteor Burst", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Meteor", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Avalanche", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Gravity Dominus", Key = "V", Mastery = 0, Type = "AoE"},
        },
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 1500000,
        Demand = "High",
        BestFor = "PvP",
        Tier = "A",
        Rating = {Damage = 7, Speed = 3, Range = 7, AoE = 8, Versatility = 6, Difficulty = 4},
    },
    {
        Name = "Venom",
        DisplayName = "Venom Fruit",
        Type = "Natural",
        Rarity = "Legendary",
        Value = 1200000,
        RobuxPrice = 1800,
        Physical = true,
        Skills = {
            {Name = "Venom Shot", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Toxic Fog", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Venom Shower", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Venom Cloud", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 2500000,
        Demand = "Very High",
        BestFor = "PvP",
        Tier = "S",
        Rating = {Damage = 8, Speed = 5, Range = 6, AoE = 8, Versatility = 8, Difficulty = 4},
    },
    {
        Name = "Control",
        DisplayName = "Control Fruit",
        Type = "Natural",
        Rarity = "Legendary",
        Value = 1200000,
        RobuxPrice = 1800,
        Physical = true,
        Skills = {
            {Name = "Messager", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Chromatic", Key = "X", Mastery = 0, Type = "Blast"},
            {Name = "Room", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Korneyrogroratiion", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 2000000,
        Demand = "Very High",
        BestFor = "PvP",
        Tier = "S",
        Rating = {Damage = 7, Speed = 5, Range = 7, AoE = 7, Versatility = 9, Difficulty = 6},
    },
    {
        Name = "Dough",
        DisplayName = "Dough Fruit",
        Type = "Natural",
        Rarity = "Legendary",
        Value = 1200000,
        RobuxPrice = 1800,
        Physical = true,
        Skills = {
            {Name = "Dough Punch", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "Dough Slam", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Carved Dough", Key = "C", Mastery = 0, Type = "Dash"},
            {Name = "Dough Fist", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Dough Spin", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = true,
        AwakeningSkills = {
            {Name = "Piercing Dough", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "Sticky Dough", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Vowel Demon", Key = "C", Mastery = 0, Type = "Dash"},
            {Name = "Dough Fist Review", Key = "V", Mastery = 0, Type = "AoE"},
        },
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 2000000,
        Demand = "Very High",
        BestFor = "PvP",
        Tier = "S",
        Rating = {Damage = 8, Speed = 5, Range = 5, AoE = 8, Versatility = 8, Difficulty = 5},
    },

    -- ==================== MYTHICAL ====================
    {
        Name = "Dragon",
        DisplayName = "Dragon Fruit",
        Type = "Mythical Zoan",
        Rarity = "Mythical",
        Value = 3500000,
        RobuxPrice = 3500,
        Physical = true,
        Skills = {
            {Name = "Heat Wave", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Roar", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Blast", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Flight", Key = "V", Mastery = 100, Type = "Dash"},
            {Name = "Dragon Flight", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 10000000,
        Demand = "Very High",
        BestFor = "PvP",
        Tier = "S",
        Rating = {Damage = 10, Speed = 7, Range = 7, AoE = 9, Versatility = 9, Difficulty = 5},
    },
    {
        Name = "Leopard",
        DisplayName = "Leopard Fruit",
        Type = "Mythical Zoan",
        Rarity = "Mythical",
        Value = 3500000,
        RobuxPrice = 3500,
        Physical = true,
        Skills = {
            {Name = "Leopard Barrage", Key = "Z", Mastery = 0, Type = "AoE"},
            {Name = "Leopard Claw", Key = "X", Mastery = 0, Type = "Blast"},
            {Name = "Leopard Gun", Key = "C", Mastery = 0, Type = "Projectile"},
            {Name = "Leopard Transformation", Key = "V", Mastery = 100, Type = "Buff"},
            {Name = "Leap", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 8000000,
        Demand = "Very High",
        BestFor = "PvP",
        Tier = "S",
        Rating = {Damage = 9, Speed = 9, Range = 4, AoE = 8, Versatility = 9, Difficulty = 4},
    },
    {
        Name = "Kitsune",
        DisplayName = "Kitsune Fruit",
        Type = "Mythical Zoan",
        Rarity = "Mythical",
        Value = 3500000,
        RobuxPrice = 4000,
        Physical = true,
        Skills = {
            {Name = "Kitsune Beam", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Fox Smite", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Kitsune Shrine", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Kitsune Form", Key = "V", Mastery = 100, Type = "Buff"},
            {Name = "Tails", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 12000000,
        Demand = "Very High",
        BestFor = "PvP",
        Tier = "S",
        Rating = {Damage = 9, Speed = 8, Range = 6, AoE = 8, Versatility = 9, Difficulty = 4},
    },
    {
        Name = "Mammoth",
        DisplayName = "Mammoth Fruit",
        Type = "Mythical Zoan",
        Rarity = "Mythical",
        Value = 3000000,
        RobuxPrice = 3000,
        Physical = true,
        Skills = {
            {Name = "Mammoth Ram", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "Tusk", Key = "X", Mastery = 0, Type = "Projectile"},
            {Name = "Mammoth Stampede", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Mammoth Slam", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Mammoth Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 5000000,
        Demand = "Very High",
        BestFor = "Grinding",
        Tier = "S",
        Rating = {Damage = 9, Speed = 3, Range = 5, AoE = 10, Versatility = 7, Difficulty = 2},
    },
    {
        Name = "T-Rex",
        DisplayName = "T-Rex Fruit",
        Type = "Mythical Zoan",
        Rarity = "Mythical",
        Value = 3000000,
        RobuxPrice = 3000,
        Physical = true,
        Skills = {
            {Name = "T-Rex Bite", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "T-Rex Claws", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "T-Rex Charge", Key = "C", Mastery = 0, Type = "Dash"},
            {Name = "T-Rex Roar", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "T-Rex Run", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 5000000,
        Demand = "Very High",
        BestFor = "Grinding",
        Tier = "S",
        Rating = {Damage = 10, Speed = 4, Range = 3, AoE = 8, Versatility = 7, Difficulty = 2},
    },
    {
        Name = "Spirit",
        DisplayName = "Spirit Fruit",
        Type = "Natural",
        Rarity = "Mythical",
        Value = 2500000,
        RobuxPrice = 2500,
        Physical = true,
        Skills = {
            {Name = "Fire Death", Key = "Z", Mastery = 0, Type = "AoE"},
            {Name = "Ice Death", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Soul Shaker", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Spirit Hurricane", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 4000000,
        Demand = "Very High",
        BestFor = "PvP",
        Tier = "S",
        Rating = {Damage = 9, Speed = 5, Range = 6, AoE = 9, Versatility = 8, Difficulty = 5},
    },
    {
        Name = "Shadow",
        DisplayName = "Shadow Fruit",
        Type = "Natural",
        Rarity = "Mythical",
        Value = 2000000,
        RobuxPrice = 2000,
        Physical = true,
        Skills = {
            {Name = "Nightmare Embrace", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "Black", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Intangled", Key = "C", Mastery = 0, Type = "Dash"},
            {Name = "Twilight Explosion", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Step of Darkness", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 3000000,
        Demand = "Very High",
        BestFor = "PvP",
        Tier = "S",
        Rating = {Damage = 8, Speed = 7, Range = 6, AoE = 8, Versatility = 8, Difficulty = 4},
    },
    {
        Name = "BuddhaAwakened",
        DisplayName = "Buddha (Awakened)",
        Type = "Special",
        Rarity = "Mythical",
        Value = 2000000,
        RobuxPrice = 0,
        Physical = true,
        Skills = {
            {Name = "Vajra Punch", Key = "Z", Mastery = 0, Type = "Blast"},
            {Name = "Buddha Stomp", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Buddha Elbow", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Execution", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Step of Buddha", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = true,
        AwakeningSkills = {},
        SpawnLocations = {},
        MetaValue = 5000000,
        Demand = "Very High",
        BestFor = "Grinding",
        Tier = "S",
        Rating = {Damage = 10, Speed = 2, Range = 3, AoE = 10, Versatility = 8, Difficulty = 1},
    },
    {
        Name = "Gas",
        DisplayName = "Gas Fruit",
        Type = "Natural",
        Rarity = "Mythical",
        Value = 2500000,
        RobuxPrice = 3000,
        Physical = true,
        Skills = {
            {Name = "Gas Bubbles", Key = "Z", Mastery = 0, Type = "Projectile"},
            {Name = "Poison Gas", Key = "X", Mastery = 0, Type = "AoE"},
            {Name = "Gas Bomb", Key = "C", Mastery = 0, Type = "AoE"},
            {Name = "Gas Cloud", Key = "V", Mastery = 100, Type = "AoE"},
            {Name = "Air Walk", Key = "F", Mastery = 0, Type = "Dash"},
        },
        Awakened = false,
        AwakeningSkills = {},
        SpawnLocations = {
            CFrame.new(-1317, -465, 20),
        },
        MetaValue = 4000000,
        Demand = "Very High",
        BestFor = "PvP",
        Tier = "S",
        Rating = {Damage = 8, Speed = 5, Range = 6, AoE = 8, Versatility = 8, Difficulty = 4},
    },
}

-- ============================================================
-- A.FruitDB.Rating - Detailed rating system per fruit
-- ============================================================
A.FruitDB.Rating = {}
for _, fruit in ipairs(A.FruitDB.All) do
    A.FruitDB.Rating[fruit.Name] = fruit.Rating
end

-- ============================================================
-- A.FruitDB.Rarity tables - sorted by rarity
-- ============================================================
A.FruitDB.Common = {}
A.FruitDB.Uncommon = {}
A.FruitDB.Rare = {}
A.FruitDB.Legendary = {}
A.FruitDB.Mythical = {}

for _, fruit in ipairs(A.FruitDB.All) do
    if fruit.Rarity == "Common" then
        table.insert(A.FruitDB.Common, fruit)
    elseif fruit.Rarity == "Uncommon" then
        table.insert(A.FruitDB.Uncommon, fruit)
    elseif fruit.Rarity == "Rare" then
        table.insert(A.FruitDB.Rare, fruit)
    elseif fruit.Rarity == "Legendary" then
        table.insert(A.FruitDB.Legendary, fruit)
    elseif fruit.Rarity == "Mythical" then
        table.insert(A.FruitDB.Mythical, fruit)
    end
end

table.sort(A.FruitDB.Common, function(a, b) return a.Value < b.Value end)
table.sort(A.FruitDB.Uncommon, function(a, b) return a.Value < b.Value end)
table.sort(A.FruitDB.Rare, function(a, b) return a.Value < b.Value end)
table.sort(A.FruitDB.Legendary, function(a, b) return a.Value < b.Value end)
table.sort(A.FruitDB.Mythical, function(a, b) return a.Value < b.Value end)

-- ============================================================
-- A.FruitDB.Physical - physical fruits only
-- ============================================================
A.FruitDB.Physical = {}
for _, fruit in ipairs(A.FruitDB.All) do
    if fruit.Physical then
        table.insert(A.FruitDB.Physical, fruit)
    end
end

-- ============================================================
-- A.FruitDB.Awakenable - fruits with awakening
-- ============================================================
A.FruitDB.Awakenable = {}
for _, fruit in ipairs(A.FruitDB.All) do
    if fruit.Awakened and #fruit.AwakeningSkills > 0 then
        table.insert(A.FruitDB.Awakenable, fruit)
    end
end

-- ============================================================
-- A.FruitDB.BestPvP - top PvP fruits
-- ============================================================
A.FruitDB.BestPvP = {}
for _, fruit in ipairs(A.FruitDB.All) do
    if fruit.BestFor == "PvP" then
        table.insert(A.FruitDB.BestPvP, fruit)
    end
end
table.sort(A.FruitDB.BestPvP, function(a, b)
    return (a.Rating.Damage + a.Rating.Speed + a.Rating.AoE + a.Rating.Versatility) >
           (b.Rating.Damage + b.Rating.Speed + b.Rating.AoE + b.Rating.Versatility)
end)

-- ============================================================
-- A.FruitDB.BestPvE - top PvE/grinding fruits
-- ============================================================
A.FruitDB.BestPvE = {}
for _, fruit in ipairs(A.FruitDB.All) do
    if fruit.BestFor == "Grinding" or fruit.BestFor == "Farming" then
        table.insert(A.FruitDB.BestPvE, fruit)
    end
end
table.sort(A.FruitDB.BestPvE, function(a, b)
    return (a.Rating.Damage + a.Rating.AoE) > (b.Rating.Damage + b.Rating.AoE)
end)

-- ============================================================
-- A.FruitDB.TradingValue - sorted by trading meta value
-- ============================================================
A.FruitDB.TradingValue = {}
for _, fruit in ipairs(A.FruitDB.All) do
    table.insert(A.FruitDB.TradingValue, fruit)
end
table.sort(A.FruitDB.TradingValue, function(a, b) return a.MetaValue > b.MetaValue end)

-- ============================================================
-- A.FruitDB.ShopFruits - fruits available in shop
-- ============================================================
A.FruitDB.ShopFruits = {}
for _, fruit in ipairs(A.FruitDB.All) do
    if fruit.RobuxPrice > 0 then
        table.insert(A.FruitDB.ShopFruits, fruit)
    end
end
table.sort(A.FruitDB.ShopFruits, function(a, b) return a.RobuxPrice < b.RobuxPrice end)

-- ============================================================
-- A.FruitDB.SpawnLocations - all spawn locations
-- ============================================================
A.FruitDB.SpawnLocations = {}
for _, fruit in ipairs(A.FruitDB.All) do
    if #fruit.SpawnLocations > 0 then
        A.FruitDB.SpawnLocations[fruit.Name] = fruit.SpawnLocations
    end
end

-- ============================================================
-- A.FruitDB.Owned - player owned fruits
-- ============================================================
A.FruitDB.Owned = {}

-- ============================================================
-- A.FruitDB.PriceHistory - price tracking
-- ============================================================
A.FruitDB.PriceHistory = {}
for _, fruit in ipairs(A.FruitDB.All) do
    A.FruitDB.PriceHistory[fruit.Name] = {
        Current = fruit.Value,
        Lowest = math.floor(fruit.Value * 0.7),
        Highest = math.floor(fruit.Value * 1.3),
        Average = fruit.Value,
        History = {},
    }
end

-- ============================================================
-- Internal lookup table for fast access
-- ============================================================
local _fruitLookup = {}
for _, fruit in ipairs(A.FruitDB.All) do
    _fruitLookup[string.lower(fruit.Name)] = fruit
end

-- ============================================================
-- Utility: find fruit by name (case insensitive)
-- ============================================================
local function _findFruit(name)
    if not name then return nil end
    local lower = string.lower(name)
    return _fruitLookup[lower]
end

-- ============================================================
-- A.FruitDB.GetFruit(name) - full data
-- ============================================================
function A.FruitDB.GetFruit(name)
    return _findFruit(name)
end

-- ============================================================
-- A.FruitDB.GetFruitType(name) - type
-- ============================================================
function A.FruitDB.GetFruitType(name)
    local f = _findFruit(name)
    if f then return f.Type end
    return nil
end

-- ============================================================
-- A.FruitDB.GetFruitRarity(name) - rarity
-- ============================================================
function A.FruitDB.GetFruitRarity(name)
    local f = _findFruit(name)
    if f then return f.Rarity end
    return nil
end

-- ============================================================
-- A.FruitDB.GetFruitValue(name) - value
-- ============================================================
function A.FruitDB.GetFruitValue(name)
    local f = _findFruit(name)
    if f then return f.Value end
    return 0
end

-- ============================================================
-- A.FruitDB.GetFruitSkills(name) - skill list
-- ============================================================
function A.FruitDB.GetFruitSkills(name)
    local f = _findFruit(name)
    if f then return f.Skills end
    return {}
end

-- ============================================================
-- A.FruitDB.GetFruitTier(name) - S/A/B/C/D
-- ============================================================
function A.FruitDB.GetFruitTier(name)
    local f = _findFruit(name)
    if f then return f.Tier end
    return nil
end

-- ============================================================
-- A.FruitDB.GetFruitMetaValue(name) - trading meta value
-- ============================================================
function A.FruitDB.GetFruitMetaValue(name)
    local f = _findFruit(name)
    if f then return f.MetaValue end
    return 0
end

-- ============================================================
-- A.FruitDB.GetFruitDemand(name) - demand level
-- ============================================================
function A.FruitDB.GetFruitDemand(name)
    local f = _findFruit(name)
    if f then return f.Demand end
    return nil
end

-- ============================================================
-- A.FruitDB.GetFruitDPS(name) - estimated DPS
-- ============================================================
function A.FruitDB.GetFruitDPS(name)
    local f = _findFruit(name)
    if not f then return 0 end
    local baseDamage = f.Rating.Damage or 1
    local speed = f.Rating.Speed or 1
    local scaling = 1
    if f.Tier == "S" then scaling = 5
    elseif f.Tier == "A" then scaling = 4
    elseif f.Tier == "B" then scaling = 3
    elseif f.Tier == "C" then scaling = 2
    else scaling = 1 end
    local dps = baseDamage * scaling * 100 + speed * scaling * 25
    return math.floor(dps)
end

-- ============================================================
-- A.FruitDB.GetFruitRange(name) - range rating
-- ============================================================
function A.FruitDB.GetFruitRange(name)
    local f = _findFruit(name)
    if f and f.Rating then return f.Rating.Range end
    return 0
end

-- ============================================================
-- A.FruitDB.GetFruitSpeed(name) - speed rating
-- ============================================================
function A.FruitDB.GetFruitSpeed(name)
    local f = _findFruit(name)
    if f and f.Rating then return f.Rating.Speed end
    return 0
end

-- ============================================================
-- A.FruitDB.GetFruitAoE(name) - AoE rating
-- ============================================================
function A.FruitDB.GetFruitAoE(name)
    local f = _findFruit(name)
    if f and f.Rating then return f.Rating.AoE end
    return 0
end

-- ============================================================
-- A.FruitDB.IsFruitPhysical(name) - physical check
-- ============================================================
function A.FruitDB.IsFruitPhysical(name)
    local f = _findFruit(name)
    if f then return f.Physical end
    return false
end

-- ============================================================
-- A.FruitDB.HasAwakening(name) - awakening check
-- ============================================================
function A.FruitDB.HasAwakening(name)
    local f = _findFruit(name)
    if f then return f.Awakened end
    return false
end

-- ============================================================
-- A.FruitDB.GetAwakeningSkills(name) - awakened skills
-- ============================================================
function A.FruitDB.GetAwakeningSkills(name)
    local f = _findFruit(name)
    if f and f.Awakened then return f.AwakeningSkills end
    return {}
end

-- ============================================================
-- A.FruitDB.GetFruitBestFor(name) - best use case
-- ============================================================
function A.FruitDB.GetFruitBestFor(name)
    local f = _findFruit(name)
    if f then return f.BestFor end
    return nil
end

-- ============================================================
-- A.FruitDB.CompareFruits(name1, name2) - compare two fruits
-- ============================================================
function A.FruitDB.CompareFruits(name1, name2)
    local f1 = _findFruit(name1)
    local f2 = _findFruit(name2)
    if not f1 or not f2 then return nil end
    local result = {
        Fruit1 = f1.Name,
        Fruit2 = f2.Name,
        ValueDiff = f1.Value - f2.Value,
        MetaDiff = f1.MetaValue - f2.MetaValue,
        Rating1 = f1.Rating,
        Rating2 = f2.Rating,
        Winner = nil,
        Advantage = {},
    }
    local s1 = f1.Rating.Damage + f1.Rating.Speed + f1.Rating.Range + f1.Rating.AoE + f1.Rating.Versatility
    local s2 = f2.Rating.Damage + f2.Rating.Speed + f2.Rating.Range + f2.Rating.AoE + f2.Rating.Versatility
    if s1 > s2 then
        result.Winner = f1.Name
    elseif s2 > s1 then
        result.Winner = f2.Name
    else
        result.Winner = "Tie"
    end
    if f1.Rating.Damage > f2.Rating.Damage then
        table.insert(result.Advantage, f1.Name .. " has better Damage")
    elseif f2.Rating.Damage > f1.Rating.Damage then
        table.insert(result.Advantage, f2.Name .. " has better Damage")
    end
    if f1.Rating.Speed > f2.Rating.Speed then
        table.insert(result.Advantage, f1.Name .. " has better Speed")
    elseif f2.Rating.Speed > f1.Rating.Speed then
        table.insert(result.Advantage, f2.Name .. " has better Speed")
    end
    if f1.Rating.Range > f2.Rating.Range then
        table.insert(result.Advantage, f1.Name .. " has better Range")
    elseif f2.Rating.Range > f1.Rating.Range then
        table.insert(result.Advantage, f2.Name .. " has better Range")
    end
    if f1.Rating.AoE > f2.Rating.AoE then
        table.insert(result.Advantage, f1.Name .. " has better AoE")
    elseif f2.Rating.AoE > f1.Rating.AoE then
        table.insert(result.Advantage, f2.Name .. " has better AoE")
    end
    if f1.Rating.Versatility > f2.Rating.Versatility then
        table.insert(result.Advantage, f1.Name .. " has better Versatility")
    elseif f2.Rating.Versatility > f1.Rating.Versatility then
        table.insert(result.Advantage, f2.Name .. " has better Versatility")
    end
    return result
end

-- ============================================================
-- A.FruitDB.GetFruitColor(name) - theme color
-- ============================================================
A.FruitDB._ColorMap = {
    Bomb = Color3.fromRGB(255, 85, 85),
    Spike = Color3.fromRGB(153, 85, 255),
    Chop = Color3.fromRGB(200, 200, 200),
    Spring = Color3.fromRGB(255, 170, 0),
    Smoke = Color3.fromRGB(200, 200, 200),
    Spin = Color3.fromRGB(170, 170, 170),
    Diamond = Color3.fromRGB(85, 255, 255),
    Eagle = Color3.fromRGB(170, 136, 255),
    Ice = Color3.fromRGB(85, 170, 255),
    Barrier = Color3.fromRGB(255, 170, 0),
    Ghost = Color3.fromRGB(200, 200, 255),
    Power = Color3.fromRGB(255, 170, 0),
    Rubber = Color3.fromRGB(255, 85, 85),
    Flame = Color3.fromRGB(255, 85, 0),
    Falcon = Color3.fromRGB(170, 136, 255),
    Qilin = Color3.fromRGB(85, 170, 255),
    Magma = Color3.fromRGB(255, 85, 0),
    Dark = Color3.fromRGB(50, 0, 100),
    Light = Color3.fromRGB(255, 255, 85),
    Love = Color3.fromRGB(255, 85, 170),
    Sound = Color3.fromRGB(255, 170, 0),
    Spider = Color3.fromRGB(170, 0, 0),
    Quake = Color3.fromRGB(136, 170, 255),
    Buddha = Color3.fromRGB(255, 230, 85),
    Phoenix = Color3.fromRGB(85, 170, 255),
    Portal = Color3.fromRGB(85, 85, 255),
    Pain = Color3.fromRGB(170, 85, 255),
    Blizzard = Color3.fromRGB(85, 200, 255),
    Gravity = Color3.fromRGB(136, 85, 170),
    Venom = Color3.fromRGB(0, 170, 0),
    Control = Color3.fromRGB(0, 85, 170),
    Dough = Color3.fromRGB(255, 200, 150),
    Dragon = Color3.fromRGB(0, 170, 0),
    Leopard = Color3.fromRGB(255, 170, 0),
    Kitsune = Color3.fromRGB(85, 136, 255),
    Mammoth = Color3.fromRGB(136, 100, 85),
    ["T-Rex"] = Color3.fromRGB(170, 136, 85),
    Spirit = Color3.fromRGB(136, 85, 255),
    Shadow = Color3.fromRGB(50, 0, 85),
    BuddhaAwakened = Color3.fromRGB(255, 255, 85),
    Gas = Color3.fromRGB(0, 200, 0),
}

function A.FruitDB.GetFruitColor(name)
    local f = _findFruit(name)
    if f and A.FruitDB._ColorMap[f.Name] then
        return A.FruitDB._ColorMap[f.Name]
    end
    return Color3.fromRGB(255, 255, 255)
end

-- ============================================================
-- A.FruitDB.GetFruitEmoji(name) - fruit emoji/icon
-- ============================================================
A.FruitDB._EmojiMap = {
    Bomb = "💣", Spike = "📌", Chop = "✂️", Spring = "🔩",
    Smoke = "🌫️", Spin = "🌀", Diamond = "💎", Eagle = "🦅",
    Ice = "❄️", Barrier = "🧱", Ghost = "👻", Power = "💪",
    Rubber = "🪢", Flame = "🔥", Falcon = "🦅", Qilin = "⚡",
    Magma = "🌋", Dark = "🌑", Light = "☀️", Love = "❤️",
    Sound = "🔊", Spider = "🕷️", Quake = "🌋", Buddha = "🧘",
    Phoenix = "🔥", Portal = "🌀", Pain = "💀", Blizzard = "❄️",
    Gravity = "🪨", Venom = "☠️", Control = "👁️", Dough = "🍩",
    Dragon = "🐉", Leopard = "🐆", Kitsune = "🦊", Mammoth = "🦣",
    ["T-Rex"] = "🦖", Spirit = "👻", Shadow = "👤", BuddhaAwakened = "🧘‍♂️",
    Gas = "☁️",
}

function A.FruitDB.GetFruitEmoji(name)
    local f = _findFruit(name)
    if f and A.FruitDB._EmojiMap[f.Name] then
        return A.FruitDB._EmojiMap[f.Name]
    end
    return "🍎"
end

-- ============================================================
-- A.FruitDB.SearchFruits(query) - search by name
-- ============================================================
function A.FruitDB.SearchFruits(query)
    if not query or query == "" then return A.FruitDB.All end
    local lower = string.lower(query)
    local results = {}
    for _, fruit in ipairs(A.FruitDB.All) do
        if string.find(string.lower(fruit.Name), lower, 1, true) then
            table.insert(results, fruit)
        elseif string.find(string.lower(fruit.DisplayName), lower, 1, true) then
            table.insert(results, fruit)
        elseif string.find(string.lower(fruit.Type), lower, 1, true) then
            table.insert(results, fruit)
        elseif string.find(string.lower(fruit.Rarity), lower, 1, true) then
            table.insert(results, fruit)
        end
    end
    return results
end

-- ============================================================
-- A.FruitDB.GetRandomFruit(rarity) - random fruit of rarity
-- ============================================================
function A.FruitDB.GetRandomFruit(rarity)
    local pool = {}
    if rarity then
        local lower = string.lower(rarity)
        for _, fruit in ipairs(A.FruitDB.All) do
            if string.lower(fruit.Rarity) == lower then
                table.insert(pool, fruit)
            end
        end
    else
        pool = A.FruitDB.All
    end
    if #pool == 0 then return nil end
    return pool[math.random(1, #pool)]
end

-- ============================================================
-- A.FruitDB.IsWorthSniping(name, price) - is it worth buying
-- ============================================================
function A.FruitDB.IsWorthSniping(name, price)
    local f = _findFruit(name)
    if not f then return false, "Fruit not found" end
    if not price or price <= 0 then return false, "Invalid price" end
    local threshold = f.Value * 0.6
    if f.MetaValue > 1000000 then
        threshold = f.MetaValue * 0.3
    end
    local ratio = price / f.Value
    local worthIt = price <= threshold
    local reason = ""
    if worthIt then
        reason = string.format("Excellent deal: %d%% of shop price", math.floor(ratio * 100))
    elseif price <= f.Value * 0.8 then
        reason = string.format("Good deal: %d%% of shop price", math.floor(ratio * 100))
    elseif price <= f.Value then
        reason = string.format("Fair price: %d%% of shop price", math.floor(ratio * 100))
    else
        reason = string.format("Overpriced: %d%% of shop price", math.floor(ratio * 100))
    end
    return worthIt, reason, ratio
end

-- ============================================================
-- A.FruitDB.GetSnipeTargets() - fruits worth sniping
-- ============================================================
function A.FruitDB.GetSnipeTargets()
    local targets = {}
    for _, fruit in ipairs(A.FruitDB.TradingValue) do
        if fruit.MetaValue >= 500000 or fruit.Rarity == "Mythical" or fruit.Rarity == "Legendary" then
            table.insert(targets, {
                Fruit = fruit,
                TargetPrice = math.floor(fruit.Value * 0.5),
                PotentialSavings = math.floor(fruit.Value * 0.5),
            })
        end
    end
    return targets
end

-- ============================================================
-- A.FruitDB.GetBestFruit(sea, purpose) - best fruit for situation
-- ============================================================
function A.FruitDB.GetBestFruit(sea, purpose)
    local lowerPurpose = purpose and string.lower(purpose) or "grinding"
    local seaNum = sea or 1
    local candidates = {}
    for _, fruit in ipairs(A.FruitDB.All) do
        local matchPurpose = false
        if lowerPurpose == "pvp" and fruit.BestFor == "PvP" then
            matchPurpose = true
        elseif lowerPurpose == "pve" and (fruit.BestFor == "Grinding" or fruit.BestFor == "Farming") then
            matchPurpose = true
        elseif lowerPurpose == "grinding" and fruit.BestFor == "Grinding" then
            matchPurpose = true
        elseif lowerPurpose == "farming" and fruit.BestFor == "Farming" then
            matchPurpose = true
        elseif lowerPurpose == "versatile" or lowerPurpose == "all" then
            matchPurpose = true
        end
        if matchPurpose then
            local tierBonus = 0
            if fruit.Tier == "S" then tierBonus = 5
            elseif fruit.Tier == "A" then tierBonus = 4
            elseif fruit.Tier == "B" then tierBonus = 3
            elseif fruit.Tier == "C" then tierBonus = 2
            else tierBonus = 1 end
            local seaBonus = 0
            if seaNum >= 2 and fruit.Rarity == "Legendary" then seaBonus = 1
            elseif seaNum >= 3 and fruit.Rarity == "Mythical" then seaBonus = 2 end
            local totalScore = fruit.Rating.Damage + fruit.Rating.Speed + fruit.Rating.Range +
                               fruit.Rating.AoE + fruit.Rating.Versatility + tierBonus + seaBonus
            table.insert(candidates, {Fruit = fruit, Score = totalScore})
        end
    end
    table.sort(candidates, function(a, b) return a.Score > b.Score end)
    if #candidates > 0 then return candidates[1].Fruit, candidates[1].Score end
    return nil, 0
end

-- ============================================================
-- A.FruitDB.GetFruitCount() - total fruits
-- ============================================================
function A.FruitDB.GetFruitCount()
    return #A.FruitDB.All
end

-- ============================================================
-- A.FruitDB.GetSpawnLocations(name) - spawn points
-- ============================================================
function A.FruitDB.GetSpawnLocations(name)
    local f = _findFruit(name)
    if f then return f.SpawnLocations end
    return {}
end

-- ============================================================
-- A.FruitDB.GetRarestFruit() - rarest fruit overall
-- ============================================================
function A.FruitDB.GetRarestFruit()
    local rarityOrder = { Mythical = 5, Legendary = 4, Rare = 3, Uncommon = 2, Common = 1 }
    local best = nil
    local bestScore = 0
    for _, fruit in ipairs(A.FruitDB.All) do
        local r = rarityOrder[fruit.Rarity] or 0
        local score = r * 10000000 + fruit.MetaValue
        if score > bestScore then
            bestScore = score
            best = fruit
        end
    end
    return best
end

-- ============================================================
-- A.FruitDB.GetCheapestFruit()
-- ============================================================
function A.FruitDB.GetCheapestFruit()
    local best = nil
    for _, fruit in ipairs(A.FruitDB.All) do
        if not best or fruit.Value < best.Value then
            best = fruit
        end
    end
    return best
end

-- ============================================================
-- A.FruitDB.GetMostExpensiveFruit()
-- ============================================================
function A.FruitDB.GetMostExpensiveFruit()
    local best = nil
    for _, fruit in ipairs(A.FruitDB.All) do
        if not best or fruit.Value > best.Value then
            best = fruit
        end
    end
    return best
end

-- ============================================================
-- A.FruitDB.UpdateOwned() - refresh owned list
-- ============================================================
function A.FruitDB.UpdateOwned()
    A.FruitDB.Owned = {}
    local player = game:GetService("Players").LocalPlayer
    if not player then return A.FruitDB.Owned end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            local fruitData = _findFruit(item.Name)
            if fruitData then
                table.insert(A.FruitDB.Owned, fruitData)
            end
        end
    end
    local character = player.Character
    if character then
        for _, item in ipairs(character:GetChildren()) do
            local fruitData = _findFruit(item.Name)
            if fruitData then
                table.insert(A.FruitDB.Owned, fruitData)
            end
        end
    end
    return A.FruitDB.Owned
end
