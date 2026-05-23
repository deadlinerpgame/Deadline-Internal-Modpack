HORSE_ITEM_TYPES = {
    ["2TK_models.2TK_Horse"] = true,
    ["2TK_models.2TK_Horse_01"] = true,
    ["2TK_models.2TK_Horse_02"] = true,
    ["2TK_models.2TK_Horse_03"] = true,
    ["2TK_models.2TK_Horse_04"] = true,
    ["2TK_models.2TK_Horse_SaddlebagS"] = true,
    ["2TK_models.2TK_Horse_01_SaddlebagS"] = true,
    ["2TK_models.2TK_Horse_02_SaddlebagS"] = true,
    ["2TK_models.2TK_Horse_03_SaddlebagS"] = true,
    ["2TK_models.2TK_Horse_04_SaddlebagS"] = true,
    ["2TK_models.2TK_Horse_SaddlebagM"] = true,
    ["2TK_models.2TK_Horse_01_SaddlebagM"] = true,
    ["2TK_models.2TK_Horse_02_SaddlebagM"] = true,
    ["2TK_models.2TK_Horse_03_SaddlebagM"] = true,
    ["2TK_models.2TK_Horse_04_SaddlebagM"] = true,
    ["2TK_models.2TK_Horse_SaddlebagL"] = true,
    ["2TK_models.2TK_Horse_01_SaddlebagL"] = true,
    ["2TK_models.2TK_Horse_02_SaddlebagL"] = true,
    ["2TK_models.2TK_Horse_03_SaddlebagL"] = true,
    ["2TK_models.2TK_Horse_04_SaddlebagL"] = true,
    ["2TK_models.2TK_Horse_SaddlebagSH"] = true,
    ["2TK_models.2TK_Horse_01_SaddlebagSH"] = true,
    ["2TK_models.2TK_Horse_02_SaddlebagSH"] = true,
    ["2TK_models.2TK_Horse_03_SaddlebagSH"] = true,
    ["2TK_models.2TK_Horse_04_SaddlebagSH"] = true,
    ["2TK_models.2TK_Horse_SaddlebagMH"] = true,
    ["2TK_models.2TK_Horse_01_SaddlebagMH"] = true,
    ["2TK_models.2TK_Horse_02_SaddlebagMH"] = true,
    ["2TK_models.2TK_Horse_03_SaddlebagMH"] = true,
    ["2TK_models.2TK_Horse_04_SaddlebagMH"] = true,
    ["2TK_models.2TK_Horse_SaddlebagLH"] = true,
    ["2TK_models.2TK_Horse_01_SaddlebagLH"] = true,
    ["2TK_models.2TK_Horse_02_SaddlebagLH"] = true,
    ["2TK_models.2TK_Horse_03_SaddlebagLH"] = true,
    ["2TK_models.2TK_Horse_04_SaddlebagLH"] = true,

}

HORSE_FEED_TYPES = {
    "Base.Apple",

}

HORSE_WATER_TYPES = {
    "Base.WaterBottleFull",
}

HORSE_SADDLE_TYPES = {
    ["Animals.Saddle"] = "Standard Saddle",
    ["Animals.RacingSaddle"] = "Racing Saddle",
    ["Animals.RoadtripSaddle"] = "Roadtrip Saddle",
}

HORSE_HEAD_TYPES = {
    ["Animals.Blinder"] = "Blinders",
}

HORSE_BACK_TYPES = {
    ["Animals.SaddlebagSmall"]  = { name = "Small Saddlebag",  size = "S", kind = "bag" },
    ["Animals.SaddlebagMedium"] = { name = "Medium Saddlebag", size = "M", kind = "bag" },
    ["Animals.SaddlebagLarge"]  = { name = "Large Saddlebag",  size = "L", kind = "bag" },
    ["Animals.Barding"]         = { name = "Barding", kind = "barding" },
}

HORSE_HOOF_TYPES = {
    ["Animals.Horseshoes"] = { name = "Horseshoes", stealth = false },
    ["Animals.HoofWraps"]  = { name = "Hoof Wraps",  stealth = true },
}

HORSE_MOUTH_TYPES = {
    ["Animals.Feedbag"]      = { name = "Feedbag",       fillType = "food" },
    ["Animals.WaterCanteen"] = { name = "Water Canteen", fillType = "water" },
}

HORSE_FEEDBAG_FOODS = {
    ["DeadlineHorse.FoodHorseA"] = { amount = 50,  name = "Horse Feed" },
    ["DeadlineHorse.FoodHorseB"] = { amount = 100, name = "Large Horse Feed" },
}

HORSE_TEMPERAMENTS = {
    Steady     = {},
    Spirited   = { speedMult = 1.15, stamMaxMult = 1.10, stamDrainMult = 1.20, fearBuildMult = 1.25 },
    Stubborn   = { speedMult = 0.85, stamDrainMult = 0.80, fearBuildMult = 0.7, accelMult = 0.7 },
    Nervous    = { speedMult = 1.20, stamMaxMult = 0.75, fearBuildMult = 1.5, accelMult = 1.3 },
    Gentle     = { hungerDrainMult = 0.9, thirstDrainMult = 0.9, regenMult = 1.2 },
    Hardy      = { speedMult = 0.80, hungerDrainMult = 0.7, thirstDrainMult = 0.7, healthMaxMult = 1.30 },
    Brave      = { healthMaxMult = 1.10, stamMaxMult = 0.9, fearBuildMult = 0.4 },
    Skittish   = { speedMult = 0.90, fearBuildMult = 1.4, fearRadiusBonus = 5 },
    Lazy       = { stamDrainMult = 0.75, accelMult = 0.7 },
    Fierce     = { speedMult = 1.10, healthMaxMult = 1.10, hungerDrainMult = 1.15, fearBuildMult = 0.85 },
    Enduring   = { speedMult = 0.90, stamMaxMult = 1.40 },
    Wild       = { speedMult = 1.20, stamMaxMult = 1.15, fearBuildMult = 0.9, throwChance = 0.005 },
    Phantom    = { speedMult = 1.25, healthMaxMult = 0.80, fearBuildMult = 1.25, hoofstepMult = 0.5 },
    Workhorse  = { speedMult = 0.90, stamMaxMult = 1.25 },
    Rascal     = { speedMult = 1.10, refuseMountChance = 0.003 },
    Loyal      = {},
    Glutton    = { speedMult = 0.95, healthMaxMult = 1.15, stamMaxMult = 1.10, hungerDrainMult = 1.30 },
    Swift      = { speedMult = 1.30, stamMaxMult = 0.80, healthMaxMult = 0.90 },
    Resilient  = { healthMaxMult = 1.20, fearBuildMult = 0.80 },
    Cowardly   = { fearBuildMult = 2.0, fearDecayMult = 0.5 },
    Frail      = { healthMaxMult = 0.60, stamMaxMult = 0.80 },
}

HORSE_TEMPERAMENT_LIST = {}
for name, _ in pairs(HORSE_TEMPERAMENTS) do
    table.insert(HORSE_TEMPERAMENT_LIST, name)
end

