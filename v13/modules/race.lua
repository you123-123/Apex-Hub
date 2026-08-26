local A = _G.Apex
local Race = {}
Race.Active = false
Race.CurrentRace = "None"
Race.RaceStage = 0
Race.TrialsCompleted = 0
Race._loop = nil
Race._startTick = 0
Race._v3Unlocked = false
Race._v4Unlocked = false
Race._v4Active = false
Race._trialActive = false
Race._currentTrial = nil
Race._trialTimer = 0
Race._trialMaxTime = 120
Race._awakenProgress = {}
Race._materials = {}
Race._failedTrials = 0
Race._maxTrialAttempts = 3
Race._lastTrialCompletion = 0
Race._v4Abilities = {}
Race._raceData = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local RACE_NAMES = {"Human", "Cyborg", "Fishman", "Ghoul", "Mink", "Skypiea", "Lunarian"}
local RACE_NPCS = {
    Human = "Human",
    Cyborg = "Cyborg",
    Fishman = "Fishman",
    Ghoul = "Ghoul",
    Mink = "Mink",
    Skypiea = "Skypiea",
    Lunarian = "Lunarian"
}
local V3_COST = 2500000
local V4_AWAKEN_STAGES = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Apex Race] Error: " .. tostring(err))
    end
    return ok, err
end

function Race.GetRace()
    local lp = A.LP
    if not lp then return "None" end
    local data = lp:FindFirstChild("Race")
    if data and data:IsA("ValueBase") then
        Race.CurrentRace = tostring(data.Value)
        return Race.CurrentRace
    end
    local char = lp.Character
    if char then
        for _, raceName in ipairs(RACE_NAMES) do
            if string.find(string.lower(char.Name), string.lower(raceName)) then
                Race.CurrentRace = raceName
                return Race.CurrentRace
            end
        end
    end
    local ok, result = SafeCall(function()
        local raceFolder = lp:FindFirstChild("RaceData") or lp:FindFirstChild("Races")
        if raceFolder then
            for _, child in ipairs(raceFolder:GetChildren()) do
                if child:IsA("ValueBase") and child.Value and child.Value ~= "" then
                    return tostring(child.Value)
                end
            end
        end
        return nil
    end)
    if ok and result then
        Race.CurrentRace = result
    end
    return Race.CurrentRace
end

function Race.GetRaceStage()
    local lp = A.LP
    if not lp then return 0 end
    local stageVal = lp:FindFirstChild("RaceStage") or lp:FindFirstChild("Stage")
    if stageVal and stageVal:IsA("ValueBase") then
        Race.RaceStage = tonumber(stageVal.Value) or 0
        return Race.RaceStage
    end
    local raceData = lp:FindFirstChild("RaceData")
    if raceData then
        local stage = raceData:FindFirstChild("Stage") or raceData:FindFirstChild("Progress")
        if stage and stage:IsA("ValueBase") then
            Race.RaceStage = tonumber(stage.Value) or 0
            return Race.RaceStage
        end
    end
    return Race.RaceStage
end

function Race.HasV3()
    local stage = Race.GetRaceStage()
    Race._v3Unlocked = stage >= 3
    return Race._v3Unlocked
end

function Race.HasV4()
    local stage = Race.GetRaceStage()
    Race._v4Unlocked = stage >= 4
    return Race._v4Unlocked
end

function Race.ActivateV3()
    if not Race.HasV3() then
        A.Notify("Race V3", "V3 not unlocked yet", 3)
        return false
    end
    local lp = A.LP
    if not lp then return false end
    local char = lp.Character
    if not char then return false end
    local race = Race.GetRace()
    if race == "None" then
        A.Notify("Race V3", "No race equipped", 3)
        return false
    end
    local ok, err = SafeCall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local activateV3 = remotes:FindFirstChild("ActivateV3") or remotes:FindFirstChild("RaceV3")
            if activateV3 then
                activateV3:FireServer()
                A.Notify("Race V3", "V3 activated!", 3)
                return true
            end
        end
        local commF = A.CommF
        if commF then
            local result = commF("ActivateV3")
            if result then
                A.Notify("Race V3", "V3 activated via CommF!", 3)
                return true
            end
        end
    end)
    return ok
end

function Race.ActivateV4()
    if not Race.HasV4() then
        A.Notify("Race V4", "V4 not unlocked yet", 3)
        return false
    end
    local ok, err = SafeCall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local activateV4 = remotes:FindFirstChild("ActivateV4") or remotes:FindFirstChild("RaceV4")
            if activateV4 then
                activateV4:FireServer()
                Race._v4Active = true
                A.Notify("Race V4", "V4 activated!", 3)
                return true
            end
        end
        local commF = A.CommF
        if commF then
            local result = commF("ActivateV4")
            if result then
                Race._v4Active = true
                A.Notify("Race V4", "V4 activated via CommF!", 3)
                return true
            end
        end
    end)
    return ok
end

