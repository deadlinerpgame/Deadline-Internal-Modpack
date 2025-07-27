if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["ButcheringHook"] = {
    nameID = "Butchering Hook",
    displayName = getText("Butchering Hook"),
    tooltipTitle = getText("Butchering Hook"),
    tooltipDescription = getText(""),
    tooltipTexture = "aerx_tools_15",
    icon = "aerx_tools_15",
    size = 1,
    anim = "VehicleTrailer",
    craftingSound = "RepairWithWrench",
    sprites = {
        north = {
            "aerx_tools_15"
        },
        south = {
            "aerx_tools_15"
        },
        west = {
            "aerx_tools_15"
        },
        east = {
            "aerx_tools_15"
        }
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.ButcheringHookConstructionSet",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}
