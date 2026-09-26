local group = BodyLocations.getGroup("Human")

-- B42 wearable-container locations not present in B41.
group:getOrCreateLocation("Satchel")
group:getOrCreateLocation("Webbing")

-- Compatibility locations used by ClothesBOX and Hayes Custom rigs.
-- Creating them here also makes this independent of mod Lua load order.
group:getOrCreateLocation("010")
group:getOrCreateLocation("668")
group:getOrCreateLocation("TorsoRigPlus2")

group:setExclusive("Webbing", "010")
group:setExclusive("Webbing", "668")
group:setExclusive("Webbing", "TorsoRigPlus2")
