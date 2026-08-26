--!strict
--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║         APEX HUB v13.0 APEX ULTIMATE - SERVICES MODULE         ║
    ║              Comprehensive Service Wrappers & Managers          ║
    ║                         Core Module                            ║
    ╚══════════════════════════════════════════════════════════════════╝
    
    Wraps all Roblox services with cached access, safe utilities,
    event management, teleport system, performance monitoring, and more.
    
    DO NOT use the `continue` keyword anywhere in this file.
--]]

local A = (getgenv and getgenv()) or _G or {}
A.__services_loaded = false

-----------------------------------------------------------------------
-- SECTION 1: CORE SERVICE REFERENCES
-----------------------------------------------------------------------

A.Players = game:GetService("Players")
A.ReplicatedStorage = game:GetService("ReplicatedStorage")
A.ServerStorage = game:GetService("ServerStorage")
A.Workspace = game:GetService("Workspace")
A.Lighting = game:GetService("Lighting")
A.UserInputService = game:GetService("UserInputService")
A.RunService = game:GetService("RunService")
A.TweenService = game:GetService("TweenService")
A.HttpService = game:GetService("HttpService")
A.VirtualInputManager = game:GetService("VirtualInputManager")
A.VirtualUser = game:GetService("VirtualUser")
A.ContextActionService = game:GetService("ContextActionService")
A.StarterGui = game:GetService("StarterGui")
A.PathfindingService = game:GetService("PathfindingService")
A.ProximityPromptService = game:GetService("ProximityPromptService")

A.LocalPlayer = A.Players.LocalPlayer

-----------------------------------------------------------------------
-- SECTION 2: LAZY-LOADED SERVICE CACHE
-----------------------------------------------------------------------

A._serviceCache = {}
A._serviceLoadAttempts = {}

function A.GetService(serviceName)
    if A._serviceCache[serviceName] then
        return A._serviceCache[serviceName]
    end
    local ok, svc = pcall(function()
        return game:GetService(serviceName)
    end)
    if ok and svc then
        A._serviceCache[serviceName] = svc
        return svc
    end
    local attempts = A._serviceLoadAttempts[serviceName] or 0
    A._serviceLoadAttempts[serviceName] = attempts + 1
    warn("[Apex] Failed to load service: " .. serviceName .. " (attempt " .. tostring(A._serviceLoadAttempts[serviceName]) .. ")")
    return nil
end

-----------------------------------------------------------------------
-- SECTION 3: SAFE INSTANCE UTILITIES
-----------------------------------------------------------------------

function A.SafeWait(parent, childName, timeout)
    if not parent then return nil end
    timeout = timeout or 15
    local child = parent:FindFirstChild(childName)
    if child then return child end
    local start = tick()
    local conn
    child = parent:FindFirstChild(childName)
    if child then return child end
    while not child and (tick() - start) < timeout do
        child = parent:FindFirstChild(childName)
        if child then
            break
        end
        task.wait(0.1)
    end
    return child
end

function A.SafeFind(parent, childName, className)
    if not parent then return nil end
    local child = parent:FindFirstChild(childName)
    if not child then return nil end
    if className and child:IsA(className) then
        return child
    elseif not className then
        return child
    end
    return nil
end

function A.SafeGet(parent, childName, className, maxDepth)
    if not parent then return nil end
    maxDepth = maxDepth or 10
    local depth = 0
    local stack = {parent}
    while #stack > 0 and depth < maxDepth do
        local current = table.remove(stack, 1)
        depth = depth + 1
        local children = current:GetChildren()
        for _, child in ipairs(children) do
            if child.Name == childName then
                if not className or child:IsA(className) then
                    return child
                end
            end
            if #child:GetChildren() > 0 then
                table.insert(stack, child)
            end
        end
    end
    return nil
end

function A.SafeDestroy(instance, delayTime)
    if not instance then return false end
    if typeof(instance) ~= "Instance" then return false end
    if not instance.Parent then return false end
    if delayTime and delayTime > 0 then
        task.delay(delayTime, function()
            if instance and instance.Parent then
                local ok, err = pcall(function()
                    instance:Destroy()
                end)
                if not ok then
                    warn("[Apex] SafeDestroy failed: " .. tostring(err))
                end
            end
        end)
    else
        local ok, err = pcall(function()
            instance:Destroy()
        end)
        if not ok then
            warn("[Apex] SafeDestroy failed: " .. tostring(err))
            return false
        end
    end
    return true
end

function A.SafeClone(original)
    if not original then return nil end
    if typeof(original) ~= "Instance" then return nil end
    local ok, clone = pcall(function()
        return original:Clone()
    end)
    if ok and clone then
        return clone
    end
    warn("[Apex] SafeClone failed for: " .. tostring(original))
    return nil
end

function A.SafeSetProperty(instance, property, value)
    if not instance then return false end
    local ok, err = pcall(function()
        instance[property] = value
    end)
    return ok
end

function A.SafeGetAttribute(instance, attributeName, default)
    if not instance then return default end
    local ok, val = pcall(function()
        return instance:GetAttribute(attributeName)
    end)
    if ok and val ~= nil then
        return val
    end
    return default
end

function A.SafeSetAttribute(instance, attributeName, value)
    if not instance then return false end
    local ok, err = pcall(function()
        instance:SetAttribute(attributeName, value)
    end)
    return ok
end

-----------------------------------------------------------------------
-- SECTION 4: WORKSPACE WRAPPER (A.WS)
-----------------------------------------------------------------------

A.WS = A.Workspace
A.WS._cache = {}
A.WS._playerCharacters = {}
A.WS._lastCleanup = tick()

function A.WS.GetCached(name, parent, timeout)
    parent = parent or A.WS
    timeout = timeout or 15
    local cacheKey = parent:GetFullName() .. "." .. name
    if A.WS._cache[cacheKey] and A.WS._cache[cacheKey].Parent then
        return A.WS._cache[cacheKey]
    end
    local found = A.SafeWait(parent, name, timeout)
    if found then
        A.WS._cache[cacheKey] = found
    end
    return found
end

function A.WS.InvalidateCache(name)
    if name then
        local cacheKey = A.WS:GetFullName() .. "." .. name
        A.WS._cache[cacheKey] = nil
    else
        A.WS._cache = {}
    end
end

