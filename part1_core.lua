local P = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local HS = game:GetService("HttpService")
local RS2 = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")
local TPS = game:GetService("TeleportService")
local SG = game:GetService("StarterGui")
local Debris = game:GetService("Debris")
local PathService = game:GetService("PathfindingService")
local Stats = game:GetService("Stats")
local Light = game:GetService("Lighting")
local LP = P.LocalPlayer
local Mouse = LP:GetMouse()
local Cam = WS.CurrentCamera
local EXEC = (function()
    if syn then return "Synapse" end
    if isKRNL and isKRNL() then return "KRNL" end
    if fluxus then return "Fluxus" end
    if getexecutorname then return getexecutorname() end
    if SOLARA then return "Solara" end
    return "Unknown"
end)()
local EXP = {
    http = (http_request or syn and syn.request or request) ~= nil,
    clipboard = setclipboard ~= nil,
    drawing = Drawing ~= nil,
    hookfn = hookfunction ~= nil,
    hookmm = hookmetamethod ~= nil,
    newcc = newcclosure ~= nil,
    getgc = getgc ~= nil,
    getconnections = getconnections ~= nil,
    fireprox = fireproximityprompt ~= nil,
    firesig = firesignal ~= nil,
    getcustomasset = getcustomasset ~= nil,
    writefile = writefile ~= nil,
    readfile = readfile ~= nil,
    queuetype = queue_on_teleport ~= nil,
    isfolder = isfolder ~= nil,
    makefolder = makefolder ~= nil,
    isfile = isfile ~= nil
}
local function HTTP(params)
    if syn and syn.request then return syn.request(params) end
    if http_request then return http_request(params) end
    if request then return request(params) end
    return nil
end
local function Clip(t)
    if setclipboard then setclipboard(tostring(t)) end
end
local function Notify(title, text, dur)
    if F.DisableNotify then return end
    pcall(function()
        SG:SetCore("SendNotification", {Title = tostring(title), Text = tostring(text), Duration = dur or 5})
    end)
end
local Cache = {
    Char = nil, HRP = nil, Hum = nil,
    CharTime = 0, HRPTime = 0, HumTime = 0,
    Remotes = {}, LastTick = 0
}
local function CacheChar()
    local now = tick()
    if now - Cache.CharTime > 0.3 then
        Cache.Char = LP.Character
        Cache.CharTime = now
    end
    return Cache.Char
end
local function CacheHRP()
    local now = tick()
    if now - Cache.HRPTime > 0.15 then
        local c = CacheChar()
        Cache.HRP = c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso"))
        Cache.HRPTime = now
    end
    return Cache.HRP
end
local function CacheHum()
    local now = tick()
    if now - Cache.HumTime > 0.15 then
        local c = CacheChar()
        Cache.Hum = c and c:FindFirstChildOfClass("Humanoid")
        Cache.HumTime = now
    end
    return Cache.Hum
end
local function ClearCharCache()
    Cache.CharTime = 0
    Cache.HRPTime = 0
    Cache.HumTime = 0
    Cache.Char = nil
    Cache.HRP = nil
    Cache.Hum = nil
end
local C = {
    WalkSpeed = 16, JumpPower = 50, SafeHP = 25,
    TweenSpeed = 350, ClickDelay = 0.05,
    HopDelay = 10, HopMode = "LowPlayer",
    MinFruitRarity = "Common", StatType = "Melee",
    KillAuraRange = 15, BringMobRange = 30,
    HumanizedMovement = true, AntiDetection = true,
    DiscordWebhook = "", AutoRaidType = "Flame",
    FlySpeed = 50, BountyTargetBounty = 500000,
    CDKSeaTarget = 3, MaxFPS = 60,
    ConfigFolder = "ApexHub", ConfigFile = "config_v12.json",
    RaidChip = "Flame", BountyCombatRange = 50,
    ChestFarmRange = 200, HakiBusoMobs = 50,
    HakiKenHP = 30, FactoryEventSea = 2,
    ComboDelay = 0.15, DodgeRange = 80, DodgeCooldown = 3,
    SmartStat1 = "Melee", SmartStat2 = "Defense",
    SmartStat3 = "Blox Fruit", SmartStatSplit = 50,
    MaterialsTarget = "Ectoplasm", StatusUpdateRate = 1,
    PathfindMaxTime = 5, ShopBuyItem = "",
    DashLength = 30, BoatSpeed = 100,
    AimbotFOV = 200, WebhookURL = "",
    AutoFishingRod = "Rod", AutoFishingBait = "Worm",
    SelectBoat = "Sloop",     AutoFruitList = "Dragon",
    TeleportIsland = "Starter Island",
    UIScale = 1,
    TreeFarmRange = 200
}
local F = {
    AutoFarm=false, AutoQuest=true, FastAttack=true,
    AutoBossFarm=false, AutoMasteryFruit=false, AutoMasterySword=false,
    AutoStats=false, LowHP=false, KillAura=false, BringMob=false,
    AutoFindFruits=false, AutoStoreFruits=false, FruitSniper=false,
    AutoDealerRoll=false, FruitRain=false, FruitRainType="All",
    AutoMirage=false, AutoSeaBeast=false, AutoRaceV4=false, AutoTrial=false,
    AutoRaid=false, AutoDungeon=false,
    ESPPlayers=false, ESPFruits=false, ESPChests=false, ESPFlowers=false, ESPBosses=false,
    ESPBorders=false, ESPSeaBeast=false,
    ServerHop=false, AntiAFK=true, Fly=false, AutoSetSpawn=false,
    AutoRaidInner=false, RaidAutoStart=false, RaidAutoRotate=false,
    AutoCDK=false, CDKAutoWisps=false, CDKAutoElites=false, CDKAutoSoulReaper=false, CDKAutoScrolls=false,
    BountyHunt=false, BountyAutoAttack=false, FPSLimit=false,
    AutoChestFarm=false, AutoHakiBuso=false, AutoHakiKen=false,
    AutoFactoryEvent=false, AutoGodHuman=false, AutoSoulGuitar=false,
    AutoTuskV4=false, AutoDarkBlade=false, AutoSharkAnchor=false,
    AutoCanvander=false, AutoLegendSword=false, AutoMaterialsFarm=false,
    SmartStatDist=false, AutoDodge=false, ComboAttack=false,
    PlayerHighlight=false, FPSBoost=false, ShowStatusBar=true,
    AutoAwakenFruit=false, SmartPathfind=true, SmartServerHop=true,
    PredictionCombat=true, AutoBuyShop=false, AutoCollectFragments=false,
    AutoBusoHaki=false, AutoKenHaki=false,
    AutoFruitSkillChain=false, AutoSwordSkillChain=false, UltraComboMode=false,
    AutoDragonTalon=false, AutoDeathStep=false, AutoSharkKarate=false, AutoElectricClaw=false,
    AutoDoughKing=false, AutoBardQuest=false,
    AutoFrozenDimension=false, AutoMirrorDimension=false,
    AutoMaterialDetector=false, AutoRevenge=false,
    SmartSafeZone=false, FarmAll=false,
    AutoFishing=false, AutoTrade=false, AutoFreezeTrade=false,
    NoclipEnabled=false, InfiniteJump=false, InfiniteEnergy=false, InfiniteSoru=false,
    AimbotEnabled=false, AutoBartiloQuest=false, AutoLegendarySword=false,
    AutoLawRaid=false, AutoObservationHaki=false, AutoMastery600=false,
    AutoBuddhaTransform=false, AutoRandomFruit=false, AutoBuyFruitStock=false,
    AutoCollectBerries=false, AutoGhoulRace=false, AutoPrehistoricIsland=false,
    BoatSpeedEnabled=false, ChestHop=false, AutoCraftItems=false,
    QuestBypass=false, AutoBuyBusoColors=false,
    AutoBossDropSaber=false, AutoBossDropPole=false, AutoBossDropSharkSaw=false,
    AutoBossDropTrident=false, AutoBossDropMusket=false, AutoBossDropWardenSword=false,
    AutoBossDropBazooka=false,
    AutoBossDropAcidumRifle=false, AutoBossDropJitte=false, AutoBossDropHellfireTorch=false,
    AutoBossDropSerpentBow=false, AutoBossDropTwinHooks=false, AutoBossDropBuddySword=false,
    AutoBossDropDarkDagger=false,
    AutoDarkDaggerQuest=false, AutoHallowScytheQuest=false, AutoSwanGlassesQuest=false,
    AutoGreybeardQuest=false,
    AutoCitizenQuest=false, AutoRainbowHaki=false, AutoHolyTorch=false,
    AutoEnhancementColor=false,
    AutoDungeonFull=false,
    AutoRaceDoor=false, AutoAutoTrial=false, AutoTrainRace=false,
    AutoBuyGear=false,
    AutoTPMirage=false, AutoTPBlueGear=false, AutoTPKitsune=false,
    AutoAzureEmber=false, AutoKillTerrorshark=false, AutoKillPiranha=false,
    AutoKillFishCrew=false,
    AutoBuyFightingStyles=false, AutoBuySwords=false,
    AutoBuyGuns=false, AutoBuyAbilities=false,
    AutoRefundStat=false, AutoRerollRace=false,
    AutoBuyGhoul=false, AutoBuyCyborg=false, AutoBuyDraco=false,
    NoStunEnabled=false, AutoActiveV3=false, AutoActiveV4Full=false,
    SuperAttack=false, SafeModePvP=false,
    AutoDojo=false,
    AutoFarmBones=false, AutoFarmCandy=false,
    AutoSecondSea=false, AutoThirdSea=false,
    SafeTween=true, AntiStuck=true,
    DisableNotify=false, AutoTreeDestroyer=false
}
local function Alive()
    local c = CacheChar()
    if not c then return false end
    local h = c:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end
local function HRP() return CacheHRP() end
local function Hum() return CacheHum() end
local function HP()
    local h = Hum()
    return h and (h.Health / h.MaxHealth) * 100 or 100
end
local function Lv()
    local d = LP:FindFirstChild("Data")
    return d and d:FindFirstChild("Level") and d.Level.Value or 1
end
local function Beli()
    local d = LP:FindFirstChild("Data")
    return d and d:FindFirstChild("Beli") and d.Beli.Value or 0
end
local function Frags()
    local d = LP:FindFirstChild("Data")
    return d and d:FindFirstChild("Fragments") and d.Fragments.Value or 0
end
local function Sea()
    local d = LP:FindFirstChild("Data")
    return d and d:FindFirstChild("Sea") and d.Sea.Value or 1
end
local function Bounty()
    local d = LP:FindFirstChild("Data")
    return d and d:FindFirstChild("Bounty") and d.Bounty.Value or 0
end
local function Island()
    local d = LP:FindFirstChild("Data")
    return d and d:FindFirstChild("Island") and d.Island.Value or ""
end
local function GetRace()
    local r = LP:FindFirstChild("Data") and LP.Data:FindFirstChild("Race")
    return r and r.Value or "Unknown"
end
local function EnsureFolder()
    if EXP.isfolder and EXP.makefolder then
        if not isfolder(C.ConfigFolder) then
            pcall(function() makefolder(C.ConfigFolder) end)
        end
    end
end
local function SaveConfig()
    EnsureFolder()
    if not EXP.writefile then return end
    local data = {Config = {}, Flags = {}, Version = "10.0"}
    for k, v in pairs(C) do data.Config[k] = v end
    for k, v in pairs(F) do data.Flags[k] = v end
    pcall(function()
        writefile(C.ConfigFolder.."/"..C.ConfigFile, HS:JSONEncode(data))
        Notify("Config", "Settings saved!", 3)
    end)
end
local function LoadConfig()
    EnsureFolder()
    if not EXP.readfile or not EXP.isfile then return end
    pcall(function()
        local path = C.ConfigFolder.."/"..C.ConfigFile
        if not isfile(path) then return end
        local raw = readfile(path)
        local data = HS:JSONDecode(raw)
        if data and data.Config then
            for k, v in pairs(data.Config) do
                if C[k] ~= nil then C[k] = v end
            end
        end
        if data and data.Flags then
            for k, v in pairs(data.Flags) do
                if F[k] ~= nil then F[k] = v end
            end
        end
        Notify("Config", "Settings loaded!", 3)
    end)
