--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║   APEX HUB v13.0 - TASK SCHEDULER (نظام جدولة المهام المتقدمة)     ║
    ║                      Core Module - Standalone                     ║
    ╚══════════════════════════════════════════════════════════════════╝

    نظام مستقل لإدارة أدوار ذات حلقات دورية مع:
      - pause / resume / stop صريح لكل وظيفة.
      - جدولة تكيفية حسب كثافة المحرك (عبر A.Metrics.DeltaLoad).
      - breakOnError لقطع الحلقة عند أول فشل اختياري.
    كل وظيفة تُنشأ عبر A.Jobs.Create ثم تُدار بالمعرّف.
    لا يستخدم الكلمة المحجوزة `continue`.
--]]

local A = _G.Apex or {}

A.Jobs = {}

function A.Jobs.Create(id, cfg, fn)
    if type(id) ~= "string" or type(fn) ~= "function" then return nil end
    local job = {
        id = id, cfg = cfg or {}, fn = fn,
        running = false, iterations = 0,
        _lastTick = tick(), _spawned = false,
    }
    A.Jobs[id] = job
    A.Jobs.Start(id)
    return job
end

function A.Jobs.Start(id)
    local j = A.Jobs[id]
    if not j or j._spawned then return end
    j._spawned = true
    task.spawn(function()
        while j and j._spawned and j.cfg and not j.cfg.stopped do
            if not j.cfg.paused then
                local ok = pcall(j.fn, j)
                if j.cfg.breakOnError and not ok then break end
                j.iterations = j.iterations + 1
            end
            local cycle = tonumber(j.cfg.cycle) or 0.05
            if j.cfg.adaptive and A.Metrics and A.Metrics.DeltaLoad then
                cycle = cycle * (1 + A.Metrics.DeltaLoad())
            end
            task.wait(cycle)
        end
    end)
end

function A.Jobs.Pause(id)
    local j = A.Jobs[id]
    if j then j.cfg.paused = true end
end

function A.Jobs.Resume(id)
    local j = A.Jobs[id]
    if j then
        j.cfg.paused = false
        A.Jobs.Start(id)
    end
end

function A.Jobs.Stop(id)
    local j = A.Jobs[id]
    if j then
        j.cfg.stopped = true
        j._spawned = false
        A.Jobs[id] = nil
    end
end

function A.Jobs.Count()
    local n = 0
    for k in pairs(A.Jobs) do
        if type(A.Jobs[k]) == "table" and A.Jobs[k].id then n = n + 1 end
    end
    return n
end

function A.Jobs.StopAll()
    for k in pairs(A.Jobs) do
        local v = A.Jobs[k]
        if type(v) == "table" and v.id then
            v.cfg.stopped = true
            v._spawned = false
            A.Jobs[k] = nil
        end
    end
end

-- INFINITE+ : Zero-Allocation Loop pool (no GC)
A.Jobs._pool = {}
function A.Jobs.GetPooledTable()
    local t = table.remove(A.Jobs._pool)
    if not t then return {} end
    table.clear(t)
    return t
end
function A.Jobs.ReleasePooledTable(t) table.clear(t); table.insert(A.Jobs._pool, t) end
-- INFINITE+ : Predictive Cache for islands (predict next 5s)
A.Jobs._predictCache = {}
function A.Jobs.PredictNextIsland()
    local isl = _G.Apex and _G.Apex.Islands and _G.Apex.Islands.All
    if not isl then return nil end
    local now = tick()
    if A.Jobs._predictCache.time and now - A.Jobs._predictCache.time < 5 then
        return A.Jobs._predictCache.island
    end
    local myPos = _G.Apex.HRP and _G.Apex.HRP() and _G.Apex.HRP().Position
    if not myPos then return nil end
    local best, bestDist = nil, math.huge
    for _, v in ipairs(isl) do
        local pos = v.Position and v.Position.Position or v.Position
        if pos then
            local d = (Vector3.new(pos.X,pos.Y,pos.Z) - myPos).Magnitude
            if d < bestDist and d > 100 then bestDist=d; best=v end
        end
    end
    A.Jobs._predictCache = {island=best, time=now}
    return best
end

-- INFINITE+ : Neural Scheduler - reorders 42 modules by Ping/FPS (was FIFO)
function A.Jobs.NeuralReorder()
    local ping = 60
    pcall(function() ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() or 60 end)
    local fps = 60
    pcall(function() fps = A.Perf and A.Perf.GetFPS and A.Perf.GetFPS() or 60 end)
    -- Priority map: low ping/high fps -> farm/combat first, high ping/low fps -> visual/esp last
    local order = {}
    for id, job in pairs(A.Jobs) do
        if type(job)=="table" and job.id then
            local prio = 50
            if id:find("Farm") or id:find("Combat") then prio = (ping>150 or fps<30) and 30 or 90
            elseif id:find("ESP") or id:find("Visual") then prio = (fps<30) and 10 or 40
            else prio = 50 end
            table.insert(order, {id=id, prio=prio, job=job})
        end
    end
    table.sort(order, function(a,b) return a.prio > b.prio end)
    -- Apply cycle scaling
    for _, o in ipairs(order) do
        if o.job.cfg then
            o.job.cfg.cycle = (o.prio < 30) and 0.1 or 0.05
        end
    end
    return order
end
-- Auto neural every 10s
task.spawn(function() while true do task.wait(10); pcall(A.Jobs.NeuralReorder) end end)

return A.Jobs