function A.WS.CacheChildren(parent, recursive)
    parent = parent or A.WS
    recursive = recursive or false
    local cached = {}
    local children = parent:GetChildren()
    for i = 1, #children do
        local child = children[i]
        local cacheKey = child:GetFullName()
        A.WS._cache[cacheKey] = child
        table.insert(cached, child)
        if recursive and child:IsA("Folder") then
            local subCached = A.WS.CacheChildren(child, true)
            for j = 1, #subCached do
                table.insert(cached, subCached[j])
            end
        end
    end
    return cached
end

A.Characters = A.WS.GetCached("Characters", A.WS, 30) or A.WS:FindFirstChild("Characters")
A.Map = A.WS.GetCached("Map", A.WS, 30) or A.WS:FindFirstChild("Map")
A.NPCs = A.WS.GetCached("NPCs", A.WS, 5) or A.WS:FindFirstChild("NPCs")
A.PlayerLeaves = A.WS.GetCached("PlayerCharacters", A.WS, 5) or A.WS:FindFirstChild("PlayerCharacters")

function A.WS.GetCharactersFolder()
    if not A.Characters or not A.Characters.Parent then
        A.Characters = A.WS.GetCached("Characters", A.WS, 30)
    end
    return A.Characters
end

function A.WS.GetMapFolder()
    if not A.Map or not A.Map.Parent then
        A.Map = A.WS.GetCached("Map", A.WS, 30)
    end
    return A.Map
end

function A.WS.GetNPCFolder()
    if not A.NPCs or not A.NPCs.Parent then
        A.NPCs = A.WS.GetCached("NPCs", A.WS, 5)
    end
    return A.NPCs
end

function A.WS.GetAllNPCs()
    local folder = A.WS.GetNPCFolder()
    if not folder then return {} end
    return folder:GetChildren()
end

function A.WS.GetNPCByName(npcName)
    local folder = A.WS.GetNPCFolder()
    if not folder then return nil end
    return A.SafeFind(folder, npcName) or A.SafeGet(folder, npcName, nil, 5)
end

function A.WS.GetNPCByDisplayName(displayName)
    local folder = A.WS.GetNPCFolder()
    if not folder then return nil end
    local npcs = folder:GetChildren()
    for i = 1, #npcs do
        local npc = npcs[i]
        if npc.Name == displayName then
            return npc
        end
        local humanoid = npc:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.DisplayName == displayName then
            return npc
        end
    end
    return nil
end

function A.WS.GetNPCsByDistance(maxDistance, origin)
    origin = origin or (A.LocalPlayer.Character and A.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and A.LocalPlayer.Character.HumanoidRootPart.Position) or Vector3.new(0, 0, 0)
    local folder = A.WS.GetNPCFolder()
    if not folder then return {} end
    local npcs = folder:GetChildren()
    local result = {}
    for i = 1, #npcs do
        local npc = npcs[i]
        local hrp = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Torso") or npc:FindFirstChild("UpperTorso")
        if hrp then
            local dist = (hrp.Position - origin).Magnitude
            if dist <= maxDistance then
                table.insert(result, {npc = npc, distance = dist})
            end
        end
    end
    table.sort(result, function(a, b) return a.distance < b.distance end)
    local output = {}
    for i = 1, #result do
        table.insert(output, result[i].npc)
    end
    return output
end

function A.WS.CleanupCharacters()
    local folder = A.WS.GetCharactersFolder()
    if not folder then return 0 end
    local removed = 0
    local children = folder:GetChildren()
    for i = #children, 1, -1 do
        local child = children[i]
        local humanoid = child:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health <= 0 then
            A.SafeDestroy(child)
            removed = removed + 1
        elseif not child:FindFirstChildOfClass("Humanoid") and not child:FindFirstChild("HumanoidRootPart") then
            A.SafeDestroy(child)
            removed = removed + 1
        end
    end
    return removed
end

-----------------------------------------------------------------------
-- SECTION 5: REPLICATED STORAGE WRAPPER (A.RS)
-----------------------------------------------------------------------

A.RS = A.ReplicatedStorage
A.RS._remoteCache = {}
A.RS._assetCache = {}

A.Remotes = A.RS:FindFirstChild("Remotes") or A.WS.GetCached("Remotes", A.RS, 10)
A.CommF = nil
A.CommE = nil
A.Assets = nil

function A.RS.Init()
    A.Remotes = A.RS:FindFirstChild("Remotes") or A.SafeWait(A.RS, "Remotes", 10)
    if A.Remotes then
        A.CommF = A.Remotes:FindFirstChild("CommF") or A.SafeWait(A.Remotes, "CommF_") or A.SafeWait(A.Remotes, "CommF", 5)
        A.CommE = A.Remotes:FindFirstChild("CommE") or A.SafeWait(A.Remotes, "CommE_") or A.SafeWait(A.Remotes, "CommE", 5)
    end
    A.Assets = A.RS:FindFirstChild("Assets") or A.SafeWait(A.RS, "Assets", 5)
end

function A.RS.GetRemote(name)
    if A.RS._remoteCache[name] and A.RS._remoteCache[name].Parent then
        return A.RS._remoteCache[name]
    end
    if not A.Remotes then
        A.RS.Init()
    end
    local remote = nil
    if A.Remotes then
        remote = A.Remotes:FindFirstChild(name)
    end
    if not remote then
        remote = A.SafeWait(A.Remotes or A.RS, name, 5)
    end
    if remote then
        A.RS._remoteCache[name] = remote
    end
    return remote
end

function A.RS.GetCommF()
    if A.CommF and A.CommF.Parent then
        return A.CommF
    end
    A.RS.Init()
    return A.CommF
end

function A.RS.GetCommE()
    if A.CommE and A.CommE.Parent then
        return A.CommE
    end
    A.RS.Init()
    return A.CommE
end

function A.RS.InvokeServer(remoteName, ...)
    local remote = A.RS.GetRemote(remoteName)
    if not remote or not remote:IsA("RemoteFunction") then
        warn("[Apex] Cannot invoke: " .. tostring(remoteName) .. " - not found or not RemoteFunction")
        return nil
    end
    local args = {...}
    local ok, result = pcall(function()
        return remote:InvokeServer(unpack(args))
    end)
    if ok then
        return result
    else
        warn("[Apex] InvokeServer failed for " .. remoteName .. ": " .. tostring(result))
        return nil
    end
end

function A.RS.FireServer(remoteName, ...)
    local remote = A.RS.GetRemote(remoteName)
    if not remote or not remote:IsA("RemoteEvent") then
        warn("[Apex] Cannot fire: " .. tostring(remoteName) .. " - not found or not RemoteEvent")
        return false
    end
    local args = {...}
    local ok, err = pcall(function()
        remote:FireServer(unpack(args))
    end)
    return ok