end
local function DeleteConfig()
    pcall(function()
        if EXP.isfolder and isfolder(C.ConfigFolder) then
            if delfolder then delfolder(C.ConfigFolder) end
            if delfile then delfile(C.ConfigFolder.."/"..C.ConfigFile) end
        end
        Notify("Config", "Config deleted", 3)
    end)
end
LoadConfig()
task.spawn(function()
    while true do
        task.wait(120)
        if EXP.writefile then SaveConfig() end
    end
end)
local IsMoving = false
local function HumanizedOffset()
    if not C.HumanizedMovement then return Vector3.new(0, 0, 0) end
    return Vector3.new(
        math.random(-10, 10) / 100,
        math.random(20, 40) / 10,
        math.random(-10, 10) / 100
    )
end
local function TpTo(pos, spd)
    if not Alive() then return false end
    local h = HRP()
    if not h then return false end
    spd = spd or C.TweenSpeed
    local d = (h.Position - pos).Magnitude
    if d < 3 then h.CFrame = CFrame.new(pos + HumanizedOffset()); return true end
    IsMoving = true
    local t = math.clamp(d / spd, 0.05, 12)
    local goal = {CFrame = CFrame.new(pos + HumanizedOffset())}
    local info = TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tw = TS:Create(h, info, goal)
    local done = false
    tw.Completed:Connect(function() done = true end)
    tw:Play()
    local el = 0
    local lastPos = h.Position
    local stuckTimer = 0
    while not done and el < t + 1 do
        task.wait(0.05); el = el + 0.05
        if not Alive() or not IsMoving then tw:Cancel(); IsMoving = false; return false end
        if F.SafeTween then
            local curPos = h.Position
            if (curPos - lastPos).Magnitude < 0.5 then
                stuckTimer = stuckTimer + 0.05
            else
                stuckTimer = 0
            end
            lastPos = curPos
            if stuckTimer >= 5 then
                tw:Cancel(); IsMoving = false
                pcall(function()
                    h.CFrame = CFrame.new(pos + HumanizedOffset())
                end)
                task.wait(0.5)
                return TpTo(pos, spd)
            end
        end
    end
    IsMoving = false
    return true
end
local function InstantTP(pos)
    local h = HRP()
    if h then h.CFrame = CFrame.new(pos) end
end
local function CancelMove() IsMoving = false end
local function SmartPathfind(targetPos, maxTime)
    maxTime = maxTime or C.PathfindMaxTime
    if not Alive() then return false end
    local h = HRP()
    if not h then return false end
    local d = (h.Position - targetPos).Magnitude
    if d < 5 then h.CFrame = CFrame.new(targetPos); return true end
    local path = PathService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentCanClimb = false
    })
    local ok, err = pcall(function()
        path:ComputeAsync(h.Position, targetPos)
    end)
    if ok and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for i, wp in ipairs(waypoints) do
            if not Alive() then return false end
            h.CFrame = CFrame.new(wp.Position + Vector3.new(0, 3, 0))
            if wp.Action == Enum.PathWaypointAction.Jump then
                local hum = Hum()
                if hum then hum.Jump = true end
            end
            task.wait(0.05)
            if i > maxTime * 20 then break end
        end
        return true
    else
        return TpTo(targetPos)
    end
end
local function CommF(...)
    local r = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("CommF_")
    if r then r:FireServer(...) end
end
local function FireR(name, ...)
    local r = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild(name)
    if r and r:IsA("RemoteEvent") then r:FireServer(...) end
end
local function CommE(...)
    local r = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("CommE_")
    if r then r:FireServer(...) end
end
local function RandDelay(min, max)
    return min + math.random() * (max - min)
end
local JitterOffset = Vector3.new(0, 0, 0)
local FakePosition = nil
local function ApplyJitter()
    if not C.AntiDetection then return end
    JitterOffset = Vector3.new(
        math.random(-30, 30) / 100,
        math.random(-5, 5) / 100,
        math.random(-30, 30) / 100
    )
end
local function GetJitteredPosition(realPos)
    if not C.AntiDetection then return realPos end
    return realPos + JitterOffset
end
task.spawn(function()
    while true do
        task.wait(RandDelay(0.1, 0.3))
        ApplyJitter()
    end
end)
local origHipHeight = nil
pcall(function()
    if EXP.hookmm and EXP.newcc then
        local oldNC
        oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local m = getnamecallmethod()
            if m == "FireServer" or m == "InvokeServer" then
                local n = self.Name:lower()
                local blk = {"anticheat","ac_","teleportcheck","cheatreport","punish","ban",
                    "detect","antispeed","positioncheck","finger","hwid","gethwid",
                    "integrity","report","kick","fingerprint","valid","check","punishme",
                    "acspeed","acs_position","ac_validate","ac_report"}
                for _, b in ipairs(blk) do
                    if n:find(b) then return nil end
                end
            end
            return oldNC(self, ...)
        end))
        local oldIdx
        oldIdx = hookmetamethod(game, "__index", newcclosure(function(self, k)
            if typeof(self) == "Instance" and self:IsA("HumanoidRootPart") then
                if k == "Velocity" then return Vector3.new(0, 0, 0) end
                if k == "AssemblyLinearVelocity" then
                    local v = oldIdx(self, k)
                    if v.Magnitude > 60 then
                        return Vector3.new(
                            math.clamp(v.X, -40, 40),
                            math.clamp(v.Y, -40, 40),
                            math.clamp(v.Z, -40, 40)
                        )
                    end
                end
                if k == "Position" and IsMoving then
                    local v = oldIdx(self, k)
                    if C.AntiDetection then
                        return v + JitterOffset
                    end
                    return v + Vector3.new(
                        math.random(-5, 5) / 10, 0, math.random(-5, 5) / 10
                    )
                end
            end
            if typeof(self) == "Instance" and self:IsA("Humanoid") then
                if k == "HipHeight" then
                    local v = oldIdx(self, k)
                    if origHipHeight == nil then origHipHeight = v end
                    return origHipHeight
                end
            end
            return oldIdx(self, k)
        end))
        local oldNI
        oldNI = hookmetamethod(game, "__newindex", newcclosure(function(self, k, v)
            if typeof(self) == "Instance" and self:IsA("Humanoid") then
                if k == "Health" then
                    if v <= 0 and self.Health > 0 then
                        local c = self.Parent
                        if c then
                            local p = P:GetPlayerFromCharacter(c)
                            if p == LP then
                                local hrp = c:FindFirstChild("HumanoidRootPart")
                                if hrp and hrp.AssemblyLinearVelocity.Magnitude > 200 then
                                    return
                                end
                            end
                        end
                    end
                end
                if k == "HipHeight" then return end
            end
            return oldNI(self, k, v)
        end))
        print("[Apex] 7-layer AC bypass active (v10)")
    end
