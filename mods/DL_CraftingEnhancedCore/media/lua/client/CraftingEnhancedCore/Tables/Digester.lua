if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

DLCraftingEnhancedCore = getModInstance()

DLCraftingEnhancedCore.tables["Digester"] = {
    nameID = "Digester",
    displayName = getText("ContextMenu_Digester"),
    tooltipTitle = getText("ContextMenu_Digester"),
    tooltipDescription = getText("Tooltip_Digester_Description"),
    tooltipTexture = "dl_workbenches_0",
    icon = "",
    size = 1,
    anim = "VehicleTrailer",
    craftingSound = "RepairWithWrench",
    sprites = {
        north = {
            "dl_workbenches_1"
        },
        south = {
            "dl_workbenches_0"
        },
        west = {
            "dl_workbenches_3"
        },
        east = {
            "dl_workbenches_2"
        }
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.DigesterConstructionSet",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}