end

function A.RS.WaitForRemote(name, timeout)
    timeout = timeout or 30
    if A.RS._remoteCache[name] and A.RS._remoteCache[name].Parent then
        return A.RS._remoteCache[name]
    end
    if not A.Remotes then
        A.RS.Init()
    end
    local remote = A.SafeWait(A.Remotes or A.RS, name, timeout)
    if remote then
        A.RS._remoteCache[name] = remote
    end
    return remote
end

function A.RS.GetAllRemotes()
    if not A.Remotes then
        A.RS.Init()
    end
    if not A.Remotes then return {} end
    local remotes = {}
    local children = A.Remotes:GetDescendants()
    for i = 1, #children do
        local child = children[i]
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            table.insert(remotes, child)
        end
    end
    return remotes
end

function A.RS.GetAsset(name, timeout)
    if A.RS._assetCache[name] then
        local cached = A.RS._assetCache[name]
        if cached and cached.Parent then
            return cached
        end
        A.RS._assetCache[name] = nil
    end
    if not A.Assets then
        A.RS.Init()
    end
    if not A.Assets then return nil end
    local asset = A.SafeWait(A.Assets, name, timeout or 5)
    if asset then
        A.RS._assetCache[name] = asset
    end
    return asset
end

function A.RS.CloneAsset(name)
    local asset = A.RS.GetAsset(name)
    if asset then
        return A.SafeClone(asset)
    end
    return nil
end

function A.RS.InvalidateRemoteCache(name)
    if name then
        A.RS._remoteCache[name] = nil
    else
        A.RS._remoteCache = {}
    end
end

-----------------------------------------------------------------------
-- SECTION 6: CAMERA WRAPPER
-----------------------------------------------------------------------

A._cameraShakeActive = false
A._cameraShakeThread = nil

function A.GetCamera()
    return workspace.CurrentCamera or A.Workspace:FindFirstChildOfClass("Camera")
end

function A.SetCameraType(camType)
    local cam = A.GetCamera()
    if cam then
        local ok, err = pcall(function()
            cam.CameraType = camType
        end)
        if not ok then
            warn("[Apex] SetCameraType failed: " .. tostring(err))
        end
        return ok
    end
    return false
end

function A.CameraSubject(humanoid)
    local cam = A.GetCamera()
    if cam and humanoid then
        local ok, err = pcall(function()
            cam.CameraSubject = humanoid
        end)
        return ok
    end
    return false
end

function A.GetCamCF()
    local cam = A.GetCamera()
    if cam then
        return cam.CFrame
    end
    return CFrame.new(0, 0, 0)
end

function A.GetCamPos()
    local cam = A.GetCamera()
    if cam then
        return cam.CFrame.Position
    end
    return Vector3.new(0, 0, 0)
end

function A.SetFOV(fov)
    local cam = A.GetCamera()
    if cam then
        local ok, err = pcall(function()
            cam.FieldOfView = fov
        end)
        return ok
    end
    return false
end

function A.GetFOV()
    local cam = A.GetCamera()
    if cam then
        return cam.FieldOfView
    end
    return 70
end

function A.SetCamCFrame(cf)
    local cam = A.GetCamera()
    if cam then
        local ok, err = pcall(function()
            cam.CFrame = cf
        end)
        return ok
    end
    return false
end

function A.TweenFOV(targetFOV, duration, easingStyle, easingDirection)
    local cam = A.GetCamera()
    if not cam then return false end
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    local startFOV = cam.FieldOfView
    local info = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = A.TweenService:Create(cam, info, {FieldOfView = targetFOV})
    tween:Play()
    return tween
end

function A.CameraShake(intensity, duration, frequency)
    if A._cameraShakeActive then return false end
    A._cameraShakeActive = true
    intensity = intensity or 1
    duration = duration or 0.5
    frequency = frequency or 0.05
    local cam = A.GetCamera()
    if not cam then
        A._cameraShakeActive = false
        return false
    end
    local originalCF = cam.CFrame
    local startTime = tick()
    A._cameraShakeThread = task.spawn(function()
        while (tick() - startTime) < duration do
            if not A._cameraShakeActive then break end
            local elapsed = tick() - startTime
            local progress = elapsed / duration
            local currentIntensity = intensity * (1 - progress)
            local offsetX = (math.random() * 2 - 1) * currentIntensity
            local offsetY = (math.random() * 2 - 1) * currentIntensity
            local offsetZ = (math.random() * 2 - 1) * currentIntensity * 0.5
            pcall(function()
                cam.CFrame = originalCF * CFrame.new(offsetX, offsetY, offsetZ)
            end)
            task.wait(frequency)
        end
        A._cameraShakeActive = false
        pcall(function()
            cam.CFrame = originalCF
        end)
    end)
    return true
end

function A.StopCameraShake()
    A._cameraShakeActive = false
    if A._cameraShakeThread then
        task.cancel(A._cameraShakeThread)
        A._cameraShakeThread = nil
    end
end

function A.CameraDistortion(intensity, duration)
    local cam = A.GetCamera()
    if not cam then return false end
    duration = duration or 1
    intensity = intensity or 0.1
    local startTime = tick()
    local conn
    conn = A.RunService.RenderStepped:Connect(function(dt)
        if (tick() - startTime) >= duration then
            if conn then conn:Disconnect() end
            return
        end
        local progress = (tick() - startTime) / duration
        local currentIntensity = intensity * (1 - progress)
        local rollAngle = math.sin(tick() * 10) * currentIntensity * 10
        pcall(function()
            cam.CFrame = cam.CFrame * CFrame.Angles(0, 0, math.rad(rollAngle))
        end)
    end)
    return true
end

function A.LookAtPosition(targetPos, smoothness)
    local cam = A.GetCamera()
    if not cam then return false end
    smoothness = smoothness or 0.5
    local camPos = cam.CFrame.Position
    local lookCF = CFrame.new(camPos, targetPos)
    if smoothness >= 1 then
        cam.CFrame = lookCF
    else
        cam.CFrame = cam.CFrame:Lerp(lookCF, smoothness)
    end
    return true
end

function A.GetMouseHit(maxDistance)
    maxDistance = maxDistance or 1000
    local cam = A.GetCamera()
    local mouse = A.LocalPlayer and A.LocalPlayer:GetMouse()
    if cam and mouse then
        local ray = cam:ScreenPointToRay(mouse.X, mouse.Y)
        local result = workspace:Raycast(ray.Origin, ray.Direction * maxDistance)
        if result then
            return result.Position, result.Instance, result.Normal
        end
    end
    return nil, nil, nil
