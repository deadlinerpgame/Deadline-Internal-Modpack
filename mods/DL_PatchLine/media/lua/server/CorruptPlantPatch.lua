if isClient() then return end

require "Farming/farming_vegetableconf";
require "Farming/SFarmingSystem";
require "Map/SGlobalObjectSystem";
SFarmingSystem = SFarmingSystem or {};

local original_badPlant = badPlant or {};

function badPlant(water, waterMax, diseaseLvl, plant, nextGrowing, updateNbOfGrow)

    local buggedProp = nil;

    if not plant then
        print("[PatchLine - badPlantPatch] Called with nil plant!");
        return 
    end;

    if not water then 
        water = 1;
        buggedProp = "water";
    end;

    if not diseaseLvl then 
        buggedProp = "diseaseLvl";
        diseaseLvl = 0;
    end;

	if not waterMax then
        waterMax = 1;
        buggedProp = "waterMax";
    end;

    if buggedProp and buggedProp ~= "" then
        print("[PatchLine] badPlant called with nil prop: " .. tostring(buggedProp));
        if plant:getSquare() then
            local square = plant:getSquare();
            print("[PatchLine - badPlantPatch]" .. tostring(square:getX()) .. "," .. tostring(square:getY()) .. "," .. tostring(square:getZ()));
        end
    end

	-- if we're here, it's because we didn't take well care of our plant, so we notice it, we'll have less xp from this plant
	if water <= -1 or waterMax <= -1 then
		plant.badCare = true;
    end

    if diseaseLvl == -2 then -- our plant is dead if disease > 60
        plant:dryThis();
        return;
    end

	if water == -1 or waterMax == -1 or diseaseLvl == -1 then-- we report our growing
		plant.nextGrowing = calcNextGrowing(nextGrowing, 30);
		if updateNbOfGrow then
			plant.nbOfGrow = plant.nbOfGrow -1;
        end
        return;
    end

    plant.nextGrowing = calcNextGrowing(nextGrowing, 50);
    plant.health = plant.health - 4;
    if updateNbOfGrow then
        plant.nbOfGrow = plant.nbOfGrow -1;
    end
end


local original_SFarmingSystem_harvest = SFarmingSystem.harvest;

function SFarmingSystem:harvest(luaObject, player)
    local farmingLevel = player:getPerkLevel(Perks.Farming);
    
    luaObject.harvestedByLvl = farmingLevel or 0;
    original_SFarmingSystem_harvest(self, luaObject, player);

    luaObject.harvestedByLvl = nil;
end

local PatchLine_GetVegetablesNumberOriginal = _G["getVegetablesNumber"];

