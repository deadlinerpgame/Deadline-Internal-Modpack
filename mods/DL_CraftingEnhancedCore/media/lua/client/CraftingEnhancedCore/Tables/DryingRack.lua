if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["DryingRack"] = {
    nameID = "Drying Rack",
    displayName = getText("Drying Rack"),
    tooltipTitle = getText("Drying Rack"),
    tooltipDescription = getText(""),
    tooltipTexture = "aerx_tools_82",
    icon = "aerx_tools_82",
    size = 2,
    anim = "Build",
    sprites = {
        north = {
            "aerx_tools_84", "aerx_tools_85"
        },
        south = {
            "aerx_tools_84", "aerx_tools_85"
        },
        west = {
            "aerx_tools_82", "aerx_tools_83"
        },
        east = {
            "aerx_tools_82", "aerx_tools_83"
        }
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.DryingRackConstructionSet",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}
