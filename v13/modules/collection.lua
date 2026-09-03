local A = _G.Apex
local Col = {}
Col.Active = false

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then return false, err end
    return true, ...
end

Col.FRUIT_VALUES = {
    ["Blox Fruit"] = 100, ["Bomb"] = 100, ["Chop"] = 100, ["Spin"] = 100,
    ["Spring"] = 100, ["Bird"] = 100, ["Smoke"] = 100, ["Spike"] = 100,
    ["Kilo"] = 150, ["Flame"] = 250, ["Sand"] = 250, ["Dark"] = 250,
    ["Ghost"] = 250, ["Diamond"] = 300, ["Light"] = 500, ["Ice"] = 500,
    ["Rocket"] = 400, ["Fire"] = 400, ["Rubber"] = 500, ["Love"] = 500,
    ["Quake"] = 700, ["Barrier"] = 700, ["Falcon"] = 700, ["Spider"] = 1000,
    ["Magma"] = 1200, ["Spring2"] = 500, ["Portal"] = 1500, ["Water"] = 1000,
    ["Venom"] = 1800, ["Shadow"] = 1800, ["Blizzard"] = 1800, ["Pain"] = 1800,
    ["Dough"] = 5000, ["Buddha"] = 1200, ["Mammoth"] = 2500, ["T-Rex"] = 5000,
    ["Leopard"] = 10000, ["Kitsune"] = 50000, ["Dragon"] = 50000, ["Tori"] = 2000,
    ["Gas"] = 3000, ["Yeti"] = 5000, ["Rumble"] = 1000, ["Sound"] = 1800,
    ["Smoke2"] = 100, ["Control"] = 2000, ["Gravity"] = 1500, ["Phoenix"] = 1500,
}
-- Distinctive Chest Filter (was all chests same vs Redz)
Col.ChestFilter = {Golden=true, Diamond=true, Wood=false, Stone=false}
function Col.SetChestFilter(t, v) Col.ChestFilter[t]=v end
function Col.IsChestAllowed(chest) local n=chest.Name:lower(); if n:find("gold") or n:find("diamond") then return Col.ChestFilter.Golden elseif n:find("wood") or n:find("stone") then return Col.ChestFilter.Wood else return true end end

function Col.GetFruitValue(fruitName)
    if not fruitName then return 0 end
    for k, v in pairs(Col.FRUIT_VALUES) do
        if string.find(string.lower(fruitName), string.lower(k)) then
            return v
        end
    end
    return 50
end

function Col.GetInventory()
    local lp = A.LP
    if not lp then return {} end
    local result = {Fruits = {}, Items = {}, Value = 0}
    local backpack = lp:FindFirstChild("Backpack")
    local char = lp.Character
    for _, container in ipairs({backpack, char}) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                local isFruit = item:FindFirstChild("Fruit") or item:FindFirstChild("FruitData") or
                    string.find(string.lower(item.Name), "fruit")
                if isFruit then
                    local val = Col.GetFruitValue(item.Name)
                    result.Fruits[#result.Fruits + 1] = {Name = item.Name, Value = val}
                    result.Value = result.Value + val
                else
                    result.Items[#result.Items + 1] = {Name = item.Name, Value = Col.GetFruitValue(item.Name)}
                    result.Value = result.Value + result.Items[#result.Items].Value
                end
            end
        end
    end
    return result
end

function Col.GetFruitInventory()
    local inv = Col.GetInventory()
    return inv.Fruits
end

function Col.GetInventoryValue()
    return Col.GetInventory().Value
end

function Col.GetMissingFruits()
    local inv = {}
    for _, f in ipairs(Col.GetFruitInventory()) do
        inv[f.Name] = true
    end
    local missing = {}
    for fruit, _ in pairs(Col.FRUIT_VALUES) do
        local owned = false
        for ownedName in pairs(inv) do
            if string.find(string.lower(ownedName), string.lower(fruit)) then
                owned = true
                break
            end
        end
        if not owned then
            missing[#missing + 1] = {Name = fruit, Value = Col.GetFruitValue(fruit)}
        end
    end
    table.sort(missing, function(a, b) return a.Value > b.Value end)
    return missing
end

function Col.GetCollectionSummary()
    local owned = Col.GetFruitInventory()
    local ownedNames = {}
    for _, f in ipairs(owned) do
        ownedNames[f.Name] = true
    end
    local ownedCount = 0
    for _ in pairs(ownedNames) do ownedCount = ownedCount + 1 end
    local missing = Col.GetMissingFruits()
    local totalCount = #Col.FRUIT_VALUES
    return {
        Owned = ownedCount,
        Missing = #missing,
        Total = totalCount,
        Completion = totalCount > 0 and math.floor((ownedCount / totalCount) * 1000) / 10 or 0,
        Value = Col.GetInventoryValue(),
        MissingList = missing,
    }
end

function Col.GetDuplicateFruits()
    local inv = Col.GetFruitInventory()
    local seen = {}
    local dups = {}
    for _, f in ipairs(inv) do
        local matched = nil
        for ownedName in pairs(seen) do
            if string.find(string.lower(ownedName), string.lower(f.Name)) then
                matched = ownedName
                break
            end
        end
        if matched then
            dups[#dups + 1] = f.Name
        else
            seen[f.Name] = true
        end
    end
    return dups
end

A.Collection = Col
A.Register("collection", A.Collection)
