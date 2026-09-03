--[[
    Apex Hub v13.0 - Fruit Management Module
    Devil fruit sniping, management, trading, and awakening
]]

-- FIX: throttle GetDescendants (was heavy)
local function _SafeDescendants(root, limit) limit=limit or 300; local res={}; local c=0; for _,v in ipairs(root:GetDescendants()) do c=c+1; if c>limit then break end; table.insert(res,v) end; return res end
local A = _G.Apex
if not A then return end

A.FruitManager = {}
A.FruitManager.Active = false
A.FruitManager.OwnedFruits = {}
A.FruitManager.SnipeList = {}
A.FruitManager.CurrentFruit = nil
A.FruitManager.LastCheck = 0
A.FruitManager.CheckInterval = 5
A.FruitManager.SessionStart = tick()
A.FruitManager.FruitsCollected = 0
A.FruitManager.FruitsSniped = 0
A.FruitManager.LastWorldFruitCheck = 0
A.FruitManager.WorldFruitCheckInterval = 30
A.FruitManager.AutoEat = false
A.FruitManager.AutoAwaken = false
A.FruitManager.AwakeMode = "normal"
A.FruitManager.Sniping = false
A.FruitManager.LastDealerCheck = 0
A.FruitManager.DealerCheckInterval = 120
A.FruitManager.ChestFarming = false
A.FruitManager.LastChestTime = 0
A.FruitManager.ChestCooldown = 5
A.FruitManager.FruitLog = {}
A.FruitManager.TotalValue = 0

A.FruitManager.FruitValues = {
    ["Dragon"] = 3500000,
    ["Leopard"] = 5500000,
    ["Kitsune"] = 4000000,
    ["Mammoth"] = 3000000,
    ["T-Rex"] = 3000000,
    ["Dough"] = 2800000,
    ["Buddha"] = 1650000,
    ["Phoenix"] = 1800000,
    ["Venom"] = 3000000,
    ["Control"] = 3500000,
    ["Spirit"] = 3200000,
    ["Blizzard"] = 3000000,
    ["Magma"] = 1100000,
    ["Ice"] = 1100000,
    ["Light"] = 1300000,
    ["Dark"] = 1300000,
    ["Rubber"] = 2000000,
    ["Quake"] = 1000000,
    ["String"] = 1200000,
    ["Human"] = 950000,
    ["Cyborg"] = 950000,
    ["Sparkle"] = 1500000,
    ["Portal"] = 1800000,
    ["Rumble"] = 1000000,
    ["Love"] = 900000,
    ["Shadow"] = 1500000,
    ["Gravity"] = 1100000,
    ["Sound"] = 1200000,
    ["Bomb"] = 120000,
    ["Spike"] = 120000,
    ["Chop"] = 120000,
    ["Spring"] = 120000,
    ["Ghost"] = 120000,
    ["Falcon"] = 120000,
    ["Smoke"] = 120000,
    ["Flame"] = 120000,
    ["Diamond"] = 120000,
    ["Barrier"] = 120000,
    ["Bird: Phoenix"] = 1800000,
}

A.FruitManager.FruitRarities = {
    ["Dragon"] = "Mythical",
    ["Leopard"] = "Mythical",
    ["Kitsune"] = "Mythical",
    ["Mammoth"] = "Legendary",
    ["T-Rex"] = "Legendary",
    ["Dough"] = "Legendary",
    ["Buddha"] = "Legendary",
    ["Phoenix"] = "Legendary",
    ["Venom"] = "Legendary",
    ["Control"] = "Legendary",
    ["Spirit"] = "Legendary",
    ["Blizzard"] = "Legendary",
    ["Magma"] = "Rare",
    ["Ice"] = "Rare",
    ["Light"] = "Rare",
    ["Dark"] = "Rare",
    ["Rubber"] = "Rare",
    ["Quake"] = "Rare",
    ["String"] = "Rare",
    ["Human"] = "Rare",
    ["Cyborg"] = "Rare",
    ["Sparkle"] = "Legendary",
    ["Portal"] = "Legendary",
    ["Rumble"] = "Rare",
    ["Love"] = "Rare",
    ["Shadow"] = "Rare",
    ["Gravity"] = "Rare",
    ["Sound"] = "Rare",
    ["Bomb"] = "Uncommon",
    ["Spike"] = "Uncommon",
    ["Chop"] = "Uncommon",
    ["Spring"] = "Uncommon",
    ["Ghost"] = "Uncommon",
    ["Falcon"] = "Uncommon",
    ["Smoke"] = "Uncommon",
    ["Flame"] = "Uncommon",
    ["Diamond"] = "Uncommon",
    ["Barrier"] = "Uncommon",
    ["Bird: Phoenix"] = "Legendary",
}

