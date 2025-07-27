if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["KilnSimple"] = {
    nameID = "Simple Kiln",
    displayName = getText("Simple Kiln"),
    tooltipTitle = getText("Simple Kiln"),
    tooltipDescription = getText(""),
    tooltipTexture = "aerx_tools_0",
    icon = "aerx_tools_0",
    size = 1,
    anim = "VehicleTrailer",
    craftingSound = "RepairWithWrench",
    sprites = {
        north = {
            "aerx_tools_0"
        },
        south = {
            "aerx_tools_0"
        },
        west = {
            "aerx_tools_2"
        },
        east = {
            "aerx_tools_2"
        }
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.KilnSimpleConstructionSet",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}
