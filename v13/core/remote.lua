--[[
    Apex Hub v13.0 APEX ULTIMATE
    Remote Function Wrapper System
    Core Module: remote.lua
    Lines: 500+
    
    Comprehensive remote management with caching, monitoring,
    hooking, argument building, and anti-detection systems.
]]

local A = _G.Apex or {}

A.RemoteSystem = A.RemoteSystem or {}
A.RemoteSystem.Version = "13.0"
A.RemoteSystem.Initialized = false

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- ============================================================================
-- SECTION 1: REMOTE CACHING SYSTEM
-- ============================================================================

A.Remotes = A.Remotes or {}
A.RemoteCache = A.RemoteCache or {}
A.RemoteCallCount = 0
A.RemoteErrors = 0
A.RemoteLog = A.RemoteLog or {}
A.RemoteCallTiming = A.RemoteCallTiming or {}
A.HookedRemotes = A.HookedRemotes or {}
A.MonitorActive = false
A.RemoteMonitorThread = nil
A.MaxLogEntries = 50
A.MaxRetries = 3
A.RetryDelay = 0.5
A.CallRateLimit = 0.1
A.LastCallTimestamp = 0

-- ============================================================================
-- SECTION 2: REMOTE PATTERNS AND EXPECTED NAMES
-- ============================================================================

A.RemotePatterns = {
    CommF_ = "Remotes",
    CommE_ = "Remotes",
    BuyItem = "Remotes",
    BuyDevilFruit = "Remotes",
    MassItem = "Remotes",
    ItemRequest = "Remotes",
    TeachSong = "Remotes",
    LearnAbility = "Remotes",
    SetTeam = "Remotes",
    GetInventory = "Remotes",
    GetInventoryData = "Remotes",
    BuyAllFrutis = "Remotes",
    EnergyControl = "Remotes",
    RemoteEvent = "Remotes",
    Skill = "Remotes",
    Block = "Remotes",
    Dodge = "Remotes",
    Soru = "Remotes",
    Geppo = "Remotes",
    Aura = "Remotes",
    TravelShip = "Remotes",
    BuyChip = "Remotes",
    RequestRaid = "Remotes",
    Raid = "Remotes",
    ActivateTurret = "Remotes",
    RaceV4 = "Remotes",
    AwakenTalent = "Remotes",
    TrialStart = "Remotes",
    Title = "Remotes",
    ClaimQuest = "Remotes",
    CompleteQuest = "Remotes",
    AbandonQuest = "Remotes",
    GetQuests = "Remotes",
    EquipGun = "Remotes",
    EquipSword = "Remotes",
    unequip = "Remotes",
    RefundStat = "Remotes",
    RerollRace = "Remotes",
}

A.RemoteNames = {
    "CommF_",
    "CommE_",
    "BuyItem",
    "BuyDevilFruit",
    "MassItem",
    "ItemRequest",
    "TeachSong",
    "LearnAbility",
    "SetTeam",
    "GetInventory",
    "GetInventoryData",
    "BuyAllFrutis",
    "EnergyControl",
    "RemoteEvent",
    "Skill",
    "Block",
    "Dodge",
    "Soru",
    "Geppo",
    "Aura",
    "TravelShip",
    "BuyChip",
    "RequestRaid",
    "Raid",
    "ActivateTurret",
    "RaceV4",
    "AwakenTalent",
    "TrialStart",
    "Title",
    "ClaimQuest",
    "CompleteQuest",
    "AbandonQuest",
    "GetQuests",
    "EquipGun",
    "EquipSword",
    "unequip",
    "RefundStat",
    "RerollRace",
    "Fly",
    "Dive",
    "GrabChest",
    "Click",
    "BuyHakiColor",
    "AddPoint",
}

-- ============================================================================
-- SECTION 3: REMOTE DISCOVERY
-- ============================================================================

function A.FindRemoteDeep(name, parent, depth)
    depth = depth or 0
    parent = parent or RS

    if depth > 20 then
        return nil
    end

    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            if child.Name == name then
                return child
            end
        end

        if child:IsA("Folder") or child:IsA("Model") then
            local found = A.FindRemoteDeep(name, child, depth + 1)
            if found then
                return found
            end
        end
    end

    return nil
end

function A.FindRemote(name)
    if not name or type(name) ~= "string" then
        return nil
    end

    if A.RemoteCache[name] then
        local cached = A.RemoteCache[name]
        if cached and cached.Parent then
            return cached
        else
            A.RemoteCache[name] = nil
        end
    end

    if A.Remotes[name] then
        local ref = A.Remotes[name]
        if ref and ref.Parent then
            A.RemoteCache[name] = ref
            return ref
        else
            A.Remotes[name] = nil
            A.RemoteCache[name] = nil
        end
    end

    local pattern = A.RemotePatterns[name]
    if pattern then
        local searchParent = RS:FindFirstChild(pattern)
        if searchParent then
            local remote = searchParent:FindFirstChild(name)
            if remote then
                A.Remotes[name] = remote
                A.RemoteCache[name] = remote
                return remote
            end
        end
    end

    local remote = A.FindRemoteDeep(name, RS)
    if remote then
        A.Remotes[name] = remote
        A.RemoteCache[name] = remote
        return remote
    end

    remote = A.FindRemoteDeep(name, game)
    if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
        A.Remotes[name] = remote
        A.RemoteCache[name] = remote
        return remote
    end

    return nil
