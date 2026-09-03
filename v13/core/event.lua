--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║   APEX HUB v13.0 - EVENT BUS (نظام النشر/الاشتراك الممركز)         ║
    ║                      Core Module - Standalone                     ║
    ╚══════════════════════════════════════════════════════════════════╝

    نظام مستقل مسؤول عن ربط المكوّنات عبر مواضيع (topics) مع:
      - أولويات المستمعين للتحكم في ترتيب التنفيذ.
      - cooldown و once لضبط تنفيذ المستمع.
      - coalescing آمن قابل للإيقاف (CancelCoalesce) لمنع تسرب الحلقات.
    يعتمد على A فقط؛ لا اعتماديات محلية.
    لا يستخدم الكلمة المحجوزة `continue`.
--]]

local A = _G.Apex or {}

A.Event = {
    _topics = {},
    _seq = 0,
    _coalesced = {},
}

function A.Event.Subscribe(topic, fn, opts)
    opts = opts or {}
    if type(topic) ~= "string" or type(fn) ~= "function" then return nil end
    A.Event._seq = A.Event._seq + 1
    local id = "evt_" .. A.Event._seq
    local priority = tonumber(opts.priority) or 0
    local topicNode = A.Event._topics[topic]
    if not topicNode then
        topicNode = {}
        A.Event._topics[topic] = topicNode
    end
    local sub = { fn = fn, priority = priority, once = opts.once, cooldown = opts.cooldown, id = id }
    topicNode[id] = sub
    return function()
        A.Event.Unsubscribe(topic, id)
    end
end

function A.Event.Unsubscribe(topic, id)
    local node = A.Event._topics[topic]
    if node then node[id] = nil end
end

function A.Event.Publish(topic, ...)
    local node = A.Event._topics[topic]
    if not node then return 0 end
    local ordered = {}
    for _, v in pairs(node) do table.insert(ordered, v) end
    table.sort(ordered, function(a, b) return a.priority > b.priority end)
    local handled = 0
    local now = tick()
    for _, listener in ipairs(ordered) do
        if listener.cooldown and listener._last and (now - listener._last) < listener.cooldown then
            -- cooldown still active: skip this listener
        elseif listener.fn then
            if listener.cooldown then listener._last = now end
            local ok = pcall(listener.fn, ...)
            if ok then handled = handled + 1 end
            if listener.once then A.Event.Unsubscribe(topic, listener.id) end
        end
    end
    return handled
end

function A.Event.PublishAsync(topic, ...)
    local args = { ... }
    task.spawn(function()
        A.Event.Publish(topic, table.unpack(args))
    end)
end

function A.Event.Clear(topic)
    if topic then
        A.Event._topics[topic] = nil
        A.Event.CancelCoalesce(topic)
    else
        A.Event._topics = {}
        for t in pairs(A.Event._coalesced) do
            A.Event.CancelCoalesce(t)
        end
    end
end

function A.Event.Coalesce(topic, window, fn)
    local state = A.Event._coalesced[topic]
    if not state then
        state = { window = window or 0.1, pending = false, alive = true }
        A.Event._coalesced[topic] = state
    end
    state.fn = fn
    if not state.timer then
        state.timer = task.spawn(function()
            while state and state.alive do
                task.wait(window or 0.1)
                if state and state.alive and state.fn and not state.pending then
                    state.pending = true
                    pcall(state.fn)
                    state.pending = false
                end
            end
        end)
    end
end

function A.Event.CancelCoalesce(topic)
    local state = A.Event._coalesced[topic]
    if state then
        state.alive = false
        A.Event._coalesced[topic] = nil
    end
end

return A.Event
