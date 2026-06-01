if isClient() and not isServer() then return end
DL = DL or {}

local function auditOnce()
    local players = getOnlinePlayers()
    if players == nil then return end
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        if p ~= nil then
            if DL.Boosts and DL.Boosts.maybeRecompute then DL.Boosts.maybeRecompute(p) end
            local _ = (function()
                local n = DL.Caps.clampAll(p)
                if n > 0 then
                    DL.log("caps(server) clamped " .. n .. " over-cap perk(s) for '"
                        .. tostring(p:getUsername()) .. "'")
                end
            end)()
        end
    end
end

local lastRun = 0
Events.OnTick.Add(function()
    local now = getTimestamp()
    if (now - lastRun) < (DL.Config.capPeriodicSec or 15) then return end
    lastRun = now
    local _ = (auditOnce)()
end)

Events.EveryOneMinute.Add(function() local _ = (auditOnce)() end)

DL.log("caps server wiring loaded (periodic authoritative audit)")
