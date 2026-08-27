--// Advanced Sea Events Module | Apex Hub v13

local A = _G.Apex or {}
local AdvSea = {}
A.AdvSea = AdvSea

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local connections = {}
local flags = {}
local stats = {}
local cached = {}

local function connect(name, signal, fn)
    if connections[name] then pcall(function() connections[name]:Disconnect() end) end
    connections[name] = signal:Connect(fn)
end

local function disconnect(name)
    if connections[name] then pcall(function() connections[name]:Disconnect() end) end
    connections[name] = nil
end

local function safe(fn, ...)
    local ok, res = pcall(fn, ...)
    return ok, res
end

local function findFirstChild(parent, name, recursive)
    if not parent then return nil end
    return parent:FindFirstChild(name, recursive or false)
end

local function getChildren(parent)
    if not parent then return {} end
    return parent:GetChildren()
end

local function getDescendants(parent)
    if not parent then return {} end
    return parent:GetDescendants()
end

local function dist(a, b)
    if not a or not b then return math.huge end
    local pA = a:IsA("BasePart") and a.Position or (a:FindFirstChild("HumanoidRootPart") and a.HumanoidRootPart.Position or Vector3.new(0,0,0))
    local pB = b:IsA("BasePart") and b.Position or (b:FindFirstChild("HumanoidRootPart") and b.HumanoidRootPart.Position or Vector3.new(0,0,0))
    return (pA - pB).Magnitude
end

local function getHRP()
    return A.HRP and A.HRP() or nil
end

local function getChar()
    return A.Char and A.Char() or nil
end

local function getHum()
    return A.Hum and A.Hum() or nil
end

local function getLP()
    return A.LP and A.LP() or nil
end

local function commF(...)
    if A.CommF then return A.CommF(...) end
    return nil
end

local function tpTo(pos, range)
    if A.TpTo then A.TpTo(pos, range or 10) end
end

local function tweenTo(pos, speed)
    if A.TweenTo then A.TweenTo(pos, speed or 350) end
end

local function attack(target, keys, delay)
    if A.Attack then A.Attack(target, keys, delay) end
end

local function alive()
    if A.Alive then return A.Alive() end
    return false
end

local function notify(title, text, dur)
    if A.Notify then A.Notify(title or "Apex", text or "", dur or 2) end
end

local function sea()
    if A.Sea then return A.Sea() end
    return 0
end

local function hasTool(toolName)
    local lp = getLP()
    if not lp then return false end
    local backpack = findFirstChild(lp, "Backpack")
    if backpack and findFirstChild(backpack, toolName) then return true end
    local char = getChar()
    if char and findFirstChild(char, toolName) then return true end
    return false
end

local function equipTool(toolName)
    local lp = getLP()
    if not lp then return false end
    local backpack = findFirstChild(lp, "Backpack")
    if backpack then
        local tool = findFirstChild(backpack, toolName)
        if tool then
            tool.Parent = getChar() or lp
            return true
        end
    end
    local char = getChar()
    if char then
        local tool = findFirstChild(char, toolName)
        if tool then return true end
    end
    return false
end

local function getTool()
    local lp = getLP()
    if not lp then return nil end
    local char = getChar()
    if char then
        for _, v in ipairs(getChildren(char)) do
            if v:IsA("Tool") then return v end
        end
    end
    local backpack = findFirstChild(lp, "Backpack")
    if backpack then
        for _, v in ipairs(getChildren(backpack)) do
            if v:IsA("Tool") then return v end
        end
    end
    return nil
end

local function getSeaBeasts()
    local found = {}
    local workspaceChildren = getChildren(workspace)
    for _, v in ipairs(workspaceChildren) do
        if v.Name == "SeaBeast1" or v.Name == "SeaBeast2" or v.Name == "SeaBeast3" then
            local hp = findFirstChild(v, "Humanoid")
            if hp and hp.Health > 0 then
                table.insert(found, v)
            end
        end
    end
    return found
end

local function getLeviathan()
    local ws = getChildren(workspace)
    for _, v in ipairs(ws) do
        if string.find(v.Name, "leviathan") or string.find(v.Name, "Leviathan") then
            return v
        end
    end
    for _, v in ipairs(ws) do
        if v.Name == "FrozenDimension" then
            return v
        end
    end
    return nil
end

local function getMegalodon()
    local ws = getChildren(workspace)
    for _, v in ipairs(ws) do
        if string.find(v.Name, "megalodon") or string.find(v.Name, "Megalodon") then
            local hp = findFirstChild(v, "Humanoid")
            if hp and hp.Health > 0 then
                return v
            end
        end
    end
    return nil
end

local function getGhostShip()
    local ws = getChildren(workspace)
    for _, v in ipairs(ws) do
        if string.find(v.Name, "GhostShip") or string.find(v.Name, "ghostship") then
            return v
        end
    end
    return nil
end

local function getPiranhas()
    local found = {}
    local ws = getChildren(workspace)
    for _, v in ipairs(ws) do
        if string.find(v.Name, "Piranha") or string.find(v.Name, "piranha") then
            local hp = findFirstChild(v, "Humanoid")
            if hp and hp.Health > 0 then
                table.insert(found, v)
            end
        end
    end
    return found
end

local function getSeaEventsFolder()
    local lp = getLP()
    if not lp then return nil end
    local plrFolder = findFirstChild(workspace, lp.Name)
    if plrFolder then
        local seaFolder = findFirstChild(plrFolder, "SeaEvents")
        if seaFolder then return seaFolder end
    end
    return nil
end

local function getShipFolder()
    local lp = getLP()
    if not lp then return nil end
    return findFirstChild(workspace, "Ship")
end

local function getBoat()
    local ship = getShipFolder()
    if ship then return ship end
    local lp = getLP()
    if lp then
        local char = getChar()
        if char then
            local vehicleSeat = findFirstChild(char, "VehicleSeat")
            if vehicleSeat then
                return vehicleSeat.Parent
            end
        end
    end
    return nil
end

local function destroyBoat()
    local lp = getLP()
    if not lp then return end
    local boat = getBoat()
    if boat then
        boat:Destroy()
    end
end

local function getMirageIsland()
    local ws = getChildren(workspace)
    for _, v in ipairs(ws) do
        if string.find(v.Name, "Mirage") or string.find(v.Name, "mirage") then
            return v
        end
    end
    return nil
end

local function getBlueGear()
    local mirage = getMirageIsland()
    if not mirage then return nil end
    local desc = getDescendants(mirage)
    for _, v in ipairs(desc) do
        if string.find(v.Name, "BlueGear") or string.find(v.Name, "bluegear") then
            return v
        end
    end
    return nil
end

local function getPirateRaidFolder()
    local ws = getChildren(workspace)
    for _, v in ipairs(ws) do
        if string.find(v.Name, "PirateRaid") or string.find(v.Name, "pirateraid") then
            return v
        end
    end
    return nil
