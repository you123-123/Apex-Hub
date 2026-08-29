--[[
    █████╗ ██████╗  █████╗ ██████╗  █████╗ ███╗   ██╗ █████╗ ██████╗ ████████╗
   ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗████╗  ██║██╔══██╗██╔══██╗╚══██╔══╝
   ███████║██████╔╝███████║██║  ██║███████║██╔██╗ ██║███████║██████╔╝   ██║
   ██╔══██║██╔══██╗██╔══██║██║  ██║██╔══██║██║╚██╗██║██╔══██║██╔══██╗   ██║
   ██║  ██║██████╔╝██║  ██║██████╔╝██║  ██║██║ ╚████║██║  ██║██║  ██║   ██║
   ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝
   Apex Hub v13.0 | APEX ULTIMATE | Configuration System
   Core Module: config.lua
   Comprehensive configuration management with persistence, validation, and defaults
--]]

local A = _G.Apex or (getgenv and getgenv().Apex) or {}
A.__index = A

-- ============================================================================
-- CONFIGURATION PATH
-- ============================================================================
A.ConfigPath = "ApexConfig_v13.json"

-- ============================================================================
-- A.C = {} — MASTER CONFIGURATION VALUES
-- ============================================================================
A.C = {}

-- ---------------------------------------------------------------------------
-- Combat & Interaction Delays
-- ---------------------------------------------------------------------------
A.C.ClickDelay = 0.02
A.C.DodgeDistance = 15
A.C.DodgeCooldown = 2
A.C.BerryCollectRange = 8
A.C.GoalPollInterval = 3
A.C.TeleportDelay = 0.15
A.C.QuestWait = 1.0
A.C.QuestRedeemDelay = 0.5
A.C.AttackComboDelay = {0.02, 0.05, 0.08}

-- ---------------------------------------------------------------------------
-- Movement & Speed
-- ---------------------------------------------------------------------------
A.C.TweenSpeed = 350
A.C.FlySpeed = 100
A.C.NoclipSpeed = 50
A.C.WalkSpeed = 16
A.C.JumpPower = 50

-- ---------------------------------------------------------------------------
-- Range & Detection
-- ---------------------------------------------------------------------------
A.C.FarmRadius = 15
A.C.AttackRange = 12
A.C.DodgeRange = 40
A.C.KillAuraRange = 30
A.C.ESPRange = 2500
A.C.AutoFarmRadius = 150

-- ---------------------------------------------------------------------------
-- Server & Networking
-- ---------------------------------------------------------------------------
A.C.ServerHopDelay = 3
A.C.MaxRetries = 5
A.C.AntiStuckTime = 10

-- ---------------------------------------------------------------------------
-- Event Timers (seconds)
-- ---------------------------------------------------------------------------
A.C.BossSpawnCheckDelay = 30
A.C.FruitCheckDelay = 60
A.C.SeaEventCheckDelay = 10
A.C.RaidCooldown = 300
A.C.BountyCheckDelay = 120
A.C.MasteryCheckDelay = 5

-- ---------------------------------------------------------------------------
-- Fruit System
-- ---------------------------------------------------------------------------
A.C.FruitsToNotify = {
    "Dragon", "Leopard", "Spirit", "Kitsune", "Mammoth",
    "T-Rex", "Control", "Dough", "Shadow", "Venom",
    "Gravity", "Buddha", "Phoenix", "Rumble", "Blizzard",
    "Paw", "Spider", "Quake", "Magma", "Light",
    "Dark", "String", "Bomb", "Spike", "Barrier",
    "Ghost", "Love", "Rubber", "Diamond", "Bird: Phoenix",
    "Kitsune", "Leopard", "Mammoth", "T-Rex", "Yeti",
    "Gas", "Ice", "Buddha", "Sound", "Creation"
}
A.C.SelectedFruitAction = "Notify"

-- ---------------------------------------------------------------------------
-- Webhook & Notifications
-- ---------------------------------------------------------------------------
A.C.DiscordWebhook = ""
A.C.NotificationDuration = 5
A.C.MaxNotifications = 10

-- ---------------------------------------------------------------------------
-- Theme / UI Colors
-- ---------------------------------------------------------------------------
A.C.Theme = {
    Primary   = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(25, 25, 25),
    Accent    = Color3.fromRGB(130, 0, 255),
    Text      = Color3.fromRGB(255, 255, 255),
    Success   = Color3.fromRGB(0, 200, 100),
    Warning   = Color3.fromRGB(255, 170, 0),
    Error     = Color3.fromRGB(255, 50, 50),
    Highlight = Color3.fromRGB(0, 170, 255),
    Muted     = Color3.fromRGB(120, 120, 120),
    Border    = Color3.fromRGB(45, 45, 45)
}

-- ---------------------------------------------------------------------------
-- Keybinds
-- ---------------------------------------------------------------------------
A.C.Keybinds = {
    ToggleUI   = "Insert",
    AutoFarm   = "F1",
    KillAura   = "F2",
    ESP        = "F3",
    Fly        = "F4",
    Noclip     = "F5",
    BossFarm   = "F6",
    SeaBeast   = "F7",
    Bounty     = "F8",
    CDK        = "F9",
    AllESP     = "F10",
    Raid       = "F11",
    Stealth    = "F12",
    Speed      = "KeypadPlus",
    GodMode    = "KeypadMinus"
}

