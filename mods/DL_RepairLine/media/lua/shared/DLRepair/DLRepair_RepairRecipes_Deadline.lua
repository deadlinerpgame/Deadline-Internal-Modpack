require "DLRepair/DLRepair_RepairRecipes"

DLRepair = DLRepair or {}
DLRepair.Profiles = DLRepair.Profiles or {}

local TAPE     = { difficulty = "easy",   restore = 0.35 }
local GLUE     = { difficulty = "normal", restore = 0.45 }
local MATERIAL = { difficulty = "normal", restore = 0.70 }

local function option(kind, item, count)
    return { difficulty = kind.difficulty, restore = kind.restore, items = { { item = item, count = count } } }
end

local function add(weapon, ...)
    if DLRepair.Profiles[weapon] then return end
    local options = {}
    for _, req in ipairs({ ... }) do
        local kind = (req[1] == "Base.DuctTape" and TAPE) or (req[1] == "Base.Glue" and GLUE) or MATERIAL
        options[#options + 1] = option(kind, req[1], req[2])
    end
    DLRepair.Profiles[weapon] = { options = options }
end

add("aerx.HatchetHead_Bone", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.SharpBone_Long", 1 })
add("aerx.JawboneBovide_Axe", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.SharpBone_Long", 1 })
add("aerx.MeatCleaver_Scrap", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.ScrapWeapon_Brake", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.Axe_ScrapCleaver", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.ScrapWeaponSpade", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })

add("aerx.CrudeShortSword", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 5 })
add("aerx.CrudeSword", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 5 })
add("aerx.Machete_Crude", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 5 })
add("aerx.MacheteForged", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 5 })
add("aerx.ShortSword", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 5 })
add("aerx.ShortSword_Scrap", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 5 })
add("aerx.Sword", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 5 })
add("aerx.Sword_Scrap", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 5 })

add("aerx.BaseballBat_Can", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.BaseballBat_GardenForkHead", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.BaseballBat_Nails", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.BaseballBat_RakeHead", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.BaseballBat_ScrapSheet", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.BucketMace_Metal", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.FieldHockeyStick_Nails", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.JawboneBovide_Morningstar", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.SharpBone_Long", 1 })
add("aerx.KettleMace_Metal", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.ScrapWeaponRakeHead", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.ScrapMaul", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.Morningstar_Scrap", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })

add("aerx.SharpBone_Long", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.SharpBone_Long", 1 })
add("aerx.LargeKnife_Scrap", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.CrudeBlade", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.CrudeKnife", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.LongCrudeBlade", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.LongCrudeKnife", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })

add("aerx.ShortBat", { "Base.DuctTape", 2 }, { "Base.Glue", 2 })
add("aerx.ShortBat_Can", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.ShortBat_Nails", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.ShortBat_RakeHead", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.Morningstar_Scrap_Short", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.JawboneBovide_Club", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.SharpBone_Long", 1 })

add("aerx.Spear_Bone", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.SharpBone_Long", 1 })
add("aerx.Spear_BoneLong", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.SharpBone_Long", 1 })
add("aerx.SpearCrude", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.SpearCrudeLong", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.IronFragments", 2 })
add("aerx.SpearStone", { "Base.DuctTape", 2 }, { "Base.Stone", 1 })
add("aerx.SpearStoneLong", { "Base.DuctTape", 2 }, { "Base.Stone", 1 })

add("ToolsOfTheTrade.DefilerAxe", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.DefilerSledgehammer", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.DespoilerAxe", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.DespoilerSledgehammer", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.IndustrialWrench", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.RailroadHammer", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.SpiritLevel", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.GrassScythe", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.ShaolinSpade", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.CrashAxe", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.Kukri", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.Tomahawk", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.FairbairnSykesKnife", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.CavalrySabre", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.BeardedAxe", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.Trident", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.Kanabo", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.BrownBessMusket", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.MeatHook", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.Seax", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.GladiusSlash", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.GladiusStab", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.HarpoonSpear", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.IndustrialPipeWrench", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.KebabSkewer", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.ExecutionersSword", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
add("ToolsOfTheTrade.RailwaySpikeHammer", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "aerx.IronFragments", 8 })
