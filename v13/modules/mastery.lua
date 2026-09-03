--[[
    Apex Hub v13.0 - Mastery Farm Module
    Comprehensive mastery farming for all weapon types
]]

local A = _G.Apex
if not A then return end

A.Mastery = {}
A.Mastery.Active = false
A.Mastery.CurrentWeapon = nil
A.Mastery.WeaponMastery = {}
A.Mastery.SessionStart = tick()
A.Mastery.TotalMasteryGained = 0
A.Mastery.LastWeaponCheck = 0
A.Mastery.CheckInterval = 5
A.Mastery.TargetMastery = 600
A.Mastery.AutoSwitch = true
A.Mastery.FarmMode = "auto"
A.Mastery.OptimalTarget = nil
-- Distinctive 5 Mastery Modes (was single auto vs HoHo 5) - HoHo has Bone/Gun/Observation/Superhuman/DeathStep
A.Mastery.Modes = {"Bone","Gun","Observation","Superhuman","DeathStep"}
function A.Mastery.SetMode(mode) if table.find(A.Mastery.Modes, mode) then A.Mastery.FarmMode=mode; A.Notify("Mastery","Mode: "..mode,2) end end
function A.Mastery.StartBone() A.Mastery.SetMode("Bone"); return A.Mastery.Start() end
function A.Mastery.StartGun() A.Mastery.SetMode("Gun"); return A.Mastery.Start() end
function A.Mastery.StartObservation() A.Mastery.SetMode("Observation"); return A.Mastery.Start() end
function A.Mastery.StartSuperhuman() A.Mastery.SetMode("Superhuman"); return A.Mastery.Start() end
function A.Mastery.StartDeathStep() A.Mastery.SetMode("DeathStep"); return A.Mastery.Start() end
A.Mastery.LastSwitch = 0
A.Mastery.SwitchCooldown = 300
A.Mastery.WeaponTypes = {"Sword", "Gun", "Melee", "Fruit", "Blox Fruit"}
A.Mastery.MaxMastery = 600
A.Mastery.FarmingLog = {}
A.Mastery.MobKills = 0
A.Mastery.LastKillTime = 0
A.Mastery.KillStreak = 0
A.Mastery.BestKillStreak = 0
A.Mastery.MasteryPerKill = 12.5

A.Mastery.MasteryRewards = {
    [25] = "Ability Unlock",
    [50] = "Moveset Upgrade",
    [100] = "New Move",
    [150] = "Enhanced Damage",
    [200] = "Special Ability",
    [250] = "Combo Unlock",
    [300] = "Mastery Move",
    [350] = "Advanced Combo",
    [400] = "Power Surge",
    [450] = "Ultimate Move",
    [500] = "Max Power",
    [550] = "Prestige",
    [600] = "Full Mastery",
}

A.Mastery.WeaponSkillUnlocks = {
    ["Sword"] = {
        [1] = "Basic Slash",
        [25] = "Dash Slash",
        [50] = "Cross Strike",
        [100] = "Thunder Flash",
        [150] = "Spiral Pierce",
        [200] = "Rapid Slashes",
        [250] = "Blade Dance",
        [300] = "Sword Gale",
        [350] = "Dragon Tail",
        [400] = "Moon Blade",
        [450] = "Star Slash",
        [500] = "Celestial Cut",
        [550] = "Divine Slash",
        [600] = "Transcendent Edge",
    },
    ["Gun"] = {
        [1] = "Quick Shot",
        [25] = "Burst Fire",
        [50] = "Sniper Shot",
        [100] = "Explosive Round",
        [150] = "Rapid Fire",
        [200] = "Homing Shot",
        [250] = "Piercing Bullet",
        [300] = "Chain Lightning",
        [350] = "Plasma Shot",
        [400] = "Orbital Strike",
        [450] = "Railgun",
        [500] = "Dimensional Shot",
        [550] = "Cosmic Blast",
        [600] = "Void Cannon",
    },
    ["Melee"] = {
        [1] = "Punch",
        [25] = "Quick Combo",
        [50] = "Uppercut",
        [100] = "Flying Kick",
        [150] = "Spin Kick",
        [200] = "Rushing Blow",
        [250] = "Meteor Smash",
        [300] = "Thunder Punch",
        [350] = "Meteor Fist",
        [400] = "Infinite Combo",
        [450] = "Meteor Impact",
        [500] = "Celestial Punch",
        [550] = "Divine Fist",
        [600] = "Universe Breaker",
    },
    ["Fruit"] = {
        [1] = "Basic Ability",
        [25] = "Elemental Blast",
        [50] = "Area Attack",
        [100] = "Devil Strike",
        [150] = "Awakening Pulse",
        [200] = "Elemental Shift",
        [250] = "Nature's Wrath",
        [300] = "Storm Fury",
        [350] = "Void Rift",
        [400] = "Cosmic Wave",
        [450] = "Reality Tear",
        [500] = "Universal Collapse",
        [550] = "Dimensional Rift",
        [600] = "Creation & Destruction",
    },
}

