-- (removed --!strict for executor compatibility)
--[[
    Apex Hub v13 — Visual Enhance Module
    Missing visual / performance / utility features
    No `continue` keyword usage
    Relies on _G.Apex (A) table
]]

local A = _G.Apex or {}
_G.Apex = A

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local Lighting           = game:GetService("Lighting")
local UserInputService   = game:GetService("UserInputService")
local StarterGui         = game:GetService("StarterGui")
local HttpService        = game:GetService("HttpService")
local TweenService       = game:GetService("TweenService")
local SoundService       = game:GetService("SoundService")
local Workspace          = game:GetService("Workspace")
local CoreGui            = game:GetService("CoreGui")
local Stats              = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

-- ============================================================================
--  A.Visual — main table
-- ============================================================================
A.Visual = {}

-- internal state -------------------------------------------------------------
A.Visual._fullBrightEnabled   = false
A.Visual._fogEnabled          = true
A.Visual._shadowsEnabled      = true
A.Visual._originalAmbient     = Lighting.Ambient
A.Visual._originalOutdoor     = Lighting.OutdoorAmbient
A.Visual._originalBrightness  = Lighting.Brightness
A.Visual._originalFogStart    = Lighting.FogStart
A.Visual._originalFogEnd      = Lighting.FogEnd
A.Visual._originalFogColor    = Lighting.FogColor
A.Visual._originalTechnology  = Lighting.Technology

A.Visual._fov                 = Workspace.CurrentCamera and Workspace.CurrentCamera.FieldOfView or 70
A.Visual._defaultFOV          = 70

A.Visual._fpsBoostActive      = false
A.Visual._removedEffects      = {}
A.Visual._removedTextures     = {}

A.Visual._antiAFKEnabled      = false
A.Visual._antiAFKConnection   = nil
A.Visual._antiAFKThread       = nil

A.Visual._webhookURL          = ""
A.Visual._webhookEnabled      = false

A.Visual._crosshairGui        = nil
A.Visual._crosshairStyle      = "Cross"

A.Visual._bgMuteEnabled      = false
A.Visual._bgMuteConnection    = nil

A.Visual._running             = false
A.Visual._connections         = {}
A.Visual._configPath          = "apex_visual_config.json"

A.Visual._disabledParticleMains = {}
A.Visual._disabledSounds        = {}

local DEFAULT_CODES = {
	"KittGaming",
	"Sub2Fer999",
	"Enyu_is_Pro",
	"Magicbus",
	"JCWK",
	"StarcodeHEO",
	"Sub2Daigrock",
	"Axiore",
	"TantaiGaming",
	"Blamspot",
	"Sub2NoobMaster123",
	"Sub2UncleKizaru",
	"Sub2Scurter",
	"Sub2CaptainMaui",
	"DIVINESPINO",
	"ADMIN_HAWK",
	"adminhawk",
	"SECRET_ADMIN",
	"CHANDLER",
	"blingbloong",
	"NOOB_REFUND",
	"15B_BEST_BROTHERS",
	"NOOB_2PRO",
	"GAMER_ROBOT_1M",
	"PLZ_DONT_BAN",
	"JeffBubolinaPVP",
	"EXP_5H",
	"RESET_2B",
	"24HR_ADMIN",
}

-- ============================================================================
--  UTILITY HELPERS
-- ============================================================================
local function safeConnect(signal, callback)
	local conn = signal:Connect(callback)
	table.insert(A.Visual._connections, conn)
	return conn
end

local function getCamera()
	return Workspace.CurrentCamera
end

local function tweenProperty(obj, props, duration, style, dir)
	local info = TweenInfo.new(
		duration or 0.5,
		style or Enum.EasingStyle.Quad,
		dir or Enum.EasingDirection.Out
	)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

local function httpPost(url, body, headers)
	local ok, err = pcall(function()
		local resp = game:HttpGet(url, true)
		return resp
	end)
	-- Roblox HttpService alternative for webhooks (usually requires external proxy)
	-- We wrap in pcall so nothing crashes even if unsupported
	return ok, err
end

-- ============================================================================
--  1. FULL BRIGHT MODE
-- ============================================================================

function A.Visual.FullBright()
	A.Visual._fullBrightEnabled = true
	A.Visual._originalAmbient    = Lighting.Ambient
	A.Visual._originalOutdoor    = Lighting.OutdoorAmbient
	A.Visual._originalBrightness = Lighting.Brightness

	Lighting.Ambient       = Color3.fromRGB(255, 255, 255)
	Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
	Lighting.Brightness     = 3
	Lighting.GlobalShadows  = false
	Lighting.ClockTime      = 14
	Lighting.ExposureCompensation = 1