function rollHorseTemperament()
    return HORSE_TEMPERAMENT_LIST[ZombRand(#HORSE_TEMPERAMENT_LIST) + 1]
end

function getTemperamentMult(data, key, default)
    local tempName = data.temperament or "Steady"
    local temp = HORSE_TEMPERAMENTS[tempName] or {}
    return temp[key] or default or 1.0
end

function applyTemperamentToExistingHorse(data, tempName)
    local temp = HORSE_TEMPERAMENTS[tempName] or {}
    data.temperament = tempName

    local healthPct = (data.health or 300) / (data.maxHealth or 300)
    local stamPct = (data.stamina or 300) / (data.maxStamina or 300)

    data.maxHealth = math.floor(300 * (temp.healthMaxMult or 1.0))
    data.maxStamina = math.floor(300 * (temp.stamMaxMult or 1.0))
    data.health = math.floor(data.maxHealth * healthPct)
    data.stamina = math.floor(data.maxStamina * stamPct)

    if temp.speedMult and not data._temperamentSpeedApplied then
        data.speedModifier = (data.speedModifier or 1.0) * temp.speedMult
        data._temperamentSpeedApplied = true
    end
end


function setHorseTemperamentDebug(player, item, tempName)
    if checkHorseGhost(item, player) then return end
    if not item or not tempName then return end
    assignHorseGUID(item, player)
    local data = item:getModData()
    local guid = data.horseGUID or "NO_GUID"
    local oldTemperament = data.temperament or "none"
    if data._temperamentSpeedApplied and data.temperament then
        local oldTemp = HORSE_TEMPERAMENTS[data.temperament] or {}
        if oldTemp.speedMult then
            data.speedModifier = (data.speedModifier or 1.0) / oldTemp.speedMult
        end
        data._temperamentSpeedApplied = false
    end
    applyTemperamentToExistingHorse(data, tempName)
    modifyModData(player, item, {
        temperament = data.temperament,
        maxHealth = data.maxHealth,
        maxStamina = data.maxStamina,
        health = data.health,
        stamina = data.stamina,
        speedModifier = data.speedModifier,
        _temperamentSpeedApplied = data._temperamentSpeedApplied,
    })
    player:Say("Horse temperament set to " .. tempName)
    localtext = player:getUsername() .. " has ADMIN-changed temperament of horse " .. item:getName() .. " from " .. oldTemperament .. " to " .. tempName .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(player:getX()) .. " " .. math.floor(player:getY()) .. " " .. math.floor(player:getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, item, "temperament_change")
end

HORSE_SADDLEBAG_VARIANTS = {
    ["2TK_models.2TK_Horse"]    = { S = "2TK_models.2TK_Horse_SaddlebagS",    M = "2TK_models.2TK_Horse_SaddlebagM",    L = "2TK_models.2TK_Horse_SaddlebagL" },
    ["2TK_models.2TK_Horse_01"] = { S = "2TK_models.2TK_Horse_01_SaddlebagS", M = "2TK_models.2TK_Horse_01_SaddlebagM", L = "2TK_models.2TK_Horse_01_SaddlebagL" },
    ["2TK_models.2TK_Horse_02"] = { S = "2TK_models.2TK_Horse_02_SaddlebagS", M = "2TK_models.2TK_Horse_02_SaddlebagM", L = "2TK_models.2TK_Horse_02_SaddlebagL" },
    ["2TK_models.2TK_Horse_03"] = { S = "2TK_models.2TK_Horse_03_SaddlebagS", M = "2TK_models.2TK_Horse_03_SaddlebagM", L = "2TK_models.2TK_Horse_03_SaddlebagL" },
    ["2TK_models.2TK_Horse_04"] = { S = "2TK_models.2TK_Horse_04_SaddlebagS", M = "2TK_models.2TK_Horse_04_SaddlebagM", L = "2TK_models.2TK_Horse_04_SaddlebagL" },
}

HORSE_SADDLEBAG_VARIANTS_WORKHORSE = {
    ["2TK_models.2TK_Horse"]    = { S = "2TK_models.2TK_Horse_SaddlebagSH",    M = "2TK_models.2TK_Horse_SaddlebagMH",    L = "2TK_models.2TK_Horse_SaddlebagLH" },
    ["2TK_models.2TK_Horse_01"] = { S = "2TK_models.2TK_Horse_01_SaddlebagSH", M = "2TK_models.2TK_Horse_01_SaddlebagMH", L = "2TK_models.2TK_Horse_01_SaddlebagLH" },
    ["2TK_models.2TK_Horse_02"] = { S = "2TK_models.2TK_Horse_02_SaddlebagSH", M = "2TK_models.2TK_Horse_02_SaddlebagMH", L = "2TK_models.2TK_Horse_02_SaddlebagLH" },
    ["2TK_models.2TK_Horse_03"] = { S = "2TK_models.2TK_Horse_03_SaddlebagSH", M = "2TK_models.2TK_Horse_03_SaddlebagMH", L = "2TK_models.2TK_Horse_03_SaddlebagLH" },
    ["2TK_models.2TK_Horse_04"] = { S = "2TK_models.2TK_Horse_04_SaddlebagSH", M = "2TK_models.2TK_Horse_04_SaddlebagMH", L = "2TK_models.2TK_Horse_04_SaddlebagLH" },
}

HORSE_SADDLEBAG_REVERSE = {}
for baseType, sizes in pairs(HORSE_SADDLEBAG_VARIANTS) do
    for _, variantType in pairs(sizes) do
        HORSE_SADDLEBAG_REVERSE[variantType] = baseType
        HORSE_ITEM_TYPES[variantType] = true
    end
end
for baseType, sizes in pairs(HORSE_SADDLEBAG_VARIANTS_WORKHORSE) do
    for _, variantType in pairs(sizes) do
        HORSE_SADDLEBAG_REVERSE[variantType] = baseType
        HORSE_ITEM_TYPES[variantType] = true
    end
end

local function initHorseStats(item)
    if not item then return end
    local data = item:getModData()

    if not data._initialized then
        data.health = ZombRand(300, 401)
        data.maxHealth = data.health
        data.speedModifier = ZombRandFloat(1.2, 1.7)
        data.temperament = rollHorseTemperament()
        local _temp = HORSE_TEMPERAMENTS[data.temperament] or {}
        data.maxHealth = math.floor(data.maxHealth * (_temp.healthMaxMult or 1.0))
        data.health = data.maxHealth
        if _temp.speedMult then
            data.speedModifier = data.speedModifier * _temp.speedMult
        end
        data._temperamentSpeedApplied = true
        data.horseSpeed = data.horseSpeed or 0.0
        data._coastTime = data._coastTime or 0
        data._coastDir = data._coastDir or nil
        data.maxHorseSpeed = 0
        data.hunger = 300
        data.maxHunger = 300
        data.thirst = 300
        data.maxThirst = 300
        data.stamina = math.floor(300 * (_temp.stamMaxMult or 1.0))
        data.maxStamina = data.stamina
        data.owner = "THEREISNOCLAIMANT"
        data.riders = {}
        data.oldName = ""
        data.description = ""
        data.equipment = data.equipment or {}
        data.equipment.saddle = nil
        data.equipment.saddleWear = 0
        data.equipment.head = nil
        data.equipment.headWear = 0
        data.equipment.back = nil
        data.equipment.backWear = 0
        data.fear = 0
        data._lastTileX = nil
        data._lastTileY = nil
        data._lastFearCheck = 0

        data._initialized = true


    end

    if data._initialized and not data.temperament then
        applyTemperamentToExistingHorse(data, rollHorseTemperament())
        data.equipment = data.equipment or {}
        data.equipment.saddle = "Animals.Saddle"
        data.equipment.saddleWear = 100
    end
end


local function onTickHorseInit()

    local player = getPlayer()
    if not player or player:isDead() then return end

    local inventory = player:getInventory()
    if not inventory then return end

    local items = inventory:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item and HORSE_ITEM_TYPES[item:getFullType()] then
            player:setIgnoreAutoVault(true);
            initHorseStats(item)
        else
        player:setIgnoreAutoVault(false);
        end
    end
end

Events.OnTick.Add(onTickHorseInit);


local function assignHorseGUID(item, player)
    if not item or not player then return end
    local data = item:getModData()
    if not data or data.horseGUID then return end

    local username = player:getUsername()
    local hourTimestamp = getGameTime():getWorldAgeHours()
    data.horseGUID = username .. "_" .. math.floor(hourTimestamp)

end

local function predicateEvalWaterItem(item)
    return item:canStoreWater() and item:IsDrainable() and item:getUsedDelta() > 0.0;
end

local function addWaterItemsToHorse(player, context, menuOption, horse)

    local subMenu = context:getNew(context);
    context:addSubMenu(menuOption, subMenu);

    local waterItems = player:getInventory():getAllEvalRecurse(predicateEvalWaterItem);

    if (not waterItems) or (waterItems:size() == 0) then
        menuOption.notAvailable = true;

        local noWaterItems = subMenu:addOption("You do not have any water containers.", player, nil);
        noWaterItems.notAvailable = true;
        return;
    end

    for i = 0, waterItems:size() - 1 do
        local waterItem = waterItems:get(i);
        subMenu:addOption(waterItem:getDisplayName(), player, onFeedHorse, horse, waterItem);
    end
end

local function horseContextMenu(player, context, items)
    for _, entry in ipairs(items) do
        local item = entry
        if type(entry) == "table" and entry.items then
            item = entry.items[1]
        end

        if item and HORSE_ITEM_TYPES[item:getFullType()] then
            local data = item:getModData()
            if data and data._initialized then

                local player = getPlayer()
                local mounted = item:getContainer() == player:getInventory()
                if not mounted then

                    if data.owner == "" or data.owner == "THEREISNOCLAIMANT" then
                        context:addOption("Claim", player, claimHorse, item)
                    elseif data.owner == player:getUsername() then
                        context:addOption("Mount", item, doMount, player)
                        context:addOption("Rename", player, renameHorse, item)
                        context:addOption("Unclaim", player, unclaimHorse, item)

                        local descMenu = context:addOption("Description", worldobjects)
                        local descSub = ISContextMenu:getNew(context)
                        context:addSubMenu(descMenu, descSub)
                        descSub:addOption("Set Description", player, setHorseDescription, item)
                        local clearOpt = descSub:addOption("Clear Description", player, clearHorseDescription, item)
                        if not data.description or data.description == "" then
                            clearOpt.notAvailable = true
                        end

                        local equipMenu = context:addOption("Equip", worldobjects)
                        local equipSub = ISContextMenu:getNew(context)
                        context:addSubMenu(equipMenu, equipSub)
                        local hasEquippable = false
                        if not data.equipment or not data.equipment.saddle then
                            for saddleType, saddleName in pairs(HORSE_SADDLE_TYPES) do
                                local saddleItem = player:getInventory():FindAndReturn(saddleType)
                                if saddleItem then
                                    hasEquippable = true
                                    local saddleWear = saddleItem:getModData().saddleWear or 100
                                    local opt = equipSub:addOption(saddleName .. " (" .. math.floor(saddleWear) .. "%)", player, equipSaddleOnHorse, item, saddleItem)
                                    local tip = ISToolTip:new()
                                    tip:initialise()
                                    tip.description = getSaddleTooltip(saddleType) .. "\nCondition: " .. math.floor(saddleWear) .. "%"
                                    opt.toolTip = tip
                                end
                            end
                        end
                        if not data.equipment or not data.equipment.head then
                            for headType, headName in pairs(HORSE_HEAD_TYPES) do
                                local headItem = player:getInventory():FindAndReturn(headType)
                                if headItem then
                                    hasEquippable = true
                                    local headWear = headItem:getModData().headWear or 100
                                    local opt = equipSub:addOption(headName .. " (" .. math.floor(headWear) .. "%)", player, equipHeadOnHorse, item, headItem)
                                    local tip = ISToolTip:new()
                                    tip:initialise()
                                    tip.description = getHeadTooltip(headType) .. "\nCondition: " .. math.floor(headWear) .. "%"
                                    opt.toolTip = tip
                                end
                            end
                        end
                        if not data.equipment or not data.equipment.back then
                            for bagType, bagInfo in pairs(HORSE_BACK_TYPES) do
                                local bagItem = player:getInventory():FindAndReturn(bagType)
                                if bagItem then
                                    hasEquippable = true
                                    local bagWear = bagItem:getModData().backWear or 100
                                    local onSelectFn = bagInfo.kind == "barding" and equipBardingOnHorse or equipSaddlebagOnHorse
                                    local opt = equipSub:addOption(bagInfo.name .. " (" .. math.floor(bagWear) .. "%)", player, onSelectFn, item, bagItem)
                                    local tip = ISToolTip:new()
                                    tip:initialise()
                                    tip.description = getBackTooltip(bagType) .. "\nCondition: " .. math.floor(bagWear) .. "%"
                                    opt.toolTip = tip
                                end
                            end
                        end
                        if not data.equipment or not data.equipment.hoof then
                            for hoofType, hoofInfo in pairs(HORSE_HOOF_TYPES) do
                                local hoofItem = player:getInventory():FindAndReturn(hoofType)
                                if hoofItem then
                                    hasEquippable = true
                                    local hoofWear = hoofItem:getModData().hoofWear or 100
                                    equipSub:addOption(hoofInfo.name .. " (" .. math.floor(hoofWear) .. "%)", player, equipHoofOnHorse, item, hoofItem)
                                end
                            end
                        end
                        if not data.equipment or not data.equipment.mouth then
                            for mouthType, mouthInfo in pairs(HORSE_MOUTH_TYPES) do
                                local mouthItem = player:getInventory():FindAndReturn(mouthType)
                                if mouthItem then
                                    hasEquippable = true
                                    local mouthWear = mouthItem:getModData().mouthWear or 100
                                    equipSub:addOption(mouthInfo.name .. " (" .. math.floor(mouthWear) .. "%)", player, equipMouthOnHorse, item, mouthItem)
                                end
                            end
                        end
                        if not hasEquippable then
                            local noOpt = equipSub:addOption("Nothing available to equip.")
                            noOpt.notAvailable = true
                        end

                        local unequipMenu = context:addOption("Unequip", worldobjects)
                        local unequipSub = ISContextMenu:getNew(context)
                        context:addSubMenu(unequipMenu, unequipSub)
                        local hasUnequippable = false
                        if data.equipment and data.equipment.saddle then
                            hasUnequippable = true
                            local saddleName = HORSE_SADDLE_TYPES[data.equipment.saddle] or "Unknown Saddle"
                            local saddleWear = data.equipment.saddleWear or 0
                            unequipSub:addOption(saddleName .. " (" .. math.floor(saddleWear) .. "%)", player, unequipSaddleFromHorse, item)
                        end
                        if data.equipment and data.equipment.head then
                            hasUnequippable = true
                            local headName = HORSE_HEAD_TYPES[data.equipment.head] or "Unknown"
                            local headWear = data.equipment.headWear or 0
                            unequipSub:addOption(headName .. " (" .. math.floor(headWear) .. "%)", player, unequipHeadFromHorse, item)
                        end
                        if data.equipment and data.equipment.back then
                            hasUnequippable = true
                            local bagInfo = HORSE_BACK_TYPES[data.equipment.back] or { name = "Unknown" }
                            local bagWear = data.equipment.backWear or 0
                            local unequipFn = bagInfo.kind == "barding" and unequipBardingFromHorse or unequipSaddlebagFromHorse
                            unequipSub:addOption(bagInfo.name .. " (" .. math.floor(bagWear) .. "%)", player, unequipFn, item)
                        end
                        if data.equipment and data.equipment.hoof then
                            hasUnequippable = true
                            local hoofInfo = HORSE_HOOF_TYPES[data.equipment.hoof] or { name = "Unknown" }
                            local hoofWear = data.equipment.hoofWear or 0
                            unequipSub:addOption(hoofInfo.name .. " (" .. math.floor(hoofWear) .. "%)", player, unequipHoofFromHorse, item)
                        end
                        if data.equipment and data.equipment.mouth then
                            hasUnequippable = true
                            local mouthInfo = HORSE_MOUTH_TYPES[data.equipment.mouth] or { name = "Unknown" }
                            local mouthWear = data.equipment.mouthWear or 0
                            local mouthFill = data.equipment.mouthFill or 0
                            unequipSub:addOption(mouthInfo.name .. " (" .. math.floor(mouthWear) .. "%, " .. math.floor(mouthFill) .. "%)", player, unequipMouthFromHorse, item)
                        end
                        if not hasUnequippable then
                            local noOpt = unequipSub:addOption("Nothing equipped.")
                            noOpt.notAvailable = true
                        end
                    end

                    if player:getAccessLevel() == "Admin" or isDebugEnabled() then
                        context:addOption("Horse Owner: " .. data.owner, item, doMount, player)
                        context:addOption("ADMIN Mount", item, doMount, player)
                        context:addOption("ADMIN Unclaim", player, unclaimHorseAdmin, item)
                        context:addOption("ADMIN Edit", player, openHorseStatsEditor, item)

                        local tempMenu = context:addOption("ADMIN Set Temperament")
                        local tempSub = ISContextMenu:getNew(context)
                        context:addSubMenu(tempMenu, tempSub)
                        for _, tempName in ipairs(HORSE_TEMPERAMENT_LIST) do
                            local marker = (data.temperament == tempName) and " [current]" or ""
                            tempSub:addOption(tempName .. marker, player, setHorseTemperamentDebug, item, tempName)
                        end
                    end

                    local menuOption = context:addOption("Feed", worldobjects);
                    local subMenu = ISContextMenu:getNew(context);
                    context:addSubMenu(menuOption, subMenu);

                    for _, foodType in ipairs(HORSE_FEED_TYPES) do
                        local foodItem = player:getInventory():FindAndReturn(foodType)
                        local scriptManager = getScriptManager()
                        local name = scriptManager:getItem(foodType):getDisplayName()
                        local opt
                        local hunger
                        if foodItem and (not foodItem:IsFood() or not foodItem:isRotten()) then
                            opt = subMenu:addOption(name, player, onFeedHorse, item, foodItem)
                            hunger = (Math.abs(foodItem:getHungerChange() * 100))
                            local tip = ISToolTip:new()
                            tip:initialise()
                            tip.description = "Will restore up to " .. hunger .. " hunger."
                            opt.toolTip = tip
                        else
                            opt = subMenu:addOption(name)
                            opt.notAvailable = true
                        end
                    end

                    local menuOption = context:addOption("Give Water", worldobjects);

                    addWaterItemsToHorse(player, context, menuOption, item);

                elseif mounted and not player:isPlayerMoving() and not player:isRunning() and not player:isSprinting() then
                    context:addOption("Dismount", item, doDismount, player)
                end

                local nearWater, X, Y, Z = checkWater(player);
                if nearWater then
                    context:addOption("Drink", player, onDrinkGroundWater, item, x, y, z)
                end

                context:addOption("Horse Stats", nil, nil)

                context:addOption("Health: " .. math.floor(data.health) .. " / " .. math.floor(data.maxHealth), nil, nil)
                context:addOption("Stamina: " .. math.floor(data.stamina) .. " / " .. math.floor(data.maxStamina), nil, nil)
                context:addOption("Hunger: " .. math.floor(data.hunger) .. " / " .. math.floor(data.maxHunger), nil, nil)
                context:addOption("Thirst: " .. math.floor(data.thirst) .. " / " .. math.floor(data.maxThirst), nil, nil)

                local fearLevel = data.fear or 0
                local fearText = "Calm"
                if fearLevel >= 80 then
                    fearText = "Panicked"
                elseif fearLevel >= 50 then
                    fearText = "Spooked"
                elseif fearLevel >= 25 then
                    fearText = "Uneasy"
                end
                context:addOption("Fear: " .. math.floor(fearLevel) .. " (" .. fearText .. ")", nil, nil)

                context:addOption("Speed: " .. string.format("%.2f", data.speedModifier) .. "x", nil, nil)
                context:addOption("Temperament: " .. (data.temperament or "Unknown"), nil, nil)

                if data.equipment and data.equipment.saddle then
                    local saddleName = HORSE_SADDLE_TYPES[data.equipment.saddle] or "Unknown"
                    local saddleWear = data.equipment.saddleWear or 0
                    context:addOption("Saddle: " .. saddleName .. " (" .. math.floor(saddleWear) .. "%)", nil, nil)
                else
                    context:addOption("Saddle: None (Bareback)", nil, nil)
                end

                if data.equipment and data.equipment.head then
                    local headName = HORSE_HEAD_TYPES[data.equipment.head] or "Unknown"
                    local headWear = data.equipment.headWear or 0
                    context:addOption("Head: " .. headName .. " (" .. math.floor(headWear) .. "%)", nil, nil)
                else
                    context:addOption("Head: None", nil, nil)
                end

                if data.equipment and data.equipment.back then
                    local bagInfo = HORSE_BACK_TYPES[data.equipment.back] or { name = "Unknown" }
                    local bagWear = data.equipment.backWear or 0
                    context:addOption("Back: " .. bagInfo.name .. " (" .. math.floor(bagWear) .. "%)", nil, nil)
                else
                    context:addOption("Back: None", nil, nil)
                end

                if data.equipment and data.equipment.hoof then
                    local info = HORSE_HOOF_TYPES[data.equipment.hoof] or { name = "Unknown" }
                    context:addOption("Hooves: " .. info.name .. " (" .. math.floor(data.equipment.hoofWear or 0) .. "%)", nil, nil)
                else
                    context:addOption("Hooves: Bare", nil, nil)
                end

                if data.equipment and data.equipment.mouth then
                    local info = HORSE_MOUTH_TYPES[data.equipment.mouth] or { name = "Unknown" }
                    context:addOption("Mouth: " .. info.name .. " (" .. math.floor(data.equipment.mouthWear or 0) .. "%, " .. math.floor(data.equipment.mouthFill or 0) .. "%)", nil, nil)
                else
                    context:addOption("Mouth: None", nil, nil)
                end

            else
                context:addOption("Reassure Horse", player, reassureHorse, item)
            end
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(horseContextMenu)

local function countZombiesInCone(player, radius, halfAngle)
    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())
    local cell = getCell()
    local count = 0
    local closest = radius + 1

    local facingRad = math.rad(player:getDirectionAngle())

    local ipx = math.floor(px)
    local ipy = math.floor(py)

    for x = ipx - radius, ipx + radius do
        for y = ipy - radius, ipy + radius do
            local sq = cell:getGridSquare(x, y, pz)
            if sq then
                local objects = sq:getMovingObjects()
                if objects then
                    for i = 0, objects:size() - 1 do
                        local obj = objects:get(i)
                        if instanceof(obj, "IsoZombie") then
                            local zx = obj:getX()
                            local zy = obj:getY()
                            local dx = zx - px
                            local dy = zy - py
                            local dist = math.sqrt(dx * dx + dy * dy)

                            if dist <= radius then
                                local angleToZombie = math.atan2(dy, dx)
                                local diff = math.abs(angleToZombie - facingRad)
                                if diff > math.pi then
                                    diff = 2 * math.pi - diff
                                end

                                if diff <= halfAngle then
                                    count = count + (1.0 - (dist / radius))
                                    if dist < closest then
                                        closest = dist
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return count, closest
end

lastHorseUpdateTime = 0
lastHorseStepTime = 0
lastFearSoundTime = 0


local function updateHorseStatsTick()

    local player = getPlayer()
    if not player or player:isDead() then return end

    local inventory = player:getInventory()
    if not inventory then return end

    local horse = player:getWornItem("Horse")
    if not horse then
        lastHorseUpdateTime = 0
        return
    end

    local data = horse:getModData()
    if not data or not data._initialized then return end

local now = getTimestampMs()

if lastHorseUpdateTime == 0 then
    lastHorseUpdateTime = now
    return
end

if now - lastHorseUpdateTime < 250 then return end

local delta = (now - lastHorseUpdateTime) / 1000.0
lastHorseUpdateTime = now

    local isSprinting = player:isSprinting()
    local isRunning = player:isRunning()
    local isMoving = player:isPlayerMoving()
    local stats = player:getStats()

if not data.equipment then
    data.equipment = {}
end
if data.equipment.hoof == nil then data.equipment.hoof = nil end
if data.equipment.hoofWear == nil then data.equipment.hoofWear = 0 end
if data.equipment.mouth == nil then data.equipment.mouth = nil end
if data.equipment.mouthWear == nil then data.equipment.mouthWear = 0 end
if data.equipment.mouthFill == nil then data.equipment.mouthFill = 0 end

local hasSaddle = data.equipment.saddle and (data.equipment.saddleWear or 0) > 0
local saddleType = hasSaddle and data.equipment.saddle or nil

if isMoving then
    local tileX = math.floor(player:getX())
    local tileY = math.floor(player:getY())
    if data._lastTileX and data._lastTileY then
        if tileX ~= data._lastTileX or tileY ~= data._lastTileY then
            if hasSaddle and ZombRand(300) == 0 then
                data.equipment.saddleWear = math.max(0, (data.equipment.saddleWear or 100) - 1)
            end
            local hasHead = data.equipment.head and (data.equipment.headWear or 0) > 0
            if hasHead and ZombRand(300) == 0 then
                data.equipment.headWear = math.max(0, (data.equipment.headWear or 100) - 1)
            end
            local hasBack = data.equipment.back and (data.equipment.backWear or 0) > 0
            if hasBack and ZombRand(300) == 0 then
                data.equipment.backWear = math.max(0, (data.equipment.backWear or 100) - 1)
            end
            local hasHoofWear = data.equipment.hoof and (data.equipment.hoofWear or 0) > 0
            if hasHoofWear and ZombRand(200) == 0 then
                data.equipment.hoofWear = math.max(0, (data.equipment.hoofWear or 100) - 1)
            end
            local hasMouthWear = data.equipment.mouth and (data.equipment.mouthWear or 0) > 0
            if hasMouthWear and ZombRand(300) == 0 then
                data.equipment.mouthWear = math.max(0, (data.equipment.mouthWear or 100) - 1)
            end
        end
    end
    data._lastTileX = tileX
    data._lastTileY = tileY
end

if not data.fear then data.fear = 0 end
if not data._lastFearCheck then data._lastFearCheck = 0 end

if now - data._lastFearCheck >= 500 then
    data._lastFearCheck = now

    local fearRadius = 15 + getTemperamentMult(data, "fearRadiusBonus", 0)
    local hasBlinder = data.equipment.head == "Animals.Blinder" and (data.equipment.headWear or 0) > 0
    local halfAngle = hasBlinder and math.rad(45) or math.rad(90)

    local zombieCount, closestDist = countZombiesInCone(player, fearRadius, halfAngle)

    if zombieCount > 0 then
        local proximityFactor = 1.0 - (closestDist / fearRadius)
        local fearGain = zombieCount * 0.5 * getTemperamentMult(data, "fearBuildMult")
        data.fear = math.min(100, data.fear + fearGain)
    else
        local fearDecay = 2.5 * getTemperamentMult(data, "fearDecayMult")
        data.fear = math.max(0, data.fear - fearDecay)
    end
end

    if data.fear >= 100 and not data._hasPlayedScream then
        if isClient() then
            getSoundManager():PlayWorldSound("horse_stop_01", player:getSquare(), 0, 30, 25, false)
        else
            getSoundManager():playUISound("horse_stop_01")
        end
        data._hasPlayedScream = true

        if not data._fearEffect then
            local roll = ZombRand(3)
            if roll == 0 then
data._fearEffect = "dismount"
            elseif roll == 1 then
                data._fearEffect = "dismount"
            else
data._fearEffect = "dismount"
            end
        end
    elseif data.fear < 100 then
        data._hasPlayedScream = false
    end

    if data.fear >= 50 and data.fear < 100 and now - lastFearSoundTime >= 5000 then
        local whinnyVariants = { "horse_whinny_01", "horse_whinny_02", "horse_whinny_03" }
        local sound = whinnyVariants[ZombRand(#whinnyVariants) + 1]
        if isClient() then
            getSoundManager():PlayWorldSound(sound, player:getSquare(), 0, 12, 10, false)
        else
            getSoundManager():playUISound(sound)
        end
        lastFearSoundTime = now
    elseif data.fear >= 25 and data.fear < 50 and now - lastFearSoundTime >= 8000 then
        local snortVariants = { "horse_snort_01", "horse_snort_02", "horse_snort_03" }
        local sound = snortVariants[ZombRand(#snortVariants) + 1]
        if isClient() then
            getSoundManager():PlayWorldSound(sound, player:getSquare(), 0, 4, 3, false)
        else
            getSoundManager():playUISound(sound)
        end
        lastFearSoundTime = now
    end

if data._fearEffect then
    if data._fearEffect == "dismount" then
        data._fearEffect = nil
        data.fear = 50
        forceDismount(player, horse)
        return
    elseif data._fearEffect == "stamina_drain" then
        data.stamina = math.max(0, data.stamina - (80 * delta))
        if now - data._fearEffectStart >= data._fearEffectDuration then
            data._fearEffect = nil
            data._fearEffectStart = nil
            data._fearEffectDuration = nil
        end
    elseif data._fearEffect == "bolt" then
        local angle = math.rad(data._boltDirection)
        local speed = 0.15
        player:setX(player:getX() + math.cos(angle) * speed)
        player:setY(player:getY() + math.sin(angle) * speed)
        data.stamina = math.max(0, data.stamina - (30 * delta))
        if now - data._fearEffectStart >= data._fearEffectDuration then
            data._fearEffect = nil
            data._fearEffectStart = nil
            data._fearEffectDuration = nil
            data._boltDirection = nil
        end
    end
end

if data.stamina <= 0 and not data._exhaustedDebuff then
    data._exhaustedDebuff = true
    data._exhaustedPhase = "stunned"
    data._exhaustedStartTime = getTimestampMs()

    if not player:isInvisible() and not player:isGhostMode() then
        if isClient() then
            getSoundManager():PlayWorldSound("horse_stop_01", player:getSquare(), 0, 5, 5, false)
        else
            getSoundManager():playUISound("horse_stop_01")
        end
    end
        player:setBlockMovement(true)


        data.maxHorseSpeed = 0
        data.horseSpeed = 0
    SpeedFramework.SetPlayerSpeed(player, 0.0)
end


if data._exhaustedDebuff and data._exhaustedPhase == "stunned" then
    local elapsed = getTimestampMs() - (data._exhaustedStartTime or 0)
    if elapsed >= 3000 then
        data._exhaustedPhase = "slowed"
        player:setBlockMovement(false)
        SpeedFramework.SetPlayerSpeed(player, 0.33)

    end
end

    if data.health <= 0 then
        if not player:isInvisible() and not player:isGhostMode() then
            if isClient() then
                getSoundManager():PlayWorldSound("horse_stop_01", player:getSquare(), 0, 5, 5, false)
            else
                getSoundManager():playUISound("horse_stop_01")
            end
        end
        if inventory:contains("2TK_models.2TK_Horse") or inventory:contains("2TK_models.2TK_Horse_01") or inventory:contains("2TK_models.2TK_Horse_02") or inventory:contains("2TK_models.2TK_Horse_03") or inventory:contains("2TK_models.2TK_Horse_04")
        or inventory:contains("2TK_models.2TK_Horse_SaddlebagS") or inventory:contains("2TK_models.2TK_Horse_01_SaddlebagS") or inventory:contains("2TK_models.2TK_Horse_02_SaddlebagS") or inventory:contains("2TK_models.2TK_Horse_03_SaddlebagS") or inventory:contains("2TK_models.2TK_Horse_04_SaddlebagS")
        or inventory:contains("2TK_models.2TK_Horse_SaddlebagM") or inventory:contains("2TK_models.2TK_Horse_01_SaddlebagM") or inventory:contains("2TK_models.2TK_Horse_02_SaddlebagM") or inventory:contains("2TK_models.2TK_Horse_03_SaddlebagM") or inventory:contains("2TK_models.2TK_Horse_04_SaddlebagM")
        or inventory:contains("2TK_models.2TK_Horse_SaddlebagL") or inventory:contains("2TK_models.2TK_Horse_01_SaddlebagL") or inventory:contains("2TK_models.2TK_Horse_02_SaddlebagL") or inventory:contains("2TK_models.2TK_Horse_03_SaddlebagL") or inventory:contains("2TK_models.2TK_Horse_04_SaddlebagL")
        or inventory:contains("2TK_models.2TK_Horse_SaddlebagSH") or inventory:contains("2TK_models.2TK_Horse_01_SaddlebagSH") or inventory:contains("2TK_models.2TK_Horse_02_SaddlebagSH") or inventory:contains("2TK_models.2TK_Horse_03_SaddlebagSH") or inventory:contains("2TK_models.2TK_Horse_04_SaddlebagSH")
        or inventory:contains("2TK_models.2TK_Horse_SaddlebagMH") or inventory:contains("2TK_models.2TK_Horse_01_SaddlebagMH") or inventory:contains("2TK_models.2TK_Horse_02_SaddlebagMH") or inventory:contains("2TK_models.2TK_Horse_03_SaddlebagMH") or inventory:contains("2TK_models.2TK_Horse_04_SaddlebagMH")
        or inventory:contains("2TK_models.2TK_Horse_SaddlebagLH") or inventory:contains("2TK_models.2TK_Horse_01_SaddlebagLH") or inventory:contains("2TK_models.2TK_Horse_02_SaddlebagLH") or inventory:contains("2TK_models.2TK_Horse_03_SaddlebagLH") or inventory:contains("2TK_models.2TK_Horse_04_SaddlebagLH") then
            if inventory:contains("2TK_models.2TK_Horse") then inventory:Remove("2TK_Horse")
            elseif inventory:contains("2TK_models.2TK_Horse_01") then inventory:Remove("2TK_Horse_01")
            elseif inventory:contains("2TK_models.2TK_Horse_02") then inventory:Remove("2TK_Horse_02")
            elseif inventory:contains("2TK_models.2TK_Horse_03") then inventory:Remove("2TK_Horse_03")
            elseif inventory:contains("2TK_models.2TK_Horse_04") then inventory:Remove("2TK_Horse_04")
            elseif inventory:contains("2TK_models.2TK_Horse_SaddlebagS") then inventory:Remove("2TK_Horse_SaddlebagS")
            elseif inventory:contains("2TK_models.2TK_Horse_01_SaddlebagS") then inventory:Remove("2TK_Horse_01_SaddlebagS")
            elseif inventory:contains("2TK_models.2TK_Horse_02_SaddlebagS") then inventory:Remove("2TK_Horse_02_SaddlebagS")
            elseif inventory:contains("2TK_models.2TK_Horse_03_SaddlebagS") then inventory:Remove("2TK_Horse_03_SaddlebagS")
            elseif inventory:contains("2TK_models.2TK_Horse_04_SaddlebagS") then inventory:Remove("2TK_Horse_04_SaddlebagS")
            elseif inventory:contains("2TK_models.2TK_Horse_SaddlebagM") then inventory:Remove("2TK_Horse_SaddlebagM")
            elseif inventory:contains("2TK_models.2TK_Horse_01_SaddlebagM") then inventory:Remove("2TK_Horse_01_SaddlebagM")
            elseif inventory:contains("2TK_models.2TK_Horse_02_SaddlebagM") then inventory:Remove("2TK_Horse_02_SaddlebagM")
            elseif inventory:contains("2TK_models.2TK_Horse_03_SaddlebagM") then inventory:Remove("2TK_Horse_03_SaddlebagM")
            elseif inventory:contains("2TK_models.2TK_Horse_04_SaddlebagM") then inventory:Remove("2TK_Horse_04_SaddlebagM")
            elseif inventory:contains("2TK_models.2TK_Horse_SaddlebagL") then inventory:Remove("2TK_Horse_SaddlebagL")
            elseif inventory:contains("2TK_models.2TK_Horse_01_SaddlebagL") then inventory:Remove("2TK_Horse_01_SaddlebagL")
            elseif inventory:contains("2TK_models.2TK_Horse_02_SaddlebagL") then inventory:Remove("2TK_Horse_02_SaddlebagL")
            elseif inventory:contains("2TK_models.2TK_Horse_03_SaddlebagL") then inventory:Remove("2TK_Horse_03_SaddlebagL")
            elseif inventory:contains("2TK_models.2TK_Horse_04_SaddlebagL") then inventory:Remove("2TK_Horse_04_SaddlebagL")
            elseif inventory:contains("2TK_models.2TK_Horse_SaddlebagSH") then inventory:Remove("2TK_Horse_SaddlebagSH")
            elseif inventory:contains("2TK_models.2TK_Horse_01_SaddlebagSH") then inventory:Remove("2TK_Horse_01_SaddlebagSH")
            elseif inventory:contains("2TK_models.2TK_Horse_02_SaddlebagSH") then inventory:Remove("2TK_Horse_02_SaddlebagSH")
            elseif inventory:contains("2TK_models.2TK_Horse_03_SaddlebagSH") then inventory:Remove("2TK_Horse_03_SaddlebagSH")
            elseif inventory:contains("2TK_models.2TK_Horse_04_SaddlebagSH") then inventory:Remove("2TK_Horse_04_SaddlebagSH")
            elseif inventory:contains("2TK_models.2TK_Horse_SaddlebagMH") then inventory:Remove("2TK_Horse_SaddlebagMH")
            elseif inventory:contains("2TK_models.2TK_Horse_01_SaddlebagMH") then inventory:Remove("2TK_Horse_01_SaddlebagMH")
            elseif inventory:contains("2TK_models.2TK_Horse_02_SaddlebagMH") then inventory:Remove("2TK_Horse_02_SaddlebagMH")
            elseif inventory:contains("2TK_models.2TK_Horse_03_SaddlebagMH") then inventory:Remove("2TK_Horse_03_SaddlebagMH")
            elseif inventory:contains("2TK_models.2TK_Horse_04_SaddlebagMH") then inventory:Remove("2TK_Horse_04_SaddlebagMH")
            elseif inventory:contains("2TK_models.2TK_Horse_SaddlebagLH") then inventory:Remove("2TK_Horse_SaddlebagLH")
            elseif inventory:contains("2TK_models.2TK_Horse_01_SaddlebagLH") then inventory:Remove("2TK_Horse_01_SaddlebagLH")
            elseif inventory:contains("2TK_models.2TK_Horse_02_SaddlebagLH") then inventory:Remove("2TK_Horse_02_SaddlebagLH")
            elseif inventory:contains("2TK_models.2TK_Horse_03_SaddlebagLH") then inventory:Remove("2TK_Horse_03_SaddlebagLH")
            elseif inventory:contains("2TK_models.2TK_Horse_04_SaddlebagLH") then inventory:Remove("2TK_Horse_04_SaddlebagLH")
            end
            local square = player:getSquare()
            local x = square:getX()
            local y = square:getY()
            local z = square:getZ()
            print(x)

            if data.equipment and data.equipment.saddle then
                local droppedSaddle = InventoryItemFactory.CreateItem(data.equipment.saddle)
                if droppedSaddle then
                    droppedSaddle:getModData().saddleWear = data.equipment.saddleWear or 0
                    square:AddWorldInventoryItem(droppedSaddle, 0, 0, 0)
                end
                data.equipment.saddle = nil
                data.equipment.saddleWear = 0
            end

            if data.equipment and data.equipment.head then
                local droppedHead = InventoryItemFactory.CreateItem(data.equipment.head)
                if droppedHead then
                    droppedHead:getModData().headWear = data.equipment.headWear or 0
                    square:AddWorldInventoryItem(droppedHead, 0, 0, 0)
                end
                data.equipment.head = nil
                data.equipment.headWear = 0
            end

            local bagInv = horse:getInventory()
            if bagInv then
                local containedItems = bagInv:getItems()
                for bi = containedItems:size() - 1, 0, -1 do
                    local contained = containedItems:get(bi)
                    if contained then
                        square:AddWorldInventoryItem(contained, 0, 0, 0)
                    end
                end
            end

            if data.equipment and data.equipment.back then
                local droppedBag = InventoryItemFactory.CreateItem(data.equipment.back)
                if droppedBag then
                    droppedBag:getModData().backWear = data.equipment.backWear or 0
                    square:AddWorldInventoryItem(droppedBag, 0, 0, 0)
                end
                data.equipment.back = nil
                data.equipment.backWear = 0
            end

            if data.equipment and data.equipment.hoof then
                local droppedHoof = InventoryItemFactory.CreateItem(data.equipment.hoof)
                if droppedHoof then
                    droppedHoof:getModData().hoofWear = data.equipment.hoofWear or 0
                    square:AddWorldInventoryItem(droppedHoof, 0, 0, 0)
                end
                data.equipment.hoof = nil
                data.equipment.hoofWear = 0
            end

            if data.equipment and data.equipment.mouth then
                local mouthType = data.equipment.mouth
                local mouthInfo = HORSE_MOUTH_TYPES[mouthType] or { fillType = "food" }
                local droppedMouth = InventoryItemFactory.CreateItem(mouthType)
                if droppedMouth then
                    droppedMouth:getModData().mouthWear = data.equipment.mouthWear or 0
                    if mouthInfo.fillType == "food" then
                        droppedMouth:getModData().mouthFill = data.equipment.mouthFill or 0
                    elseif mouthInfo.fillType == "water" and droppedMouth.setUsedDelta then
                        droppedMouth:setUsedDelta((data.equipment.mouthFill or 0) / 100)
                    end
                    square:AddWorldInventoryItem(droppedMouth, 0, 0, 0)
                end
                data.equipment.mouth = nil
                data.equipment.mouthWear = 0
                data.equipment.mouthFill = 0
            end

            local c = InventoryItemFactory.CreateItem("2TK_models.2TK_Horse_Carcass")
	        c:setAge(0)
            square:AddWorldInventoryItem(c, 0,0,0)

            writeHorseFile(player, item, "death")
            player:setWornItem("Horse", nil, false)
            triggerEvent("OnClothingUpdated", player)
            ISInventoryPage.renderDirty = true
            player:getInventory():setDrawDirty(true)
        end
    end

if data.stamina > 15 and data._exhaustedDebuff then
    SpeedFramework.SetPlayerSpeed(player, nil)
    data._exhaustedDebuff = false
    data._exhaustedPhase = nil
    data._exhaustedStartTime = nil
    player:setBlockMovement(false)
end

    if (isRunning or isSprinting) and (not hasSaddle or saddleType == "Animals.RacingSaddle") then
        local currentEndurance = stats:getEndurance()
        stats:setEndurance(math.max(0, currentEndurance - 0.0025))
    end

    local hasMouth = data.equipment.mouth and (data.equipment.mouthWear or 0) > 0 and (data.equipment.mouthFill or 0) > 0
    local mouthInfo = hasMouth and HORSE_MOUTH_TYPES[data.equipment.mouth] or nil
    local hungerDrainMult = getTemperamentMult(data, "hungerDrainMult")
    local thirstDrainMult = getTemperamentMult(data, "thirstDrainMult")
    if hasMouth and mouthInfo then
        if mouthInfo.fillType == "food" then
            hungerDrainMult = hungerDrainMult * 0.5
            data.equipment.mouthFill = math.max(0, data.equipment.mouthFill - (0.15 * delta))
        elseif mouthInfo.fillType == "water" then
            thirstDrainMult = thirstDrainMult * 0.5
            data.equipment.mouthFill = math.max(0, data.equipment.mouthFill - (0.2 * delta))
        end
    end

    if isSprinting and not data._exhaustedDebuff then
        data.hunger = math.max(0, data.hunger - (0.2 * hungerDrainMult * delta))
        data.thirst = math.max(0, data.thirst - (0.333 * thirstDrainMult * delta))
    elseif isRunning and not data._exhaustedDebuff then
        data.hunger = math.max(0, data.hunger - (0.133 * hungerDrainMult * delta))
        data.thirst = math.max(0, data.thirst - (0.2 * thirstDrainMult * delta))
    elseif isMoving then
        data.hunger = math.max(0, data.hunger - (0.013 * hungerDrainMult * delta))
        data.thirst = math.max(0, data.thirst - (0.033 * thirstDrainMult * delta))
    end

    if data.hunger >= 300 and data.thirst >= 300 and not isMoving then
        local regenMult = getTemperamentMult(data, "regenMult")
        data.health = math.min(data.maxHealth, math.max(0, data.health + (0.5 * regenMult * delta)))
    end

    if data.hunger <= 0 or data.thirst <= 0 and isMoving then
        data.health = math.max(0, data.health - (0.5 * delta))
    end

    local staminaDrainMult = getTemperamentMult(data, "stamDrainMult")
    if not hasSaddle then
        staminaDrainMult = staminaDrainMult * 1.15
    elseif saddleType == "Animals.RoadtripSaddle" then
        staminaDrainMult = staminaDrainMult * 0.8
    end

    if isSprinting and not data._exhaustedDebuff then
        data.stamina = math.max(0, data.stamina - (25 * staminaDrainMult * delta))
    elseif isRunning and not data._exhaustedDebuff then
        data.stamina = math.max(0, data.stamina - (5 * staminaDrainMult * delta))
    elseif data._exhaustedDebuff or not isSprinting and not isRunning and not isMoving then
        data.stamina = math.min(data.maxStamina, data.stamina + (15 * delta))
    else
        data.stamina = math.min(data.maxStamina, data.stamina + (5 * delta))
    end

local stepInterval = 500
local variants = nil
local soundRadius = 5
local soundVolume = 5

if isSprinting and not data._exhaustedDebuff then
    stepInterval = 400
    variants = { "horse_run_01", "horse_run_02", "horse_run_03", "horse_run_04" }
    soundRadius = 22
    soundVolume = 16
elseif isRunning and not data._exhaustedDebuff then
    stepInterval = 500
    variants = { "horse_run_01", "horse_run_02", "horse_run_03", "horse_run_04" }
    soundRadius = 14
    soundVolume = 10
elseif not isRunning and not isSprinting and isMoving then
    stepInterval = 500
    variants = { "horse_walk_01", "horse_walk_02", "horse_walk_03" }
    soundRadius = 6
    soundVolume = 4
elseif data._exhaustedDebuff and isMoving then
    stepInterval = 500
    variants = nil
end

local hoofInfo = data.equipment.hoof and HORSE_HOOF_TYPES[data.equipment.hoof] or nil
if hoofInfo and hoofInfo.stealth and (data.equipment.hoofWear or 0) > 0 then
    soundRadius = math.floor(soundRadius * 0.35)
    soundVolume = math.floor(soundVolume * 0.35)
end

local hoofstepMult = getTemperamentMult(data, "hoofstepMult")
if hoofstepMult ~= 1.0 then
    soundRadius = math.floor(soundRadius * hoofstepMult)
    soundVolume = math.floor(soundVolume * hoofstepMult)
end

if variants and  now - lastHorseStepTime >= stepInterval then
    lastHorseStepTime = now



      local sound = variants[ZombRand(#variants) + 1]
    if not player:isInvisible() and not player:isGhostMode() then
        if isClient() and sound then
            getSoundManager():PlayWorldSound(sound, player:getSquare(), 0, soundRadius, soundVolume, false);
        else
            getSoundManager():playUISound(tostring(sound))
        end
    end
end
    if lastHorseUpdateTime == 0 then
        lastHorseUpdateTime = now
        return
    end



    local ACCELERATION_RATE = 1 * getTemperamentMult(data, "accelMult")
    local DECELERATION_RATE = 0.7


    local speedMult = 1.2
    if not hasSaddle then
        speedMult = 0.9
    elseif saddleType == "Animals.RacingSaddle" then
        speedMult = 1.45
    end

    local hasHoof = data.equipment.hoof and (data.equipment.hoofWear or 0) > 0
    if not hasHoof then
        speedMult = speedMult * 0.9
    end

    if data.temperament == "Loyal" and data._loyalBurstEnd and getTimestampMs() < data._loyalBurstEnd then
        speedMult = speedMult * 1.20
    end

    local lazyBlockSprint = data.temperament == "Lazy" and (data.stamina or 0) < (data.maxStamina or 300) * 0.3

    if data.temperament == "Wild" and isSprinting then
        local throwChance = HORSE_TEMPERAMENTS.Wild.throwChance or 0.005
        if ZombRandFloat(0, 1) < throwChance then
            data.fear = 100
            data._fearEffect = "dismount"
        end
    end

        if isSprinting and not lazyBlockSprint then
            data.maxHorseSpeed = 1.5 * data.speedModifier * speedMult
        elseif isRunning then
            data.maxHorseSpeed = 1.3 * data.speedModifier * speedMult
        elseif data._exhaustedDebuff then
            data.maxHorseSpeed = 0.0
        else
            data.maxHorseSpeed = 1.15 * speedMult
        end

    if isMoving then
        data.horseSpeed = math.min(data.maxHorseSpeed, data.horseSpeed + (ACCELERATION_RATE * delta))
    elseif data._exhaustedDebuff then
        data.horseSpeed = 0.0
    else
        data.horseSpeed = math.max(0.0, data.horseSpeed - (DECELERATION_RATE * delta))
    end

    if data.horseSpeed > 0.01 and not data._exhaustedDebuff then
        SpeedFramework.SetPlayerSpeed(player, data.horseSpeed)
    elseif not data._exhaustedDebuff then
        SpeedFramework.SetPlayerSpeed(player, nil)
    end



local isPressingMovement =
    isKeyDown(Keyboard.KEY_W) or
    isKeyDown(Keyboard.KEY_A) or
    isKeyDown(Keyboard.KEY_S) or
    isKeyDown(Keyboard.KEY_D)

if not isPressingMovement and data.horseSpeed > 0.5 and data.stamina <= 5 and not data._exhaustedDebuff  then
    player:setBlockMovement(true)
    local elapsed = getTimestampMs() - (data._exhaustedStartTime or 0)
    if elapsed >= 3000 then
        player:setBlockMovement(false)
    end
end

data.stamina = math.max(0, data.stamina)
data.hunger = math.max(0, data.hunger)
data.thirst = math.max(0, data.thirst)
data.health = math.max(0, data.health)
data.fear = math.max(0, math.min(100, data.fear or 0))

end

Events.OnTick.Add(updateHorseStatsTick)

local function onLoyalHorseDamage(player, damageType, damage)
    if not player then return end
    local horse = player:getWornItem("Horse")
    if not horse then return end
    local data = horse:getModData()
    if data.temperament == "Loyal" then
        data._loyalBurstEnd = getTimestampMs() + 5000
    end
end
Events.OnPlayerGetDamage.Add(onLoyalHorseDamage)


function isHorseGhost(item, player)
    if not item then return true end
    local wi = item:getWorldItem()
    if not wi then return true end
    local sq = wi:getSquare()
    if not sq then return true end
    local wios = sq:getWorldObjects()
    for i = 0, wios:size() - 1 do
        if wios:get(i) == wi then
            return false
        end
    end
    return true
end

function checkHorseGhost(item, player)
    if isHorseGhost(item, player) then
        if player then player:Say("Please move a tile and try again.") end
        return true
    end
    return false
end


function doMount(item, player)
    if checkHorseGhost(item, player) then return end
    assignHorseGUID(item, player)
    local data = item:getModData()
    local guid = data.horseGUID or "NO_GUID"

    if data.temperament == "Rascal" then
        local refuseChance = HORSE_TEMPERAMENTS.Rascal.refuseMountChance or 0.003
        if ZombRandFloat(0, 1) < refuseChance then
            player:Say("The horse walks away from me...")
            return
        end
    end

    localtext = player:getUsername() .. " has mounted a horse with name " .. item:getName() .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, item, "mount")
    ISTimedActionQueue.add(HorseMount:new(player, item, true))

end


function doDismount(item, player)
    assignHorseGUID(item, player)
    local data = item:getModData()
    local guid = data.horseGUID or "NO_GUID"
    localtext = player:getUsername() .. " has dismounted a horse with name " .. item:getName() .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, item, "dismount")

    local sq = player:getSquare()
    local x, y, z = player:getX() - math.floor(sq:getX()), player:getY() - math.floor(sq:getY()), player:getZ() - math.floor(sq:getZ())
    local rot = player:getDirectionAngle() + 180
    if rot > 360 then
        rot = rot - 360
    end
    ISTimedActionQueue.add(HorseMount:new(player, item, false, sq, x, y, z, rot))
    SpeedFramework.SetPlayerSpeed(player, nil)
end


function forceDismount(player, horse)
    player:setBlockMovement(true)
    local sq = player:getSquare()
    if not sq then return end
    local x = player:getX() - math.floor(sq:getX())
    local y = player:getY() - math.floor(sq:getY())
    local z = player:getZ() - math.floor(sq:getZ())
    local rot = player:getDirectionAngle() + 180
    if rot > 360 then rot = rot - 360 end

    horse:setWeight(60)
    horse:setActualWeight(60)
    horse:setCustomWeight(false)

    local worldItem = sq:AddWorldInventoryItem(horse, x, y, z, false)
    if worldItem then
        worldItem:setWorldZRotation(rot)
        worldItem:getWorldItem():setIgnoreRemoveSandbox(true)
        worldItem:getWorldItem():transmitCompleteItemToServer()
    end

    player:getInventory():Remove(horse)
    player:setWornItem("Horse", nil, false)
    SpeedFramework.SetPlayerSpeed(player, nil)
    triggerEvent("OnClothingUpdated", player)
    ISInventoryPage.renderDirty = true
    player:getInventory():setDrawDirty(true)


    player:getBodyDamage():getBodyPart(BodyPartType.Torso_Upper):setAdditionalPain(50.0)

    local hurtSound = player:isFemale() and "FemaleHurt01" or "MaleHurt01"
    player:getEmitter():playSound(hurtSound)

    local fallStart = getTimestampMs()
    local phase = "fall"
    player:playEmote("TaseFall")

    local function throwAnimationTick()
        local elapsed = getTimestampMs() - fallStart
        if phase == "fall" and elapsed >= 500 then
            phase = "down"
            player:playEmote("TaseDown")
        elseif phase == "down" and elapsed >= 1500 then
            phase = "waiting"
            player:playEmote("TaseGetUp")
        elseif phase == "waiting" and elapsed >= 2500 then
            player:setBlockMovement(false)
            player:playEmote("")
            Events.OnTick.Remove(throwAnimationTick)
        end
    end
    Events.OnTick.Add(throwAnimationTick)

    assignHorseGUID(horse, player)
    local data = horse:getModData()
    local guid = data.horseGUID or "NO_GUID"
    localtext = player:getUsername() .. " was thrown from horse " .. horse:getName() .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(player:getX()) .. " " .. math.floor(player:getY()) .. " " .. math.floor(player:getZ()) .. " "
    sendClientCommand(player, 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
end


function cleanMenu(playerID, context, items)
    items = ISInventoryPane.getActualItems(items)
    local isHorse = false
    for i = 1, #items do
        local item = items[i]
        if HORSE_ITEM_TYPES[item:getFullType()] then
            isHorse = true
            break
        end
    end
    if not isHorse then
        return
    end
    local toRemove = {}
    for i = 1, #context.options do
        local option = context.options[i]
        if option.onSelect == ISInventoryPaneContextMenu.onWearItems
        or option.onSelect == ISInventoryPaneContextMenu.wearItem
        or option.onSelect == ISInventoryPaneContextMenu.onUnEquip
        or option.onSelect == ISInventoryPaneContextMenu.onDropItems
        or option.onSelect == ISInventoryPaneContextMenu.onGrabItems then
            table.insert(toRemove, option.name)
        end
    end
    for i = 1, #toRemove do
        local name = toRemove[i]
        context:removeOptionByName(name)
    end
end

Events.OnFillInventoryObjectContextMenu.Add(cleanMenu)

function checkWater(player)
    local playerX = math.floor(player:getX())
    local playerY = math.floor(player:getY())
    local playerZ = player:getZ()

    for x = playerX - 1, playerX + 1 do
        for y = playerY - 1, playerY + 1 do
            local square = getCell():getGridSquare(x, y, playerZ)
            if square and square:Is(IsoFlagType.water) then
                return true, x, y, playerZ
            end
        end
    end

    return false, nil, nil, nil
end

function onDrinkGroundWater(player, horse, X, Y, Z)
    if checkHorseGhost(horse, player) then return end
    ISTimedActionQueue.add(DrinkWaterGround:new(player, horse, X, Y, Z))
end

function onFeedHorse(player, horse, food)
    if checkHorseGhost(horse, player) then return end
        ISTimedActionQueue.add(HorseFeed:new(player, horse, food))
end


function modifyModData(player, item, data)
    local md = item:getModData() or {}
    for k, v in pairs(data) do
        md[k] = v
    end
    local wi = item:getWorldItem()
    if not wi or not wi:getSquare() then
        return
    end
    local square = wi:getSquare()
    local x, y, z = math.floor(square:getX()), math.floor(square:getY()), math.floor(square:getZ())
    local args = {
        x = x,
        y = y,
        z = z,
        id = item:getID(),
        data = data
    }
    sendClientCommand("DeadlineHorse", "RequestSyncHorseData", args)
end


function sanitizeHorseFileName(name)
    if not name then return "unknown" end
    local clean = tostring(name):gsub("[^%w_%-]", "_")
    if clean == "" then clean = "unknown" end
    return clean
end

function buildHorseFileName(owner, horseName, fileUID)
    return sanitizeHorseFileName(owner) .. "_" .. sanitizeHorseFileName(horseName) .. "_" .. tostring(fileUID or "nouid") .. ".txt"
end

function serializeHorseData(player, item, action)
    local data = item:getModData()
    local lines = {}
    local ts = os.date("%Y-%m-%d %H:%M:%S")
    table.insert(lines, "lastUpdate=" .. tostring(ts))
    table.insert(lines, "lastAction=" .. tostring(action or "unknown"))
    table.insert(lines, "lastActor=" .. tostring(player and player:getUsername() or "unknown"))
    table.insert(lines, "fileUID=" .. tostring(data.fileUID or ""))
    table.insert(lines, "owner=" .. tostring(data.owner or ""))
    table.insert(lines, "name=" .. tostring(item:getName() or ""))
    table.insert(lines, "guid=" .. tostring(data.horseGUID or ""))
    table.insert(lines, "itemType=" .. tostring(item:getFullType() or ""))
    table.insert(lines, "temperament=" .. tostring(data.temperament or ""))
    table.insert(lines, "health=" .. tostring(data.health or 0))
    table.insert(lines, "maxHealth=" .. tostring(data.maxHealth or 0))
    table.insert(lines, "stamina=" .. tostring(data.stamina or 0))
    table.insert(lines, "maxStamina=" .. tostring(data.maxStamina or 0))
    table.insert(lines, "hunger=" .. tostring(data.hunger or 0))
    table.insert(lines, "thirst=" .. tostring(data.thirst or 0))
    table.insert(lines, "fear=" .. tostring(data.fear or 0))
    table.insert(lines, "speedModifier=" .. tostring(data.speedModifier or 0))
    table.insert(lines, "description=" .. tostring(data.description or ""))
    local eq = data.equipment or {}
    table.insert(lines, "saddle=" .. tostring(eq.saddle or ""))
    table.insert(lines, "saddleWear=" .. tostring(eq.saddleWear or 0))
    table.insert(lines, "head=" .. tostring(eq.head or ""))
    table.insert(lines, "headWear=" .. tostring(eq.headWear or 0))
    table.insert(lines, "back=" .. tostring(eq.back or ""))
    table.insert(lines, "backWear=" .. tostring(eq.backWear or 0))
    table.insert(lines, "hoof=" .. tostring(eq.hoof or ""))
    table.insert(lines, "hoofWear=" .. tostring(eq.hoofWear or 0))
    table.insert(lines, "mouth=" .. tostring(eq.mouth or ""))
    table.insert(lines, "mouthWear=" .. tostring(eq.mouthWear or 0))
    table.insert(lines, "mouthFill=" .. tostring(eq.mouthFill or 0))
    if player then
        table.insert(lines, "coordX=" .. math.floor(player:getX()))
        table.insert(lines, "coordY=" .. math.floor(player:getY()))
        table.insert(lines, "coordZ=" .. math.floor(player:getZ()))
    end
    return table.concat(lines, "\n")
end

function ensureHorseFileUID(item)
    local data = item:getModData()
    if not data.fileUID then
        data.fileUID = tostring(getTimestampMs()) .. "_" .. tostring(ZombRand(1000000))
    end
    return data.fileUID
end

function writeHorseFile(player, item, action)
    if not player or not item then return end
    local data = item:getModData()
    if not data.owner then return end
    ensureHorseFileUID(item)
    local filename = buildHorseFileName(data.owner, item:getName(), data.fileUID)
    local content = serializeHorseData(player, item, action)
    sendClientCommand(player, 'HorseFileSystem', 'writeHorseFile', { filename = filename, content = content })
    data._lastHorseFileName = filename
end

function deleteHorseFile(player, item)
    if not player or not item then return end
    local data = item:getModData()
    local filename = data._lastHorseFileName
    if not filename then
        if not data.fileUID then return end
        filename = buildHorseFileName(data.owner or "unknown", item:getName(), data.fileUID)
    end
    local content = "DELETED\n" .. serializeHorseData(player, item, "unclaim")
    sendClientCommand(player, 'HorseFileSystem', 'writeHorseFile', { filename = filename, content = content })
end

function renameHorseFile(player, item, oldOwner, oldName)
    if not player or not item then return end
    local data = item:getModData()
    if not data.fileUID then return end
    local oldFilename = buildHorseFileName(oldOwner or data.owner or "unknown", oldName or item:getName(), data.fileUID)
    local deleteContent = "DELETED\n" .. serializeHorseData(player, item, "rename_old")
    sendClientCommand(player, 'HorseFileSystem', 'writeHorseFile', { filename = oldFilename, content = deleteContent })
    writeHorseFile(player, item, "rename_new")
end


function getHunger(modData)
    local hunger = modData["hunger"] or 0

    if hunger > 300 then
        hunger = 300
    end

    return hunger
end

function getThirst(modData)
    local thirst = modData["thirst"] or 0

    if thirst > 300 then
        thirst = 300
    end

    return thirst
end


function claimHorse(player, item)
    if checkHorseGhost(item, player) then return end
    assignHorseGUID(item, player)
    local data = item:getModData()
    local guid = data.horseGUID or "NO_GUID"
    player:Say("Horse claimed.")
    localtext = player:getUsername() .. " has claimed a horse with name " .. item:getName() .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    data.fileUID = tostring(getTimestampMs()) .. "_" .. tostring(ZombRand(1000000))
    data.owner = player:getUsername()
    modifyModData(player, item, {
        owner = player:getUsername(),
        riders = {},
        fileUID = data.fileUID,
    })
    writeHorseFile(player, item, "claim")
end

function unclaimHorse(player, item)
    if checkHorseGhost(item, player) then return end
    assignHorseGUID(item, player)
    local data = item:getModData()
    local guid = data.horseGUID or "NO_GUID"
    player:Say("Horse unclaimed")
    localtext = player:getUsername() .. " has unclaimed a horse with name " .. item:getName() .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    deleteHorseFile(player, item)
    modifyModData(player, item, {
        owner = "THEREISNOCLAIMANT",
        riders = {},
        fileUID = nil,
        _lastHorseFileName = nil,
    })
end

function unclaimHorseAdmin(player, item)
    if checkHorseGhost(item, player) then return end
    assignHorseGUID(item, player)
    local data = item:getModData()
    local guid = data.horseGUID or "NO_GUID"
    localtext = player:getUsername() .. " has admin unclaimed a horse with name " .. item:getName() .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    deleteHorseFile(player, item)
    modifyModData(player, item, {
        owner = "THEREISNOCLAIMANT",
        riders = {},
        fileUID = nil,
        _lastHorseFileName = nil,
    })
end


function reassureHorse(player, item)
    if checkHorseGhost(item, player) then return end
    print(item)
    if not item then return end
    local data = item:getModData()

    if not data._initialized then
        data.health = ZombRand(300, 401)
        data.maxHealth = data.health
        data.speedModifier = ZombRandFloat(1.2, 1.7)
        data.horseSpeed = data.horseSpeed or 0.0
        data._coastTime = data._coastTime or 0
        data._coastDir = data._coastDir or nil
        data.maxHorseSpeed = 0
        data.hunger = 300
        data.maxHunger = 300
        data.thirst = 300
        data.maxThirst = 300
        data.stamina = 300
        data.maxStamina = 300
        data.owner = ""
        data.riders = {}
        data.oldName = ""
        data.description = ""
        data.equipment = data.equipment or {}
        data.equipment.saddle = nil
        data.equipment.saddleWear = 0
        data.equipment.head = nil
        data.equipment.headWear = 0
        data.equipment.back = nil
        data.equipment.backWear = 0
        data.fear = 0
        data._lastTileX = nil
        data._lastTileY = nil
        data._lastFearCheck = 0

        data._initialized = true


    end
end


function renameHorse(player, item)
    if checkHorseGhost(item, player) then return end
    assignHorseGUID(item, player)
    local data = item:getModData()
    local guid = data.horseGUID or "NO_GUID"
    local prompt = "Enter a new name for your horse:"
    local defaultName = item:getName()
    local md = item:getModData()
    modifyModData(player, item, {
        oldName = item:getName(),
    })

    local function onRename(target, button)
        if button.internal ~= "OK" then
            return
        end

        local newName = button.target.entry:getText()
        if newName and newName ~= "" then
            local oldName = md.oldName
            item:setName(newName)
            player:Say("You have renamed your horse to " .. newName)
            localtext = player:getUsername() .. " has renamed a horse from " .. md.oldName .. " to " .. newName .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
            sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
            renameHorseFile(player, item, data.owner, oldName)
        end
    end

    local modal = ISTextBox:new(
        0, 0, 280, 180,
        prompt,
        defaultName,
        nil,
        onRename,
        player:getPlayerNum()
    )
    modal:initialise()
    modal:addToUIManager()
    item:setCustomName(true)

end


function setHorseDescription(player, item)
    if checkHorseGhost(item, player) then return end
    assignHorseGUID(item, player)
    local data = item:getModData()
    local guid = data.horseGUID or "NO_GUID"
    local prompt = "Enter a description for your horse (max 50 characters):"
    local defaultText = data.description or ""

    local function onSetDescription(target, button)
        if button.internal ~= "OK" then return end
        local text = button.target.entry:getText()
        if text and text ~= "" then
            text = string.sub(text, 1, 50)
            modifyModData(player, item, {
                description = text,
            })
            localtext = player:getUsername() .. " has set description on horse " .. item:getName() .. " to \"" .. text .. "\" [GUID: " .. guid .. "] at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
            sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
        end
    end

    local modal = ISTextBox:new(
        0, 0, 280, 180,
        prompt,
        defaultText,
        nil,
        onSetDescription,
        player:getPlayerNum()
    )
    modal:initialise()
    modal:addToUIManager()
end

function clearHorseDescription(player, item)
    if checkHorseGhost(item, player) then return end
    assignHorseGUID(item, player)
    local data = item:getModData()
    local guid = data.horseGUID or "NO_GUID"
    modifyModData(player, item, {
        description = "",
    })
    localtext = player:getUsername() .. " has cleared description on horse " .. item:getName() .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
end


function getSaddleTooltip(saddleType)
    if saddleType == "Animals.Saddle" then
        return "Standard saddle. No bonuses or penalties."
    elseif saddleType == "Animals.RacingSaddle" then
        return "Racing saddle. +25% horse speed, but drains rider stamina."
    elseif saddleType == "Animals.RoadtripSaddle" then
        return "Roadtrip saddle. Reduces horse stamina drain by 20%."
    end
    return "Unknown saddle."
end


function equipSaddleOnHorse(player, horse, saddleItem)
    if checkHorseGhost(horse, player) then return end
    assignHorseGUID(horse, player)
    local data = horse:getModData()
    local guid = data.horseGUID or "NO_GUID"

    if not data.equipment then
        data.equipment = {}
    end

    if data.equipment.saddle then return end

    local saddleType = saddleItem:getFullType()
    local saddleWear = saddleItem:getModData().saddleWear or 100

    data.equipment.saddle = saddleType
    data.equipment.saddleWear = saddleWear

    player:getInventory():DoRemoveItem(saddleItem)

    modifyModData(player, horse, {
        equipment = data.equipment,
    })

    local saddleName = HORSE_SADDLE_TYPES[saddleType] or "Unknown Saddle"
    localtext = player:getUsername() .. " has equipped " .. saddleName .. " (" .. math.floor(saddleWear) .. "%) on horse " .. horse:getName() .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, horse, "equip_saddle")
end


function unequipSaddleFromHorse(player, horse)
    if checkHorseGhost(horse, player) then return end
    assignHorseGUID(horse, player)
    local data = horse:getModData()
    local guid = data.horseGUID or "NO_GUID"

    if not data.equipment or not data.equipment.saddle then return end

    local saddleType = data.equipment.saddle
    local saddleWear = data.equipment.saddleWear or 0
    local saddleName = HORSE_SADDLE_TYPES[saddleType] or "Unknown Saddle"

    local saddleItem = InventoryItemFactory.CreateItem(saddleType)
    if saddleItem then
        saddleItem:getModData().saddleWear = saddleWear
        player:getInventory():AddItem(saddleItem)
    end

    data.equipment.saddle = nil
    data.equipment.saddleWear = 0

    modifyModData(player, horse, {
        equipment = data.equipment,
    })

    localtext = player:getUsername() .. " has unequipped " .. saddleName .. " (" .. math.floor(saddleWear) .. "%) from horse " .. horse:getName() .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, horse, "unequip_saddle")
end


function getHeadTooltip(headType)
    if headType == "Animals.Blinder" then
        return "Blinders. Reduces horse vision cone, lowering fear buildup."
    end
    return "Unknown head equipment."
end


function equipHeadOnHorse(player, horse, headItem)
    if checkHorseGhost(horse, player) then return end
    assignHorseGUID(horse, player)
    local data = horse:getModData()
    local guid = data.horseGUID or "NO_GUID"

    if not data.equipment then
        data.equipment = {}
    end

    if data.equipment.head then return end

    local headType = headItem:getFullType()
    local headWear = headItem:getModData().headWear or 100

    data.equipment.head = headType
    data.equipment.headWear = headWear

    player:getInventory():DoRemoveItem(headItem)

    modifyModData(player, horse, {
        equipment = data.equipment,
    })

    local headName = HORSE_HEAD_TYPES[headType] or "Unknown"
    localtext = player:getUsername() .. " has equipped " .. headName .. " (" .. math.floor(headWear) .. "%) on horse " .. horse:getName() .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, horse, "equip_head")
end


function unequipHeadFromHorse(player, horse)
    if checkHorseGhost(horse, player) then return end
    assignHorseGUID(horse, player)
    local data = horse:getModData()
    local guid = data.horseGUID or "NO_GUID"

    if not data.equipment or not data.equipment.head then return end

    local headType = data.equipment.head
    local headWear = data.equipment.headWear or 0
    local headName = HORSE_HEAD_TYPES[headType] or "Unknown"

    local headItem = InventoryItemFactory.CreateItem(headType)
    if headItem then
        headItem:getModData().headWear = headWear
        player:getInventory():AddItem(headItem)
    end

    data.equipment.head = nil
    data.equipment.headWear = 0

    modifyModData(player, horse, {
        equipment = data.equipment,
    })

    localtext = player:getUsername() .. " has unequipped " .. headName .. " (" .. math.floor(headWear) .. "%) from horse " .. horse:getName() .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, horse, "unequip_head")
end


function getBackTooltip(bagType)
    local info = HORSE_BACK_TYPES[bagType]
    if not info then return "Unknown back equipment." end
    if info.size == "S" then return "Small saddlebag. +10 carry capacity."
    elseif info.size == "M" then return "Medium saddlebag. +15 carry capacity."
    elseif info.size == "L" then return "Large saddlebag. +20 carry capacity." end
    return "Saddlebag."
end


function swapHorseVariant(player, oldHorse, newType)
    local oldData = oldHorse:getModData()
    local oldName = oldHorse:getName()
    local wi = oldHorse:getWorldItem()
    if not wi then return nil end
    local sq = wi:getSquare()
    if not sq then return nil end

    local xoff = wi:getWorldPosX() - sq:getX()
    local yoff = wi:getWorldPosY() - sq:getY()
    local zoff = wi:getWorldPosZ() - sq:getZ()
    local rot = 0

    local newHorse = InventoryItemFactory.CreateItem(newType)
    if not newHorse then return nil end

    local newData = newHorse:getModData()
    for k, v in pairs(oldData) do newData[k] = v end
    if oldName then
        newHorse:setName(oldName)
        newHorse:setCustomName(true)
    end

    sq:transmitRemoveItemFromSquare(wi)
    sq:removeWorldObject(wi)

    local newWi = sq:AddWorldInventoryItem(newHorse, xoff, yoff, zoff, false)
    if newWi then
        newWi:setWorldZRotation(rot)
        newWi:getWorldItem():setIgnoreRemoveSandbox(true)
        newWi:getWorldItem():transmitCompleteItemToServer()
    end

    return newHorse
end


function equipSaddlebagOnHorse(player, horse, bagItem)
    if checkHorseGhost(horse, player) then return end
    assignHorseGUID(horse, player)
    local data = horse:getModData()
    local guid = data.horseGUID or "NO_GUID"
    if data.equipment and data.equipment.back then return end

    local bagType = bagItem:getFullType()
    local bagInfo = HORSE_BACK_TYPES[bagType]
    if not bagInfo then return end

    local variantTable = (data.temperament == "Workhorse") and HORSE_SADDLEBAG_VARIANTS_WORKHORSE or HORSE_SADDLEBAG_VARIANTS
    local variants = variantTable[horse:getFullType()]
    if not variants then return end
    local newType = variants[bagInfo.size]
    if not newType then return end

    local bagWear = bagItem:getModData().backWear or 100
    data.equipment.back = bagType
    data.equipment.backWear = bagWear

    player:getInventory():DoRemoveItem(bagItem)

    local horseName = horse:getName()
    local newHorse = swapHorseVariant(player, horse, newType)
    if newHorse then
        modifyModData(player, newHorse, { equipment = newHorse:getModData().equipment })
    end

    localtext = player:getUsername() .. " has equipped " .. bagInfo.name .. " (" .. math.floor(bagWear) .. "%) on horse " .. horseName .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, horse, "equip_saddlebag")
end


function unequipSaddlebagFromHorse(player, horse)
    if checkHorseGhost(horse, player) then return end
    assignHorseGUID(horse, player)
    local data = horse:getModData()
    local guid = data.horseGUID or "NO_GUID"
    if not data.equipment or not data.equipment.back then return end

    local bagInv = horse:getInventory()
    if bagInv and bagInv:getItems():size() > 0 then
        player:Say("The saddlebag must be empty first.")
        return
    end

    local bagType = data.equipment.back
    local bagWear = data.equipment.backWear or 0
    local bagInfo = HORSE_BACK_TYPES[bagType] or { name = "Unknown" }

    local baseType = HORSE_SADDLEBAG_REVERSE[horse:getFullType()]
    if not baseType then return end

    local bagItem = InventoryItemFactory.CreateItem(bagType)
    if bagItem then
        bagItem:getModData().backWear = bagWear
        player:getInventory():AddItem(bagItem)
    end

    data.equipment.back = nil
    data.equipment.backWear = 0

    local horseName = horse:getName()
    local newHorse = swapHorseVariant(player, horse, baseType)
    if newHorse then
        modifyModData(player, newHorse, { equipment = newHorse:getModData().equipment })
    end

    localtext = player:getUsername() .. " has unequipped " .. bagInfo.name .. " (" .. math.floor(bagWear) .. "%) from horse " .. horseName .. " [GUID: " .. guid .. "] at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, horse, "unequip_saddlebag")
end


function equipBardingOnHorse(player, horse, bardingItem)
    if checkHorseGhost(horse, player) then return end
    assignHorseGUID(horse, player)
    local data = horse:getModData()
    local guid = data.horseGUID or "NO_GUID"
    if data.equipment and data.equipment.back then return end
    local wear = bardingItem:getModData().backWear or 100
    data.equipment.back = "Animals.Barding"
    data.equipment.backWear = wear
    player:getInventory():DoRemoveItem(bardingItem)
    modifyModData(player, horse, { equipment = data.equipment })
    localtext = player:getUsername() .. " has equipped Barding (" .. math.floor(wear) .. "%) on horse " .. horse:getName() .. " [GUID: " .. guid .. "]"
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, horse, "equip_barding")
end

