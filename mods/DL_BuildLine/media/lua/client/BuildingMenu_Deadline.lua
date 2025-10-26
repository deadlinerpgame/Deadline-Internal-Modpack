---@class BuildingMenu
local BuildingMenu = require("BuildingMenu01_Main")
require("BuildingMenu04_CategoriesDefinitions")

--[[
              HOW TO SEARCH
        NO SPACE IN BETWEEN NOUNS
        + F AT THE START. EG: LOW
         TABLES ARE "FLOWTABLES"

        !! CURRENT CATEGORIES !!
            > WALLS
            > FURNITURE
                - TABLES: Low tables, Small tables, Large tables
                - BOOKSHELVES

--]]

--[[ >>>>>>>> WALLS <<<<<<<< --]]

local function addDeadlineWallsToMenu()
-- MELOS - Tiled Vines Blue
    local melosWallsTVBl = {
 -- WALL NORMAL
        BuildingMenu.createObject(
            "Tooltip_WallWall_Name",
            "Tooltip_WallWall_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlueBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_24",
                northSprite = "melos_tiles_walls_bathroom_03_25",
                corner = "melos_tiles_walls_bathroom_03_26",
                pillar = "melos_tiles_walls_bathroom_03_27"
            }
        ),
 -- WALL CORNER
        BuildingMenu.createObject(
            "Tooltip_WallCorner_Name",
            "Tooltip_WallCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlueBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_bathroom_03_26",
                pillar = "melos_tiles_walls_bathroom_03_27"
            }
        ),
 -- WALL PILLAR
        BuildingMenu.createObject(
            "Tooltip_WallPillar_Name",
            "Tooltip_WallPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlueSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_bathroom_03_27"
            }
        ),
 -- DOOR FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildDoorFrame,
            BuildingMenu.BlueBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_34",
                northSprite = "melos_tiles_walls_bathroom_03_35",
                pillar = "melos_tiles_walls_bathroom_03_27"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BlueBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_42",
                northSprite = "melos_tiles_walls_bathroom_03_45",
                pillar = "melos_tiles_walls_bathroom_03_27"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BlueBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_43",
                northSprite = "melos_tiles_walls_bathroom_03_46",
                pillar = "melos_tiles_walls_bathroom_03_27"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BlueBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_44",
                northSprite = "melos_tiles_walls_bathroom_03_47",
                pillar = "melos_tiles_walls_bathroom_03_27"
            }
        ),
 -- WINDOW FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlueBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_32",
                northSprite = "melos_tiles_walls_bathroom_03_33",
                pillar = "melos_tiles_walls_bathroom_03_27"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlueBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_40",
                northSprite = "melos_tiles_walls_bathroom_03_41",
                pillar = "melos_tiles_walls_bathroom_03_27"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlueBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_36",
                northSprite = "melos_tiles_walls_bathroom_03_38",
                pillar = "melos_tiles_walls_bathroom_03_27"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlueBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_37",
                northSprite = "melos_tiles_walls_bathroom_03_39",
                pillar = "melos_tiles_walls_bathroom_03_27"
            }
        ),
 -- SMALLER WALL 1
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlueSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_28",
                northSprite = "melos_tiles_walls_bathroom_03_29",
                corner = "melos_tiles_walls_bathroom_03_30",
                pillar = "melos_tiles_walls_bathroom_03_31"
            }
        ),
 -- SMALLER WALL CORNER 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlueBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_bathroom_03_30",
                pillar = "melos_tiles_walls_bathroom_03_31"
            }
        ),
 -- SMALLER WALL PILLAR 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlueSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_bathroom_03_31"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_melosWallsTVBl",
        "melos_tiles_walls_bathroom_03_24",
        melosWallsTVBl
    )
-- MELOS - Tiled Vines Green
    local melosWallsTVGrn = {
 -- WALL NORMAL
        BuildingMenu.createObject(
            "Tooltip_WallWall_Name",
            "Tooltip_WallWall_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreenBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_0",
                northSprite = "melos_tiles_walls_bathroom_03_1",
                corner = "melos_tiles_walls_bathroom_03_2",
                pillar = "melos_tiles_walls_bathroom_03_3"
            }
        ),
 -- WALL CORNER
        BuildingMenu.createObject(
            "Tooltip_WallCorner_Name",
            "Tooltip_WallCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreenBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_bathroom_03_2",
                pillar = "melos_tiles_walls_bathroom_03_3"
            }
        ),
 -- WALL PILLAR
        BuildingMenu.createObject(
            "Tooltip_WallPillar_Name",
            "Tooltip_WallPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreenSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_bathroom_03_3"
            }
        ),
 -- DOOR FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildDoorFrame,
            BuildingMenu.GreenBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_10",
                northSprite = "melos_tiles_walls_bathroom_03_11",
                pillar = "melos_tiles_walls_bathroom_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.GreenBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_18",
                northSprite = "melos_tiles_walls_bathroom_03_21",
                pillar = "melos_tiles_walls_bathroom_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.GreenBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_19",
                northSprite = "melos_tiles_walls_bathroom_03_22",
                pillar = "melos_tiles_walls_bathroom_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.GreenBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_20",
                northSprite = "melos_tiles_walls_bathroom_03_23",
                pillar = "melos_tiles_walls_bathroom_03_3"
            }
        ),
 -- WINDOW FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreenBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_8",
                northSprite = "melos_tiles_walls_bathroom_03_9",
                pillar = "melos_tiles_walls_bathroom_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreenBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_16",
                northSprite = "melos_tiles_walls_bathroom_03_17",
                pillar = "melos_tiles_walls_bathroom_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreenBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_12",
                northSprite = "melos_tiles_walls_bathroom_03_14",
                pillar = "melos_tiles_walls_bathroom_03_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreenBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_13",
                northSprite = "melos_tiles_walls_bathroom_03_15",
                pillar = "melos_tiles_walls_bathroom_03_3"
            }
        ),
 -- SMALLER WALL 1
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreenSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_4",
                northSprite = "melos_tiles_walls_bathroom_03_5",
                corner = "melos_tiles_walls_bathroom_03_6",
                pillar = "melos_tiles_walls_bathroom_03_7"
            }
        ),
 -- SMALLER WALL CORNER 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreenBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_bathroom_03_6",
                pillar = "melos_tiles_walls_bathroom_03_7"
            }
        ),
 -- SMALLER WALL PILLAR 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreenSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_bathroom_03_7"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_melosWallsTVGrn",
        "melos_tiles_walls_bathroom_03_0",
        melosWallsTVGrn
    )
-- MELOS - Tiled Vines Grey
    local melosWallsTVGr = {
 -- WALL NORMAL
        BuildingMenu.createObject(
            "Tooltip_WallWall_Name",
            "Tooltip_WallWall_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreyBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_48",
                northSprite = "melos_tiles_walls_bathroom_03_49",
                corner = "melos_tiles_walls_bathroom_03_50",
                pillar = "melos_tiles_walls_bathroom_03_51"
            }
        ),
 -- WALL CORNER
        BuildingMenu.createObject(
            "Tooltip_WallCorner_Name",
            "Tooltip_WallCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreyBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_bathroom_03_50",
                pillar = "melos_tiles_walls_bathroom_03_51"
            }
        ),
 -- WALL PILLAR
        BuildingMenu.createObject(
            "Tooltip_WallPillar_Name",
            "Tooltip_WallPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreySmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_bathroom_03_51"
            }
        ),
 -- DOOR FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildDoorFrame,
            BuildingMenu.GreyBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_58",
                northSprite = "melos_tiles_walls_bathroom_03_59",
                pillar = "melos_tiles_walls_bathroom_03_51"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.GreyBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_66",
                northSprite = "melos_tiles_walls_bathroom_03_69",
                pillar = "melos_tiles_walls_bathroom_03_51"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.GreyBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_67",
                northSprite = "melos_tiles_walls_bathroom_03_70",
                pillar = "melos_tiles_walls_bathroom_03_51"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.GreyBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_68",
                northSprite = "melos_tiles_walls_bathroom_03_71",
                pillar = "melos_tiles_walls_bathroom_03_51"
            }
        ),
 -- WINDOW FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreyBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_56",
                northSprite = "melos_tiles_walls_bathroom_03_57",
                pillar = "melos_tiles_walls_bathroom_03_51"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreyBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_64",
                northSprite = "melos_tiles_walls_bathroom_03_65",
                pillar = "melos_tiles_walls_bathroom_03_51"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreyBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_60",
                northSprite = "melos_tiles_walls_bathroom_03_62",
                pillar = "melos_tiles_walls_bathroom_03_51"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreyBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_61",
                northSprite = "melos_tiles_walls_bathroom_03_63",
                pillar = "melos_tiles_walls_bathroom_03_51"
            }
        ),
 -- SMALLER WALL 1
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreySmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_bathroom_03_52",
                northSprite = "melos_tiles_walls_bathroom_03_53",
                corner = "melos_tiles_walls_bathroom_03_54",
                pillar = "melos_tiles_walls_bathroom_03_55"
            }
        ),
 -- SMALLER WALL CORNER 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreyBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_bathroom_03_54",
                pillar = "melos_tiles_walls_bathroom_03_55"
            }
        ),
 -- SMALLER WALL PILLAR 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.GreySmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_bathroom_03_55"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_melosWallsTVGr",
        "melos_tiles_walls_bathroom_03_48",
        melosWallsTVGr
    )
