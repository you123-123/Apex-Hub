local A = _G.Apex
local Rec = {}
Rec.Active = false
Rec.AutoRejoin = true
Rec.RejoinOnError = true
Rec.RejoinOnKick = false
Rec._loop = nil
Rec._failedCount = 0
Rec._lastError = nil

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then return false, err end
    return true, ...
end

function Rec.HandleError(err)
    Rec._failedCount = Rec._failedCount + 1
    Rec._lastError = err
    if Rec.RejoinOnError and Rec._failedCount >= 3 then
        A.Notify("⚠ Recovery", "Rejoining after errors (" .. tostring(Rec._failedCount) .. ")", 3)
        Rec._failedCount = 0
        Rec.Rejoin()
    end
end

function Rec.Rejoin()
    A.Notify("Server", "Rejoining...", 2)
    SafeCall(function()
        if A.Server and A.Server.Rejoin then
            A.Server.Rejoin()
            return
        end
        local ts = game:GetService("TeleportService")
        local placeId = game.PlaceId
        local jobId = game.JobId
        if ts and jobId then
            ts:TeleportToPlaceInstance(placeId, jobId, A.LP)
        end
    end)
end

function Rec.Hop()
    A.Notify("Server", "Hopping...", 2)
    SafeCall(function()
        if A.Server and A.Server.ServerHop then
            A.Server.ServerHop()
        end
    end)
end

function Rec.MainLoop()
    while Rec.Active do
        local lp = A.LP
        if not lp then
            task.wait(5)
            -- can't rejoin without LP
        else
            -- Monitor status every few seconds
            local alive = A.Alive()
            if not alive then
                -- Character died, wait for respawn
            end
        end
        task.wait(10)
    end
end

function Rec.Start()
    if Rec.Active then return end
    Rec.Active = true
    Rec._loop = task.spawn(function()
        Rec.MainLoop()
        Rec.Active = false
    end)
end

function Rec.Stop()
    Rec.Active = false
    if Rec._loop then
        task.cancel(Rec._loop)
        Rec._loop = nil
    end
end

A.AutoRecovery = Rec
A.Register("auto_recovery", A.AutoRecovery)