function Race.GetRaceV4Abilities()
    local abilities = {}
    local race = Race.GetRace()
    if race == "Human" then
        abilities = {"Emperor's Haki", "Will of D", "Conqueror's Pulse"}
    elseif race == "Cyborg" then
        abilities = {"Energy Core", "Cybernetic Boost", "Full Body Cybernetics"}
    elseif race == "Fishman" then
        abilities = {"Shark Tooth", "Water Shield", "Tidal Wave"}
    elseif race == "Ghoul" then
        abilities = {"Life Leech", "Blood Rage", "Domain Expansion"}
    elseif race == "Mink" then
        abilities = {"Electric Claws", "Thunder Step", "Rabbit Fur Coat"}
    elseif race == "Skypiea" then
        abilities = {"Sky Walk", "Heavenly Light", "Divine Judgment"}
    elseif race == "Lunarian" then
        abilities = {"Flame Wings", "Sacrifice", "Burn Body"}
    end
    Race._v4Abilities = abilities
    return abilities
end

function Race.UseRaceAbility(abilityName)
    if not Race._v4Active then
        Race.ActivateV4()
        task.wait(1)
    end
    local ok, err = SafeCall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local useAbility = remotes:FindFirstChild("UseRaceAbility") or remotes:FindFirstChild("RaceAbility")
            if useAbility then
                useAbility:FireServer(abilityName)
            end
        end
    end)
    return ok
end

function Race.FindTrialNPC()
    local myHRP = A.HRP()
    if not myHRP then return nil end
    local race = Race.GetRace()
    local npcName = RACE_NPCS[race]
    if not npcName then return nil end
    local npcs = Workspace:FindFirstChild("NPCs") or Workspace:FindFirstChild("Living")
    if not npcs then
        for _, child in ipairs(Workspace:GetChildren()) do
            if child:IsA("Folder") then
                for _, npc in ipairs(child:GetChildren()) do
                    if npc:IsA("Model") and string.find(string.lower(npc.Name), string.lower(npcName)) then
                        local part = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
                        if part then
                            return npc
                        end
                    end
                end
            end
        end
    end
    if npcs then
        for _, npc in ipairs(npcs:GetChildren()) do
            if npc:IsA("Model") and string.find(string.lower(npc.Name), string.lower(npcName)) then
                local part = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
                if part then
                    return npc
                end
            end
        end
    end
    return nil
end

function Race.GetTrialRequirements()
    local race = Race.GetRace()
    local stage = Race.GetRaceStage()
    local requirements = {
        Race = race,
        CurrentStage = stage,
        RequiredLevel = stage == 0 and 850 or (stage == 1 and 1100 or (stage == 2 and 1500 or 2000)),
        RequiredFragments = stage * 500,
        RequiredMastery = stage * 100,
        TrialLocation = race == "Mink" and "Mink Village" or
            (race == "Human" and "Great Tree" or
            (race == "Fishman" and "Fishman Island" or
            (race == "Cyborg" and "Cyborg Arena" or
            (race == "Ghoul" and "Cursed Ship" or
            (race == "Skypiea" and "Upper Yard" or
            (race == "Lunarian" and "Mirror World" or "Unknown")))))),
        TrialType = stage < 3 and "Combat" or "Puzzle",
        TimeLimit = 120
    }
    return requirements
end

function Race.FarmTrial()
    local reqs = Race.GetTrialRequirements()
    local myHRP = A.HRP()
    if not myHRP then return false end
    A.Notify("Trial", "Starting trial for " .. reqs.Race .. " stage " .. tostring(reqs.CurrentStage + 1), 3)
    local npc = Race.FindTrialNPC()
    if npc then
        local part = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
        if part then
            local dist = (myHRP.Position - part.Position).Magnitude
            if dist > 30 then
                A.TpTo(part.Position + Vector3.new(0, 3, 0), 100)
                task.wait(1)
            end
            local args = {"RaceTrial"}
            local commF = A.CommF
            if commF then
                commF(unpack(args))
            end
        end
    end
    Race._trialActive = true
    Race._trialTimer = tick()
    Race._currentTrial = reqs
    return true
end

function Race.CompleteTrial()
    if not Race._trialActive then return false end
    local elapsed = tick() - Race._trialTimer
    if elapsed > Race._trialMaxTime then
        A.Notify("Trial", "Time limit exceeded!", 3)
        Race._trialActive = false
        Race._failedTrials = Race._failedTrials + 1
        return false
    end
    local enemies = Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("Hostile")
    local killedAll = true
    if enemies then
        for _, enemy in ipairs(enemies:GetChildren()) do
            if enemy:IsA("Model") then
                local hum = enemy:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    killedAll = false
                    local part = enemy:FindFirstChild("HumanoidRootPart") or enemy.PrimaryPart
                    if part then
                        A.SuperAttack(enemy)
                    end
                end
            end
        end
    end
    if killedAll then
        Race._trialActive = false
        Race.TrialsCompleted = Race.TrialsCompleted + 1
        Race._lastTrialCompletion = tick()
        A.Notify("Trial", "Trial completed! Total: " .. tostring(Race.TrialsCompleted), 3)
        return true
    end
    return false
