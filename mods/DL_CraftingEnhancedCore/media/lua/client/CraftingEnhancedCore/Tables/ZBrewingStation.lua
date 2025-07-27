if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

DLCraftingEnhancedCore = getModInstance()

DLCraftingEnhancedCore.tables["BrewingStation"] = {
    nameID = "BrewingStation",
    displayName = getText("ContextMenu_BrewingStation"),
    tooltipTitle = getText("ContextMenu_BrewingStation"),
    tooltipDescription = getText("Tooltip_BrewingStation_Description"),
    tooltipTexture = "dl_workbenches_20",
    icon = "",
    size = 1,
    anim = "VehicleTrailer",
    craftingSound = "RepairWithWrench",
    sprites = {
        north = {
            "dl_workbenches_20"
        },
        south = {
            "dl_workbenches_20"
        },
        west = {
            "dl_workbenches_21"
        },
        east = {
            "dl_workbenches_21"
        }
    },
    requiredSkills = {
        Woodwork = 4,

        
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.BrewingStationConstructionSet",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200

}