end

function A.GetCommF()
    if A.Remotes.CommF_ and A.Remotes.CommF_.Parent then
        return A.Remotes.CommF_
    end
    local remote = A.FindRemote("CommF_")
    if remote then
        A.Remotes.CommF_ = remote
        return remote
    end
    return nil
end

function A.GetCommE()
    if A.Remotes.CommE_ and A.Remotes.CommE_.Parent then
        return A.Remotes.CommE_
    end
    local remote = A.FindRemote("CommE_")
    if remote then
        A.Remotes.CommE_ = remote
        return remote
    end
    return nil
end

function A.RefreshRemotes()
    A.RemoteCache = {}

    for _, name in ipairs(A.RemoteNames) do
        A.FindRemote(name)
    end

    A.GetCommF()
    A.GetCommE()

    return A.Remotes
end

function A.DiscoverAllRemotes()
    A.RefreshRemotes()

    local discovered = {}
    local function scan(parent, path, depth)
        depth = depth or 0
        if depth > 15 then return end

        for _, child in ipairs(parent:GetChildren()) do
            local currentPath = path .. "." .. child.Name
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                discovered[#discovered + 1] = {
                    Name = child.Name,
                    Class = child.ClassName,
                    Path = currentPath,
                    Instance = child,
                }
            end
            if child:IsA("Folder") or child:IsA("Model") then
                scan(child, currentPath, depth + 1)
            end
        end
    end

    scan(RS, "ReplicatedStorage", 0)
    return discovered
end

-- ============================================================================
-- SECTION 4: REMOTE VALIDATION AND SANITIZATION
-- ============================================================================

function A.ValidateRemoteArgs(args)
    if not args or type(args) ~= "table" then
        return false, "Args must be a table"
    end

    for i, v in ipairs(args) do
        local t = type(v)
        if t == "userdata" and typeof then
            local dt = typeof(v)
            if dt == "Instance" then
                if not v.Parent then
                    return false, "Arg " .. i .. " is a destroyed Instance"
                end
            elseif dt == "CFrame" or dt == "Vector3" or dt == "Color3" then
                -- valid types
            elseif dt == "EnumItem" then
                -- valid type
            else
                return false, "Arg " .. i .. " has unsupported typeof: " .. dt
            end
        elseif t ~= "string" and t ~= "number" and t ~= "boolean" and t ~= "nil" and t ~= "table" then
            return false, "Arg " .. i .. " has unsupported type: " .. t
        end
    end

    return true, "Valid"
end

function A.SanitizeArgs(args)
    if not args or type(args) ~= "table" then
        return {}
    end

    local sanitized = {}
    for i, v in ipairs(args) do
        local t = type(v)
        if t == "string" then
            local clean = v:gsub("[\0-\31]", "")
            clean = clean:gsub("\\0", "")
            clean = clean:gsub("\\x", "")
            if #clean > 10000 then
                clean = string.sub(clean, 1, 10000)
            end
            sanitized[i] = clean
        elseif t == "number" then
            if v ~= v then
                sanitized[i] = 0
            elseif v == math.huge or v == -math.huge then
                sanitized[i] = 0
            else
                sanitized[i] = v
            end
        elseif t == "boolean" then
            sanitized[i] = v
        elseif t == "nil" then
            sanitized[i] = nil
        elseif t == "table" then
            sanitized[i] = A.SanitizeArgs(v)
        elseif t == "userdata" then
            if typeof then
                local dt = typeof(v)
                if dt == "Instance" and v.Parent then
                    sanitized[i] = v
                elseif dt == "CFrame" or dt == "Vector3" or dt == "Color3" or dt == "EnumItem" then
                    sanitized[i] = v
                else
                    sanitized[i] = nil
                end
            else
                sanitized[i] = v
            end
        else
            sanitized[i] = nil
        end
    end

    return sanitized
end

function A.ArgsToString(args)
    if not args or type(args) ~= "table" then
        return "nil"
    end

    local parts = {}
    for i, v in ipairs(args) do
        local t = type(v)
        if t == "string" then
            if #v > 100 then
                parts[i] = '"' .. string.sub(v, 1, 100) .. '..."'
            else
                parts[i] = '"' .. v .. '"'
            end
        elseif t == "number" then
            parts[i] = tostring(v)
        elseif t == "boolean" then
            parts[i] = v and "true" or "false"
        elseif t == "nil" then
            parts[i] = "nil"
        elseif t == "userdata" then
            if typeof then
                local dt = typeof(v)
                if dt == "Instance" then
                    parts[i] = "Instance:" .. v.ClassName .. "(" .. v.Name .. ")"
                else
                    parts[i] = dt .. "()"
                end
            else
                parts[i] = "userdata"
            end
        elseif t == "table" then
            local subStr = A.ArgsToString(v)
            if #subStr > 80 then
                parts[i] = "{" .. string.sub(subStr, 1, 80) .. "...}"
            else
                parts[i] = "{" .. subStr .. "}"
            end
        else
            parts[i] = t .. "()"
        end
    end

    return table.concat(parts, ", ")
