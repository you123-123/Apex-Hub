--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║   APEX HUB v13.0 - REMOTE MAP (كاشف/خريطة بنية الشبكة)            ║
    ║                      Core Module - Standalone                     ║
    ╚══════════════════════════════════════════════════════════════════╝

    نظام مستقل يوفّر خريطة سريعة للريميوت (Name -> instance + className)
    مع حِفظ للإسراع دون إعادة فحص كامل الشجرة إلا عند الحاجة.
    يعتمد على A.ReplicatedStorage. لا يستخدم الكلمة المحجوزة `continue`.
--]]

local A = _G.Apex or {}

A.RemoteMap = {}
A.RemoteMapValid = tick()

function A.BuildRemoteMap(parent, depth)
    parent = parent or (A.ReplicatedStorage or game:GetService("ReplicatedStorage"))
    depth = depth or 0
    if depth > 6 then return end
    local map = A.RemoteMap
    for _, obj in ipairs(parent:GetChildren()) do
        local cn = obj.ClassName or ""
        if cn == "RemoteEvent" or cn == "RemoteFunction" or cn == "BindableEvent" or cn == "BindableFunction" then
            local key = obj.Name
            if not map[key] then
                map[key] = { inst = obj, cn = cn, path = obj:GetFullName() }
            end
        end
        A.BuildRemoteMap(obj, depth + 1)
    end
end

function A.GetRemoteCached(name, rebuild)
    if rebuild or (tick() - A.RemoteMapValid) > 30 then
        A.RemoteMap = {}
        A.BuildRemoteMap()
        A.RemoteMapValid = tick()
    end
    local hit = A.RemoteMap[name]
    if hit then return hit.inst, hit.cn end
    if not rebuild then
        return A.GetRemoteCached(name, true)
    end
    return nil
end

function A.CleanRemoteMap()
    for k in pairs(A.RemoteMap) do
        local e = A.RemoteMap[k]
        if not e.inst or not e.inst.Parent then
            A.RemoteMap[k] = nil
        end
    end
end

function A.ResetRemoteMap()
    A.RemoteMap = {}
    A.RemoteMapValid = tick()
end

return A.RemoteMap