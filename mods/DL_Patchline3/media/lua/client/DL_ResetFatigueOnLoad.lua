require "LogLineUtils"

local function resetFatigueAndFear(player)
    if not player then return end

    local stats = player:getStats()
    if not stats then return end

    local fatigue, fear = stats:getFatigue(), stats:getFear()
    if fatigue == 0 and fear == 0 then return end

    stats:setFatigue(0)
    stats:setFear(0)
    LogLineUtils.LogFromClient("InvalidStats", "Automatic reset of fatigue and fear for player "
        .. tostring(player:getUsername()) .. ": fatigue=" .. tostring(fatigue)
        .. "; fear=" .. tostring(fear))
end

local function onCreatePlayer(playerNum, player)
    if player == getPlayer() then resetFatigueAndFear(player) end
end

local function onHour()
    resetFatigueAndFear(getPlayer())
end

Events.OnCreatePlayer.Add(onCreatePlayer)
Events.EveryHours.Add(onHour)
