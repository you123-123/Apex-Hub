local A = _G.Apex
if not A then return end

A.Awaken = {}
A.Awaken.Active = false
A.Awaken.CurrentFruit = nil
A.Awaken.Progress = 0
A.Awaken.Level = 0
A.Awaken.Materials = {}
A.Awaken.Chips = {}
A.Awaken.Stats = {
    FruitsAwakened = 0,
    ChipsUsed = 0,
    RaidsCompleted = 0,
    MaterialsFarmed = 0,
    SessionStart = tick()
}

A.Awaken.FruitData = {
    ["Flame"] = { MaxLevel = 5, Raid = "Flame Raid", Materials = {"Flame Fragment", "Magma Ore"}, ChipCost = 1000, FragmentsPerLevel = 500 },
    ["Ice"] = { MaxLevel = 5, Raid = "Ice Raid", Materials = {"Ice Fragment", "Frozen Heart"}, ChipCost = 1000, FragmentsPerLevel = 500 },
    ["Light"] = { MaxLevel = 5, Raid = "Light Raid", Materials = {"Light Fragment", "Angel Wings"}, ChipCost = 1000, FragmentsPerLevel = 500 },
    ["Dark"] = { MaxLevel = 5, Raid = "Dark Raid", Materials = {"Dark Fragment", "Soul Gem"}, ChipCost = 1000, FragmentsPerLevel = 500 },
    ["Rubber"] = { MaxLevel = 5, Raid = "Rubber Raid", Materials = {"Rubber Fragment", "Elastic Core"}, ChipCost = 1000, FragmentsPerLevel = 500 },
    ["Magma"] = { MaxLevel = 5, Raid = "Magma Raid", Materials = {"Magma Fragment", "Volcanic Rock"}, ChipCost = 1000, FragmentsPerLevel = 500 },
    ["Buddha"] = { MaxLevel = 5, Raid = "Buddha Raid", Materials = {"Buddha Fragment", "Ancient Scroll"}, ChipCost = 1500, FragmentsPerLevel = 750 },
    ["Phoenix"] = { MaxLevel = 5, Raid = "Phoenix Raid", Materials = {"Phoenix Fragment", "Rebirth Flame"}, ChipCost = 1500, FragmentsPerLevel = 750 },
    ["Spider"] = { MaxLevel = 5, Raid = "Spider Raid", Materials = {"Spider Fragment", "Venom Sac"}, ChipCost = 1000, FragmentsPerLevel = 500 },
    ["Quake"] = { MaxLevel = 5, Raid = "Quake Raid", Materials = {"Quake Fragment", "Tectonic Plate"}, ChipCost = 1500, FragmentsPerLevel = 750 },
    ["Human"] = { MaxLevel = 5, Raid = "Human Raid", Materials = {"Human Fragment", "Life Essence"}, ChipCost = 1000, FragmentsPerLevel = 500 },
    ["Blizzard"] = { MaxLevel = 5, Raid = "Blizzard Raid", Materials = {"Blizzard Fragment", "Frost Core"}, ChipCost = 1200, FragmentsPerLevel = 600 },
    ["Gravity"] = { MaxLevel = 5, Raid = "Gravity Raid", Materials = {"Gravity Fragment", "Neutron Star"}, ChipCost = 1200, FragmentsPerLevel = 600 },
    ["Dough"] = { MaxLevel = 5, Raid = "Dough Raid", Materials = {"Dough Fragment", "Sweet Core"}, ChipCost = 1500, FragmentsPerLevel = 750 },
    ["Shadow"] = { MaxLevel = 5, Raid = "Shadow Raid", Materials = {"Shadow Fragment", "Void Crystal"}, ChipCost = 1500, FragmentsPerLevel = 750 },
    ["Control"] = { MaxLevel = 5, Raid = "Control Raid", Materials = {"Control Fragment", "Mind Core"}, ChipCost = 2000, FragmentsPerLevel = 1000 },
    ["Dragon"] = { MaxLevel = 5, Raid = "Dragon Raid", Materials = {"Dragon Fragment", "Dragon Scale"}, ChipCost = 2000, FragmentsPerLevel = 1000 },
    ["Leopard"] = { MaxLevel = 5, Raid = "Leopard Raid", Materials = {"Leopard Fragment", "Spotted Core"}, ChipCost = 2000, FragmentsPerLevel = 1000 },
    ["Spirit"] = { MaxLevel = 5, Raid = "Spirit Raid", Materials = {"Spirit Fragment", "Soul Stone"}, ChipCost = 2000, FragmentsPerLevel = 1000 },
    ["Kitsune"] = { MaxLevel = 5, Raid = "Kitsune Raid", Materials = {"Kitsune Fragment", "Fox Tail"}, ChipCost = 2500, FragmentsPerLevel = 1250 },
    ["T-Rex"] = { MaxLevel = 5, Raid = "T-Rex Raid", Materials = {"T-Rex Fragment", "Fossil Core"}, ChipCost = 2500, FragmentsPerLevel = 1250 },
    ["Mammoth"] = { MaxLevel = 5, Raid = "Mammoth Raid", Materials = {"Mammoth Fragment", "Permafrost"}, ChipCost = 2500, FragmentsPerLevel = 1250 },
    ["Gas"] = { MaxLevel = 5, Raid = "Gas Raid", Materials = {"Gas Fragment", "Toxic Core"}, ChipCost = 2500, FragmentsPerLevel = 1250 },
    ["Sound"] = { MaxLevel = 5, Raid = "Sound Raid", Materials = {"Sound Fragment", "Resonance Crystal"}, ChipCost = 2500, FragmentsPerLevel = 1250 },
    ["Venom"] = { MaxLevel = 5, Raid = "Venom Raid", Materials = {"Venom Fragment", "Poison Gland"}, ChipCost = 2500, FragmentsPerLevel = 1250 },
    ["Magma V2"] = { MaxLevel = 5, Raid = "Magma V2 Raid", Materials = {"Magma V2 Fragment", "Eruption Core"}, ChipCost = 2500, FragmentsPerLevel = 1250 },
    ["Spider V2"] = { MaxLevel = 5, Raid = "Spider V2 Raid", Materials = {"Spider V2 Fragment", "Web Core"}, ChipCost = 2500, FragmentsPerLevel = 1250 }
}