end

local function getFactoryRaidFolder()
    local ws = getChildren(workspace)
    for _, v in ipairs(ws) do
        if string.find(v.Name, "Factory") or string.find(v.Name, "factory") then
            return v
        end
    end
    return nil
end

local function getCastleFolder()
    local ws = getChildren(workspace)
    for _, v in ipairs(ws) do
        if string.find(v.Name, "Castle") or string.find(v.Name, "castle") then
            return v
        end
    end
    return nil
end

local function getHeart()
    local lp = getLP()
    if not lp then return nil end
    local char = getChar()
    if char then
        local heart = findFirstChild(char, "LeviathanHeart")
        if heart then return heart end
    end
    local backpack = findFirstChild(lp, "Backpack")
    if backpack then
        local heart = findFirstChild(backpack, "LeviathanHeart")
        if heart then return heart end
    end
    return nil
end

local function getHeartObject()
    local lp = getLP()
    if not lp then return nil end
    local char = getChar()
    if not char then return nil end
    local desc = getDescendants(char)
    for _, v in ipairs(desc) do
        if v.Name == "LeviathanHeart" and v:IsA("Model") then
            return v
        end
    end
    local backpack = findFirstChild(lp, "Backpack")
    if backpack then
        local desc2 = getDescendants(backpack)
        for _, v in ipairs(desc2) do
            if v.Name == "LeviathanHeart" and v:IsA("Model") then
                return v
            end
        end
    end
    return nil
end

local function getGateDoor()
    local ws = getChildren(workspace)
    for _, v in ipairs(ws) do
        if string.find(v.Name, "LeviathanGate") or string.find(v.Name, "FrozenGate") then
            return v
        end
    end
    return nil
end

local function countMobsByName(mobName)
    local count = 0
    local ws = getChildren(workspace)
    for _, v in ipairs(ws) do
        if string.find(v.Name, mobName) then
            local hp = findFirstChild(v, "Humanoid")
            if hp and hp.Health > 0 then
                count = count + 1
            end
        end
    end
    return count
end

local function getDangerLevel()
    local lvl = 0
    local result, val = safe(commF, "getDangerLevel")
    if result and val then
        lvl = tonumber(val) or 0
    end
    return lvl
end

local function setDangerLevel(level)
    safe(commF, "setDangerLevel", level)
end

local function getShipHealth()
    local boat = getBoat()
    if not boat then return 0 end
    local hp = findFirstChild(boat, "Health")
    if hp then return hp.Value end
    local hum = findFirstChild(boat, "Humanoid")
    if hum then return hum.Health end
    return 0
end

local function getHarpoonAmmo()
    local lp = getLP()
    if not lp then return 0 end
    local result, val = safe(commF, "getHarpoonAmmo")
    if result and val then return tonumber(val) or 0 end
    return 0
end

local function reloadHarpoon()
    safe(commF, "reloadHarpoon")
end

local function shootHarpoon(targetPos)
    safe(commF, "shootHarpoon", targetPos)
end

local function freezeLeviathan()
    safe(commF, "freezeLeviathan")
end

local function extractHeart()
    safe(commF, "extractHeart")
end

local function unlockGate()
    safe(commF, "unlockGate")
end

local function getScales()
    local lp = getLP()
    if not lp then return 0 end
    local result, val = safe(commF, "getLeviathanScales")
    if result and val then return tonumber(val) or 0 end
    return 0
end

local function farmScales(count)
    safe(commF, "farmLeviathanScales", count)
end

local function getMegalodonTooth()
    local lp = getLP()
    if not lp then return 0 end
    local result, val = safe(commF, "getMegalodonTooth")
    if result and val then return tonumber(val) or 0 end
    return 0
end

local function farmTooth()
    safe(commF, "farmMegalodonTooth")
end

local function getGhostShipLoot()
    local lp = getLP()
    if not lp then return 0 end
    local result, val = safe(commF, "getGhostShipLoot")
    if result and val then return tonumber(val) or 0 end
    return 0
end

local function farmGhostLoot()
    safe(commF, "farmGhostShipLoot")
end

local function getSeaBeastCount()
    return #getSeaBeasts()
end

local function killAllMobs()
    local hrp = getHRP()
    if not hrp then return end
    local ws = getChildren(workspace)
    for _, v in ipairs(ws) do
        if v ~= getChar() then
            local hp = findFirstChild(v, "Humanoid")
            local root = findFirstChild(v, "HumanoidRootPart")
            if hp and hp.Health > 0 and root then
                local d = (hrp.Position - root.Position).Magnitude
                if d < 100 then
                    attack(v, {"1", "2", "3", "4"}, 0.1)
                end
            end
        end
    end
end

local function killTarget(target, maxDist)
    if not target then return end
    local hrp = getHRP()
    if not hrp then return end
    local tRoot = findFirstChild(target, "HumanoidRootPart")
    if not tRoot then return end
    local tHum = findFirstChild(target, "Humanoid")
    if not tHum or tHum.Health <= 0 then return end
    local d = (hrp.Position - tRoot.Position).Magnitude
    if d > (maxDist or 60) then
        tpTo(tRoot.Position, 5)
    end
    attack(target, {"1", "2", "3", "4"}, 0.08)
end

--================================================================
-- LEVIATHAN SYSTEM
--================================================================

AdvSea.LeviathanStats = {
    Searched = 0,
    Fought = 0,
    Killed = 0,
    HeartsExtracted = 0,
    ScalesFarmed = 0,
    GatesUnlocked = 0,
    TotalDamage = 0,
    LastSpawnPos = nil,
    TrackingActive = false,
    SearchActive = false,
    FightActive = false,
    SegmentData = {},
}

function AdvSea.LeviathanSearch()
    if not alive() then return end
    if sea() ~= 3 then
        notify("Leviathan Search", "Must be in Third Sea!", 3)
        return
    end
    AdvSea.LeviathanStats.SearchActive = true
    AdvSea.LeviathanStats.Searched = AdvSea.LeviathanStats.Searched + 1
    notify("Leviathan Search", "Searching for Leviathan spawn...", 2)
    local hrp = getHRP()
    if not hrp then return end
    local searchPositions = {
        Vector3.new(-3683, 303, -1418),
        Vector3.new(-4518, 225, -738),
        Vector3.new(-3951, 10, -724),
        Vector3.new(-4965, 10, -260),
        Vector3.new(-5239, 10, 186),
        Vector3.new(-4774, 10, 1696),
        Vector3.new(-3794, 10, 2104),
        Vector3.new(-2316, 10, 2365),
    }
    local found = false
    for _, pos in ipairs(searchPositions) do
        if not alive() or not AdvSea.LeviathanStats.SearchActive then break end
        tweenTo(pos, 400)
        task.wait(3)
        local levi = getLeviathan()
        if levi then
            AdvSea.LeviathanStats.LastSpawnPos = levi:GetPivot().Position
            AdvSea.LeviathanStats.TrackingActive = true
            notify("Leviathan Search", "Leviathan found!", 3)
            found = true
            break
        end
    end
    if not found then
        notify("Leviathan Search", "No Leviathan found this run", 2)
    end
    AdvSea.LeviathanStats.SearchActive = false
