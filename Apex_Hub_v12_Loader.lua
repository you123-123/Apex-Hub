if _G.ApexLoaded then return end
_G.ApexLoaded = true
if not game:IsLoaded() then game.Loaded:Wait() end
local base = "https://raw.githubusercontent.com/you123-123/Apex-Hub/main/"
local ok1, p1 = pcall(function() return game:HttpGet(base.."part1_core.lua", true) end)
local ok2, p2 = pcall(function() return game:HttpGet(base.."part2_loops.lua", true) end)
local ok3, p3 = pcall(function() return game:HttpGet(base.."part3_ui.lua", true) end)
if ok1 and ok2 and ok3 and p1 and p2 and p3 then
    loadstring(p1.."\n"..p2.."\n"..p3)()
    print("[Apex Hub] v12.0 Loaded!")
else
    warn("[Apex Hub] Failed: "..tostring(p1 or p2 or p3))
end
