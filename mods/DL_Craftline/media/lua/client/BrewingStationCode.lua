local validTiles = {
    "dl_workbenches_20", "dl_workbenches_21"
}

local activeBrewingTiles = ModData.getOrCreate("activeBrewingTiles")

function isTileValidForBrewing(spriteName)
    for _, validTile in ipairs(validTiles) do
        if spriteName == validTile then
            return true
        end
    end
    return false
end

function getProductionProgress(startTime, totalProductionTime)
    local currentTime = getGameTime():getWorldAgeHours()
    local elapsedTime = currentTime - startTime
    local progress = math.min(math.max((elapsedTime / totalProductionTime) * 100, 0), 100)
    return math.floor(progress + 0.5) -- Round to the nearest integer
end

function OnRightClickTile(player, context, worldobjects)
    -- Loop through the world objects under the cursor
    for _, object in ipairs(worldobjects) do
        -- Check if the object's sprite name is one of the valid tile names
        if object and object:getSprite() then
            local spriteName = object:getSprite():getName()
            if spriteName and isTileValidForBrewing(spriteName) then
                local modData = object:getModData()
                print(modData.BrewingType)
                if not modData.isBrewing then
                    modData.isBrewing = false
                    modData.BrewingStartTime = 0
                    modData.BrewingType = 0
                    modData.TimeNeeded = 0
                end
                if modData.isBrewing == false then
                    local LagerOption = context:addOption("Brew Lager", worldobjects, startLagerProduction, player, object)
                    local AleOption = context:addOption("Brew Ale", worldobjects, startAleProduction, player, object)
                    local WheatBeerOption = context:addOption("Brew Wheat Beer", worldobjects, startWheatBeerProduction, player, object)
                    local IPAOption = context:addOption("Brew Indian Pale Ale", worldobjects, startIPAProduction, player, object)
                    local VodkaOption = context:addOption("Brew Vodka", worldobjects, startVodkaProduction, player, object)
                    local StoutTypesOption = context:insertOptionAfter(getText("Brew Indian Pale Ale"), getText("Brew Stout"));
                    local StoutTypesMenu = ISContextMenu:getNew(context);
                    context:addSubMenu(StoutTypesOption, StoutTypesMenu);  
                        local StoutOption = StoutTypesMenu:addOption("Brew Stout", worldobjects, startStoutProduction, player, object)
                        local StoutCoffeeOption = StoutTypesMenu:addOption("Brew Coffee Stout", worldobjects, startStoutCoffeeProduction, player, object)
                        local StoutChocolateOption = StoutTypesMenu:addOption("Brew Chocolate Stout", worldobjects, startStoutChocolateProduction, player, object)
                    local FruitBeerTypesOption = context:insertOptionAfter(getText("Brew Stout"), getText("Brew Fruit Beer"));
                    local FruitBeerTypesMenu = ISContextMenu:getNew(context);
                    context:addSubMenu(FruitBeerTypesOption, FruitBeerTypesMenu);  
                        local CherryFruitBeerOption = FruitBeerTypesMenu:addOption("Brew Cherry Fruit Beer", worldobjects, startCherryBeerProduction, player, object)
                        local BlueberryFruitBeerOption = FruitBeerTypesMenu:addOption("Brew Blueberry Fruit Beer", worldobjects, startBlueberryBeerProduction, player, object)
                        local StrawberryFruitBeerOption = FruitBeerTypesMenu:addOption("Brew Strawberry Fruit Beer", worldobjects, startStrawberryBeerProduction, player, object)
                        local LemonFruitBeerOption = FruitBeerTypesMenu:addOption("Brew Lemon Fruit Beer", worldobjects, startLemonBeerProduction, player, object)
                        local AppleFruitBeerOption = FruitBeerTypesMenu:addOption("Brew Apple Fruit Beer", worldobjects, startAppleBeerProduction, player, object)
                        local PearFruitBeerOption = FruitBeerTypesMenu:addOption("Brew Pear Fruit Beer", worldobjects, startPearBeerProduction, player, object)

                        
                    addTooltip(LagerOption, "Lager", {"1 x Hops", "2 x Wheat", "5 x Water", "1 x Yeast"}, "12 hours")
                    addTooltip(AleOption, "Ale", {"1 x Hops", "2 x Wheat", "5 x Water", "1 x Yeast"}, "16 hours")
                    addTooltip(WheatBeerOption, "Wheat Beer", {"1 x Hops", "3 x Wheat", "5 x Water", "1 x Yeast"}, "18 hours")
                    addTooltip(IPAOption, "Indian Pale Ale", {"3 x Hops", "2 x Wheat", "5 x Water", "1 x Yeast"}, "20 hours")
                    addTooltip(StoutOption, "Stout", {"2 x Hops", "3 x Wheat", "5 x Water", "1 x Yeast"}, "24 hours")
                    addTooltip(StoutCoffeeOption, "Coffee Stout", {"2 x Hops", "3 x Wheat", "5 x Water", "1 x Yeast", "1 x Coffee Beans"}, "24 hours")
                    addTooltip(StoutChocolateOption, "Chocolate Stout", {"2 x Hops", "3 x Wheat", "5 x Water", "1 x Yeast", "1 x Chocolate"}, "24 hours")
                    addTooltip(CherryFruitBeerOption, "Cherry Beer", {"1 x Hops", "2 x Wheat", "5 x Water", "1 x Yeast", "1 x Cherry"}, "16 hours")
                    addTooltip(BlueberryFruitBeerOption, "Blueberry Beer", {"1 x Hops", "2 x Wheat", "5 x Water", "1 x Yeast", "1 x Blueberry"}, "16 hours")
                    addTooltip(StrawberryFruitBeerOption, "Strawberry Beer", {"1 x Hops", "2 x Wheat", "5 x Water", "1 x Yeast", "1 x Strawberry"}, "16 hours")
                    addTooltip(LemonFruitBeerOption, "Lemon Beer", {"1 x Hops", "2 x Wheat", "5 x Water", "1 x Yeast", "1 x Lemon"}, "16 hours")
                    addTooltip(AppleFruitBeerOption, "Apple Beer", {"1 x Hops", "2 x Wheat", "5 x Water", "1 x Yeast", "1 x Apple"}, "16 hours")
                    addTooltip(PearFruitBeerOption, "Pear Beer", {"1 x Hops", "2 x Wheat", "5 x Water", "1 x Yeast", "1 x Pear"}, "16 hours")
                    addTooltip(VodkaOption, "Vodka", {"3 x Potatoes", "1 x Sugar", "5 x Water", "1 x Yeast"}, "16 hours")
            break
            elseif modData.BrewingType == 1 and isBrewComplete(modData.BrewingStartTime, 90) then
                context:addOption("Bottle Lager", worldobjects, giveLager, player, object)
            break
            elseif modData.BrewingType == 2 and isBrewComplete(modData.BrewingStartTime, 120) then
                context:addOption("Bottle Ale", worldobjects, giveAle, player, object)
            break
            elseif modData.BrewingType == 3 and isBrewComplete(modData.BrewingStartTime, 135) then
                context:addOption("Bottle Wheat Beer", worldobjects, giveWheatBeer, player, object)
            break
            elseif modData.BrewingType == 4 and isBrewComplete(modData.BrewingStartTime, 150) then
                context:addOption("Bottle Indian Pale Ale", worldobjects, giveIPA, player, object)
            break
            elseif modData.BrewingType == 5 and isBrewComplete(modData.BrewingStartTime, 180) then
                context:addOption("Bottle Stout", worldobjects, giveStout, player, object)
            break
            elseif modData.BrewingType == 6 and isBrewComplete(modData.BrewingStartTime, 180) then
                context:addOption("Bottle Coffee Stout", worldobjects, giveStoutCoffee, player, object)
            break
            elseif modData.BrewingType == 7 and isBrewComplete(modData.BrewingStartTime, 180) then
                context:addOption("Bottle Chocolate Stout", worldobjects, giveStoutChocolate, player, object)
            break
            elseif modData.BrewingType == 8 and isBrewComplete(modData.BrewingStartTime, 120) then
                context:addOption("Bottle Cherry Beer", worldobjects, giveBeerCherry, player, object)
            break
            elseif modData.BrewingType == 9 and isBrewComplete(modData.BrewingStartTime, 120) then
                context:addOption("Bottle Blueberry Beer", worldobjects, giveBeerBlueberry, player, object)
            break
            elseif modData.BrewingType == 10 and isBrewComplete(modData.BrewingStartTime, 120) then
                context:addOption("Bottle Strawberry Beer", worldobjects, giveBeerStrawberry, player, object)
            break
            elseif modData.BrewingType == 11 and isBrewComplete(modData.BrewingStartTime, 120) then
                context:addOption("Bottle Lemon Beer", worldobjects, giveBeerLemon, player, object)
            break
            elseif modData.BrewingType == 13 and isBrewComplete(modData.BrewingStartTime, 120) then
                context:addOption("Bottle Apple Beer", worldobjects, giveBeerApple, player, object)
            break
            elseif modData.BrewingType == 12 and isBrewComplete(modData.BrewingStartTime, 120) then
                context:addOption("Bottle Pear Beer", worldobjects, giveBeerPear, player, object)
            elseif modData.BrewingType == 13 and isBrewComplete(modData.BrewingStartTime, 120) then
                context:addOption("Bottle Vodka", worldobjects, giveVodka, player, object)            
            break
            elseif modData.isBrewing == true then
                local progresspercentage = getProductionProgress(modData.BrewingStartTime, modData.TimeNeeded)
                    local currentTime = getGameTime():getWorldAgeHours()
                    local elapsedTime = currentTime - modData.BrewingStartTime
                    local timeLeft = modData.TimeNeeded - elapsedTime
                    timeLeft = tonumber(string.format("%.1f", timeLeft))
                    local ProductionProgressOption = context:addOption("Production Progress " .. progresspercentage .. "%" .. " / Hours Required " .. timeLeft, worldobjects, dummy, player, object)
            break
                end
            end
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(OnRightClickTile)

