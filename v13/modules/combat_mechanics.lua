local A = _G.Apex
if not A then
	warn("[CombatMech] Apex table not found")
	return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local CombatMech = {}
CombatMech.Active = false
CombatMech.AttackSpeed = 0
CombatMech.AttackMode = "Normal"
CombatMech.AttackAngle = "Front"
CombatMech.AttackDistance = 6
CombatMech.HitboxRange = 25
CombatMech.BringRange = 100
CombatMech.FreezeRange = 100
CombatMech.CurrentWeapon = nil
CombatMech.SilentAimEnabled = false
CombatMech.AntiKnockbackEnabled = false
CombatMech.InfiniteDashEnabled = false
CombatMech.AutoHitboxEnabled = false
CombatMech.BringMobsEnabled = false
CombatMech.FreezeMobsEnabled = false
CombatMech._connections = {}
CombatMech._frozenMobs = {}
CombatMech._hitboxCache = {}
CombatMech._lockedTargets = {}
CombatMech._originalProps = {}

local function safeCall(fn, ...)
	local ok, err = pcall(fn, ...)
	if not ok then
		warn("[CombatMech] Error: " .. tostring(err))
	end
	return ok, err
end

local function getCharacterParts()
	local char = A.Char()
	if not char then return nil, nil, nil end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	return char, hrp, hum
end

local function getMobPrimaryPart(mob)
	if not mob then return nil end
	if mob:IsA("Model") then
		return mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso") or mob.PrimaryPart
	end
	if mob:IsA("BasePart") then
		return mob
	end
	return nil
end

local function getMobsInRange(range)
	local mobs = {}
	local char, hrp = getCharacterParts()
	if not hrp then return mobs end
	local folders = {"NPCs", "Enemies", "Mobs"}
	for _, folderName in ipairs(folders) do
		local folder = Workspace:FindFirstChild(folderName)
		if folder then
			for _, mob in pairs(folder:GetChildren()) do
				local mobPart = getMobPrimaryPart(mob)
				if mobPart then
					local dist = (mobPart.Position - hrp.Position).Magnitude
					if dist <= range then
						table.insert(mobs, mob)
					end
				end
			end
		end
	end
	for _, obj in pairs(Workspace:GetChildren()) do
		if obj:IsA("Model") and obj ~= char then
			local mobPart = getMobPrimaryPart(obj)
			if mobPart then
				local humanoid = obj:FindFirstChildOfClass("Humanoid")
				if humanoid and humanoid.Health > 0 then
					local dist = (mobPart.Position - hrp.Position).Magnitude
					if dist <= range then
						local found = false
						for _, m in ipairs(mobs) do
							if m == obj then found = true break end
						end
						if not found then
							table.insert(mobs, obj)
						end
					end
				end
			end
		end
	end
	return mobs
end

local function getPlayersInRange(range)
	local players = {}
	local char, hrp = getCharacterParts()
	if not hrp then return players end
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= Players.LocalPlayer then
			local tChar = player.Character
			if tChar then
				local tHRP = tChar:FindFirstChild("HumanoidRootPart")
				local tHum = tChar:FindFirstChildOfClass("Humanoid")
				if tHRP and tHum and tHum.Health > 0 then
					local dist = (tHRP.Position - hrp.Position).Magnitude
					if dist <= range then
						table.insert(players, player)
					end
				end
			end
		end
	end
	return players
end

local function getNearestMob(range)
	local char, hrp = getCharacterParts()
	if not hrp then return nil, math.huge end
	local nearest = nil
	local nearestDist = range or math.huge
	local mobs = getMobsInRange(range or 100)
	for _, mob in pairs(mobs) do
		local mobPart = getMobPrimaryPart(mob)
		if mobPart then
			local dist = (mobPart.Position - hrp.Position).Magnitude
			if dist < nearestDist then
				nearestDist = dist
				nearest = mob
			end
		end
	end
	return nearest, nearestDist
end

local function getNearestPlayer(range)
	local char, hrp = getCharacterParts()
	if not hrp then return nil, math.huge end
	local nearest = nil
	local nearestDist = range or math.huge
	local players = getPlayersInRange(range or 100)
	for _, player in pairs(players) do
		local tChar = player.Character
		if tChar then
			local tHRP = tChar:FindFirstChild("HumanoidRootPart")
			if tHRP then
				local dist = (tHRP.Position - hrp.Position).Magnitude
				if dist < nearestDist then
					nearestDist = dist
					nearest = player
				end
			end
		end
	end
	return nearest, nearestDist
end

local function calculateAnglePosition(basePos, angle, distance)
	local offset = Vector3.new(0, 0, 0)
	if angle == "Above" then
		offset = Vector3.new(0, distance, 0)
	elseif angle == "Below" then
		offset = Vector3.new(0, -distance, 0)
	elseif angle == "Behind" then
		offset = Vector3.new(0, 0, distance)
	elseif angle == "Front" then
		offset = Vector3.new(0, 0, -distance)
	elseif angle == "Left" then
		offset = Vector3.new(-distance, 0, 0)
	elseif angle == "Right" then
		offset = Vector3.new(distance, 0, 0)
	end
	return basePos + offset
