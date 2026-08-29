--[[
    Apex Hub v13.0 APEX ULTIMATE
    Core Combat Engine
    
    Comprehensive combat system with combos, auto-attack,
    target acquisition, damage calculation, and smart AI.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local A = _G.Apex or {}
A.__index = A

---------------------------------------------------------------------------
-- State Variables
---------------------------------------------------------------------------

A.AutoAttackEnabled = false
A.AutoAttackTarget = nil
A.AttackThread = nil
A.AttackSpeed = 0.1
A.AttackRange = 15
A.ComboRange = 20
A.SuperRange = 25

A.KillCount = 0
A.ComboCount = 0
A.TotalDamage = 0
A.KillLog = {}
A.CombatState = "Idle"
A.AttackPositionOffset = 3

A.Blacklist = {}
A.Whitelist = {}

A.LastAttackTime = 0
A.AttackLock = false
A.AntiKickEnabled = true
A.AntiStunEnabled = true
A.AntiComboEnabled = true
A.AntiGlideEnabled = true

A.TeamFightEnabled = false
A.FriendlyPlayers = {}

---------------------------------------------------------------------------
-- Combo Definitions
---------------------------------------------------------------------------

A.ComboIndex = 1
A.CurrentCombo = nil
A.ComboActive = false
A.ComboStartTime = 0

A.Combos = {
    ["Basic"] = {
        "Click", "Click", "Click", "Remote", "Click"
    },
    ["Sword"] = {
        "Click", "Z", "Click", "X", "Click", "C", "Click"
    },
    ["Fruit"] = {
        "Click", "Z", "X", "C", "V", "Click"
    },
    ["Gun"] = {
        "Click", "Z", "X", "Click"
    },
    ["Melee"] = {
        "Click", "Click", "Z", "Click", "X", "Click", "C"
    },
    ["Bloxfruit"] = {
        "Click", "Z", "X", "C", "V", "F", "Click"
    },
    ["SuperCombo"] = {
        "Click", "Z", "Click", "X", "Click", "C", "Click", "V", "Click", "F"
    },
    ["MegaCombo"] = {
        "Click", "Z", "Click", "X", "Click", "C", "Click", "V", "Click", "F", "Click", "R"
    },
    ["UltraCombo"] = {
        "Click", "Z", "Click", "Z", "Click", "X", "Click", "X", "Click", "C", "Click", "V"
    },
    ["PvP_Burst"] = {
        "Z", "Click", "Click", "X", "Click", "C", "V"
    },
    ["PvP_Stun"] = {
        "Z", "Z", "Click", "X", "Click", "Click", "C", "V", "F"
    },
    ["PvP_Ultra"] = {
        "Z", "Click", "X", "Click", "C", "Click", "V", "Click", "F", "Click", "R"
    },
    ["Grind_Close"] = {
        "Click", "Click", "Click", "Click", "Click"
    },
    ["Grind_Mid"] = {
        "Click", "Z", "Click", "Click", "X", "Click"
    },
    ["Grind_Far"] = {
        "Z", "X", "C", "V", "F"
    },
}

---------------------------------------------------------------------------
-- Internal Utility
---------------------------------------------------------------------------

local function GetHRP(character)
    if character then
        return character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function GetHumanoid(character)
    if character then
        return character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

local function IsAlive(character)
    local hum = GetHumanoid(character)
    if hum and hum.Health > 0 then
        return true
    end
    return false
end

local function GetCharacter()
    return LocalPlayer.Character
end

local function GetMyHRP()
    local char = GetCharacter()
    return GetHRP(char)
end

local function GetMyHumanoid()
    local char = GetCharacter()
    return GetHumanoid(char)
end

local function DistanceTo(part1, part2)
    if not part1 or not part2 then
        return math.huge
    end
    local pos1 = part1.Position
    local pos2 = part2.Position
    return (pos1 - pos2).Magnitude
end

local function WaitForChildTimeout(parent, childName, timeout)
    return parent:WaitForChild(childName, timeout or 5)
end

local function GetRemote(name)
    local remote = ReplicatedStorage:FindFirstChild(name)
    if remote then
        return remote
    end
    for _, child in ipairs(ReplicatedStorage:GetDescendants()) do
        if child.Name == name and (child:IsA("RemoteEvent") or child:IsA("RemoteFunction")) then
            return child
        end
    end
    return nil
end

local function FireClickRemote(position)
    local char = GetCharacter()
    if not char then return end

    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end

    local handle = tool:FindFirstChild("Handle")
    if not handle then return end

    local clickRemote = tool:FindFirstChild("ClickRemote")
    if clickRemote and clickRemote:IsA("RemoteEvent") then
        clickRemote:FireServer(position)
        return true
    end

    local events = tool:FindFirstChild("Events")
    if events then
        local click = events:FindFirstChild("Click")
        if click and click:IsA("RemoteEvent") then
            click:FireServer(position)
            return true
        end
    end

    return false
end

local function FireAttackRemote(position, damage)
    local remotes = {"Attack", "Combat", "Damage", "Hit"}
    for _, name in ipairs(remotes) do
        local remote = GetRemote(name)
        if remote then
            if remote:IsA("RemoteEvent") then
                remote:FireServer(position, damage or 0)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(position, damage or 0)
            end
            return true
        end
    end
    return false
end

local function PressSkillKey(keyName)
    local keyCode = nil
    local keyMap = {
        ["Z"] = Enum.KeyCode.Z,
        ["X"] = Enum.KeyCode.X,
        ["C"] = Enum.KeyCode.C,
        ["V"] = Enum.KeyCode.V,
        ["F"] = Enum.KeyCode.F,
        ["R"] = Enum.KeyCode.R,
        ["Q"] = Enum.KeyCode.Q,
        ["E"] = Enum.KeyCode.E,
        ["G"] = Enum.KeyCode.G,
    }
    keyCode = keyMap[keyName]
    if keyCode then
        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
        return true
    end
    return false
end

local function FireSkillRemote(skillName)
    local skillRemotes = {"SkillRemote", "Skill", "UseSkill", "CastSkill", "Ability"}
    for _, name in ipairs(skillRemotes) do
        local remote = GetRemote(name)
        if remote then
            if remote:IsA("RemoteEvent") then
                remote:FireServer(skillName)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(skillName)
            end
            return true
        end
    end
    return false
end

local function PerformClickAttack(targetPart)
    if not targetPart then return false end
    local char = GetCharacter()
    if not char then return false end
    local myHRP = GetMyHRP()
    if not myHRP then return false end

    local targetPos = targetPart.Position
    local dirToTarget = (targetPos - myHRP.Position).Unit
    local behindPos = targetPos + (dirToTarget * -3)
    local lookAtPos = targetPos

    myHRP.CFrame = CFrame.new(behindPos, lookAtPos)
    task.wait(0.05)

    FireClickRemote(targetPos)
    return true
end

local function PerformRemoteAttack(targetPart, args)
    if not targetPart then return false end
    local targetPos = targetPart.Position

    local attackArgs = args or {targetPos.X, targetPos.Y, targetPos.Z}
    FireAttackRemote(targetPos, attackArgs)
    return true
end

local function PerformSkillAttack(targetPart, skillName)
    if not targetPart then return false end
    local myHRP = GetMyHRP()
    if not myHRP then return false end

    local targetPos = targetPart.Position
    local dirToTarget = (targetPos - myHRP.Position).Unit
    local behindPos = targetPos + (dirToTarget * -3)

    myHRP.CFrame = CFrame.new(behindPos, targetPos)
    task.wait(0.05)

    PressSkillKey(skillName)
    task.wait(0.05)
    FireSkillRemote(skillName)
    return true
end

---------------------------------------------------------------------------
-- Anti-Kick System
---------------------------------------------------------------------------

local AntiKickConnections = {}
local AntiKickActive = false

local function StartAntiKick()
    if AntiKickActive then return end
    AntiKickActive = true

    local function onHeartbeat()
        if not A.AntiKickEnabled then return end
        pcall(function()
            local char = GetCharacter()
            if char then
                local hum = GetHumanoid(char)
                if hum then
                    hum.PlatformStand = false
                    hum.AutoRotate = true
                end
            end
        end)
    end

    local hb = RunService.Heartbeat:Connect(onHeartbeat)
    table.insert(AntiKickConnections, hb)

    local cg = LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if A.AntiKickEnabled and AntiKickActive then
            pcall(function()
                local hum = GetHumanoid(char)
                if hum then
                    hum.PlatformStand = false
                    hum.AutoRotate = true
                end
            end)
        end
    end)
    table.insert(AntiKickConnections, cg)
end

local function StopAntiKick()
    AntiKickActive = false
    for _, conn in ipairs(AntiKickConnections) do
        if conn.Connected then
            conn:Disconnect()
        end
    end
    AntiKickConnections = {}
end

---------------------------------------------------------------------------
-- Target Blacklist
---------------------------------------------------------------------------

function A.BlacklistTarget(target)
    if target then
        A.Blacklist[target.Name] = tick()
    end
end

function A.WhitelistTarget(target)
    if target then
        A.Blacklist[target.Name] = nil
        A.Whitelist[target.Name] = tick()
    end
end

function A.IsBlacklisted(target)
    if target then
        if A.Blacklist[target.Name] then
            local elapsed = tick() - A.Blacklist[target.Name]
            if elapsed > 60 then
                A.Blacklist[target.Name] = nil
                return false
            end
            return true
        end
    end
    return false
end

function A.ClearBlacklist()
    A.Blacklist = {}
    A.Whitelist = {}
end

---------------------------------------------------------------------------
-- Target Acquisition
---------------------------------------------------------------------------

function A.ValidateTarget(target, maxRange)
    if not target then return false end
    if not target.Parent then return false end
    if not target:FindFirstChild("Humanoid") then return false end
    if not target:FindFirstChild("HumanoidRootPart") then return false end
    if target == GetCharacter() then return false end

    local hum = target:FindFirstChild("Humanoid")
    if hum.Health <= 0 then return false end

    if A.IsBlacklisted(target) then return false end

    if maxRange then
        local dist = A.GetTargetDistance(target)
        if dist > maxRange then return false end
    end

    return true
end

function A.GetTargetHealth(target)
    if not target then return 0 end
    local hum = target:FindFirstChild("Humanoid")
    if hum then
        return hum.Health
    end
    return 0
end

function A.GetTargetDistance(target)
    if not target then return math.huge end
    local targetHRP = GetHRP(target)
    local myHRP = GetMyHRP()
    return DistanceTo(myHRP, targetHRP)
end

function A.TargetPriority(target)
    if not target then return 0 end
    local priority = 0

    local hum = target:FindFirstChild("Humanoid")
    if hum then
        local healthPercent = hum.Health / hum.MaxHealth
        priority = priority + (1 - healthPercent) * 50
    end

    local dist = A.GetTargetDistance(target)
    if dist > 0 then
        priority = priority + (1000 / dist)
    end

    local hum2 = target:FindFirstChild("Humanoid")
    if hum2 then
        local walkSpeed = hum2.WalkSpeed
        if walkSpeed < 16 then
            priority = priority + 20
        end
    end

    return priority
end

function A.SortTargets(targets, mode)
    if not targets or #targets == 0 then return {} end

    mode = mode or "Closest"

    local sorted = {}
    for _, t in ipairs(targets) do
        table.insert(sorted, t)
    end

    if mode == "Closest" then
        table.sort(sorted, function(a, b)
            return A.GetTargetDistance(a) < A.GetTargetDistance(b)
        end)
    elseif mode == "Weakest" then
        table.sort(sorted, function(a, b)
            return A.GetTargetHealth(a) < A.GetTargetHealth(b)
        end)
    elseif mode == "Strongest" then
        table.sort(sorted, function(a, b)
            return A.GetTargetHealth(a) > A.GetTargetHealth(b)
        end)
    elseif mode == "Lowest" then
        table.sort(sorted, function(a, b)
            return A.GetTargetHealth(a) < A.GetTargetHealth(b)
        end)
    elseif mode == "Highest" then
        table.sort(sorted, function(a, b)
            return A.GetTargetHealth(a) > A.GetTargetHealth(b)
        end)
    elseif mode == "Random" then
        for i = #sorted, 2, -1 do
            local j = math.random(1, i)
            sorted[i], sorted[j] = sorted[j], sorted[i]
        end
    elseif mode == "Priority" then
        table.sort(sorted, function(a, b)
            return A.TargetPriority(a) > A.TargetPriority(b)
        end)
    end

    return sorted
end

function A.FindTarget(maxRange)
    maxRange = maxRange or A.AttackRange
    local myChar = GetCharacter()
    if not myChar then return nil end

    local candidates = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and A.ValidateTarget(char, maxRange) then
                table.insert(candidates, char)
            end
        end
    end

    local workspaceTargets = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= myChar then
            if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if A.ValidateTarget(obj, maxRange) then
                    local isPlayer = false
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p.Character == obj then
                            isPlayer = true
                            break
                        end
                    end
                    if not isPlayer then
                        table.insert(workspaceTargets, obj)
                    end
                end
            end
        end
    end

    local allTargets = {}
    for _, c in ipairs(candidates) do
        table.insert(allTargets, c)
    end
    for _, w in ipairs(workspaceTargets) do
        table.insert(allTargets, w)
    end

    local sorted = A.SortTargets(allTargets, "Closest")
    if #sorted > 0 then
        return sorted[1]
    end
    return nil
end

function A.FindPlayerTarget(maxRange, mode)
    maxRange = maxRange or A.AttackRange
    mode = mode or "Closest"

    local candidates = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and A.ValidateTarget(char, maxRange) then
                table.insert(candidates, char)
            end
        end
    end

    local sorted = A.SortTargets(candidates, mode)
    if #sorted > 0 then
        return sorted[1]
    end
    return nil
end

function A.FindBossTarget()
    local bossNames = {
        "Boss", "Boss [Lv", "Raids Boss", "Elite", "AdminBoss",
        "Tyrant", "Diable", "Cake", "Greybeard", "Diamond",
        "Jeremy", "Saber Expert", "BlackBeard", "Sanguine"
    }

    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            local hum = obj:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                for _, bossName in ipairs(bossNames) do
                    if string.find(obj.Name, bossName) then
                        local dist = A.GetTargetDistance(obj)
                        if dist <= A.SuperRange then
                            return obj
                        end
                    end
                end
            end
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                local hum = char:FindFirstChild("Humanoid")
                if hum.MaxHealth > 10000 then
                    return char
                end
            end
        end
    end

    return nil
end

function A.FindQuestTarget(quest)
    if not quest then return A.FindTarget() end

    local questMobs = {}
    if quest.MobName then
        table.insert(questMobs, quest.MobName)
    end
    if quest.Mobs then
        for _, name in ipairs(quest.Mobs) do
            table.insert(questMobs, name)
        end
    end

    for _, mobName in ipairs(questMobs) do
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj.Name == mobName then
                local hum = obj:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local dist = A.GetTargetDistance(obj)
                    if dist <= A.AttackRange * 2 then
                        return obj
                    end
                end
            end
        end
    end

    return A.FindTarget()
end

---------------------------------------------------------------------------
-- Attack Execution
---------------------------------------------------------------------------

function A.Attack(target, keys, delay)
    if not target then return false end
    if not A.ValidateTarget(target) then return false end
    if A.AttackLock then return false end

    A.AttackLock = true
    A.AntiKickEnabled = true
    StartAntiKick()

    local success = false

    delay = delay or A.AttackSpeed

    local targetHRP = GetHRP(target)
    if not targetHRP then
        A.AttackLock = false
        return false
    end

    local myHRP = GetMyHRP()
    if not myHRP then
        A.AttackLock = false
        return false
    end

    local targetPos = targetHRP.Position
    local dirToTarget = (targetPos - myHRP.Position)
    if dirToTarget.Magnitude > 0 then
        dirToTarget = dirToTarget.Unit
    else
        dirToTarget = Vector3.new(0, 0, -1)
    end
    local behindPos = targetPos + (dirToTarget * -A.AttackPositionOffset)

    pcall(function()
        myHRP.CFrame = CFrame.new(behindPos, targetPos)
    end)

    task.wait(0.05)

    keys = keys or {"Click"}
    for i, key in ipairs(keys) do
        if not A.ValidateTarget(target) then
            break
        end

        if key == "Click" then
            success = PerformClickAttack(GetHRP(target))
        elseif key == "Remote" then
            local targetHRP2 = GetHRP(target)
            success = PerformRemoteAttack(targetHRP2, {targetHRP2.Position.X, targetHRP2.Position.Y, targetHRP2.Position.Z})
        elseif key == "Skill" then
            local targetHRP3 = GetHRP(target)
            success = PerformSkillAttack(targetHRP3, "Z")
        else
            local isSkillKey = (key == "Z" or key == "X" or key == "C" or key == "V" or key == "F" or key == "R")
            if isSkillKey then
                local targetHRP4 = GetHRP(target)
                success = PerformSkillAttack(targetHRP4, key)
            else
                local targetHRP5 = GetHRP(target)
                success = PerformClickAttack(targetHRP5)
            end
        end

        if i < #keys then
            task.wait(delay)
        end
    end

    A.LastAttackTime = tick()
    A.AttackLock = false
    StopAntiKick()

    return success
end

function A.ClickAttack(target)
    if not target then return false end
    if not A.ValidateTarget(target) then return false end

    A.AttackLock = true
    StartAntiKick()

    local result = false

    local targetHRP = GetHRP(target)
    local myHRP = GetMyHRP()
    if targetHRP and myHRP then
        local targetPos = targetHRP.Position
        local dirToTarget = (targetPos - myHRP.Position)
        if dirToTarget.Magnitude > 0 then
            dirToTarget = dirToTarget.Unit
        else
            dirToTarget = Vector3.new(0, 0, -1)
        end
        local behindPos = targetPos + (dirToTarget * -A.AttackPositionOffset)

        pcall(function()
            myHRP.CFrame = CFrame.new(behindPos, targetPos)
        end)
        task.wait(0.05)

        result = PerformClickAttack(targetHRP)
    end

    A.LastAttackTime = tick()
    A.AttackLock = false
    StopAntiKick()

    return result
end

function A.RemoteAttack(target, args)
    if not target then return false end
    if not A.ValidateTarget(target) then return false end

    A.AttackLock = true
    StartAntiKick()

    local result = false

    local targetHRP = GetHRP(target)
    if targetHRP then
        result = PerformRemoteAttack(targetHRP, args)
    end

    A.LastAttackTime = tick()
    A.AttackLock = false
    StopAntiKick()

    return result
end

function A.SkillAttack(target, skillName)
    if not target then return false end
    if not A.ValidateTarget(target) then return false end

    A.AttackLock = true
    StartAntiKick()

    local result = false

    local targetHRP = GetHRP(target)
    if targetHRP then
        result = PerformSkillAttack(targetHRP, skillName)
    end

    A.LastAttackTime = tick()
    A.AttackLock = false
    StopAntiKick()

    return result
end

function A.ComboAttack(target, combo)
    if not target then return false end
    if not A.ValidateTarget(target) then return false end
    if not combo then return false end

    A.AttackLock = true
    A.ComboActive = true
    A.ComboStartTime = tick()
    StartAntiKick()

    local comboKeys = nil
    if type(combo) == "string" then
        comboKeys = A.Combos[combo]
        A.CurrentCombo = combo
    elseif type(combo) == "table" then
        comboKeys = combo
    end

    if not comboKeys then
        A.AttackLock = false
        A.ComboActive = false
        StopAntiKick()
        return false
    end

    A.ComboIndex = 1
    local success = false

    for i, key in ipairs(comboKeys) do
        if not A.ValidateTarget(target) then
            break
        end

        if A.CombatState == "Retreat" then
            break
        end

        A.ComboIndex = i

        local targetHRP = GetHRP(target)
        local myHRP = GetMyHRP()
        if targetHRP and myHRP then
            local dist = DistanceTo(myHRP, targetHRP)
            if dist > A.AttackRange * 1.5 then
                pcall(function()
                    local pos = targetHRP.Position
                    local dir = (pos - myHRP.Position)
                    if dir.Magnitude > 0 then
                        dir = dir.Unit
                    else
                        dir = Vector3.new(0, 0, -1)
                    end
                    myHRP.CFrame = CFrame.new(pos + (dir * -3), pos)
                end)
                task.wait(0.1)
            end
        end

        if key == "Click" then
            success = PerformClickAttack(GetHRP(target))
            task.wait(A.AttackSpeed)
        elseif key == "Remote" then
            local tHRP = GetHRP(target)
            success = PerformRemoteAttack(tHRP)
            task.wait(A.AttackSpeed)
        else
            local isSkillKey = (key == "Z" or key == "X" or key == "C" or key == "V" or key == "F" or key == "R")
            if isSkillKey then
                local tHRP2 = GetHRP(target)
                success = PerformSkillAttack(tHRP2, key)
                task.wait(A.AttackSpeed + 0.1)
            else
                local tHRP3 = GetHRP(target)
                success = PerformClickAttack(tHRP3)
                task.wait(A.AttackSpeed)
            end
        end
    end

    A.ComboCount = A.ComboCount + 1
    A.ComboActive = false
    A.AttackLock = false
    A.LastAttackTime = tick()
    StopAntiKick()

    return success
end

---------------------------------------------------------------------------
-- Combo System
---------------------------------------------------------------------------

function A.SetCombo(name)
    if A.Combos[name] then
        A.CurrentCombo = name
        A.ComboIndex = 1
        A.ComboActive = false
        return true
    end
    return false
end

function A.AddCombo(name, keys)
    if name and keys and type(keys) == "table" then
        A.Combos[name] = keys
        return true
    end
    return false
end

function A.ExecuteCombo(target, name)
    if not target then return false end

    local comboName = name or A.CurrentCombo or "Basic"
    return A.ComboAttack(target, comboName)
end

function A.ComboStep()
    A.ComboIndex = A.ComboIndex + 1

    if A.CurrentCombo then
        local comboKeys = A.Combos[A.CurrentCombo]
        if comboKeys and A.ComboIndex > #comboKeys then
            A.ComboIndex = 1
            return false
        end
    end

    return true
end

function A.ResetCombo()
    A.ComboIndex = 1
    A.ComboActive = false
    A.ComboStartTime = 0
end

function A.GetComboByRange(distance)
    if distance <= 8 then
        if math.random(1, 100) <= 50 then
            return "Melee"
        else
            return "Basic"
        end
    elseif distance <= 15 then
        if math.random(1, 100) <= 40 then
            return "SuperCombo"
        elseif math.random(1, 100) <= 50 then
            return "Bloxfruit"
        else
            return "Sword"
        end
    elseif distance <= 25 then
        if math.random(1, 100) <= 50 then
            return "MegaCombo"
        else
            return "Fruit"
        end
    else
        return "Grind_Far"
    end
end

function A.AddBuiltInCombos()
    A.Combos["PvP_Burst"] = {
        "Z", "Click", "Click", "X", "Click", "C", "V"
    }
    A.Combos["PvP_Stun"] = {
        "Z", "Z", "Click", "X", "Click", "Click", "C", "V", "F"
    }
    A.Combos["PvP_Ultra"] = {
        "Z", "Click", "X", "Click", "C", "Click", "V", "Click", "F", "Click", "R"
    }
    A.Combos["Grind_Close"] = {
        "Click", "Click", "Click", "Click", "Click"
    }
    A.Combos["Grind_Mid"] = {
        "Click", "Z", "Click", "Click", "X", "Click"
    }
    A.Combos["Grind_Far"] = {
        "Z", "X", "C", "V", "F"
    }
end

A.AddBuiltInCombos()

---------------------------------------------------------------------------
-- Super Attack System
---------------------------------------------------------------------------

function A.SuperAttack(target)
    if type(target) == "boolean" or not target then
        target = A.AutoAttackTarget
    end
    if not target then return false end
    if not A.ValidateTarget(target) then return false end

    A.CombatState = "SuperAttack"
    A.AttackLock = true
    StartAntiKick()

    local success = false

    local targetHRP = GetHRP(target)
    local myHRP = GetMyHRP()
    if not targetHRP or not myHRP then
        A.CombatState = "Idle"
        A.AttackLock = false
        StopAntiKick()
        return false
    end

    local targetPos = targetHRP.Position
    local dirToTarget = (targetPos - myHRP.Position)
    if dirToTarget.Magnitude > 0 then
        dirToTarget = dirToTarget.Unit
    else
        dirToTarget = Vector3.new(0, 0, -1)
    end
    local behindPos = targetPos + (dirToTarget * -3)

    pcall(function()
        myHRP.CFrame = CFrame.new(behindPos, targetPos)
    end)
    task.wait(0.05)

    local tHRP1 = GetHRP(target)
    if tHRP1 then
        PressSkillKey("Z")
        task.wait(0.15)
        FireSkillRemote("Z")
    end

    task.wait(0.3)

    for i = 1, 5 do
        if not A.ValidateTarget(target) then break end
        local tHRP2 = GetHRP(target)
        if tHRP2 then
            PerformClickAttack(tHRP2)
            task.wait(0.08)
        end
    end

    task.wait(0.2)

    local tHRP3 = GetHRP(target)
    if tHRP3 then
        local pos3 = tHRP3.Position
        local dir3 = (pos3 - myHRP.Position)
        if dir3.Magnitude > 0 then
            dir3 = dir3.Unit
        else
            dir3 = Vector3.new(0, 0, -1)
        end
        pcall(function()
            myHRP.CFrame = CFrame.new(pos3 + (dir3 * -3), pos3)
        end)
        task.wait(0.05)
        PerformSkillAttack(tHRP3, "X")
    end

    task.wait(0.3)

    local tHRP4 = GetHRP(target)
    if tHRP4 then
        local pos4 = tHRP4.Position
        local dir4 = (pos4 - myHRP.Position)
        if dir4.Magnitude > 0 then
            dir4 = dir4.Unit
        else
            dir4 = Vector3.new(0, 0, -1)
        end
        pcall(function()
            myHRP.CFrame = CFrame.new(pos4 + (dir4 * -3), pos4)
        end)
        task.wait(0.05)
        PerformSkillAttack(tHRP4, "V")
    end

    task.wait(0.2)

    A.ComboCount = A.ComboCount + 1
    A.CombatState = "Idle"
    A.AttackLock = false
    A.LastAttackTime = tick()
    StopAntiKick()

    return true
end

function A.UltraCombo(target)
    if not target then return false end
    if not A.ValidateTarget(target) then return false end

    A.CombatState = "UltraCombo"
    A.AttackLock = true
    StartAntiKick()

    local ultraKeys = {"Z", "Click", "Click", "X", "Click", "Click", "C", "Click", "V", "Click", "F", "Click", "R"}

    for i, key in ipairs(ultraKeys) do
        if not A.ValidateTarget(target) then break end
        if A.CombatState == "Retreat" then break end

        local tHRP = GetHRP(target)
        local myHRP = GetMyHRP()
        if tHRP and myHRP then
            local dist = DistanceTo(myHRP, tHRP)
            if dist > A.AttackRange then
                pcall(function()
                    local pos = tHRP.Position
                    local dir = (pos - myHRP.Position)
                    if dir.Magnitude > 0 then
                        dir = dir.Unit
                    else
                        dir = Vector3.new(0, 0, -1)
                    end
                    myHRP.CFrame = CFrame.new(pos + (dir * -3), pos)
                end)
                task.wait(0.08)
            end

            if key == "Click" then
                PerformClickAttack(tHRP)
                task.wait(A.AttackSpeed)
            else
                local isSkillKey = (key == "Z" or key == "X" or key == "C" or key == "V" or key == "F" or key == "R")
                if isSkillKey then
                    PerformSkillAttack(tHRP, key)
                    task.wait(A.AttackSpeed + 0.15)
                else
                    PerformClickAttack(tHRP)
                    task.wait(A.AttackSpeed)
                end
            end
        end
    end

    A.ComboCount = A.ComboCount + 1
    A.CombatState = "Idle"
    A.AttackLock = false
    A.LastAttackTime = tick()
    StopAntiKick()

    return true
end

function A.MegaCombo(target)
    if not target then return false end
    if not A.ValidateTarget(target) then return false end

    A.CombatState = "MegaCombo"
    A.AttackLock = true
    StartAntiKick()

    local megaKeys = {"Z", "Click", "Z", "X", "Click", "X", "C", "Click", "C", "V", "Click", "V", "F", "Click", "F", "R"}

    for i, key in ipairs(megaKeys) do
        if not A.ValidateTarget(target) then break end
        if A.CombatState == "Retreat" then break end

        local tHRP = GetHRP(target)
        local myHRP = GetMyHRP()
        if tHRP and myHRP then
            local dist = DistanceTo(myHRP, tHRP)
            if dist > A.AttackRange then
                pcall(function()
                    local pos = tHRP.Position
                    local dir = (pos - myHRP.Position)
                    if dir.Magnitude > 0 then
                        dir = dir.Unit
                    else
                        dir = Vector3.new(0, 0, -1)
                    end
                    myHRP.CFrame = CFrame.new(pos + (dir * -3), pos)
                end)
                task.wait(0.08)
            end

            if key == "Click" then
                PerformClickAttack(tHRP)
                task.wait(A.AttackSpeed)
            else
                local isSkillKey = (key == "Z" or key == "X" or key == "C" or key == "V" or key == "F" or key == "R")
                if isSkillKey then
                    PerformSkillAttack(tHRP, key)
                    task.wait(A.AttackSpeed + 0.15)
                else
                    PerformClickAttack(tHRP)
                    task.wait(A.AttackSpeed)
                end
            end
        end
    end

    A.ComboCount = A.ComboCount + 1
    A.CombatState = "Idle"
    A.AttackLock = false
    A.LastAttackTime = tick()
    StopAntiKick()

    return true
end

function A.OneShot(target)
    if not target then return false end
    if not A.ValidateTarget(target) then return false end

    A.CombatState = "OneShot"
    A.AttackLock = true
    StartAntiKick()

    local myHRP = GetMyHRP()
    local targetHRP = GetHRP(target)
    if not myHRP or not targetHRP then
        A.CombatState = "Idle"
        A.AttackLock = false
        StopAntiKick()
        return false
    end

    pcall(function()
        local pos = targetHRP.Position
        local dir = (pos - myHRP.Position)
        if dir.Magnitude > 0 then
            dir = dir.Unit
        else
            dir = Vector3.new(0, 0, -1)
        end
        myHRP.CFrame = CFrame.new(pos + (dir * -2), pos)
    end)
    task.wait(0.05)

    local oneShotSequence = {
        {key = "Z", wait = 0.15},
        {key = "X", wait = 0.2},
        {key = "C", wait = 0.15},
        {key = "V", wait = 0.2},
        {key = "F", wait = 0.15},
        {key = "R", wait = 0.1},
    }

    for _, step in ipairs(oneShotSequence) do
        if not A.ValidateTarget(target) then break end

        local tHRP = GetHRP(target)
        local myHRP2 = GetMyHRP()
        if tHRP and myHRP2 then
            local pos = tHRP.Position
            local dir = (pos - myHRP2.Position)
            if dir.Magnitude > 0 then
                dir = dir.Unit
            else
                dir = Vector3.new(0, 0, -1)
            end
            pcall(function()
                myHRP2.CFrame = CFrame.new(pos + (dir * -2), pos)
            end)
            task.wait(0.03)

            local isSkillKey = (step.key == "Z" or step.key == "X" or step.key == "C" or step.key == "V" or step.key == "F" or step.key == "R")
            if isSkillKey then
                PerformSkillAttack(tHRP, step.key)
            end
            task.wait(step.wait)
        end
    end

    for i = 1, 8 do
        if not A.ValidateTarget(target) then break end
        local tHRP2 = GetHRP(target)
        if tHRP2 then
            PerformClickAttack(tHRP2)
            task.wait(0.05)
        end
    end

    A.ComboCount = A.ComboCount + 1
    A.CombatState = "Idle"
    A.AttackLock = false
    A.LastAttackTime = tick()
    StopAntiKick()

    return true
end

---------------------------------------------------------------------------
-- Auto Attack System
---------------------------------------------------------------------------

function A.StartAutoAttack(target)
    if A.AutoAttackEnabled then return end

    A.AutoAttackEnabled = true
    A.AutoAttackTarget = target or A.FindTarget()
    A.CombatState = "Attacking"

    A.AttackThread = task.spawn(function()
        pcall(function()
        while A.AutoAttackEnabled do
            task.wait(0.05)

            local currentTarget = A.AutoAttackTarget

            if not currentTarget then
                currentTarget = A.FindTarget()
                if currentTarget then
                    A.AutoAttackTarget = currentTarget
                else
                    A.CombatState = "Searching"
                    task.wait(0.5)
                    break
                end
            end

            if currentTarget and currentTarget.Parent then
                local hum = currentTarget:FindFirstChild("Humanoid")
                if hum and hum.Health <= 0 then
                    A.LogKill(currentTarget, "AutoAttack", tick())
                    A.AutoAttackTarget = nil

                    local nextTarget = A.FindTarget()
                    if nextTarget then
                        A.AutoAttackTarget = nextTarget
                    else
                        break
                    end
                else
                    local dist = A.GetTargetDistance(currentTarget)
                    if dist > A.AttackRange * 2 then
                        local myHRP = GetMyHRP()
                        local targetHRP = GetHRP(currentTarget)
                        if myHRP and targetHRP then
                            pcall(function()
                                myHRP.CFrame = CFrame.new(targetHRP.Position)
                            end)
                            task.wait(0.1)
                        end
                    elseif dist > A.AttackRange then
                        local myHRP = GetMyHRP()
                        local targetHRP = GetHRP(currentTarget)
                        if myHRP and targetHRP then
                            pcall(function()
                                local pos = targetHRP.Position
                                local dir = (pos - myHRP.Position)
                                if dir.Magnitude > 0 then
                                    dir = dir.Unit
                                else
                                    dir = Vector3.new(0, 0, -1)
                                end
                                myHRP.CFrame = CFrame.new(myHRP.Position + (dir * 10))
                            end)
                            task.wait(0.08)
                        end
                    else
                        local comboName = A.GetComboByRange(dist)
                        A.ComboAttack(currentTarget, comboName)
                        task.wait(A.AttackSpeed)
                    end
                end
            else
                A.AutoAttackTarget = nil
                local nextTarget = A.FindTarget()
                if nextTarget then
                    A.AutoAttackTarget = nextTarget
                else
                    task.wait(0.5)
                    break
                end
            end
        end

        A.AutoAttackEnabled = false
        A.CombatState = "Idle"
        end)
    end)
end

function A.StopAutoAttack()
    A.AutoAttackEnabled = false
    A.AutoAttackTarget = nil
    A.CombatState = "Idle"

    if A.AttackThread then
        task.cancel(A.AttackThread)
        A.AttackThread = nil
    end

    StopAntiKick()
end

function A.AttackLoop()
    while A.AutoAttackEnabled do
        task.wait(0.05)

        local target = A.AutoAttackTarget

        if not target then
            A.CombatState = "Searching"
            target = A.FindTarget()
            if target then
                A.AutoAttackTarget = target
                A.CombatState = "Attacking"
            else
                task.wait(0.5)
                break
            end
        end

        if target and target.Parent then
            local isAlive = IsAlive(target)
            if not isAlive then
                A.LogKill(target, "AttackLoop", tick())
                A.AutoAttackTarget = nil
                local nextTarget = A.FindTarget()
                if nextTarget then
                    A.AutoAttackTarget = nextTarget
                else
                    break
                end
            else
                local dist = A.GetTargetDistance(target)

                local myHumanoid = GetMyHumanoid()
                if myHumanoid and myHumanoid.Health < myHumanoid.MaxHealth * 0.2 then
                    A.CombatState = "Retreat"
                    A.ShouldRetreat()
                    task.wait(1)
                    break
                end

                local stunCheck = A.AntiStun()
                if not stunCheck then
                    if dist <= A.AttackRange then
                        local comboName = A.GetComboByRange(dist)
                        A.ExecuteCombo(target, comboName)
                    else
                        local myHRP = GetMyHRP()
                        local targetHRP = GetHRP(target)
                        if myHRP and targetHRP then
                            pcall(function()
                                local pos = targetHRP.Position
                                local dir = (pos - myHRP.Position)
                                if dir.Magnitude > 0 then
                                    dir = dir.Unit
                                else
                                    dir = Vector3.new(0, 0, -1)
                                end
                                myHRP.CFrame = CFrame.new(myHRP.Position + (dir * 15))
                            end)
                        end
                        task.wait(0.1)
                    end
                else
                    task.wait(0.2)
                end
            end
        else
            A.AutoAttackTarget = nil
            local nextTarget = A.FindTarget()
            if nextTarget then
                A.AutoAttackTarget = nextTarget
            else
                break
            end
        end
    end
end

---------------------------------------------------------------------------
-- Damage Calculation
---------------------------------------------------------------------------

function A.CalcDamage(baseDamage, multiplier, defense)
    multiplier = multiplier or 1
    defense = defense or 0

    local rawDamage = baseDamage * multiplier
    local mitigatedDamage = rawDamage * (100 / (100 + defense))

    return math.floor(mitigatedDamage)
end

function A.GetMyDamage()
    local damage = 0

    local char = GetCharacter()
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            local damageValues = {
                tool:FindFirstChild("Damage"),
                tool:FindFirstChild("Dmg"),
                tool:FindFirstChild("AttackDamage"),
            }
            for _, dv in ipairs(damageValues) do
                if dv and dv:IsA("ValueBase") then
                    damage = dv.Value
                    break
                end
            end
        end
    end

    if damage == 0 then
        damage = 100
    end

    local myHumanoid = GetMyHumanoid()
    if myHumanoid then
        damage = damage * (1 + (myHumanoid.MaxHealth / 10000))
    end

    return damage
end

function A.GetEnemyDefense(target)
    if not target then return 0 end

    local defense = 0
    local hum = target:FindFirstChild("Humanoid")
    if hum then
        defense = math.floor(hum.MaxHealth * 0.1)
    end

    local values = {
        target:FindFirstChild("Defense"),
        target:FindFirstChild("Def"),
        target:FindFirstChild("Armor"),
    }
    for _, v in ipairs(values) do
        if v and v:IsA("ValueBase") then
            defense = v.Value
            break
        end
    end

    return defense
end

function A.TimeToKill(target)
    if not target then return math.huge end

    local health = A.GetTargetHealth(target)
    local defense = A.GetEnemyDefense(target)
    local myDamage = A.GetMyDamage()

    if myDamage <= 0 then return math.huge end

    local effectiveDamage = A.CalcDamage(myDamage, 1, defense)
    if effectiveDamage <= 0 then return math.huge end

    local hitsNeeded = math.ceil(health / effectiveDamage)
    local estimatedTime = hitsNeeded * A.AttackSpeed

    return estimatedTime
end

function A.GetDPS()
    local myDamage = A.GetMyDamage()
    if A.AttackSpeed > 0 then
        return myDamage / A.AttackSpeed
    end
    return 0
end

function A.OptimalSkill(target)
    if not target then return "Click" end

    local dist = A.GetTargetDistance(target)
    local health = A.GetTargetHealth(target)
    local myHealth = 0
    local myHumanoid = GetMyHumanoid()
    if myHumanoid then
        myHealth = myHumanoid.Health / myHumanoid.MaxHealth
    end

    if myHealth < 0.3 then
        if dist <= 10 then
            return "V"
        else
            return "F"
        end
    end

    if health < A.GetMyDamage() * 3 then
        if dist <= 10 then
            return "C"
        else
            return "Z"
        end
    end

    if dist <= 8 then
        if math.random(1, 100) <= 30 then
            return "Z"
        elseif math.random(1, 100) <= 50 then
            return "X"
        else
            return "Click"
        end
    elseif dist <= 18 then
        local skills = {"Z", "X", "C"}
        return skills[math.random(1, #skills)]
    else
        local longRange = {"Z", "X", "V", "F"}
        return longRange[math.random(1, #longRange)]
    end
end

---------------------------------------------------------------------------
-- Kill Tracking
---------------------------------------------------------------------------

function A.LogKill(target, method, time)
    if not target then return end

    A.KillCount = A.KillCount + 1

    local killEntry = {
        name = target.Name,
        method = method or "Unknown",
        time = time or tick(),
        health = A.GetTargetHealth(target),
    }
    table.insert(A.KillLog, killEntry)

    if #A.KillLog > 100 then
        table.remove(A.KillLog, 1)
    end
end

function A.GetKillsPerMinute()
    if #A.KillLog == 0 then return 0 end

    local now = tick()
    local oneMinuteAgo = now - 60
    local count = 0

    for _, entry in ipairs(A.KillLog) do
        if entry.time >= oneMinuteAgo then
            count = count + 1
        end
    end

    return count
end

function A.ResetKillStats()
    A.KillCount = 0
    A.ComboCount = 0
    A.TotalDamage = 0
    A.KillLog = {}
end

---------------------------------------------------------------------------
-- Smart Combat
---------------------------------------------------------------------------

function A.PredictTarget(target, time)
    if not target then return nil end

    local targetHRP = GetHRP(target)
    if not targetHRP then return nil end

    local hum = target:FindFirstChild("Humanoid")
    if not hum then return targetHRP.Position end

    local currentPos = targetHRP.Position
    local currentVel = targetHRP.Velocity

    local predictedPos = currentPos + (currentVel * time)

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {target, GetCharacter()}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local rayResult = workspace:Raycast(
        currentPos,
        (predictedPos - currentPos),
        rayParams
    )

    if rayResult then
        return rayResult.Position
    end

    return predictedPos
end

function A.LeadTarget(target, speed)
    if not target then return nil end

    local targetHRP = GetHRP(target)
    local myHRP = GetMyHRP()
    if not targetHRP or not myHRP then return nil end

    local targetPos = targetHRP.Position
    local targetVel = targetHRP.Velocity
    local myPos = myHRP.Position

    local dist = (targetPos - myPos).Magnitude
    local travelTime = dist / math.max(speed, 1)

    local predictedPos = targetPos + (targetVel * travelTime)

    return predictedPos
end

function A.OptimalPosition(target, range)
    if not target then return nil end

    local targetHRP = GetHRP(target)
    local myHRP = GetMyHRP()
    if not targetHRP or not myHRP then return nil end

    local targetPos = targetHRP.Position
    local myPos = myHRP.Position

    local dirToTarget = (targetPos - myPos)
    if dirToTarget.Magnitude > 0 then
        dirToTarget = dirToTarget.Unit
    else
        dirToTarget = Vector3.new(0, 0, -1)
    end

    local optimalPos = targetPos + (dirToTarget * -range)

    return optimalPos
end

function A.ShouldChase(target)
    if not target then return false end

    local dist = A.GetTargetDistance(target)
    local health = A.GetTargetHealth(target)
    local myHumanoid = GetMyHumanoid()

    if not myHumanoid then return false end

    if myHumanoid.Health < myHumanoid.MaxHealth * 0.3 then
        return false
    end

    if dist > A.AttackRange * 3 then
        return false
    end

    local hum = target:FindFirstChild("Humanoid")
    if hum then
        if hum.Health < myHumanoid.MaxHealth * 0.5 then
            return true
        end
    end

    if dist > A.AttackRange and dist <= A.AttackRange * 3 then
        return true
    end

    return false
end

function A.ShouldRetreat()
    local myHumanoid = GetMyHumanoid()
    if not myHumanoid then return false end

    local healthPercent = myHumanoid.Health / myHumanoid.MaxHealth

    if healthPercent < 0.15 then
        return true
    end

    if healthPercent < 0.3 then
        local nearbyEnemies = 0
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local pChar = player.Character
                if pChar then
                    local dist = A.GetTargetDistance(pChar)
                    if dist <= 20 then
                        nearbyEnemies = nearbyEnemies + 1
                    end
                end
            end
        end

        if nearbyEnemies >= 3 then
            return true
        end
    end

    return false
end

function A.CombatDecision()
    if A.ShouldRetreat() then
        A.CombatState = "Retreating"
        local myHRP = GetMyHRP()
        if myHRP then
            local safeDir = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
            pcall(function()
                myHRP.CFrame = CFrame.new(myHRP.Position + (safeDir * 50))
            end)
        end
        return "Retreat"
    end

    local target = A.AutoAttackTarget
    if target and A.ValidateTarget(target) then
        local dist = A.GetTargetDistance(target)
        if dist > A.AttackRange * 1.5 then
            if A.ShouldChase(target) then
                A.CombatState = "Chasing"
                return "Chase"
            else
                return "Hold"
            end
        else
            A.CombatState = "Attacking"
            return "Attack"
        end
    end

    local newTarget = A.FindTarget()
    if newTarget then
        A.AutoAttackTarget = newTarget
        A.CombatState = "Acquiring"
        return "Acquire"
    end

    A.CombatState = "Idle"
    return "Idle"
end

---------------------------------------------------------------------------
-- Anti-Combat Systems
---------------------------------------------------------------------------

function A.AntiStun()
    if not A.AntiStunEnabled then return false end

    local myHumanoid = GetMyHumanoid()
    if not myHumanoid then return false end

    local isStunned = false

    local char = GetCharacter()
    if char then
        local effects = char:FindFirstChild("Effects") or char:FindFirstChild("StatusEffects")
        if effects then
            for _, effect in ipairs(effects:GetChildren()) do
                if effect.Name == "Stun" or effect.Name == "Stunned" then
                    isStunned = true
                    break
                end
            end
        end

        local bodyEffects = char:FindFirstChild("BodyEffects")
        if bodyEffects then
            for _, effect in ipairs(bodyEffects:GetChildren()) do
                if effect.Name == "Stun" or effect.Name == "Stunned" or effect.Name == "Down" then
                    isStunned = true
                    break
                end
            end
        end
    end

    if isStunned then
        pcall(function()
            myHumanoid.PlatformStand = false
        end)
        pcall(function()
            local animator = myHumanoid:FindFirstChildOfClass("Animator")
            if animator then
                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    if track.Name == "Stun" or track.Name == "Stunned" then
                        track:Stop(0)
                    end
                end
            end
        end)
        task.wait(0.1)
        return true
    end

    return false
end

function A.AntiCombo()
    if not A.AntiComboEnabled then return false end

    local myHumanoid = GetMyHumanoid()
    local myHRP = GetMyHRP()
    if not myHumanoid or not myHRP then return false end

    local incomingDamage = false

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local pChar = player.Character
            if pChar then
                local pHum = pChar:FindFirstChild("Humanoid")
                local pHRP = GetHRP(pChar)
                if pHum and pHRP then
                    local dist = DistanceTo(myHRP, pHRP)
                    if dist <= 10 then
                        local myHealthBefore = myHumanoid.Health
                        task.wait(0.1)
                        local myHealthAfter = myHumanoid.Health
                        if myHealthAfter < myHealthBefore then
                            incomingDamage = true
                        end
                    end
                end
            end
        end
    end

    if incomingDamage then
        local randomDir = Vector3.new(math.random(-1, 1), 0.3, math.random(-1, 1)).Unit
        pcall(function()
            myHRP.CFrame = CFrame.new(myHRP.Position + (randomDir * 20))
        end)
        task.wait(0.15)
        return true
    end

    return false
end

function A.AntiGlide()
    if not A.AntiGlideEnabled then return false end

    local myHRP = GetMyHRP()
    local myHumanoid = GetMyHumanoid()
    if not myHRP or not myHumanoid then return false end

    local pos = myHRP.Position
    local vel = myHRP.Velocity

    if vel.Y < -50 then
        pcall(function()
            myHumanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
        task.wait(0.05)
        return true
    end

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {GetCharacter()}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local rayResult = workspace:Raycast(
        pos,
        Vector3.new(0, -20, 0),
        rayParams
    )

    if rayResult and rayResult.Distance > 3 then
        if vel.Magnitude < 1 then
            pcall(function()
                myHumanoid:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
    end

    return false
end

function A.DodgeAttack()
    local myHRP = GetMyHRP()
    local myHumanoid = GetMyHumanoid()
    if not myHRP or not myHumanoid then return false end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local pChar = player.Character
            if pChar then
                local pHRP = GetHRP(pChar)
                if pHRP then
                    local dist = DistanceTo(myHRP, pHRP)
                    if dist <= 15 then
                        local toMe = (myHRP.Position - pHRP.Position).Unit
                        local dodgeDir = toMe * 25

                        pcall(function()
                            myHRP.CFrame = CFrame.new(myHRP.Position + dodgeDir)
                        end)
                        task.wait(0.1)
                        return true
                    end
                end
            end
        end
    end

    return false
end

---------------------------------------------------------------------------
-- Team Fight Support
---------------------------------------------------------------------------

function A.AssistAlly(ally)
    if not ally then return false end

    local target = A.FindTarget(A.AttackRange * 1.5)
    if target then
        A.AutoAttackTarget = target
        local dist = A.GetTargetDistance(target)
        local comboName = A.GetComboByRange(dist)
        return A.ComboAttack(target, comboName)
    end

    return false
end

function A.HealAlly(ally)
    if not ally then return false end

    local myHRP = GetMyHRP()
    local allyHRP = GetHRP(ally)
    if not myHRP or not allyHRP then return false end

    local dist = DistanceTo(myHRP, allyHRP)
    if dist <= 20 then
        local healRemote = GetRemote("Heal") or GetRemote("HealPlayer")
        if healRemote then
            if healRemote:IsA("RemoteEvent") then
                healRemote:FireServer(ally)
            elseif healRemote:IsA("RemoteFunction") then
                healRemote:InvokeServer(ally)
            end
            return true
        end

        PressSkillKey("H")
        task.wait(0.2)
        return true
    end

    return false
end

function A.PullEnemies()
    local myHRP = GetMyHRP()
    if not myHRP then return false end

    local pulled = 0

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local pChar = player.Character
            if pChar then
                local pHRP = GetHRP(pChar)
                if pHRP then
                    local dist = DistanceTo(myHRP, pHRP)
                    if dist <= 50 and dist > 15 then
                        local dirToMe = (myHRP.Position - pHRP.Position).Unit
                        local pullTarget = myHRP.Position + (dirToMe * -5)

                        local aggroRemote = GetRemote("Aggro") or GetRemote("Pull") or GetRemote("Taunt")
                        if aggroRemote then
                            if aggroRemote:IsA("RemoteEvent") then
                                aggroRemote:FireServer(pChar)
                            end
                            pulled = pulled + 1
                        end
                    end
                end
            end
        end
    end

    return pulled > 0
end

---------------------------------------------------------------------------
-- Combat State Management
---------------------------------------------------------------------------

function A.GetCombatState()
    return A.CombatState
end

function A.SetCombatState(state)
    A.CombatState = state
end

function A.IsCombatActive()
    return A.AutoAttackEnabled or A.AttackLock or A.ComboActive
end

function A.GetCombatStats()
    return {
        State = A.CombatState,
        KillCount = A.KillCount,
        ComboCount = A.ComboCount,
        TotalDamage = A.TotalDamage,
        KillsPerMinute = A.GetKillsPerMinute(),
        DPS = A.GetDPS(),
        AutoAttack = A.AutoAttackEnabled,
        Target = A.AutoAttackTarget and A.AutoAttackTarget.Name or "None",
        CurrentCombo = A.CurrentCombo or "None",
        ComboIndex = A.ComboIndex,
        BlacklistSize = #A.Blacklist,
    }
end

function A.ForceStop()
    A.StopAutoAttack()
    A.AttackLock = false
    A.ComboActive = false
    A.CombatState = "Idle"
    A.ResetCombo()
    StopAntiKick()
end

---------------------------------------------------------------------------
-- Initialization
---------------------------------------------------------------------------

function A.Initialize()
    A.ForceStop()
    A.AddBuiltInCombos()
    A.ClearBlacklist()

    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(1)
        if A.AutoAttackEnabled then
            A.StopAutoAttack()
            task.wait(0.5)
        end
    end)
end

-- Aliases for tabs.lua compatibility
A.StartAura = A.StartAutoAttack
A.StopAura = A.StopAutoAttack
A.GetTarget = function()
    return A.AutoAttackTarget
end
A.IsAuraActive = function()
    return A.AutoAttackEnabled
end

_G.Apex.Combat = A
return A
