if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["TailoringWorkbench"] = {
    nameID = "TailoringWorkbench",
    displayName = "Tailoring Table",
    tooltipTitle = "Tailoring Table",
    tooltipDescription = "Tailoring Table",
    tooltipTexture = "Table_tiles_0",
    icon = "Table_tiles_0",
    size = 1,
    anim = "VehicleTrailer",
    craftingSound = "RepairWithWrench",
    sprites = {
        north = {
            "Table_tiles_8"
        },
        south = {
            "Table_tiles_1"
        },
        west = {
            "Table_tiles_9"
        },
        east = {
            "Table_tiles_0"
        }
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.TailorTableConstructionSet",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}