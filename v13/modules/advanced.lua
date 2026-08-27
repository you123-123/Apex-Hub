local A = _G.Apex
if not A then return end

A.AdvanceFarm = {}
A.AdvanceFarm.Active = false
A.AdvanceFarm.CurrentMode = "Normal"
A.AdvanceFarm.CurrentPreset = nil
A.AdvanceFarm.ComboPresets = {}
A.AdvanceFarm.AdvancedStats = {
    TotalDamage = 0,
    TotalKills = 0,
    CombosExecuted = 0,
    AverageComboTime = 0,
    FastestCombo = math.huge,
    MostDamageCombo = {Name = "None", Damage = 0},
    SessionStart = tick(),
    TargetsHit = 0,
    MissedAttacks = 0,
    DPS = 0,
    LastDPSUpdate = 0
}

A.AdvanceFarm.ComboPresets = {
    Aggressive = {
        Name = "Aggressive",
        Description = "Maximum damage output with all skills",
        Skills = {"Z", "X", "C", "V", "F"},
        Delays = {0.1, 0.1, 0.1, 0.1, 0.1},
        HoldTimes = {0.5, 0.5, 0.5, 0.8, 0.3},
        UseM1 = true,
        M1Between = true,
        Priority = 10,
        Cooldown = 0,
        DamageMultiplier = 1.5,
        StunLock = true,
        AoE = false,
        Range = 15
    },
    Defensive = {
        Name = "Defensive",
        Description = "Block-first approach with counter attacks",
        Skills = {"Block", "Z", "X", "C", "V"},
        Delays = {0.3, 0.2, 0.2, 0.2, 0.2},
        HoldTimes = {0.5, 0.4, 0.4, 0.4, 0.6},
        UseM1 = true,
        M1Between = false,
        Priority = 6,
        Cooldown = 1,
        DamageMultiplier = 1.0,
        StunLock = false,
        AoE = false,
        Range = 12
    },
    Burst = {
        Name = "Burst",
        Description = "Quick burst damage then retreat",
        Skills = {"Z", "X"},
        Delays = {0.05, 0.05},
        HoldTimes = {0.2, 0.2},
        UseM1 = false,
        M1Between = false,
        Priority = 9,
        Cooldown = 2,
        DamageMultiplier = 1.3,
        StunLock = false,
        AoE = false,
        Range = 10
    },
    Stun = {
        Name = "Stun",
        Description = "Perma-stun combo with crowd control",
        Skills = {"Z", "V", "C", "X", "F"},
        Delays = {0.05, 0.15, 0.1, 0.1, 0.05},
        HoldTimes = {0.3, 0.6, 0.4, 0.4, 0.3},
        UseM1 = true,
        M1Between = true,
        Priority = 8,
        Cooldown = 0.5,
        DamageMultiplier = 1.1,
        StunLock = true,
        AoE = true,
        Range = 18
    },
    Heal = {
        Name = "Heal",
        Description = "Life steal focused combo",
        Skills = {"C", "Z", "X", "V"},
        Delays = {0.2, 0.2, 0.2, 0.2},
        HoldTimes = {0.5, 0.5, 0.5, 0.8},
        UseM1 = true,
        M1Between = true,
        Priority = 7,
        Cooldown = 1,
        DamageMultiplier = 0.9,
        StunLock = false,
        AoE = true,
        Range = 14
    },
    Counter = {
        Name = "Counter",
        Description = "Wait for enemy attack then counter",
        Skills = {"Block", "Z", "C", "V"},
        Delays = {0.5, 0.1, 0.1, 0.1},
        HoldTimes = {0.3, 0.4, 0.6, 0.8},
        UseM1 = false,
        M1Between = false,
        Priority = 8,
        Cooldown = 2,
        DamageMultiplier = 2.0,
        StunLock = true,
        AoE = false,
        Range = 12
    },
    PvP = {
        Name = "PvP",
        Description = "Optimized for player versus player combat",
        Skills = {"Z", "X", "C", "V", "F"},
        Delays = {0.08, 0.08, 0.12, 0.15, 0.05},
        HoldTimes = {0.3, 0.3, 0.5, 0.7, 0.2},
        UseM1 = true,
        M1Between = true,
        Priority = 10,
        Cooldown = 0,
        DamageMultiplier = 1.4,
        StunLock = true,
        AoE = false,
        Range = 16
    },
    PvE = {
        Name = "PvE",
        Description = "Optimized for NPC farming",
        Skills = {"V", "C", "X", "Z"},
        Delays = {0.1, 0.1, 0.1, 0.1},
        HoldTimes = {0.8, 0.5, 0.4, 0.3},
        UseM1 = true,
        M1Between = true,
        Priority = 9,
        Cooldown = 0,
        DamageMultiplier = 1.2,
        StunLock = false,
        AoE = true,
        Range = 25
    },
    Boss = {
        Name = "Boss",
        Description = "Safe combo for boss fights",
        Skills = {"Z", "X", "C", "V", "F"},
        Delays = {0.15, 0.15, 0.15, 0.2, 0.1},
        HoldTimes = {0.5, 0.5, 0.6, 0.9, 0.3},
        UseM1 = true,
        M1Between = true,
        Priority = 8,
        Cooldown = 0.5,
        DamageMultiplier = 1.3,
        StunLock = false,
        AoE = false,
        Range = 14
    },
    Raid = {
        Name = "Raid",
        Description = "Fast clear combo for raids",
        Skills = {"V", "Z", "X", "C"},
        Delays = {0.05, 0.1, 0.1, 0.1},
        HoldTimes = {0.7, 0.3, 0.3, 0.5},
        UseM1 = true,
        M1Between = true,
        Priority = 10,
        Cooldown = 0,
        DamageMultiplier = 1.4,
        StunLock = true,
        AoE = true,
        Range = 30
    },
    Fruit = {
        Name = "Fruit",
        Description = "Fruit ability focused combo",
        Skills = {"Z", "X", "C", "V", "F"},
        Delays = {0.1, 0.1, 0.1, 0.1, 0.1},
        HoldTimes = {0.4, 0.4, 0.4, 0.6, 0.3},
        UseM1 = false,
        M1Between = false,
        Priority = 8,
        Cooldown = 0.5,
        DamageMultiplier = 1.5,
        StunLock = false,
        AoE = true,
        Range = 20
    },
    Sword = {
        Name = "Sword",
        Description = "Sword combat optimized combo",
        Skills = {"Z", "X"},
        Delays = {0.05, 0.08},
        HoldTimes = {0.3, 0.3},
        UseM1 = true,
        M1Between = true,
        Priority = 9,
        Cooldown = 0,
        DamageMultiplier = 1.6,
        StunLock = true,
        AoE = false,
        Range = 10
    },
    Gun = {
        Name = "Gun",
        Description = "Gun and ranged combat combo",
        Skills = {"Z", "X"},
        Delays = {0.1, 0.1},
        HoldTimes = {0.2, 0.2},
        UseM1 = true,
        M1Between = true,
        Priority = 7,
        Cooldown = 0,
        DamageMultiplier = 1.2,
        StunLock = false,
        AoE = false,
        Range = 40
    },
    Melee = {
        Name = "Melee",
        Description = "Close quarters melee combat",
        Skills = {"Z", "X", "C", "V"},
        Delays = {0.05, 0.05, 0.08, 0.1},
        HoldTimes = {0.2, 0.2, 0.3, 0.4},
        UseM1 = true,
        M1Between = true,
        Priority = 9,
        Cooldown = 0,
        DamageMultiplier = 1.5,
        StunLock = true,
        AoE = false,
        Range = 8
    },
    AllRound = {
        Name = "AllRound",
        Description = "Balanced combo for all situations",
        Skills = {"Z", "X", "C", "V", "F"},
        Delays = {0.12, 0.12, 0.12, 0.15, 0.1},
        HoldTimes = {0.4, 0.4, 0.5, 0.7, 0.3},
        UseM1 = true,
        M1Between = true,
        Priority = 8,
        Cooldown = 0.3,
        DamageMultiplier = 1.2,
        StunLock = false,
        AoE = true,
        Range = 18
    }
}

