ClothesUpgrade = ClothesUpgrade or {}

ClothesUpgrade.Config = {
    perk = "Tailoring",

    packExclude = {
        ["Base.KeyRing"] = true,
        ["KeyRing"]      = true,
    },

    defaultDifficulty = "normal",

    consumeOnFailure = true,
    failXpFraction   = 0.34,

    baseActionTime        = 200,
    timePerLevelReduction = 10,
    minActionTime         = 60,

    defaultXp = 6,

    botch = {
        enabled        = true,
        chance         = 0.10,
        perLevelReduction = 0.007,
        minChance      = 0.01,
        maxPerGarment  = 3,
        pool = {
            { stat = "insulation",     amount = -0.06, weight = 3, label = "Thin patch" },
            { stat = "windResistance", amount = -0.06, weight = 3, label = "Loose weave" },
            { stat = "waterResistance",amount = -0.06, weight = 2, label = "Wicking seam" },
            { stat = "scratchDefense", amount = -1,    weight = 2, label = "Weak stitch" },
            { stat = "biteDefense",    amount = -1,    weight = 2, label = "Gap in lining" },
        },
    },

    dye = {
        enabled  = true,
        cost     = { { item = "ClothesUpgradeLine.FabricDye", count = 1 } },
        tools    = {},
        skillMin = 0,
    },

    windowWidth  = 860,
    windowHeight = 580,
}
