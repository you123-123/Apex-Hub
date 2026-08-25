-- ══════════════════════════════════════════════════════════════════════════
-- IMPORTS from _G.Apex (Part1 exports)
-- ══════════════════════════════════════════════════════════════════════════
local C = _G.Apex.C; local F = _G.Apex.F
local P = _G.Apex.P; local RS = _G.Apex.RS; local WS = _G.Apex.WS
local UIS = _G.Apex.UIS; local TS = _G.Apex.TS; local HS = _G.Apex.HS
local RS2 = _G.Apex.RS2; local VU = _G.Apex.VU; local VIM = _G.Apex.VIM
local TPS = _G.Apex.TPS; local SG = _G.Apex.SG
local Debris = _G.Apex.Debris; local PathService = _G.Apex.PathService
local Stats = _G.Apex.Stats; local Light = _G.Apex.Light
local LP = _G.Apex.LP; local Mouse = _G.Apex.Mouse; local Cam = _G.Apex.Cam
local EXEC = _G.Apex.EXEC; local EXP = _G.Apex.EXP
local HTTP = _G.Apex.HTTP; local Clip = _G.Apex.Clip; local Notify = _G.Apex.Notify
local Alive = _G.Apex.Alive; local HRP = _G.Apex.HRP
local Hum = _G.Apex.Hum; local HP = _G.Apex.HP
local Lv = _G.Apex.Lv; local Beli = _G.Apex.Beli
local Frags = _G.Apex.Frags; local Sea = _G.Apex.Sea
local Bounty = _G.Apex.Bounty; local Island = _G.Apex.Island
local GetRace = _G.Apex.GetRace
local EnsureFolder = _G.Apex.EnsureFolder
local SaveConfig = _G.Apex.SaveConfig; local LoadConfig = _G.Apex.LoadConfig
local DeleteConfig = _G.Apex.DeleteConfig
local HumanizedOffset = _G.Apex.HumanizedOffset
local TpTo = _G.Apex.TpTo; local InstantTP = _G.Apex.InstantTP
local CancelMove = _G.Apex.CancelMove
local SmartPathfind = _G.Apex.SmartPathfind
local CommF = _G.Apex.CommF; local CommE = _G.Apex.CommE
local FireR = _G.Apex.FireR; local RandDelay = _G.Apex.RandDelay
local ApplyJitter = _G.Apex.ApplyJitter
local GetJitteredPosition = _G.Apex.GetJitteredPosition
local SuperAttack = _G.Apex.SuperAttack
local SafeModePvPCheck = _G.Apex.SafeModePvPCheck
local TPToLocation = _G.Apex.TPToLocation
local FindMob = _G.Apex.FindMob; local FindSmartMob = _G.Apex.FindSmartMob
local FindAllMobs = _G.Apex.FindAllMobs
local HasWeapon = _G.Apex.HasWeapon; local Attack = _G.Apex.Attack
local KillAura = _G.Apex.KillAura; local UltraCombo = _G.Apex.UltraCombo
local EquipType = _G.Apex.EquipType; local EquipBest = _G.Apex.EquipBest
local DeathWait = _G.Apex.DeathWait; local SafeCheck = _G.Apex.SafeCheck
local GetQuest = _G.Apex.GetQuest; local GetOptimalStats = _G.Apex.GetOptimalStats
local PredictPosition = _G.Apex.PredictPosition
local AcceptQuest = _G.Apex.AcceptQuest; local SmartQuestSwitch = _G.Apex.SmartQuestSwitch
local BuyRaidChip = _G.Apex.BuyRaidChip; local FindRaidChip = _G.Apex.FindRaidChip
local FindRaidConsole = _G.Apex.FindRaidConsole; local FindRaidRoom = _G.Apex.FindRaidRoom
local GetCDKProgress = _G.Apex.GetCDKProgress
local Quests = _G.Apex.Quests; local Bosses = _G.Apex.Bosses
local EliteEnemies = _G.Apex.EliteEnemies; local Raids = _G.Apex.Raids
local FruitDB = _G.Apex.FruitDB; local RO = _G.Apex.RO
local MaterialsDB = _G.Apex.MaterialsDB
local AllBossDropWeapons = _G.Apex.AllBossDropWeapons
local IslandLocations = _G.Apex.IslandLocations
local FightingStylesShop = _G.Apex.FightingStylesShop
local SwordShop = _G.Apex.SwordShop; local GunShop = _G.Apex.GunShop
local AbilitiesShop = _G.Apex.AbilitiesShop
local BossDropWeaponsSea1 = _G.Apex.BossDropWeaponsSea1
local BossDropWeaponsSea2 = _G.Apex.BossDropWeaponsSea2
local BossDropWeaponsSea3 = _G.Apex.BossDropWeaponsSea3
local ClearCharCache = _G.Apex.ClearCharCache
local JitterOffset = _G.Apex.JitterOffset
-- ══════════════════════════════════════════════════════════════════════════

task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.AutoCDK or not F.CDKAutoWisps then return end
            if not Alive() then return end
            GetCDKProgress()
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoCDK or not F.CDKAutoWisps then break end
                if obj:IsA("Model") and (obj.Name:find("Wisp") or obj.Name:find("Demonic")) then
                    local mh = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                    if mh then
                        TpTo(mh.Position + Vector3.new(0, 3, 0), 400)
                        task.wait(0.5)
                        Attack(obj, {"Click","Remote","Click"}, 0.05)
                        task.wait(0.5)
                    end
                end
            end
            if Sea() >= 3 then
                local deepSea = CFrame.new(-5000, 10, -10000)
                if (HRP().Position - deepSea.Position).Magnitude > 500 then
                    TpTo(deepSea.Position, 400)
                    task.wait(10)
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.AutoCDK or not F.CDKAutoElites then return end
            if not Alive() then DeathWait(); return end
            GetCDKProgress()
            for _, folder in ipairs({"Enemies","NPCs","Living"}) do
                local f = WS:FindFirstChild(folder)
                if f then
                    for _, obj in ipairs(f:GetDescendants()) do
                        if obj:IsA("Model") then
                            for _, ename in ipairs(EliteEnemies) do
                                if obj.Name == ename or obj.Name:find(ename) then
                                    local mh = obj:FindFirstChildOfClass("Humanoid")
                                    if mh and mh.Health > 0 then
                                        local mhrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                                        if mhrp then
                                            TpTo(mhrp.Position + Vector3.new(0, 5, 0), 400)
                                            task.wait(0.5)
                                            local atk = 0
                                            while mh.Health > 0 and Alive() and F.AutoCDK and atk < 200 do
                                                Attack(obj, {"Click","Click","Click","Click","Remote","Click"}, 0.04)
                                                atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                                                task.wait(0.06)
                                            end
                                            Notify("CDK", "Elite "..ename.." killed!", 3)
                                            return
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            pcall(function()
                CommF("EliteHunter")
                CommF("AcceptEliteHunter")
                CommF("StartQuest", "EliteHunterQuest")
            end)
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Elite") or obj.Name:find("Hunter")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then
                            h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3)
                            task.wait(0.5)
                            pcall(function() fireproximityprompt(pp) end)
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoCDK or not F.CDKAutoSoulReaper then return end
            if not Alive() then return end
            for _, folder in ipairs({"Enemies","NPCs","Living"}) do
                local f = WS:FindFirstChild(folder)
                if f then
                    for _, obj in ipairs(f:GetDescendants()) do
                        if obj:IsA("Model") and (obj.Name:find("Soul Reaper") or obj.Name:find("SoulReaper") or obj.Name:find("Haunted")) then
                            local mh = obj:FindFirstChildOfClass("Humanoid")
                            local mhrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                            if mh and mh.Health > 0 and mhrp then
                                TpTo(mhrp.Position + Vector3.new(0, 5, 0), 400)
                                task.wait(1)
                                local atk = 0
                                while mh.Health > 0 and Alive() and F.AutoCDK and atk < 300 do
                                    Attack(obj, {"Click","Click","Click","Click","Remote","Click","Click","Ability"}, 0.03)
                                    atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                                    task.wait(0.06)
                                end
                                Notify("CDK", "Soul Reaper defeated!", 5)
                                return
                            end
                        end
                    end
                end
            end
            pcall(function()
                CommF("SoulReaper")
                CommF("SummonSoulReaper")
                CommF("StartSoulReaper")
            end)
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoCDK or not F.CDKAutoScrolls then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoCDK or not F.CDKAutoScrolls then break end
                if obj:IsA("Tool") and (obj.Name:find("Scroll") or obj.Name:find("Cursed")) then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        TpTo(handle.Position + Vector3.new(0, 2, 0), 500)
                        task.wait(0.3)
                        pcall(function()
                            local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                            if pp then fireproximityprompt(pp) end
                        end)
                        pcall(function()
                            CommF("PickupScroll", obj.Name)
                            CommF("PickupItem", obj.Name)
                        end)
                        task.wait(1)
                    end
                end
            end
        end)
    end
end)
local BountyState = {Target=nil, OriginalBounty=0, Kills=0}
local function FindBountyTargets()
    local targets = {}
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local playerBounty = 0
                local pd = p:FindFirstChild("Data") or p:FindFirstChild("leaderstats")
                if pd then
                    local b = pd:FindFirstChild("Bounty") or pd:FindFirstChild("bounty")
                    if b and b:IsA("IntValue") then playerBounty = b.Value end
                end
                local bp = p:FindFirstChild("Bounty") or p:FindFirstChild("bounty")
                if bp and bp:IsA("IntValue") then playerBounty = bp.Value end
                if playerBounty >= C.BountyTargetBounty then
                    local myHrp = HRP()
                    if myHrp then
                        local dist = (myHrp.Position - hrp.Position).Magnitude
                        table.insert(targets, {Player=p, HRp=hrp, Hum=hum, Bounty=playerBounty, Dist=dist})
                    end
                end
            end
        end
    end
    table.sort(targets, function(a,b) return a.Bounty > b.Bounty end)
    return targets
end
local function PvPAttack(target)
    if not target or not target.HRp or not target.Hum then return end
    if not Alive() then return end
    local h = HRP()
    if not h then return end
    local dist = (h.Position - target.HRp.Position).Magnitude
    if dist > 30 then
        TpTo(target.HRp.Position + Vector3.new(0, 3, 0), 400)
    else
        if F.PredictionCombat then
            local predicted = PredictPosition(target.HRp, h)
            h.CFrame = CFrame.new(predicted + Vector3.new(0, 0, 3), Vector3.new(predicted.X, h.Position.Y, predicted.Z))
        else
            local behind = target.HRp.CFrame * CFrame.new(0, 0, 3)
            h.CFrame = CFrame.new(behind.Position, Vector3.new(target.HRp.Position.X, behind.Position.Y, target.HRp.Position.Z))
        end
        Attack(target.Player.Character, {"Click","Click","Click","Click","Click","Remote","Click","Click","Ability","Click"}, 0.03)
        _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
        pcall(function() CommF("Ability", 1) end)
        pcall(function() CommF("UseAbility", 1) end)
        pcall(function() CommF("UseSkill", 1) end)
    end
end
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if not F.BountyHunt then return end
            if not Alive() then DeathWait(); return end
            local targets = FindBountyTargets()
            if #targets == 0 then
                if F.BountyAutoAttack then
                    Notify("Bounty", "No targets found. Searching...", 3)
                    task.wait(5)
                end
                return
            end
            BountyState.Target = targets[1]
            Notify("Bounty", "Target: "..targets[1].Player.Name.." ["..targets[1].Bounty.." bounty]", 3)
            local atkTimer = 0
            while F.BountyHunt and BountyState.Target and Alive() and atkTimer < 60 do
                local tgt = BountyState.Target
                if not tgt.Hum or tgt.Hum.Health <= 0 or not tgt.HRp or not tgt.HRp.Parent then
                    BountyState.Kills = BountyState.Kills + 1
                    Notify("Bounty", "Target eliminated! Total kills: "..BountyState.Kills, 3)
                    break
                end
                if F.BountyAutoAttack then PvPAttack(tgt) end
                atkTimer = atkTimer + 1
                task.wait(0.1)
            end
            BountyState.Target = nil
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.AutoRevenge then return end
            if not Alive() then return end
            local h = HRP()
            if not h then return end
            for _, p in ipairs(P:GetPlayers()) do
                if p ~= LP and p.Character then
                    local phrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local phum = p.Character:FindFirstChildOfClass("Humanoid")
                    if phrp and phum and phum.Health > 0 then
                        local d = (h.Position - phrp.Position).Magnitude
                        if d < 100 then
                            local myBounty = Bounty()
                            local theirBounty = 0
                            local pd = p:FindFirstChild("Data") or p:FindFirstChild("leaderstats")
                            if pd then
                                local b = pd:FindFirstChild("Bounty") or pd:FindFirstChild("bounty")
                                if b and b:IsA("IntValue") then theirBounty = b.Value end
                            end
                            if theirBounty > myBounty * 1.5 then
                                if F.SmartSafeZone then
                                    InstantTP(Vector3.new(0, 100, 0))
                                    Notify("Revenge", "High bounty player nearby! Safe zone activated.", 3)
                                    task.wait(5)
                                    return
                                end
                            end
                            PvPAttack({Player=p, HRp=phrp, Hum=phum, Bounty=theirBounty, Dist=d})
                            _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                        end
                    end
                end
            end
        end)
    end
end)
local CollectedLog = {}
local RainParts = {}
local function ScanFruits(maxD)
    maxD = maxD or 10000
    local h = HRP()
    if not h then return {} end
    local found = {}
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("Tool") then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
            if handle then
                local d = (h.Position - handle.Position).Magnitude
                if d <= maxD then
                    local fd = GetFD(obj.Name)
                    table.insert(found, {Obj=obj, Name=obj.Name, Handle=handle, Pos=handle.Position, Dist=d, Data=fd})
                end
            end
        end
        if obj:IsA("Model") and (obj.Name:find("Fruit") or obj.Name:find("fruit")) then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
            if handle then
                local d = (h.Position - handle.Position).Magnitude
                if d <= maxD then
                    local fd = GetFD(obj.Name)
                    table.insert(found, {Obj=obj, Name=obj.Name, Handle=handle, Pos=handle.Position, Dist=d, Data=fd})
                end
            end
        end
    end
    table.sort(found, function(a,b)
        local ra = RO[a.Data and a.Data.R or "Common"] or 1
        local rb = RO[b.Data and b.Data.R or "Common"] or 1
        if ra ~= rb then return ra > rb end
        return a.Dist < b.Dist
    end)
    return found