local function GetDistance(pos1, pos2)
    if not pos1 or not pos2 then return math.huge end
    return (pos1 - pos2).Magnitude
end

local function IsAlive(player)
    if not player or not player.Character then return false end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local hum = player.Character:FindFirstChild("Humanoid")
    return hrp and hum and hum.Health > 0
end

local function GetCharacterParts(player)
    if not player or not player.Character then return nil end
    return {
        Root = player.Character:FindFirstChild("HumanoidRootPart"),
        Head = player.Character:FindFirstChild("Head"),
        Hum = player.Character:FindFirstChild("Humanoid"),
        HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    }
end

local function WaitForSkillReady(skillName)
    local startTime = tick()
    while tick() - startTime < 5 do
        local char = A.Char()
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                local Remote = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("RemoteFunction")
                if Remote then return true end
            end
        end
        task.wait(0.1)
    end
    return false
end

local function ExecuteSkill(skillName, holdTime)
    local startTime = tick()
    local char = A.Char()
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    local remote = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("RemoteFunction")
    if not remote then return end
    pcall(function()
        if tool:FindFirstChild("RemoteEvent") then
            tool.RemoteEvent:FireServer(skillName, "Hold")
        end
    end)
    task.wait(holdTime or 0.3)
    pcall(function()
        if tool:FindFirstChild("RemoteEvent") then
            tool.RemoteEvent:FireServer(skillName, "Release")
        end
    end)
