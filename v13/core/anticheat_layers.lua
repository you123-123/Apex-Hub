--[[
    APEX Anticheat Layers Merged - 9 layers combined for GitHub 100 limit
    Was 9 files, now 1 (saves 8)
]]

-- === LAYER KICK ===
local A = _G.Apex or {}
local AC = A.AC or {}
A.AC = AC
-- Layer content below (original with FIX preserved)
-- LAYER 1: KICK BYPASS
---------------------------------------------------------------------------

AC._kickBypassActive = false
AC._originalKick = nil
AC._kickHooks = {}

function AC.BypassKick()
    if AC._kickBypassActive then return end
    AC._kickBypassActive = true

    pcall(function()
        if LocalPlayer and LocalPlayer.Kick then
            AC._originalKick = LocalPlayer.Kick
            LocalPlayer.Kick = function(self, ...)
                local reason = select(1, ...) or "No reason"
                local reasonStr = tostring(reason)
                AC.AddHistory(3, "Kick intercepted: " .. reasonStr)
                local blockKick = true
                local lowerReason = string.lower(reasonStr)
                if string.find(lowerReason, "maintenance") or string.find(lowerReason, "update") then
                    blockKick = false
                end
                if blockKick then
                    AC.AddHistory(3, "Kick BLOCKED by bypass: " .. reasonStr)
                    return nil
                else
                    if AC._originalKick then
                        return AC._originalKick(self, ...)
                    end
                end
            end
            table.insert(AC._kickHooks, {
                target = "LocalPlayer.Kick",
                original = AC._originalKick
            })
        end
    end)

    -- FIX: Use HookManager chaining (was overwriting __namecall, breaking L2/Remote)
    pcall(function()
        local HM = _G.Apex and _G.Apex.HookManager or nil
        if HM and HM.Hook then
            HM.Hook("__namecall", "AC_Kick", function(self, orig, ...)
                local method = getnamecallmethod()
                if method == "Kick" then
                    local args = {...}
                    local reason = args[1] or "No reason"
                    local reasonStr = tostring(reason)
                    AC.AddHistory(3, "Namecall Kick intercepted: " .. reasonStr)
                    local lowerReason = string.lower(reasonStr)
                    local blockKick = true
                    if string.find(lowerReason, "maintenance") or string.find(lowerReason, "update") then
                        blockKick = false
                    end
                    if blockKick then
                        AC.AddHistory(3, "Namecall Kick BLOCKED: " .. reasonStr)
                        return true, nil -- block chain
                    end
                end
                return false, nil -- continue chain
            end)
        else
            -- Fallback: direct hook with chaining preservation
            local mt = getrawmetatable(game)
            if mt and mt.__namecall and not AC._originalMethods["__namecall_kick"] then
                local oldNamecall = mt.__namecall
                AC._originalMethods["__namecall_kick"] = oldNamecall
                mt.__namecall = newcclosure(function(self, ...)
                    local method = getnamecallmethod()
                    if method == "Kick" then
                        local args = {...}
                        local reason = args[1] or "No reason"
                        local reasonStr = tostring(reason)
                        AC.AddHistory(3, "Namecall Kick intercepted: " .. reasonStr)
                        local lowerReason = string.lower(reasonStr)
                        if not (string.find(lowerReason, "maintenance") or string.find(lowerReason, "update")) then
                            AC.AddHistory(3, "Namecall Kick BLOCKED: " .. reasonStr)
                            return nil
                        end
                    end
                    return oldNamecall(self, ...)
                end)
                table.insert(AC._protectedMethods, "__namecall")
            end
        end
    end)

    AC.AddHistory(1, "Layer 1 (Kick Bypass) activated [HookManager Chained]")
end

function AC.UnhookKick()
    if not AC._kickBypassActive then return end
    if AC._originalKick and LocalPlayer then
        pcall(function() LocalPlayer.Kick = AC._originalKick end)
    end
    pcall(function()
        local HM = _G.Apex and _G.Apex.HookManager
        if HM and HM.Unhook then HM.Unhook("__namecall", "AC_Kick") end
    end)
    for _, hookInfo in ipairs(AC._kickHooks) do
        AC.AddHistory(0, "Unhooked: " .. hookInfo.target)
    end
    AC._kickHooks = {}
    AC._kickBypassActive = false
    AC.AddHistory(1, "Layer 1 (Kick Bypass) deactivated")
end

---------------------------------------------------------------------------

-- === LAYER TELEPORT ===
local A = _G.Apex or {}
local AC = A.AC or {}
A.AC = AC
-- Layer content below (original with FIX preserved)
-- LAYER 2: TELEPORT BYPASS
---------------------------------------------------------------------------

AC._teleportBypassActive = false
AC._lastTeleportTime = 0
AC._minTeleportInterval = 0.5
AC._teleportCount = 0

function AC.BypassTeleport()
    if AC._teleportBypassActive then return end
    AC._teleportBypassActive = true

    -- FIX: Use HookManager chaining for teleport (was overwriting Kick hook)
    pcall(function()
        local HM = _G.Apex and _G.Apex.HookManager or nil
        if HM and HM.Hook then
            -- FIX: Removed blocking task.wait inside __namecall (was freezing game thread) - now just record, throttling via SafeTeleport Governor outside hook
            HM.Hook("__namecall", "AC_Teleport", function(self, orig, ...)
                local method = getnamecallmethod()
                if method == "SetPrimaryPartCFrame" or method == "PivotTo" then
                    AC._lastTeleportTime = GetTimestamp()
                    AC._teleportCount = AC._teleportCount + 1
                end
                return false, nil -- continue chain
            end)
        else
            local mt = getrawmetatable(game)
            if mt and mt.__namecall and not AC._originalMethods["__namecall_teleport"] then
                local oldNamecall = mt.__namecall
                AC._originalMethods["__namecall_teleport"] = oldNamecall
                mt.__namecall = newcclosure(function(self, ...)
                    local method = getnamecallmethod()
                        if method == "SetPrimaryPartCFrame" or method == "PivotTo" then
                            -- FIX: No blocking wait inside hook
                        AC._lastTeleportTime = GetTimestamp()
                        AC._teleportCount = AC._teleportCount + 1
                    end
                    return oldNamecall(self, ...)
                end)
            end
        end
    end)

    AC._teleportMonitor = RunService.Heartbeat:Connect(function()
        if not AC._teleportBypassActive then return end
        local char = LocalPlayer and LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local currentPos = hrp.Position
            if AC._lastPosition then
                local distance = DistanceBetween(currentPos, AC._lastPosition)
                if distance > 100 then
                    AC.AddHistory(2, "Large teleport detected: " .. string.format("%.1f", distance) .. " studs")
                    AC.SetDetectionLevel(math.min(AC.DetectionLevel + 1, 4))
                end
            end
            AC._lastPosition = currentPos
        end
    end)
    table.insert(AC._connections, AC._teleportMonitor)

    AC.AddHistory(1, "Layer 2 (Teleport Bypass) activated")
end

function AC.UnhookTeleport()
    AC._teleportBypassActive = false
    if AC._teleportMonitor then
        AC._teleportMonitor:Disconnect()
        AC._teleportMonitor = nil
    end
    pcall(function()
        local HM = _G.Apex and _G.Apex.HookManager
        if HM and HM.Unhook then HM.Unhook("__namecall", "AC_Teleport") end
    end)
    AC.AddHistory(1, "Layer 2 (Teleport Bypass) deactivated")
end

---------------------------------------------------------------------------

-- === LAYER SPEED ===
local A = _G.Apex or {}
local AC = A.AC or {}
A.AC = AC
-- Layer content below (original with FIX preserved)
-- LAYER 3: SPEED BYPASS
---------------------------------------------------------------------------

AC._speedBypassActive = false
AC._baseSpeed = 16
AC._targetSpeed = 16
AC._speedRampRate = 2
AC._speedHistory = {}
AC._maxSpeedHistory = 50