-- MELOS - Wood Thick Light
    local melosWallsW03b = {
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
                sprite = "melos_tiles_walls_wood_03b_0",
                northSprite = "melos_tiles_walls_wood_03b_1",
                corner = "melos_tiles_walls_wood_03b_2",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                corner = "melos_tiles_walls_wood_03b_2",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_10",
                northSprite = "melos_tiles_walls_wood_03b_11",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_12",
                northSprite = "melos_tiles_walls_wood_03b_14",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_13",
                northSprite = "melos_tiles_walls_wood_03b_15",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_64",
                northSprite = "melos_tiles_walls_wood_03b_67",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_65",
                northSprite = "melos_tiles_walls_wood_03b_68",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_66",
                northSprite = "melos_tiles_walls_wood_03b_69",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_8",
                northSprite = "melos_tiles_walls_wood_03b_9",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_4",
                northSprite = "melos_tiles_walls_wood_03b_5",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_6",
                northSprite = "melos_tiles_walls_wood_03b_7",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_22",
                northSprite = "melos_tiles_walls_wood_03b_23",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_16",
                northSprite = "melos_tiles_walls_wood_03b_19",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_17",
                northSprite = "melos_tiles_walls_wood_03b_20",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_18",
                northSprite = "melos_tiles_walls_wood_03b_21",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_24",
                northSprite = "melos_tiles_walls_wood_03b_27",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_25",
                northSprite = "melos_tiles_walls_wood_03b_28",
                pillar = "melos_tiles_walls_wood_03b_3"
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
                sprite = "melos_tiles_walls_wood_03b_26",
                northSprite = "melos_tiles_walls_wood_03b_29",
                pillar = "melos_tiles_walls_wood_03b_3"
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
            { sprite = "melos_tiles_walls_wood_03b_96", northSprite = "melos_tiles_walls_wood_03b_101" }
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
            { sprite = "melos_tiles_walls_wood_03b_97", northSprite = "melos_tiles_walls_wood_03b_100" }
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
            { sprite = "melos_tiles_walls_wood_03b_98", northSprite = "melos_tiles_walls_wood_03b_99" }
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
            { sprite = "melos_tiles_walls_wood_03b_112", northSprite = "melos_tiles_walls_wood_03b_117" }
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
            { sprite = "melos_tiles_walls_wood_03b_113", northSprite = "melos_tiles_walls_wood_03b_116" }
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
            { sprite = "melos_tiles_walls_wood_03b_114", northSprite = "melos_tiles_walls_wood_03b_115" }
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
            { sprite = "melos_tiles_walls_wood_03b_104", northSprite = "melos_tiles_walls_wood_03b_109" }
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
            { sprite = "melos_tiles_walls_wood_03b_105", northSprite = "melos_tiles_walls_wood_03b_108" }
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
            { sprite = "melos_tiles_walls_wood_03b_106", northSprite = "melos_tiles_walls_wood_03b_107" }
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
            { sprite = "melos_tiles_walls_wood_03b_32", northSprite = "melos_tiles_walls_wood_03b_61" }
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
            { sprite = "melos_tiles_walls_wood_03b_33", northSprite = "melos_tiles_walls_wood_03b_60" }
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
            { sprite = "melos_tiles_walls_wood_03b_34", northSprite = "melos_tiles_walls_wood_03b_59" }
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
            { sprite = "melos_tiles_walls_wood_03b_35", northSprite = "melos_tiles_walls_wood_03b_58" }
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
            { sprite = "melos_tiles_walls_wood_03b_36", northSprite = "melos_tiles_walls_wood_03b_57" }
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
            { sprite = "melos_tiles_walls_wood_03b_37", northSprite = "melos_tiles_walls_wood_03b_56" }
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
            { sprite = "melos_tiles_walls_wood_03b_31", northSprite = "melos_tiles_walls_wood_03b_71" }
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
            { sprite = "melos_tiles_walls_wood_03b_30", northSprite = "melos_tiles_walls_wood_03b_70" }
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
            { sprite = "melos_tiles_walls_wood_03b_39", northSprite = "melos_tiles_walls_wood_03b_63" }
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
            { sprite = "melos_tiles_walls_wood_03b_38", northSprite = "melos_tiles_walls_wood_03b_62" }
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
            { sprite = "melos_tiles_walls_wood_03b_47", northSprite = "melos_tiles_walls_wood_03b_55" }
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
            { sprite = "melos_tiles_walls_wood_03b_46", northSprite = "melos_tiles_walls_wood_03b_54" }
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
            { sprite = "melos_tiles_walls_wood_03b_40", northSprite = "melos_tiles_walls_wood_03b_53" }
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
            { sprite = "melos_tiles_walls_wood_03b_41", northSprite = "melos_tiles_walls_wood_03b_52" }
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
            { sprite = "melos_tiles_walls_wood_03b_42", northSprite = "melos_tiles_walls_wood_03b_51" }
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
            { sprite = "melos_tiles_walls_wood_03b_43", northSprite = "melos_tiles_walls_wood_03b_50" }
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
            { sprite = "melos_tiles_walls_wood_03b_44", northSprite = "melos_tiles_walls_wood_03b_49" }
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
            { sprite = "melos_tiles_walls_wood_03b_45", northSprite = "melos_tiles_walls_wood_03b_48" }
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
                sprite = "melos_tiles_walls_wood_03b_72",
                northSprite = "melos_tiles_walls_wood_03b_73",
                corner = "melos_tiles_walls_wood_03b_74",
                pillar = "melos_tiles_walls_wood_03b_75"
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
                corner = "melos_tiles_walls_wood_03b_74",
                pillar = "melos_tiles_walls_wood_03b_75"
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
                sprite = "melos_tiles_walls_wood_03b_75"
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
                sprite = "melos_tiles_walls_wood_03b_76",
                northSprite = "melos_tiles_walls_wood_03b_77",
                corner = "melos_tiles_walls_wood_03b_78",
                pillar = "melos_tiles_walls_wood_03b_79"
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
                corner = "melos_tiles_walls_wood_03b_78",
                pillar = "melos_tiles_walls_wood_03b_79"
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
                sprite = "melos_tiles_walls_wood_03b_79"
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
                sprite = "melos_tiles_walls_wood_03b_80",
                northSprite = "melos_tiles_walls_wood_03b_81",
                corner = "melos_tiles_walls_wood_03b_82",
                pillar = "melos_tiles_walls_wood_03b_83"
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
                corner = "melos_tiles_walls_wood_03b_82",
                pillar = "melos_tiles_walls_wood_03b_83"
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
                sprite = "melos_tiles_walls_wood_03b_83"
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
                sprite = "melos_tiles_walls_wood_03b_84",
                northSprite = "melos_tiles_walls_wood_03b_85",
                corner = "melos_tiles_walls_wood_03b_86",
                pillar = "melos_tiles_walls_wood_03b_87"
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
                corner = "melos_tiles_walls_wood_03b_86",
                pillar = "melos_tiles_walls_wood_03b_87"
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
                sprite = "melos_tiles_walls_wood_03b_87"
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
                sprite = "melos_tiles_walls_wood_03b_88",
                northSprite = "melos_tiles_walls_wood_03b_89",
                corner = "melos_tiles_walls_wood_03b_90",
                pillar = "melos_tiles_walls_wood_03b_91"
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
                corner = "melos_tiles_walls_wood_03b_90",
                pillar = "melos_tiles_walls_wood_03b_91"
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
                sprite = "melos_tiles_walls_wood_03b_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_melosWallsW03b",
        "melos_tiles_walls_wood_03b_0",
        melosWallsW03b
    )
-- MELOS - Wood Thick Brown
    local melosWallsW03 = {
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
                sprite = "melos_tiles_walls_wood_03_0",
                northSprite = "melos_tiles_walls_wood_03_1",
                corner = "melos_tiles_walls_wood_03_2",
                pillar = "melos_tiles_walls_wood_03_3"
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
                corner = "melos_tiles_walls_wood_03_2",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_10",
                northSprite = "melos_tiles_walls_wood_03_11",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_12",
                northSprite = "melos_tiles_walls_wood_03_14",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_13",
                northSprite = "melos_tiles_walls_wood_03_15",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_64",
                northSprite = "melos_tiles_walls_wood_03_67",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_65",
                northSprite = "melos_tiles_walls_wood_03_68",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_66",
                northSprite = "melos_tiles_walls_wood_03_69",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_8",
                northSprite = "melos_tiles_walls_wood_03_9",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_4",
                northSprite = "melos_tiles_walls_wood_03_5",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_6",
                northSprite = "melos_tiles_walls_wood_03_7",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_22",
                northSprite = "melos_tiles_walls_wood_03_23",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_16",
                northSprite = "melos_tiles_walls_wood_03_19",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_17",
                northSprite = "melos_tiles_walls_wood_03_20",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_18",
                northSprite = "melos_tiles_walls_wood_03_21",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_24",
                northSprite = "melos_tiles_walls_wood_03_27",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_25",
                northSprite = "melos_tiles_walls_wood_03_28",
                pillar = "melos_tiles_walls_wood_03_3"
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
                sprite = "melos_tiles_walls_wood_03_26",
                northSprite = "melos_tiles_walls_wood_03_29",
                pillar = "melos_tiles_walls_wood_03_3"
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
            { sprite = "melos_tiles_walls_wood_03_96", northSprite = "melos_tiles_walls_wood_03_101" }
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
            { sprite = "melos_tiles_walls_wood_03_97", northSprite = "melos_tiles_walls_wood_03_100" }
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
            { sprite = "melos_tiles_walls_wood_03_98", northSprite = "melos_tiles_walls_wood_03_99" }
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
            { sprite = "melos_tiles_walls_wood_03_112", northSprite = "melos_tiles_walls_wood_03_117" }
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
            { sprite = "melos_tiles_walls_wood_03_113", northSprite = "melos_tiles_walls_wood_03_116" }
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
            { sprite = "melos_tiles_walls_wood_03_114", northSprite = "melos_tiles_walls_wood_03_115" }
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
            { sprite = "melos_tiles_walls_wood_03_104", northSprite = "melos_tiles_walls_wood_03_109" }
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
            { sprite = "melos_tiles_walls_wood_03_105", northSprite = "melos_tiles_walls_wood_03_108" }
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
            { sprite = "melos_tiles_walls_wood_03_106", northSprite = "melos_tiles_walls_wood_03_107" }
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
            { sprite = "melos_tiles_walls_wood_03_32", northSprite = "melos_tiles_walls_wood_03_61" }
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
            { sprite = "melos_tiles_walls_wood_03_33", northSprite = "melos_tiles_walls_wood_03_60" }
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
            { sprite = "melos_tiles_walls_wood_03_34", northSprite = "melos_tiles_walls_wood_03_59" }
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
            { sprite = "melos_tiles_walls_wood_03_35", northSprite = "melos_tiles_walls_wood_03_58" }
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
            { sprite = "melos_tiles_walls_wood_03_36", northSprite = "melos_tiles_walls_wood_03_57" }
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
            { sprite = "melos_tiles_walls_wood_03_37", northSprite = "melos_tiles_walls_wood_03_56" }
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
            { sprite = "melos_tiles_walls_wood_03_31", northSprite = "melos_tiles_walls_wood_03_71" }
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
            { sprite = "melos_tiles_walls_wood_03_30", northSprite = "melos_tiles_walls_wood_03_70" }
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
            { sprite = "melos_tiles_walls_wood_03_39", northSprite = "melos_tiles_walls_wood_03_63" }
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
            { sprite = "melos_tiles_walls_wood_03_38", northSprite = "melos_tiles_walls_wood_03_62" }
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
            { sprite = "melos_tiles_walls_wood_03_47", northSprite = "melos_tiles_walls_wood_03_55" }
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
            { sprite = "melos_tiles_walls_wood_03_46", northSprite = "melos_tiles_walls_wood_03_54" }
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
            { sprite = "melos_tiles_walls_wood_03_40", northSprite = "melos_tiles_walls_wood_03_53" }
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
            { sprite = "melos_tiles_walls_wood_03_41", northSprite = "melos_tiles_walls_wood_03_52" }
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
            { sprite = "melos_tiles_walls_wood_03_42", northSprite = "melos_tiles_walls_wood_03_51" }
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
            { sprite = "melos_tiles_walls_wood_03_43", northSprite = "melos_tiles_walls_wood_03_50" }
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
            { sprite = "melos_tiles_walls_wood_03_44", northSprite = "melos_tiles_walls_wood_03_49" }
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
            { sprite = "melos_tiles_walls_wood_03_45", northSprite = "melos_tiles_walls_wood_03_48" }
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
                sprite = "melos_tiles_walls_wood_03_72",
                northSprite = "melos_tiles_walls_wood_03_73",
                corner = "melos_tiles_walls_wood_03_74",
                pillar = "melos_tiles_walls_wood_03_75"
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
                corner = "melos_tiles_walls_wood_03_74",
                pillar = "melos_tiles_walls_wood_03_75"
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
                sprite = "melos_tiles_walls_wood_03_75"
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
                sprite = "melos_tiles_walls_wood_03_76",
                northSprite = "melos_tiles_walls_wood_03_77",
                corner = "melos_tiles_walls_wood_03_78",
                pillar = "melos_tiles_walls_wood_03_79"
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
                corner = "melos_tiles_walls_wood_03_78",
                pillar = "melos_tiles_walls_wood_03_79"
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
                sprite = "melos_tiles_walls_wood_03_79"
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
                sprite = "melos_tiles_walls_wood_03_80",
                northSprite = "melos_tiles_walls_wood_03_81",
                corner = "melos_tiles_walls_wood_03_82",
                pillar = "melos_tiles_walls_wood_03_83"
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
                corner = "melos_tiles_walls_wood_03_82",
                pillar = "melos_tiles_walls_wood_03_83"
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
                sprite = "melos_tiles_walls_wood_03_83"
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
                sprite = "melos_tiles_walls_wood_03_84",
                northSprite = "melos_tiles_walls_wood_03_85",
                corner = "melos_tiles_walls_wood_03_86",
                pillar = "melos_tiles_walls_wood_03_87"
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
                corner = "melos_tiles_walls_wood_03_86",
                pillar = "melos_tiles_walls_wood_03_87"
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
                sprite = "melos_tiles_walls_wood_03_87"
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
                sprite = "melos_tiles_walls_wood_03_88",
                northSprite = "melos_tiles_walls_wood_03_89",
                corner = "melos_tiles_walls_wood_03_90",
                pillar = "melos_tiles_walls_wood_03_91"
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
                corner = "melos_tiles_walls_wood_03_90",
                pillar = "melos_tiles_walls_wood_03_91"
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
                sprite = "melos_tiles_walls_wood_03_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_melosWallsW03",
        "melos_tiles_walls_wood_03_0",
        melosWallsW03
    )