-- ---------------------------------------------------------------------------
-- Anti-Cheat Bypass Levels (1–7)
-- ---------------------------------------------------------------------------
A.C.AntiCheatBypass = {
    [1] = {
        Name        = "Basic",
        Description = "Standard memory read mitigation",
        UseFakePosition = false,
        RandomizeClicks = false,
        DelayMultiplier = 1.0,
        SpoofVelocity = false,
        BlockRemoteDetection = false,
        RotateCharacter = false,
        JitterMovement = false,
        UseHumanoidRootPart = true,
        MaxActionsPerSecond = 100,
        EnableServerSideCheck = false
    },
    [2] = {
        Name        = "Intermediate",
        Description = "Click pattern obfuscation with delay jittering",
        UseFakePosition = false,
        RandomizeClicks = true,
        DelayMultiplier = 1.2,
        SpoofVelocity = false,
        BlockRemoteDetection = true,
        RotateCharacter = false,
        JitterMovement = false,
        UseHumanoidRootPart = true,
        MaxActionsPerSecond = 80,
        EnableServerSideCheck = false
    },
    [3] = {
        Name        = "Advanced",
        Description = "Position spoofing and remote rate limiting",
        UseFakePosition = true,
        RandomizeClicks = true,
        DelayMultiplier = 1.5,
        SpoofVelocity = false,
        BlockRemoteDetection = true,
        RotateCharacter = false,
        JitterMovement = true,
        UseHumanoidRootPart = true,
        MaxActionsPerSecond = 60,
        EnableServerSideCheck = true
    },
    [4] = {
        Name        = "Expert",
        Description = "Velocity spoofing with jittered movement paths",
        UseFakePosition = true,
        RandomizeClicks = true,
        DelayMultiplier = 1.8,
        SpoofVelocity = true,
        BlockRemoteDetection = true,
        RotateCharacter = true,
        JitterMovement = true,
        UseHumanoidRootPart = false,
        MaxActionsPerSecond = 45,
        EnableServerSideCheck = true
    },
    [5] = {
        Name        = "Master",
        Description = "Full spoof suite with server-side simulation checks",
        UseFakePosition = true,
        RandomizeClicks = true,
        DelayMultiplier = 2.2,
        SpoofVelocity = true,
        BlockRemoteDetection = true,
        RotateCharacter = true,
        JitterMovement = true,
        UseHumanoidRootPart = false,
        MaxActionsPerSecond = 30,
        EnableServerSideCheck = true
    },
    [6] = {
        Name        = "Stealth",
        Description = "Undetectable mode — maximum safety, reduced speed",
        UseFakePosition = true,
        RandomizeClicks = true,
        DelayMultiplier = 3.0,
        SpoofVelocity = true,
        BlockRemoteDetection = true,
        RotateCharacter = true,
        JitterMovement = true,
        UseHumanoidRootPart = false,
        MaxActionsPerSecond = 20,
        EnableServerSideCheck = true
    },
    [7] = {
        Name        = "Ghost",
        Description = "Ghost protocol — near-complete detection avoidance",
        UseFakePosition = true,
        RandomizeClicks = true,
        DelayMultiplier = 4.0,
        SpoofVelocity = true,
        BlockRemoteDetection = true,
        RotateCharacter = true,
        JitterMovement = true,
        UseHumanoidRootPart = false,
        MaxActionsPerSecond = 10,
        EnableServerSideCheck = true
    }
}
A.C.SelectedBypassLevel = 4

-- ---------------------------------------------------------------------------
-- Validation Ranges (used by A.ValidateConfig / A.ClampValues)
-- ---------------------------------------------------------------------------
A.C._Ranges = {
    ClickDelay         = {min = 0.01, max = 2.0},
    TeleportDelay      = {min = 0.05, max = 5.0},
    TweenSpeed         = {min = 50,   max = 2000},
    QuestWait          = {min = 0.1,  max = 10.0},
    QuestRedeemDelay   = {min = 0.1,  max = 5.0},
    FarmRadius         = {min = 1,    max = 200},
    AttackRange        = {min = 1,    max = 100},
    DodgeRange         = {min = 5,    max = 200},
    KillAuraRange      = {min = 5,    max = 200},
    ESPRange           = {min = 100,  max = 10000},
    AutoFarmRadius     = {min = 10,   max = 2000},
    ServerHopDelay     = {min = 1,    max = 60},
    MaxRetries         = {min = 1,    max = 50},
    AntiStuckTime      = {min = 3,    max = 120},
    FlySpeed           = {min = 10,   max = 500},
    NoclipSpeed        = {min = 10,   max = 300},
    WalkSpeed          = {min = 16,   max = 500},
    JumpPower          = {min = 50,   max = 500},
    BossSpawnCheckDelay = {min = 5,   max = 300},
    FruitCheckDelay    = {min = 10,   max = 600},
    SeaEventCheckDelay = {min = 1,    max = 120},
    RaidCooldown       = {min = 30,   max = 1800},
    BountyCheckDelay   = {min = 30,   max = 600},
    MasteryCheckDelay  = {min = 1,    max = 60},
    NotificationDuration = {min = 1,  max = 30},
    MaxNotifications   = {min = 1,    max = 100},
    SelectedBypassLevel = {min = 1,   max = 7}
}

-- ============================================================================
-- A.F = {} — MASTER FEATURE FLAGS (all disabled by default)
-- ============================================================================
A.F = {}

-- ---------------------------------------------------------------------------
-- Berry Farm Flags
-- ---------------------------------------------------------------------------
A.F.BerryFarm         = false
A.F.BerryESP          = false

-- ---------------------------------------------------------------------------
-- Fishing Expansion Flags
-- ---------------------------------------------------------------------------
A.F.AutoSellFish      = false
A.F.AutoEquipBestRod  = false

-- ---------------------------------------------------------------------------
-- Trading Expansion Flags
-- ---------------------------------------------------------------------------
A.F.AutoAddFruits     = false
A.F.ScamDetect        = true

-- ---------------------------------------------------------------------------
-- Goal System Flags
-- ---------------------------------------------------------------------------
A.F.GoalSystem        = false
A.F.GoalLevel         = false
A.F.GoalLevelTarget   = 0
A.F.GoalBeli          = false
A.F.GoalBeliTarget    = 0
A.F.GoalFragments     = false
A.F.GoalFragTarget    = 0
A.F.GoalNotification  = true

-- ---------------------------------------------------------------------------
-- Combat Dodge Flags
-- ---------------------------------------------------------------------------
A.F.CombatDodge       = false
A.F.ProjectileDodge   = false
A.F.SkillDodge        = false
A.F.AreaDodge         = false
A.F.ObservationDodge  = false

-- ---------------------------------------------------------------------------
-- Sound & GUI Control Flags
-- ---------------------------------------------------------------------------
A.F.Sounds            = true
A.F.PanicButton       = false
A.F.PanicStop         = true

-- ---------------------------------------------------------------------------
-- Auto Recovery Flags
-- ---------------------------------------------------------------------------
A.F.AutoRecovery      = false
A.F.RejoinOnError     = true

-- ---------------------------------------------------------------------------
-- Smart AI Flags (Rare Features)
-- ---------------------------------------------------------------------------
A.F.SmartAI           = false
A.F.RouteOptimize     = false
A.F.EconomyMaster     = false
A.F.SessionMemory     = false
A.F.Humanization      = false
A.F.PrecisionFarm     = false

-- ---------------------------------------------------------------------------
-- Auto Farm Flags
-- ---------------------------------------------------------------------------
A.F.AutoFarm          = false
A.F.AutoFarmChest     = false
A.F.AutoFarmBone      = false
A.F.AutoFarmCandy     = false
A.F.AutoFarmMaterial  = false

