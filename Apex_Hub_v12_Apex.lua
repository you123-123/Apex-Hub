---- ====================================================================
---- APEX HUB v12.0 "APEX COMPLETE" - THE FINAL DEFINITIVE BLOX FRUITS SCRIPT
---- All techniques from: Redz Hub, Hoho Hub, W-Azure, Alchemy Hub,
----   Void Hub, Sukuna Hub, Relz Hub, Zen Hub, Muxus Hub, ZekeHub
---- NEW in v11.0: Ultra Combat System, Skill Chains, Auto Haki Activation,
----   Auto Fighting Style Quests, Auto Dough King, Smart Quest Switcher,
----   Auto Bard Quest, Advanced Anti-Detection (Jitter, FakePos),
----   Auto Dimensions (Frozen/Mirror), Material Detector, Auto PvP Revenge,
----   Smart Safe Zone, Auto Farm All, Enhanced Memory Cleanup,
----   15-Tab UI, Enhanced Status Bar, Combat Tab, Anti-AC Tab
---- NEW in v12.0: Boss Drop Farming (Sea 1/2/3), Boss Quests, Special Quests,
----   Dungeon System, Race System, Sea Events Enhanced, Shop System,
----   Movement Additions (NoStun, V3, V4), Combat Additions (Super Attack, Safe Mode),
----   Teleport System, Dojo & Dragon, 5 New UI Tabs (Boss Drops, Special Quests,
----   Dungeon, Teleport, Shop), 169+ new features from ZekeHub/ZenHub/RedzHub
---- ====================================================================

if _G.ApexLoaded then return end
_G.ApexLoaded = true

if not game:IsLoaded() then game.Loaded:Wait() end

---- ========== CORE SERVICES ==========
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

---- ========== EXPLOIT ENVIRONMENT ==========
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

---- ========== PERFORMANCE CACHE ==========
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

---- ========== CONFIG ==========
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
    -- v11 new flags
    AutoFishing=false, AutoTrade=false, AutoFreezeTrade=false,
    NoclipEnabled=false, InfiniteJump=false, InfiniteEnergy=false, InfiniteSoru=false,
    AimbotEnabled=false, AutoBartiloQuest=false, AutoLegendarySword=false,
    AutoLawRaid=false, AutoObservationHaki=false, AutoMastery600=false,
    AutoBuddhaTransform=false, AutoRandomFruit=false, AutoBuyFruitStock=false,
    AutoCollectBerries=false, AutoGhoulRace=false, AutoPrehistoricIsland=false,
    BoatSpeedEnabled=false, ChestHop=false, AutoCraftItems=false,
    QuestBypass=false, AutoBuyBusoColors=false,
    -- v12 new flags: Boss Drop Farming
    AutoBossDropSaber=false, AutoBossDropPole=false, AutoBossDropSharkSaw=false,
    AutoBossDropTrident=false, AutoBossDropMusket=false, AutoBossDropWardenSword=false,
    AutoBossDropBazooka=false,
    AutoBossDropAcidumRifle=false, AutoBossDropJitte=false, AutoBossDropHellfireTorch=false,
    AutoBossDropSerpentBow=false, AutoBossDropTwinHooks=false, AutoBossDropBuddySword=false,
    AutoBossDropDarkDagger=false,
    -- v12 new flags: Boss Quests
    AutoDarkDaggerQuest=false, AutoHallowScytheQuest=false, AutoSwanGlassesQuest=false,
    AutoGreybeardQuest=false,
    -- v12 new flags: Special Quests
    AutoCitizenQuest=false, AutoRainbowHaki=false, AutoHolyTorch=false,
    AutoEnhancementColor=false,
    -- v12 new flags: Dungeon
    AutoDungeonFull=false,
    -- v12 new flags: Race System
    AutoRaceDoor=false, AutoAutoTrial=false, AutoTrainRace=false,
    AutoBuyGear=false,
    -- v12 new flags: Sea Events Enhanced
    AutoTPMirage=false, AutoTPBlueGear=false, AutoTPKitsune=false,
    AutoAzureEmber=false, AutoKillTerrorshark=false, AutoKillPiranha=false,
    AutoKillFishCrew=false,
    -- v12 new flags: Shop System
    AutoBuyFightingStyles=false, AutoBuySwords=false,
    AutoBuyGuns=false, AutoBuyAbilities=false,
    AutoRefundStat=false, AutoRerollRace=false,
    AutoBuyGhoul=false, AutoBuyCyborg=false, AutoBuyDraco=false,
    -- v12 new flags: Movement
    NoStunEnabled=false, AutoActiveV3=false, AutoActiveV4Full=false,
    -- v12 new flags: Combat
    SuperAttack=false, SafeModePvP=false,
    -- v12 new flags: Dojo
    AutoDojo=false,
    -- v12.1 new flags: Simple features
    AutoFarmBones=false, AutoFarmCandy=false,
    AutoSecondSea=false, AutoThirdSea=false,
    SafeTween=true, AntiStuck=true,
    DisableNotify=false, AutoTreeDestroyer=false
}
---- ========== CHARACTER UTILITIES (Cached) ==========
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

---- ========== CONFIG SAVE / LOAD ==========
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

---- ========== HUMANIZED MOVEMENT ==========
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

---- ========== SMART PATHFINDING ==========
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

---- ========== REMOTE FIRE SYSTEM ==========
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

---- ========== RANDOMIZED ANTI-DETECTION DELAYS ==========
local function RandDelay(min, max)
    return min + math.random() * (max - min)
end

---- ========== V10: ADVANCED ANTI-DETECTION (Jitter + FakePos) ==========
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

---- ========== ANTI-CHEAT BYPASS v7 (6-Layer + v10 Enhancements) ==========
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
---- ========== QUEST DATABASE ==========
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

---- ========== BOSS DATABASE ==========
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

---- ========== RAID DATABASE ==========
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

---- ========== FRUIT DATABASE ==========
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

---- ========== MATERIALS DATABASE ==========
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
---- ========== V12: BOSS DROP WEAPON DATABASE ==========
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

---- ========== V12: ISLAND TELEPORT LOCATIONS ==========
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

---- ========== V12: SHOP DATABASES ==========
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

---- ========== V12: SUPER ATTACK FUNCTION ==========
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

---- ========== V12: SAFE MODE PvP ==========
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

---- ========== V12: TELEPORT TO LOCATION ==========
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

---- ========== V12: BOSS DROP FARMING LOOP - SEA 1 ==========
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

---- ========== V12: BOSS DROP FARMING LOOP - SEA 2 ==========
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

---- ========== V12: BOSS DROP FARMING LOOP - SEA 3 ==========
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