-- MELOS - Wood Thick Dark
    local melosWallsW03a = {
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
                sprite = "melos_tiles_walls_wood_03a_0",
                northSprite = "melos_tiles_walls_wood_03a_1",
                corner = "melos_tiles_walls_wood_03a_2",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                corner = "melos_tiles_walls_wood_03a_2",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_10",
                northSprite = "melos_tiles_walls_wood_03a_11",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_12",
                northSprite = "melos_tiles_walls_wood_03a_14",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_13",
                northSprite = "melos_tiles_walls_wood_03a_15",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_64",
                northSprite = "melos_tiles_walls_wood_03a_67",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_65",
                northSprite = "melos_tiles_walls_wood_03a_68",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_66",
                northSprite = "melos_tiles_walls_wood_03a_69",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_8",
                northSprite = "melos_tiles_walls_wood_03a_9",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_4",
                northSprite = "melos_tiles_walls_wood_03a_5",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_6",
                northSprite = "melos_tiles_walls_wood_03a_7",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_22",
                northSprite = "melos_tiles_walls_wood_03a_23",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_16",
                northSprite = "melos_tiles_walls_wood_03a_19",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_17",
                northSprite = "melos_tiles_walls_wood_03a_20",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_18",
                northSprite = "melos_tiles_walls_wood_03a_21",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_24",
                northSprite = "melos_tiles_walls_wood_03a_27",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_25",
                northSprite = "melos_tiles_walls_wood_03a_28",
                pillar = "melos_tiles_walls_wood_03a_3"
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
                sprite = "melos_tiles_walls_wood_03a_26",
                northSprite = "melos_tiles_walls_wood_03a_29",
                pillar = "melos_tiles_walls_wood_03a_3"
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
            { sprite = "melos_tiles_walls_wood_03a_96", northSprite = "melos_tiles_walls_wood_03a_101" }
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
            { sprite = "melos_tiles_walls_wood_03a_97", northSprite = "melos_tiles_walls_wood_03a_100" }
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
            { sprite = "melos_tiles_walls_wood_03a_98", northSprite = "melos_tiles_walls_wood_03a_99" }
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
            { sprite = "melos_tiles_walls_wood_03a_112", northSprite = "melos_tiles_walls_wood_03a_117" }
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
            { sprite = "melos_tiles_walls_wood_03a_113", northSprite = "melos_tiles_walls_wood_03a_116" }
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
            { sprite = "melos_tiles_walls_wood_03a_114", northSprite = "melos_tiles_walls_wood_03a_115" }
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
            { sprite = "melos_tiles_walls_wood_03a_104", northSprite = "melos_tiles_walls_wood_03a_109" }
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
            { sprite = "melos_tiles_walls_wood_03a_105", northSprite = "melos_tiles_walls_wood_03a_108" }
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
            { sprite = "melos_tiles_walls_wood_03a_106", northSprite = "melos_tiles_walls_wood_03a_107" }
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
            { sprite = "melos_tiles_walls_wood_03a_32", northSprite = "melos_tiles_walls_wood_03a_61" }
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
            { sprite = "melos_tiles_walls_wood_03a_33", northSprite = "melos_tiles_walls_wood_03a_60" }
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
            { sprite = "melos_tiles_walls_wood_03a_34", northSprite = "melos_tiles_walls_wood_03a_59" }
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
            { sprite = "melos_tiles_walls_wood_03a_35", northSprite = "melos_tiles_walls_wood_03a_58" }
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
            { sprite = "melos_tiles_walls_wood_03a_36", northSprite = "melos_tiles_walls_wood_03a_57" }
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
            { sprite = "melos_tiles_walls_wood_03a_37", northSprite = "melos_tiles_walls_wood_03a_56" }
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
            { sprite = "melos_tiles_walls_wood_03a_31", northSprite = "melos_tiles_walls_wood_03a_71" }
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
            { sprite = "melos_tiles_walls_wood_03a_30", northSprite = "melos_tiles_walls_wood_03a_70" }
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
            { sprite = "melos_tiles_walls_wood_03a_39", northSprite = "melos_tiles_walls_wood_03a_63" }
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
            { sprite = "melos_tiles_walls_wood_03a_38", northSprite = "melos_tiles_walls_wood_03a_62" }
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
            { sprite = "melos_tiles_walls_wood_03a_47", northSprite = "melos_tiles_walls_wood_03a_55" }
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
            { sprite = "melos_tiles_walls_wood_03a_46", northSprite = "melos_tiles_walls_wood_03a_54" }
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
            { sprite = "melos_tiles_walls_wood_03a_40", northSprite = "melos_tiles_walls_wood_03a_53" }
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
            { sprite = "melos_tiles_walls_wood_03a_41", northSprite = "melos_tiles_walls_wood_03a_52" }
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
            { sprite = "melos_tiles_walls_wood_03a_42", northSprite = "melos_tiles_walls_wood_03a_51" }
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
            { sprite = "melos_tiles_walls_wood_03a_43", northSprite = "melos_tiles_walls_wood_03a_50" }
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
            { sprite = "melos_tiles_walls_wood_03a_44", northSprite = "melos_tiles_walls_wood_03a_49" }
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
            { sprite = "melos_tiles_walls_wood_03a_45", northSprite = "melos_tiles_walls_wood_03a_48" }
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
                sprite = "melos_tiles_walls_wood_03a_72",
                northSprite = "melos_tiles_walls_wood_03a_73",
                corner = "melos_tiles_walls_wood_03a_74",
                pillar = "melos_tiles_walls_wood_03a_75"
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
                corner = "melos_tiles_walls_wood_03a_74",
                pillar = "melos_tiles_walls_wood_03a_75"
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
                sprite = "melos_tiles_walls_wood_03a_75"
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
                sprite = "melos_tiles_walls_wood_03a_76",
                northSprite = "melos_tiles_walls_wood_03a_77",
                corner = "melos_tiles_walls_wood_03a_78",
                pillar = "melos_tiles_walls_wood_03a_79"
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
                corner = "melos_tiles_walls_wood_03a_78",
                pillar = "melos_tiles_walls_wood_03a_79"
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
                sprite = "melos_tiles_walls_wood_03a_79"
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
                sprite = "melos_tiles_walls_wood_03a_80",
                northSprite = "melos_tiles_walls_wood_03a_81",
                corner = "melos_tiles_walls_wood_03a_82",
                pillar = "melos_tiles_walls_wood_03a_83"
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
                corner = "melos_tiles_walls_wood_03a_82",
                pillar = "melos_tiles_walls_wood_03a_83"
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
                sprite = "melos_tiles_walls_wood_03a_83"
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
                sprite = "melos_tiles_walls_wood_03a_84",
                northSprite = "melos_tiles_walls_wood_03a_85",
                corner = "melos_tiles_walls_wood_03a_86",
                pillar = "melos_tiles_walls_wood_03a_87"
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
                corner = "melos_tiles_walls_wood_03a_86",
                pillar = "melos_tiles_walls_wood_03a_87"
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
                sprite = "melos_tiles_walls_wood_03a_87"
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
                sprite = "melos_tiles_walls_wood_03a_88",
                northSprite = "melos_tiles_walls_wood_03a_89",
                corner = "melos_tiles_walls_wood_03a_90",
                pillar = "melos_tiles_walls_wood_03a_91"
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
                corner = "melos_tiles_walls_wood_03a_90",
                pillar = "melos_tiles_walls_wood_03a_91"
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
                sprite = "melos_tiles_walls_wood_03a_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_melosWallsW03a",
        "melos_tiles_walls_wood_03a_0",
        melosWallsW03a
    )

-- PERT - Brick Small Thin 
    local pertWalls09 = {
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
                sprite = "melos_tiles_walls_pert_add_09_0",
                northSprite = "melos_tiles_walls_pert_add_09_1",
                corner = "melos_tiles_walls_pert_add_09_2",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                corner = "melos_tiles_walls_pert_add_09_2",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_10",
                northSprite = "melos_tiles_walls_pert_add_09_11",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_12",
                northSprite = "melos_tiles_walls_pert_add_09_14",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_13",
                northSprite = "melos_tiles_walls_pert_add_09_15",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_64",
                northSprite = "melos_tiles_walls_pert_add_09_67",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_65",
                northSprite = "melos_tiles_walls_pert_add_09_68",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_66",
                northSprite = "melos_tiles_walls_pert_add_09_69",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_8",
                northSprite = "melos_tiles_walls_pert_add_09_9",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_4",
                northSprite = "melos_tiles_walls_pert_add_09_5",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_6",
                northSprite = "melos_tiles_walls_pert_add_09_7",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_22",
                northSprite = "melos_tiles_walls_pert_add_09_23",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_16",
                northSprite = "melos_tiles_walls_pert_add_09_19",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_17",
                northSprite = "melos_tiles_walls_pert_add_09_20",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_18",
                northSprite = "melos_tiles_walls_pert_add_09_21",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_24",
                northSprite = "melos_tiles_walls_pert_add_09_27",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_25",
                northSprite = "melos_tiles_walls_pert_add_09_28",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
                sprite = "melos_tiles_walls_pert_add_09_26",
                northSprite = "melos_tiles_walls_pert_add_09_29",
                pillar = "melos_tiles_walls_pert_add_09_3"
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
            { sprite = "melos_tiles_walls_pert_add_09_96", northSprite = "melos_tiles_walls_pert_add_09_101" }
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
            { sprite = "melos_tiles_walls_pert_add_09_97", northSprite = "melos_tiles_walls_pert_add_09_100" }
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
            { sprite = "melos_tiles_walls_pert_add_09_98", northSprite = "melos_tiles_walls_pert_add_09_99" }
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
            { sprite = "melos_tiles_walls_pert_add_09_112", northSprite = "melos_tiles_walls_pert_add_09_117" }
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
            { sprite = "melos_tiles_walls_pert_add_09_113", northSprite = "melos_tiles_walls_pert_add_09_116" }
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
            { sprite = "melos_tiles_walls_pert_add_09_114", northSprite = "melos_tiles_walls_pert_add_09_115" }
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
            { sprite = "melos_tiles_walls_pert_add_09_104", northSprite = "melos_tiles_walls_pert_add_09_109" }
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
            { sprite = "melos_tiles_walls_pert_add_09_105", northSprite = "melos_tiles_walls_pert_add_09_108" }
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
            { sprite = "melos_tiles_walls_pert_add_09_106", northSprite = "melos_tiles_walls_pert_add_09_107" }
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
            { sprite = "melos_tiles_walls_pert_add_09_32", northSprite = "melos_tiles_walls_pert_add_09_61" }
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
            { sprite = "melos_tiles_walls_pert_add_09_33", northSprite = "melos_tiles_walls_pert_add_09_60" }
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
            { sprite = "melos_tiles_walls_pert_add_09_34", northSprite = "melos_tiles_walls_pert_add_09_59" }
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
            { sprite = "melos_tiles_walls_pert_add_09_35", northSprite = "melos_tiles_walls_pert_add_09_58" }
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
            { sprite = "melos_tiles_walls_pert_add_09_36", northSprite = "melos_tiles_walls_pert_add_09_57" }
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
            { sprite = "melos_tiles_walls_pert_add_09_37", northSprite = "melos_tiles_walls_pert_add_09_56" }
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
            { sprite = "melos_tiles_walls_pert_add_09_31", northSprite = "melos_tiles_walls_pert_add_09_71" }
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
            { sprite = "melos_tiles_walls_pert_add_09_30", northSprite = "melos_tiles_walls_pert_add_09_70" }
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
            { sprite = "melos_tiles_walls_pert_add_09_39", northSprite = "melos_tiles_walls_pert_add_09_63" }
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
            { sprite = "melos_tiles_walls_pert_add_09_38", northSprite = "melos_tiles_walls_pert_add_09_62" }
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
            { sprite = "melos_tiles_walls_pert_add_09_47", northSprite = "melos_tiles_walls_pert_add_09_55" }
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
            { sprite = "melos_tiles_walls_pert_add_09_46", northSprite = "melos_tiles_walls_pert_add_09_54" }
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
            { sprite = "melos_tiles_walls_pert_add_09_40", northSprite = "melos_tiles_walls_pert_add_09_53" }
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
            { sprite = "melos_tiles_walls_pert_add_09_41", northSprite = "melos_tiles_walls_pert_add_09_52" }
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
            { sprite = "melos_tiles_walls_pert_add_09_42", northSprite = "melos_tiles_walls_pert_add_09_51" }
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
            { sprite = "melos_tiles_walls_pert_add_09_43", northSprite = "melos_tiles_walls_pert_add_09_50" }
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
            { sprite = "melos_tiles_walls_pert_add_09_44", northSprite = "melos_tiles_walls_pert_add_09_49" }
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
            { sprite = "melos_tiles_walls_pert_add_09_45", northSprite = "melos_tiles_walls_pert_add_09_48" }
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
                sprite = "melos_tiles_walls_pert_add_09_72",
                northSprite = "melos_tiles_walls_pert_add_09_73",
                corner = "melos_tiles_walls_pert_add_09_74",
                pillar = "melos_tiles_walls_pert_add_09_75"
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
                corner = "melos_tiles_walls_pert_add_09_74",
                pillar = "melos_tiles_walls_pert_add_09_75"
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
                sprite = "melos_tiles_walls_pert_add_09_75"
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
                sprite = "melos_tiles_walls_pert_add_09_76",
                northSprite = "melos_tiles_walls_pert_add_09_77",
                corner = "melos_tiles_walls_pert_add_09_78",
                pillar = "melos_tiles_walls_pert_add_09_79"
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
                corner = "melos_tiles_walls_pert_add_09_78",
                pillar = "melos_tiles_walls_pert_add_09_79"
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
                sprite = "melos_tiles_walls_pert_add_09_79"
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
                sprite = "melos_tiles_walls_pert_add_09_80",
                northSprite = "melos_tiles_walls_pert_add_09_81",
                corner = "melos_tiles_walls_pert_add_09_82",
                pillar = "melos_tiles_walls_pert_add_09_83"
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
                corner = "melos_tiles_walls_pert_add_09_82",
                pillar = "melos_tiles_walls_pert_add_09_83"
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
                sprite = "melos_tiles_walls_pert_add_09_83"
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
                sprite = "melos_tiles_walls_pert_add_09_84",
                northSprite = "melos_tiles_walls_pert_add_09_85",
                corner = "melos_tiles_walls_pert_add_09_86",
                pillar = "melos_tiles_walls_pert_add_09_87"
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
                corner = "melos_tiles_walls_pert_add_09_86",
                pillar = "melos_tiles_walls_pert_add_09_87"
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
                sprite = "melos_tiles_walls_pert_add_09_87"
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
                sprite = "melos_tiles_walls_pert_add_09_88",
                northSprite = "melos_tiles_walls_pert_add_09_89",
                corner = "melos_tiles_walls_pert_add_09_90",
                pillar = "melos_tiles_walls_pert_add_09_91"
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
                corner = "melos_tiles_walls_pert_add_09_90",
                pillar = "melos_tiles_walls_pert_add_09_91"
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
                sprite = "melos_tiles_walls_pert_add_09_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_pertWalls09",
        "melos_tiles_walls_pert_add_09_0",
        pertWalls09
    )
