DL = DL or {}
DL.TraitEffects = DL.TraitEffects or {}
local E = DL.TraitEffects

E.offroadTrait = "SpeedDemon"
E.offroadPowerMultiplier = 2
E.productiveTrait = "productive"
E.productiveTimeMultiplier = 0.8
E.slowWorkerTrait = "slow_worker"
E.slowWorkerTimeMultiplier = 1.2
E.maniacalTrait = "maniacal"
E.maniacalUnhappinessPerTenMinutes = 5
E.hoarderTrait = "hoarder"
E.hoarderCapacityMultiplier = 1.2
E.hoarderThreshold = 0.5
E.hoarderStressPerMinute = 0.01

local function localPlayers()
    local out = {}
    for i = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(i)
        if player ~= nil and not player:isDead() then
            out[#out + 1] = player
        end
    end
    return out
end

if ISBaseTimedAction ~= nil and ISBaseTimedAction.adjustMaxTime ~= nil then
    local vanillaAdjustMaxTime = ISBaseTimedAction.adjustMaxTime
    function ISBaseTimedAction:adjustMaxTime(maxTime)
        local adjusted = vanillaAdjustMaxTime(self, maxTime)
        local character = self.character
        if adjusted == -1 or character == nil then return adjusted end
        if character:HasTrait(E.productiveTrait) then
            adjusted = adjusted * E.productiveTimeMultiplier
        end
        if character:HasTrait(E.slowWorkerTrait) then
            adjusted = adjusted * E.slowWorkerTimeMultiplier
        end
        return adjusted
    end
end

function E.bloodiness(player)
    local visual = player:getHumanVisual()
    if visual == nil then return 0 end
    local parts = BloodBodyPartType.MAX:index()
    if parts <= 0 then return 0 end
    local worn = player:getWornItems()
    local total = 0
    for i = 0, parts - 1 do
        local part = BloodBodyPartType.FromIndex(i)
        local level = visual:getBlood(part)
        if worn ~= nil then
            for j = 0, worn:size() - 1 do
                local item = worn:get(j):getItem()
                if instanceof(item, "Clothing") and item:getVisual() ~= nil then
                    local clothingBlood = item:getBloodlevelForPart(part)
                    if clothingBlood > level then
                        level = clothingBlood
                    end
                end
            end
        end
        total = total + level
    end
    return total / parts
end

function E.maniacalTick()
    for _, player in ipairs(localPlayers()) do
        if player:HasTrait(E.maniacalTrait) then
            local amount = E.bloodiness(player) * E.maniacalUnhappinessPerTenMinutes
            local body = player:getBodyDamage()
            local current = body:getUnhappynessLevel()
            if amount > 0 and current > 0 then
                body:setUnhappynessLevel(math.max(0, current - amount))
            end
        end
    end
end

Events.EveryTenMinutes.Add(E.maniacalTick)

local hoarderState = {}

function E.applyHoarderCapacity(player)
    local key = player:getPlayerNum()
    local state = hoarderState[key]
    local current = player:getMaxWeightDelta()
    if player:HasTrait(E.hoarderTrait) then
        if state ~= nil and state.player == player and math.abs(current - state.applied) < 0.0001 then return end
        local target = current * E.hoarderCapacityMultiplier
        player:setMaxWeightDelta(target)
        hoarderState[key] = { player = player, base = current, applied = target }
    elseif state ~= nil then
        if state.player == player and math.abs(current - state.applied) < 0.0001 then
            player:setMaxWeightDelta(state.base)
        end
        hoarderState[key] = nil
    end
end

function E.hoarderStress(player)
    if not player:HasTrait(E.hoarderTrait) or player:isAsleep() then return end
    local maxWeight = player:getMaxWeight()
    if maxWeight <= 0 then return end
    if player:getInventoryWeight() / maxWeight >= E.hoarderThreshold then return end
    local stats = player:getStats()
    local base = stats:getStress() - stats:getStressFromCigarettes()
    stats:setStress(math.min(1, base + E.hoarderStressPerMinute))
end

Events.EveryOneMinute.Add(function()
    for _, player in ipairs(localPlayers()) do
        E.applyHoarderCapacity(player)
        E.hoarderStress(player)
    end
end)

local offroad = {}
local offroadTicks = {}

local function engineLoudnessArgument(vehicle)
    return math.floor((vehicle:getEngineLoudness() + 0.5) * 2.7)
end

local function setEnginePower(vehicle, power)
    vehicle:setEngineFeature(vehicle:getEngineQuality(), engineLoudnessArgument(vehicle), power)
end

function E.restoreOffroad(key)
    local state = offroad[key]
    if state == nil then return end
    offroad[key] = nil
    local vehicle = state.vehicle
    if vehicle:getEnginePower() == state.boosted then
        setEnginePower(vehicle, state.base)
    end
    vehicle:getModData().DL_OffroadBase = nil
end

function E.updateOffroad(player)
    local key = player:getPlayerNum()
    local vehicle = player:getVehicle()
    local wanted = vehicle ~= nil
        and player:isDriving()
        and vehicle:getDriver() == player
        and player:HasTrait(E.offroadTrait)
        and not getActivatedMods():contains("DrivingSkill")
        and vehicle:isDoingOffroad()
    local state = offroad[key]
    if state ~= nil and (not wanted or state.vehicle ~= vehicle) then
        E.restoreOffroad(key)
        state = nil
    end
    if not wanted or state ~= nil then return end
    local modData = vehicle:getModData()
    if modData.DL_OffroadBase ~= nil then
        setEnginePower(vehicle, modData.DL_OffroadBase)
    end
    local base = vehicle:getEnginePower()
    local boosted = math.floor(base * E.offroadPowerMultiplier)
    modData.DL_OffroadBase = base
    setEnginePower(vehicle, boosted)
    offroad[key] = { vehicle = vehicle, base = base, boosted = boosted }
end

Events.OnPlayerUpdate.Add(function(player)
    if not instanceof(player, "IsoPlayer") or not player:isLocalPlayer() then return end
    local key = player:getPlayerNum()
    offroadTicks[key] = (offroadTicks[key] or 0) + 1
    if offroadTicks[key] % 5 ~= 0 then return end
    E.updateOffroad(player)
end)

Events.OnPlayerDeath.Add(function(player)
    if player ~= nil and instanceof(player, "IsoPlayer") and player:isLocalPlayer() then
        E.restoreOffroad(player:getPlayerNum())
    end
end)

Events.OnCreatePlayer.Add(function(index, player)
    hoarderState[index] = nil
    E.restoreOffroad(index)
    if player ~= nil then
        E.applyHoarderCapacity(player)
    end
end)
