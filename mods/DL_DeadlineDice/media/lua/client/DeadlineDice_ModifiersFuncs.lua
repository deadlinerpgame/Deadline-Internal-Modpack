DeadlineDice = DeadlineDice or {}

-------------------------------- COMBAT ROLLS --------------------------------
-- Inititative
function DeadlineDice.getInitiativeModifiers(modifiers, character)


    -- Define a lookup table mapping traits to their modifier values
    local traitModifiers = {
        Lethargic = -2,
        ReadyForAction = 2,
        AllThumbs = -1,
        Dextrous = 1,
    }

    return DeadlineDice.addTraitModifiers2(modifiers, character, traitModifiers)
end

-- Attack (Melee Weapon)
function DeadlineDice.getAttackCloseModifiers(modifiers, character)
    local currentItem = character:getPrimaryHandItem() or character:getSecondaryHandItem()


    -- Unarmed Roll
    if not currentItem or (currentItem and not currentItem:IsWeapon()) then
        return DeadlineDice.getAttackUnarmedModifiers(modifiers, character)
    end



    local meleeWeaponModifiers = DeadlineDice.getMeleeWeaponSkill(character)
    for category, value in pairs(meleeWeaponModifiers) do
        if category == "Short Blunt" then
        local traitModifiers = {Fighter = 2,SloppySwing = -2,HobbyShortBlunt = 1, SkilledShortBlunt = 2}
        return DeadlineDice.addTraitModifiers(modifiers, character, traitModifiers)
        end

        if category == "Long Blunt" then
        local traitModifiers = {Fighter = 2,SloppySwing = -2,HobbyLongBlunt = 1, SkilledLongBlunt = 2}
        return DeadlineDice.addTraitModifiers(modifiers, character, traitModifiers)
        end

        if category == "Short Blade" then
        local traitModifiers = {Fighter = 2,SloppySwing = -2,HobbyShortBlade = 1, SkilledShortBlade = 2}
    return DeadlineDice.addTraitModifiers(modifiers, character, traitModifiers)
        end

        if category == "Long Blade" then
        local traitModifiers = {Fighter = 2,SloppySwing = -2,HobbyLongBlade = 1, SkilledLongBlade = 2}
        return DeadlineDice.addTraitModifiers(modifiers, character, traitModifiers)
        end

        if category == "Axe" then
        local traitModifiers = {Fighter = 2,SloppySwing = -2,HobbyAxe = 1, SkilledAxe = 2}
        return DeadlineDice.addTraitModifiers(modifiers, character, traitModifiers)
        end

        if category == "Spear" then
        local traitModifiers = {Fighter = 2,SloppySwing = -2,HobbySpear = 1, SkilledSpear = 2}
        return DeadlineDice.addTraitModifiers(modifiers, character, traitModifiers)
        end
    end


local function isThrowable(item)
    local itemType = item:getType()

    local throwables = {
        SmokeBomb = true,
        SmokeBombSensorV1 = true,
        SmokeBombSensorV2 = true,
        SmokeBombSensorV3 = true,
        SmokeBombRemote = true,
        PipeBombRemote = true,
        FlameTrapRemote = true,
        AerosolbombRemote = true,
        PipeBombTriggered = true,
        PipeBombSensorV1 = true,
        PipeBombSensorV2 = true,
        PipeBombSensorV3 = true,
        PipeBomb = true,
        Molotov = true,
        FlameTrapTriggered = true,
        FlameTrapSensorV1 = true,
        FlameTrapSensorV2 = true,
        FlameTrapSensorV3 = true,
        FlameTrap = true,
        Aerosolbomb = true,
        AerosolbombTriggered = true,
        AerosolbombV1 = true,
        AerosolbombV2 = true,
        AerosolbombV3 = true,
    }
    return throwables[itemType] or false
end



local traitModifiers = {Marksman = 2,ShakyHands = -2,HobbyFirearms = 1, SkilledFirearms = 2}

    return DeadlineDice.addTraitModifiers2(modifiers, character, traitModifiers)

end

-- Escape
function DeadlineDice.getEscapeModifiers(modifiers, character)


    return DeadlineDice.addTraitModifiers(modifiers, character, traitModifiers)

end

-- -- Attack (Improvised)
-- function DeadlineDice.getAttackImprovisedModifiers(modifiers, character)
--     modifiers["Strength: "] = character:getPerkLevel(Perks.Strength)
--     modifiers["Maintenance: "] = character:getPerkLevel(Perks.Maintenance)

--     return modifiers
-- end

-- Attack (Unarmed)
function DeadlineDice.getAttackUnarmedModifiers(modifiers, character)


    local traitModifiers = {
        Brawler = 2,
        PulledPunches = -2,
    }

    return DeadlineDice.addTraitModifiers(modifiers, character, traitModifiers)
end