function unequipBardingFromHorse(player, horse)
    if checkHorseGhost(horse, player) then return end
    assignHorseGUID(horse, player)
    local data = horse:getModData()
    local guid = data.horseGUID or "NO_GUID"
    if not data.equipment or data.equipment.back ~= "Animals.Barding" then return end
    local wear = data.equipment.backWear or 0
    local bardingItem = InventoryItemFactory.CreateItem("Animals.Barding")
    if bardingItem then
        bardingItem:getModData().backWear = wear
        player:getInventory():AddItem(bardingItem)
    end
    data.equipment.back = nil
    data.equipment.backWear = 0
    modifyModData(player, horse, { equipment = data.equipment })
    localtext = player:getUsername() .. " has unequipped Barding (" .. math.floor(wear) .. "%) from horse " .. horse:getName() .. " [GUID: " .. guid .. "]"
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, horse, "unequip_barding")
end

function equipHoofOnHorse(player, horse, hoofItem)
    if checkHorseGhost(horse, player) then return end
    assignHorseGUID(horse, player)
    local data = horse:getModData()
    local guid = data.horseGUID or "NO_GUID"
    if data.equipment and data.equipment.hoof then return end
    local hoofType = hoofItem:getFullType()
    local info = HORSE_HOOF_TYPES[hoofType]
    if not info then return end
    local wear = hoofItem:getModData().hoofWear or 100
    data.equipment.hoof = hoofType
    data.equipment.hoofWear = wear
    player:getInventory():DoRemoveItem(hoofItem)
    modifyModData(player, horse, { equipment = data.equipment })
    localtext = player:getUsername() .. " has equipped " .. info.name .. " (" .. math.floor(wear) .. "%) on horse " .. horse:getName() .. " [GUID: " .. guid .. "]"
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, horse, "equip_hoof")
end

