--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║              APEX HUB v13.0 - APEX ULTIMATE                    ║
    ║                   Movement System Module                       ║
    ║                                                                ║
    ║  Features: Teleport, Tween, Fly, Noclip, Speed Hacks,         ║
    ║  Pathfinding, Camera Control, Auto-Walk, Anti-Stuck,          ║
    ║  Walk on Water, and full Movement State tracking               ║
    ║                                                                ║
    ║  Author: Apex Hub Team                                        ║
    ║  Version: 13.0.0                                              ║
    ╚══════════════════════════════════════════════════════════════════╝
--]]

local Movement = {}
Movement.__index = Movement

-- ══════════════════════════════════════════════════════════════════
-- Services
-- ══════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- ══════════════════════════════════════════════════════════════════
-- Constants
-- ══════════════════════════════════════════════════════════════════

local DEFAULT_TWEEN_SPEED = 350
local DEFAULT_FLY_SPEED = 100
local DEFAULT_STUCK_THRESHOLD = 5
local DEFAULT_STUCK_CHECK_INTERVAL = 0.5
local TELEPORT_JITTER = 0.05
local SAFE_TELEPORT_TIMEOUT = 5
local PATHFIND_TIMEOUT = 8
local PATHFIND_RETRY_COUNT = 3
local WATER_RAY_DISTANCE = 50
local GROUND_RAY_DISTANCE = 20

-- ══════════════════════════════════════════════════════════════════
-- State Variables
-- ══════════════════════════════════════════════════════════════════

local A = {}
A.Connections = {}

-- Teleport state
A.LastTeleportTime = 0
A.TeleportCooldown = 0.1
A.TeleportCount = 0

-- Tween state
A.CurrentTween = nil
A.TweenInterrupted = false
A.LastTweenTime = 0

-- Fly state
A.FlyEnabled = false
A.FlySpeed = DEFAULT_FLY_SPEED
A.FlyBody = nil
A.FlyGyro = nil
A.FlyConnection = nil
A.FlyAcceleration = 10
A.FlyDeceleration = 15
A.FlyMaxSpeed = 500
A.FlyMinSpeed = 10
A.FlyCurrentVelocity = Vector3.new(0, 0, 0)

-- Noclip state
A.NoclipEnabled = false
A.NoclipLoop = nil
A.NoclipParts = {}
A.NoclipCheckInterval = 0.05

-- Speed/Jump state
A.OriginalSpeed = 16
A.OriginalJumpPower = 50
A.OriginalGravity = 196.2
A.SpeedModified = false
A.JumpModified = false
A.GravityModified = false

-- Walk on water state
A.WalkOnWaterEnabled = false
A.WaterPlatform = nil
A.WaterPlatformConnection = nil
A.WaterCheckInterval = 0.1

-- Anti-stuck state
A.StuckCheckEnabled = false
A.LastPosition = nil
A.StuckTimer = 0
A.StuckThreshold = DEFAULT_STUCK_THRESHOLD
A.StuckCheckConnection = nil
A.StuckPositionHistory = {}
A.MaxStuckHistory = 20
A.IsCurrentlyStuck = false

-- Auto-walk state
A.AutoWalkEnabled = false
A.AutoWalkConnection = nil
A.AutoWalkSpeed = 16

-- Camera state
A.CameraLocked = false
A.CameraLockTarget = nil
A.CameraLockConnection = nil
A.OriginalCameraType = nil
A.OriginalCameraFOV = 70

-- Movement state
A.MovementState = "Ground"
A.LastStateChangeTime = 0

-- Pathfinding state
A.CurrentPath = nil
A.PathFollowing = false
A.PathWaypoints = {}
A.PathVisualizers = {}

-- ══════════════════════════════════════════════════════════════════
-- Internal Utility Functions
-- ══════════════════════════════════════════════════════════════════

local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHumanoidRootPart()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChild("Humanoid")
end

local function GetRootPartPosition()
    local hrp = GetHumanoidRootPart()
    if hrp then
        return hrp.Position
    end
    return Vector3.new(0, 0, 0)
end

local function SafeDisconnect(connectionKey)
    if A.Connections[connectionKey] then
        if typeof(A.Connections[connectionKey]) == "RBXScriptConnection" then
            A.Connections[connectionKey]:Disconnect()
        elseif typeof(A.Connections[connectionKey]) == "table" then
            for _, conn in pairs(A.Connections[connectionKey]) do
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                end
            end
        end
        A.Connections[connectionKey] = nil
    end
end