end)
task.spawn(function()
    while true do
        task.wait(0.3)
        pcall(function()
            local h = HRP()
            if h and h.AssemblyLinearVelocity.Magnitude > 150 then
                h.AssemblyLinearVelocity = Vector3.new(
                    math.clamp(h.AssemblyLinearVelocity.X, -60, 60),
                    math.clamp(h.AssemblyLinearVelocity.Y, -60, 60),
                    math.clamp(h.AssemblyLinearVelocity.Z, -60, 60)
                )
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            local c = LP.Character
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                if h and h.Health <= 0 then task.wait(RandDelay(1, 3)) end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            local h = Hum()
            if h then
                local hrp = HRP()
                if hrp then
                    local charY = hrp.Position.Y
                    local humY = h.RootPart and h.RootPart.Position.Y or charY
                end
            end
        end)
    end
end)
local Quests = {
    {Min=1,Max=11,Q="BanditQuestGiver",M="Bandit",Pos=CFrame.new(1061,16,3283),Sea=1},
    {Min=12,Max=17,Q="MonkeyQuestGiver",M="Monkey",Pos=CFrame.new(-1449,28,280),Sea=1},
    {Min=18,Max=25,Q="GorillaQuestGiver",M="Gorilla",Pos=CFrame.new(-1252,8,361),Sea=1},
    {Min=30,Max=44,Q="PirateQuestGiver",M="Pirate",Pos=CFrame.new(-1174,20,3555),Sea=1},
    {Min=45,Max=59,Q="BruteQuestGiver",M="Brute",Pos=CFrame.new(-1137,12,3888),Sea=1},
    {Min=60,Max=74,Q="DesertQuestGiver",M="Desert Bandit",Pos=CFrame.new(896,7,4394),Sea=1},
    {Min=75,Max=89,Q="SnowQuestGiver",M="Snow Bandit",Pos=CFrame.new(567,8,-827),Sea=1},
    {Min=90,Max=99,Q="YetiQuestGiver",M="Yeti",Pos=CFrame.new(1122,8,-1661),Sea=1},
    {Min=100,Max=124,Q="MarineQuestGiver",M="Marine",Pos=CFrame.new(-2566,7,6463),Sea=1},
    {Min=125,Max=149,Q="SkyQuestGiver",M="Sky Bandit",Pos=CFrame.new(-4818,718,-2592),Sea=1},
    {Min=150,Max=174,Q="PrisonQuestGiver",M="Prisoner",Pos=CFrame.new(4867,15,742),Sea=1},
    {Min=175,Max=199,Q="DangerousQuestGiver",M="Dangerous Prisoner",Pos=CFrame.new(4867,15,742),Sea=1},
    {Min=200,Max=224,Q="TogaQuestGiver",M="Toga Warrior",Pos=CFrame.new(-1580,7,-2997),Sea=1},
    {Min=225,Max=249,Q="ColosseumQuestGiver",M="Gladiator",Pos=CFrame.new(-1580,7,-2997),Sea=1},
    {Min=250,Max=274,Q="SeaSoldierQuestGiver",M="Sea Soldier",Pos=CFrame.new(-3042,8,5819),Sea=1},
    {Min=275,Max=299,Q="ForgottenQuestGiver",M="Water Fighter",Pos=CFrame.new(-3042,8,5819),Sea=1},
    {Min=300,Max=374,Q="FountainQuestGiver",M="Fountain Crew",Pos=CFrame.new(4030,6,-1570),Sea=2},
    {Min=375,Max=449,Q="ShandaQuestGiver",M="Shanda",Pos=CFrame.new(4755,8,-1450),Sea=2},
    {Min=450,Max=524,Q="RoyalSquadQuestGiver",M="Royal Squad",Pos=CFrame.new(4369,7,-247),Sea=2},
    {Min=525,Max=599,Q="RoyalSoldierQuestGiver",M="Royal Soldier",Pos=CFrame.new(4369,7,-247),Sea=2},
    {Min=600,Max=674,Q="GalleyPirateQuestGiver",M="Galley Pirate",Pos=CFrame.new(4735,8,7874),Sea=2},
    {Min=675,Max=749,Q="GalleyCaptainQuestGiver",M="Galley Captain",Pos=CFrame.new(4735,8,7874),Sea=2},
    {Min=750,Max=799,Q="FishmanQuestGiver",M="Fishman Raider",Pos=CFrame.new(3912,5,-1574),Sea=3},
    {Min=800,Max=874,Q="FishmanCaptainQuestGiver",M="Fishman Captain",Pos=CFrame.new(3912,5,-1574),Sea=3},
    {Min=875,Max=949,Q="SkyQuestGiver2",M="Gods Guard",Pos=CFrame.new(-4614,718,-1903),Sea=3},
    {Min=950,Max=999,Q="ShandianQuestGiver",M="Shandian Warrior",Pos=CFrame.new(-13090,875,-453),Sea=3},
    {Min=1000,Max=1149,Q="BigMomQuestGiver",M="Diabolic Servant",Pos=CFrame.new(-6506,8,-15505),Sea=3},
    {Min=1150,Max=1249,Q="CakeQuestGiver",M="Cookie Crafter",Pos=CFrame.new(-1930,5,-11579),Sea=3},
    {Min=1250,Max=1349,Q="CandyQuestGiver",M="Candy Rebel",Pos=CFrame.new(1470,4,-16403),Sea=3},
    {Min=1350,Max=1499,Q="IsleQuestGiver",M="Isle Outlaw",Pos=CFrame.new(-1190,7,-2345),Sea=3},
    {Min=1500,Max=1700,Q="TikiQuestGiver",M="Island Boy",Pos=CFrame.new(-16388,8,-180),Sea=3},
    {Min=1700,Max=1800,Q="TikiQuestGiver2",M="Island Champion",Pos=CFrame.new(-16388,8,-180),Sea=3},
    {Min=1800,Max=1900,Q="TikiQuestGiver3",M="Island Queen",Pos=CFrame.new(-16388,8,-180),Sea=3},
    {Min=1900,Max=2000,Q="TikiQuestGiver4",M="Island King",Pos=CFrame.new(-16388,8,-180),Sea=3},
    {Min=2000,Max=2100,Q="TikiQuestGiver5",M="Island Emperor",Pos=CFrame.new(-16388,8,-180),Sea=3},
    {Min=2100,Max=2200,Q="TikiQuestGiver6",M="Island Warlord",Pos=CFrame.new(-16388,8,-180),Sea=3},
    {Min=2200,Max=2400,Q="TikiQuestGiver7",M="Island Conqueror",Pos=CFrame.new(-16388,8,-180),Sea=3},
    {Min=2400,Max=2600,Q="TikiQuestGiver8",M="Island Overlord",Pos=CFrame.new(-16388,8,-180),Sea=3},
    {Min=2600,Max=2800,Q="TikiQuestGiver9",M="Island Warlord Elite",Pos=CFrame.new(-16388,8,-180),Sea=3},
    {Min=2800,Max=3000,Q="TikiQuestGiver10",M="Island Conqueror Elite",Pos=CFrame.new(-16388,8,-180),Sea=3}
}
local Bosses = {
    {Name="Bobby",Pos=CFrame.new(-4500,5,7800)},
    {Name="The Vice President",Pos=CFrame.new(-4600,5,7800)},
    {Name="Warden",Pos=CFrame.new(4750,15,810)},
    {Name="Chief Warden",Pos=CFrame.new(4750,15,810)},
    {Name="Swan",Pos=CFrame.new(4750,15,810)},
    {Name="Diamond",Pos=CFrame.new(-3750,8,-860)},
    {Name="Jeremy",Pos=CFrame.new(1850,75,-2600)},
    {Name="Fajita",Pos=CFrame.new(-2350,8,-3420)},
    {Name="Don Swan",Pos=CFrame.new(-2350,8,-3420)},
    {Name="Smoke Admiral",Pos=CFrame.new(-4950,5,820)},
    {Name="Cursed Captain",Pos=CFrame.new(-4950,5,820)},
    {Name="Darkbeard",Pos=CFrame.new(3700,8,-6500)},
    {Name="Order",Pos=CFrame.new(5800,8,-3000)},
    {Name="Rip_Indra",Pos=CFrame.new(-5400,8,9200)},
    {Name="Magma Admiral",Pos=CFrame.new(-4800,5,820)},
    {Name="Fishman Lord",Pos=CFrame.new(4200,5,-1600)},
    {Name="Wysper",Pos=CFrame.new(-7800,5,-2400)},
    {Name="Thunder God",Pos=CFrame.new(-2300,8,-4300)},
    {Name="Saber Expert",Pos=CFrame.new(-1450,8,210)},
    {Name="Katakuri",Pos=CFrame.new(-5700,5,-15700)},
    {Name="Cake Queen",Pos=CFrame.new(-1930,5,-11579)},
    {Name="Longma",Pos=CFrame.new(-1210,8,-1170)},
    {Name="Dough King",Pos=CFrame.new(-2000,8,-1200)},
    {Name="Core Brain",Pos=CFrame.new(1500,8,-3000)},
    {Name="Beautiful Pirate",Pos=CFrame.new(-1250,8,-1200)},
    {Name="Leviathan",Pos=CFrame.new(-5000,10,-10000),Sea=3},
    {Name="Terror Shark",Pos=CFrame.new(-4500,10,-9000),Sea=3},
    {Name="Pirate Millionaire",Pos=CFrame.new(-5000,5,-3000),Sea=3},
    {Name="Stone",Pos=CFrame.new(-5200,5,-3200),Sea=3},
    {Name="Hydra",Pos=CFrame.new(5700,5,500),Sea=3},
    {Name="Tide Keeper",Pos=CFrame.new(4200,5,-1600),Sea=3},
    {Name="Captain Elephant",Pos=CFrame.new(-1350,5,-1150),Sea=3},
    {Name="Beautiful Pirate",Pos=CFrame.new(-1250,8,-1200),Sea=3}
}
local EliteEnemies = {"Diablo", "Urban", "Deandre"}
local Raids = {
    {Name="Flame",Chip="Flame",Pos=CFrame.new(-5448,320,-6506),Boss="Magma Admiral",Level=1100},
    {Name="Ice",Chip="Ice",Pos=CFrame.new(-5448,320,-6506),Boss="Frozen Captain",Level=1100},
    {Name="Quake",Chip="Quake",Pos=CFrame.new(-5448,320,-6506),Boss="Quake User",Level=1100},
    {Name="Light",Chip="Light",Pos=CFrame.new(-5448,320,-6506),Boss="Light Admiral",Level=1250},
    {Name="Dark",Chip="Dark",Pos=CFrame.new(-5448,320,-6506),Boss="Darkbeard",Level=1250},
    {Name="Magma",Chip="Magma",Pos=CFrame.new(-5448,320,-6506),Boss="Magma Commander",Level=1500},
    {Name="Rumble",Chip="Rumble",Pos=CFrame.new(-5448,320,-6506),Boss="Thunder Admiral",Level=1500},
    {Name="Spider",Chip="Spider",Pos=CFrame.new(-5448,320,-6506),Boss="Spider Commander",Level=1750},
    {Name="Buddha",Chip="Buddha",Pos=CFrame.new(-5448,320,-6506),Boss="Buddha Guardian",Level=1750},
    {Name="Phoenix",Chip="Phoenix",Pos=CFrame.new(-5448,320,-6506),Boss="Phoenix Admiral",Level=2000},
    {Name="Dough",Chip="Dough",Pos=CFrame.new(-5448,320,-6506),Boss="Dough Prince",Level=2000}
}
local FruitDB = {
    {N="Spin",R="Common",C=Color3.fromRGB(180,180,180)},
    {N="Blade",R="Common",C=Color3.fromRGB(180,180,180)},
    {N="Bomb",R="Common",C=Color3.fromRGB(180,180,180)},
    {N="Smoke",R="Common",C=Color3.fromRGB(180,180,180)},
    {N="Spike",R="Common",C=Color3.fromRGB(180,180,180)},
    {N="Chop",R="Common",C=Color3.fromRGB(180,180,180)},
    {N="Spring",R="Common",C=Color3.fromRGB(180,180,180)},
    {N="Flame",R="Uncommon",C=Color3.fromRGB(80,200,80)},
    {N="Falcon",R="Uncommon",C=Color3.fromRGB(80,200,80)},
    {N="Ice",R="Uncommon",C=Color3.fromRGB(80,200,80)},
    {N="Sand",R="Uncommon",C=Color3.fromRGB(80,200,80)},
    {N="Dark",R="Uncommon",C=Color3.fromRGB(80,200,80)},
    {N="Diamond",R="Uncommon",C=Color3.fromRGB(80,200,80)},
    {N="Light",R="Uncommon",C=Color3.fromRGB(80,200,80)},
    {N="Rubber",R="Uncommon",C=Color3.fromRGB(80,200,80)},
    {N="Quake",R="Rare",C=Color3.fromRGB(80,120,255)},
    {N="Bird: Phoenix",R="Rare",C=Color3.fromRGB(80,120,255)},
    {N="Buddha",R="Rare",C=Color3.fromRGB(80,120,255)},
    {N="Barrier",R="Rare",C=Color3.fromRGB(80,120,255)},
    {N="Ghost",R="Rare",C=Color3.fromRGB(80,120,255)},
    {N="Magma",R="Rare",C=Color3.fromRGB(80,120,255)},
    {N="Love",R="Legendary",C=Color3.fromRGB(255,170,0)},
    {N="Spider",R="Legendary",C=Color3.fromRGB(255,170,0)},
    {N="Sound",R="Legendary",C=Color3.fromRGB(255,170,0)},
    {N="Phoenix",R="Legendary",C=Color3.fromRGB(255,170,0)},
    {N="Portal",R="Legendary",C=Color3.fromRGB(255,170,0)},
    {N="Rumble",R="Legendary",C=Color3.fromRGB(255,170,0)},
    {N="Shadow",R="Legendary",C=Color3.fromRGB(255,170,0)},
    {N="Blizzard",R="Legendary",C=Color3.fromRGB(255,170,0)},
    {N="Dough",R="Legendary",C=Color3.fromRGB(255,170,0)},
    {N="Control",R="Legendary",C=Color3.fromRGB(255,170,0)},
    {N="Gravity",R="Legendary",C=Color3.fromRGB(255,170,0)},
    {N="Eagle",R="Legendary",C=Color3.fromRGB(255,170,0)},
    {N="Creation",R="Legendary",C=Color3.fromRGB(255,170,0)},
    {N="Lightning",R="Legendary",C=Color3.fromRGB(255,170,0)},
    {N="Dragon",R="Mythical",C=Color3.fromRGB(200,50,50)},
    {N="Leopard",R="Mythical",C=Color3.fromRGB(200,50,50)},
    {N="Kitsune",R="Mythical",C=Color3.fromRGB(200,50,50)},
    {N="Spirit",R="Mythical",C=Color3.fromRGB(200,50,50)},
    {N="T-Rex",R="Mythical",C=Color3.fromRGB(200,50,50)},
    {N="Mammoth",R="Mythical",C=Color3.fromRGB(200,50,50)},
    {N="Yeti",R="Mythical",C=Color3.fromRGB(200,50,50)},
    {N="Leviathan",R="Mythical",C=Color3.fromRGB(200,50,50)}
}
local RO = {Common=1,Uncommon=2,Rare=3,Legendary=4,Mythical=5}
local function GetFD(name)
    for _, f in ipairs(FruitDB) do
        if name:find(f.N) then return f end
    end
    return nil
