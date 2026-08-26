local A = _G.Apex
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local LP = A.LP
local V3 = A.V3
local CF = A.CF

A.AntiDetect = {}
local AD = A.AntiDetect

AD.Active = false
AD.DetectionLevel = 0
AD.ThreatLevel = 0
AD.History = {}
AD.SafeMode = true
AD.LastReportTime = 0
AD.ReportCooldown = 30
AD.SuspiciousActivity = 0
AD.ConsecutiveTeleports = 0
AD.LastTeleportTime = 0
AD.TeleportBurstLimit = 3
AD.TeleportBurstWindow = 5
AD.StealthActive = false
AD.AntiReportActive = false
AD.EmergencyMode = false
AD.PositionHistory = {}
AD.VelocityHistory = {}
AD.DeathCount = 0
AD.LastDeathTime = 0
AD.PlayerDeathTracker = {}
AD.AdminList = {}
AD.ReportWatchList = {}
AD.MovementPattern = {}
AD.InvisibilityDetected = false
AD.SpeedHackDetected = false
AD.FlyHackDetected = false
AD.TeleportHackDetected = false
AD.DetectionThreshold = 3
AD.MaxThreatBeforeStop = 80
AD.RecoveryDelay = 5
AD.LastScanTime = 0
AD.ScanInterval = 2
AD.KickMonitorActive = false
AD.AdminMonitorActive = false
AD.ReportMonitorActive = false
AD.BehaviorMonitorActive = false
AD.LogBuffer = {}
AD.MaxLogSize = 100

