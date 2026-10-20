local function resetFatigueOnLoad(playerIndex, player)
    if not player then return end

    player:getStats():setFatigue(0)
end

Events.OnCreatePlayer.Add(resetFatigueOnLoad)