end

-----------------------------------------------------------------------
-- SECTION 7: CONNECTIONS MANAGER
-----------------------------------------------------------------------

A.Conn = {}
A._connCallbacks = {}

function A.AddConn(name, conn)
    if A.Conn[name] then
        pcall(function()
            A.Conn[name]:Disconnect()
        end)
    end
    A.Conn[name] = conn
    return conn
end

function A.RemoveConn(name)
    if A.Conn[name] then
        pcall(function()
            A.Conn[name]:Disconnect()
        end)
        A.Conn[name] = nil
        return true
    end
    return false
end

function A.DisconnectAll()
    local count = 0
    for name, conn in pairs(A.Conn) do
        if conn then
            pcall(function()
                conn:Disconnect()
            end)
            count = count + 1
        end
    end
    A.Conn = {}
    return count
end

function A.Reconnect(name, fn)
    if A.Conn[name] then
        pcall(function()
            A.Conn[name]:Disconnect()
        end)
    end
    local ok, conn = pcall(fn)
    if ok and conn then
        A.Conn[name] = conn
        return conn
    end
    warn("[Apex] Reconnect failed for: " .. tostring(name))
    return nil
end

function A.ConnectedCount()
    local count = 0
    local toRemove = {}
    for name, conn in pairs(A.Conn) do
        if conn then
            local ok, connected = pcall(function()
                return conn.Connected
            end)
            if ok and connected then
                count = count + 1
            else
                table.insert(toRemove, name)
            end
        else
            table.insert(toRemove, name)
        end
    end
    for i = 1, #toRemove do
        A.Conn[toRemove[i]] = nil
    end
    return count
end

function A.ConnGetAll()
    local active = {}
    local dead = {}
    for name, conn in pairs(A.Conn) do
        if conn then
            local ok, connected = pcall(function()
                return conn.Connected
            end)
            if ok and connected then
                active[name] = conn
            else
                dead[name] = conn
            end
        else
            dead[name] = true
        end
    end
    return active, dead
end

function A.ConnIsAlive(name)
    local conn = A.Conn[name]
    if not conn then return false end
    local ok, connected = pcall(function()
        return conn.Connected
    end)
    return ok and connected
end

-----------------------------------------------------------------------
-- SECTION 8: RENDER STEPPED SYSTEM
-----------------------------------------------------------------------

A._renderCallbacks = {}
A._renderConnections = {}
A._renderOrder = {}
A._renderActive = false

function A.OnRender(fn, name, priority)
    if not name then
        name = "render_" .. tostring(tick()) .. "_" .. tostring(math.random(100000))
    end
    priority = priority or 50
    A._renderCallbacks[name] = {
        func = fn,
        priority = priority,
        enabled = true,
        created = tick()
    }
    table.insert(A._renderOrder, name)
    table.sort(A._renderOrder, function(a, b)
        return (A._renderCallbacks[a].priority or 50) < (A._renderCallbacks[b].priority or 50)
    end)
    if not A._renderActive then
        A._renderStart()
    end
    return name
end

function A.RemoveRender(name)
    if A._renderCallbacks[name] then
        A._renderCallbacks[name] = nil
        for i = #A._renderOrder, 1, -1 do
            if A._renderOrder[i] == name then
                table.remove(A._renderOrder, i)
                break
            end
        end
        return true
    end
    return false
end

function A.EnableRender(name)
    if A._renderCallbacks[name] then
        A._renderCallbacks[name].enabled = true
        return true
    end
    return false
end

function A.DisableRender(name)
    if A._renderCallbacks[name] then
        A._renderCallbacks[name].enabled = false
        return true
    end
    return false
end

function A._renderStart()
    if A._renderActive then return end
    A._renderActive = true
    local conn = A.RunService.RenderStepped:Connect(function(dt)
        for i = 1, #A._renderOrder do
            local name = A._renderOrder[i]
            local cb = A._renderCallbacks[name]
            if cb and cb.enabled and cb.func then
                local ok, err = pcall(cb.func, dt)
                if not ok then
                    warn("[Apex] Render callback '" .. name .. "' error: " .. tostring(err))
                end
            end
        end
    end)
    A.AddConn("__apex_render_main", conn)
end

function A.RenderCallbackCount()
    local count = 0
    for _ in pairs(A._renderCallbacks) do
        count = count + 1
    end
    return count
end

function A.ClearAllRenders()
    for name, _ in pairs(A._renderCallbacks) do
        A._renderCallbacks[name] = nil
    end
    A._renderOrder = {}
end

-----------------------------------------------------------------------
-- SECTION 9: HEARTBEAT SYSTEM
-----------------------------------------------------------------------

A._heartbeatCallbacks = {}
A._heartbeatOrder = {}
A._heartbeatActive = false

function A.OnHeartbeat(fn, name, priority)
    if not name then
        name = "heartbeat_" .. tostring(tick()) .. "_" .. tostring(math.random(100000))
    end
    priority = priority or 50
    A._heartbeatCallbacks[name] = {
        func = fn,
        priority = priority,
        enabled = true,
        created = tick()
    }
    table.insert(A._heartbeatOrder, name)
    table.sort(A._heartbeatOrder, function(a, b)
        return (A._heartbeatCallbacks[a].priority or 50) < (A._heartbeatCallbacks[b].priority or 50)
    end)
    if not A._heartbeatActive then
        A._heartbeatStart()
    end
    return name
end

function A.RemoveHeartbeat(name)
    if A._heartbeatCallbacks[name] then
        A._heartbeatCallbacks[name] = nil
        for i = #A._heartbeatOrder, 1, -1 do
            if A._heartbeatOrder[i] == name then
                table.remove(A._heartbeatOrder, i)
                break
            end
        end
        return true
    end
    return false
end

function A.EnableHeartbeat(name)
    if A._heartbeatCallbacks[name] then
        A._heartbeatCallbacks[name].enabled = true
        return true
    end
    return false
end

function A.DisableHeartbeat(name)
    if A._heartbeatCallbacks[name] then
        A._heartbeatCallbacks[name].enabled = false
        return true
    end
    return false
end

function A._heartbeatStart()
    if A._heartbeatActive then return end
    A._heartbeatActive = true
    local conn = A.RunService.Heartbeat:Connect(function(dt)
        for i = 1, #A._heartbeatOrder do
            local name = A._heartbeatOrder[i]
            local cb = A._heartbeatCallbacks[name]
            if cb and cb.enabled and cb.func then
                local ok, err = pcall(cb.func, dt)
                if not ok then
                    warn("[Apex] Heartbeat callback '" .. name .. "' error: " .. tostring(err))
                end
            end
        end
    end)
    A.AddConn("__apex_heartbeat_main", conn)
