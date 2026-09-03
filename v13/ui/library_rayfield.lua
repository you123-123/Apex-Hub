--[[
    APEX HUB v13 - Rayfield Compatibility Shim
    Lightweight wrapper: Apex API (AddToggle/AddSlider) -> Rayfield API (CreateToggle/CreateSlider)
    Keeps tabs.lua 1976 lines untouched while using Rayfield 2484 lines internally
    Fallback to legacy library if Rayfield fails
]]

local A = _G.Apex or {}
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Rayfield = nil
local RayfieldLoaded = false

-- Try load Rayfield from multiple sources
local function LoadRayfield()
    local sources = {
        "https://sirius.menu/rayfield",
        "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua",
    }
    for _, url in ipairs(sources) do
        local ok, result = pcall(function() return game:HttpGet(url) end)
        if ok and result and #result > 1000 then
            local ok2, lib = pcall(loadstring, result)
            if ok2 and lib then
                local ok3, ray = pcall(lib)
                if ok3 and ray and ray.CreateWindow then
                    return ray
                end
            end
        end
    end
    return nil
end

-- Attempt load, fallback to legacy if fails
Rayfield = LoadRayfield()
if Rayfield then
    RayfieldLoaded = true
    print("[Apex Rayfield] Loaded successfully")
else
    warn("[Apex Rayfield] Failed to load, falling back to legacy library")
    -- FIX: Use relative path only (legacy deleted to save 0.1MB, fallback to pruned library.lua)
    local legacyCode = nil
    if isfile and readfile then
        pcall(function()
            if isfile("ui/library.lua") then legacyCode = readfile("ui/library.lua") end
        end)
    end
    if legacyCode then
        local fn = loadstring(legacyCode)
        if fn then return fn() end
    end
    pcall(function()
        local legacy = loadstring(game:HttpGet("https://raw.githubusercontent.com/you123-123/Apex-Hub/main/v13/ui/library.lua"))()
        return legacy
    end)
    warn("[Apex Rayfield] Both Rayfield and legacy failed - returning minimal stub UI")
    local stub = {Flags={}}
    function stub:CreateWindow() return {CreateTab=function() return {AddSection=function() end, AddToggle=function() end, AddSlider=function() end, AddDropdown=function() end, AddButton=function() end, AddLabel=function() end, AddTextbox=function() end} end} end
    A.UI = stub
    return stub
end

-- Apex Compatibility Layer
local UI = {}
A.UI = UI
UI._rayfield = Rayfield
UI._windows = {}
UI.Flags = Rayfield.Flags

-- Theme compat (Apex had 5 themes, Rayfield has Default/Ocean etc)
function UI.SetTheme(name)
    -- Map Apex theme names to Rayfield
    local map = {Default="Default", Neon="Default", Ocean="Ocean", Red="Amethyst", Midnight="Amethyst"}
    local target = map[name] or "Default"
    -- Rayfield theme is set at window creation, not runtime - just store
    UI._currentTheme = target
end
function UI.GetTheme() return UI._currentTheme or "Default" end
function UI.AddTheme() end
function UI.RemoveTheme() end
function UI.GetThemes() return {"Default","Neon","Ocean","Red","Midnight"} end
function UI.OnThemeChanged() end

-- State compat (Apex used UI.StateStore, Rayfield uses Flags)
function UI.RegisterState(k,v) Rayfield.Flags[k] = {CurrentValue=v} end
function UI.GetState(k,d) local f=Rayfield.Flags[k] return f and f.CurrentValue or d end
function UI.SetState(k,v) if Rayfield.Flags[k] then Rayfield.Flags[k].CurrentValue=v end end
function UI.ClearState(k) Rayfield.Flags[k]=nil end
function UI.SaveState() end
function UI.LoadState() end
function UI.ResetState() end

-- Notification compat
function UI.Notify(cfg)
    if type(cfg)=="string" then cfg={Title=cfg} end
    Rayfield:Notify({Title=cfg.Title or cfg.Name or "Apex", Content=cfg.Content or cfg.Text or "", Duration=cfg.Duration or 3})
