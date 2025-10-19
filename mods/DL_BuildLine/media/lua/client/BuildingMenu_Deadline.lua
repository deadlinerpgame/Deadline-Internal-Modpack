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

--[[ >>>>>>>> WALLS <<<<<<<< --]]


local function addDeadlinePertWallsToMenu()
    local pertWalls01 = {
-- WALL NORMAL
        BuildingMenu.createObject(
            "Tooltip_WallWall_Name",
            "Tooltip_WallWall_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_0",
                northSprite = "melos_tiles_walls_pert_add_01_1",
                corner = "melos_tiles_walls_pert_add_01_2",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
 -- WALL CORNER
        BuildingMenu.createObject(
            "Tooltip_WallCorner_Name",
            "Tooltip_WallCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_01_2",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
 -- WALL PILLAR
        BuildingMenu.createObject(
            "Tooltip_WallPillar_Name",
            "Tooltip_WallPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_01_3"
            }
        ),
 -- DOOR FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildDoorFrame,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_10",
                northSprite = "melos_tiles_walls_pert_add_01_11",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_12",
                northSprite = "melos_tiles_walls_pert_add_01_14",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_13",
                northSprite = "melos_tiles_walls_pert_add_01_15",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_64",
                northSprite = "melos_tiles_walls_pert_add_01_67",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_65",
                northSprite = "melos_tiles_walls_pert_add_01_68",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_66",
                northSprite = "melos_tiles_walls_pert_add_01_69",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
 -- WINDOW FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_8",
                northSprite = "melos_tiles_walls_pert_add_01_9",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_4",
                northSprite = "melos_tiles_walls_pert_add_01_5",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_6",
                northSprite = "melos_tiles_walls_pert_add_01_7",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_22",
                northSprite = "melos_tiles_walls_pert_add_01_23",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_16",
                northSprite = "melos_tiles_walls_pert_add_01_19",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_17",
                northSprite = "melos_tiles_walls_pert_add_01_20",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_18",
                northSprite = "melos_tiles_walls_pert_add_01_21",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_24",
                northSprite = "melos_tiles_walls_pert_add_01_27",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_25",
                northSprite = "melos_tiles_walls_pert_add_01_28",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_26",
                northSprite = "melos_tiles_walls_pert_add_01_29",
                pillar = "melos_tiles_walls_pert_add_01_3"
            }
        ),
 -- ROOF WALLS
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_96", northSprite = "melos_tiles_walls_pert_add_01_101" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_97", northSprite = "melos_tiles_walls_pert_add_01_100" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_98", northSprite = "melos_tiles_walls_pert_add_01_99" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_112", northSprite = "melos_tiles_walls_pert_add_01_117" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_113", northSprite = "melos_tiles_walls_pert_add_01_116" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_114", northSprite = "melos_tiles_walls_pert_add_01_115" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_104", northSprite = "melos_tiles_walls_pert_add_01_109" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_105", northSprite = "melos_tiles_walls_pert_add_01_108" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_106", northSprite = "melos_tiles_walls_pert_add_01_107" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_32", northSprite = "melos_tiles_walls_pert_add_01_61" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_33", northSprite = "melos_tiles_walls_pert_add_01_60" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_34", northSprite = "melos_tiles_walls_pert_add_01_59" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_35", northSprite = "melos_tiles_walls_pert_add_01_58" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_36", northSprite = "melos_tiles_walls_pert_add_01_57" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_37", northSprite = "melos_tiles_walls_pert_add_01_56" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_31", northSprite = "melos_tiles_walls_pert_add_01_71" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_30", northSprite = "melos_tiles_walls_pert_add_01_70" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_39", northSprite = "melos_tiles_walls_pert_add_01_63" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_38", northSprite = "melos_tiles_walls_pert_add_01_62" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_47", northSprite = "melos_tiles_walls_pert_add_01_55" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_46", northSprite = "melos_tiles_walls_pert_add_01_54" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_40", northSprite = "melos_tiles_walls_pert_add_01_53" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_41", northSprite = "melos_tiles_walls_pert_add_01_52" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_42", northSprite = "melos_tiles_walls_pert_add_01_51" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_43", northSprite = "melos_tiles_walls_pert_add_01_50" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_44", northSprite = "melos_tiles_walls_pert_add_01_49" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_01_45", northSprite = "melos_tiles_walls_pert_add_01_48" }
        ),
 -- SMALLER WALL 1
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_72",
                northSprite = "melos_tiles_walls_pert_add_01_73",
                corner = "melos_tiles_walls_pert_add_01_74",
                pillar = "melos_tiles_walls_pert_add_01_75"
            }
        ),
 -- SMALLER WALL CORNER 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_01_74",
                pillar = "melos_tiles_walls_pert_add_01_75"
            }
        ),
 -- SMALLER WALL PILLAR 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_01_75"
            }
        ),
 -- SMALLER WALL 2
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_76",
                northSprite = "melos_tiles_walls_pert_add_01_77",
                corner = "melos_tiles_walls_pert_add_01_78",
                pillar = "melos_tiles_walls_pert_add_01_79"
            }
        ),
 -- SMALLER WALL CORNER 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_01_78",
                pillar = "melos_tiles_walls_pert_add_01_79"
            }
        ),
 -- SMALLER WALL PILLAR 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_01_79"
            }
        ),
 -- SMALLER WALL 3
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_80",
                northSprite = "melos_tiles_walls_pert_add_01_81",
                corner = "melos_tiles_walls_pert_add_01_82",
                pillar = "melos_tiles_walls_pert_add_01_83"
            }
        ),
 -- SMALLER WALL CORNER 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_01_82",
                pillar = "melos_tiles_walls_pert_add_01_83"
            }
        ),
 -- SMALLER WALL PILLAR 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_01_83"
            }
        ),
 -- SMALLER WALL 4
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_84",
                northSprite = "melos_tiles_walls_pert_add_01_85",
                corner = "melos_tiles_walls_pert_add_01_86",
                pillar = "melos_tiles_walls_pert_add_01_87"
            }
        ),
 -- SMALLER WALL CORNER 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_01_86",
                pillar = "melos_tiles_walls_pert_add_01_87"
            }
        ),
 -- SMALLER WALL PILLAR 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_01_87"
            }
        ),
 -- SMALLER WALL 5
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_01_88",
                northSprite = "melos_tiles_walls_pert_add_01_89",
                corner = "melos_tiles_walls_pert_add_01_90",
                pillar = "melos_tiles_walls_pert_add_01_91"
            }
        ),
 -- SMALLER WALL CORNER 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_01_90",
                pillar = "melos_tiles_walls_pert_add_01_91"
            }
        ),
 -- SMALLER WALL PILLAR 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_01_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        "walls_exterior_wooden_01_24",
        "IGUI_DeadlineWalls_pertWalls01",
        "melos_tiles_walls_pert_add_01_0",
        pertWalls01
    )
    local pertWalls02 = {
-- WALL NORMAL
        BuildingMenu.createObject(
            "Tooltip_WallWall_Name",
            "Tooltip_WallWall_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_0",
                northSprite = "melos_tiles_walls_pert_add_02_1",
                corner = "melos_tiles_walls_pert_add_02_2",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
 -- WALL CORNER
        BuildingMenu.createObject(
            "Tooltip_WallCorner_Name",
            "Tooltip_WallCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_02_2",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
 -- WALL PILLAR
        BuildingMenu.createObject(
            "Tooltip_WallPillar_Name",
            "Tooltip_WallPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_02_3"
            }
        ),
 -- DOOR FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildDoorFrame,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_10",
                northSprite = "melos_tiles_walls_pert_add_02_11",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_12",
                northSprite = "melos_tiles_walls_pert_add_02_14",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_13",
                northSprite = "melos_tiles_walls_pert_add_02_15",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_64",
                northSprite = "melos_tiles_walls_pert_add_02_67",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_65",
                northSprite = "melos_tiles_walls_pert_add_02_68",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_66",
                northSprite = "melos_tiles_walls_pert_add_02_69",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
 -- WINDOW FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_8",
                northSprite = "melos_tiles_walls_pert_add_02_9",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_4",
                northSprite = "melos_tiles_walls_pert_add_02_5",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_6",
                northSprite = "melos_tiles_walls_pert_add_02_7",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_22",
                northSprite = "melos_tiles_walls_pert_add_02_23",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_16",
                northSprite = "melos_tiles_walls_pert_add_02_19",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_17",
                northSprite = "melos_tiles_walls_pert_add_02_20",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_18",
                northSprite = "melos_tiles_walls_pert_add_02_21",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_24",
                northSprite = "melos_tiles_walls_pert_add_02_27",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_25",
                northSprite = "melos_tiles_walls_pert_add_02_28",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_26",
                northSprite = "melos_tiles_walls_pert_add_02_29",
                pillar = "melos_tiles_walls_pert_add_02_3"
            }
        ),
 -- ROOF WALLS
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_96", northSprite = "melos_tiles_walls_pert_add_02_101" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_97", northSprite = "melos_tiles_walls_pert_add_02_100" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_98", northSprite = "melos_tiles_walls_pert_add_02_99" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_112", northSprite = "melos_tiles_walls_pert_add_02_117" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_113", northSprite = "melos_tiles_walls_pert_add_02_116" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_114", northSprite = "melos_tiles_walls_pert_add_02_115" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_104", northSprite = "melos_tiles_walls_pert_add_02_109" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_105", northSprite = "melos_tiles_walls_pert_add_02_108" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_106", northSprite = "melos_tiles_walls_pert_add_02_107" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_32", northSprite = "melos_tiles_walls_pert_add_02_61" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_33", northSprite = "melos_tiles_walls_pert_add_02_60" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_34", northSprite = "melos_tiles_walls_pert_add_02_59" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_35", northSprite = "melos_tiles_walls_pert_add_02_58" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_36", northSprite = "melos_tiles_walls_pert_add_02_57" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_37", northSprite = "melos_tiles_walls_pert_add_02_56" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_31", northSprite = "melos_tiles_walls_pert_add_02_71" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_30", northSprite = "melos_tiles_walls_pert_add_02_70" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_39", northSprite = "melos_tiles_walls_pert_add_02_63" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_38", northSprite = "melos_tiles_walls_pert_add_02_62" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_47", northSprite = "melos_tiles_walls_pert_add_02_55" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_46", northSprite = "melos_tiles_walls_pert_add_02_54" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_40", northSprite = "melos_tiles_walls_pert_add_02_53" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_41", northSprite = "melos_tiles_walls_pert_add_02_52" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_42", northSprite = "melos_tiles_walls_pert_add_02_51" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_43", northSprite = "melos_tiles_walls_pert_add_02_50" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_44", northSprite = "melos_tiles_walls_pert_add_02_49" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_02_45", northSprite = "melos_tiles_walls_pert_add_02_48" }
        ),
 -- SMALLER WALL 1
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_72",
                northSprite = "melos_tiles_walls_pert_add_02_73",
                corner = "melos_tiles_walls_pert_add_02_74",
                pillar = "melos_tiles_walls_pert_add_02_75"
            }
        ),
 -- SMALLER WALL CORNER 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_02_74",
                pillar = "melos_tiles_walls_pert_add_02_75"
            }
        ),
 -- SMALLER WALL PILLAR 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_02_75"
            }
        ),
 -- SMALLER WALL 2
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_76",
                northSprite = "melos_tiles_walls_pert_add_02_77",
                corner = "melos_tiles_walls_pert_add_02_78",
                pillar = "melos_tiles_walls_pert_add_02_79"
            }
        ),
 -- SMALLER WALL CORNER 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_02_78",
                pillar = "melos_tiles_walls_pert_add_02_79"
            }
        ),
 -- SMALLER WALL PILLAR 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_02_79"
            }
        ),
 -- SMALLER WALL 3
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_80",
                northSprite = "melos_tiles_walls_pert_add_02_81",
                corner = "melos_tiles_walls_pert_add_02_82",
                pillar = "melos_tiles_walls_pert_add_02_83"
            }
        ),
 -- SMALLER WALL CORNER 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_02_82",
                pillar = "melos_tiles_walls_pert_add_02_83"
            }
        ),
 -- SMALLER WALL PILLAR 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_02_83"
            }
        ),
 -- SMALLER WALL 4
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_84",
                northSprite = "melos_tiles_walls_pert_add_02_85",
                corner = "melos_tiles_walls_pert_add_02_86",
                pillar = "melos_tiles_walls_pert_add_02_87"
            }
        ),
 -- SMALLER WALL CORNER 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_02_86",
                pillar = "melos_tiles_walls_pert_add_02_87"
            }
        ),
 -- SMALLER WALL PILLAR 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_02_87"
            }
        ),
 -- SMALLER WALL 5
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_02_88",
                northSprite = "melos_tiles_walls_pert_add_02_89",
                corner = "melos_tiles_walls_pert_add_02_90",
                pillar = "melos_tiles_walls_pert_add_02_91"
            }
        ),
 -- SMALLER WALL CORNER 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_02_90",
                pillar = "melos_tiles_walls_pert_add_02_91"
            }
        ),
 -- SMALLER WALL PILLAR 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_02_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_pertWalls02",
        "melos_tiles_walls_pert_add_02_0",
        pertWalls02
    )
    local pertWalls03 = {
-- WALL NORMAL
        BuildingMenu.createObject(
            "Tooltip_WallWall_Name",
            "Tooltip_WallWall_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_0",
                northSprite = "melos_tiles_walls_pert_add_03_1",
                corner = "melos_tiles_walls_pert_add_03_2",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
 -- WALL CORNER
        BuildingMenu.createObject(
            "Tooltip_WallCorner_Name",
            "Tooltip_WallCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_03_2",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
 -- WALL PILLAR
        BuildingMenu.createObject(
            "Tooltip_WallPillar_Name",
            "Tooltip_WallPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_03_3"
            }
        ),
 -- DOOR FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildDoorFrame,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_10",
                northSprite = "melos_tiles_walls_pert_add_03_11",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_12",
                northSprite = "melos_tiles_walls_pert_add_03_14",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_13",
                northSprite = "melos_tiles_walls_pert_add_03_15",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_64",
                northSprite = "melos_tiles_walls_pert_add_03_67",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_65",
                northSprite = "melos_tiles_walls_pert_add_03_68",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_66",
                northSprite = "melos_tiles_walls_pert_add_03_69",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
 -- WINDOW FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_8",
                northSprite = "melos_tiles_walls_pert_add_03_9",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_4",
                northSprite = "melos_tiles_walls_pert_add_03_5",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_6",
                northSprite = "melos_tiles_walls_pert_add_03_7",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_22",
                northSprite = "melos_tiles_walls_pert_add_03_23",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_16",
                northSprite = "melos_tiles_walls_pert_add_03_19",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_17",
                northSprite = "melos_tiles_walls_pert_add_03_20",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_18",
                northSprite = "melos_tiles_walls_pert_add_03_21",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_24",
                northSprite = "melos_tiles_walls_pert_add_03_27",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_25",
                northSprite = "melos_tiles_walls_pert_add_03_28",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_26",
                northSprite = "melos_tiles_walls_pert_add_03_29",
                pillar = "melos_tiles_walls_pert_add_03_3"
            }
        ),
 -- ROOF WALLS
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_96", northSprite = "melos_tiles_walls_pert_add_03_101" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_97", northSprite = "melos_tiles_walls_pert_add_03_100" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_98", northSprite = "melos_tiles_walls_pert_add_03_99" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_112", northSprite = "melos_tiles_walls_pert_add_03_117" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_113", northSprite = "melos_tiles_walls_pert_add_03_116" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_114", northSprite = "melos_tiles_walls_pert_add_03_115" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_104", northSprite = "melos_tiles_walls_pert_add_03_109" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_105", northSprite = "melos_tiles_walls_pert_add_03_108" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_106", northSprite = "melos_tiles_walls_pert_add_03_107" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_32", northSprite = "melos_tiles_walls_pert_add_03_61" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_33", northSprite = "melos_tiles_walls_pert_add_03_60" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_34", northSprite = "melos_tiles_walls_pert_add_03_59" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_35", northSprite = "melos_tiles_walls_pert_add_03_58" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_36", northSprite = "melos_tiles_walls_pert_add_03_57" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_37", northSprite = "melos_tiles_walls_pert_add_03_56" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_31", northSprite = "melos_tiles_walls_pert_add_03_71" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_30", northSprite = "melos_tiles_walls_pert_add_03_70" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_39", northSprite = "melos_tiles_walls_pert_add_03_63" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_38", northSprite = "melos_tiles_walls_pert_add_03_62" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_47", northSprite = "melos_tiles_walls_pert_add_03_55" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_46", northSprite = "melos_tiles_walls_pert_add_03_54" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_40", northSprite = "melos_tiles_walls_pert_add_03_53" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_41", northSprite = "melos_tiles_walls_pert_add_03_52" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_42", northSprite = "melos_tiles_walls_pert_add_03_51" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_43", northSprite = "melos_tiles_walls_pert_add_03_50" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_44", northSprite = "melos_tiles_walls_pert_add_03_49" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_03_45", northSprite = "melos_tiles_walls_pert_add_03_48" }
        ),
 -- SMALLER WALL 1
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_72",
                northSprite = "melos_tiles_walls_pert_add_03_73",
                corner = "melos_tiles_walls_pert_add_03_74",
                pillar = "melos_tiles_walls_pert_add_03_75"
            }
        ),
 -- SMALLER WALL CORNER 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_03_74",
                pillar = "melos_tiles_walls_pert_add_03_75"
            }
        ),
 -- SMALLER WALL PILLAR 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_03_75"
            }
        ),
 -- SMALLER WALL 2
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_76",
                northSprite = "melos_tiles_walls_pert_add_03_77",
                corner = "melos_tiles_walls_pert_add_03_78",
                pillar = "melos_tiles_walls_pert_add_03_79"
            }
        ),
 -- SMALLER WALL CORNER 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_03_78",
                pillar = "melos_tiles_walls_pert_add_03_79"
            }
        ),
 -- SMALLER WALL PILLAR 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_03_79"
            }
        ),
 -- SMALLER WALL 3
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_80",
                northSprite = "melos_tiles_walls_pert_add_03_81",
                corner = "melos_tiles_walls_pert_add_03_82",
                pillar = "melos_tiles_walls_pert_add_03_83"
            }
        ),
 -- SMALLER WALL CORNER 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_03_82",
                pillar = "melos_tiles_walls_pert_add_03_83"
            }
        ),
 -- SMALLER WALL PILLAR 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_03_83"
            }
        ),
 -- SMALLER WALL 4
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_84",
                northSprite = "melos_tiles_walls_pert_add_03_85",
                corner = "melos_tiles_walls_pert_add_03_86",
                pillar = "melos_tiles_walls_pert_add_03_87"
            }
        ),
 -- SMALLER WALL CORNER 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_03_86",
                pillar = "melos_tiles_walls_pert_add_03_87"
            }
        ),
 -- SMALLER WALL PILLAR 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_03_87"
            }
        ),
 -- SMALLER WALL 5
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_03_88",
                northSprite = "melos_tiles_walls_pert_add_03_89",
                corner = "melos_tiles_walls_pert_add_03_90",
                pillar = "melos_tiles_walls_pert_add_03_91"
            }
        ),
 -- SMALLER WALL CORNER 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_03_90",
                pillar = "melos_tiles_walls_pert_add_03_91"
            }
        ),
 -- SMALLER WALL PILLAR 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_03_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_pertWalls03",
        "melos_tiles_walls_pert_add_03_0",
        pertWalls03
    )
    local pertWalls04 = {
-- WALL NORMAL
        BuildingMenu.createObject(
            "Tooltip_WallWall_Name",
            "Tooltip_WallWall_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_0",
                northSprite = "melos_tiles_walls_pert_add_04_1",
                corner = "melos_tiles_walls_pert_add_04_2",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
 -- WALL CORNER
        BuildingMenu.createObject(
            "Tooltip_WallCorner_Name",
            "Tooltip_WallCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_04_2",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
 -- WALL PILLAR
        BuildingMenu.createObject(
            "Tooltip_WallPillar_Name",
            "Tooltip_WallPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_04_3"
            }
        ),
 -- DOOR FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildDoorFrame,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_10",
                northSprite = "melos_tiles_walls_pert_add_04_11",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_12",
                northSprite = "melos_tiles_walls_pert_add_04_14",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_13",
                northSprite = "melos_tiles_walls_pert_add_04_15",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_64",
                northSprite = "melos_tiles_walls_pert_add_04_67",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_65",
                northSprite = "melos_tiles_walls_pert_add_04_68",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_66",
                northSprite = "melos_tiles_walls_pert_add_04_69",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
 -- WINDOW FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_8",
                northSprite = "melos_tiles_walls_pert_add_04_9",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_4",
                northSprite = "melos_tiles_walls_pert_add_04_5",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_6",
                northSprite = "melos_tiles_walls_pert_add_04_7",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_22",
                northSprite = "melos_tiles_walls_pert_add_04_23",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_16",
                northSprite = "melos_tiles_walls_pert_add_04_19",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_17",
                northSprite = "melos_tiles_walls_pert_add_04_20",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_18",
                northSprite = "melos_tiles_walls_pert_add_04_21",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_24",
                northSprite = "melos_tiles_walls_pert_add_04_27",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_25",
                northSprite = "melos_tiles_walls_pert_add_04_28",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_26",
                northSprite = "melos_tiles_walls_pert_add_04_29",
                pillar = "melos_tiles_walls_pert_add_04_3"
            }
        ),
 -- ROOF WALLS
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_96", northSprite = "melos_tiles_walls_pert_add_04_101" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_97", northSprite = "melos_tiles_walls_pert_add_04_100" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_98", northSprite = "melos_tiles_walls_pert_add_04_99" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_112", northSprite = "melos_tiles_walls_pert_add_04_117" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_113", northSprite = "melos_tiles_walls_pert_add_04_116" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_114", northSprite = "melos_tiles_walls_pert_add_04_115" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_104", northSprite = "melos_tiles_walls_pert_add_04_109" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_105", northSprite = "melos_tiles_walls_pert_add_04_108" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_106", northSprite = "melos_tiles_walls_pert_add_04_107" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_32", northSprite = "melos_tiles_walls_pert_add_04_61" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_33", northSprite = "melos_tiles_walls_pert_add_04_60" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_34", northSprite = "melos_tiles_walls_pert_add_04_59" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_35", northSprite = "melos_tiles_walls_pert_add_04_58" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_36", northSprite = "melos_tiles_walls_pert_add_04_57" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_37", northSprite = "melos_tiles_walls_pert_add_04_56" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_31", northSprite = "melos_tiles_walls_pert_add_04_71" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_30", northSprite = "melos_tiles_walls_pert_add_04_70" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_39", northSprite = "melos_tiles_walls_pert_add_04_63" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_38", northSprite = "melos_tiles_walls_pert_add_04_62" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_47", northSprite = "melos_tiles_walls_pert_add_04_55" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_46", northSprite = "melos_tiles_walls_pert_add_04_54" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_40", northSprite = "melos_tiles_walls_pert_add_04_53" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_41", northSprite = "melos_tiles_walls_pert_add_04_52" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_42", northSprite = "melos_tiles_walls_pert_add_04_51" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_43", northSprite = "melos_tiles_walls_pert_add_04_50" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_44", northSprite = "melos_tiles_walls_pert_add_04_49" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_04_45", northSprite = "melos_tiles_walls_pert_add_04_48" }
        ),
 -- SMALLER WALL 1
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_72",
                northSprite = "melos_tiles_walls_pert_add_04_73",
                corner = "melos_tiles_walls_pert_add_04_74",
                pillar = "melos_tiles_walls_pert_add_04_75"
            }
        ),
 -- SMALLER WALL CORNER 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_04_74",
                pillar = "melos_tiles_walls_pert_add_04_75"
            }
        ),
 -- SMALLER WALL PILLAR 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_04_75"
            }
        ),
 -- SMALLER WALL 2
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_76",
                northSprite = "melos_tiles_walls_pert_add_04_77",
                corner = "melos_tiles_walls_pert_add_04_78",
                pillar = "melos_tiles_walls_pert_add_04_79"
            }
        ),
 -- SMALLER WALL CORNER 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_04_78",
                pillar = "melos_tiles_walls_pert_add_04_79"
            }
        ),
 -- SMALLER WALL PILLAR 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_04_79"
            }
        ),
 -- SMALLER WALL 3
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_80",
                northSprite = "melos_tiles_walls_pert_add_04_81",
                corner = "melos_tiles_walls_pert_add_04_82",
                pillar = "melos_tiles_walls_pert_add_04_83"
            }
        ),
 -- SMALLER WALL CORNER 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_04_82",
                pillar = "melos_tiles_walls_pert_add_04_83"
            }
        ),
 -- SMALLER WALL PILLAR 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_04_83"
            }
        ),
 -- SMALLER WALL 4
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_84",
                northSprite = "melos_tiles_walls_pert_add_04_85",
                corner = "melos_tiles_walls_pert_add_04_86",
                pillar = "melos_tiles_walls_pert_add_04_87"
            }
        ),
 -- SMALLER WALL CORNER 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_04_86",
                pillar = "melos_tiles_walls_pert_add_04_87"
            }
        ),
 -- SMALLER WALL PILLAR 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_04_87"
            }
        ),
 -- SMALLER WALL 5
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_04_88",
                northSprite = "melos_tiles_walls_pert_add_04_89",
                corner = "melos_tiles_walls_pert_add_04_90",
                pillar = "melos_tiles_walls_pert_add_04_91"
            }
        ),
 -- SMALLER WALL CORNER 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_04_90",
                pillar = "melos_tiles_walls_pert_add_04_91"
            }
        ),
 -- SMALLER WALL PILLAR 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_04_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_pertWalls04",
        "melos_tiles_walls_pert_add_04_0",
        pertWalls04
    )
    local pertWalls05 = {
-- WALL NORMAL
        BuildingMenu.createObject(
            "Tooltip_WallWall_Name",
            "Tooltip_WallWall_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_0",
                northSprite = "melos_tiles_walls_pert_add_05_1",
                corner = "melos_tiles_walls_pert_add_05_2",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
 -- WALL CORNER
        BuildingMenu.createObject(
            "Tooltip_WallCorner_Name",
            "Tooltip_WallCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_05_2",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
 -- WALL PILLAR
        BuildingMenu.createObject(
            "Tooltip_WallPillar_Name",
            "Tooltip_WallPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_05_3"
            }
        ),
 -- DOOR FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildDoorFrame,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_10",
                northSprite = "melos_tiles_walls_pert_add_05_11",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_12",
                northSprite = "melos_tiles_walls_pert_add_05_14",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_13",
                northSprite = "melos_tiles_walls_pert_add_05_15",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_64",
                northSprite = "melos_tiles_walls_pert_add_05_67",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_65",
                northSprite = "melos_tiles_walls_pert_add_05_68",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_66",
                northSprite = "melos_tiles_walls_pert_add_05_69",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
 -- WINDOW FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_8",
                northSprite = "melos_tiles_walls_pert_add_05_9",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_4",
                northSprite = "melos_tiles_walls_pert_add_05_5",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_6",
                northSprite = "melos_tiles_walls_pert_add_05_7",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_22",
                northSprite = "melos_tiles_walls_pert_add_05_23",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_16",
                northSprite = "melos_tiles_walls_pert_add_05_19",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_17",
                northSprite = "melos_tiles_walls_pert_add_05_20",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_18",
                northSprite = "melos_tiles_walls_pert_add_05_21",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_24",
                northSprite = "melos_tiles_walls_pert_add_05_27",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_25",
                northSprite = "melos_tiles_walls_pert_add_05_28",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_26",
                northSprite = "melos_tiles_walls_pert_add_05_29",
                pillar = "melos_tiles_walls_pert_add_05_3"
            }
        ),
 -- ROOF WALLS
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_96", northSprite = "melos_tiles_walls_pert_add_05_101" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_97", northSprite = "melos_tiles_walls_pert_add_05_100" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_98", northSprite = "melos_tiles_walls_pert_add_05_99" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_112", northSprite = "melos_tiles_walls_pert_add_05_117" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_113", northSprite = "melos_tiles_walls_pert_add_05_116" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_114", northSprite = "melos_tiles_walls_pert_add_05_115" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_104", northSprite = "melos_tiles_walls_pert_add_05_109" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_105", northSprite = "melos_tiles_walls_pert_add_05_108" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_106", northSprite = "melos_tiles_walls_pert_add_05_107" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_32", northSprite = "melos_tiles_walls_pert_add_05_61" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_33", northSprite = "melos_tiles_walls_pert_add_05_60" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_34", northSprite = "melos_tiles_walls_pert_add_05_59" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_35", northSprite = "melos_tiles_walls_pert_add_05_58" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_36", northSprite = "melos_tiles_walls_pert_add_05_57" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_37", northSprite = "melos_tiles_walls_pert_add_05_56" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_31", northSprite = "melos_tiles_walls_pert_add_05_71" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_30", northSprite = "melos_tiles_walls_pert_add_05_70" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_39", northSprite = "melos_tiles_walls_pert_add_05_63" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_38", northSprite = "melos_tiles_walls_pert_add_05_62" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_47", northSprite = "melos_tiles_walls_pert_add_05_55" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_46", northSprite = "melos_tiles_walls_pert_add_05_54" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_40", northSprite = "melos_tiles_walls_pert_add_05_53" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_41", northSprite = "melos_tiles_walls_pert_add_05_52" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_42", northSprite = "melos_tiles_walls_pert_add_05_51" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_43", northSprite = "melos_tiles_walls_pert_add_05_50" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_44", northSprite = "melos_tiles_walls_pert_add_05_49" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_05_45", northSprite = "melos_tiles_walls_pert_add_05_48" }
        ),
 -- SMALLER WALL 1
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_72",
                northSprite = "melos_tiles_walls_pert_add_05_73",
                corner = "melos_tiles_walls_pert_add_05_74",
                pillar = "melos_tiles_walls_pert_add_05_75"
            }
        ),
 -- SMALLER WALL CORNER 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_05_74",
                pillar = "melos_tiles_walls_pert_add_05_75"
            }
        ),
 -- SMALLER WALL PILLAR 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_05_75"
            }
        ),
 -- SMALLER WALL 2
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_76",
                northSprite = "melos_tiles_walls_pert_add_05_77",
                corner = "melos_tiles_walls_pert_add_05_78",
                pillar = "melos_tiles_walls_pert_add_05_79"
            }
        ),
 -- SMALLER WALL CORNER 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_05_78",
                pillar = "melos_tiles_walls_pert_add_05_79"
            }
        ),
 -- SMALLER WALL PILLAR 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_05_79"
            }
        ),
 -- SMALLER WALL 3
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_80",
                northSprite = "melos_tiles_walls_pert_add_05_81",
                corner = "melos_tiles_walls_pert_add_05_82",
                pillar = "melos_tiles_walls_pert_add_05_83"
            }
        ),
 -- SMALLER WALL CORNER 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_05_82",
                pillar = "melos_tiles_walls_pert_add_05_83"
            }
        ),
 -- SMALLER WALL PILLAR 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_05_83"
            }
        ),
 -- SMALLER WALL 4
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_84",
                northSprite = "melos_tiles_walls_pert_add_05_85",
                corner = "melos_tiles_walls_pert_add_05_86",
                pillar = "melos_tiles_walls_pert_add_05_87"
            }
        ),
 -- SMALLER WALL CORNER 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_05_86",
                pillar = "melos_tiles_walls_pert_add_05_87"
            }
        ),
 -- SMALLER WALL PILLAR 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_05_87"
            }
        ),
 -- SMALLER WALL 5
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_05_88",
                northSprite = "melos_tiles_walls_pert_add_05_89",
                corner = "melos_tiles_walls_pert_add_05_90",
                pillar = "melos_tiles_walls_pert_add_05_91"
            }
        ),
 -- SMALLER WALL CORNER 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_05_90",
                pillar = "melos_tiles_walls_pert_add_05_91"
            }
        ),
 -- SMALLER WALL PILLAR 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_05_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_pertWalls05",
        "melos_tiles_walls_pert_add_05_0",
        pertWalls05
    )
    local pertWalls06 = {
-- WALL NORMAL
        BuildingMenu.createObject(
            "Tooltip_WallWall_Name",
            "Tooltip_WallWall_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_0",
                northSprite = "melos_tiles_walls_pert_add_06_1",
                corner = "melos_tiles_walls_pert_add_06_2",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
 -- WALL CORNER
        BuildingMenu.createObject(
            "Tooltip_WallCorner_Name",
            "Tooltip_WallCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_06_2",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
 -- WALL PILLAR
        BuildingMenu.createObject(
            "Tooltip_WallPillar_Name",
            "Tooltip_WallPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_06_3"
            }
        ),
 -- DOOR FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildDoorFrame,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_10",
                northSprite = "melos_tiles_walls_pert_add_06_11",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_12",
                northSprite = "melos_tiles_walls_pert_add_06_14",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_13",
                northSprite = "melos_tiles_walls_pert_add_06_15",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_64",
                northSprite = "melos_tiles_walls_pert_add_06_67",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_65",
                northSprite = "melos_tiles_walls_pert_add_06_68",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_66",
                northSprite = "melos_tiles_walls_pert_add_06_69",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
 -- WINDOW FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_8",
                northSprite = "melos_tiles_walls_pert_add_06_9",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_4",
                northSprite = "melos_tiles_walls_pert_add_06_5",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_6",
                northSprite = "melos_tiles_walls_pert_add_06_7",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_22",
                northSprite = "melos_tiles_walls_pert_add_06_23",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_16",
                northSprite = "melos_tiles_walls_pert_add_06_19",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_17",
                northSprite = "melos_tiles_walls_pert_add_06_20",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_18",
                northSprite = "melos_tiles_walls_pert_add_06_21",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_24",
                northSprite = "melos_tiles_walls_pert_add_06_27",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_25",
                northSprite = "melos_tiles_walls_pert_add_06_28",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_26",
                northSprite = "melos_tiles_walls_pert_add_06_29",
                pillar = "melos_tiles_walls_pert_add_06_3"
            }
        ),
 -- ROOF WALLS
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_96", northSprite = "melos_tiles_walls_pert_add_06_101" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_97", northSprite = "melos_tiles_walls_pert_add_06_100" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_98", northSprite = "melos_tiles_walls_pert_add_06_99" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_112", northSprite = "melos_tiles_walls_pert_add_06_117" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_113", northSprite = "melos_tiles_walls_pert_add_06_116" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_114", northSprite = "melos_tiles_walls_pert_add_06_115" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_104", northSprite = "melos_tiles_walls_pert_add_06_109" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_105", northSprite = "melos_tiles_walls_pert_add_06_108" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_106", northSprite = "melos_tiles_walls_pert_add_06_107" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_32", northSprite = "melos_tiles_walls_pert_add_06_61" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_33", northSprite = "melos_tiles_walls_pert_add_06_60" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_34", northSprite = "melos_tiles_walls_pert_add_06_59" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_35", northSprite = "melos_tiles_walls_pert_add_06_58" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_36", northSprite = "melos_tiles_walls_pert_add_06_57" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_37", northSprite = "melos_tiles_walls_pert_add_06_56" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_31", northSprite = "melos_tiles_walls_pert_add_06_71" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_30", northSprite = "melos_tiles_walls_pert_add_06_70" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_39", northSprite = "melos_tiles_walls_pert_add_06_63" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_38", northSprite = "melos_tiles_walls_pert_add_06_62" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_47", northSprite = "melos_tiles_walls_pert_add_06_55" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_46", northSprite = "melos_tiles_walls_pert_add_06_54" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_40", northSprite = "melos_tiles_walls_pert_add_06_53" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_41", northSprite = "melos_tiles_walls_pert_add_06_52" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_42", northSprite = "melos_tiles_walls_pert_add_06_51" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_43", northSprite = "melos_tiles_walls_pert_add_06_50" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_44", northSprite = "melos_tiles_walls_pert_add_06_49" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_06_45", northSprite = "melos_tiles_walls_pert_add_06_48" }
        ),
 -- SMALLER WALL 1
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_72",
                northSprite = "melos_tiles_walls_pert_add_06_73",
                corner = "melos_tiles_walls_pert_add_06_74",
                pillar = "melos_tiles_walls_pert_add_06_75"
            }
        ),
 -- SMALLER WALL CORNER 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_06_74",
                pillar = "melos_tiles_walls_pert_add_06_75"
            }
        ),
 -- SMALLER WALL PILLAR 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_06_75"
            }
        ),
 -- SMALLER WALL 2
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_76",
                northSprite = "melos_tiles_walls_pert_add_06_77",
                corner = "melos_tiles_walls_pert_add_06_78",
                pillar = "melos_tiles_walls_pert_add_06_79"
            }
        ),
 -- SMALLER WALL CORNER 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_06_78",
                pillar = "melos_tiles_walls_pert_add_06_79"
            }
        ),
 -- SMALLER WALL PILLAR 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_06_79"
            }
        ),
 -- SMALLER WALL 3
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_80",
                northSprite = "melos_tiles_walls_pert_add_06_81",
                corner = "melos_tiles_walls_pert_add_06_82",
                pillar = "melos_tiles_walls_pert_add_06_83"
            }
        ),
 -- SMALLER WALL CORNER 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_06_82",
                pillar = "melos_tiles_walls_pert_add_06_83"
            }
        ),
 -- SMALLER WALL PILLAR 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_06_83"
            }
        ),
 -- SMALLER WALL 4
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_84",
                northSprite = "melos_tiles_walls_pert_add_06_85",
                corner = "melos_tiles_walls_pert_add_06_86",
                pillar = "melos_tiles_walls_pert_add_06_87"
            }
        ),
 -- SMALLER WALL CORNER 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_06_86",
                pillar = "melos_tiles_walls_pert_add_06_87"
            }
        ),
 -- SMALLER WALL PILLAR 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_06_87"
            }
        ),
 -- SMALLER WALL 5
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_06_88",
                northSprite = "melos_tiles_walls_pert_add_06_89",
                corner = "melos_tiles_walls_pert_add_06_90",
                pillar = "melos_tiles_walls_pert_add_06_91"
            }
        ),
 -- SMALLER WALL CORNER 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_06_90",
                pillar = "melos_tiles_walls_pert_add_06_91"
            }
        ),
 -- SMALLER WALL PILLAR 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.SmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_06_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_pertWalls06",
        "melos_tiles_walls_pert_add_06_0",
        pertWalls06
    )