A.Awaken.AwakeningLevels = {
    [0] = { Name = "Base", Multiplier = 1.0, SkillsUnlocked = {} },
    [1] = { Name = "Stage 1", Multiplier = 1.2, SkillsUnlocked = {"Z"} },
    [2] = { Name = "Stage 2", Multiplier = 1.4, SkillsUnlocked = {"Z", "X"} },
    [3] = { Name = "Stage 3", Multiplier = 1.6, SkillsUnlocked = {"Z", "X", "C"} },
    [4] = { Name = "Stage 4", Multiplier = 1.8, SkillsUnlocked = {"Z", "X", "C", "V"} },
    [5] = { Name = "Max", Multiplier = 2.0, SkillsUnlocked = {"Z", "X", "C", "V", "F"} }
}

A.Awaken.AwakeningSkills = {
    ["Flame"] = {
        [1] = { Name = "Fire Fist Awakened", Skill = "Z", Damage = 120, Cooldown = 3 },
        [2] = { Name = "Fire Column Awakened", Skill = "X", Damage = 150, Cooldown = 4 },
        [3] = { Name = "Fire Elite Awakened", Skill = "C", Damage = 200, Cooldown = 6 },
        [4] = { Name = "Flame Emperor Awakened", Skill = "V", Damage = 300, Cooldown = 10 },
        [5] = { Name = "Fire Bird Awakened", Skill = "F", Damage = 180, Cooldown = 5 }
    },
    ["Ice"] = {
        [1] = { Name = "Ice Lance Awakened", Skill = "Z", Damage = 110, Cooldown = 3 },
        [2] = { Name = "Ice Spears Awakened", Skill = "X", Damage = 140, Cooldown = 4 },
        [3] = { Name = "Ice Block Awakened", Skill = "C", Damage = 180, Cooldown = 5 },
        [4] = { Name = "Frozen Domain Awakened", Skill = "V", Damage = 280, Cooldown = 10 },
        [5] = { Name = "Ice Age Awakened", Skill = "F", Damage = 160, Cooldown = 5 }
    },
    ["Light"] = {
        [1] = { Name = "Light Beam Awakened", Skill = "Z", Damage = 130, Cooldown = 2 },
        [2] = { Name = "Light Speed Slash Awakened", Skill = "X", Damage = 160, Cooldown = 3 },
        [3] = { Name = "Light Pillar Awakened", Skill = "C", Damage = 220, Cooldown = 5 },
        [4] = { Name = "Sacred Judgment Awakened", Skill = "V", Damage = 320, Cooldown = 10 },
        [5] = { Name = "Light Speed Kick Awakened", Skill = "F", Damage = 190, Cooldown = 4 }
    },
    ["Dark"] = {
        [1] = { Name = "Black Hole Awakened", Skill = "Z", Damage = 140, Cooldown = 3 },
        [2] = { Name = "World Splitter Awakened", Skill = "X", Damage = 170, Cooldown = 4 },
        [3] = { Name = "Demon Caliber Awakened", Skill = "C", Damage = 230, Cooldown = 6 },
        [4] = { Name = "Endless Darkness Awakened", Skill = "V", Damage = 350, Cooldown = 12 },
        [5] = { Name = "Black Leg Awakened", Skill = "F", Damage = 200, Cooldown = 5 }
    },
    ["Rubber"] = {
        [1] = { Name = "Gum Gum Pistol Awakened", Skill = "Z", Damage = 125, Cooldown = 2 },
        [2] = { Name = "Gum Gum Gatling Awakened", Skill = "X", Damage = 155, Cooldown = 3 },
        [3] = { Name = "Gum Gum Bazooka Awakened", Skill = "C", Damage = 210, Cooldown = 5 },
        [4] = { Name = "Gum Gum Red Hawk Awakened", Skill = "V", Damage = 310, Cooldown = 10 },
        [5] = { Name = "Gum Gum Rifle Awakened", Skill = "F", Damage = 185, Cooldown = 4 }
    },
    ["Buddha"] = {
        [1] = { Name = "Buddha Palm Awakened", Skill = "Z", Damage = 160, Cooldown = 4 },
        [2] = { Name = "Buddha Slam Awakened", Skill = "X", Damage = 200, Cooldown = 5 },
        [3] = { Name = "Buddha Beam Awakened", Skill = "C", Damage = 260, Cooldown = 7 },
        [4] = { Name = "Buddha Rage Awakened", Skill = "V", Damage = 400, Cooldown = 12 },
        [5] = { Name = "Buddha Leap Awakened", Skill = "F", Damage = 220, Cooldown = 5 }
    },
    ["Dough"] = {
        [1] = { Name = "Dough Fist Awakened", Skill = "Z", Damage = 135, Cooldown = 3 },
        [2] = { Name = "Dough Slap Awakened", Skill = "X", Damage = 165, Cooldown = 4 },
        [3] = { Name = "Dough Roller Awakened", Skill = "C", Damage = 240, Cooldown = 6 },
        [4] = { Name = "Dough Vortex Awakened", Skill = "V", Damage = 360, Cooldown = 11 },
        [5] = { Name = "Dough Wave Awakened", Skill = "F", Damage = 195, Cooldown = 4 }
    },
    ["Dragon"] = {
        [1] = { Name = "Dragon Claw Awakened", Skill = "Z", Damage = 150, Cooldown = 3 },
        [2] = { Name = "Dragon Breath Awakened", Skill = "X", Damage = 180, Cooldown = 4 },
        [3] = { Name = "Dragon Flight Awakened", Skill = "C", Damage = 250, Cooldown = 6 },
        [4] = { Name = "Dragon Domination Awakened", Skill = "V", Damage = 380, Cooldown = 12 },
        [5] = { Name = "Dragon Storm Awakened", Skill = "F", Damage = 210, Cooldown = 5 }
    }
}

