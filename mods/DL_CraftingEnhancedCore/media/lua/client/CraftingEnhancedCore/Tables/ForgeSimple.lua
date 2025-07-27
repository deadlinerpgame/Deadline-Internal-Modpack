if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["ForgeSimple"] = {
    nameID = "Simple Forge",
    displayName = getText("Simple Forge"),
    tooltipTitle = getText("Simple Forge"),
    tooltipDescription = getText(""),
    tooltipTexture = "aerx_tools_18",
    icon = "aerx_tools_18",
    size = 3,
    anim = "Build",
    sprites = {
        north = {
            "aerx_tools_16", "aerx_tools_21", "aerx_tools_22"
        },
        south = {
            "aerx_tools_16", "aerx_tools_20", "aerx_tools_22"
        },
        west = {
            "aerx_tools_18", "aerx_tools_20", "aerx_tools_22"
        },
        east = {
            "aerx_tools_18", "aerx_tools_20", "aerx_tools_22"
        }
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.ForgeSimpleConstructionSet",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}
