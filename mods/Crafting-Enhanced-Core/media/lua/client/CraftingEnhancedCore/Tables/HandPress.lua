if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["HandPress"] = {
    nameID = "Hand Press",
    displayName = getText("Hand Press"),
    tooltipTitle = getText("Hand Press"),
    tooltipDescription = getText(""),
    tooltipTexture = "aerx_tools_86",
    icon = "aerx_tools_86",
    size = 1,
    anim = "VehicleTrailer",
    craftingSound = "RepairWithWrench",
    sprites = {
        north = {
            "aerx_tools_86"
        },
        south = {
            "aerx_tools_86"
        },
        west = {
            "aerx_tools_87"
        },
        east = {
            "aerx_tools_87"
        }
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.HandPressConstructionSet",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}