end

function A.Visual.DisableFog()
	A.Visual._fogEnabled    = false
	A.Visual._originalFogStart = Lighting.FogStart
	A.Visual._originalFogEnd   = Lighting.FogEnd
	A.Visual._originalFogColor = Lighting.FogColor

	Lighting.FogStart = 999999
	Lighting.FogEnd   = 999999
	Lighting.FogColor = Color3.fromRGB(255, 255, 255)

	pcall(function()
		for _, v in ipairs(Lighting:GetDescendants()) do
			if v:IsA("Atmosphere") then
				v.Density  = 0
				v.Haze     = 0
				v.Glare    = 0
			end
		end
	end)
end

function A.Visual.RemoveShadows()
	A.Visual._shadowsEnabled = false
	Lighting.GlobalShadows = false

	pcall(function()
		for _, v in ipairs(Lighting:GetDescendants()) do
			if v:IsA("Sky") then
				v.StarCount = 0
				v.SunAngularSize = 0
			end
		end
	end)
end

function A.Visual.BrightAmbient()
	Lighting.Ambient       = Color3.fromRGB(200, 200, 200)
	Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
	Lighting.Brightness     = 4
	Lighting.ClockTime      = 14
	Lighting.GeographicLatitude = 0
	Lighting.ExposureCompensation = 2
end

function A.Visual.ResetLighting()
	A.Visual._fullBrightEnabled = false
	A.Visual._fogEnabled        = true
	A.Visual._shadowsEnabled    = true

	Lighting.Ambient              = A.Visual._originalAmbient
	Lighting.OutdoorAmbient       = A.Visual._originalOutdoor
	Lighting.Brightness           = A.Visual._originalBrightness
	Lighting.GlobalShadows        = true
	Lighting.FogStart             = A.Visual._originalFogStart
	Lighting.FogEnd               = A.Visual._originalFogEnd
	Lighting.FogColor             = A.Visual._originalFogColor
	Lighting.ClockTime            = 12
	Lighting.ExposureCompensation = 0
	Lighting.GeographicLatitude   = 41.733

	pcall(function()
		for _, v in ipairs(Lighting:GetDescendants()) do
			if v:IsA("Atmosphere") then
				v.Density = 0.3
				v.Haze    = 1
			end
			if v:IsA("Sky") then
				v.StarCount       = 3000
				v.SunAngularSize  = 21
			end
		end
	end)

	A.Visual._Notify("Visuals Reset", "Lighting restored to defaults")
end

-- ============================================================================
--  2. FOV CHANGER
-- ============================================================================

function A.Visual.SetFOV(fov)
	fov = math.clamp(fov or 70, 30, 120)
	A.Visual._fov = fov
	local cam = getCamera()
	if cam then
		cam.FieldOfView = fov
	end
end

function A.Visual.ResetFOV()
	A.Visual._fov = A.Visual._defaultFOV
	local cam = getCamera()
	if cam then
		cam.FieldOfView = A.Visual._defaultFOV
	end
end

function A.Visual.MaxFOV()
	A.Visual.SetFOV(120)
end

function A.Visual.FOVSlider(min, max)
	min = min or 30
	max = max or 120
	local current = A.Visual._fov or 70

	local gui = Instance.new("ScreenGui")
	gui.Name = "ApexFOVSlider"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function()
		gui.Parent = CoreGui
	end)
	if not gui.Parent then
		gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 280, 0, 80)
	frame.Position = UDim2.new(0.5, -140, 1, -100)
	frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.Parent = gui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 24)
	title.Position = UDim2.new(0, 10, 0, 4)
	title.BackgroundTransparency = 1
	title.Text = "FOV: " .. tostring(math.floor(current))
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 16
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = frame

	local slider = Instance.new("TextButton")
	slider.Size = UDim2.new(1, -20, 0, 20)
	slider.Position = UDim2.new(0, 10, 0, 32)
	slider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	slider.BorderSizePixel = 0
	slider.Text = ""
	slider.Parent = frame
	Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 6)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	fill.BorderSizePixel = 0
	fill.Parent = slider
	Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 6)

	local dragging = false

	local function updateSlider(inputX)
		local abs = slider.AbsolutePosition.X
		local wid = slider.AbsoluteSize.X
		local pct = math.clamp((inputX - abs) / wid, 0, 1)
		local val = min + pct * (max - min)
		val = math.floor(val)
		fill.Size = UDim2.new(pct, 0, 1, 0)
		title.Text = "FOV: " .. tostring(val)
		A.Visual.SetFOV(val)
	end

	slider.MouseButton1Down:Connect(function()
		dragging = true
	end)

	safeConnect(UserInputService.InputChanged, function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input.Position.X)
		end
	end)

	safeConnect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 60, 0, 24)
	closeBtn.Position = UDim2.new(1, -70, 1, -28)
	closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
	closeBtn.Text = "Close"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.TextSize = 14
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.BorderSizePixel = 0
	closeBtn.Parent = frame
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

	closeBtn.MouseButton1Click:Connect(function()
		gui:Destroy()
	end)

	A.Visual._fovSliderGui = gui
	return gui
