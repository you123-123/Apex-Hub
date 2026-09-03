--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║   APEX HUB v13.0 - GOVERNOR (نظام الحوكمة وحل الصراعات)           ║
    ║                      Core Module - Standalone                     ║
    ╚══════════════════════════════════════════════════════════════════╝

    نظام مستقل يحلّ الصراعات تلقائياً بتطبيق أولويات آمنة، ويرصد حالة
    الأنظمة بتوصية في الوقت الفعلي، ويسجل سجل حوكمة (audit).
    يعتمد على جداول A.F و A.C (التي تعرّف في core/config.lua).
    مراقب الحوكمة قابل للإيقاف (لا يبدأ تلقائياً). لا يستخدم continue.
--]]

local A = _G.Apex or {}

A.Governor = {
    _resolved = {},
    _audit = {},
    _auditorOn = false,
}

function A.Governor.Resolve(conflict)
    if not conflict or not conflict.flags then return end
    local keep = conflict.keep
    for _, f in ipairs(conflict.flags) do
        if f ~= keep and A.F and A.F[f] then
            A.F[f] = false
            A.Governor._resolved[f] = (A.Governor._resolved[f] or 0) + 1
            table.insert(A.Governor._audit, { time = tick(), flag = f, action = "disabled", why = conflict.message })
        end
    end
end

function A.Governor.EnforceSafeConfig()
    local priorities = {
        { flags = {"Speed", "SpeedHack"}, keep = "Speed", msg = "SpeedHack overridden by Speed" },
        { flags = {"Fly", "Noclip"}, keep = "Fly", msg = "Noclip overridden by Fly" },
        { flags = {"MegaFarm", "AutoFarm"}, keep = "MegaFarm", msg = "AutoFarm suppressed under MegaFarm" },
        { flags = {"GodMode", "AutoPilot"}, keep = "AutoPilot", msg = "AutoPilot combined with GodMode" },
    }
    for _, rule in ipairs(priorities) do
        if A.F and A.F[rule.flags[1]] and A.F[rule.flags[2]] then
            A.Governor.Resolve({ flags = rule.flags, keep = rule.keep, message = rule.msg })
        end
    end
    return A.Governor._audit
end

function A.Governor.SafetyIndex()
    local score = 1
    local riskFlags = {"SpeedHack", "TeleportSpam", "FakeVote"}
    for _, f in ipairs(riskFlags) do
        if A.F and A.F[f] then score = score - 0.2 end
    end
    if A.C and A.C.ClickDelay and A.C.ClickDelay < 0.05 then
        score = score - 0.15
    end
    return math.max(0, score)
end

function A.Governor.Recommend(moduleKey)
    if moduleKey == "farm" then
        if A.F and A.F.MegaFarm then return "mega" end
        if A.F and A.F.AutoFarm then return "standard" end
        return "idle"
    elseif moduleKey == "combat" then
        if A.F and A.F.KillAura then return "aura" end
        return "manual"
    end
    return "idle"
end

function A.Governor.AuditLog()
    return A.Governor._audit
end

function A.Governor.StartAuditor(interval)
    if A.Governor._auditorOn then return end
    A.Governor._auditorOn = true
    task.spawn(function()
        while A.Governor._auditorOn do
            task.wait(interval or 30)
            pcall(A.Governor.EnforceSafeConfig)
        end
    end)
end

function A.Governor.StopAuditor()
    A.Governor._auditorOn = false
end

return A.Governor
