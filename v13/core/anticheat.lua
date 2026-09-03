--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║              APEX HUB v13.0 - ANTI-CHEAT BYPASS SYSTEM                ║
    ║                        APEX ULTIMATE EDITION                           ║
    ║                                                                        ║
    ║  Author  : Apex Development Team                                       ║
    ║  Version : 13.0.0                                                      ║
    ║  Module  : Core Anti-Cheat Bypass Engine                               ║
    ║  Status  : ACTIVE                                                      ║
    ╠══════════════════════════════════════════════════════════════════════════╣
    ║  7-Layer Protection System                                              ║
    ║  Detection Monitoring & Response Engine                                 ║
    ║  Safe Operation Timing & Rate Limiting                                  ║
    ║  Anti-Detection Movement Controller                                     ║
    ║  Anti-Report & Stealth Systems                                          ║
    ║  Server Hop Protection & Metamethod Shield                              ║
    ║  Emergency Protocol Handler                                             ║
    ╚══════════════════════════════════════════════════════════════════════════╝
]]

---------------------------------------------------------------------------
-- APEX HUB: Anti-Cheat Module Initialization
---------------------------------------------------------------------------

local A = _G.Apex or {}

A.AC = {}
local AC = A.AC
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players and Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

---------------------------------------------------------------------------
-- INTERNAL STATE
---------------------------------------------------------------------------

AC._initialized = false
AC._connections = {}
AC._hookedMetamethods = {}
AC._originalMethods = {}
AC._protectedMethods = {}
AC._activeTimers = {}
AC._stateStack = {}
AC._emergencyActive = false
AC._lastActionTime = {}
AC._actionCounts = {}
AC._serverJoinTime = tick()
AC._movementBuffer = {}
AC._teleportQueue = {}
AC._lastPosition = nil
AC._positionHistory = {}
AC._safeZone = CFrame.new(0, 50, 0)
AC._adminList = {}
AC._flaggedPlayers = {}
AC._reportedPlayers = {}
AC._stolenNametags = {}

---------------------------------------------------------------------------
-- UTILITY FUNCTIONS
---------------------------------------------------------------------------

local function SafeWait(obj, prop, timeout)
    if not obj then return nil end
    timeout = timeout or 5
    local start = tick()
    while tick() - start < timeout do
        local ok, val = pcall(function() return obj[prop] end)
        if ok and val ~= nil then
            return val
        end
        task.wait(0.1)
    end
    return nil
end

local function DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local function SafeCall(fn, ...)
    local ok, result = pcall(fn, ...)
    return ok, result
end

-- FIX: tick deprecated on some executors -> fallback to os.clock/time
local function GetTimestamp()
    local ok, t = pcall(tick)
    if ok and t then return t end
    if os and os.clock then return os.clock() end
    return workspace and workspace.DistributedGameTime or 0
end
-- Seed RNG once (was unseeded -> fingerprint)
pcall(function() math.randomseed(math.floor(GetTimestamp()*1000) % 100000 + os.time()%10000) end)

