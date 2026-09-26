ClothesUpgrade = ClothesUpgrade or {}

local NEEDLE = { "Base.Needle" }

local function insulationTrack()
    return {
        stat = "insulation", perStep = 0.07, maxLevel = 4, maxBonus = 0.28,
        difficulty = "normal", tools = NEEDLE,
        levels = {
            { skillMin = 1, xp = 6,  items = { { item = "Base.RippedSheets", count = 2 }, { item = "Base.Thread", count = 2 } } },
            { skillMin = 2, xp = 8,  items = { { item = "Base.RippedSheets", count = 3 }, { item = "Base.Thread", count = 3 } } },
            { skillMin = 4, xp = 11, items = { { item = "Base.RippedSheets", count = 4 }, { item = "Base.Thread", count = 4 } }, difficulty = "hard" },
        },
    }
end

local function windTrack()
    return {
        stat = "windResistance", perStep = 0.07, maxLevel = 3, maxBonus = 0.21,
        difficulty = "normal", tools = NEEDLE,
        levels = {
            { skillMin = 1, xp = 6,  items = { { item = "Base.RippedSheets", count = 2 }, { item = "Base.Thread", count = 2 } } },
            { skillMin = 3, xp = 9,  items = { { item = "Base.DenimStrips", count = 2 }, { item = "Base.Thread", count = 3 } }, difficulty = "hard" },
        },
    }
end

local function waterTrack()
    return {
        stat = "waterResistance", perStep = 0.06, maxLevel = 3, maxBonus = 0.18,
        difficulty = "hard", tools = NEEDLE,
        levels = {
            { skillMin = 2, xp = 8,  items = { { item = "Base.RippedSheets", count = 2 }, { item = "Base.Glue", count = 1 }, { item = "Base.Thread", count = 2 } } },
            { skillMin = 4, xp = 12, items = { { item = "Base.DenimStrips", count = 2 }, { item = "Base.Glue", count = 1 }, { item = "Base.Thread", count = 3 } } },
        },
    }
end

local function scratchTrack()
    return {
        stat = "scratchDefense", perStep = 1, maxLevel = 4,
        difficulty = "normal", tools = NEEDLE,
        levels = {
            { skillMin = 1, xp = 7,  items = { { item = "Base.DenimStrips", count = 2 }, { item = "Base.Thread", count = 3 } } },
            { skillMin = 3, xp = 10, items = { { item = "Base.DenimStrips", count = 3 }, { item = "Base.Thread", count = 4 } }, difficulty = "hard" },
            { skillMin = 5, xp = 14, items = { { item = "Base.LeatherStrips", count = 2 }, { item = "Base.Thread", count = 4 } }, difficulty = "expert" },
        },
    }
end

local function biteTrack()
    return {
        stat = "biteDefense", perStep = 1, maxLevel = 4,
        difficulty = "hard", tools = NEEDLE,
        levels = {
            { skillMin = 3, xp = 10, items = { { item = "Base.LeatherStrips", count = 2 }, { item = "Base.Thread", count = 4 } } },
            { skillMin = 5, xp = 15, items = { { item = "Base.LeatherStrips", count = 3 }, { item = "Base.Thread", count = 5 } }, difficulty = "expert" },
        },
    }
end

local function genericTracks()
    return { insulationTrack(), windTrack(), waterTrack(), scratchTrack() }
end

ClothesUpgrade.ApparelDefaults = {
    generic = { tracks = genericTracks() },

    torso = { tracks = { insulationTrack(), windTrack(), waterTrack(),
                         scratchTrack(), biteTrack() } },

    legs  = { tracks = { insulationTrack(), windTrack(), waterTrack(),
                         scratchTrack(), biteTrack() } },

    head  = { tracks = { insulationTrack(), windTrack(),
                         scratchTrack(), biteTrack() } },

    feet  = { tracks = { insulationTrack(), waterTrack(), scratchTrack() } },

    hands = { tracks = { insulationTrack(), scratchTrack() } },
}

ClothesUpgrade.ApparelProfiles = {}
