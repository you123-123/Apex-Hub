local A = _G.Apex
if not A then return end

A.AdvCombat = {}
A.AdvCombat.Active = false
A.AdvCombat.Mode = "Balanced"
A.AdvCombat.CombatStats = {
    TotalDamageDealt = 0,
    TotalDamageTaken = 0,
    TotalKills = 0,
    TotalDeaths = 0,
    TotalBlocks = 0,
    TotalDodges = 0,
    TotalParries = 0,
    TotalComboHits = 0,
    Accuracy = 100,
    KDRatio = 0,
    BestStreak = 0,
    CurrentStreak = 0,
    SessionStart = tick()
}

A.AdvCombat.PlayerKills = {}
A.AdvCombat.StunCounters = {
    MaxStunDuration = 3,
    CurrentStun = 0,
    StunResistance = 0,
    AntiStunActive = false,
    LastStunTime = 0
}

A.AdvCombat.HighlightData = {}
A.AdvCombat.CombatLog = {}

A.AdvCombat.RangePresets = {
    Melee = {Min = 0, Max = 10, Optimal = 5},
    Sword = {Min = 0, Max = 15, Optimal = 8},
    Gun = {Min = 10, Max = 60, Optimal = 35},
    Fruit = {Min = 5, Max = 40, Optimal = 20},
    Melee_Range = {Min = 0, Max = 12, Optimal = 6}
}

A.AdvCombat.ComboCounters = {
    ["Stun"] = {"Block", "Dash"},
    ["Knockback"] = {"Dash", "Block"},
    ["Pull"] = {"Dash"},
    ["AreaOfEffect"] = {"Dash"},
    ["Projectile"] = {"Block", "Dodge"},
    ["Grab"] = {"Block"},
    ["Slow"] = {"Dash"},
    ["Bleed"] = {"Heal"},
    ["Burn"] = {"Heal"},
    ["Freeze"] = {"Dash"}
}

A.AdvCombat.Strategies = {
    Aggressive = {
        Name = "Aggressive",
        Description = "Maximum offense, minimal defense",
        DodgeChance = 0.2,
        BlockChance = 0.1,
        ComboFrequency = 0.8,
        RangePreference = "Melee",
        PriorityTargets = "LowestHealth",
        RetreatThreshold = 10,
        PushThreshold = 80
    },
    Defensive = {
        Name = "Defensive",
        Description = "Prioritize survival and counter attacks",
        DodgeChance = 0.6,
        BlockChance = 0.7,
        ComboFrequency = 0.4,
        RangePreference = "Sword",
        PriorityTargets = "Closest",
        RetreatThreshold = 50,
        PushThreshold = 90
    },
    Balanced = {
        Name = "Balanced",
        Description = "Balanced offense and defense",
        DodgeChance = 0.4,
        BlockChance = 0.4,
        ComboFrequency = 0.6,
        RangePreference = "Fruit",
        PriorityTargets = "HighestThreat",
        RetreatThreshold = 30,
        PushThreshold = 70
    },
    Assassin = {
        Name = "Assassin",
        Description = "Quick kills with stealth approach",
        DodgeChance = 0.3,
        BlockChance = 0.2,
        ComboFrequency = 0.9,
        RangePreference = "Melee",
        PriorityTargets = "LowestHealth",
        RetreatThreshold = 20,
        PushThreshold = 85
    },
    Tank = {
        Name = "Tank",
        Description = "High defense, sustained combat",
        DodgeChance = 0.1,
        BlockChance = 0.9,
        ComboFrequency = 0.3,
        RangePreference = "Melee",
        PriorityTargets = "Closest",
        RetreatThreshold = 70,
        PushThreshold = 95
    }
}

A.AdvCombat.DodgeDirections = {
    Forward = Vector3.new(0, 0, -1),
    Back = Vector3.new(0, 0, 1),
    Left = Vector3.new(-1, 0, 0),
    Right = Vector3.new(1, 0, 0),
    ForwardLeft = Vector3.new(-0.707, 0, -0.707),
    ForwardRight = Vector3.new(0.707, 0, -0.707),
    BackLeft = Vector3.new(-0.707, 0, 0.707),
    BackRight = Vector3.new(0.707, 0, 0.707)
}

