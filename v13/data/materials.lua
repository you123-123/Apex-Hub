local A = _G.Apex
A.Materials = {}

A.Materials.All = {
    -- ═══════════════════════════════════════════════════════
    -- COMMON MATERIALS
    -- ═══════════════════════════════════════════════════════
    {
        Name = "Magma Ore",
        DisplayName = "Magma Ore",
        Rarity = "Common",
        Value = 250,
        Sources = {"Magma Guard", "Magma Admiral", "Magma Golem"},
        Islands = {"Magma Village", "Hot and Cold"},
        Sea = 1,
        QuestRequired = "none",
        DropChance = 0.35,
        UsedFor = {"Magma Blade", "Magma Hammer", "Magma Stone"},
        FarmEfficiency = 8.2,
    },
    {
        Name = "Leather",
        DisplayName = "Leather",
        Rarity = "Common",
        Value = 100,
        Sources = {"Bandit", "Monkey", "Gorilla", "Fishman"},
        Islands = {"Starter Island", "Monkey Mountain", "Marine Fortress"},
        Sea = 1,
        QuestRequired = "none",
        DropChance = 0.45,
        UsedFor = {"Leather Armor", "Leather Boots", "Pirate Hat"},
        FarmEfficiency = 9.5,
    },
    {
        Name = "Scrap Metal",
        DisplayName = "Scrap Metal",
        Rarity = "Common",
        Value = 150,
        Sources = {"Pirate", "Brute", "Cyborg"},
        Islands = {"Pirate Village", "Prison", "Baratie"},
        Sea = 1,
        QuestRequired = "none",
        DropChance = 0.40,
        UsedFor = {"Iron Mace", "Pipe", "Refined Flintlock"},
        FarmEfficiency = 8.8,
    },
    {
        Name = "Angel Wings",
        DisplayName = "Angel Wings",
        Rarity = "Uncommon",
        Value = 750,
        Sources = {"Angel", " Fallen Angel", "Chromatic Angel"},
        Islands = {"Sky Islands", "Upper Sky", "Fountain City"},
        Sea = 1,
        QuestRequired = "none",
        DropChance = 0.20,
        UsedFor = {"Angelic Halo", "Sky Wings", "Heavenly Bow"},
        FarmEfficiency = 6.5,
    },
    {
        Name = "Fish Tail",
        DisplayName = "Fish Tail",
        Rarity = "Common",
        Value = 200,
        Sources = {"Fishman", "Shark", "Fishman Raider"},
        Islands = {"Underwater City", "Marine Fortress", "Frozen Village"},
        Sea = 1,
        QuestRequired = "none",
        DropChance = 0.40,
        UsedFor = {"Trident", "Fish Tail Sword", "Ocean Compass"},
        FarmEfficiency = 8.0,
    },
    {
        Name = "Mystic Droplet",
        DisplayName = "Mystic Droplet",
        Rarity = "Rare",
        Value = 2000,
        Sources = {"Water Fighter", "Mystic Guard", "Sea Creature"},
        Islands = {"Forgotten Island", "Underwater City"},
        Sea = 1,
        QuestRequired = "none",
        DropChance = 0.12,
        UsedFor = "Water Sword",
        FarmEfficiency = 5.0,
    },
    {
        Name = "Dragon Scale",
        DisplayName = "Dragon Scale",
        Rarity = "Legendary",
        Value = 5000,
        Sources = {"Dragon", "Sea Dragon", "Flying Dragon"},
        Islands = {"Forgotten Island", "Dead Mountain"},
        Sea = 1,
        QuestRequired = "none",
        DropChance = 0.05,
        UsedFor = {"Dragon Blade", "Dragon Armor"},
        FarmEfficiency = 3.2,
    },
    {
        Name = "Fool's Gold",
        DisplayName = "Fool's Gold",
        Rarity = "Uncommon",
        Value = 500,
        Sources = {"Jester", "Clown", "Trickster"},
        Islands = {"Pirate Village", "Colosseum"},
        Sea = 1,
        QuestRequired = "none",
        DropChance = 0.25,
        UsedFor = {"Golden Hook", "Jester's Blade"},
        FarmEfficiency = 7.0,
    },
    {
        Name = "Vampire Fang",
        DisplayName = "Vampire Fang",
        Rarity = "Uncommon",
        Value = 600,
        Sources = {"Vampire", "Bat", "Dark Vampire"},
        Islands = {"Graveyard", "Cursed Ship"},
        Sea = 2,
        QuestRequired = "none",
        DropChance = 0.28,
        UsedFor = {"Vampire Blade", "Blood Scythe"},
        FarmEfficiency = 7.2,
    },
    {
        Name = "Conjured Cocoa",
        DisplayName = "Conjured Cocoa",
        Rarity = "Uncommon",
        Value = 550,
        Sources = {"Cocoa Warrior", "Chocolate Boy", "Sweet Thief"},
        Islands = {"Kingdom of Rose", "Cafe"},
        Sea = 2,
        QuestRequired = "none",
        DropChance = 0.30,
        UsedFor = {"Sweet Sword", "Cocoa Blade"},
        FarmEfficiency = 7.8,
    },
    {
        Name = "Large Bone",
        DisplayName = "Large Bone",
        Rarity = "Rare",
        Value = 1500,
        Sources = {"Skeleton", "Bone Warrior", "Undead Knight"},
        Islands = {"Graveyard", "Haunted Castle"},
        Sea = 2,
        QuestRequired = "none",
        DropChance = 0.15,
        UsedFor = {"Bone Blade", "Skeleton Hammer"},
        FarmEfficiency = 5.5,
    },
    {
        Name = "Bird Feather",
        DisplayName = "Bird Feather",
        Rarity = "Common",
        Value = 300,
        Sources = {"Bird", "Sky Bird", "Falcon"},
        Islands = {"Sky Islands", "Upper Sky", "Land on the Sky"},
        Sea = 1,
        QuestRequired = "none",
        DropChance = 0.38,
        UsedFor = {"Feather Hat", "Wind Bow"},
        FarmEfficiency = 8.5,
    },
    {
        Name = "Iron Alloy",
        DisplayName = "Iron Alloy",
        Rarity = "Common",
        Value = 350,
        Sources = {"Iron Soldier", "Metal Knight", "Steel Guard"},
        Islands = {"Marine Fortress", "Prison"},
        Sea = 1,
        QuestRequired = "none",
        DropChance = 0.32,
        UsedFor = {"Steel Blade", "Iron Shield"},
        FarmEfficiency = 8.3,
    },
    {
        Name = "Dark Fragment",
        DisplayName = "Dark Fragment",
        Rarity = "Rare",
        Value = 3000,
        Sources = {"Dark Lord", "Shadow Reaper", "Void Walker"},
        Islands = {"Mysterious Dungeon", "Cursed Ship"},
        Sea = 1,
        QuestRequired = "Dark Blade Quest",
        DropChance = 0.08,
        UsedFor = {"Dark Blade", "Shadow Scythe"},
        FarmEfficiency = 4.0,
    },
    {
        Name = "Frozen Heart",
        DisplayName = "Frozen Heart",
        Rarity = "Uncommon",
        Value = 700,
        Sources = {"Snow Soldier", "Ice Admiral", "Frozen Guard"},
        Islands = {"Frozen Village", "Frozen Village Sea 2"},
        Sea = 1,
        QuestRequired = "none",
        DropChance = 0.22,
        UsedFor = {"Ice Blade", "Frozen Shield"},
        FarmEfficiency = 6.8,
    },
    {
        Name = "Ectoplasm",
        DisplayName = "Ectoplasm",
        Rarity = "Uncommon",
        Value = 650,
        Sources = {"Ghost", "Phantom", "Spirit Warrior"},
        Islands = {"Cursed Ship", "Graveyard"},
        Sea = 2,
        QuestRequired = "none",
        DropChance = 0.25,
        UsedFor = {"Soul Guitar", "Ectoplasm Blade"},
        FarmEfficiency = 7.0,
    },
    {
        Name = "Cursed Cloth",
        DisplayName = "Cursed Cloth",
        Rarity = "Rare",
        Value = 2500,
        Sources = {"Cursed Spirit", "Doom Guard", "Haunted Knight"},
        Islands = {"Cursed Ship", "Haunted Castle"},
        Sea = 2,
        QuestRequired = "none",
        DropChance = 0.10,
        UsedFor = {"Cursed Dual Katana", "Ghost Cloth Armor"},
        FarmEfficiency = 4.5,
    },
    {
        Name = "Relic",
        DisplayName = "Relic",
        Rarity = "Rare",
        Value = 4000,
        Sources = {"Temple Guard", "Ancient Warrior", "Relic Hunter"},
        Islands = {"Sky Islands", "Fountain City"},
        Sea = 1,
        QuestRequired = "none",
        DropChance = 0.07,
        UsedFor = {"Soul Cane", "Relic Blade"},
        FarmEfficiency = 3.8,
    },
    {
        Name = "Mystic Fragment",
        DisplayName = "Mystic Fragment",
        Rarity = "Rare",
        Value = 3500,
        Sources = {"Mystic Mage", "Arcane Guard", "Spell Caster"},
        Islands = {"Kingdom of Rose", "Dressrosa"},
        Sea = 2,
        QuestRequired = "none",
        DropChance = 0.09,
        UsedFor = {"Mystic Katana", "Arcane Staff"},
        FarmEfficiency = 4.2,
    },
    {
        Name = "Dragon Fang",
        DisplayName = "Dragon Fang",
        Rarity = "Legendary",
        Value = 8000,
        Sources = {"Dragon Lord", "Ancient Dragon", "Wyvern"},
        Islands = {"Dead Mountain", "Forgotten Island"},
        Sea = 1,
        QuestRequired = "Dragon Quest",
        DropChance = 0.03,
        UsedFor = {"Dragon Claw", "Dragon Fang Sword"},
        FarmEfficiency = 2.5,
    },
    -- ═══════════════════════════════════════════════════════
    -- SEA 2 MATERIALS
    -- ═══════════════════════════════════════════════════════
    {
        Name = "Radioactive Material",
        DisplayName = "Radioactive Material",
        Rarity = "Uncommon",
        Value = 800,
        Sources = {"Factory Worker", "Nuclear Zombie", "Mutant"},
        Islands = {"Hot and Cold", "Green Zone"},
        Sea = 2,
        QuestRequired = "none",
        DropChance = 0.20,
        UsedFor = {"Gamma Blade", "Radioactive Sword"},
        FarmEfficiency = 6.5,
    },
    {
        Name = "Granite",
        DisplayName = "Granite",
        Rarity = "Common",
        Value = 400,
        Sources = {"Stone Golem", "Rock Monster", "Granite Guard"},
        Islands = {"Kingdom of Rose", "Green Bit"},
        Sea = 2,
        QuestRequired = "none",
        DropChance = 0.35,
        UsedFor = {"Stone Blade", "Rock Shield"},
        FarmEfficiency = 8.0,
    },
    {
        Name = "Obsidian",
        DisplayName = "Obsidian",
        Rarity = "Rare",
        Value = 2800,
        Sources = {"Dark Stone", "Obsidian Golem", "Shadow Rock"},
        Islands = {"Graveyard", "Cursed Ship"},
        Sea = 2,
        QuestRequired = "none",
        DropChance = 0.11,
        UsedFor = {"Dark Katana", "Obsidian Armor"},
        FarmEfficiency = 4.3,
    },
    {
        Name = "Phoenix Feather",
        DisplayName = "Phoenix Feather",
        Rarity = "Legendary",
        Value = 6000,
        Sources = {"Phoenix", "Flame Bird", "Ash Bird"},
        Islands = {"Green Zone", "Usoapp's Island"},
        Sea = 2,
        QuestRequired = "Phoenix Quest",
        DropChance = 0.04,
        UsedFor = {"Phoenix Blade", "Flame Scythe"},
        FarmEfficiency = 2.8,
    },
    {
        Name = "Quake Core",
        DisplayName = "Quake Core",
        Rarity = "Legendary",
        Value = 10000,
        Sources = {"Quake Guardian", "Earthquake Golem", "Tremor Titan"},
        Islands = {"Colosseum Sea 2", "Graveyard"},
        Sea = 2,
        QuestRequired = "Quake Quest",
        DropChance = 0.02,
        UsedFor = {"Quake Fist", "Tremor Blade"},
        FarmEfficiency = 2.0,
    },
    {
        Name = "Warrior's Resolve",
        DisplayName = "Warrior's Resolve",
        Rarity = "Uncommon",
        Value = 900,
        Sources = {"Arena Fighter", "Gladiator", "Champion"},
        Islands = {"Colosseum Sea 2", "Dressrosa"},
        Sea = 2,
        QuestRequired = "none",
        DropChance = 0.18,
        UsedFor = {"Arena Blade", "Gladiator Armor"},
        FarmEfficiency = 6.0,
    },
    {
        Name = "Living Coral",
        DisplayName = "Living Coral",
        Rarity = "Uncommon",
        Value = 700,
        Sources = {"Coral Guard", "Sea Anemone", "Ocean Warrior"},
        Islands = {"Forgotten Island", "Underwater City"},
        Sea = 1,
        QuestRequired = "none",
        DropChance = 0.22,
        UsedFor = {"Coral Sword", "Ocean Armor"},
        FarmEfficiency = 6.8,
    },
    {
        Name = "Shadow Essence",
        DisplayName = "Shadow Essence",
        Rarity = "Rare",
        Value = 3200,
        Sources = {"Shadow Boss", "Dark Shade", "Void Knight"},
        Islands = {"Haunted Castle", "Cursed Ship"},
        Sea = 2,
        QuestRequired = "none",
        DropChance = 0.08,
        UsedFor = {"Shadow Blade", "Void Armor"},
        FarmEfficiency = 3.5,
    },
    {
        Name = "Electric Wing",
        DisplayName = "Electric Wing",
        Rarity = "Rare",
        Value = 2200,
        Sources = {"Thunder Bird", "Electric Eagle", "Storm Hawk"},
        Islands = {"Sky Islands", "Land on the Sky"},
        Sea = 1,
        QuestRequired = "none",
        DropChance = 0.14,
        UsedFor = {"Electric Blade", "Thunder Bow"},
        FarmEfficiency = 5.2,
    },
    {
        Name = "Treasure Chest",
        DisplayName = "Treasure Chest",
        Rarity = "Common",
        Value = 500,
        Sources = {"Treasure Guardian", "Gold Golem", "Coin Monster"},
        Islands = {"Pirate Village", "Shipwreck"},
        Sea = 2,
        QuestRequired = "none",
        DropChance = 0.30,
        UsedFor = {"Gold Sword", "Treasure Map"},
        FarmEfficiency = 7.5,
    },
    -- ═══════════════════════════════════════════════════════
    -- SEA 3 MATERIALS
    -- ═══════════════════════════════════════════════════════
    {
        Name = "Leviathan Scale",
        DisplayName = "Leviathan Scale",
        Rarity = "Mythical",
        Value = 25000,
        Sources = {"Leviathan", "Sea Leviathan", "Deep Lord"},
        Islands = {"Great Tree", "Temple of Time"},
        Sea = 3,
        QuestRequired = "Leviathan Quest",
        DropChance = 0.01,
        UsedFor = {"Leviathan Blade", "Sea King Armor"},
        FarmEfficiency = 1.0,
    },
    {
        Name = "Mystic Isotope",
        DisplayName = "Mystic Isotope",
        Rarity = "Rare",
        Value = 4500,
        Sources = {"Isotope Guard", "Mystic Soldier", "Dimension Walker"},
        Islands = {"Temple of Time", "Floating Turtle"},
        Sea = 3,
        QuestRequired = "none",
        DropChance = 0.08,
        UsedFor = {"Isotope Blade", "Mystic Core"},
        FarmEfficiency = 3.8,
    },
    {
        Name = "Shark Tooth",
        DisplayName = "Shark Tooth",
        Rarity = "Uncommon",
        Value = 850,
        Sources = {"Shark", "Tiger Shark", "Megalodon"},
        Islands = {"Hydra Island", "Tiki Outpost"},
        Sea = 3,
        QuestRequired = "none",
        DropChance = 0.22,
        UsedFor = {"Shark Anchor", "Tiger Tooth Blade"},
        FarmEfficiency = 6.5,
    },
    {
        Name = "Kitsune Tail",
        DisplayName = "Kitsune Tail",
        Rarity = "Legendary",
        Value = 7500,
        Sources = {"Kitsune", "Moon Fox", "Spirit Fox"},
        Islands = {"Kitsune Island"},
        Sea = 3,
        QuestRequired = "Kitsune Quest",
        DropChance = 0.04,
        UsedFor = {"Kitsune Sword", "Moon Blade"},
        FarmEfficiency = 2.5,
    },
    {
        Name = "Valkyrie Helm",
        DisplayName = "Valkyrie Helm",
        Rarity = "Rare",
        Value = 3800,
        Sources = {"Valkyrie", "Berserker", "Shield Maiden"},
        Islands = {"Floating Turtle", "Castle on the Sea"},
        Sea = 3,
        QuestRequired = "none",
        DropChance = 0.10,
        UsedFor = {"Valkyrie Sword", "Berserker Axe"},
        FarmEfficiency = 4.2,
    },
    {
        Name = "Frozen Bone",
        DisplayName = "Frozen Bone",
        Rarity = "Uncommon",
        Value = 750,
        Sources = {"Frozen Skeleton", "Ice Revenant", "Frost Knight"},
        Islands = {"Haunted Castle", "Tiki Outpost"},
        Sea = 3,
        QuestRequired = "none",
        DropChance = 0.20,
        UsedFor = {"Frozen Blade", "Frost Armor"},
        FarmEfficiency = 6.8,
    },
    {
        Name = "Dragon Heart",
        DisplayName = "Dragon Heart",
        Rarity = "Mythical",
        Value = 20000,
        Sources = {"Ancient Dragon", "Dragon King", "Primal Wyrm"},
        Islands = {"Temple of Time", "Great Tree"},
        Sea = 3,
        QuestRequired = "Dragon Heart Quest",
        DropChance = 0.015,
        UsedFor = {"Dragon Heart Sword", "Dragon God Armor"},
        FarmEfficiency = 1.2,
    },
    {
        Name = "Cursed Gem",
        DisplayName = "Cursed Gem",
        Rarity = "Legendary",
        Value = 9000,
        Sources = {"Gem Guardian", "Cursed Jewel", "Dark Crystal"},
        Islands = {"Haunted Castle", "Castle on the Sea"},
        Sea = 3,
        QuestRequired = "none",
        DropChance = 0.03,
        UsedFor = {"Gem Blade", "Crystal Armor"},
        FarmEfficiency = 2.2,
    },
    {
        Name = "Sea Prism",
        DisplayName = "Sea Prism",
        Rarity = "Rare",
        Value = 3000,
        Sources = {"Sea Crystal", "Ocean Guardian", "Coral King"},
        Islands = {"Port Town", "Hydra Island"},
        Sea = 3,
        QuestRequired = "none",
        DropChance = 0.12,
        UsedFor = {"Sea Blade", "Ocean Armor"},
        FarmEfficiency = 4.8,
    },
    {
        Name = "Treat",
        DisplayName = "Treat",
        Rarity = "Uncommon",
        Value = 600,
        Sources = {"Candy Soldier", "Cookie Guard", "Sugar Monster"},
        Islands = {"Sea of Treats"},
        Sea = 3,
        QuestRequired = "none",
        DropChance = 0.25,
        UsedFor = {"Candy Blade", "Sweet Shield"},
        FarmEfficiency = 7.2,
    },
    {
        Name = "Moon Stone",
        DisplayName = "Moon Stone",
        Rarity = "Rare",
        Value = 4000,
        Sources = {"Moon Soldier", "Lunar Guard", "Eclipse Knight"},
        Islands = {"Kitsune Island", "Temple of Time"},
        Sea = 3,
        QuestRequired = "none",
        DropChance = 0.09,
        UsedFor = {"Moon Blade", "Lunar Sword"},
        FarmEfficiency = 4.0,
    },
    {
        Name = "Titan's Blood",
        DisplayName = "Titan's Blood",
        Rarity = "Legendary",
        Value = 8500,
        Sources = {"Titan Guard", "Ancient Titan", "Colossus"},
        Islands = {"Marble Island", "Great Tree"},
        Sea = 3,
        QuestRequired = "Titan Quest",
        DropChance = 0.035,
        UsedFor = {"Titan Blade", "Colossus Hammer"},
        FarmEfficiency = 2.3,
    },
    {
        Name = "Ancient Amber",
        DisplayName = "Ancient Amber",
        Rarity = "Rare",
        Value = 3600,
        Sources = {"Amber Golem", "Prehistoric Guard", "Fossil Knight"},
        Islands = {"Marble Island", "Hydra Island"},
        Sea = 3,
        QuestRequired = "none",
        DropChance = 0.10,
        UsedFor = {"Amber Blade", "Ancient Shield"},
        FarmEfficiency = 4.1,
    },
    {
        Name = "Glacial Essence",
        DisplayName = "Glacial Essence",
        Rarity = "Uncommon",
        Value = 750,
        Sources = {"Glacial Guard", "Ice Golem", "Frost Monster"},
        Islands = {"Frozen Village Sea 2", "Tiki Outpost"},
        Sea = 3,
        QuestRequired = "none",
        DropChance = 0.22,
        UsedFor = {"Glacial Blade", "Frost Core"},
        FarmEfficiency = 6.6,
    },
    {
        Name = "Void Crystal",
        DisplayName = "Void Crystal",
        Rarity = "Mythical",
        Value = 15000,
        Sources = {"Void Lord", "Dimension Boss", "Eclipse Guardian"},
        Islands = {"Temple of Time"},
        Sea = 3,
        QuestRequired = "Void Quest",
        DropChance = 0.02,
        UsedFor = {"Void Blade", "Dimension Armor"},
        FarmEfficiency = 1.5,
    },
}