_G["getVegetablesNumber"] = function(min, max, minAuthorised, maxAuthorised, plant)
    -- Basic nil value prevention (there's a lot of invalid plant stats cropping up!)
    if not plant then return 0 end;

    if not plant.health then
        plant.health = 0;
    end;
    
    local minMaxDifference = maxAuthorised - minAuthorised;

    -- Health modifier is: for every 10 HP points over 50, gain 1 more vegetable (base game).
    -- This means you can gain up to 5 extra veg in a harvest if at good HP.
    local healthModifier = math.floor((plant.health - 50) / 10);
	if healthModifier < 0 then
		healthModifier = 0;
    end

    -- Next is the server's difficulty modifier. This affects the min and max authorised value limits.
    -- e.g. 1 - 3 at modifier -4 becomes -3 to -1. 
    local difficultyModifier = 0;
    if SandboxVars.PlantAbundance == 1 then -- Very Poor
        difficultyModifier = -4;
    elseif SandboxVars.PlantAbundance == 2 then -- Poor
        difficultyModifier = -2;
    elseif SandboxVars.PlantAbundance == 4 then -- Abundant
        difficultyModifier = 3;
    elseif SandboxVars.PlantAbundance == 5 then -- Very Abundant
        difficultyModifier = 5;
    end

    local modifierBonus = healthModifier + difficultyModifier;
    local minV = min + modifierBonus; -- The absolute minimum with modifiers.
    local maxV = max + modifierBonus; -- As above but max.

    -- We want to make sure that the difficulty modifier doesn't take us below 1. If it does, set it to 1.
    local minAuthorisedWithDifficulty = minAuthorised + difficultyModifier;
    local maxAuthorisedWithDifficulty = maxAuthorised + difficultyModifier;

    if minAuthorisedWithDifficulty < 1 then
        minAuthorisedWithDifficulty = 1;
    end 

    if maxAuthorisedWithDifficulty < minAuthorisedWithDifficulty or maxAuthorisedWithDifficulty < 1 then
        maxAuthorisedWithDifficulty = math.ceil(minAuthorisedWithDifficulty + minMaxDifference); -- Maintain the difference between the min and max despite modifiers.
    end

    if minV > minAuthorisedWithDifficulty then
        minV = minAuthorisedWithDifficulty
    end

    if maxV > maxAuthorisedWithDifficulty then
        maxV = maxAuthorisedWithDifficulty;
    end

    local nbOfVegetable = ZombRand(minV, maxV + 1);

    if not plant.aphidLvl then
        plant.aphidLvl = 0;
    end

    -- Lower harvest by 1 per every 10 aphid level.
	local aphidModifier = math.floor(plant.aphidLvl / 10);
	nbOfVegetable = nbOfVegetable - aphidModifier;

    -- Now modify number of vegetables by level between 6 and 10.
    -- And remove 1 from harvest if won't take to 0.
    if plant.harvestedByLvl then
        local lvl = plant.harvestedByLvl;
        if lvl < 6 and nbOfVegetable > 1 then
            nbOfVegetable = nbOfVegetable - 1;
        end

        if lvl > 6 then
            -- For every level from 6 add 10%, so at nbOfVegetable = 5, with farming 10, this would be:
            -- 5 * (0.1 * 4) = 5 * 0.4 = 2
            local lvlsOverThreshold = lvl - 6;
            local totalExtraHarvest = Math.ceil(nbOfVegetable * (0.1 * lvlsOverThreshold));

            nbOfVegetable = nbOfVegetable + totalExtraHarvest;
        end
    end

    if nbOfVegetable < 1 and aphidModifier > 5 then -- This means if you don't treat the aphid level you will get 0 crops on an unlucky roll.
        return 0;
    elseif nbOfVegetable < 1 then
        return 1;
    else
        return nbOfVegetable;
    end
end

local original_rottenThis = SPlantGlobalObject["rottenThis"];

SPlantGlobalObject.rottenThis = function(self)
    if not self.typeOfSeed then return end;

    local isoObject = self:getObject();
    if not isoObject then return end;

    local cropName = tostring(self.typeOfSeed);
    local spriteName = tostring(self.spriteName);
    local coordString = string.format("%0d,%0d,%0d", isoObject:getX(), isoObject:getY(), isoObject:getZ());
    local state, nbOfGrow, health, badCare, exterior = self.state, self.nbOfGrow, self.health, tostring(self.badCare), tostring(self.exterior);
    local diseaseString = string.format("Mildew: %0d | Flies: %0d | DWF: %0d", self.mildewLvl or 0, self.fliesLvl or 0, self.aphidLvl or 0);
    local lastWaterHr, nextGrowing = tostring(self.lastWaterHour) or "never", self.nextGrowing or "not";
    local waterNeeded, waterMax = self.waterNeeded, self.waterNeededMax or 0;

    local logStr = string.format(
        "Crop %s (sprite: %s) at (%s) called rottenThis with stats: [State: %s] [Nb of Grow: %0d] [Disease: %s] [Water Needed: %0d] [Water Needed Max: %0d] [Last Water Hour: %0d] [Next Growing: %0d] [Health: %0d] [Bad Care: %s] [Exterior: %s]",
        cropName, spriteName, coordString, state, nbOfGrow, diseaseString, waterNeeded, waterMax, lastWaterHr, nextGrowing, health, badCare, exterior
    );

    writeLog("PlantDebugging", logStr);

    original_rottenThis(self);
end