-- ---------------------------------------------------------------------------
-- Combat Flags
-- ---------------------------------------------------------------------------
A.F.KillAura          = false
A.F.KillAuraMobs      = false
A.F.KillAuraPlayers   = false
A.F.AutoClick         = false
A.F.AuraBypass        = false

-- ---------------------------------------------------------------------------
-- Boss & PvP Flags
-- ---------------------------------------------------------------------------
A.F.BossFarm          = false
A.F.AutoBounty        = false
A.F.AutoCDK           = false
A.F.AutoOrder         = false
A.F.AutoRipIndra      = false
A.F.AutoLeviathan     = false
A.F.Leviathan         = false

-- ---------------------------------------------------------------------------
-- Mastery Flags
-- ---------------------------------------------------------------------------
A.F.AutoMastery       = false
A.F.AutoMasteryFruit  = false
A.F.AutoMasterySword  = false
A.F.AutoMasteryGun    = false
A.F.AutoMasteryMelee  = false
A.F.AutoMasteryAbility = false

-- ---------------------------------------------------------------------------
-- Auto Stats Flags
-- ---------------------------------------------------------------------------
A.F.AutoStats         = false
A.F.AutoStatsMelee    = false
A.F.AutoStatsDefense  = false
A.F.AutoStatsBloxfruit = false
A.F.AutoStatsSword    = false
A.F.AutoStatsGun      = false

-- ---------------------------------------------------------------------------
-- Fruit System Flags
-- ---------------------------------------------------------------------------
A.F.AutoFruit         = false
A.F.AutoStore         = false
A.F.AutoEat           = false
A.F.AutoSniperFruit   = false
A.F.AutoDropFruit     = false
A.F.AutoTradeFruit    = false

-- ---------------------------------------------------------------------------
-- Sea Event Flags
-- ---------------------------------------------------------------------------
A.F.SeaBeast          = false
A.F.TerrorShark       = false
A.F.SharkAnchor       = false
A.F.FrozenDimension   = false
A.F.AutoFrozenDimension = false
A.F.PrehistoricIsland = false
A.F.AutoPrehistoricIsland = false
A.F.MirrorDimension   = false
A.F.AutoMirrorDimension = false

-- ---------------------------------------------------------------------------
-- Raid Flags
-- ---------------------------------------------------------------------------
A.F.AutoRaid          = false
A.F.AutoRaidAll       = false
A.F.AutoRaidNext      = false
A.F.AutoCompleteRaid  = false
A.F.RaidBoss          = false
A.F.RaidBosses        = false

-- ---------------------------------------------------------------------------
-- ESP Flags
-- ---------------------------------------------------------------------------
A.F.ESP               = false
A.F.ESPPlayers        = false
A.F.ESPChest          = false
A.F.ESPFruit          = false
A.F.ESPMob            = false
A.F.ESPQuest          = false
A.F.ESPSea            = false
A.F.ESPBoss           = false

-- ---------------------------------------------------------------------------
-- Teleport Flags
-- ---------------------------------------------------------------------------
A.F.Teleport          = false
A.F.TeleportFruit     = false
A.F.TeleportBoss      = false
A.F.TeleportNPC       = false
A.F.TeleportIsland    = false

-- ---------------------------------------------------------------------------
-- Movement Flags
-- ---------------------------------------------------------------------------
A.F.Fly               = false
A.F.Noclip            = false
A.F.Speed             = false
A.F.SpeedHack         = false
A.F.JumpPower         = false
A.F.InfiniteEnergy    = false
A.F.WalkOnWater       = false
A.F.InfiniteJump      = false
A.F.BHop              = false

-- ---------------------------------------------------------------------------
-- Combat Utility Flags
-- ---------------------------------------------------------------------------
A.F.NoStun            = false
A.F.NoStunEnabled     = false
A.F.EnhancedDodge     = false
A.F.AutoActiveV3      = false
A.F.AutoActiveV4      = false
A.F.AutoActiveV4Full  = false
A.F.SafeModePvP       = false
A.F.SuperAttack       = false

-- ---------------------------------------------------------------------------
-- Progression Flags
-- ---------------------------------------------------------------------------
A.F.AutoSecondSea     = false
A.F.AutoThirdSea      = false
A.F.AutoRaceV4        = false
A.F.AutoDungeon       = false
A.F.AutoAwaken        = false
A.F.AutoDojo          = false
A.F.AutoDracoRace     = false
A.F.AutoGhoul         = false
A.F.AutoCyborg        = false

-- ---------------------------------------------------------------------------
-- Haki / Ability Flags
-- ---------------------------------------------------------------------------
A.F.AutoBuyFood       = false
A.F.AutoHaki          = false
A.F.AutoBuso          = false
A.F.AutoKen           = false
A.F.AutoSoru          = false
A.F.AutoGeppo         = false
A.F.AutoAura          = false
A.F.AutoRock          = false
A.F.AutoBuySwords     = false
A.F.AutoBuyGuns       = false
A.F.AutoBuyAbilities  = false
A.F.AutoBuyFightingStyles = false
A.F.AutoBuyAccessories = false

-- ---------------------------------------------------------------------------
-- Utility Flags
-- ---------------------------------------------------------------------------
A.F.AutoFishing       = false
A.F.AutoRob           = false
A.F.AutoOpen          = false
A.F.AutoBuy           = false
A.F.AutoSell          = false
A.F.AutoQuest         = false
A.F.AutoTrade         = false
A.F.AutoAccept        = false

-- ---------------------------------------------------------------------------
-- World Event Flags
-- ---------------------------------------------------------------------------
A.F.FullMoon          = false
A.F.AutoEliteHunter  = false
A.F.AutoDoughKing    = false
A.F.AutoDarkbeard    = false
A.F.AutoCakePrince   = false
A.F.AutoColorAdmin   = false
A.F.AutoRainbowHaki  = false
A.F.AutoEnhancementColor = false
A.F.AutoFruitSkillChain = false
A.F.AutoSwordSkillChain = false
A.F.AutoTreeDestroyer = false
A.F.AutoRevenge       = false

-- ---------------------------------------------------------------------------
-- Unique / Quality-of-Life Flags
-- ---------------------------------------------------------------------------
A.F.UniqueFeatures    = false
A.F.AutoKeybinds      = false
A.F.AutoStealth       = false
A.F.StealthMode       = false
A.F.AutoTeamSwitch    = false
A.F.AutoInventory     = false
A.F.AutoBuffManager   = false

-- ---------------------------------------------------------------------------
-- Extended Automation Flags
-- ---------------------------------------------------------------------------
A.F.AutoBossTimer     = false
A.F.AutoPvPRank       = false
A.F.AutoFruitValue    = false
A.F.AutoHopLow        = false
A.F.AutoSellTrash     = false
A.F.AutoBuyAllRaces   = false