end

function AdvSea.LeviathanTrack()
    if not alive() then return end
    local levi = getLeviathan()
    if not levi then
        notify("Leviathan Track", "No Leviathan found", 2)
        return
    end
    AdvSea.LeviathanStats.TrackingActive = true
    notify("Leviathan Track", "Tracking Leviathan...", 2)
    while AdvSea.LeviathanStats.TrackingActive and alive() do
        levi = getLeviathan()
        if not levi then break end
        local pos = levi:GetPivot().Position
        AdvSea.LeviathanStats.LastSpawnPos = pos
        local hrp = getHRP()
        if hrp then
            local d = (hrp.Position - pos).Magnitude
            if d > 80 then
                tpTo(pos, 10)
            end
        end
        task.wait(1)
    end
    AdvSea.LeviathanStats.TrackingActive = false
end

function AdvSea.LeviathanSegmentTarget(segment)
    if not alive() then return end
    local levi = getLeviathan()
    if not levi then return end
    segment = segment or "head"
    local target = nil
    local desc = getDescendants(levi)
    for _, v in ipairs(desc) do
        if v:IsA("BasePart") then
            if segment == "head" and (string.find(v.Name, "Head") or string.find(v.Name, "head")) then
                target = v
                break
            elseif segment == "tail" and (string.find(v.Name, "Tail") or string.find(v.Name, "tail")) then
                target = v
                break
            elseif segment == "scales" and (string.find(v.Name, "Scale") or string.find(v.Name, "scale")) then
                target = v
                break
            end
        end
    end
    if not target then
        for _, v in ipairs(desc) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                target = v
                break
            end
        end
    end
    if target then
        AdvSea.LeviathanStats.SegmentData[segment] = target.Position
        killTarget(target, 80)
    end
end

function AdvSea.FreezeLeviathan()
    if not alive() then return end
    local levi = getLeviathan()
    if not levi then return end
    freezeLeviathan()
    notify("Leviathan Freeze", "Freezing Leviathan...", 2)
    task.wait(2)
end

function AdvSea.AutoShootHarpoon()
    if not alive() then return end
    local levi = getLeviathan()
    if not levi then return end
    local ammo = getHarpoonAmmo()
    if ammo <= 0 then
        AdvSea.AutoReloadHarpoon()
        return
    end
    local hrp = getHRP()
    if not hrp then return end
    local desc = getDescendants(levi)
    local closest = nil
    local closestDist = math.huge
    for _, v in ipairs(desc) do
        if v:IsA("BasePart") then
            local d = (hrp.Position - v.Position).Magnitude
            if d < closestDist then
                closestDist = d
                closest = v
            end
        end
    end
    if closest then
        shootHarpoon(closest.Position)
        notify("Harpoon", "Shot at Leviathan segment!", 1)
    end
end

function AdvSea.AutoReloadHarpoon()
    if not alive() then return end
    local ammo = getHarpoonAmmo()
    if ammo <= 0 then
        reloadHarpoon()
        notify("Harpoon", "Reloading...", 1)
        task.wait(1)
    end
end

function AdvSea.LeviathanFight()
    if not alive() then return end
    if sea() ~= 3 then
        notify("Leviathan Fight", "Must be in Third Sea!", 3)
        return
    end
    AdvSea.LeviathanStats.FightActive = true
    AdvSea.LeviathanStats.Fought = AdvSea.LeviathanStats.Fought + 1
    notify("Leviathan Fight", "Starting Leviathan fight...", 3)
    AdvSea.FreezeLeviathan()
    task.wait(2)
    while AdvSea.LeviathanStats.FightActive and alive() do
        local levi = getLeviathan()
        if not levi then break end
        local hp = findFirstChild(levi, "Humanoid")
        if not hp or hp.Health <= 0 then break end
        local segments = {"head", "tail", "scales"}
        for _, seg in ipairs(segments) do
            if not AdvSea.LeviathanStats.FightActive or not alive() then break end
            AdvSea.LeviathanSegmentTarget(seg)
            task.wait(0.3)
        end
        AdvSea.AutoShootHarpoon()
        task.wait(0.5)
    end
    notify("Leviathan Fight", "Fight ended", 2)
    AdvSea.LeviathanStats.FightActive = false
end

function AdvSea.LeviathanKill()
    if not alive() then return end
    AdvSea.LeviathanFight()
    local levi = getLeviathan()
    if not levi then
        AdvSea.LeviathanStats.Killed = AdvSea.LeviathanStats.Killed + 1
        notify("Leviathan Kill", "Leviathan killed!", 3)
    end
end

function AdvSea.ExtractLeviathanHeart()
    if not alive() then return end
    local heart = getHeartObject()
    if heart then
        extractHeart()
        AdvSea.LeviathanStats.HeartsExtracted = AdvSea.LeviathanStats.HeartsExtracted + 1
        notify("Leviathan", "Heart extracted!", 3)
        task.wait(1)
    else
        notify("Leviathan", "No heart to extract", 2)
    end
end

function AdvSea.LeviathanGateUnlock()
    if not alive() then return end
    local gate = getGateDoor()
    if gate then
        unlockGate()
        AdvSea.LeviathanStats.GatesUnlocked = AdvSea.LeviathanStats.GatesUnlocked + 1
        notify("Leviathan", "Gate unlocked!", 3)
        task.wait(2)
    else
        notify("Leviathan", "No gate found", 2)
    end
end

function AdvSea.FarmLeviathanScales()
    if not alive() then return end
    local scalesBefore = getScales()
    AdvSea.LeviathanFight()
    task.wait(2)
    local scalesAfter = getScales()
    local gained = scalesAfter - scalesBefore
    AdvSea.LeviathanStats.ScalesFarmed = AdvSea.LeviathanStats.ScalesFarmed + gained
    notify("Leviathan", "Farmed " .. tostring(gained) .. " scales", 2)
end

function AdvSea.LeviathanFullFarm()
    if not alive() then return end
    if sea() ~= 3 then
        notify("Leviathan Full Farm", "Must be in Third Sea!", 3)
        return
    end
    notify("Leviathan Full Farm", "Starting full Leviathan farm...", 3)
    AdvSea.LeviathanSearch()
    task.wait(2)
    local levi = getLeviathan()
    if levi then
        AdvSea.LeviathanTrack()
        AdvSea.LeviathanFight()
        AdvSea.LeviathanKill()
        AdvSea.ExtractLeviathanHeart()
        AdvSea.FarmLeviathanScales()
        AdvSea.LeviathanGateUnlock()
    else
        notify("Leviathan Full Farm", "No Leviathan found this cycle", 2)
    end
    notify("Leviathan Full Farm", "Cycle complete. Stats: Killed=" .. AdvSea.LeviathanStats.Killed .. " Hearts=" .. AdvSea.LeviathanStats.HeartsExtracted .. " Scales=" .. AdvSea.LeviathanStats.ScalesFarmed, 4)