function A.FruitManager.MainLoop()
    while A.FruitManager.Active do
        if A.Alive() then
            if A.FruitManager.Sniping then
                A.FruitManager.CheckFruitSpawn()
                A.FruitManager.SnipeFruit()
            end
            if A.FruitManager.ChestFarming then
                A.FruitManager.FruitChest()
            end
            A.FruitManager.CheckFruitWorld()
            A.FruitManager.CheckDealerStock()
            if A.FruitManager.AutoEat then
                A.FruitManager.AutoEatFruit()
            end
            if A.FruitManager.AutoAwaken then
                A.FruitManager.AwakenFruit()
            end
        end
        task.wait(A.FruitManager.CheckInterval)
    end
end

function A.FruitManager.GetFruit()
    local char = A.Char()
    if not char then return nil end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local fruitType = tool:GetAttribute("Fruit") or tool:GetAttribute("IsFruit")
        if fruitType then
            return tool
        end
        local isBlox = string.find(string.lower(tool.Name), "fruit") or string.find(string.lower(tool.Name), "blox")
        if isBlox then
            return tool
        end
    end
    local player = A.LP
    if player then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") then
                    local isFruit = item:GetAttribute("Fruit") or item:GetAttribute("IsFruit")
                    if isFruit then
                        return item
                    end
                end
            end
        end
    end
    return nil
end

function A.FruitManager.HasFruit()
    local fruit = A.FruitManager.GetFruit()
    return fruit ~= nil
end

function A.FruitManager.GetFruitMastery()
    local fruit = A.FruitManager.GetFruit()
    if not fruit then return 0 end
    local mastery = fruit:FindFirstChild("Mastery") or fruit:FindFirstChild("Level")
    if mastery and mastery:IsA("ValueBase") then
        return mastery.Value
    end
    return 0
end

function A.FruitManager.DropFruit()
    local fruit = A.FruitManager.GetFruit()
    if not fruit then
        A.Notify("Fruits", "No fruit to drop", 2)
        return false
    end
    local char = A.Char()
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool == fruit then
            tool.Parent = A.LP:FindFirstChild("Backpack")
            task.wait(0.5)
        end
    end
    local backpack = A.LP:FindFirstChild("Backpack")
    if backpack then
        local tool = backpack:FindFirstChild(fruit.Name)
        if tool then
            tool.Parent = workspace
            tool.Handle.Anchored = false
            A.Notify("Fruits", "Dropped: " .. fruit.Name, 3)
            return true
        end
    end
    return false
end

function A.FruitManager.StoreFruit()
    local fruit = A.FruitManager.GetFruit()
    if not fruit then
        A.Notify("Fruits", "No fruit to store", 2)
        return false
    end
    local success = pcall(function()
        A.CommF("StoreFruit", fruit.Name)
    end)
    if success then
        A.Notify("Fruits", "Stored: " .. fruit.Name, 3)
        table.insert(A.FruitManager.FruitLog, {
            action = "Store",
            fruit = fruit.Name,
            time = os.date("%Y-%m-%d %H:%M:%S"),
        })
    end
    return success
end

function A.FruitManager.EquipFruit(name)
    if not name then return false end
    local backpack = A.LP:FindFirstChild("Backpack")
    if not backpack then return false end
    local tool = backpack:FindFirstChild(name)
    if not tool then
        A.Notify("Fruits", "Fruit not found in backpack: " .. name, 2)
        return false
    end
    tool.Parent = A.LP.Character or A.LP
    A.Notify("Fruits", "Equipped: " .. name, 3)
    return true
