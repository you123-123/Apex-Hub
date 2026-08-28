local A = _G.Apex
local Smart = {}
Smart.Active = false
Smart.RouteOptimize = false
Smart.EconomyMaster = false
Smart.SessionMemory = false
Smart.Humanization = false
Smart.PrecisionFarm = false
Smart._loop = nil
Smart._sessionPath = nil

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then return false, err end
    return true, ...
end

-- ============ ROUTE OPTIMIZER ============
-- Given a list of target points, compute the shortest visiting order (nearest-neighbour heuristic).
function Smart.OptimizeRoute(points)
    if not points or #points == 0 then return {} end
    local hrp = A.HRP()
    local start = hrp and hrp.Position or (points[1] and points[1].Position or points[1])
    local remaining = {}
    for i, p in ipairs(points) do
        remaining[i] = {Index = i, Pos = (type(p) == "table" and (p.Position or p)) or p}
    end
    local order = {}
    local current = start
    while #remaining > 0 do
        local bestIdx = nil
        local bestDist = math.huge
        for i, r in ipairs(remaining) do
            local dist = (r.Pos - current).Magnitude
            if dist < bestDist then
                bestDist = dist
                bestIdx = i
            end
        end
        if not bestIdx then break end
        local chosen = table.remove(remaining, bestIdx)
        table.insert(order, chosen.Index)
        current = chosen.Pos
    end
    return order
end

-- Convenience: teleport through waypoints in optimized order.
function Smart.FollowOptimizedRoute(waypoints, stopEarly)
    stopEarly = stopEarly ~= false
    local order = Smart.OptimizeRoute(waypoints)
    local count = 0
    for _, idx in ipairs(order) do
        if stopEarly and not Smart.Active then break end
        local wp = waypoints[idx]
        local pos = (type(wp) == "table" and (wp.Position or wp)) or wp
        A.TweenTo(pos, 200)
        count = count + 1
    end
    return count
end

-- ============ ECONOMY MASTER ============
-- Decide, based on current stats, whether to invest in Meister (Mahakai) or do fragmented grinding.
function Smart.GetEconomyAdvice()
    local beli = A.StatsHUD and A.StatsHUD.GetBeli and A.StatsHUD.GetBeli() or 0
    local fragments = A.StatsHUD and A.StatsHUD.GetFragments and A.StatsHUD.GetFragments() or 0
    local level = A.StatsHUD and A.StatsHUD.GetLevel and A.StatsHUD.GetLevel() or 0
    local advice = {}
    advice.Beli = beli
    advice.Fragments = fragments
    advice.Level = level
    if beli >= 1000000 then
        advice.BuyMastery = true
        advice.Reason = "You have plenty of Beli - buy mastery"
    else
        advice.BuyMastery = false
        advice.Reason = "Farm Beli before buying mastery"
    end
    if fragments >= 5000 then
        advice.Raid = true
        advice.RaidReason = "Fragments are high - good time for raids"
    else
        advice.Raid = false
        advice.RaidReason = "Need more fragments for raids"
    end
    return advice
end

-- ============ SESSION MEMORY ============
local function GetSessionFile()
    if Smart._sessionPath then return Smart._sessionPath end
    local path = nil
    local ok, p = SafeCall(function()
        if writefile then
            return "APEX_Hub_Session.txt"
        end
        return nil
    end)
    if ok and p then Smart._sessionPath = p end
    return Smart._sessionPath
end

function Smart.SaveSession(data)
    local path = GetSessionFile()
    if not path then return false end
    local ok, enc = SafeCall(function()
        local json = game:GetService("HttpService"):JSONEncode(data)
        writefile(path, json)
    end)
    return ok ~= false
end

function Smart.LoadSession()
    local path = GetSessionFile()
    if not path then return nil end
    local ok, content = SafeCall(function() return readfile(path) end)
    if not ok or not content then return nil end
    local data = SafeCall(function()
        return game:GetService("HttpService"):JSONDecode(content)
    end)
    if not data then return nil end
    return data
end

function Smart.RecordSession()
    local current = A.StatsHUD and A.StatsHUD.GetAll and A.StatsHUD.GetAll() or {}
    local prev = Smart.LoadSession() or {}
    local snap = {
        Level = current.Level or 0,
        Beli = current.Beli or 0,
        Fragments = current.Fragments or 0,
        Time = tick(),
        TotalSeconds = (prev.TotalSeconds or 0) + ((current.Elapsed or 0)),
        TotalKills = (prev.TotalKills or 0) + (current.Kills or 0)
    }
    Smart.SaveSession(snap)
    return snap
end

function Smart.GetProgressReport()
    local prev = Smart.LoadSession()
    if not prev then return nil end
    local hours = (prev.TotalSeconds or 0) / 3600
    return {
        HoursPlayed = hours,
        TotalKills = prev.TotalKills or 0,
        LastLevel = prev.Level or 0,
        LastBeli = prev.Beli or 0
    }
end

-- ============ HUMANIZATION ============
-- Randomize delays to mimic human behavior. Input is a base delay; output jitters it.
function Smart.Jitter(baseDelay, variance)
    variance = variance or 0.3
    return math.max(0.05, baseDelay + (math.random() * 2 - 1) * variance * baseDelay)
end

function Smart.Sometimes(actionChance, callback)
    if math.random() < actionChance then
        SafeCall(callback)
        return true
    end
    return false
end

-- ============ PRECISION FARM ============
-- Runs a coroutine that periodically jitters movement pauses to look natural.
function Smart.RunPrecisionLoop()
    while Smart.Active and Smart.PrecisionFarm do
        Smart.Sometimes(0.3, function()
            task.wait(Smart.Jitter(0.2, 0.5))
        end)
        task.wait(Smart.Jitter(1, 0.4))
    end
end

function Smart.Loop()
    while Smart.Active do
        if Smart.RouteOptimize and A.Farm then
            SafeCall(function()
                if A.Farm.ReoptimizePath then
                    A.Farm.ReoptimizePath()
                end
            end)
        end
        if Smart.SessionMemory then
            Smart.RecordSession()
        end
        task.wait(Smart.Jitter(30, 0.5))
    end
end

function Smart.Start()
    if Smart.Active then return end
    Smart.Active = true
    Smart._loop = task.spawn(function()
        Smart.Loop()
        Smart.Active = false
    end)
    if Smart.PrecisionFarm then
        Smart._ploop = task.spawn(function()
            Smart.RunPrecisionLoop()
        end)
    end
end

function Smart.Stop()
    Smart.Active = false
    if Smart._loop then task.cancel(Smart._loop); Smart._loop = nil end
    if Smart._ploop then task.cancel(Smart._ploop); Smart._ploop = nil end
end

A.Smart = Smart
A.Register("smart", A.Smart)