-- Attack (Bomb)
function DeadlineDice.getAttackBombModifiers(modifiers, character)

        local character = getPlayer()
    local primary = character:getPrimaryHandItem()
    local secondary = character:getSecondaryHandItem()

    if primary then 
        print("testyp")
        unequip(character,primary)
        character:removeWornItem(primary)
        character:getInventory():Remove(primary)

    elseif not primary then
        print("testys")
        unequip(character,secondary)
        character:removeWornItem(secondary)
        character:getInventory():Remove(secondary)

    end

    local traitModifiers = {
        Lobber = 2,
    }

    return DeadlineDice.addTraitModifiers(modifiers, character, traitModifiers)
end

function unequip(isoPlayer,item)
    if not isoPlayer then return end
    if not item or not item:isEquipped() then return end

    isoPlayer:removeWornItem(item)
    
    local hotbar = getPlayerHotbar(isoPlayer:getPlayerNum())
    local fromHotbar = false;
    if hotbar then
        fromHotbar = hotbar:isItemAttached(item);
    end
    if fromHotbar then
        isoPlayer:setAttachedItem(item:getAttachedToModel(), item);
        isoPlayer:resetEquippedHandsModels()
    end
    
    if item == isoPlayer:getPrimaryHandItem() then
        isoPlayer:setPrimaryHandItem(nil)
    end
    if item == isoPlayer:getSecondaryHandItem() then
        isoPlayer:setSecondaryHandItem(nil)
    end
    item:getContainer():setDrawDirty(true);
end

-- Attack (Ranged)
function DeadlineDice.getAttackRangedModifiers(modifiers, character)


local traitModifiers = {Fighter = 2,SloppySwing = -2,HobbyLongBlade = 1, SkilledLongBlade = 2}

    return DeadlineDice.addTraitModifiers2(modifiers, character, traitModifiers)
end

-- -- Attack (Ranged - Improvised)
-- function DeadlineDice.getAttackRangedImprovisedModifiers(modifiers, character)
--     modifiers["Strength: "] = character:getPerkLevel(Perks.Strength)
--     modifiers["Agility: "] = DeadlineDice.getAgility(character)
--     modifiers["Maintenance: "] = character:getPerkLevel(Perks.Maintenance)

--     return modifiers
-- end

-- Defend (Close)
function DeadlineDice.getDefendCloseModifiers(modifiers, character)


    local traitModifiers = {
        QuickReflexes = 2,
        Clumsy = -2,
        HobbySprinting = 1,
        HobbyNimble = 1,
        SkilledSprinting = 2,
        SkilledNimble = 2,
        SlowReflexes = -2,
    }

    return DeadlineDice.addTraitModifiers2(modifiers, character, traitModifiers)
end

-- Throw

function DeadlineDice.getThrowModifiers(modifiers, character)

local currentItem = character:getPrimaryHandItem() or character:getSecondaryHandItem()

local function isThrowable(item)
    local itemType = item:getType()

    local throwables = {
        SmokeBomb = true,
        SmokeBombSensorV1 = true,
        SmokeBombSensorV2 = true,
        SmokeBombSensorV3 = true,
        SmokeBombRemote = true,
        PipeBombRemote = true,
        FlameTrapRemote = true,
        AerosolbombRemote = true,
        PipeBombTriggered = true,
        PipeBombSensorV1 = true,
        PipeBombSensorV2 = true,
        PipeBombSensorV3 = true,
        PipeBomb = true,
        Molotov = true,
        FlameTrapTriggered = true,
        FlameTrapSensorV1 = true,
        FlameTrapSensorV2 = true,
        FlameTrapSensorV3 = true,
        FlameTrap = true,
        Aerosolbomb = true,
        AerosolbombTriggered = true,
        AerosolbombV1 = true,
        AerosolbombV2 = true,
        AerosolbombV3 = true,
    }
    return throwables[itemType] or false
end

--[[
    if isThrowable(currentItem) then
       return DeadlineDice.getAttackBombModifiers(modifiers, character)
    end
]]
    local traitModifiers = {
        Lobber = 2,
    }

    return DeadlineDice.addTraitModifiers2(modifiers, character, traitModifiers)
end

-- Defend (Ranged)
function DeadlineDice.getDefendRangedModifiers(modifiers, character)


    local traitModifiers = {
        BulletDodger = 2,
        Target = -2,
        HobbySneaking = 1,
        HobbyLightfoot = 1,
        SkilledSneaking = 2,
        SkilledLightfoot = 2,
    }

    return DeadlineDice.addTraitModifiers2(modifiers, character, traitModifiers)
end

-------------------------------- NON-COMBAT ROLLS --------------------------------
-- Hide
function DeadlineDice.getHideModifiers(modifiers, character)


    -- Define a lookup table mapping traits to their modifier values
    local traitModifiers = {
        Graceful = 1,
        Inconspicuous = 2,
        Clumsy = -1,
        Conspicuous = -2,
    }

    return DeadlineDice.addTraitModifiers2(modifiers, character, traitModifiers)
end

-- Spot
function DeadlineDice.getSpotModifiers(modifiers, character)


    -- Define a lookup table mapping traits to their modifier values
    local traitModifiers = {
        Nightvision = 2,
        EagleEyed = 2,
        KeenHearing = 2,
        ShortSighted = -1,
        HardofHearing = -1,
        Deaf = -2,
    }

    return DeadlineDice.addTraitModifiers2(modifiers, character, traitModifiers)