function unequipHoofFromHorse(player, horse)
    if checkHorseGhost(horse, player) then return end
    assignHorseGUID(horse, player)
    local data = horse:getModData()
    local guid = data.horseGUID or "NO_GUID"
    if not data.equipment or not data.equipment.hoof then return end
    local hoofType = data.equipment.hoof
    local wear = data.equipment.hoofWear or 0
    local info = HORSE_HOOF_TYPES[hoofType] or { name = "Unknown" }
    local hoofItem = InventoryItemFactory.CreateItem(hoofType)
    if hoofItem then
        hoofItem:getModData().hoofWear = wear
        player:getInventory():AddItem(hoofItem)
    end
    data.equipment.hoof = nil
    data.equipment.hoofWear = 0
    modifyModData(player, horse, { equipment = data.equipment })
    localtext = player:getUsername() .. " has unequipped " .. info.name .. " (" .. math.floor(wear) .. "%) from horse " .. horse:getName() .. " [GUID: " .. guid .. "]"
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, horse, "unequip_hoof")
end

function equipMouthOnHorse(player, horse, mouthItem)
    if checkHorseGhost(horse, player) then return end
    assignHorseGUID(horse, player)
    local data = horse:getModData()
    local guid = data.horseGUID or "NO_GUID"
    if data.equipment and data.equipment.mouth then return end
    local mouthType = mouthItem:getFullType()
    local info = HORSE_MOUTH_TYPES[mouthType]
    if not info then return end
    local wear = mouthItem:getModData().mouthWear or 100
    local fill = 0
    if info.fillType == "food" then
        fill = mouthItem:getModData().mouthFill or 0
    elseif info.fillType == "water" then
        if mouthItem.getUsedDelta and mouthItem:IsDrainable() then
            fill = math.floor(mouthItem:getUsedDelta() * 100)
        end
    end
    data.equipment.mouth = mouthType
    data.equipment.mouthWear = wear
    data.equipment.mouthFill = fill
    player:getInventory():DoRemoveItem(mouthItem)
    modifyModData(player, horse, { equipment = data.equipment })
    localtext = player:getUsername() .. " has equipped " .. info.name .. " (" .. math.floor(wear) .. "%, fill " .. fill .. "%) on horse " .. horse:getName() .. " [GUID: " .. guid .. "]"
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, horse, "equip_mouth")
end