local function GetCharacterParts(player)
    if not player or not player.Character then return nil end
    return {
        Root = player.Character:FindFirstChild("HumanoidRootPart"),
        Head = player.Character:FindFirstChild("Head"),
        Hum = player.Character:FindFirstChild("Humanoid"),
        Torso = player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("Torso")
    }
end

local function IsAlive(player)
    if not player or not player.Character then return false end
    local parts = GetCharacterParts(player)
    return parts and parts.Root and parts.Hum and parts.Hum.Health > 0
end

local function GetDistance(pos1, pos2)
    if not pos1 or not pos2 then return math.huge end
    return (pos1 - pos2).Magnitude
end

local function GetHealthPercent(player)
    local parts = GetCharacterParts(player)
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
    return false
end

local function IsTargetAttacking(target)
    if not target or not target.Character then return false end
    local char = target.Character
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        local anim = humanoid:FindFirstChildOfClass("Animator")
        if anim then
            for _, track in pairs(anim:GetPlayingAnimationTracks()) do
                if track.Name and (string.find(track.Name, "Attack") or string.find(track.Name, "Combo") or string.find(track.Name, "Skill")) then
                    return true
                end
            end
        end
    end
    return false
end

local function PredictTargetPosition(target, time)
    local parts = GetCharacterParts(target)
    if not parts or not parts.Root then return nil end
    local pos = parts.Root.Position
    local vel = parts.Root.Velocity
    local grav = Vector3.new(0, -196.2, 0)
    return pos + vel * time + 0.5 * grav * time * time
end

local function GetThreatLevel(player, myPlayer)
    if not player or not myPlayer then return 0 end
    local threat = 0
    local myParts = GetCharacterParts(myPlayer)
    local targetParts = GetCharacterParts(player)
    if not myParts or not targetParts then return 0 end
    local dist = GetDistance(myParts.Root.Position, targetParts.Root.Position)
    local health = GetHealthPercent(player)
    local myHealth = GetHealthPercent(myPlayer)
    threat = threat + (100 - health)
    threat = threat + (100 - myHealth) * 0.5
    if dist < 15 then
        threat = threat + 30
    elseif dist < 30 then
        threat = threat + 15
    end
    local bounty = player:FindFirstChild("Leaderstats") and player.Leaderstats:FindFirstChild("Bounty")
    if bounty then
        threat = threat + bounty.Value / 100000
    end
    local level = player:FindFirstChild("Level") and player.Level.Value or 0
    local myLevel = myPlayer:FindFirstChild("Level") and myPlayer.Level.Value or 0
    if level > myLevel then
        threat = threat + (level - myLevel) * 0.5
    end
    if IsTargetAttacking(player) then
        threat = threat + 40
    end
    return threat
end

function A.AdvCombat.NoStun()
    A.AdvCombat.StunCounters.CurrentStun = 0
    A.AdvCombat.StunCounters.AntiStunActive = true
    pcall(function()
        local char = A.Char()
        if char then
            local stunValue = char:FindFirstChild("Stun")
            if stunValue then
                if stunValue:IsA("NumberValue") then
                    stunValue.Value = 0
                elseif stunValue:IsA("IntValue") then
                    stunValue.Value = 0
                end
            end
            local bodyEffects = char:FindFirstChild("BodyEffects")
            if bodyEffects then
                for _, effect in pairs(bodyEffects:GetChildren()) do
                    if effect.Name == "Stun" or effect.Name == "Stunned" then
                        effect:Destroy()
                    end
                end
            end
        end
    end)
end

function A.AdvCombat.AntiStun()
    A.AdvCombat.NoStun()
    A.AdvCombat.StunCounters.StunResistance = 100
    task.spawn(function()
        while A.AdvCombat.Active and A.AdvCombat.StunCounters.AntiStunActive do
            A.AdvCombat.NoStun()
            task.wait(0.1)
        end
    end)