end
local MaterialsDB = {
    {Name="Ectoplasm",Mobs={"Possessed Mummy","Cursed Captain"},Sea={2,3},Loc="Cursed Ship / Haunted Castle"},
    {Name="Magma Ore",Mobs={"Magma Miner","Fire Starter"},Sea={2},Loc="Magma Village / Hot and Cold"},
    {Name="Leather",Mobs={"Pirate","Brute","Viking"},Sea={1},Loc="Pirate Starter / Middle Town"},
    {Name="Scrap Metal",Mobs={"Pirate","Marine","Soldier"},Sea={1,2},Loc="Various"},
    {Name="Angel Wings",Mobs={"Gods Guard","Shandian Warrior"},Sea={3},Loc="Upper Sky / Great Tree"},
    {Name="Vampire Fang",Mobs={"Vampire","Thirsty Vampire"},Sea={2},Loc="Graveyard"},
    {Name="Yeti Fur",Mobs={"Yeti"},Sea={1},Loc="Frozen Village"},
    {Name="Mini Tusk",Mobs={"Isle Outlaw","Isle Champion"},Sea={3},Loc="Floating Turtle"},
    {Name="Dragon Scale",Mobs={"Dragon Crew Archer","Dragon Crew Warrior"},Sea={3},Loc="Hydra Island"},
    {Name="Concentrated Oxygen",Mobs={"Fishman Raider","Fishman Captain"},Sea={3},Loc="Forgotten Island"},
    {Name="Mystic Droplet",Mobs={"Water Fighter","Tide Keeper"},Sea={2},Loc="Forgotten Island"},
    {Name="Radioactive Material",Mobs={"Lab Subordinate","Vulkan"},Sea={2},Loc="Hot and Cold"},
    {Name="Bones",Mobs={"Skeleton","Possessed Mummy"},Sea={3},Loc="Haunted Castle"},
    {Name="Dark Cloth",Mobs={"Dark Master","Shadow Priest"},Sea={2},Loc="Dark Arena"},
    {Name="Rare Metal",Mobs={"Core Brain"},Sea={2},Loc="Factory"},
    {Name="Flutter Wing",Mobs={"Beautiful Pirate"},Sea={3},Loc="Beautiful Pirate Domain"},
    {Name="Valkyrie Helm",Mobs={"Greybeard"},Sea={2},Loc="Marine Fortress"},
    {Name="Colosseum Disc",Mobs={"Gladiator"},Sea={1},Loc="Colosseum"},
    {Name="Ghost Fragment",Mobs={"Haunted Soldier","Soul Reaper"},Sea={3},Loc="Haunted Castle"},
    {Name="Foolish Gold Ore",Mobs={"Diamond"},Sea={2},Loc="Green Zone"},
    {Name="Azure Embers",Mobs={"Demonic Wisp","Wisp"},Sea={3},Loc="Sea Events"},
    {Name="Leviathan Scale",Mobs={"Leviathan","Terror Shark"},Sea={3},Loc="Deep Sea"},
    {Name="Shark Tooth",Mobs={"Shark","Terror Shark"},Sea={3},Loc="Deep Sea"},
    {Name="Pearl",Mobs={"Sea Beast","Terror Shark"},Sea={3},Loc="Deep Sea Events"},
    {Name="Canine Heart",Mobs={"Wolf","Dog"},Sea={1},Loc="Middle Town"},
    {Name="Remote Fish",Mobs={"Fishman","Shark"},Sea={1},Loc="Underwater City"},
    {Name="Mystic Fog",Mobs={"Ghost","Possessed Mummy"},Sea={3},Loc="Haunted Castle"},
    {Name="Ancient Stone",Mobs={"Diamond","Fajita"},Sea={2},Loc="Green Zone"},
    {Name="Enchanted Scale",Mobs={"Sea Beast","Leviathan"},Sea={3},Loc="Deep Sea Events"}
}
local BossDropWeaponsSea1 = {
    {Name="Saber",Boss="Saber Expert",Weapon="Saber",Pos=CFrame.new(-1450,8,210),Sea=1},
    {Name="Pole 1st Form",Boss="Thunder God",Weapon="Pole v.1",Pos=CFrame.new(-2300,8,-4300),Sea=1},
    {Name="Shark Saw",Boss="The Saw",Weapon="Shark Saw",Pos=CFrame.new(-2500,8,7800),Sea=1},
    {Name="Trident",Boss="Fishman Lord",Weapon="Trident",Pos=CFrame.new(4200,5,-1600),Sea=1},
    {Name="Refined Musket",Boss="Magma Admiral",Weapon="Refined Musket",Pos=CFrame.new(-4800,5,820),Sea=1},
    {Name="Warden Sword",Boss="Chief Warden",Weapon="Warden Sword",Pos=CFrame.new(4750,15,810),Sea=1},
    {Name="Bazooka",Boss="Wysper",Weapon="Bazooka",Pos=CFrame.new(-7800,5,-2400),Sea=1}
}
local BossDropWeaponsSea2 = {
    {Name="Acidum Rifle",Boss="Diamond",Weapon="Acidum Rifle",Pos=CFrame.new(-3750,8,-860),Sea=2},
    {Name="Jitte",Boss="Smoke Admiral",Weapon="Jitte",Pos=CFrame.new(-4950,5,820),Sea=2},
    {Name="Hellfire Torch",Boss="Cursed Captain",Weapon="Hellfire Torch",Pos=CFrame.new(-4950,5,820),Sea=2}
}
local BossDropWeaponsSea3 = {
    {Name="Serpent Bow",Boss="Island Empress",Weapon="Serpent Bow",Pos=CFrame.new(4200,5,-1600),Sea=3},
    {Name="Twin Hooks",Boss="Captain Elephant",Weapon="Twin Hooks",Pos=CFrame.new(-1350,5,-1150),Sea=3},
    {Name="Buddy Sword",Boss="Cake Queen",Weapon="Buddy Sword",Pos=CFrame.new(-1930,5,-11579),Sea=3},
    {Name="Dark Dagger",Boss="rip_indra",Weapon="Dark Dagger",Pos=CFrame.new(-5400,8,9200),Sea=3}
}
local AllBossDropWeapons = {}
for _, v in ipairs(BossDropWeaponsSea1) do table.insert(AllBossDropWeapons, v) end
for _, v in ipairs(BossDropWeaponsSea2) do table.insert(AllBossDropWeapons, v) end
for _, v in ipairs(BossDropWeaponsSea3) do table.insert(AllBossDropWeapons, v) end
local IslandLocations = {
    {Name="Starter Island",Pos=CFrame.new(-2500,10,2000),Sea=1},
    {Name="Marine Fortress",Pos=CFrame.new(-2500,10,2000),Sea=1},
    {Name="Jungle",Pos=CFrame.new(-1450,10,210),Sea=1},
    {Name="Pirate Village",Pos=CFrame.new(-1174,20,3555),Sea=1},
    {Name="Desert",Pos=CFrame.new(896,7,4394),Sea=1},
    {Name="Frozen Village",Pos=CFrame.new(1122,8,-1661),Sea=1},
    {Name="Marine Ford",Pos=CFrame.new(-2566,7,6463),Sea=1},
    {Name="Prison",Pos=CFrame.new(4867,15,742),Sea=1},
    {Name="Magma Village",Pos=CFrame.new(-4800,5,820),Sea=1},
    {Name="Sky Island",Pos=CFrame.new(-4818,718,-2592),Sea=1},
    {Name="Underwater City",Pos=CFrame.new(4200,5,-1600),Sea=1},
    {Name="Colosseum",Pos=CFrame.new(-1580,7,-2997),Sea=1},
    {Name="Hot and Cold",Pos=CFrame.new(-5000,5,-3000),Sea=2},
    {Name="Cursed Ship",Pos=CFrame.new(-5000,5,-8200),Sea=3},
    {Name="Haunted Castle",Pos=CFrame.new(-5000,5,-8200),Sea=3},
    {Name="Turtle Island",Pos=CFrame.new(-16388,8,-180),Sea=3},
    {Name="Port Town",Pos=CFrame.new(-16388,8,-180),Sea=3},
    {Name="Green Zone",Pos=CFrame.new(-3750,8,-860),Sea=2},
    {Name="Factory",Pos=CFrame.new(1500,8,-3000),Sea=2},
    {Name="Graveyard",Pos=CFrame.new(-5000,5,-3000),Sea=2},
    {Name="Usoapp Island",Pos=CFrame.new(4000,8,-1500),Sea=2},
    {Name="Forgotten Island",Pos=CFrame.new(3912,5,-1574),Sea=3},
    {Name="Hydra Island",Pos=CFrame.new(5700,5,500),Sea=3},
    {Name="Great Tree",Pos=CFrame.new(-4614,718,-1903),Sea=3},
    {Name="Candy Island",Pos=CFrame.new(1470,4,-16403),Sea=3},
    {Name="Chocolate Island",Pos=CFrame.new(-1930,5,-11579),Sea=3},
    {Name="Kitsune Island",Pos=CFrame.new(1500,5,-10000),Sea=3},
    {Name="Deep Sea",Pos=CFrame.new(-5000,10,-10000),Sea=3}
}
local FightingStylesShop = {
    "Black Leg","Fishman Karate","Electro","Dragon Breath",
    "SuperHuman","Death Step","Sharkman Karate",
    "Electric Claw","Dragon Talon","God Human","Sanguine Art"
}
local SwordShop = {
    "Cutlass","Katana","Iron Mace","Dual Katana","Triple Katana",
    "Pipe","Dual-Headed Blade","Bisento","Soul Cane","Pole v.2"
}
local GunShop = {
    "Slingshot","Musket","Flintlock","Refined Slingshot",
    "Refined Flintlock","Cannon","Kabucha","Bizarre Rifle"
}
local AbilitiesShop = {
    "Skyjump","Buso Haki","Observation Haki","Soru"
}
local function SuperAttack(model)
    if not model or not Alive() then return end
    local mh = model:FindFirstChildOfClass("Humanoid")
    if not mh or mh.Health <= 0 then return end
    for i = 1, 10 do
        if not model or not model.Parent then break end
        if not Alive() then break end
        if mh.Health <= 0 then break end
        pcall(function()
            local p = UIS:GetMouseLocation()
            VIM:SendMouseButtonEvent(p.X, p.Y, 0, true, game, 1)
            task.wait(0.01)
            VIM:SendMouseButtonEvent(p.X, p.Y, 0, false, game, 1)
        end)
        task.wait(0.02)
    end
end
local function SafeModePvPCheck()
    if not F.SafeModePvP then return false end
    if not Alive() then return false end
    local hp = HP()
    if hp >= 50 then return false end
    local h = HRP()
    if not h then return false end
    local nearestEnemy = nil
    local nearestDist = math.huge
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            local phrp = p.Character:FindFirstChild("HumanoidRootPart")
            local phum = p.Character:FindFirstChildOfClass("Humanoid")
            if phrp and phum and phum.Health > 0 then
                local d = (h.Position - phrp.Position).Magnitude
                if d < 150 and d < nearestDist then
                    nearestDist = d
                    nearestEnemy = p
                end
            end
        end
    end
    if nearestEnemy then
        Notify("SafeMode PvP", "Low HP with enemy nearby! Fleeing!", 3)
        local fleePos = h.Position + Vector3.new(math.random(-200, 200), 50, math.random(-200, 200))
        SmartPathfind(fleePos, 5)
        return true
    end
    return false
end
local function TPToLocation(name)
    for _, loc in ipairs(IslandLocations) do
        if loc.Name:lower():find(name:lower()) then
            Notify("Teleport", "Teleporting to "..loc.Name.."...", 3)
            TpTo(loc.Pos.Position, 500)
            return true
        end
    end
    Notify("Teleport", "Location not found: "..name, 3)
    return false