end

local function performAttack(target, attackSpeed)
	local char, hrp, hum = getCharacterParts()
	if not char or not hrp or not hum then return end
	if hum.Health <= 0 then return end
	local targetPart = nil
	if typeof(target) == "Instance" then
		if target:IsA("Player") then
			local tChar = target.Character
			if tChar then
				targetPart = tChar:FindFirstChild("HumanoidRootPart")
			end
		else
			targetPart = getMobPrimaryPart(target)
		end
	end
	local targetPos = nil
	if targetPart then
		targetPos = targetPart.Position
	elseif typeof(target) == "Vector3" then
		targetPos = target
	end
	if not targetPos then return end
	if A.Attack then
		safeCall(function()
			A.Attack(target, {}, attackSpeed or 0)
		end)
	end
	if A.SuperAttack then
		safeCall(function()
			A.SuperAttack(target)
		end)
	end
	local tool = char:FindFirstChildOfClass("Tool")
	if tool then
		safeCall(function()
			tool:Activate()
		end)
	end
end

local function cancelSkillAnimation()
	local char = A.Char()
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		local animator = hum:FindFirstChildOfClass("Animator")
		if animator then
			for _, track in pairs(animator:GetPlayingAnimationTracks()) do
				track:Stop(0)
			end
		end
	end
end

-- ============================================================================
-- SECTION 1: FAST ATTACK SYSTEM
-- ============================================================================

function CombatMech.FastAttackNormal(target)
	if not target then return end
	local speed = 0.15
	performAttack(target, speed)
	task.wait(speed)
	performAttack(target, speed)
end

function CombatMech.FastAttackExtreme(target)
	if not target then return end
	local speed = 0.05
	for _ = 1, 3 do
		performAttack(target, speed)
		task.wait(speed)
	end
end

function CombatMech.FastAttackInstant(target)
	if not target then return end
	local speed = 0.01
	local char, hrp, hum = getCharacterParts()
	if not char or not hum then return end
	local start = tick()
	while tick() - start < 0.5 do
		if not CombatMech.Active then break end
		if hum.Health <= 0 then break end
		local mobHumanoid = nil
		if typeof(target) == "Instance" then
			if target:IsA("Player") then
				local tChar = target.Character
				if tChar then
					mobHumanoid = tChar:FindFirstChildOfClass("Humanoid")
				end
			else
				mobHumanoid = target:FindFirstChildOfClass("Humanoid")
			end
		end
		if mobHumanoid and mobHumanoid.Health <= 0 then break end
		performAttack(target, speed)
		task.wait(speed)
	end
end

function CombatMech.NoCooldownAttack(target)
	if not target then return end
	for _ = 1, 5 do
		if not CombatMech.Active then break end
		performAttack(target, 0)
		task.wait(0.01)
	end
end

function CombatMech.SetAttackSpeed(speed)
	if type(speed) ~= "number" then
		warn("[CombatMech] Invalid attack speed value")
		return
	end
	CombatMech.AttackSpeed = math.clamp(speed, 0, 10)
	A.Notify("CombatMech", "Attack speed set to: " .. tostring(CombatMech.AttackSpeed), 2)
end

function CombatMech.AttackLoop(target)
	if not target then return end
	local speedModes = {
		Normal = 0.15,
		Fast = 0.05,
		Extreme = 0.02,
		Instant = 0.005,
		Blazing = 0.001,
	}
	local speed = speedModes[CombatMech.AttackMode] or 0.15
	if CombatMech.AttackSpeed > 0 then
		speed = CombatMech.AttackSpeed
	end
	local char, hrp, hum = getCharacterParts()
	if not char or not hum then return end
	local start = tick()
	while CombatMech.Active and tick() - start < 60 do
		if hum.Health <= 0 then break end
		local mobHumanoid = nil
		if typeof(target) == "Instance" then
			if target:IsA("Player") then
				local tChar = target.Character
				if tChar then
					mobHumanoid = tChar:FindFirstChildOfClass("Humanoid")
				end
			else
				mobHumanoid = target:FindFirstChildOfClass("Humanoid")
			end
		end
		if mobHumanoid and mobHumanoid.Health <= 0 then break end
		performAttack(target, speed)
		task.wait(speed)
	end
end

-- ============================================================================
-- SECTION 2: HITBOX EXPANSION
-- ============================================================================

function CombatMech.HitboxExpand(range)
	local expandedRange = range or CombatMech.HitboxRange
	local mobs = getMobsInRange(200)
	for _, mob in ipairs(mobs) do
		safeCall(function()
			local humanoid = mob:FindFirstChildOfClass("Humanoid")
			if humanoid then
				if not CombatMech._hitboxCache[mob] then
					CombatMech._hitboxCache[mob] = {}
				end
				for _, part in pairs(mob:GetDescendants()) do
					if part:IsA("BasePart") then
						CombatMech._hitboxCache[mob][part] = part.Size
						part.Size = Vector3.new(expandedRange, expandedRange, expandedRange)
						part.Transparency = 0.7
						part.CanCollide = false
						part.Anchored = true
					end
				end
				local animator = humanoid:FindFirstChildOfClass("Animator")
				if animator then
					for _, track in pairs(animator:GetPlayingAnimationTracks()) do
						track:Stop(0)
					end
				end
			end
		end)
	end
