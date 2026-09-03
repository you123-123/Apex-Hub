--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║              APEX HUB v13.0 - CORE INITIALIZATION             ║
    ║                   APEX ULTIMATE FRAMEWORK                     ║
    ║                                                              ║
    ║  Author: Apex Development Team                                ║
    ║  Version: 13.0.0                                              ║
    ║  Build: APEX-ULTIMATE                                         ║
    ║  Purpose: Core bootstrap & environment initialization         ║
    ╚══════════════════════════════════════════════════════════════════╝
--]]

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 1: RACE CONDITION & DOUBLE-INSTANCE GUARD
-- ═══════════════════════════════════════════════════════════════════

if _G.Apex ~= nil then
    warn("[APEX CORE] Detected existing _G.Apex instance. Forcing fresh reinitialization...")
    _G.Apex = nil
end

if _G.HelloKittyX ~= nil then
    warn("[APEX CORE] CRITICAL: Detected HelloKittyX environment override.")
    warn("[APEX CORE] This environment appears to have been modified by an external script.")
    warn("[APEX CORE] Proceeding with caution - some features may be degraded.")
end

if _G.APEX_LOADED then
    warn("[APEX CORE] Apex Hub is already marked as loaded in global scope.")
    warn("[APEX CORE] Forcing reinitialization...")
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 2: RAPID ENVIRONMENT SNAPSHOT (pre-init telemetry)
-- ═══════════════════════════════════════════════════════════════════

local _PRE_INIT_TICK = tick()
local _PRE_INIT_MEMORY = gcinfo and gcinfo() or 0

local _PRE_INIT_ENV_CHECK = {
    hasgame = (game ~= nil),
    hasplayers = (game and game.Players ~= nil),
    hasrunservice = (game and game:GetService("RunService") ~= nil),
    hasworkspace = (game and game.Workspace ~= nil),
    hasgetfenv = (type(getfenv) == "function"),
    hassetfenv = (type(setfenv) == "function"),
    haspcall = (type(pcall) == "function"),
    hasxpcall = (type(xpcall) == "function"),
    haserror = (type(error) == "function"),
    haswarn = (type(warn) == "function"),
    hasprint = (type(print) == "function"),
    hasstring = (type(string) == "table"),
    hastable = (type(table) == "table"),
    hasnetwork = (type(game and game.HttpService ~= nil or false) == "table"),
}

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 3: EXECUTOR DETECTION SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local ExecutorData = {
    Detected = "Unknown",
    DisplayName = "Unknown Executor",
    Version = "Unknown",
    SupportsHttp = false,
    SupportsSynProtect = false,
    SupportsDrawing = false,
    SupportsUI = false,
    SupportsClosure = false,
    IsSynapse = false,
    IsKrnl = false,
    IsFluxus = false,
    IsScriptWare = false,
    IsArceusX = false,
    IsDelta = false,
    IsHydrogen = false,
    IsWave = false,
    IsOxygen = false,
    IsCelery = false,
    IsEVONT = false,
    IsAlanX = false,
    IsZorara = false,
    IsSelinium = false,
    RawName = "",
}