function A.Mastery.MainLoop()
    while A.Mastery.Active do
        if not A.Alive() then
            A.Notify("Mastery", "Waiting for respawn...", 3)
            task.wait(3)
        else
            local weapon = A.Mastery.CurrentWeapon
            if weapon then
                if A.Mastery.AutoSwitch and A.Mastery.IsMasteryMaxed(weapon) then
                    A.Mastery.SwitchWeaponMastery()
                else
                    A.Mastery.FarmMastery(weapon)
                end
            else
                A.Mastery.SelectWeapon(A.Mastery.FarmMode)
            end
            A.Mastery.CheckMasteryProgress()
        end
        task.wait(0.5)
    end
end

function A.Mastery.GetMasteryLevel(weaponName)
    if not weaponName then return 0 end
    local char = A.Char()
    if not char then return 0 end
    local player = A.LP
    if not player then return 0 end
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local masteryFolder = leaderstats:FindFirstChild("Mastery") or leaderstats:FindFirstChild("WeaponMastery")
        if masteryFolder then
            local weaponStat = masteryFolder:FindFirstChild(weaponName)
            if weaponStat then
                return weaponStat.Value
            end
        end
    end
    local equipped = A.LP.Character and A.LP.Character:FindFirstChildOfClass("Tool")
    if equipped and equipped.Name == weaponName then
        local masteryVal = equipped:FindFirstChild("Mastery") or equipped:FindFirstChild("Level")
        if masteryVal and masteryVal:IsA("IntValue") then
            return masteryVal.Value
        end
    end
    if A.Mastery.WeaponMastery[weaponName] then
        return A.Mastery.WeaponMastery[weaponName]
    end
    return 0
end

function A.Mastery.GetMasteryProgress(weaponName)
    local level = A.Mastery.GetMasteryLevel(weaponName)
    local required = A.Mastery.GetMasteryRequired(weaponName)
    if required <= 0 then return 100 end
    local progress = (level / required) * 100
    return math.min(progress, 100)
end

function A.Mastery.GetMasteryRequired(weaponName)
    local level = A.Mastery.GetMasteryLevel(weaponName)
    local nextLevel = level + 1
    if nextLevel >= A.Mastery.MaxMastery then
        return A.Mastery.MaxMastery
    end
    local baseXP = 100
    local scaling = 1.15
    local required = math.floor(baseXP * (scaling ^ nextLevel))
    return required
end

function A.Mastery.SelectWeapon(type)
    type = type or "auto"
    local best = A.Mastery.GetBestWeaponForMastery(type)
    if best then
        A.Mastery.CurrentWeapon = best
        A.Mastery.WeaponMastery[best] = A.Mastery.GetMasteryLevel(best)
        A.Notify("Mastery", "Selected: " .. best .. " (Lv." .. A.Mastery.WeaponMastery[best] .. ")", 3)
        return best
    end
    A.Notify("Mastery", "No weapons found for type: " .. type, 3)
    return nil
