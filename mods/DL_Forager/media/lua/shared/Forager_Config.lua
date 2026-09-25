DL = DL or {}
DL.Config = DL.Config or {}
local C = DL.Config

C.forageLists = C.forageLists or {
    {
        name       = "Scrap Cache",
        enabled    = false,
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
    {
        name       = "Carrion Eye: Remains",
        enabled    = true,
        condition  = { trait = "carrion_eye" },
        categories = { "Junk" },
        zones      = { TownZone = 100, TrailerPark = 100, Nav = 100, Farm = 60, FarmLand = 60, Vegitation = 60, Forest = 60, DeepForest = 60 },
        items = {
            {
                type = "Base.Wallet", min = 1, max = 1, xp = 10,
                extras = {
                    rolls = { 1, 3 },
                    pool = {
                        { "Base.Money", 4 },
                        { "Base.Lighter", 3 },
                        { "Base.Matches", 3 },
                        { "Base.Cigarettes", 3 },
                        { "Base.KeyRing", 2 },
                        { "Base.Pills", 2 },
                        { "Base.PillsBeta", 1 },
                        { "Base.Bandage", 2 },
                        { "Base.Bullets9mm", 2 },
                        { "Base.Battery", 2 },
                        { "Base.HandTorch", 1 },
                        { "Base.Necklace_Gold", 1 },
                        { "Base.WristWatch_Left_ClassicBlack", 1 },
                        { "Base.Pen", 1 },
                        { "Base.Notebook", 1 },
                        { "Base.Chocolate", 2 },
                        { "Base.Crisps", 2 },
                        { "Base.KitchenKnife", 1 },
                        { "Base.Screwdriver", 1 },
                    },
                },
            },
        },
    },
    {
        name       = "Carrion Eye: Shallow Cache",
        enabled    = true,
        condition  = { trait = "carrion_eye" },
        categories = { "Junk" },
        zones      = { Forest = 100, DeepForest = 100, Vegitation = 100, Farm = 60, FarmLand = 60, Nav = 60, TrailerPark = 40, TownZone = 40 },
        items = {
            {
                type = "Base.GroceryBag1", min = 1, max = 1, xp = 10,
                contents = {
                    rolls = { 3, 5 },
                    pool = {
                        { "Base.TinnedBeans", 3 },
                        { "Base.CannedCorn", 3 },
                        { "Base.CannedChili", 2 },
                        { "Base.TunaTin", 2 },
                        { "Base.WaterBottleFull", 3 },
                        { "Base.Bandage", 3 },
                        { "Base.Disinfectant", 1 },
                        { "Base.Pills", 2 },
                        { "Base.Bullets9mm", 2 },
                        { "Base.ShotgunShells", 2 },
                        { "Base.Nails", 2 },
                        { "Base.DuctTape", 2 },
                        { "Base.Matches", 3 },
                        { "Base.Battery", 2 },
                        { "Base.Candle", 2 },
                        { "Base.Cigarettes", 2 },
                        { "Base.Money", 2 },
                        { "Base.Screwdriver", 1 },
                        { "Base.Hammer", 1 },
                        { "Base.HuntingKnife", 1 },
                    },
                },
            },
        },
    },
}

C.forageTraitBonuses = C.forageTraitBonuses or {
    tracker = {
        visionBonus     = 0,
        weatherEffect   = 0,
        darknessEffect  = 0,
        specialisations = { DeadAnimals = 100, Animals = 50 },
    },
}

if DL.log ~= nil then
    DL.log("forage config loaded (" .. tostring(#C.forageLists) .. " list(s) defined)")
end