end

-- ============================================================================
--  3. FPS BOOSTER
-- ============================================================================

function A.Visual.FPSBoost()
	if A.Visual._fpsBoostActive then
		A.Visual._Notify("FPS Boost", "Already active")
		return
	end
	A.Visual._fpsBoostActive = true

	A.Visual.DisableEffects()
	A.Visual.DisableTextures()
	A.Visual.RemoveShadows()
	A.Visual.DisableFog()

	Lighting.Brightness          = 2
	Lighting.GlobalShadows       = false
	Lighting.ClockTime           = 14
	Lighting.Technology          = Enum.Technology.Compatibility

	Workspace.StreamingEnabled   = true

	Workspace.DescendantAdded:Connect(function(desc)
		if not A.Visual._fpsBoostActive then return end
		if desc:IsA("ParticleEmitter") then
			desc.Enabled = false
		end
		if desc:IsA("Trail") then
			desc.Enabled = false
		end
		if desc:IsA("Beam") then
			desc.Enabled = false
		end
		if desc:IsA("Fire") then
			desc.Enabled = false
		end
		if desc:IsA("Smoke") then
			desc.Enabled = false
		end
		if desc:IsA("Sparkles") then
			desc.Enabled = false
		end
		if desc:IsA("Explosion") then
			desc.Destroying:Connect(function() end)
		end
	end)

	A.Visual._Notify("FPS Boost", "Enabled — particles & textures reduced")
end

function A.Visual.DisableEffects()
	local count = 0
	pcall(function()
		for _, desc in ipairs(Workspace:GetDescendants()) do
			local dominated = false
			if desc:IsA("ParticleEmitter") then
				table.insert(A.Visual._disabledParticleMains, desc)
				desc.Enabled = false
				count = count + 1
				dominated = true
			end
			if desc:IsA("Trail") then
				table.insert(A.Visual._disabledParticleMains, desc)
				desc.Enabled = false
				count = count + 1
				dominated = true
			end
			if desc:IsA("Beam") then
				table.insert(A.Visual._disabledParticleMains, desc)
				desc.Enabled = false
				count = count + 1
				dominated = true
			end
			if desc:IsA("Fire") then
				desc.Enabled = false
				count = count + 1
				dominated = true
			end
			if desc:IsA("Smoke") then
				desc.Enabled = false
				count = count + 1
				dominated = true
			end
			if desc:IsA("Sparkles") then
				desc.Enabled = false
				count = count + 1
				dominated = true
			end
			if desc:IsA("PointLight") then
				desc.Brightness = 0
				count = count + 1
				dominated = true
			end
			if desc:IsA("SpotLight") then
				desc.Brightness = 0
				count = count + 1
				dominated = true
			end
			if desc:IsA("SurfaceLight") then
				desc.Brightness = 0
				count = count + 1
				dominated = true
			end
		end
	end)
	A.Visual._Notify("Effects", count .. " effects disabled")
end

function A.Visual.DisableTextures()
	local count = 0
	pcall(function()
		for _, desc in ipairs(Workspace:GetDescendants()) do
			if desc:IsA("Decal") then
				desc.Transparency = 1
				count = count + 1
			end
			if desc:IsA("Texture") then
				desc.Transparency = 1
				count = count + 1
			end
			if desc:IsA("SurfaceGui") then
				desc.Enabled = false
				count = count + 1
			end
			if desc:IsA("BillboardGui") then
				desc.Enabled = false
				count = count + 1
			end
		end
	end)
	A.Visual._Notify("Textures", count .. " textures disabled")
end

