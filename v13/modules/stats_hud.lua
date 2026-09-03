local A = _G.Apex
local Stats = {}
Stats.Active = false
Stats._loop = nil
Stats.SessionStart = 0
Stats.LastLevel = 0
Stats.LastXP = 0
Stats.LastBeli = 0
Stats.LastFragments = 0
Stats.Kills = 0
Stats.Stats = {}

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then return false, err end
    return true, ...
end

function Stats.GetLevel()
    local lp = A.LP
    if not lp then return 0 end
    local data = lp:FindFirstChild("Data") or lp:FindFirstChild("DataLeaderboard")
    if data then
        local level = data:FindFirstChild("Level")
        return level and (tonumber(tostring(level.Value)) or 0) or 0
    end
    return 0
end

function Stats.GetBeli()
    local lp = A.LP
    if not lp then return 0 end
    local data = lp:FindFirstChild("Data") or lp:FindFirstChild("DataLeaderboard")
    if data then
        local beli = data:FindFirstChild("Beli") or data:FindFirstChild("Points") or data:FindFirstChild("Bounty")
        return beli and (tonumber(tostring(beli.Value)) or 0) or 0
    end
    return 0
end

function Stats.GetFragments()
    local lp = A.LP
    if not lp then return 0 end
    local data = lp:FindFirstChild("Data")
    if data then
        local frags = data:FindFirstChild("Fragments")
        return frags and (tonumber(tostring(frags.Value)) or 0) or 0
    end
    return 0
end

function Stats.GetMastery(type)
    local lp = A.LP
    if not lp then return 0 end
    local name = (type == "Sword" and "SwordMastery") or
        (type == "Gun" and "GunMastery") or
        (type == "Melee" and "MeleeMastery") or "Mastery"
    local data = lp:FindFirstChild("Data")
    if data then
        local val = data:FindFirstChild(name)
        return val and (tonumber(tostring(val.Value)) or 0) or 0
    end
    return 0
end

function Stats.Sample(tag)
    local s = {}
    s.Level = Stats.GetLevel()
    s.Beli = Stats.GetBeli()
    s.Fragments = Stats.GetFragments()
    s.Sword = Stats.GetMastery("Sword")
    s.Gun = Stats.GetMastery("Gun")
    s.Melee = Stats.GetMastery("Melee")
    s.Time = tick()
    Stats.Stats[tag] = s
    return s
end

function Stats.Rate(tag1, tag2, key)
    local a = Stats.Stats[tag1]
    local b = Stats.Stats[tag2]
    if not a or not b then return 0 end
    if not a[key] or not b[key] then return 0 end
    local elapsedMin = (b.Time - a.Time) / 60
    if elapsedMin <= 0 then return 0 end
    return (b[key] - a[key]) / elapsedMin
end

function Stats.GetAll()
    local now = tick()
    local elapsed = now - Stats.SessionStart
    local hours = elapsed / 3600
    local level = Stats.GetLevel()
    local beli = Stats.GetBeli()
    local fragments = Stats.GetFragments()
    local sword = Stats.GetMastery("Sword")
    local gun = Stats.GetMastery("Gun")
    local melee = Stats.GetMastery("Melee")
    return {
        Level = level,
        Beli = beli,
        Fragments = fragments,
        Sword = sword,
        Gun = gun,
        Melee = melee,
        Kills = Stats.Kills,
        Elapsed = elapsed,
        XPPerHour = hours > 0 and math.floor((level - Stats.SessionLevel) / hours) or 0,
        BeliPerHour = hours > 0 and math.floor((beli - Stats.SessionBeli) / hours) or 0,
        FragPerHour = hours > 0 and math.floor((fragments - Stats.SessionFrags) / hours) or 0,
        SwordPerHour = hours > 0 and math.floor((sword - Stats.SessionSword) / hours) or 0,
        GunPerHour = hours > 0 and math.floor((gun - Stats.SessionGun) / hours) or 0,
        MeleePerHour = hours > 0 and math.floor((melee - Stats.SessionMelee) / hours) or 0,
    }
end

function Stats.MainLoop()
    while Stats.Active do
        SafeCall(function()
            local s = Stats.GetAll()
            s.IsValid = true
        end)
        task.wait(5)
    end
end

function Stats.Start()
    if Stats.Active then return end
    Stats.Active = true
    Stats.SessionStart = tick()
    Stats.SessionLevel = Stats.GetLevel()
    Stats.SessionBeli = Stats.GetBeli()
    Stats.SessionFrags = Stats.GetFragments()
    Stats.SessionSword = Stats.GetMastery("Sword")
    Stats.SessionGun = Stats.GetMastery("Gun")
    Stats.SessionMelee = Stats.GetMastery("Melee")
    Stats.Kills = A.Combat and A.Combat.Kills or 0
    Stats._loop = task.spawn(function()
        Stats.MainLoop()
        Stats.Active = false
    end)
end

function Stats.Stop()
    Stats.Active = false
    if Stats._loop then
        task.cancel(Stats._loop)
        Stats._loop = nil
    end
end

A.StatsHUD = Stats
A.Register("stats_hud", A.StatsHUD)
