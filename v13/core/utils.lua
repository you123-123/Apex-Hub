------------------------------------------------------------------------
-- Apex Hub v13.0 APEX ULTIMATE  ─  Utilities Module
-- Author: Apex Team
-- Description: Core utility library providing notifications, table,
--              string, number, math, drawing, UI, color, file, clipboard,
--              performance, and debug helpers used throughout the hub.
------------------------------------------------------------------------

local A = _G.Apex or {}

------------------------------------------------------------------------
-- §0  REFERENCES & CONSTANTS
------------------------------------------------------------------------

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local HttpService        = game:GetService("HttpService")
local TweenService       = game:GetService("TweenService")
local SoundService       = game:GetService("SoundService")
local StarterGui         = game:GetService("StarterGui")
local Stats              = game:GetService("Stats")
local CoreGui            = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

A.FolderPath          = "ApexHub_v13"
A.NotificationQueue   = {}
A._Timers             = {}
A._Version            = "13.0.0"

------------------------------------------------------------------------
-- §1  NOTIFICATION SYSTEM
------------------------------------------------------------------------

-- Ensure the persistent folder exists via writefile hook (exploit‑side).
pcall(function()
    if not isfolder(A.FolderPath) then
        makefolder(A.FolderPath)
    end
end)

------------------------------------------------------------------------
-- §1.1  Internal notification helpers
------------------------------------------------------------------------

local _NotifGui = nil

local function GetNotifGui()
    if _NotifGui and _NotifGui.Parent then return _NotifGui end
    _NotifGui = Instance.new("ScreenGui")
    _NotifGui.Name                 = "ApexNotifications"
    _NotifGui.ResetOnSpawn         = false
    _NotifGui.ZIndexBehavior       = Enum.ZIndexBehavior.Sibling
    _NotifGui.DisplayOrder         = 999
    _NotifGui.IgnoreGuiInset       = true
    pcall(function() _NotifGui.Parent = CoreGui end)
    if not _NotifGui.Parent then
        _NotifGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    return _NotifGui
end

local NOTIF_WIDTH    = 320
local NOTIF_HEIGHT   = 60
local NOTIF_GAP      = 8
local NOTIF_MAX      = 5
local NOTIF_DURATION = 4
local NOTIF_COLORS   = {
    Info    = Color3.fromRGB(50, 120, 220),
    Success = Color3.fromRGB(40, 190, 80),
    Warning = Color3.fromRGB(230, 170, 30),
    Error   = Color3.fromRGB(220, 50, 50),
}

local function PlayNotifSound()
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://6042053626"
        s.Volume  = 0.25
        s.Parent  = SoundService
        s:Play()
        game:GetService("Debris"):AddItem(s, 3)
    end)
end

local function StackNotifications()
    local visible = {}
    for _, data in ipairs(A.NotificationQueue) do
        if data.Frame and data.Frame.Parent then
            table.insert(visible, data)
        end
    end
    for i, data in ipairs(visible) do
        local targetY = -((i - 1) * (NOTIF_HEIGHT + NOTIF_GAP) + 16)
        TweenService:Create(data.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -NOTIF_WIDTH - 12, 1, targetY),
        }):Play()
    end
end

local function RemoveFromQueue(data)
    for i = #A.NotificationQueue, 1, -1 do
        if A.NotificationQueue[i] == data then
            table.remove(A.NotificationQueue, i)
            break
        end
    end
end

