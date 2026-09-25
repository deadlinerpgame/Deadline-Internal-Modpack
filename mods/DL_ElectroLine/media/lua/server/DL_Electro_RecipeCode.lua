Recipe = Recipe or {}
Recipe.OnCreate = Recipe.OnCreate or {}
Recipe.OnGiveXP = Recipe.OnGiveXP or {}

function Recipe.OnCreate.GiveEmptyMethaneTank(items, result, player)
    player:getInventory():AddItem("EmptyMethaneTank");
end

function Recipe.OnCreate.MakePropaneTankEmpty(items, result, player)
    if result then
        result:setUsedDelta(0);
    end
end

function Recipe.OnCreate.ReturnBottleOrCan(items, result, player)
    local item, itemType;
    local ropeItems = {};
    for i = 0, items:size() - 1 do
        item = items:get(i);
        if item then
            itemType = item:getFullType();
            if itemType == "Base.Disinfectant" then
                return
            else

            end;
        end;
    end;
end

if not Recipe.OnGiveXP.Cultivation20 then
    function Recipe.OnGiveXP.Cultivation20(recipe, ingredients, result, player)
        player:getXp():AddXP(Perks.Farming, 20)
    end
end