----------

function addTooltip(option, name, requirements, timeToComplete)
    local tooltip = ISBuildMenu.addToolTip()
    option.toolTip = tooltip
    tooltip:setName(name or "Tooltip")
    tooltip.description = "Requires: <LINE>"

    for _, requirement in ipairs(requirements) do
        tooltip.description = tooltip.description .. requirement .. " <LINE>"
    end
    tooltip.description = tooltip.description .. ""
    tooltip.description = tooltip.description .. "Skills: <LINE>"
    tooltip.description = tooltip.description .. "Cooking level 4 <LINE>"
    tooltip.description = tooltip.description .. "Approx. " .. (timeToComplete or "Unknown") .. " to complete."
end

----------

function calculateTotalWaterUnits(item)
    local useDelta = item:getUseDelta() -- Fraction consumed per use
    local usedDelta = item:getUsedDelta() -- Percentage of the container that is filled

    if useDelta > 0 then
        local totalCapacity = 1 / useDelta -- Total capacity in units
        return usedDelta * totalCapacity -- Current units of water in the container
    end

    return 0 -- If the item cannot store water
end

function isWaterContainer(item)
    return item:isWaterSource() 
end

----------

function startLagerProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local requiredWaterUnits = 5
    local hopsNeeded = 1
    local wheatNeeded = 2
    local yeastNeeded = 1
    local totalWaterUnits = 0
    local items = playerInventory:getItems()
    local cookingLevel = getSpecificPlayer(player):getPerkLevel(Perks.Cooking)

    if cookingLevel < 4 then
        getSpecificPlayer(player):Say("I don't know how to do this.")
        return
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            totalWaterUnits = totalWaterUnits + calculateTotalWaterUnits(item)
        end
    end

    if totalWaterUnits < requiredWaterUnits then
        getSpecificPlayer(player):Say("I don't have enough water.")
        return
    end

    local HopsCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Hops")
    if HopsCount < hopsNeeded then
        getSpecificPlayer(player):Say("I need more hops to start production.")
        return
    end
    local WheatCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Wheat")
    if WheatCount < wheatNeeded then
        getSpecificPlayer(player):Say("I need more wheat to start production.")
        return
    end
    local YeastCount = playerInventory:getItemCountFromTypeRecurse("Base.Yeast")
    if YeastCount < yeastNeeded then
        getSpecificPlayer(player):Say("I need more yeast to start production.")
        return
    end

    local remainingWaterUnits = requiredWaterUnits
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            local availableWaterUnits = calculateTotalWaterUnits(item)
            if availableWaterUnits >= remainingWaterUnits then
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (remainingWaterUnits / (1 / useDelta)))
                remainingWaterUnits = 0
                break
            else
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (availableWaterUnits / (1 / useDelta)))
                remainingWaterUnits = remainingWaterUnits - availableWaterUnits
            end
        end
    end

    -- Consume hops
    for i = 1, hopsNeeded do
        local hopsItem = playerInventory:getFirstType("Sprout.Hops")
        if hopsItem then
            playerInventory:Remove(hopsItem)
        end
    end
    for i = 1, wheatNeeded do
        local wheatItem = playerInventory:getFirstType("Sprout.Wheat")
        if wheatItem then
            playerInventory:Remove(wheatItem)
        end
    end
    for i = 1, yeastNeeded do
        local yeastItem = playerInventory:getFirstType("Base.Yeast")
        if yeastItem then
            playerInventory:Remove(yeastItem)
        end
    end

    local modData = tile:getModData()
    modData.isBrewing = true
    modData.BrewingStartTime = getGameTime():getWorldAgeHours()
    modData.BrewingType = 1
    modData.TimeNeeded = 45
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeBrewingTiles[tileID] = true
    tile:transmitModData()
    getSpecificPlayer(player):Say("Production started!")
end

----------

function startAleProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local requiredWaterUnits = 5
    local hopsNeeded = 1
    local wheatNeeded = 2
    local yeastNeeded = 1
    local totalWaterUnits = 0
    local items = playerInventory:getItems()
    local cookingLevel = getSpecificPlayer(player):getPerkLevel(Perks.Cooking)

    if cookingLevel < 4 then
        getSpecificPlayer(player):Say("I don't know how to do this.")
        return
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            totalWaterUnits = totalWaterUnits + calculateTotalWaterUnits(item)
        end
    end

    if totalWaterUnits < requiredWaterUnits then
        getSpecificPlayer(player):Say("I don't have enough water.")
        return
    end

    local HopsCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Hops")
    if HopsCount < hopsNeeded then
        getSpecificPlayer(player):Say("I need more hops to start production.")
        return
    end
    local WheatCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Wheat")
    if WheatCount < wheatNeeded then
        getSpecificPlayer(player):Say("I need more wheat to start production.")
        return
    end
    local YeastCount = playerInventory:getItemCountFromTypeRecurse("Base.Yeast")
    if YeastCount < yeastNeeded then
        getSpecificPlayer(player):Say("I need more yeast to start production.")
        return
    end

    local remainingWaterUnits = requiredWaterUnits
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            local availableWaterUnits = calculateTotalWaterUnits(item)
            if availableWaterUnits >= remainingWaterUnits then
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (remainingWaterUnits / (1 / useDelta)))
                remainingWaterUnits = 0
                break
            else
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (availableWaterUnits / (1 / useDelta)))
                remainingWaterUnits = remainingWaterUnits - availableWaterUnits
            end
        end
    end

    -- Consume hops
    for i = 1, hopsNeeded do
        local hopsItem = playerInventory:getFirstType("Sprout.Hops")
        if hopsItem then
            playerInventory:Remove(hopsItem)
        end
    end
    for i = 1, wheatNeeded do
        local wheatItem = playerInventory:getFirstType("Sprout.Wheat")
        if wheatItem then
            playerInventory:Remove(wheatItem)
        end
    end
    for i = 1, yeastNeeded do
        local yeastItem = playerInventory:getFirstType("Base.Yeast")
        if yeastItem then
            playerInventory:Remove(yeastItem)
        end
    end

    local modData = tile:getModData()
    modData.isBrewing = true
    modData.BrewingStartTime = getGameTime():getWorldAgeHours()
    modData.BrewingType = 2
    modData.TimeNeeded = 60
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeBrewingTiles[tileID] = true
    tile:transmitModData()
    getSpecificPlayer(player):Say("Production started!")
end

----------


function startWheatBeerProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local requiredWaterUnits = 5
    local hopsNeeded = 1
    local wheatNeeded = 3
    local yeastNeeded = 1
    local totalWaterUnits = 0
    local items = playerInventory:getItems()
    local cookingLevel = getSpecificPlayer(player):getPerkLevel(Perks.Cooking)

    if cookingLevel < 4 then
        getSpecificPlayer(player):Say("I don't know how to do this.")
        return
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            totalWaterUnits = totalWaterUnits + calculateTotalWaterUnits(item)
        end
    end

    if totalWaterUnits < requiredWaterUnits then
        getSpecificPlayer(player):Say("I don't have enough water.")
        return
    end

    local HopsCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Hops")
    if HopsCount < hopsNeeded then
        getSpecificPlayer(player):Say("I need more hops to start production.")
        return
    end
    local WheatCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Wheat")
    if WheatCount < wheatNeeded then
        getSpecificPlayer(player):Say("I need more wheat to start production.")
        return
    end
    local YeastCount = playerInventory:getItemCountFromTypeRecurse("Base.Yeast")
    if YeastCount < yeastNeeded then
        getSpecificPlayer(player):Say("I need more yeast to start production.")
        return
    end

    local remainingWaterUnits = requiredWaterUnits
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            local availableWaterUnits = calculateTotalWaterUnits(item)
            if availableWaterUnits >= remainingWaterUnits then
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (remainingWaterUnits / (1 / useDelta)))
                remainingWaterUnits = 0
                break
            else
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (availableWaterUnits / (1 / useDelta)))
                remainingWaterUnits = remainingWaterUnits - availableWaterUnits
            end
        end
    end

    -- Consume hops
    for i = 1, hopsNeeded do
        local hopsItem = playerInventory:getFirstType("Sprout.Hops")
        if hopsItem then
            playerInventory:Remove(hopsItem)
        end
    end
    for i = 1, wheatNeeded do
        local wheatItem = playerInventory:getFirstType("Sprout.Wheat")
        if wheatItem then
            playerInventory:Remove(wheatItem)
        end
    end
    for i = 1, yeastNeeded do
        local yeastItem = playerInventory:getFirstType("Base.Yeast")
        if yeastItem then
            playerInventory:Remove(yeastItem)
        end
    end

    local modData = tile:getModData()
    modData.isBrewing = true
    modData.BrewingStartTime = getGameTime():getWorldAgeHours()
    modData.BrewingType = 3
    modData.TimeNeeded = 70
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeBrewingTiles[tileID] = true
    tile:transmitModData()
    getSpecificPlayer(player):Say("Production started!")
end

----------

function startIPAProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local requiredWaterUnits = 5
    local hopsNeeded = 3
    local wheatNeeded = 2
    local yeastNeeded = 1
    local totalWaterUnits = 0
    local items = playerInventory:getItems()
    local cookingLevel = getSpecificPlayer(player):getPerkLevel(Perks.Cooking)

    if cookingLevel < 4 then
        getSpecificPlayer(player):Say("I don't know how to do this.")
        return
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            totalWaterUnits = totalWaterUnits + calculateTotalWaterUnits(item)
        end
    end

    if totalWaterUnits < requiredWaterUnits then
        getSpecificPlayer(player):Say("I don't have enough water.")
        return
    end

    local HopsCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Hops")
    if HopsCount < hopsNeeded then
        getSpecificPlayer(player):Say("I need more hops to start production.")
        return
    end
    local WheatCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Wheat")
    if WheatCount < wheatNeeded then
        getSpecificPlayer(player):Say("I need more wheat to start production.")
        return
    end
    local YeastCount = playerInventory:getItemCountFromTypeRecurse("Base.Yeast")
    if YeastCount < yeastNeeded then
        getSpecificPlayer(player):Say("I need more yeast to start production.")
        return
    end

    local remainingWaterUnits = requiredWaterUnits
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            local availableWaterUnits = calculateTotalWaterUnits(item)
            if availableWaterUnits >= remainingWaterUnits then
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (remainingWaterUnits / (1 / useDelta)))
                remainingWaterUnits = 0
                break
            else
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (availableWaterUnits / (1 / useDelta)))
                remainingWaterUnits = remainingWaterUnits - availableWaterUnits
            end
        end
    end

    -- Consume hops
    for i = 1, hopsNeeded do
        local hopsItem = playerInventory:getFirstType("Sprout.Hops")
        if hopsItem then
            playerInventory:Remove(hopsItem)
        end
    end
    for i = 1, wheatNeeded do
        local wheatItem = playerInventory:getFirstType("Sprout.Wheat")
        if wheatItem then
            playerInventory:Remove(wheatItem)
        end
    end
    for i = 1, yeastNeeded do
        local yeastItem = playerInventory:getFirstType("Base.Yeast")
        if yeastItem then
            playerInventory:Remove(yeastItem)
        end
    end

    local modData = tile:getModData()
    modData.isBrewing = true
    modData.BrewingStartTime = getGameTime():getWorldAgeHours()
    modData.BrewingType = 4
    modData.TimeNeeded = 75
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeBrewingTiles[tileID] = true
    tile:transmitModData()
    getSpecificPlayer(player):Say("Production started!")
end

----------

function startStoutProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local requiredWaterUnits = 5
    local hopsNeeded = 2
    local wheatNeeded = 3
    local yeastNeeded = 1
    local totalWaterUnits = 0
    local items = playerInventory:getItems()
    local cookingLevel = getSpecificPlayer(player):getPerkLevel(Perks.Cooking)

    if cookingLevel < 4 then
        getSpecificPlayer(player):Say("I don't know how to do this.")
        return
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            totalWaterUnits = totalWaterUnits + calculateTotalWaterUnits(item)
        end
    end

    if totalWaterUnits < requiredWaterUnits then
        getSpecificPlayer(player):Say("I don't have enough water.")
        return
    end

    local HopsCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Hops")
    if HopsCount < hopsNeeded then
        getSpecificPlayer(player):Say("I need more hops to start production.")
        return
    end
    local WheatCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Wheat")
    if WheatCount < wheatNeeded then
        getSpecificPlayer(player):Say("I need more wheat to start production.")
        return
    end
    local YeastCount = playerInventory:getItemCountFromTypeRecurse("Base.Yeast")
    if YeastCount < yeastNeeded then
        getSpecificPlayer(player):Say("I need more yeast to start production.")
        return
    end

    local remainingWaterUnits = requiredWaterUnits
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            local availableWaterUnits = calculateTotalWaterUnits(item)
            if availableWaterUnits >= remainingWaterUnits then
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (remainingWaterUnits / (1 / useDelta)))
                remainingWaterUnits = 0
                break
            else
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (availableWaterUnits / (1 / useDelta)))
                remainingWaterUnits = remainingWaterUnits - availableWaterUnits
            end
        end
    end

    -- Consume hops
    for i = 1, hopsNeeded do
        local hopsItem = playerInventory:getFirstType("Sprout.Hops")
        if hopsItem then
            playerInventory:Remove(hopsItem)
        end
    end
    for i = 1, wheatNeeded do
        local wheatItem = playerInventory:getFirstType("Sprout.Wheat")
        if wheatItem then
            playerInventory:Remove(wheatItem)
        end
    end
    for i = 1, yeastNeeded do
        local yeastItem = playerInventory:getFirstType("Base.Yeast")
        if yeastItem then
            playerInventory:Remove(yeastItem)
        end
    end

    local modData = tile:getModData()
    modData.isBrewing = true
    modData.BrewingStartTime = getGameTime():getWorldAgeHours()
    modData.BrewingType = 5
    modData.TimeNeeded = 90
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeBrewingTiles[tileID] = true
    tile:transmitModData()
    getSpecificPlayer(player):Say("Production started!")
end

----------

function startStoutCoffeeProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local requiredWaterUnits = 5
    local hopsNeeded = 2
    local wheatNeeded = 3
    local yeastNeeded = 1
    local coffeeNeeded = 1
    local totalWaterUnits = 0
    local items = playerInventory:getItems()
    local cookingLevel = getSpecificPlayer(player):getPerkLevel(Perks.Cooking)

    if cookingLevel < 4 then
        getSpecificPlayer(player):Say("I don't know how to do this.")
        return
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            totalWaterUnits = totalWaterUnits + calculateTotalWaterUnits(item)
        end
    end

    if totalWaterUnits < requiredWaterUnits then
        getSpecificPlayer(player):Say("I don't have enough water.")
        return
    end

    local HopsCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Hops")
    if HopsCount < hopsNeeded then
        getSpecificPlayer(player):Say("I need more hops to start production.")
        return
    end
    local WheatCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Wheat")
    if WheatCount < wheatNeeded then
        getSpecificPlayer(player):Say("I need more wheat to start production.")
        return
    end
    local YeastCount = playerInventory:getItemCountFromTypeRecurse("Base.Yeast")
    if YeastCount < yeastNeeded then
        getSpecificPlayer(player):Say("I need more yeast to start production.")
        return
    end
    local CoffeeCount = playerInventory:getItemCountFromTypeRecurse("Sprout.CoffeeBeans")
    if CoffeeCount < coffeeNeeded then
        getSpecificPlayer(player):Say("I need more coffee beans to start production.")
        return
    end

    local remainingWaterUnits = requiredWaterUnits
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            local availableWaterUnits = calculateTotalWaterUnits(item)
            if availableWaterUnits >= remainingWaterUnits then
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (remainingWaterUnits / (1 / useDelta)))
                remainingWaterUnits = 0
                break
            else
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (availableWaterUnits / (1 / useDelta)))
                remainingWaterUnits = remainingWaterUnits - availableWaterUnits
            end
        end
    end

    -- Consume hops
    for i = 1, hopsNeeded do
        local hopsItem = playerInventory:getFirstType("Sprout.Hops")
        if hopsItem then
            playerInventory:Remove(hopsItem)
        end
    end
    for i = 1, wheatNeeded do
        local wheatItem = playerInventory:getFirstType("Sprout.Wheat")
        if wheatItem then
            playerInventory:Remove(wheatItem)
        end
    end
    for i = 1, yeastNeeded do
        local yeastItem = playerInventory:getFirstType("Base.Yeast")
        if yeastItem then
            playerInventory:Remove(yeastItem)
        end
    end
    for i = 1, coffeeNeeded do
        local cofeeItem = playerInventory:getFirstType("Sprout.CoffeeBeans")
        if cofeeItem then
            playerInventory:Remove(cofeeItem)
        end
    end

    local modData = tile:getModData()
    modData.isBrewing = true
    modData.BrewingStartTime = getGameTime():getWorldAgeHours()
    modData.BrewingType = 6
    modData.TimeNeeded = 90
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeBrewingTiles[tileID] = true
    tile:transmitModData()
    getSpecificPlayer(player):Say("Production started!")