end
local function CollectFruit(info)
    if not info or not info.Handle then return end
    if not Alive() then return end
    TpTo(info.Handle.Position + Vector3.new(0, 2, 0), 500)
    task.wait(0.3)
    local ok = false
    pcall(function()
        local pp = info.Obj:FindFirstChildOfClass("ProximityPrompt")
        if pp then fireproximityprompt(pp); ok = true end
    end)
    if not ok then
        pcall(function()
            local p = UIS:GetMouseLocation()
            VIM:SendMouseButtonEvent(p.X, p.Y, 0, true, game, 1)
            task.wait(0.05)
            VIM:SendMouseButtonEvent(p.X, p.Y, 0, false, game, 1)
            ok = true
        end)
    end
    if not ok then
        pcall(function()
            local h = HRP()
            if h and info.Handle then info.Handle.CFrame = h.CFrame end
        end)
    end
    pcall(function() CommF("PickupFruit", info.Name) end)
    task.wait(0.5)
    table.insert(CollectedLog, {Name=info.Name, Time=os.time()})
end
local function StoreFruit(name)
    pcall(function() CommF("StoreFruit", name) end)
    pcall(function() CommF("StoreItem", name) end)
end
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoFindFruits then return end
            if not Alive() then return end
            local fruits = ScanFruits(10000)
            local minR = RO[C.MinFruitRarity] or 1
            for _, f in ipairs(fruits) do
                if not F.AutoFindFruits then break end
                local ri = RO[f.Data and f.Data.R or "Common"] or 1
                if ri >= minR then
                    local recent = false
                    for _, l in ipairs(CollectedLog) do
                        if l.Name == f.Name and (os.time() - l.Time) < 300 then recent = true; break end
                    end
                    if not recent then
                        local rarity = f.Data and f.Data.R or "?"
                        Notify("Fruit Found!", f.Name.." ["..rarity.."] "..math.floor(f.Dist).."m", 5)
                        if C.DiscordWebhook ~= "" then
                            pcall(function()
                                HTTP({
                                    Url = C.DiscordWebhook,
                                    Method = "POST",
                                    Headers = {["Content-Type"] = "application/json"},
                                    Body = HS:JSONEncode({
                                        content = "Fruit Found: **"..f.Name.."** ["..rarity.."] - "..math.floor(f.Dist).."m"
                                    })
                                })
                            end)
                        end
                        CollectFruit(f)
                        if F.AutoStoreFruits then task.wait(1); StoreFruit(f.Name) end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(10)
        pcall(function()
            if not F.FruitSniper then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Dealer") or obj.Name:find("Blox Fruit")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then
                            h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3)
                            task.wait(1)
                            pcall(function()
                                CommF("BuyFruit", "Dragon")
                                CommF("BuyFruit", "Leopard")
                                CommF("BuyFruit", "Kitsune")
                                CommF("BuyFruit", "Spirit")
                                CommF("BuyFruit", "Dough")
                                CommF("BuyFruit", "Control")
                            end)
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(0.4)
        pcall(function()
            if not F.FruitRain then return end
            local h = HRP()
            if not h then return end
            local names = {}
            for _, fd in ipairs(FruitDB) do
                if F.FruitRainType == "All" or
                   (F.FruitRainType == "Rare" and RO[fd.R] >= 3) or
                   (F.FruitRainType == "Legendary" and RO[fd.R] >= 4) then
                    table.insert(names, fd.N)
                end
            end
            if #names == 0 then return end
            local angle = math.random() * math.pi * 2
            local dist = math.random(15, 80)
            local x = h.Position.X + math.cos(angle) * dist
            local z = h.Position.Z + math.sin(angle) * dist
            local y = h.Position.Y + math.random(60, 100)
            local rn = names[math.random(1, #names)]
            local fd = GetFD(rn)
            local color = fd and fd.C or Color3.fromRGB(255, 200, 0)
            local part = Instance.new("Part")
            part.Size = Vector3.new(3, 3, 3)
            part.Position = Vector3.new(x, y, z)
            part.Anchored = false; part.CanCollide = false
            part.Material = Enum.Material.Neon; part.Color = color
            part.Transparency = 0.2; part.Parent = WS
            Instance.new("PointLight", part).Color = color
            part.PointLight.Brightness = 3; part.PointLight.Range = 20
            local bb = Instance.new("BillboardGui", part)
            bb.Size = UDim2.new(0, 120, 0, 40)
            bb.StudsOffset = Vector3.new(0, 4, 0)
            bb.AlwaysOnTop = true
            local lbl = Instance.new("TextLabel", bb)
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1; lbl.Text = rn
            lbl.TextColor3 = color; lbl.TextStrokeTransparency = 0
            lbl.TextScaled = true; lbl.Font = Enum.Font.GothamBold
            local a1 = Instance.new("Attachment", part)
            a1.Position = Vector3.new(0, 1.5, 0)
            local a2 = Instance.new("Attachment", part)
            a2.Position = Vector3.new(0, -1.5, 0)
            local trail = Instance.new("Trail", part)
            trail.Attachment0 = a1; trail.Attachment1 = a2
            trail.Lifetime = 2; trail.MinLength = 0.1
            trail.Color = ColorSequence.new(color)
            trail.Transparency = NumberSequence.new({0.3, 1})
            Debris:AddItem(part, 30)
            table.insert(RainParts, part)
        end)
    end
end)
local ESPObjects = {}
local function CreateESP(obj, color, text, size)
    if not obj or not obj.Parent then return end
    if ESPObjects[obj] then
        pcall(function()
            if ESPObjects[obj].BB then ESPObjects[obj].BB:Remove() end
            if ESPObjects[obj].Box then ESPObjects[obj].Box:Remove() end
            if ESPObjects[obj].Text then ESPObjects[obj].Text:Remove() end
            if ESPObjects[obj].Dist then ESPObjects[obj].Dist:Remove() end
            if ESPObjects[obj].HealthBar then ESPObjects[obj].HealthBar:Remove() end
            if ESPObjects[obj].HealthFill then ESPObjects[obj].HealthFill:Remove() end
            if ESPObjects[obj].Tracer then ESPObjects[obj].Tracer:Remove() end
        end)
        ESPObjects[obj] = nil
    end
    if EXP.drawing then
        pcall(function()
            local adornee = obj:IsA("Model") and (obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart"))
                or (obj:IsA("BasePart") and obj)
            if not adornee then return end
            local box = Drawing.new("Square")
            box.Thickness = 1; box.Color = color or Color3.new(1,1,1)
            box.Filled = false; box.Visible = true
            local textObj = Drawing.new("Text")
            textObj.Size = 12; textObj.Color = color or Color3.new(1,1,1)
            textObj.Center = true; textObj.Outline = true; textObj.Visible = true
            local distObj = Drawing.new("Text")
            distObj.Size = 10; distObj.Color = Color3.fromRGB(200, 200, 200)
            distObj.Center = true; distObj.Outline = true; distObj.Visible = true
            local healthBar = Drawing.new("Line")
            healthBar.Thickness = 3; healthBar.Color = Color3.fromRGB(0, 255, 0)
            healthBar.Visible = true
            local healthFill = Drawing.new("Line")
            healthFill.Thickness = 3; healthFill.Color = Color3.fromRGB(0, 255, 0)
            healthFill.Visible = true
            local tracer = Drawing.new("Line")
            tracer.Thickness = 1; tracer.Color = Color3.fromRGB(150, 150, 255)
            tracer.Visible = true; tracer.Transparency = 0.5
            ESPObjects[obj] = {Box=box, Text=textObj, Dist=distObj, HealthBar=healthBar, HealthFill=healthFill, Tracer=tracer, Adornee=adornee}
            task.spawn(function()
                while box.Visible and adornee and adornee.Parent and task.wait(0.1) do
                    local hrp = HRP()
                    if hrp and adornee.Parent then
                        local pos, onScreen = Cam:WorldToViewportPoint(adornee.Position)
                        if onScreen then
                            local d = math.floor((hrp.Position - adornee.Position).Magnitude)
                            local boxW, boxH = 40, 50
                            box.Size = Vector2.new(boxW, boxH)
                            box.Position = Vector2.new(pos.X - boxW/2, pos.Y - boxH/2)
                            textObj.Position = Vector2.new(pos.X, pos.Y - boxH/2 - 15)
                            textObj.Text = text or obj.Name
                            distObj.Position = Vector2.new(pos.X, pos.Y + boxH/2 + 5)
                            distObj.Text = d .. "m"
                            local barX = pos.X - boxW/2 - 6
                            healthBar.From = Vector2.new(barX, pos.Y - boxH/2)
                            healthBar.To = Vector2.new(barX, pos.Y + boxH/2)
                            healthBar.Color = Color3.fromRGB(60, 60, 60)
                            local hum = obj:FindFirstChildOfClass("Humanoid")
                            local hpPct = hum and (hum.Health / math.max(hum.MaxHealth, 1)) or 1
                            local barH = boxH * hpPct
                            healthFill.From = Vector2.new(barX, pos.Y + boxH/2)
                            healthFill.To = Vector2.new(barX, pos.Y + boxH/2 - barH)
                            if hpPct > 0.6 then healthFill.Color = Color3.fromRGB(0, 255, 0)
                            elseif hpPct > 0.3 then healthFill.Color = Color3.fromRGB(255, 255, 0)
                            else healthFill.Color = Color3.fromRGB(255, 0, 0) end
                            tracer.From = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y)
                            tracer.To = Vector2.new(pos.X, pos.Y + boxH/2)
                        else
                            box.Visible = false; textObj.Visible = false; distObj.Visible = false
                            healthBar.Visible = false; healthFill.Visible = false; tracer.Visible = false
                        end
                    end
                end
                box.Visible = false; textObj.Visible = false; distObj.Visible = false
                healthBar.Visible = false; healthFill.Visible = false; tracer.Visible = false
            end)
        end)
        if ESPObjects[obj] then return end
    end
    local bb = Instance.new("BillboardGui")
    bb.Name = "ApexESP"; bb.Size = UDim2.new(0, size or 140, 0, 50)
    bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true; bb.LightInfluence = 0
    local nl = Instance.new("TextLabel", bb)
    nl.Size = UDim2.new(1, 0, 0.6, 0); nl.BackgroundTransparency = 1
    nl.Text = text or obj.Name; nl.TextColor3 = color or Color3.new(1,1,1)
    nl.TextStrokeTransparency = 0; nl.TextStrokeColor3 = Color3.new(0,0,0)
    nl.TextScaled = true; nl.Font = Enum.Font.GothamBold
    local dl = Instance.new("TextLabel", bb)
    dl.Size = UDim2.new(1, 0, 0.4, 0); dl.Position = UDim2.new(0, 0, 0.6, 0)
    dl.BackgroundTransparency = 1; dl.TextColor3 = Color3.fromRGB(200,200,200)
    dl.TextStrokeTransparency = 0; dl.TextScaled = true; dl.Font = Enum.Font.Gotham
    local adornee = obj:IsA("Model") and (obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart"))
        or (obj:IsA("BasePart") and obj)
    if adornee then bb.Adornee = adornee; bb.Parent = adornee end
    ESPObjects[obj] = {BB=bb, Adornee=adornee}
    task.spawn(function()
        while bb and bb.Parent and adornee and adornee.Parent and task.wait(0.5) do
            local h = HRP()
            if h then dl.Text = math.floor((h.Position - adornee.Position).Magnitude) .. "m" end
        end
    end)
end
local function ClearESP()
    for o, data in pairs(ESPObjects) do
        if data.BB then pcall(function() data.BB:Remove() end) end
        if data.Box then pcall(function() data.Box:Remove() end) end
        if data.Text then pcall(function() data.Text:Remove() end) end
        if data.Dist then pcall(function() data.Dist:Remove() end) end
        if data.HealthBar then pcall(function() data.HealthBar:Remove() end) end
        if data.HealthFill then pcall(function() data.HealthFill:Remove() end) end
        if data.Tracer then pcall(function() data.Tracer:Remove() end) end
    end
    ESPObjects = {}
end
task.spawn(function()
    while true do task.wait(3)
        pcall(function()
            if not F.AutoMirage then return end
            if not Alive() then return end
            local m = WS:FindFirstChild("MirageIsland") or WS:FindFirstChild("Mirage Island")
            if m then
                local p = m:FindFirstChildWhichIsA("BasePart")
                if p then TpTo(p.Position + Vector3.new(0,60,0), 400) end
            else
                for _, pos in ipairs({CFrame.new(4418,10,7445), CFrame.new(-1800,10,-1400), CFrame.new(-2200,10,-2800)}) do
                    if not F.AutoMirage then break end
                    TpTo(pos.Position, 400); task.wait(5)
                    if WS:FindFirstChild("MirageIsland") then break end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do task.wait(2)
        pcall(function()
            if not F.AutoSeaBeast then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Sea Beast") or obj.Name:find("Seabeast") or obj.Name:find("Terror Shark")) then
                    local mh = obj:FindFirstChild("HumanoidRootPart")
                    local mm = obj:FindFirstChildOfClass("Humanoid")
                    if mh and mm and mm.Health > 0 then
                        local h = HRP()
                        if h then
                            local d = (h.Position - mh.Position).Magnitude
                            if d > 20 then TpTo(mh.Position + Vector3.new(0,15,0), 400)
                            else Attack(obj, {"Click","Click","Click","Click","Remote","Click","Click","Ability"}, 0.04); _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1 end
                        end
                        return
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoFrozenDimension then return end
            if not Alive() then return end
            CommF("FrozenDimension")
            CommF("EnterFrozen")
            CommF("FrozenSea")
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoFrozenDimension then break end
                if obj:IsA("Model") and (obj.Name:find("Frozen") or obj.Name:find("Ice")) then
                    local mh = obj:FindFirstChild("HumanoidRootPart")
                    local mm = obj:FindFirstChildOfClass("Humanoid")
                    if mh and mm and mm.Health > 0 then
                        TpTo(mh.Position + Vector3.new(0, 15, 0), 400)
                        task.wait(0.5)
                        local atk = 0
                        while mm.Health > 0 and Alive() and F.AutoFrozenDimension and atk < 200 do
                            Attack(obj, {"Click","Click","Click","Click","Remote","Click","Ability"}, 0.04)
                            atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1; task.wait(0.06)
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoMirrorDimension then return end
            if not Alive() then return end
            CommF("MirrorDimension")
            CommF("EnterMirror")
            CommF("MirrorSea")
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoMirrorDimension then break end
                if obj:IsA("Model") and (obj.Name:find("Mirror") or obj.Name:find("Dimension")) then
                    local mh = obj:FindFirstChild("HumanoidRootPart")
                    local mm = obj:FindFirstChildOfClass("Humanoid")
                    if mh and mm and mm.Health > 0 then
                        TpTo(mh.Position + Vector3.new(0, 15, 0), 400)
                        task.wait(0.5)
                        local atk = 0
                        while mm.Health > 0 and Alive() and F.AutoMirrorDimension and atk < 200 do
                            Attack(obj, {"Click","Click","Click","Click","Remote","Click","Ability"}, 0.04)
                            atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1; task.wait(0.06)
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do task.wait(3)
        pcall(function()
            if not F.AutoRaceV4 then return end
            if not Alive() then return end
            pcall(function() CommF("ActivateRaceV4") end)
            pcall(function() CommF("RaceAwakening") end)
            pcall(function() CommF("TrialStart") end)
        end)
    end
end)
task.spawn(function()
    while true do task.wait(30)
        pcall(function()
            if not F.AutoSetSpawn then return end
    end
end)
local function GetServers()
    local s = {}
    local ok, res = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    end)
    if ok and res then
        local d = HS:JSONDecode(res)
        if d and d.data then
            for _, sv in ipairs(d.data) do
                if sv.id ~= game.JobId and sv.playing < sv.maxPlayers then
                    table.insert(s, {Id=sv.id, P=sv.playing, M=sv.maxPlayers, Ping=sv.ping or 0})
                end
            end
        end
    end
    return s
end
local function QueueScript()
    if EXP.queuetype then
        pcall(function()
            queue_on_teleport('if _G.ApexLoaded then return end; loadstring(game:HttpGet("https://raw.githubusercontent.com/ApexHub/BloxFruits/main/Apex_Hub_v10_Apex.lua"))()')
        end)
    end
end
local function SmartShouldHop()
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("Tool") and GetFD(obj.Name) then return false end
    end
    for _, bd in ipairs(Bosses) do
        local mob = FindMob(bd.Name, 500)
        if mob then return false end
    end
    local playerCount = #P:GetPlayers()
    if playerCount <= 5 then return false end
    return true
end
local function DoHop(mode)
    mode = mode or C.HopMode
    if F.SmartServerHop and not SmartShouldHop() then
        Notify("Hop", "Smart hop: Conditions not met, staying.", 3)
        return
    end
    local servers = GetServers()
    if #servers == 0 then Notify("Hop", "No servers found", 3); return end
    if mode == "LowPlayer" then table.sort(servers, function(a,b) return a.P < b.P end)
    elseif mode == "HighPlayer" then table.sort(servers, function(a,b) return a.P > b.P end)
    elseif mode == "LowPing" then table.sort(servers, function(a,b) return a.Ping < b.Ping end)
    elseif mode == "New" then
        local s = servers[#servers]
        QueueScript()
        pcall(function() TPS:TeleportToPlaceInstance(game.PlaceId, s.Id, LP) end)
        return
    end
    local t = servers[1]
    Notify("Hop", "Hopping ("..t.P.."/"..t.M..")", 3)
    task.wait(1)
    QueueScript()
    pcall(function() TPS:TeleportToPlaceInstance(game.PlaceId, t.Id, LP) end)
end
task.spawn(function()
    while true do
        task.wait(C.HopDelay)
        if F.ServerHop then pcall(function() DoHop() end) end
        task.wait(5)
    end
end)
LP.Idled:Connect(function()
    if F.AntiAFK then
        pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
    end
end)
local flyBV, flyBG
task.spawn(function()
    while true do task.wait(0.1)
        pcall(function()
            local h = Hum()
            local hrp = HRP()
            if not h or not hrp then
                if flyBV then flyBV:Destroy(); flyBV = nil end
                if flyBG then flyBG:Destroy(); flyBG = nil end
                return
            end
            if F.Fly then
                if not flyBV then
                    flyBV = Instance.new("BodyVelocity", hrp)
                    flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    flyBV.Velocity = Vector3.new(0, 0, 0)
                end
                if not flyBG then
                    flyBG = Instance.new("BodyGyro", hrp)
                    flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    flyBG.P = 9e4; flyBG.D = 500
                end
                flyBV.Velocity = Vector3.new(0, 0, 0)
                h.WalkSpeed = 0
                local spd = C.FlySpeed
                if UIS:IsKeyDown(Enum.KeyCode.W) then flyBV.Velocity = flyBV.Velocity + (Cam.CFrame.LookVector * spd) end
                if UIS:IsKeyDown(Enum.KeyCode.S) then flyBV.Velocity = flyBV.Velocity - (Cam.CFrame.LookVector * spd) end
                if UIS:IsKeyDown(Enum.KeyCode.A) then flyBV.Velocity = flyBV.Velocity - (Cam.CFrame.RightVector * spd) end
                if UIS:IsKeyDown(Enum.KeyCode.D) then flyBV.Velocity = flyBV.Velocity + (Cam.CFrame.RightVector * spd) end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then flyBV.Velocity = flyBV.Velocity + Vector3.new(0, spd, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then flyBV.Velocity = flyBV.Velocity - Vector3.new(0, spd, 0) end
                flyBG.CFrame = Cam.CFrame
            else
                if flyBV then flyBV:Destroy(); flyBV = nil end
                if flyBG then flyBG:Destroy(); flyBG = nil end
                h.WalkSpeed = C.WalkSpeed
            end
        end)
    end
end)
task.spawn(function()
    while true do task.wait(1)
        if F.FPSLimit then
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                if setfpscap then setfpscap(C.MaxFPS) end
            end)
        else
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
                if setfpscap then setfpscap(999) end
            end)
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.AutoChestFarm then return end
            if not Alive() then return end
            local h = HRP()
            if not h then return end
            local chests = {}
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoChestFarm then break end
                if (obj.Name:find("Chest") or obj.Name:find("Treasure")) and (obj:IsA("BasePart") or obj:IsA("Model")) then
                    local handle = obj:IsA("Model") and (obj:FindFirstChildWhichIsA("BasePart")) or obj
                    if handle then
                        local d = (h.Position - handle.Position).Magnitude
                        if d <= C.ChestFarmRange then
                            table.insert(chests, {Obj=obj, Handle=handle, Dist=d})
                        end
                    end
                end
            end
            table.sort(chests, function(a,b) return a.Dist < b.Dist end)
            for _, ch in ipairs(chests) do
                if not F.AutoChestFarm then break end
                if not Alive() then break end
                local pos = ch.Handle.Position + Vector3.new(0, 3, 0)
                if F.SmartPathfind and ch.Dist > 30 then
                    SmartPathfind(pos, 3)
                else
                    TpTo(pos, 500)
                end
                task.wait(0.3)
                pcall(function()
                    local pp = ch.Obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then fireproximityprompt(pp) end
                end)
                pcall(function()
                    CommF("PickupChest", ch.Obj.Name)
                    CommF("CollectChest", ch.Obj.Name)
                    CommF("CollectReward")
                end)
                pcall(function()
                    local p = UIS:GetMouseLocation()
                    VIM:SendMouseButtonEvent(p.X, p.Y, 0, true, game, 1)
                    task.wait(0.03)
                    VIM:SendMouseButtonEvent(p.X, p.Y, 0, false, game, 1)
                end)
                task.wait(0.5)
            end
            if #chests == 0 then
                local chestSpawns = {
                    CFrame.new(-2500, 8, -500), CFrame.new(4500, 8, 7800),
                    CFrame.new(4000, 8, -1500), CFrame.new(-3000, 8, 5800),
                    CFrame.new(5800, 8, -3000), CFrame.new(-5400, 8, -6500)
                }
                local r = chestSpawns[math.random(1, #chestSpawns)]
                TpTo(r.Position, 400)
                task.wait(3)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.AutoHakiBuso then return end
            if not Alive() then return end
            EquipType("Sword")
            task.wait(0.3)
            local mob, dist = FindMob("", C.HakiBusoMobs)
            if mob then
                local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                if mhrp then
                    if dist > 12 then
                        TpTo(mhrp.Position + HumanizedOffset(), 400)
                    else
                        Attack(mob, {"Click","Click","Click","Remote"}, 0.08)
                        _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                        pcall(function()
                            CommF("BusoHaki")
                            CommF("ActivateHaki", "Buso")
                            CommF("ToggleHaki", "Buso")
                        end)
                    end
                end
            else
                local q = GetQuest(Lv())
                if q then TpTo(q.Pos.Position, 400) end
                task.wait(3)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoHakiKen then return end
            if not Alive() then return end
            pcall(function()
                CommF("KenHaki")
                CommF("ActivateHaki", "Ken")
                CommF("ToggleHaki", "Ken")
            end)
            local mob, dist = FindMob("", 50)
            if mob and dist < C.HakiKenHP then
                local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                if mhrp then TpTo(mhrp.Position + Vector3.new(3, 0, 0), 200) end
            else
                local q = GetQuest(Lv())
                if q then TpTo(q.Pos.Position, 400) end
                task.wait(3)
            end
            if HP() < C.SafeHP then
                InstantTP(Vector3.new(0, 100, 0))
                task.wait(3)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoFactoryEvent then return end
            if not Alive() then DeathWait(); return end
            local factoryPos = CFrame.new(1500, 8, -3000)
            local factoryActive = false
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj.Name:find("Factory") or obj.Name:find("Core Brain") then
                    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
                        local mh = obj:FindFirstChildOfClass("Humanoid")
                        if mh and mh.Health > 0 then factoryActive = true end
                    end
                end
            end
            if factoryActive then
                for _, folder in ipairs({"Enemies","NPCs","Living"}) do
                    local f = WS:FindFirstChild(folder)
                    if f then
                        for _, obj in ipairs(f:GetDescendants()) do
                            if not F.AutoFactoryEvent then break end
                            if obj:IsA("Model") and (obj.Name:find("Factory") or obj.Name:find("Core Brain") or obj.Name:find("Chief") or obj.Name:find("Science Crew")) then
                                local mh = obj:FindFirstChildOfClass("Humanoid")
                                local mhrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                                if mh and mh.Health > 0 and mhrp then
                                    TpTo(mhrp.Position + Vector3.new(0, 5, 0), 400)
                                    task.wait(0.5)
                                    local atk = 0
                                    while mh.Health > 0 and Alive() and F.AutoFactoryEvent and atk < 200 do
                                        Attack(obj, {"Click","Click","Click","Click","Remote","Click","Ability"}, 0.04)
                                        atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                                        task.wait(0.06)
                                    end
                                end
                            end
                        end
                    end
                end
            else
                TpTo(factoryPos.Position, 400)
                task.wait(5)
                pcall(function()
                    CommF("StartFactory")
                    CommF("FactoryEvent")
                    CommF("ActivateFactory")
                end)
            end
        end)
    end
end)
local function BuyFromShop(shopName, itemName)
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:find(shopName) then
            local pp = obj:FindFirstChildOfClass("ProximityPrompt")
            if pp then
                local h = HRP()
                if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                task.wait(1)
                pcall(function() fireproximityprompt(pp) end)
                pcall(function()
                    CommF("BuyItem", itemName)
                    CommF("PurchaseItem", itemName)
                    CommF("ShopBuy", itemName)
                end)
                task.wait(1)
            end
        end
    end
end
local function CollectRaceFragments()
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:find("Torch") or obj.Name:find("Fire")) then
            TpTo(obj.Position + Vector3.new(0,2,0), 400)
            task.wait(1)
            pcall(function()
                local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                if pp then fireproximityprompt(pp) end
            end)
        end
    end
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:find("Fragment") then
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part then
                TpTo(part.Position + Vector3.new(0,2,0), 400)
                task.wait(1)
                pcall(function()
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then fireproximityprompt(pp) end
                end)
            end
        end
    end
end
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoAwakenFruit then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Awaken") or obj.Name:find("Expert")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                        task.wait(1)
                        pcall(function() fireproximityprompt(pp) end)
                        pcall(function()
                            CommF("AwakenFruit")
                            CommF("UpgradeAbility")
                            CommF("AwakenAbility", 1)
                        end)
                        task.wait(2)
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoGodHuman then return end
            if not Alive() then DeathWait(); return end
            if HasWeapon("GodHuman") then
                Notify("GodHuman", "Already have GodHuman!", 5); return
            end
            local ancientOnePos = CFrame.new(-1250, 8, -1200)
            TpTo(ancientOnePos.Position, 400)
            task.wait(1)
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Ancient") or obj.Name:find("Master") or obj.Name:find("Fighting")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3); task.wait(0.5); pcall(function() fireproximityprompt(pp) end) end
                    end
                end
            end
            pcall(function()
                CommF("BuyFightingStyle", "GodHuman")
                CommF("UnlockFightingStyle", "GodHuman")
                CommF("LearnFightingStyle", "GodHuman")
            end)
            local materialsNeeded = {"Magma Ore", "Leather", "Scrap Metal", "Vampire Fang", "Mystic Droplet"}
            for _, mat in ipairs(materialsNeeded) do
                if not F.AutoGodHuman then break end
                local matData = nil
                for _, m in ipairs(MaterialsDB) do
                    if m.Name:find(mat) then matData = m; break end
                end
                if matData then
                    for _, mobName in ipairs(matData.Mobs) do
                        if not F.AutoGodHuman then break end
                        local mob = FindMob(mobName, 500)
                        if mob then
                            local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                            if mhrp then
                                TpTo(mhrp.Position + Vector3.new(0, 3, 0), 400)
                                task.wait(0.5)
                                local atk = 0
                                local mh = mob:FindFirstChildOfClass("Humanoid")
                                while mh and mh.Health > 0 and Alive() and F.AutoGodHuman and atk < 100 do
                                    Attack(mob, {"Click","Click","Click","Remote","Click"}, 0.05)
                                    atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                                    task.wait(0.06)
                                end
                            end
                        end
                    end
                end
            end
            TpTo(ancientOnePos.Position, 400); task.wait(1)
            pcall(function() CommF("BuyFightingStyle", "GodHuman"); CommF("UnlockFightingStyle", "GodHuman") end)
            Notify("GodHuman", "Attempting to unlock GodHuman...", 5)
            task.wait(5)
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoDragonTalon and not F.AutoDeathStep and not F.AutoSharkKarate and not F.AutoElectricClaw then return end
            if not Alive() then DeathWait(); return end
            if F.AutoDragonTalon then
                if not HasWeapon("Dragon Talon") then
                    for _, obj in ipairs(WS:GetDescendants()) do
                        if obj:IsA("Model") and obj.Name:find("Alchemist") then
                            local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                            if pp then
                                local h = HRP()
                                if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3); task.wait(0.5); pcall(function() fireproximityprompt(pp) end) end
                            end
                        end
                    end
                    pcall(function()
                        CommF("BuyFightingStyle", "Dragon Talon")
                        CommF("UnlockFightingStyle", "Dragon Talon")
                        CommF("LearnFightingStyle", "Dragon Talon")
                    end)
                    local mats = {"Bones", "Dragon Scale", "Leviathan Scale"}
                    for _, mat in ipairs(mats) do
                        if not F.AutoDragonTalon then break end
                        local matData = nil
                        for _, m in ipairs(MaterialsDB) do
                            if m.Name == mat then matData = m; break end
                        end
                        if matData then
                            for _, mobName in ipairs(matData.Mobs) do
                                if not F.AutoDragonTalon then break end
                                local mob = FindMob(mobName, 500)
                                if mob then
                                    local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                                    if mhrp then
                                        TpTo(mhrp.Position + Vector3.new(0, 3, 0), 400)
                                        task.wait(0.5)
                                        local mh = mob:FindFirstChildOfClass("Humanoid")
                                        local atk = 0
                                        while mh and mh.Health > 0 and Alive() and F.AutoDragonTalon and atk < 100 do
                                            Attack(mob, {"Click","Click","Click","Remote","Click"}, 0.05)
                                            atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1; task.wait(0.06)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if F.AutoDeathStep then
                if not HasWeapon("Death Step") then
                    for _, obj in ipairs(WS:GetDescendants()) do
                        if obj:IsA("Model") and (obj.Name:find("Slave") or obj.Name:find("Quest") or obj.Name:find("Martial")) then
                            local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                            if pp then
                                local h = HRP()
                                if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3); task.wait(0.5); pcall(function() fireproximityprompt(pp) end) end
                            end
                        end
                    end
                    pcall(function()
                        CommF("BuyFightingStyle", "Death Step")
                        CommF("UnlockFightingStyle", "Death Step")
                        CommF("LearnFightingStyle", "Death Step")
                    end)
                end
            end
            if F.AutoSharkKarate then
                if not HasWeapon("Sharkman Karate") then
                    for _, obj in ipairs(WS:GetDescendants()) do
                        if obj:IsA("Model") and obj.Name:find("Fish") then
                            local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                            if pp then
                                local h = HRP()
                                if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3); task.wait(0.5); pcall(function() fireproximityprompt(pp) end) end
                            end
                        end
                    end
                    pcall(function()
                        CommF("BuyFightingStyle", "Sharkman Karate")
                        CommF("UnlockFightingStyle", "Sharkman Karate")
                        CommF("LearnFightingStyle", "Sharkman Karate")
                    end)
                end
            end
            if F.AutoElectricClaw then
                if not HasWeapon("Electric Claw") then
                    for _, obj in ipairs(WS:GetDescendants()) do
                        if obj:IsA("Model") and obj.Name:find("Electric") then
                            local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                            if pp then
                                local h = HRP()
                                if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3); task.wait(0.5); pcall(function() fireproximityprompt(pp) end) end
                            end
                        end
                    end
                    pcall(function()
                        CommF("BuyFightingStyle", "Electric Claw")
                        CommF("UnlockFightingStyle", "Electric Claw")
                        CommF("LearnFightingStyle", "Electric Claw")
                    end)
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoDoughKing then return end
            if not Alive() then DeathWait(); return end
            for _, folder in ipairs({"Enemies","NPCs","Living"}) do
                local f = WS:FindFirstChild(folder)
                if f then
                    for _, obj in ipairs(f:GetDescendants()) do
                        if obj:IsA("Model") and (obj.Name:find("Dough King") or obj.Name:find("DoughKing")) then
                            local mh = obj:FindFirstChildOfClass("Humanoid")
                            local mhrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                            if mh and mh.Health > 0 and mhrp then
                                TpTo(mhrp.Position + Vector3.new(0, 5, 0), 400)
                                task.wait(1)
                                local atk = 0
                                while mh.Health > 0 and Alive() and F.AutoDoughKing and atk < 500 do
                                    Attack(obj, {"Click","Click","Click","Click","Remote","Click","Click","Ability"}, 0.03)
                                    atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1; task.wait(0.06)
                                end
                                Notify("Dough King", "Dough King defeated!", 5)
                                return
                            end
                        end
                    end
                end
            end
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Cake") or obj.Name:find("Prince")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3); task.wait(0.5); pcall(function() fireproximityprompt(pp) end) end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoBardQuest then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Bard") or obj.Name:find("QuestGiver")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3); task.wait(0.5); pcall(function() fireproximityprompt(pp) end) end
                    end
                end
            end
            pcall(function()
                CommF("BardQuest")
                CommF("AcceptBardQuest")
                CommF("StartBardQuest")
            end)
            local bardMobs = {"Island Boy", "Island Champion", "Island Queen", "Island King"}
            for _, mobName in ipairs(bardMobs) do
                if not F.AutoBardQuest then break end
                local mob = FindMob(mobName, 500)
                if mob then
                    local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                    if mhrp then
                        TpTo(mhrp.Position + Vector3.new(0, 3, 0), 400)
                        task.wait(0.5)
                        local mh = mob:FindFirstChildOfClass("Humanoid")
                        local atk = 0
                        while mh and mh.Health > 0 and Alive() and F.AutoBardQuest and atk < 100 do
                            Attack(mob, {"Click","Click","Click","Remote","Click"}, 0.05)
                            atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1; task.wait(0.06)
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoSoulGuitar then return end
            if not Alive() then DeathWait(); return end
            if HasWeapon("Soul Guitar") then Notify("Soul Guitar", "Already have Soul Guitar!", 5); return end
            local ectoMob = FindMob("Possessed Mummy", 500)
            if not ectoMob then ectoMob = FindMob("Cursed Captain", 500) end
            if not ectoMob then ectoMob = FindMob("Ghost", 500) end
            if ectoMob then
                local mhrp = ectoMob:FindFirstChild("HumanoidRootPart") or ectoMob:FindFirstChild("Torso")
                if mhrp then
                    TpTo(mhrp.Position + HumanizedOffset(), 400); task.wait(0.5)
                    local mh = ectoMob:FindFirstChildOfClass("Humanoid")
                    local atk = 0
                    while mh and mh.Health > 0 and Alive() and F.AutoSoulGuitar and atk < 50 do
                        Attack(ectoMob, {"Click","Click","Click","Remote","Click"}, 0.05)
                        atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1; task.wait(0.06)
                    end
                end
            else
                TpTo(CFrame.new(-5000, 5, -3000).Position, 400); task.wait(5)
            end
            local boneMob = FindMob("Skeleton", 500)
            if boneMob then
                local mhrp = boneMob:FindFirstChild("HumanoidRootPart") or boneMob:FindFirstChild("Torso")
                if mhrp then
                    TpTo(mhrp.Position + HumanizedOffset(), 400); task.wait(0.5)
                    Attack(boneMob, {"Click","Click","Click","Remote","Click"}, 0.05)
                    _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                end
            end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoSoulGuitar then break end
                if obj:IsA("Model") and (obj.Name:find("Craft") or obj.Name:find("Forge") or obj.Name:find("Altar")) then
                    local handle = obj:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        TpTo(handle.Position + Vector3.new(0, 5, 0), 400); task.wait(1)
                        pcall(function() local pp = obj:FindFirstChildOfClass("ProximityPrompt"); if pp then fireproximityprompt(pp) end end)
                        pcall(function() CommF("CraftWeapon", "Soul Guitar"); CommF("BuySoulGuitar"); CommF("SoulGuitarCraft") end)
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoTuskV4 then return end
            if not Alive() then DeathWait(); return end
            local deepSea = CFrame.new(-5000, 10, -10000)
            if (HRP().Position - deepSea.Position).Magnitude > 500 then TpTo(deepSea.Position, 400); task.wait(10) end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoTuskV4 then break end
                if obj:IsA("Model") and (obj.Name:find("Sea Beast") or obj.Name:find("Terror Shark") or obj.Name:find("Leviathan")) then
                    local mh = obj:FindFirstChild("HumanoidRootPart")
                    local mm = obj:FindFirstChildOfClass("Humanoid")
                    if mh and mm and mm.Health > 0 then
                        TpTo(mh.Position + Vector3.new(0, 15, 0), 400); task.wait(0.5)
                        local atk = 0
                        while mm.Health > 0 and Alive() and F.AutoTuskV4 and atk < 200 do
                            Attack(obj, {"Click","Click","Click","Click","Remote","Click","Ability"}, 0.04)
                            atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1; task.wait(0.06)
                        end
                    end
                end
            end
            pcall(function() CommF("MirrorDimension"); CommF("EnterMirror"); CommF("TuskV4", "mirror") end)
            pcall(function() CommF("FrozenDimension"); CommF("EnterFrozen"); CommF("TuskV4", "frozen") end)
            pcall(function() CommF("PirateShip"); CommF("BoardShip"); CommF("TuskV4", "pirate") end)
            pcall(function() CommF("AwakenTusk"); CommF("TuskV4Awaken"); CommF("RaceV4", "Tusk") end)
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoDarkBlade then return end
            if not Alive() then DeathWait(); return end
            if HasWeapon("Dark Blade") then
                for _, obj in ipairs(WS:GetDescendants()) do
                    if not F.AutoDarkBlade then break end
                    if obj:IsA("Model") and (obj.Name:find("Frozen") or obj.Name:find("Advanced") or obj.Name:find("Dark Blade")) then
                        local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                        if pp then local h = HRP(); if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3); task.wait(0.5); pcall(function() fireproximityprompt(pp) end) end end
                    end
                end
                pcall(function() CommF("UpgradeDarkBlade", "V2"); CommF("DarkBladeV2") end)
                for _, folder in ipairs({"Enemies","NPCs","Living"}) do
                    local f = WS:FindFirstChild(folder)
                    if f then
                        for _, obj in ipairs(f:GetDescendants()) do
                            if not F.AutoDarkBlade then break end
                            if obj:IsA("Model") then
                                for _, ename in ipairs(EliteEnemies) do
                                    if obj.Name:find(ename) then
                                        local mh = obj:FindFirstChildOfClass("Humanoid")
                                        if mh and mh.Health > 0 then
                                            local mhrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                                            if mhrp then
                                                TpTo(mhrp.Position + Vector3.new(0, 5, 0), 400); task.wait(0.5)
                                                local atk = 0
                                                while mh.Health > 0 and Alive() and F.AutoDarkBlade and atk < 200 do
                                                    Attack(obj, {"Click","Click","Click","Click","Remote","Click"}, 0.04)
                                                    atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1; task.wait(0.06)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                pcall(function() CommF("UpgradeDarkBlade", "V3"); CommF("DarkBladeV3") end)
            else
                for _, obj in ipairs(WS:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:find("Frozen") or obj.Name:find("Advanced")) then
                        local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                        if pp then local h = HRP(); if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3); task.wait(0.5); pcall(function() fireproximityprompt(pp) end) end end
                    end
                end
                pcall(function() CommF("BuyWeapon", "Dark Blade"); CommF("PurchaseWeapon", "Dark Blade") end)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoSharkAnchor then return end
            if not Alive() then DeathWait(); return end
            if HasWeapon("Shark Anchor") then Notify("Shark Anchor", "Already have Shark Anchor!", 5); return end
            local deepSea = CFrame.new(-5000, 10, -10000)
            if (HRP().Position - deepSea.Position).Magnitude > 500 then TpTo(deepSea.Position, 400); task.wait(10) end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoSharkAnchor then break end
                if obj:IsA("Model") and (obj.Name:find("Shark") or obj.Name:find("Leviathan") or obj.Name:find("Terror Shark")) then
                    local mh = obj:FindFirstChild("HumanoidRootPart")
                    local mm = obj:FindFirstChildOfClass("Humanoid")
                    if mh and mm and mm.Health > 0 then
                        TpTo(mh.Position + Vector3.new(0, 10, 0), 400); task.wait(0.5)
                        local atk = 0
                        while mm.Health > 0 and Alive() and F.AutoSharkAnchor and atk < 300 do
                            Attack(obj, {"Click","Click","Click","Click","Remote","Click","Ability"}, 0.04)
                            atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1; task.wait(0.06)
                        end
                    end
                end
            end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoSharkAnchor then break end
                if obj:IsA("Model") and (obj.Name:find("Craft") or obj.Name:find("Forge")) then
                    local handle = obj:FindFirstChildWhichIsA("BasePart")
                    if handle then TpTo(handle.Position + Vector3.new(0, 5, 0), 400); task.wait(1); pcall(function() CommF("CraftWeapon", "Shark Anchor") end) end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoCanvander then return end
            if not Alive() then DeathWait(); return end
            if HasWeapon("Canvander") then Notify("Canvander", "Already have Canvander!", 5); return end
            for _, folder in ipairs({"Enemies","NPCs","Living"}) do
                local f = WS:FindFirstChild(folder)
                if f then
                    for _, obj in ipairs(f:GetDescendants()) do
                        if not F.AutoCanvander then break end
                        if obj:IsA("Model") and (obj.Name:find("Beautiful Pirate") or obj.Name:find("Longma") or obj.Name:find("Dough King")) then
                            local mh = obj:FindFirstChildOfClass("Humanoid")
                            local mhrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                            if mh and mh.Health > 0 and mhrp then
                                TpTo(mhrp.Position + Vector3.new(0, 5, 0), 400); task.wait(1)
                                local atk = 0
                                while mh.Health > 0 and Alive() and F.AutoCanvander and atk < 300 do
                                    Attack(obj, {"Click","Click","Click","Click","Remote","Click","Click","Ability"}, 0.03)
                                    atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1; task.wait(0.06)
                                end
                            end
                        end
                    end
                end
            end
            TpTo(CFrame.new(-1250, 8, -1200).Position, 400); task.wait(3)
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoLegendSword then return end
            if not Alive() then DeathWait(); return end
            if HasWeapon("Legend Sword") or HasWeapon("Sentry") then Notify("Legend Sword", "Already have Legend Sword!", 5); return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoLegendSword then break end
                if obj:IsA("Model") and (obj.Name:find("Alchemist") or obj.Name:find("Guru")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then local h = HRP(); if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3); task.wait(0.5); pcall(function() fireproximityprompt(pp) end) end end
                end
            end
            pcall(function() CommF("TalkToAlchemist"); CommF("StartAlchemistQuest"); CommF("LegendSword", "start") end)
            local flowerNames = {"Red Flower", "Blue Flower", "Yellow Flower", "Flower"}
            for _, fn in ipairs(flowerNames) do
                if not F.AutoLegendSword then break end
                for _, obj in ipairs(WS:GetDescendants()) do
                    if not F.AutoLegendSword then break end
                    if obj:IsA("Model") and obj.Name:find(fn) then
                        local handle = obj:FindFirstChildWhichIsA("BasePart")
                        if handle then
                            TpTo(handle.Position + Vector3.new(0, 2, 0), 500); task.wait(0.5)
                            pcall(function() local pp = obj:FindFirstChildOfClass("ProximityPrompt"); if pp then fireproximityprompt(pp) end end)
                            pcall(function() CommF("PickupFlower", obj.Name); CommF("CollectFlower", obj.Name) end)
                        end
                    end
                end
            end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoLegendSword then break end
                if obj:IsA("Model") and (obj.Name:find("Alchemist") or obj.Name:find("Guru")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then local h = HRP(); if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3); task.wait(0.5); pcall(function() fireproximityprompt(pp) end) end end
                end
            end
            pcall(function() CommF("TalkToAlchemist"); CommF("LegendSword", "complete"); CommF("BuyWeapon", "Legend Sword") end)
            task.wait(5)
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoMaterialsFarm then return end
            if not Alive() then DeathWait(); return end
            local targetMat = nil
            for _, m in ipairs(MaterialsDB) do
                if m.Name:find(C.MaterialsTarget) then targetMat = m; break end
            end
            if not targetMat then Notify("Materials", "Material not found: "..C.MaterialsTarget, 3); return end
            for _, mobName in ipairs(targetMat.Mobs) do
                if not F.AutoMaterialsFarm then break end
                local mob = FindMob(mobName, 500)
                if mob then
                    local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                    if mhrp then
                        TpTo(mhrp.Position + HumanizedOffset(), 400); task.wait(0.5)
                        local mh = mob:FindFirstChildOfClass("Humanoid")
                        local atk = 0
                        while mh and mh.Health > 0 and Alive() and F.AutoMaterialsFarm and atk < 100 do
                            Attack(mob, {"Click","Click","Click","Remote","Click"}, 0.05)
                            atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1; task.wait(0.06)
                        end
                    end
                else
                    if Sea() >= 2 then
                        local locations = {CFrame.new(-5000, 5, -3000), CFrame.new(-1250, 8, -1200), CFrame.new(4200, 5, -1600)}
                        local r = locations[math.random(1, #locations)]
                        TpTo(r.Position, 400); task.wait(5)
                    end
                end
            end
            task.wait(2)
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoMaterialDetector then return end
            if not Alive() then return end
            local detected = {}
            for _, mat in ipairs(MaterialsDB) do
                for _, mobName in ipairs(mat.Mobs) do
                    local mob = FindMob(mobName, 300)
                    if mob then
                        table.insert(detected, {Material=mat.Name, Mob=mobName, Obj=mob})
                    end
                end
            end
            if #detected > 0 then
                Notify("Material Detector", "Found "..#detected.." material sources nearby!", 5)
                for i = 1, math.min(3, #detected) do
                    Notify("Material", detected[i].Material.." ("..detected[i].Mob..")", 3)
                end
            else
                Notify("Material Detector", "No material mobs within 300m", 3)
            end
            task.wait(10)
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            if not F.AutoDodge then return end
            if not Alive() then return end
            local h = HRP()
            if not h then return end
            for _, p in ipairs(P:GetPlayers()) do
                if p ~= LP and p.Character then
                    local phrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local phum = p.Character:FindFirstChildOfClass("Humanoid")
                    if phrp and phum and phum.Health > 0 then
                        local d = (h.Position - phrp.Position).Magnitude
                        if d < C.DodgeRange then
                            local vel = phrp.AssemblyLinearVelocity
                            local dirToUs = (h.Position - phrp.Position).Unit
                            local dot = vel.Unit:Dot(dirToUs)
                            if dot > 0.5 and vel.Magnitude > 20 then
                                local dodgeDir = (h.Position - phrp.Position).Unit * 30
                                local sideVec = h.CFrame.RightVector * (math.random() > 0.5 and 1 or -1) * 15
                                local dodgePos = h.Position + dodgeDir + sideVec
                                InstantTP(dodgePos)
                                task.wait(C.DodgeCooldown)
                                return
                            end
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(C.ComboDelay)
        pcall(function()
            if not F.ComboAttack and not F.UltraComboMode then return end
            if not Alive() then return end
            local mob, dist = FindMob("", C.KillAuraRange)
            if not mob then return end
            local mh = mob:FindFirstChildOfClass("Humanoid")
            if not mh or mh.Health <= 0 then return end
            if F.UltraComboMode then
                pcall(function()
                    CommF("BusoHaki")
                    CommF("ActivateHaki", "Buso")
                    CommF("ToggleHaki", "Buso")
                end)
                EquipType("Sword"); task.wait(0.08)
                Attack(mob, {"Click","Click","Remote"}, 0.04); _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                if mh.Health <= 0 then return end
                EquipType("Fruit"); task.wait(0.08)
                Attack(mob, {"Click","Ability","Ability"}, 0.06); _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                if mh.Health <= 0 then return end
                EquipType("Gun"); task.wait(0.08)
                Attack(mob, {"Click","Remote"}, 0.06); _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                if mh.Health <= 0 then return end
                EquipType("Fighting"); task.wait(0.08)
                Attack(mob, {"Click","Click","Ability"}, 0.05); _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                if mh.Health <= 0 then return end
                EquipBest(); task.wait(0.08)
                Attack(mob, {"Click","Click","Click","Click","Remote"}, 0.03); _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
            else
                EquipType("Sword"); task.wait(0.1)
                Attack(mob, {"Click","Click","Remote"}, 0.05); _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                if mh.Health <= 0 then return end
                EquipType("Fruit"); task.wait(0.1)
                Attack(mob, {"Click","Ability"}, 0.08); _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                if mh.Health <= 0 then return end
                EquipType("Gun"); task.wait(0.1)
                Attack(mob, {"Click","Remote"}, 0.08); _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                if mh.Health <= 0 then return end
                EquipBest(); task.wait(0.1)
                Attack(mob, {"Click","Click","Click","Click","Remote"}, 0.04); _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if not F.AutoBusoHaki and not F.AutoKenHaki then return end
            if not Alive() then return end
            if F.AutoBusoHaki then
                CommF("BusoHaki")
                CommF("ActivateHaki", "Buso")
                CommF("ToggleHaki", "Buso")
            end
            if F.AutoKenHaki then
                CommF("KenHaki")
                CommF("ActivateHaki", "Ken")
                CommF("ToggleHaki", "Ken")
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.SmartSafeZone then return end
            if not Alive() then return end
            local h = HRP()
            if not h then return end
            if HP() < 15 then
                InstantTP(Vector3.new(0, 100, 0))
                Notify("Safe Zone", "Critical HP! Teleported to safe zone.", 3)
                task.wait(5)
                return
            end
            local highBountyNearby = false
            for _, p in ipairs(P:GetPlayers()) do
                if p ~= LP and p.Character then
                    local phrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if phrp then
                        local d = (h.Position - phrp.Position).Magnitude
                        if d < 80 then
                            local theirBounty = 0
                            local pd = p:FindFirstChild("Data") or p:FindFirstChild("leaderstats")
                            if pd then
                                local b = pd:FindFirstChild("Bounty") or pd:FindFirstChild("bounty")
                                if b and b:IsA("IntValue") then theirBounty = b.Value end
                            end
                            if theirBounty > Bounty() * 2 then
                                highBountyNearby = true
                                break
                            end
                        end
                    end
                end
            end
            if highBountyNearby then
                InstantTP(Vector3.new(0, 100, 0))
                Notify("Safe Zone", "High bounty player detected! Evading.", 3)
                task.wait(5)
            end
        end)
    end
end)
local Highlights = {}
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.PlayerHighlight then
                for _, hl in pairs(Highlights) do
                    if hl and hl.Parent then hl:Destroy() end
                end
                Highlights = {}
                return
            end
            for _, p in ipairs(P:GetPlayers()) do
                if p ~= LP and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        if not Highlights[p] or not Highlights[p].Parent then
                            local hl = Instance.new("Highlight")
                            hl.Name = "ApexHL"
                            hl.FillTransparency = 0.7
                            hl.OutlineTransparency = 0
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            if p.Team and p.Team.TeamColor then
                                hl.FillColor = p.Team.TeamColor.Color
                                hl.OutlineColor = p.Team.TeamColor.Color
                            else
                                hl.FillColor = Color3.fromRGB(255, 50, 50)
                                hl.OutlineColor = Color3.fromRGB(255, 100, 100)
                            end
                            hl.Parent = p.Character
                            Highlights[p] = hl
                        end
                    else
                        if Highlights[p] then Highlights[p]:Destroy(); Highlights[p] = nil end
                    end
                else
                    if Highlights[p] then Highlights[p]:Destroy(); Highlights[p] = nil end
                end
            end
            for p, hl in pairs(Highlights) do
                if not p.Parent then
                    if hl and hl.Parent then hl:Destroy() end
                    Highlights[p] = nil
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.FPSBoost then return end
            Light.GlobalShadows = false
            Light.FogEnd = 999999
            Light.FogStart = 999999
            Light.ClockTime = 14
            Light.Brightness = 2
            Light.Ambient = Color3.fromRGB(178, 178, 178)
            Light.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
            if WS:FindFirstChild("Terrain") then
                WS.Terrain.WaterWaveSize = 0
                WS.Terrain.WaterWaveSpeed = 0
                WS.Terrain.WaterReflectance = 0
                WS.Terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(Light:GetDescendants()) do
                if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("DepthOfFieldEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                end
            end
        end)
    end
end)
local MemStats = {Cleanups=0, ObjectsRemoved=0, LastCleanup=0}
task.spawn(function()
    while true do
        task.wait(30)
        local removed = 0
        for obj, data in pairs(ESPObjects) do
            if not obj or not obj.Parent then
                pcall(function() if data.BB then data.BB:Remove(); removed = removed + 1 end end)
                pcall(function() if data.Box then data.Box:Remove(); removed = removed + 1 end end)
                pcall(function() if data.Text then data.Text:Remove(); removed = removed + 1 end end)
                pcall(function() if data.Dist then data.Dist:Remove(); removed = removed + 1 end end)
                pcall(function() if data.HealthBar then data.HealthBar:Remove(); removed = removed + 1 end end)
                pcall(function() if data.HealthFill then data.HealthFill:Remove(); removed = removed + 1 end end)
                pcall(function() if data.Tracer then data.Tracer:Remove(); removed = removed + 1 end end)
                ESPObjects[obj] = nil
            end
        end
        for i = #RainParts, 1, -1 do
            if not RainParts[i] or not RainParts[i].Parent then
                table.remove(RainParts, i)
                removed = removed + 1
            end
        end
        for p, hl in pairs(Highlights) do
            if not p.Parent then
                if hl and hl.Parent then hl:Destroy(); removed = removed + 1 end
                Highlights[p] = nil
            end
        end
        pcall(function() collectgarbage("collect") end)
        MemStats.Cleanups = MemStats.Cleanups + 1
        MemStats.ObjectsRemoved = MemStats.ObjectsRemoved + removed
        MemStats.LastCleanup = os.time()
    end
end)
local FishingRods = {"Bazooka Rod","Flame Rod","Ice Rod","Gold Rod","Shark Rod","Electro Rod","Dark Rod","Dragon Rod","Heaven Rod"}
local BaitTypes = {"Worm","Shrimp","Krill","Bait","Glowing Worm","Quality Bait"}
local function AutoFish()
    if not F.AutoFishing then return end
    pcall(function()
        local char = LP.Character
        if not char then return end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:find("Rod") then
                tool.Parent = LP.Backpack
                task.wait(0.5)
                tool.Parent = LP.Character
                break
            end
        end
        pcall(function()
            VIM:SendKeyEvent(true, Enum.KeyCode["F"], false, game)
            task.wait(0.05)
            VIM:SendKeyEvent(false, Enum.KeyCode["F"], false, game)
        end)
        task.wait(RandDelay(2, 5))
        pcall(function()
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.1)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end)
        task.wait(1)
        pcall(function()
            CommF("SellFish")
            CommF("TradeFish")
        end)
    end)
end
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoFishing then return end
            if not Alive() then return end
            AutoFish()
        end)
    end
