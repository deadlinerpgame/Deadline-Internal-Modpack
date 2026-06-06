DL = DL or {}
DL.Config = DL.Config or {}
local C = DL.Config


--   condition = { trait = "Herbalist" }                 -- must have the trait
--   condition = { skill = "MetalWelding", level = 6 }   -- that perk >= level

C.forageLists = C.forageLists or {
    {
        name       = "Scrap Cache",
        enabled    = false,   -- set true if in use
        condition  = { skill = "MetalWelding", level = 6 },
        categories = { "Junk" },
        zones      = { TownZone = 50, TrailerPark = 50, Forest = 20 },
        items = {
            { type = "Base.ScrapMetal",       min = 1, max = 3, xp = 5 },
            { type = "Base.SmallSheetMetal",  min = 1, max = 1, xp = 8 },
        },
    },
    {
        name       = "Herbalist's Eye",
        enabled    = false,
        condition  = { trait = "Herbalist" },
        categories = { "MedicinalPlants" },
        zones      = { Forest = 6, DeepForest = 8 },
        items = {
            { type = "Base.Plantain", min = 2, max = 4, xp = 6 },
        },
    },
}

DL.log("forage config loaded (" .. tostring(#C.forageLists) .. " list(s) defined)")
