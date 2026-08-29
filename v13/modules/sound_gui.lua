local A = _G.Apex
local Mod = {}
Mod.Active = false
Mod.SoundEnabled = true
Mod.SoundVolume = 0.5
Mod.PanicKey = Enum.KeyCode.LeftControl
Mod.HideKey = Enum.KeyCode.F8
Mod.GUIScale = 1
Mod.GUITransparency = 0
Mod.GUIHidden = false
Mod.PanicStop = true

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then end
    return ok, err
end

local SOUND_IDS = {
    notify = "rbxassetid://5070305259",
    levelup = "rbxassetid://9116576339",
    rare = "rbxassetid://2982723035",
    success = "rbxassetid://12221851",
    error = "rbxassetid://138132308",
    goal = "rbxassetid://5070303382",
}

function Mod.PlaySound(soundName, volume)
    if not Mod.SoundEnabled then return end
    soundName = soundName or "notify"
    volume = volume or Mod.SoundVolume
    local lp = A.LP
    if not lp then return end
    local soundId = SOUND_IDS[soundName] or SOUND_IDS.notify
    SafeCall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = volume
        sound.Parent = lp.Character or lp:FindFirstChild("PlayerGui")
        sound:Play()
        task.delay(3, function()
            SafeCall(function() sound:Destroy() end)
        end)
    end)
end

function Mod.NotifySound(title, message, soundName, duration)
    A.Notify(title, message, duration or 2)
    Mod.PlaySound(soundName)
end

function Mod.Panic()
    Mod.HideGui(true)
    if Mod.PanicStop and A.F then
        for k, v in pairs(A.F) do
            if type(v) == "boolean" and v == true then
                A.F[k] = false
            end
        end
    end
    A.Notify("⚠ PANIC", "All toggles off + GUI hidden", 2)
end

function Mod.ToggleAll(on)
    on = on ~= false
    if A.F then
        for k, v in pairs(A.F) do
            if type(v) == "boolean" then
                A.F[k] = on
            end
        end
    end
    A.Notify("GUI", on and "All toggles ON" or "All toggles OFF", 2)
end

function Mod.HideGui(hide)
    Mod.GUIHidden = hide ~= false
    if A.UI and A.UI._windows then
        for _, win in ipairs(A.UI._windows) do
            if win and win._gui then
                SafeCall(function()
                    win._gui.Visible = not Mod.GUIHidden
                end)
            elseif win then
                SafeCall(function()
                    if win.ToggleVisibility then win.ToggleVisibility() end
                end)
            end
        end
    end
end

function Mod.ToggleGui()
    Mod.HideGui(not Mod.GUIHidden)
end

function Mod.SetScale(scale)
    scale = math.clamp(tonumber(scale) or 1, 0.5, 2)
    Mod.GUIScale = scale
    if A.UI and A.UI._scale then
        A.UI._scale = scale
    end
    if A.UI and A.UI.ApplyScale then
        SafeCall(function() A.UI.ApplyScale(scale) end)
    end
end

function Mod.SetTransparency(transparency)
    transparency = math.clamp(tonumber(transparency) or 0, 0, 1)
    Mod.GUITransparency = transparency
    if A.UI and A.UI._transparency then
        A.UI._transparency = transparency
    end
    if A.UI and A.UI.ApplyTransparency then
        SafeCall(function() A.UI.ApplyTransparency(transparency) end)
    end
end

function Mod.HideGuiNow()
    if A.UI and A.UI._activeWindow and A.UI._activeWindow._gui then
        SafeCall(function()
            A.UI._activeWindow._gui.Visible = not Mod.GUIHidden
        end)
    end
end

function Mod.RefreshGUI()
    Mod.HideGui(Mod.GUIHidden)
end

function Mod.Start()
    if Mod.Active then return end
    Mod.Active = true
    Mod._conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if Mod.PanicKey and input.KeyCode == Mod.PanicKey then
            Mod.Panic()
        elseif Mod.HideKey and input.KeyCode == Mod.HideKey then
            Mod.ToggleGui()
        end
    end)
end

function Mod.Stop()
    Mod.Active = false
    if Mod._conn then
        Mod._conn:Disconnect()
        Mod._conn = nil
    end
end

A.SoundGui = Mod
A.Register("sound_gui", A.SoundGui)