function unequipMouthFromHorse(player, horse)
    if checkHorseGhost(horse, player) then return end
    assignHorseGUID(horse, player)
    local data = horse:getModData()
    local guid = data.horseGUID or "NO_GUID"
    if not data.equipment or not data.equipment.mouth then return end
    local mouthType = data.equipment.mouth
    local wear = data.equipment.mouthWear or 0
    local fill = data.equipment.mouthFill or 0
    local info = HORSE_MOUTH_TYPES[mouthType] or { name = "Unknown", fillType = "food" }
    local mouthItem = InventoryItemFactory.CreateItem(mouthType)
    if mouthItem then
        mouthItem:getModData().mouthWear = wear
        if info.fillType == "food" then
            mouthItem:getModData().mouthFill = fill
        elseif info.fillType == "water" and mouthItem.setUsedDelta then
            mouthItem:setUsedDelta(fill / 100)
        end
        player:getInventory():AddItem(mouthItem)
    end
    data.equipment.mouth = nil
    data.equipment.mouthWear = 0
    data.equipment.mouthFill = 0
    modifyModData(player, horse, { equipment = data.equipment })
    localtext = player:getUsername() .. " has unequipped " .. info.name .. " (" .. math.floor(wear) .. "%, fill " .. fill .. "%) from horse " .. horse:getName() .. " [GUID: " .. guid .. "]"
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    writeHorseFile(player, horse, "unequip_mouth")
end