end

function A.FruitManager.FindFruitWorld()
    for _, obj in ipairs(_SafeDescendants(workspace,300)) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
            local isFruit = obj:GetAttribute("Fruit") or obj:GetAttribute("IsFruit")
            if isFruit then
                return obj
            end
            for fruitName, _ in pairs(A.FruitManager.FruitValues) do
                if obj.Name == fruitName then
                    return obj
                end
            end
        end
    end
    return nil
end

function A.FruitManager.SnipeFruit()
    if not A.FruitManager.Sniping then return false end
    local fruit = A.FruitManager.FindFruitWorld()
    if not fruit then return false end
    local handle = fruit:FindFirstChild("Handle")
    if not handle then return false end
    local isWorth = A.FruitManager.IsFruitWorthKeeping(fruit.Name)
    if not isWorth then
        A.Notify("Fruits", "Skipping low value fruit: " .. fruit.Name, 2)
        return false
    end
    local _hrpFruit = A.HRP()
    local dist = _hrpFruit and (handle.Position - _hrpFruit.Position).Magnitude or math.huge
    if dist > 500 then
        -- FIX: nil-check HRP before CFrame assign
        local _hrp2 = A.HRP()
        if _hrp2 then _hrp2.CFrame = A.CF(handle.Position + A.V3(0, 30, 0)) end
        task.wait(0.5)
    else
        A.TpTo(handle.Position, 30)
    end
    task.wait(0.5)
    local char = A.Char()
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(handle.Position)
            task.wait(0.3)
        end
    end
    local success = pcall(function()
        firetouchinterest(A.LP.Character.HumanoidRootPart, handle, 0)
        task.wait(0.1)
        firetouchinterest(A.LP.Character.HumanoidRootPart, handle, 1)
    end)
    if success then
        A.FruitManager.FruitsSniped = A.FruitManager.FruitsSniped + 1
        A.Notify("Fruit Snipe", "Collected: " .. fruit.Name, 5)
        table.insert(A.FruitManager.FruitLog, {
            action = "Snipe",
            fruit = fruit.Name,
            time = os.date("%Y-%m-%d %H:%M:%S"),
        })
        return true
    end
    return false
end

function A.FruitManager.CheckFruitSpawn()
    if tick() - A.FruitManager.LastWorldFruitCheck < A.FruitManager.WorldFruitCheckInterval then
        return
    end
    A.FruitManager.LastWorldFruitCheck = tick()
    local fruit = A.FruitManager.FindFruitWorld()
    if fruit then
        A.Notify("Fruit Spawn", "Fruit found in world: " .. fruit.Name, 5)
    end
end

function A.FruitManager.GetFruitValue(name)
    if not name then return 0 end
    return A.FruitManager.FruitValues[name] or 0
end

function A.FruitManager.IsFruitWorthKeeping(name)
    if not name then return false end
    local value = A.FruitManager.GetFruitValue(name)
    if value >= 500000 then
        return true
    end
    for _, snipeName in ipairs(A.FruitManager.SnipeList) do
        if snipeName == name then
            return true
        end
    end
    return false
end

function A.FruitManager.FruitChest()
    if tick() - A.FruitManager.LastChestTime < A.FruitManager.ChestCooldown then
        return
    end
    A.FruitManager.LastChestTime = tick()
    -- FIX: nil-check HRP
    local _hrpChest = A.HRP()
    for _, obj in ipairs(_SafeDescendants(workspace,300)) do
        if obj:IsA("BasePart") and string.find(string.lower(obj.Name), "chest") then
            local dist = _hrpChest and (obj.Position - _hrpChest.Position).Magnitude or math.huge
            if dist < 500 then
                A.TpTo(obj.Position, 20)
                task.wait(0.5)
                pcall(function()
                    fireclickdetector(obj:FindFirstChildOfClass("ClickDetector") or obj)
                end)
            end
        end
    end
