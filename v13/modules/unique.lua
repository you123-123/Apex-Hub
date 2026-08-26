local A = _G.Apex
if not A then return end

A.Unique = {}
A.Unique.Active = false
A.Unique.KeybindsActive = false
A.Unique.StealthActive = false
A.Unique.FeaturesUsed = 0
A.Unique.SessionStats = {
    F1Toggles = 0,
    F2Toggles = 0,
    F3Toggles = 0,
    F4Toggles = 0,
    F5Toggles = 0,
    F6Toggles = 0,
    F7Toggles = 0,
    F8Toggles = 0,
    F9Toggles = 0,
    F10Toggles = 0,
    InsertToggles = 0,
    TotalKeybindsPressed = 0,
    SessionStart = tick(),
    StealthActivations = 0,
    TeamSwitches = 0,
    ItemsManaged = 0,
    BuffsManaged = 0,
    BossTimersTracked = 0,
    PvPMatches = 0,
    FruitChecks = 0,
    ServerHops = 0,
    ItemsSold = 0,
    RacesUnlocked = 0,
    CombosSaved = 0,
    AIPredictions = 0,
    CombatAnalyses = 0,
    FarmsOptimized = 0,
    ProgressTracked = 0,
    AchievementsTracked = 0,
    NotificationsSent = 0,
    SocialActions = 0,
    FPS = 60,
    Ping = 0,
    Memory = 0
}

A.Unique.KeybindState = {
    F1 = false,
    F2 = false,
    F3 = false,
    F4 = false,
    F5 = false,
    F6 = false,
    F7 = false,
    F8 = false,
    F9 = false,
    F10 = false,
    Insert = false
}

A.Unique.StealthSettings = {
    HideName = true,
    HideDistance = true,
    HideEffects = true,
    FakeName = "Player",
    RandomizePosition = false,
    AntiReport = true,
    LeaveOnReport = false
}

A.Unique.BossTimers = {
    ["Gorilla King"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-1600, 50, 380)},
    ["Bobby"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-400, 30, -2600)},
    ["Yeti"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(540, 40, -5280)},
    ["Vice Admiral"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-4800, 20, -1800)},
    ["Warden"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(5100, 20, 4050)},
    ["Swan"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(5200, 20, 4150)},
    ["Combat Master"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-2000, 20, -3200)},
    ["Diamond"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-2800, 30, 2300)},
    ["Jeremy"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-3200, 30, -700)},
    ["Fajita"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-3300, 30, -800)},
    ["Don Swan"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-3400, 30, -900)},
    ["Smoke Admiral"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-3500, 30, -1000)},
    ["Cursed Captain"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-3600, 30, -1100)},
    ["Awakened Ice Admiral"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-3700, 30, -1200)},
    ["Order"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-3900, 30, -1400)},
    ["Head Instructor"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-600, 20, 500)},
    ["Diablo"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(6300, 25, 1000)},
    ["Dread"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(5400, 600, 1600)},
    ["Rip_indra"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-700, 20, 600)},
    ["Venom"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(5500, 600, 1700)},
    ["Terrorshark"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-850, 20, 750)},
    ["Leviathan"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-950, 20, 850)},
    ["Cake Prince"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-1050, 20, 950)},
    ["Dough King"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-1150, 20, 1050)},
    ["Kitsune"] = {SpawnTime = 0, RespawnTime = 300, LastKill = 0, Position = CFrame.new(-1250, 20, 1150)}
}

A.Unique.FruitValueData = {
    ["Common"] = {Min = 100, Max = 500, Fruits = {"Bomb", "Spin", "Chop", "Spring", "Bomb"}},
    ["Uncommon"] = {Min = 500, Max = 2000, Fruits = {"Smoke", "Flame", "Ice", "Dark", "Diamond"}},
    ["Rare"] = {Min = 2000, Max = 10000, Fruits = {"Light", "Rubber", "Magma", "Quake", "Love"}},
    ["Epic"] = {Min = 10000, Max = 50000, Fruits = {"String", "Bird: Phoenix", "Barrier", "Gravity", "Ghost"}},
    ["Legendary"] = {Min = 50000, Max = 200000, Fruits = {"Buddha", "Spider", "Control", "Dragon", "Leopard"}},
    ["Mythical"] = {Min = 200000, Max = 1000000, Fruits = {"Spirit", "Dough", "Venom", "Shadow", "Kitsune", "Mammoth", "T-Rex", "Gas", "Sound", "Control"}}
}

A.Unique.ComboPresets = {}
A.Unique.ProgressData = {
    Level = 0,
    Bounty = 0,
    Beli = 0,
    Fragments = 0,
    Race = "Unknown",
    RaceLevel = 0,
    HakiLevel = 0,
    AwakeningLevel = 0,
    ItemsOwned = 0,
    BossesDefeated = 0,
    PvPWins = 0,
    PvPLosses = 0,
    PlayTime = 0,
    LastUpdate = tick()
}

A.Unique.AchievementData = {
    FirstKill = false,
    FirstBoss = false,
    MaxLevel = false,
    MaxBounty = false,
    AllRaces = false,
    AllFruits = false,
    AllSwords = false,
    AllGuns = false,
    AllAccessories = false,
    RainbowHaki = false,
    MaxAwakening = false,
    SeaBeast = false,
    Leviathan = false,
    DoughKing = false,
    Kitsune = false,
    PvPStreak10 = false,
    PvPStreak50 = false,
    PvPStreak100 = false,
    Played24Hours = false,
    Played100Hours = false
}