end

local function PerformM1(target)
    if not target then return end
    local char = A.Char()
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    pcall(function()
        local remote = tool:FindFirstChild("RemoteEvent")
        if remote then
            remote:FireServer("M1", target)
        end
    end)
    task.wait(0.15)
end

local function UseBlock(duration)
    local char = A.Char()
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    pcall(function()
        local remote = tool:FindFirstChild("RemoteEvent")
        if remote then
            remote:FireServer("Block", "Start")
        end
    end)
    task.wait(duration or 0.5)
    pcall(function()
        local remote = tool:FindFirstChild("RemoteEvent")
        if remote then
            remote:FireServer("Block", "Stop")
        end
    end)
end

local function UseDash(direction)
    local char = A.Char()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    pcall(function()
        local remote = tool:FindFirstChild("RemoteEvent")
        if remote then
            remote:FireServer("Dash", direction)
        end
    end)
    task.wait(0.2)
end

local function PredictPosition(target, time)
    local parts = GetCharacterParts(target)
    if not parts or not parts.Root then return nil end
    local pos = parts.Root.Position
    local vel = parts.Root.Velocity
    local grav = Vector3.new(0, -196.2, 0)
    return pos + vel * time + 0.5 * grav * time * time
end

local function GetTargetHealthPercent(target)
    local parts = GetCharacterParts(target)
    if not parts or not parts.Hum then return 0 end
    return (parts.Hum.Health / parts.Hum.MaxHealth) * 100
end

local function IsTargetBlocking(target)
    if not target or not target.Character then return false end
    local char = target.Character
    local bodyEffects = char:FindFirstChild("BodyEffects") or char:FindFirstChild("Effects")
    if bodyEffects then
        local block = bodyEffects:FindFirstChild("Block") or bodyEffects:FindFirstChild("Blocking")
        if block and block.Value then return true end
    end
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        local anim = humanoid:FindFirstChildOfClass("Animator")
        if anim then
            for _, track in pairs(anim:GetPlayingAnimationTracks()) do
                if track.Name and string.lower(track.Name):find("block") then
                    return true
                end
            end
        end
    end
    return false
end

local function EstimateDamage(skills, multiplier)
    local baseDamage = 0
    local skillDamage = {
        Z = 50,
        X = 60,
        C = 80,
        V = 120,
        F = 40
    }
    for _, skill in ipairs(skills) do
        baseDamage = baseDamage + (skillDamage[skill] or 30)
    end
    return baseDamage * (multiplier or 1)
end

function A.AdvanceFarm.SelectCombo(mode, distance, target)
    if not A.AdvanceFarm.Active then return nil end
    local presetName = nil
    if mode == "PvP" or mode == "pvp" then
        if distance > 30 then
            presetName = "Gun"
        elseif distance > 15 then
            presetName = "PvP"
        else
            presetName = "Melee"
        end
    elseif mode == "PvE" or mode == "pve" then
        if target then
            local health = GetTargetHealthPercent(target)
            if health < 25 then
                presetName = "Burst"
            elseif health > 75 then
                presetName = "Aggressive"
            else
                presetName = "PvE"
            end
        else
            presetName = "PvE"
        end
    elseif mode == "Boss" or mode == "boss" then
        presetName = "Boss"
    elseif mode == "Raid" or mode == "raid" then
        presetName = "Raid"
    elseif mode == "Farm" or mode == "farm" then
        presetName = "PvE"
    elseif mode == "Defensive" or mode == "defensive" then
        presetName = "Defensive"
    else
        presetName = "AllRound"
    end
    if target and IsTargetBlocking(target) then
        presetName = "Counter"
    end
    A.AdvanceFarm.CurrentPreset = A.AdvanceFarm.ComboPresets[presetName]
    return A.AdvanceFarm.ComboPresets[presetName]
end