end

function A.HeartbeatCallbackCount()
    local count = 0
    for _ in pairs(A._heartbeatCallbacks) do
        count = count + 1
    end
    return count
end

function A.ClearAllHeartbeats()
    for name, _ in pairs(A._heartbeatCallbacks) do
        A._heartbeatCallbacks[name] = nil
    end
    A._heartbeatOrder = {}
end

-----------------------------------------------------------------------
-- SECTION 10: STEPPED SYSTEM
-----------------------------------------------------------------------

A._steppedCallbacks = {}
A._steppedOrder = {}
A._steppedActive = false

function A.OnStepped(fn, name, priority)
    if not name then
        name = "stepped_" .. tostring(tick()) .. "_" .. tostring(math.random(100000))
    end
    priority = priority or 50
    A._steppedCallbacks[name] = {
        func = fn,
        priority = priority,
        enabled = true,
        created = tick()
    }
    table.insert(A._steppedOrder, name)
    table.sort(A._steppedOrder, function(a, b)
        return (A._steppedCallbacks[a].priority or 50) < (A._steppedCallbacks[b].priority or 50)
    end)
    if not A._steppedActive then
        A._steppedStart()
    end
    return name
end

function A.RemoveStepped(name)
    if A._steppedCallbacks[name] then
        A._steppedCallbacks[name] = nil
        for i = #A._steppedOrder, 1, -1 do
            if A._steppedOrder[i] == name then
                table.remove(A._steppedOrder, i)
                break
            end
        end
        return true
    end
    return false
end

function A.EnableStepped(name)
    if A._steppedCallbacks[name] then
        A._steppedCallbacks[name].enabled = true
        return true
    end
    return false
end

function A.DisableStepped(name)
    if A._steppedCallbacks[name] then
        A._steppedCallbacks[name].enabled = false
        return true
    end
    return false
end

function A._steppedStart()
    if A._steppedActive then return end
    A._steppedActive = true
    local conn = A.RunService.Stepped:Connect(function(time, dt)
        for i = 1, #A._steppedOrder do
            local name = A._steppedOrder[i]
            local cb = A._steppedCallbacks[name]
            if cb and cb.enabled and cb.func then
                local ok, err = pcall(cb.func, time, dt)
                if not ok then
                    warn("[Apex] Stepped callback '" .. name .. "' error: " .. tostring(err))
                end
            end
        end
    end)
    A.AddConn("__apex_stepped_main", conn)
end

function A.SteppedCallbackCount()
    local count = 0
    for _ in pairs(A._steppedCallbacks) do
        count = count + 1
    end
    return count
end

function A.ClearAllStepped()
    for name, _ in pairs(A._steppedCallbacks) do
        A._steppedCallbacks[name] = nil
    end
    A._steppedOrder = {}
end

-----------------------------------------------------------------------
-- SECTION 11: TELEPORT SERVICE (A.TP)
-----------------------------------------------------------------------

A.TP = {}
A.TP._stuckDetection = false
A.TP._lastPositions = {}
A.TP._antiTeleportCheck = true
A.TP._movementThread = nil
A.TP._flyActive = false
A.TP._flyBody = nil
A.TP._flyGyro = nil

function A.TP.GetCharacter()
    local char = A.LocalPlayer.Character
    if not char then
        char = A.LocalPlayer.CharacterAdded:Wait()
    end
    return char
end

function A.TP.GetHumanoidRootPart()
    local char = A.TP.GetCharacter()
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

function A.TP.GetHumanoid()
    local char = A.TP.GetCharacter()
    if char then
        return char:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

function A.TP.GetPosition()
    local hrp = A.TP.GetHumanoidRootPart()
    if hrp then
        return hrp.Position
    end
    return Vector3.new(0, 0, 0)
end

function A.TP.GetCF()
    local hrp = A.TP.GetHumanoidRootPart()
    if hrp then
        return hrp.CFrame
    end
    return CFrame.new(0, 0, 0)
end

function A.TP.DistanceTo(targetPos)
    local myPos = A.TP.GetPosition()
    return (myPos - targetPos).Magnitude
end

function A.TP.EstimateTime(targetPos, speed)
    local dist = A.TP.DistanceTo(targetPos)
    speed = speed or 16
    return dist / speed
end

function A.TP.TPTo(pos, range)
    if not pos then return false end
    range = range or 3
    local hrp = A.TP.GetHumanoidRootPart()
    if not hrp then
        warn("[Apex] TPTo: No HumanoidRootPart")
        return false
    end
    local attempts = 0
    local maxAttempts = 5
    while attempts < maxAttempts do
        attempts = attempts + 1
        local currentCF = hrp.CFrame
        local targetCF = CFrame.new(pos)
        local ok, err = pcall(function()
            hrp.CFrame = targetCF
        end)
        if ok then
            task.wait(0.2)
            local newDist = A.TP.DistanceTo(pos)
            if newDist <= range then
                return true
            end
            if A.TP._antiTeleportCheck then
                local newHRP = A.TP.GetHumanoidRootPart()
                if newHRP then
                    local vel = newHRP.Velocity
                    if vel.Magnitude > 100 then
                        warn("[Apex] Anti-teleport detected, velocity spike: " .. tostring(vel.Magnitude))
                        task.wait(0.5)
                    end
                end
            end
        else
            warn("[Apex] TPTo attempt " .. attempts .. " failed: " .. tostring(err))
            task.wait(0.3)
        end
    end
    return false
end

function A.TP.SafeTeleport(pos, retries)
    retries = retries or 3
    if not pos then return false end
    local startPos = A.TP.GetPosition()
    local range = math.max((pos - startPos).Magnitude * 0.1, 5)
    for attempt = 1, retries do
        local hrp = A.TP.GetHumanoidRootPart()
        if not hrp then
            A.LocalPlayer.CharacterAdded:Wait()
            task.wait(0.5)
            hrp = A.TP.GetHumanoidRootPart()
            if not hrp then return false end
        end
        local ok = A.TP.TPTo(pos, range)
        if ok then
            return true
        end
        task.wait(0.5 + (attempt * 0.2))
    end
    warn("[Apex] SafeTeleport failed after " .. retries .. " attempts")
    return false
end