function AC.BypassSpeed()
    if AC._speedBypassActive then return end
    AC._speedBypassActive = true

    AC._speedMonitor = RunService.Heartbeat:Connect(function(dt)
        if not AC._speedBypassActive then return end
        local char = LocalPlayer and LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local currentSpeed = humanoid.WalkSpeed
            local now = GetTimestamp()
            table.insert(AC._speedHistory, {
                speed = currentSpeed,
                time = now
            })
            if #AC._speedHistory > AC._maxSpeedHistory then
                table.remove(AC._speedHistory, 1)
            end
            if currentSpeed > AC._baseSpeed * 3 then
                AC.AddHistory(2, "Abnormal speed detected: " .. tostring(currentSpeed))
            end
        end
    end)
    table.insert(AC._connections, AC._speedMonitor)

    AC.AddHistory(1, "Layer 3 (Speed Bypass) activated")
end

function AC.SetSpeed(speed, gradual)
    gradual = gradual ~= false
    local char = LocalPlayer and LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    if AC.DetectionLevel >= 3 then
        AC.AddHistory(1, "Speed change blocked - detection level too high")
        return false
    end
    if gradual then
        local currentSpeed = humanoid.WalkSpeed
        local diff = speed - currentSpeed
        local steps = math.max(1, math.ceil(math.abs(diff) / AC._speedRampRate))
        local stepTime = 0.05
        for i = 1, steps do
            local t = i / steps
            local newSpeed = Lerp(currentSpeed, speed, t)
            humanoid.WalkSpeed = newSpeed
            task.wait(stepTime)
        end
    else
        humanoid.WalkSpeed = speed
    end
    AC._targetSpeed = speed
    return true
end

function AC.ResetSpeed()
    return AC.SetSpeed(AC._baseSpeed, true)
end

function AC.GetSpeedHistory()
    return DeepCopy(AC._speedHistory)
end

function AC.UnhookSpeed()
    AC._speedBypassActive = false
    if AC._speedMonitor then
        AC._speedMonitor:Disconnect()
        AC._speedMonitor = nil
    end
    AC.ResetSpeed()
    AC.AddHistory(1, "Layer 3 (Speed Bypass) deactivated")
end

---------------------------------------------------------------------------

-- === LAYER FLIGHT ===
local A = _G.Apex or {}
local AC = A.AC or {}
A.AC = AC
-- Layer content below (original with FIX preserved)
-- LAYER 4: FLIGHT BYPASS
---------------------------------------------------------------------------

AC._flightBypassActive = false
AC._isFlying = false
AC._flightStartPos = nil
AC._gravitySimulator = nil
AC._lastGroundCheck = 0
AC._groundCheckInterval = 0.5

function AC.BypassFlight()
    if AC._flightBypassActive then return end
    AC._flightBypassActive = true

    AC._flightMonitor = RunService.Heartbeat:Connect(function(dt)
        if not AC._flightBypassActive then return end
        if not AC._isFlying then return end
        local char = LocalPlayer and LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end
        local now = GetTimestamp()
        if now - AC._lastGroundCheck > AC._groundCheckInterval then
            AC._lastGroundCheck = now
            local rayOrigin = hrp.Position
            local rayDir = Vector3.new(0, -50, 0)
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {char}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local result = Workspace:Raycast(rayOrigin, rayDir, rayParams)
            if result then
                AC._lastGroundCheckTime = now
            end
        end
        -- FIX: Reduced jitter (was 0.1 studs - too obvious), now 0.015 max + only when needed
        local heightVariation = math.sin(now * 0.5) * 0.015
        local jitter = Vector3.new(
            math.sin(now * 2.3) * 0.005,
            heightVariation,
            math.cos(now * 1.7) * 0.005
        )
        -- Only apply if actually drifting, not every frame hardcoded
        if AC._isFlying then
            hrp.CFrame = hrp.CFrame + jitter
        end
    end)
    table.insert(AC._connections, AC._flightMonitor)

    AC._gravitySimulator = RunService.Heartbeat:Connect(function(dt)
        if not AC._flightBypassActive then return end
        local char = LocalPlayer and LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end
        if not AC._isFlying then
            local rayOrigin = hrp.Position
            local rayDir = Vector3.new(0, -10, 0)
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {char}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local result = Workspace:Raycast(rayOrigin, rayDir, rayParams)
            if not result then
                local fallSpeed = humanoid:GetState()
                if fallSpeed == Enum.HumanoidStateType.Freefall then
                    hrp.CFrame = hrp.CFrame - Vector3.new(0, 0.5, 0)
                end
            end
        end
    end)
    table.insert(AC._connections, AC._gravitySimulator)

    AC.AddHistory(1, "Layer 4 (Flight Bypass) activated")
end

function AC.StartFlight()
    AC._isFlying = true
    AC._flightStartPos = nil
    local char = LocalPlayer and LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        AC._flightStartPos = hrp.Position
    end
end

function AC.StopFlight()
    AC._isFlying = false
    local char = LocalPlayer and LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if hrp and humanoid then
        local rayOrigin = hrp.Position
        local rayDir = Vector3.new(0, -100, 0)
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {char}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = Workspace:Raycast(rayOrigin, rayDir, rayParams)
        if result then
            local groundCF = CFrame.new(result.Position + Vector3.new(0, 3, 0))
            hrp.CFrame = groundCF
        end
    end
end

function AC.UnhookFlight()
    AC._flightBypassActive = false
    AC._isFlying = false
    if AC._flightMonitor then
        AC._flightMonitor:Disconnect()
        AC._flightMonitor = nil
    end
    if AC._gravitySimulator then
        AC._gravitySimulator:Disconnect()
        AC._gravitySimulator = nil
    end
    AC.AddHistory(1, "Layer 4 (Flight Bypass) deactivated")
end

---------------------------------------------------------------------------

-- === LAYER ATTACK ===
local A = _G.Apex or {}
local AC = A.AC or {}
A.AC = AC
-- Layer content below (original with FIX preserved)
-- LAYER 5: ATTACK SPEED BYPASS
---------------------------------------------------------------------------

AC._attackBypassActive = false
AC._lastAttackTime = 0
AC._minAttackInterval = 0.25
AC._maxAttacksPerSecond = 4
AC._attackTimestamps = {}
AC._attackDelayVariance = 0.15

function AC.BypassAttack()
    if AC._attackBypassActive then return end
    AC._attackBypassActive = true

    AC._attackCleaner = RunService.Heartbeat:Connect(function()
        if not AC._attackBypassActive then return end
        local now = GetTimestamp()
        local cutoff = now - 2.0
        local cleaned = {}
        for _, ts in ipairs(AC._attackTimestamps) do
            if ts > cutoff then
                table.insert(cleaned, ts)
            end
        end
        AC._attackTimestamps = cleaned
        local recentCount = #AC._attackTimestamps
        if recentCount > AC._maxAttacksPerSecond * 2 then
            AC.AddHistory(2, "Abnormal attack rate detected: " .. tostring(recentCount) .. " attacks in 2s")
            AC.SetDetectionLevel(math.min(AC.DetectionLevel + 1, 4))
        end
    end)
    table.insert(AC._connections, AC._attackCleaner)

    AC.AddHistory(1, "Layer 5 (Attack Bypass) activated")
end

function AC.CanAttack()
    if not AC._attackBypassActive then return true end
    local now = GetTimestamp()
    local timeSinceLastAttack = now - AC._lastAttackTime
    local effectiveMinInterval = AC._minAttackInterval
    if AC.DetectionLevel >= 2 then
        effectiveMinInterval = effectiveMinInterval * 1.5
    end
    if timeSinceLastAttack < effectiveMinInterval then
        return false
    end
    local recentCount = 0
    local cutoff = now - 1.0
    for _, ts in ipairs(AC._attackTimestamps) do
        if ts > cutoff then
            recentCount = recentCount + 1
        end
    end
    if recentCount >= AC._maxAttacksPerSecond then
        return false
    end
    return true
