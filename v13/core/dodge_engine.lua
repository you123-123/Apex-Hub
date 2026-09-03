--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║   APEX HUB v13.0 - DODGE ENGINE (محرك المراوغة التنبؤي)           ║
    ║                      Core Module - Standalone                     ║
    ╚══════════════════════════════════════════════════════════════════╝

    نظام مستقل يتفادى الهجمات الواردة بالتنبؤ بالمقذوفات/الأهداف
    والثب/الانحراف للخروج من الخطر قبل وقوع الإصابة.
    بدء/إيقاف صريحان مدعومان بحلقة أمان؛ لا يبدأ تلقائياً.
    يعتمد على A.HRP (المعرفة في core/character.lua).
    لا يستخدم الكلمة المحجوزة `continue`.
--]]

-- FIX: throttle GetDescendants (was heavy)
local function _SafeDescendants(root, limit) limit=limit or 300; local res={}; local c=0; for _,v in ipairs(root:GetDescendants()) do c=c+1; if c>limit then break end; table.insert(res,v) end; return res end
local A = _G.Apex or {}

local function GetMyHRP()
    if A.HRP then return A.HRP() end
    return nil
end

A.DodgeEngine = {
    enabled = false,
    _lastDodge = 0,
    dodgeCooldown = 0.5,
    radius = 12,
    _conn = nil,
}

function A.DodgeEngine.ThreatScan(radius)
    radius = radius or A.DodgeEngine.radius or 12
    local myHrp = GetMyHRP()
    if not myHrp then return nil end
    local myPos = myHrp.Position
    local closest = nil
    local bestD = radius * radius
    for _, obj in ipairs(_SafeDescendants(workspace,300)) do
        if obj:IsA("Part") or obj:IsA("MeshPart") then
            local n = (obj.Name or ""):lower()
            if n:find("proj") or n:find("bullet") or n:find("ball") or n:find("fire") then
                local p = obj.Position or obj.CFrame and obj.CFrame.Position
                if p then
                    local d = (p.X - myPos.X)^2 + (p.Y - myPos.Y)^2 + (p.Z - myPos.Z)^2
                    if d < bestD then
                        bestD = d
                        closest = obj
                    end
                end
            end
        end
    end
    return closest, math.sqrt(bestD)
end

function A.DodgeEngine.Step()
    if not A.DodgeEngine.enabled then return end
    if (tick() - A.DodgeEngine._lastDodge) < A.DodgeEngine.dodgeCooldown then return end
    local threat, dist = A.DodgeEngine.ThreatScan(A.DodgeEngine.radius or 12)
    if threat and dist then
        A.DodgeEngine._lastDodge = tick()
        local myHrp = GetMyHRP()
        if myHrp then
            local tp = threat.Position
            local vx = (myHrp.Position.X or 0) - (tp and tp.X or 0)
            local vz = (myHrp.Position.Z or 0) - (tp and tp.Z or 0)
            local mag = math.sqrt(vx * vx + vz * vz)
            if mag > 0 then
                local nx = -vz / mag
                local nz = vx / mag
                pcall(function()
                    myHrp.CFrame = CFrame.new(
                        (myHrp.Position.X or 0) + nx * 8,
                        myHrp.Position.Y or 0,
                        (myHrp.Position.Z or 0) + nz * 8
                    )
                end)
            end
        end
    end
end

function A.DodgeEngine.Start(interval)
    A.DodgeEngine.enabled = true
    if A.DodgeEngine._conn then return end
    A.DodgeEngine._conn = task.spawn(function()
        while A.DodgeEngine.enabled do
            pcall(A.DodgeEngine.Step)
            task.wait(interval or 0.25)
        end
        A.DodgeEngine._conn = nil
    end)
end

function A.DodgeEngine.Stop()
    A.DodgeEngine.enabled = false
end

function A.StopDodgeEngine()
    A.DodgeEngine.enabled = false
end

return A.DodgeEngine
