local function resetFatigueOnLoad()
    local player = getPlayer()
    if not player then return end

    player:getStats():setFatigue(0)
end

Events.OnCreatePlayer.Add(resetFatigueOnLoad)
Events.EveryHours.Add(resetFatigueOnLoad) -- remove it after a few days