local function GetLocalFruit()
    local char = A.Char()
    if not char then return nil end
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local fruitData = tool:FindFirstChild("Fruit")
            if fruitData then
                return tool.Name
            end
        end
    end
    local backpack = A.LP:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local fruitData = tool:FindFirstChild("Fruit")
                if fruitData then
                    return tool.Name
                end
            end
        end
    end
    return nil
end

local function GetFruitAwakeningLevel(fruitName)
    if not fruitName then return 0 end
    local success, result = pcall(function()
        return A.CommF("getAwakeningLevel", fruitName)
    end)
    if success and result then
        return result
    end
    return 0
end

local function GetFruitAwakeningProgress(fruitName)
    if not fruitName then return 0 end
    local success, result = pcall(function()
        return A.CommF("getAwakeningProgress", fruitName)
    end)
    if success and result then
        return result
    end
    return 0
end

local function HasAwakeningChip(fruitName)
    if not fruitName then return false end
    local success, result = pcall(function()
        return A.CommF("hasAwakeningChip", fruitName)
    end)
    if success and result then
        return result
    end
    return false
end

local function GetAwakeningMaterials(fruitName)
    if not fruitName then return {} end
    local fruitData = A.Awaken.FruitData[fruitName]
    if not fruitData then return {} end
    local materials = {}
    for _, matName in ipairs(fruitData.Materials) do
        local count = 0
        local success, result = pcall(function()
            return A.CommF("getItemCount", matName)
        end)
        if success and result then
            count = result
        end
        table.insert(materials, { Name = matName, Count = count })
    end
    return materials
end

local function GetRequiredMaterials(fruitName)
    local fruitData = A.Awaken.FruitData[fruitName]
    if not fruitData then return {} end
    return fruitData.Materials
end

