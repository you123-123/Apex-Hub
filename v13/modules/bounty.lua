local A = _G.Apex
local Bounty = {}
Bounty.Active = false
Bounty.CurrentTarget = nil
Bounty.BountyKills = 0
Bounty.BountyEarned = 0
Bounty.BountyHistory = {}
Bounty._loop = nil
Bounty._startTick = 0
Bounty._lastBounty = 0
Bounty._lastHonor = 0
Bounty._safeMode = false
Bounty._lastDeathTime = 0
Bounty._targetCache = {}
Bounty._killLog = {}
Bounty._sessionKills = 0
Bounty._sessionEarned = 0
Bounty._targetSwitchCount = 0
Bounty._consecutiveFails = 0
Bounty._maxConsecutiveFails = 5
Bounty._huntMode = "balanced"
Bounty._avoidList = {}
Bounty._preferredTargets = {}
Bounty._lastFleeTime = 0
Bounty._fleeCooldown = 10

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Apex Bounty] Error: " .. tostring(err))
    end
    return ok, err
end

function Bounty.GetBounty()
    local lp = A.LP
    if not lp then return 0 end
    local leaderstats = lp:FindFirstChild("leaderstats")
    if not leaderstats then return 0 end
    local bountyVal = leaderstats:FindFirstChild("Bounty/Honor")
    if not bountyVal then
        bountyVal = leaderstats:FindFirstChild("Bounty")
    end
    if bountyVal and bountyVal:IsA("ValueBase") then
        return tonumber(bountyVal.Value) or 0
    end
    return 0
end

function Bounty.GetHonor()
    local lp = A.LP
    if not lp then return 0 end
    local leaderstats = lp:FindFirstChild("leaderstats")
    if not leaderstats then return 0 end
    local honorVal = leaderstats:FindFirstChild("Bounty/Honor")
    if not honorVal then
        honorVal = leaderstats:FindFirstChild("Honor")
    end
    if honorVal and honorVal:IsA("ValueBase") then
        return tonumber(honorVal.Value) or 0
    end
    return Bounty.GetBounty()
end

function Bounty.GetPlayers()
    local lp = A.LP
    local results = {}
    if not lp or not lp.Character then return results end
    local hrp = A.HRP()
    if not hrp then return results end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lp and player.Character then
            local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHum = player.Character:FindFirstChild("Humanoid")
            if targetHRP and targetHum and targetHum.Health > 0 then
                local dist = (hrp.Position - targetHRP.Position).Magnitude
                local tb = player:FindFirstChild("leaderstats")
                local bounty = 0
                if tb then
                    local bv = tb:FindFirstChild("Bounty/Honor") or tb:FindFirstChild("Bounty")
                    if bv and bv:IsA("ValueBase") then
                        bounty = tonumber(bv.Value) or 0
                    end
                end
                table.insert(results, {
                    Player = player,
                    Distance = dist,
                    Bounty = bounty,
                    Health = targetHum.Health,
                    MaxHealth = targetHum.MaxHealth,
                    Name = player.DisplayName or player.Name
                })
            end
        end
    end
    table.sort(results, function(a, b)
        if Bounty._huntMode == "bounty" then
            return a.Bounty > b.Bounty
        elseif Bounty._huntMode == "easy" then
            return a.Health < b.Health
        elseif Bounty._huntMode == "close" then
            return a.Distance < b.Distance
        else
            local scoreA = a.Bounty / math.max(a.Distance, 1) * (1 - a.Health / math.max(a.MaxHealth, 1))
            local scoreB = b.Bounty / math.max(b.Distance, 1) * (1 - b.Health / math.max(b.MaxHealth, 1))
            return scoreA > scoreB
        end
    end)
    return results
end

