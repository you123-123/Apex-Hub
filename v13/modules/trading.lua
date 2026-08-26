local A = _G.Apex
local Trading = {}
Trading.Active = false
Trading.TradesCompleted = 0
Trading.TradeHistory = {}
Trading._loop = nil
Trading._startTick = 0
Trading._pendingTrade = nil
Trading._tradePartner = nil
Trading._tradeValue = 0
Trading._autoAcceptThreshold = 50000
Trading._minAcceptableValue = 10000
Trading._maxTradeAttempts = 5
Trading._tradeAttempts = 0
Trading._lastTradeTime = 0
Trading._tradeCooldown = 30
Trading._tradeLog = {}
Trading._scammed = false
Trading._partnerBlacklist = {}
Trading._itemValues = {}
Trading._myOfferValue = 0
Trading._theirOfferValue = 0
Trading._fairnessRatio = 0
Trading._tradeActive = false
Trading._tradeWindowOpen = false
Trading._confirmClicked = false
Trading._safetyChecks = true

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local HIGH_VALUE_ITEMS = {
    ["Leviathan Shield"] = 500000,
    ["Soul Guitar"] = 750000,
    ["Dark Blade V3"] = 1000000,
    ["Godhuman"] = 2000000,
    ["Canvander"] = 2500000,
    ["Spikey Trident"] = 3000000,
    ["Bundle"] = 4000000,
    ["Yama"] = 5000000,
    ["Tushita"] = 5000000,
    ["Dark Dagger"] = 7500000,
    ["Void" .. "walker"] = 1000000,
    ["Kitsune" .. "Ribbon"] = 3000000
}

local COMMON_ITEMS = {
    ["Katana"] = 1000,
    ["Iron Mace"] = 1500,
    ["Dual Katana"] = 12000,
    ["Triple Katana"] = 60000,
    ["Pipe"] = 100000,
    ["Sword Master"] = 150000,
    ["Slingshot"] = 5000,
    ["Musket"] = 8000,
    ["Flintlock"] = 15000
}

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Apex Trading] Error: " .. tostring(err))
    end
    return ok, err
end

function Trading.GetTradeValue(items)
    local totalValue = 0
    if not items or type(items) ~= "table" then return 0 end
    for _, item in ipairs(items) do
        local itemName = type(item) == "table" and item.Name or tostring(item)
        local value = HIGH_VALUE_ITEMS[itemName] or COMMON_ITEMS[itemName] or 5000
        if type(item) == "table" and item.Quantity then
            value = value * item.Quantity
        end
        totalValue = totalValue + value
    end
    return totalValue
end

function Trading.IsTradeFair(myItems, theirItems)
    local myValue = Trading.GetTradeValue(myItems)
    local theirValue = Trading.GetTradeValue(theirItems)
    Trading._myOfferValue = myValue
    Trading._theirOfferValue = theirValue
    if myValue == 0 then
        Trading._fairnessRatio = theirValue > 0 and 999 or 1
        return true
    end
    Trading._fairnessRatio = theirValue / myValue
    return Trading._fairnessRatio >= 0.7 and Trading._fairnessRatio <= 1.5
end

function Trading.CheckTradeSafety(tradeData)
    if not Trading._safetyChecks then return true end
    if not tradeData then return false end
    local partner = tradeData.Partner
    if partner and table.find(Trading._partnerBlacklist, partner) then
        A.Notify("Trade Safety", "Partner is blacklisted!", 3)
        return false
    end
    if tradeData.MyItems and #tradeData.MyItems == 0 and tradeData.TheirItems and #tradeData.TheirItems > 0 then
        return true
    end
    if tradeData.MyItems then
        for _, item in ipairs(tradeData.MyItems) do
            local itemName = type(item) == "table" and item.Name or tostring(item)
            local value = HIGH_VALUE_ITEMS[itemName]
            if value and value >= 1000000 then
                A.Notify("Trade Safety", "Trading high-value item: " .. itemName, 5)
                task.wait(2)
            end
        end
    end
    if tradeData.TheirItems and #tradeData.TheirItems == 0 and tradeData.MyItems and #tradeData.MyItems > 0 then
        A.Notify("Trade Safety", "Partner offering nothing!", 5)
        return false
    end
    return true
end

