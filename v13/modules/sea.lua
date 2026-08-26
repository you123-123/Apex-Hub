local A = _G.Apex
local Sea = {}
Sea.Active = false
Sea.SeaBeastKills = 0
Sea.TerrorSharkKills = 0
Sea.SharkAnchorKills = 0
Sea.LeviathanKills = 0
Sea._loop = nil
Sea._boat = nil
Sea._startTick = 0
Sea._lastEvent = nil
Sea._eventTimer = 0
Sea._seaPhase = "sailing"
Sea._targetPosition = nil
Sea._boatSpeed = 100
Sea._maxBoatSpeed = 250
Sea._navigateTarget = nil
Sea._isInDanger = false
Sea._rewards = {}
Sea._totalRewards = {}
Sea._mobKills = 0
Sea._lastSpawnPos = nil
Sea._dangerZones = {}
Sea._safeRadius = 500
Sea._eventCooldowns = {}
Sea._seaBeastSpawned = false
Sea._sharkAnchorSpawned = false
Sea._terrorSharkSpawned = false
Sea._leviathanSpawned = false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Apex Sea] Error: " .. tostring(err))
    end
    return ok, err
end

local SEA_BEAST_NAMES = {"SeaBeast", "Sea Beast", "Shark", "Terror Shark", "Ghost Ship", "Leviathan"}
local TERROR_SHARK_NAMES = {"TerrorShark", "Terror Shark", "TerrorSharkNormal"}
local SHARK_ANCHOR_NAMES = {"SharkAnchor", "Shark Anchor"}
local LEVIATHAN_NAMES = {"Leviathan", "LeviathanBaby", "LeviathanHeart"}

local function FindModelByName(parent, names)
    for _, name in ipairs(names) do
        local model = parent:FindFirstChild(name, true)
        if model then return model end
    end
    for _, child in ipairs(parent:GetDescendants()) do
        if child:IsA("Model") then
            for _, name in ipairs(names) do
                if string.find(string.lower(child.Name), string.lower(name)) then
                    return child
                end
            end
        end
    end
    return nil
end

function Sea.GetSeaEventDistance(eventName)
    local myHRP = A.HRP()
    if not myHRP then return math.huge end
    local names = {}
    if eventName == "seabeast" then
        names = SEA_BEAST_NAMES
    elseif eventName == "terrorshark" then
        names = TERROR_SHARK_NAMES
    elseif eventName == "sharkanchor" then
        names = SHARK_ANCHOR_NAMES
    elseif eventName == "leviathan" then
        names = LEVIATHAN_NAMES
    end
    local model = FindModelByName(Workspace, names)
    if model then
        local part = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
        if part then
            return (myHRP.Position - part.Position).Magnitude
        end
    end
    return math.huge
end

function Sea.IsSeaEventActive(eventName)
    local dist = Sea.GetSeaEventDistance(eventName)
    return dist < 2000
end

function Sea.SpawnBoat()
    local ok, err = SafeCall(function()
        local boatSpawns = Workspace:FindFirstChild("BoatSpawns") or Workspace:FindFirstChild("Boat_Spawns")
        if not boatSpawns then
            for _, child in ipairs(Workspace:GetDescendants()) do
                if string.find(string.lower(child.Name), "boat") and string.find(string.lower(child.Name), "spawn") then
                    boatSpawns = child
                    break
                end
            end
        end
        if boatSpawns then
            for _, spawn in ipairs(boatSpawns:GetDescendants()) do
                if spawn:IsA("BasePart") or spawn:IsA("Model") then
                    local pos = spawn:IsA("BasePart") and spawn.Position or (spawn.PrimaryPart and spawn.PrimaryPart.Position)
                    if pos then
                        A.TpTo(pos + Vector3.new(0, 10, 0), 100)
                        task.wait(1)
                        break
                    end
                end
            end
        end
        local args = {}
        local buyBoat = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("BuyBoat")
        if buyBoat then
            buyBoat:FireServer(unpack(args))
        end
    end)
    return ok
end

function Sea.GetBoat()
    local lp = A.LP
    if not lp then return nil end
    local chars = Workspace:FindFirstChild("Characters") or Workspace
    for _, model in ipairs(chars:GetChildren()) do
        if model:IsA("Model") then
            local isBoat = string.find(string.lower(model.Name), "boat") or
                string.find(string.lower(model.Name), "ship") or
                string.find(string.lower(model.Name), "sloop") or
                string.find(string.lower(model.Name), "brigand") or
                string.find(string.lower(model.Name), "galleon")
            if isBoat then
                local boatSeat = model:FindFirstChildWhichIsA("VehicleSeat") or model:FindFirstChildWhichIsA("Seat")
                if boatSeat then
                    return model
                end
            end
        end
    end
    return nil