local function CreateNotifFrame(title, text, color, duration, isClickToDismiss)
    local gui = GetNotifGui()

    local data = {}
    data.StartTime = tick()

    -- Main container
    local frame = Instance.new("Frame")
    frame.Name                 = "Notif_" .. tostring(tick())
    frame.Size                 = UDim2.new(0, NOTIF_WIDTH, 0, NOTIF_HEIGHT)
    frame.Position             = UDim2.new(1, NOTIF_WIDTH + 20, 1, -16)
    frame.BackgroundColor3     = Color3.fromRGB(25, 25, 35)
    frame.BorderSizePixel      = 0
    frame.ClipsDescendants     = true
    frame.Parent               = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent       = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color      = color or NOTIF_COLORS.Info
    stroke.Thickness  = 1.5
    stroke.Transparency = 0.3
    stroke.Parent     = frame

    -- Left accent bar
    local accent = Instance.new("Frame")
    accent.Name                 = "Accent"
    accent.Size                 = UDim2.new(0, 4, 1, 0)
    accent.Position             = UDim2.new(0, 0, 0, 0)
    accent.BackgroundColor3     = color or NOTIF_COLORS.Info
    accent.BorderSizePixel      = 0
    accent.Parent               = frame

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 10)
    accentCorner.Parent       = accent

    -- Title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name                 = "Title"
    titleLabel.Size                 = UDim2.new(1, -24, 0, 20)
    titleLabel.Position             = UDim2.new(0, 14, 0, 6)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text                 = title or "Apex Hub"
    titleLabel.TextColor3           = color or NOTIF_COLORS.Info
    titleLabel.Font                 = Enum.Font.GothamBold
    titleLabel.TextSize             = 14
    titleLabel.TextXAlignment       = Enum.TextXAlignment.Left
    titleLabel.TextTruncate         = Enum.TextTruncate.AtEnd
    titleLabel.Parent               = frame

    -- Text label
    local textLabel = Instance.new("TextLabel")
    textLabel.Name                 = "Text"
    textLabel.Size                 = UDim2.new(1, -24, 1, -28)
    textLabel.Position             = UDim2.new(0, 14, 0, 26)
    textLabel.BackgroundTransparency = 1
    textLabel.Text                 = text or ""
    textLabel.TextColor3           = Color3.fromRGB(200, 200, 210)
    textLabel.Font                 = Enum.Font.Gotham
    textLabel.TextSize             = 12
    textLabel.TextWrapped          = true
    textLabel.TextXAlignment       = Enum.TextXAlignment.Left
    textLabel.TextYAlignment       = Enum.TextYAlignment.Top
    textLabel.TextTruncate         = Enum.TextTruncate.AtEnd
    textLabel.Parent               = frame

    -- Progress bar (auto‑dismiss)
    local progress = Instance.new("Frame")
    progress.Name                 = "Progress"
    progress.Size                 = UDim2.new(1, 0, 0, 2)
    progress.Position             = UDim2.new(0, 0, 1, -2)
    progress.BackgroundColor3     = color or NOTIF_COLORS.Info
    progress.BackgroundTransparency = 0.4
    progress.BorderSizePixel      = 0
    progress.Parent               = frame

    data.Frame    = frame
    data.Progress = progress
    data.Color    = color

    -- Slide in animation
    TweenService:Create(frame, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -NOTIF_WIDTH - 12, 1, -16),
    }):Play()

    -- Progress shrink
    local dur = duration or NOTIF_DURATION
    TweenService:Create(progress, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 2),
    }):Play()

    -- Click to dismiss
    if isClickToDismiss ~= false then
        local conn
        conn = frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                -- slide out
                TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                    Position = UDim2.new(1, NOTIF_WIDTH + 20, 1, frame.Position.Y.Offset),
                }):Play()
                task.delay(0.32, function()
                    if frame and frame.Parent then frame:Destroy() end
                end)
                RemoveFromQueue(data)
                task.delay(0.35, StackNotifications)
                if conn then conn:Disconnect() end
            end
        end)
        data.Conn = conn
    end

    -- Auto‑dismiss
    task.delay(dur, function()
        if frame and frame.Parent then
            TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Position = UDim2.new(1, NOTIF_WIDTH + 20, 1, frame.Position.Y.Offset),
            }):Play()
            task.delay(0.37, function()
                if frame and frame.Parent then frame:Destroy() end
            end)
            RemoveFromQueue(data)
            task.delay(0.4, StackNotifications)
        end
    end)

    table.insert(A.NotificationQueue, data)

    -- Enforce max visible
    if #A.NotificationQueue > NOTIF_MAX then
        local oldest = table.remove(A.NotificationQueue, 1)
        if oldest and oldest.Frame and oldest.Frame.Parent then
            oldest.Frame:Destroy()
        end
    end

    StackNotifications()
    return data
end

------------------------------------------------------------------------
-- §1.2  Public notification API
------------------------------------------------------------------------

function A.Notify(title, text, duration)
    PlayNotifSound()
    return CreateNotifFrame(title, text or "", NOTIF_COLORS.Info, duration or NOTIF_DURATION)
end