function A.AdvanceFarm.GetBestCombo(target)
    if not target then return A.AdvanceFarm.ComboPresets.AllRound end
    local hrp = A.HRP()
    local targetParts = GetCharacterParts(target)
    if not hrp or not targetParts or not targetParts.Root then
        return A.AdvanceFarm.ComboPresets.AllRound
    end
    local distance = GetDistance(hrp.Position, targetParts.Root.Position)
    local health = GetTargetHealthPercent(target)
    local isBlocking = IsTargetBlocking(target)
    if isBlocking then
        return A.AdvanceFarm.ComboPresets.Counter
    end
    if health < 20 then
        return A.AdvanceFarm.ComboPresets.Burst
    end
    if distance > 35 then
        return A.AdvanceFarm.ComboPresets.Gun
    elseif distance > 15 then
        return A.AdvanceFarm.ComboPresets.Fruit
    elseif distance > 8 then
        return A.AdvanceFarm.ComboPresets.Melee
    else
        return A.AdvanceFarm.ComboPresets.Aggressive
    end
end

function A.AdvanceFarm.ExecuteCombo(preset, target)
    if not A.AdvanceFarm.Active then return end
    if not preset then return end
    if not target then return end
    local startTime = tick()
    local stats = A.AdvanceFarm.AdvancedStats
    for i, skill in ipairs(preset.Skills) do
        if not A.AdvanceFarm.Active then break end
        if not IsAlive(target) then break end
        if skill == "Block" then
            UseBlock(preset.HoldTimes[i] or 0.3)
        elseif skill == "Dash" then
            UseDash("Forward")
        else
            if preset.UseM1 and preset.M1Between and skill ~= preset.Skills[1] then
                for m = 1, 2 do
                    if not A.AdvanceFarm.Active then break end
                    if not IsAlive(target) then break end
                    PerformM1(target)
                end
            end
            local targetPos = nil
            if target then
                local targetParts = GetCharacterParts(target)
                if targetParts and targetParts.Root then
                    targetPos = targetParts.Root.Position
                end
            end
            if targetPos then
                local myHRP = A.HRP()
                if myHRP then
                    local dist = GetDistance(myHRP.Position, targetPos)
                    if dist > preset.Range then
                        A.TweenTo(targetPos, 200)
                        task.wait(0.2)
                    end
                end
            end
            ExecuteSkill(skill, preset.HoldTimes[i] or 0.3)
            task.wait(preset.Delays[i] or 0.1)
            stats.TargetsHit = stats.TargetsHit + 1
        end
    end
    if preset.UseM1 then
        for m = 1, 4 do
            if not A.AdvanceFarm.Active then break end
            if not IsAlive(target) then break end
            PerformM1(target)
        end
    end
    local comboTime = tick() - startTime
    stats.CombosExecuted = stats.CombosExecuted + 1
    local comboDamage = EstimateDamage(preset.Skills, preset.DamageMultiplier)
    stats.TotalDamage = stats.TotalDamage + comboDamage
    if comboTime < stats.FastestCombo then
        stats.FastestCombo = comboTime
    end
    if comboDamage > stats.MostDamageCombo.Damage then
        stats.MostDamageCombo = {Name = preset.Name, Damage = comboDamage}
    end
    local elapsed = tick() - stats.SessionStart
    if elapsed > 0 then
        stats.DPS = stats.TotalDamage / elapsed
    end
    return comboTime, comboDamage
end

function A.AdvanceFarm.ChainCombo(target, skills)
    if not A.AdvanceFarm.Active then return end
    if not target or not skills then return end
    local customPreset = {
        Name = "Chain",
        Skills = skills,
        Delays = {},
        HoldTimes = {},
        UseM1 = false,
        M1Between = false,
        Priority = 10,
        Cooldown = 0,
        DamageMultiplier = 1.0,
        StunLock = false,
        AoE = false,
        Range = 20
    }
    for _ = 1, #skills do
        table.insert(customPreset.Delays, 0.1)
        table.insert(customPreset.HoldTimes, 0.35)
    end
    return A.AdvanceFarm.ExecuteCombo(customPreset, target)
end

function A.AdvanceFarm.MegaCombo(target, fullSkills)
    if not A.AdvanceFarm.Active then return end
    if not target then return end
    local allSkills = fullSkills or {"Z", "X", "C", "V", "F"}
    local allDelays = {}
    local allHoldTimes = {}
    for _ = 1, #allSkills do
        table.insert(allDelays, 0.08)
        table.insert(allHoldTimes, 0.25)
    end
    local megaPreset = {
        Name = "Mega",
        Skills = allSkills,
        Delays = allDelays,
        HoldTimes = allHoldTimes,
        UseM1 = true,
        M1Between = true,
        Priority = 10,
        Cooldown = 0,
        DamageMultiplier = 1.8,
        StunLock = true,
        AoE = false,
        Range = 15
    }
    return A.AdvanceFarm.ExecuteCombo(megaPreset, target)
