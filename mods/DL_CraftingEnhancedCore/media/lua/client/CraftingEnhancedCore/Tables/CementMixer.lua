if not getModInstance then
    require('CraftingEnhancedCore/TableBuildMenu')
end

CraftingEnhancedCore = getModInstance()

CraftingEnhancedCore.tables["CementMixer"] = {
    nameID = "Cement Mixer",
    displayName = getText("Cement Mixer"),
    tooltipTitle = getText("Cement Mixer"),
    tooltipDescription = getText(""),
    tooltipTexture = "contruction_01_6",
    icon = "contruction_01_6",
    size = 1,
    anim = "VehicleTrailer",
    craftingSound = "RepairWithWrench",
    sprites = {
        north = {
            "contruction_01_6"
        },
        south = {
            "contruction_01_6"
        },
        west = {
            "contruction_01_7"
        },
        east = {
            "contruction_01_7"
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