local function HasAllMaterials(fruitName)
    local materials = GetAwakeningMaterials(fruitName)
    for _, mat in ipairs(materials) do
        if mat.Count < 5 then
            return false
        end
    end
    return true
end

local function GetFragmentCount()
    local success, result = pcall(function()
        return A.CommF("getFragmentCount")
    end)
    if success and result then
        return result
    end
    return 0
end

local function GetChipCount()
    local success, result = pcall(function()
        return A.CommF("getChipCount")
    end)
    if success and result then
        return result
    end
    return 0
end

local function GetRaidPosition(raidName)
    local raidPositions = {
        ["Flame Raid"] = CFrame.new(-5400, 1100, -500),
        ["Ice Raid"] = CFrame.new(-5400, 1100, -500),
        ["Light Raid"] = CFrame.new(-5400, 1100, -500),
        ["Dark Raid"] = CFrame.new(-5400, 1100, -500),
        ["Rubber Raid"] = CFrame.new(-5400, 1100, -500),
        ["Magma Raid"] = CFrame.new(-5400, 1100, -500),
        ["Buddha Raid"] = CFrame.new(-5400, 1100, -500),
        ["Phoenix Raid"] = CFrame.new(-5400, 1100, -500),
        ["Spider Raid"] = CFrame.new(-5400, 1100, -500),
        ["Quake Raid"] = CFrame.new(-5400, 1100, -500),
        ["Human Raid"] = CFrame.new(-5400, 1100, -500),
        ["Control Raid"] = CFrame.new(-5400, 1100, -500),
        ["Dragon Raid"] = CFrame.new(-5400, 1100, -500),
        ["Dough Raid"] = CFrame.new(-5400, 1100, -500),
        ["Leopard Raid"] = CFrame.new(-5400, 1100, -500),
        ["Spirit Raid"] = CFrame.new(-5400, 1100, -500),
        ["Kitsune Raid"] = CFrame.new(-5400, 1100, -500),
        ["T-Rex Raid"] = CFrame.new(-5400, 1100, -500),
        ["Mammoth Raid"] = CFrame.new(-5400, 1100, -500),
        ["Gas Raid"] = CFrame.new(-5400, 1100, -500),
        ["Sound Raid"] = CFrame.new(-5400, 1100, -500),
        ["Venom Raid"] = CFrame.new(-5400, 1100, -500),
        ["Magma V2 Raid"] = CFrame.new(-5400, 1100, -500),
        ["Spider V2 Raid"] = CFrame.new(-5400, 1100, -500)
    }
    return raidPositions[raidName] or CFrame.new(-5400, 1100, -500)
end

local function GetRaidEnemies(raidName)
    local raidEnemies = {
        ["Flame Raid"] = {"Fire Guardian", "Flame Beast", "Lava Golem"},
        ["Ice Raid"] = {"Ice Warrior", "Frost Giant", "Blizzard Lord"},
        ["Light Raid"] = {"Light Angel", "Holy Knight", "Radiance"},
        ["Dark Raid"] = {"Shadow Assassin", "Void Walker", "Dark Lord"},
        ["Rubber Raid"] = {"Rubber Soldier", "Elastic Guard", "Bouncy Knight"},
        ["Magma Raid"] = {"Magma Warrior", "Volcanic Beast", "Lava Lord"},
        ["Buddha Raid"] = {"Buddha Monk", "Enlightened One", "Divine Guardian"},
        ["Phoenix Raid"] = {"Phoenix Warrior", "Flame Bird", "Rebirth Phoenix"},
        ["Spider Raid"] = {"Spider Guard", "Venom Soldier", "Web Master"},
        ["Quake Raid"] = {"Quake Warrior", "Tectonic Guard", "Earth Shaker"},
        ["Human Raid"] = {"Human Soldier", "Life Guardian", "Soul Reaper"},
        ["Control Raid"] = {"Control Agent", "Mind Walker", "Psychic Lord"},
        ["Dragon Raid"] = {"Dragon Warrior", "Scale Guard", "Dragon Lord"},
        ["Dough Raid"] = {"Dough Soldier", "Sugar Guard", "Sweet Lord"},
        ["Leopard Raid"] = {"Leopard Warrior", "Spotted Guard", "Feline Lord"},
        ["Spirit Raid"] = {"Spirit Walker", "Ghost Knight", "Soul Guardian"},
        ["Kitsune Raid"] = {"Kitsune Warrior", "Fox Guard", "Nine-Tails"},
        ["T-Rex Raid"] = {"T-Rex Warrior", "Fossil Guard", "Primal Lord"},
        ["Mammoth Raid"] = {"Mammoth Warrior", "Permafrost Guard", "Ice Age Lord"},
        ["Gas Raid"] = {"Gas Warrior", "Toxic Guard", "Fume Lord"},
        ["Sound Raid"] = {"Sound Warrior", "Echo Guard", "Sonic Lord"},
        ["Venom Raid"] = {"Venom Warrior", "Poison Guard", "Toxic Lord"},
        ["Magma V2 Raid"] = {"Magma V2 Warrior", "Eruption Guard", "Inferno Lord"},
        ["Spider V2 Raid"] = {"Spider V2 Warrior", "Web Guard", "Arachnid Lord"}
    }
    return raidEnemies[raidName] or {"Unknown Enemy"}
