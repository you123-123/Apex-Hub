local A = _G.Apex
local Movement = {}
Movement.Active = false
Movement.FlyEnabled = false
Movement.NoclipEnabled = false
Movement.SpeedEnabled = false
Movement.JumpEnabled = false
Movement._loop = nil
Movement._startTick = 0
Movement._flySpeed = 50
Movement._walkSpeed = 16
Movement._jumpPower = 50
Movement._flyBodyVelocity = nil
Movement._flyBodyGyro = nil
Movement._noclipConnection = nil
Movement._flyConnection = nil
Movement._speedConnection = nil
Movement._originalWalkSpeed = 16
Movement._originalJumpPower = 50
Movement._originalGravity = 196.2
Movement._bhopActive = false
Movement._bhopInterval = 0.15
Movement._walkOnWaterActive = false
Movement._waterPlatform = nil
Movement._floatActive = false
Movement._highJumpMultiplier = 3
Movement._infiniteJumpActive = false
Movement._flyKeys = {W = false, A = false, S = false, D = false, Space = false, LeftShift = false}
Movement._lastFlyUpdate = 0
Movement._flyUpdateRate = 0.016

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Apex Movement] Error: " .. tostring(err))
    end
    return ok, err
end

function Movement.StartFly()
    if Movement.FlyEnabled then return end
    local lp = A.LP
    if not lp then return end
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    Movement.FlyEnabled = true
    Movement._originalWalkSpeed = hum.WalkSpeed
    Movement._originalJumpPower = hum.JumpPower
    local bg = Instance.new("BodyGyro")
    bg.Name = "ApexFlyGyro"
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 9000
    bg.D = 500
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp
    Movement._flyBodyGyro = bg
    local bv = Instance.new("BodyVelocity")
    bv.Name = "ApexFlyVelocity"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.P = 9000
    bv.Parent = hrp
    Movement._flyBodyVelocity = bv
    Movement._flyConnection = RunService.Heartbeat:Connect(function(dt)
        if not Movement.FlyEnabled then return end
        if not hrp or not hrp.Parent then
            Movement.StopFly()
            return
        end
        local camCF = Workspace.CurrentCamera.CFrame
        local dir = Vector3.new(0, 0, 0)
        if Movement._flyKeys.W then dir = dir + camCF.LookVector end
        if Movement._flyKeys.S then dir = dir - camCF.LookVector end
        if Movement._flyKeys.A then dir = dir - camCF.RightVector end
        if Movement._flyKeys.D then dir = dir + camCF.RightVector end
        if Movement._flyKeys.Space then dir = dir + Vector3.new(0, 1, 0) end
        if Movement._flyKeys.LeftShift then dir = dir - Vector3.new(0, 1, 0) end
        if dir.Magnitude > 0 then
            dir = dir.Unit
        end
        local speed = Movement._flySpeed
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            speed = speed * 2
        end
        bv.Velocity = dir * speed
        bg.CFrame = camCF
    end)
    A.Notify("Movement", "Fly enabled", 2)
end

function Movement.StopFly()
    Movement.FlyEnabled = false
    if Movement._flyConnection then
        Movement._flyConnection:Disconnect()
        Movement._flyConnection = nil
    end
    if Movement._flyBodyVelocity then
        pcall(function() Movement._flyBodyVelocity:Destroy() end)
        Movement._flyBodyVelocity = nil
    end
    if Movement._flyBodyGyro then
        pcall(function() Movement._flyBodyGyro:Destroy() end)
        Movement._flyBodyGyro = nil
    end
end

function Movement.SetFlySpeed(speed)
    Movement._flySpeed = math.clamp(speed or 50, 10, 500)
end