end

--================================================================
-- MEGALODON SYSTEM
--================================================================

AdvSea.MegalodonStats = {
    Found = 0,
    Killed = 0,
    TeethFarmed = 0,
    Active = false,
}

function AdvSea.FindMegalodon()
    if not alive() then return nil end
    local megal = getMegalodon()
    if megal then
        AdvSea.MegalodonStats.Found = AdvSea.MegalodonStats.Found + 1
        return megal
    end
    local hrp = getHRP()
    if hrp then
        local scanPositions = {
            Vector3.new(-4305, 303, -1388),
            Vector3.new(-4560, 225, -800),
            Vector3.new(-4800, 10, -200),
            Vector3.new(-5100, 10, 300),
            Vector3.new(-4600, 10, 1200),
            Vector3.new(-3500, 10, 1800),
        }
        for _, pos in ipairs(scanPositions) do
            if not alive() then break end
            tweenTo(pos, 380)
            task.wait(2)
            megal = getMegalodon()
            if megal then
                AdvSea.MegalodonStats.Found = AdvSea.MegalodonStats.Found + 1
                return megal
            end
        end
    end
    return nil
end

function AdvSea.FightMegalodon()
    if not alive() then return end
    AdvSea.MegalodonStats.Active = true
    notify("Megalodon", "Starting fight...", 3)
    while AdvSea.MegalodonStats.Active and alive() do
        local megal = getMegalodon()
        if not megal then break end
        local hp = findFirstChild(megal, "Humanoid")
        if not hp or hp.Health <= 0 then break end
        killTarget(megal, 80)
        task.wait(0.2)
    end
    AdvSea.MegalodonStats.Active = false
end

function AdvSea.KillMegalodon()
    if not alive() then return end
    AdvSea.FightMegalodon()
    local megal = getMegalodon()
    if not megal then
        AdvSea.MegalodonStats.Killed = AdvSea.MegalodonStats.Killed + 1
        notify("Megalodon", "Killed!", 3)
    end
end

function AdvSea.FarmMegalodonTooth()
    if not alive() then return end
    local toothBefore = getMegalodonTooth()
    AdvSea.KillMegalodon()
    task.wait(2)
    local toothAfter = getMegalodonTooth()
    local gained = toothAfter - toothBefore
    AdvSea.MegalodonStats.TeethFarmed = AdvSea.MegalodonStats.TeethFarmed + gained
    notify("Megalodon", "Farmed " .. tostring(gained) .. " teeth", 2)
end

function AdvSea.MegalodonFullFarm()
    if not alive() then return end
    if sea() ~= 3 then
        notify("Megalodon Farm", "Must be in Third Sea!", 3)
        return
    end
    notify("Megalodon Full Farm", "Starting...", 3)
    local megal = AdvSea.FindMegalodon()
    if megal then
        AdvSea.FightMegalodon()
        AdvSea.KillMegalodon()
        AdvSea.FarmMegalodonTooth()
    else
        notify("Megalodon Full Farm", "No Megalodon found", 2)
    end
    notify("Megalodon Full Farm", "Done. Killed=" .. AdvSea.MegalodonStats.Killed .. " Teeth=" .. AdvSea.MegalodonStats.TeethFarmed, 3)
end

--================================================================
-- GHOST SHIP SYSTEM
--================================================================

AdvSea.GhostShipStats = {
    Found = 0,
    Killed = 0,
    LootFarmed = 0,
    FleetsCleared = 0,
    Active = false,
}

function AdvSea.FindGhostShip()
    if not alive() then return nil end
    local ship = getGhostShip()
    if ship then
        AdvSea.GhostShipStats.Found = AdvSea.GhostShipStats.Found + 1
        return ship
    end
    local hrp = getHRP()
    if hrp then
        local scanPositions = {
            Vector3.new(-4200, 303, -1300),
            Vector3.new(-4600, 225, -700),
            Vector3.new(-4900, 10, 0),
            Vector3.new(-5200, 10, 400),
            Vector3.new(-4800, 10, 1000),
            Vector3.new(-3800, 10, 1600),
        }
        for _, pos in ipairs(scanPositions) do
            if not alive() then break end
            tweenTo(pos, 370)
            task.wait(2)
            ship = getGhostShip()
            if ship then
                AdvSea.GhostShipStats.Found = AdvSea.GhostShipStats.Found + 1
                return ship
            end
        end
    end
    return nil
end

function AdvSea.FightGhostShip()
    if not alive() then return end
    AdvSea.GhostShipStats.Active = true
    notify("Ghost Ship", "Starting fight...", 3)
    while AdvSea.GhostShipStats.Active and alive() do
        local ship = getGhostShip()
        if not ship then break end
        local hp = findFirstChild(ship, "Humanoid")
        if hp and hp.Health <= 0 then break end
        local root = findFirstChild(ship, "HumanoidRootPart")
        if not root then
            root = ship.PrimaryPart
        end
        if root then
            killTarget(ship, 80)
        else
            local desc = getDescendants(ship)
            for _, v in ipairs(desc) do
                if v:IsA("BasePart") then
                    killTarget(v, 80)
                    break
                end
            end
        end
        task.wait(0.3)
    end
    AdvSea.GhostShipStats.Active = false
end

function AdvSea.KillGhostShip()
    if not alive() then return end
    AdvSea.FightGhostShip()
    local ship = getGhostShip()
    if not ship then
        AdvSea.GhostShipStats.Killed = AdvSea.GhostShipStats.Killed + 1
        notify("Ghost Ship", "Destroyed!", 3)
    end
end

function AdvSea.GhostShipFleetAnnihilation()
    if not alive() then return end
    notify("Ghost Fleet", "Clearing fleet...", 3)
    AdvSea.GhostShipStats.FleetsCleared = AdvSea.GhostShipStats.FleetsCleared + 1
    local cleared = 0
    while alive() do
        local ship = getGhostShip()
        if not ship then break end
        AdvSea.KillGhostShip()
        cleared = cleared + 1
        task.wait(1)
    end
    notify("Ghost Fleet", "Cleared " .. tostring(cleared) .. " ships", 3)
end

function AdvSea.FarmGhostShipLoot()
    if not alive() then return end
    local lootBefore = getGhostShipLoot()
    AdvSea.KillGhostShip()
    task.wait(2)
    local lootAfter = getGhostShipLoot()
    local gained = lootAfter - lootBefore
    AdvSea.GhostShipStats.LootFarmed = AdvSea.GhostShipStats.LootFarmed + gained
    notify("Ghost Ship", "Farmed " .. tostring(gained) .. " loot", 2)