-- ---------------------------------------------------------------------------
-- Server Filter Flags
-- ---------------------------------------------------------------------------
A.F.ServerFilters     = false
A.F.PreferEmpty       = false
A.F.HopToEmpty        = false

-- ---------------------------------------------------------------------------
-- Combat AI Flags
-- ---------------------------------------------------------------------------
A.F.CombatAI          = false
A.F.AutoCounter       = false
A.F.SmartDodge        = false
A.F.AdaptiveCombo     = false
A.F.AntiCombo         = false
A.F.PredictionCombat  = false

-- ---------------------------------------------------------------------------
-- Mega Farm Flags
-- ---------------------------------------------------------------------------
A.F.MegaFarm          = false
A.F.FarmAllEnemies    = false
A.F.FarmAllQuests     = false
A.F.FarmAllZones      = false
A.F.AutoCollectAll    = false
A.F.MegaCombo         = false

-- ---------------------------------------------------------------------------
-- Trigger Flags
-- ---------------------------------------------------------------------------
A.F.AutoTriggerRaids    = false
A.F.AutoTriggerFactory  = false
A.F.AutoTriggerSeaBeast = false
A.F.AutoTriggerAllEvents = false

-- ---------------------------------------------------------------------------
-- Advanced Sea Flags
-- ---------------------------------------------------------------------------
A.F.AutoTerrorShark  = false
A.F.AutoKitsune      = false

-- ---------------------------------------------------------------------------
-- Security Flags
-- ---------------------------------------------------------------------------
A.F.AntiDetection    = false
A.F.AntiReport       = false
A.F.StealthMovement  = false
A.F.FullProtection   = false

-- ---------------------------------------------------------------------------
-- Pilot / Automation Flags
-- ---------------------------------------------------------------------------
A.F.AutoPilot        = false
A.F.AutoDodge        = false
A.F.FarmAll          = false
A.F.SmartPathfind    = false
A.F.PlayerHighlight  = false

-- ---------------------------------------------------------------------------
-- Combat Mechanics Flags
-- ---------------------------------------------------------------------------
A.F.FastAttackNormal   = false
A.F.FastAttackExtreme  = false
A.F.FastAttackInstant  = false
A.F.NoCooldownAttack   = false
A.F.HitboxExpand       = false
A.F.HitboxExpandRange  = 25
A.F.MobMagnetRange     = 100
A.F.MobFreezeRange     = 100
A.F.MobMagnet          = false
A.F.MobFreeze          = false
A.F.SilentAim          = false
A.F.MultiTargetLock    = false
A.F.AntiKnockback      = false
A.F.InfiniteDash       = false
A.F.UnlimitedDash      = false
A.F.WallCombo          = false
A.F.AirCombo           = false
A.F.TargetLockSpectate = false
A.F.FastWeaponSwitch   = false
A.F.SkillCancel        = false
A.F.AntiBanChestFarm   = false
A.F.BypassChestSpeed   = false

-- ---------------------------------------------------------------------------
-- Advanced Sea Flags
-- ---------------------------------------------------------------------------
A.F.LeviathanFarm      = false
A.F.LeviathanHarpoon   = false
A.F.LeviathanFreeze    = false
A.F.LeviathanHeart     = false
A.F.LeviathanScales    = false
A.F.MegalodonFarm      = false
A.F.GhostShipFarm      = false
A.F.PiranhaFarm        = false
A.F.SailToDanger       = false
A.F.SeaEventsEvade     = false
A.F.MultiSeaBeast      = false
A.F.MirageIsland       = false
A.F.BlueGear           = false
A.F.MoonAlign          = false
A.F.Resonance          = false
A.F.PirateRaid         = false
A.F.FactoryRaid        = false
A.F.CastleDefense      = false
A.F.MobSpawnCounter    = false

-- ---------------------------------------------------------------------------
-- Visual / Performance Flags
-- ---------------------------------------------------------------------------
A.F.FullBright         = false
A.F.DisableFog         = false
A.F.FOVChanger         = false
A.F.FOVValue           = 70
A.F.FPSBoost           = false
A.F.DisableRendering   = false
A.F.WhiteScreen        = false
A.F.BlackScreen        = false
A.F.AntiAFK            = false
A.F.AutoRedeemCodes    = false
A.F.DiscordWebhook     = false
A.F.WebhookURL         = ""
A.F.Crosshair          = false
A.F.BackgroundMute     = false

-- ---------------------------------------------------------------------------
-- Race V4 Advanced Flags
-- ---------------------------------------------------------------------------
A.F.RaceV4Advanced     = false
A.F.FarmFlowers        = false
A.F.V2Quest            = false
A.F.V3Quest            = false
A.F.TempleOfTime       = false
A.F.FullMoonAlert      = false
A.F.AutoTrial          = false
A.F.V4Gear             = false
A.F.V4SkillTree        = false
A.F.V4Awakening        = false
A.F.AutoSuperhuman     = false
A.F.AutoDeathStep      = false
A.F.AutoSharkmanKarate = false
A.F.AutoElectricClaw   = false
A.F.AutoGodhuman       = false
A.F.AutoDragonTalon    = false
A.F.AutoSanguineArt    = false
A.F.AutoSaberQuest     = false
A.F.AutoTushitaQuest   = false
A.F.AutoYamaQuest      = false
A.F.AutoSoulGuitar     = false
A.F.AutoTTK            = false
A.F.TrainObservationV2 = false
A.F.BuyAllHakiColors   = false

-- ---------------------------------------------------------------------------
-- System Flags
-- ---------------------------------------------------------------------------
A.F.Enabled          = false
A.F.GodMode          = false

-- ============================================================================
-- DEFAULTS BACKUP (used by ResetConfig, GetConfigDiff)
-- ============================================================================
local DefaultC = {}
local DefaultF = {}

-- ============================================================================
-- INTERNAL HELPERS
-- ============================================================================

--- Deep-copy an arbitrary table (no metatables, no userdata)
local function DeepCopy(orig)
    if type(orig) ~= "table" then return orig end
    local copy = {}
    for k, v in pairs(orig) do
        if type(v) == "table" then
            copy[k] = DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

--- Shallow merge `override` into `base`; returns new table
local function ShallowMerge(base, override)
    local result = DeepCopy(base)
    for k, v in pairs(override or {}) do
        result[k] = v
    end
    return result
end

