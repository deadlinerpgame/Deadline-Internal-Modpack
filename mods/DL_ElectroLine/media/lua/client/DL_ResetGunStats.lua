-- Native repair count and DL_repairs / DL_attempts / DL_optionUses stay on the original.
local function eligible(gun)
    return gun and instanceof(gun, "HandWeapon") and gun:isRanged() and gun:getAmmoType() ~= nil
end

local stats = {
    "MaxHitCount",
    "MinDamage",
    "MaxDamage",
    "CriticalChance",
    "CritDmgMultiplier",
    "HitChance",
    "MaxRange",
    "MinRange",
    "MinRangeRanged",
    "MinAngle",
    "AimingTime",
    "RecoilDelay",
    "ReloadTime",
    "AimingPerkHitChanceModifier",
    "AimingPerkRangeModifier",
    "AimingPerkMinAngleModifier",
    "AimingPerkCritModifier",
    "ConditionLowerChance",
    "JamGunChance",
    "SoundRadius",
    "SoundVolume",
    "SwingSound",
}

local function resetGunStats(player, gun)
    if not player or not player:isLocalPlayer() then return end
    if not eligible(gun) then return end
    if gun:getAllWeaponParts():size() > 0 then return end

    local defaults = InventoryItemFactory.CreateItem(gun:getFullType())
    if not defaults then return end
    for _, stat in ipairs(stats) do
        local getter, setter = "get" .. stat, "set" .. stat
        gun[setter](gun, defaults[getter](defaults))
    end

    local oldCondition = gun:getCondition()
    local oldMax = gun:getConditionMax()
    local md = gun:getModData()
    local baseMax = defaults:getConditionMax()
    local newMax = baseMax + (md.DL_maxBonus or 0)
    gun:setConditionMax(newMax)
    if md.DL_baseMax ~= nil then md.DL_baseMax = baseMax end

    -- Preserve wear percentage, including reinforcement.
    local newCondition = 0
    if oldCondition > 0 then
        newCondition = oldMax > 0 and math.floor(oldCondition * newMax / oldMax) or 1
        newCondition = math.max(1, math.min(newMax, newCondition))
    end
    gun:setCondition(newCondition)
end

Events.OnFillInventoryObjectContextMenu.Add(function(playerNum, context, items)
    local player = getSpecificPlayer(playerNum)
    if not player or not player:isLocalPlayer() then return end
    for _, gun in ipairs(ISInventoryPane.getActualItems(items)) do
        if eligible(gun) then
            local attached = gun:getAllWeaponParts():size() > 0
            local label = attached and "Reset Weapon Stats (remove attachments first)" or "Reset Weapon Stats"
            local option = context:addOption(label, player, resetGunStats, gun)
            option.notAvailable = attached
        end
    end
end)