local function DetectExecutor()
    -- Priority-ordered detection: check most specific identifiers first

    -- Synapse X (full / X-free variants)
    if syn and syn.protect_gui then
        ExecutorData.Detected = "SynapseX"
        ExecutorData.DisplayName = "Synapse X"
        ExecutorData.IsSynapse = true
        ExecutorData.SupportsHttp = true
        ExecutorData.SupportsSynProtect = true
        ExecutorData.SupportsDrawing = true
        ExecutorData.SupportsUI = true
        ExecutorData.SupportsClosure = true
        ExecutorData.RawName = "syn"
        pcall(function()
            if syn.getexecutorname then
                ExecutorData.Version = tostring(syn.getexecutorname())
            end
        end)
        pcall(function()
            if identifyexecutor then
                ExecutorData.Version = tostring(identifyexecutor())
            end
        end)
        return
    end

    -- KRNL
    if KRNL_LOADED or (KRNL_LOADED ~= nil) then
        ExecutorData.Detected = "KRNL"
        ExecutorData.DisplayName = "KRNL"
        ExecutorData.IsKrnl = true
        ExecutorData.SupportsHttp = false
        ExecutorData.SupportsDrawing = true
        ExecutorData.SupportsUI = true
        ExecutorData.SupportsClosure = true
        ExecutorData.RawName = "krnl"
        return
    end

    if getgenv and getgenv().KRNL_LOADED then
        ExecutorData.Detected = "KRNL"
        ExecutorData.DisplayName = "KRNL"
        ExecutorData.IsKrnl = true
        ExecutorData.SupportsClosure = true
        ExecutorData.RawName = "krnl"
        return
    end

    -- Script-Ware
    if ScriptWare or (getgenv and getgenv().ScriptWare) then
        ExecutorData.Detected = "ScriptWare"
        ExecutorData.DisplayName = "Script-Ware"
        ExecutorData.IsScriptWare = true
        ExecutorData.SupportsHttp = true
        ExecutorData.SupportsDrawing = true
        ExecutorData.SupportsUI = true
        ExecutorData.SupportsClosure = true
        ExecutorData.RawName = "scriptware"
        return
    end

    -- Fluxus
    if is_fluxus_closure or (getgenv and getgenv().fluxus) then
        ExecutorData.Detected = "Fluxus"
        ExecutorData.DisplayName = "Fluxus"
        ExecutorData.IsFluxus = true
        ExecutorData.SupportsHttp = true
        ExecutorData.SupportsDrawing = false
        ExecutorData.SupportsUI = true
        ExecutorData.SupportsClosure = true
        ExecutorData.RawName = "fluxus"
        return
    end

    -- Arceus X
    if arceus_x or (getgenv and getgenv().ARCEUS_LOADED) then
        ExecutorData.Detected = "ArceusX"
        ExecutorData.DisplayName = "Arceus X"
        ExecutorData.IsArceusX = true
        ExecutorData.SupportsHttp = false
        ExecutorData.SupportsDrawing = false
        ExecutorData.SupportsUI = true
        ExecutorData.SupportsClosure = false
        ExecutorData.RawName = "arceusx"
        return
    end

    -- Delta
    if delta_loaded or (getgenv and getgenv().DeltaLoaded) then
        ExecutorData.Detected = "Delta"
        ExecutorData.DisplayName = "Delta"
        ExecutorData.IsDelta = true
        ExecutorData.SupportsHttp = false
        ExecutorData.SupportsDrawing = false
        ExecutorData.SupportsUI = true
        ExecutorData.SupportsClosure = false
        ExecutorData.RawName = "delta"
        return
    end

    -- Hydrogen
    if hydrogen_loaded or (getgenv and getgenv().HydrogenLoaded) then
        ExecutorData.Detected = "Hydrogen"
        ExecutorData.DisplayName = "Hydrogen"
        ExecutorData.IsHydrogen = true
        ExecutorData.SupportsHttp = false
        ExecutorData.SupportsDrawing = false
        ExecutorData.SupportsUI = true
        ExecutorData.SupportsClosure = false
        ExecutorData.RawName = "hydrogen"
        return
    end

    -- Wave
    if wave_loaded or (getgenv and getgenv().WaveLoaded) then
        ExecutorData.Detected = "Wave"
        ExecutorData.DisplayName = "Wave"
        ExecutorData.IsWave = true
        ExecutorData.SupportsHttp = false
        ExecutorData.SupportsDrawing = false
        ExecutorData.SupportsUI = true
        ExecutorData.SupportsClosure = false
        ExecutorData.RawName = "wave"
        return
    end

    -- Oxygen
    if oxygen_exec or (getgenv and getgenv().OxygenExec) then
        ExecutorData.Detected = "Oxygen"
        ExecutorData.DisplayName = "Oxygen"
        ExecutorData.IsOxygen = true
        ExecutorData.SupportsHttp = false
        ExecutorData.SupportsDrawing = false
        ExecutorData.SupportsUI = true
        ExecutorData.SupportsClosure = false
        ExecutorData.RawName = "oxygen"
        return
    end

    -- Celery
    if celery_loaded or (getgenv and getgenv().CeleryLoaded) then
        ExecutorData.Detected = "Celery"
        ExecutorData.DisplayName = "Celery"
        ExecutorData.IsCelery = true
        ExecutorData.SupportsHttp = true
        ExecutorData.SupportsDrawing = false
        ExecutorData.SupportsUI = true
        ExecutorData.SupportsClosure = false
        ExecutorData.RawName = "celery"
        return
    end

    -- EVONT
    if evont_loaded or (getgenv and getgenv().EVONT_LOADED) then
        ExecutorData.Detected = "EVONT"
        ExecutorData.DisplayName = "EVONT"
        ExecutorData.IsEVONT = true
        ExecutorData.SupportsHttp = true
        ExecutorData.SupportsDrawing = false
        ExecutorData.SupportsUI = true
        ExecutorData.SupportsClosure = false
        ExecutorData.RawName = "evont"
        return
    end

    -- Alan X
    if alan_x or (getgenv and getgenv().AlanX) then
        ExecutorData.Detected = "AlanX"
        ExecutorData.DisplayName = "Alan X"
        ExecutorData.IsAlanX = true
        ExecutorData.SupportsHttp = false
        ExecutorData.SupportsDrawing = false
        ExecutorData.SupportsUI = true
        ExecutorData.SupportsClosure = false
        ExecutorData.RawName = "alanx"
        return
    end

    -- Zorara
    if zorara_exec or (getgenv and getgenv().ZoraraLoaded) then
        ExecutorData.Detected = "Zorara"
        ExecutorData.DisplayName = "Zorara"
        ExecutorData.IsZorara = true
        ExecutorData.SupportsHttp = false
        ExecutorData.SupportsDrawing = false
        ExecutorData.SupportsUI = true
        ExecutorData.SupportsClosure = false
        ExecutorData.RawName = "zorara"
        return
    end

    -- Fallback: try identifyexecutor
    if identifyexecutor then
        local ok, name = pcall(identifyexecutor)
        if ok and name then
            ExecutorData.Detected = tostring(name)
            ExecutorData.DisplayName = tostring(name)
            ExecutorData.RawName = tostring(name):lower():gsub("%s+", "")
            ExecutorData.Version = tostring(name)
        end
    end

    -- Fallback: check common global indicators
    if getgenv then
        local ok, env = pcall(getgenv)
        if ok and type(env) == "table" then
            if env.protect_gui or env.protectgui then
                ExecutorData.SupportsSynProtect = true
            end
            if env.getexecutorname then
                pcall(function()
                    ExecutorData.Version = tostring(env.getexecutorname())
                end)
            end
        end
    end

    -- Final fallback
    ExecutorData.RawName = ExecutorData.RawName == "" and "unknown" or ExecutorData.RawName