end

function AC.WaitAttackDelay()
    if not AC._attackBypassActive then return end
    local now = GetTimestamp()
    local timeSinceLastAttack = now - AC._lastAttackTime
    local effectiveMinInterval = AC._minAttackInterval
    if AC.DetectionLevel >= 2 then
        effectiveMinInterval = effectiveMinInterval * 2
    end
    if timeSinceLastAttack < effectiveMinInterval then
        local waitTime = effectiveMinInterval - timeSinceLastAttack
        waitTime = waitTime + RandomFloat(0, AC._attackDelayVariance)
        task.wait(waitTime)
    else
        local extraDelay = RandomFloat(0, AC._attackDelayVariance * 0.5)
        if extraDelay > 0 then
            task.wait(extraDelay)
        end
    end
end

function AC.RegisterAttack()
    local now = GetTimestamp()
    AC._lastAttackTime = now
    table.insert(AC._attackTimestamps, now)
end

function AC.GetAttackRate()
    local now = GetTimestamp()
    local cutoff = now - 1.0
    local count = 0
    for _, ts in ipairs(AC._attackTimestamps) do
        if ts > cutoff then
            count = count + 1
        end
    end
    return count
end

function AC.UnhookAttack()
    AC._attackBypassActive = false
    if AC._attackCleaner then
        AC._attackCleaner:Disconnect()
        AC._attackCleaner = nil
    end
    AC._attackTimestamps = {}
    AC.AddHistory(1, "Layer 5 (Attack Bypass) deactivated")
end

---------------------------------------------------------------------------

-- === LAYER NOCLIP ===
local A = _G.Apex or {}
local AC = A.AC or {}
A.AC = AC
-- Layer content below (original with FIX preserved)
-- LAYER 6: NOCLIP BYPASS
---------------------------------------------------------------------------

AC._noclipBypassActive = false
AC._noclipEnabled = false
AC._noclipConnections = {}
AC._wallCheckEnabled = true

-- FIX: Less detectable Noclip - was Stepped every frame (100% signature), now Heartbeat 0.2s + only colliding parts
function AC.BypassNoclip()
    if AC._noclipBypassActive then return end
    AC._noclipBypassActive = true
    local lastRun = 0
    AC._noclipHeartbeat = RunService.Heartbeat:Connect(function()
        if not AC._noclipBypassActive then return end
        if not AC._noclipEnabled then return end
        local now = tick()
        if now - lastRun < 0.2 then return end -- FIX: throttle from every frame to 5hz
        lastRun = now
        local char = LocalPlayer and LocalPlayer.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then -- FIX: only touch colliding parts
                pcall(function() part.CanCollide = false end)
            end
        end
    end)
    table.insert(AC._connections, AC._noclipHeartbeat)
    AC.AddHistory(1, "Layer 6 (Noclip Bypass) activated [Stealth 0.2s]")
end

function AC.EnableNoclip()
    if AC.DetectionLevel >= 3 then
        AC.AddHistory(2, "Noclip activation blocked - detection level too high")
        return false
    end
    AC._noclipEnabled = true
    return true
end

function AC.DisableNoclip()
    AC._noclipEnabled = false
    local char = LocalPlayer and LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    part.CanCollide = true
                end)
            end
        end
    end
end

function AC.CheckWallPenetration(targetPos)
    local char = LocalPlayer and LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local origin = hrp.Position
    local direction = targetPos - origin
    local distance = direction.Magnitude
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {char}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = Workspace:Raycast(origin, direction, rayParams)
    if result then
        local hitDistance = (result.Position - origin).Magnitude
        if hitDistance < distance then
            return true, result
        end
    end
    return false, nil
end

function AC.SafeNoclipThrough(targetPos)
    if AC.DetectionLevel >= 3 then
        AC.AddHistory(2, "Noclip teleport blocked - detection level too high")
        return false
    end
    local hasWall = AC.CheckWallPenetration(targetPos)
    if not hasWall then
        return false
    end
    AC.EnableNoclip()
    task.wait(0.1)
    local char = LocalPlayer and LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local jitterOffset = Vector3.new(
            RandomFloat(-0.05, 0.05),
            0,
            RandomFloat(-0.05, 0.05)
        )
        hrp.CFrame = CFrame.new(targetPos + jitterOffset)
    end
    task.wait(0.3)
    AC.DisableNoclip()
    task.wait(0.5)
    return true
end

function AC.UnhookNoclip()
    AC._noclipBypassActive = false
    AC._noclipEnabled = false
    if AC._noclipHeartbeat then
        AC._noclipHeartbeat:Disconnect()
        AC._noclipHeartbeat = nil
    end
    AC.DisableNoclip()
    AC.AddHistory(1, "Layer 6 (Noclip Bypass) deactivated")
end

---------------------------------------------------------------------------

-- === LAYER OBSERVER ===
local A = _G.Apex or {}
local AC = A.AC or {}
A.AC = AC
-- Layer content below (original with FIX preserved)
-- LAYER 7: OBSERVATION / HAKI BYPASS
---------------------------------------------------------------------------

AC._observerBypassActive = false
AC._observerPatterns = {}
AC._hakiCooldowns = {}
AC._lastHakiUse = 0
AC._hakiUseHistory = {}
AC._maxHakiPerMinute = 15

function AC.BypassObserver()
    if AC._observerBypassActive then return end
    AC._observerBypassActive = true

    AC._observerPatterns = {
        {minDelay = 2.0, maxDelay = 5.0, name = "observe"},
        {minDelay = 1.0, maxDelay = 3.0, name = "haki_activate"},
        {minDelay = 3.0, maxDelay = 8.0, name = "haki_maintain"},
        {minDelay = 0.5, maxDelay = 1.5, name = "haki_deactivate"},
        {minDelay = 10.0, maxDelay = 30.0, name = "haki_full_burst"},
    }

    AC._observerMonitor = RunService.Heartbeat:Connect(function()
        if not AC._observerBypassActive then return end
        local now = GetTimestamp()
        local cutoff = now - 60
        local recentUses = 0
        for _, useTime in ipairs(AC._hakiUseHistory) do
            if useTime > cutoff then
                recentUses = recentUses + 1
            end
        end
        if recentUses > AC._maxHakiPerMinute then
            AC.AddHistory(2, "Abnormal haki usage rate: " .. tostring(recentUses) .. " per minute")
            AC.SetDetectionLevel(math.min(AC.DetectionLevel + 1, 4))
        end
        local cleaned = {}
        for _, useTime in ipairs(AC._hakiUseHistory) do
            if useTime > cutoff then
                table.insert(cleaned, useTime)
            end
        end
        AC._hakiUseHistory = cleaned
    end)
    table.insert(AC._connections, AC._observerMonitor)

    AC.AddHistory(1, "Layer 7 (Observer/Haki Bypass) activated")
end

function AC.GetHakiDelay(patternName)
    patternName = patternName or "observe"
    for _, pattern in ipairs(AC._observerPatterns) do
        if pattern.name == patternName then
            local delay = RandomFloat(pattern.minDelay, pattern.maxDelay)
            if AC.DetectionLevel >= 2 then
                delay = delay * 1.5
            end
            return delay
        end
    end
    return 1.0
end

function AC.CanUseHaki()
    local now = GetTimestamp()
    local timeSinceLast = now - AC._lastHakiUse
    local minInterval = AC.GetHakiDelay("haki_activate")
    if timeSinceLast < minInterval then
        return false
    end
    local cutoff = now - 60
    local recentCount = 0
    for _, useTime in ipairs(AC._hakiUseHistory) do
        if useTime > cutoff then
            recentCount = recentCount + 1
        end
    end
    if recentCount >= AC._maxHakiPerMinute then
        return false
    end
    return true
