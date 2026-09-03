--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║ APEX HUB v13.0 - SIGNAL GOVERNOR (حوكمة إرسال الريميوت)           ║
    ║                      Core Module - Standalone                     ║
    ╚══════════════════════════════════════════════════════════════════╝

    نظام مستقل يحوكم إرسالات الشبكة لتقليل النمطية المكتشفة:
      - A.SignalGovernor: حدّ ذروة الاستدعاءات لكل نافذة (bucket + window).
      - A.SafeFire / A.SafeInvoke: إرسال آمن موقَّت عبر RemoteEvent/Function
        مع مهلة أمان وعدّاش أخطاء.
    لا يستخدم الكلمة المحجوزة `continue`.
--]]

local A = _G.Apex or {}

local unpackFn = unpack or table.unpack

A.SignalGovernor = {
    enabled = false,
    _window = {},
    maxPerWindow = 8,
    windowLen = 1.0,
    _tokens = 0,
    _lastRefill = tick(),
}

function A.SignalGovernor.ShouldSend()
    if not A.SignalGovernor.enabled then return true end
    local now = tick()
    while #A.SignalGovernor._window > 0 and (now - A.SignalGovernor._window[1]) > A.SignalGovernor.windowLen do
        table.remove(A.SignalGovernor._window, 1)
    end
    if #A.SignalGovernor._window < A.SignalGovernor.maxPerWindow then
        table.insert(A.SignalGovernor._window, now)
        return true
    end
    task.wait(0.04 + math.random() * 0.06)
    return false
end

-- ملتف آمن للإرسال عبر RemoteEvent
function A.SafeFire(remote, ...)
    if not remote then return false end
    local guard = 0
    while not A.SignalGovernor.ShouldSend() do
        guard = guard + 1
        if guard > 6 then return false end
    end
    local args = { ... }
    local ok = pcall(function()
        remote:FireServer(unpackFn(args))
    end)
    if not ok and A.RemoteErrors then A.RemoteErrors = A.RemoteErrors + 1 end
    return ok
end

-- ملتف آمن للإرسال عبر RemoteFunction
function A.SafeInvoke(remote, ...)
    if not remote then return nil end
    local guard = 0
    while not A.SignalGovernor.ShouldSend() do
        guard = guard + 1
        if guard > 6 then return nil end
    end
    local args = { ... }
    local ok, res = pcall(function()
        return remote:InvokeServer(unpackFn(args))
    end)
    if ok then return res end
    if A.RemoteErrors then A.RemoteErrors = A.RemoteErrors + 1 end
    return nil
end

function A.SignalGovernor.SetThrottle(max, windowLen)
    A.SignalGovernor.maxPerWindow = max or 8
    A.SignalGovernor.windowLen = windowLen or 1.0
end

function A.SignalGovernor.Enable(v)
    A.SignalGovernor.enabled = v
    return v
end

function A.SignalGovernor.Reset()
    A.SignalGovernor._window = {}
    A.SignalGovernor._tokens = 0
    A.SignalGovernor._lastRefill = tick()
end

return A.SignalGovernor