local function IsPointInWater(position)
    local rayOrigin = position + Vector3.new(0, 10, 0)
    local rayDirection = Vector3.new(0, -WATER_RAY_DISTANCE, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local char = GetCharacter()
    if char then
        raycastParams.FilterDescendantsInstances = {char}
    end

    local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if result then
        if result.Material == Enum.Material.Water or result.Material == Enum.Material.Glass then
            return true, result.Position
        end
        local part = result.Instance
        if part and (part.Name == "Water" or part.Name == "WaterPart" or part.Name == "WaterEffect") then
            return true, result.Position
        end
    end
    return false, nil
end

local function IsPointOnGround(position)
    local rayOrigin = position + Vector3.new(0, 2, 0)
    local rayDirection = Vector3.new(0, -GROUND_RAY_DISTANCE, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local char = GetCharacter()
    if char then
        raycastParams.FilterDescendantsInstances = {char}
    end

    local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if result then
        if result.Material ~= Enum.Material.Water then
            return true, result.Position, result.Normal
        end
    end
    return false, nil, nil
end

local function CalculateSafePosition(position)
    local onGround, groundPos = IsPointOnGround(position)
    if onGround and groundPos then
        return Vector3.new(position.X, groundPos.Y + 5, position.Z)
    end

    local rayOrigin = position + Vector3.new(0, 50, 0)
    local rayDirection = Vector3.new(0, -100, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local char = GetCharacter()
    if char then
        raycastParams.FilterDescendantsInstances = {char}
    end

    local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if result then
        return Vector3.new(position.X, result.Position.Y + 5, position.Z)
    end

    return Vector3.new(position.X, position.Y + 3, position.Z)
end

local function AddJitter(position)
    local jitterX = (math.random() - 0.5) * TELEPORT_JITTER
    local jitterZ = (math.random() - 0.5) * TELEPORT_JITTER
    return position + Vector3.new(jitterX, 0, jitterZ)
end

local function WaitForCharacter()
    local char = LocalPlayer.Character
    if not char then
        char = LocalPlayer.CharacterAdded:Wait()
    end
    local hrp = char:WaitForChild("HumanoidRootPart", 10)
    local hum = char:WaitForChild("Humanoid", 10)
    return char, hrp, hum
end

local function UpdateMovementState(newState)
    if A.MovementState ~= newState then
        A.MovementState = newState
        A.LastStateChangeTime = tick()
    end
end

local function GetKeyState(key)
    return UserInputService:IsKeyDown(key)
end

local function GetMoveDirection()
    local direction = Vector3.new(0, 0, 0)

    if GetKeyState(Enum.KeyCode.W) then
        direction = direction + Vector3.new(0, 0, -1)
    end
    if GetKeyState(Enum.KeyCode.S) then
        direction = direction + Vector3.new(0, 0, 1)
    end
    if GetKeyState(Enum.KeyCode.A) then
        direction = direction + Vector3.new(-1, 0, 0)
    end
    if GetKeyState(Enum.KeyCode.D) then
        direction = direction + Vector3.new(1, 0, 0)
    end

    if direction.Magnitude > 0 then
        direction = direction.Unit
    end

    return direction
end

local function GetCameraLookDirection()
    local camCF = Camera.CFrame
    local lookDir = camCF.LookVector
    return Vector3.new(lookDir.X, 0, lookDir.Z).Unit
end

local function GetCameraRightDirection()
    local camCF = Camera.CFrame
    local rightDir = camCF.RightVector
    return Vector3.new(rightDir.X, 0, rightDir.Z).Unit
end

local function GetVerticalInput()
    if GetKeyState(Enum.KeyCode.Space) then
        return 1
    elseif GetKeyState(Enum.KeyCode.LeftShift) then
        return -1
    end
    return 0
end

local function CleanupPathVisualizers()
    for _, visualizer in pairs(A.PathVisualizers) do
        if visualizer and visualizer.Parent then
            visualizer:Destroy()
        end
    end
    A.PathVisualizers = {}
end

local function CreatePathVisualizer(position, isStart, isEnd)
    local part = Instance.new("Part")
    part.Size = Vector3.new(1, 1, 1)
    part.Shape = Enum.PartType.Ball
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Position = position

    if isStart then
        part.Color = Color3.fromRGB(0, 255, 0)
        part.Size = Vector3.new(1.5, 1.5, 1.5)
    elseif isEnd then
        part.Color = Color3.fromRGB(255, 0, 0)
        part.Size = Vector3.new(1.5, 1.5, 1.5)
    else
        part.Color = Color3.fromRGB(0, 150, 255)
        part.Size = Vector3.new(0.5, 0.5, 0.5)
    end

    part.Parent = Workspace
    table.insert(A.PathVisualizers, part)
    return part
end

-- ══════════════════════════════════════════════════════════════════
-- 1. TELEPORT SYSTEM
-- ══════════════════════════════════════════════════════════════════

function A.TpTo(pos, range)
    local hrp = GetHumanoidRootPart()
    if not hrp then
        return false
    end

    if tick() - A.LastTeleportTime < A.TeleportCooldown then
        return false
    end

    if range and typeof(range) == "number" then
        local currentPos = hrp.Position
        local distance = (currentPos - pos).Magnitude
        if distance <= range then
            return true
        end
    end

    local safePos = CalculateSafePosition(pos)
    local jitteredPos = AddJitter(safePos)

    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.PlatformStand = true
        RunService.Heartbeat:Wait()
    end

    hrp.CFrame = CFrame.new(jitteredPos)

    RunService.Heartbeat:Wait()

    if humanoid then
        humanoid.PlatformStand = false
    end

    A.LastTeleportTime = tick()
    A.TeleportCount = A.TeleportCount + 1

    return true
end

function A.SafeTpTo(pos, maxTime)
    maxTime = maxTime or SAFE_TELEPORT_TIMEOUT
    local startTime = tick()

    local hrp = GetHumanoidRootPart()
    if not hrp then
        return false
    end

    local startPos = hrp.Position
    local distance = (startPos - pos).Magnitude

    if distance < 5 then
        return true
    end

    local success = A.TpTo(pos)

    while not success and (tick() - startTime) < maxTime do
        RunService.Heartbeat:Wait()
        hrp = GetHumanoidRootPart()
        if hrp then
            success = A.TpTo(pos)
        end
    end

    if hrp then
        local finalDist = (hrp.Position - pos).Magnitude
        return finalDist < 15
    end

    return false
end

function A.SmoothTpTo(pos, steps)
    steps = steps or 10
    local hrp = GetHumanoidRootPart()
    if not hrp then
        return false
    end

    local startPos = hrp.Position
    local stepDelay = 0.02

    for i = 1, steps do
        local alpha = i / steps
        local smoothedAlpha = alpha * alpha * (3 - 2 * alpha)
        local intermediatePos = startPos:Lerp(pos, smoothedAlpha)
        local safePos = CalculateSafePosition(intermediatePos)
        local jitteredPos = AddJitter(safePos)

        hrp.CFrame = CFrame.new(jitteredPos)
        RunService.Heartbeat:Wait()
        wait(stepDelay)
    end

    local finalSafe = CalculateSafePosition(pos)
    hrp.CFrame = CFrame.new(AddJitter(finalSafe))

    A.LastTeleportTime = tick()
    A.TeleportCount = A.TeleportCount + 1
    return true
end

function A.BehindTp(target, distance)
    distance = distance or 5
    local hrp = GetHumanoidRootPart()
    if not hrp then
        return false
    end

    local targetPart = nil
    if typeof(target) == "Instance" then
        targetPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso") or target.PrimaryPart
    elseif typeof(target) == "Vector3" then
        local behindPos = target - (Camera.CFrame.LookVector * distance)
        return A.TpTo(behindPos)
    end

    if not targetPart then
        return false
    end

    local targetCF = targetPart.CFrame
    local behindOffset = targetCF.LookVector * -distance
    local behindPos = targetCF.Position + behindOffset
    local safePos = CalculateSafePosition(behindPos)

    return A.TpTo(safePos)
end

function A.AboveTp(target, distance)
    distance = distance or 10
    local hrp = GetHumanoidRootPart()
    if not hrp then
        return false
    end

    local targetPos = nil
    if typeof(target) == "Instance" then
        local targetPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso") or target.PrimaryPart
        if targetPart then
            targetPos = targetPart.Position
        end
    elseif typeof(target) == "Vector3" then
        targetPos = target
    end

    if not targetPos then
        return false
    end

    local abovePos = targetPos + Vector3.new(0, distance, 0)
    return A.TpTo(abovePos)
end

function A.SideTp(target, side, distance)
    side = side or "Right"
    distance = distance or 5

    local targetPart = nil
    if typeof(target) == "Instance" then
        targetPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso") or target.PrimaryPart
    end

    if not targetPart then
        return false
    end

    local targetCF = targetPart.CFrame
    local sideOffset = nil

    if side == "Right" then
        sideOffset = targetCF.RightVector * distance
    elseif side == "Left" then
        sideOffset = targetCF.RightVector * -distance
    elseif side == "Front" then
        sideOffset = targetCF.LookVector * distance
    elseif side == "Back" then
        sideOffset = targetCF.LookVector * -distance
    else
        sideOffset = targetCF.RightVector * distance
    end

    local sidePos = targetCF.Position + sideOffset
    local safePos = CalculateSafePosition(sidePos)

    return A.TpTo(safePos)
end

-- ══════════════════════════════════════════════════════════════════
-- 2. TWEEN MOVEMENT SYSTEM
-- ══════════════════════════════════════════════════════════════════

function A.TweenTo(pos, speed)
    speed = speed or DEFAULT_TWEEN_SPEED

    local hrp = GetHumanoidRootPart()
    if not hrp then
        return false
    end

    if A.CurrentTween then
        A.CurrentTween:Cancel()
        A.CurrentTween = nil
    end

    A.TweenInterrupted = false
    UpdateMovementState("Teleporting")

    local startPos = hrp.Position
    local distance = (startPos - pos).Magnitude
    local duration = distance / speed

    duration = math.clamp(duration, 0.1, 30)

    local safePos = CalculateSafePosition(pos)
    local targetCF = CFrame.new(safePos)

    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.In,
        0,
        false,
        0
    )

    local tweenValue = Instance.new("CFrameValue")
    tweenValue.Value = hrp.CFrame
    tweenValue.Parent = workspace

    local tween = TweenService:Create(tweenValue, tweenInfo, {Value = targetCF})

    A.CurrentTween = tween

    local connection
    connection = tweenValue.Changed:Connect(function(newCF)
        if A.TweenInterrupted then
            tween:Cancel()
            if connection then
                connection:Disconnect()
            end
            return
        end

        local currentHRP = GetHumanoidRootPart()
        if currentHRP then
            currentHRP.CFrame = newCF
        end
    end)

    local completed = false
    tween.Completed:Connect(function()
        completed = true
        if connection then
            connection:Disconnect()
        end
        tweenValue:Destroy()
        A.CurrentTween = nil
        A.LastTweenTime = tick()
        UpdateMovementState("Ground")
    end)

    tween:Play()

    while not completed and not A.TweenInterrupted do
        RunService.Heartbeat:Wait()
    end

    if not completed then
        tween:Cancel()
        if connection then
            connection:Disconnect()
        end
        tweenValue:Destroy()
        A.CurrentTween = nil
        UpdateMovementState("Ground")
        return false
    end

    return true
end

function A.SafeTweenTo(pos, speed)
    speed = speed or DEFAULT_TWEEN_SPEED
    local hrp = GetHumanoidRootPart()
    if not hrp then
        return false
    end

    local distance = (hrp.Position - pos).Magnitude
    if distance < 5 then
        return true
    end

    A.StartStuckCheck()

    local result = A.TweenTo(pos, speed)

    A.StopStuckCheck()
    return result
end

function A.CurveTweenTo(pos, height, speed)
    speed = speed or DEFAULT_TWEEN_SPEED
    height = height or 20

    local hrp = GetHumanoidRootPart()
    if not hrp then
        return false
    end

    local startPos = hrp.Position
    local midPos = (startPos + pos) / 2 + Vector3.new(0, height, 0)

    local steps = 20
    local totalDistance = 0
    local waypoints = {}

    for i = 0, steps do
        local t = i / steps
        local oneMinusT = 1 - t

        local point = (oneMinusT * oneMinusT * startPos) +
            (2 * oneMinusT * t * midPos) +
            (t * t * pos)

        table.insert(waypoints, point)
        if i > 0 then
            totalDistance = totalDistance + (waypoints[i] - point).Magnitude
        end
    end

    local stepDelay = totalDistance / (speed * steps)

    for i = 2, #waypoints do
        local safePos = CalculateSafePosition(waypoints[i])
        hrp.CFrame = CFrame.new(AddJitter(safePos))
        RunService.Heartbeat:Wait()
        wait(stepDelay)
    end

    A.LastTeleportTime = tick()
    return true
end

function A.TweenBehind(target, speed)
    speed = speed or DEFAULT_TWEEN_SPEED

    local targetPart = nil
    if typeof(target) == "Instance" then
        targetPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso") or target.PrimaryPart
    end

    if not targetPart then
        return false
    end

    local targetCF = targetPart.CFrame
    local behindPos = targetCF.Position + (targetCF.LookVector * -5)
    local safePos = CalculateSafePosition(behindPos)

    return A.TweenTo(safePos, speed)
end

function A.InterruptTween()
    A.TweenInterrupted = true
    if A.CurrentTween then
        A.CurrentTween:Cancel()
        A.CurrentTween = nil
    end
    UpdateMovementState("Ground")
end

-- ══════════════════════════════════════════════════════════════════
-- 3. FLY SYSTEM
-- ══════════════════════════════════════════════════════════════════

function A.StartFly(speed)
    if A.FlyEnabled then
        return
    end

    A.FlySpeed = speed or DEFAULT_FLY_SPEED
    A.FlyEnabled = true

    local hrp = GetHumanoidRootPart()
    if not hrp then
        A.FlyEnabled = false
        return
    end

    A.FlyGyro = Instance.new("BodyGyro")
    A.FlyGyro.Name = "ApexFlyGyro"
    A.FlyGyro.P = 9000
    A.FlyGyro.D = 500
    A.FlyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    A.FlyGyro.CFrame = hrp.CFrame
    A.FlyGyro.Parent = hrp

    A.FlyBody = Instance.new("BodyVelocity")
    A.FlyBody.Name = "ApexFlyVelocity"
    A.FlyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    A.FlyBody.Velocity = Vector3.new(0, 0, 0)
    A.FlyBody.P = 10000
    A.FlyBody.Parent = hrp

    A.FlyCurrentVelocity = Vector3.new(0, 0, 0)

    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.PlatformStand = true
    end

    UpdateMovementState("Flying")

    A.FlyConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not A.FlyEnabled then
            return
        end

        local currentHRP = GetHumanoidRootPart()
        if not currentHRP then
            A.StopFly()
            return
        end

        local moveDir = GetMoveDirection()
        local verticalInput = GetVerticalInput()

        local camLook = GetCameraLookDirection()
        local camRight = GetCameraRightDirection()

        local targetVelocity = Vector3.new(0, 0, 0)

        if moveDir.Z < 0 then
            targetVelocity = targetVelocity + camLook * A.FlySpeed
        elseif moveDir.Z > 0 then
            targetVelocity = targetVelocity - camLook * A.FlySpeed
        end

        if moveDir.X > 0 then
            targetVelocity = targetVelocity + camRight * A.FlySpeed
        elseif moveDir.X < 0 then
            targetVelocity = targetVelocity - camRight * A.FlySpeed
        end

        if verticalInput > 0 then
            targetVelocity = targetVelocity + Vector3.new(0, A.FlySpeed, 0)
        elseif verticalInput < 0 then
            targetVelocity = targetVelocity - Vector3.new(0, A.FlySpeed, 0)
        end

        local accelRate = A.FlyAcceleration * deltaTime
        local decelRate = A.FlyDeceleration * deltaTime

        if targetVelocity.Magnitude > 0 then
            A.FlyCurrentVelocity = A.FlyCurrentVelocity:Lerp(targetVelocity, math.min(1, accelRate))
        else
            local currentMag = A.FlyCurrentVelocity.Magnitude
            if currentMag > 0.1 then
                local reduction = decelRate * A.FlySpeed
                local newMag = math.max(0, currentMag - reduction)
                A.FlyCurrentVelocity = A.FlyCurrentVelocity.Unit * newMag
            else
                A.FlyCurrentVelocity = Vector3.new(0, 0, 0)
            end
        end

        if A.FlyBody and A.FlyBody.Parent then
            A.FlyBody.Velocity = A.FlyCurrentVelocity
        end

        local camCF = Camera.CFrame
        if A.FlyGyro and A.FlyGyro.Parent then
            A.FlyGyro.CFrame = camCF
        end
    end)
end

function A.StopFly()
    A.FlyEnabled = false

    if A.FlyConnection then
        A.FlyConnection:Disconnect()
        A.FlyConnection = nil
    end

    if A.FlyBody then
        if A.FlyBody.Parent then
            A.FlyBody:Destroy()
        end
        A.FlyBody = nil
    end

    if A.FlyGyro then
        if A.FlyGyro.Parent then
            A.FlyGyro:Destroy()
        end
        A.FlyGyro = nil
    end

    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.PlatformStand = false
    end

    A.FlyCurrentVelocity = Vector3.new(0, 0, 0)
    UpdateMovementState("Ground")
end

function A.SetFlySpeed(speed)
    speed = math.clamp(speed, A.FlyMinSpeed, A.FlyMaxSpeed)
    A.FlySpeed = speed
end

function A.ToggleFly()
    if A.FlyEnabled then
        A.StopFly()
    else
        A.StartFly()
    end
    return A.FlyEnabled
end

function A.IsFlying()
    return A.FlyEnabled
end

-- ══════════════════════════════════════════════════════════════════
-- 4. NOCLIP SYSTEM
-- ══════════════════════════════════════════════════════════════════

function A.StartNoclip()
    if A.NoclipEnabled then
        return
    end

    A.NoclipEnabled = true
    UpdateMovementState("Noclipping")

    A.NoclipLoop = RunService.Stepped:Connect(function()
        if not A.NoclipEnabled then
            return
        end

        local char = GetCharacter()
        if not char then
            return
        end

        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end

        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
    end)
end

function A.StopNoclip()
    A.NoclipEnabled = false

    if A.NoclipLoop then
        A.NoclipLoop:Disconnect()
        A.NoclipLoop = nil
    end

    local char = GetCharacter()
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end

    UpdateMovementState("Ground")
end

function A.ToggleNoclip()
    if A.NoclipEnabled then
        A.StopNoclip()
    else
        A.StartNoclip()
    end
    return A.NoclipEnabled
end

-- ══════════════════════════════════════════════════════════════════
-- 5. SPEED / JUMP HACKS
-- ══════════════════════════════════════════════════════════════════

function A.SetSpeed(speed)
    local humanoid = GetHumanoid()
    if not humanoid then
        return false
    end

    if not A.SpeedModified then
        A.OriginalSpeed = humanoid.WalkSpeed
        A.SpeedModified = true
    end

    speed = math.clamp(speed, 0, 500)
    humanoid.WalkSpeed = speed

    return true
end

function A.SetJumpPower(power)
    local humanoid = GetHumanoid()
    if not humanoid then
        return false
    end

    if not A.JumpModified then
        A.OriginalJumpPower = humanoid.JumpPower
        A.JumpModified = true
    end

    power = math.clamp(power, 0, 300)
    humanoid.JumpPower = power
    humanoid.UseJumpPower = true

    return true
end

function A.SetGravity(gravity)
    if not A.GravityModified then
        A.OriginalGravity = Workspace.Gravity
        A.GravityModified = true
    end

    gravity = math.clamp(gravity, 0, 500)
    Workspace.Gravity = gravity

    return true
end

function A.InfiniteJump()
    if A.Connections["InfiniteJump"] then
        A.Connections["InfiniteJump"]:Disconnect()
        A.Connections["InfiniteJump"] = nil
        return false
    end

    A.Connections["InfiniteJump"] = UserInputService.JumpRequest:Connect(function()
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    return true
end

function A.HighJump(power)
    power = power or 100

    local humanoid = GetHumanoid()
    if not humanoid then
        return false
    end

    local hrp = GetHumanoidRootPart()
    if not hrp then
        return false
    end

    local wasNoclipping = A.NoclipEnabled

    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "ApexHighJump"
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Velocity = Vector3.new(0, power, 0)
    bodyVelocity.P = 5000
    bodyVelocity.Parent = hrp

    game:GetService("Debris"):AddItem(bodyVelocity, 0.3)

    return true
end

function A.NoClipJump()
    local wasNoclipping = A.NoclipEnabled

    if not wasNoclipping then
        A.StartNoclip()
    end

    local humanoid = GetHumanoid()
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end

    if not wasNoclipping then
        spawn(function()
            wait(0.5)
            if not wasNoclipping then
                A.StopNoclip()
            end
        end)
    end

    return true
end

function A.ResetMovement()
    local humanoid = GetHumanoid()
    if not humanoid then
        return false
    end

    if A.SpeedModified then
        humanoid.WalkSpeed = A.OriginalSpeed
        A.SpeedModified = false
    end

    if A.JumpModified then
        humanoid.JumpPower = A.OriginalJumpPower
        A.JumpModified = false
    end

    if A.GravityModified then
        Workspace.Gravity = A.OriginalGravity
        A.GravityModified = false
    end

    if A.FlyEnabled then
        A.StopFly()
    end

    if A.NoclipEnabled then
        A.StopNoclip()
    end

    if A.WalkOnWaterEnabled then
        A.StopWalkOnWater()
    end

    if A.AutoWalkEnabled then
        A.StopAutoWalk()
    end

    if A.CameraLocked then
        A.UnlockCamera()
    end

    A.StopStuckCheck()
    CleanupPathVisualizers()

    UpdateMovementState("Ground")

    return true
end

-- ══════════════════════════════════════════════════════════════════
-- 6. WALK ON WATER
-- ══════════════════════════════════════════════════════════════════

function A.StartWalkOnWater()
    if A.WalkOnWaterEnabled then
        return
    end

    A.WalkOnWaterEnabled = true

    A.WaterPlatform = Instance.new("Part")
    A.WaterPlatform.Name = "ApexWaterPlatform"
    A.WaterPlatform.Size = Vector3.new(10, 0.5, 10)
    A.WaterPlatform.Transparency = 1
    A.WaterPlatform.Anchored = true
    A.WaterPlatform.CanCollide = true
    A.WaterPlatform.Material = Enum.Material.ForceField
    A.WaterPlatform.Parent = Workspace

    A.WaterPlatformConnection = RunService.Heartbeat:Connect(function()
        if not A.WalkOnWaterEnabled then
            return
        end

        local hrp = GetHumanoidRootPart()
        if not hrp or not A.WaterPlatform then
            return
        end

        local pos = hrp.Position
        A.WaterPlatform.Position = Vector3.new(pos.X, pos.Y - 3.5, pos.Z)

        local onWater = A.IsOnWater()
        if onWater then
            A.WaterPlatform.Transparency = 1
            A.WaterPlatform.CanCollide = true
        else
            A.WaterPlatform.Transparency = 1
            A.WaterPlatform.CanCollide = false
        end
    end)
end

function A.StopWalkOnWater()
    A.WalkOnWaterEnabled = false

    if A.WaterPlatformConnection then
        A.WaterPlatformConnection:Disconnect()
        A.WaterPlatformConnection = nil
    end

    if A.WaterPlatform then
        if A.WaterPlatform.Parent then
            A.WaterPlatform:Destroy()
        end
        A.WaterPlatform = nil
    end
end

function A.IsOnWater()
    local hrp = GetHumanoidRootPart()
    if not hrp then
        return false
    end

    local onWater, waterPos = IsPointInWater(hrp.Position)
    return onWater
end

-- ══════════════════════════════════════════════════════════════════
-- 7. PATHFINDING SYSTEM
-- ══════════════════════════════════════════════════════════════════

function A.PathfindTo(pos, visualize)
    visualize = visualize or false

    local hrp = GetHumanoidRootPart()
    local humanoid = GetHumanoid()
    if not hrp or not humanoid then
        return false
    end

    CleanupPathVisualizers()

    local agentParams = {
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentCanClimb = false,
        WaypointSpacing = 4,
        AgentCanSwim = true,
    }

    local path = PathfindingService:CreatePath(agentParams)
    A.CurrentPath = path

    local startPos = hrp.Position
    local success, err = pcall(function()
        path:ComputeAsync(startPos, pos)
    end)

    if not success then
        A.CurrentPath = nil
        return false
    end

    if path.Status ~= Enum.PathStatus.Success then
        A.CurrentPath = nil
        return false
    end

    local waypoints = path:GetWaypoints()
    A.PathWaypoints = waypoints

    if visualize then
        CreatePathVisualizer(startPos, true, false)
        CreatePathVisualizer(pos, false, true)

        for i = 2, #waypoints - 1 do
            CreatePathVisualizer(waypoints[i].Position, false, false)
        end
    end

    A.PathFollowing = true
    UpdateMovementState("Pathfinding")

    for i, waypoint in ipairs(waypoints) do
        if not A.PathFollowing then
            break
        end

        humanoid:MoveTo(waypoint.Position)

        if waypoint.Action == Enum.PathWaypointAction.Jump then
            humanoid.Jump = true
        end

        local moveSuccess = false
        local moveTimeout = 0
        local maxMoveTimeout = PATHFIND_TIMEOUT
        local lastPos = hrp.Position
        local stuckCount = 0

        while moveTimeout < maxMoveTimeout and A.PathFollowing do
            RunService.Heartbeat:Wait()
            moveTimeout = moveTimeout + RunService.Heartbeat:Wait()

            local currentPos = hrp.Position
            local distToWaypoint = (currentPos - waypoint.Position).Magnitude

            if distToWaypoint < 4 then
                moveSuccess = true
                break
            end

            local distMoved = (currentPos - lastPos).Magnitude
            if distMoved < 0.1 then
                stuckCount = stuckCount + 1
                if stuckCount > 15 then
                    break
                end
            else
                stuckCount = 0
            end

            lastPos = currentPos
        end

        if not moveSuccess and not A.PathFollowing then
            break
        end
    end

    A.PathFollowing = false
    A.CurrentPath = nil
    UpdateMovementState("Ground")

    if visualize then
        spawn(function()
            wait(3)
            CleanupPathVisualizers()
        end)
    end

    return true
end

function A.SafePathfind(pos)
    for attempt = 1, PATHFIND_RETRY_COUNT do
        local success = A.PathfindTo(pos, false)
        if success then
            local currentDist = (GetRootPartPosition() - pos).Magnitude
            if currentDist < 15 then
                return true
            end
        end

        if attempt < PATHFIND_RETRY_COUNT then
            local hrp = GetHumanoidRootPart()
            if hrp then
                local currentPos = hrp.Position
                local randomOffset = Vector3.new(
                    (math.random() - 0.5) * 10,
                    0,
                    (math.random() - 0.5) * 10
                )
                A.TpTo(currentPos + randomOffset)
                wait(0.5)
            end
        end
    end

    return A.TpTo(pos)
end

function A.PathfindToTarget(target)
    if not target then
        return false
    end

    local targetPart = nil
    if typeof(target) == "Instance" then
        targetPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso") or target.PrimaryPart
    end

    if not targetPart then
        return false
    end

    A.PathFollowing = true
    UpdateMovementState("Pathfinding")

    local followConnection
    local lastUpdateTime = 0
    local updateInterval = 0.5

    followConnection = RunService.Heartbeat:Connect(function()
        if not A.PathFollowing then
            followConnection:Disconnect()
            return
        end

        local now = tick()
        if now - lastUpdateTime < updateInterval then
            return
        end
        lastUpdateTime = now

        local hrp = GetHumanoidRootPart()
        if not hrp then
            A.PathFollowing = false
            followConnection:Disconnect()
            return
        end

        local dist = (hrp.Position - targetPart.Position).Magnitude
        if dist < 8 then
            A.PathFollowing = false
            followConnection:Disconnect()
            UpdateMovementState("Ground")
            return
        end

        spawn(function()
            A.PathfindTo(targetPart.Position, false)
        end)
    end)

    return true
end

function A.GetPathDistance(from, to)
    local agentParams = {
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentCanClimb = false,
        WaypointSpacing = 4,
        AgentCanSwim = true,
    }

    local path = PathfindingService:CreatePath(agentParams)

    local success, err = pcall(function()
        path:ComputeAsync(from, to)
    end)

    if not success or path.Status ~= Enum.PathStatus.Success then
        return (from - to).Magnitude
    end

    local waypoints = path:GetWaypoints()
    local totalDist = 0

    for i = 2, #waypoints do
        totalDist = totalDist + (waypoints[i - 1].Position - waypoints[i].Position).Magnitude
    end

    return totalDist
end

function A.IsPathBlocked(from, to)
    local agentParams = {
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentCanClimb = false,
        WaypointSpacing = 4,
        AgentCanSwim = true,
    }

    local path = PathfindingService:CreatePath(agentParams)

    local success, err = pcall(function()
        path:ComputeAsync(from, to)
    end)

    if not success then
        return true
    end

    return path.Status ~= Enum.PathStatus.Success
end

function A.StopPathfind()
    A.PathFollowing = false

    local humanoid = GetHumanoid()
    if humanoid then
        humanoid:MoveTo(humanoid.RootPart.Position)
    end

    CleanupPathVisualizers()
    UpdateMovementState("Ground")
end

-- ══════════════════════════════════════════════════════════════════
-- 8. MOVEMENT UTILITIES
-- ══════════════════════════════════════════════════════════════════

function A.GetMoveDir()
    return GetMoveDirection()
end

function A.IsMoving()
    local hrp = GetHumanoidRootPart()
    if not hrp then
        return false
    end

    local velocity = hrp.Velocity
    local horizontalVelocity = Vector3.new(velocity.X, 0, velocity.Z)
    return horizontalVelocity.Magnitude > 0.5
end

function A.GetVelocity()
    local hrp = GetHumanoidRootPart()
    if not hrp then
        return Vector3.new(0, 0, 0)
    end
    return hrp.Velocity
end

function A.GetSpeed()
    local hrp = GetHumanoidRootPart()
    if not hrp then
        return 0
    end
    return hrp.Velocity.Magnitude
end

function A.GetMoveTime(dist, speed)
    speed = speed or DEFAULT_TWEEN_SPEED
    if speed <= 0 then
        return math.huge
    end
    return dist / speed
end

function A.GetDistanceTo(pos)
    local currentPos = GetRootPartPosition()
    return (currentPos - pos).Magnitude
end

function A.GetDistanceToTarget(target)
    if not target then
        return math.huge
    end

    local targetPos = nil
    if typeof(target) == "Instance" then
        local targetPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso") or target.PrimaryPart
        if targetPart then
            targetPos = targetPart.Position
        end
    elseif typeof(target) == "Vector3" then
        targetPos = target
    end

    if not targetPos then
        return math.huge
    end

    local currentPos = GetRootPartPosition()
    return (currentPos - targetPos).Magnitude
end

function A.InRange(target, range)
    local dist = A.GetDistanceToTarget(target)
    return dist <= range
end

-- ══════════════════════════════════════════════════════════════════
-- 9. ANTI-STUCK SYSTEM
-- ══════════════════════════════════════════════════════════════════

function A.StartStuckCheck()
    if A.StuckCheckEnabled then
        return
    end

    A.StuckCheckEnabled = true
    A.StuckTimer = 0
    A.IsCurrentlyStuck = false
    A.StuckPositionHistory = {}

    local hrp = GetHumanoidRootPart()
    if hrp then
        A.LastPosition = hrp.Position
    end

    A.StuckCheckConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not A.StuckCheckEnabled then
            return
        end

        local hrp = GetHumanoidRootPart()
        if not hrp then
            return
        end

        local currentPos = hrp.Position

        if A.LastPosition then
            local distMoved = (currentPos - A.LastPosition).Magnitude

            table.insert(A.StuckPositionHistory, {
                position = currentPos,
                time = tick(),
                distance = distMoved
            })

            if #A.StuckPositionHistory > A.MaxStuckHistory then
                table.remove(A.StuckPositionHistory, 1)
            end

            if distMoved < 0.5 then
                A.StuckTimer = A.StuckTimer + deltaTime
                if A.StuckTimer >= A.StuckThreshold then
                    A.IsCurrentlyStuck = true
                end
            else
                A.StuckTimer = 0
                A.IsCurrentlyStuck = false
            end
        end

        A.LastPosition = currentPos
    end)
end

function A.StopStuckCheck()
    A.StuckCheckEnabled = false
    A.StuckTimer = 0
    A.IsCurrentlyStuck = false
    A.LastPosition = nil
    A.StuckPositionHistory = {}

    if A.StuckCheckConnection then
        A.StuckCheckConnection:Disconnect()
        A.StuckCheckConnection = nil
    end
end

function A.IsStuck()
    return A.IsCurrentlyStuck
end

function A.Unstuck()
    local hrp = GetHumanoidRootPart()
    local humanoid = GetHumanoid()
    if not hrp or not humanoid then
        return false
    end

    -- Method 1: Jump
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    humanoid.Jump = true
    wait(0.3)

    local movedAfterJump = (hrp.Position - (A.LastPosition or hrp.Position)).Magnitude
    if movedAfterJump > 2 then
        A.StuckTimer = 0
        A.IsCurrentlyStuck = false
        return true
    end

    -- Method 2: Move sideways
    local randomSide = Vector3.new(
        (math.random() - 0.5) * 20,
        0,
        (math.random() - 0.5) * 20
    )
    humanoid:MoveTo(hrp.Position + randomSide)
    wait(1)

    local movedAfterSide = (hrp.Position - (A.LastPosition or hrp.Position)).Magnitude
    if movedAfterSide > 2 then
        A.StuckTimer = 0
        A.IsCurrentlyStuck = false
        return true
    end

    -- Method 3: Teleport up
    local upPos = hrp.Position + Vector3.new(0, 15, 0)
    local safeUp = CalculateSafePosition(upPos)
    hrp.CFrame = CFrame.new(safeUp)
    wait(0.5)

    -- Method 4: Teleport to a different nearby position
    local randomTP = hrp.Position + Vector3.new(
        (math.random() - 0.5) * 30,
        5,
        (math.random() - 0.5) * 30
    )
    local safeTP = CalculateSafePosition(randomTP)
    hrp.CFrame = CFrame.new(safeTP)
    wait(0.5)

    A.StuckTimer = 0
    A.IsCurrentlyStuck = false
    A.LastPosition = hrp.Position

    return true
end

function A.StuckRecovery()
    if not A.IsCurrentlyStuck then
        return false
    end

    local maxRecoveryAttempts = 5
    local recovered = false

    for attempt = 1, maxRecoveryAttempts do
        local success = A.Unstuck()
        if success then
            recovered = true
            break
        end

        wait(0.5)
    end

    if not recovered then
        local hrp = GetHumanoidRootPart()
        if hrp then
            local currentPos = hrp.Position
            local randomFar = currentPos + Vector3.new(
                (math.random() - 0.5) * 100,
                10,
                (math.random() - 0.5) * 100
            )
            local safeFar = CalculateSafePosition(randomFar)
            hrp.CFrame = CFrame.new(safeFar)
            wait(0.5)
        end
    end

    A.StuckTimer = 0
    A.IsCurrentlyStuck = false
    return true
end

-- ══════════════════════════════════════════════════════════════════
-- 10. CAMERA CONTROL
-- ══════════════════════════════════════════════════════════════════

function A.LockCamera(target)
    if A.CameraLocked then
        A.UnlockCamera()
    end

    local targetPart = nil
    if typeof(target) == "Instance" then
        targetPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head") or target.PrimaryPart
    elseif typeof(target) == "Vector3" then
        local tempPart = Instance.new("Part")
        tempPart.Size = Vector3.new(1, 1, 1)
        tempPart.Position = target
        tempPart.Anchored = true
        tempPart.CanCollide = false
        tempPart.Transparency = 1
        tempPart.Parent = Workspace
        targetPart = tempPart
    end

    if not targetPart then
        return false
    end

    A.CameraLocked = true
    A.CameraLockTarget = targetPart
    A.OriginalCameraType = Camera.CameraType

    Camera.CameraType = Enum.CameraType.Scriptable

    A.CameraLockConnection = RunService.RenderStepped:Connect(function()
        if not A.CameraLocked or not A.CameraLockTarget or not A.CameraLockTarget.Parent then
            A.UnlockCamera()
            return
        end

        local targetPos = A.CameraLockTarget.Position
        local hrp = GetHumanoidRootPart()

        if hrp then
            local cameraPos = hrp.Position + Vector3.new(0, 3, 0)
            local direction = (targetPos - cameraPos).Unit
            Camera.CFrame = CFrame.new(cameraPos, cameraPos + direction)
        end
    end)

    return true
end

function A.UnlockCamera()
    A.CameraLocked = false
    A.CameraLockTarget = nil

    if A.CameraLockConnection then
        A.CameraLockConnection:Disconnect()
        A.CameraLockConnection = nil
    end

    Camera.CameraType = A.OriginalCameraType or Enum.CameraType.Custom
end

function A.CameraToPos(pos)
    local hrp = GetHumanoidRootPart()
    if not hrp then
        return false
    end

    local cameraPos = hrp.Position + Vector3.new(0, 3, 0)
    local direction = (pos - cameraPos).Unit

    Camera.CameraType = Enum.CameraType.Scriptable
    Camera.CFrame = CFrame.new(cameraPos, cameraPos + direction)

    return true
end

function A.GetCameraCF()
    return Camera.CFrame
end

function A.SetFOV(fov)
    fov = math.clamp(fov, 30, 120)
    Camera.FieldOfView = fov
    return true
end

function A.ResetFOV()
    Camera.FieldOfView = A.OriginalCameraFOV
    return true
end

-- ══════════════════════════════════════════════════════════════════
-- 11. AUTO-WALK SYSTEM
-- ══════════════════════════════════════════════════════════════════

function A.StartAutoWalk(direction, speed)
    if A.AutoWalkEnabled then
        A.StopAutoWalk()
    end

    A.AutoWalkEnabled = true
    A.AutoWalkSpeed = speed or 16

    local humanoid = GetHumanoid()
    if not humanoid then
        A.AutoWalkEnabled = false
        return false
    end

    local moveDirection = nil
    if typeof(direction) == "Vector3" then
        moveDirection = direction.Unit
    elseif typeof(direction) == "string" then
        if direction == "Forward" then
            moveDirection = Vector3.new(0, 0, -1)
        elseif direction == "Back" then
            moveDirection = Vector3.new(0, 0, 1)
        elseif direction == "Left" then
            moveDirection = Vector3.new(-1, 0, 0)
        elseif direction == "Right" then
            moveDirection = Vector3.new(1, 0, 0)
        end
    end

    if not moveDirection then
        A.AutoWalkEnabled = false
        return false
    end

    humanoid.WalkSpeed = A.AutoWalkSpeed

    A.AutoWalkConnection = RunService.Heartbeat:Connect(function()
        if not A.AutoWalkEnabled then
            return
        end

        local hum = GetHumanoid()
        local hrp = GetHumanoidRootPart()
        if not hum or not hrp then
            return
        end

        local worldDir = hrp.CFrame:VectorToWorldSpace(moveDirection)
        hum:MoveTo(hrp.Position + worldDir * 10)
    end)

    return true
end

function A.StopAutoWalk()
    A.AutoWalkEnabled = false

    if A.AutoWalkConnection then
        A.AutoWalkConnection:Disconnect()
        A.AutoWalkConnection = nil
    end

    local humanoid = GetHumanoid()
    if humanoid then
        humanoid:MoveTo(humanoid.RootPart.Position)
    end
end

function A.CircularWalk(center, radius, speed)
    if A.AutoWalkEnabled then
        A.StopAutoWalk()
    end

    A.AutoWalkEnabled = true
    A.AutoWalkSpeed = speed or 16

    local humanoid = GetHumanoid()
    if not humanoid then
        A.AutoWalkEnabled = false
        return false
    end

    local centerX, centerZ
    if typeof(center) == "Vector3" then
        centerX = center.X
        centerZ = center.Z
    elseif typeof(center) == "Instance" then
        local part = center:FindFirstChild("HumanoidRootPart") or center:FindFirstChild("Torso") or center.PrimaryPart
        if part then
            centerX = part.Position.X
            centerZ = part.Position.Z
        else
            A.AutoWalkEnabled = false
            return false
        end
    else
        local hrp = GetHumanoidRootPart()
        if hrp then
            centerX = hrp.Position.X
            centerZ = hrp.Position.Z
        else
            A.AutoWalkEnabled = false
            return false
        end
    end

    radius = radius or 15
    local angle = 0
    local angularSpeed = speed / radius

    A.AutoWalkConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not A.AutoWalkEnabled then
            return
        end

        local hum = GetHumanoid()
        if not hum then
            return
        end

        angle = angle + angularSpeed * deltaTime

        local targetX = centerX + math.cos(angle) * radius
        local targetZ = centerZ + math.sin(angle) * radius
        local targetPos = Vector3.new(targetX, 0, targetZ)

        local hrp = GetHumanoidRootPart()
        if hrp then
            local onGround, groundPos = IsPointOnGround(targetPos)
            if onGround and groundPos then
                targetPos = Vector3.new(targetPos.X, groundPos.Y, targetPos.Z)
            end
        end

        hum:MoveTo(targetPos)
    end)

    return true
