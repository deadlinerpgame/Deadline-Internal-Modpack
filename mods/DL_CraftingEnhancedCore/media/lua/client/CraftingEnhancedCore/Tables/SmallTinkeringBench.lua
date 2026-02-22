if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["SmallTinkeringBench"] = {
    nameID = "SmallTinkeringBench",
    displayName = getText("SmallTinkeringBench"),
    tooltipTitle = getText("SmallTinkeringBench"),
    tooltipDescription = getText(""),
    tooltipTexture = "edit_ddd_RUS_location_business_machinery_02_6
    icon = "edit_ddd_RUS_location_business_machinery_02_6
    size = 1,
    anim = "VehicleTrailer",
    craftingSound = "RepairWithWrench",
    sprites = {
        north = {
            "edit_ddd_RUS_location_business_machinery_02_7"
        },
        south = {
            "edit_ddd_RUS_location_business_machinery_02_7"
        },
        west = {
            "edit_ddd_RUS_location_business_machinery_02_6"
        },
        east = {
            "edit_ddd_RUS_location_business_machinery_02_6"
        }
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.SmallTinkeringBench",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}