---- ========== V12: AUTO DARK DAGGER QUEST ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoDarkDaggerQuest then continue end
        pcall(function()
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

---- ========== V12: AUTO HALLOW SCYTHE QUEST ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoHallowScytheQuest then continue end
        pcall(function()
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

---- ========== V12: AUTO SWAN GLASSES QUEST ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoSwanGlassesQuest then continue end
        pcall(function()
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

---- ========== V12: AUTO GREYBEARD QUEST ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoGreybeardQuest then continue end
        pcall(function()
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

---- ========== V12: AUTO CITIZEN QUEST ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoCitizenQuest then continue end
        pcall(function()
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

---- ========== V12: AUTO RAINBOW HAKI ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoRainbowHaki then continue end
        pcall(function()
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

---- ========== V12: AUTO HOLY TORCH ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoHolyTorch then continue end
        pcall(function()
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

---- ========== V12: AUTO ENHANCEMENT COLOR ==========
task.spawn(function()
    while true do
        task.wait(10)
        if not F.AutoEnhancementColor then continue end
        pcall(function()
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

---- ========== V12: AUTO DUNGEON SYSTEM ==========
local DungeonState = {InProgress=false, Room=0}

task.spawn(function()
    while true do
        task.wait(2)
        if not F.AutoDungeonFull then continue end
        pcall(function()
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

---- ========== V12: AUTO RACE DOOR ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoRaceDoor then continue end
        pcall(function()
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

---- ========== V12: AUTO TRIAL ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoAutoTrial then continue end
        pcall(function()
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

---- ========== V12: AUTO TRAIN RACE ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoTrainRace then continue end
        pcall(function()
            if not Alive() then return end
            CommF("TrainRace")
            CommF("StartTrain")
            CommF("RaceTrain")
            CommF("BeginRace")
        end)
    end
end)

---- ========== V12: AUTO BUY GEAR ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoBuyGear then continue end
        pcall(function()
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

---- ========== V12: AUTO TP MIRAGE (Enhanced) ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoTPMirage then continue end
        pcall(function()
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

---- ========== V12: AUTO TP BLUE GEAR ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoTPBlueGear then continue end
        pcall(function()
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

---- ========== V12: AUTO TP KITSUNE ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoTPKitsune then continue end
        pcall(function()
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

---- ========== V12: AUTO AZURE EMBER ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoAzureEmber then continue end
        pcall(function()
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

---- ========== V12: AUTO KILL TERRORSHARK ==========
task.spawn(function()
    while true do
        task.wait(2)
        if not F.AutoKillTerrorshark then continue end
        pcall(function()
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

---- ========== V12: AUTO KILL PIRANHA ==========
task.spawn(function()
    while true do
        task.wait(2)
        if not F.AutoKillPiranha then continue end
        pcall(function()
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

---- ========== V12: AUTO KILL FISH CREW ==========
task.spawn(function()
    while true do
        task.wait(2)
        if not F.AutoKillFishCrew then continue end
        pcall(function()
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

---- ========== V12: SHOP SYSTEM - FIGHTING STYLES ==========
task.spawn(function()
    while true do
        task.wait(10)
        if not F.AutoBuyFightingStyles then continue end
        pcall(function()
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

---- ========== V12: SHOP SYSTEM - SWORDS ==========
task.spawn(function()
    while true do
        task.wait(10)
        if not F.AutoBuySwords then continue end
        pcall(function()
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

---- ========== V12: SHOP SYSTEM - GUNS ==========
task.spawn(function()
    while true do
        task.wait(10)
        if not F.AutoBuyGuns then continue end
        pcall(function()
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

---- ========== V12: SHOP SYSTEM - ABILITIES ==========
task.spawn(function()
    while true do
        task.wait(10)
        if not F.AutoBuyAbilities then continue end
        pcall(function()
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

---- ========== V12: SHOP SYSTEM - REFUND / REROLL / RACES ==========
task.spawn(function()
    while true do
        task.wait(15)
        if not F.AutoRefundStat and not F.AutoRerollRace and not F.AutoBuyGhoul and not F.AutoBuyCyborg and not F.AutoBuyDraco then continue end
        pcall(function()
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

---- ========== V12: NO STUN ==========
task.spawn(function()
    while true do
        task.wait(0.1)
        if not F.NoStunEnabled then continue end
        pcall(function()
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

---- ========== V12: AUTO ACTIVE V3 ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoActiveV3 then continue end
        pcall(function()
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

---- ========== V12: AUTO ACTIVE V4 ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoActiveV4Full then continue end
        pcall(function()
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

---- ========== V12: SAFE MODE PvP LOOP ==========
task.spawn(function()
    while true do
        task.wait(1)
        if not F.SafeModePvP then continue end
        pcall(function()
            if not Alive() then return end
            SafeModePvPCheck()
        end)
    end
end)

---- ========== V12: SUPER ATTACK LOOP ==========
task.spawn(function()
    while true do
        task.wait(0.15)
        if not F.SuperAttack then continue end
        pcall(function()
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

---- ========== V12: AUTO DOJO ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoDojo then continue end
        pcall(function()
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

---- ========== V12: AUTO ACTIVE V4 FULL LOOP ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoActiveV4Full then continue end
        pcall(function()
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

---- ========== V12: AUTO V3 FULL LOOP ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoActiveV3 then continue end
        pcall(function()
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

---- ========== MOB FINDER (Optimized) ==========
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

---- ========== SMART MOB TARGETING ==========
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

---- ========== SMART STAT DISTRIBUTION - LEVEL BRACKETS ==========
local function GetOptimalStats(level)
    if level < 300 then return {"Melee", "Defense"} end
    if level < 700 then return {"Melee", "Defense", "Sword"} end
    if level < 1500 then return {"Melee", "Defense", "Sword"} end
    return {"Melee", "Defense", "Blox Fruit"}
end

---- ========== PREDICTION COMBAT ==========
local function PredictPosition(targetHRP, myHRP)
    if not targetHRP or not myHRP then
        return targetHRP and targetHRP.Position or Vector3.new(0, 0, 0)
    end
    local vel = targetHRP.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local dist = (targetHRP.Position - myHRP.Position).Magnitude
    local travelTime = dist / 350
    return targetHRP.Position + vel * travelTime * 0.5
end

---- ========== ATTACK SYSTEM ==========
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

---- ========== V11: ULTRA COMBO FUNCTION (Standalone) ==========
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

---- ========== EQUIPMENT ==========
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

---- ========== DEATH / SAFE HANDLING ==========
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
---- ========== QUEST ACCEPT ==========
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

---- ========== AUTO FARM ==========
local function GetQuest(lv)
    for _, q in ipairs(Quests) do
        if lv >= q.Min and lv <= q.Max then return q end
    end
    return Quests[#Quests]
end

---- ========== V10: SMART QUEST SWITCHER ==========
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
        if not F.AutoFarm then continue end
        pcall(function()
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

---- ========== BOSS FARM ==========
task.spawn(function()
    while true do
        task.wait()
        if not F.AutoBossFarm then continue end
        pcall(function()
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

---- ========== MASTERY FARM ==========
task.spawn(function()
    while true do
        task.wait()
        if not (F.AutoMasteryFruit or F.AutoMasterySword) then continue end
        pcall(function()
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

---- ========== KILL AURA LOOP ==========
task.spawn(function()
    while true do
        task.wait(0.15)
        if not F.KillAura then continue end
        pcall(function()
            if not Alive() then return end
            KillAura(C.KillAuraRange, 0.06)
        end)
    end
end)

---- ========== AUTO STATS ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoStats then continue end
        pcall(function() CommF("AddStat", C.StatType) end)
    end
end)

---- ========== SMART STAT DISTRIBUTION (Level Brackets) ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.SmartStatDist then continue end
        pcall(function()
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
---- ========== AUTO RAID SYSTEM ==========
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
        if not F.AutoRaid then continue end
        pcall(function()
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
---- ========== AUTO CDK SYSTEM ==========
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

task.spawn(function()
    while true do
        task.wait(2)
        if not F.AutoCDK or not F.CDKAutoWisps then continue end
        pcall(function()
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
        if not F.AutoCDK or not F.CDKAutoElites then continue end
        pcall(function()
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
                                                atk = atk + 1; AtkCount = AtkCount + 1
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
        if not F.AutoCDK or not F.CDKAutoSoulReaper then continue end
        pcall(function()
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
                                    atk = atk + 1; AtkCount = AtkCount + 1
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
        if not F.AutoCDK or not F.CDKAutoScrolls then continue end
        pcall(function()
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
---- ========== BOUNTY HUNTER SYSTEM ==========
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
        AtkCount = AtkCount + 1
        pcall(function() CommF("Ability", 1) end)
        pcall(function() CommF("UseAbility", 1) end)
        pcall(function() CommF("UseSkill", 1) end)
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        if not F.BountyHunt then continue end
        pcall(function()
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

---- ========== V10: AUTO PVP REVENGE ==========
task.spawn(function()
    while true do
        task.wait(2)
        if not F.AutoRevenge then continue end
        pcall(function()
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
                            AtkCount = AtkCount + 1
                        end
                    end
                end
            end
        end)
    end
end)

---- ========== FRUIT SYSTEM ==========
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
        if not F.AutoFindFruits then continue end
        pcall(function()
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
        if not F.FruitSniper then continue end
        pcall(function()
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
        if not F.FruitRain then continue end
        pcall(function()
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

---- ========== ESP SYSTEM (with Health Bars + Tracers) ==========
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
---- ========== SEA EVENTS ==========
task.spawn(function()
    while true do task.wait(3)
        if not F.AutoMirage then continue end
        pcall(function()
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
        if not F.AutoSeaBeast then continue end
        pcall(function()
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
                            else Attack(obj, {"Click","Click","Click","Click","Remote","Click","Click","Ability"}, 0.04); AtkCount = AtkCount + 1 end
                        end
                        return
                    end
                end
            end
        end)
    end
end)

---- ========== V10: AUTO FROZEN / MIRROR DIMENSION ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoFrozenDimension then continue end
        pcall(function()
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
        task.wait(3)
        if not F.AutoMirrorDimension then continue end
        pcall(function()
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
                            atk = atk + 1; AtkCount = AtkCount + 1; task.wait(0.06)
                        end
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do task.wait(3)
        if not F.AutoRaceV4 then continue end
        pcall(function()
            if not Alive() then return end
            pcall(function() CommF("ActivateRaceV4") end)
            pcall(function() CommF("RaceAwakening") end)
            pcall(function() CommF("TrialStart") end)
        end)
    end
end)

task.spawn(function()
    while true do task.wait(30)
        if not F.AutoSetSpawn then continue end
        pcall(function() CommF("SetSpawnPoint") end)
    end
end)

---- ========== SERVER HOP ==========
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
---- ========== FLY SYSTEM ==========
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

---- ========== FPS LIMITER ==========
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

---- ========== AUTO CHEST FARM ==========
task.spawn(function()
    while true do
        task.wait(2)
        if not F.AutoChestFarm then continue end
        pcall(function()
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

---- ========== HAKI TRAINING ==========
task.spawn(function()
    while true do
        task.wait(2)
        if not F.AutoHakiBuso then continue end
        pcall(function()
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
                        AtkCount = AtkCount + 1
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
        if not F.AutoHakiKen then continue end
        pcall(function()
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

---- ========== AUTO FACTORY EVENT ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoFactoryEvent then continue end
        pcall(function()
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
                                        atk = atk + 1; AtkCount = AtkCount + 1
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

---- ========== AUTO BUY FROM SHOPS ==========
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
---- ========== RACE V4 FRAGMENTS ==========
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

---- ========== AUTO AWAKEN FRUIT ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoAwakenFruit then continue end
        pcall(function()
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

---- ========== AUTO WEAPONS (GodHuman, Soul Guitar, etc.) ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoGodHuman then continue end
        pcall(function()
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
                                    atk = atk + 1; AtkCount = AtkCount + 1
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

---- ========== V10: AUTO FIGHTING STYLE QUESTS ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoDragonTalon and not F.AutoDeathStep and not F.AutoSharkKarate and not F.AutoElectricClaw then continue end
        pcall(function()
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
                                            atk = atk + 1; AtkCount = AtkCount + 1; task.wait(0.06)
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

---- ========== V10: AUTO DOUGH KING ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoDoughKing then continue end
        pcall(function()
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
                                    atk = atk + 1; AtkCount = AtkCount + 1; task.wait(0.06)
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
---- ========== V10: AUTO BARD QUEST ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoBardQuest then continue end
        pcall(function()
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
                            atk = atk + 1; AtkCount = AtkCount + 1; task.wait(0.06)
                        end
                    end
                end
            end
        end)
    end
end)

---- ========== SOUL GUITAR ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoSoulGuitar then continue end
        pcall(function()
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
                        atk = atk + 1; AtkCount = AtkCount + 1; task.wait(0.06)
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
                    AtkCount = AtkCount + 1
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

---- ========== TUSK V4 ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoTuskV4 then continue end
        pcall(function()
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
                            atk = atk + 1; AtkCount = AtkCount + 1; task.wait(0.06)
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

---- ========== DARK BLADE ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoDarkBlade then continue end
        pcall(function()
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
                                                    atk = atk + 1; AtkCount = AtkCount + 1; task.wait(0.06)
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

---- ========== SHARK ANCHOR ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoSharkAnchor then continue end
        pcall(function()
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
                            atk = atk + 1; AtkCount = AtkCount + 1; task.wait(0.06)
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

---- ========== CANVANDER ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoCanvander then continue end
        pcall(function()
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
                                    atk = atk + 1; AtkCount = AtkCount + 1; task.wait(0.06)
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

---- ========== LEGEND SWORD ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoLegendSword then continue end
        pcall(function()
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

---- ========== MATERIALS FARM ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoMaterialsFarm then continue end
        pcall(function()
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
                            atk = atk + 1; AtkCount = AtkCount + 1; task.wait(0.06)
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

---- ========== V10: MATERIAL DETECTOR ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoMaterialDetector then continue end
        pcall(function()
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
---- ========== ENHANCED COMBAT: AUTO DODGE ==========
task.spawn(function()
    while true do
        task.wait(0.5)
        if not F.AutoDodge then continue end
        pcall(function()
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

---- ========== V10: ULTRA COMBO SYSTEM (Skill Chains) ==========
task.spawn(function()
    while true do
        task.wait(C.ComboDelay)
        if not F.ComboAttack and not F.UltraComboMode then continue end
        pcall(function()
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
                Attack(mob, {"Click","Click","Remote"}, 0.04); AtkCount = AtkCount + 1
                if mh.Health <= 0 then return end
                EquipType("Fruit"); task.wait(0.08)
                Attack(mob, {"Click","Ability","Ability"}, 0.06); AtkCount = AtkCount + 1
                if mh.Health <= 0 then return end
                EquipType("Gun"); task.wait(0.08)
                Attack(mob, {"Click","Remote"}, 0.06); AtkCount = AtkCount + 1
                if mh.Health <= 0 then return end
                EquipType("Fighting"); task.wait(0.08)
                Attack(mob, {"Click","Click","Ability"}, 0.05); AtkCount = AtkCount + 1
                if mh.Health <= 0 then return end
                EquipBest(); task.wait(0.08)
                Attack(mob, {"Click","Click","Click","Click","Remote"}, 0.03); AtkCount = AtkCount + 1
            else
                EquipType("Sword"); task.wait(0.1)
                Attack(mob, {"Click","Click","Remote"}, 0.05); AtkCount = AtkCount + 1
                if mh.Health <= 0 then return end
                EquipType("Fruit"); task.wait(0.1)
                Attack(mob, {"Click","Ability"}, 0.08); AtkCount = AtkCount + 1
                if mh.Health <= 0 then return end
                EquipType("Gun"); task.wait(0.1)
                Attack(mob, {"Click","Remote"}, 0.08); AtkCount = AtkCount + 1
                if mh.Health <= 0 then return end
                EquipBest(); task.wait(0.1)
                Attack(mob, {"Click","Click","Click","Click","Remote"}, 0.04); AtkCount = AtkCount + 1
            end
        end)
    end
end)

---- ========== V10: AUTO HAKI ACTIVATION IN COMBAT ==========
task.spawn(function()
    while true do
        task.wait(1)
        if not F.AutoBusoHaki and not F.AutoKenHaki then continue end
        pcall(function()
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

---- ========== V10: SMART SAFE ZONE ==========
task.spawn(function()
    while true do
        task.wait(2)
        if not F.SmartSafeZone then continue end
        pcall(function()
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

---- ========== PLAYER HIGHLIGHT ==========
local Highlights = {}

task.spawn(function()
    while true do
        task.wait(2)
        if not F.PlayerHighlight then
            for _, hl in pairs(Highlights) do
                if hl and hl.Parent then hl:Destroy() end
            end
            Highlights = {}
            continue
        end
        pcall(function()
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

---- ========== FPS BOOST ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.FPSBoost then continue end
        pcall(function()
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

---- ========== V10: ENHANCED MEMORY CLEANUP WITH STATS ==========
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
---- ========== V11: AUTO FISHING SYSTEM ==========
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
        if not F.AutoFishing then continue end
        pcall(function()
            if not Alive() then return end
            AutoFish()
        end)
    end
end)

---- ========== V11: AUTO TRADE SYSTEM ==========
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
        if not F.AutoTrade then continue end
        pcall(function()
            if F.AutoFreezeTrade then FreezeTrade() end
            AutoAcceptTrade()
        end)
    end
end)

---- ========== V11: NOCLIP SYSTEM ==========
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

---- ========== V11: WALK SPEED + JUMP POWER + DASH ==========
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

---- ========== V11: INFINITE JUMP ==========
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

---- ========== V11: INFINITE ENERGY + SORU ==========
task.spawn(function()
    while true do
        task.wait(0.1)
        if not F.InfiniteEnergy then continue end
        pcall(function()
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
        if not F.InfiniteSoru then continue end
        pcall(function()
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

---- ========== V11: AIMBOT CAMERA LOCK ==========
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

---- ========== V11: AUTO BARTILO QUEST ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoBartiloQuest then continue end
        pcall(function()
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

---- ========== V11: AUTO LEGENDARY SWORDS ==========
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
        if not F.AutoLegendarySword then continue end
        pcall(function() BuyLegendarySword() end)
    end
end)

---- ========== V11: AUTO LAW RAID ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoLawRaid then continue end
        pcall(function()
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
                        AtkCount = AtkCount + 1
                        task.wait(0.06)
                    end
                end
            end
        end)
    end
end)

---- ========== V11: AUTO OBSERVATION HAKI FARM ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoObservationHaki then continue end
        pcall(function()
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

---- ========== V11: AUTO FARM 600 MASTERY ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoMastery600 then continue end
        pcall(function()
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

---- ========== V11: AUTO BUDDHA TRANSFORMATION ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoBuddhaTransform then continue end
        pcall(function()
            CommF("BuddhaTransformation")
            CommF("TransformBuddha")
            CommF("BuddhaTransform")
        end)
    end
end)

---- ========== V11: AUTO RANDOM FRUIT ==========
task.spawn(function()
    while true do
        task.wait(10)
        if not F.AutoRandomFruit then continue end
        pcall(function()
            CommF("BuyRandomFruit")
            CommF("RandomFruit")
            CommF("SpinFruit")
        end)
    end
end)

---- ========== V11: AUTO BUY FRUIT STOCK ==========
task.spawn(function()
    while true do
        task.wait(30)
        if not F.AutoBuyFruitStock then continue end
        pcall(function()
            local fruitList = {"Dragon","Leopard","Spirit","Dough","Buddha","Control","Kitsune"}
            for _, fruit in ipairs(fruitList) do
                CommF("BuyItem", fruit)
                CommF("PurchaseFruit", fruit)
                CommF("BuyFruit", fruit)
            end
        end)
    end
end)

---- ========== V11: AUTO COLLECT BERRIES ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoCollectBerries then continue end
        pcall(function()
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

---- ========== V11: AUTO GHOUL RACE ==========
task.spawn(function()
    while true do
        task.wait(10)
        if not F.AutoGhoulRace then continue end
        pcall(function()
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

---- ========== V11: AUTO PREHISTORIC ISLAND ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoPrehistoricIsland then continue end
        pcall(function()
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

---- ========== V11: BOAT SELECTION + SPEED ==========
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
        if not F.BoatSpeedEnabled then continue end
        pcall(function()
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

---- ========== V11: CHEST HOP ==========
task.spawn(function()
    while true do
        task.wait(1)
        if not F.ChestHop then continue end
        pcall(function()
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

---- ========== V11: AUTO CRAFT ITEMS ==========
task.spawn(function()
    while true do
        task.wait(30)
        if not F.AutoCraftItems then continue end
        pcall(function()
            CommF("CraftItem")
            CommF("ForgeItem")
            CommF("UpgradeWeapon")
        end)
    end
end)

---- ========== V11: QUEST BYPASS ==========
local function QuestBypass()
    pcall(function()
        CommF("QuestBypass")
        CommF("BypassQuest")
        CommF("SkipQuest")
        CommF("CompleteQuest")
        CommF("FinishQuest")
    end)
end

---- ========== V11: CUSTOM WEBHOOK ==========
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

---- ========== V11: BUY BUSO COLORS ==========
task.spawn(function()
    while true do
        task.wait(30)
        if not F.AutoBuyBusoColors then continue end
        pcall(function()
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

---- ========== V11: ISLAND SELECTOR ==========
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


---- ========== V11: ADDITIONAL UTILITY FUNCTIONS ==========

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



---- ========== V11: ENHANCED AUTO FISHING WITH QUEST SUPPORT ==========
task.spawn(function()
    while true do
        task.wait(10)
        if not F.AutoFishing then continue end
        pcall(function()
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
        if not F.AutoFishing then continue end
        pcall(function()
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

---- ========== V11: ENHANCED TRADE SYSTEM WITH FULL AUTO ==========
task.spawn(function()
    while true do
        task.wait(2)
        if not F.AutoTrade then continue end
        pcall(function()
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

---- ========== V11: ENHANCED NOCLIP WITH TOGGLE ==========
task.spawn(function()
    while true do
        task.wait(0.1)
        if not F.NoclipEnabled then continue end
        pcall(function()
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

---- ========== V11: AIMBOT WITH TEAM CHECK ==========
task.spawn(function()
    while true do
        task.wait(0.5)
        if not F.AimbotEnabled then continue end
        pcall(function()
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
                        if LP.Team and p.Team and LP.Team == p.Team then
                            continue
                        end
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
                local targetCF = CFrame.new(cam.CFrame.Position, closest.Position)
                cam.CFrame = cam.CFrame:Lerp(targetCF, 0.3)
            end
        end)
    end
end)

---- ========== V11: AUTO LEGENDARY SWORDS ENHANCED ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoLegendarySword then continue end
        pcall(function()
            if not Alive() then return end
            for _, sword in ipairs(LegendarySwords) do
                if not F.AutoLegendarySword then break end
                if HasWeapon(sword) then
                    continue
                end
                CommF("BuyItem", sword)
                CommF("PurchaseItem", sword)
                CommF("LegendarySword", sword)
                task.wait(1)
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

---- ========== V11: AUTO LAW RAID ENHANCED ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoLawRaid then continue end
        pcall(function()
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
                        AtkCount = AtkCount + 1
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

---- ========== V11: AUTO OBSERVATION HAKI ENHANCED ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoObservationHaki then continue end
        pcall(function()
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

---- ========== V11: ENHANCED COLLECT BERRIES WITH EGG SUPPORT ==========
task.spawn(function()
    while true do
        task.wait(3)
        if not F.AutoCollectBerries then continue end
        pcall(function()
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

---- ========== V11: AUTO GHOUL RACE ENHANCED ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoGhoulRace then continue end
        pcall(function()
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
                            AtkCount = AtkCount + 1
                            task.wait(0.05)
                        end
                    end
                end
            end
        end)
    end
end)

---- ========== V11: AUTO PREHISTORIC ISLAND ENHANCED ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoPrehistoricIsland then continue end
        pcall(function()
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

---- ========== V11: BOAT SYSTEM ENHANCED ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.BoatSpeedEnabled then continue end
        pcall(function()
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

---- ========== V11: CHEST HOP ENHANCED ==========
task.spawn(function()
    while true do
        task.wait(1)
        if not F.ChestHop then continue end
        pcall(function()
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

---- ========== V11: AUTO CRAFT ITEMS ENHANCED ==========
task.spawn(function()
    while true do
        task.wait(15)
        if not F.AutoCraftItems then continue end
        pcall(function()
            CommF("CraftItem")
            CommF("ForgeItem")
            CommF("UpgradeWeapon")
            CommF("EnhanceItem")
            CommF("UpgradeSword")
            CommF("EvolveWeapon")
        end)
    end
end)

---- ========== V11: QUEST BYPASS ENHANCED ==========
task.spawn(function()
    while true do
        task.wait(10)
        if not F.QuestBypass then continue end
        pcall(function()
            QuestBypass()
            CommF("CompleteAllQuests")
            CommF("FinishAllQuests")
            CommF("SkipAllQuests")
        end)
    end
end)

---- ========== V11: BUY BUSO COLORS ENHANCED ==========
task.spawn(function()
    while true do
        task.wait(15)
        if not F.AutoBuyBusoColors then continue end
        pcall(function()
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

---- ========== V11: ENHANCED SMART SAFE ZONE ==========
task.spawn(function()
    while true do
        task.wait(2)
        if not F.SmartSafeZone then continue end
        pcall(function()
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

---- ========== V12.1: ANTI-STUCK ==========
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

---- ========== V12.1: SAFE TWEEN GLOBAL MONITOR ==========
task.spawn(function()
    while true do
        task.wait(1)
        if not F.SafeTween then continue end
        pcall(function()
            if not Alive() then return end
            local h = HRP()
            if not h then return end
            if IsMoving then
                local pos1 = h.Position
                task.wait(5)
                if IsMoving and Alive() then
                    local h2 = HRP()
                    if h2 and (h2.Position - pos1).Magnitude < 0.5 then
                        CancelMove()
                    end
                end
            end
        end)
    end
end)

---- ========== V12.1: AUTO FARM BONES ==========
task.spawn(function()
    while true do
        task.wait(2)
        if not F.AutoFarmBones then continue end
        pcall(function()
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
                            AtkCount = AtkCount + 1
                        end
                    end
                end
            end
        end)
    end
end)

---- ========== V12.1: AUTO FARM CANDY ==========
task.spawn(function()
    while true do
        task.wait(2)
        if not F.AutoFarmCandy then continue end
        pcall(function()
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
                            AtkCount = AtkCount + 1
                        end
                    end
                end
            end
        end)
    end
end)

---- ========== V12.1: AUTO SECOND SEA PROGRESSION ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoSecondSea then continue end
        pcall(function()
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
                            atk = atk + 1; AtkCount = AtkCount + 1; task.wait(0.06)
                        end
                    end
                end
            end
        end)
    end
end)

---- ========== V12.1: AUTO THIRD SEA PROGRESSION ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoThirdSea then continue end
        pcall(function()
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

---- ========== V12.1: AUTO TREE DESTROYER ==========
task.spawn(function()
    while true do
        task.wait(2)
        if not F.AutoTreeDestroyer then continue end
        pcall(function()
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
                                    atk = atk + 1; AtkCount = AtkCount + 1; task.wait(0.06)
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

---- ========== UI LIBRARY ==========
local Theme = {
    BG=Color3.fromRGB(15,15,25), Bar=Color3.fromRGB(25,25,40),
    Accent=Color3.fromRGB(255,70,70), Sec=Color3.fromRGB(20,20,35),
    Text=Color3.fromRGB(235,235,235), Dim=Color3.fromRGB(140,140,160),
    ToggleOff=Color3.fromRGB(55,55,75), SliderBG=Color3.fromRGB(35,35,55),
    DropBG=Color3.fromRGB(30,30,50), Border=Color3.fromRGB(35,35,55)
}

local function M(cls, props, kids)
    local i = Instance.new(cls)
    for k,v in pairs(props or {}) do pcall(function() i[k]=v end) end
    for _,c in ipairs(kids or {}) do c.Parent = i end
    return i
end

local function Cr(p,r) return M("UICorner",{CornerRadius=UDim.new(0,r or 8)},{},p) end
local function St(p,c,t) return M("UIStroke",{Color=c or Theme.Border,Thickness=t or 1},{},p) end

local scr = M("ScreenGui",{Name="ApexHub",ZIndexBehavior=Enum.ZIndexBehavior.Sibling,ResetOnSpawn=false})
local main = M("Frame",{Size=UDim2.new(0,800,0,600),Position=UDim2.new(0.5,-400,0.5,-300),BackgroundColor3=Theme.BG,BorderSizePixel=0,Active=true},{scr})
Cr(main,12); St(main,Theme.Accent,2)

local tb = M("Frame",{Size=UDim2.new(1,0,0,42),BackgroundColor3=Theme.Bar,BorderSizePixel=0},{main})
M("TextLabel",{Size=UDim2.new(0.5,0,1,0),Position=UDim2.new(0,15,0,0),BackgroundTransparency=1,Text="APEX HUB v12.0 APEX COMPLETE",TextColor3=Theme.Accent,TextSize=16,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},{tb})
local infoLbl = M("TextLabel",{Size=UDim2.new(0.45,0,1,0),Position=UDim2.new(0.53,0,0,0),BackgroundTransparency=1,Text=EXEC.." | Lv"..Lv(),TextColor3=Theme.Dim,TextSize=12,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Right},{tb})

local closeBtn = M("TextButton",{Size=UDim2.new(0,28,0,28),Position=UDim2.new(1,-36,0,7),BackgroundColor3=Color3.fromRGB(255,60,60),Text="X",TextColor3=Color3.new(1,1,1),TextSize=13,Font=Enum.Font.GothamBold,AutoButtonColor=true},{tb})
Cr(closeBtn,6)

local tabC = M("Frame",{Size=UDim2.new(0,140,1,-42),Position=UDim2.new(0,0,0,42),BackgroundColor3=Theme.Bar,BorderSizePixel=0},{main})
local tabList = M("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ScrollBarThickness=3,ScrollBarImageColor3=Theme.Accent,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y},{tabC})
M("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},{tabList})

local content = M("Frame",{Size=UDim2.new(1,-150,1,-46),Position=UDim2.new(0,148,0,44),BackgroundColor3=Theme.BG,BorderSizePixel=0},{main})
Cr(content,6)

local minimized = false
closeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized; tabC.Visible = not minimized
    main.Size = minimized and UDim2.new(0,800,0,42) or UDim2.new(0,800,0,600)
    closeBtn.Text = minimized and "+" or "X"
end)

local dragging, dragStart, startPos
tb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)

---- ========== TAB SYSTEM ==========
local AllTabs = {}

local function MakeTab(name)
    local btn = M("TextButton",{Size=UDim2.new(1,0,0,28),BackgroundColor3=Color3.fromRGB(45,45,65),Text=name,TextColor3=Theme.Dim,TextSize=10,Font=Enum.Font.GothamMedium,AutoButtonColor=true,Order=#AllTabs},{tabList})
    Cr(btn,6)
    local frame = M("ScrollingFrame",{Size=UDim2.new(1,-10,1,-10),Position=UDim2.new(0,5,0,5),BackgroundTransparency=1,Visible=false,ScrollBarThickness=3,ScrollBarImageColor3=Theme.Accent,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y},{content})
    M("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},{frame})

    local tab = {Frame=frame, Button=btn, Name=name}
    table.insert(AllTabs, tab)

    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(AllTabs) do t.Frame.Visible=false; t.Button.BackgroundColor3=Color3.fromRGB(45,45,65); t.Button.TextColor3=Theme.Dim end
        frame.Visible=true; btn.BackgroundColor3=Theme.Accent; btn.TextColor3=Theme.Text
    end)

    function tab:AddSection(n)
        local f = M("Frame",{Size=UDim2.new(1,0,0,26),BackgroundTransparency=1},{frame})
        M("TextLabel",{Size=UDim2.new(0.8,0,1,0),Position=UDim2.new(0,5,0,0),BackgroundTransparency=1,Text="-- "..n.." --",TextColor3=Theme.Accent,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},{f})
    end

    function tab:AddLabel(n)
        M("TextLabel",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,Text=n,TextColor3=Theme.Dim,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},{frame})
    end

    function tab:AddButton(cfg)
        local b = M("TextButton",{Size=UDim2.new(1,0,0,28),BackgroundColor3=Theme.Accent,Text=cfg.Name,TextColor3=Theme.Text,TextSize=11,Font=Enum.Font.GothamMedium,AutoButtonColor=true},{frame})
        Cr(b,6)
        b.MouseButton1Click:Connect(function() pcall(cfg.Callback) end)
    end

    function tab:AddToggle(cfg)
        local f = M("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=Theme.Sec,BorderSizePixel=0},{frame})
        Cr(f,6)
        M("TextLabel",{Size=UDim2.new(0.7,0,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text=cfg.Name,TextColor3=Theme.Text,TextSize=10,Font=Enum.Font.GothamMedium,TextXAlignment=Enum.TextXAlignment.Left},{f})
        local bg = M("Frame",{Size=UDim2.new(0,40,0,20),Position=UDim2.new(1,-52,0.5,-10),BackgroundColor3=cfg.Default and Theme.Accent or Theme.ToggleOff},{f})
        Cr(bg,10)
        local dot = M("Frame",{Size=UDim2.new(0,16,0,16),Position=cfg.Default and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8),BackgroundColor3=Theme.Text},{bg})
        Cr(dot,8)
        local state = cfg.Default or false
        local function upd()
            bg.BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff
            dot:TweenPosition(state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        end
        M("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=""},{f}).MouseButton1Click:Connect(function()
            state = not state; upd(); pcall(cfg.Callback, state)
        end)
        upd()
    end

    function tab:AddSlider(cfg)
        local f = M("Frame",{Size=UDim2.new(1,0,0,42),BackgroundColor3=Theme.Sec,BorderSizePixel=0},{frame})
        Cr(f,6)
        local mn=cfg.Min or 0; local mx=cfg.Max or 100; local val=cfg.Default or mn; local inc=cfg.Increment or 1; local vn=cfg.ValueName or ""
        M("TextLabel",{Size=UDim2.new(0.6,0,0,16),Position=UDim2.new(0,12,0,3),BackgroundTransparency=1,Text=cfg.Name,TextColor3=Theme.Text,TextSize=10,Font=Enum.Font.GothamMedium,TextXAlignment=Enum.TextXAlignment.Left},{f})
        local vl = M("TextLabel",{Size=UDim2.new(0.35,0,0,16),Position=UDim2.new(0.63,0,0,3),BackgroundTransparency=1,Text=tostring(val).." "..vn,TextColor3=Theme.Accent,TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Right},{f})
        local sbg = M("Frame",{Size=UDim2.new(1,-24,0,5),Position=UDim2.new(0,12,0,28),BackgroundColor3=Theme.SliderBG},{f})
        Cr(sbg,3)
        local pct=(val-mn)/(mx-mn)
        local fill = M("Frame",{Size=UDim2.new(pct,0,1,0),BackgroundColor3=Theme.Accent},{sbg})
        Cr(fill,3)
        local knob = M("Frame",{Size=UDim2.new(0,12,0,12),Position=UDim2.new(pct,-6,0.5,-6),BackgroundColor3=Theme.Text},{sbg})
        Cr(knob,6)
        local sliding = false
        local function update(x)
            local p = math.clamp((x-sbg.AbsolutePosition.X)/sbg.AbsoluteSize.X,0,1)
            val = math.floor((mn+(mx-mn)*p)/inc+0.5)*inc; val=math.clamp(val,mn,mx)
            local np=(val-mn)/(mx-mn); fill.Size=UDim2.new(np,0,1,0); knob.Position=UDim2.new(np,-6,0.5,-6)
            vl.Text = tostring(val).." "..vn
        end
        M("TextButton",{Size=UDim2.new(0,16,0,16),Position=UDim2.new(pct,-8,0.5,-8),BackgroundTransparency=1,Text=""},{sbg}).InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=true end end)
        UIS.InputEnded:Connect(function(i) if sliding and i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false; pcall(cfg.Callback,val) end end)
        UIS.InputChanged:Connect(function(i) if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then update(i.Position.X) end end)
        sbg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=true; update(i.Position.X) end end)
    end

    function tab:AddDropdown(cfg)
        local f = M("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=Theme.Sec,BorderSizePixel=0},{frame})
        Cr(f,6)
        M("TextLabel",{Size=UDim2.new(0.45,0,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text=cfg.Name,TextColor3=Theme.Text,TextSize=10,Font=Enum.Font.GothamMedium,TextXAlignment=Enum.TextXAlignment.Left},{f})
        local sel = cfg.Default or cfg.Options[1] or ""
        local selLbl = M("TextLabel",{Size=UDim2.new(0.4,0,1,0),Position=UDim2.new(0.55,0,0,0),BackgroundTransparency=1,Text=sel,TextColor3=Theme.Accent,TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Right},{f})
        M("TextLabel",{Size=UDim2.new(0,20,1,0),Position=UDim2.new(1,-22,0,0),BackgroundTransparency=1,Text=">",TextColor3=Theme.Dim,TextSize=13,Font=Enum.Font.GothamBold},{f})
        local open=false
        local list = M("ScrollingFrame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,1,2),BackgroundColor3=Theme.DropBG,BorderSizePixel=0,Visible=false,ScrollBarThickness=3,ScrollBarImageColor3=Theme.Accent,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Z,ZIndex=10},{f})
        Cr(list,6)
        M("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},{list})
        local function build()
            for _,c in ipairs(list:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
            for _,opt in ipairs(cfg.Options) do
                local ob=M("TextButton",{Size=UDim2.new(1,0,0,22),BackgroundColor3=Theme.Sec,Text="  "..opt,TextColor3=opt==sel and Theme.Accent or Theme.Text,TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=true,ZIndex=11},{list})
                Cr(ob,4)
                ob.MouseButton1Click:Connect(function() sel=opt; selLbl.Text=opt; open=false; list.Visible=false; list.Size=UDim2.new(1,0,0,0); pcall(cfg.Callback,opt) end)
            end
        end
        M("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=""},{f}).MouseButton1Click:Connect(function()
            open=not open; if open then build() end
            list.Visible=open; list.Size=open and UDim2.new(1,0,0,math.min(#cfg.Options*24+4,150)) or UDim2.new(1,0,0,0)
        end)
    end

    return tab
end
---- ========== BUILD ALL 15 TABS (v11.0) ==========

---- TAB 1: Main
local T1=MakeTab("Main")
T1:AddSection("Info")
T1:AddLabel("Executor: "..EXEC)
T1:AddLabel("Level: "..Lv())
T1:AddLabel("Beli: "..Beli())
T1:AddLabel("Fragments: "..Frags())
T1:AddLabel("Sea: "..Sea())
T1:AddLabel("Bounty: "..Bounty())
T1:AddSection("Safety")
T1:AddToggle({Name="Low Health Safe Mode",Default=F.LowHP,Callback=function(v) F.LowHP=v end})
T1:AddSlider({Name="Safe HP%",Min=5,Max=50,Default=C.SafeHP,ValueName="%",Callback=function(v) C.SafeHP=v end})
T1:AddSection("Movement")
T1:AddSlider({Name="Walk Speed",Min=16,Max=500,Default=C.WalkSpeed,Callback=function(v) C.WalkSpeed=v; local h=Hum(); if h then h.WalkSpeed=v end end})
T1:AddSlider({Name="Jump Power",Min=50,Max=500,Default=C.JumpPower,Callback=function(v) C.JumpPower=v; local h=Hum(); if h then h.JumpPower=v end end})
T1:AddToggle({Name="Fly (WASD+Space+Shift)",Default=F.Fly,Callback=function(v) F.Fly=v end})
T1:AddSlider({Name="Fly Speed",Min=20,Max=200,Default=C.FlySpeed,Callback=function(v) C.FlySpeed=v end})
T1:AddToggle({Name="Auto Set Spawn",Default=F.AutoSetSpawn,Callback=function(v) F.AutoSetSpawn=v end})
T1:AddSection("Server")
T1:AddButton({Name="Rejoin",Callback=function() QueueScript(); TPS:Teleport(game.PlaceId,LP) end})
T1:AddButton({Name="Server Hop",Callback=function() DoHop() end})
T1:AddButton({Name="Copy Job ID",Callback=function() Clip(game.JobId) end})

---- TAB 2: Farm
local T2=MakeTab("Farm")
T2:AddSection("Level Farm")
T2:AddToggle({Name="Auto Farm",Default=F.AutoFarm,Callback=function(v) F.AutoFarm=v end})
T2:AddToggle({Name="Auto Quest",Default=F.AutoQuest,Callback=function(v) F.AutoQuest=v end})
T2:AddToggle({Name="Fast Attack",Default=F.FastAttack,Callback=function(v) F.FastAttack=v end})
T2:AddToggle({Name="Kill Aura",Default=F.KillAura,Callback=function(v) F.KillAura=v end})
T2:AddSlider({Name="Kill Aura Range",Min=5,Max=50,Default=C.KillAuraRange,ValueName="m",Callback=function(v) C.KillAuraRange=v end})
T2:AddToggle({Name="Bring Mobs",Default=F.BringMob,Callback=function(v) F.BringMob=v end})
T2:AddSlider({Name="Bring Range",Min=10,Max=60,Default=C.BringMobRange,ValueName="m",Callback=function(v) C.BringMobRange=v end})
T2:AddSection("V10 Farm All")
T2:AddToggle({Name="Auto Farm All (Master)",Default=F.FarmAll,Callback=function(v) F.FarmAll=v end})
T2:AddLabel("Auto switches quests, farms optimally")
T2:AddSection("Boss")
T2:AddToggle({Name="Auto Boss Farm",Default=F.AutoBossFarm,Callback=function(v) F.AutoBossFarm=v end})
T2:AddSection("Mastery")
T2:AddToggle({Name="Auto Mastery (Fruit)",Default=F.AutoMasteryFruit,Callback=function(v) F.AutoMasteryFruit=v end})
T2:AddToggle({Name="Auto Mastery (Sword)",Default=F.AutoMasterySword,Callback=function(v) F.AutoMasterySword=v end})
T2:AddSection("Stats")
T2:AddToggle({Name="Auto Stats",Default=F.AutoStats,Callback=function(v) F.AutoStats=v end})
T2:AddDropdown({Name="Stat",Default=C.StatType,Options={"Melee","Defense","Sword","Gun","Blox Fruit"},Callback=function(v) C.StatType=v end})
T2:AddSection("Smart Stats")
T2:AddToggle({Name="Smart Stat Distribution",Default=F.SmartStatDist,Callback=function(v) F.SmartStatDist=v end})
T2:AddDropdown({Name="Priority 1",Default=C.SmartStat1,Options={"Melee","Defense","Sword","Gun","Blox Fruit"},Callback=function(v) C.SmartStat1=v end})
T2:AddDropdown({Name="Priority 2",Default=C.SmartStat2,Options={"Melee","Defense","Sword","Gun","Blox Fruit"},Callback=function(v) C.SmartStat2=v end})
T2:AddDropdown({Name="Priority 3",Default=C.SmartStat3,Options={"Melee","Defense","Sword","Gun","Blox Fruit"},Callback=function(v) C.SmartStat3=v end})
T2:AddSlider({Name="Primary Split %",Min=10,Max=90,Default=C.SmartStatSplit,ValueName="%",Callback=function(v) C.SmartStatSplit=v end})
T2:AddSection("Bone Farm")
T2:AddToggle({Name="Auto Farm Bones",Default=F.AutoFarmBones,Callback=function(v) F.AutoFarmBones=v end})
T2:AddLabel("Collects bone drops and kills Skeleton/Mummy mobs")
T2:AddSection("Candy Farm")
T2:AddToggle({Name="Auto Farm Candy",Default=F.AutoFarmCandy,Callback=function(v) F.AutoFarmCandy=v end})
T2:AddLabel("Collects candy drops and kills Cookie/Candy mobs")
T2:AddSection("Tree Farm")
T2:AddToggle({Name="Auto Tree Destroyer",Default=F.AutoTreeDestroyer,Callback=function(v) F.AutoTreeDestroyer=v end})
T2:AddSlider({Name="Tree Farm Range",Min=50,Max=500,Default=C.TreeFarmRange,ValueName="m",Callback=function(v) C.TreeFarmRange=v end})
T2:AddLabel("Destroys trees and collects wood drops")
T2:AddSection("Sea Progression")
T2:AddToggle({Name="Auto Second Sea (Lv 700+)",Default=F.AutoSecondSea,Callback=function(v) F.AutoSecondSea=v end})
T2:AddLabel("Auto accepts Military Officer quest and farms to Sea 2")
T2:AddToggle({Name="Auto Third Sea (Lv 1500+)",Default=F.AutoThirdSea,Callback=function(v) F.AutoThirdSea=v end})
T2:AddLabel("Auto talks to Dead Receiver/Alchemist for Sea 3")

---- TAB 3: Fruits
local T3=MakeTab("Fruits")
T3:AddSection("Scanner")
T3:AddToggle({Name="Auto Find & Collect",Default=F.AutoFindFruits,Callback=function(v) F.AutoFindFruits=v end})
T3:AddToggle({Name="Auto Store",Default=F.AutoStoreFruits,Callback=function(v) F.AutoStoreFruits=v end})
T3:AddDropdown({Name="Min Rarity",Default=C.MinFruitRarity,Options={"Common","Uncommon","Rare","Legendary","Mythical"},Callback=function(v) C.MinFruitRarity=v end})
T3:AddButton({Name="Scan Now",Callback=function()
    local fr=ScanFruits(10000)
    Notify("Scan","Found "..#fr.." fruits",5)
    for i=1,math.min(5,#fr) do Notify("Fruit",fr[i].Name.." ["..(fr[i].Data and fr[i].Data.R or "?").."] "..math.floor(fr[i].Dist).."m",5) end
end})
T3:AddSection("Dealer")
T3:AddToggle({Name="Fruit Sniper (Legendary+)",Default=F.FruitSniper,Callback=function(v) F.FruitSniper=v end})
T3:AddToggle({Name="Auto Dealer Roll",Default=F.AutoDealerRoll,Callback=function(v) F.AutoDealerRoll=v end})
T3:AddButton({Name="Buy Random Fruit",Callback=function() TpTo(CFrame.new(-1250,8,-1170).Position,400); task.wait(1); pcall(function() CommF("BuyRandomFruit") end) end})
T3:AddSection("Rain")
T3:AddDropdown({Name="Rain Type",Default=F.FruitRainType,Options={"All","Rare","Legendary"},Callback=function(v) F.FruitRainType=v end})
T3:AddToggle({Name="Visual Fruit Rain",Default=F.FruitRain,Callback=function(v) F.FruitRain=v; if not v then for _,p in ipairs(RainParts) do if p and p.Parent then p:Destroy() end end; RainParts={} end end})

---- TAB 4: Raid
local T4=MakeTab("Raid")
T4:AddSection("Raid System")
T4:AddToggle({Name="Auto Raid",Default=F.AutoRaid,Callback=function(v) F.AutoRaid=v end})
T4:AddToggle({Name="Auto Start Raid",Default=F.RaidAutoStart,Callback=function(v) F.RaidAutoStart=v end})
T4:AddToggle({Name="Auto Rotate Rooms",Default=F.RaidAutoRotate,Callback=function(v) F.RaidAutoRotate=v end})
T4:AddDropdown({Name="Raid Type",Default=C.RaidChip,Options={"Flame","Ice","Quake","Light","Dark","Magma","Rumble","Spider","Buddha","Phoenix","Dough"},Callback=function(v) C.RaidChip=v; RaidState.ChipBought=false end})
T4:AddButton({Name="Buy Raid Chip",Callback=function()
    Notify("Raid", "Buying "..C.RaidChip.." chip...", 3)
    BuyRaidChip(C.RaidChip)
end})

---- TAB 5: CDK
local T5=MakeTab("CDK")
T5:AddSection("Cursed Dual Katana")
T5:AddToggle({Name="Auto CDK (Master)",Default=F.AutoCDK,Callback=function(v) F.AutoCDK=v end})
T5:AddToggle({Name="Auto Demonic Wisps",Default=F.CDKAutoWisps,Callback=function(v) F.CDKAutoWisps=v end})
T5:AddToggle({Name="Auto Elite Enemies",Default=F.CDKAutoElites,Callback=function(v) F.CDKAutoElites=v end})
T5:AddToggle({Name="Auto Soul Reaper",Default=F.CDKAutoSoulReaper,Callback=function(v) F.CDKAutoSoulReaper=v end})
T5:AddToggle({Name="Auto Scroll Finder",Default=F.CDKAutoScrolls,Callback=function(v) F.CDKAutoScrolls=v end})
T5:AddSection("Progress")
T5:AddLabel("Wisps: 0 | Elites: 0")
T5:AddButton({Name="Check CDK Progress",Callback=function()
    GetCDKProgress()
    Notify("CDK Progress", "Wisps: "..CDKState.Wisps.."/30 | Elites: "..CDKState.Elites, 5)
end})

---- TAB 6: Bounty
local T6=MakeTab("Bounty")
T6:AddSection("Bounty Hunter")
T6:AddToggle({Name="Auto Bounty Hunt",Default=F.BountyHunt,Callback=function(v) F.BountyHunt=v end})
T6:AddToggle({Name="Auto Attack Target",Default=F.BountyAutoAttack,Callback=function(v) F.BountyAutoAttack=v end})
T6:AddSlider({Name="Target Min Bounty",Min=100000,Max=10000000,Default=C.BountyTargetBounty,ValueName="",Callback=function(v) C.BountyTargetBounty=v end})
T6:AddSection("V10 Revenge")
T6:AddToggle({Name="Auto PvP Revenge",Default=F.AutoRevenge,Callback=function(v) F.AutoRevenge=v end})
T6:AddLabel("Fights back when high bounty players attack")
T6:AddSection("Status")
T6:AddSection("PvP Tools")
T6:AddToggle({Name="Aimbot Camera Lock",Default=F.AimbotEnabled,Callback=function(v) F.AimbotEnabled=v end})
T6:AddSlider({Name="Aimbot FOV",Min=50,Max=500,Default=C.AimbotFOV,ValueName="px",Callback=function(v) C.AimbotFOV=v end})
T6:AddLabel("Locks camera to nearest enemy within FOV")
T6:AddSection("Targets")
T6:AddButton({Name="Scan Bounty Targets",Callback=function()
    local targets = FindBountyTargets()
    Notify("Bounty", "Found "..#targets.." targets", 3)
    for i=1,math.min(3,#targets) do
        Notify("Target "..i, targets[i].Player.Name.." ["..targets[i].Bounty.." bounty] "..math.floor(targets[i].Dist).."m", 5)
    end
end})

---- TAB 7: Combat (NEW in v10)
local T7=MakeTab("Combat")
T7:AddSection("V10 Ultra Combat")
T7:AddToggle({Name="Auto Buso Haki",Default=F.AutoBusoHaki,Callback=function(v) F.AutoBusoHaki=v end})
T7:AddToggle({Name="Auto Ken Haki",Default=F.AutoKenHaki,Callback=function(v) F.AutoKenHaki=v end})
T7:AddToggle({Name="Ultra Combo Mode",Default=F.UltraComboMode,Callback=function(v) F.UltraComboMode=v end})
T7:AddLabel("Sword > Fruit > Gun > Fighting > Best rotation")
T7:AddSection("Prediction & Dodge")
T7:AddToggle({Name="Auto Dodge",Default=F.AutoDodge,Callback=function(v) F.AutoDodge=v end})
T7:AddSlider({Name="Dodge Range",Min=20,Max=150,Default=C.DodgeRange,ValueName="m",Callback=function(v) C.DodgeRange=v end})
T7:AddToggle({Name="Prediction Combat",Default=F.PredictionCombat,Callback=function(v) F.PredictionCombat=v end})
T7:AddLabel("Leads targets based on velocity")
T7:AddSection("Combo")
T7:AddToggle({Name="Combo Attack",Default=F.ComboAttack,Callback=function(v) F.ComboAttack=v end})
T7:AddLabel("Sword > Fruit > Gun rotation")
T7:AddSection("Safe Zone")
T7:AddToggle({Name="Smart Safe Zone",Default=F.SmartSafeZone,Callback=function(v) F.SmartSafeZone=v end})
T7:AddLabel("Evades high bounty players and low HP")
---- TAB 8: Weapons
local T8=MakeTab("Weapons")
T8:AddSection("GodHuman")
T8:AddToggle({Name="Auto GodHuman",Default=F.AutoGodHuman,Callback=function(v) F.AutoGodHuman=v end})
T8:AddSection("V10 Fighting Style Quests")
T8:AddToggle({Name="Auto Dragon Talon",Default=F.AutoDragonTalon,Callback=function(v) F.AutoDragonTalon=v end})
T8:AddToggle({Name="Auto Death Step",Default=F.AutoDeathStep,Callback=function(v) F.AutoDeathStep=v end})
T8:AddToggle({Name="Auto Shark Karate",Default=F.AutoSharkKarate,Callback=function(v) F.AutoSharkKarate=v end})
T8:AddToggle({Name="Auto Electric Claw",Default=F.AutoElectricClaw,Callback=function(v) F.AutoElectricClaw=v end})
T8:AddSection("Soul Guitar")
T8:AddToggle({Name="Auto Soul Guitar",Default=F.AutoSoulGuitar,Callback=function(v) F.AutoSoulGuitar=v end})
T8:AddSection("Dark Blade")
T8:AddToggle({Name="Auto Dark Blade V1/V2/V3",Default=F.AutoDarkBlade,Callback=function(v) F.AutoDarkBlade=v end})
T8:AddSection("Shark Anchor")
T8:AddToggle({Name="Auto Shark Anchor",Default=F.AutoSharkAnchor,Callback=function(v) F.AutoSharkAnchor=v end})
T8:AddSection("Canvander")
T8:AddToggle({Name="Auto Canvander",Default=F.AutoCanvander,Callback=function(v) F.AutoCanvander=v end})
T8:AddSection("Legend Sword")
T8:AddToggle({Name="Auto Legend Sword",Default=F.AutoLegendSword,Callback=function(v) F.AutoLegendSword=v end})
T8:AddSection("Tusk V4")
T8:AddToggle({Name="Auto Tusk V4",Default=F.AutoTuskV4,Callback=function(v) F.AutoTuskV4=v end})
T8:AddSection("Legendary Swords")
T8:AddToggle({Name="Auto Buy Legendary Swords",Default=F.AutoLegendarySword,Callback=function(v) F.AutoLegendarySword=v end})
T8:AddLabel("Buys Saber, Shisui, Wando, Sadie, Enma, Yama, Tushita")
T8:AddButton({Name="Check Weapon Inventory",Callback=function()
    local weapons = {}
    if HasWeapon("GodHuman") then table.insert(weapons, "GodHuman") end
    if HasWeapon("Soul Guitar") then table.insert(weapons, "Soul Guitar") end
    if HasWeapon("Dark Blade") then table.insert(weapons, "Dark Blade") end
    if HasWeapon("Shark Anchor") then table.insert(weapons, "Shark Anchor") end
    if HasWeapon("Canvander") then table.insert(weapons, "Canvander") end
    if HasWeapon("CDK") or HasWeapon("Cursed Dual Katana") then table.insert(weapons, "CDK") end
    if #weapons > 0 then Notify("Weapons", table.concat(weapons, ", "), 5)
    else Notify("Weapons", "No special weapons found", 3) end
end})

---- TAB 9: Sea Events
local T9=MakeTab("Sea Events")
T9:AddSection("Events")
T9:AddToggle({Name="Auto Mirage Island",Default=F.AutoMirage,Callback=function(v) F.AutoMirage=v end})
T9:AddToggle({Name="Auto Sea Beast",Default=F.AutoSeaBeast,Callback=function(v) F.AutoSeaBeast=v end})
T9:AddToggle({Name="Auto Race V4",Default=F.AutoRaceV4,Callback=function(v) F.AutoRaceV4=v end})
T9:AddToggle({Name="Auto Trial",Default=F.AutoTrial,Callback=function(v) F.AutoTrial=v end})
T9:AddSection("V10 Dimensions")
T9:AddToggle({Name="Auto Frozen Dimension",Default=F.AutoFrozenDimension,Callback=function(v) F.AutoFrozenDimension=v end})
T9:AddToggle({Name="Auto Mirror Dimension",Default=F.AutoMirrorDimension,Callback=function(v) F.AutoMirrorDimension=v end})
T9:AddSection("Factory")
T9:AddToggle({Name="Auto Factory Event",Default=F.AutoFactoryEvent,Callback=function(v) F.AutoFactoryEvent=v end})
T9:AddLabel("Sea 2: Kills factory mobs + Core Brain")
T9:AddSection("V10 Dough King")
T9:AddToggle({Name="Auto Dough King",Default=F.AutoDoughKing,Callback=function(v) F.AutoDoughKing=v end})
T9:AddLabel("Auto defeats Dough King boss")
T9:AddSection("Law Raid")
T9:AddToggle({Name="Auto Law Raid",Default=F.AutoLawRaid,Callback=function(v) F.AutoLawRaid=v end})
T9:AddLabel("Auto fights Law boss in sea events")
T9:AddSection("Prehistoric Island")
T9:AddToggle({Name="Auto Prehistoric Island",Default=F.AutoPrehistoricIsland,Callback=function(v) F.AutoPrehistoricIsland=v end})
T9:AddLabel("Auto clears Prehistoric Island mobs")
T9:AddSection("Boat")
T9:AddToggle({Name="Boat Speed Boost",Default=F.BoatSpeedEnabled,Callback=function(v) F.BoatSpeedEnabled=v end})
T9:AddSlider({Name="Boat Speed",Min=50,Max=500,Default=C.BoatSpeed,ValueName="spd",Callback=function(v) C.BoatSpeed=v end})
T9:AddButton({Name="Spawn Boat",Callback=function() SelectBoat(C.SelectBoat) end})
T9:AddDropdown({Name="Boat Type",Default=C.SelectBoat,Options=Boats,Callback=function(v) C.SelectBoat=v end})

---- TAB 10: Race V4
local T10=MakeTab("Race V4")
T10:AddSection("Race V4 Fragments")
T10:AddToggle({Name="Auto Collect Fragments",Default=F.AutoCollectFragments,Callback=function(v) F.AutoCollectFragments=v end})
T10:AddButton({Name="Collect Race Fragments Now",Callback=function()
    CollectRaceFragments()
    Notify("Race V4", "Fragment collection complete!", 3)
end})
T10:AddSection("V4 Activation")
T10:AddToggle({Name="Auto Race V4",Default=F.AutoRaceV4,Callback=function(v) F.AutoRaceV4=v end})
T10:AddToggle({Name="Auto Trial",Default=F.AutoTrial,Callback=function(v) F.AutoTrial=v end})
T10:AddLabel("Auto activates V4 and starts trials")
T10:AddSection("Race Status")
T10:AddButton({Name="Check Race",Callback=function()
    Notify("Race", "Your race: "..GetRace(), 5)
end})
T10:AddSection("Ghoul Race")
T10:AddToggle({Name="Auto Ghoul Race",Default=F.AutoGhoulRace,Callback=function(v) F.AutoGhoulRace=v end})
T10:AddLabel("Farms ectoplasm for Ghoul race unlock")
T10:AddSection("Shop")
T10:AddToggle({Name="Auto Buy from Shops",Default=F.AutoBuyShop,Callback=function(v) F.AutoBuyShop=v end})
T10:AddButton({Name="Buy Race Enhancement",Callback=function()
    BuyFromShop("Race", "Enhancement")
    Notify("Shop", "Attempting to buy race enhancement...", 3)
end})

---- TAB 11: Farming
local T11=MakeTab("Farming")
T11:AddSection("Chest Farm")
T11:AddToggle({Name="Auto Chest Farm",Default=F.AutoChestFarm,Callback=function(v) F.AutoChestFarm=v end})
T11:AddSlider({Name="Chest Range",Min=50,Max=500,Default=C.ChestFarmRange,ValueName="m",Callback=function(v) C.ChestFarmRange=v end})
T11:AddSection("Materials Farm")
T11:AddToggle({Name="Auto Materials Farm",Default=F.AutoMaterialsFarm,Callback=function(v) F.AutoMaterialsFarm=v end})
T11:AddDropdown({Name="Target Material",Default=C.MaterialsTarget,Options={"Ectoplasm","Magma Ore","Leather","Scrap Metal","Angel Wings","Vampire Fang","Yeti Fur","Mini Tusk","Dragon Scale","Mystic Droplet","Bones","Dark Cloth","Rare Metal","Ghost Fragment","Azure Embers","Leviathan Scale","Shark Tooth","Pearl"},Callback=function(v) C.MaterialsTarget=v end})
T11:AddSection("V10 Material Detector")
T11:AddToggle({Name="Material Detector",Default=F.AutoMaterialDetector,Callback=function(v) F.AutoMaterialDetector=v end})
T11:AddLabel("Scans nearby for material mobs")
T11:AddSection("Haki Training")
T11:AddToggle({Name="Auto Buso Training",Default=F.AutoHakiBuso,Callback=function(v) F.AutoHakiBuso=v end})
T11:AddSlider({Name="Mob Range",Min=10,Max=100,Default=C.HakiBusoMobs,ValueName="m",Callback=function(v) C.HakiBusoMobs=v end})
T11:AddToggle({Name="Auto Ken Training",Default=F.AutoHakiKen,Callback=function(v) F.AutoHakiKen=v end})
T11:AddSlider({Name="Stay Distance",Min=5,Max=50,Default=C.HakiKenHP,ValueName="m",Callback=function(v) C.HakiKenHP=v end})
T11:AddButton({Name="Activate All Haki Now",Callback=function()
    pcall(function() CommF("BusoHaki"); CommF("ActivateHaki", "Buso"); CommF("ToggleHaki", "Buso") end)
    pcall(function() CommF("KenHaki"); CommF("ActivateHaki", "Ken"); CommF("ToggleHaki", "Ken") end)
    Notify("Haki", "Activating Buso + Ken Haki...", 3)
end})
T11:AddSection("Auto Awaken Fruit")
T11:AddToggle({Name="Auto Awaken Fruit",Default=F.AutoAwakenFruit,Callback=function(v) F.AutoAwakenFruit=v end})
T11:AddLabel("Finds awakening expert and upgrades abilities")
T11:AddSection("V10 Bard Quest")
T11:AddToggle({Name="Auto Bard Quest",Default=F.AutoBardQuest,Callback=function(v) F.AutoBardQuest=v end})
T11:AddLabel("Auto completes Bard quests in Sea 3")
T11:AddSection("Auto Mastery 600")
T11:AddToggle({Name="Auto Farm 600 Mastery",Default=F.AutoMastery600,Callback=function(v) F.AutoMastery600=v end})
T11:AddLabel("Farms mobs until equipped tool reaches 600 mastery")
T11:AddSection("Auto Craft Items")
T11:AddToggle({Name="Auto Craft Items",Default=F.AutoCraftItems,Callback=function(v) F.AutoCraftItems=v end})
T11:AddLabel("Auto crafts forgeable items when materials are available")
T11:AddSection("Auto Collect Berries")
T11:AddToggle({Name="Auto Collect Berries",Default=F.AutoCollectBerries,Callback=function(v) F.AutoCollectBerries=v end})
T11:AddLabel("Collects berries, embers, and eggs from the map")

---- TAB 12: ESP
local T12=MakeTab("ESP")
T12:AddSection("ESP")
T12:AddToggle({Name="Player ESP",Default=F.ESPPlayers,Callback=function(v) F.ESPPlayers=v end})
T12:AddToggle({Name="Fruit ESP",Default=F.ESPFruits,Callback=function(v) F.ESPFruits=v end})
T12:AddToggle({Name="Chest ESP",Default=F.ESPChests,Callback=function(v) F.ESPChests=v end})
T12:AddToggle({Name="Flower ESP",Default=F.ESPFlowers,Callback=function(v) F.ESPFlowers=v end})
T12:AddToggle({Name="Boss ESP",Default=F.ESPBosses,Callback=function(v) F.ESPBosses=v end})
T12:AddToggle({Name="Sea Beast ESP",Default=F.ESPSeaBeast,Callback=function(v) F.ESPSeaBeast=v end})
T12:AddToggle({Name="Border ESP",Default=F.ESPBorders,Callback=function(v) F.ESPBorders=v end})
T12:AddButton({Name="Clear All ESP",Callback=function() ClearESP() end})
T12:AddSection("Player Highlight")
T12:AddToggle({Name="Player Highlight",Default=F.PlayerHighlight,Callback=function(v) F.PlayerHighlight=v end})
T12:AddLabel("Team-colored highlights through walls")

---- TAB 13: Fishing (NEW in v11)
local T13=MakeTab("Fishing")
T13:AddSection("Auto Fishing")
T13:AddToggle({Name="Auto Fish",Default=F.AutoFishing,Callback=function(v) F.AutoFishing=v end})
T13:AddDropdown({Name="Fishing Rod",Default=C.AutoFishingRod,Options=FishingRods,Callback=function(v) C.AutoFishingRod=v end})
T13:AddDropdown({Name="Bait Type",Default=C.AutoFishingBait,Options=BaitTypes,Callback=function(v) C.AutoFishingBait=v end})
T13:AddButton({Name="Fish Now",Callback=function() AutoFish() end})
T13:AddSection("Fish Shop")
T13:AddButton({Name="Sell All Fish",Callback=function()
    pcall(function() CommF("SellFish"); CommF("TradeFish") end)
    Notify("Fish", "Selling all fish...", 3)
end})
T13:AddButton({Name="Buy Fishing Quest",Callback=function()
    pcall(function() CommF("FishingQuest"); CommF("AcceptFishingQuest") end)
    Notify("Fish", "Accepting fishing quest...", 3)
end})
T13:AddSection("Sunken Chest")
T13:AddButton({Name="Find Sunken Chest",Callback=function()
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:find("Sunken") or obj.Name:find("Treasure")) then
            local pp = obj:FindFirstChildOfClass("ProximityPrompt")
            if pp then
                local h = HRP()
                if h then h.CFrame = obj.Position + Vector3.new(0, 5, 0) end
                task.wait(1)
                pcall(function() fireproximityprompt(pp) end)
                Notify("Fish", "Found sunken chest!", 3)
                return
            end
        end
    end
    Notify("Fish", "No sunken chest found nearby", 3)
end})

---- TAB 14: Trading (NEW in v11)
local T14=MakeTab("Trading")
T14:AddSection("Auto Trade")
T14:AddToggle({Name="Auto Accept Trade",Default=F.AutoTrade,Callback=function(v) F.AutoTrade=v end})
T14:AddToggle({Name="Freeze Trade Window",Default=F.AutoFreezeTrade,Callback=function(v) F.AutoFreezeTrade=v end})
T14:AddButton({Name="Accept Trade Now",Callback=function() AutoAcceptTrade() end})
T14:AddButton({Name="Freeze Trade Now",Callback=function() FreezeTrade() end})
T14:AddSection("Value Calculator")
T14:AddButton({Name="Scan Trade Values",Callback=function()
    local gui = LP.PlayerGui:FindFirstChild("TradeGui") or LP.PlayerGui:FindFirstChild("TradingGui")
    if gui then
        for _, item in ipairs(gui:GetDescendants()) do
            if item:IsA("TextLabel") and item.Text ~= "" then
                local val = GetFruitValue(item.Text)
                if val > 0 then
                    Notify("Trade Value", item.Text..": $"..val, 5)
                end
            end
        end
    else
        Notify("Trade", "No trade window open", 3)
    end
end})
T14:AddSection("Fruit Values")
T14:AddLabel("Dragon: $35M | Leopard: $30M | Spirit: $25M")
T14:AddLabel("Dough: $20M | Buddha: $15M | Venom: $12M")
T14:AddLabel("Control: $10M | T-Rex: $8M | Mammoth: $7M")
T14:AddLabel("Shadow: $6M | Blizzard: $5M | Gravity: $4M")

---- TAB 15: Movement (NEW in v11)
local T15=MakeTab("Movement")
T15:AddSection("NoClip")
T15:AddToggle({Name="NoClip",Default=F.NoclipEnabled,Callback=function(v) F.NoclipEnabled=v end})
T15:AddLabel("Walk through walls and objects")
T15:AddSection("Speed & Jump")
T15:AddSlider({Name="Walk Speed",Min=16,Max=500,Default=C.WalkSpeed,Callback=function(v) C.WalkSpeed=v; ApplySpeed() end})
T15:AddSlider({Name="Jump Power",Min=50,Max=500,Default=C.JumpPower,Callback=function(v) C.JumpPower=v; ApplySpeed() end})
T15:AddSlider({Name="Dash Length",Min=10,Max=100,Default=C.DashLength,Callback=function(v) C.DashLength=v; ApplyDash() end})
T15:AddButton({Name="Reset Speed",Callback=function()
    C.WalkSpeed=16; C.JumpPower=50
    local h=Hum(); if h then h.WalkSpeed=16; h.JumpPower=50 end
    Notify("Movement", "Speed reset to default", 3)
end})
T15:AddSection("Infinite")
T15:AddToggle({Name="Infinite Jump",Default=F.InfiniteJump,Callback=function(v) F.InfiniteJump=v end})
T15:AddToggle({Name="Infinite Energy",Default=F.InfiniteEnergy,Callback=function(v) F.InfiniteEnergy=v end})
T15:AddToggle({Name="Infinite Soru",Default=F.InfiniteSoru,Callback=function(v) F.InfiniteSoru=v end})
T15:AddSection("Fly")
T15:AddToggle({Name="Fly (WASD+Space+Shift)",Default=F.Fly,Callback=function(v) F.Fly=v end})
T15:AddSlider({Name="Fly Speed",Min=20,Max=200,Default=C.FlySpeed,Callback=function(v) C.FlySpeed=v end})
T15:AddSection("V12 Movement")
T15:AddToggle({Name="No Stun",Default=F.NoStunEnabled,Callback=function(v) F.NoStunEnabled=v end})
T15:AddLabel("Prevents stun lock by resetting Stun value")
T15:AddToggle({Name="Auto Active V3",Default=F.AutoActiveV3,Callback=function(v) F.AutoActiveV3=v end})
T15:AddLabel("Auto activates V3 ability every 5s")
T15:AddToggle({Name="Auto Active V4",Default=F.AutoActiveV4Full,Callback=function(v) F.AutoActiveV4Full=v end})
T15:AddLabel("Auto activates V4 awakening every 5s")

---- TAB 16: Haki Training (NEW in v11)
local T16=MakeTab("Haki Training")
T16:AddSection("Buso Haki")
T16:AddToggle({Name="Auto Buso Training",Default=F.AutoHakiBuso,Callback=function(v) F.AutoHakiBuso=v end})
T16:AddSlider({Name="Mob Range",Min=10,Max=100,Default=C.HakiBusoMobs,ValueName="m",Callback=function(v) C.HakiBusoMobs=v end})
T16:AddToggle({Name="Auto Ken Training",Default=F.AutoHakiKen,Callback=function(v) F.AutoHakiKen=v end})
T16:AddSlider({Name="Stay Distance",Min=5,Max=50,Default=C.HakiKenHP,ValueName="m",Callback=function(v) C.HakiKenHP=v end})
T16:AddButton({Name="Activate All Haki Now",Callback=function()
    pcall(function() CommF("BusoHaki"); CommF("ActivateHaki", "Buso"); CommF("ToggleHaki", "Buso") end)
    pcall(function() CommF("KenHaki"); CommF("ActivateHaki", "Ken"); CommF("ToggleHaki", "Ken") end)
    Notify("Haki", "Activating Buso + Ken Haki...", 3)
end})
T16:AddSection("Observation Haki")
T16:AddToggle({Name="Auto Observation Haki Farm",Default=F.AutoObservationHaki,Callback=function(v) F.AutoObservationHaki=v end})
T16:AddLabel("Stays near mobs to train Observation Haki")
T16:AddSection("Buso Colors")
T16:AddToggle({Name="Auto Buy Buso Colors",Default=F.AutoBuyBusoColors,Callback=function(v) F.AutoBuyBusoColors=v end})
T16:AddLabel("Buys colors from Barista Cousin NPC")

---- TAB 17: Config
local T17=MakeTab("Config")
T17:AddSection("Save / Load")
T17:AddButton({Name="Save Config",Callback=function() SaveConfig() end})
T17:AddButton({Name="Load Config",Callback=function() LoadConfig() end})
T17:AddButton({Name="Delete Config",Callback=function() DeleteConfig() end})
T17:AddSection("Export / Import")
T17:AddButton({Name="Export Config to Clipboard",Callback=function()
    EnsureFolder()
    if EXP.readfile and EXP.isfile then
        pcall(function()
            local path = C.ConfigFolder.."/"..C.ConfigFile
            if isfile(path) then Clip(readfile(path)); Notify("Config", "Exported to clipboard!", 3) end
        end)
    end
end})
T17:AddButton({Name="Reset All Settings",Callback=function()
    for k,v in pairs(F) do if type(v)=="boolean" then F[k]=false end end
    C.WalkSpeed=16; C.JumpPower=50; C.SafeHP=25
    local h=Hum(); if h then h.WalkSpeed=16; h.JumpPower=50 end
    Notify("Config", "All settings reset!", 3)
end})
T17:AddSection("Webhook")
T17:AddButton({Name="Set Webhook URL",Callback=function()
    Notify("Webhook", "Paste your Discord webhook URL in the console", 5)
end})
T17:AddToggle({Name="Anti-AFK",Default=F.AntiAFK,Callback=function(v) F.AntiAFK=v end})
T17:AddSection("UI Settings")
T17:AddSlider({Name="UI Scale",Min=50,Max=150,Default=100,ValueName="%",Callback=function(v)
    C.UIScale = v / 100
    pcall(function()
        main.Size = UDim2.new(0, math.floor(800 * C.UIScale), 0, math.floor(600 * C.UIScale))
        main.Position = UDim2.new(0.5, -math.floor(400 * C.UIScale), 0.5, -math.floor(300 * C.UIScale))
    end)
end})
T17:AddSection("Tween Safety")
T17:AddToggle({Name="Safe Tween",Default=F.SafeTween,Callback=function(v) F.SafeTween=v end})
T17:AddLabel("Resets stuck tweens after 5 seconds")
T17:AddButton({Name="Stop Tween Now",Callback=function()
    CancelMove()
    Notify("Tween", "Active tween stopped!", 3)
end})
T17:AddSection("Notifications")
T17:AddToggle({Name="Disable Notifications",Default=F.DisableNotify,Callback=function(v) F.DisableNotify=v end})
T17:AddLabel("Silences all notifications from the hub")
T17:AddSection("Anti-Stuck")
T17:AddToggle({Name="Anti-Stuck (Respawn)",Default=F.AntiStuck,Callback=function(v) F.AntiStuck=v end})
T17:AddLabel("Respawns character if not moving for 10 seconds")
T17:AddSection("Performance")
T17:AddToggle({Name="FPS Limiter",Default=F.FPSLimit,Callback=function(v) F.FPSLimit=v end})
T17:AddSlider({Name="Max FPS",Min=30,Max=240,Default=C.MaxFPS,ValueName="FPS",Callback=function(v) C.MaxFPS=v end})
T17:AddToggle({Name="FPS Boost Mode",Default=F.FPSBoost,Callback=function(v) F.FPSBoost=v end})
T17:AddLabel("Reduces shadows, fog, particles, effects")
T17:AddSection("Smart Features")
T17:AddToggle({Name="Smart Pathfinding",Default=F.SmartPathfind,Callback=function(v) F.SmartPathfind=v end})
T17:AddLabel("Uses PathfindingService for far targets")
T17:AddToggle({Name="Smart Server Hop",Default=F.SmartServerHop,Callback=function(v) F.SmartServerHop=v end})
T17:AddLabel("Checks for fruits/bosses before hopping")
T17:AddToggle({Name="Prediction Combat",Default=F.PredictionCombat,Callback=function(v) F.PredictionCombat=v end})
T17:AddLabel("Leads targets based on velocity")
T17:AddSection("Webhook Custom")
T17:AddButton({Name="Send Test Webhook",Callback=function()
    SendCustomWebhook("Apex Hub Test", "Test message from Apex Hub v11.0!
Executor: "..EXEC.."
Level: "..Lv().."
Sea: "..Sea(), 65280)
    Notify("Webhook", "Test webhook sent!", 3)
end})
T17:AddButton({Name="Send Fruit Alert",Callback=function()
    SendCustomWebhook("Fruit Found!", "A fruit was found on the map!
Check ESP for location.", 16711680)
    Notify("Webhook", "Fruit alert webhook sent!", 3)
end})
T17:AddSection("Keybinds")
T17:AddLabel("RightShift: Toggle UI visibility")
T17:AddLabel("Anti-Detection: Jitter + Randomized delays active")

---- TAB 18: Anti-AC + Emergency (merged) (NEW in v10)
local T18=MakeTab("Anti-AC + Emergency")
T18:AddSection("Anti-Cheat Bypass")
T18:AddLabel("7-Layer AC Bypass Active (v10)")
T18:AddLabel("Layer 1: Namecall hook (block AC remotes)")
T18:AddLabel("Layer 2: Velocity spoofing")
T18:AddLabel("Layer 3: Position jitter")
T18:AddLabel("Layer 4: HipHeight lock")
T18:AddLabel("Layer 5: Death delay randomizer")
T18:AddLabel("Layer 6: AssemblyLinearVelocity limiter")
T18:AddLabel("Layer 7: Fake position on __index")
T18:AddSection("V10 Anti-Detection")
T18:AddToggle({Name="Advanced Anti-Detection",Default=C.AntiDetection,Callback=function(v) C.AntiDetection=v end})
T18:AddLabel("Jitter offsets on movement")
T18:AddLabel("Randomized attack delays")
T18:AddLabel("Humanized movement patterns")
T18:AddSection("Detection Stats")
T18:AddLabel("AC Bypass: ACTIVE")
T18:AddLabel("Velocity Hook: ACTIVE")
T18:AddLabel("Position Hook: ACTIVE")
T18:AddLabel("Health Hook: ACTIVE")
T18:AddLabel("HipHeight Lock: ACTIVE")

---- Emergency Section in T18 (NEW in v10)
-- Emergency merged into T18
T18:AddSection("Emergency Controls")
T18:AddButton({Name="STOP ALL",Callback=function()
    for k,v in pairs(F) do if type(v)=="boolean" then F[k]=false end end
    for _,p in ipairs(RainParts) do if p and p.Parent then p:Destroy() end end
    RainParts={}; ClearESP(); CancelMove()
    if flyBV then flyBV:Destroy(); flyBV=nil end
    if flyBG then flyBG:Destroy(); flyBG=nil end
    for _,hl in pairs(Highlights) do if hl and hl.Parent then hl:Destroy() end end
    Highlights={}
    ClearCharCache()
    Notify("APEX HUB","ALL features disabled!",3)
end})
T18:AddSection("Memory Cleanup")
T18:AddButton({Name="Force Memory Cleanup",Callback=function()
    pcall(function() collectgarbage("collect") end)
    local removed = 0
    for obj, data in pairs(ESPObjects) do
        pcall(function() if data.BB then data.BB:Remove(); removed = removed + 1 end end)
        pcall(function() if data.Box then data.Box:Remove(); removed = removed + 1 end end)
        pcall(function() if data.Text then data.Text:Remove(); removed = removed + 1 end end)
        pcall(function() if data.Dist then data.Dist:Remove(); removed = removed + 1 end end)
        pcall(function() if data.HealthBar then data.HealthBar:Remove(); removed = removed + 1 end end)
        pcall(function() if data.HealthFill then data.HealthFill:Remove(); removed = removed + 1 end end)
        pcall(function() if data.Tracer then data.Tracer:Remove(); removed = removed + 1 end end)
        ESPObjects[obj] = nil
    end
    Notify("Memory", "Cleaned up "..removed.." objects", 3)
end})
T18:AddSection("V10 Stats")
T18:AddLabel("Version: 12.0 APEX COMPLETE")
T18:AddLabel("Tabs: 24")
T18:AddLabel("AC Layers: 7")
T18:AddLabel("Combat: Ultra Combo + Skill Chains + Super Attack")
T18:AddLabel("Anti-Detection: Jitter + FakePos")
T18:AddLabel("V12: Boss Drops, Quests, Dungeon, Race, Shop, Teleport")
T18:AddLabel("Memory Cleanups: 0")
---- ========== V12 NEW UI TABS ==========

---- TAB 19: Boss Drops (NEW in v12)
local T19=MakeTab("Boss Drops")
T19:AddSection("Sea 1 Weapons")
T19:AddToggle({Name="Auto Farm Saber (Saber Expert)",Default=F.AutoBossDropSaber,Callback=function(v) F.AutoBossDropSaber=v end})
T19:AddToggle({Name="Auto Farm Pole 1st Form (Thunder God)",Default=F.AutoBossDropPole,Callback=function(v) F.AutoBossDropPole=v end})
T19:AddToggle({Name="Auto Farm Shark Saw (The Saw)",Default=F.AutoBossDropSharkSaw,Callback=function(v) F.AutoBossDropSharkSaw=v end})
T19:AddToggle({Name="Auto Farm Trident (Fishman Lord)",Default=F.AutoBossDropTrident,Callback=function(v) F.AutoBossDropTrident=v end})
T19:AddToggle({Name="Auto Farm Refined Musket (Magma Admiral)",Default=F.AutoBossDropMusket,Callback=function(v) F.AutoBossDropMusket=v end})
T19:AddToggle({Name="Auto Farm Warden Sword (Chief Warden)",Default=F.AutoBossDropWardenSword,Callback=function(v) F.AutoBossDropWardenSword=v end})
T19:AddToggle({Name="Auto Farm Bazooka (Wysper)",Default=F.AutoBossDropBazooka,Callback=function(v) F.AutoBossDropBazooka=v end})
T19:AddSection("Sea 2 Weapons")
T19:AddToggle({Name="Auto Farm Acidum Rifle (Diamond)",Default=F.AutoBossDropAcidumRifle,Callback=function(v) F.AutoBossDropAcidumRifle=v end})
T19:AddToggle({Name="Auto Farm Jitte (Smoke Admiral)",Default=F.AutoBossDropJitte,Callback=function(v) F.AutoBossDropJitte=v end})
T19:AddToggle({Name="Auto Farm Hellfire Torch (Cursed Captain)",Default=F.AutoBossDropHellfireTorch,Callback=function(v) F.AutoBossDropHellfireTorch=v end})
T19:AddSection("Sea 3 Weapons")
T19:AddToggle({Name="Auto Farm Serpent Bow (Island Empress)",Default=F.AutoBossDropSerpentBow,Callback=function(v) F.AutoBossDropSerpentBow=v end})
T19:AddToggle({Name="Auto Farm Twin Hooks (Captain Elephant)",Default=F.AutoBossDropTwinHooks,Callback=function(v) F.AutoBossDropTwinHooks=v end})
T19:AddToggle({Name="Auto Farm Buddy Sword (Cake Queen)",Default=F.AutoBossDropBuddySword,Callback=function(v) F.AutoBossDropBuddySword=v end})
T19:AddToggle({Name="Auto Farm Dark Dagger (rip_indra)",Default=F.AutoBossDropDarkDagger,Callback=function(v) F.AutoBossDropDarkDagger=v end})
T19:AddSection("Status")
T19:AddButton({Name="Check Boss Weapons",Callback=function()
    local found = {}
    local allWeapons = {"Saber","Pole","Shark Saw","Trident","Refined Musket","Warden Sword","Bazooka","Acidum Rifle","Jitte","Hellfire Torch","Serpent Bow","Twin Hooks","Buddy Sword","Dark Dagger"}
    for _, w in ipairs(allWeapons) do
        if HasWeapon(w) then table.insert(found, w) end
    end
    if #found > 0 then Notify("Boss Drops", "Owned: "..table.concat(found, ", "), 5)
    else Notify("Boss Drops", "No boss drop weapons found", 3) end
end})

---- TAB 20: Boss Quests (NEW in v12)
local T20=MakeTab("Boss Quests")
T20:AddSection("Special Boss Farming")
T20:AddToggle({Name="Auto Dark Dagger (rip_indra)",Default=F.AutoDarkDaggerQuest,Callback=function(v) F.AutoDarkDaggerQuest=v end})
T20:AddLabel("Farm rip_indra True Form for Dark Dagger")
T20:AddToggle({Name="Auto Hallow Scythe (Soul Reaper)",Default=F.AutoHallowScytheQuest,Callback=function(v) F.AutoHallowScytheQuest=v end})
T20:AddLabel("Summon and defeat Soul Reaper for Hallow Scythe")
T20:AddToggle({Name="Auto Swan Glasses (Don Swan)",Default=F.AutoSwanGlassesQuest,Callback=function(v) F.AutoSwanGlassesQuest=v end})
T20:AddLabel("Defeat Don Swan for Swan Glasses")
T20:AddToggle({Name="Auto Greybeard (Whitebeard)",Default=F.AutoGreybeardQuest,Callback=function(v) F.AutoGreybeardQuest=v end})
T20:AddLabel("Defeat Greybeard/Whitebeard in Marine Ford")

---- TAB 21: Special Quests (NEW in v12)
local T21=MakeTab("Special Quests")
T21:AddSection("Citizen Quest")
T21:AddToggle({Name="Auto Citizen Quest",Default=F.AutoCitizenQuest,Callback=function(v) F.AutoCitizenQuest=v end})
T21:AddLabel("Find Citizen NPC and complete quest")
T21:AddSection("Rainbow Haki")
T21:AddToggle({Name="Auto Rainbow Haki",Default=F.AutoRainbowHaki,Callback=function(v) F.AutoRainbowHaki=v end})
T21:AddLabel("Collect flowers and buy Rainbow Haki")
T21:AddSection("Holy Torch")
T21:AddToggle({Name="Auto Holy Torch",Default=F.AutoHolyTorch,Callback=function(v) F.AutoHolyTorch=v end})
T21:AddLabel("Find and collect Holy Torches on the map")
T21:AddSection("Enhancement")
T21:AddToggle({Name="Auto Enhancement Color",Default=F.AutoEnhancementColor,Callback=function(v) F.AutoEnhancementColor=v end})
T21:AddLabel("Auto buy enhancement colors")
T21:AddSection("Dojo Training")
T21:AddToggle({Name="Auto Dojo",Default=F.AutoDojo,Callback=function(v) F.AutoDojo=v end})
T21:AddLabel("Find Dojo/Trainer NPC and complete training")

---- TAB 22: Dungeon (NEW in v12)
local T22=MakeTab("Dungeon")
T22:AddSection("Dungeon System")
T22:AddToggle({Name="Auto Dungeon (Full)",Default=F.AutoDungeonFull,Callback=function(v) F.AutoDungeonFull=v end})
T22:AddLabel("Auto select, join, start dungeon")
T22:AddLabel("Auto kill mobs and touch doors")
T22:AddLabel("Auto select reward and choose card")
T22:AddSection("Status")
T22:AddButton({Name="Check Dungeon Status",Callback=function()
    if DungeonState.InProgress then
        Notify("Dungeon", "Dungeon in progress! Room: "..DungeonState.Room, 3)
    else
        Notify("Dungeon", "No dungeon in progress", 3)
    end
end})

---- TAB 23: Teleport (NEW in v12)
local T23=MakeTab("Teleport")
T23:AddSection("Island Teleport")
T23:AddDropdown({Name="Select Island",Default=C.TeleportIsland,Options={"Starter Island","Marine Fortress","Jungle","Pirate Village","Desert","Frozen Village","Marine Ford","Prison","Magma Village","Sky Island","Underwater City","Colosseum","Hot and Cold","Cursed Ship","Haunted Castle","Turtle Island","Port Town","Green Zone","Factory","Graveyard","Usoapp Island","Forgotten Island","Hydra Island","Great Tree","Candy Island","Chocolate Island","Kitsune Island","Deep Sea"},Callback=function(v) C.TeleportIsland=v end})
T23:AddButton({Name="Teleport to Selected Island",Callback=function() TPToLocation(C.TeleportIsland) end})
T23:AddSection("Quick Teleport")
T23:AddButton({Name="TP to Jungle",Callback=function() TPToLocation("Jungle") end})
T23:AddButton({Name="TP to Marine Ford",Callback=function() TPToLocation("Marine Ford") end})
T23:AddButton({Name="TP to Prison",Callback=function() TPToLocation("Prison") end})
T23:AddButton({Name="TP to Hot and Cold",Callback=function() TPToLocation("Hot and Cold") end})
T23:AddButton({Name="TP to Cursed Ship",Callback=function() TPToLocation("Cursed Ship") end})
T23:AddButton({Name="TP to Haunted Castle",Callback=function() TPToLocation("Haunted Castle") end})
T23:AddButton({Name="TP to Turtle Island",Callback=function() TPToLocation("Turtle Island") end})
T23:AddButton({Name="TP to Deep Sea",Callback=function() TPToLocation("Deep Sea") end})
T23:AddButton({Name="TP to Kitsune Island",Callback=function() TPToLocation("Kitsune Island") end})
T23:AddButton({Name="TP to Sky Safe Zone",Callback=function() InstantTP(Vector3.new(0, 100, 0)); Notify("Teleport", "Teleported to sky safe zone!", 3) end})

---- TAB 24: Shop (NEW in v12)
local T24=MakeTab("Shop")
T24:AddSection("Fighting Styles")
T24:AddToggle({Name="Auto Buy All Fighting Styles",Default=F.AutoBuyFightingStyles,Callback=function(v) F.AutoBuyFightingStyles=v end})
T24:AddLabel("Black Leg, Fishman Karate, Electro, Dragon Breath")
T24:AddLabel("SuperHuman, Death Step, Sharkman Karate")
T24:AddLabel("Electric Claw, Dragon Talon, God Human, Sanguine Art")
T24:AddSection("Swords")
T24:AddToggle({Name="Auto Buy All Swords",Default=F.AutoBuySwords,Callback=function(v) F.AutoBuySwords=v end})
T24:AddLabel("Cutlass, Katana, Iron Mace, Dual Katana")
T24:AddLabel("Triple Katana, Pipe, Dual-Headed Blade")
T24:AddLabel("Bisento, Soul Cane, Pole v.2")
T24:AddSection("Guns")
T24:AddToggle({Name="Auto Buy All Guns",Default=F.AutoBuyGuns,Callback=function(v) F.AutoBuyGuns=v end})
T24:AddLabel("Slingshot, Musket, Flintlock, Refined Slingshot")
T24:AddLabel("Refined Flintlock, Cannon, Kabucha, Bizarre Rifle")
T24:AddSection("Abilities")
T24:AddToggle({Name="Auto Buy All Abilities",Default=F.AutoBuyAbilities,Callback=function(v) F.AutoBuyAbilities=v end})
T24:AddLabel("Skyjump, Buso Haki, Observation Haki, Soru")
T24:AddSection("Services")
T24:AddButton({Name="Buy Refund Stat",Callback=function()
    CommF("RefundStat")
    CommF("StatRefund")
    CommF("BuyRefund")
    Notify("Shop", "Refund stat requested!", 3)
end})
T24:AddButton({Name="Buy Reroll Race",Callback=function()
    CommF("RerollRace")
    CommF("BuyRerollRace")
    CommF("RaceReroll")
    Notify("Shop", "Reroll race requested!", 3)
end})
T24:AddSection("Race Purchases")
T24:AddToggle({Name="Buy Ghoul Race",Default=F.AutoBuyGhoul,Callback=function(v) F.AutoBuyGhoul=v end})
T24:AddToggle({Name="Buy Cyborg Race",Default=F.AutoBuyCyborg,Callback=function(v) F.AutoBuyCyborg=v end})
T24:AddToggle({Name="Buy Draco Race",Default=F.AutoBuyDraco,Callback=function(v) F.AutoBuyDraco=v end})

---- ========== SELECT FIRST TAB ==========
AllTabs[1].Frame.Visible = true
AllTabs[1].Button.BackgroundColor3 = Theme.Accent
AllTabs[1].Button.TextColor3 = Theme.Text

---- ========== UI KEYBINDS (RightShift to toggle) ==========
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        minimized = not minimized
        content.Visible = not minimized
        tabC.Visible = not minimized
        main.Size = minimized and UDim2.new(0,800,0,42) or UDim2.new(0,800,0,600)
        closeBtn.Text = minimized and "+" or "X"
    end
end)

---- ========== ESP LOOPS ==========
task.spawn(function()
    while true do
        task.wait(3)
        if F.ESPPlayers then pcall(function()
            for _, p in ipairs(P:GetPlayers()) do
                if p ~= LP and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local c = p.Team and p.Team.TeamColor and p.Team.TeamColor.Color or Color3.fromRGB(255,100,100)
                        CreateESP(p.Character, c, p.Name.." ["..math.floor(hum.Health/hum.MaxHealth*100).."%]", 160)
                    end
                end
            end
        end) end
    end
end)

task.spawn(function()
    while true do
        task.wait(4)
        if F.ESPFruits then pcall(function()
            for _, o in ipairs(WS:GetDescendants()) do
                if o:IsA("Tool") or (o:IsA("Model") and o.Name:find("Fruit")) then
                    local h = o:FindFirstChild("Handle") or o:FindFirstChildWhichIsA("BasePart")
                    if h then
                        local fd = GetFD(o.Name)
                        CreateESP(o, fd and fd.C or Color3.fromRGB(255,170,0), o.Name.." ["..(fd and fd.R or "?").."]", 180)
                    end
                end
            end
        end) end
    end
end)

task.spawn(function()
    while true do task.wait(5)
        if F.ESPChests then pcall(function()
            for _, o in ipairs(WS:GetDescendants()) do
                if (o.Name:find("Chest") or o.Name:find("Treasure")) and (o:IsA("BasePart") or o:IsA("Model")) then
                    CreateESP(o, Color3.fromRGB(255,215,0), o.Name, 100)
                end
            end
        end) end
    end
end)

task.spawn(function()
    while true do task.wait(5)
        if F.ESPFlowers then pcall(function()
            for _, o in ipairs(WS:GetDescendants()) do
                if (o.Name:find("Flower") or o.Name:find("Blossom")) and (o:IsA("BasePart") or o:IsA("MeshPart")) then
                    CreateESP(o, Color3.fromRGB(255,100,200), o.Name, 80)
                end
            end
        end) end
    end
end)

task.spawn(function()
    while true do task.wait(3)
        if F.ESPBosses then pcall(function()
            for _, bd in ipairs(Bosses) do
                for _, folder in ipairs({"Enemies","NPCs","Living"}) do
                    local f = WS:FindFirstChild(folder)
                    if f then
                        for _, obj in ipairs(f:GetDescendants()) do
                            if obj:IsA("Model") and obj.Name == bd.Name then
                                local hum = obj:FindFirstChildOfClass("Humanoid")
                                if hum and hum.Health > 0 then
                                    CreateESP(obj, Color3.fromRGB(255,0,0), "[BOSS] "..bd.Name.." ["..math.floor(hum.Health/hum.MaxHealth*100).."%]", 200)
                                end
                            end
                        end
                    end
                end
            end
        end) end
    end
end)

task.spawn(function()
    while true do task.wait(3)
        if F.ESPSeaBeast then pcall(function()
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Sea Beast") or obj.Name:find("Terror Shark") or obj.Name:find("Leviathan")) then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        CreateESP(obj, Color3.fromRGB(0, 150, 255), "[SEA] "..obj.Name, 200)
                    end
                end
            end
        end) end
    end
end)

---- ========== AUTO COLLECT FRAGMENTS LOOP ==========
task.spawn(function()
    while true do
        task.wait(10)
        if not F.AutoCollectFragments then continue end
        pcall(function()
            if not Alive() then return end
            CollectRaceFragments()
        end)
    end
end)

---- ========== V10: AUTO BUY SHOP LOOP ==========
task.spawn(function()
    while true do
        task.wait(5)
        if not F.AutoBuyShop then continue end
        pcall(function()
            if not Alive() then return end
            BuyFromShop("Shop", C.ShopBuyItem)
            BuyFromShop("Weapon", C.ShopBuyItem)
            BuyFromShop("Fighting Style", C.ShopBuyItem)
        end)
    end
end)

---- ========== STATUS BAR (v11.0 Enhanced) ==========
local statusBar = M("Frame",{Size=UDim2.new(0,800,0,28),Position=UDim2.new(0.5,-400,1,-290),BackgroundColor3=Theme.Bar,BorderSizePixel=0},{scr})
Cr(statusBar,8); St(statusBar,Theme.Accent,1)

local statusHP = M("TextLabel",{Size=UDim2.new(0.15,0,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Text="HP: 100%",TextColor3=Theme.Accent,TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},{statusBar})
local statusSea = M("TextLabel",{Size=UDim2.new(0.08,0,1,0),Position=UDim2.new(0.16,0,0,0),BackgroundTransparency=1,Text="Sea 1",TextColor3=Theme.Text,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},{statusBar})
local statusLv = M("TextLabel",{Size=UDim2.new(0.08,0,1,0),Position=UDim2.new(0.25,0,0,0),BackgroundTransparency=1,Text="Lv: 1",TextColor3=Theme.Text,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},{statusBar})
local statusAtk = M("TextLabel",{Size=UDim2.new(0.1,0,1,0),Position=UDim2.new(0.34,0,0,0),BackgroundTransparency=1,Text="Atk: 0",TextColor3=Theme.Dim,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},{statusBar})
local statusActive = M("TextLabel",{Size=UDim2.new(0.38,0,1,0),Position=UDim2.new(0.45,0,0,0),BackgroundTransparency=1,Text="Active: None",TextColor3=Color3.fromRGB(100,255,100),TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},{statusBar})
local statusVer = M("TextLabel",{Size=UDim2.new(0.12,0,1,0),Position=UDim2.new(0.88,0,0,0),BackgroundTransparency=1,Text="v12.0 ULTIMATE",TextColor3=Theme.Accent,TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Right},{statusBar})

task.spawn(function()
    while scr.Parent do
        task.wait(C.StatusUpdateRate)
        pcall(function()
            local hp = HP()
            statusHP.Text = "HP: "..math.floor(hp).."%"
            statusHP.TextColor3 = hp > 60 and Color3.fromRGB(100,255,100) or (hp > 30 and Color3.fromRGB(255,255,100) or Color3.fromRGB(255,80,80))
            statusSea.Text = "Sea "..Sea()
            statusLv.Text = "Lv: "..Lv()
            statusAtk.Text = "Atk: "..AtkCount
            local active = {}
            if F.AutoFarm then table.insert(active, "Farm") end
            if F.FarmAll then table.insert(active, "FarmAll") end
            if F.AutoBossFarm then table.insert(active, "Boss") end
            if F.KillAura then table.insert(active, "KillAura") end
            if F.AutoRaid then table.insert(active, "Raid") end
            if F.AutoCDK then table.insert(active, "CDK") end
            if F.BountyHunt then table.insert(active, "Bounty") end
            if F.AutoFindFruits then table.insert(active, "Fruit") end
            if F.AutoChestFarm then table.insert(active, "Chest") end
            if F.AutoMaterialsFarm then table.insert(active, "Mat") end
            if F.AutoHakiBuso or F.AutoHakiKen then table.insert(active, "Haki") end
            if F.AutoGodHuman then table.insert(active, "GodH") end
            if F.AutoSoulGuitar then table.insert(active, "SoulG") end
            if F.AutoDarkBlade then table.insert(active, "DB") end
            if F.AutoSharkAnchor then table.insert(active, "SharkA") end
            if F.AutoCanvander then table.insert(active, "Canv") end
            if F.AutoLegendSword then table.insert(active, "LegS") end
            if F.AutoTuskV4 then table.insert(active, "Tusk") end
            if F.AutoFactoryEvent then table.insert(active, "Fact") end
            if F.AutoDoughKing then table.insert(active, "DoughK") end
            if F.AutoFrozenDimension then table.insert(active, "Frozen") end
            if F.AutoMirrorDimension then table.insert(active, "Mirror") end
            if F.AutoDragonTalon then table.insert(active, "DragonT") end
            if F.AutoDeathStep then table.insert(active, "DeathS") end
            if F.AutoSharkKarate then table.insert(active, "SharkK") end
            if F.AutoElectricClaw then table.insert(active, "ElecClaw") end
            if F.AutoBardQuest then table.insert(active, "Bard") end
            if F.AutoRevenge then table.insert(active, "Revenge") end
            if F.AutoBusoHaki then table.insert(active, "AutoBuso") end
            if F.AutoKenHaki then table.insert(active, "AutoKen") end
            if F.UltraComboMode then table.insert(active, "UltraCombo") end
            if F.Fly then table.insert(active, "Fly") end
            if F.AutoDodge then table.insert(active, "Dodge") end
            if F.ComboAttack then table.insert(active, "Combo") end
            if F.PlayerHighlight then table.insert(active, "HL") end
            if F.FPSBoost then table.insert(active, "FPS+") end
            if F.SmartSafeZone then table.insert(active, "SafeZ") end
            if F.SmartPathfind then table.insert(active, "Pathfind") end
            if F.PredictionCombat then table.insert(active, "Predict") end
            if F.AutoAwakenFruit then table.insert(active, "Awaken") end
            if F.AutoCollectFragments then table.insert(active, "Frag") end
            if F.AutoFishing then table.insert(active, "Fish") end
            if F.AutoTrade then table.insert(active, "Trade") end
            if F.NoclipEnabled then table.insert(active, "NoClip") end
            if F.InfiniteJump then table.insert(active, "InfJump") end
            if F.AimbotEnabled then table.insert(active, "Aimbot") end
            if F.AutoBartiloQuest then table.insert(active, "Bartilo") end
            if F.AutoLegendarySword then table.insert(active, "LegSwd") end
            if F.AutoLawRaid then table.insert(active, "LawRaid") end
            if F.AutoObservationHaki then table.insert(active, "ObsHaki") end
            if F.AutoMastery600 then table.insert(active, "M600") end
            if F.AutoBuddhaTransform then table.insert(active, "Buddha") end
            if F.AutoRandomFruit then table.insert(active, "RandF") end
            if F.AutoCollectBerries then table.insert(active, "Berry") end
            if F.AutoGhoulRace then table.insert(active, "Ghoul") end
            if F.ChestHop then table.insert(active, "ChestH") end
            if F.BoatSpeedEnabled then table.insert(active, "Boat") end
            if F.AutoBuyBusoColors then table.insert(active, "BusoC") end
            if F.AutoDarkDaggerQuest then table.insert(active, "DDagger") end
            if F.AutoHallowScytheQuest then table.insert(active, "HScythe") end
            if F.AutoSwanGlassesQuest then table.insert(active, "SGlasses") end
            if F.AutoGreybeardQuest then table.insert(active, "Greyb") end
            if F.AutoCitizenQuest then table.insert(active, "Citizen") end
            if F.AutoRainbowHaki then table.insert(active, "Rainbow") end
            if F.AutoHolyTorch then table.insert(active, "Torch") end
            if F.AutoEnhancementColor then table.insert(active, "Enhance") end
            if F.AutoDungeonFull then table.insert(active, "Dungeon") end
            if F.AutoRaceDoor then table.insert(active, "RaceDr") end
            if F.AutoAutoTrial then table.insert(active, "Trial") end
            if F.AutoTrainRace then table.insert(active, "TrainR") end
            if F.AutoBuyGear then table.insert(active, "Gear") end
            if F.AutoTPMirage then table.insert(active, "Mirage") end
            if F.AutoTPBlueGear then table.insert(active, "BluGear") end
            if F.AutoTPKitsune then table.insert(active, "Kitsune") end
            if F.AutoAzureEmber then table.insert(active, "Ember") end
            if F.AutoKillTerrorshark then table.insert(active, "TShark") end
            if F.AutoKillPiranha then table.insert(active, "Piranha") end
            if F.AutoKillFishCrew then table.insert(active, "FishCr") end
            if F.AutoBuyFightingStyles then table.insert(active, "BuyFS") end
            if F.AutoBuySwords then table.insert(active, "BuySwd") end
            if F.AutoBuyGuns then table.insert(active, "BuyGun") end
            if F.AutoBuyAbilities then table.insert(active, "BuyAb") end
            if F.NoStunEnabled then table.insert(active, "NoStun") end
            if F.AutoActiveV3 then table.insert(active, "V3") end
            if F.AutoActiveV4Full then table.insert(active, "V4") end
            if F.SuperAttack then table.insert(active, "SupAtk") end
            if F.SafeModePvP then table.insert(active, "SafePvP") end
            if F.AutoDojo then table.insert(active, "Dojo") end
            if F.AutoFarmBones then table.insert(active, "Bones") end
            if F.AutoFarmCandy then table.insert(active, "Candy") end
            if F.AutoSecondSea then table.insert(active, "Sea2") end
            if F.AutoThirdSea then table.insert(active, "Sea3") end
            if F.AutoTreeDestroyer then table.insert(active, "Tree") end
            if F.SafeTween then table.insert(active, "SafeTwn") end
            if F.AntiStuck then table.insert(active, "AntiStk") end
            if F.AutoBossDropSaber or F.AutoBossDropPole or F.AutoBossDropSharkSaw or F.AutoBossDropTrident or F.AutoBossDropMusket or F.AutoBossDropWardenSword or F.AutoBossDropBazooka then table.insert(active, "BS1") end
            if F.AutoBossDropAcidumRifle or F.AutoBossDropJitte or F.AutoBossDropHellfireTorch then table.insert(active, "BS2") end
            if F.AutoBossDropSerpentBow or F.AutoBossDropTwinHooks or F.AutoBossDropBuddySword or F.AutoBossDropDarkDagger then table.insert(active, "BS3") end
            if #active == 0 then
                statusActive.Text = "Active: None"
                statusActive.TextColor3 = Theme.Dim
            else
                statusActive.Text = "Active: "..table.concat(active, ", ")
                statusActive.TextColor3 = Color3.fromRGB(100, 255, 100)
            end
            infoLbl.Text = EXEC.." | Lv"..Lv().." | "..Beli().."B | "..Frags().."F | Sea"..Sea().." | "..GetRace()
        end)
    end
end)

---- ========== V12: ADDITIONAL UTILITY FUNCTIONS ==========

local function GetBossStatus(bossName)
    for _, bd in ipairs(Bosses) do
        if bd.Name == bossName then
            local mob = FindMob(bossName, 1000)
            if mob then
                local mh = mob:FindFirstChildOfClass("Humanoid")
                if mh and mh.Health > 0 then
                    return "Alive", math.floor(mh.Health / mh.MaxHealth * 100)
                end
            end
            return "Not Found", 0
        end
    end
    return "Unknown", 0
end

local function GetSeaName(seaNum)
    if seaNum == 1 then return "Sea 1 (??)" end
    if seaNum == 2 then return "Sea 2 (???)" end
    if seaNum == 3 then return "Sea 3 (???)" end
    return "Sea Unknown"
end

local function GetFormattedRace()
    local race = GetRace()
    return race ~= "Unknown" and race or "Not Selected"
end

local function GetPlaytime()
    return math.floor(game:GetService("Stats"):GetValue("SessionStart") ~= 0
        and tick() - game:GetService("Stats"):GetValue("SessionStart") or 0)
end

local function EmergencyFullHeal()
    pcall(function()
        CommF("Heal")
        CommF("FullHeal")
        CommF("RestoreHealth")
        CommF("EatFruit")
        local h = Hum()
        if h then
            h.Health = h.MaxHealth
        end
    end)
    Notify("Emergency", "Full heal requested!", 3)
end

local function AntiKick()
    pcall(function()
        if EXP.hookmm and EXP.newcc then
            local oldNC
            oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local m = getnamecallmethod()
                if m == "Kick" then
                    local n = tostring(self)
                    if n:find("LocalPlayer") or n:find(LP.Name) then
                        return nil
                    end
                end
                return oldNC(self, ...)
            end))
        end
    end)
end

pcall(AntiKick)

---- ========== V12: AUTO COLLECT ALL HELPER ==========
local function GetAllNearbyItems(maxDist)
    maxDist = maxDist or 500
    local h = HRP()
    if not h then return {} end
    local items = {}
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local handle = obj:IsA("Model") and (obj:FindFirstChildWhichIsA("BasePart")) or obj
            if handle then
                local d = (h.Position - handle.Position).Magnitude
                if d <= maxDist then
                    local name = obj.Name
                    if name:find("Fragment") or name:find("Coin") or name:find("Gem") or name:find("Token") or name:find("Relic") then
                        table.insert(items, {Obj=obj, Name=name, Pos=handle.Position, Dist=d})
                    end
                end
            end
        end
    end
    table.sort(items, function(a,b) return a.Dist < b.Dist end)
    return items
end

local function CollectAllNearbyItems()
    if not Alive() then return end
    local items = GetAllNearbyItems(300)
    for _, item in ipairs(items) do
        if not Alive() then break end
        SmartPathfind(item.Pos + Vector3.new(0, 2, 0))
        task.wait(0.3)
        pcall(function()
            local pp = item.Obj:FindFirstChildOfClass("ProximityPrompt")
            if pp then fireproximityprompt(pp) end
        end)
        pcall(function()
            if EXP.firetouch then
                firetouchinterest(HRP(), item.Obj, 0)
                task.wait(0.1)
                firetouchinterest(HRP(), item.Obj, 1)
            end
        end)
        pcall(function()
            CommF("PickupItem", item.Name)
            CommF("CollectItem", item.Name)
        end)
        task.wait(0.2)
    end
end

---- ========== V12: STATUS REPORTER ==========
local StatusReport = {LastReport=0, ReportInterval=60}

task.spawn(function()
    while true do
        task.wait(StatusReport.ReportInterval)
        pcall(function()
            if not Alive() then return end
            local now = os.time()
            if (now - StatusReport.LastReport) < StatusReport.ReportInterval then return end
            StatusReport.LastReport = now
            local activeFeatures = 0
            for _, v in pairs(F) do
                if type(v) == "boolean" and v then
                    activeFeatures = activeFeatures + 1
                end
            end
            if activeFeatures > 0 then
                Notify("Status Report", "Level: "..Lv().." | Sea: "..Sea().." | Bounty: "..FormatNumber(Bounty()).." | Active: "..activeFeatures.." features", 5)
            end
        end)
    end
end)

---- ========== V12: AUTO ACTIVATE HAKI ON RESPAWN ==========
LP.CharacterAdded:Connect(function(c)
    ClearCharCache()
    task.wait(1)
    local h = c:WaitForChild("Humanoid", 5)
    if h then h.WalkSpeed = C.WalkSpeed; h.JumpPower = C.JumpPower end
    ClearCharCache()
    if F.AutoBusoHaki or F.AutoHakiBuso then
        task.wait(2)
        pcall(function()
            CommF("BusoHaki")
            CommF("ActivateHaki", "Buso")
            CommF("ToggleHaki", "Buso")
        end)
    end
    if F.AutoKenHaki or F.AutoHakiKen then
        task.wait(2)
        pcall(function()
            CommF("KenHaki")
            CommF("ActivateHaki", "Ken")
            CommF("ToggleHaki", "Ken")
        end)
    end
end)
LP.CharacterAdded:Connect(function(c)
    ClearCharCache()
    task.wait(1)
    local h = c:WaitForChild("Humanoid", 5)
    if h then h.WalkSpeed = C.WalkSpeed; h.JumpPower = C.JumpPower end
    ClearCharCache()
end)

task.defer(function()
    local h = Hum()
    if h then h.WalkSpeed = C.WalkSpeed; h.JumpPower = C.JumpPower end
end)

---- ========== FINAL ==========
print("=================================================================")
print("     APEX HUB v12.0 APEX COMPLETE - ALL SYSTEMS LOADED")
print("     Executor:  "..EXEC)
print("     Level:     "..Lv())
print("     Sea:       "..Sea())
print("     Anti-AC:   7-Layer Active (v10 Enhanced)")
print("     Smart:     Pathfind, Mob Target, Stats, ServerHop")
print("     Combat:    Prediction, Combo, Ultra Combo, Auto Dodge")
print("     Kill Aura: Ready")
print("     Bring Mob: Ready")
print("     Fly System: Ready")
print("     Auto Raid: Ready")
print("     Auto CDK:  Ready")
print("     Bounty:    Ready + Revenge")
print("     Weapons:   GodHuman, Soul Guitar, Dark Blade,")
print("                Shark Anchor, Canvander, Legend Sword, Tusk V4")
print("     Fighting:  Dragon Talon, Death Step, Shark Karate, Electric Claw")
print("     Chest Farm: Ready")
print("     Materials: Database loaded ("..#MaterialsDB.." materials)")
print("     Material Detector: Active")
print("     Haki:      Buso + Ken training + Auto activation")
print("     Combo:     Ultra Combo (5-weapon) + Sword->Fruit->Gun")
print("     Auto Dodge: PvP evasion active")
print("     Dimensions: Frozen + Mirror auto farm")
print("     Dough King: Auto defeat ready")
print("     Bard Quest: Auto complete ready")
print("     Player HL: Team-colored highlights")
print("     FPS Boost: Lighting + effects optimization")
print("     Status Bar: Live stats display (v10 enhanced)")
print("     ESP:       Drawing API + Health Bars + Tracers + Sea Beast")
print("     Race V4:   Fragments, V4 activation, trials")
print("     Awaken:    Auto fruit awakening")
print("     Shops:     Auto buy from NPCs")
print("     Safe Zone: Smart evasion system")
print("     Anti-Det:  Jitter + FakePos + Randomized delays")
print("     Memory:    Auto cleanup with stats tracking")
print("     Keybinds:  RightShift toggle UI")
print("     Config:    Save/Load Active (v12.0)")
print("     Tabs:      24 tabs, all systems integrated")
print("     [V12] Boss Drop Farming: Sea 1/2/3 weapons")
print("     [V12] Boss Quests: Dark Dagger, Hallow Scythe, Swan, Greybeard")
print("     [V12] Special Quests: Citizen, Rainbow Haki, Holy Torch, Dojo")
print("     [V12] Dungeon System: Full auto dungeon with doors/rewards")
print("     [V12] Race System: Door, Trial, Train, Buy Gear")
print("     [V12] Sea Events: Mirage, Blue Gear, Kitsune, Azure Ember, Terrorshark")
print("     [V12] Shop System: Fighting Styles, Swords, Guns, Abilities, Races")
print("     [V12] Movement: No Stun, Auto V3, Auto V4")
print("     [V12] Combat: Super Attack, Safe Mode PvP")
print("     [V12] Teleport: 28 islands with dropdown selection")
print("     [V12] ZekeHub Features: 169+ new features integrated")
print("=================================================================")

Notify("APEX HUB v12.0 APEX COMPLETE", "All systems loaded! "..EXEC.." | Lv"..Lv().." | Sea"..Sea().." | 24 Tabs | 169+ new features", 5)