-- PERT - Brick Stone Thick 
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
-- PERT - PERT - Stone Colourful 
    local pertWalls07 = {
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
                sprite = "melos_tiles_walls_pert_add_07_0",
                northSprite = "melos_tiles_walls_pert_add_07_1",
                corner = "melos_tiles_walls_pert_add_07_2",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                corner = "melos_tiles_walls_pert_add_07_2",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_10",
                northSprite = "melos_tiles_walls_pert_add_07_11",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_12",
                northSprite = "melos_tiles_walls_pert_add_07_14",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_13",
                northSprite = "melos_tiles_walls_pert_add_07_15",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_64",
                northSprite = "melos_tiles_walls_pert_add_07_67",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_65",
                northSprite = "melos_tiles_walls_pert_add_07_68",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_66",
                northSprite = "melos_tiles_walls_pert_add_07_69",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_8",
                northSprite = "melos_tiles_walls_pert_add_07_9",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_4",
                northSprite = "melos_tiles_walls_pert_add_07_5",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_6",
                northSprite = "melos_tiles_walls_pert_add_07_7",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_22",
                northSprite = "melos_tiles_walls_pert_add_07_23",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_16",
                northSprite = "melos_tiles_walls_pert_add_07_19",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_17",
                northSprite = "melos_tiles_walls_pert_add_07_20",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_18",
                northSprite = "melos_tiles_walls_pert_add_07_21",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_24",
                northSprite = "melos_tiles_walls_pert_add_07_27",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_25",
                northSprite = "melos_tiles_walls_pert_add_07_28",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
                sprite = "melos_tiles_walls_pert_add_07_26",
                northSprite = "melos_tiles_walls_pert_add_07_29",
                pillar = "melos_tiles_walls_pert_add_07_3"
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
            { sprite = "melos_tiles_walls_pert_add_07_96", northSprite = "melos_tiles_walls_pert_add_07_101" }
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
            { sprite = "melos_tiles_walls_pert_add_07_97", northSprite = "melos_tiles_walls_pert_add_07_100" }
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
            { sprite = "melos_tiles_walls_pert_add_07_98", northSprite = "melos_tiles_walls_pert_add_07_99" }
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
            { sprite = "melos_tiles_walls_pert_add_07_112", northSprite = "melos_tiles_walls_pert_add_07_117" }
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
            { sprite = "melos_tiles_walls_pert_add_07_113", northSprite = "melos_tiles_walls_pert_add_07_116" }
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
            { sprite = "melos_tiles_walls_pert_add_07_114", northSprite = "melos_tiles_walls_pert_add_07_115" }
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
            { sprite = "melos_tiles_walls_pert_add_07_104", northSprite = "melos_tiles_walls_pert_add_07_109" }
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
            { sprite = "melos_tiles_walls_pert_add_07_105", northSprite = "melos_tiles_walls_pert_add_07_108" }
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
            { sprite = "melos_tiles_walls_pert_add_07_106", northSprite = "melos_tiles_walls_pert_add_07_107" }
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
            { sprite = "melos_tiles_walls_pert_add_07_32", northSprite = "melos_tiles_walls_pert_add_07_61" }
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
            { sprite = "melos_tiles_walls_pert_add_07_33", northSprite = "melos_tiles_walls_pert_add_07_60" }
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
            { sprite = "melos_tiles_walls_pert_add_07_34", northSprite = "melos_tiles_walls_pert_add_07_59" }
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
            { sprite = "melos_tiles_walls_pert_add_07_35", northSprite = "melos_tiles_walls_pert_add_07_58" }
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
            { sprite = "melos_tiles_walls_pert_add_07_36", northSprite = "melos_tiles_walls_pert_add_07_57" }
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
            { sprite = "melos_tiles_walls_pert_add_07_37", northSprite = "melos_tiles_walls_pert_add_07_56" }
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
            { sprite = "melos_tiles_walls_pert_add_07_31", northSprite = "melos_tiles_walls_pert_add_07_71" }
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
            { sprite = "melos_tiles_walls_pert_add_07_30", northSprite = "melos_tiles_walls_pert_add_07_70" }
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
            { sprite = "melos_tiles_walls_pert_add_07_39", northSprite = "melos_tiles_walls_pert_add_07_63" }
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
            { sprite = "melos_tiles_walls_pert_add_07_38", northSprite = "melos_tiles_walls_pert_add_07_62" }
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
            { sprite = "melos_tiles_walls_pert_add_07_47", northSprite = "melos_tiles_walls_pert_add_07_55" }
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
            { sprite = "melos_tiles_walls_pert_add_07_46", northSprite = "melos_tiles_walls_pert_add_07_54" }
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
            { sprite = "melos_tiles_walls_pert_add_07_40", northSprite = "melos_tiles_walls_pert_add_07_53" }
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
            { sprite = "melos_tiles_walls_pert_add_07_41", northSprite = "melos_tiles_walls_pert_add_07_52" }
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
            { sprite = "melos_tiles_walls_pert_add_07_42", northSprite = "melos_tiles_walls_pert_add_07_51" }
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
            { sprite = "melos_tiles_walls_pert_add_07_43", northSprite = "melos_tiles_walls_pert_add_07_50" }
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
            { sprite = "melos_tiles_walls_pert_add_07_44", northSprite = "melos_tiles_walls_pert_add_07_49" }
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
            { sprite = "melos_tiles_walls_pert_add_07_45", northSprite = "melos_tiles_walls_pert_add_07_48" }
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
                sprite = "melos_tiles_walls_pert_add_07_72",
                northSprite = "melos_tiles_walls_pert_add_07_73",
                corner = "melos_tiles_walls_pert_add_07_74",
                pillar = "melos_tiles_walls_pert_add_07_75"
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
                corner = "melos_tiles_walls_pert_add_07_74",
                pillar = "melos_tiles_walls_pert_add_07_75"
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
                sprite = "melos_tiles_walls_pert_add_07_75"
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
                sprite = "melos_tiles_walls_pert_add_07_76",
                northSprite = "melos_tiles_walls_pert_add_07_77",
                corner = "melos_tiles_walls_pert_add_07_78",
                pillar = "melos_tiles_walls_pert_add_07_79"
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
                corner = "melos_tiles_walls_pert_add_07_78",
                pillar = "melos_tiles_walls_pert_add_07_79"
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
                sprite = "melos_tiles_walls_pert_add_07_79"
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
                sprite = "melos_tiles_walls_pert_add_07_80",
                northSprite = "melos_tiles_walls_pert_add_07_81",
                corner = "melos_tiles_walls_pert_add_07_82",
                pillar = "melos_tiles_walls_pert_add_07_83"
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
                corner = "melos_tiles_walls_pert_add_07_82",
                pillar = "melos_tiles_walls_pert_add_07_83"
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
                sprite = "melos_tiles_walls_pert_add_07_83"
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
                sprite = "melos_tiles_walls_pert_add_07_84",
                northSprite = "melos_tiles_walls_pert_add_07_85",
                corner = "melos_tiles_walls_pert_add_07_86",
                pillar = "melos_tiles_walls_pert_add_07_87"
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
                corner = "melos_tiles_walls_pert_add_07_86",
                pillar = "melos_tiles_walls_pert_add_07_87"
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
                sprite = "melos_tiles_walls_pert_add_07_87"
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
                sprite = "melos_tiles_walls_pert_add_07_88",
                northSprite = "melos_tiles_walls_pert_add_07_89",
                corner = "melos_tiles_walls_pert_add_07_90",
                pillar = "melos_tiles_walls_pert_add_07_91"
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
                corner = "melos_tiles_walls_pert_add_07_90",
                pillar = "melos_tiles_walls_pert_add_07_91"
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
                sprite = "melos_tiles_walls_pert_add_07_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_pertWalls07",
        "melos_tiles_walls_pert_add_07_0",
        pertWalls07
    )