end

--================================================================
-- PIRANHA SYSTEM
--================================================================

AdvSea.PiranhaStats = {
    Killed = 0,
    WavesCleared = 0,
    Active = false,
}

function AdvSea.KillPiranha()
    if not alive() then return end
    AdvSea.PiranhaStats.Active = true
    local piranhas = getPiranhas()
    for _, pir in ipairs(piranhas) do
        if not alive() or not AdvSea.PiranhaStats.Active then break end
        local hp = findFirstChild(pir, "Humanoid")
        if hp and hp.Health > 0 then
            killTarget(pir, 60)
            AdvSea.PiranhaStats.Killed = AdvSea.PiranhaStats.Killed + 1
        end
    end
    AdvSea.PiranhaStats.Active = false
end

function AdvSea.PiranhaWaveClear()
    if not alive() then return end
    notify("Piranha", "Clearing wave...", 2)
    AdvSea.PiranhaStats.WavesCleared = AdvSea.PiranhaStats.WavesCleared + 1
    local maxWaves = 10
    for wave = 1, maxWaves do
        if not alive() then break end
        local piranhas = getPiranhas()
        if #piranhas == 0 then break end
        AdvSea.KillPiranha()
        task.wait(1)
    end
    notify("Piranha", "Wave cleared", 2)
end

function AdvSea.PiranhaFullFarm()
    if not alive() then return end
    if sea() ~= 3 then
        notify("Piranha Farm", "Must be in Third Sea!", 3)
        return
    end
    notify("Piranha Full Farm", "Starting...", 3)
    AdvSea.PiranhaWaveClear()
    task.wait(2)
    local piranhas = getPiranhas()
    while #piranhas > 0 and alive() do
        AdvSea.KillPiranha()
        task.wait(1)
        piranhas = getPiranhas()
    end
    notify("Piranha Full Farm", "Done. Killed=" .. AdvSea.PiranhaStats.Killed .. " Waves=" .. AdvSea.PiranhaStats.WavesCleared, 3)
end

--================================================================
-- SEA NAVIGATION
--================================================================

AdvSea.NavigationStats = {
    EventsTriggered = 0,
    SeaBeastsKilled = 0,
    DangerLevel = 0,
    Active = false,
}

function AdvSea.AutoSailToDanger(level)
    if not alive() then return end
    level = math.clamp(level or 5, 1, 6)
    AdvSea.NavigationStats.DangerLevel = level
    AdvSea.NavigationStats.Active = true
    notify("Sea Navigation", "Sailing to Danger Level " .. tostring(level), 3)
    local hrp = getHRP()
    if not hrp then return end
    local sailPositions = {
        [1] = Vector3.new(-1557, 24, 1960),
        [2] = Vector3.new(-2100, 10, 2400),
        [3] = Vector3.new(-2800, 10, 2700),
        [4] = Vector3.new(-3500, 10, 3000),
        [5] = Vector3.new(-4300, 10, 3200),
        [6] = Vector3.new(-5000, 10, 3500),
    }
    local target = sailPositions[level]
    if target then
        tweenTo(target, 350)
        task.wait(5)
        setDangerLevel(level)
        task.wait(2)
    end
    notify("Sea Navigation", "Arrived at Danger Level " .. tostring(level), 2)
    AdvSea.NavigationStats.Active = false
end

function AdvSea.AutoSpawnSeaEvents()
    if not alive() then return end
    AdvSea.NavigationStats.EventsTriggered = AdvSea.NavigationStats.EventsTriggered + 1
    notify("Sea Events", "Spawning sea events...", 2)
    AdvSea.AutoSailToDanger(5)
    task.wait(3)
    local hrp = getHRP()
    if hrp then
        local wanderPositions = {
            Vector3.new(-4500, 10, 3300),
            Vector3.new(-4200, 10, 3100),
            Vector3.new(-4800, 10, 3500),
            Vector3.new(-4100, 10, 2900),
            Vector3.new(-4600, 10, 3400),
        }
        for _, pos in ipairs(wanderPositions) do
            if not alive() then break end
            tweenTo(pos, 300)
            task.wait(3)
            local beasts = getSeaBeasts()
            local megal = getMegalodon()
            local ghost = getGhostShip()
            local pira = getPiranhas()
            if #beasts > 0 or megal or ghost or #pira > 0 then
                notify("Sea Events", "Event spawned!", 3)
                break
            end
        end
    end
end

function AdvSea.SeaEventsEvade()
    if not alive() then return end
    local hrp = getHRP()
    if not hrp then return end
    local currentPos = hrp.Position
    local evadeOffset = Vector3.new(math.random(-200, 200), 0, math.random(-200, 200))
    tweenTo(currentPos + evadeOffset, 400)
    task.wait(1)
end

function AdvSea.MultiSeaBeastFarm()
    if not alive() then return end
    notify("Multi Sea Beast", "Farming all sea beasts...", 3)
    AdvSea.NavigationStats.Active = true
    while AdvSea.NavigationStats.Active and alive() do
        local beasts = getSeaBeasts()
        if #beasts == 0 then break end
        for _, beast in ipairs(beasts) do
            if not alive() or not AdvSea.NavigationStats.Active then break end
            local hp = findFirstChild(beast, "Humanoid")
            if hp and hp.Health > 0 then
                killTarget(beast, 120)
                AdvSea.NavigationStats.SeaBeastsKilled = AdvSea.NavigationStats.SeaBeastsKilled + 1
            end
        end
        task.wait(0.5)
    end
    AdvSea.NavigationStats.Active = false
    notify("Multi Sea Beast", "All beasts eliminated", 2)
end

function AdvSea.SeaEventTracker()
    local status = {
        SeaBeasts = #getSeaBeasts(),
        Megalodon = getMegalodon() ~= nil,
        GhostShip = getGhostShip() ~= nil,
        Piranhas = #getPiranhas(),
        DangerLevel = getDangerLevel(),
    }
    return status
end

function AdvSea.GetSeaEventStatus()
    local status = AdvSea.SeaEventTracker()
    local report = "=== Sea Event Status ===\n"
    report = report .. "Danger Level: " .. tostring(status.DangerLevel) .. "\n"
    report = report .. "Sea Beasts: " .. tostring(status.SeaBeasts) .. "\n"
    report = report .. "Megalodon: " .. tostring(status.Megalodon) .. "\n"
    report = report .. "Ghost Ship: " .. tostring(status.GhostShip) .. "\n"
    report = report .. "Piranhas: " .. tostring(status.Piranhas) .. "\n"
    report = report .. "Events Triggered: " .. tostring(AdvSea.NavigationStats.EventsTriggered) .. "\n"
    report = report .. "Beasts Killed: " .. tostring(AdvSea.NavigationStats.SeaBeastsKilled)
    notify("Sea Status", report, 5)
    return status