end

function A.AdvanceFarm.SuperCombo(target)
    if not A.AdvanceFarm.Active then return end
    if not target then return end
    A.AdvanceFarm.ChainCombo(target, {"Z", "X", "C", "V", "F"})
    task.wait(0.1)
    A.AdvanceFarm.ChainCombo(target, {"V", "C", "X", "Z"})
    task.wait(0.1)
    for i = 1, 6 do
        if not A.AdvanceFarm.Active then break end
        if not IsAlive(target) then break end
        PerformM1(target)
    end
end

function A.AdvanceFarm.UltraCombo(target)
    if not A.AdvanceFarm.Active then return end
    if not target then return end
    A.AdvanceFarm.MegaCombo(target, {"Z", "X", "C", "V", "F"})
    task.wait(0.15)
    A.AdvanceFarm.MegaCombo(target, {"V", "C", "X", "Z", "F"})
    task.wait(0.15)
    A.AdvanceFarm.MegaCombo(target, {"C", "V", "Z", "X"})
    for i = 1, 8 do
        if not A.AdvanceFarm.Active then break end
        if not IsAlive(target) then break end
        PerformM1(target)
    end
end

function A.AdvanceFarm.OneShotCombo(target)
    if not A.AdvanceFarm.Active then return end
    if not target then return end
    local skills = {"Z", "X", "C", "V", "F", "Z", "X", "C", "V"}
    local preset = {
        Name = "OneShot",
        Skills = skills,
        Delays = {},
        HoldTimes = {},
        UseM1 = true,
        M1Between = true,
        Priority = 10,
        Cooldown = 0,
        DamageMultiplier = 2.0,
        StunLock = true,
        AoE = false,
        Range = 15
    }
    for _ = 1, #skills do
        table.insert(preset.Delays, 0.05)
        table.insert(preset.HoldTimes, 0.2)
    end
    A.AdvanceFarm.ExecuteCombo(preset, target)
end

function A.AdvanceFarm.ComboStep(combo, index)
    if not combo or not index then return end
    if index > #combo.Skills then return end
    local skill = combo.Skills[index]
    local delay = combo.Delays[index] or 0.1
    local holdTime = combo.HoldTimes[index] or 0.3
    if skill == "Block" then
        UseBlock(holdTime)
    elseif skill == "Dash" then
        UseDash("Forward")
    else
        ExecuteSkill(skill, holdTime)
    end
    task.wait(delay)
end

function A.AdvanceFarm.ResetCombo()
    A.AdvanceFarm.CurrentPreset = nil
end

function A.AdvanceFarm.GetComboDamage(combo)
    if not combo then return 0 end
    return EstimateDamage(combo.Skills, combo.DamageMultiplier)
end

function A.AdvanceFarm.EstimateComboTime(combo)
    if not combo then return 0 end
    local totalTime = 0
    for i = 1, #combo.Skills do
        totalTime = totalTime + (combo.Delays[i] or 0.1) + (combo.HoldTimes[i] or 0.3)
    end
    if combo.UseM1 then
        totalTime = totalTime + 0.6
    end
    return totalTime
end

function A.AdvanceFarm.SmartTargeting(mode)
    local bestTarget = nil
    local bestScore = -math.huge
    local range = mode == "Farm" and 500 or 200
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= A.LP and IsAlive(player) then
            local hrp = A.HRP()
            local parts = GetCharacterParts(player)
            if hrp and parts and parts.Root then
                local dist = GetDistance(hrp.Position, parts.Root.Position)
                if dist <= range then
                    local health = GetTargetHealthPercent(player)
                    local score = 0
                    if mode == "Farm" then
                        score = score + (500 - dist)
                        score = score + (100 - health)
                        local levelDiff = math.abs(A.Lv() - (player:FindFirstChild("Level") and player.Level.Value or 0))
                        score = score - levelDiff * 2
                    elseif mode == "PvP" then
                        score = score + (200 - dist)
                        score = score + (100 - health)
                        if A.InCombat() then
                            score = score + 50
                        end
                    elseif mode == "Boss" then
                        local bossData = A.BossData
                        if bossData then
                            for bossName, _ in pairs(bossData) do
                                if player.Name == bossName then
                                    score = score + 1000
                                end
                            end
                        end
                    end
                    if player:FindFirstChild("Leaderstats") then
                        local bounty = player.Leaderstats:FindFirstChild("Bounty") or player.Leaderstats:FindFirstChild("Honor")
                        if bounty then
                            score = score + bounty.Value / 10000
                        end
                    end
                    if score > bestScore then
                        bestScore = score
                        bestTarget = player
                    end
                end
            end
        end
    end
    return bestTarget