end

-- ============================================================================
-- SECTION 5: REMOTE LOGGING
-- ============================================================================

function A.LogRemote(remote, args, result, duration, errorOccurred)
    local entry = {
        Timestamp = tick(),
        RemoteName = remote and remote.Name or "Unknown",
        RemoteClass = remote and remote.ClassName or "Unknown",
        Args = args,
        Result = result,
        Duration = duration or 0,
        Success = not errorOccurred,
        ArgsString = A.ArgsToString(args),
    }

    if type(result) == "table" then
        entry.ResultString = A.ArgsToString(result)
    elseif type(result) == "string" then
        entry.ResultString = #result > 200 and string.sub(result, 1, 200) .. "..." or result
    else
        entry.ResultString = tostring(result)
    end

    table.insert(A.RemoteLog, entry)

    while #A.RemoteLog > A.MaxLogEntries do
        table.remove(A.RemoteLog, 1)
    end

    if errorOccurred then
        A.RemoteErrors = A.RemoteErrors + 1
    end

    A.RemoteCallCount = A.RemoteCallCount + 1

    if A.RemoteCallTiming[entry.RemoteName] then
        local timing = A.RemoteCallTiming[entry.RemoteName]
        local calls = timing.Count + 1
        timing.TotalTime = timing.TotalTime + duration
        timing.AvgTime = timing.TotalTime / calls
        timing.Count = calls
        if duration > timing.MaxTime then
            timing.MaxTime = duration
        end
        if timing.MinTime == 0 or duration < timing.MinTime then
            timing.MinTime = duration
        end
    else
        A.RemoteCallTiming[entry.RemoteName] = {
            TotalTime = duration or 0,
            AvgTime = duration or 0,
            MaxTime = duration or 0,
            MinTime = duration or 0,
            Count = 1,
        }
    end

    return entry
end

function A.GetRemoteLog()
    return A.RemoteLog
end

function A.ClearRemoteLog()
    A.RemoteLog = {}
end

-- ============================================================================
-- SECTION 6: SAFE REMOTE CALLING
-- ============================================================================

function A.FireServer(remote, ...)
    if not remote then
        A.RemoteErrors = A.RemoteErrors + 1
        return nil
    end

    local remoteName = remote.Name
    local remoteClass = remote.ClassName
    local args = { ... }
    local startTime = tick()

    local cleanArgs = A.SanitizeArgs(args)

    local rateCheck = tick() - A.LastCallTimestamp
    if rateCheck < A.CallRateLimit then
        local waitTime = A.CallRateLimit - rateCheck
        if waitTime > 0 then
            task.wait(waitTime)
        end
    end
    A.LastCallTimestamp = tick()

    local success, result = pcall(function()
        if remoteClass == "RemoteEvent" then
            remote:FireServer(unpack(cleanArgs))
            return true
        else
            return remote:InvokeServer(unpack(cleanArgs))
        end
    end)

    local duration = tick() - startTime

    if not success then
        A.LogRemote(remote, cleanArgs, result, duration, true)
        warn("[Apex Hub] Remote call failed: " .. remoteName .. " | Error: " .. tostring(result))
        return nil
    else
        A.LogRemote(remote, cleanArgs, result, duration, false)
    end

    return result
end

function A.InvokeServer(remote, ...)
    if not remote then
        A.RemoteErrors = A.RemoteErrors + 1
        return nil
    end

    if remote.ClassName ~= "RemoteFunction" then
        warn("[Apex Hub] InvokeServer called on non-RemoteFunction: " .. remote.ClassName)
        return nil
    end

    local remoteName = remote.Name
    local args = { ... }
    local startTime = tick()

    local cleanArgs = A.SanitizeArgs(args)

    local rateCheck = tick() - A.LastCallTimestamp
    if rateCheck < A.CallRateLimit then
        local waitTime = A.CallRateLimit - rateCheck
        if waitTime > 0 then
            task.wait(waitTime)
        end
    end
    A.LastCallTimestamp = tick()

    local success, result = pcall(function()
        return remote:InvokeServer(unpack(cleanArgs))
    end)

    local duration = tick() - startTime

    if not success then
        A.LogRemote(remote, cleanArgs, result, duration, true)
        warn("[Apex Hub] InvokeServer failed: " .. remoteName .. " | Error: " .. tostring(result))
        return nil
    else
        A.LogRemote(remote, cleanArgs, result, duration, false)
    end

    return result
end

