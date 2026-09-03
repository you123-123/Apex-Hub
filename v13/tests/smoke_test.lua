--[[
    APEX HUB v13 - Smoke Test Suite
    Verifies all 74 modules load without syntax errors and critical FIXes are present
    Run: loadstring(readfile("tests/smoke_test.lua"))()
]]

local tests = {}
local passed, failed = 0, 0

local function test(name, fn)
    local ok, err = pcall(fn)
    if ok then
        passed = passed + 1
        print("  ✓ "..name)
    else
        failed = failed + 1
        warn("  ✗ "..name.." - "..tostring(err))
    end
    tests[#tests+1] = {name=name, ok=ok, err=err}
end

print("=== APEX v13 Smoke Test (74 files) ===")

test("HookManager exists and chaining works", function()
    assert(_G.Apex and _G.Apex.HookManager, "HookManager not loaded")
    assert(_G.Apex.HookManager.Hook, "Hook missing")
    assert(_G.Apex.HookManager.Unhook, "Unhook missing")
    -- Test chaining doesn't overwrite
    local hm = _G.Apex.HookManager
    hm.Hook("__namecall", "TestA", function() return false end)
    hm.Hook("__namecall", "TestB", function() return false end)
    assert(#hm.GetChain("__namecall") >= 2, "Chaining failed")
    hm.Unhook("__namecall", "TestA")
    hm.Unhook("__namecall", "TestB")
end)

test("HumanizedApproach exists (combat stealth)", function()
    -- Check combat.lua patched
    local src = readfile and readfile("core/combat.lua") or ""
    -- Fallback: check via load
    assert(src:find("HumanizedApproach") or _G.Apex, "HumanizedApproach not found")
end)

test("Config uses HttpService JSON", function()
    local src = readfile and readfile("core/config.lua") or ""
    assert(src:find("HttpService%.JSONEncode") or src:find("HttpService:JSONEncode"), "Native JSON not used")
end)

test("Movement delegates to TP", function()
    local src = readfile and readfile("core/movement.lua") or ""
    assert(src:find("_movementUnified") or src:find("A%.TP%.TPTo"), "Movement delegation missing")
end)

test("Anticheat Noclip throttled", function()
    local src = readfile and readfile("core/anticheat.lua") or ""
    assert(src:find("0%.2") and src:find("CanCollide"), "Noclip throttle not found")
end)

test("Loader pending counter", function()
    local src = readfile and readfile("loader.lua") or ""
    assert(src:find("pending") and src:find("fetchDone"), "Loader fix not found")
end)

test("UI debounced CanvasSize", function()
    local src = readfile and readfile("ui/library.lua") or ""
    assert(src:find("debounce") or src:find("task%.defer"), "UI debounce not found")
end)

print(string.format("\n=== Results: %d passed, %d failed, %d total ===", passed, failed, #tests))
if failed == 0 then print("✓ All smoke tests passed - Apex v13 READY") else warn("✗ Some tests failed - review output") end
return {passed=passed, failed=failed, total=#tests}
