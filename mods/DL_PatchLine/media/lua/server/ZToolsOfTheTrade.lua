function Recipe.OnCreate.TransferCondition(items, result, player, oldItem, firstHand, secondHand)
    result:getModData()["AlloyType"] = oldItem:getModData()["AlloyType"] or "";
    result:setCondition(oldItem:getCondition());
    result:setMaxCondition(oldItem:getMaxCondition());
    result:setWeight(oldItem:getWeight());
    result:setMinDamage(oldItem:getMinDamage());
    result:setMaxDamage(oldItem:getMaxDamage());
    result:setConditionLowerChance(oldItem:getConditionLowerChance());
    result:setCriticalChance(oldItem:getCriticalChance());
    
    if secondHand or firstHand then
        if not player:getPrimaryHandItem() then
            player:setPrimaryHandItem(result);
        end
        player:setPrimaryHandItem(result);
    end
end