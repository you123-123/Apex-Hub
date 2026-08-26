-- Apex Hub v13.0 | Character Management System
-- Handles all character accessors, data reading, monitoring, combat state, tools, and more

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local A = _G.Apex or {}

local CharacterConnections = {}
local HealthConnections = {}
local RespawnCallbacks = {}
local DeathCallbacks = {}
local HealthChangeCallbacks = {}

A.LastPosition = nil
A.PositionHistory = {}
A.StuckTimer = 0
A.StuckThreshold = 0.5
A.StuckCheckInterval = 1.0
local PositionTrackConnection = nil

local function SafeCall(fn, ...)
    local ok, result = pcall(fn, ...)
    if ok then return result end
    return nil
end

local function GetCharacter()
    return LocalPlayer and LocalPlayer.Character
end

local function GetHumanoid()
    local char = GetCharacter()
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function GetData()
    local ok, data = pcall(function()
        local d = LocalPlayer:FindFirstChild("Data")
        if not d then return nil end
        return d
    end)
    if ok then return data end
    return nil
end

local function GetReplicatedStorage()
    local ok, remotes = pcall(function()
        return ReplicatedStorage:FindFirstChild("Remotes")
    end)
    if ok then return remotes end
    return nil
end

local function CommF(...)
    local remotes = GetReplicatedStorage()
    if not remotes then return nil end
    local comm = remotes:FindFirstChild("CommF_")
    if not comm then return nil end
    return SafeCall(comm.InvokeServer, comm, ...)
end

local function CommF2(...)
    local remotes = GetReplicatedStorage()
    if not remotes then return nil end
    local comm = remotes:FindFirstChild("CommF2")
    if not comm then return nil end
    return SafeCall(comm.InvokeServer, comm, ...)
end

local function GetDataValue(name)
    local data = GetData()
    if not data then return nil end
    local values = data:FindFirstChild("Values")
    if not values then return nil end
    local val = values:FindFirstChild(name)
    if not val then return nil end
    return val.Value
end

local function GetDataValueFolder()
    local data = GetData()
    if not data then return nil end
    return data:FindFirstChild("Values")
end

-- ==============================
-- 1. Core Character Accessors
-- ==============================

function A.Alive()
    local char = GetCharacter()
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local alive = false
    SafeCall(function()
        alive = hum.Health > 0
    end)
    if not alive then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not hrp then return false end
    return true
end

function A.Char()
    return GetCharacter()
end

function A.Hum()
    return GetHumanoid()
end

function A.HRP()
    local char = GetCharacter()
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then return hrp end
    local torso = char:FindFirstChild("Torso")
    if torso then return torso end
    local root = char:FindFirstChild("RootPart")
    if root then return root end
    local primary = char.PrimaryPart
    if primary then return primary end
    return nil
end

function A.Head()
    local char = GetCharacter()
    if not char then return nil end
    return char:FindFirstChild("Head")
end

function A.RootPart()
    return A.HRP()
end

function A.Torso()
    local char = GetCharacter()
    if not char then return nil end
    local torso = char:FindFirstChild("Torso")
    if torso then return torso end
    local upper = char:FindFirstChild("UpperTorso")
    if upper then return upper end
    local lower = char:FindFirstChild("LowerTorso")
    if lower then return lower end
    return nil
end

function A.LeftArm()
    local char = GetCharacter()
    if not char then return nil end
    local la = char:FindFirstChild("Left Arm")
    if la then return la end
    return char:FindFirstChild("LeftHand")
end

function A.RightArm()
    local char = GetCharacter()
    if not char then return nil end
    local ra = char:FindFirstChild("Right Arm")
    if ra then return ra end
    return char:FindFirstChild("RightHand")
end

function A.LeftLeg()
    local char = GetCharacter()
    if not char then return nil end
    local ll = char:FindFirstChild("Left Leg")
    if ll then return ll end
    return char:FindFirstChild("LeftFoot")
end

function A.RightLeg()
    local char = GetCharacter()
    if not char then return nil end
    local rl = char:FindFirstChild("Right Leg")
    if rl then return rl end
    return char:FindFirstChild("RightFoot")
end

function A.HumanoidHealth()
    local hum = GetHumanoid()
    if not hum then return 0 end
    local ok, health = pcall(function() return hum.Health end)
    if ok and health then return health end
    return 0
end

function A.HumanoidMaxHealth()
    local hum = GetHumanoid()
    if not hum then return 0 end
    local ok, max = pcall(function() return hum.MaxHealth end)
    if ok and max then return max end
    return 0
end

function A.HealthPercent()
    local health = A.HumanoidHealth()
    local max = A.HumanoidMaxHealth()
    if max == 0 then return 0 end
    return (health / max) * 100
end

function A.HumanoidMoveTo(pos)
    local hum = GetHumanoid()
    if not hum then return false end
    if typeof(pos) ~= "Vector3" then return false end
    local ok = SafeCall(function()
        hum:MoveTo(pos)
    end)
    return ok ~= nil
end

function A.HumanoidJump()
    local hum = GetHumanoid()
    if not hum then return false end
    local ok = SafeCall(function()
        hum.Jump = true
    end)
    return ok ~= nil
end

function A.HumanoidSit()
    local hum = GetHumanoid()
    if not hum then return false end
    local ok = SafeCall(function()
        hum.Sit = true
    end)
    return ok ~= nil
end

function A.HumanoidStand()
    local hum = GetHumanoid()
    if not hum then return false end
    local ok = SafeCall(function()
        hum.Sit = false
    end)
    return ok ~= nil
end

function A.GetPosition()
    local hrp = A.HRP()
    if not hrp then return Vector3.new(0, 0, 0) end
    local ok, pos = pcall(function() return hrp.Position end)
    if ok and pos then return pos end
    return Vector3.new(0, 0, 0)
end

function A.GetCF()
    local hrp = A.HRP()
    if not hrp then return CFrame.new(0, 0, 0) end
    local ok, cf = pcall(function() return hrp.CFrame end)
    if ok and cf then return cf end
    return CFrame.new(0, 0, 0)
end

-- ==============================
-- 2. Level and Data Access
-- ==============================