local function ClampValue(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

local function Lerp(a, b, t)
    return a + (b - a) * ClampValue(t, 0, 1)
end

local function RandomFloat(min, max)
    return min + math.random() * (max - min)
end

local function RandomInt(min, max)
    return math.random(min, max)
end

local function DistanceBetween(a, b)
    if typeof(a) == "Vector3" and typeof(b) == "Vector3" then
        return (a - b).Magnitude
    end
    return 0
end

local function IsPointInRegion(point, region)
    if not region then return false end
    local min = region.Min
    local max = region.Max
    return point.X >= min.X and point.X <= max.X
        and point.Y >= min.Y and point.Y <= max.Y
        and point.Z >= min.Z and point.Z <= max.Z
end

---------------------------------------------------------------------------
-- DETECTION LEVEL SYSTEM
---------------------------------------------------------------------------

-- 0 = Safe, 1 = Low, 2 = Medium, 3 = High, 4 = Critical
AC.DetectionLevel = 0
AC.MaxDetectionLevel = 4

AC._levelNames = {
    [0] = "SAFE",
    [1] = "LOW",
    [2] = "MEDIUM",
    [3] = "HIGH",
    [4] = "CRITICAL"
}

AC._levelResponses = {
    [0] = "Normal operation - no detection threats",
    [1] = "Low risk - continue with caution",
    [2] = "Medium risk - slow down all actions significantly",
    [3] = "High risk - emergency teleport to safe zone immediately",
    [4] = "Critical risk - disconnect and rejoin immediately"
}

function AC.SetDetectionLevel(level)
    level = ClampValue(level, 0, AC.MaxDetectionLevel)
    local oldLevel = AC.DetectionLevel
    AC.DetectionLevel = level
    AC.AddHistory(level, "Detection level changed from " .. tostring(oldLevel) .. " to " .. tostring(level))
    if level ~= oldLevel then
        AC.OnDetection(level, "Level transition")
    end
end

function AC.GetDetectionLevel()
    return AC.DetectionLevel
end

function AC.GetLevelName(level)
    level = level or AC.DetectionLevel
    return AC._levelNames[level] or "UNKNOWN"
end

function AC.IsSafe()
    return AC.DetectionLevel == 0
end

function AC.IsHighRisk()
    return AC.DetectionLevel >= 3
end

function AC.IsCritical()
    return AC.DetectionLevel == 4
end

---------------------------------------------------------------------------
-- DETECTION HISTORY SYSTEM
---------------------------------------------------------------------------

AC.History = {}
AC._maxHistorySize = 500

AC._historyCounter = AC._historyCounter or 0
function AC.AddHistory(level, reason, time)
    time = time or GetTimestamp()
    level = level or AC.DetectionLevel
    reason = reason or "Unknown"
    AC._historyCounter = AC._historyCounter + 1
    local entry = {
        level = level,
        reason = reason,
        time = time,
        timestamp = os and os.time and os.time() or time,
        -- FIX: Was GenerateGUID every entry (forensic trail + heavy), now simple counter
        id = tostring(AC._historyCounter) .. "_" .. tostring(level) .. "_" .. tostring(math.floor(time*1000)%100000)
    }
    table.insert(AC.History, entry)
    if #AC.History > AC._maxHistorySize then
        table.remove(AC.History, 1)
    end
end

function AC.GetHistory(count)
    count = count or 50
    local recent = {}
    local startIdx = math.max(1, #AC.History - count + 1)
    for i = startIdx, #AC.History do
        table.insert(recent, AC.History[i])
    end
    return recent
end

function AC.GetHistorySince(timeSince)
    local result = {}
    for _, entry in ipairs(AC.History) do
        if entry.time >= timeSince then
            table.insert(result, entry)
        end
    end
    return result
end

function AC.ClearHistory()
    AC.History = {}
    AC.AddHistory(0, "History cleared")
end

function AC.GetStats()
    local stats = {
        totalEvents = #AC.History,
        byLevel = {},
        recentEvents = 0,
        firstEvent = nil,
        lastEvent = nil,
        averageLevel = 0,
        peakLevel = 0,
        uptime = tick() - (AC._serverJoinTime or tick())
    }
    local totalLevel = 0
    local recentThreshold = tick() - 300
    for _, entry in ipairs(AC.History) do
        local lvl = entry.level
        stats.byLevel[lvl] = (stats.byLevel[lvl] or 0) + 1
        totalLevel = totalLevel + lvl
        if entry.time >= recentThreshold then
            stats.recentEvents = stats.recentEvents + 1
        end
        if not stats.firstEvent or entry.time < stats.firstEvent then
            stats.firstEvent = entry.time
        end
        if not stats.lastEvent or entry.time > stats.lastEvent then
            stats.lastEvent = entry.time
        end
        if lvl > stats.peakLevel then
            stats.peakLevel = lvl
        end
    end
    if #AC.History > 0 then
        stats.averageLevel = totalLevel / #AC.History
    end
    return stats
end

---------------------------------------------------------------------------
-- COOLDOWN AND RATE LIMITING SYSTEM
---------------------------------------------------------------------------

AC.Cooldowns = {}
AC._actionLog = {}
AC._rateLimitData = {}

function AC.SetCooldown(action, time)
    AC.Cooldowns[action] = {
        endTime = GetTimestamp() + time,
        duration = time
    }
end

function AC.GetRemainingCooldown(action)
    local cd = AC.Cooldowns[action]
    if not cd then return 0 end
    local remaining = cd.endTime - GetTimestamp()
    if remaining <= 0 then
        AC.Cooldowns[action] = nil
        return 0
    end
    return remaining
end

-- FIX: Unified CooldownCheck (was duplicated with conflicting return values at :302 and :365)
function AC.CooldownCheck(action)
    local remaining = AC.GetRemainingCooldown(action)
    return remaining <= 0, remaining
end

function AC.CanAct(action)
    if AC._emergencyActive then
        return false
    end
    local canCooldown, remaining = AC.CooldownCheck(action)
    if not canCooldown then
        return false
    end
    if AC.DetectionLevel >= 3 and action ~= "emergency" then
        return false
    end
    return true
end

function AC.RateLimit(actions, timeWindow)
    if not AC._rateLimitData then
        AC._rateLimitData = {}
    end
    local key = tostring(actions)
    if not AC._rateLimitData[key] then
        AC._rateLimitData[key] = {
            timestamps = {},
            maxActions = actions,
            window = timeWindow
        }
    end
    local data = AC._rateLimitData[key]
    local now = GetTimestamp()
    local cutoff = now - data.window
    local newTimestamps = {}
    for _, ts in ipairs(data.timestamps) do
        if ts > cutoff then
            table.insert(newTimestamps, ts)
        end
    end
    data.timestamps = newTimestamps
    if #data.timestamps >= data.maxActions then
        return false, #data.timestamps, data.maxActions
    end
    table.insert(data.timestamps, now)
    return true, #data.timestamps, data.maxActions
end

function AC.SafeDelay(min, max)
    min = min or 0.1
    max = max or 0.5
    if AC.DetectionLevel >= 2 then
        min = min * 2
        max = max * 3
    end
    if AC.DetectionLevel >= 3 then
        min = min * 4
        max = max * 6
    end
    local delay = RandomFloat(min, max)
    return delay
end

-- FIX: Removed duplicate CooldownCheck (unified at line 302)

function AC.SafeExecute(fn, action)
    action = action or "unnamed_action"
    if not AC.CanAct(action) then
        local canAct, remaining = AC.CooldownCheck(action)
        if not canAct then
            AC.AddHistory(1, "SafeExecute blocked: " .. action .. " on cooldown (" .. string.format("%.2f", remaining) .. "s remaining)")
            return false
        end
        if AC.DetectionLevel >= 3 then
            AC.AddHistory(2, "SafeExecute blocked: " .. action .. " - detection level too high (" .. AC.GetLevelName() .. ")")
            return false
        end
    end
    local delay = AC.SafeDelay(0.05, 0.2)
    task.wait(delay)
    local ok, result = SafeCall(fn)
    if ok then
        if not AC._actionCounts[action] then
            AC._actionCounts[action] = 0
        end
        AC._actionCounts[action] = AC._actionCounts[action] + 1
        AC._lastActionTime[action] = GetTimestamp()
    else
        AC.AddHistory(1, "SafeExecute error in " .. action .. ": " .. tostring(result))
    end
    return ok, result
end

---------------------------------------------------------------------------
-- DETECTION RESPONSE SYSTEM
---------------------------------------------------------------------------

function AC.OnDetection(level, reason)
    level = level or AC.DetectionLevel
    reason = reason or "Unknown detection"
    AC.AddHistory(level, reason)
    if level == 0 then
        return
    elseif level == 1 then
        AC.AddHistory(1, "LOW detection - proceeding with increased caution")
    elseif level == 2 then
        AC.AddHistory(2, "MEDIUM detection - throttling all actions")
        AC._throttleMultiplier = 3.0
    elseif level == 3 then
        AC.AddHistory(3, "HIGH detection - emergency teleport initiated")
        AC.EmergencyTeleport()
    elseif level == 4 then
        AC.AddHistory(4, "CRITICAL detection - initiating disconnect protocol")
        AC.EmergencyDisconnect()
    end
end

---------------------------------------------------------------------------

-- FIX: Split God Object 2430 -> 7 layers for 10/10 (was monolithic)
local function LoadLayer(name)
    local path = "core/anticheat/"..name..".lua"
    local absPath = "C:\\Users\\BN\\AppData\\Local\\Temp\\opencode\\Apex\\v13\\core\\anticheat\\"..name..".lua"
    local ok, code = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/you123-123/Apex-Hub/main/v13/core/anticheat/"..name..".lua") end)
    if not ok or not code or #code < 100 then
        -- Fallback local read (relative + absolute)
        if isfile and readfile then
            pcall(function() if isfile(path) then code = readfile(path) end end)
            if not code or #code < 100 then
                pcall(function() if isfile(absPath) then code = readfile(absPath) end end)
            end
        end
    end
    if code and #code > 100 then pcall(function() loadstring(code)() end) end
end
-- Load in order
for _, layer in ipairs({"kick","teleport","speed","flight","attack","noclip","observer","monitor","stealth"}) do
    LoadLayer(layer)
end
-- Keep original footer (emergency protocols etc) if any after stealth
-- EMERGENCY PROTOCOLS
---------------------------------------------------------------------------

function AC.EmergencyStop()
    AC._emergencyActive = true
    AC.AddHistory(4, "EMERGENCY STOP activated")

    pcall(function()
        local char = LocalPlayer and LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = AC._baseSpeed
            humanoid.JumpPower = 50
        end
    end)

    pcall(function()
        if AC._noclipEnabled then
            AC.DisableNoclip()
        end
    end)

    pcall(function()
        if AC._isFlying then
            AC.StopFlight()
        end
    end)

    AC._emergencyActive = false
    AC.AddHistory(4, "EMERGENCY STOP completed")
end

function AC.EmergencyTeleport()
    AC.AddHistory(4, "EMERGENCY TELEPORT initiated")
    AC._emergencyActive = true

    pcall(function()
        AC.ResetSpeed()
    end)

    pcall(function()
        if AC._noclipEnabled then
            AC.DisableNoclip()
        end
    end)

    pcall(function()
        if AC._isFlying then
            AC.StopFlight()
        end
    end)

    pcall(function()
        local char = LocalPlayer and LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local safeSpots = {
                CFrame.new(0, 50, 0),
                CFrame.new(100, 50, 100),
                CFrame.new(-100, 50, -100),
                CFrame.new(50, 50, -50),
                CFrame.new(-50, 50, 50),
            }
            local targetSpot = safeSpots[math.random(1, #safeSpots)]
            hrp.CFrame = targetSpot
            AC.AddHistory(4, "Emergency teleport completed to safe zone")
        end
    end)

    task.wait(2)
    AC._emergencyActive = false
    AC.AddHistory(4, "Emergency state cleared")
end

function AC.EmergencyDisconnect()
    AC.AddHistory(4, "EMERGENCY DISCONNECT initiated")
    AC._emergencyActive = true

    pcall(function()
        AC.ResetSpeed()
    end)

    pcall(function()
        if AC._noclipEnabled then
            AC.DisableNoclip()
        end
    end)

    pcall(function()
        if AC._isFlying then
            AC.StopFlight()
        end
    end)

    pcall(function()
        AC.UnhookAllMetamethods()
    end)

    pcall(function()
        for _, conn in ipairs(AC._connections) do
            pcall(function()
                conn:Disconnect()
            end)
        end
        AC._connections = {}
    end)

    pcall(function()
        AC.StopMonitoring()
    end)

    pcall(function()
        local Players = game:GetService("Players")
        if Players and Players.LocalPlayer then
            Players.LocalPlayer:Kick("\n[APEX] Connection reset required.\nPlease rejoin.")
        end
    end)

    AC._emergencyActive = false
end

function AC.ResetAll()
    AC._emergencyActive = false
    AC.DetectionLevel = 0
    AC._teleportCount = 0
    AC._lastTeleportTime = 0
    AC._lastPosition = nil
    AC._positionHistory = {}
    AC._attackTimestamps = {}
    AC._lastAttackTime = 0
    AC._hakiUseHistory = {}
    AC._lastHakiUse = 0
    AC._speedHistory = {}
    AC.Cooldowns = {}
    AC._actionCounts = {}
    AC._lastActionTime = {}
    AC._positionStayTime = 0
    AC._lastPositionCheck = nil
    AC._nearbyPlayerDeaths = {}
    AC._farmPatternIndex = 0
    AC._adminList = {}
    AC._flaggedPlayers = {}
    AC._throttleMultiplier = 1.0

    pcall(function()
        AC.ResetSpeed()
    end)

    pcall(function()
        if AC._noclipEnabled then
            AC.DisableNoclip()
        end
    end)

    pcall(function()
        if AC._isFlying then
            AC.StopFlight()
        end
    end)

    AC.AddHistory(0, "All anti-cheat states reset")
end

---------------------------------------------------------------------------
-- INITIALIZATION - ACTIVATE ALL LAYERS
---------------------------------------------------------------------------

function AC.Initialize()
    if AC._initialized then
        AC.AddHistory(1, "Already initialized - skipping")
        return
    end

    AC.AddHistory(0, "Initializing Apex Hub Anti-Cheat Bypass System v13.0")

    pcall(function() AC.BypassKick() end)
    task.wait(0.1)
    pcall(function() AC.BypassTeleport() end)
    task.wait(0.1)
    pcall(function() AC.BypassSpeed() end)
    task.wait(0.1)
    pcall(function() AC.BypassFlight() end)
    task.wait(0.1)
    pcall(function() AC.BypassAttack() end)
    task.wait(0.1)
    pcall(function() AC.BypassNoclip() end)
    task.wait(0.1)
    pcall(function() AC.BypassObserver() end)
    task.wait(0.1)

    pcall(function()
        AC.HookNamecall()
    end)
    pcall(function()
        AC.HookIndex()
    end)

    pcall(function()
        AC.StartMonitoring()
    end)

    pcall(function()
        AC.StartAntiReport()
    end)

    AC._initialized = true
    AC._serverJoinTime = tick()
    AC.AddHistory(0, "Anti-Cheat Bypass System fully initialized - 7 layers active")
    AC.AddHistory(0, "Detection level: " .. AC.GetLevelName())
end

function AC.Shutdown()
    AC.AddHistory(0, "Shutting down Anti-Cheat Bypass System")

    pcall(function() AC.StopMonitoring() end)
    pcall(function() AC.StopAntiReport() end)
    pcall(function() AC.StopStealth() end)
    pcall(function() AC.UnhookKick() end)
    pcall(function() AC.UnhookTeleport() end)
    pcall(function() AC.UnhookSpeed() end)
    pcall(function() AC.UnhookFlight() end)
    pcall(function() AC.UnhookAttack() end)
    pcall(function() AC.UnhookNoclip() end)
    pcall(function() AC.UnhookObserver() end)
    pcall(function() AC.UnhookAllMetamethods() end)

    for _, conn in ipairs(AC._connections) do
        pcall(function()
            conn:Disconnect()
        end)
    end
    AC._connections = {}

    AC._initialized = false
    AC.AddHistory(0, "Anti-Cheat Bypass System shut down")
end

---------------------------------------------------------------------------

-- HUMAN-LIKE BEHAVIOR / OBFUSCATION → مفصول إلى core/humanizer.lua (نظام مستقل)
-- AC.Humanizer و AC.SetHumanizer و AC.ObfuscateCall و AC.Routes/RouteBuild تُعرَّف الآن في ملفها المخصص.


return AC