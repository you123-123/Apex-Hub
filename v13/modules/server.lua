local A = _G.Apex
local Server = {}
Server.Active = false
Server.HopCount = 0
Server.ServerList = {}
Server.BestServers = {}
Server._loop = nil
Server._startTick = 0
Server._lastHopTime = 0
Server._hopCooldown = 10
Server._autoHopEnabled = false
Server._autoHopInterval = 300
Server._targetPlayerCount = nil
Server._targetBoss = nil
Server._targetFruit = nil
Server._targetSeaBeast = nil
Server._maxPlayers = 0
Server._minPlayers = 0
Server._currentServerId = game.JobId
Server._currentPlayerCount = 0
Server._currentPing = 0
Server._safetyCheck = true
Server._blacklistedServers = {}
Server._regionFilter = nil
Server._attemptCount = 0
Server._maxAttempts = 10
Server._hopHistory = {}
Server._rejoinEnabled = true
Server._lastRejoinTime = 0
Server._rejoinCooldown = 60

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Apex Server] Error: " .. tostring(err))
    end
    return ok, err
end

function Server.GetServerList()
    local servers = {}
    local ok, res = SafeCall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)
    if ok and res and res.data then
        for _, srv in ipairs(res.data) do
            if srv.id ~= game.JobId then
                table.insert(servers, {
                    Id = srv.id,
                    Playing = srv.playing or 0,
                    MaxPlayers = srv.maxPlayers or 0,
                    Ping = srv.ping or 0,
                    Name = srv.name or "Unknown"
                })
            end
        end
    end
    Server.ServerList = servers
    return servers
end

function Server.GetPlayerCount()
    return #Players:GetPlayers()
end

function Server.GetServerPing()
    local ok, ping = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok and ping then
        Server._currentPing = math.floor(ping)
        return Server._currentPing
    end
    return 0
end

function Server.GetServerInfo()
    local ping = Server.GetServerPing()
    local playerCount = Server.GetPlayerCount()
    Server._currentPlayerCount = playerCount
    return {
        ServerId = game.JobId,
        PlayerCount = playerCount,
        MaxPlayers = Players.MaxPlayers,
        Ping = ping,
        JobId = game.JobId,
        PlaceId = game.PlaceId,
        LocalPlayer = Players.LocalPlayer and Players.LocalPlayer.Name or "Unknown",
        GameTime = math.floor(workspace.DistributedGameTime)
    }
end

function Server.CheckServerSafety(serverData)
    if not Server._safetyCheck then return true end
    if not serverData then return false end
    for _, blacklisted in ipairs(Server._blacklistedServers) do
        if serverData.Id == blacklisted then
            return false
        end
    end
    if serverData.Playing >= serverData.MaxPlayers * 0.9 then
        return false
    end
    return true
end

function Server.GetBestServer(criteria)
    criteria = criteria or "balanced"
    local servers = Server.GetServerList()
    if #servers == 0 then return nil end
    local filtered = {}
    for _, srv in ipairs(servers) do
        if Server.CheckServerSafety(srv) then
            table.insert(filtered, srv)
        end
    end
    if #filtered == 0 then return nil end
    if criteria == "low" then
        table.sort(filtered, function(a, b) return a.Playing < b.Playing end)
    elseif criteria == "high" then
        table.sort(filtered, function(a, b) return a.Playing > b.Playing end)
    elseif criteria == "boss" then
        table.sort(filtered, function(a, b) return a.Playing > b.Playing end)
    elseif criteria == "fruit" then
        table.sort(filtered, function(a, b) return a.Playing > b.Playing end)
    elseif criteria == "ping" then
        table.sort(filtered, function(a, b) return (a.Ping or 0) < (b.Ping or 0) end)
    else
        table.sort(filtered, function(a, b)
            local scoreA = a.Playing * 0.7 + (a.MaxPlayers - a.Playing) * 0.3
            local scoreB = b.Playing * 0.7 + (b.MaxPlayers - b.Playing) * 0.3
            return scoreA > scoreB
        end)
    end
    Server.BestServers = filtered
    return filtered[1]
end

function Server.GetRegionServers(region)
    region = region or "any"
    local servers = Server.GetServerList()
    if region == "any" then return servers end
    local filtered = {}
    for _, srv in ipairs(servers) do
        if srv.Name and string.find(string.lower(srv.Name), string.lower(region)) then
            table.insert(filtered, srv)
        end
    end
    if #filtered == 0 then
        return servers
    end
    return filtered
end

