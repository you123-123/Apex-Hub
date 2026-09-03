local A = _G.Apex
local Dungeon = {}
Dungeon.Active = false
Dungeon.DungeonsCleared = 0
Dungeon.KeyFragment = 0
Dungeon.DungeonRewards = {}
Dungeon._loop = nil
Dungeon._startTick = 0
Dungeon._inDungeon = false
Dungeon._currentFloor = 0
Dungeon._dungeonTimer = 0
Dungeon._dungeonMaxTime = 600
Dungeon._enemies = {}
Dungeon._bossFound = false
Dungeon._puzzlesSolved = 0
Dungeon._roomsCleared = 0
Dungeon._totalRooms = 0
Dungeon._currentRoom = nil
Dungeon._roomQueue = {}
Dungeon._clearedRooms = {}
Dungeon._lootCollected = 0
Dungeon._damageDealt = 0
Dungeon._keysUsed = 0
Dungeon._puzzleTypes = {}
Dungeon._lastReward = nil
Dungeon._autoRun = false
Dungeon._safeThreshold = 0.3

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local DUNGEON_ROOMS = {"StartRoom", "EnemyRoom", "PuzzleRoom", "BossRoom", "LootRoom", "TrapRoom", "ShopRoom", "RestRoom"}
local PUZZLE_TYPES = {"PressurePlate", "Memory", "SimonSays", "Pattern", "Code", "Timing"}
local BOSS_NAMES = {"DungeonBoss", "SkeletonBoss", "CursedBoss", "ShadowBoss", "DemonBoss", "UndeadBoss"}
local DUNGEON_ENEMIES = {"Skeleton", "Ghost", "Zombie", "Demon", "Shadow", "Cursed", "Undead"}

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Apex Dungeon] Error: " .. tostring(err))
    end
    return ok, err
end

function Dungeon.GetDungeonKey()
    local lp = A.LP
    if not lp then return 0 end
    local backpack = lp:FindFirstChild("Backpack")
    if backpack then
        local key = backpack:FindFirstChild("DungeonKey") or backpack:FindFirstChild("Key")
        if key then return 1 end
    end
    if lp.Character then
        local key = lp.Character:FindFirstChild("DungeonKey") or lp.Character:FindFirstChild("Key")
        if key then return 1 end
    end
    local keysVal = lp:FindFirstChild("DungeonKeys") or lp:FindFirstChild("Keys")
    if keysVal and keysVal:IsA("ValueBase") then
        return tonumber(keysVal.Value) or 0
    end
    return Dungeon.KeyFragment
end

function Dungeon.IsInDungeon()
    local lp = A.LP
    if not lp then return false end
    local char = lp.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local pos = hrp.Position
    local dungeonZones = Workspace:FindFirstChild("Dungeon") or Workspace:FindFirstChild("Dungeons")
    if dungeonZones then
        Dungeon._inDungeon = true
        return true
    end
    if pos.Y < -500 or pos.Y > 500 then
        Dungeon._inDungeon = true
        return true
    end
    for _, child in ipairs(Workspace:GetChildren()) do
        if string.find(string.lower(child.Name), "dungeon") and child:IsA("Folder") then
            Dungeon._inDungeon = true
            return true
        end
    end
    Dungeon._inDungeon = false
    return false
end

function Dungeon.GetDungeonFloor()
    local lp = A.LP
    if not lp then return 0 end
    local floorVal = lp:FindFirstChild("DungeonFloor") or lp:FindFirstChild("Floor")
    if floorVal and floorVal:IsA("ValueBase") then
        Dungeon._currentFloor = tonumber(floorVal.Value) or 0
        return Dungeon._currentFloor
    end
    return Dungeon._currentFloor
end

function Dungeon.GetDungeonTimer()
    local elapsed = tick() - Dungeon._dungeonTimer
    local remaining = Dungeon._dungeonMaxTime - elapsed
    if remaining < 0 then remaining = 0 end
    local minutes = math.floor(remaining / 60)
    local seconds = math.floor(remaining % 60)
    return {
        Elapsed = math.floor(elapsed),
        Remaining = math.floor(remaining),
        Display = string.format("%dm %ds", minutes, seconds),
        Expired = remaining <= 0
    }
end

