local functionHttpGet(url)
    local ok, result = pcall(function() return game:HttpGet(url, true) end)
    if ok and result and #result > 50 then return result end
    local funcs = {http_request, request, syn and syn.request}
    for _, fn in ipairs(funcs) do
        if fn then
            local ok2, res = pcall(function()
                return fn({Url = url, Method = "GET"})
            end)
            if ok2 and res and res.Body and #res.Body > 50 then return res.Body end
        end
    end
    return nil
end
print("[Apex Hub] Loading...")
local base = "https://raw.githubusercontent.com/you123-123/Apex-Hub/main/"
local names = {"part1_core.lua", "part2_loops.lua", "part3_ui.lua"}
local full = ""
for i, name in ipairs(names) do
    print("[Apex Hub] Fetching part " .. i .. "...")
    local content = functionHttpGet(base .. name)
    if not content then
        warn("[Apex Hub] FAILED to download: " .. name)
        return
    end
    full = full .. "\n" .. content
    print("[Apex Hub] Part " .. i .. " OK (" .. #content .. " bytes)")
end
if #full > 100 then
    print("[Apex Hub] Executing script (" .. #full .. " bytes)...")
    local fn, err = loadstring(full)
    if fn then
        local ok, err2 = pcall(fn)
        if ok then
            print("[Apex Hub] v12.0 LOADED SUCCESSFULLY!")
        else
            warn("[Apex Hub] Runtime error: " .. tostring(err2))
        end
    else
        warn("[Apex Hub] Syntax error: " .. tostring(err))
    end
else
    warn("[Apex Hub] Script empty or too small!")
end