function A.Lv()
    local v = GetDataValue("Level")
    if v then return v end
    return 1
end

function A.Exp()
    local v = GetDataValue("Exp")
    if v then return v end
    return 0
end

function A.Money()
    local v = GetDataValue("Beli")
    if v then return v end
    return 0
end

function A.Fragments()
    local v = GetDataValue("Fragments")
    if v then return v end
    return 0
end

function A.Race()
    local v = GetDataValue("Race")
    if v then return v end
    return "Unknown"
end

function A.Title()
    local v = GetDataValue("Title")
    if v then return v end
    return ""
end

function A.GetBountyValue()
    local ok, bounty = pcall(function()
        return LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Bounty") and LocalPlayer.leaderstats.Bounty.Value or 0
    end)
    if ok and bounty then return bounty end
    local v = GetDataValue("Bounty")
    if v then return v end
    return 0
end

function A.Honor()
    local ok, honor = pcall(function()
        return LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Honor") and LocalPlayer.leaderstats.Honor.Value or 0
    end)
    if ok and honor then return honor end
    local v = GetDataValue("Honor")
    if v then return v end
    return 0
end

function A.MeleeLevel()
    local v = GetDataValue("Melee")
    if v then return v end
    return 0
end

function A.DefenseLevel()
    local v = GetDataValue("Defense")
    if v then return v end
    return 0
end

function A.FruitLevel()
    local v = GetDataValue("Blox Fruit")
    if v then return v end
    local v2 = GetDataValue("Fruit")
    if v2 then return v2 end
    return 0
end

function A.SwordLevel()
    local v = GetDataValue("Sword")
    if v then return v end
    return 0
end

function A.GunLevel()
    local v = GetDataValue("Gun")
    if v then return v end
    return 0
end

function A.SniperLevel()
    local v = GetDataValue("Sniper")
    if v then return v end
    return 0
end

function A.Points()
    local v = GetDataValue("Points")
    if v then return v end
    return 0
end

function A.StatPoints()
    return A.Points()
end

function A.TotalStatPoints()
    return A.MeleeLevel() + A.DefenseLevel() + A.FruitLevel() + A.SwordLevel() + A.GunLevel()
end

-- ==============================
-- 3. Team Management
-- ==============================

function A.Team()
    return LocalPlayer and LocalPlayer.Team
end

function A.TeamName()
    local team = A.Team()
    if team then return team.Name end
    return "None"
end

function A.IsPirate()
    local name = A.TeamName()
    return name == "Pirates" or name == "Marine" and false or false
end

function A.IsMarine()
    local name = A.TeamName()
    return name == "Marines"
end

function A.SwitchTeam(name)
    if type(name) ~= "string" or name == "" then return false end
    if A.TeamName() == name then return true end
    local ok = SafeCall(function()
        CommF("SetTeam", name)
    end)
    return ok ~= nil
end

function A.GetClosestTeammate()
    local pos = A.GetPosition()
    local closest = nil
    local closestDist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team == A.Team() then
            local pChar = player.Character
            if pChar then
                local pHRP = pChar:FindFirstChild("HumanoidRootPart") or pChar:FindFirstChild("Torso")
                if pHRP then
                    local dist = (pHRP.Position - pos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest, closestDist
end

function A.GetClosestEnemy()
    local pos = A.GetPosition()
    local closest = nil
    local closestDist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= A.Team() then
            local pChar = player.Character
            if pChar then
                local pHumanoid = pChar:FindFirstChildOfClass("Humanoid")
                local pHRP = pChar:FindFirstChild("HumanoidRootPart") or pChar:FindFirstChild("Torso")
                if pHRP and pHumanoid and pHumanoid.Health > 0 then
                    local dist = (pHRP.Position - pos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest, closestDist
end

function A.TeamCount()
    local count = 0
    local team = A.Team()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Team == team then
            count = count + 1
        end
    end
    return count
end

function A.EnemyCount()
    local count = 0
    local team = A.Team()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= team then
            local pChar = player.Character
            if pChar then
                local pHum = pChar:FindFirstChildOfClass("Humanoid")
                if pHum and pHum.Health > 0 then
                    count = count + 1
                end
            end
        end
    end
    return count
end

-- ==============================
-- 4. Character Monitoring
-- ==============================

function A.WatchCharacter(fn)
    if type(fn) ~= "function" then return nil end
    local conn = nil
    local function setup()
        local char = GetCharacter()
        if not char then return end
        if conn then
            SafeCall(function() conn:Disconnect() end)
        end
        conn = char.ChildAdded:Connect(function(child)
            if child.Name == "Humanoid" then
                local hum = child
                hum.Died:Connect(function()
                    fn("Died")
                end)
            end
        end)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function()
                fn("Died")
            end)
        end
    end
    setup()
    local charAddedConn = LocalPlayer.CharacterAdded:Connect(function()
        setup()
        fn("Respawned")
    end)
    table.insert(CharacterConnections, conn)
    table.insert(CharacterConnections, charAddedConn)
    return {
        Disconnect = function()
            if conn then SafeCall(function() conn:Disconnect() end) end
            if charAddedConn then SafeCall(function() charAddedConn:Disconnect() end) end
        end
    }
end

function A.OnRespawn(fn)
    if type(fn) ~= "function" then return nil end
    table.insert(RespawnCallbacks, fn)
    local conn = LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then
            char:WaitForChild("Humanoid", 5)
        end
        fn(char)
    end)
    table.insert(CharacterConnections, conn)
    return {
        Disconnect = function()
            if conn then SafeCall(function() conn:Disconnect() end) end
            for i, cb in pairs(RespawnCallbacks) do
                if cb == fn then
                    table.remove(RespawnCallbacks, i)
                    break
                end
            end
        end
    }
end

function A.OnDeath(fn)
    if type(fn) ~= "function" then return nil end
    table.insert(DeathCallbacks, fn)
    local conn = nil
    local function setup()
        local char = GetCharacter()
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            conn = hum.Died:Connect(function()
                fn(char, hum)
            end)
        end
    end
    setup()
    local charAddedConn = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.3)
        setup()
    end)
    table.insert(CharacterConnections, conn)
    table.insert(CharacterConnections, charAddedConn)
    return {
        Disconnect = function()
            if conn then SafeCall(function() conn:Disconnect() end) end
            if charAddedConn then SafeCall(function() charAddedConn:Disconnect() end) end
            for i, cb in pairs(DeathCallbacks) do
                if cb == fn then
                    table.remove(DeathCallbacks, i)
                    break
                end
            end
        end
    }
