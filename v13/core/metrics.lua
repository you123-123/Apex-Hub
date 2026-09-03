--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║   APEX HUB v13.0 - METRICS ENGINE (نظام مراقبة الأداء والكثافة)  ║
    ║                      Core Module - Standalone                     ║
    ╚══════════════════════════════════════════════════════════════════╝

    نظام مستقل مسؤول عن قياس وتسجيل كثافة الأداء في الجلسة.
    يعتمد على A (من _G.Apex) فقط ولا يستورد أي اعتماديات محلية.

    يصفّى كل النظام في الوقت الحقيقي لإبطاء الحمل على المحرك.
    لا يستخدم الكلمة المحجوزة `continue` في أي مكان.
--]]

local A = _G.Apex or {}

A.Metrics = {
    _samples = {},
    _frames = {},
    _maxFrames = 60,
}

function A.Metrics.Record(category, delta)
    if not A.Metrics._samples[category] then
        A.Metrics._samples[category] = { sum = 0, count = 0, peak = 0, min = math.huge }
    end
    local s = A.Metrics._samples[category]
    s.sum = s.sum + (delta or 0)
    s.count = s.count + 1
    if delta and delta > s.peak then s.peak = delta end
    if delta and delta < s.min then s.min = delta end
end

function A.Metrics.Average(category)
    local s = A.Metrics._samples[category]
    if not s or s.count == 0 then return 0 end
    return s.sum / s.count
end

function A.Metrics.Peak(category)
    local s = A.Metrics._samples[category]
    return s and s.peak or 0
end

function A.Metrics.Min(category)
    local s = A.Metrics._samples[category]
    if not s or s.count == 0 then return 0 end
    return s.min
end

function A.Metrics.Reset(category)
    if category then
        A.Metrics._samples[category] = nil
    else
        A.Metrics._samples = {}
    end
end

function A.Metrics.DeltaLoad()
    local now = tick()
    table.insert(A.Metrics._frames, now)
    while #A.Metrics._frames > A.Metrics._maxFrames do
        table.remove(A.Metrics._frames, 1)
    end
    if #A.Metrics._frames < 2 then return 0 end
    local dt = A.Metrics._frames[#A.Metrics._frames] - A.Metrics._frames[1]
    if dt <= 0 then return 0 end
    return math.min(1, math.max(0, 1 - (dt / (#A.Metrics._frames * 0.05))))
end

return A.Metrics