end
function UI.Toast(m,s,d) UI.Notify({Title=m, Content=s, Duration=d}) end
function UI.Tooltip() end
function UI.Dialog(cfg) Rayfield:Notify({Title=cfg.Title or "Dialog", Content=cfg.Content or "", Duration=5}) end

-- Animation stubs (Rayfield handles internally)
function UI.Tween(...) end
function UI.TweenWait(...) end
function UI.FadeIn(...) end
function UI.FadeOut(...) end
function UI.SlideIn(...) end
function UI.ScaleIn(...) end
function UI.ShrinkAndFade(...) end
function UI.Bounce(...) end
function UI.Pulse(...) end
function UI.Shake(...) end
function UI.CreateCorner(...) end
function UI.CreateStroke(...) end
function UI.CreateGradient(...) end
function UI.CreatePadding(...) end
function UI.CreateLayout(...) end
function UI.CreateScrollFrame(...) return Instance.new("Frame") end
function UI.CreateText(...) return Instance.new("TextLabel") end
function UI.CreateFrame(...) return Instance.new("Frame") end
function UI.FormatNumber(n) return tostring(n or 0) end
function UI.FormatTime(s) return tostring(s or 0) end
function UI.DeepCopy(o) local c={} for k,v in pairs(o) do c[k]=v end return c end
function UI.SearchBox(...) return Instance.new("Frame") end
function UI.LoadingIndicator(...) return Instance.new("Frame") end