function A.Visual.DisableRendering()
	Workspace.RenderingTarget = "Summary"

	pcall(function()
		for _, part in ipairs(Workspace:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Material = Enum.Material.SmoothPlastic
				part.Reflectance = 0
				part.CastShadow = false
			end
		end
	end)

	A.Visual._Notify("Rendering", "Minimal rendering enabled")
end

function A.Visual.WhiteScreenMode()
	local gui = Instance.new("ScreenGui")
	gui.Name = "ApexWhiteScreen"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 999
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function()
		gui.Parent = CoreGui
	end)
	if not gui.Parent then
		gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame.BorderSizePixel = 0
	frame.Parent = gui

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 120, 0, 40)
	closeBtn.Position = UDim2.new(0.5, -60, 0, 10)
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
	closeBtn.Text = "Close White"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.TextSize = 16
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.BorderSizePixel = 0
	closeBtn.Parent = frame
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

	closeBtn.MouseButton1Click:Connect(function()
		gui:Destroy()
	end)

	A.Visual._whiteScreenGui = gui
	A.Visual._Notify("White Screen", "GPU saving mode active")
	return gui
end

function A.Visual.BlackScreenMode()
	local gui = Instance.new("ScreenGui")
	gui.Name = "ApexBlackScreen"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 999
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function()
		gui.Parent = CoreGui
	end)
	if not gui.Parent then
		gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BorderSizePixel = 0
	frame.Parent = gui

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 120, 0, 40)
	closeBtn.Position = UDim2.new(0.5, -60, 0, 10)
	closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
	closeBtn.Text = "Close Black"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.TextSize = 16
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.BorderSizePixel = 0
	closeBtn.Parent = frame
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

	closeBtn.MouseButton1Click:Connect(function()
		gui:Destroy()
	end)

	A.Visual._blackScreenGui = gui
	A.Visual._Notify("Black Screen", "GPU saving mode active")
	return gui
end

function A.Visual.MinimalRender()
	A.Visual.DisableEffects()
	A.Visual.DisableTextures()
	A.Visual.RemoveShadows()
	A.Visual.DisableFog()

	Lighting.Technology = Enum.Technology.Compatibility
	Lighting.GlobalShadows = false
	Lighting.Brightness = 2
	Workspace.StreamingEnabled = true

	pcall(function()
		for _, obj in ipairs(Workspace:GetDescendants()) do
			if obj:IsA("BasePart") then
				obj.CastShadow = false
				obj.Reflectance = 0
			end
			if obj:IsA("MeshPart") then
				obj.RenderFidelity = Enum.RenderFidelity.Performance
			end
		end
	end)

	A.Visual._Notify("Minimal Render", "All visual extras stripped")
end

function A.Visual.ResetVisuals()
	A.Visual.ResetLighting()

	A.Visual._fpsBoostActive = false

	-- re-enable particles
	for _, pe in ipairs(A.Visual._disabledParticleMains) do
		pcall(function()
			pe.Enabled = true
		end)
	end
	A.Visual._disabledParticleMains = {}

	-- remove screen overlays
	if A.Visual._whiteScreenGui then
		pcall(function() A.Visual._whiteScreenGui:Destroy() end)
		A.Visual._whiteScreenGui = nil
	end
	if A.Visual._blackScreenGui then
		pcall(function() A.Visual._blackScreenGui:Destroy() end)
		A.Visual._blackScreenGui = nil
	end

	A.Visual.ResetFOV()

	A.Visual._Notify("Visual Reset", "All visual settings restored")
end

-- ============================================================================
--  4. ANTI-AFK
-- ============================================================================

function A.Visual.AntiAFK()
	if A.Visual._antiAFKEnabled then
		A.Visual._Notify("Anti-AFK", "Already running")
		return
	end
	A.Visual._antiAFKEnabled = true

	pcall(function()
		local VirtualUser = game:GetService("VirtualUser")
		A.Visual._antiAFKConnection = LocalPlayer.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new(0, 0))
		end)
	end)

	A.Visual._antiAFKThread = task.spawn(function()
		while A.Visual._antiAFKEnabled do
			pcall(function()
				local char = LocalPlayer.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					local root = char.HumanoidRootPart
					local offset = Vector3.new(
						math.random(-2, 2),
						0,
						math.random(-2, 2)
					)
					root.CFrame = root.CFrame + offset
					task.wait(0.1)
					root.CFrame = root.CFrame - offset
				end
			end)
			task.wait(math.random(60, 120))
		end
	end)

	-- Backup: fire position event periodically
	task.spawn(function()
		while A.Visual._antiAFKEnabled do
			task.wait(30)
			pcall(function()
				local VirtualInputManager = game:GetService("VirtualInputManager")
				VirtualInputManager:SendMouseMove()
			end)
		end
	end)

	A.Visual._Notify("Anti-AFK", "Anti-AFK activated — you will not be kicked")