end

function A.AdvanceFarm.PredictTarget(target, time)
    if not target then return nil end
    return PredictPosition(target, time or 0.5)
end

function A.AdvanceFarm.LeadTarget(target, projectileSpeed)
    if not target then return nil end
    local parts = GetCharacterParts(target)
    if not parts or not parts.Root then return nil end
    local myHRP = A.HRP()
    if not myHRP then return nil end
    local myPos = myHRP.Position
    local targetPos = parts.Root.Position
    local targetVel = parts.Root.Velocity
    local dist = GetDistance(myPos, targetPos)
    local travelTime = dist / (projectileSpeed or 100)
    return targetPos + targetVel * travelTime
end

function A.AdvanceFarm.AutoAim(target)
    if not target then return end
    local parts = GetCharacterParts(target)
    if not parts or not parts.Head then return end
    local myChar = A.Char()
    if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local lookAt = CFrame.new(myHRP.Position, Vector3.new(parts.Head.Position.X, myHRP.Position.Y, parts.Head.Position.Z))
    myHRP.CFrame = lookAt
end

function A.AdvanceFarm.LockOn(target)
    A.AdvanceFarm.LockedTarget = target
    A.AdvanceFarm.Locked = true
end

function A.AdvanceFarm.UnlockTarget()
    A.AdvanceFarm.LockedTarget = nil
    A.AdvanceFarm.Locked = false
end

function A.AdvanceFarm.DodgeCounter(target)
    if not target then return end
    local attackIndicators = {"Z", "X", "C", "V"}
    local dodgeDirections = {
        Z = "Right",
        X = "Left",
        C = "Back",
        V = "Back"
    }
    for _, skill in ipairs(attackIndicators) do
        local parts = GetCharacterParts(target)
        if parts and parts.Hum then
            local anim = parts.Hum:FindFirstChildOfClass("Animator")
            if anim then
                for _, track in pairs(anim:GetPlayingAnimationTracks()) do
                    if track.Name and string.find(track.Name, skill) then
                        local dir = dodgeDirections[skill] or "Back"
                        UseDash(dir)
                        return true
                    end
                end
            end
        end
    end
    return false
end

function A.AdvanceFarm.ParryCounter(target)
    if not target then return end
    local startTime = tick()
    while tick() - startTime < 1 do
        if not IsAlive(target) then break end
        local isBlocking = IsTargetBlocking(target)
        if isBlocking then
            UseBlock(0.5)
            task.wait(0.3)
            A.AdvanceFarm.ExecuteCombo(A.AdvanceFarm.ComboPresets.Counter, target)
            return true
        end
        task.wait(0.05)
    end
    return false
end

function A.AdvanceFarm.BlockCounter(target)
    if not target then return end
    local startTime = tick()
    while tick() - startTime < 2 do
        if not IsAlive(target) then break end
        UseBlock(0.3)
        local parts = GetCharacterParts(target)
        if parts and parts.Hum then
            local anim = parts.Hum:FindFirstChildOfClass("Animator")
            if anim then
                local playing = false
                for _, track in pairs(anim:GetPlayingAnimationTracks()) do
                    if track and track.Speed and track.Speed > 0 then
                        playing = true
                    end
                end
                if not playing then
                    A.AdvanceFarm.ExecuteCombo(A.AdvanceFarm.ComboPresets.Aggressive, target)
                    return true
                end
            end
        end
        task.wait(0.05)
    end
    return false
end

function A.AdvanceFarm.FarmOptimized(target, mode)
    if not A.AdvanceFarm.Active then return end
    if not target then return end
    local myHRP = A.HRP()
    local parts = GetCharacterParts(target)
    if not myHRP or not parts or not parts.Root then return end
    local distance = GetDistance(myHRP.Position, parts.Root.Position)
    local optimalDist = 12
    if mode == "Ranged" then
        optimalDist = 35
    elseif mode == "Melee" then
        optimalDist = 8
    end
    if distance > optimalDist + 5 then
        A.TweenTo(parts.Root.Position, 200)
        task.wait(0.3)
    elseif distance < optimalDist - 3 then
        local awayDir = (myHRP.Position - parts.Root.Position).Unit
        local newPos = myHRP.Position + awayDir * 5
        A.TweenTo(newPos, 150)
        task.wait(0.2)
    end
    local combo = A.AdvanceFarm.GetBestCombo(target)
    A.AdvanceFarm.ExecuteCombo(combo, target)
end