end

--================================================================
-- MIRAGE ISLAND
--================================================================

AdvSea.MirageStats = {
    Found = 0,
    GearsCollected = 0,
    ResonanceActivated = 0,
    Active = false,
}

function AdvSea.FindMirageIsland()
    if not alive() then return nil end
    if sea() ~= 3 then
        notify("Mirage", "Must be in Third Sea!", 3)
        return nil
    end
    local mirage = getMirageIsland()
    if mirage then
        AdvSea.MirageStats.Found = AdvSea.MirageStats.Found + 1
        return mirage
    end
    local hrp = getHRP()
    if hrp then
        local scanPositions = {
            Vector3.new(-4500, 10, -1200),
            Vector3.new(-5000, 10, -500),
            Vector3.new(-5300, 10, 300),
            Vector3.new(-4900, 10, 1000),
            Vector3.new(-4200, 10, 1600),
            Vector3.new(-3400, 10, 2000),
            Vector3.new(-2500, 10, 2300),
        }
        for _, pos in ipairs(scanPositions) do
            if not alive() then break end
            tweenTo(pos, 400)
            task.wait(3)
            mirage = getMirageIsland()
            if mirage then
                AdvSea.MirageStats.Found = AdvSea.MirageStats.Found + 1
                notify("Mirage", "Mirage Island found!", 3)
                return mirage
            end
        end
    end
    notify("Mirage", "Mirage Island not found", 2)
    return nil
end

function AdvSea.TeleportMirage()
    if not alive() then return end
    local mirage = getMirageIsland()
    if not mirage then
        notify("Mirage", "No Mirage Island found", 2)
        return
    end
    local pos = mirage:GetPivot().Position
    tpTo(pos, 10)
    notify("Mirage", "Teleported to Mirage Island", 2)
end

function AdvSea.TeleportMirageHighest()
    if not alive() then return end
    local mirage = getMirageIsland()
    if not mirage then
        notify("Mirage", "No Mirage Island found", 2)
        return
    end
    local highest = nil
    local maxY = -math.huge
    local desc = getDescendants(mirage)
    for _, v in ipairs(desc) do
        if v:IsA("BasePart") then
            if v.Position.Y > maxY then
                maxY = v.Position.Y
                highest = v
            end
        end
    end
    if highest then
        tpTo(highest.Position + Vector3.new(0, 10, 0), 10)
        notify("Mirage", "Teleported to highest point", 2)
    end
end

function AdvSea.FindBlueGear()
    if not alive() then return nil end
    local gear = getBlueGear()
    if gear then
        AdvSea.MirageStats.GearsCollected = AdvSea.MirageStats.GearsCollected + 1
        return gear
    end
    local mirage = getMirageIsland()
    if not mirage then return nil end
    local desc = getDescendants(mirage)
    for _, v in ipairs(desc) do
        if v:IsA("BasePart") and (string.find(v.Name, "Gear") or string.find(v.Name, "gear")) then
            AdvSea.MirageStats.GearsCollected = AdvSea.MirageStats.GearsCollected + 1
            return v
        end
    end
    return nil
end

function AdvSea.AutoMoonAlign()
    if not alive() then return end
    notify("Mirage", "Aligning with moon...", 3)
    local result, moonCFrame = safe(function()
        local lightning = Lighting
        local moon = findFirstChild(lightning, "Moon")
        if moon then return true, moon.CFrame end
        return false, nil
    end)
    if result and moonCFrame then
        notify("Mirage", "Moon aligned", 2)
    else
        task.wait(10)
        notify("Mirage", "Moon alignment attempted", 2)
    end
end

function AdvSea.AutoResonance()
    if not alive() then return end
    notify("Mirage", "Activating resonance...", 3)
    local gear = AdvSea.FindBlueGear()
    if gear then
        tpTo(gear.Position, 5)
        task.wait(1)
        safe(commF, "activateResonance")
        AdvSea.MirageStats.ResonanceActivated = AdvSea.MirageStats.ResonanceActivated + 1
        notify("Mirage", "Resonance activated!", 3)
    else
        notify("Mirage", "No blue gear found", 2)
    end
end

function AdvSea.MirageFullFarm()
    if not alive() then return end
    if sea() ~= 3 then
        notify("Mirage Full Farm", "Must be in Third Sea!", 3)
        return
    end
    AdvSea.MirageStats.Active = true
    notify("Mirage Full Farm", "Starting...", 3)
    local mirage = AdvSea.FindMirageIsland()
    if mirage then
        AdvSea.TeleportMirage()
        task.wait(2)
        AdvSea.TeleportMirageHighest()
        task.wait(1)
        AdvSea.FindBlueGear()
        task.wait(1)
        AdvSea.AutoMoonAlign()
        task.wait(1)
        AdvSea.AutoResonance()
    else
        notify("Mirage Full Farm", "No Mirage Island available", 2)
    end
    AdvSea.MirageStats.Active = false
    notify("Mirage Full Farm", "Done. Found=" .. AdvSea.MirageStats.Found .. " Gears=" .. AdvSea.MirageStats.GearsCollected .. " Resonance=" .. AdvSea.MirageStats.ResonanceActivated, 3)
end

--================================================================
-- PIRATE RAID
--================================================================

AdvSea.PirateRaidStats = {
    Cleared = 0,
    LootCollected = 0,
    Active = false,
}

function AdvSea.AutoPirateRaid()
    if not alive() then return end
    if sea() ~= 3 then
        notify("Pirate Raid", "Must be in Third Sea!", 3)
        return
    end
    AdvSea.PirateRaidStats.Active = true
    notify("Pirate Raid", "Starting auto pirate raid...", 3)
    local hrp = getHRP()
    if not hrp then return end
    tweenTo(Vector3.new(-2670, 50, 4570), 350)
    task.wait(5)
    local raidFolder = getPirateRaidFolder()
    if raidFolder then
        while AdvSea.PirateRaidStats.Active and alive() do
            local desc = getDescendants(raidFolder)
            local enemies = {}
            for _, v in ipairs(desc) do
                local hp = findFirstChild(v, "Humanoid")
                if hp and hp.Health > 0 then
                    table.insert(enemies, v)
                end
            end
            if #enemies == 0 then break end
            for _, enemy in ipairs(enemies) do
                if not alive() or not AdvSea.PirateRaidStats.Active then break end
                killTarget(enemy, 80)
                task.wait(0.15)
            end
            task.wait(0.5)
        end
        AdvSea.PirateRaidStats.Cleared = AdvSea.PirateRaidStats.Cleared + 1
        notify("Pirate Raid", "Raid cleared!", 3)
    else
        notify("Pirate Raid", "No raid detected", 2)
    end
    AdvSea.PirateRaidStats.Active = false
end

function AdvSea.PirateRaidClear()
    if not alive() then return end
    AdvSea.AutoPirateRaid()
end

