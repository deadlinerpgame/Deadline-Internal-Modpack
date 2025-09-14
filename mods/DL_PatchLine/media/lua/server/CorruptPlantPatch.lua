require "Farming/farming_vegetableconf";

if isClient() then return end;

local original_badPlant = badPlant or {};

function badPlant(water, waterMax, diseaseLvl, plant, nextGrowing, updateNbOfGrow)
    if not plant then return end;

    if not water then 
        water = 30;
        plant.health = 50;
    end;

    if not diseaseLvl then diseaseLvl = 0 end;

	if not waterMax then waterMax = 1 end;

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