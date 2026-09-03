--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║  APEX HUB v13.0 - NEURAL TARGETING (التوجيه المحايد + الدماغ)     ║
    ║                      Core Module - Standalone                     ║
    ╚══════════════════════════════════════════════════════════════════╝

    نظام مستقل يجمع خوارزمية الاختيار العصبي (تنبؤ/رغبة/اختيار) مع
    محرك الدماغ القتالي (CombatBrain) وحلقته الآمنة القابلة للإيقاف.
    لا يبدأ تلقائياً. يعتمد على دوال A عامة. لا يستخدم continue.
--]]

local A = _G.Apex or {}

-- ── أدوات مساعدة محلية تُحاكي locals الأصلية عبر دوال A العامة ──
local function GetHRP(obj)
    if not obj then return nil end
    if obj:IsA("Model") then
        return obj:FindFirstChild("HumanoidRootPart")
            or obj:FindFirstChild("Torso")
            or obj:FindFirstChild("UpperTorso")
    end
    return obj
end

local function GetMyHRP()
    if A.HRP then return A.HRP() end
    return nil
end

local function DistanceTo(p1, p2)
    if not p1 or not p2 then return math.huge end
    local dx = (p1.X or p1.x or 0) - (p2.X or p2.x or 0)
    local dy = (p1.Y or p1.y or 0) - (p2.Y or p2.y or 0)
    local dz = (p1.Z or p1.z or 0) - (p2.Z or p2.z or 0)
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function IsAlive(t)
    if not t then return false end
    local char = t.Character or (t:IsA("Model") and t)
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return false end
    return hum.Health > 0 and hum.MaxHealth > 0
end

-- تنبؤ موضع الهدف بعد زمن يسحب حركته
function A.PredictTargetPosition(target, t)
    if not target then return nil end
    local hrp = GetHRP(target)
    local myHrp = GetMyHRP()
    if not hrp or not myHrp then return Vector3.new(0, 0, 0) end
    local pos = hrp.Position
    local vel = hrp.AssemblyLinearVelocity or { X = 0, Y = 0, Z = 0 }
    t = t or 0.15
    return {
        X = pos.X + (vel.X or 0) * t,
        Y = pos.Y + (vel.Y or 0) * t,
        Z = pos.Z + (vel.Z or 0) * t,
    }
end

function A.DesirabilityScore(target, maxRange, mode)
    local score = 0
    mode = mode or A.TargetingMode or "mix"
    if not target then return -math.huge end
    local dist = A.GetTargetDistance and A.GetTargetDistance(target) or math.huge
    local hp = A.GetTargetHealth and A.GetTargetHealth(target) or 100
    local humanoid = target.Character and target.Character:FindFirstChild("Humanoid")
    local lvl = humanoid and humanoid.MaxHealth or 100

    local wDist = 0.35
    local wHp = 0.30
    local wLvl = 0.20
    local wThreat = 0.15

    local distTerm = math.max(0, 1 - (dist / math.max(1, maxRange)))
    local hpTerm = math.max(0, 1 - (hp / math.max(1, lvl)))
    local lvlTerm = math.max(0, 1 - math.abs((lvl - 100) / 1000))

    if mode == "lowesthp" then
        score = hpTerm * 1.0 + distTerm * 0.5
    elseif mode == "closest" then
        score = distTerm * 1.0 + hpTerm * 0.3
    elseif mode == "highestlvl" then
        score = lvlTerm * 1.0 + distTerm * 0.4
    else
        score = distTerm * wDist + hpTerm * wHp + lvlTerm * wLvl + wThreat
    end
    return score
end

function A.SmartSelectTarget(candidates, maxRange, mode)
    if not candidates or #candidates == 0 then return nil, 0 end
    local best, bestScore = nil, -math.huge
    for _, t in ipairs(candidates) do
        local s = A.DesirabilityScore(t, maxRange, mode)
        if s > bestScore then
            best, bestScore = t, s
        end
    end
    return best, bestScore
end

function A.NeuralEngageBase(target, opts)
    opts = opts or {}
    local myHrp = GetMyHRP()
    if not target or not myHrp then return false end
    local range = A.GetTargetDistance and A.GetTargetDistance(target) or math.huge
    local desired = opts.meleeRange or A.MeleeRange or 12
    local skill = opts.skill or A.ActiveSkill

    local action = "idle"
    if range > desired then
        action = "chase"
        if A.PathfindToTarget then pcall(A.PathfindToTarget, target) end
    else
        action = "attack"
        if skill and A.SkillAttack then
            pcall(A.SkillAttack, target, skill)
        else
            A.ClickAttack(target)
        end
    end
    return action
end

function A.GroupTargetIDs()
    local zone = {}
    local myHrp = GetMyHRP()
    if not myHrp then return zone end
    local myPos = myHrp.Position
    local radius = A.AuraRange or 20
    for _, obj in ipairs(workspace:GetDescendants()) do
        local hrp = GetHRP(obj)
        if hrp then
            local d = DistanceTo(myPos, hrp.Position)
            if d <= radius then
                table.insert(zone, obj)
            end
        end
    end
    return zone
end

A.CombatBrainEnabled = false
A.CombatBrainActive = false

function A.CombatBrain(interval)
    interval = interval or 0.3
    if A.CombatBrainActive then return end
    A.CombatBrainActive = true
    A.CombatBrainEnabled = true
    task.spawn(function()
        while A.CombatBrainEnabled and A.CombatBrainActive do
            pcall(function()
                if A.AutoAttackEnabled then
                    local t = A.NeuralTarget
                    if not t or not (t.Parent and IsAlive(t)) then
                        local zone = A.GroupTargetIDs()
                        if #zone > 0 then
                            t = A.SmartSelectTarget(zone, A.AuraRange or 20, A.TargetingMode)
                            A.NeuralTarget = t
                        end
                    end
                    if t then
                        pcall(A.NeuralEngage, t, { skill = A.ActiveSkill })
                    end
                end
            end)
            task.wait(interval)
        end
        A.CombatBrainActive = false
    end)
end

function A.StopCombatBrain()
    A.CombatBrainEnabled = false
end

return A