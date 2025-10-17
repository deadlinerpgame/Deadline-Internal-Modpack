---@class BuildingMenu
local BuildingMenu = require("BuildingMenu01_Main")
require("BuildingMenu04_CategoriesDefinitions")

--[[
              HOW TO SEARCH
        NO SPACE IN BETWEEN NOUNS
        + F AT THE START. EG: LOW
         TABLES ARE "FLOWTABLES"

        !! CURRENT CATEGORIES !!
            > FURNITURE
                - TABLES: Low tables, Small tables, Large tables
                - BOOKSHELVES

--]]


--[[ >>>>>> FURNITURE <<<<<< --]]

-- >> TABLES: LOW, SMALL, LARGE
local function addDeadlineTablesToMenu()
    local DeadlineTables = {
-- FLOWTABLES
        {
            subcategoryName = "IGUI_BuildingMenuSubCat_Furniture_Low_Tables",
            subCategoryIcon = "furniture_tables_low_01_13",
            objects = {
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_low_01_9",
                        sprite2 = "furniture_tables_low_01_8",
                        northSprite = "furniture_tables_low_01_10",
                        northSprite2 = "furniture_tables_low_01_11",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_low_01_5",
                        sprite2 = "furniture_tables_low_01_4",
                        northSprite = "furniture_tables_low_01_6",
                        northSprite2 = "furniture_tables_low_01_7",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_low_erika_01_129",
                        sprite2 = "furniture_tables_low_erika_01_128",
                        northSprite = "furniture_tables_low_erika_01_130",
                        northSprite2 = "furniture_tables_low_erika_01_131",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_low_erika_01_133",
                        sprite2 = "furniture_tables_low_erika_01_132",
                        northSprite = "furniture_tables_low_erika_01_134",
                        northSprite2 = "furniture_tables_low_erika_01_135",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_17",
                        northSprite = "melos_tiles_furniture_tables_low_16",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_19",
                        northSprite = "melos_tiles_furniture_tables_low_18",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_21",
                        northSprite = "melos_tiles_furniture_tables_low_20",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_23",
                        northSprite = "melos_tiles_furniture_tables_low_22",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_25",
                        northSprite = "melos_tiles_furniture_tables_low_24",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_33",
                        sprite2 = "melos_tiles_furniture_tables_low_32",
                        northSprite = "melos_tiles_furniture_tables_low_34",
                        northSprite2 = "melos_tiles_furniture_tables_low_35",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_37",
                        sprite2 = "melos_tiles_furniture_tables_low_36",
                        northSprite = "melos_tiles_furniture_tables_low_38",
                        northSprite2 = "melos_tiles_furniture_tables_low_39",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_41",
                        sprite2 = "melos_tiles_furniture_tables_low_40",
                        northSprite = "melos_tiles_furniture_tables_low_42",
                        northSprite2 = "melos_tiles_furniture_tables_low_43",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_45",
                        sprite2 = "melos_tiles_furniture_tables_low_44",
                        northSprite = "melos_tiles_furniture_tables_low_46",
                        northSprite2 = "melos_tiles_furniture_tables_low_47",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_49",
                        sprite2 = "melos_tiles_furniture_tables_low_48",
                        northSprite = "melos_tiles_furniture_tables_low_50",
                        northSprite2 = "melos_tiles_furniture_tables_low_51",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_64",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_65",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_66",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_67",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_68",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_69",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_72",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_73",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_74",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_75",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_76",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_77",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_83",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_84",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_85",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_89",
                        sprite2 = "melos_tiles_furniture_tables_low_88",
                        northSprite = "melos_tiles_furniture_tables_low_90",
                        northSprite2 = "melos_tiles_furniture_tables_low_91",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_112",
                        northSprite = "melos_tiles_furniture_tables_low_113",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_93",
                        sprite2 = "melos_tiles_furniture_tables_low_92",
                        northSprite = "melos_tiles_furniture_tables_low_94",
                        northSprite2 = "melos_tiles_furniture_tables_low_95",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_114",
                        northSprite = "melos_tiles_furniture_tables_low_115",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_97",
                        sprite2 = "melos_tiles_furniture_tables_low_96",
                        northSprite = "melos_tiles_furniture_tables_low_98",
                        northSprite2 = "melos_tiles_furniture_tables_low_99",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_116",
                        northSprite = "melos_tiles_furniture_tables_low_117",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_101",
                        sprite2 = "melos_tiles_furniture_tables_low_100",
                        northSprite = "melos_tiles_furniture_tables_low_102",
                        northSprite2 = "melos_tiles_furniture_tables_low_103",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_118",
                        northSprite = "melos_tiles_furniture_tables_low_119",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_105",
                        sprite2 = "melos_tiles_furniture_tables_low_104",
                        northSprite = "melos_tiles_furniture_tables_low_106",
                        northSprite2 = "melos_tiles_furniture_tables_low_107",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_120",
                        northSprite = "melos_tiles_furniture_tables_low_121",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_109",
                        sprite2 = "melos_tiles_furniture_tables_low_108",
                        northSprite = "melos_tiles_furniture_tables_low_110",
                        northSprite2 = "melos_tiles_furniture_tables_low_111",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_122",
                        northSprite = "melos_tiles_furniture_tables_low_123",
                    }
                ),
            }
        },
