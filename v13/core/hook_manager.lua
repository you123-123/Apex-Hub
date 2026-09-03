--[[
    APEX HUB v13.0 - HOOK MANAGER
    Centralized Metamethod Hook Chaining System
    Fixes: hook collision where L1/L2/Remote overwrite each other
]]

local A = _G.Apex or {}
A.HookManager = A.HookManager or {}
local HM = A.HookManager

HM._chains = HM._chains or {} -- { ["__namecall"] = { {id, fn, old}, ... } }
HM._originals = HM._originals or {}
HM._enabled = HM._enabled or false

local function getRawMT()
    local ok, mt = pcall(getrawmetatable, game)
    return ok and mt or nil
end

-- Call chain: each hook can decide to block (return true, value) or pass
function HM._dispatch(metamethod, self, ...)
    local chain = HM._chains[metamethod]
    if not chain or #chain == 0 then
        local orig = HM._originals[metamethod]
        if orig then return orig(self, ...) end
        return nil
    end
    -- Execute in reverse order (last registered = first executed, like middleware)
    for i = #chain, 1, -1 do
        local entry = chain[i]
        local ok, shouldBlock, ret = pcall(entry.fn, self, HM._originals[metamethod], ...)
        if ok and shouldBlock == true then
            return ret
        end
        -- if hook returns nil/false, continue to next
    end
    local orig = HM._originals[metamethod]
    if orig then return orig(self, ...) end
    return nil
end

function HM.Hook(metamethod, id, fn)
    if not HM._chains[metamethod] then HM._chains[metamethod] = {} end
    -- Remove existing with same id
    for i, e in ipairs(HM._chains[metamethod]) do
        if e.id == id then table.remove(HM._chains[metamethod], i) break end
    end
    table.insert(HM._chains[metamethod], {id=id, fn=fn})

    -- Install dispatcher if not yet
    if not HM._enabled or not HM._originals[metamethod] then
        local mt = getRawMT()
        if mt and mt[metamethod] and not HM._originals[metamethod] then
            HM._originals[metamethod] = mt[metamethod]
            local orig = HM._originals[metamethod]
            -- Use newcclosure if available
            local newFn = newcclosure and newcclosure(function(self, ...)
                return HM._dispatch(metamethod, self, ...)
            end) or function(self, ...) return HM._dispatch(metamethod, self, ...) end
            local ok = pcall(function()
                if hookmetamethod then
                    hookmetamethod(game, metamethod, newFn)
                else
                    mt[metamethod] = newFn
                end
            end)
            if ok then HM._enabled = true else HM._originals[metamethod] = nil return false end
        end
    end
    return true
end

function HM.Unhook(metamethod, id)
    local chain = HM._chains[metamethod]
    if not chain then return false end
    for i, e in ipairs(chain) do
        if e.id == id then
            table.remove(chain, i)
            return true
        end
    end
    return false
end

function HM.Restore(metamethod)
    local mt = getRawMT()
    local orig = HM._originals[metamethod]
    if mt and orig then
        pcall(function()
            if hookmetamethod then
                hookmetamethod(game, metamethod, orig)
            else
                mt[metamethod] = orig
            end
        end)
        HM._originals[metamethod] = nil
        HM._chains[metamethod] = {}
    end
end

function HM.GetChain(metamethod)
    return HM._chains[metamethod] or {}
end

A.HookManager = HM
return HM
