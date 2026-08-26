--[[
    Apex Hub v13.0 - APEX ULTIMATE
    Custom UI Library - Complete Framework
    Built from scratch - No external dependencies
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

local A = _G.Apex or {}
local LP = A.LP or Players.LocalPlayer
local Mouse = LP:GetMouse()

local UI = {}
A.UI = UI
UI._instances = {}
UI._connections = {}
UI._windows = {}
UI._activeWindow = nil
UI._version = "13.0.0"

local Themes = {}
Themes.Default = {
    Name="Default Dark", Primary=Color3.fromRGB(15,15,15), Secondary=Color3.fromRGB(25,25,25),
    Tertiary=Color3.fromRGB(35,35,35), Quaternary=Color3.fromRGB(45,45,45),
    Accent=Color3.fromRGB(130,0,255), AccentDark=Color3.fromRGB(90,0,180), AccentLight=Color3.fromRGB(170,60,255),
    Text=Color3.fromRGB(255,255,255), TextDim=Color3.fromRGB(160,160,160), TextMuted=Color3.fromRGB(100,100,100),
    Success=Color3.fromRGB(0,200,100), SuccessDark=Color3.fromRGB(0,160,80),
    Warning=Color3.fromRGB(255,170,0), WarningDark=Color3.fromRGB(200,130,0),
    Error=Color3.fromRGB(255,50,50), ErrorDark=Color3.fromRGB(200,30,30),
    Info=Color3.fromRGB(0,150,255), InfoDark=Color3.fromRGB(0,120,220),
    Border=Color3.fromRGB(50,50,50), BorderLight=Color3.fromRGB(70,70,70),
    Shadow=Color3.fromRGB(0,0,0),
    ToggleOff=Color3.fromRGB(60,60,60), ToggleOffKnob=Color3.fromRGB(140,140,140),
    ToggleOn=Color3.fromRGB(130,0,255), ToggleOnKnob=Color3.fromRGB(255,255,255),
    SliderTrack=Color3.fromRGB(40,40,40), SliderFill=Color3.fromRGB(130,0,255), SliderHandle=Color3.fromRGB(255,255,255),
    ButtonDefault=Color3.fromRGB(130,0,255), ButtonHover=Color3.fromRGB(160,40,255),
    ButtonPressed=Color3.fromRGB(100,0,200), ButtonDisabled=Color3.fromRGB(50,50,50),
    Scrollbar=Color3.fromRGB(40,40,40), ScrollbarThumb=Color3.fromRGB(80,80,80), ScrollbarThumbHover=Color3.fromRGB(110,110,110),
    InputBackground=Color3.fromRGB(30,30,30), InputBorder=Color3.fromRGB(60,60,60), InputFocused=Color3.fromRGB(130,0,255),
    DropdownBackground=Color3.fromRGB(28,28,28), DropdownHover=Color3.fromRGB(45,45,45), DropdownSelected=Color3.fromRGB(130,0,255),
    Overlay=Color3.fromRGB(0,0,0), OverlayTransparency=0.5, Transparency=0,
    WindowCornerRadius=10, ElementCornerRadius=8, SmallCornerRadius=6, TinyCornerRadius=4,
}
Themes.Neon = {
    Name="Neon Cyber", Primary=Color3.fromRGB(8,8,18), Secondary=Color3.fromRGB(12,12,28),
    Tertiary=Color3.fromRGB(18,18,38), Quaternary=Color3.fromRGB(24,24,48),
    Accent=Color3.fromRGB(0,255,200), AccentDark=Color3.fromRGB(0,200,160), AccentLight=Color3.fromRGB(80,255,220),
    Text=Color3.fromRGB(210,255,240), TextDim=Color3.fromRGB(120,170,155), TextMuted=Color3.fromRGB(70,100,90),
    Success=Color3.fromRGB(0,255,150), SuccessDark=Color3.fromRGB(0,200,120),
    Warning=Color3.fromRGB(255,255,0), WarningDark=Color3.fromRGB(200,200,0),
    Error=Color3.fromRGB(255,0,100), ErrorDark=Color3.fromRGB(200,0,80),
    Info=Color3.fromRGB(0,200,255), InfoDark=Color3.fromRGB(0,160,220),
    Border=Color3.fromRGB(0,80,60), BorderLight=Color3.fromRGB(0,120,90),
    Shadow=Color3.fromRGB(0,0,0),
    ToggleOff=Color3.fromRGB(30,30,55), ToggleOffKnob=Color3.fromRGB(80,80,110),
    ToggleOn=Color3.fromRGB(0,255,200), ToggleOnKnob=Color3.fromRGB(255,255,255),
    SliderTrack=Color3.fromRGB(25,25,45), SliderFill=Color3.fromRGB(0,255,200), SliderHandle=Color3.fromRGB(255,255,255),
    ButtonDefault=Color3.fromRGB(0,255,200), ButtonHover=Color3.fromRGB(80,255,220),
    ButtonPressed=Color3.fromRGB(0,200,160), ButtonDisabled=Color3.fromRGB(30,30,50),
    Scrollbar=Color3.fromRGB(20,20,40), ScrollbarThumb=Color3.fromRGB(0,120,90), ScrollbarThumbHover=Color3.fromRGB(0,160,120),
    InputBackground=Color3.fromRGB(14,14,32), InputBorder=Color3.fromRGB(0,80,60), InputFocused=Color3.fromRGB(0,255,200),
    DropdownBackground=Color3.fromRGB(12,12,28), DropdownHover=Color3.fromRGB(20,20,44), DropdownSelected=Color3.fromRGB(0,255,200),
    Overlay=Color3.fromRGB(0,0,0), OverlayTransparency=0.55, Transparency=0,
    WindowCornerRadius=12, ElementCornerRadius=10, SmallCornerRadius=8, TinyCornerRadius=5,
}
Themes.Ocean = {
    Name="Ocean Blue", Primary=Color3.fromRGB(10,18,30), Secondary=Color3.fromRGB(15,25,42),
    Tertiary=Color3.fromRGB(20,32,54), Quaternary=Color3.fromRGB(28,42,68),
    Accent=Color3.fromRGB(0,140,255), AccentDark=Color3.fromRGB(0,100,210), AccentLight=Color3.fromRGB(60,170,255),
    Text=Color3.fromRGB(220,240,255), TextDim=Color3.fromRGB(130,160,190), TextMuted=Color3.fromRGB(70,95,120),
    Success=Color3.fromRGB(0,200,140), SuccessDark=Color3.fromRGB(0,160,110),
    Warning=Color3.fromRGB(255,200,50), WarningDark=Color3.fromRGB(220,160,30),
    Error=Color3.fromRGB(255,80,80), ErrorDark=Color3.fromRGB(220,50,50),
    Info=Color3.fromRGB(0,160,255), InfoDark=Color3.fromRGB(0,120,220),
    Border=Color3.fromRGB(30,50,75), BorderLight=Color3.fromRGB(40,65,95),
    Shadow=Color3.fromRGB(0,0,0),
    ToggleOff=Color3.fromRGB(35,50,70), ToggleOffKnob=Color3.fromRGB(90,110,130),
    ToggleOn=Color3.fromRGB(0,140,255), ToggleOnKnob=Color3.fromRGB(255,255,255),
    SliderTrack=Color3.fromRGB(22,35,52), SliderFill=Color3.fromRGB(0,140,255), SliderHandle=Color3.fromRGB(255,255,255),
    ButtonDefault=Color3.fromRGB(0,140,255), ButtonHover=Color3.fromRGB(40,165,255),
    ButtonPressed=Color3.fromRGB(0,110,220), ButtonDisabled=Color3.fromRGB(28,40,55),
    Scrollbar=Color3.fromRGB(18,28,42), ScrollbarThumb=Color3.fromRGB(35,60,90), ScrollbarThumbHover=Color3.fromRGB(50,80,115),
    InputBackground=Color3.fromRGB(12,22,36), InputBorder=Color3.fromRGB(30,48,72), InputFocused=Color3.fromRGB(0,140,255),
    DropdownBackground=Color3.fromRGB(12,22,36), DropdownHover=Color3.fromRGB(24,38,58), DropdownSelected=Color3.fromRGB(0,140,255),
    Overlay=Color3.fromRGB(0,0,0), OverlayTransparency=0.5, Transparency=0,
    WindowCornerRadius=10, ElementCornerRadius=8, SmallCornerRadius=6, TinyCornerRadius=4,
}
Themes.Red = {
    Name="Blood Red", Primary=Color3.fromRGB(18,5,5), Secondary=Color3.fromRGB(28,8,8),
    Tertiary=Color3.fromRGB(38,12,12), Quaternary=Color3.fromRGB(48,16,16),
    Accent=Color3.fromRGB(255,30,30), AccentDark=Color3.fromRGB(200,20,20), AccentLight=Color3.fromRGB(255,80,80),
    Text=Color3.fromRGB(255,225,225), TextDim=Color3.fromRGB(180,120,120), TextMuted=Color3.fromRGB(120,70,70),
    Success=Color3.fromRGB(0,200,100), SuccessDark=Color3.fromRGB(0,160,80),
    Warning=Color3.fromRGB(255,170,0), WarningDark=Color3.fromRGB(200,130,0),
    Error=Color3.fromRGB(255,50,50), ErrorDark=Color3.fromRGB(200,30,30),
    Info=Color3.fromRGB(255,100,100), InfoDark=Color3.fromRGB(200,70,70),
    Border=Color3.fromRGB(70,18,18), BorderLight=Color3.fromRGB(100,28,28),
    Shadow=Color3.fromRGB(0,0,0),
    ToggleOff=Color3.fromRGB(55,12,12), ToggleOffKnob=Color3.fromRGB(120,60,60),
    ToggleOn=Color3.fromRGB(255,30,30), ToggleOnKnob=Color3.fromRGB(255,255,255),
    SliderTrack=Color3.fromRGB(38,10,10), SliderFill=Color3.fromRGB(255,30,30), SliderHandle=Color3.fromRGB(255,255,255),
    ButtonDefault=Color3.fromRGB(255,30,30), ButtonHover=Color3.fromRGB(255,70,70),
    ButtonPressed=Color3.fromRGB(200,20,20), ButtonDisabled=Color3.fromRGB(45,10,10),
    Scrollbar=Color3.fromRGB(35,8,8), ScrollbarThumb=Color3.fromRGB(100,25,25), ScrollbarThumbHover=Color3.fromRGB(140,40,40),
    InputBackground=Color3.fromRGB(22,6,6), InputBorder=Color3.fromRGB(60,14,14), InputFocused=Color3.fromRGB(255,30,30),
    DropdownBackground=Color3.fromRGB(22,6,6), DropdownHover=Color3.fromRGB(40,10,10), DropdownSelected=Color3.fromRGB(255,30,30),
    Overlay=Color3.fromRGB(0,0,0), OverlayTransparency=0.5, Transparency=0,
    WindowCornerRadius=10, ElementCornerRadius=8, SmallCornerRadius=6, TinyCornerRadius=4,
}
Themes.Midnight = {
    Name="Midnight Purple", Primary=Color3.fromRGB(12,12,24), Secondary=Color3.fromRGB(18,18,36),
    Tertiary=Color3.fromRGB(26,26,48), Quaternary=Color3.fromRGB(34,34,56),
    Accent=Color3.fromRGB(120,80,255), AccentDark=Color3.fromRGB(90,50,220), AccentLight=Color3.fromRGB(160,120,255),
    Text=Color3.fromRGB(230,230,245), TextDim=Color3.fromRGB(140,140,170), TextMuted=Color3.fromRGB(80,80,110),
    Success=Color3.fromRGB(50,210,120), SuccessDark=Color3.fromRGB(30,170,90),
    Warning=Color3.fromRGB(255,190,40), WarningDark=Color3.fromRGB(220,160,20),
    Error=Color3.fromRGB(255,60,80), ErrorDark=Color3.fromRGB(220,40,55),
    Info=Color3.fromRGB(60,140,255), InfoDark=Color3.fromRGB(40,110,220),
    Border=Color3.fromRGB(40,40,65), BorderLight=Color3.fromRGB(55,55,80),
    Shadow=Color3.fromRGB(0,0,0),
    ToggleOff=Color3.fromRGB(40,40,60), ToggleOffKnob=Color3.fromRGB(100,100,130),
    ToggleOn=Color3.fromRGB(120,80,255), ToggleOnKnob=Color3.fromRGB(255,255,255),
    SliderTrack=Color3.fromRGB(30,30,50), SliderFill=Color3.fromRGB(120,80,255), SliderHandle=Color3.fromRGB(255,255,255),
    ButtonDefault=Color3.fromRGB(120,80,255), ButtonHover=Color3.fromRGB(145,110,255),
    ButtonPressed=Color3.fromRGB(90,50,220), ButtonDisabled=Color3.fromRGB(32,32,48),
    Scrollbar=Color3.fromRGB(22,22,40), ScrollbarThumb=Color3.fromRGB(45,45,70), ScrollbarThumbHover=Color3.fromRGB(65,65,95),
    InputBackground=Color3.fromRGB(16,16,32), InputBorder=Color3.fromRGB(38,38,60), InputFocused=Color3.fromRGB(120,80,255),
    DropdownBackground=Color3.fromRGB(16,16,32), DropdownHover=Color3.fromRGB(28,28,48), DropdownSelected=Color3.fromRGB(120,80,255),
    Overlay=Color3.fromRGB(0,0,0), OverlayTransparency=0.5, Transparency=0,
    WindowCornerRadius=10, ElementCornerRadius=8, SmallCornerRadius=6, TinyCornerRadius=4,
}
local CurrentTheme = Themes.Default
local ThemeName = "Default"
function UI.SetTheme(themeName) if Themes[themeName] then CurrentTheme=Themes[themeName]; ThemeName=themeName; if UI._themeChangedCallback then UI._themeChangedCallback(CurrentTheme,ThemeName) end else warn("[Apex Hub] Theme '"..tostring(themeName).."' not found.") end end
function UI.GetTheme() return CurrentTheme, ThemeName end
function UI.AddTheme(name,themeData) Themes[name]=themeData end
function UI.RemoveTheme(name) if name~="Default" then Themes[name]=nil end end
function UI.GetThemes() local l={}; for k,_ in pairs(Themes) do table.insert(l,k) end; table.sort(l); return l end
function UI.OnThemeChanged(cb) UI._themeChangedCallback=cb end

-- ═══════════════════════════════════════════════════════════════════════════
-- SECTION: ANIMATION HELPERS
-- ═══════════════════════════════════════════════════════════════════════════
local function createTweenInfo(duration, style, direction, repeatCount, delayTime)
    return TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out, repeatCount or 0, false, delayTime or 0)
end
function UI.Tween(obj, props, duration, style, direction)
    if not obj then return nil end
    local tween = TweenService:Create(obj, createTweenInfo(duration, style, direction), props)
    tween:Play()
    return tween
end
function UI.TweenWait(obj, props, duration, style, direction)
    if not obj then return nil end
    local tween = TweenService:Create(obj, createTweenInfo(duration, style, direction), props)
    tween:Play()
    tween.Completed:Wait()
    return tween
end
function UI.FadeIn(obj, duration)
    if not obj then return nil end
    local tbg = obj:GetAttribute("BaseTransparency")
    if tbg == nil then tbg = 0 end
    obj.BackgroundTransparency = 1
    local props = {BackgroundTransparency = tbg}
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        local tt = obj:GetAttribute("BaseTextTransparency")
        if tt == nil then tt = 0 end
        obj.TextTransparency = 1
        props.TextTransparency = tt
    end
    if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        local ti = obj:GetAttribute("BaseImageTransparency")
        if ti == nil then ti = 0 end
        obj.ImageTransparency = 1
        props.ImageTransparency = ti
    end
    return UI.Tween(obj, props, duration or 0.3)
end
function UI.FadeOut(obj, duration)
    if not obj then return nil end
    if not obj:GetAttribute("BaseTransparency") then obj:SetAttribute("BaseTransparency", obj.BackgroundTransparency) end
    if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) and not obj:GetAttribute("BaseTextTransparency") then obj:SetAttribute("BaseTextTransparency", obj.TextTransparency) end
    if (obj:IsA("ImageLabel") or obj:IsA("ImageButton")) and not obj:GetAttribute("BaseImageTransparency") then obj:SetAttribute("BaseImageTransparency", obj.ImageTransparency) end
    local props = {BackgroundTransparency = 1}
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then props.TextTransparency = 1 end
    if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then props.ImageTransparency = 1 end
    return UI.Tween(obj, props, duration or 0.3)
