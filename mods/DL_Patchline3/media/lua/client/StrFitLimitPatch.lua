local CAPS = {
  [Perks.Fitness] = {
    {to=0,  cap=750},
    {to=1,  cap=1000},
    {to=2,  cap=1500},
    {to=3,  cap=1800},
    {to=4,  cap=3000},
    {to=5,  cap=4300},
    {to=6,  cap=7500},
    {to=7,  cap=10000},
    {to=8,  cap=15000},
    {to=9,  cap=18750},
    {to=10, cap=18750},
  },
  [Perks.Strength] = {
    {to=0,  cap=750},
    {to=1,  cap=1000},
    {to=2,  cap=1500},
    {to=3,  cap=1800},
    {to=4,  cap=3000},
    {to=5,  cap=4300},
    {to=6,  cap=7500},
    {to=7,  cap=10000},
    {to=8,  cap=15000},
    {to=9,  cap=18750},
    {to=10, cap=18750},
  }
}

local function capFor(perk, level)
  local rows = CAPS[perk]
  for _, r in ipairs(rows) do
    if level <= r.to then return r.cap end
  end
  return rows[#rows].cap
end

Events.AddXP.Add(function(player, perk, amount)
    if amount <= 0 then return end
    if not player or player:isDead() then return end
    local modData = player:getModData()
    modData.xpCooldown_fitness_xp      = modData.xpCooldown_fitness_xp or 0
    modData.xpCooldown_fitness_timestamp = modData.xpCooldown_fitness_timestamp or 0
    modData.xpCooldown_strength_xp     = modData.xpCooldown_strength_xp or 0
    modData.xpCooldown_strength_timestamp = modData.xpCooldown_strength_timestamp or 0

    local currentTime = getGameTime():getWorldAgeHours()


    if currentTime - modData.xpCooldown_fitness_timestamp >= 90 then
        modData.xpCooldown_fitness_xp = 0
        modData.xpCooldown_fitness_timestamp = currentTime
    end
    if currentTime - modData.xpCooldown_strength_timestamp >= 90 then
        modData.xpCooldown_strength_xp = 0
        modData.xpCooldown_strength_timestamp = currentTime
    end

    if perk == Perks.Fitness then
        local lvl = player:getPerkLevel(Perks.Fitness)
        local limit = capFor(Perks.Fitness, lvl)
        local used  = modData.xpCooldown_fitness_xp
        local newTotal = used + amount

        if newTotal > limit then
            local overflow = newTotal - limit
            player:getXp():AddXP(Perks.Fitness, -overflow, true, false, false)
            modData.xpCooldown_fitness_xp = limit
        else
            modData.xpCooldown_fitness_xp = newTotal
        end
    end

    if perk == Perks.Strength then
        local lvl = player:getPerkLevel(Perks.Strength)
        local limit = capFor(Perks.Strength, lvl)
        local used  = modData.xpCooldown_strength_xp
        local newTotal = used + amount

        if newTotal > limit then
            local overflow = newTotal - limit

            player:getNutrition():setProteins(350)
            local nutrition = player:getNutrition():getProteins()
            local penalty = overflow
            if nutrition < -300 then
                penalty = penalty * 1.4
            else
                penalty = penalty * 0.996
            end
            player:getXp():AddXP(Perks.Strength, -penalty, true, false, false)
            modData.xpCooldown_strength_xp = limit
        else
            modData.xpCooldown_strength_xp = newTotal
        end
    end
end)