function Server.ServerHop(criteria)
    if tick() - Server._lastHopTime < Server._hopCooldown then
        A.Notify("Server Hop", "Cooldown active, please wait", 3)
        return false
    end
    if Server._attemptCount >= Server._maxAttempts then
        A.Notify("Server Hop", "Max attempts reached", 3)
        return false
    end
    local server = Server.GetBestServer(criteria or "balanced")
    if not server then
        A.Notify("Server Hop", "No suitable servers found", 3)
        return false
    end
    Server._attemptCount = Server._attemptCount + 1
    Server._lastHopTime = tick()
    Server.HopCount = Server.HopCount + 1
    table.insert(Server._hopHistory, {
        FromServer = game.JobId,
        ToServer = server.Id,
        Time = tick(),
        Players = server.Playing
    })
    A.Notify("Server Hop", "Hopping to server (" .. tostring(server.Playing) .. " players)", 3)
    local ok, err = SafeCall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.Id, Players.LocalPlayer)
    end)
    if not ok then
        A.Notify("Server Hop", "Failed to hop: " .. tostring(err), 5)
        Server._blacklistedServers[#Server._blacklistedServers + 1] = server.Id
        return false
    end
    return true
end

function Server.HopToLow()
    return Server.ServerHop("low")
end

function Server.HopToHigh()
    return Server.ServerHop("high")
end

function Server.HopToBoss(bossName)
    Server._targetBoss = bossName
    local maxAttempts = 15
    for i = 1, maxAttempts do
        if not Server.Active then break end
        A.Notify("Boss Hop", "Attempt " .. tostring(i) .. "/" .. tostring(maxAttempts), 2)
        local ok, err = SafeCall(function()
            local hopResult = Server.ServerHop("boss")
            if hopResult then
                task.wait(5)
                local boss = Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("Hostile")
                if boss then
                    for _, mob in ipairs(boss:GetDescendants()) do
                        if mob:IsA("Model") and string.find(string.lower(mob.Name), string.lower(bossName)) then
                            local hum = mob:FindFirstChild("Humanoid")
                            if hum and hum.Health > 0 then
                                A.Notify("Boss Hop", "Found " .. bossName .. "!", 3)
                                return true
                            end
                        end
                    end
                end
            end
        end)
        if ok then return true end
        task.wait(2)
    end
    return false
end

function Server.HopToSeaBeast()
    local maxAttempts = 10
    for i = 1, maxAttempts do
        if not Server.Active then break end
        A.Notify("Sea Beast Hop", "Attempt " .. tostring(i), 2)
        local ok, err = SafeCall(function()
            local hopResult = Server.ServerHop("high")
            if hopResult then
                task.wait(5)
                local enemies = Workspace:FindFirstChild("Enemies") or Workspace
                for _, child in ipairs(enemies:GetDescendants()) do
                    if child:IsA("Model") and string.find(string.lower(child.Name), "beast") then
                        A.Notify("Sea Beast Hop", "Found sea beast!", 3)
                        return true
                    end
                end
            end
        end)
        if ok then return true end
        task.wait(2)
    end
    return false
end

function Server.HopToFruit()
    local maxAttempts = 10
    for i = 1, maxAttempts do
        if not Server.Active then break end
        A.Notify("Fruit Hop", "Attempt " .. tostring(i), 2)
        local ok, err = SafeCall(function()
            local hopResult = Server.ServerHop("high")
            if hopResult then
                task.wait(5)
                local fruits = Workspace:FindFirstChild("Fruits") or Workspace:FindFirstChild("Blox Fruits")
                if fruits then
                    for _, child in ipairs(fruits:GetChildren()) do
                        if child:IsA("BasePart") or child:IsA("Model") then
                            A.Notify("Fruit Hop", "Found fruit: " .. child.Name, 3)
                            return true
                        end
                    end
                end
            end
        end)
        if ok then return true end
        task.wait(2)
    end
    return false
end

function Server.ServerHopDelay(delay)
    delay = delay or 5
    A.Notify("Server Hop", "Hopping in " .. tostring(delay) .. " seconds...", delay)
    task.wait(delay)
    return Server.ServerHop()
end

function Server.AutoHop()
    Server._autoHopEnabled = true
    A.Notify("Server Hop", "Auto hop enabled (interval: " .. tostring(Server._autoHopInterval) .. "s)", 3)
    task.spawn(function()
        while Server._autoHopEnabled and Server.Active do
            task.wait(Server._autoHopInterval)
            if Server._autoHopEnabled and Server.Active then
                Server.ServerHop()
            end
        end
    end)
end

function Server.Rejoin()
    if tick() - Server._lastRejoinTime < Server._rejoinCooldown then
        A.Notify("Rejoin", "Cooldown active", 3)
        return false
    end
    if not Server._rejoinEnabled then return false end
    Server._lastRejoinTime = tick()
    A.Notify("Rejoin", "Rejoining server...", 3)
    local ok, err = SafeCall(function()
        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
    end)
    if not ok then
        A.Notify("Rejoin", "Failed: " .. tostring(err), 5)
    end
    return ok
end

function Server.GetServerStats()
    local sessionTime = tick() - Server._startTick
    local minutes = math.floor(sessionTime / 60)
    local seconds = math.floor(sessionTime % 60)
    return {
        HopCount = Server.HopCount,
        ServerListSize = #Server.ServerList,
        BestServer = Server.BestServers[1] and Server.BestServers[1].Playing or 0,
        CurrentPlayers = Server._currentPlayerCount,
        CurrentPing = Server._currentPing,
        SessionTime = string.format("%dm %ds", minutes, seconds),
        AutoHop = Server._autoHopEnabled,
        AutoHopInterval = Server._autoHopInterval,
        AttemptCount = Server._attemptCount,
        BlacklistedServers = #Server._blacklistedServers,
        LastHopTime = Server._lastHopTime > 0 and tostring(math.floor(tick() - Server._lastHopTime)) .. "s ago" or "Never",
        HopHistory = #Server._hopHistory,
        SafetyCheck = Server._safetyCheck
    }
end

function Server.MainLoop()
    while Server.Active do
        if not A.Alive() then
            task.wait(2)
            break
        end
        Server.GetServerPing()
        Server._currentPlayerCount = Server.GetPlayerCount()
        task.wait(5)
    end
end

function Server.Start(autoHop)
    if Server.Active then return end
    Server.Active = true
    Server._startTick = tick()
    Server._currentServerId = game.JobId
    Server._attemptCount = 0
    Server._hopHistory = {}
    Server._blacklistedServers = {}
    A.Notify("Server", "Server management started", 3)
    Server._loop = task.spawn(function()
        Server.MainLoop()
        Server.Active = false
    end)
    if autoHop then
        Server.AutoHop()
    end
end

function Server.Stop()
    Server.Active = false
    Server._autoHopEnabled = false
    if Server._loop then
        task.cancel(Server._loop)
        Server._loop = nil
    end
    A.Notify("Server", "Stopped", 2)
end

A.Server = Server
A.Register("server", A.Server)
