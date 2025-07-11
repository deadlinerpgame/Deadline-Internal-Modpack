local FITNESS_XP_LIMIT = 1200
local STRENGTH_XP_LIMIT = 1200

Events.AddXP.Add(function(player, perk, amount)
    if amount <= 0 then return end
    if not player or player:isDead() then return end
    local modData = player:getModData()
    modData.xpCooldown_fitness_xp = modData.xpCooldown_fitness_xp or 0
    modData.xpCooldown_fitness_timestamp = modData.xpCooldown_fitness_timestamp or 0
    modData.xpCooldown_strength_xp = modData.xpCooldown_strength_xp or 0
    modData.xpCooldown_strength_timestamp = modData.xpCooldown_strength_timestamp or 0
    local currentTime = getGameTime():getWorldAgeHours()
    local cooldown = modData.xpCooldown
    local negamount = -amount
    if perk == Perks.Fitness then
        if currentTime - modData.xpCooldown_fitness_timestamp >= 180 then
            modData.xpCooldown_fitness_xp = 0
            modData.xpCooldown_fitness_timestamp = currentTime
        end

        if modData.xpCooldown_fitness_xp + amount > FITNESS_XP_LIMIT then
            player:getXp():AddXP(Perks.Fitness, negamount * 0.990, true, false, false)
        else
        modData.xpCooldown_fitness_xp = modData.xpCooldown_fitness_xp + amount
        end
    end

    if perk == Perks.Strength then

        if currentTime - modData.xpCooldown_strength_timestamp >= 180 then
            modData.xpCooldown_strength_xp = 0
            modData.xpCooldown_strength_timestamp = currentTime
        end

        if modData.xpCooldown_strength_xp + amount > STRENGTH_XP_LIMIT then
            player:getNutrition():setProteins(350);
            local nutrition = player:getNutrition():getProteins();
            print(nutrition)
            local nutboost = amount
            if nutrition < -300 then nutboost = nutboost * 1.4 else nutboost = nutboost * 0.996 end
            negamount = -nutboost
            player:getXp():AddXP(Perks.Strength, negamount, true, false, false)
        else
        modData.xpCooldown_strength_xp = modData.xpCooldown_strength_xp + amount
        end
    end
end)