A.Unique.ServerHopData = {
    LowPlayerThreshold = 10,
    MaxHops = 10,
    HopsCompleted = 0,
    LastHopTime = 0,
    Cooldown = 30
}

local function GetPlayerCount()
    return #game.Players:GetPlayers()
end

local function GetLowPlayerServers()
    local servers = {}
    pcall(function()
        local success, result = pcall(function()
            return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if success and result and result.data then
            for _, server in ipairs(result.data) do
                if server.playing < A.Unique.ServerHopData.LowPlayerThreshold then
                    table.insert(servers, server)
                end
            end
        end
    end)
    return servers
end

local function GetServerPing()
    local success, ping = pcall(function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    return success and ping or 0
end

local function GetMemoryUsage()
    local success, mem = pcall(function()
        return game:GetService("Stats").PhysicalMemory Used / 1024 / 1024
    end)
    return success and mem or 0
end

local function GetFPS()
    local success, fps = pcall(function()
        return math.floor(1 / game:GetService("RunService").Heartbeat:Wait())
    end)
    return success and fps or 60
end

local function FormatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    end
    return tostring(num)
end

local function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    if hours > 0 then
        return string.format("%dh %dm %ds", hours, minutes, secs)
    elseif minutes > 0 then
        return string.format("%dm %ds", minutes, secs)
    end
    return string.format("%ds", secs)
end

local function SetupKeybind(key, callback)
    local keyConnection
    keyConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == key then
            callback()
        end
    end)
    return keyConnection
end

function A.Unique.ToggleAutoFarm()
    A.Unique.KeybindState.F1 = not A.Unique.KeybindState.F1
    A.Unique.SessionStats.F1Toggles = A.Unique.SessionStats.F1Toggles + 1
    A.Unique.SessionStats.TotalKeybindsPressed = A.Unique.SessionStats.TotalKeybindsPressed + 1
    if A.Unique.KeybindState.F1 then
        A.Notify("Keybind F1", "Auto Farm: ON", 2)
        if A.AutoFarm then
            A.AutoFarm.Start()
        end
    else
        A.Notify("Keybind F1", "Auto Farm: OFF", 2)
        if A.AutoFarm then
            A.AutoFarm.Stop()
        end
    end
end

function A.Unique.ToggleKillAura()
    A.Unique.KeybindState.F2 = not A.Unique.KeybindState.F2
    A.Unique.SessionStats.F2Toggles = A.Unique.SessionStats.F2Toggles + 1
    A.Unique.SessionStats.TotalKeybindsPressed = A.Unique.SessionStats.TotalKeybindsPressed + 1
    if A.Unique.KeybindState.F2 then
        A.Notify("Keybind F2", "Kill Aura: ON", 2)
        if A.KillAura then
            A.KillAura.Start()
        end
    else
        A.Notify("Keybind F2", "Kill Aura: OFF", 2)
        if A.KillAura then
            A.KillAura.Stop()
        end
    end
end

function A.Unique.ToggleESP()
    A.Unique.KeybindState.F3 = not A.Unique.KeybindState.F3
    A.Unique.SessionStats.F3Toggles = A.Unique.SessionStats.F3Toggles + 1
    A.Unique.SessionStats.TotalKeybindsPressed = A.Unique.SessionStats.TotalKeybindsPressed + 1
    if A.Unique.KeybindState.F3 then
        A.Notify("Keybind F3", "ESP: ON", 2)
        if A.ESP then
            A.ESP.Start()
        end
    else
        A.Notify("Keybind F3", "ESP: OFF", 2)
        if A.ESP then
            A.ESP.Stop()
        end
    end
end

function A.Unique.ToggleFly()
    A.Unique.KeybindState.F4 = not A.Unique.KeybindState.F4
    A.Unique.SessionStats.F4Toggles = A.Unique.SessionStats.F4Toggles + 1
    A.Unique.SessionStats.TotalKeybindsPressed = A.Unique.SessionStats.TotalKeybindsPressed + 1
    if A.Unique.KeybindState.F4 then
        A.Notify("Keybind F4", "Fly: ON", 2)
        if A.Fly then
            A.Fly.Start()
        end
    else
        A.Notify("Keybind F4", "Fly: OFF", 2)
        if A.Fly then
            A.Fly.Stop()
        end
    end
end

function A.Unique.ToggleNoclip()
    A.Unique.KeybindState.F5 = not A.Unique.KeybindState.F5
    A.Unique.SessionStats.F5Toggles = A.Unique.SessionStats.F5Toggles + 1
    A.Unique.SessionStats.TotalKeybindsPressed = A.Unique.SessionStats.TotalKeybindsPressed + 1
    if A.Unique.KeybindState.F5 then
        A.Notify("Keybind F5", "Noclip: ON", 2)
        if A.Noclip then
            A.Noclip.Start()
        end
    else
        A.Notify("Keybind F5", "Noclip: OFF", 2)
        if A.Noclip then
            A.Noclip.Stop()
        end
    end
end

function A.Unique.ToggleBossFarm()
    A.Unique.KeybindState.F6 = not A.Unique.KeybindState.F6
    A.Unique.SessionStats.F6Toggles = A.Unique.SessionStats.F6Toggles + 1
    A.Unique.SessionStats.TotalKeybindsPressed = A.Unique.SessionStats.TotalKeybindsPressed + 1
    if A.Unique.KeybindState.F6 then
        A.Notify("Keybind F6", "Boss Farm: ON", 2)
        if A.BossFarm then
            A.BossFarm.Start()
        end
    else
        A.Notify("Keybind F6", "Boss Farm: OFF", 2)
        if A.BossFarm then
            A.BossFarm.Stop()
        end
    end
end

function A.Unique.ToggleSeaBeast()
    A.Unique.KeybindState.F7 = not A.Unique.KeybindState.F7
    A.Unique.SessionStats.F7Toggles = A.Unique.SessionStats.F7Toggles + 1
    A.Unique.SessionStats.TotalKeybindsPressed = A.Unique.SessionStats.TotalKeybindsPressed + 1
    if A.Unique.KeybindState.F7 then
        A.Notify("Keybind F7", "Sea Beast: ON", 2)
        if A.SeaBeast then
            A.SeaBeast.Start()
        end
    else
        A.Notify("Keybind F7", "Sea Beast: OFF", 2)
        if A.SeaBeast then
            A.SeaBeast.Stop()
        end
    end
end

function A.Unique.ToggleBounty()
    A.Unique.KeybindState.F8 = not A.Unique.KeybindState.F8
    A.Unique.SessionStats.F8Toggles = A.Unique.SessionStats.F8Toggles + 1
    A.Unique.SessionStats.TotalKeybindsPressed = A.Unique.SessionStats.TotalKeybindsPressed + 1
    if A.Unique.KeybindState.F8 then
        A.Notify("Keybind F8", "Bounty Farm: ON", 2)
        if A.BountyFarm then
            A.BountyFarm.Start()
        end
    else
        A.Notify("Keybind F8", "Bounty Farm: OFF", 2)
        if A.BountyFarm then
            A.BountyFarm.Stop()
        end
    end
end

function A.Unique.ToggleCDK()
    A.Unique.KeybindState.F9 = not A.Unique.KeybindState.F9
    A.Unique.SessionStats.F9Toggles = A.Unique.SessionStats.F9Toggles + 1
    A.Unique.SessionStats.TotalKeybindsPressed = A.Unique.SessionStats.TotalKeybindsPressed + 1
    if A.Unique.KeybindState.F9 then
        A.Notify("Keybind F9", "CDK Farm: ON", 2)
        if A.CDK then
            A.CDK.Start()
        end
    else
        A.Notify("Keybind F9", "CDK Farm: OFF", 2)
        if A.CDK then
            A.CDK.Stop()
        end
    end
end

function A.Unique.ToggleAllESP()
    A.Unique.KeybindState.F10 = not A.Unique.KeybindState.F10
    A.Unique.SessionStats.F10Toggles = A.Unique.SessionStats.F10Toggles + 1
    A.Unique.SessionStats.TotalKeybindsPressed = A.Unique.SessionStats.TotalKeybindsPressed + 1
    if A.Unique.KeybindState.F10 then
        A.Notify("Keybind F10", "All ESP: ON", 2)
        if A.ESP then
            A.ESP.Start()
        end
    else
        A.Notify("Keybind F10", "All ESP: OFF", 2)
        if A.ESP then
            A.ESP.Stop()
        end
    end
end

function A.Unique.ToggleUI()
    A.Unique.KeybindState.Insert = not A.Unique.KeybindState.Insert
    A.Unique.SessionStats.InsertToggles = A.Unique.SessionStats.InsertToggles + 1
    A.Unique.SessionStats.TotalKeybindsPressed = A.Unique.SessionStats.TotalKeybindsPressed + 1
    pcall(function()
        local gui = A.LP:FindFirstChild("PlayerGui")
        if gui then
            local apexGui = gui:FindFirstChild("ApexHub") or gui:FindFirstChild("ApexHubv13")
            if apexGui then
                apexGui.Enabled = not apexGui.Enabled
                if apexGui.Enabled then
                    A.Notify("Keybind Insert", "UI: SHOWN", 2)
                else
                    A.Notify("Keybind Insert", "UI: HIDDEN", 2)
                end
            end
        end
    end)
end

function A.Unique.SetupKeybinds()
    if A.Unique.KeybindsActive then return end
    A.Unique.KeybindsActive = true
    SetupKeybind(Enum.KeyCode.F1, function() A.Unique.ToggleAutoFarm() end)
    SetupKeybind(Enum.KeyCode.F2, function() A.Unique.ToggleKillAura() end)
    SetupKeybind(Enum.KeyCode.F3, function() A.Unique.ToggleESP() end)
    SetupKeybind(Enum.KeyCode.F4, function() A.Unique.ToggleFly() end)
    SetupKeybind(Enum.KeyCode.F5, function() A.Unique.ToggleNoclip() end)
    SetupKeybind(Enum.KeyCode.F6, function() A.Unique.ToggleBossFarm() end)
    SetupKeybind(Enum.KeyCode.F7, function() A.Unique.ToggleSeaBeast() end)
    SetupKeybind(Enum.KeyCode.F8, function() A.Unique.ToggleBounty() end)
    SetupKeybind(Enum.KeyCode.F9, function() A.Unique.ToggleCDK() end)
    SetupKeybind(Enum.KeyCode.F10, function() A.Unique.ToggleAllESP() end)
    SetupKeybind(Enum.KeyCode.Insert, function() A.Unique.ToggleUI() end)
    A.Notify("Keybinds", "All keybinds activated!", 3)
end

function A.Unique.StealthMode()
    if not A.Unique.Active then return end
    A.Unique.StealthActive = true
    A.Unique.SessionStats.StealthActivations = A.Unique.SessionStats.StealthActivations + 1
    spawn(function()
        while A.Unique.Active and A.Unique.StealthActive do
            pcall(function()
                local char = A.Char()
                if char then
                    if A.Unique.StealthSettings.HideName then
                        local head = char:FindFirstChild("Head")
                        if head then
                            local billboard = head:FindFirstChildOfClass("BillboardGui")
                            if billboard then
                                billboard.Enabled = false
                            end
                            local nameTag = head:FindFirstChild("NameTag")
                            if nameTag then
                                nameTag.Visible = false
                            end
                        end
                    end
                    if A.Unique.StealthSettings.HideEffects then
                        for _, child in pairs(char:GetDescendants()) do
                            if child:IsA("ParticleEmitter") or child:IsA("Trail") or child:IsA("Beam") then
                                child.Enabled = false
                            end
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end

function A.Unique.StopStealth()
    A.Unique.StealthActive = false
end

function A.Unique.AutoTeamSwitch()
    if not A.Unique.Active then return end
    spawn(function()
        while A.Unique.Active do
            pcall(function()
                local success, currentTeam = pcall(function()
                    return A.CommF("getTeam")
                end)
                if success and currentTeam then
                    local oppositeTeam = currentTeam == "Marines" and "Pirates" or "Marines"
                    local myLevel = A.Lv()
                    local targetLevel = 0
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= A.LP then
                            local playerLevel = player:FindFirstChild("Level") and player.Level.Value or 0
                            if playerLevel > targetLevel then
                                targetLevel = playerLevel
                            end
                        end
                    end
                    if targetLevel > myLevel + 200 then
                        pcall(function()
                            A.CommF("setTeam", oppositeTeam)
                            A.Unique.SessionStats.TeamSwitches = A.Unique.SessionStats.TeamSwitches + 1
                        end)
                    end
                end
            end)
            task.wait(30)
        end
    end)
end

function A.Unique.AutoInventory()
    if not A.Unique.Active then return end
    spawn(function()
        while A.Unique.Active do
            pcall(function()
                pcall(function()
                    local inventory = A.CommF("getInventory")
                    if inventory then
                        for _, item in ipairs(inventory) do
                            if item.Type == "Material" and item.Count > 100 then
                                A.CommF("sellItem", item.Name, math.floor(item.Count / 2))
                                A.Unique.SessionStats.ItemsManaged = A.Unique.SessionStats.ItemsManaged + 1
                            end
                        end
                    end
                end)
            end)
            task.wait(60)
        end
    end)
end

function A.Unique.AutoBuffManager()
    if not A.Unique.Active then return end
    spawn(function()
        while A.Unique.Active do
            pcall(function()
                local char = A.Char()
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        local healthPercent = (hum.Health / hum.MaxHealth) * 100
                        if healthPercent < 50 then
                            pcall(function()
                                A.CommF("useHealItem")
                            end)
                        end
                    end
                    local buffs = {"SpeedBoost", "DamageBoost", "DefenseBoost"}
                    for _, buff in ipairs(buffs) do
                        pcall(function()
                            local hasBuff = A.CommF("hasBuff", buff)
                            if not hasBuff then
                                A.CommF("activateBuff", buff)
                                A.Unique.SessionStats.BuffsManaged = A.Unique.SessionStats.BuffsManaged + 1
                            end
                        end)
                    end
                end
            end)
            task.wait(30)
        end
    end)
end

function A.Unique.AutoBossTimer()
    if not A.Unique.Active then return end
    spawn(function()
        while A.Unique.Active do
            pcall(function()
                for bossName, data in pairs(A.Unique.BossTimers) do
                    if data.LastKill > 0 then
                        local timeSinceKill = tick() - data.LastKill
                        if timeSinceKill >= data.RespawnTime then
                            local boss = workspace:FindFirstChild(bossName, true)
                            if boss then
                                local hrp = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("Handle")
                                if hrp then
                                    data.SpawnTime = tick()
                                    A.Unique.SessionStats.BossTimersTracked = A.Unique.SessionStats.BossTimersTracked + 1
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(10)
        end
    end)
end

function A.Unique.AutoPvPRankTracker()
    if not A.Unique.Active then return end
    spawn(function()
        while A.Unique.Active do
            pcall(function()
                local success, bounty = pcall(function()
                    return A.CommF("getBounty")
                end)
                if success and bounty then
                    local oldBounty = A.Unique.ProgressData.Bounty or 0
                    if bounty > oldBounty then
                        A.Unique.ProgressData.Bounty = bounty
                        A.Unique.SessionStats.PvPMatches = A.Unique.SessionStats.PvPMatches + 1
                    end
                end
            end)
            task.wait(5)
        end
    end)
end

function A.Unique.FruitValueCheck(value)
    if not value then
        value = 0
        pcall(function()
            local success, fruit = pcall(function()
                return A.CommF("getCurrentFruit")
            end)
            if success and fruit then
                for rarity, data in pairs(A.Unique.FruitValueData) do
                    for _, fruitName in ipairs(data.Fruits) do
                        if fruit == fruitName then
                            value = math.random(data.Min, data.Max)
                            break
                        end
                    end
                end
            end
        end)
    end
    A.Unique.SessionStats.FruitChecks = A.Unique.SessionStats.FruitChecks + 1
    local estimatedValue = value
    local tradeValue = value * 1.2
    local marketValue = value * 0.8
    return {
        FruitValue = estimatedValue,
        TradeValue = tradeValue,
        MarketValue = marketValue,
        FormattedValue = FormatNumber(estimatedValue),
        FormattedTrade = FormatNumber(tradeValue),
        FormattedMarket = FormatNumber(marketValue)
    }
end

function A.Unique.BossTimerDisplay()
    local timers = {}
    for bossName, data in pairs(A.Unique.BossTimers) do
        local timeSinceKill = data.LastKill > 0 and (tick() - data.LastKill) or 0
        local timeUntilSpawn = math.max(0, data.RespawnTime - timeSinceKill)
        local isSpawned = timeUntilSpawn <= 0
        table.insert(timers, {
            Name = bossName,
            TimeUntilSpawn = timeUntilSpawn,
            IsSpawned = isSpawned,
            FormattedTime = FormatTime(timeUntilSpawn),
            Position = data.Position
        })
    end
    table.sort(timers, function(a, b)
        return a.TimeUntilSpawn < b.TimeUntilSpawn
    end)
    return timers
end

function A.Unique.ComboPresetManager(action, name, combo)
    if action == "save" and name and combo then
        A.Unique.ComboPresets[name] = combo
        A.Unique.SessionStats.CombosSaved = A.Unique.SessionStats.CombosSaved + 1
        pcall(function()
            if not isfolder("ApexHub") then makefolder("ApexHub") end
            if not isfolder("ApexHub/UniquePresets") then makefolder("ApexHub/UniquePresets") end
            writefile("ApexHub/UniquePresets/" .. name .. ".json", game:GetService("HttpService"):JSONEncode(combo))
        end)
        return true
    elseif action == "load" and name then
        if A.Unique.ComboPresets[name] then
            return A.Unique.ComboPresets[name]
        end
        local success, data = pcall(function()
            return readfile("ApexHub/UniquePresets/" .. name .. ".json")
        end)
        if success and data then
            local decoded = game:GetService("HttpService"):JSONDecode(data)
            A.Unique.ComboPresets[name] = decoded
            return decoded
        end
        return nil
    elseif action == "delete" and name then
        A.Unique.ComboPresets[name] = nil
        pcall(function()
            delfile("ApexHub/UniquePresets/" .. name .. ".json")
        end)
        return true
    elseif action == "list" then
        local names = {}
        for n, _ in pairs(A.Unique.ComboPresets) do
            table.insert(names, n)
        end
        return names
    end
    return nil
end

function A.Unique.AIPrediction(target)
    if not target then return nil end
    A.Unique.SessionStats.AIPredictions = A.Unique.SessionStats.AIPredictions + 1
    local targetParts = nil
    pcall(function()
        if target.Character then
            targetParts = {
                Root = target.Character:FindFirstChild("HumanoidRootPart"),
                Head = target.Character:FindFirstChild("Head"),
                Hum = target.Character:FindFirstChild("Humanoid")
            }
        end
    end)
    if not targetParts or not targetParts.Root then return nil end
    local pos = targetParts.Root.Position
    local vel = targetParts.Root.Velocity
    local health = targetParts.Hum and (targetParts.Hum.Health / targetParts.Hum.MaxHealth * 100) or 100
    local myHRP = A.HRP()
    if not myHRP then return nil end
    local dist = (myHRP.Position - pos).Magnitude
    local timeToReach = dist / 100
    local predictedPos = pos + vel * timeToReach
    local predictedHealth = health - (timeToReach * 10)
    local movementPattern = "Unknown"
    local speed = vel.Magnitude
    if speed < 5 then
        movementPattern = "Stationary"
    elseif speed < 20 then
        movementPattern = "Walking"
    elseif speed < 50 then
        movementPattern = "Running"
    else
        movementPattern = "Dashing"
    end
    local predictedNextMove = "Unknown"
    if movementPattern == "Stationary" then
        predictedNextMove = "Will likely stay or start moving"
    elseif movementPattern == "Walking" then
        predictedNextMove = "May continue or speed up"
    elseif movementPattern == "Running" then
        predictedNextMove = "Likely fleeing or engaging"
    elseif movementPattern == "Dashing" then
        predictedNextMove = "Aggressive or escaping"
    end
    return {
        CurrentPosition = pos,
        PredictedPosition = predictedPos,
        Velocity = vel,
        Speed = speed,
        Health = health,
        PredictedHealth = math.max(0, predictedHealth),
        Distance = dist,
        TimeToReach = timeToReach,
        MovementPattern = movementPattern,
        PredictedNextMove = predictedNextMove,
        ThreatLevel = (100 - health) + (dist < 20 and 50 or 0) + (speed > 30 and 30 or 0),
        BestEngageAngle = math.atan2(vel.Z, vel.X),
        ShouldBlock = health < 30,
        ShouldHeal = health < 20,
        OptimalRange = speed > 30 and 30 or 15
    }
end

function A.Unique.CombatAnalysis()
    if not A.Unique.Active then return nil end
    A.Unique.SessionStats.CombatAnalyses = A.Unique.SessionStats.CombatAnalyses + 1
    local stats = {
        PlayersInRange = 0,
        AverageHealth = 100,
        HighestThreat = nil,
        HighestThreatLevel = 0,
        RecommendedAction = "None",
        CombatScore = 0
    }
    local totalHealth = 0
    local playerCount = 0
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= A.LP then
            local parts = nil
            pcall(function()
                if player.Character then
                    parts = {
                        Root = player.Character:FindFirstChild("HumanoidRootPart"),
                        Hum = player.Character:FindFirstChild("Humanoid")
                    }
                end
            end)
            if parts and parts.Root and parts.Hum then
                local myHRP = A.HRP()
                if myHRP then
                    local dist = (myHRP.Position - parts.Root.Position).Magnitude
                    if dist < 300 then
                        stats.PlayersInRange = stats.PlayersInRange + 1
                        local health = (parts.Hum.Health / parts.Hum.MaxHealth) * 100
                        totalHealth = totalHealth + health
                        playerCount = playerCount + 1
                        local threat = (100 - health) + (dist < 20 and 50 or 0)
                        if threat > stats.HighestThreatLevel then
                            stats.HighestThreatLevel = threat
                            stats.HighestThreat = player
                        end
                    end
                end
            end
        end
    end
    if playerCount > 0 then
        stats.AverageHealth = totalHealth / playerCount
    end
    local myHealth = 100
    pcall(function()
        local hum = A.Hum()
        if hum then
            myHealth = (hum.Health / hum.MaxHealth) * 100
        end
    end)
    stats.CombatScore = (100 - myHealth) + (stats.PlayersInRange * 10) + stats.HighestThreatLevel
    if myHealth < 20 then
        stats.RecommendedAction = "Retreat and Heal"
    elseif myHealth < 50 and stats.PlayersInRange > 2 then
        stats.RecommendedAction = "Defensive Mode"
    elseif stats.HighestThreatLevel > 80 then
        stats.RecommendedAction = "Engage Highest Threat"
    elseif stats.PlayersInRange == 0 then
        stats.RecommendedAction = "Safe to Farm"
    else
        stats.RecommendedAction = "Balanced Combat"
    end
    return stats
end

function A.Unique.FarmingOptimization()
    if not A.Unique.Active then return nil end
    A.Unique.SessionStats.FarmsOptimized = A.Unique.SessionStats.FarmsOptimized + 1
    local level = A.Lv()
    local currentSea = 1
    if level >= 1500 then
        currentSea = 3
    elseif level >= 700 then
        currentSea = 2
    end
    local optimalFarmingSpots = {
        [1] = {
            {Name = "Bandits", Level = 5, Position = CFrame.new(1060, 16, 1540), XP = 100},
            {Name = "Monkeys", Level = 15, Position = CFrame.new(-1580, 30, 360), XP = 200},
            {Name = "Gorillas", Level = 25, Position = CFrame.new(-1600, 50, 380), XP = 350},
            {Name = "Pirates", Level = 35, Position = CFrame.new(-1200, 20, -800), XP = 500},
            {Name = "Brutes", Level = 55, Position = CFrame.new(-400, 30, -2600), XP = 800},
            {Name = "Desert Bandits", Level = 65, Position = CFrame.new(1600, 12, -600), XP = 1000},
            {Name = "Snow Bandits", Level = 90, Position = CFrame.new(600, 40, -5200), XP = 1500},
            {Name = "Vice Admiral", Level = 130, Position = CFrame.new(-4800, 20, -1800), XP = 2500},
            {Name = "Sky Bandits", Level = 190, Position = CFrame.new(-4900, 320, -2300), XP = 4000},
            {Name = "Prisoners", Level = 230, Position = CFrame.new(5300, 20, 4200), XP = 5000},
            {Name = "Beast Pirates", Level = 300, Position = CFrame.new(-1300, 10, 1150), XP = 7000},
            {Name = "Dragon Crew", Level = 350, Position = CFrame.new(6350, 25, 1050), XP = 9000},
            {Name = "Admiral", Level = 475, Position = CFrame.new(-4650, 20, -1900), XP = 12000}
        },
        [2] = {
            {Name = "Raiders", Level = 700, Position = CFrame.new(-2800, 30, 2300), XP = 15000},
            {Name = "Mercenaries", Level = 750, Position = CFrame.new(-2750, 30, 2350), XP = 18000},
            {Name = "Swamp Pirates", Level = 800, Position = CFrame.new(-3200, 30, -700), XP = 22000},
            {Name = "Jungle Pirates", Level = 950, Position = CFrame.new(-3350, 30, -850), XP = 30000},
            {Name = "Musketeer Pirates", Level = 1000, Position = CFrame.new(-3400, 30, -900), XP = 35000},
            {Name = "Diabolic Pirates", Level = 1100, Position = CFrame.new(-3500, 30, -1000), XP = 45000},
            {Name = "Cyborgs", Level = 1350, Position = CFrame.new(-3750, 30, -1250), XP = 65000},
            {Name = "Fishman Lords", Level = 1450, Position = CFrame.new(-3850, 30, -1350), XP = 80000}
        },
        [3] = {
            {Name = "Pirate Millionaires", Level = 1500, Position = CFrame.new(-600, 20, 500), XP = 100000},
            {Name = "Dragon Crew Warriors", Level = 1600, Position = CFrame.new(6300, 25, 1000), XP = 120000},
            {Name = "Marine Commodores", Level = 1800, Position = CFrame.new(-700, 20, 600), XP = 160000},
            {Name = "Island Champions", Level = 1950, Position = CFrame.new(5500, 600, 1700), XP = 200000},
            {Name = "Elite Troops", Level = 2100, Position = CFrame.new(-900, 20, 800), XP = 250000},
            {Name = "Commanders", Level = 2300, Position = CFrame.new(-1100, 20, 1000), XP = 320000},
            {Name = "Supremes", Level = 2550, Position = CFrame.new(-1350, 20, 1250), XP = 400000}
        }
    }
    local spots = optimalFarmingSpots[currentSea] or optimalFarmingSpots[1]
    local bestSpot = nil
    local bestEfficiency = 0
    for _, spot in ipairs(spots) do
        if level >= spot.Level then
            local efficiency = spot.XP / math.max(1, math.abs(level - spot.Level) + 1)
            if efficiency > bestEfficiency then
                bestEfficiency = efficiency
                bestSpot = spot
            end
        end
    end
    return {
        CurrentSea = currentSea,
        RecommendedSpot = bestSpot,
        AllSpots = spots,
        Level = level,
        Efficiency = bestEfficiency
    }
end

function A.Unique.ProgressTracker()
    if not A.Unique.Active then return nil end
    A.Unique.SessionStats.ProgressTracked = A.Unique.SessionStats.ProgressTracked + 1
    local level = A.Lv()
    local bounty = 0
    pcall(function()
        local success, b = pcall(function()
            return A.CommF("getBounty")
        end)
        if success and b then bounty = b end
    end)
    local beli = 0
    pcall(function()
        local success, b = pcall(function()
            return A.CommF("getBeli")
        end)
        if success and b then beli = b end
    end)
    local fragments = 0
    pcall(function()
        local success, f = pcall(function()
            return A.CommF("getFragmentCount")
        end)
        if success and f then fragments = f end
    end)
    local race = "Unknown"
    pcall(function()
        local success, r = pcall(function()
            return A.CommF("getRace")
        end)
        if success and r then race = r end
    end)
    A.Unique.ProgressData = {
        Level = level,
        Bounty = bounty,
        Beli = beli,
        Fragments = fragments,
        Race = race,
        LastUpdate = tick()
    }
    local levelProgress = (level / 2550) * 100
    local seaProgress = 0
    if level >= 1500 then
        seaProgress = ((level - 1500) / 1050) * 100
    elseif level >= 700 then
        seaProgress = ((level - 700) / 800) * 100
    else
        seaProgress = (level / 700) * 100
    end
    return {
        Level = level,
        LevelProgress = levelProgress,
        SeaProgress = seaProgress,
        Bounty = bounty,
        Beli = beli,
        Fragments = fragments,
        Race = race,
        FormattedBounty = FormatNumber(bounty),
        FormattedBeli = FormatNumber(beli),
        FormattedFragments = FormatNumber(fragments),
        EstimatedPlayTime = FormatTime(tick() - A.Unique.SessionStats.SessionStart)
    }
end

function A.Unique.AchievementTracker()
    if not A.Unique.Active then return nil end
    A.Unique.SessionStats.AchievementsTracked = A.Unique.SessionStats.AchievementsTracked + 1
    local level = A.Lv()
    local bounty = 0
    pcall(function()
        local success, b = pcall(function()
            return A.CommF("getBounty")
        end)
        if success and b then bounty = b end
    end)
    if level >= 2550 then
        A.Unique.AchievementData.MaxLevel = true
    end
    if bounty >= 10000000 then
        A.Unique.AchievementData.MaxBounty = true
    end
    local playTime = tick() - A.Unique.SessionStats.SessionStart
    if playTime >= 86400 then
        A.Unique.AchievementData.Played24Hours = true
    end
    if playTime >= 360000 then
        A.Unique.AchievementData.Played100Hours = true
    end
    local completed = 0
    local total = 0
    for _, v in pairs(A.Unique.AchievementData) do
        total = total + 1
        if v then
            completed = completed + 1
        end
    end
    return {
        Achievements = A.Unique.AchievementData,
        Completed = completed,
        Total = total,
        CompletionPercent = total > 0 and (completed / total * 100) or 0
    }
end

function A.Unique.SmartNotification(context, data)
    if not context then return end
    A.Unique.SessionStats.NotificationsSent = A.Unique.SessionStats.NotificationsSent + 1
    local title = "Apex Hub"
    local text = ""
    local duration = 3
    if context == "BossSpawned" then
        title = "Boss Alert"
        text = data.Name .. " has spawned!"
        duration = 5
    elseif context == "LowHealth" then
        title = "Health Warning"
        text = "Health critical: " .. tostring(math.floor(data.Percent)) .. "%"
        duration = 3
    elseif context == "EventActive" then
        title = "Event Alert"
        text = data.Name .. " is active!"
        duration = 5
    elseif context == "PvPEnemy" then
        title = "PvP Alert"
        text = data.Name .. " nearby! Threat: " .. tostring(math.floor(data.Threat))
        duration = 4
    elseif context == "FruitValue" then
        title = "Fruit Value"
        text = data.Name .. ": " .. FormatNumber(data.Value)
        duration = 3
    elseif context == "Progress" then
        title = "Progress Update"
        text = data.Message
        duration = 3
    elseif context == "Achievement" then
        title = "Achievement Unlocked!"
        text = data.Name
        duration = 5
    end
    A.Notify(title, text, duration)
end

function A.Unique.AutoSocial()
    if not A.Unique.Active then return end
    spawn(function()
        while A.Unique.Active do
            pcall(function()
                local chance = math.random(1, 100)
                if chance <= 5 then
                    local messages = {
                        "GG!",
                        "Nice fight!",
                        "Good luck!",
                        "Thanks for the help!",
                        "Anyone want to team?",
                        "LF party for raid",
                        "Selling fruits",
                        "Any trades?"
                    }
                    local message = messages[math.random(1, #messages)]
                    pcall(function()
                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
                    end)
                    A.Unique.SessionStats.SocialActions = A.Unique.SessionStats.SocialActions + 1
                end
            end)
            task.wait(60)
        end
    end)
end

function A.Unique.PerformanceMonitor()
    if not A.Unique.Active then return nil end
    A.Unique.SessionStats.FPS = GetFPS()
    A.Unique.SessionStats.Ping = GetServerPing()
    A.Unique.SessionStats.Memory = GetMemoryUsage()
    return {
        FPS = A.Unique.SessionStats.FPS,
        Ping = A.Unique.SessionStats.Ping,
        Memory = A.Unique.SessionStats.Memory,
        FormattedMemory = string.format("%.1f MB", A.Unique.SessionStats.Memory),
        PerformanceScore = math.clamp(100 - (A.Unique.SessionStats.Ping / 10) - (math.max(0, 60 - A.Unique.SessionStats.FPS) * 2), 0, 100),
        Status = A.Unique.SessionStats.FPS > 50 and A.Unique.SessionStats.Ping < 100 and "Good" or "Poor"
    }
end

function A.Unique.SessionStatistics()
    local stats = A.Unique.SessionStats
    local uptime = tick() - stats.SessionStart
    return {
        SessionUptime = FormatTime(uptime),
        TotalKeybindsPressed = stats.TotalKeybindsPressed,
        F1Toggles = stats.F1Toggles,
        F2Toggles = stats.F2Toggles,
        F3Toggles = stats.F3Toggles,
        F4Toggles = stats.F4Toggles,
        F5Toggles = stats.F5Toggles,
        F6Toggles = stats.F6Toggles,
        F7Toggles = stats.F7Toggles,
        F8Toggles = stats.F8Toggles,
        F9Toggles = stats.F9Toggles,
        F10Toggles = stats.F10Toggles,
        InsertToggles = stats.InsertToggles,
        StealthActivations = stats.StealthActivations,
        TeamSwitches = stats.TeamSwitches,
        ItemsManaged = stats.ItemsManaged,
        BuffsManaged = stats.BuffsManaged,
        BossTimersTracked = stats.BossTimersTracked,
        PvPMatches = stats.PvPMatches,
        FruitChecks = stats.FruitChecks,
        ServerHops = stats.ServerHops,
        ItemsSold = stats.ItemsSold,
        RacesUnlocked = stats.RacesUnlocked,
        CombosSaved = stats.CombosSaved,
        AIPredictions = stats.AIPredictions,
        CombatAnalyses = stats.CombatAnalyses,
        FarmsOptimized = stats.FarmsOptimized,
        ProgressTracked = stats.ProgressTracked,
        AchievementsTracked = stats.AchievementsTracked,
        NotificationsSent = stats.NotificationsSent,
        SocialActions = stats.SocialActions,
        FPS = stats.FPS,
        Ping = stats.Ping,
        Memory = stats.Memory
    }
end

function A.Unique.MainLoop()
    while A.Unique.Active do
        pcall(function()
            A.Unique.PerformanceMonitor()
            A.Unique.ProgressTracker()
            local combatAnalysis = A.Unique.CombatAnalysis()
            if combatAnalysis and combatAnalysis.HighestThreat then
                local threat = combatAnalysis.HighestThreat
                local threatLevel = combatAnalysis.HighestThreatLevel
                if threatLevel > 80 then
                    A.Unique.SmartNotification("PvPEnemy", {
                        Name = threat.Name,
                        Threat = threatLevel
                    })
                end
            end
            local timers = A.Unique.BossTimerDisplay()
            for _, timer in ipairs(timers) do
                if timer.IsSpawned then
                    A.Unique.SmartNotification("BossSpawned", {Name = timer.Name})
                end
            end
        end)
        task.wait(5)
    end
end

function A.Unique.Start()
    if A.Unique.Active then return end
    A.Unique.Active = true
    A.Unique.SessionStats = {
        F1Toggles = 0,
        F2Toggles = 0,
        F3Toggles = 0,
        F4Toggles = 0,
        F5Toggles = 0,
        F6Toggles = 0,
        F7Toggles = 0,
        F8Toggles = 0,
        F9Toggles = 0,
        F10Toggles = 0,
        InsertToggles = 0,
        TotalKeybindsPressed = 0,
        SessionStart = tick(),
        StealthActivations = 0,
        TeamSwitches = 0,
        ItemsManaged = 0,
        BuffsManaged = 0,
        BossTimersTracked = 0,
        PvPMatches = 0,
        FruitChecks = 0,
        ServerHops = 0,
        ItemsSold = 0,
        RacesUnlocked = 0,
        CombosSaved = 0,
        AIPredictions = 0,
        CombatAnalyses = 0,
        FarmsOptimized = 0,
        ProgressTracked = 0,
        AchievementsTracked = 0,
        NotificationsSent = 0,
        SocialActions = 0,
        FPS = 60,
        Ping = 0,
        Memory = 0
    }
    A.Unique.SetupKeybinds()
    A.Unique.StealthMode()
    A.Unique.AutoTeamSwitch()
    A.Unique.AutoInventory()
    A.Unique.AutoBuffManager()
    A.Unique.AutoBossTimer()
    A.Unique.AutoPvPRankTracker()
    A.Unique.AutoSocial()
    A.Notify("Unique Features", "All unique features activated!", 5)
    task.spawn(function()
        A.Unique.MainLoop()
    end)
end

function A.Unique.Stop()
    A.Unique.Active = false
    A.Unique.KeybindsActive = false
    A.Unique.StealthActive = false
    A.Unique.StopStealth()
    A.Notify("Unique Features", "All unique features deactivated!", 3)
end

function A.Unique.SetMaster(v)
    A.F.MasterMode = v
end

function A.Unique.SetKeybinds(v)
    if v then A.Unique.SetupKeybinds() end
end

function A.Unique.SetStealth(v)
    if v then A.Unique.StealthMode() end
end

A.Register("unique", A.Unique)