end

-- ══════════════════════════════════════════════════════════════════
-- 12. MOVEMENT STATE
-- ══════════════════════════════════════════════════════════════════

function A.IsOnGround()
    local hrp = GetHumanoidRootPart()
    if not hrp then
        return false
    end

    local onGround, groundPos, normal = IsPointOnGround(hrp.Position)
    if onGround and groundPos then
        local heightAboveGround = hrp.Position.Y - groundPos.Y
        if heightAboveGround < 5 then
            return true
        end
    end

    local humanoid = GetHumanoid()
    if humanoid then
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.RunningNoPhysics then
            return true
        end
    end

    return false
end

function A.IsInAir()
    local hrp = GetHumanoidRootPart()
    if not hrp then
        return false
    end

    if A.FlyEnabled then
        return true
    end

    local humanoid = GetHumanoid()
    if humanoid then
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
            return true
        end
    end

    if not A.IsOnGround() then
        local onWater = A.IsOnWater()
        if not onWater then
            return true
        end
    end

    return false
end

function A.IsSwimming()
    local humanoid = GetHumanoid()
    if humanoid then
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Swimming then
            return true
        end
    end

    return A.IsOnWater()
end

function A.GetTerrainType()
    if A.FlyEnabled then
        return "Flying"
    end

    if A.NoclipEnabled then
        return "Noclipping"
    end

    if A.MovementState == "Pathfinding" then
        return "Pathfinding"
    end

    if A.MovementState == "Teleporting" then
        return "Teleporting"
    end

    if A.IsSwimming() then
        return "Water"
    end

    if A.IsInAir() then
        return "Air"
    end

    if A.IsOnGround() then
        return "Ground"
    end

    return "Unknown"