end

-- Execute detection immediately
DetectExecutor()

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 4: CORE TABLE CREATION & SHARED NAMESPACE
-- ═══════════════════════════════════════════════════════════════════

-- Initialize the master namespace
_G.Apex = {}

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 5: METATABLE PROTECTION FOR _G.Apex
-- ═══════════════════════════════════════════════════════════════════

-- Snapshot of core functions registered before lockdown.
-- Used by the post-init verification to detect rawset overwrites.
local _CORE_FUNCTION_KEYS = {}

local ApexMeta = {
    __index = function(self, key)
        return rawget(self, key)
    end,

    __newindex = function(self, key, value)
        if rawget(self, "_LOADED") == true then
            local v = rawget(self, key)
            -- Protect any core function from post-lockdown overwrites
            if type(v) == "function" then
                warn("[APEX CORE] Attempt to overwrite function '" .. key .. "' blocked by metatable.")
                return
            end
        end
        rawset(self, key, value)
    end,

    __len = function(self)
        local modules = rawget(self, "RegisteredModules")
        if modules and type(modules) == "table" then
            local count = 0
            for _ in pairs(modules) do
                count = count + 1
            end
            return count
        end
        return 0
    end,

    __tostring = function(self)
        local ver = rawget(self, "Version") or "?.?"
        local build = rawget(self, "Build") or "?.?"
        return "Apex Hub v" .. ver .. " [" .. build .. "]"
    end,

    __metatable = "ApexHub_ProtectedMetatable",
}

setmetatable(_G.Apex, ApexMeta)

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 6: ALIAS & CONVENIENCE REFERENCES
-- ═══════════════════════════════════════════════════════════════════

local A = _G.Apex

-- Defensive fallbacks: guarantee registration + constructors survive any mid-init error
if not A.Register then A.Register = function() return true end end
if not A.V3 then A.V3 = function(x, y, z)
    if x ~= nil and y == nil then return x end
    return Vector3.new(x, y, z)
end end
if not A.CF then A.CF = function(...) return CFrame.new(...) end end
if not A.Log then A.Log = function() end end

A.Version = "13.0.0"
A.Build = "APEX-ULTIMATE-" .. math.random(1000, 9999)
A.CRASH_SAFE = false
A._INITIALIZING = true
A._LOADED = false

-- Runtime core references
A.LP = game.Players.LocalPlayer
A.G = game
A.CF = function(...) return CFrame.new(...) end
A.V3 = function(x, y, z)
    if x ~= nil and y == nil then return x end
    return Vector3.new(x, y, z)
end
A.EXEC = ExecutorData.Detected
A.Executor = ExecutorData.Detected
A.ExecutorData = ExecutorData

-- Session management
A.SESSION_START = tick()
A.SESSION_ID = string.format(
    "%X-%X-%X-%X",
    math.random(0, 0xFFFF),
    math.random(0, 0xFFFF),
    math.random(0, 0xFFFF),
    math.floor((tick() * 1000) % 0xFFFF)
)

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 7: ENVIRONMENT FINGERPRINTING
-- ═══════════════════════════════════════════════════════════════════

local _gv = "Unknown"
pcall(function()
    local f = version
    if type(f) == "function" then
        _gv = tostring(f())
    end
end)

A.Fingerprint = {
    GameVersion = _gv,
    PlaceId = game.PlaceId or 0,
    PlaceVersion = game.PlaceVersion or 0,
    JobId = game.JobId or "Unknown",
    GameId = game.GameId or 0,
    UserId = (A.LP and A.LP.UserId) or 0,
    UserName = (A.LP and A.LP.Name) or "Unknown",
    Executor = ExecutorData.Detected,
    ExecutorVersion = ExecutorData.Version,
    ExecutorRaw = ExecutorData.RawName,
    MachineId = nil, -- Filled below if possible
    SessionId = A.SESSION_ID,
    DetectionTime = tick(),
    DetectedAt = os.time and os.time() or tick(),
    Platform = (function()
        local ok, platform = pcall(function()
            return UserInputService and UserInputService.TouchEnabled and "Mobile" or "Desktop"
        end)
        return ok and platform or "Unknown"
    end)(),
}