end)
local FruitValues = {
    ["Dragon"] = 35000000, ["Leopard"] = 30000000, ["Spirit"] = 25000000,
    ["Dough"] = 20000000, ["Buddha"] = 15000000, ["Venom"] = 12000000,
    ["Control"] = 10000000, ["T-Rex"] = 8000000, ["Mammoth"] = 7000000,
    ["Shadow"] = 6000000, ["Blizzard"] = 5000000, ["Gravity"] = 4000000,
    ["Phoenix"] = 3500000, ["Portal"] = 3000000, ["Rumble"] = 2500000,
    ["Pain"] = 2000000, ["Spider"] = 1500000, ["Quake"] = 1000000,
    ["String"] = 800000, ["Magma"] = 600000, ["Light"] = 500000,
    ["Dark"] = 400000, ["Ice"] = 300000, ["Sand"] = 250000,
    ["Flame"] = 200000, ["Smoke"] = 150000, ["Spring"] = 100000,
    ["Chop"] = 50000
}
local function GetFruitValue(name)
    return FruitValues[name] or 0
end
local function FreezeTrade()
    pcall(function()
        CommF("FreezeTrade")
        CommF("LockTrade")
        local gui = LP.PlayerGui:FindFirstChild("TradeGui") or LP.PlayerGui:FindFirstChild("TradingGui")
        if gui then
            for _, frame in ipairs(gui:GetDescendants()) do
                if frame:IsA("Frame") and frame.Name:find("Trade") then
                    frame.Active = false
                end
            end
        end
    end)