end

function Sea.SailBoat(boat, destination)
    if not boat then return false end
    local seat = boat:FindFirstChildWhichIsA("VehicleSeat") or boat:FindFirstChildWhichIsA("Seat")
    if not seat then return false end
    local seatPos = seat.Position
    local myHRP = A.HRP()
    if not myHRP then return false end
    local distToSeat = (myHRP.Position - seatPos).Magnitude
    if distToSeat > 30 then
        A.TpTo(seatPos + Vector3.new(0, 5, 0), 100)
        return true
    end
    if destination then
        local dir = (destination - seatPos).Unit
        local boatHRP = boat.PrimaryPart or seat
        if boatHRP then
            local currentDir = boatHRP.CFrame.LookVector
            local angle = math.acos(math.clamp(currentDir:Dot(dir), -1, 1))
            if angle > 0.1 then
                local newCF = CFrame.new(seatPos, seatPos + dir)
                seat.CFrame = newCF
            end
            local boatSpeed = Sea._boatSpeed
            local forward = boatHRP.CFrame.LookVector * boatSpeed * 0.1
            boat:SetPrimaryPartCFrame(boatHRP.CFrame + forward)
        end
    end
    return true
end

function Sea.NavigateSea(destination, maxDist)
    maxDist = maxDist or 5000
    local boat = Sea.GetBoat()
    if not boat then
        Sea.SpawnBoat()
        task.wait(3)
        boat = Sea.GetBoat()
        if not boat then return false end
    end
    local myHRP = A.HRP()
    if not myHRP then return false end
    local seat = boat:FindFirstChildWhichIsA("VehicleSeat")
    if seat then
        local dist = (myHRP.Position - seat.Position).Magnitude
        if dist > 20 then
            A.TpTo(seat.Position, 100)
            return true
        end
    end
    local boatPart = boat.PrimaryPart or boat:FindFirstChildWhichIsA("BasePart")
    if not boatPart then return false end
    local distToDest = (boatPart.Position - destination).Magnitude
    if distToDest < 200 then
        return true
    end
    Sea.SailBoat(boat, destination)
    return false
end

function Sea.FindSeaBeast()
    return FindModelByName(Workspace, SEA_BEAST_NAMES)
end

function Sea.FightSeaBeast(mob)
    if not mob then return false end
    local part = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChildWhichIsA("BasePart")
    if not part then return false end
    local myHRP = A.HRP()
    if not myHRP then return false end
    local dist = (myHRP.Position - part.Position).Magnitude
    if dist > 500 then
        A.TpTo(part.Position, 200)
        return true
    end
    if dist > 100 then
        A.TweenTo(part.Position, 300)
    end
    local hum = mob:FindFirstChild("Humanoid")
    if hum and hum.Health > 0 then
        A.SuperAttack(mob)
    end
    return true
end

function Sea.KillSeaBeast()
    local mob = Sea.FindSeaBeast()
    if not mob then return false end
    local maxAttempts = 120
    local attempts = 0
    while mob and mob.Parent and Sea.Active do
        attempts = attempts + 1
        if attempts > maxAttempts then break end
        local hum = mob:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then
            Sea.SeaBeastKills = Sea.SeaBeastKills + 1
            Sea._mobKills = Sea._mobKills + 1
            A.Notify("Sea Beast", "Killed! Total: " .. tostring(Sea.SeaBeastKills), 3)
            return true
        end
        Sea.FightSeaBeast(mob)
        task.wait(0.2)
    end
    return false
end

function Sea.FindTerrorShark()
    return FindModelByName(Workspace, TERROR_SHARK_NAMES)
end

function Sea.FightTerrorShark(mob)
    if not mob then return false end
    local part = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChildWhichIsA("BasePart")
    if not part then return false end
    local myHRP = A.HRP()
    if not myHRP then return false end
    local dist = (myHRP.Position - part.Position).Magnitude
    if dist > 400 then
        A.TpTo(part.Position, 150)
        return true
    end
    if dist > 80 then
        A.TweenTo(part.Position, 250)
    end
    local hum = mob:FindFirstChild("Humanoid")
    if hum and hum.Health > 0 then
        A.SuperAttack(mob)
    end
    return true
end

