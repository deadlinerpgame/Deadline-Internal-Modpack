require "recipecode"
require "DL_Forge"

-- Separate ingot and bar inputs let B41 filter each alloy independently.
local function matchesAlloys(item, ingotAlloy, barAlloy)
    local required
    if item:getFullType() == "aerx.IronBar" then
        required = barAlloy
        if not required then return false end
    elseif item:hasTag("DLIngot") then
        required = ingotAlloy
    else
        return true
    end
    local material = DL.Forge.materialOf(item)
    return material ~= nil and material.alloyId == required
end

function Recipe.OnTest.DLBuildworksLatheAlloy(item)
    return matchesAlloys(item, "cast_iron", "bronze")
end

function Recipe.OnTest.DLBuildworksCementMixerAlloy(item)
    return matchesAlloys(item, "steel", nil)
end

function Recipe.OnTest.DLBuildworksPrecisionFabricatorAlloy(item)
    return matchesAlloys(item, "steel", "invar")
end