end
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            local anyActive = false
            for _, bd in ipairs(BossDropWeaponsSea1) do
                local flagName = "AutoBossDrop" .. bd.Name:gsub("%s+", ""):gsub("1st", "")
                if F[flagName] then anyActive = true; break end
            end
            if not anyActive then task.wait(5); return end
            if not Alive() then DeathWait(); return end
            for _, bd in ipairs(BossDropWeaponsSea1) do
                local flagName = "AutoBossDrop" .. bd.Name:gsub("%s+", ""):gsub("1st", "")
                if F[flagName] then
                    if HasWeapon(bd.Weapon) then
                        Notify("BossDrop", "Already have "..bd.Weapon.."!", 3)
                        F[flagName] = false
                    else
                        local mob = FindMob(bd.Boss, 1000)
                        if mob then
                            local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                            if mhrp then
                                SmartPathfind(mhrp.Position + Vector3.new(0, 5, 0))
                                task.wait(1)
                                UltraCombo(mob)
                                Notify("BossDrop", "Killing "..bd.Boss.." for "..bd.Weapon, 3)
                            end
                        else
                            TpTo(bd.Pos.Position, 400)
                            task.wait(3)
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
            local anyActive = false
            for _, bd in ipairs(BossDropWeaponsSea2) do
                local flagName = "AutoBossDrop" .. bd.Name:gsub("%s+", "")
                if F[flagName] then anyActive = true; break end
            end
            if not anyActive then task.wait(5); return end
            if not Alive() then DeathWait(); return end
            for _, bd in ipairs(BossDropWeaponsSea2) do
                local flagName = "AutoBossDrop" .. bd.Name:gsub("%s+", "")
                if F[flagName] then
                    if HasWeapon(bd.Weapon) then
                        Notify("BossDrop", "Already have "..bd.Weapon.."!", 3)
                        F[flagName] = false
                    else
                        local mob = FindMob(bd.Boss, 1000)
                        if mob then
                            local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                            if mhrp then
                                SmartPathfind(mhrp.Position + Vector3.new(0, 5, 0))
                                task.wait(1)
                                UltraCombo(mob)
                                Notify("BossDrop", "Killing "..bd.Boss.." for "..bd.Weapon, 3)
                            end
                        else
                            TpTo(bd.Pos.Position, 400)
                            task.wait(3)
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
            local anyActive = false
            for _, bd in ipairs(BossDropWeaponsSea3) do
                local flagName = "AutoBossDrop" .. bd.Name:gsub("%s+", "")
                if F[flagName] then anyActive = true; break end
            end
            if not anyActive then task.wait(5); return end
            if not Alive() then DeathWait(); return end
            for _, bd in ipairs(BossDropWeaponsSea3) do
                local flagName = "AutoBossDrop" .. bd.Name:gsub("%s+", "")
                if F[flagName] then
                    if HasWeapon(bd.Weapon) then
                        Notify("BossDrop", "Already have "..bd.Weapon.."!", 3)
                        F[flagName] = false
                    else
                        local mob = FindMob(bd.Boss, 1000)
                        if mob then
                            local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                            if mhrp then
                                SmartPathfind(mhrp.Position + Vector3.new(0, 5, 0))
                                task.wait(1)
                                UltraCombo(mob)
                                Notify("BossDrop", "Killing "..bd.Boss.." for "..bd.Weapon, 3)
                            end
                        else
                            TpTo(bd.Pos.Position, 400)
                            task.wait(3)
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
            if not F.AutoDarkDaggerQuest then return end
            if not Alive() then DeathWait(); return end
            if HasWeapon("Dark Dagger") then
                Notify("Dark Dagger", "Already have Dark Dagger!", 5)
                F.AutoDarkDaggerQuest = false
                return
            end
            local mob = FindMob("rip_indra", 1000) or FindMob("Rip_Indra", 1000)
            if mob then
                local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                if mhrp then
                    SmartPathfind(mhrp.Position + Vector3.new(0, 5, 0))
                    task.wait(1)
                    local atk = 0
                    local mh = mob:FindFirstChildOfClass("Humanoid")
                    while mh and mh.Health > 0 and Alive() and F.AutoDarkDaggerQuest and atk < 500 do
                        Attack(mob, {"Click","Click","Click","Click","Remote","Click","Click","Ability"}, 0.03)
                        atk = atk + 1; AtkCount = AtkCount + 1
                        task.wait(0.06)
                    end
                    Notify("Dark Dagger", "rip_indra defeated!", 5)
                end
            else
                TpTo(CFrame.new(-5400,8,9200).Position, 400)
                task.wait(5)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoHallowScytheQuest then return end
            if not Alive() then DeathWait(); return end
            if HasWeapon("Hallow Scythe") then
                Notify("Hallow Scythe", "Already have Hallow Scythe!", 5)
                F.AutoHallowScytheQuest = false
                return
            end
            local mob = FindMob("Soul Reaper", 1000) or FindMob("SoulReaper", 1000)
            if mob then
                local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                if mhrp then
                    SmartPathfind(mhrp.Position + Vector3.new(0, 5, 0))
                    task.wait(1)
                    local atk = 0
                    local mh = mob:FindFirstChildOfClass("Humanoid")
                    while mh and mh.Health > 0 and Alive() and F.AutoHallowScytheQuest and atk < 500 do
                        Attack(mob, {"Click","Click","Click","Click","Remote","Click","Click","Ability"}, 0.03)
                        atk = atk + 1; AtkCount = AtkCount + 1
                        task.wait(0.06)
                    end
                    Notify("Hallow Scythe", "Soul Reaper defeated!", 5)
                end
            else
                pcall(function()
                    CommF("SoulReaper")
                    CommF("SummonSoulReaper")
                    CommF("StartSoulReaper")
                end)
                task.wait(3)
            end
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Tool") and (obj.Name:find("Hallow") or obj.Name:find("Scythe")) then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        TpTo(handle.Position + Vector3.new(0, 2, 0), 500)
                        task.wait(0.3)
                        pcall(function()
                            local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                            if pp then fireproximityprompt(pp) end
                        end)
                        pcall(function() CommF("PickupItem", obj.Name) end)
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
            if not F.AutoSwanGlassesQuest then return end
            if not Alive() then DeathWait(); return end
            if HasWeapon("Swan Glasses") or HasWeapon("SwanGlasses") then
                Notify("Swan Glasses", "Already have Swan Glasses!", 5)
                F.AutoSwanGlassesQuest = false
                return
            end
            local mob = FindMob("Don Swan", 1000)
            if mob then
                local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                if mhrp then
                    SmartPathfind(mhrp.Position + Vector3.new(0, 5, 0))
                    task.wait(1)
                    local atk = 0
                    local mh = mob:FindFirstChildOfClass("Humanoid")
                    while mh and mh.Health > 0 and Alive() and F.AutoSwanGlassesQuest and atk < 500 do
                        Attack(mob, {"Click","Click","Click","Click","Remote","Click","Click","Ability"}, 0.03)
                        atk = atk + 1; AtkCount = AtkCount + 1
                        task.wait(0.06)
                    end
                    Notify("Swan Glasses", "Don Swan defeated!", 5)
                end
            else
                TpTo(CFrame.new(-2350,8,-3420).Position, 400)
                task.wait(5)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoGreybeardQuest then return end
            if not Alive() then DeathWait(); return end
            local mob = FindMob("Greybeard", 1000) or FindMob("Whitebeard", 1000)
            if mob then
                local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                if mhrp then
                    SmartPathfind(mhrp.Position + Vector3.new(0, 5, 0))
                    task.wait(1)
                    local atk = 0
                    local mh = mob:FindFirstChildOfClass("Humanoid")
                    while mh and mh.Health > 0 and Alive() and F.AutoGreybeardQuest and atk < 500 do
                        Attack(mob, {"Click","Click","Click","Click","Remote","Click","Click","Ability"}, 0.03)
                        atk = atk + 1; AtkCount = AtkCount + 1
                        task.wait(0.06)
                    end
                    Notify("Greybeard", "Greybeard defeated!", 5)
                end
            else
                TpTo(CFrame.new(-2500,10,2000).Position, 400)
                task.wait(5)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoCitizenQuest then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoCitizenQuest then break end
                if obj:IsA("Model") and (obj.Name:find("Citizen") or obj.Name:find("Tavern")) then
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
                CommF("CitizenQuest")
                CommF("AcceptCitizenQuest")
                CommF("StartQuest", "CitizenQuest")
            end)
            local citizenMobs = {"Swan Pirate","Royal Squad","Royal Soldier","Shanda"}
            for _, mobName in ipairs(citizenMobs) do
                if not F.AutoCitizenQuest then break end
                local mob = FindSmartMob(mobName, 500)
                if mob then
                    local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                    if mhrp then
                        SmartPathfind(mhrp.Position + Vector3.new(0, 3, 0))
                        task.wait(0.5)
                        local mh = mob:FindFirstChildOfClass("Humanoid")
                        local atk = 0
                        while mh and mh.Health > 0 and Alive() and F.AutoCitizenQuest and atk < 100 do
                            Attack(mob, {"Click","Click","Remote","Click","Click"}, 0.05)
                            atk = atk + 1; AtkCount = AtkCount + 1; task.wait(0.06)
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
            if not F.AutoRainbowHaki then return end
            if not Alive() then return end
            CommF("RainbowHaki")
            CommF("BuyRainbowHaki")
            CommF("PurchaseRainbowHaki")
            CommF("ActivateRainbowHaki")
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Alchemist") or obj.Name:find("Guru") or obj.Name:find("Rainbow")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                        task.wait(0.5)
                        pcall(function() fireproximityprompt(pp) end)
                    end
                end
            end
            local flowerNames = {"Red Flower", "Blue Flower", "Yellow Flower"}
            for _, fn in ipairs(flowerNames) do
                if not F.AutoRainbowHaki then break end
                for _, obj in ipairs(WS:GetDescendants()) do
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
        task.wait(3)
        pcall(function()
            if not F.AutoHolyTorch then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoHolyTorch then break end
                if obj:IsA("BasePart") and (obj.Name:find("Torch") or obj.Name:find("Holy")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp or obj.Position then
                        SmartPathfind(obj.Position + Vector3.new(0, 2, 0))
                        task.wait(0.5)
                        pcall(function()
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
                            CommF("PickupItem", "Holy Torch")
                            CommF("CollectItem", "Torch")
                        end)
                        task.wait(1)
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
            if not F.AutoEnhancementColor then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Enhancement") or obj.Name:find("Color") or obj.Name:find("Barista")) then
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
                CommF("EnhancementColor")
                CommF("BuyEnhancement")
                CommF("BuyColor")
                CommF("PurchaseColor")
            end)
        end)
    end