-- PERT - Stone Dark 
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
-- PERT - Stone Grey 
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
-- PERT - Stone Red 
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
-- PERT - Stone White 
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
-- PERT - Stone Small Grey 
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
-- PERT - Stone Small Tan 
    local pertWalls08 = {
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
                sprite = "melos_tiles_walls_pert_add_08_0",
                northSprite = "melos_tiles_walls_pert_add_08_1",
                corner = "melos_tiles_walls_pert_add_08_2",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                corner = "melos_tiles_walls_pert_add_08_2",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_10",
                northSprite = "melos_tiles_walls_pert_add_08_11",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_12",
                northSprite = "melos_tiles_walls_pert_add_08_14",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_13",
                northSprite = "melos_tiles_walls_pert_add_08_15",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_64",
                northSprite = "melos_tiles_walls_pert_add_08_67",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_65",
                northSprite = "melos_tiles_walls_pert_add_08_68",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_66",
                northSprite = "melos_tiles_walls_pert_add_08_69",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_8",
                northSprite = "melos_tiles_walls_pert_add_08_9",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_4",
                northSprite = "melos_tiles_walls_pert_add_08_5",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_6",
                northSprite = "melos_tiles_walls_pert_add_08_7",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_22",
                northSprite = "melos_tiles_walls_pert_add_08_23",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_16",
                northSprite = "melos_tiles_walls_pert_add_08_19",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_17",
                northSprite = "melos_tiles_walls_pert_add_08_20",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_18",
                northSprite = "melos_tiles_walls_pert_add_08_21",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_24",
                northSprite = "melos_tiles_walls_pert_add_08_27",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_25",
                northSprite = "melos_tiles_walls_pert_add_08_28",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
                sprite = "melos_tiles_walls_pert_add_08_26",
                northSprite = "melos_tiles_walls_pert_add_08_29",
                pillar = "melos_tiles_walls_pert_add_08_3"
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
            { sprite = "melos_tiles_walls_pert_add_08_96", northSprite = "melos_tiles_walls_pert_add_08_101" }
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
            { sprite = "melos_tiles_walls_pert_add_08_97", northSprite = "melos_tiles_walls_pert_add_08_100" }
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
            { sprite = "melos_tiles_walls_pert_add_08_98", northSprite = "melos_tiles_walls_pert_add_08_99" }
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
            { sprite = "melos_tiles_walls_pert_add_08_112", northSprite = "melos_tiles_walls_pert_add_08_117" }
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
            { sprite = "melos_tiles_walls_pert_add_08_113", northSprite = "melos_tiles_walls_pert_add_08_116" }
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
            { sprite = "melos_tiles_walls_pert_add_08_114", northSprite = "melos_tiles_walls_pert_add_08_115" }
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
            { sprite = "melos_tiles_walls_pert_add_08_104", northSprite = "melos_tiles_walls_pert_add_08_109" }
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
            { sprite = "melos_tiles_walls_pert_add_08_105", northSprite = "melos_tiles_walls_pert_add_08_108" }
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
            { sprite = "melos_tiles_walls_pert_add_08_106", northSprite = "melos_tiles_walls_pert_add_08_107" }
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
            { sprite = "melos_tiles_walls_pert_add_08_32", northSprite = "melos_tiles_walls_pert_add_08_61" }
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
            { sprite = "melos_tiles_walls_pert_add_08_33", northSprite = "melos_tiles_walls_pert_add_08_60" }
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
            { sprite = "melos_tiles_walls_pert_add_08_34", northSprite = "melos_tiles_walls_pert_add_08_59" }
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
            { sprite = "melos_tiles_walls_pert_add_08_35", northSprite = "melos_tiles_walls_pert_add_08_58" }
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
            { sprite = "melos_tiles_walls_pert_add_08_36", northSprite = "melos_tiles_walls_pert_add_08_57" }
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
            { sprite = "melos_tiles_walls_pert_add_08_37", northSprite = "melos_tiles_walls_pert_add_08_56" }
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
            { sprite = "melos_tiles_walls_pert_add_08_31", northSprite = "melos_tiles_walls_pert_add_08_71" }
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
            { sprite = "melos_tiles_walls_pert_add_08_30", northSprite = "melos_tiles_walls_pert_add_08_70" }
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
            { sprite = "melos_tiles_walls_pert_add_08_39", northSprite = "melos_tiles_walls_pert_add_08_63" }
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
            { sprite = "melos_tiles_walls_pert_add_08_38", northSprite = "melos_tiles_walls_pert_add_08_62" }
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
            { sprite = "melos_tiles_walls_pert_add_08_47", northSprite = "melos_tiles_walls_pert_add_08_55" }
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
            { sprite = "melos_tiles_walls_pert_add_08_46", northSprite = "melos_tiles_walls_pert_add_08_54" }
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
            { sprite = "melos_tiles_walls_pert_add_08_40", northSprite = "melos_tiles_walls_pert_add_08_53" }
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
            { sprite = "melos_tiles_walls_pert_add_08_41", northSprite = "melos_tiles_walls_pert_add_08_52" }
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
            { sprite = "melos_tiles_walls_pert_add_08_42", northSprite = "melos_tiles_walls_pert_add_08_51" }
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
            { sprite = "melos_tiles_walls_pert_add_08_43", northSprite = "melos_tiles_walls_pert_add_08_50" }
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
            { sprite = "melos_tiles_walls_pert_add_08_44", northSprite = "melos_tiles_walls_pert_add_08_49" }
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
            { sprite = "melos_tiles_walls_pert_add_08_45", northSprite = "melos_tiles_walls_pert_add_08_48" }
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
                sprite = "melos_tiles_walls_pert_add_08_72",
                northSprite = "melos_tiles_walls_pert_add_08_73",
                corner = "melos_tiles_walls_pert_add_08_74",
                pillar = "melos_tiles_walls_pert_add_08_75"
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
                corner = "melos_tiles_walls_pert_add_08_74",
                pillar = "melos_tiles_walls_pert_add_08_75"
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
                sprite = "melos_tiles_walls_pert_add_08_75"
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
                sprite = "melos_tiles_walls_pert_add_08_76",
                northSprite = "melos_tiles_walls_pert_add_08_77",
                corner = "melos_tiles_walls_pert_add_08_78",
                pillar = "melos_tiles_walls_pert_add_08_79"
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
                corner = "melos_tiles_walls_pert_add_08_78",
                pillar = "melos_tiles_walls_pert_add_08_79"
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
                sprite = "melos_tiles_walls_pert_add_08_79"
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
                sprite = "melos_tiles_walls_pert_add_08_80",
                northSprite = "melos_tiles_walls_pert_add_08_81",
                corner = "melos_tiles_walls_pert_add_08_82",
                pillar = "melos_tiles_walls_pert_add_08_83"
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
                corner = "melos_tiles_walls_pert_add_08_82",
                pillar = "melos_tiles_walls_pert_add_08_83"
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
                sprite = "melos_tiles_walls_pert_add_08_83"
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
                sprite = "melos_tiles_walls_pert_add_08_84",
                northSprite = "melos_tiles_walls_pert_add_08_85",
                corner = "melos_tiles_walls_pert_add_08_86",
                pillar = "melos_tiles_walls_pert_add_08_87"
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
                corner = "melos_tiles_walls_pert_add_08_86",
                pillar = "melos_tiles_walls_pert_add_08_87"
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
                sprite = "melos_tiles_walls_pert_add_08_87"
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
                sprite = "melos_tiles_walls_pert_add_08_88",
                northSprite = "melos_tiles_walls_pert_add_08_89",
                corner = "melos_tiles_walls_pert_add_08_90",
                pillar = "melos_tiles_walls_pert_add_08_91"
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
                corner = "melos_tiles_walls_pert_add_08_90",
                pillar = "melos_tiles_walls_pert_add_08_91"
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
                sprite = "melos_tiles_walls_pert_add_08_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_pertWalls08",
        "melos_tiles_walls_pert_add_08_0",
        pertWalls08
    )
-- PERT - Wood Thin Brown
    local pertWalls13 = {
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
                sprite = "melos_tiles_walls_pert_add_13_0",
                northSprite = "melos_tiles_walls_pert_add_13_1",
                corner = "melos_tiles_walls_pert_add_13_2",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                corner = "melos_tiles_walls_pert_add_13_2",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_10",
                northSprite = "melos_tiles_walls_pert_add_13_11",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_12",
                northSprite = "melos_tiles_walls_pert_add_13_14",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_13",
                northSprite = "melos_tiles_walls_pert_add_13_15",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_64",
                northSprite = "melos_tiles_walls_pert_add_13_67",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_65",
                northSprite = "melos_tiles_walls_pert_add_13_68",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_66",
                northSprite = "melos_tiles_walls_pert_add_13_69",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_8",
                northSprite = "melos_tiles_walls_pert_add_13_9",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_4",
                northSprite = "melos_tiles_walls_pert_add_13_5",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_6",
                northSprite = "melos_tiles_walls_pert_add_13_7",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_22",
                northSprite = "melos_tiles_walls_pert_add_13_23",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_16",
                northSprite = "melos_tiles_walls_pert_add_13_19",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_17",
                northSprite = "melos_tiles_walls_pert_add_13_20",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_18",
                northSprite = "melos_tiles_walls_pert_add_13_21",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_24",
                northSprite = "melos_tiles_walls_pert_add_13_27",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_25",
                northSprite = "melos_tiles_walls_pert_add_13_28",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
                sprite = "melos_tiles_walls_pert_add_13_26",
                northSprite = "melos_tiles_walls_pert_add_13_29",
                pillar = "melos_tiles_walls_pert_add_13_3"
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
            { sprite = "melos_tiles_walls_pert_add_13_96", northSprite = "melos_tiles_walls_pert_add_13_101" }
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
            { sprite = "melos_tiles_walls_pert_add_13_97", northSprite = "melos_tiles_walls_pert_add_13_100" }
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
            { sprite = "melos_tiles_walls_pert_add_13_98", northSprite = "melos_tiles_walls_pert_add_13_99" }
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
            { sprite = "melos_tiles_walls_pert_add_13_112", northSprite = "melos_tiles_walls_pert_add_13_117" }
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
            { sprite = "melos_tiles_walls_pert_add_13_113", northSprite = "melos_tiles_walls_pert_add_13_116" }
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
            { sprite = "melos_tiles_walls_pert_add_13_114", northSprite = "melos_tiles_walls_pert_add_13_115" }
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
            { sprite = "melos_tiles_walls_pert_add_13_104", northSprite = "melos_tiles_walls_pert_add_13_109" }
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
            { sprite = "melos_tiles_walls_pert_add_13_105", northSprite = "melos_tiles_walls_pert_add_13_108" }
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
            { sprite = "melos_tiles_walls_pert_add_13_106", northSprite = "melos_tiles_walls_pert_add_13_107" }
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
            { sprite = "melos_tiles_walls_pert_add_13_32", northSprite = "melos_tiles_walls_pert_add_13_61" }
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
            { sprite = "melos_tiles_walls_pert_add_13_33", northSprite = "melos_tiles_walls_pert_add_13_60" }
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
            { sprite = "melos_tiles_walls_pert_add_13_34", northSprite = "melos_tiles_walls_pert_add_13_59" }
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
            { sprite = "melos_tiles_walls_pert_add_13_35", northSprite = "melos_tiles_walls_pert_add_13_58" }
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
            { sprite = "melos_tiles_walls_pert_add_13_36", northSprite = "melos_tiles_walls_pert_add_13_57" }
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
            { sprite = "melos_tiles_walls_pert_add_13_37", northSprite = "melos_tiles_walls_pert_add_13_56" }
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
            { sprite = "melos_tiles_walls_pert_add_13_31", northSprite = "melos_tiles_walls_pert_add_13_71" }
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
            { sprite = "melos_tiles_walls_pert_add_13_30", northSprite = "melos_tiles_walls_pert_add_13_70" }
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
            { sprite = "melos_tiles_walls_pert_add_13_39", northSprite = "melos_tiles_walls_pert_add_13_63" }
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
            { sprite = "melos_tiles_walls_pert_add_13_38", northSprite = "melos_tiles_walls_pert_add_13_62" }
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
            { sprite = "melos_tiles_walls_pert_add_13_47", northSprite = "melos_tiles_walls_pert_add_13_55" }
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
            { sprite = "melos_tiles_walls_pert_add_13_46", northSprite = "melos_tiles_walls_pert_add_13_54" }
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
            { sprite = "melos_tiles_walls_pert_add_13_40", northSprite = "melos_tiles_walls_pert_add_13_53" }
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
            { sprite = "melos_tiles_walls_pert_add_13_41", northSprite = "melos_tiles_walls_pert_add_13_52" }
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
            { sprite = "melos_tiles_walls_pert_add_13_42", northSprite = "melos_tiles_walls_pert_add_13_51" }
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
            { sprite = "melos_tiles_walls_pert_add_13_43", northSprite = "melos_tiles_walls_pert_add_13_50" }
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
            { sprite = "melos_tiles_walls_pert_add_13_44", northSprite = "melos_tiles_walls_pert_add_13_49" }
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
            { sprite = "melos_tiles_walls_pert_add_13_45", northSprite = "melos_tiles_walls_pert_add_13_48" }
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
                sprite = "melos_tiles_walls_pert_add_13_72",
                northSprite = "melos_tiles_walls_pert_add_13_73",
                corner = "melos_tiles_walls_pert_add_13_74",
                pillar = "melos_tiles_walls_pert_add_13_75"
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
                corner = "melos_tiles_walls_pert_add_13_74",
                pillar = "melos_tiles_walls_pert_add_13_75"
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
                sprite = "melos_tiles_walls_pert_add_13_75"
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
                sprite = "melos_tiles_walls_pert_add_13_76",
                northSprite = "melos_tiles_walls_pert_add_13_77",
                corner = "melos_tiles_walls_pert_add_13_78",
                pillar = "melos_tiles_walls_pert_add_13_79"
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
                corner = "melos_tiles_walls_pert_add_13_78",
                pillar = "melos_tiles_walls_pert_add_13_79"
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
                sprite = "melos_tiles_walls_pert_add_13_79"
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
                sprite = "melos_tiles_walls_pert_add_13_80",
                northSprite = "melos_tiles_walls_pert_add_13_81",
                corner = "melos_tiles_walls_pert_add_13_82",
                pillar = "melos_tiles_walls_pert_add_13_83"
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
                corner = "melos_tiles_walls_pert_add_13_82",
                pillar = "melos_tiles_walls_pert_add_13_83"
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
                sprite = "melos_tiles_walls_pert_add_13_83"
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
                sprite = "melos_tiles_walls_pert_add_13_84",
                northSprite = "melos_tiles_walls_pert_add_13_85",
                corner = "melos_tiles_walls_pert_add_13_86",
                pillar = "melos_tiles_walls_pert_add_13_87"
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
                corner = "melos_tiles_walls_pert_add_13_86",
                pillar = "melos_tiles_walls_pert_add_13_87"
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
                sprite = "melos_tiles_walls_pert_add_13_87"
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
                sprite = "melos_tiles_walls_pert_add_13_88",
                northSprite = "melos_tiles_walls_pert_add_13_89",
                corner = "melos_tiles_walls_pert_add_13_90",
                pillar = "melos_tiles_walls_pert_add_13_91"
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
                corner = "melos_tiles_walls_pert_add_13_90",
                pillar = "melos_tiles_walls_pert_add_13_91"
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
                sprite = "melos_tiles_walls_pert_add_13_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_pertWalls13",
        "melos_tiles_walls_pert_add_13_0",
        pertWalls13
    )
