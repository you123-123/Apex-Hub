--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║   APEX HUB v13.0 - COMBO ORCHESTRATOR (قائد الخيط المهاراتي)      ║
    ║                      Core Module - Standalone                     ║
    ╚══════════════════════════════════════════════════════════════════╝

    نظام مستقل لاتخاذ قرار المهارة التالية ديناميكياً بناءً على:
      - مدى الهدف (قريب/متوسط/بعيد).
      - تبريد المهارات (cd) وحالة الهدف.
      - تسلسل مهارات معرّف لكل سيناريو.
    يُفعَّل فقط عند الضغط (لا يبدأ تلقائياً وقت التحميل).
    يعتمد على دوال عامة فقط: A.GetTargetDistance, A.SkillAttack.
    لا يستخدم الكلمة المحجوزة `continue`.
--]]

local A = _G.Apex or {}

A.ComboMaster = {
    enabled = false,
    skills = {},
    sequence = {},
    _cursor = 1,
    _lastDecision = 0,
}

function A.ComboMaster.RegisterSkill(name, data)
    A.ComboMaster.skills[name] = data or {}
end

function A.ComboMaster.SetSequence(list)
    A.ComboMaster.sequence = list or {}
    A.ComboMaster._cursor = 1
end

function A.ComboMaster.SkillReady(name)
    local s = A.ComboMaster.skills[name]
    if not s then return false end
    if not s.lastUse then return true end
    local cd = s.cd or 1
    return (tick() - s.lastUse) >= cd
end

function A.ComboMaster.PickForRange(dist)
    for _, name in ipairs(A.ComboMaster.sequence) do
        local s = A.ComboMaster.skills[name]
        if s and A.ComboMaster.SkillReady(name) then
            local rt = s.rangeType or "any"
            if rt == "any"
               or (rt == "melee" and dist <= 15)
               or (rt == "mid" and dist > 15 and dist <= 40)
               or (rt == "long" and dist > 40) then
                return name
            end
        end
    end
    return nil
end

function A.ComboMaster.Decide(target)
    if not A.ComboMaster.enabled or not target then return nil end
    local dist = A.GetTargetDistance and A.GetTargetDistance(target) or 999
    return A.ComboMaster.PickForRange(dist)
end

function A.ComboMaster.Step(target)
    if not A.ComboMaster.enabled or not target then return end
    local name = A.ComboMaster.Decide(target)
    if name then
        local s = A.ComboMaster.skills[name]
        if s then s.lastUse = tick() end
        if A.SkillAttack then
            pcall(A.SkillAttack, target, name)
        end
        return name
    end
    return nil
end

function A.ComboMaster.Start()
    A.ComboMaster.enabled = true
end

function A.ComboMaster.Stop()
    A.ComboMaster.enabled = false
end

return A.ComboMaster