end

function A.FruitManager.BuyFruit(name)
    if not name then return false end
    local knownCost = A.FruitManager.FruitValues and A.FruitManager.FruitValues[name]
    if knownCost and A.Money then
        local money = pcall(A.Money)
        if money and type(money) == "number" and money < knownCost then
            A.Notify("Fruits", "Not enough money to buy " .. name .. " (need " .. knownCost .. ")", 4)
            return false
        end
    end
    local success = pcall(function()
        A.CommF("BuyFruit", name)
    end)
    if success then
        A.Notify("Fruits", "Bought: " .. name, 3)
        table.insert(A.FruitManager.FruitLog, {
            action = "Buy",
            fruit = name,
            time = os.date("%Y-%m-%d %H:%M:%S"),
        })
    end
    return success
end

function A.FruitManager.GetDealerStock()
    local stock = {}
    local success = pcall(function()
        local dealerStock = A.CommF("GetDealerStock")
        if dealerStock then
            stock = dealerStock
        end
    end)
    return stock
end

function A.FruitManager.AwaitDealer(timeout)
    timeout = timeout or 600
    local start = tick()
    A.Notify("Fruits", "Waiting for fruit dealer...", 3)
    while tick() - start < timeout do
        if not A.FruitManager.Active then return false end
        local stock = A.FruitManager.GetDealerStock()
        if #stock > 0 then
            return true
        end
        task.wait(10)
    end
    return false
end

function A.FruitManager.GetFruitRarity(name)
    if not name then return "Unknown" end
    return A.FruitManager.FruitRarities[name] or "Unknown"
end

function A.FruitManager.CompareFruits(f1, f2)
    if not f1 or not f2 then return nil end
    local v1 = A.FruitManager.GetFruitValue(f1)
    local v2 = A.FruitManager.GetFruitValue(f2)
    return {
        fruit1 = f1,
        fruit2 = f2,
        value1 = v1,
        value2 = v2,
        better = v1 >= v2 and f1 or f2,
        diff = math.abs(v1 - v2),
    }
end

function A.FruitManager.GetBestFruit()
    local best = nil
    local bestValue = -1
    local player = A.LP
    if not player then return nil end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local isFruit = item:GetAttribute("Fruit") or item:GetAttribute("IsFruit")
                if isFruit then
                    local value = A.FruitManager.GetFruitValue(item.Name)
                    if value > bestValue then
                        bestValue = value
                        best = item.Name
                    end
                end
            end
        end
    end
    return best
end

function A.FruitManager.GetFruitList()
    local fruits = {}
    local player = A.LP
    if not player then return fruits end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local isFruit = item:GetAttribute("Fruit") or item:GetAttribute("IsFruit")
                if isFruit then
                    table.insert(fruits, {
                        name = item.Name,
                        value = A.FruitManager.GetFruitValue(item.Name),
                        rarity = A.FruitManager.GetFruitRarity(item.Name),
                    })
                end
            end
        end
    end
    return fruits
end

function A.FruitManager.SellFruit(name)
    if not name then return false end
    local success = pcall(function()
        A.CommF("SellFruit", name)
    end)
    if success then
        A.Notify("Fruits", "Sold: " .. name, 3)
        table.insert(A.FruitManager.FruitLog, {
            action = "Sell",
            fruit = name,
            time = os.date("%Y-%m-%d %H:%M:%S"),
        })
    end
    return success
end

function A.FruitManager.TradeFruit(f1, f2)
    if not f1 or not f2 then return false end
    local success = pcall(function()
        A.CommF("TradeFruit", f1, f2)
    end)
    if success then
        A.Notify("Fruits", "Traded: " .. f1 .. " for " .. f2, 3)
        table.insert(A.FruitManager.FruitLog, {
            action = "Trade",
            fruit = f1 .. " -> " .. f2,
            time = os.date("%Y-%m-%d %H:%M:%S"),
        })
    end
    return success
end