end

function A.Visual.StopAntiAFK()
	A.Visual._antiAFKEnabled = false
	if A.Visual._antiAFKConnection then
		A.Visual._antiAFKConnection:Disconnect()
		A.Visual._antiAFKConnection = nil
	end
	A.Visual._antiAFKThread = nil
	A.Visual._Notify("Anti-AFK", "Stopped")
end

function A.Visual.AFKLoop()
	-- Alias — same as AntiAFK but named for UI wiring
	A.Visual.AntiAFK()
end

-- ============================================================================
--  5. AUTO CODES
-- ============================================================================

function A.Visual.GetCodeList()
	return DEFAULT_CODES
end

function A.Visual.RedeemCode(code)
	if not code or code == "" then
		A.Visual._Notify("Codes", "No code provided")
		return false
	end
	local success, err = pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "Redeeming Code",
			Text = "Trying: " .. code,
			Duration = 2,
		})
	end)

	-- attempt to fire the codes event directly
	local redeemed = false
	pcall(function()
		local remoteEvent = ReplicatedStorage
			and ReplicatedStorage:FindFirstChild("Remotes")
			and ReplicatedStorage.Remotes:FindFirstChild("RedeemCode")
		if remoteEvent and remoteEvent:IsA("RemoteEvent") then
			remoteEvent:FireServer(code)
			redeemed = true
		end
	end)

	pcall(function()
		local remoteEvent = nil
		local rs = game.ReplicatedStorage
		if rs then
			remoteEvent = rs:FindFirstChild("GetModule")
		end
		if not redeemed then
			-- alt path used by some versions
			local alt = game.ReplicatedStorage:FindFirstChild("RedeemCode")
			if alt and alt:IsA("RemoteEvent") then
				alt:FireServer(code)
				redeemed = true
			end
		end
	end)

	if redeemed then
		A.Visual._Notify("Codes", "Sent code: " .. code)
	else
		A.Visual._Notify("Codes", "Could not send code: " .. code)
	end
	return redeemed
end

