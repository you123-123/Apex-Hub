local A = _G.Apex
local Fishing = {}
Fishing.Active = false
Fishing.FishCaught = 0
Fishing.FishingLevel = 1
Fishing.CastCount = 0
Fishing._loop = nil
Fishing._startTick = 0
Fishing._isCasting = false
Fishing._hasBite = false
Fishing._currentFish = nil
Fishing._fishLog = {}
Fishing._comboCount = 0
Fishing._comboTimer = 0
Fishing._comboMaxTime = 5
Fishing._bestFish = nil
Fishing._totalValue = 0
Fishing._rodEquipped = false
Fishing._baitCount = 0
Fishing._castPosition = nil
Fishing._waitStart = 0
Fishing._maxWaitTime = 30
Fishing._autoEquip = true
Fishing._rareFishCaught = {}
Fishing._catchRate = 0
Fishing._avgCatchTime = 0
Fishing._totalCatchTime = 0

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local FISH_RARITIES = {
    Common = {MinValue = 10, MaxValue = 100, Chance = 0.5},
    Uncommon = {MinValue = 100, MaxValue = 500, Chance = 0.3},
    Rare = {MinValue = 500, MaxValue = 2000, Chance = 0.15},
    Epic = {MinValue = 2000, MaxValue = 10000, Chance = 0.04},
    Legendary = {MinValue = 10000, MaxValue = 100000, Chance = 0.008},
    Mythical = {MinValue = 100000, MaxValue = 1000000, Chance = 0.002}
}

local FISHING_RODS = {
    {Name = "Flimsy Rod", Level = 1, Speed = 1.0, Rarity = "Common"},
    {Name = "Bait Rod", Level = 5, Speed = 1.2, Rarity = "Common"},
    {Name = "Carrot Rod", Level = 10, Speed = 1.5, Rarity = "Uncommon"},
    {Name = "Steel Rod", Level = 20, Speed = 1.8, Rarity = "Uncommon"},
    {Name = "Golden Rod", Level = 35, Speed = 2.0, Rarity = "Rare"},
    {Name = "Shark Rod", Level = 50, Speed = 2.5, Rarity = "Epic"},
    {Name = "Kitsune Rod", Level = 75, Speed = 3.0, Rarity = "Legendary"},
    {Name = "Leviathan Rod", Level = 100, Speed = 4.0, Rarity = "Mythical"}
}

local BAIT_TYPES = {
    {Name = "Worm", Attraction = 1.0, Cost = 100},
    {Name = "Shrimp", Attraction = 1.5, Cost = 500},
    {Name = "Squid", Attraction = 2.0, Cost = 1000},
    {Name = "Krill", Attraction = 2.5, Cost = 2500},
    {Name = "Rare Bait", Attraction = 3.0, Cost = 5000},
    {Name = "Legendary Bait", Attraction = 5.0, Cost = 25000}
}

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Apex Fishing] Error: " .. tostring(err))
    end
    return ok, err
end

function Fishing.GetFishingRod()
    local lp = A.LP
    if not lp then return nil end
    local bestRod = nil
    local bestLevel = 0
    local backpack = lp:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                for _, rod in ipairs(FISHING_RODS) do
                    if string.find(string.lower(item.Name), string.lower(rod.Name)) or
                        string.find(string.lower(item.Name), "rod") then
                        if rod.Level > bestLevel then
                            bestRod = item
                            bestLevel = rod.Level
                        end
                    end
                end
            end
        end
    end
    if lp.Character then
        for _, item in ipairs(lp.Character:GetChildren()) do
            if item:IsA("Tool") then
                for _, rod in ipairs(FISHING_RODS) do
                    if string.find(string.lower(item.Name), string.lower(rod.Name)) or
                        string.find(string.lower(item.Name), "rod") then
                        if rod.Level > bestLevel then
                            bestRod = item
                            bestLevel = rod.Level
                        end
                    end
                end
            end
        end
    end
    return bestRod
end

function Fishing.EquipFishingRod()
    local rod = Fishing.GetFishingRod()
    if not rod then
        A.Notify("Fishing", "No fishing rod found!", 3)
        return false
    end
    local lp = A.LP
    if not lp then return false end
    local char = lp.Character
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return false end
    if rod.Parent == char then
        Fishing._rodEquipped = true
        return true
    end
    pcall(function()
        hum:EquipTool(rod)
    end)
    task.wait(0.5)
    Fishing._rodEquipped = true
    return true
