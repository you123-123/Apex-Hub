--[[
    APEX Fruit Sniper - Server Hop (was missing vs HoHo/Redz)
    Distinctive: Hop 10 servers/min + rarity filter + value tracker
]]
local A = _G.Apex or {}
A.FruitSniper = {}
local FS = A.FruitSniper
FS.Active = false
FS.Hops = 0
FS.Found = 0
FS._loop = nil
FS._settings = {
    HopDelay = 6, -- seconds per hop
    MinRarity = 0, -- 0=all, 0.5=Dragon only
    AutoStore = true,
    NotifyDiscord = false,
}

function FS.Start()
    if FS.Active then return end
    FS.Active = true
    FS.Hops = 0
    FS._loop = task.spawn(function()
        while FS.Active do
            local found = false
            -- Scan current server for fruits (from ESP cache)
            pcall(function()
                for k, data in pairs(A.ESP and A.ESP._objectCache or {}) do
                    if data.Type=="Fruit" and data.Object and data.Object.Parent then
                        local info = A.ESP and A.ESP.GetFruitInfo and A.ESP.GetFruitInfo(data.Object.Name) or {chance=5}
                        if info.chance <= (FS._settings.MinRarity == 0 and 100 or FS._settings.MinRarity) or FS._settings.MinRarity==0 then
                            found = true
                            FS.Found = FS.Found + 1
                            -- Distinctive: 3D arrow + value
                            if A.ESP and A.ESP.DrawOffScreenArrow then
                                A.Notify("Fruit Sniper", "Found "..data.Object.Name.." ["..info.chance.."%] - Hop "..FS.Hops, 5)
                            end
                            if FS._settings.AutoStore and A.FruitSniper and A.FruitSniper.Store then
                                pcall(function() A.FruitSniper.Store(data.Object) end)
                            end
                            -- Hologram
                            if A.Distinctive then A.Distinctive.ShowModuleHologram("Fruit Sniper", "Found: "..data.Object.Name, "🍎") end
                            task.wait(2)
                        end
                    end
                end
            end)
            if not found then
                FS.Hops = FS.Hops + 1
                pcall(function()
                    if A.Server and A.Server.Hop then A.Server.Hop()
                    else
                        -- Fallback: TeleportService hop
                        local TeleportService = game:GetService("TeleportService")
                        local Players = game:GetService("Players")
                        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
                    end
                end)
            end
            task.wait(FS._settings.HopDelay)
        end
    end)
    A.Notify("Fruit Sniper", "Started - Hopping every "..FS._settings.HopDelay.."s", 3)
end

function FS.Stop()
    FS.Active = false
    if FS._loop then task.cancel(FS._loop); FS._loop=nil end
    A.Notify("Fruit Sniper", "Stopped - Hops: "..FS.Hops.." Found: "..FS.Found, 3)
end

function FS.SetHopDelay(s) FS._settings.HopDelay = math.clamp(s, 3, 30) end
function FS.SetMinRarity(v) FS._settings.MinRarity = v end

A.Register("fruit_sniper", FS)
return FS