function A.Visual.AutoRedeemCodes()
	A.Visual._Notify("Codes", "Attempting to redeem " .. #DEFAULT_CODES .. " codes...")
	local redeemed = 0
	local failed   = 0

	for _, code in ipairs(DEFAULT_CODES) do
		local ok = A.Visual.RedeemCode(code)
		if ok then
			redeemed = redeemed + 1
		else
			failed = failed + 1
		end
		task.wait(0.5)
	end

	A.Visual._Notify("Codes", "Done — Redeemed: " .. redeemed .. " | Failed: " .. failed)
	return redeemed, failed
end

-- ============================================================================
--  6. DISCORD WEBHOOK
-- ============================================================================

function A.Visual.SetWebhookURL(url)
	A.Visual._webhookURL = url or ""
	A.Visual._webhookEnabled = (#A.Visual._webhookURL > 0)
	A.Visual._Notify("Webhook", A.Visual._webhookEnabled and "URL set" or "URL cleared")
end

function A.Visual.SendWebhook(data)
	if not A.Visual._webhookEnabled or A.Visual._webhookURL == "" then
		return false
	end

	local payload
	if type(data) == "string" then
		payload = {
			content = data,
			username = "Apex Hub",
		}
	elseif type(data) == "table" then
		data.username = data.username or "Apex Hub"
		payload = data
	else
		return false
	end

	local jsonBody = HttpService:JSONEncode(payload)

	local ok, err = pcall(function()
		-- Roblox limits Http requests; this is a best-effort post
		local http = game:GetService("HttpService"):RequestAsync({
			Url = A.Visual._webhookURL,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
			},
			Body = jsonBody,
		})
		return http
	end)

	if not ok then
		A.Visual._Notify("Webhook", "Send failed: " .. tostring(err))
	end
	return ok
end

function A.Visual.NotifyFruit(fruit)
	local name = tostring(fruit or "Unknown Fruit")
	A.Visual.SendWebhook({
		content = "**Apex Hub** — Fruit Found!",
		embeds = {{
			title = ":star: Fruit Detected",
			description = "**" .. name .. "**",
			color = 16750848,
			fields = {
				{ name = "Server",  value = game.JobId or "N/A",    inline = true },
				{ name = "Player", value = LocalPlayer.Name,        inline = true },
			},
			timestamp = DateTime.now():ToIsoDate(),
		}},
	})
	A.Visual._Notify("Fruit Alert", name)
end

function A.Visual.NotifyLevel(level)
	local lvl = tostring(level or LocalPlayer:FindFirstChild("Data")
		and LocalPlayer.Data:FindFirstChild("Level")
		and LocalPlayer.Data.Level.Value or "?")
	A.Visual.SendWebhook({
		content = "**Apex Hub** — Level Up!",
		embeds = {{
			title = ":arrow_up: Level Up",
			description = "Reached level **" .. lvl .. "**",
			color = 3066993,
			fields = {
				{ name = "Player", value = LocalPlayer.Name, inline = true },
			},
			timestamp = DateTime.now():ToIsoDate(),
		}},
	})
end

function A.Visual.NotifyBoss(boss)
	local name = tostring(boss or "Unknown Boss")
	A.Visual.SendWebhook({
		content = "**Apex Hub** — Boss Defeated!",
		embeds = {{
			title = ":skull: Boss Kill",
			description = "**" .. name .. "** was defeated",
			color = 15158332,
			fields = {
				{ name = "Player", value = LocalPlayer.Name, inline = true },
				{ name = "Server", value = game.JobId or "N/A", inline = true },
			},
			timestamp = DateTime.now():ToIsoDate(),
		}},
	})
end

function A.Visual.NotifyAchievement(ach)
	local name = tostring(ach or "Unknown Achievement")
	A.Visual.SendWebhook({
		content = "**Apex Hub** — Achievement!",
		embeds = {{
			title = ":trophy: Achievement Unlocked",
			description = "**" .. name .. "**",
			color = 16776960,
			fields = {
				{ name = "Player", value = LocalPlayer.Name, inline = true },
			},
			timestamp = DateTime.now():ToIsoDate(),
		}},
	})
end

-- ============================================================================
--  7. CROSSHAIR
-- ============================================================================

function A.Visual.AddCrosshair()
	if A.Visual._crosshairGui then
		A.Visual.RemoveCrosshair()
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "ApexCrosshair"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 900
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function()
		gui.Parent = CoreGui
	end)
	if not gui.Parent then
		gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end

	local container = Instance.new("Frame")
	container.Name = "CrosshairContainer"
	container.Size = UDim2.new(0, 40, 0, 40)
	container.Position = UDim2.new(0.5, -20, 0.5, -20)
	container.BackgroundTransparency = 1
	container.Parent = gui

	A.Visual._crosshairGui = gui
	A.Visual.SetCrosshairStyle(A.Visual._crosshairStyle)
	return gui
end

function A.Visual.RemoveCrosshair()
	if A.Visual._crosshairGui then
		pcall(function() A.Visual._crosshairGui:Destroy() end)
		A.Visual._crosshairGui = nil
	end
end

function A.Visual.SetCrosshairStyle(style)
	style = style or "Cross"
	A.Visual._crosshairStyle = style

	if not A.Visual._crosshairGui then
		A.Visual.AddCrosshair()
	end

	local container = A.Visual._crosshairGui:FindFirstChild("CrosshairContainer")
	if not container then return end

	-- clear old children
	for _, child in ipairs(container:GetChildren()) do
		child:Destroy()
	end

	if style == "Dot" then
		local dot = Instance.new("Frame")
		dot.Name = "Dot"
		dot.Size = UDim2.new(0, 6, 0, 6)
		dot.Position = UDim2.new(0.5, -3, 0.5, -3)
		dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		dot.BorderSizePixel = 0
		dot.Parent = container
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

	elseif style == "Circle" then
		local ring = Instance.new("UIStroke")
		-- We use a Frame with UIStroke for a circle crosshair
		local circleFrame = Instance.new("Frame")
		circleFrame.Name = "Circle"
		circleFrame.Size = UDim2.new(0, 24, 0, 24)
		circleFrame.Position = UDim2.new(0.5, -12, 0.5, -12)
		circleFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		circleFrame.BackgroundTransparency = 1
		circleFrame.BorderSizePixel = 0
		circleFrame.Parent = container
		Instance.new("UICorner", circleFrame).CornerRadius = UDim.new(1, 0)
		ring.Parent = circleFrame
		ring.Color = Color3.fromRGB(255, 255, 255)
		ring.Thickness = 2
		ring.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

		local innerDot = Instance.new("Frame")
		innerDot.Name = "InnerDot"
		innerDot.Size = UDim2.new(0, 3, 0, 3)
		innerDot.Position = UDim2.new(0.5, -1, 0.5, -1)
		innerDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
		innerDot.BorderSizePixel = 0
		innerDot.Parent = circleFrame
		Instance.new("UICorner", innerDot).CornerRadius = UDim.new(1, 0)

	else -- "Cross" (default)
		local hLine = Instance.new("Frame")
		hLine.Name = "HLine"
		hLine.Size = UDim2.new(0, 20, 0, 2)
		hLine.Position = UDim2.new(0.5, -10, 0.5, -1)
		hLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		hLine.BorderSizePixel = 0
		hLine.Parent = container

		local vLine = Instance.new("Frame")
		vLine.Name = "VLine"
		vLine.Size = UDim2.new(0, 2, 0, 20)
		vLine.Position = UDim2.new(0.5, -1, 0.5, -10)
		vLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		vLine.BorderSizePixel = 0
		vLine.Parent = container

		local centerDot = Instance.new("Frame")
		centerDot.Name = "CenterDot"
		centerDot.Size = UDim2.new(0, 4, 0, 4)
		centerDot.Position = UDim2.new(0.5, -2, 0.5, -2)
		centerDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		centerDot.BorderSizePixel = 0
		centerDot.Parent = container
		Instance.new("UICorner", centerDot).CornerRadius = UDim.new(1, 0)
	end