end

function A.Mastery.FarmMastery(weapon)
    if not weapon then return end
    local target = A.Mastery.OptimalMasteryTarget()
    if not target then
        A.Notify("Mastery", "No mastery targets found", 3)
        task.wait(3)
        return
    end
    local targetHum = target:FindFirstChildOfClass("Humanoid")
    if not targetHum or targetHum.Health <= 0 then
        return
    end
    A.TpTo(target.HumanoidRootPart.Position, 25)
    task.wait(0.3)
    A.SuperAttack(target)
    A.Mastery.MobKills = A.Mastery.MobKills + 1
    A.Mastery.KillStreak = A.Mastery.KillStreak + 1
    A.Mastery.LastKillTime = tick()
    if A.Mastery.KillStreak > A.Mastery.BestKillStreak then
        A.Mastery.BestKillStreak = A.Mastery.KillStreak
    end
    local masteryGain = A.Mastery.MasteryPerKill
    A.Mastery.TotalMasteryGained = A.Mastery.TotalMasteryGained + masteryGain
end

function A.Mastery.GetBestWeaponForMastery(type)
    type = type or "auto"
    local player = A.LP
    if not player then return nil end
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    local weapons = {}
    local function scanContainer(container)
        if not container then return end
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") then
                local itemType = item:GetAttribute("Type") or item:GetAttribute("WeaponType") or ""
                local masteryLevel = A.Mastery.GetMasteryLevel(item.Name)
                table.insert(weapons, {
                    name = item.Name,
                    type = itemType,
                    mastery = masteryLevel,
                    isEquipped = (character and character:FindFirstChild(item.Name) ~= nil),
                })
            end
        end
    end
    scanContainer(backpack)
    scanContainer(character)
    if type ~= "auto" then
        local filtered = {}
        for _, w in ipairs(weapons) do
            if string.lower(w.type) == string.lower(type) or string.find(string.lower(w.name), string.lower(type)) then
                table.insert(filtered, w)
            end
        end
        weapons = filtered
    end
    table.sort(weapons, function(a, b) return a.mastery < b.mastery end)
    if #weapons > 0 then
        return weapons[1].name
    end
    return nil
end

function A.Mastery.MasteryFruit()
    A.Mastery.FarmMode = "Fruit"
    A.Mastery.SelectWeapon("Fruit")
end

function A.Mastery.MasterySword()
    A.Mastery.FarmMode = "Sword"
    A.Mastery.SelectWeapon("Sword")
end

function A.Mastery.MasteryGun()
    A.Mastery.FarmMode = "Gun"
    A.Mastery.SelectWeapon("Gun")
end

function A.Mastery.MasteryMelee()
    A.Mastery.FarmMode = "Melee"
    A.Mastery.SelectWeapon("Melee")
end

function A.Mastery.MasteryAbility()
    A.Mastery.FarmMode = "Blox Fruit"
    A.Mastery.SelectWeapon("Blox Fruit")
end

function A.Mastery.OptimalMasteryTarget()
    local playerLevel = A.Lv() or 1
    local targets = {}
    local npcFolder = A.G:FindFirstChild("NPCs") or A.G:FindFirstChild("Enemys") or A.G:FindFirstChild("Enemies")
    if not npcFolder then
        for _, child in ipairs(A.G:GetChildren()) do
            if child:IsA("Folder") then
                npcFolder = child
                break
            end
        end
    end
    if not npcFolder then return nil end
    for _, npc in ipairs(npcFolder:GetChildren()) do
        if npc:IsA("Model") then
            local hum = npc:FindFirstChildOfClass("Humanoid")
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                local npcLevel = npc:FindFirstChild("Level") and npc.Level.Value or 0
                if npcLevel >= playerLevel - 10 and npcLevel <= playerLevel + 5 then
                    local myHRP = A.HRP()
                    if not myHRP then return nil end
                    local dist = (hrp.Position - myHRP.Position).Magnitude
                    table.insert(targets, {
                        model = npc,
                        level = npcLevel,
                        distance = dist,
                        health = hum.Health,
                        priority = 1000 - dist + npcLevel,
                    })
                end
            end
        end
    end
    table.sort(targets, function(a, b) return a.priority > b.priority end)
    if #targets > 0 then
        return targets[1].model
    end
    return nil