end

function A.OnHealthChange(fn)
    if type(fn) ~= "function" then return nil end
    table.insert(HealthChangeCallbacks, fn)
    local conn = nil
    local function setup()
        local char = GetCharacter()
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if conn then SafeCall(function() conn:Disconnect() end) end
            conn = hum.HealthChanged:Connect(function(newHealth)
                fn(newHealth, hum.MaxHealth)
            end)
        end
    end
    setup()
    local charAddedConn = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.3)
        setup()
    end)
    table.insert(HealthConnections, conn)
    table.insert(HealthConnections, charAddedConn)
    return {
        Disconnect = function()
            if conn then SafeCall(function() conn:Disconnect() end) end
            if charAddedConn then SafeCall(function() charAddedConn:Disconnect() end) end
            for i, cb in pairs(HealthChangeCallbacks) do
                if cb == fn then
                    table.remove(HealthChangeCallbacks, i)
                    break
                end
            end
        end
    }
end

function A.DeathWait(timeout)
    timeout = timeout or 30
    local char = GetCharacter()
    if not char then
        char = LocalPlayer.CharacterAdded:Wait()
    end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then
        local t = 0
        while t < timeout do
            task.wait(0.2)
            t = t + 0.2
            local newChar = GetCharacter()
            if newChar then
                local newHum = newChar:FindFirstChildOfClass("Humanoid")
                if newHum and newHum.Health > 0 then
                    return newChar
                end
            end
        end
    end
    return GetCharacter()
end

function A.RespawnWait(timeout)
    timeout = timeout or 15
    local char = GetCharacter()
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            return char
        end
    end
    local t = 0
    while t < timeout do
        task.wait(0.3)
        t = t + 0.3
        local newChar = GetCharacter()
        if newChar then
            local newHum = newChar:FindFirstChildOfClass("Humanoid")
            if newHum and newHum.Health > 0 then
                local hrp = newChar:FindFirstChild("HumanoidRootPart") or newChar:FindFirstChild("Torso")
                if hrp then
                    return newChar
                end
            end
        end
    end
    return GetCharacter()
end

function A.WaitForCharacter(timeout)
    timeout = timeout or 30
    local t = 0
    while t < timeout do
        local char = GetCharacter()
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
            if hum and hrp and hum.Health > 0 then
                return char
            end
        end
        task.wait(0.3)
        t = t + 0.3
    end
    return GetCharacter()
end

function A.DisconnectAllCharacter()
    for _, conn in pairs(CharacterConnections) do
        if conn then
            SafeCall(function() conn:Disconnect() end)
        end
    end
    for _, conn in pairs(HealthConnections) do
        if conn then
            SafeCall(function() conn:Disconnect() end)
        end
    end
    CharacterConnections = {}
    HealthConnections = {}
end

-- ==============================
-- 5. Sea Detection
-- ==============================

local SeaZones = {
    FirstSea = {
        min = Vector3.new(-3500, 0, -5500),
        max = Vector3.new(8000, 200, 6000),
    },
    SecondSea = {
        min = Vector3.new(-6500, 0, -6500),
        max = Vector3.new(6500, 200, 6500),
    },
    ThirdSea = {
        min = Vector3.new(-6000, 0, -6000),
        max = Vector3.new(6000, 200, 6000),
    },
}

local SafeZonePositions = {
    Vector3.new(614, 3, 661),
    Vector3.new(1538, 18, 208),
    Vector3.new(-3029, 38, -814),
    Vector3.new(3023, 31, -894),
    Vector3.new(-285, 34, -1332),
    Vector3.new(332, 30, -1332),
    Vector3.new(-580, 5, 4100),
    Vector3.new(284, 45, 3745),
}

function A.Sea()
    local pos = A.GetPosition()
    if pos == Vector3.new(0, 0, 0) then return 1 end
    local ok, result = SafeCall(function()
        local level = A.Lv()
        if level then
            if level <= 700 then
                return 1
            elseif level <= 1500 then
                return 2
            else
                return 3
            end
        end
        return 1
    end)
    if ok and result then return result end
    return 1
end

function A.SeaName()
    local sea = A.Sea()
    if sea == 1 then return "First Sea" end
    if sea == 2 then return "Second Sea" end
    if sea == 3 then return "Third Sea" end
    return "Unknown Sea"
end

function A.InSafeZone()
    local pos = A.GetPosition()
    for _, safePos in pairs(SafeZonePositions) do
        local dist = (pos - safePos).Magnitude
        if dist < 200 then
            return true
        end
    end
    return false
end

function A.InPVP()
    if A.InSafeZone() then return false end
    local combatState = A.InCombat()
    return combatState
end

-- ==============================
-- 6. Combat State
-- ==============================

local CombatState = {
    lastDamageTime = 0,
    lastDamageTaken = 0,
    lastDamageDealt = 0,
    inCombatTimer = 0,
}

local CombatDuration = 5

function A.InCombat()
    local currentTime = tick()
    local timeSinceTaken = currentTime - CombatState.lastDamageTaken
    local timeSinceDealt = currentTime - CombatState.lastDamageDealt
    if timeSinceTaken < CombatDuration or timeSinceDealt < CombatDuration then
        return true
    end
    return false
end

function A.InCFrame()
    local pos = A.GetCF()
    local lastCF = A._lastCFrame
    if not lastCF then
        A._lastCFrame = pos
        return false
    end
    local dist = (pos.Position - lastCF.Position).Magnitude
    A._lastCFrame = pos
    return dist < 0.01
end

function A.CombatTime()
    local currentTime = tick()
    local timeSinceTaken = currentTime - CombatState.lastDamageTaken
    local timeSinceDealt = currentTime - CombatState.lastDamageDealt
    return math.min(timeSinceTaken, timeSinceDealt)
end