end

local function WaitForRaidStart(timeout)
    local startTime = tick()
    while tick() - startTime < (timeout or 120) do
        local success, inRaid = pcall(function()
            return A.CommF("isInRaid")
        end)
        if success and inRaid then
            return true
        end
        task.wait(1)
    end
    return false
end

local function WaitForRaidComplete(timeout)
    local startTime = tick()
    while tick() - startTime < (timeout or 300) do
        local success, complete = pcall(function()
            return A.CommF("isRaidComplete")
        end)
        if success and complete then
            return true
        end
        local success2, inRaid = pcall(function()
            return A.CommF("isInRaid")
        end)
        if success2 and not inRaid then
            return false
        end
        task.wait(1)
    end
    return false
end

local function FarmRaidEnemies(raidName)
    local enemies = GetRaidEnemies(raidName)
    local startTime = tick()
    while tick() - startTime < 180 do
        if not A.Awaken.Active then return false end
        local target = A.FindTarget(300)
        if target then
            A.SuperAttack(target)
            task.wait(0.1)
        else
            local enemiesFound = false
            for _, enemyName in ipairs(enemies) do
                local enemy = workspace:FindFirstChild(enemyName, true)
                if enemy then
                    local hrp = enemy:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        A.TpTo(hrp.Position, 5)
                        enemiesFound = true
                        break
                    end
                end
            end
            if not enemiesFound then
                task.wait(1)
            end
        end
        task.wait(0.1)
    end
    return true
end

function A.Awaken.GetFruitAwakening()
    local fruit = GetLocalFruit()
    if not fruit then
        return nil, 0, 0
    end
    local level = GetFruitAwakeningLevel(fruit)
    local progress = GetFruitAwakeningProgress(fruit)
    return fruit, level, progress
end

function A.Awaken.HasAwakening()
    local fruit, level, progress = A.Awaken.GetFruitAwakening()
    return fruit ~= nil and level > 0
end

function A.Awaken.GetAwakeningLevel()
    local fruit, level = A.Awaken.GetFruitAwakening()
    return level
end

function A.Awaken.GetAwakeningProgress(fruit)
    if not fruit then
        fruit = GetLocalFruit()
    end
    if not fruit then return 0 end
    return GetFruitAwakeningProgress(fruit)
end

function A.Awaken.GetAwakeningRequirements(fruit)
    if not fruit then
        fruit = GetLocalFruit()
    end
    if not fruit then return nil end
    local fruitData = A.Awaken.FruitData[fruit]
    if not fruitData then return nil end
    local currentLevel = GetFruitAwakeningLevel(fruit)
    local requirements = {
        CurrentLevel = currentLevel,
        MaxLevel = fruitData.MaxLevel,
        RaidName = fruitData.Raid,
        Materials = fruitData.Materials,
        ChipCost = fruitData.ChipCost,
        FragmentsNeeded = fruitData.FragmentsPerLevel,
        CurrentFragments = GetFragmentCount(),
        HasChip = HasAwakeningChip(fruit),
        MaterialsOwned = GetAwakeningMaterials(fruit)
    }
    return requirements
end

function A.Awaken.GetAwakeningChips(fruit)
    if not fruit then
        fruit = GetLocalFruit()
    end
    if not fruit then return 0 end
    local chipCount = GetChipCount()
    return chipCount
end

function A.Awaken.BuyAwakeningChip(fruit)
    if not fruit then
        fruit = GetLocalFruit()
    end
    if not fruit then return false end
    local fruitData = A.Awaken.FruitData[fruit]
    if not fruitData then return false end
    local currentFragments = GetFragmentCount()
    if currentFragments < fruitData.ChipCost then
        A.Notify("Awakening", "Not enough fragments! Need " .. fruitData.ChipCost, 5)
        return false
    end
    local success, result = pcall(function()
        return A.CommF("buyAwakeningChip", fruit)
    end)
    if success and result then
        A.Awaken.Stats.ChipsUsed = A.Awaken.Stats.ChipsUsed + 1
        A.Notify("Awakening", "Bought awakening chip for " .. fruit, 3)
        return true
    end
    A.Notify("Awakening", "Failed to buy awakening chip", 3)
    return false
