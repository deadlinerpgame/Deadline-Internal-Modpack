DL = DL or {}
DL.Config = DL.Config or {}
local C = DL.Config

C.forageLists = C.forageLists or {
    {
        name       = "Scrap Cache",
        enabled    = true,
        condition  = { skill = "MetalWelding", level = 6 },
        categories = { "Trash" },
        zones      = { TownZone = 5000, TrailerPark = 5000, Forest = 2000, DeepForest = 2000},
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