end

function CombatMech.HitboxExpandMob(mob, range)
	if not mob then return end
	local expandedRange = range or CombatMech.HitboxRange
	safeCall(function()
		if not CombatMech._hitboxCache[mob] then
			CombatMech._hitboxCache[mob] = {}
		end
		for _, part in pairs(mob:GetDescendants()) do
			if part:IsA("BasePart") then
				CombatMech._hitboxCache[mob][part] = part.Size
				part.Size = Vector3.new(expandedRange, expandedRange, expandedRange)
				part.Transparency = 0.7
				part.CanCollide = false
				part.Anchored = true
			end
		end
		local humanoid = mob:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local animator = humanoid:FindFirstChildOfClass("Animator")
			if animator then
				for _, track in pairs(animator:GetPlayingAnimationTracks()) do
					track:Stop(0)
				end
			end
		end
	end)
end

function CombatMech.HitboxExpandPlayer(player, range)
	if not player or not player.Character then return end
	local expandedRange = range or CombatMech.HitboxRange
	local targetChar = player.Character
	safeCall(function()
		if not CombatMech._hitboxCache[player] then
			CombatMech._hitboxCache[player] = {}
		end
		for _, part in pairs(targetChar:GetDescendants()) do
			if part:IsA("BasePart") then
				CombatMech._hitboxCache[player][part] = part.Size
				part.Size = Vector3.new(expandedRange, expandedRange, expandedRange)
				part.Transparency = 0.7
				part.CanCollide = false
			end
		end
	end)
end

function CombatMech.ResetHitbox(mob)
	if not mob then return end
	local cache = CombatMech._hitboxCache[mob]
	if cache then
		safeCall(function()
			for part, originalSize in pairs(cache) do
				if part and part.Parent then
					part.Size = originalSize
					part.Transparency = 0
					part.CanCollide = true
					part.Anchored = false
				end
			end
		end)
		CombatMech._hitboxCache[mob] = nil
	end
end

function CombatMech.AutoHitboxExpand()
	if not CombatMech.AutoHitboxEnabled then return end
	local mobs = getMobsInRange(CombatMech.HitboxRange)
	for _, mob in ipairs(mobs) do
		safeCall(function()
			local humanoid = mob:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 then
				if not CombatMech._hitboxCache[mob] then
					CombatMech._hitboxCache[mob] = {}
				end
				for _, part in pairs(mob:GetDescendants()) do
					if part:IsA("BasePart") and part.Size.Magnitude < CombatMech.HitboxRange then
						CombatMech._hitboxCache[mob][part] = part.Size
						part.Size = Vector3.new(CombatMech.HitboxRange, CombatMech.HitboxRange, CombatMech.HitboxRange)
						part.Transparency = 0.7
						part.CanCollide = false
						part.Anchored = true
					end
				end
			end
		end)
	end
end

-- ============================================================================
-- SECTION 3: MOB MAGNET (BRING MOBS)
-- ============================================================================

function CombatMech.BringMobs(range)
	local bringRange = range or CombatMech.BringRange
	local char, hrp = getCharacterParts()
	if not char or not hrp then return end
	local mobs = getMobsInRange(bringRange)
	local pos = hrp.Position
	for _, mob in ipairs(mobs) do
		safeCall(function()
			local mobPart = getMobPrimaryPart(mob)
			if mobPart then
				local humanoid = mob:FindFirstChildOfClass("Humanoid")
				if humanoid and humanoid.Health > 0 then
					local targetPos = pos + Vector3.new(
						math.random(-3, 3),
						0,
						math.random(-3, 3)
					)
					mobPart.CFrame = CFrame.new(targetPos, pos)
					mobPart.Velocity = Vector3.new(0, 0, 0)
					mobPart.RotVelocity = Vector3.new(0, 0, 0)
					local rootJoint = mobPart:FindFirstChild("RootJoint")
						or mobPart:FindFirstChild("RootC0")
						or mobPart:FindFirstChild("Root")
					if rootJoint then
						if rootJoint:IsA("Motor6D") then
							rootJoint.Part0 = mobPart
						end
					end
				end
			end
		end)
	end
end

function CombatMech.BringMobsToPoint(pos, range)
	if not pos then return end
	local bringRange = range or CombatMech.BringRange
	local mobs = getMobsInRange(bringRange)
	for _, mob in ipairs(mobs) do
		safeCall(function()
			local mobPart = getMobPrimaryPart(mob)
			if mobPart then
				local humanoid = mob:FindFirstChildOfClass("Humanoid")
				if humanoid and humanoid.Health > 0 then
					local offset = Vector3.new(
						math.random(-5, 5),
						0,
						math.random(-5, 5)
					)
					local targetPos = pos + offset
					mobPart.CFrame = CFrame.new(targetPos, pos)
					mobPart.Velocity = Vector3.new(0, 0, 0)
					mobPart.RotVelocity = Vector3.new(0, 0, 0)
				end
			end
		end)
	end