--- Serialize any Lua value to a JSON-like string (handles tables, strings, numbers, bools, nil, Color3)
local function SerializeValue(value, indent)
    indent = indent or 0
    local pad = string.rep("  ", indent)
    local padInner = string.rep("  ", indent + 1)

    local vtype = type(value)

    if vtype == "nil" then
        return "null"

    elseif vtype == "boolean" then
        return tostring(value)

    elseif vtype == "number" then
        if value ~= value then return "NaN" end
        if value == math.huge then return "Infinity" end
        if value == -math.huge then return "-Infinity" end
        return tostring(value)

    elseif vtype == "string" then
        local escaped = value:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r'):gsub('\t', '\\t')
        return '"' .. escaped .. '"'

    elseif vtype == "table" then
        -- Check if it's a Color3
        if typeof and typeof(value) == "Color3" then
            return string.format(
                '{"__type":"Color3","R":%.4f,"G":%.4f,"B":%.4f}',
                value.R, value.G, value.B
            )
        end

        -- Detect array vs dict
        local isArray = true
        local maxIndex = 0
        for k, _ in pairs(value) do
            if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then
                isArray = false
                break
            end
            if k > maxIndex then maxIndex = k end
        end
        if maxIndex ~= #value then isArray = false end

        local parts = {}
        if isArray then
            for i = 1, #value do
                parts[#parts + 1] = padInner .. SerializeValue(value[i], indent + 1)
            end
            return "[\n" .. table.concat(parts, ",\n") .. "\n" .. pad .. "]"
        else
            local keys = {}
            for k in pairs(value) do keys[#keys + 1] = k end
            table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
            for _, k in ipairs(keys) do
                local kStr = type(k) == "string" and ('"' .. k .. '"') or tostring(k)
                parts[#parts + 1] = padInner .. kStr .. ": " .. SerializeValue(value[k], indent + 1)
            end
            return "{\n" .. table.concat(parts, ",\n") .. "\n" .. pad .. "}"
        end
    else
        return '"' .. tostring(value) .. '"'
    end
end

--- Simple JSON parser for our config format (handles our specific serialized output)
local function ParseJSON(str)
    str = str:match("^%s*(.-)%s*$")
    if str == "null" or str == "" then return nil end
    if str == "true" then return true end
    if str == "false" then return false end
    if str == "NaN" or str == "Infinity" then return 0 end
    if str == "-Infinity" then return 0 end

    local num = tonumber(str)
    if num then return num end

    -- String
    if str:sub(1, 1) == '"' and str:sub(-1) == '"' then
        local inner = str:sub(2, -2)
        inner = inner:gsub('\\"', '"'):gsub('\\n', '\n'):gsub('\\r', '\r'):gsub('\\t', '\t'):gsub('\\\\', '\\')
        return inner
    end

    -- Table: array or object
    if str:sub(1, 1) == '{' or str:sub(1, 1) == '[' then
        local isArray = str:sub(1, 1) == '['
        local result = {}
        local content = str:sub(2, -2):match("^%s*(.-)%s*$")
        if content == "" then return result end

        -- Tokenize by commas at the correct depth
        local tokens = {}
        local depth = 0
        local inString = false
        local current = {}
        local escapeNext = false

        for i = 1, #content do
            local ch = content:sub(i, i)
            if escapeNext then
                current[#current + 1] = ch
                escapeNext = false
            elseif ch == '\\' and inString then
                current[#current + 1] = ch
                escapeNext = true
            elseif ch == '"' then
                inString = not inString
                current[#current + 1] = ch
            elseif not inString then
                if ch == '{' or ch == '[' then
                    depth = depth + 1
                    current[#current + 1] = ch
                elseif ch == '}' or ch == ']' then
                    depth = depth - 1
                    current[#current + 1] = ch
                elseif ch == ',' and depth == 0 then
                    tokens[#tokens + 1] = table.concat(current):match("^%s*(.-)%s*$")
                    current = {}
                else
                    current[#current + 1] = ch
                end
            else
                current[#current + 1] = ch
            end
        end
        if #current > 0 then
            tokens[#tokens + 1] = table.concat(current):match("^%s*(.-)%s*$")
        end

        if isArray then
            for _, token in ipairs(tokens) do
                result[#result + 1] = ParseJSON(token)
            end
        else
            for _, token in ipairs(tokens) do
                local key, val = token:match("^%s*\"(.-)\"%s*:%s*(.*)$")
                if key and val then
                    -- Handle Color3 objects
                    if val:match('"__type"%s*:%s*"Color3"') then
                        local r = tonumber(val:match('"R"%s*:%s*([%d%.]+)') or "0")
                        local g = tonumber(val:match('"G"%s*:%s*([%d%.]+)') or "0")
                        local b = tonumber(val:match('"B"%s*:%s*([%d%.]+)') or "0")
                        result[key] = Color3.new(r, g, b)
                    else
                        result[key] = ParseJSON(val)
                    end
                end
            end
        end

        return result
    end

    return str
end

--- Read entire file as string
local function ReadFile(path)
    local ok, content = pcall(function()
        if readfile then
            return readfile(path)
        end
        return nil
    end)
    if ok then return content end
    return nil
end

--- Write string to file
local function WriteFile(path, content)
    local ok = pcall(function()
        if writefile then
            writefile(path, content)
            return true
        end
        if syn and syn.write_file then
            syn.write_file(path, content, true)
            return true
        end
        return false
    end)
    return ok
end

--- Check if file exists
local function FileExists(path)
    local ok, result = pcall(function()
        if isfile then
            return isfile(path)
        end
        return false
    end)
    return ok and result
end

--- Delete file
local function DeleteFile(path)
    pcall(function()
        if delfile then delfile(path) end
    end)
end

--- Get timestamp string
local function GetTimestamp()
    local ok, ts = pcall(function()
        return os.date("%Y-%m-%d %H:%M:%S")
    end)
    return ok and ts or "unknown"
end

--- Merge feature flags, respecting only known keys
local function MergeFeatureFlags(base, override)
    local result = DeepCopy(base)
    if type(override) ~= "table" then return result end
    for k, v in pairs(override) do
        if base[k] ~= nil and type(v) == "boolean" then
            result[k] = v
        end
    end
    return result
end

--- Flatten config tables to a single-level key=value map for diff
local function FlattenConfig(prefix, tbl, out)
    out = out or {}
    for k, v in pairs(tbl) do
        local key = prefix ~= "" and (prefix .. "." .. k) or k
        if type(v) == "table" and not (typeof and typeof(v) == "Color3") then
            FlattenConfig(key, v, out)
        else
            out[key] = v
        end
    end
    return out
end

-- ============================================================================
-- SAVE / LOAD / RESET
-- ============================================================================

--- Save current A.C and A.F to JSON file
function A.SaveConfig()
    local snapshot = {
        version = "13.0.0",
        timestamp = GetTimestamp(),
        config = {},
        flags = {}
    }

    for k, v in pairs(A.C) do
        if k ~= "_Ranges" then
            snapshot.config[k] = v
        end
    end

    for k, v in pairs(A.F) do
        snapshot.flags[k] = v
    end

    local json = SerializeValue(snapshot)
    local success = WriteFile(A.ConfigPath, json)

    if success then
        pcall(function()
            if A.UI and A.UI.Notify then
                A.UI.Notify("Config saved successfully", A.C.Theme.Success, 2)
            end
        end)
    else
        pcall(function()
            if A.UI and A.UI.Notify then
                A.UI.Notify("Failed to save config", A.C.Theme.Error, 3)
            end
        end)
    end

    return success
end

--- Load config from JSON file, merging with defaults
function A.LoadConfig()
    if not FileExists(A.ConfigPath) then
        pcall(function()
            if A.UI and A.UI.Notify then
                A.UI.Notify("No saved config found — using defaults", A.C.Theme.Warning, 3)
            end
        end)
        return false
    end

    local raw = ReadFile(A.ConfigPath)
    if not raw or raw == "" then
        return false
    end

    local ok, parsed = pcall(ParseJSON, raw)
    if not ok or type(parsed) ~= "table" then
        pcall(function()
            if A.UI and A.UI.Notify then
                A.UI.Notify("Failed to parse config file — using defaults", A.C.Theme.Error, 4)
            end
        end)
        return false
    end

    -- Merge config values
    if type(parsed.config) == "table" then
        for k, v in pairs(parsed.config) do
            if k ~= "_Ranges" and A.C[k] ~= nil then
                A.C[k] = v
            end
        end
    end

    -- Merge feature flags
    if type(parsed.flags) == "table" then
        A.F = MergeFeatureFlags(A.F, parsed.flags)
    end

    -- Run validation after loading
    A.ClampValues()
    local issues = A.ValidateConfig()
    if issues and #issues > 0 then
        pcall(function()
            if A.UI and A.UI.Notify then
                A.UI.Notify("Config loaded with " .. #issues .. " auto-corrected value(s)", A.C.Theme.Warning, 3)
            end
        end)
    else
        pcall(function()
            if A.UI and A.UI.Notify then
                A.UI.Notify("Config loaded successfully", A.C.Theme.Success, 2)
            end
        end)
    end

    return true
end

--- Reset all config values and feature flags to defaults
function A.ResetConfig()
    -- Reset config values
    for k, v in pairs(DefaultC) do
        if k ~= "_Ranges" then
            A.C[k] = DeepCopy(v)
        end
    end

    -- Reset feature flags
    for k, _ in pairs(A.F) do
        A.F[k] = false
    end

    -- Delete saved file
    DeleteFile(A.ConfigPath)

    pcall(function()
        if A.UI and A.UI.Notify then
            A.UI.Notify("Config reset to defaults", A.C.Theme.Warning, 2)
        end
    end)

    return true
end

--- Export config as a raw JSON string
function A.ExportConfig()
    local snapshot = {
        version = "13.0.0",
        timestamp = GetTimestamp(),
        config = {},
        flags = {}
    }

    for k, v in pairs(A.C) do
        if k ~= "_Ranges" then
            snapshot.config[k] = v
        end
    end

    for k, v in pairs(A.F) do
        snapshot.flags[k] = v
    end

    return SerializeValue(snapshot)
end

--- Import config from a JSON string
function A.ImportConfig(json)
    if type(json) ~= "string" or json == "" then
        pcall(function()
            if A.UI and A.UI.Notify then
                A.UI.Notify("Invalid import data", A.C.Theme.Error, 3)
            end
        end)
        return false
    end

    local ok, parsed = pcall(ParseJSON, json)
    if not ok or type(parsed) ~= "table" then
        pcall(function()
            if A.UI and A.UI.Notify then
                A.UI.Notify("Failed to parse import JSON", A.C.Theme.Error, 3)
            end
        end)
        return false
    end

    -- Validate version
    if parsed.version and parsed.version ~= "13.0.0" then
        pcall(function()
            if A.UI and A.UI.Notify then
                A.UI.Notify("Config version mismatch: " .. tostring(parsed.version) .. " (expected 13.0.0)", A.C.Theme.Warning, 4)
            end
        end)
    end

    local appliedConfig = 0
    local appliedFlags = 0

    if type(parsed.config) == "table" then
        for k, v in pairs(parsed.config) do
            if k ~= "_Ranges" and A.C[k] ~= nil and type(v) == type(A.C[k]) then
                A.C[k] = v
                appliedConfig = appliedConfig + 1
            end
        end
    end

    if type(parsed.flags) == "table" then
        for k, v in pairs(parsed.flags) do
            if A.F[k] ~= nil and type(v) == "boolean" then
                A.F[k] = v
                appliedFlags = appliedFlags + 1
            end
        end
    end

    A.ClampValues()
    local issues = A.ValidateConfig()

    pcall(function()
        if A.UI and A.UI.Notify then
            A.UI.Notify(
                "Imported " .. appliedConfig .. " config values, " .. appliedFlags .. " flags",
                A.C.Theme.Success, 3
            )
        end
    end)

    return true
end

--- Return a table describing what changed from defaults
function A.GetConfigDiff()
    local diff = {config = {}, flags = {}, summary = {changed = 0, unchanged = 0}}
    local flatCurrent = FlattenConfig("", A.C)
    local flatDefault = FlattenConfig("", DefaultC)

    for k, v in pairs(flatCurrent) do
        if flatDefault[k] ~= nil then
            local defaultVal = flatDefault[k]
            local currentVal = v
            local isEqual = false

            if type(defaultVal) == "table" and typeof and typeof(defaultVal) == "Color3" then
                local cVal = (typeof(currentVal) == "Color3") and currentVal or Color3.new(0, 0, 0)
                isEqual = (math.abs(defaultVal.R - cVal.R) < 0.001)
                    and (math.abs(defaultVal.G - cVal.G) < 0.001)
                    and (math.abs(defaultVal.B - cVal.B) < 0.001)
            elseif type(defaultVal) == "table" and type(currentVal) == "table" then
                -- Shallow comparison for sub-tables
                local allMatch = true
                for dk, dv in pairs(defaultVal) do
                    if currentVal[dk] ~= dv then allMatch = false; break end
                end
                if allMatch then
                    for ck, cv in pairs(currentVal) do
                        if defaultVal[ck] ~= cv then allMatch = false; break end
                    end
                end
                isEqual = allMatch
            else
                isEqual = (defaultVal == currentVal)
            end

            if isEqual then
                diff.summary.unchanged = diff.summary.unchanged + 1
            else
                diff.config[k] = {old = defaultVal, new = currentVal}
                diff.summary.changed = diff.summary.changed + 1
            end
        end
    end

    -- Feature flag diffs
    for k, v in pairs(A.F) do
        local defaultVal = DefaultF[k]
        if defaultVal ~= nil and v ~= defaultVal then
            diff.flags[k] = {old = defaultVal, new = v}
            diff.summary.changed = diff.summary.changed + 1
        else
            diff.summary.unchanged = diff.summary.unchanged + 1
        end
    end

    diff.summary.total = diff.summary.changed + diff.summary.unchanged
    return diff
end

-- ============================================================================
-- VALIDATION & CLAMPING
-- ============================================================================

--- Validate all config values; returns a list of issues found
function A.ValidateConfig()
    local issues = {}

    for key, range in pairs(A.C._Ranges or {}) do
        local val = A.C[key]
        if val == nil then
            issues[#issues + 1] = key .. ": missing value (expected number)"
        elseif type(val) ~= "number" then
            issues[#issues + 1] = key .. ": expected number, got " .. type(val) .. " — resetting to default"
            A.C[key] = DefaultC[key] or range.min
        elseif val ~= val then -- NaN check
            issues[#issues + 1] = key .. ": is NaN — resetting to default"
            A.C[key] = DefaultC[key] or range.min
        elseif val < range.min or val > range.max then
            issues[#issues + 1] = key .. ": " .. tostring(val) .. " outside [" .. range.min .. ", " .. range.max .. "]"
        end
    end

    -- Validate ClickDelay is a positive number
    if type(A.C.ClickDelay) ~= "number" or A.C.ClickDelay <= 0 then
        issues[#issues + 1] = "ClickDelay must be a positive number"
    end

    -- Validate TeleportDelay is a positive number
    if type(A.C.TeleportDelay) ~= "number" or A.C.TeleportDelay <= 0 then
        issues[#issues + 1] = "TeleportDelay must be a positive number"
    end

    -- Validate AttackComboDelay is a table with 3 numbers
    if type(A.C.AttackComboDelay) ~= "table" or #A.C.AttackComboDelay ~= 3 then
        issues[#issues + 1] = "AttackComboDelay must be an array of 3 numbers"
        A.C.AttackComboDelay = {0.02, 0.05, 0.08}
    else
        for i, v in ipairs(A.C.AttackComboDelay) do
            if type(v) ~= "number" or v < 0 or v > 5 then
                issues[#issues + 1] = "AttackComboDelay[" .. i .. "] invalid"
                A.C.AttackComboDelay[i] = 0.02 * i
            end
        end
    end

    -- Validate SelectedFruitAction
    local validActions = {Notify = true, Store = true, Drop = true, Eat = true, Trade = true, Sniper = true}
    if not validActions[A.C.SelectedFruitAction] then
        issues[#issues + 1] = "SelectedFruitAction '" .. tostring(A.C.SelectedFruitAction) .. "' is not valid"
A.C.SelectedFruitAction = "Notify"
A.C.BountyRange = 1000
A.C.ComboMode = "Basic"
A.C.FarmMode = "Default"
A.C.SelectedIsland = ""
A.C.StatBuild = "Melee"
A.C.TargetMode = "Nearest"
    end

    -- Validate SelectedBypassLevel
    if type(A.C.SelectedBypassLevel) ~= "number" then
        issues[#issues + 1] = "SelectedBypassLevel must be a number"
        A.C.SelectedBypassLevel = 4
    elseif not A.C.AntiCheatBypass[A.C.SelectedBypassLevel] then
        issues[#issues + 1] = "SelectedBypassLevel " .. A.C.SelectedBypassLevel .. " does not exist (1-7)"
        A.C.SelectedBypassLevel = 4
    end

    -- Validate Theme is a table with required keys
    local themeKeys = {"Primary", "Secondary", "Accent", "Text", "Success", "Warning", "Error"}
    if type(A.C.Theme) ~= "table" then
        issues[#issues + 1] = "Theme must be a table"
    else
        for _, key in ipairs(themeKeys) do
            if not A.C.Theme[key] then
                issues[#issues + 1] = "Theme missing key: " .. key
            elseif typeof and typeof(A.C.Theme[key]) ~= "Color3" then
                issues[#issues + 1] = "Theme." .. key .. " must be Color3"
            end
        end
    end

    -- Validate Keybinds is a table with required keys
    local requiredKeybinds = {"ToggleUI", "AutoFarm", "KillAura", "ESP", "Fly", "Noclip", "BossFarm"}
    if type(A.C.Keybinds) ~= "table" then
        issues[#issues + 1] = "Keybinds must be a table"
    else
        for _, key in ipairs(requiredKeybinds) do
            if not A.C.Keybinds[key] then
                issues[#issues + 1] = "Keybinds missing required key: " .. key
            end
        end
    end

    -- Validate DiscordWebhook format
    if A.C.DiscordWebhook ~= "" then
        local isHttp = A.C.DiscordWebhook:match("^https?://discord%.com/api/webhooks/") or
                        A.C.DiscordWebhook:match("^https?://discordapp%.com/api/webhooks/")
        if not isHttp then
            issues[#issues + 1] = "DiscordWebhook does not appear to be a valid webhook URL"
        end
    end

    -- Validate FruitsToNotify is a table
    if type(A.C.FruitsToNotify) ~= "table" then
        issues[#issues + 1] = "FruitsToNotify must be a table of strings"
        A.C.FruitsToNotify = {}
    end

    -- Validate all feature flags are booleans
    for k, v in pairs(A.F) do
        if type(v) ~= "boolean" then
            issues[#issues + 1] = "Feature flag '" .. k .. "' is " .. type(v) .. " (expected boolean)"
            A.F[k] = false
        end
    end

    return issues
end

--- Clamp all numeric config values to their valid ranges
function A.ClampValues()
    for key, range in pairs(A.C._Ranges or {}) do
        local val = A.C[key]
        if type(val) == "number" then
            if val ~= val then -- NaN
                A.C[key] = range.min
            elseif val < range.min then
                A.C[key] = range.min
            elseif val > range.max then
                A.C[key] = range.max
            end
        end
    end

    -- Clamp AttackComboDelay values
    if type(A.C.AttackComboDelay) == "table" then
        for i = 1, #A.C.AttackComboDelay do
            if type(A.C.AttackComboDelay[i]) == "number" then
                A.C.AttackComboDelay[i] = math.max(0, math.min(5, A.C.AttackComboDelay[i]))
            else
                A.C.AttackComboDelay[i] = 0.02 * i
            end
        end
    end

    -- Clamp Theme Color3 values
    if type(A.C.Theme) == "table" then
        for k, v in pairs(A.C.Theme) do
            if typeof and typeof(v) == "Color3" then
                local r = math.max(0, math.min(1, v.R))
                local g = math.max(0, math.min(1, v.G))
                local b = math.max(0, math.min(1, v.B))
                A.C.Theme[k] = Color3.new(r, g, b)
            end
        end
    end

    return true
end

--- Check for conflicting feature flag combinations and warn
function A.CheckConflicts()
    local conflicts = {}

    -- Speed conflicts
    if A.F.Speed and A.F.SpeedHack then
        conflicts[#conflicts + 1] = {
            severity = "warning",
            message = "Speed and SpeedHack are both enabled — SpeedHack takes priority",
            flags = {"Speed", "SpeedHack"}
        }
    end

    -- KillAura conflicts
    if A.F.KillAura and A.F.KillAuraMobs and A.F.KillAuraPlayers then
        conflicts[#conflicts + 1] = {
            severity = "info",
            message = "KillAura targeting both mobs and players",
            flags = {"KillAura", "KillAuraMobs", "KillAuraPlayers"}
        }
    end

    -- Farm conflicts
    local farmCount = 0
    local farmFlags = {"AutoFarm", "AutoFarmChest", "AutoFarmBone", "AutoFarmCandy", "AutoFarmMaterial"}
    for _, f in ipairs(farmFlags) do
        if A.F[f] then farmCount = farmCount + 1 end
    end
    if farmCount > 2 then
        conflicts[#conflicts + 1] = {
            severity = "warning",
            message = farmCount .. " farm modes active simultaneously — may cause conflicts",
            flags = farmFlags
        }
    end

    -- Sea event conflicts
    local seaCount = 0
    local seaFlags = {"SeaBeast", "TerrorShark", "SharkAnchor", "FrozenDimension", "PrehistoricIsland", "MirrorDimension"}
    for _, f in ipairs(seaFlags) do
        if A.F[f] then seaCount = seaCount + 1 end
    end
    if seaCount > 1 then
        conflicts[#conflicts + 1] = {
            severity = "info",
            message = seaCount .. " sea events active",
            flags = seaFlags
        }
    end

    -- Raid conflicts
    if A.F.AutoRaid and A.F.AutoRaidAll then
        conflicts[#conflicts + 1] = {
            severity = "warning",
            message = "AutoRaid and AutoRaidAll both enabled — AutoRaidAll takes priority",
            flags = {"AutoRaid", "AutoRaidAll"}
        }
    end

    -- V4 conflicts
    if A.F.AutoActiveV4 and A.F.AutoActiveV4Full then
        conflicts[#conflicts + 1] = {
            severity = "info",
            message = "Both V4 and V4Full active — V4Full takes priority",
            flags = {"AutoActiveV4", "AutoActiveV4Full"}
        }
    end

    -- Mastery conflicts
    if A.F.AutoMastery and (A.F.AutoMasteryFruit or A.F.AutoMasterySword or A.F.AutoMasteryGun or A.F.AutoMasteryMelee) then
        conflicts[#conflicts + 1] = {
            severity = "info",
            message = "AutoMastery enabled alongside specific mastery types",
            flags = {"AutoMastery", "AutoMasteryFruit", "AutoMasterySword", "AutoMasteryGun", "AutoMasteryMelee"}
        }
    end

    -- Combat AI conflicts
    local combatCount = 0
    local combatFlags = {"CombatAI", "AutoCounter", "SmartDodge", "AdaptiveCombo", "PredictionCombat"}
    for _, f in ipairs(combatFlags) do
        if A.F[f] then combatCount = combatCount + 1 end
    end
    if combatCount > 3 then
        conflicts[#conflicts + 1] = {
            severity = "warning",
            message = combatCount .. " combat AI features active — may impact performance",
            flags = combatFlags
        }
    end

    -- Stealth + loud operations
    if A.F.StealthMovement and A.F.AntiDetection then
        conflicts[#conflicts + 1] = {
            severity = "info",
            message = "Stealth and AntiDetection both active — optimal stealth mode",
            flags = {"StealthMovement", "AntiDetection"}
        }
    end

    -- GodMode with AutoPilot
    if A.F.GodMode and A.F.AutoPilot then
        conflicts[#conflicts + 1] = {
            severity = "info",
            message = "GodMode active with AutoPilot — extra protection enabled",
            flags = {"GodMode", "AutoPilot"}
        }
    end

    -- MegaFarm with specific farms
    if A.F.MegaFarm and A.F.AutoFarm then
        conflicts[#conflicts + 1] = {
            severity = "warning",
            message = "MegaFarm overrides individual AutoFarm settings",
            flags = {"MegaFarm", "AutoFarm"}
        }
    end

    -- Fly with Noclip
    if A.F.Fly and A.F.Noclip then
        conflicts[#conflicts + 1] = {
            severity = "info",
            message = "Fly enabled with Noclip — Noclip redundant while flying",
            flags = {"Fly", "Noclip"}
        }
    end

    -- AntiCheat level 7 with fast operations
    if A.C.SelectedBypassLevel == 7 then
        local fastOps = A.C.ClickDelay < 0.05 or A.C.TweenSpeed > 500
        if fastOps then
            conflicts[#conflicts + 1] = {
                severity = "critical",
                message = "Ghost-level bypass with fast delays — high detection risk",
                flags = {"SelectedBypassLevel"}
            }
        end
    end

    return conflicts
end

-- ============================================================================
-- INITIALIZATION — store defaults for later comparison
-- ============================================================================
local function StoreDefaults()
    for k, v in pairs(A.C) do
        if k ~= "_Ranges" then
            DefaultC[k] = DeepCopy(v)
        end
    end
    for k, v in pairs(A.F) do
        DefaultF[k] = v
    end
end

StoreDefaults()

-- ============================================================================
-- MODULE REGISTRATION
-- ============================================================================
if A.Register then
    A.Register("config", A)
end

-- ============================================================================
-- EXPOSE TO GLOBAL SCOPE
-- ============================================================================
if _G.Apex then
    for k, v in pairs(A) do
        _G.Apex[k] = v
    end
end

return A
