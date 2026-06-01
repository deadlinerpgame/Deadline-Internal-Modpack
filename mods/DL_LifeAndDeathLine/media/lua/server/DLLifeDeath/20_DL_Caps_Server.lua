DL = DL or {}

local function auditOnce()
    local players = getOnlinePlayers()
    if players == nil then return end
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        if p ~= nil then
            ;(function()
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
    ;(auditOnce)()
end)

Events.EveryOneMinute.Add(function() ;(auditOnce)() end)

DL.log("caps server wiring loaded (periodic authoritative audit)")