function fillFeedbag(player, feedbag, foodType)
    local foodItem = player:getInventory():FindAndReturn(foodType)
    if not foodItem then return end
    local foodInfo = HORSE_FEEDBAG_FOODS[foodType]
    if not foodInfo then return end
    local current = feedbag:getModData().mouthFill or 0
    feedbag:getModData().mouthFill = math.min(100, current + foodInfo.amount)
    player:getInventory():DoRemoveItem(foodItem)
end

local function fillFeedbagMenu(playerIdx, context, items)
    items = ISInventoryPane.getActualItems(items)
    local player = getPlayer()
    for _, item in ipairs(items) do
        if item:getFullType() == "Animals.Feedbag" then
            local fillMenu = context:addOption("Fill Feedbag")
            local fillSub = ISContextMenu:getNew(context)
            context:addSubMenu(fillMenu, fillSub)
            local any = false
            for foodType, foodInfo in pairs(HORSE_FEEDBAG_FOODS) do
                local foodItem = player:getInventory():FindAndReturn(foodType)
                if foodItem then
                    any = true
                    fillSub:addOption(foodInfo.name .. " (+" .. foodInfo.amount .. "%)", player, fillFeedbag, item, foodType)
                end
            end
            if not any then
                local none = fillSub:addOption("No horse feed in inventory.")
                none.notAvailable = true
            end
            local current = item:getModData().mouthFill or 0
            local tip = ISToolTip:new()
            tip:initialise()
            tip.description = "Current fill: " .. math.floor(current) .. "%"
            fillMenu.toolTip = tip
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(fillFeedbagMenu)


