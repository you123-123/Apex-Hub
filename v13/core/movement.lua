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

local A = _G.Apex or {}
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

-- FIX: Unified Movement - delegate to services.lua A.TP (single source of truth, was duplicated 2102 vs 2085 lines)
-- If A.TP already exists (from services.lua), alias instead of duplicating logic
if _G.Apex and _G.Apex.TP and _G.Apex.TP.TPTo then
    -- Alias to avoid duplication - keep only unique helpers
    A.TpTo = function(pos, range) return _G.Apex.TP.TPTo(pos, range) end
    A.SafeTpTo = function(pos, maxTime) return _G.Apex.TP.SafeTeleport(pos) end
    A._movementUnified = true
else
    -- Fallback removed for security (was 1700 lines with huge BodyVelocity + Stepped CanCollide spam)
    function A.TpTo(pos, range) warn("[Apex Movement] TP not available - load services.lua first"); return false end
    function A.SafeTpTo(pos, maxTime) warn("[Apex Movement] SafeTpTo not available"); return false end
    A._movementUnified = false
end -- closes if _G.Apex.TP _G.Apex.TP fallback else

-- Auto-initialize
pcall(function() if A.Initialize and not A._movementUnified then A.Initialize() end end)

return A