end
function UI.SlideIn(obj, direction, duration)
    if not obj then return nil end
    local dir = direction or "Left"
    local op = obj.Position
    local sp
    if dir == "Left" then sp = UDim2.new(op.X.Scale-0.15, op.X.Offset-40, op.Y.Scale, op.Y.Offset)
    elseif dir == "Right" then sp = UDim2.new(op.X.Scale+0.15, op.X.Offset+40, op.Y.Scale, op.Y.Offset)
    elseif dir == "Top" then sp = UDim2.new(op.X.Scale, op.X.Offset, op.Y.Scale-0.15, op.Y.Offset-30)
    elseif dir == "Bottom" then sp = UDim2.new(op.X.Scale, op.X.Offset, op.Y.Scale+0.15, op.Y.Offset+30)
    else sp = op end
    obj.Position = sp
    obj.BackgroundTransparency = 1
    return UI.Tween(obj, {Position=op, BackgroundTransparency=obj:GetAttribute("BaseTransparency") or 0}, duration or 0.4, Enum.EasingStyle.Back)
end
function UI.ScaleIn(obj, duration)
    if not obj then return nil end
    local os2 = obj.Size
    obj.Size = UDim2.new(0,0,0,0)
    obj.BackgroundTransparency = 1
    return UI.Tween(obj, {Size=os2, BackgroundTransparency=obj:GetAttribute("BaseTransparency") or 0}, duration or 0.35, Enum.EasingStyle.Back)
