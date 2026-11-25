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
add("aerx.MeatCleaver_Scrap", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.ScrapWeapon_Brake", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.Axe_ScrapCleaver", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.ScrapWeaponSpade", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })

add("aerx.CrudeShortSword", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 5 })
add("aerx.CrudeSword", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 5 })
add("aerx.Machete_Crude", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 5 })
add("aerx.MacheteForged", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 5 })
add("aerx.ShortSword", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 5 })
add("aerx.ShortSword_Scrap", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 5 })
add("aerx.Sword", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 5 })
add("aerx.Sword_Scrap", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 5 })

add("aerx.BaseballBat_Can", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.BaseballBat_GardenForkHead", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.BaseballBat_Nails", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.BaseballBat_RakeHead", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.BaseballBat_ScrapSheet", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.BucketMace_Metal", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.FieldHockeyStick_Nails", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.JawboneBovide_Morningstar", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.SharpBone_Long", 1 })
add("aerx.KettleMace_Metal", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.ScrapWeaponRakeHead", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.ScrapMaul", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.Morningstar_Scrap", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })

add("aerx.SharpBone_Long", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.SharpBone_Long", 1 })
add("aerx.LargeKnife_Scrap", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.CrudeBlade", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.CrudeKnife", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.LongCrudeBlade", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.LongCrudeKnife", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })

add("aerx.ShortBat", { "Base.DuctTape", 2 }, { "Base.Glue", 2 })
add("aerx.ShortBat_Can", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.ShortBat_Nails", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.ShortBat_RakeHead", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.Morningstar_Scrap_Short", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.JawboneBovide_Club", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.SharpBone_Long", 1 })

add("aerx.Spear_Bone", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.SharpBone_Long", 1 })
add("aerx.Spear_BoneLong", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "aerx.SharpBone_Long", 1 })
add("aerx.SpearCrude", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.SpearCrudeLong", { "Base.DuctTape", 2 }, { "Base.Glue", 2 }, { "DL_MetalLine.Scrap_Iron_S", 2 })
add("aerx.SpearStone", { "Base.DuctTape", 2 }, { "Base.Stone", 1 })
add("aerx.SpearStoneLong", { "Base.DuctTape", 2 }, { "Base.Stone", 1 })

add("ToolsOfTheTrade.DefilerAxe", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.DefilerSledgehammer", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.DespoilerAxe", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.DespoilerSledgehammer", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.IndustrialWrench", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.RailroadHammer", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.SpiritLevel", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.GrassScythe", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.ShaolinSpade", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.CrashAxe", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.Kukri", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.Tomahawk", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.FairbairnSykesKnife", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.CavalrySabre", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.BeardedAxe", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.Trident", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.Kanabo", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.BrownBessMusket", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.MeatHook", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.Seax", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.GladiusSlash", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.GladiusStab", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.HarpoonSpear", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.IndustrialPipeWrench", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.KebabSkewer", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.ExecutionersSword", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })
add("ToolsOfTheTrade.RailwaySpikeHammer", { "Base.DuctTape", 3 }, { "Base.Glue", 3 }, { "DL_MetalLine.Scrap_Iron_S", 8 })

-- List of firearms to apply the repair recipes to
local firearmTypes = {
    "Base.AC556",
    "Base.AC556Short",
    "Base.AK47",
    "Base.AK47Bayonet",
    "Base.AK47S",
    "Base.AR15",
    "Base.AR15Bayonet",
    "Base.AR15Short",
    "Base.AssaultRifle",
    "Base.AssaultRifle2",
    "Base.AssaultRifle2Short",
    "Base.AssaultRifleBayonet",
    "Base.AssaultRifleShort",
    "Base.BrowningAR",
    "Base.BrowningARShort",
    "Base.ColtAce",
    "Base.ColtAnaconda",
    "Base.ColtPeacemaker",
    "Base.ColtPython",
    "Base.ColtPythonHunter",
    "Base.ColtPythonStubby",
    "Base.ColtSingleAction22",
    "Base.DLAC556",
    "Base.DLAC556Short",
    "Base.DLAK47",
    "Base.DLAK47Bayonet",
    "Base.DLAK47S",
    "Base.DLAR15",
    "Base.DLAR15Bayonet",
    "Base.DLAR15Short",
    "Base.DLAssaultRifle",
    "Base.DLAssaultRifle2",
    "Base.DLAssaultRifle2Short",
    "Base.DLAssaultRifleBayonet",
    "Base.DLAssaultRifleShort",
    "Base.DLBrowningAR",
    "Base.DLBrowningARShort",
    "Base.DLColtAce",
    "Base.DLColtAnaconda",
    "Base.DLColtPeacemaker",
    "Base.DLColtPython",
    "Base.DLColtPythonHunter",
    "Base.DLColtPythonStubby",
    "Base.DLColtSingleAction22",
    "Base.DLDoubleBarrelShotgun",
    "Base.DLDoubleBarrelShotgunSawnoff",
    "Base.DLDoubleBarrelShotgunShort",
    "Base.DLFN_FAL",
    "Base.DLFN_FALShort",
    "Base.DLGlock17",
    "Base.DLHuntingRifle",
    "Base.DLHuntingRifleShort",
    "Base.DLHuntingRifle_Sawn",
    "Base.DLLAW12",
    "Base.DLM14A1",
    "Base.DLM14A1Short",
    "Base.DLM16A2",
    "Base.DLM16A2Bayonet",
    "Base.DLM16A2Short",
    "Base.DLM1887",
    "Base.DLM1887Sawn",
    "Base.DLM1887Short",
    "Base.DLM1903Springfield",
    "Base.DLM1903SpringfieldBayonet",
    "Base.DLM1903SpringfieldShort",
    "Base.DLM1903Springfield_Sawn",
    "Base.DLM1Garand",
    "Base.DLM1GarandBayonet",
    "Base.DLM24Rifle",
    "Base.DLM3Grease",
    "Base.DLM60",
    "Base.DLM633",
    "Base.DLM733",
    "Base.DLMP5",
    "Base.DLMac10",
    "Base.DLMini14",
    "Base.DLMini14Sawn",
    "Base.DLMini14Short",
    "Base.DLMossberg500",
    "Base.DLMossberg500Tactical",
    "Base.DLOUShotgun",
    "Base.DLOUShotgunSawnoff",
    "Base.DLOUShotgunShort",
    "Base.DLPistol",
    "Base.DLPistol2",
    "Base.DLPistol3",
    "Base.DLPistol_Compact",
    "Base.DLPistol_M45A1",
    "Base.DLRemington870Sawnoff",
    "Base.DLRemington870Wood",
    "Base.DLRevolver",
    "Base.DLRevolver_Long",
    "Base.DLRevolver_M29",
    "Base.DLRevolver_Short",
    "Base.DLRossi92",
    "Base.DLRossi92Sawn",
    "Base.DLRugerm7722",
    "Base.DLRugerm7722_Sawn",
    "Base.DLSKS",
    "Base.DLSKSBayonet",
    "Base.DLSKSMag",
    "Base.DLSKSMagBayonet",
    "Base.DLSKSMagSawn",
    "Base.DLSKSMagShort",
    "Base.DLSKSSawn",
    "Base.DLSKSShort",
    "Base.DLSPAS12",
    "Base.DLShotgun",
    "Base.DLShotgunSawnoff",
    "Base.DLShotgunShort",
    "Base.DLUZI",
    "Base.DLVarmintRifle",
    "Base.DLVarmintRifleShort",
    "Base.DLVarmintRifle_Sawn",
    "Base.DLWinchester73",
    "Base.DLWinchester73Sawn",
    "Base.DLWinchester77",
    "Base.DLWinchester77_Sawn",
    "Base.DLWinchester94",
    "Base.DLWinchester94Sawn",
    "Base.DoubleBarrelShotgun",
    "Base.DoubleBarrelShotgunSawnoff",
    "Base.DoubleBarrelShotgunShort",
    "Base.FN_FAL",
    "Base.FN_FALShort",
    "Base.Glock17",
    "Base.HuntingRifle",
    "Base.HuntingRifleShort",
    "Base.HuntingRifle_Sawn",
    "Base.LAW12",
    "Base.M14A1",
    "Base.M14A1Short",
    "Base.M16A2",
    "Base.M16A2Bayonet",
    "Base.M16A2Short",
    "Base.M1887",
    "Base.M1887Sawn",
    "Base.M1887Short",
    "Base.M1903Springfield",
    "Base.M1903SpringfieldBayonet",
    "Base.M1903SpringfieldShort",
    "Base.M1903Springfield_Sawn",
    "Base.M1Garand",
    "Base.M1GarandBayonet",
    "Base.M24Rifle",
    "Base.M3Grease",
    "Base.M60",
    "Base.M633",
    "Base.M733",
    "Base.MP5",
    "Base.Mac10",
    "Base.Mini14",
    "Base.Mini14Sawn",
    "Base.Mini14Short",
    "Base.Mossberg500",
    "Base.Mossberg500Tactical",
    "Base.OUShotgun",
    "Base.OUShotgunSawnoff",
    "Base.OUShotgunShort",
    "Base.Pistol",
    "Base.Pistol2",
    "Base.Pistol3",
    "Base.Pistol_Compact",
    "Base.Pistol_M45A1",
    "Base.Remington870Sawnoff",
    "Base.Remington870Wood",
    "Base.Revolver",
    "Base.Revolver_Long",
    "Base.Revolver_M29",
    "Base.Revolver_Short",
    "Base.Rossi92",
    "Base.Rossi92Sawn",
    "Base.Rugerm7722",
    "Base.Rugerm7722_Sawn",
    "Base.SKS",
    "Base.SKSBayonet",
    "Base.SKSMag",
    "Base.SKSMagBayonet",
    "Base.SKSMagSawn",
    "Base.SKSMagShort",
    "Base.SKSSawn",
    "Base.SKSShort",
    "Base.SPAS12",
    "Base.Shotgun",
    "Base.ShotgunSawnoff",
    "Base.ShotgunShort",
    "Base.T3Bolt",
    "Base.T3MG",
    "Base.T3Pistol",
    "Base.T3Revolver",
    "Base.T3Rifle",
    "Base.T3SMG",
    "Base.UZI",
    "Base.VarmintRifle",
    "Base.VarmintRifleShort",
    "Base.VarmintRifle_Sawn",
    "Base.Winchester73",
    "Base.Winchester73Sawn",
    "Base.Winchester77",
    "Base.Winchester77_Sawn",
    "Base.Winchester94",
    "Base.Winchester94Sawn",
    "aerx.T1Pistol1",
    "aerx.T1Pistol2",
    "aerx.T1Revolver",
    "aerx.T1Shotgun1",
    "aerx.T1Shotgun2",
    "aerx.T2DMR1",
    "aerx.T2MP1",
    "aerx.T2Pistol1",
    "aerx.T2Rifle1",
    "aerx.T2SMG1",
    "aerx.T2Shotgun",
}
for _, fullType in ipairs(firearmTypes) do
    DLRepair.Profiles[fullType] = {
        options = {
            { difficulty = "easy", restore = 0.30,
              items = {
                { item = "Base.GunToolKit", count = 2 }
                }
            },
            { difficulty = "normal", restore = 0.50, maintenanceMin = 2,
              tools = { "Base.Screwdriver" },
              items = {
                { item = "Base.GunToolKit", count = 2 },
                { item = "DL_MetalLine.GunmetalBar", count = 1 }
                }
            },
            { difficulty = "hard", restore = 0.75, maintenanceMin = 5,
              tools = { "Base.Screwdriver" },
              items = {
                { item = "DL_MetalLine.GunmetalBar", count = 2 },
                    }
            },
        },
    }
end
