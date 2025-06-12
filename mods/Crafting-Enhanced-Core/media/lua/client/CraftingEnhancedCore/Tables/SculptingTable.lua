if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["SculptingTable"] = {
    nameID = "Sculpting Table",
    displayName = getText("Sculpting Table"),
    tooltipTitle = getText("Sculpting Table"),
    tooltipDescription = getText(""),
    tooltipTexture = "aerx_tools_88",
    icon = "aerx_tools_88",
    size = 1,
    anim = "VehicleTrailer",
    craftingSound = "RepairWithWrench",
    sprites = {
        north = {
            "aerx_tools_88"
        },
        south = {
            "aerx_tools_88"
        },
        west = {
            "aerx_tools_89"
        },
        east = {
            "aerx_tools_89"
        }
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.SculptingTableConstructionSet",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}