end

function CombatMech.BringMob(mob, pos)
	if not mob or not pos then return end
	safeCall(function()
		local mobPart = getMobPrimaryPart(mob)
		if mobPart then
			local humanoid = mob:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 then
				mobPart.CFrame = CFrame.new(pos, pos)
				mobPart.Velocity = Vector3.new(0, 0, 0)
				mobPart.RotVelocity = Vector3.new(0, 0, 0)
			end
		end
	end)
end

function CombatMech.FreezeBringMobs(range)
	local bringRange = range or CombatMech.BringRange
	local char, hrp = getCharacterParts()
	if not char or not hrp then return end
	local mobs = getMobsInRange(bringRange)
	local pos = hrp.Position
	for _, mob in ipairs(mobs) do
		safeCall(function()
			local mobPart = getMobPrimaryPart(mob)
			if mobPart then
				local humanoid = mob:FindFirstChildOfClass("Humanoid")
				if humanoid and humanoid.Health > 0 then
					local targetPos = pos + Vector3.new(
						math.random(-3, 3),
						0,
						math.random(-3, 3)
					)
					mobPart.CFrame = CFrame.new(targetPos, pos)
					mobPart.Velocity = Vector3.new(0, 0, 0)
					mobPart.RotVelocity = Vector3.new(0, 0, 0)
					mobPart.Anchored = true
					CombatMech._frozenMobs[mob] = true
				end
			end
		end)
	end
end

function CombatMech.MobMagnetLoop()
	while CombatMech.Active and CombatMech.BringMobsEnabled do
		CombatMech.BringMobs(CombatMech.BringRange)
		task.wait(0.1)
	end
end

-- ============================================================================
-- SECTION 4: MOB FREEZE
-- ============================================================================

function CombatMech.FreezeMob(mob)
	if not mob then return end
	safeCall(function()
		local mobPart = getMobPrimaryPart(mob)
		if mobPart then
			local humanoid = mob:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 then
				CombatMech._originalProps[mob] = {
					Anchored = mobPart.Anchored,
					Velocity = mobPart.Velocity,
					RotVelocity = mobPart.RotVelocity,
				}
				mobPart.Anchored = true
				mobPart.Velocity = Vector3.new(0, 0, 0)
				mobPart.RotVelocity = Vector3.new(0, 0, 0)
				humanoid.WalkSpeed = 0
				humanoid.JumpPower = 0
				humanoid.JumpHeight = 0
				CombatMech._frozenMobs[mob] = true
			end
		end
	end)
end

function CombatMech.UnfreezeMob(mob)
	if not mob then return end
	safeCall(function()
		local mobPart = getMobPrimaryPart(mob)
		if mobPart then
			local humanoid = mob:FindFirstChildOfClass("Humanoid")
			local original = CombatMech._originalProps[mob]
			if original then
				mobPart.Anchored = original.Anchored
				mobPart.Velocity = original.Velocity
				mobPart.RotVelocity = original.RotVelocity
			else
				mobPart.Anchored = false
			end
			if humanoid then
				humanoid.WalkSpeed = 16
				humanoid.JumpPower = 50
				humanoid.JumpHeight = 7.2
			end
			CombatMech._frozenMobs[mob] = nil
			CombatMech._originalProps[mob] = nil
		end
	end)
end

function CombatMech.FreezeAllMobs(range)
	local freezeRange = range or CombatMech.FreezeRange
	local mobs = getMobsInRange(freezeRange)
	for _, mob in ipairs(mobs) do
		CombatMech.FreezeMob(mob)
	end
end

function CombatMech.UnfreezeAll()
	for mob, _ in pairs(CombatMech._frozenMobs) do
		if mob and mob.Parent then
			CombatMech.UnfreezeMob(mob)
		end
	end
	CombatMech._frozenMobs = {}
end

function CombatMech.FreezeAndKill(range)
	local killRange = range or CombatMech.FreezeRange
	local mobs = getMobsInRange(killRange)
	for _, mob in ipairs(mobs) do
		CombatMech.FreezeMob(mob)
	end
	for _, mob in ipairs(mobs) do
		if CombatMech.Active then
			performAttack(mob, 0)
			task.wait(0.01)
		end
	end
end

-- ============================================================================
-- SECTION 5: ATTACK CUSTOMIZATION
-- ============================================================================

function CombatMech.AutoHitNearest()
	local char, hrp, hum = getCharacterParts()
	if not char or not hrp or not hum then return end
	if hum.Health <= 0 then return end
	local mob, dist = getNearestMob(100)
	if mob then
		CombatMech.FastAttackNormal(mob)
	end
	local player, pDist = getNearestPlayer(100)
	if player and pDist < dist then
		CombatMech.FastAttackNormal(player)
	elseif player and dist == math.huge then
		CombatMech.FastAttackNormal(player)
	end