end

-------------------------------- SKILLS ROLLS --------------------------------
function DeadlineDice.getCarpentryModifiers(modifiers, character, diceScore)
    modifiers["50% of Roll"] = -math.floor(diceScore / 2)
    modifiers["Carpentry"] = character:getPerkLevel(Perks.Woodwork)
    return modifiers
end

function DeadlineDice.getCookingModifiers(modifiers, character, diceScore)
    modifiers["50% of Roll"] = -math.floor(diceScore / 2)
    modifiers["Cooking"] = character:getPerkLevel(Perks.Cooking)
    return modifiers
end

function DeadlineDice.getFarmingModifiers(modifiers, character, diceScore)
    modifiers["50% of Roll"] = -math.floor(diceScore / 2)
    modifiers["Farming"] = character:getPerkLevel(Perks.Farming)
    return modifiers
end

function DeadlineDice.getElectricalModifiers(modifiers, character, diceScore)
    modifiers["50% of Roll"] = -math.floor(diceScore / 2)
    modifiers["Electrical"] = character:getPerkLevel(Perks.Electricity)
    return modifiers
end

function DeadlineDice.getMetalworkingModifiers(modifiers, character, diceScore)
    modifiers["50% of Roll"] = -math.floor(diceScore / 2)
    modifiers["Metalworking"] = character:getPerkLevel(Perks.MetalWelding)
    return modifiers
end

function DeadlineDice.getMechanicsModifiers(modifiers, character, diceScore)
    modifiers["50% of Roll"] = -math.floor(diceScore / 2)
    modifiers["Mechanics"] = character:getPerkLevel(Perks.Mechanics)
    return modifiers
end

function DeadlineDice.getTailoringModifiers(modifiers, character, diceScore)
    modifiers["50% of Roll"] = -math.floor(diceScore / 2)
    modifiers["Tailoring"] = character:getPerkLevel(Perks.Tailoring)
    return modifiers
end

function DeadlineDice.getFirstAidModifiers(modifiers, character)
    modifiers["First Aid"] = character:getPerkLevel(Perks.Doctor)
    return modifiers
end

-------------------------------- ENDURANCE ROLLS --------------------------------
function DeadlineDice.getPhysicalEnduranceModifiers(modifiers, character)


    -- local currentEndurance = character:getStats():getEndurance()
    -- local currentPanic = character:getStats():getPanic()

    -- -- Calculate the percentage of missing endurance (range 0 to 1)
    -- local missingEndurancePercentage = (1 - currentEndurance) * 100 -- Convert to percentage
    -- local panicModifier = math.floor((currentPanic) / 20)

    -- -- Apply modifiers with percentage values in the keys
    -- modifiers[math.floor(missingEndurancePercentage) .. "% " .. "Missing Endurance"] = -math.floor((1 - currentEndurance) *
    --     5)

    -- modifiers[math.floor(currentPanic) .. "% " .. "Panic"] = -panicModifier

    local traitModifiers = {
        ProneToIllness = -1,
        Asthmatic = -2,
        FastHealer = 2,
        Resilient = 1,
        ThickSkinned = 3,
        SlowHealer = -2,
        IronGut = 1,
        WeakStomach = -1,
        Outdoorsman = 3,
        Thinskinned = -2,
        Stalwart = 2,
        Spry = 1,
        Resolute = 1,
        Frail = -2,
        Reckless = -1,
        Sluggish = -1,
    }

    return DeadlineDice.addTraitModifiers2(modifiers, character, traitModifiers)
end

function DeadlineDice.getMentalEnduranceModifiers(modifiers, character)
    -- Get Unhappiness level (Already in percentage)
    -- local currentUnhappiness = character:getBodyDamage():getUnhappynessLevel()
    -- local currentBoredom = character:getStats():getBoredom()

    -- Calculate the percentage of boredom (range 0 to 1)
    -- local boredomPercentage = currentBoredom * 100 -- Convert to percentage

    -- Calculate the number of points to deduct for unhappiness
    -- local unhappinessModifier = math.floor(currentUnhappiness / 20) -- Add 1 point for every 20% unhappiness


    -- modifiers[math.floor(currentUnhappiness) .. "% " .. "Unhappiness"] = -unhappinessModifier
    -- modifiers[math.floor(boredomPercentage) .. "% " .. "Boredom"] = -math.floor(currentBoredom * 5)

    -- Define a lookup table mapping traits to their modifier values
    local traitModifiers = {
        Spiritual = 1,
        Tranquil = 2,
        Resolute = 1,
        WeakWilled = -2,
        Reckless = -1,
        Organized = 1,
        Disorganized = -1,
        Smoker = -1,
        WeakWilled = -2,
        FrailNerves = -1,
        Clearheaded = 1,
        FastLearner = 3,

    }

    return DeadlineDice.addTraitModifiers2(modifiers, character, traitModifiers)
end
