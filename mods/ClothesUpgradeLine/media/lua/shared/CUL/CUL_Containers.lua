ClothesUpgrade = ClothesUpgrade or {}

function ClothesUpgrade.isBackpack(item)
    return item ~= nil and instanceof(item, "InventoryContainer") and item:canBeEquipped() == "Back"
end

function ClothesUpgrade.resetNonBackpackContainers(character)
    if not character or string.lower(character:getAccessLevel()) == "admin" then return end
    local items = character:getInventory():getAllEvalRecurse(function(item)
        return instanceof(item, "InventoryContainer") and not ClothesUpgrade.isBackpack(item)
    end)
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        -- B41 script items have no capacity/reduction getters; use a fresh instance.
        local defaults = InventoryItemFactory.CreateItem(item:getFullType())
        if defaults then
            item:setCapacity(defaults:getCapacity())
            item:setWeightReduction(defaults:getWeightReduction())
            item:getContainer():setDrawDirty(true)
        end
    end
end