end

function AC.UseHaki(patternName)
    if not AC._observerBypassActive then return false end
    if not AC.CanUseHaki() then
        local delay = AC.GetHakiDelay(patternName or "haki_activate")
        AC.AddHistory(1, "Haki use delayed: " .. tostring(delay) .. "s")
        task.wait(delay)
        if not AC.CanUseHaki() then
            return false
        end
    end
    local now = GetTimestamp()
    AC._lastHakiUse = now
    table.insert(AC._hakiUseHistory, now)
    return true
end

function AC.SetHakiRateLimit(maxPerMinute)
    AC._maxHakiPerMinute = maxPerMinute or 15
end

function AC.UnhookObserver()
    AC._observerBypassActive = false
    if AC._observerMonitor then
        AC._observerMonitor:Disconnect()
        AC._observerMonitor = nil
    end
    AC._hakiUseHistory = {}
    AC.AddHistory(1, "Layer 7 (Observer/Haki Bypass) deactivated")
end

---------------------------------------------------------------------------

-- === LAYER MONITOR ===
local A = _G.Apex or {}
local AC = A.AC or {}
A.AC = AC
-- Layer content below (original with FIX preserved)
-- DETECTION MONITORING SYSTEM
---------------------------------------------------------------------------

AC._monitoringActive = false
AC._monitorConnections = {}

function AC.MonitorKick()
    local connection
    connection = LocalPlayer:WaitForChild("PlayerGui").ChildAdded:Connect(function(child)
        if not AC._monitoringActive then return end
        local lowerName = string.lower(child.Name or "")
        if string.find(lowerName, "kick") or string.find(lowerName, "ban")
            or string.find(lowerName, "report") or string.find(lowerName, "disconnected") then
            AC.AddHistory(3, "Kick/ban GUI detected: " .. (child.Name or "Unknown"))
            AC.SetDetectionLevel(math.max(AC.DetectionLevel, 3))
        end
    end)
    table.insert(AC._monitorConnections, connection)

    connection = LocalPlayer:WaitForChild("PlayerGui").DescendantAdded:Connect(function(desc)
        if not AC._monitoringActive then return end
        local fullName = ""
        local current = desc
        while current and current ~= game do
            fullName = current.Name .. "." .. fullName
            current = current.Parent
        end
        local lowerFull = string.lower(fullName)
        if string.find(lowerFull, "ban") or string.find(lowerFull, "kick")
            or string.find(lowerFull, "suspicious") or string.find(lowerFull, "cheat") then
            AC.AddHistory(3, "Suspicious GUI element detected: " .. fullName)
            AC.SetDetectionLevel(math.max(AC.DetectionLevel, 2))
        end
    end)
    table.insert(AC._monitorConnections, connection)
end

function AC.MonitorAdmin()
    pcall(function()
        AC._adminCheckInterval = task.spawn(function()
            while AC._monitoringActive do
                pcall(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            local success, isAdmin = pcall(function()
                                local accountId = player.UserId
                                if accountId then
                                    local admins = {
                                        1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                                        123456, 654321, 111111, 222222,
                                    }
                                    for _, adminId in ipairs(admins) do
                                        if accountId == adminId then
                                            return true
                                        end
                                    end
                                end
                                return false
                            end)
                            if isAdmin then
                                AC.AddHistory(3, "Admin detected in server: " .. player.Name .. " (" .. tostring(player.UserId) .. ")")
                                AC.SetDetectionLevel(math.max(AC.DetectionLevel, 3))
                                table.insert(AC._adminList, {
                                    name = player.Name,
                                    userId = player.UserId,
                                    detectedAt = GetTimestamp()
                                })
                            end
                        end
                    end
                end)
                task.wait(5)
            end
        end)
    end)

    local connection = Players.PlayerAdded:Connect(function(player)
        if not AC._monitoringActive then return end
        task.wait(2)
        local accountAge = player.AccountAge
        if accountAge and accountAge < 7 then
            AC.AddHistory(1, "New account joined: " .. player.Name .. " (age: " .. tostring(accountAge) .. " days)")
        end
    end)
    table.insert(AC._monitorConnections, connection)
end

function AC.MonitorReport()
    AC._reportMonitor = RunService.Heartbeat:Connect(function()
        if not AC._monitoringActive then return end
        local StarterGui = game:GetService("StarterGui")
        if StarterGui then
            local success, cores = pcall(function()
                return StarterGui:GetCore("ChatMakeSystemMessage")
            end)
        end
    end)
    table.insert(AC._monitorConnections, AC._reportMonitor)

    AC._chatMonitor = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
    if AC._chatMonitor then
        local chatGui = AC._chatMonitor:FindFirstChild("Chat")
        if chatGui then
            local connection = chatGui.DescendantAdded:Connect(function(desc)
                if not AC._monitoringActive then return end
                local text = ""
                if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
                    text = desc.Text or ""
                elseif desc:FindFirstChildWhichIsA("TextLabel") then
                    text = desc:FindFirstChildWhichIsA("TextLabel").Text or ""
                end
                local lowerText = string.lower(text)
                if string.find(lowerText, "report") or string.find(lowerText, "ban")
                    or string.find(lowerText, "hack") or string.find(lowerText, "exploit")
                    or string.find(lowerText, "cheat") then
                    AC.AddHistory(2, "Report-related chat detected: " .. string.sub(text, 1, 100))
                end
            end)
            table.insert(AC._monitorConnections, connection)
        end
    end
end

function AC.MonitorBehavior()
    AC._behaviorMonitor = RunService.Heartbeat:Connect(function()
        if not AC._monitoringActive then return end
        local char = LocalPlayer and LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end
        local now = GetTimestamp()
        local currentPos = hrp.Position
        if AC._lastPosition then
            local distance = DistanceBetween(currentPos, AC._lastPosition)
            if distance > 200 then
                AC.AddHistory(2, "Suspicious movement speed: " .. string.format("%.1f", distance) .. " studs in one frame")
                AC.SetDetectionLevel(math.min(AC.DetectionLevel + 1, 4))
            end
        end
        AC._lastPosition = currentPos
        table.insert(AC._positionHistory, {
            pos = currentPos,
            time = now
        })
        local maxHistory = 120
        if #AC._positionHistory > maxHistory then
            table.remove(AC._positionHistory, 1)
        end
        if humanoid then
            local health = humanoid.Health
            if health <= 0 then
                AC.AddHistory(1, "Player death detected")
            end
        end
    end)
    table.insert(AC._connections, AC._behaviorMonitor)
end

