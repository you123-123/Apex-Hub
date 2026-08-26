local A = _G.Apex
local Shop = {}
Shop.Active = false
Shop.BoughtItems = {}
Shop.TotalSpent = 0
Shop._loop = nil
Shop._startTick = 0
Shop._purchaseLog = {}
Shop._failedPurchases = {}
Shop._lastPurchaseTime = 0
Shop._purchaseCooldown = 1
Shop._autoBuyList = {}
Shop._blacklist = {}
Shop._budget = math.huge
Shop._spentThisSession = 0
Shop._itemsBoughtThisSession = 0
Shop._shopLocation = nil
Shop._navigating = false
Shop._buyQueue = {}
Shop._retryCount = 3
Shop._materialCache = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local SWORD_ITEMS = {"Swords", "Sword"}
local GUN_ITEMS = {"Guns", "Gun"}
local ABILITY_ITEMS = {"Abilities", "Ability", "Skills"}
local FIGHTING_ITEMS = {"FightingStyle", "Fighting Styles", "Fist"}
local ACCESSORY_ITEMS = {"Accessories", "Accessory", "Equip"}
local MATERIAL_ITEMS = {"Materials", "Material"}
local HAKI_TYPES = {"Haki", "Buso", "Ken", "Soru", "Geppo"}

local SHOP_NPCS = {
    SwordDealer = "Sword Dealer",
    GunDealer = "Gun Dealer",
    AbilityTeacher = "Ability Teacher",
    FightingTeacher = "Fighting Style Teacher",
    AccessoryDealer = "Accessory Dealer",
    MaterialDealer = "Material Dealer",
    HakiTeacher = "Haki Teacher",
    RaceDealer = "Race Dealer",
    GeneralShop = "Shop"
}

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Apex Shop] Error: " .. tostring(err))
    end
    return ok, err
end

function Shop.CanAfford(price)
    local lp = A.LP
    if not lp then return false end
    local money = 0
    local moneyVal = lp:FindFirstChild("Money") or lp:FindFirstChild("Beli")
    if moneyVal and moneyVal:IsA("ValueBase") then
        money = tonumber(moneyVal.Value) or 0
    end
    local fragVal = lp:FindFirstChild("Fragments") or lp:FindFirstChild("Frag")
    local frags = 0
    if fragVal and fragVal:IsA("ValueBase") then
        frags = tonumber(fragVal.Value) or 0
    end
    if type(price) == "table" then
        local beliCost = price.Beli or 0
        local fragCost = price.Fragments or 0
        return money >= beliCost and frags >= fragCost
    end
    return money >= price
end

function Shop.GetMoney()
    local lp = A.LP
    if not lp then return 0, 0 end
    local money = 0
    local moneyVal = lp:FindFirstChild("Money") or lp:FindFirstChild("Beli")
    if moneyVal and moneyVal:IsA("ValueBase") then
        money = tonumber(moneyVal.Value) or 0
    end
    local frags = 0
    local fragVal = lp:FindFirstChild("Fragments") or lp:FindFirstChild("Frag")
    if fragVal and fragVal:IsA("ValueBase") then
        frags = tonumber(fragVal.Value) or 0
    end
    return money, frags
end

function Shop.GetShopLocation(shopType)
    local locations = {
        SwordDealer = Vector3.new(-268, 35, 58),
        GunDealer = Vector3.new(-270, 35, 60),
        AbilityTeacher = Vector3.new(-272, 35, 62),
        FightingTeacher = Vector3.new(-274, 35, 64),
        AccessoryDealer = Vector3.new(-276, 35, 66),
        MaterialDealer = Vector3.new(-278, 35, 68),
        HakiTeacher = Vector3.new(-280, 35, 70),
        RaceDealer = Vector3.new(-282, 35, 72),
        GeneralShop = Vector3.new(-284, 35, 74)
    }
    return locations[shopType] or Vector3.new(0, 30, 0)
end

function Shop.NavigateToShop(shopType)
    local pos = Shop.GetShopLocation(shopType)
    if not pos then return false end
    local myHRP = A.HRP()
    if not myHRP then return false end
    local dist = (myHRP.Position - pos).Magnitude
    if dist > 30 then
        A.TpTo(pos + Vector3.new(0, 3, 0), 100)
        Shop._navigating = true
        return false
    end
    Shop._navigating = false
    return true
end

function Shop.GetShopItems(shopType)
    local items = {}
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            local result = commF("GetShopItems", shopType)
            if result and type(result) == "table" then
                items = result
            end
        end
    end)
    if #items == 0 then
        local npc = Workspace:FindFirstChild("NPCs") or Workspace:FindFirstChild("Living")
        if npc then
            local shopName = SHOP_NPCS[shopType] or shopType
            for _, child in ipairs(npc:GetDescendants()) do
                if child:IsA("Model") and string.find(string.lower(child.Name), string.lower(shopName)) then
                    local dialog = child:FindFirstChild("Dialog") or child:FindFirstChild("Interact")
                    if dialog then
                        table.insert(items, {Name = child.Name, Type = "NPC", NPC = child})
                    end
                end
            end
        end
    end
    return items