-- FSMALLTABLES
        {
            subcategoryName = "IGUI_BuildingMenuSubCat_Furniture_Small_Tables",
            subCategoryIcon = "melos_tiles_furniture_tables_01_24",
            objects = {
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_01_68",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_01_60",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_01_24",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_01_25",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_01_26",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_01_27",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_01_28",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_01_29",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_01_30",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_01_31",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_01_21",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_17",
                        northSprite = "furniture_tables_high_erika_01_16",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_19",
                        northSprite = "furniture_tables_high_erika_01_18",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_21",
                        northSprite = "furniture_tables_high_erika_01_20",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_23",
                        northSprite = "furniture_tables_high_erika_01_22",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_25",
                        northSprite = "furniture_tables_high_erika_01_24",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_26",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_27",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_28",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_29",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_30",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_31",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_32",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_33",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_34",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_35",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_52",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_53",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_54",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_55",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_56",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_SmallTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_57",
                    }
                ),
            }
        },
-- FLARGETABLES        
        {
            subcategoryName = "IGUI_BuildingMenuSubCat_Furniture_Large_Tables",
            subCategoryIcon = "melos_tiles_furniture_tables_01_59",
            objects = {
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LargeTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_01_59",
                        sprite2 = "melos_tiles_furniture_tables_01_58",
                        northSprite = "melos_tiles_furniture_tables_01_56",
                        northSprite2 = "melos_tiles_furniture_tables_01_57",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LargeTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_01_37",
                        sprite2 = "melos_tiles_furniture_tables_01_36",
                        northSprite = "melos_tiles_furniture_tables_01_44",
                        northSprite2 = "melos_tiles_furniture_tables_01_45",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LargeTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_61",
                        sprite2 = "furniture_tables_high_erika_01_60",
                        northSprite = "furniture_tables_high_erika_01_62",
                        northSprite2 = "furniture_tables_high_erika_01_63",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LargeTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_51",
                        sprite2 = "furniture_tables_high_erika_01_50",
                        northSprite = "furniture_tables_high_erika_01_48",
                        northSprite2 = "furniture_tables_high_erika_01_49",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LargeTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_47",
                        sprite2 = "furniture_tables_high_erika_01_46",
                        northSprite = "furniture_tables_high_erika_01_44",
                        northSprite2 = "furniture_tables_high_erika_01_45",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LargeTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_9",
                        sprite2 = "furniture_tables_high_erika_01_8",
                        northSprite = "furniture_tables_high_erika_01_10",
                        northSprite2 = "furniture_tables_high_erika_01_11",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LargeTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_1",
                        sprite2 = "furniture_tables_high_erika_01_0",
                        northSprite = "furniture_tables_high_erika_01_2",
                        northSprite2 = "furniture_tables_high_erika_01_3",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LargeTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_5",
                        sprite2 = "furniture_tables_high_erika_01_4",
                        northSprite = "furniture_tables_high_erika_01_6",
                        northSprite2 = "furniture_tables_high_erika_01_7",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LargeTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_13",
                        sprite2 = "furniture_tables_high_erika_01_12",
                        northSprite = "furniture_tables_high_erika_01_14",
                        northSprite2 = "furniture_tables_high_erika_01_15",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LargeTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_39",
                        sprite2 = "furniture_tables_high_erika_01_38",
                        northSprite = "furniture_tables_high_erika_01_36",
                        northSprite2 = "furniture_tables_high_erika_01_37",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LargeTable_Desc",
                    BuildingMenu.onBuildDoubleTileFurniture,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_tables_high_erika_01_43",
                        sprite2 = "furniture_tables_high_erika_01_42",
                        northSprite = "furniture_tables_high_erika_01_40",
                        northSprite2 = "furniture_tables_high_erika_01_41",
                    }
                ),
            }
        },
    }
    for k, subCatData in pairs(DeadlineTables) do
        BuildingMenu.addObjectsToCategories(
            "Deadline",
            "IGUI_BuildingMenuCat_DeadlineFurniture",
            "furniture_tables_low_01_16",
            subCatData.subcategoryName,
            subCatData.subCategoryIcon,
            subCatData.objects
        )
    end