function A.IsAttacking()
    local hum = GetHumanoid()
    if not hum then return false end
    local char = GetCharacter()
    if not char then return false end
    local ok, result = SafeCall(function()
        for _, anim in pairs(hum:GetPlayingAnimationTracks()) do
            local name = anim.Name:lower()
            if name:find("attack") or name:find("slash") or name:find("punch") or name:find("kick") or name:find("swing") then
                return true
            end
        end
        return false
    end)
    if ok then return result end
    return false
end

function A.CanAttack()
    if not A.Alive() then return false end
    if A.IsStunned() then return false end
    if A.InCutscene() then return false end
    return true
end

function A.IsStunned()
    local hum = GetHumanoid()
    if not hum then return false end
    local ok, result = SafeCall(function()
        local char = GetCharacter()
        if not char then return false end
        local stun = char:FindFirstChild("Stun") or char:FindFirstChild("Stunned")
        if stun and stun:IsA("BoolValue") then
            return stun.Value
        end
        if hum.PlatformStand then
            return true
        end
        return false
    end)
    if ok then return result end
    return false
end

function A.InCutscene()
    local ok, result = SafeCall(function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return false end
        local cgs = playerGui:FindFirstChild("CutsceneGui") or playerGui:FindFirstChild("Cutscene")
        if cgs then return true end
        return false
    end)
    if ok then return result end
    return false
end

function A.TrackCombatDamage()
    local char = GetCharacter()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local lastHealth = hum.Health
    local conn = hum.HealthChanged:Connect(function(newHealth)
        local currentTime = tick()
        if newHealth < lastHealth then
            CombatState.lastDamageTaken = currentTime
            CombatState.lastDamageTime = currentTime
        elseif newHealth > lastHealth then
            CombatState.lastDamageDealt = currentTime
        end
        lastHealth = newHealth
    end)
    table.insert(CharacterConnections, conn)
end

-- ==============================
-- 7. Tool Management
-- ==============================

function A.GetTool(name)
    if type(name) ~= "string" then return nil end
    local char = GetCharacter()
    if not char then return nil end
    local tool = char:FindFirstChild(name)
    if tool and tool:IsA("Tool") then return tool end
    tool = char:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find(name:lower()) then return tool end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        tool = backpack:FindFirstChild(name)
        if tool and tool:IsA("Tool") then return tool end
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") and child.Name:lower():find(name:lower()) then
                return child
            end
        end
    end
    return nil
end

function A.EquipTool(tool)
    if not tool then return false end
    if not tool:IsA("Tool") then return false end
    local ok = SafeCall(function()
        tool.Parent = GetCharacter()
    end)
    return ok ~= nil
end

function A.UnequipTool()
    local char = GetCharacter()
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return false end
    local ok = SafeCall(function()
        tool.Parent = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer
    end)
    return ok ~= nil
end

function A.GetEquipped()
    local char = GetCharacter()
    if not char then return nil end
    local tool = char:FindFirstChildOfClass("Tool")
    return tool
end

function A.GetEquippedType()
    local tool = A.GetEquipped()
    if not tool then return "None" end
    local toolName = tool.Name:lower()
    local function checkTags(tags)
        for _, tag in pairs(tags) do
            if toolName:find(tag) or tool:FindFirstChild(tag) then
                return true
            end
        end
        return false
    end
    if checkTags({"sword", "blade", "katana", "saber", "scythe", "dual", "saw", "cutter", "Claw", "Anchor", "Trident", "Rapier"}) then
        return "Sword"
    end
    if checkTags({"gun", "pistol", "musket", "blunderbuss", "cannon", "sniper", "rifle", "flintlock", "pocket"}) then
        return "Gun"
    end
    if checkTags({"melee", "fight", "combat", "box", "electric", "dark", "death", "superhuman", "shark", "dragon", "talon", "god", "slayer", "bone"}) then
        return "Melee"
    end
    if checkTags({"fruit", "blox fruit", "paramecia", "logia", "zoan", " mythical"}) then
        return "Blox Fruit"
    end
    if tool:FindFirstChild("remote") or tool:FindFirstChild("RemoteEvent") then
        return "Blox Fruit"
    end
    return "Unknown"
end

function A.GetToolDamage(tool)
    if not tool then return 0 end
    local ok, dmg = SafeCall(function()
        local toolData = tool:FindFirstChild("ToolData")
        if toolData then
            local damage = toolData:FindFirstChild("Damage")
            if damage then return damage.Value end
        end
        local stats = tool:FindFirstChild("Stats")
        if stats then
            local damage = stats:FindFirstChild("Damage")
            if damage then return damage.Value end
        end
        if tool.ToolTip and tool.ToolTip:find("Damage") then
            local nums = tool.ToolTip:match("(%d+)")
            if nums then return tonumber(nums) or 0 end
        end
        return 0
    end)
    if ok and dmg then return dmg end
    return 0
end

function A.HasWeapon(type)
    if type(type) ~= "string" then return false end
    type = type:lower()
    local char = GetCharacter()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local function checkContainer(container)
        if not container then return false end
        for _, child in pairs(container:GetChildren()) do
            if child:IsA("Tool") then
                local toolName = child.Name:lower()
                if type == "sword" and (toolName:find("sword") or toolName:find("blade") or toolName:find("saber")) then
                    return true
                end
                if type == "gun" and (toolName:find("gun") or toolName:find("pistol") or toolName:find("musket")) then
                    return true
                end
                if type == "melee" and (toolName:find("combat") or toolName:find("fight") or toolName:find("box")) then
                    return true
                end
                if type == "fruit" and child:FindFirstChild("remote") then
                    return true
                end
            end
        end
        return false
    end
    return checkContainer(char) or checkContainer(backpack)
end

function A.GetAllTools()
    local tools = {}
    local char = GetCharacter()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if char then
        for _, child in pairs(char:GetChildren()) do
            if child:IsA("Tool") then
                table.insert(tools, child)
            end
        end
    end
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                table.insert(tools, child)
            end
        end
    end
    return tools
end

-- ==============================
-- 8. Devil Fruit Detection
-- ==============================