end

function Fishing.GetBait()
    local lp = A.LP
    if not lp then return nil end
    local backpack = lp:FindFirstChild("Backpack")
    if backpack then
        for _, bait in ipairs(BAIT_TYPES) do
            local baitItem = backpack:FindFirstChild(bait.Name)
            if baitItem then
                return baitItem, bait
            end
        end
    end
    return nil, nil
end

function Fishing.GetBestBait()
    local lp = A.LP
    if not lp then return nil end
    local bestBait = nil
    local bestAttraction = 0
    local backpack = lp:FindFirstChild("Backpack")
    if backpack then
        for _, baitInfo in ipairs(BAIT_TYPES) do
            local baitItem = backpack:FindFirstChild(baitInfo.Name)
            if baitItem then
                if baitInfo.Attraction > bestAttraction then
                    bestBait = baitItem
                    bestAttraction = baitInfo.Attraction
                end
            end
        end
    end
    return bestBait, bestAttraction
end

function Fishing.BuyBait(baitName, amount)
    amount = amount or 10
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            for i = 1, amount do
                commF("BuyBait", baitName)
                task.wait(0.2)
            end
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local buyBait = remotes:FindFirstChild("BuyBait")
            if buyBait then
                for i = 1, amount do
                    buyBait:FireServer(baitName)
                    task.wait(0.2)
                end
            end
        end
        A.Notify("Fishing", "Bought " .. tostring(amount) .. "x " .. baitName, 2)
    end)
    return ok
end

function Fishing.CastRod()
    if Fishing._isCasting then return false end
    local lp = A.LP
    if not lp then return false end
    local char = lp.Character
    if not char then return false end
    local tool = char:FindFirstChildWhichIsA("Tool")
    if not tool then
        Fishing.EquipFishingRod()
        task.wait(1)
        tool = char:FindFirstChildWhichIsA("Tool")
        if not tool then return false end
    end
    local isRod = false
    for _, rod in ipairs(FISHING_RODS) do
        if string.find(string.lower(tool.Name), string.lower(rod.Name)) or
            string.find(string.lower(tool.Name), "rod") then
            isRod = true
            break
        end
    end
    if not isRod then return false end
    local hrp = A.HRP()
    if not hrp then return false end
    local castDir = hrp.CFrame.LookVector
    Fishing._castPosition = hrp.Position + castDir * 50
    local ok, err = SafeCall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local castRemote = remotes:FindFirstChild("CastRod") or remotes:FindFirstChild("FishCast")
            if castRemote then
                castRemote:FireServer(Fishing._castPosition)
            end
        end
        tool:Activate()
        Fishing._isCasting = true
        Fishing.CastCount = Fishing.CastCount + 1
        Fishing._waitStart = tick()
    end)
    return ok
end

function Fishing.WaitForBite()
    if not Fishing._isCasting then return false end
    local elapsed = tick() - Fishing._waitStart
    if elapsed > Fishing._maxWaitTime then
        Fishing._isCasting = false
        return false
    end
    local lp = A.LP
    if not lp then return false end
    local char = lp.Character
    if not char then return false end
    local screenGui = lp.PlayerGui:FindFirstChild("FishingGUI") or lp.PlayerGui:FindFirstChild("Fish")
    if screenGui then
        local biteIndicator = screenGui:FindFirstChild("Bite") or screenGui:FindFirstChild("Catch")
        if biteIndicator and biteIndicator.Visible then
            Fishing._hasBite = true
            return true
        end
    end
    for _, gui in ipairs(lp.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, frame in ipairs(gui:GetDescendants()) do
                if frame:IsA("Frame") or frame:IsA("TextLabel") then
                    if string.find(string.lower(frame.Name), "bite") or
                        string.find(string.lower(frame.Name), "catch") or
                        string.find(string.lower(frame.Name), "fish") then
                        if frame.Visible then
                            Fishing._hasBite = true
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

function Fishing.CatchFish()
    if not Fishing._hasBite then return false end
    local lp = A.LP
    if not lp then return false end
    local ok, err = SafeCall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local catchRemote = remotes:FindFirstChild("CatchFish") or remotes:FindFirstChild("FishCatch")
            if catchRemote then
                catchRemote:FireServer()
            end
        end
        local char = lp.Character
        if char then
            local tool = char:FindFirstChildWhichIsA("Tool")
            if tool then
                tool:Activate()
            end
        end
    end)
    local catchTime = tick() - Fishing._waitStart
    Fishing._totalCatchTime = Fishing._totalCatchTime + catchTime
    Fishing.FishCaught = Fishing.FishCaught + 1
    Fishing._isCasting = false
    Fishing._hasBite = false
    Fishing._comboCount = Fishing._comboCount + 1
    Fishing._comboTimer = tick()
    local rarity = Fishing.GetFishRarity()
    local value = Fishing.GetFishValue(rarity)
    Fishing._totalValue = Fishing._totalValue + value
    local fishData = {
        Rarity = rarity,
        Value = value,
        CatchTime = catchTime,
        Time = tick()
    }
    table.insert(Fishing._fishLog, fishData)
    if rarity == "Legendary" or rarity == "Mythical" then
        table.insert(Fishing._rareFishCaught, fishData)
        A.Notify("Rare Fish!", "Caught a " .. rarity .. " fish worth " .. tostring(value) .. "!", 5)
    end
    if not Fishing._bestFish or value > Fishing._bestFish.Value then
        Fishing._bestFish = fishData
    end
    if Fishing.AutoSellFish and not Fishing.ShouldKeepRarity(rarity) then
        task.spawn(function()
            Fishing.SellFish(rarity)
        end)
    end
    Fishing._catchRate = Fishing.FishCaught / math.max((tick() - Fishing._startTick) / 60, 1)
    Fishing._avgCatchTime = Fishing._totalCatchTime / math.max(Fishing.FishCaught, 1)
    return true