-- PERT - Wood Thin Dark
    local pertWalls14 = {
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
                sprite = "melos_tiles_walls_pert_add_14_0",
                northSprite = "melos_tiles_walls_pert_add_14_1",
                corner = "melos_tiles_walls_pert_add_14_2",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                corner = "melos_tiles_walls_pert_add_14_2",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_10",
                northSprite = "melos_tiles_walls_pert_add_14_11",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_12",
                northSprite = "melos_tiles_walls_pert_add_14_14",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_13",
                northSprite = "melos_tiles_walls_pert_add_14_15",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_64",
                northSprite = "melos_tiles_walls_pert_add_14_67",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_65",
                northSprite = "melos_tiles_walls_pert_add_14_68",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_66",
                northSprite = "melos_tiles_walls_pert_add_14_69",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_8",
                northSprite = "melos_tiles_walls_pert_add_14_9",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_4",
                northSprite = "melos_tiles_walls_pert_add_14_5",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_6",
                northSprite = "melos_tiles_walls_pert_add_14_7",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_22",
                northSprite = "melos_tiles_walls_pert_add_14_23",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_16",
                northSprite = "melos_tiles_walls_pert_add_14_19",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_17",
                northSprite = "melos_tiles_walls_pert_add_14_20",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_18",
                northSprite = "melos_tiles_walls_pert_add_14_21",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_24",
                northSprite = "melos_tiles_walls_pert_add_14_27",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_25",
                northSprite = "melos_tiles_walls_pert_add_14_28",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
                sprite = "melos_tiles_walls_pert_add_14_26",
                northSprite = "melos_tiles_walls_pert_add_14_29",
                pillar = "melos_tiles_walls_pert_add_14_3"
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
            { sprite = "melos_tiles_walls_pert_add_14_96", northSprite = "melos_tiles_walls_pert_add_14_101" }
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
            { sprite = "melos_tiles_walls_pert_add_14_97", northSprite = "melos_tiles_walls_pert_add_14_100" }
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
            { sprite = "melos_tiles_walls_pert_add_14_98", northSprite = "melos_tiles_walls_pert_add_14_99" }
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
            { sprite = "melos_tiles_walls_pert_add_14_112", northSprite = "melos_tiles_walls_pert_add_14_117" }
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
            { sprite = "melos_tiles_walls_pert_add_14_113", northSprite = "melos_tiles_walls_pert_add_14_116" }
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
            { sprite = "melos_tiles_walls_pert_add_14_114", northSprite = "melos_tiles_walls_pert_add_14_115" }
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
            { sprite = "melos_tiles_walls_pert_add_14_104", northSprite = "melos_tiles_walls_pert_add_14_109" }
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
            { sprite = "melos_tiles_walls_pert_add_14_105", northSprite = "melos_tiles_walls_pert_add_14_108" }
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
            { sprite = "melos_tiles_walls_pert_add_14_106", northSprite = "melos_tiles_walls_pert_add_14_107" }
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
            { sprite = "melos_tiles_walls_pert_add_14_32", northSprite = "melos_tiles_walls_pert_add_14_61" }
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
            { sprite = "melos_tiles_walls_pert_add_14_33", northSprite = "melos_tiles_walls_pert_add_14_60" }
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
            { sprite = "melos_tiles_walls_pert_add_14_34", northSprite = "melos_tiles_walls_pert_add_14_59" }
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
            { sprite = "melos_tiles_walls_pert_add_14_35", northSprite = "melos_tiles_walls_pert_add_14_58" }
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
            { sprite = "melos_tiles_walls_pert_add_14_36", northSprite = "melos_tiles_walls_pert_add_14_57" }
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
            { sprite = "melos_tiles_walls_pert_add_14_37", northSprite = "melos_tiles_walls_pert_add_14_56" }
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
            { sprite = "melos_tiles_walls_pert_add_14_31", northSprite = "melos_tiles_walls_pert_add_14_71" }
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
            { sprite = "melos_tiles_walls_pert_add_14_30", northSprite = "melos_tiles_walls_pert_add_14_70" }
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
            { sprite = "melos_tiles_walls_pert_add_14_39", northSprite = "melos_tiles_walls_pert_add_14_63" }
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
            { sprite = "melos_tiles_walls_pert_add_14_38", northSprite = "melos_tiles_walls_pert_add_14_62" }
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
            { sprite = "melos_tiles_walls_pert_add_14_47", northSprite = "melos_tiles_walls_pert_add_14_55" }
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
            { sprite = "melos_tiles_walls_pert_add_14_46", northSprite = "melos_tiles_walls_pert_add_14_54" }
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
            { sprite = "melos_tiles_walls_pert_add_14_40", northSprite = "melos_tiles_walls_pert_add_14_53" }
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
            { sprite = "melos_tiles_walls_pert_add_14_41", northSprite = "melos_tiles_walls_pert_add_14_52" }
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
            { sprite = "melos_tiles_walls_pert_add_14_42", northSprite = "melos_tiles_walls_pert_add_14_51" }
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
            { sprite = "melos_tiles_walls_pert_add_14_43", northSprite = "melos_tiles_walls_pert_add_14_50" }
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
            { sprite = "melos_tiles_walls_pert_add_14_44", northSprite = "melos_tiles_walls_pert_add_14_49" }
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
            { sprite = "melos_tiles_walls_pert_add_14_45", northSprite = "melos_tiles_walls_pert_add_14_48" }
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
                sprite = "melos_tiles_walls_pert_add_14_72",
                northSprite = "melos_tiles_walls_pert_add_14_73",
                corner = "melos_tiles_walls_pert_add_14_74",
                pillar = "melos_tiles_walls_pert_add_14_75"
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
                corner = "melos_tiles_walls_pert_add_14_74",
                pillar = "melos_tiles_walls_pert_add_14_75"
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
                sprite = "melos_tiles_walls_pert_add_14_75"
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
                sprite = "melos_tiles_walls_pert_add_14_76",
                northSprite = "melos_tiles_walls_pert_add_14_77",
                corner = "melos_tiles_walls_pert_add_14_78",
                pillar = "melos_tiles_walls_pert_add_14_79"
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
                corner = "melos_tiles_walls_pert_add_14_78",
                pillar = "melos_tiles_walls_pert_add_14_79"
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
                sprite = "melos_tiles_walls_pert_add_14_79"
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
                sprite = "melos_tiles_walls_pert_add_14_80",
                northSprite = "melos_tiles_walls_pert_add_14_81",
                corner = "melos_tiles_walls_pert_add_14_82",
                pillar = "melos_tiles_walls_pert_add_14_83"
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
                corner = "melos_tiles_walls_pert_add_14_82",
                pillar = "melos_tiles_walls_pert_add_14_83"
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
                sprite = "melos_tiles_walls_pert_add_14_83"
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
                sprite = "melos_tiles_walls_pert_add_14_84",
                northSprite = "melos_tiles_walls_pert_add_14_85",
                corner = "melos_tiles_walls_pert_add_14_86",
                pillar = "melos_tiles_walls_pert_add_14_87"
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
                corner = "melos_tiles_walls_pert_add_14_86",
                pillar = "melos_tiles_walls_pert_add_14_87"
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
                sprite = "melos_tiles_walls_pert_add_14_87"
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
                sprite = "melos_tiles_walls_pert_add_14_88",
                northSprite = "melos_tiles_walls_pert_add_14_89",
                corner = "melos_tiles_walls_pert_add_14_90",
                pillar = "melos_tiles_walls_pert_add_14_91"
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
                corner = "melos_tiles_walls_pert_add_14_90",
                pillar = "melos_tiles_walls_pert_add_14_91"
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
                sprite = "melos_tiles_walls_pert_add_14_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_pertWalls14",
        "melos_tiles_walls_pert_add_14_0",
        pertWalls14
    )
-- PERT - Wood Thin Light
    local pertWalls12 = {
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
                sprite = "melos_tiles_walls_pert_add_12_0",
                northSprite = "melos_tiles_walls_pert_add_12_1",
                corner = "melos_tiles_walls_pert_add_12_2",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                corner = "melos_tiles_walls_pert_add_12_2",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_10",
                northSprite = "melos_tiles_walls_pert_add_12_11",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_12",
                northSprite = "melos_tiles_walls_pert_add_12_14",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_13",
                northSprite = "melos_tiles_walls_pert_add_12_15",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_64",
                northSprite = "melos_tiles_walls_pert_add_12_67",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_65",
                northSprite = "melos_tiles_walls_pert_add_12_68",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_66",
                northSprite = "melos_tiles_walls_pert_add_12_69",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_8",
                northSprite = "melos_tiles_walls_pert_add_12_9",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_4",
                northSprite = "melos_tiles_walls_pert_add_12_5",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_6",
                northSprite = "melos_tiles_walls_pert_add_12_7",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_22",
                northSprite = "melos_tiles_walls_pert_add_12_23",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_16",
                northSprite = "melos_tiles_walls_pert_add_12_19",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_17",
                northSprite = "melos_tiles_walls_pert_add_12_20",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_18",
                northSprite = "melos_tiles_walls_pert_add_12_21",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_24",
                northSprite = "melos_tiles_walls_pert_add_12_27",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_25",
                northSprite = "melos_tiles_walls_pert_add_12_28",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
                sprite = "melos_tiles_walls_pert_add_12_26",
                northSprite = "melos_tiles_walls_pert_add_12_29",
                pillar = "melos_tiles_walls_pert_add_12_3"
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
            { sprite = "melos_tiles_walls_pert_add_12_96", northSprite = "melos_tiles_walls_pert_add_12_101" }
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
            { sprite = "melos_tiles_walls_pert_add_12_97", northSprite = "melos_tiles_walls_pert_add_12_100" }
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
            { sprite = "melos_tiles_walls_pert_add_12_98", northSprite = "melos_tiles_walls_pert_add_12_99" }
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
            { sprite = "melos_tiles_walls_pert_add_12_112", northSprite = "melos_tiles_walls_pert_add_12_117" }
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
            { sprite = "melos_tiles_walls_pert_add_12_113", northSprite = "melos_tiles_walls_pert_add_12_116" }
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
            { sprite = "melos_tiles_walls_pert_add_12_114", northSprite = "melos_tiles_walls_pert_add_12_115" }
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
            { sprite = "melos_tiles_walls_pert_add_12_104", northSprite = "melos_tiles_walls_pert_add_12_109" }
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
            { sprite = "melos_tiles_walls_pert_add_12_105", northSprite = "melos_tiles_walls_pert_add_12_108" }
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
            { sprite = "melos_tiles_walls_pert_add_12_106", northSprite = "melos_tiles_walls_pert_add_12_107" }
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
            { sprite = "melos_tiles_walls_pert_add_12_32", northSprite = "melos_tiles_walls_pert_add_12_61" }
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
            { sprite = "melos_tiles_walls_pert_add_12_33", northSprite = "melos_tiles_walls_pert_add_12_60" }
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
            { sprite = "melos_tiles_walls_pert_add_12_34", northSprite = "melos_tiles_walls_pert_add_12_59" }
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
            { sprite = "melos_tiles_walls_pert_add_12_35", northSprite = "melos_tiles_walls_pert_add_12_58" }
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
            { sprite = "melos_tiles_walls_pert_add_12_36", northSprite = "melos_tiles_walls_pert_add_12_57" }
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
            { sprite = "melos_tiles_walls_pert_add_12_37", northSprite = "melos_tiles_walls_pert_add_12_56" }
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
            { sprite = "melos_tiles_walls_pert_add_12_31", northSprite = "melos_tiles_walls_pert_add_12_71" }
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
            { sprite = "melos_tiles_walls_pert_add_12_30", northSprite = "melos_tiles_walls_pert_add_12_70" }
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
            { sprite = "melos_tiles_walls_pert_add_12_39", northSprite = "melos_tiles_walls_pert_add_12_63" }
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
            { sprite = "melos_tiles_walls_pert_add_12_38", northSprite = "melos_tiles_walls_pert_add_12_62" }
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
            { sprite = "melos_tiles_walls_pert_add_12_47", northSprite = "melos_tiles_walls_pert_add_12_55" }
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
            { sprite = "melos_tiles_walls_pert_add_12_46", northSprite = "melos_tiles_walls_pert_add_12_54" }
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
            { sprite = "melos_tiles_walls_pert_add_12_40", northSprite = "melos_tiles_walls_pert_add_12_53" }
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
            { sprite = "melos_tiles_walls_pert_add_12_41", northSprite = "melos_tiles_walls_pert_add_12_52" }
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
            { sprite = "melos_tiles_walls_pert_add_12_42", northSprite = "melos_tiles_walls_pert_add_12_51" }
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
            { sprite = "melos_tiles_walls_pert_add_12_43", northSprite = "melos_tiles_walls_pert_add_12_50" }
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
            { sprite = "melos_tiles_walls_pert_add_12_44", northSprite = "melos_tiles_walls_pert_add_12_49" }
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
            { sprite = "melos_tiles_walls_pert_add_12_45", northSprite = "melos_tiles_walls_pert_add_12_48" }
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
                sprite = "melos_tiles_walls_pert_add_12_72",
                northSprite = "melos_tiles_walls_pert_add_12_73",
                corner = "melos_tiles_walls_pert_add_12_74",
                pillar = "melos_tiles_walls_pert_add_12_75"
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
                corner = "melos_tiles_walls_pert_add_12_74",
                pillar = "melos_tiles_walls_pert_add_12_75"
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
                sprite = "melos_tiles_walls_pert_add_12_75"
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
                sprite = "melos_tiles_walls_pert_add_12_76",
                northSprite = "melos_tiles_walls_pert_add_12_77",
                corner = "melos_tiles_walls_pert_add_12_78",
                pillar = "melos_tiles_walls_pert_add_12_79"
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
                corner = "melos_tiles_walls_pert_add_12_78",
                pillar = "melos_tiles_walls_pert_add_12_79"
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
                sprite = "melos_tiles_walls_pert_add_12_79"
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
                sprite = "melos_tiles_walls_pert_add_12_80",
                northSprite = "melos_tiles_walls_pert_add_12_81",
                corner = "melos_tiles_walls_pert_add_12_82",
                pillar = "melos_tiles_walls_pert_add_12_83"
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
                corner = "melos_tiles_walls_pert_add_12_82",
                pillar = "melos_tiles_walls_pert_add_12_83"
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
                sprite = "melos_tiles_walls_pert_add_12_83"
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
                sprite = "melos_tiles_walls_pert_add_12_84",
                northSprite = "melos_tiles_walls_pert_add_12_85",
                corner = "melos_tiles_walls_pert_add_12_86",
                pillar = "melos_tiles_walls_pert_add_12_87"
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
                corner = "melos_tiles_walls_pert_add_12_86",
                pillar = "melos_tiles_walls_pert_add_12_87"
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
                sprite = "melos_tiles_walls_pert_add_12_87"
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
                sprite = "melos_tiles_walls_pert_add_12_88",
                northSprite = "melos_tiles_walls_pert_add_12_89",
                corner = "melos_tiles_walls_pert_add_12_90",
                pillar = "melos_tiles_walls_pert_add_12_91"
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
                corner = "melos_tiles_walls_pert_add_12_90",
                pillar = "melos_tiles_walls_pert_add_12_91"
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
                sprite = "melos_tiles_walls_pert_add_12_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_pertWalls12",
        "melos_tiles_walls_pert_add_12_0",
        pertWalls12
    )