function A.GetDevilFruit()
    local char = GetCharacter()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local function search(container)
        if not container then return nil end
        for _, child in pairs(container:GetChildren()) do
            if child:IsA("Tool") then
                if child:FindFirstChild("remote") or child:FindFirstChild("RemoteEvent") then
                    return child
                end
                local name = child.Name:lower()
                if name:find("fruit") then
                    return child
                end
            end
        end
        return nil
    end
    return search(char) or search(backpack)
end

function A.HasFruit()
    return A.GetDevilFruit() ~= nil
end

function A.GetFruitType()
    local fruit = A.GetDevilFruit()
    if not fruit then return "None" end
    local ok, result = SafeCall(function()
        local fruitData = fruit:FindFirstChild("FruitData") or fruit:FindFirstChild("Data")
        if fruitData then
            local fruitType = fruitData:FindFirstChild("Type") or fruitData:FindFirstChild("Class")
            if fruitType and fruitType:IsA("StringValue") then
                return fruitType.Value
            end
        end
        local remote = fruit:FindFirstChild("remote")
        if remote then
            local args = SafeCall(function()
                return remote:InvokeServer("GetData")
            end)
            if args and type(args) == "table" then
                return args.Type or args.FruitType or "Unknown"
            end
        end
        return "Unknown"
    end)
    if ok and result then return result end
    return "Unknown"
end

function A.GetFruitSkills()
    local skills = {}
    local fruit = A.GetDevilFruit()
    if not fruit then return skills end
    local ok = SafeCall(function()
        local remote = fruit:FindFirstChild("remote")
        if remote then
            local args = SafeCall(function()
                return remote:InvokeServer("GetSkills")
            end)
            if args and type(args) == "table" then
                for _, skill in pairs(args) do
                    table.insert(skills, skill)
                end
            end
        end
    end)
    local char = GetCharacter()
    if char then
        local folder = char:FindFirstChild("FruitMoves") or char:FindFirstChild("Abilities")
        if folder then
            for _, child in pairs(folder:GetChildren()) do
                table.insert(skills, child.Name)
            end
        end
    end
    return skills
end

function A.GetFruitMastery()
    local fruit = A.GetDevilFruit()
    if not fruit then return 0 end
    local ok, result = SafeCall(function()
        local data = GetDataValueFolder()
        if data then
            local fruitMastery = data:FindFirstChild("Blox Fruit") or data:FindFirstChild("FruitMastery")
            if fruitMastery then return fruitMastery.Value end
        end
        return 0
    end)
    if ok and result then return result end
    return 0
end

function A.HasAwakening(type)
    if type(type) ~= "string" then return false end
    type = type:lower()
    local fruit = A.GetDevilFruit()
    if not fruit then return false end
    local ok, result = SafeCall(function()
        local remote = fruit:FindFirstChild("remote")
        if remote then
            local data = SafeCall(function()
                return remote:InvokeServer("GetAwakening")
            end)
            if data then
                return true
            end
        end
        local fruitData = fruit:FindFirstChild("FruitData")
        if fruitData then
            local awak = fruitData:FindFirstChild("Awakening") or fruitData:FindFirstChild("Awakened")
            if awak and awak:IsA("BoolValue") then
                return awak.Value
            end
        end
        return false
    end)
    if ok then return result end
    return false
end

function A.GetFruitName()
    local fruit = A.GetDevilFruit()
    if not fruit then return "None" end
    return fruit.Name
end

function A.GetFruitRarity()
    local fruit = A.GetDevilFruit()
    if not fruit then return "None" end
    local ok, result = SafeCall(function()
        local data = fruit:FindFirstChild("FruitData") or fruit:FindFirstChild("Data")
        if data then
            local rarity = data:FindFirstChild("Rarity")
            if rarity then return rarity.Value end
        end
        return "Unknown"
    end)
    if ok and result then return result end
    return "Unknown"
end

-- ==============================
-- 9. Movement State
-- ==============================

function A.IsMoving()
    local hum = GetHumanoid()
    if not hum then return false end
    local ok, result = SafeCall(function()
        return hum.MoveDirection.Magnitude > 0.01
    end)
    if ok then return result end
    return false
end

function A.GetMoveDirection()
    local hum = GetHumanoid()
    if not hum then return Vector3.new(0, 0, 0) end
    local ok, dir = pcall(function() return hum.MoveDirection end)
    if ok and dir then return dir end
    return Vector3.new(0, 0, 0)
end

function A.GetVelocity()
    local hrp = A.HRP()
    if not hrp then return Vector3.new(0, 0, 0) end
    local ok, vel = pcall(function()
        local bf = hrp:FindFirstChildOfClass("BodyForce") or hrp:FindFirstChildOfClass("BodyVelocity")
        if bf and bf:IsA("BodyVelocity") then
            return bf.Velocity
        end
        return hrp.Velocity
    end)
    if ok and vel then return vel end
    return Vector3.new(0, 0, 0)
end

function A.IsFalling()
    local vel = A.GetVelocity()
    return vel.Y < -5
end

function A.IsGrounded()
    local hrp = A.HRP()
    if not hrp then return false end
    local ok, result = SafeCall(function()
        local rayResult = workspace:Raycast(hrp.Position, Vector3.new(0, -6, 0))
        return rayResult ~= nil
    end)
    if ok then return result end
    return false
end

function A.GetSpeed()
    local vel = A.GetVelocity()
    return vel.Magnitude
end

function A.IsFlying()
    local hrp = A.HRP()
    if not hrp then return false end
    local ok, result = SafeCall(function()
        local bodyVelocity = hrp:FindFirstChildOfClass("BodyVelocity")
        local bodyGyro = hrp:FindFirstChildOfClass("BodyGyro")
        local bodyForce = hrp:FindFirstChildOfClass("BodyForce")
        if bodyVelocity or bodyGyro then
            local flyGui = LocalPlayer.PlayerGui:FindFirstChild("FlyGUI")
            if flyGui then return true end
            if bodyVelocity and bodyGyro then
                return true
            end
        end
        local vehicle = hrp:FindFirstChildOfClass("VehicleSeat")
        if vehicle then return false end
        local floating = A.IsFalling() and A.GetSpeed() < 1 and hrp.Position.Y > 100
        if floating then return true end
        return false
    end)
    if ok then return result end
    return false