function Dungeon.GetDungeonEnemies()
    local enemies = {}
    local dungeon = Workspace:FindFirstChild("Dungeon") or Workspace:FindFirstChild("Dungeons")
    if not dungeon then
        for _, child in ipairs(Workspace:GetChildren()) do
            if string.find(string.lower(child.Name), "dungeon") then
                dungeon = child
                break
            end
        end
    end
    if not dungeon then return enemies end
    local enemyFolder = dungeon:FindFirstChild("Enemies") or dungeon:FindFirstChild("Mobs")
    if enemyFolder then
        for _, mob in ipairs(enemyFolder:GetChildren()) do
            if mob:IsA("Model") then
                local hum = mob:FindFirstChild("Humanoid")
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    table.insert(enemies, {
                        Model = mob,
                        Health = hum.Health,
                        MaxHealth = hum.MaxHealth,
                        Position = hrp.Position,
                        Name = mob.Name,
                        Distance = A.HRP() and (A.HRP().Position - hrp.Position).Magnitude or math.huge
                    })
                end
            end
        end
    end
    for _, child in ipairs(dungeon:GetDescendants()) do
        if child:IsA("Model") then
            local hum = child:FindFirstChild("Humanoid")
            local hrp = child:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 and child ~= Players.LocalPlayer.Character then
                local isEnemy = false
                for _, ename in ipairs(DUNGEON_ENEMIES) do
                    if string.find(string.lower(child.Name), string.lower(ename)) then
                        isEnemy = true
                        break
                    end
                end
                if isEnemy then
                    local alreadyAdded = false
                    for _, e in ipairs(enemies) do
                        if e.Model == child then
                            alreadyAdded = true
                            break
                        end
                    end
                    if not alreadyAdded then
                        table.insert(enemies, {
                            Model = child,
                            Health = hum.Health,
                            MaxHealth = hum.MaxHealth,
                            Position = hrp.Position,
                            Name = child.Name,
                            Distance = A.HRP() and (A.HRP().Position - hrp.Position).Magnitude or math.huge
                        })
                    end
                end
            end
        end
    end
    table.sort(enemies, function(a, b) return a.Distance < b.Distance end)
    Dungeon._enemies = enemies
    return enemies
end

function Dungeon.FindDungeonBoss()
    local dungeon = Workspace:FindFirstChild("Dungeon") or Workspace:FindFirstChild("Dungeons")
    if not dungeon then return nil end
    for _, child in ipairs(dungeon:GetDescendants()) do
        if child:IsA("Model") then
            for _, bossName in ipairs(BOSS_NAMES) do
                if string.find(string.lower(child.Name), string.lower(bossName)) then
                    local hum = child:FindFirstChild("Humanoid")
                    local hrp = child:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 0 then
                        Dungeon._bossFound = true
                        return child
                    end
                end
            end
        end
    end
    Dungeon._bossFound = false
    return nil
end

function Dungeon.KillDungeonEnemies()
    local enemies = Dungeon.GetDungeonEnemies()
    if #enemies == 0 then return false end
    for _, enemyData in ipairs(enemies) do
        if enemyData.Model and enemyData.Model.Parent then
            local hum = enemyData.Model:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                A.SuperAttack(enemyData.Model)
                return true
            end
        end
    end
    return false
end

function Dungeon.KillDungeonBoss()
    local boss = Dungeon.FindDungeonBoss()
    if not boss then return false end
    local maxAttempts = 120
    local attempts = 0
    while boss and boss.Parent and Dungeon.Active do
        attempts = attempts + 1
        if attempts > maxAttempts then break end
        local hum = boss:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then
            A.Notify("Dungeon", "Boss defeated!", 3)
            return true
        end
        local hrp = boss:FindFirstChild("HumanoidRootPart")
        if hrp then
            local myHRP = A.HRP()
            if myHRP then
                local dist = (myHRP.Position - hrp.Position).Magnitude
                if dist > 200 then
                    A.TpTo(hrp.Position, 100)
                elseif dist > 50 then
                    A.TweenTo(hrp.Position, 200)
                end
            end
        end
        A.SuperAttack(boss)
        task.wait(0.2)
    end
    return false
end

