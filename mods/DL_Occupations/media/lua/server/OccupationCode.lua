function Recipe.OnCreate.OE_SawLogs(items, result, player)
    if player:HasTrait("profcarpenter") then
        local plankCount = 1;

	    local chance = player:getPerkLevel(Perks.Woodwork)*10;
	    if ZombRand(0,100) < chance then
            plankCount = plankCount + 1;
	    end

        local square = player:getSquare();
        for i = 1, plankCount do
            square:AddWorldInventoryItem("Base.Plank", 0, 0, 0, true);
        end

	    player:getStats():setStress(player:getStats():getStress() - 0.2);
		print(player:getStats():getStress());
	    player:getBodyDamage():setBoredomLevel(player:getBodyDamage():getBoredomLevel() - 10);
		print(player:getBodyDamage():getBoredomLevel());
	    player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - 5);
		print(player:getBodyDamage():getUnhappynessLevel())
    end
end





function Recipe.OnTest.OE_IsPoisonousFood(item)
	if not item:IsFood() then
		return true;
	end
    if item:isPoison() then 
        return true;
    else
        return false;
    end
end


function Recipe.OnCreate.OE_PerformPoisonCleaning(items, result, player)
	local foodItemSource = items:get(0);
	local sourceAge = foodItemSource:getAge();
	local sourceHunger = foodItemSource:getBaseHunger();
	result:setAge(sourceAge);
	result:setHungChange(sourceHunger);
end


function Recipe.OnGiveXP.OE_MergeCarParts(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Mechanics, 5);
end

function Recipe.OnTest.OE_IsRottenFood(item)
    if item:isRotten() then 
        return true;
    else
        return false;
    end
end


function Recipe.OnCreate.ProfForager2_TestCritter(item)
    if item:getUnhappyChange() > 0 then
        return true;
    else
        return false;
    end
end


function Recipe.OnCreate.ProfForager2_PrepareCritter(items, result, player, selectedItem)
    local itemType = selectedItem:getFullType()
    player:getInventory():Remove(result)
    local newItem = InventoryItemFactory.CreateItem(itemType)
    
    if newItem then
        newItem:setUnhappyChange(0)
        newItem:setPoisonPower(0)
        newItem:setPoisonDetectionLevel(0)

        if selectedItem:isCooked() then
            newItem:setCooked(true)
        end
        if selectedItem:isFresh() then
            newItem:setAge(selectedItem:getAge())
        end
        player:getInventory():AddItem(newItem)
    end
end