end

function A.AdvCombat.ClearStun()
    A.AdvCombat.StunCounters.CurrentStun = 0
    A.AdvCombat.StunCounters.AntiStunActive = false
end

function A.AdvCombat.PlayerHighlight(target)
    if not target or not target.Character then return end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local existing = hrp:FindFirstChild("ApexHighlight")
    if existing then existing:Destroy() end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ApexHighlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = target.Character
    highlight.Parent = hrp
    table.insert(A.AdvCombat.HighlightData, {Player = target, Highlight = highlight})
end

function A.AdvCombat.AddHighlight(player)
    A.AdvCombat.PlayerHighlight(player)
end

function A.AdvCombat.RemoveHighlight(player)
    for i, data in ipairs(A.AdvCombat.HighlightData) do
        if data.Player == player then
            if data.Highlight and data.Highlight.Parent then
                data.Highlight:Destroy()
            end
            table.remove(A.AdvCombat.HighlightData, i)
            break
        end
    end
end

function A.AdvCombat.ClearHighlights()
    for _, data in ipairs(A.AdvCombat.HighlightData) do
        if data.Highlight and data.Highlight.Parent then
            data.Highlight:Destroy()
        end
    end
    A.AdvCombat.HighlightData = {}
end

function A.AdvCombat.EnhancedDodge(target)
    if not target then return false end
    local myHRP = A.HRP()
    if not myHRP then return false end
    local targetParts = GetCharacterParts(target)
    if not targetParts or not targetParts.Root then return false end
    local dist = GetDistance(myHRP.Position, targetParts.Root.Position)
    local toTarget = (targetParts.Root.Position - myHRP.Position).Unit
    local bestDir = "Back"
    local bestScore = -math.huge
    for dirName, dirVec in pairs(A.AdvCombat.DodgeDirections) do
        local worldDir = myHRP.CFrame:VectorToWorldSpace(dirVec)
        local score = 0
        local awayFromTarget = worldDir:Dot(-toTarget)
        score = score + awayFromTarget * 50
        local safety = 0
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= A.LP and player ~= target and IsAlive(player) then
                local otherParts = GetCharacterParts(player)
                if otherParts and otherParts.Root then
                    local futurePos = myHRP.Position + worldDir * 10
                    local dangerDist = GetDistance(futurePos, otherParts.Root.Position)
                    if dangerDist < 15 then
                        safety = safety - (15 - dangerDist) * 5
                    end
                end
            end
        end
        score = score + safety
        if score > bestScore then
            bestScore = score
            bestDir = dirName
        end
    end
    local dodgeVec = A.AdvCombat.DodgeDirections[bestDir]
    if dodgeVec then
        local worldDir = myHRP.CFrame:VectorToWorldSpace(dodgeVec)
        local newPos = myHRP.Position + worldDir * 20
        A.TweenTo(newPos, 200)
        A.AdvCombat.CombatStats.TotalDodges = A.AdvCombat.CombatStats.TotalDodges + 1
        task.wait(0.2)
        return true
    end
    return false
end

function A.AdvCombat.AutoDodge(target)
    if not target then return false end
    local strategy = A.AdvCombat.Strategies[A.AdvCombat.Mode]
    if not strategy then return false end
    if math.random() > strategy.DodgeChance then return false end
    return A.AdvCombat.EnhancedDodge(target)
end

function A.AdvCombat.PredictDodge(target)
    if not target then return false end
    local targetParts = GetCharacterParts(target)
    if not targetParts or not targetParts.Root then return false end
    local myHRP = A.HRP()
    if not myHRP then return false end
    local dist = GetDistance(myHRP.Position, targetParts.Root.Position)
    local attackTypes = {"Z", "X", "C", "V"}
    for _, skill in ipairs(attackTypes) do
        if IsTargetAttacking(target) then
            local predictedPos = PredictTargetPosition(target, 0.3)
            if predictedPos then
                local attackDir = (predictedPos - myHRP.Position).Unit
                local dodgeDir = attackDir:Cross(Vector3.new(0, 1, 0)).Unit
                if math.random() > 0.5 then
                    dodgeDir = -dodgeDir
                end
                local newPos = myHRP.Position + dodgeDir * 15
                A.TweenTo(newPos, 250)
                A.AdvCombat.CombatStats.TotalDodges = A.AdvCombat.CombatStats.TotalDodges + 1
                task.wait(0.15)
                return true
            end
        end
    end
    return false
