if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["CementMixer"] = {
    nameID = "Cement Mixer",
    displayName = getText("Cement Mixer"),
    tooltipTitle = getText("Cement Mixer"),
    tooltipDescription = getText(""),
    tooltipTexture = "construction_01_6",
    icon = "construction_01_6",
    size = 1,
    anim = "VehicleTrailer",
    craftingSound = "RepairWithWrench",
    sprites = {
        north = {
            "construction_01_6"
        },
        south = {
            "construction_01_6"
        },
        west = {
            "construction_01_7"
        },
        east = {
            "construction_01_7"
        }
    },
    requireTool = "Hammer",
    recipe = {
        {
            type = "Base.CementMixer",
            amount = 1,
        }
    },
    completionSound = "BuildWoodenStructureLarge",
    maxTime = 200,
}