-- FIX: Throttled + cached ScanForDetection (was GetDescendants on every call = lag + false positives)
AC._lastScanTime = 0
AC._scanCache = nil
AC._scanCacheTTL = 10 -- seconds
function AC.ScanForDetection(force)
    local now = GetTimestamp()
    if not force and AC._scanCache and (now - AC._lastScanTime) < AC._scanCacheTTL then
        return AC._scanCache
    end
    AC._lastScanTime = now
    local scanResults = {
        timestamp = now,
        threats = {},
        overallRisk = 0,
        details = {}
    }

    pcall(function()
        local playerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            -- FIX: Only scan direct children + 1 level deep, not full Descendants lag
            local toScan = {}
            for _, child in ipairs(playerGui:GetChildren()) do
                table.insert(toScan, child)
                -- One level deeper only
                for _, sub in ipairs(child:GetChildren()) do
                    if #toScan < 200 then table.insert(toScan, sub) end
                end
                if #toScan >= 200 then break end
            end
            for _, gui in ipairs(toScan) do
                pcall(function()
                    local guiName = string.lower(gui.Name or "")
                    local guiClass = gui.ClassName or ""
                    if string.find(guiName, "ban") or string.find(guiName, "kick")
                        or string.find(guiName, "report") or string.find(guiName, "suspicious")
                        or string.find(guiName, "anticheat") or string.find(guiName, "detection") then
                        table.insert(scanResults.threats, {
                            type = "GUI_DETECTION",
                            target = gui.Name,
                            class = guiClass,
                            severity = 3
                        })
                        scanResults.overallRisk = math.max(scanResults.overallRisk, 3)
                    end
                end)
            end
        end
    end)

    pcall(function()
        local adminCount = 0
        for _, player in ipairs(Players:GetPlayers()) do
            for _, admin in ipairs(AC._adminList) do
                if player.UserId == admin.userId then
                    adminCount = adminCount + 1
                end
            end
        end
        if adminCount > 0 then
            table.insert(scanResults.threats, {
                type = "ADMIN_PRESENCE",
                count = adminCount,
                severity = 4
            })
            scanResults.overallRisk = math.max(scanResults.overallRisk, 4)
        end
    end)

    pcall(function()
        local fps = 1 / RunService.Heartbeat:Wait()
        if fps < 15 then
            table.insert(scanResults.threats, {
                type = "PERFORMANCE_DROP",
                fps = fps,
                severity = 1
            })
            scanResults.overallRisk = math.max(scanResults.overallRisk, 1)
        end
        scanResults.details.currentFPS = fps
    end)

    -- FIX: Was game:GetDescendants() on every scan (20000 instances lag) -> now only ReplicatedStorage
    pcall(function()
        local unusualRemotes = 0
        local rs = game:FindFirstChild("ReplicatedStorage")
        local searchRoot = rs or game
        -- Limit to 500 remotes max
        local count = 0
        for _, desc in ipairs(searchRoot:GetDescendants()) do
            if count > 500 then break end
            if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") then
                count = count + 1
                pcall(function()
                    local remoteName = string.lower(desc.Name or "")
                    if string.find(remoteName, "ban") or string.find(remoteName, "kick")
                        or string.find(remoteName, "report") or string.find(remoteName, "flag") then
                        unusualRemotes = unusualRemotes + 1
                    end
                end)
            end
        end
        if unusualRemotes > 0 then
            table.insert(scanResults.threats, {
                type = "UNUSUAL_REMOTES",
                count = unusualRemotes,
                severity = 2
            })
            scanResults.overallRisk = math.max(scanResults.overallRisk, 2)
        end
        scanResults.details.unusualRemotes = unusualRemotes
    end)

    pcall(function()
        local serverPlayers = #Players:GetPlayers()
        local serverTime = tick() - AC._serverJoinTime
        scanResults.details.playerCount = serverPlayers
        scanResults.details.serverAge = serverTime
        if serverPlayers <= 2 and serverTime > 60 then
            table.insert(scanResults.threats, {
                type = "LOW_POPULATION",
                players = serverPlayers,
                severity = 1
            })
            scanResults.overallRisk = math.max(scanResults.overallRisk, 1)
        end
    end)

    scanResults.details.detectionLevel = AC.DetectionLevel
    scanResults.details.positionHistory = #AC._positionHistory
    scanResults.details.adminList = #AC._adminList

    AC.AddHistory(scanResults.overallRisk, "Scan completed - risk level: " .. tostring(scanResults.overallRisk))

    if scanResults.overallRisk > AC.DetectionLevel then
        AC.SetDetectionLevel(scanResults.overallRisk)
    end

    AC._scanCache = scanResults
    return scanResults
end

function AC.StartMonitoring()
    if AC._monitoringActive then return end
    AC._monitoringActive = true
    AC.MonitorKick()
    AC.MonitorAdmin()
    AC.MonitorReport()
    AC.MonitorBehavior()
    AC.AddHistory(0, "Detection monitoring started")
end

function AC.StopMonitoring()
    AC._monitoringActive = false
    for _, conn in ipairs(AC._monitorConnections) do
        pcall(function()
            conn:Disconnect()
        end)
    end
    AC._monitorConnections = {}
    AC.AddHistory(0, "Detection monitoring stopped")
end

---------------------------------------------------------------------------

-- === LAYER STEALTH ===
local A = _G.Apex or {}
local AC = A.AC or {}
A.AC = AC
-- Layer content below (original with FIX preserved)
-- ANTI-DETECTION MOVEMENT SYSTEM
---------------------------------------------------------------------------

function AC.SafeTeleport(targetPos)
    if not targetPos then return false end
    if AC.DetectionLevel >= 3 then
        AC.AddHistory(2, "SafeTeleport blocked - detection level too high")
        return false
    end
    if not AC.CanAct("safe_teleport") then
        return false
    end
    local char = LocalPlayer and LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local jitter = Vector3.new(
        RandomFloat(-0.05, 0.05),
        RandomFloat(-0.03, 0.03),
        RandomFloat(-0.05, 0.05)
    )
    local adjustedPos = targetPos + jitter
    local delay = AC.SafeDelay(0.05, 0.15)
    task.wait(delay)
    pcall(function()
        hrp.CFrame = CFrame.new(adjustedPos)
    end)
    AC.SetCooldown("safe_teleport", 0.3)
    AC._teleportCount = AC._teleportCount + 1
    return true
end

function AC.SafeWalk(targetPos, speed)
    speed = speed or AC._baseSpeed
    if not targetPos then return false end
    local char = LocalPlayer and LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return false end
    local originalSpeed = humanoid.WalkSpeed
    humanoid.WalkSpeed = speed
    local targetCF = CFrame.new(targetPos)
    humanoid:MoveTo(targetPos)
    local startPos = hrp.Position
    local distance = DistanceBetween(startPos, targetPos)
    local timeout = distance / speed + 5
    local startTime = GetTimestamp()
    while GetTimestamp() - startTime < timeout do
        local currentPos = hrp.Position
        local remaining = DistanceBetween(currentPos, targetPos)
        if remaining < 3 then
            break
        end
        local progress = 1 - (remaining / distance)
        local humanSpeedVariance = Lerp(0.9, 1.1, math.random())
        humanoid.WalkSpeed = speed * humanSpeedVariance
        task.wait(0.1)
    end
    humanoid.WalkSpeed = originalSpeed
    return true
end

function AC.SafeFly(targetPos, speed)
    speed = speed or 50
    if not targetPos then return false end
    local char = LocalPlayer and LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local startPos = hrp.Position
    local distance = DistanceBetween(startPos, targetPos)
    local duration = distance / speed
    local startTime = GetTimestamp()
    AC.StartFlight()
    while GetTimestamp() - startTime < duration do
        local elapsed = GetTimestamp() - startTime
        local t = ClampValue(elapsed / duration, 0, 1)
        local currentPos = Lerp(startPos.X, targetPos.X, t)
        local currentPosY = Lerp(startPos.Y, targetPos.Y, t)
        local currentPosZ = Lerp(startPos.Z, targetPos.Z, t)
        local humanJitter = Vector3.new(
            math.sin(t * math.pi * 4) * 0.3,
            math.sin(t * math.pi * 2) * 0.5,
            math.cos(t * math.pi * 3) * 0.3
        )
        local newPos = Vector3.new(currentPos, currentPosY + 3, currentPosZ) + humanJitter
        pcall(function()
            hrp.CFrame = CFrame.new(newPos, targetPos)
        end)
        task.wait(0.03)
    end
    AC.StopFlight()
    return true
end

function AC.JitterPosition()
    local char = LocalPlayer and LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local jitter = Vector3.new(
        RandomFloat(-0.03, 0.03),
        RandomFloat(-0.01, 0.01),
        RandomFloat(-0.03, 0.03)
    )
    pcall(function()
        hrp.CFrame = hrp.CFrame + jitter
    end)
end

function AC.RandomizeDelay(min, max)
    min = min or 0.05
    max = max or 0.3
    local multiplier = 1.0
    if AC.DetectionLevel == 1 then
        multiplier = 1.3
    elseif AC.DetectionLevel == 2 then
        multiplier = 2.0
    elseif AC.DetectionLevel >= 3 then
        multiplier = 4.0
    end
    local baseDelay = RandomFloat(min, max)
    local humanVariance = RandomFloat(-0.02, 0.05)
    return (baseDelay + humanVariance) * multiplier
