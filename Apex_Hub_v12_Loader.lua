print("[Apex] Loading v12.0...")
local BASE = "https://raw.githubusercontent.com/you123-123/Apex-Hub/main/"
local ok1, err1 = pcall(function()
    loadstring(game:HttpGet(BASE.."part1_core.lua", true))()
end)
if not ok1 or not _G.Apex then
    warn("[Apex] Part1 FAILED: "..tostring(err1))
    return
end
print("[Apex] Part1 OK!")
local ok2, err2 = pcall(function()
    loadstring(game:HttpGet(BASE.."part2_loops.lua", true))()
end)
if not ok2 then
    warn("[Apex] Part2 FAILED: "..tostring(err2))
    return
end
print("[Apex] Part2 OK!")
local ok3, err3 = pcall(function()
    loadstring(game:HttpGet(BASE.."part3_ui.lua", true))()
end)
if not ok3 then
    warn("[Apex] Part3 FAILED: "..tostring(err3))
    return
end
print("[Apex] v12.0 LOADED!")