function AdvSea.PirateRaidLoot()
    if not alive() then return end
    local hrp = getHRP()
    if not hrp then return end
    local raidFolder = getPirateRaidFolder()
    if raidFolder then
        local desc = getDescendants(raidFolder)
        for _, v in ipairs(desc) do
            if v:IsA("BasePart") and (string.find(v.Name, "Loot") or string.find(v.Name, "Chest") or string.find(v.Name, "Drop")) then
                tpTo(v.Position, 5)
                task.wait(0.5)
                AdvSea.PirateRaidStats.LootCollected = AdvSea.PirateRaidStats.LootCollected + 1
            end
        end
    end
    notify("Pirate Raid", "Loot collected: " .. tostring(AdvSea.PirateRaidStats.LootCollected), 2)
end

--================================================================
-- FACTORY RAID
--================================================================

AdvSea.FactoryRaidStats = {
    Completed = 0,
    Snipes = 0,
    Active = false,
}

function AdvSea.AutoFactoryRaid()
    if not alive() then return end
    if sea() ~= 2 then
        notify("Factory Raid", "Must be in Second Sea!", 3)
        return
    end
    AdvSea.FactoryRaidStats.Active = true
    notify("Factory Raid", "Starting auto factory raid...", 3)
    local hrp = getHRP()
    if not hrp then return end
    tweenTo(Vector3.new(923, 96, 3285), 350)
    task.wait(5)
    local factoryFolder = getFactoryRaidFolder()
    if factoryFolder then
        while AdvSea.FactoryRaidStats.Active and alive() do
            local desc = getDescendants(factoryFolder)
            local enemies = {}
            for _, v in ipairs(desc) do
                local hp = findFirstChild(v, "Humanoid")
                if hp and hp.Health > 0 then
                    table.insert(enemies, v)
                end
            end
            if #enemies == 0 then break end
            for _, enemy in ipairs(enemies) do
                if not alive() or not AdvSea.FactoryRaidStats.Active then break end
                killTarget(enemy, 80)
                task.wait(0.15)
            end
            task.wait(0.5)
        end
        AdvSea.FactoryRaidStats.Completed = AdvSea.FactoryRaidStats.Completed + 1
        notify("Factory Raid", "Factory cleared!", 3)
    else
        notify("Factory Raid", "No factory detected", 2)
    end
    AdvSea.FactoryRaidStats.Active = false
end

function AdvSea.FactoryRaidSnipe()
    if not alive() then return end
    if sea() ~= 2 then return end
    AdvSea.FactoryRaidStats.Snipes = AdvSea.FactoryRaidStats.Snipes + 1
    notify("Factory Snipe", "Sniping factory core...", 2)
    local hrp = getHRP()
    if not hrp then return end
    local factoryFolder = getFactoryRaidFolder()
    if factoryFolder then
        local desc = getDescendants(factoryFolder)
        for _, v in ipairs(desc) do
            if v:IsA("BasePart") and (string.find(v.Name, "Core") or string.find(v.Name, "core") or string.find(v.Name, "Lever")) then
                tpTo(v.Position, 5)
                task.wait(1)
                break
            end
        end
    end
end

function AdvSea.FactoryRaidComplete()
    if not alive() then return end
    AdvSea.AutoFactoryRaid()
    AdvSea.FactoryRaidSnipe()
    notify("Factory Raid", "Completed. Total=" .. tostring(AdvSea.FactoryRaidStats.Completed) .. " Snipes=" .. tostring(AdvSea.FactoryRaidStats.Snipes), 3)
end

--================================================================
-- CASTLE DEFENSE
--================================================================

AdvSea.CastleDefenseStats = {
    Cleared = 0,
    Active = false,
}

function AdvSea.AutoCastleDefense()
    if not alive() then return end
    if sea() ~= 3 then
        notify("Castle Defense", "Must be in Third Sea!", 3)
        return
    end
    AdvSea.CastleDefenseStats.Active = true
    notify("Castle Defense", "Defending castle...", 3)
    local hrp = getHRP()
    if not hrp then return end
    tweenTo(Vector3.new(-2860, 90, -5060), 350)
    task.wait(5)
    local castleFolder = getCastleFolder()
    if castleFolder then
        while AdvSea.CastleDefenseStats.Active and alive() do
            local desc = getDescendants(castleFolder)
            local enemies = {}
            for _, v in ipairs(desc) do
                local hp = findFirstChild(v, "Humanoid")
                if hp and hp.Health > 0 then
                    table.insert(enemies, v)
                end
            end
            if #enemies == 0 then break end
            for _, enemy in ipairs(enemies) do
                if not alive() or not AdvSea.CastleDefenseStats.Active then break end
                killTarget(enemy, 100)
                task.wait(0.15)
            end
            task.wait(0.5)
        end
        AdvSea.CastleDefenseStats.Cleared = AdvSea.CastleDefenseStats.Cleared + 1
        notify("Castle Defense", "Castle defended!", 3)
    else
        notify("Castle Defense", "No defense event", 2)
    end
    AdvSea.CastleDefenseStats.Active = false
end

function AdvSea.CastleDefenseClear()
    if not alive() then return end
    AdvSea.AutoCastleDefense()
end

--================================================================
-- MOB SPAWN COUNTER
--================================================================

AdvSea.SpawnCounterData = {
    DisplayActive = false,
}

function AdvSea.GetMobSpawnCounter(mobType)
    mobType = mobType or ""
    local count = 0
    local ws = getChildren(workspace)
    for _, v in ipairs(ws) do
        if mobType == "" or string.find(v.Name, mobType) then
            local hp = findFirstChild(v, "Humanoid")
            if hp and hp.Health > 0 then
                count = count + 1
            end
        end
    end
    return count
end

function AdvSea.DisplaySpawnCounter()
    if not alive() then return end
    AdvSea.SpawnCounterData.DisplayActive = true
    notify("Spawn Counter", "Displaying counters...", 3)
    local types = {"Katakuri", "DoughKing", "Leviathan", "Megalodon", "Piranha"}
    while AdvSea.SpawnCounterData.DisplayActive and alive() do
        local report = ""
        for _, t in ipairs(types) do
            local c = AdvSea.GetMobSpawnCounter(t)
            report = report .. t .. ": " .. tostring(c) .. "  "
        end
        notify("Spawn Counter", report, 3)
        task.wait(5)
    end
end

function AdvSea.KatakuriCounter()
    local count = AdvSea.GetMobSpawnCounter("Katakuri")
    notify("Katakuri Counter", "Katakuri mobs: " .. tostring(count), 3)
    return count
end

function AdvSea.DoughKingCounter()
    local count = AdvSea.GetMobSpawnCounter("DoughKing")
    notify("Dough King Counter", "Dough King mobs: " .. tostring(count), 3)
    return count
end

--================================================================
-- STAT PRINT
--================================================================