end

-- ============================================================================
--  8. BACKGROUND MUTE
-- ============================================================================

function A.Visual.BackgroundMute()
	if A.Visual._bgMuteEnabled then
		A.Visual._Notify("Mute", "Already active")
		return
	end
	A.Visual._bgMuteEnabled = true

	-- store originals
	A.Visual._originalMuteState = SoundService.AmbientReverb
	A.Visual._originalVolume    = SoundService.AmbientReverb

	SoundService.AmbientReverb = Enum.ReverbType.NoReverb
	SoundService.AmbientReverb = 0

	-- lower all playing sounds
	pcall(function()
		for _, desc in ipairs(SoundService:GetDescendants()) do
			if desc:IsA("Sound") then
				table.insert(A.Visual._disabledSounds, {
					sound  = desc,
					volume = desc.Volume,
				})
				desc.Volume = 0
			end
		end
	end)

	-- Also attempt to mute the game's core sounds
	pcall(function()
		local soundGroups = SoundService:GetChildren()
		for _, sg in ipairs(soundGroups) do
			if sg:IsA("SoundGroup") then
				sg.Volume = 0
			end
		end
	end)

	A.Visual._bgMuteConnection = safeConnect(Workspace.DescendantAdded, function(desc)
		if not A.Visual._bgMuteEnabled then return end
		pcall(function()
			if desc:IsA("Sound") then
				desc.Volume = 0
			end
		end)
	end)

	A.Visual._Notify("Background Mute", "Game sounds muted")
end

function A.Visual.StopBackgroundMute()
	A.Visual._bgMuteEnabled = false

	if A.Visual._bgMuteConnection then
		A.Visual._bgMuteConnection:Disconnect()
		A.Visual._bgMuteConnection = nil
	end

	-- restore stored sounds
	for _, entry in ipairs(A.Visual._disabledSounds) do
		pcall(function()
			if entry.sound and entry.sound.Parent then
				entry.sound.Volume = entry.volume
			end
		end)
	end
	A.Visual._disabledSounds = {}

	-- restore sound groups
	pcall(function()
		local soundGroups = SoundService:GetChildren()
		for _, sg in ipairs(soundGroups) do
			if sg:IsA("SoundGroup") then
				sg.Volume = 1
			end
		end
	end)

	A.Visual._Notify("Background Mute", "Sounds restored")
end

-- ============================================================================
--  9. CONFIG PERSISTENCE
-- ============================================================================

function A.Visual.SaveVisualConfig()
	local config = {
		fullBright     = A.Visual._fullBrightEnabled,
		fogDisabled    = not A.Visual._fogEnabled,
		shadowsOff     = not A.Visual._shadowsEnabled,
		fov            = A.Visual._fov,
		fpsBoost       = A.Visual._fpsBoostActive,
		antiAFK        = A.Visual._antiAFKEnabled,
		webhookURL     = A.Visual._webhookURL,
		crosshairStyle = A.Visual._crosshairStyle,
		bgMute         = A.Visual._bgMuteEnabled,
	}

	local json = HttpService:JSONEncode(config)

	-- save via writefile if available (exploit environments)
	local saved = false
	pcall(function()
		if writefile then
			writefile(A.Visual._configPath, json)
			saved = true
		end
	end)

	pcall(function()
		if not saved then
			-- fallback: use Instance attribute on a persistent object
			sethidden = sethidden or nil
			if sethidden then
				sethidden(workspace, "ApexVisualConfig", json)
				saved = true
			end
		end
	end)

	A.Visual._Notify("Config", saved and "Settings saved" or "Save not supported")
	return saved