end

function A.Mastery.SwitchWeaponMastery()
    if tick() - A.Mastery.LastSwitch < A.Mastery.SwitchCooldown then
        return nil
    end
    A.Mastery.LastSwitch = tick()
    local weapon = A.Mastery.SelectWeapon(A.Mastery.FarmMode)
    return weapon
end

function A.Mastery.GetMasteryReward(weapon, level)
    if not weapon or not level then return nil end
    local reward = A.Mastery.MasteryRewards[level]
    if reward then
        return {level = level, reward = reward, weapon = weapon}
    end
    return nil
end

function A.Mastery.GetMasterySkills(weapon)
    if not weapon then return {} end
    local weaponType = "Sword"
    if string.find(string.lower(weapon), "gun") or string.find(string.lower(weapon), "pistol") or string.find(string.lower(weapon), "cannon") then
        weaponType = "Gun"
    elseif string.find(string.lower(weapon), "fruit") or string.find(string.lower(weapon), "blox") then
        weaponType = "Fruit"
    elseif string.find(string.lower(weapon), "fist") or string.find(string.lower(weapon), "leg") or string.find(string.lower(weapon), "claw") then
        weaponType = "Melee"
    end
    return A.Mastery.WeaponSkillUnlocks[weaponType] or {}
end

function A.Mastery.IsMasteryMaxed(weapon)
    local level = A.Mastery.GetMasteryLevel(weapon)
    return level >= A.Mastery.MaxMastery
end

function A.Mastery.GetMasteryStats()
    local uptime = tick() - A.Mastery.SessionStart
    local hours = math.floor(uptime / 3600)
    local mins = math.floor((uptime % 3600) / 60)
    local secs = math.floor(uptime % 60)
    local allWeapons = {}
    local player = A.LP
    if player then
        local backpack = player:FindFirstChild("Backpack")
        local character = player.Character
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") then
                    table.insert(allWeapons, {
                        name = item.Name,
                        mastery = A.Mastery.GetMasteryLevel(item.Name),
                        maxed = A.Mastery.IsMasteryMaxed(item.Name),
                    })
                end
            end
        end
        if character then
            for _, item in ipairs(character:GetChildren()) do
                if item:IsA("Tool") then
                    table.insert(allWeapons, {
                        name = item.Name,
                        mastery = A.Mastery.GetMasteryLevel(item.Name),
                        maxed = A.Mastery.IsMasteryMaxed(item.Name),
                    })
                end
            end
        end
    end
    return {
        active = A.Mastery.Active,
        currentWeapon = A.Mastery.CurrentWeapon or "None",
        farmMode = A.Mastery.FarmMode,
        totalMasteryGained = A.Mastery.TotalMasteryGained,
        mobKills = A.Mastery.MobKills,
        killStreak = A.Mastery.KillStreak,
        bestKillStreak = A.Mastery.BestKillStreak,
        uptime = string.format("%dh %dm %ds", hours, mins, secs),
        killsPerHour = uptime > 0 and math.floor(A.Mastery.MobKills / (uptime / 3600)) or 0,
        weapons = allWeapons,
        targetMastery = A.Mastery.TargetMastery,
        autoSwitch = A.Mastery.AutoSwitch,
    }
end