function A.CommF(...)
    local remote = A.GetCommF()
    if not remote then
        warn("[Apex Hub] CommF_ remote not found!")
        return nil
    end

    local args = { ... }
    local lastResult = nil
    local lastError = nil

    for attempt = 1, A.MaxRetries do
        local startTime = tick()

        local cleanArgs = A.SanitizeArgs(args)

        local rateCheck = tick() - A.LastCallTimestamp
        if rateCheck < A.CallRateLimit then
            local waitTime = A.CallRateLimit - rateCheck
            if waitTime > 0 then
                task.wait(waitTime)
            end
        end
        A.LastCallTimestamp = tick()

        local success, result = pcall(function()
            return remote:InvokeServer(unpack(cleanArgs))
        end)

        local duration = tick() - startTime

        if success then
            A.LogRemote(remote, cleanArgs, result, duration, false)
            return result
        else
            lastError = result
            lastResult = result
            A.LogRemote(remote, cleanArgs, result, duration, true)

            if attempt < A.MaxRetries then
                warn("[Apex Hub] CommF_ attempt " .. attempt .. "/" .. A.MaxRetries .. " failed: " .. tostring(result))
                task.wait(A.RetryDelay * attempt)
                remote = A.GetCommF()
                if not remote then
                    warn("[Apex Hub] CommF_ lost during retry")
                    return nil
                end
            end
        end
    end

    warn("[Apex Hub] CommF_ all retries exhausted | Last error: " .. tostring(lastError))
    return nil
end

function A.CommE(...)
    local remote = A.GetCommE()
    if not remote then
        warn("[Apex Hub] CommE_ remote not found!")
        return nil
    end

    local args = { ... }
    local lastResult = nil
    local lastError = nil

    for attempt = 1, A.MaxRetries do
        local startTime = tick()

        local cleanArgs = A.SanitizeArgs(args)

        local rateCheck = tick() - A.LastCallTimestamp
        if rateCheck < A.CallRateLimit then
            local waitTime = A.CallRateLimit - rateCheck
            if waitTime > 0 then
                task.wait(waitTime)
            end
        end
        A.LastCallTimestamp = tick()

        local success, result = pcall(function()
            return remote:InvokeServer(unpack(cleanArgs))
        end)

        local duration = tick() - startTime

        if success then
            A.LogRemote(remote, cleanArgs, result, duration, false)
            return result
        else
            lastError = result
            lastResult = result
            A.LogRemote(remote, cleanArgs, result, duration, true)

            if attempt < A.MaxRetries then
                warn("[Apex Hub] CommE_ attempt " .. attempt .. "/" .. A.MaxRetries .. " failed: " .. tostring(result))
                task.wait(A.RetryDelay * attempt)
                remote = A.GetCommE()
                if not remote then
                    warn("[Apex Hub] CommE_ lost during retry")
                    return nil
                end
            end
        end
    end

    warn("[Apex Hub] CommE_ all retries exhausted | Last error: " .. tostring(lastError))
    return nil
end

function A.BatchRemotes(calls)
    if not calls or type(calls) ~= "table" then
        return {}
    end

    local results = {}
    for i, call in ipairs(calls) do
        local remoteName = call[1]
        local args = { unpack(call, 2) }

        local remote = A.FindRemote(remoteName)
        if remote then
            if remote.ClassName == "RemoteFunction" then
                local success, result = pcall(function()
                    return remote:InvokeServer(unpack(args))
                end)
                results[i] = {
                    Success = success,
                    Result = result,
                    Remote = remoteName,
                }
            else
                local success, result = pcall(function()
                    remote:FireServer(unpack(args))
                    return true
                end)
                results[i] = {
                    Success = success,
                    Result = result,
                    Remote = remoteName,
                }
            end
        else
            results[i] = {
                Success = false,
                Result = nil,
                Remote = remoteName,
                Error = "Remote not found",
            }
        end

        RunService.Heartbeat:Wait()
    end

    return results
end

-- ============================================================================
-- SECTION 7: REMOTE ARGUMENT BUILDERS
-- ============================================================================

-- Quest operations
function A.R_QuestStart(questName)
    if not questName or type(questName) ~= "string" then
        return nil, "Quest name must be a string"
    end
    return { "CommF_", "quest" .. questName }
end

function A.R_QuestComplete(questName)
    if not questName or type(questName) ~= "string" then
        return nil, "Quest name must be a string"
    end
    return { "CommF_", "Complete" .. questName }
end

function A.R_QuestAbandon(questName)
    if not questName or type(questName) ~= "string" then
        return nil, "Quest name must be a string"
    end
    return { "CommF_", "Abandon" .. questName }
end

function A.R_GetQuests()
    return { "CommF_", "GetQuests" }
end

function A.ExecuteQuestStart(questName)
    local callArgs, err = A.R_QuestStart(questName)
    if not callArgs then return false, err end
    return A.CommF(unpack(callArgs))
end