function A.TP.TweenTo(pos, speed)
    if not pos then return false end
    speed = speed or 50
    local hrp = A.TP.GetHumanoidRootPart()
    if not hrp then return false end
    local startPos = hrp.Position
    local distance = (pos - startPos).Magnitude
    if distance < 1 then return true end
    local duration = distance / speed
    duration = math.clamp(duration, 0.05, 5)
    local startCF = hrp.CFrame
    local endCF = CFrame.new(pos)
    local startTime = tick()
    A.TP._movementThread = task.spawn(function()
        while (tick() - startTime) < duration do
            local hrpNow = A.TP.GetHumanoidRootPart()
            if not hrpNow then break end
            local progress = math.clamp((tick() - startTime) / duration, 0, 1)
            local smoothProgress = progress * progress * (3 - 2 * progress)
            local newCF = startCF:Lerp(endCF, smoothProgress)
            pcall(function()
                hrpNow.CFrame = newCF
            end)
            task.wait()
        end
        local hrpFinal = A.TP.GetHumanoidRootPart()
        if hrpFinal then
            pcall(function()
                hrpFinal.CFrame = endCF
            end)
        end
    end)
    return true
end

function A.TP.FlyTo(pos, speed)
    if not pos then return false end
    speed = speed or 80
    local hrp = A.TP.GetHumanoidRootPart()
    if not hrp then return false end
    local humanoid = A.TP.GetHumanoid()
    if humanoid then
        humanoid.PlatformStand = true
    end
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.P = 10000
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = hrp
    A.TP._flyBody = bodyVelocity
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 9000
    bodyGyro.D = 500
    bodyGyro.Parent = hrp
    A.TP._flyGyro = bodyGyro
    A.TP._flyActive = true
    A.TP._movementThread = task.spawn(function()
        while A.TP._flyActive do
            local hrpNow = A.TP.GetHumanoidRootPart()
            if not hrpNow then break end
            local currentPos = hrpNow.Position
            local dist = (pos - currentPos).Magnitude
            if dist < 3 then break end
            local dir = (pos - currentPos).Unit
            bodyVelocity.Velocity = dir * speed
            bodyGyro.CFrame = CFrame.new(currentPos, pos)
            task.wait()
        end
        A.TP.StopFly()
    end)
    return true
end

function A.TP.StopFly()
    A.TP._flyActive = false
    if A.TP._flyBody and A.TP._flyBody.Parent then
        A.SafeDestroy(A.TP._flyBody)
    end
    A.TP._flyBody = nil
    if A.TP._flyGyro and A.TP._flyGyro.Parent then
        A.SafeDestroy(A.TP._flyGyro)
    end
    A.TP._flyGyro = nil
    local humanoid = A.TP.GetHumanoid()
    if humanoid then
        humanoid.PlatformStand = false
    end
end

function A.TP.PathTo(pos)
    if not pos then return false end
    local hrp = A.TP.GetHumanoidRootPart()
    if not hrp then return false end
    local path = A.PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentCanClimb = false,
        WaypointSpacing = 4
    })
    local ok, err = pcall(function()
        path:ComputeAsync(hrp.Position, pos)
    end)
    if not ok then
        warn("[Apex] PathTo ComputeAsync failed: " .. tostring(err))
        return false
    end
    if path.Status ~= Enum.PathStatus.Success then
        warn("[Apex] PathTo: Pathfinding failed, status: " .. tostring(path.Status))
        return false
    end
    local waypoints = path:GetWaypoints()
    if not waypoints or #waypoints == 0 then
        return false
    end
    local humanoid = A.TP.GetHumanoid()
    if not humanoid then return false end
    A.TP._movementThread = task.spawn(function()
        for i = 2, #waypoints do
            if not A.TP._flyActive then break end
            local wp = waypoints[i]
            humanoid:MoveTo(wp.Position)
            if wp.Action == Enum.WaypointAction.Jump then
                humanoid.Jump = true
            end
            humanoid.MoveToFinished:Wait()
        end
    end)
    return true
end

function A.TP.CancelMovement()
    if A.TP._movementThread then
        task.cancel(A.TP._movementThread)
        A.TP._movementThread = nil
    end
    A.TP.StopFly()
end

function A.TP.StartStuckDetection(interval, stuckThreshold, callback)
    interval = interval or 0.5
    stuckThreshold = stuckThreshold or 1
    A.TP._stuckDetection = true
    A.TP._lastPositions = {}
    local name = "__apex_stuck_detection"
    A.OnHeartbeat(function(dt)
        if not A.TP._stuckDetection then
            A.RemoveHeartbeat(name)
            return
        end
        local hrp = A.TP.GetHumanoidRootPart()
        if not hrp then return end
        local pos = hrp.Position
        local posKey = tostring(math.floor(pos.X)) .. "_" .. tostring(math.floor(pos.Z))
        if A.TP._lastPositions[posKey] then
            A.TP._lastPositions[posKey] = A.TP._lastPositions[posKey] + dt
            if A.TP._lastPositions[posKey] > stuckThreshold then
                if callback then
                    pcall(callback, pos, A.TP._lastPositions[posKey])
                end
                A.TP._lastPositions[posKey] = 0
            end
        else
            A.TP._lastPositions = {}
            A.TP._lastPositions[posKey] = 0
        end
    end, name, 90)
end

function A.TP.StopStuckDetection()
    A.TP._stuckDetection = false
    A.RemoveHeartbeat("__apex_stuck_detection")
end

-----------------------------------------------------------------------
-- SECTION 12: PERFORMANCE MONITORING
-----------------------------------------------------------------------

A.Perf = {}
A.Perf._fpsHistory = {}
A.Perf._memoryHistory = {}
A.Perf._pingHistory = {}
A.Perf._tracking = false
A.Perf._trackingConn = nil
A.Perf._lastFrameTime = tick()
A.Perf._frameCount = 0
A.Perf._currentFPS = 60
A.Perf._lastCheckTime = tick()