end

function A.Awaken.StartAwakening()
    if not A.Awaken.Active then return false end
    local fruit, level = A.Awaken.GetFruitAwakening()
    if not fruit then
        A.Notify("Awakening", "No fruit equipped!", 3)
        return false
    end
    local fruitData = A.Awaken.FruitData[fruit]
    if not fruitData then
        A.Notify("Awakening", "This fruit cannot be awakened!", 3)
        return false
    end
    if level >= fruitData.MaxLevel then
        A.Notify("Awakening", fruit .. " is already max awakened!", 3)
        return false
    end
    if not HasAwakeningChip(fruit) then
        local bought = A.Awaken.BuyAwakeningChip(fruit)
        if not bought then return false end
    end
    if not HasAllMaterials(fruit) then
        A.Notify("Awakening", "Missing materials! Farming...", 3)
        A.Awaken.FarmAwakeningMaterials(fruit)
    end
    A.Awaken.CurrentFruit = fruit
    A.Awaken.Level = level
    return true
end

function A.Awaken.CompleteAwakening()
    if not A.Awaken.Active then return false end
    local fruit = A.Awaken.CurrentFruit
    if not fruit then return false end
    local raidPos = GetRaidPosition(A.Awaken.FruitData[fruit].Raid)
    A.TpTo(raidPos, 10)
    task.wait(2)
    local success, result = pcall(function()
        return A.CommF("startAwakeningRaid", fruit)
    end)
    if success and result then
        A.Notify("Awakening", "Starting " .. A.Awaken.FruitData[fruit].Raid .. "...", 5)
        local raidStarted = WaitForRaidStart(60)
        if raidStarted then
            A.Awaken.Stats.RaidsCompleted = A.Awaken.Stats.RaidsCompleted + 1
            FarmRaidEnemies(A.Awaken.FruitData[fruit].Raid)
            local raidComplete = WaitForRaidComplete(300)
            if raidComplete then
                A.Awaken.Stats.FruitsAwakened = A.Awaken.Stats.FruitsAwakened + 1
                A.Notify("Awakening", fruit .. " awakened successfully!", 5)
                return true
            else
                A.Notify("Awakening", "Raid failed or timed out!", 3)
                return false
            end
        else
            A.Notify("Awakening", "Failed to start raid!", 3)
            return false
        end
    end
    A.Notify("Awakening", "Failed to start awakening raid", 3)
    return false
end

function A.Awaken.WaitForAwakening()
    local startTime = tick()
    while tick() - startTime < 600 do
        if not A.Awaken.Active then return false end
        local fruit, level = A.Awaken.GetFruitAwakening()
        if fruit and level > A.Awaken.Level then
            A.Awaken.Level = level
            A.Notify("Awakening", "Awakening level increased to " .. level, 3)
            return true
        end
        task.wait(2)
    end
    return false
end

function A.Awaken.GetAwakeningSkills(fruit)
    if not fruit then
        fruit = GetLocalFruit()
    end
    if not fruit then return {} end
    local skills = A.Awaken.AwakeningSkills[fruit]
    if not skills then return {} end
    local level = GetFruitAwakeningLevel(fruit)
    local unlockedSkills = {}
    for i = 1, level do
        if skills[i] then
            table.insert(unlockedSkills, skills[i])
        end
    end
    return unlockedSkills
end

function A.Awaken.UnlockAwakeningSkill(fruit, skill)
    if not fruit or not skill then return false end
    local success, result = pcall(function()
        return A.CommF("unlockAwakeningSkill", fruit, skill)
    end)
    if success and result then
        A.Notify("Awakening", "Unlocked " .. skill .. " for " .. fruit, 3)
        return true
    end
    return false
end

function A.Awaken.GetAwakeningMaterials(fruit)
    if not fruit then
        fruit = GetLocalFruit()
    end
    return GetAwakeningMaterials(fruit)
end