end

----------
function startStoutChocolateProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local requiredWaterUnits = 5
    local hopsNeeded = 2
    local wheatNeeded = 3
    local yeastNeeded = 1
    local chocolateNeeded = 1
    local totalWaterUnits = 0
    local items = playerInventory:getItems()
    local cookingLevel = getSpecificPlayer(player):getPerkLevel(Perks.Cooking)

    if cookingLevel < 4 then
        getSpecificPlayer(player):Say("I don't know how to do this.")
        return
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            totalWaterUnits = totalWaterUnits + calculateTotalWaterUnits(item)
        end
    end

    if totalWaterUnits < requiredWaterUnits then
        getSpecificPlayer(player):Say("I don't have enough water.")
        return
    end

    local HopsCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Hops")
    if HopsCount < hopsNeeded then
        getSpecificPlayer(player):Say("I need more hops to start production.")
        return
    end
    local WheatCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Wheat")
    if WheatCount < wheatNeeded then
        getSpecificPlayer(player):Say("I need more wheat to start production.")
        return
    end
    local YeastCount = playerInventory:getItemCountFromTypeRecurse("Base.Yeast")
    if YeastCount < yeastNeeded then
        getSpecificPlayer(player):Say("I need more yeast to start production.")
        return
    end
    local ChocolateCount = playerInventory:getItemCountFromTypeRecurse("Base.Chocolate")
    if ChocolateCount < chocolateNeeded then
        getSpecificPlayer(player):Say("I need more chocolate to start production.")
        return
    end

    local remainingWaterUnits = requiredWaterUnits
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            local availableWaterUnits = calculateTotalWaterUnits(item)
            if availableWaterUnits >= remainingWaterUnits then
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (remainingWaterUnits / (1 / useDelta)))
                remainingWaterUnits = 0
                break
            else
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (availableWaterUnits / (1 / useDelta)))
                remainingWaterUnits = remainingWaterUnits - availableWaterUnits
            end
        end
    end

    -- Consume hops
    for i = 1, hopsNeeded do
        local hopsItem = playerInventory:getFirstType("Sprout.Hops")
        if hopsItem then
            playerInventory:Remove(hopsItem)
        end
    end
    for i = 1, wheatNeeded do
        local wheatItem = playerInventory:getFirstType("Sprout.Wheat")
        if wheatItem then
            playerInventory:Remove(wheatItem)
        end
    end
    for i = 1, yeastNeeded do
        local yeastItem = playerInventory:getFirstType("Base.Yeast")
        if yeastItem then
            playerInventory:Remove(yeastItem)
        end
    end
    for i = 1, chocolateNeeded do
        local chocolateItem = playerInventory:getFirstType("Base.Chocolate")
        if chocolateItem then
            playerInventory:Remove(chocolateItem)
        end
    end

    local modData = tile:getModData()
    modData.isBrewing = true
    modData.BrewingStartTime = getGameTime():getWorldAgeHours()
    modData.BrewingType = 7
    modData.TimeNeeded = 90
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeBrewingTiles[tileID] = true
    tile:transmitModData()
    getSpecificPlayer(player):Say("Production started!")
end

----------
function startCherryBeerProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local requiredWaterUnits = 5
    local hopsNeeded = 1
    local wheatNeeded = 2
    local yeastNeeded = 1
    local fruitNeeded = 1
    local totalWaterUnits = 0
    local items = playerInventory:getItems()
    local cookingLevel = getSpecificPlayer(player):getPerkLevel(Perks.Cooking)

    if cookingLevel < 4 then
        getSpecificPlayer(player):Say("I don't know how to do this.")
        return
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            totalWaterUnits = totalWaterUnits + calculateTotalWaterUnits(item)
        end
    end

    if totalWaterUnits < requiredWaterUnits then
        getSpecificPlayer(player):Say("I don't have enough water.")
        return
    end

    local HopsCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Hops")
    if HopsCount < hopsNeeded then
        getSpecificPlayer(player):Say("I need more hops to start production.")
        return
    end
    local WheatCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Wheat")
    if WheatCount < wheatNeeded then
        getSpecificPlayer(player):Say("I need more wheat to start production.")
        return
    end
    local YeastCount = playerInventory:getItemCountFromTypeRecurse("Base.Yeast")
    if YeastCount < yeastNeeded then
        getSpecificPlayer(player):Say("I need more yeast to start production.")
        return
    end
    local FruitCount = playerInventory:getItemCountFromTypeRecurse("Base.Cherry")
    if FruitCount < fruitNeeded then
        getSpecificPlayer(player):Say("I need more fruit to start production.")
        return
    end

    local remainingWaterUnits = requiredWaterUnits
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            local availableWaterUnits = calculateTotalWaterUnits(item)
            if availableWaterUnits >= remainingWaterUnits then
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (remainingWaterUnits / (1 / useDelta)))
                remainingWaterUnits = 0
                break
            else
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (availableWaterUnits / (1 / useDelta)))
                remainingWaterUnits = remainingWaterUnits - availableWaterUnits
            end
        end
    end

    -- Consume hops
    for i = 1, hopsNeeded do
        local hopsItem = playerInventory:getFirstType("Sprout.Hops")
        if hopsItem then
            playerInventory:Remove(hopsItem)
        end
    end
    for i = 1, wheatNeeded do
        local wheatItem = playerInventory:getFirstType("Sprout.Wheat")
        if wheatItem then
            playerInventory:Remove(wheatItem)
        end
    end
    for i = 1, yeastNeeded do
        local yeastItem = playerInventory:getFirstType("Base.Yeast")
        if yeastItem then
            playerInventory:Remove(yeastItem)
        end
    end
    for i = 1, fruitNeeded do
        local chocolateItem = playerInventory:getFirstType("Base.Cherry")
        if chocolateItem then
            playerInventory:Remove(chocolateItem)
        end
    end

    local modData = tile:getModData()
    modData.isBrewing = true
    modData.BrewingStartTime = getGameTime():getWorldAgeHours()
    modData.BrewingType = 8
    modData.TimeNeeded = 60
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeBrewingTiles[tileID] = true
    tile:transmitModData()
    getSpecificPlayer(player):Say("Production started!")
end

----------

function startBlueberryBeerProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local requiredWaterUnits = 5
    local hopsNeeded = 1
    local wheatNeeded = 2
    local yeastNeeded = 1
    local fruitNeeded = 1
    local totalWaterUnits = 0
    local items = playerInventory:getItems()
    local cookingLevel = getSpecificPlayer(player):getPerkLevel(Perks.Cooking)

    if cookingLevel < 4 then
        getSpecificPlayer(player):Say("I don't know how to do this.")
        return
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            totalWaterUnits = totalWaterUnits + calculateTotalWaterUnits(item)
        end
    end

    if totalWaterUnits < requiredWaterUnits then
        getSpecificPlayer(player):Say("I don't have enough water.")
        return
    end

    local HopsCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Hops")
    if HopsCount < hopsNeeded then
        getSpecificPlayer(player):Say("I need more hops to start production.")
        return
    end
    local WheatCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Wheat")
    if WheatCount < wheatNeeded then
        getSpecificPlayer(player):Say("I need more wheat to start production.")
        return
    end
    local YeastCount = playerInventory:getItemCountFromTypeRecurse("Base.Yeast")
    if YeastCount < yeastNeeded then
        getSpecificPlayer(player):Say("I need more yeast to start production.")
        return
    end
    local FruitCount = playerInventory:getItemCountFromTypeRecurse("Base.BerryBlue")
    if FruitCount < fruitNeeded then
        getSpecificPlayer(player):Say("I need more fruit to start production.")
        return
    end

    local remainingWaterUnits = requiredWaterUnits
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            local availableWaterUnits = calculateTotalWaterUnits(item)
            if availableWaterUnits >= remainingWaterUnits then
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (remainingWaterUnits / (1 / useDelta)))
                remainingWaterUnits = 0
                break
            else
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (availableWaterUnits / (1 / useDelta)))
                remainingWaterUnits = remainingWaterUnits - availableWaterUnits
            end
        end
    end

    -- Consume hops
    for i = 1, hopsNeeded do
        local hopsItem = playerInventory:getFirstType("Sprout.Hops")
        if hopsItem then
            playerInventory:Remove(hopsItem)
        end
    end
    for i = 1, wheatNeeded do
        local wheatItem = playerInventory:getFirstType("Sprout.Wheat")
        if wheatItem then
            playerInventory:Remove(wheatItem)
        end
    end
    for i = 1, yeastNeeded do
        local yeastItem = playerInventory:getFirstType("Base.Yeast")
        if yeastItem then
            playerInventory:Remove(yeastItem)
        end
    end
    for i = 1, fruitNeeded do
        local chocolateItem = playerInventory:getFirstType("Base.BerryBlue")
        if chocolateItem then
            playerInventory:Remove(chocolateItem)
        end
    end

    local modData = tile:getModData()
    modData.isBrewing = true
    modData.BrewingStartTime = getGameTime():getWorldAgeHours()
    modData.BrewingType = 9
    modData.TimeNeeded = 60
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeBrewingTiles[tileID] = true
    tile:transmitModData()
    getSpecificPlayer(player):Say("Production started!")
end

----------

function startStrawberryBeerProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local requiredWaterUnits = 5
    local hopsNeeded = 1
    local wheatNeeded = 2
    local yeastNeeded = 1
    local fruitNeeded = 1
    local totalWaterUnits = 0
    local items = playerInventory:getItems()
    local cookingLevel = getSpecificPlayer(player):getPerkLevel(Perks.Cooking)

    if cookingLevel < 4 then
        getSpecificPlayer(player):Say("I don't know how to do this.")
        return
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            totalWaterUnits = totalWaterUnits + calculateTotalWaterUnits(item)
        end
    end

    if totalWaterUnits < requiredWaterUnits then
        getSpecificPlayer(player):Say("I don't have enough water.")
        return
    end

    local HopsCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Hops")
    if HopsCount < hopsNeeded then
        getSpecificPlayer(player):Say("I need more hops to start production.")
        return
    end
    local WheatCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Wheat")
    if WheatCount < wheatNeeded then
        getSpecificPlayer(player):Say("I need more wheat to start production.")
        return
    end
    local YeastCount = playerInventory:getItemCountFromTypeRecurse("Base.Yeast")
    if YeastCount < yeastNeeded then
        getSpecificPlayer(player):Say("I need more yeast to start production.")
        return
    end
    local FruitCount = playerInventory:getItemCountFromTypeRecurse("farming.Strewberrie")
    if FruitCount < fruitNeeded then
        getSpecificPlayer(player):Say("I need more fruit to start production.")
        return
    end

    local remainingWaterUnits = requiredWaterUnits
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            local availableWaterUnits = calculateTotalWaterUnits(item)
            if availableWaterUnits >= remainingWaterUnits then
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (remainingWaterUnits / (1 / useDelta)))
                remainingWaterUnits = 0
                break
            else
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (availableWaterUnits / (1 / useDelta)))
                remainingWaterUnits = remainingWaterUnits - availableWaterUnits
            end
        end
    end

    -- Consume hops
    for i = 1, hopsNeeded do
        local hopsItem = playerInventory:getFirstType("Sprout.Hops")
        if hopsItem then
            playerInventory:Remove(hopsItem)
        end
    end
    for i = 1, wheatNeeded do
        local wheatItem = playerInventory:getFirstType("Sprout.Wheat")
        if wheatItem then
            playerInventory:Remove(wheatItem)
        end
    end
    for i = 1, yeastNeeded do
        local yeastItem = playerInventory:getFirstType("Base.Yeast")
        if yeastItem then
            playerInventory:Remove(yeastItem)
        end
    end
    for i = 1, fruitNeeded do
        local chocolateItem = playerInventory:getFirstType("farming.Strewberrie")
        if chocolateItem then
            playerInventory:Remove(chocolateItem)
        end
    end

    local modData = tile:getModData()
    modData.isBrewing = true
    modData.BrewingStartTime = getGameTime():getWorldAgeHours()
    modData.BrewingType = 10
    modData.TimeNeeded = 60
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeBrewingTiles[tileID] = true
    tile:transmitModData()
    getSpecificPlayer(player):Say("Production started!")
end

----------
function startLemonBeerProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local requiredWaterUnits = 5
    local hopsNeeded = 1
    local wheatNeeded = 2
    local yeastNeeded = 1
    local fruitNeeded = 1
    local totalWaterUnits = 0
    local items = playerInventory:getItems()
    local cookingLevel = getSpecificPlayer(player):getPerkLevel(Perks.Cooking)

    if cookingLevel < 4 then
        getSpecificPlayer(player):Say("I don't know how to do this.")
        return
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            totalWaterUnits = totalWaterUnits + calculateTotalWaterUnits(item)
        end
    end

    if totalWaterUnits < requiredWaterUnits then
        getSpecificPlayer(player):Say("I don't have enough water.")
        return
    end

    local HopsCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Hops")
    if HopsCount < hopsNeeded then
        getSpecificPlayer(player):Say("I need more hops to start production.")
        return
    end
    local WheatCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Wheat")
    if WheatCount < wheatNeeded then
        getSpecificPlayer(player):Say("I need more wheat to start production.")
        return
    end
    local YeastCount = playerInventory:getItemCountFromTypeRecurse("Base.Yeast")
    if YeastCount < yeastNeeded then
        getSpecificPlayer(player):Say("I need more yeast to start production.")
        return
    end
    local FruitCount = playerInventory:getItemCountFromTypeRecurse("Base.Lemon")
    if FruitCount < fruitNeeded then
        getSpecificPlayer(player):Say("I need more fruit to start production.")
        return
    end

    local remainingWaterUnits = requiredWaterUnits
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            local availableWaterUnits = calculateTotalWaterUnits(item)
            if availableWaterUnits >= remainingWaterUnits then
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (remainingWaterUnits / (1 / useDelta)))
                remainingWaterUnits = 0
                break
            else
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (availableWaterUnits / (1 / useDelta)))
                remainingWaterUnits = remainingWaterUnits - availableWaterUnits
            end
        end
    end

    -- Consume hops
    for i = 1, hopsNeeded do
        local hopsItem = playerInventory:getFirstType("Sprout.Hops")
        if hopsItem then
            playerInventory:Remove(hopsItem)
        end
    end
    for i = 1, wheatNeeded do
        local wheatItem = playerInventory:getFirstType("Sprout.Wheat")
        if wheatItem then
            playerInventory:Remove(wheatItem)
        end
    end
    for i = 1, yeastNeeded do
        local yeastItem = playerInventory:getFirstType("Base.Yeast")
        if yeastItem then
            playerInventory:Remove(yeastItem)
        end
    end
    for i = 1, fruitNeeded do
        local chocolateItem = playerInventory:getFirstType("Base.Lemon")
        if chocolateItem then
            playerInventory:Remove(chocolateItem)
        end
    end

    local modData = tile:getModData()
    modData.isBrewing = true
    modData.BrewingStartTime = getGameTime():getWorldAgeHours()
    modData.BrewingType = 11
    modData.TimeNeeded = 60
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeBrewingTiles[tileID] = true
    tile:transmitModData()
    getSpecificPlayer(player):Say("Production started!")
end