end

function A.AdvCombat.DodgeDirection(target, attack)
    if not target or not attack then return "Back" end
    local myHRP = A.HRP()
    local targetParts = GetCharacterParts(target)
    if not myHRP or not targetParts or not targetParts.Root then return "Back" end
    local toTarget = (targetParts.Root.Position - myHRP.Position).Unit
    if attack == "Projectile" then
        local side = toTarget:Cross(Vector3.new(0, 1, 0)).Unit
        if math.random() > 0.5 then side = -side end
        return side
    elseif attack == "AreaOfEffect" then
        return -toTarget
    elseif attack == "Grab" then
        return "Back"
    end
    return "Back"
end

function A.AdvCombat.GetDodgeVector(target)
    if not target then return Vector3.new(0, 0, 1) end
    local myHRP = A.HRP()
    local targetParts = GetCharacterParts(target)
    if not myHRP or not targetParts or not targetParts.Root then return Vector3.new(0, 0, 1) end
    local toTarget = (targetParts.Root.Position - myHRP.Position).Unit
    return -toTarget
end

function A.AdvCombat.SmartBlock(target)
    if not target then return false end
    local strategy = A.AdvCombat.Strategies[A.AdvCombat.Mode]
    if not strategy then return false end
    if math.random() > strategy.BlockChance then return false end
    local char = A.Char()
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return false end
    pcall(function()
        local remote = tool:FindFirstChild("RemoteEvent")
        if remote then
            remote:FireServer("Block", "Start")
        end
    end)
    A.AdvCombat.CombatStats.TotalBlocks = A.AdvCombat.CombatStats.TotalBlocks + 1
    local blockTime = 0
    local maxBlockTime = 2
    while blockTime < maxBlockTime do
        if not A.AdvCombat.Active then break end
        if not IsTargetAttacking(target) then break end
        task.wait(0.1)
        blockTime = blockTime + 0.1
    end
    pcall(function()
        local remote = tool:FindFirstChild("RemoteEvent")
        if remote then
            remote:FireServer("Block", "Stop")
        end
    end)
    return true
end

function A.AdvCombat.AutoBlock(target)
    if not target then return false end
    if IsTargetAttacking(target) then
        return A.AdvCombat.SmartBlock(target)
    end
    return false
end

function A.AdvCombat.BlockTimer(duration)
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
    task.wait(duration or 1)
    pcall(function()
        local remote = tool:FindFirstChild("RemoteEvent")
        if remote then
            remote:FireServer("Block", "Stop")
        end
    end)
end

function A.AdvCombat.AutoSoru(target)
    if not target then return false end
    local myHRP = A.HRP()
    local targetParts = GetCharacterParts(target)
    if not myHRP or not targetParts or not targetParts.Root then return false end
    local dist = GetDistance(myHRP.Position, targetParts.Root.Position)
    if dist > 50 then
        local char = A.Char()
        if not char then return false end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then return false end
        pcall(function()
            local remote = tool:FindFirstChild("RemoteEvent")
            if remote then
                remote:FireServer("Soru", targetParts.Root.Position)
            end
        end)
        task.wait(0.5)
        return true
    end
    return false
end

function A.AdvCombat.AutoGeppo(target)
    if not target then return false end
    local myHRP = A.HRP()
    if not myHRP then return false end
    local char = A.Char()
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return false end
    local targetParts = GetCharacterParts(target)
    if not targetParts or not targetParts.Root then return false end
    local dir = (targetParts.Root.Position - myHRP.Position).Unit
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
    task.wait(0.1)
    myHRP.Velocity = dir * 50 + Vector3.new(0, 50, 0)
    task.wait(0.3)
    return true
