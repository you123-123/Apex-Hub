local A = _G.Apex
local CD = {}
CD.Active = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LP = A.LP
local V3 = A.V3
local CF = A.CF

CD.DodgeEnabled = true
CD.ProjectileDodge = true
CD.SkillDodge = true
CD.AreaDodge = true
CD.ObservationDodge = true
CD.DodgeDistance = 15
CD.DodgeCooldown = 2
CD.DodgeDirection = "auto"

CD.LastDodgeTime = 0
CD.LastProjectileDodge = 0
CD.LastSkillDodge = 0
CD.LastAreaDodge = 0
CD.LastObservationDodge = 0
CD.DodgeCount = 0
CD.ThreatData = {}
CD.ProjectileCache = {}
CD.ObservedTargets = {}

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then end
    return ok, err
end

local function OnCooldown(key, cooldown)
    return CD.LastDodgeTime > 0 and (tick() - CD.LastDodgeTime) < cooldown
end

local function GetMyHRP()
    return A.HRP()
end

local function IsCharacterPart(part, root)
    if not root then return false end
    local p = part
    while p do
        if p == root then return true end
        p = p.Parent
    end
    return false
end

local function ComputeDodgeDirection(projPos, threatPos)
    local myHRP = GetMyHRP()
    if not myHRP then return V3(1, 0, 0) end
    local fromThreat = threatPos or (projPos or myHRP.Position)
    local away = (myHRP.Position - fromThreat)
    away = V3(away.X, 0, away.Z)
    if away.Magnitude < 0.001 then
        away = V3(1, 0, 0)
    end
    away = away.Unit
    if CD.DodgeDirection == "back" then
        return away
    end
    local right = away:Cross(V3(0, 1, 0)).Unit
    if math.random() < 0.5 then
        right = -right
    end
    local wallParams = RaycastParams.new()
    wallParams.FilterDescendantsInstances = {myHRP.Parent}
    wallParams.FilterType = Enum.RaycastFilterType.Blacklist
    local wallHit = SafeCall(Workspace.Raycast, Workspace, myHRP.Position, right, wallParams)
    if not wallHit then
        return right
    end
    local backHit = SafeCall(Workspace.Raycast, Workspace, myHRP.Position, away, wallParams)
    if not backHit then
        return away
    end
    return away
end

local function PerformDodge(reason, threatPos)
    local now = tick()
    if now - CD.LastDodgeTime < 0.15 then return false end
    local myHRP = GetMyHRP()
    local myHum = A.Hum()
    if not myHRP or not myHum then return false end
    if myHum.Health <= 0 then return false end
    if not A.Alive() then return false end

    local dir = ComputeDodgeDirection(nil, threatPos)
    local targetPos = myHRP.Position + dir * CD.DodgeDistance

    local wallParams = RaycastParams.new()
    wallParams.FilterDescendantsInstances = {myHRP.Parent}
    wallParams.FilterType = Enum.RaycastFilterType.Blacklist
    local hit = SafeCall(Workspace.Raycast, Workspace, myHRP.Position, dir * CD.DodgeDistance, wallParams)
    if hit then
        targetPos = hit.Position - dir * 3
    end

    CD.LastDodgeTime = now
    CD.DodgeCount = CD.DodgeCount + 1
    CD.LastReason = reason

    local ok = SafeCall(function() A.TweenTo(targetPos, 250) end)
    if not ok then
        SafeCall(function()
            local model = myHRP.Parent
            if model and model.PrimaryPart then
                model:SetPrimaryPartCFrame(CF.new(targetPos, model.PrimaryPart.CFrame.LookVector + targetPos))
            else
                myHRP.CFrame = CF.new(targetPos) + (myHRP.CFrame - myHRP.CFrame.Position)
            end
        end)
    end

    if CD.ObservationDodge then
        CD.LastObservationDodge = now
    end
    return true
end

