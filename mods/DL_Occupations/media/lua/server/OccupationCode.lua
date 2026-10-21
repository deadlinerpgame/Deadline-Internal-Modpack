function Recipe.OnCreate.OE_SawLogs(items, result, player)
    if player:getPerkLevel(Perks.Woodwork) >= 10 then
        local plankCount = 1;

	    local chance = player:getPerkLevel(Perks.Woodwork)*10;
	    if ZombRand(0,100) < chance then
            plankCount = plankCount + 1;
	    end

        local square = player:getSquare();
        for i = 1, plankCount do
            square:AddWorldInventoryItem("Base.Plank", 0, 0, 0);
        end
        -- removed prints (performance), added math.max for any overflow silliness
	    player:getStats():setStress(math.max(0, player:getStats():getStress() - 0.2));
	    player:getBodyDamage():setBoredomLevel(math.max(0, player:getBodyDamage():getBoredomLevel() - 10));
	    player:getBodyDamage():setUnhappynessLevel(math.max(0, player:getBodyDamage():getUnhappynessLevel() - 5));
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
    local parts = recipe:getSource():get(0):getItems()
    local condition, count = 0, 0
    for i = 0, ingredients:size() - 1 do
        local item = ingredients:get(i)
        if parts:contains(item:getFullType()) then
            condition = condition + item:getCondition() / item:getConditionMax()
            count = count + 1
        end
    end
    if count > 0 then
        result:setCondition(math.floor(result:getConditionMax() * condition / count + 0.5))
    end
    player:getXp():AddXP(Perks.Mechanics, 5);
end

function Recipe.OnTest.OE_IsRottenFood(item)
    if item:isRotten() then 
        return true;
    else
        return false;
    end
end


function Recipe.OnTest.ProfForager2_TestCritter(item)
    if item:getUnhappyChange() > 0 then
        return true;
    else
        return false;
    end
end


function Recipe.OnCreate.ProfForager2_PrepareCritter(items, result, player, selectedItem)
    local source = items:get(0)
    local itemType = source:getFullType()
    local newItem = InventoryItemFactory.CreateItem(itemType)
    
    if newItem then
        newItem:setUnhappyChange(0)
        newItem:setPoisonPower(0)
        newItem:setPoisonDetectionLevel(0)

        if source:isCooked() then
            newItem:setCooked(true)
        end
        newItem:setAge(source:getAge())
        player:getInventory():AddItem(newItem)
    end
end