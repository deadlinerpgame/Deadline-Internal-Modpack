if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["BigMetalBench"] = {
    nameID = "BigMetalBench",
    displayName = getText("ContextMenu_BigMetalBench"),
    tooltipTitle = getText("ContextMenu_BigMetalBench"),
    tooltipDescription = getText("Tooltip_BigMetalBench_Description"),
    tooltipTexture = "industry_tk_02_56
    icon = "",
    size = 2,
    anim = "VehicleTrailer",
    craftingSound = "RepairWithWrench",
    sprites = {
        north = {
            "industry_tk_02_56", "industry_tk_02_57"
        },
        south = {
            "industry_tk_02_68", "industry_tk_02_69"
        },
        west = {
            "industry_tk_02_58", "industry_tk_02_59"
        },
        east = {
            "industry_tk_02_70", "industry_tk_02_71"
        }
    },
    requiredSkills = {
        Woodwork = 6,
        
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.BigMetalBench",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}