function A.Awaken.FarmAwakeningMaterials(fruit)
    if not fruit then
        fruit = GetLocalFruit()
    end
    if not fruit then return end
    local fruitData = A.Awaken.FruitData[fruit]
    if not fruitData then return end
    for _, materialName in ipairs(fruitData.Materials) do
        if not A.Awaken.Active then break end
        local currentCount = 0
        local success, count = pcall(function()
            return A.CommF("getItemCount", materialName)
        end)
        if success and count then
            currentCount = count
        end
        local needed = 5 - currentCount
        if needed > 0 then
            A.Notify("Awakening", "Farming " .. materialName .. " (need " .. needed .. " more)", 3)
            for i = 1, needed do
                if not A.Awaken.Active then break end
                local target = A.FindTarget(500)
                if target then
                    A.SuperAttack(target)
                    task.wait(0.5)
                else
                    local matTarget = workspace:FindFirstChild(materialName, true)
                    if matTarget then
                        local hrp = matTarget:FindFirstChild("HumanoidRootPart") or matTarget:FindFirstChild("Handle")
                        if hrp then
                            A.TpTo(hrp.Position, 5)
                            task.wait(1)
                        end
                    else
                        task.wait(2)
                    end
                end
            end
            A.Awaken.Stats.MaterialsFarmed = A.Awaken.Stats.MaterialsFarmed + needed
        end
    end
end

function A.Awaken.GetRaidForAwakening(fruit)
    if not fruit then
        fruit = GetLocalFruit()
    end
    if not fruit then return nil end
    local fruitData = A.Awaken.FruitData[fruit]
    if not fruitData then return nil end
    return fruitData.Raid
end

function A.Awaken.StartAwakeningRaid()
    if not A.Awaken.Active then return false end
    local fruit = GetLocalFruit()
    if not fruit then return false end
    return A.Awaken.CompleteAwakening()
end

function A.Awaken.IsFruitAwakenable(fruit)
    if not fruit then return false end
    return A.Awaken.FruitData[fruit] ~= nil
end

function A.Awaken.GetMaxAwakeningLevel(fruit)
    if not fruit then return 0 end
    local fruitData = A.Awaken.FruitData[fruit]
    if not fruitData then return 0 end
    return fruitData.MaxLevel
end

function A.Awaken.GetAwakeningStats(fruit)
    if not fruit then
        fruit = GetLocalFruit()
    end
    if not fruit then return nil end
    local fruitData = A.Awaken.FruitData[fruit]
    if not fruitData then return nil end
    local level = GetFruitAwakeningLevel(fruit)
    local levelData = A.Awaken.AwakeningLevels[level] or A.Awaken.AwakeningLevels[0]
    return {
        Fruit = fruit,
        CurrentLevel = level,
        MaxLevel = fruitData.MaxLevel,
        LevelName = levelData.Name,
        DamageMultiplier = levelData.Multiplier,
        SkillsUnlocked = levelData.SkillsUnlocked,
        Materials = GetAwakeningMaterials(fruit),
        Fragments = GetFragmentCount(),
        HasChip = HasAwakeningChip(fruit)
    }
end

function A.Awaken.CompareAwakened(fruit)
    if not fruit then return nil end
    local fruitData = A.Awaken.FruitData[fruit]
    if not fruitData then return nil end
    local level = GetFruitAwakeningLevel(fruit)
    local baseDamage = 100
    local awakenedDamage = baseDamage * (A.Awaken.AwakeningLevels[level].Multiplier or 1)
    local maxDamage = baseDamage * (A.Awaken.AwakeningLevels[fruitData.MaxLevel].Multiplier or 1)
    return {
        BaseDamage = baseDamage,
        CurrentDamage = awakenedDamage,
        MaxDamage = maxDamage,
        DamageIncrease = awakenedDamage - baseDamage,
        MaxDamageIncrease = maxDamage - baseDamage,
        PercentComplete = (level / fruitData.MaxLevel) * 100
    }
end

function A.Awaken.AutoAwakenAll()
    if not A.Awaken.Active then return end
    local fruits = A.Awaken.GetUnawakenedFruits()
    for _, fruit in ipairs(fruits) do
        if not A.Awaken.Active then break end
        A.Notify("Awakening", "Auto-awakening: " .. fruit, 5)
        A.Awaken.CurrentFruit = fruit
        local fruitData = A.Awaken.FruitData[fruit]
        if fruitData then
            local level = GetFruitAwakeningLevel(fruit)
            while level < fruitData.MaxLevel do
                if not A.Awaken.Active then break end
                local success = A.Awaken.CompleteAwakening()
                if success then
                    level = GetFruitAwakeningLevel(fruit)
                    A.Notify("Awakening", fruit .. " now at level " .. level, 3)
                else
                    break
                end
                task.wait(2)
            end
        end
    end
end

function A.Awaken.GetAwakeningPriority(fruit)
    if not fruit then return 0 end
    local fruitData = A.Awaken.FruitData[fruit]
    if not fruitData then return 0 end
    local level = GetFruitAwakeningLevel(fruit)
    local maxLevel = fruitData.MaxLevel
    local priority = 0
    if level == 0 then
        priority = priority + 50
    elseif level < maxLevel then
        priority = priority + 30
    end
    if fruit == A.Awaken.CurrentFruit then
        priority = priority + 20
    end
    local fragments = GetFragmentCount()
    if fragments >= fruitData.ChipCost then
        priority = priority + 15
    end
    return priority
