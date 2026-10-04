local group = BodyLocations.getGroup("Human")

-- B41 has no native per-limb pad slots, so recreate the four B42 locations.
group:getOrCreateLocation("KneeLeft")
group:getOrCreateLocation("KneeRight")
group:getOrCreateLocation("ElbowLeft")
group:getOrCreateLocation("ElbowRight")

-- Recreate the applicable B42 hide relationships using B41 location names.
-- B42 calf-armour exclusivity cannot be copied because B41 has no calf slots.
group:setHideModel("Dress", "KneeLeft")
group:setHideModel("Dress", "KneeRight")
group:setHideModel("Dress", "ElbowLeft")
group:setHideModel("Dress", "ElbowRight")
group:setHideModel("FullSuit", "KneeLeft")
group:setHideModel("FullSuit", "KneeRight")
group:setHideModel("FullSuit", "ElbowLeft")
group:setHideModel("FullSuit", "ElbowRight")
group:setHideModel("FullSuitHead", "KneeLeft")
group:setHideModel("FullSuitHead", "KneeRight")
group:setHideModel("FullSuitHead", "ElbowLeft")
group:setHideModel("FullSuitHead", "ElbowRight")