end

function Fishing.GetFishRarity()
    local roll = math.random()
    local cumulative = 0
    for rarity, data in pairs(FISH_RARITIES) do
        cumulative = cumulative + data.Chance
        if roll <= cumulative then
            return rarity
        end
    end
    return "Common"
end

function Fishing.GetFishValue(rarity)
    rarity = rarity or Fishing.GetFishRarity()
    local data = FISH_RARITIES[rarity]
    if not data then return 10 end
    local baseValue = math.random(data.MinValue, data.MaxValue)
    local multiplier = 1 + (Fishing.FishingLevel * 0.1)
    return math.floor(baseValue * multiplier)
end

function Fishing.FishCombo()
    if tick() - Fishing._comboTimer > Fishing._comboMaxTime then
        Fishing._comboCount = 0
    end
    return Fishing._comboCount
end

function Fishing.AutoFish()
    if not Fishing._isCasting then
        local bait, baitData = Fishing.GetBestBait()
        if not bait and Fishing._baitCount > 0 then
            Fishing.BuyBait("Worm", 10)
            task.wait(1)
        end
        Fishing.CastRod()
        task.wait(1)
        return
    end
    if Fishing._hasBite then
        Fishing.CatchFish()
        task.wait(0.5)
        return
    end
    Fishing.WaitForBite()
end

function Fishing.GetFishingStats()
    local sessionTime = tick() - Fishing._startTick
    local minutes = math.floor(sessionTime / 60)
    local seconds = math.floor(sessionTime % 60)
    return {
        FishCaught = Fishing.FishCaught,
        FishingLevel = Fishing.FishingLevel,
        CastCount = Fishing.CastCount,
        TotalValue = Fishing._totalValue,
        CatchRate = string.format("%.1f/min", Fishing._catchRate),
        AvgCatchTime = string.format("%.1fs", Fishing._avgCatchTime),
        ComboCount = Fishing._comboCount,
        BestFish = Fishing._bestFish and Fishing._bestFish.Rarity or "None",
        BestFishValue = Fishing._bestFish and Fishing._bestFish.Value or 0,
        RareFish = #Fishing._rareFishCaught,
        SessionTime = string.format("%dm %ds", minutes, seconds),
        IsCasting = Fishing._isCasting,
        HasBite = Fishing._hasBite,
        RodEquipped = Fishing._rodEquipped
    }
end

function Fishing.MainLoop()
    while Fishing.Active do
        if not A.Alive() then
            task.wait(2)
            break
        end
        SafeCall(function()
            Fishing.AutoFish()
        end)
        task.wait(0.3)
    end
end

function Fishing.Start()
    if Fishing.Active then return end
    Fishing.Active = true
    Fishing._startTick = tick()
    Fishing._comboCount = 0
    Fishing._comboTimer = 0
    Fishing.EquipFishingRod()
    A.Notify("Fishing", "Started auto fishing", 3)
    Fishing._loop = task.spawn(function()
        Fishing.MainLoop()
        Fishing.Active = false
    end)
