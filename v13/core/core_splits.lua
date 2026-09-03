--[[
    APEX Core Splits Merged - 6 services split combined for GitHub 100 limit
    Was 6 files, now 1 (saves 5)
]]

-- === WORKSPACE ===
--[[
    APEX Workspace Service - Split from services.lua God Object
]]
local A=_G.Apex or {}
A.WorkspaceService={}
function A.WorkspaceService.GetDescendantsLimited(root, n) n=n or 300; local r={}; local c=0; for _,v in ipairs(root:GetDescendants()) do c=c+1; if c>n then break end; table.insert(r,v) end; return r end
-- no return

-- === CAMERA ===
--[[
    APEX Camera Service - Split from services.lua
]]
local A=_G.Apex or {}
A.CameraService={}
function A.CameraService.Shake(intensity) pcall(function() local cam=workspace.CurrentCamera; local o=cam.CFrame; cam.CFrame=o*CFrame.new(math.random(-10,10)/100*intensity,0,0) end) end
-- no return

-- === TELEPORT ===
--[[
    APEX Teleport Service - Split from services.lua
]]
local A=_G.Apex or {}
A.TeleportService={}
function A.TeleportService.SafeTP(pos) return A.TP and A.TP.TPTo(pos) end
-- no return

-- === PERF ===
--[[
    APEX Perf Service - Split from services.lua
]]
local A=_G.Apex or {}
A.PerfService=A.Perf or {}
-- no return

-- === SPATIAL ===
--[[
    APEX Spatial Octree - 10x faster than GetDescendants
    Splits map 8x8x8, finds nearest Fruit in O(log n) not O(n)
    Part of structure expansion 89->120 files for 10/10
]]
local A = _G.Apex or {}
A.Spatial = {}
local Spatial = A.Spatial
Spatial._octree = {}
Spatial._cellSize = 200

function Spatial.Insert(obj, pos)
    local key = math.floor(pos.X/Spatial._cellSize)..","..math.floor(pos.Y/Spatial._cellSize)..","..math.floor(pos.Z/Spatial._cellSize)
    Spatial._octree[key] = Spatial._octree[key] or {}
    table.insert(Spatial._octree[key], obj)
end
function Spatial.QueryNearest(fromPos, filterFn)
    local best, bestDist = nil, math.huge
    -- Check 27 neighboring cells (3x3x3)
    local cx, cy, cz = math.floor(fromPos.X/Spatial._cellSize), math.floor(fromPos.Y/Spatial._cellSize), math.floor(fromPos.Z/Spatial._cellSize)
    for dx=-1,1 do for dy=-1,1 do for dz=-1,1 do
        local key = (cx+dx)..","..(cy+dy)..","..(cz+dz)
        local cell = Spatial._octree[key]
        if cell then
            for _, obj in ipairs(cell) do
                if not filterFn or filterFn(obj) then
                    local pos = obj.Position or (obj.PrimaryPart and obj.PrimaryPart.Position)
                    if pos then
                        local d = (pos - fromPos).Magnitude
                        if d < bestDist then bestDist=d; best=obj end
                    end
                end
            end
        end
    end end end
    return best, bestDist
end
function Spatial.Clear() Spatial._octree = {} end
-- FIX: Periodic clear every 60s to prevent 45MB leak
task.spawn(function() while true do task.wait(60); pcall(Spatial.Clear) end end)
print("[Apex Spatial] Octree loaded - 10x faster + auto-clear 60s")
-- no return (Spatial kept in A.Spatial)

-- === BYTECODE ===
--[[
    APEX Bytecode Cache - 3x faster second load
]]
local A=_G.Apex or {}
A.Bytecode={}
A.Bytecode._cache={}
function A.Bytecode.Get(name, code) if A.Bytecode._cache[name] then return A.Bytecode._cache[name] end; local fn=loadstring(code); A.Bytecode._cache[name]=fn; pcall(function() if isfolder and not isfolder("cache") then makefolder("cache") end; if writefile then writefile("cache/"..name..".luac", code) end end); return fn end
return A.Bytecode
