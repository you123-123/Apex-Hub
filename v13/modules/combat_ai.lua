local A = _G.Apex
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local LP = A.LP
local V3 = A.V3
local CF = A.CF

A.CombatAI = {}
local CA = A.CombatAI

CA.Active = false
CA.Target = nil
CA.AIState = "Idle"
CA.CombatHistory = {}
CA.PredictionData = {}
CA.SkillCooldowns = {}
CA.ComboIndex = 0
CA.ComboStartTime = 0
CA.TotalDamage = 0
CA.TotalKills = 0
CA.LastAttackTime = 0
CA.LastDodgeTime = 0
CA.LastCounterTime = 0
CA.OpponentAnalysis = {}
CA.AttackPatternBuffer = {}
CA.AntiStunActive = false
CA.ComboBreakerReady = true
CA.RecoveryHealthThreshold = 0.3
CA.ThreatLevel = 0
CA.EngagementHistory = {}
CA.CurrentPreset = nil
CA.AnimationCancelQueue = {}
CA.PredictionModel = {Velocity = V3(0,0,0), Acceleration = V3(0,0,0), LastPosition = nil, LastTime = 0, History = {}}

CA.ComboPresets = {
    Aggressive = {
        Name = "Aggressive",
        Skills = {"Z", "X", "C", "V"},
        Timing = {0.08, 0.08, 0.08, 0.1},
        Positioning = "Close",
        Playstyle = "Aggressive",
        Description = "Maximum pressure, close range, non-stop attacks",
        DashAfterCombo = true,
        GapCloseFirst = true,
        AutoFruit = true,
        PerfectBlock = false
    },
    Defensive = {
        Name = "Defensive",
        Skills = {"V", "C", "X", "Z"},
        Timing = {0.3, 0.25, 0.2, 0.15},
        Positioning = "Far",
        Playstyle = "Defensive",
        Description = "Wait for openings, punish mistakes, block often",
        DashAfterCombo = false,
        GapCloseFirst = false,
        AutoFruit = false,
        PerfectBlock = true
    },
    Burst = {
        Name = "Burst",
        Skills = {"C", "Z", "X", "V"},
        Timing = {0.05, 0.05, 0.05, 0.05},
        Positioning = "Close",
        Playstyle = "Aggressive",
        Description = "Dump all skills instantly for maximum burst damage",
        DashAfterCombo = true,
        GapCloseFirst = true,
        AutoFruit = true,
        PerfectBlock = false
    },
    Execute = {
        Name = "Execute",
        Skills = {"V", "Z", "X", "C"},
        Timing = {0.15, 0.1, 0.1, 0.1},
        Positioning = "Behind",
        Playstyle = "Balanced",
        Description = "Execute low health targets with strongest skills first",
        DashAfterCombo = false,
        GapCloseFirst = true,
        AutoFruit = true,
        PerfectBlock = false
    },
    StunLock = {
        Name = "StunLock",
        Skills = {"Z", "X", "C", "V"},
        Timing = {0.35, 0.35, 0.35, 0.2},
        Positioning = "Close",
        Playstyle = "Aggressive",
        Description = "Chain stuns to prevent opponent from acting",
        DashAfterCombo = false,
        GapCloseFirst = true,
        AutoFruit = false,
        PerfectBlock = false
    },
    PvP = {
        Name = "PvP",
        Skills = {"X", "C", "Z", "V"},
        Timing = {0.12, 0.15, 0.18, 0.1},
        Positioning = "Circle",
        Playstyle = "Balanced",
        Description = "Optimized for player vs player combat",
        DashAfterCombo = true,
        GapCloseFirst = false,
        AutoFruit = true,
        PerfectBlock = true
    },
    Boss = {
        Name = "Boss",
        Skills = {"Z", "X", "C", "V"},
        Timing = {0.2, 0.2, 0.2, 0.15},
        Positioning = "Behind",
        Playstyle = "Balanced",
        Description = "Optimized for boss fights with positioning",
        DashAfterCombo = false,
        GapCloseFirst = false,
        AutoFruit = true,
        PerfectBlock = true
    },
    Counter = {
        Name = "Counter",
        Skills = {"V", "C", "X", "Z"},
        Timing = {0.1, 0.1, 0.1, 0.1},
        Positioning = "Far",
        Playstyle = "Defensive",
        Description = "Counter-attack focused, punish every move",
        DashAfterCombo = true,
        GapCloseFirst = false,
        AutoFruit = false,
        PerfectBlock = true
    }
}

CA.AITargeting = {}

