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

return A.Jobs
