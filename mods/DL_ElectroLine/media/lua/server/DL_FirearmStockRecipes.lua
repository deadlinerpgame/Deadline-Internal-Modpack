require "recipecode"
require "DL_Forge"

local function matchesAlloy(alloy)
    return function(item)
        if item:getFullType() ~= "aerx.IronBar" then return true end
        local material = DL.Forge.materialOf(item)
        return material ~= nil and material.alloyId == alloy
    end
end

Recipe.OnTest.DLFirearmStock_brass = matchesAlloy("brass")
Recipe.OnTest.DLFirearmStock_bronze = matchesAlloy("bronze")
Recipe.OnTest.DLFirearmStock_steel = matchesAlloy("steel")
Recipe.OnTest.DLFirearmStock_stainless_steel = matchesAlloy("stainless_steel")
Recipe.OnTest.DLFirearmStock_gunmetal = matchesAlloy("gunmetal")