end
local function AutoAcceptTrade()
    pcall(function()
        CommF("AcceptTrade")
        CommF("AcceptDeal")
        CommF("ConfirmTrade")
        local gui = LP.PlayerGui:FindFirstChild("TradeGui") or LP.PlayerGui:FindFirstChild("TradingGui")
        if gui then
            for _, btn in ipairs(gui:GetDescendants()) do
                if btn:IsA("TextButton") and (btn.Name:find("Accept") or btn.Text:find("Accept")) then
                    btn:Activate()
                end
            end
        end
    end)
end
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoTrade then return end
            if F.AutoFreezeTrade then FreezeTrade() end
            AutoAcceptTrade()
        end)
    end
end)
local NoclipConnection = nil
local function ToggleNoclip(state)
    if state then
        NoclipConnection = RS2.Stepped:Connect(function()
            pcall(function()
                local char = LP.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end)
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
    end
end
local function ApplySpeed()
    pcall(function()
        local h = Hum()
        if h then
            h.WalkSpeed = C.WalkSpeed or 16
            h.JumpPower = C.JumpPower or 50
        end
    end)
end
local function ApplyDash()
    pcall(function()
        local char = LP.Character
        if char then
            local dash = char:FindFirstChild("DashLength") or char:FindFirstChild("Dash")
            if dash and dash:IsA("NumberValue") then
                dash.Value = C.DashLength or 30
            end
        end
    end)
end
local InfiniteJumpConn = nil
local function ToggleInfiniteJump(state)
    if state then
        InfiniteJumpConn = UIS.JumpRequest:Connect(function()
            pcall(function()
                local h = Hum()
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end)
    else
        if InfiniteJumpConn then
            InfiniteJumpConn:Disconnect()
            InfiniteJumpConn = nil
        end
    end
end
task.spawn(function()
    while true do
        task.wait(0.5)
        if F.InfiniteJump then
            if not InfiniteJumpConn then ToggleInfiniteJump(true) end
        else
            if InfiniteJumpConn then ToggleInfiniteJump(false) end
        end
        if F.NoclipEnabled then
            if not NoclipConnection then ToggleNoclip(true) end
        else
            if NoclipConnection then ToggleNoclip(false) end
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            if not F.InfiniteEnergy then return end
            local char = LP.Character
            if char then
                local energy = char:FindFirstChild("Energy") or char:FindFirstChild("Stamina")
                if energy and energy:IsA("NumberValue") then
                    energy.Value = energy.MaxValue or 100
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            if not F.InfiniteSoru then return end
            local char = LP.Character
            if char then
                local soru = char:FindFirstChild("Soru")
                if soru and soru:IsA("NumberValue") then
                    soru.Value = 0
                end
            end
        end)
    end
end)
local AimbotConnection = nil
local function ToggleAimbot(state)
    if state then
        AimbotConnection = RS2.RenderStepped:Connect(function()
            pcall(function()
                if not F.AimbotEnabled then return end
                local cam = WS.CurrentCamera
                local myhrp = HRP()
                if not cam or not myhrp then return end
                local closest = nil
                local closestDist = C.AimbotFOV or 200
                for _, p in ipairs(P:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local phrp = p.Character:FindFirstChild("HumanoidRootPart")
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if phrp and hum and hum.Health > 0 then
                            local screenPos, onScreen = cam:WorldToViewportPoint(phrp.Position)
                            if onScreen then
                                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    closest = phrp
                                end
                            end
                        end
                    end
                end
                if closest then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Position)
                end
            end)
        end)
    else
        if AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
        end
    end
end
task.spawn(function()
    while true do
        task.wait(0.5)
        if F.AimbotEnabled then
            if not AimbotConnection then ToggleAimbot(true) end
        else
            if AimbotConnection then ToggleAimbot(false) end
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoBartiloQuest then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and obj.Name:find("Bartilo") then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                        task.wait(1)
                        pcall(function() fireproximityprompt(pp) end)
                        task.wait(1)
                        CommF("TalkNPC", "Bartilo")
                        CommF("BartiloQuest")
                        CommF("AcceptQuest", "BartiloQuest")
                    end
                end
            end
            local bartiloMobs = {"Swan Pirate","Royal Squad","Royal Soldier","Shanda"}
            for _, mobName in ipairs(bartiloMobs) do
                if not F.AutoBartiloQuest then break end
                local mob = FindSmartMob(mobName, 500)
                if mob then
                    local mhrp = mob:FindFirstChild("HumanoidRootPart")
                    if mhrp then
                        SmartPathfind(mhrp.Position, 3)
                        task.wait(0.5)
                        while mob:FindFirstChildOfClass("Humanoid") and mob:FindFirstChildOfClass("Humanoid").Health > 0 and Alive() and F.AutoBartiloQuest do
                            Attack(mob, {"Click","Click","Remote","Click","Click"}, 0.04)
                            task.wait(0.05)
                        end
                    end
                end
            end
        end)
    end
end)
local LegendarySwords = {"Saber","Shisui","Wando","Sadie","Enma","Yama","Tushita"}
local function BuyLegendarySword()
    pcall(function()
        for _, obj in ipairs(WS:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:find("Legendary") or obj.Name:find("Sword Dealer") or obj.Name:find("Shanks")) then
                local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                if pp then
                    local h = HRP()
                    if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                    task.wait(1)
                    pcall(function() fireproximityprompt(pp) end)
                    task.wait(1)
                    for _, sword in ipairs(LegendarySwords) do
                        CommF("BuyItem", sword)
                        CommF("PurchaseItem", sword)
                        CommF("LegendarySword", sword)
                    end
                end
            end
        end
    end)
