if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["KilnAdvanced"] = {
    nameID = "Advanced Kiln",
    displayName = getText("Advanced Kiln"),
    tooltipTitle = getText("Advanced Kiln"),
    tooltipDescription = getText(""),
    tooltipTexture = "aerx_tools_4",
    icon = "aerx_tools_4",
    size = 2,
    anim = "Build",
    sprites = {
        north = {
            "aerx_tools_4", "aerx_tools_5"
        },
        south = {
            "aerx_tools_4", "aerx_tools_5"
        },
        west = {
            "aerx_tools_8", "aerx_tools_9"
        },
        east = {
            "aerx_tools_8", "aerx_tools_9"
        }
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.KilnAdvancedConstructionSet",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}