end

-- >> BOOKSHELVES
local function addDeadlineBookshelvesToMenu()
    local DeadlineBookshelves = {
-- FBOOKSHELVES
        {
            subcategoryName = "IGUI_BuildingMenuSubCat_Furniture_Bookshelves",
            subCategoryIcon = "furniture_shelving_01_41",
            objects = {
                BuildingMenu.createObject(
                    "Tooltip_Bookshelves_Uncraftables_Name",
                    "Tooltip_Bookshelves_Uncraftable_DlbCorner_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                        needToBeAgainstWall = true,
                    },
                    {
                        sprite = "furniture_shelving_01_0",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                        needToBeAgainstWall = true,
                    },
                    {
                        sprite = "furniture_shelving_01_2",
                        northSprite = "furniture_shelving_01_1",
                        eastSprite = "furniture_shelving_01_3",
                        southSprite = "furniture_shelving_01_4",
                    }
                ),
                BuildingMenu.createObject(
                    "Tooltip_Bookshelves_Uncraftables_Name",
                    "Tooltip_Bookshelves_Uncraftable_CornerLow_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                        needToBeAgainstWall = true,
                    },
                    {
                        sprite = "furniture_shelving_erika_01_88",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                        needToBeAgainstWall = true,
                    },
                    {
                        sprite = "furniture_shelving_erika_01_90",
                        northSprite = "furniture_shelving_erika_01_89",
                        eastSprite = "furniture_shelving_erika_01_91",
                        southSprite = "furniture_shelving_erika_01_92",
                    }
                ),
                BuildingMenu.createObject(
                    "Tooltip_Bookshelves_Uncraftables_Name",
                    "Tooltip_Bookshelves_Uncraftable_CornerHigh_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                        needToBeAgainstWall = true,
                        buildHigh = true,
                    },
                    {
                        sprite = "furniture_shelving_erika_01_96",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                        needToBeAgainstWall = true,
                        buildHigh = true,
                    },
                    {
                        sprite = "furniture_shelving_erika_01_98",
                        northSprite = "furniture_shelving_erika_01_97",
                        eastSprite = "furniture_shelving_erika_01_99",
                        southSprite = "furniture_shelving_erika_01_100",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_shelving_01_41",
                        northSprite = "furniture_shelving_01_40",
                        eastSprite = "furniture_shelving_01_42",
                        southSprite = "furniture_shelving_01_43",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_shelving_erika_01_105",
                        northSprite = "furniture_shelving_erika_01_104",
                        eastSprite = "furniture_shelving_erika_01_106",
                        southSprite = "furniture_shelving_erika_01_107",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                        buildLow = true,
                    },
                    {
                        sprite = "furniture_shelving_erika_01_55",
                        northSprite = "furniture_shelving_erika_01_51",
                        eastSprite = "furniture_shelving_erika_01_63",
                        southSprite = "furniture_shelving_erika_01_59",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_shelving_erika_01_1",
                        northSprite = "furniture_shelving_erika_01_0",
                        eastSprite = "furniture_shelving_erika_01_2",
                        southSprite = "furniture_shelving_erika_01_3",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_shelving_erika_01_113",
                        northSprite = "furniture_shelving_erika_01_112",
                        eastSprite = "furniture_shelving_erika_01_114",
                        southSprite = "furniture_shelving_erika_01_115",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                        buildLow = true,
                    },
                    {
                        sprite = "furniture_shelving_erika_01_39",
                        northSprite = "furniture_shelving_erika_01_35",
                        eastSprite = "furniture_shelving_erika_01_47",
                        southSprite = "furniture_shelving_erika_01_43",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_shelving_01_45",
                        northSprite = "furniture_shelving_01_44",
                        eastSprite = "furniture_shelving_01_46",
                        southSprite = "furniture_shelving_01_47",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_shelving_erika_01_109",
                        northSprite = "furniture_shelving_erika_01_108",
                        eastSprite = "furniture_shelving_erika_01_110",
                        southSprite = "furniture_shelving_erika_01_111",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_shelving_erika_01_13",
                        northSprite = "furniture_shelving_erika_01_12",
                        eastSprite = "furniture_shelving_erika_01_14",
                        southSprite = "furniture_shelving_erika_01_15",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_shelving_erika_01_125",
                        northSprite = "furniture_shelving_erika_01_124",
                        eastSprite = "furniture_shelving_erika_01_126",
                        southSprite = "furniture_shelving_erika_01_127",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                        buildLow = true,
                    },
                    {
                        sprite = "furniture_shelving_erika_01_71",
                        northSprite = "furniture_shelving_erika_01_67",
                        eastSprite = "furniture_shelving_erika_01_79",
                        southSprite = "furniture_shelving_erika_01_75",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_shelving_erika_01_9",
                        northSprite = "furniture_shelving_erika_01_8",
                        eastSprite = "furniture_shelving_erika_01_10",
                        southSprite = "furniture_shelving_erika_01_11",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_shelving_erika_01_121",
                        northSprite = "furniture_shelving_erika_01_120",
                        eastSprite = "furniture_shelving_erika_01_122",
                        southSprite = "furniture_shelving_erika_01_123",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                        buildLow = true,
                    },
                    {
                        sprite = "furniture_shelving_erika_01_23",
                        northSprite = "furniture_shelving_erika_01_19",
                        eastSprite = "furniture_shelving_erika_01_31",
                        southSprite = "furniture_shelving_erika_01_27",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_shelving_erika_01_5",
                        northSprite = "furniture_shelving_erika_01_4",
                        eastSprite = "furniture_shelving_erika_01_6",
                        southSprite = "furniture_shelving_erika_01_7",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.LargeFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "furniture_shelving_erika_01_117",
                        northSprite = "furniture_shelving_erika_01_116",
                        eastSprite = "furniture_shelving_erika_01_118",
                        southSprite = "furniture_shelving_erika_01_119",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_Bookshelf_Desc",
                    BuildingMenu.onBuildWoodenContainer,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                        buildLow = true,
                    },
                    {
                        sprite = "furniture_shelving_01_23",
                        northSprite = "furniture_shelving_01_19",
                        eastSprite = "furniture_shelving_01_55",
                        southSprite = "furniture_shelving_01_51",
                    }
                ),
            }
        },
    }
    for k, subCatData in pairs(DeadlineBookshelves) do
        BuildingMenu.addObjectsToCategories(
            "Deadline",
            "IGUI_BuildingMenuCat_DeadlineFurniture",
            nil,
            subCatData.subcategoryName,
            subCatData.subCategoryIcon,
            subCatData.objects
        )
    end
end





--[[ >>>>>> FOR THE SANDBOX OPTIONS ON "media\sandbox-options.txt" <<<<<<--]]
local function addCategoriesToBuildingMenu()
    if SandboxVars.BuildingMenu.DeadlineTablesSubCategory then
        addDeadlineTablesToMenu()
    end
    if SandboxVars.BuildingMenu.DeadlineBookshelvesSubCategory then
        addDeadlineBookshelvesToMenu()
    end
end
Events.OnInitializeBuildingMenuObjects.Add(addCategoriesToBuildingMenu)