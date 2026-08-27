local A = _G.Apex
local Berry = {}
Berry.Active = false
Berry.TotalCollected = 0
Berry.SessionStart = 0
Berry._loop = nil
Berry._collecting = false
Berry.BerryCount = 0
Berry._berries = {}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BERRY_TYPES = {
    {Name = "Blueberry", Value = 100},
    {Name = "Raspberry", Value = 150},
    {Name = "Strawberry", Value = 200},
    {Name = "Blackberry", Value = 300},
    {Name = "Golden Berry", Value = 1000},
}

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Apex Berry] Error: " .. tostring(err))
    end
    return ok, err
end

function Berry.FindBerrySpawns()
    local spawns = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local name = obj and obj.Name or ""
        local lower = string.lower(name)
        if obj:IsA("BasePart") or obj:IsA("Model") then
            for _, berry in ipairs(BERRY_TYPES) do
                local berryLower = string.lower(berry.Name)
                if string.find(lower, berryLower) then
                    local root = obj:IsA("Model") and (obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Part") or obj.PrimaryPart) or obj
                    if root then
                        table.insert(spawns, {
                            Obj = obj,
                            Root = root,
                            Name = berry.Name,
                            Value = berry.Value,
                            Position = root.Position
                        })
                    end
                    break
                end
            end
        end
    end
    return spawns
end

function Berry.GetNearestBerry()
    local spawns = Berry.FindBerrySpawns()
    if #spawns == 0 then return nil end
    local hrp = A.HRP()
    if not hrp then return nil end
    local nearest = nil
    local nearestDist = math.huge
    for _, spawn in ipairs(spawns) do
        local dist = (spawn.Position - hrp.Position).Magnitude
        if dist < nearestDist then
            nearest = spawn
            nearestDist = dist
        end
    end
    return nearest, nearestDist
end

function Berry.CollectBerry(berry)
    if not berry then return false end
    local ok = SafeCall(function()
        if berry.Obj:IsA("Model") and berry.Obj:FindFirstChildOfClass("ProximityPrompt") then
            local prompt = berry.Obj:FindFirstChildOfClass("ProximityPrompt")
            if fireproximityprompt then
                fireproximityprompt(prompt)
                task.wait(0.2)
                Berry.BerryCount = Berry.BerryCount + 1
                Berry.TotalCollected = Berry.TotalCollected + 1
                return true
            end
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local collectRemote = remotes:FindFirstChild("CollectBerry") or remotes:FindFirstChild("BerryCollect")
            if collectRemote then
                collectRemote:FireServer(berry.Obj)
                task.wait(0.2)
                Berry.BerryCount = Berry.BerryCount + 1
                Berry.TotalCollected = Berry.TotalCollected + 1
                return true
            end
        end
        if firetouchinterest then
            firetouchinterest(A.HRP(), berry.Obj, 0)
            task.wait(0.2)
            firetouchinterest(A.HRP(), berry.Obj, 1)
            task.wait(0.1)
            Berry.BerryCount = Berry.BerryCount + 1
            Berry.TotalCollected = Berry.TotalCollected + 1
            return true
        end
    end)
    return ok
end

function Berry.TeleportTo(berry)
    if not berry then return false end
    local hrp = A.HRP()
    if not hrp then return false end
    local cf = CFrame.new(berry.Position + Vector3.new(0, 5, 0))
    pcall(function()
        hrp.CFrame = cf
    end)
    task.wait(0.2)
    return true
end

function Berry.MainLoop()
    while Berry.Active do
        local alive = A.Alive()
        if not alive then
            task.wait(2)
        else
            local nearest, dist = Berry.GetNearestBerry()
            if nearest then
                if dist then
                    if dist > 8 then
                        Berry.TeleportTo(nearest)
                    else
                        Berry.CollectBerry(nearest)
                    end
                end
            else
                task.wait(2)
            end
        end
        task.wait(0.2)
    end
end

function Berry.Start()
    if Berry.Active then return end
    Berry.Active = true
    Berry.SessionStart = tick()
    Berry.BerryCount = 0
    A.Notify("Berry", "Started berry farming", 3)
    Berry._loop = task.spawn(function()
        Berry.MainLoop()
        Berry.Active = false
    end)
end

function Berry.Stop()
    Berry.Active = false
    if Berry._loop then
        task.cancel(Berry._loop)
        Berry._loop = nil
    end
    A.Notify("Berry", "Stopped", 2)
end

function Berry.GetStats()
    local sessionTime = tick() - Berry.SessionStart
    local rate = Berry.BerryCount / math.max(sessionTime / 60, 1)
    return {
        TotalCollected = Berry.TotalCollected,
        SessionCollected = Berry.BerryCount,
        Rate = string.format("%.1f/min", rate),
        SessionTime = tostring(math.floor(sessionTime / 60)) .. "m " .. tostring(math.floor(sessionTime % 60)) .. "s"
    }
end

A.Berry = Berry
A.Register("berry", A.Berry)