end

function A.Awaken.FarmAllAwakenings()
    A.Awaken.AutoAwakenAll()
end

function A.Awaken.GetUnawakenedFruits()
    local unawakened = {}
    for fruitName, fruitData in pairs(A.Awaken.FruitData) do
        local level = GetFruitAwakeningLevel(fruitName)
        if level < fruitData.MaxLevel then
            table.insert(unawakened, fruitName)
        end
    end
    table.sort(unawakened, function(a, b)
        return A.Awaken.GetAwakeningPriority(a) > A.Awaken.GetAwakeningPriority(b)
    end)
    return unawakened
end

function A.Awaken.AwakeningProgress()
    local fruit, level, progress = A.Awaken.GetFruitAwakening()
    if not fruit then
        return { Fruit = "None", Level = 0, Progress = 0, MaxLevel = 0 }
    end
    local fruitData = A.Awaken.FruitData[fruit]
    local maxLevel = fruitData and fruitData.MaxLevel or 5
    return {
        Fruit = fruit,
        Level = level,
        Progress = progress,
        MaxLevel = maxLevel,
        PercentComplete = (level / maxLevel) * 100
    }
end

function A.Awaken.PrintAwakeningStatus()
    local progress = A.Awaken.AwakeningProgress()
    local stats = A.Awaken.Stats
    local lines = {
        "=== Awakening Status ===",
        "Fruit: " .. progress.Fruit,
        "Level: " .. progress.Level .. "/" .. progress.MaxLevel,
        "Progress: " .. string.format("%.1f", progress.PercentComplete) .. "%",
        "",
        "=== Session Stats ===",
        "Fruits Awakened: " .. stats.FruitsAwakened,
        "Chips Used: " .. stats.ChipsUsed,
        "Raids Completed: " .. stats.RaidsCompleted,
        "Materials Farmed: " .. stats.MaterialsFarmed,
        "Session Time: " .. string.format("%.0f", tick() - stats.SessionStart) .. "s"
    }
    for _, line in ipairs(lines) do
        A.Notify("Awakening Status", line, 3)
    end
end

function A.Awaken.GetAwakeningCost(fruit)
    if not fruit then return 0 end
    local fruitData = A.Awaken.FruitData[fruit]
    if not fruitData then return 0 end
    local level = GetFruitAwakeningLevel(fruit)
    local remaining = fruitData.MaxLevel - level
    local totalCost = fruitData.ChipCost * remaining
    local totalFragments = fruitData.FragmentsPerLevel * remaining
    return {
        ChipsNeeded = remaining,
        ChipCost = totalCost,
        FragmentsNeeded = totalFragments,
        MaterialsNeeded = fruitData.Materials
    }
end

function A.Awaken.CalculateAwakeningValue(fruit)
    if not fruit then return 0 end
    local comparison = A.Awaken.CompareAwakened(fruit)
    if not comparison then return 0 end
    local value = comparison.DamageIncrease * 10
    local level = GetFruitAwakeningLevel(fruit)
    if level > 0 then
        value = value + level * 500
    end
    return value
end

function A.Awaken.MainLoop()
    while A.Awaken.Active do
        pcall(function()
            local fruit, level, progress = A.Awaken.GetFruitAwakening()
            if fruit then
                A.Awaken.CurrentFruit = fruit
                A.Awaken.Level = level
                A.Awaken.Progress = progress
                local fruitData = A.Awaken.FruitData[fruit]
                if fruitData and level < fruitData.MaxLevel then
                    if not HasAllMaterials(fruit) then
                        A.Awaken.FarmAwakeningMaterials(fruit)
                    end
                    if HasAwakeningChip(fruit) and HasAllMaterials(fruit) then
                        A.Awaken.CompleteAwakening()
                    end
                end
            end
        end)
        task.wait(5)
    end
end

function A.Awaken.Start()
    if A.Awaken.Active then return end
    A.Awaken.Active = true
    A.Awaken.Stats = {
        FruitsAwakened = 0,
        ChipsUsed = 0,
        RaidsCompleted = 0,
        MaterialsFarmed = 0,
        SessionStart = tick()
    }
    A.Notify("Awakening", "Awakening system started!", 3)
    task.spawn(function()
        A.Awaken.MainLoop()
    end)
end

function A.Awaken.Stop()
    A.Awaken.Active = false
    A.Notify("Awakening", "Awakening system stopped!", 3)
end

function A.Awaken.ShowProgress()
    A.Awaken.AwakeningProgress()
end

A.Register("awakening", A.Awaken)
