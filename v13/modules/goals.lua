local A = _G.Apex
local Goals = {}
Goals.Active = false
Goals.Goals = {}
Goals._loop = nil
Goals._lastPoll = tick()

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then return false, err end
    return true, ...
end

function Goals.SetGoal(category, target)
    category = category or "Level"
    target = tonumber(target) or 0
    Goals.Goals[category] = {
        Target = target,
        StartValue = Goals.GetValue(category),
        StartTime = tick(),
        Notified = false
    }
    A.Notify("Goals", "Goal set: " .. category .. " -> " .. tostring(target), 2)
end

function Goals.GetValue(category)
    local lp = A.LP
    if not lp then return 0 end
    if category == "Level" then
        local level = lp:FindFirstChild("Data") and lp.Data:FindFirstChild("Level") or nil
        return level and (tonumber(level.Value) or 0) or 0
    elseif category == "Beli" then
        local data = lp:FindFirstChild("DataLeaderboard") or lp:FindFirstChild("Data")
        if data then
            local beli = data:FindFirstChild("Beli") or data:FindFirstChild("Points")
            return beli and (tonumber(tostring(beli.Value)) or 0) or 0
        end
        return 0
    elseif category == "Fragments" then
        local data = lp:FindFirstChild("Data")
        if data then
            local frags = data:FindFirstChild("Fragments")
            return frags and (tonumber(tostring(frags.Value)) or 0) or 0
        end
        return 0
    elseif category == "Kills" then
        return A.Combat and A.Combat.Kills or 0
    end
    return 0
end

function Goals.GetProgress(category)
    local goal = Goals.Goals[category]
    if not goal then return 0, 0 end
    local current = Goals.GetValue(category)
    local startVal = goal.StartValue
    local diff = goal.Target - startVal
    if diff <= 0 then return 100, current end
    local progress = math.clamp((current - startVal) / diff, 0, 1)
    return progress * 100, current
end

function Goals.GetETA(category)
    local goal = Goals.Goals[category]
    if not goal then return nil end
    local elapsed = tick() - goal.StartTime
    local current = Goals.GetValue(category)
    local gained = current - goal.StartValue
    if gained <= 0 then return nil end
    local remaining = goal.Target - current
    if remaining <= 0 then return 0 end
    local rate = gained / math.max(elapsed / 60, 0.001)
    local minutes = remaining / rate
    if not (minutes > 0) then return nil end
    local secs = math.floor(minutes * 60)
    return string.format("%02dh %02dm %02ds", math.floor(secs / 3600), math.floor((secs % 3600) / 60), secs % 60)
end

function Goals.PollGoals()
    local lp = A.LP
    if not lp then return end
    local levelsCrossed = 0
    for category, goal in pairs(Goals.Goals) do
        local progress, current = Goals.GetProgress(category)
        if progress >= 100 and not goal.Notified then
            goal.Notified = true
            A.Notify("🎯 GOAL COMPLETE!", category .. " goal reached: " .. tostring(goal.Target), 5)
        elseif progress >= 50 and not goal._halfNotified then
            goal._halfNotified = true
        end
    end
    local currentLevel = Goals.GetValue("Level")
    if currentLevel ~= Goals.LastLevel and Goals.LastLevel then
        levelsCrossed = currentLevel - Goals.LastLevel
        if levelsCrossed > 0 then
            A.Notify("🎉 Level Up!", "Reached level " .. tostring(currentLevel), 3)
        end
    end
    Goals.LastLevel = currentLevel
end

function Goals.MainLoop()
    while Goals.Active do
        SafeCall(function()
            Goals.PollGoals()
        end)
        task.wait(3)
    end
end

function Goals.Start()
    if Goals.Active then return end
    Goals.Active = true
    Goals._loop = task.spawn(function()
        Goals.MainLoop()
        Goals.Active = false
    end)
    A.Notify("Goals", "Goal system started", 2)
end

function Goals.Stop()
    Goals.Active = false
    if Goals._loop then
        task.cancel(Goals._loop)
        Goals._loop = nil
    end
end

function Goals.ClearGoal(category)
    if category then
        Goals.Goals[category] = nil
    else
        Goals.Goals = {}
    end
end

function Goals.GetAllGoals()
    local result = {}
    for category, goal in pairs(Goals.Goals) do
        local progress, current = Goals.GetProgress(category)
        result[#result + 1] = {
            Category = category,
            Target = goal.Target,
            Current = current,
            Progress = math.floor(progress * 10) / 10,
            ETA = Goals.GetETA(category)
        }
    end
    table.sort(result, function(a, b) return (a.Progress or 0) > (b.Progress or 0) end)
    return result
end

A.Goals = Goals
A.Register("goals", A.Goals)