function A.BigNotify(text, color)
    local gui = GetNotifGui()

    local overlay = Instance.new("Frame")
    overlay.Name                 = "BigNotif"
    overlay.Size                 = UDim2.new(0, 500, 0, 160)
    overlay.Position             = UDim2.new(0.5, -250, 0.5, -80)
    overlay.BackgroundColor3     = Color3.fromRGB(18, 18, 28)
    overlay.BackgroundTransparency = 0.05
    overlay.BorderSizePixel      = 0
    overlay.AnchorPoint          = Vector2.new(0, 0)
    overlay.Parent               = gui

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 16)
    c.Parent       = overlay

    local s = Instance.new("UIStroke")
    s.Color        = color or NOTIF_COLORS.Info
    s.Thickness    = 2
    s.Transparency = 0.2
    s.Parent       = overlay

    local lbl = Instance.new("TextLabel")
    lbl.Size                 = UDim2.new(1, -40, 1, -20)
    lbl.Position             = UDim2.new(0, 20, 0, 10)
    lbl.BackgroundTransparency = 1
    lbl.Text                 = text or ""
    lbl.TextColor3           = color or Color3.fromRGB(255, 255, 255)
    lbl.Font                 = Enum.Font.GothamBold
    lbl.TextSize             = 28
    lbl.TextWrapped          = true
    lbl.TextScaled           = false
    lbl.Parent               = overlay

    -- Entrance
    overlay.Size     = UDim2.new(0, 0, 0, 0)
    overlay.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(overlay, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size     = UDim2.new(0, 500, 0, 160),
        Position = UDim2.new(0.5, -250, 0.5, -80),
    }):Play()

    task.delay(3, function()
        TweenService:Create(overlay, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
        }):Play()
        TweenService:Create(lbl, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
        task.delay(0.45, function() if overlay.Parent then overlay:Destroy() end end)
    end)
end

function A.WarningNotify(text)
    PlayNotifSound()
    return CreateNotifFrame("Warning", text, NOTIF_COLORS.Warning, 5)
end

function A.ErrorNotify(text)
    PlayNotifSound()
    return CreateNotifFrame("Error", text, NOTIF_COLORS.Error, 6)
end

function A.SuccessNotify(text)
    PlayNotifSound()
    return CreateNotifFrame("Success", text, NOTIF_COLORS.Success, 4)
end

function A.ClearNotifications()
    for _, data in ipairs(A.NotificationQueue) do
        if data.Conn then pcall(function() data.Conn:Disconnect() end) end
        if data.Frame and data.Frame.Parent then data.Frame:Destroy() end
    end
    A.NotificationQueue = {}
end

------------------------------------------------------------------------
-- §2  DRAWING / ESP UTILITIES
------------------------------------------------------------------------

function A.SafeDrawing(typeName)
    local ok, result = pcall(function()
        return Drawing.new(typeName)
    end)
    if ok then return result end
    return nil
end

function A.NewDrawing(typeName, props)
    local drawing = A.SafeDrawing(typeName)
    if not drawing then return nil end
    if props then
        for k, v in pairs(props) do
            pcall(function() drawing[k] = v end)
        end
    end
    return drawing
end

function A.ClearDrawings(list)
    if not list then return end
    for _, d in ipairs(list) do
        if d and typeof(d) == "Drawing" then
            pcall(function() d:Remove() end)
        end
    end
end

function A.DrawingExists(drawing)
    if not drawing then return false end
    local ok = pcall(function() return drawing.Visible end)
    return ok
end

------------------------------------------------------------------------
-- §3  TABLE UTILITIES
------------------------------------------------------------------------

function A.TableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

function A.TableFind(tbl, fn)
    for k, v in pairs(tbl) do
        if fn(v, k) then return v, k end
    end
    return nil, nil
end

function A.TableFilter(tbl, fn)
    local out = {}
    for k, v in pairs(tbl) do
        if fn(v, k) then
            out[k] = v
        end
    end
    return out
end

function A.TableMap(tbl, fn)
    local out = {}
    for k, v in pairs(tbl) do
        out[k] = fn(v, k)
    end
    return out
end

function A.TableFlatten(tbl, depth)
    depth = depth or 1
    local out = {}
    for _, v in ipairs(tbl) do
        if type(v) == "table" and depth > 0 then
            local flat = A.TableFlatten(v, depth - 1)
            for _, fv in ipairs(flat) do
                table.insert(out, fv)
            end
        else
            table.insert(out, v)
        end
    end
    return out
end