-- Core: CreateWindow compat
function UI.CreateWindow(cfg)
    cfg = cfg or {}
    local win = Rayfield:CreateWindow({
        Name = cfg.Name or "APEX HUB v13.0",
        LoadingTitle = cfg.Name or "Apex Ultimate",
        LoadingSubtitle = "by Apex Team",
        ConfigurationSaving = {Enabled=false},
        Discord = {Enabled=false},
        KeySystem = false,
    })
    -- Wrap Window to add Apex-compatible CreateTab that returns Tab with AddToggle etc
    local origCreateTab = win.CreateTab
    function win:CreateTab(tabCfg)
        tabCfg = tabCfg or {}
        local tab = origCreateTab(win, tabCfg.Name or "Tab", tabCfg.Icon or 4483362458)
        -- Apex compat: AddSection
        local origCreateSection = tab.CreateSection
        function tab:AddSection(name)
            if type(name)=="table" then name=name.Name end
            return origCreateSection(tab, tostring(name or "Section"))
        end
        -- AddToggle: {Name, Flag, Default, Callback} -> {Name, CurrentValue, Flag, Callback}
        function tab:AddToggle(cfg2)
            cfg2 = cfg2 or {}
            return tab:CreateToggle({
                Name = cfg2.Name or "Toggle",
                CurrentValue = cfg2.Default or false,
                Flag = cfg2.Flag,
                Callback = cfg2.Callback or function() end,
            })
        end
        -- AddSlider: {Name, Flag, Min, Max, Default} -> {Name, Range, Increment, CurrentValue}
        function tab:AddSlider(cfg2)
            cfg2 = cfg2 or {}
            return tab:CreateSlider({
                Name = cfg2.Name or "Slider",
                Range = {cfg2.Min or 0, cfg2.Max or 100},
                Increment = cfg2.Increment or 1,
                Suffix = cfg2.Suffix or "",
                CurrentValue = cfg2.Default or cfg2.Min or 0,
                Flag = cfg2.Flag,
                Callback = cfg2.Callback or function() end,
            })
        end
        -- AddDropdown: {Name, Flag, Options, Default} -> {Name, Options, CurrentOption, Flag}
        function tab:AddDropdown(cfg2)
            cfg2 = cfg2 or {}
            local opts = cfg2.Options or {}
            local def = cfg2.Default or opts[1]
            return tab:CreateDropdown({
                Name = cfg2.Name or "Dropdown",
                Options = opts,
                CurrentOption = def and {def} or {opts[1]},
                MultipleOptions = false,
                Flag = cfg2.Flag,
                Callback = cfg2.Callback or function() end,
            })
        end
        -- AddButton
        function tab:AddButton(cfg2)
            cfg2 = cfg2 or {}
            return tab:CreateButton({
                Name = cfg2.Name or "Button",
                Callback = cfg2.Callback or function() end,
            })
        end
        -- AddLabel
        function tab:AddLabel(text, cfg2)
            if type(text)=="table" then text=text.Text or text.Name end
            return tab:CreateLabel(tostring(text or "Label"))
        end
        -- AddParagraph (for compatibility)
        function tab:AddParagraph(cfg2)
            cfg2 = cfg2 or {}
            return tab:CreateParagraph({Title=cfg2.Title or "Info", Content=cfg2.Content or ""})
        end
        -- FIX: Missing APIs that broke 8 tabs (tabs.lua:1158 etc) - was nil
        function tab:AddTextbox(cfg2)
            cfg2=cfg2 or {}
            return tab:CreateInput({
                Name=cfg2.Name or "Textbox",
                PlaceholderText=cfg2.Placeholder or cfg2.PlaceholderText or "",
                CurrentValue=cfg2.Default or "",
                Flag=cfg2.Flag,
                Callback=cfg2.Callback or function() end,
                RemoveTextAfterFocusLost = cfg2.RemoveTextAfterFocusLost or false,
            })
        end
        function tab:AddInput(cfg2) return tab:AddTextbox(cfg2) end
        function tab:AddKeybind(cfg2)
            cfg2=cfg2 or {}
            return tab:CreateKeybind({
                Name=cfg2.Name or "Keybind",
                CurrentKeybind=cfg2.Default or "None",
                HoldToInteract=cfg2.HoldToInteract or false,
                Flag=cfg2.Flag,
                Callback=cfg2.Callback or function() end,
            })
        end
        function tab:AddColorPicker(cfg2)
            cfg2=cfg2 or {}
            return tab:CreateColorPicker({
                Name=cfg2.Name or "ColorPicker",
                Color=cfg2.Default or Color3.fromRGB(255,255,255),
                Flag=cfg2.Flag,
                Callback=cfg2.Callback or function() end,
            })
        end
        function tab:AddParagraph2(cfg2) return tab:AddParagraph(cfg2) end
        return tab
    end
    -- Distinctive Motion: Parallax 3D + Glass (logical, not extreme)
    pcall(function()
        local main = win and win.Main or Rayfield and Rayfield.Main
        if main then
            -- Parallax 3D tilt (subtle, 0.008)
            local RunService = game:GetService("RunService")
            local UserInputService = game:GetService("UserInputService")
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not main or not main.Parent then if conn then conn:Disconnect() end return end
                local mouse = UserInputService:GetMouseLocation()
                local center = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
                local offset = (mouse - center) * 0.008
                pcall(function()
                    main.Position = UDim2.fromOffset(main.AbsolutePosition.X + offset.X*0.02, main.AbsolutePosition.Y + offset.Y*0.02)
                end)
            end)
            pcall(function() Rayfield:Notify({Title="Apex Motion", Content="Glass + Parallax active", Duration=2}) end)
        end
    end)
    -- Command Palette Ctrl+K (not in any Hub)
    pcall(function()
        local UserInputService = game:GetService("UserInputService")
        UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.K and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                local tabs = win and win.Tabs or {}
                local names = {}
                for _, t in ipairs(tabs) do table.insert(names, t.Name or "Tab") end
                Rayfield:Notify({Title="Command Palette", Content="Tabs: "..table.concat(names, ", "), Duration=4})
            end
        end)
    end)
    table.insert(UI._windows, win)
    return win
end

-- Legacy CreateWindow alias
UI.CreateWindow = UI.CreateWindow

return UI