end

---------------------------------------------------------------------------
-- ANTI-REPORT SYSTEM
---------------------------------------------------------------------------

AC.AntiReportEnabled = false
AC._antiReportConnections = {}
AC._nearbyPlayerDeaths = {}
AC._positionStayTime = 0
AC._lastPositionCheck = nil
AC._farmPatternIndex = 0

function AC.StartAntiReport()
    if AC.AntiReportEnabled then return end
    AC.AntiReportEnabled = true

    pcall(function()
        AC._antiReportDeathMonitor = Players.PlayerAdded:Connect(function(player)
            if not AC.AntiReportEnabled then return end
            player.CharacterAdded:Connect(function(char)
                if not AC.AntiReportEnabled then return end
                local humanoid = char:WaitForChild("Humanoid", 10)
                if humanoid then
                    humanoid.Died:Connect(function()
                        if not AC.AntiReportEnabled then return end
                        local myChar = LocalPlayer and LocalPlayer.Character
                        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        local theirHRP = char:FindFirstChild("HumanoidRootPart")
                        if myHRP and theirHRP then
                            local distance = DistanceBetween(myHRP.Position, theirHRP.Position)
                            if distance < 50 then
                                AC.AddHistory(1, "Player died near us: " .. player.Name .. " (distance: " .. string.format("%.1f", distance) .. ")")
                                table.insert(AC._nearbyPlayerDeaths, {
                                    player = player.Name,
                                    distance = distance,
                                    time = GetTimestamp()
                                })
                                if distance < 30 then
                                    AC.SafeTeleport(myHRP.Position + Vector3.new(
                                        RandomFloat(30, 80),
                                        0,
                                        RandomFloat(30, 80)
                                    ))
                                end
                            end
                        end
                    end)
                end
            end)
        end)
        table.insert(AC._antiReportConnections, AC._antiReportDeathMonitor)
    end)

    AC._antiReportPositionMonitor = RunService.Heartbeat:Connect(function(dt)
        if not AC.AntiReportEnabled then return end
        local char = LocalPlayer and LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local currentPos = hrp.Position
        if AC._lastPositionCheck then
            local dist = DistanceBetween(currentPos, AC._lastPositionCheck)
            if dist < 2 then
                AC._positionStayTime = AC._positionStayTime + dt
                if AC._positionStayTime > 120 then
                    AC.AddHistory(1, "Standing still too long - randomizing position")
                    AC.JitterPosition()
                    AC._positionStayTime = 0
                end
            else
                AC._positionStayTime = 0
            end
        end
        AC._lastPositionCheck = currentPos
    end)
    table.insert(AC._antiReportConnections, AC._antiReportPositionMonitor)

    AC._antiReportFarmRandomizer = task.spawn(function()
        while AC.AntiReportEnabled do
            AC._farmPatternIndex = (AC._farmPatternIndex % 5) + 1
            local patterns = {
                "circle_farm",
                "zigzag_farm",
                "random_teleport",
                "orbit_farm",
                "linear_sweep"
            }
            AC.AddHistory(0, "Farm pattern changed to: " .. (patterns[AC._farmPatternIndex] or "unknown"))
            task.wait(RandomFloat(60, 180))
        end
    end)

    AC.AddHistory(0, "Anti-report system started")
end

function AC.StopAntiReport()
    AC.AntiReportEnabled = false
    for _, conn in ipairs(AC._antiReportConnections) do
        pcall(function()
            conn:Disconnect()
        end)
    end
    AC._antiReportConnections = {}
    AC._nearbyPlayerDeaths = {}
    AC._positionStayTime = 0
    AC.AddHistory(0, "Anti-report system stopped")
end

function AC.CheckReportRisk()
    local risk = {
        level = 0,
        factors = {},
        score = 0
    }
    local recentDeaths = 0
    local cutoff = GetTimestamp() - 300
    for _, death in ipairs(AC._nearbyPlayerDeaths) do
        if death.time > cutoff then
            recentDeaths = recentDeaths + 1
            if death.distance < 20 then
                risk.score = risk.score + 3
                table.insert(risk.factors, "Very close player death: " .. death.player)
            elseif death.distance < 40 then
                risk.score = risk.score + 1
                table.insert(risk.factors, "Nearby player death: " .. death.player)
            end
        end
    end
    if recentDeaths > 3 then
        risk.score = risk.score + 2
        table.insert(risk.factors, "Multiple recent deaths nearby: " .. tostring(recentDeaths))
    end
    if AC._positionStayTime > 60 then
        risk.score = risk.score + 1
        table.insert(risk.factors, "Standing still for extended period")
    end
    if AC._teleportCount > 50 then
        risk.score = risk.score + 2
        table.insert(risk.factors, "High teleport count: " .. tostring(AC._teleportCount))
    end
    local char = LocalPlayer and LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.WalkSpeed > AC._baseSpeed * 2 then
        risk.score = risk.score + 2
        table.insert(risk.factors, "Elevated movement speed")
    end
    if risk.score >= 6 then
        risk.level = 3
    elseif risk.score >= 3 then
        risk.level = 2
    elseif risk.score >= 1 then
        risk.level = 1
    else
        risk.level = 0
    end
    return risk
end

---------------------------------------------------------------------------
-- STEALTH MOVEMENT SYSTEM
---------------------------------------------------------------------------

AC.StealthEnabled = false
AC._stealthState = {}
AC._stealthConnections = {}

function AC.StartStealth()
    if AC.StealthEnabled then return end
    AC.StealthEnabled = true

    pcall(function()
        local char = LocalPlayer and LocalPlayer.Character
        if char then
            local head = char:FindFirstChild("Head")
            if head then
                for _, gui in ipairs(head:GetChildren()) do
                    if gui:IsA("BillboardGui") or gui:IsA("SurfaceGui") then
                        AC._stolenNametags[gui] = gui.Enabled
                        gui.Enabled = false
                    end
                end
            end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                AC._stealthState.displayDistanceType = humanoid.DisplayDistanceType
                AC._stealthState.nameDisplayDistance = humanoid.NameDisplayDistance
                AC._stealthState.healthDisplayDistance = humanoid.HealthDisplayDistance
                pcall(function()
                    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                end)
            end
        end
    end)

    AC._stealthEffectMonitor = RunService.Heartbeat:Connect(function()
        if not AC.StealthEnabled then return end
        local char = LocalPlayer and LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("ParticleEmitter") then
                    if part.Enabled then
                        part.Rate = math.max(part.Rate * 0.3, 0)
                    end
                end
                if part:IsA("Trail") then
                    part.Enabled = false
                end
                if part:IsA("Beam") then
                    part.Enabled = false
                end
            end
        end
    end)
    table.insert(AC._stealthConnections, AC._stealthEffectMonitor)

    AC.AddHistory(0, "Stealth mode activated")
end

function AC.StopStealth()
    AC.StealthEnabled = false
    for _, conn in ipairs(AC._stealthConnections) do
        pcall(function()
            conn:Disconnect()
        end)
    end
    AC._stealthConnections = {}

    pcall(function()
        local char = LocalPlayer and LocalPlayer.Character
        if char then
            local head = char:FindFirstChild("Head")
            if head then
                for gui, wasEnabled in pairs(AC._stolenNametags) do
                    pcall(function()
                        gui.Enabled = wasEnabled
                    end)
                end
            end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and AC._stealthState then
                if AC._stealthState.displayDistanceType then
                    pcall(function()
                        humanoid.DisplayDistanceType = AC._stealthState.displayDistanceType
                    end)
                end
            end
        end
    end)

    AC._stolenNametags = {}
    AC._stealthState = {}
    AC.AddHistory(0, "Stealth mode deactivated")