end


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
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_17",
                        northSprite = "melos_tiles_furniture_tables_low_01_16",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_19",
                        northSprite = "melos_tiles_furniture_tables_low_01_18",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_21",
                        northSprite = "melos_tiles_furniture_tables_low_01_20",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_23",
                        northSprite = "melos_tiles_furniture_tables_low_01_22",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_25",
                        northSprite = "melos_tiles_furniture_tables_low_01_24",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildDoubleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_33",
                        sprite2 = "melos_tiles_furniture_tables_low_01_32",
                        northSprite = "melos_tiles_furniture_tables_low_01_34",
                        northSprite2 = "melos_tiles_furniture_tables_low_01_35",
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
                        sprite = "melos_tiles_furniture_tables_low_01_37",
                        sprite2 = "melos_tiles_furniture_tables_low_01_36",
                        northSprite = "melos_tiles_furniture_tables_low_01_38",
                        northSprite2 = "melos_tiles_furniture_tables_low_01_39",
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
                        sprite = "melos_tiles_furniture_tables_low_01_41",
                        sprite2 = "melos_tiles_furniture_tables_low_01_40",
                        northSprite = "melos_tiles_furniture_tables_low_01_42",
                        northSprite2 = "melos_tiles_furniture_tables_low_01_43",
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
                        sprite = "melos_tiles_furniture_tables_low_01_45",
                        sprite2 = "melos_tiles_furniture_tables_low_01_44",
                        northSprite = "melos_tiles_furniture_tables_low_01_46",
                        northSprite2 = "melos_tiles_furniture_tables_low_01_47",
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
                        sprite = "melos_tiles_furniture_tables_low_01_49",
                        sprite2 = "melos_tiles_furniture_tables_low_01_48",
                        northSprite = "melos_tiles_furniture_tables_low_01_50",
                        northSprite2 = "melos_tiles_furniture_tables_low_01_51",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_64",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_65",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_66",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_67",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_68",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_69",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_72",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_73",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_74",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_75",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_76",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_77",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_83",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_84",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_85",
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
                        sprite = "melos_tiles_furniture_tables_low_01_89",
                        sprite2 = "melos_tiles_furniture_tables_low_01_88",
                        northSprite = "melos_tiles_furniture_tables_low_01_90",
                        northSprite2 = "melos_tiles_furniture_tables_low_01_91",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_112",
                        northSprite = "melos_tiles_furniture_tables_low_01_113",
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
                        sprite = "melos_tiles_furniture_tables_low_01_93",
                        sprite2 = "melos_tiles_furniture_tables_low_01_92",
                        northSprite = "melos_tiles_furniture_tables_low_01_94",
                        northSprite2 = "melos_tiles_furniture_tables_low_01_95",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_114",
                        northSprite = "melos_tiles_furniture_tables_low_01_115",
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
                        sprite = "melos_tiles_furniture_tables_low_01_97",
                        sprite2 = "melos_tiles_furniture_tables_low_01_96",
                        northSprite = "melos_tiles_furniture_tables_low_01_98",
                        northSprite2 = "melos_tiles_furniture_tables_low_01_99",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_116",
                        northSprite = "melos_tiles_furniture_tables_low_01_117",
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
                        sprite = "melos_tiles_furniture_tables_low_01_101",
                        sprite2 = "melos_tiles_furniture_tables_low_01_100",
                        northSprite = "melos_tiles_furniture_tables_low_01_102",
                        northSprite2 = "melos_tiles_furniture_tables_low_01_103",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_118",
                        northSprite = "melos_tiles_furniture_tables_low_01_119",
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
                        sprite = "melos_tiles_furniture_tables_low_01_105",
                        sprite2 = "melos_tiles_furniture_tables_low_01_104",
                        northSprite = "melos_tiles_furniture_tables_low_01_106",
                        northSprite2 = "melos_tiles_furniture_tables_low_01_107",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_120",
                        northSprite = "melos_tiles_furniture_tables_low_01_121",
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
                        sprite = "melos_tiles_furniture_tables_low_01_109",
                        sprite2 = "melos_tiles_furniture_tables_low_01_108",
                        northSprite = "melos_tiles_furniture_tables_low_01_110",
                        northSprite2 = "melos_tiles_furniture_tables_low_01_111",
                    }
                ),
                BuildingMenu.createObject(
                    "",
                    "Tooltip_LowTable_Desc",
                    BuildingMenu.onBuildSimpleFurniture,
                    BuildingMenu.SmallFurnitureRecipe,
                    true,
                    {
                        completionSound = "BuildWoodenStructureLarge",
                    },
                    {
                        sprite = "melos_tiles_furniture_tables_low_01_122",
                        northSprite = "melos_tiles_furniture_tables_low_01_123",
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
            "melos_tiles_furniture_tables_low_01_14",
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
    if SandboxVars.BuildingMenu.DeadlinePertWallsSubCategory then
        addDeadlinePertWallsToMenu()
    end
    if SandboxVars.BuildingMenu.DeadlineTablesSubCategory then
        addDeadlineTablesToMenu()
    end
    if SandboxVars.BuildingMenu.DeadlineBookshelvesSubCategory then
        addDeadlineBookshelvesToMenu()
    end
end
Events.OnInitializeBuildingMenuObjects.Add(addCategoriesToBuildingMenu)