-- PERT - Wood Pannel Fancy Black
    local pertWalls19 = {
 -- WALL NORMAL
        BuildingMenu.createObject(
            "Tooltip_WallWall_Name",
            "Tooltip_WallWall_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_0",
                northSprite = "melos_tiles_walls_pert_add_19_1",
                corner = "melos_tiles_walls_pert_add_19_2",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
 -- WALL CORNER
        BuildingMenu.createObject(
            "Tooltip_WallCorner_Name",
            "Tooltip_WallCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_19_2",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
 -- WALL PILLAR
        BuildingMenu.createObject(
            "Tooltip_WallPillar_Name",
            "Tooltip_WallPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_19_3"
            }
        ),
 -- DOOR FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildDoorFrame,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_10",
                northSprite = "melos_tiles_walls_pert_add_19_11",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_12",
                northSprite = "melos_tiles_walls_pert_add_19_14",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_13",
                northSprite = "melos_tiles_walls_pert_add_19_15",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_64",
                northSprite = "melos_tiles_walls_pert_add_19_67",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_65",
                northSprite = "melos_tiles_walls_pert_add_19_68",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_66",
                northSprite = "melos_tiles_walls_pert_add_19_69",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
 -- WINDOW FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_8",
                northSprite = "melos_tiles_walls_pert_add_19_9",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_4",
                northSprite = "melos_tiles_walls_pert_add_19_5",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_6",
                northSprite = "melos_tiles_walls_pert_add_19_7",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_22",
                northSprite = "melos_tiles_walls_pert_add_19_23",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_16",
                northSprite = "melos_tiles_walls_pert_add_19_19",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_17",
                northSprite = "melos_tiles_walls_pert_add_19_20",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_18",
                northSprite = "melos_tiles_walls_pert_add_19_21",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_24",
                northSprite = "melos_tiles_walls_pert_add_19_27",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_25",
                northSprite = "melos_tiles_walls_pert_add_19_28",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_26",
                northSprite = "melos_tiles_walls_pert_add_19_29",
                pillar = "melos_tiles_walls_pert_add_19_3"
            }
        ),
 -- ROOF WALLS
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_96", northSprite = "melos_tiles_walls_pert_add_19_101" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_97", northSprite = "melos_tiles_walls_pert_add_19_100" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_98", northSprite = "melos_tiles_walls_pert_add_19_99" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_112", northSprite = "melos_tiles_walls_pert_add_19_117" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_113", northSprite = "melos_tiles_walls_pert_add_19_116" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_114", northSprite = "melos_tiles_walls_pert_add_19_115" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_104", northSprite = "melos_tiles_walls_pert_add_19_109" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_105", northSprite = "melos_tiles_walls_pert_add_19_108" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_106", northSprite = "melos_tiles_walls_pert_add_19_107" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_32", northSprite = "melos_tiles_walls_pert_add_19_61" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_33", northSprite = "melos_tiles_walls_pert_add_19_60" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_34", northSprite = "melos_tiles_walls_pert_add_19_59" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_35", northSprite = "melos_tiles_walls_pert_add_19_58" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_36", northSprite = "melos_tiles_walls_pert_add_19_57" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_37", northSprite = "melos_tiles_walls_pert_add_19_56" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_31", northSprite = "melos_tiles_walls_pert_add_19_71" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_30", northSprite = "melos_tiles_walls_pert_add_19_70" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_39", northSprite = "melos_tiles_walls_pert_add_19_63" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_38", northSprite = "melos_tiles_walls_pert_add_19_62" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_47", northSprite = "melos_tiles_walls_pert_add_19_55" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_46", northSprite = "melos_tiles_walls_pert_add_19_54" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_40", northSprite = "melos_tiles_walls_pert_add_19_53" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_41", northSprite = "melos_tiles_walls_pert_add_19_52" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_42", northSprite = "melos_tiles_walls_pert_add_19_51" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_43", northSprite = "melos_tiles_walls_pert_add_19_50" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_44", northSprite = "melos_tiles_walls_pert_add_19_49" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_19_45", northSprite = "melos_tiles_walls_pert_add_19_48" }
        ),
 -- SMALLER WALL 1
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_72",
                northSprite = "melos_tiles_walls_pert_add_19_73",
                corner = "melos_tiles_walls_pert_add_19_74",
                pillar = "melos_tiles_walls_pert_add_19_75"
            }
        ),
 -- SMALLER WALL CORNER 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_19_74",
                pillar = "melos_tiles_walls_pert_add_19_75"
            }
        ),
 -- SMALLER WALL PILLAR 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_19_75"
            }
        ),
 -- SMALLER WALL 2
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_76",
                northSprite = "melos_tiles_walls_pert_add_19_77",
                corner = "melos_tiles_walls_pert_add_19_78",
                pillar = "melos_tiles_walls_pert_add_19_79"
            }
        ),
 -- SMALLER WALL CORNER 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_19_78",
                pillar = "melos_tiles_walls_pert_add_19_79"
            }
        ),
 -- SMALLER WALL PILLAR 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_19_79"
            }
        ),
 -- SMALLER WALL 3
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_80",
                northSprite = "melos_tiles_walls_pert_add_19_81",
                corner = "melos_tiles_walls_pert_add_19_82",
                pillar = "melos_tiles_walls_pert_add_19_83"
            }
        ),
 -- SMALLER WALL CORNER 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_19_82",
                pillar = "melos_tiles_walls_pert_add_19_83"
            }
        ),
 -- SMALLER WALL PILLAR 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_19_83"
            }
        ),
 -- SMALLER WALL 4
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_84",
                northSprite = "melos_tiles_walls_pert_add_19_85",
                corner = "melos_tiles_walls_pert_add_19_86",
                pillar = "melos_tiles_walls_pert_add_19_87"
            }
        ),
 -- SMALLER WALL CORNER 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_19_86",
                pillar = "melos_tiles_walls_pert_add_19_87"
            }
        ),
 -- SMALLER WALL PILLAR 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_19_87"
            }
        ),
 -- SMALLER WALL 5
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_19_88",
                northSprite = "melos_tiles_walls_pert_add_19_89",
                corner = "melos_tiles_walls_pert_add_19_90",
                pillar = "melos_tiles_walls_pert_add_19_91"
            }
        ),
 -- SMALLER WALL CORNER 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_19_90",
                pillar = "melos_tiles_walls_pert_add_19_91"
            }
        ),
 -- SMALLER WALL PILLAR 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.BlackSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_19_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_pertWalls19",
        "melos_tiles_walls_pert_add_19_0",
        pertWalls19
    )