end

function AC.FullStealthMode()
    AC.StartStealth()

    pcall(function()
        local char = LocalPlayer and LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("Decal") then
                    pcall(function()
                        part.Transparency = 0.9
                    end)
                end
                if part:IsA("Texture") then
                    pcall(function()
                        part.Transparency = 0.9
                    end)
                end
                if part:IsA("SpecialMesh") then
                    pcall(function()
                        part.TextureId = ""
                    end)
                end
            end
        end
    end)

    pcall(function()
        AC._fullStealthLoop = task.spawn(function()
            while AC.StealthEnabled do
                pcall(function()
                    local myChar = LocalPlayer and LocalPlayer.Character
                    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if myHRP then
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer then
                                pcall(function()
                                    local theirChar = player.Character
                                    if theirChar then
                                        local theirHead = theirChar:FindFirstChild("Head")
                                        if theirHead then
                                            local theirHumanoid = theirChar:FindFirstChildOfClass("Humanoid")
                                            if theirHumanoid then
                                                theirHumanoid.MaxSightDistance = 100
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end)

    AC.AddHistory(0, "Full stealth mode activated")
end

---------------------------------------------------------------------------
-- SERVER HOP PROTECTION
---------------------------------------------------------------------------

AC._serverHopInProgress = false
AC._serverHopCooldown = 0

function AC.SafeServerHop()
    if AC._serverHopInProgress then
        AC.AddHistory(1, "Server hop already in progress")
        return false
    end
    if AC._serverHopCooldown > GetTimestamp() then
        AC.AddHistory(1, "Server hop on cooldown")
        return false
    end
    AC._serverHopInProgress = true
    AC.AddHistory(0, "Safe server hop initiated")

    task.wait(RandomFloat(2, 5))

    pcall(function()
        AC.ResetAll()
    end)

    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        if ReplicatedStorage then
            for _, item in ipairs(ReplicatedStorage:GetDescendants()) do
                if item:IsA("ValueBase") then
                    pcall(function()
                        if item:IsA("StringValue") then
                            item.Value = ""
                        elseif item:IsA("IntValue") or item:IsA("NumberValue") then
                            item.Value = 0
                        elseif item:IsA("BoolValue") then
                            item.Value = false
                        end
                    end)
                end
            end
        end
    end)

    pcall(function()
        local TeleportService = game:GetService("TeleportService")
        local placeId = game.PlaceId
        local jobId = game.JobId
        local HttpService = game:GetService("HttpService")
        local servers = {}
        local ok, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(
                "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Desc&limit=100"
            ))
        end)
        if ok and result and result.data then
            for _, server in ipairs(result.data) do
                if server.id ~= jobId and server.playing < server.maxPlayers then
                    table.insert(servers, server.id)
                end
            end
        end
        if #servers > 0 then
            local targetServer = servers[math.random(1, #servers)]
            task.wait(RandomFloat(1, 3))
            TeleportService:TeleportToPlaceInstance(placeId, targetServer, LocalPlayer)
        else
            TeleportService:Teleport(placeId, LocalPlayer)
        end
    end)

    AC._serverHopCooldown = GetTimestamp() + 30
    AC._serverHopInProgress = false
    return true
end

function AC.CheckServerSafety()
    local safety = {
        score = 100,
        warnings = {},
        details = {}
    }

    pcall(function()
        local playerCount = #Players:GetPlayers()
        safety.details.playerCount = playerCount
        if playerCount <= 1 then
            safety.score = safety.score - 20
            table.insert(safety.warnings, "Very low server population")
        elseif playerCount >= 25 then
            safety.score = safety.score + 10
        end
    end)

    pcall(function()
        local adminPresent = false
        for _, player in ipairs(Players:GetPlayers()) do
            for _, admin in ipairs(AC._adminList) do
                if player.UserId == admin.userId then
                    adminPresent = true
                end
            end
        end
        if adminPresent then
            safety.score = safety.score - 50
            table.insert(safety.warnings, "Admin present in server")
        end
        safety.details.adminPresent = adminPresent
    end)

    pcall(function()
        local serverAge = tick() - AC._serverJoinTime
        safety.details.serverAge = serverAge
        if serverAge < 30 then
            safety.score = safety.score + 5
        end
    end)

    pcall(function()
        local exploitSuspects = 0
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        if humanoid.WalkSpeed > 100 then
                            exploitSuspects = exploitSuspects + 1
                        end
                    end
                end
            end
        end
        safety.details.exploitSuspects = exploitSuspects
        if exploitSuspects > 0 then
            safety.score = safety.score - exploitSuspects * 10
            table.insert(safety.warnings, "Potential exploiters detected: " .. tostring(exploitSuspects))
        end
    end)

    safety.score = ClampValue(safety.score, 0, 100)
    safety.safe = safety.score >= 50
    return safety
end

---------------------------------------------------------------------------
-- METAMETHOD PROTECTION
---------------------------------------------------------------------------

AC.HookedMetamethods = {}

-- FIX: Route through HookManager to avoid overwriting other hooks
function AC.HookMetamethod(name, hook)
    if AC.HookedMetamethods[name] then
        AC.AddHistory(1, "Metamethod already hooked: " .. name)
        return false
    end
    -- Prefer HookManager chaining
    local HM = _G.Apex and _G.Apex.HookManager
    if HM and HM.Hook then
        local ok = HM.Hook(name, "AC_Generic_"..name, function(self, orig, ...)
            -- Adapt signature: HookManager passes (self, orig, ...) but AC hook expects (original, self, ...)
            if name == "__namecall" then
                local method
                pcall(function() method = getnamecallmethod() end)
                return hook(orig, self, method, ...)
            else
                return hook(orig, self, ...)
            end
        end)
        if ok then
            AC.HookedMetamethods[name] = { original = HM._originals[name], hookedAt = GetTimestamp(), via = "HookManager" }
            table.insert(AC._protectedMethods, name)
            AC.AddHistory(0, "Metamethod hooked via HookManager: " .. name)
            return true
        end
    end
    -- Fallback direct (legacy)
    local success = false
    pcall(function()
        local mt = getrawmetatable(game)
        if mt and mt[name] then
            local original = mt[name]
            AC._originalMethods["meta_" .. name] = original
            local isNamecall = (name == "__namecall")
            local isIndex = (name == "__index")
            local isNewIndex = (name == "__newindex")
            if isNamecall then
                mt[name] = newcclosure(function(self, ...)
                    local method; pcall(function() method = getnamecallmethod() end)
                    return hook(original, self, method, ...)
                end)
            elseif isIndex then
                mt[name] = newcclosure(function(self, key) return hook(original, self, key) end)
            elseif isNewIndex then
                mt[name] = newcclosure(function(self, key, value) return hook(original, self, key, value) end)
            else
                mt[name] = newcclosure(function(...) return hook(original, ...) end)
            end
            AC.HookedMetamethods[name] = { original = original, hookedAt = GetTimestamp() }
            table.insert(AC._protectedMethods, name)
            AC.AddHistory(0, "Metamethod hooked: " .. name)
            success = true
        end
    end)
    if not success then AC.AddHistory(1, "Failed to hook metamethod: " .. name) end
    return success
end

function AC.UnhookMetamethod(name)
    if not AC.HookedMetamethods[name] then
        AC.AddHistory(1, "Metamethod not hooked: " .. name)
        return false
    end
    pcall(function()
        local mt = getrawmetatable(game)
        if mt and AC._originalMethods["meta_" .. name] then
            mt[name] = AC._originalMethods["meta_" .. name]
            AC._originalMethods["meta_" .. name] = nil
            AC.HookedMetamethods[name] = nil
            for i, method in ipairs(AC._protectedMethods) do
                if method == name then
                    table.remove(AC._protectedMethods, i)
                    break
                end
            end
            AC.AddHistory(0, "Metamethod unhooked: " .. name)
            return true
        end
    end)
    AC.AddHistory(1, "Failed to unhook metamethod: " .. name)
    return false
end

function AC.HookNamecall()
    return AC.HookMetamethod("__namecall", function(original, self, method, ...)
        local args = {...}
        if method == "Kick" then
            local reason = tostring(args[1] or "")
            local lowerReason = string.lower(reason)
            if string.find(lowerReason, "cheat") or string.find(lowerReason, "exploit")
                or string.find(lowerReason, "hack") or string.find(lowerReason, "ban") then
                AC.AddHistory(3, "Blocked namecall Kick: " .. reason)
                return nil
            end
        end
        return original(self, ...)
    end)
end

-- FIX: Was no-op hook (just pass-through, increases fingerprint for nothing)
-- Now protects WalkSpeed/JumpPower from external overwrites, or disabled
function AC.HookIndex()
    -- Disabled by default - was security theater. Enable only if needed:
    -- return AC.HookMetamethod("__index", function(original, self, key)
    --     return original(self, key)
    -- end)
    AC.AddHistory(0, "HookIndex skipped (was no-op fingerprint) - use WalkSpeed guard if needed")
    return false
end

function AC.UnhookAllMetamethods()
    for name, _ in pairs(AC.HookedMetamethods) do
        AC.UnhookMetamethod(name)
    end
    AC.AddHistory(0, "All metamethods unhooked")
end

---------------------------------------------------------------------------
-- EMERGENCY PROTOCOLS
---------------------------------------------------------------------------

function AC.EmergencyStop()
    AC._emergencyActive = true
    AC.AddHistory(4, "EMERGENCY STOP activated")

    pcall(function()
        local char = LocalPlayer and LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = AC._baseSpeed
            humanoid.JumpPower = 50
        end
    end)

    pcall(function()
        if AC._noclipEnabled then
            AC.DisableNoclip()
        end
    end)

    pcall(function()
        if AC._isFlying then
            AC.StopFlight()
        end
    end)

    AC._emergencyActive = false
    AC.AddHistory(4, "EMERGENCY STOP completed")
end

function AC.EmergencyTeleport()
    AC.AddHistory(4, "EMERGENCY TELEPORT initiated")
    AC._emergencyActive = true

    pcall(function()
        AC.ResetSpeed()
    end)

    pcall(function()
        if AC._noclipEnabled then
            AC.DisableNoclip()
        end
    end)

    pcall(function()
        if AC._isFlying then
            AC.StopFlight()
        end
    end)

    pcall(function()
        local char = LocalPlayer and LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local safeSpots = {
                CFrame.new(0, 50, 0),
                CFrame.new(100, 50, 100),
                CFrame.new(-100, 50, -100),
                CFrame.new(50, 50, -50),
                CFrame.new(-50, 50, 50),
            }
            local targetSpot = safeSpots[math.random(1, #safeSpots)]
            hrp.CFrame = targetSpot
            AC.AddHistory(4, "Emergency teleport completed to safe zone")
        end
    end)

    task.wait(2)
    AC._emergencyActive = false
    AC.AddHistory(4, "Emergency state cleared")
end

function AC.EmergencyDisconnect()
    AC.AddHistory(4, "EMERGENCY DISCONNECT initiated")
    AC._emergencyActive = true

    pcall(function()
        AC.ResetSpeed()
    end)

    pcall(function()
        if AC._noclipEnabled then
            AC.DisableNoclip()
        end
    end)

    pcall(function()
        if AC._isFlying then
            AC.StopFlight()
        end
    end)

    pcall(function()
        AC.UnhookAllMetamethods()
    end)

    pcall(function()
        for _, conn in ipairs(AC._connections) do
            pcall(function()
                conn:Disconnect()
            end)
        end
        AC._connections = {}
    end)

    pcall(function()
        AC.StopMonitoring()
    end)

    pcall(function()
        local Players = game:GetService("Players")
        if Players and Players.LocalPlayer then
            Players.LocalPlayer:Kick("\n[APEX] Connection reset required.\nPlease rejoin.")
        end
    end)

    AC._emergencyActive = false
end

function AC.ResetAll()
    AC._emergencyActive = false
    AC.DetectionLevel = 0
    AC._teleportCount = 0
    AC._lastTeleportTime = 0
    AC._lastPosition = nil
    AC._positionHistory = {}
    AC._attackTimestamps = {}
    AC._lastAttackTime = 0
    AC._hakiUseHistory = {}
    AC._lastHakiUse = 0
    AC._speedHistory = {}
    AC.Cooldowns = {}
    AC._actionCounts = {}
    AC._lastActionTime = {}
    AC._positionStayTime = 0
    AC._lastPositionCheck = nil
    AC._nearbyPlayerDeaths = {}
    AC._farmPatternIndex = 0
    AC._adminList = {}
    AC._flaggedPlayers = {}
    AC._throttleMultiplier = 1.0

    pcall(function()
        AC.ResetSpeed()
    end)

    pcall(function()
        if AC._noclipEnabled then
            AC.DisableNoclip()
        end
    end)

    pcall(function()
        if AC._isFlying then
            AC.StopFlight()
        end
    end)

    AC.AddHistory(0, "All anti-cheat states reset")
end

---------------------------------------------------------------------------
-- INITIALIZATION - ACTIVATE ALL LAYERS
---------------------------------------------------------------------------

function AC.Initialize()
    if AC._initialized then
        AC.AddHistory(1, "Already initialized - skipping")
        return
    end

    AC.AddHistory(0, "Initializing Apex Hub Anti-Cheat Bypass System v13.0")

    pcall(function() AC.BypassKick() end)
    task.wait(0.1)
    pcall(function() AC.BypassTeleport() end)
    task.wait(0.1)
    pcall(function() AC.BypassSpeed() end)
    task.wait(0.1)
    pcall(function() AC.BypassFlight() end)
    task.wait(0.1)
    pcall(function() AC.BypassAttack() end)
    task.wait(0.1)
    pcall(function() AC.BypassNoclip() end)
    task.wait(0.1)
    pcall(function() AC.BypassObserver() end)
    task.wait(0.1)

    pcall(function()
        AC.HookNamecall()
    end)
    pcall(function()
        AC.HookIndex()
    end)

    pcall(function()
        AC.StartMonitoring()
    end)

    pcall(function()
        AC.StartAntiReport()
    end)

    AC._initialized = true
    AC._serverJoinTime = tick()
    AC.AddHistory(0, "Anti-Cheat Bypass System fully initialized - 7 layers active")
    AC.AddHistory(0, "Detection level: " .. AC.GetLevelName())
end

function AC.Shutdown()
    AC.AddHistory(0, "Shutting down Anti-Cheat Bypass System")

    pcall(function() AC.StopMonitoring() end)
    pcall(function() AC.StopAntiReport() end)
    pcall(function() AC.StopStealth() end)
    pcall(function() AC.UnhookKick() end)
    pcall(function() AC.UnhookTeleport() end)
    pcall(function() AC.UnhookSpeed() end)
    pcall(function() AC.UnhookFlight() end)
    pcall(function() AC.UnhookAttack() end)
    pcall(function() AC.UnhookNoclip() end)
    pcall(function() AC.UnhookObserver() end)
    pcall(function() AC.UnhookAllMetamethods() end)

    for _, conn in ipairs(AC._connections) do
        pcall(function()
            conn:Disconnect()
        end)
    end
    AC._connections = {}

    AC._initialized = false
    AC.AddHistory(0, "Anti-Cheat Bypass System shut down")
end

---------------------------------------------------------------------------

-- HUMAN-LIKE BEHAVIOR / OBFUSCATION → مفصول إلى core/humanizer.lua (نظام مستقل)
-- AC.Humanizer و AC.SetHumanizer و AC.ObfuscateCall و AC.Routes/RouteBuild تُعرَّف الآن في ملفها المخصص.


return AC