function Dungeon.FindPuzzleRoom()
    local dungeon = Workspace:FindFirstChild("Dungeon") or Workspace:FindFirstChild("Dungeons")
    if not dungeon then return nil end
    for _, child in ipairs(dungeon:GetDescendants()) do
        if child:IsA("Model") then
            for _, puzzleType in ipairs(PUZZLE_TYPES) do
                if string.find(string.lower(child.Name), string.lower(puzzleType)) then
                    return child
                end
            end
            if string.find(string.lower(child.Name), "puzzle") then
                return child
            end
        end
    end
    return nil
end

function Dungeon.SolvePuzzle()
    local puzzle = Dungeon.FindPuzzleRoom()
    if not puzzle then return false end
    local myHRP = A.HRP()
    if not myHRP then return false end
    local puzzlePart = puzzle:FindFirstChildWhichIsA("BasePart") or puzzle.PrimaryPart
    if not puzzlePart then return false end
    local dist = (myHRP.Position - puzzlePart.Position).Magnitude
    if dist > 50 then
        A.TpTo(puzzlePart.Position + Vector3.new(0, 5, 0), 100)
        return true
    end
    for _, child in ipairs(puzzle:GetDescendants()) do
        if child:IsA("BasePart") then
            local clickDetector = child:FindFirstChildWhichIsA("ClickDetector")
            if clickDetector then
                pcall(function()
                    clickDetector:Click()
                end)
            end
            local proximityPrompt = child:FindFirstChildWhichIsA("ProximityPrompt")
            if proximityPrompt then
                pcall(function()
                    proximityPrompt:InputHoldBegin()
                    task.wait(0.5)
                    proximityPrompt:InputHoldEnd()
                end)
            end
        end
    end
    Dungeon._puzzlesSolved = Dungeon._puzzlesSolved + 1
    A.Notify("Puzzle", "Solved puzzle #" .. tostring(Dungeon._puzzlesSolved), 2)
    return true
end

function Dungeon.CollectLoot()
    local dungeon = Workspace:FindFirstChild("Dungeon") or Workspace:FindFirstChild("Dungeons")
    if not dungeon then return end
    local myHRP = A.HRP()
    if not myHRP then return end
    for _, child in ipairs(dungeon:GetDescendants()) do
        if child:IsA("Tool") or child:IsA("BasePart") then
            if string.find(string.lower(child.Name), "loot") or
                string.find(string.lower(child.Name), "reward") or
                string.find(string.lower(child.Name), "drop") then
                local pos = child:IsA("BasePart") and child.Position or (child.PrimaryPart and child.PrimaryPart.Position)
                if pos then
                    local dist = (myHRP.Position - pos).Magnitude
                    if dist < 200 then
                        A.TpTo(pos, 50)
                        task.wait(0.5)
                        Dungeon._lootCollected = Dungeon._lootCollected + 1
                    end
                end
            end
        end
    end
end

function Dungeon.NavigateDungeon()
    local dungeon = Workspace:FindFirstChild("Dungeon") or Workspace:FindFirstChild("Dungeons")
    if not dungeon then return false end
    local myHRP = A.HRP()
    if not myHRP then return false end
    local rooms = {}
    for _, child in ipairs(dungeon:GetDescendants()) do
        if child:IsA("Model") then
            local isRoom = false
            for _, roomType in ipairs(DUNGEON_ROOMS) do
                if string.find(string.lower(child.Name), string.lower(roomType)) then
                    isRoom = true
                    break
                end
            end
            if isRoom and not Dungeon._clearedRooms[child.Name .. "_" .. tostring(child:GetFullName())] then
                local part = child:FindFirstChildWhichIsA("BasePart") or child.PrimaryPart
                if part then
                    table.insert(rooms, {
                        Model = child,
                        Position = part.Position,
                        Distance = (myHRP.Position - part.Position).Magnitude
                    })
                end
            end
        end
    end
    table.sort(rooms, function(a, b) return a.Distance < b.Distance end)
    if #rooms > 0 then
        local nearest = rooms[1]
        A.TpTo(nearest.Position + Vector3.new(0, 5, 0), 100)
        Dungeon._currentRoom = nearest.Model
        return true
    end
    return false
end

function Dungeon.GetDungeonStats()
    local timer = Dungeon.GetDungeonTimer()
    return {
        InDungeon = Dungeon._inDungeon,
        Floor = Dungeon._currentFloor,
        Timer = timer.Display,
        TimerExpired = timer.Expired,
        Enemies = #Dungeon._enemies,
        BossFound = Dungeon._bossFound,
        PuzzlesSolved = Dungeon._puzzlesSolved,
        RoomsCleared = Dungeon._roomsCleared,
        LootCollected = Dungeon._lootCollected,
        KeysUsed = Dungeon._keysUsed,
        DungeonsCleared = Dungeon.DungeonsCleared,
        KeyFragments = Dungeon.KeyFragment
    }
