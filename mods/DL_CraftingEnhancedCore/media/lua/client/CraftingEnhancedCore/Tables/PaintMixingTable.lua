if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["PaintMixingTable"] = {
    nameID = "PaintMixingTable",
    displayName = getText("ContextMenu_PaintMixingTable"),
    tooltipTitle = getText("ContextMenu_PaintMixingTable"),
    tooltipDescription = getText("Tooltip_PaintMixingTable_Description"),
    tooltipTexture = "core_workbenches_1",
    icon = "",
    size = 2,
    anim = "VehicleTrailer",
    craftingSound = "RepairWithWrench",
    sprites = {
        north = {
            "core_workbenches_2", "core_workbenches_3"
        },
        south = {
            "core_workbenches_6", "core_workbenches_7"
        },
        west = {
            "core_workbenches_0", "core_workbenches_1"
        },
        east = {
            "core_workbenches_4", "core_workbenches_5"
        }
    },
    requiredSkills = {
        Woodwork = 6,
        
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.PaintMixingConstructionSet",
            amount = 1,
        }
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