end

function A.IsNoclipping()
    local char = GetCharacter()
    if not char then return false end
    local ok, result = SafeCall(function()
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                local noclipTag = part:FindFirstChild("CanCollide_orig")
                if noclipTag then return true end
                if part.CanCollide == false and part.Name ~= "HumanoidRootPart" and part.Name ~= "Head" then
                    local rayResult = workspace:Raycast(part.Position, Vector3.new(0, 5, 0))
                    if rayResult and not rayResult.Instance:IsDescendantOf(char) then
                        return true
                    end
                end
            end
        end
        return false
    end)
    if ok then return result end
    return false
end

function A.GetJumpPower()
    local hum = GetHumanoid()
    if not hum then return 0 end
    local ok, jp = pcall(function() return hum.JumpPower end)
    if ok and jp then return jp end
    return 50
end

function A.GetWalkSpeed()
    local hum = GetHumanoid()
    if not hum then return 0 end
    local ok, ws = pcall(function() return hum.WalkSpeed end)
    if ok and ws then return ws end
    return 16
end

-- ==============================
-- 10. Position Tracking
-- ==============================

local function StartPositionTracking()
    if PositionTrackConnection then return end
    PositionTrackConnection = RunService.Heartbeat:Connect(function(dt)
        pcall(function()
            local char = GetCharacter()
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
            if not hrp then return end
            local currentPos = hrp.Position
            A.LastPosition = currentPos
            table.insert(A.PositionHistory, {
                position = currentPos,
                time = tick()
            })
            if #A.PositionHistory > 50 then
                table.remove(A.PositionHistory, 1)
            end
            local lastPos = A._previousTrackPosition
            if lastPos then
                local dist = (currentPos - lastPos).Magnitude
                if dist < 0.1 then
                    A.StuckTimer = A.StuckTimer + dt
                else
                    A.StuckTimer = 0
                end
            end
            A._previousTrackPosition = currentPos
        end)
    end)
end

function A.IsStuck()
    return A.StuckTimer >= A.StuckThreshold
end

function A.Unstuck()
    local hrp = A.HRP()
    if not hrp then return false end
    local ok = SafeCall(function()
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 20, 0)
    end)
    A.StuckTimer = 0
    return ok ~= nil
end

function A.ResetPosition()
    A.LastPosition = A.GetPosition()
    A.PositionHistory = {}
    A.StuckTimer = 0
    A._previousTrackPosition = nil
end

function A.GetPositionHistory(duration)
    duration = duration or 5
    local currentTime = tick()
    local history = {}
    for _, entry in pairs(A.PositionHistory) do
        if currentTime - entry.time <= duration then
            table.insert(history, entry)
        end
    end
    return history
end

function A.GetAveragePosition(duration)
    local history = A.GetPositionHistory(duration or 3)
    if #history == 0 then return A.GetPosition() end
    local sumX, sumY, sumZ = 0, 0, 0
    for _, entry in pairs(history) do
        sumX = sumX + entry.position.X
        sumY = sumY + entry.position.Y
        sumZ = sumZ + entry.position.Z
    end
    local count = #history
    return Vector3.new(sumX / count, sumY / count, sumZ / count)
end

function A.Teleport(pos)
    if typeof(pos) ~= "Vector3" then return false end
    local hrp = A.HRP()
    if not hrp then return false end
    local ok = SafeCall(function()
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end)
    return ok ~= nil
end

function A.TeleportToPart(part)
    if not part then return false end
    local ok, result = SafeCall(function()
        local pos = part.Position
        return A.Teleport(pos)
    end)
    if ok then return result end
    return false
end

StartPositionTracking()

-- ==============================
-- 11. Buff/Status Tracking
-- ==============================

function A.GetBuffs()
    local buffs = {}
    local char = GetCharacter()
    if not char then return buffs end
    local ok = SafeCall(function()
        local buffFolder = char:FindFirstChild("Buffs") or char:FindFirstChild("StatusEffects")
        if buffFolder then
            for _, child in pairs(buffFolder:GetChildren()) do
                local isActive = true
                if child:IsA("BoolValue") then
                    isActive = child.Value
                end
                if isActive then
                    table.insert(buffs, {
                        name = child.Name,
                        value = child.Value,
                        instance = child,
                    })
                end
            end
        end
        for _, child in pairs(char:GetChildren()) do
            if child.Name:find("Buff") or child.Name:find("Boost") then
                table.insert(buffs, {
                    name = child.Name,
                    value = child:IsA("BoolValue") and child.Value or true,
                    instance = child,
                })
            end
        end
    end)
    return buffs
end

function A.HasBuff(name)
    if type(name) ~= "string" then return false end
    local buffs = A.GetBuffs()
    for _, buff in pairs(buffs) do
        if buff.name:lower():find(name:lower()) then
            return true
        end
    end
    local char = GetCharacter()
    if char then
        local ok, result = SafeCall(function()
            for _, child in pairs(char:GetChildren()) do
                if child.Name:lower():find(name:lower()) then
                    return true
                end
            end
            return false
        end)
        if ok then return result end
    end
    return false
end

function A.GetObservationLevel()
    local v = GetDataValue("ObservationLevel")
    if v then return v end
    local data = GetDataValueFolder()
    if data then
        local obs = data:FindFirstChild("Observation")
        if obs then return obs.Value end
    end
    return 0
end

function A.GetHakiLevel()
    local v = GetDataValue("HakiLevel")
    if v then return v end
    local data = GetDataValueFolder()
    if data then
        local haki = data:FindFirstChild("Haki") or data:FindFirstChild("BusoHaki")
        if haki then return haki.Value end
    end
    return 0
end

function A.GetRace()
    return A.Race()
end

function A.GetRaceStage()
    local race = A.Race()
    if race == "Unknown" or race == "" then return 0 end
    local ok, result = SafeCall(function()
        local data = GetDataValueFolder()
        if data then
            local raceVal = data:FindFirstChild("Race")
            if raceVal and raceVal:IsA("StringValue") then
                local raceStr = raceVal.Value:lower()
                if raceStr:find("v4") or raceStr:find("awakened") then
                    return 4
                elseif raceStr:find("v3") then
                    return 3
                elseif raceStr:find("v2") then
                    return 2
                else
                    return 1
                end
            end
        end
        return 1
    end)
    if ok then return result end
    return 1
