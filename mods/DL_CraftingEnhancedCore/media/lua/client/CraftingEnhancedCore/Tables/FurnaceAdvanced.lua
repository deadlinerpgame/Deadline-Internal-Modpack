if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["FurnaceAdvanced"] = {
    nameID = "Advanced Furnace",
    displayName = getText("Advanced Furnace"),
    tooltipTitle = getText("Advanced Furnace"),
    tooltipDescription = getText(""),
    tooltipTexture = "aerx_tools_42",
    icon = "aerx_tools_42",
    size = 4,
    anim = "Build",
    sprites = {
        north = {
            "aerx_tools_41", "aerx_tools_40", "aerx_tools_42", "aerx_tools_43"
        },
        south = {
            "aerx_tools_41", "aerx_tools_40", "aerx_tools_42", "aerx_tools_43"
        },
        west = {
            "aerx_tools_41", "aerx_tools_40", "aerx_tools_42", "aerx_tools_43"
        },
        east = {
            "aerx_tools_41", "aerx_tools_40", "aerx_tools_42", "aerx_tools_43"
        }
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.FurnaceAdvancedConstructionSet",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}
