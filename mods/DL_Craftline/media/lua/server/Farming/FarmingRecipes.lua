function Recipe.GetItemTypes.Skulls(scriptItems)
    local items = getScriptManager():getAllItems();
    for i = 0, items:size() - 1 do
        local item = items:get(i);
        if item:getName():contains("_Skull") and item:getDisplayCategory() == "AnimalPart" then
            scriptItems:add(item);
        end
    end
end

function Recipe.GetItemTypes.Bones(scriptItems)
    local scriptManager = getScriptManager();
    scriptItems:addAll(scriptManager:getItemsTag("SmallAnimalBone"));
    scriptItems:addAll(scriptManager:getItem("AnimalBone"));
    scriptItems:addAll(scriptManager:getItem("LargeAnimalBone"));
end