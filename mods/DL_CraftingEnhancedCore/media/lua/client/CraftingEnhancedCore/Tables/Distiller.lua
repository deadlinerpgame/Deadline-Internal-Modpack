if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["Distiller"] = {
    nameID = "Distiller",
    displayName = getText("ContextMenu_Distiller"),
    tooltipTitle = getText("ContextMenu_Distiller"),
    tooltipDescription = getText("Tooltip_Distiller_Description"),
    tooltipTexture = "dl_workbenches_15",
    icon = "",
    size = 2,
    anim = "VehicleTrailer",
    craftingSound = "RepairWithWrench",
    sprites = {
        north = {
            "dl_workbenches_18", "dl_workbenches_19"
        },
        south = {
            "dl_workbenches_16", "dl_workbenches_17"
        },
        west = {
            "dl_workbenches_14", "dl_workbenches_15"
        },
        east = {
            "dl_workbenches_12", "dl_workbenches_13"
        }
    },
    requireTool = "Screwdriver",
    recipe = {
        {
            type = "Base.DistillerConstructionSet",
            amount = 1,
        },
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
    container = {
        type = "crate",
        capacity = 5,
        positions = {
            west = 0,
            east = 0,
            north = 0,
            south = 0,
        }
    }
}