function AD.MonitorDetection()
    if not AD.Active then return end
    local now = tick()
    if now - AD.LastScanTime < AD.ScanInterval then return end
    AD.LastScanTime = now
    local signals = {}
    local myHRP = A.HRP()
    if myHRP then
        local vel = myHRP.Velocity
        local speed = vel.Magnitude
        if speed > 150 and not AD.SafeMode then
            table.insert(signals, {Type = "SpeedAnomaly", Severity = 2, Detail = "Speed: " .. math.floor(speed)})
            AD.SpeedHackDetected = true
        else
            AD.SpeedHackDetected = false
        end
        table.insert(AD.VelocityHistory, {Velocity = vel, Time = now, Speed = speed})
        if #AD.VelocityHistory > 30 then
            table.remove(AD.VelocityHistory, 1)
        end
        local pos = myHRP.Position
        table.insert(AD.PositionHistory, {Position = pos, Time = now})
        if #AD.PositionHistory > 50 then
            table.remove(AD.PositionHistory, 1)
        end
        if #AD.PositionHistory >= 5 then
            local lastFive = {}
            for i = math.max(1, #AD.PositionHistory - 4), #AD.PositionHistory do
                table.insert(lastFive, AD.PositionHistory[i])
            end
            local totalDist = 0
            for i = 2, #lastFive do
                totalDist = totalDist + (lastFive[i].Position - lastFive[i-1].Position).Magnitude
            end
            local timeDiff = lastFive[#lastFive].Time - lastFive[1].Time
            if timeDiff > 0 then
                local avgSpeed = totalDist / timeDiff
                if avgSpeed > 200 then
                    table.insert(signals, {Type = "ConsistentSpeedHack", Severity = 3, Detail = "AvgSpeed: " .. math.floor(avgSpeed)})
                end
            end
        end
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local theirHRP = player.Character.HumanoidRootPart
            local theirVel = theirHRP.Velocity
            local theirSpeed = theirVel.Magnitude
            if theirSpeed > 150 then
                table.insert(signals, {Type = "PlayerSpeedHack", Severity = 1, Detail = player.Name .. " speed: " .. math.floor(theirSpeed)})
            end
            if theirHRP.Position.Y > 300 then
                local rayParams = RaycastParams.new()
                local ray = workspace:Raycast(theirHRP.Position, V3(0, -500, 0), rayParams)
                if not ray then
                    table.insert(signals, {Type = "PlayerFlyHack", Severity = 2, Detail = player.Name .. " floating"})
                end
            end
        end
    end
    local char = A.Char()
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if humanoid.WalkSpeed > 30 then
                table.insert(signals, {Type = "WalkSpeedModified", Severity = 1, Detail = "WalkSpeed: " .. humanoid.WalkSpeed})
            end
            if humanoid.JumpPower > 100 then
                table.insert(signals, {Type = "JumpPowerModified", Severity = 1, Detail = "JumpPower: " .. humanoid.JumpPower})
            end
        end
    end
    for _, signal in pairs(signals) do
        AD.AddDetection(signal.Severity, signal.Type .. ": " .. signal.Detail)
    end
    AD.UpdateThreatLevel()
end

function AD.ScanForDetection()
    local signals = {}
    local now = tick()
    local myHRP = A.HRP()
    if myHRP then
        local pos = myHRP.Position
        local vel = myHRP.Velocity
        local speed = vel.Magnitude
        if speed > 120 then
            table.insert(signals, {Type = "HighSpeed", Level = 2, Data = speed})
        end
        local recentPositions = {}
        for _, entry in pairs(AD.PositionHistory) do
            if now - entry.Time < 3 then
                table.insert(recentPositions, entry.Position)
            end
        end
        if #recentPositions >= 3 then
            local jumps = 0
            for i = 2, #recentPositions do
                local dist = (recentPositions[i] - recentPositions[i-1]).Magnitude
                if dist > 100 then
                    jumps = jumps + 1
                end
            end
            if jumps >= 2 then
                table.insert(signals, {Type = "TeleportPattern", Level = 3, Data = jumps})
            end
        end
        local rayParams = RaycastParams.new()
        local ray = workspace:Raycast(pos, V3(0, -20, 0), rayParams)
        if not ray then
            table.insert(signals, {Type = "Floating", Level = 1, Data = "No ground contact"})
        end
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = myHRP and (player.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude or 0
                if dist > 0 and dist < 50 then
                    local theirHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if theirHumanoid and theirHumanoid.Health <= 0 then
                        table.insert(signals, {Type = "NearbyDeath", Level = 1, Data = player.Name})
                    end
                end
            end
        end
    end
    return signals
end

function AD.MonitorKick()
    if not AD.Active then return end
    AD.KickMonitorActive = true
    local heartbeatConn
    heartbeatConn = RunService.Heartbeat:Connect(function()
        if not AD.Active then
            if heartbeatConn then heartbeatConn:Disconnect() end
            return
        end
        pcall(function()
            local success, err = pcall(function()
                if not LP or not LP.Parent then
                    AD.OnDetection(5, "Player removed from game")
                end
            end)
        end)
    end)
end

function AD.MonitorAdmin()
    if not AD.Active then return end
    AD.AdminMonitorActive = true
    local knownAdmins = {}
    local adminGroups = {25347177, 12283074, 41028184}
    while AD.Active do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP then
                local isAdmin = false
                pcall(function()
                    for _, groupId in pairs(adminGroups) do
                        local success, result = pcall(function()
                            return player:GetRankInGroup(groupId)
                        end)
                        if success and result and result >= 100 then
                            isAdmin = true
                            break
                        end
                    end
                end)
                local name = player.Name:lower()
                local adminKeywords = {"admin", "mod", "staff", "dev", "builder", "roblox"}
                for _, keyword in pairs(adminKeywords) do
                    if name:find(keyword) then
                        isAdmin = true
                        break
                    end
                end
                if isAdmin and not knownAdmins[player.Name] then
                    knownAdmins[player.Name] = true
                    AD.OnDetection(4, "Admin/Mod detected: " .. player.Name)
                    AD.ThreatLevel = AD.ThreatLevel + 30
                end
            end
        end
        wait(15)
    end
end

function AD.MonitorReport()
    if not AD.Active then return end
    AD.ReportMonitorActive = true
    while AD.Active do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP then
                if player.Chatted then
                    player.Chatted:Connect(function(message)
                        if not AD.Active then return end
                        local msg = message:lower()
                        local reportKeywords = {"report", "hack", "cheat", "exploit", "ban", "exploiter", "hacker", "cheater"}
                        for _, keyword in pairs(reportKeywords) do
                            if msg:find(keyword) then
                                AD.ReportWatchList[player.Name] = {
                                    Reason = message,
                                    Time = tick(),
                                    Threat = 3
                                }
                                AD.ThreatLevel = AD.ThreatLevel + 15
                                AD.OnDetection(3, "Potential report from " .. player.Name .. ": " .. message)
                                break
                            end
                        end
                    end)
                end
            end
        end
        wait(5)
    end
end

function AD.MonitorBehavior()
    if not AD.Active then return end
    AD.BehaviorMonitorActive = true
    local lastPosition = nil
    local lastCheckTime = tick()
    local positionChecks = {}
    while AD.Active do
        local now = tick()
        local myHRP = A.HRP()
        if myHRP and now - lastCheckTime > 0.5 then
            local currentPos = myHRP.Position
            if lastPosition then
                local dist = (currentPos - lastPosition).Magnitude
                local dt = now - lastCheckTime
                local speed = dist / math.max(dt, 0.01)
                table.insert(positionChecks, {Speed = speed, Time = now, Position = currentPos})
                if #positionChecks > 20 then
                    table.remove(positionChecks, 1)
                end
                if speed > 200 then
                    AD.SuspiciousActivity = AD.SuspiciousActivity + 3
                elseif speed > 100 then
                    AD.SuspiciousActivity = AD.SuspiciousActivity + 1
                end
                if #positionChecks >= 5 then
                    local recentChecks = {}
                    for i = math.max(1, #positionChecks - 4), #positionChecks do
                        table.insert(recentChecks, positionChecks[i])
                    end
                    local avgSpeed = 0
                    for _, check in pairs(recentChecks) do
                        avgSpeed = avgSpeed + check.Speed
                    end
                    avgSpeed = avgSpeed / #recentChecks
                    if avgSpeed > 150 then
                        AD.SuspiciousActivity = AD.SuspiciousActivity + 5
                    end
                end
            end
            lastPosition = currentPos
            lastCheckTime = now
        end
        if AD.SuspiciousActivity > 10 then
            AD.OnDetection(2, "Suspicious behavior threshold exceeded")
            AD.SuspiciousActivity = math.max(0, AD.SuspiciousActivity - 2)
        end
        wait(0.5)
    end
end

function AD.OnDetection(level, reason)
    if not AD.Active then return end
    local now = tick()
    AD.DetectionLevel = math.max(AD.DetectionLevel, level)
    AD.AddDetection(level, reason)
    A.Notify("Anti-Detect", "Detection Level " .. level .. ": " .. reason, 3)
    if level >= 4 then
        AD.ThreatLevel = AD.ThreatLevel + 40
    elseif level >= 3 then
        AD.ThreatLevel = AD.ThreatLevel + 25
    elseif level >= 2 then
        AD.ThreatLevel = AD.ThreatLevel + 15
    else
        AD.ThreatLevel = AD.ThreatLevel + 5
    end
    AD.ThreatLevel = math.min(AD.ThreatLevel, 100)
    if AD.ThreatLevel >= AD.MaxThreatBeforeStop then
        AD.EmergencyMode = true
        AD.EmergencyStop()
    elseif AD.ThreatLevel >= 60 then
        AD.SafeMode = true
        AD.SafeDelay(2, 5)
    elseif AD.ThreatLevel >= 40 then
        AD.SafeMode = true
    end
end

function AD.SafeTeleport(pos)
    if not pos then return end
    if not AD.Active then A.TpTo(pos, 100) return end
    local myHRP = A.HRP()
    if not myHRP then return end
    local now = tick()
    AD.ConsecutiveTeleports = AD.ConsecutiveTeleports + 1
    if now - AD.LastTeleportTime > AD.TeleportBurstWindow then
        AD.ConsecutiveTeleports = 1
    end
    AD.LastTeleportTime = now
    if AD.ConsecutiveTeleports > AD.TeleportBurstLimit then
        wait(AD.SafeDelay(1, 3))
        AD.ConsecutiveTeleports = 0
    end
    local currentPos = myHRP.Position
    local dist = (pos - currentPos).Magnitude
    if dist > 200 then
        local midPoint = currentPos + (pos - currentPos) * 0.5
        midPoint = midPoint + V3(math.random(-5, 5), math.random(-2, 2), math.random(-5, 5))
        A.TpTo(midPoint, 150)
        wait(AD.SafeDelay(0.2, 0.5))
    end
    local jitteredPos = pos + V3(math.random(-3, 3) / 10, math.random(-1, 1) / 10, math.random(-3, 3) / 10)
    A.TpTo(jitteredPos, 200)
    AD.ConsecutiveTeleports = AD.ConsecutiveTeleports + 1
end

function AD.SafeWalk(pos, speed)
    if not pos then return end
    if not A.Alive() then return end
    speed = speed or 16
    local myHRP = A.HRP()
    local myHum = A.Hum()
    if not myHRP or not myHum then return end
    myHum.WalkSpeed = speed
    local path = nil
    pcall(function()
        local PathService = game:GetService("PathfindingService")
        path = PathService:CreatePath({
            AgentRadius = 2,
            AgentHeight = 5,
            AgentCanJump = true,
            AgentCanClimb = false
        })
        path:ComputeAsync(myHRP.Position, pos)
    end)
    if path and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _, waypoint in ipairs(waypoints) do
            if not AD.Active or not A.Alive() then break end
            local jitter = V3(math.random(-2, 2) / 10, 0, math.random(-2, 2) / 10)
            myHum:MoveTo(waypoint.Position + jitter)
            local moveStart = tick()
            while tick() - moveStart < 3 do
                if not A.Alive() then break end
                local dist = (myHRP.Position - waypoint.Position).Magnitude
                if dist < 4 then break end
                if AD.SafeMode then
                    local speed = myHRP.Velocity.Magnitude
                    if speed > 100 then
                        myHum.WalkSpeed = 16
                        wait(0.1)
                    end
                end
                RunService.Heartbeat:Wait()
            end
        end
    else
        A.TpTo(pos, 100)
    end
    myHum.WalkSpeed = 16
end

function AD.SafeFly(pos, speed)
    if not pos then return end
    if not A.Alive() then return end
    speed = speed or 80
    local myHRP = A.HRP()
    if not myHRP then return end
    local startPos = myHRP.Position
    local dist = (pos - startPos).Magnitude
    local duration = dist / speed
    local startTime = tick()
    local bodyPos = Instance.new("BodyPosition")
    bodyPos.MaxForce = V3(math.huge, math.huge, math.huge)
    bodyPos.P = 10000
    bodyPos.D = 500
    bodyPos.Parent = myHRP
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = V3(math.huge, math.huge, math.huge)
    bodyGyro.P = 10000
    bodyGyro.D = 500
    bodyGyro.Parent = myHRP
    while tick() - startTime < duration do
        if not AD.Active or not A.Alive() then break end
        local elapsed = tick() - startTime
        local alpha = math.clamp(elapsed / duration, 0, 1)
        local easedAlpha = alpha * alpha * (3 - 2 * alpha)
        local currentPos = startPos + (pos - startPos) * easedAlpha
        if AD.SafeMode then
            currentPos = currentPos + V3(math.random(-3, 3), math.random(-2, 2), math.random(-3, 3))
        end
        bodyPos.Position = currentPos
        local lookDir = (pos - myHRP.Position).Unit
        bodyGyro.CFrame = CFrame.lookAt(myHRP.Position, myHRP.Position + lookDir)
        RunService.Heartbeat:Wait()
    end
    bodyPos:Destroy()
    bodyGyro:Destroy()
    myHRP.CFrame = CFrame.lookAt(pos, pos + (pos - startPos).Unit)
end

function AD.JitterPosition()
    if not A.Alive() then return end
    local myHRP = A.HRP()
    if not myHRP then return end
    local currentPos = myHRP.Position
    local jitter = V3(
        (math.random() - 0.5) * 2,
        (math.random() - 0.5) * 0.5,
        (math.random() - 0.5) * 2
    )
    myHRP.CFrame = myHRP.CFrame + jitter
end

function AD.RandomizeDelay(min, max)
    min = min or 0.1
    max = max or 0.5
    local baseDelay = min + math.random() * (max - min)
    local humanFactor = math.random() > 0.9 and math.random() * 0.3 or 0
    return baseDelay + humanFactor
end

function AD.SafeDelay(min, max)
    min = min or 0.05
    max = max or 0.2
    local delay = min + math.random() * (max - min)
    wait(delay)
    return delay
end

function AD.StartAntiReport()
    AD.AntiReportActive = true
    A.Notify("Anti-Report", "Anti-Report System Activated", 2)
end

function AD.StopAntiReport()
    AD.AntiReportActive = false
end

function AD.CheckReportRisk()
    local risk = 0
    local now = tick()
    for playerName, data in pairs(AD.ReportWatchList) do
        if now - data.Time < 300 then
            risk = risk + data.Threat
        end
    end
    if AD.SuspiciousActivity > 5 then
        risk = risk + AD.SuspiciousActivity
    end
    local myHRP = A.HRP()
    if myHRP then
        local nearbyCount = 0
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (player.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
                if dist < 50 then
                    nearbyCount = nearbyCount + 1
                end
            end
        end
        if nearbyCount > 3 then
            risk = risk + nearbyCount * 5
        end
    end
    return math.min(risk, 100)
end

function AD.StealthMode()
    AD.StealthActive = true
    pcall(function()
        local playerGui = LP:FindFirstChild("PlayerGui")
        if playerGui then
            local nameGui = playerGui:FindFirstChild("NameGui")
            if nameGui then
                nameGui.Enabled = false
            end
        end
    end)
    local myHRP = A.HRP()
    if myHRP then
        for _, desc in pairs(myHRP:GetDescendants()) do
            if desc:IsA("BillboardGui") then
                desc.Enabled = false
            end
        end
    end
    A.Notify("Stealth", "Stealth Mode Activated", 2)
end

function AD.UnStealthMode()
    AD.StealthActive = false
    pcall(function()
        local playerGui = LP:FindFirstChild("PlayerGui")
        if playerGui then
            local nameGui = playerGui:FindFirstChild("NameGui")
            if nameGui then
                nameGui.Enabled = true
            end
        end
    end)
    local myHRP = A.HRP()
    if myHRP then
        for _, desc in pairs(myHRP:GetDescendants()) do
            if desc:IsA("BillboardGui") then
                desc.Enabled = true
            end
        end
    end
    A.Notify("Stealth", "Stealth Mode Deactivated", 2)
end

function AD.FullStealthMode()
    AD.StealthMode()
    AD.SafeMode = true
    AD.ReportCooldown = 60
    AD.TeleportBurstLimit = 2
    AD.ScanInterval = 1
    A.Notify("Full Stealth", "Full Stealth Mode Activated", 2)
end

function AD.AntiReport()
    if not AD.AntiReportActive then return end
    local risk = AD.CheckReportRisk()
    if risk > 50 then
        AD.SafeMode = true
        AD.StealthMode()
        AD.SafeDelay(2, 4)
    end
    if risk > 80 then
        AD.EmergencyTeleport()
    end
end

function AD.CheckNearbyPlayers()
    local myHRP = A.HRP()
    if not myHRP then return {} end
    local nearby = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
            if dist < 100 then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                table.insert(nearby, {
                    Player = player,
                    Distance = dist,
                    Health = hum and hum.Health or 0,
                    MaxHealth = hum and hum.MaxHealth or 1,
                    Alive = hum and hum.Health > 0
                })
            end
        end
    end
    return nearby
end

function AD.EmergencyStop()
    AD.EmergencyMode = true
    A.Notify("EMERGENCY", "Emergency Stop Activated!", 5)
    pcall(function()
        _G.Apex.AutoFarm = false
        _G.Apex.AutoQuest = false
        if _G.Apex.MegaFarm then _G.Apex.MegaFarm.Active = false end
        if _G.Apex.CombatAI then _G.Apex.CombatAI.Active = false end
        if _G.Apex.AutoEvents then _G.Apex.AutoEvents.Active = false end
        if _G.Apex.AutoPilot then _G.Apex.AutoPilot.Active = false end
    end)
    AD.JitterPosition()
    AD.SafeDelay(1, 3)
end

function AD.EmergencyTeleport()
    AD.EmergencyMode = true
    A.Notify("EMERGENCY", "Emergency Teleport Activated!", 5)
    local safePositions = {
        V3(0, 10, 0),
        V3(500, 10, 500),
        V3(-500, 10, -500),
        V3(1000, 10, 0),
        V3(0, 10, 1000)
    }
    local safePos = safePositions[math.random(1, #safePositions)]
    AD.SafeTeleport(safePos)
    AD.EmergencyStop()
end

function AD.EmergencyDisconnect()
    A.Notify("EMERGENCY", "Emergency Disconnect - Leaving Game!", 5)
    AD.EmergencyStop()
    wait(1)
    pcall(function()
        game:Shutdown()
    end)
end

function AD.ResetAll()
    AD.DetectionLevel = 0
    AD.ThreatLevel = 0
    AD.SuspiciousActivity = 0
    AD.ConsecutiveTeleports = 0
    AD.EmergencyMode = false
    AD.SafeMode = true
    AD.PositionHistory = {}
    AD.VelocityHistory = {}
    AD.ReportWatchList = {}
    AD.SpeedHackDetected = false
    AD.FlyHackDetected = false
    AD.TeleportHackDetected = false
    AD.InvisibilityDetected = false
    AD.LogBuffer = {}
    A.Notify("Anti-Detect", "All states reset", 2)
end

function AD.GetDetectionStats()
    local now = tick()
    local recentDetections = 0
    for _, entry in pairs(AD.History) do
        if now - entry.Time < 300 then
            recentDetections = recentDetections + 1
        end
    end
    return {
        Active = AD.Active,
        DetectionLevel = AD.DetectionLevel,
        ThreatLevel = AD.ThreatLevel,
        SafeMode = AD.SafeMode,
        StealthActive = AD.StealthActive,
        AntiReportActive = AD.AntiReportActive,
        EmergencyMode = AD.EmergencyMode,
        SuspiciousActivity = AD.SuspiciousActivity,
        SpeedHackDetected = AD.SpeedHackDetected,
        FlyHackDetected = AD.FlyHackDetected,
        TeleportHackDetected = AD.TeleportHackDetected,
        ReportRisk = AD.CheckReportRisk(),
        RecentDetections = recentDetections,
        TotalDetections = #AD.History,
        ReportWatchListSize = AD.ReportWatchList and (function() local c = 0; for _ in pairs(AD.ReportWatchList) do c = c + 1 end; return c end)() or 0
    }
end

function AD.AddDetection(level, reason)
    local entry = {
        Level = level,
        Reason = reason,
        Time = tick(),
        Position = A.GetPosition()
    }
    table.insert(AD.History, entry)
    table.insert(AD.LogBuffer, string.format("[L%d] %s", level, reason))
    if #AD.LogBuffer > AD.MaxLogSize then
        table.remove(AD.LogBuffer, 1)
    end
    if #AD.History > 500 then
        table.remove(AD.History, 1)
    end
end

function AD.GetDetectionHistory()
    return AD.History
end

function AD.SafeServerHop()
    if not AD.Active then return false end
    A.Notify("Server Hop", "Attempting safe server hop...", 2)
    AD.SafeDelay(1, 3)
    pcall(function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        if servers and servers.data then
            local currentServerId = game.JobId
            local candidates = {}
            for _, server in pairs(servers.data) do
                if server.id ~= currentServerId and server.playing and server.maxPlayers then
                    if server.playing < server.maxPlayers then
                        table.insert(candidates, server)
                    end
                end
            end
            if #candidates > 0 then
                local target = candidates[math.random(1, #candidates)]
                TeleportService:TeleportToPlaceInstance(game.PlaceId, target.id, LP)
                return true
            end
        end
    end)
    return false
end

function AD.CheckServerSafety()
    local safety = 100
    local playerCount = #Players:GetPlayers()
    if playerCount > 25 then
        safety = safety - 10
    end
    local myHRP = A.HRP()
    if myHRP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (player.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
                if dist < 30 then
                    safety = safety - 5
                end
            end
        end
    end
    for _, data in pairs(AD.ReportWatchList) do
        if tick() - data.Time < 120 then
            safety = safety - 15
        end
    end
    return math.max(safety, 0)
end

function AD.MainLoop()
    while AD.Active do
        pcall(function()
            AD.MonitorDetection()
            AD.AntiReport()
            local reportRisk = AD.CheckReportRisk()
            if reportRisk > 60 and AD.AntiReportActive then
                AD.SafeMode = true
            end
            AD.ThreatLevel = math.max(0, AD.ThreatLevel - 0.5)
            AD.SuspiciousActivity = math.max(0, AD.SuspiciousActivity - 0.2)
            if AD.EmergencyMode and AD.ThreatLevel < 20 then
                AD.EmergencyMode = false
                A.Notify("Anti-Detect", "Emergency mode cleared", 2)
            end
        end)
        wait(1)
    end
end

function AD.Start()
    if AD.Active then return end
    AD.Active = true
    AD.ResetAll()
    AD.SafeMode = true
    AD.StartAntiReport()
    AD.MonitorKick()
    AD.MonitorAdmin()
    AD.MonitorReport()
    AD.MonitorBehavior()
    A.Notify("Anti-Detect", "Anti-Detection System Activated", 2)
    spawn(function()
        AD.MainLoop()
    end)
end

function AD.Stop()
    AD.Active = false
    AD.StopAntiReport()
    AD.KickMonitorActive = false
    AD.AdminMonitorActive = false
    AD.ReportMonitorActive = false
    AD.BehaviorMonitorActive = false
    A.Notify("Anti-Detect", "Anti-Detection System Deactivated", 2)
end

function AD.SetAntiReport(v)
    A.F.AntiReport = v
end

function AD.SetStealthMovement(v)
    if v then AD.StealthMode() else AD.UnStealthMode() end
end

function AD.SetFullProtection(v)
    if v then AD.FullStealthMode() end
end

function AD.EnableStealth()
    AD.StealthMode()
end

function AD.DisableStealth()
    AD.UnStealthMode()
end

A.Register("anti_detection", AD)
return AD