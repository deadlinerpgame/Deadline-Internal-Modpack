if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["FurnaceSimple"] = {
    nameID = "Simple Furnace",
    displayName = getText("Simple Furnace"),
    tooltipTitle = getText("Simple Furnace"),
    tooltipDescription = getText(""),
    tooltipTexture = "aerx_tools_37",
    icon = "aerx_tools_37",
    size = 1,
    anim = "VehicleTrailer",
    craftingSound = "RepairWithWrench",
    sprites = {
        north = {
            "aerx_tools_37"
        },
        south = {
            "aerx_tools_37"
        },
        west = {
            "aerx_tools_35"
        },
        east = {
            "aerx_tools_35"
        }
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.FurnaceSimpleConstructionSet",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}