function A.Perf.StartTracking(interval)
    if A.Perf._tracking then return end
    A.Perf._tracking = true
    A.Perf._lastFrameTime = tick()
    A.Perf._frameCount = 0
    A.Perf._lastCheckTime = tick()
    A.Perf._renderConn = A.RunService.RenderStepped:Connect(function()
        A.Perf._frameCount = A.Perf._frameCount + 1
        local now = tick()
        local elapsed = now - A.Perf._lastCheckTime
        if elapsed >= (interval or 1) then
            A.Perf._currentFPS = math.floor(A.Perf._frameCount / elapsed)
            table.insert(A.Perf._fpsHistory, A.Perf._currentFPS)
            if #A.Perf._fpsHistory > 120 then
                table.remove(A.Perf._fpsHistory, 1)
            end
            local ok, memUsage = pcall(function()
                return gcinfo()
            end)
            if ok then
                table.insert(A.Perf._memoryHistory, memUsage)
                if #A.Perf._memoryHistory > 120 then
                    table.remove(A.Perf._memoryHistory, 1)
                end
            end
            local ok2, ping = pcall(function()
                local stats = game:GetService("Stats")
                return stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            if ok2 and ping then
                table.insert(A.Perf._pingHistory, math.floor(ping))
                if #A.Perf._pingHistory > 120 then
                    table.remove(A.Perf._pingHistory, 1)
                end
            end
            A.Perf._frameCount = 0
            A.Perf._lastCheckTime = now
        end
    end)
end

function A.Perf.StopTracking()
    A.Perf._tracking = false
    if A.Perf._renderConn then
        pcall(function() A.Perf._renderConn:Disconnect() end)
        A.Perf._renderConn = nil
    end
end

function A.Perf.GetFPS()
    return A.Perf._currentFPS
end

function A.Perf.GetMemoryMB()
    local ok, mem = pcall(function()
        return gcinfo()
    end)
    if ok then
        return mem / 1024
    end
    return 0
end

function A.Perf.GetPing()
    if #A.Perf._pingHistory > 0 then
        return A.Perf._pingHistory[#A.Perf._pingHistory]
    end
    local ok, ping = pcall(function()
        local stats = game:GetService("Stats")
        return stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok and ping then
        return math.floor(ping)
    end
    return 0
end

function A.Perf.GetFPSAverage()
    if #A.Perf._fpsHistory == 0 then return 0 end
    local sum = 0
    for i = 1, #A.Perf._fpsHistory do
        sum = sum + A.Perf._fpsHistory[i]
    end
    return math.floor(sum / #A.Perf._fpsHistory)
end

function A.Perf.GetFPSMin()
    if #A.Perf._fpsHistory == 0 then return 0 end
    local min = A.Perf._fpsHistory[1]
    for i = 2, #A.Perf._fpsHistory do
        if A.Perf._fpsHistory[i] < min then
            min = A.Perf._fpsHistory[i]
        end
    end
    return min
end

function A.Perf.GetFPSMax()
    if #A.Perf._fpsHistory == 0 then return 0 end
    local max = A.Perf._fpsHistory[1]
    for i = 2, #A.Perf._fpsHistory do
        if A.Perf._fpsHistory[i] > max then
            max = A.Perf._fpsHistory[i]
        end
    end
    return max
end

function A.Perf.GetPingAverage()
    if #A.Perf._pingHistory == 0 then return 0 end
    local sum = 0
    for i = 1, #A.Perf._pingHistory do
        sum = sum + A.Perf._pingHistory[i]
    end
    return math.floor(sum / #A.Perf._pingHistory)
end

function A.Perf.GetMemoryAverageMB()
    if #A.Perf._memoryHistory == 0 then return 0 end
    local sum = 0
    for i = 1, #A.Perf._memoryHistory do
        sum = sum + A.Perf._memoryHistory[i]
    end
    return (sum / #A.Perf._memoryHistory) / 1024
end

function A.Perf.GetReport()
    return {
        fps = A.Perf.GetFPS(),
        fpsAvg = A.Perf.GetFPSAverage(),
        fpsMin = A.Perf.GetFPSMin(),
        fpsMax = A.Perf.GetFPSMax(),
        memoryMB = A.Perf.GetMemoryMB(),
        memoryAvgMB = A.Perf.GetMemoryAverageMB(),
        ping = A.Perf.GetPing(),
        pingAvg = A.Perf.GetPingAverage(),
        timestamp = tick()
    }
end

function A.Perf.ServerHopTiming()
    return {
        startTick = tick(),
        teleportStart = nil,
        teleportEnd = nil,
        loadStart = nil,
        loadEnd = nil,
        totalDuration = nil,
        serverName = tostring(game.JobId)
    }
end

-----------------------------------------------------------------------
-- SECTION 13: EVENT BUS SYSTEM
-----------------------------------------------------------------------

A.EventBus = {}
A.EventBus._listeners = {}
A.EventBus._history = {}
A.EventBus._historyLimit = 100
A.EventBus._historyEnabled = false

function A.EventBus:On(event, fn)
    if not event or not fn then return nil end
    if not self._listeners[event] then
        self._listeners[event] = {}
    end
    local id = tostring(tick()) .. "_" .. tostring(math.random(1000000))
    self._listeners[event][id] = {
        func = fn,
        enabled = true,
        created = tick(),
        fireCount = 0
    }
    return id
end

function A.EventBus:Once(event, fn)
    if not event or not fn then return nil end
    local id
    id = self:On(event, function(...)
        fn(...)
        self:Off(event, id)
    end)
    return id
end

function A.EventBus:Off(event, id)
    if not event then return false end
    if id then
        if self._listeners[event] then
            self._listeners[event][id] = nil
            return true
        end
    else
        self._listeners[event] = {}
        return true
    end
    return false
end

function A.EventBus:Fire(event, ...)
    if not event then return 0 end
    local count = 0
    if self._listeners[event] then
        local toRemove = {}
        for id, listener in pairs(self._listeners[event]) do
            if listener and listener.enabled and listener.func then
                listener.fireCount = listener.fireCount + 1
                local ok, err = pcall(listener.func, ...)
                if not ok then
                    warn("[Apex] EventBus '" .. event .. "' listener error: " .. tostring(err))
                    table.insert(toRemove, id)
                else
                    count = count + 1
                end
            else
                table.insert(toRemove, id)
            end
        end
        for i = 1, #toRemove do
            self._listeners[event][toRemove[i]] = nil
        end
    end
    if self._historyEnabled and count > 0 then
        local entry = {
            event = event,
            args = {...},
            timestamp = tick(),
            listenerCount = count
        }
        table.insert(self._history, entry)
        if #self._history > self._historyLimit then
            table.remove(self._history, 1)
        end
    end
    return count
end

function A.EventBus:GetListenerCount(event)
    if not event then return 0 end
    if not self._listeners[event] then return 0 end
    local count = 0
    for _, listener in pairs(self._listeners[event]) do
        if listener and listener.enabled then
            count = count + 1
        end
    end
    return count
end

function A.EventBus:GetAllEvents()
    local events = {}
    for event, listeners in pairs(self._listeners) do
        local count = 0
        for _, listener in pairs(listeners) do
            if listener and listener.enabled then
                count = count + 1
            end
        end
        if count > 0 then
            table.insert(events, {event = event, listenerCount = count})
        end
    end
    return events
end

function A.EventBus:EnableHistory(enabled, limit)
    self._historyEnabled = enabled or false
    self._historyLimit = limit or 100
end

function A.EventBus:GetHistory()
    return self._history
end

function A.EventBus:ClearHistory()
    self._history = {}
end

function A.EventBus:EnableListener(event, id, enabled)
    if not event or not id then return false end
    if self._listeners[event] and self._listeners[event][id] then
        self._listeners[event][id].enabled = enabled
        return true
    end
    return false
end

function A.EventBus:RemoveAll()
    self._listeners = {}
end

function A.EventBus:Debug()
    local info = {
        totalEvents = 0,
        totalListeners = 0,
        events = {}
    }
    for event, listeners in pairs(self._listeners) do
        local count = 0
        for _, l in pairs(listeners) do
            if l and l.enabled then
                count = count + 1
                info.totalListeners = info.totalListeners + 1
            end
        end
        info.totalEvents = info.totalEvents + 1
        info.events[event] = count
    end
    return info
end

-----------------------------------------------------------------------
-- SECTION 14: ADDITIONAL UTILITY WRAPPERS
-----------------------------------------------------------------------

function A.SafeTween(instance, tweenInfo, goal, waitComplete)
    if not instance then return nil end
    local ok, tween = pcall(function()
        return A.TweenService:Create(instance, tweenInfo, goal)
    end)
    if ok and tween then
        tween:Play()
        if waitComplete then
            tween.Completed:Wait()
        end
        return tween
    end
    return nil
end

function A.SafeTeleportService(targetPlaceId, targetJobId, timeout)
    timeout = timeout or 15
    local TeleportService = A.GetService("TeleportService")
    if not TeleportService then return false end
    local ok, err = pcall(function()
        if targetJobId and targetJobId ~= "" then
            TeleportService:TeleportToPlaceInstance(targetPlaceId, targetJobId, A.LocalPlayer)
        else
            TeleportService:Teleport(targetPlaceId, A.LocalPlayer)
        end
    end)
    return ok
end

function A.SafeSetCore(coreName, value)
    local ok, err = pcall(function()
        A.StarterGui:SetCore(coreName, value)
    end)
    return ok
end

function A.SafeGetCore(coreName)
    local ok, result = pcall(function()
        return A.StarterGui:GetCore(coreName)
    end)
    if ok then return result end
    return nil
end

function A.SafeNotification(title, text, duration)
    A.SafeSetCore("SendNotification", {
        Title = title or "Apex Hub",
        Text = text or "",
        Duration = duration or 5
    })
end

function A.WaitForCharacter(maxWait)
    maxWait = maxWait or 30
    local char = A.LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then return char end
    end
    local start = tick()
    while (tick() - start) < maxWait do
        char = A.LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then return char end
        end
        task.wait(0.1)
    end
    return A.LocalPlayer.Character
end

function A.WaitForHRP(maxWait)
    maxWait = maxWait or 30
    local char = A.WaitForCharacter(maxWait)
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

function A.WaitForHumanoid(maxWait)
    maxWait = maxWait or 30
    local char = A.WaitForCharacter(maxWait)
    if char then
        return char:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

function A.GetTool()
    local char = A.LocalPlayer.Character
    if char then
        return char:FindFirstChildOfClass("Tool")
    end
    return nil
end

function A.GetBackpack()
    return A.LocalPlayer:FindFirstChildOfClass("Backpack")
end

function A.GetAllTools()
    local tools = {}
    local char = A.LocalPlayer.Character
    if char then
        local charTools = char:GetChildren()
        for i = 1, #charTools do
            if charTools[i]:IsA("Tool") then
                table.insert(tools, charTools[i])
            end
        end
    end
    local backpack = A.GetBackpack()
    if backpack then
        local bpTools = backpack:GetChildren()
        for i = 1, #bpTools do
            if bpTools[i]:IsA("Tool") then
                table.insert(tools, bpTools[i])
            end
        end
    end
    return tools
end

function A.EquipTool(toolName)
    local backpack = A.GetBackpack()
    if not backpack then return false end
    local tool = backpack:FindFirstChild(toolName)
    if tool then
        local humanoid = A.TP.GetHumanoid()
        if humanoid then
            humanoid:EquipTool(tool)
            return true
        end
    end
    local charTools = A.GetAllTools()
    for i = 1, #charTools do
        if charTools[i].Name == toolName then
            local humanoid = A.TP.GetHumanbed()
            if humanoid then
                humanoid:EquipTool(charTools[i])
                return true
            end
        end
    end
    return false
end

function A.UnEquipTool()
    local humanoid = A.TP.GetHumanoid()
    if humanoid then
        humanoid:UnequipTools()
        return true
    end
    return false
end

function A.IsAlive()
    local char = A.LocalPlayer.Character
    if not char then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    return humanoid.Health > 0
end

function A.GetHealth()
    local humanoid = A.TP.GetHumanoid()
    if humanoid then
        return humanoid.Health, humanoid.MaxHealth
    end
    return 0, 100
end

function A.GetPing()
    return A.Perf.GetPing()
end

function A.GetServerHopTime()
    local ok, jobId = pcall(function()
        return game.JobId
    end)
    if ok and jobId then
        return {
            jobId = jobId,
            serverAge = tick() - game:GetService("Workspace").DistributedGameTime
        }
    end
    return nil
end

-----------------------------------------------------------------------
-- SECTION 15: CLEANUP / DESTROY
-----------------------------------------------------------------------

function A.Cleanup()
    A.DisconnectAll()
    A.ClearAllRenders()
    A.ClearAllHeartbeats()
    A.ClearAllStepped()
    A.TP.CancelMovement()
    A.TP.StopStuckDetection()
    A.Perf.StopTracking()
    A.EventBus:RemoveAll()
    A.WS._cache = {}
    A.RS._remoteCache = {}
    A.RS._assetCache = {}
    A._renderActive = false
    A._heartbeatActive = false
    A._steppedActive = false
    A._serviceCache = {}
end

-----------------------------------------------------------------------
-- SECTION 16: INITIALIZATION
-----------------------------------------------------------------------

A._initTime = tick()

task.spawn(function()
    pcall(function()
        A.RS.Init()
    end)
    A.WS.CacheChildren(A.WS, false)
    A.__services_loaded = true
end)

return A