function A.ExecuteQuestComplete(questName)
    local callArgs, err = A.R_QuestComplete(questName)
    if not callArgs then return false, err end
    return A.CommF(unpack(callArgs))
end

function A.ExecuteQuestAbandon(questName)
    local callArgs, err = A.R_QuestAbandon(questName)
    if not callArgs then return false, err end
    return A.CommF(unpack(callArgs))
end

function A.ExecuteGetQuests()
    local callArgs = A.R_GetQuests()
    return A.CommF(unpack(callArgs))
end

-- Combat operations
function A.R_Attack(tool, target, position)
    local args = {}
    args[1] = "CommF_"
    args[2] = "Buy"
    if tool then
        args[3] = tool
    end
    if target then
        args[4] = target
    end
    if position then
        if typeof(position) == "Vector3" then
            args[5] = position.X
            args[6] = position.Y
            args[7] = position.Z
        elseif typeof(position) == "CFrame" then
            args[5] = position.Position.X
            args[6] = position.Position.Y
            args[7] = position.Position.Z
        else
            args[5] = 0
            args[6] = 0
            args[7] = 0
        end
    end
    return args
end

function A.R_Skill(skillName, direction)
    local args = {}
    args[1] = "CommF_"
    args[2] = "Skill"
    args[3] = skillName or "Normal"
    if direction then
        if typeof(direction) == "Vector3" then
            args[4] = direction.X
            args[5] = direction.Y
            args[6] = direction.Z
        elseif typeof(direction) == "CFrame" then
            args[4] = direction.LookVector.X
            args[5] = direction.LookVector.Y
            args[6] = direction.LookVector.Z
        else
            args[4] = 0
            args[5] = 0
            args[6] = 0
        end
    else
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local lookVector = hrp.CFrame.LookVector
                args[4] = lookVector.X
                args[5] = lookVector.Y
                args[6] = lookVector.Z
            end
        end
    end
    return args
end

function A.R_Block()
    return { "CommF_", "Block" }
end

function A.R_Dodge()
    return { "CommF_", "Dodge" }
end

function A.R_AimLock(target)
    if not target then
        return nil, "Target is required"
    end
    local args = { "CommF_", "AimLock" }
    if typeof(target) == "Instance" then
        args[3] = target.Name
    elseif type(target) == "string" then
        args[3] = target
    end
    return args
end

function A.ExecuteAttack(tool, target, position)
    local callArgs = A.R_Attack(tool, target, position)
    return A.CommF(unpack(callArgs))
end

function A.ExecuteSkill(skillName, direction)
    local callArgs, err = A.R_Skill(skillName, direction)
    if not callArgs then return false, err end
    return A.CommF(unpack(callArgs))
end

function A.ExecuteBlock()
    return A.CommF(unpack(A.R_Block()))
end

function A.ExecuteDodge()
    return A.CommF(unpack(A.R_Dodge()))
end

-- Shop operations
function A.R_BuyItem(itemName, price)
    if not itemName then return nil, "Item name required" end
    local args = { "CommF_", "Buy" }
    args[3] = itemName
    if price then
        args[4] = price
    end
    return args
end

function A.R_SellItem(itemName, amount)
    if not itemName then return nil, "Item name required" end
    local args = { "CommF_", "Sell" }
    args[3] = itemName
    args[4] = amount or 1
    return args
end

function A.R_BuyFruit(name)
    if not name then return nil, "Fruit name required" end
    return { "CommF_", "BuyDevilFruit", name }
end

function A.R_RefundStats()
    return { "CommF_", "RefundStat", "2500" }
end

function A.R_RerollRace()
    return { "CommF_", "RerollRace", "3500" }
end

function A.ExecuteBuyItem(itemName, price)
    local callArgs, err = A.R_BuyItem(itemName, price)
    if not callArgs then return false, err end
    return A.CommF(unpack(callArgs))
end

function A.ExecuteSellItem(itemName, amount)
    local callArgs, err = A.R_SellItem(itemName, amount)
    if not callArgs then return false, err end
    return A.CommF(unpack(callArgs))
end

function A.ExecuteBuyFruit(name)
    local callArgs, err = A.R_BuyFruit(name)
    if not callArgs then return false, err end
    return A.CommF(unpack(callArgs))
end

function A.ExecuteRefundStats()
    return A.CommF(unpack(A.R_RefundStats()))
end

function A.ExecuteRerollRace()
    return A.CommF(unpack(A.R_RerollRace()))
end

-- Movement operations
function A.R_Soru()
    return { "CommF_", "Soru" }
end

function A.R_Geppo()
    return { "CommF_", "Geppo" }
end

function A.R_Fly()
    return { "CommF_", "Fly" }
end

function A.ExecuteSoru()
    return A.CommF(unpack(A.R_Soru()))
end

function A.ExecuteGeppo()
    return A.CommF(unpack(A.R_Geppo()))
end

function A.ExecuteFly()
    return A.CommF(unpack(A.R_Fly()))
end