local function renderHorseDescriptions()
    local player = getPlayer()
    if not player then return end

    local pz = math.floor(player:getZ())
    local cell = getCell()
    if not cell then return end

    local range = 15
    local px = math.floor(player:getX())
    local py = math.floor(player:getY())

    for x = px - range, px + range do
        for y = py - range, py + range do
            local square = cell:getGridSquare(x, y, pz)
            if square then
                local objects = square:getWorldObjects()
                if objects then
                    for i = 0, objects:size() - 1 do
                        local wi = objects:get(i)
                        if wi and wi:getItem() then
                            local item = wi:getItem()
                            if HORSE_ITEM_TYPES[item:getFullType()] then
                                local data = item:getModData()
                                if data and data.description and data.description ~= "" then
                                    local sx = IsoUtils.XToScreen(wi:getWorldPosX(), wi:getWorldPosY(), wi:getWorldPosZ(), 0)
                                    local sy = IsoUtils.YToScreen(wi:getWorldPosX(), wi:getWorldPosY(), wi:getWorldPosZ(), 0)

                                    sx = sx - IsoCamera.getOffX() - player:getOffsetX()
                                    sy = sy - IsoCamera.getOffY() - player:getOffsetY()

                                    local drawY = sy - 130

                                    getTextManager():DrawStringCentre(UIFont.AutoNormSmall,
                                        sx, drawY,
                                        data.description,
                                        1.0, 1.0, 1.0, 0.85)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