A.Materials.RarityOrder = {
    ["Common"] = 1,
    ["Uncommon"] = 2,
    ["Rare"] = 3,
    ["Legendary"] = 4,
    ["Mythical"] = 5,
}

A.Materialsfunctions = {}

function A.Materialsfunctions.GetMaterial(name)
    for _, mat in ipairs(A.Materials.All) do
        if mat.Name == name then
            return mat
        end
    end
    return nil
end

function A.Materialsfunctions.GetMaterialSources(name)
    local mat = A.Materialsfunctions.GetMaterial(name)
    if mat then
        return mat.Sources or {}
    end
    return {}
end

function A.Materialsfunctions.GetMaterialValue(name)
    local mat = A.Materialsfunctions.GetMaterial(name)
    if mat then
        return mat.Value or 0
    end
    return 0
end

function A.Materialsfunctions.GetMaterialRarity(name)
    local mat = A.Materialsfunctions.GetMaterial(name)
    if mat then
        return mat.Rarity or "Common"
    end
    return "Common"
end

function A.Materialsfunctions.GetFarmingIslands(name)
    local mat = A.Materialsfunctions.GetMaterial(name)
    if mat then
        return mat.Islands or {}
    end
    return {}
end

function A.Materialsfunctions.GetRequiredForItem(itemName)
    local result = {}
    for _, mat in ipairs(A.Materials.All) do
        if type(mat.UsedFor) == "table" then
            for _, item in ipairs(mat.UsedFor) do
                if item == itemName then
                    table.insert(result, mat)
                end
            end
        elseif mat.UsedFor == itemName then
            table.insert(result, mat)
        end
    end
    return result