function A.AdvanceFarm.SpeedFarm(target)
    if not A.AdvanceFarm.Active then return end
    if not target then return end
    local startTime = tick()
    while tick() - startTime < 30 do
        if not A.AdvanceFarm.Active then break end
        if not IsAlive(target) then break end
        local combo = A.AdvanceFarm.ComboPresets.Aggressive
        A.AdvanceFarm.ExecuteCombo(combo, target)
        task.wait(0.1)
    end
end

function A.AdvanceFarm.SafeFarm(target)
    if not A.AdvanceFarm.Active then return end
    if not target then return end
    local startTime = tick()
    while tick() - startTime < 60 do
        if not A.AdvanceFarm.Active then break end
        if not IsAlive(target) then break end
        local myHRP = A.HRP()
        local parts = GetCharacterParts(target)
        if myHRP and parts and parts.Root then
            local health = GetTargetHealthPercent(target)
            local myHealth = 100
            local myHum = A.Hum()
            if myHum then
                myHealth = (myHum.Health / myHum.MaxHealth) * 100
            end
            if myHealth < 30 then
                UseDash("Back")
                task.wait(0.5)
            elseif health < 20 then
                local combo = A.AdvanceFarm.ComboPresets.Burst
                A.AdvanceFarm.ExecuteCombo(combo, target)
            else
                local combo = A.AdvanceFarm.ComboPresets.Defensive
                A.AdvanceFarm.ExecuteCombo(combo, target)
            end
        end
        task.wait(0.2)
    end
end

function A.AdvanceFarm.AdvancedAttack(target)
    if not A.AdvanceFarm.Active then return end
    if not target then return end
    local combo = A.AdvanceFarm.GetBestCombo(target)
    A.AdvanceFarm.AutoAim(target)
    task.wait(0.05)
    A.AdvanceFarm.ExecuteCombo(combo, target)
end

function A.AdvanceFarm.PrecisionAttack(target)
    if not A.AdvanceFarm.Active then return end
    if not target then return end
    A.AdvanceFarm.AutoAim(target)
    task.wait(0.05)
    local skills = {"Z", "X", "C"}
    for _, skill in ipairs(skills) do
        if not A.AdvanceFarm.Active then break end
        if not IsAlive(target) then break end
        local parts = GetCharacterParts(target)
        if parts and parts.Head then
            local headPos = parts.Head.Position
            local myHRP = A.HRP()
            if myHRP then
                local lookDir = (headPos - myHRP.Position).Unit
                myHRP.CFrame = CFrame.new(myHRP.Position, myHRP.Position + Vector3.new(lookDir.X, 0, lookDir.Z))
            end
        end
        ExecuteSkill(skill, 0.3)
        task.wait(0.15)
    end
end

function A.AdvanceFarm.AoEAttack(position, range)
    if not A.AdvanceFarm.Active then return end
    if not position then return end
    local aoeSkills = {"V", "C"}
    for _, skill in ipairs(aoeSkills) do
        if not A.AdvanceFarm.Active then break end
        local myHRP = A.HRP()
        if myHRP then
            local dist = GetDistance(myHRP.Position, position)
            if dist > 20 then
                A.TweenTo(position, 200)
                task.wait(0.3)
            end
        end
        ExecuteSkill(skill, 0.5)
        task.wait(0.2)
    end
    local targets = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= A.LP and IsAlive(player) then
            local parts = GetCharacterParts(player)
            if parts and parts.Root then
                local dist = GetDistance(position, parts.Root.Position)
                if dist <= (range or 25) then
                    table.insert(targets, player)
                end
            end
        end
    end
    for _, t in ipairs(targets) do
        A.AdvanceFarm.AutoAim(t)
        for _, skill in ipairs({"Z", "X"}) do
            if not A.AdvanceFarm.Active then break end
            if not IsAlive(t) then break end
            ExecuteSkill(skill, 0.3)
            task.wait(0.1)
        end
    end
end

function A.AdvanceFarm.SkillPriority(target)
    if not target then return {"Z", "X", "C", "V", "F"} end
    local health = GetTargetHealthPercent(target)
    local dist = 0
    local myHRP = A.HRP()
    local parts = GetCharacterParts(target)
    if myHRP and parts and parts.Root then
        dist = GetDistance(myHRP.Position, parts.Root.Position)
    end
    local priorities = {}
    if health < 20 then
        priorities = {"V", "C", "Z", "X", "F"}
    elseif health < 50 then
        priorities = {"C", "V", "Z", "X", "F"}
    elseif dist > 30 then
        priorities = {"Z", "X", "C", "F", "V"}
    else
        priorities = {"Z", "X", "C", "V", "F"}
    end
    if IsTargetBlocking(target) then
        priorities = {"V", "C", "Z", "X", "F"}
    end
    return priorities
