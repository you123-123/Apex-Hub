local A = _G.Apex
A.Shops = {}

A.Shops.All = {
    -- ═══════════════════════════════════════════════════════
    -- SEA 1 SHOPS
    -- ═══════════════════════════════════════════════════════
    {
        Name = "Sword Dealer",
        NPC = "Sword Dealer",
        Position = CFrame.new(-4460, 215, -1960),
        Island = "Starter Island",
        Sea = 1,
        Category = "Weapon",
        Items = {
            {Name = "Cutlass", Price = 100, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Katana", Price = 500, Currency = "Beli", RequiredLevel = 5, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Iron Mace", Price = 1000, Currency = "Beli", RequiredLevel = 10, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Dual Katana", Price = 8000, Currency = "Beli", RequiredLevel = 50, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Triple Katana", Price = 5000, Currency = "Beli", RequiredLevel = 30, RequiredItem = "none", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Gun Dealer",
        NPC = "Gun Dealer",
        Position = CFrame.new(-4310, 218, -1480),
        Island = "Marine Fortress",
        Sea = 1,
        Category = "Weapon",
        Items = {
            {Name = "Slingshot", Price = 50, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Flintlock", Price = 500, Currency = "Beli", RequiredLevel = 10, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Musket", Price = 1500, Currency = "Beli", RequiredLevel = 30, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Cannon", Price = 10000, Currency = "Beli", RequiredLevel = 150, RequiredItem = "none", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Fighting Style Teacher",
        NPC = "Fighting Style Teacher",
        Position = CFrame.new(-4300, 220, -1490),
        Island = "Marine Fortress",
        Sea = 1,
        Category = "FightingStyle",
        Items = {
            {Name = "Black Leg", Price = 15000, Currency = "Beli", RequiredLevel = 100, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Ken Haki Punch", Price = 0, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Haki Teacher",
        NPC = "Haki Teacher",
        Position = CFrame.new(-3790, 208, -1190),
        Island = "Shanks' Town",
        Sea = 1,
        Category = "Accessory",
        Items = {
            {Name = "Buso Haki", Price = 25000, Currency = "Beli", RequiredLevel = 20, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Observation Haki", Price = 25000, Currency = "Beli", RequiredLevel = 20, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Enhancement Color 1", Price = 5000, Currency = "Beli", RequiredLevel = 0, RequiredItem = "Buso Haki", Limited = false, Stock = 0},
            {Name = "Enhancement Color 2", Price = 10000, Currency = "Beli", RequiredLevel = 0, RequiredItem = "Buso Haki", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Blacksmith",
        NPC = "Blacksmith",
        Position = CFrame.new(-3180, 260, -590),
        Island = "Magma Village",
        Sea = 1,
        Category = "Material",
        Items = {
            {Name = "Metal Alloy", Price = 5000, Currency = "Beli", RequiredLevel = 0, RequiredItem = "Scrap Metal x5", Limited = false, Stock = 0},
            {Name = "Magma Blade", Price = 15000, Currency = "Beli", RequiredLevel = 80, RequiredItem = "Magma Ore x10", Limited = false, Stock = 0},
            {Name = "Frozen Blade", Price = 12000, Currency = "Beli", RequiredLevel = 100, RequiredItem = "Frozen Heart x8", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Coliseum Dealer",
        NPC = "Medal Vendor",
        Position = CFrame.new(-1690, 128, 910),
        Island = "Colosseum",
        Sea = 1,
        Category = "Accessory",
        Items = {
            {Name = "Warrior Helmet", Price = 20000, Currency = "Beli", RequiredLevel = 100, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Gladiator Belt", Price = 15000, Currency = "Beli", RequiredLevel = 80, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Champion Cape", Price = 25000, Currency = "Beli", RequiredLevel = 120, RequiredItem = "none", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Sky Merchant",
        NPC = "Cloud Merchant",
        Position = CFrame.new(-790, 808, 1810),
        Island = "Sky Islands",
        Sea = 1,
        Category = "Weapon",
        Items = {
            {Name = "Dragon Claw", Price = 50000, Currency = "Beli", RequiredLevel = 120, RequiredItem = "Dragon Fang x5", Limited = false, Stock = 0},
            {Name = "Soul Cane", Price = 60000, Currency = "Beli", RequiredLevel = 150, RequiredItem = "Relic x3", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Deep Sea Merchant",
        NPC = "Deep Sea Merchant",
        Position = CFrame.new(-990, -292, 2010),
        Island = "Underwater City",
        Sea = 1,
        Category = "Weapon",
        Items = {
            {Name = "Fishman Karate", Price = 100000, Currency = "Beli", RequiredLevel = 350, RequiredItem = "Fish Tail x10", Limited = false, Stock = 0},
            {Name = "Trident", Price = 45000, Currency = "Beli", RequiredLevel = 250, RequiredItem = "Fish Tail x8", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Undead Dealer",
        NPC = "Undead Dealer",
        Position = CFrame.new(-1090, 408, 1510),
        Island = "Dead Mountain",
        Sea = 1,
        Category = "Weapon",
        Items = {
            {Name = "Scythe", Price = 80000, Currency = "Beli", RequiredLevel = 250, RequiredItem = "Large Bone x12", Limited = false, Stock = 0},
            {Name = "Bone Blade", Price = 35000, Currency = "Beli", RequiredLevel = 200, RequiredItem = "Large Bone x5", Limited = false, Stock = 0},
        },
    },
    -- ═══════════════════════════════════════════════════════
    -- SEA 2 SHOPS
    -- ═══════════════════════════════════════════════════════
    {
        Name = "Blox Fruit Dealer",
        NPC = "Blox Fruit Dealer",
        Position = CFrame.new(-2690, 308, -990),
        Island = "Cafe",
        Sea = 2,
        Category = "Fruit",
        Items = {
            {Name = "Flame Fruit", Price = 250000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Ice Fruit", Price = 350000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Quake Fruit", Price = 2000000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = true, Stock = 1},
            {Name = "Buddha Fruit", Price = 1800000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = true, Stock = 1},
            {Name = "Light Fruit", Price = 650000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Dark Fruit", Price = 500000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Magma Fruit", Price = 300000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Rumble Fruit", Price = 450000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Gas Fruit", Price = 400000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Control Fruit", Price = 2200000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = true, Stock = 1},
            {Name = "Dough Fruit", Price = 2500000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = true, Stock = 1},
            {Name = "Dragon Fruit", Price = 3500000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = true, Stock = 1},
            {Name = "Leopard Fruit", Price = 5000000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = true, Stock = 1},
        },
    },
    {
        Name = "Sword Dealer Sea 2",
        NPC = "Sword Dealer",
        Position = CFrame.new(-2695, 312, -975),
        Island = "Cafe",
        Sea = 2,
        Category = "Weapon",
        Items = {
            {Name = "Sabi", Price = 20000, Currency = "Beli", RequiredLevel = 175, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Wando", Price = 20000, Currency = "Beli", RequiredLevel = 175, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Shisui", Price = 30000, Currency = "Beli", RequiredLevel = 200, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Sandai Kitetsu", Price = 40000, Currency = "Beli", RequiredLevel = 220, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Yubashiri", Price = 50000, Currency = "Beli", RequiredLevel = 250, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Bisento", Price = 80000, Currency = "Beli", RequiredLevel = 850, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Kabucha", Price = 75000, Currency = "Beli", RequiredLevel = 850, RequiredItem = "none", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Fighting Style Teacher 2",
        NPC = "Master Fighting Teacher",
        Position = CFrame.new(-2685, 306, -1010),
        Island = "Cafe",
        Sea = 2,
        Category = "FightingStyle",
        Items = {
            {Name = "Superhuman", Price = 300000, Currency = "Beli", RequiredLevel = 1000, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Death Step", Price = 250000, Currency = "Beli", RequiredLevel = 1200, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Electric Claw", Price = 200000, Currency = "Beli", RequiredLevel = 1150, RequiredItem = "none", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Boss Drop Shop",
        NPC = "Boss Shop",
        Position = CFrame.new(-2680, 300, -1020),
        Island = "Cafe",
        Sea = 2,
        Category = "Weapon",
        Items = {
            {Name = "Gravity Cane", Price = 150000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Koketsu", Price = 100000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Spikey Trident", Price = 200000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "none", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Material Exchange",
        NPC = "Material Exchange",
        Position = CFrame.new(-2700, 295, -985),
        Island = "Cafe",
        Sea = 2,
        Category = "Material",
        Items = {
            {Name = "Leather to Beli", Price = 0, Currency = "Materials", RequiredLevel = 0, RequiredItem = "Leather x10", Limited = false, Stock = 0},
            {Name = "Scrap Metal to Beli", Price = 0, Currency = "Materials", RequiredLevel = 0, RequiredItem = "Scrap Metal x10", Limited = false, Stock = 0},
            {Name = "Magma Ore to Beli", Price = 0, Currency = "Materials", RequiredLevel = 0, RequiredItem = "Magma Ore x10", Limited = false, Stock = 0},
            {Name = "Fish Tail to Beli", Price = 0, Currency = "Materials", RequiredLevel = 0, RequiredItem = "Fish Tail x10", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Blacksmith Sea 2",
        NPC = "Blacksmith",
        Position = CFrame.new(-2690, 298, -1005),
        Island = "Cafe",
        Sea = 2,
        Category = "Material",
        Items = {
            {Name = "Gamma Blade", Price = 120000, Currency = "Beli", RequiredLevel = 900, RequiredItem = "Radioactive Material x8", Limited = false, Stock = 0},
            {Name = "Vampire Blade", Price = 80000, Currency = "Beli", RequiredLevel = 800, RequiredItem = "Vampire Fang x10", Limited = false, Stock = 0},
            {Name = "Sweet Sword", Price = 65000, Currency = "Beli", RequiredLevel = 750, RequiredItem = "Conjured Cocoa x8", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Sword Dealer Dressrosa",
        NPC = "Sword Dealer",
        Position = CFrame.new(-1790, 248, -390),
        Island = "Dressrosa",
        Sea = 2,
        Category = "Weapon",
        Items = {
            {Name = "Canvander", Price = 150000, Currency = "Beli", RequiredLevel = 1875, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Dual Katana", Price = 100000, Currency = "Beli", RequiredLevel = 900, RequiredItem = "none", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Race Reroll Shop",
        NPC = "Race Reroll",
        Position = CFrame.new(-1490, 225, -190),
        Island = "Hot and Cold",
        Sea = 2,
        Category = "Race",
        Items = {
            {Name = "Race Reroll", Price = 3000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Fruit Notifier", Price = 2500, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "none", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Coliseum Champion Shop",
        NPC = "Arena Champion",
        Position = CFrame.new(-290, 165, 610),
        Island = "Colosseum Sea 2",
        Sea = 2,
        Category = "Accessory",
        Items = {
            {Name = "Champion Cape V2", Price = 50000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Gladiator Armor V2", Price = 40000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Arena Ring", Price = 30000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "none", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Cursed Merchant",
        NPC = "Cursed Merchant",
        Position = CFrame.new(10, 55, 810),
        Island = "Cursed Ship",
        Sea = 2,
        Category = "Weapon",
        Items = {
            {Name = "Midnight Blade", Price = 300000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "Ectoplasm x100", Limited = false, Stock = 0},
            {Name = "Soul Guitar", Price = 500000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "Ectoplasm x200", Limited = true, Stock = 1},
        },
    },
    -- ═══════════════════════════════════════════════════════
    -- SEA 3 SHOPS
    -- ═══════════════════════════════════════════════════════
    {
        Name = "Blox Fruit Dealer Sea 3",
        NPC = "Blox Fruit Dealer",
        Position = CFrame.new(-190, 108, -2990),
        Island = "Port Town",
        Sea = 3,
        Category = "Fruit",
        Items = {
            {Name = "Flame Fruit", Price = 250000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Ice Fruit", Price = 350000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Quake Fruit", Price = 2000000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = true, Stock = 1},
            {Name = "Buddha Fruit", Price = 1800000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = true, Stock = 1},
            {Name = "Light Fruit", Price = 650000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Dark Fruit", Price = 500000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Magma Fruit", Price = 300000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Rumble Fruit", Price = 450000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Gas Fruit", Price = 400000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Control Fruit", Price = 2200000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = true, Stock = 1},
            {Name = "Dough Fruit", Price = 2500000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = true, Stock = 1},
            {Name = "Dragon Fruit", Price = 3500000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = true, Stock = 1},
            {Name = "Leopard Fruit", Price = 5000000, Currency = "Beli", RequiredLevel = 1, RequiredItem = "none", Limited = true, Stock = 1},
        },
    },
    {
        Name = "Fighting Style Teacher 3",
        NPC = "Grand Master",
        Position = CFrame.new(-200, 105, -3010),
        Island = "Port Town",
        Sea = 3,
        Category = "FightingStyle",
        Items = {
            {Name = "Dragon Talon", Price = 500000, Currency = "Fragments", RequiredLevel = 1600, RequiredItem = "Dragon Fang x15", Limited = false, Stock = 0},
            {Name = "Sharkman Karate", Price = 350000, Currency = "Beli", RequiredLevel = 1250, RequiredItem = "Shark Tooth x10", Limited = false, Stock = 0},
            {Name = "Mink", Price = 200000, Currency = "Beli", RequiredLevel = 300, RequiredItem = "none", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Godhuman Teacher",
        NPC = "Ancient One",
        Position = CFrame.new(-190, 308, -2590),
        Island = "Floating Turtle",
        Sea = 3,
        Category = "FightingStyle",
        Items = {
            {Name = "Godhuman", Price = 1000000, Currency = "Fragments", RequiredLevel = 1800, RequiredItem = "Cursed Cloth x20", Limited = false, Stock = 0},
            {Name = "Sanguine Art", Price = 800000, Currency = "Fragments", RequiredLevel = 1900, RequiredItem = "Shadow Essence x15", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Sword Dealer Sea 3",
        NPC = "Legendary Sword Dealer",
        Position = CFrame.new(-185, 315, -2585),
        Island = "Floating Turtle",
        Sea = 3,
        Category = "Weapon",
        Items = {
            {Name = "Tushita", Price = 500000, Currency = "Fragments", RequiredLevel = 1800, RequiredItem = "none", Limited = true, Stock = 1},
            {Name = "Yama", Price = 500000, Currency = "Fragments", RequiredLevel = 1900, RequiredItem = "none", Limited = true, Stock = 1},
            {Name = "Cursed Dual Katana", Price = 1000000, Currency = "Fragments", RequiredLevel = 2100, RequiredItem = "Tushita + Yama", Limited = true, Stock = 1},
            {Name = "Shark Anchor", Price = 300000, Currency = "Fragments", RequiredLevel = 1600, RequiredItem = "Shark Tooth x15", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Blacksmith Sea 3",
        NPC = "Master Blacksmith",
        Position = CFrame.new(210, 358, -2390),
        Island = "Castle on the Sea",
        Sea = 3,
        Category = "Material",
        Items = {
            {Name = "Leviathan Blade", Price = 500000, Currency = "Fragments", RequiredLevel = 1900, RequiredItem = "Leviathan Scale x5", Limited = true, Stock = 1},
            {Name = "Gem Blade", Price = 250000, Currency = "Fragments", RequiredLevel = 2000, RequiredItem = "Cursed Gem x8", Limited = false, Stock = 0},
            {Name = "Titan Blade", Price = 300000, Currency = "Fragments", RequiredLevel = 2100, RequiredItem = "Titan's Blood x10", Limited = false, Stock = 0},
            {Name = "Void Blade", Price = 400000, Currency = "Fragments", RequiredLevel = 2300, RequiredItem = "Void Crystal x5", Limited = true, Stock = 1},
        },
    },
    {
        Name = "Race Reroll Shop Sea 3",
        NPC = "Mysterious Dealer",
        Position = CFrame.new(215, 355, -2400),
        Island = "Castle on the Sea",
        Sea = 3,
        Category = "Race",
        Items = {
            {Name = "Race Reroll", Price = 3000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Fruit Reroll", Price = 5000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "none", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Tiki Shop",
        NPC = "Tiki Merchant",
        Position = CFrame.new(-490, 98, -3190),
        Island = "Tiki Outpost",
        Sea = 3,
        Category = "Weapon",
        Items = {
            {Name = "Dragon Talon Sword", Price = 250000, Currency = "Fragments", RequiredLevel = 1600, RequiredItem = "Dragon Heart x3", Limited = false, Stock = 0},
            {Name = "Shark Anchor V2", Price = 200000, Currency = "Fragments", RequiredLevel = 1700, RequiredItem = "Shark Tooth x20", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Kitsune Shop",
        NPC = "Moon Merchant",
        Position = CFrame.new(610, 88, -1190),
        Island = "Kitsune Island",
        Sea = 3,
        Category = "Accessory",
        Items = {
            {Name = "Kitsune Mask", Price = 100000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "Kitsune Tail x10", Limited = false, Stock = 0},
            {Name = "Moon Cape", Price = 150000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "Moon Stone x8", Limited = false, Stock = 0},
            {Name = "Fox Lamp", Price = 200000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "Kitsune Tail x15", Limited = true, Stock = 1},
        },
    },
    {
        Name = "Sea of Treats Shop",
        NPC = "Candy Merchant",
        Position = CFrame.new(-990, 158, -1490),
        Island = "Sea of Treats",
        Sea = 3,
        Category = "Accessory",
        Items = {
            {Name = "Candy Cape", Price = 50000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "Treat x20", Limited = false, Stock = 0},
            {Name = "Sugar Ring", Price = 75000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "Treat x30", Limited = false, Stock = 0},
            {Name = "Sweet Helmet", Price = 60000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "Treat x25", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Temple Guardian Shop",
        NPC = "Temple Guardian",
        Position = CFrame.new(10, 708, -3790),
        Island = "Temple of Time",
        Sea = 3,
        Category = "Weapon",
        Items = {
            {Name = "Almighty Sword", Price = 2000000, Currency = "Fragments", RequiredLevel = 2300, RequiredItem = "Void Crystal x10 + Dragon Heart x5", Limited = true, Stock = 1},
            {Name = "Isotope Blade", Price = 500000, Currency = "Fragments", RequiredLevel = 2200, RequiredItem = "Mystic Isotope x12", Limited = false, Stock = 0},
            {Name = "Moon Blade", Price = 400000, Currency = "Fragments", RequiredLevel = 2100, RequiredItem = "Moon Stone x10", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Enhancement Colors Shop",
        NPC = "Color Dealer",
        Position = CFrame.new(-2710, 305, -1000),
        Island = "Cafe",
        Sea = 2,
        Category = "Accessory",
        Items = {
            {Name = "Black Enhancement", Price = 50000, Currency = "Beli", RequiredLevel = 0, RequiredItem = "Buso Haki", Limited = false, Stock = 0},
            {Name = "Red Enhancement", Price = 75000, Currency = "Beli", RequiredLevel = 0, RequiredItem = "Buso Haki", Limited = false, Stock = 0},
            {Name = "Blue Enhancement", Price = 75000, Currency = "Beli", RequiredLevel = 0, RequiredItem = "Buso Haki", Limited = false, Stock = 0},
            {Name = "Green Enhancement", Price = 75000, Currency = "Beli", RequiredLevel = 0, RequiredItem = "Buso Haki", Limited = false, Stock = 0},
            {Name = "Purple Enhancement", Price = 100000, Currency = "Beli", RequiredLevel = 0, RequiredItem = "Buso Haki", Limited = false, Stock = 0},
            {Name = "Yellow Enhancement", Price = 100000, Currency = "Beli", RequiredLevel = 0, RequiredItem = "Buso Haki", Limited = false, Stock = 0},
            {Name = "White Enhancement", Price = 150000, Currency = "Beli", RequiredLevel = 0, RequiredItem = "Buso Haki", Limited = false, Stock = 0},
            {Name = "Pink Enhancement", Price = 125000, Currency = "Beli", RequiredLevel = 0, RequiredItem = "Buso Haki", Limited = false, Stock = 0},
        },
    },
    {
        Name = "Accessory Shop",
        NPC = "Accessory Dealer",
        Position = CFrame.new(-2698, 302, -998),
        Island = "Cafe",
        Sea = 2,
        Category = "Accessory",
        Items = {
            {Name = "Pirate Hat", Price = 15000, Currency = "Beli", RequiredLevel = 50, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Leather Armor", Price = 10000, Currency = "Beli", RequiredLevel = 30, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Shark Hood", Price = 40000, Currency = "Beli", RequiredLevel = 200, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Ice Cape", Price = 55000, Currency = "Beli", RequiredLevel = 300, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Flame Cape", Price = 65000, Currency = "Beli", RequiredLevel = 400, RequiredItem = "none", Limited = false, Stock = 0},
            {Name = "Leviathan Crown", Price = 500000, Currency = "Fragments", RequiredLevel = 0, RequiredItem = "Leviathan Scale x3", Limited = true, Stock = 1},
        },
    },
}

A.Shops.CategoryOrder = {
    ["Weapon"] = 1,
    ["Fruit"] = 2,
    ["FightingStyle"] = 3,
    ["Accessory"] = 4,
    ["Material"] = 5,
    ["Race"] = 6,
}

A.Shopsfunctions = {}

function A.Shopsfunctions.GetShop(name)
    for _, shop in ipairs(A.Shops.All) do
        if shop.Name == name then
            return shop
        end
    end
    return nil
end

function A.Shopsfunctions.GetShopItems(shopName)
    local shop = A.Shopsfunctions.GetShop(shopName)
    if shop then
        return shop.Items or {}
    end
    return {}
end

function A.Shopsfunctions.GetShopByItem(itemName)
    for _, shop in ipairs(A.Shops.All) do
        for _, item in ipairs(shop.Items) do
            if item.Name == itemName then
                return shop
            end
        end
    end
    return nil
end

function A.Shopsfunctions.GetShopPosition(shopName)
    local shop = A.Shopsfunctions.GetShop(shopName)
    if shop then
        return shop.Position
    end
    return nil
end

function A.Shopsfunctions.BuyItem(shopName, itemName)
    local shop = A.Shopsfunctions.GetShop(shopName)
    if not shop then return false, "Shop not found" end
    for _, item in ipairs(shop.Items) do
        if item.Name == itemName then
            if A.Player and A.Player.Data then
                if A.Player.Data.Level.Value < item.RequiredLevel then
                    return false, "Level too low"
                end
                if item.RequiredItem ~= "none" then
                    local hasRequired = A.Inventory and A.Inventory.HasItem and A.Inventory.HasItem(item.RequiredItem)
                    if not hasRequired then
                        return false, "Missing required item: " .. item.RequiredItem
                    end
                end
                if item.Currency == "Beli" and A.Player.Data.Beli.Value < item.Price then
                    return false, "Not enough Beli"
                elseif item.Currency == "Fragments" and A.Player.Data.Fragments.Value < item.Price then
                    return false, "Not enough Fragments"
                end
                return true, "Can buy"
            end
            return false, "Player data not available"
        end
    end
    return false, "Item not found in shop"
end

function A.Shopsfunctions.CanAfford(shopName, itemName)
    local shop = A.Shopsfunctions.GetShop(shopName)
    if not shop then return false end
    for _, item in ipairs(shop.Items) do
        if item.Name == itemName then
            if A.Player and A.Player.Data then
                if item.Currency == "Beli" then
                    return A.Player.Data.Beli.Value >= item.Price
                elseif item.Currency == "Fragments" then
                    return A.Player.Data.Fragments.Value >= item.Price
                end
            end
            return false
        end
    end
    return false
end

function A.Shopsfunctions.GetRequiredForItem(itemName)
    local shop = A.Shopsfunctions.GetShopByItem(itemName)
    if shop then
        for _, item in ipairs(shop.Items) do
            if item.Name == itemName then
                return item.RequiredItem, item.RequiredLevel, item.Price, item.Currency
            end
        end
    end
    return "none", 0, 0, "Beli"
end

function A.Shopsfunctions.GetAllShops(sea)
    local result = {}
    for _, shop in ipairs(A.Shops.All) do
        if shop.Sea == sea then
            table.insert(result, shop)
        end
    end
    return result
end

function A.Shopsfunctions.GetShopNPCs()
    local npcs = {}
    for _, shop in ipairs(A.Shops.All) do
        table.insert(npcs, shop.NPC)
    end
    return npcs
end

function A.Shopsfunctions.GetClosestShop(pos)
    local closest = nil
    local closestDist = math.huge
    for _, shop in ipairs(A.Shops.All) do
        local dist = (pos - shop.Position).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = shop
        end
    end
    return closest, closestDist
end

function A.Shopsfunctions.GetShopCategory(category)
    local result = {}
    for _, shop in ipairs(A.Shops.All) do
        if shop.Category == category then
            table.insert(result, shop)
        end
    end
    return result
end

function A.Shopsfunctions.IsLimited(shopName, itemName)
    local shop = A.Shopsfunctions.GetShop(shopName)
    if shop then
        for _, item in ipairs(shop.Items) do
            if item.Name == itemName then
                return item.Limited or false
            end
        end
    end
    return false
end

function A.Shopsfunctions.GetItemPrice(shopName, itemName)
    local shop = A.Shopsfunctions.GetShop(shopName)
    if shop then
        for _, item in ipairs(shop.Items) do
            if item.Name == itemName then
                return item.Price, item.Currency
            end
        end
    end
    return 0, "Beli"
end

function A.Shopsfunctions.SearchItems(query)
    local results = {}
    local lowerQuery = string.lower(query)
    for _, shop in ipairs(A.Shops.All) do
        for _, item in ipairs(shop.Items) do
            if string.find(string.lower(item.Name), lowerQuery) then
                table.insert(results, {
                    Item = item,
                    Shop = shop.Name,
                    Island = shop.Island,
                })
            end
        end
    end
    return results
end

function A.Shopsfunctions.GetFruitDealerLocation()
    for _, shop in ipairs(A.Shops.All) do
        if shop.Category == "Fruit" then
            return shop.Position, shop.Island
        end
    end
    return nil, nil
end

function A.Shopsfunctions.GetRaceShop()
    for _, shop in ipairs(A.Shops.All) do
        if shop.Category == "Race" then
            return shop
        end
    end
    return nil
end

function A.Shopsfunctions.GetMaterialExchange()
    for _, shop in ipairs(A.Shops.All) do
        if shop.Category == "Material" and string.find(shop.Name, "Exchange") then
            return shop
        end
    end
    return nil
end

return A.Shops
