DeadlineDice = DeadlineDice or {}

DeadlineDice.initiativeTracker = {}
DeadlineDice.orderTracker = {}

function DeadlineDice.getDiceRoll()
    return ZombRand(1, 21)
end

function DeadlineDice.getDiceRoll6()
    return ZombRand(1, 7)
end

function DeadlineDice.getModifiers(skill, diceScore)
    local modifiers = {}
    local skill = skill:lower()
    local character = getPlayer()

    -- Define a lookup table mapping skill names to corresponding modifier calculation functions
    local skillModifiers =
    {
        -------------------------------- COMBAT ROLLS --------------------------------
        -- Inititative
        initiative = DeadlineDice.getInitiativeModifiers,
        -- Attack (Close)
        attack = DeadlineDice.getAttackCloseModifiers,
        -- Throw
        throwing = DeadlineDice.getThrowModifiers,
        -- Attack (Improvised)
        --attackimprovised = DeadlineDice.getAttackImprovisedModifiers,
        -- Attack (Unarmed)
        -- attackunarmed = DeadlineDice.getAttackUnarmedModifiers,
        -- Attack (Ranged)
        attackranged = DeadlineDice.getAttackRangedModifiers,
        -- Attack (Ranged - Improvised)
        --attackrangedimprovised = DeadlineDice.getAttackRangedImprovisedModifiers,
        -- Defend (Close)
        defendclose = DeadlineDice.getDefendCloseModifiers,
        -- escape
        escapecheck = DeadlineDice.getEscapeModifiers,
        -- Defend (Ranged)
        defendranged = DeadlineDice.getDefendRangedModifiers,
        -------------------------------- NON-COMBAT ROLLS --------------------------------
        sneak = DeadlineDice.getHideModifiers,
        notice = DeadlineDice.getSpotModifiers,
        -------------------------------- SKILLS ROLLS --------------------------------
        carpentry = DeadlineDice.getCarpentryModifiers,
        cooking = DeadlineDice.getCookingModifiers,
        farming = DeadlineDice.getFarmingModifiers,
        electrical = DeadlineDice.getElectricalModifiers,
        metalworking = DeadlineDice.getMetalworkingModifiers,
        mechanics = DeadlineDice.getMechanicsModifiers,
        tailoring = DeadlineDice.getTailoringModifiers,
        firstaid = DeadlineDice.getFirstAidModifiers,
        -------------------------------- ENDURANCE ROLLS --------------------------------
        -- Physical Endurance
        physicalendurance = DeadlineDice.getPhysicalEnduranceModifiers,
        -- Mental Endurance
        mentalendurance = DeadlineDice.getMentalEnduranceModifiers,
    }

    -- Check if the skill exists in the lookup table
    local modifierFunction = skillModifiers[skill]
    if modifierFunction then
        -- Call the corresponding function to calculate modifiers
        modifiers = modifierFunction(modifiers, character, diceScore)
    end

    -- Return the modifiers table
    return modifiers
end

function DeadlineDice.getMeleeWeaponSkill(character)
    local currentItem = character:getPrimaryHandItem() or character:getSecondaryHandItem()
    local modifiers = {}

    if not currentItem then
        return modifiers
    end

    if not currentItem:IsWeapon() or currentItem:isRanged() then
        return modifiers
    end

    local weaponCategories = currentItem:getCategories()

    if weaponCategories:contains("SmallBlunt") then
        modifiers["Short Blunt"] = character:getPerkLevel(Perks.SmallBlunt)
    end

    if weaponCategories:contains("Blunt") then
        modifiers["Long Blunt"] = character:getPerkLevel(Perks.Blunt)
    end

    if weaponCategories:contains("LongBlade") then
        modifiers["Long Blade"] = character:getPerkLevel(Perks.LongBlade)
    end

    if weaponCategories:contains("SmallBlade") then
        modifiers["Short Blade"] = character:getPerkLevel(Perks.SmallBlade)
    end

    if weaponCategories:contains("Axe") then
        modifiers["Axe"] = character:getPerkLevel(Perks.Axe)
    end

    if weaponCategories:contains("Spear") then
        modifiers["Spear"] = character:getPerkLevel(Perks.Spear)
    end

    return modifiers
end

function DeadlineDice.getAgility(character)
    local nimbleLevel = character:getPerkLevel(Perks.Nimble)
    local lightFootLevel = character:getPerkLevel(Perks.Lightfoot)
    local sprintingLevel = character:getPerkLevel(Perks.Sprinting)
    local sneakingLevel = character:getPerkLevel(Perks.Sneak)

    -- Get the highest of the four perks
    local highestAgility = math.max(nimbleLevel, lightFootLevel, sprintingLevel, sneakingLevel)

    return highestAgility
end

function DeadlineDice.addTraitModifiers(modifiers, character, traitModifiers)
    for trait, modifierValue in pairs(traitModifiers) do
        local formattedTrait = DeadlineDice.traitFormatConverter[trait] or trait
        if character:HasTrait(trait) then
            modifiers[formattedTrait] = modifierValue
        end
    end
    return modifiers
end

function DeadlineDice.addTraitModifiers2(modifiers, character, traitModifiers)
    local highestPositive = {trait = nil, value = -math.huge}

    for trait, modifierValue in pairs(traitModifiers) do
        if character:HasTrait(trait) then
            if modifierValue > 0 and modifierValue > highestPositive.value then
                highestPositive.trait = trait
                highestPositive.value = modifierValue
            elseif modifierValue < 0 then
                local formattedTrait = DeadlineDice.traitFormatConverter[trait] or trait
                modifiers[formattedTrait] = modifierValue
            end
        end
    end

    -- Add the highest positive modifier
    if highestPositive.trait then
        local formattedTrait = DeadlineDice.traitFormatConverter[highestPositive.trait] or highestPositive.trait
        modifiers[formattedTrait] = highestPositive.value
    end

    return modifiers
end



DeadlineDice.traitFormatConverter =
{
    EagleEyed = "Eagle Eyed",
    KeenHearing = "Keen Hearing",
    ShortSighted = "Short Sighted",
    HardofHearing = "Hard of Hearing",
}

function DeadlineDice.addLineInChat(message)
    local _Chat = ISChat.instance;
    local _TabID = 0;
    local _Tab;

    for i, tab in ipairs(_Chat.tabs) do
        if tab and tab.tabID == _TabID then
            _Tab = tab;
            break;
        end
    end

    local _FoundMessage = nil;
    for i, msg in ipairs(_Tab.chatMessages) do
        if (msg and not _FoundMessage) then
            _FoundMessage = msg;
        end;
    end

    local _NewMsg = _FoundMessage:clone();
    _NewMsg:setText(message);
    _NewMsg:setServerAlert(false);
    _NewMsg:setServerAuthor(false);
    _NewMsg:setLocal(true);

    ISChat.instance.addLineInChat(_NewMsg, 0);
end;

function DeadlineDice.areCoordinatesWithinRange(coord1, coord2, range)
    local dx = coord1.x - coord2.x
    local dy = coord1.y - coord2.y
    local dz = coord1.z - coord2.z
    local distanceSquared = dx * dx + dy * dy + dz * dz
    local rangeSquared = range * range
    return distanceSquared <= rangeSquared
end