end

function Fishing.Stop()
    Fishing.Active = false
    Fishing._isCasting = false
    Fishing._hasBite = false
    if Fishing._loop then
        task.cancel(Fishing._loop)
        Fishing._loop = nil
    end
    A.Notify("Fishing", "Stopped", 2)
end

-- ==================== v13.1 EXPANSIONS ====================

Fishing.MinKeepRarity = 0
Fishing.AutoSellFish = false
Fishing.AutoEquipBestRod = false
Fishing._sellRemote = nil
Fishing._rarityOrder = {["Common"]=1, ["Uncommon"]=2, ["Rare"]=3, ["Epic"]=4, ["Legendary"]=5, ["Mythical"]=6}

local RARITY_KEEP_FILTER = {
    ["Keep All"] = 0,
    ["Uncommon+"] = 2,
    ["Rare+"] = 3,
    ["Epic+"] = 4,
    ["Legendary+"] = 5,
    ["Mythical Only"] = 6
}

function Fishing.GetRarityRank(rarity)
    return Fishing._rarityOrder[rarity] or 1
end

function Fishing.SetKeepFilter(optionName)
    local level = RARITY_KEEP_FILTER[optionName]
    if level == nil then return false end
    Fishing.MinKeepRarity = level
    A.Notify("Fishing", "Keep filter: " .. tostring(optionName), 2)
    return true
end

function Fishing.GetFilterOption()
    for name, level in pairs(RARITY_KEEP_FILTER) do
        if level == Fishing.MinKeepRarity then return name end
    end
    return "Keep All"
end

function Fishing.SellAllFish()
    local ok, err = SafeCall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local sellRemote = remotes:FindFirstChild("SellFish") or remotes:FindFirstChild("SellItem") or remotes:FindFirstChild("Sell")
            if sellRemote then
                sellRemote:FireServer("All")
                Fishing._totalValue = 0
                A.Notify("Fishing", "Sold all fish!", 2)
                return true
            end
        end
        local commF = A.CommF
        if commF and commF.FireServer then
            commF:FireServer("SellFish", "All")
            Fishing._totalValue = 0
            A.Notify("Fishing", "Sold all fish!", 2)
            return true
        end
        A.Notify("Fishing", "Could not find sell remote", 2)
    end)
    return ok
end

function Fishing.SellFish(rarity)
    local ok, err = SafeCall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local sellRemote = remotes:FindFirstChild("SellFish") or remotes:FindFirstChild("SellItem")
            if sellRemote then
                sellRemote:FireServer(rarity)
                return true
            end
        end
    end)
    return ok
end

function Fishing.ShouldKeepRarity(rarity)
    if Fishing.MinKeepRarity == 0 then return true end
    return Fishing.GetRarityRank(rarity) >= Fishing.MinKeepRarity
end

function Fishing.EquipBestRod()
    local lp = A.LP
    if not lp then return false end
    local bestRod = nil
    local bestLevel = 0
    local backpack = lp:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                for _, rod in ipairs(FISHING_RODS) do
                    if (string.find(string.lower(item.Name), string.lower(rod.Name)) or string.find(string.lower(item.Name), "rod")) and rod.Level > bestLevel then
                        bestRod = item
                        bestLevel = rod.Level
                    end
                end
            end
        end
    end
    if not bestRod then return false end
    local char = lp.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            pcall(function() hum:EquipTool(bestRod) end)
        end
    end
    A.Notify("Fishing", "Equipped best rod: " .. bestRod.Name, 2)
    return true
end

function Fishing.GetFishingQuests()
    local quests = {}
    local lp = A.LP
    if lp then
        local data = lp:FindFirstChild("Data")
        if data then
            for _, child in ipairs(data:GetChildren()) do
                if string.find(string.lower(child.Name), "fish") or string.find(string.lower(child.Name), "quest") then
                    quests[#quests + 1] = child.Name
                end
            end
        end
        local questInfo = lp:FindFirstChild("Quest") or lp.PlayerGui:FindFirstChild("Quest")
        if questInfo then
            table.insert(quests, "Current: " .. questInfo.Name)
        end
    end
    return quests
end

function Fishing.GetNextRod()
    local currentLevel = Fishing.FishingLevel
    for _, rod in ipairs(FISHING_RODS) do
        if rod.Level > currentLevel then
            return rod
        end
    end
    return nil
end

A.Fishing = Fishing
A.Register("fishing", A.Fishing)