function Movement.StartNoclip()
    if Movement.NoclipEnabled then return end
    Movement.NoclipEnabled = true
    Movement._noclipConnection = RunService.Stepped:Connect(function()
        if not Movement.NoclipEnabled then return end
        local lp = A.LP
        if not lp or not lp.Character then return end
        for _, part in ipairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    A.Notify("Movement", "Noclip enabled", 2)
end

function Movement.StopNoclip()
    Movement.NoclipEnabled = false
    if Movement._noclipConnection then
        Movement._noclipConnection:Disconnect()
        Movement._noclipConnection = nil
    end
    local lp = A.LP
    if lp and lp.Character then
        for _, part in ipairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

function Movement.SetSpeed(speed)
    Movement._walkSpeed = math.clamp(speed or 16, 0, 500)
    Movement.SpeedEnabled = true
    local lp = A.LP
    if lp and lp.Character then
        local hum = lp.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = Movement._walkSpeed
        end
    end
end

function Movement.SetJumpPower(power)
    Movement._jumpPower = math.clamp(power or 50, 0, 500)
    Movement.JumpEnabled = true
    local lp = A.LP
    if lp and lp.Character then
        local hum = lp.Character:FindFirstChild("Humanoid")
        if hum then
            hum.JumpPower = Movement._jumpPower
            hum.UseJumpPower = true
        end
    end
end

function Movement.InfiniteJump()
    if Movement._infiniteJumpActive then return end
    Movement._infiniteJumpActive = true
    Movement.JumpEnabled = true
    UserInputService.JumpRequest:Connect(function()
        if not Movement._infiniteJumpActive then return end
        local lp = A.LP
        if not lp or not lp.Character then return end
        local hum = lp.Character:FindFirstChild("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
    A.Notify("Movement", "Infinite jump enabled", 2)
end

function Movement.HighJump()
    local lp = A.LP
    if not lp or not lp.Character then return end
    local hum = lp.Character:FindFirstChild("Humanoid")
    local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    local currentJump = Movement._jumpPower * Movement._highJumpMultiplier
    hum.JumpPower = currentJump
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
    task.delay(0.1, function()
        if Movement.JumpEnabled then
            hum.JumpPower = Movement._jumpPower
        else
            hum.JumpPower = 50
        end
    end)
end

function Movement.StartWalkOnWater()
    if Movement._walkOnWaterActive then return end
    Movement._walkOnWaterActive = true
    Movement._waterPlatform = Instance.new("Part")
    Movement._waterPlatform.Name = "ApexWaterPlatform"
    Movement._waterPlatform.Size = Vector3.new(10, 1, 10)
    Movement._waterPlatform.Anchored = true
    Movement._waterPlatform.CanCollide = true
    Movement._waterPlatform.Transparency = 1
    Movement._waterPlatform.Parent = Workspace
    Movement._walkOnWaterActive = true
    RunService.Heartbeat:Connect(function()
        if not Movement._walkOnWaterActive then
            if Movement._waterPlatform then
                Movement._waterPlatform:Destroy()
                Movement._waterPlatform = nil
            end
            return
        end
        local lp = A.LP
        if not lp or not lp.Character then return end
        local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local rayResult = Workspace:Raycast(
            hrp.Position,
            Vector3.new(0, -50, 0),
            RaycastParams.new()
        )
        if rayResult and rayResult.Instance then
            local isWater = string.find(string.lower(rayResult.Instance.Name), "water") or
                rayResult.Instance.Transparency > 0.5
            if isWater then
                Movement._waterPlatform.Position = Vector3.new(hrp.Position.X, rayResult.Position.Y + 0.5, hrp.Position.Z)
                Movement._waterPlatform.Parent = Workspace
            end
        end
    end)
    A.Notify("Movement", "Walk on water enabled", 2)
end

function Movement.StopWalkOnWater()
    Movement._walkOnWaterActive = false
    if Movement._waterPlatform then
        Movement._waterPlatform:Destroy()
        Movement._waterPlatform = nil
    end
end

function Movement.FloatOnWater()
    local lp = A.LP
    if not lp or not lp.Character then return end
    local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bv = Instance.new("BodyVelocity")
    bv.Name = "ApexFloatVelocity"
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.Velocity = Vector3.new(0, 10, 0)
    bv.P = 1000
    bv.Parent = hrp
    task.delay(2, function()
        pcall(function() bv:Destroy() end)
    end)
end

function Movement.BHop()
    if not Movement._bhopActive then return end
    local lp = A.LP
    if not lp or not lp.Character then return end
    local hum = lp.Character:FindFirstChild("Humanoid")
    if not hum then return end
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local vel = root.AssemblyLinearVelocity
    if math.abs(vel.Y) < 0.1 then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

function Movement.AutoBHop()
    Movement._bhopActive = true
    A.Notify("Movement", "Auto bhop enabled", 2)
    task.spawn(function()
        while Movement._bhopActive do
            pcall(function()
                Movement.BHop()
            end)
            task.wait(Movement._bhopInterval)
        end
    end)
end

function Movement.SetGravity(gravity)
    Workspace.Gravity = math.clamp(gravity or 196.2, 0, 1000)
end

function Movement.ToggleFly()
    if Movement.FlyEnabled then
        Movement.StopFly()
    else
        Movement.StartFly()
    end
end

function Movement.ToggleNoclip()
    if Movement.NoclipEnabled then
        Movement.StopNoclip()
    else
        Movement.StartNoclip()
    end
end

function Movement.ResetAll()
    Movement.StopFly()
    Movement.StopNoclip()
    Movement._walkOnWaterActive = false
    Movement._bhopActive = false
    Movement._infiniteJumpActive = false
    Movement.SpeedEnabled = false
    Movement.JumpEnabled = false
    local lp = A.LP
    if lp and lp.Character then
        local hum = lp.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = Movement._originalWalkSpeed
            hum.JumpPower = Movement._originalJumpPower
        end
    end
    Workspace.Gravity = Movement._originalGravity
    A.Notify("Movement", "All movement hacks reset", 2)
end

function Movement.GetMovementStats()
    return {
        Active = Movement.Active,
        Fly = Movement.FlyEnabled,
        Noclip = Movement.NoclipEnabled,
        Speed = Movement.SpeedEnabled,
        Jump = Movement.JumpEnabled,
        FlySpeed = Movement._flySpeed,
        WalkSpeed = Movement._walkSpeed,
        JumpPower = Movement._jumpPower,
        BHop = Movement._bhopActive,
        WalkOnWater = Movement._walkOnWaterActive,
        InfiniteJump = Movement._infiniteJumpActive,
        Gravity = Workspace.Gravity
    }
end

function Movement.MainLoop()
    while Movement.Active do
        if not A.Alive() then
            task.wait(2)
            break
        end
        SafeCall(function()
            if Movement.SpeedEnabled then
                local hum = A.Hum()
                if hum then
                    hum.WalkSpeed = Movement._walkSpeed
                end
            end
            if Movement.JumpEnabled and not Movement._infiniteJumpActive then
                local hum = A.Hum()
                if hum then
                    hum.JumpPower = Movement._jumpPower
                end
            end
        end)
        task.wait(0.5)
    end
end

function Movement.Start()
    if Movement.Active then return end
    Movement.Active = true
    Movement._startTick = tick()
    Movement._originalWalkSpeed = A.Hum() and A.Hum().WalkSpeed or 16
    Movement._originalJumpPower = A.Hum() and A.Hum().JumpPower or 50
    Movement._originalGravity = Workspace.Gravity
    A.Notify("Movement", "Movement hack system started", 3)
    Movement._loop = task.spawn(function()
        Movement.MainLoop()
        Movement.Active = false
    end)
end

function Movement.Stop()
    Movement.Active = false
    Movement.ResetAll()
    if Movement._loop then
        task.cancel(Movement._loop)
        Movement._loop = nil
    end
    A.Notify("Movement", "Stopped", 2)
end

A.MovementHack = Movement
A.Register("movement", A.MovementHack)
