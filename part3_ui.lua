-- ══════════════════════════════════════════════════════════════════════════
-- IMPORTS from _G.Apex (Part1 + Part2 exports)
-- ══════════════════════════════════════════════════════════════════════════
local C = _G.Apex.C; local F = _G.Apex.F
local P = _G.Apex.P; local RS = _G.Apex.RS; local WS = _G.Apex.WS
local UIS = _G.Apex.UIS; local TS = _G.Apex.TS; local HS = _G.Apex.HS
local RS2 = _G.Apex.RS2; local VU = _G.Apex.VU; local VIM = _G.Apex.VIM
local TPS = _G.Apex.TPS; local SG = _G.Apex.SG
local Debris = _G.Apex.Debris; local PathService = _G.Apex.PathService
local Stats = _G.Apex.Stats; local Light = _G.Apex.Light
local LP = _G.Apex.LP; local Mouse = _G.Apex.Mouse; local Cam = _G.Apex.Cam
local EXEC = _G.Apex.EXEC; local EXP = _G.Apex.EXP
local HTTP = _G.Apex.HTTP; local Clip = _G.Apex.Clip; local Notify = _G.Apex.Notify
local Alive = _G.Apex.Alive; local HRP = _G.Apex.HRP
local Hum = _G.Apex.Hum; local HP = _G.Apex.HP
local Lv = _G.Apex.Lv; local Beli = _G.Apex.Beli
local Frags = _G.Apex.Frags; local Sea = _G.Apex.Sea
local Bounty = _G.Apex.Bounty; local Island = _G.Apex.Island
local GetRace = _G.Apex.GetRace
local EnsureFolder = _G.Apex.EnsureFolder
local SaveConfig = _G.Apex.SaveConfig; local LoadConfig = _G.Apex.LoadConfig
local DeleteConfig = _G.Apex.DeleteConfig
local HumanizedOffset = _G.Apex.HumanizedOffset
local TpTo = _G.Apex.TpTo; local InstantTP = _G.Apex.InstantTP
local CancelMove = _G.Apex.CancelMove
local SmartPathfind = _G.Apex.SmartPathfind
local CommF = _G.Apex.CommF; local CommE = _G.Apex.CommE
local FireR = _G.Apex.FireR; local RandDelay = _G.Apex.RandDelay
local ApplyJitter = _G.Apex.ApplyJitter
local GetJitteredPosition = _G.Apex.GetJitteredPosition
local SuperAttack = _G.Apex.SuperAttack
local SafeModePvPCheck = _G.Apex.SafeModePvPCheck
local TPToLocation = _G.Apex.TPToLocation
local FindMob = _G.Apex.FindMob; local FindSmartMob = _G.Apex.FindSmartMob
local FindAllMobs = _G.Apex.FindAllMobs
local HasWeapon = _G.Apex.HasWeapon; local Attack = _G.Apex.Attack
local KillAura = _G.Apex.KillAura; local UltraCombo = _G.Apex.UltraCombo
local EquipType = _G.Apex.EquipType; local EquipBest = _G.Apex.EquipBest
local DeathWait = _G.Apex.DeathWait; local SafeCheck = _G.Apex.SafeCheck
local GetQuest = _G.Apex.GetQuest; local GetOptimalStats = _G.Apex.GetOptimalStats
local PredictPosition = _G.Apex.PredictPosition
local AcceptQuest = _G.Apex.AcceptQuest; local SmartQuestSwitch = _G.Apex.SmartQuestSwitch
local BuyRaidChip = _G.Apex.BuyRaidChip; local FindRaidChip = _G.Apex.FindRaidChip
local FindRaidConsole = _G.Apex.FindRaidConsole; local FindRaidRoom = _G.Apex.FindRaidRoom
local GetCDKProgress = _G.Apex.GetCDKProgress
local Quests = _G.Apex.Quests; local Bosses = _G.Apex.Bosses
local EliteEnemies = _G.Apex.EliteEnemies; local Raids = _G.Apex.Raids
local FruitDB = _G.Apex.FruitDB; local RO = _G.Apex.RO
local MaterialsDB = _G.Apex.MaterialsDB
local AllBossDropWeapons = _G.Apex.AllBossDropWeapons
local IslandLocations = _G.Apex.IslandLocations
local FightingStylesShop = _G.Apex.FightingStylesShop
local SwordShop = _G.Apex.SwordShop; local GunShop = _G.Apex.GunShop
local AbilitiesShop = _G.Apex.AbilitiesShop
local BossDropWeaponsSea1 = _G.Apex.BossDropWeaponsSea1
local BossDropWeaponsSea2 = _G.Apex.BossDropWeaponsSea2
local BossDropWeaponsSea3 = _G.Apex.BossDropWeaponsSea3
local ClearCharCache = _G.Apex.ClearCharCache
local JitterOffset = _G.Apex.JitterOffset
-- Part2 exports
local QueueScript = _G.Apex.QueueScript; local DoHop = _G.Apex.DoHop
local FindBountyTargets = _G.Apex.FindBountyTargets
local CreateESP = _G.Apex.CreateESP; local ClearESP = _G.Apex.ClearESP
local ESPObjects = _G.Apex.ESPObjects
local ScanFruits = _G.Apex.ScanFruits
local CollectFruit = _G.Apex.CollectFruit; local StoreFruit = _G.Apex.StoreFruit
local BuyFromShop = _G.Apex.BuyFromShop
local CollectRaceFragments = _G.Apex.CollectRaceFragments
local GetFruitValue = _G.Apex.GetFruitValue
local FreezeTrade = _G.Apex.FreezeTrade
local AutoAcceptTrade = _G.Apex.AutoAcceptTrade
local SelectBoat = _G.Apex.SelectBoat; local AutoFish = _G.Apex.AutoFish
local SendCustomWebhook = _G.Apex.SendCustomWebhook
local FormatNumber = _G.Apex.FormatNumber
local ApplySpeed = _G.Apex.ApplySpeed; local ApplyDash = _G.Apex.ApplyDash
local ToggleNoclip = _G.Apex.ToggleNoclip
local ToggleInfiniteJump = _G.Apex.ToggleInfiniteJump
local ToggleAimbot = _G.Apex.ToggleAimbot
local BuyLegendarySword = _G.Apex.BuyLegendarySword
local QuestBypass = _G.Apex.QuestBypass
local RainParts = _G.Apex.RainParts
local Highlights = _G.Apex.Highlights
local Boats = _G.Apex.Boats
local FishingRods = _G.Apex.FishingRods; local BaitTypes = _G.Apex.BaitTypes
local flyBV = _G.Apex.flyBV; local flyBG = _G.Apex.flyBG
local BountyState = _G.Apex.BountyState
local MemStats = {Cleanups=0, ObjectsRemoved=0, LastCleanup=0}
-- ══════════════════════════════════════════════════════════════════════════

local Theme = {
    BG=Color3.fromRGB(15,15,25), Bar=Color3.fromRGB(25,25,40),
    Accent=Color3.fromRGB(255,70,70), Sec=Color3.fromRGB(20,20,35),
    Text=Color3.fromRGB(235,235,235), Dim=Color3.fromRGB(140,140,160),
    ToggleOff=Color3.fromRGB(55,55,75), SliderBG=Color3.fromRGB(35,35,55),
    DropBG=Color3.fromRGB(30,30,50), Border=Color3.fromRGB(35,35,55)
}
local function M(cls, props, kids)
    local i = Instance.new(cls)
    for k,v in pairs(props or {}) do pcall(function() i[k]=v end) end
    for _,c in ipairs(kids or {}) do c.Parent = i end
    return i