-- Team operations
function A.R_SetTeam(name)
    if not name then return nil, "Team name required" end
    return { "CommF_", "SetTeam", name }
end

function A.R_GetTeams()
    return { "CommF_", "GetTeams" }
end

function A.ExecuteSetTeam(name)
    local callArgs, err = A.R_SetTeam(name)
    if not callArgs then return false, err end
    return A.CommF(unpack(callArgs))
end

function A.ExecuteGetTeams()
    return A.CommF(unpack(A.R_GetTeams()))
end

-- Inventory operations
function A.R_GetInventory()
    return { "CommF_", "getInventory" }
end

function A.R_EquipItem(name)
    if not name then return nil, "Item name required" end
    return { "CommF_", "EquipItem", name }
end

function A.R_StoreItem(name)
    if not name then return nil, "Item name required" end
    return { "CommF_", "StoreItem", name }
end

function A.ExecuteGetInventory()
    return A.CommF(unpack(A.R_GetInventory()))
end

function A.ExecuteEquipItem(name)
    local callArgs, err = A.R_EquipItem(name)
    if not callArgs then return false, err end
    return A.CommF(unpack(callArgs))
end

function A.ExecuteStoreItem(name)
    local callArgs, err = A.R_StoreItem(name)
    if not callArgs then return false, err end
    return A.CommF(unpack(callArgs))
end

-- Race/V4 operations
function A.R_ActivateRaceV4()
    return { "CommF_", "RaceV4" }
end

function A.R_RaceAwaken()
    return { "CommF_", "AwakenTalent" }
end

function A.R_TrialStart()
    return { "CommF_", "TrialStart" }
end

function A.ExecuteActivateRaceV4()
    return A.CommF(unpack(A.R_ActivateRaceV4()))
end

function A.ExecuteRaceAwaken()
    return A.CommF(unpack(A.R_RaceAwaken()))
end

function A.ExecuteTrialStart()
    return A.CommF(unpack(A.R_TrialStart()))
end

-- Title operations
function A.R_GetTitles()
    return { "CommF_", "GetTitles" }
end

function A.R_EquipTitle(name)
    if not name then return nil, "Title name required" end
    return { "CommF_", "EquipTitle", name }
end

function A.ExecuteGetTitles()
    return A.CommF(unpack(A.R_GetTitles()))
end

function A.ExecuteEquipTitle(name)
    local callArgs, err = A.R_EquipTitle(name)
    if not callArgs then return false, err end
    return A.CommF(unpack(callArgs))
end

-- ============================================================================
-- SECTION 8: REMOTE MONITORING
-- ============================================================================

function A.StartRemoteMonitor()
    if A.MonitorActive then
        return false, "Monitor already active"
    end

    A.MonitorActive = true

    A.RemoteMonitorThread = task.spawn(function()
        while A.MonitorActive do
            for _, desc in ipairs(RS:GetDescendants()) do
                if desc:IsA("RemoteEvent") then
                    if not A.RemoteCache[desc.Name] then
                        A.RemoteCache[desc.Name] = desc
                    end
                elseif desc:IsA("RemoteFunction") then
                    if not A.RemoteCache[desc.Name] then
                        A.RemoteCache[desc.Name] = desc
                    end
                end
            end

            task.wait(5)
        end
    end)

    return true, "Monitor started"
end

function A.StopRemoteMonitor()
    A.MonitorActive = false

    if A.RemoteMonitorThread then
        task.cancel(A.RemoteMonitorThread)
        A.RemoteMonitorThread = nil
    end

    return true, "Monitor stopped"
end

function A.GetRemoteStats()
    local totalCalls = A.RemoteCallCount
    local totalErrors = A.RemoteErrors
    local errorRate = 0
    if totalCalls > 0 then
        errorRate = (totalErrors / totalCalls) * 100
    end

    local totalAvgTime = 0
    local timingCount = 0
    for name, timing in pairs(A.RemoteCallTiming) do
        totalAvgTime = totalAvgTime + timing.AvgTime
        timingCount = timingCount + 1
    end

    local overallAvgTime = 0
    if timingCount > 0 then
        overallAvgTime = totalAvgTime / timingCount
    end

    return {
        TotalCalls = totalCalls,
        TotalErrors = totalErrors,
        ErrorRate = errorRate,
        AverageResponseTime = overallAvgTime,
        CachedRemotes = 0,
        HookedRemotes = 0,
        MonitorActive = A.MonitorActive,
        LogEntries = #A.RemoteLog,
        TimingDetails = A.RemoteCallTiming,
    }
end

function A.GetAvgRemoteTime(remoteName)
    if remoteName and A.RemoteCallTiming[remoteName] then
        return A.RemoteCallTiming[remoteName].AvgTime
    end

    local total = 0
    local count = 0
    for _, timing in pairs(A.RemoteCallTiming) do
        total = total + timing.AvgTime
        count = count + 1
    end

    if count > 0 then
        return total / count
    end

    return 0
end