end

function CombatMech.SetAttackAngle(angle)
	local validAngles = {"Above", "Below", "Behind", "Front", "Left", "Right"}
	local found = false
	for _, v in ipairs(validAngles) do
		if v == angle then
			found = true
			break
		end
	end
	if not found then
		warn("[CombatMech] Invalid angle: " .. tostring(angle))
		A.Notify("CombatMech", "Valid angles: Above, Below, Behind, Front, Left, Right", 3)
		return
	end
	CombatMech.AttackAngle = angle
	A.Notify("CombatMech", "Attack angle set to: " .. angle, 2)
end

function CombatMech.SetAttackDistance(dist)
	if type(dist) ~= "number" or dist <= 0 then
		warn("[CombatMech] Invalid attack distance")
		return
	end
	CombatMech.AttackDistance = dist
	A.Notify("CombatMech", "Attack distance set to: " .. tostring(dist), 2)
end

function CombatMech.GetOptimalAttackPos(target)
	if not target then return nil end
	local char, hrp = getCharacterParts()
	if not hrp then return nil end
	local targetPart = nil
	if typeof(target) == "Instance" then
		if target:IsA("Player") then
			local tChar = target.Character
			if tChar then
				targetPart = tChar:FindFirstChild("HumanoidRootPart")
			end
		else
			targetPart = getMobPrimaryPart(target)
		end
	end
	if not targetPart then return nil end
	local targetPos = targetPart.Position
	local myPos = hrp.Position
	local direction = (targetPos - myPos).Unit
	local optimalDist = CombatMech.AttackDistance
	local angleOffset = Vector3.new(0, 0, 0)
	if CombatMech.AttackAngle == "Above" then
		angleOffset = Vector3.new(0, optimalDist, 0)
	elseif CombatMech.AttackAngle == "Below" then
		angleOffset = Vector3.new(0, -optimalDist * 0.5, 0)
	elseif CombatMech.AttackAngle == "Behind" then
		angleOffset = -direction * optimalDist
	elseif CombatMech.AttackAngle == "Front" then
		angleOffset = direction * optimalDist
	elseif CombatMech.AttackAngle == "Left" then
		angleOffset = direction:Cross(Vector3.new(0, 1, 0)).Unit * optimalDist
	elseif CombatMech.AttackAngle == "Right" then
		angleOffset = -direction:Cross(Vector3.new(0, 1, 0)).Unit * optimalDist
	end
	return targetPos + angleOffset
end

function CombatMech.AttackWithAngle(target, angle)
	if not target then return end
	local prevAngle = CombatMech.AttackAngle
	CombatMech.AttackAngle = angle or "Front"
	local optimalPos = CombatMech.GetOptimalAttackPos(target)
	if optimalPos and A.TpTo then
		safeCall(function()
			A.TpTo(optimalPos, 5)
		end)
	end
	task.wait(0.05)
	performAttack(target, 0.01)
	task.wait(0.05)
	CombatMech.AttackAngle = prevAngle
end

-- ============================================================================
-- SECTION 6: WEAPON SWITCH
-- ============================================================================

function CombatMech.FastSwitchWeapon(type)
	local char = A.Char()
	if not char then return end
	local targetType = type or "Melee"
	for _, tool in pairs(char:GetChildren()) do
		if tool:IsA("Tool") then
			local name = tool.Name:lower()
			local matchesType = false
			if targetType == "Sword" and (name:find("sword") or name:find("blade") or name:find("katana")) then
				matchesType = true
			elseif targetType == "Gun" and (name:find("gun") or name:find("pistol") or name:find("musket")) then
				matchesType = true
			elseif targetType == "Melee" and not name:find("sword") and not name:find("gun") then
				matchesType = true
			end
			if matchesType then
				tool.Parent = char
				tool:Activate()
				CombatMech.CurrentWeapon = tool
				return tool
			end
		end
	end
	return nil
end

function CombatMech.AutoWeaponSwitch(target)
	if not target then return end
	local char = A.Char()
	if not char then return end
	local targetType = "Melee"
	if typeof(target) == "Instance" then
		if target:IsA("Player") then
			local tChar = target.Character
			if tChar then
				local tHum = tChar:FindFirstChildOfClass("Humanoid")
				if tHum and tHum.Health > 0 then
					local dist = 0
					local myHRP = char:FindFirstChild("HumanoidRootPart")
					local tHRP = tChar:FindFirstChild("HumanoidRootPart")
					if myHRP and tHRP then
						dist = (tHRP.Position - myHRP.Position).Magnitude
					end
					if dist > 30 then
						targetType = "Gun"
					else
						targetType = "Sword"
					end
				end
			end
		else
			local mobHumanoid = target:FindFirstChildOfClass("Humanoid")
			if mobHumanoid then
				targetType = "Sword"
			end
		end
	end
	return CombatMech.FastSwitchWeapon(targetType)