end

function Dungeon.EnterDungeon()
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            commF("EnterDungeon")
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local enter = remotes:FindFirstChild("EnterDungeon") or remotes:FindFirstChild("DungeonEnter")
            if enter then
                enter:FireServer()
            end
        end
        Dungeon._dungeonTimer = tick()
        Dungeon._inDungeon = true
        Dungeon._currentFloor = Dungeon.GetDungeonFloor() + 1
        A.Notify("Dungeon", "Entered dungeon floor " .. tostring(Dungeon._currentFloor), 3)
    end)
    return ok
end

function Dungeon.SafeDungeon()
    if not A.Alive() then return true end
    local hum = A.Hum()
    if hum and hum.Health / math.max(hum.MaxHealth, 1) < Dungeon._safeThreshold then
        local myHRP = A.HRP()
        if myHRP then
            local safePos = myHRP.Position + Vector3.new(0, 200, 0)
            A.TpTo(safePos, 100)
        end
        return true
    end
    local timer = Dungeon.GetDungeonTimer()
    if timer.Expired then
        A.Notify("Dungeon", "Time expired! Exiting...", 3)
        return true
    end
    return false
end

function Dungeon.AutoDungeon()
    if Dungeon.SafeDungeon() then return end
    if not Dungeon.IsInDungeon() then
        local keys = Dungeon.GetDungeonKey()
        if keys > 0 then
            Dungeon.EnterDungeon()
            task.wait(3)
        else
            A.Notify("Dungeon", "No dungeon keys!", 3)
            return
        end
    end
    local boss = Dungeon.FindDungeonBoss()
    if boss then
        Dungeon.KillDungeonBoss()
        return
    end
    local puzzle = Dungeon.FindPuzzleRoom()
    if puzzle then
        Dungeon.SolvePuzzle()
        return
    end
    local killed = Dungeon.KillDungeonEnemies()
    if not killed then
        Dungeon.CollectLoot()
        Dungeon.NavigateDungeon()
    end
end

function Dungeon.FarmDungeonRewards()
    local rewards = {}
    local lp = A.LP
    if not lp then return rewards end
    local backpack = lp:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local isDungeon = string.find(string.lower(item.Name), "dungeon") or
                    string.find(string.lower(item.Name), "shadow") or
                    string.find(string.lower(item.Name), "soul") or
                    string.find(string.lower(item.Name), "bone")
                if isDungeon then
                    table.insert(rewards, {
                        Name = item.Name,
                        Type = "Tool",
                        Value = item:GetAttribute("Value") or 0
                    })
                end
            end
        end
    end
    Dungeon.DungeonRewards = rewards
    return rewards
end

function Dungeon.MainLoop()
    while Dungeon.Active do
        if not A.Alive() then
            task.wait(2)
        else
            SafeCall(function()
                Dungeon.AutoDungeon()
                if not Dungeon._inDungeon then
                    Dungeon.FarmDungeonRewards()
                end
            end)
            task.wait(0.5)
        end
    end
end

function Dungeon.Start(auto)
    if Dungeon.Active then return end
    Dungeon.Active = true
    Dungeon._startTick = tick()
    Dungeon._dungeonTimer = tick()
    Dungeon._autoRun = auto or false
    Dungeon._puzzlesSolved = 0
    Dungeon._roomsCleared = 0
    Dungeon._lootCollected = 0
    Dungeon._keysUsed = 0
    Dungeon._clearedRooms = {}
    A.Notify("Dungeon", "Started dungeon farming", 3)
    Dungeon._loop = task.spawn(function()
        Dungeon.MainLoop()
        Dungeon.Active = false
    end)
end

function Dungeon.Stop()
    Dungeon.Active = false
    Dungeon._inDungeon = false
    if Dungeon._loop then
        task.cancel(Dungeon._loop)
        Dungeon._loop = nil
    end
    A.Notify("Dungeon", "Stopped", 2)
end

A.Dungeon = Dungeon
A.Register("dungeon", A.Dungeon)