function Trading.FindTradePartner()
    local lp = A.LP
    if not lp then return nil end
    local myHRP = A.HRP()
    if not myHRP then return nil end
    local candidates = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lp and player.Character then
            local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local dist = (myHRP.Position - targetHRP.Position).Magnitude
                if dist < 100 then
                    local isBlacklisted = false
                    for _, name in ipairs(Trading._partnerBlacklist) do
                        if (player.DisplayName or player.Name) == name then
                            isBlacklisted = true
                            break
                        end
                    end
                    if not isBlacklisted then
                        table.insert(candidates, {
                            Player = player,
                            Distance = dist,
                            Name = player.DisplayName or player.Name
                        })
                    end
                end
            end
        end
    end
    table.sort(candidates, function(a, b) return a.Distance < b.Distance end)
    if #candidates > 0 then
        return candidates[1]
    end
    return nil
end

function Trading.GetBestTradeOffers()
    local offers = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            local inventory = {}
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                for _, item in ipairs(leaderstats:GetChildren()) do
                    if item:IsA("ValueBase") then
                        table.insert(inventory, {Name = item.Name, Value = item.Value})
                    end
                end
            end
            if #inventory > 0 then
                local totalValue = 0
                for _, inv in ipairs(inventory) do
                    totalValue = totalValue + (tonumber(inv.Value) or 0)
                end
                table.insert(offers, {
                    Player = player,
                    Name = player.DisplayName or player.Name,
                    Items = inventory,
                    TotalValue = totalValue
                })
            end
        end
    end
    table.sort(offers, function(a, b) return a.TotalValue > b.TotalValue end)
    return offers
end

function Trading.LogTrade(tradeData)
    local logEntry = {
        Time = tick(),
        Partner = tradeData.Partner or "Unknown",
        MyItems = tradeData.MyItems or {},
        TheirItems = tradeData.TheirItems or {},
        MyValue = tradeData.MyValue or 0,
        TheirValue = tradeData.TheirValue or 0,
        Accepted = tradeData.Accepted or false,
        Fair = tradeData.Fair or false
    }
    table.insert(Trading.TradeHistory, logEntry)
    table.insert(Trading._tradeLog, logEntry)
    if #Trading.TradeHistory > 100 then
        table.remove(Trading.TradeHistory, 1)
    end
end

function Trading.AcceptTrade()
    local ok, err = SafeCall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local acceptTrade = remotes:FindFirstChild("AcceptTrade") or remotes:FindFirstChild("TradeAccept")
            if acceptTrade then
                acceptTrade:FireServer()
                Trading._confirmClicked = true
                A.Notify("Trade", "Trade accepted!", 2)
            end
        end
        local commF = A.CommF
        if commF then
            commF("AcceptTrade")
        end
    end)
    return ok
end

function Trading.DeclineTrade()
    local ok, err = SafeCall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local declineTrade = remotes:FindFirstChild("DeclineTrade") or remotes:FindFirstChild("TradeDecline")
            if declineTrade then
                declineTrade:FireServer()
                A.Notify("Trade", "Trade declined", 2)
            end
        end
        local commF = A.CommF
        if commF then
            commF("DeclineTrade")
        end
    end)
    Trading._tradeActive = false
    Trading._tradeWindowOpen = false
    Trading._confirmClicked = false
    return ok
end

function Trading.AutoAccept(tradeData)
    if not tradeData then return false end
    if not Trading.CheckTradeSafety(tradeData) then
        Trading.DeclineTrade()
        return false
    end
    local isFair = Trading.IsTradeFair(tradeData.MyItems or {}, tradeData.TheirItems or {})
    if tradeData.TheirValue and tradeData.TheirValue >= Trading._autoAcceptThreshold then
        A.Notify("Trade Auto", "High value trade detected: " .. tostring(tradeData.TheirValue), 5)
        Trading.AcceptTrade()
        Trading.TradesCompleted = Trading.TradesCompleted + 1
        Trading.LogTrade({
            Partner = tradeData.Partner,
            MyItems = tradeData.MyItems,
            TheirItems = tradeData.TheirItems,
            MyValue = Trading._myOfferValue,
            TheirValue = Trading._theirOfferValue,
            Accepted = true,
            Fair = isFair
        })
        return true
    end
    if isFair and tradeData.TheirValue and tradeData.TheirValue >= Trading._minAcceptableValue then
        A.Notify("Trade Auto", "Fair trade detected", 3)
        Trading.AcceptTrade()
        Trading.TradesCompleted = Trading.TradesCompleted + 1
        Trading.LogTrade({
            Partner = tradeData.Partner,
            MyItems = tradeData.MyItems,
            TheirItems = tradeData.TheirItems,
            MyValue = Trading._myOfferValue,
            TheirValue = Trading._theirOfferValue,
            Accepted = true,
            Fair = true
        })
        return true
    end
    if tradeData.TheirValue and tradeData.TheirValue < Trading._minAcceptableValue then
        A.Notify("Trade Auto", "Trade value too low: " .. tostring(tradeData.TheirValue), 3)
        Trading.DeclineTrade()
        return false
    end
    return false
