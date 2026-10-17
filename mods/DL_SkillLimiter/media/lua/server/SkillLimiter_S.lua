if isClient() and not isServer() then return end
DL = DL or {}

local reported = {}

local function auditOnce()
    local players = getOnlinePlayers()
    if players == nil then return end
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        if player ~= nil then
            for _, entry in ipairs(DL.Caps.overCap(player)) do
                local username = tostring(player:getUsername())
                local key = username .. ":" .. tostring(entry.perk) .. ":" .. tostring(entry.level)
                if not reported[key] then
                    reported[key] = true
                    writeLog("DL_SkillCaps", username .. " has " .. tostring(entry.perk) .. " level "
                        .. tostring(entry.level) .. ", above their cap of " .. tostring(entry.cap))
                end
            end
        end
    end
end

local lastRun = 0
Events.OnTick.Add(function()
    local now = getTimestamp()
    if (now - lastRun) < (DL.SkillCaps.auditSeconds or 60) then return end
    lastRun = now
    auditOnce()
end)

DL.log("caps server audit loaded (logs over-cap characters to DL_SkillCaps)")