end
task.spawn(function()
    while true do
        task.wait(30)
        pcall(function()
            if not F.AutoLegendarySword then return end
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoLawRaid then return end
            if not Alive() then return end
            pcall(function()
                CommF("BuyLawRaid")
                CommF("LawRaid")
            end)
            local law = FindMob("Law", 500) or FindMob("Order", 500)
            if law then
                local mhrp = law:FindFirstChild("HumanoidRootPart")
                if mhrp then
                    SmartPathfind(mhrp.Position, 3)
                    task.wait(1)
                    while law:FindFirstChildOfClass("Humanoid") and law:FindFirstChildOfClass("Humanoid").Health > 0 and Alive() and F.AutoLawRaid do
                        Attack(law, {"Click","Click","Click","Click","Remote","Click","Ability"}, 0.04)
                        _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                        task.wait(0.06)
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoObservationHaki then return end
            if not Alive() then return end
            CommF("KenHaki")
            CommF("ActivateHaki", "Ken")
            CommF("ToggleHaki", "Ken")
            for _, fname in ipairs({"Enemies","NPCs","Living"}) do
                local f = WS:FindFirstChild(fname)
                if f then
                    for _, mob in ipairs(f:GetDescendants()) do
                        if not F.AutoObservationHaki then break end
                        if mob:IsA("Model") then
                            local mh = mob:FindFirstChildOfClass("Humanoid")
                            local mhrp = mob:FindFirstChild("HumanoidRootPart")
                            if mh and mh.Health > 0 and mhrp then
                                local myhrp = HRP()
                                if myhrp and (myhrp.Position - mhrp.Position).Magnitude < 30 then
                                    task.wait(0.5)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoMastery600 then return end
            if not Alive() then return end
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if not tool then
                EquipBest()
                task.wait(0.5)
                tool = LP.Character:FindFirstChildOfClass("Tool")
            end
            local mob = FindSmartMob("", 500)
            if mob then
                local mhrp = mob:FindFirstChild("HumanoidRootPart")
                if mhrp then
                    SmartPathfind(mhrp.Position, 3)
                    task.wait(0.5)
                    while mob:FindFirstChildOfClass("Humanoid") and mob:FindFirstChildOfClass("Humanoid").Health > 0 and Alive() and F.AutoMastery600 do
                        Attack(mob, {"Click","Click","Remote","Click","Click"}, 0.04)
                        task.wait(0.05)
                        local t = LP.Character:FindFirstChildOfClass("Tool")
                        if t then
                            local mastery = t:FindFirstChild("Level") or t:FindFirstChild("Mastery")
                            if mastery and mastery.Value >= 600 then
                                Notify("Mastery", t.Name .. " reached 600!", 5)
                                F.AutoMastery600 = false
                                break
                            end
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoBuddhaTransform then return end
            CommF("BuddhaTransformation")
            CommF("TransformBuddha")
            CommF("BuddhaTransform")
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(10)
        pcall(function()
            if not F.AutoRandomFruit then return end
            CommF("BuyRandomFruit")
            CommF("RandomFruit")
            CommF("SpinFruit")
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(30)
        pcall(function()
            if not F.AutoBuyFruitStock then return end
            local fruitList = {"Dragon","Leopard","Spirit","Dough","Buddha","Control","Kitsune"}
            for _, fruit in ipairs(fruitList) do
                CommF("BuyItem", fruit)
                CommF("PurchaseFruit", fruit)
                CommF("BuyFruit", fruit)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoCollectBerries then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoCollectBerries then break end
                if obj:IsA("BasePart") and (obj.Name:find("Berry") or obj.Name:find("Ember") or obj.Name:find("Egg")) then
                    SmartPathfind(obj.Position + Vector3.new(0,2,0), 3)
                    task.wait(0.5)
                    pcall(function()
                        local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                        if pp then fireproximityprompt(pp) end
                    end)
                    pcall(function()
                        if EXP.firetouch then
                            firetouchinterest(HRP(), obj, 0)
                            task.wait(0.1)
                            firetouchinterest(HRP(), obj, 1)
                        end
                    end)
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(10)
        pcall(function()
            if not F.AutoGhoulRace then return end
            if not Alive() then return end
            local ghoulMobs = {"Swan Pirate","Military Spy","Factory Staff"}
            for _, mobName in ipairs(ghoulMobs) do
                if not F.AutoGhoulRace then break end
                local m = FindSmartMob(mobName, 500)
                if m then
                    local mhrp = m:FindFirstChild("HumanoidRootPart")
                    if mhrp then
                        SmartPathfind(mhrp.Position, 3)
                        task.wait(0.5)
                        while m:FindFirstChildOfClass("Humanoid") and m:FindFirstChildOfClass("Humanoid").Health > 0 and Alive() and F.AutoGhoulRace do
                            Attack(m, {"Click","Click","Remote","Click","Click"}, 0.04)
                            task.wait(0.05)
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoPrehistoricIsland then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoPrehistoricIsland then break end
                if obj:IsA("BasePart") and (obj.Name:find("Prehistoric") or obj.Name:find("Volcano")) then
                    SmartPathfind(obj.Position + Vector3.new(0,5,0), 5)
                    task.wait(2)
                    local mobs = FindAllMobs(200)
                    for _, mob in ipairs(mobs) do
                        if not F.AutoPrehistoricIsland then break end
                        if mob.Hum.Health > 0 then
                            UltraCombo(mob.Model)
                        end
                    end
                end
            end
        end)
    end
end)
local Boats = {"Sloop","Brigantine","Flower Ship","Fast Boat","Grand Brigade","Leviathan"}
local function SelectBoat(boatName)
    pcall(function()
        CommF("SelectBoat", boatName)
        CommF("BuyBoat", boatName)
        CommF("SpawnBoat", boatName)
    end)
end
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.BoatSpeedEnabled then return end
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:find("Boat") or obj.Name:find("Ship") or obj.Name:find("Sloop")) then
                    local boatSeat = obj:FindFirstChildWhichIsA("VehicleSeat") or obj:FindFirstChildWhichIsA("Seat")
                    if boatSeat then
                        local bodyVelocity = boatSeat:FindFirstChildOfClass("BodyVelocity") or Instance.new("BodyVelocity", boatSeat)
                        bodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
                        bodyVelocity.Velocity = obj.CFrame.LookVector * (C.BoatSpeed or 100)
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if not F.ChestHop then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.ChestHop then break end
                if obj:IsA("BasePart") and (obj.Name:find("Chest") or obj.Name:find("Treasure")) then
                    if obj.Transparency ~= 1 then
                        SmartPathfind(obj.Position + Vector3.new(0,2,0), 3)
                        task.wait(0.5)
                        pcall(function()
                            if EXP.firetouch then
                                firetouchinterest(HRP(), obj, 0)
                                task.wait(0.1)
                                firetouchinterest(HRP(), obj, 1)
                            end
                        end)
                        pcall(function()
                            local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                            if pp then fireproximityprompt(pp) end
                        end)
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(30)
        pcall(function()
            if not F.AutoCraftItems then return end
            CommF("CraftItem")
            CommF("ForgeItem")
            CommF("UpgradeWeapon")
        end)
    end
end)
local function QuestBypass()
    pcall(function()
        CommF("QuestBypass")
        CommF("BypassQuest")
        CommF("SkipQuest")
        CommF("CompleteQuest")
        CommF("FinishQuest")
    end)
end
local function SendCustomWebhook(title, description, color)
    if not C.WebhookURL or C.WebhookURL == "" then return end
    pcall(function()
        local data = {
            ["embeds"] = {{
                ["title"] = title or "Apex Hub",
                ["description"] = description or "",
                ["color"] = color or 16711680,
                ["footer"] = {["text"] = "Apex Hub v11.0 | " .. os.date("%Y-%m-%d %H:%M:%S")}
            }}
        }
        local json = HS:JSONEncode(data)
        HTTP({Url = C.WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = json})
    end)
end
task.spawn(function()
    while true do
        task.wait(30)
        pcall(function()
            if not F.AutoBuyBusoColors then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Barista") or obj.Name:find("Cousin")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                        task.wait(1)
                        pcall(function() fireproximityprompt(pp) end)
                        task.wait(1)
                        CommF("BuyBusoColor")
                        CommF("BusoColor")
                    end
                end
            end
        end)
    end
end)
local Islands = {"Starter Island","Marine Fortress","Sky Island","Prison","Underwater City","Frozen Village","Hot and Cold","Magma Village","Colosseum","Forgotten Island","Usoapp Island","Third Sea","Haunted Castle","Candy","Chocolate","Island Empress","Tide Keeper","Beautiful Pirate","Longma","Dough King","Cake Queen","Cookie Crafter","Cursed Captain","Ghost Ship","Kitsune Island","Leviathan","Mirage Island"}
local function GetIslandList()
    local islands = {}
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Folder") and (obj.Name:find("Island") or obj.Name:find("Map")) then
            table.insert(islands, obj.Name)
        end
    end
    return islands
end
local function GetPlayerWeaponList()
    local weapons = {}
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                table.insert(weapons, t.Name)
            end
        end
    end
    local char = LP.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then
                table.insert(weapons, t.Name)
            end
        end
    end
    return weapons
end
local function GetPlayerFruits()
    local fruits = {}
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local fd = GetFD(t.Name)
                if fd then table.insert(fruits, {Name=t.Name, Rarity=fd.R, Value=GetFruitValue(t.Name)}) end
            end
        end
    end
    return fruits
end
local function GetServerPlayerCount()
    return #P:GetPlayers()
end
local function GetNearestPlayer()
    local myHRP = HRP()
    if not myHRP then return nil, math.huge end
    local closest, closestDist = nil, math.huge
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            local phrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if phrp and hum and hum.Health > 0 then
                local d = (myHRP.Position - phrp.Position).Magnitude
                if d < closestDist then
                    closestDist = d
                    closest = p
                end
            end
        end
    end
    return closest, closestDist
end
local function GetAllFruitsOnMap()
    local found = {}
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("Tool") or (obj:IsA("Model") and obj.Name:find("Fruit")) then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
            if handle then
                table.insert(found, {Obj=obj, Name=obj.Name, Pos=handle.Position})
            end
        end
    end
    return found
end
local function IsInSafeZone()
    local myHRP = HRP()
    if not myHRP then return false end
    local safePositions = {
        Vector3.new(0, 100, 0),
        Vector3.new(-2500, 200, -500),
        Vector3.new(4500, 200, 7800)
    }
    for _, pos in ipairs(safePositions) do
        if (myHRP.Position - pos).Magnitude < 100 then
            return true
        end
    end
    return false
end
local function GetQuestProgress()
    local progress = {Level=Lv(), Beli=Beli(), Fragments=Frags(), Sea=Sea(), Bounty=Bounty(), Race=GetRace()}
    pcall(function()
        local data = LP:FindFirstChild("Data")
        if data then
            local sp = data:FindFirstChild("StatPoints")
            if sp and sp:IsA("IntValue") then progress.StatPoints = sp.Value end
        end
        local quests = LP:FindFirstChild("Quests")
        if quests then
            for _, q in ipairs(quests:GetChildren()) do
                if q:IsA("IntValue") then
                    progress[q.Name] = q.Value
                end
            end
        end
    end)
    return progress
end
local function FormatNumber(n)
    if n >= 1000000000 then
        return string.format("%.1fB", n / 1000000000)
    elseif n >= 1000000 then
        return string.format("%.1fM", n / 1000000)
    elseif n >= 1000 then
        return string.format("%.1fK", n / 1000)
    end
    return tostring(n)
end
local function GetFormattedBounty()
    return FormatNumber(Bounty())
end
local function GetFormattedLevel()
    return tostring(Lv())
end
local function EmergencyTP()
    InstantTP(Vector3.new(0, 100, 0))
    Notify("Emergency", "Teleported to sky safe zone!", 3)
end
local function EmergencyHeal()
    pcall(function()
        CommF("Heal")
        CommF("FullHeal")
        CommF("RestoreHealth")
    end)
    Notify("Emergency", "Attempting to heal...", 3)
end
local function EmergencyUnstuck()
    pcall(function()
        ClearCharCache()
        task.wait(1)
        local char = LP.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(0, 50, 0)
            end
        end
    end)
    Notify("Emergency", "Unstuck attempt complete!", 3)
end
task.spawn(function()
    while true do
        task.wait(10)
        pcall(function()
            if not F.AutoFishing then return end
            if not Alive() then return end
            CommF("FishingQuest")
            CommF("AcceptFishingQuest")
            CommF("StartFishingQuest")
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(15)
        pcall(function()
            if not F.AutoFishing then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoFishing then break end
                if obj:IsA("BasePart") and (obj.Name:find("Sunken") or obj.Name:find("Treasure")) then
                    SmartPathfind(obj.Position + Vector3.new(0,2,0), 3)
                    task.wait(1)
                    pcall(function()
                        local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                        if pp then fireproximityprompt(pp) end
                    end)
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.AutoTrade then return end
            local gui = LP.PlayerGui:FindFirstChild("TradeGui") or LP.PlayerGui:FindFirstChild("TradingGui")
            if gui then
                local myFruits = GetPlayerFruits()
                local totalValue = 0
                for _, fruit in ipairs(myFruits) do
                    totalValue = totalValue + fruit.Value
                end
                if totalValue > 0 then
                    Notify("Trade", "Your fruits value: $"..FormatNumber(totalValue), 3)
                end
                if F.AutoFreezeTrade then
                    for _, frame in ipairs(gui:GetDescendants()) do
                        if frame:IsA("Frame") and frame.Name:find("Trade") then
                            frame.Active = false
                        end
                    end
                end
                for _, btn in ipairs(gui:GetDescendants()) do
                    if btn:IsA("TextButton") then
                        if btn.Name:find("Accept") or btn.Text:find("Accept") then
                            btn:Activate()
                        end
                        if btn.Name:find("Confirm") or btn.Text:find("Confirm") then
                            btn:Activate()
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            if not F.NoclipEnabled then return end
            local char = LP.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            if not F.AimbotEnabled then return end
            if not Alive() then return end
            local cam = WS.CurrentCamera
            local myhrp = HRP()
            if not cam or not myhrp then return end
            local closest = nil
            local closestDist = C.AimbotFOV or 200
            for _, p in ipairs(P:GetPlayers()) do
                if p ~= LP and p.Character then
                    local phrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local phum = p.Character:FindFirstChildOfClass("Humanoid")
                    if phrp and phum and phum.Health > 0 then
                        if not (LP.Team and p.Team and LP.Team == p.Team) then
                            local screenPos, onScreen = cam:WorldToViewportPoint(phrp.Position)
                            if onScreen then
                                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    closest = phrp
                                end
                            end
                        end
                    end
                end
            end
            if closest then
                local targetCF = CFrame.new(cam.CFrame.Position, closest.Position)
                cam.CFrame = cam.CFrame:Lerp(targetCF, 0.3)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoLegendarySword then return end
            if not Alive() then return end
            for _, sword in ipairs(LegendarySwords) do
                if not F.AutoLegendarySword then break end
                if not HasWeapon(sword) then
                    CommF("BuyItem", sword)
                    CommF("PurchaseItem", sword)
                    CommF("LegendarySword", sword)
                    task.wait(1)
                end
            end
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Legendary") or obj.Name:find("Sword Dealer") or obj.Name:find("Shanks")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                        task.wait(1)
                        pcall(function() fireproximityprompt(pp) end)
                        task.wait(1)
                        for _, sword in ipairs(LegendarySwords) do
                            CommF("BuyItem", sword)
                            CommF("PurchaseItem", sword)
                            CommF("LegendarySword", sword)
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoLawRaid then return end
            if not Alive() then return end
            CommF("BuyLawRaid")
            CommF("LawRaid")
            CommF("StartLawRaid")
            CommF("ActivateLawRaid")
            local law = FindMob("Law", 500) or FindMob("Order", 500)
            if law then
                local mhrp = law:FindFirstChild("HumanoidRootPart")
                if mhrp then
                    SmartPathfind(mhrp.Position, 3)
                    task.wait(1)
                    local atk = 0
                    while law:FindFirstChildOfClass("Humanoid") and law:FindFirstChildOfClass("Humanoid").Health > 0 and Alive() and F.AutoLawRaid and atk < 500 do
                        Attack(law, {"Click","Click","Click","Click","Remote","Click","Ability"}, 0.04)
                        atk = atk + 1
                        _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                        task.wait(0.06)
                    end
                    Notify("Law Raid", "Law boss defeated!", 5)
                end
            else
                local raidSpots = {
                    CFrame.new(-5448, 320, -6506),
                    CFrame.new(5800, 8, -3000),
                    CFrame.new(1500, 8, -3000)
                }
                local spot = raidSpots[math.random(1, #raidSpots)]
                TpTo(spot.Position, 400)
                task.wait(5)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoObservationHaki then return end
            if not Alive() then return end
            pcall(function()
                CommF("KenHaki")
                CommF("ActivateHaki", "Ken")
                CommF("ToggleHaki", "Ken")
            end)
            local myhrp = HRP()
            if not myhrp then return end
            local nearest, nearestDist = GetNearestPlayer()
            if nearest and nearestDist < 50 then
                local theirHRP = nearest.Character and nearest.Character:FindFirstChild("HumanoidRootPart")
                if theirHRP then
                    myhrp.CFrame = CFrame.new(theirHRP.Position + Vector3.new(0, 0, 15), theirHRP.Position)
                end
            end
            for _, fname in ipairs({"Enemies","NPCs","Living"}) do
                if not F.AutoObservationHaki then break end
                local f = WS:FindFirstChild(fname)
                if f then
                    for _, mob in ipairs(f:GetDescendants()) do
                        if not F.AutoObservationHaki then break end
                        if mob:IsA("Model") then
                            local mh = mob:FindFirstChildOfClass("Humanoid")
                            local mhrp = mob:FindFirstChild("HumanoidRootPart")
                            if mh and mh.Health > 0 and mhrp then
                                if myhrp and (myhrp.Position - mhrp.Position).Magnitude < 25 then
                                    task.wait(0.3)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoCollectBerries then return end
            if not Alive() then return end
            local collectNames = {"Berry","Ember","Egg","Flower","Shard","Crystal","Fragment","Orb","Token","Coin","Gem","Relic"}
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoCollectBerries then break end
                if obj:IsA("BasePart") then
                    local shouldCollect = false
                    for _, name in ipairs(collectNames) do
                        if obj.Name:find(name) then
                            shouldCollect = true
                            break
                        end
                    end
                    if shouldCollect then
                        SmartPathfind(obj.Position + Vector3.new(0,2,0), 3)
                        task.wait(0.3)
                        pcall(function()
                            local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                            if pp then fireproximityprompt(pp) end
                        end)
                        pcall(function()
                            if EXP.firetouch then
                                firetouchinterest(HRP(), obj, 0)
                                task.wait(0.1)
                                firetouchinterest(HRP(), obj, 1)
                            end
                        end)
                        pcall(function()
                            CommF("PickupItem", obj.Name)
                            CommF("CollectItem", obj.Name)
                        end)
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoGhoulRace then return end
            if not Alive() then return end
            CommF("EctoplasmQuest")
            CommF("AcceptEctoplasmQuest")
            local ghoulMobs = {"Swan Pirate","Military Spy","Factory Staff","Possessed Mummy","Cursed Captain"}
            for _, mobName in ipairs(ghoulMobs) do
                if not F.AutoGhoulRace then break end
                local m = FindSmartMob(mobName, 500)
                if m then
                    local mhrp = m:FindFirstChild("HumanoidRootPart")
                    if mhrp then
                        SmartPathfind(mhrp.Position, 3)
                        task.wait(0.5)
                        local mh = m:FindFirstChildOfClass("Humanoid")
                        local atk = 0
                        while mh and mh.Health > 0 and Alive() and F.AutoGhoulRace and atk < 100 do
                            Attack(m, {"Click","Click","Remote","Click","Click"}, 0.04)
                            atk = atk + 1
                            _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                            task.wait(0.05)
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoPrehistoricIsland then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoPrehistoricIsland then break end
                if obj:IsA("BasePart") and (obj.Name:find("Prehistoric") or obj.Name:find("Volcano") or obj.Name:find("Ancient")) then
                    SmartPathfind(obj.Position + Vector3.new(0,5,0), 5)
                    task.wait(2)
                    local mobs = FindAllMobs(200)
                    for _, mob in ipairs(mobs) do
                        if not F.AutoPrehistoricIsland then break end
                        if mob.Hum.Health > 0 then
                            local mhrp = mob.Model:FindFirstChild("HumanoidRootPart")
                            if mhrp then
                                SmartPathfind(mhrp.Position + Vector3.new(0, 3, 0), 3)
                                task.wait(0.5)
                                UltraCombo(mob.Model)
                            end
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.BoatSpeedEnabled then return end
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:find("Boat") or obj.Name:find("Ship") or obj.Name:find("Sloop") or obj.Name:find("Brigantine")) then
                    local boatSeat = obj:FindFirstChildWhichIsA("VehicleSeat") or obj:FindFirstChildWhichIsA("Seat")
                    if boatSeat then
                        local bv = boatSeat:FindFirstChildOfClass("BodyVelocity")
                        if not bv then
                            bv = Instance.new("BodyVelocity")
                            bv.Parent = boatSeat
                        end
                        bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
                        bv.Velocity = obj.CFrame.LookVector * (C.BoatSpeed or 100)
                        local bg = boatSeat:FindFirstChildOfClass("BodyGyro")
                        if not bg then
                            bg = Instance.new("BodyGyro")
                            bg.Parent = boatSeat
                        end
                        bg.MaxTorque = Vector3.new(0, math.huge, 0)
                        bg.P = 9e4
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if not F.ChestHop then return end
            if not Alive() then return end
            local myHRP = HRP()
            if not myHRP then return end
            local chests = {}
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:find("Chest") or obj.Name:find("Treasure")) then
                    if obj.Transparency ~= 1 then
                        local d = (myHRP.Position - obj.Position).Magnitude
                        table.insert(chests, {Obj=obj, Dist=d})
                    end
                end
            end
            table.sort(chests, function(a,b) return a.Dist < b.Dist end)
            for _, ch in ipairs(chests) do
                if not F.ChestHop then break end
                if not Alive() then break end
                if ch.Dist < 150 then
                    SmartPathfind(ch.Obj.Position + Vector3.new(0,2,0), 3)
                    task.wait(0.3)
                    pcall(function()
                        if EXP.firetouch then
                            firetouchinterest(HRP(), ch.Obj, 0)
                            task.wait(0.1)
                            firetouchinterest(HRP(), ch.Obj, 1)
                        end
                    end)
                    pcall(function()
                        local pp = ch.Obj:FindFirstChildOfClass("ProximityPrompt")
                        if pp then fireproximityprompt(pp) end
                    end)
                    pcall(function()
                        CommF("PickupChest", ch.Obj.Name)
                        CommF("CollectChest", ch.Obj.Name)
                        CommF("CollectReward")
                    end)
                    task.wait(0.5)
                else
                    TpTo(ch.Obj.Position, 500)
                    task.wait(2)
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(15)
        pcall(function()
            if not F.AutoCraftItems then return end
            CommF("CraftItem")
            CommF("ForgeItem")
            CommF("UpgradeWeapon")
            CommF("EnhanceItem")
            CommF("UpgradeSword")
            CommF("EvolveWeapon")
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(10)
        pcall(function()
            if not F.QuestBypass then return end
            QuestBypass()
            CommF("CompleteAllQuests")
            CommF("FinishAllQuests")
            CommF("SkipAllQuests")
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(15)
        pcall(function()
            if not F.AutoBuyBusoColors then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Barista") or obj.Name:find("Cousin") or obj.Name:find("Haki")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                        task.wait(1)
                        pcall(function() fireproximityprompt(pp) end)
                        task.wait(1)
                        CommF("BuyBusoColor")
                        CommF("BusoColor")
                        CommF("BuyColor")
                        CommF("PurchaseColor")
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.SmartSafeZone then return end
            if not Alive() then return end
            local h = HRP()
            if not h then return end
            if HP() < 15 then
                EmergencyTP()
                task.wait(5)
                return
            end
            local nearest, nearestDist = GetNearestPlayer()
            if nearest and nearestDist < 60 then
                local theirBounty = 0
                local pd = nearest:FindFirstChild("Data") or nearest:FindFirstChild("leaderstats")
                if pd then
                    local b = pd:FindFirstChild("Bounty") or pd:FindFirstChild("bounty")
                    if b and b:IsA("IntValue") then theirBounty = b.Value end
                end
                if theirBounty > Bounty() * 2 then
                    EmergencyTP()
                    task.wait(5)
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.AntiStuck then return end
            if not Alive() then return end
            local h = HRP()
            if not h then return end
            local lastCheckPos = h.Position
            task.wait(10)
            if not Alive() then return end
            local h2 = HRP()
            if not h2 then return end
            if (h2.Position - lastCheckPos).Magnitude < 1 then
                pcall(function()
                    ClearCharCache()
                    LP.Character:BreakJoints()
                end)
                task.wait(3)
                ClearCharCache()
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if not F.SafeTween then return end
            if not Alive() then return end
            local h = HRP()
            if not h then return end
            if _G.Apex.IsMoving then
                local pos1 = h.Position
                task.wait(5)
                if _G.Apex.IsMoving and Alive() then
                    local h2 = HRP()
                    if h2 and (h2.Position - pos1).Magnitude < 0.5 then
                        CancelMove()
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.AutoFarmBones then return end
            if not Alive() then DeathWait(); return end
            local h = HRP()
            if not h then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoFarmBones then break end
                if obj:IsA("BasePart") and (obj.Name:find("Bone") or obj.Name:find("Bones")) then
                    local handle = obj
                    local d = (h.Position - handle.Position).Magnitude
                    if d <= 500 then
                        SmartPathfind(handle.Position + Vector3.new(0, 2, 0))
                        task.wait(0.3)
                        pcall(function()
                            local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                            if pp then fireproximityprompt(pp) end
                        end)
                        pcall(function()
                            if EXP.firetouch then
                                firetouchinterest(HRP(), obj, 0)
                                task.wait(0.1)
                                firetouchinterest(HRP(), obj, 1)
                            end
                        end)
                        pcall(function()
                            CommF("PickupItem", "Bones")
                            CommF("CollectItem", "Bones")
                        end)
                        task.wait(0.2)
                    end
                end
            end
            local boneMobs = {"Skeleton","Possessed Mummy"}
            for _, mobName in ipairs(boneMobs) do
                if not F.AutoFarmBones then break end
                local mob = FindMob(mobName, 500)
                if mob then
                    local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                    if mhrp then
                        if (h.Position - mhrp.Position).Magnitude > 12 then
                            SmartPathfind(mhrp.Position + Vector3.new(0, 3, 0))
                        else
                            Attack(mob, {"Click","Click","Click","Remote","Click"}, 0.05)
                            _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.AutoFarmCandy then return end
            if not Alive() then DeathWait(); return end
            local h = HRP()
            if not h then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoFarmCandy then break end
                if obj:IsA("BasePart") and (obj.Name:find("Candy") or obj.Name:find("Sweet") or obj.Name:find("Chocolate") or obj.Name:find("Lollipop")) then
                    local handle = obj
                    local d = (h.Position - handle.Position).Magnitude
                    if d <= 500 then
                        SmartPathfind(handle.Position + Vector3.new(0, 2, 0))
                        task.wait(0.3)
                        pcall(function()
                            local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                            if pp then fireproximityprompt(pp) end
                        end)
                        pcall(function()
                            if EXP.firetouch then
                                firetouchinterest(HRP(), obj, 0)
                                task.wait(0.1)
                                firetouchinterest(HRP(), obj, 1)
                            end
                        end)
                        pcall(function()
                            CommF("PickupItem", "Candy")
                            CommF("CollectItem", "Candy")
                        end)
                        task.wait(0.2)
                    end
                end
            end
            local candyMobs = {"Cookie Crafter","Candy Rebel","Sweet Thief"}
            for _, mobName in ipairs(candyMobs) do
                if not F.AutoFarmCandy then break end
                local mob = FindMob(mobName, 500)
                if mob then
                    local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                    if mhrp then
                        if (h.Position - mhrp.Position).Magnitude > 12 then
                            SmartPathfind(mhrp.Position + Vector3.new(0, 3, 0))
                        else
                            Attack(mob, {"Click","Click","Click","Remote","Click"}, 0.05)
                            _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoSecondSea then return end
            if not Alive() then DeathWait(); return end
            local level = Lv()
            if level < 700 then
                Notify("Second Sea", "Need Lv 700+ (Current: "..level..")", 5)
                task.wait(30)
                return
            end
            if Sea() >= 2 then
                Notify("Second Sea", "Already in Sea 2+!", 5)
                F.AutoSecondSea = false
                return
            end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoSecondSea then break end
                if obj:IsA("Model") and (obj.Name:find("Military Officer") or obj.Name:find("Military") or obj.Name:find("QuestGiver")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                        task.wait(0.5)
                        pcall(function() fireproximityprompt(pp) end)
                    end
                end
            end
            pcall(function()
                CommF("MilitaryOfficerQuest")
                CommF("AcceptMilitaryQuest")
                CommF("StartQuest", "MilitaryQuest", 1)
                CommF("AcceptQuest", "MilitaryQuest")
                CommF("SecondSea")
                CommF("TravelToSecondSea")
                CommF("DressQuest")
            end)
            task.wait(3)
            local mobNames = {"Military Spy","Scientist"}
            for _, mobName in ipairs(mobNames) do
                if not F.AutoSecondSea then break end
                local mob = FindMob(mobName, 1000)
                if mob then
                    local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                    if mhrp then
                        SmartPathfind(mhrp.Position + Vector3.new(0, 3, 0))
                        task.wait(0.5)
                        local mh = mob:FindFirstChildOfClass("Humanoid")
                        local atk = 0
                        while mh and mh.Health > 0 and Alive() and F.AutoSecondSea and atk < 100 do
                            Attack(mob, {"Click","Click","Click","Remote","Click"}, 0.05)
                            atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1; task.wait(0.06)
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoThirdSea then return end
            if not Alive() then DeathWait(); return end
            local level = Lv()
            if level < 1500 then
                Notify("Third Sea", "Need Lv 1500+ (Current: "..level..")", 5)
                task.wait(30)
                return
            end
            if Sea() >= 3 then
                Notify("Third Sea", "Already in Sea 3+!", 5)
                F.AutoThirdSea = false
                return
            end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoThirdSea then break end
                if obj:IsA("Model") and (obj.Name:find("Dead Receiver") or obj.Name:find("Alchemist") or obj.Name:find("Los") or obj.Name:find("ThirdSea")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                        task.wait(0.5)
                        pcall(function() fireproximityprompt(pp) end)
                    end
                end
            end
            pcall(function()
                CommF("DeadReceiver")
                CommF("TalkToDeadReceiver")
                CommF("AlchemistQuest")
                CommF("AcceptAlchemistQuest")
                CommF("ThirdSea")
                CommF("TravelToThirdSea")
                CommF("LosTunidosQuest")
                CommF("TalkToAlchemist")
                CommF("StartQuest", "AlchemistQuest")
            end)
            task.wait(3)
            local collectNames = {"Red Flower", "Blue Flower", "Yellow Flower"}
            for _, fn in ipairs(collectNames) do
                if not F.AutoThirdSea then break end
                for _, obj in ipairs(WS:GetDescendants()) do
                    if not F.AutoThirdSea then break end
                    if obj:IsA("Model") and obj.Name:find(fn) then
                        local handle = obj:FindFirstChildWhichIsA("BasePart")
                        if handle then
                            SmartPathfind(handle.Position + Vector3.new(0, 2, 0))
                            task.wait(0.5)
                            pcall(function()
                                local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                                if pp then fireproximityprompt(pp) end
                            end)
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.AutoTreeDestroyer then return end
            if not Alive() then DeathWait(); return end
            local h = HRP()
            if not h then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoTreeDestroyer then break end
                if obj:IsA("Model") and (obj.Name:find("Tree") or obj.Name:find("Log") or obj.Name:find("Wood") or obj.Name:find("Palm")) then
                    local handle = obj:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        local d = (h.Position - handle.Position).Magnitude
                        if d <= C.TreeFarmRange then
                            SmartPathfind(handle.Position + Vector3.new(0, 3, 0))
                            task.wait(0.5)
                            local atk = 0
                            local mh = obj:FindFirstChildOfClass("Humanoid")
                            if mh and mh.Health > 0 then
                                while mh and mh.Health > 0 and Alive() and F.AutoTreeDestroyer and atk < 50 do
                                    Attack(obj, {"Click","Click","Remote","Click"}, 0.05)
                                    atk = atk + 1; _G.Apex.AtkCount = (_G.Apex.AtkCount or 0) + 1; task.wait(0.06)
                                end
                            else
                                pcall(function()
                                    local p = UIS:GetMouseLocation()
                                    VIM:SendMouseButtonEvent(p.X, p.Y, 0, true, game, 1)
                                    task.wait(0.03)
                                    VIM:SendMouseButtonEvent(p.X, p.Y, 0, false, game, 1)
                                end)
                                task.wait(0.5)
                            end
                            pcall(function()
                                if EXP.firetouch then
                                    firetouchinterest(HRP(), handle, 0)
                                    task.wait(0.1)
                                    firetouchinterest(HRP(), handle, 1)
                                end
                            end)
                            pcall(function()
                                CommF("PickupItem", obj.Name)
                                CommF("CollectItem", "Wood")
                                CommF("CollectItem", obj.Name)
                            end)
                        end
                    end
                end
            end
        end)
    end
end)
-- ══════════════════════════════════════════════════════════════════════════
-- EXPORTS to _G.Apex (for Part3)
-- ══════════════════════════════════════════════════════════════════════════
if _G.Apex then
    -- Functions defined in Part2
    _G.Apex.QueueScript = QueueScript
    _G.Apex.DoHop = DoHop
    _G.Apex.FindBountyTargets = FindBountyTargets
    _G.Apex.CreateESP = CreateESP
    _G.Apex.ClearESP = ClearESP
    _G.Apex.ScanFruits = ScanFruits
    _G.Apex.CollectFruit = CollectFruit
    _G.Apex.StoreFruit = StoreFruit
    _G.Apex.BuyFromShop = BuyFromShop
    _G.Apex.CollectRaceFragments = CollectRaceFragments
    _G.Apex.GetFruitValue = GetFruitValue
    _G.Apex.FreezeTrade = FreezeTrade
    _G.Apex.AutoAcceptTrade = AutoAcceptTrade
    _G.Apex.SelectBoat = SelectBoat
    _G.Apex.AutoFish = AutoFish
    _G.Apex.SendCustomWebhook = SendCustomWebhook
    _G.Apex.FormatNumber = FormatNumber
    _G.Apex.ApplySpeed = ApplySpeed
    _G.Apex.ApplyDash = ApplyDash
    _G.Apex.ToggleNoclip = ToggleNoclip
    _G.Apex.ToggleInfiniteJump = ToggleInfiniteJump
    _G.Apex.ToggleAimbot = ToggleAimbot
    _G.Apex.BuyLegendarySword = BuyLegendarySword
    _G.Apex.QuestBypass = QuestBypass
    _G.Apex.PvPAttack = PvPAttack
    _G.Apex.GetServers = GetServers
    _G.Apex.SmartShouldHop = SmartShouldHop
    _G.Apex.GetIslandList = GetIslandList
    _G.Apex.GetPlayerWeaponList = GetPlayerWeaponList
    _G.Apex.GetPlayerFruits = GetPlayerFruits
    _G.Apex.GetServerPlayerCount = GetServerPlayerCount
    _G.Apex.GetNearestPlayer = GetNearestPlayer
    _G.Apex.GetAllFruitsOnMap = GetAllFruitsOnMap
    _G.Apex.IsInSafeZone = IsInSafeZone
    _G.Apex.GetQuestProgress = GetQuestProgress
    _G.Apex.GetFormattedBounty = GetFormattedBounty
    _G.Apex.GetFormattedLevel = GetFormattedLevel
    _G.Apex.EmergencyTP = EmergencyTP
    _G.Apex.EmergencyHeal = EmergencyHeal
    _G.Apex.EmergencyUnstuck = EmergencyUnstuck
    -- Data tables
    _G.Apex.ESPObjects = ESPObjects
    _G.Apex.RainParts = RainParts
    _G.Apex.Highlights = Highlights
    _G.Apex.Boats = Boats
    _G.Apex.FishingRods = FishingRods
    _G.Apex.BaitTypes = BaitTypes
    _G.Apex.BountyState = BountyState
    _G.Apex.flyBV = flyBV
    _G.Apex.flyBG = flyBG
end