--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║ APEX HUB v13.0 - HUMANIZER + OBFUSCATION (محاكي السلوك البشري)    ║
    ║                      Core Module - Standalone                     ║
    ╚══════════════════════════════════════════════════════════════════╝

    نظام مستقل يقلل النمطية الحسابية المكتشفة من أنظمة مكافحة الغش عبر:
      - إزاحة ضمنية عشوائية للهدف (aim noise).
      - راحة بشرية دورية وتشتيت طَقَري.
      - طبقة إخفاء متعددة الأشكال (ObfuscateCall) ومسارات متوزعة.
    يعتمد على كائن AC العام (من core/anticheat.lua) ودالة AC.AddHistory.
    لا يستخدم الكلمة المحجوزة `continue`.
--]]

local AC = _G.Apex and _G.Apex.AC or {}

AC.Humanizer = {
    enabled = false,
    _aimNoiseX = 0, _aimNoiseY = 0,
    _lastAimReset = 0,
    _humanizedPos = nil,
}

function AC.Humanizer.UpdateAimNoise()
    local now = tick()
    if now - AC.Humanizer._lastAimReset > 0.35 then
        AC.Humanizer._lastAimReset = now
        AC.Humanizer._aimNoiseX = (math.random() * 2 - 1) * 0.35
        AC.Humanizer._aimNoiseY = (math.random() * 2 - 1) * 0.25
    end
    return AC.Humanizer._aimNoiseX, AC.Humanizer._aimNoiseY
end

function AC.Humanizer.ApplyAimOffset(v3)
    if not AC.Humanizer.enabled then return v3 end
    local nx, ny = AC.Humanizer.UpdateAimNoise()
    local v = v3 or {}
    return { X = (v.X or 0) + nx, Y = (v.Y or 0) + ny, Z = (v.Z or 0) }
end

function AC.Humanizer.MaybeRest(minSec, maxSec)
    if not AC.Humanizer.enabled then return false end
    if math.random() < 0.08 then
        task.wait(math.random() * (maxSec or 1.2) + (minSec or 0.4))
        return true
    end
    return false
end

function AC.Humanizer.JitterDelay(base, spread)
    if not AC.Humanizer.enabled then return base or 0 end
    return (base or 0) + (math.random() * (spread or 0.1) - (spread or 0.1) / 2)
end

function AC.SetHumanizer(state)
    AC.Humanizer.enabled = state
    if AC.AddHistory then
        AC.AddHistory(0, "Humanizer " .. (state and "ENABLED" or "DISABLED"))
    end
    return state
end

function AC.ObfuscateCall(fn, ...)
    if type(fn) ~= "function" then return nil end
    local args = { ... }
    local unpackFn = unpack or table.unpack
    local ok, res = pcall(function()
        if AC.Humanizer.enabled and math.random() < 0.5 then
            return fn(unpackFn(args))
        else
            local proxy = {}
            for i = 1, #args do proxy[i] = args[i] end
            return fn(unpackFn(proxy))
        end
    end)
    if ok then return res end
    return nil
end

AC.Routes = {}
function AC.RouteBuild()
    if #AC.Routes == 0 then
        local cases = { "direct", "proxy", "defer" }
        for _, c in ipairs(cases) do
            table.insert(AC.Routes, { id = c, used = 0 })
        end
    end
    local total = 0
    for _, r in ipairs(AC.Routes) do total = total + r.used end
    local idx = (math.random() % #AC.Routes) + 1
    AC.Routes[idx].used = AC.Routes[idx].used + 1
    return AC.Routes[idx].id
end

return AC