function Bounty.GetPlayerStats(player)
    if not player or not player.Character then return nil end
    local hum = player.Character:FindFirstChild("Humanoid")
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return nil end
    local level = 0
    local vl = player:FindFirstChild("Level")
    if vl and vl:IsA("ValueBase") then
        level = tonumber(vl.Value) or 0
    end
    local bounty = 0
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        local bv = ls:FindFirstChild("Bounty/Honor") or ls:FindFirstChild("Bounty")
        if bv and bv:IsA("ValueBase") then
            bounty = tonumber(bv.Value) or 0
        end
    end
    local myBounty = Bounty.GetBounty()
    return {
        Name = player.DisplayName or player.Name,
        Level = level,
        Bounty = bounty,
        Health = hum.Health,
        MaxHealth = hum.MaxHealth,
        HealthPercent = hum.Health / math.max(hum.MaxHealth, 1),
        Distance = (A.HRP() and (A.HRP().Position - hrp.Position).Magnitude) or math.huge,
        IsVulnerable = hum.Health > 0 and hum.Health < hum.MaxHealth * 0.5,
        CanKill = bounty >= 10000,
        BountyDifference = bounty - myBounty,
        Score = bounty * (1 - hum.Health / math.max(hum.MaxHealth, 1)) / math.max((A.HRP() and (A.HRP().Position - hrp.Position).Magnitude) or 1, 1)
    }
end

function Bounty.IsPlayerStrong(player)
    local stats = Bounty.GetPlayerStats(player)
    if not stats then return true end
    if stats.Level > A.Lv() + 200 then return true end
    if stats.Bounty > Bounty.GetBounty() * 1.5 then return true end
    if stats.HealthPercent > 0.8 and stats.Distance < 50 then
        local myStats = {
            Health = A.Hum() and A.Hum().Health or 0,
            MaxHealth = A.Hum() and A.Hum().MaxHealth or 1
        }
        if myStats.Health / math.max(myStats.MaxHealth, 1) < 0.3 then
            return true
        end
    end
    for _, avoidName in ipairs(Bounty._avoidList) do
        if stats.Name == avoidName then return true end
    end
    return false
end

function Bounty.CanKillPlayer(player)
    local stats = Bounty.GetPlayerStats(player)
    if not stats then return false end
    if stats.Health <= 0 then return false end
    local myStats = {
        Health = A.Hum() and A.Hum().Health or 0,
        MaxHealth = A.Hum() and A.Hum().MaxHealth or 1
    }
    local myHealthPct = myStats.Health / math.max(myStats.MaxHealth, 1)
    if myHealthPct < 0.15 and stats.HealthPercent > 0.5 then
        return false
    end
    if stats.Distance > 1000 then return false end
    return true
end

function Bounty.GetBountyTarget()
    local players = Bounty.GetPlayers()
    for _, data in ipairs(players) do
        if not Bounty.IsPlayerStrong(data.Player) and Bounty.CanKillPlayer(data.Player) then
            local isAvoided = false
            for _, avoidName in ipairs(Bounty._avoidList) do
                if data.Name == avoidName then
                    isAvoided = true
                    break
                end
            end
            if not isAvoided then
                return data
            end
        end
    end
    return nil
end

function Bounty.SelectTarget(mode)
    Bounty._huntMode = mode or "balanced"
    local target = Bounty.GetBountyTarget()
    if target then
        Bounty.CurrentTarget = target
        A.Notify("Bounty Target", "Selected: " .. target.Name .. " | Bounty: " .. tostring(target.Bounty), 3)
        return target
    end
    return nil
end

function Bounty.FindTarget(range)
    range = range or 1500
    local players = Bounty.GetPlayers()
    for _, data in ipairs(players) do
        if data.Distance <= range and not Bounty.IsPlayerStrong(data.Player) then
            return data.Player
        end
    end
    return nil
end

function Bounty.ChaseTarget(target)
    if not target or not target.Character then return false end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local myHRP = A.HRP()
    if not myHRP then return false end
    local dist = (myHRP.Position - hrp.Position).Magnitude
    if dist > 50 then
        A.TpTo(hrp.Position + Vector3.new(
            math.random(-5, 5),
            3,
            math.random(-5, 5)
        ), 30)
        return true
    end
    return false
end

function Bounty.FightPlayer(target)
    if not target or not target.Character then return false end
    local targetHum = target.Character:FindFirstChild("Humanoid")
    if not targetHum or targetHum.Health <= 0 then return false end
    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return false end
    local myHRP = A.HRP()
    if not myHRP then return false end
    local dist = (myHRP.Position - targetHRP.Position).Magnitude
    if dist > 300 then
        A.TpTo(targetHRP.Position, 100)
        return true
    end
    if dist > 20 then
        A.TweenTo(targetHRP.Position, 200)
        return true
    end
    A.Attack(target, {"MouseButton1"}, 0.1)
    return true