end

function Shop.BuySpecificItem(itemName, shopType)
    if tick() - Shop._lastPurchaseTime < Shop._purchaseCooldown then
        return false
    end
    if table.find(Shop._blacklist, itemName) then
        return false
    end
    if not Shop.NavigateToShop(shopType or "GeneralShop") then
        return false
    end
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            commF("BuyItem", itemName)
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local buyRemote = remotes:FindFirstChild("BuyItem") or remotes:FindFirstChild("Purchase")
            if buyRemote then
                buyRemote:FireServer(itemName)
            end
        end
        Shop._lastPurchaseTime = tick()
        table.insert(Shop.BoughtItems, {
            Name = itemName,
            Time = tick(),
            ShopType = shopType or "GeneralShop"
        })
        Shop._itemsBoughtThisSession = Shop._itemsBoughtThisSession + 1
        A.Notify("Shop", "Bought: " .. itemName, 2)
    end)
    if not ok then
        table.insert(Shop._failedPurchases, {
            Name = itemName,
            Error = err,
            Time = tick()
        })
    end
    return ok
end

function Shop.BuySwords()
    local swordData = {
        {Name = "Katana", Price = 1000},
        {Name = "Iron Mace", Price = 1500},
        {Name = "Dual Katana", Price = 12000},
        {Name = "Triple Katana", Price = 60000},
        {Name = "Pipe", Price = 100000},
        {Name = "Sword Master", Price = 150000},
        {Name = "Bisento", Price = 750000},
        {Name = "Platinum Saber", Price = 1000000},
        {Name = "Shark Blade", Price = 1200000},
        {Name = "Soul Cane", Price = 2500000},
        {Name = "Gravity Cane", Price = 2500000},
        {Name = "Dark Blade", Price = 5000000}
    }
    for _, sword in ipairs(swordData) do
        if not table.find(Shop._blacklist, sword.Name) and Shop.CanAfford(sword.Price) then
            Shop.BuySpecificItem(sword.Name, "SwordDealer")
            task.wait(0.5)
        end
    end
end

function Shop.BuyGuns()
    local gunData = {
        {Name = "Slingshot", Price = 5000},
        {Name = "Musket", Price = 8000},
        {Name = "Flintlock", Price = 15000},
        {Name = "Refined Musket", Price = 30000},
        {Name = "Cannon", Price = 100000},
        {Name = "Bazooka", Price = 250000},
        {Name = "Kabucha", Price = 1500000}
    }
    for _, gun in ipairs(gunData) do
        if not table.find(Shop._blacklist, gun.Name) and Shop.CanAfford(gun.Price) then
            Shop.BuySpecificItem(gun.Name, "GunDealer")
            task.wait(0.5)
        end
    end
end

function Shop.BuyAbilities()
    local abilities = {
        {Name = "Geppo", Price = 10000},
        {Name = "Soru", Price = 10000},
        {Name = "Haki", Price = 25000},
        {Name = "Rokushiki", Price = 50000}
    }
    for _, abil in ipairs(abilities) do
        if not table.find(Shop._blacklist, abil.Name) and Shop.CanAfford(abil.Price) then
            Shop.BuySpecificItem(abil.Name, "AbilityTeacher")
            task.wait(0.5)
        end
    end
end

function Shop.BuyFightingStyles()
    local styles = {
        {Name = "Black Leg", Price = 150000},
        {Name = "Electro", Price = 500000},
        {Name = "Fishman Karate", Price = 750000},
        {Name = "Dragon Claw", Price = 1500000},
        {Name = "Super Human", Price = 3000000},
        {Name = "Electric Claw", Price = 3000000},
        {Name = "Sharkman Karate", Price = 2500000},
        {Name = "Death Step", Price = 2500000},
        {Name = "Godhuman", Price = 5000000}
    }
    for _, style in ipairs(styles) do
        if not table.find(Shop._blacklist, style.Name) and Shop.CanAfford(style.Price) then
            Shop.BuySpecificItem(style.Name, "FightingTeacher")
            task.wait(0.5)
        end
    end
end

function Shop.BuyAccessories()
    local accessories = {
        {Name = "Black Cape", Price = 50000},
        {Name = "Swordsman Hat", Price = 100000},
        {Name = "Pink Coat", Price = 250000},
        {Name = "Tomoe Ring", Price = 500000},
        {Name = "Leather Belt", Price = 750000},
        {Name = "Flower Shirt", Price = 1000000}
    }
    for _, acc in ipairs(accessories) do
        if not table.find(Shop._blacklist, acc.Name) and Shop.CanAfford(acc.Price) then
            Shop.BuySpecificItem(acc.Name, "AccessoryDealer")
            task.wait(0.5)
        end
    end
end