end

function Trading.TradeFilter(player)
    if not player or not player.Character then return false end
    if player == Players.LocalPlayer then return false end
    if table.find(Trading._partnerBlacklist, player.DisplayName or player.Name) then
        return false
    end
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        for _, item in ipairs(leaderstats:GetChildren()) do
            if item:IsA("ValueBase") and tonumber(item.Value) and tonumber(item.Value) > 10000 then
                return true
            end
        end
    end
    return false
end

function Trading.GetTradeHistory()
    return Trading.TradeHistory
end

function Trading.GetTradeStats()
    local sessionTime = tick() - Trading._startTick
    local minutes = math.floor(sessionTime / 60)
    local seconds = math.floor(sessionTime % 60)
    local wins = 0
    local losses = 0
    for _, trade in ipairs(Trading.TradeHistory) do
        if trade.Fair then
            wins = wins + 1
        else
            losses = losses + 1
        end
    end
    return {
        TradesCompleted = Trading.TradesCompleted,
        TotalTrades = #Trading.TradeHistory,
        Wins = wins,
        Losses = losses,
        WinRate = #Trading.TradeHistory > 0 and string.format("%.1f%%", wins / #Trading.TradeHistory * 100) or "0%",
        SessionTime = string.format("%dm %ds", minutes, seconds),
        CurrentPartner = Trading._tradePartner and Trading._tradePartner.Name or "None",
        TradeActive = Trading._tradeActive,
        BlacklistSize = #Trading._partnerBlacklist,
        AutoThreshold = Trading._autoAcceptThreshold,
        LastTradeTime = Trading._lastTradeTime > 0 and tostring(math.floor(tick() - Trading._lastTradeTime)) .. "s ago" or "Never"
    }
end

function Trading.MainLoop()
    while Trading.Active do
        if not A.Alive() then
            task.wait(2)
            break
        end
        SafeCall(function()
            if Trading._tradeActive and Trading._tradeWindowOpen then
                if Trading._pendingTrade then
                    Trading.AutoAccept(Trading._pendingTrade)
                end
            end
            if not Trading._tradeActive then
                if tick() - Trading._lastTradeTime < Trading._tradeCooldown then
                    return
                end
                local partner = Trading.FindTradePartner()
                if partner then
                    local tradeData = {
                        Partner = partner.Name,
                        MyItems = {},
                        TheirItems = {},
                        MyValue = 0,
                        TheirValue = 0
                    }
                    Trading._pendingTrade = tradeData
                    Trading._tradePartner = partner.Player
                    Trading._tradeActive = true
                    A.Notify("Trade", "Found partner: " .. partner.Name, 3)
                end
            end
        end)
        task.wait(1)
    end
end

function Trading.Start()
    if Trading.Active then return end
    Trading.Active = true
    Trading._startTick = tick()
    Trading._tradeActive = false
    Trading._tradeWindowOpen = false
    Trading._confirmClicked = false
    A.Notify("Trading", "Started auto trading", 3)
    Trading._loop = task.spawn(function()
        Trading.MainLoop()
        Trading.Active = false
    end)
end

function Trading.Stop()
    Trading.Active = false
    Trading._tradeActive = false
    Trading._tradeWindowOpen = false
    Trading._pendingTrade = nil
    if Trading._loop then
        task.cancel(Trading._loop)
        Trading._loop = nil
    end
    A.Notify("Trading", "Stopped", 2)
end

function Trading.ShowHistory()
    Trading.GetTradeHistory()
end

A.Trading = Trading
A.Register("trading", A.Trading)