function A.TableShuffle(tbl)
    local out = A.TableCopy(tbl)
    for i = #out, 2, -1 do
        local j = math.random(1, i)
        out[i], out[j] = out[j], out[i]
    end
    return out
end

function A.TableSort(tbl, fn)
    local out = A.TableCopy(tbl)
    table.sort(out, fn)
    return out
end

function A.TableRemove(tbl, val)
    for i = #tbl, 1, -1 do
        if tbl[i] == val then
            table.remove(tbl, i)
        end
    end
    return tbl
end

function A.TableRemoveIndex(tbl, idx)
    table.remove(tbl, idx)
    return tbl
end

function A.TableMerge(t1, t2)
    local out = A.TableCopy(t1)
    for k, v in pairs(t2) do
        if type(v) == "table" and type(out[k]) == "table" then
            out[k] = A.TableMerge(out[k], v)
        else
            out[k] = A.TableCopy(v)
        end
    end
    return out
end

function A.TableCopy(t)
    if type(t) ~= "table" then return t end
    local out = {}
    for k, v in pairs(t) do
        out[A.TableCopy(k)] = A.TableCopy(v)
    end
    return setmetatable(out, getmetatable(t))
end

function A.TableKeys(t)
    local out = {}
    for k in pairs(t) do
        table.insert(out, k)
    end
    return out
end

function A.TableValues(t)
    local out = {}
    for _, v in pairs(t) do
        table.insert(out, v)
    end
    return out
end