function A.GetRemoteTiming(remoteName)
    if remoteName then
        return A.RemoteCallTiming[remoteName]
    end
    return A.RemoteCallTiming
end

-- ============================================================================
-- SECTION 9: REMOTE HOOKING
-- ============================================================================

function A.HookRemote(name, preHook, postHook)
    if not name or type(name) ~= "string" then
        return false, "Invalid remote name"
    end

    local remote = A.FindRemote(name)
    if not remote then
        return false, "Remote not found: " .. name
    end

    if A.HookedRemotes[name] then
        return false, "Remote already hooked: " .. name
    end

    if remote:IsA("RemoteFunction") then
        local originalNameCall = remote.NameCall
        local hookedNameCall

        if preHook or postHook then
            hookedNameCall = newcclosure(function(self, ...)
                local args = { ... }

                if preHook then
                    local preResult = preHook(name, args)
                    if preResult == false then
                        return nil
                    end
                    if type(preResult) == "table" then
                        args = preResult
                    end
                end

                local result = originalNameCall(self, unpack(args))

                if postHook then
                    local postResult = postHook(name, args, result)
                    if postResult ~= nil then
                        result = postResult
                    end
                end

                return result
            end)

            hookmetamethod(game, "__namecall", hookedNameCall)
        end

        A.HookedRemotes[name] = {
            Remote = remote,
            Original = originalNameCall,
            Hooked = hookedNameCall,
            PreHook = preHook,
            PostHook = postHook,
            CallCount = 0,
            HookedAt = tick(),
        }
    else
        A.HookedRemotes[name] = {
            Remote = remote,
            Original = nil,
            Hooked = nil,
            PreHook = preHook,
            PostHook = postHook,
            CallCount = 0,
            HookedAt = tick(),
        }

        local conn
        conn = remote.OnServerEvent:Connect(function(...)
            if A.HookedRemotes[name] then
                A.HookedRemotes[name].CallCount = A.HookedRemotes[name].CallCount + 1
            end
        end)

        A.HookedRemotes[name].Connection = conn
    end

    return true, "Hooked: " .. name
end

function A.UnhookRemote(name)
    if not name or type(name) ~= "string" then
        return false, "Invalid remote name"
    end

    if not A.HookedRemotes[name] then
        return false, "Remote not hooked: " .. name
    end

    local hookData = A.HookedRemotes[name]

    if hookData.Connection then
        hookData.Connection:Disconnect()
    end

    A.HookedRemotes[name] = nil
    return true, "Unhooked: " .. name
end

function A.GetHookedRemotes()
    local hooked = {}
    for name, data in pairs(A.HookedRemotes) do
        hooked[#hooked + 1] = {
            Name = name,
            CallCount = data.CallCount,
            HookedAt = data.HookedAt,
            Duration = tick() - data.HookedAt,
        }
    end
    return hooked
end

function A.UnhookAllRemotes()
    for name, _ in pairs(A.HookedRemotes) do
        A.UnhookRemote(name)
    end
    return true, "All remotes unhooked"
end

-- ============================================================================
-- SECTION 10: ANTI-KICK AND ANTI-TELEPORT PROTECTION
-- ============================================================================

function A.AntiKick()
    local player = LocalPlayer

    local oldKick
    if hookmetamethod then
        oldKick = hookmetamethod(game, "__index", function(self, index)
            if self == player and (index == "Kick" or index == "kick") then
                return function(self, msg)
                    warn("[Apex Hub] Kick blocked! Message: " .. tostring(msg))
                    return nil
                end
            end
            return oldKick(self, index)
        end)
    end

    if oldKick then
        local success, err = pcall(function()
            hookmetamethod(game, "__index", oldKick)
        end)
    end

    if hookfunction then
        local success, err = pcall(function()
            local oldKickFunc = player.Kick
            hookfunction(player.Kick, function(self, msg)
                warn("[Apex Hub] Kick intercepted! Message: " .. tostring(msg))
                return nil
            end)
        end)
    end

    A._antiKickEnabled = true
    return true
end

function A.AntiTeleport()
    local player = LocalPlayer

    A._lastTeleportPosition = nil
    A._teleportMonitoring = true

    A._antiTeleportThread = task.spawn(function()
        local humanoidRootPart = nil

        local function setupCharacter(char)
            humanoidRootPart = char:WaitForChild("HumanoidRootPart", 10)
            if humanoidRootPart then
                A._lastTeleportPosition = humanoidRootPart.Position
            end
        end

        if player.Character then
            setupCharacter(player.Character)
        end
        player.CharacterAdded:Connect(setupCharacter)

        while A._teleportMonitoring do
            if humanoidRootPart and humanoidRootPart.Parent then
                local currentPos = humanoidRootPart.Position
                if A._lastTeleportPosition then
                    local distance = (currentPos - A._lastTeleportPosition).Magnitude
                    if distance > 200 then
                        warn("[Apex Hub] Large teleport detected: " .. math.floor(distance) .. " studs")
                    end
                end
                A._lastTeleportPosition = currentPos
            end
            task.wait(0.5)
        end
    end)

    return true
