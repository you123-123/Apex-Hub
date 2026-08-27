local A = _G.Apex
local W = A.UI.CreateWindow({Name = "APEX HUB v13.0", Size = UDim2.new(0, 620, 0, 520)})

local StatsKills = 0
local StatsQuests = 0
local StatsXP = 0
local RaidCount = 0
local RaidFragments = 0
local BountyVal = 0
local FishCaught = 0
local TradeCount = 0
local ESPCount = 0
local OpenCount = 0
local MegaKills = 0
local MegaQuests = 0
local CDKYama = 0
local CDKTushita = 0
local CDKProgress = 0
local PilotStatus = "Idle"
local CurrentIsland = "Unknown"
local CurrentFruit = "None"
local CurrentRace = "Unknown"

-- TAB 1: AutoFarm
do
    local Tab = W:CreateTab({Name = "AutoFarm", Color = Color3.fromRGB(0, 255, 0), Icon = "⚔️"})
    local Section = Tab:AddSection("Core Farm")
    Tab:AddToggle({Name = "AutoFarm", Flag = "AutoFarm", Default = false, Callback = function(v)
        A.F.AutoFarm = v
        if A.Farm then if v then A.Farm:Start() else A.Farm:Stop() end end
        A.Notify("AutoFarm", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "AutoFarmChest", Flag = "AutoFarmChest", Default = false, Callback = function(v)
        A.F.AutoFarmChest = v
        if A.Farm then if v then A.Farm:ChestFarm(true) else A.Farm:ChestFarm(false) end end
    end})
    Tab:AddToggle({Name = "AutoClick", Flag = "AutoClick", Default = false, Callback = function(v)
        A.F.AutoClick = v
        if v then
            spawn(function()
                while A.F.AutoClick do
                    pcall(function()
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
                    end)
                    wait(A.C.ClickDelay or 0.02)
                end
            end)
        end
    end})
    Tab:AddToggle({Name = "AutoHaki", Flag = "AutoHaki", Default = false, Callback = function(v)
        A.F.AutoHaki = v
        if A.Farm then if v then A.Farm:AutoHaki(true) else A.Farm:AutoHaki(false) end end
    end})
    Tab:AddToggle({Name = "AutoBuso", Flag = "AutoBuso", Default = false, Callback = function(v)
        A.F.AutoBuso = v
        if A.Farm then if v then A.Farm:AutoBuso(true) else A.Farm:AutoBuso(false) end end
    end})
    Tab:AddToggle({Name = "AutoKen", Flag = "AutoKen", Default = false, Callback = function(v)
        A.F.AutoKen = v
        if A.Farm then if v then A.Farm:AutoKen(true) else A.Farm:AutoKen(false) end end
    end})
    Tab:AddToggle({Name = "AutoSoru", Flag = "AutoSoru", Default = false, Callback = function(v)
        A.F.AutoSoru = v
        if A.Farm then if v then A.Farm:AutoSoru(true) else A.Farm:AutoSoru(false) end end
    end})
    Tab:AddToggle({Name = "AutoGeppo", Flag = "AutoGeppo", Default = false, Callback = function(v)
        A.F.AutoGeppo = v
        if A.Farm then if v then A.Farm:AutoGeppo(true) else A.Farm:AutoGeppo(false) end end
    end})
    Tab:AddToggle({Name = "AutoQuest", Flag = "AutoQuest", Default = false, Callback = function(v)
        A.F.AutoQuest = v
        if A.Farm then if v then A.Farm:AutoQuest(true) else A.Farm:AutoQuest(false) end end
    end})
    Tab:AddToggle({Name = "AutoStats", Flag = "AutoStats", Default = false, Callback = function(v)
        A.F.AutoStats = v
        if A.Stats then if v then A.Stats:Start() else A.Stats:Stop() end end
    end})
    Tab:AddToggle({Name = "AutoBuyFood", Flag = "AutoBuyFood", Default = false, Callback = function(v)
        A.F.AutoBuyFood = v
    end})
    Tab:AddToggle({Name = "AutoSell", Flag = "AutoSell", Default = false, Callback = function(v)
        A.F.AutoSell = v
    end})
    Tab:AddToggle({Name = "AutoRock", Flag = "AutoRock", Default = false, Callback = function(v)
        A.F.AutoRock = v
    end})
    Tab:AddToggle({Name = "AutoActiveV3", Flag = "AutoActiveV3", Default = false, Callback = function(v)
        A.F.AutoActiveV3 = v
    end})
    Tab:AddToggle({Name = "AutoActiveV4", Flag = "AutoActiveV4", Default = false, Callback = function(v)
        A.F.AutoActiveV4 = v
    end})
    Tab:AddToggle({Name = "AutoActiveV4Full", Flag = "AutoActiveV4Full", Default = false, Callback = function(v)
        A.F.AutoActiveV4Full = v
    end})
    local S2 = Tab:AddSection("Settings")
    Tab:AddSlider({Name = "ClickDelay", Flag = "ClickDelay", Min = 0.01, Max = 0.5, Default = 0.02, Callback = function(v)
        A.C.ClickDelay = v
    end})
    Tab:AddSlider({Name = "FarmRadius", Flag = "FarmRadius", Min = 5, Max = 50, Default = 15, Callback = function(v)
        A.C.FarmRadius = v
    end})
    Tab:AddLabel("Farm Stats: Kills: 0 | Quests: 0 | XP: 0")
end

-- TAB 2: Kill Aura
do
    local Tab = W:CreateTab({Name = "Kill Aura", Color = Color3.fromRGB(255, 0, 0), Icon = "🔴"})
    local Section = Tab:AddSection("Aura Settings")
    Tab:AddToggle({Name = "KillAura", Flag = "KillAura", Default = false, Callback = function(v)
        A.F.KillAura = v
        if A.Combat then if v then A.Combat:StartAura() else A.Combat:StopAura() end end
        A.Notify("KillAura", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "KillAuraMobs", Flag = "KillAuraMobs", Default = false, Callback = function(v)
        A.F.KillAuraMobs = v
    end})
    Tab:AddToggle({Name = "KillAuraPlayers", Flag = "KillAuraPlayers", Default = false, Callback = function(v)
        A.F.KillAuraPlayers = v
    end})
    Tab:AddToggle({Name = "AuraBypass", Flag = "AuraBypass", Default = false, Callback = function(v)
        A.F.AuraBypass = v
    end})
    Tab:AddSlider({Name = "KillAuraRange", Flag = "KillAuraRange", Min = 10, Max = 60, Default = 30, Callback = function(v)
        A.C.KillAuraRange = v
    end})
    Tab:AddDropdown({Name = "ComboMode", Flag = "ComboMode", Options = {"Basic", "Sword", "Fruit", "Super", "Mega", "Ultra"}, Default = "Basic", Callback = function(v)
        A.C.ComboMode = v
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Execute Combo", Callback = function()
        if A.Combat then local target = A.Combat:GetTarget()
        if target then A.Combat:MegaCombo(target) end end
    end})
    Tab:AddButton({Name = "One Shot", Callback = function()
        if A.Combat then local target = A.Combat:GetTarget()
        if target then A.Combat:OneShot(target) end end
    end})
end

-- TAB 3: Boss Farm
do
    local Tab = W:CreateTab({Name = "Boss Farm", Color = Color3.fromRGB(139, 0, 0), Icon = "👹"})
    local Section = Tab:AddSection("Boss Settings")
    Tab:AddToggle({Name = "BossFarm", Flag = "BossFarm", Default = false, Callback = function(v)
        A.F.BossFarm = v
        if A.BossFarm then if v then A.BossFarm:Start() else A.BossFarm:Stop() end end
        A.Notify("BossFarm", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "AutoEliteHunter", Flag = "AutoEliteHunter", Default = false, Callback = function(v)
        A.F.AutoEliteHunter = v
        if A.SpecialQuest then if v then A.SpecialQuest:AutoEliteHunter(true) else A.SpecialQuest:AutoEliteHunter(false) end end
    end})
    Tab:AddToggle({Name = "AutoCakePrince", Flag = "AutoCakePrince", Default = false, Callback = function(v)
        A.F.AutoCakePrince = v
        if A.SpecialQuest then if v then A.SpecialQuest:AutoCakePrince(true) else A.SpecialQuest:AutoCakePrince(false) end end
    end})
    Tab:AddToggle({Name = "AutoDoughKing", Flag = "AutoDoughKing", Default = false, Callback = function(v)
        A.F.AutoDoughKing = v
        if A.SpecialQuest then if v then A.SpecialQuest:AutoDoughKing(true) else A.SpecialQuest:AutoDoughKing(false) end end
    end})
    Tab:AddToggle({Name = "AutoDarkbeard", Flag = "AutoDarkbeard", Default = false, Callback = function(v)
        A.F.AutoDarkbeard = v
        if A.SpecialQuest then if v then A.SpecialQuest:AutoDarkbeard(true) else A.SpecialQuest:AutoDarkbeard(false) end end
    end})
    Tab:AddToggle({Name = "AutoColorAdmin", Flag = "AutoColorAdmin", Default = false, Callback = function(v)
        A.F.AutoColorAdmin = v
    end})
    Tab:AddToggle({Name = "AutoTerrorShark", Flag = "AutoTerrorShark", Default = false, Callback = function(v)
        A.F.AutoTerrorShark = v
        if A.AutoEvents then if v then A.AutoEvents:TriggerTerrorShark(true) else A.AutoEvents:TriggerTerrorShark(false) end end
    end})
    Tab:AddToggle({Name = "AutoKitsune", Flag = "AutoKitsune", Default = false, Callback = function(v)
        A.F.AutoKitsune = v
        if A.AutoEvents then if v then A.AutoEvents:TriggerKitsune(true) else A.AutoEvents:TriggerKitsune(false) end end
    end})
    Tab:AddToggle({Name = "AutoOrder", Flag = "AutoOrder", Default = false, Callback = function(v)
        A.F.AutoOrder = v
        if A.SpecialQuest then if v then A.SpecialQuest:AutoOrder(true) else A.SpecialQuest:AutoOrder(false) end end
    end})
    Tab:AddToggle({Name = "AutoRipIndra", Flag = "AutoRipIndra", Default = false, Callback = function(v)
        A.F.AutoRipIndra = v
        if A.SpecialQuest then if v then A.SpecialQuest:AutoRipIndra(true) else A.SpecialQuest:AutoRipIndra(false) end end
    end})
    Tab:AddToggle({Name = "AutoLeviathan", Flag = "AutoLeviathan", Default = false, Callback = function(v)
        A.F.AutoLeviathan = v
        if A.AutoEvents then if v then A.AutoEvents:TriggerLeviathan(true) else A.AutoEvents:TriggerLeviathan(false) end end
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Kill All Bosses", Callback = function()
        if A.BossFarm then A.BossFarm:FarmAllBosses() end
        A.Notify("Boss Farm", "Starting all bosses...", 3)
    end})
    Tab:AddButton({Name = "Show Boss Timers", Callback = function()
        A.Notify("Boss Timers", "Checking boss spawn timers...", 3)
        if A.BossFarm then A.BossFarm:ShowTimers() end
    end})
end

-- TAB 4: Stats
do
    local Tab = W:CreateTab({Name = "Stats", Color = Color3.fromRGB(0, 120, 255), Icon = "📊"})
    local Section = Tab:AddSection("Stat Distribution")
    Tab:AddToggle({Name = "AutoStats", Flag = "AutoStatsMain", Default = false, Callback = function(v)
        A.F.AutoStats = v
        if A.Stats then if v then A.Stats:Start() else A.Stats:Stop() end end
        A.Notify("AutoStats", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddDropdown({Name = "Build", Flag = "StatBuild", Options = {"Melee", "Sword", "Fruit", "Gun", "Custom"}, Default = "Melee", Callback = function(v)
        A.C.StatBuild = v
        if A.Stats then A.Stats:SetBuild(v) end
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Distribute Now", Callback = function()
        if A.Stats then A.Stats:Distribute() end
        A.Notify("Stats", "Distributing stats now...", 2)
    end})
    Tab:AddButton({Name = "Refund Stats", Callback = function()
        if A.Stats then A.Stats:ResetStats() end
        A.Notify("Stats", "Refunding all stats...", 2)
    end})
    Tab:AddLabel("Stats: Melee 0 | Sword 0 | Fruit 0 | Gun 0 | Defense 0 | Health 0")
end

-- TAB 5: Sea Events
do
    local Tab = W:CreateTab({Name = "Sea Events", Color = Color3.fromRGB(0, 220, 255), Icon = "🌊"})
    local Section = Tab:AddSection("Sea Event Farm")
    Tab:AddToggle({Name = "SeaBeast", Flag = "SeaBeast", Default = false, Callback = function(v)
        A.F.SeaBeast = v
        if A.SeaEvents then if v then A.SeaEvents:FindSeaBeast(true) else A.SeaEvents:FindSeaBeast(false) end end
        A.Notify("SeaBeast", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "TerrorShark", Flag = "TerrorShark", Default = false, Callback = function(v)
        A.F.TerrorShark = v
        if A.SeaEvents then if v then A.SeaEvents:FindTerrorShark(true) else A.SeaEvents:FindTerrorShark(false) end end
    end})
    Tab:AddToggle({Name = "SharkAnchor", Flag = "SharkAnchor", Default = false, Callback = function(v)
        A.F.SharkAnchor = v
    end})
    Tab:AddToggle({Name = "Leviathan", Flag = "Leviathan", Default = false, Callback = function(v)
        A.F.Leviathan = v
        if A.SeaEvents then if v then A.SeaEvents:FindLeviathan(true) else A.SeaEvents:FindLeviathan(false) end end
    end})
    Tab:AddToggle({Name = "FrozenDimension", Flag = "FrozenDimension", Default = false, Callback = function(v)
        A.F.FrozenDimension = v
        if A.World then if v then A.World:AutoFrozenDimension(true) else A.World:AutoFrozenDimension(false) end end
    end})
    Tab:AddToggle({Name = "PrehistoricIsland", Flag = "PrehistoricIsland", Default = false, Callback = function(v)
        A.F.PrehistoricIsland = v
        if A.World then if v then A.World:AutoPrehistoricIsland(true) else A.World:AutoPrehistoricIsland(false) end end
    end})
    Tab:AddToggle({Name = "MirrorDimension", Flag = "MirrorDimension", Default = false, Callback = function(v)
        A.F.MirrorDimension = v
        if A.World then if v then A.World:AutoMirrorDimension(true) else A.World:AutoMirrorDimension(false) end end
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Farm All Sea Events", Callback = function()
        if A.SeaEvents then A.SeaEvents:FarmAllSeaEvents() end
        A.Notify("Sea Events", "Starting all sea events...", 3)
    end})
    Tab:AddLabel("Sea Events: 0 | SeaBeast: 0 | TerrorShark: 0")
end

-- TAB 6: Raids
do
    local Tab = W:CreateTab({Name = "Raids", Color = Color3.fromRGB(255, 140, 0), Icon = "⚡"})
    local Section = Tab:AddSection("Raid Settings")
    Tab:AddToggle({Name = "AutoRaid", Flag = "AutoRaid", Default = false, Callback = function(v)
        A.F.AutoRaid = v
        if A.Raid then if v then A.Raid:Start() else A.Raid:Stop() end end
        A.Notify("AutoRaid", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "AutoRaidAll", Flag = "AutoRaidAll", Default = false, Callback = function(v)
        A.F.AutoRaidAll = v
        if A.Raid then if v then A.Raid:FarmAllRaids(true) else A.Raid:FarmAllRaids(false) end end
    end})
    Tab:AddToggle({Name = "AutoRaidNext", Flag = "AutoRaidNext", Default = false, Callback = function(v)
        A.F.AutoRaidNext = v
    end})
    Tab:AddToggle({Name = "AutoCompleteRaid", Flag = "AutoCompleteRaid", Default = false, Callback = function(v)
        A.F.AutoCompleteRaid = v
    end})
    Tab:AddToggle({Name = "RaidBoss", Flag = "RaidBoss", Default = false, Callback = function(v)
        A.F.RaidBoss = v
    end})
    Tab:AddToggle({Name = "RaidBosses", Flag = "RaidBosses", Default = false, Callback = function(v)
        A.F.RaidBosses = v
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Start Raid", Callback = function()
        if A.Raid then A.Raid:StartRaid() end
        A.Notify("Raid", "Starting raid...", 2)
    end})
    Tab:AddButton({Name = "Farm All Raids", Callback = function()
        if A.Raid then A.Raid:FarmAllRaids() end
        A.Notify("Raid", "Farming all raids...", 2)
    end})
    Tab:AddLabel("Raids: 0 | Fragments: 0")
end

-- TAB 7: Fruit Sniper
do
    local Tab = W:CreateTab({Name = "Fruit Sniper", Color = Color3.fromRGB(255, 215, 0), Icon = "🍎"})
    local Section = Tab:AddSection("Fruit Settings")
    Tab:AddToggle({Name = "AutoFruit", Flag = "AutoFruit", Default = false, Callback = function(v)
        A.F.AutoFruit = v
        if A.FruitManager then if v then A.FruitManager:Start() else A.FruitManager:Stop() end end
        A.Notify("AutoFruit", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "AutoStore", Flag = "AutoStore", Default = false, Callback = function(v)
        A.F.AutoStore = v
    end})
    Tab:AddToggle({Name = "AutoEat", Flag = "AutoEat", Default = false, Callback = function(v)
        A.F.AutoEat = v
    end})
    Tab:AddToggle({Name = "AutoSniperFruit", Flag = "AutoSniperFruit", Default = false, Callback = function(v)
        A.F.AutoSniperFruit = v
        if A.FruitManager then if v then A.FruitManager:SnipeFruit(true) else A.FruitManager:SnipeFruit(false) end end
    end})
    Tab:AddToggle({Name = "AutoDropFruit", Flag = "AutoDropFruit", Default = false, Callback = function(v)
        A.F.AutoDropFruit = v
    end})
    Tab:AddToggle({Name = "AutoTradeFruit", Flag = "AutoTradeFruit", Default = false, Callback = function(v)
        A.F.AutoTradeFruit = v
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Check Fruit Values", Callback = function()
        if A.FruitManager then A.FruitManager:FruitStats() end
        A.Notify("Fruit Sniper", "Checking fruit values...", 2)
    end})
    Tab:AddButton({Name = "Find Fruit World", Callback = function()
        if A.FruitManager then A.FruitManager:FindFruitWorld() end
        A.Notify("Fruit Sniper", "Searching for fruit in world...", 2)
    end})
    Tab:AddButton({Name = "Check Dealer Stock", Callback = function()
        if A.FruitManager then A.FruitManager:GetDealerStock() end
        A.Notify("Fruit Sniper", "Checking dealer stock...", 2)
    end})
    Tab:AddLabel("Current Fruit: None")
end

-- TAB 8: ESP
do
    local Tab = W:CreateTab({Name = "ESP", Color = Color3.fromRGB(160, 0, 255), Icon = "👁️"})
    local Section = Tab:AddSection("ESP Settings")
    Tab:AddToggle({Name = "ESP (Master)", Flag = "ESPMaster", Default = false, Callback = function(v)
        A.F.ESP = v
        if A.ESP then if v then A.ESP:Start() else A.ESP:Stop() end end
        A.Notify("ESP", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "ESPPlayers", Flag = "ESPPlayers", Default = false, Callback = function(v)
        A.F.ESPPlayers = v
        if A.ESP then A.ESP:SetPlayers(v) end
    end})
    Tab:AddToggle({Name = "ESPChest", Flag = "ESPChest", Default = false, Callback = function(v)
        A.F.ESPChest = v
        if A.ESP then A.ESP:SetChest(v) end
    end})
    Tab:AddToggle({Name = "ESPFruit", Flag = "ESPFruit", Default = false, Callback = function(v)
        A.F.ESPFruit = v
        if A.ESP then A.ESP:SetFruit(v) end
    end})
    Tab:AddToggle({Name = "ESPMob", Flag = "ESPMob", Default = false, Callback = function(v)
        A.F.ESPMob = v
        if A.ESP then A.ESP:SetMob(v) end
    end})
    Tab:AddToggle({Name = "ESPQuest", Flag = "ESPQuest", Default = false, Callback = function(v)
        A.F.ESPQuest = v
        if A.ESP then A.ESP:SetQuest(v) end
    end})
    Tab:AddToggle({Name = "ESPSea", Flag = "ESPSea", Default = false, Callback = function(v)
        A.F.ESPSea = v
        if A.ESP then A.ESP:SetSea(v) end
    end})
    Tab:AddToggle({Name = "ESPBoss", Flag = "ESPBoss", Default = false, Callback = function(v)
        A.F.ESPBoss = v
        if A.ESP then A.ESP:SetBoss(v) end
    end})
    Tab:AddSlider({Name = "ESPRange", Flag = "ESPRange", Min = 500, Max = 5000, Default = 2500, Callback = function(v)
        A.C.ESPRange = v
        if A.ESP then A.ESP:SetRange(v) end
    end})
    Tab:AddLabel("ESP Count: 0")
end

-- TAB 9: Teleport
do
    local Tab = W:CreateTab({Name = "Teleport", Color = Color3.fromRGB(0, 180, 180), Icon = "📍"})
    local Section = Tab:AddSection("Sea Travel")
    Tab:AddButton({Name = "To Second Sea", Callback = function()
        if A.SeaProgress then A.SeaProgress:ToSecondSea() end
        A.Notify("Teleport", "Traveling to Second Sea...", 3)
    end})
    Tab:AddButton({Name = "To Third Sea", Callback = function()
        if A.SeaProgress then A.SeaProgress:ToThirdSea() end
        A.Notify("Teleport", "Traveling to Third Sea...", 3)
    end})
    local S2 = Tab:AddSection("Quick Teleport")
    Tab:AddButton({Name = "Teleport to Quest", Callback = function()
        if A.Teleport then A.Teleport:ToQuest() end
        A.Notify("Teleport", "Teleporting to quest NPC...", 2)
    end})
    Tab:AddButton({Name = "Teleport to Boss", Callback = function()
        if A.Teleport then A.Teleport:ToBoss() end
        A.Notify("Teleport", "Teleporting to boss...", 2)
    end})
    Tab:AddButton({Name = "Teleport to Fruit", Callback = function()
        if A.Teleport then A.Teleport:ToFruit() end
        A.Notify("Teleport", "Teleporting to fruit...", 2)
    end})
    Tab:AddButton({Name = "Teleport to Chest", Callback = function()
        if A.Teleport then A.Teleport:ToChest() end
        A.Notify("Teleport", "Teleporting to chest...", 2)
    end})
    Tab:AddButton({Name = "Teleport to NPC", Callback = function()
        if A.Teleport then A.Teleport:ToNPC() end
        A.Notify("Teleport", "Teleporting to NPC...", 2)
    end})
    local S3 = Tab:AddSection("Island Teleport")
    Tab:AddDropdown({Name = "Island", Flag = "IslandSelect", Options = {
        "Starter Island", "Marine Fortress", "Shark Island", "Sky Island",
        "Frozen Village", "Underwater City", "Upper Sky", "Prison",
        "Colosseum", "Magma Village", "Usoapp Island", "Forgotten Island",
        "Marine Ranch", "Candy Island", "Haunted Castle", "Chocolate Island",
        "Monastery", "Navy Fortress", "Floating Turtle", "Port Town",
        "Hydra Island", "Yama Training Ground", "Tushita Dojo", "Kitsune Island",
        "Leviathan Lair", "Terror Shark Bay", "Prehistoric Island", "Frozen Dimension"
    }, Default = "Starter Island", Callback = function(v)
        A.C.SelectedIsland = v
    end})
    Tab:AddButton({Name = "Teleport to Island", Callback = function()
        local island = A.C.SelectedIsland or "Starter Island"
        if A.Teleport then A.Teleport:ToIsland(island) end
        A.Notify("Teleport", "Teleporting to " .. island .. "...", 2)
    end})
    Tab:AddLabel("Current Island: Starter Island")
end

-- TAB 10: Movement
do
    local Tab = W:CreateTab({Name = "Movement", Color = Color3.fromRGB(0, 255, 0), Icon = "🏃"})
    local Section = Tab:AddSection("Movement Hacks")
    Tab:AddToggle({Name = "Fly", Flag = "Fly", Default = false, Callback = function(v)
        A.F.Fly = v
        if A.MovementHack then if v then A.MovementHack:StartFly() else A.MovementHack:StopFly() end end
        A.Notify("Fly", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "Noclip", Flag = "Noclip", Default = false, Callback = function(v)
        A.F.Noclip = v
        if A.MovementHack then if v then A.MovementHack:StartNoclip() else A.MovementHack:StopNoclip() end end
        A.Notify("Noclip", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "Speed", Flag = "Speed", Default = false, Callback = function(v)
        A.F.Speed = v
        local plr = game:GetService("Players").LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            if v then
                plr.Character.Humanoid.WalkSpeed = A.C.WalkSpeed or 100
            else
                plr.Character.Humanoid.WalkSpeed = 16
            end
        end
        A.Notify("Speed", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "JumpPower", Flag = "JumpPower", Default = false, Callback = function(v)
        A.F.JumpPower = v
        local plr = game:GetService("Players").LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            if v then
                plr.Character.Humanoid.JumpPower = A.C.JumpPower or 100
            else
                plr.Character.Humanoid.JumpPower = 50
            end
        end
        A.Notify("JumpPower", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "WalkOnWater", Flag = "WalkOnWater", Default = false, Callback = function(v)
        A.F.WalkOnWater = v
        if A.MovementHack then if v then A.MovementHack:StartWalkOnWater() else A.MovementHack:StopWalkOnWater() end end
    end})
    Tab:AddToggle({Name = "InfiniteJump", Flag = "InfiniteJump", Default = false, Callback = function(v)
        A.F.InfiniteJump = v
    end})
    Tab:AddToggle({Name = "BHop", Flag = "BHop", Default = false, Callback = function(v)
        A.F.BHop = v
    end})
    local S2 = Tab:AddSection("Settings")
    Tab:AddSlider({Name = "FlySpeed", Flag = "FlySpeed", Min = 50, Max = 500, Default = 100, Callback = function(v)
        A.C.FlySpeed = v
    end})
    Tab:AddSlider({Name = "WalkSpeed", Flag = "WalkSpeedSlider", Min = 16, Max = 200, Default = 16, Callback = function(v)
        A.C.WalkSpeed = v
        if A.F.Speed then
            local plr = game:GetService("Players").LocalPlayer
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.WalkSpeed = v
            end
        end
    end})
    Tab:AddSlider({Name = "JumpPowerSlider", Flag = "JumpPowerSlider", Min = 50, Max = 300, Default = 50, Callback = function(v)
        A.C.JumpPower = v
        if A.F.JumpPower then
            local plr = game:GetService("Players").LocalPlayer
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.JumpPower = v
            end
        end
    end})
    local S3 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Reset Movement", Callback = function()
        if A.MovementHack then A.MovementHack:ResetAll() end
        A.Notify("Movement", "All movement hacks reset!", 2)
    end})
end

-- TAB 11: Mastery
do
    local Tab = W:CreateTab({Name = "Mastery", Color = Color3.fromRGB(139, 69, 19), Icon = "🎓"})
    local Section = Tab:AddSection("Mastery Farm")
    Tab:AddToggle({Name = "AutoMastery", Flag = "AutoMastery", Default = false, Callback = function(v)
        A.F.AutoMastery = v
        if A.Mastery then if v then A.Mastery:Start() else A.Mastery:Stop() end end
        A.Notify("Mastery", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "AutoMasteryFruit", Flag = "AutoMasteryFruit", Default = false, Callback = function(v)
        A.F.AutoMasteryFruit = v
        if A.Mastery then if v then A.Mastery:MasteryFruit(true) else A.Mastery:MasteryFruit(false) end end
    end})
    Tab:AddToggle({Name = "AutoMasterySword", Flag = "AutoMasterySword", Default = false, Callback = function(v)
        A.F.AutoMasterySword = v
        if A.Mastery then if v then A.Mastery:MasterySword(true) else A.Mastery:MasterySword(false) end end
    end})
    Tab:AddToggle({Name = "AutoMasteryGun", Flag = "AutoMasteryGun", Default = false, Callback = function(v)
        A.F.AutoMasteryGun = v
        if A.Mastery then if v then A.Mastery:MasteryGun(true) else A.Mastery:MasteryGun(false) end end
    end})
    Tab:AddToggle({Name = "AutoMasteryMelee", Flag = "AutoMasteryMelee", Default = false, Callback = function(v)
        A.F.AutoMasteryMelee = v
        if A.Mastery then if v then A.Mastery:MasteryMelee(true) else A.Mastery:MasteryMelee(false) end end
    end})
    Tab:AddToggle({Name = "AutoMasteryAbility", Flag = "AutoMasteryAbility", Default = false, Callback = function(v)
        A.F.AutoMasteryAbility = v
        if A.Mastery then if v then A.Mastery:MasteryAbility(true) else A.Mastery:MasteryAbility(false) end end
    end})
    local S2 = Tab:AddSection("Info")
    Tab:AddButton({Name = "Show Mastery Progress", Callback = function()
        if A.Mastery then A.Mastery:ShowProgress() end
        A.Notify("Mastery", "Displaying mastery progress...", 2)
    end})
    Tab:AddLabel("Mastery: Fruit 0 | Sword 0 | Gun 0 | Melee 0 | Ability 0")
end

-- TAB 12: Bounty
do
    local Tab = W:CreateTab({Name = "Bounty", Color = Color3.fromRGB(255, 215, 0), Icon = "💰"})
    local Section = Tab:AddSection("Bounty Settings")
    Tab:AddToggle({Name = "AutoBounty", Flag = "AutoBounty", Default = false, Callback = function(v)
        A.F.AutoBounty = v
        if A.Bounty then if v then A.Bounty:Start() else A.Bounty:Stop() end end
        A.Notify("AutoBounty", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddSlider({Name = "BountyRange", Flag = "BountyRange", Min = 100, Max = 2000, Default = 500, Callback = function(v)
        A.C.BountyRange = v
    end})
    Tab:AddDropdown({Name = "TargetMode", Flag = "TargetMode", Options = {"Closest", "Weakest", "Strongest", "HighestBounty", "Lowest"}, Default = "Closest", Callback = function(v)
        A.C.TargetMode = v
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Hunt Bounty", Callback = function()
        if A.Bounty then A.Bounty:FightPlayer() end
        A.Notify("Bounty", "Hunting bounty target...", 2)
    end})
    Tab:AddButton({Name = "Server Hop Bounty", Callback = function()
        if A.Bounty then A.Bounty:HopBounty() end
        A.Notify("Bounty", "Server hopping for bounty...", 3)
    end})
    Tab:AddLabel("Bounty: 0")
end

-- TAB 13: Dungeon
do
    local Tab = W:CreateTab({Name = "Dungeon", Color = Color3.fromRGB(80, 0, 120), Icon = "🏰"})
    local Section = Tab:AddSection("Dungeon Settings")
    Tab:AddToggle({Name = "AutoDungeon", Flag = "AutoDungeon", Default = false, Callback = function(v)
        A.F.AutoDungeon = v
        if A.Dungeon then if v then A.Dungeon:Start() else A.Dungeon:Stop() end end
        A.Notify("AutoDungeon", v and "Enabled" or "Disabled", 2)
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Enter Dungeon", Callback = function()
        if A.Dungeon then A.Dungeon:EnterDungeon() end
        A.Notify("Dungeon", "Entering dungeon...", 2)
    end})
    Tab:AddButton({Name = "Farm Dungeon", Callback = function()
        if A.Dungeon then A.Dungeon:FarmDungeonRewards() end
        A.Notify("Dungeon", "Farming dungeon rewards...", 2)
    end})
    Tab:AddLabel("Dungeons: 0 | Keys: 0 | Relics: 0")
end

-- TAB 14: Shop
do
    local Tab = W:CreateTab({Name = "Shop", Color = Color3.fromRGB(0, 200, 0), Icon = "🛒"})
    local Section = Tab:AddSection("Auto Buy Settings")
    Tab:AddToggle({Name = "AutoBuy", Flag = "AutoBuy", Default = false, Callback = function(v)
        A.F.AutoBuy = v
        if A.Shop then if v then A.Shop:Start() else A.Shop:Stop() end end
        A.Notify("AutoBuy", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "AutoBuySwords", Flag = "AutoBuySwords", Default = false, Callback = function(v)
        A.F.AutoBuySwords = v
    end})
    Tab:AddToggle({Name = "AutoBuyGuns", Flag = "AutoBuyGuns", Default = false, Callback = function(v)
        A.F.AutoBuyGuns = v
    end})
    Tab:AddToggle({Name = "AutoBuyAbilities", Flag = "AutoBuyAbilities", Default = false, Callback = function(v)
        A.F.AutoBuyAbilities = v
    end})
    Tab:AddToggle({Name = "AutoBuyFightingStyles", Flag = "AutoBuyFightingStyles", Default = false, Callback = function(v)
        A.F.AutoBuyFightingStyles = v
    end})
    Tab:AddToggle({Name = "AutoBuyAccessories", Flag = "AutoBuyAccessories", Default = false, Callback = function(v)
        A.F.AutoBuyAccessories = v
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Buy All Items", Callback = function()
        if A.Shop then A.Shop:BuyAllItems() end
        A.Notify("Shop", "Buying all items...", 2)
    end})
    Tab:AddButton({Name = "Buy Specific", Callback = function()
        if A.Shop then A.Shop:ShowDialog() end
        A.Notify("Shop", "Opening shop dialog...", 2)
    end})
end

-- TAB 15: Fishing
do
    local Tab = W:CreateTab({Name = "Fishing", Color = Color3.fromRGB(0, 100, 255), Icon = "🎣"})
    local Section = Tab:AddSection("Fishing Settings")
    Tab:AddToggle({Name = "AutoFishing", Flag = "AutoFishing", Default = false, Callback = function(v)
        A.F.AutoFishing = v
        if A.Fishing then if v then A.Fishing:Start() else A.Fishing:Stop() end end
        A.Notify("AutoFishing", v and "Enabled" or "Disabled", 2)
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Cast Rod", Callback = function()
        if A.Fishing then A.Fishing:CastRod() end
        A.Notify("Fishing", "Casting rod...", 2)
    end})
    Tab:AddButton({Name = "Catch Fish", Callback = function()
        if A.Fishing then A.Fishing:CatchFish() end
        A.Notify("Fishing", "Catching fish...", 2)
    end})
    Tab:AddLabel("Fish Caught: 0")
    local S3 = Tab:AddSection("Rod & Bait")
    Tab:AddToggle({Name = "Auto Equip Best Rod", Flag = "AutoEquipBestRod", Default = false, Callback = function(v)
        A.F.AutoEquipBestRod = v
        if A.Fishing then A.Fishing.AutoEquipBestRod = v end
    end})
    Tab:AddButton({Name = "Equip Best Rod", Callback = function()
        if A.Fishing and A.Fishing.EquipBestRod then A.Fishing.EquipBestRod() end
    end})
    Tab:AddButton({Name = "Buy Bait (Worm x10)", Callback = function()
        if A.Fishing and A.Fishing.BuyBait then A.Fishing.BuyBait("Worm", 10) end
    end})
    local S4 = Tab:AddSection("Sell & Filter")
    Tab:AddToggle({Name = "Auto Sell Low Rarity", Flag = "AutoSellFish", Default = false, Callback = function(v)
        A.F.AutoSellFish = v
        if A.Fishing then A.Fishing.AutoSellFish = v end
    end})
    Tab:AddDropdown({Name = "Keep Filter", Flag = "KeepFilter", Options = {"Keep All", "Uncommon+", "Rare+", "Epic+", "Legendary+", "Mythical Only"}, Default = "Keep All", Callback = function(option)
        if A.Fishing and A.Fishing.SetKeepFilter then A.Fishing.SetKeepFilter(option) end
    end})
    Tab:AddButton({Name = "Sell All Fish", Callback = function()
        if A.Fishing and A.Fishing.SellAllFish then A.Fishing.SellAllFish() end
    end})
    local S5 = Tab:AddSection("Fishing Info")
    Tab:AddButton({Name = "Fishing Stats", Callback = function()
        if A.Fishing and A.Fishing.GetFishingStats then
            local s = A.Fishing.GetFishingStats()
            A.Notify("Fishing", string.format("Caught: %d | Value: %d | Rate: %s", s.FishCaught, s.TotalValue, s.CatchRate), 5)
        end
    end})
    Tab:AddButton({Name = "Show Quests", Callback = function()
        if A.Fishing and A.Fishing.GetFishingQuests then
            local q = A.Fishing.GetFishingQuests()
            if #q == 0 then A.Notify("Fishing", "No fishing quests", 2)
            else A.Notify("Fishing", table.concat(q, ", "), 4) end
        end
    end})
end

-- TAB 16: Trading
do
    local Tab = W:CreateTab({Name = "Trading", Color = Color3.fromRGB(255, 140, 0), Icon = "🤝"})
    local Section = Tab:AddSection("Trading Settings")
    Tab:AddToggle({Name = "AutoTrade", Flag = "AutoTrade", Default = false, Callback = function(v)
        A.F.AutoTrade = v
        if A.Trading then if v then A.Trading:Start() else A.Trading:Stop() end end
        A.Notify("AutoTrade", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "AutoAccept", Flag = "AutoAccept", Default = false, Callback = function(v)
        A.F.AutoAccept = v
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Show Trade History", Callback = function()
        if A.Trading then A.Trading:ShowHistory() end
        A.Notify("Trading", "Showing trade history...", 2)
    end})
    Tab:AddLabel("Trades: 0")
    local S3 = Tab:AddSection("Auto-Add & Calculator")
    Tab:AddToggle({Name = "Auto Add All Fruits", Flag = "AutoAddFruits", Default = false, Callback = function(v)
        A.F.AutoAddFruits = v
        if A.Trading then A.Trading.AutoAddFruits = v end
    end})
    Tab:AddToggle({Name = "Scam Detection", Flag = "ScamDetect", Default = true, Callback = function(v)
        A.F.ScamDetect = v
        if A.Trading then A.Trading.ScamDetect = v end
    end})
    Tab:AddButton({Name = "Add All Fruits to Trade", Callback = function()
        if A.Trading and A.Trading.AutoAddAllFruits then A.Trading.AutoAddAllFruits() end
    end})
    Tab:AddTextbox({Name = "Check Item Value", Placeholder = "e.g. Dough or Yama", Callback = function(text)
        if A.Trading and A.Trading.GetTradeValueOfItem and text and text ~= "" then
            A.Notify("Trading", text .. " value: " .. tostring(A.Trading.GetTradeValueOfItem(text)), 3)
        end
    end})
    Tab:AddButton({Name = "Trade Value Calculator", Callback = function()
        if A.Trading and A.Trading.CalculateTradeValue then
            local r = A.Trading.CalculateTradeValue({"Dough", "Dragon"}, {"Leopard", "T-Rex"})
            A.Notify("Calculator", string.format("You: %d | Them: %d | Diff: %d | %s", r.LhsTotal, r.RhsTotal, r.Difference, r.Fair and "FAIR" or "UNFAIR"), 6)
        end
    end})
end

-- TAB 17: PVP
do
    local Tab = W:CreateTab({Name = "PVP", Color = Color3.fromRGB(220, 20, 60), Icon = "⚔️"})
    local Section = Tab:AddSection("PVP Settings")
    Tab:AddToggle({Name = "SafeModePvP", Flag = "SafeModePvP", Default = false, Callback = function(v)
        A.F.SafeModePvP = v
        A.Notify("PVP", "Safe mode " .. (v and "enabled" or "disabled"), 2)
    end})
    Tab:AddToggle({Name = "NoStunEnabled", Flag = "NoStunEnabled", Default = false, Callback = function(v)
        A.F.NoStunEnabled = v
        if A.AdvCombat then if v then A.AdvCombat:NoStun(true) else A.AdvCombat:NoStun(false) end end
    end})
    Tab:AddToggle({Name = "PlayerHighlight", Flag = "PlayerHighlight", Default = false, Callback = function(v)
        A.F.PlayerHighlight = v
        if A.AdvCombat then if v then A.AdvCombat:PlayerHighlight(true) else A.AdvCombat:PlayerHighlight(false) end end
    end})
    Tab:AddToggle({Name = "EnhancedDodge", Flag = "EnhancedDodge", Default = false, Callback = function(v)
        A.F.EnhancedDodge = v
        if A.AdvCombat then if v then A.AdvCombat:EnhancedDodge(true) else A.AdvCombat:EnhancedDodge(false) end end
    end})
    Tab:AddSlider({Name = "DodgeRange", Flag = "DodgeRange", Min = 10, Max = 100, Default = 30, Callback = function(v)
        A.C.DodgeRange = v
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Find Target", Callback = function()
        if A.Bounty then A.Bounty:SelectTarget() end
        A.Notify("PVP", "Finding target...", 2)
    end})
    Tab:AddLabel("PVP: K/D 0/0 | Bounty: 0")
end

-- TAB 18: Haki
do
    local Tab = W:CreateTab({Name = "Haki", Color = Color3.fromRGB(30, 30, 30), Icon = "🌀"})
    local Section = Tab:AddSection("Haki Settings")
    Tab:AddToggle({Name = "AutoHaki", Flag = "HakiAutoHaki", Default = false, Callback = function(v)
        A.F.AutoHaki = v
        if A.Farm then if v then A.Farm:AutoHaki(true) else A.Farm:AutoHaki(false) end end
        A.Notify("Haki", v and "Auto Haki Enabled" or "Auto Haki Disabled", 2)
    end})
    Tab:AddToggle({Name = "AutoBuso", Flag = "HakiAutoBuso", Default = false, Callback = function(v)
        A.F.AutoBuso = v
        if A.Farm then if v then A.Farm:AutoBuso(true) else A.Farm:AutoBuso(false) end end
    end})
    Tab:AddToggle({Name = "AutoKen", Flag = "HakiAutoKen", Default = false, Callback = function(v)
        A.F.AutoKen = v
        if A.Farm then if v then A.Farm:AutoKen(true) else A.Farm:AutoKen(false) end end
    end})
    Tab:AddToggle({Name = "AutoRainbowHaki", Flag = "AutoRainbowHaki", Default = false, Callback = function(v)
        A.F.AutoRainbowHaki = v
        if A.World then if v then A.World:AutoRainbowHaki(true) else A.World:AutoRainbowHaki(false) end end
    end})
    Tab:AddToggle({Name = "AutoEnhancementColor", Flag = "AutoEnhancementColor", Default = false, Callback = function(v)
        A.F.AutoEnhancementColor = v
        if A.World then if v then A.World:AutoEnhancementColor(true) else A.World:AutoEnhancementColor(false) end end
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Train Haki", Callback = function()
        if A.Farm then A.Farm:TrainHaki() end
        A.Notify("Haki", "Training Haki...", 2)
    end})
end

-- TAB 19: Second Sea
do
    local Tab = W:CreateTab({Name = "Second Sea", Color = Color3.fromRGB(255, 165, 0), Icon = "🏝️"})
    local Section = Tab:AddSection("Second Sea")
    Tab:AddToggle({Name = "AutoSecondSea", Flag = "AutoSecondSea", Default = false, Callback = function(v)
        A.F.AutoSecondSea = v
        if v then if A.SeaProgress then A.SeaProgress:ToSecondSea() end end
        A.Notify("Second Sea", v and "Traveling to Second Sea..." or "Disabled", 2)
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Travel to Second Sea", Callback = function()
        if A.SeaProgress then A.SeaProgress:ToSecondSea() end
        A.Notify("Second Sea", "Traveling to Second Sea...", 3)
    end})
    Tab:AddLabel("Requires: Level 700 | Defeat Darkbeard | Complete Alchemist Quest")
end

-- TAB 20: Third Sea
do
    local Tab = W:CreateTab({Name = "Third Sea", Color = Color3.fromRGB(200, 0, 0), Icon = "🏴"})
    local Section = Tab:AddSection("Third Sea")
    Tab:AddToggle({Name = "AutoThirdSea", Flag = "AutoThirdSea", Default = false, Callback = function(v)
        A.F.AutoThirdSea = v
        if v then if A.SeaProgress then A.SeaProgress:ToThirdSea() end end
        A.Notify("Third Sea", v and "Traveling to Third Sea..." or "Disabled", 2)
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Travel to Third Sea", Callback = function()
        if A.SeaProgress then A.SeaProgress:ToThirdSea() end
        A.Notify("Third Sea", "Traveling to Third Sea...", 3)
    end})
    Tab:AddLabel("Requires: Level 1500 | Defeat Tide Keeper | Complete Colosseum Quest")
end

-- TAB 21: Race V4
do
    local Tab = W:CreateTab({Name = "Race V4", Color = Color3.fromRGB(255, 0, 255), Icon = "🧬"})
    local Section = Tab:AddSection("Race V4")
    Tab:AddToggle({Name = "AutoRaceV4", Flag = "AutoRaceV4", Default = false, Callback = function(v)
        A.F.AutoRaceV4 = v
        if A.Race then if v then A.Race:ActivateV4() end end
        A.Notify("Race V4", v and "Auto V4 Enabled" or "Disabled", 2)
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Start Trial", Callback = function()
        if A.Race then A.Race:StartTrial() end
        A.Notify("Race V4", "Starting trial...", 2)
    end})
    Tab:AddButton({Name = "Complete Trial", Callback = function()
        if A.Race then A.Race:CompleteTrial() end
        A.Notify("Race V4", "Completing trial...", 2)
    end})
    Tab:AddButton({Name = "Awaken Race", Callback = function()
        if A.Race then A.Race:RaceAwaken() end
        A.Notify("Race V4", "Awakening race...", 3)
    end})
    Tab:AddButton({Name = "Refund Race", Callback = function()
        if A.Race then A.Race:RefundRace() end
        A.Notify("Race V4", "Refunding race...", 2)
    end})
    Tab:AddButton({Name = "Reroll Race", Callback = function()
        if A.Race then A.Race:RerollRace() end
        A.Notify("Race V4", "Rerolling race...", 2)
    end})
    Tab:AddLabel("Current Race: Unknown")
end

-- TAB 22: Auto Open
do
    local Tab = W:CreateTab({Name = "Auto Open", Color = Color3.fromRGB(255, 105, 180), Icon = "📦"})
    local Section = Tab:AddSection("Auto Open Settings")
    Tab:AddToggle({Name = "AutoOpen", Flag = "AutoOpen", Default = false, Callback = function(v)
        A.F.AutoOpen = v
        A.Notify("AutoOpen", v and "Enabled" or "Disabled", 2)
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Open All", Callback = function()
        if A.FruitManager then A.FruitManager:OpenAll() end
        A.Notify("Auto Open", "Opening all items...", 2)
    end})
    Tab:AddLabel("Opens: 0")
end

-- TAB 23: CDK
do
    local Tab = W:CreateTab({Name = "CDK", Color = Color3.fromRGB(255, 215, 0), Icon = "🗡️"})
    local Section = Tab:AddSection("CDK Settings")
    Tab:AddToggle({Name = "AutoCDK", Flag = "AutoCDK", Default = false, Callback = function(v)
        A.F.AutoCDK = v
        if A.CDK then if v then A.CDK:Start() else A.CDK:Stop() end end
        A.Notify("AutoCDK", v and "Enabled" or "Disabled", 2)
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Farm Yama", Callback = function()
        if A.CDK then A.CDK:FarmYama() end
        A.Notify("CDK", "Farming Yama...", 3)
    end})
    Tab:AddButton({Name = "Farm Tushita", Callback = function()
        if A.CDK then A.CDK:FarmTushita() end
        A.Notify("CDK", "Farming Tushita...", 3)
    end})
    Tab:AddButton({Name = "Farm CDK", Callback = function()
        if A.CDK then A.CDK:AutoCDK() end
        A.Notify("CDK", "Farming CDK...", 3)
    end})
    Tab:AddButton({Name = "Show Progress", Callback = function()
        if A.CDK then A.CDK:ShowProgress() end
        A.Notify("CDK", "Showing CDK progress...", 2)
    end})
    Tab:AddLabel("CDK Progress: Yama 0% | Tushita 0% | CDK 0%")
end

-- TAB 24: Farm Mode
do
    local Tab = W:CreateTab({Name = "Farm Mode", Color = Color3.fromRGB(0, 100, 255), Icon = "🎯"})
    local Section = Tab:AddSection("Farm Mode Settings")
    Tab:AddToggle({Name = "FarmAll", Flag = "FarmAllMode", Default = false, Callback = function(v)
        A.F.FarmAll = v
        if A.AdvCombat then if v then A.AdvCombat:FarmAll() end end
    end})
    Tab:AddToggle({Name = "SmartPathfind", Flag = "SmartPathfind", Default = false, Callback = function(v)
        A.F.SmartPathfind = v
        if A.AdvCombat then if v then A.AdvCombat:SmartPathfind(true) else A.AdvCombat:SmartPathfind(false) end end
    end})
    Tab:AddToggle({Name = "AutoDodge", Flag = "AutoDodge", Default = false, Callback = function(v)
        A.F.AutoDodge = v
        if A.AdvCombat then if v then A.AdvCombat:EnhancedDodge(true) else A.AdvCombat:EnhancedDodge(false) end end
    end})
    Tab:AddSlider({Name = "DodgeRange", Flag = "FarmDodgeRange", Min = 10, Max = 100, Default = 30, Callback = function(v)
        A.C.DodgeRange = v
    end})
    Tab:AddDropdown({Name = "FarmMode", Flag = "FarmMode", Options = {"Quest", "Boss", "Chest", "All"}, Default = "Quest", Callback = function(v)
        A.C.FarmMode = v
    end})
end

-- TAB 25: Adv Farm
do
    local Tab = W:CreateTab({Name = "Adv Farm", Color = Color3.fromRGB(0, 200, 0), Icon = "🏟️"})
    local Section = Tab:AddSection("Advanced Farm")
    Tab:AddToggle({Name = "SuperAttack", Flag = "SuperAttack", Default = false, Callback = function(v)
        A.F.SuperAttack = v
        if A.Combat then if v then A.Combat:SuperAttack(true) else A.Combat:SuperAttack(false) end end
        A.Notify("Adv Farm", "Super Attack " .. (v and "enabled" or "disabled"), 2)
    end})
    Tab:AddToggle({Name = "AutoTreeDestroyer", Flag = "AutoTreeDestroyer", Default = false, Callback = function(v)
        A.F.AutoTreeDestroyer = v
        if A.World then if v then A.World:AutoTreeDestroyer(true) else A.World:AutoTreeDestroyer(false) end end
    end})
    Tab:AddToggle({Name = "AutoRevenge", Flag = "AutoRevenge", Default = false, Callback = function(v)
        A.F.AutoRevenge = v
        if A.World then if v then A.World:AutoRevengeBoss() end end
    end})
    local S2 = Tab:AddSection("Combo Actions")
    Tab:AddButton({Name = "Mega Combo", Callback = function()
        if A.Combat then local target = A.Combat:GetTarget()
        if target then A.Combat:MegaCombo(target) end end
    end})
    Tab:AddButton({Name = "Ultra Combo", Callback = function()
        if A.Combat then local target = A.Combat:GetTarget()
        if target then A.Combat:UltraCombo(target) end end
    end})
    Tab:AddButton({Name = "One Shot", Callback = function()
        if A.Combat then local target = A.Combat:GetTarget()
        if target then A.Combat:OneShot(target) end end
    end})
end

-- TAB 26: Awakening
do
    local Tab = W:CreateTab({Name = "Awakening", Color = Color3.fromRGB(255, 215, 0), Icon = "✨"})
    local Section = Tab:AddSection("Awakening Settings")
    Tab:AddToggle({Name = "AutoAwaken", Flag = "AutoAwaken", Default = false, Callback = function(v)
        A.F.AutoAwaken = v
        if A.Awaken then if v then A.Awaken:Start() else A.Awaken:Stop() end end
        A.Notify("Awakening", v and "Enabled" or "Disabled", 2)
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Awaken Fruit", Callback = function()
        if A.Awaken then A.Awaken:StartAwakening() end
        A.Notify("Awakening", "Starting fruit awakening...", 3)
    end})
    Tab:AddButton({Name = "Show Progress", Callback = function()
        if A.Awaken then A.Awaken:ShowProgress() end
        A.Notify("Awakening", "Showing awakening progress...", 2)
    end})
    Tab:AddLabel("Awakening: Moves 0/5 | Materials: 0 | Charges: 0")
end

-- TAB 27: Sea Progress
do
    local Tab = W:CreateTab({Name = "Sea Progress", Color = Color3.fromRGB(0, 200, 255), Icon = "🌊"})
    local Section = Tab:AddSection("Sea Travel")
    Tab:AddButton({Name = "To Second Sea", Callback = function()
        if A.SeaProgress then A.SeaProgress:ToSecondSea() end
        A.Notify("Sea Progress", "Traveling to Second Sea...", 3)
    end})
    Tab:AddButton({Name = "To Third Sea", Callback = function()
        if A.SeaProgress then A.SeaProgress:ToThirdSea() end
        A.Notify("Sea Progress", "Traveling to Third Sea...", 3)
    end})
    local S2 = Tab:AddSection("Race Unlocks")
    Tab:AddToggle({Name = "AutoDojo", Flag = "AutoDojo", Default = false, Callback = function(v)
        A.F.AutoDojo = v
        if A.SeaProgress then if v then A.SeaProgress:AutoDojo() end end
    end})
    Tab:AddToggle({Name = "AutoDracoRace", Flag = "AutoDracoRace", Default = false, Callback = function(v)
        A.F.AutoDracoRace = v
        if A.SeaProgress then if v then A.SeaProgress:AutoDracoRace() end end
    end})
    Tab:AddToggle({Name = "AutoGhoul", Flag = "AutoGhoul", Default = false, Callback = function(v)
        A.F.AutoGhoul = v
        if A.SeaProgress then if v then A.SeaProgress:AutoGhoul() end end
    end})
    Tab:AddToggle({Name = "AutoCyborg", Flag = "AutoCyborg", Default = false, Callback = function(v)
        A.F.AutoCyborg = v
        if A.SeaProgress then if v then A.SeaProgress:AutoCyborg() end end
    end})
    Tab:AddLabel("Sea Progress: First Sea | Level: 1/2550")
end

-- TAB 28: World
do
    local Tab = W:CreateTab({Name = "World", Color = Color3.fromRGB(128, 0, 255), Icon = "🌍"})
    local Section = Tab:AddSection("World Events")
    Tab:AddToggle({Name = "AutoPrehistoricIsland", Flag = "AutoPrehistoricIslandWorld", Default = false, Callback = function(v)
        A.F.AutoPrehistoricIsland = v
        if A.World then if v then A.World:AutoPrehistoricIsland(true) else A.World:AutoPrehistoricIsland(false) end end
    end})
    Tab:AddToggle({Name = "AutoFrozenDimension", Flag = "AutoFrozenDimensionWorld", Default = false, Callback = function(v)
        A.F.AutoFrozenDimension = v
        if A.World then if v then A.World:AutoFrozenDimension(true) else A.World:AutoFrozenDimension(false) end end
    end})
    Tab:AddToggle({Name = "AutoMirrorDimension", Flag = "AutoMirrorDimensionWorld", Default = false, Callback = function(v)
        A.F.AutoMirrorDimension = v
        if A.World then if v then A.World:AutoMirrorDimension(true) else A.World:AutoMirrorDimension(false) end end
    end})
    Tab:AddToggle({Name = "AutoTreeDestroyer", Flag = "AutoTreeDestroyerWorld", Default = false, Callback = function(v)
        A.F.AutoTreeDestroyer = v
        if A.World then if v then A.World:AutoTreeDestroyer(true) else A.World:AutoTreeDestroyer(false) end end
    end})
    Tab:AddToggle({Name = "AutoRevenge", Flag = "AutoRevengeWorld", Default = false, Callback = function(v)
        A.F.AutoRevenge = v
        if A.World then if v then A.World:AutoRevengeBoss() end end
    end})
    local S2 = Tab:AddSection("World Features")
    Tab:AddToggle({Name = "AutoRainbowHaki", Flag = "AutoRainbowHakiWorld", Default = false, Callback = function(v)
        A.F.AutoRainbowHaki = v
        if A.World then if v then A.World:AutoRainbowHaki(true) else A.World:AutoRainbowHaki(false) end end
    end})
    Tab:AddToggle({Name = "AutoEnhancementColor", Flag = "AutoEnhancementColorWorld", Default = false, Callback = function(v)
        A.F.AutoEnhancementColor = v
        if A.World then if v then A.World:AutoEnhancementColor(true) else A.World:AutoEnhancementColor(false) end end
    end})
    Tab:AddToggle({Name = "AutoFruitSkillChain", Flag = "AutoFruitSkillChain", Default = false, Callback = function(v)
        A.F.AutoFruitSkillChain = v
        if A.World then if v then A.World:AutoFruitSkillChain(true) else A.World:AutoFruitSkillChain(false) end end
    end})
    Tab:AddToggle({Name = "AutoSwordSkillChain", Flag = "AutoSwordSkillChain", Default = false, Callback = function(v)
        A.F.AutoSwordSkillChain = v
        if A.World then if v then A.World:AutoSwordSkillChain(true) else A.World:AutoSwordSkillChain(false) end end
    end})
end

-- TAB 29: Adv Combat
do
    local Tab = W:CreateTab({Name = "Adv Combat", Color = Color3.fromRGB(255, 0, 0), Icon = "🎯"})
    local Section = Tab:AddSection("Advanced Combat")
    Tab:AddToggle({Name = "NoStunEnabled", Flag = "AdvNoStun", Default = false, Callback = function(v)
        A.F.NoStunEnabled = v
        if A.AdvCombat then if v then A.AdvCombat:NoStun(true) else A.AdvCombat:NoStun(false) end end
        A.Notify("Adv Combat", "No Stun " .. (v and "enabled" or "disabled"), 2)
    end})
    Tab:AddToggle({Name = "PlayerHighlight", Flag = "AdvPlayerHighlight", Default = false, Callback = function(v)
        A.F.PlayerHighlight = v
        if A.AdvCombat then if v then A.AdvCombat:PlayerHighlight(true) else A.AdvCombat:PlayerHighlight(false) end end
    end})
    Tab:AddToggle({Name = "EnhancedDodge", Flag = "AdvEnhancedDodge", Default = false, Callback = function(v)
        A.F.EnhancedDodge = v
        if A.AdvCombat then if v then A.AdvCombat:EnhancedDodge(true) else A.AdvCombat:EnhancedDodge(false) end end
    end})
    Tab:AddToggle({Name = "FarmAll", Flag = "AdvFarmAll", Default = false, Callback = function(v)
        A.F.FarmAll = v
        if A.AdvCombat then if v then A.AdvCombat:FarmAll() end end
    end})
    Tab:AddToggle({Name = "SmartPathfind", Flag = "AdvSmartPathfind", Default = false, Callback = function(v)
        A.F.SmartPathfind = v
        if A.AdvCombat then if v then A.AdvCombat:SmartPathfind(true) else A.AdvCombat:SmartPathfind(false) end end
    end})
    Tab:AddSlider({Name = "DodgeRange", Flag = "AdvDodgeRange", Min = 10, Max = 100, Default = 30, Callback = function(v)
        A.C.DodgeRange = v
    end})
end

-- TAB 30: EXCLUSIVE
do
    local Tab = W:CreateTab({Name = "EXCLUSIVE", Color = Color3.fromRGB(255, 215, 0), Icon = "👑"})
    local Section = Tab:AddSection("Exclusive Features")
    Tab:AddToggle({Name = "UniqueFeatures (Master)", Flag = "UniqueFeatures", Default = false, Callback = function(v)
        A.F.UniqueFeatures = v
        if A.Unique then A.Unique:SetMaster(v) end
        A.Notify("EXCLUSIVE", "Unique features " .. (v and "enabled" or "disabled"), 2)
    end})
    Tab:AddToggle({Name = "AutoKeybinds", Flag = "AutoKeybinds", Default = false, Callback = function(v)
        A.F.AutoKeybinds = v
        if A.Unique then A.Unique:SetKeybinds(v) end
    end})
    Tab:AddToggle({Name = "StealthMode", Flag = "StealthMode", Default = false, Callback = function(v)
        A.F.StealthMode = v
        if A.Unique then A.Unique:SetStealth(v) end
        A.Notify("EXCLUSIVE", "Stealth mode " .. (v and "enabled" or "disabled"), 2)
    end})
    Tab:AddToggle({Name = "AutoTeamSwitch", Flag = "AutoTeamSwitch", Default = false, Callback = function(v)
        A.F.AutoTeamSwitch = v
    end})
    Tab:AddToggle({Name = "AutoInventory", Flag = "AutoInventory", Default = false, Callback = function(v)
        A.F.AutoInventory = v
    end})
    Tab:AddToggle({Name = "AutoBuffManager", Flag = "AutoBuffManager", Default = false, Callback = function(v)
        A.F.AutoBuffManager = v
    end})
    Tab:AddToggle({Name = "AutoBossTimer", Flag = "AutoBossTimer", Default = false, Callback = function(v)
        A.F.AutoBossTimer = v
    end})
    Tab:AddToggle({Name = "AutoPvPRank", Flag = "AutoPvPRank", Default = false, Callback = function(v)
        A.F.AutoPvPRank = v
    end})
    Tab:AddToggle({Name = "AutoFruitValue", Flag = "AutoFruitValue", Default = false, Callback = function(v)
        A.F.AutoFruitValue = v
    end})
    Tab:AddToggle({Name = "AutoHopLow", Flag = "AutoHopLow", Default = false, Callback = function(v)
        A.F.AutoHopLow = v
    end})
    Tab:AddToggle({Name = "AutoSellTrash", Flag = "AutoSellTrash", Default = false, Callback = function(v)
        A.F.AutoSellTrash = v
    end})
    Tab:AddToggle({Name = "AutoBuyAllRaces", Flag = "AutoBuyAllRaces", Default = false, Callback = function(v)
        A.F.AutoBuyAllRaces = v
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Check Fruit Values", Callback = function()
        if A.FruitManager then A.FruitManager:FruitStats() end
        A.Notify("EXCLUSIVE", "Checking fruit values...", 2)
    end})
    Tab:AddButton({Name = "Show Boss Timers", Callback = function()
        if A.BossFarm then A.BossFarm:ShowTimers() end
        A.Notify("EXCLUSIVE", "Showing boss timers...", 2)
    end})
    Tab:AddLabel("Hotkeys: F1=ToggleFarm F2=ToggleESP F3=ToggleKillAura F4=ToggleFly F5=Teleport F6=ToggleNoclip F7=ToggleSpeed F8=ToggleJump F9=ToggleAutoStats F10=ToggleMegaFarm")
    local S3 = Tab:AddSection("Server Filters")
    Tab:AddToggle({Name = "Enable Server Filters", Flag = "ServerFilters", Default = false, Callback = function(v)
        A.F.ServerFilters = v
    end})
    Tab:AddToggle({Name = "Prefer Empty Servers", Flag = "PreferEmpty", Default = false, Callback = function(v)
        A.F.PreferEmpty = v
        if A.Server then A.Server.PreferEmpty = v end
    end})
    Tab:AddTextbox({Name = "Min Players", Placeholder = "e.g. 0", Callback = function(text)
        local min = tonumber(text)
        if min and A.Server and A.Server.SetMinPlayers then A.Server.SetMinPlayers(min) end
    end})
    Tab:AddTextbox({Name = "Max Players", Placeholder = "e.g. 15", Callback = function(text)
        local maxp = tonumber(text)
        if maxp and A.Server and A.Server.SetMaxPlayers then A.Server.SetMaxPlayers(maxp) end
    end})
    Tab:AddTextbox({Name = "Region (en/au/etc)", Placeholder = "e.g. us or leave empty", Callback = function(text)
        if A.Server and A.Server.SetRegionFilter then
            A.Server.SetRegionFilter(text == "" and "any" or text)
        end
    end})
    Tab:AddTextbox({Name = "Max Age (minutes)", Placeholder = "0 = off", Callback = function(text)
        local age = tonumber(text) or 0
        if A.Server and A.Server.SetAgeFilter then A.Server.SetAgeFilter(age) end
    end})
    Tab:AddButton({Name = "Hop to Empty Server", Callback = function()
        if A.Server and A.Server.HopToEmpty then A.Server.HopToEmpty() end
    end})
    Tab:AddButton({Name = "Hop with Filters", Callback = function()
        if A.Server and A.Server.ServerHopFiltered then A.Server.ServerHopFiltered("low") end
    end})
    Tab:AddButton({Name = "Find Empty Servers", Callback = function()
        if A.Server and A.Server.FindEmptyServers then
            local e = A.Server.FindEmptyServers(3)
            A.Notify("Server", "Empty servers found: " .. tostring(#e), 3)
        end
    end})
end

-- TAB 31: Combat AI
do
    local Tab = W:CreateTab({Name = "Combat AI", Color = Color3.fromRGB(255, 0, 255), Icon = "🧠"})
    local Section = Tab:AddSection("AI Settings")
    Tab:AddToggle({Name = "CombatAI (Master)", Flag = "CombatAI", Default = false, Callback = function(v)
        A.F.CombatAI = v
        if A.CombatAI then if v then A.CombatAI:Start() else A.CombatAI:Stop() end end
        A.Notify("Combat AI", v and "Enabled" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "PredictionCombat", Flag = "PredictionCombat", Default = false, Callback = function(v)
        A.F.PredictionCombat = v
        if A.CombatAI then A.CombatAI:SetPrediction(v) end
    end})
    Tab:AddToggle({Name = "AutoCounter", Flag = "AutoCounter", Default = false, Callback = function(v)
        A.F.AutoCounter = v
        if A.CombatAI then A.CombatAI:SetCounter(v) end
    end})
    Tab:AddToggle({Name = "SmartDodge", Flag = "SmartDodge", Default = false, Callback = function(v)
        A.F.SmartDodge = v
        if A.CombatAI then A.CombatAI:SetSmartDodge(v) end
    end})
    Tab:AddToggle({Name = "AdaptiveCombo", Flag = "AdaptiveCombo", Default = false, Callback = function(v)
        A.F.AdaptiveCombo = v
        if A.CombatAI then A.CombatAI:SetAdaptiveCombo(v) end
    end})
    Tab:AddToggle({Name = "AntiCombo", Flag = "AntiCombo", Default = false, Callback = function(v)
        A.F.AntiCombo = v
        if A.CombatAI then A.CombatAI:SetAntiCombo(v) end
    end})
    local S2 = Tab:AddSection("Combo Actions")
    Tab:AddButton({Name = "Aggressive Combo", Callback = function()
        if A.CombatAI then local target = A.CombatAI:SelectTarget()
        if target then A.CombatAI:AggressiveCombo(target) end end
    end})
    Tab:AddButton({Name = "Burst Combo", Callback = function()
        if A.CombatAI then local target = A.CombatAI:SelectTarget()
        if target then A.CombatAI:BurstCombo(target) end end
    end})
    Tab:AddButton({Name = "Execute Combo", Callback = function()
        if A.CombatAI then local target = A.CombatAI:SelectTarget()
        if target then A.CombatAI:ExecuteCombo(target) end end
    end})
    Tab:AddButton({Name = "StunLock Combo", Callback = function()
        if A.CombatAI then local target = A.CombatAI:SelectTarget()
        if target then A.CombatAI:StunLockCombo(target) end end
    end})
    local S3 = Tab:AddSection("Target Selection")
    Tab:AddButton({Name = "Select Smart Target", Callback = function()
        if A.CombatAI then A.CombatAI:SelectSmartTarget() end
    end})
    Tab:AddButton({Name = "Select Closest", Callback = function()
        if A.CombatAI then A.CombatAI:SelectClosest() end
    end})
    Tab:AddButton({Name = "Select Weakest", Callback = function()
        if A.CombatAI then A.CombatAI:SelectWeakest() end
    end})
    Tab:AddButton({Name = "Select Highest Bounty", Callback = function()
        if A.CombatAI then A.CombatAI:SelectHighestBounty() end
    end})
end

-- TAB 32: MEGA FARM
do
    local Tab = W:CreateTab({Name = "MEGA FARM", Color = Color3.fromRGB(255, 140, 0), Icon = "⚡"})
    local Section = Tab:AddSection("Mega Farm Settings")
    Tab:AddToggle({Name = "MegaFarm (Ultimate)", Flag = "MegaFarm", Default = false, Callback = function(v)
        A.F.MegaFarm = v
        if A.MegaFarm then if v then A.MegaFarm:Start() else A.MegaFarm:Stop() end end
        A.Notify("MEGA FARM", v and "ULTIMATE MODE ENABLED" or "Disabled", 3)
    end})
    Tab:AddToggle({Name = "FarmAllEnemies", Flag = "FarmAllEnemies", Default = false, Callback = function(v)
        A.F.FarmAllEnemies = v
        if A.MegaFarm then A.MegaFarm:SetFarmAllEnemies(v) end
    end})
    Tab:AddToggle({Name = "FarmAllQuests", Flag = "FarmAllQuests", Default = false, Callback = function(v)
        A.F.FarmAllQuests = v
        if A.MegaFarm then A.MegaFarm:SetFarmAllQuests(v) end
    end})
    Tab:AddToggle({Name = "FarmAllZones", Flag = "FarmAllZones", Default = false, Callback = function(v)
        A.F.FarmAllZones = v
        if A.MegaFarm then A.MegaFarm:SetFarmAllZones(v) end
    end})
    Tab:AddToggle({Name = "AutoCollectAll", Flag = "AutoCollectAll", Default = false, Callback = function(v)
        A.F.AutoCollectAll = v
        if A.MegaFarm then A.MegaFarm:SetAutoCollectAll(v) end
    end})
    Tab:AddToggle({Name = "MegaCombo", Flag = "MegaComboToggle", Default = false, Callback = function(v)
        A.F.MegaCombo = v
        if A.MegaFarm then A.MegaFarm:SetMegaCombo(v) end
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Loot All Drops", Callback = function()
        if A.MegaFarm then A.MegaFarm:LootAllDrops() end
        A.Notify("MEGA FARM", "Looting all drops...", 2)
    end})
    Tab:AddButton({Name = "Collect Everything", Callback = function()
        if A.MegaFarm then A.MegaFarm:CollectEverything() end
        A.Notify("MEGA FARM", "Collecting everything...", 2)
    end})
    Tab:AddLabel("Kills: 0 | Quests: 0 | Drops: 0 | Gold: 0")
end

-- TAB 33: Auto Events
do
    local Tab = W:CreateTab({Name = "Auto Events", Color = Color3.fromRGB(255, 215, 0), Icon = "🎪"})
    local Section = Tab:AddSection("Event Settings")
    Tab:AddToggle({Name = "AutoTriggerAllEvents", Flag = "AutoTriggerAllEvents", Default = false, Callback = function(v)
        A.F.AutoTriggerAllEvents = v
        if A.AutoEvents then if v then A.AutoEvents:Start() else A.AutoEvents:Stop() end end
        A.Notify("Auto Events", v and "All events triggered" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "AutoTriggerRaids", Flag = "AutoTriggerRaids", Default = false, Callback = function(v)
        A.F.AutoTriggerRaids = v
        if A.AutoEvents then if v then A.AutoEvents:TriggerRaids(true) else A.AutoEvents:TriggerRaids(false) end end
    end})
    Tab:AddToggle({Name = "AutoTriggerFactory", Flag = "AutoTriggerFactory", Default = false, Callback = function(v)
        A.F.AutoTriggerFactory = v
        if A.AutoEvents then if v then A.AutoEvents:TriggerFactory(true) else A.AutoEvents:TriggerFactory(false) end end
    end})
    Tab:AddToggle({Name = "AutoTriggerSeaBeast", Flag = "AutoTriggerSeaBeast", Default = false, Callback = function(v)
        A.F.AutoTriggerSeaBeast = v
        if A.AutoEvents then if v then A.AutoEvents:TriggerSeaBeast(true) else A.AutoEvents:TriggerSeaBeast(false) end end
    end})
    Tab:AddToggle({Name = "AutoTerrorShark", Flag = "AutoTerrorSharkEvent", Default = false, Callback = function(v)
        A.F.AutoTerrorShark = v
        if A.AutoEvents then if v then A.AutoEvents:TriggerTerrorShark(true) else A.AutoEvents:TriggerTerrorShark(false) end end
    end})
    Tab:AddToggle({Name = "AutoKitsune", Flag = "AutoKitsuneEvent", Default = false, Callback = function(v)
        A.F.AutoKitsune = v
        if A.AutoEvents then if v then A.AutoEvents:TriggerKitsune(true) else A.AutoEvents:TriggerKitsune(false) end end
    end})
    local S2 = Tab:AddSection("Trigger Actions")
    Tab:AddButton({Name = "Trigger Raid", Callback = function()
        if A.AutoEvents then A.AutoEvents:TriggerRaids() end
        A.Notify("Auto Events", "Triggering raid...", 2)
    end})
    Tab:AddButton({Name = "Trigger Factory", Callback = function()
        if A.AutoEvents then A.AutoEvents:TriggerFactory() end
        A.Notify("Auto Events", "Triggering factory...", 2)
    end})
    Tab:AddButton({Name = "Trigger Sea Beast", Callback = function()
        if A.AutoEvents then A.AutoEvents:TriggerSeaBeast() end
        A.Notify("Auto Events", "Triggering sea beast...", 2)
    end})
    Tab:AddButton({Name = "Trigger Law Raid", Callback = function()
        if A.AutoEvents then A.AutoEvents:TriggerLawRaid() end
        A.Notify("Auto Events", "Triggering Law raid...", 2)
    end})
    Tab:AddButton({Name = "Trigger Dough King", Callback = function()
        if A.AutoEvents then A.AutoEvents:TriggerDoughKing() end
        A.Notify("Auto Events", "Triggering Dough King...", 2)
    end})
    Tab:AddButton({Name = "Trigger Terror Shark", Callback = function()
        if A.AutoEvents then A.AutoEvents:TriggerTerrorShark() end
        A.Notify("Auto Events", "Triggering Terror Shark...", 2)
    end})
end

-- TAB 34: Anti-Detect
do
    local Tab = W:CreateTab({Name = "Anti-Detect", Color = Color3.fromRGB(0, 200, 0), Icon = "🛡️"})
    local Section = Tab:AddSection("Anti-Detection Settings")
    Tab:AddToggle({Name = "AntiDetection", Flag = "AntiDetection", Default = false, Callback = function(v)
        A.F.AntiDetection = v
        if A.AntiDetect then if v then A.AntiDetect:Start() else A.AntiDetect:Stop() end end
        A.Notify("Anti-Detect", v and "Protection ENABLED" or "Disabled", 2)
    end})
    Tab:AddToggle({Name = "AntiReport", Flag = "AntiReport", Default = false, Callback = function(v)
        A.F.AntiReport = v
        if A.AntiDetect then A.AntiDetect:SetAntiReport(v) end
    end})
    Tab:AddToggle({Name = "StealthMovement", Flag = "StealthMovement", Default = false, Callback = function(v)
        A.F.StealthMovement = v
        if A.AntiDetect then A.AntiDetect:SetStealthMovement(v) end
    end})
    Tab:AddToggle({Name = "FullProtection", Flag = "FullProtection", Default = false, Callback = function(v)
        A.F.FullProtection = v
        if A.AntiDetect then A.AntiDetect:SetFullProtection(v) end
        A.Notify("Anti-Detect", "Full protection " .. (v and "enabled" or "disabled"), 2)
    end})
    local S2 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Emergency Teleport", Callback = function()
        if A.AntiDetect then A.AntiDetect:EmergencyTeleport() end
        A.Notify("Anti-Detect", "EMERGENCY TELEPORT ACTIVATED!", 5)
    end})
    Tab:AddButton({Name = "Enable Stealth", Callback = function()
        if A.AntiDetect then A.AntiDetect:EnableStealth() end
        A.Notify("Anti-Detect", "Stealth mode enabled", 2)
    end})
    Tab:AddButton({Name = "Disable Stealth", Callback = function()
        if A.AntiDetect then A.AntiDetect:DisableStealth() end
        A.Notify("Anti-Detect", "Stealth mode disabled", 2)
    end})
end

-- TAB 35: AUTO PILOT
do
    local Tab = W:CreateTab({Name = "AUTO PILOT", Color = Color3.fromRGB(0, 180, 180), Icon = "🤖"})
    local Section = Tab:AddSection("Auto Pilot Settings")
    Tab:AddToggle({Name = "AutoPilot (Play For Me)", Flag = "AutoPilot", Default = false, Callback = function(v)
        A.F.AutoPilot = v
        if A.AutoPilot then if v then A.AutoPilot:Start() else A.AutoPilot:Stop() end end
        PilotStatus = v and "Running" or "Idle"
        A.Notify("AUTO PILOT", v and "PLAYING FOR YOU!" or "Disabled", 3)
    end})
    local S2 = Tab:AddSection("What It Does")
    Tab:AddLabel("This plays the ENTIRE game for you!")
    Tab:AddLabel("From Level 1 to 2550 automatically!")
    Tab:AddLabel("Auto quest, auto farm, auto stats, auto equip!")
    local S3 = Tab:AddSection("Features")
    Tab:AddLabel("1. Auto accepts and completes quests")
    Tab:AddLabel("2. Auto kills quest mobs")
    Tab:AddLabel("3. Auto distributes stats")
    Tab:AddLabel("4. Auto equips best weapons")
    Tab:AddLabel("5. Auto travels between seas")
    Tab:AddLabel("6. Auto farms raids for fragments")
    Tab:AddLabel("7. Progress display with time tracking")
    local S4 = Tab:AddSection("Controls")
    Tab:AddButton({Name = "Start Auto Pilot", Callback = function()
if A.AutoPilot then A.AutoPilot:Start() end
        PilotStatus = "Running"
        A.Notify("AUTO PILOT", "Starting full auto pilot...", 3)
    end})
    Tab:AddButton({Name = "Stop Auto Pilot", Callback = function()
if A.AutoPilot then A.AutoPilot:Stop() end
        PilotStatus = "Stopped"
        A.Notify("AUTO PILOT", "Auto pilot stopped!", 2)
    end})
    Tab:AddLabel("Status: Idle")
end

-- TAB 36: Info
do
    local Tab = W:CreateTab({Name = "Info", Color = Color3.fromRGB(128, 128, 128), Icon = "ℹ️"})
    local Section = Tab:AddSection("Apex Hub v13.0")
    Tab:AddLabel("Apex Hub v13.0 - APEX ULTIMATE")
    Tab:AddLabel("Version: 13.0.0")
    Tab:AddLabel("Architecture: Modular | Modules: 32 | Tabs: 36 | Features: 200+")
    Tab:AddLabel("Executor: " .. (A.EXEC or "Unknown"))
    local S2 = Tab:AddSection("Module List")
    Tab:AddLabel("UI | Farm | BossFarm | Mastery | Stats | FruitManager")
    Tab:AddLabel("Raid | CDK | Bounty | SeaEvents | Race | Dungeon")
    Tab:AddLabel("Shop | Fishing | Trading | ESP | MovementHack | Teleport")
    Tab:AddLabel("SpecialQuest | Server | Advanced | Awakening | SeaProgress")
    Tab:AddLabel("AdvCombat | World | Unique | CombatAI | MegaFarm")
    Tab:AddLabel("AutoEvents | AntiDetect | AutoPilot")
    Tab:AddLabel("CombatMechanics | AdvSea | Visual | RaceV4Adv")
    local S3 = Tab:AddSection("Credits")
    Tab:AddLabel("Apex Hub Development Team")
    Tab:AddLabel("v13.0 - APEX ULTIMATE Release")
    local S4 = Tab:AddSection("Actions")
    Tab:AddButton({Name = "Copy Discord", Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/apexhub")
            A.Notify("Info", "Discord link copied!", 2)
        end
    end})
    Tab:AddButton({Name = "Copy Script", Callback = function()
        if setclipboard then
            setclipboard(game:HttpGet("https://raw.githubusercontent.com/apexhub/main/apexv13.lua"))
            A.Notify("Info", "Script link copied!", 2)
        end
    end})
end

-- ==================== TAB 37: COMBAT MECHANICS ====================
do
    local Tab = W:CreateTab({Name = "Combat", Color = Color3.fromRGB(255, 30, 60), Icon = "💥"})
    local S1 = Tab:AddSection("Fast Attack")
    Tab:AddToggle({Name = "Fast Attack (Normal)", Flag = "FastAttackNormal", Default = false, Callback = function(v) A.F.FastAttackNormal = v end})
    Tab:AddToggle({Name = "Fast Attack (Extreme)", Flag = "FastAttackExtreme", Default = false, Callback = function(v) A.F.FastAttackExtreme = v end})
    Tab:AddToggle({Name = "Fast Attack (Instant)", Flag = "FastAttackInstant", Default = false, Callback = function(v) A.F.FastAttackInstant = v end})
    Tab:AddToggle({Name = "No Cooldown Attack", Flag = "NoCooldownAttack", Default = false, Callback = function(v) A.F.NoCooldownAttack = v end})
    local S2 = Tab:AddSection("Hitbox & Magnet")
    Tab:AddToggle({Name = "Hitbox Expansion", Flag = "HitboxExpand", Default = false, Callback = function(v)
        A.F.HitboxExpand = v
        if A.CombatMech then
            A.CombatMech.AutoHitboxEnabled = v
            if v and not A.CombatMech.Active then A.CombatMech.Start() end
        end
    end})
    Tab:AddSlider({Name = "Hitbox Range", Min = 10, Max = 100, Default = 25, Flag = "HitboxExpandRange", Callback = function(v)
        A.F.HitboxExpandRange = v
        if A.CombatMech then A.CombatMech.HitboxRange = v end
    end})
    Tab:AddToggle({Name = "Mob Magnet", Flag = "MobMagnet", Default = false, Callback = function(v)
        A.F.MobMagnet = v
        if A.CombatMech then
            A.CombatMech.BringMobsEnabled = v
            if v and not A.CombatMech.Active then A.CombatMech.Start() end
        end
    end})
    Tab:AddSlider({Name = "Magnet Range", Min = 20, Max = 200, Default = 100, Flag = "MobMagnetRange", Callback = function(v)
        A.F.MobMagnetRange = v
        if A.CombatMech then A.CombatMech.BringRange = v end
    end})
    Tab:AddToggle({Name = "Mob Freeze", Flag = "MobFreeze", Default = false, Callback = function(v)
        A.F.MobFreeze = v
        if A.CombatMech then
            A.CombatMech.FreezeMobsEnabled = v
            if v and not A.CombatMech.Active then A.CombatMech.Start() end
        end
    end})
    Tab:AddSlider({Name = "Freeze Range", Min = 20, Max = 200, Default = 100, Flag = "MobFreezeRange", Callback = function(v)
        A.F.MobFreezeRange = v
        if A.CombatMech then A.CombatMech.FreezeRange = v end
    end})
    local S3 = Tab:AddSection("PvP Combat")
    Tab:AddToggle({Name = "Silent Aim", Flag = "SilentAim", Default = false, Callback = function(v)
        A.F.SilentAim = v
        if A.CombatMech then
            A.CombatMech.SilentAimEnabled = v
            if v and not A.CombatMech.Active then A.CombatMech.Start() end
        end
    end})
    Tab:AddToggle({Name = "Multi-Target Lock", Flag = "MultiTargetLock", Default = false, Callback = function(v) A.F.MultiTargetLock = v end})
    Tab:AddToggle({Name = "Anti-Knockback", Flag = "AntiKnockback", Default = false, Callback = function(v)
        A.F.AntiKnockback = v
        if A.CombatMech then
            A.CombatMech.AntiKnockbackEnabled = v
            if v and not A.CombatMech.Active then A.CombatMech.Start() end
        end
    end})
    Tab:AddToggle({Name = "Infinite Dash", Flag = "InfiniteDash", Default = false, Callback = function(v)
        A.F.InfiniteDash = v
        if A.CombatMech then
            A.CombatMech.InfiniteDashEnabled = v
            if v and not A.CombatMech.Active then A.CombatMech.Start() end
        end
    end})
    Tab:AddToggle({Name = "Unlimited Dash", Flag = "UnlimitedDash", Default = false, Callback = function(v) A.F.UnlimitedDash = v end})
    Tab:AddToggle({Name = "Wall Combo", Flag = "WallCombo", Default = false, Callback = function(v) A.F.WallCombo = v end})
    Tab:AddToggle({Name = "Air Combo", Flag = "AirCombo", Default = false, Callback = function(v) A.F.AirCombo = v end})
    Tab:AddToggle({Name = "Target Lock & Spectate", Flag = "TargetLockSpectate", Default = false, Callback = function(v) A.F.TargetLockSpectate = v end})
    local S4 = Tab:AddSection("Weapon & Skills")
    Tab:AddToggle({Name = "Fast Weapon Switch", Flag = "FastWeaponSwitch", Default = false, Callback = function(v) A.F.FastWeaponSwitch = v end})
    Tab:AddToggle({Name = "Skill Cancel (Feint)", Flag = "SkillCancel", Default = false, Callback = function(v) A.F.SkillCancel = v end})
    local S5 = Tab:AddSection("Chest")
    Tab:AddToggle({Name = "Anti-Ban Chest Farm", Flag = "AntiBanChestFarm", Default = false, Callback = function(v) A.F.AntiBanChestFarm = v end})
    Tab:AddToggle({Name = "Bypass Chest Speed", Flag = "BypassChestSpeed", Default = false, Callback = function(v) A.F.BypassChestSpeed = v end})
end

-- ==================== TAB 38: ADVANCED SEA ====================
do
    local Tab = W:CreateTab({Name = "Adv Sea", Color = Color3.fromRGB(0, 150, 255), Icon = "🐋"})
    local advSeaMap = {
        LeviathanFarm = "AutoLeviathan",
        MegalodonFarm = "AutoMegalodon",
        GhostShipFarm = "AutoGhostShip",
        PiranhaFarm = "AutoPiranha",
    }
    local function advSeaFlag(name, value)
        A.F[name] = value
        if A.AdvSea then
            local internal = advSeaMap[name]
            if internal then
                A.AdvSea.SetFlag(internal, value)
            else
                A.AdvSea.SetFlag(name, value)
            end
            if value and not A.AdvSea._running then A.AdvSea.Start() end
        end
    end
    local S1 = Tab:AddSection("Leviathan")
    Tab:AddToggle({Name = "Auto Leviathan Farm", Flag = "LeviathanFarm", Default = false, Callback = function(v) advSeaFlag("LeviathanFarm", v) end})
    Tab:AddToggle({Name = "Auto Harpoon", Flag = "LeviathanHarpoon", Default = false, Callback = function(v) advSeaFlag("LeviathanHarpoon", v) end})
    Tab:AddToggle({Name = "Freeze Leviathan", Flag = "LeviathanFreeze", Default = false, Callback = function(v) advSeaFlag("LeviathanFreeze", v) end})
    Tab:AddToggle({Name = "Extract Heart", Flag = "LeviathanHeart", Default = false, Callback = function(v) advSeaFlag("LeviathanHeart", v) end})
    Tab:AddToggle({Name = "Farm Scales", Flag = "LeviathanScales", Default = false, Callback = function(v) advSeaFlag("LeviathanScales", v) end})
    local S2 = Tab:AddSection("Megalodon & Ghost")
    Tab:AddToggle({Name = "Auto Megalodon", Flag = "MegalodonFarm", Default = false, Callback = function(v) advSeaFlag("MegalodonFarm", v) end})
    Tab:AddToggle({Name = "Auto Ghost Ship", Flag = "GhostShipFarm", Default = false, Callback = function(v) advSeaFlag("GhostShipFarm", v) end})
    Tab:AddToggle({Name = "Auto Piranha", Flag = "PiranhaFarm", Default = false, Callback = function(v) advSeaFlag("PiranhaFarm", v) end})
    local S3 = Tab:AddSection("Sea Navigation")
    Tab:AddToggle({Name = "Sail to Danger Zone", Flag = "SailToDanger", Default = false, Callback = function(v) advSeaFlag("SailToDanger", v) end})
    Tab:AddToggle({Name = "Sea Events Evade", Flag = "SeaEventsEvade", Default = false, Callback = function(v) advSeaFlag("SeaEventsEvade", v) end})
    Tab:AddToggle({Name = "Multi Sea Beast", Flag = "MultiSeaBeast", Default = false, Callback = function(v) advSeaFlag("MultiSeaBeast", v) end})
    local S4 = Tab:AddSection("Mirage Island")
    Tab:AddToggle({Name = "Find Mirage Island", Flag = "MirageIsland", Default = false, Callback = function(v) advSeaFlag("MirageIsland", v) end})
    Tab:AddToggle({Name = "Find Blue Gear", Flag = "BlueGear", Default = false, Callback = function(v) advSeaFlag("BlueGear", v) end})
    Tab:AddToggle({Name = "Moon Align", Flag = "MoonAlign", Default = false, Callback = function(v) advSeaFlag("MoonAlign", v) end})
    Tab:AddToggle({Name = "Resonance Activation", Flag = "Resonance", Default = false, Callback = function(v) advSeaFlag("Resonance", v) end})
    local S5 = Tab:AddSection("Raids & Defense")
    Tab:AddToggle({Name = "Auto Pirate Raid", Flag = "PirateRaid", Default = false, Callback = function(v) advSeaFlag("PirateRaid", v) end})
    Tab:AddToggle({Name = "Auto Factory Raid", Flag = "FactoryRaid", Default = false, Callback = function(v) advSeaFlag("FactoryRaid", v) end})
    Tab:AddToggle({Name = "Auto Castle Defense", Flag = "CastleDefense", Default = false, Callback = function(v) advSeaFlag("CastleDefense", v) end})
    Tab:AddToggle({Name = "Mob Spawn Counter", Flag = "MobSpawnCounter", Default = false, Callback = function(v) advSeaFlag("MobSpawnCounter", v) end})
end

-- ==================== TAB 39: VISUAL ENHANCE ====================
do
    local Tab = W:CreateTab({Name = "Visual", Color = Color3.fromRGB(255, 255, 100), Icon = "👁️"})
    local S1 = Tab:AddSection("Lighting")
    Tab:AddToggle({Name = "Full Bright", Flag = "FullBright", Default = false, Callback = function(v)
        A.F.FullBright = v
        if A.Visual then
            if v then A.Visual.FullBright() else A.Visual.ResetLighting() end
            if not A.Visual._running then A.Visual.Start() end
        end
    end})
    Tab:AddToggle({Name = "Disable Fog", Flag = "DisableFog", Default = false, Callback = function(v)
        A.F.DisableFog = v
        if A.Visual then
            A.Visual._fogEnabled = not v
            if v then A.Visual.DisableFog() end
            if not A.Visual._running then A.Visual.Start() end
        end
    end})
    local S2 = Tab:AddSection("Camera")
    Tab:AddToggle({Name = "FOV Changer", Flag = "FOVChanger", Default = false, Callback = function(v)
        A.F.FOVChanger = v
        if A.Visual then
            if v then A.Visual.SetFOV(A.F.FOVValue or 70) else A.Visual.ResetFOV() end
        end
    end})
    Tab:AddSlider({Name = "FOV Value", Min = 50, Max = 120, Default = 70, Flag = "FOVValue", Callback = function(v)
        A.F.FOVValue = v
        if A.Visual and A.F.FOVChanger then A.Visual.SetFOV(v) end
    end})
    Tab:AddToggle({Name = "Crosshair", Flag = "Crosshair", Default = false, Callback = function(v)
        A.F.Crosshair = v
        if A.Visual then
            if v then A.Visual.AddCrosshair() else A.Visual.RemoveCrosshair() end
        end
    end})
    local S3 = Tab:AddSection("Performance")
    Tab:AddToggle({Name = "FPS Boost", Flag = "FPSBoost", Default = false, Callback = function(v)
        A.F.FPSBoost = v
        if A.Visual and v then A.Visual.FPSBoost() end
    end})
    Tab:AddToggle({Name = "Disable Rendering", Flag = "DisableRendering", Default = false, Callback = function(v)
        A.F.DisableRendering = v
        if A.Visual then
            if v then A.Visual.DisableRendering() end
        end
    end})
    Tab:AddToggle({Name = "White Screen Mode", Flag = "WhiteScreen", Default = false, Callback = function(v)
        A.F.WhiteScreen = v
        if A.Visual then
            if v then A.Visual.WhiteScreenMode() end
        end
    end})
    Tab:AddToggle({Name = "Black Screen Mode", Flag = "BlackScreen", Default = false, Callback = function(v)
        A.F.BlackScreen = v
        if A.Visual then
            if v then A.Visual.BlackScreenMode() end
        end
    end})
    Tab:AddToggle({Name = "Background Mute", Flag = "BackgroundMute", Default = false, Callback = function(v)
        A.F.BackgroundMute = v
        if A.Visual then
            if v then A.Visual.BackgroundMute() else A.Visual.StopBackgroundMute() end
        end
    end})
    local S4 = Tab:AddSection("Automation")
    Tab:AddToggle({Name = "Anti-AFK", Flag = "AntiAFK", Default = false, Callback = function(v)
        A.F.AntiAFK = v
        if A.Visual then
            if v then A.Visual.AntiAFK() else A.Visual.StopAntiAFK() end
        end
    end})
    Tab:AddToggle({Name = "Auto Redeem Codes", Flag = "AutoRedeemCodes", Default = false, Callback = function(v)
        A.F.AutoRedeemCodes = v
        if A.Visual and v then A.Visual.AutoRedeemCodes() end
    end})
    Tab:AddToggle({Name = "Discord Webhook", Flag = "DiscordWebhook", Default = false, Callback = function(v) A.F.DiscordWebhook = v end})
    Tab:AddButton({Name = "Set Webhook URL", Callback = function()
        if A.Visual and A.Visual.SetWebhookURL then
            A.Visual.SetWebhookURL("")
            A.Notify("Visual", "Set webhook URL in config", 3)
        end
    end})
    local S5 = Tab:AddSection("Quick Actions")
    Tab:AddButton({Name = "Apply Full Bright Now", Callback = function()
        if A.Visual and A.Visual.FullBright then A.Visual.FullBright() end
    end})
    Tab:AddButton({Name = "FPS Boost Now", Callback = function()
        if A.Visual and A.Visual.FPSBoost then A.Visual.FPSBoost() end
    end})
    Tab:AddButton({Name = "Reset All Visuals", Callback = function()
        if A.Visual and A.Visual.ResetVisuals then A.Visual.ResetVisuals() end
    end})
end

-- ==================== TAB 40: RACE V4 ADVANCED ====================
do
    local Tab = W:CreateTab({Name = "Race+", Color = Color3.fromRGB(170, 0, 255), Icon = "🧬"})
    local function raceStart(mode)
        if A.RaceV4Adv and A.RaceV4Adv.Start then A.RaceV4Adv.Start(mode) end
    end
    local S1 = Tab:AddSection("Race V2/V3")
    Tab:AddToggle({Name = "Farm Flowers (V2)", Flag = "FarmFlowers", Default = false, Callback = function(v)
        A.F.FarmFlowers = v
        if v then raceStart("flower") end
    end})
    Tab:AddToggle({Name = "Auto V2 Quest", Flag = "V2Quest", Default = false, Callback = function(v)
        A.F.V2Quest = v
        if v then raceStart("race") end
    end})
    Tab:AddToggle({Name = "Auto V3 Quest", Flag = "V3Quest", Default = false, Callback = function(v)
        A.F.V3Quest = v
        if v then raceStart("race") end
    end})
    local S2 = Tab:AddSection("Temple of Time")
    Tab:AddToggle({Name = "Temple of Time", Flag = "TempleOfTime", Default = false, Callback = function(v) A.F.TempleOfTime = v end})
    Tab:AddToggle({Name = "Full Moon Alert", Flag = "FullMoonAlert", Default = false, Callback = function(v)
        A.F.FullMoonAlert = v
        if v then raceStart("moon") end
    end})
    local S3 = Tab:AddSection("Race Trials")
    Tab:AddToggle({Name = "Auto Trial", Flag = "AutoTrial", Default = false, Callback = function(v)
        A.F.AutoTrial = v
        if v then raceStart("trial") end
    end})
    local S4 = Tab:AddSection("V4 Gear")
    Tab:AddToggle({Name = "V4 Gear Training", Flag = "V4Gear", Default = false, Callback = function(v) A.F.V4Gear = v end})
    Tab:AddToggle({Name = "V4 Skill Tree", Flag = "V4SkillTree", Default = false, Callback = function(v) A.F.V4SkillTree = v end})
    Tab:AddToggle({Name = "V4 Awakening", Flag = "V4Awakening", Default = false, Callback = function(v)
        A.F.V4Awakening = v
        if v then raceStart("v4") end
    end})
    local S5 = Tab:AddSection("Weapon Unlocks")
    Tab:AddToggle({Name = "Auto Superhuman", Flag = "AutoSuperhuman", Default = false, Callback = function(v) A.F.AutoSuperhuman = v end})
    Tab:AddToggle({Name = "Auto Death Step", Flag = "AutoDeathStep", Default = false, Callback = function(v) A.F.AutoDeathStep = v end})
    Tab:AddToggle({Name = "Auto Sharkman Karate", Flag = "AutoSharkmanKarate", Default = false, Callback = function(v) A.F.AutoSharkmanKarate = v end})
    Tab:AddToggle({Name = "Auto Electric Claw", Flag = "AutoElectricClaw", Default = false, Callback = function(v) A.F.AutoElectricClaw = v end})
    Tab:AddToggle({Name = "Auto Godhuman", Flag = "AutoGodhuman", Default = false, Callback = function(v) A.F.AutoGodhuman = v end})
    Tab:AddToggle({Name = "Auto Dragon Talon", Flag = "AutoDragonTalon", Default = false, Callback = function(v) A.F.AutoDragonTalon = v end})
    Tab:AddToggle({Name = "Auto Sanguine Art", Flag = "AutoSanguineArt", Default = false, Callback = function(v) A.F.AutoSanguineArt = v end})
    local S6 = Tab:AddSection("Weapon Quests")
    Tab:AddToggle({Name = "Auto Saber Quest", Flag = "AutoSaberQuest", Default = false, Callback = function(v)
        A.F.AutoSaberQuest = v
        if v then raceStart("saber") end
    end})
    Tab:AddToggle({Name = "Auto Tushita Quest", Flag = "AutoTushitaQuest", Default = false, Callback = function(v) A.F.AutoTushitaQuest = v end})
    Tab:AddToggle({Name = "Auto Yama Quest", Flag = "AutoYamaQuest", Default = false, Callback = function(v) A.F.AutoYamaQuest = v end})
    Tab:AddToggle({Name = "Auto Soul Guitar", Flag = "AutoSoulGuitar", Default = false, Callback = function(v)
        A.F.AutoSoulGuitar = v
        if v then raceStart("soulguitar") end
    end})
    Tab:AddToggle({Name = "Auto TTK", Flag = "AutoTTK", Default = false, Callback = function(v)
        A.F.AutoTTK = v
        if v then raceStart("ttk") end
    end})
    local S7 = Tab:AddSection("Haki")
    Tab:AddToggle({Name = "Train Observation V2", Flag = "TrainObservationV2", Default = false, Callback = function(v) A.F.TrainObservationV2 = v end})
    Tab:AddToggle({Name = "Buy All Haki Colors", Flag = "BuyAllHakiColors", Default = false, Callback = function(v)
        A.F.BuyAllHakiColors = v
        if v then raceStart("haki") end
    end})
    Tab:AddButton({Name = "Unlock ALL Weapons", Callback = function()
        if A.RaceV4Adv and A.RaceV4Adv.AutoAllWeaponUnlocks then A.RaceV4Adv.AutoAllWeaponUnlocks() end
    end})
end

-- ==================== TAB 41: BERRY FARM ====================
do
    local Tab = W:CreateTab({Name = "Berry Farm", Color = Color3.fromRGB(139, 0, 139), Icon = "🫐"})
    local S1 = Tab:AddSection("Berry Farming")
    Tab:AddToggle({Name = "Auto Berry Farm", Flag = "BerryFarm", Default = false, Callback = function(v)
        A.F.BerryFarm = v
        if A.Berry then if v then A.Berry.Start() else A.Berry.Stop() end end
    end})
    Tab:AddToggle({Name = "Berry ESP", Flag = "BerryESP", Default = false, Callback = function(v)
        A.F.BerryESP = v
        if A.Berry then A.F.BerryESP = v end
    end})
    local S2 = Tab:AddSection("Berry Stats")
    Tab:AddLabel("Collected: 0")
    Tab:AddLabel("Rate: 0/min")
    Tab:AddButton({Name = "Refresh Stats", Callback = function()
        if A.Berry and A.Berry.GetStats then
            local s = A.Berry.GetStats()
            A.Notify("Berry", "Total: " .. tostring(s.TotalCollected) .. " | Rate: " .. s.Rate, 3)
        end
    end})
end

-- ==================== TAB 42: GOALS ====================
do
    local Tab = W:CreateTab({Name = "Goals", Color = Color3.fromRGB(0, 200, 255), Icon = "🎯"})
    local S1 = Tab:AddSection("Goal System")
    Tab:AddToggle({Name = "Enable Goal System", Flag = "GoalSystem", Default = false, Callback = function(v)
        A.F.GoalSystem = v
        if A.Goals then if v then A.Goals.Start() else A.Goals.Stop() end end
    end})
    Tab:AddToggle({Name = "Level Goal", Flag = "GoalLevel", Default = false, Callback = function(v)
        A.F.GoalLevel = v
    end})
    Tab:AddTextbox({Name = "Target Level", Placeholder = "e.g. 2550", Callback = function(text)
        local target = tonumber(text)
        if target and A.Goals then A.Goals.SetGoal("Level", target) end
    end})
    Tab:AddToggle({Name = "Beli Goal", Flag = "GoalBeli", Default = false, Callback = function(v)
        A.F.GoalBeli = v
    end})
    Tab:AddTextbox({Name = "Target Beli", Placeholder = "e.g. 1000000", Callback = function(text)
        local target = tonumber(text)
        if target and A.Goals then A.Goals.SetGoal("Beli", target) end
    end})
    Tab:AddToggle({Name = "Fragments Goal", Flag = "GoalFragments", Default = false, Callback = function(v)
        A.F.GoalFragments = v
    end})
    Tab:AddTextbox({Name = "Target Fragments", Placeholder = "e.g. 5000", Callback = function(text)
        local target = tonumber(text)
        if target and A.Goals then A.Goals.SetGoal("Fragments", target) end
    end})
    Tab:AddToggle({Name = "Goal Notifications", Flag = "GoalNotification", Default = true, Callback = function(v)
        A.F.GoalNotification = v
    end})
    local S2 = Tab:AddSection("Active Goals")
    Tab:AddButton({Name = "Show Goals", Callback = function()
        if A.Goals and A.Goals.GetAllGoals then
            local goals = A.Goals.GetAllGoals()
            if #goals == 0 then
                A.Notify("Goals", "No goals set", 2)
            else
                for _, g in ipairs(goals) do
                    A.Notify(g.Category, string.format("%.1f%% | ETA: %s", g.Progress, g.ETA or "N/A"), 3)
                end
            end
        end
    end})
    Tab:AddButton({Name = "Clear All Goals", Callback = function()
        if A.Goals and A.Goals.ClearGoal then A.Goals.ClearGoal() end
        A.Notify("Goals", "All goals cleared", 2)
    end})
end

-- ==================== TAB 43: STATS HUD ====================
do
    local Tab = W:CreateTab({Name = "Stats", Color = Color3.fromRGB(0, 255, 100), Icon = "📈"})
    local S1 = Tab:AddSection("Global Stats")
    Tab:AddToggle({Name = "Enable Stats Tracking", Flag = "StatsHUD", Default = false, Callback = function(v)
        A.F.StatsHUD = v
        if A.StatsHUD then if v then A.StatsHUD.Start() else A.StatsHUD.Stop() end end
    end})
    Tab:AddButton({Name = "Show Current Stats", Callback = function()
        if A.StatsHUD and A.StatsHUD.GetAll then
            local s = A.StatsHUD.GetAll()
            A.Notify("Stats", string.format("Level: %d | Beli: %s | Frags: %s", s.Level, tostring(s.Beli), tostring(s.Fragments)), 4)
        end
    end})
    Tab:AddButton({Name = "Show Rates / Hour", Callback = function()
        if A.StatsHUD and A.StatsHUD.GetAll then
            local s = A.StatsHUD.GetAll()
            A.Notify("Rates", string.format("XP/hr: %d | Beli/hr: %d | Frag/hr: %d", s.XPPerHour, s.BeliPerHour, s.FragPerHour), 4)
        end
    end})
    Tab:AddButton({Name = "Mastery Rates", Callback = function()
        if A.StatsHUD and A.StatsHUD.GetAll then
            local s = A.StatsHUD.GetAll()
            A.Notify("Mastery", string.format("Sword/hr: %d | Gun/hr: %d | Melee/hr: %d", s.SwordPerHour, s.GunPerHour, s.MeleePerHour), 4)
        end
    end})
end

-- ==================== TAB 44: COMBAT DODGE ====================
do
    local Tab = W:CreateTab({Name = "Dodge AI", Color = Color3.fromRGB(255, 200, 0), Icon = "🤸"})
    local S1 = Tab:AddSection("Auto Dodge")
    Tab:AddToggle({Name = "Enable Combat Dodge", Flag = "CombatDodge", Default = false, Callback = function(v)
        A.F.CombatDodge = v
        if A.CombatDodge then if v then A.CombatDodge.Start() else A.CombatDodge.Stop() end end
    end})
    Tab:AddToggle({Name = "Projectile Dodge", Flag = "ProjectileDodge", Default = false, Callback = function(v)
        A.F.ProjectileDodge = v
        if A.CombatDodge then A.F.ProjectileDodge = v end
    end})
    Tab:AddToggle({Name = "Skill Dodge", Flag = "SkillDodge", Default = false, Callback = function(v)
        A.F.SkillDodge = v
        if A.CombatDodge then A.F.SkillDodge = v end
    end})
    Tab:AddToggle({Name = "Area Dodge", Flag = "AreaDodge", Default = false, Callback = function(v)
        A.F.AreaDodge = v
        if A.CombatDodge then A.F.AreaDodge = v end
    end})
    Tab:AddToggle({Name = "Observation Dodge", Flag = "ObservationDodge", Default = false, Callback = function(v)
        A.F.ObservationDodge = v
        if A.CombatDodge then A.F.ObservationDodge = v end
    end})
end

-- ==================== TAB 45: SOUND & GUI ====================
do
    local Tab = W:CreateTab({Name = "Sound / GUI", Color = Color3.fromRGB(200, 200, 200), Icon = "🔊"})
    local S1 = Tab:AddSection("Sound Notifications")
    Tab:AddToggle({Name = "Enable Sounds", Flag = "Sounds", Default = true, Callback = function(v)
        A.F.Sounds = v
        if A.SoundGui then A.SoundGui.SoundEnabled = v end
    end})
    Tab:AddButton({Name = "Test Sound", Callback = function()
        if A.SoundGui and A.SoundGui.PlaySound then A.SoundGui.PlaySound("notify") end
    end})
    local S2 = Tab:AddSection("GUI Control")
    Tab:AddToggle({Name = "Panic Button (Ctrl)", Flag = "PanicButton", Default = false, Callback = function(v)
        A.F.PanicButton = v
        if A.SoundGui then
            if v then A.SoundGui.Start() else A.SoundGui.Stop() end
        end
    end})
    Tab:AddToggle({Name = "Panic Stops All Toggles", Flag = "PanicStop", Default = true, Callback = function(v)
        A.F.PanicStop = v
        if A.SoundGui then A.SoundGui.PanicStop = v end
    end})
    Tab:AddButton({Name = "Toggle All ON", Callback = function()
        if A.SoundGui and A.SoundGui.ToggleAll then A.SoundGui.ToggleAll(true) end
    end})
    Tab:AddButton({Name = "Toggle All OFF", Callback = function()
        if A.SoundGui and A.SoundGui.ToggleAll then A.SoundGui.ToggleAll(false) end
    end})
    Tab:AddButton({Name = "Hide / Show GUI (F8)", Callback = function()
        if A.SoundGui and A.SoundGui.ToggleGui then A.SoundGui.ToggleGui() end
    end})
end

-- ==================== TAB 46: COLLECTION ====================
do
    local Tab = W:CreateTab({Name = "Collection", Color = Color3.fromRGB(255, 100, 200), Icon = "📚"})
    local S1 = Tab:AddSection("Inventory & Collection")
    Tab:AddButton({Name = "Inventory Value", Callback = function()
        if A.Collection and A.Collection.GetInventoryValue then
            A.Notify("Collection", "Inventory value: " .. tostring(A.Collection.GetInventoryValue()), 3)
        end
    end})
    Tab:AddButton({Name = "Collection Progress", Callback = function()
        if A.Collection and A.Collection.GetCollectionSummary then
            local s = A.Collection.GetCollectionSummary()
            A.Notify("Collection", string.format("Owned: %d/%d (%d%%) | Value: %d", s.Owned, s.Total, s.Completion, s.Value), 5)
        end
    end})
    Tab:AddButton({Name = "Missing Fruits", Callback = function()
        if A.Collection and A.Collection.GetMissingFruits then
            local missing = A.Collection.GetMissingFruits()
            if #missing == 0 then
                A.Notify("Collection", "You own all fruits!", 2)
            else
                A.Notify("Collection", #missing .. " missing (check next)", 3)
            end
        end
    end})
    Tab:AddTextbox({Name = "Check Fruit Value", Placeholder = "e.g. Dough", Callback = function(text)
        if A.Collection and A.Collection.GetFruitValue and text and text ~= "" then
            A.Notify("Collection", text .. " value: " .. tostring(A.Collection.GetFruitValue(text)), 3)
        end
    end})
end

-- ==================== TAB 47: AUTO RECOVERY ====================
do
    local Tab = W:CreateTab({Name = "Recovery", Color = Color3.fromRGB(0, 150, 200), Icon = "🚑"})
    local S1 = Tab:AddSection("Auto Recovery")
    Tab:AddToggle({Name = "Enable Auto Recovery", Flag = "AutoRecovery", Default = false, Callback = function(v)
        A.F.AutoRecovery = v
        if A.AutoRecovery then if v then A.AutoRecovery.Start() else A.AutoRecovery.Stop() end end
    end})
    Tab:AddToggle({Name = "Rejoin on Error", Flag = "RejoinOnError", Default = true, Callback = function(v)
        A.F.RejoinOnError = v
        if A.AutoRecovery then A.AutoRecovery.RejoinOnError = v end
    end})
    Tab:AddButton({Name = "Rejoin Server Now", Callback = function()
        if A.AutoRecovery and A.AutoRecovery.Rejoin then A.AutoRecovery.Rejoin() end
    end})
    Tab:AddButton({Name = "Server Hop Now", Callback = function()
        if A.AutoRecovery and A.AutoRecovery.Hop then A.AutoRecovery.Hop() end
    end})
end

-- ==================== TAB 48: SMART AI (RARE FEATURES) ====================
do
    local Tab = W:CreateTab({Name = "Smart AI", Color = Color3.fromRGB(180, 0, 220), Icon = "🧠"})
    local S1 = Tab:AddSection("Smart AI Suite")
    Tab:AddToggle({Name = "Enable Smart AI", Flag = "SmartAI", Default = false, Callback = function(v)
        A.F.SmartAI = v
        if A.Smart then if v then A.Smart.Start() else A.Smart.Stop() end end
    end})
    local S2 = Tab:AddSection("Route Optimizer")
    Tab:AddToggle({Name = "Optimize Farm Paths", Flag = "RouteOptimize", Default = false, Callback = function(v)
        A.F.RouteOptimize = v
        if A.Smart then A.Smart.RouteOptimize = v end
    end})
    Tab:AddButton({Name = "Optimize Current Route", Callback = function()
        if A.Smart and A.Smart.OptimizeRoute then
            local pts = {{Position = A.HRP() and A.HRP().Position + Vector3.new(20,0,0)}, {Position = A.HRP() and A.HRP().Position + Vector3.new(-20,0,10)}}
            local order = A.Smart.OptimizeRoute(pts)
            A.Notify("Smart", "Route optimized: " .. tostring(#order) .. " stops", 3)
        end
    end})
    local S3 = Tab:AddSection("Economy Master")
    Tab:AddToggle({Name = "Enable Economy Master", Flag = "EconomyMaster", Default = false, Callback = function(v)
        A.F.EconomyMaster = v
        if A.Smart then A.Smart.EconomyMaster = v end
    end})
    Tab:AddButton({Name = "Get Economy Advice", Callback = function()
        if A.Smart and A.Smart.GetEconomyAdvice then
            local a = A.Smart.GetEconomyAdvice()
            A.Notify("Economy", "Beli: " .. tostring(a.Beli) .. " | " .. a.Reason, 4)
        end
    end})
    local S4 = Tab:AddSection("Session Memory")
    Tab:AddToggle({Name = "Enable Session Memory", Flag = "SessionMemory", Default = false, Callback = function(v)
        A.F.SessionMemory = v
        if A.Smart then A.Smart.SessionMemory = v end
    end})
    Tab:AddButton({Name = "Save Session Now", Callback = function()
        if A.Smart and A.Smart.RecordSession then
            local s = A.Smart.RecordSession()
            A.Notify("Smart", "Session saved (Level " .. tostring(s.Level) .. ")", 3)
        end
    end})
    Tab:AddButton({Name = "Show Progress Report", Callback = function()
        if A.Smart and A.Smart.GetProgressReport then
            local r = A.Smart.GetProgressReport()
            if r then
                A.Notify("Smart", string.format("Hours: %.1f | Kills: %d | Level: %d", r.HoursPlayed, r.TotalKills, r.LastLevel), 5)
            else
                A.Notify("Smart", "No session data yet", 2)
            end
        end
    end})
    local S5 = Tab:AddSection("Humanization / Precision")
    Tab:AddToggle({Name = "Human-like Delays", Flag = "Humanization", Default = false, Callback = function(v)
        A.F.Humanization = v
        if A.Smart then A.Smart.Humanization = v end
    end})
    Tab:AddToggle({Name = "Precision Farming", Flag = "PrecisionFarm", Default = false, Callback = function(v)
        A.F.PrecisionFarm = v
        if A.Smart then A.Smart.PrecisionFarm = v end
    end})
    Tab:AddButton({Name = "Test Jitter Delay", Callback = function()
        if A.Smart and A.Smart.Jitter then
            local j = A.Smart.Jitter(1, 0.4)
            A.Notify("Smart", "Jittered delay: " .. string.format("%.2fs", j), 2)
        end
    end})
end

print("[Apex] All 48 tabs loaded!")