end

function Bounty.FleeFromDanger()
    local myHRP = A.HRP()
    if not myHRP then return false end
    local myPos = myHRP.Position
    local players = Bounty.GetPlayers()
    local threats = 0
    for _, data in ipairs(players) do
        if data.Distance < 200 and Bounty.IsPlayerStrong(data.Player) then
            threats = threats + 1
        end
    end
    if threats >= 2 then
        Bounty._safeMode = true
        Bounty._lastFleeTime = tick()
        local fleeDir = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
        local fleePos = myPos + fleeDir * 300 + Vector3.new(0, 100, 0)
        A.TpTo(fleePos, 50)
        A.Notify("Safe Mode", "Fleeing from " .. tostring(threats) .. " threats!", 3)
        return true
    end
    return false
end

function Bounty.AvoidDangerousPlayers()
    local players = Bounty.GetPlayers()
    for _, data in ipairs(players) do
        if Bounty.IsPlayerStrong(data.Player) and data.Distance < 300 then
            if not table.find(Bounty._avoidList, data.Name) then
                table.insert(Bounty._avoidList, data.Name)
                A.Notify("Avoiding", data.Name .. " (too strong)", 2)
            end
            if data.Distance < 150 then
                return Bounty.FleeFromDanger()
            end
        end
    end
    if tick() - Bounty._lastFleeTime > 60 then
        Bounty._avoidList = {}
    end
    return false
end

function Bounty.GetKillReward(bountyBefore, bountyAfter)
    local killed = 0
    local earned = 0
    if bountyAfter > bountyBefore then
        earned = bountyAfter - bountyBefore
        killed = 1
    elseif bountyAfter < bountyBefore then
        local lostAmount = bountyBefore - bountyAfter
        if lostAmount > 1000 then
            A.Notify("Bounty Lost", "Lost " .. tostring(lostAmount) .. " bounty", 3)
        end
    end
    return killed, earned
end

function Bounty.TrackBountyChange()
    local currentBounty = Bounty.GetBounty()
    local currentHonor = Bounty.GetHonor()
    if Bounty._lastBounty > 0 then
        local kills, earned = Bounty.GetKillReward(Bounty._lastBounty, currentBounty)
        if kills > 0 then
            Bounty.BountyKills = Bounty.BountyKills + kills
            Bounty.BountyEarned = Bounty.BountyEarned + earned
            Bounty._sessionKills = Bounty._sessionKills + kills
            Bounty._sessionEarned = Bounty._sessionEarned + earned
            table.insert(Bounty.BountyHistory, {
                Time = tick(),
                Bounty = currentBounty,
                Earned = earned,
                Total = Bounty.BountyKills
            })
            A.Notify("Kill!", "+" .. tostring(earned) .. " bounty earned", 3)
        end
    end
    Bounty._lastBounty = currentBounty
    Bounty._lastHonor = currentHonor
end