end

function A.HasRace(raceName)
    if type(raceName) ~= "string" then return false end
    local currentRace = A.Race()
    return currentRace:lower():find(raceName:lower()) ~= nil
end

function A.GetElemental()
    local v = GetDataValue("Elemental")
    if v then return v end
    return "None"
end

function A.GetMastery(type)
    if type(type) ~= "string" then return 0 end
    type = type:lower()
    if type == "fruit" or type == "blox fruit" then
        return A.FruitLevel()
    elseif type == "melee" then
        return A.MeleeLevel()
    elseif type == "defense" then
        return A.DefenseLevel()
    elseif type == "sword" then
        return A.SwordLevel()
    elseif type == "gun" then
        return A.GunLevel()
    end
    return 0
end

function A.GetCharacterAge()
    local char = GetCharacter()
    if not char then return 0 end
    local ok, result = SafeCall(function()
        return tick() - char:GetAttribute("SpawnTime") or 0
    end)
    if ok and result then return result end
    return 0
end

function A.IsWearingAccessory(name)
    if type(name) ~= "string" then return false end
    local char = GetCharacter()
    if not char then return false end
    for _, child in pairs(char:GetChildren()) do
        if child:IsA("Accessory") then
            if child.Name:lower():find(name:lower()) then
                return true
            end
        end
    end
    return false
end

-- ==============================
-- 12. Quest Data
-- ==============================

function A.GetQuestLevel()
    local v = GetDataValue("QuestLevel")
    if v then return v end
    return 0
end

function A.GetQuestName()
    local v = GetDataValue("QuestName")
    if v then return v end
    return ""
end

function A.HasQuest()
    local name = A.GetQuestName()
    return name ~= "" and name ~= nil
end

function A.GetQuestProgress()
    local ok, result = SafeCall(function()
        local data = GetDataValueFolder()
        if data then
            local progress = data:FindFirstChild("QuestProgress") or data:FindFirstChild("QuestKill")
            if progress then return progress.Value end
        end
        return 0
    end)
    if ok and result then return result end
    return 0
end

-- ==============================
-- 13. Island / Location Detection
-- ==============================

local Islands = {
    {name = "Starter Island", sea = 1, center = Vector3.new(-30, 10, -1500), radius = 500},
    {name = "Marine Fort", sea = 1, center = Vector3.new(-2100, 10, -500), radius = 600},
    {name = "Jungle", sea = 1, center = Vector3.new(-1300, 10, 1100), radius = 800},
    {name = "Pirate Village", sea = 1, center = Vector3.new(-1100, 10, -3200), radius = 700},
    {name = "Desert", sea = 1, center = Vector3.new(1000, 10, 4300), radius = 900},
    {name = "Frozen Village", sea = 1, center = Vector3.new(1000, 10, -4700), radius = 700},
    {name = "Marine fortress", sea = 1, center = Vector3.new(-4500, 10, -2600), radius = 600},
    {name = "Prison", sea = 1, center = Vector3.new(5000, 10, 3800), radius = 800},
    {name = "Colosseum", sea = 1, center = Vector3.new(-3700, 10, -1700), radius = 500},
    {name = "Magma Village", sea = 1, center = Vector3.new(-5200, 10, -1500), radius = 600},
    {name = "Underwater City", sea = 1, center = Vector3.new(6200, 10, -7700), radius = 800},
    {name = "Sky Island", sea = 1, center = Vector3.new(-500, 3000, -2000), radius = 1000},
    {name = "Kingdom of Rose", sea = 2, center = Vector3.new(-3200, 10, -2500), radius = 1000},
    {name = "Cafe", sea = 2, center = Vector3.new(-3100, 10, -2700), radius = 500},
    {name = "Usoapp's Island", sea = 2, center = Vector3.new(1000, 10, -1000), radius = 600},
    {name = "Green Zone", sea = 2, center = Vector3.new(-2400, 10, 3200), radius = 1000},
    {name = "Graveyard", sea = 2, center = Vector3.new(-5400, 10, -1500), radius = 700},
    {name = "Dead Mountain", sea = 2, center = Vector3.new(-1400, 10, -5600), radius = 700},
    {name = "Forgotten Island", sea = 2, center = Vector3.new(-1400, 10, -4600), radius = 800},
    {name = "Hot and Cold", sea = 2, center = Vector3.new(5500, 10, -2500), radius = 1200},
    {name = "Haunted Castle", sea = 3, center = Vector3.new(-5000, 10, -3000), radius = 1200},
    {name = "Castle on the Sea", sea = 3, center = Vector3.new(-4800, 10, -3500), radius = 800},
    {name = "Chocolate Island", sea = 3, center = Vector3.new(300, 10, 3000), radius = 1000},
    {name = "Ice Cream Island", sea = 3, center = Vector3.new(-2000, 10, 3500), radius = 900},
    {name = "Candy Island", sea = 3, center = Vector3.new(-2000, 10, -3200), radius = 800},
    {name = "Tiki Outpost", sea = 3, center = Vector3.new(-5500, 10, -1200), radius = 800},
}

function A.GetCurrentIsland()
    local pos = A.GetPosition()
    local closest = nil
    local closestDist = math.huge
    for _, island in pairs(Islands) do
        local dist = (pos - island.center).Magnitude
        if dist < island.radius and dist < closestDist then
            closestDist = dist
            closest = island
        end
    end
    return closest
end

function A.GetIslandName()
    local island = A.GetCurrentIsland()
    if island then return island.name end
    return "Unknown"
end

function A.GetNearestIsland()
    local pos = A.GetPosition()
    local closest = nil
    local closestDist = math.huge
    for _, island in pairs(Islands) do
        local dist = (pos - island.center).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = island
        end
    end
    return closest, closestDist
end

-- ==============================
-- 14. Miscellaneous Utilities
-- ==============================

function A.GetFPS()
    local ok, fps = pcall(function()
        return math.floor(1 / RunService.RenderStepped:Wait())
    end)
    if ok and fps then return fps end
    return 60