function A.TableCount(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end

function A.TableEmpty(t)
    return next(t) == nil
end

function A.TableEqual(a, b)
    if a == b then return true end
    if type(a) ~= "table" or type(b) ~= "table" then return false end
    for k, v in pairs(a) do
        if not A.TableEqual(v, b[k]) then return false end
    end
    for k, v in pairs(b) do
        if a[k] == nil then return false end
    end
    return true
end

function A.TableReverse(t)
    local out = {}
    for i = #t, 1, -1 do
        table.insert(out, t[i])
    end
    return out
end

function A.TableSlice(t, start, stop)
    start = start or 1
    stop  = stop or #t
    local out = {}
    for i = start, stop do
        table.insert(out, t[i])
    end
    return out
end

function A.TableRandom(t)
    if #t == 0 then return nil end
    return t[math.random(1, #t)]
end

function A.TableWeightedRandom(t, weights)
    local total = 0
    for _, w in ipairs(weights) do
        total = total + w
    end
    local roll = math.random() * total
    local cum  = 0
    for i, w in ipairs(weights) do
        cum = cum + w
        if roll <= cum then return t[i] end
    end
    return t[#t]
end

------------------------------------------------------------------------
-- §4  STRING UTILITIES
------------------------------------------------------------------------

function A.StrStarts(str, prefix)
    return str:sub(1, #prefix) == prefix
end

function A.StrEnds(str, suffix)
    return suffix == "" or str:sub(-#suffix) == suffix
end

function A.StrContains(str, sub)
    return str:find(sub, 1, true) ~= nil
end

function A.StrTrim(str)
    return str:match("^%s*(.-)%s*$")
end

function A.StrSplit(str, sep)
    local out = {}
    if sep == "" then
        for i = 1, #str do
            table.insert(out, str:sub(i, i))
        end
        return out
    end
    local pattern = "([^" .. sep .. "]*)" .. sep
    for match in (str .. sep):gmatch(pattern) do
        table.insert(out, match)
    end
    return out
end

function A.StrReplace(str, old, new)
    local result, _ = str:gsub(old:gsub("([^%w])", "%%%1"), new)
    return result
end

function A.StrRepeat(str, n)
    local out = ""
    for _ = 1, n do
        out = out .. str
    end
    return out
end

function A.StrPadLeft(str, len, char)
    char = char or " "
    while #str < len do
        str = char .. str
    end
    return str
end

function A.StrFormatTime(seconds)
    seconds = math.floor(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    local parts = {}
    if h > 0 then table.insert(parts, h .. "h") end
    if m > 0 then table.insert(parts, m .. "m") end
    table.insert(parts, s .. "s")
    return table.concat(parts, " ")
end

function A.StrFormatNumber(n)
    if n >= 1e12 then
        return string.format("%.1fT", n / 1e12)
    elseif n >= 1e9 then
        return string.format("%.1fB", n / 1e9)
    elseif n >= 1e6 then
        return string.format("%.1fM", n / 1e6)
    elseif n >= 1e3 then
        return string.format("%.1fK", n / 1e3)
    end
    return tostring(math.floor(n))
end

function A.StrFormatPercent(n)
    return string.format("%.1f%%", n * 100)
end

function A.StrTruncate(str, maxLen)
    maxLen = maxLen or 30
    if #str <= maxLen then return str end
    return str:sub(1, maxLen - 3) .. "..."
end

------------------------------------------------------------------------
-- §5  NUMBER UTILITIES
------------------------------------------------------------------------

function A.NumRound(n, decimals)
    decimals = decimals or 0
    local mult = 10 ^ decimals
    return math.floor(n * mult + 0.5) / mult
end

function A.NumClamp(n, min, max)
    if n < min then return min end
    if n > max then return max end
    return n
end

function A.NumLerp(a, b, t)
    return a + (b - a) * A.NumClamp(t, 0, 1)
end

function A.NumMap(n, fromMin, fromMax, toMin, toMax)
    local t = (n - fromMin) / (fromMax - fromMin)
    return toMin + (toMax - toMin) * A.NumClamp(t, 0, 1)
end

function A.NumRandom(min, max)
    return math.random(min, max)
end

function A.NumRandomFloat(min, max)
    return min + math.random() * (max - min)
end

function A.NumAngleBetween(v1, v2)
    local dot   = v1.Unit:Dot(v2.Unit)
    local clamped = A.NumClamp(dot, -1, 1)
    return math.deg(math.acos(clamped))
end

function A.NumDistance(a, b)
    return (a - b).Magnitude
end

function A.NumDistance2D(a, b)
    local d = a - b
    return Vector3.new(d.X, 0, d.Z).Magnitude
end

function A.NumNormalize(n, min, max)
    if max == min then return 0 end
    return A.NumClamp((n - min) / (max - min), 0, 1)
end

------------------------------------------------------------------------
-- §6  FILE OPERATIONS
------------------------------------------------------------------------

function A.SaveFile(name, content)
    local ok, err = pcall(function()
        writefile(A.FolderPath .. "/" .. name, content)
    end)
    return ok, err
end

function A.LoadFile(name)
    local ok, result = pcall(function()
        return readfile(A.FolderPath .. "/" .. name)
    end)
    if ok then return result end
    return nil
end

function A.DeleteFile(name)
    local ok, err = pcall(function()
        delfile(A.FolderPath .. "/" .. name)
    end)
    return ok, err
end

function A.FileExists(name)
    local ok, exists = pcall(function()
        return isfile(A.FolderPath .. "/" .. name)
    end)
    return ok and exists or false
end

function A.ListFiles()
    local ok, files = pcall(function()
        return listfiles(A.FolderPath)
    end)
    if ok then return files end
    return {}
end

function A.SaveJSON(name, data)
    local json = HttpService:JSONEncode(data)
    return A.SaveFile(name, json)
end

function A.LoadJSON(name)
    local raw = A.LoadFile(name)
    if not raw then return nil end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if ok then return data end
    return nil
end

------------------------------------------------------------------------
-- §7  CLIPBOARD
------------------------------------------------------------------------

function A.Clip(text)
    pcall(function() setclipboard(text) end)
end

function A.ClipRead()
    local ok, result = pcall(function() return getclipboard() end)
    if ok then return result end
    return ""
end

------------------------------------------------------------------------
-- §8  UI UTILITIES
------------------------------------------------------------------------

function A.GetScreenSize()
    return workspace.CurrentCamera.ViewportSize
end

function A.GetMousePos()
    return UserInputService:GetMouseLocation()
end

function A.GetViewportSize()
    local cam = workspace.CurrentCamera
    return cam.ViewportSize
end

function A.CreateCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent       = parent
    return c
end

function A.CreateStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color        = color or Color3.fromRGB(255, 255, 255)
    s.Thickness    = thickness or 1
    s.Transparency = 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent       = parent
    return s
end

function A.CreateGradient(parent, colors)
    local g = Instance.new("UIGradient")
    if colors then
        g.Color = ColorSequence.new(colors[1] or Color3.new(1,1,1), colors[2] or Color3.new(0,0,0))
    end
    g.Parent = parent
    return g
end

function A.CreatePadding(parent, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 4)
    p.PaddingBottom = UDim.new(0, b or 4)
    p.PaddingLeft   = UDim.new(0, l or 4)
    p.PaddingRight  = UDim.new(0, r or 4)
    p.Parent        = parent
    return p
end

function A.CreateLayout(parent, direction, padding)
    local l = Instance.new("UIListLayout")
    l.FillDirection         = direction or Enum.FillDirection.Vertical
    l.Padding              = UDim.new(0, padding or 4)
    l.HorizontalAlignment  = Enum.HorizontalAlignment.Left
    l.VerticalAlignment    = Enum.VerticalAlignment.Top
    l.SortOrder            = Enum.SortOrder.LayoutOrder
    l.Parent               = parent
    return l
end

------------------------------------------------------------------------
-- §9  COLOR UTILITIES
------------------------------------------------------------------------

function A.ColorLerp(c1, c2, t)
    t = A.NumClamp(t, 0, 1)
    return Color3.new(
        c1.R + (c2.R - c1.R) * t,
        c1.G + (c2.G - c1.G) * t,
        c1.B + (c2.B - c1.B) * t
    )
end

function A.ColorRandom()
    return Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
end

function A.ColorFromHex(hex)
    hex = hex:gsub("#", "")
    if #hex == 3 then
        hex = hex:sub(1,1)..hex:sub(1,1)..hex:sub(2,2)..hex:sub(2,2)..hex:sub(3,3)..hex:sub(3,3)
    end
    local r = tonumber(hex:sub(1, 2), 16) or 0
    local g = tonumber(hex:sub(3, 4), 16) or 0
    local b = tonumber(hex:sub(5, 6), 16) or 0
    return Color3.fromRGB(r, g, b)
end

function A.ColorToHex(color)
    return string.format("#%02X%02X%02X",
        math.floor(color.R * 255),
        math.floor(color.G * 255),
        math.floor(color.B * 255)
    )
end

function A.ColorBrightness(color, amount)
    local r = A.NumClamp(color.R + amount, 0, 1)
    local g = A.NumClamp(color.G + amount, 0, 1)
    local b = A.NumClamp(color.B + amount, 0, 1)
    return Color3.new(r, g, b)
end

function A.ColorRainbow(offset)
    offset = offset or 0
    local t = (tick() + offset) % 1
    local h = t * 360
    return Color3.fromHSV(h / 360, 1, 1)
end

function A.ColorTeam()
    local ok, team = pcall(function()
        return LocalPlayer.Team
    end)
    if ok and team then
        return team.TeamColor.Color
    end
    return Color3.fromRGB(200, 200, 200)
end

function A.ColorHealth(health)
    health = A.NumClamp(health, 0, 1)
    return Color3.new(1 - health, health, 0)
end

function A.ColorRarity(rarity)
    local map = {
        Common    = Color3.fromRGB(180, 180, 180),
        Uncommon  = Color3.fromRGB(80, 200, 80),
        Rare      = Color3.fromRGB(60, 130, 240),
        Epic      = Color3.fromRGB(170, 70, 230),
        Legendary = Color3.fromRGB(240, 180, 30),
        Mythical  = Color3.fromRGB(240, 50, 50),
    }
    return map[rarity] or Color3.fromRGB(200, 200, 200)
end

------------------------------------------------------------------------
-- §10  MATH UTILITIES
------------------------------------------------------------------------

function A.MathClamp(val, min, max)
    return A.NumClamp(val, min, max)
end

function A.MathLerp(a, b, t)
    return A.NumLerp(a, b, t)
end

function A.MathRound(val, decimals)
    return A.NumRound(val, decimals)
end

function A.MathRandom(min, max)
    return math.random(min, max)
end

function A.MathAngle(from, to)
    return math.atan2(to.Z - from.Z, to.X - from.X)
end

function A.MathDirection(from, to)
    return (to - from).Unit
end

function A.MathIntersect(rayOrigin, rayDir, planePoint, planeNormal)
    local denom = planeNormal:Dot(rayDir)
    if math.abs(denom) < 1e-6 then return nil end
    local t = planePoint:Dot(planeNormal - rayOrigin) / denom
    if t < 0 then return nil end
    return rayOrigin + rayDir * t
end

function A.MathBezier(t, points)
    local pts = A.TableCopy(points)
    local n = #pts
    while n > 1 do
        local newPts = {}
        for i = 1, n - 1 do
            newPts[i] = pts[i] * (1 - t) + pts[i + 1] * t
        end
        pts = newPts
        n = #pts
    end
    return pts[1]
end

------------------------------------------------------------------------
-- §11  PERFORMANCE
------------------------------------------------------------------------

-- A.PerfStart / A.PerfEnd يعرَّفان في core/init.lua (النسخة الحاكمة المتكاملة
-- مع A.Log و A._PerfTimers). نمنع إعادة التعريف هنا لتجنب تعارض الدوال القديمة.
-- A.PerfStart = nil
-- A.PerfEnd = nil

function A.PerfReport()
    print("─── Apex Hub Performance Report ───")
    print("FPS:      " .. A.FPS())
    print("Memory:   " .. A.Memory())
    print("Ping:     " .. A.Ping() .. " ms")
    print("───────────────────────────────────")
end

function A.FPS()
    local ok, fps = pcall(function()
        return math.floor(1 / RunService.RenderStepped:Wait())
    end)
    if ok then return fps end
    return 0
end

function A.Memory()
    local ok, mem = pcall(function()
        return Stats:GetTotalMemoryUsageMb()
    end)
    if ok then return string.format("%.1f MB", mem) end
    return "0 MB"
end

function A.Ping()
    local ok, ping = pcall(function()
        return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    if ok then return ping end
    return 0
end

------------------------------------------------------------------------
-- §12  DEBUG
------------------------------------------------------------------------

function A.DebugPrint(...)
    local args = { ... }
    local parts = {}
    for i, v in ipairs(args) do
        parts[i] = tostring(v)
    end
    print("[Apex Debug] " .. table.concat(parts, " "))
end

function A.DumpTable(t, indent, visited)
    indent  = indent or 0
    visited = visited or {}
    if type(t) ~= "table" then
        return tostring(t)
    end
    if visited[t] then return "<circular ref>" end
    visited[t] = true

    local pad = string.rep("  ", indent)
    local lines = {}
    table.insert(lines, "{")
    for k, v in pairs(t) do
        local keyStr = tostring(k)
        local valStr
        if type(v) == "table" then
            valStr = A.DumpTable(v, indent + 1, visited)
        else
            valStr = tostring(v)
        end
        table.insert(lines, pad .. "  [" .. keyStr .. "] = " .. valStr)
    end
    table.insert(lines, pad .. "}")
    return table.concat(lines, "\n")
end

function A.Stacktrace()
    local trace = debug.traceback("", 2)
    print("─── Apex Stacktrace ───")
    print(trace)
    print("───────────────────────")
    return trace
end

function A.TimeFunc(fn, ...)
    local args  = { ... }
    local start = tick()
    local results = { fn(unpack(args)) }
    local elapsed = (tick() - start) * 1000
    print(string.format("[Apex Timing] %.4f ms", elapsed))
    return elapsed, unpack(results)
end

function A.GetLineInfo(level)
    level = (level or 1) + 1
    local info = debug.getinfo(level, "nSl")
    if not info then return nil end
    return {
        Source   = info.source or "?",
        Name     = info.name or "<anonymous>",
        Line     = info.currentline or -1,
        FuncLine = info.linedefined or -1,
    }
end

------------------------------------------------------------------------
-- §13  ADDITIONAL CONVENIENCE
------------------------------------------------------------------------

function A.Switch(value, cases, default)
    for case, result in pairs(cases) do
        if value == case then
            if type(result) == "function" then
                return result()
            end
            return result
        end
    end
    if default then
        if type(default) == "function" then
            return default()
        end
        return default
    end
    return nil
end

function A.Debounce(fn, delay)
    local lastCall = 0
    return function(...)
        local now = tick()
        if now - lastCall >= delay then
            lastCall = now
            return fn(...)
        end
        return nil
    end
end

function A.Throttle(fn, interval)
    local lastRun = 0
    return function(...)
        local now = tick()
        if now - lastRun >= interval then
            lastRun = now
            return fn(...)
        end
        return nil
    end
end

function A.Memoize(fn)
    local cache = {}
    return function(...)
        local key = HttpService:JSONEncode({ ... })
        if cache[key] == nil then
            cache[key] = fn(...)
        end
        return cache[key]
    end
end

function A.SafeCall(fn, ...)
    local ok, result = pcall(fn, ...)
    return ok, result
end

function A.Wait(secs)
    task.wait(secs)
end

function A.FormatError(err)
    return "[Apex Error] " .. tostring(err)
end

-- ════════════════════════════════════════════════════════════════════
-- ALGORITHMIC CORE (النوى الحاسوبية: مدمج-التخطيط، شجرة، توجيه)
-- ════════════════════════════════════════════════════════════════════

-- Distancia مضاعفة إقليدية (للعمليات عالية الدقة)
function A.VectorDist(a, b)
    if not a or not b then return 0 end
    local dx = (a.X or a.x or 0) - (b.X or b.x or 0)
    local dy = (a.Y or a.y or 0) - (b.Y or b.y or 0)
    local dz = (a.Z or a.z or 0) - (b.Z or b.z or 0)
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

-- إقحام خطّي متعدد (lerp) بين جدولا نقاط
function A.LerpPoint(a, b, t)
    local cl = math.max(0, math.min(1, t))
    return {
        X = (a.X or a.x or 0) + ((b.X or b.x or 0) - (a.X or a.x or 0)) * cl,
        Y = (a.Y or a.y or 0) + ((b.Y or b.y or 0) - (a.Y or a.y or 0)) * cl,
        Z = (a.Z or a.z or 0) + ((b.Z or b.z or 0) - (a.Z or a.z or 0)) * cl,
    }
end

-- منجّل تتريس بين نقطتين عبر مجموعة نقاط وسيطة (صف-كدالة)
function A.Follower(a, b, opts)
    opts = opts or {}
    local waypoints = { a }
    for i = 1, (opts.steps or 4) do
        table.insert(waypoints, A.LerpPoint(a, b, i / (opts.steps or 4)))
    end
    table.insert(waypoints, b)
    return waypoints
end

-- Currency كيمياء: تحويل رقم لـK/M/B (عرض جميل)
function A.FormatNumber(n)
    n = tonumber(n) or 0
    local abs = math.abs(n)
    if abs >= 1e9 then return string.format("%.2fB", n / 1e9) end
    if abs >= 1e6 then return string.format("%.2fM", n / 1e6) end
    if abs >= 1e3 then return string.format("%.2fK", n / 1e3) end
    return string.format("%.0f", n)
end

-- خوارزمية الانحدار الخطي البسيط (للمؤشرات الزمنية)
function A.LinearRegression(points, key)
    key = key or function(p) return p end
    local n = #points
    if n < 2 then return 0, 0 end
    local sumX, sumY, sumXY, sumXX = 0, 0, 0, 0
    for i, p in ipairs(points) do
        sumX = sumX + i
        local y = key(p)
        sumY = sumY + y
        sumXY = sumXY + i * y
        sumXX = sumXX + i * i
    end
    local denom = n * sumXX - sumX * sumX
    if denom == 0 then return 0, 0 end
    local slope = (n * sumXY - sumX * sumY) / denom
    local itcp = (sumY - slope * sumX) / n
    return slope, itcp
end

-- لاقتصاص جد самым أمان داخل Lua: توزيع حواجز آمنة
function A.PowerClamp(value, minV, maxV)
    return math.max(minV, math.min(maxV, value))
end

-- عشوائية كاملة عالية الجودة (للجّابة) — تغذيةSeed
function A.RandomRange(minV, maxV)
    if minV > maxV then minV, maxV = maxV, minV end
    return minV + math.random() * (maxV - minV)
end

-- مقارنة تقريبية بين قيم عائمة (دقة مرنة)
function A.ApproxEqual(a, b, epsilon)
    return math.abs(a - b) < (epsilon or 1e-6)
end

-- متجه تجنّب: يصعب التحقق من تعديله داخل مجلد
function A.AvoidanceVec(current, threat, strength)
    if not current or not threat then return current end
    local dx = (current.X or 0) - (threat.X or 0)
    local dz = (current.Z or 0) - (threat.Z or 0)
    local mag = math.sqrt(dx*dx + dz*dz)
    if mag == 0 then return current end
    return {
        X = (current.X or 0) + (dx / mag) * (strength or 3),
        Y = current.Y or 0,
        Z = (current.Z or 0) + (dz / mag) * (strength or 3),
    }
end

-- ════════════════════════════════════════════════════════════════════
-- BRAIN / MEMORY BANK → مفصول إلى core/brain.lua (نظام مستقل)
-- A.Brain يعرَّف الآن في ملفه المخصص.

return A