-- PERT - Wood Pannel Fancy Brown
    local pertWalls18 = {
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
                sprite = "melos_tiles_walls_pert_add_18_0",
                northSprite = "melos_tiles_walls_pert_add_18_1",
                corner = "melos_tiles_walls_pert_add_18_2",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                corner = "melos_tiles_walls_pert_add_18_2",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_10",
                northSprite = "melos_tiles_walls_pert_add_18_11",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_12",
                northSprite = "melos_tiles_walls_pert_add_18_14",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_13",
                northSprite = "melos_tiles_walls_pert_add_18_15",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_64",
                northSprite = "melos_tiles_walls_pert_add_18_67",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_65",
                northSprite = "melos_tiles_walls_pert_add_18_68",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_66",
                northSprite = "melos_tiles_walls_pert_add_18_69",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_8",
                northSprite = "melos_tiles_walls_pert_add_18_9",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_4",
                northSprite = "melos_tiles_walls_pert_add_18_5",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_6",
                northSprite = "melos_tiles_walls_pert_add_18_7",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_22",
                northSprite = "melos_tiles_walls_pert_add_18_23",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_16",
                northSprite = "melos_tiles_walls_pert_add_18_19",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_17",
                northSprite = "melos_tiles_walls_pert_add_18_20",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_18",
                northSprite = "melos_tiles_walls_pert_add_18_21",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_24",
                northSprite = "melos_tiles_walls_pert_add_18_27",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_25",
                northSprite = "melos_tiles_walls_pert_add_18_28",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
                sprite = "melos_tiles_walls_pert_add_18_26",
                northSprite = "melos_tiles_walls_pert_add_18_29",
                pillar = "melos_tiles_walls_pert_add_18_3"
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
            { sprite = "melos_tiles_walls_pert_add_18_96", northSprite = "melos_tiles_walls_pert_add_18_101" }
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
            { sprite = "melos_tiles_walls_pert_add_18_97", northSprite = "melos_tiles_walls_pert_add_18_100" }
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
            { sprite = "melos_tiles_walls_pert_add_18_98", northSprite = "melos_tiles_walls_pert_add_18_99" }
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
            { sprite = "melos_tiles_walls_pert_add_18_112", northSprite = "melos_tiles_walls_pert_add_18_117" }
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
            { sprite = "melos_tiles_walls_pert_add_18_113", northSprite = "melos_tiles_walls_pert_add_18_116" }
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
            { sprite = "melos_tiles_walls_pert_add_18_114", northSprite = "melos_tiles_walls_pert_add_18_115" }
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
            { sprite = "melos_tiles_walls_pert_add_18_104", northSprite = "melos_tiles_walls_pert_add_18_109" }
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
            { sprite = "melos_tiles_walls_pert_add_18_105", northSprite = "melos_tiles_walls_pert_add_18_108" }
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
            { sprite = "melos_tiles_walls_pert_add_18_106", northSprite = "melos_tiles_walls_pert_add_18_107" }
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
            { sprite = "melos_tiles_walls_pert_add_18_32", northSprite = "melos_tiles_walls_pert_add_18_61" }
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
            { sprite = "melos_tiles_walls_pert_add_18_33", northSprite = "melos_tiles_walls_pert_add_18_60" }
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
            { sprite = "melos_tiles_walls_pert_add_18_34", northSprite = "melos_tiles_walls_pert_add_18_59" }
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
            { sprite = "melos_tiles_walls_pert_add_18_35", northSprite = "melos_tiles_walls_pert_add_18_58" }
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
            { sprite = "melos_tiles_walls_pert_add_18_36", northSprite = "melos_tiles_walls_pert_add_18_57" }
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
            { sprite = "melos_tiles_walls_pert_add_18_37", northSprite = "melos_tiles_walls_pert_add_18_56" }
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
            { sprite = "melos_tiles_walls_pert_add_18_31", northSprite = "melos_tiles_walls_pert_add_18_71" }
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
            { sprite = "melos_tiles_walls_pert_add_18_30", northSprite = "melos_tiles_walls_pert_add_18_70" }
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
            { sprite = "melos_tiles_walls_pert_add_18_39", northSprite = "melos_tiles_walls_pert_add_18_63" }
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
            { sprite = "melos_tiles_walls_pert_add_18_38", northSprite = "melos_tiles_walls_pert_add_18_62" }
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
            { sprite = "melos_tiles_walls_pert_add_18_47", northSprite = "melos_tiles_walls_pert_add_18_55" }
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
            { sprite = "melos_tiles_walls_pert_add_18_46", northSprite = "melos_tiles_walls_pert_add_18_54" }
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
            { sprite = "melos_tiles_walls_pert_add_18_40", northSprite = "melos_tiles_walls_pert_add_18_53" }
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
            { sprite = "melos_tiles_walls_pert_add_18_41", northSprite = "melos_tiles_walls_pert_add_18_52" }
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
            { sprite = "melos_tiles_walls_pert_add_18_42", northSprite = "melos_tiles_walls_pert_add_18_51" }
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
            { sprite = "melos_tiles_walls_pert_add_18_43", northSprite = "melos_tiles_walls_pert_add_18_50" }
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
            { sprite = "melos_tiles_walls_pert_add_18_44", northSprite = "melos_tiles_walls_pert_add_18_49" }
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
            { sprite = "melos_tiles_walls_pert_add_18_45", northSprite = "melos_tiles_walls_pert_add_18_48" }
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
                sprite = "melos_tiles_walls_pert_add_18_72",
                northSprite = "melos_tiles_walls_pert_add_18_73",
                corner = "melos_tiles_walls_pert_add_18_74",
                pillar = "melos_tiles_walls_pert_add_18_75"
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
                corner = "melos_tiles_walls_pert_add_18_74",
                pillar = "melos_tiles_walls_pert_add_18_75"
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
                sprite = "melos_tiles_walls_pert_add_18_75"
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
                sprite = "melos_tiles_walls_pert_add_18_76",
                northSprite = "melos_tiles_walls_pert_add_18_77",
                corner = "melos_tiles_walls_pert_add_18_78",
                pillar = "melos_tiles_walls_pert_add_18_79"
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
                corner = "melos_tiles_walls_pert_add_18_78",
                pillar = "melos_tiles_walls_pert_add_18_79"
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
                sprite = "melos_tiles_walls_pert_add_18_79"
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
                sprite = "melos_tiles_walls_pert_add_18_80",
                northSprite = "melos_tiles_walls_pert_add_18_81",
                corner = "melos_tiles_walls_pert_add_18_82",
                pillar = "melos_tiles_walls_pert_add_18_83"
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
                corner = "melos_tiles_walls_pert_add_18_82",
                pillar = "melos_tiles_walls_pert_add_18_83"
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
                sprite = "melos_tiles_walls_pert_add_18_83"
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
                sprite = "melos_tiles_walls_pert_add_18_84",
                northSprite = "melos_tiles_walls_pert_add_18_85",
                corner = "melos_tiles_walls_pert_add_18_86",
                pillar = "melos_tiles_walls_pert_add_18_87"
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
                corner = "melos_tiles_walls_pert_add_18_86",
                pillar = "melos_tiles_walls_pert_add_18_87"
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
                sprite = "melos_tiles_walls_pert_add_18_87"
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
                sprite = "melos_tiles_walls_pert_add_18_88",
                northSprite = "melos_tiles_walls_pert_add_18_89",
                corner = "melos_tiles_walls_pert_add_18_90",
                pillar = "melos_tiles_walls_pert_add_18_91"
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
                corner = "melos_tiles_walls_pert_add_18_90",
                pillar = "melos_tiles_walls_pert_add_18_91"
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
                sprite = "melos_tiles_walls_pert_add_18_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_pertWalls18",
        "melos_tiles_walls_pert_add_18_0",
        pertWalls18
    )
-- PERT - Wood Pannel Fancy White
    local pertWalls20 = {
 -- WALL NORMAL
        BuildingMenu.createObject(
            "Tooltip_WallWall_Name",
            "Tooltip_WallWall_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_0",
                northSprite = "melos_tiles_walls_pert_add_20_1",
                corner = "melos_tiles_walls_pert_add_20_2",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
 -- WALL CORNER
        BuildingMenu.createObject(
            "Tooltip_WallCorner_Name",
            "Tooltip_WallCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_20_2",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
 -- WALL PILLAR
        BuildingMenu.createObject(
            "Tooltip_WallPillar_Name",
            "Tooltip_WallPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_20_3"
            }
        ),
 -- DOOR FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildDoorFrame,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_10",
                northSprite = "melos_tiles_walls_pert_add_20_11",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_12",
                northSprite = "melos_tiles_walls_pert_add_20_14",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_13",
                northSprite = "melos_tiles_walls_pert_add_20_15",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_64",
                northSprite = "melos_tiles_walls_pert_add_20_67",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_65",
                northSprite = "melos_tiles_walls_pert_add_20_68",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallDoor_Name",
            "Tooltip_WallDoor_Desc",
            BuildingMenu.onBuildSpecialObject,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                modData = { wallType = "doorframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_66",
                northSprite = "melos_tiles_walls_pert_add_20_69",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
 -- WINDOW FRAMES
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_8",
                northSprite = "melos_tiles_walls_pert_add_20_9",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_4",
                northSprite = "melos_tiles_walls_pert_add_20_5",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_6",
                northSprite = "melos_tiles_walls_pert_add_20_7",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_22",
                northSprite = "melos_tiles_walls_pert_add_20_23",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_16",
                northSprite = "melos_tiles_walls_pert_add_20_19",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_17",
                northSprite = "melos_tiles_walls_pert_add_20_20",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_18",
                northSprite = "melos_tiles_walls_pert_add_20_21",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_24",
                northSprite = "melos_tiles_walls_pert_add_20_27",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_25",
                northSprite = "melos_tiles_walls_pert_add_20_28",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallWindow_Name",
            "Tooltip_WallWindow_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canBarricade = true,
                hoppable = true,
                modData = { wallType = "windowsframe" }
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_26",
                northSprite = "melos_tiles_walls_pert_add_20_29",
                pillar = "melos_tiles_walls_pert_add_20_3"
            }
        ),
 -- ROOF WALLS
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_96", northSprite = "melos_tiles_walls_pert_add_20_101" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_97", northSprite = "melos_tiles_walls_pert_add_20_100" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_98", northSprite = "melos_tiles_walls_pert_add_20_99" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_112", northSprite = "melos_tiles_walls_pert_add_20_117" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_113", northSprite = "melos_tiles_walls_pert_add_20_116" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_114", northSprite = "melos_tiles_walls_pert_add_20_115" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_104", northSprite = "melos_tiles_walls_pert_add_20_109" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_105", northSprite = "melos_tiles_walls_pert_add_20_108" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_106", northSprite = "melos_tiles_walls_pert_add_20_107" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_32", northSprite = "melos_tiles_walls_pert_add_20_61" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_33", northSprite = "melos_tiles_walls_pert_add_20_60" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_34", northSprite = "melos_tiles_walls_pert_add_20_59" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_35", northSprite = "melos_tiles_walls_pert_add_20_58" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_36", northSprite = "melos_tiles_walls_pert_add_20_57" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_37", northSprite = "melos_tiles_walls_pert_add_20_56" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_31", northSprite = "melos_tiles_walls_pert_add_20_71" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_30", northSprite = "melos_tiles_walls_pert_add_20_70" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_39", northSprite = "melos_tiles_walls_pert_add_20_63" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_38", northSprite = "melos_tiles_walls_pert_add_20_62" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_47", northSprite = "melos_tiles_walls_pert_add_20_55" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_46", northSprite = "melos_tiles_walls_pert_add_20_54" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_40", northSprite = "melos_tiles_walls_pert_add_20_53" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_41", northSprite = "melos_tiles_walls_pert_add_20_52" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_42", northSprite = "melos_tiles_walls_pert_add_20_51" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_43", northSprite = "melos_tiles_walls_pert_add_20_50" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_44", northSprite = "melos_tiles_walls_pert_add_20_49" }
        ),
        BuildingMenu.createObject(
            "Tooltip_WallRoofSlope_Name",
            "Tooltip_WallRoofSlope_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            { sprite = "melos_tiles_walls_pert_add_20_45", northSprite = "melos_tiles_walls_pert_add_20_48" }
        ),
 -- SMALLER WALL 1
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_72",
                northSprite = "melos_tiles_walls_pert_add_20_73",
                corner = "melos_tiles_walls_pert_add_20_74",
                pillar = "melos_tiles_walls_pert_add_20_75"
            }
        ),
 -- SMALLER WALL CORNER 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_20_74",
                pillar = "melos_tiles_walls_pert_add_20_75"
            }
        ),
 -- SMALLER WALL PILLAR 1
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_20_75"
            }
        ),
 -- SMALLER WALL 2
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_76",
                northSprite = "melos_tiles_walls_pert_add_20_77",
                corner = "melos_tiles_walls_pert_add_20_78",
                pillar = "melos_tiles_walls_pert_add_20_79"
            }
        ),
 -- SMALLER WALL CORNER 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_20_78",
                pillar = "melos_tiles_walls_pert_add_20_79"
            }
        ),
 -- SMALLER WALL PILLAR 2
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_20_79"
            }
        ),
 -- SMALLER WALL 3
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_80",
                northSprite = "melos_tiles_walls_pert_add_20_81",
                corner = "melos_tiles_walls_pert_add_20_82",
                pillar = "melos_tiles_walls_pert_add_20_83"
            }
        ),
 -- SMALLER WALL CORNER 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_20_82",
                pillar = "melos_tiles_walls_pert_add_20_83"
            }
        ),
 -- SMALLER WALL PILLAR 3
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_20_83"
            }
        ),
 -- SMALLER WALL 4
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_84",
                northSprite = "melos_tiles_walls_pert_add_20_85",
                corner = "melos_tiles_walls_pert_add_20_86",
                pillar = "melos_tiles_walls_pert_add_20_87"
            }
        ),
 -- SMALLER WALL CORNER 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_20_86",
                pillar = "melos_tiles_walls_pert_add_20_87"
            }
        ),
 -- SMALLER WALL PILLAR 4
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_20_87"
            }
        ),
 -- SMALLER WALL 5
        BuildingMenu.createObject(
            "Tooltip_WallSmaller_Name",
            "Tooltip_WallSmaller_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureSmall",
                isThumpable = true,
                hoppable = true,
                blockAllTheSquare = false
            },
            {
                sprite = "melos_tiles_walls_pert_add_20_88",
                northSprite = "melos_tiles_walls_pert_add_20_89",
                corner = "melos_tiles_walls_pert_add_20_90",
                pillar = "melos_tiles_walls_pert_add_20_91"
            }
        ),
 -- SMALLER WALL CORNER 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerCorner_Name",
            "Tooltip_WallSmallerCorner_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteBigWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                isThumpable = true,
                canScrap = false,
                canBarricade = false,
                modData = { wallType = "wall" }
            },
            {
                corner = "melos_tiles_walls_pert_add_20_90",
                pillar = "melos_tiles_walls_pert_add_20_91"
            }
        ),
 -- SMALLER WALL PILLAR 5
        BuildingMenu.createObject(
            "Tooltip_WallSmallerPillar_Name",
            "Tooltip_WallSmallerPillar_Desc",
            BuildingMenu.onBuildWall,
            BuildingMenu.WhiteSmallWoodWallRecipe,
            true,
            {
                completionSound = "BuildWoodenStructureLarge",
                canPassThrough = true,
                canBarricade = false,
                isCorner = true,
                modData = { wallType = "pillar" }
            },
            { 
                sprite = "melos_tiles_walls_pert_add_20_91"
            }
        ),
    }
    BuildingMenu.addObjectsToCategories(
        "Deadline",
        "IGUI_BuildingMenuCat_DeadlineWalls",
        nil,
        "IGUI_DeadlineWalls_pertWalls20",
        "melos_tiles_walls_pert_add_20_0",
        pertWalls20
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
                    BuildingMenu.onBuildDoubleTileFurniture,
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
        addDeadlineWallsToMenu()
    end
    if SandboxVars.BuildingMenu.DeadlineTablesSubCategory then
        addDeadlineTablesToMenu()
    end
    if SandboxVars.BuildingMenu.DeadlineBookshelvesSubCategory then
        addDeadlineBookshelvesToMenu()
    end
end
Events.OnInitializeBuildingMenuObjects.Add(addCategoriesToBuildingMenu)