function A.FruitManager.FruitStats()
    local fruits = A.FruitManager.GetFruitList()
    local totalValue = 0
    local rarityCount = {}
    for _, fruit in ipairs(fruits) do
        totalValue = totalValue + fruit.value
        if not rarityCount[fruit.rarity] then
            rarityCount[fruit.rarity] = 0
        end
        rarityCount[fruit.rarity] = rarityCount[fruit.rarity] + 1
    end
    return {
        totalFruits = #fruits,
        totalValue = totalValue,
        bestFruit = A.FruitManager.GetBestFruit(),
        rarityBreakdown = rarityCount,
        fruitsSniped = A.FruitManager.FruitsSniped,
        fruitsCollected = A.FruitManager.FruitsCollected,
        log = A.FruitManager.FruitLog,
    }
end

function A.FruitManager.AutoEatFruit()
    if not A.Alive() then return end
    local char = A.Char()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local hpPct = hum.Health / hum.MaxHealth
    if hpPct < 0.3 then
        local fruit = A.FruitManager.GetFruit()
        if fruit then
            local handle = fruit:FindFirstChild("Handle")
            if handle then
                pcall(function()
                    firetouchinterest(A.LP.Character.HumanoidRootPart, handle, 0)
                    task.wait(0.1)
                    firetouchinterest(A.LP.Character.HumanoidRootPart, handle, 1)
                end)
                A.Notify("Fruits", "Eating fruit for HP recovery", 2)
            end
        end
    end
end

function A.FruitManager.AwakenFruit()
    if not A.FruitManager.AutoAwaken then return end
    local fruit = A.FruitManager.GetFruit()
    if not fruit then return end
    local success = pcall(function()
        A.CommF("AwakenFruit", fruit.Name, A.FruitManager.AwakeMode)
    end)
    if success then
        A.Notify("Fruits", "Attempting awakening for " .. fruit.Name, 3)
    end
end

function A.FruitManager.GetAwakeningProgress()
    local fruit = A.FruitManager.GetFruit()
    if not fruit then return nil end
    local progress = {
        name = fruit.Name,
        mastery = A.FruitManager.GetFruitMastery(),
        maxMastery = 600,
        progress = 0,
    }
    progress.progress = math.floor(progress.mastery / progress.maxMastery * 100)
    return progress
end

function A.FruitManager.CheckFruitWorld()
    if tick() - A.FruitManager.LastCheck < A.FruitManager.CheckInterval then
        return
    end
    A.FruitManager.LastCheck = tick()
    local fruit = A.FruitManager.FindFruitWorld()
    if fruit then
        if A.FruitManager.IsFruitWorthKeeping(fruit.Name) then
            A.Notify("Fruit Alert", "Valuable fruit in world: " .. fruit.Name, 5)
        end
    end
end

function A.FruitManager.CheckDealerStock()
    if tick() - A.FruitManager.LastDealerCheck < A.FruitManager.DealerCheckInterval then
        return
    end
    A.FruitManager.LastDealerCheck = tick()
    local stock = A.FruitManager.GetDealerStock()
    if #stock > 0 then
        A.Notify("Dealer", "Fruits available in dealer stock!", 4)
    end
end

function A.FruitManager.Start()
    if A.FruitManager.Active then
        A.Notify("Fruits", "Already running!", 2)
        return
    end
    A.FruitManager.Active = true
    A.FruitManager.SessionStart = tick()
    A.FruitManager.FruitsCollected = 0
    A.FruitManager.FruitsSniped = 0
    A.Notify("Fruits", "Fruit manager started!", 3)
    task.spawn(A.FruitManager.MainLoop)
end

function A.FruitManager.Stop()
    A.FruitManager.Active = false
    A.FruitManager.Sniping = false
    A.FruitManager.AutoAwaken = false
    A.Notify("Fruits", "Fruit manager stopped. Sniped: " .. A.FruitManager.FruitsSniped, 3)
end

local _origSnipeFruit = A.FruitManager.SnipeFruit

function A.FruitManager.OpenAll()
end

function A.FruitManager.SnipeFruit(v)
    _origSnipeFruit()
end

A.Register("fruits", A.FruitManager)