end

function A.Visual.LoadVisualConfig()
	local json = nil

	-- load via readfile if available
	pcall(function()
		if readfile then
			json = readfile(A.Visual._configPath)
		end
	end)

	if not json or json == "" then
		A.Visual._Notify("Config", "No saved config found")
		return false
	end

	local ok, config = pcall(function()
		return HttpService:JSONDecode(json)
	end)

	if not ok or type(config) ~= "table" then
		A.Visual._Notify("Config", "Invalid config data")
		return false
	end

	if config.fullBright then
		A.Visual.FullBright()
	end
	if config.fogDisabled then
		A.Visual.DisableFog()
	end
	if config.shadowsOff then
		A.Visual.RemoveShadows()
	end
	if config.fov then
		A.Visual.SetFOV(config.fov)
	end
	if config.fpsBoost then
		A.Visual.FPSBoost()
	end
	if config.antiAFK then
		A.Visual.AntiAFK()
	end
	if config.webhookURL and config.webhookURL ~= "" then
		A.Visual.SetWebhookURL(config.webhookURL)
	end
	if config.crosshairStyle then
		A.Visual._crosshairStyle = config.crosshairStyle
	end
	if config.bgMute then
		A.Visual.BackgroundMute()
	end

	A.Visual._Notify("Config", "Settings loaded successfully")
	return true
end

-- ============================================================================
--  10. NOTIFICATION HELPER
-- ============================================================================

function A.Visual._Notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title or "Apex Hub",
			Text  = text or "",
			Duration = 3,
		})
	end)
end

-- ============================================================================
--  11. MAIN LOOP — runs periodic checks & maintenance
-- ============================================================================

function A.Visual._MainLoop()
	while A.Visual._running do
		task.wait(1)

		-- keep FOV consistent if camera respawns
		pcall(function()
			local cam = getCamera()
			if cam and cam.FieldOfView ~= A.Visual._fov then
				cam.FieldOfView = A.Visual._fov
			end
		end)

		-- if full bright is on, re-apply if lighting changed externally
		if A.Visual._fullBrightEnabled then
			pcall(function()
				if Lighting.Ambient ~= Color3.fromRGB(255, 255, 255) then
					Lighting.Ambient = Color3.fromRGB(255, 255, 255)
					Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
					Lighting.Brightness = 3
				end
				if Lighting.GlobalShadows ~= false then
					Lighting.GlobalShadows = false
				end
			end)
		end

		-- keep fog disabled if toggled
		if not A.Visual._fogEnabled then
			pcall(function()
				if Lighting.FogStart ~= 999999 then
					Lighting.FogStart = 999999
					Lighting.FogEnd   = 999999
				end
			end)
		end

		-- keep shadows off if toggled
		if not A.Visual._shadowsEnabled then
			pcall(function()
				if Lighting.GlobalShadows ~= false then
					Lighting.GlobalShadows = false
				end
			end)
		end
	end
end

-- ============================================================================
--  12. START / STOP
-- ============================================================================

function A.Visual.Start()
	if A.Visual._running then
		A.Visual._Notify("Visual Enhance", "Already running")
		return
	end
	A.Visual._running = true

	A.Visual._Notify("Visual Enhance", "Module started")
	task.spawn(A.Visual._MainLoop)
end

function A.Visual.Stop()
	A.Visual._running = false

	-- disconnect all stored connections
	for _, conn in ipairs(A.Visual._connections) do
		pcall(function()
			conn:Disconnect()
		end)
	end
	A.Visual._connections = {}

	-- stop subsystems
	if A.Visual._antiAFKEnabled then
		A.Visual.StopAntiAFK()
	end
	if A.Visual._bgMuteEnabled then
		A.Visual.StopBackgroundMute()
	end
	A.Visual.RemoveCrosshair()

	A.Visual._Notify("Visual Enhance", "Module stopped")
end

-- ============================================================================
--  13. REGISTER
-- ============================================================================

if A.Register then
	A.Register("visual_enhance", A.Visual)
end

return A.Visual