end

function A.StopAntiTeleport()
    A._teleportMonitoring = false
    if A._antiTeleportThread then
        task.cancel(A._antiTeleportThread)
        A._antiTeleportThread = nil
    end
    return true
end

function A.AntiVoid()
    A._antiVoidEnabled = true
    A._antiVoidThread = task.spawn(function()
        while A._antiVoidEnabled do
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChild("Humanoid")
                if hrp and humanoid then
                    if hrp.Position.Y < -200 then
                        warn("[Apex Hub] Void detected! Teleporting up...")
                        hrp.CFrame = CFrame.new(0, 50, 0)
                    end
                end
            end
            task.wait(0.25)
        end
    end)
    return true
end

function A.StopAntiVoid()
    A._antiVoidEnabled = false
    if A._antiVoidThread then
        task.cancel(A._antiVoidThread)
        A._antiVoidThread = nil
    end
    return true
end

-- ============================================================================
-- SECTION 11: REMOTE PERFORMANCE UTILITIES
-- ============================================================================

function A.PingRemote(name)
    local remote = A.FindRemote(name)
    if not remote then
        return nil, "Remote not found"
    end

    if remote.ClassName ~= "RemoteFunction" then
        return nil, "Cannot ping RemoteEvent"
    end

    local startTime = tick()
    local success, result = pcall(function()
        return remote:InvokeServer("ping")
    end)
    local duration = tick() - startTime

    return {
        Success = success,
        Duration = duration,
        Result = result,
        Remote = name,
    }
end

function A.BatchInvoke(remoteName, argSets)
    if not remoteName or type(argSets) ~= "table" then
        return {}
    end

    local remote = A.FindRemote(remoteName)
    if not remote then
        return {}
    end

    local results = {}
    for i, args in ipairs(argSets) do
        local startTime = tick()
        local success, result = pcall(function()
            return remote:InvokeServer(unpack(args))
        end)
        local duration = tick() - startTime

        results[i] = {
            Success = success,
            Result = result,
            Duration = duration,
        }

        RunService.Heartbeat:Wait()
    end

    return results
end

function A.GetCachedRemotes()
    local cached = {}
    for name, remote in pairs(A.RemoteCache) do
        cached[#cached + 1] = {
            Name = name,
            Exists = remote and remote.Parent ~= nil,
            ClassName = remote and remote.ClassName or "Unknown",
        }
    end
    return cached
end

function A.PurgeCache()
    local removed = 0
    for name, remote in pairs(A.RemoteCache) do
        if not remote or not remote.Parent then
            A.RemoteCache[name] = nil
            A.Remotes[name] = nil
            removed = removed + 1
        end
    end
    return removed
end

function A.GetRemoteDump()
    local dump = {}
    local function scan(parent, path, depth)
        depth = depth or 0
        if depth > 15 then return end

        for _, child in ipairs(parent:GetChildren()) do
            local currentPath = path .. "." .. child.Name
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                dump[#dump + 1] = {
                    Name = child.Name,
                    ClassName = child.ClassName,
                    Path = currentPath,
                    IsCached = A.RemoteCache[child.Name] ~= nil,
                    IsHooked = A.HookedRemotes[child.Name] ~= nil,
                }
            end
            if child:IsA("Folder") or child:IsA("Model") then
                scan(child, currentPath, depth + 1)
            end
        end
    end

    scan(RS, "RS", 0)
    return dump
end

-- ============================================================================
-- SECTION 12: CONVENIENCE WRAPPERS
-- ============================================================================

function A.SafeFire(name, ...)
    local remote = A.FindRemote(name)
    if not remote then
        return false
    end
    return A.FireServer(remote, ...)
end

function A.SafeInvoke(name, ...)
    local remote = A.FindRemote(name)
    if not remote then
        return nil
    end
    return A.InvokeServer(remote, ...)
end

function A.SafeCommF(...)
    return A.CommF(...)
end

function A.SafeCommE(...)
    return A.CommE(...)
end

-- ============================================================================
-- SECTION 13: INITIALIZATION
-- ============================================================================

function A.InitRemoteSystem()
    if A.RemoteSystem.Initialized then
        return true
    end

    A.RefreshRemotes()
    A.AntiKick()
    A.StartRemoteMonitor()

    A.RemoteSystem.Initialized = true
    A.RemoteSystem.InitTime = tick()

    return true
end

function A.ShutdownRemoteSystem()
    A.StopRemoteMonitor()
    A.UnhookAllRemotes()
    A.StopAntiTeleport()
    A.StopAntiVoid()

    A.RemoteSystem.Initialized = false
    A.Remotes = {}
    A.RemoteCache = {}
    A.HookedRemotes = {}
    A.RemoteLog = {}
    A.RemoteCallTiming = {}
    A.RemoteCallCount = 0
    A.RemoteErrors = 0

    return true
end

A.InitRemoteSystem()

return A