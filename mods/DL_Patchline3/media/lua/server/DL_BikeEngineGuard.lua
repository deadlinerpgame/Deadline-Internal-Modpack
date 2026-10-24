require "recipecode"
require "Vehicles/Vehicles"

-- This should make it not spawn on vehicles
function Vehicles.Create.DL_BikeEngineGuard(vehicle, part)
end

-- OnTest, lookup specific item and it's alloy type, only works if we require a single alloy. Note to self, do not add the same item in 2 fields, that will break recipes. Do 1 recipe requireing ingot, 2nd requireing bar like Deadline-Internal-Modpack\mods\BuildworkItemsB41\media\scripts\knox_buildworks_kit_recipes.txt or special items.
function Recipe.OnTest.DL_BikeEngineGuardAlloy(item)
    if item:getFullType() ~= "aerx.IronBar" then return true end
    local alloy = item:getModData().DLMade
    return alloy ~= nil and alloy.alloyId == "steel"
end
