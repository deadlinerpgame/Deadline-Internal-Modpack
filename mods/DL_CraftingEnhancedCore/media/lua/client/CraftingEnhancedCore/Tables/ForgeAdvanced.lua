if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["ForgeAdvanced"] = {
    nameID = "Advanced Forge",
    displayName = getText("Advanced Forge"),
    tooltipTitle = getText("Advanced Forge"),
    tooltipDescription = getText(""),
    tooltipTexture = "aerx_tools_24",
    icon = "aerx_tools_24",
    size = 5,
    anim = "Build",
    sprites = {
        north = {
            "aerx_tools_26", "aerx_tools_27", "aerx_tools_33", "aerx_tools_20", "aerx_tools_34"
        },
        south = {
            "aerx_tools_26", "aerx_tools_27", "aerx_tools_33", "aerx_tools_20", "aerx_tools_34"
        },
        west = {
            "aerx_tools_26", "aerx_tools_27", "aerx_tools_33", "aerx_tools_20", "aerx_tools_34"
        },
        east = {
            "aerx_tools_26", "aerx_tools_27", "aerx_tools_33", "aerx_tools_20", "aerx_tools_34"
        }
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.ForgeAdvancedConstructionSet",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}
