--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║   APEX HUB v13.0 - BRAIN / MEMORY BANK (الذاكرة وتحليل النمط)      ║
    ║                      Core Module - Standalone                     ║
    ╚══════════════════════════════════════════════════════════════════╝

    نظام مستقل يسجل أحداثاً زمنية (فئات) ويطابق أنماطاً متتالية
    ويساعد على قرارات مُستنيرة عبر ذاكرة قصيرة قصوى قابلة للضبط.
    يعتمد على A فقط. لا يستخدم الكلمة المحجوزة `continue`.
--]]

local A = _G.Apex or {}

A.Brain = {
    _events = {},
    _patterns = {},
    _maxEvents = 200,
}

function A.Brain.Remember(category, payload)
    table.insert(A.Brain._events, {
        t = tick(), category = category, payload = payload,
    })
    while #A.Brain._events > A.Brain._maxEvents do
        table.remove(A.Brain._events, 1)
    end
end

function A.Brain.Recent(category, seconds)
    local now = tick()
    local count = 0
    for _, e in ipairs(A.Brain._events) do
        if e.category == category and (now - e.t) <= seconds then
            count = count + 1
        end
    end
    return count
end

function A.Brain.MatchesPattern(category, sequence)
    local seq = sequence or {}
    if #seq == 0 then return false end
    local relevant = {}
    for _, e in ipairs(A.Brain._events) do
        if e.category == category then
            table.insert(relevant, e.payload)
        end
    end
    if #relevant < #seq then return false end
    for i = 0, #seq - 1 do
        if relevant[#relevant - i] ~= seq[#seq - i] then
            return false
        end
    end
    return true
end

function A.Brain.Last(category, seconds)
    local now = tick()
    for i = #A.Brain._events, 1, -1 do
        local e = A.Brain._events[i]
        if e.category == category and (now - e.t) <= (seconds or math.huge) then
            return e.payload
        end
    end
    return nil
end

function A.Brain.Total(category)
    local count = 0
    for _, e in ipairs(A.Brain._events) do
        if e.category == category then count = count + 1 end
    end
    return count
end

function A.Brain.Learn(key, delta)
    A.Brain._patterns[key] = (A.Brain._patterns[key] or 0) + (delta or 1)
end

function A.Brain.Weight(key)
    return A.Brain._patterns[key] or 0
end

function A.Brain.SetCapacity(n)
    A.Brain._maxEvents = n or A.Brain._maxEvents
end

function A.Brain.Clear(category)
    if category then
        local kept = {}
        for _, e in ipairs(A.Brain._events) do
            if e.category ~= category then table.insert(kept, e) end
        end
        A.Brain._events = kept
    else
        A.Brain._events = {}
        A.Brain._patterns = {}
    end
end

return A.Brain