----------
function startPearBeerProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local requiredWaterUnits = 5
    local hopsNeeded = 1
    local wheatNeeded = 2
    local yeastNeeded = 1
    local fruitNeeded = 1
    local totalWaterUnits = 0
    local items = playerInventory:getItems()
    local cookingLevel = getSpecificPlayer(player):getPerkLevel(Perks.Cooking)

    if cookingLevel < 4 then
        getSpecificPlayer(player):Say("I don't know how to do this.")
        return
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            totalWaterUnits = totalWaterUnits + calculateTotalWaterUnits(item)
        end
    end

    if totalWaterUnits < requiredWaterUnits then
        getSpecificPlayer(player):Say("I don't have enough water.")
        return
    end

    local HopsCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Hops")
    if HopsCount < hopsNeeded then
        getSpecificPlayer(player):Say("I need more hops to start production.")
        return
    end
    local WheatCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Wheat")
    if WheatCount < wheatNeeded then
        getSpecificPlayer(player):Say("I need more wheat to start production.")
        return
    end
    local YeastCount = playerInventory:getItemCountFromTypeRecurse("Base.Yeast")
    if YeastCount < yeastNeeded then
        getSpecificPlayer(player):Say("I need more yeast to start production.")
        return
    end
    local FruitCount = playerInventory:getItemCountFromTypeRecurse("Base.Pear")
    if FruitCount < fruitNeeded then
        getSpecificPlayer(player):Say("I need more fruit to start production.")
        return
    end

    local remainingWaterUnits = requiredWaterUnits
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            local availableWaterUnits = calculateTotalWaterUnits(item)
            if availableWaterUnits >= remainingWaterUnits then
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (remainingWaterUnits / (1 / useDelta)))
                remainingWaterUnits = 0
                break
            else
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (availableWaterUnits / (1 / useDelta)))
                remainingWaterUnits = remainingWaterUnits - availableWaterUnits
            end
        end
    end

    -- Consume hops
    for i = 1, hopsNeeded do
        local hopsItem = playerInventory:getFirstType("Sprout.Hops")
        if hopsItem then
            playerInventory:Remove(hopsItem)
        end
    end
    for i = 1, wheatNeeded do
        local wheatItem = playerInventory:getFirstType("Sprout.Wheat")
        if wheatItem then
            playerInventory:Remove(wheatItem)
        end
    end
    for i = 1, yeastNeeded do
        local yeastItem = playerInventory:getFirstType("Base.Yeast")
        if yeastItem then
            playerInventory:Remove(yeastItem)
        end
    end
    for i = 1, fruitNeeded do
        local chocolateItem = playerInventory:getFirstType("Base.Pear")
        if chocolateItem then
            playerInventory:Remove(chocolateItem)
        end
    end

    local modData = tile:getModData()
    modData.isBrewing = true
    modData.BrewingStartTime = getGameTime():getWorldAgeHours()
    modData.BrewingType = 12
    modData.TimeNeeded = 60
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeBrewingTiles[tileID] = true
    tile:transmitModData()
    getSpecificPlayer(player):Say("Production started!")
end

----------
function startAppleBeerProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local requiredWaterUnits = 5
    local hopsNeeded = 1
    local wheatNeeded = 2
    local yeastNeeded = 1
    local fruitNeeded = 1
    local totalWaterUnits = 0
    local items = playerInventory:getItems()
    local cookingLevel = getSpecificPlayer(player):getPerkLevel(Perks.Cooking)

    if cookingLevel < 4 then
        getSpecificPlayer(player):Say("I don't know how to do this.")
        return
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            totalWaterUnits = totalWaterUnits + calculateTotalWaterUnits(item)
        end
    end

    if totalWaterUnits < requiredWaterUnits then
        getSpecificPlayer(player):Say("I don't have enough water.")
        return
    end

    local HopsCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Hops")
    if HopsCount < hopsNeeded then
        getSpecificPlayer(player):Say("I need more hops to start production.")
        return
    end
    local WheatCount = playerInventory:getItemCountFromTypeRecurse("Sprout.Wheat")
    if WheatCount < wheatNeeded then
        getSpecificPlayer(player):Say("I need more wheat to start production.")
        return
    end
    local YeastCount = playerInventory:getItemCountFromTypeRecurse("Base.Yeast")
    if YeastCount < yeastNeeded then
        getSpecificPlayer(player):Say("I need more yeast to start production.")
        return
    end
    local FruitCount = playerInventory:getItemCountFromTypeRecurse("Base.Apple")
    if FruitCount < fruitNeeded then
        getSpecificPlayer(player):Say("I need more fruit to start production.")
        return
    end

    local remainingWaterUnits = requiredWaterUnits
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            local availableWaterUnits = calculateTotalWaterUnits(item)
            if availableWaterUnits >= remainingWaterUnits then
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (remainingWaterUnits / (1 / useDelta)))
                remainingWaterUnits = 0
                break
            else
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (availableWaterUnits / (1 / useDelta)))
                remainingWaterUnits = remainingWaterUnits - availableWaterUnits
            end
        end
    end

    -- Consume hops
    for i = 1, hopsNeeded do
        local hopsItem = playerInventory:getFirstType("Sprout.Hops")
        if hopsItem then
            playerInventory:Remove(hopsItem)
        end
    end
    for i = 1, wheatNeeded do
        local wheatItem = playerInventory:getFirstType("Sprout.Wheat")
        if wheatItem then
            playerInventory:Remove(wheatItem)
        end
    end
    for i = 1, yeastNeeded do
        local yeastItem = playerInventory:getFirstType("Base.Yeast")
        if yeastItem then
            playerInventory:Remove(yeastItem)
        end
    end
    for i = 1, fruitNeeded do
        local chocolateItem = playerInventory:getFirstType("Base.Apple")
        if chocolateItem then
            playerInventory:Remove(chocolateItem)
        end
    end

    local modData = tile:getModData()
    modData.isBrewing = true
    modData.BrewingStartTime = getGameTime():getWorldAgeHours()
    modData.BrewingType = 13
    modData.TimeNeeded = 60
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeBrewingTiles[tileID] = true
    tile:transmitModData()
    getSpecificPlayer(player):Say("Production started!")
end

----------

function startVodkaProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local requiredWaterUnits = 5
    local sugarNeeded = 1
    local potatoNeeded = 3
    local yeastNeeded = 1
    local totalWaterUnits = 0
    local items = playerInventory:getItems()
    local cookingLevel = getSpecificPlayer(player):getPerkLevel(Perks.Cooking)

    if cookingLevel < 6 then
        getSpecificPlayer(player):Say("I don't know how to do this.")
        return
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            totalWaterUnits = totalWaterUnits + calculateTotalWaterUnits(item)
        end
    end

    if totalWaterUnits < requiredWaterUnits then
        getSpecificPlayer(player):Say("I don't have enough water.")
        return
    end

    local SugarCount = playerInventory:getItemCountFromTypeRecurse("base.Sugar") -- addd different types of sugar? Brown? - Milo
    if SugarCount < sugarNeeded then
        getSpecificPlayer(player):Say("I need more sugar to start production.")
        return
    end
    local PotatoCount = playerInventory:getItemCountFromTypeRecurse("farming.Potato")
    if PotatoCount < potatoNeeded then
        getSpecificPlayer(player):Say("I need more potatos to start production.")
        return
    end
    local YeastCount = playerInventory:getItemCountFromTypeRecurse("Base.Yeast")
    if YeastCount < yeastNeeded then
        getSpecificPlayer(player):Say("I need more yeast to start production.")
        return
    end

    local remainingWaterUnits = requiredWaterUnits
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if isWaterContainer(item) then
            local availableWaterUnits = calculateTotalWaterUnits(item)
            if availableWaterUnits >= remainingWaterUnits then
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (remainingWaterUnits / (1 / useDelta)))
                remainingWaterUnits = 0
                break
            else
                local useDelta = item:getUseDelta()
                item:setUsedDelta(item:getUsedDelta() - (availableWaterUnits / (1 / useDelta)))
                remainingWaterUnits = remainingWaterUnits - availableWaterUnits
            end
        end
    end

    -- Consume hops
    for i = 1, hopsNeeded do
        local hopsItem = playerInventory:getFirstType("Sprout.Hops")
        if hopsItem then
            playerInventory:Remove(hopsItem)
        end
    end
    for i = 1, wheatNeeded do
        local wheatItem = playerInventory:getFirstType("Sprout.Wheat")
        if wheatItem then
            playerInventory:Remove(wheatItem)
        end
    end
    for i = 1, yeastNeeded do
        local yeastItem = playerInventory:getFirstType("Base.Yeast")
        if yeastItem then
            playerInventory:Remove(yeastItem)
        end
    end

    local modData = tile:getModData()
    modData.isBrewing = true
    modData.BrewingStartTime = getGameTime():getWorldAgeHours()
    modData.BrewingType = 13
    modData.TimeNeeded = 45
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeBrewingTiles[tileID] = true
    tile:transmitModData()
    getSpecificPlayer(player):Say("Production started!")
end

----------

function isBrewComplete(startTime, timeToProduce)
    return getGameTime():getWorldAgeHours() >= startTime + (timeToProduce)
end

----------

function checkBrewingStatus()
    for tileID, _ in pairs(activeBrewingTiles) do
        -- Parse the tile coordinates from the unique ID
        local x, y, z = tileID:match("^(%d+)_(%d+)_(%d+)$")
        local square = getCell():getGridSquare(tonumber(x), tonumber(y), tonumber(z))

        if square then
            -- Re-fetch each tile object directly from the square
            for i = 0, square:getObjects():size() - 1 do
                local currentTile = square:getObjects():get(i)
                local modData = currentTile:getModData()
                currentTile:transmitModData() -- Sync changes
            end
        end
    end
