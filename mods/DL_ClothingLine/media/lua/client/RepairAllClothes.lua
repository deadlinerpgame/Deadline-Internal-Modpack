function RepairAllClothes()
    local items = getAllItems();
    for i = 0, items:size() - 1 do
        local item = items:get(i);
        local fabricType = item:getFabricType();
        -- NbrOfCoveredParts from java\inventory\types\Clothing.java
        local NbrOfCoveredParts = BloodClothingType.getCoveredPartCount(item:getBloodClothingType())
        if fabricType == nil and NbrOfCoveredParts > 0 then
            item:DoParam("FabricType = Leather");
        end
    end
end

Events.OnGameBoot.Add(RepairAllClothes)