end

function A.AdvCombat.AutoDash(target)
    if not target then return false end
    local myHRP = A.HRP()
    local targetParts = GetCharacterParts(target)
    if not myHRP or not targetParts or not targetParts.Root then return false end
    local dir = (targetParts.Root.Position - myHRP.Position).Unit
    local char = A.Char()
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return false end
    pcall(function()
        local remote = tool:FindFirstChild("RemoteEvent")
        if remote then
            remote:FireServer("Dash", dir)
        end
    end)
    task.wait(0.2)
    return true
end

function A.AdvCombat.FarmAll(target)
    if not A.AdvCombat.Active then return end
    if not target then return end
    local strategy = A.AdvCombat.Strategies[A.AdvCombat.Mode]
    if not strategy then return end
    local myHRP = A.HRP()
    local targetParts = GetCharacterParts(target)
    if not myHRP or not targetParts or not targetParts.Root then return end
    local dist = GetDistance(myHRP.Position, targetParts.Root.Position)
    local health = GetHealthPercent(target)
    local myHealth = GetHealthPercent(A.LP)
    if myHealth < strategy.RetreatThreshold then
        A.AdvCombat.EnhancedDodge(target)
        task.wait(0.3)
        return
    end
    if IsTargetAttacking(target) and math.random() < strategy.BlockChance then
        A.AdvCombat.SmartBlock(target)
        task.wait(0.2)
        A.SuperAttack(target)
    elseif dist > A.AdvCombat.RangePresets[strategy.RangePreference].Max then
        A.TweenTo(targetParts.Root.Position, 200)
        task.wait(0.3)
    elseif dist < A.AdvCombat.RangePresets[strategy.RangePreference].Min then
        local awayDir = (myHRP.Position - targetParts.Root.Position).Unit
        A.TweenTo(myHRP.Position + awayDir * 5, 150)
        task.wait(0.2)
    else
        if math.random() < strategy.ComboFrequency then
            A.SuperAttack(target)
            A.AdvCombat.CombatStats.TotalComboHits = A.AdvCombat.CombatStats.TotalComboHits + 1
        else
            A.Attack(target, {"Z", "X", "C"}, 0.1)
        end
    end
end

function A.AdvCombat.FarmPVP()
    if not A.AdvCombat.Active then return end
    local target = A.FindTarget(200)
    if target and target:IsA("Player") then
        A.AdvCombat.FarmAll(target)
    end
end

function A.AdvCombat.FarmPVE()
    if not A.AdvCombat.Active then return end
    local target = A.FindTarget(200)
    if target then
        A.AdvCombat.FarmAll(target)
    end
end

function A.AdvCombat.FarmMixed()
    if not A.AdvCombat.Active then return end
    local target = A.FindTarget(200)
    if target then
        A.AdvCombat.FarmAll(target)
    end
end

function A.AdvCombat.SmartPathfind(target)
    if not target then return false end
    local myHRP = A.HRP()
    local targetParts = GetCharacterParts(target)
    if not myHRP or not targetParts or not targetParts.Root then return false end
    local path = game:GetService("PathfindingService"):CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentCanClimb = false
    })
    local success, err = pcall(function()
        path:ComputeAsync(myHRP.Position, targetParts.Root.Position)
    end)
    if success and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _, waypoint in ipairs(waypoints) do
            if not A.AdvCombat.Active then break end
            if not IsAlive(target) then break end
            myHRP.CFrame = CFrame.new(waypoint.Position)
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                local hum = A.Hum()
                if hum then
                    hum.Jump = true
                end
            end
            task.wait(0.1)
        end
        return true
    else
        A.TweenTo(targetParts.Root.Position, 200)
        return true
    end
    return false
end

function A.AdvCombat.FindPathTo(target)
    return A.AdvCombat.SmartPathfind(target)
end