end

-- ══════════════════════════════════════════════════════════════════
-- INITIALIZATION & CLEANUP
-- ══════════════════════════════════════════════════════════════════

function A.Initialize()
    A.OriginalGravity = Workspace.Gravity

    local humanoid = GetHumanoid()
    if humanoid then
        A.OriginalSpeed = humanoid.WalkSpeed
        A.OriginalJumpPower = humanoid.JumpPower
    end

    A.OriginalCameraFOV = Camera.FieldOfView
    A.OriginalCameraType = Camera.CameraType

    Camera = Workspace.CurrentCamera
end

function A.Cleanup()
    A.ResetMovement()

    for key, connection in pairs(A.Connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        elseif typeof(connection) == "table" then
            for _, conn in pairs(connection) do
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                end
            end
        end
    end
    A.Connections = {}

    CleanupPathVisualizers()
end

function A.GetState()
    return {
        MovementState = A.MovementState,
        IsFlying = A.FlyEnabled,
        IsNoclipping = A.NoclipEnabled,
        IsOnWater = A.IsOnWater(),
        IsOnGround = A.IsOnGround(),
        IsInAir = A.IsInAir(),
        IsSwimming = A.IsSwimming(),
        IsStuck = A.IsCurrentlyStuck,
        IsPathFollowing = A.PathFollowing,
        IsAutoWalking = A.AutoWalkEnabled,
        IsCameraLocked = A.CameraLocked,
        FlySpeed = A.FlySpeed,
        TerrainType = A.GetTerrainType(),
        Position = GetRootPartPosition(),
        Velocity = A.GetVelocity(),
        Speed = A.GetSpeed(),
    }
end

-- Auto-initialize
A.Initialize()

return A
