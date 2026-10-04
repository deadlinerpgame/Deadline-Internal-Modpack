ClothesUpgrade = ClothesUpgrade or {}

local NEEDLE = { "Base.Needle" }

local function capacityTrack()
    return {
        id = "capacity", stat = "capacity",
        perStep = 3, maxValue = 40,
        difficulty = "normal", tools = NEEDLE,
        levels = {
            { skillMin = 2, xp = 8,  items = { { item = "Base.DenimStrips", count = 3 }, { item = "Base.Thread", count = 3 } } },
            { skillMin = 4, xp = 12, items = { { item = "Base.DenimStrips", count = 4 }, { item = "Base.Thread", count = 4 } }, difficulty = "hard" },
            { skillMin = 6, xp = 16, items = { { item = "Base.LeatherStrips", count = 3 }, { item = "Base.Thread", count = 5 } }, difficulty = "hard" },
            { skillMin = 8, xp = 22, items = { { item = "Base.LeatherStrips", count = 5 }, { item = "Base.Thread", count = 6 } }, difficulty = "expert" },
        },
    }
end

local function weightTrack()
    return {
        id = "weightReduction", stat = "weightReduction",
        perStep = 5, maxValue = 90,
        difficulty = "hard", tools = NEEDLE,
        levels = {
            { skillMin = 3, xp = 10, items = { { item = "Base.LeatherStrips", count = 2 }, { item = "Base.Thread", count = 4 } } },
            { skillMin = 5, xp = 14, items = { { item = "Base.LeatherStrips", count = 3 }, { item = "Base.DenimStrips", count = 2 }, { item = "Base.Thread", count = 5 } } },
            { skillMin = 7, xp = 20, items = { { item = "Base.LeatherStrips", count = 4 }, { item = "Base.DenimStrips", count = 3 }, { item = "Base.Thread", count = 6 } }, difficulty = "expert" },
        },
    }
end

ClothesUpgrade.PackDefaults = {
    generic = { tracks = { capacityTrack(), weightTrack() } },
}

ClothesUpgrade.PackProfiles = {}
