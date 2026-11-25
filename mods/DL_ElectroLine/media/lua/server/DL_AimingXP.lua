-- Code adopted with permission by Gravy from WastelandRP. Big thanks to him and the Wasteland team!
local function bonusAimingXP(character, perk, amount)
    if perk ~= Perks.Aiming or amount <= 0 then return end
    if not character or not instanceof(character, "IsoPlayer") or not character:isLocalPlayer() then return end
    local weapon = character:getPrimaryHandItem()
    if not weapon or not instanceof(weapon, "HandWeapon") or not weapon:isRanged() then return end

    local ammo = (weapon:getAmmoType() or ""):lower()
    if ammo:find("crossbow", 1, true) or ammo:find("woodenbolt", 1, true)
        or ammo:find("arrow", 1, true) then return end
    -- Shotguns keep vanilla XP, non-shotguns receive the progression buff.
    if weapon:getWeaponReloadType() == "shotgun" or ammo:find("shotgun", 1, true) then return end

    local maxHit = weapon:getMaxHitCount()
    local extraFactor
    if maxHit == 1 then
        if weapon:isPiercingBullets() then
            extraFactor = 1.7
        else
            extraFactor = 2.5
        end
    elseif maxHit == 2 then
        extraFactor = 1.5
    else
        return
    end

    local extra = amount * extraFactor
    local xp = character:getXp()
    local boost = xp:getPerkBoost(perk)
    if character:getPerkLevel(perk) >= 5 and boost > 0 then
        -- Same high-level easing formula as WastelandXP, limited to non-shotguns.
        extra = extra + (0.21 * boost) * ((amount + extra) / 0.37)
    end
    -- Limit bonus XP to the player's existing skill cap, exclude admin characters
    local caps = DL and DL.Caps
    if caps and not caps.isExempt(character) then
        local cap = caps.capFor(character, perk, caps.computeCapsCached(character))
        extra = math.min(extra, math.max(0, perk:getTotalXpForLevel(cap) - xp:getXP(perk)))
    end
    if extra > 0 then xp:AddXP(perk, extra, false, false, false) end
end

Events.AddXP.Add(bonusAimingXP)