end

function CombatMech.SwitchForCombo(combo)
	if type(combo) ~= "table" then return end
	local char = A.Char()
	if not char then return end
	for _, weaponType in ipairs(combo) do
		if CombatMech.Active then
			CombatMech.FastSwitchWeapon(weaponType)
			task.wait(0.05)
			local target = A.FindTarget and A.FindTarget(50) or nil
			if target then
				performAttack(target, 0.01)
			end
			task.wait(0.1)
		end
	end
end

function CombatMech.GetBestWeaponForTarget(target)
	if not target then return nil end
	local char = A.Char()
	if not char then return nil end
	local bestWeapon = nil
	local bestRating = -1
	for _, tool in pairs(char:GetChildren()) do
		if tool:IsA("Tool") then
			local rating = 0
			local name = tool.Name:lower()
			if name:find("sword") or name:find("blade") then
				rating = 10
			elseif name:find("gun") then
				rating = 8
			else
				rating = 5
			end
			local stats = tool:FindFirstChild("Stats") or tool:FindFirstChild("Data")
			if stats then
				local dmg = stats:FindFirstChild("Damage") or stats:FindFirstChild("Power")
				if dmg and dmg:IsA("ValueBase") then
					rating = rating + (dmg.Value or 0)
				end
			end
			if rating > bestRating then
				bestRating = rating
				bestWeapon = tool
			end
		end
	end
	return bestWeapon
end

-- ============================================================================
-- SECTION 7: SKILL CANCEL
-- ============================================================================

function CombatMech.SkillCancel(skill)
	if not skill then return end
	safeCall(function()
		cancelSkillAnimation()
		local char = A.Char()
		if char then
			local tool = char:FindFirstChildOfClass("Tool")
			if tool then
				local remote = tool:FindFirstChild(skill)
					or tool:FindFirstChild("RemoteEvent")
					or tool:FindFirstChild("SkillRemote")
				if remote and remote:IsA("RemoteEvent") then
					remote:FireServer()
				end
			end
		end
	end)
end

function CombatMech.FeintCombo(target)
	if not target then return end
	local char, hrp, hum = getCharacterParts()
	if not char or not hum then return end
	if hum.Health <= 0 then return end
	safeCall(function()
		CombatMech.SkillCancel("Skill1")
	end)
	task.wait(0.1)
	performAttack(target, 0.01)
	task.wait(0.05)
	safeCall(function()
		CombatMech.SkillCancel("Skill2")
	end)
	task.wait(0.1)
	performAttack(target, 0.01)
end

function CombatMech.CancelAndAttack(target, skill)
	if not target then return end
	safeCall(function()
		CombatMech.SkillCancel(skill or "Skill1")
	end)
	task.wait(0.05)
	performAttack(target, 0.01)
end

-- ============================================================================
-- SECTION 8: PVP COMBAT
-- ============================================================================

function CombatMech.SilentAim(target)
	if not target then return end
	local char, hrp, hum = getCharacterParts()
	if not char or not hrp or not hum then return end
	if hum.Health <= 0 then return end
	local targetChar = nil
	if typeof(target) == "Instance" and target:IsA("Player") then
		targetChar = target.Character
	else
		return
	end
	if not targetChar then return end
	local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end
	local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
	if targetHum and targetHum.Health <= 0 then return end
	local dir = (targetHRP.Position - hrp.Position).Unit
	local lookCF = CFrame.new(hrp.Position, hrp.Position + dir)
	safeCall(function()
		hrp.CFrame = lookCF
	end)
	local tool = char:FindFirstChildOfClass("Tool")
	if tool then
		safeCall(function()
			tool:Activate()
		end)
	end
end