end
local function Cr(p,r) return M("UICorner",{CornerRadius=UDim.new(0,r or 8)},{},p) end
local function St(p,c,t) return M("UIStroke",{Color=c or Theme.Border,Thickness=t or 1},{},p) end
local scr = M("ScreenGui",{Name="ApexHub",ZIndexBehavior=Enum.ZIndexBehavior.Sibling,ResetOnSpawn=false})
local main = M("Frame",{Size=UDim2.new(0,800,0,600),Position=UDim2.new(0.5,-400,0.5,-300),BackgroundColor3=Theme.BG,BorderSizePixel=0,Active=true},{scr})
Cr(main,12); St(main,Theme.Accent,2)
local tb = M("Frame",{Size=UDim2.new(1,0,0,42),BackgroundColor3=Theme.Bar,BorderSizePixel=0},{main})
M("TextLabel",{Size=UDim2.new(0.5,0,1,0),Position=UDim2.new(0,15,0,0),BackgroundTransparency=1,Text="APEX HUB v12.0 APEX COMPLETE",TextColor3=Theme.Accent,TextSize=16,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},{tb})
local infoLbl = M("TextLabel",{Size=UDim2.new(0.45,0,1,0),Position=UDim2.new(0.53,0,0,0),BackgroundTransparency=1,Text=EXEC.." | Lv"..Lv(),TextColor3=Theme.Dim,TextSize=12,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Right},{tb})
local closeBtn = M("TextButton",{Size=UDim2.new(0,28,0,28),Position=UDim2.new(1,-36,0,7),BackgroundColor3=Color3.fromRGB(255,60,60),Text="X",TextColor3=Color3.new(1,1,1),TextSize=13,Font=Enum.Font.GothamBold,AutoButtonColor=true},{tb})
Cr(closeBtn,6)
local tabC = M("Frame",{Size=UDim2.new(0,140,1,-42),Position=UDim2.new(0,0,0,42),BackgroundColor3=Theme.Bar,BorderSizePixel=0},{main})
local tabList = M("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ScrollBarThickness=3,ScrollBarImageColor3=Theme.Accent,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y},{tabC})
M("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},{tabList})
local content = M("Frame",{Size=UDim2.new(1,-150,1,-46),Position=UDim2.new(0,148,0,44),BackgroundColor3=Theme.BG,BorderSizePixel=0},{main})
Cr(content,6)
local minimized = false
closeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized; tabC.Visible = not minimized
    main.Size = minimized and UDim2.new(0,800,0,42) or UDim2.new(0,800,0,600)
    closeBtn.Text = minimized and "+" or "X"
end)
local dragging, dragStart, startPos
tb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)
local AllTabs = {}
local function MakeTab(name)
    local btn = M("TextButton",{Size=UDim2.new(1,0,0,28),BackgroundColor3=Color3.fromRGB(45,45,65),Text=name,TextColor3=Theme.Dim,TextSize=10,Font=Enum.Font.GothamMedium,AutoButtonColor=true,Order=#AllTabs},{tabList})
    Cr(btn,6)
    local frame = M("ScrollingFrame",{Size=UDim2.new(1,-10,1,-10),Position=UDim2.new(0,5,0,5),BackgroundTransparency=1,Visible=false,ScrollBarThickness=3,ScrollBarImageColor3=Theme.Accent,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y},{content})
    M("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},{frame})
    local tab = {Frame=frame, Button=btn, Name=name}
    table.insert(AllTabs, tab)
    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(AllTabs) do t.Frame.Visible=false; t.Button.BackgroundColor3=Color3.fromRGB(45,45,65); t.Button.TextColor3=Theme.Dim end
        frame.Visible=true; btn.BackgroundColor3=Theme.Accent; btn.TextColor3=Theme.Text
    end)
    function tab:AddSection(n)
        local f = M("Frame",{Size=UDim2.new(1,0,0,26),BackgroundTransparency=1},{frame})
        M("TextLabel",{Size=UDim2.new(0.8,0,1,0),Position=UDim2.new(0,5,0,0),BackgroundTransparency=1,Text="-- "..n.." --",TextColor3=Theme.Accent,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},{f})
    end
    function tab:AddLabel(n)
        M("TextLabel",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,Text=n,TextColor3=Theme.Dim,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},{frame})
    end
    function tab:AddButton(cfg)
        local b = M("TextButton",{Size=UDim2.new(1,0,0,28),BackgroundColor3=Theme.Accent,Text=cfg.Name,TextColor3=Theme.Text,TextSize=11,Font=Enum.Font.GothamMedium,AutoButtonColor=true},{frame})
        Cr(b,6)
        b.MouseButton1Click:Connect(function() pcall(cfg.Callback) end)
    end
    function tab:AddToggle(cfg)
        local f = M("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=Theme.Sec,BorderSizePixel=0},{frame})
        Cr(f,6)
        M("TextLabel",{Size=UDim2.new(0.7,0,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text=cfg.Name,TextColor3=Theme.Text,TextSize=10,Font=Enum.Font.GothamMedium,TextXAlignment=Enum.TextXAlignment.Left},{f})
        local bg = M("Frame",{Size=UDim2.new(0,40,0,20),Position=UDim2.new(1,-52,0.5,-10),BackgroundColor3=cfg.Default and Theme.Accent or Theme.ToggleOff},{f})
        Cr(bg,10)
        local dot = M("Frame",{Size=UDim2.new(0,16,0,16),Position=cfg.Default and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8),BackgroundColor3=Theme.Text},{bg})
        Cr(dot,8)
        local state = cfg.Default or false
        local function upd()
            bg.BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff
            dot:TweenPosition(state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        end
        M("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=""},{f}).MouseButton1Click:Connect(function()
            state = not state; upd(); pcall(cfg.Callback, state)
        end)
        upd()
    end
    function tab:AddSlider(cfg)
        local f = M("Frame",{Size=UDim2.new(1,0,0,42),BackgroundColor3=Theme.Sec,BorderSizePixel=0},{frame})
        Cr(f,6)
        local mn=cfg.Min or 0; local mx=cfg.Max or 100; local val=cfg.Default or mn; local inc=cfg.Increment or 1; local vn=cfg.ValueName or ""
        M("TextLabel",{Size=UDim2.new(0.6,0,0,16),Position=UDim2.new(0,12,0,3),BackgroundTransparency=1,Text=cfg.Name,TextColor3=Theme.Text,TextSize=10,Font=Enum.Font.GothamMedium,TextXAlignment=Enum.TextXAlignment.Left},{f})
        local vl = M("TextLabel",{Size=UDim2.new(0.35,0,0,16),Position=UDim2.new(0.63,0,0,3),BackgroundTransparency=1,Text=tostring(val).." "..vn,TextColor3=Theme.Accent,TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Right},{f})
        local sbg = M("Frame",{Size=UDim2.new(1,-24,0,5),Position=UDim2.new(0,12,0,28),BackgroundColor3=Theme.SliderBG},{f})
        Cr(sbg,3)
        local pct=(val-mn)/(mx-mn)
        local fill = M("Frame",{Size=UDim2.new(pct,0,1,0),BackgroundColor3=Theme.Accent},{sbg})
        Cr(fill,3)
        local knob = M("Frame",{Size=UDim2.new(0,12,0,12),Position=UDim2.new(pct,-6,0.5,-6),BackgroundColor3=Theme.Text},{sbg})
        Cr(knob,6)
        local sliding = false
        local function update(x)
            local p = math.clamp((x-sbg.AbsolutePosition.X)/sbg.AbsoluteSize.X,0,1)
            val = math.floor((mn+(mx-mn)*p)/inc+0.5)*inc; val=math.clamp(val,mn,mx)
            local np=(val-mn)/(mx-mn); fill.Size=UDim2.new(np,0,1,0); knob.Position=UDim2.new(np,-6,0.5,-6)
            vl.Text = tostring(val).." "..vn
        end
        M("TextButton",{Size=UDim2.new(0,16,0,16),Position=UDim2.new(pct,-8,0.5,-8),BackgroundTransparency=1,Text=""},{sbg}).InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=true end end)
        UIS.InputEnded:Connect(function(i) if sliding and i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false; pcall(cfg.Callback,val) end end)
        UIS.InputChanged:Connect(function(i) if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then update(i.Position.X) end end)
        sbg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=true; update(i.Position.X) end end)
    end
    function tab:AddDropdown(cfg)
        local f = M("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=Theme.Sec,BorderSizePixel=0},{frame})
        Cr(f,6)
        M("TextLabel",{Size=UDim2.new(0.45,0,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text=cfg.Name,TextColor3=Theme.Text,TextSize=10,Font=Enum.Font.GothamMedium,TextXAlignment=Enum.TextXAlignment.Left},{f})
        local sel = cfg.Default or cfg.Options[1] or ""
        local selLbl = M("TextLabel",{Size=UDim2.new(0.4,0,1,0),Position=UDim2.new(0.55,0,0,0),BackgroundTransparency=1,Text=sel,TextColor3=Theme.Accent,TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Right},{f})
        M("TextLabel",{Size=UDim2.new(0,20,1,0),Position=UDim2.new(1,-22,0,0),BackgroundTransparency=1,Text=">",TextColor3=Theme.Dim,TextSize=13,Font=Enum.Font.GothamBold},{f})
        local open=false
        local list = M("ScrollingFrame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,1,2),BackgroundColor3=Theme.DropBG,BorderSizePixel=0,Visible=false,ScrollBarThickness=3,ScrollBarImageColor3=Theme.Accent,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Z,ZIndex=10},{f})
        Cr(list,6)
        M("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},{list})
        local function build()
            for _,c in ipairs(list:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
            for _,opt in ipairs(cfg.Options) do
                local ob=M("TextButton",{Size=UDim2.new(1,0,0,22),BackgroundColor3=Theme.Sec,Text="  "..opt,TextColor3=opt==sel and Theme.Accent or Theme.Text,TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=true,ZIndex=11},{list})
                Cr(ob,4)
                ob.MouseButton1Click:Connect(function() sel=opt; selLbl.Text=opt; open=false; list.Visible=false; list.Size=UDim2.new(1,0,0,0); pcall(cfg.Callback,opt) end)
            end
        end
        M("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=""},{f}).MouseButton1Click:Connect(function()
            open=not open; if open then build() end
            list.Visible=open; list.Size=open and UDim2.new(1,0,0,math.min(#cfg.Options*24+4,150)) or UDim2.new(1,0,0,0)
        end)
    end
    return tab
end
local T1=MakeTab("Main")
T1:AddSection("Info")
T1:AddLabel("Executor: "..EXEC)
T1:AddLabel("Level: "..Lv())
T1:AddLabel("Beli: "..Beli())
T1:AddLabel("Fragments: "..Frags())
T1:AddLabel("Sea: "..Sea())
T1:AddLabel("Bounty: "..Bounty())
T1:AddSection("Safety")
T1:AddToggle({Name="Low Health Safe Mode",Default=F.LowHP,Callback=function(v) F.LowHP=v end})
T1:AddSlider({Name="Safe HP%",Min=5,Max=50,Default=C.SafeHP,ValueName="%",Callback=function(v) C.SafeHP=v end})
T1:AddSection("Movement")
T1:AddSlider({Name="Walk Speed",Min=16,Max=500,Default=C.WalkSpeed,Callback=function(v) C.WalkSpeed=v; local h=Hum(); if h then h.WalkSpeed=v end end})
T1:AddSlider({Name="Jump Power",Min=50,Max=500,Default=C.JumpPower,Callback=function(v) C.JumpPower=v; local h=Hum(); if h then h.JumpPower=v end end})
T1:AddToggle({Name="Fly (WASD+Space+Shift)",Default=F.Fly,Callback=function(v) F.Fly=v end})
T1:AddSlider({Name="Fly Speed",Min=20,Max=200,Default=C.FlySpeed,Callback=function(v) C.FlySpeed=v end})
T1:AddToggle({Name="Auto Set Spawn",Default=F.AutoSetSpawn,Callback=function(v) F.AutoSetSpawn=v end})
T1:AddSection("Server")
T1:AddButton({Name="Rejoin",Callback=function() QueueScript(); TPS:Teleport(game.PlaceId,LP) end})
T1:AddButton({Name="Server Hop",Callback=function() DoHop() end})
T1:AddButton({Name="Copy Job ID",Callback=function() Clip(game.JobId) end})
local T2=MakeTab("Farm")
T2:AddSection("Level Farm")
T2:AddToggle({Name="Auto Farm",Default=F.AutoFarm,Callback=function(v) F.AutoFarm=v end})
T2:AddToggle({Name="Auto Quest",Default=F.AutoQuest,Callback=function(v) F.AutoQuest=v end})
T2:AddToggle({Name="Fast Attack",Default=F.FastAttack,Callback=function(v) F.FastAttack=v end})
T2:AddToggle({Name="Kill Aura",Default=F.KillAura,Callback=function(v) F.KillAura=v end})
T2:AddSlider({Name="Kill Aura Range",Min=5,Max=50,Default=C.KillAuraRange,ValueName="m",Callback=function(v) C.KillAuraRange=v end})
T2:AddToggle({Name="Bring Mobs",Default=F.BringMob,Callback=function(v) F.BringMob=v end})
T2:AddSlider({Name="Bring Range",Min=10,Max=60,Default=C.BringMobRange,ValueName="m",Callback=function(v) C.BringMobRange=v end})
T2:AddSection("V10 Farm All")
T2:AddToggle({Name="Auto Farm All (Master)",Default=F.FarmAll,Callback=function(v) F.FarmAll=v end})
T2:AddLabel("Auto switches quests, farms optimally")
T2:AddSection("Boss")
T2:AddToggle({Name="Auto Boss Farm",Default=F.AutoBossFarm,Callback=function(v) F.AutoBossFarm=v end})
T2:AddSection("Mastery")
T2:AddToggle({Name="Auto Mastery (Fruit)",Default=F.AutoMasteryFruit,Callback=function(v) F.AutoMasteryFruit=v end})
T2:AddToggle({Name="Auto Mastery (Sword)",Default=F.AutoMasterySword,Callback=function(v) F.AutoMasterySword=v end})
T2:AddSection("Stats")
T2:AddToggle({Name="Auto Stats",Default=F.AutoStats,Callback=function(v) F.AutoStats=v end})
T2:AddDropdown({Name="Stat",Default=C.StatType,Options={"Melee","Defense","Sword","Gun","Blox Fruit"},Callback=function(v) C.StatType=v end})
T2:AddSection("Smart Stats")
T2:AddToggle({Name="Smart Stat Distribution",Default=F.SmartStatDist,Callback=function(v) F.SmartStatDist=v end})
T2:AddDropdown({Name="Priority 1",Default=C.SmartStat1,Options={"Melee","Defense","Sword","Gun","Blox Fruit"},Callback=function(v) C.SmartStat1=v end})
T2:AddDropdown({Name="Priority 2",Default=C.SmartStat2,Options={"Melee","Defense","Sword","Gun","Blox Fruit"},Callback=function(v) C.SmartStat2=v end})
T2:AddDropdown({Name="Priority 3",Default=C.SmartStat3,Options={"Melee","Defense","Sword","Gun","Blox Fruit"},Callback=function(v) C.SmartStat3=v end})
T2:AddSlider({Name="Primary Split %",Min=10,Max=90,Default=C.SmartStatSplit,ValueName="%",Callback=function(v) C.SmartStatSplit=v end})
T2:AddSection("Bone Farm")
T2:AddToggle({Name="Auto Farm Bones",Default=F.AutoFarmBones,Callback=function(v) F.AutoFarmBones=v end})
T2:AddLabel("Collects bone drops and kills Skeleton/Mummy mobs")
T2:AddSection("Candy Farm")
T2:AddToggle({Name="Auto Farm Candy",Default=F.AutoFarmCandy,Callback=function(v) F.AutoFarmCandy=v end})
T2:AddLabel("Collects candy drops and kills Cookie/Candy mobs")
T2:AddSection("Tree Farm")
T2:AddToggle({Name="Auto Tree Destroyer",Default=F.AutoTreeDestroyer,Callback=function(v) F.AutoTreeDestroyer=v end})
T2:AddSlider({Name="Tree Farm Range",Min=50,Max=500,Default=C.TreeFarmRange,ValueName="m",Callback=function(v) C.TreeFarmRange=v end})
T2:AddLabel("Destroys trees and collects wood drops")
T2:AddSection("Sea Progression")
T2:AddToggle({Name="Auto Second Sea (Lv 700+)",Default=F.AutoSecondSea,Callback=function(v) F.AutoSecondSea=v end})
T2:AddLabel("Auto accepts Military Officer quest and farms to Sea 2")
T2:AddToggle({Name="Auto Third Sea (Lv 1500+)",Default=F.AutoThirdSea,Callback=function(v) F.AutoThirdSea=v end})
T2:AddLabel("Auto talks to Dead Receiver/Alchemist for Sea 3")
local T3=MakeTab("Fruits")
T3:AddSection("Scanner")
T3:AddToggle({Name="Auto Find & Collect",Default=F.AutoFindFruits,Callback=function(v) F.AutoFindFruits=v end})
T3:AddToggle({Name="Auto Store",Default=F.AutoStoreFruits,Callback=function(v) F.AutoStoreFruits=v end})
T3:AddDropdown({Name="Min Rarity",Default=C.MinFruitRarity,Options={"Common","Uncommon","Rare","Legendary","Mythical"},Callback=function(v) C.MinFruitRarity=v end})
T3:AddButton({Name="Scan Now",Callback=function()
    local fr=ScanFruits(10000)
    Notify("Scan","Found "..#fr.." fruits",5)
    for i=1,math.min(5,#fr) do Notify("Fruit",fr[i].Name.." ["..(fr[i].Data and fr[i].Data.R or "?").."] "..math.floor(fr[i].Dist).."m",5) end
end})
T3:AddSection("Dealer")
T3:AddToggle({Name="Fruit Sniper (Legendary+)",Default=F.FruitSniper,Callback=function(v) F.FruitSniper=v end})
T3:AddToggle({Name="Auto Dealer Roll",Default=F.AutoDealerRoll,Callback=function(v) F.AutoDealerRoll=v end})
T3:AddButton({Name="Buy Random Fruit",Callback=function() TpTo(CFrame.new(-1250,8,-1170).Position,400); task.wait(1); pcall(function() CommF("BuyRandomFruit") end) end})
T3:AddSection("Rain")
T3:AddDropdown({Name="Rain Type",Default=F.FruitRainType,Options={"All","Rare","Legendary"},Callback=function(v) F.FruitRainType=v end})
T3:AddToggle({Name="Visual Fruit Rain",Default=F.FruitRain,Callback=function(v) F.FruitRain=v; if not v then for _,p in ipairs(RainParts) do if p and p.Parent then p:Destroy() end end; RainParts={} end end})
local T4=MakeTab("Raid")
T4:AddSection("Raid System")
T4:AddToggle({Name="Auto Raid",Default=F.AutoRaid,Callback=function(v) F.AutoRaid=v end})
T4:AddToggle({Name="Auto Start Raid",Default=F.RaidAutoStart,Callback=function(v) F.RaidAutoStart=v end})
T4:AddToggle({Name="Auto Rotate Rooms",Default=F.RaidAutoRotate,Callback=function(v) F.RaidAutoRotate=v end})
T4:AddDropdown({Name="Raid Type",Default=C.RaidChip,Options={"Flame","Ice","Quake","Light","Dark","Magma","Rumble","Spider","Buddha","Phoenix","Dough"},Callback=function(v) C.RaidChip=v; RaidState.ChipBought=false end})
T4:AddButton({Name="Buy Raid Chip",Callback=function()
    Notify("Raid", "Buying "..C.RaidChip.." chip...", 3)
    BuyRaidChip(C.RaidChip)
end})
local T5=MakeTab("CDK")
T5:AddSection("Cursed Dual Katana")
T5:AddToggle({Name="Auto CDK (Master)",Default=F.AutoCDK,Callback=function(v) F.AutoCDK=v end})
T5:AddToggle({Name="Auto Demonic Wisps",Default=F.CDKAutoWisps,Callback=function(v) F.CDKAutoWisps=v end})
T5:AddToggle({Name="Auto Elite Enemies",Default=F.CDKAutoElites,Callback=function(v) F.CDKAutoElites=v end})
T5:AddToggle({Name="Auto Soul Reaper",Default=F.CDKAutoSoulReaper,Callback=function(v) F.CDKAutoSoulReaper=v end})
T5:AddToggle({Name="Auto Scroll Finder",Default=F.CDKAutoScrolls,Callback=function(v) F.CDKAutoScrolls=v end})
T5:AddSection("Progress")
T5:AddLabel("Wisps: 0 | Elites: 0")
T5:AddButton({Name="Check CDK Progress",Callback=function()
    GetCDKProgress()
    Notify("CDK Progress", "Wisps: "..CDKState.Wisps.."/30 | Elites: "..CDKState.Elites, 5)
end})
local T6=MakeTab("Bounty")
T6:AddSection("Bounty Hunter")
T6:AddToggle({Name="Auto Bounty Hunt",Default=F.BountyHunt,Callback=function(v) F.BountyHunt=v end})
T6:AddToggle({Name="Auto Attack Target",Default=F.BountyAutoAttack,Callback=function(v) F.BountyAutoAttack=v end})
T6:AddSlider({Name="Target Min Bounty",Min=100000,Max=10000000,Default=C.BountyTargetBounty,ValueName="",Callback=function(v) C.BountyTargetBounty=v end})
T6:AddSection("V10 Revenge")
T6:AddToggle({Name="Auto PvP Revenge",Default=F.AutoRevenge,Callback=function(v) F.AutoRevenge=v end})
T6:AddLabel("Fights back when high bounty players attack")
T6:AddSection("Status")
T6:AddSection("PvP Tools")
T6:AddToggle({Name="Aimbot Camera Lock",Default=F.AimbotEnabled,Callback=function(v) F.AimbotEnabled=v end})
T6:AddSlider({Name="Aimbot FOV",Min=50,Max=500,Default=C.AimbotFOV,ValueName="px",Callback=function(v) C.AimbotFOV=v end})
T6:AddLabel("Locks camera to nearest enemy within FOV")
T6:AddSection("Targets")
T6:AddButton({Name="Scan Bounty Targets",Callback=function()
    local targets = FindBountyTargets()
    Notify("Bounty", "Found "..#targets.." targets", 3)
    for i=1,math.min(3,#targets) do
        Notify("Target "..i, targets[i].Player.Name.." ["..targets[i].Bounty.." bounty] "..math.floor(targets[i].Dist).."m", 5)
    end
end})
local T7=MakeTab("Combat")
T7:AddSection("V10 Ultra Combat")
T7:AddToggle({Name="Auto Buso Haki",Default=F.AutoBusoHaki,Callback=function(v) F.AutoBusoHaki=v end})
T7:AddToggle({Name="Auto Ken Haki",Default=F.AutoKenHaki,Callback=function(v) F.AutoKenHaki=v end})
T7:AddToggle({Name="Ultra Combo Mode",Default=F.UltraComboMode,Callback=function(v) F.UltraComboMode=v end})
T7:AddLabel("Sword > Fruit > Gun > Fighting > Best rotation")
T7:AddSection("Prediction & Dodge")
T7:AddToggle({Name="Auto Dodge",Default=F.AutoDodge,Callback=function(v) F.AutoDodge=v end})
T7:AddSlider({Name="Dodge Range",Min=20,Max=150,Default=C.DodgeRange,ValueName="m",Callback=function(v) C.DodgeRange=v end})
T7:AddToggle({Name="Prediction Combat",Default=F.PredictionCombat,Callback=function(v) F.PredictionCombat=v end})
T7:AddLabel("Leads targets based on velocity")
T7:AddSection("Combo")
T7:AddToggle({Name="Combo Attack",Default=F.ComboAttack,Callback=function(v) F.ComboAttack=v end})
T7:AddLabel("Sword > Fruit > Gun rotation")
T7:AddSection("Safe Zone")
T7:AddToggle({Name="Smart Safe Zone",Default=F.SmartSafeZone,Callback=function(v) F.SmartSafeZone=v end})
T7:AddLabel("Evades high bounty players and low HP")
local T8=MakeTab("Weapons")
T8:AddSection("GodHuman")
T8:AddToggle({Name="Auto GodHuman",Default=F.AutoGodHuman,Callback=function(v) F.AutoGodHuman=v end})
T8:AddSection("V10 Fighting Style Quests")
T8:AddToggle({Name="Auto Dragon Talon",Default=F.AutoDragonTalon,Callback=function(v) F.AutoDragonTalon=v end})
T8:AddToggle({Name="Auto Death Step",Default=F.AutoDeathStep,Callback=function(v) F.AutoDeathStep=v end})
T8:AddToggle({Name="Auto Shark Karate",Default=F.AutoSharkKarate,Callback=function(v) F.AutoSharkKarate=v end})
T8:AddToggle({Name="Auto Electric Claw",Default=F.AutoElectricClaw,Callback=function(v) F.AutoElectricClaw=v end})
T8:AddSection("Soul Guitar")
T8:AddToggle({Name="Auto Soul Guitar",Default=F.AutoSoulGuitar,Callback=function(v) F.AutoSoulGuitar=v end})
T8:AddSection("Dark Blade")
T8:AddToggle({Name="Auto Dark Blade V1/V2/V3",Default=F.AutoDarkBlade,Callback=function(v) F.AutoDarkBlade=v end})
T8:AddSection("Shark Anchor")
T8:AddToggle({Name="Auto Shark Anchor",Default=F.AutoSharkAnchor,Callback=function(v) F.AutoSharkAnchor=v end})
T8:AddSection("Canvander")
T8:AddToggle({Name="Auto Canvander",Default=F.AutoCanvander,Callback=function(v) F.AutoCanvander=v end})
T8:AddSection("Legend Sword")
T8:AddToggle({Name="Auto Legend Sword",Default=F.AutoLegendSword,Callback=function(v) F.AutoLegendSword=v end})
T8:AddSection("Tusk V4")
T8:AddToggle({Name="Auto Tusk V4",Default=F.AutoTuskV4,Callback=function(v) F.AutoTuskV4=v end})
T8:AddSection("Legendary Swords")
T8:AddToggle({Name="Auto Buy Legendary Swords",Default=F.AutoLegendarySword,Callback=function(v) F.AutoLegendarySword=v end})
T8:AddLabel("Buys Saber, Shisui, Wando, Sadie, Enma, Yama, Tushita")
T8:AddButton({Name="Check Weapon Inventory",Callback=function()
    local weapons = {}
    if HasWeapon("GodHuman") then table.insert(weapons, "GodHuman") end
    if HasWeapon("Soul Guitar") then table.insert(weapons, "Soul Guitar") end
    if HasWeapon("Dark Blade") then table.insert(weapons, "Dark Blade") end
    if HasWeapon("Shark Anchor") then table.insert(weapons, "Shark Anchor") end
    if HasWeapon("Canvander") then table.insert(weapons, "Canvander") end
    if HasWeapon("CDK") or HasWeapon("Cursed Dual Katana") then table.insert(weapons, "CDK") end
    if #weapons > 0 then Notify("Weapons", table.concat(weapons, ", "), 5)
    else Notify("Weapons", "No special weapons found", 3) end
end})
local T9=MakeTab("Sea Events")
T9:AddSection("Events")
T9:AddToggle({Name="Auto Mirage Island",Default=F.AutoMirage,Callback=function(v) F.AutoMirage=v end})
T9:AddToggle({Name="Auto Sea Beast",Default=F.AutoSeaBeast,Callback=function(v) F.AutoSeaBeast=v end})
T9:AddToggle({Name="Auto Race V4",Default=F.AutoRaceV4,Callback=function(v) F.AutoRaceV4=v end})
T9:AddToggle({Name="Auto Trial",Default=F.AutoTrial,Callback=function(v) F.AutoTrial=v end})
T9:AddSection("V10 Dimensions")
T9:AddToggle({Name="Auto Frozen Dimension",Default=F.AutoFrozenDimension,Callback=function(v) F.AutoFrozenDimension=v end})
T9:AddToggle({Name="Auto Mirror Dimension",Default=F.AutoMirrorDimension,Callback=function(v) F.AutoMirrorDimension=v end})
T9:AddSection("Factory")
T9:AddToggle({Name="Auto Factory Event",Default=F.AutoFactoryEvent,Callback=function(v) F.AutoFactoryEvent=v end})
T9:AddLabel("Sea 2: Kills factory mobs + Core Brain")
T9:AddSection("V10 Dough King")
T9:AddToggle({Name="Auto Dough King",Default=F.AutoDoughKing,Callback=function(v) F.AutoDoughKing=v end})
T9:AddLabel("Auto defeats Dough King boss")
T9:AddSection("Law Raid")
T9:AddToggle({Name="Auto Law Raid",Default=F.AutoLawRaid,Callback=function(v) F.AutoLawRaid=v end})
T9:AddLabel("Auto fights Law boss in sea events")
T9:AddSection("Prehistoric Island")
T9:AddToggle({Name="Auto Prehistoric Island",Default=F.AutoPrehistoricIsland,Callback=function(v) F.AutoPrehistoricIsland=v end})
T9:AddLabel("Auto clears Prehistoric Island mobs")
T9:AddSection("Boat")
T9:AddToggle({Name="Boat Speed Boost",Default=F.BoatSpeedEnabled,Callback=function(v) F.BoatSpeedEnabled=v end})
T9:AddSlider({Name="Boat Speed",Min=50,Max=500,Default=C.BoatSpeed,ValueName="spd",Callback=function(v) C.BoatSpeed=v end})
T9:AddButton({Name="Spawn Boat",Callback=function() SelectBoat(C.SelectBoat) end})
T9:AddDropdown({Name="Boat Type",Default=C.SelectBoat,Options=Boats,Callback=function(v) C.SelectBoat=v end})
local T10=MakeTab("Race V4")
T10:AddSection("Race V4 Fragments")
T10:AddToggle({Name="Auto Collect Fragments",Default=F.AutoCollectFragments,Callback=function(v) F.AutoCollectFragments=v end})
T10:AddButton({Name="Collect Race Fragments Now",Callback=function()
    CollectRaceFragments()
    Notify("Race V4", "Fragment collection complete!", 3)
end})
T10:AddSection("V4 Activation")
T10:AddToggle({Name="Auto Race V4",Default=F.AutoRaceV4,Callback=function(v) F.AutoRaceV4=v end})
T10:AddToggle({Name="Auto Trial",Default=F.AutoTrial,Callback=function(v) F.AutoTrial=v end})
T10:AddLabel("Auto activates V4 and starts trials")
T10:AddSection("Race Status")
T10:AddButton({Name="Check Race",Callback=function()
    Notify("Race", "Your race: "..GetRace(), 5)
end})
T10:AddSection("Ghoul Race")
T10:AddToggle({Name="Auto Ghoul Race",Default=F.AutoGhoulRace,Callback=function(v) F.AutoGhoulRace=v end})
T10:AddLabel("Farms ectoplasm for Ghoul race unlock")
T10:AddSection("Shop")
T10:AddToggle({Name="Auto Buy from Shops",Default=F.AutoBuyShop,Callback=function(v) F.AutoBuyShop=v end})
T10:AddButton({Name="Buy Race Enhancement",Callback=function()
    BuyFromShop("Race", "Enhancement")
    Notify("Shop", "Attempting to buy race enhancement...", 3)
end})
local T11=MakeTab("Farming")
T11:AddSection("Chest Farm")
T11:AddToggle({Name="Auto Chest Farm",Default=F.AutoChestFarm,Callback=function(v) F.AutoChestFarm=v end})
T11:AddSlider({Name="Chest Range",Min=50,Max=500,Default=C.ChestFarmRange,ValueName="m",Callback=function(v) C.ChestFarmRange=v end})
T11:AddSection("Materials Farm")
T11:AddToggle({Name="Auto Materials Farm",Default=F.AutoMaterialsFarm,Callback=function(v) F.AutoMaterialsFarm=v end})
T11:AddDropdown({Name="Target Material",Default=C.MaterialsTarget,Options={"Ectoplasm","Magma Ore","Leather","Scrap Metal","Angel Wings","Vampire Fang","Yeti Fur","Mini Tusk","Dragon Scale","Mystic Droplet","Bones","Dark Cloth","Rare Metal","Ghost Fragment","Azure Embers","Leviathan Scale","Shark Tooth","Pearl"},Callback=function(v) C.MaterialsTarget=v end})
T11:AddSection("V10 Material Detector")
T11:AddToggle({Name="Material Detector",Default=F.AutoMaterialDetector,Callback=function(v) F.AutoMaterialDetector=v end})
T11:AddLabel("Scans nearby for material mobs")
T11:AddSection("Haki Training")
T11:AddToggle({Name="Auto Buso Training",Default=F.AutoHakiBuso,Callback=function(v) F.AutoHakiBuso=v end})
T11:AddSlider({Name="Mob Range",Min=10,Max=100,Default=C.HakiBusoMobs,ValueName="m",Callback=function(v) C.HakiBusoMobs=v end})
T11:AddToggle({Name="Auto Ken Training",Default=F.AutoHakiKen,Callback=function(v) F.AutoHakiKen=v end})
T11:AddSlider({Name="Stay Distance",Min=5,Max=50,Default=C.HakiKenHP,ValueName="m",Callback=function(v) C.HakiKenHP=v end})
T11:AddButton({Name="Activate All Haki Now",Callback=function()
    pcall(function() CommF("BusoHaki"); CommF("ActivateHaki", "Buso"); CommF("ToggleHaki", "Buso") end)
    pcall(function() CommF("KenHaki"); CommF("ActivateHaki", "Ken"); CommF("ToggleHaki", "Ken") end)
    Notify("Haki", "Activating Buso + Ken Haki...", 3)
end})
T11:AddSection("Auto Awaken Fruit")
T11:AddToggle({Name="Auto Awaken Fruit",Default=F.AutoAwakenFruit,Callback=function(v) F.AutoAwakenFruit=v end})
T11:AddLabel("Finds awakening expert and upgrades abilities")
T11:AddSection("V10 Bard Quest")
T11:AddToggle({Name="Auto Bard Quest",Default=F.AutoBardQuest,Callback=function(v) F.AutoBardQuest=v end})
T11:AddLabel("Auto completes Bard quests in Sea 3")
T11:AddSection("Auto Mastery 600")
T11:AddToggle({Name="Auto Farm 600 Mastery",Default=F.AutoMastery600,Callback=function(v) F.AutoMastery600=v end})
T11:AddLabel("Farms mobs until equipped tool reaches 600 mastery")
T11:AddSection("Auto Craft Items")
T11:AddToggle({Name="Auto Craft Items",Default=F.AutoCraftItems,Callback=function(v) F.AutoCraftItems=v end})
T11:AddLabel("Auto crafts forgeable items when materials are available")
T11:AddSection("Auto Collect Berries")
T11:AddToggle({Name="Auto Collect Berries",Default=F.AutoCollectBerries,Callback=function(v) F.AutoCollectBerries=v end})
T11:AddLabel("Collects berries, embers, and eggs from the map")
local T12=MakeTab("ESP")
T12:AddSection("ESP")
T12:AddToggle({Name="Player ESP",Default=F.ESPPlayers,Callback=function(v) F.ESPPlayers=v end})
T12:AddToggle({Name="Fruit ESP",Default=F.ESPFruits,Callback=function(v) F.ESPFruits=v end})
T12:AddToggle({Name="Chest ESP",Default=F.ESPChests,Callback=function(v) F.ESPChests=v end})
T12:AddToggle({Name="Flower ESP",Default=F.ESPFlowers,Callback=function(v) F.ESPFlowers=v end})
T12:AddToggle({Name="Boss ESP",Default=F.ESPBosses,Callback=function(v) F.ESPBosses=v end})
T12:AddToggle({Name="Sea Beast ESP",Default=F.ESPSeaBeast,Callback=function(v) F.ESPSeaBeast=v end})
T12:AddToggle({Name="Border ESP",Default=F.ESPBorders,Callback=function(v) F.ESPBorders=v end})
T12:AddButton({Name="Clear All ESP",Callback=function() ClearESP() end})
T12:AddSection("Player Highlight")
T12:AddToggle({Name="Player Highlight",Default=F.PlayerHighlight,Callback=function(v) F.PlayerHighlight=v end})
T12:AddLabel("Team-colored highlights through walls")
local T13=MakeTab("Fishing")
T13:AddSection("Auto Fishing")
T13:AddToggle({Name="Auto Fish",Default=F.AutoFishing,Callback=function(v) F.AutoFishing=v end})
T13:AddDropdown({Name="Fishing Rod",Default=C.AutoFishingRod,Options=FishingRods,Callback=function(v) C.AutoFishingRod=v end})
T13:AddDropdown({Name="Bait Type",Default=C.AutoFishingBait,Options=BaitTypes,Callback=function(v) C.AutoFishingBait=v end})
T13:AddButton({Name="Fish Now",Callback=function() AutoFish() end})
T13:AddSection("Fish Shop")
T13:AddButton({Name="Sell All Fish",Callback=function()
    pcall(function() CommF("SellFish"); CommF("TradeFish") end)
    Notify("Fish", "Selling all fish...", 3)
end})
T13:AddButton({Name="Buy Fishing Quest",Callback=function()
    pcall(function() CommF("FishingQuest"); CommF("AcceptFishingQuest") end)
    Notify("Fish", "Accepting fishing quest...", 3)
end})
T13:AddSection("Sunken Chest")
T13:AddButton({Name="Find Sunken Chest",Callback=function()
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:find("Sunken") or obj.Name:find("Treasure")) then
            local pp = obj:FindFirstChildOfClass("ProximityPrompt")
            if pp then
                local h = HRP()
                if h then h.CFrame = obj.Position + Vector3.new(0, 5, 0) end
                task.wait(1)
                pcall(function() fireproximityprompt(pp) end)
                Notify("Fish", "Found sunken chest!", 3)
                return
            end
        end
    end
    Notify("Fish", "No sunken chest found nearby", 3)
end})
local T14=MakeTab("Trading")
T14:AddSection("Auto Trade")
T14:AddToggle({Name="Auto Accept Trade",Default=F.AutoTrade,Callback=function(v) F.AutoTrade=v end})
T14:AddToggle({Name="Freeze Trade Window",Default=F.AutoFreezeTrade,Callback=function(v) F.AutoFreezeTrade=v end})
T14:AddButton({Name="Accept Trade Now",Callback=function() AutoAcceptTrade() end})
T14:AddButton({Name="Freeze Trade Now",Callback=function() FreezeTrade() end})
T14:AddSection("Value Calculator")
T14:AddButton({Name="Scan Trade Values",Callback=function()
    local gui = LP.PlayerGui:FindFirstChild("TradeGui") or LP.PlayerGui:FindFirstChild("TradingGui")
    if gui then
        for _, item in ipairs(gui:GetDescendants()) do
            if item:IsA("TextLabel") and item.Text ~= "" then
                local val = GetFruitValue(item.Text)
                if val > 0 then
                    Notify("Trade Value", item.Text..": $"..val, 5)
                end
            end
        end
    else
        Notify("Trade", "No trade window open", 3)
    end
end})
T14:AddSection("Fruit Values")
T14:AddLabel("Dragon: $35M | Leopard: $30M | Spirit: $25M")
T14:AddLabel("Dough: $20M | Buddha: $15M | Venom: $12M")
T14:AddLabel("Control: $10M | T-Rex: $8M | Mammoth: $7M")
T14:AddLabel("Shadow: $6M | Blizzard: $5M | Gravity: $4M")
local T15=MakeTab("Movement")
T15:AddSection("NoClip")
T15:AddToggle({Name="NoClip",Default=F.NoclipEnabled,Callback=function(v) F.NoclipEnabled=v end})
T15:AddLabel("Walk through walls and objects")
T15:AddSection("Speed & Jump")
T15:AddSlider({Name="Walk Speed",Min=16,Max=500,Default=C.WalkSpeed,Callback=function(v) C.WalkSpeed=v; ApplySpeed() end})
T15:AddSlider({Name="Jump Power",Min=50,Max=500,Default=C.JumpPower,Callback=function(v) C.JumpPower=v; ApplySpeed() end})
T15:AddSlider({Name="Dash Length",Min=10,Max=100,Default=C.DashLength,Callback=function(v) C.DashLength=v; ApplyDash() end})
T15:AddButton({Name="Reset Speed",Callback=function()
    C.WalkSpeed=16; C.JumpPower=50
    local h=Hum(); if h then h.WalkSpeed=16; h.JumpPower=50 end
    Notify("Movement", "Speed reset to default", 3)
end})
T15:AddSection("Infinite")
T15:AddToggle({Name="Infinite Jump",Default=F.InfiniteJump,Callback=function(v) F.InfiniteJump=v end})
T15:AddToggle({Name="Infinite Energy",Default=F.InfiniteEnergy,Callback=function(v) F.InfiniteEnergy=v end})
T15:AddToggle({Name="Infinite Soru",Default=F.InfiniteSoru,Callback=function(v) F.InfiniteSoru=v end})
T15:AddSection("Fly")
T15:AddToggle({Name="Fly (WASD+Space+Shift)",Default=F.Fly,Callback=function(v) F.Fly=v end})
T15:AddSlider({Name="Fly Speed",Min=20,Max=200,Default=C.FlySpeed,Callback=function(v) C.FlySpeed=v end})
T15:AddSection("V12 Movement")
T15:AddToggle({Name="No Stun",Default=F.NoStunEnabled,Callback=function(v) F.NoStunEnabled=v end})
T15:AddLabel("Prevents stun lock by resetting Stun value")
T15:AddToggle({Name="Auto Active V3",Default=F.AutoActiveV3,Callback=function(v) F.AutoActiveV3=v end})
T15:AddLabel("Auto activates V3 ability every 5s")
T15:AddToggle({Name="Auto Active V4",Default=F.AutoActiveV4Full,Callback=function(v) F.AutoActiveV4Full=v end})
T15:AddLabel("Auto activates V4 awakening every 5s")
local T16=MakeTab("Haki Training")
T16:AddSection("Buso Haki")
T16:AddToggle({Name="Auto Buso Training",Default=F.AutoHakiBuso,Callback=function(v) F.AutoHakiBuso=v end})
T16:AddSlider({Name="Mob Range",Min=10,Max=100,Default=C.HakiBusoMobs,ValueName="m",Callback=function(v) C.HakiBusoMobs=v end})
T16:AddToggle({Name="Auto Ken Training",Default=F.AutoHakiKen,Callback=function(v) F.AutoHakiKen=v end})
T16:AddSlider({Name="Stay Distance",Min=5,Max=50,Default=C.HakiKenHP,ValueName="m",Callback=function(v) C.HakiKenHP=v end})
T16:AddButton({Name="Activate All Haki Now",Callback=function()
    pcall(function() CommF("BusoHaki"); CommF("ActivateHaki", "Buso"); CommF("ToggleHaki", "Buso") end)
    pcall(function() CommF("KenHaki"); CommF("ActivateHaki", "Ken"); CommF("ToggleHaki", "Ken") end)
    Notify("Haki", "Activating Buso + Ken Haki...", 3)
end})
T16:AddSection("Observation Haki")
T16:AddToggle({Name="Auto Observation Haki Farm",Default=F.AutoObservationHaki,Callback=function(v) F.AutoObservationHaki=v end})
T16:AddLabel("Stays near mobs to train Observation Haki")
T16:AddSection("Buso Colors")
T16:AddToggle({Name="Auto Buy Buso Colors",Default=F.AutoBuyBusoColors,Callback=function(v) F.AutoBuyBusoColors=v end})
T16:AddLabel("Buys colors from Barista Cousin NPC")
local T17=MakeTab("Config")
T17:AddSection("Save / Load")
T17:AddButton({Name="Save Config",Callback=function() SaveConfig() end})
T17:AddButton({Name="Load Config",Callback=function() LoadConfig() end})
T17:AddButton({Name="Delete Config",Callback=function() DeleteConfig() end})
T17:AddSection("Export / Import")
T17:AddButton({Name="Export Config to Clipboard",Callback=function()
    EnsureFolder()
    if EXP.readfile and EXP.isfile then
        pcall(function()
            local path = C.ConfigFolder.."/"..C.ConfigFile
            if isfile(path) then Clip(readfile(path)); Notify("Config", "Exported to clipboard!", 3) end
        end)
    end
end})
T17:AddButton({Name="Reset All Settings",Callback=function()
    for k,v in pairs(F) do if type(v)=="boolean" then F[k]=false end end
    C.WalkSpeed=16; C.JumpPower=50; C.SafeHP=25
    local h=Hum(); if h then h.WalkSpeed=16; h.JumpPower=50 end
    Notify("Config", "All settings reset!", 3)
end})
T17:AddSection("Webhook")
T17:AddButton({Name="Set Webhook URL",Callback=function()
    Notify("Webhook", "Paste your Discord webhook URL in the console", 5)
end})
T17:AddToggle({Name="Anti-AFK",Default=F.AntiAFK,Callback=function(v) F.AntiAFK=v end})
T17:AddSection("UI Settings")
T17:AddSlider({Name="UI Scale",Min=50,Max=150,Default=100,ValueName="%",Callback=function(v)
    C.UIScale = v / 100
    pcall(function()
        main.Size = UDim2.new(0, math.floor(800 * C.UIScale), 0, math.floor(600 * C.UIScale))
        main.Position = UDim2.new(0.5, -math.floor(400 * C.UIScale), 0.5, -math.floor(300 * C.UIScale))
    end)
end})
T17:AddSection("Tween Safety")
T17:AddToggle({Name="Safe Tween",Default=F.SafeTween,Callback=function(v) F.SafeTween=v end})
T17:AddLabel("Resets stuck tweens after 5 seconds")
T17:AddButton({Name="Stop Tween Now",Callback=function()
    CancelMove()
    Notify("Tween", "Active tween stopped!", 3)
end})
T17:AddSection("Notifications")
T17:AddToggle({Name="Disable Notifications",Default=F.DisableNotify,Callback=function(v) F.DisableNotify=v end})
T17:AddLabel("Silences all notifications from the hub")
T17:AddSection("Anti-Stuck")
T17:AddToggle({Name="Anti-Stuck (Respawn)",Default=F.AntiStuck,Callback=function(v) F.AntiStuck=v end})
T17:AddLabel("Respawns character if not moving for 10 seconds")
T17:AddSection("Performance")
T17:AddToggle({Name="FPS Limiter",Default=F.FPSLimit,Callback=function(v) F.FPSLimit=v end})
T17:AddSlider({Name="Max FPS",Min=30,Max=240,Default=C.MaxFPS,ValueName="FPS",Callback=function(v) C.MaxFPS=v end})
T17:AddToggle({Name="FPS Boost Mode",Default=F.FPSBoost,Callback=function(v) F.FPSBoost=v end})
T17:AddLabel("Reduces shadows, fog, particles, effects")
T17:AddSection("Smart Features")
T17:AddToggle({Name="Smart Pathfinding",Default=F.SmartPathfind,Callback=function(v) F.SmartPathfind=v end})
T17:AddLabel("Uses PathfindingService for far targets")
T17:AddToggle({Name="Smart Server Hop",Default=F.SmartServerHop,Callback=function(v) F.SmartServerHop=v end})
T17:AddLabel("Checks for fruits/bosses before hopping")
T17:AddToggle({Name="Prediction Combat",Default=F.PredictionCombat,Callback=function(v) F.PredictionCombat=v end})
T17:AddLabel("Leads targets based on velocity")
T17:AddSection("Webhook Custom")
T17:AddButton({Name="Send Test Webhook",Callback=function()
    SendCustomWebhook("Apex Hub Test", "Test message from Apex Hub v11.0!
Executor: "..EXEC.."
Level: "..Lv().."
Sea: "..Sea(), 65280)
    Notify("Webhook", "Test webhook sent!", 3)
end})
T17:AddButton({Name="Send Fruit Alert",Callback=function()
    SendCustomWebhook("Fruit Found!", "A fruit was found on the map!
Check ESP for location.", 16711680)
    Notify("Webhook", "Fruit alert webhook sent!", 3)
end})
T17:AddSection("Keybinds")
T17:AddLabel("RightShift: Toggle UI visibility")
T17:AddLabel("Anti-Detection: Jitter + Randomized delays active")
local T18=MakeTab("Anti-AC + Emergency")
T18:AddSection("Anti-Cheat Bypass")
T18:AddLabel("7-Layer AC Bypass Active (v10)")
T18:AddLabel("Layer 1: Namecall hook (block AC remotes)")
T18:AddLabel("Layer 2: Velocity spoofing")
T18:AddLabel("Layer 3: Position jitter")
T18:AddLabel("Layer 4: HipHeight lock")
T18:AddLabel("Layer 5: Death delay randomizer")
T18:AddLabel("Layer 6: AssemblyLinearVelocity limiter")
T18:AddLabel("Layer 7: Fake position on __index")
T18:AddSection("V10 Anti-Detection")
T18:AddToggle({Name="Advanced Anti-Detection",Default=C.AntiDetection,Callback=function(v) C.AntiDetection=v end})
T18:AddLabel("Jitter offsets on movement")
T18:AddLabel("Randomized attack delays")
T18:AddLabel("Humanized movement patterns")
T18:AddSection("Detection Stats")
T18:AddLabel("AC Bypass: ACTIVE")
T18:AddLabel("Velocity Hook: ACTIVE")
T18:AddLabel("Position Hook: ACTIVE")
T18:AddLabel("Health Hook: ACTIVE")
T18:AddLabel("HipHeight Lock: ACTIVE")
T18:AddSection("Emergency Controls")
T18:AddButton({Name="STOP ALL",Callback=function()
    for k,v in pairs(F) do if type(v)=="boolean" then F[k]=false end end
    for _,p in ipairs(RainParts) do if p and p.Parent then p:Destroy() end end
    RainParts={}; ClearESP(); CancelMove()
    if flyBV then flyBV:Destroy(); flyBV=nil end
    if flyBG then flyBG:Destroy(); flyBG=nil end
    for _,hl in pairs(Highlights) do if hl and hl.Parent then hl:Destroy() end end
    Highlights={}
    ClearCharCache()
    Notify("APEX HUB","ALL features disabled!",3)
end})
T18:AddSection("Memory Cleanup")
T18:AddButton({Name="Force Memory Cleanup",Callback=function()
    pcall(function() collectgarbage("collect") end)
    local removed = 0
    for obj, data in pairs(ESPObjects) do
        pcall(function() if data.BB then data.BB:Remove(); removed = removed + 1 end end)
        pcall(function() if data.Box then data.Box:Remove(); removed = removed + 1 end end)
        pcall(function() if data.Text then data.Text:Remove(); removed = removed + 1 end end)
        pcall(function() if data.Dist then data.Dist:Remove(); removed = removed + 1 end end)
        pcall(function() if data.HealthBar then data.HealthBar:Remove(); removed = removed + 1 end end)
        pcall(function() if data.HealthFill then data.HealthFill:Remove(); removed = removed + 1 end end)
        pcall(function() if data.Tracer then data.Tracer:Remove(); removed = removed + 1 end end)
        ESPObjects[obj] = nil
    end
    Notify("Memory", "Cleaned up "..removed.." objects", 3)
end})
T18:AddSection("V10 Stats")
T18:AddLabel("Version: 12.0 APEX COMPLETE")
T18:AddLabel("Tabs: 24")
T18:AddLabel("AC Layers: 7")
T18:AddLabel("Combat: Ultra Combo + Skill Chains + Super Attack")
T18:AddLabel("Anti-Detection: Jitter + FakePos")
T18:AddLabel("V12: Boss Drops, Quests, Dungeon, Race, Shop, Teleport")
T18:AddLabel("Memory Cleanups: 0")
local T19=MakeTab("Boss Drops")
T19:AddSection("Sea 1 Weapons")
T19:AddToggle({Name="Auto Farm Saber (Saber Expert)",Default=F.AutoBossDropSaber,Callback=function(v) F.AutoBossDropSaber=v end})
T19:AddToggle({Name="Auto Farm Pole 1st Form (Thunder God)",Default=F.AutoBossDropPole,Callback=function(v) F.AutoBossDropPole=v end})
T19:AddToggle({Name="Auto Farm Shark Saw (The Saw)",Default=F.AutoBossDropSharkSaw,Callback=function(v) F.AutoBossDropSharkSaw=v end})
T19:AddToggle({Name="Auto Farm Trident (Fishman Lord)",Default=F.AutoBossDropTrident,Callback=function(v) F.AutoBossDropTrident=v end})
T19:AddToggle({Name="Auto Farm Refined Musket (Magma Admiral)",Default=F.AutoBossDropMusket,Callback=function(v) F.AutoBossDropMusket=v end})
T19:AddToggle({Name="Auto Farm Warden Sword (Chief Warden)",Default=F.AutoBossDropWardenSword,Callback=function(v) F.AutoBossDropWardenSword=v end})
T19:AddToggle({Name="Auto Farm Bazooka (Wysper)",Default=F.AutoBossDropBazooka,Callback=function(v) F.AutoBossDropBazooka=v end})
T19:AddSection("Sea 2 Weapons")
T19:AddToggle({Name="Auto Farm Acidum Rifle (Diamond)",Default=F.AutoBossDropAcidumRifle,Callback=function(v) F.AutoBossDropAcidumRifle=v end})
T19:AddToggle({Name="Auto Farm Jitte (Smoke Admiral)",Default=F.AutoBossDropJitte,Callback=function(v) F.AutoBossDropJitte=v end})
T19:AddToggle({Name="Auto Farm Hellfire Torch (Cursed Captain)",Default=F.AutoBossDropHellfireTorch,Callback=function(v) F.AutoBossDropHellfireTorch=v end})
T19:AddSection("Sea 3 Weapons")
T19:AddToggle({Name="Auto Farm Serpent Bow (Island Empress)",Default=F.AutoBossDropSerpentBow,Callback=function(v) F.AutoBossDropSerpentBow=v end})
T19:AddToggle({Name="Auto Farm Twin Hooks (Captain Elephant)",Default=F.AutoBossDropTwinHooks,Callback=function(v) F.AutoBossDropTwinHooks=v end})
T19:AddToggle({Name="Auto Farm Buddy Sword (Cake Queen)",Default=F.AutoBossDropBuddySword,Callback=function(v) F.AutoBossDropBuddySword=v end})
T19:AddToggle({Name="Auto Farm Dark Dagger (rip_indra)",Default=F.AutoBossDropDarkDagger,Callback=function(v) F.AutoBossDropDarkDagger=v end})
T19:AddSection("Status")
T19:AddButton({Name="Check Boss Weapons",Callback=function()
    local found = {}
    local allWeapons = {"Saber","Pole","Shark Saw","Trident","Refined Musket","Warden Sword","Bazooka","Acidum Rifle","Jitte","Hellfire Torch","Serpent Bow","Twin Hooks","Buddy Sword","Dark Dagger"}
    for _, w in ipairs(allWeapons) do
        if HasWeapon(w) then table.insert(found, w) end
    end
    if #found > 0 then Notify("Boss Drops", "Owned: "..table.concat(found, ", "), 5)
    else Notify("Boss Drops", "No boss drop weapons found", 3) end
end})
local T20=MakeTab("Boss Quests")
T20:AddSection("Special Boss Farming")
T20:AddToggle({Name="Auto Dark Dagger (rip_indra)",Default=F.AutoDarkDaggerQuest,Callback=function(v) F.AutoDarkDaggerQuest=v end})
T20:AddLabel("Farm rip_indra True Form for Dark Dagger")
T20:AddToggle({Name="Auto Hallow Scythe (Soul Reaper)",Default=F.AutoHallowScytheQuest,Callback=function(v) F.AutoHallowScytheQuest=v end})
T20:AddLabel("Summon and defeat Soul Reaper for Hallow Scythe")
T20:AddToggle({Name="Auto Swan Glasses (Don Swan)",Default=F.AutoSwanGlassesQuest,Callback=function(v) F.AutoSwanGlassesQuest=v end})
T20:AddLabel("Defeat Don Swan for Swan Glasses")
T20:AddToggle({Name="Auto Greybeard (Whitebeard)",Default=F.AutoGreybeardQuest,Callback=function(v) F.AutoGreybeardQuest=v end})
T20:AddLabel("Defeat Greybeard/Whitebeard in Marine Ford")
local T21=MakeTab("Special Quests")
T21:AddSection("Citizen Quest")
T21:AddToggle({Name="Auto Citizen Quest",Default=F.AutoCitizenQuest,Callback=function(v) F.AutoCitizenQuest=v end})
T21:AddLabel("Find Citizen NPC and complete quest")
T21:AddSection("Rainbow Haki")
T21:AddToggle({Name="Auto Rainbow Haki",Default=F.AutoRainbowHaki,Callback=function(v) F.AutoRainbowHaki=v end})
T21:AddLabel("Collect flowers and buy Rainbow Haki")
T21:AddSection("Holy Torch")
T21:AddToggle({Name="Auto Holy Torch",Default=F.AutoHolyTorch,Callback=function(v) F.AutoHolyTorch=v end})
T21:AddLabel("Find and collect Holy Torches on the map")
T21:AddSection("Enhancement")
T21:AddToggle({Name="Auto Enhancement Color",Default=F.AutoEnhancementColor,Callback=function(v) F.AutoEnhancementColor=v end})
T21:AddLabel("Auto buy enhancement colors")
T21:AddSection("Dojo Training")
T21:AddToggle({Name="Auto Dojo",Default=F.AutoDojo,Callback=function(v) F.AutoDojo=v end})
T21:AddLabel("Find Dojo/Trainer NPC and complete training")
local T22=MakeTab("Dungeon")
T22:AddSection("Dungeon System")
T22:AddToggle({Name="Auto Dungeon (Full)",Default=F.AutoDungeonFull,Callback=function(v) F.AutoDungeonFull=v end})
T22:AddLabel("Auto select, join, start dungeon")
T22:AddLabel("Auto kill mobs and touch doors")
T22:AddLabel("Auto select reward and choose card")
T22:AddSection("Status")
T22:AddButton({Name="Check Dungeon Status",Callback=function()
    if DungeonState.InProgress then
        Notify("Dungeon", "Dungeon in progress! Room: "..DungeonState.Room, 3)
    else
        Notify("Dungeon", "No dungeon in progress", 3)
    end
end})
local T23=MakeTab("Teleport")
T23:AddSection("Island Teleport")
T23:AddDropdown({Name="Select Island",Default=C.TeleportIsland,Options={"Starter Island","Marine Fortress","Jungle","Pirate Village","Desert","Frozen Village","Marine Ford","Prison","Magma Village","Sky Island","Underwater City","Colosseum","Hot and Cold","Cursed Ship","Haunted Castle","Turtle Island","Port Town","Green Zone","Factory","Graveyard","Usoapp Island","Forgotten Island","Hydra Island","Great Tree","Candy Island","Chocolate Island","Kitsune Island","Deep Sea"},Callback=function(v) C.TeleportIsland=v end})
T23:AddButton({Name="Teleport to Selected Island",Callback=function() TPToLocation(C.TeleportIsland) end})
T23:AddSection("Quick Teleport")
T23:AddButton({Name="TP to Jungle",Callback=function() TPToLocation("Jungle") end})
T23:AddButton({Name="TP to Marine Ford",Callback=function() TPToLocation("Marine Ford") end})
T23:AddButton({Name="TP to Prison",Callback=function() TPToLocation("Prison") end})
T23:AddButton({Name="TP to Hot and Cold",Callback=function() TPToLocation("Hot and Cold") end})
T23:AddButton({Name="TP to Cursed Ship",Callback=function() TPToLocation("Cursed Ship") end})
T23:AddButton({Name="TP to Haunted Castle",Callback=function() TPToLocation("Haunted Castle") end})
T23:AddButton({Name="TP to Turtle Island",Callback=function() TPToLocation("Turtle Island") end})
T23:AddButton({Name="TP to Deep Sea",Callback=function() TPToLocation("Deep Sea") end})
T23:AddButton({Name="TP to Kitsune Island",Callback=function() TPToLocation("Kitsune Island") end})
T23:AddButton({Name="TP to Sky Safe Zone",Callback=function() InstantTP(Vector3.new(0, 100, 0)); Notify("Teleport", "Teleported to sky safe zone!", 3) end})
local T24=MakeTab("Shop")
T24:AddSection("Fighting Styles")
T24:AddToggle({Name="Auto Buy All Fighting Styles",Default=F.AutoBuyFightingStyles,Callback=function(v) F.AutoBuyFightingStyles=v end})
T24:AddLabel("Black Leg, Fishman Karate, Electro, Dragon Breath")
T24:AddLabel("SuperHuman, Death Step, Sharkman Karate")
T24:AddLabel("Electric Claw, Dragon Talon, God Human, Sanguine Art")
T24:AddSection("Swords")
T24:AddToggle({Name="Auto Buy All Swords",Default=F.AutoBuySwords,Callback=function(v) F.AutoBuySwords=v end})
T24:AddLabel("Cutlass, Katana, Iron Mace, Dual Katana")
T24:AddLabel("Triple Katana, Pipe, Dual-Headed Blade")
T24:AddLabel("Bisento, Soul Cane, Pole v.2")
T24:AddSection("Guns")
T24:AddToggle({Name="Auto Buy All Guns",Default=F.AutoBuyGuns,Callback=function(v) F.AutoBuyGuns=v end})
T24:AddLabel("Slingshot, Musket, Flintlock, Refined Slingshot")
T24:AddLabel("Refined Flintlock, Cannon, Kabucha, Bizarre Rifle")
T24:AddSection("Abilities")
T24:AddToggle({Name="Auto Buy All Abilities",Default=F.AutoBuyAbilities,Callback=function(v) F.AutoBuyAbilities=v end})
T24:AddLabel("Skyjump, Buso Haki, Observation Haki, Soru")
T24:AddSection("Services")
T24:AddButton({Name="Buy Refund Stat",Callback=function()
    CommF("RefundStat")
    CommF("StatRefund")
    CommF("BuyRefund")
    Notify("Shop", "Refund stat requested!", 3)
end})
T24:AddButton({Name="Buy Reroll Race",Callback=function()
    CommF("RerollRace")
    CommF("BuyRerollRace")
    CommF("RaceReroll")
    Notify("Shop", "Reroll race requested!", 3)
end})
T24:AddSection("Race Purchases")
T24:AddToggle({Name="Buy Ghoul Race",Default=F.AutoBuyGhoul,Callback=function(v) F.AutoBuyGhoul=v end})
T24:AddToggle({Name="Buy Cyborg Race",Default=F.AutoBuyCyborg,Callback=function(v) F.AutoBuyCyborg=v end})
T24:AddToggle({Name="Buy Draco Race",Default=F.AutoBuyDraco,Callback=function(v) F.AutoBuyDraco=v end})
AllTabs[1].Frame.Visible = true
AllTabs[1].Button.BackgroundColor3 = Theme.Accent
AllTabs[1].Button.TextColor3 = Theme.Text
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        minimized = not minimized
        content.Visible = not minimized
        tabC.Visible = not minimized
        main.Size = minimized and UDim2.new(0,800,0,42) or UDim2.new(0,800,0,600)
        closeBtn.Text = minimized and "+" or "X"
    end
end)
task.spawn(function()
    while true do
        task.wait(3)
        if F.ESPPlayers then pcall(function()
            for _, p in ipairs(P:GetPlayers()) do
                if p ~= LP and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local c = p.Team and p.Team.TeamColor and p.Team.TeamColor.Color or Color3.fromRGB(255,100,100)
                        CreateESP(p.Character, c, p.Name.." ["..math.floor(hum.Health/hum.MaxHealth*100).."%]", 160)
                    end
                end
            end
        end) end
    end
end)
task.spawn(function()
    while true do
        task.wait(4)
        if F.ESPFruits then pcall(function()
            for _, o in ipairs(WS:GetDescendants()) do
                if o:IsA("Tool") or (o:IsA("Model") and o.Name:find("Fruit")) then
                    local h = o:FindFirstChild("Handle") or o:FindFirstChildWhichIsA("BasePart")
                    if h then
                        local fd = GetFD(o.Name)
                        CreateESP(o, fd and fd.C or Color3.fromRGB(255,170,0), o.Name.." ["..(fd and fd.R or "?").."]", 180)
                    end
                end
            end
        end) end
    end
end)
task.spawn(function()
    while true do task.wait(5)
        if F.ESPChests then pcall(function()
            for _, o in ipairs(WS:GetDescendants()) do
                if (o.Name:find("Chest") or o.Name:find("Treasure")) and (o:IsA("BasePart") or o:IsA("Model")) then
                    CreateESP(o, Color3.fromRGB(255,215,0), o.Name, 100)
                end
            end
        end) end
    end
end)
task.spawn(function()
    while true do task.wait(5)
        if F.ESPFlowers then pcall(function()
            for _, o in ipairs(WS:GetDescendants()) do
                if (o.Name:find("Flower") or o.Name:find("Blossom")) and (o:IsA("BasePart") or o:IsA("MeshPart")) then
                    CreateESP(o, Color3.fromRGB(255,100,200), o.Name, 80)
                end
            end
        end) end
    end
end)
task.spawn(function()
    while true do task.wait(3)
        if F.ESPBosses then pcall(function()
            for _, bd in ipairs(Bosses) do
                for _, folder in ipairs({"Enemies","NPCs","Living"}) do
                    local f = WS:FindFirstChild(folder)
                    if f then
                        for _, obj in ipairs(f:GetDescendants()) do
                            if obj:IsA("Model") and obj.Name == bd.Name then
                                local hum = obj:FindFirstChildOfClass("Humanoid")
                                if hum and hum.Health > 0 then
                                    CreateESP(obj, Color3.fromRGB(255,0,0), "[BOSS] "..bd.Name.." ["..math.floor(hum.Health/hum.MaxHealth*100).."%]", 200)
                                end
                            end
                        end
                    end
                end
            end
        end) end
    end
end)
task.spawn(function()
    while true do task.wait(3)
        if F.ESPSeaBeast then pcall(function()
            for _, obj in ipairs(WS:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Sea Beast") or obj.Name:find("Terror Shark") or obj.Name:find("Leviathan")) then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        CreateESP(obj, Color3.fromRGB(0, 150, 255), "[SEA] "..obj.Name, 200)
                    end
                end
            end
        end) end
    end
end)
task.spawn(function()
    while true do
        task.wait(10)
        pcall(function()
            if not F.AutoCollectFragments then return end
            if not Alive() then return end
            CollectRaceFragments()
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            if not F.AutoBuyShop then return end
            if not Alive() then return end
            BuyFromShop("Shop", C.ShopBuyItem)
            BuyFromShop("Weapon", C.ShopBuyItem)
            BuyFromShop("Fighting Style", C.ShopBuyItem)
        end)
    end
end)
local statusBar = M("Frame",{Size=UDim2.new(0,800,0,28),Position=UDim2.new(0.5,-400,1,-290),BackgroundColor3=Theme.Bar,BorderSizePixel=0},{scr})
Cr(statusBar,8); St(statusBar,Theme.Accent,1)
local statusHP = M("TextLabel",{Size=UDim2.new(0.15,0,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Text="HP: 100%",TextColor3=Theme.Accent,TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},{statusBar})
local statusSea = M("TextLabel",{Size=UDim2.new(0.08,0,1,0),Position=UDim2.new(0.16,0,0,0),BackgroundTransparency=1,Text="Sea 1",TextColor3=Theme.Text,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},{statusBar})
local statusLv = M("TextLabel",{Size=UDim2.new(0.08,0,1,0),Position=UDim2.new(0.25,0,0,0),BackgroundTransparency=1,Text="Lv: 1",TextColor3=Theme.Text,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},{statusBar})
local statusAtk = M("TextLabel",{Size=UDim2.new(0.1,0,1,0),Position=UDim2.new(0.34,0,0,0),BackgroundTransparency=1,Text="Atk: 0",TextColor3=Theme.Dim,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},{statusBar})
local statusActive = M("TextLabel",{Size=UDim2.new(0.38,0,1,0),Position=UDim2.new(0.45,0,0,0),BackgroundTransparency=1,Text="Active: None",TextColor3=Color3.fromRGB(100,255,100),TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},{statusBar})
local statusVer = M("TextLabel",{Size=UDim2.new(0.12,0,1,0),Position=UDim2.new(0.88,0,0,0),BackgroundTransparency=1,Text="v12.0 ULTIMATE",TextColor3=Theme.Accent,TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Right},{statusBar})
task.spawn(function()
    while scr.Parent do
        task.wait(C.StatusUpdateRate)
        pcall(function()
            local hp = HP()
            statusHP.Text = "HP: "..math.floor(hp).."%"
            statusHP.TextColor3 = hp > 60 and Color3.fromRGB(100,255,100) or (hp > 30 and Color3.fromRGB(255,255,100) or Color3.fromRGB(255,80,80))
            statusSea.Text = "Sea "..Sea()
            statusLv.Text = "Lv: "..Lv()
            statusAtk.Text = "Atk: "..(_G.Apex.AtkCount or 0)
            local active = {}
            if F.AutoFarm then table.insert(active, "Farm") end
            if F.FarmAll then table.insert(active, "FarmAll") end
            if F.AutoBossFarm then table.insert(active, "Boss") end
            if F.KillAura then table.insert(active, "KillAura") end
            if F.AutoRaid then table.insert(active, "Raid") end
            if F.AutoCDK then table.insert(active, "CDK") end
            if F.BountyHunt then table.insert(active, "Bounty") end
            if F.AutoFindFruits then table.insert(active, "Fruit") end
            if F.AutoChestFarm then table.insert(active, "Chest") end
            if F.AutoMaterialsFarm then table.insert(active, "Mat") end
            if F.AutoHakiBuso or F.AutoHakiKen then table.insert(active, "Haki") end
            if F.AutoGodHuman then table.insert(active, "GodH") end
            if F.AutoSoulGuitar then table.insert(active, "SoulG") end
            if F.AutoDarkBlade then table.insert(active, "DB") end
            if F.AutoSharkAnchor then table.insert(active, "SharkA") end
            if F.AutoCanvander then table.insert(active, "Canv") end
            if F.AutoLegendSword then table.insert(active, "LegS") end
            if F.AutoTuskV4 then table.insert(active, "Tusk") end
            if F.AutoFactoryEvent then table.insert(active, "Fact") end
            if F.AutoDoughKing then table.insert(active, "DoughK") end
            if F.AutoFrozenDimension then table.insert(active, "Frozen") end
            if F.AutoMirrorDimension then table.insert(active, "Mirror") end
            if F.AutoDragonTalon then table.insert(active, "DragonT") end
            if F.AutoDeathStep then table.insert(active, "DeathS") end
            if F.AutoSharkKarate then table.insert(active, "SharkK") end
            if F.AutoElectricClaw then table.insert(active, "ElecClaw") end
            if F.AutoBardQuest then table.insert(active, "Bard") end
            if F.AutoRevenge then table.insert(active, "Revenge") end
            if F.AutoBusoHaki then table.insert(active, "AutoBuso") end
            if F.AutoKenHaki then table.insert(active, "AutoKen") end
            if F.UltraComboMode then table.insert(active, "UltraCombo") end
            if F.Fly then table.insert(active, "Fly") end
            if F.AutoDodge then table.insert(active, "Dodge") end
            if F.ComboAttack then table.insert(active, "Combo") end
            if F.PlayerHighlight then table.insert(active, "HL") end
            if F.FPSBoost then table.insert(active, "FPS+") end
            if F.SmartSafeZone then table.insert(active, "SafeZ") end
            if F.SmartPathfind then table.insert(active, "Pathfind") end
            if F.PredictionCombat then table.insert(active, "Predict") end
            if F.AutoAwakenFruit then table.insert(active, "Awaken") end
            if F.AutoCollectFragments then table.insert(active, "Frag") end
            if F.AutoFishing then table.insert(active, "Fish") end
            if F.AutoTrade then table.insert(active, "Trade") end
            if F.NoclipEnabled then table.insert(active, "NoClip") end
            if F.InfiniteJump then table.insert(active, "InfJump") end
            if F.AimbotEnabled then table.insert(active, "Aimbot") end
            if F.AutoBartiloQuest then table.insert(active, "Bartilo") end
            if F.AutoLegendarySword then table.insert(active, "LegSwd") end
            if F.AutoLawRaid then table.insert(active, "LawRaid") end
            if F.AutoObservationHaki then table.insert(active, "ObsHaki") end
            if F.AutoMastery600 then table.insert(active, "M600") end
            if F.AutoBuddhaTransform then table.insert(active, "Buddha") end
            if F.AutoRandomFruit then table.insert(active, "RandF") end
            if F.AutoCollectBerries then table.insert(active, "Berry") end
            if F.AutoGhoulRace then table.insert(active, "Ghoul") end
            if F.ChestHop then table.insert(active, "ChestH") end
            if F.BoatSpeedEnabled then table.insert(active, "Boat") end
            if F.AutoBuyBusoColors then table.insert(active, "BusoC") end
            if F.AutoDarkDaggerQuest then table.insert(active, "DDagger") end
            if F.AutoHallowScytheQuest then table.insert(active, "HScythe") end
            if F.AutoSwanGlassesQuest then table.insert(active, "SGlasses") end
            if F.AutoGreybeardQuest then table.insert(active, "Greyb") end
            if F.AutoCitizenQuest then table.insert(active, "Citizen") end
            if F.AutoRainbowHaki then table.insert(active, "Rainbow") end
            if F.AutoHolyTorch then table.insert(active, "Torch") end
            if F.AutoEnhancementColor then table.insert(active, "Enhance") end
            if F.AutoDungeonFull then table.insert(active, "Dungeon") end
            if F.AutoRaceDoor then table.insert(active, "RaceDr") end
            if F.AutoAutoTrial then table.insert(active, "Trial") end
            if F.AutoTrainRace then table.insert(active, "TrainR") end
            if F.AutoBuyGear then table.insert(active, "Gear") end
            if F.AutoTPMirage then table.insert(active, "Mirage") end
            if F.AutoTPBlueGear then table.insert(active, "BluGear") end
            if F.AutoTPKitsune then table.insert(active, "Kitsune") end
            if F.AutoAzureEmber then table.insert(active, "Ember") end
            if F.AutoKillTerrorshark then table.insert(active, "TShark") end
            if F.AutoKillPiranha then table.insert(active, "Piranha") end
            if F.AutoKillFishCrew then table.insert(active, "FishCr") end
            if F.AutoBuyFightingStyles then table.insert(active, "BuyFS") end
            if F.AutoBuySwords then table.insert(active, "BuySwd") end
            if F.AutoBuyGuns then table.insert(active, "BuyGun") end
            if F.AutoBuyAbilities then table.insert(active, "BuyAb") end
            if F.NoStunEnabled then table.insert(active, "NoStun") end
            if F.AutoActiveV3 then table.insert(active, "V3") end
            if F.AutoActiveV4Full then table.insert(active, "V4") end
            if F.SuperAttack then table.insert(active, "SupAtk") end
            if F.SafeModePvP then table.insert(active, "SafePvP") end
            if F.AutoDojo then table.insert(active, "Dojo") end
            if F.AutoFarmBones then table.insert(active, "Bones") end
            if F.AutoFarmCandy then table.insert(active, "Candy") end
            if F.AutoSecondSea then table.insert(active, "Sea2") end
            if F.AutoThirdSea then table.insert(active, "Sea3") end
            if F.AutoTreeDestroyer then table.insert(active, "Tree") end
            if F.SafeTween then table.insert(active, "SafeTwn") end
            if F.AntiStuck then table.insert(active, "AntiStk") end
            if F.AutoBossDropSaber or F.AutoBossDropPole or F.AutoBossDropSharkSaw or F.AutoBossDropTrident or F.AutoBossDropMusket or F.AutoBossDropWardenSword or F.AutoBossDropBazooka then table.insert(active, "BS1") end
            if F.AutoBossDropAcidumRifle or F.AutoBossDropJitte or F.AutoBossDropHellfireTorch then table.insert(active, "BS2") end
            if F.AutoBossDropSerpentBow or F.AutoBossDropTwinHooks or F.AutoBossDropBuddySword or F.AutoBossDropDarkDagger then table.insert(active, "BS3") end
            if #active == 0 then
                statusActive.Text = "Active: None"
                statusActive.TextColor3 = Theme.Dim
            else
                statusActive.Text = "Active: "..table.concat(active, ", ")
                statusActive.TextColor3 = Color3.fromRGB(100, 255, 100)
            end
            infoLbl.Text = EXEC.." | Lv"..Lv().." | "..Beli().."B | "..Frags().."F | Sea"..Sea().." | "..GetRace()
        end)
    end
end)
local function GetBossStatus(bossName)
    for _, bd in ipairs(Bosses) do
        if bd.Name == bossName then
            local mob = FindMob(bossName, 1000)
            if mob then
                local mh = mob:FindFirstChildOfClass("Humanoid")
                if mh and mh.Health > 0 then
                    return "Alive", math.floor(mh.Health / mh.MaxHealth * 100)
                end
            end
            return "Not Found", 0
        end
    end
    return "Unknown", 0
end
local function GetSeaName(seaNum)
    if seaNum == 1 then return "Sea 1 (??)" end
    if seaNum == 2 then return "Sea 2 (???)" end
    if seaNum == 3 then return "Sea 3 (???)" end
    return "Sea Unknown"
end
local function GetFormattedRace()
    local race = GetRace()
    return race ~= "Unknown" and race or "Not Selected"
end
local function GetPlaytime()
    return math.floor(game:GetService("Stats"):GetValue("SessionStart") ~= 0
        and tick() - game:GetService("Stats"):GetValue("SessionStart") or 0)
end
local function EmergencyFullHeal()
    pcall(function()
        CommF("Heal")
        CommF("FullHeal")
        CommF("RestoreHealth")
        CommF("EatFruit")
        local h = Hum()
        if h then
            h.Health = h.MaxHealth
        end
    end)
    Notify("Emergency", "Full heal requested!", 3)
end
local function AntiKick()
    pcall(function()
        if EXP.hookmm and EXP.newcc then
            local oldNC
            oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local m = getnamecallmethod()
                if m == "Kick" then
                    local n = tostring(self)
                    if n:find("LocalPlayer") or n:find(LP.Name) then
                        return nil
                    end
                end
                return oldNC(self, ...)
            end))
        end
    end)
end
pcall(AntiKick)
local function GetAllNearbyItems(maxDist)
    maxDist = maxDist or 500
    local h = HRP()
    if not h then return {} end
    local items = {}
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local handle = obj:IsA("Model") and (obj:FindFirstChildWhichIsA("BasePart")) or obj
            if handle then
                local d = (h.Position - handle.Position).Magnitude
                if d <= maxDist then
                    local name = obj.Name
                    if name:find("Fragment") or name:find("Coin") or name:find("Gem") or name:find("Token") or name:find("Relic") then
                        table.insert(items, {Obj=obj, Name=name, Pos=handle.Position, Dist=d})
                    end
                end
            end
        end
    end
    table.sort(items, function(a,b) return a.Dist < b.Dist end)
    return items
end
local function CollectAllNearbyItems()
    if not Alive() then return end
    local items = GetAllNearbyItems(300)
    for _, item in ipairs(items) do
        if not Alive() then break end
        SmartPathfind(item.Pos + Vector3.new(0, 2, 0))
        task.wait(0.3)
        pcall(function()
            local pp = item.Obj:FindFirstChildOfClass("ProximityPrompt")
            if pp then fireproximityprompt(pp) end
        end)
        pcall(function()
            if EXP.firetouch then
                firetouchinterest(HRP(), item.Obj, 0)
                task.wait(0.1)
                firetouchinterest(HRP(), item.Obj, 1)
            end
        end)
        pcall(function()
            CommF("PickupItem", item.Name)
            CommF("CollectItem", item.Name)
        end)
        task.wait(0.2)
    end
end
local StatusReport = {LastReport=0, ReportInterval=60}
task.spawn(function()
    while true do
        task.wait(StatusReport.ReportInterval)
        pcall(function()
            if not Alive() then return end
            local now = os.time()
            if (now - StatusReport.LastReport) < StatusReport.ReportInterval then return end
            StatusReport.LastReport = now
            local activeFeatures = 0
            for _, v in pairs(F) do
                if type(v) == "boolean" and v then
                    activeFeatures = activeFeatures + 1
                end
            end
            if activeFeatures > 0 then
                Notify("Status Report", "Level: "..Lv().." | Sea: "..Sea().." | Bounty: "..FormatNumber(Bounty()).." | Active: "..activeFeatures.." features", 5)
            end
        end)
    end
end)
LP.CharacterAdded:Connect(function(c)
    ClearCharCache()
    task.wait(1)
    local h = c:WaitForChild("Humanoid", 5)
    if h then h.WalkSpeed = C.WalkSpeed; h.JumpPower = C.JumpPower end
    ClearCharCache()
    if F.AutoBusoHaki or F.AutoHakiBuso then
        task.wait(2)
        pcall(function()
            CommF("BusoHaki")
            CommF("ActivateHaki", "Buso")
            CommF("ToggleHaki", "Buso")
        end)
    end
    if F.AutoKenHaki or F.AutoHakiKen then
        task.wait(2)
        pcall(function()
            CommF("KenHaki")
            CommF("ActivateHaki", "Ken")
            CommF("ToggleHaki", "Ken")
        end)
    end
end)
LP.CharacterAdded:Connect(function(c)
    ClearCharCache()
    task.wait(1)
    local h = c:WaitForChild("Humanoid", 5)
    if h then h.WalkSpeed = C.WalkSpeed; h.JumpPower = C.JumpPower end
    ClearCharCache()
end)
task.defer(function()
    local h = Hum()
    if h then h.WalkSpeed = C.WalkSpeed; h.JumpPower = C.JumpPower end
end)
print("=================================================================")
print("     APEX HUB v12.0 APEX COMPLETE - ALL SYSTEMS LOADED")
print("     Executor:  "..EXEC)
print("     Level:     "..Lv())
print("     Sea:       "..Sea())
print("     Anti-AC:   7-Layer Active (v10 Enhanced)")
print("     Smart:     Pathfind, Mob Target, Stats, ServerHop")
print("     Combat:    Prediction, Combo, Ultra Combo, Auto Dodge")
print("     Kill Aura: Ready")
print("     Bring Mob: Ready")
print("     Fly System: Ready")
print("     Auto Raid: Ready")
print("     Auto CDK:  Ready")
print("     Bounty:    Ready + Revenge")
print("     Weapons:   GodHuman, Soul Guitar, Dark Blade,")
print("                Shark Anchor, Canvander, Legend Sword, Tusk V4")
print("     Fighting:  Dragon Talon, Death Step, Shark Karate, Electric Claw")
print("     Chest Farm: Ready")
print("     Materials: Database loaded ("..#MaterialsDB.." materials)")
print("     Material Detector: Active")
print("     Haki:      Buso + Ken training + Auto activation")
print("     Combo:     Ultra Combo (5-weapon) + Sword->Fruit->Gun")
print("     Auto Dodge: PvP evasion active")
print("     Dimensions: Frozen + Mirror auto farm")
print("     Dough King: Auto defeat ready")
print("     Bard Quest: Auto complete ready")
print("     Player HL: Team-colored highlights")
print("     FPS Boost: Lighting + effects optimization")
print("     Status Bar: Live stats display (v10 enhanced)")
print("     ESP:       Drawing API + Health Bars + Tracers + Sea Beast")
print("     Race V4:   Fragments, V4 activation, trials")
print("     Awaken:    Auto fruit awakening")
print("     Shops:     Auto buy from NPCs")
print("     Safe Zone: Smart evasion system")
print("     Anti-Det:  Jitter + FakePos + Randomized delays")
print("     Memory:    Auto cleanup with stats tracking")
print("     Keybinds:  RightShift toggle UI")
print("     Config:    Save/Load Active (v12.0)")
print("     Tabs:      24 tabs, all systems integrated")
print("     [V12] Boss Drop Farming: Sea 1/2/3 weapons")
print("     [V12] Boss Quests: Dark Dagger, Hallow Scythe, Swan, Greybeard")
print("     [V12] Special Quests: Citizen, Rainbow Haki, Holy Torch, Dojo")
print("     [V12] Dungeon System: Full auto dungeon with doors/rewards")
print("     [V12] Race System: Door, Trial, Train, Buy Gear")
print("     [V12] Sea Events: Mirage, Blue Gear, Kitsune, Azure Ember, Terrorshark")
print("     [V12] Shop System: Fighting Styles, Swords, Guns, Abilities, Races")
print("     [V12] Movement: No Stun, Auto V3, Auto V4")
print("     [V12] Combat: Super Attack, Safe Mode PvP")
print("     [V12] Teleport: 28 islands with dropdown selection")
print("     [V12] ZekeHub Features: 169+ new features integrated")
print("=================================================================")
Notify("APEX HUB v12.0 APEX COMPLETE", "All systems loaded! "..EXEC.." | Lv"..Lv().." | Sea"..Sea().." | 24 Tabs | 169+ new features", 5)