Events.OnPostRender.Add(renderHorseDescriptions)


HorseStatsEditor = ISPanel:derive("HorseStatsEditor")

function HorseStatsEditor:initialise()
    ISPanel.initialise(self)
end

function HorseStatsEditor:createChildren()
    ISPanel.createChildren(self)

    local y = 20
    local labelWidth = 100
    local inputWidth = 120
    local inputHeight = 25
    local spacing = 35

    self.title = ISLabel:new(self.width / 2 - 50, y, 25, "Edit Horse Stats", 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.title)
    y = y + spacing + 10

    self.healthLabel = ISLabel:new(20, y, inputHeight, "Health:", 1, 1, 1, 1, UIFont.Small, true)
    self:addChild(self.healthLabel)
    self.healthEntry = ISTextEntryBox:new(tostring(self.data.health or 0), labelWidth + 30, y, inputWidth, inputHeight)
    self.healthEntry:initialise()
    self.healthEntry:instantiate()
    self.healthEntry:setOnlyNumbers(true)
    self:addChild(self.healthEntry)
    y = y + spacing

    self.maxHealthLabel = ISLabel:new(20, y, inputHeight, "Max Health:", 1, 1, 1, 1, UIFont.Small, true)
    self:addChild(self.maxHealthLabel)
    self.maxHealthEntry = ISTextEntryBox:new(tostring(self.data.maxHealth or 0), labelWidth + 30, y, inputWidth, inputHeight)
    self.maxHealthEntry:initialise()
    self.maxHealthEntry:instantiate()
    self.maxHealthEntry:setOnlyNumbers(true)
    self:addChild(self.maxHealthEntry)
    y = y + spacing

    self.hungerLabel = ISLabel:new(20, y, inputHeight, "Hunger:", 1, 1, 1, 1, UIFont.Small, true)
    self:addChild(self.hungerLabel)
    self.hungerEntry = ISTextEntryBox:new(tostring(self.data.hunger or 0), labelWidth + 30, y, inputWidth, inputHeight)
    self.hungerEntry:initialise()
    self.hungerEntry:instantiate()
    self.hungerEntry:setOnlyNumbers(true)
    self:addChild(self.hungerEntry)
    y = y + spacing

    self.thirstLabel = ISLabel:new(20, y, inputHeight, "Thirst:", 1, 1, 1, 1, UIFont.Small, true)
    self:addChild(self.thirstLabel)
    self.thirstEntry = ISTextEntryBox:new(tostring(self.data.thirst or 0), labelWidth + 30, y, inputWidth, inputHeight)
    self.thirstEntry:initialise()
    self.thirstEntry:instantiate()
    self.thirstEntry:setOnlyNumbers(true)
    self:addChild(self.thirstEntry)
    y = y + spacing

    self.speedLabel = ISLabel:new(20, y, inputHeight, "Speed:", 1, 1, 1, 1, UIFont.Small, true)
    self:addChild(self.speedLabel)
    self.speedEntry = ISTextEntryBox:new(string.format("%.2f", self.data.speedModifier or 1.0), labelWidth + 30, y, inputWidth, inputHeight)
    self.speedEntry:initialise()
    self.speedEntry:instantiate()
    self:addChild(self.speedEntry)
    y = y + spacing + 10

    self.saveButton = ISButton:new(20, y, 100, 25, "Save", self, HorseStatsEditor.onSave)
    self.saveButton:initialise()
    self.saveButton:instantiate()
    self:addChild(self.saveButton)


    self.cancelButton = ISButton:new(self.width - 120, y, 100, 25, "Cancel", self, HorseStatsEditor.onCancel)
    self.cancelButton:initialise()
    self.cancelButton:instantiate()
    self:addChild(self.cancelButton)
end

function HorseStatsEditor:onSave()
    if checkHorseGhost(self.item, self.player) then self:close() return end
    local newHealth = tonumber(self.healthEntry:getText()) or self.data.health
    local newMaxHealth = tonumber(self.maxHealthEntry:getText()) or self.data.maxHealth
    local newHunger = tonumber(self.hungerEntry:getText()) or self.data.hunger
    local newThirst = tonumber(self.thirstEntry:getText()) or self.data.thirst
    local newSpeed = tonumber(self.speedEntry:getText()) or self.data.speedModifier

    local oldHealth = self.data.health or 0
    local oldMaxHealth = self.data.maxHealth or 0
    local oldHunger = self.data.hunger or 0
    local oldThirst = self.data.thirst or 0
    local oldSpeed = self.data.speedModifier or 0

    assignHorseGUID(self.item, self.player)
    local guid = self.data.horseGUID or "NO_GUID"

    modifyModData(self.player, self.item, {
        health = newHealth,
        maxHealth = newMaxHealth,
        hunger = newHunger,
        thirst = newThirst,
        speedModifier = newSpeed,
    })

    self.player:Say("Horse stats updated.")

    localtext = self.player:getUsername() .. " has ADMIN-edited stats of horse " .. self.item:getName() ..
        " [GUID: " .. guid .. "]" ..
        " health " .. math.floor(oldHealth) .. "->" .. math.floor(newHealth) ..
        ", maxHealth " .. math.floor(oldMaxHealth) .. "->" .. math.floor(newMaxHealth) ..
        ", hunger " .. math.floor(oldHunger) .. "->" .. math.floor(newHunger) ..
        ", thirst " .. math.floor(oldThirst) .. "->" .. math.floor(newThirst) ..
        ", speed " .. string.format("%.2f", oldSpeed) .. "->" .. string.format("%.2f", newSpeed) ..
        " at coordinates " .. math.floor(self.player:getX()) .. " " .. math.floor(self.player:getY()) .. " " .. math.floor(self.player:getZ())
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})

    writeHorseFile(self.player, self.item, "stats_edit")

    self:close()
end

function HorseStatsEditor:onCancel()
    self:close()
end

function HorseStatsEditor:close()
    self:setVisible(false)
    self:removeFromUIManager()
end

function HorseStatsEditor:new(player, item)
    local width = 280
    local height = 300
    local x = (getCore():getScreenWidth() - width) / 2
    local y = (getCore():getScreenHeight() - height) / 2

    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.backgroundColor = {r=0.1, g=0.1, b=0.1, a=0.9}
    o.borderColor = {r=0.5, g=0.5, b=0.5, a=1}
    o.player = player
    o.item = item
    o.data = item:getModData()
    o.moveWithMouse = true
    return o
end

function openHorseStatsEditor(player, item)
    if checkHorseGhost(item, player) then return end
    local editor = HorseStatsEditor:new(player, item)
    editor:initialise()
    editor:addToUIManager()
end


local o_ISUnequipAction_isValid = ISUnequipAction.isValid
function ISUnequipAction:isValid()
    if self.item and HORSE_ITEM_TYPES[self.item:getFullType()] then
        return false
    end
    return o_ISUnequipAction_isValid(self)
end

local original_ISEnterVehicle_isValid = ISEnterVehicle.isValid
function ISEnterVehicle:isValid()
    if getPlayer():getWornItem("Horse") then
        return false
    end
    return original_ISEnterVehicle_isValid(self)
end

local original_ISInventoryTransferAction_isValid = ISInventoryTransferAction.isValid
function ISInventoryTransferAction:isValid()
    local val = original_ISInventoryTransferAction_isValid(self)
    if not val then return false end
    if self.item and HORSE_ITEM_TYPES[self.item:getFullType()] then
        if self.destContainer:getType() == "floor" then
            return true
        end
        return false
    end
    return true
end