function Bounty.HopBounty()
    A.Notify("Server Hop", "Hopping for bounty targets...", 3)
    local servers = {}
    local ok, res = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)
    if ok and res and res.data then
        for _, srv in ipairs(res.data) do
            if srv.id ~= game.JobId and srv.playing < srv.maxPlayers then
                table.insert(servers, srv)
            end
        end
    end
    if #servers > 0 then
        table.sort(servers, function(a, b)
            return (a.playing or 0) > (b.playing or 0)
        end)
        local chosen = servers[math.random(1, math.min(5, #servers))]
        if chosen and chosen.id then
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, chosen.id, A.LP)
            end)
            return true
        end
    end
    return false
end

function Bounty.BountyRoute()
    local myHRP = A.HRP()
    if not myHRP then return end
    local target = Bounty.GetBountyTarget()
    if target then
        Bounty.ChaseTarget(target)
        Bounty.FightPlayer(target)
    else
        local players = Bounty.GetPlayers()
        if #players == 0 then
            Bounty.HopBounty()
        end
    end
end

function Bounty.SafeMode()
    if tick() - Bounty._lastDeathTime < 15 then
        return true
    end
    if Bounty._safeMode and tick() - Bounty._lastFleeTime > 30 then
        Bounty._safeMode = false
    end
    if Bounty._consecutiveFails >= Bounty._maxConsecutiveFails then
        Bounty._safeMode = true
        A.Notify("Safe Mode", "Too many failures, entering safe mode", 5)
        return true
    end
    local hum = A.Hum()
    if hum and hum.Health / math.max(hum.MaxHealth, 1) < 0.2 then
        local myHRP = A.HRP()
        if myHRP then
            local safePos = myHRP.Position + Vector3.new(0, 200, 0)
            A.TpTo(safePos, 50)
        end
        return true
    end
    return Bounty._safeMode
end

function Bounty.GetBountyStats()
    local current = Bounty.GetBounty()
    local sessionTime = tick() - Bounty._startTick
    local minutes = math.floor(sessionTime / 60)
    local seconds = math.floor(sessionTime % 60)
    return {
        CurrentBounty = current,
        SessionKills = Bounty._sessionKills,
        SessionEarned = Bounty._sessionEarned,
        TotalKills = Bounty.BountyKills,
        TotalEarned = Bounty.BountyEarned,
        SessionTime = string.format("%dm %ds", minutes, seconds),
        Rate = sessionTime > 0 and string.format("%.0f/min", Bounty._sessionEarned / (sessionTime / 60)) or "0/min",
        TargetSwitches = Bounty._targetSwitchCount,
        SafeMode = Bounty._safeMode,
        History = #Bounty.BountyHistory
    }
end

function Bounty.MainLoop()
    while Bounty.Active do
        if not A.Alive() then
            task.wait(2)
            break
        end
        if Bounty.SafeMode() then
            task.wait(1)
            break
        end
        Bounty.TrackBountyChange()
        local ok, err = SafeCall(function()
            if Bounty.CurrentTarget then
                local tgt = Bounty.CurrentTarget
                if not tgt.Player or not tgt.Player.Character then
                    Bounty.CurrentTarget = nil
                    Bounty._targetSwitchCount = Bounty._targetSwitchCount + 1
                else
                    local tgtHum = tgt.Player.Character:FindFirstChild("Humanoid")
                    if not tgtHum or tgtHum.Health <= 0 then
                        Bounty.CurrentTarget = nil
                        Bounty._targetSwitchCount = Bounty._targetSwitchCount + 1
                    else
                        local tgtHRP = tgt.Player.Character:FindFirstChild("HumanoidRootPart")
                        if tgtHRP then
                            local dist = (A.HRP().Position - tgtHRP.Position).Magnitude
                            if dist > 2000 then
                                Bounty.CurrentTarget = nil
                                Bounty._targetSwitchCount = Bounty._targetSwitchCount + 1
                            elseif dist > 300 then
                                Bounty.ChaseTarget(tgt.Player)
                            else
                                Bounty.FightPlayer(tgt.Player)
                            end
                        end
                    end
                end
            end
            if not Bounty.CurrentTarget then
                if not Bounty.AvoidDangerousPlayers() then
                    local target = Bounty.GetBountyTarget()
                    if target then
                        Bounty.CurrentTarget = target
                        Bounty._targetSwitchCount = Bounty._targetSwitchCount + 1
                    else
                        Bounty.BountyRoute()
                    end
                end
            end
        end)
        if not ok then
            Bounty._consecutiveFails = Bounty._consecutiveFails + 1
        else
            Bounty._consecutiveFails = 0
        end
        task.wait(0.3)
    end
end

function Bounty.Start(mode)
    if Bounty.Active then return end
    Bounty.Active = true
    Bounty._startTick = tick()
    Bounty._lastBounty = Bounty.GetBounty()
    Bounty._lastHonor = Bounty.GetHonor()
    Bounty._consecutiveFails = 0
    Bounty._avoidList = {}
    if mode then
        Bounty._huntMode = mode
    end
    A.Notify("Bounty Hunter", "Started with mode: " .. Bounty._huntMode, 3)
    Bounty._loop = task.spawn(function()
        Bounty.MainLoop()
        Bounty.Active = false
    end)
end

function Bounty.Stop()
    Bounty.Active = false
    Bounty.CurrentTarget = nil
    if Bounty._loop then
        task.cancel(Bounty._loop)
        Bounty._loop = nil
    end
    A.Notify("Bounty Hunter", "Stopped", 2)
end

A.Bounty = Bounty
A.Register("bounty", A.Bounty)