local function DetectProjectiles()
    local myHRP = GetMyHRP()
    if not myHRP then return end
    local myPos = myHRP.Position
    for _, obj in pairs(SafeCall(Workspace.GetDescendants, Workspace) or {}) do
        if obj:IsA("BasePart") then
            local isProjectile = false
            local name = (obj.Name or ""):lower()
            if name:find("proj") or name:find("ball") or name:find("blast") or name:find("bullet") or name:find("fire") or name:find("wave") then
                isProjectile = true
            end
            if obj:FindFirstChild("Mesh") and (obj.Mesh.MeshType == Enum.MeshType.Sphere) then
                isProjectile = true
            end
            if not isProjectile then
                local cue = false
                for _, p in pairs(CD.ThreatData) do
                    if p and p.Part == obj then
                        cue = true
                        break
                    end
                end
                isProjectile = cue
            end
            if isProjectile then
                local root = obj.Parent
                if not IsCharacterPart(obj, root) then
                    local vel = obj.Velocity
                    local speed = vel.Magnitude
                    if speed > 8 then
                        local rel = obj.Position - myPos
                        if rel.Magnitude < 30 then
                            local dir = vel.Unit
                            local dot = rel.Unit:Dot(dir)
                            if dot < -0.6 then
                                local ray = SafeCall(Workspace.Raycast, Workspace, obj.Position, dir * 20)
                                if ray and ray.Instance then
                                    local hitRoot = ray.Instance.Parent
                                    if hitRoot == myHRP.Parent then
                                        CD.DetectProjectile = true
                                        if CD.ProjectileDodge then
                                            PerformDodge("Projectile", obj.Position)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function DetectSkillDodge()
    local myHRP = GetMyHRP()
    if not myHRP then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= A.LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local target = player.Character
            local hrp = target:FindFirstChild("HumanoidRootPart")
            local hum = target:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 and myHRP then
                local dist = (hrp.Position - myHRP.Position).Magnitude
                local hasHealthBar = target:FindFirstChild("HealthBar") or target:FindFirstChild("NameTag")
                local moving = hum.MoveDirection.Magnitude > 0.1
                local data = CD.ObservedTargets[target]
                local now = tick()
                if data and data.LastPos then
                    local movedDist = (hrp.Position - data.LastPos).Magnitude
                    if data.SinceStop and (now - data.SinceStop) < 0.5 and data.SinceStop > 0 and movedDist < 0.5 then
                    end
                end
                local bigAttackWindup = false
                if hasHealthBar and not moving and dist < 25 then
                    bigAttackWindup = true
                end
                if dist > 30 and target:FindFirstChild("Tool") and not moving then
                    bigAttackWindup = true
                end
                if bigAttackWindup then
                    if CD.SkillDodge and dist < 60 then
                        PerformDodge("Skill", hrp.Position)
                        CD.LastSkillDodge = tick()
                    end
                end
                CD.ObservedTargets[target] = {LastPos = hrp.Position, SinceStop = moving and nil or (CD.ObservedTargets[target] and CD.ObservedTargets[target].SinceStop or now)}
            end
        end
    end
end

local function DetectAreaDodge()
    local myHRP = GetMyHRP()
    if not myHRP then return end
    local myPos = myHRP.Position
    for _, obj in pairs(SafeCall(Workspace.GetDescendants, Workspace) or {}) do
        if obj:IsA("BasePart") then
            local name = (obj.Name or ""):lower()
            local isArea = name:find("explo") or name:find("boom") or name:find("aoe") or name:find("radius") or name:find("field") or name:find("zone")
            if isArea or obj:FindFirstChild("Explosion") then
                local dist = (obj.Position - myPos).Magnitude
                if dist < 12 then
                    if CD.AreaDodge then
                        PerformDodge("Area", obj.Position)
                        CD.LastAreaDodge = tick()
                    end
                end
            end
        end
    end
end

local function ScanThreats()
    if not CD.DodgeEnabled or not CD.Active then return end
    if not A.Alive() then return end
    if OnCooldown("any", CD.DodgeCooldown) and (tick() - CD.LastDodgeTime) > 0.9 then return end
    if CD.ProjectileDodge then
        DetectProjectiles()
    end
    if CD.SkillDodge then
        DetectSkillDodge()
    end
    if CD.AreaDodge then
        DetectAreaDodge()
    end
end

function CD.Start()
    if CD.Active then return end
    CD.Active = true
    CD.DodgeEnabled = true
    CD.LastDodgeTime = 0
    CD.ObservedTargets = {}
    SafeCall(function() A.Notify("Combat Dodge", "Auto Dodge System Activated", 2) end)
    task.spawn(function()
        while CD.Active do
            SafeCall(ScanThreats, CD)
            task.wait(0.1)
        end
    end)
end

function CD.Stop()
    CD.Active = false
    CD.ObservedTargets = {}
    SafeCall(function() A.Notify("Combat Dodge", "Auto Dodge System Deactivated", 2) end)
end

function CD.SetProperty(name, value)
    if CD[name] ~= nil then
        CD[name] = value
        return true
    end
    return false
end

function CD:ToggleDodge(v)
    CD.DodgeEnabled = v
end

function CD:SetDistance(v)
    CD.DodgeDistance = v
end

function CD:SetCooldown(v)
    CD.DodgeCooldown = v
end

function CD:SetDirection(v)
    CD.DodgeDirection = v
end

function CD:ForceDodge()
    local myHRP = GetMyHRP()
    if not myHRP then return false end
    return PerformDodge("Manual", myHRP.Position + V3(10, 0, 10))
end

A.CombatDodge = CD
A.Register("combat_dodge", A.CombatDodge)

return CD