end

Events.EveryHours.Add(checkBrewingStatus)
----------

function giveLager(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local bottleCount = inv:getItemCountFromTypeRecurse("Base.BeerEmpty")
    if bottleCount < 12 then
        getSpecificPlayer(0):Say("I need 12 empty beer bottles.")
        return
    end
    -- Consume hops
    for i = 1, 12 do
        local bottleItem = inv:getFirstType("Base.BeerEmpty")
        if bottleItem then
            inv:Remove(bottleItem)
        end
    end
    inv:AddItem('Deadline.BeerLager')
    inv:AddItem('Deadline.BeerLager')
    inv:AddItem('Deadline.BeerLager')
    inv:AddItem('Deadline.BeerLager')
    inv:AddItem('Deadline.BeerLager')
    inv:AddItem('Deadline.BeerLager')
    inv:AddItem('Deadline.BeerLager')
    inv:AddItem('Deadline.BeerLager')
    inv:AddItem('Deadline.BeerLager')
    inv:AddItem('Deadline.BeerLager')
    inv:AddItem('Deadline.BeerLager')
    inv:AddItem('Deadline.BeerLager')
    local modData = tile:getModData()
    modData.isBrewing = false
    tile:transmitModData()
end

function giveAle(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local bottleCount = inv:getItemCountFromTypeRecurse("Base.BeerEmpty")
    if bottleCount < 12 then
        getSpecificPlayer(0):Say("I need 12 empty beer bottles.")
        return
    end
    -- Consume hops
    for i = 1, 12 do
        local bottleItem = inv:getFirstType("Base.BeerEmpty")
        if bottleItem then
            inv:Remove(bottleItem)
        end
    end
    inv:AddItem('Deadline.BeerAle')
    inv:AddItem('Deadline.BeerAle')
    inv:AddItem('Deadline.BeerAle')
    inv:AddItem('Deadline.BeerAle')
    inv:AddItem('Deadline.BeerAle')
    inv:AddItem('Deadline.BeerAle')
    inv:AddItem('Deadline.BeerAle')
    inv:AddItem('Deadline.BeerAle')
    inv:AddItem('Deadline.BeerAle')
    inv:AddItem('Deadline.BeerAle')
    inv:AddItem('Deadline.BeerAle')
    inv:AddItem('Deadline.BeerAle')
    local modData = tile:getModData()
    modData.isBrewing = false
    tile:transmitModData()
end

function giveWheatBeer(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local bottleCount = inv:getItemCountFromTypeRecurse("Base.BeerEmpty")
    if bottleCount < 12 then
        getSpecificPlayer(0):Say("I need 12 empty beer bottles.")
        return
    end
    -- Consume hops
    for i = 1, 12 do
        local bottleItem = inv:getFirstType("Base.BeerEmpty")
        if bottleItem then
            inv:Remove(bottleItem)
        end
    end
    inv:AddItem('Deadline.BeerWheatBeer')
    inv:AddItem('Deadline.BeerWheatBeer')
    inv:AddItem('Deadline.BeerWheatBeer')
    inv:AddItem('Deadline.BeerWheatBeer')
    inv:AddItem('Deadline.BeerWheatBeer')
    inv:AddItem('Deadline.BeerWheatBeer')
    inv:AddItem('Deadline.BeerWheatBeer')
    inv:AddItem('Deadline.BeerWheatBeer')
    inv:AddItem('Deadline.BeerWheatBeer')
    inv:AddItem('Deadline.BeerWheatBeer')
    inv:AddItem('Deadline.BeerWheatBeer')
    inv:AddItem('Deadline.BeerWheatBeer')
    local modData = tile:getModData()
    modData.isBrewing = false
    tile:transmitModData()
end

function giveIPA(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local bottleCount = inv:getItemCountFromTypeRecurse("Base.BeerEmpty")
    if bottleCount < 12 then
        getSpecificPlayer(0):Say("I need 12 empty beer bottles.")
        return
    end
    -- Consume hops
    for i = 1, 12 do
        local bottleItem = inv:getFirstType("Base.BeerEmpty")
        if bottleItem then
            inv:Remove(bottleItem)
        end
    end
    inv:AddItem('Deadline.BeerIPA')
    inv:AddItem('Deadline.BeerIPA')
    inv:AddItem('Deadline.BeerIPA')
    inv:AddItem('Deadline.BeerIPA')
    inv:AddItem('Deadline.BeerIPA')
    inv:AddItem('Deadline.BeerIPA')
    inv:AddItem('Deadline.BeerIPA')
    inv:AddItem('Deadline.BeerIPA')
    inv:AddItem('Deadline.BeerIPA')
    inv:AddItem('Deadline.BeerIPA')
    inv:AddItem('Deadline.BeerIPA')
    inv:AddItem('Deadline.BeerIPA')
    local modData = tile:getModData()
    modData.isBrewing = false
    tile:transmitModData()
end

function giveStout(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local bottleCount = inv:getItemCountFromTypeRecurse("Base.BeerEmpty")
    if bottleCount < 12 then
        getSpecificPlayer(0):Say("I need 12 empty beer bottles.")
        return
    end
    -- Consume hops
    for i = 1, 12 do
        local bottleItem = inv:getFirstType("Base.BeerEmpty")
        if bottleItem then
            inv:Remove(bottleItem)
        end
    end
    inv:AddItem('Deadline.BeerStout')
    inv:AddItem('Deadline.BeerStout')
    inv:AddItem('Deadline.BeerStout')
    inv:AddItem('Deadline.BeerStout')
    inv:AddItem('Deadline.BeerStout')
    inv:AddItem('Deadline.BeerStout')
    inv:AddItem('Deadline.BeerStout')
    inv:AddItem('Deadline.BeerStout')
    inv:AddItem('Deadline.BeerStout')
    inv:AddItem('Deadline.BeerStout')
    inv:AddItem('Deadline.BeerStout')
    inv:AddItem('Deadline.BeerStout')
    local modData = tile:getModData()
    modData.isBrewing = false
    tile:transmitModData()
end

function giveStoutCoffee(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local bottleCount = inv:getItemCountFromTypeRecurse("Base.BeerEmpty")
    if bottleCount < 12 then
        getSpecificPlayer(0):Say("I need 12 empty beer bottles.")
        return
    end
    -- Consume hops
    for i = 1, 12 do
        local bottleItem = inv:getFirstType("Base.BeerEmpty")
        if bottleItem then
            inv:Remove(bottleItem)
        end
    end
    inv:AddItem('Deadline.BeerStoutCoffee')
    inv:AddItem('Deadline.BeerStoutCoffee')
    inv:AddItem('Deadline.BeerStoutCoffee')
    inv:AddItem('Deadline.BeerStoutCoffee')
    inv:AddItem('Deadline.BeerStoutCoffee')
    inv:AddItem('Deadline.BeerStoutCoffee')
    inv:AddItem('Deadline.BeerStoutCoffee')
    inv:AddItem('Deadline.BeerStoutCoffee')
    inv:AddItem('Deadline.BeerStoutCoffee')
    inv:AddItem('Deadline.BeerStoutCoffee')
    inv:AddItem('Deadline.BeerStoutCoffee')
    inv:AddItem('Deadline.BeerStoutCoffee')
    local modData = tile:getModData()
    modData.isBrewing = false
    tile:transmitModData()
end

function giveStoutChocolate(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local bottleCount = inv:getItemCountFromTypeRecurse("Base.BeerEmpty")
    if bottleCount < 12 then
        getSpecificPlayer(0):Say("I need 12 empty beer bottles.")
        return
    end
    -- Consume hops
    for i = 1, 12 do
        local bottleItem = inv:getFirstType("Base.BeerEmpty")
        if bottleItem then
            inv:Remove(bottleItem)
        end
    end
    inv:AddItem('Deadline.BeerStoutChocolate')
    inv:AddItem('Deadline.BeerStoutChocolate')
    inv:AddItem('Deadline.BeerStoutChocolate')
    inv:AddItem('Deadline.BeerStoutChocolate')
    inv:AddItem('Deadline.BeerStoutChocolate')
    inv:AddItem('Deadline.BeerStoutChocolate')
    inv:AddItem('Deadline.BeerStoutChocolate')
    inv:AddItem('Deadline.BeerStoutChocolate')
    inv:AddItem('Deadline.BeerStoutChocolate')
    inv:AddItem('Deadline.BeerStoutChocolate')
    inv:AddItem('Deadline.BeerStoutChocolate')
    inv:AddItem('Deadline.BeerStoutChocolate')
    local modData = tile:getModData()
    modData.isBrewing = false
    tile:transmitModData()
end


function giveBeerCherry(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local bottleCount = inv:getItemCountFromTypeRecurse("Base.BeerEmpty")
    if bottleCount < 12 then
        getSpecificPlayer(0):Say("I need 12 empty beer bottles.")
        return
    end
    -- Consume hops
    for i = 1, 12 do
        local bottleItem = inv:getFirstType("Base.BeerEmpty")
        if bottleItem then
            inv:Remove(bottleItem)
        end
    end
    inv:AddItem('Deadline.BeerFruitCherry')
    inv:AddItem('Deadline.BeerFruitCherry')
    inv:AddItem('Deadline.BeerFruitCherry')
    inv:AddItem('Deadline.BeerFruitCherry')
    inv:AddItem('Deadline.BeerFruitCherry')
    inv:AddItem('Deadline.BeerFruitCherry')
    inv:AddItem('Deadline.BeerFruitCherry')
    inv:AddItem('Deadline.BeerFruitCherry')
    inv:AddItem('Deadline.BeerFruitCherry')
    inv:AddItem('Deadline.BeerFruitCherry')
    inv:AddItem('Deadline.BeerFruitCherry')
    inv:AddItem('Deadline.BeerFruitCherry')
    local modData = tile:getModData()
    modData.isBrewing = false
    tile:transmitModData()
end

function giveBeerBlueberry(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local bottleCount = inv:getItemCountFromTypeRecurse("Base.BeerEmpty")
    if bottleCount < 12 then
        getSpecificPlayer(0):Say("I need 12 empty beer bottles.")
        return
    end
    -- Consume hops
    for i = 1, 12 do
        local bottleItem = inv:getFirstType("Base.BeerEmpty")
        if bottleItem then
            inv:Remove(bottleItem)
        end
    end
    inv:AddItem('Deadline.BeerFruitBlueberry')
    inv:AddItem('Deadline.BeerFruitBlueberry')
    inv:AddItem('Deadline.BeerFruitBlueberry')
    inv:AddItem('Deadline.BeerFruitBlueberry')
    inv:AddItem('Deadline.BeerFruitBlueberry')
    inv:AddItem('Deadline.BeerFruitBlueberry')
    inv:AddItem('Deadline.BeerFruitBlueberry')
    inv:AddItem('Deadline.BeerFruitBlueberry')
    inv:AddItem('Deadline.BeerFruitBlueberry')
    inv:AddItem('Deadline.BeerFruitBlueberry')
    inv:AddItem('Deadline.BeerFruitBlueberry')
    inv:AddItem('Deadline.BeerFruitBlueberry')
    local modData = tile:getModData()
    modData.isBrewing = false
    tile:transmitModData()
end

function giveBeerStrawberry(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local bottleCount = inv:getItemCountFromTypeRecurse("Base.BeerEmpty")
    if bottleCount < 12 then
        getSpecificPlayer(0):Say("I need 12 empty beer bottles.")
        return
    end
    -- Consume hops
    for i = 1, 12 do
        local bottleItem = inv:getFirstType("Base.BeerEmpty")
        if bottleItem then
            inv:Remove(bottleItem)
        end
    end
    inv:AddItem('Deadline.BeerFruitStrawberry')
    inv:AddItem('Deadline.BeerFruitStrawberry')
    inv:AddItem('Deadline.BeerFruitStrawberry')
    inv:AddItem('Deadline.BeerFruitStrawberry')
    inv:AddItem('Deadline.BeerFruitStrawberry')
    inv:AddItem('Deadline.BeerFruitStrawberry')
    inv:AddItem('Deadline.BeerFruitStrawberry')
    inv:AddItem('Deadline.BeerFruitStrawberry')
    inv:AddItem('Deadline.BeerFruitStrawberry')
    inv:AddItem('Deadline.BeerFruitStrawberry')
    inv:AddItem('Deadline.BeerFruitStrawberry')
    inv:AddItem('Deadline.BeerFruitStrawberry')
    local modData = tile:getModData()
    modData.isBrewing = false
    tile:transmitModData()
end

function giveBeerLemon(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local bottleCount = inv:getItemCountFromTypeRecurse("Base.BeerEmpty")
    if bottleCount < 12 then
        getSpecificPlayer(0):Say("I need 12 empty beer bottles.")
        return
    end
    -- Consume hops
    for i = 1, 12 do
        local bottleItem = inv:getFirstType("Base.BeerEmpty")
        if bottleItem then
            inv:Remove(bottleItem)
        end
    end
    inv:AddItem('Deadline.BeerFruitLemon')
    inv:AddItem('Deadline.BeerFruitLemon')
    inv:AddItem('Deadline.BeerFruitLemon')
    inv:AddItem('Deadline.BeerFruitLemon')
    inv:AddItem('Deadline.BeerFruitLemon')
    inv:AddItem('Deadline.BeerFruitLemon')
    inv:AddItem('Deadline.BeerFruitLemon')
    inv:AddItem('Deadline.BeerFruitLemon')
    inv:AddItem('Deadline.BeerFruitLemon')
    inv:AddItem('Deadline.BeerFruitLemon')
    inv:AddItem('Deadline.BeerFruitLemon')
    inv:AddItem('Deadline.BeerFruitLemon')
    local modData = tile:getModData()
    modData.isBrewing = false
    tile:transmitModData()
end

function giveBeerApple(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local bottleCount = inv:getItemCountFromTypeRecurse("Base.BeerEmpty")
    if bottleCount < 12 then
        getSpecificPlayer(0):Say("I need 12 empty beer bottles.")
        return
    end
    -- Consume hops
    for i = 1, 12 do
        local bottleItem = inv:getFirstType("Base.BeerEmpty")
        if bottleItem then
            inv:Remove(bottleItem)
        end
    end
    inv:AddItem('Deadline.BeerFruitApple')
    inv:AddItem('Deadline.BeerFruitApple')
    inv:AddItem('Deadline.BeerFruitApple')
    inv:AddItem('Deadline.BeerFruitApple')
    inv:AddItem('Deadline.BeerFruitApple')
    inv:AddItem('Deadline.BeerFruitApple')
    inv:AddItem('Deadline.BeerFruitApple')
    inv:AddItem('Deadline.BeerFruitApple')
    inv:AddItem('Deadline.BeerFruitApple')
    inv:AddItem('Deadline.BeerFruitApple')
    inv:AddItem('Deadline.BeerFruitApple')
    inv:AddItem('Deadline.BeerFruitApple')
    local modData = tile:getModData()
    modData.isBrewing = false
    tile:transmitModData()
end

function giveBeerPear(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local bottleCount = inv:getItemCountFromTypeRecurse("Base.BeerEmpty")
    if bottleCount < 12 then
        getSpecificPlayer(0):Say("I need 12 empty beer bottles.")
        return
    end
    -- Consume hops
    for i = 1, 12 do
        local bottleItem = inv:getFirstType("Base.BeerEmpty")
        if bottleItem then
            inv:Remove(bottleItem)
        end
    end
    inv:AddItem('Deadline.BeerFruitPear')
    inv:AddItem('Deadline.BeerFruitPear')
    inv:AddItem('Deadline.BeerFruitPear')
    inv:AddItem('Deadline.BeerFruitPear')
    inv:AddItem('Deadline.BeerFruitPear')
    inv:AddItem('Deadline.BeerFruitPear')
    inv:AddItem('Deadline.BeerFruitPear')
    inv:AddItem('Deadline.BeerFruitPear')
    inv:AddItem('Deadline.BeerFruitPear')
    inv:AddItem('Deadline.BeerFruitPear')
    inv:AddItem('Deadline.BeerFruitPear')
    inv:AddItem('Deadline.BeerFruitPear')
    local modData = tile:getModData()
    modData.isBrewing = false
    tile:transmitModData()
end

function giveVodka(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local bottleCount = inv:getItemCountFromTypeRecurse("Base.BeerEmpty")
    if bottleCount < 4 then
        getSpecificPlayer(0):Say("I need 4 empty vine bottles.")
        return
    end
    -- Consume hops
    for i = 1, 4 do
        local bottleItem = inv:getFirstType("Base.BeerEmpty") -- use a wine bottle item instead - Milo
        if bottleItem then
            inv:Remove(bottleItem)
        end
    end
    inv:AddItem('Deadline.Vodka')
    inv:AddItem('Deadline.Vodka')
    inv:AddItem('Deadline.Vodka')
    inv:AddItem('Deadline.Vodka')
    local modData = tile:getModData()
    modData.isBrewing = false
    tile:transmitModData()
end