end

function A.AdvanceFarm.GetOptimalSkill(target, distance, health)
    if not target then return "Z" end
    local health = health or GetTargetHealthPercent(target)
    local dist = distance or 0
    local myHRP = A.HRP()
    local parts = GetCharacterParts(target)
    if myHRP and parts and parts.Root then
        dist = GetDistance(myHRP.Position, parts.Root.Position)
    end
    if health < 15 then
        return "V"
    elseif health < 30 then
        return "C"
    elseif dist > 30 then
        return "Z"
    elseif dist > 15 then
        return "X"
    else
        return "Z"
    end
end

function A.AdvanceFarm.ComboStats()
    return A.AdvanceFarm.AdvancedStats
end

function A.AdvanceFarm.GetStats()
    local stats = A.AdvanceFarm.AdvancedStats
    local uptime = tick() - stats.SessionStart
    return {
        TotalDamage = stats.TotalDamage,
        TotalKills = stats.TotalKills,
        CombosExecuted = stats.CombosExecuted,
        AverageComboTime = stats.CombosExecuted > 0 and (uptime / stats.CombosExecuted) or 0,
        FastestCombo = stats.FastestCombo == math.huge and 0 or stats.FastestCombo,
        MostDamageCombo = stats.MostDamageCombo,
        DPS = stats.DPS,
        TargetsHit = stats.TargetsHit,
        MissedAttacks = stats.MissedAttacks,
        Accuracy = stats.TargetsHit > 0 and ((stats.TargetsHit / (stats.TargetsHit + stats.MissedAttacks)) * 100) or 0,
        SessionUptime = uptime
    }
end

function A.AdvanceFarm.ResetStats()
    A.AdvanceFarm.AdvancedStats = {
        TotalDamage = 0,
        TotalKills = 0,
        CombosExecuted = 0,
        AverageComboTime = 0,
        FastestCombo = math.huge,
        MostDamageCombo = {Name = "None", Damage = 0},
        SessionStart = tick(),
        TargetsHit = 0,
        MissedAttacks = 0,
        DPS = 0,
        LastDPSUpdate = 0
    }
end

function A.AdvanceFarm.SaveComboPreset(name, combo)
    if not name or not combo then return false end
    A.AdvanceFarm.ComboPresets[name] = combo
    pcall(function()
        if not isfolder("ApexHub") then makefolder("ApexHub") end
        if not isfolder("ApexHub/Presets") then makefolder("ApexHub/Presets") end
        writefile("ApexHub/Presets/" .. name .. ".json", game:GetService("HttpService"):JSONEncode(combo))
    end)
    return true
end

function A.AdvanceFarm.LoadComboPreset(name)
    if not name then return nil end
    if A.AdvanceFarm.ComboPresets[name] then
        return A.AdvanceFarm.ComboPresets[name]
    end
    local success, data = pcall(function()
        return readfile("ApexHub/Presets/" .. name .. ".json")
    end)
    if success and data then
        local decoded = game:GetService("HttpService"):JSONDecode(data)
        A.AdvanceFarm.ComboPresets[name] = decoded
        return decoded
    end
    return nil
end

function A.AdvanceFarm.GetComboPresets()
    local names = {}
    for name, _ in pairs(A.AdvanceFarm.ComboPresets) do
        table.insert(names, name)
    end
    return names
end

function A.AdvanceFarm.AutoCombo(target)
    if not A.AdvanceFarm.Active then return end
    if not target then return end
    local combo = A.AdvanceFarm.GetBestCombo(target)
    A.AdvanceFarm.ExecuteCombo(combo, target)
end

function A.AdvanceFarm.MainLoop()
    while A.AdvanceFarm.Active do
        pcall(function()
            local target = A.FindTarget(200)
            if target then
                A.AdvanceFarm.AutoCombo(target)
            end
        end)
        task.wait(0.1)
    end
end

function A.AdvanceFarm.Start()
    if A.AdvanceFarm.Active then return end
    A.AdvanceFarm.Active = true
    A.AdvanceFarm.ResetStats()
    A.Notify("Advanced Farm", "Advanced farming started!", 3)
    task.spawn(function()
        A.AdvanceFarm.MainLoop()
    end)
end

function A.AdvanceFarm.Stop()
    A.AdvanceFarm.Active = false
    A.AdvanceFarm.ResetCombo()
    A.Notify("Advanced Farm", "Advanced farming stopped!", 3)
end

A.Register("advanced", A.AdvanceFarm)