function AdvSea.PrintStats()
    local report = "=== Advanced Sea Stats ===\n"
    report = report .. "-- Leviathan --\n"
    report = report .. "  Searched: " .. tostring(AdvSea.LeviathanStats.Searched) .. "\n"
    report = report .. "  Fought: " .. tostring(AdvSea.LeviathanStats.Fought) .. "\n"
    report = report .. "  Killed: " .. tostring(AdvSea.LeviathanStats.Killed) .. "\n"
    report = report .. "  Hearts: " .. tostring(AdvSea.LeviathanStats.HeartsExtracted) .. "\n"
    report = report .. "  Scales: " .. tostring(AdvSea.LeviathanStats.ScalesFarmed) .. "\n"
    report = report .. "  Gates: " .. tostring(AdvSea.LeviathanStats.GatesUnlocked) .. "\n"
    report = report .. "-- Megalodon --\n"
    report = report .. "  Found: " .. tostring(AdvSea.MegalodonStats.Found) .. "\n"
    report = report .. "  Killed: " .. tostring(AdvSea.MegalodonStats.Killed) .. "\n"
    report = report .. "  Teeth: " .. tostring(AdvSea.MegalodonStats.TeethFarmed) .. "\n"
    report = report .. "-- Ghost Ship --\n"
    report = report .. "  Found: " .. tostring(AdvSea.GhostShipStats.Found) .. "\n"
    report = report .. "  Killed: " .. tostring(AdvSea.GhostShipStats.Killed) .. "\n"
    report = report .. "  Loot: " .. tostring(AdvSea.GhostShipStats.LootFarmed) .. "\n"
    report = report .. "  Fleets: " .. tostring(AdvSea.GhostShipStats.FleetsCleared) .. "\n"
    report = report .. "-- Piranha --\n"
    report = report .. "  Killed: " .. tostring(AdvSea.PiranhaStats.Killed) .. "\n"
    report = report .. "  Waves: " .. tostring(AdvSea.PiranhaStats.WavesCleared) .. "\n"
    report = report .. "-- Navigation --\n"
    report = report .. "  Events: " .. tostring(AdvSea.NavigationStats.EventsTriggered) .. "\n"
    report = report .. "  Beasts Killed: " .. tostring(AdvSea.NavigationStats.SeaBeastsKilled) .. "\n"
    report = report .. "-- Mirage --\n"
    report = report .. "  Found: " .. tostring(AdvSea.MirageStats.Found) .. "\n"
    report = report .. "  Gears: " .. tostring(AdvSea.MirageStats.GearsCollected) .. "\n"
    report = report .. "  Resonance: " .. tostring(AdvSea.MirageStats.ResonanceActivated) .. "\n"
    report = report .. "-- Pirate Raid --\n"
    report = report .. "  Cleared: " .. tostring(AdvSea.PirateRaidStats.Cleared) .. "\n"
    report = report .. "  Loot: " .. tostring(AdvSea.PirateRaidStats.LootCollected) .. "\n"
    report = report .. "-- Factory Raid --\n"
    report = report .. "  Completed: " .. tostring(AdvSea.FactoryRaidStats.Completed) .. "\n"
    report = report .. "  Snipes: " .. tostring(AdvSea.FactoryRaidStats.Snipes) .. "\n"
    report = report .. "-- Castle Defense --\n"
    report = report .. "  Cleared: " .. tostring(AdvSea.CastleDefenseStats.Cleared)
    notify("Full Stats", report, 8)
    return report
end

--================================================================
-- MAIN LOOP + START/STOP
--================================================================

AdvSea._mainConnection = nil
AdvSea._running = false

local function mainLoop()
    if not alive() then return end
    local se = sea()
    if se == 3 then
        local beasts = getSeaBeasts()
        local megal = getMegalodon()
        local ghost = getGhostShip()
        local pira = getPiranhas()
        local levi = getLeviathan()
        if flags.AutoSeaBeast and #beasts > 0 then
            for _, b in ipairs(beasts) do
                if alive() and flags.AutoSeaBeast then
                    killTarget(b, 120)
                    task.wait(0.3)
                end
            end
        end
        if flags.AutoMegalodon and megal then
            killTarget(megal, 80)
        end
        if flags.AutoGhostShip and ghost then
            killTarget(ghost, 80)
        end
        if flags.AutoPiranha and #pira > 0 then
            for _, p in ipairs(pira) do
                if alive() and flags.AutoPiranha then
                    killTarget(p, 60)
                    task.wait(0.2)
                end
            end
        end
        if flags.AutoLeviathan and levi then
            local hp = findFirstChild(levi, "Humanoid")
            if hp and hp.Health > 0 then
                killTarget(levi, 80)
            end
        end
    end
end

function AdvSea.Start()
    if AdvSea._running then return end
    AdvSea._running = true
    flags.AutoSeaBeast = false
    flags.AutoMegalodon = false
    flags.AutoGhostShip = false
    flags.AutoPiranha = false
    flags.AutoLeviathan = false
    AdvSea._mainConnection = RunService.Heartbeat:Connect(function()
        safe(mainLoop)
    end)
    notify("AdvSea", "Advanced Sea module started", 2)
end

function AdvSea.Stop()
    AdvSea._running = false
    AdvSea.LeviathanStats.SearchActive = false
    AdvSea.LeviathanStats.TrackingActive = false
    AdvSea.LeviathanStats.FightActive = false
    AdvSea.MegalodonStats.Active = false
    AdvSea.GhostShipStats.Active = false
    AdvSea.PiranhaStats.Active = false
    AdvSea.NavigationStats.Active = false
    AdvSea.MirageStats.Active = false
    AdvSea.PirateRaidStats.Active = false
    AdvSea.FactoryRaidStats.Active = false
    AdvSea.CastleDefenseStats.Active = false
    AdvSea.SpawnCounterData.DisplayActive = false
    if AdvSea._mainConnection then
        pcall(function() AdvSea._mainConnection:Disconnect() end)
        AdvSea._mainConnection = nil
    end
    for k, _ in pairs(flags) do
        flags[k] = false
    end
    notify("AdvSea", "Advanced Sea module stopped", 2)
end

function AdvSea.Toggle()
    if AdvSea._running then
        AdvSea.Stop()
    else
        AdvSea.Start()
    end
    return AdvSea._running
end

function AdvSea.SetFlag(name, value)
    flags[name] = value
end

function AdvSea.GetFlags()
    local f = {}
    for k, v in pairs(flags) do
        f[k] = v
    end
    return f
end

--================================================================
-- CLEANUP
--================================================================

function AdvSea.Cleanup()
    AdvSea.Stop()
    for name, conn in pairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    connections = {}
    notify("AdvSea", "Cleanup complete", 2)
end

--================================================================
-- REGISTER
--================================================================

if A.Register then
    A.Register("advanced_sea", AdvSea)
end

A.AdvSea = AdvSea
_G.Apex = A

return AdvSea