function CA.AITargeting.SelectTarget(mode)
    if not A.Alive() then return nil end
    local myPos = A.GetPosition()
    local candidates = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local dist = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
            local hum = player.Character:FindFirstChild("Humanoid")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local maxDist = 350
            if A.Sea() == 2 then maxDist = 500 end
            if A.Sea() == 3 then maxDist = 600 end
            if dist <= maxDist then
                local bounty = player:FindFirstChild("Data") and player.Data:FindFirstChild("Bounty") and player.Data.Bounty.Value or 0
                table.insert(candidates, {
                    Player = player,
                    Distance = dist,
                    Health = hum.Health,
                    MaxHealth = hum.MaxHealth,
                    HealthPercent = hum.Health / math.max(hum.MaxHealth, 1),
                    Position = hrp.Position,
                    Velocity = hrp.Velocity,
                    Bounty = bounty,
                    Threat = CA.AITargeting.CalculateThreat(player)
                })
            end
        end
    end
    if #candidates == 0 then return nil end
    local mode = mode or "Smart"
    if mode == "Closest" then
        table.sort(candidates, function(a, b) return a.Distance < b.Distance end)
    elseif mode == "Weakest" then
        table.sort(candidates, function(a, b) return a.Health < b.Health end)
    elseif mode == "Strongest" then
        table.sort(candidates, function(a, b) return a.Health > b.Health end)
    elseif mode == "Lowest" then
        table.sort(candidates, function(a, b) return a.HealthPercent < b.HealthPercent end)
    elseif mode == "Highest" then
        table.sort(candidates, function(a, b) return a.HealthPercent > b.HealthPercent end)
    elseif mode == "Random" then
        return candidates[math.random(1, #candidates)]
    elseif mode == "HighestBounty" then
        table.sort(candidates, function(a, b) return a.Bounty > b.Bounty end)
    elseif mode == "LowestHealth" then
        table.sort(candidates, function(a, b) return a.HealthPercent < b.HealthPercent end)
    elseif mode == "Smart" then
        for _, c in pairs(candidates) do
            c.Score = 0
            c.Score = c.Score + (1 - c.Distance / 350) * 30
            c.Score = c.Score + (1 - c.HealthPercent) * 40
            c.Score = c.Score + math.min(c.Threat, 30)
            local now = tick()
            for _, hist in pairs(CA.CombatHistory) do
                if hist.Target == c.Player.Name and hist.Time > now - 60 then
                    c.Score = c.Score + 10
                end
            end
            if c.Player.Team and c.Player.Team == LP.Team then
                c.Score = -9999
            end
        end
        table.sort(candidates, function(a, b) return a.Score > b.Score end)
    end
    local best = candidates[1]
    if best and best.Player then
        return best.Player
    end
    return nil
end

function CA.AITargeting.PredictMovement(target, time)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        return V3(0, 0, 0)
    end
    local hrp = target.Character.HumanoidRootPart
    local currentPos = hrp.Position
    local currentVel = hrp.Velocity
    local model = CA.PredictionModel
    local now = tick()
    if model.LastPosition and model.LastTime > 0 then
        local dt = now - model.LastTime
        if dt > 0 then
            local instantVel = (currentPos - model.LastPosition) / dt
            model.Acceleration = (instantVel - model.Velocity) / math.max(dt, 0.01)
            model.Velocity = instantVel
        end
    end
    model.LastPosition = currentPos
    model.LastTime = now
    table.insert(model.History, {Position = currentPos, Velocity = currentVel, Time = now})
    if #model.History > 50 then
        table.remove(model.History, 1)
    end
    local predictedPos = currentPos + currentVel * time + 0.5 * model.Acceleration * time * time
    local groundCheck = workspace:Raycast(predictedPos, V3(0, -50, 0), RaycastParams.new())
    if not groundCheck then
        local originalY = currentPos.Y
        predictedPos = V3(predictedPos.X, originalY, predictedPos.Z)
    end
    return predictedPos
end

function CA.AITargeting.LeadTarget(target, projectileSpeed)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        return V3(0, 0, 0)
    end
    local hrp = target.Character.HumanoidRootPart
    local myHRP = A.HRP()
    if not myHRP then return hrp.Position end
    local targetPos = hrp.Position
    local targetVel = hrp.Velocity
    local myPos = myHRP.Position
    local displacement = targetPos - myPos
    local distance = displacement.Magnitude
    local timeToHit = distance / math.max(projectileSpeed, 1)
    local leadPos = targetPos + targetVel * timeToHit
    local gravityComp = V3(0, -0.5 * 196.2 * timeToHit * timeToHit, 0)
    leadPos = leadPos + gravityComp
    return leadPos
end

function CA.AITargeting.CalculateThreat(player)
    if not player or not player.Character then return 0 end
    local threat = 0
    local myLv = A.Lv()
    local myHealth = A.Hum() and A.Hum().Health or 0
    local myMaxHealth = A.Hum() and A.Hum().MaxHealth or 1
    local hum = player.Character:FindFirstChild("Humanoid")
    if not hum then return 0 end
    local theirLv = player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") and player.Data.Level.Value or 1
    local theirHealth = hum.Health
    local theirMaxHealth = hum.MaxHealth
    local theirHRP = player.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = A.HRP()
    local distance = 300
    if theirHRP and myHRP then
        distance = (theirHRP.Position - myHRP.Position).Magnitude
    end
    if theirLv > myLv then
        threat = threat + math.min((theirLv - myLv) / 100, 25)
    end
    if theirHealth / math.max(theirMaxHealth, 1) > myHealth / math.max(myMaxHealth, 1) then
        threat = threat + 15
    end
    if distance < 30 then
        threat = threat + 20
    elseif distance < 60 then
        threat = threat + 10
    end
    local theirGear = 0
    for _, tool in pairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") then
            theirGear = theirGear + 1
        end
    end
    threat = threat + theirGear * 5
    local bounty = player:FindFirstChild("Data") and player.Data:FindFirstChild("Bounty") and player.Data.Bounty.Value or 0
    threat = threat + math.min(bounty / 1000000, 15)
    return math.clamp(threat, 0, 100)
end

function CA.AITargeting.RankTargets(players)
    local ranked = {}
    for _, player in pairs(players) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local threat = CA.AITargeting.CalculateThreat(player)
            local myHRP = A.HRP()
            local dist = myHRP and (player.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude or 999
            table.insert(ranked, {
                Player = player,
                Threat = threat,
                Distance = dist,
                Score = threat * 0.4 + (1 - math.clamp(dist / 350, 0, 1)) * 60
            })
        end
    end
    table.sort(ranked, function(a, b) return a.Score > b.Score end)
    return ranked
end

function CA.AITargeting.ShouldEngage(target)
    if not target or not target.Character then return false end
    if target.Team and target.Team == LP.Team then return false end
    local hum = target.Character:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local myHealth = A.Hum() and A.Hum().Health / math.max(A.Hum().MaxHealth, 1) or 1
    local theirHealth = hum.Health / math.max(hum.MaxHealth, 1)
    local threat = CA.AITargeting.CalculateThreat(target)
    local myHRP = A.HRP()
    local theirHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP or not theirHRP then return false end
    local dist = (theirHRP.Position - myHRP.Position).Magnitude
    if myHealth < CA.RecoveryHealthThreshold and theirHealth > 0.5 then
        return false
    end
    if CA.AIState == "Fleeing" and threat > 60 then
        return false
    end
    if dist > 400 then return false end
    if myHealth > 0.7 then return true end
    if theirHealth < 0.3 then return true end
    if threat < 40 then return true end
    if dist > 100 and myHealth < 0.4 then return false end
    return true
end

function CA.AITargeting.ShouldFlee(target)
    if not target or not target.Character then return false end
    local hum = target.Character:FindFirstChild("Humanoid")
    if not hum then return false end
    local myHealth = A.Hum() and A.Hum().Health / math.max(A.Hum().MaxHealth, 1) or 1
    local theirHealth = hum.Health / math.max(hum.MaxHealth, 1)
    local threat = CA.AITargeting.CalculateThreat(target)
    if myHealth < 0.2 then return true end
    if myHealth < 0.35 and theirHealth > 0.7 and threat > 50 then return true end
    if myHealth < 0.5 and theirHealth > 0.8 and threat > 70 then return true end
    local nearbyEnemies = 0
    local myHRP = A.HRP()
    if myHRP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player ~= target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local d = (player.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
                if d < 80 then
                    nearbyEnemies = nearbyEnemies + 1
                end
            end
        end
    end
    if nearbyEnemies >= 3 and myHealth < 0.6 then return true end
    return false
end

function CA.AITargeting.FindOptimalRange(weapon)
    if not weapon then return 15 end
    local wName = weapon.Name:lower()
    if wName:find("sword") or wName:find("blade") then
        return 12
    elseif wName:find("gun") or wName:find("cannon") then
        return 80
    elseif wName:find("fruit") or wName:find("power") then
        return 40
    elseif wName:find("fighting") or wName:find("box") then
        return 8
    end
    return 15
end

CA.ComboEngine = {}

function CA.ComboEngine.ExecuteCombo(preset, target)
    if not CA.Active then return end
    if not preset or not CA.ComboPresets[preset] then return end
    if not target or not target.Character then return end
    local p = CA.ComboPresets[preset]
    CA.CurrentPreset = preset
    CA.ComboIndex = 0
    CA.ComboStartTime = tick()
    CA.AIState = "Comboing"
    for i, skillKey in ipairs(p.Skills) do
        if not CA.Active then break end
        if not target or not target.Character then break end
        local hum = target.Character:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then break end
        CA.ComboEngine.ComboStep(preset, i)
        local timing = p.Timing[i] or 0.1
        local jitter = (math.random() - 0.5) * 0.04
        wait(math.max(timing + jitter, 0.03))
        if p.Positioning == "Behind" then
            CA.ComboEngine.PositionBehindTarget(target)
        elseif p.Positioning == "Circle" then
            CA.ComboEngine.CircleTarget(target, 15)
        end
    end
    if p.DashAfterCombo then
        CA.ComboEngine.AnimationCancel(target)
    end
    CA.AIState = "Idle"
end

function CA.ComboEngine.ComboStep(preset, index)
    if not CA.Active then return end
    local p = CA.ComboPresets[preset]
    if not p then return end
    local skillKey = p.Skills[index]
    if not skillKey then return end
    local cooldownKey = preset .. "_" .. skillKey
    if CA.SkillCooldowns[cooldownKey] and tick() - CA.SkillCooldowns[cooldownKey] < 1.5 then
        return
    end
    CA.SkillCooldowns[cooldownKey] = tick()
    CA.AttackWithKey(skillKey)
    CA.TotalDamage = CA.TotalDamage + 1
end

function CA.ComboEngine.ResetCombo()
    CA.ComboIndex = 0
    CA.ComboStartTime = 0
    CA.CurrentPreset = nil
    CA.AIState = "Idle"
    CA.AnimationCancelQueue = {}
end

function CA.ComboEngine.GetComboDamage(preset)
    local p = CA.ComboPresets[preset]
    if not p then return 0 end
    local totalDmg = 0
    local fruitStats = A.G:FindFirstChild("FruitStats")
    for _, skillKey in ipairs(p.Skills) do
        local skillDmg = 0
        if fruitStats and fruitStats:FindFirstChild(skillKey) then
            skillDmg = fruitStats[skillKey].Value
        else
            skillDmg = A.Lv() * 2.5 + 50
        end
        totalDmg = totalDmg + skillDmg
    end
    return totalDmg
end

function CA.ComboEngine.GetComboTime(preset)
    local p = CA.ComboPresets[preset]
    if not p then return 0 end
    local totalTime = 0
    for _, t in ipairs(p.Timing) do
        totalTime = totalTime + t
    end
    return totalTime
end

function CA.ComboEngine.OptimalCombo(target, distance, health)
    if not target then return "Aggressive" end
    local bestPreset = "Aggressive"
    local bestScore = 0
    local theirHealth = 1
    if target.Character and target.Character:FindFirstChild("Humanoid") then
        theirHealth = target.Character.Humanoid.Health / math.max(target.Character.Humanoid.MaxHealth, 1)
    end
    local scores = {}
    scores.Aggressive = (1 - distance / 100) * 30 + (1 - theirHealth) * 20 + 20
    scores.Defensive = theirHealth * 25 + (1 - health) * 30
    scores.Burst = theirHealth < 0.3 and 50 or 10
    scores.Execute = theirHealth < 0.25 and 60 or 5
    scores.StunLock = distance < 20 and 40 or 10
    scores.PvP = 30
    scores.Boss = target:FindFirstChild("BossTag") and 50 or 5
    scores.Counter = 25
    for name, score in pairs(scores) do
        if score > bestScore then
            bestScore = score
            bestPreset = name
        end
    end
    return bestPreset
end

function CA.ComboEngine.ChainSkills(skills, target)
    if not CA.Active then return end
    if not skills or #skills == 0 then return end
    for i, skillKey in ipairs(skills) do
        if not CA.Active then break end
        if not target or not target.Character then break end
        local hum = target.Character:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then break end
        CA.AttackWithKey(skillKey)
        local delay = 0.1 + (math.random() - 0.5) * 0.03
        wait(math.max(delay, 0.05))
    end
end

function CA.ComboEngine.CancelAnimation()
    local char = A.Char()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        if track.IsPlaying then
            track:Stop(0)
        end
    end
end

function CA.ComboEngine.AnimationCancel(target)
    wait(0.05)
    CA.ComboEngine.CancelAnimation()
    local myHRP = A.HRP()
    local theirHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if myHRP and theirHRP then
        local dir = (myHRP.Position - theirHRP.Position).Unit
        local dashPos = myHRP.Position + dir * 8
        A.TpTo(dashPos, 5)
    end
    wait(0.08)
    CA.ComboEngine.CancelAnimation()
end

function CA.ComboEngine.PositionBehindTarget(target)
    if not target or not target.Character then return end
    local theirHRP = target.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = A.HRP()
    if not theirHRP or not myHRP then return end
    local lookVec = theirHRP.CFrame.LookVector
    local behindPos = theirHRP.Position - lookVec * 6
    A.TpTo(behindPos, 4)
end

function CA.ComboEngine.CircleTarget(target, radius)
    if not target or not target.Character then return end
    local theirHRP = target.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = A.HRP()
    if not theirHRP or not myHRP then return end
    local angle = math.rad(tick() * 120 % 360)
    local circlePos = theirHRP.Position + V3(math.cos(angle) * radius, 0, math.sin(angle) * radius)
    A.TpTo(circlePos, 4)
end

CA.DodgeSystem = {}

function CA.DodgeSystem.SmartDodge(target, attack)
    if not CA.Active then return false end
    local now = tick()
    if now - CA.LastDodgeTime < 0.4 then return false end
    local dodgeDir = CA.DodgeSystem.GetDodgeDirection(target, attack)
    local myHRP = A.HRP()
    if not myHRP then return false end
    local dodgePos = myHRP.Position + dodgeDir * 18
    CA.ComboEngine.CancelAnimation()
    A.TpTo(dodgePos, 3)
    CA.LastDodgeTime = now
    wait(0.1)
    return true
end

function CA.DodgeSystem.PredictAttack(target)
    if not target or not target.Character then return nil end
    local hrp = target.Character.HumanoidRootPart
    local myHRP = A.HRP()
    if not hrp or not myHRP then return nil end
    local toMe = (myHRP.Position - hrp.Position).Unit
    local theirLook = hrp.CFrame.LookVector
    local dot = toMe:Dot(theirLook)
    if dot > 0.7 then
        local dist = (hrp.Position - myHRP.Position).Magnitude
        if dist < 40 then
            return {Type = "Melee", Direction = toMe, Urgency = dot * 100}
        end
    end
    if dot > 0.5 then
        return {Type = "Ranged", Direction = toMe, Urgency = dot * 70}
    end
    return nil
end

function CA.DodgeSystem.GetDodgeDirection(target, attack)
    local myHRP = A.HRP()
    local theirHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP or not theirHRP then return V3(1, 0, 0) end
    local toMe = (myHRP.Position - theirHRP.Position).Unit
    local right = toMe:Cross(V3(0, 1, 0)).Unit
    local dodgeOptions = {right, -right, V3(0, 1, 0), toMe * -1}
    local bestDir = right
    local bestScore = -999
    for _, dir in pairs(dodgeOptions) do
        local score = 0
        local testPos = myHRP.Position + dir * 18
        local rayParams = RaycastParams.new()
        local ray = workspace:Raycast(myHRP.Position, dir * 18, rayParams)
        if not ray then
            score = score + 30
        end
        local awayFromEnemy = dir:Dot(toMe)
        if awayFromEnemy > 0 then
            score = score + 20
        end
        if dir.Y > 0.5 then
            score = score + 10
        end
        if score > bestScore then
            bestScore = score
            bestDir = dir
        end
    end
    return bestDir
end

function CA.DodgeSystem.DodgeCounter(target)
    if not CA.Active then return end
    local dodged = CA.DodgeSystem.SmartDodge(target, nil)
    if dodged then
        wait(0.15)
        local preset = CA.ComboEngine.OptimalCombo(target, 20, A.Hum().Health / math.max(A.Hum().MaxHealth, 1))
        CA.ComboEngine.ExecuteCombo(preset, target)
    end
end

function CA.DodgeSystem.BlockAndCounter(target)
    if not CA.Active then return end
    local myChar = A.Char()
    if not myChar then return end
    local equipped = myChar:FindFirstChildOfClass("Tool")
    if equipped then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        wait(0.5)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    end
    wait(0.1)
    local preset = CA.ComboEngine.OptimalCombo(target, 15, A.Hum().Health / math.max(A.Hum().MaxHealth, 1))
    CA.ComboEngine.ExecuteCombo(preset, target)
end

function CA.DodgeSystem.ParryWindow(target)
    if not target or not target.Character then return false end
    local hrp = target.Character.HumanoidRootPart
    local myHRP = A.HRP()
    if not hrp or not myHRP then return false end
    local dist = (hrp.Position - myHRP.Position).Magnitude
    if dist > 25 then return false end
    local prediction = CA.DodgeSystem.PredictAttack(target)
    if prediction and prediction.Urgency > 60 then
        return true
    end
    return false
end

CA.CounterSystem = {}

CA.CounterSystem.CounterTypes = {
    Parry = {Name = "Parry", Window = 0.3, Damage = 1.5, Cooldown = 2},
    Dodge = {Name = "Dodge", Window = 0.5, Damage = 0, Cooldown = 1},
    Block = {Name = "Block", Window = 0.8, Damage = 0.5, Cooldown = 3},
    Reposition = {Name = "Reposition", Window = 1.0, Damage = 0, Cooldown = 1.5}
}

function CA.CounterSystem.AutoCounter(target)
    if not CA.Active then return end
    local now = tick()
    if now - CA.LastCounterTime < 1.0 then return end
    local opportunity = CA.CounterSystem.DetectCounterOpportunity(target)
    if opportunity then
        CA.CounterSystem.ExecuteCounter(target, opportunity.Type)
        CA.LastCounterTime = now
    end
end

function CA.CounterSystem.DetectCounterOpportunity(target)
    if not target or not target.Character then return nil end
    local hrp = target.Character.HumanoidRootPart
    local myHRP = A.HRP()
    if not hrp or not myHRP then return nil end
    local dist = (hrp.Position - myHRP.Position).Magnitude
    local prediction = CA.DodgeSystem.PredictAttack(target)
    local theirHealth = target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health / math.max(target.Character.Humanoid.MaxHealth, 1) or 1
    if prediction and prediction.Type == "Melee" and dist < 25 then
        local rng = math.random()
        if rng < 0.4 then
            return {Type = "Parry"}
        elseif rng < 0.7 then
            return {Type = "Block"}
        else
            return {Type = "Dodge"}
        end
    end
    if prediction and prediction.Type == "Ranged" then
        return {Type = "Dodge"}
    end
    if theirHealth < 0.3 and dist < 30 then
        return {Type = "Parry"}
    end
    if dist > 50 then
        return {Type = "Reposition"}
    end
    return nil
end

function CA.CounterSystem.ExecuteCounter(target, counterType)
    if not CA.Active then return end
    local cType = CA.CounterSystem.CounterTypes[counterType]
    if not cType then return end
    if counterType == "Parry" then
        CA.DodgeSystem.BlockAndCounter(target)
    elseif counterType == "Dodge" then
        CA.DodgeSystem.DodgeCounter(target)
    elseif counterType == "Block" then
        CA.DodgeSystem.BlockAndCounter(target)
    elseif counterType == "Reposition" then
        CA.ComboEngine.PositionBehindTarget(target)
        wait(0.1)
        local preset = CA.ComboEngine.OptimalCombo(target, 15, A.Hum().Health / math.max(A.Hum().MaxHealth, 1))
        CA.ComboEngine.ExecuteCombo(preset, target)
    end
end

CA.AdaptiveCombo = {}

function CA.AdaptiveCombo.AdaptCombo(target, history)
    if not target then return "Aggressive" end
    local analysis = CA.AdaptiveCombo.AnalyzeOpponent(target)
    CA.OpponentAnalysis[target.Name] = analysis
    if analysis.Playstyle == "Aggressive" then
        return "Defensive"
    elseif analysis.Playstyle == "Defensive" then
        return "Aggressive"
    elseif analysis.Playstyle == "Coward" then
        return "Aggressive"
    elseif analysis.Playstyle == "Spammer" then
        return "Counter"
    elseif analysis.Playstyle == "Technical" then
        return "Burst"
    end
    return "PvP"
end

function CA.AdaptiveCombo.AnalyzeOpponent(player)
    if not player then return {Playstyle = "Unknown", Weakness = "None", Aggression = 0.5, Pattern = {} } end
    local aggression = 0
    local defense = 0
    local patterns = {}
    local myHRP = A.HRP()
    local theirHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if myHRP and theirHRP then
        local dist = (theirHRP.Position - myHRP.Position).Magnitude
        if dist < 20 then aggression = aggression + 2 end
        if dist > 50 then defense = defense + 2 end
    end
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        local hp = hum.Health / math.max(hum.MaxHealth, 1)
        if hp < 0.3 then defense = defense + 3 end
    end
    local playstyle = "Balanced"
    if aggression > defense + 2 then
        playstyle = "Aggressive"
    elseif defense > aggression + 2 then
        playstyle = "Defensive"
    end
    local weakness = CA.AdaptiveCombo.GetOpponentWeakness(player)
    return {Playstyle = playstyle, Weakness = weakness, Aggression = aggression / math.max(aggression + defense, 1), Pattern = patterns}
end

function CA.AdaptiveCombo.GetOpponentWeakness(player)
    if not player then return "Unknown" end
    local analysis = CA.OpponentAnalysis[player.Name]
    if analysis then
        if analysis.Playstyle == "Aggressive" then return "BackOff"
        elseif analysis.Playstyle == "Defensive" then return "Pressure"
        end
    end
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum and hum.Health / math.max(hum.MaxHealth, 1) < 0.3 then
        return "LowHealth"
    end
    return "Unknown"
end

function CA.AdaptiveCombo.AdjustStrategy(player, state)
    if not player then return end
    local analysis = CA.AdaptiveCombo.AnalyzeOpponent(player)
    CA.OpponentAnalysis[player.Name] = analysis
    if state == "Winning" then
        CA.RecoveryHealthThreshold = 0.2
    elseif state == "Losing" then
        CA.RecoveryHealthThreshold = 0.5
    elseif state == "Even" then
        CA.RecoveryHealthThreshold = 0.35
    end
end

CA.AntiCombo = {}

function CA.AntiCombo.DetectCombo(target)
    if not target or not target.Character then return false end
    local hrp = target.Character.HumanoidRootPart
    local myHRP = A.HRP()
    if not hrp or not myHRP then return false end
    local dist = (hrp.Position - myHRP.Position).Magnitude
    if dist > 30 then return false end
    local now = tick()
    local recentHits = 0
    for i = #CA.AttackPatternBuffer, 1, -1 do
        local entry = CA.AttackPatternBuffer[i]
        if now - entry.Time < 1.5 then
            if entry.IsHit then
                recentHits = recentHits + 1
            end
        else
            break
        end
    end
    if recentHits >= 3 then
        return true
    end
    return false
end

function CA.AntiCombo.BreakCombo()
    CA.AntiStunActive = true
    CA.ComboBreakerReady = false
    local myHRP = A.HRP()
    if myHRP then
        local randomDir = V3(math.random(-1, 1), math.random(0, 1), math.random(-1, 1)).Unit
        local escapePos = myHRP.Position + randomDir * 25
        A.TpTo(escapePos, 2)
    end
    wait(0.5)
    CA.AntiStunActive = false
    wait(3)
    CA.ComboBreakerReady = true
end

function CA.AntiCombo.AntiStunlock()
    if not CA.Active then return end
    local myHum = A.Hum()
    if not myHum then return end
    local myHealth = myHum.Health / math.max(myHum.MaxHealth, 1)
    if myHealth < 0.15 and CA.ComboBreakerReady then
        CA.AntiCombo.BreakCombo()
    end
end

function CA.AntiCombo.RecoverySequence()
    CA.AIState = "Recovering"
    CA.ComboEngine.ResetCombo()
    local myHRP = A.HRP()
    if myHRP then
        local awayDir = V3(math.random() - 0.5, 0, math.random() - 0.5).Unit
        local retreatPos = myHRP.Position + awayDir * 40
        A.TpTo(retreatPos, 3)
    end
    wait(1)
    CA.AIState = "Idle"
end

CA.PredictionEngine = {}

function CA.PredictionEngine.PredictNextAction(target)
    if not target then return "Unknown" end
    local analysis = CA.OpponentAnalysis[target.Name]
    if not analysis then
        analysis = CA.AdaptiveCombo.AnalyzeOpponent(target)
        CA.OpponentAnalysis[target.Name] = analysis
    end
    local theirHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = A.HRP()
    if not theirHRP or not myHRP then return "Unknown" end
    local dist = (theirHRP.Position - myHRP.Position).Magnitude
    local theirLook = theirHRP.CFrame.LookVector
    local toMe = (myHRP.Position - theirHRP.Position).Unit
    local facingMe = theirLook:Dot(toMe) > 0.6
    if facingMe and dist < 30 then
        return "Attack"
    elseif facingMe and dist < 60 then
        return "Approach"
    elseif not facingMe and dist < 20 then
        return "Flee"
    else
        return "Idle"
    end
end

function CA.PredictionEngine.PredictPosition(target, time)
    return CA.AITargeting.PredictMovement(target, time)
end

function CA.PredictionEngine.PredictDirection(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        return V3(0, 0, 0)
    end
    local hrp = target.Character.HumanoidRootPart
    return hrp.CFrame.LookVector
end

function CA.PredictionEngine.PredictAttackPattern(player)
    if not player then return {} end
    local buffer = {}
    local now = tick()
    for i = #CA.AttackPatternBuffer, 1, -1 do
        local entry = CA.AttackPatternBuffer[i]
        if now - entry.Time < 10 and entry.Player == player.Name then
            table.insert(buffer, entry)
        end
    end
    local pattern = {}
    for _, b in ipairs(buffer) do
        table.insert(pattern, b.Action)
    end
    return pattern
end

function CA.PredictionEngine.UpdatePredictionModel(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = target.Character.HumanoidRootPart
    local now = tick()
    local model = CA.PredictionModel
    table.insert(model.History, {
        Position = hrp.Position,
        Velocity = hrp.Velocity,
        Time = now,
        Facing = hrp.CFrame.LookVector
    })
    if #model.History > 100 then
        table.remove(model.History, 1)
    end
end

function CA.AttackWithKey(key)
    if not CA.Active then return end
    local char = A.Char()
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local remoteName = key .. "Remotes"
        local remote = tool:FindFirstChild(remoteName) or tool:FindFirstChild(key)
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer()
        end
    end
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    RunService.Heartbeat:Wait()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
    table.insert(CA.AttackPatternBuffer, {Action = key, Time = tick(), IsHit = true, Player = CA.Target and CA.Target.Name or "Unknown"})
    if #CA.AttackPatternBuffer > 50 then
        table.remove(CA.AttackPatternBuffer, 1)
    end
end

function CA.FightWithAI(target)
    if not CA.Active then return end
    if not target or not target.Character then return end
    local hum = target.Character:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local myHRP = A.HRP()
    local theirHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP or not theirHRP then return end
    local dist = (theirHRP.Position - myHRP.Position).Magnitude
    local myHealth = A.Hum() and A.Hum().Health / math.max(A.Hum().MaxHealth, 1) or 1
    local theirHealth = hum.Health / math.max(hum.MaxHealth, 1)
    if CA.AntiCombo.DetectCombo(target) and CA.ComboBreakerReady then
        CA.AntiCombo.BreakCombo()
        return
    end
    CA.PredictionEngine.UpdatePredictionModel(target)
    local predictedAction = CA.PredictionEngine.PredictNextAction(target)
    if predictedAction == "Attack" then
        local dodgeChance = CA.DodgeSystem.ParryWindow(target) and 0.8 or 0.5
        if math.random() < dodgeChance then
            CA.DodgeSystem.SmartDodge(target, nil)
            return
        end
    end
    if CA.AITargeting.ShouldFlee(target) then
        CA.AntiCombo.RecoverySequence()
        return
    end
    CA.AdaptiveCombo.AdjustStrategy(target, myHealth > theirHealth + 0.15 and "Winning" or (myHealth < theirHealth - 0.15 and "Losing" or "Even"))
    local optimalPreset = CA.AdaptiveCombo.AdaptCombo(target, CA.CombatHistory)
    local gapCloseDist = 30
    if CA.ComboPresets[optimalPreset].Positioning == "Far" then
        gapCloseDist = 60
    end
    if dist > gapCloseDist then
        A.TweenTo(theirHRP.Position, 200)
        wait(0.1)
    else
        CA.ComboEngine.ExecuteCombo(optimalPreset, target)
    end
    CA.CounterSystem.AutoCounter(target)
end

function CA.ProcessAITarget()
    if not CA.Active then return end
    if CA.Target and CA.Target.Character and CA.Target.Character:FindFirstChild("Humanoid") and CA.Target.Character.Humanoid.Health > 0 then
        local myHRP = A.HRP()
        local theirHRP = CA.Target.Character:FindFirstChild("HumanoidRootPart")
        if myHRP and theirHRP then
            local dist = (theirHRP.Position - myHRP.Position).Magnitude
            if dist > 500 then
                CA.Target = nil
                CA.AIState = "Searching"
            end
        end
    else
        CA.Target = nil
        CA.AIState = "Searching"
    end
    if not CA.Target then
        local mode = "Smart"
        CA.Target = CA.AITargeting.SelectTarget(mode)
        if CA.Target then
            CA.AIState = "Engaging"
        end
    end
end

function CA.UpdateCombatState()
    if not CA.Active then return end
    local myHum = A.Hum()
    if not myHum then return end
    local myHealth = myHum.Health / math.max(myHum.MaxHealth, 1)
    if myHealth < CA.RecoveryHealthThreshold then
        CA.AntiCombo.RecoverySequence()
        return
    end
    if CA.Target then
        CA.FightWithAI(CA.Target)
    else
        CA.ProcessAITarget()
    end
end

function CA.GetAIDecision()
    local state = CA.AIState
    local target = CA.Target and CA.Target.Name or "None"
    local preset = CA.CurrentPreset or "None"
    local health = A.Hum() and string.format("%.1f%%", A.Hum().Health / math.max(A.Hum().MaxHealth, 1) * 100) or "0%"
    return {
        State = state,
        Target = target,
        Preset = preset,
        Health = health,
        Threat = CA.ThreatLevel,
        Active = CA.Active
    }
end

function CA.Engage()
    CA.AIState = "Engaging"
    CA.ProcessAITarget()
end

function CA.Disengage()
    CA.Target = nil
    CA.AIState = "Idle"
    CA.ComboEngine.ResetCombo()
end

function CA.GetCombatStats()
    return {
        TotalDamage = CA.TotalDamage,
        TotalKills = CA.TotalKills,
        Duration = tick() - (CA.ComboStartTime > 0 and CA.ComboStartTime or tick()),
        CurrentTarget = CA.Target and CA.Target.Name or "None",
        CurrentPreset = CA.CurrentPreset or "None",
        AIState = CA.AIState,
        ThreatLevel = CA.ThreatLevel,
        HistoryCount = #CA.CombatHistory
    }
end

function CA.ResetStats()
    CA.TotalDamage = 0
    CA.TotalKills = 0
    CA.CombatHistory = {}
    CA.AttackPatternBuffer = {}
    CA.OpponentAnalysis = {}
    CA.PredictionModel = {Velocity = V3(0,0,0), Acceleration = V3(0,0,0), LastPosition = nil, LastTime = 0, History = {}}
end

function CA.GetAIHistory()
    return CA.CombatHistory
end

function CA.AICombatLoop()
    while CA.Active do
        pcall(function()
            CA.UpdateCombatState()
        end)
        wait(0.08)
    end
end

function CA.StartAI(target)
    if CA.Active then return end
    CA.Active = true
    CA.AIState = "Initializing"
    CA.Target = target
    CA.ComboStartTime = tick()
    CA.ResetStats()
    A.Notify("Combat AI", "AI Combat System Activated", 2)
    spawn(function()
        CA.AICombatLoop()
    end)
end

function CA.StopAI()
    CA.Active = false
    CA.Target = nil
    CA.AIState = "Idle"
    CA.ComboEngine.ResetCombo()
    A.Notify("Combat AI", "AI Combat System Deactivated", 2)
end

function CA.MainLoop()
    while CA.Active do
        wait(0.1)
    end
end

function CA.Start()
    CA.StartAI(nil)
end

function CA.Stop()
    CA.StopAI()
end

function CA:SetPrediction(v)
    A.F.CombatAIPrediction = v
end

function CA:SetCounter(v)
    A.F.CombatAICounter = v
end

function CA:SetSmartDodge(v)
    A.F.CombatAISmartDodge = v
end

function CA:SetAdaptiveCombo(v)
    A.F.CombatAIAdaptiveCombo = v
end

function CA:SetAntiCombo(v)
    A.F.CombatAIAntiCombo = v
end

function CA:SelectTarget()
    return CA.AITargeting.SelectTarget()
end

function CA:AggressiveCombo(target)
    CA.ComboEngine.ExecuteCombo("Aggressive", target)
end

function CA:BurstCombo(target)
    CA.ComboEngine.ExecuteCombo("Burst", target)
end

function CA:ExecuteCombo(target)
    CA.ComboEngine.ExecuteCombo("Execute", target)
end

function CA:StunLockCombo(target)
    CA.ComboEngine.ExecuteCombo("StunLock", target)
end

function CA:SelectSmartTarget()
    return CA.AITargeting.SelectTarget("Smart")
end

function CA:SelectClosest()
    return CA.AITargeting.SelectTarget("Closest")
end

function CA:SelectWeakest()
    return CA.AITargeting.SelectTarget("Weakest")
end

function CA:SelectHighestBounty()
    return CA.AITargeting.SelectTarget("HighestBounty")
end

A.Register("combat_ai", CA)
return CA