end

function A.GetServerTime()
    local ok, result = SafeCall(function()
        return CommF("GetServerTime")
    end)
    if ok and result then return result end
    return tick()
end

function A.IsAlive()
    return A.Alive()
end

function A.GetDisplayName()
    return LocalPlayer.DisplayName or LocalPlayer.Name
end

function A.GetUserName()
    return LocalPlayer.Name
end

function A.GetUserId()
    return LocalPlayer.UserId
end

function A.GetCharacterModel()
    return GetCharacter()
end

function A.GetRootPartPosition()
    return A.GetPosition()
end

function A.GetRootPartCFrame()
    return A.GetCF()
end

function A.GetCharacterChildren()
    local char = GetCharacter()
    if not char then return {} end
    return char:GetChildren()
end

function A.GetCharacterDescendants()
    local char = GetCharacter()
    if not char then return {} end
    return char:GetDescendants()
end

function A.FindCharacterChild(name)
    if type(name) ~= "string" then return nil end
    local char = GetCharacter()
    if not char then return nil end
    return char:FindFirstChild(name)
end

function A.CharacterHasChild(name)
    if type(name) ~= "string" then return false end
    local char = GetCharacter()
    if not char then return false end
    return char:FindFirstChild(name) ~= nil
end

function A.GetCharacterMass()
    local char = GetCharacter()
    if not char then return 0 end
    local ok, mass = pcall(function()
        local totalMass = 0
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                totalMass = totalMass + part:GetMass()
            end
        end
        return totalMass
    end)
    if ok and mass then return mass end
    return 0
end

function A.GetCharacterSize()
    local char = GetCharacter()
    if not char then return Vector3.new(0, 0, 0) end
    local ok, result = pcall(function()
        local minPos = Vector3.new(math.huge, math.huge, math.huge)
        local maxPos = Vector3.new(-math.huge, -math.huge, -math.huge)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                local cf = part.CFrame
                local size = part.Size
                local corners = {
                    cf * CFrame.new(size.X / 2, size.Y / 2, size.Z / 2),
                    cf * CFrame.new(-size.X / 2, size.Y / 2, size.Z / 2),
                    cf * CFrame.new(size.X / 2, -size.Y / 2, size.Z / 2),
                    cf * CFrame.new(-size.X / 2, -size.Y / 2, size.Z / 2),
                    cf * CFrame.new(size.X / 2, size.Y / 2, -size.Z / 2),
                    cf * CFrame.new(-size.X / 2, size.Y / 2, -size.Z / 2),
                    cf * CFrame.new(size.X / 2, -size.Y / 2, -size.Z / 2),
                    cf * CFrame.new(-size.X / 2, -size.Y / 2, -size.Z / 2),
                }
                for _, corner in pairs(corners) do
                    local pos = corner.Position
                    minPos = Vector3.new(
                        math.min(minPos.X, pos.X),
                        math.min(minPos.Y, pos.Y),
                        math.min(minPos.Z, pos.Z)
                    )
                    maxPos = Vector3.new(
                        math.max(maxPos.X, pos.X),
                        math.max(maxPos.Y, pos.Y),
                        math.max(maxPos.Z, pos.Z)
                    )
                end
            end
        end
        return maxPos - minPos
    end)
    if ok and result then return result end
    return Vector3.new(0, 0, 0)
end

function A.IsEnemyNearby(range)
    range = range or 100
    local pos = A.GetPosition()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= A.Team() then
            local pChar = player.Character
            if pChar then
                local pHRP = pChar:FindFirstChild("HumanoidRootPart") or pChar:FindFirstChild("Torso")
                local pHum = pChar:FindFirstChildOfClass("Humanoid")
                if pHRP and pHum and pHum.Health > 0 then
                    local dist = (pHRP.Position - pos).Magnitude
                    if dist <= range then
                        return true, player, dist
                    end
                end
            end
        end
    end
    return false, nil, math.huge
end

function A.GetClosestNPC(range)
    range = range or 500
    local pos = A.GetPosition()
    local closest = nil
    local closestDist = math.huge
    local ok = SafeCall(function()
        for _, model in pairs(workspace:GetChildren()) do
            if model:IsA("Model") and model ~= GetCharacter() then
                local hum = model:FindFirstChildOfClass("Humanoid")
                local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
                if hum and root and hum.Health > 0 then
                    local isPlayer = false
                    for _, p in pairs(Players:GetPlayers()) do
                        if p.Character == model then
                            isPlayer = true
                            break
                        end
                    end
                    if not isPlayer then
                        local dist = (root.Position - pos).Magnitude
                        if dist < closestDist and dist <= range then
                            closestDist = dist
                            closest = model
                        end
                    end
                end
            end
        end
    end)
    return closest, closestDist
end

function A.GetClosestPlayer(range)
    range = range or math.huge
    local pos = A.GetPosition()
    local closest = nil
    local closestDist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local pChar = player.Character
            if pChar then
                local pHRP = pChar:FindFirstChild("HumanoidRootPart") or pChar:FindFirstChild("Torso")
                if pHRP then
                    local dist = (pHRP.Position - pos).Magnitude
                    if dist < closestDist and dist <= range then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest, closestDist
end

function A.GetDistanceTo(target)
    if not target then return math.huge end
    local pos = A.GetPosition()
    if typeof(target) == "Vector3" then
        return (pos - target).Magnitude
    elseif typeof(target) == "CFrame" then
        return (pos - target.Position).Magnitude
    elseif typeof(target) == "Instance" then
        local root = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso") or target
        if root:IsA("BasePart") then
            return (pos - root.Position).Magnitude
        end
    elseif type(target) == "table" and target.Position then
        return (pos - target.Position).Magnitude
    end
    return math.huge
end

-- ==============================
-- Initialization
-- ==============================

task.spawn(function()
    pcall(function()
        task.wait(2)
        A.TrackCombatDamage()
        local charAddedConn = LocalPlayer.CharacterAdded:Connect(function()
            task.wait(1)
            A.TrackCombatDamage()
        end)
        table.insert(CharacterConnections, charAddedConn)
    end)
end)

return A