end
function UI.ShrinkAndFade(obj, duration)
    if not obj then return nil end
    UI.Tween(obj, {Size=UDim2.new(obj.Size.X.Scale, obj.Size.X.Offset, 0, 0), BackgroundTransparency=1}, duration or 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
end
function UI.Bounce(obj, duration)
    if not obj then return nil end
    local orig = obj.Size
    local dur = duration or 0.4
    local t1 = UI.Tween(obj, {Size=UDim2.new(orig.X.Scale, orig.X.Offset+6, orig.Y.Scale, orig.Y.Offset+6)}, dur*0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    if t1 then t1.Completed:Connect(function()
        local t2 = UI.Tween(obj, {Size=UDim2.new(orig.X.Scale, orig.X.Offset-2, orig.Y.Scale, orig.Y.Offset-2)}, dur*0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        if t2 then t2.Completed:Connect(function() UI.Tween(obj, {Size=orig}, dur*0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) end) end
    end) end
end
function UI.Pulse(obj, duration)
    if not obj then return nil end
    local orig = obj.Size
    local dur = duration or 0.5
    local t1 = UI.Tween(obj, {Size=UDim2.new(orig.X.Scale, orig.X.Offset+4, orig.Y.Scale, orig.Y.Offset+4)}, dur*0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    if t1 then t1.Completed:Connect(function() UI.Tween(obj, {Size=orig}, dur*0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut) end) end
end
function UI.Shake(obj, intensity, duration)
    if not obj then return nil end
    local orig = obj.Position
    local steps = 8
    local stepDur = (duration or 0.4)/steps
    task.spawn(function()
        for i = 1, steps do
            local offset = (i % 2 == 0) and intensity or -intensity
            local decay = 1 - (i/steps)
            UI.Tween(obj, {Position=UDim2.new(orig.X.Scale, orig.X.Offset+offset*decay, orig.Y.Scale, orig.Y.Offset)}, stepDur)
            task.wait(stepDur)
        end
        obj.Position = orig
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SECTION: UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════
function UI.CreateCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or CurrentTheme.ElementCornerRadius)
    c.Parent = parent
    return c
end
function UI.CreateStroke(parent, color, thickness, transparency, mode)
    local s = Instance.new("UIStroke")
    s.Color = color or CurrentTheme.Border
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.5
    s.ApplyStrokeMode = mode or Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end
function UI.CreateGradient(parent, colors, rotation, transparency)
    local g = Instance.new("UIGradient")
    g.Color = colors or ColorSequence.new({ColorSequenceKeypoint.new(0, CurrentTheme.Accent), ColorSequenceKeypoint.new(1, CurrentTheme.AccentDark)})
    g.Rotation = rotation or 45
    if transparency then g.Transparency = transparency end
    g.Parent = parent
    return g
end
function UI.CreatePadding(parent, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, t or 8)
    p.PaddingBottom = UDim.new(0, b or 8)
    p.PaddingLeft = UDim.new(0, l or 8)
    p.PaddingRight = UDim.new(0, r or 8)
    p.Parent = parent
    return p
end
function UI.CreateLayout(parent, direction, padding, fill, hAlign, vAlign, sort)
    local l = Instance.new("UIListLayout")
    l.FillDirection = direction or Enum.FillDirection.Vertical
    l.Padding = UDim.new(0, padding or 6)
    l.FillMode = fill or Enum.FillMode.Y
    l.HorizontalAlignment = hAlign or Enum.HorizontalAlignment.Left
    l.VerticalAlignment = vAlign or Enum.VerticalAlignment.Top
    l.SortOrder = sort or Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end
function UI.CreateScrollFrame(parent, config)
    local cfg = config or {}
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = cfg.Name or "ScrollFrame"
    scroll.Size = cfg.Size or UDim2.new(1, 0, 1, 0)
    scroll.Position = cfg.Position or UDim2.new(0, 0, 0, 0)
    scroll.BackgroundTransparency = cfg.BackgroundTransparency or 1
    scroll.BackgroundColor3 = cfg.BackgroundColor or Color3.fromRGB(0, 0, 0)
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = cfg.ScrollBarThickness or 5
    scroll.ScrollBarImageColor3 = cfg.ScrollBarColor or CurrentTheme.ScrollbarThumb
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    scroll.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    scroll.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    scroll.ElasticBehavior = Enum.ElasticBehavior.Never
    scroll.Parent = parent
    if cfg.Corner then UI.CreateCorner(scroll, cfg.Corner) end
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 0, 0)
    contentFrame.AutomaticSize = Enum.AutomaticSize.Y
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = scroll
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = cfg.LayoutDirection or Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, cfg.Padding or 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.Parent = contentFrame
    UI.CreatePadding(contentFrame, cfg.PaddingTop or 8, cfg.PaddingBottom or 8, cfg.PaddingLeft or 8, cfg.PaddingRight or 8)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + (cfg.PaddingTop or 8) + (cfg.PaddingBottom or 8) + 4)
    end)
    return scroll, contentFrame
end
function UI.CreateText(parent, config)
    local cfg = config or {}
    local t = Instance.new("TextLabel")
    t.Name = cfg.Name or "Text"
    t.Size = cfg.Size or UDim2.new(1, 0, 0, 20)
    t.Position = cfg.Position or UDim2.new(0, 0, 0, 0)
    t.BackgroundTransparency = 1
    t.TextColor3 = cfg.Color or CurrentTheme.Text
    t.Font = cfg.Font or Enum.Font.GothamMedium
    t.TextSize = cfg.TextSize or 14
    t.Text = cfg.Text or ""
    t.TextXAlignment = cfg.XAlign or Enum.TextXAlignment.Left
    t.TextYAlignment = cfg.YAlign or Enum.TextYAlignment.Center
    t.TextWrapped = cfg.Wrapped ~= false
    t.TextTruncate = cfg.Truncate or Enum.TextTruncate.None
    t.TextTransparency = cfg.Transparency or 0
    t.RichText = cfg.Rich or false
    t.LayoutOrder = cfg.Order or 0
    t.Parent = parent
    return t
end
function UI.CreateFrame(parent, config)
    local cfg = config or {}
    local f = Instance.new("Frame")
    f.Name = cfg.Name or "Frame"
    f.Size = cfg.Size or UDim2.new(1, 0, 0, 50)
    f.Position = cfg.Position or UDim2.new(0, 0, 0, 0)
    f.BackgroundColor3 = cfg.BackgroundColor or CurrentTheme.Secondary
    f.BackgroundTransparency = cfg.Transparency or 0
    f.BorderSizePixel = 0
    f.ClipsDescendants = cfg.Clips or false
    f.LayoutOrder = cfg.Order or 0
    f.ZIndex = cfg.ZIndex or 1
    f.Parent = parent
    if cfg.Corner then UI.CreateCorner(f, cfg.Corner) end
    if cfg.Stroke then UI.CreateStroke(f, cfg.StrokeColor, cfg.StrokeThickness, cfg.StrokeTransparency) end
    if cfg.Gradient then
        local grad = UI.CreateGradient(f, cfg.GradientColors, cfg.GradientRotation)
        if cfg.GradientTransparency then grad.Transparency = cfg.GradientTransparency end
    end
    return f
end
function UI.FormatNumber(num)
    if not num then return "0" end
    if num >= 1e9 then return string.format("%.1fB", num/1e9)
    elseif num >= 1e6 then return string.format("%.1fM", num/1e6)
    elseif num >= 1e3 then return string.format("%.1fK", num/1e3) end
    return tostring(math.floor(num))
end
function UI.FormatTime(s)
    if not s then return "00:00" end
    local h=math.floor(s/3600); local m=math.floor((s%3600)/60); local sec=math.floor(s%60)
    if h > 0 then return string.format("%02d:%02d:%02d", h, m, sec) end
    return string.format("%02d:%02d", m, sec)
end
function UI.DeepCopy(o)
    local c = {}
    for k, v in pairs(o) do if type(v) == "table" then c[k] = UI.DeepCopy(v) else c[k] = v end end
    return c
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SECTION: STATE MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════
local StateStore = {}
local StateDefaults = {}
function UI.RegisterState(key, default) StateDefaults[key] = default; if StateStore[key] == nil then StateStore[key] = default end end
function UI.GetState(key, default) if StateStore[key] ~= nil then return StateStore[key] end; return default or StateDefaults[key] end
function UI.SetState(key, value) StateStore[key] = value end
function UI.ClearState(key) StateStore[key] = StateDefaults[key] end
function UI.SaveState()
    local data = {}
    for k, v in pairs(StateStore) do
        if type(v) == "Color3" then data[k] = {_type="Color3", R=v.R, G=v.G, B=v.B} else data[k] = v end
    end
    pcall(function() if writefile then writefile("ApexHub_v13_state.json", HttpService:JSONEncode(data)) end end)
end
function UI.LoadState()
    pcall(function()
        if readfile and isfile and isfile("ApexHub_v13_state.json") then
            local data = HttpService:JSONDecode(readfile("ApexHub_v13_state.json"))
            for k, v in pairs(data) do
                if type(v) == "table" and v._type == "Color3" then StateStore[k] = Color3.new(v.R, v.G, v.B) else StateStore[k] = v end
            end
        end
    end)
end
function UI.ResetState() for k, v in pairs(StateDefaults) do StateStore[k] = v end end

-- ═══════════════════════════════════════════════════════════════════════════
-- SECTION: NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════
local NotificationGui = nil
local NotificationHolder = nil
local NotificationCount = 0
local MaxNotifications = 5
local NotificationQueue = {}
local NotificationStyles = {
    Info = {Icon="\226\136\128", GetColor=function() return CurrentTheme.Info end},
    Success = {Icon="\226\156\147", GetColor=function() return CurrentTheme.Success end},
    Warning = {Icon="\226\154\160", GetColor=function() return CurrentTheme.Warning end},
    Error = {Icon="\226\156\151", GetColor=function() return CurrentTheme.Error end},
}
local function EnsureNotificationGui()
    if NotificationGui and NotificationGui.Parent then return end
    NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = "ApexHub_Notifications"
    NotificationGui.ResetOnSpawn = false
    NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NotificationGui.DisplayOrder = 999
    pcall(function() NotificationGui.Parent = CoreGui end)
    if not NotificationGui.Parent then pcall(function() NotificationGui.Parent = LP:WaitForChild("PlayerGui") end) end
    NotificationHolder = Instance.new("Frame")
    NotificationHolder.Name = "Holder"
    NotificationHolder.Size = UDim2.new(0, 340, 1, 0)
    NotificationHolder.Position = UDim2.new(1, -350, 0, 10)
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.Parent = NotificationGui
    local h = Instance.new("UIListLayout"); h.FillDirection=Enum.FillDirection.Vertical; h.Padding=UDim.new(0,8); h.SortOrder=Enum.SortOrder.LayoutOrder; h.VerticalAlignment=Enum.VerticalAlignment.Top; h.Parent=NotificationHolder
end
function UI.Notify(config)
    EnsureNotificationGui()
    local cfg = type(config) == "string" and {Title="Apex Hub", Text=config, Style="Info", Duration=3} or (config or {})
    local styleName = cfg.Style or "Info"
    local style = NotificationStyles[styleName] or NotificationStyles.Info
    local duration = cfg.Duration or 3
    if NotificationCount >= MaxNotifications then table.insert(NotificationQueue, cfg); return end
    NotificationCount = NotificationCount + 1
    local notifIndex = NotificationCount
    local accentColor = style.GetColor()
    local nf = Instance.new("Frame")
    nf.Name = "Notification_"..notifIndex
    nf.Size = UDim2.new(1, 0, 0, 70)
    nf.Position = UDim2.new(1, 0, 0, 0)
    nf.BackgroundColor3 = CurrentTheme.Secondary
    nf.BackgroundTransparency = 0.02
    nf.BorderSizePixel = 0; nf.ClipsDescendants = true
    nf.LayoutOrder = notifIndex; nf.Parent = NotificationHolder
    UI.CreateCorner(nf, 10)
    UI.CreateStroke(nf, accentColor, 1.5, 0.4)
    local as = Instance.new("Frame"); as.Size=UDim2.new(0,4,1,-14); as.Position=UDim2.new(0,6,0,7); as.BackgroundColor3=accentColor; as.BorderSizePixel=0; as.Parent=nf; UI.CreateCorner(as,2)
    local il = Instance.new("TextLabel"); il.Size=UDim2.new(0,32,0,32); il.Position=UDim2.new(0,16,0,8); il.BackgroundTransparency=1; il.Text=style.Icon; il.TextColor3=accentColor; il.TextSize=22; il.Font=Enum.Font.GothamBold; il.Parent=nf
    local tl = Instance.new("TextLabel"); tl.Size=UDim2.new(1,-80,0,20); tl.Position=UDim2.new(0,52,0,8); tl.BackgroundTransparency=1; tl.Text=cfg.Title or "Apex Hub"; tl.TextColor3=CurrentTheme.Text; tl.Font=Enum.Font.GothamBold; tl.TextSize=13; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.TextTruncate=Enum.TextTruncate.AtEnd; tl.Parent=nf
    local ml = Instance.new("TextLabel"); ml.Size=UDim2.new(1,-80,0,28); ml.Position=UDim2.new(0,52,0,30); ml.BackgroundTransparency=1; ml.Text=cfg.Text or ""; ml.TextColor3=CurrentTheme.TextDim; ml.Font=Enum.Font.Gotham; ml.TextSize=11; ml.TextXAlignment=Enum.TextXAlignment.Left; ml.TextYAlignment=Enum.TextYAlignment.Top; ml.TextWrapped=true; ml.Parent=nf
    local cb = Instance.new("TextButton"); cb.Size=UDim2.new(0,20,0,20); cb.Position=UDim2.new(1,-26,0,6); cb.BackgroundTransparency=1; cb.Text="\195\151"; cb.TextColor3=CurrentTheme.TextDim; cb.TextSize=14; cb.Font=Enum.Font.GothamBold; cb.Parent=nf
    local pbg = Instance.new("Frame"); pbg.Size=UDim2.new(1,-16,0,3); pbg.Position=UDim2.new(0,8,1,-7); pbg.BackgroundColor3=CurrentTheme.Tertiary; pbg.BorderSizePixel=0; pbg.Parent=nf; UI.CreateCorner(pbg,2)
    local pf = Instance.new("Frame"); pf.Size=UDim2.new(1,0,1,0); pf.BackgroundColor3=accentColor; pf.BorderSizePixel=0; pf.Parent=pbg; UI.CreateCorner(pf,2)
    local dismissed = false
    local function dismissNotif()
        if dismissed then return end; dismissed = true
        UI.Tween(nf, {Position=UDim2.new(1,0,0,nf.Position.Y.Offset), BackgroundTransparency=1}, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        task.delay(0.35, function()
            if nf and nf.Parent then nf:Destroy() end
            NotificationCount = math.max(0, NotificationCount-1)
            if #NotificationQueue > 0 then local nn = table.remove(NotificationQueue, 1); task.defer(function() UI.Notify(nn) end) end
        end)
    end
    cb.MouseButton1Click:Connect(dismissNotif)
    nf.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dismissNotif() end end)
    nf.Position = UDim2.new(1,0,0,0)
    UI.Tween(nf, {Position=UDim2.new(0,0,0,0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local startTime = tick()
    local progressConn
    progressConn = RunService.Heartbeat:Connect(function()
        if dismissed then progressConn:Disconnect(); return end
        local elapsed = tick()-startTime
        pf.Size = UDim2.new(math.max(0, 1-elapsed/duration), 0, 1, 0)
        if elapsed >= duration then progressConn:Disconnect(); dismissNotif() end
    end)
    return {Dismiss=dismissNotif, Frame=nf}
end
function A.Notify(title, text, dur)
    return UI.Notify({Title=title or "Apex Hub", Text=text or "", Style="Info", Duration=dur or 3})
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SECTION: TOOLTIP SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════
local TooltipGui, TooltipFrame, TooltipLabel, TooltipActive = nil, nil, nil, false
local function EnsureTooltip()
    if TooltipGui and TooltipGui.Parent then return end
    TooltipGui = Instance.new("ScreenGui"); TooltipGui.Name="ApexTooltip"; TooltipGui.ResetOnSpawn=false; TooltipGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; TooltipGui.DisplayOrder=1000
    pcall(function() TooltipGui.Parent = CoreGui end)
    if not TooltipGui.Parent then pcall(function() TooltipGui.Parent = LP:WaitForChild("PlayerGui") end) end
    TooltipFrame = Instance.new("Frame"); TooltipFrame.Size=UDim2.new(0,200,0,30); TooltipFrame.BackgroundColor3=CurrentTheme.Primary; TooltipFrame.BorderSizePixel=0; TooltipFrame.Visible=false; TooltipFrame.ZIndex=1001; TooltipFrame.Parent=TooltipGui
    UI.CreateCorner(TooltipFrame, 6); UI.CreateStroke(TooltipFrame, CurrentTheme.Accent, 1, 0.5)
    TooltipLabel = Instance.new("TextLabel"); TooltipLabel.Size=UDim2.new(1,-12,1,-4); TooltipLabel.Position=UDim2.new(0,6,0,2); TooltipLabel.BackgroundTransparency=1; TooltipLabel.TextColor3=CurrentTheme.Text; TooltipLabel.Font=Enum.Font.Gotham; TooltipLabel.TextSize=12; TooltipLabel.TextWrapped=true; TooltipLabel.TextXAlignment=Enum.TextXAlignment.Left; TooltipLabel.ZIndex=1002; TooltipLabel.Parent=TooltipFrame
end
function UI.Tooltip(text, element)
    EnsureTooltip()
    if not element then return end
    local function show()
        TooltipActive = true; TooltipLabel.Text = text or ""
        local ts = TextService:GetTextSize(text or "", 12, Enum.Font.Gotham, Vector2.new(250, 200))
        local w = math.clamp(ts.X+16, 60, 250); local h = math.clamp(ts.Y+8, 24, 100)
        TooltipFrame.Size = UDim2.new(0,w,0,h)
        local mp = UserInputService:GetMouseLocation()
        local px, py = mp.X+12, mp.Y+12
        if px+w > workspace.CurrentCamera.ViewportSize.X then px = mp.X-w-4 end
        if py+h > workspace.CurrentCamera.ViewportSize.Y then py = mp.Y-h-4 end
        TooltipFrame.Position = UDim2.new(0,px,0,py); TooltipFrame.Visible=true; TooltipFrame.BackgroundTransparency=1; TooltipLabel.TextTransparency=1
        UI.Tween(TooltipFrame, {BackgroundTransparency=0}, 0.15); UI.Tween(TooltipLabel, {TextTransparency=0}, 0.15)
    end
    local function hide()
        TooltipActive = false; UI.Tween(TooltipFrame, {BackgroundTransparency=1}, 0.1); UI.Tween(TooltipLabel, {TextTransparency=1}, 0.1)
        task.delay(0.12, function() if not TooltipActive then TooltipFrame.Visible = false end end)
    end
    element.MouseEnter:Connect(show); element.MouseLeave:Connect(hide)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SECTION: DIALOG SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════
function UI.Dialog(config)
    EnsureNotificationGui()
    local cfg = config or {}
    local title = cfg.Title or "Confirm"
    local text = cfg.Text or "Are you sure?"
    local buttons = cfg.Buttons or {{Text="OK",Style="Primary",Result=true},{Text="Cancel",Style="Secondary",Result=false}}
    local callback = cfg.Callback or function() end
    local overlay = Instance.new("Frame"); overlay.Size=UDim2.new(1,0,1,0); overlay.BackgroundColor3=CurrentTheme.Overlay; overlay.BackgroundTransparency=0.5; overlay.BorderSizePixel=0; overlay.ZIndex=900; overlay.Parent=NotificationHolder
    local df = Instance.new("Frame"); df.Size=UDim2.new(0,380,0,200); df.Position=UDim2.new(0.5,-190,0.5,-100); df.BackgroundColor3=CurrentTheme.Secondary; df.BorderSizePixel=0; df.ZIndex=901; df.ClipsDescendants=true; df.Parent=NotificationHolder
    UI.CreateCorner(df, 12); UI.CreateStroke(df, CurrentTheme.Accent, 1.5, 0.4)
    local al = Instance.new("Frame"); al.Size=UDim2.new(1,0,0,3); al.BackgroundColor3=CurrentTheme.Accent; al.BorderSizePixel=0; al.ZIndex=902; al.Parent=df
    local tl = Instance.new("TextLabel"); tl.Size=UDim2.new(1,-24,0,30); tl.Position=UDim2.new(0,12,0,14); tl.BackgroundTransparency=1; tl.Text=title; tl.TextColor3=CurrentTheme.Text; tl.Font=Enum.Font.GothamBold; tl.TextSize=16; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.ZIndex=902; tl.Parent=df
    local txl = Instance.new("TextLabel"); txl.Size=UDim2.new(1,-24,0,50); txl.Position=UDim2.new(0,12,0,46); txl.BackgroundTransparency=1; txl.Text=text; txl.TextColor3=CurrentTheme.TextDim; txl.Font=Enum.Font.Gotham; txl.TextSize=13; txl.TextWrapped=true; txl.TextXAlignment=Enum.TextXAlignment.Left; txl.TextYAlignment=Enum.TextYAlignment.Top; txl.ZIndex=902; txl.Parent=df
    local bc = Instance.new("Frame"); bc.Size=UDim2.new(1,-24,0,36); bc.Position=UDim2.new(0,12,1,-48); bc.BackgroundTransparency=1; bc.ZIndex=902; bc.Parent=df
    local bl = Instance.new("UIListLayout"); bl.FillDirection=Enum.FillDirection.Horizontal; bl.HorizontalAlignment=Enum.HorizontalAlignment.Right; bl.Padding=UDim.new(0,8); bl.SortOrder=Enum.SortOrder.LayoutOrder; bl.Parent=bc
    local function closeDialog()
        UI.ShrinkAndFade(df, 0.25); UI.FadeOut(overlay, 0.25)
        task.delay(0.3, function() if overlay and overlay.Parent then overlay:Destroy() end; if df and df.Parent then df:Destroy() end end)
    end
    overlay.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then closeDialog() end end)
    for i, btn in ipairs(buttons) do
        local bf = Instance.new("TextButton"); bf.Size=UDim2.new(0,90,0,34); bf.BackgroundColor3=btn.Style=="Primary" and CurrentTheme.Accent or CurrentTheme.Tertiary; bf.BorderSizePixel=0; bf.ZIndex=903; bf.LayoutOrder=i; bf.Text=""; bf.Parent=bc
        UI.CreateCorner(bf, 6)
        local bt = Instance.new("TextLabel"); bt.Size=UDim2.new(1,0,1,0); bt.BackgroundTransparency=1; bt.Text=btn.Text or "Button"; bt.TextColor3=CurrentTheme.Text; bt.Font=Enum.Font.GothamBold; bt.TextSize=13; bt.ZIndex=904; bt.Parent=bf
        bf.MouseEnter:Connect(function() UI.Tween(bf, {BackgroundColor3=btn.Style=="Primary" and CurrentTheme.ButtonHover or CurrentTheme.AccentDark}, 0.15) end)
        bf.MouseLeave:Connect(function() UI.Tween(bf, {BackgroundColor3=btn.Style=="Primary" and CurrentTheme.Accent or CurrentTheme.Tertiary}, 0.15) end)
        bf.MouseButton1Click:Connect(function() UI.Bounce(bf, 0.3); task.delay(0.15, function() closeDialog(); callback(btn.Result, btn) end) end)
    end
    df.Size = UDim2.new(0,0,0,0); df.Position = UDim2.new(0.5,0,0.5,0); overlay.BackgroundTransparency=1
    UI.Tween(overlay, {BackgroundTransparency=0.5}, 0.3); UI.ScaleIn(df, 0.35)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SECTION: WINDOW CREATION
-- ═══════════════════════════════════════════════════════════════════════════
local WindowCount = 0
function UI.CreateWindow(config)
    local cfg = config or {}
    WindowCount = WindowCount + 1
    local Window = {}; Window.Id=WindowCount; Window.Tabs={}; Window.CurrentTab=nil; Window.Visible=true; Window.Minimized=false
    local ss = workspace.CurrentCamera.ViewportSize
    local winW = cfg.Width or 600; local winH = cfg.Height or 500
    local winX = cfg.X or math.floor((ss.X-winW)/2); local winY = cfg.Y or math.floor((ss.Y-winH)/2)
    local sg = Instance.new("ScreenGui"); sg.Name="ApexHub_v13_"..WindowCount; sg.ResetOnSpawn=false; sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.DisplayOrder=100+WindowCount
    pcall(function() sg.Parent=CoreGui end); if not sg.Parent then pcall(function() sg.Parent=LP:WaitForChild("PlayerGui") end) end
    Window.Gui = sg
    local shadow = Instance.new("ImageLabel"); shadow.Name="Shadow"; shadow.Size=UDim2.new(1,50,1,50); shadow.Position=UDim2.new(0,-25,0,-25); shadow.BackgroundTransparency=1; shadow.Image="rbxassetid=5554236805"; shadow.ImageColor3=Color3.fromRGB(0,0,0); shadow.ImageTransparency=0.6; shadow.ScaleType=Enum.ScaleType.Slice; shadow.SliceCenter=Rect.new(23,23,277,277); shadow.Parent=sg
    local mf = Instance.new("Frame"); mf.Name="MainFrame"; mf.Size=UDim2.new(0,winW,0,winH); mf.Position=UDim2.new(0,winX,0,winY); mf.BackgroundColor3=CurrentTheme.Primary; mf.BackgroundTransparency=CurrentTheme.Transparency or 0; mf.BorderSizePixel=0; mf.ClipsDescendants=true; mf.Parent=sg; Window.MainFrame=mf
    UI.CreateCorner(mf, 10); UI.CreateStroke(mf, CurrentTheme.Accent, 1, 0.6)
    local ta = Instance.new("Frame"); ta.Size=UDim2.new(1,0,0,3); ta.BackgroundColor3=CurrentTheme.Accent; ta.BorderSizePixel=0; ta.Parent=mf
    UI.CreateGradient(ta, ColorSequence.new({ColorSequenceKeypoint.new(0,CurrentTheme.Accent),ColorSequenceKeypoint.new(0.5,CurrentTheme.AccentDark),ColorSequenceKeypoint.new(1,CurrentTheme.Accent)}), 0)
    local tb = Instance.new("Frame"); tb.Name="TitleBar"; tb.Size=UDim2.new(1,0,0,38); tb.Position=UDim2.new(0,0,0,3); tb.BackgroundColor3=CurrentTheme.Secondary; tb.BackgroundTransparency=0.3; tb.BorderSizePixel=0; tb.Parent=mf
    local tt = Instance.new("TextLabel"); tt.Size=UDim2.new(1,-140,0,20); tt.Position=UDim2.new(0,14,0,0); tt.BackgroundTransparency=1; tt.Text=cfg.Title or "APEX HUB v13.0 - APEX ULTIMATE"; tt.TextColor3=CurrentTheme.Text; tt.Font=Enum.Font.GothamBlack; tt.TextSize=14; tt.TextXAlignment=Enum.TextXAlignment.Left; tt.Parent=tb
    local vl = Instance.new("TextLabel"); vl.Size=UDim2.new(1,-140,0,14); vl.Position=UDim2.new(0,14,0,18); vl.BackgroundTransparency=1; vl.Text=cfg.Version or ("v13.0 | Build "..math.random(1000,9999)); vl.TextColor3=CurrentTheme.TextDim; vl.Font=Enum.Font.Gotham; vl.TextSize=10; vl.TextXAlignment=Enum.TextXAlignment.Left; vl.Parent=tb
    local pi = Instance.new("TextLabel"); pi.Size=UDim2.new(1,-140,0,12); pi.Position=UDim2.new(0,14,0,32); pi.BackgroundTransparency=1; pi.Text="Player: "..LP.Name.." | ID: "..LP.UserId; pi.TextColor3=CurrentTheme.TextDim; pi.Font=Enum.Font.Gotham; pi.TextSize=9; pi.TextXAlignment=Enum.TextXAlignment.Left; pi.Parent=tb
    local fp = Instance.new("TextLabel"); fp.Size=UDim2.new(0,170,0,14); fp.Position=UDim2.new(1,-290,0,3); fp.BackgroundTransparency=1; fp.Text="FPS: -- | Ping: --ms"; fp.TextColor3=CurrentTheme.TextDim; fp.Font=Enum.Font.Gotham; fp.TextSize=10; fp.TextXAlignment=Enum.TextXAlignment.Right; fp.Parent=tb
    local lastFU, fpsFr = 0, 0
    local fpsConn = RunService.Heartbeat:Connect(function(dt)
        fpsFr=fpsFr+1; lastFU=lastFU+dt
        if lastFU >= 0.5 then
            local fps = math.round(fpsFr/lastFU); local ping="--"
            pcall(function() ping=tostring(math.round(LP:GetNetworkPing()*1000)) end)
            if fp and fp.Parent then fp.Text="FPS: "..fps.." | Ping: "..ping.."ms"
                if fps >= 50 then fp.TextColor3=CurrentTheme.Success elseif fps >= 30 then fp.TextColor3=CurrentTheme.Warning else fp.TextColor3=CurrentTheme.Error end
            else fpsConn:Disconnect(); return end
            fpsFr=0; lastFU=0
        end
    end)
    local bsz = UDim2.new(0,28,0,28)
    local function mkBtn(name, color, txt, xPos)
        local b=Instance.new("TextButton"); b.Name=name; b.Size=bsz; b.Position=UDim2.new(1,xPos,0,5); b.BackgroundColor3=color; b.Text=""; b.BorderSizePixel=0; b.Parent=tb; UI.CreateCorner(b,14)
        local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1; l.Text=txt; l.TextColor3=CurrentTheme.Text; l.TextSize=12; l.Font=Enum.Font.GothamBold; l.Parent=b; return b
    end
    local closeBtn = mkBtn("CloseBtn", CurrentTheme.Error, "\195\151", -38)
    local minBtn = mkBtn("MinBtn", CurrentTheme.Warning, "\226\148\128", -72)
    local toggleBtn = mkBtn("ToggleBtn", CurrentTheme.Success, "\226\150\170", -106)
    local ca = Instance.new("Frame"); ca.Name="ContentArea"; ca.Size=UDim2.new(1,0,1,-41); ca.Position=UDim2.new(0,0,0,41); ca.BackgroundTransparency=1; ca.Parent=mf
    local sidebar = Instance.new("Frame"); sidebar.Name="Sidebar"; sidebar.Size=UDim2.new(0,160,1,0); sidebar.BackgroundColor3=CurrentTheme.Secondary; sidebar.BackgroundTransparency=0.2; sidebar.BorderSizePixel=0; sidebar.Parent=ca
    local sd = Instance.new("Frame"); sd.Size=UDim2.new(0,1,1,-16); sd.Position=UDim2.new(1,-1,0,8); sd.BackgroundColor3=CurrentTheme.Border; sd.BackgroundTransparency=0.5; sd.BorderSizePixel=0; sd.Parent=sidebar
    local ss2 = Instance.new("ScrollingFrame"); ss2.Name="SidebarScroll"; ss2.Size=UDim2.new(1,0,1,-8); ss2.Position=UDim2.new(0,0,0,4); ss2.BackgroundTransparency=1; ss2.BorderSizePixel=0; ss2.ScrollBarThickness=3; ss2.ScrollBarImageColor3=CurrentTheme.Accent; ss2.CanvasSize=UDim2.new(0,0,0,0); ss2.AutomaticCanvasSize=Enum.AutomaticSize.Y; ss2.ScrollingDirection=Enum.ScrollingDirection.Y; ss2.TopImage="rbxasset://textures/ui/Scroll/scroll-middle.png"; ss2.BottomImage="rbxasset://textures/ui/Scroll/scroll-middle.png"; ss2.MidImage="rbxasset://textures/ui/Scroll/scroll-middle.png"; ss2.Parent=sidebar
    local sl = Instance.new("UIListLayout"); sl.FillDirection=Enum.FillDirection.Vertical; sl.Padding=UDim.new(0,2); sl.SortOrder=Enum.SortOrder.LayoutOrder; sl.HorizontalAlignment=Enum.HorizontalAlignment.Left; sl.Parent=ss2; UI.CreatePadding(ss2,4,4,4,4)
    sl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() ss2.CanvasSize=UDim2.new(0,0,0,sl.AbsoluteContentSize.Y+8) end)
    local mc = Instance.new("Frame"); mc.Name="MainContent"; mc.Size=UDim2.new(1,-162,1,0); mc.Position=UDim2.new(0,162,0,0); mc.BackgroundTransparency=1; mc.Parent=ca
    local dragging=false; local dragStart, startPos
    tb.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true; dragStart=input.Position; startPos=mf.Position end end)
    tb.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then local d=input.Position-dragStart; mf.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)
    local function toggleVisibility()
        Window.Visible = not Window.Visible
        if Window.Visible then mf.Visible=true; shadow.Visible=true; UI.ScaleIn(mf, 0.3)
        else UI.ShrinkAndFade(mf, 0.25); task.delay(0.3, function() if not Window.Visible then mf.Visible=false end end) end
    end
    local function minimizeWindow()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then UI.Tween(mf, {Size=UDim2.new(0,winW,0,41)}, 0.3); UI.Tween(shadow, {ImageTransparency=0.9}, 0.3)
        else UI.Tween(mf, {Size=UDim2.new(0,winW,0,winH)}, 0.3, Enum.EasingStyle.Back); UI.Tween(shadow, {ImageTransparency=0.6}, 0.3) end
    end
    closeBtn.MouseButton1Click:Connect(function() UI.Bounce(closeBtn,0.3); task.delay(0.15, function() toggleVisibility() end) end)
    minBtn.MouseButton1Click:Connect(function() UI.Bounce(minBtn,0.3); task.delay(0.15, function() minimizeWindow() end) end)
    toggleBtn.MouseButton1Click:Connect(function() UI.Bounce(toggleBtn,0.3); task.delay(0.15, function() toggleVisibility() end) end)
    UserInputService.InputBegan:Connect(function(input, gp) if gp then return end; if input.KeyCode==Enum.KeyCode.Insert then toggleVisibility() end end)
    mf.Size=UDim2.new(0,0,0,0); mf.Position=UDim2.new(0,winX+winW/2,0,winY+winH/2); shadow.ImageTransparency=1
    UI.Tween(mf, {Size=UDim2.new(0,winW,0,winH), Position=UDim2.new(0,winX,0,winY)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    UI.Tween(shadow, {ImageTransparency=0.6}, 0.5)
    table.insert(UI._windows, Window); UI._activeWindow=Window

-- ═══════════════════════════════════════════════════════════════════════════
-- SECTION: TAB SYSTEM + ALL COMPONENTS
-- ═══════════════════════════════════════════════════════════════════════════
    local tabOrderCounter = 0
    function Window:CreateTab(tabConfig)
        local tabCfg = tabConfig or {}; tabOrderCounter = tabOrderCounter + 1
        local Tab = {}; Tab.Name=tabCfg.Name or "Tab "..tabOrderCounter; Tab.Icon=tabCfg.Icon or ""; Tab.Order=tabCfg.Order or tabOrderCounter; Tab.Elements={}; Tab.Visible=true
        local tc = Instance.new("Frame"); tc.Name="Tab_"..Tab.Name; tc.Size=UDim2.new(1,0,1,0); tc.BackgroundTransparency=1; tc.Visible=false; tc.Parent=mc; Tab.ContentFrame=tc
        local ts, tco = UI.CreateScrollFrame(tc, {Name="TabScroll", Padding=6}); Tab.ScrollFrame=ts; Tab.Container=tco
        local tbtn = Instance.new("TextButton"); tbtn.Name="TabBtn_"..Tab.Name; tbtn.Size=UDim2.new(1,-8,0,36); tbtn.BackgroundColor3=CurrentTheme.Tertiary; tbtn.BackgroundTransparency=1; tbtn.Text=""; tbtn.BorderSizePixel=0; tbtn.LayoutOrder=Tab.Order; tbtn.Parent=ss2; UI.CreateCorner(tbtn, 6)
        local ai = Instance.new("Frame"); ai.Size=UDim2.new(0,3,0,0); ai.Position=UDim2.new(0,0,0.5,0); ai.AnchorPoint=Vector2.new(0,0.5); ai.BackgroundColor3=CurrentTheme.Accent; ai.BorderSizePixel=0; ai.Parent=tbtn; UI.CreateCorner(ai,2)
        local ticon = Instance.new("TextLabel"); ticon.Size=UDim2.new(0,24,0,24); ticon.Position=UDim2.new(0,10,0.5,-12); ticon.BackgroundTransparency=1; ticon.Text=Tab.Icon; ticon.TextColor3=CurrentTheme.TextDim; ticon.TextSize=16; ticon.Font=Enum.Font.GothamBold; ticon.Parent=tbtn
        local tlabel = Instance.new("TextLabel"); tlabel.Size=UDim2.new(1,-42,1,0); tlabel.Position=UDim2.new(0,36,0,0); tlabel.BackgroundTransparency=1; tlabel.Text=Tab.Name; tlabel.TextColor3=CurrentTheme.TextDim; tlabel.TextSize=13; tlabel.Font=Enum.Font.GothamMedium; tlabel.TextXAlignment=Enum.TextXAlignment.Left; tlabel.TextTruncate=Enum.TextTruncate.AtEnd; tlabel.Parent=tbtn
        local badge = Instance.new("TextLabel"); badge.Size=UDim2.new(0,20,0,16); badge.Position=UDim2.new(1,-28,0.5,-8); badge.BackgroundColor3=CurrentTheme.Accent; badge.BackgroundTransparency=0.8; badge.Text=""; badge.TextColor3=CurrentTheme.Accent; badge.TextSize=9; badge.Font=Enum.Font.GothamBold; badge.Visible=false; badge.Parent=tbtn; UI.CreateCorner(badge,8)
        local function selectTab()
            for _, t in ipairs(Window.Tabs) do if t.ContentFrame then t.ContentFrame.Visible=false end; if t.TabButton then UI.Tween(t.TabButton, {BackgroundTransparency=1}, 0.2); if t.TabButton:FindFirstChild("ActiveIndicator") then UI.Tween(t.TabButton.ActiveIndicator, {Size=UDim2.new(0,3,0,0)}, 0.2) end; if t.TabButton:FindFirstChild("TabIcon") then UI.Tween(t.TabButton.TabIcon, {TextColor3=CurrentTheme.TextDim}, 0.2) end; if t.TabButton:FindFirstChild("TabLabel") then UI.Tween(t.TabButton.TabLabel, {TextColor3=CurrentTheme.TextDim}, 0.2) end end end
            Tab.ContentFrame.Visible=true; tbtn.BackgroundTransparency=0; tbtn.BackgroundColor3=CurrentTheme.Tertiary; ai.Size=UDim2.new(0,3,0,24); ticon.TextColor3=CurrentTheme.Accent; tlabel.TextColor3=CurrentTheme.Text; Window.CurrentTab=Tab
        end
        tbtn.MouseButton1Click:Connect(function() UI.Bounce(tbtn, 0.25); task.delay(0.1, function() selectTab() end) end)
        tbtn.MouseEnter:Connect(function() if Window.CurrentTab~=Tab then UI.Tween(tbtn, {BackgroundTransparency=0.5}, 0.15) end end)
        tbtn.MouseLeave:Connect(function() if Window.CurrentTab~=Tab then UI.Tween(tbtn, {BackgroundTransparency=1}, 0.15) end end)
        Tab.TabButton=tbtn; Tab.Select=selectTab; table.insert(Window.Tabs, Tab)
        if #Window.Tabs==1 then task.defer(function() selectTab() end) end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: Toggle
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddToggle(config)
            local tCfg=config or {}; local flag=tCfg.Flag or ("Tog_"..HttpService:GenerateGUID(false)); local default=tCfg.Default or false; local state=default
            UI.RegisterState(flag, default); local ss2=UI.GetState(flag); if ss2~=nil then state=ss2 end; local eo=#Tab.Elements+1
            local row=Instance.new("Frame"); row.Name="Toggle_"..(tCfg.Name or flag); row.Size=UDim2.new(1,0,0,40); row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-60,0,20); nl.Position=UDim2.new(0,12,0,2); nl.BackgroundTransparency=1; nl.Text=tCfg.Name or "Toggle"; nl.TextColor3=CurrentTheme.Text; nl.Font=Enum.Font.GothamMedium; nl.TextSize=13; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=row
            if tCfg.Sub then local sl=Instance.new("TextLabel"); sl.Size=UDim2.new(1,-60,0,14); sl.Position=UDim2.new(0,12,0,22); sl.BackgroundTransparency=1; sl.Text=tCfg.Sub; sl.TextColor3=CurrentTheme.TextDim; sl.Font=Enum.Font.Gotham; sl.TextSize=10; sl.TextXAlignment=Enum.TextXAlignment.Left; sl.Parent=row end
            local ts2=Instance.new("Frame"); ts2.Name="Switch"; ts2.Size=UDim2.new(0,40,0,22); ts2.Position=UDim2.new(1,-52,0.5,-11); ts2.BackgroundColor3=state and (tCfg.ColorOn or CurrentTheme.ToggleOn) or CurrentTheme.ToggleOff; ts2.BorderSizePixel=0; ts2.Parent=row; UI.CreateCorner(ts2,11)
            local tc2=Instance.new("Frame"); tc2.Name="Circle"; tc2.Size=UDim2.new(0,18,0,18); tc2.Position=state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9); tc2.BackgroundColor3=state and CurrentTheme.ToggleOnKnob or CurrentTheme.ToggleOffKnob; tc2.BorderSizePixel=0; tc2.Parent=ts2; UI.CreateCorner(tc2,9)
            local hb=Instance.new("TextButton"); hb.Size=UDim2.new(1,0,1,0); hb.BackgroundTransparency=1; hb.Text=""; hb.Parent=row
            local function uv()
                if state then UI.Tween(ts2, {BackgroundColor3=tCfg.ColorOn or CurrentTheme.ToggleOn}, 0.2); UI.Tween(tc2, {Position=UDim2.new(1,-20,0.5,-9), BackgroundColor3=CurrentTheme.ToggleOnKnob}, 0.2, Enum.EasingStyle.Back)
                else UI.Tween(ts2, {BackgroundColor3=CurrentTheme.ToggleOff}, 0.2); UI.Tween(tc2, {Position=UDim2.new(0,2,0.5,-9), BackgroundColor3=CurrentTheme.ToggleOffKnob}, 0.2, Enum.EasingStyle.Back) end
            end; uv()
            hb.MouseButton1Click:Connect(function() state=not state; UI.SetState(flag,state); uv(); UI.Bounce(ts2,0.2); if tCfg.Callback then tCfg.Callback(state) end end)
            Tab.Elements[eo]=row
            return {Set=function(_,v) state=v; UI.SetState(flag,state); uv() end, Get=function() return state end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: Slider
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddSlider(config)
            local sCfg=config or {}; local flag=sCfg.Flag or ("Sldr_"..HttpService:GenerateGUID(false)); local min=sCfg.Min or 0; local max=sCfg.Max or 100; local step=sCfg.Step or 1; local default=sCfg.Default or min; local value=default
            UI.RegisterState(flag,default); local sv=UI.GetState(flag); if sv~=nil then value=sv end; local eo=#Tab.Elements+1
            local row=Instance.new("Frame"); row.Name="Slider_"..(sCfg.Name or flag); row.Size=UDim2.new(1,0,0,56); row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(0.6,0,0,20); nl.Position=UDim2.new(0,12,0,6); nl.BackgroundTransparency=1; nl.Text=sCfg.Name or "Slider"; nl.TextColor3=CurrentTheme.Text; nl.Font=Enum.Font.GothamMedium; nl.TextSize=13; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=row
            local vl=Instance.new("TextLabel"); vl.Size=UDim2.new(0.4,-12,0,20); vl.Position=UDim2.new(0.6,0,0,6); vl.BackgroundTransparency=1; vl.Text=tostring(value); vl.TextColor3=CurrentTheme.Accent; vl.Font=Enum.Font.GothamBold; vl.TextSize=13; vl.TextXAlignment=Enum.TextXAlignment.Right; vl.Parent=row
            local track=Instance.new("Frame"); track.Size=UDim2.new(1,-24,0,8); track.Position=UDim2.new(0,12,0,38); track.BackgroundColor3=CurrentTheme.SliderTrack; track.BorderSizePixel=0; track.Parent=row; UI.CreateCorner(track,4)
            local fp=(value-min)/(max-min)
            local fill=Instance.new("Frame"); fill.Size=UDim2.new(fp,0,1,0); fill.BackgroundColor3=sCfg.Color or CurrentTheme.SliderFill; fill.BorderSizePixel=0; fill.Parent=track; UI.CreateCorner(fill,4)
            UI.CreateGradient(fill, ColorSequence.new({ColorSequenceKeypoint.new(0,sCfg.Color or CurrentTheme.SliderFill),ColorSequenceKeypoint.new(1,CurrentTheme.AccentDark)}), 0)
            local handle=Instance.new("Frame"); handle.Size=UDim2.new(0,18,0,18); handle.Position=UDim2.new(fp,-9,0.5,-9); handle.BackgroundColor3=CurrentTheme.SliderHandle; handle.BorderSizePixel=0; handle.ZIndex=2; handle.Parent=track; UI.CreateCorner(handle,9); UI.CreateStroke(handle,sCfg.Color or CurrentTheme.SliderFill,2,0)
            local ml=Instance.new("TextLabel"); ml.Size=UDim2.new(0,30,0,14); ml.Position=UDim2.new(0,12,1,-14); ml.BackgroundTransparency=1; ml.Text=tostring(min); ml.TextColor3=CurrentTheme.TextDim; ml.Font=Enum.Font.Gotham; ml.TextSize=9; ml.TextXAlignment=Enum.TextXAlignment.Left; ml.Parent=row
            local mxl=Instance.new("TextLabel"); mxl.Size=UDim2.new(0,30,0,14); mxl.Position=UDim2.new(1,-42,1,-14); mxl.BackgroundTransparency=1; mxl.Text=tostring(max); mxl.TextColor3=CurrentTheme.TextDim; mxl.Font=Enum.Font.Gotham; mxl.TextSize=9; mxl.TextXAlignment=Enum.TextXAlignment.Right; mxl.Parent=row
            local sliding=false
            local function updateSlider(ix)
                local relX=math.clamp((ix-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                value=math.round((min+(max-min)*relX)/step)*step; value=math.clamp(value,min,max); UI.SetState(flag,value)
                local p=(value-min)/(max-min)
                UI.Tween(fill,{Size=UDim2.new(p,0,1,0)},0.1); UI.Tween(handle,{Position=UDim2.new(p,-9,0.5,-9)},0.1); vl.Text=tostring(value)
                if sCfg.Callback then sCfg.Callback(value) end
            end
            track.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then sliding=true; updateSlider(input.Position.X) end end)
            local thb=Instance.new("TextButton"); thb.Size=UDim2.new(1,0,1,10); thb.Position=UDim2.new(0,0,0,-5); thb.BackgroundTransparency=1; thb.Text=""; thb.Parent=track
            thb.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then sliding=true; updateSlider(input.Position.X) end end)
            UserInputService.InputChanged:Connect(function(input) if sliding and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then updateSlider(input.Position.X) end end)
            UserInputService.InputEnded:Connect(function(input) if sliding and (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) then sliding=false end end)
            Tab.Elements[eo]=row
            return {Set=function(_,v) value=math.clamp(v,min,max); UI.SetState(flag,value); local p=(value-min)/(max-min); fill.Size=UDim2.new(p,0,1,0); handle.Position=UDim2.new(p,-9,0.5,-9); vl.Text=tostring(value) end, Get=function() return value end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: Button
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddButton(config)
            local bCfg=config or {}; local eo=#Tab.Elements+1
            local row=Instance.new("Frame"); row.Name="Button_"..(bCfg.Name or "Button"); row.Size=UDim2.new(1,0,0,36); row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,-16,1,-8); btn.Position=UDim2.new(0,8,0,4); btn.BackgroundColor3=bCfg.Color or CurrentTheme.Accent; btn.Text=""; btn.BorderSizePixel=0; btn.AutoButtonColor=false; btn.Parent=row; UI.CreateCorner(btn,6)
            UI.CreateGradient(btn, ColorSequence.new({ColorSequenceKeypoint.new(0,bCfg.Color or CurrentTheme.Accent),ColorSequenceKeypoint.new(1,CurrentTheme.AccentDark)}), 0)
            local bt=Instance.new("TextLabel"); bt.Size=UDim2.new(1,-12,1,0); bt.Position=UDim2.new(0,6,0,0); bt.BackgroundTransparency=1; bt.Text=bCfg.Name or "Button"; bt.TextColor3=CurrentTheme.Text; bt.Font=Enum.Font.GothamBold; bt.TextSize=13; bt.Parent=btn
            local disabled=bCfg.Disabled or false; if disabled then btn.BackgroundTransparency=0.5; bt.TextTransparency=0.5 end
            if bCfg.Tooltip then UI.Tooltip(bCfg.Tooltip, btn) end
            btn.MouseEnter:Connect(function() if not disabled then UI.Tween(btn, {BackgroundColor3=bCfg.HoverColor or CurrentTheme.ButtonHover}, 0.15) end end)
            btn.MouseLeave:Connect(function() if not disabled then UI.Tween(btn, {BackgroundColor3=bCfg.Color or CurrentTheme.Accent}, 0.15) end end)
            btn.MouseButton1Click:Connect(function() if disabled then return end; local o=btn.Size; UI.Tween(btn,{Size=UDim2.new(o.X.Scale,o.X.Offset-4,o.Y.Scale,o.Y.Offset-2)},0.05); task.delay(0.05,function() UI.Tween(btn,{Size=o},0.1,Enum.EasingStyle.Back) end); if bCfg.Callback then bCfg.Callback() end end)
            Tab.Elements[eo]=row
            return {SetEnabled=function(_,e) disabled=not e; btn.BackgroundTransparency=disabled and 0.5 or 0; bt.TextTransparency=disabled and 0.5 or 0 end, SetText=function(_,t) bt.Text=t end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: Dropdown
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddDropdown(config)
            local dCfg=config or {}; local flag=dCfg.Flag or ("Dd_"..HttpService:GenerateGUID(false)); local options=dCfg.Options or {}; local default=dCfg.Default or (options[1] or ""); local current=default; local multi=dCfg.Multi or false; local selected=multi and {} or current; local isOpen=false
            UI.RegisterState(flag,multi and {} or default); local sv=UI.GetState(flag); if sv~=nil then current=sv; selected=sv end; local eo=#Tab.Elements+1
            local row=Instance.new("Frame"); row.Name="Dropdown_"..(dCfg.Name or flag); row.Size=UDim2.new(1,0,0,38); row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.ClipsDescendants=false; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-16,0,20); nl.Position=UDim2.new(0,12,0,2); nl.BackgroundTransparency=1; nl.Text=dCfg.Name or "Dropdown"; nl.TextColor3=CurrentTheme.Text; nl.Font=Enum.Font.GothamMedium; nl.TextSize=13; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=row
            local vd=Instance.new("TextLabel"); vd.Size=UDim2.new(1,-24,0,16); vd.Position=UDim2.new(0,12,0,20); vd.BackgroundTransparency=1; vd.Text=tostring(multi and (#selected>0 and table.concat(selected,", ") or "None") or current); vd.TextColor3=CurrentTheme.TextDim; vd.Font=Enum.Font.Gotham; vd.TextSize=11; vd.TextXAlignment=Enum.TextXAlignment.Left; vd.TextTruncate=Enum.TextTruncate.AtEnd; vd.Parent=row
            local al=Instance.new("TextLabel"); al.Size=UDim2.new(0,20,0,20); al.Position=UDim2.new(1,-30,0,9); al.BackgroundTransparency=1; al.Text="\226\150\176"; al.TextColor3=CurrentTheme.TextDim; al.TextSize=10; al.Font=Enum.Font.GothamBold; al.Parent=row
            local dh=Instance.new("Frame"); dh.Size=UDim2.new(1,16,0,0); dh.Position=UDim2.new(0,0,1,4); dh.BackgroundColor3=CurrentTheme.DropdownBackground; dh.BorderSizePixel=0; dh.ClipsDescendants=true; dh.ZIndex=50; dh.Parent=row; UI.CreateCorner(dh,8); UI.CreateStroke(dh,CurrentTheme.Border,1,0.3)
            local ds=Instance.new("ScrollingFrame"); ds.Size=UDim2.new(1,0,1,0); ds.BackgroundTransparency=1; ds.BorderSizePixel=0; ds.ScrollBarThickness=4; ds.ScrollBarImageColor3=CurrentTheme.Accent; ds.CanvasSize=UDim2.new(0,0,0,0); ds.AutomaticCanvasSize=Enum.AutomaticSize.Y; ds.ZIndex=51; ds.TopImage="rbxasset://textures/ui/Scroll/scroll-middle.png"; ds.BottomImage="rbxasset://textures/ui/Scroll/scroll-middle.png"; ds.MidImage="rbxasset://textures/ui/Scroll/scroll-middle.png"; ds.Parent=dh
            local dl=Instance.new("UIListLayout"); dl.FillDirection=Enum.FillDirection.Vertical; dl.Padding=UDim.new(0,2); dl.SortOrder=Enum.SortOrder.LayoutOrder; dl.Parent=ds; UI.CreatePadding(ds,4,4,4,4)
            dl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() ds.CanvasSize=UDim2.new(0,0,0,dl.AbsoluteContentSize.Y+8) end)
            local function closeDropdown() isOpen=false; UI.Tween(dh,{Size=UDim2.new(1,16,0,0)},0.2); UI.Tween(al,{Rotation=0},0.2) end
            local function refreshOptions()
                for _,c in ipairs(ds:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                for i,opt in ipairs(options) do
                    local ob=Instance.new("TextButton"); ob.Size=UDim2.new(1,-8,0,28); ob.BackgroundColor3=CurrentTheme.Tertiary; ob.BackgroundTransparency=0.5; ob.Text=""; ob.BorderSizePixel=0; ob.LayoutOrder=i; ob.ZIndex=51; ob.Parent=ds; UI.CreateCorner(ob,5)
                    local isSel=false; if multi then for _,s in ipairs(selected) do if s==opt then isSel=true; break end end else isSel=(current==opt) end
                    if isSel then ob.BackgroundColor3=CurrentTheme.Accent; ob.BackgroundTransparency=0.7 end
                    local ol=Instance.new("TextLabel"); ol.Size=UDim2.new(1,-8,1,0); ol.Position=UDim2.new(0,8,0,0); ol.BackgroundTransparency=1; ol.Text=opt; ol.TextColor3=isSel and CurrentTheme.Accent or CurrentTheme.Text; ol.Font=isSel and Enum.Font.GothamBold or Enum.Font.Gotham; ol.TextSize=12; ol.TextXAlignment=Enum.TextXAlignment.Left; ol.ZIndex=52; ol.Parent=ob
                    ob.MouseEnter:Connect(function() if not isSel then UI.Tween(ob,{BackgroundTransparency=0.3},0.1) end end)
                    ob.MouseLeave:Connect(function() if not isSel then UI.Tween(ob,{BackgroundTransparency=0.5},0.1) end end)
                    ob.MouseButton1Click:Connect(function()
                        if multi then local found=false; for idx,s in ipairs(selected) do if s==opt then table.remove(selected,idx); found=true; break end end; if not found then table.insert(selected,opt) end; current=table.concat(selected,", "); vd.Text=#selected>0 and table.concat(selected,", ") or "None"; UI.SetState(flag,selected)
                        else current=opt; vd.Text=opt; UI.SetState(flag,current); closeDropdown() end
                        refreshOptions(); if dCfg.Callback then dCfg.Callback(multi and selected or current) end
                    end)
                end
            end
            local hitbox=Instance.new("TextButton"); hitbox.Size=UDim2.new(1,0,0,38); hitbox.BackgroundTransparency=1; hitbox.Text=""; hitbox.ZIndex=10; hitbox.Parent=row
            hitbox.MouseButton1Click:Connect(function() if isOpen then closeDropdown() else isOpen=true; refreshOptions(); UI.Tween(dh,{Size=UDim2.new(1,16,0,math.min(#options*30+8,200))},0.25,Enum.EasingStyle.Back); UI.Tween(al,{Rotation=180},0.2) end end)
            refreshOptions(); Tab.Elements[eo]=row
            return {Set=function(_,v) if multi then selected=type(v)=="table" and v or {v}; current=table.concat(selected,", ") else current=v; selected=v end; vd.Text=multi and (#selected>0 and table.concat(selected,", ") or "None") or current; UI.SetState(flag,multi and selected or current); refreshOptions() end, Get=function() return multi and selected or current end, Refresh=function(_,no) options=no; refreshOptions() end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: Textbox
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddTextbox(config)
            local tCfg=config or {}; local flag=tCfg.Flag or ("Tbx_"..HttpService:GenerateGUID(false)); local default=tCfg.Default or ""; local value=default; local charLimit=tCfg.CharLimit or 100
            UI.RegisterState(flag,default); local eo=#Tab.Elements+1
            local row=Instance.new("Frame"); row.Name="Textbox_"..(tCfg.Name or flag); row.Size=UDim2.new(1,0,0,60); row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-16,0,20); nl.Position=UDim2.new(0,12,0,4); nl.BackgroundTransparency=1; nl.Text=tCfg.Name or "Textbox"; nl.TextColor3=CurrentTheme.Text; nl.Font=Enum.Font.GothamMedium; nl.TextSize=13; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=row
            local ib=Instance.new("TextBox"); ib.Size=UDim2.new(1,-24,0,28); ib.Position=UDim2.new(0,12,0,26); ib.BackgroundColor3=CurrentTheme.InputBackground; ib.Text=default; ib.PlaceholderText=tCfg.Placeholder or "Type here..."; ib.PlaceholderColor3=CurrentTheme.TextDim; ib.TextColor3=CurrentTheme.Text; ib.Font=Enum.Font.Gotham; ib.TextSize=13; ib.ClearTextOnFocus=tCfg.ClearOnFocus or false; ib.TextXAlignment=Enum.TextXAlignment.Left; ib.ClipsDescendants=true; ib.Parent=row; UI.CreateCorner(ib,6); UI.CreateStroke(ib,CurrentTheme.Border,1,0.5)
            local tp=Instance.new("UIPadding"); tp.PaddingLeft=UDim.new(0,8); tp.PaddingRight=UDim.new(0,12); tp.Parent=ib
            if tCfg.SubmitButton then local sb=Instance.new("TextButton"); sb.Size=UDim2.new(0,28,0,28); sb.Position=UDim2.new(1,-36,0,26); sb.BackgroundColor3=CurrentTheme.Accent; sb.Text="\226\134\147"; sb.TextColor3=CurrentTheme.Text; sb.Font=Enum.Font.GothamBold; sb.TextSize=14; sb.Parent=row; UI.CreateCorner(sb,6)
                sb.MouseEnter:Connect(function() UI.Tween(sb,{BackgroundColor3=CurrentTheme.ButtonHover},0.15) end); sb.MouseLeave:Connect(function() UI.Tween(sb,{BackgroundColor3=CurrentTheme.Accent},0.15) end)
                sb.MouseButton1Click:Connect(function() value=ib.Text; UI.SetState(flag,value); UI.Bounce(sb,0.2); if tCfg.Callback then tCfg.Callback(value) end end)
            end
            ib.FocusLost:Connect(function(ep) value=ib.Text; if #value>charLimit then value=string.sub(value,1,charLimit); ib.Text=value end; UI.SetState(flag,value); if tCfg.Callback then tCfg.Callback(value,ep) end end)
            ib.Focused:Connect(function() UI.Tween(ib,{BackgroundColor3=CurrentTheme.Tertiary},0.15) end)
            ib.FocusLost:Connect(function() task.delay(0.1,function() if not ib:IsFocused() then UI.Tween(ib,{BackgroundColor3=CurrentTheme.InputBackground},0.15) end end) end)
            Tab.Elements[eo]=row
            return {Set=function(_,v) value=v; ib.Text=v; UI.SetState(flag,value) end, Get=function() return value end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: Label
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddLabel(text)
            local eo=#Tab.Elements+1; local l=Instance.new("TextLabel"); l.Name="Label"; l.Size=UDim2.new(1,-16,0,22); l.Position=UDim2.new(0,8,0,0); l.BackgroundTransparency=1; l.Text=text or ""; l.TextColor3=CurrentTheme.Text; l.Font=Enum.Font.GothamMedium; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left; l.TextWrapped=true; l.LayoutOrder=eo; l.Parent=Tab.Container
            Tab.Elements[eo]=l
            return {Set=function(_,v) l.Text=v end, Get=function() return l.Text end, Frame=l}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: Section
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddSection(text)
            local eo=#Tab.Elements+1; local sf=Instance.new("Frame"); sf.Name="Section_"..text; sf.Size=UDim2.new(1,0,0,30); sf.BackgroundTransparency=1; sf.LayoutOrder=eo; sf.Parent=Tab.Container
            local sl=Instance.new("TextLabel"); sl.Size=UDim2.new(0,0,1,0); sl.Position=UDim2.new(0,4,0,0); sl.BackgroundTransparency=1; sl.Text=text or "Section"; sl.TextColor3=CurrentTheme.Accent; sl.Font=Enum.Font.GothamBold; sl.TextSize=12; sl.TextXAlignment=Enum.TextXAlignment.Left; sl.AutomaticSize=Enum.AutomaticSize.X; sl.Parent=sf
            local lr=Instance.new("Frame"); lr.Size=UDim2.new(1,-8,0,1); lr.Position=UDim2.new(0,4,0.5,0); lr.BackgroundColor3=CurrentTheme.Border; lr.BackgroundTransparency=0.5; lr.BorderSizePixel=0; lr.Parent=sf
            Tab.Elements[eo]=sf; return {Frame=sf}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: Keybind
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddKeybind(config)
            local kCfg=config or {}; local flag=kCfg.Flag or ("Kb_"..HttpService:GenerateGUID(false)); local currentKey=kCfg.Default or Enum.KeyCode.Unknown; local listening=false
            UI.RegisterState(flag,currentKey.Name); local eo=#Tab.Elements+1
            local row=Instance.new("Frame"); row.Name="Keybind_"..(kCfg.Name or flag); row.Size=UDim2.new(1,0,0,38); row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-100,0,20); nl.Position=UDim2.new(0,12,0,2); nl.BackgroundTransparency=1; nl.Text=kCfg.Name or "Keybind"; nl.TextColor3=CurrentTheme.Text; nl.Font=Enum.Font.GothamMedium; nl.TextSize=13; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=row
            local kd=Instance.new("TextButton"); kd.Size=UDim2.new(0,80,0,26); kd.Position=UDim2.new(1,-92,0,6); kd.BackgroundColor3=CurrentTheme.InputBackground; kd.Text=currentKey.Name=="Unknown" and "None" or currentKey.Name; kd.TextColor3=CurrentTheme.Accent; kd.Font=Enum.Font.GothamBold; kd.TextSize=12; kd.Parent=row; UI.CreateCorner(kd,6); UI.CreateStroke(kd,CurrentTheme.Border,1,0.5)
            kd.MouseButton1Click:Connect(function() listening=true; kd.Text="..."; kd.TextColor3=CurrentTheme.Warning; UI.Tween(kd,{BackgroundColor3=CurrentTheme.Tertiary},0.15) end)
            UserInputService.InputBegan:Connect(function(input,gp) if gp then return end; if listening and input.UserInputType==Enum.UserInputType.Keyboard then currentKey=input.KeyCode; kd.Text=currentKey.Name; kd.TextColor3=CurrentTheme.Accent; UI.Tween(kd,{BackgroundColor3=CurrentTheme.InputBackground},0.15); listening=false; UI.SetState(flag,currentKey.Name); if kCfg.Callback then kCfg.Callback(currentKey) end end end)
            Tab.Elements[eo]=row
            return {Set=function(_,kc) currentKey=kc; kd.Text=kc.Name; UI.SetState(flag,currentKey.Name) end, Get=function() return currentKey end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: ColorPicker
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddColorPicker(config)
            local cCfg=config or {}; local flag=cCfg.Flag or ("Cp_"..HttpService:GenerateGUID(false)); local default=cCfg.Default or Color3.fromRGB(255,255,255); local currentColor=default; local isOpen=false
            UI.RegisterState(flag,{R=default.R*255,G=default.G*255,B=default.B*255}); local eo=#Tab.Elements+1
            local row=Instance.new("Frame"); row.Name="ColorPicker_"..(cCfg.Name or flag); row.Size=UDim2.new(1,0,0,38); row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.ClipsDescendants=false; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-70,0,20); nl.Position=UDim2.new(0,12,0,2); nl.BackgroundTransparency=1; nl.Text=cCfg.Name or "Color"; nl.TextColor3=CurrentTheme.Text; nl.Font=Enum.Font.GothamMedium; nl.TextSize=13; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=row
            local cp=Instance.new("Frame"); cp.Size=UDim2.new(0,28,0,28); cp.Position=UDim2.new(1,-40,0,5); cp.BackgroundColor3=currentColor; cp.BorderSizePixel=0; cp.Parent=row; UI.CreateCorner(cp,6); UI.CreateStroke(cp,CurrentTheme.Border,1,0.3)
            local panel=Instance.new("Frame"); panel.Size=UDim2.new(1,16,0,0); panel.Position=UDim2.new(0,0,1,4); panel.BackgroundColor3=CurrentTheme.DropdownBackground; panel.BorderSizePixel=0; panel.ClipsDescendants=true; panel.ZIndex=50; panel.Visible=false; panel.Parent=row; UI.CreateCorner(panel,8); UI.CreateStroke(panel,CurrentTheme.Border,1,0.3)
            local ht=Instance.new("Frame"); ht.Size=UDim2.new(1,-16,0,12); ht.Position=UDim2.new(0,8,0,8); ht.BackgroundColor3=Color3.fromRGB(255,255,255); ht.BorderSizePixel=0; ht.ZIndex=51; ht.Parent=panel; UI.CreateCorner(ht,6)
            UI.CreateGradient(ht, ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),ColorSequenceKeypoint.new(0.17,Color3.fromRGB(255,255,0)),ColorSequenceKeypoint.new(0.33,Color3.fromRGB(0,255,0)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),ColorSequenceKeypoint.new(0.67,Color3.fromRGB(0,0,255)),ColorSequenceKeypoint.new(0.83,Color3.fromRGB(255,0,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))}), 0)
            local hh=Instance.new("Frame"); hh.Size=UDim2.new(0,4,0,16); hh.Position=UDim2.new(0,0,0.5,-8); hh.BackgroundColor3=Color3.fromRGB(255,255,255); hh.BorderSizePixel=0; hh.ZIndex=52; hh.Parent=ht; UI.CreateCorner(hh,2); UI.CreateStroke(hh,CurrentTheme.Text,1,0)
            local svf=Instance.new("Frame"); svf.Size=UDim2.new(1,-16,0,80); svf.Position=UDim2.new(0,8,0,26); svf.BackgroundColor3=currentColor; svf.BorderSizePixel=0; svf.ZIndex=51; svf.Parent=panel; UI.CreateCorner(svf,6)
            UI.CreateGradient(svf, ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))}), 0)
            local sh=Instance.new("Frame"); sh.Size=UDim2.new(0,8,0,8); sh.Position=UDim2.new(0.5,-4,0.5,-4); sh.BackgroundColor3=Color3.fromRGB(255,255,255); sh.BorderSizePixel=0; sh.ZIndex=52; sh.Parent=svf; UI.CreateCorner(sh,4); UI.CreateStroke(sh,CurrentTheme.Text,1.5,0)
            local hueH,satS,valV=Color3.toHSV(currentColor); local hd=false; local sd=false
            local function updateColor()
                currentColor=Color3.fromHSV(hueH,satS,valV); cp.BackgroundColor3=currentColor; svf.BackgroundColor3=Color3.fromHSV(hueH,1,1); hh.Position=UDim2.new(hueH,-2,0.5,-8)
                UI.SetState(flag,{R=math.floor(currentColor.R*255),G=math.floor(currentColor.G*255),B=math.floor(currentColor.B*255)})
                if cCfg.Callback then cCfg.Callback(currentColor) end
            end
            ht.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 then hd=true end end)
            svf.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 then sd=true end end)
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseMovement then
                    if hd then hueH=math.clamp((input.Position.X-ht.AbsolutePosition.X)/ht.AbsoluteSize.X,0,1); updateColor() end
                    if sd then local rx=math.clamp((input.Position.X-svf.AbsolutePosition.X)/svf.AbsoluteSize.X,0,1); local ry=math.clamp((input.Position.Y-svf.AbsolutePosition.Y)/svf.AbsoluteSize.Y,0,1); satS=rx; valV=1-ry; sh.Position=UDim2.new(rx,-4,ry,-4); updateColor() end
                end
            end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 then hd=false; sd=false end end)
            local hitbox=Instance.new("TextButton"); hitbox.Size=UDim2.new(1,0,0,38); hitbox.BackgroundTransparency=1; hitbox.Text=""; hitbox.ZIndex=10; hitbox.Parent=row
            hitbox.MouseButton1Click:Connect(function()
                isOpen=not isOpen
                if isOpen then panel.Visible=true; panel.Size=UDim2.new(1,16,0,0); UI.Tween(panel,{Size=UDim2.new(1,16,0,112)},0.25,Enum.EasingStyle.Back); row.Size=UDim2.new(1,0,0,154)
                else UI.Tween(panel,{Size=UDim2.new(1,16,0,0)},0.2); task.delay(0.22,function() panel.Visible=false end); row.Size=UDim2.new(1,0,0,38) end
            end)
            updateColor(); Tab.Elements[eo]=row
            return {Set=function(_,c) currentColor=c; hueH,satS,valV=Color3.toHSV(c); updateColor() end, Get=function() return currentColor end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: Paragraph
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddParagraph(config)
            local pCfg=config or {}; local eo=#Tab.Elements+1
            local row=Instance.new("Frame"); row.Name="Para_"..(pCfg.Title or "Para"); row.Size=UDim2.new(1,0,0,0); row.AutomaticSize=Enum.AutomaticSize.Y; row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local tl=Instance.new("TextLabel"); tl.Size=UDim2.new(1,-16,0,20); tl.Position=UDim2.new(0,8,0,6); tl.BackgroundTransparency=1; tl.Text=pCfg.Title or "Paragraph"; tl.TextColor3=CurrentTheme.Accent; tl.Font=Enum.Font.GothamBold; tl.TextSize=13; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.Parent=row
            local cl=Instance.new("TextLabel"); cl.Size=UDim2.new(1,-16,0,0); cl.AutomaticSize=Enum.AutomaticSize.Y; cl.Position=UDim2.new(0,8,0,26); cl.BackgroundTransparency=1; cl.Text=pCfg.Content or ""; cl.TextColor3=CurrentTheme.TextDim; cl.Font=Enum.Font.Gotham; cl.TextSize=12; cl.TextXAlignment=Enum.TextXAlignment.Left; cl.TextYAlignment=Enum.TextYAlignment.Top; cl.TextWrapped=true; cl.Parent=row
            local sp=Instance.new("Frame"); sp.Size=UDim2.new(1,0,0,8); sp.Position=UDim2.new(0,0,1,-8); sp.BackgroundTransparency=1; sp.Parent=row
            Tab.Elements[eo]=row
            return {Set=function(_,t,c) if t then tl.Text=t end; if c then cl.Text=c end end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: Image
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddImage(config)
            local iCfg=config or {}; local eo=#Tab.Elements+1
            local row=Instance.new("Frame"); row.Name="Img_"..(iCfg.Name or "Image"); row.Size=UDim2.new(1,0,0,(iCfg.Height or 100)+16); row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local il=Instance.new("ImageLabel"); il.Size=UDim2.new(0,iCfg.Width or 200,0,iCfg.Height or 100); il.Position=UDim2.new(0.5,-(iCfg.Width or 200)/2,0,8); il.BackgroundTransparency=1; il.Image=iCfg.Image or ""; il.ImageColor3=iCfg.ImageColor or Color3.fromRGB(255,255,255); il.ScaleType=iCfg.ScaleType or Enum.ScaleType.Fit; il.Parent=row; UI.CreateCorner(il,6)
            if iCfg.Callback then local b=Instance.new("TextButton"); b.Size=UDim2.new(1,0,1,0); b.BackgroundTransparency=1; b.Text=""; b.Parent=il; b.MouseButton1Click:Connect(function() UI.Bounce(il,0.3); iCfg.Callback() end) end
            Tab.Elements[eo]=row; return {SetImage=function(_,id) il.Image=id end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: ToggleGroup
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddToggleGroup(config)
            local tgCfg=config or {}; local flag=tgCfg.Flag or ("TG_"..HttpService:GenerateGUID(false)); local options=tgCfg.Options or {"Option 1","Option 2","Option 3"}; local default=tgCfg.Default or options[1]; local current=default; local buttons={}
            UI.RegisterState(flag,default); local eo=#Tab.Elements+1
            local row=Instance.new("Frame"); row.Name="TG_"..(tgCfg.Name or flag); row.Size=UDim2.new(1,0,0,0); row.AutomaticSize=Enum.AutomaticSize.Y; row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-16,0,22); nl.Position=UDim2.new(0,8,0,6); nl.BackgroundTransparency=1; nl.Text=tgCfg.Name or "Toggle Group"; nl.TextColor3=CurrentTheme.Text; nl.Font=Enum.Font.GothamMedium; nl.TextSize=13; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=row
            local bc=Instance.new("Frame"); bc.Size=UDim2.new(1,-16,0,0); bc.AutomaticSize=Enum.AutomaticSize.Y; bc.Position=UDim2.new(0,8,0,30); bc.BackgroundTransparency=1; bc.Parent=row
            UI.CreateLayout(bc,Enum.FillDirection.Vertical,4)
            local sp=Instance.new("Frame"); sp.Size=UDim2.new(1,0,0,8); sp.BackgroundTransparency=1; sp.LayoutOrder=999; sp.Parent=bc
            local function uv()
                for o,b in pairs(buttons) do if o==current then UI.Tween(b,{BackgroundColor3=CurrentTheme.Accent,BackgroundTransparency=0.7},0.2); if b:FindFirstChild("Label") then UI.Tween(b.Label,{TextColor3=CurrentTheme.Accent},0.2) end
                else UI.Tween(b,{BackgroundColor3=CurrentTheme.Tertiary,BackgroundTransparency=0.5},0.2); if b:FindFirstChild("Label") then UI.Tween(b.Label,{TextColor3=CurrentTheme.Text},0.2) end end end
            end
            for i,opt in ipairs(options) do
                local ob=Instance.new("TextButton"); ob.Size=UDim2.new(1,0,0,30); ob.BackgroundColor3=(opt==current) and CurrentTheme.Accent or CurrentTheme.Tertiary; ob.BackgroundTransparency=(opt==current) and 0.7 or 0.5; ob.Text=""; ob.BorderSizePixel=0; ob.LayoutOrder=i; ob.Parent=bc; UI.CreateCorner(ob,6)
                local ol=Instance.new("TextLabel"); ol.Name="Label"; ol.Size=UDim2.new(1,-12,1,0); ol.Position=UDim2.new(0,12,0,0); ol.BackgroundTransparency=1; ol.Text=opt; ol.TextColor3=(opt==current) and CurrentTheme.Accent or CurrentTheme.Text; ol.Font=(opt==current) and Enum.Font.GothamBold or Enum.Font.Gotham; ol.TextSize=12; ol.TextXAlignment=Enum.TextXAlignment.Left; ol.Parent=ob
                ob.MouseButton1Click:Connect(function() current=opt; UI.SetState(flag,current); uv(); UI.Bounce(ob,0.2); if tgCfg.Callback then tgCfg.Callback(current) end end)
                buttons[opt]=ob
            end
            Tab.Elements[eo]=row
            return {Set=function(_,v) current=v; UI.SetState(flag,current); uv() end, Get=function() return current end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: ProgressBar
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddProgressBar(config)
            local pbCfg=config or {}; local eo=#Tab.Elements+1; local value=pbCfg.Default or 0; local min=pbCfg.Min or 0; local max=pbCfg.Max or 100
            local row=Instance.new("Frame"); row.Name="PB_"..(pbCfg.Name or "Progress"); row.Size=UDim2.new(1,0,0,48); row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(0.6,0,0,18); nl.Position=UDim2.new(0,12,0,4); nl.BackgroundTransparency=1; nl.Text=pbCfg.Name or "Progress"; nl.TextColor3=CurrentTheme.Text; nl.Font=Enum.Font.GothamMedium; nl.TextSize=13; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=row
            local pl=Instance.new("TextLabel"); pl.Size=UDim2.new(0.4,-12,0,18); pl.Position=UDim2.new(0.6,0,0,4); pl.BackgroundTransparency=1; pl.Text="0%"; pl.TextColor3=CurrentTheme.Accent; pl.Font=Enum.Font.GothamBold; pl.TextSize=13; pl.TextXAlignment=Enum.TextXAlignment.Right; pl.Parent=row
            local track=Instance.new("Frame"); track.Size=UDim2.new(1,-24,0,10); track.Position=UDim2.new(0,12,0,28); track.BackgroundColor3=CurrentTheme.SliderTrack; track.BorderSizePixel=0; track.Parent=row; UI.CreateCorner(track,5)
            local fill=Instance.new("Frame"); fill.Size=UDim2.new(0,0,1,0); fill.BackgroundColor3=pbCfg.Color or CurrentTheme.Accent; fill.BorderSizePixel=0; fill.Parent=track; UI.CreateCorner(fill,5)
            UI.CreateGradient(fill, ColorSequence.new({ColorSequenceKeypoint.new(0,pbCfg.Color or CurrentTheme.Accent),ColorSequenceKeypoint.new(1,CurrentTheme.AccentDark)}), 0)
            local function updateBar() local p=math.clamp((value-min)/(max-min),0,1); UI.Tween(fill,{Size=UDim2.new(p,0,1,0)},0.3,Enum.EasingStyle.Quint); pl.Text=tostring(math.floor(p*100)).."%" end; updateBar()
            Tab.Elements[eo]=row
            return {Set=function(_,v) value=math.clamp(v,min,max); updateBar() end, Get=function() return value end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: NotificationBar (In-tab notifications)
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddNotificationBar(config)
            local nbCfg=config or {}; local eo=#Tab.Elements+1
            local row=Instance.new("Frame"); row.Name="NotifBar_"..(nbCfg.Name or "Notifications"); row.Size=UDim2.new(1,0,0,0); row.AutomaticSize=Enum.AutomaticSize.Y; row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.ClipsDescendants=true; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local header=Instance.new("TextLabel"); header.Size=UDim2.new(1,-16,0,22); header.Position=UDim2.new(0,8,0,4); header.BackgroundTransparency=1; header.Text=nbCfg.Name or "Notifications"; header.TextColor3=CurrentTheme.Accent; header.Font=Enum.Font.GothamBold; header.TextSize=12; header.TextXAlignment=Enum.TextXAlignment.Left; header.Parent=row
            local nContainer=Instance.new("Frame"); nContainer.Size=UDim2.new(1,0,0,0); nContainer.AutomaticSize=Enum.AutomaticSize.Y; nContainer.Position=UDim2.new(0,0,0,26); nContainer.BackgroundTransparency=1; nContainer.Parent=row
            UI.CreateLayout(nContainer,Enum.FillDirection.Vertical,4)
            local function addNotif(title, text, style)
                local s=style or "Info"; local clr=s=="Error" and CurrentTheme.Error or s=="Warning" and CurrentTheme.Warning or s=="Success" and CurrentTheme.Success or CurrentTheme.Info
                local nf=Instance.new("Frame"); nf.Size=UDim2.new(1,-8,0,40); nf.BackgroundColor3=CurrentTheme.Tertiary; nf.BackgroundTransparency=0.3; nf.BorderSizePixel=0; nf.Parent=nContainer; UI.CreateCorner(nf,6)
                local ab=Instance.new("Frame"); ab.Size=UDim2.new(0,3,1,-8); ab.Position=UDim2.new(0,4,0,4); ab.BackgroundColor3=clr; ab.BorderSizePixel=0; ab.Parent=nf; UI.CreateCorner(ab,2)
                local tl=Instance.new("TextLabel"); tl.Size=UDim2.new(1,-16,0,16); tl.Position=UDim2.new(0,12,0,3); tl.BackgroundTransparency=1; tl.Text=title or ""; tl.TextColor3=CurrentTheme.Text; tl.Font=Enum.Font.GothamBold; tl.TextSize=11; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.Parent=nf
                local ml=Instance.new("TextLabel"); ml.Size=UDim2.new(1,-16,0,16); ml.Position=UDim2.new(0,12,0,19); ml.BackgroundTransparency=1; ml.Text=text or ""; ml.TextColor3=CurrentTheme.TextDim; ml.Font=Enum.Font.Gotham; ml.TextSize=10; ml.TextXAlignment=Enum.TextXAlignment.Left; ml.TextWrapped=true; ml.Parent=nf
                UI.ScaleIn(nf,0.2)
                local dur=nbCfg.DismissDuration or 5
                task.delay(dur, function()
                    UI.ShrinkAndFade(nf,0.3)
                    task.delay(0.35, function() if nf and nf.Parent then nf:Destroy() end end)
                end)
            end
            Tab.Elements[eo]=row
            return {Add=function(_,title,text,style) addNotif(title,text,style) end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: MultiToggleGrid (grid of toggles)
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddMultiToggleGrid(config)
            local mgCfg = config or {}; local flag = mgCfg.Flag or ("MTG_"..HttpService:GenerateGUID(false))
            local items = mgCfg.Items or {}; local defaults = mgCfg.Defaults or {}; local states = {}
            for _, item in ipairs(items) do states[item] = defaults[item] or false end
            UI.RegisterState(flag, states); local sv = UI.GetState(flag); if sv then states = sv end
            local eo = #Tab.Elements + 1
            local row = Instance.new("Frame"); row.Name="MultiToggle_"..(mgCfg.Name or flag); row.Size=UDim2.new(1,0,0,0); row.AutomaticSize=Enum.AutomaticSize.Y
            row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local nl = Instance.new("TextLabel"); nl.Size=UDim2.new(1,-16,0,22); nl.Position=UDim2.new(0,8,0,6); nl.BackgroundTransparency=1; nl.Text=mgCfg.Name or "Multi Toggle"; nl.TextColor3=CurrentTheme.Text; nl.Font=Enum.Font.GothamMedium; nl.TextSize=13; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=row
            local gc = Instance.new("Frame"); gc.Size=UDim2.new(1,-16,0,0); gc.AutomaticSize=Enum.AutomaticSize.Y; gc.Position=UDim2.new(0,8,0,30); gc.BackgroundTransparency=1; gc.Parent=row
            local gl = Instance.new("UIGridLayout"); gl.CellSize=UDim2.new(0.5,-4,0,32); gl.CellPadding=UDim2.new(0,4,0,4); gl.SortOrder=Enum.SortOrder.LayoutOrder; gl.FillDirection=Enum.FillDirection.Horizontal; gl.Parent=gc
            local function refresh()
                for _, c in ipairs(gc:GetChildren()) do
                    if c:IsA("TextButton") then
                        local it = c.Name
                        if states[it] then UI.Tween(c,{BackgroundColor3=CurrentTheme.Accent,BackgroundTransparency=0.7},0.2) else UI.Tween(c,{BackgroundColor3=CurrentTheme.Tertiary,BackgroundTransparency=0.5},0.2) end
                    end
                end
            end
            local sp = Instance.new("Frame"); sp.Size=UDim2.new(1,0,0,8); sp.BackgroundTransparency=true; sp.LayoutOrder=999; sp.Parent=gc
            for i, item in ipairs(items) do
                local ob = Instance.new("TextButton"); ob.Name=item; ob.BackgroundColor3=states[item] and CurrentTheme.Accent or CurrentTheme.Tertiary
                ob.BackgroundTransparency=states[item] and 0.7 or 0.5; ob.Text=""; ob.LayoutOrder=i; ob.Parent=gc; UI.CreateCorner(ob,6)
                local ol = Instance.new("TextLabel"); ol.Size=UDim2.new(1,-8,1,0); ol.Position=UDim2.new(0,4,0,0); ol.BackgroundTransparency=1; ol.Text=item
                ol.TextColor3=states[item] and CurrentTheme.Accent or CurrentTheme.Text; ol.Font=states[item] and Enum.Font.GothamBold or Enum.Font.Gotham; ol.TextSize=11; ol.Parent=ob
                ob.MouseButton1Click:Connect(function() states[item]=not states[item]; UI.SetState(flag,states); refresh(); UI.Bounce(ob,0.2)
                    if mgCfg.Callback then mgCfg.Callback(item, states[item], states) end end)
            end
            local sp2 = Instance.new("Frame"); sp2.Size=UDim2.new(1,0,0,8); sp2.BackgroundTransparency=true; sp2.LayoutOrder=998; sp2.Parent=gc
            Tab.Elements[eo]=row
            return {Set=function(_,item,v) states[item]=v; refresh() end, GetAll=function() return states end, Get=function(_,item) return states[item] end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: TabBadge + TabIcon + TabName setters
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:SetBadge(text)
            local badge = self.TabButton:FindFirstChild("Badge")
            if badge then
                if text and #tostring(text) > 0 then badge.Text=tostring(text); badge.Visible=true else badge.Visible=false end
            end
        end
        function Tab:SetIcon(icon)
            local iconLbl = self.TabButton:FindFirstChild("TabIcon")
            if iconLbl then iconLbl.Text=icon end
        end
        function Tab:SetName(name)
            self.Name = name
            local label = self.TabButton:FindFirstChild("TabLabel")
            if label then label.Text=name end
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: Credits
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddCredits(config)
            local crCfg = config or {}; local eo = #Tab.Elements + 1
            local credits = crCfg.Credits or {{"Developer","Apex Team"},{"Script Hub","Apex Hub v13"},{"Discord","discord.gg/apex"},{"Special Thanks","Community"}};
            local row = Instance.new("Frame"); row.Name="Credits_"..eo; row.Size=UDim2.new(1,0,0,0); row.AutomaticSize=Enum.AutomaticSize.Y
            row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local tl = Instance.new("TextLabel"); tl.Size=UDim2.new(1,-16,0,22); tl.Position=UDim2.new(0,8,0,6); tl.BackgroundTransparency=1; tl.Text=crCfg.Title or "Credits"; tl.TextColor3=CurrentTheme.Accent; tl.Font=Enum.Font.GothamBold; tl.TextSize=14; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.Parent=row
            local lc = Instance.new("Frame"); lc.Size=UDim2.new(1,-16,0,0); lc.AutomaticSize=Enum.AutomaticSize.Y; lc.Position=UDim2.new(0,8,0,30); lc.BackgroundTransparency=1; lc.Parent=row
            UI.CreateLayout(lc,Enum.FillDirection.Vertical,2)
            for _, cr in ipairs(credits) do
                local crf = Instance.new("Frame"); crf.Size=UDim2.new(1,0,0,28); crf.BackgroundColor3=CurrentTheme.Tertiary; crf.BackgroundTransparency=0.7; crf.BorderSizePixel=0; crf.Parent=lc; UI.CreateCorner(crf,5)
                local rl = Instance.new("TextLabel"); rl.Size=UDim2.new(0.4,0,1,0); rl.Position=UDim2.new(0,12,0,0); rl.BackgroundTransparency=1; rl.Text=cr[1] or ""; rl.TextColor3=CurrentTheme.TextDim; rl.Font=Enum.Font.GothamMedium; rl.TextSize=11; rl.TextXAlignment=Enum.TextXAlignment.Left; rl.Parent=crf
                local vl = Instance.new("TextLabel"); vl.Size=UDim2.new(0.6,-12,1,0); vl.Position=UDim2.new(0.4,0,0,0); vl.BackgroundTransparency=1; vl.Text=cr[2] or ""; vl.TextColor3=CurrentTheme.Text; vl.Font=Enum.Font.GothamBold; vl.TextSize=11; vl.TextXAlignment=Enum.TextXAlignment.Left; vl.Parent=crf
            end
            local sp = Instance.new("Frame"); sp.Size=UDim2.new(1,0,0,8); sp.BackgroundTransparency=1; sp.Parent=row
            Tab.Elements[eo] = row
            return {Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: Changelog
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddChangelog(config)
            local clCfg = config or {}; local eo = #Tab.Elements + 1
            local entries = clCfg.Entries or {{"v13.0","Initial release of Apex Hub Ultimate"},{"v12.5","Bug fixes and performance improvements"},{"v12.0","Added color picker and toggle group"},{"v11.0","New UI library rewrite"}};
            local row = Instance.new("Frame"); row.Name="Changelog_"..eo; row.Size=UDim2.new(1,0,0,0); row.AutomaticSize=Enum.AutomaticSize.Y
            row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local tl = Instance.new("TextLabel"); tl.Size=UDim2.new(1,-16,0,22); tl.Position=UDim2.new(0,8,0,6); tl.BackgroundTransparency=1; tl.Text=clCfg.Title or "Changelog"; tl.TextColor3=CurrentTheme.Accent; tl.Font=Enum.Font.GothamBold; tl.TextSize=14; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.Parent=row
            local lc = Instance.new("Frame"); lc.Size=UDim2.new(1,-16,0,0); lc.AutomaticSize=Enum.AutomaticSize.Y; lc.Position=UDim2.new(0,8,0,30); lc.BackgroundTransparency=1; lc.Parent=row
            UI.CreateLayout(lc,Enum.FillDirection.Vertical,4)
            for i, entry in ipairs(entries) do
                local ef = Instance.new("Frame"); ef.Size=UDim2.new(1,0,0,0); ef.AutomaticSize=Enum.AutomaticSize.Y; ef.BackgroundColor3=CurrentTheme.Tertiary; ef.BackgroundTransparency=0.7; ef.BorderSizePixel=0; ef.LayoutOrder=i; ef.Parent=lc; UI.CreateCorner(ef,6)
                local vl = Instance.new("TextLabel"); vl.Size=UDim2.new(1,-12,0,18); vl.Position=UDim2.new(0,8,0,4); vl.BackgroundTransparency=1; vl.Text=entry[1] or ""; vl.TextColor3=CurrentTheme.Accent; vl.Font=Enum.Font.GothamBold; vl.TextSize=12; vl.TextXAlignment=Enum.TextXAlignment.Left; vl.Parent=ef
                local dl = Instance.new("TextLabel"); dl.Size=UDim2.new(1,-12,0,0); dl.AutomaticSize=Enum.AutomaticSize.Y; dl.Position=UDim2.new(0,8,0,22); dl.BackgroundTransparency=1; dl.Text=entry[2] or ""; dl.TextColor3=CurrentTheme.TextDim; dl.Font=Enum.Font.Gotham; dl.TextSize=11; dl.TextXAlignment=Enum.TextXAlignment.Left; dl.TextWrapped=true; dl.Parent=ef
                local sp2 = Instance.new("Frame"); sp2.Size=UDim2.new(1,0,0,6); sp2.BackgroundTransparency=1; sp2.LayoutOrder=999; sp2.Parent=ef
            end
            local sp = Instance.new("Frame"); sp.Size=UDim2.new(1,0,0,8); sp.BackgroundTransparency=1; sp.Parent=row
            Tab.Elements[eo] = row
            return {AddEntry=function(_,v,desc) table.insert(entries,{v,desc}) end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: ThemeSwitcher (live theme preview)
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddThemeSwitcher(config)
            local tsCfg = config or {}; local eo = #Tab.Elements + 1
            local row = Instance.new("Frame"); row.Name="ThemeSwitcher_"..eo; row.Size=UDim2.new(1,0,0,0); row.AutomaticSize=Enum.AutomaticSize.Y
            row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local tl = Instance.new("TextLabel"); tl.Size=UDim2.new(1,-16,0,22); tl.Position=UDim2.new(0,8,0,6); tl.BackgroundTransparency=1; tl.Text=tsCfg.Name or "Theme Switcher"; tl.TextColor3=CurrentTheme.Text; tl.Font=Enum.Font.GothamMedium; tl.TextSize=13; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.Parent=row
            local gc = Instance.new("Frame"); gc.Size=UDim2.new(1,-16,0,0); gc.AutomaticSize=Enum.AutomaticSize.Y; gc.Position=UDim2.new(0,8,0,30); gc.BackgroundTransparency=1; gc.Parent=row
            local gl = Instance.new("UIGridLayout"); gl.CellSize=UDim2.new(0.333,-4,0,60); gl.CellPadding=UDim2.new(0,4,0,4); gl.SortOrder=Enum.SortOrder.LayoutOrder; gl.Parent=gc
            local themeNames = {"Default","Neon","Ocean","Red","Midnight"}
            for i, name in ipairs(themeNames) do
                local td = UI.Themes[name]
                local preview = Instance.new("TextButton"); preview.Size=UDim2.new(0,100,0,60); preview.BackgroundColor3=td.Primary; preview.BorderSizePixel=0; preview.LayoutOrder=i; preview.Text=""; preview.Parent=gc; UI.CreateCorner(preview,6); UI.CreateStroke(preview,td.Accent,1.5,0)
                local pn = Instance.new("TextLabel"); pn.Size=UDim2.new(1,0,0,14); pn.Position=UDim2.new(0,0,0.5,-7); pn.BackgroundTransparency=1; pn.Text=name; pn.TextColor3=td.Text; pn.Font=Enum.Font.GothamBold; pn.TextSize=10; pn.Parent=preview
                local ab = Instance.new("Frame"); ab.Size=UDim2.new(0.8,0,0,4); ab.Position=UDim2.new(0.1,0,1,-12); ab.BackgroundColor3=td.Accent; ab.BorderSizePixel=0; ab.Parent=preview; UI.CreateCorner(ab,2)
                preview.MouseButton1Click:Connect(function()
                    UI.SetTheme(name)
                    UI.Bounce(preview, 0.3)
                    if tsCfg.Callback then tsCfg.Callback(name, td) end
                end)
                preview.MouseEnter:Connect(function() UI.Tween(preview, {Size=UDim2.new(0.333,-2,0,64)}, 0.15, Enum.EasingStyle.Back) end)
                preview.MouseLeave:Connect(function() UI.Tween(preview, {Size=UDim2.new(0.333,-4,0,60)}, 0.15) end)
            end
            local sp = Instance.new("Frame"); sp.Size=UDim2.new(1,0,0,8); sp.BackgroundTransparency=1; sp.Parent=row
            Tab.Elements[eo] = row
            return {Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: Divider + Spacer
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddDivider()
            local eo = #Tab.Elements + 1
            local div = Instance.new("Frame"); div.Name="Divider"; div.Size=UDim2.new(1,0,0,10); div.BackgroundTransparency=1; div.LayoutOrder=eo; div.Parent=Tab.Container
            local line = Instance.new("Frame"); line.Size=UDim2.new(1,-24,0,1); line.Position=UDim2.new(0,12,0.5,0); line.BackgroundColor3=CurrentTheme.Border; line.BackgroundTransparency=0.5; line.BorderSizePixel=0; line.Parent=div
            Tab.Elements[eo] = div; return {Frame=div}
        end
        function Tab:AddSpacer(height)
            local eo = #Tab.Elements + 1
            local sp = Instance.new("Frame"); sp.Name="Spacer"; sp.Size=UDim2.new(1,0,0,height or 12); sp.BackgroundTransparency=1; sp.LayoutOrder=eo; sp.Parent=Tab.Container
            Tab.Elements[eo] = sp; return {Frame=sp}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: LinkButton
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddLinkButton(config)
            local lkCfg = config or {}; local eo = #Tab.Elements + 1
            local row = Instance.new("Frame"); row.Name="LinkBtn_"..eo; row.Size=UDim2.new(1,0,0,36); row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local btn = Instance.new("TextButton"); btn.Size=UDim2.new(1,-16,1,-8); btn.Position=UDim2.new(0,8,0,4); btn.BackgroundColor3=lkCfg.Color or CurrentTheme.Accent; btn.Text=""; btn.BorderSizePixel=0; btn.AutoButtonColor=false; btn.Parent=row; UI.CreateCorner(btn,6)
            local bt = Instance.new("TextLabel"); bt.Size=UDim2.new(1,-24,1,0); bt.Position=UDim2.new(0,8,0,0); bt.BackgroundTransparency=1; bt.Text=lkCfg.Name or "Link"; bt.TextColor3=CurrentTheme.Text; bt.Font=Enum.Font.GothamBold; bt.TextSize=13; bt.TextXAlignment=Enum.TextXAlignment.Left; bt.Parent=btn
            local ar = Instance.new("TextLabel"); ar.Size=UDim2.new(0,20,0,20); ar.Position=UDim2.new(1,-28,0.5,-10); ar.BackgroundTransparency=1; ar.Text="\226\134\147"; ar.TextColor3=CurrentTheme.Text; ar.TextSize=14; ar.Font=Enum.Font.GothamBold; ar.Parent=btn
            btn.MouseEnter:Connect(function() UI.Tween(btn, {BackgroundColor3=CurrentTheme.ButtonHover}, 0.15) end)
            btn.MouseLeave:Connect(function() UI.Tween(btn, {BackgroundColor3=lkCfg.Color or CurrentTheme.Accent}, 0.15) end)
            btn.MouseButton1Click:Connect(function() UI.Bounce(btn, 0.25); if lkCfg.Callback then lkCfg.Callback() end end)
            Tab.Elements[eo] = row; return {SetUrl=function(_,url) lkCfg.Callback=function() end end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: CountdownTimer
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddCountdownTimer(config)
            local ctCfg = config or {}; local eo = #Tab.Elements + 1; local seconds = ctCfg.Seconds or 60; local running = false; local timeLeft = seconds
            local row = Instance.new("Frame"); row.Name="Countdown_"..eo; row.Size=UDim2.new(1,0,0,48); row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local nl = Instance.new("TextLabel"); nl.Size=UDim2.new(0.6,0,0,20); nl.Position=UDim2.new(0,12,0,4); nl.BackgroundTransparency=1; nl.Text=ctCfg.Name or "Timer"; nl.TextColor3=CurrentTheme.Text; nl.Font=Enum.Font.GothamMedium; nl.TextSize=13; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=row
            local vl = Instance.new("TextLabel"); vl.Size=UDim2.new(0.4,-12,0,20); vl.Position=UDim2.new(0.6,0,0,4); vl.BackgroundTransparency=1; vl.Text=UI.FormatTime(timeLeft); vl.TextColor3=CurrentTheme.Accent; vl.Font=Enum.Font.GothamBold; vl.TextSize=14; vl.TextXAlignment=Enum.TextXAlignment.Right; vl.Parent=row
            local track = Instance.new("Frame"); track.Size=UDim2.new(1,-24,0,10); track.Position=UDim2.new(0,12,0,30); track.BackgroundColor3=CurrentTheme.SliderTrack; track.BorderSizePixel=0; track.Parent=row; UI.CreateCorner(track,5)
            local fill = Instance.new("Frame"); fill.Size=UDim2.new(1,0,1,0); fill.BackgroundColor3=CurrentTheme.Accent; fill.BorderSizePixel=0; fill.Parent=track; UI.CreateCorner(fill,5)
            UI.CreateGradient(fill, ColorSequence.new({ColorSequenceKeypoint.new(0,CurrentTheme.Accent),ColorSequenceKeypoint.new(1,CurrentTheme.AccentDark)}), 0)
            local conn
            local function start()
                if running then return end; running=true; timeLeft=seconds; fill.Size=UDim2.new(1,0,1,0); fill.BackgroundColor3=CurrentTheme.Accent
                conn = RunService.Heartbeat:Connect(function(dt)
                    if not running then if conn then conn:Disconnect() end; return end
                    timeLeft = math.max(0, timeLeft - dt); local p = timeLeft / seconds; fill.Size = UDim2.new(p,0,1,0); vl.Text = UI.FormatTime(timeLeft)
                    if p < 0.3 then fill.BackgroundColor3 = CurrentTheme.Warning elseif p < 0.1 then fill.BackgroundColor3 = CurrentTheme.Error end
                    if timeLeft <= 0 then running=false; if conn then conn:Disconnect() end; if ctCfg.Callback then ctCfg.Callback() end; UI.Toast("Timer finished!","Success") end
                end)
            end
            local function stop() running=false; if conn then conn:Disconnect(); conn=nil end end
            local function reset(t) seconds=t or seconds; timeLeft=seconds; running=false; if conn then conn:Disconnect(); conn=nil end; fill.Size=UDim2.new(1,0,1,0); fill.BackgroundColor3=CurrentTheme.Accent; vl.Text=UI.FormatTime(timeLeft) end
            local bc = Instance.new("Frame"); bc.Size=UDim2.new(1,-16,0,0); bc.AutomaticSize=Enum.AutomaticSize.Y; bc.Position=UDim2.new(0,8,0,46); bc.BackgroundTransparency=1; bc.Parent=row
            UI.CreateLayout(bc,Enum.FillDirection.Horizontal,4)
            local startBtn = Instance.new("TextButton"); startBtn.Size=UDim2.new(0,50,0,22); startBtn.BackgroundColor3=CurrentTheme.Success; startBtn.Text="Start"; startBtn.TextColor3=CurrentTheme.Text; startBtn.Font=Enum.Font.GothamBold; startBtn.TextSize=10; startBtn.Parent=bc; UI.CreateCorner(startBtn,4)
            local stopBtn = Instance.new("TextButton"); stopBtn.Size=UDim2.new(0,50,0,22); stopBtn.BackgroundColor3=CurrentTheme.Error; stopBtn.Text="Stop"; stopBtn.TextColor3=CurrentTheme.Text; stopBtn.Font=Enum.Font.GothamBold; stopBtn.TextSize=10; stopBtn.Parent=bc; UI.CreateCorner(stopBtn,4)
            local resetBtn = Instance.new("TextButton"); resetBtn.Size=UDim2.new(0,50,0,22); resetBtn.BackgroundColor3=CurrentTheme.Warning; resetBtn.Text="Reset"; resetBtn.TextColor3=CurrentTheme.Text; resetBtn.Font=Enum.Font.GothamBold; resetBtn.TextSize=10; resetBtn.Parent=bc; UI.CreateCorner(resetBtn,4)
            startBtn.MouseButton1Click:Connect(function() UI.Bounce(startBtn,0.2); start() end)
            stopBtn.MouseButton1Click:Connect(function() UI.Bounce(stopBtn,0.2); stop() end)
            resetBtn.MouseButton1Click:Connect(function() UI.Bounce(resetBtn,0.2); reset() end)
            Tab.Elements[eo] = row
            return {Start=function() start() end, Stop=function() stop() end, Reset=function(_,t) reset(t) end, IsRunning=function() return running end, Frame=row}
        end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: InfoPanel
-- ═══════════════════════════════════════════════════════════════════════════
        function Tab:AddInfoPanel(config)
            local ipCfg = config or {}; local eo = #Tab.Elements + 1; local fields = ipCfg.Fields or {}
            local row = Instance.new("Frame"); row.Name="InfoPanel_"..eo; row.Size=UDim2.new(1,0,0,0); row.AutomaticSize=Enum.AutomaticSize.Y
            row.BackgroundColor3=CurrentTheme.Secondary; row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=eo; row.Parent=Tab.Container; UI.CreateCorner(row,8)
            local tl = Instance.new("TextLabel"); tl.Size=UDim2.new(1,-16,0,22); tl.Position=UDim2.new(0,8,0,6); tl.BackgroundTransparency=1; tl.Text=ipCfg.Title or "Information"; tl.TextColor3=CurrentTheme.Accent; tl.Font=Enum.Font.GothamBold; tl.TextSize=13; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.Parent=row
            local lc = Instance.new("Frame"); lc.Size=UDim2.new(1,-16,0,0); lc.AutomaticSize=Enum.AutomaticSize.Y; lc.Position=UDim2.new(0,8,0,30); lc.BackgroundTransparency=1; lc.Parent=row
            UI.CreateLayout(lc,Enum.FillDirection.Vertical,2)
            local fieldLabels = {}
            for i, field in ipairs(fields) do
                local ff = Instance.new("Frame"); ff.Size=UDim2.new(1,0,0,24); ff.BackgroundColor3=CurrentTheme.Tertiary; ff.BackgroundTransparency=0.7; ff.BorderSizePixel=0; ff.LayoutOrder=i; ff.Parent=lc; UI.CreateCorner(ff,4)
                local kL = Instance.new("TextLabel"); kL.Size=UDim2.new(0.4,0,1,0); kL.Position=UDim2.new(0,8,0,0); kL.BackgroundTransparency=1; kL.Text=field[1] or ""; kL.TextColor3=CurrentTheme.TextDim; kL.Font=Enum.Font.GothamMedium; kL.TextSize=11; kL.TextXAlignment=Enum.TextXAlignment.Left; kL.Parent=ff
                local vL = Instance.new("TextLabel"); vL.Size=UDim2.new(0.6,-8,1,0); vL.Position=UDim2.new(0.4,0,0,0); vL.BackgroundTransparency=1; vL.Text=field[2] or ""; vL.TextColor3=CurrentTheme.Text; vL.Font=Enum.Font.GothamBold; vL.TextSize=11; vL.TextXAlignment=Enum.TextXAlignment.Left; vL.Parent=ff
                fieldLabels[field[1]] = vL
            end
            local sp = Instance.new("Frame"); sp.Size=UDim2.new(1,0,0,8); sp.BackgroundTransparency=1; sp.Parent=row
            Tab.Elements[eo] = row
            return {UpdateField=function(_,key,val) if fieldLabels[key] then fieldLabels[key].Text=tostring(val) end end, Frame=row}
        end

        return Tab
    end -- end CreateTab

    return Window
end -- end CreateWindow

-- ═══════════════════════════════════════════════════════════════════════════
-- SECTION: UI-LEVEL ADDITIONAL COMPONENTS
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: SearchBox (filters tab content)
-- ═══════════════════════════════════════════════════════════════════════════
function UI.SearchBox(parent, config)
    local sbCfg = config or {}; local placeholder = sbCfg.Placeholder or "Search..."; local callback = sbCfg.Callback
    local sf = Instance.new("Frame"); sf.Name="SearchBox"; sf.Size=UDim2.new(1,0,0,34); sf.BackgroundColor3=CurrentTheme.Secondary; sf.BackgroundTransparency=0.3; sf.BorderSizePixel=0; sf.Parent=parent; UI.CreateCorner(sf,8)
    local sicon = Instance.new("TextLabel"); sicon.Size=UDim2.new(0,20,0,20); sicon.Position=UDim2.new(0,10,0,7); sicon.BackgroundTransparency=1; sicon.Text="\240\159\148\136"; sicon.TextColor3=CurrentTheme.TextDim; sicon.TextSize=14; sicon.Font=Enum.Font.GothamBold; sicon.Parent=sf
    local si = Instance.new("TextBox"); si.Size=UDim2.new(1,-48,0,22); si.Position=UDim2.new(0,34,0,6); si.BackgroundTransparency=1; si.Text=""; si.PlaceholderText=placeholder; si.PlaceholderColor3=CurrentTheme.TextDim; si.TextColor3=CurrentTheme.Text; si.Font=Enum.Font.Gotham; si.TextSize=12; si.TextXAlignment=Enum.TextXAlignment.Left; si.ClearTextOnFocus=false; si.Parent=sf
    local clrBtn = Instance.new("TextButton"); clrBtn.Size=UDim2.new(0,20,0,20); clrBtn.Position=UDim2.new(1,-26,0,7); clrBtn.BackgroundColor3=CurrentTheme.TextDim; clrBtn.Text="\195\151"; clrBtn.TextColor3=CurrentTheme.Primary; clrBtn.TextSize=10; clrBtn.Font=Enum.Font.GothamBold; clrBtn.Visible=false; clrBtn.Parent=sf; UI.CreateCorner(clrBtn,10)
    local function onInput(text)
        clrBtn.Visible = #text > 0
        if callback then callback(text) end
    end
    si:GetPropertyChangedSignal("Text"):Connect(function() onInput(si.Text) end)
    clrBtn.MouseButton1Click:Connect(function() si.Text=""; onInput("") end)
    UI.CreateStroke(sf, CurrentTheme.Border, 1, 0.3)
    return {SetText=function(_,t) si.Text=t end, GetText=function() return si.Text end, Focus=function() si:CaptureFocus() end, Clear=function() si.Text=""; clrBtn.Visible=false end, Frame=sf}
end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: Toast (mini floating notification)
-- ═══════════════════════════════════════════════════════════════════════════
function UI.Toast(message, style, duration)
    local dur = duration or 3; local st = style or "Info"
    local clr = st=="Error" and CurrentTheme.Error or st=="Warning" and CurrentTheme.Warning or st=="Success" and CurrentTheme.Success or CurrentTheme.Accent
    local sg = CoreGui:FindFirstChild("ApexToasts") or Instance.new("ScreenGui"); sg.Name="ApexToasts"; sg.ResetOnSpawn=false; sg.DisplayOrder=200
    if not sg.Parent then pcall(function() sg.Parent=CoreGui end); if not sg.Parent then sg.Parent=LP:WaitForChild("PlayerGui") end end
    local toastCount = #sg:GetChildren()
    local t = Instance.new("Frame"); t.Size=UDim2.new(0,260,0,44); t.Position=UDim2.new(1,-280,0.3,toastCount*52); t.BackgroundColor3=CurrentTheme.Primary; t.BackgroundTransparency=0.05; t.BorderSizePixel=0; t.ZIndex=100; t.Parent=sg; UI.CreateCorner(t,8); UI.CreateStroke(t,clr,1.5,0.2)
    local ab = Instance.new("Frame"); ab.Size=UDim2.new(0,4,1,-12); ab.Position=UDim2.new(0,6,0,6); ab.BackgroundColor3=clr; ab.BorderSizePixel=0; ab.ZIndex=101; ab.Parent=t; UI.CreateCorner(ab,2)
    local ml = Instance.new("TextLabel"); ml.Size=UDim2.new(1,-28,0,18); ml.Position=UDim2.new(0,18,0,8); ml.BackgroundTransparency=1; ml.Text="Apex Hub"; ml.TextColor3=clr; ml.Font=Enum.Font.GothamBold; ml.TextSize=11; ml.TextXAlignment=Enum.TextXAlignment.Left; ml.ZIndex=101; ml.Parent=t
    local tl = Instance.new("TextLabel"); tl.Size=UDim2.new(1,-28,0,18); tl.Position=UDim2.new(0,18,0,26); tl.BackgroundTransparency=1; tl.Text=message; tl.TextColor3=CurrentTheme.Text; tl.Font=Enum.Font.Gotham; tl.TextSize=11; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.TextTruncate=Enum.TextTruncate.AtEnd; tl.ZIndex=101; tl.Parent=t
    t.Size=UDim2.new(0,0,0,44); t.Position=UDim2.new(1,10,0.3,toastCount*52)
    UI.Tween(t, {Size=UDim2.new(0,260,0,44), Position=UDim2.new(1,-280,0.3,toastCount*52)}, 0.3, Enum.EasingStyle.Back)
    task.delay(dur, function()
        UI.Tween(t, {Position=UDim2.new(1,10,0.3,toastCount*52), Size=UDim2.new(0,260,0,0)}, 0.25)
        task.delay(0.3, function() if t and t.Parent then t:Destroy() end end)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPONENT: LoadingIndicator (full overlay spinner)
-- ═══════════════════════════════════════════════════════════════════════════
function UI.LoadingIndicator(parent, config)
    local liCfg = config or {}; local parent = parent or UI._activeWindow and UI._activeWindow.MainFrame
    if not parent then return nil end
    local lf = Instance.new("Frame"); lf.Name="LoadingOverlay"; lf.Size=UDim2.new(1,0,1,0); lf.BackgroundColor3=CurrentTheme.Primary; lf.BackgroundTransparency=0.3; lf.BorderSizePixel=0; lf.ZIndex=200; lf.Parent=parent
    local sp = Instance.new("Frame"); sp.Size=UDim2.new(0,40,0,40); sp.Position=UDim2.new(0.5,-20,0.5,-30); sp.BackgroundTransparency=1; sp.ZIndex=201; sp.Parent=lf
    local dotCount = 8; local dots = {}
    for i = 1, dotCount do
        local angle = (i / dotCount) * math.pi * 2
        local dx = math.cos(angle) * 16; local dy = math.sin(angle) * 16
        local dot = Instance.new("Frame"); dot.Size=UDim2.new(0,6,0,6); dot.Position=UDim2.new(0.5,-3+dx,0.5,-3+dy); dot.BackgroundColor3=CurrentTheme.Accent; dot.BackgroundTransparency=(i-1)/(dotCount-1)*0.7; dot.BorderSizePixel=0; dot.ZIndex=202; dot.Parent=sp; UI.CreateCorner(dot,3)
        table.insert(dots, dot)
    end
    task.spawn(function()
        local rot = 0
        while lf and lf.Parent do
            rot = rot + 45; sp.Rotation = rot
            for i, d in ipairs(dots) do local a = ((rot/45)+i)%dotCount; d.BackgroundTransparency = 0.2 + (a/dotCount)*0.6 end
            task.wait(0.05)
        end
    end)
    local ml = Instance.new("TextLabel"); ml.Size=UDim2.new(1,0,0,20); ml.Position=UDim2.new(0,0,0.5,20); ml.BackgroundTransparency=1; ml.Text=liCfg.Text or "Loading..."; ml.TextColor3=CurrentTheme.Text; ml.Font=Enum.Font.GothamMedium; ml.TextSize=12; ml.ZIndex=201; ml.Parent=lf
    local pb = Instance.new("Frame"); pb.Size=UDim2.new(0,120,0,4); pb.Position=UDim2.new(0.5,-60,0.5,44); pb.BackgroundColor3=CurrentTheme.SliderTrack; pb.BorderSizePixel=0; pb.ZIndex=201; pb.Parent=lf; UI.CreateCorner(pb,2)
    local fill = Instance.new("Frame"); fill.Size=UDim2.new(0,0,1,0); fill.BackgroundColor3=CurrentTheme.Accent; fill.BorderSizePixel=0; fill.ZIndex=202; fill.Parent=pb; UI.CreateCorner(fill,2)
    local done = false
    local function setProgress(p) UI.Tween(fill,{Size=UDim2.new(math.clamp(p,0,1),0,1,0)},0.2) end
    local function dismiss() done=true; UI.FadeOut(lf,0.3); task.delay(0.35,function() if lf and lf.Parent then lf:Destroy() end end) end
    return {SetProgress=setProgress, SetText=function(_,t) ml.Text=t end, Dismiss=dismiss, IsDone=function() return done end, Frame=lf}
end

-- ═══════════════════════════════════════════════════════════════════════════
-- DEFAULT TAB: Info (auto-created unless cfg.SkipDefaults)
-- ═══════════════════════════════════════════════════════════════════════════
if not cfg.SkipDefaults then
    local infoTab = Window:CreateTab({Name="Info",Icon="\239\128\129",Order=999})
    infoTab:AddCredits({Credits={{"Hub","Apex Hub v13.0 - APEX ULTIMATE"},{"Build","v13.0 | Build "..(cfg.Build or math.random(1000,9999))},{"Player",LP.Name.." (ID: "..LP.UserId..")"},{"Executor",UI.Executor},{"Platform",game.PlaceId > 0 and ("Place: "..game.PlaceId) or "Studio"},{"Developer","Apex Team"},{"Discord","discord.gg/apex"},{"Special Thanks","All supporters and testers"}}})
    infoTab:AddDivider()
    infoTab:AddChangelog({Entries={{"v13.0","Complete rewrite with new component system"},{"v12.5","Added theme switcher, toast system, search box"},{"v12.0","New color picker, toggle grid, countdown timer"},{"v11.0","Full UI library rewrite"},{"v10.0","Legacy version"}}})
    infoTab:AddInfoPanel({Title="System Info", Fields={{"Memory",string.format("%.1f MB",collectgarbage("count"))},{"FPS","--"},{"Ping","--"},{"Time",os.date("%H:%M:%S")},{"Date",os.date("%Y-%m-%d")},{"Server",game.JobId and string.sub(game.JobId,1,8) or "N/A"}}})
end

-- ═══════════════════════════════════════════════════════════════════════════
-- AUTO-SAVE ON GAME CLOSE
-- ═══════════════════════════════════════════════════════════════════════════
game:BindToClose(function()
    pcall(function() UI.SaveState() end)
end)

return UI