end

function Race.StartTrial()
    if Race._trialActive then
        A.Notify("Trial", "Already in a trial!", 2)
        return false
    end
    if Race._failedTrials >= Race._maxTrialAttempts then
        A.Notify("Trial", "Max trial attempts reached", 3)
        return false
    end
    return Race.FarmTrial()
end

function Race.RaceAwaken()
    local race = Race.GetRace()
    if race == "None" then
        A.Notify("Race Awaken", "No race equipped", 3)
        return false
    end
    local stage = Race.GetRaceStage()
    if stage >= 4 then
        A.Notify("Race Awaken", "Race fully awakened!", 3)
        return true
    end
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            commF("RaceAwaken")
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local awaken = remotes:FindFirstChild("RaceAwaken") or remotes:FindFirstChild("AwakenRace")
            if awaken then
                awaken:FireServer()
            end
        end
    end)
    return ok
end

function Race.RaceBySea(sea)
    local raceMap = {
        [1] = {"Human", "Mink", "Fishman"},
        [2] = {"Human", "Cyborg", "Skypiea"},
        [3] = {"Ghoul", "Lunarian", "Mink"}
    }
    return raceMap[sea] or {}
end

function Race.GetRaceBySea(sea)
    local races = Race.RaceBySea(sea)
    for _, r in ipairs(races) do
        if Race.CurrentRace == r then
            return true
        end
    end
    return false
end

function Race.FarmRaceMaterials()
    local reqs = Race.GetTrialRequirements()
    local myHRP = A.HRP()
    if not myHRP then return false end
    local materialNames = {
        "Angel Wings", "Vampire Fang", "Mamba Venom", "Leviathan Scale",
        "Dragon Scale", "Meteor Core", "Frozen Heart", "Dark Fragment"
    }
    local enemies = Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("Hostile")
    if enemies then
        for _, enemy in ipairs(enemies:GetChildren()) do
            if enemy:IsA("Model") then
                local hum = enemy:FindFirstChild("Humanoid")
                local hrp = enemy:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local dist = (myHRP.Position - hrp.Position).Magnitude
                    if dist < 500 then
                        A.SuperAttack(enemy)
                        return true
                    end
                end
            end
        end
    end
    return false
end

function Race.RefundRace()
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            commF("RefundRace")
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local refund = remotes:FindFirstChild("RefundRace") or remotes:FindFirstChild("RaceRefund")
            if refund then
                refund:FireServer()
                A.Notify("Race", "Race refunded!", 3)
            end
        end
    end)
    return ok
end

function Race.RerollRace()
    local ok, err = SafeCall(function()
        local commF = A.CommF
        if commF then
            commF("RerollRace")
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local reroll = remotes:FindFirstChild("RerollRace") or remotes:FindFirstChild("RaceReroll")
            if reroll then
                reroll:FireServer()
                task.wait(2)
                Race.GetRace()
                A.Notify("Race", "Race rerolled! New: " .. Race.CurrentRace, 3)
            end
        end
    end)
    return ok
end

function Race.IsRaceLocked()
    local lp = A.LP
    if not lp then return true end
    local locked = lp:FindFirstChild("RaceLocked")
    if locked and locked:IsA("ValueBase") then
        return locked.Value == true
    end
    return false
end

function Race.GetRaceStats()
    local race = Race.GetRace()
    local stage = Race.GetRaceStage()
    return {
        Race = race,
        Stage = stage,
        HasV3 = Race.HasV3(),
        HasV4 = Race.HasV4(),
        V4Active = Race._v4Active,
        TrialsCompleted = Race.TrialsCompleted,
        FailedTrials = Race._failedTrials,
        Abilities = Race.GetRaceV4Abilities(),
        IsLocked = Race.IsRaceLocked(),
        TrialActive = Race._trialActive
    }
end

function Race.MainLoop()
    while Race.Active do
        if not A.Alive() then
            task.wait(2)
            break
        end
        SafeCall(function()
            Race.GetRace()
            Race.GetRaceStage()
            if Race._trialActive then
                Race.CompleteTrial()
            end
            if not Race._trialActive and Race.HasV4() and not Race._v4Active then
                if tick() - Race._lastTrialCompletion > 60 then
                    Race.ActivateV4()
                end
            end
        end)
        task.wait(1)
    end
end

function Race.Start()
    if Race.Active then return end
    Race.Active = true
    Race._startTick = tick()
    Race.GetRace()
    Race.GetRaceStage()
    A.Notify("Race", "Active: " .. Race.CurrentRace .. " Stage " .. tostring(Race.RaceStage), 3)
    Race._loop = task.spawn(function()
        Race.MainLoop()
        Race.Active = false
    end)
end

function Race.Stop()
    Race.Active = false
    Race._trialActive = false
    if Race._loop then
        task.cancel(Race._loop)
        Race._loop = nil
    end
    A.Notify("Race", "Stopped", 2)
end

A.Race = Race
A.Register("race", A.Race)
