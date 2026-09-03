--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║   APEX HUB v13.0 - NEURAL ENGAGE (محوّل الالتحام الذكي)           ║
    ║                      Core Module - Standalone                     ║
    ╚══════════════════════════════════════════════════════════════════╝

    محوّل قرار الهجوم الموحد: يقرر ما بين محرك الخيط (A.ComboMaster)
    وخوارزمية الالتحام الأساسية (A.NeuralEngageBase) بحسب التفعيل.
    يُستدعى من CombatBrain وغيره؛ لا يبدأ تلقائياً.
    لا يستخدم الكلمة المحجوزة `continue`.
--]]

local A = _G.Apex or {}

function A.NeuralEngage(target, opts)
    if A.ComboMaster and A.ComboMaster.enabled then
        local stepName = A.ComboMaster.Step(target)
        if stepName then return "combo:" .. stepName end
    end
    if A.NeuralEngageBase then
        return A.NeuralEngageBase(target, opts)
    end
    return false
end

return A.NeuralEngage