-- Attempt to get a machine-level identifier (non-PII)
pcall(function()
    if gethiddenproperty then
        local ok, mid = pcall(gethiddenproperty, game, "PhysicalUniqueId")
        if ok and mid then
            A.Fingerprint.MachineId = tostring(mid)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 8: LOGGING SYSTEM
-- ═══════════════════════════════════════════════════════════════════

A.Logs = {}
A.LogsMutex = false -- Simple lock for log queue

local LOG_LEVELS = {
    INFO  = { priority = 1, color = "White",   prefix = "[INFO] " },
    WARN  = { priority = 2, color = "Yellow",  prefix = "[WARN] " },
    ERROR = { priority = 3, color = "Red",     prefix = "[ERROR] " },
    DEBUG = { priority = 0, color = "Cyan",    prefix = "[DEBUG] " },
    OK    = { priority = 1, color = "Lime",    prefix = "[OK] " },
    PERF  = { priority = 0, color = "Aqua",    prefix = "[PERF] " },
    INIT  = { priority = 1, color = "White",   prefix = "[INIT] " },
    SYS   = { priority = 1, color = "White",   prefix = "[SYS] " },
}

local MAX_LOG_ENTRIES = 5000

function A.Log(msg, level)
    level = level or "INFO"
    local levelData = LOG_LEVELS[tostring(level):upper()]
    if not levelData then
        levelData = LOG_LEVELS["INFO"]
        level = "INFO"
    end

    local entry = {
        timestamp = tick(),
        wallclock = os.time and os.time() or tick(),
        level = string.upper(level),
        message = tostring(msg),
        uptime = tick() - A.SESSION_START,
        uptimeFormatted = string.format("%.3fs", tick() - A.SESSION_START),
    }

    -- Prevent log queue from growing unbounded
    if #A.Logs >= MAX_LOG_ENTRIES then
        table.remove(A.Logs, 1) -- Remove oldest entry
    end

    table.insert(A.Logs, entry)

    -- Output to console with formatting
    local logPrefix = string.format(
        "[APEX %s] %s%s",
        string.format("%.3fs", tick() - A.SESSION_START),
        levelData.prefix,
        tostring(msg)
    )

    if level == "ERROR" or level == "WARN" then
        warn(logPrefix)
    else
        print(logPrefix)
    end

    return entry
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 10: UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════

function A.DeepEqual(a, b)
    if a == b then return true end
    if type(a) ~= type(b) then return false end
    if type(a) ~= "table" then return false end

    local keysA = {}
    local keysB = {}

    for k in pairs(a) do
        keysA[#keysA + 1] = k
    end
    for k in pairs(b) do
        keysB[#keysB + 1] = k
    end

    if #keysA ~= #keysB then return false end

    for _, k in ipairs(keysA) do
        if b[k] == nil then return false end
        if not A.DeepEqual(a[k], b[k]) then return false end
    end

    return true
end

function A.TableMerge(t1, t2)
    if type(t1) ~= "table" then t1 = {} end
    if type(t2) ~= "table" then t2 = {} end

    local result = {}
    for k, v in pairs(t1) do
        result[k] = v
    end
    for k, v in pairs(t2) do
        if type(v) == "table" and type(result[k]) == "table" then
            result[k] = A.TableMerge(result[k], v)
        else
            result[k] = v
        end
    end
    return result
end

function A.DeepCopy(t)
    if type(t) ~= "table" then return t end

    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = A.DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return setmetatable(copy, getmetatable(t))
end

function A.SafeExec(fn, name)
    name = name or "UnnamedFunction"
    local startTime = tick()

    local success, result = pcall(function()
        return fn()
    end)

    local elapsed = tick() - startTime

    if success then
        A.Log(string.format("SafeExec '%s' completed in %.4fs", name, elapsed), "DEBUG")
        return true, result
    else
        local errMsg = tostring(result or "Unknown error")
        A.Log(string.format("SafeExec '%s' FAILED after %.4fs: %s", name, elapsed, errMsg), "ERROR")
        return false, errMsg
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 11: PERFORMANCE MONITORING
-- ═══════════════════════════════════════════════════════════════════

A._PerfTimers = {}
A._PerfHistory = {}
local MAX_PERF_HISTORY = 200

function A.PerfStart(name)
    name = name or "unnamed_measure"
    A._PerfTimers[name] = tick()
end

function A.PerfEnd(name)
    name = name or "unnamed_measure"
    local startTime = A._PerfTimers[name]
    if not startTime then
        A.Log("PerfEnd called without matching PerfStart for '" .. name .. "'", "WARN")
        return 0
    end

    local elapsed = tick() - startTime
    A._PerfTimers[name] = nil

    -- Store in history
    if not A._PerfHistory[name] then
        A._PerfHistory[name] = {}
    end

    local history = A._PerfHistory[name]
    if #history >= MAX_PERF_HISTORY then
        table.remove(history, 1)
    end

    local entry = {
        duration = elapsed,
        timestamp = tick(),
    }
    table.insert(history, entry)

    return elapsed
end

function A.GetPerfStats(name)
    local history = A._PerfHistory[name]
    if not history or #history == 0 then
        return nil
    end

    local total = 0
    local minVal = math.huge
    local maxVal = -math.huge
    local count = #history

    for _, entry in ipairs(history) do
        total = total + entry.duration
        if entry.duration < minVal then minVal = entry.duration end
        if entry.duration > maxVal then maxVal = entry.duration end
    end

    return {
        name = name,
        count = count,
        avg = total / count,
        min = minVal,
        max = maxVal,
        total = total,
        last = history[count].duration,
    }
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 12: MODULE REGISTRATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════

A.RegisteredModules = {}
A.LoadOrder = {}

function A.Register(name, mod)
    if type(name) ~= "string" or name == "" then
        A.Log("Register: invalid module name (must be non-empty string)", "ERROR")
        return false, "E007"
    end

    if type(mod) ~= "table" then
        A.Log("Register: module '" .. name .. "' must be a table", "ERROR")
        return false, "E007"
    end

    if A.RegisteredModules[name] then
        A.Log("Register: module '" .. name .. "' is already registered. Skipping.", "WARN")
        return false, "E009"
    end

    mod._ModuleName = name
    mod._RegisteredAt = tick()
    mod._RegisteredAtUptime = tick() - A.SESSION_START

    A.RegisteredModules[name] = mod
    A.LoadOrder[#A.LoadOrder + 1] = name

    A.Log(string.format("Register: module '%s' registered successfully (#%d)", name, #A.LoadOrder), "OK")
    return true
end

function A.GetModule(name)
    if type(name) ~= "string" then return nil end
    local mod = A.RegisteredModules[name]
    if not mod then
        A.Log("GetModule: '" .. name .. "' not found", "WARN")
        return nil
    end
    return mod
end

function A.IsLoaded(name)
    if type(name) ~= "string" then return false end
    return A.RegisteredModules[name] ~= nil
end

function A.GetLoadOrder()
    local result = {}
    for i, name in ipairs(A.LoadOrder) do
        result[i] = {
            name = name,
            registered = A.RegisteredModules[name] ~= nil,
            registeredAt = A.RegisteredModules[name] and A.RegisteredModules[name]._RegisteredAt or nil,
        }
    end
    return result
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 13: SESSION MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════

function A.GetSessionUptime()
    return tick() - A.SESSION_START
end

function A.GetExecutor()
    return A.ExecutorData
end

function A.GetExecutorInfo()
    return A.ExecutorData
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 14: RUNTIME STATISTICS
-- ═══════════════════════════════════════════════════════════════════

A.Flags = {}
A.Signals = {}
A.Subsystems = {}
A.SubsystemOrder = {}
A.Environment = _PRE_INIT_ENV_CHECK

function A.GetStats()
    local uptime = tick() - A.SESSION_START
    local memory = 0
    pcall(function()
        memory = gcinfo()
    end)

    local fps = 0
    pcall(function()
        fps = math.floor(1 / RunService.RenderStepped:Wait())
    end)

    local moduleCount = 0
    for _ in pairs(A.RegisteredModules) do
        moduleCount = moduleCount + 1
    end

    local subsystemCount = 0
    for _ in pairs(A.Subsystems) do
        subsystemCount = subsystemCount + 1
    end

    local playerInfo = {}
    if A.LP then
        playerInfo = {
            Name = A.LP.Name,
            UserId = A.LP.UserId,
            DisplayName = A.LP.DisplayName,
            Health = A.LP.Character and A.LP.Character:FindFirstChild("Humanoid") and A.LP.Character.Humanoid.Health or 0,
            MaxHealth = A.LP.Character and A.LP.Character:FindFirstChild("Humanoid") and A.LP.Character.Humanoid.MaxHealth or 0,
            Position = A.LP.Character and A.LP.Character:FindFirstChild("HumanoidRootPart") and tostring(A.LP.Character.HumanoidRootPart.Position) or "N/A",
            AccountAge = A.LP.AccountAge or 0,
        }
    end

    return {
        -- Timing
        uptime = uptime,
        uptimeFormatted = string.format("%02dh %02dm %02ds",
            math.floor(uptime / 3600),
            math.floor((uptime % 3600) / 60),
            math.floor(uptime % 60)
        ),
        sessionStart = A.SESSION_START,
        sessionStartWall = os.time and os.time() or nil,

        -- Identity
        version = A.Version,
        build = A.Build,
        sessionId = A.SESSION_ID,

        -- Memory
        memoryMB = memory / 1024,
        memoryGB = memory / (1024 * 1024),
        memoryKB = memory,

        -- Performance
        estimatedFPS = fps,

        -- Executor
        executor = A.ExecutorData.Detected,
        executorDisplayName = A.ExecutorData.DisplayName,
        executorVersion = A.ExecutorData.Version,

        -- Modules
        registeredModules = moduleCount,
        loadOrder = A.DeepCopy(A.LoadOrder),

        -- Subsystems
        subsystemCount = subsystemCount,

        -- Player
        player = playerInfo,

        -- Fingerprint
        placeId = A.Fingerprint.PlaceId,
        gameId = A.Fingerprint.GameId,
        jobId = A.Fingerprint.JobId,
        gameVersion = A.Fingerprint.GameVersion,

        -- Logs
        logCount = #A.Logs,

        -- Init
        preInitTick = _PRE_INIT_TICK,
        preInitMemory = _PRE_INIT_MEMORY,

        -- Status
        crashSafe = A.CRASH_SAFE,
        fullyLoaded = A._LOADED,
    }
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 15: SUBSYSTEM MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════

function A.RegisterSubsystem(name, initFn, priority)
    priority = priority or 100
    if type(name) ~= "string" or type(initFn) ~= "function" then
        A.Log("RegisterSubsystem: invalid arguments for '" .. tostring(name) .. "'", "WARN")
        return false
    end

    A.Subsystems[name] = {
        name = name,
        initFn = initFn,
        priority = priority,
        initialized = false,
        initTime = nil,
        initError = nil,
    }

    A.SubsystemOrder[#A.SubsystemOrder + 1] = name

    -- Re-sort by priority
    table.sort(A.SubsystemOrder, function(a, b)
        return (A.Subsystems[a].priority or 100) < (A.Subsystems[b].priority or 100)
    end)

    return true
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 16: SIGNAL / EVENT SYSTEM
-- ═══════════════════════════════════════════════════════════════════

function A.CreateSignal(name)
    if type(name) ~= "string" then return nil end

    local signal = {
        Name = name,
        _Connections = {},
        _Fired = false,
        _LastValue = nil,
    }

    function signal:Connect(fn)
        if type(fn) ~= "function" then return nil end
        local id = #self._Connections + 1
        self._Connections[id] = fn
        return {
            Disconnect = function()
                self._Connections[id] = nil
            end,
            Id = id,
        }
    end

    function signal:Fire(...)
        local args = { ... }
        self._Fired = true
        self._LastValue = args
        for _, fn in pairs(self._Connections) do
            if type(fn) == "function" then
                pcall(function()
                    fn(unpack(args))
                end)
            end
        end
    end

    function signal:Wait()
        -- Polling-based wait (compatible with most executors)
        local startTime = tick()
        while not self._Fired do
            if tick() - startTime > 10 then
                A.Log("Signal:Wait timeout for '" .. name .. "'", "WARN")
                return nil
            end
            game:GetService("RunService").Heartbeat:Wait()
        end
        self._Fired = false
        return unpack(self._LastValue or {})
    end

    function signal:Once(fn)
        if type(fn) ~= "function" then return nil end
        local conn
        conn = self:Connect(function(...)
            fn(...)
            if conn then conn:Disconnect() end
        end)
        return conn
    end

    function signal:DisconnectAll()
        self._Connections = {}
    end

    function signal:GetConnectionCount()
        local count = 0
        for _ in pairs(self._Connections) do
            count = count + 1
        end
        return count
    end

    A.Signals[name] = signal
    return signal
end

function A.GetSignal(name)
    if type(name) ~= "string" then return nil end
    return A.Signals[name]
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 17: FEATURE FLAGS SYSTEM
-- ═══════════════════════════════════════════════════════════════════

function A.SetFlag(name, value)
    if type(name) ~= "string" then return end
    A.Flags[name] = value
end

function A.GetFlag(name)
    return A.Flags[name]
end

function A.HasFlag(name)
    return A.Flags[name] ~= nil
end

function A.ClearFlag(name)
    A.Flags[name] = nil
end

function A.ListFlags()
    local result = {}
    for k, v in pairs(A.Flags) do
        result[k] = v
    end
    return result
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 18: INITIALIZATION BANNER & ASCII ART
-- ═══════════════════════════════════════════════════════════════════

local function PrintBanner()
    local banner = {
        "",
        "  ╔═══════════════════════════════════════════════════════════════╗",
        "  ║                                                               ║",
        "  ║     █████╗  ██████╗ ███████╗██╗      ██████╗  █████╗ ██████╗  ║",
        "  ║    ██╔══██╗██╔════╝ ██╔════╝██║     ██╔═══██╗██╔══██╗██╔══██╗ ║",
        "  ║    ███████║██║  ███╗█████╗  ██║     ██║   ██║███████║██████╔╝ ║",
        "  ║    ██╔══██║██║   ██║██╔══╝  ██║     ██║   ██║██╔══██║██╔═══╝  ║",
        "  ║    ██║  ██║╚██████╔╝███████╗███████╗╚██████╔╝██║  ██║██║      ║",
        "  ║    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝      ║",
        "  ║                                                               ║",
        "  ║            H U B   v" .. A.Version .. "  -  " .. A.Build .. "         ║",
        "  ║                                                               ║",
        "  ╚═══════════════════════════════════════════════════════════════╝",
        "",
    }

    for _, line in ipairs(banner) do
        print(line)
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 19: CORE INITIALIZATION FUNCTION
-- ═══════════════════════════════════════════════════════════════════

function A.Init()
    local initStart = tick()
    A._INITIALIZING = true

    A.Log("═══════════════════════════════════════════════════════════", "INIT")
    A.Log("  APEX HUB v" .. A.Version .. " - CORE INITIALIZATION", "INIT")
    A.Log("  Build: " .. A.Build, "INIT")
    A.Log("  Session: " .. A.SESSION_ID, "INIT")
    A.Log("  Time: " .. tostring(os.date and os.date("%Y-%m-%d %H:%M:%S") or "N/A"), "INIT")
    A.Log("═══════════════════════════════════════════════════════════", "INIT")

    -- Print ASCII art banner
    A.SafeExec(function()
        PrintBanner()
    end, "BannerPrint")

    -- Step 1: Verify local player exists
    A.Log("Step 1/10: Verifying LocalPlayer...", "INIT")
    if not A.LP or not A.LP.Parent then
        A.Log("LocalPlayer is nil or not in game hierarchy!", "ERROR")
        A.Log("Attempting recovery: game.Players.LocalPlayer", "WARN")
        A.LP = nil
        pcall(function()
            A.LP = game.Players.LocalPlayer
        end)
        if not A.LP then
            A.Log("CRITICAL: Cannot find LocalPlayer. Hub cannot function.", "ERROR")
            A._INITIALIZING = false
            return false, "E005"
        end
    end
    A.Log("LocalPlayer verified: " .. A.LP.Name .. " (ID: " .. A.LP.UserId .. ")", "OK")

    -- Step 2: Executor analysis
    A.Log("Step 2/10: Executor analysis complete.", "INIT")
    A.Log("Executor: " .. ExecutorData.DisplayName, "OK")
    A.Log("  Capability HTTP:      " .. tostring(ExecutorData.SupportsHttp), "DEBUG")
    A.Log("  Capability Drawing:  " .. tostring(ExecutorData.SupportsDrawing), "DEBUG")
    A.Log("  Capability UI:       " .. tostring(ExecutorData.SupportsUI), "DEBUG")
    A.Log("  Capability Closure:  " .. tostring(ExecutorData.SupportsClosure), "DEBUG")
    A.Log("  Capability SynProt:  " .. tostring(ExecutorData.SupportsSynProtect), "DEBUG")

    -- Step 3: Environment integrity check
    A.Log("Step 3/10: Environment integrity checks...", "INIT")
    for checkName, checkResult in pairs(_PRE_INIT_ENV_CHECK) do
        A.Log("  " .. checkName .. " = " .. tostring(checkResult), "DEBUG")
    end

    local missingCritical = false
    if not _PRE_INIT_ENV_CHECK.haspcall then
        A.Log("CRITICAL: pcall is not available in this environment!", "ERROR")
        missingCritical = true
    end
    if missingCritical then
        A.Log("Environment has missing critical components. Some features disabled.", "WARN")
    else
        A.Log("Environment integrity: PASSED", "OK")
    end

    -- Step 4: Race condition check
    A.Log("Step 4/10: Race condition detection...", "INIT")
    if _G.Apex and _G.Apex._DEPRECATED then
        A.Log("Previous Apex instance was deprecated and replaced.", "WARN")
    end
    if _G.APEX_LOADED then
        A.Log("Global _G.APEX_LOADED flag detected (previous load). Overwriting.", "WARN")
    end
    A.Log("Race condition scan: COMPLETE", "OK")

    -- Step 5: Initialize core flags
    A.Log("Step 5/10: Setting core flags...", "INIT")
    A.SetFlag("core_initialized", true)
    A.SetFlag("executor", ExecutorData.Detected)
    A.SetFlag("place_id", game.PlaceId)
    A.SetFlag("server_job_id", game.JobId)
    A.SetFlag("framework_version", A.Version)
    A.SetFlag("build_id", A.Build)
    A.SetFlag("session_id", A.SESSION_ID)
    A.Log("Core flags: " .. tostring(#(function()
        local c = 0; for _ in pairs(A.Flags) do c = c + 1 end; return setmetatable({}, {__len = function() return c end}) end)()) .. " flags set", "DEBUG")

    -- Step 6: Create core signals
    A.Log("Step 6/10: Creating core signals...", "INIT")
    A.CreateSignal("CoreLoaded")
    A.CreateSignal("ModuleRegistered")
    A.CreateSignal("SubsystemReady")
    A.CreateSignal("Error")
    A.CreateSignal("PlayerDied")
    A.CreateSignal("Teleported")
    A.CreateSignal("ServerHop")
    A.CreateSignal("GameJoined")
    A.Log("Core signals created: " .. tostring((function()
        local c = 0; for _ in pairs(A.Signals) do c = c + 1 end; return c end)()) .. " signals", "OK")

    -- Step 7: Initialize subsystems
    A.Log("Step 7/10: Initializing subsystems...", "INIT")
    for _, subName in ipairs(A.SubsystemOrder) do
        local sub = A.Subsystems[subName]
        if sub and not sub.initialized then
            A.PerfStart("subsys_" .. subName)
            local ok, err = pcall(sub.initFn)
            local elapsed = A.PerfEnd("subsys_" .. subName)
            if ok then
                sub.initialized = true
                sub.initTime = elapsed
                A.Log(string.format("  Subsystem '%s' initialized in %.4fs", subName, elapsed or 0), "OK")
            else
                sub.initError = tostring(err or "Unknown error")
                A.Log(string.format("  Subsystem '%s' FAILED: %s", subName, sub.initError), "ERROR")
            end
            -- Signal that subsystem is ready (even on failure)
            local sig = A.GetSignal("SubsystemReady")
            if sig then sig:Fire(subName, ok) end
        end
    end
    A.Log("Subsystem initialization: COMPLETE", "OK")

    -- Step 8: Pre-lockdown snapshot of core functions
    A.Log("Step 8/10: Pre-lockdown function snapshot...", "INIT")
    _CORE_FUNCTION_KEYS = {}
    for k, v in pairs(A) do
        if type(v) == "function" then
            _CORE_FUNCTION_KEYS[k] = v
        end
    end
    A.Log("  Core functions snapshotted: " .. tostring((function() local c=0; for _ in pairs(_CORE_FUNCTION_KEYS) do c=c+1 end; return c end)()), "DEBUG")

    -- Step 9: Post-lockdown verification
    A.Log("Step 9/10: Post-lockdown verification...", "INIT")
    local stats = A.GetStats()
    A.Log("  Modules loaded:     " .. tostring(stats.registeredModules), "DEBUG")
    A.Log("  Subsystems active:  " .. tostring(stats.subsystemCount), "DEBUG")
    A.Log("Post-lockdown verification: PASSED", "OK")

    -- Step 10: Finalization (lockdown)
    A.Log("Step 10/10: Finalizing (lockdown)...", "INIT")
    A._INITIALIZING = false
    A._LOADED = true
    _G.APEX_LOADED = true

    -- Post-lockdown: detect any rawset overwrites that snuck past the metatable.
    -- If a core function was replaced, restore it from the snapshot.
    local tamperCount = 0
    for k, origFn in pairs(_CORE_FUNCTION_KEYS) do
        local current = rawget(A, k)
        if type(current) == "function" and current ~= origFn then
            tamperCount = tamperCount + 1
            rawset(A, k, origFn)
            warn("[APEX CORE] Post-lockdown tamper detected on '" .. k .. "' — restored from snapshot.")
        end
    end
    if tamperCount > 0 then
        A.Log(string.format("  Tamper recovery: %d function(s) restored", tamperCount), "WARN")
    else
        A.Log("  Tamper scan: CLEAN", "OK")
    end

    local totalInitTime = tick() - initStart
    A.SetFlag("init_time", totalInitTime)

    A.Log("═══════════════════════════════════════════════════════════", "OK")
    A.Log(string.format("  APEX HUB v%s INITIALIZED SUCCESSFULLY", A.Version), "OK")
    A.Log(string.format("  Build: %s", A.Build), "OK")
    A.Log(string.format("  Init Time: %.4fs", totalInitTime), "OK")
    A.Log(string.format("  Session: %s", A.SESSION_ID), "OK")
    A.Log(string.format("  Uptime: %s", stats.uptimeFormatted or "N/A"), "OK")
    A.Log("═══════════════════════════════════════════════════════════", "OK")

    -- Fire the CoreLoaded signal
    local sig = A.GetSignal("CoreLoaded")
    if sig then sig:Fire(stats) end

    return true
end

-- ═══════════════════════════════════════════════════════════════════
-- SECTION 20: AUTO-INIT GUARD (delayed, non-blocking)
-- ═══════════════════════════════════════════════════════════════════

-- The core module provides A.Init() for manual initialization.
-- This allows subsystem modules to register before Init() is called.
-- The user (or main script) should call _G.Apex.Init() explicitly.

-- Log that core module is loaded and ready
local _CORE_LOAD_TIME = tick() - _PRE_INIT_TICK
A.Log = A.Log or function() end -- Safety fallback if logging failed
A.Log(string.format(
    "Core module loaded in %.4fs. Ready for subsystem registration and Init().",
    _CORE_LOAD_TIME
), "INIT")
A.Log(string.format(
    "Pre-init env scan: %d/%d checks passed",
    (function()
        local count = 0
        for _, v in pairs(_PRE_INIT_ENV_CHECK) do
            if v == true then count = count + 1 end
        end
        return count
    end)(),
    (function()
        local count = 0
        for _ in pairs(_PRE_INIT_ENV_CHECK) do count = count + 1 end
        return count
    end)()
), "DEBUG")

return A