function Sea.KillTerrorShark()
    local mob = Sea.FindTerrorShark()
    if not mob then return false end
    local maxAttempts = 90
    local attempts = 0
    while mob and mob.Parent and Sea.Active do
        attempts = attempts + 1
        if attempts > maxAttempts then break end
        local hum = mob:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then
            Sea.TerrorSharkKills = Sea.TerrorSharkKills + 1
            Sea._mobKills = Sea._mobKills + 1
            A.Notify("Terror Shark", "Killed! Total: " .. tostring(Sea.TerrorSharkKills), 3)
            return true
        end
        Sea.FightTerrorShark(mob)
        task.wait(0.2)
    end
    return false
end

function Sea.FindSharkAnchor()
    return FindModelByName(Workspace, SHARK_ANCHOR_NAMES)
end

function Sea.FightSharkAnchor(mob)
    if not mob then return false end
    local part = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChildWhichIsA("BasePart")
    if not part then return false end
    local myHRP = A.HRP()
    if not myHRP then return false end
    local dist = (myHRP.Position - part.Position).Magnitude
    if dist > 600 then
        A.TpTo(part.Position, 200)
        return true
    end
    if dist > 100 then
        A.TweenTo(part.Position, 300)
    end
    local hum = mob:FindFirstChild("Humanoid")
    if hum and hum.Health > 0 then
        A.SuperAttack(mob)
    end
    return true
end

function Sea.KillSharkAnchor()
    local mob = Sea.FindSharkAnchor()
    if not mob then return false end
    local maxAttempts = 100
    local attempts = 0
    while mob and mob.Parent and Sea.Active do
        attempts = attempts + 1
        if attempts > maxAttempts then break end
        local hum = mob:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then
            Sea.SharkAnchorKills = Sea.SharkAnchorKills + 1
            Sea._mobKills = Sea._mobKills + 1
            A.Notify("Shark Anchor", "Killed! Total: " .. tostring(Sea.SharkAnchorKills), 3)
            return true
        end
        Sea.FightSharkAnchor(mob)
        task.wait(0.2)
    end
    return false
end

function Sea.FindLeviathan()
    return FindModelByName(Workspace, LEVIATHAN_NAMES)
end

function Sea.FightLeviathan(mob)
    if not mob then return false end
    local heart = mob:FindFirstChild("Heart") or mob:FindFirstChild("LeviathanHeart")
    local part = heart or mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChildWhichIsA("BasePart")
    if not part then return false end
    local myHRP = A.HRP()
    if not myHRP then return false end
    local dist = (myHRP.Position - part.Position).Magnitude
    if dist > 800 then
        A.TpTo(part.Position, 300)
        return true
    end
    if dist > 150 then
        A.TweenTo(part.Position, 400)
    end
    A.SuperAttack(mob)
    return true
end

function Sea.KillLeviathan()
    local mob = Sea.FindLeviathan()
    if not mob then return false end
    local maxAttempts = 180
    local attempts = 0
    while mob and mob.Parent and Sea.Active do
        attempts = attempts + 1
        if attempts > maxAttempts then break end
        local heart = mob:FindFirstChild("Heart") or mob:FindFirstChild("LeviathanHeart")
        if heart then
            local hHum = heart:FindFirstChild("Humanoid")
            if hHum and hHum.Health <= 0 then
                Sea.LeviathanKills = Sea.LeviathanKills + 1
                Sea._mobKills = Sea._mobKills + 1
                A.Notify("Leviathan", "Killed! Total: " .. tostring(Sea.LeviathanKills), 3)
                return true
            end
        end
        local mainHum = mob:FindFirstChild("Humanoid")
        if mainHum and mainHum.Health <= 0 then
            Sea.LeviathanKills = Sea.LeviathanKills + 1
            Sea._mobKills = Sea._mobKills + 1
            A.Notify("Leviathan", "Killed! Total: " .. tostring(Sea.LeviathanKills), 3)
            return true
        end
        Sea.FightLeviathan(mob)
        task.wait(0.2)
    end
    return false
end

function Sea.WaitForSeaEvent(eventName, timeout)
    timeout = timeout or 120
    local startTick = tick()
    while Sea.Active and (tick() - startTick) < timeout do
        if Sea.IsSeaEventActive(eventName) then
            return true
        end
        task.wait(1)
    end
    return false
end

function Sea.SeaEventTimer(eventName)
    local cd = Sea._eventCooldowns[eventName]
    if cd and (tick() - cd) < 300 then
        return 300 - (tick() - cd)
    end
    return 0
end