function A.AdvCombat.AntiGlide()
    task.spawn(function()
        while A.AdvCombat.Active do
            pcall(function()
                local char = A.Char()
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local vel = hrp.Velocity
                        if vel.Y < -10 and not char:FindFirstChild("Flying") then
                            hrp.Velocity = Vector3.new(vel.X, 0, vel.Z)
                        end
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

function A.AdvCombat.AntiCombo()
    task.spawn(function()
        while A.AdvCombat.Active do
            pcall(function()
                local char = A.Char()
                if char then
                    local stun = char:FindFirstChild("Stun")
                    if stun and (stun:IsA("NumberValue") or stun:IsA("IntValue")) and stun.Value > 0 then
                        A.AdvCombat.NoStun()
                        A.AdvCombat.EnhancedDodge(nil)
                    end
                    local bodyEffects = char:FindFirstChild("BodyEffects")
                    if bodyEffects then
                        for _, effect in pairs(bodyEffects:GetChildren()) do
                            if effect.Name == "Stun" or effect.Name == "Stunned" or effect.Name == "Combo" then
                                A.AdvCombat.NoStun()
                            end
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end

function A.AdvCombat.AntiStunlock()
    A.AdvCombat.AntiCombo()
    A.AdvCombat.AntiGlide()
end

function A.AdvCombat.AimAssist(target)
    if not target then return end
    local myChar = A.Char()
    if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local targetParts = GetCharacterParts(target)
    if not targetParts then return end
    local aimPart = targetParts.Head or targetParts.Root
    if not aimPart then return end
    local predictedPos = PredictTargetPosition(target, 0.1)
    if predictedPos then
        local lookAt = CFrame.new(myHRP.Position, Vector3.new(predictedPos.X, myHRP.Position.Y, predictedPos.Z))
        myHRP.CFrame = lookAt
    else
        local lookAt = CFrame.new(myHRP.Position, Vector3.new(aimPart.Position.X, myHRP.Position.Y, aimPart.Position.Z))
        myHRP.CFrame = lookAt
    end
end

function A.AdvCombat.AutoAim(target)
    A.AdvCombat.AimAssist(target)
end

function A.AdvCombat.SmoothAim(target)
    if not target then return end
    local myChar = A.Char()
    if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local targetParts = GetCharacterParts(target)
    if not targetParts or not targetParts.Root then return end
    local currentCF = myHRP.CFrame
    local targetPos = targetParts.Root.Position
    local targetCF = CFrame.new(currentCF.Position, Vector3.new(targetPos.X, currentCF.Position.Y, targetPos.Z))
    myHRP.CFrame = currentCF:Lerp(targetCF, 0.3)
end

function A.AdvCombat.CombatPrediction(target)
    if not target then return nil end
    local targetParts = GetCharacterParts(target)
    if not targetParts or not targetParts.Root then return nil end
    local pos = targetParts.Root.Position
    local vel = targetParts.Root.Velocity
    local health = GetHealthPercent(target)
    local myHRP = A.HRP()
    if not myHRP then return nil end
    local dist = GetDistance(myHRP.Position, pos)
    local timeToReach = dist / 100
    local predictedPos = PredictTargetPosition(target, timeToReach)
    return {
        Position = predictedPos or pos,
        TimeToReach = timeToReach,
        Health = health,
        Velocity = vel,
        Distance = dist,
        ThreatLevel = GetThreatLevel(target, A.LP)
    }
end

function A.AdvCombat.EstimateDamage(target)
    if not target then return 0 end
    local health = GetHealthPercent(target)
    local baseDamage = 100
    local comboDamage = baseDamage * 5
    local hitsNeeded = math.ceil((health / 100 * (target.Character.Humanoid.MaxHealth or 1000)) / comboDamage)
    return hitsNeeded
end

function A.AdvCombat.CalcTimeToKill(target)
    if not target then return math.huge end
    local health = GetHealthPercent(target)
    local maxHealth = 1000
    local targetParts = GetCharacterParts(target)
    if targetParts and targetParts.Hum then
        maxHealth = targetParts.Hum.MaxHealth
    end
    local currentHealth = (health / 100) * maxHealth
    local dps = 500
    return currentHealth / dps
end

function A.AdvCombat.GetCombatRange(type)
    return A.AdvCombat.RangePresets[type] or A.AdvCombat.RangePresets.Melee
end

function A.AdvCombat.OptimalRange(target, weapon)
    if not target then return 10 end
    local weaponType = weapon or "Melee"
    local range = A.AdvCombat.RangePresets[weaponType]
    if range then
        return range.Optimal
    end
    return 10
end

function A.AdvCombat.EngageTarget(target)
    if not target then return end
    A.AdvCombat.PlayerHighlight(target)
    local strategy = A.AdvCombat.Strategies[A.AdvCombat.Mode]
    local optimalDist = A.AdvCombat.OptimalRange(target, strategy.RangePreference)
    local myHRP = A.HRP()
    local targetParts = GetCharacterParts(target)
    if myHRP and targetParts and targetParts.Root then
        local dist = GetDistance(myHRP.Position, targetParts.Root.Position)
        if dist > optimalDist + 5 then
            A.TweenTo(targetParts.Root.Position, 200)
        end
    end
    A.AdvCombat.FarmAll(target)
end

function A.AdvCombat.DisengageTarget()
    A.AdvCombat.ClearHighlights()
    local myHRP = A.HRP()
    if myHRP then
        local retreatPos = myHRP.Position + Vector3.new(math.random(-50, 50), 0, math.random(-50, 50))
        A.TweenTo(retreatPos, 150)
    end
end

function A.AdvCombat.DefensiveMode()
    A.AdvCombat.Mode = "Defensive"
    A.Notify("Combat", "Switched to Defensive mode", 3)
end

function A.AdvCombat.AggressiveMode()
    A.AdvCombat.Mode = "Aggressive"
    A.Notify("Combat", "Switched to Aggressive mode", 3)
end

function A.AdvCombat.BalancedMode()
    A.AdvCombat.Mode = "Balanced"
    A.Notify("Combat", "Switched to Balanced mode", 3)
end

function A.AdvCombat.TargetSelection(mode)
    local bestTarget = nil
    local bestScore = -math.huge
    local range = 300
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= A.LP and IsAlive(player) then
            local score = GetThreatLevel(player, A.LP)
            if mode == "Closest" then
                local myHRP = A.HRP()
                local targetParts = GetCharacterParts(player)
                if myHRP and targetParts and targetParts.Root then
                    score = 1000 - GetDistance(myHRP.Position, targetParts.Root.Position)
                end
            elseif mode == "LowestHealth" then
                score = 100 - GetHealthPercent(player)
            elseif mode == "HighestThreat" then
                score = GetThreatLevel(player, A.LP)
            elseif mode == "HighestBounty" then
                local bounty = player:FindFirstChild("Leaderstats") and player.Leaderstats:FindFirstChild("Bounty")
                if bounty then
                    score = bounty.Value
                end
            end
            if score > bestScore then
                bestScore = score
                bestTarget = player
            end
        end
    end
    return bestTarget
end

function A.AdvCombat.PriorityTarget()
    local strategy = A.AdvCombat.Strategies[A.AdvCombat.Mode]
    if strategy then
        return A.AdvCombat.TargetSelection(strategy.PriorityTargets)
    end
    return A.AdvCombat.TargetSelection("HighestThreat")
end

function A.AdvCombat.ThreatAssessment(player)
    return GetThreatLevel(player, A.LP)
end

function A.AdvCombat.PvPStrategy(player)
    if not player then return end
    local threat = A.AdvCombat.ThreatAssessment(player)
    if threat > 80 then
        A.AdvCombat.Mode = "Defensive"
    elseif threat > 50 then
        A.AdvCombat.Mode = "Balanced"
    else
        A.AdvCombat.Mode = "Aggressive"
    end
end

function A.AdvCombat.CounterStrategy(player)
    if not player then return end
    local targetParts = GetCharacterParts(player)
    if not targetParts then return end
    local myHRP = A.HRP()
    if not myHRP then return end
    local dist = GetDistance(myHRP.Position, targetParts.Root.Position)
    if dist > 30 then
        A.AdvCombat.Mode = "Aggressive"
    elseif dist > 15 then
        A.AdvCombat.Mode = "Balanced"
    else
        A.AdvCombat.Mode = "Defensive"
    end
end

function A.AdvCombat.AdaptStrategy(player)
    if not player then return end
    local recentDamage = A.AdvCombat.CombatStats.TotalDamageTaken
    local recentKills = A.AdvCombat.CombatStats.TotalKills
    if recentDamage > 500 and recentKills < 2 then
        A.AdvCombat.Mode = "Defensive"
    elseif recentKills > 5 then
        A.AdvCombat.Mode = "Aggressive"
    else
        A.AdvCombat.Mode = "Balanced"
    end
end

function A.AdvCombat.GetCombatStats()
    local stats = A.AdvCombat.CombatStats
    local uptime = tick() - stats.SessionStart
    return {
        TotalDamageDealt = stats.TotalDamageDealt,
        TotalDamageTaken = stats.TotalDamageTaken,
        TotalKills = stats.TotalKills,
        TotalDeaths = stats.TotalDeaths,
        TotalBlocks = stats.TotalBlocks,
        TotalDodges = stats.TotalDodges,
        TotalParries = stats.TotalParries,
        TotalComboHits = stats.TotalComboHits,
        KDRatio = stats.TotalDeaths > 0 and (stats.TotalKills / stats.TotalDeaths) or stats.TotalKills,
        BestStreak = stats.BestStreak,
        CurrentStreak = stats.CurrentStreak,
        SessionUptime = uptime,
        DamagePerSecond = uptime > 0 and (stats.TotalDamageDealt / uptime) or 0,
        KillsPerMinute = uptime > 0 and (stats.TotalKills / (uptime / 60)) or 0,
        Mode = A.AdvCombat.Mode
    }
end

function A.AdvCombat.ResetCombatStats()
    A.AdvCombat.CombatStats = {
        TotalDamageDealt = 0,
        TotalDamageTaken = 0,
        TotalKills = 0,
        TotalDeaths = 0,
        TotalBlocks = 0,
        TotalDodges = 0,
        TotalParries = 0,
        TotalComboHits = 0,
        Accuracy = 100,
        KDRatio = 0,
        BestStreak = 0,
        CurrentStreak = 0,
        SessionStart = tick()
    }
end

function A.AdvCombat.MainLoop()
    while A.AdvCombat.Active do
        pcall(function()
            A.AdvCombat.NoStun()
            local target = A.FindTarget(300)
            if target then
                A.AdvCombat.FarmAll(target)
                local health = GetHealthPercent(target)
                if health <= 0 then
                    A.AdvCombat.CombatStats.TotalKills = A.AdvCombat.CombatStats.TotalKills + 1
                    A.AdvCombat.CombatStats.CurrentStreak = A.AdvCombat.CombatStats.CurrentStreak + 1
                    if A.AdvCombat.CombatStats.CurrentStreak > A.AdvCombat.CombatStats.BestStreak then
                        A.AdvCombat.CombatStats.BestStreak = A.AdvCombat.CombatStats.CurrentStreak
                    end
                    table.insert(A.AdvCombat.PlayerKills, {
                        Player = target.Name,
                        Time = tick()
                    })
                end
            end
        end)
        task.wait(0.1)
    end
end

function A.AdvCombat.Start()
    if A.AdvCombat.Active then return end
    A.AdvCombat.Active = true
    A.AdvCombat.ResetCombatStats()
    A.AdvCombat.AntiStunlock()
    A.Notify("Advanced Combat", "Advanced combat started! Mode: " .. A.AdvCombat.Mode, 5)
    task.spawn(function()
        A.AdvCombat.MainLoop()
    end)
end

function A.AdvCombat.Stop()
    A.AdvCombat.Active = false
    A.AdvCombat.ClearStun()
    A.AdvCombat.ClearHighlights()
    A.Notify("Advanced Combat", "Advanced combat stopped!", 3)
end

A.Register("advanced_combat", A.AdvCombat)