end)
local DungeonState = {InProgress=false, Room=0}
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.AutoDungeonFull then return end
            if not Alive() then DeathWait(); return end
            pcall(function()
                CommF("SelectDungeon")
                CommF("JoinDungeon")
                CommF("StartDungeon")
                CommF("DungeonStart")
            end)
            task.wait(2)
            local mobs = FindAllMobs(300)
            if #mobs > 0 then
                DungeonState.InProgress = true
                for _, mob in ipairs(mobs) do
                    if not F.AutoDungeonFull then break end
                    if mob.Hum.Health > 0 then
                        SmartPathfind(mob.HRP.Position + Vector3.new(0, 3, 0))
                        task.wait(0.3)
                        UltraCombo(mob.Model)
                    end
                end
            else
                for _, obj in ipairs(WS:GetDescendants()) do
                    if not F.AutoDungeonFull then break end
                    if obj:IsA("BasePart") and (obj.Name:find("Door") or obj.Name:find("Gate") or obj.Name:find("Room")) then
                        SmartPathfind(obj.Position + Vector3.new(0, 3, 0))
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
                        task.wait(1)
                    end
                end
            end
            pcall(function()
                CommF("SelectReward")
                CommF("ChooseCard")
                CommF("DungeonReward")
                CommF("SelectDungeonReward")
            end)
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoRaceDoor then return end
            if not Alive() then return end
            local playerRace = GetRace()
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoRaceDoor then break end
                if obj:IsA("BasePart") and (obj.Name:find("Door") or obj.Name:find("Gate")) then
                    if obj.Name:lower():find(playerRace:lower()) or obj.Name:find("Ancient") or obj.Name:find("Race") then
                        SmartPathfind(obj.Position + Vector3.new(0, 3, 0))
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
                        task.wait(1)
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
            if not F.AutoAutoTrial then return end
            if not Alive() then return end
            pcall(function()
                CommF("Trial")
                CommF("StartTrial")
                CommF("TrialStart")
                CommF("BeginTrial")
            end)
            task.wait(2)
            for _, p in ipairs(P:GetPlayers()) do
                if p ~= LP and p.Character then
                    local phrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local phum = p.Character:FindFirstChildOfClass("Humanoid")
                    if phrp and phum and phum.Health > 0 then
                        local h = HRP()
                        if h then
                            local d = (h.Position - phrp.Position).Magnitude
                            if d < 200 then
                                local atk = 0
                                while phum.Health > 0 and Alive() and F.AutoAutoTrial and atk < 300 do
                                    Attack(p.Character, {"Click","Click","Click","Click","Remote","Click","Click","Ability"}, 0.03)
                                    atk = atk + 1; AtkCount = AtkCount + 1
                                    task.wait(0.06)
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
        task.wait(5)
        pcall(function()
            if not F.AutoTrainRace then return end
            if not Alive() then return end
            CommF("TrainRace")
            CommF("StartTrain")
            CommF("RaceTrain")
            CommF("BeginRace")
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoBuyGear then return end
            if not Alive() then return end
            CommF("BuyGear")
            CommF("PurchaseGear")
            CommF("BuyRaceGear")
            CommF("PurchaseRaceGear")
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Gear") or obj.Name:find("Ancient") or obj.Name:find("Race")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                        task.wait(0.5)
                        pcall(function() fireproximityprompt(pp) end)
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
            if not F.AutoTPMirage then return end
            if not Alive() then return end
            local m = WS:FindFirstChild("MirageIsland") or WS:FindFirstChild("Mirage Island")
            if m then
                local p = m:FindFirstChildWhichIsA("BasePart")
                if p then
                    SmartPathfind(p.Position + Vector3.new(0, 60, 0))
                    Notify("Mirage", "Found Mirage Island! Teleporting...", 3)
                end
            else
                for _, pos in ipairs({CFrame.new(4418,10,7445), CFrame.new(-1800,10,-1400), CFrame.new(-2200,10,-2800)}) do
                    if not F.AutoTPMirage then break end
                    TpTo(pos.Position, 400); task.wait(5)
                    if WS:FindFirstChild("MirageIsland") then break end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoTPBlueGear then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoTPBlueGear then break end
                if obj:IsA("BasePart") and (obj.Name:find("Blue Gear") or obj.Name:find("Gear")) then
                    SmartPathfind(obj.Position + Vector3.new(0, 2, 0))
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
                    pcall(function() CommF("PickupItem", "Blue Gear") end)
                    Notify("Blue Gear", "Collected Blue Gear!", 3)
                    task.wait(1)
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoTPKitsune then return end
            if not Alive() then return end
            local kit = WS:FindFirstChild("KitsuneIsland") or WS:FindFirstChild("Kitsune Island")
            if kit then
                local p = kit:FindFirstChildWhichIsA("BasePart")
                if p then
                    SmartPathfind(p.Position + Vector3.new(0, 30, 0))
                    Notify("Kitsune", "Found Kitsune Island!", 3)
                end
            else
                TpTo(CFrame.new(1500,5,-10000).Position, 400)
                task.wait(10)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoAzureEmber then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoAzureEmber then break end
                if obj:IsA("BasePart") and (obj.Name:find("Ember") or obj.Name:find("Azure")) then
                    SmartPathfind(obj.Position + Vector3.new(0, 2, 0))
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
                    pcall(function() CommF("PickupItem", "Azure Ember") end)
                    task.wait(1)
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.AutoKillTerrorshark then return end
            if not Alive() then DeathWait(); return end
            local mob = FindMob("Terror Shark", 1000) or FindMob("TerrorShark", 1000)
            if mob then
                local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                if mhrp then
                    SmartPathfind(mhrp.Position + Vector3.new(0, 10, 0))
                    task.wait(1)
                    UltraCombo(mob)
                end
            else
                TpTo(CFrame.new(-5000,10,-10000).Position, 400)
                task.wait(10)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.AutoKillPiranha then return end
            if not Alive() then DeathWait(); return end
            local mob = FindMob("Piranha", 1000) or FindMob("Piranha Boat", 1000)
            if mob then
                local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                if mhrp then
                    SmartPathfind(mhrp.Position + Vector3.new(0, 10, 0))
                    task.wait(1)
                    UltraCombo(mob)
                end
            else
                TpTo(CFrame.new(-5000,10,-10000).Position, 400)
                task.wait(10)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            if not F.AutoKillFishCrew then return end
            if not Alive() then DeathWait(); return end
            local fishMobs = {"Fish Crew Captain","Fish Crew Member","Fish Crew"}
            for _, mobName in ipairs(fishMobs) do
                local mob = FindMob(mobName, 1000)
                if mob then
                    local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                    if mhrp then
                        SmartPathfind(mhrp.Position + Vector3.new(0, 5, 0))
                        task.wait(1)
                        UltraCombo(mob)
                        return
                    end
                end
            end
            TpTo(CFrame.new(-5000,10,-10000).Position, 400)
            task.wait(10)
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(10)
        pcall(function()
            if not F.AutoBuyFightingStyles then return end
            if not Alive() then return end
            for _, name in ipairs(FightingStylesShop) do
                if not F.AutoBuyFightingStyles then break end
                pcall(function()
                    CommF("BuyFightingStyle", name)
                    CommF("UnlockFightingStyle", name)
                    CommF("LearnFightingStyle", name)
                    CommF("BuyItem", name)
                end)
                task.wait(1)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(10)
        pcall(function()
            if not F.AutoBuySwords then return end
            if not Alive() then return end
            for _, name in ipairs(SwordShop) do
                if not F.AutoBuySwords then break end
                pcall(function()
                    CommF("BuySword", name)
                    CommF("BuyItem", name)
                    CommF("PurchaseItem", name)
                    CommF("ShopBuy", name)
                end)
                task.wait(1)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(10)
        pcall(function()
            if not F.AutoBuyGuns then return end
            if not Alive() then return end
            for _, name in ipairs(GunShop) do
                if not F.AutoBuyGuns then break end
                pcall(function()
                    CommF("BuyGun", name)
                    CommF("BuyItem", name)
                    CommF("PurchaseItem", name)
                    CommF("ShopBuy", name)
                end)
                task.wait(1)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(10)
        pcall(function()
            if not F.AutoBuyAbilities then return end
            if not Alive() then return end
            for _, name in ipairs(AbilitiesShop) do
                if not F.AutoBuyAbilities then break end
                pcall(function()
                    CommF("BuyAbility", name)
                    CommF("BuyItem", name)
                    CommF("UnlockAbility", name)
                    CommF("LearnAbility", name)
                end)
                task.wait(1)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(15)
        pcall(function()
            if not F.AutoRefundStat and not F.AutoRerollRace and not F.AutoBuyGhoul and not F.AutoBuyCyborg and not F.AutoBuyDraco then return end
            if not Alive() then return end
            if F.AutoRefundStat then
                CommF("RefundStat")
                CommF("StatRefund")
                CommF("BuyRefund")
                F.AutoRefundStat = false
                Notify("Shop", "Refund stat requested!", 3)
            end
            if F.AutoRerollRace then
                CommF("RerollRace")
                CommF("BuyRerollRace")
                CommF("RaceReroll")
                F.AutoRerollRace = false
                Notify("Shop", "Reroll race requested!", 3)
            end
            if F.AutoBuyGhoul then
                for _, obj in ipairs(WS:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:find("Mysterious") or obj.Name:find("Quest")) then
                        local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                        if pp then
                            local h = HRP()
                            if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                            task.wait(0.5)
                            pcall(function() fireproximityprompt(pp) end)
                        end
                    end
                end
                CommF("BuyGhoul")
                CommF("GhoulRace")
                CommF("UnlockRace", "Ghoul")
                CommF("BuyRace", "Ghoul")
                Notify("Shop", "Ghoul race purchase requested!", 3)
            end
            if F.AutoBuyCyborg then
                CommF("BuyCyborg")
                CommF("CyborgRace")
                CommF("UnlockRace", "Cyborg")
                CommF("BuyRace", "Cyborg")
                Notify("Shop", "Cyborg race purchase requested!", 3)
            end
            if F.AutoBuyDraco then
                CommF("BuyDraco")
                CommF("DracoRace")
                CommF("UnlockRace", "Draco")
                CommF("BuyRace", "Draco")
                Notify("Shop", "Draco race purchase requested!", 3)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            if not F.NoStunEnabled then return end
            local char = LP.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
                local stun = char:FindFirstChild("Stun") or char:FindFirstChild("Stunned")
                if stun and stun:IsA("NumberValue") then
                    stun.Value = 0
                end
                local csrf = char:FindFirstChild(" CSRF") or char:FindFirstChild("CSRF")
                if csrf and csrf:IsA("NumberValue") then
                    csrf.Value = 0
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoActiveV3 then return end
            if not Alive() then return end
            CommF("ActivateV3")
            CommF("V3Ability")
            CommF("ActivateRaceV3")
            CommF("RaceV3")
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Trial") or obj.Name:find("Ancient") or obj.Name:find("Clock")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                        task.wait(0.5)
                        pcall(function() fireproximityprompt(pp) end)
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
            if not F.AutoActiveV4Full then return end
            if not Alive() then return end
            CommF("ActivateV4")
            CommF("V4Ability")
            CommF("AwakenV4")
            CommF("ActivateRaceV4")
            CommF("RaceV4")
            CommF("AwakenRace")
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Trial") or obj.Name:find("Ancient") or obj.Name:find("Awakening")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                        task.wait(0.5)
                        pcall(function() fireproximityprompt(pp) end)
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
            if not F.SafeModePvP then return end
            if not Alive() then return end
            SafeModePvPCheck()
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(0.15)
        pcall(function()
            if not F.SuperAttack then return end
            if not Alive() then return end
            local mob = FindMob("", C.KillAuraRange)
            if mob then
                local mh = mob:FindFirstChildOfClass("Humanoid")
                if mh and mh.Health > 0 then
                    local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                    if mhrp then
                        local h = HRP()
                        if h then
                            local dist = (h.Position - mhrp.Position).Magnitude
                            if dist > 12 then
                                TpTo(mhrp.Position + Vector3.new(0, 3, 0), 400)
                            else
                                h.CFrame = mhrp.CFrame * CFrame.new(0, 0, 3.5)
                                SuperAttack(mob)
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
            if not F.AutoDojo then return end
            if not Alive() then return end
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoDojo then break end
                if obj:IsA("Model") and (obj.Name:find("Dojo") or obj.Name:find("Trainer")) then
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
                CommF("DojoTraining")
                CommF("StartDojo")
                CommF("DojoQuest")
                CommF("AcceptDojo")
            end)
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoActiveV4Full then return end
            if not Alive() then return end
            CommF("ActivateV4")
            CommF("V4Ability")
            CommF("AwakenV4")
            CommF("ActivateRaceV4")
            CommF("RaceV4")
            CommF("AwakenRace")
            CommF("StartAwakening")
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoActiveV4Full then break end
                if obj:IsA("Model") and (obj.Name:find("Ancient One") or obj.Name:find("Trial") or obj.Name:find("Clock")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                        task.wait(0.5)
                        pcall(function() fireproximityprompt(pp) end)
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
            if not F.AutoActiveV3 then return end
            if not Alive() then return end
            CommF("ActivateV3")
            CommF("V3Ability")
            CommF("ActivateRaceV3")
            CommF("RaceV3")
            for _, obj in ipairs(WS:GetDescendants()) do
                if not F.AutoActiveV3 then break end
                if obj:IsA("Model") and (obj.Name:find("Trial") or obj.Name:find("Ancient") or obj.Name:find("Upgrade")) then
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        local h = HRP()
                        if h then h.CFrame = obj:GetPivot() * CFrame.new(0, 0, -3) end
                        task.wait(0.5)
                        pcall(function() fireproximityprompt(pp) end)
                    end
                end
            end
        end)
    end
end)
local function FindMob(name, maxD)
    maxD = maxD or 500
    local h = HRP()
    if not h then return nil, math.huge end
    local best, bestD = nil, maxD
    for _, fname in ipairs({"Enemies","NPCs","Living"}) do
        local f = WS:FindFirstChild(fname)
        if f then
            for _, obj in ipairs(f:GetDescendants()) do
                if obj:IsA("Model") and (name == "" or obj.Name:find(name)) then
                    local mh = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                    local mm = obj:FindFirstChildOfClass("Humanoid")
                    if mh and mm and mm.Health > 0 then
                        local d = (h.Position - mh.Position).Magnitude
                        if d < bestD then best = obj; bestD = d end
                    end
                end
            end
        end
    end
    return best, bestD
end
local function FindSmartMob(questName, maxD)
    maxD = maxD or 500
    local h = HRP()
    if not h then return nil, math.huge end
    local best, bestScore = nil, -math.huge
    for _, fname in ipairs({"Enemies","NPCs","Living"}) do
        local f = WS:FindFirstChild(fname)
        if f then
            for _, obj in ipairs(f:GetDescendants()) do
                if obj:IsA("Model") then
                    local mh = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                    local mm = obj:FindFirstChildOfClass("Humanoid")
                    if mh and mm and mm.Health > 0 then
                        local d = (h.Position - mh.Position).Magnitude
                        if d <= maxD then
                            local score = 0
                            if questName and obj.Name:find(questName) then score = score + 100 end
                            score = score + (1 - mm.Health / mm.MaxHealth) * 50
                            score = score + (maxD - d) / maxD * 30
                            if score > bestScore then
                                bestScore = score
                                best = obj
                            end
                        end
                    end
                end
            end
        end
    end
    return best, best and bestScore or math.huge
end
local function FindAllMobs(maxD)
    maxD = maxD or C.BringMobRange
    local h = HRP()
    if not h then return {} end
    local list = {}
    for _, fname in ipairs({"Enemies","NPCs","Living"}) do
        local f = WS:FindFirstChild(fname)
        if f then
            for _, obj in ipairs(f:GetDescendants()) do
                if obj:IsA("Model") then
                    local mh = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                    local mm = obj:FindFirstChildOfClass("Humanoid")
                    if mh and mm and mm.Health > 0 and mm.MaxHealth > 0 then
                        local d = (h.Position - mh.Position).Magnitude
                        if d <= maxD then
                            table.insert(list, {Model=obj, Dist=d, HRP=mh, Hum=mm})
                        end
                    end
                end
            end
        end
    end
    table.sort(list, function(a,b) return a.Dist < b.Dist end)
    return list
end
local function GetOptimalStats(level)
    if level < 300 then return {"Melee", "Defense"} end
    if level < 700 then return {"Melee", "Defense", "Sword"} end
    if level < 1500 then return {"Melee", "Defense", "Sword"} end
    return {"Melee", "Defense", "Blox Fruit"}
end
local function PredictPosition(targetHRP, myHRP)
    if not targetHRP or not myHRP then
        return targetHRP and targetHRP.Position or Vector3.new(0, 0, 0)
    end
    local vel = targetHRP.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local dist = (targetHRP.Position - myHRP.Position).Magnitude
    local travelTime = dist / 350
    return targetHRP.Position + vel * travelTime * 0.5
end
local AtkCount = 0
local function Attack(model, methods, delay)
    if not model or not Alive() then return end
    local h = HRP()
    local mh = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
    local mm = model:FindFirstChildOfClass("Humanoid")
    if not h or not mh or not mm or mm.Health <= 0 then return end
    local behind = mh.CFrame * CFrame.new(0, 0, 3.5)
    local lookAt = CFrame.new(behind.Position, Vector3.new(mh.Position.X, behind.Position.Y, mh.Position.Z))
    h.CFrame = lookAt
    for _, m in ipairs(methods or {"Click","Remote","Click"}) do
        if not Alive() or mm.Health <= 0 then return end
        if m == "Click" then
            pcall(function()
                local p = UIS:GetMouseLocation()
                VIM:SendMouseButtonEvent(p.X, p.Y, 0, true, game, 1)
                task.wait(0.03)
                VIM:SendMouseButtonEvent(p.X, p.Y, 0, false, game, 1)
            end)
        elseif m == "Remote" then
            pcall(function() CommF("HitMob", model.Name, model) end)
        elseif m == "Ability" then
            pcall(function() CommF("Ability", 1) end)
            pcall(function() CommF("UseAbility", 1) end)
        end
        task.wait(delay or 0.05)
    end
end
local function KillAura(range, delay)
    if not Alive() then return end
    range = range or C.KillAuraRange
    delay = delay or 0.08
    local mobs = FindAllMobs(range)
    for _, mob in ipairs(mobs) do
        if not Alive() then break end
        if mob.Hum.Health > 0 then
            Attack(mob.Model, {"Click","Remote","Click"}, delay)
        end
    end
end
local function UltraCombo(model)
    if not model or not Alive() then return end
    local mh = model:FindFirstChildOfClass("Humanoid")
    local mhrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
    if not mh or not mhrp or mh.Health <= 0 then return end
    pcall(function()
        CommF("BusoHaki")
        CommF("ActivateHaki", "Buso")
        CommF("ToggleHaki", "Buso")
    end)
    EquipType("Sword"); task.wait(0.08)
    Attack(model, {"Click","Click","Remote"}, 0.04); AtkCount = AtkCount + 1
    if mh.Health <= 0 then return end
    EquipType("Fruit"); task.wait(0.08)
    Attack(model, {"Click","Ability","Ability"}, 0.06); AtkCount = AtkCount + 1
    if mh.Health <= 0 then return end
    EquipType("Gun"); task.wait(0.08)
    Attack(model, {"Click","Remote"}, 0.06); AtkCount = AtkCount + 1
    if mh.Health <= 0 then return end
    EquipType("Fighting"); task.wait(0.08)
    Attack(model, {"Click","Click","Ability"}, 0.05); AtkCount = AtkCount + 1
    if mh.Health <= 0 then return end
    EquipBest(); task.wait(0.08)
    Attack(model, {"Click","Click","Click","Click","Remote"}, 0.03); AtkCount = AtkCount + 1
end
local function BringMobs(range)
    if not Alive() then return end
    local h = HRP()
    if not h then return end
    range = range or C.BringMobRange
    local mobs = FindAllMobs(range)
    local groupPos = h.Position + Vector3.new(0, 0, -5)
    for _, mob in ipairs(mobs) do
        if mob.HRP and mob.Hum.Health > 0 then
            local offset = Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
            mob.HRP.CFrame = CFrame.new(groupPos + offset)
        end
    end
end
local function EquipBest()
    local bp = LP:FindFirstChild("Backpack")
    if not bp then return end
    local best, bestL = nil, 0
    local function check(t)
        if not t:IsA("Tool") then return end
        local l = t:FindFirstChild("Level") or t:FindFirstChild("Mastery")
        local v = l and l:IsA("NumberValue") and l.Value or 0
        if v > bestL then bestL = v; best = t end
    end
    for _, t in ipairs(bp:GetChildren()) do check(t) end
    local c = LP.Character
    if c then for _, t in ipairs(c:GetChildren()) do check(t) end end
    if best then local h = Hum(); if h then h:EquipTool(best) end end
end
local function EquipType(wtype)
    local bp = LP:FindFirstChild("Backpack")
    if not bp then return end
    local best, bestL = nil, 0
    local function check(t)
        if not t:IsA("Tool") then return end
        local ok = false
        if wtype == "Sword" then
            ok = t:FindFirstChild("Sword") or t.Name:find("Katana") or t.Name:find("Sword") or t.Name:find("Blade") or t.Name:find("Cleaver") or t.Name:find("Twin") or t.Name:find("Shark") or t.Name:find("Canvander") or t.Name:find("Dark Blade") or t.Name:find("CDK") or t.Name:find("Legend") or t.Name:find("Tusk")
        elseif wtype == "Gun" then
            ok = t:FindFirstChild("Gun") or t.Name:find("Gun") or t.Name:find("Pistol") or t.Name:find("Musket") or t.Name:find("Cannon") or t.Name:find("Slingshot") or t.Name:find("Soul Guitar")
        elseif wtype == "Fruit" then
            ok = t:FindFirstChild("Fruit") or t.Name:find("Fruit")
        elseif wtype == "Fighting" then
            ok = t:FindFirstChild("FightingStyle") or t.Name:find("GodHuman") or t.Name:find("Electric") or t.Name:find("Dark Step") or t.Name:find("Water Kung Fu") or t.Name:find("Sharkman") or t.Name:find("Dragon Talon")
        end
        if ok then
            local l = t:FindFirstChild("Mastery") or t:FindFirstChild("Level")
            local v = l and l:IsA("NumberValue") and l.Value or 0
            if v > bestL or not best then bestL = v; best = t end
        end
    end
    for _, t in ipairs(bp:GetChildren()) do check(t) end
    local c = LP.Character
    if c then for _, t in ipairs(c:GetChildren()) do check(t) end end
    if best then local h = Hum(); if h then h:EquipTool(best) end end
end
local function HasWeapon(name)
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and t.Name:find(name) then return true end
        end
    end
    local c = LP.Character
    if c then
        for _, t in ipairs(c:GetChildren()) do
            if t:IsA("Tool") and t.Name:find(name) then return true end
        end
    end
    return false
end
local function SafeCheck()
    if not F.LowHP then return false end
    if HP() > C.SafeHP then return false end
    InstantTP(Vector3.new(0, 100, 0))
    task.wait(2)
    while HP() < 60 and F.LowHP and F.AutoFarm do task.wait(1) end
    return true
end
local function DeathWait()
    if Alive() then return end
    ClearCharCache()
    local c = LP.CharacterAdded:Wait()
    task.wait(1)
    local h = c:WaitForChild("Humanoid", 5)
    if h then h.WalkSpeed = C.WalkSpeed; h.JumpPower = C.JumpPower end
    task.wait(0.5)
    ClearCharCache()
    EquipBest()
end
local QuestCooldown = 0
local function AcceptQuest(q)
    if not q then return end
    if (os.time() - QuestCooldown) < 4 then return end
    TpTo(q.Pos.Position + Vector3.new(0, 5, 0), 400)
    task.wait(0.5)
    pcall(function() CommF("StartQuest", q.Q, 1) end)
    pcall(function() CommF("StartQuest", q.Q) end)
    pcall(function() CommF("AcceptQuest", q.Q) end)
    pcall(function() CommF("QuestAccept", q.Q) end)
    pcall(function() CommF("AcceptQuest", q.Q, 1) end)
    QuestCooldown = os.time()
    task.wait(0.3)
end
local function GetQuest(lv)
    for _, q in ipairs(Quests) do
        if lv >= q.Min and lv <= q.Max then return q end
    end
    return Quests[#Quests]
end
local QuestSwitchCooldown = 0
local function SmartQuestSwitch()
    if not F.AutoFarm then return end
    if (os.time() - QuestSwitchCooldown) < 30 then return end
    local level = Lv()
    local q = GetQuest(level)
    if q then
        local mob, dist = FindSmartMob(q.M, 300)
        if not mob or dist > 400 then
            QuestSwitchCooldown = os.time()
            pcall(function() CommF("AbandonQuest") end)
            task.wait(1)
            AcceptQuest(q)
        end
    end
end
task.spawn(function()
    while true do
        task.wait()
        pcall(function()
            if not F.AutoFarm then return end
            if SafeCheck() then return end
            if not Alive() then DeathWait(); return end
            if F.FarmAll then
                SmartQuestSwitch()
            end
            local q = GetQuest(Lv())
            if not q then return end
            if F.AutoQuest then AcceptQuest(q) end
            local mob, dist = FindSmartMob(q.M, 500)
            if mob then
                local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                if mhrp then
                    if dist > 12 then
                        if F.SmartPathfind and dist > 30 then
                            SmartPathfind(mhrp.Position + Vector3.new(0, 3, 0))
                        else
                            TpTo(mhrp.Position + HumanizedOffset(), 400)
                        end
                    else
                        if F.BringMob then BringMobs(C.BringMobRange) end
                        if F.PredictionCombat then
                            local myHRP = HRP()
                            if myHRP then
                                local predicted = PredictPosition(mhrp, myHRP)
                                myHRP.CFrame = CFrame.new(predicted + Vector3.new(0, 0, 3.5), Vector3.new(predicted.X, myHRP.Position.Y, predicted.Z))
                            end
                        end
                        Attack(mob, F.FastAttack
                            and {"Click","Click","Click","Click","Remote","Click"}
                            or {"Click","Remote"},
                            F.FastAttack and 0.04 or 0.12
                        )
                        AtkCount = AtkCount + 1
                        if F.KillAura then KillAura(C.KillAuraRange, 0.08) end
                    end
                end
            else
                TpTo(q.Pos.Position, 400)
                task.wait(RandDelay(1, 3))
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait()
        pcall(function()
            if not F.AutoBossFarm then return end
            if SafeCheck() then return end
            if not Alive() then DeathWait(); return end
            for _, bd in ipairs(Bosses) do
                if not F.AutoBossFarm then break end
                for _, folder in ipairs({"Enemies","NPCs","Living"}) do
                    local f = WS:FindFirstChild(folder)
                    if f then
                        for _, obj in ipairs(f:GetDescendants()) do
                            if obj:IsA("Model") and obj.Name == bd.Name then
                                local mh = obj:FindFirstChildOfClass("Humanoid")
                                if mh and mh.Health > 0 then
                                    TpTo(bd.Pos.Position, 400)
                                    task.wait(1)
                                    local atk = 0
                                    while mh.Health > 0 and Alive() and F.AutoBossFarm and atk < 300 do
                                        Attack(obj, {"Click","Click","Click","Click","Remote","Click"}, 0.04)
                                        atk = atk + 1; AtkCount = AtkCount + 1
                                        task.wait(0.08)
                                    end
                                    return
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
        task.wait()
        pcall(function()
            if not (F.AutoMasteryFruit or F.AutoMasterySword) then return end
            if SafeCheck() then return end
            if not Alive() then DeathWait(); return end
            if F.AutoMasteryFruit then EquipType("Fruit")
            elseif F.AutoMasterySword then EquipType("Sword") end
            task.wait(0.3)
            local mob, dist = FindSmartMob("", 500)
            if mob then
                local mhrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                if mhrp then
                    if dist > 12 then TpTo(mhrp.Position + Vector3.new(0,3,0), 400)
                    else
                        if F.BringMob then BringMobs(C.BringMobRange) end
                        Attack(mob, {"Click","Click","Click","Click","Remote"}, 0.05)
                        AtkCount = AtkCount + 1
                        if F.KillAura then KillAura(C.KillAuraRange, 0.08) end
                    end
                end
            else
                local q = GetQuest(Lv())
                TpTo(q.Pos.Position, 400)
                task.wait(2)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(0.15)
        pcall(function()
            if not F.KillAura then return end
            if not Alive() then return end
            KillAura(C.KillAuraRange, 0.06)
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if not F.AutoStats then return end
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.SmartStatDist then return end
            local statPoints = 0
            local d = LP:FindFirstChild("Data")
            if d and d:FindFirstChild("StatPoints") then
                statPoints = d.StatPoints.Value
            end
            if statPoints <= 0 then return end
            local level = Lv()
            local optimal = GetOptimalStats(level)
            local primary = optimal[1] or "Melee"
            local secondary = optimal[2] or "Defense"
            local tertiary = optimal[3] or "Sword"
            local split = C.SmartStatSplit or 50
            local primaryAmt = math.floor(statPoints * (split / 100))
            for i = 1, math.min(primaryAmt, 5) do
                CommF("AddStat", primary)
                task.wait(0.3)
            end
            local remaining = statPoints - primaryAmt
            local secondaryAmt = math.floor(remaining * 0.6)
            for i = 1, math.min(secondaryAmt, 5) do
                CommF("AddStat", secondary)
                task.wait(0.3)
            end
            local tertiaryAmt = remaining - secondaryAmt
            for i = 1, math.min(tertiaryAmt, 5) do
                CommF("AddStat", tertiary)
                task.wait(0.3)
            end
        end)
    end
end)
local RaidState = {InRaid=false, Room=0, Timer=0, ChipBought=false}
local function FindRaidChip(name)
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and t.Name:find(name.." Chip") then return true end
        end
    end
    local c = LP.Character
    if c then
        for _, t in ipairs(c:GetChildren()) do
            if t:IsA("Tool") and t.Name:find(name.." Chip") then return true end
        end
    end
    return false
end
local function BuyRaidChip(name)
    if FindRaidChip(name) then return true end
    pcall(function()
        CommF("BuyChip", name)
        CommF("RaidsBuyChip", name)
        CommF("RaidBuyChip", name)
        CommF("BuyRaidChip", name)
    end)
    task.wait(2)
    return FindRaidChip(name)
end
local function FindRaidConsole()
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj.Name:find("Raid") and obj:IsA("BasePart") then return obj end
        if obj.Name:find("Console") and obj:IsA("BasePart") then return obj end
        if obj.Name:find("Teleport") and obj:IsA("BasePart") and obj.Position.Y > 200 then return obj end
    end
    return nil
end
local function FindRaidRoom()
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:find("Island") or obj.Name:find("Room")) then
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part and part.Position.Y > 200 then return obj end
        end
    end
    return nil
end
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if not F.AutoRaid then return end
            if not Alive() then DeathWait(); return end
            local h = HRP()
            if not h then return end
            if not RaidState.ChipBought then
                if not FindRaidChip(C.RaidChip) then
                    Notify("Raid", "Buying "..C.RaidChip.." chip...", 3)
                    BuyRaidChip(C.RaidChip)
                    task.wait(3)
                    if not FindRaidChip(C.RaidChip) then
                        Notify("Raid", "Could not buy chip!", 5)
                        task.wait(10)
                        return
                    end
                end
                RaidState.ChipBought = true
            end
            if F.RaidAutoStart then
                local console = FindRaidConsole()
                if console then
                    TpTo(console.Position + Vector3.new(0, 5, 0), 400)
                    task.wait(1)
                    pcall(function()
                        local pp = console:FindFirstChildOfClass("ProximityPrompt")
                        if pp then fireproximityprompt(pp) end
                    end)
                    pcall(function()
                        CommF("ActivateRaid")
                        CommF("StartRaid")
                        CommF("RaidStart")
                        CommF("RaidsStart")
                    end)
                    task.wait(2)
                end
            end
            local mobs = FindAllMobs(200)
            if #mobs > 0 then
                RaidState.InRaid = true
                for _, mob in ipairs(mobs) do
                    if not F.AutoRaid then break end
                    if mob.Hum.Health > 0 then
                        Attack(mob.Model, {"Click","Click","Click","Click","Remote","Click","Ability"}, 0.04)
                        AtkCount = AtkCount + 1
                    end
                end
                if F.RaidAutoRotate then
                    local room = FindRaidRoom()
                    if room then
                        local rp = room:FindFirstChildWhichIsA("BasePart")
                        if rp then TpTo(rp.Position + Vector3.new(0, 20, 0), 400); task.wait(3) end
                    end
                end
            else
                if F.RaidAutoRotate then
                    for _, obj in ipairs(WS:GetDescendants()) do
                        if obj:IsA("Model") and obj.Name:find("Island") then
                            local p = obj:FindFirstChildWhichIsA("BasePart")
                            if p and (h.Position - p.Position).Magnitude > 100 then
                                TpTo(p.Position + Vector3.new(0, 30, 0), 400)
                                task.wait(5)
                                break
                            end
                        end
                    end
                end
            end
            for _, bd in ipairs(Bosses) do
                if not F.AutoRaid then break end
                for _, folder in ipairs({"Enemies","NPCs","Living"}) do
                    local f = WS:FindFirstChild(folder)
                    if f then
                        for _, obj in ipairs(f:GetDescendants()) do
                            if obj:IsA("Model") and (obj.Name:find("Boss") or obj.Name:find(bd.Name)) then
                                local mh = obj:FindFirstChildOfClass("Humanoid")
                                if mh and mh.Health > 0 then
                                    local atk = 0
                                    while mh.Health > 0 and Alive() and F.AutoRaid and atk < 500 do
                                        Attack(obj, {"Click","Click","Click","Click","Remote","Click","Click","Ability"}, 0.03)
                                        atk = atk + 1; AtkCount = AtkCount + 1
                                        task.wait(0.06)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)
local CDKState = {Wisps=0, Elites=0, ScrollA=false, ScrollB=false, SoulReaper=false}
local function GetCDKProgress()
    pcall(function()
        local data = LP:FindFirstChild("Data")
        if data then
            local wisps = data:FindFirstChild("DemonicWisps") or data:FindFirstChild("Wisps")
            if wisps and wisps:IsA("IntValue") then CDKState.Wisps = wisps.Value end
        end
        local quests = LP:FindFirstChild("Quests")
        if quests then
            local elite = quests:FindFirstChild("EliteQuest") or quests:FindFirstChild("Elite")
            if elite then
                local c = elite:FindFirstChild("Count") or elite:FindFirstChild("Value")
                if c and c:IsA("IntValue") then CDKState.Elites = c.Value end
            end
        end
    end)
end

_G.Apex = {
    C = C, F = F,
    P = P, RS = RS, WS = WS, UIS = UIS, TS = TS, HS = HS,
    RS2 = RS2, VU = VU, VIM = VIM, TPS = TPS, SG = SG,
    Debris = Debris, PathService = PathService, Stats = Stats, Light = Light,
    LP = LP, Mouse = Mouse, Cam = Cam, EXEC = EXEC,
    EXP = EXP,
    HTTP = HTTP, Clip = Clip, Notify = Notify,
    Alive = Alive, HRP = HRP, Hum = Hum, HP = HP,
    Lv = Lv, Beli = Beli, Frags = Frags, Sea = Sea,
    Bounty = Bounty, Island = Island, GetRace = GetRace,
    EnsureFolder = EnsureFolder, SaveConfig = SaveConfig,
    LoadConfig = LoadConfig, DeleteConfig = DeleteConfig,
    HumanizedOffset = HumanizedOffset,
    TpTo = TpTo, InstantTP = InstantTP, CancelMove = CancelMove,
    SmartPathfind = SmartPathfind, CommF = CommF, CommE = CommE,
    FireR = FireR, RandDelay = RandDelay,
    ApplyJitter = ApplyJitter, GetJitteredPosition = GetJitteredPosition,
    SuperAttack = SuperAttack, SafeModePvPCheck = SafeModePvPCheck,
    TPToLocation = TPToLocation,
    FindMob = FindMob, FindSmartMob = FindSmartMob, FindAllMobs = FindAllMobs,
    HasWeapon = HasWeapon, Attack = Attack, KillAura = KillAura, UltraCombo = UltraCombo,
    EquipType = EquipType, EquipBest = EquipBest,
    DeathWait = DeathWait, SafeCheck = SafeCheck,
    GetQuest = GetQuest, GetOptimalStats = GetOptimalStats, PredictPosition = PredictPosition,
    AcceptQuest = AcceptQuest, SmartQuestSwitch = SmartQuestSwitch,
    BuyRaidChip = BuyRaidChip, FindRaidChip = FindRaidChip,
    FindRaidConsole = FindRaidConsole, FindRaidRoom = FindRaidRoom,
    GetCDKProgress = GetCDKProgress,
    Quests = Quests, Bosses = Bosses, EliteEnemies = EliteEnemies,
    Raids = Raids, FruitDB = FruitDB, RO = RO,
    MaterialsDB = MaterialsDB, AllBossDropWeapons = AllBossDropWeapons,
    IslandLocations = IslandLocations,
    FightingStylesShop = FightingStylesShop,
    SwordShop = SwordShop, GunShop = GunShop, AbilitiesShop = AbilitiesShop,
    BossDropWeaponsSea1 = BossDropWeaponsSea1,
    BossDropWeaponsSea2 = BossDropWeaponsSea2,
    BossDropWeaponsSea3 = BossDropWeaponsSea3,
    AtkCount = 0, IsMoving = false,
    RaidState = RaidState, CDKState = CDKState, DungeonState = DungeonState,
    Cache = Cache, ClearCharCache = ClearCharCache,
    JitterOffset = JitterOffset,
}
task.spawn(function()
    while true do
        task.wait(0.05)
        if _G.Apex then
            if AtkCount > (_G.Apex.AtkCount or 0) then
                _G.Apex.AtkCount = AtkCount
            else
                AtkCount = _G.Apex.AtkCount or AtkCount
            end
            _G.Apex.IsMoving = IsMoving
        end
    end
end)