function CombatMech.MultiTargetLock(targets)
	if type(targets) ~= "table" then return end
	CombatMech._lockedTargets = {}
	for _, target in ipairs(targets) do
		if typeof(target) == "Instance" then
			if target:IsA("Player") then
				local tChar = target.Character
				if tChar then
					local tHum = tChar:FindFirstChildOfClass("Humanoid")
					if tHum and tHum.Health > 0 then
						table.insert(CombatMech._lockedTargets, target)
					end
				end
			else
				local mobHum = target:FindFirstChildOfClass("Humanoid")
				if mobHum and mobHum.Health > 0 then
					table.insert(CombatMech._lockedTargets, target)
				end
			end
		end
	end
	A.Notify("CombatMech", "Locked " .. #CombatMech._lockedTargets .. " targets", 2)
end

function CombatMech.AntiKnockback()
	if CombatMech.AntiKnockbackEnabled then return end
	CombatMech.AntiKnockbackEnabled = true
	local char, hrp, hum = getCharacterParts()
	if not char or not hrp or not hum then return end
	local lastPos = hrp.Position
	local con = RunService.Heartbeat:Connect(function()
		pcall(function()
			if not CombatMech.Active or not CombatMech.AntiKnockbackEnabled then
				return
			end
			local char2, hrp2, hum2 = getCharacterParts()
			if not hrp2 or not hum2 then return end
			if hum2.Health <= 0 then return end
			local currentPos = hrp2.Position
			local velocity = hrp2.Velocity
			local knockbackDetected = velocity.Magnitude > 50
			local suddenDrop = (currentPos.Y - lastPos.Y) < -10
			if knockbackDetected or suddenDrop then
				safeCall(function()
					hrp2.Velocity = Vector3.new(0, 0, 0)
					hrp2.RotVelocity = Vector3.new(0, 0, 0)
				end)
			end
			lastPos = currentPos
		end)
	end)
	table.insert(CombatMech._connections, con)
end

function CombatMech.InfiniteDash()
	if CombatMech.InfiniteDashEnabled then return end
	CombatMech.InfiniteDashEnabled = true
	local char, hrp, hum = getCharacterParts()
	if not char or not hrp or not hum then return end
	local con = RunService.Heartbeat:Connect(function()
		pcall(function()
			if not CombatMech.Active or not CombatMech.InfiniteDashEnabled then
				return
			end
			local char2, hrp2, hum2 = getCharacterParts()
			if not hrp2 or not hum2 then return end
			if hum2.Health <= 0 then return end
			local moveDir = hum2.MoveDirection
			if moveDir.Magnitude > 0 then
				safeCall(function()
					hrp2.Velocity = Vector3.new(
						moveDir.X * 80,
						hrp2.Velocity.Y,
						moveDir.Z * 80
					)
				end)
			end
		end)
	end)
	table.insert(CombatMech._connections, con)
end

function CombatMech.UnlimitedDash()
	if CombatMech.InfiniteDashEnabled then
		CombatMech.InfiniteDashEnabled = false
		return
	end
	CombatMech.InfiniteDashEnabled = true
	local char, hrp, hum = getCharacterParts()
	if not char or not hrp or not hum then return end
	local con = RunService.Heartbeat:Connect(function()
		pcall(function()
			if not CombatMech.Active or not CombatMech.InfiniteDashEnabled then
				return
			end
			local char2, hrp2, hum2 = getCharacterParts()
			if not hrp2 or not hum2 then return end
			if hum2.Health <= 0 then return end
			local moveDir = hum2.MoveDirection
			if moveDir.Magnitude > 0 then
				safeCall(function()
					hrp2.CFrame = hrp2.CFrame + (moveDir * 2)
				end)
			end
		end)
	end)
	table.insert(CombatMech._connections, con)
end

function CombatMech.WallCombo(target)
	if not target then return end
	local char, hrp, hum = getCharacterParts()
	if not char or not hrp or not hum then return end
	if hum.Health <= 0 then return end
	local targetPart = nil
	if typeof(target) == "Instance" then
		if target:IsA("Player") then
			local tChar = target.Character
			if tChar then
				targetPart = tChar:FindFirstChild("HumanoidRootPart")
			end
		else
			targetPart = getMobPrimaryPart(target)
		end
	end
	if not targetPart then return end
	local targetPos = targetPart.Position
	local direction = (targetPos - hrp.Position).Unit
	local wallPos = targetPos + direction * 5
	safeCall(function()
		hrp.CFrame = CFrame.new(wallPos, targetPos)
	end)
	task.wait(0.1)
	for _ = 1, 3 do
		if not CombatMech.Active then break end
		performAttack(target, 0.01)
		task.wait(0.05)
	end
end

function CombatMech.AirCombo(target)
	if not target then return end
	local char, hrp, hum = getCharacterParts()
	if not char or not hrp or not hum then return end
	if hum.Health <= 0 then return end
	local targetPart = nil
	if typeof(target) == "Instance" then
		if target:IsA("Player") then
			local tChar = target.Character
			if tChar then
				targetPart = tChar:FindFirstChild("HumanoidRootPart")
			end
		else
			targetPart = getMobPrimaryPart(target)
		end
	end
	if not targetPart then return end
	local targetPos = targetPart.Position
	local airPos = targetPos + Vector3.new(0, 15, 0)
	safeCall(function()
		hrp.CFrame = CFrame.new(airPos, targetPos)
	end)
	task.wait(0.1)
	for _ = 1, 4 do
		if not CombatMech.Active then break end
		performAttack(target, 0.01)
		task.wait(0.08)
	end
end

function CombatMech.TargetLockSpectate(target)
	if not target then return end
	if not target:IsA("Player") then
		warn("[CombatMech] Target must be a Player for spectate")
		return
	end
	CombatMech._lockedTargets = {target}
	A.Notify("CombatMech", "Locked target: " .. target.Name, 2)
	safeCall(function()
		Workspace.CurrentCamera.CameraSubject = target.Character
	end)
end

-- ============================================================================
-- SECTION 9: CHEST FARM ENHANCED
-- ============================================================================

function CombatMech.AntiBanChestFarm()
	local char, hrp, hum = getCharacterParts()
	if not char or not hrp or not hum then return end
	local con = RunService.Heartbeat:Connect(function()
		pcall(function()
			if not CombatMech.Active then return end
			local char2, hrp2, hum2 = getCharacterParts()
			if not hrp2 or not hum2 then return end
			if hum2.Health <= 0 then return end
			local speed = hum2.WalkSpeed
			if speed > 100 then
				hum2.WalkSpeed = 50
			end
			local pos = hrp2.Position
			if pos.Y < -50 or pos.Y > 5000 then
				safeCall(function()
					hrp2.CFrame = CFrame.new(0, 50, 0)
				end)
			end
		end)
	end)
	table.insert(CombatMech._connections, con)
end

function CombatMech.BypassChestSpeed()
	local char, hrp, hum = getCharacterParts()
	if not char or not hrp or not hum then return end
	local con = RunService.Heartbeat:Connect(function()
		pcall(function()
			if not CombatMech.Active then return end
			local char2, hrp2, hum2 = getCharacterParts()
			if not hrp2 or not hum2 then return end
			if hum2.Health <= 0 then return end
			if hum2.WalkSpeed < 200 then
				hum2.WalkSpeed = 200
			end
		end)
	end)
	table.insert(CombatMech._connections, con)
end

function CombatMech.SafeChestCollect(chest)
	if not chest then return end
	local char, hrp, hum = getCharacterParts()
	if not char or not hrp or not hum then return end
	if hum.Health <= 0 then return end
	local chestPart = nil
	if chest:IsA("Model") then
		chestPart = chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")
	elseif chest:IsA("BasePart") then
		chestPart = chest
	end
	if not chestPart then return end
	local chestPos = chestPart.Position
	local safePos = chestPos + Vector3.new(0, 2, 0)
	safeCall(function()
		hrp.CFrame = CFrame.new(safePos, chestPos)
	end)
	task.wait(0.2)
	safeCall(function()
		hrp.CFrame = CFrame.new(chestPos)
	end)
	task.wait(0.1)
	local touchPart = chest:FindFirstChild("TouchPart")
	if touchPart and touchPart:IsA("BasePart") then
		safeCall(function()
			touchPart.CanCollide = false
			touchPart.Size = Vector3.new(10, 10, 10)
		end)
	end
end

-- ============================================================================
-- SECTION 10: AUTO SYSTEMS & MAIN LOOP
-- ============================================================================

function CombatMech.MainLoop()
	while CombatMech.Active do
		safeCall(function()
			if CombatMech.AutoHitboxEnabled then
				CombatMech.AutoHitboxExpand()
			end
			if CombatMech.BringMobsEnabled then
				CombatMech.BringMobs(CombatMech.BringRange)
			end
			if CombatMech.FreezeMobsEnabled then
				CombatMech.FreezeAllMobs(CombatMech.FreezeRange)
			end
			if CombatMech.SilentAimEnabled then
				local target = getNearestPlayer(200)
				if target then
					CombatMech.SilentAim(target)
				end
			end
			if CombatMech.InfiniteDashEnabled then
				local char, hrp, hum = getCharacterParts()
				if hum then
					local moveDir = hum.MoveDirection
					if moveDir.Magnitude > 0 then
						safeCall(function()
							hrp.CFrame = hrp.CFrame + (moveDir * 1.5)
						end)
					end
				end
			end
		end)
		task.wait(0.1)
	end
end

function CombatMech.Start()
	if CombatMech.Active then
		A.Notify("CombatMech", "Already running", 2)
		return
	end
	CombatMech.Active = true
	A.Notify("CombatMech", "Combat Mechanics started", 2)
	safeCall(function()
		CombatMech.AntiKnockback()
		CombatMech.AntiBanChestFarm()
	end)
	task.spawn(function()
		CombatMech.MainLoop()
	end)
end

function CombatMech.Stop()
	CombatMech.Active = false
	CombatMech.AutoHitboxEnabled = false
	CombatMech.BringMobsEnabled = false
	CombatMech.FreezeMobsEnabled = false
	CombatMech.SilentAimEnabled = false
	CombatMech.AntiKnockbackEnabled = false
	CombatMech.InfiniteDashEnabled = false
	for _, con in ipairs(CombatMech._connections) do
		if con and con.Connected then
			con:Disconnect()
		end
	end
	CombatMech._connections = {}
	CombatMech.UnfreezeAll()
	for mob, _ in pairs(CombatMech._hitboxCache) do
		if mob and mob.Parent then
			CombatMech.ResetHitbox(mob)
		end
	end
	CombatMech._hitboxCache = {}
	CombatMech._lockedTargets = {}
	CombatMech._originalProps = {}
	safeCall(function()
		local char = A.Char()
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = 16
				hum.JumpPower = 50
				hum.JumpHeight = 7.2
			end
		end
	end)
	safeCall(function()
		Workspace.CurrentCamera.CameraSubject = A.Char()
	end)
	A.Notify("CombatMech", "Combat Mechanics stopped", 2)
end

A.CombatMech = CombatMech

A.Register("combat_mechanics", CombatMech)