end

function A.Materialsfunctions.GetOptimalFarm(matName)
    local mat = A.Materialsfunctions.GetMaterial(matName)
    if not mat then return nil end
    local bestIsland = nil
    local bestScore = 0
    for _, islandName in ipairs(mat.Islands) do
        local island = A.Islandsfunctions.GetIsland(islandName)
        if island then
            local score = mat.FarmEfficiency * (mat.DropChance or 0.1)
            if score > bestScore then
                bestScore = score
                bestIsland = island
            end
        end
    end
    return bestIsland, bestScore
end

function A.Materialsfunctions.GetMaterialDropChance(mob, mat)
    for _, material in ipairs(A.Materials.All) do
        if material.Name == mat then
            for _, source in ipairs(material.Sources) do
                if source == mob then
                    return material.DropChance
                end
            end
        end
    end
    return 0
end

function A.Materialsfunctions.GetMaterialsForSea(sea)
    local result = {}
    for _, mat in ipairs(A.Materials.All) do
        if mat.Sea == sea then
            table.insert(result, mat)
        end
    end
    return result
end

function A.Materialsfunctions.GetMaterialCount(name)
    if A.Inventory and A.Inventory.Materials then
        return A.Inventory.Materials[name] or 0
    end
    return 0
end

function A.Materialsfunctions.SortByValue()
    local sorted = {}
    for _, mat in ipairs(A.Materials.All) do
        table.insert(sorted, mat)
    end
    table.sort(sorted, function(a, b) return a.Value > b.Value end)
    return sorted
end

function A.Materialsfunctions.SortByRarity()
    local sorted = {}
    for _, mat in ipairs(A.Materials.All) do
        table.insert(sorted, mat)
    end
    table.sort(sorted, function(a, b)
        local ra = A.Materials.RarityOrder[a.Rarity] or 1
        local rb = A.Materials.RarityOrder[b.Rarity] or 1
        return ra > rb
    end)
    return sorted
end

function A.Materialsfunctions.GetBestMaterialFarm(sea)
    local mats = A.Materialsfunctions.GetMaterialsForSea(sea)
    local best = nil
    local bestVal = 0
    for _, mat in ipairs(mats) do
        local score = mat.Value * mat.FarmEfficiency * mat.DropChance
        if score > bestVal then
            bestVal = score
            best = mat
        end
    end
    return best, bestVal
end

return A.Materials
