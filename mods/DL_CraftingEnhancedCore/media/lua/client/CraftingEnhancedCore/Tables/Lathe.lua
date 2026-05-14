if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["Lathe"] = {
    nameID = "Lathe",
    displayName = getText("Lathe"),
    tooltipTitle = getText("Lathe"),
    tooltipTexture = "industry_tk_02_56",
    icon = "industry_tk_02_56",
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
            type = "Base.Lathe",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}