function Shop.BuyMaterials()
    local materials = {"Scrap Metal", "Iron Ore", "Leather Cloth", "Radioactive Material", "Mystic Droplet", "Dragon Scale", "Ectoplasm", "Dark Fragment", "Angel Wings", "Meteor Core"}
    for _, mat in ipairs(materials) do
        if Shop.CanAfford(10000) then
            Shop.BuySpecificItem(mat, "MaterialDealer")
            task.wait(0.5)
        end
    end
end

function Shop.BuyFromDealer(dealerName, itemName)
    local npc = Workspace:FindFirstChild("NPCs") or Workspace:FindFirstChild("Living")
    if not npc then return false end
    for _, child in ipairs(npc:GetDescendants()) do
        if child:IsA("Model") and string.find(string.lower(child.Name), string.lower(dealerName)) then
            local part = child:FindFirstChild("HumanoidRootPart") or child.PrimaryPart
            if part then
                local myHRP = A.HRP()
                if myHRP then
                    local dist = (myHRP.Position - part.Position).Magnitude
                    if dist > 30 then
                        A.TpTo(part.Position + Vector3.new(0, 3, 0), 100)
                        return false
                    end
                end
                Shop.BuySpecificItem(itemName, dealerName)
                return true
            end
        end
    end
    return false
end

function Shop.BuyRace()
    local races = {"Human", "Cyborg", "Fishman", "Ghoul", "Mink"}
    for _, race in ipairs(races) do
        Shop.BuySpecificItem(race, "RaceDealer")
        task.wait(1)
    end
end

function Shop.RefundStats()
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            commF("RefundStats")
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local refund = remotes:FindFirstChild("RefundStats") or remotes:FindFirstChild("Refund")
            if refund then
                refund:FireServer()
                A.Notify("Shop", "Stats refunded!", 3)
            end
        end
    end)
    return ok
end

function Shop.RerollRace()
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            commF("RerollRace")
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local reroll = remotes:FindFirstChild("RerollRace")
            if reroll then
                reroll:FireServer()
                A.Notify("Shop", "Race rerolled!", 3)
            end
        end
    end)
    return ok
end

function Shop.BuyHaki()
    return Shop.BuySpecificItem("Haki", "HakiTeacher")
end

function Shop.BuyGeppo()
    return Shop.BuySpecificItem("Geppo", "AbilityTeacher")
end

function Shop.BuySoru()
    return Shop.BuySpecificItem("Soru", "AbilityTeacher")
end

function Shop.BuyBuso()
    return Shop.BuySpecificItem("Buso Haki", "HakiTeacher")
end

function Shop.BuyKen()
    return Shop.BuySpecificItem("Ken Haki", "HakiTeacher")
end

function Shop.BuyAllItems()
    Shop.BuySwords()
    task.wait(0.5)
    Shop.BuyGuns()
    task.wait(0.5)
    Shop.BuyAbilities()
    task.wait(0.5)
    Shop.BuyFightingStyles()
    task.wait(0.5)
    Shop.BuyAccessories()
    task.wait(0.5)
    Shop.BuyMaterials()
end

function Shop.GetBoughtItems()
    return Shop.BoughtItems
end

function Shop.ShopStats()
    local money, frags = Shop.GetMoney()
    local sessionTime = tick() - Shop._startTick
    local minutes = math.floor(sessionTime / 60)
    local seconds = math.floor(sessionTime % 60)
    return {
        Money = money,
        Fragments = frags,
        ItemsBought = #Shop.BoughtItems,
        SessionItems = Shop._itemsBoughtThisSession,
        FailedPurchases = #Shop._failedPurchases,
        TotalSpent = Shop._spentThisSession,
        SessionTime = string.format("%dm %ds", minutes, seconds),
        BlacklistSize = #Shop._blacklist,
        BuyQueueSize = #Shop._buyQueue
    }
end

function Shop.MainLoop()
    while Shop.Active do
        if not A.Alive() then
            task.wait(2)
            break
        end
        if #Shop._buyQueue > 0 then
            local item = table.remove(Shop._buyQueue, 1)
            if item then
                Shop.BuySpecificItem(item.Name, item.ShopType)
            end
        end
        task.wait(1)
    end
end

function Shop.Start(buyList)
    if Shop.Active then return end
    Shop.Active = true
    Shop._startTick = tick()
    if buyList and type(buyList) == "table" then
        for _, item in ipairs(buyList) do
            table.insert(Shop._buyQueue, item)
        end
    end
    A.Notify("Shop", "Started shop automation", 3)
    Shop._loop = task.spawn(function()
        Shop.MainLoop()
        Shop.Active = false
    end)
end

function Shop.Stop()
    Shop.Active = false
    Shop._buyQueue = {}
    if Shop._loop then
        task.cancel(Shop._loop)
        Shop._loop = nil
    end
    A.Notify("Shop", "Stopped", 2)
end

function Shop.ShowDialog()
end

A.Shop = Shop
A.Register("shop", A.Shop)