function Sea.GetSeaRewards()
    local rewards = {}
    local lp = A.LP
    if not lp then return rewards end
    local backpack = lp:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Accessory") then
                table.insert(rewards, {
                    Name = item.Name,
                    Type = item.ClassName,
                    Source = "Backpack"
                })
            end
        end
    end
    if lp.Character then
        for _, item in ipairs(lp.Character:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Accessory") then
                table.insert(rewards, {
                    Name = item.Name,
                    Type = item.ClassName,
                    Source = "Equipped"
                })
            end
        end
    end
    return rewards
end

function Sea.CollectLoot()
    local myHRP = A.HRP()
    if not myHRP then return end
    local items = Workspace:FindFirstChild("Items") or Workspace:FindFirstChild("DroppedItems")
    if not items then
        for _, child in ipairs(Workspace:GetChildren()) do
            if string.find(string.lower(child.Name), "item") or string.find(string.lower(child.Name), "drop") then
                items = child
                break
            end
        end
    end
    if items then
        for _, item in ipairs(items:GetChildren()) do
            if item:IsA("BasePart") then
                local dist = (myHRP.Position - item.Position).Magnitude
                if dist < 200 then
                    A.TpTo(item.Position, 50)
                    task.wait(0.5)
                end
            end
        end
    end
end

function Sea.SafeSea()
    if not A.Alive() then return true end
    local hum = A.Hum()
    if hum and hum.Health / math.max(hum.MaxHealth, 1) < 0.15 then
        local myHRP = A.HRP()
        if myHRP then
            local safePos = myHRP.Position + Vector3.new(0, 300, 0)
            A.TpTo(safePos, 100)
        end
        return true
    end
    return false
end

function Sea.FarmAllSeaEvents()
    if Sea.SafeSea() then return end
    if Sea.IsSeaEventActive("seabeast") then
        Sea.KillSeaBeast()
        return
    end
    if Sea.IsSeaEventActive("terrorshark") then
        Sea.KillTerrorShark()
        return
    end
    if Sea.IsSeaEventActive("sharkanchor") then
        Sea.KillSharkAnchor()
        return
    end
    if Sea.IsSeaEventActive("leviathan") then
        Sea.KillLeviathan()
        return
    end
    if Sea._navigateTarget then
        if Sea.NavigateSea(Sea._navigateTarget) then
            Sea._navigateTarget = nil
        end
    end
end

function Sea.SeaEventHop()
    A.Notify("Sea Hop", "Hopping for sea events...", 3)
    local HttpService = game:GetService("HttpService")
    local ok, res = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)
    if ok and res and res.data then
        local servers = {}
        for _, srv in ipairs(res.data) do
            if srv.id ~= game.JobId and srv.playing >= 5 then
                table.insert(servers, srv)
            end
        end
        if #servers > 0 then
            table.sort(servers, function(a, b) return (a.playing or 0) > (b.playing or 0) end)
            local chosen = servers[1]
            if chosen and chosen.id then
                pcall(function()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, chosen.id, A.LP)
                end)
                return true
            end
        end
    end
    return false
end

function Sea.GetSeaStats()
    local sessionTime = tick() - Sea._startTick
    local minutes = math.floor(sessionTime / 60)
    local seconds = math.floor(sessionTime % 60)
    return {
        SeaBeastKills = Sea.SeaBeastKills,
        TerrorSharkKills = Sea.TerrorSharkKills,
        SharkAnchorKills = Sea.SharkAnchorKills,
        LeviathanKills = Sea.LeviathanKills,
        TotalKills = Sea._mobKills,
        SessionTime = string.format("%dm %ds", minutes, seconds),
        Phase = Sea._seaPhase,
        BoatSpeed = Sea._boatSpeed,
        HasBoat = Sea.GetBoat() ~= nil
    }
end

function Sea.MainLoop()
    while Sea.Active do
        if not A.Alive() then
            task.wait(2)
            break
        end
        SafeCall(function()
            Sea.FarmAllSeaEvents()
        end)
        task.wait(0.5)
    end
end

function Sea.Start(navigateTo)
    if Sea.Active then return end
    Sea.Active = true
    Sea._startTick = tick()
    Sea._seaPhase = "sailing"
    if navigateTo then
        Sea._navigateTarget = navigateTo
    end
    A.Notify("Sea Events", "Started sea event farming", 3)
    Sea._loop = task.spawn(function()
        Sea.MainLoop()
        Sea.Active = false
    end)
end

function Sea.Stop()
    Sea.Active = false
    Sea._navigateTarget = nil
    if Sea._loop then
        task.cancel(Sea._loop)
        Sea._loop = nil
    end
    A.Notify("Sea Events", "Stopped", 2)
end

A.SeaEvents = Sea
A.Register("sea", A.SeaEvents)