function A.Mastery.CalcMasteryTime(weapon)
    if not weapon then return 0 end
    local currentLevel = A.Mastery.GetMasteryLevel(weapon)
    local targetLevel = A.Mastery.TargetMastery
    local remaining = targetLevel - currentLevel
    if remaining <= 0 then return 0 end
    local uptime = tick() - A.Mastery.SessionStart
    local avgKillsPerHour = uptime > 0 and (A.Mastery.MobKills / (uptime / 3600)) or 120
    local killsNeeded = remaining * 10
    local hoursNeeded = killsNeeded / avgKillsPerHour
    return hoursNeeded * 3600
end

function A.Mastery.GetUnlocks(weapon)
    if not weapon then return {} end
    local currentLevel = A.Mastery.GetMasteryLevel(weapon)
    local skills = A.Mastery.GetMasterySkills(weapon)
    local unlocks = {}
    for level, skillName in pairs(skills) do
        table.insert(unlocks, {
            level = level,
            skill = skillName,
            unlocked = currentLevel >= level,
        })
    end
    table.sort(unlocks, function(a, b) return a.level < b.level end)
    return unlocks
end

function A.Mastery.CheckMasteryProgress()
    if tick() - A.Mastery.LastWeaponCheck < A.Mastery.CheckInterval then
        return
    end
    A.Mastery.LastWeaponCheck = tick()
    if A.Mastery.CurrentWeapon then
        local oldLevel = A.Mastery.WeaponMastery[A.Mastery.CurrentWeapon] or 0
        local newLevel = A.Mastery.GetMasteryLevel(A.Mastery.CurrentWeapon)
        if newLevel > oldLevel then
            local gain = newLevel - oldLevel
            A.Mastery.WeaponMastery[A.Mastery.CurrentWeapon] = newLevel
            A.Notify("Mastery", A.Mastery.CurrentWeapon .. " leveled up! " .. oldLevel .. " -> " .. newLevel .. " (+" .. gain .. ")", 5)
            table.insert(A.Mastery.FarmingLog, {
                weapon = A.Mastery.CurrentWeapon,
                from = oldLevel,
                to = newLevel,
                time = os.date("%Y-%m-%d %H:%M:%S"),
            })
            local reward = A.Mastery.GetMasteryReward(A.Mastery.CurrentWeapon, newLevel)
            if reward then
                A.Notify("Mastery Unlock", "New reward at Lv." .. newLevel .. ": " .. reward.reward, 8)
            end
        end
    end
end

function A.Mastery.Start()
    if A.Mastery.Active then
        A.Notify("Mastery", "Already running!", 2)
        return
    end
    A.Mastery.Active = true
    A.Mastery.SessionStart = tick()
    A.Mastery.TotalMasteryGained = 0
    A.Mastery.MobKills = 0
    A.Mastery.KillStreak = 0
    A.Mastery.BestKillStreak = 0
    A.Notify("Mastery", "Started farming " .. (A.Mastery.FarmMode or "auto") .. " mastery!", 3)
    task.spawn(A.Mastery.MainLoop)
end

function A.Mastery.Stop()
    A.Mastery.Active = false
    A.Mastery.CurrentWeapon = nil
    A.Notify("Mastery", "Stopped. Gained " .. A.Mastery.TotalMasteryGained .. " mastery this session.", 3)
end

local _origMasteryFruit = A.Mastery.MasteryFruit
local _origMasterySword = A.Mastery.MasterySword
local _origMasteryGun = A.Mastery.MasteryGun
local _origMasteryMelee = A.Mastery.MasteryMelee
local _origMasteryAbility = A.Mastery.MasteryAbility

function A.Mastery.ShowProgress()
end

function A.Mastery.MasteryFruit(v)
    _origMasteryFruit()
end

function A.Mastery.MasterySword(v)
    _origMasterySword()
end

function A.Mastery.MasteryGun(v)
    _origMasteryGun()
end

function A.Mastery.MasteryMelee(v)
    _origMasteryMelee()
end

function A.Mastery.MasteryAbility(v)
    _origMasteryAbility()
end

A.Register("mastery", A.Mastery)
